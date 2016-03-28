package feathers.tests
{
	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.data.ListCollection;
	import feathers.layout.Direction;

	import org.flexunit.Assert;

	import starling.display.Quad;

	public class ButtonGroupMeasurementTests
	{
		private static const PADDING_TOP:Number = 6;
		private static const PADDING_RIGHT:Number = 8;
		private static const PADDING_BOTTOM:Number = 2;
		private static const PADDING_LEFT:Number = 10;
		private static const GAP:Number = 5;
		private static const FIRST_GAP:Number = 7;
		private static const LAST_GAP:Number = 6;
		private static const BUTTON_WIDTH:Number = 200;
		private static const BUTTON_HEIGHT:Number = 100;
		
		private var _group:ButtonGroup;

		[Before]
		public function prepare():void
		{
			this._group = new ButtonGroup();
			this._group.buttonFactory = function():Button
			{
				var button:Button = new Button();
				button.hasLabelTextRenderer = false;
				button.defaultSkin = new Quad(BUTTON_WIDTH, BUTTON_HEIGHT, 0xff00ff);
				return button;
			};
			TestFeathers.starlingRoot.addChild(this._group);
		}

		[After]
		public function cleanup():void
		{
			this._group.removeFromParent(true);
			this._group = null;
			
			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testVerticalDimensionsWithNoItems():void
		{
			this._group.direction = Direction.VERTICAL;
			this._group.validate();
			Assert.assertStrictlyEquals("ButtonGroup width not equal to 0 with empty data provider.",
				0, this._group.width);
			Assert.assertStrictlyEquals("ButtonGroup height not equal to 0 with empty data provider.",
				0, this._group.height);
			Assert.assertStrictlyEquals("ButtonGroup minWidth not equal to 0 with empty data provider.",
				0, this._group.minWidth);
			Assert.assertStrictlyEquals("ButtonGroup minHeight not equal to 0 with empty data provider.",
				0, this._group.minHeight);
		}

		[Test]
		public function testVerticalDimensionsWithPaddingGapAndNoItems():void
		{
			this._group.direction = Direction.VERTICAL;
			this._group.paddingTop = PADDING_TOP;
			this._group.paddingRight = PADDING_RIGHT;
			this._group.paddingBottom = PADDING_BOTTOM;
			this._group.paddingLeft = PADDING_LEFT;
			this._group.gap = GAP;
			this._group.validate();
			Assert.assertStrictlyEquals("ButtonGroup width not equal to sum of left and right padding with empty data provider.", PADDING_LEFT + PADDING_RIGHT, this._group.width);
			Assert.assertStrictlyEquals("ButtonGroup height not equal to sum of top and bottom padding with empty data provider.", PADDING_TOP + PADDING_BOTTOM, this._group.height);
			Assert.assertStrictlyEquals("ButtonGroup minWidth not equal to sum of left and right padding with empty data provider.", PADDING_LEFT + PADDING_RIGHT, this._group.minWidth);
			Assert.assertStrictlyEquals("ButtonGroup minHeight not equal to sum of top and bottom padding with empty data provider.", PADDING_TOP + PADDING_BOTTOM, this._group.minHeight);
		}

		[Test]
		public function testVerticalDimensionsWithOneChild():void
		{
			this._group.direction = Direction.VERTICAL;
			this._group.dataProvider = new ListCollection(
			[
				{},
			]);
			this._group.validate();
			Assert.assertStrictlyEquals("ButtonGroup width not equal to one button width.", BUTTON_WIDTH, this._group.width);
			Assert.assertStrictlyEquals("ButtonGroup height not equal to one button height.", BUTTON_HEIGHT, this._group.height);
			Assert.assertStrictlyEquals("ButtonGroup minWidth not equal to one button width.", BUTTON_WIDTH, this._group.minWidth);
			Assert.assertStrictlyEquals("ButtonGroup minHeight not equal to one button height.", BUTTON_HEIGHT, this._group.minHeight);
		}

		[Test]
		public function testVerticalDimensionsWithPaddingGapAndOneChild():void
		{
			this._group.direction = Direction.VERTICAL;
			this._group.paddingTop = PADDING_TOP;
			this._group.paddingRight = PADDING_RIGHT;
			this._group.paddingBottom = PADDING_BOTTOM;
			this._group.paddingLeft = PADDING_LEFT;
			this._group.gap = GAP;
			this._group.dataProvider = new ListCollection(
			[
				{},
			]);
			this._group.validate();
			Assert.assertStrictlyEquals("ButtonGroup width not equal to sum of left and right padding and width of button.", BUTTON_WIDTH + PADDING_LEFT + PADDING_RIGHT, this._group.width);
			Assert.assertStrictlyEquals("ButtonGroup height not equal to sum of top and bottom padding and height of button.", BUTTON_HEIGHT + PADDING_TOP + PADDING_BOTTOM, this._group.height);
			Assert.assertStrictlyEquals("ButtonGroup minWidth not equal to sum of left and right padding and width of button.", BUTTON_WIDTH + PADDING_LEFT + PADDING_RIGHT, this._group.minWidth);
			Assert.assertStrictlyEquals("ButtonGroup minHeight not equal to sum of top and bottom padding and height of button.", BUTTON_HEIGHT + PADDING_TOP + PADDING_BOTTOM, this._group.minHeight);
		}

		[Test]
		public function testVerticalDimensionsWithTwoChildren():void
		{
			this._group.direction = Direction.VERTICAL;
			this._group.dataProvider = new ListCollection(
			[
				{},
				{},
			]);
			this._group.validate();
			Assert.assertStrictlyEquals("ButtonGroup width not equal to max width of buttons.", BUTTON_WIDTH, this._group.width);
			Assert.assertStrictlyEquals("ButtonGroup height not equal to sum of button heights.", BUTTON_HEIGHT * 2, this._group.height);
			Assert.assertStrictlyEquals("ButtonGroup minWidth not equal to max width of buttons.", BUTTON_WIDTH, this._group.minWidth);
			Assert.assertStrictlyEquals("ButtonGroup minHeight not equal to sum of button heights.", BUTTON_HEIGHT * 2, this._group.minHeight);
		}

		[Test]
		public function testVerticalDimensionsWithPaddingGapAndTwoChildren():void
		{
			this._group.direction = Direction.VERTICAL;
			this._group.paddingTop = PADDING_TOP;
			this._group.paddingRight = PADDING_RIGHT;
			this._group.paddingBottom = PADDING_BOTTOM;
			this._group.paddingLeft = PADDING_LEFT;
			this._group.gap = GAP;
			this._group.dataProvider = new ListCollection(
			[
				{},
				{},
			]);
			this._group.validate();
			Assert.assertStrictlyEquals("ButtonGroup width not equal to sum of left and right padding and max width of buttons.", BUTTON_WIDTH + PADDING_LEFT + PADDING_RIGHT, this._group.width);
			Assert.assertStrictlyEquals("ButtonGroup height not equal to sum of top and bottom padding, gap, and sum of button heights.", BUTTON_HEIGHT * 2 + GAP + PADDING_TOP + PADDING_BOTTOM, this._group.height);
			Assert.assertStrictlyEquals("ButtonGroup minWidth not equal to sum of left and right padding and max width of buttons.", BUTTON_WIDTH + PADDING_LEFT + PADDING_RIGHT, this._group.minWidth);
			Assert.assertStrictlyEquals("ButtonGroup minHeight not equal to sum of top and bottom padding, gap, and sum of button heights.", BUTTON_HEIGHT * 2 + GAP + PADDING_TOP + PADDING_BOTTOM, this._group.minHeight);
		}

		[Test]
		public function testVerticalHeightWithFirstGapAndTwoChildren():void
		{
			this._group.direction = Direction.VERTICAL;
			this._group.gap = GAP;
			this._group.firstGap = FIRST_GAP;
			this._group.dataProvider = new ListCollection(
			[
				{},
				{},
			]);
			this._group.validate();
			Assert.assertStrictlyEquals("ButtonGroup height not equal to first gap plus sum of button heights.", BUTTON_HEIGHT * 2 + FIRST_GAP, this._group.height);
			Assert.assertStrictlyEquals("ButtonGroup minHeight not equal to first gap plus sum of button heights.", BUTTON_HEIGHT * 2 + FIRST_GAP, this._group.minHeight);
		}

		[Test]
		public function testVerticalHeightWithLastGapAndTwoChildren():void
		{
			this._group.direction = Direction.VERTICAL;
			this._group.gap = GAP;
			this._group.lastGap = LAST_GAP;
			this._group.dataProvider = new ListCollection(
			[
				{},
				{},
			]);
			this._group.validate();
			Assert.assertStrictlyEquals("ButtonGroup height not equal to gap plus sum of button heights when using last gap with two buttons.", BUTTON_HEIGHT * 2 + GAP, this._group.height);
			Assert.assertStrictlyEquals("ButtonGroup minHeight not equal to gap plus sum of button heights when using last gap with two buttons.", BUTTON_HEIGHT * 2 + GAP, this._group.minHeight);
		}

		[Test]
		public function testVerticalHeightWithFirstGapAndThreeChildren():void
		{
			this._group.direction = Direction.VERTICAL;
			this._group.gap = GAP;
			this._group.firstGap = FIRST_GAP;
			this._group.dataProvider = new ListCollection(
			[
				{},
				{},
				{},
			]);
			this._group.validate();
			Assert.assertStrictlyEquals("ButtonGroup height not equal to sum of button heights, plus first gap, plus gap, with three buttons.", BUTTON_HEIGHT * 3 + GAP + FIRST_GAP, this._group.height);
			Assert.assertStrictlyEquals("ButtonGroup minHeight not equal to sum of button heights, plus first gap, plus gap, with three buttons.", BUTTON_HEIGHT * 3 + GAP + FIRST_GAP, this._group.minHeight);
		}

		[Test]
		public function testVerticalHeightWithLastGapAndThreeChildren():void
		{
			this._group.direction = Direction.VERTICAL;
			this._group.gap = GAP;
			this._group.lastGap = LAST_GAP;
			this._group.dataProvider = new ListCollection(
			[
				{},
				{},
				{},
			]);
			this._group.validate();
			Assert.assertStrictlyEquals("ButtonGroup height not equal to sum of button heights, plus gap, plus last gap, with three buttons.", BUTTON_HEIGHT * 3 + GAP + LAST_GAP, this._group.height);
			Assert.assertStrictlyEquals("ButtonGroup minHeight not equal to sum of button heights, plus gap, plus last gap, with three buttons.", BUTTON_HEIGHT * 3 + GAP + LAST_GAP, this._group.minHeight);
		}

		[Test]
		public function testVerticalHeightWithFirstAndLastGapAndFourChildren():void
		{
			this._group.direction = Direction.VERTICAL;
			this._group.gap = GAP;
			this._group.firstGap = FIRST_GAP;
			this._group.lastGap = LAST_GAP;
			this._group.dataProvider = new ListCollection(
			[
				{},
				{},
				{},
				{},
			]);
			this._group.validate();
			Assert.assertStrictlyEquals("ButtonGroup height not equal to sum of button heights, plus first gap, plus gap, plus last gap, with four buttons.", BUTTON_HEIGHT * 4 + FIRST_GAP + GAP + LAST_GAP, this._group.height);
			Assert.assertStrictlyEquals("ButtonGroup minHeight not equal to sum of button heights, plus first gap, plus gap, plus last gap, with four buttons.", BUTTON_HEIGHT * 4 + FIRST_GAP + GAP + LAST_GAP, this._group.minHeight);
		}

		[Test]
		public function testHorizontalDimensionsWithNoChildren():void
		{
			this._group.direction = Direction.HORIZONTAL;
			this._group.validate();
			Assert.assertStrictlyEquals("ButtonGroup width not equal to 0 with no buttons.", 0, this._group.width);
			Assert.assertStrictlyEquals("ButtonGroup height not equal to 0 with no buttons.", 0, this._group.height);
			Assert.assertStrictlyEquals("ButtonGroup minWidth not equal to 0 with no buttons.", 0, this._group.minWidth);
			Assert.assertStrictlyEquals("ButtonGroup minHeight not equal to 0 with no buttons.", 0, this._group.minHeight);
		}

		[Test]
		public function testHorizontalDimensionsWithPaddingGapAndNoChildren():void
		{
			this._group.direction = Direction.HORIZONTAL;
			this._group.paddingTop = PADDING_TOP;
			this._group.paddingRight = PADDING_RIGHT;
			this._group.paddingBottom = PADDING_BOTTOM;
			this._group.paddingLeft = PADDING_LEFT;
			this._group.gap = GAP;
			this._group.validate();
			Assert.assertStrictlyEquals("ButtonGroup width not equal to sum of left and right padding with no buttons.", PADDING_LEFT + PADDING_RIGHT, this._group.width);
			Assert.assertStrictlyEquals("ButtonGroup height not equal to sum of top and bottom padding with no buttons.", PADDING_TOP + PADDING_BOTTOM, this._group.height);
			Assert.assertStrictlyEquals("ButtonGroup minWidth not equal to sum of left and right padding with no buttons.", PADDING_LEFT + PADDING_RIGHT, this._group.minWidth);
			Assert.assertStrictlyEquals("ButtonGroup minHeight not equal to sum of top and bottom padding with no buttons.", PADDING_TOP + PADDING_BOTTOM, this._group.minHeight);
		}

		[Test]
		public function testHorizontalDimensionsWithOneChild():void
		{
			this._group.direction = Direction.HORIZONTAL;
			this._group.dataProvider = new ListCollection(
			[
				{},
			]);
			this._group.validate();
			Assert.assertStrictlyEquals("ButtonGroup width not equal to button width.", BUTTON_WIDTH, this._group.width);
			Assert.assertStrictlyEquals("ButtonGroup height not equal to button height.", BUTTON_HEIGHT, this._group.height);
			Assert.assertStrictlyEquals("ButtonGroup minWidth not equal to button width.", BUTTON_WIDTH, this._group.minWidth);
			Assert.assertStrictlyEquals("ButtonGroup minHeight not equal to button height.", BUTTON_HEIGHT, this._group.minHeight);
		}

		[Test]
		public function testHorizontalDimensionsWithPaddingGapAndOneChild():void
		{
			this._group.direction = Direction.HORIZONTAL;
			this._group.paddingTop = PADDING_TOP;
			this._group.paddingRight = PADDING_RIGHT;
			this._group.paddingBottom = PADDING_BOTTOM;
			this._group.paddingLeft = PADDING_LEFT;
			this._group.gap = GAP;
			this._group.dataProvider = new ListCollection(
			[
				{},
			]);
			this._group.validate();
			Assert.assertStrictlyEquals("ButtonGroup width not equal to sum of left and right padding and width of button.", BUTTON_WIDTH + PADDING_LEFT + PADDING_RIGHT, this._group.width);
			Assert.assertStrictlyEquals("ButtonGroup height not equal to sum of top and bottom padding and height of button.", BUTTON_HEIGHT + PADDING_TOP + PADDING_BOTTOM, this._group.height);
			Assert.assertStrictlyEquals("ButtonGroup minWidth not equal to sum of left and right padding and width of button.", BUTTON_WIDTH + PADDING_LEFT + PADDING_RIGHT, this._group.minWidth);
			Assert.assertStrictlyEquals("ButtonGroup minHeight not equal to sum of top and bottom padding and height of button.", BUTTON_HEIGHT + PADDING_TOP + PADDING_BOTTOM, this._group.minHeight);
		}

		[Test]
		public function testHorizontalDimensionsWithTwoChildren():void
		{
			this._group.direction = Direction.HORIZONTAL;
			this._group.dataProvider = new ListCollection(
			[
				{},
				{},
			]);
			this._group.validate();
			Assert.assertStrictlyEquals("ButtonGroup width not equal to sum of button widths.", BUTTON_WIDTH * 2, this._group.width);
			Assert.assertStrictlyEquals("ButtonGroup height not equal to max height of buttons.", BUTTON_HEIGHT, this._group.height);
			Assert.assertStrictlyEquals("ButtonGroup minWidth not equal to sum of button widths.", BUTTON_WIDTH * 2, this._group.minWidth);
			Assert.assertStrictlyEquals("ButtonGroup minHeight not equal to max height of buttons.", BUTTON_HEIGHT, this._group.minHeight);
		}

		[Test]
		public function testHorizontalDimensionsWithPaddingGapAndTwoChildren():void
		{
			this._group.direction = Direction.HORIZONTAL;
			this._group.paddingTop = PADDING_TOP;
			this._group.paddingRight = PADDING_RIGHT;
			this._group.paddingBottom = PADDING_BOTTOM;
			this._group.paddingLeft = PADDING_LEFT;
			this._group.gap = GAP;
			this._group.dataProvider = new ListCollection(
			[
				{},
				{},
			]);
			this._group.validate();
			Assert.assertStrictlyEquals("ButtonGroup width not equal to sum of left and right padding, gap, and sum of button widths.", BUTTON_WIDTH * 2 + GAP + PADDING_LEFT + PADDING_RIGHT, this._group.width);
			Assert.assertStrictlyEquals("ButtonGroup height not equal to sum of top and bottom padding and max height of buttons.", BUTTON_HEIGHT + PADDING_TOP + PADDING_BOTTOM, this._group.height);
			Assert.assertStrictlyEquals("ButtonGroup minWidth not equal to sum of left and right padding, gap, and sum of button widths.", BUTTON_WIDTH * 2 + GAP + PADDING_LEFT + PADDING_RIGHT, this._group.minWidth);
			Assert.assertStrictlyEquals("ButtonGroup minHeight not equal to sum of top and bottom padding and max height of buttons.", BUTTON_HEIGHT + PADDING_TOP + PADDING_BOTTOM, this._group.minHeight);
		}

		[Test]
		public function testHorizontalWidthWithGapAndTwoChildren():void
		{
			this._group.direction = Direction.HORIZONTAL;
			this._group.gap = GAP;
			this._group.dataProvider = new ListCollection(
			[
				{},
				{},
			]);
			this._group.validate();
			Assert.assertStrictlyEquals("ButtonGroup width not equal to gap plus sum of button widths.", BUTTON_WIDTH * 2 + GAP, this._group.width);
			Assert.assertStrictlyEquals("ButtonGroup minWidth not equal to gap plus sum of button widths.", BUTTON_WIDTH * 2 + GAP, this._group.minWidth);
		}

		[Test]
		public function testHorizontalWidthWithFirstGapAndTwoChildren():void
		{
			this._group.direction = Direction.HORIZONTAL;
			this._group.gap = GAP;
			this._group.firstGap = FIRST_GAP;
			this._group.dataProvider = new ListCollection(
			[
				{},
				{},
			]);
			this._group.validate();
			Assert.assertStrictlyEquals("ButtonGroup width not equal to gap plus sum of button widths.", BUTTON_WIDTH * 2 + FIRST_GAP, this._group.width);
			Assert.assertStrictlyEquals("ButtonGroup minWidth not equal to gap plus sum of button widths.", BUTTON_WIDTH * 2 + FIRST_GAP, this._group.minWidth);
		}

		[Test]
		public function testHorizontalWidthWithLastGapAndTwoChildren():void
		{
			this._group.direction = Direction.HORIZONTAL;
			this._group.gap = GAP;
			this._group.lastGap = LAST_GAP;
			this._group.dataProvider = new ListCollection(
			[
				{},
				{},
			]);
			this._group.validate();
			Assert.assertStrictlyEquals("ButtonGroup width not equal to gap plus sum of button widths when using last gap with two buttons.", BUTTON_WIDTH * 2 + GAP, this._group.width);
			Assert.assertStrictlyEquals("ButtonGroup minWidth not equal to gap plus sum of button widths when using last gap with two buttons.", BUTTON_WIDTH * 2 + GAP, this._group.minWidth);
		}

		[Test]
		public function testHorizontalWidthWithFirstGapAndThreeChildren():void
		{
			this._group.direction = Direction.HORIZONTAL;
			this._group.gap = GAP;
			this._group.firstGap = FIRST_GAP;
			this._group.dataProvider = new ListCollection(
			[
				{},
				{},
				{},
			]);
			this._group.validate();
			Assert.assertStrictlyEquals("ButtonGroup width not equal to sum of button widths, plus first gap, plus gap, with three buttons.", BUTTON_WIDTH * 3 + GAP + FIRST_GAP, this._group.width);
			Assert.assertStrictlyEquals("ButtonGroup minWidth not equal to sum of button widths, plus first gap, plus gap, with three buttons.", BUTTON_WIDTH * 3 + GAP + FIRST_GAP, this._group.minWidth);
		}

		[Test]
		public function testHorizontalWidthWithLastGapAndThreeChildren():void
		{
			this._group.direction = Direction.HORIZONTAL;
			this._group.gap = GAP;
			this._group.lastGap = LAST_GAP;
			this._group.dataProvider = new ListCollection(
			[
				{},
				{},
				{},
			]);
			this._group.validate();
			Assert.assertStrictlyEquals("ButtonGroup width not equal to sum of button widths, plus gap, plus last gap, with three buttons.", BUTTON_WIDTH * 3 + GAP + LAST_GAP, this._group.width);
			Assert.assertStrictlyEquals("ButtonGroup minWidth not equal to sum of button widths, plus gap, plus last gap, with three buttons.", BUTTON_WIDTH * 3 + GAP + LAST_GAP, this._group.minWidth);
		}

		[Test]
		public function testHorizontalWidthWithFirstAndLastGapAndFourChildren():void
		{
			this._group.direction = Direction.HORIZONTAL;
			this._group.gap = GAP;
			this._group.firstGap = FIRST_GAP;
			this._group.lastGap = LAST_GAP;
			this._group.dataProvider = new ListCollection(
			[
				{},
				{},
				{},
				{},
			]);
			this._group.validate();
			Assert.assertStrictlyEquals("ButtonGroup width not equal to sum of button widths, plus first gap, plus gap, plus last gap, with four buttons.", BUTTON_WIDTH * 4 + FIRST_GAP + GAP + LAST_GAP, this._group.width);
			Assert.assertStrictlyEquals("ButtonGroup minWidth not equal to sum of button widths, plus first gap, plus gap, plus last gap, with four buttons.", BUTTON_WIDTH * 4 + FIRST_GAP + GAP + LAST_GAP, this._group.minWidth);
		}
	}
}
