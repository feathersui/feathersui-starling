package feathers.tests
{
	import feathers.controls.LayoutGroup;
	import feathers.layout.VerticalLayout;

	import org.flexunit.Assert;

	import starling.display.Quad;

	public class LayoutGroupVerticalLayoutTests
	{
		private static const PADDING_TOP:Number = 6;
		private static const PADDING_RIGHT:Number = 8;
		private static const PADDING_BOTTOM:Number = 2;
		private static const PADDING_LEFT:Number = 10;
		private static const GAP:Number = 5;
		private static const FIRST_GAP:Number = 7;
		private static const LAST_GAP:Number = 6;
		private static const CHILD1_WIDTH:Number = 200;
		private static const CHILD1_HEIGHT:Number = 100;
		private static const CHILD2_WIDTH:Number = 150;
		private static const CHILD2_HEIGHT:Number = 75;
		private static const CHILD3_WIDTH:Number = 75;
		private static const CHILD3_HEIGHT:Number = 50;
		private static const CHILD4_WIDTH:Number = 10;
		private static const CHILD4_HEIGHT:Number = 20;
		
		private var _group:LayoutGroup;
		private var _layout:VerticalLayout;

		[Before]
		public function prepare():void
		{
			this._group = new LayoutGroup();
			this._layout = new VerticalLayout();
			this._group.layout = this._layout;
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
		public function testDimensionsWithNoChildren():void
		{
			this._group.validate();
			Assert.assertStrictlyEquals("VerticalLayout width not equal to 0 with no children.", 0, this._group.width);
			Assert.assertStrictlyEquals("VerticalLayout height not equal to 0 with no children.", 0, this._group.height);
		}

		[Test]
		public function testDimensionsWithPaddingGapAndNoChildren():void
		{
			this._layout.paddingTop = PADDING_TOP;
			this._layout.paddingRight = PADDING_RIGHT;
			this._layout.paddingBottom = PADDING_BOTTOM;
			this._layout.paddingLeft = PADDING_LEFT;
			this._layout.gap = GAP;
			this._group.validate();
			Assert.assertStrictlyEquals("VerticalLayout width not equal to sum of left and right padding with no children.", PADDING_LEFT + PADDING_RIGHT, this._group.width);
			Assert.assertStrictlyEquals("VerticalLayout height not equal to sum of top and bottom padding with no children.", PADDING_TOP + PADDING_BOTTOM, this._group.height);
		}

		[Test]
		public function testDimensionsWithOneChild():void
		{
			this._group.addChild(new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff));
			this._group.validate();
			Assert.assertStrictlyEquals("VerticalLayout width not equal to child width.", CHILD1_WIDTH, this._group.width);
			Assert.assertStrictlyEquals("VerticalLayout height not equal to child height.", CHILD1_HEIGHT, this._group.height);
		}

		[Test]
		public function testDimensionsWithPaddingGapAndOneChild():void
		{
			this._layout.paddingTop = PADDING_TOP;
			this._layout.paddingRight = PADDING_RIGHT;
			this._layout.paddingBottom = PADDING_BOTTOM;
			this._layout.paddingLeft = PADDING_LEFT;
			this._layout.gap = GAP;
			this._group.addChild(new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff));
			this._group.validate();
			Assert.assertStrictlyEquals("VerticalLayout width not equal to sum of left and right padding and width of child.", CHILD1_WIDTH + PADDING_LEFT + PADDING_RIGHT, this._group.width);
			Assert.assertStrictlyEquals("VerticalLayout height not equal to sum of top and bottom padding and height of child.", CHILD1_HEIGHT + PADDING_TOP + PADDING_BOTTOM, this._group.height);
		}

		[Test]
		public function testDimensionsWithTwoChildren():void
		{
			this._group.addChild(new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff));
			this._group.addChild(new Quad(CHILD2_WIDTH, CHILD2_HEIGHT, 0xff00ff));
			this._group.validate();
			var maxChildWidth:Number = Math.max(CHILD1_WIDTH, CHILD2_WIDTH);
			Assert.assertStrictlyEquals("VerticalLayout width not equal to max width of children.", maxChildWidth, this._group.width);
			Assert.assertStrictlyEquals("VerticalLayout height not equal to sum of child heights.", CHILD1_HEIGHT + CHILD2_HEIGHT, this._group.height);
		}

		[Test]
		public function testDimensionsWithPaddingGapAndTwoChildren():void
		{
			this._layout.paddingTop = PADDING_TOP;
			this._layout.paddingRight = PADDING_RIGHT;
			this._layout.paddingBottom = PADDING_BOTTOM;
			this._layout.paddingLeft = PADDING_LEFT;
			this._layout.gap = GAP;
			this._group.addChild(new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff));
			this._group.addChild(new Quad(CHILD2_WIDTH, CHILD2_HEIGHT, 0xff00ff));
			this._group.validate();
			var maxChildWidth:Number = Math.max(CHILD1_WIDTH, CHILD2_WIDTH);
			Assert.assertStrictlyEquals("VerticalLayout width not equal to sum of left and right padding and max width of children.", maxChildWidth + PADDING_LEFT + PADDING_RIGHT, this._group.width);
			Assert.assertStrictlyEquals("VerticalLayout height not equal to sum of top and bottom padding, gap, and sum of child heights.", CHILD1_HEIGHT + CHILD2_HEIGHT + GAP + PADDING_TOP + PADDING_BOTTOM, this._group.height);
		}

		[Test]
		public function testHeightWithGapAndTwoChildren():void
		{
			this._layout.gap = GAP;
			this._group.addChild(new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff));
			this._group.addChild(new Quad(CHILD2_WIDTH, CHILD2_HEIGHT, 0xff00ff));
			this._group.validate();
			Assert.assertStrictlyEquals("VerticalLayout height not equal to gap plus sum of child heights.", CHILD1_HEIGHT + CHILD2_HEIGHT + GAP, this._group.height);
		}

		[Test]
		public function testHeightWithMaxHeightLargerThanChild():void
		{
			this._group.maxHeight = CHILD1_HEIGHT + 100;
			this._group.addChild(new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff));
			this._group.validate();
			Assert.assertStrictlyEquals("VerticalLayout height not equal to child height when maxHeight is larger than child width.", CHILD1_HEIGHT, this._group.height);
		}

		[Test]
		public function testHeightWithMaxHeightSmallerThanChild():void
		{
			this._group.maxHeight = CHILD1_HEIGHT / 2;
			this._group.addChild(new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff));
			this._group.validate();
			Assert.assertStrictlyEquals("VerticalLayout height not equal to maxHeight of child when maxHeight is smaller than child width.", this._group.maxHeight, this._group.height);
		}

		[Test]
		public function testHeightWithFirstGapAndTwoChildren():void
		{
			this._layout.gap = GAP;
			this._layout.firstGap = FIRST_GAP;
			this._group.addChild(new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff));
			this._group.addChild(new Quad(CHILD2_WIDTH, CHILD2_HEIGHT, 0xff00ff));
			this._group.validate();
			Assert.assertStrictlyEquals("VerticalLayout height not equal to first gap plus sum of child heights.", CHILD1_HEIGHT + CHILD2_HEIGHT + FIRST_GAP, this._group.height);
		}

		[Test]
		public function testHeightWithLastGapAndTwoChildren():void
		{
			this._layout.gap = GAP;
			this._layout.lastGap = LAST_GAP;
			this._group.addChild(new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff));
			this._group.addChild(new Quad(CHILD2_WIDTH, CHILD2_HEIGHT, 0xff00ff));
			this._group.validate();
			Assert.assertStrictlyEquals("VerticalLayout height not equal to gap plus sum of child heights when using last gap with two children.", CHILD1_HEIGHT + CHILD2_HEIGHT + GAP, this._group.height);
		}

		[Test]
		public function testHeightWithFirstGapAndThreeChildren():void
		{
			this._layout.gap = GAP;
			this._layout.firstGap = FIRST_GAP;
			this._group.addChild(new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff));
			this._group.addChild(new Quad(CHILD2_WIDTH, CHILD2_HEIGHT, 0xff00ff));
			this._group.addChild(new Quad(CHILD3_WIDTH, CHILD3_HEIGHT, 0xff00ff));
			this._group.validate();
			Assert.assertStrictlyEquals("VerticalLayout height not equal to sum of child heights, plus first gap, plus gap, with three children.", CHILD1_HEIGHT + CHILD2_HEIGHT + CHILD3_HEIGHT + GAP + FIRST_GAP, this._group.height);
		}

		[Test]
		public function testHeightWithLastGapAndThreeChildren():void
		{
			this._layout.gap = GAP;
			this._layout.lastGap = LAST_GAP;
			this._group.addChild(new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff));
			this._group.addChild(new Quad(CHILD2_WIDTH, CHILD2_HEIGHT, 0xff00ff));
			this._group.addChild(new Quad(CHILD3_WIDTH, CHILD3_HEIGHT, 0xff00ff));
			this._group.validate();
			Assert.assertStrictlyEquals("VerticalLayout height not equal to sum of child heights, plus gap, plus last gap, with three children.", CHILD1_HEIGHT + CHILD2_HEIGHT + CHILD3_HEIGHT + GAP + LAST_GAP, this._group.height);
		}

		[Test]
		public function testHeightWithFirstAndLastGapAndFourChildren():void
		{
			this._layout.gap = GAP;
			this._layout.firstGap = FIRST_GAP;
			this._layout.lastGap = LAST_GAP;
			this._group.addChild(new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff));
			this._group.addChild(new Quad(CHILD2_WIDTH, CHILD2_HEIGHT, 0xff00ff));
			this._group.addChild(new Quad(CHILD3_WIDTH, CHILD3_HEIGHT, 0xff00ff));
			this._group.addChild(new Quad(CHILD4_WIDTH, CHILD4_HEIGHT, 0xff00ff));
			this._group.validate();
			Assert.assertStrictlyEquals("VerticalLayout height not equal to sum of child heights, plus first gap, plus gap, plus last gap, with four children.", CHILD1_HEIGHT + CHILD2_HEIGHT + CHILD3_HEIGHT + CHILD4_HEIGHT + FIRST_GAP + GAP + LAST_GAP, this._group.height);
		}

		[Test]
		public function testChildXWithHorizontalAlignCenterAndMaxWidthSmallerThanChild():void
		{
			this._layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			var child:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			this._group.maxWidth = child.width / 2;
			this._group.addChild(child);
			this._group.validate();
			Assert.assertStrictlyEquals("Child x position incorrectly set to value less than zero with VerticalLayout.HORIZONTAL_ALIGN_CENTER", 0, child.x);
		}

		[Test]
		public function testChildYWithVerticalAlignMiddleAndMaxHeightSmallerThanChild():void
		{
			this._layout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
			var child:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			this._group.maxHeight = child.height / 2;
			this._group.addChild(child);
			this._group.validate();
			Assert.assertStrictlyEquals("Child y position incorrectly set to value less than zero with VerticalLayout.VERTICAL_ALIGN_MIDDLE", 0, child.y);
		}

		[Test]
		public function testChildXIsIntegerWithHorizontalAlignCenter():void
		{
			this._layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			var child:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			this._group.width = child.width + 111;
			this._group.addChild(child);
			this._group.validate();
			Assert.assertStrictlyEquals("Child x position incorrectly set to non-integer with VerticalLayout.HORIZONTAL_ALIGN_CENTER", Math.round(child.x), child.x);
		}

		[Test]
		public function testChildYIsIntegerWithVerticalAlignMiddle():void
		{
			this._layout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
			var child:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			this._group.height = child.height + 111;
			this._group.addChild(child);
			this._group.validate();
			Assert.assertStrictlyEquals("Child y position incorrectly set to non-integer with VerticalLayout.VERTICAL_ALIGN_MIDDLE", Math.round(child.y), child.y);
		}
	}
}
