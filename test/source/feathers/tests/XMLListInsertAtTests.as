package feathers.tests
{
	import feathers.utils.xml.xmlListInsertAt;

	import org.flexunit.Assert;

	public class XMLListInsertAtTests
	{
		private var _xmlList:XMLList;

		[Before]
		public function prepare():void
		{
			this._xmlList = <items>
				<item label="One"/>
				<item label="Two"/>
				<item label="Three"/>
			</items>.elements();
		}

		[After]
		public function cleanup():void
		{
			this._xmlList = null;
		}

		[Test]
		public function testInsertAt0():void
		{
			var itemToInsert:XML = <item label="New Item"/>;
			this._xmlList = xmlListInsertAt(this._xmlList, 0, itemToInsert);
			Assert.assertStrictlyEquals("xmlListInsertAt: length() after insert did not increase",
				4, this._xmlList.length());
			Assert.assertStrictlyEquals("xmlListInsertAt: returned item is not correct after insert at index 0",
				itemToInsert, this._xmlList[0]);
		}

		[Test]
		public function testInsertAtLength():void
		{
			var index:int = this._xmlList.length();
			var itemToInsert:XML = <item label="New Item"/>;
			this._xmlList = xmlListInsertAt(this._xmlList, index, itemToInsert);
			Assert.assertStrictlyEquals("xmlListInsertAt: length() after insert did not increase",
				4, this._xmlList.length());
			Assert.assertStrictlyEquals("xmlListInsertAt: returned item is not correct after insert at index === length()",
				itemToInsert, this._xmlList[index]);
		}
	}
}