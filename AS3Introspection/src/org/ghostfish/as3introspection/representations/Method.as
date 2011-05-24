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
	import org.as3commons.bytecode.abc.MethodTrait;
	
	/**
	 * A representation of a function or method. 
	 */
	public class Method extends TypedRepresentation implements IXMLRepresentation
	{
		/**
		 * True if the method overrides a parent class version. 
		 */
		protected var _isOverride:Boolean;
		
		/**
		 * True if the method cannot be overridden by a child class 
		 */
		protected var _isFinal:Boolean;
		
		/**
		 * Used to specify the xml node's name. Can be overriden by
		 * classes extending this one, eg Getter and Setter. 
		 */
		protected var _xmlName:String = "method";
		
		/**
		 * True if the XML will contain return type info. 
		 */
		protected var _includeReturnType:Boolean = true;
		
		/**
		 *  True if the XML is to contain optional parameter info.
		 */
		protected var _includeOptional:Boolean = true;
		
		/**
		 * True if the XML will contain the namespace. 
		 */
		protected var _includeNamespace:Boolean = true;
		
		/**
		 * True if the XML will contain static info. 
		 */
		protected var _includeStatic:Boolean = true;
		
		/**
		 * True if the XML will contain override info. 
		 */
		protected var _includeOverride:Boolean = true;
		
		/**
		 * True if the XML will contain final info. 
		 */
		protected var _includeFinal:Boolean = true;
		
		/**
		 * The set of arguments (parameters) for this method. 
		 */
		protected var _arguments:ArgumentCollection;
		
		/**
		 * Constructor.
		 *  
		 * @param trait			The MethodTrait represented by this method instance
		 * @param packageName	The package name for the trait. Null if not packaged.
		 * @interfaceMode		True if this trait is a child of an interface trait.
		 * 						Used to control the XML attributes as interface
		 * 						methods cannot be final, static etc.
		 */
		public function Method(trait:MethodTrait, packageName:String, interfaceMode:Boolean)
		{
			super(trait, packageName);
			
			generateArgumentsCollection(trait);
			
			_isOverride = trait.isOverride;
			_isFinal = trait.isFinal;
			
			if (interfaceMode)
			{
				_includeFinal = false;
				_includeNamespace = false;
				_includeOverride = false;
				_includeStatic = false;
			}
		}
		
		/**
		 * Generates some XML representing the method. Exactly what
		 * is generated depends on the state of _xmlName, _name and
		 * all the _includeXXX fields.
		 */
		public function get xml():XML
		{
			var result:XML = <{_xmlName} name={_name} />;

			includedInfo(result, _includeNamespace, "@namespace", nameSpaceName);
			includedInfo(result, _includeStatic, "@static", _isStatic);
			includedInfo(result, _includeOverride, "@override", _isOverride);
			includedInfo(result, _includeFinal, "@final", _isFinal);
			includedInfo(result, _includeReturnType, "@returntype", _type.typeAsXML());
			
			appendPackageAndMetadataToXML(result);
			_arguments.appendArguments(result);
			
			return result;
		}
		
		/**
		 * Added the specifed attribute and value to the XML if
		 * includeAttribute is true; else does nothing.
		 * 
		 * @param xml				The XML to be annotated.
		 * @param includeAttribute	If true, the annotation occurrs, else
		 * 							no change is made to the XML.
		 * @param attribute			The attribute (must start with 	&#64;) to
		 * 							be added to the XML.
		 * @param value				The value associated with the attribute.
		 */
		protected function includedInfo(xml:XML,
										includeAttribute:Boolean,
										attribute:String, 
										value:Object):void
		{
			if (includeAttribute)
			{
				xml[attribute] = value;
			}
		}
		
		/**
		 * Generates the argument collection for this method.
		 * 
		 * @param trait	The trait associated with this representation.
		 */
		protected function generateArgumentsCollection(trait:MethodTrait):void
		{
			_arguments = 
				new ArgumentCollection(trait.traitMethod.argumentCollection,
					trait.traitMethod.flags, 
					_includeOptional);
		}
	}
}