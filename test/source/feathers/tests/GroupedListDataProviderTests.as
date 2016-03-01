package feathers.tests
{
	import feathers.controls.GroupedList;
	import feathers.controls.renderers.DefaultGroupedListHeaderOrFooterRenderer;
	import feathers.controls.renderers.DefaultGroupedListItemRenderer;
	import feathers.data.HierarchicalCollection;

	import org.flexunit.Assert;

	import starling.display.Quad;

	public class GroupedListDataProviderTests
	{
		private var _list:GroupedList;

		[Before]
		public function prepare():void
		{
			this._list = new GroupedList();
			this._list.itemRendererFactory = function():DefaultGroupedListItemRenderer
			{
				var itemRenderer:DefaultGroupedListItemRenderer = new DefaultGroupedListItemRenderer();
				itemRenderer.defaultSkin = new Quad(200, 200);
				return itemRenderer;
			};
			this._list.headerRendererFactory = function():DefaultGroupedListHeaderOrFooterRenderer
			{
				var headerRenderer:DefaultGroupedListHeaderOrFooterRenderer = new DefaultGroupedListHeaderOrFooterRenderer();
				headerRenderer.backgroundSkin = new Quad(200, 200);
				return headerRenderer;
			};
			TestFeathers.starlingRoot.addChild(this._list);
		}

		[After]
		public function cleanup():void
		{
			this._list.removeFromParent(true);
			this._list = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testValidateWithNullDataProvider():void
		{
			this._list.validate();
		}

		[Test]
		public function testValidateWithNullDataProviderAndTypicalItem():void
		{
			this._list.typicalItem = { label: "Typical Item" };
			this._list.validate();
		}

		[Test]
		public function testNoErrorOnDataProviderWithoutGroups():void
		{
			this._list.dataProvider = new HierarchicalCollection([]);
			this._list.validate();
		}

		[Test]
		public function testNoErrorOnDataProviderWithOneEmptyGroup():void
		{
			this._list.dataProvider = new HierarchicalCollection(
			[
				{ children: [] }
			]);
			this._list.validate();
		}

		[Test]
		public function testNoErrorOnDataProviderWithoutGroupsAndWithTypicalItem():void
		{
			this._list.typicalItem = { label: "Typical Item" };
			this._list.dataProvider = new HierarchicalCollection([]);
			this._list.validate();
		}

		[Test]
		public function testNoErrorOnDataProviderWithOneEmptyGroupAndTypicalItem():void
		{
			this._list.typicalItem = { label: "Typical Item" };
			this._list.dataProvider = new HierarchicalCollection(
			[
				{ children: [] }
			]);
			this._list.validate();
		}

		[Test(expects="TypeError")]
		public function testErrorOnGroupWithNoChildrenField():void
		{
			this._list.dataProvider = new HierarchicalCollection(
			[
				{}
			]);
			this._list.validate();
		}
	}
}
