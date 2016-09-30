package feathers.tests
{
	import feathers.layout.FlowLayout;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.LayoutBoundsResult;
	import feathers.layout.ViewPortBounds;

	import flash.geom.Point;

	import org.flexunit.Assert;

	import starling.display.DisplayObject;
	import starling.display.Quad;

	public class FlowLayoutTests
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
		
		private var _layout:FlowLayout;

		[Before]
		public function prepare():void
		{
			this._layout = new FlowLayout();
			this._layout.useVirtualLayout = false;
		}

		[After]
		public function cleanup():void
		{
			this._layout = null;
		}

		[Test]
		public function testLayoutResultWithNoItems():void
		{
			var items:Vector.<DisplayObject> = new <DisplayObject>[];
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("FlowLayout layout LayoutBoundsResult viewPortWidth not equal to 0 with no items.", 0, result.viewPortWidth);
			Assert.assertStrictlyEquals("FlowLayout layout LayoutBoundsResult viewPortHeight not equal to 0 with no items.", 0, result.viewPortHeight);
			Assert.assertStrictlyEquals("FlowLayout layout LayoutBoundsResult contentWidth not equal to 0 with no items.", 0, result.contentWidth);
			Assert.assertStrictlyEquals("FlowLayout layout LayoutBoundsResult contentHeight not equal to 0 with no items.", 0, result.contentHeight);
			Assert.assertStrictlyEquals("FlowLayout layout LayoutBoundsResult contentX not equal to 0 with no items.", 0, result.contentX);
			Assert.assertStrictlyEquals("FlowLayout layout LayoutBoundsResult contentY not equal to 0 with no items.", 0, result.contentY);
		}

		[Test]
		public function testMeasureViewPortResultWithNoItems():void
		{
			this._layout.useVirtualLayout = true;
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:Point = this._layout.measureViewPort(0, bounds);
			Assert.assertStrictlyEquals("FlowLayout measureViewPort width not equal to 0 with no items.", 0, result.x);
			Assert.assertStrictlyEquals("FlowLayout measureViewPort height not equal to 0 with no items.", 0, result.y);
		}

		[Test]
		public function testLayoutResultWithPaddingGapAndNoItems():void
		{
			this._layout.paddingTop = PADDING_TOP;
			this._layout.paddingRight = PADDING_RIGHT;
			this._layout.paddingBottom = PADDING_BOTTOM;
			this._layout.paddingLeft = PADDING_LEFT;
			this._layout.gap = GAP;
			var items:Vector.<DisplayObject> = new <DisplayObject>[];
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("FlowLayout layout LayoutBoundsResult viewPortWidth not equal to sum of left and right padding with no items.", PADDING_LEFT + PADDING_RIGHT, result.viewPortWidth);
			Assert.assertStrictlyEquals("FlowLayout layout LayoutBoundsResult viewPortHeight not equal to sum of top and bottom padding with no items.", PADDING_TOP + PADDING_BOTTOM, result.viewPortHeight);
			Assert.assertStrictlyEquals("FlowLayout layout LayoutBoundsResult contentWidth not equal to sum of left and right padding with no items.", PADDING_LEFT + PADDING_RIGHT, result.contentWidth);
			Assert.assertStrictlyEquals("FlowLayout layout LayoutBoundsResult contentHeight not equal to sum of top and bottom padding with no items.", PADDING_TOP + PADDING_BOTTOM, result.contentHeight);
			Assert.assertStrictlyEquals("FlowLayout layout LayoutBoundsResult contentX not equal to 0 with padding and no items.", 0, result.contentX);
			Assert.assertStrictlyEquals("FlowLayout layout LayoutBoundsResult contentY not equal to 0 with padding and no items.", 0, result.contentY);
		}

		[Test]
		public function testMeasureViewPortResultWithPaddingGapAndNoItems():void
		{
			this._layout.useVirtualLayout = true;
			this._layout.paddingTop = PADDING_TOP;
			this._layout.paddingRight = PADDING_RIGHT;
			this._layout.paddingBottom = PADDING_BOTTOM;
			this._layout.paddingLeft = PADDING_LEFT;
			this._layout.gap = GAP;
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:Point = this._layout.measureViewPort(0, bounds);
			Assert.assertStrictlyEquals("FlowLayout measureViewPort x not equal to sum of left and right padding with no items.", PADDING_LEFT + PADDING_RIGHT, result.x);
			Assert.assertStrictlyEquals("FlowLayout measureViewPort y not equal to sum of top and bottom padding with no items.", PADDING_TOP + PADDING_BOTTOM, result.y);
		}

		[Test]
		public function testLayoutResultWithOneChild():void
		{
			var item1:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("FlowLayout layout LayoutBoundsResult viewPortWidth not equal to child width with one item.", CHILD1_WIDTH, result.viewPortWidth);
			Assert.assertStrictlyEquals("FlowLayout layout LayoutBoundsResult viewPortHeight not equal to child height with one item.", CHILD1_HEIGHT, result.viewPortHeight);
			Assert.assertStrictlyEquals("FlowLayout layout LayoutBoundsResult contentWidth not equal to child width with one item.", CHILD1_WIDTH, result.contentWidth);
			Assert.assertStrictlyEquals("FlowLayout layout LayoutBoundsResult contentHeight not equal to child height with one item.", CHILD1_HEIGHT, result.contentHeight);
			Assert.assertStrictlyEquals("FlowLayout layout LayoutBoundsResult contentX not equal to 0 with one item.", 0, result.contentX);
			Assert.assertStrictlyEquals("FlowLayout layout LayoutBoundsResult contentY not equal to 0 with one item.", 0, result.contentY);
		}

		[Test]
		public function testMeasureViewPortResultWithOneChild():void
		{
			var item1:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			this._layout.useVirtualLayout = true;
			this._layout.typicalItem = item1;
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:Point = this._layout.measureViewPort(1, bounds);
			Assert.assertStrictlyEquals("FlowLayout measureViewPort x not equal to child width with one item.", CHILD1_WIDTH, result.x);
			Assert.assertStrictlyEquals("FlowLayout measureViewPort y not equal to child height with and one item.", CHILD1_HEIGHT, result.y);
		}

		[Test]
		public function testLayoutResultWithPaddingGapAndOneChild():void
		{
			this._layout.paddingTop = PADDING_TOP;
			this._layout.paddingRight = PADDING_RIGHT;
			this._layout.paddingBottom = PADDING_BOTTOM;
			this._layout.paddingLeft = PADDING_LEFT;
			this._layout.gap = GAP;
			var item1:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("FlowLayout layout LayoutBoundsResult viewPortWidth not equal to sum of left and right padding and width of child.", CHILD1_WIDTH + PADDING_LEFT + PADDING_RIGHT, result.viewPortWidth);
			Assert.assertStrictlyEquals("FlowLayout layout LayoutBoundsResult viewPortHeight not equal to sum of top and bottom padding and height of child.", CHILD1_HEIGHT + PADDING_TOP + PADDING_BOTTOM, result.viewPortHeight);
			Assert.assertStrictlyEquals("FlowLayout layout LayoutBoundsResult contentWidth not equal to sum of left and right padding and width of child.", CHILD1_WIDTH + PADDING_LEFT + PADDING_RIGHT, result.contentWidth);
			Assert.assertStrictlyEquals("FlowLayout layout LayoutBoundsResult contentHeight not equal to sum of top and bottom padding and height of child.", CHILD1_HEIGHT + PADDING_TOP + PADDING_BOTTOM, result.contentHeight);
			Assert.assertStrictlyEquals("FlowLayout layout LayoutBoundsResult contentX not equal to 0 with one item and padding.", 0, result.contentX);
			Assert.assertStrictlyEquals("FlowLayout layout LayoutBoundsResult contentY not equal to 0 with one item and padding.", 0, result.contentY);
		}

		[Test]
		public function testMeasureViewPortResultWithPaddingGapAndOneChild():void
		{
			var item1:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			this._layout.useVirtualLayout = true;
			this._layout.typicalItem = item1;
			this._layout.paddingTop = PADDING_TOP;
			this._layout.paddingRight = PADDING_RIGHT;
			this._layout.paddingBottom = PADDING_BOTTOM;
			this._layout.paddingLeft = PADDING_LEFT;
			this._layout.gap = GAP;
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:Point = this._layout.measureViewPort(1, bounds);
			Assert.assertStrictlyEquals("FlowLayout measureViewPort x not equal to sum of left and right padding and width of child.", CHILD1_WIDTH + PADDING_LEFT + PADDING_RIGHT, result.x);
			Assert.assertStrictlyEquals("FlowLayout measureViewPort y not equal to sum of top and bottom padding and height of child.", CHILD1_HEIGHT + PADDING_TOP + PADDING_BOTTOM, result.y);
		}

		[Test]
		public function testLayoutResultWithTwoChildren():void
		{
			var item1:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			var item2:Quad = new Quad(CHILD2_WIDTH, CHILD2_HEIGHT, 0xff00ff);
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1, item2];
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			var maxChildHeight:Number = Math.max(CHILD1_HEIGHT, CHILD2_HEIGHT);
			Assert.assertStrictlyEquals("FlowLayout layout LayoutBoundsResult viewPortWidth not equal to sum of item widths.", CHILD1_WIDTH + CHILD2_WIDTH, result.viewPortWidth);
			Assert.assertStrictlyEquals("FlowLayout layout LayoutBoundsResult viewPortHeight not equal to max height of items.", maxChildHeight, result.viewPortHeight);
			Assert.assertStrictlyEquals("FlowLayout layout LayoutBoundsResult contentWidth not equal to sum of item widths.", CHILD1_WIDTH + CHILD2_WIDTH, result.contentWidth);
			Assert.assertStrictlyEquals("FlowLayout layout LayoutBoundsResult contentHeight not equal to max height of items.", maxChildHeight, result.contentHeight);
			Assert.assertStrictlyEquals("FlowLayout layout LayoutBoundsResult contentX not equal to 0 with padding and two items.", 0, result.contentX);
			Assert.assertStrictlyEquals("FlowLayout layout LayoutBoundsResult contentY not equal to 0 with padding and two items.", 0, result.contentY);
		}

		[Test]
		public function testMeasureViewPortResultWithTwoChildren():void
		{
			var item1:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			this._layout.useVirtualLayout = true;
			this._layout.typicalItem = item1;
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:Point = this._layout.measureViewPort(2, bounds);
			Assert.assertStrictlyEquals("FlowLayout measureViewPort x not equal to typical item width multiplied by the number of items.", 2 * CHILD1_WIDTH, result.x);
			Assert.assertStrictlyEquals("FlowLayout measureViewPort y not equal to height of typical item.", CHILD1_HEIGHT, result.y);
		}

		[Test]
		public function testLayoutResultWithPaddingGapAndTwoChildren():void
		{
			this._layout.paddingTop = PADDING_TOP;
			this._layout.paddingRight = PADDING_RIGHT;
			this._layout.paddingBottom = PADDING_BOTTOM;
			this._layout.paddingLeft = PADDING_LEFT;
			this._layout.gap = GAP;
			var item1:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			var item2:Quad = new Quad(CHILD2_WIDTH, CHILD2_HEIGHT, 0xff00ff);
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1, item2];
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			var maxChildHeight:Number = Math.max(CHILD1_HEIGHT, CHILD2_HEIGHT);
			Assert.assertStrictlyEquals("FlowLayout layout LayoutBoundsResult viewPortWidth not equal to sum of item widths plus left and right padding and gap.", CHILD1_WIDTH + CHILD2_WIDTH + PADDING_LEFT + PADDING_RIGHT + GAP, result.viewPortWidth);
			Assert.assertStrictlyEquals("FlowLayout layout LayoutBoundsResult viewPortHeight not equal to max height of items plus top and bottom padding.", maxChildHeight + PADDING_TOP + PADDING_BOTTOM, result.viewPortHeight);
			Assert.assertStrictlyEquals("FlowLayout layout LayoutBoundsResult contentWidth not equal to sum of item widths plus left and right padding and gap.", CHILD1_WIDTH + CHILD2_WIDTH + PADDING_LEFT + PADDING_RIGHT + GAP, result.contentWidth);
			Assert.assertStrictlyEquals("FlowLayout layout LayoutBoundsResult contentHeight not equal to max height of items plus top and bottom padding.", maxChildHeight + PADDING_TOP + PADDING_BOTTOM, result.contentHeight);
			Assert.assertStrictlyEquals("FlowLayout layout LayoutBoundsResult contentX not equal to 0 with two items plus padding and gap.", 0, result.contentX);
			Assert.assertStrictlyEquals("FlowLayout layout LayoutBoundsResult contentY not equal to 0 with two items plus padding and gap.", 0, result.contentY);
		}

		[Test]
		public function testMeasureViewPortResultWithPaddingGapAndTwoChildren():void
		{
			var item1:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			this._layout.paddingTop = PADDING_TOP;
			this._layout.paddingRight = PADDING_RIGHT;
			this._layout.paddingBottom = PADDING_BOTTOM;
			this._layout.paddingLeft = PADDING_LEFT;
			this._layout.gap = GAP;
			this._layout.useVirtualLayout = true;
			this._layout.typicalItem = item1;
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:Point = this._layout.measureViewPort(2, bounds);
			Assert.assertStrictlyEquals("FlowLayout measureViewPort x not equal to typical item width multiplied by item count plus left and right padding and gap.", 2 * CHILD1_WIDTH + PADDING_LEFT + PADDING_RIGHT + GAP, result.x);
			Assert.assertStrictlyEquals("FlowLayout measureViewPort y not equal to max height of items plus top and bottom padding.", CHILD1_HEIGHT + PADDING_TOP + PADDING_BOTTOM, result.y);
		}

		[Test]
		public function testLayoutResultWithMaxWidthLargerThanItems():void
		{
			var item1:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			var item2:Quad = new Quad(CHILD2_WIDTH, CHILD2_HEIGHT, 0xff00ff);
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1, item2];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.maxWidth = CHILD1_WIDTH + (CHILD2_WIDTH / 2);
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			var maxChildWidth:Number = Math.max(CHILD1_WIDTH, CHILD2_WIDTH);
			Assert.assertStrictlyEquals("FlowLayout layout LayoutResult viewPortWidth not equal to max child width when flow to second row.", maxChildWidth, result.viewPortWidth);
			Assert.assertStrictlyEquals("FlowLayout layout LayoutResult viewPortHeight not equal to sum of child heights when flow to second row.", CHILD1_HEIGHT + CHILD2_HEIGHT, result.viewPortHeight);
			Assert.assertStrictlyEquals("FlowLayout layout LayoutResult contentWidth not equal to max child width when flow to second row.", maxChildWidth, result.contentWidth);
			Assert.assertStrictlyEquals("FlowLayout layout LayoutResult contentHeight not equal to sum of child heights when flow to second row.", CHILD1_HEIGHT + CHILD2_HEIGHT, result.contentHeight);
		}

		[Test]
		public function testMeasureViewPortResultWithMaxWidthLargerThanItems():void
		{
			var item1:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			this._layout.useVirtualLayout = true;
			this._layout.typicalItem = item1;
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.maxWidth = CHILD1_WIDTH + (CHILD2_WIDTH / 2);
			var result:Point = this._layout.measureViewPort(2, bounds);
			Assert.assertStrictlyEquals("FlowLayout measureViewPort x not equal to typical item width when flow to second row.", CHILD1_WIDTH, result.x);
			Assert.assertStrictlyEquals("FlowLayout measureViewPort y not equal to typical item height multiplied by item count when flow to second row.", 2 * CHILD1_HEIGHT, result.y);
		}

		[Test]
		public function testLayoutResultWithMaxWidthSmallerThanItems():void
		{
			var item1:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			var item2:Quad = new Quad(CHILD2_WIDTH, CHILD2_HEIGHT, 0xff00ff);
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1, item2];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.maxWidth = Math.min(CHILD1_WIDTH, CHILD2_WIDTH) / 2;
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			var maxChildWidth:Number = Math.max(CHILD1_WIDTH, CHILD2_WIDTH);
			Assert.assertStrictlyEquals("FlowLayout layout LayoutResult viewPortWidth not equal to maxWidth with larger children.", bounds.maxWidth, result.viewPortWidth);
			Assert.assertStrictlyEquals("FlowLayout layout LayoutResult viewPortHeight not equal to sum of child heights when flow to second row.", CHILD1_HEIGHT + CHILD2_HEIGHT, result.viewPortHeight);
			Assert.assertStrictlyEquals("FlowLayout layout LayoutResult contentWidth not equal to maximum child width with larger children.", maxChildWidth, result.contentWidth);
			Assert.assertStrictlyEquals("FlowLayout layout LayoutResult contentHeight not equal to sum of child heights when flow to second row.", CHILD1_HEIGHT + CHILD2_HEIGHT, result.contentHeight);
		}

		[Test]
		public function testMeasureViewPortResultWithMaxWidthSmallerThanItems():void
		{
			var item1:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			this._layout.useVirtualLayout = true;
			this._layout.typicalItem = item1;
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.maxWidth = Math.min(CHILD1_WIDTH, CHILD2_WIDTH) / 2;
			var result:Point = this._layout.measureViewPort(2, bounds);
			Assert.assertStrictlyEquals("FlowLayout measureViewPort x not equal to maxWidth with larger children.", bounds.maxWidth, result.x);
			Assert.assertStrictlyEquals("FlowLayout measureViewPort y not equal to typical item height multiplied by item count when flow to second row.", 2 * CHILD1_HEIGHT, result.y);
		}

		[Test]
		public function testRightAlignmentWithMaxWidthLargerThanItems():void
		{
			var item1:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			var item2:Quad = new Quad(CHILD2_WIDTH, CHILD2_HEIGHT, 0xff00ff);
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1, item2];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.maxWidth = CHILD1_WIDTH + (CHILD2_WIDTH / 2);
			this._layout.horizontalAlign = HorizontalAlign.RIGHT;
			this._layout.layout(items, bounds);
			var maxChildWidth:Number = Math.max(CHILD1_WIDTH, CHILD2_WIDTH);
			Assert.assertStrictlyEquals("FlowLayout with HorizontalAlign.RIGHT set first child.x incorrectly", maxChildWidth - CHILD1_WIDTH, item1.x);
			Assert.assertStrictlyEquals("FlowLayout with HorizontalAlign.RIGHT set second child.x incorrectly", maxChildWidth - CHILD2_WIDTH, item2.x);
		}

		[Test]
		public function testRightAlignmentWithMinAndMaxWidthLargerThanItems():void
		{
			var item1:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			var item2:Quad = new Quad(CHILD2_WIDTH, CHILD2_HEIGHT, 0xff00ff);
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1, item2];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.minWidth = CHILD1_WIDTH + (CHILD2_WIDTH / 4);
			bounds.maxWidth = CHILD1_WIDTH + (CHILD2_WIDTH / 2);
			this._layout.horizontalAlign = HorizontalAlign.RIGHT;
			this._layout.layout(items, bounds);
			var maxChildWidth:Number = Math.max(CHILD1_WIDTH, CHILD2_WIDTH);
			Assert.assertStrictlyEquals("FlowLayout with HorizontalAlign.RIGHT set first child.x incorrectly", bounds.minWidth - CHILD1_WIDTH, item1.x);
			Assert.assertStrictlyEquals("FlowLayout with HorizontalAlign.RIGHT set second child.x incorrectly", bounds.minWidth - CHILD2_WIDTH, item2.x);
		}

		[Test]
		public function testRightAlignmentWithExplicitWidthInBetweenItemWidths():void
		{
			var item1:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			var item2:Quad = new Quad(CHILD2_WIDTH, CHILD2_HEIGHT, 0xff00ff);
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1, item2];
			var bounds:ViewPortBounds = new ViewPortBounds();
			var explicitWidth:Number = (CHILD1_WIDTH + CHILD2_WIDTH) / 2;
			bounds.explicitWidth = explicitWidth;
			this._layout.horizontalAlign = HorizontalAlign.RIGHT;
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("FlowLayout with HorizontalAlign.RIGHT and larger child than explicitWidth calculated contentWidth incorrectly",
				CHILD1_WIDTH, result.contentWidth);
			Assert.assertStrictlyEquals("FlowLayout with HorizontalAlign.RIGHT and larger child than explicitWidth calculated viewPortWidth incorrectly",
				explicitWidth, result.viewPortWidth);
			Assert.assertStrictlyEquals("FlowLayout with HorizontalAlign.RIGHT and larger child than explicitWidth calculated larger child x incorrectly",
				0, item1.x);
			Assert.assertStrictlyEquals("FlowLayout with HorizontalAlign.RIGHT and larger child than explicitWidth calculated smaller child x incorrectly",
				CHILD1_WIDTH - item2.width, item2.x);
		}
	}
}
