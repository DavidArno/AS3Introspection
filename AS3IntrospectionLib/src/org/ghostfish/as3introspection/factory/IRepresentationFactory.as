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