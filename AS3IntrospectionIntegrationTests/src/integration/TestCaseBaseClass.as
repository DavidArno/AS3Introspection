package integration
{
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	
	import nochump.util.zip.ZipEntry;
	import nochump.util.zip.ZipFile;
	
	import org.as3commons.bytecode.swf.SWFFile;
	import org.as3commons.bytecode.swf.SWFFileIO;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;
	import org.ghostfish.as3introspection.abc.ABCWalker;
	import org.ghostfish.as3introspection.factory.IRepresentationFactory;
	import org.ghostfish.as3introspection.factory.XMLFormatter;
	import org.ghostfish.as3introspection.factory.XMLRepresentationFactory;

	/**
	 * Generic exact SWF from SWC, convert DoABC traits to XML and compare to the
	 * reference XML code. Applies asserts too.
	 */
	public class TestCaseBaseClass
	{
		/**
		 * Entry point for extending test case class. Runs the extract, 
		 * convert & test cycle for a given SWC.
		 *  
		 * @param SWCClass	The SWC to be tested
		 * @param XMLClass	The expected XML result
		 * 
		 * @param swcName	The name of the SWC. Used as part of an assert error
		 * 					message if library.swf cannot be found in the supplied  
		 * 					SWC.
		 */
		protected function generateAndTest(SWCClass:Class, XMLClass:Class, swcName:String):void
		{
			var zip:ZipFile = new ZipFile(new SWCClass());
			var found:Boolean = false;
			
			for each (var entry:ZipEntry in zip.entries)
			{
				if (entry.name == "library.swf")
				{
					found = true;
					var xml:XML = generateXML(zip.getInput(entry));
					testXML(xml, XMLClass);
				}
			}
			
			assertTrue("Failed to find library.swf in " + swcName, found);
		}
		
		/**
		 * Generates an XML representation of the supplied SWF.
		 *  
		 * @param data	The SWF.
		 * 
		 * @return The XML representation of the SWF.
		 */
		protected function generateXML(data:ByteArray):XML
		{
			var factory:IRepresentationFactory = new XMLRepresentationFactory();
			var formatter:XMLFormatter = new XMLFormatter();
			var io:SWFFileIO = new SWFFileIO();
			var swfFile:SWFFile = io.read(data);
			
			var walker:ABCWalker = new ABCWalker(factory, formatter);
			walker.processSWF(swfFile);
			
			return formatter.result;
		}
		
		/**
		 * Tests that the supplied XMl matches that in the specified file.
		 *  
		 * @param xml		The XMl to be tested
		 * @param XMLClass	An embedded XML file containing the reference XML.
		 */
		protected function testXML(xml:XML, XMLClass:Class):void
		{
			var expected:IDataInput = new XMLClass();
			var buffer:ByteArray = new ByteArray();
			expected.readBytes(buffer);
			
			assertEquals(buffer.toString(), xml.toXMLString());
		}
	}
}