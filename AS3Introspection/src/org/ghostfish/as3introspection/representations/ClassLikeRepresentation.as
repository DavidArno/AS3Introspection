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
	import org.as3commons.bytecode.abc.ClassTrait;
	import org.as3commons.bytecode.abc.InstanceInfo;
	import org.as3commons.bytecode.abc.Multiname;
	
	/**
	 * Common representation details of classes and interfaces.
	 */
	public class ClassLikeRepresentation extends TraitRepresentation
	{
		/**
		 * The set of interfaces that this trait extends (if an
		 * interface itself) or implements (if a class.)
		 */
		protected var _interfaces:Vector.<String>;
		
		/**
		 * The name given to the "interfaces" tag. Used by 
		 * appendInterfaces(). 
		 */
		protected var _interfacesTagName:String = "interfaces";
		
		/**
		 * The name given to the "implements" tag. Used by 
		 * appendInterfaces(). 
		 */
		protected var _implementsTagName:String = "implements";
		
		/**
		 * Constructor.
		 * 
		 * @param trait			The class trait represented by this representation.
		 * @param info			The InstanceInfo associated with the class trait.
		 * @param packageName	The package name for the trait. Null if not packaged.
		 */
		public function ClassLikeRepresentation(trait:ClassTrait, info:InstanceInfo, packageName:String)
		{
			_interfaces = createInterfaceList(info.interfaceMultinames);

			super(trait, packageName);
		}
		
		/**
		 * Creates a list of full names of any interfaces that this
		 * trait extends or implements.
		 *  
		 * @param names	The array of interface Multinames for this trait.
		 *  
		 * @return Vector of full names of the interfaces. 
		 */
		protected function createInterfaceList(names:Array):Vector.<String>
		{
			var results:Vector.<String> = new Vector.<String>();
				
			for each (var multiName:Multiname in names)
			{
				results.push(multiName.namespaceSet.namespaces[0].name + "." + multiName.name);
			}
			
			return results;
		}
		
		/**
		 * Appends details of the interfaces to the supplied XML.
		 *  
		 * @param result	Updated XML, including interface
		 * 					detail. No change occurs if there
		 * 					are no implement/ extended 
		 * 					interfaces associated with this trait.
		 */
		protected function appendInterfaces(result:XML):void
		{
			if (_interfaces.length > 0)
			{
				var interfaceXML:XML = <{_interfacesTagName}/>;
				
				for each (var iFace:String in _interfaces)
				{
					interfaceXML.appendChild(<{_implementsTagName} name={iFace} />);
				}
				
				result.appendChild(interfaceXML);
			}
		}
	}
}