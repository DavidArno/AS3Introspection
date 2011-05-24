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
package org.ghostfish.as3introspection.representations
{
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import org.as3commons.bytecode.abc.BaseMultiname;
	import org.as3commons.bytecode.abc.LNamespace;
	import org.as3commons.bytecode.abc.MethodTrait;
	import org.as3commons.bytecode.abc.Multiname;
	import org.as3commons.bytecode.abc.MultinameG;
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.as3commons.bytecode.abc.SlotOrConstantTrait;
	import org.as3commons.bytecode.abc.TraitInfo;
	
	/**
	 * Representation of traits that have a type
	 */
	public class TypedRepresentation extends TraitRepresentation
	{
		/**
		 * The item's type
		 */
		protected var _type:TypeRepresentation;
		
		/**
		 * True if the item is "static" (ie a class member, rather than instance member) 
		 */
		protected var _isStatic:Boolean;
		
		/**
		 * Constructor
		 *  
		 * @param trait			The item's trait. Must be an instance of SlotOrConstantTrait
		 * 						or MethodTrait. Will throw an error if not.
		 * @param packageName	The package to which the item belongs.
		 * 
		 * @throws	Error		If trait is not an instance of SlotOrConstantTrait
		 * 						or MethodTrait.
		 */
		public function TypedRepresentation(trait:TraitInfo, packageName:String)
		{
			if (trait is SlotOrConstantTrait || trait is MethodTrait)
			{
				super(trait, packageName);
				
				if (trait is SlotOrConstantTrait)
				{
					extraSetupForSlotOrConstantTrait(trait as SlotOrConstantTrait);
				}
				else
				{
					extraSetupForMethodTrait(trait as MethodTrait);
				}
			}
			else
			{
				throw new Error("TypedRepresentation: trait type of '" + getQualifiedClassName(trait) + 
								"' is not supported. Must be instance of SlotOrConstantTrait or MethodTrait");
			}
		}
		
		/**
		 * Handles the extra setup for variables and constants 
		 * 
		 * @param trait	The trait associated with this representation
		 */
		protected function extraSetupForSlotOrConstantTrait(trait:SlotOrConstantTrait):void
		{
			_type = new TypeRepresentation(trait.typeMultiname);
			_isStatic = trait.isStatic;
		}
		
		/**
		 * Handles the extra setup for functions, methods, setters and getters.
		 *
		 * @param trait The trait associated with this representation
		 */
		protected function extraSetupForMethodTrait(trait:MethodTrait):void
		{
			_type = new TypeRepresentation(trait.traitMethod.returnType);
			_isStatic = trait.isStatic;
		}
		
		/**
		 * Expresses the trait's type as a string suitable for
		 * use with XML.
		 * <p>In order to handle AS3 "generics", a Vector.&lt;SomeType&gt;
		 * type for example, will be expressed as Vector.[SomeType]
		 * by this method</p>
		 *   
		 * @return	An XML-safe string representation of the type 
		 */
		public function traitTypeAsXML():String
		{
			return _type.typeAsXML();
		}
		
	}
}