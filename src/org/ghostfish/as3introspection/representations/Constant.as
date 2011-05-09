package org.ghostfish.as3introspection.representations
{
	import org.as3commons.bytecode.abc.SlotOrConstantTrait;
	
	/**
	 * Provides an XML representation of a global constant or static or instance constant
	 * within a class.
	 */
	public class Constant extends Variable
	{
		/**
		 * Constructor.
		 * 
		 * @param trait			The trait to be represented
		 * @param packageName	The package within which the representation exists. 
		 * 						If not a packaged representation, then this will be null.
		 */
		public function Constant(trait:SlotOrConstantTrait, packageName:String)
		{
			super(trait, packageName);
			_xmlName = "constant";
		}
	}
}