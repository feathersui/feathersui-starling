package feathers.tests
{
	import feathers.controls.text.TextFieldTextRenderer;

	import org.flexunit.Assert;

	public class TextFieldTextRendererTests
	{
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
	}
}
