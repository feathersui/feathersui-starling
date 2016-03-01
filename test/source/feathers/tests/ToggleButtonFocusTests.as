package feathers.tests
{
	import feathers.controls.ToggleButton;
	import feathers.core.FocusManager;

	import flash.ui.Keyboard;

	import org.flexunit.Assert;

	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.KeyboardEvent;

	public class ToggleButtonFocusTests
	{
		private var _target:ToggleButton;

		[Before]
		public function prepare():void
		{
			this._target = new ToggleButton();
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
			this._target.isEnabled = false;
			this._target.validate();
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
			this._target.isSelected = true;
			this._target.validate();
			FocusManager.focus = this._target;

			this._target.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, 0, Keyboard.SPACE));
			this._target.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, 0, Keyboard.SPACE));
			Assert.assertFalse("isSelected was not changed to false when deselected with keyboard", this._target.isSelected);
		}
	}
}
