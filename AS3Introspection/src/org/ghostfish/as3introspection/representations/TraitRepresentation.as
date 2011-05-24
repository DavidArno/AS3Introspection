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
	import org.as3commons.bytecode.abc.LNamespace;
	import org.as3commons.bytecode.abc.TraitInfo;
	
	/**
	 * Abstraction layer class that handles extracting the metadata, namespace and name
	 * needed by <code>AbstractRepresentation</code> from a <code>TraitInfo</code> or
	 * descendent object.
	 */
	public class TraitRepresentation extends AbstractRepresentation
	{
		/**
		 * Constructor
		 * 
		 * @param trait			The <code>TraitInfo</code> instance.
		 * @param packageName	If the trait is a package-level item, then this
		 * 						string holds the package path. Null otherwise.
		 */
		public function TraitRepresentation(trait:TraitInfo, packageName:String)
		{
			var metadata:Array = trait.metadata;
			var name:String = trait.traitMultiname.name;
			var namespace:LNamespace = trait.traitMultiname.nameSpace;

			super(metadata, namespace, name, packageName);
		}
	}
}