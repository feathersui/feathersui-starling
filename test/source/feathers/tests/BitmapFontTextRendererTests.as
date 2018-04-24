package feathers.tests
{
	import feathers.controls.text.BitmapFontTextRenderer;
	import feathers.tests.supportClasses.CustomToggle;
	import feathers.text.BitmapFontTextFormat;
	import feathers.text.FontStylesSet;

	import org.flexunit.Assert;

	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.text.TextFormat;

	public class BitmapFontTextRendererTests
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

		private var _textRenderer:BitmapFontTextRenderer;

		[Before]
		public function prepare():void
		{
			TextField.registerCompositor(new BitmapFont(), DEFAULT_FONT_NAME);
			TextField.registerCompositor(new BitmapFont(), DISABLED_FONT_NAME);
			TextField.registerCompositor(new BitmapFont(), SELECTED_FONT_NAME);
			TextField.registerCompositor(new BitmapFont(), STATE_FONT_NAME);

			this._textRenderer = new BitmapFontTextRenderer();
			TestFeathers.starlingRoot.addChild(this._textRenderer);
		}

		[After]
		public function cleanup():void
		{
			this._textRenderer.removeFromParent(true);
			this._textRenderer = null;

			TextField.unregisterCompositor(DEFAULT_FONT_NAME);
			TextField.unregisterCompositor(DISABLED_FONT_NAME);
			TextField.unregisterCompositor(SELECTED_FONT_NAME);
			TextField.unregisterCompositor(STATE_FONT_NAME);

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testMaxWidth0WithWordWrap():void
		{
			this._textRenderer.text = "Test";
			this._textRenderer.wordWrap = true;
			this._textRenderer.maxWidth = 0;
			this._textRenderer.validate();
		}

		[Test]
		public function testOneLineWithEmptyString():void
		{
			this._textRenderer.text = "";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("BitmapFontTextRenderer numLines must be 1 with empty string", 1, this._textRenderer.numLines);
		}

		[Test]
		public function testOneLine():void
		{
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("BitmapFontTextRenderer numLines must be 1", 1, this._textRenderer.numLines);
		}

		[Test]
		public function testNumLinesWithLineBreak():void
		{
			this._textRenderer.text = "Hello\nWorld";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("BitmapFontTextRenderer numLines must be 2 when line break is in text", 2, this._textRenderer.numLines);
		}

		[Test]
		public function testNumLinesWithCarriageReturn():void
		{
			this._textRenderer.text = "Hello\rWorld";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("BitmapFontTextRenderer numLines must be 2 when carriage return is in text", 2, this._textRenderer.numLines);
		}

		[Test]
		public function testGetTextFormatForStateWithoutSetTextFormatForState():void
		{
			Assert.assertNull("BitmapFontTextRenderer getTextFormatForState() must return null if BitmapFontTextFormat not provided with setTextFormatForState()",
				this._textRenderer.getTextFormatForState(STATE_DISABLED));
		}

		[Test]
		public function testGetTextFormatForStateAfterSetTextFormatForState():void
		{
			var textFormat:BitmapFontTextFormat = new BitmapFontTextFormat(new BitmapFont());
			this._textRenderer.setTextFormatForState(STATE_DISABLED, textFormat);
			Assert.assertStrictlyEquals("BitmapFontTextRenderer getTextFormatForState() must return value passed to setTextFormatForState() with same state",
				textFormat, this._textRenderer.getTextFormatForState(STATE_DISABLED));
		}

		[Test]
		public function testCurrentTextFormatWithTextFormat():void
		{
			this._textRenderer.textFormat = new BitmapFontTextFormat(new BitmapFont());
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("BitmapFontTextRenderer currentTextFormat must be equal to textFormat when no other text formats are specified",
				this._textRenderer.textFormat, this._textRenderer.currentTextFormat);
		}

		[Test]
		public function testCurrentTextFormatWithTextFormatAndDisabled():void
		{
			this._textRenderer.textFormat = new BitmapFontTextFormat(new BitmapFont());
			this._textRenderer.text = "Hello World";
			this._textRenderer.isEnabled = false;
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("BitmapFontTextRenderer currentTextFormat must be equal to textFormat when isEnabled is false, but no other text formats are specified",
				this._textRenderer.textFormat, this._textRenderer.currentTextFormat);
		}

		[Test]
		public function testCurrentTextFormatWithDisabledTextFormatAndDisabled():void
		{
			this._textRenderer.textFormat = new BitmapFontTextFormat(new BitmapFont());
			this._textRenderer.disabledTextFormat = new BitmapFontTextFormat(new BitmapFont());
			this._textRenderer.text = "Hello World";
			this._textRenderer.isEnabled = false;
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("BitmapFontTextRenderer currentTextFormat must be equal to disabledTextFormat when isEnabled is false and disabledTextFormat is not null",
				this._textRenderer.disabledTextFormat, this._textRenderer.currentTextFormat);
		}

		[Test]
		public function testCurrentTextFormatWithTextFormatAndStateContextDisabled():void
		{
			var stateContext:CustomToggle = new CustomToggle();
			stateContext.isEnabled = false;
			this._textRenderer.stateContext = stateContext;
			this._textRenderer.textFormat = new BitmapFontTextFormat(new BitmapFont());
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("BitmapFontTextRenderer currentTextFormat must be equal to textFormat when stateContext isEnabled is false, but no other text formats are specified",
				this._textRenderer.textFormat, this._textRenderer.currentTextFormat);
		}

		[Test]
		public function testCurrentTextFormatWithDisabledTextFormatAndStateContextDisabled():void
		{
			var stateContext:CustomToggle = new CustomToggle();
			stateContext.isEnabled = false;
			this._textRenderer.stateContext = stateContext;
			this._textRenderer.textFormat = new BitmapFontTextFormat(new BitmapFont());
			this._textRenderer.disabledTextFormat = new BitmapFontTextFormat(new BitmapFont());
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("BitmapFontTextRenderer currentTextFormat must be equal to disabledTextFormat when isEnabled is false and disabledTextFormat is not null",
				this._textRenderer.disabledTextFormat, this._textRenderer.currentTextFormat);
		}

		[Test]
		public function testCurrentTextFormatWithTextFormatAndStateContextSelected():void
		{
			var stateContext:CustomToggle = new CustomToggle();
			stateContext.isSelected = true;
			this._textRenderer.stateContext = stateContext;
			this._textRenderer.textFormat = new BitmapFontTextFormat(new BitmapFont());
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("BitmapFontTextRenderer currentTextFormat must be equal to textFormat when stateContext isSelected is true, but no other text formats are specified",
				this._textRenderer.textFormat, this._textRenderer.currentTextFormat);
		}

		[Test]
		public function testCurrentTextFormatWithSelectedTextFormatAndStateContextSelected():void
		{
			var stateContext:CustomToggle = new CustomToggle();
			stateContext.isSelected = true;
			this._textRenderer.stateContext = stateContext;
			this._textRenderer.textFormat = new BitmapFontTextFormat(new BitmapFont());
			this._textRenderer.selectedTextFormat = new BitmapFontTextFormat(new BitmapFont());
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("BitmapFontTextRenderer currentTextFormat must be equal to selectedTextFormat when isSelected is true and selectedTextFormat is not null",
				this._textRenderer.selectedTextFormat, this._textRenderer.currentTextFormat);
		}

		[Test]
		public function testCurrentTextFormatWithSelectedAndDisabledTextFormatAndStateContextSelectedAndDisabled():void
		{
			var stateContext:CustomToggle = new CustomToggle();
			stateContext.isSelected = true;
			stateContext.isEnabled = false;
			this._textRenderer.stateContext = stateContext;
			this._textRenderer.textFormat = new BitmapFontTextFormat(new BitmapFont());
			this._textRenderer.disabledTextFormat = new BitmapFontTextFormat(new BitmapFont());
			this._textRenderer.selectedTextFormat = new BitmapFontTextFormat(new BitmapFont());
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			//disabled should get priority over selected
			Assert.assertStrictlyEquals("BitmapFontTextRenderer currentTextFormat must be equal to disabledTextFormat when isSelected is true and isEnabled is false and both selectedTextFormat and disabledTextFormat are not null",
				this._textRenderer.disabledTextFormat, this._textRenderer.currentTextFormat);
		}

		[Test]
		public function testCurrentTextFormatWithOnlyTextFormatAndStateContextCurrentState():void
		{
			var stateContext:CustomToggle = new CustomToggle();
			stateContext.currentState = STATE_DISABLED;
			this._textRenderer.stateContext = stateContext;
			this._textRenderer.textFormat = new BitmapFontTextFormat(new BitmapFont());
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("BitmapFontTextRenderer currentTextFormat must be equal to textFormat when no other text formats are specified",
				this._textRenderer.textFormat, this._textRenderer.currentTextFormat);
		}

		[Test]
		public function testCurrentTextFormatWithDisabledTextFormatAndStateTextFormatWithStateContextDisabledAndCurrentState():void
		{
			var stateContext:CustomToggle = new CustomToggle();
			stateContext.isEnabled = false;
			stateContext.isSelected = true;
			stateContext.currentState = STATE_DISABLED;
			this._textRenderer.stateContext = stateContext;
			this._textRenderer.textFormat = new BitmapFontTextFormat(new BitmapFont());
			this._textRenderer.disabledTextFormat = new BitmapFontTextFormat(new BitmapFont());
			this._textRenderer.selectedTextFormat = new BitmapFontTextFormat(new BitmapFont());
			var disabledStateTextFormat:BitmapFontTextFormat = new BitmapFontTextFormat(new BitmapFont());
			this._textRenderer.setTextFormatForState(STATE_DISABLED, disabledStateTextFormat);
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			//exact states always get priority over default/disabled/selected
			Assert.assertStrictlyEquals("BitmapFontTextRenderer currentTextFormat must be equal to BitmapFontTextFormat passed into setTextFormatForState() when isEnabled is false and disabledTextFormat are not null",
				disabledStateTextFormat, this._textRenderer.currentTextFormat);
		}

		[Test]
		public function testFontStylesIgnoredIfAdvancedBitmapFontTextFormatExists():void
		{
			var fontStyles:FontStylesSet = new FontStylesSet();
			fontStyles.format = new TextFormat();
			this._textRenderer.fontStyles = fontStyles;
			this._textRenderer.textFormat = new BitmapFontTextFormat(new BitmapFont());
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("BitmapFontTextRenderer currentTextFormat must be equal to elementFormat and not a format from font styles",
				this._textRenderer.textFormat, this._textRenderer.currentTextFormat);
		}

		[Test]
		public function testCurrentTextFormatWithFontStyles():void
		{
			var fontStyles:FontStylesSet = new FontStylesSet();
			fontStyles.format = new TextFormat(DEFAULT_FONT_NAME, DEFAULT_FONT_SIZE, DEFAULT_COLOR);
			this._textRenderer.fontStyles = fontStyles;
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("BitmapFontTextRenderer currentTextFormat.fontName must be equal to starling.text.TextFormat font",
				TextField.getBitmapFont(DEFAULT_FONT_NAME), this._textRenderer.currentTextFormat.font);
			Assert.assertStrictlyEquals("BitmapFontTextRenderer currentTextFormat.size must be equal to starling.text.TextFormat size",
				DEFAULT_FONT_SIZE, this._textRenderer.currentTextFormat.size);
			Assert.assertStrictlyEquals("BitmapFontTextRenderer currentTextFormat.color must be equal to starling.text.TextFormat color",
				DEFAULT_COLOR, this._textRenderer.currentTextFormat.color);
		}

		[Test]
		public function testCurrentTextFormatFallBackToDefaultFontStylesWhenDisabled():void
		{
			var fontStyles:FontStylesSet = new FontStylesSet();
			fontStyles.format = new TextFormat(DEFAULT_FONT_NAME, DEFAULT_FONT_SIZE, DEFAULT_COLOR);
			this._textRenderer.fontStyles = fontStyles;
			this._textRenderer.text = "Hello World";
			this._textRenderer.isEnabled = false;
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("BitmapFontTextRenderer currentTextFormat.fontName must be equal to starling.text.TextFormat font",
				TextField.getBitmapFont(DEFAULT_FONT_NAME), this._textRenderer.currentTextFormat.font);
			Assert.assertStrictlyEquals("BitmapFontTextRenderer currentTextFormat.size must be equal to starling.text.TextFormat size",
				DEFAULT_FONT_SIZE, this._textRenderer.currentTextFormat.size);
			Assert.assertStrictlyEquals("BitmapFontTextRenderer currentTextFormat.color must be equal to starling.text.TextFormat color",
				DEFAULT_COLOR, this._textRenderer.currentTextFormat.color);
		}

		[Test]
		public function testCurrentTextFormatUseDisabledFontStylesWhenDisabled():void
		{
			var fontStyles:FontStylesSet = new FontStylesSet();
			fontStyles.format = new TextFormat(DEFAULT_FONT_NAME, DEFAULT_FONT_SIZE, DEFAULT_COLOR);
			fontStyles.disabledFormat = new TextFormat(DISABLED_FONT_NAME, DISABLED_FONT_SIZE, DISABLED_COLOR);
			this._textRenderer.fontStyles = fontStyles;
			this._textRenderer.text = "Hello World";
			this._textRenderer.isEnabled = false;
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("BitmapFontTextRenderer currentTextFormat.fontName must be equal to starling.text.TextFormat font",
				TextField.getBitmapFont(DISABLED_FONT_NAME), this._textRenderer.currentTextFormat.font);
			Assert.assertStrictlyEquals("BitmapFontTextRenderer currentTextFormat.size must be equal to starling.text.TextFormat size",
				DISABLED_FONT_SIZE, this._textRenderer.currentTextFormat.size);
			Assert.assertStrictlyEquals("BitmapFontTextRenderer currentTextFormat.color must be equal to starling.text.TextFormat color",
				DISABLED_COLOR, this._textRenderer.currentTextFormat.color);
		}

		[Test]
		public function testCurrentTextFormatFallBackToDefaultFontStylesWithStateContextDisabled():void
		{
			var stateContext:CustomToggle = new CustomToggle();
			stateContext.isEnabled = false;
			this._textRenderer.stateContext = stateContext;
			var fontStyles:FontStylesSet = new FontStylesSet();
			fontStyles.format = new TextFormat(DEFAULT_FONT_NAME, DEFAULT_FONT_SIZE, DEFAULT_COLOR);
			this._textRenderer.fontStyles = fontStyles;
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("BitmapFontTextRenderer currentTextFormat.fontName must be equal to starling.text.TextFormat font",
				TextField.getBitmapFont(DEFAULT_FONT_NAME), this._textRenderer.currentTextFormat.font);
			Assert.assertStrictlyEquals("BitmapFontTextRenderer currentTextFormat.size must be equal to starling.text.TextFormat size",
				DEFAULT_FONT_SIZE, this._textRenderer.currentTextFormat.size);
			Assert.assertStrictlyEquals("BitmapFontTextRenderer currentTextFormat.color must be equal to starling.text.TextFormat color",
				DEFAULT_COLOR, this._textRenderer.currentTextFormat.color);
		}

		[Test]
		public function testCurrentTextFormatUseDisabledFontStylesWithStateContextDisabled():void
		{
			var stateContext:CustomToggle = new CustomToggle();
			stateContext.isEnabled = false;
			this._textRenderer.stateContext = stateContext;
			var fontStyles:FontStylesSet = new FontStylesSet();
			fontStyles.format = new TextFormat(DEFAULT_FONT_NAME, DEFAULT_FONT_SIZE, DEFAULT_COLOR);
			fontStyles.disabledFormat = new TextFormat(DISABLED_FONT_NAME, DISABLED_FONT_SIZE, DISABLED_COLOR);
			this._textRenderer.fontStyles = fontStyles;
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("BitmapFontTextRenderer currentTextFormat.fontName must be equal to starling.text.TextFormat font",
				TextField.getBitmapFont(DISABLED_FONT_NAME), this._textRenderer.currentTextFormat.font);
			Assert.assertStrictlyEquals("BitmapFontTextRenderer currentTextFormat.size must be equal to starling.text.TextFormat size",
				DISABLED_FONT_SIZE, this._textRenderer.currentTextFormat.size);
			Assert.assertStrictlyEquals("BitmapFontTextRenderer currentTextFormat.color must be equal to starling.text.TextFormat color",
				DISABLED_COLOR, this._textRenderer.currentTextFormat.color);
		}

		[Test]
		public function testCurrentTextFormatFallBackToDefaultFontStylesWithStateContextSelected():void
		{
			var stateContext:CustomToggle = new CustomToggle();
			stateContext.isSelected = true;
			this._textRenderer.stateContext = stateContext;
			var fontStyles:FontStylesSet = new FontStylesSet();
			fontStyles.format = new TextFormat(DEFAULT_FONT_NAME, DEFAULT_FONT_SIZE, DEFAULT_COLOR);
			this._textRenderer.fontStyles = fontStyles;
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("BitmapFontTextRenderer currentTextFormat.fontName must be equal to starling.text.TextFormat font",
				TextField.getBitmapFont(DEFAULT_FONT_NAME), this._textRenderer.currentTextFormat.font);
			Assert.assertStrictlyEquals("BitmapFontTextRenderer currentTextFormat.size must be equal to starling.text.TextFormat size",
				DEFAULT_FONT_SIZE, this._textRenderer.currentTextFormat.size);
			Assert.assertStrictlyEquals("BitmapFontTextRenderer currentTextFormat.color must be equal to starling.text.TextFormat color",
				DEFAULT_COLOR, this._textRenderer.currentTextFormat.color);
		}

		[Test]
		public function testCurrentTextFormatUseSelectedFontStylesWithStateContextSelected():void
		{
			var stateContext:CustomToggle = new CustomToggle();
			stateContext.isSelected = true;
			this._textRenderer.stateContext = stateContext;
			var fontStyles:FontStylesSet = new FontStylesSet();
			fontStyles.format = new TextFormat(DEFAULT_FONT_NAME, DEFAULT_FONT_SIZE, DEFAULT_COLOR);
			fontStyles.selectedFormat = new TextFormat(SELECTED_FONT_NAME, SELECTED_FONT_SIZE, SELECTED_COLOR);
			this._textRenderer.fontStyles = fontStyles;
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("BitmapFontTextRenderer currentTextFormat.fontName must be equal to starling.text.TextFormat font",
				TextField.getBitmapFont(SELECTED_FONT_NAME), this._textRenderer.currentTextFormat.font);
			Assert.assertStrictlyEquals("BitmapFontTextRenderer currentTextFormat.size must be equal to starling.text.TextFormat size",
				SELECTED_FONT_SIZE, this._textRenderer.currentTextFormat.size);
			Assert.assertStrictlyEquals("BitmapFontTextRenderer currentTextFormat.color must be equal to starling.text.TextFormat color",
				SELECTED_COLOR, this._textRenderer.currentTextFormat.color);
		}

		[Test]
		public function testCurrentTextFormatUseDisabledFontStylesWithStateContextSelectedAndDisabled():void
		{
			var stateContext:CustomToggle = new CustomToggle();
			stateContext.isSelected = true;
			stateContext.isEnabled = false;
			this._textRenderer.stateContext = stateContext;
			var fontStyles:FontStylesSet = new FontStylesSet();
			fontStyles.format = new TextFormat(DEFAULT_FONT_NAME, DEFAULT_FONT_SIZE, DEFAULT_COLOR);
			fontStyles.selectedFormat = new TextFormat(SELECTED_FONT_NAME, SELECTED_FONT_SIZE, SELECTED_COLOR);
			fontStyles.disabledFormat = new TextFormat(DISABLED_FONT_NAME, DISABLED_FONT_SIZE, DISABLED_COLOR);
			this._textRenderer.fontStyles = fontStyles;
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			//disabled should get priority over selected
			Assert.assertStrictlyEquals("BitmapFontTextRenderer currentTextFormat.fontName must be equal to starling.text.TextFormat font",
				TextField.getBitmapFont(DISABLED_FONT_NAME), this._textRenderer.currentTextFormat.font);
			Assert.assertStrictlyEquals("BitmapFontTextRenderer currentTextFormat.size must be equal to starling.text.TextFormat size",
				DISABLED_FONT_SIZE, this._textRenderer.currentTextFormat.size);
			Assert.assertStrictlyEquals("BitmapFontTextRenderer currentTextFormat.color must be equal to starling.text.TextFormat color",
				DISABLED_COLOR, this._textRenderer.currentTextFormat.color);
		}

		[Test]
		public function testCurrentTextFormatFallBackToDefaultFontStylesWithStateContextCurrentState():void
		{
			var stateContext:CustomToggle = new CustomToggle();
			stateContext.currentState = STATE_DISABLED;
			this._textRenderer.stateContext = stateContext;
			var fontStyles:FontStylesSet = new FontStylesSet();
			fontStyles.format = new TextFormat(DEFAULT_FONT_NAME, DEFAULT_FONT_SIZE, DEFAULT_COLOR);
			this._textRenderer.fontStyles = fontStyles;
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("BitmapFontTextRenderer currentTextFormat.fontName must be equal to starling.text.TextFormat font",
				TextField.getBitmapFont(DEFAULT_FONT_NAME), this._textRenderer.currentTextFormat.font);
			Assert.assertStrictlyEquals("BitmapFontTextRenderer currentTextFormat.size must be equal to starling.text.TextFormat size",
				DEFAULT_FONT_SIZE, this._textRenderer.currentTextFormat.size);
			Assert.assertStrictlyEquals("BitmapFontTextRenderer currentTextFormat.color must be equal to starling.text.TextFormat color",
				DEFAULT_COLOR, this._textRenderer.currentTextFormat.color);
		}

		[Test]
		public function testCurrentTextFormatUseStateFontStylesWithStateContextCurrentState():void
		{
			var stateContext:CustomToggle = new CustomToggle();
			stateContext.currentState = STATE_DISABLED;
			stateContext.isSelected = true;
			stateContext.isEnabled = false;
			this._textRenderer.stateContext = stateContext;
			var fontStyles:FontStylesSet = new FontStylesSet();
			fontStyles.format = new TextFormat(DEFAULT_FONT_NAME, DEFAULT_FONT_SIZE, DEFAULT_COLOR);
			fontStyles.selectedFormat = new TextFormat(SELECTED_FONT_NAME, SELECTED_FONT_SIZE, SELECTED_COLOR);
			fontStyles.disabledFormat = new TextFormat(DISABLED_FONT_NAME, DISABLED_FONT_SIZE, DISABLED_COLOR);
			fontStyles.setFormatForState(STATE_DISABLED, new TextFormat(STATE_FONT_NAME, STATE_FONT_SIZE, STATE_COLOR));
			this._textRenderer.fontStyles = fontStyles;
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			//exact states always get priority over default/disabled/selected
			Assert.assertStrictlyEquals("BitmapFontTextRenderer currentTextFormat.fontName must be equal to starling.text.TextFormat font",
				TextField.getBitmapFont(STATE_FONT_NAME), this._textRenderer.currentTextFormat.font);
			Assert.assertStrictlyEquals("BitmapFontTextRenderer currentTextFormat.size must be equal to starling.text.TextFormat size",
				STATE_FONT_SIZE, this._textRenderer.currentTextFormat.size);
			Assert.assertStrictlyEquals("BitmapFontTextRenderer currentTextFormat.color must be equal to starling.text.TextFormat color",
				STATE_COLOR, this._textRenderer.currentTextFormat.color);
		}

		[Test]
		public function testInvalidAfterChangePropertyOfFontStyles():void
		{
			var format:TextFormat = new TextFormat(DEFAULT_FONT_NAME, DEFAULT_FONT_SIZE, DEFAULT_COLOR);
			var fontStyles:FontStylesSet = new FontStylesSet();
			fontStyles.format = format
			this._textRenderer.fontStyles = fontStyles;
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			format.color = SELECTED_COLOR;
			Assert.assertTrue("BitmapFontTextRenderer: must be invalid after changing property of font styles.",
				this._textRenderer.isInvalid());
		}
	}
}
