package feathers.tests
{
	import feathers.controls.Button;
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
				{ label: "One" },
				{ label: "Two" },
				{ label: "Three" },
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
		}

		[Test]
		public function testProgrammaticChangeEvent():void
		{
			var beforeSelectedIndex:int = this._tabBar.selectedIndex;
			var beforeSelectedItem:Object = this._tabBar.selectedItem;
			var hasChanged:Boolean = false;
			this._tabBar.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._tabBar.selectedIndex = 1;
			this._tabBar.validate(); //the change doesn't happen until validation
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertFalse("This selectedIndex property was not changed", beforeSelectedIndex === this._tabBar.selectedIndex);
			Assert.assertFalse("This selectedItem property was not changed", beforeSelectedItem === this._tabBar.selectedItem);
		}

		[Test]
		public function testInteractiveChangeEvent():void
		{
			var beforeSelectedIndex:Boolean = this._tabBar.selectedIndex;
			var hasChanged:Boolean = false;
			this._tabBar.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			var position:Point = new Point(210, 10);
			var target:DisplayObject = this._tabBar.stage.hitTest(position, true);
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
			Assert.assertFalse("This selectedIndex property was not changed", beforeSelectedIndex === this._tabBar.selectedIndex);
		}

		[Test]
		public function testRemoveBeforeSelectedIndexChangeEvent():void
		{
			this._tabBar.selectedIndex = 1;
			this._tabBar.validate(); //the change doesn't happen until validation
			var beforeSelectedIndex:int = this._tabBar.selectedIndex;
			var beforeSelectedItem:Object = this._tabBar.selectedItem;
			var hasChanged:Boolean = false;
			this._tabBar.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._tabBar.dataProvider.removeItemAt(0);
			this._tabBar.validate();
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertFalse("The selectedIndex property was not changed",
				beforeSelectedIndex === this._tabBar.selectedIndex);
			Assert.assertStrictlyEquals("The selectedItem was incorrectly changed",
				beforeSelectedItem, this._tabBar.selectedItem);
		}

		[Test]
		public function testRemoveAfterSelectedIndexChangeEvent():void
		{
			this._tabBar.selectedIndex = 1;
			this._tabBar.validate(); //the change doesn't happen until validation
			var beforeSelectedIndex:int = this._tabBar.selectedIndex;
			var beforeSelectedItem:Object = this._tabBar.selectedItem;
			var hasChanged:Boolean = false;
			this._tabBar.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._tabBar.dataProvider.removeItemAt(2);
			this._tabBar.validate();
			Assert.assertFalse("Event.CHANGE was incorrectly dispatched", hasChanged);
			Assert.assertStrictlyEquals("The selectedIndex property was incorrectly changed",
				beforeSelectedIndex, this._tabBar.selectedIndex);
			Assert.assertStrictlyEquals("The selectedItem was incorrectly changed",
				beforeSelectedItem, this._tabBar.selectedItem);
		}

		[Test]
		public function testRemoveSelectedIndexChangeEvent():void
		{
			this._tabBar.selectedIndex = 1;
			this._tabBar.validate(); //the change doesn't happen until validation
			var beforeSelectedIndex:int = this._tabBar.selectedIndex;
			var beforeSelectedItem:Object = this._tabBar.selectedItem;
			var hasChanged:Boolean = false;
			this._tabBar.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._tabBar.dataProvider.removeItemAt(1);
			this._tabBar.validate();
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertStrictlyEquals("The selectedIndex property was incorrectly changed",
				beforeSelectedIndex, this._tabBar.selectedIndex);
			Assert.assertFalse("The selectedItem was not changed",
				beforeSelectedItem === this._tabBar.selectedItem);
		}
	}
}
