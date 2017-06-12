package feathers.tests
{
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.tests.supportClasses.CustomStateContext;
	import feathers.text.FontStylesSet;

	import flash.text.TextFormat;

	import org.flexunit.Assert;

	import starling.text.TextFormat;

	public class TextFieldTextRendererTests
	{
		private static const STATE_DISABLED:String = "disabled";

		private static const DEFAULT_FONT_NAME:String = "DefaultFont";
		private static const DEFAULT_FONT_SIZE:Number = 16;
		private static const DEFAULT_COLOR:uint = 0xff00ff;
		private static const DISABLED_FONT_NAME:String = "DisabledFont";
		private static const DISABLED_FONT_SIZE:Number = 15;
		private static const DISABLED_COLOR:uint = 0x999999;
		private static const SELECTED_FONT_NAME:String = "SelectedFont";
		private static const SELECTED_FONT_SIZE:Number = 17;
		private static const SELECTED_COLOR:uint = 0xff0000;
		private static const STATE_FONT_NAME:String = "StateFont";
		private static const STATE_FONT_SIZE:Number = 18;
		private static const STATE_COLOR:uint = 0xffffff;

		private var _textRenderer:TextFieldTextRenderer;

		[Before]
		public function prepare():void
		{
			this._textRenderer = new TextFieldTextRenderer();
			TestFeathers.starlingRoot.addChild(this._textRenderer);
		}

		[After]
		public function cleanup():void
		{
			this._textRenderer.removeFromParent(true);
			this._textRenderer = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testOneLineWithEmptyString():void
		{
			this._textRenderer.text = "";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("TextFieldTextRenderer numLines must be 1 with empty string", 1, this._textRenderer.numLines);
		}

		[Test]
		public function testOneLine():void
		{
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("TextFieldTextRenderer numLines must be 1", 1, this._textRenderer.numLines);
		}

		[Test]
		public function testNumLinesWithLineBreak():void
		{
			this._textRenderer.text = "Hello\nWorld";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("TextFieldTextRenderer numLines must be 2 when line break is in text", 2, this._textRenderer.numLines);
		}

		[Test]
		public function testNumLinesWithCarriageReturn():void
		{
			this._textRenderer.text = "Hello\rWorld";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("TextFieldTextRenderer numLines must be 2 when carriage return is in text", 2, this._textRenderer.numLines);
		}

		[Test]
		public function testGetTextFormatForStateWithoutSetTextFormatForState():void
		{
			Assert.assertNull("TextFieldTextRenderer getTextFormatForState() must return null if TextFormat not provided with setTextFormatForState()",
				this._textRenderer.getTextFormatForState(STATE_DISABLED));
		}

		[Test]
		public function testGetTextFormatForStateAfterSetTextFormatForState():void
		{
			var textFormat:flash.text.TextFormat = new flash.text.TextFormat();
			this._textRenderer.setTextFormatForState(STATE_DISABLED, textFormat);
			Assert.assertStrictlyEquals("TextFieldTextRenderer getTextFormatForState() must return value passed to setTextFormatForState() with same state",
				textFormat, this._textRenderer.getTextFormatForState(STATE_DISABLED));
		}

		[Test]
		public function testCurrentTextFormatWithTextFormat():void
		{
			this._textRenderer.textFormat = new flash.text.TextFormat();
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("TextFieldTextRenderer currentTextFormat must be equal to textFormat when no other text formats are specified",
				this._textRenderer.textFormat, this._textRenderer.currentTextFormat);
		}

		[Test]
		public function testCurrentTextFormatWithTextFormatAndDisabled():void
		{
			this._textRenderer.textFormat = new flash.text.TextFormat();
			this._textRenderer.text = "Hello World";
			this._textRenderer.isEnabled = false;
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("TextFieldTextRenderer currentTextFormat must be equal to textFormat when isEnabled is false, but no other text formats are specified",
				this._textRenderer.textFormat, this._textRenderer.currentTextFormat);
		}

		[Test]
		public function testCurrentTextFormatWithDisabledTextFormatAndDisabled():void
		{
			this._textRenderer.textFormat = new flash.text.TextFormat();
			this._textRenderer.disabledTextFormat = new flash.text.TextFormat();
			this._textRenderer.text = "Hello World";
			this._textRenderer.isEnabled = false;
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("TextFieldTextRenderer currentTextFormat must be equal to disabledTextFormat when isEnabled is false and disabledTextFormat is not null",
				this._textRenderer.disabledTextFormat, this._textRenderer.currentTextFormat);
		}

		[Test]
		public function testCurrentTextFormatWithTextFormatAndStateContextDisabled():void
		{
			var stateContext:CustomStateContext = new CustomStateContext();
			stateContext.isEnabled = false;
			this._textRenderer.stateContext = stateContext;
			this._textRenderer.textFormat = new flash.text.TextFormat();
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("TextFieldTextRenderer currentTextFormat must be equal to textFormat when stateContext isEnabled is false, but no other text formats are specified",
				this._textRenderer.textFormat, this._textRenderer.currentTextFormat);
		}

		[Test]
		public function testCurrentTextFormatWithDisabledTextFormatAndStateContextDisabled():void
		{
			var stateContext:CustomStateContext = new CustomStateContext();
			stateContext.isEnabled = false;
			this._textRenderer.stateContext = stateContext;
			this._textRenderer.textFormat = new flash.text.TextFormat();
			this._textRenderer.disabledTextFormat = new flash.text.TextFormat();
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("TextFieldTextRenderer currentTextFormat must be equal to disabledTextFormat when isEnabled is false and disabledTextFormat is not null",
				this._textRenderer.disabledTextFormat, this._textRenderer.currentTextFormat);
		}

		[Test]
		public function testCurrentTextFormatWithTextFormatAndStateContextSelected():void
		{
			var stateContext:CustomStateContext = new CustomStateContext();
			stateContext.isSelected = true;
			this._textRenderer.stateContext = stateContext;
			this._textRenderer.textFormat = new flash.text.TextFormat();
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("TextFieldTextRenderer currentTextFormat must be equal to textFormat when stateContext isSelected is true, but no other text formats are specified",
				this._textRenderer.textFormat, this._textRenderer.currentTextFormat);
		}

		[Test]
		public function testCurrentTextFormatWithSelectedTextFormatAndStateContextSelected():void
		{
			var stateContext:CustomStateContext = new CustomStateContext();
			stateContext.isSelected = true;
			this._textRenderer.stateContext = stateContext;
			this._textRenderer.textFormat = new flash.text.TextFormat();
			this._textRenderer.selectedTextFormat = new flash.text.TextFormat();
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("TextFieldTextRenderer currentTextFormat must be equal to selectedTextFormat when isSelected is true and selectedTextFormat is not null",
				this._textRenderer.selectedTextFormat, this._textRenderer.currentTextFormat);
		}

		[Test]
		public function testCurrentTextFormatWithSelectedAndDisabledTextFormatAndStateContextSelectedAndDisabled():void
		{
			var stateContext:CustomStateContext = new CustomStateContext();
			stateContext.isSelected = true;
			stateContext.isEnabled = false;
			this._textRenderer.stateContext = stateContext;
			this._textRenderer.textFormat = new flash.text.TextFormat();
			this._textRenderer.disabledTextFormat = new flash.text.TextFormat();
			this._textRenderer.selectedTextFormat = new flash.text.TextFormat();
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			//disabled should get priority over selected
			Assert.assertStrictlyEquals("TextFieldTextRenderer currentTextFormat must be equal to disabledTextFormat when isSelected is true and isEnabled is false and both selectedTextFormat and disabledTextFormat are not null",
				this._textRenderer.disabledTextFormat, this._textRenderer.currentTextFormat);
		}

		[Test]
		public function testCurrentTextFormatWithOnlyTextFormatAndStateContextCurrentState():void
		{
			var stateContext:CustomStateContext = new CustomStateContext();
			stateContext.currentState = STATE_DISABLED;
			this._textRenderer.stateContext = stateContext;
			this._textRenderer.textFormat = new flash.text.TextFormat();
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("TextFieldTextRenderer currentTextFormat must be equal to textFormat when no other text formats are specified",
				this._textRenderer.textFormat, this._textRenderer.currentTextFormat);
		}

		[Test]
		public function testCurrentTextFormatWithDisabledTextFormatAndStateTextFormatWithStateContextDisabledAndCurrentState():void
		{
			var stateContext:CustomStateContext = new CustomStateContext();
			stateContext.isEnabled = false;
			stateContext.currentState = STATE_DISABLED;
			this._textRenderer.stateContext = stateContext;
			this._textRenderer.textFormat = new flash.text.TextFormat();
			this._textRenderer.disabledTextFormat = new flash.text.TextFormat();
			var disabledStateTextFormat:flash.text.TextFormat = new flash.text.TextFormat();
			this._textRenderer.setTextFormatForState(STATE_DISABLED, disabledStateTextFormat);
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			//exact states always get priority over default/disabled/selected
			Assert.assertStrictlyEquals("TextFieldTextRenderer currentTextFormat must be equal to flash.text.TextFormat passed into setTextFormatForState() when isEnabled is false and disabledTextFormat are not null",
				disabledStateTextFormat, this._textRenderer.currentTextFormat);
		}

		[Test]
		public function testFontStylesIgnoredIfAdvancedTextFormatExists():void
		{
			var fontStyles:FontStylesSet = new FontStylesSet();
			fontStyles.format = new starling.text.TextFormat();
			this._textRenderer.fontStyles = fontStyles;
			this._textRenderer.textFormat = new flash.text.TextFormat();
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("TextFieldTextRenderer currentTextFormat must be equal to elementFormat and not a format from font styles",
				this._textRenderer.textFormat, this._textRenderer.currentTextFormat);
		}

		[Test]
		public function testCurrentTextFormatWithFontStyles():void
		{
			var fontStyles:FontStylesSet = new FontStylesSet();
			fontStyles.format = new starling.text.TextFormat(DEFAULT_FONT_NAME, DEFAULT_FONT_SIZE, DEFAULT_COLOR);
			this._textRenderer.fontStyles = fontStyles;
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("TextFieldTextRenderer currentTextFormat.font must be equal to starling.text.TextFormat font",
				DEFAULT_FONT_NAME, this._textRenderer.currentTextFormat.font);
			Assert.assertStrictlyEquals("TextFieldTextRenderer currentTextFormat.size must be equal to starling.text.TextFormat size",
				DEFAULT_FONT_SIZE, this._textRenderer.currentTextFormat.size);
			Assert.assertStrictlyEquals("TextFieldTextRenderer currentTextFormat.color must be equal to starling.text.TextFormat color",
				DEFAULT_COLOR, this._textRenderer.currentTextFormat.color);
		}

		[Test]
		public function testCurrentTextFormatFallBackToDefaultFontStylesWhenDisabled():void
		{
			var fontStyles:FontStylesSet = new FontStylesSet();
			fontStyles.format = new starling.text.TextFormat(DEFAULT_FONT_NAME, DEFAULT_FONT_SIZE, DEFAULT_COLOR);
			this._textRenderer.fontStyles = fontStyles;
			this._textRenderer.text = "Hello World";
			this._textRenderer.isEnabled = false;
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("TextFieldTextRenderer currentTextFormat.font must be equal to starling.text.TextFormat font",
				DEFAULT_FONT_NAME, this._textRenderer.currentTextFormat.font);
			Assert.assertStrictlyEquals("TextFieldTextRenderer currentTextFormat.size must be equal to starling.text.TextFormat size",
				DEFAULT_FONT_SIZE, this._textRenderer.currentTextFormat.size);
			Assert.assertStrictlyEquals("TextFieldTextRenderer currentTextFormat.color must be equal to starling.text.TextFormat color",
				DEFAULT_COLOR, this._textRenderer.currentTextFormat.color);
		}

		[Test]
		public function testCurrentTextFormatUseDisabledFontStylesWhenDisabled():void
		{
			var fontStyles:FontStylesSet = new FontStylesSet();
			fontStyles.format = new starling.text.TextFormat(DEFAULT_FONT_NAME, DEFAULT_FONT_SIZE, DEFAULT_COLOR);
			fontStyles.disabledFormat = new starling.text.TextFormat(DISABLED_FONT_NAME, DISABLED_FONT_SIZE, DISABLED_COLOR);
			this._textRenderer.fontStyles = fontStyles;
			this._textRenderer.text = "Hello World";
			this._textRenderer.isEnabled = false;
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("TextFieldTextRenderer currentTextFormat.font must be equal to starling.text.TextFormat font",
				DISABLED_FONT_NAME, this._textRenderer.currentTextFormat.font);
			Assert.assertStrictlyEquals("TextFieldTextRenderer currentTextFormat.size must be equal to starling.text.TextFormat size",
				DISABLED_FONT_SIZE, this._textRenderer.currentTextFormat.size);
			Assert.assertStrictlyEquals("TextFieldTextRenderer currentTextFormat.color must be equal to starling.text.TextFormat color",
				DISABLED_COLOR, this._textRenderer.currentTextFormat.color);
		}

		[Test]
		public function testCurrentTextFormatFallBackToDefaultFontStylesWithStateContextDisabled():void
		{
			var stateContext:CustomStateContext = new CustomStateContext();
			stateContext.isEnabled = false;
			this._textRenderer.stateContext = stateContext;
			var fontStyles:FontStylesSet = new FontStylesSet();
			fontStyles.format = new starling.text.TextFormat(DEFAULT_FONT_NAME, DEFAULT_FONT_SIZE, DEFAULT_COLOR);
			this._textRenderer.fontStyles = fontStyles;
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("TextFieldTextRenderer currentTextFormat.font must be equal to starling.text.TextFormat font",
				DEFAULT_FONT_NAME, this._textRenderer.currentTextFormat.font);
			Assert.assertStrictlyEquals("TextFieldTextRenderer currentTextFormat.size must be equal to starling.text.TextFormat size",
				DEFAULT_FONT_SIZE, this._textRenderer.currentTextFormat.size);
			Assert.assertStrictlyEquals("TextFieldTextRenderer currentTextFormat.color must be equal to starling.text.TextFormat color",
				DEFAULT_COLOR, this._textRenderer.currentTextFormat.color);
		}

		[Test]
		public function testCurrentTextFormatUseDisabledFontStylesWithStateContextDisabled():void
		{
			var stateContext:CustomStateContext = new CustomStateContext();
			stateContext.isEnabled = false;
			this._textRenderer.stateContext = stateContext;
			var fontStyles:FontStylesSet = new FontStylesSet();
			fontStyles.format = new starling.text.TextFormat(DEFAULT_FONT_NAME, DEFAULT_FONT_SIZE, DEFAULT_COLOR);
			fontStyles.disabledFormat = new starling.text.TextFormat(DISABLED_FONT_NAME, DISABLED_FONT_SIZE, DISABLED_COLOR);
			this._textRenderer.fontStyles = fontStyles;
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("TextFieldTextRenderer currentTextFormat.font must be equal to starling.text.TextFormat font",
				DISABLED_FONT_NAME, this._textRenderer.currentTextFormat.font);
			Assert.assertStrictlyEquals("TextFieldTextRenderer currentTextFormat.size must be equal to starling.text.TextFormat size",
				DISABLED_FONT_SIZE, this._textRenderer.currentTextFormat.size);
			Assert.assertStrictlyEquals("TextFieldTextRenderer currentTextFormat.color must be equal to starling.text.TextFormat color",
				DISABLED_COLOR, this._textRenderer.currentTextFormat.color);
		}

		[Test]
		public function testCurrentTextFormatFallBackToDefaultFontStylesWithStateContextSelected():void
		{
			var stateContext:CustomStateContext = new CustomStateContext();
			stateContext.isSelected = true;
			this._textRenderer.stateContext = stateContext;
			var fontStyles:FontStylesSet = new FontStylesSet();
			fontStyles.format = new starling.text.TextFormat(DEFAULT_FONT_NAME, DEFAULT_FONT_SIZE, DEFAULT_COLOR);
			this._textRenderer.fontStyles = fontStyles;
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("TextFieldTextRenderer currentTextFormat.font must be equal to starling.text.TextFormat font",
				DEFAULT_FONT_NAME, this._textRenderer.currentTextFormat.font);
			Assert.assertStrictlyEquals("TextFieldTextRenderer currentTextFormat.size must be equal to starling.text.TextFormat size",
				DEFAULT_FONT_SIZE, this._textRenderer.currentTextFormat.size);
			Assert.assertStrictlyEquals("TextFieldTextRenderer currentTextFormat.color must be equal to starling.text.TextFormat color",
				DEFAULT_COLOR, this._textRenderer.currentTextFormat.color);
		}

		[Test]
		public function testCurrentTextFormatUseSelectedFontStylesWithStateContextSelected():void
		{
			var stateContext:CustomStateContext = new CustomStateContext();
			stateContext.isSelected = true;
			this._textRenderer.stateContext = stateContext;
			var fontStyles:FontStylesSet = new FontStylesSet();
			fontStyles.format = new starling.text.TextFormat(DEFAULT_FONT_NAME, DEFAULT_FONT_SIZE, DEFAULT_COLOR);
			fontStyles.selectedFormat = new starling.text.TextFormat(SELECTED_FONT_NAME, SELECTED_FONT_SIZE, SELECTED_COLOR);
			this._textRenderer.fontStyles = fontStyles;
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("TextFieldTextRenderer currentTextFormat.font must be equal to starling.text.TextFormat font",
				SELECTED_FONT_NAME, this._textRenderer.currentTextFormat.font);
			Assert.assertStrictlyEquals("TextFieldTextRenderer currentTextFormat.size must be equal to starling.text.TextFormat size",
				SELECTED_FONT_SIZE, this._textRenderer.currentTextFormat.size);
			Assert.assertStrictlyEquals("TextFieldTextRenderer currentTextFormat.color must be equal to starling.text.TextFormat color",
				SELECTED_COLOR, this._textRenderer.currentTextFormat.color);
		}

		[Test]
		public function testCurrentTextFormatUseDisabledFontStylesWithStateContextSelectedAndDisabled():void
		{
			var stateContext:CustomStateContext = new CustomStateContext();
			stateContext.isSelected = true;
			stateContext.isEnabled = false;
			this._textRenderer.stateContext = stateContext;
			var fontStyles:FontStylesSet = new FontStylesSet();
			fontStyles.format = new starling.text.TextFormat(DEFAULT_FONT_NAME, DEFAULT_FONT_SIZE, DEFAULT_COLOR);
			fontStyles.selectedFormat = new starling.text.TextFormat(SELECTED_FONT_NAME, SELECTED_FONT_SIZE, SELECTED_COLOR);
			fontStyles.disabledFormat = new starling.text.TextFormat(DISABLED_FONT_NAME, DISABLED_FONT_SIZE, DISABLED_COLOR);
			this._textRenderer.fontStyles = fontStyles;
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			//disabled should get priority over selected
			Assert.assertStrictlyEquals("TextFieldTextRenderer currentTextFormat.font must be equal to starling.text.TextFormat font",
				DISABLED_FONT_NAME, this._textRenderer.currentTextFormat.font);
			Assert.assertStrictlyEquals("TextFieldTextRenderer currentTextFormat.size must be equal to starling.text.TextFormat size",
				DISABLED_FONT_SIZE, this._textRenderer.currentTextFormat.size);
			Assert.assertStrictlyEquals("TextFieldTextRenderer currentTextFormat.color must be equal to starling.text.TextFormat color",
				DISABLED_COLOR, this._textRenderer.currentTextFormat.color);
		}

		[Test]
		public function testCurrentTextFormatFallBackToDefaultFontStylesWithStateContextCurrentState():void
		{
			var stateContext:CustomStateContext = new CustomStateContext();
			stateContext.currentState = STATE_DISABLED;
			this._textRenderer.stateContext = stateContext;
			var fontStyles:FontStylesSet = new FontStylesSet();
			fontStyles.format = new starling.text.TextFormat(DEFAULT_FONT_NAME, DEFAULT_FONT_SIZE, DEFAULT_COLOR);
			this._textRenderer.fontStyles = fontStyles;
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("TextFieldTextRenderer currentTextFormat.font must be equal to starling.text.TextFormat font",
				DEFAULT_FONT_NAME, this._textRenderer.currentTextFormat.font);
			Assert.assertStrictlyEquals("TextFieldTextRenderer currentTextFormat.size must be equal to starling.text.TextFormat size",
				DEFAULT_FONT_SIZE, this._textRenderer.currentTextFormat.size);
			Assert.assertStrictlyEquals("TextFieldTextRenderer currentTextFormat.color must be equal to starling.text.TextFormat color",
				DEFAULT_COLOR, this._textRenderer.currentTextFormat.color);
		}

		[Test]
		public function testCurrentTextFormatUseStateFontStylesWithStateContextCurrentState():void
		{
			var stateContext:CustomStateContext = new CustomStateContext();
			stateContext.currentState = STATE_DISABLED;
			stateContext.isSelected = true;
			stateContext.isEnabled = false;
			this._textRenderer.stateContext = stateContext;
			var fontStyles:FontStylesSet = new FontStylesSet();
			fontStyles.format = new starling.text.TextFormat(DEFAULT_FONT_NAME, DEFAULT_FONT_SIZE, DEFAULT_COLOR);
			fontStyles.selectedFormat = new starling.text.TextFormat(SELECTED_FONT_NAME, SELECTED_FONT_SIZE, SELECTED_COLOR);
			fontStyles.disabledFormat = new starling.text.TextFormat(DISABLED_FONT_NAME, DISABLED_FONT_SIZE, DISABLED_COLOR);
			fontStyles.setFormatForState(STATE_DISABLED, new starling.text.TextFormat(STATE_FONT_NAME, STATE_FONT_SIZE, STATE_COLOR));
			this._textRenderer.fontStyles = fontStyles;
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			//exact states always get priority over default/disabled/selected
			Assert.assertStrictlyEquals("TextFieldTextRenderer currentTextFormat.font must be equal to starling.text.TextFormat font",
				STATE_FONT_NAME, this._textRenderer.currentTextFormat.font);
			Assert.assertStrictlyEquals("TextFieldTextRenderer currentTextFormat.size must be equal to starling.text.TextFormat size",
				STATE_FONT_SIZE, this._textRenderer.currentTextFormat.size);
			Assert.assertStrictlyEquals("TextFieldTextRenderer currentTextFormat.color must be equal to starling.text.TextFormat color",
				STATE_COLOR, this._textRenderer.currentTextFormat.color);
		}

		[Test]
		public function testInvalidAfterChangePropertyOfFontStyles():void
		{
			var format:starling.text.TextFormat = new starling.text.TextFormat(DEFAULT_FONT_NAME, DEFAULT_FONT_SIZE, DEFAULT_COLOR);
			var fontStyles:FontStylesSet = new FontStylesSet();
			fontStyles.format = format
			this._textRenderer.fontStyles = fontStyles;
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			format.color = SELECTED_COLOR;
			Assert.assertTrue("TextFieldTextRenderer: must be invalid after changing property of font styles.",
				this._textRenderer.isInvalid());
		}
	}
}
