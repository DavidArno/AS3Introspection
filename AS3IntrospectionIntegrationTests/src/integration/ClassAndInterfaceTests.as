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

	public class ClassAndInterfaceTests extends TestCaseBaseClass
	{
		[Embed(source="libs/ClassAndInterfaceTestSWC.swc", mimeType="application/octet-stream")]
		public static const ClassAndInterfaceTestSWC:Class;
		
		[Embed(source="xml/ClassesAndInterfaces.xml", mimeType="application/octet-stream")]
		public static const ClassAndInterfacesTestXML:Class;
		
		/**
		 * Single test that extracts the SWf from Immutable.swc, loads it into memory
		 * and then applies the ABCWalker to it. Finally generates the resultant XML and
		 * checks it against the expected result.
		 */
		[Test]
		public function testClassesAndInterfaces():void
		{
			generateAndTest(ClassAndInterfaceTestSWC, 
				ClassAndInterfacesTestXML,
				"ClassAndInterfaceTestSWC.swc");
		}
	}
}