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
	 * A representation of a "get function". 
	 */
	public class Getter extends Method
	{
		/**
		 * Constructor.
		 *  
		 * @param trait			The MethodTrait represented by this Getter instance
		 * @param packageName	The package name for the trait. Null if not packaged.
		 * @interfaceMode		True if this trait is a child of an interface trait.
		 * 						Used by Method to control its XML attributes.
		 */
		public function Getter(trait:MethodTrait, packageName:String, interfaceMode:Boolean)
		{
			super(trait, packageName, interfaceMode);
			_xmlName = "getter";
		}
	}
}