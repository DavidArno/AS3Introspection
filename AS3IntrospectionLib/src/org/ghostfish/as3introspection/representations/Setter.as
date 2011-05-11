package org.ghostfish.as3introspection.representations
{
	import org.as3commons.bytecode.abc.MethodTrait;
	
	/**
	 * A representation of a "set function". 
	 */
	public class Setter extends Method
	{
		/**
		 * Constructor.
		 *  
		 * @param trait			The MethodTrait represented by this setter instance.
		 * @param packageName	The package name for the trait. Null if not packaged.
		 * @interfaceMode		True if this trait is a child of an interface trait.
		 * 						Used by Method to control its XML attributes.
		 */
		public function Setter(trait:MethodTrait, packageName:String, interfaceMode:Boolean)
		{
			super(trait, packageName, interfaceMode);
			
			_includeOptional = false;
			_xmlName = "setter";
			_includeReturnType = false;
			
			// Regenerate the arguments set in order to pick up the changed state
			// of _includeOptional
			generateArgumentsCollection(trait);
		}
	}
}