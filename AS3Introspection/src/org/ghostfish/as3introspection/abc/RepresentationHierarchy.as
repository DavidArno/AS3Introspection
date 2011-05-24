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
package org.ghostfish.as3introspection.abc
{
	import org.ghostfish.as3introspection.representations.AbstractRepresentation;

	/**
	 * Simple "value object" for holding a heirarachy of trait representations.
	 * 
	 * <p>By convention, either currentRepresentation (and optionally childen) should be
	 * set, or references should be set.</p>
	 * 
	 * <p>For a typical SWF created by the ABCWalker, there will be one instance of this 
	 * class that references one or more further instances: one per DoABC tag found in
	 * the SWF. If the SWF was created according to AS3 rules, each of those further
	 * instances will be a "packaged representation" (see below.) However, the SWF
	 * format isn't restricted to AS3 rules and so one or more of those referenced
	 * instances might itself be a set of references (again see below for more details)</p>
	 * 
	 * <p>An AS3 source file must consist of exactly one public trait (variable, constant,
	 * namespace, function, getter, setter, interface or class) and zero or more private 
	 * traits. The public trait must be contained within a package declaration. The 
	 * private traits are declared outside of the package declaration. As the ABCWalker 
	 * ignores the private traits, it therefore creates a packaged representation of the 
	 * trait. The currentRepresentation field will contain that trait's details and - if 
	 * an interface or class, children will contain details of the static and instance
	 * member traits.</p>
	 * 
	 * <p>Whilst most SWFs will be created from AS3 via a compiler that obeys the AS3
	 * syntax rules, some won't be. As case in point is the SWF within the playerglobal.swc
	 * that forms part of the Flex SDK. In this case the Object DoABC tag defines
	 * multiple public traits. It is for this reason that the ABCWalker might return
	 * more than one lwvel of references within the representation hierarchy.</p> 
	 */
	public class RepresentationHierarchy
	{
		/**
		 * The current representation within a hierarchy.
		 * 
		 * <p>Should be null if references is set.</p>
		 */
		public var currentRepresentation:AbstractRepresentation;
		
		/**
		 * If currentRepresentation represents an interface or class, then the
		 * representations of its members will be stored in this field.
		 * 
		 * <p>Should be null unless currentRepresentation represents an interface or 
		 * class, in which case it should not be null. For example a class with no 
		 * public members should result in a zero length Vector.</p>
		 */
		public var childen:Vector.<AbstractRepresentation>;
		
		/**
		 * One or more references to further representation heirarchies
		 * 
		 * <p>This field is used to facilitate RepresentationHierarchy being able 
		 * to represent an entire SWF/ DoABC tag/ public trait collection
		 * hierarchy using the same class.</p>
		 * 
		 * <p>Should be null if currentRepresentation is set</p>
		 */
		public var references:Vector.<RepresentationHierarchy>;
	}
}