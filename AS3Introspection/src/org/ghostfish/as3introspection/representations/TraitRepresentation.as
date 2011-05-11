package org.ghostfish.as3introspection.representations
{
	import org.as3commons.bytecode.abc.LNamespace;
	import org.as3commons.bytecode.abc.TraitInfo;
	
	/**
	 * Abstraction layer class that handles extracting the metadata, namespace and name
	 * needed by <code>AbstractRepresentation</code> from a <code>TraitInfo</code> or
	 * descendent object.
	 */
	public class TraitRepresentation extends AbstractRepresentation
	{
		/**
		 * Constructor
		 * 
		 * @param trait			The <code>TraitInfo</code> instance.
		 * @param packageName	If the trait is a package-level item, then this
		 * 						string holds the package path. Null otherwise.
		 */
		public function TraitRepresentation(trait:TraitInfo, packageName:String)
		{
			var metadata:Array = trait.metadata;
			var name:String = trait.traitMultiname.name;
			var namespace:LNamespace = trait.traitMultiname.nameSpace;

			super(metadata, namespace, name, packageName);
		}
	}
}