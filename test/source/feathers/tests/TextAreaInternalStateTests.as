package feathers.tests
{
	import feathers.controls.TextInput;
	import feathers.controls.TextInputState;
	import feathers.core.FocusManager;
	import feathers.events.FeathersEventType;

	import org.flexunit.Assert;

	import starling.display.Quad;

	public class TextAreaInternalStateTests
	{
		private var _textArea:TextAreaWithInternalState;

		[Before]
		public function prepare():void
		{
			FocusManager.setEnabledForStage(TestFeathers.starlingRoot.stage, true);

			this._textArea = new TextAreaWithInternalState();
			TestFeathers.starlingRoot.addChild(this._textArea);
		}

		[After]
		public function cleanup():void
		{
			this._textArea.removeFromParent(true);
			this._textArea = null;

			FocusManager.setEnabledForStage(TestFeathers.starlingRoot.stage, false);

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testGetSkinForStateWithoutSetSkinForState():void
		{
			Assert.assertNull("TextInput getSkinForState(TextInputState.ENABLED) must be null when setSkinForState() is not called", this._textArea.getSkinForState(TextInputState.FOCUSED));
			Assert.assertNull("TextInput getSkinForState(TextInputState.DISABLED) must be null when setSkinForState() is not called", this._textArea.getSkinForState(TextInputState.DISABLED));
			Assert.assertNull("TextInput getSkinForState(TextInputState.FOCUSED) must be null when setSkinForState() is not called", this._textArea.getSkinForState(TextInputState.FOCUSED));
			Assert.assertNull("TextInput getSkinForState(TextInputState.ERROR) must be null when setSkinForState() is not called", this._textArea.getSkinForState(TextInputState.ERROR));
		}

		[Test]
		public function testGetSkinForState():void
		{
			var backgroundSkin:Quad = new Quad(200, 200);
			this._textArea.backgroundSkin = backgroundSkin;

			var enabledSkin:Quad = new Quad(200, 200);
			this._textArea.setSkinForState(TextInputState.ENABLED, enabledSkin);

			var disabledSkin:Quad = new Quad(200, 200);
			this._textArea.setSkinForState(TextInputState.DISABLED, disabledSkin);

			var focusedSkin:Quad = new Quad(200, 200);
			this._textArea.setSkinForState(TextInputState.FOCUSED, focusedSkin);

			var errorSkin:Quad = new Quad(200, 200);
			this._textArea.setSkinForState(TextInputState.ERROR, errorSkin);

			Assert.assertStrictlyEquals("TextInput getSkinForState(TextInputState.ENABLED) does not match value passed to setSkinForState()", enabledSkin, this._textArea.getSkinForState(TextInputState.ENABLED));
			Assert.assertStrictlyEquals("TextInput getSkinForState(TextInputState.DISABLED) does not match value passed to setSkinForState()", disabledSkin, this._textArea.getSkinForState(TextInputState.DISABLED));
			Assert.assertStrictlyEquals("TextInput getSkinForState(TextInputState.FOCUSED) does not match value passed to setSkinForState()", focusedSkin, this._textArea.getSkinForState(TextInputState.FOCUSED));
			Assert.assertStrictlyEquals("TextInput getSkinForState(TextInputState.ERROR) does not match value passed to setSkinForState()", errorSkin, this._textArea.getSkinForState(TextInputState.ERROR));
		}

		[Test]
		public function testDefaultCurrentBackground():void
		{
			var backgroundSkin:Quad = new Quad(200, 200);
			this._textArea.backgroundSkin = backgroundSkin;

			this._textArea.validate();
			Assert.assertStrictlyEquals("TextInput state is not TextInputState.ENABLED by default", TextInputState.ENABLED, this._textArea.currentState);
			Assert.assertStrictlyEquals("TextInput background is not backgroundSkin when currentState is TextInputState.ENABLED and background not provided for this state", backgroundSkin, this._textArea.currentBackgroundInternal);

			this._textArea.errorString = "Error";
			this._textArea.validate();
			Assert.assertStrictlyEquals("TextInput state is not TextInputState.ERROR when errorString is not null", TextInputState.ERROR, this._textArea.currentState);
			Assert.assertStrictlyEquals("TextInput background is not backgroundSkin when currentState is TextInputState.ENABLED and background not provided for this state", backgroundSkin, this._textArea.currentBackgroundInternal);
			this._textArea.errorString = null;

			this._textArea.isEnabled = false;
			this._textArea.validate();
			Assert.assertStrictlyEquals("TextInput state is not TextInputState.DISABLED when isEnabled is false", TextInputState.DISABLED, this._textArea.currentState);
			Assert.assertStrictlyEquals("TextInput background is not backgroundSkin when currentState is TextInputState.DISABLED and background not provided for this state", backgroundSkin, this._textArea.currentBackgroundInternal);

			this._textArea.isEnabled = true;
			FocusManager.focus = this._textArea;
			this._textArea.validate();
			Assert.assertStrictlyEquals("TextInput state is not TextInputState.FOCUSED when input is focused", TextInputState.FOCUSED, this._textArea.currentState);
			Assert.assertStrictlyEquals("TextInput background is not backgroundSkin when currentState is TextInputState.FOCUSED and background not provided for this state", backgroundSkin, this._textArea.currentBackgroundInternal);
		}

		[Test]
		public function testCurrentSkinWithSetSkinForState():void
		{
			var backgroundSkin:Quad = new Quad(200, 200);
			this._textArea.backgroundSkin = backgroundSkin;

			var backgroundEnabledSkin:Quad = new Quad(200, 200);
			this._textArea.setSkinForState(TextInputState.ENABLED, backgroundEnabledSkin);

			var backgroundDisabledSkin:Quad = new Quad(200, 200);
			this._textArea.setSkinForState(TextInputState.DISABLED, backgroundDisabledSkin);

			var backgroundFocusedSkin:Quad = new Quad(200, 200);
			this._textArea.setSkinForState(TextInputState.FOCUSED, backgroundFocusedSkin);

			var backgroundErrorSkin:Quad = new Quad(200, 200);
			this._textArea.setSkinForState(TextInputState.ERROR, backgroundErrorSkin);

			this._textArea.validate();
			Assert.assertStrictlyEquals("TextInput state is not TextInputState.ENABLED by default", TextInputState.ENABLED, this._textArea.currentState);
			Assert.assertStrictlyEquals("TextInput background is not backgroundEnabledSkin when currentState is TextInputState.ENABLED", backgroundEnabledSkin, this._textArea.currentBackgroundInternal);

			this._textArea.errorString = "Error";
			this._textArea.validate();
			Assert.assertStrictlyEquals("TextInput state is not TextInputState.ERROR when errorString is not null", TextInputState.ERROR, this._textArea.currentState);
			Assert.assertStrictlyEquals("TextInput background is not backgroundEnabledSkin when currentState is TextInputState.ENABLED", backgroundErrorSkin, this._textArea.currentBackgroundInternal);
			this._textArea.errorString = null;

			this._textArea.isEnabled = false;
			this._textArea.validate();
			Assert.assertStrictlyEquals("TextInput state is not TextInputState.DISABLED when isEnabled is false", TextInputState.DISABLED, this._textArea.currentState);
			Assert.assertStrictlyEquals("TextInput background is not backgroundDisabledSkin when currentState is TextInputState.DISABLED", backgroundDisabledSkin, this._textArea.currentBackgroundInternal);

			this._textArea.isEnabled = true;
			FocusManager.focus = this._textArea;
			this._textArea.validate();
			Assert.assertStrictlyEquals("TextInput state is not TextInputState.FOCUSED when input is focused", TextInputState.FOCUSED, this._textArea.currentState);
			Assert.assertStrictlyEquals("TextInput background is not backgroundFocusedSkin when currentState is TextInputState.FOCUSED", backgroundFocusedSkin, this._textArea.currentBackgroundInternal);
		}
	}
}

import feathers.controls.TextArea;

import starling.display.DisplayObject;

class TextAreaWithInternalState extends TextArea
{
	public function TextAreaWithInternalState()
	{
		super();
	}

	public function get currentBackgroundInternal():DisplayObject
	{
		return this.currentBackgroundSkin;
	}
}