package feathers.tests
{
	import feathers.core.FocusManager;
	import feathers.tests.supportClasses.CustomToggle;
	import feathers.utils.keyboard.KeyToSelect;

	import flash.ui.Keyboard;

	import org.flexunit.Assert;

	import starling.display.Stage;

	import starling.events.Event;
	import starling.events.KeyboardEvent;

	public class KeyToSelectTests
	{
		private var _target:CustomToggle;
		private var _keyToSelect:KeyToSelect;

		[Before]
		public function prepare():void
		{
			this._target = new CustomToggle();
			TestFeathers.starlingRoot.addChild(this._target);
			this._target.validate();
			
			FocusManager.setEnabledForStage(TestFeathers.starlingRoot.stage, true);

			this._keyToSelect = new KeyToSelect(this._target);
		}

		[After]
		public function cleanup():void
		{
			this._target.removeFromParent(true);
			this._target = null;

			this._keyToSelect = null;

			FocusManager.setEnabledForStage(TestFeathers.starlingRoot.stage, false);

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
			Assert.assertFalse("FocusManager not disabled on cleanup.", FocusManager.isEnabledForStage(TestFeathers.starlingRoot.stage));
		}

		[Test]
		public function testIgnoreKeyAfterFocusOut():void
		{
			this._target.isSelected = false;
			FocusManager.focus = this._target;
			FocusManager.focus = null;

			var hasChanged:Boolean = false;
			this._target.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._target.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, 0, Keyboard.SPACE));
			this._target.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, 0, Keyboard.SPACE));
			Assert.assertFalse("Event.CHANGE was incorrectly dispatched", hasChanged);
			Assert.assertFalse("isSelected was incorrectly changed to true after key to select when not in focus", this._target.isSelected);
		}

		[Test]
		public function testChangeEvent():void
		{
			this._target.isSelected = false;
			FocusManager.focus = this._target;

			var hasChanged:Boolean = false;
			this._target.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._target.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, 0, Keyboard.SPACE));
			this._target.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, 0, Keyboard.SPACE));
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertTrue("isSelected was not changed to true after key to select", this._target.isSelected);
		}

		[Test]
		public function testDisabled():void
		{
			this._target.isSelected = false;
			this._keyToSelect.isEnabled = false;
			FocusManager.focus = this._target;

			var hasChanged:Boolean = false;
			this._target.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._target.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, 0, Keyboard.SPACE));
			this._target.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, 0, Keyboard.SPACE));
			Assert.assertFalse("Event.CHANGE was incorrectly dispatched when disabled", hasChanged);
			Assert.assertFalse("isSelected was incorrectly changed to true after key to select when disabled", this._target.isSelected);
		}

		[Test]
		public function testNoErrorWhenDisabledAfterRemove():void
		{
			this._target.removeFromParent(false);
			this._keyToSelect.isEnabled = false;
		}

		[Test]
		public function testCancelKeyBeforeChangeEvent():void
		{
			this._target.isSelected = false;
			FocusManager.focus = this._target;

			var hasChanged:Boolean = false;
			this._target.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._target.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, 0, Keyboard.SPACE));
			this._target.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, 0, Keyboard.ESCAPE));
			this._target.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, 0, Keyboard.ESCAPE));
			this._target.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, 0, Keyboard.SPACE));
			Assert.assertFalse("Event.CHANGE was incorrectly dispatched after cancel key", hasChanged);
			Assert.assertFalse("isSelected was incorrectly changed to true after cancel key", this._target.isSelected);
		}

		[Test]
		public function testDeselect():void
		{
			this._keyToSelect.keyToDeselect = true;
			this._target.isSelected = true;
			FocusManager.focus = this._target;
			
			this._target.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, 0, Keyboard.SPACE));
			this._target.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, 0, Keyboard.SPACE));
			Assert.assertFalse("isSelected was not changed to false when keyToDeselect set to true", this._target.isSelected);
		}

		[Test]
		public function testDisabledDeselect():void
		{
			this._keyToSelect.keyToDeselect = false;
			this._target.isSelected = true;
			FocusManager.focus = this._target;
			
			this._target.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, 0, Keyboard.SPACE));
			this._target.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, 0, Keyboard.SPACE));
			Assert.assertTrue("isSelected was incorrectly changed to false when keyToDeselect set to false", this._target.isSelected);
		}

		[Test]
		public function testRemovedBeforeTriggeredEvent():void
		{
			this._target.isSelected = false;

			var hasChanged:Boolean = false;
			this._target.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});

			var stage:Stage = this._target.stage;
			stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, 0, Keyboard.SPACE));

			this._target.removeFromParent(false);

			stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, 0, Keyboard.SPACE));

			//while it's good to check that Event.CHANGE isn't dispatched,
			//this test also ensures that no runtime errors are thrown after the
			//target is removed (its stage property is null, and that is used
			//by KeyToSelect)

			Assert.assertFalse("Event.CHANGE was incorrectly dispatched when target was removed", hasChanged);
			Assert.assertFalse("isSelected was incorrectly changed to true when target was removed", this._target.isSelected);
		}
	}
}
