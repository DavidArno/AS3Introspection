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