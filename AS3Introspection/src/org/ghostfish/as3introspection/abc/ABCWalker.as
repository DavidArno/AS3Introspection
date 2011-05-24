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
	import flash.utils.ByteArray;
	
	import org.as3commons.bytecode.abc.AbcFile;
	import org.as3commons.bytecode.abc.TraitInfo;
	import org.as3commons.bytecode.abc.enum.NamespaceKind;
	import org.as3commons.bytecode.swf.SWFFile;
	import org.as3commons.bytecode.swf.SWFFileIO;
	import org.as3commons.bytecode.tags.DoABCTag;
	import org.ghostfish.as3introspection.factory.IRepresentationFactory;
	import org.ghostfish.as3introspection.factory.IRepresentationFormatter;

	/**
	 * Handles processing an in-memory SWF file to generate a collection 
	 * of representations of the traits found therein.
	 * 
	 * <p>Points to note: 
	 * <ul>
	 * <li>Private and internal traits are ignored.</li>
	 * <li>Multiple public traits within one DoABC tag are converted into multiple
	 * packaged representations</li>
	 * </ul></p>
	 */
	public class ABCWalker
	{
		/**
		 * Local copy of IRepresentationFactory that this walker will use to
		 * process a SWF.
		 */
		protected var _representationFactory:IRepresentationFactory;
		
		/**
		 * Local copy of IRepresentationFormatter that this walker will use
		 * to process the representation of the SWF 
		 */
		protected var _formatter:IRepresentationFormatter;
		
		/**
		 * Constructor 
		 * 
		 * @param representationFactory	The IRepresentationFactory that this walker
		 * 								is to use in processing SWFs.
		 * @param formatter				The IRepresentationFormatter that this
		 * 								walker is to use in processing the 
		 * 								representation of SWFs.
		 */
		public function ABCWalker(representationFactory:IRepresentationFactory,
								  formatter:IRepresentationFormatter)
		{
			_representationFactory = representationFactory;
			_formatter = formatter;
		}
		
		/**
		 * Extracts the SWF from the supplied byte array and calls
		 * processSWF using that SWF.
		 * 
		 * @param data	A byte array that must contain a in-memory SWF.
		 * 
		 * @throws	???
		 */
		public function processByteArray(data:ByteArray):void
		{
			var io:SWFFileIO = new SWFFileIO();
			var swfFile:SWFFile = io.read(data);
			
			processSWF(swfFile);
		}
		
		/**
		 * Applies the IRepresentationFactory to the supplied SWF to generate
		 * a representation hierarchy, then applies the 
		 * IRepresentationFormatter to that representation.
		 * 
		 * @param swf	The in-memory SWF file to be processed.
		 */
		public function processSWF(swf:SWFFile):void
		{
			var hierarchy:RepresentationHierarchy =
				extractRepresentations(swf);
			
			_formatter.process(hierarchy);
		}
		
		/**
		 * Generates a representation hierarchy from the ABCFiles tags found within the
		 * supplied SWF.
		 *   
		 * @param swf	The SWF to be processed
		 * 
		 * @return 		A RepresentationHierarchy. See the class' description for more
		 * 				details.
		 */
		public function extractRepresentations(swf:SWFFile):RepresentationHierarchy
		{
			var hierarchy:RepresentationHierarchy = new RepresentationHierarchy();
			hierarchy.references = new Vector.<RepresentationHierarchy>();
			
			for each(var tag:DoABCTag in swf.getTagsByType(DoABCTag))
			{
				hierarchy.references.push(processAbcFile(tag.abcFile));
			}
			
			return hierarchy;
		}
		
		/**
		 * Processes an ABCFile tag within a SWF to extract the representations found therein.
		 * <p>Called by extractRepresentations(); once for each ABCFile tag found in the SWF</p>
		 * 
		 * @param abcFile	The abcFile tag to process.
		 * 
		 * @return 			A RepresentationHierarchy of the representations found therein.
		 */
		protected function processAbcFile(abcFile:AbcFile):RepresentationHierarchy
		{
			var hierarchy:RepresentationHierarchy = new RepresentationHierarchy();
			hierarchy.references = new Vector.<RepresentationHierarchy>();
			
			for each (var trait:TraitInfo in abcFile.scriptInfo[0].traits)
			{
				if (accessible(trait))
				{
					var traitHierarchy:RepresentationHierarchy = 
						_representationFactory.createPackagedRepresentation(
							trait, 
							abcFile.instanceInfo,
							trait.traitMultiname.nameSpace.name);

					hierarchy.references.push(traitHierarchy);
				}
			}
			
			return hierarchy;
		}
		
		/**
		 * Tests whether the trait is public and meaningful
		 * 
		 * @param trait 	The trait to test
		 * 
		 * @return 			True if public; else false.
		 */
		protected function accessible(trait:TraitInfo):Boolean
		{
			var result:Boolean = false;
			
			if (trait.traitMultiname.nameSpace.kind.byteValue == NamespaceKind.PACKAGE_NAMESPACE.byteValue)
			{
				if (trait.traitMultiname.fullName.search(/_[0-9a-f]+_flash_display_Sprite/) == -1)
				{
					result = true;
				}
			}
			
			return result;
		}
	}
}