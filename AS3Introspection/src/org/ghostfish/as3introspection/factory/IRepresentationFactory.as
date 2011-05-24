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
	import org.as3commons.bytecode.abc.TraitInfo;
	import org.ghostfish.as3introspection.abc.RepresentationHierarchy;

	/**
	 * Defines the contract that any representation factory must fulfill.
	 * 
	 * <p>The representation factory is used by an instance of ABCWalker to
	 * turn the traits within a SWF into an arbitrary hierarchy of 
	 * representations of those traits.</p>
	 * 
	 * <p>Implementations of this interface get to choose just what those
	 * representations are, eg they might be the SWF's contents expressed as
	 * XML or JSON or they might be AS3 code or even another language's source
	 * code.</p>
	 */
	public interface IRepresentationFactory
	{
		/**
		 * Generates a representation (in the form of a hierarchy) for the specified trait
		 * 
		 * @param trait			The trait for which a representation is to be created.
		 * @param instanceInfo	The DoABC InstanceInfo array for the trait's DoABC tag.
		 * @param packageName	The package to which the trait belongs. Will be null if
		 * 						the trait is a member of a class or interface.
		 * 
		 * @return				The representation in the form of a hierarchy.
		 */
		function createPackagedRepresentation(trait:TraitInfo, 
											  instanceInfo:Array, 
											  packageName:String):RepresentationHierarchy;
	}
}