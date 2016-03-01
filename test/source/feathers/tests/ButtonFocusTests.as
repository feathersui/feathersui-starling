package feathers.tests
{
	import feathers.controls.Button;
	import feathers.core.FocusManager;

	import flash.ui.Keyboard;

	import org.flexunit.Assert;

	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.KeyboardEvent;

	public class ButtonFocusTests
	{
		private var _target:Button;

		[Before]
		public function prepare():void
		{
			this._target = new Button();
			this._target.defaultSkin = new Quad(200, 200, 0xff00ff);
			TestFeathers.starlingRoot.addChild(this._target);

			FocusManager.setEnabledForStage(TestFeathers.starlingRoot.stage, true);
		}

		[After]
		public function cleanup():void
		{
			this._target.removeFromParent(true);
			this._target = null;

			FocusManager.setEnabledForStage(TestFeathers.starlingRoot.stage, false);

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
			Assert.assertFalse("FocusManager not disabled on cleanup.", FocusManager.isEnabledForStage(TestFeathers.starlingRoot.stage));
		}

		[Test]
		public function testTriggeredEvent():void
		{
			FocusManager.focus = this._target;
			var hasTriggered:Boolean = false;
			this._target.addEventListener(Event.TRIGGERED, function(event:Event):void
			{
				hasTriggered = true;
			});
			this._target.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, 0, Keyboard.SPACE));
			this._target.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, 0, Keyboard.SPACE));
			Assert.assertTrue("Event.TRIGGERED was not dispatched", hasTriggered);
		}

		[Test]
		public function testDisabled():void
		{
			this._target.isEnabled = false;
			this._target.validate();
			FocusManager.focus = this._target;

			var hasTriggered:Boolean = false;
			this._target.addEventListener(Event.TRIGGERED, function(event:Event):void
			{
				hasTriggered = true;
			});
			this._target.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, 0, Keyboard.SPACE));
			this._target.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, 0, Keyboard.SPACE));
			Assert.assertFalse("Event.TRIGGERED was incorrectly dispatched when disabled", hasTriggered);
		}

		[Test]
		public function testCancelKeyBeforeTriggeredEvent():void
		{
			FocusManager.focus = this._target;
			var hasTriggered:Boolean = false;
			this._target.addEventListener(Event.TRIGGERED, function(event:Event):void
			{
				hasTriggered = true;
			});
			this._target.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, 0, Keyboard.SPACE));
			this._target.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, 0, Keyboard.ESCAPE));
			this._target.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, 0, Keyboard.ESCAPE));
			this._target.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, 0, Keyboard.SPACE));
			Assert.assertFalse("Event.TRIGGERED was incorrectly dispatched when touch moved out of bounds", hasTriggered);
		}
	}
}
