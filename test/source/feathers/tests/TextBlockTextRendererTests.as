package feathers.tests
{
	import feathers.controls.text.TextBlockTextRenderer;
	import feathers.tests.supportClasses.CustomStateContext;

	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;

	import org.flexunit.Assert;

	public class TextBlockTextRendererTests
	{
		private static const STATE_DISABLED:String = "disabled";

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
			stateContext.currentState = STATE_DISABLED;
			this._textRenderer.stateContext = stateContext;
			var font:FontDescription = new FontDescription("_sans");
			this._textRenderer.elementFormat = new ElementFormat(font);
			this._textRenderer.disabledElementFormat = new ElementFormat(font);
			var disabledStateElementFormat:ElementFormat = new ElementFormat(font);
			this._textRenderer.setElementFormatForState(STATE_DISABLED, disabledStateElementFormat);
			this._textRenderer.text = "Hello World";
			this._textRenderer.validate();
			Assert.assertStrictlyEquals("TextBlockTextRenderer currentElementFormat must be equal to ElementFormat passed into setElementFormatForState() when isEnabled is false and disabledElementFormat are not null",
				disabledStateElementFormat, this._textRenderer.currentElementFormat);
		}
	}
}
