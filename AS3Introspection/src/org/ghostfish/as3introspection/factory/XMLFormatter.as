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
package org.ghostfish.as3introspection.factory
{
	import flash.utils.getQualifiedClassName;
	
	import org.ghostfish.as3introspection.abc.RepresentationHierarchy;
	import org.ghostfish.as3introspection.representations.AbstractRepresentation;
	import org.ghostfish.as3introspection.representations.ClassRepresentation;
	import org.ghostfish.as3introspection.representations.Constant;
	import org.ghostfish.as3introspection.representations.IXMLRepresentation;
	import org.ghostfish.as3introspection.representations.Interface;
	import org.ghostfish.as3introspection.representations.Method;
	import org.ghostfish.as3introspection.representations.NamespaceRepresentation;
	import org.ghostfish.as3introspection.representations.Variable;
	
	/**
	 * Implementation of IRepresentationFormatter that creates a XML
	 * object that expresses the contents of a SWF.
	 */
	public class XMLFormatter implements IRepresentationFormatter
	{
		/**
		 * Local copy of the XML expression of the contents of the SWF.
		 */
		protected var _results:XML;
		
		/**
		 * Processes a hierarchy representation to create the XML
		 * expression of a SWF's contents.
		 * 
		 * @param hierarchy The RepresentationHierarchy created via
		 * 					XMLRepresentation.
		 */
		public function process(hierarchy:RepresentationHierarchy):void
		{
			var classes:XML = <classes/>;
			var interfaces:XML = <interfaces/>;
			var namespaces:XML = <namespaces/>;
			var functions:XML = <functions/>;
			var constants:XML = <constants/>;
			var variables:XML = <variables/>;
			
			addChildren(classes, hierarchy, ClassRepresentation);
			addChildren(interfaces, hierarchy, Interface);
			addChildren(namespaces, hierarchy, NamespaceRepresentation);
			addChildren(functions, hierarchy, Method);
			addChildren(constants, hierarchy, Constant);
			addChildren(variables, hierarchy, Variable);

			_results = <swf/>;
			_results.appendChild(classes);
			_results.appendChild(interfaces);
			_results.appendChild(namespaces);
			_results.appendChild(functions);
			_results.appendChild(constants);
			_results.appendChild(variables);
		}
		
		/**
		 * The XML results from called process().
		 */
		public function get result():XML
		{
			return _results;
		}
		
		/**
		 * Adds child nodes to an XML node when processing a hierarchy.
		 * 
		 * @param parentXML	The XML node to which the children XML will be added
		 * 
		 * @param hierarchy	The hierarchy that will be processed to generate the
		 * 					children XML.
		 * @param traitType	The trait type (as an implementation of
		 * 					IXMLRepresentation) to be added to the parentXML
		 */
		protected function addChildren(parentXML:XML, 
									   hierarchy:RepresentationHierarchy, 
									   traitType:Class):void
		{
			if (hierarchy.currentRepresentation is IXMLRepresentation &&
				getQualifiedClassName(hierarchy.currentRepresentation) == 
				getQualifiedClassName(traitType))
			{
				var subParent:XML = addChild(parentXML, hierarchy.currentRepresentation);
				
				if (hierarchy.childen is Vector.<AbstractRepresentation>)
				{
					for each (var child:AbstractRepresentation in hierarchy.childen)
					{
						addChild(subParent, child);
					}
				}
			}
			else
			{
				for each (var subHierarchy:RepresentationHierarchy in hierarchy.references)
				{
					addChildren(parentXML, subHierarchy, traitType);
				}
			}
		}	
		
		/**
		 * Adds a single child XML node to a parent node.
		 *  
		 * @param parentXML			The parent node.
		 * @param representation	Representation that will be turned into XML.
		 * 							Must be instance of IXMLRepresentation
		 * 
		 * @return					The XML representation of the child.
		 */
		protected function addChild(parentXML:XML, representation:AbstractRepresentation):XML
		{
			var xmlRepresentation:IXMLRepresentation = 
				representation as IXMLRepresentation;
			
			var child:XML = xmlRepresentation.xml;
			parentXML.appendChild(child);
			
			return child;
		}
	}
}