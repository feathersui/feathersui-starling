package feathers.tests
{
	import feathers.controls.TabBar;
	import feathers.controls.ToggleButton;
	import feathers.data.ListCollection;

	import flash.geom.Point;

	import org.flexunit.Assert;

	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class TabBarTests
	{
		private var _tabBar:TabBar;

		[Before]
		public function prepare():void
		{
			this._tabBar = new TabBar();
			this._tabBar.dataProvider = new ListCollection(
			[
				{ label: "One", name: "one" },
				{ label: "Two" },
				{ label: "Three", isEnabled: true, name: "three" },
				{ label: "Four", isEnabled: false, name: "four" },
			]);
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

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testProgrammaticSelectionChange():void
		{
			var beforeSelectedIndex:int = this._tabBar.selectedIndex;
			var beforeSelectedItem:Object = this._tabBar.selectedItem;
			var hasChanged:Boolean = false;
			this._tabBar.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._tabBar.selectedIndex = 1;
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertFalse("The selectedIndex property was not changed",
				beforeSelectedIndex === this._tabBar.selectedIndex);
			Assert.assertFalse("The selectedItem property was not changed",
				beforeSelectedItem === this._tabBar.selectedItem);
		}

		[Test]
		public function testInteractiveSelectionChange():void
		{
			var beforeSelectedIndex:int = this._tabBar.selectedIndex;
			var hasChanged:Boolean = false;
			this._tabBar.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			var position:Point = new Point(210, 10);
			var target:DisplayObject = this._tabBar.stage.hitTest(position);
			var touch:Touch = new Touch(0);
			touch.target = target;
			touch.phase = TouchPhase.BEGAN;
			touch.globalX = position.x;
			touch.globalY = position.y;
			var touches:Vector.<Touch> = new <Touch>[touch];
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			//this touch does not move at all, so it should result in triggering
			//the button.
			touch.phase = TouchPhase.ENDED;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertFalse("The selectedIndex property was not changed",
				beforeSelectedIndex === this._tabBar.selectedIndex);
		}

		[Test]
		public function testRemoveItemBeforeSelectedIndex():void
		{
			this._tabBar.selectedIndex = 1;
			var beforeSelectedIndex:int = this._tabBar.selectedIndex;
			var beforeSelectedItem:Object = this._tabBar.selectedItem;
			var hasChanged:Boolean = false;
			this._tabBar.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._tabBar.dataProvider.removeItemAt(0);
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertStrictlyEquals("The selectedIndex property was not changed",
				beforeSelectedIndex - 1, this._tabBar.selectedIndex);
			Assert.assertStrictlyEquals("The selectedItem property was incorrectly changed",
				beforeSelectedItem, this._tabBar.selectedItem);
		}

		[Test]
		public function testRemoveItemAfterSelectedIndex():void
		{
			this._tabBar.selectedIndex = 1;
			var beforeSelectedIndex:int = this._tabBar.selectedIndex;
			var beforeSelectedItem:Object = this._tabBar.selectedItem;
			var hasChanged:Boolean = false;
			this._tabBar.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._tabBar.dataProvider.removeItemAt(2);
			Assert.assertFalse("Event.CHANGE was incorrectly dispatched", hasChanged);
			Assert.assertStrictlyEquals("The selectedIndex property was incorrectly changed",
				beforeSelectedIndex, this._tabBar.selectedIndex);
			Assert.assertStrictlyEquals("The selectedItem property was incorrectly changed",
				beforeSelectedItem, this._tabBar.selectedItem);
		}

		[Test]
		public function testRemoveSelectedIndex():void
		{
			this._tabBar.selectedIndex = 1;
			var beforeSelectedIndex:int = this._tabBar.selectedIndex;
			var beforeSelectedItem:Object = this._tabBar.selectedItem;
			var hasChanged:Boolean = false;
			this._tabBar.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._tabBar.dataProvider.removeItemAt(1);
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertStrictlyEquals("The selectedIndex property was incorrectly changed",
				beforeSelectedIndex, this._tabBar.selectedIndex);
			Assert.assertFalse("The selectedItem property was not changed",
				beforeSelectedItem === this._tabBar.selectedItem);
		}

		[Test]
		public function testReplaceItemAtSelectedIndex():void
		{
			this._tabBar.selectedIndex = 1;
			var beforeSelectedIndex:int = this._tabBar.selectedIndex;
			var beforeSelectedItem:Object = this._tabBar.selectedItem;
			var hasChanged:Boolean = false;
			this._tabBar.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._tabBar.dataProvider.setItemAt({ label: "New Item" }, beforeSelectedIndex);
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertStrictlyEquals("The selectedIndex property was incorrectly changed",
				beforeSelectedIndex, this._tabBar.selectedIndex);
			Assert.assertFalse("The selectedItem property was not changed",
				beforeSelectedItem === this._tabBar.selectedItem);
		}

		[Test]
		public function testDeselectAllOnNullDataProvider():void
		{
			var hasChanged:Boolean = false;
			this._tabBar.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._tabBar.dataProvider = null;
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertStrictlyEquals("The selectedIndex property was not set to -1",
				-1, this._tabBar.selectedIndex);
			Assert.assertStrictlyEquals("The selectedItem property was not set to null",
				null, this._tabBar.selectedItem);
		}

		[Test]
		public function testDeselectAllOnDataProviderRemoveAll():void
		{
			var hasChanged:Boolean = false;
			this._tabBar.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._tabBar.dataProvider.removeAll();
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertStrictlyEquals("The selectedIndex property was not set to -1",
				-1, this._tabBar.selectedIndex);
			Assert.assertStrictlyEquals("The selectedItem property was not set to null",
				null, this._tabBar.selectedItem);
		}

		[Test]
		public function testAddItemBeforeSelectedIndex():void
		{
			this._tabBar.selectedIndex = 1;
			var hasChanged:Boolean = false;
			var beforeSelectedIndex:int = this._tabBar.selectedIndex;
			var beforeSelectedItem:Object = this._tabBar.selectedItem;
			this._tabBar.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._tabBar.dataProvider.addItemAt({label: "New Item"}, 0);
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertStrictlyEquals("The selectedIndex property was not changed",
				beforeSelectedIndex + 1, this._tabBar.selectedIndex);
			Assert.assertStrictlyEquals("The selectedItem property was incorrectly changed",
				beforeSelectedItem, this._tabBar.selectedItem);
		}

		[Test]
		public function testDisposeWithoutChangeEvent():void
		{
			this._tabBar.selectedIndex = 1;
			var hasChanged:Boolean = false;
			this._tabBar.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._tabBar.dispose();
			Assert.assertFalse("Event.CHANGE was incorrectly dispatched", hasChanged);
		}

		[Test]
		public function testDisableAndReenable():void
		{
			this._tabBar.isEnabled = false;
			this._tabBar.validate();
			this._tabBar.isEnabled = true;
			this._tabBar.validate();
			var tab1:ToggleButton = ToggleButton(this._tabBar.getChildByName("one"));
			var tab3:ToggleButton = ToggleButton(this._tabBar.getChildByName("three"));
			var tab4:ToggleButton = ToggleButton(this._tabBar.getChildByName("four"));
			Assert.assertTrue("Tab without isEnabled value in data provider is not enabled when TabBar is disabled and then re-enabled", tab1.isEnabled);
			Assert.assertTrue("Tab with isEnabled value set to true in data provider is not enabled when TabBar is disabled and then re-enabled", tab3.isEnabled);
			Assert.assertFalse("Tab with isEnabled value set to false in data provider is not disabled when TabBar is disabled and then re-enabled", tab4.isEnabled);
		}

		[Test]
		public function testDisable():void
		{
			this._tabBar.isEnabled = false;
			this._tabBar.validate();
			var tab1:ToggleButton = ToggleButton(this._tabBar.getChildByName("one"));
			var tab3:ToggleButton = ToggleButton(this._tabBar.getChildByName("three"));
			var tab4:ToggleButton = ToggleButton(this._tabBar.getChildByName("four"));
			Assert.assertFalse("Tab without isEnabled value in data provider is incorrectly enabled when TabBar is disabled", tab1.isEnabled);
			Assert.assertFalse("Tab with isEnabled value set to true in data provider is incorrectly enabled when TabBar is disabled", tab3.isEnabled);
			Assert.assertFalse("Tab with isEnabled value set to false in data provider is incorrectly enabled when TabBar is disabled", tab4.isEnabled);
		}
	}
}
