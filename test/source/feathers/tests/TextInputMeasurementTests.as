package feathers.tests
{
	import feathers.controls.LayoutGroup;
	import feathers.controls.TextInput;
	import feathers.controls.text.BitmapFontTextRenderer;
	import feathers.core.ITextRenderer;

	import org.flexunit.Assert;

	import starling.display.Quad;

	public class TextInputMeasurementTests
	{
		private static const SMALL_BACKGROUND_WIDTH:Number = 10;
		private static const SMALL_BACKGROUND_HEIGHT:Number = 12;
		private static const LARGE_BACKGROUND_WIDTH:Number = 200;
		private static const LARGE_BACKGROUND_HEIGHT:Number = 210;
		private static const COMPLEX_BACKGROUND_WIDTH:Number = 54;
		private static const COMPLEX_BACKGROUND_HEIGHT:Number = 55;
		private static const COMPLEX_BACKGROUND_MIN_WIDTH:Number = 38;
		private static const COMPLEX_BACKGROUND_MIN_HEIGHT:Number = 39;

		private static const SMALL_ICON_WIDTH:Number = 13;
		private static const SMALL_ICON_HEIGHT:Number = 11;
		private static const LARGE_ICON_WIDTH:Number = 105;
		private static const LARGE_ICON_HEIGHT:Number = 115;
		private static const COMPLEX_ICON_WIDTH:Number = 23;
		private static const COMPLEX_ICON_HEIGHT:Number = 25;
		private static const COMPLEX_ICON_MIN_WIDTH:Number = 18;
		private static const COMPLEX_ICON_MIN_HEIGHT:Number = 19;
		
		private static const PADDING_TOP:Number = 50;
		private static const PADDING_RIGHT:Number = 54;
		private static const PADDING_BOTTOM:Number = 59;
		private static const PADDING_LEFT:Number = 60;
		private static const GAP:Number = 6;

		private var input:TextInput;
		private var textRenderer:BitmapFontTextRenderer;

		[Before]
		public function prepare():void
		{
			this.input = new TextInput();
			this.input.promptFactory = function():ITextRenderer
			{
				return new BitmapFontTextRenderer();
			};
			TestFeathers.starlingRoot.addChild(this.input);

			this.textRenderer = new BitmapFontTextRenderer();
			TestFeathers.starlingRoot.addChild(this.textRenderer);
		}

		[After]
		public function cleanup():void
		{
			this.textRenderer.removeFromParent(true);
			this.textRenderer = null;
			
			this.input.removeFromParent(true);
			this.input = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		private function addSmallSimpleBackground():void
		{
			this.input.backgroundSkin = new Quad(SMALL_BACKGROUND_WIDTH, SMALL_BACKGROUND_HEIGHT, 0xff00ff);
		}

		private function addLargeSimpleBackground():void
		{
			this.input.backgroundSkin = new Quad(LARGE_BACKGROUND_WIDTH, LARGE_BACKGROUND_HEIGHT, 0xff00ff);
		}

		private function addComplexBackground():void
		{
			var backgroundSkin:LayoutGroup = new LayoutGroup();
			backgroundSkin.width = COMPLEX_BACKGROUND_WIDTH;
			backgroundSkin.height = COMPLEX_BACKGROUND_HEIGHT;
			backgroundSkin.minWidth = COMPLEX_BACKGROUND_MIN_WIDTH;
			backgroundSkin.minHeight = COMPLEX_BACKGROUND_MIN_HEIGHT;
			this.input.backgroundSkin = backgroundSkin;
		}
		
		private function addSmallSimpleIcon():void
		{
			this.input.defaultIcon = new Quad(SMALL_ICON_WIDTH, SMALL_ICON_HEIGHT, 0xff00ff);
		}

		private function addLargeSimpleIcon():void
		{
			this.input.defaultIcon = new Quad(LARGE_ICON_WIDTH, LARGE_ICON_HEIGHT, 0xff00ff);
		}

		private function addComplexIcon():void
		{
			var icon:LayoutGroup = new LayoutGroup();
			icon.width = COMPLEX_ICON_WIDTH;
			icon.height = COMPLEX_ICON_HEIGHT;
			icon.minWidth = COMPLEX_ICON_MIN_WIDTH;
			icon.minHeight = COMPLEX_ICON_MIN_HEIGHT;
			this.input.defaultIcon = icon;
		}

		[Test]
		public function testAutoSizeWithPadding():void
		{
			this.input.paddingTop = PADDING_TOP;
			this.input.paddingRight = PADDING_RIGHT;
			this.input.paddingBottom = PADDING_BOTTOM;
			this.input.paddingLeft = PADDING_LEFT;
			this.input.validate();

			Assert.assertStrictlyEquals("The width of the TextInput was not calculated correctly based on the left and right padding.",
				PADDING_LEFT + PADDING_RIGHT, this.input.width);
			Assert.assertStrictlyEquals("The height of the TextInput was not calculated correctly based on the top and bottom padding.",
				PADDING_TOP + PADDING_BOTTOM, this.input.height);
			Assert.assertStrictlyEquals("The minWidth of the TextInput was not calculated correctly based on the left and right padding.",
				PADDING_LEFT + PADDING_RIGHT, this.input.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the TextInput was not calculated correctly based on the top and bottom padding.",
				PADDING_TOP + PADDING_BOTTOM, this.input.minHeight);
		}

		[Test]
		public function testAutoSizeWithPrompt():void
		{
			var promptText:String = "I am the very model of a modern major general";
			this.textRenderer.text = promptText;
			this.textRenderer.validate();
			
			this.input.prompt = promptText;
			this.input.validate();

			Assert.assertTrue("The width of the TextInput was not greater than 0 when using a prompt.",
				this.input.width > 0);
			Assert.assertTrue("The height of the TextInput was not greater than 0 when using a prompt.",
				this.input.height > 0);
			Assert.assertTrue("The minWidth of the TextInput was not greater than 0 when using a prompt.",
				this.input.minWidth > 0);
			Assert.assertTrue("The minHeight of the TextInput was not greater than 0 when using a prompt.",
				this.input.minHeight > 0);
			Assert.assertStrictlyEquals("The width of the TextInput was not calculated correctly based on the prompt.",
				this.textRenderer.width, this.input.width);
			Assert.assertStrictlyEquals("The height of the TextInput was not calculated correctly based on the prompt.",
				this.textRenderer.height, this.input.height);
			Assert.assertStrictlyEquals("The minWidth of the TextInput was not calculated correctly based on the prompt.",
				this.textRenderer.width, this.input.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the TextInput was not calculated correctly based on the prompt.",
				this.textRenderer.height, this.input.minHeight);
		}

		[Test]
		public function testAutoSizeWithPromptAndPadding():void
		{
			var promptText:String = "I am the very model of a modern major general";
			this.textRenderer.text = promptText;
			this.textRenderer.validate();

			this.input.prompt = promptText;
			this.input.paddingTop = PADDING_TOP;
			this.input.paddingRight = PADDING_RIGHT;
			this.input.paddingBottom = PADDING_BOTTOM;
			this.input.paddingLeft = PADDING_LEFT;
			this.input.validate();

			Assert.assertStrictlyEquals("The width of the TextInput was not calculated correctly based on the prompt and left and right padding.",
				this.textRenderer.width + PADDING_LEFT + PADDING_RIGHT, this.input.width);
			Assert.assertStrictlyEquals("The height of the TextInput was not calculated correctly based on the prompt and top and bottom padding.",
				this.textRenderer.height + PADDING_TOP + PADDING_BOTTOM, this.input.height);
			Assert.assertStrictlyEquals("The minWidth of the TextInput was not calculated correctly based on the prompt and left and right padding.",
				this.textRenderer.width + PADDING_LEFT + PADDING_RIGHT, this.input.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the TextInput was not calculated correctly based on the prompt and top and bottom padding.",
				this.textRenderer.height + PADDING_TOP + PADDING_BOTTOM, this.input.minHeight);
		}

		[Test]
		public function testAutoSizeWithPromptAndSimpleIcon():void
		{
			var promptText:String = "I am the very model of a modern major general";
			this.textRenderer.text = promptText;
			this.textRenderer.validate();

			this.addLargeSimpleIcon();
			this.input.prompt = promptText;
			this.input.validate();

			Assert.assertStrictlyEquals("The width of the TextInput was not calculated correctly based on the prompt and icon.",
				this.textRenderer.width + LARGE_ICON_WIDTH, this.input.width);
			Assert.assertStrictlyEquals("The height of the TextInput was not calculated correctly based on the prompt and icon.",
				LARGE_ICON_HEIGHT, this.input.height);
			Assert.assertStrictlyEquals("The minWidth of the TextInput was not calculated correctly based on the prompt and icon.",
				this.textRenderer.width + LARGE_ICON_WIDTH, this.input.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the TextInput was not calculated correctly based on the prompt and icon.",
				LARGE_ICON_HEIGHT, this.input.minHeight);
		}

		[Test]
		public function testAutoSizeWithPromptGapAndSimpleIcon():void
		{
			var promptText:String = "I am the very model of a modern major general";
			this.textRenderer.text = promptText;
			this.textRenderer.validate();

			this.addLargeSimpleIcon();
			this.input.prompt = promptText;
			this.input.gap = GAP;
			this.input.validate();

			Assert.assertStrictlyEquals("The width of the TextInput was not calculated correctly based on the prompt, gap, and icon.",
				this.textRenderer.width + GAP + LARGE_ICON_WIDTH, this.input.width);
			Assert.assertStrictlyEquals("The height of the TextInput was not calculated correctly based on the prompt, gap, and icon.",
				LARGE_ICON_HEIGHT, this.input.height);
			Assert.assertStrictlyEquals("The minWidth of the TextInput was not calculated correctly based on the prompt, gap, and icon.",
				this.textRenderer.width + GAP + LARGE_ICON_WIDTH, this.input.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the TextInput was not calculated correctly based on the prompt, and icon.",
				LARGE_ICON_HEIGHT, this.input.minHeight);
		}

		[Test]
		public function testAutoSizeWithPromptGapPaddingAndSimpleIcon():void
		{
			var promptText:String = "I am the very model of a modern major general";
			this.textRenderer.text = promptText;
			this.textRenderer.validate();

			this.addLargeSimpleIcon();
			this.input.prompt = promptText;
			this.input.paddingTop = PADDING_TOP;
			this.input.paddingRight = PADDING_RIGHT;
			this.input.paddingBottom = PADDING_BOTTOM;
			this.input.paddingLeft = PADDING_LEFT;
			this.input.gap = GAP;
			this.input.validate();

			Assert.assertStrictlyEquals("The width of the TextInput was not calculated correctly based on the prompt, gap, left and right padding, and icon.",
				this.textRenderer.width + GAP + LARGE_ICON_WIDTH + PADDING_LEFT + PADDING_RIGHT, this.input.width);
			Assert.assertStrictlyEquals("The height of the TextInput was not calculated correctly based on the prompt, gap, top and bottom padding, and icon.",
				LARGE_ICON_HEIGHT + PADDING_TOP + PADDING_BOTTOM, this.input.height);
			Assert.assertStrictlyEquals("The minWidth of the TextInput was not calculated correctly based on the prompt, gap, left and right padding, and icon.",
				this.textRenderer.width + GAP + LARGE_ICON_WIDTH + PADDING_LEFT + PADDING_RIGHT, this.input.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the TextInput was not calculated correctly based on the prompt, gap, top and bottom padding, and icon.",
				LARGE_ICON_HEIGHT + PADDING_TOP + PADDING_BOTTOM, this.input.minHeight);
		}

		[Test]
		public function testAutoSizeWithSimpleBackgroundSkin():void
		{
			this.addSmallSimpleBackground();
			this.input.validate();

			Assert.assertStrictlyEquals("The width of the TextInput was not calculated correctly based on the background width.",
				SMALL_BACKGROUND_WIDTH, this.input.width);
			Assert.assertStrictlyEquals("The height of the TextInput was not calculated correctly based on the background height.",
				SMALL_BACKGROUND_HEIGHT, this.input.height);
			Assert.assertStrictlyEquals("The minWidth of the TextInput was not calculated correctly based on the background width.",
				SMALL_BACKGROUND_WIDTH, this.input.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the TextInput was not calculated correctly based on the background height.",
				SMALL_BACKGROUND_HEIGHT, this.input.minHeight);
		}

		[Test]
		public function testAutoSizeWithSmallSimpleBackgroundSkinAndLargeSimpleIcon():void
		{
			this.addSmallSimpleBackground();
			this.addLargeSimpleIcon();
			this.input.validate();

			Assert.assertStrictlyEquals("The width of the TextInput was not calculated correctly based on the icon width.",
				LARGE_ICON_WIDTH, this.input.width);
			Assert.assertStrictlyEquals("The height of the TextInput was not calculated correctly based on the icon height.",
				LARGE_ICON_HEIGHT, this.input.height);
			Assert.assertStrictlyEquals("The minWidth of the TextInput was not calculated correctly based on the icon width.",
				LARGE_ICON_WIDTH, this.input.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the TextInput was not calculated correctly based on the icon height.",
				LARGE_ICON_HEIGHT, this.input.minHeight);
		}

		[Test]
		public function testAutoSizeWithLargeSimpleBackgroundSkinAndSmallSimpleIcon():void
		{
			this.addLargeSimpleBackground();
			this.addSmallSimpleIcon();
			this.input.validate();

			Assert.assertStrictlyEquals("The width of the TextInput was not calculated correctly based on the background width.",
				LARGE_BACKGROUND_WIDTH, this.input.width);
			Assert.assertStrictlyEquals("The height of the TextInput was not calculated correctly based on the background height.",
				LARGE_BACKGROUND_HEIGHT, this.input.height);
			Assert.assertStrictlyEquals("The minWidth of the TextInput was not calculated correctly based on the background width.",
				LARGE_BACKGROUND_WIDTH, this.input.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the TextInput was not calculated correctly based on the background height.",
				LARGE_BACKGROUND_HEIGHT, this.input.minHeight);
		}

		[Test]
		public function testAutoSizeWithComplexBackground():void
		{
			this.addComplexBackground();
			this.input.validate();

			Assert.assertStrictlyEquals("The width of the TextInput was not calculated correctly based on the complex background width.",
				COMPLEX_BACKGROUND_WIDTH, this.input.width);
			Assert.assertStrictlyEquals("The height of the TextInput was not calculated correctly based on the complex background height.",
				COMPLEX_BACKGROUND_HEIGHT, this.input.height);
			Assert.assertStrictlyEquals("The minWidth of the TextInput was not calculated correctly based on the complex background minWidth.",
				COMPLEX_BACKGROUND_MIN_WIDTH, this.input.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the TextInput was not calculated correctly based on the complex background minHeight.",
				COMPLEX_BACKGROUND_MIN_HEIGHT, this.input.minHeight);
		}

		[Test]
		public function testAutoSizeWithSimpleIcon():void
		{
			this.addLargeSimpleIcon();
			this.input.validate();

			Assert.assertStrictlyEquals("The width of the TextInput was not calculated correctly based on the icon width.",
				LARGE_ICON_WIDTH, this.input.width);
			Assert.assertStrictlyEquals("The height of the TextInput was not calculated correctly based on the icon height.",
				LARGE_ICON_HEIGHT, this.input.height);
			Assert.assertStrictlyEquals("The minWidth of the TextInput was not calculated correctly based on the icon width.",
				LARGE_ICON_WIDTH, this.input.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the TextInput was not calculated correctly based on the icon height.",
				LARGE_ICON_HEIGHT, this.input.minHeight);
		}

		[Test]
		public function testAutoSizeWithComplexIcon():void
		{
			this.addComplexIcon();
			this.input.validate();

			Assert.assertStrictlyEquals("The width of the TextInput was not calculated correctly based on the complex icon width.",
				COMPLEX_ICON_WIDTH, this.input.width);
			Assert.assertStrictlyEquals("The height of the TextInput was not calculated correctly based on the complex icon height.",
				COMPLEX_ICON_HEIGHT, this.input.height);
			Assert.assertStrictlyEquals("The minWidth of the TextInput was not calculated correctly based on the complex icon minWidth.",
				COMPLEX_ICON_MIN_WIDTH, this.input.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the TextInput was not calculated correctly based on the complex icon minHeight.",
				COMPLEX_ICON_MIN_HEIGHT, this.input.minHeight);
		}

		[Test]
		public function testAutoSizeWithSimpleBackgroundPaddingAndGap():void
		{
			this.input.paddingTop = PADDING_TOP;
			this.input.paddingRight = PADDING_RIGHT;
			this.input.paddingBottom = PADDING_BOTTOM;
			this.input.paddingLeft = PADDING_LEFT;
			this.input.gap = GAP;
			this.addLargeSimpleBackground();
			this.input.validate();
			Assert.assertStrictlyEquals("The width of the TextInput was not calculated correctly with background skin, padding, and gap.",
				LARGE_BACKGROUND_WIDTH, this.input.width);
			Assert.assertStrictlyEquals("The height of the TextInput was not calculated correctly with background skin, padding, and gap.",
				LARGE_BACKGROUND_HEIGHT, this.input.height);
			Assert.assertStrictlyEquals("The minWidth of the TextInput was not calculated correctly with background skin, padding, and gap.",
				LARGE_BACKGROUND_WIDTH, this.input.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the TextInput was not calculated correctly with background skin, padding, and gap.",
				LARGE_BACKGROUND_HEIGHT, this.input.minHeight);
		}
	}
}
