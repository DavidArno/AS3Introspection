package org.ghostfish.as3introspection.representations
{
	import org.as3commons.bytecode.abc.LNamespace;
	import org.as3commons.bytecode.abc.SlotOrConstantTrait;
	import org.as3commons.bytecode.abc.enum.NamespaceKind;
	
	/**
	 * XML representation of a namespace definition.
	 */
	public class NamespaceRepresentation extends Constant
	{
		/**
		 * The namespace's URL if defined. Null otherwise. 
		 */
		protected var url:String = null;
		
		/**
		 * Constructor.
		 *  
		 * @param trait			The trait to be represented
		 * @param packageName	The package within which the representation exists. 
		 * 						If not a packaged representation, then this will be null.
		 */
		public function NamespaceRepresentation(trait:SlotOrConstantTrait, packageName:String)
		{
			super(trait, packageName);
			_xmlName = "namespace";
			_showStatic = false;
			_showType = false;
			
			if ((trait.defaultValue as LNamespace).kind.byteValue == NamespaceKind.NAMESPACE.byteValue)
			{
				url = trait.defaultValue.name;
			}
		}
		
		/**
		 * Generates the XML representation of a namespace. 
		 */
		public override function get xml():XML
		{
			var result:XML = super.xml;
			if (url != null)
			{
				result.@url = url;
			}
			
			return result;
		}
	}
}