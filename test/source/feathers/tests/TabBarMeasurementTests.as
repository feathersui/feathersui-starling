package feathers.tests
{
	import feathers.controls.TabBar;
	import feathers.controls.ToggleButton;
	import feathers.data.ListCollection;
	import feathers.layout.Direction;

	import org.flexunit.Assert;

	import starling.display.Quad;

	public class TabBarMeasurementTests
	{
		private static const PADDING_TOP:Number = 6;
		private static const PADDING_RIGHT:Number = 8;
		private static const PADDING_BOTTOM:Number = 2;
		private static const PADDING_LEFT:Number = 10;
		private static const GAP:Number = 5;
		private static const FIRST_GAP:Number = 7;
		private static const LAST_GAP:Number = 6;
		private static const TAB_WIDTH:Number = 200;
		private static const TAB_HEIGHT:Number = 100;
		
		private var _tabs:TabBar;

		[Before]
		public function prepare():void
		{
			this._tabs = new TabBar();
			this._tabs.tabFactory = function():ToggleButton
			{
				var tab:ToggleButton = new ToggleButton();
				tab.hasLabelTextRenderer = false;
				tab.defaultSkin = new Quad(TAB_WIDTH, TAB_HEIGHT, 0xff00ff);
				return tab;
			};
			TestFeathers.starlingRoot.addChild(this._tabs);
		}

		[After]
		public function cleanup():void
		{
			this._tabs.removeFromParent(true);
			this._tabs = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testVerticalDimensionsWithNoItems():void
		{
			this._tabs.direction = Direction.VERTICAL;
			this._tabs.validate();
			Assert.assertStrictlyEquals("TabBar width not equal to 0 with empty data provider.",
				0, this._tabs.width);
			Assert.assertStrictlyEquals("TabBar height not equal to 0 with empty data provider.",
				0, this._tabs.height);
			Assert.assertStrictlyEquals("TabBar minWidth not equal to 0 with empty data provider.",
				0, this._tabs.minWidth);
			Assert.assertStrictlyEquals("TabBar minHeight not equal to 0 with empty data provider.",
				0, this._tabs.minHeight);
		}

		[Test]
		public function testVerticalDimensionsWithPaddingGapAndNoItems():void
		{
			this._tabs.direction = Direction.VERTICAL;
			this._tabs.paddingTop = PADDING_TOP;
			this._tabs.paddingRight = PADDING_RIGHT;
			this._tabs.paddingBottom = PADDING_BOTTOM;
			this._tabs.paddingLeft = PADDING_LEFT;
			this._tabs.gap = GAP;
			this._tabs.validate();
			Assert.assertStrictlyEquals("TabBar width not equal to sum of left and right padding with empty data provider.", PADDING_LEFT + PADDING_RIGHT, this._tabs.width);
			Assert.assertStrictlyEquals("TabBar height not equal to sum of top and bottom padding with empty data provider.", PADDING_TOP + PADDING_BOTTOM, this._tabs.height);
			Assert.assertStrictlyEquals("TabBar minWidth not equal to sum of left and right padding with empty data provider.", PADDING_LEFT + PADDING_RIGHT, this._tabs.minWidth);
			Assert.assertStrictlyEquals("TabBar minHeight not equal to sum of top and bottom padding with empty data provider.", PADDING_TOP + PADDING_BOTTOM, this._tabs.minHeight);
		}

		[Test]
		public function testVerticalDimensionsWithOneChild():void
		{
			this._tabs.direction = Direction.VERTICAL;
			this._tabs.dataProvider = new ListCollection(
			[
				{},
			]);
			this._tabs.validate();
			Assert.assertStrictlyEquals("TabBar width not equal to one button width.", TAB_WIDTH, this._tabs.width);
			Assert.assertStrictlyEquals("TabBar height not equal to one button height.", TAB_HEIGHT, this._tabs.height);
			Assert.assertStrictlyEquals("TabBar minWidth not equal to one button width.", TAB_WIDTH, this._tabs.minWidth);
			Assert.assertStrictlyEquals("TabBar minHeight not equal to one button height.", TAB_HEIGHT, this._tabs.minHeight);
		}

		[Test]
		public function testVerticalDimensionsWithPaddingGapAndOneChild():void
		{
			this._tabs.direction = Direction.VERTICAL;
			this._tabs.paddingTop = PADDING_TOP;
			this._tabs.paddingRight = PADDING_RIGHT;
			this._tabs.paddingBottom = PADDING_BOTTOM;
			this._tabs.paddingLeft = PADDING_LEFT;
			this._tabs.gap = GAP;
			this._tabs.dataProvider = new ListCollection(
			[
				{},
			]);
			this._tabs.validate();
			Assert.assertStrictlyEquals("TabBar width not equal to sum of left and right padding and width of tab.", TAB_WIDTH + PADDING_LEFT + PADDING_RIGHT, this._tabs.width);
			Assert.assertStrictlyEquals("TabBar height not equal to sum of top and bottom padding and height of tab.", TAB_HEIGHT + PADDING_TOP + PADDING_BOTTOM, this._tabs.height);
			Assert.assertStrictlyEquals("TabBar minWidth not equal to sum of left and right padding and width of tab.", TAB_WIDTH + PADDING_LEFT + PADDING_RIGHT, this._tabs.minWidth);
			Assert.assertStrictlyEquals("TabBar minHeight not equal to sum of top and bottom padding and height of tab.", TAB_HEIGHT + PADDING_TOP + PADDING_BOTTOM, this._tabs.minHeight);
		}

		[Test]
		public function testVerticalDimensionsWithTwoChildren():void
		{
			this._tabs.direction = Direction.VERTICAL;
			this._tabs.dataProvider = new ListCollection(
			[
				{},
				{},
			]);
			this._tabs.validate();
			Assert.assertStrictlyEquals("TabBar width not equal to max width of tabs.", TAB_WIDTH, this._tabs.width);
			Assert.assertStrictlyEquals("TabBar height not equal to sum of tab heights.", TAB_HEIGHT * 2, this._tabs.height);
			Assert.assertStrictlyEquals("TabBar minWidth not equal to max width of tabs.", TAB_WIDTH, this._tabs.minWidth);
			Assert.assertStrictlyEquals("TabBar minHeight not equal to sum of tab heights.", TAB_HEIGHT * 2, this._tabs.minHeight);
		}

		[Test]
		public function testVerticalDimensionsWithPaddingGapAndTwoChildren():void
		{
			this._tabs.direction = Direction.VERTICAL;
			this._tabs.paddingTop = PADDING_TOP;
			this._tabs.paddingRight = PADDING_RIGHT;
			this._tabs.paddingBottom = PADDING_BOTTOM;
			this._tabs.paddingLeft = PADDING_LEFT;
			this._tabs.gap = GAP;
			this._tabs.dataProvider = new ListCollection(
			[
				{},
				{},
			]);
			this._tabs.validate();
			Assert.assertStrictlyEquals("TabBar width not equal to sum of left and right padding and max width of tabs.", TAB_WIDTH + PADDING_LEFT + PADDING_RIGHT, this._tabs.width);
			Assert.assertStrictlyEquals("TabBar height not equal to sum of top and bottom padding, gap, and sum of tab heights.", TAB_HEIGHT * 2 + GAP + PADDING_TOP + PADDING_BOTTOM, this._tabs.height);
			Assert.assertStrictlyEquals("TabBar minWidth not equal to sum of left and right padding and max width of tabs.", TAB_WIDTH + PADDING_LEFT + PADDING_RIGHT, this._tabs.minWidth);
			Assert.assertStrictlyEquals("TabBar minHeight not equal to sum of top and bottom padding, gap, and sum of tab heights.", TAB_HEIGHT * 2 + GAP + PADDING_TOP + PADDING_BOTTOM, this._tabs.minHeight);
		}

		[Test]
		public function testVerticalHeightWithFirstGapAndTwoChildren():void
		{
			this._tabs.direction = Direction.VERTICAL;
			this._tabs.gap = GAP;
			this._tabs.firstGap = FIRST_GAP;
			this._tabs.dataProvider = new ListCollection(
			[
				{},
				{},
			]);
			this._tabs.validate();
			Assert.assertStrictlyEquals("TabBar height not equal to first gap plus sum of tab heights.", TAB_HEIGHT * 2 + FIRST_GAP, this._tabs.height);
			Assert.assertStrictlyEquals("TabBar minHeight not equal to first gap plus sum of tab heights.", TAB_HEIGHT * 2 + FIRST_GAP, this._tabs.minHeight);
		}

		[Test]
		public function testVerticalHeightWithLastGapAndTwoChildren():void
		{
			this._tabs.direction = Direction.VERTICAL;
			this._tabs.gap = GAP;
			this._tabs.lastGap = LAST_GAP;
			this._tabs.dataProvider = new ListCollection(
			[
				{},
				{},
			]);
			this._tabs.validate();
			Assert.assertStrictlyEquals("TabBar height not equal to gap plus sum of tab heights when using last gap with two tabs.", TAB_HEIGHT * 2 + GAP, this._tabs.height);
			Assert.assertStrictlyEquals("TabBar minHeight not equal to gap plus sum of tab heights when using last gap with two tabs.", TAB_HEIGHT * 2 + GAP, this._tabs.minHeight);
		}

		[Test]
		public function testVerticalHeightWithFirstGapAndThreeChildren():void
		{
			this._tabs.direction = Direction.VERTICAL;
			this._tabs.gap = GAP;
			this._tabs.firstGap = FIRST_GAP;
			this._tabs.dataProvider = new ListCollection(
			[
				{},
				{},
				{},
			]);
			this._tabs.validate();
			Assert.assertStrictlyEquals("TabBar height not equal to sum of tab heights, plus first gap, plus gap, with three tabs.", TAB_HEIGHT * 3 + GAP + FIRST_GAP, this._tabs.height);
			Assert.assertStrictlyEquals("TabBar minHeight not equal to sum of tab heights, plus first gap, plus gap, with three tabs.", TAB_HEIGHT * 3 + GAP + FIRST_GAP, this._tabs.minHeight);
		}

		[Test]
		public function testVerticalHeightWithLastGapAndThreeChildren():void
		{
			this._tabs.direction = Direction.VERTICAL;
			this._tabs.gap = GAP;
			this._tabs.lastGap = LAST_GAP;
			this._tabs.dataProvider = new ListCollection(
			[
				{},
				{},
				{},
			]);
			this._tabs.validate();
			Assert.assertStrictlyEquals("TabBar height not equal to sum of tab heights, plus gap, plus last gap, with three tabs.", TAB_HEIGHT * 3 + GAP + LAST_GAP, this._tabs.height);
			Assert.assertStrictlyEquals("TabBar minHeight not equal to sum of tab heights, plus gap, plus last gap, with three tabs.", TAB_HEIGHT * 3 + GAP + LAST_GAP, this._tabs.minHeight);
		}

		[Test]
		public function testVerticalHeightWithFirstAndLastGapAndFourChildren():void
		{
			this._tabs.direction = Direction.VERTICAL;
			this._tabs.gap = GAP;
			this._tabs.firstGap = FIRST_GAP;
			this._tabs.lastGap = LAST_GAP;
			this._tabs.dataProvider = new ListCollection(
			[
				{},
				{},
				{},
				{},
			]);
			this._tabs.validate();
			Assert.assertStrictlyEquals("TabBar height not equal to sum of tab heights, plus first gap, plus gap, plus last gap, with four tabs.", TAB_HEIGHT * 4 + FIRST_GAP + GAP + LAST_GAP, this._tabs.height);
			Assert.assertStrictlyEquals("TabBar minHeight not equal to sum of tab heights, plus first gap, plus gap, plus last gap, with four tabs.", TAB_HEIGHT * 4 + FIRST_GAP + GAP + LAST_GAP, this._tabs.minHeight);
		}

		[Test]
		public function testHorizontalDimensionsWithNoChildren():void
		{
			this._tabs.direction = Direction.HORIZONTAL;
			this._tabs.validate();
			Assert.assertStrictlyEquals("TabBar width not equal to 0 with no tabs.", 0, this._tabs.width);
			Assert.assertStrictlyEquals("TabBar height not equal to 0 with no tabs.", 0, this._tabs.height);
			Assert.assertStrictlyEquals("TabBar minWidth not equal to 0 with no tabs.", 0, this._tabs.minWidth);
			Assert.assertStrictlyEquals("TabBar minHeight not equal to 0 with no tabs.", 0, this._tabs.minHeight);
		}

		[Test]
		public function testHorizontalDimensionsWithPaddingGapAndNoChildren():void
		{
			this._tabs.direction = Direction.HORIZONTAL;
			this._tabs.paddingTop = PADDING_TOP;
			this._tabs.paddingRight = PADDING_RIGHT;
			this._tabs.paddingBottom = PADDING_BOTTOM;
			this._tabs.paddingLeft = PADDING_LEFT;
			this._tabs.gap = GAP;
			this._tabs.validate();
			Assert.assertStrictlyEquals("TabBar width not equal to sum of left and right padding with no tabs.", PADDING_LEFT + PADDING_RIGHT, this._tabs.width);
			Assert.assertStrictlyEquals("TabBar height not equal to sum of top and bottom padding with no tabs.", PADDING_TOP + PADDING_BOTTOM, this._tabs.height);
			Assert.assertStrictlyEquals("TabBar minWidth not equal to sum of left and right padding with no tabs.", PADDING_LEFT + PADDING_RIGHT, this._tabs.minWidth);
			Assert.assertStrictlyEquals("TabBar minHeight not equal to sum of top and bottom padding with no tabs.", PADDING_TOP + PADDING_BOTTOM, this._tabs.minHeight);
		}

		[Test]
		public function testHorizontalDimensionsWithOneChild():void
		{
			this._tabs.direction = Direction.HORIZONTAL;
			this._tabs.dataProvider = new ListCollection(
			[
				{},
			]);
			this._tabs.validate();
			Assert.assertStrictlyEquals("TabBar width not equal to tab width.", TAB_WIDTH, this._tabs.width);
			Assert.assertStrictlyEquals("TabBar height not equal to tab height.", TAB_HEIGHT, this._tabs.height);
			Assert.assertStrictlyEquals("TabBar minWidth not equal to tab width.", TAB_WIDTH, this._tabs.minWidth);
			Assert.assertStrictlyEquals("TabBar minHeight not equal to tab height.", TAB_HEIGHT, this._tabs.minHeight);
		}

		[Test]
		public function testHorizontalDimensionsWithPaddingGapAndOneChild():void
		{
			this._tabs.direction = Direction.HORIZONTAL;
			this._tabs.paddingTop = PADDING_TOP;
			this._tabs.paddingRight = PADDING_RIGHT;
			this._tabs.paddingBottom = PADDING_BOTTOM;
			this._tabs.paddingLeft = PADDING_LEFT;
			this._tabs.gap = GAP;
			this._tabs.dataProvider = new ListCollection(
			[
				{},
			]);
			this._tabs.validate();
			Assert.assertStrictlyEquals("TabBar width not equal to sum of left and right padding and width of tab.", TAB_WIDTH + PADDING_LEFT + PADDING_RIGHT, this._tabs.width);
			Assert.assertStrictlyEquals("TabBar height not equal to sum of top and bottom padding and height of tab.", TAB_HEIGHT + PADDING_TOP + PADDING_BOTTOM, this._tabs.height);
			Assert.assertStrictlyEquals("TabBar minWidth not equal to sum of left and right padding and width of tab.", TAB_WIDTH + PADDING_LEFT + PADDING_RIGHT, this._tabs.minWidth);
			Assert.assertStrictlyEquals("TabBar minHeight not equal to sum of top and bottom padding and height of tab.", TAB_HEIGHT + PADDING_TOP + PADDING_BOTTOM, this._tabs.minHeight);
		}

		[Test]
		public function testHorizontalDimensionsWithTwoChildren():void
		{
			this._tabs.direction = Direction.HORIZONTAL;
			this._tabs.dataProvider = new ListCollection(
			[
				{},
				{},
			]);
			this._tabs.validate();
			Assert.assertStrictlyEquals("TabBar width not equal to sum of tab widths.", TAB_WIDTH * 2, this._tabs.width);
			Assert.assertStrictlyEquals("TabBar height not equal to max height of tabs.", TAB_HEIGHT, this._tabs.height);
			Assert.assertStrictlyEquals("TabBar minWidth not equal to sum of tab widths.", TAB_WIDTH * 2, this._tabs.minWidth);
			Assert.assertStrictlyEquals("TabBar minHeight not equal to max height of tabs.", TAB_HEIGHT, this._tabs.minHeight);
		}

		[Test]
		public function testHorizontalDimensionsWithPaddingGapAndTwoChildren():void
		{
			this._tabs.direction = Direction.HORIZONTAL;
			this._tabs.paddingTop = PADDING_TOP;
			this._tabs.paddingRight = PADDING_RIGHT;
			this._tabs.paddingBottom = PADDING_BOTTOM;
			this._tabs.paddingLeft = PADDING_LEFT;
			this._tabs.gap = GAP;
			this._tabs.dataProvider = new ListCollection(
			[
				{},
				{},
			]);
			this._tabs.validate();
			Assert.assertStrictlyEquals("TabBar width not equal to sum of left and right padding, gap, and sum of tab widths.", TAB_WIDTH * 2 + GAP + PADDING_LEFT + PADDING_RIGHT, this._tabs.width);
			Assert.assertStrictlyEquals("TabBar height not equal to sum of top and bottom padding and max height of tabs.", TAB_HEIGHT + PADDING_TOP + PADDING_BOTTOM, this._tabs.height);
			Assert.assertStrictlyEquals("TabBar minWidth not equal to sum of left and right padding, gap, and sum of tab widths.", TAB_WIDTH * 2 + GAP + PADDING_LEFT + PADDING_RIGHT, this._tabs.minWidth);
			Assert.assertStrictlyEquals("TabBar minHeight not equal to sum of top and bottom padding and max height of tabs.", TAB_HEIGHT + PADDING_TOP + PADDING_BOTTOM, this._tabs.minHeight);
		}

		[Test]
		public function testHorizontalWidthWithGapAndTwoChildren():void
		{
			this._tabs.direction = Direction.HORIZONTAL;
			this._tabs.gap = GAP;
			this._tabs.dataProvider = new ListCollection(
			[
				{},
				{},
			]);
			this._tabs.validate();
			Assert.assertStrictlyEquals("TabBar width not equal to gap plus sum of tab widths.", TAB_WIDTH * 2 + GAP, this._tabs.width);
			Assert.assertStrictlyEquals("TabBar minWidth not equal to gap plus sum of tab widths.", TAB_WIDTH * 2 + GAP, this._tabs.minWidth);
		}

		[Test]
		public function testHorizontalWidthWithFirstGapAndTwoChildren():void
		{
			this._tabs.direction = Direction.HORIZONTAL;
			this._tabs.gap = GAP;
			this._tabs.firstGap = FIRST_GAP;
			this._tabs.dataProvider = new ListCollection(
			[
				{},
				{},
			]);
			this._tabs.validate();
			Assert.assertStrictlyEquals("TabBar width not equal to gap plus sum of tab widths.", TAB_WIDTH * 2 + FIRST_GAP, this._tabs.width);
			Assert.assertStrictlyEquals("TabBar minWidth not equal to gap plus sum of tab widths.", TAB_WIDTH * 2 + FIRST_GAP, this._tabs.minWidth);
		}

		[Test]
		public function testHorizontalWidthWithLastGapAndTwoChildren():void
		{
			this._tabs.direction = Direction.HORIZONTAL;
			this._tabs.gap = GAP;
			this._tabs.lastGap = LAST_GAP;
			this._tabs.dataProvider = new ListCollection(
			[
				{},
				{},
			]);
			this._tabs.validate();
			Assert.assertStrictlyEquals("TabBar width not equal to gap plus sum of tab widths when using last gap with two tabs.", TAB_WIDTH * 2 + GAP, this._tabs.width);
			Assert.assertStrictlyEquals("TabBar minWidth not equal to gap plus sum of tab widths when using last gap with two tabs.", TAB_WIDTH * 2 + GAP, this._tabs.minWidth);
		}

		[Test]
		public function testHorizontalWidthWithFirstGapAndThreeChildren():void
		{
			this._tabs.direction = Direction.HORIZONTAL;
			this._tabs.gap = GAP;
			this._tabs.firstGap = FIRST_GAP;
			this._tabs.dataProvider = new ListCollection(
			[
				{},
				{},
				{},
			]);
			this._tabs.validate();
			Assert.assertStrictlyEquals("TabBar width not equal to sum of tab widths, plus first gap, plus gap, with three tabs.", TAB_WIDTH * 3 + GAP + FIRST_GAP, this._tabs.width);
			Assert.assertStrictlyEquals("TabBar minWidth not equal to sum of tab widths, plus first gap, plus gap, with three tabs.", TAB_WIDTH * 3 + GAP + FIRST_GAP, this._tabs.minWidth);
		}

		[Test]
		public function testHorizontalWidthWithLastGapAndThreeChildren():void
		{
			this._tabs.direction = Direction.HORIZONTAL;
			this._tabs.gap = GAP;
			this._tabs.lastGap = LAST_GAP;
			this._tabs.dataProvider = new ListCollection(
			[
				{},
				{},
				{},
			]);
			this._tabs.validate();
			Assert.assertStrictlyEquals("TabBar width not equal to sum of tab widths, plus gap, plus last gap, with three tabs.", TAB_WIDTH * 3 + GAP + LAST_GAP, this._tabs.width);
			Assert.assertStrictlyEquals("TabBar minWidth not equal to sum of tab widths, plus gap, plus last gap, with three tabs.", TAB_WIDTH * 3 + GAP + LAST_GAP, this._tabs.minWidth);
		}

		[Test]
		public function testHorizontalWidthWithFirstAndLastGapAndFourChildren():void
		{
			this._tabs.direction = Direction.HORIZONTAL;
			this._tabs.gap = GAP;
			this._tabs.firstGap = FIRST_GAP;
			this._tabs.lastGap = LAST_GAP;
			this._tabs.dataProvider = new ListCollection(
			[
				{},
				{},
				{},
				{},
			]);
			this._tabs.validate();
			Assert.assertStrictlyEquals("TabBar width not equal to sum of tab widths, plus first gap, plus gap, plus last gap, with four tabs.", TAB_WIDTH * 4 + FIRST_GAP + GAP + LAST_GAP, this._tabs.width);
			Assert.assertStrictlyEquals("TabBar minWidth not equal to sum of tab widths, plus first gap, plus gap, plus last gap, with four tabs.", TAB_WIDTH * 4 + FIRST_GAP + GAP + LAST_GAP, this._tabs.minWidth);
		}
	}
}
