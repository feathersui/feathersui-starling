package feathers.tests
{
	import feathers.controls.text.TextFieldTextEditor;
	import feathers.tests.supportClasses.CustomStateContext;

	import flash.text.TextFormat;

	import org.flexunit.Assert;

	public class TextFieldTextEditorTests
	{
		private static const STATE_DISABLED:String = "disabled";

		private var _textEditor:TextFieldTextEditor;

		[Before]
		public function prepare():void
		{
			this._textEditor = new TextFieldTextEditor();
			TestFeathers.starlingRoot.addChild(this._textEditor);
		}

		[After]
		public function cleanup():void
		{
			this._textEditor.removeFromParent(true);
			this._textEditor = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testGetTextFormatForStateWithoutSetTextFormatForState():void
		{
			Assert.assertNull("TextFieldTextRenderer getTextFormatForState() must return null if TextFormat not provided with setTextFormatForState()",
				this._textEditor.getTextFormatForState(STATE_DISABLED));
		}

		[Test]
		public function testGetTextFormatForStateAfterSetTextFormatForState():void
		{
			var textFormat:TextFormat = new TextFormat();
			this._textEditor.setTextFormatForState(STATE_DISABLED, textFormat);
			Assert.assertStrictlyEquals("TextFieldTextRenderer getTextFormatForState() must return value passed to setTextFormatForState() with same state",
				textFormat, this._textEditor.getTextFormatForState(STATE_DISABLED));
		}

		[Test]
		public function testCurrentTextFormatWithTextFormat():void
		{
			this._textEditor.textFormat = new TextFormat();
			this._textEditor.text = "Hello World";
			this._textEditor.validate();
			Assert.assertStrictlyEquals("TextFieldTextRenderer currentTextFormat must be equal to textFormat when no other text formats are specified",
				this._textEditor.textFormat, this._textEditor.currentTextFormat);
		}

		[Test]
		public function testCurrentTextFormatWithTextFormatAndDisabled():void
		{
			this._textEditor.textFormat = new TextFormat();
			this._textEditor.text = "Hello World";
			this._textEditor.isEnabled = false;
			this._textEditor.validate();
			Assert.assertStrictlyEquals("TextFieldTextRenderer currentTextFormat must be equal to textFormat when isEnabled is false, but no other text formats are specified",
				this._textEditor.textFormat, this._textEditor.currentTextFormat);
		}

		[Test]
		public function testCurrentTextFormatWithDisabledTextFormatAndDisabled():void
		{
			this._textEditor.textFormat = new TextFormat();
			this._textEditor.disabledTextFormat = new TextFormat();
			this._textEditor.text = "Hello World";
			this._textEditor.isEnabled = false;
			this._textEditor.validate();
			Assert.assertStrictlyEquals("TextFieldTextRenderer currentTextFormat must be equal to disabledTextFormat when isEnabled is false and disabledTextFormat is not null",
				this._textEditor.disabledTextFormat, this._textEditor.currentTextFormat);
		}

		[Test]
		public function testCurrentTextFormatWithTextFormatAndStateContextDisabled():void
		{
			var stateContext:CustomStateContext = new CustomStateContext();
			stateContext.isEnabled = false;
			this._textEditor.stateContext = stateContext;
			this._textEditor.textFormat = new TextFormat();
			this._textEditor.text = "Hello World";
			this._textEditor.validate();
			Assert.assertStrictlyEquals("TextFieldTextRenderer currentTextFormat must be equal to textFormat when stateContext isEnabled is false, but no other text formats are specified",
				this._textEditor.textFormat, this._textEditor.currentTextFormat);
		}

		[Test]
		public function testCurrentTextFormatWithDisabledTextFormatAndStateContextDisabled():void
		{
			var stateContext:CustomStateContext = new CustomStateContext();
			stateContext.isEnabled = false;
			this._textEditor.stateContext = stateContext;
			this._textEditor.textFormat = new TextFormat();
			this._textEditor.disabledTextFormat = new TextFormat();
			this._textEditor.text = "Hello World";
			this._textEditor.validate();
			Assert.assertStrictlyEquals("TextFieldTextRenderer currentTextFormat must be equal to disabledTextFormat when isEnabled is false and disabledTextFormat is not null",
				this._textEditor.disabledTextFormat, this._textEditor.currentTextFormat);
		}

		[Test]
		public function testCurrentTextFormatWithTextFormatAndStateContextSelected():void
		{
			var stateContext:CustomStateContext = new CustomStateContext();
			stateContext.isSelected = true;
			this._textEditor.stateContext = stateContext;
			this._textEditor.textFormat = new TextFormat();
			this._textEditor.text = "Hello World";
			this._textEditor.validate();
			Assert.assertStrictlyEquals("TextFieldTextRenderer currentTextFormat must be equal to textFormat when stateContext isSelected is true, but no other text formats are specified",
				this._textEditor.textFormat, this._textEditor.currentTextFormat);
		}

		[Test]
		public function testCurrentTextFormatWithOnlyTextFormatAndStateContextCurrentState():void
		{
			var stateContext:CustomStateContext = new CustomStateContext();
			stateContext.currentState = STATE_DISABLED;
			this._textEditor.stateContext = stateContext;
			this._textEditor.textFormat = new TextFormat();
			this._textEditor.text = "Hello World";
			this._textEditor.validate();
			Assert.assertStrictlyEquals("TextFieldTextRenderer currentTextFormat must be equal to textFormat when no other text formats are specified",
				this._textEditor.textFormat, this._textEditor.currentTextFormat);
		}

		[Test]
		public function testCurrentTextFormatWithDisabledTextFormatAndStateTextFormatWithStateContextDisabledAndCurrentState():void
		{
			var stateContext:CustomStateContext = new CustomStateContext();
			stateContext.isEnabled = false;
			stateContext.currentState = STATE_DISABLED;
			this._textEditor.stateContext = stateContext;
			this._textEditor.textFormat = new TextFormat();
			this._textEditor.disabledTextFormat = new TextFormat();
			var disabledStateTextFormat:TextFormat = new TextFormat();
			this._textEditor.setTextFormatForState(STATE_DISABLED, disabledStateTextFormat);
			this._textEditor.text = "Hello World";
			this._textEditor.validate();
			Assert.assertStrictlyEquals("TextFieldTextRenderer currentTextFormat must be equal to flash.text.TextFormat passed into setTextFormatForState() when isEnabled is false and disabledTextFormat are not null",
				disabledStateTextFormat, this._textEditor.currentTextFormat);
		}
	}
}
