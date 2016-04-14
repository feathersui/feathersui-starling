package feathers.tests
{
	import feathers.controls.SpinnerList;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.data.ListCollection;

	import org.flexunit.Assert;

	import starling.display.Quad;

	public class SpinnerListTests
	{
		private var _list:SpinnerList;

		[Before]
		public function prepare():void
		{
			this._list = new SpinnerList();
			this._list.itemRendererFactory = function():DefaultListItemRenderer
			{
				var itemRenderer:DefaultListItemRenderer = new DefaultListItemRenderer();
				itemRenderer.defaultSkin = new Quad(200, 200);
				return itemRenderer;
			};
			TestFeathers.starlingRoot.addChild(this._list);
			this._list.validate();
		}

		[After]
		public function cleanup():void
		{
			this._list.removeFromParent(true);
			this._list = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		private function setDataProvider():void
		{
			this._list.dataProvider = new ListCollection(
			[
				{ label: "One" },
				{ label: "Two" },
				{ label: "Three" },
				{ label: "Four" },
			]);
		}

		[Test]
		public function testDefaultSelectionWithoutDataProvider():void
		{
			Assert.assertStrictlyEquals("SpinnerList selectedIndex must default to 0 when no data provider is available", -1, this._list.selectedIndex);
			Assert.assertNull("SpinnerList selectedItem must default to null when no data provider is available", this._list.selectedItem);
		}

		[Test]
		public function testDefaultSelectionWithDataProvider():void
		{
			this.setDataProvider();
			Assert.assertStrictlyEquals("SpinnerList selectedIndex must default to 0 with a data provider", 0, this._list.selectedIndex);
			Assert.assertStrictlyEquals("SpinnerList selectedItem must default to the item at index 0", this._list.dataProvider.getItemAt(0), this._list.selectedItem);
		}

		[Test]
		public function testSetSelectedIndexToNegativeOneWithDataProvider():void
		{
			var index:int = 2;
			this.setDataProvider();
			this._list.selectedIndex = index;
			this._list.selectedIndex = -1;
			Assert.assertStrictlyEquals("SpinnerList selectedIndex cannot be changed to -1 with a non-empty data provider", index, this._list.selectedIndex);
		}

		[Test]
		public function testSetSelectedItemToNonItemWithDataProvider():void
		{
			var index:int = 2;
			this.setDataProvider();
			this._list.selectedIndex = index;
			this._list.selectedItem = {};
			Assert.assertStrictlyEquals("SpinnerList selectedItem cannot be changed to non-item with a non-empty data provider", index, this._list.selectedIndex);
		}
	}
}
