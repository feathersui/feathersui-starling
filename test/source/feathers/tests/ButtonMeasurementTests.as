package feathers.tests
{
	import feathers.controls.Button;
	import feathers.controls.LayoutGroup;
	import feathers.controls.text.BitmapFontTextRenderer;

	import org.flexunit.Assert;

	import starling.display.Quad;

	public class ButtonMeasurementTests
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
		
		private var _button:Button;
		
		private var _textRenderer:BitmapFontTextRenderer;

		[Before]
		public function prepare():void
		{
			this._button = new Button();
			this._button.labelFactory = function():BitmapFontTextRenderer
			{
				return new BitmapFontTextRenderer();
			}
			TestFeathers.starlingRoot.addChild(this._button);

			this._textRenderer = new BitmapFontTextRenderer();
			TestFeathers.starlingRoot.addChild(this._textRenderer);
		}

		[After]
		public function cleanup():void
		{
			this._button.removeFromParent(true);
			this._button = null;
			
			this._textRenderer.removeFromParent(true);
			this._textRenderer = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}
		
		private function addSmallSimpleIcon():void
		{
			this._button.defaultIcon = new Quad(SMALL_ICON_WIDTH, SMALL_ICON_HEIGHT, 0xff00ff);
		}

		private function addLargeSimpleIcon():void
		{
			this._button.defaultIcon = new Quad(LARGE_ICON_WIDTH, LARGE_ICON_HEIGHT, 0xff00ff);
		}

		private function addComplexIcon():void
		{
			var icon:LayoutGroup = new LayoutGroup();
			icon.width = COMPLEX_ICON_WIDTH;
			icon.height = COMPLEX_ICON_HEIGHT;
			icon.minWidth = COMPLEX_ICON_MIN_WIDTH;
			icon.minHeight = COMPLEX_ICON_MIN_HEIGHT;
			this._button.defaultIcon = icon;
		}

		private function addSmallSimpleBackground():void
		{
			this._button.defaultSkin = new Quad(SMALL_BACKGROUND_WIDTH, SMALL_BACKGROUND_HEIGHT, 0xff00ff);
		}

		private function addLargeSimpleBackground():void
		{
			this._button.defaultSkin = new Quad(LARGE_BACKGROUND_WIDTH, LARGE_BACKGROUND_HEIGHT, 0xff00ff);
		}

		private function addComplexBackground():void
		{
			var backgroundSkin:LayoutGroup = new LayoutGroup();
			backgroundSkin.width = COMPLEX_BACKGROUND_WIDTH;
			backgroundSkin.height = COMPLEX_BACKGROUND_HEIGHT;
			backgroundSkin.minWidth = COMPLEX_BACKGROUND_MIN_WIDTH;
			backgroundSkin.minHeight = COMPLEX_BACKGROUND_MIN_HEIGHT;
			this._button.defaultSkin = backgroundSkin;
		}

		[Test]
		public function testAutoSizeWithPadding():void
		{
			this._button.paddingTop = PADDING_TOP;
			this._button.paddingRight = PADDING_RIGHT;
			this._button.paddingBottom = PADDING_BOTTOM;
			this._button.paddingLeft = PADDING_LEFT;
			this._button.validate();

			Assert.assertStrictlyEquals("The width of the Button was not calculated correctly based on the left and right padding.",
				PADDING_LEFT + PADDING_RIGHT, this._button.width);
			Assert.assertStrictlyEquals("The height of the Button was not calculated correctly based on the top and bottom padding.",
				PADDING_TOP + PADDING_BOTTOM, this._button.height);
			Assert.assertStrictlyEquals("The minWidth of the Button was not calculated correctly based on the left and right padding.",
				PADDING_LEFT + PADDING_RIGHT, this._button.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Button was not calculated correctly based on the top and bottom padding.",
				PADDING_TOP + PADDING_BOTTOM, this._button.minHeight);
		}

		[Test]
		public function testAutoSizeWithLabel():void
		{
			var labelText:String = "I am the very model of a modern major general";
			this._textRenderer.text = labelText;
			this._textRenderer.validate();

			this._button.label = labelText;
			this._button.validate();

			Assert.assertTrue("The width of the Button was not greater than 0 when using a label.",
				this._button.width > 0);
			Assert.assertTrue("The height of the Button was not greater than 0 when using a label.",
				this._button.height > 0);
			Assert.assertTrue("The minWidth of the Button was not greater than 0 when using a label.",
				this._button.minWidth > 0);
			Assert.assertTrue("The minHeight of the Button was not greater than 0 when using a label.",
				this._button.minHeight > 0);
			Assert.assertStrictlyEquals("The width of the Button was not calculated correctly based on the label.",
				this._textRenderer.width, this._button.width);
			Assert.assertStrictlyEquals("The height of the Button was not calculated correctly based on the label.",
				this._textRenderer.height, this._button.height);
			Assert.assertStrictlyEquals("The minWidth of the Button was not calculated correctly based on the label.",
				this._textRenderer.width, this._button.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Button was not calculated correctly based on the label.",
				this._textRenderer.height, this._button.minHeight);
		}

		[Test]
		public function testAutoSizeWithLabelAndPadding():void
		{
			var labelText:String = "I am the very model of a modern major general";
			this._textRenderer.text = labelText;
			this._textRenderer.validate();

			this._button.label = labelText;
			this._button.paddingTop = PADDING_TOP;
			this._button.paddingRight = PADDING_RIGHT;
			this._button.paddingBottom = PADDING_BOTTOM;
			this._button.paddingLeft = PADDING_LEFT;
			this._button.validate();

			Assert.assertStrictlyEquals("The width of the Button was not calculated correctly based on the label and left and right padding.",
				this._textRenderer.width + PADDING_LEFT + PADDING_RIGHT, this._button.width);
			Assert.assertStrictlyEquals("The height of the Button was not calculated correctly based on the label and top and bottom padding.",
				this._textRenderer.height + PADDING_TOP + PADDING_BOTTOM, this._button.height);
			Assert.assertStrictlyEquals("The minWidth of the Button was not calculated correctly based on the label and left and right padding.",
				this._textRenderer.width + PADDING_LEFT + PADDING_RIGHT, this._button.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Button was not calculated correctly based on the label and top and bottom padding.",
				this._textRenderer.height + PADDING_TOP + PADDING_BOTTOM, this._button.minHeight);
		}

		[Test]
		public function testAutoSizeWithLabelAndSimpleIcon():void
		{
			var labelText:String = "I am the very model of a modern major general";
			this._textRenderer.text = labelText;
			this._textRenderer.validate();

			this.addLargeSimpleIcon();
			this._button.label = labelText;
			this._button.validate();

			Assert.assertStrictlyEquals("The width of the Button was not calculated correctly based on the label and icon.",
				this._textRenderer.width + LARGE_ICON_WIDTH, this._button.width);
			Assert.assertStrictlyEquals("The height of the Button was not calculated correctly based on the label and icon.",
				LARGE_ICON_HEIGHT, this._button.height);
			Assert.assertStrictlyEquals("The minWidth of the Button was not calculated correctly based on the label and icon.",
				this._textRenderer.width + LARGE_ICON_WIDTH, this._button.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Button was not calculated correctly based on the label and icon.",
				LARGE_ICON_HEIGHT, this._button.minHeight);
		}

		[Test]
		public function testAutoSizeWithLabelGapAndSimpleIcon():void
		{
			var labelText:String = "I am the very model of a modern major general";
			this._textRenderer.text = labelText;
			this._textRenderer.validate();

			this.addLargeSimpleIcon();
			this._button.label = labelText;
			this._button.gap = GAP;
			this._button.validate();

			Assert.assertStrictlyEquals("The width of the Button was not calculated correctly based on the label, gap, and icon.",
				this._textRenderer.width + GAP + LARGE_ICON_WIDTH, this._button.width);
			Assert.assertStrictlyEquals("The height of the Button was not calculated correctly based on the label, gap, and icon.",
				LARGE_ICON_HEIGHT, this._button.height);
			Assert.assertStrictlyEquals("The minWidth of the Button was not calculated correctly based on the label, gap, and icon.",
				this._textRenderer.width + GAP + LARGE_ICON_WIDTH, this._button.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Button was not calculated correctly based on the label, and icon.",
				LARGE_ICON_HEIGHT, this._button.minHeight);
		}

		[Test]
		public function testAutoSizeWithLabelGapPaddingAndSimpleIcon():void
		{
			var labelText:String = "I am the very model of a modern major general";
			this._textRenderer.text = labelText;
			this._textRenderer.validate();

			this.addLargeSimpleIcon();
			this._button.label = labelText;
			this._button.paddingTop = PADDING_TOP;
			this._button.paddingRight = PADDING_RIGHT;
			this._button.paddingBottom = PADDING_BOTTOM;
			this._button.paddingLeft = PADDING_LEFT;
			this._button.gap = GAP;
			this._button.validate();

			Assert.assertStrictlyEquals("The width of the Button was not calculated correctly based on the label, gap, left and right padding, and icon.",
				this._textRenderer.width + GAP + LARGE_ICON_WIDTH + PADDING_LEFT + PADDING_RIGHT, this._button.width);
			Assert.assertStrictlyEquals("The height of the Button was not calculated correctly based on the label, gap, top and bottom padding, and icon.",
				LARGE_ICON_HEIGHT + PADDING_TOP + PADDING_BOTTOM, this._button.height);
			Assert.assertStrictlyEquals("The minWidth of the Button was not calculated correctly based on the label, gap, left and right padding, and icon.",
				this._textRenderer.width + GAP + LARGE_ICON_WIDTH + PADDING_LEFT + PADDING_RIGHT, this._button.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Button was not calculated correctly based on the label, gap, top and bottom padding, and icon.",
				LARGE_ICON_HEIGHT + PADDING_TOP + PADDING_BOTTOM, this._button.minHeight);
		}

		[Test]
		public function testAutoSizeWithSimpleIcon():void
		{
			this.addLargeSimpleIcon();
			this._button.validate();

			Assert.assertStrictlyEquals("The width of the Button was not calculated correctly based on the icon width.",
				LARGE_ICON_WIDTH, this._button.width);
			Assert.assertStrictlyEquals("The height of the Button was not calculated correctly based on the icon height.",
				LARGE_ICON_HEIGHT, this._button.height);
			Assert.assertStrictlyEquals("The minWidth of the Button was not calculated correctly based on the icon width.",
				LARGE_ICON_WIDTH, this._button.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Button was not calculated correctly based on the icon height.",
				LARGE_ICON_HEIGHT, this._button.minHeight);
		}

		[Test]
		public function testAutoSizeWithComplexIcon():void
		{
			this.addComplexIcon();
			this._button.validate();

			Assert.assertStrictlyEquals("The width of the Button was not calculated correctly based on the complex icon width.",
				COMPLEX_ICON_WIDTH, this._button.width);
			Assert.assertStrictlyEquals("The height of the Button was not calculated correctly based on the complex icon height.",
				COMPLEX_ICON_HEIGHT, this._button.height);
			Assert.assertStrictlyEquals("The minWidth of the Button was not calculated correctly based on the complex icon minWidth.",
				COMPLEX_ICON_MIN_WIDTH, this._button.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Button was not calculated correctly based on the complex icon minHeight.",
				COMPLEX_ICON_MIN_HEIGHT, this._button.minHeight);
		}

		[Test]
		public function testAutoSizeWithSimpleBackgroundSkin():void
		{
			this.addSmallSimpleBackground();
			this._button.validate();

			Assert.assertStrictlyEquals("The width of the Button was not calculated correctly based on the background width.",
				SMALL_BACKGROUND_WIDTH, this._button.width);
			Assert.assertStrictlyEquals("The height of the Button was not calculated correctly based on the background height.",
				SMALL_BACKGROUND_HEIGHT, this._button.height);
			Assert.assertStrictlyEquals("The minWidth of the Button was not calculated correctly based on the background width.",
				SMALL_BACKGROUND_WIDTH, this._button.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Button was not calculated correctly based on the background height.",
				SMALL_BACKGROUND_HEIGHT, this._button.minHeight);
		}

		[Test]
		public function testAutoSizeWithSmallSimpleBackgroundSkinAndLargeSimpleIcon():void
		{
			this.addSmallSimpleBackground();
			this.addLargeSimpleIcon();
			this._button.validate();

			Assert.assertStrictlyEquals("The width of the Button was not calculated correctly based on the icon width.",
				LARGE_ICON_WIDTH, this._button.width);
			Assert.assertStrictlyEquals("The height of the Button was not calculated correctly based on the icon height.",
				LARGE_ICON_HEIGHT, this._button.height);
			Assert.assertStrictlyEquals("The minWidth of the Button was not calculated correctly based on the icon width.",
				LARGE_ICON_WIDTH, this._button.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Button was not calculated correctly based on the icon height.",
				LARGE_ICON_HEIGHT, this._button.minHeight);
		}

		[Test]
		public function testAutoSizeWithLargeSimpleBackgroundSkinAndSmallSimpleIcon():void
		{
			this.addLargeSimpleBackground();
			this.addSmallSimpleIcon();
			this._button.validate();

			Assert.assertStrictlyEquals("The width of the Button was not calculated correctly based on the background width.",
				LARGE_BACKGROUND_WIDTH, this._button.width);
			Assert.assertStrictlyEquals("The height of the Button was not calculated correctly based on the background height.",
				LARGE_BACKGROUND_HEIGHT, this._button.height);
			Assert.assertStrictlyEquals("The minWidth of the Button was not calculated correctly based on the background width.",
				LARGE_BACKGROUND_WIDTH, this._button.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Button was not calculated correctly based on the background height.",
				LARGE_BACKGROUND_HEIGHT, this._button.minHeight);
		}

		[Test]
		public function testAutoSizeWithComplexBackground():void
		{
			this.addComplexBackground();
			this._button.validate();

			Assert.assertStrictlyEquals("The width of the Button was not calculated correctly based on the complex background width.",
				COMPLEX_BACKGROUND_WIDTH, this._button.width);
			Assert.assertStrictlyEquals("The height of the Button was not calculated correctly based on the complex background height.",
				COMPLEX_BACKGROUND_HEIGHT, this._button.height);
			Assert.assertStrictlyEquals("The minWidth of the Button was not calculated correctly based on the complex background minWidth.",
				COMPLEX_BACKGROUND_MIN_WIDTH, this._button.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Button was not calculated correctly based on the complex background minHeight.",
				COMPLEX_BACKGROUND_MIN_HEIGHT, this._button.minHeight);
		}

		[Test]
		public function testAutoSizeWithLargeSimpleBackgroundPaddingAndGap():void
		{
			this._button.paddingTop = PADDING_TOP;
			this._button.paddingRight = PADDING_RIGHT;
			this._button.paddingBottom = PADDING_BOTTOM;
			this._button.paddingLeft = PADDING_LEFT;
			this._button.gap = GAP;
			this.addLargeSimpleBackground();
			this._button.validate();
			Assert.assertStrictlyEquals("The width of the Button was not calculated correctly with background skin, padding, and gap.",
				LARGE_BACKGROUND_WIDTH, this._button.width);
			Assert.assertStrictlyEquals("The height of the Button was not calculated correctly with background skin, padding, and gap.",
				LARGE_BACKGROUND_HEIGHT, this._button.height);
			Assert.assertStrictlyEquals("The minWidth of the Button was not calculated correctly with background skin, padding, and gap.",
				LARGE_BACKGROUND_WIDTH, this._button.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Button was not calculated correctly with background skin, padding, and gap.",
				LARGE_BACKGROUND_HEIGHT, this._button.minHeight);
		}
	}
}
