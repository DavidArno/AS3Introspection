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
	import org.as3commons.bytecode.abc.QualifiedName;
	
	/**
	 * A representation of a Class.
	 */
	public class ClassRepresentation extends ClassLikeRepresentation implements IXMLRepresentation
	{
		/**
		 * True if the class is marked as final.
		 */
		protected var _isFinal:Boolean;

		/**
		 * True if the class is marked as dynamic.
		 */
		protected var _isDynamic:Boolean;
		
		/**
		 * The argument set for the class' constructor.
		 */
		protected var _constructorArgs:ArgumentCollection;
		
		/**
		 * The name of the class that this one extends. 
		 */
		protected var _superClass:String;
		
		/**
		 * Constructor.
		 * 
		 * @param trait			The class trait represented by this representation.
		 * @param info			The InstanceInfo associated with the class trait.
		 * @param packageName	The package name for the trait. Null if not packaged.
		 */
		public function ClassRepresentation(trait:ClassTrait, info:InstanceInfo, packageName:String)
		{
			_isFinal = info.isFinal;
			_isDynamic = !info.isSealed;
			_superClass = (info.superclassMultiname as QualifiedName).fullName;
			
			_constructorArgs = 
				new ArgumentCollection(info.constructor.argumentCollection, info.constructor.flags, true);
			
			super(trait, info, packageName);
		}
		
		/**
		 * The XML form of this representation.
		 */
		public function get xml():XML
		{
			var result:XML = <classDetails name={_name}
										   namespace={nameSpaceName}
										   dynamic={_isDynamic}
										   final={_isFinal} 
										   extends={_superClass} />;
			
			appendInterfaces(result);
			appendPackageAndMetadataToXML(result);
			appendConstructor(result);
			
			return result;
		}
		
		/**
		 * Adds details of the class' constructor to the XML representation.
		 * 
		 * @param xml	The XML to which the constructor details
		 * 				are added.
		 */
		protected function appendConstructor(xml:XML):void
		{
			var constructor:XML = <contructor/>;
			_constructorArgs.appendArguments(constructor);
			xml.appendChild(constructor);
		}
	}
}