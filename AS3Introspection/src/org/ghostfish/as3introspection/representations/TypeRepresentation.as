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
	import org.as3commons.bytecode.abc.BaseMultiname;
	import org.as3commons.bytecode.abc.MultinameG;
	import org.as3commons.bytecode.abc.QualifiedName;

	/**
	 * An XML representation of a bytecode-level data type. 
	 * 
	 * <p>Note: this class was created a result of a hasty refactor to
	 * provide support for constructors in the XML. It is very clunky
	 * as a result and will likely dramatically change soon. You have
	 * been warned!</p>
	 */
	public class TypeRepresentation
	{
		protected var _type:BaseMultiname;
		protected var _genericCharsLeft:String = ".<";
		protected var _genericCharsRight:String = ">";
		
		/**
		 * Constructor
		 * 
		 * @param type	the type to be represented
		 */
		public function TypeRepresentation(type:BaseMultiname)
		{
			_type = type;
		}
		
		/**
		 * Used to change the way a "parametized type" (ie a generic type)
		 * is rendered. By default it is GenericType.&lt;SpecificType&gt;.
		 * This property allows the ".&lt;" part to be changed.
		 */
		public function set genericCharsLeft(value:String):void
		{
			_genericCharsLeft = value;
		}

		/**
		 * Used to change the way a "parametized type" (ie a generic type)
		 * is rendered. By default it is GenericType.&lt;SpecificType&gt;.
		 * This property allows the "&gt;" part to be changed.
		 */
		public function set genericCharsRight(value:String):void
		{
			_genericCharsRight = value;
		}

		/**
		 * Expresses the supplied type as a string suitable for
		 * use with XML.
		 * <p>In order to handle AS3 "generics", a Vector.&lt;SomeType&gt;
		 * type for example, will be expressed as Vector.[SomeType]
		 * by this method</p>
		 *   
		 * @return	An XML-safe string representation of the type 
		 */
		public function typeAsXML():String
		{
			// Save the generic chars current state & make them
			// XML-proof
			var genericCharsLeft:String = _genericCharsLeft;
			var genericCharsRight:String = _genericCharsRight;
			_genericCharsLeft = ".[";
			_genericCharsRight = "]";
			
			var result:String;
			
			if (_type is QualifiedName)
			{
				result = (_type as QualifiedName).fullName;
			}
			else
			{
				result = genericTypeRepresentation(_type as MultinameG);
			}
			
			_genericCharsLeft = genericCharsLeft;
			_genericCharsRight = genericCharsRight;
			
			return result;
		}
		
		/**
		 * Creates a string representation of a generic type.
		 * <p>By default it will generate <code>
		 * package.path.GenericType.&lt;other.package.path.SpecificType&gt;
		 * </code>, but the .&lt; and &gt; can be replaced with other 
		 * character sequences using genericCharsLeft and genericCharsRight
		 * setters respectively.</p>
		 * 
		 * @param type				The MultinameG description of the type
		 * 
		 * @return The string representation of the generic type.
		 */
		protected function genericTypeRepresentation(type:MultinameG):String
		{
			var result:String = type.qualifiedName.fullName;
			result += _genericCharsLeft;
			result += genericParameters(type);
			result += _genericCharsRight;
			
			return result;
		}
		
		/**
		 * Generates a comma seperated list of specific types for a
		 * constrained generic type.
		 * 
		 * @param type	The constrained generic type.
		 * 
		 * @return A comma seperated list of the specific types
		 */
		protected function genericParameters(type:MultinameG):String
		{
			var first:Boolean = true;
			var result:String = "";
			
			for each (var qn:QualifiedName in type.parameters)
			{
				result += first ? "" : ", ";
				result += qn.fullName;
				first = false;
			}
			
			return result;
		}
	}
}