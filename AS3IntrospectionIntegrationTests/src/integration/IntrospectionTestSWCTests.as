package integration
{
	import flash.utils.ByteArray;
	
	import flashx.textLayout.debug.assert;
	
	import nochump.util.zip.ZipEntry;
	import nochump.util.zip.ZipFile;
	
	import org.as3commons.bytecode.swf.SWFFile;
	import org.as3commons.bytecode.swf.SWFFileIO;
	import org.flexunit.asserts.assertTrue;
	import org.ghostfish.as3introspection.abc.ABCWalker;
	import org.ghostfish.as3introspection.factory.IRepresentationFactory;
	import org.ghostfish.as3introspection.factory.XMLFormatter;
	import org.ghostfish.as3introspection.factory.XMLRepresentationFactory;

	public class IntrospectionTestSWCTests extends TestCaseBaseClass
	{
		[Embed(source="libs/IntrospectionTestSWC.swc", mimeType="application/octet-stream")]
		public const IntrospectionTestSWC:Class;
		
		[Embed(source="xml/IntrospectionSelfTest.xml", mimeType="application/octet-stream")]
		public const IntrospectionTestXML:Class;
		
		/**
		 * Single test that extracts the SWF from IntrospectionTestSWC, loads it into memory
		 * and then applies the ABCWalker to it. Finally generates the resultant XML and
		 * checks it against the expected result.
		 */
		[Test]
		public function testIntrospectionTestSWC():void
		{
			generateAndTest(IntrospectionTestSWC, IntrospectionTestXML, "IntrospectionTestSWC.swc");
		}
	}
}