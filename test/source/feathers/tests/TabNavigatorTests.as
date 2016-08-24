package feathers.tests
{
	import feathers.controls.TabNavigator;
	import feathers.controls.TabNavigatorItem;

	import org.flexunit.Assert;

	import starling.display.DisplayObject;

	import starling.display.Quad;
	import starling.events.Event;

	public class TabNavigatorTests
	{
		public static const SCREEN_A_ID:String = "a";
		public static const SCREEN_B_ID:String = "b";
		public static const SCREEN_A_LABEL:String = "Screen A";
		public static const SCREEN_B_LABEL:String = "Screen B";

		private var _navigator:TabNavigator;

		[Before]
		public function prepare():void
		{
			this._navigator = new TabNavigator();
			TestFeathers.starlingRoot.addChild(this._navigator);
			this._navigator.validate();
		}

		[After]
		public function cleanup():void
		{
			this._navigator.removeFromParent(true);
			this._navigator = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.",
				0, TestFeathers.starlingRoot.numChildren);
		}

		private function addScreenA():void
		{
			var screen:Quad = new Quad(10, 10, 0xff00ff);
			var item:TabNavigatorItem = new TabNavigatorItem(screen, SCREEN_A_LABEL);
			this._navigator.addScreen(SCREEN_A_ID, item);
			Assert.assertStrictlyEquals("screenDisplayObject does not return correct value",
				screen, item.screenDisplayObject);
		}

		private function addScreenB():void
		{
			var screen:Quad = new Quad(10, 10, 0xffff00);
			var item:TabNavigatorItem = new TabNavigatorItem(screen, SCREEN_B_LABEL);
			this._navigator.addScreen(SCREEN_B_ID, item);
		}

		[Test]
		public function testHasScreenWhenNotAdded():void
		{
			Assert.assertFalse("hasScreen() incorrectly returned true for a screen that was not added",
				this._navigator.hasScreen(SCREEN_A_ID));
		}

		[Test]
		public function testHasScreen():void
		{
			this.addScreenA();
			Assert.assertTrue("hasScreen() incorrectly returned false for a screen that was added",
				this._navigator.hasScreen(SCREEN_A_ID));
		}

		[Test]
		public function testStateWithNoTabs():void
		{
			Assert.assertNull("activeScreen returned incorrect value for no tabs",
				this._navigator.activeScreen);
			Assert.assertNull("activeScreenID returned incorrect value for no tabs",
				this._navigator.activeScreenID);
			Assert.assertStrictlyEquals("selectedIndex returned incorrect value for no tabs",
				-1, this._navigator.selectedIndex);
		}

		[Test]
		public function testStateWithOneTab():void
		{
			this.addScreenA();
			Assert.assertStrictlyEquals("activeScreen returned incorrect value for first tab",
				this._navigator.getScreen(SCREEN_A_ID).screenDisplayObject, this._navigator.activeScreen);
			Assert.assertStrictlyEquals("activeScreenID returned incorrect value for first tab",
				SCREEN_A_ID, this._navigator.activeScreenID);
			Assert.assertStrictlyEquals("selectedIndex returned incorrect value for first tab",
				0, this._navigator.selectedIndex);
		}

		[Test]
		public function testSetSelectedIndexToNegativeOne():void
		{
			this.addScreenA();
			this._navigator.selectedIndex = -1;
			Assert.assertNull("activeScreen returned incorrect value after selectedIndex = -1",
				this._navigator.activeScreen);
			Assert.assertNull("activeScreenID returned incorrect value after selectedIndex = -1",
				this._navigator.activeScreenID);
			Assert.assertStrictlyEquals("selectedIndex returned incorrect value after selectedIndex = -1",
				-1, this._navigator.selectedIndex);
		}

		[Test]
		public function testChangeSelectedIndex():void
		{
			var hasChanged:Boolean = false;
			this.addScreenA();
			this.addScreenB();
			var newSelectedIndex:int = -1;
			var newActiveScreen:DisplayObject;
			var newActiveScreenID:String;
			this._navigator.addEventListener(Event.CHANGE, function(event:Event):void
			{
				var navigator:TabNavigator = TabNavigator(event.currentTarget);
				newSelectedIndex = navigator.selectedIndex;
				newActiveScreen = navigator.activeScreen;
				newActiveScreenID = navigator.activeScreenID;
				hasChanged = true;
			});
			this._navigator.selectedIndex = 1;
			Assert.assertStrictlyEquals("activeScreen returned incorrect value for second tab after set selectedIndex",
				this._navigator.getScreen(SCREEN_B_ID).screenDisplayObject, newActiveScreen);
			Assert.assertStrictlyEquals("activeScreenID returned incorrect value for second tab after set selectedIndex",
				SCREEN_B_ID, newActiveScreenID);
			Assert.assertStrictlyEquals("selectedIndex returned incorrect value for second tab after set selectedIndex",
				1, newSelectedIndex);
			Assert.assertTrue("Event.CHANGE was not dispatched",
				hasChanged);
		}

		[Test]
		public function testShowScreen():void
		{
			var hasChanged:Boolean = false;
			this.addScreenA();
			this.addScreenB();
			var newSelectedIndex:int = -1;
			var newActiveScreen:DisplayObject;
			var newActiveScreenID:String;
			this._navigator.addEventListener(Event.CHANGE, function(event:Event):void
			{
				var navigator:TabNavigator = TabNavigator(event.currentTarget);
				newSelectedIndex = navigator.selectedIndex;
				newActiveScreen = navigator.activeScreen;
				newActiveScreenID = navigator.activeScreenID;
				hasChanged = true;
			});
			this._navigator.showScreen(SCREEN_B_ID);
			Assert.assertStrictlyEquals("activeScreen returned incorrect value for second tab after showScreen()",
				this._navigator.getScreen(SCREEN_B_ID).screenDisplayObject, newActiveScreen);
			Assert.assertStrictlyEquals("activeScreenID returned incorrect value for second tab after showScreen()",
				SCREEN_B_ID, newActiveScreenID);
			Assert.assertStrictlyEquals("selectedIndex returned incorrect value for second tab after showScreen()",
				1, newSelectedIndex);
			Assert.assertTrue("Event.CHANGE was not dispatched",
				hasChanged);
		}
	}
}
