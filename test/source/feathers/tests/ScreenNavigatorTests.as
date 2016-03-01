package feathers.tests
{
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.events.FeathersEventType;

	import flexunit.framework.Assert;

	import starling.display.Quad;

	public class ScreenNavigatorTests
	{
		private static const SCREEN_A_ID:String = "a";
		private static const SCREEN_B_ID:String = "b";
		
		private static const EVENT_SHOW_SCREEN_B:String = "showScreenB";
		private static const EVENT_CALL_FUNCTION:String = "callFunction";
		
		private var _navigator:ScreenNavigator;
		
		private var _functionWasCalled:Boolean = false;

		[Before]
		public function prepare():void
		{
			this._navigator = new ScreenNavigator();
			TestFeathers.starlingRoot.addChild(this._navigator);
			this._navigator.validate();
			
			this._functionWasCalled = false;
		}

		[After]
		public function cleanup():void
		{
			this._navigator.removeFromParent(true);
			this._navigator = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testHasScreenWhenNotAdded():void
		{
			Assert.assertFalse("hasScreen() incorrectly returned true for a screen that was not added", this._navigator.hasScreen(SCREEN_A_ID));
		}

		[Test]
		public function testHasScreen():void
		{
			this.addScreenA();
			Assert.assertTrue("hasScreen() incorrectly returned false for a screen that was added", this._navigator.hasScreen(SCREEN_A_ID));
		}

		[Test]
		public function testStateWithEmptyStack():void
		{
			Assert.assertNull("activeScreen returned incorrect value for empty ScreenNavigator", this._navigator.activeScreen);
			Assert.assertNull("activeScreenID returned incorrect value for empty ScreenNavigator", this._navigator.activeScreenID);
		}

		[Test]
		public function testShowScreen():void
		{
			this.addScreenA();
			this.addScreenB();
			this._navigator.showScreen(SCREEN_A_ID);
			Assert.assertStrictlyEquals("activeScreen returned incorrect value after showScreen()", this._navigator.getScreen(SCREEN_A_ID).screen, this._navigator.activeScreen);
			Assert.assertStrictlyEquals("activeScreenID returned incorrect value for after showScreen()", SCREEN_A_ID, this._navigator.activeScreenID);
		}

		[Test]
		public function testShowAnotherScreen():void
		{
			this.addScreenA();
			this.addScreenB();
			this._navigator.showScreen(SCREEN_A_ID);
			this._navigator.showScreen(SCREEN_B_ID);
			Assert.assertStrictlyEquals("activeScreen returned incorrect value after two calls to showScreen()", this._navigator.getScreen(SCREEN_B_ID).screen, this._navigator.activeScreen);
			Assert.assertStrictlyEquals("activeScreenID returned incorrect value after two calls to showScreen()", SCREEN_B_ID, this._navigator.activeScreenID);
		}

		[Test]
		public function testClearScreen():void
		{
			this.addScreenA();
			this._navigator.showScreen(SCREEN_A_ID);
			this._navigator.clearScreen();
			Assert.assertNull("activeScreen returned incorrect value for stack after clearScreen()", this._navigator.activeScreen);
			Assert.assertNull("activeScreenID returned incorrect value for stack after clearScreen()", this._navigator.activeScreenID);
		}

		[Test]
		public function testShowScreenWithEvent():void
		{
			this.addScreenA();
			this.addScreenB();
			this._navigator.showScreen(SCREEN_A_ID);
			this._navigator.activeScreen.dispatchEventWith(EVENT_SHOW_SCREEN_B);
			Assert.assertStrictlyEquals("activeScreen returned incorrect value after show screen with event", this._navigator.getScreen(SCREEN_B_ID).screen, this._navigator.activeScreen);
			Assert.assertStrictlyEquals("activeScreenID returned incorrect value after show screen with event", SCREEN_B_ID, this._navigator.activeScreenID);
		}

		[Test]
		public function testCallFunctionWithEvent():void
		{
			this.addScreenA();
			this.addScreenB();
			this._navigator.showScreen(SCREEN_A_ID);
			this._navigator.activeScreen.dispatchEventWith(EVENT_CALL_FUNCTION);
			Assert.assertTrue("Function passed to setFunctionForEvent() was not called after dispatching the event.", this._functionWasCalled);
		}

		[Test]
		public function testRemoveScreenOnTransitionCompleteEvent():void
		{
			this.addScreenA();
			this.addScreenB();
			this._navigator.showScreen(SCREEN_A_ID);
			this._navigator.addEventListener(FeathersEventType.TRANSITION_COMPLETE, removeScreenA);
			this._navigator.showScreen(SCREEN_B_ID);
		}

		[Test]
		public function testScreenWithEventAndMethodWithSameName():void
		{
			var item:ScreenNavigatorItem = new ScreenNavigatorItem(ScreenWithEventAndMethodWithSameName);
			item.setScreenIDForEvent(EVENT_SHOW_SCREEN_B, SCREEN_B_ID);
			this._navigator.addScreen(SCREEN_A_ID, item);
			this._navigator.showScreen(SCREEN_A_ID);
		}
		
		private function addScreenA():void
		{
			var screen:Quad = new Quad(10, 10, 0xff00ff);
			var item:ScreenNavigatorItem = new ScreenNavigatorItem(screen);
			item.setScreenIDForEvent(EVENT_SHOW_SCREEN_B, SCREEN_B_ID);
			item.setFunctionForEvent(EVENT_CALL_FUNCTION, eventFunction);
			this._navigator.addScreen(SCREEN_A_ID, item);
		}

		private function addScreenB():void
		{
			var screen:Quad = new Quad(10, 10, 0xffff00);
			var item:ScreenNavigatorItem = new ScreenNavigatorItem(screen);
			this._navigator.addScreen(SCREEN_B_ID, item);
		}
		
		private function eventFunction():void
		{
			this._functionWasCalled = true;
		}

		private function removeScreenA():void
		{
			this._navigator.removeScreen(SCREEN_A_ID);
		}
	}
}

import starling.display.Quad;

class ScreenWithEventAndMethodWithSameName extends Quad
{
	public function ScreenWithEventAndMethodWithSameName()
	{
		super(10, 10, 0xff00ff);
	}
	
	public function showScreenB():void {}
}