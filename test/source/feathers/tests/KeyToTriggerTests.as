package feathers.tests
{
	import feathers.core.FocusManager;
	import feathers.tests.supportClasses.CustomToggle;
	import feathers.utils.keyboard.KeyToTrigger;

	import flash.ui.Keyboard;

	import org.flexunit.Assert;

	import starling.display.Stage;
	import starling.events.Event;
	import starling.events.KeyboardEvent;

	public class KeyToTriggerTests
	{
		private var _target:CustomToggle;
		private var _keyToTrigger:KeyToTrigger;

		[Before]
		public function prepare():void
		{
			this._target = new CustomToggle();
			this._target.setSize(200, 200);
			TestFeathers.starlingRoot.addChild(this._target);

			this._keyToTrigger = new KeyToTrigger(this._target);

			FocusManager.setEnabledForStage(TestFeathers.starlingRoot.stage, true);
		}

		[After]
		public function cleanup():void
		{
			this._target.removeFromParent(true);
			this._target = null;

			this._keyToTrigger = null;

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
			this._keyToTrigger.isEnabled = false;
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
		public function testNoErrorWhenDisabledAfterRemove():void
		{
			this._target.removeFromParent(false);
			this._keyToTrigger.isEnabled = false;
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

		[Test]
		public function testRemovedBeforeTriggeredEvent():void
		{
			var hasTriggered:Boolean = false;
			this._target.addEventListener(Event.TRIGGERED, function(event:Event):void
			{
				hasTriggered = true;
			});

			var stage:Stage = this._target.stage;
			stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, 0, Keyboard.SPACE));

			this._target.removeFromParent(false);

			stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, 0, Keyboard.SPACE));

			//while it's good to check that Event.TRIGGERED isn't dispatched,
			//this test also ensures that no runtime errors are thrown after the
			//target is removed (its stage property is null, and that may be
			//used by KeyToTrigger)
			Assert.assertFalse("Event.TRIGGERED was incorrectly dispatched when target was removed", hasTriggered);
		}
	}
}
