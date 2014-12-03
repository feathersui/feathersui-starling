package feathers.tests
{
	import feathers.controls.TabBar;
	import feathers.controls.ToggleButton;
	import feathers.data.ListCollection;

	import org.flexunit.Assert;

	import starling.display.Quad;
	import starling.events.Event;

	public class TabBarEmptyDataProviderTests
	{
		private var _tabBar:TabBar;

		[Before]
		public function prepare():void
		{
			this._tabBar = new TabBar();
			this._tabBar.tabFactory = function():ToggleButton
			{
				var tab:ToggleButton = new ToggleButton();
				tab.defaultSkin = new Quad(200, 200);
				return tab;
			}
			TestFeathers.starlingRoot.addChild(this._tabBar);
			this._tabBar.validate();
		}

		[After]
		public function cleanup():void
		{
			this._tabBar.removeFromParent(true);
			this._tabBar = null;
		}

		[Test]
		public function testNoSelection():void
		{
			Assert.assertStrictlyEquals("The selectedIndex property was not equal to -1",
				-1, this._tabBar.selectedIndex);
			Assert.assertStrictlyEquals("The selectedItem property was not equal to null",
				null, this._tabBar.selectedItem);
		}

		[Test]
		public function testSelectFirstItemOnSetDataProvider():void
		{
			var hasChanged:Boolean = false;
			this._tabBar.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			var dataProvider:ListCollection = new ListCollection(
			[
				{ label: "One" },
				{ label: "Two" },
				{ label: "Three" },
			]);
			this._tabBar.dataProvider = dataProvider;
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertStrictlyEquals("The selectedIndex property was not equal to 0",
				0, this._tabBar.selectedIndex);
			Assert.assertStrictlyEquals("The selectedItem property was not equal to the first item",
				dataProvider.getItemAt(0), this._tabBar.selectedItem);
		}
	}
}
