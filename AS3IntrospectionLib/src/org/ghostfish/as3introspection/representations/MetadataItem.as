package org.ghostfish.as3introspection.representations
{
	import flash.utils.Dictionary;
	
	import org.as3commons.bytecode.typeinfo.Metadata;

	/**
	 * Provides an XML representation of a single metadata item.
	 * 
	 * <p>A single metadata item has the AS3 code form of <code>
	 * [name(property="value", property="value")]</code>. The class 
	 * can generate an XML form of this metadata item.</p>
	 */
	public class MetadataItem implements IXMLRepresentation
	{
		/**
		 * The name of this metadat item 
		 */
		protected var _name:String;
		
		/**
		 * A dictionary of properties. The keys are the property names; the values are the property values.
		 */
		protected var _properties:Dictionary;
		
		/**
		 * Constructor.
		 * 
		 * @param 	raw			A populated instance of org.as3commons.bytecode.typeinfo.Metadata
		 * @throws	TypeError	If raw is null.
		 */
		public function MetadataItem(raw:Metadata)
		{
			_name = raw.name;
			_properties = raw.properties;
		}
		
		/**
		 * Generates an XML form of this metadata item.
		 * <p>
		 * It takes the form:
		 * <pre>&lt;metadata-item name="someName"&gt;
		 *   &lt;property name="p1" value="p1value"/&gt;
		 *   &lt;property name="p2" value="p2value"/&gt;
		 * &lt;/metadata-item&gt;</pre>
		 * </p>
		 * 
		 * @return	The XML form of this metadata item.
		 */
		public function get xml():XML
		{
			var result:XML = <metadataItem name={_name}/>;
			var sortedProperties:Array = [];
			var property:String;
			
			for (property in _properties)
			{
				sortedProperties.push(property);
			}
			
			sortedProperties = sortedProperties.sort(Array.CASEINSENSITIVE);

			for each (property in sortedProperties) 
			{
				result.appendChild(<property name={property} value={_properties[property]}/>);
			}
			
			return result;
		}
	}
}