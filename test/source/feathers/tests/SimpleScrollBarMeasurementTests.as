package feathers.tests
{
	import feathers.controls.BasicButton;
	import feathers.controls.SimpleScrollBar;
	import feathers.layout.Direction;

	import org.flexunit.Assert;

	import starling.display.Quad;

	public class SimpleScrollBarMeasurementTests
	{
		private static const HORIZONTAL_THUMB_WIDTH:Number = 25;
		private static const HORIZONTAL_THUMB_HEIGHT:Number = 20;
		private static const HORIZONTAL_THUMB_MIN_WIDTH:Number = 16;
		private static const HORIZONTAL_THUMB_MIN_HEIGHT:Number = 14;

		private static const VERTICAL_THUMB_WIDTH:Number = 15;
		private static const VERTICAL_THUMB_HEIGHT:Number = 18;
		private static const VERTICAL_THUMB_MIN_WIDTH:Number = 10;
		private static const VERTICAL_THUMB_MIN_HEIGHT:Number = 12;
		
		private static const MINIMUM:Number = 0;
		private static const MAXIMUM:Number = 100;
		private static const STEP:Number = 1;
		private static const PAGE:Number = 10;
		
		private var _scrollBar:SimpleScrollBar;

		[Before]
		public function prepare():void
		{
			this._scrollBar = new SimpleScrollBar();
			TestFeathers.starlingRoot.addChild(this._scrollBar);
		}

		[After]
		public function cleanup():void
		{
			this._scrollBar.removeFromParent(true);
			this._scrollBar = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testAutoSizeHorizontal():void
		{
			this._scrollBar.direction = Direction.HORIZONTAL;
			this._scrollBar.minimum = MINIMUM;
			this._scrollBar.maximum = MAXIMUM;
			this._scrollBar.step = STEP;
			this._scrollBar.page = PAGE;
			this._scrollBar.thumbFactory = function():BasicButton
			{
				var thumb:BasicButton = new BasicButton();
				thumb.defaultSkin = new Quad(HORIZONTAL_THUMB_WIDTH, HORIZONTAL_THUMB_HEIGHT, 0xff00ff);
				return thumb;
			};
			this._scrollBar.validate();

			Assert.assertStrictlyEquals("The width of the horizontal SimpleScrollBar was not calculated correctly.",
				HORIZONTAL_THUMB_WIDTH * (MAXIMUM - MINIMUM) / PAGE, this._scrollBar.width);
			Assert.assertStrictlyEquals("The minWidth of the horizontal SimpleScrollBar was not calculated correctly.",
				HORIZONTAL_THUMB_WIDTH * (MAXIMUM - MINIMUM) / PAGE, this._scrollBar.minWidth);
			Assert.assertStrictlyEquals("The height of the horizontal SimpleScrollBar was not calculated correctly.",
				HORIZONTAL_THUMB_HEIGHT, this._scrollBar.height);
			Assert.assertStrictlyEquals("The minHeight of the horizontal SimpleScrollBar was not calculated correctly.",
				HORIZONTAL_THUMB_HEIGHT, this._scrollBar.minHeight);
		}

		[Test]
		public function testAutoSizeVertical():void
		{
			this._scrollBar.direction = Direction.VERTICAL;
			this._scrollBar.minimum = MINIMUM;
			this._scrollBar.maximum = MAXIMUM;
			this._scrollBar.step = STEP;
			this._scrollBar.page = PAGE;
			this._scrollBar.thumbFactory = function():BasicButton
			{
				var thumb:BasicButton = new BasicButton();
				thumb.defaultSkin = new Quad(VERTICAL_THUMB_WIDTH, VERTICAL_THUMB_HEIGHT, 0xff00ff);
				return thumb;
			};
			this._scrollBar.validate();
			Assert.assertStrictlyEquals("The width of the vertical SimpleScrollBar was not calculated correctly.",
				VERTICAL_THUMB_WIDTH, this._scrollBar.width);
			Assert.assertStrictlyEquals("The minWidth of the vertical SimpleScrollBar was not calculated correctly.",
				VERTICAL_THUMB_WIDTH, this._scrollBar.minWidth);
			Assert.assertStrictlyEquals("The height of the horizontal SimpleScrollBar was not calculated correctly.",
				VERTICAL_THUMB_HEIGHT * (MAXIMUM - MINIMUM) / PAGE, this._scrollBar.height);
			Assert.assertStrictlyEquals("The minHeight of the horizontal SimpleScrollBar was not calculated correctly.",
				VERTICAL_THUMB_HEIGHT * (MAXIMUM - MINIMUM) / PAGE, this._scrollBar.minHeight);
		}

		[Test]
		public function testAutoSizeHorizontalWithMinDimensions():void
		{
			this._scrollBar.direction = Direction.HORIZONTAL;
			this._scrollBar.minimum = MINIMUM;
			this._scrollBar.maximum = MAXIMUM;
			this._scrollBar.step = STEP;
			this._scrollBar.page = PAGE;
			this._scrollBar.thumbFactory = function():BasicButton
			{
				var thumb:BasicButton = new BasicButton();
				thumb.defaultSkin = new Quad(HORIZONTAL_THUMB_WIDTH, HORIZONTAL_THUMB_HEIGHT, 0xff00ff);
				thumb.minWidth = HORIZONTAL_THUMB_MIN_WIDTH;
				thumb.minHeight = HORIZONTAL_THUMB_MIN_HEIGHT;
				return thumb;
			};
			this._scrollBar.validate();
			Assert.assertStrictlyEquals("The minWidth of the horizontal SimpleScrollBar was not calculated correctly when thumb has minWidth.",
				HORIZONTAL_THUMB_MIN_WIDTH * (MAXIMUM - MINIMUM) / PAGE, this._scrollBar.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the horizontal SimpleScrollBar was not calculated correctly when thumb has minHeight.",
				HORIZONTAL_THUMB_MIN_HEIGHT, this._scrollBar.minHeight);
		}

		[Test]
		public function testAutoSizeVerticalWithMinDimensions():void
		{
			this._scrollBar.direction = Direction.VERTICAL;
			this._scrollBar.minimum = MINIMUM;
			this._scrollBar.maximum = MAXIMUM;
			this._scrollBar.step = STEP;
			this._scrollBar.page = PAGE;
			this._scrollBar.thumbFactory = function():BasicButton
			{
				var thumb:BasicButton = new BasicButton();
				thumb.defaultSkin = new Quad(VERTICAL_THUMB_WIDTH, VERTICAL_THUMB_HEIGHT, 0xff00ff);
				thumb.minWidth = VERTICAL_THUMB_MIN_WIDTH;
				thumb.minHeight = VERTICAL_THUMB_MIN_HEIGHT;
				return thumb;
			};
			this._scrollBar.validate();
			Assert.assertStrictlyEquals("The minWidth of the vertical SimpleScrollBar was not calculated correctly when thumb has minWidth.",
				VERTICAL_THUMB_MIN_WIDTH, this._scrollBar.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the horizontal SimpleScrollBar was not calculated correctly when thumb has minHeight.",
				VERTICAL_THUMB_MIN_HEIGHT * (MAXIMUM - MINIMUM) / PAGE, this._scrollBar.minHeight);
		}
	}
}
