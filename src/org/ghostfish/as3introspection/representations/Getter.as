package org.ghostfish.as3introspection.representations
{
	import org.as3commons.bytecode.abc.MethodTrait;
	
	/**
	 * A representation of a "get function". 
	 */
	public class Getter extends Method
	{
		/**
		 * Constructor.
		 *  
		 * @param trait			The MethodTrait represented by this Getter instance
		 * @param packageName	The package name for the trait. Null if not packaged.
		 * @interfaceMode		True if this trait is a child of an interface trait.
		 * 						Used by Method to control its XML attributes.
		 */
		public function Getter(trait:MethodTrait, packageName:String, interfaceMode:Boolean)
		{
			super(trait, packageName, interfaceMode);
			_xmlName = "getter";
		}
	}
}