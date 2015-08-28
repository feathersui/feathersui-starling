package feathers.tests
{
	import feathers.controls.Button;
	import feathers.core.FocusManager;
	import feathers.core.PopUpManager;

	import flexunit.framework.Assert;

	import starling.display.Quad;

	public class PopUpManagerFocusManagerTests
	{
		private var _button1:Button;
		private var _button2:Button;

		[Before]
		public function prepare():void
		{
			FocusManager.setEnabledForStage(TestFeathers.starlingRoot.stage, true);
		}

		[After]
		public function cleanup():void
		{
			if(this._button1)
			{
				this._button1.removeFromParent(true);
				this._button1 = null;
			}
			if(this._button2)
			{
				this._button2.removeFromParent(true);
				this._button2 = null;
			}
			
			FocusManager.setEnabledForStage(TestFeathers.starlingRoot.stage, false);

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testPopUpHasNonNullFocusManager():void
		{
			this.createButton1();
			PopUpManager.addPopUp(this._button1, true);

			Assert.assertNotNull("Modal pop-up must have focus manager.", this._button1.focusManager);
		}

		[Test]
		public function testPopUpHasDifferentFocusManager():void
		{
			this.createButton1();
			TestFeathers.starlingRoot.addChild(this._button1);

			this.createButton2();
			PopUpManager.addPopUp(this._button2, true);
			
			Assert.assertFalse("Modal pop-up must have different focus manager.", this._button1.focusManager === this._button2.focusManager);
		}

		[Test]
		public function testHasFocusManagerOnChildAddedUnderPopUp():void
		{
			this.createButton1();
			PopUpManager.addPopUp(this._button1, true);
			
			this.createButton2();
			TestFeathers.starlingRoot.addChild(this._button2);
			
			this._button1.removeFromParent(true);
			this._button1 = null;

			Assert.assertNotNull("Component added under modal pop-up must have focus manager after removing pop-up.", this._button2.focusManager);
		}
		
		private function createButton1():void
		{
			this._button1 = new Button();
			this._button1.label = "Click Me";
			this._button1.defaultSkin = new Quad(200, 200);
		}

		private function createButton2():void
		{
			this._button2 = new Button();
			this._button2.label = "Click Me Too";
			this._button2.defaultSkin = new Quad(200, 200);
			this._button2.y = 210;
		}
	}
}
