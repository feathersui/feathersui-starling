package feathers.tests
{
	import feathers.controls.text.BitmapFontTextRenderer;
	import feathers.tests.supportClasses.CustomStateContext;
	import feathers.text.BitmapFontTextFormat;

	import org.flexunit.Assert;

	import starling.text.BitmapFont;

	public class BitmapFontTextRendererTests
	{
		private static const STATE_DISABLED:String = "disabled";

		private var _textRenderer:BitmapFontTextRenderer;

		[Before]
		public function prepare():void
		{
			this._textRenderer = new BitmapFontTextRenderer();
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
			var stateContext:CustomStateContext = new CustomStateContext();
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
			var stateContext:CustomStateContext = new CustomStateContext();
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
			var stateContext:CustomStateContext = new CustomStateContext();
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
			var stateContext:CustomStateContext = new CustomStateContext();
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
			var stateContext:CustomStateContext = new CustomStateContext();
			stateContext.isSelected = true;
			stateContext.isEnabled = false;
			this._textRenderer.stateContext = stateContext;
			this._textRenderer.textFormat = new BitmapFontTextFormat(new BitmapFont());
			this._textRenderer.disabledTextFormat = new BitmapFontTextFormat(new BitmapFont());
			this._textRenderer.selectedTextFormat = new BitmapFontTextFormat(new BitmapFont());
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("BitmapFontTextRenderer currentTextFormat must be equal to disabledTextFormat when isSelected is true and isEnabled is false and both selectedTextFormat and disabledTextFormat are not null",
				this._textRenderer.disabledTextFormat, this._textRenderer.currentTextFormat);
		}

		[Test]
		public function testCurrentTextFormatWithOnlyTextFormatAndStateContextCurrentState():void
		{
			var stateContext:CustomStateContext = new CustomStateContext();
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
			var stateContext:CustomStateContext = new CustomStateContext();
			stateContext.isEnabled = false;
			stateContext.currentState = STATE_DISABLED;
			this._textRenderer.stateContext = stateContext;
			this._textRenderer.textFormat = new BitmapFontTextFormat(new BitmapFont());
			this._textRenderer.disabledTextFormat = new BitmapFontTextFormat(new BitmapFont());
			var disabledStateTextFormat:BitmapFontTextFormat = new BitmapFontTextFormat(new BitmapFont());
			this._textRenderer.setTextFormatForState(STATE_DISABLED, disabledStateTextFormat);
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("BitmapFontTextRenderer currentTextFormat must be equal to BitmapFontTextFormat passed into setTextFormatForState() when isEnabled is false and disabledTextFormat are not null",
				disabledStateTextFormat, this._textRenderer.currentTextFormat);
		}
	}
}
