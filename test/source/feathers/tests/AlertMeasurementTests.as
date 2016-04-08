package feathers.tests
{
	import feathers.controls.Alert;
	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.controls.Header;
	import feathers.controls.LayoutGroup;
	import feathers.controls.text.BitmapFontTextRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.Direction;

	import org.flexunit.Assert;

	import starling.display.Quad;

	public class AlertMeasurementTests
	{
		private static const BACKGROUND_WIDTH:Number = 200;
		private static const BACKGROUND_HEIGHT:Number = 250;

		private static const COMPLEX_BACKGROUND_WIDTH:Number = 340;
		private static const COMPLEX_BACKGROUND_HEIGHT:Number = 350;
		private static const COMPLEX_BACKGROUND_MIN_WIDTH:Number = 280;
		private static const COMPLEX_BACKGROUND_MIN_HEIGHT:Number = 290;

		private static const PADDING_TOP:Number = 50;
		private static const PADDING_RIGHT:Number = 54;
		private static const PADDING_BOTTOM:Number = 59;
		private static const PADDING_LEFT:Number = 60;

		private static const HEADER_WIDTH:Number = 150;
		private static const HEADER_HEIGHT:Number = 40;

		private static const LARGE_HEADER_WIDTH:Number = 550;

		private static const ICON_WIDTH:Number = 120;
		private static const ICON_HEIGHT:Number = 110;

		private static const BUTTON_WIDTH:Number = 160;
		private static const BUTTON_HEIGHT:Number = 30;
		
		private static const GAP:Number = 4;

		private var _alert:Alert;
		private var _textRenderer:BitmapFontTextRenderer;

		[Before]
		public function prepare():void
		{
			this._alert = new Alert();
			this._alert.footerFactory = function():ButtonGroup
			{
				var footer:ButtonGroup = new ButtonGroup();
				footer.direction = Direction.HORIZONTAL;
				footer.buttonFactory = function():Button
				{
					var button:Button = new Button();
					button.defaultSkin = new Quad(BUTTON_WIDTH, BUTTON_HEIGHT, 0x00ff00);
					return button;
				};
				return footer;
			};
			TestFeathers.starlingRoot.addChild(this._alert);
			
			this._textRenderer = new BitmapFontTextRenderer();
			TestFeathers.starlingRoot.addChild(this._textRenderer);
		}

		[After]
		public function cleanup():void
		{
			this._alert.removeFromParent(true);
			this._alert = null;
			
			this._textRenderer.removeFromParent(true);
			this._textRenderer = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		private function addSimpleBackground():void
		{
			this._alert.backgroundSkin = new Quad(BACKGROUND_WIDTH, BACKGROUND_HEIGHT, 0xff00ff);
		}

		private function addComplexBackground():void
		{
			var backgroundSkin:LayoutGroup = new LayoutGroup();
			backgroundSkin.width = COMPLEX_BACKGROUND_WIDTH;
			backgroundSkin.height = COMPLEX_BACKGROUND_HEIGHT;
			backgroundSkin.minWidth = COMPLEX_BACKGROUND_MIN_WIDTH;
			backgroundSkin.minHeight = COMPLEX_BACKGROUND_MIN_HEIGHT;
			this._alert.backgroundSkin = backgroundSkin;
		}

		private function addHeader():void
		{
			this._alert.headerFactory = function():Header
			{
				var header:Header = new Header();
				header.backgroundSkin = new Quad(HEADER_WIDTH, HEADER_HEIGHT, 0xff00ff);
				return header;
			};
		}

		private function addWideHeader():void
		{
			this._alert.headerFactory = function():Header
			{
				var header:Header = new Header();
				header.backgroundSkin = new Quad(LARGE_HEADER_WIDTH, HEADER_HEIGHT, 0xff00ff);
				return header;
			};
		}

		[Test]
		public function testAutoSizeWithHeader():void
		{
			this.addHeader();
			this._alert.validate();
			Assert.assertStrictlyEquals("The width of the Alert was not calculated correctly with a header.",
				HEADER_WIDTH, this._alert.width);
			Assert.assertStrictlyEquals("The height of the Alert was not calculated correctly with a header.",
				HEADER_HEIGHT, this._alert.height);
			Assert.assertStrictlyEquals("The minWidth of the Alert was not calculated correctly with a header.",
				HEADER_WIDTH, this._alert.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Alert was not calculated correctly with a header.",
				HEADER_HEIGHT, this._alert.minHeight);
		}

		[Test]
		public function testAutoSizeWithHeaderAndPadding():void
		{
			this.addHeader();
			this._alert.paddingTop = PADDING_TOP;
			this._alert.paddingRight = PADDING_RIGHT;
			this._alert.paddingBottom = PADDING_BOTTOM;
			this._alert.paddingLeft = PADDING_LEFT;
			this._alert.validate();

			Assert.assertStrictlyEquals("The width of the Alert was not calculated correctly based on the header and left and right padding.",
				HEADER_WIDTH, this._alert.width);
			Assert.assertStrictlyEquals("The height of the Alert was not calculated correctly based on the header and top and bottom padding.",
				HEADER_HEIGHT + PADDING_TOP + PADDING_BOTTOM, this._alert.height);
			Assert.assertStrictlyEquals("The minWidth of the Alert was not calculated correctly based on the header and left and right padding.",
				HEADER_WIDTH, this._alert.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Alert was not calculated correctly based on the header and top and bottom padding.",
				HEADER_HEIGHT + PADDING_TOP + PADDING_BOTTOM, this._alert.minHeight);
		}

		[Test]
		public function testAutoSizeWithHeaderAndSimpleBackgroundSkin():void
		{
			this.addHeader();
			this.addSimpleBackground();
			this._alert.validate();

			Assert.assertStrictlyEquals("The width of the Alert was not calculated correctly based on the background width larger than the header width.",
				BACKGROUND_WIDTH, this._alert.width);
			Assert.assertStrictlyEquals("The height of the Alert was not calculated correctly based on the background height.",
				BACKGROUND_HEIGHT, this._alert.height);
			Assert.assertStrictlyEquals("The minWidth of the Alert was not calculated correctly based on the background width larger than the header width.",
				BACKGROUND_WIDTH, this._alert.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Alert was not calculated correctly based on the background height.",
				BACKGROUND_HEIGHT, this._alert.minHeight);
		}

		[Test]
		public function testAutoSizeWithHeaderAndComplexBackground():void
		{
			this.addHeader();
			this.addComplexBackground();
			this._alert.validate();

			Assert.assertStrictlyEquals("The width of the Alert was not calculated correctly based on the complex background width.",
				COMPLEX_BACKGROUND_WIDTH, this._alert.width);
			Assert.assertStrictlyEquals("The height of the Alert was not calculated correctly based on the complex background height.",
				COMPLEX_BACKGROUND_HEIGHT, this._alert.height);
			Assert.assertStrictlyEquals("The minWidth of the Alert was not calculated correctly based on the complex background minWidth.",
				COMPLEX_BACKGROUND_MIN_WIDTH, this._alert.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Alert was not calculated correctly based on the complex background minHeight.",
				COMPLEX_BACKGROUND_MIN_HEIGHT, this._alert.minHeight);
		}

		[Test]
		public function testAutoSizeWithHeaderAndFooter():void
		{
			this.addHeader();
			this._alert.buttonsDataProvider = new ListCollection(
			[
				{},
				{},
				{},
			]);
			this._alert.validate();
			Assert.assertStrictlyEquals("The width of the Alert was not calculated correctly with header and footer.",
				BUTTON_WIDTH * 3, this._alert.width);
			Assert.assertStrictlyEquals("The height of the Alert was not calculated correctly with header and footer.",
				HEADER_HEIGHT + BUTTON_HEIGHT, this._alert.height);
			Assert.assertStrictlyEquals("The minWidth of the Alert was not calculated correctly with header and footer.",
				BUTTON_WIDTH * 3, this._alert.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Alert was not calculated correctly with header and footer.",
				HEADER_HEIGHT + BUTTON_HEIGHT, this._alert.minHeight);
		}

		[Test]
		public function testAutoSizeWidthWithHeaderAndSmallerFooter():void
		{
			this.addWideHeader();
			this._alert.buttonsDataProvider = new ListCollection(
			[
				{},
			]);
			this._alert.validate();
			Assert.assertStrictlyEquals("The width of the Alert was not calculated correctly with header and footer.",
				LARGE_HEADER_WIDTH, this._alert.width);
			Assert.assertStrictlyEquals("The minWidth of the Alert was not calculated correctly with header and footer.",
				LARGE_HEADER_WIDTH, this._alert.minWidth);
		}

		[Test]
		public function testAutoSizeWithHeaderFooterAndPadding():void
		{
			this.addHeader();
			this._alert.buttonsDataProvider = new ListCollection(
			[
				{},
				{},
				{},
			]);
			this._alert.paddingTop = PADDING_TOP;
			this._alert.paddingRight = PADDING_RIGHT;
			this._alert.paddingBottom = PADDING_BOTTOM;
			this._alert.paddingLeft = PADDING_LEFT;
			this._alert.validate();

			Assert.assertStrictlyEquals("The width of the Alert was not calculated correctly based on the header, footer, and left and right padding.",
				BUTTON_WIDTH * 3, this._alert.width);
			Assert.assertStrictlyEquals("The height of the Alert was not calculated correctly based on the header, footer, and top and bottom padding.",
				HEADER_HEIGHT + BUTTON_HEIGHT + PADDING_TOP + PADDING_BOTTOM, this._alert.height);
			Assert.assertStrictlyEquals("The minWidth of the Alert was not calculated correctly based on the header, footer, and left and right padding.",
				BUTTON_WIDTH * 3, this._alert.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Alert was not calculated correctly based on the header, footer, and top and bottom padding.",
				HEADER_HEIGHT + BUTTON_HEIGHT + PADDING_TOP + PADDING_BOTTOM, this._alert.minHeight);
		}

		[Test]
		public function testAutoSizeWithHeaderFooterAndLargerSimpleBackgroundSkin():void
		{
			this.addHeader();
			this._alert.buttonsDataProvider = new ListCollection(
			[
				{},
			]);
			this.addSimpleBackground();
			this._alert.validate();

			Assert.assertStrictlyEquals("The width of the Alert was not calculated correctly based on the background width with a smaller header and footer.",
				BACKGROUND_WIDTH, this._alert.width);
			Assert.assertStrictlyEquals("The height of the Alert was not calculated correctly based on the background width with a smaller header and footer.",
				BACKGROUND_HEIGHT, this._alert.height);
			Assert.assertStrictlyEquals("The minWidth of the Alert was not calculated correctly based on the background height with a smaller header and footer.",
				BACKGROUND_WIDTH, this._alert.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Alert was not calculated correctly based on the background width with a smaller header and footer.",
				BACKGROUND_HEIGHT, this._alert.minHeight);
		}

		[Test]
		public function testAutoSizeWithHeaderFooterAndLargerComplexBackground():void
		{
			this.addHeader();
			this._alert.buttonsDataProvider = new ListCollection(
			[
				{},
			]);
			this.addComplexBackground();
			this._alert.validate();

			Assert.assertStrictlyEquals("The width of the Alert was not calculated correctly based on the complex background width with a smaller header and footer.",
				COMPLEX_BACKGROUND_WIDTH, this._alert.width);
			Assert.assertStrictlyEquals("The height of the Alert was not calculated correctly based on the complex background height with a smaller header and footer.",
				COMPLEX_BACKGROUND_HEIGHT, this._alert.height);
			Assert.assertStrictlyEquals("The minWidth of the Alert was not calculated correctly based on the complex background minWidth with a smaller header and footer.",
				COMPLEX_BACKGROUND_MIN_WIDTH, this._alert.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Alert was not calculated correctly based on the complex background minHeight with a smaller header and footer.",
				COMPLEX_BACKGROUND_MIN_HEIGHT, this._alert.minHeight);
		}

		[Test]
		public function testAutoSizeWithHeaderAndShortMessage():void
		{
			var message:String = "Hello";
			this.addHeader();
			this._alert.message = message;
			this._alert.validate();

			this._textRenderer.text = message;
			this._textRenderer.validate();
			
			Assert.assertStrictlyEquals("The width of the Alert was not calculated correctly with a header and short message.",
				HEADER_WIDTH, this._alert.width);
			Assert.assertStrictlyEquals("The height of the Alert was not calculated correctly with a header and short message.",
				HEADER_HEIGHT + this._textRenderer.height, this._alert.height);
			Assert.assertStrictlyEquals("The minWidth of the Alert was not calculated correctly with a header and short message.",
				HEADER_WIDTH, this._alert.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Alert was not calculated correctly with a header and short message.",
				HEADER_HEIGHT + this._textRenderer.minHeight, this._alert.minHeight);
		}

		[Test]
		public function testAutoSizeWithHeaderAndLongMessage():void
		{
			var message:String = "I am the very model of a modern major general";
			this.addHeader();
			this._alert.message = message;
			this._alert.validate();

			this._textRenderer.text = message;
			this._textRenderer.validate();
			
			Assert.assertStrictlyEquals("The width of the Alert was not calculated correctly with a header and long message.",
				this._textRenderer.width, this._alert.width);
			Assert.assertStrictlyEquals("The height of the Alert was not calculated correctly with a header and long message.",
				HEADER_HEIGHT + this._textRenderer.height, this._alert.height);
			Assert.assertStrictlyEquals("The minWidth of the Alert was not calculated correctly with a header and long message.",
				this._textRenderer.minWidth, this._alert.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Alert was not calculated correctly with a header and long message.",
				HEADER_HEIGHT + this._textRenderer.minHeight, this._alert.minHeight);
		}

		[Test]
		public function testAutoSizeWithHeaderIconAndLongMessage():void
		{
			var message:String = "I am the very model of a modern major general";
			this.addHeader();
			this._alert.message = message;
			this._alert.icon = new Quad(ICON_WIDTH, ICON_HEIGHT);
			this._alert.validate();

			this._textRenderer.text = message;
			this._textRenderer.validate();

			Assert.assertStrictlyEquals("The width of the Alert was not calculated correctly with a header, icon, and long message.",
				ICON_WIDTH + this._textRenderer.width, this._alert.width);
			Assert.assertStrictlyEquals("The height of the Alert was not calculated correctly with a header, icon, and long message.",
				HEADER_HEIGHT + ICON_HEIGHT, this._alert.height);
			Assert.assertStrictlyEquals("The minWidth of the Alert was not calculated correctly with a header, icon, and long message.",
				ICON_WIDTH + this._textRenderer.width, this._alert.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Alert was not calculated correctly with a header, icon, and long message.",
				HEADER_HEIGHT + ICON_HEIGHT, this._alert.minHeight);
		}

		[Test]
		public function testAutoSizeWithHeaderIconGapAndLongMessage():void
		{
			var message:String = "I am the very model of a modern major general";
			this.addHeader();
			this._alert.message = message;
			this._alert.gap = GAP;
			this._alert.icon = new Quad(ICON_WIDTH, ICON_HEIGHT);
			this._alert.validate();

			this._textRenderer.text = message;
			this._textRenderer.validate();

			Assert.assertStrictlyEquals("The width of the Alert was not calculated correctly with a header, icon, gap, and long message.",
				ICON_WIDTH + GAP + this._textRenderer.width, this._alert.width);
			Assert.assertStrictlyEquals("The height of the Alert was not calculated correctly with a header, icon, gap, and long message.",
				HEADER_HEIGHT + ICON_HEIGHT, this._alert.height);
			Assert.assertStrictlyEquals("The minWidth of the Alert was not calculated correctly with a header, icon, gap, and long message.",
				ICON_WIDTH + GAP + this._textRenderer.width, this._alert.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Alert was not calculated correctly with a header, icon, gap, and long message.",
				HEADER_HEIGHT + ICON_HEIGHT, this._alert.minHeight);
		}

		[Test]
		public function testAutoSizeWithHeaderMessageAndMeasureViewPortSetToFalse():void
		{
			var message:String = "I am the very model of a modern major general";
			this.addHeader();
			this._alert.message = message;
			this._alert.measureViewPort = false;
			this._alert.validate();

			this._textRenderer.text = message;
			this._textRenderer.validate();
			
			Assert.assertStrictlyEquals("The width of the Alert was not calculated correctly with a header.",
				HEADER_WIDTH, this._alert.width);
			Assert.assertStrictlyEquals("The height of the Alert was not calculated correctly with a header.",
				HEADER_HEIGHT, this._alert.height);
			Assert.assertStrictlyEquals("The minWidth of the Alert was not calculated correctly with a header.",
				HEADER_WIDTH, this._alert.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Alert was not calculated correctly with a header.",
				HEADER_HEIGHT, this._alert.minHeight);
		}
	}
}
