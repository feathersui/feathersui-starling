package feathers.tests
{
	import feathers.controls.text.TextBlockTextRenderer;
	import feathers.tests.supportClasses.CustomStateContext;
	import feathers.text.FontStylesSet;

	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;

	import org.flexunit.Assert;

	import starling.text.TextFormat;

	public class TextBlockTextRendererTests
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

		private var _textRenderer:TextBlockTextRenderer;

		[Before]
		public function prepare():void
		{
			this._textRenderer = new TextBlockTextRenderer();
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
			Assert.assertStrictlyEquals("TextBlockTextRenderer numLines must be 1 with empty string", 1, this._textRenderer.numLines);
		}

		[Test]
		public function testOneLine():void
		{
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("TextBlockTextRenderer numLines must be 1", 1, this._textRenderer.numLines);
		}

		[Test]
		public function testNumLinesWithLineBreak():void
		{
			this._textRenderer.text = "Hello\nWorld";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("TextBlockTextRenderer numLines must be 2 when line break is in text", 2, this._textRenderer.numLines);
		}

		[Test]
		public function testNumLinesWithCarriageReturn():void
		{
			this._textRenderer.text = "Hello\rWorld";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("TextBlockTextRenderer numLines must be 2 when carriage return is in text", 2, this._textRenderer.numLines);
		}

		[Test]
		public function testGetElementFormatForStateWithoutSetElementFormatForState():void
		{
			Assert.assertNull("TextBlockTextRenderer getElementFormatForState() must return null if ElementFormat not provided with setElementFormatForState()",
				this._textRenderer.getElementFormatForState(STATE_DISABLED));
		}

		[Test]
		public function testGetElementFormatForStateAfterSetElementFormatForState():void
		{
			var elementFormat:ElementFormat = new ElementFormat();
			this._textRenderer.setElementFormatForState(STATE_DISABLED, elementFormat);
			Assert.assertStrictlyEquals("TextBlockTextRenderer getElementFormatForState() must return value passed to setElementFormatForState() with same state",
				elementFormat, this._textRenderer.getElementFormatForState(STATE_DISABLED));
		}

		[Test]
		public function testCurrentElementFormatWithElementFormat():void
		{
			var font:FontDescription = new FontDescription("_sans");
			this._textRenderer.elementFormat = new ElementFormat(font);
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("TextBlockTextRenderer currentElementFormat must be equal to elementFormat when no other element formats are specified",
				this._textRenderer.elementFormat, this._textRenderer.currentElementFormat);
		}

		[Test]
		public function testCurrentElementFormatWithElementFormatAndDisabled():void
		{
			var font:FontDescription = new FontDescription("_sans");
			this._textRenderer.elementFormat = new ElementFormat(font);
			this._textRenderer.text = "Hello World";
			this._textRenderer.isEnabled = false;
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("TextBlockTextRenderer currentElementFormat must be equal to elementFormat when isEnabled is false, but no other element formats are specified",
				this._textRenderer.elementFormat, this._textRenderer.currentElementFormat);
		}

		[Test]
		public function testCurrentElementFormatWithDisabledElementFormatAndDisabled():void
		{
			var font:FontDescription = new FontDescription("_sans");
			this._textRenderer.elementFormat = new ElementFormat(font);
			this._textRenderer.disabledElementFormat = new ElementFormat(font);
			this._textRenderer.text = "Hello World";
			this._textRenderer.isEnabled = false;
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("TextBlockTextRenderer currentElementFormat must be equal to disabledElementFormat when isEnabled is false and disabledElementFormat is not null",
				this._textRenderer.disabledElementFormat, this._textRenderer.currentElementFormat);
		}

		[Test]
		public function testCurrentElementFormatWithElementFormatAndStateContextDisabled():void
		{
			var stateContext:CustomStateContext = new CustomStateContext();
			stateContext.isEnabled = false;
			this._textRenderer.stateContext = stateContext;
			var font:FontDescription = new FontDescription("_sans");
			this._textRenderer.elementFormat = new ElementFormat(font);
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("TextBlockTextRenderer currentElementFormat must be equal to elementFormat when stateContext isEnabled is false, but no other element formats are specified",
				this._textRenderer.elementFormat, this._textRenderer.currentElementFormat);
		}

		[Test]
		public function testCurrentElementFormatWithDisabledElementFormatAndStateContextDisabled():void
		{
			var stateContext:CustomStateContext = new CustomStateContext();
			stateContext.isEnabled = false;
			this._textRenderer.stateContext = stateContext;
			var font:FontDescription = new FontDescription("_sans");
			this._textRenderer.elementFormat = new ElementFormat(font);
			this._textRenderer.disabledElementFormat = new ElementFormat(font);
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("TextBlockTextRenderer currentElementFormat must be equal to disabledElementFormat when isEnabled is false and disabledElementFormat is not null",
				this._textRenderer.disabledElementFormat, this._textRenderer.currentElementFormat);
		}

		[Test]
		public function testCurrentElementFormatWithElementFormatAndStateContextSelected():void
		{
			var stateContext:CustomStateContext = new CustomStateContext();
			stateContext.isSelected = true;
			this._textRenderer.stateContext = stateContext;
			var font:FontDescription = new FontDescription("_sans");
			this._textRenderer.elementFormat = new ElementFormat(font);
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("TextBlockTextRenderer currentElementFormat must be equal to elementFormat when stateContext isSelected is true, but no other element formats are specified",
				this._textRenderer.elementFormat, this._textRenderer.currentElementFormat);
		}

		[Test]
		public function testCurrentElementFormatWithSelectedElementFormatAndStateContextSelected():void
		{
			var stateContext:CustomStateContext = new CustomStateContext();
			stateContext.isSelected = true;
			this._textRenderer.stateContext = stateContext;
			var font:FontDescription = new FontDescription("_sans");
			this._textRenderer.elementFormat = new ElementFormat(font);
			this._textRenderer.selectedElementFormat = new ElementFormat(font);
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("TextBlockTextRenderer currentElementFormat must be equal to selectedElementFormat when isSelected is true and selectedElementFormat is not null",
				this._textRenderer.selectedElementFormat, this._textRenderer.currentElementFormat);
		}

		[Test]
		public function testCurrentElementFormatWithSelectedAndDisabledElementFormatAndStateContextSelectedAndDisabled():void
		{
			var stateContext:CustomStateContext = new CustomStateContext();
			stateContext.isSelected = true;
			stateContext.isEnabled = false;
			this._textRenderer.stateContext = stateContext;
			var font:FontDescription = new FontDescription("_sans");
			this._textRenderer.elementFormat = new ElementFormat(font);
			this._textRenderer.disabledElementFormat = new ElementFormat(font);
			this._textRenderer.selectedElementFormat = new ElementFormat(font);
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			//disabled should get priority over selected
			Assert.assertStrictlyEquals("TextBlockTextRenderer currentElementFormat must be equal to disabledElementFormat when isSelected is true and isEnabled is false and both selectedElementFormat and disabledElementFormat are not null",
				this._textRenderer.disabledElementFormat, this._textRenderer.currentElementFormat);
		}

		[Test]
		public function testCurrentElementFormatWithOnlyElementFormatAndStateContextCurrentState():void
		{
			var stateContext:CustomStateContext = new CustomStateContext();
			stateContext.currentState = STATE_DISABLED;
			this._textRenderer.stateContext = stateContext;
			var font:FontDescription = new FontDescription("_sans");
			this._textRenderer.elementFormat = new ElementFormat(font);
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("TextBlockTextRenderer currentElementFormat must be equal to elementFormat when no other element formats are specified",
				this._textRenderer.elementFormat, this._textRenderer.currentElementFormat);
		}

		[Test]
		public function testCurrentElementFormatWithDisabledElementFormatAndStateElementFormatWithStateContextDisabledAndCurrentState():void
		{
			var stateContext:CustomStateContext = new CustomStateContext();
			stateContext.isEnabled = false;
			stateContext.isSelected = true;
			stateContext.currentState = STATE_DISABLED;
			this._textRenderer.stateContext = stateContext;
			var font:FontDescription = new FontDescription("_sans");
			this._textRenderer.elementFormat = new ElementFormat(font);
			this._textRenderer.disabledElementFormat = new ElementFormat(font);
			this._textRenderer.selectedElementFormat = new ElementFormat(font);
			var disabledStateElementFormat:ElementFormat = new ElementFormat(font);
			this._textRenderer.setElementFormatForState(STATE_DISABLED, disabledStateElementFormat);
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			//exact states always get priority over default/disabled/selected
			Assert.assertStrictlyEquals("TextBlockTextRenderer currentElementFormat must be equal to ElementFormat passed into setElementFormatForState() when isEnabled is false and disabledElementFormat are not null",
				disabledStateElementFormat, this._textRenderer.currentElementFormat);
		}

		[Test]
		public function testFontStylesIgnoredIfAdvancedElementFormatExists():void
		{
			var fontStyles:FontStylesSet = new FontStylesSet();
			fontStyles.format = new TextFormat();
			this._textRenderer.fontStyles = fontStyles;
			var font:FontDescription = new FontDescription("_sans");
			this._textRenderer.elementFormat = new ElementFormat(font);
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("TextBlockTextRenderer currentElementFormat must be equal to elementFormat and not a format from font styles",
				this._textRenderer.elementFormat, this._textRenderer.currentElementFormat);
		}

		[Test]
		public function testCurrentElementFormatWithFontStyles():void
		{
			var fontStyles:FontStylesSet = new FontStylesSet();
			fontStyles.format = new TextFormat(DEFAULT_FONT_NAME, DEFAULT_FONT_SIZE, DEFAULT_COLOR);
			this._textRenderer.fontStyles = fontStyles;
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("TextBlockTextRenderer currentElementFormat.fontDescription.fontName must be equal to starling.text.TextFormat font",
				DEFAULT_FONT_NAME, this._textRenderer.currentElementFormat.fontDescription.fontName);
			Assert.assertStrictlyEquals("TextBlockTextRenderer currentElementFormat.fontSize must be equal to starling.text.TextFormat size",
				DEFAULT_FONT_SIZE, this._textRenderer.currentElementFormat.fontSize);
			Assert.assertStrictlyEquals("TextBlockTextRenderer currentElementFormat.color must be equal to starling.text.TextFormat color",
				DEFAULT_COLOR, this._textRenderer.currentElementFormat.color);
		}

		[Test]
		public function testCurrentElementFormatFallBackToDefaultFontStylesWhenDisabled():void
		{
			var fontStyles:FontStylesSet = new FontStylesSet();
			fontStyles.format = new TextFormat(DEFAULT_FONT_NAME, DEFAULT_FONT_SIZE, DEFAULT_COLOR);
			this._textRenderer.fontStyles = fontStyles;
			this._textRenderer.text = "Hello World";
			this._textRenderer.isEnabled = false;
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("TextBlockTextRenderer currentElementFormat.fontDescription.fontName must be equal to starling.text.TextFormat font",
				DEFAULT_FONT_NAME, this._textRenderer.currentElementFormat.fontDescription.fontName);
			Assert.assertStrictlyEquals("TextBlockTextRenderer currentElementFormat.fontSize must be equal to starling.text.TextFormat size",
				DEFAULT_FONT_SIZE, this._textRenderer.currentElementFormat.fontSize);
			Assert.assertStrictlyEquals("TextBlockTextRenderer currentElementFormat.color must be equal to starling.text.TextFormat color",
				DEFAULT_COLOR, this._textRenderer.currentElementFormat.color);
		}

		[Test]
		public function testCurrentElementFormatUseDisabledFontStylesWhenDisabled():void
		{
			var fontStyles:FontStylesSet = new FontStylesSet();
			fontStyles.format = new TextFormat(DEFAULT_FONT_NAME, DEFAULT_FONT_SIZE, DEFAULT_COLOR);
			fontStyles.disabledFormat = new TextFormat(DISABLED_FONT_NAME, DISABLED_FONT_SIZE, DISABLED_COLOR);
			this._textRenderer.fontStyles = fontStyles;
			this._textRenderer.text = "Hello World";
			this._textRenderer.isEnabled = false;
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("TextBlockTextRenderer currentElementFormat.fontDescription.fontName must be equal to starling.text.TextFormat font",
				DISABLED_FONT_NAME, this._textRenderer.currentElementFormat.fontDescription.fontName);
			Assert.assertStrictlyEquals("TextBlockTextRenderer currentElementFormat.fontSize must be equal to starling.text.TextFormat size",
				DISABLED_FONT_SIZE, this._textRenderer.currentElementFormat.fontSize);
			Assert.assertStrictlyEquals("TextBlockTextRenderer currentElementFormat.color must be equal to starling.text.TextFormat color",
				DISABLED_COLOR, this._textRenderer.currentElementFormat.color);
		}

		[Test]
		public function testCurrentElementFormatFallBackToDefaultFontStylesWithStateContextDisabled():void
		{
			var stateContext:CustomStateContext = new CustomStateContext();
			stateContext.isEnabled = false;
			this._textRenderer.stateContext = stateContext;
			var fontStyles:FontStylesSet = new FontStylesSet();
			fontStyles.format = new TextFormat(DEFAULT_FONT_NAME, DEFAULT_FONT_SIZE, DEFAULT_COLOR);
			this._textRenderer.fontStyles = fontStyles;
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("TextBlockTextRenderer currentElementFormat.fontDescription.fontName must be equal to starling.text.TextFormat font",
				DEFAULT_FONT_NAME, this._textRenderer.currentElementFormat.fontDescription.fontName);
			Assert.assertStrictlyEquals("TextBlockTextRenderer currentElementFormat.fontSize must be equal to starling.text.TextFormat size",
				DEFAULT_FONT_SIZE, this._textRenderer.currentElementFormat.fontSize);
			Assert.assertStrictlyEquals("TextBlockTextRenderer currentElementFormat.color must be equal to starling.text.TextFormat color",
				DEFAULT_COLOR, this._textRenderer.currentElementFormat.color);
		}

		[Test]
		public function testCurrentElementFormatUseDisabledFontStylesWithStateContextDisabled():void
		{
			var stateContext:CustomStateContext = new CustomStateContext();
			stateContext.isEnabled = false;
			this._textRenderer.stateContext = stateContext;
			var fontStyles:FontStylesSet = new FontStylesSet();
			fontStyles.format = new TextFormat(DEFAULT_FONT_NAME, DEFAULT_FONT_SIZE, DEFAULT_COLOR);
			fontStyles.disabledFormat = new TextFormat(DISABLED_FONT_NAME, DISABLED_FONT_SIZE, DISABLED_COLOR);
			this._textRenderer.fontStyles = fontStyles;
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("TextBlockTextRenderer currentElementFormat.fontDescription.fontName must be equal to starling.text.TextFormat font",
				DISABLED_FONT_NAME, this._textRenderer.currentElementFormat.fontDescription.fontName);
			Assert.assertStrictlyEquals("TextBlockTextRenderer currentElementFormat.fontSize must be equal to starling.text.TextFormat size",
				DISABLED_FONT_SIZE, this._textRenderer.currentElementFormat.fontSize);
			Assert.assertStrictlyEquals("TextBlockTextRenderer currentElementFormat.color must be equal to starling.text.TextFormat color",
				DISABLED_COLOR, this._textRenderer.currentElementFormat.color);
		}

		[Test]
		public function testCurrentElementFormatFallBackToDefaultFontStylesWithStateContextSelected():void
		{
			var stateContext:CustomStateContext = new CustomStateContext();
			stateContext.isSelected = true;
			this._textRenderer.stateContext = stateContext;
			var fontStyles:FontStylesSet = new FontStylesSet();
			fontStyles.format = new TextFormat(DEFAULT_FONT_NAME, DEFAULT_FONT_SIZE, DEFAULT_COLOR);
			this._textRenderer.fontStyles = fontStyles;
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("TextBlockTextRenderer currentElementFormat.fontDescription.fontName must be equal to starling.text.TextFormat font",
				DEFAULT_FONT_NAME, this._textRenderer.currentElementFormat.fontDescription.fontName);
			Assert.assertStrictlyEquals("TextBlockTextRenderer currentElementFormat.fontSize must be equal to starling.text.TextFormat size",
				DEFAULT_FONT_SIZE, this._textRenderer.currentElementFormat.fontSize);
			Assert.assertStrictlyEquals("TextBlockTextRenderer currentElementFormat.color must be equal to starling.text.TextFormat color",
				DEFAULT_COLOR, this._textRenderer.currentElementFormat.color);
		}

		[Test]
		public function testCurrentElementFormatUseSelectedFontStylesWithStateContextSelected():void
		{
			var stateContext:CustomStateContext = new CustomStateContext();
			stateContext.isSelected = true;
			this._textRenderer.stateContext = stateContext;
			var fontStyles:FontStylesSet = new FontStylesSet();
			fontStyles.format = new TextFormat(DEFAULT_FONT_NAME, DEFAULT_FONT_SIZE, DEFAULT_COLOR);
			fontStyles.selectedFormat = new TextFormat(SELECTED_FONT_NAME, SELECTED_FONT_SIZE, SELECTED_COLOR);
			this._textRenderer.fontStyles = fontStyles;
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("TextBlockTextRenderer currentElementFormat.fontDescription.fontName must be equal to starling.text.TextFormat font",
				SELECTED_FONT_NAME, this._textRenderer.currentElementFormat.fontDescription.fontName);
			Assert.assertStrictlyEquals("TextBlockTextRenderer currentElementFormat.fontSize must be equal to starling.text.TextFormat size",
				SELECTED_FONT_SIZE, this._textRenderer.currentElementFormat.fontSize);
			Assert.assertStrictlyEquals("TextBlockTextRenderer currentElementFormat.color must be equal to starling.text.TextFormat color",
				SELECTED_COLOR, this._textRenderer.currentElementFormat.color);
		}

		[Test]
		public function testCurrentElementFormatUseDisabledFontStylesWithStateContextSelectedAndDisabled():void
		{
			var stateContext:CustomStateContext = new CustomStateContext();
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
			Assert.assertStrictlyEquals("TextBlockTextRenderer currentElementFormat.fontDescription.fontName must be equal to starling.text.TextFormat font",
				DISABLED_FONT_NAME, this._textRenderer.currentElementFormat.fontDescription.fontName);
			Assert.assertStrictlyEquals("TextBlockTextRenderer currentElementFormat.fontSize must be equal to starling.text.TextFormat size",
				DISABLED_FONT_SIZE, this._textRenderer.currentElementFormat.fontSize);
			Assert.assertStrictlyEquals("TextBlockTextRenderer currentElementFormat.color must be equal to starling.text.TextFormat color",
				DISABLED_COLOR, this._textRenderer.currentElementFormat.color);
		}

		[Test]
		public function testCurrentElementFormatFallBackToDefaultFontStylesWithStateContextCurrentState():void
		{
			var stateContext:CustomStateContext = new CustomStateContext();
			stateContext.currentState = STATE_DISABLED;
			this._textRenderer.stateContext = stateContext;
			var fontStyles:FontStylesSet = new FontStylesSet();
			fontStyles.format = new TextFormat(DEFAULT_FONT_NAME, DEFAULT_FONT_SIZE, DEFAULT_COLOR);
			this._textRenderer.fontStyles = fontStyles;
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("TextBlockTextRenderer currentElementFormat.fontDescription.fontName must be equal to starling.text.TextFormat font",
				DEFAULT_FONT_NAME, this._textRenderer.currentElementFormat.fontDescription.fontName);
			Assert.assertStrictlyEquals("TextBlockTextRenderer currentElementFormat.fontSize must be equal to starling.text.TextFormat size",
				DEFAULT_FONT_SIZE, this._textRenderer.currentElementFormat.fontSize);
			Assert.assertStrictlyEquals("TextBlockTextRenderer currentElementFormat.color must be equal to starling.text.TextFormat color",
				DEFAULT_COLOR, this._textRenderer.currentElementFormat.color);
		}

		[Test]
		public function testCurrentElementFormatUseStateFontStylesWithStateContextCurrentState():void
		{
			var stateContext:CustomStateContext = new CustomStateContext();
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
			Assert.assertStrictlyEquals("TextBlockTextRenderer currentElementFormat.fontDescription.fontName must be equal to starling.text.TextFormat font",
				STATE_FONT_NAME, this._textRenderer.currentElementFormat.fontDescription.fontName);
			Assert.assertStrictlyEquals("TextBlockTextRenderer currentElementFormat.fontSize must be equal to starling.text.TextFormat size",
				STATE_FONT_SIZE, this._textRenderer.currentElementFormat.fontSize);
			Assert.assertStrictlyEquals("TextBlockTextRenderer currentElementFormat.color must be equal to starling.text.TextFormat color",
				STATE_COLOR, this._textRenderer.currentElementFormat.color);
		}
	}
}
