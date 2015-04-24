package feathers.tests
{
	import feathers.controls.Button;
	import feathers.core.FocusManager;
	import feathers.events.FeathersEventType;

	import org.flexunit.Assert;

	import starling.display.Quad;
	import starling.events.Event;

	public class FocusManagerTests
	{
		private var _button:Button;
		
		[Before]
		public function prepare():void
		{
			FocusManager.setEnabledForStage(TestFeathers.starlingRoot.stage, true);
			
			this._button = new Button();
			this._button.label = "Click Me";
			this._button.defaultSkin = new Quad(200, 200);
			TestFeathers.starlingRoot.addChild(this._button);
		}
		
		[After]
		public function cleanup():void
		{
			this._button.removeFromParent(true);
			this._button = null;
			FocusManager.setEnabledForStage(TestFeathers.starlingRoot.stage, false);
		}

		[Test]
		public function testInjectFocusManager():void
		{
			Assert.assertFalse("focusManager property incorrectly returns null", this._button.focusManager === null);
			Assert.assertStrictlyEquals("focusManager property does not match getFocusManagerForStage()", this._button.focusManager, FocusManager.getFocusManagerForStage(this._button.stage));
		}

		[Test]
		public function testChangeFocus():void
		{
			this._button.focusManager.focus = this._button;
			Assert.assertStrictlyEquals("Wrong value returned by focus property of FocusManager", this._button.focusManager.focus, this._button);
		}

		[Test]
		public function testDispatchFocusInEvent():void
		{
			var hasDispatchedFocusIn:Boolean = false;
			this._button.addEventListener(FeathersEventType.FOCUS_IN, function(event:Event):void
			{
				hasDispatchedFocusIn = true;
			});
			this._button.focusManager.focus = this._button;
			Assert.assertTrue("FeathersEventType.FOCUS_IN was not dispatched after setting focus property of FocusManager", hasDispatchedFocusIn);
		}

		[Test]
		public function testDispatchFocusOutEvent():void
		{
			var hasDispatchedFocusOut:Boolean = false;
			this._button.addEventListener(FeathersEventType.FOCUS_OUT, function(event:Event):void
			{
				hasDispatchedFocusOut = true;
			});
			this._button.focusManager.focus = this._button;
			this._button.focusManager.focus = null;
			Assert.assertTrue("FeathersEventType.FOCUS_OUT was not dispatched after setting focus property of FocusManager", hasDispatchedFocusOut);
		}

		[Test]
		public function testFocusPropertyInFocusInEventListener():void
		{
			var hasCorrectFocus:Boolean = false;
			this._button.addEventListener(FeathersEventType.FOCUS_IN, function(event:Event):void
			{
				var button:Button = Button(event.currentTarget);
				hasCorrectFocus = button.focusManager.focus === button;
			});
			this._button.focusManager.focus = this._button;
			Assert.assertTrue("The focus property of the FocusManager is not updated before calling listener for FeathersEventType.FOCUS_IN event", hasCorrectFocus);
		}

		[Test]
		public function testFocusPropertyInFocusOutEventListener():void
		{
			var hasDifferentFocus:Boolean = false;
			this._button.addEventListener(FeathersEventType.FOCUS_OUT, function(event:Event):void
			{
				var button:Button = Button(event.currentTarget);
				hasDifferentFocus = button.focusManager.focus !== button;
			});
			this._button.focusManager.focus = this._button;
			this._button.focusManager.focus = null;
			Assert.assertTrue("The focus property of the FocusManager is not updated before calling listener for FeathersEventType.FOCUS_OUT event", hasDifferentFocus);
		}
	}
}
