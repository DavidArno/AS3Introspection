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
	import org.as3commons.bytecode.abc.enum.MethodFlag;
	import org.as3commons.bytecode.typeinfo.Argument;

	/**
	 * A representation of a method, setter or constructor argument set.
	 */
	public class ArgumentCollection
	{
		/**
		 * Array of Argument objects that represents the 
		 * mandatory and optional parameters for this collection.
		 */
		protected var _arguments:Array;
		
		/**
		 * If true, the XML representation of this collection will 
		 * make reference to whether there are any optional
		 * arguments. As this makes no sense for setters, this
		 * functionality can be suppressed via this flag.
		 */
		protected var _includeOptional:Boolean;
		
		/**
		 * True if the argument list ends with a "...rest" VarArgs
		 * set.  
		 */
		protected var _hasVarArgs:Boolean;
		
		/**
		 * Constructor.
		 * 
		 * @param arguments			Array of Argument objects that represents  
		 * 							the mandatory and optional parameters for 
		 * 							this collection.
		 * @param flags				A int reprentation of a set of MethodFlag
		 * 							values. Used to determine whether the
		 * 							arguments end with a "...rest" varargs
		 * 							set.
		 * @param includeOptional	If true, the XML representation of this 
		 * 							collection will make reference to whether 
		 * 							there are any optional arguments. If
		 * 							false, it won't. Optional arguments
		 * 							make no sense for setters for example.
		 */
		public function ArgumentCollection(arguments:Array, flags:int, includeOptional:Boolean)
		{
			_arguments = arguments;
			_includeOptional = includeOptional;
			_hasVarArgs = (flags & MethodFlag.NEED_REST.value) != 0; 
		}
		
		/**
		 * Appends details of the argument set to the supplied XML.
		 * 
		 * @param value	The XML to be annotated with the argument
		 * 				details.
		 */
		public function appendArguments(value:XML):void
		{
			if (_arguments.length > 0 || _hasVarArgs)
			{
				var parameters:XML = <arguments hasVarArgs={_hasVarArgs} />;
				for each (var argument:Argument in _arguments)
				{
					var type:TypeRepresentation = new TypeRepresentation(argument.type);
					var parameter:XML = <argument name={argument.name}
												  type={type.typeAsXML()} />;
					
					if (_includeOptional)
					{
						parameter.@optional = argument.isOptional;
						
						if (argument.isOptional)
						{
							parameter.@value = argument.defaultValue;
							parameter.@valueisnull = argument.defaultValue == null;
						}
					}
					
					parameters.appendChild(parameter);
				}
				
				value.appendChild(parameters);
			}
		}
	}
}