package org.ghostfish.as3introspection.representations
{
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.as3commons.bytecode.abc.SlotOrConstantTrait;
	
	/**
	 * Provides an XML representation of a global variable or static or instance field
	 * within a class.
	 */
	public class Variable extends TypedRepresentation implements IXMLRepresentation
	{
		/**
		 * The name of the XML tag. Allows suptypes to override this in order to
		 * re-use this XML representation for their own trait types. 
		 */
		protected var _xmlName:String = "variable";
		
		/**
		 * True if the XML is to include static info 
		 */
		protected var _showStatic:Boolean = true;
		
		/**
		 * True if the XML is to include type info 
		 */
		protected var _showType:Boolean = true;
		
		/**
		 * Constructor.
		 * 
		 * @param trait			The trait to be represented
		 * @param packageName	The package within which the representation exists. 
		 * 						If not a packaged representation, then this will be null.
		 */
		public function Variable(trait:SlotOrConstantTrait, packageName:String)
		{
			super(trait, packageName);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get xml():XML
		{
			var value:XML =	<{_xmlName} name={_name} 
									    namespace={nameSpaceName}/>;
			
			if (_showStatic)
			{
				value.@static = _isStatic;
			}
			
			if (_showType)
			{
				value.@type = _type.typeAsXML();
			}

			appendPackageAndMetadataToXML(value);
			return value;
		}
	}
}