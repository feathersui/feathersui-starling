package feathers.tests
{
	import feathers.controls.LayoutGroup;
	import feathers.layout.FlowLayout;

	import org.flexunit.Assert;

	import starling.display.Quad;

	public class LayoutGroupFlowLayoutTests
	{
		private static const PADDING_TOP:Number = 6;
		private static const PADDING_RIGHT:Number = 8;
		private static const PADDING_BOTTOM:Number = 2;
		private static const PADDING_LEFT:Number = 10;
		private static const GAP:Number = 5;
		private static const CHILD1_WIDTH:Number = 200;
		private static const CHILD1_HEIGHT:Number = 100;
		private static const CHILD2_WIDTH:Number = 150;
		private static const CHILD2_HEIGHT:Number = 75;
		
		private var _group:LayoutGroup;
		private var _layout:FlowLayout;

		[Before]
		public function prepare():void
		{
			this._group = new LayoutGroup();
			this._layout = new FlowLayout();
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
			Assert.assertStrictlyEquals("FlowLayout width not equal to 0 with no children.", 0, this._group.width);
			Assert.assertStrictlyEquals("FlowLayout height not equal to 0 with no children.", 0, this._group.height);
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
			Assert.assertStrictlyEquals("FlowLayout width not equal to sum of left and right padding with no children.", PADDING_LEFT + PADDING_RIGHT, this._group.width);
			Assert.assertStrictlyEquals("FlowLayout height not equal to sum of top and bottom padding with no children.", PADDING_TOP + PADDING_BOTTOM, this._group.height);
		}

		[Test]
		public function testDimensionsWithOneChild():void
		{
			this._group.addChild(new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff));
			this._group.validate();
			Assert.assertStrictlyEquals("FlowLayout width not equal to child width.", CHILD1_WIDTH, this._group.width);
			Assert.assertStrictlyEquals("FlowLayout height not equal to child height.", CHILD1_HEIGHT, this._group.height);
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
			Assert.assertStrictlyEquals("FlowLayout width not equal to sum of left and right padding and width of child.", CHILD1_WIDTH + PADDING_LEFT + PADDING_RIGHT, this._group.width);
			Assert.assertStrictlyEquals("FlowLayout height not equal to sum of top and bottom padding and height of child.", CHILD1_HEIGHT + PADDING_TOP + PADDING_BOTTOM, this._group.height);
		}

		[Test]
		public function testDimensionsWithTwoChildren():void
		{
			this._group.addChild(new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff));
			this._group.addChild(new Quad(CHILD2_WIDTH, CHILD2_HEIGHT, 0xff00ff));
			this._group.validate();
			var maxChildHeight:Number = Math.max(CHILD1_HEIGHT, CHILD2_HEIGHT);
			Assert.assertStrictlyEquals("FlowLayout width not equal to sum of child widths.", CHILD1_WIDTH + CHILD2_WIDTH, this._group.width);
			Assert.assertStrictlyEquals("FlowLayout height not equal to max height of children.", maxChildHeight, this._group.height);
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
			var maxChildHeight:Number = Math.max(CHILD1_HEIGHT, CHILD2_HEIGHT);
			Assert.assertStrictlyEquals("FlowLayout width not equal to sum of left and right padding and sum of child widths.", CHILD1_WIDTH + CHILD2_WIDTH + GAP + PADDING_LEFT + PADDING_RIGHT, this._group.width);
			Assert.assertStrictlyEquals("FlowLayout height not equal to sum of top and bottom padding and max height of children.", maxChildHeight + PADDING_TOP + PADDING_BOTTOM, this._group.height);
		}

		[Test]
		public function testDimensionsWithMaxWidthLargerThanItems():void
		{
			this._group.maxWidth = CHILD1_WIDTH + (CHILD2_WIDTH / 2);
			this._group.addChild(new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff));
			this._group.addChild(new Quad(CHILD1_WIDTH, CHILD2_HEIGHT, 0xff00ff));
			this._group.validate();
			var maxChildWidth:Number = Math.max(CHILD1_WIDTH, CHILD1_WIDTH);
			Assert.assertStrictlyEquals("FlowLayout width not equal to max child width when flow to second row.", maxChildWidth, this._group.width);
			Assert.assertStrictlyEquals("FlowLayout height not equal to sum of child heights when flow to second row.", CHILD1_HEIGHT + CHILD2_HEIGHT, this._group.height);
		}

		[Test]
		public function testDimensionsWithMaxWidthSmallerThanItems():void
		{
			this._group.maxWidth = Math.min(CHILD1_WIDTH, CHILD2_WIDTH) / 2;
			this._group.addChild(new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff));
			this._group.addChild(new Quad(CHILD1_WIDTH, CHILD2_HEIGHT, 0xff00ff));
			this._group.validate();
			Assert.assertStrictlyEquals("FlowLayout width not equal to maxWidth with larger children.", this._group.maxWidth, this._group.width);
			Assert.assertStrictlyEquals("FlowLayout height not equal to sum of child heights when flow to second row.", CHILD1_HEIGHT + CHILD2_HEIGHT, this._group.height);
		}
	}
}
