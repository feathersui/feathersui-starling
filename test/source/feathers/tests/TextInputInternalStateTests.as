package feathers.tests
{
	import feathers.controls.TextInput;
	import feathers.core.FocusManager;
	import feathers.events.FeathersEventType;

	import org.flexunit.Assert;

	import starling.display.Quad;

	public class TextInputInternalStateTests
	{
		private var _input:TextInputWithInternalState;

		[Before]
		public function prepare():void
		{
			FocusManager.setEnabledForStage(TestFeathers.starlingRoot.stage, true);
			
			this._input = new TextInputWithInternalState();
			TestFeathers.starlingRoot.addChild(this._input);
		}

		[After]
		public function cleanup():void
		{
			this._input.removeFromParent(true);
			this._input = null;

			FocusManager.setEnabledForStage(TestFeathers.starlingRoot.stage, false);

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testGetSkinForStateWithoutSetSkinForState():void
		{
			Assert.assertNull("TextInput getSkinForState(TextInputState.ENABLED) must be null when setIconForState() is not called", this._input.getSkinForState(TextInput.STATE_FOCUSED));
			Assert.assertNull("TextInput getSkinForState(TextInputState.DISABLED) must be null when setIconForState() is not called", this._input.getSkinForState(TextInput.STATE_DISABLED));
			Assert.assertNull("TextInput getSkinForState(TextInputState.FOCUSED) must be null when setIconForState() is not called", this._input.getSkinForState(TextInput.STATE_FOCUSED));
		}

		[Test]
		public function testGetSkinForState():void
		{
			var backgroundSkin:Quad = new Quad(200, 200);
			this._input.backgroundSkin = backgroundSkin;

			var enabledSkin:Quad = new Quad(200, 200);
			this._input.setSkinForState(TextInput.STATE_ENABLED, enabledSkin);

			var disabledSkin:Quad = new Quad(200, 200);
			this._input.setSkinForState(TextInput.STATE_DISABLED, disabledSkin);

			var focusedSkin:Quad = new Quad(200, 200);
			this._input.setSkinForState(TextInput.STATE_FOCUSED, focusedSkin);

			Assert.assertStrictlyEquals("TextInput getSkinForState(TextInputState.ENABLED) does not match value passed to setSkinForState()", enabledSkin, this._input.getSkinForState(TextInput.STATE_ENABLED));
			Assert.assertStrictlyEquals("TextInput getSkinForState(TextInputState.DISABLED) does not match value passed to setSkinForState()", disabledSkin, this._input.getSkinForState(TextInput.STATE_DISABLED));
			Assert.assertStrictlyEquals("TextInput getSkinForState(TextInputState.DISABLED) does not match value passed to setSkinForState()", focusedSkin, this._input.getSkinForState(TextInput.STATE_FOCUSED));
		}

		[Test]
		public function testDefaultCurrentBackground():void
		{
			var backgroundSkin:Quad = new Quad(200, 200);
			this._input.backgroundSkin = backgroundSkin;

			this._input.validate();
			Assert.assertStrictlyEquals("TextInput state is not TextInputState.ENABLED by default", TextInput.STATE_ENABLED, this._input.currentState);
			Assert.assertStrictlyEquals("TextInput background is not backgroundSkin when currentState is TextInputState.ENABLED and background not provided for this state", backgroundSkin, this._input.currentBackgroundInternal);

			this._input.isEnabled = false;
			this._input.validate();
			Assert.assertStrictlyEquals("TextInput state is not TextInputState.DISABLED when isEnabled is false", TextInput.STATE_DISABLED, this._input.currentState);
			Assert.assertStrictlyEquals("TextInput background is not backgroundSkin when currentState is TextInputState.DISABLED and background not provided for this state", backgroundSkin, this._input.currentBackgroundInternal);

			this._input.isEnabled = true;
			FocusManager.focus = this._input;
			this._input.validate();
			Assert.assertStrictlyEquals("TextInput state is not TextInputState.FOCUSED when input is focused", TextInput.STATE_FOCUSED, this._input.currentState);
			Assert.assertStrictlyEquals("TextInput background is not backgroundSkin when currentState is TextInputState.FOCUSED and background not provided for this state", backgroundSkin, this._input.currentBackgroundInternal);
		}

		[Test]
		public function testCurrentSkinWithSetSkinForState():void
		{
			var backgroundSkin:Quad = new Quad(200, 200);
			this._input.backgroundSkin = backgroundSkin;

			var backgroundEnabledSkin:Quad = new Quad(200, 200);
			this._input.setSkinForState(TextInput.STATE_ENABLED, backgroundEnabledSkin);

			var backgroundDisabledSkin:Quad = new Quad(200, 200);
			this._input.setSkinForState(TextInput.STATE_DISABLED, backgroundDisabledSkin);

			var backgroundFocusedSkin:Quad = new Quad(200, 200);
			this._input.setSkinForState(TextInput.STATE_FOCUSED, backgroundFocusedSkin);

			this._input.validate();
			Assert.assertStrictlyEquals("TextInput state is not TextInputState.ENABLED by default", TextInput.STATE_ENABLED, this._input.currentState);
			Assert.assertStrictlyEquals("TextInput background is not backgroundEnabledSkin when currentState is TextInputState.ENABLED", backgroundEnabledSkin, this._input.currentBackgroundInternal);

			this._input.isEnabled = false;
			this._input.validate();
			Assert.assertStrictlyEquals("TextInput state is not TextInputState.DISABLED when isEnabled is false", TextInput.STATE_DISABLED, this._input.currentState);
			Assert.assertStrictlyEquals("TextInput background is not backgroundDisabledSkin when currentState is TextInputState.DISABLED", backgroundDisabledSkin, this._input.currentBackgroundInternal);

			this._input.isEnabled = true;
			FocusManager.focus = this._input;
			this._input.validate();
			Assert.assertStrictlyEquals("TextInput state is not TextInputState.FOCUSED when input is focused", TextInput.STATE_FOCUSED, this._input.currentState);
			Assert.assertStrictlyEquals("TextInput background is not backgroundFocusedSkin when currentState is TextInputState.FOCUSED", backgroundFocusedSkin, this._input.currentBackgroundInternal);
		}
		
		[Test]
		public function testGetIconForStateWithoutSetIconForState():void
		{
			Assert.assertNull("TextInput getIconForState(TextInputState.ENABLED) must be null when setIconForState() is not called", this._input.getIconForState(TextInput.STATE_FOCUSED));
			Assert.assertNull("TextInput getIconForState(TextInputState.DISABLED) must be null when setIconForState() is not called", this._input.getIconForState(TextInput.STATE_DISABLED));
			Assert.assertNull("TextInput getIconForState(TextInputState.FOCUSED) must be null when setIconForState() is not called", this._input.getIconForState(TextInput.STATE_FOCUSED));
		}

		[Test]
		public function testGetIconForState():void
		{
			var defaultIcon:Quad = new Quad(200, 200);
			this._input.defaultIcon = defaultIcon;

			var enabledIcon:Quad = new Quad(200, 200);
			this._input.setIconForState(TextInput.STATE_ENABLED, enabledIcon);

			var disabledIcon:Quad = new Quad(200, 200);
			this._input.setIconForState(TextInput.STATE_DISABLED, disabledIcon);

			var focusedIcon:Quad = new Quad(200, 200);
			this._input.setIconForState(TextInput.STATE_FOCUSED, focusedIcon);

			Assert.assertStrictlyEquals("TextInput getIconForState(TextInputState.ENABLED) does not match value passed to setIconForState()", enabledIcon, this._input.getIconForState(TextInput.STATE_ENABLED));
			Assert.assertStrictlyEquals("TextInput getIconForState(TextInputState.DISABLED) does not match value passed to setIconForState()", disabledIcon, this._input.getIconForState(TextInput.STATE_DISABLED));
			Assert.assertStrictlyEquals("TextInput getIconForState(TextInputState.FOCUSED) does not match value passed to setIconForState()", focusedIcon, this._input.getIconForState(TextInput.STATE_FOCUSED));
		}

		[Test]
		public function testDefaultCurrentIcon():void
		{
			var defaultIcon:Quad = new Quad(200, 200);
			this._input.defaultIcon = defaultIcon;

			this._input.validate();
			Assert.assertStrictlyEquals("TextInput state is not TextInputState.ENABLED by default", TextInput.STATE_ENABLED, this._input.currentState);
			Assert.assertStrictlyEquals("TextInput icon is not defaultIcon when currentState is TextInputState.ENABLED and icon not provided for this state", defaultIcon, this._input.currentIconInternal);

			this._input.isEnabled = false;
			this._input.validate();
			Assert.assertStrictlyEquals("TextInput state is not TextInputState.DISABLED when isEnabled is false", TextInput.STATE_DISABLED, this._input.currentState);
			Assert.assertStrictlyEquals("TextInput icon is not defaultIcon when currentState is TextInputState.DISABLED and icon not provided for this state", defaultIcon, this._input.currentIconInternal);

			this._input.isEnabled = true;
			FocusManager.focus = this._input;
			this._input.validate();
			Assert.assertStrictlyEquals("TextInput state is not TextInputState.FOCUSED when input is focused", TextInput.STATE_FOCUSED, this._input.currentState);
			Assert.assertStrictlyEquals("TextInput icon is not defaultIcon when currentState is TextInputState.FOCUSED and icon not provided for this state", defaultIcon, this._input.currentIconInternal);
		}

		[Test]
		public function testCurrentIconWithSetIconForState():void
		{
			var defaultIcon:Quad = new Quad(200, 200);
			this._input.defaultIcon = defaultIcon;

			var enabledIcon:Quad = new Quad(200, 200);
			this._input.setIconForState(TextInput.STATE_ENABLED, enabledIcon);

			var disabledIcon:Quad = new Quad(200, 200);
			this._input.setIconForState(TextInput.STATE_DISABLED, disabledIcon);

			var focusedIcon:Quad = new Quad(200, 200);
			this._input.setIconForState(TextInput.STATE_FOCUSED, focusedIcon);

			this._input.validate();
			Assert.assertStrictlyEquals("TextInput state is not TextInputState.ENABLED by default", TextInput.STATE_ENABLED, this._input.currentState);
			Assert.assertStrictlyEquals("TextInput icon is not enabledIcon when currentState is TextInputState.ENABLED", enabledIcon, this._input.currentIconInternal);

			this._input.isEnabled = false;
			this._input.validate();
			Assert.assertStrictlyEquals("TextInput state is not TextInputState.DISABLED when isEnabled is false", TextInput.STATE_DISABLED, this._input.currentState);
			Assert.assertStrictlyEquals("TextInput icon is not disabledIcon when currentState is TextInputState.DISABLED", disabledIcon, this._input.currentIconInternal);

			this._input.isEnabled = true;
			FocusManager.focus = this._input;
			this._input.validate();
			Assert.assertStrictlyEquals("TextInput state is not TextInputState.FOCUSED when input is focused", TextInput.STATE_FOCUSED, this._input.currentState);
			Assert.assertStrictlyEquals("TextInput icon is not focusedIcon when currentState is TextInputState.FOCUSED", focusedIcon, this._input.currentIconInternal);
		}
	}
}

import feathers.controls.TextInput;

import starling.display.DisplayObject;

class TextInputWithInternalState extends TextInput
{
	public function TextInputWithInternalState()
	{
		super();
	}

	public function get currentBackgroundInternal():DisplayObject
	{
		return this.currentBackground;
	}

	public function get currentIconInternal():DisplayObject
	{
		return this.currentIcon;
	}
}