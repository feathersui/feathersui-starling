package feathers.tests
{
	import feathers.controls.Label;
	import feathers.controls.LayoutGroup;
	import feathers.layout.LayoutBoundsResult;
	import feathers.layout.SlideShowLayout;
	import feathers.layout.ViewPortBounds;

	import org.flexunit.Assert;

	import starling.display.DisplayObject;
	import starling.display.Quad;
	import flash.geom.Point;
	import feathers.layout.Direction;

	public class SlideShowLayoutTests
	{
		private static const PADDING_TOP:Number = 6;
		private static const PADDING_RIGHT:Number = 8;
		private static const PADDING_BOTTOM:Number = 2;
		private static const PADDING_LEFT:Number = 10;
		private static const CHILD1_WIDTH:Number = 200;
		private static const CHILD1_HEIGHT:Number = 100;
		private static const CHILD2_WIDTH:Number = 150;
		private static const CHILD2_HEIGHT:Number = 75;
		private static const CHILD3_WIDTH:Number = 75;
		private static const CHILD3_HEIGHT:Number = 50;
		private static const CHILD4_WIDTH:Number = 10;
		private static const CHILD4_HEIGHT:Number = 20;

		private var _layout:SlideShowLayout;
		private var _child1:DisplayObject;
		private var _child2:DisplayObject;

		[Before]
		public function prepare():void
		{
			this._layout = new SlideShowLayout();
		}

		[After]
		public function cleanup():void
		{
			this._layout = null;
			if(this._child1 !== null)
			{
				this._child1.dispose();
				this._child1 = null;
			}
			if(this._child2 !== null)
			{
				this._child2.dispose();
				this._child2 = null;
			}
		}

		[Test]
		public function testLayoutResultWithNoItems():void
		{
			this._layout.useVirtualLayout = false;
			var result:LayoutBoundsResult = this._layout.layout(new <DisplayObject>[]);
			Assert.assertStrictlyEquals("SlideShowLayout: viewPortWidth not equal to 0 with no children.",
				0, result.viewPortWidth);
			Assert.assertStrictlyEquals("SlideShowLayout: viewPortHeight not equal to 0 with no children.",
				0, result.viewPortHeight);
			Assert.assertStrictlyEquals("SlideShowLayout: contentWidth not equal to 0 with no children.",
				0, result.contentWidth);
			Assert.assertStrictlyEquals("SlideShowLayout: contentHeight not equal to 0 with no children.",
				0, result.contentHeight);
		}

		[Test]
		public function testMeasureViewPortResultWithNoItems():void
		{
			this._layout.useVirtualLayout = true;
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:Point = this._layout.measureViewPort(0, bounds);
			Assert.assertStrictlyEquals("SlideShowLayout: measureViewPort x not equal to 0 with no children.",
				0, result.x);
			Assert.assertStrictlyEquals("SlideShowLayout: measureViewPort y not equal to 0 with no children.",
				0, result.y);
		}

		[Test]
		public function testLayoutResultWithPaddingAndNoChildren():void
		{
			this._layout.useVirtualLayout = false;
			this._layout.paddingTop = PADDING_TOP;
			this._layout.paddingRight = PADDING_RIGHT;
			this._layout.paddingBottom = PADDING_BOTTOM;
			this._layout.paddingLeft = PADDING_LEFT;
			var result:LayoutBoundsResult = this._layout.layout(new <DisplayObject>[]);
			Assert.assertStrictlyEquals("SlideShowLayout: viewPortWidth not equal to sum of left and right padding with no children.",
				PADDING_LEFT + PADDING_RIGHT, result.viewPortWidth);
			Assert.assertStrictlyEquals("SlideShowLayout: viewPortHeight not equal to sum of top and bottom padding with no children.",
				PADDING_TOP + PADDING_BOTTOM, result.viewPortHeight);
			Assert.assertStrictlyEquals("SlideShowLayout: contentWidth not equal to sum of left and right padding with no children.",
				PADDING_LEFT + PADDING_RIGHT, result.contentWidth);
			Assert.assertStrictlyEquals("SlideShowLayout: contentHeight not equal to sum of top and bottom padding with no children.",
				PADDING_TOP + PADDING_BOTTOM, result.contentHeight);
		}

		[Test]
		public function testMeasureViewPortResultWithPaddingAndNoChildren():void
		{
			this._layout.useVirtualLayout = true;
			this._layout.paddingTop = PADDING_TOP;
			this._layout.paddingRight = PADDING_RIGHT;
			this._layout.paddingBottom = PADDING_BOTTOM;
			this._layout.paddingLeft = PADDING_LEFT;
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:Point = this._layout.measureViewPort(0, bounds);
			Assert.assertStrictlyEquals("SlideShowLayout: measureViewPort x not equal to sum of left and right padding with no children.",
				PADDING_LEFT + PADDING_RIGHT, result.x);
			Assert.assertStrictlyEquals("SlideShowLayout: measureViewPort y not equal to sum of top and bottom padding with no children.",
				PADDING_TOP + PADDING_BOTTOM, result.y);
		}

		[Test]
		public function testLayoutResultWithOneChild():void
		{
			this._layout.useVirtualLayout = false;
			this._child1 = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			var result:LayoutBoundsResult = this._layout.layout(new <DisplayObject>[this._child1]);
			Assert.assertStrictlyEquals("SlideShowLayout: viewPortWidth not equal to child width.",
				CHILD1_WIDTH, result.viewPortWidth);
			Assert.assertStrictlyEquals("SlideShowLayout: viewPortHeight not equal to child height.",
				CHILD1_HEIGHT, result.viewPortHeight);
			Assert.assertStrictlyEquals("SlideShowLayout: contentWidth not equal to child width.",
				CHILD1_WIDTH, result.contentWidth);
			Assert.assertStrictlyEquals("SlideShowLayout: contentHeight not equal to child height.",
				CHILD1_HEIGHT, result.contentHeight);
		}

		[Test]
		public function testMeasureViewPortResultWithOneChild():void
		{
			this._layout.useVirtualLayout = true;
			this._child1 = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			this._layout.typicalItem = this._child1;
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:Point = this._layout.measureViewPort(1, bounds);
			Assert.assertStrictlyEquals("SlideShowLayout: measureViewPort x not equal to child width.",
				CHILD1_WIDTH, result.x);
			Assert.assertStrictlyEquals("SlideShowLayout: measureViewPort y not equal to child height.",
				CHILD1_HEIGHT, result.y);
		}

		[Test]
		public function testLayoutResultWithPaddingAndOneChild():void
		{
			this._layout.useVirtualLayout = false;
			this._layout.paddingTop = PADDING_TOP;
			this._layout.paddingRight = PADDING_RIGHT;
			this._layout.paddingBottom = PADDING_BOTTOM;
			this._layout.paddingLeft = PADDING_LEFT;
			this._child1 = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			var items:Vector.<DisplayObject> = new <DisplayObject>[this._child1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("SlideShowLayout: viewPortWidth not equal to child width plus left and right padding.",
				CHILD1_WIDTH + PADDING_LEFT + PADDING_RIGHT, result.viewPortWidth);
			Assert.assertStrictlyEquals("SlideShowLayout: viewPortHeight not equal to child height plus top and bottom padding.",
				CHILD1_HEIGHT + PADDING_TOP + PADDING_BOTTOM, result.viewPortHeight);
			Assert.assertStrictlyEquals("SlideShowLayout: contentWidth not equal to child width plus left and right padding.",
				CHILD1_WIDTH + PADDING_LEFT + PADDING_RIGHT, result.contentWidth);
			Assert.assertStrictlyEquals("SlideShowLayout: contentHeight not equal to child height plus top and bottom padding.",
				CHILD1_HEIGHT + PADDING_TOP + PADDING_BOTTOM, result.contentHeight);
		}

		[Test]
		public function testMeasureViewPortResultWithPaddingAndOneChild():void
		{
			this._layout.useVirtualLayout = true;
			this._layout.paddingTop = PADDING_TOP;
			this._layout.paddingRight = PADDING_RIGHT;
			this._layout.paddingBottom = PADDING_BOTTOM;
			this._layout.paddingLeft = PADDING_LEFT;
			this._child1 = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			this._layout.typicalItem = this._child1;
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:Point = this._layout.measureViewPort(1, bounds);
			Assert.assertStrictlyEquals("SlideShowLayout: measureViewPort x not equal to child width plus left and right padding.",
				CHILD1_WIDTH + PADDING_LEFT + PADDING_RIGHT, result.x);
			Assert.assertStrictlyEquals("SlideShowLayout: measureViewPort y not equal to child height plus top and bottom padding.",
				CHILD1_HEIGHT + PADDING_TOP + PADDING_BOTTOM, result.y);
		}

		[Test]
		public function testLayoutResultWithTwoChildrenPositionedHorizontally():void
		{
			this._layout.direction = Direction.HORIZONTAL;
			this._layout.useVirtualLayout = false;
			this._child1 = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			this._child2 = new Quad(CHILD2_WIDTH, CHILD2_HEIGHT, 0xff00ff);
			var items:Vector.<DisplayObject> = new <DisplayObject>[this._child1, this._child2];
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("SlideShowLayout: viewPortWidth not equal to max child width.",
				Math.max(CHILD1_WIDTH, CHILD2_WIDTH), result.viewPortWidth);
			Assert.assertStrictlyEquals("SlideShowLayout: viewPortHeight not equal to max child height.",
				Math.max(CHILD1_HEIGHT, CHILD2_HEIGHT), result.viewPortHeight);
			Assert.assertStrictlyEquals("SlideShowLayout: contentWidth not equal to max child width multiplied by number of items.",
				2 * Math.max(CHILD1_WIDTH, CHILD2_WIDTH), result.contentWidth);
			Assert.assertStrictlyEquals("SlideShowLayout: contentHeight not equal to max child height.",
				Math.max(CHILD1_HEIGHT, CHILD2_HEIGHT), result.contentHeight);
		}

		[Test]
		public function testLayoutResultWithTwoChildrenPositionedVertically():void
		{
			this._layout.direction = Direction.VERTICAL;
			this._layout.useVirtualLayout = false;
			this._child1 = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			this._child2 = new Quad(CHILD2_WIDTH, CHILD2_HEIGHT, 0xff00ff);
			var items:Vector.<DisplayObject> = new <DisplayObject>[this._child1, this._child2];
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("SlideShowLayout: viewPortWidth not equal to max child width.",
				Math.max(CHILD1_WIDTH, CHILD2_WIDTH), result.viewPortWidth);
			Assert.assertStrictlyEquals("SlideShowLayout: viewPortHeight not equal to max child height.",
				Math.max(CHILD1_HEIGHT, CHILD2_HEIGHT), result.viewPortHeight);
			Assert.assertStrictlyEquals("SlideShowLayout: contentWidth not equal to max child width.",
				Math.max(CHILD1_WIDTH, CHILD2_WIDTH), result.contentWidth);
			Assert.assertStrictlyEquals("SlideShowLayout: contentHeight not equal to max child height multiplied by number of items.",
				2 * Math.max(CHILD1_HEIGHT, CHILD2_HEIGHT), result.contentHeight);
		}

		[Test]
		public function testMeasureViewPortResultWithTwoChildrenPositionedHorizontally():void
		{
			this._layout.direction = Direction.HORIZONTAL;
			this._layout.useVirtualLayout = true;
			this._child1 = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			this._layout.typicalItem = this._child1;
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:Point = this._layout.measureViewPort(2, bounds);
			Assert.assertStrictlyEquals("SlideShowLayout: viewPortWidth not equal to max child width.",
				Math.max(CHILD1_WIDTH, CHILD2_WIDTH), result.x);
			Assert.assertStrictlyEquals("SlideShowLayout: viewPortHeight not equal to max child height.",
				Math.max(CHILD1_HEIGHT, CHILD2_HEIGHT), result.y);
		}

		[Test]
		public function testMeasureViewPortResultWithTwoChildrenPositionedVertically():void
		{
			this._layout.direction = Direction.VERTICAL;
			this._layout.useVirtualLayout = true;
			this._child1 = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			this._layout.typicalItem = this._child1;
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:Point = this._layout.measureViewPort(2, bounds);
			Assert.assertStrictlyEquals("SlideShowLayout: measureViewPort x not equal to max child width.",
				Math.max(CHILD1_WIDTH, CHILD2_WIDTH), result.x);
			Assert.assertStrictlyEquals("SlideShowLayout: measureViewPort y not equal to max child height.",
				Math.max(CHILD1_HEIGHT, CHILD2_HEIGHT), result.y);
		}

		[Test]
		public function testLayoutResultWithExplicitWidthSmallerThanChild():void
		{
			this._layout.useVirtualLayout = false;
			this._child1 = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			var items:Vector.<DisplayObject> = new <DisplayObject>[this._child1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitWidth = CHILD1_WIDTH / 3;
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("SlideShowLayout: viewPortWidth not equal to explicitWidth when explicitWidth is smaller than item width.",
				bounds.explicitWidth, result.viewPortWidth);
			Assert.assertStrictlyEquals("SlideShowLayout: contentWidth not equal to explicitWidth when explicitWidth is smaller than item width.",
				bounds.explicitWidth, result.contentWidth);
		}

		[Test]
		public function testMeasureViewPortResultWithExplicitWidthSmallerThanChild():void
		{
			this._layout.useVirtualLayout = true;
			this._child1 = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			this._layout.typicalItem = this._child1;
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitWidth = CHILD1_WIDTH / 3;
			var result:Point = this._layout.measureViewPort(1, bounds);
			Assert.assertStrictlyEquals("SlideShowLayout: measureViewPort x not equal to explicitWidth when explicitWidth is smaller than item width.",
				bounds.explicitWidth, result.x);
		}

		[Test]
		public function testLayoutResultWithExplicitWidthLargerThanChild():void
		{
			this._layout.useVirtualLayout = false;
			this._child1 = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			var items:Vector.<DisplayObject> = new <DisplayObject>[this._child1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitWidth = 3 * CHILD1_WIDTH;
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("SlideShowLayout: viewPortWidth not equal to explicitWidth when explicitWidth is larger than item width.",
				bounds.explicitWidth, result.viewPortWidth);
			Assert.assertStrictlyEquals("SlideShowLayout: contentWidth not equal to explicitWidth when explicitWidth is larger than item width.",
				bounds.explicitWidth, result.contentWidth);
		}

		[Test]
		public function testMeasureViewPortResultWithExplicitWidthLargerThanChild():void
		{
			this._layout.useVirtualLayout = true;
			this._child1 = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			this._layout.typicalItem = this._child1;
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitWidth = 3 * CHILD1_WIDTH;
			var result:Point = this._layout.measureViewPort(1, bounds);
			Assert.assertStrictlyEquals("SlideShowLayout: measureViewPort x not equal to explicitWidth when explicitWidth is larger than item width.",
				bounds.explicitWidth, result.x);
		}

		[Test]
		public function testLayoutResultWithMaxWidthSmallerThanChild():void
		{
			this._layout.useVirtualLayout = false;
			this._child1 = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			var items:Vector.<DisplayObject> = new <DisplayObject>[this._child1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.maxWidth = CHILD1_WIDTH / 3;
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("SlideShowLayout: viewPortWidth not equal to maxWidth when maxWidth is smaller than item width.",
				bounds.maxWidth, result.viewPortWidth);
			Assert.assertStrictlyEquals("SlideShowLayout: contentWidth not equal to maxWidth when maxWidth is smaller than item width.",
				bounds.maxWidth, result.contentWidth);
		}

		[Test]
		public function testMeasureViewPortResultWithMaxWidthSmallerThanChild():void
		{
			this._layout.useVirtualLayout = true;
			this._child1 = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			this._layout.typicalItem = this._child1;
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.maxWidth = CHILD1_WIDTH / 3;
			var result:Point = this._layout.measureViewPort(1, bounds);
			Assert.assertStrictlyEquals("SlideShowLayout: measureViewPort x not equal to maxWidth when maxWidth is smaller than item width.",
				bounds.maxWidth, result.x);
		}

		[Test]
		public function testLayoutResultWithMinWidthLargerThanChild():void
		{
			this._layout.useVirtualLayout = false;
			this._child1 = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			var items:Vector.<DisplayObject> = new <DisplayObject>[this._child1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.minWidth = 3 * CHILD1_WIDTH;
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("SlideShowLayout: viewPortWidth not equal to minWidth when minWidth is larger than item width.",
				bounds.minWidth, result.viewPortWidth);
			Assert.assertStrictlyEquals("SlideShowLayout: contentWidth not equal to minWidth when minWidth is larger than item width.",
				bounds.minWidth, result.contentWidth);
		}

		[Test]
		public function testMeasureViewPortResultWithMinWidthLargerThanChild():void
		{
			this._layout.useVirtualLayout = true;
			this._child1 = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			this._layout.typicalItem = this._child1;
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.minWidth = 3 * CHILD1_WIDTH;
			var result:Point = this._layout.measureViewPort(1, bounds);
			Assert.assertStrictlyEquals("SlideShowLayout: measureViewPort x not equal to minWidth when minWidth is larger than item width.",
				bounds.minWidth, result.x);
		}

		[Test]
		public function testLayoutResultWithMaxWidthLargerThanChild():void
		{
			this._layout.useVirtualLayout = false;
			this._child1 = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			var items:Vector.<DisplayObject> = new <DisplayObject>[this._child1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			//needs to be enough to require more than one tile
			bounds.maxWidth = 3 * CHILD1_WIDTH;
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("SlideShowLayout: viewPortWidth not equal to item width when maxWidth is larger than item width.",
				CHILD1_WIDTH, result.viewPortWidth);
			Assert.assertStrictlyEquals("SlideShowLayout: contentWidth not equal to item width when maxWidth is larger than item width.",
				CHILD1_WIDTH, result.contentWidth);
		}

		[Test]
		public function testMeasureViewPortResultWithMaxWidthLargerThanChild():void
		{
			this._layout.useVirtualLayout = true;
			this._child1 = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			this._layout.typicalItem = this._child1;
			var bounds:ViewPortBounds = new ViewPortBounds();
			//needs to be enough to require more than one tile
			bounds.maxWidth = 3 * CHILD1_WIDTH;
			var result:Point = this._layout.measureViewPort(1, bounds);
			Assert.assertStrictlyEquals("SlideShowLayout: measureViewPort x not equal to item width when maxWidth is larger than item width.",
				CHILD1_WIDTH, result.x);
		}

		[Test]
		public function testLayoutResultWithExplicitHeightSmallerThanChild():void
		{
			this._layout.useVirtualLayout = false;
			this._child1 = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			var items:Vector.<DisplayObject> = new <DisplayObject>[this._child1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitHeight = CHILD1_HEIGHT / 3;
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("SlideShowLayout: viewPortHeight not equal to explicitHeight when explicitHeight is smaller than item height.",
				bounds.explicitHeight, result.viewPortHeight);
			Assert.assertStrictlyEquals("SlideShowLayout: contentHeight not equal to explicitHeight when explicitHeight is smaller than item height.",
				bounds.explicitHeight, result.contentHeight);
		}

		[Test]
		public function testMeasureViewPortResultWithExplicitHeightSmallerThanChild():void
		{
			this._layout.useVirtualLayout = true;
			this._child1 = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			this._layout.typicalItem = this._child1;
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitHeight = CHILD1_HEIGHT / 3;
			var result:Point = this._layout.measureViewPort(1, bounds);
			Assert.assertStrictlyEquals("SlideShowLayout: measureViewPort y not equal to explicitHeight when explicitHeight is smaller than item height.",
				bounds.explicitHeight, result.y);
		}

		[Test]
		public function testLayoutResultWithExplicitHeightLargerThanChild():void
		{
			this._layout.useVirtualLayout = false;
			this._child1 = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			var items:Vector.<DisplayObject> = new <DisplayObject>[this._child1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitHeight = 3 * CHILD1_HEIGHT;
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("SlideShowLayout: viewPortHeight not equal to explicitHeight when explicitHeight is larger than item height.",
				bounds.explicitHeight, result.viewPortHeight);
			Assert.assertStrictlyEquals("SlideShowLayout: contentHeight not equal to explicitHeight when explicitHeight is larger than item height.",
				bounds.explicitHeight, result.contentHeight);
		}

		[Test]
		public function testMeasureViewPortResultWithExplicitHeightLargerThanChild():void
		{
			this._layout.useVirtualLayout = true;
			this._child1 = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			this._layout.typicalItem = this._child1;
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitHeight = 3 * CHILD1_HEIGHT;
			var result:Point = this._layout.measureViewPort(1, bounds);
			Assert.assertStrictlyEquals("SlideShowLayout: measureViewPort y not equal to explicitHeight when explicitHeight is larger than item height.",
				bounds.explicitHeight, result.y);
		}

		[Test]
		public function testLayoutResultWithMaxHeightSmallerThanChild():void
		{
			this._layout.useVirtualLayout = false;
			this._child1 = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			var items:Vector.<DisplayObject> = new <DisplayObject>[this._child1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.maxHeight = CHILD1_HEIGHT / 3;
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("SlideShowLayout: viewPortHeight not equal to maxHeight when maxHeight is smaller than item height.",
				bounds.maxHeight, result.viewPortHeight);
			Assert.assertStrictlyEquals("SlideShowLayout: contentHeight not equal to maxHeight when maxHeight is smaller than item height.",
				bounds.maxHeight, result.contentHeight);
		}

		[Test]
		public function testMeasureViewPortResultWithMaxHeightSmallerThanChild():void
		{
			this._layout.useVirtualLayout = true;
			this._child1 = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			this._layout.typicalItem = this._child1;
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.maxHeight = CHILD1_HEIGHT / 3;
			var result:Point = this._layout.measureViewPort(1, bounds);
			Assert.assertStrictlyEquals("SlideShowLayout: measureViewPort y not equal to maxHeight when maxHeight is smaller than item height.",
				bounds.maxHeight, result.y);
		}

		[Test]
		public function testLayoutResultWithMinHeightLargerThanChild():void
		{
			this._layout.useVirtualLayout = false;
			this._child1 = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			var items:Vector.<DisplayObject> = new <DisplayObject>[this._child1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.minHeight = 3 * CHILD1_HEIGHT;
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("SlideShowLayout: viewPortHeight not equal to minHeight when minHeight is larger than item height.",
				bounds.minHeight, result.viewPortHeight);
			Assert.assertStrictlyEquals("SlideShowLayout: contentHeight not equal to minHeight when minHeight is larger than item height.",
				bounds.minHeight, result.contentHeight);
		}

		[Test]
		public function testMeasureViewPortResultWithMinHeightLargerThanChild():void
		{
			this._layout.useVirtualLayout = true;
			this._child1 = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			this._layout.typicalItem = this._child1;
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.minHeight = 3 * CHILD1_HEIGHT;
			var result:Point = this._layout.measureViewPort(1, bounds);
			Assert.assertStrictlyEquals("SlideShowLayout: measureViewPort y not equal to minHeight when minHeight is larger than item height.",
				bounds.minHeight, result.y);
		}

		[Test]
		public function testLayoutResultWithMaxHeightLargerThanChild():void
		{
			this._layout.useVirtualLayout = false;
			this._child1 = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			var items:Vector.<DisplayObject> = new <DisplayObject>[this._child1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			//needs to be enough to require more than one tile
			bounds.maxHeight = 3 * CHILD1_HEIGHT;
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("SlideShowLayout: viewPortHeight not equal to item height when maxHeight is larger than item height.",
				CHILD1_HEIGHT, result.viewPortHeight);
			Assert.assertStrictlyEquals("SlideShowLayout: contentHeight not equal to item height when maxHeight is larger than item height.",
				CHILD1_HEIGHT, result.contentHeight);
		}

		[Test]
		public function testMeasureViewPortResultWithMaxHeightLargerThanChild():void
		{
			this._layout.useVirtualLayout = true;
			this._child1 = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			this._layout.typicalItem = this._child1;
			var bounds:ViewPortBounds = new ViewPortBounds();
			//needs to be enough to require more than one tile
			bounds.maxHeight = 3 * CHILD1_HEIGHT;
			var result:Point = this._layout.measureViewPort(1, bounds);
			Assert.assertStrictlyEquals("SlideShowLayout: measureViewPort y not equal to item height when maxHeight is larger than item height.",
				CHILD1_HEIGHT, result.y);
		}
	}
}
