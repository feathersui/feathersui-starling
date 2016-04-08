package feathers.tests
{
	import feathers.controls.LayoutGroup;
	import feathers.controls.Panel;
	import feathers.core.IFeathersControl;

	import org.flexunit.Assert;

	import starling.display.Quad;

	public class PanelMeasurementTests
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

		private static const FOOTER_WIDTH:Number = 160;
		private static const FOOTER_HEIGHT:Number = 30;

		private static const SMALL_ITEM_WIDTH:Number = 120;
		private static const LARGE_ITEM_WIDTH:Number = 180;
		private static const ITEM_HEIGHT:Number = 60;

		private static const LARGE_HEADER_WIDTH:Number = 550;

		private var _panel:Panel;

		[Before]
		public function prepare():void
		{
			this._panel = new Panel();
			TestFeathers.starlingRoot.addChild(this._panel);
		}

		[After]
		public function cleanup():void
		{
			this._panel.removeFromParent(true);
			this._panel = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		private function addSimpleBackground():void
		{
			this._panel.backgroundSkin = new Quad(BACKGROUND_WIDTH, BACKGROUND_HEIGHT, 0xff00ff);
		}

		private function addComplexBackground():void
		{
			var backgroundSkin:LayoutGroup = new LayoutGroup();
			backgroundSkin.width = COMPLEX_BACKGROUND_WIDTH;
			backgroundSkin.height = COMPLEX_BACKGROUND_HEIGHT;
			backgroundSkin.minWidth = COMPLEX_BACKGROUND_MIN_WIDTH;
			backgroundSkin.minHeight = COMPLEX_BACKGROUND_MIN_HEIGHT;
			this._panel.backgroundSkin = backgroundSkin;
		}

		private function addHeader():void
		{
			this._panel.headerFactory = function():IFeathersControl
			{
				var header:LayoutGroup = new LayoutGroup();
				header.backgroundSkin = new Quad(HEADER_WIDTH, HEADER_HEIGHT, 0xff00ff);
				return header;
			};
		}

		private function addWideHeader():void
		{
			this._panel.headerFactory = function():IFeathersControl
			{
				var header:LayoutGroup = new LayoutGroup();
				header.backgroundSkin = new Quad(LARGE_HEADER_WIDTH, HEADER_HEIGHT, 0xff00ff);
				return header;
			};
		}

		private function addFooter():void
		{
			this._panel.footerFactory = function():IFeathersControl
			{
				var footer:LayoutGroup = new LayoutGroup();
				footer.backgroundSkin = new Quad(FOOTER_WIDTH, FOOTER_HEIGHT, 0x00ff00);
				return footer;
			};
		}

		[Test]
		public function testAutoSizeWithHeader():void
		{
			this.addHeader();
			this._panel.validate();
			Assert.assertStrictlyEquals("The width of the Panel was not calculated correctly with a header.",
				HEADER_WIDTH, this._panel.width);
			Assert.assertStrictlyEquals("The height of the Panel was not calculated correctly with a header.",
				HEADER_HEIGHT, this._panel.height);
			Assert.assertStrictlyEquals("The minWidth of the Panel was not calculated correctly with a header.",
				HEADER_WIDTH, this._panel.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Panel was not calculated correctly with a header.",
				HEADER_HEIGHT, this._panel.minHeight);
		}

		[Test]
		public function testAutoSizeWithHeaderAndPadding():void
		{
			this.addHeader();
			this._panel.paddingTop = PADDING_TOP;
			this._panel.paddingRight = PADDING_RIGHT;
			this._panel.paddingBottom = PADDING_BOTTOM;
			this._panel.paddingLeft = PADDING_LEFT;
			this._panel.validate();

			Assert.assertStrictlyEquals("The width of the Panel was not calculated correctly based on the header and left and right padding.",
				HEADER_WIDTH, this._panel.width);
			Assert.assertStrictlyEquals("The height of the Panel was not calculated correctly based on the header and top and bottom padding.",
				HEADER_HEIGHT + PADDING_TOP + PADDING_BOTTOM, this._panel.height);
			Assert.assertStrictlyEquals("The minWidth of the Panel was not calculated correctly based on the header and left and right padding.",
				HEADER_WIDTH, this._panel.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Panel was not calculated correctly based on the header and top and bottom padding.",
				HEADER_HEIGHT + PADDING_TOP + PADDING_BOTTOM, this._panel.minHeight);
		}

		[Test]
		public function testAutoSizeWithHeaderAndSimpleBackgroundSkin():void
		{
			this.addHeader();
			this.addSimpleBackground();
			this._panel.validate();

			Assert.assertStrictlyEquals("The width of the Panel was not calculated correctly based on the background width larger than the header width.",
				BACKGROUND_WIDTH, this._panel.width);
			Assert.assertStrictlyEquals("The height of the Panel was not calculated correctly based on the background height.",
				BACKGROUND_HEIGHT, this._panel.height);
			Assert.assertStrictlyEquals("The minWidth of the Panel was not calculated correctly based on the background width larger than the header width.",
				BACKGROUND_WIDTH, this._panel.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Panel was not calculated correctly based on the background height.",
				BACKGROUND_HEIGHT, this._panel.minHeight);
		}

		[Test]
		public function testAutoSizeWithHeaderAndComplexBackground():void
		{
			this.addHeader();
			this.addComplexBackground();
			this._panel.validate();

			Assert.assertStrictlyEquals("The width of the Panel was not calculated correctly based on the complex background width.",
				COMPLEX_BACKGROUND_WIDTH, this._panel.width);
			Assert.assertStrictlyEquals("The height of the Panel was not calculated correctly based on the complex background height.",
				COMPLEX_BACKGROUND_HEIGHT, this._panel.height);
			Assert.assertStrictlyEquals("The minWidth of the Panel was not calculated correctly based on the complex background minWidth.",
				COMPLEX_BACKGROUND_MIN_WIDTH, this._panel.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Panel was not calculated correctly based on the complex background minHeight.",
				COMPLEX_BACKGROUND_MIN_HEIGHT, this._panel.minHeight);
		}

		[Test]
		public function testAutoSizeWithHeaderAndFooter():void
		{
			this.addHeader();
			this.addFooter();
			this._panel.validate();
			Assert.assertStrictlyEquals("The width of the Panel was not calculated correctly with header and footer.",
				FOOTER_WIDTH, this._panel.width);
			Assert.assertStrictlyEquals("The height of the Panel was not calculated correctly with header and footer.",
				HEADER_HEIGHT + FOOTER_HEIGHT, this._panel.height);
			Assert.assertStrictlyEquals("The minWidth of the Panel was not calculated correctly with header and footer.",
				FOOTER_WIDTH, this._panel.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Panel was not calculated correctly with header and footer.",
				HEADER_HEIGHT + FOOTER_HEIGHT, this._panel.minHeight);
		}

		[Test]
		public function testAutoSizeWidthWithHeaderAndSmallerFooter():void
		{
			this.addWideHeader();
			this.addFooter();
			this._panel.validate();
			Assert.assertStrictlyEquals("The width of the Panel was not calculated correctly with header and footer.",
				LARGE_HEADER_WIDTH, this._panel.width);
			Assert.assertStrictlyEquals("The minWidth of the Panel was not calculated correctly with header and footer.",
				LARGE_HEADER_WIDTH, this._panel.minWidth);
		}

		[Test]
		public function testAutoSizeWithHeaderFooterAndPadding():void
		{
			this.addHeader();
			this.addFooter();
			this._panel.paddingTop = PADDING_TOP;
			this._panel.paddingRight = PADDING_RIGHT;
			this._panel.paddingBottom = PADDING_BOTTOM;
			this._panel.paddingLeft = PADDING_LEFT;
			this._panel.validate();

			Assert.assertStrictlyEquals("The width of the Panel was not calculated correctly based on the header, footer, and left and right padding.",
				FOOTER_WIDTH, this._panel.width);
			Assert.assertStrictlyEquals("The height of the Panel was not calculated correctly based on the header, footer, and top and bottom padding.",
				HEADER_HEIGHT + FOOTER_HEIGHT + PADDING_TOP + PADDING_BOTTOM, this._panel.height);
			Assert.assertStrictlyEquals("The minWidth of the Panel was not calculated correctly based on the header, footer, and left and right padding.",
				FOOTER_WIDTH, this._panel.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Panel was not calculated correctly based on the header, footer, and top and bottom padding.",
				HEADER_HEIGHT + FOOTER_HEIGHT + PADDING_TOP + PADDING_BOTTOM, this._panel.minHeight);
		}

		[Test]
		public function testAutoSizeWithHeaderFooterAndLargerSimpleBackgroundSkin():void
		{
			this.addHeader();
			this.addFooter();
			this.addSimpleBackground();
			this._panel.validate();

			Assert.assertStrictlyEquals("The width of the Panel was not calculated correctly based on the background width with a smaller header and footer.",
				BACKGROUND_WIDTH, this._panel.width);
			Assert.assertStrictlyEquals("The height of the Panel was not calculated correctly based on the background width with a smaller header and footer.",
				BACKGROUND_HEIGHT, this._panel.height);
			Assert.assertStrictlyEquals("The minWidth of the Panel was not calculated correctly based on the background height with a smaller header and footer.",
				BACKGROUND_WIDTH, this._panel.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Panel was not calculated correctly based on the background width with a smaller header and footer.",
				BACKGROUND_HEIGHT, this._panel.minHeight);
		}

		[Test]
		public function testAutoSizeWithHeaderFooterAndLargerComplexBackground():void
		{
			this.addHeader();
			this.addFooter();
			this.addComplexBackground();
			this._panel.validate();

			Assert.assertStrictlyEquals("The width of the Panel was not calculated correctly based on the complex background width with a smaller header and footer.",
				COMPLEX_BACKGROUND_WIDTH, this._panel.width);
			Assert.assertStrictlyEquals("The height of the Panel was not calculated correctly based on the complex background height with a smaller header and footer.",
				COMPLEX_BACKGROUND_HEIGHT, this._panel.height);
			Assert.assertStrictlyEquals("The minWidth of the Panel was not calculated correctly based on the complex background minWidth with a smaller header and footer.",
				COMPLEX_BACKGROUND_MIN_WIDTH, this._panel.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Panel was not calculated correctly based on the complex background minHeight with a smaller header and footer.",
				COMPLEX_BACKGROUND_MIN_HEIGHT, this._panel.minHeight);
		}

		[Test]
		public function testAutoSizeWithHeaderAndNarrowChild():void
		{
			this.addHeader();
			this._panel.addChild(new Quad(SMALL_ITEM_WIDTH, ITEM_HEIGHT, 0xff00ff));
			this._panel.validate();
			Assert.assertStrictlyEquals("The width of the Panel was not calculated correctly with a header.",
				HEADER_WIDTH, this._panel.width);
			Assert.assertStrictlyEquals("The height of the Panel was not calculated correctly with a header.",
				HEADER_HEIGHT + ITEM_HEIGHT, this._panel.height);
			Assert.assertStrictlyEquals("The minWidth of the Panel was not calculated correctly with a header.",
				HEADER_WIDTH, this._panel.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Panel was not calculated correctly with a header.",
				HEADER_HEIGHT + ITEM_HEIGHT, this._panel.minHeight);
		}

		[Test]
		public function testAutoSizeWithHeaderAndWideChild():void
		{
			this.addHeader();
			this._panel.addChild(new Quad(LARGE_ITEM_WIDTH, ITEM_HEIGHT, 0xff00ff));
			this._panel.validate();
			Assert.assertStrictlyEquals("The width of the Panel was not calculated correctly with a header.",
				LARGE_ITEM_WIDTH, this._panel.width);
			Assert.assertStrictlyEquals("The height of the Panel was not calculated correctly with a header.",
				HEADER_HEIGHT + ITEM_HEIGHT, this._panel.height);
			Assert.assertStrictlyEquals("The minWidth of the Panel was not calculated correctly with a header.",
				LARGE_ITEM_WIDTH, this._panel.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Panel was not calculated correctly with a header.",
				HEADER_HEIGHT + ITEM_HEIGHT, this._panel.minHeight);
		}

		[Test]
		public function testAutoSizeWithHeaderChildAndMeasureViewPortSetToFalse():void
		{
			this.addHeader();
			this._panel.addChild(new Quad(SMALL_ITEM_WIDTH, ITEM_HEIGHT, 0xff00ff));
			this._panel.measureViewPort = false;
			this._panel.validate();
			Assert.assertStrictlyEquals("The width of the Panel was not calculated correctly with a header.",
				HEADER_WIDTH, this._panel.width);
			Assert.assertStrictlyEquals("The height of the Panel was not calculated correctly with a header.",
				HEADER_HEIGHT, this._panel.height);
			Assert.assertStrictlyEquals("The minWidth of the Panel was not calculated correctly with a header.",
				HEADER_WIDTH, this._panel.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Panel was not calculated correctly with a header.",
				HEADER_HEIGHT, this._panel.minHeight);
		}
	}
}
