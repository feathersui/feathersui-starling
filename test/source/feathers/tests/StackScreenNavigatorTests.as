package feathers.tests
{
	import feathers.controls.StackScreenNavigator;
	import feathers.controls.StackScreenNavigatorItem;

	import flexunit.framework.Assert;

	import starling.display.Quad;

	public class StackScreenNavigatorTests
	{
		private static const SCREEN_A_ID:String = "a";
		private static const SCREEN_B_ID:String = "b";
		private static const SCREEN_C_ID:String = "c";
		
		private var _navigator:StackScreenNavigator;

		[Before]
		public function prepare():void
		{
			this._navigator = new StackScreenNavigator();
			TestFeathers.starlingRoot.addChild(this._navigator);
			this._navigator.validate();
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
		public function testActiveScreenWithEmptyStack():void
		{
			Assert.assertNull("activeScreen returned incorrect value for empty stack", this._navigator.activeScreen);
			Assert.assertNull("activeScreenID returned incorrect value for empty stack", this._navigator.activeScreenID);
		}

		[Test]
		public function testActiveScreenWithRootScreen():void
		{
			this.addScreenA();
			this._navigator.rootScreenID = SCREEN_A_ID;
			Assert.assertStrictlyEquals("activeScreen returned incorrect value for stack with only root screen", this._navigator.getScreen(SCREEN_A_ID).screen, this._navigator.activeScreen);
			Assert.assertStrictlyEquals("activeScreenID returned incorrect value for stack with only root screen", SCREEN_A_ID, this._navigator.activeScreenID);
		}

		[Test]
		public function testActiveScreenAfterPush():void
		{
			this.addScreenA();
			this.addScreenB();
			this._navigator.rootScreenID = SCREEN_A_ID;
			this._navigator.pushScreen(SCREEN_B_ID);
			Assert.assertStrictlyEquals("activeScreen returned incorrect value for stack with pushed screen", this._navigator.getScreen(SCREEN_B_ID).screen, this._navigator.activeScreen);
			Assert.assertStrictlyEquals("activeScreenID returned incorrect value for stack with pushed screen", SCREEN_B_ID, this._navigator.activeScreenID);
		}

		[Test]
		public function testActiveScreenAfterReplace():void
		{
			this.addScreenA();
			this.addScreenB();
			this.addScreenC();
			this._navigator.rootScreenID = SCREEN_A_ID;
			this._navigator.pushScreen(SCREEN_B_ID);
			this._navigator.replaceScreen(SCREEN_C_ID);
			Assert.assertStrictlyEquals("activeScreen returned incorrect value for stack with replaced screen", this._navigator.getScreen(SCREEN_C_ID).screen, this._navigator.activeScreen);
			Assert.assertStrictlyEquals("activeScreenID returned incorrect value for stack with replaced screen", SCREEN_C_ID, this._navigator.activeScreenID);
		}

		[Test]
		public function testActiveScreenAfterPop():void
		{
			this.addScreenA();
			this.addScreenB();
			this._navigator.rootScreenID = SCREEN_A_ID;
			this._navigator.pushScreen(SCREEN_B_ID);
			this._navigator.popScreen();
			Assert.assertStrictlyEquals("activeScreen returned incorrect value for stack with popped screen", this._navigator.getScreen(SCREEN_A_ID).screen, this._navigator.activeScreen);
			Assert.assertStrictlyEquals("activeScreenID returned incorrect value for stack with popped screen", SCREEN_A_ID, this._navigator.activeScreenID);
		}

		[Test]
		public function testActiveScreenAfterPopToRoot():void
		{
			this.addScreenA();
			this.addScreenB();
			this.addScreenC();
			this._navigator.rootScreenID = SCREEN_A_ID;
			this._navigator.pushScreen(SCREEN_B_ID);
			this._navigator.pushScreen(SCREEN_C_ID);
			this._navigator.popToRootScreen();
			Assert.assertStrictlyEquals("activeScreen returned incorrect value for stack after pop to root", this._navigator.getScreen(SCREEN_A_ID).screen, this._navigator.activeScreen);
			Assert.assertStrictlyEquals("activeScreenID returned incorrect value for stack after pop to root", SCREEN_A_ID, this._navigator.activeScreenID);
		}

		[Test]
		public function testStackCountWithEmptyStack():void
		{
			Assert.assertStrictlyEquals("stackCount returned incorrect value for empty stack", 0, this._navigator.stackCount);
		}

		[Test]
		public function testStackCountWithRootScreen():void
		{
			this.addScreenA();
			this._navigator.rootScreenID = SCREEN_A_ID;
			Assert.assertStrictlyEquals("stackCount returned incorrect value for stack with only root screen", 1, this._navigator.stackCount);
		}

		[Test]
		public function testStackCountAfterPush():void
		{
			this.addScreenA();
			this.addScreenB();
			this._navigator.rootScreenID = SCREEN_A_ID;
			this._navigator.pushScreen(SCREEN_B_ID);
			Assert.assertStrictlyEquals("stackCount returned incorrect value for stack with root screen and pushed screen", 2, this._navigator.stackCount);
		}

		[Test]
		public function testStackCountAfterReplace():void
		{
			this.addScreenA();
			this.addScreenB();
			this.addScreenC();
			this._navigator.rootScreenID = SCREEN_A_ID;
			this._navigator.pushScreen(SCREEN_B_ID);
			this._navigator.replaceScreen(SCREEN_C_ID);
			Assert.assertStrictlyEquals("stackCount returned incorrect value for stack with replaced screen", 2, this._navigator.stackCount);
		}

		[Test]
		public function testStackCountAfterPop():void
		{
			this.addScreenA();
			this.addScreenB();
			this._navigator.rootScreenID = SCREEN_A_ID;
			this._navigator.pushScreen(SCREEN_B_ID);
			this._navigator.popScreen();
			Assert.assertStrictlyEquals("stackCount returned incorrect value for stack with popped screen", 1, this._navigator.stackCount);
		}

		[Test]
		public function testStackCountAfterPopToRoot():void
		{
			this.addScreenA();
			this.addScreenB();
			this.addScreenC();
			this._navigator.rootScreenID = SCREEN_A_ID;
			this._navigator.pushScreen(SCREEN_B_ID);
			this._navigator.pushScreen(SCREEN_C_ID);
			this._navigator.popToRootScreen();
			Assert.assertStrictlyEquals("stackCount returned incorrect value for stack after pop to root", 1, this._navigator.stackCount);
		}
		
		private function addScreenA():void
		{
			var screen:Quad = new Quad(10, 10, 0xff00ff);
			var item:StackScreenNavigatorItem = new StackScreenNavigatorItem(screen);
			this._navigator.addScreen(SCREEN_A_ID, item);
		}

		private function addScreenB():void
		{
			var screen:Quad = new Quad(10, 10, 0xffff00);
			var item:StackScreenNavigatorItem = new StackScreenNavigatorItem(screen);
			this._navigator.addScreen(SCREEN_B_ID, item);
		}

		private function addScreenC():void
		{
			var screen:Quad = new Quad(10, 10, 0x00ffff);
			var item:StackScreenNavigatorItem = new StackScreenNavigatorItem(screen);
			this._navigator.addScreen(SCREEN_C_ID, item);
		}
	}
}
