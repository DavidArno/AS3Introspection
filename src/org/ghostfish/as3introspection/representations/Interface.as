package org.ghostfish.as3introspection.representations
{
	import org.as3commons.bytecode.abc.ClassTrait;
	import org.as3commons.bytecode.abc.InstanceInfo;
	import org.as3commons.bytecode.abc.Multiname;
	
	/**
	 * A representation of an interface.
	 */
	public class Interface extends ClassLikeRepresentation implements IXMLRepresentation
	{
		/**
		 * Constructor.
		 * 
		 * @param trait			The class trait represented by this representation.
		 * @param info			The InstanceInfo associated with the class trait.
		 * @param packageName	The package name for the trait. Null if not packaged.
		 */
		public function Interface(trait:ClassTrait, info:InstanceInfo, packageName:String)
		{
			super(trait, info, packageName);
			
			_interfaces = createInterfaceList(info.interfaceMultinames);
			_interfacesTagName = "parentInterfaces";
			_implementsTagName = "extends";
		}
		
		/**
		 * The XML form of this representation.
		 */
		public function get xml():XML
		{
			var result:XML = <interfaceDetails name={_name}
											   namespace={nameSpaceName} />;
			
			appendInterfaces(result);
			appendPackageAndMetadataToXML(result);
			return result;
		}
	}
}