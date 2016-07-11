package feathers.tests
{
	import feathers.controls.text.TextFieldTextEditor;
	import feathers.tests.supportClasses.CustomStateContext;
	import feathers.text.FontStylesSet;

	import flash.text.TextFormat;

	import org.flexunit.Assert;

	import starling.text.TextFormat;

	public class TextFieldTextEditorTests
	{
		private static const STATE_DISABLED:String = "disabled";

		private static const DEFAULT_FONT_NAME:String = "DefaultFont";
		private static const DEFAULT_FONT_SIZE:Number = 16;
		private static const DEFAULT_COLOR:uint = 0xff00ff;
		private static const DISABLED_FONT_NAME:String = "DisabledFont";
		private static const DISABLED_FONT_SIZE:Number = 15;
		private static const DISABLED_COLOR:uint = 0x999999;
		private static const STATE_FONT_NAME:String = "StateFont";
		private static const STATE_FONT_SIZE:Number = 18;
		private static const STATE_COLOR:uint = 0xffffff;

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
			Assert.assertNull("TextFieldTextEditor getTextFormatForState() must return null if TextFormat not provided with setTextFormatForState()",
				this._textEditor.getTextFormatForState(STATE_DISABLED));
		}

		[Test]
		public function testGetTextFormatForStateAfterSetTextFormatForState():void
		{
			var textFormat:flash.text.TextFormat = new flash.text.TextFormat();
			this._textEditor.setTextFormatForState(STATE_DISABLED, textFormat);
			Assert.assertStrictlyEquals("TextFieldTextEditor getTextFormatForState() must return value passed to setTextFormatForState() with same state",
				textFormat, this._textEditor.getTextFormatForState(STATE_DISABLED));
		}

		[Test]
		public function testCurrentTextFormatWithTextFormat():void
		{
			this._textEditor.textFormat = new flash.text.TextFormat();
			this._textEditor.text = "Hello World";
			this._textEditor.validate();
			Assert.assertStrictlyEquals("TextFieldTextEditor currentTextFormat must be equal to textFormat when no other text formats are specified",
				this._textEditor.textFormat, this._textEditor.currentTextFormat);
		}

		[Test]
		public function testCurrentTextFormatWithTextFormatAndDisabled():void
		{
			this._textEditor.textFormat = new flash.text.TextFormat();
			this._textEditor.text = "Hello World";
			this._textEditor.isEnabled = false;
			this._textEditor.validate();
			Assert.assertStrictlyEquals("TextFieldTextEditor currentTextFormat must be equal to textFormat when isEnabled is false, but no other text formats are specified",
				this._textEditor.textFormat, this._textEditor.currentTextFormat);
		}

		[Test]
		public function testCurrentTextFormatWithDisabledTextFormatAndDisabled():void
		{
			this._textEditor.textFormat = new flash.text.TextFormat();
			this._textEditor.disabledTextFormat = new flash.text.TextFormat();
			this._textEditor.text = "Hello World";
			this._textEditor.isEnabled = false;
			this._textEditor.validate();
			Assert.assertStrictlyEquals("TextFieldTextEditor currentTextFormat must be equal to disabledTextFormat when isEnabled is false and disabledTextFormat is not null",
				this._textEditor.disabledTextFormat, this._textEditor.currentTextFormat);
		}

		[Test]
		public function testCurrentTextFormatWithTextFormatAndStateContextDisabled():void
		{
			var stateContext:CustomStateContext = new CustomStateContext();
			stateContext.isEnabled = false;
			this._textEditor.stateContext = stateContext;
			this._textEditor.textFormat = new flash.text.TextFormat();
			this._textEditor.text = "Hello World";
			this._textEditor.validate();
			Assert.assertStrictlyEquals("TextFieldTextEditor currentTextFormat must be equal to textFormat when stateContext isEnabled is false, but no other text formats are specified",
				this._textEditor.textFormat, this._textEditor.currentTextFormat);
		}

		[Test]
		public function testCurrentTextFormatWithDisabledTextFormatAndStateContextDisabled():void
		{
			var stateContext:CustomStateContext = new CustomStateContext();
			stateContext.isEnabled = false;
			this._textEditor.stateContext = stateContext;
			this._textEditor.textFormat = new flash.text.TextFormat();
			this._textEditor.disabledTextFormat = new flash.text.TextFormat();
			this._textEditor.text = "Hello World";
			this._textEditor.validate();
			Assert.assertStrictlyEquals("TextFieldTextEditor currentTextFormat must be equal to disabledTextFormat when isEnabled is false and disabledTextFormat is not null",
				this._textEditor.disabledTextFormat, this._textEditor.currentTextFormat);
		}

		[Test]
		public function testCurrentTextFormatWithTextFormatAndStateContextSelected():void
		{
			var stateContext:CustomStateContext = new CustomStateContext();
			stateContext.isSelected = true;
			this._textEditor.stateContext = stateContext;
			this._textEditor.textFormat = new flash.text.TextFormat();
			this._textEditor.text = "Hello World";
			this._textEditor.validate();
			Assert.assertStrictlyEquals("TextFieldTextEditor currentTextFormat must be equal to textFormat when stateContext isSelected is true, but no other text formats are specified",
				this._textEditor.textFormat, this._textEditor.currentTextFormat);
		}

		[Test]
		public function testCurrentTextFormatWithOnlyTextFormatAndStateContextCurrentState():void
		{
			var stateContext:CustomStateContext = new CustomStateContext();
			stateContext.currentState = STATE_DISABLED;
			this._textEditor.stateContext = stateContext;
			this._textEditor.textFormat = new flash.text.TextFormat();
			this._textEditor.text = "Hello World";
			this._textEditor.validate();
			Assert.assertStrictlyEquals("TextFieldTextEditor currentTextFormat must be equal to textFormat when no other text formats are specified",
				this._textEditor.textFormat, this._textEditor.currentTextFormat);
		}

		[Test]
		public function testCurrentTextFormatWithDisabledTextFormatAndStateTextFormatWithStateContextDisabledAndCurrentState():void
		{
			var stateContext:CustomStateContext = new CustomStateContext();
			stateContext.isEnabled = false;
			stateContext.currentState = STATE_DISABLED;
			this._textEditor.stateContext = stateContext;
			this._textEditor.textFormat = new flash.text.TextFormat();
			this._textEditor.disabledTextFormat = new flash.text.TextFormat();
			var disabledStateTextFormat:flash.text.TextFormat = new flash.text.TextFormat();
			this._textEditor.setTextFormatForState(STATE_DISABLED, disabledStateTextFormat);
			this._textEditor.text = "Hello World";
			this._textEditor.validate();
			//exact states always get priority over default/disabled
			Assert.assertStrictlyEquals("TextFieldTextEditor currentTextFormat must be equal to flash.text.TextFormat passed into setTextFormatForState() when isEnabled is false and disabledTextFormat are not null",
				disabledStateTextFormat, this._textEditor.currentTextFormat);
		}

		[Test]
		public function testFontStylesIgnoredIfAdvancedTextFormatExists():void
		{
			var fontStyles:FontStylesSet = new FontStylesSet();
			fontStyles.format = new starling.text.TextFormat();
			this._textEditor.fontStyles = fontStyles;
			this._textEditor.textFormat = new flash.text.TextFormat();
			this._textEditor.text = "Hello World";
			this._textEditor.validate();
			Assert.assertStrictlyEquals("TextFieldTextEditor currentTextFormat must be equal to elementFormat and not a format from font styles",
				this._textEditor.textFormat, this._textEditor.currentTextFormat);
		}

		[Test]
		public function testCurrentTextFormatWithFontStyles():void
		{
			var fontStyles:FontStylesSet = new FontStylesSet();
			fontStyles.format = new starling.text.TextFormat(DEFAULT_FONT_NAME, DEFAULT_FONT_SIZE, DEFAULT_COLOR);
			this._textEditor.fontStyles = fontStyles;
			this._textEditor.text = "Hello World";
			this._textEditor.validate();
			Assert.assertStrictlyEquals("TextFieldTextEditor currentTextFormat.font must be equal to starling.text.TextFormat font",
				DEFAULT_FONT_NAME, this._textEditor.currentTextFormat.font);
			Assert.assertStrictlyEquals("TextFieldTextEditor currentTextFormat.size must be equal to starling.text.TextFormat size",
				DEFAULT_FONT_SIZE, this._textEditor.currentTextFormat.size);
			Assert.assertStrictlyEquals("TextFieldTextEditor currentTextFormat.color must be equal to starling.text.TextFormat color",
				DEFAULT_COLOR, this._textEditor.currentTextFormat.color);
		}

		[Test]
		public function testCurrentTextFormatFallBackToDefaultFontStylesWhenDisabled():void
		{
			var fontStyles:FontStylesSet = new FontStylesSet();
			fontStyles.format = new starling.text.TextFormat(DEFAULT_FONT_NAME, DEFAULT_FONT_SIZE, DEFAULT_COLOR);
			this._textEditor.fontStyles = fontStyles;
			this._textEditor.text = "Hello World";
			this._textEditor.isEnabled = false;
			this._textEditor.validate();
			Assert.assertStrictlyEquals("TextFieldTextEditor currentTextFormat.font must be equal to starling.text.TextFormat font",
				DEFAULT_FONT_NAME, this._textEditor.currentTextFormat.font);
			Assert.assertStrictlyEquals("TextFieldTextEditor currentTextFormat.size must be equal to starling.text.TextFormat size",
				DEFAULT_FONT_SIZE, this._textEditor.currentTextFormat.size);
			Assert.assertStrictlyEquals("TextFieldTextEditor currentTextFormat.color must be equal to starling.text.TextFormat color",
				DEFAULT_COLOR, this._textEditor.currentTextFormat.color);
		}

		[Test]
		public function testCurrentTextFormatUseDisabledFontStylesWhenDisabled():void
		{
			var fontStyles:FontStylesSet = new FontStylesSet();
			fontStyles.format = new starling.text.TextFormat(DEFAULT_FONT_NAME, DEFAULT_FONT_SIZE, DEFAULT_COLOR);
			fontStyles.disabledFormat = new starling.text.TextFormat(DISABLED_FONT_NAME, DISABLED_FONT_SIZE, DISABLED_COLOR);
			this._textEditor.fontStyles = fontStyles;
			this._textEditor.text = "Hello World";
			this._textEditor.isEnabled = false;
			this._textEditor.validate();
			Assert.assertStrictlyEquals("TextFieldTextEditor currentTextFormat.font must be equal to starling.text.TextFormat font",
				DISABLED_FONT_NAME, this._textEditor.currentTextFormat.font);
			Assert.assertStrictlyEquals("TextFieldTextEditor currentTextFormat.size must be equal to starling.text.TextFormat size",
				DISABLED_FONT_SIZE, this._textEditor.currentTextFormat.size);
			Assert.assertStrictlyEquals("TextFieldTextEditor currentTextFormat.color must be equal to starling.text.TextFormat color",
				DISABLED_COLOR, this._textEditor.currentTextFormat.color);
		}

		[Test]
		public function testCurrentTextFormatFallBackToDefaultFontStylesWithStateContextDisabled():void
		{
			var stateContext:CustomStateContext = new CustomStateContext();
			stateContext.isEnabled = false;
			this._textEditor.stateContext = stateContext;
			var fontStyles:FontStylesSet = new FontStylesSet();
			fontStyles.format = new starling.text.TextFormat(DEFAULT_FONT_NAME, DEFAULT_FONT_SIZE, DEFAULT_COLOR);
			this._textEditor.fontStyles = fontStyles;
			this._textEditor.text = "Hello World";
			this._textEditor.validate();
			Assert.assertStrictlyEquals("TextFieldTextEditor currentTextFormat.font must be equal to starling.text.TextFormat font",
				DEFAULT_FONT_NAME, this._textEditor.currentTextFormat.font);
			Assert.assertStrictlyEquals("TextFieldTextEditor currentTextFormat.size must be equal to starling.text.TextFormat size",
				DEFAULT_FONT_SIZE, this._textEditor.currentTextFormat.size);
			Assert.assertStrictlyEquals("TextFieldTextEditor currentTextFormat.color must be equal to starling.text.TextFormat color",
				DEFAULT_COLOR, this._textEditor.currentTextFormat.color);
		}

		[Test]
		public function testCurrentTextFormatUseDisabledFontStylesWithStateContextDisabled():void
		{
			var stateContext:CustomStateContext = new CustomStateContext();
			stateContext.isEnabled = false;
			this._textEditor.stateContext = stateContext;
			var fontStyles:FontStylesSet = new FontStylesSet();
			fontStyles.format = new starling.text.TextFormat(DEFAULT_FONT_NAME, DEFAULT_FONT_SIZE, DEFAULT_COLOR);
			fontStyles.disabledFormat = new starling.text.TextFormat(DISABLED_FONT_NAME, DISABLED_FONT_SIZE, DISABLED_COLOR);
			this._textEditor.fontStyles = fontStyles;
			this._textEditor.text = "Hello World";
			this._textEditor.validate();
			Assert.assertStrictlyEquals("TextFieldTextEditor currentTextFormat.font must be equal to starling.text.TextFormat font",
				DISABLED_FONT_NAME, this._textEditor.currentTextFormat.font);
			Assert.assertStrictlyEquals("TextFieldTextEditor currentTextFormat.size must be equal to starling.text.TextFormat size",
				DISABLED_FONT_SIZE, this._textEditor.currentTextFormat.size);
			Assert.assertStrictlyEquals("TextFieldTextEditor currentTextFormat.color must be equal to starling.text.TextFormat color",
				DISABLED_COLOR, this._textEditor.currentTextFormat.color);
		}

		[Test]
		public function testCurrentTextFormatFallBackToDefaultFontStylesWithStateContextSelected():void
		{
			var stateContext:CustomStateContext = new CustomStateContext();
			stateContext.isSelected = true;
			this._textEditor.stateContext = stateContext;
			var fontStyles:FontStylesSet = new FontStylesSet();
			fontStyles.format = new starling.text.TextFormat(DEFAULT_FONT_NAME, DEFAULT_FONT_SIZE, DEFAULT_COLOR);
			this._textEditor.fontStyles = fontStyles;
			this._textEditor.text = "Hello World";
			this._textEditor.validate();
			Assert.assertStrictlyEquals("TextFieldTextEditor currentTextFormat.font must be equal to starling.text.TextFormat font",
				DEFAULT_FONT_NAME, this._textEditor.currentTextFormat.font);
			Assert.assertStrictlyEquals("TextFieldTextEditor currentTextFormat.size must be equal to starling.text.TextFormat size",
				DEFAULT_FONT_SIZE, this._textEditor.currentTextFormat.size);
			Assert.assertStrictlyEquals("TextFieldTextEditor currentTextFormat.color must be equal to starling.text.TextFormat color",
				DEFAULT_COLOR, this._textEditor.currentTextFormat.color);
		}

		[Test]
		public function testCurrentTextFormatFallBackToDefaultFontStylesWithStateContextCurrentState():void
		{
			var stateContext:CustomStateContext = new CustomStateContext();
			stateContext.currentState = STATE_DISABLED;
			this._textEditor.stateContext = stateContext;
			var fontStyles:FontStylesSet = new FontStylesSet();
			fontStyles.format = new starling.text.TextFormat(DEFAULT_FONT_NAME, DEFAULT_FONT_SIZE, DEFAULT_COLOR);
			this._textEditor.fontStyles = fontStyles;
			this._textEditor.text = "Hello World";
			this._textEditor.validate();
			Assert.assertStrictlyEquals("TextFieldTextEditor currentTextFormat.font must be equal to starling.text.TextFormat font",
				DEFAULT_FONT_NAME, this._textEditor.currentTextFormat.font);
			Assert.assertStrictlyEquals("TextFieldTextEditor currentTextFormat.size must be equal to starling.text.TextFormat size",
				DEFAULT_FONT_SIZE, this._textEditor.currentTextFormat.size);
			Assert.assertStrictlyEquals("TextFieldTextEditor currentTextFormat.color must be equal to starling.text.TextFormat color",
				DEFAULT_COLOR, this._textEditor.currentTextFormat.color);
		}

		[Test]
		public function testCurrentTextFormatUseStateFontStylesWithStateContextCurrentState():void
		{
			var stateContext:CustomStateContext = new CustomStateContext();
			stateContext.currentState = STATE_DISABLED;
			stateContext.isSelected = true;
			stateContext.isEnabled = false;
			this._textEditor.stateContext = stateContext;
			var fontStyles:FontStylesSet = new FontStylesSet();
			fontStyles.format = new starling.text.TextFormat(DEFAULT_FONT_NAME, DEFAULT_FONT_SIZE, DEFAULT_COLOR);
			fontStyles.disabledFormat = new starling.text.TextFormat(DISABLED_FONT_NAME, DISABLED_FONT_SIZE, DISABLED_COLOR);
			fontStyles.setFormatForState(STATE_DISABLED, new starling.text.TextFormat(STATE_FONT_NAME, STATE_FONT_SIZE, STATE_COLOR));
			this._textEditor.fontStyles = fontStyles;
			this._textEditor.text = "Hello World";
			this._textEditor.validate();
			//exact states always get priority over default/disabled
			Assert.assertStrictlyEquals("TextFieldTextEditor currentTextFormat.font must be equal to starling.text.TextFormat font",
				STATE_FONT_NAME, this._textEditor.currentTextFormat.font);
			Assert.assertStrictlyEquals("TextFieldTextEditor currentTextFormat.size must be equal to starling.text.TextFormat size",
				STATE_FONT_SIZE, this._textEditor.currentTextFormat.size);
			Assert.assertStrictlyEquals("TextFieldTextEditor currentTextFormat.color must be equal to starling.text.TextFormat color",
				STATE_COLOR, this._textEditor.currentTextFormat.color);
		}
	}
}
