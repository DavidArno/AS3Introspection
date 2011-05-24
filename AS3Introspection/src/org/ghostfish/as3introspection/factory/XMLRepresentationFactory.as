/*
Copyright (c) 2011, David Arno

Permission is hereby granted, free of charge, to any person obtaining a copy of 
this software and associated documentation files (the "Software"), to deal in 
the Software without restriction, including without limitation the rights to 
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
of the Software, and to permit persons to whom the Software is furnished to 
do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in 
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN 
THE SOFTWARE.
*/
package org.ghostfish.as3introspection.factory
{
	import org.as3commons.bytecode.abc.ClassTrait;
	import org.as3commons.bytecode.abc.InstanceInfo;
	import org.as3commons.bytecode.abc.MethodTrait;
	import org.as3commons.bytecode.abc.SlotOrConstantTrait;
	import org.as3commons.bytecode.abc.TraitInfo;
	import org.as3commons.bytecode.abc.enum.NamespaceKind;
	import org.as3commons.bytecode.abc.enum.TraitKind;
	import org.ghostfish.as3introspection.abc.RepresentationHierarchy;
	import org.ghostfish.as3introspection.representations.AbstractRepresentation;
	import org.ghostfish.as3introspection.representations.ClassRepresentation;
	import org.ghostfish.as3introspection.representations.Constant;
	import org.ghostfish.as3introspection.representations.Getter;
	import org.ghostfish.as3introspection.representations.Interface;
	import org.ghostfish.as3introspection.representations.Method;
	import org.ghostfish.as3introspection.representations.NamespaceRepresentation;
	import org.ghostfish.as3introspection.representations.Setter;
	import org.ghostfish.as3introspection.representations.Variable;
	
	/**
	 * Implementation of IRepresentationFactory for creating an XML representation of
	 * a set of traits.
	 */
	public class XMLRepresentationFactory implements IRepresentationFactory
	{
		/**
		 * @inheritDoc 
		 */
		public function createPackagedRepresentation(trait:TraitInfo, 
													 instanceInfo:Array, 
													 packageName:String):RepresentationHierarchy
		{
			return createRepresentation(trait, instanceInfo, packageName, false);
		}
		
		/**
		 * 
		 * @param trait			The trait for which a representation is to be created.
		 * @param instanceInfo	The DoABC InstanceInfo array for the trait's DoABC tag.
		 * @param packageName	The package to which the trait belongs. Will be null if
		 * 						the trait is a member of a class or interface.
		 * @param interfaceMode True if we are creating representations of the child
		 * 						traits of an interface; false otherwise.
		 * 
		 * @return				The representation in the form of a hierarchy.
		 */
		protected function createRepresentation(trait:TraitInfo, 
												instanceInfo:Array, 
												packageName:String,
												interfaceMode:Boolean):RepresentationHierarchy
		{
			if (trait is ClassTrait)
			{
				return classRepresentation(trait as ClassTrait, instanceInfo, packageName);
			}
			else if (trait is SlotOrConstantTrait)
			{
				return variableRepresentation(trait as SlotOrConstantTrait, packageName);
			}
			else
			{
				return functionRepresentation(trait as MethodTrait, packageName, interfaceMode);
			}
		}
		
		/**
		 * Creates a method, setter or getter representation from the supplied trait.
		 *  
		 * @param trait			The trait to be represented.
		 * @param packageName	The trait's package name (null if none).
		 * @param interfaceMode True if we are creating representations of the child
		 * 						traits of an interface; false otherwise.
		 * 
		 * @return				The representation (as a hierarchy)
		 */
		protected function functionRepresentation(trait:MethodTrait, 
												  packageName:String,
												  interfaceMode:Boolean):RepresentationHierarchy
		{
			var type:Class = trait.isGetter ? Getter : trait.isSetter ? Setter : Method;
			var hierarchy:RepresentationHierarchy = 
				createMethodRepresentation(trait, packageName, type, interfaceMode);

			return hierarchy;
		}
		
		/**
		 * Creates a constant or variable representation from the supplied trait.
		 *  
		 * @param trait			The trait to be represented.
		 * @param packageName	The trait's package name (null if none).
		 * 
		 * @return				The representation (as a hierarchy)
		 */
		protected function variableRepresentation(trait:SlotOrConstantTrait, 
												  packageName:String):RepresentationHierarchy
		{
			var type:Class = 
				trait.vkind != null && trait.vkind.description == "namespace" ? NamespaceRepresentation :
				trait.traitKind == TraitKind.CONST ? Constant : Variable;
			var hierarchy:RepresentationHierarchy = 
				createBasicRepresentation(trait, packageName, type);
			
			return hierarchy;
		}
		
		/**
		 * Creates an interface or class representation from the supplied trait.
		 *  
		 * @param trait			The trait to be represented.
		 * @param instanceInfo	The array of InstanceInfos associated with this
		 * 						trait.
		 * @param packageName	The trait's package name (null if none).
		 * 
		 * @return				The representation (as a hierarchy), including all static
		 * 						and instance member representations
		 */
		protected function classRepresentation(trait:ClassTrait, 
											   instanceInfo:Array, 
											   packageName:String):RepresentationHierarchy
		{
			var isInterface:Boolean = instanceInfo[trait.classIndex].isInterface;
			var type:Class = isInterface ? Interface : ClassRepresentation;
			var hierarchy:RepresentationHierarchy = 
				createClassStyleRepresentation(trait, instanceInfo[trait.classIndex], packageName, type);
			
			hierarchy.childen = new <AbstractRepresentation>[];
			populateChildren(hierarchy, trait, instanceInfo[trait.classIndex].classInfo.traits, new <String>[], isInterface);
			
			var localNamespaces:Vector.<String> = 
				generateLocalNamespaces(instanceInfo[trait.classIndex].classInfo.traits);

			populateChildren(hierarchy, trait, instanceInfo[trait.classIndex].traits, localNamespaces, isInterface);
			
			return hierarchy;
		}
		
		/**
		 * Populates the children Vector of a hierarchy with representations of the
		 * supplied child traits.
		 * 
		 * @param hierarchy			The hierarchy to be populated with the child represenations.
		 * @param trait				The parent trait. 
		 * @param children			An array of traits.
		 * @param localNamespaces	A list of the names of any local namespaces that the parent
		 * 							trait defines (required to determine if custom namespace
		 * 							children are publicly visible.)
		 * @param interfaceMode		True if the parent trait is an interface. False if a class.
		 */
		protected function populateChildren(hierarchy:RepresentationHierarchy,
											trait:TraitInfo,
											children:Array,
											localNamespaces:Vector.<String>,
											interfaceMode:Boolean):void
		{
			if (hierarchy.childen == null)
			{
				hierarchy.childen = new Vector.<AbstractRepresentation>();
			}
			
			for each (var child:TraitInfo in children)
			{
				if (accessible(child, trait.traitMultiname.fullName, localNamespaces))
				{
					var tmp:RepresentationHierarchy = 
						createRepresentation(child, null, null, interfaceMode);
					hierarchy.childen.push(tmp.currentRepresentation);
				}
			}
		}
		
		/**
		 * Creates a representation heierarchy and sets its currentRepresentation to
		 * a new instance of "type".
		 * 
		 * @param trait			The trait to be represented. 
		 * @param packageName	The trait's package name (null if none).
		 * @param type			The AbstractRepresentation child type to be used to
		 * 						create the currentRepresentation. Must be a type that
		 * 						takes two parameters for its constructor: trait and
		 * 						packageName.
		 * 
		 * @return 				The representation heierarchy
		 */
		protected function createBasicRepresentation(trait:TraitInfo, 
													 packageName:String,
													 type:Class):RepresentationHierarchy
		{
			var hierarchy:RepresentationHierarchy = new RepresentationHierarchy();
			hierarchy.currentRepresentation = new type(trait, packageName);
			
			return hierarchy;
		}
		
		/**
		 * Creates a representation heierarchy and sets its currentRepresentation to
		 * a new instance of "type".
		 * 
		 * @param trait			The trait to be represented. 
		 * @param packageName	The trait's package name (null if none).
		 * @param type			The AbstractRepresentation child type to be used to
		 * 						create the currentRepresentation. Must be a type that
		 * 						takes two parameters for its constructor: trait and
		 * 						packageName.
		 * @param interfaceMode	True if the parent trait is an interface. False if a class.
		 * 
		 * @return 				The representation heierarchy
		 */
		protected function createMethodRepresentation(trait:TraitInfo, 
													  packageName:String,
													  type:Class,
													  interfaceMode:Boolean):RepresentationHierarchy
		{
			var hierarchy:RepresentationHierarchy = new RepresentationHierarchy();
			hierarchy.currentRepresentation = new type(trait, packageName, interfaceMode);
			
			return hierarchy;
		}
		
		/**
		 * Creates a representation heierarchy and sets its currentRepresentation to
		 * a new instance of "type".
		 * 
		 * @param trait			The trait to be represented. 
		 * @param packageName	The trait's package name (null if none).
		 * @param type			The AbstractRepresentation child type to be used to
		 * 						create the currentRepresentation. Must be a type that
		 * 						takes three parameters for its constructor: trait,
		 * 						instanceInfo and packageName.
		 * 
		 * @return 				The representation heierarchy
		 */
		protected function createClassStyleRepresentation(trait:TraitInfo,
														  instanceInfo:InstanceInfo,
														  packageName:String,
														  type:Class):RepresentationHierarchy
		{
			var hierarchy:RepresentationHierarchy = new RepresentationHierarchy();
			hierarchy.currentRepresentation = new type(trait, instanceInfo, packageName);
			
			return hierarchy;
		}
		
		/**
		 * Determines whether the child trait is publicly accessible.
		 * 
		 * <p>A trait is deemed to be publicly accessible if it is public,
		 * protected, or has a public or protected custom namespace.</p>
		 *  
		 * <p>Note to self: this method is overly long and needs refactoring</p>
		 * 
		 * @param child				The trait to be analysed.
		 * @param classPath			The package of the parent class. Internal
		 * 							traits have this value as their namespace.
		 * @param localNamespaces	A list of local (public or protected only)
		 * 							namespaces defined by the class.
		 * 
		 * @return					True if the trait is accessible.
		 */
		protected function accessible(child:TraitInfo, classPath:String, localNamespaces:Vector.<String>):Boolean
		{
			var result:Boolean = false;
			var className:String = "";
			var packageName:String = "";
			var dotIndex:int = classPath.lastIndexOf(".");
			
			if (dotIndex > 0)
			{
				packageName = classPath.substring(0, dotIndex);
				className = packageName + ":" +
					classPath.substring(dotIndex + 1);
			}
			else
			{
				className = classPath;
			}
			
			if (child.traitMultiname.nameSpace.kind == NamespaceKind.PACKAGE_NAMESPACE ||
				child.traitMultiname.nameSpace.kind == NamespaceKind.PROTECTED_NAMESPACE ||
				child.traitMultiname.nameSpace.kind == NamespaceKind.NAMESPACE ||
				child.traitMultiname.nameSpace.kind == NamespaceKind.STATIC_PROTECTED_NAMESPACE)
			{
				// Trait is public, protected or has publci custom namespace, so is accessible
				result = true;
			}
			else if (child.traitMultiname.nameSpace.kind == NamespaceKind.PACKAGE_INTERNAL_NAMESPACE)
			{
				// internal has no name, so filter it out
				if (child.traitMultiname.nameSpace.name != packageName)
				{
					if (child.traitMultiname.nameSpace.name.indexOf(className) != 0)
					{
						// external namespace, so accessible
						result = true;
					}
					if (localNamespaceTrait(child.traitMultiname.nameSpace.name, className, localNamespaces))
					{
						// Local, accessible namespace.
						result = true;
					}
				}
			}
			
			return result;
		}
		
		/**
		 * Generates a list of any public and protected local custom
		 * namespaces that the class defines.
		 * 
		 * @param traits	The class' child traits.
		 * 
		 * @return 			A vector of names of any namespaces.
		 */
		protected function generateLocalNamespaces(traits:Array):Vector.<String>
		{
			var result:Vector.<String> = new <String>[];
			
			for each (var trait:TraitInfo in traits)
			{
				if (trait is SlotOrConstantTrait && 
					(trait as SlotOrConstantTrait).vkind != null &&
					(trait as SlotOrConstantTrait).vkind.description == "namespace")
				{
					if (trait.traitMultiname.nameSpace.kind == NamespaceKind.PACKAGE_NAMESPACE ||
						trait.traitMultiname.nameSpace.kind == NamespaceKind.STATIC_PROTECTED_NAMESPACE)
					{
						result.push(trait.traitMultiname.name);
					}
				}
			}
			
			return result;
		}
		
		/**
		 * Determines if the trait's namespace if a locally defined namespace.
		 *  
		 * @param name				The full name of the trait (includes namespace)
		 * @param className			The class' full name (including package)
		 * @param localNamespaces	The list of local namespaces
		 * 
		 * @return					True if the trait's namespace if a locally 
		 * 							defined namespace; else false.
		 */
		protected function localNamespaceTrait(name:String, className:String, localNamespaces:Vector.<String>):Boolean
		{
			var result:Boolean = false;
			
			for each (var lns:String in localNamespaces)
			{
				if (name == className + "/" + lns ||
					name == className + "/protected:" + lns)
				{
					result = true;
					break;
				}
			}
			
			return result;
		}
	}
}