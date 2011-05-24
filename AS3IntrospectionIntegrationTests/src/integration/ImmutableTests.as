package integration
{
	import a.b.GenericClass;
	
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

	public class ImmutableTests extends TestCaseBaseClass
	{
		[Embed(source="libs/Immutable.swc", mimeType="application/octet-stream")]
		public const ImmutableSWC:Class;
		
		[Embed(source="xml/Immutable.xml", mimeType="application/octet-stream")]
		public static const ImmutableXML:Class;
		
		/**
		 * Single test that extracts the SWf from Immutable.swc, loads it into memory
		 * and then applies the ABCWalker to it. Finally generates the resultant XML and
		 * checks it against the expected result.
		 */
		[Test]
		public function testImmutable():void
		{
			generateAndTest(ImmutableSWC, ImmutableXML, "Immutable.swc");
		}
	}
}