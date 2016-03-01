package feathers.tests
{
	import feathers.controls.PageIndicator;

	import org.flexunit.Assert;

	import starling.display.Quad;

	public class PageIndicatorMeasurementTests
	{
		private static const SYMBOL_WIDTH:Number = 20;
		private static const SYMBOL_HEIGHT:Number = 16;
		private static const GAP:Number = 4;

		private static const PADDING_TOP:Number = 4;
		private static const PADDING_RIGHT:Number = 10;
		private static const PADDING_BOTTOM:Number = 3;
		private static const PADDING_LEFT:Number = 16;
		
		private var _pages:PageIndicator;

		[Before]
		public function prepare():void
		{
			this._pages = new PageIndicator();
			this._pages.normalSymbolFactory = function():Quad
			{
				return new Quad(SYMBOL_WIDTH, SYMBOL_HEIGHT, 0xff00ff);
			};
			this._pages.selectedSymbolFactory = function():Quad
			{
				return new Quad(SYMBOL_WIDTH, SYMBOL_HEIGHT, 0xff00ff);
			};
			TestFeathers.starlingRoot.addChild(this._pages);
		}

		[After]
		public function cleanup():void
		{
			this._pages.removeFromParent(true);
			this._pages = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testAutoSize():void
		{
			this._pages.pageCount = 5;
			this._pages.validate();

			Assert.assertStrictlyEquals("The width of the page indicator was not calculated correctly based on the width of the symbols.",
				SYMBOL_WIDTH * this._pages.pageCount, this._pages.width);
			Assert.assertStrictlyEquals("The height of the progress bar was not calculated correctly based on the height of the symbols.",
				SYMBOL_HEIGHT, this._pages.height);
			Assert.assertStrictlyEquals("The minWidth of the progress bar was not calculated correctly based on the width of the symbols.",
				SYMBOL_WIDTH * this._pages.pageCount, this._pages.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the progress bar was not calculated correctly based on the height of the symbols.",
				SYMBOL_HEIGHT, this._pages.minHeight);
		}

		[Test]
		public function testAutoSizeWithGap():void
		{
			this._pages.pageCount = 5;
			this._pages.gap = GAP;
			this._pages.validate();

			Assert.assertStrictlyEquals("The width of the page indicator was not calculated correctly based on the width of the symbols and the gap.",
				(SYMBOL_WIDTH + GAP) * this._pages.pageCount - GAP, this._pages.width);
			Assert.assertStrictlyEquals("The height of the progress bar was not calculated correctly based on the height of the symbols.",
				SYMBOL_HEIGHT, this._pages.height);
			Assert.assertStrictlyEquals("The minWidth of the progress bar was not calculated correctly based on the width of the symbols and the gap.",
				(SYMBOL_WIDTH + GAP) * this._pages.pageCount - GAP, this._pages.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the progress bar was not calculated correctly based on the height of the symbols.",
				SYMBOL_HEIGHT, this._pages.minHeight);
		}

		[Test]
		public function testAutoSizeWithPadding():void
		{
			this._pages.pageCount = 5;
			this._pages.paddingTop = PADDING_TOP;
			this._pages.paddingRight = PADDING_RIGHT;
			this._pages.paddingBottom = PADDING_BOTTOM;
			this._pages.paddingLeft = PADDING_LEFT;
			this._pages.validate();

			Assert.assertStrictlyEquals("The width of the page indicator was not calculated correctly based on the width of the symbols plus padding left and padding right.",
				SYMBOL_WIDTH * this._pages.pageCount + PADDING_LEFT + PADDING_RIGHT, this._pages.width);
			Assert.assertStrictlyEquals("The height of the progress bar was not calculated correctly based on the height of the symbols plus padding top and padding bottom.",
				SYMBOL_HEIGHT + PADDING_TOP + PADDING_BOTTOM, this._pages.height);
			Assert.assertStrictlyEquals("The minWidth of the progress bar was not calculated correctly based on the width of the symbols plus padding left and padding right.",
				SYMBOL_WIDTH * this._pages.pageCount + PADDING_LEFT + PADDING_RIGHT, this._pages.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the progress bar was not calculated correctly based on the height of the symbols plus padding top and padding bottom.",
				SYMBOL_HEIGHT + PADDING_TOP + PADDING_BOTTOM, this._pages.minHeight);
		}

		[Test]
		public function testAutoSizeWithGapAndPadding():void
		{
			this._pages.pageCount = 5;
			this._pages.gap = GAP;
			this._pages.paddingTop = PADDING_TOP;
			this._pages.paddingRight = PADDING_RIGHT;
			this._pages.paddingBottom = PADDING_BOTTOM;
			this._pages.paddingLeft = PADDING_LEFT;
			this._pages.validate();

			Assert.assertStrictlyEquals("The width of the page indicator was not calculated correctly based on the width of the symbols plus the gap plus padding left and padding right.",
				(SYMBOL_WIDTH + GAP) * this._pages.pageCount - GAP + PADDING_LEFT + PADDING_RIGHT, this._pages.width);
			Assert.assertStrictlyEquals("The height of the progress bar was not calculated correctly based on the height of the symbols plus padding top and padding bottom.",
				SYMBOL_HEIGHT + PADDING_TOP + PADDING_BOTTOM, this._pages.height);
			Assert.assertStrictlyEquals("The minWidth of the progress bar was not calculated correctly based on the width of the symbols plus the gap plus padding left and padding right.",
				(SYMBOL_WIDTH + GAP) * this._pages.pageCount - GAP + PADDING_LEFT + PADDING_RIGHT, this._pages.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the progress bar was not calculated correctly based on the height of the symbols plus padding top and padding bottom.",
				SYMBOL_HEIGHT + PADDING_TOP + PADDING_BOTTOM, this._pages.minHeight);
		}
	}
}
