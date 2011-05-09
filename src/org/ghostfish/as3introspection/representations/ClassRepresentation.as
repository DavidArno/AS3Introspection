package org.ghostfish.as3introspection.representations
{
	import org.as3commons.bytecode.abc.ClassTrait;
	import org.as3commons.bytecode.abc.InstanceInfo;
	import org.as3commons.bytecode.abc.Multiname;
	import org.as3commons.bytecode.abc.QualifiedName;
	
	/**
	 * A representation of a Class.
	 */
	public class ClassRepresentation extends ClassLikeRepresentation implements IXMLRepresentation
	{
		/**
		 * True if the class is marked as final.
		 */
		protected var _isFinal:Boolean;

		/**
		 * True if the class is marked as dynamic.
		 */
		protected var _isDynamic:Boolean;
		
		/**
		 * The argument set for the class' constructor.
		 */
		protected var _constructorArgs:ArgumentCollection;
		
		/**
		 * The name of the class that this one extends. 
		 */
		protected var _superClass:String;
		
		/**
		 * Constructor.
		 * 
		 * @param trait			The class trait represented by this representation.
		 * @param info			The InstanceInfo associated with the class trait.
		 * @param packageName	The package name for the trait. Null if not packaged.
		 */
		public function ClassRepresentation(trait:ClassTrait, info:InstanceInfo, packageName:String)
		{
			_isFinal = info.isFinal;
			_isDynamic = !info.isSealed;
			_superClass = (info.superclassMultiname as QualifiedName).fullName;
			
			_constructorArgs = 
				new ArgumentCollection(info.constructor.argumentCollection, info.constructor.flags, true);
			
			super(trait, info, packageName);
		}
		
		/**
		 * The XML form of this representation.
		 */
		public function get xml():XML
		{
			var result:XML = <classDetails name={_name}
										   namespace={nameSpaceName}
										   dynamic={_isDynamic}
										   final={_isFinal} 
										   extends={_superClass} />;
			
			appendInterfaces(result);
			appendPackageAndMetadataToXML(result);
			appendConstructor(result);
			
			return result;
		}
		
		/**
		 * Adds details of the class' constructor to the XML representation.
		 * 
		 * @param xml	The XML to which the constructor details
		 * 				are added.
		 */
		protected function appendConstructor(xml:XML):void
		{
			var constructor:XML = <contructor/>;
			_constructorArgs.appendArguments(constructor);
			xml.appendChild(constructor);
		}
	}
}