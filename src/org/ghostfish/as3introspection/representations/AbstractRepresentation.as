package org.ghostfish.as3introspection.representations
{
	import org.as3commons.bytecode.abc.LNamespace;
	import org.as3commons.bytecode.abc.enum.NamespaceKind;
	import org.as3commons.bytecode.typeinfo.Metadata;
	import org.ghostfish.as3introspection.enums.NameSpaces;

	/**
	 * Basic representation of a named item, that may be packages and may have metadata
	 * associated with it. 
	 */
	public class AbstractRepresentation
	{
		/**
		 * Raw metadata set via the constructor. An array of
		 * org.as3commons.bytecode.typeinfo.Metadata items.
		 * <p>
		 * Used by processMetadata() to populate _metadata
		 * </p>
		 */
		protected var _rawMetadata:Array;
		
		/**
		 * Processed metadata created by processMetadata()
		 */
		protected var _metadata:Vector.<MetadataItem>;
		
		/**
		 * Local copy of the namespace to which this representation belongs 
		 */
		protected var _namespace:LNamespace;
		
		/**
		 * The representation's name 
		 */
		protected var _name:String;
		
		/**
		 * The package within which the representation exists. If not a packaged
		 * representation, then this will be null. Remember "" is the default package.
		 */
		protected var _packageName:String;
		
		/**
		 * Constructor.
		 *  
		 * @param metadata		An array of Metadata items associated with this representation.
		 * @param namespace		The namespace to which this representation belongs.
		 * @param name			The representation's name
		 * @param packageName	The package within which the representation exists. If not a packaged
		 * 						representation, then this will be null.
		 */
		function AbstractRepresentation(metadata:Array, namespace:LNamespace, name:String, packageName:String)
		{
			_rawMetadata = metadata;
			_namespace = namespace;
			_name = name;
			_packageName = packageName;
			
			processMetadata();
		}
		
		/**
		 * Creates a vector of MetadataItem's from the _rawMetadata,
		 * which are stored in  _metadata
		 * 
		 * <p>The __go_to_ctor_definition_help and __go_to_definition_help
		 * metadata items are filtered out.</p>
		 */
		protected function processMetadata():void
		{
			_metadata = new Vector.<MetadataItem>();
			for each (var raw:Metadata in _rawMetadata)
			{
				if (raw.name != "__go_to_ctor_definition_help" &&
					raw.name != "__go_to_definition_help")
				{
					var processed:MetadataItem = new MetadataItem(raw);
					_metadata.push(processed);
				}
			}
		}
		
		/**
		 * True if this is a packaged representation; false otherwise
		 */
		public function get packaged():Boolean
		{
			return _packageName != null;
		}
		
		/**
		 * XML representation of the package.
		 * <p>Takes the form &lt;packaged path={package name}/&gt;</p>
		 * 
		 * @return XML if representation is packaged; otherwise null.
		 */
		public function get packageXML():XML
		{
			var result:XML;
			if (packaged)
			{
				result = <packaged path={_packageName}/>
			}
			
			return result;
		}
		
		/**
		 * The name of the namespace (public, protected or a custom value)
		 * <p>
		 * If custom, the name will be the fully qualified name, including
		 * package, eg "flash.utils.flash_proxy"
		 * </p>
		 */
		public function get nameSpaceName():String
		{
			var ns:String = _namespace.name;
			var type:NameSpaces = nameSpaceType;
			
			if (type != NameSpaces.Custom)
			{
				ns = type.keyword;
			}
		
			return ns;
		}
		
		/**
		 * One of NameSpaces.Public, NameSpaces.Protected or NameSpaces.Custom.
		 */
		public function get nameSpaceType():NameSpaces
		{
			var type:NameSpaces;
			
			if (_namespace.kind.byteValue == NamespaceKind.PACKAGE_NAMESPACE.byteValue)
			{
				type = NameSpaces.Public;
			}
			else if (_namespace.kind == NamespaceKind.PROTECTED_NAMESPACE ||
					 _namespace.kind == NamespaceKind.STATIC_PROTECTED_NAMESPACE)
			{
				type = NameSpaces.Protected;
			}
			else
			{
				type = NameSpaces.Custom;
			}
			
			return type;
		}
		
		/**
		 * Adds package and namespace info to the supplied XML as
		 * child elements.
		 * 
		 * <p>If the representation is packaged, then</p>
		 * 
		 * <p>&lt;xml/&gt;</p>
		 * 
		 * <p>becomes</p>
		 * 
		 * <p>&lt;xml&gt;<br/>
		 *   &lt;packaged path={package name}/&gt;<br/>
		 * &lt;/xml&gt;</p>
		 * 
		 * <p>otherwise no change occurrs.</p>
		 * 
		 * @param value	The XML to be updated.
		 */
		protected function appendPackageAndMetadataToXML(value:XML):void
		{
			if (packaged)
			{
				value.appendChild(packageXML);
			}
			
			if (_metadata.length > 0)
			{
				var metaXML:XML = <metadata/>;
				for each (var metadata:MetadataItem in _metadata)
				{
					metaXML.appendChild(metadata.xml);
				}
				
				value.appendChild(metaXML);
			}
		}
	}
}