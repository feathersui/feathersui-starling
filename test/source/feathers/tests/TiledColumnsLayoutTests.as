package feathers.tests
{
	import feathers.layout.LayoutBoundsResult;
	import feathers.layout.TiledColumnsLayout;
	import feathers.layout.ViewPortBounds;

	import flash.geom.Point;

	import org.flexunit.Assert;

	import starling.display.DisplayObject;
	import starling.display.Quad;

	public class TiledColumnsLayoutTests
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
		private static const CHILD3_WIDTH:Number = 75;
		private static const CHILD3_HEIGHT:Number = 50;

		private var _layout:TiledColumnsLayout;

		[Before]
		public function prepare():void
		{
			this._layout = new TiledColumnsLayout();
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
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult viewPortWidth not equal to 0 with no items.", 0, result.viewPortWidth);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult viewPortHeight not equal to 0 with no items.", 0, result.viewPortHeight);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult contentWidth not equal to 0 with no items.", 0, result.contentWidth);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult contentHeight not equal to 0 with no items.", 0, result.contentHeight);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult contentX not equal to 0 with no items.", 0, result.contentX);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult contentY not equal to 0 with no items.", 0, result.contentY);
		}

		[Test]
		public function testMeasureViewPortResultWithNoItems():void
		{
			this._layout.useVirtualLayout = true;
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:Point = this._layout.measureViewPort(0, bounds);
			Assert.assertStrictlyEquals("TiledColumnsLayout measureViewPort width not equal to 0 with no items.", 0, result.x);
			Assert.assertStrictlyEquals("TiledColumnsLayout measureViewPort height not equal to 0 with no items.", 0, result.y);
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
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult viewPortWidth not equal to sum of left and right padding with no items.", PADDING_LEFT + PADDING_RIGHT, result.viewPortWidth);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult viewPortHeight not equal to sum of top and bottom padding with no items.", PADDING_TOP + PADDING_BOTTOM, result.viewPortHeight);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult contentWidth not equal to sum of left and right padding with no items.", PADDING_LEFT + PADDING_RIGHT, result.contentWidth);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult contentHeight not equal to sum of top and bottom padding with no items.", PADDING_TOP + PADDING_BOTTOM, result.contentHeight);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult contentX not equal to 0 with padding and no items.", 0, result.contentX);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult contentY not equal to 0 with padding and no items.", 0, result.contentY);
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
			Assert.assertStrictlyEquals("TiledColumnsLayout measureViewPort x not equal to sum of left and right padding with no items.", PADDING_LEFT + PADDING_RIGHT, result.x);
			Assert.assertStrictlyEquals("TiledColumnsLayout measureViewPort y not equal to sum of top and bottom padding with no items.", PADDING_TOP + PADDING_BOTTOM, result.y);
		}

		[Test]
		public function testLayoutResultWithOneChildAndSquareTiles():void
		{
			var item1:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			var tileSize:Number = Math.max(CHILD1_WIDTH, CHILD1_HEIGHT);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult viewPortWidth not equal to max child dimension with square tiles and one item.", tileSize, result.viewPortWidth);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult viewPortHeight not equal to max child dimension with square tiles and one item.", tileSize, result.viewPortHeight);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult contentWidth not equal to max child dimension with square tiles and one item.", tileSize, result.contentWidth);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult contentHeight not equal to max child dimension with square tiles and one item.", tileSize, result.contentHeight);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult contentX not equal to 0 with one item and square tiles.", 0, result.contentX);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult contentY not equal to 0 with one item and square tiles.", 0, result.contentY);
		}

		[Test]
		public function testMeasureViewPortResultWithOneChildAndSquareTiles():void
		{
			var item1:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			this._layout.useVirtualLayout = true;
			this._layout.typicalItem = item1;
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:Point = this._layout.measureViewPort(1, bounds);
			var tileSize:Number = Math.max(CHILD1_WIDTH, CHILD1_HEIGHT);
			Assert.assertStrictlyEquals("TiledColumnsLayout measureViewPort x not equal to max child dimension with square tiles and one item.", tileSize, result.x);
			Assert.assertStrictlyEquals("TiledColumnsLayout measureViewPort y not equal to max child dimension with square tiles and one item.", tileSize, result.y);
		}

		[Test]
		public function testLayoutResultWithOneChildAndNotSquareTiles():void
		{
			this._layout.useSquareTiles = false;
			var item1:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult viewPortWidth not equal to child width with non-square tiles and one item.", CHILD1_WIDTH, result.viewPortWidth);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult viewPortHeight not equal to child height with non-square tiles and one item.", CHILD1_HEIGHT, result.viewPortHeight);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult contentWidth not equal to child width with non-square tiles and one item.", CHILD1_WIDTH, result.contentWidth);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult contentHeight not equal to child height with non-square tiles and one item.", CHILD1_HEIGHT, result.contentHeight);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult contentX not equal to 0 with one item and non-square tiles.", 0, result.contentX);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult contentY not equal to 0 with one item and non-square tiles.", 0, result.contentY);
		}

		[Test]
		public function testMeasureViewPortResultWithOneChildAndNotSquareTiles():void
		{
			var item1:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			this._layout.useSquareTiles = false;
			this._layout.useVirtualLayout = true;
			this._layout.typicalItem = item1;
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:Point = this._layout.measureViewPort(1, bounds);
			Assert.assertStrictlyEquals("TiledColumnsLayout measureViewPort x not equal to child width with non-square tiles and one item.", CHILD1_WIDTH, result.x);
			Assert.assertStrictlyEquals("TiledColumnsLayout measureViewPort y not equal to child height with non-square tiles and one item.", CHILD1_HEIGHT, result.y);
		}

		[Test]
		public function testLayoutResultWithPaddingGapAndOneChild():void
		{
			this._layout.useSquareTiles = false;
			this._layout.paddingTop = PADDING_TOP;
			this._layout.paddingRight = PADDING_RIGHT;
			this._layout.paddingBottom = PADDING_BOTTOM;
			this._layout.paddingLeft = PADDING_LEFT;
			this._layout.gap = GAP;
			var item1:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult viewPortWidth not equal to sum of left and right padding and width of child.", CHILD1_WIDTH + PADDING_LEFT + PADDING_RIGHT, result.viewPortWidth);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult viewPortHeight not equal to sum of top and bottom padding and height of child.", CHILD1_HEIGHT + PADDING_TOP + PADDING_BOTTOM, result.viewPortHeight);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult contentWidth not equal to sum of left and right padding and width of child.", CHILD1_WIDTH + PADDING_LEFT + PADDING_RIGHT, result.contentWidth);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult contentHeight not equal to sum of top and bottom padding and height of child.", CHILD1_HEIGHT + PADDING_TOP + PADDING_BOTTOM, result.contentHeight);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult contentX not equal to 0 with one item and padding.", 0, result.contentX);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult contentY not equal to 0 with one item and padding.", 0, result.contentY);
		}

		[Test]
		public function testMeasureViewPortResultWithPaddingGapAndOneChild():void
		{
			var item1:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			this._layout.useVirtualLayout = true;
			this._layout.typicalItem = item1;
			this._layout.useSquareTiles = false;
			this._layout.paddingTop = PADDING_TOP;
			this._layout.paddingRight = PADDING_RIGHT;
			this._layout.paddingBottom = PADDING_BOTTOM;
			this._layout.paddingLeft = PADDING_LEFT;
			this._layout.gap = GAP;
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:Point = this._layout.measureViewPort(1, bounds);
			Assert.assertStrictlyEquals("TiledColumnsLayout measureViewPort x not equal to sum of left and right padding and width of child.", CHILD1_WIDTH + PADDING_LEFT + PADDING_RIGHT, result.x);
			Assert.assertStrictlyEquals("TiledColumnsLayout measureViewPort y not equal to sum of top and bottom padding and height of child.", CHILD1_HEIGHT + PADDING_TOP + PADDING_BOTTOM, result.y);
		}

		[Test]
		public function testLayoutResultWithTwoChildren():void
		{
			this._layout.useSquareTiles = false;
			var item1:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			var item2:Quad = new Quad(CHILD2_WIDTH, CHILD2_HEIGHT, 0xff00ff);
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1, item2];
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			var maxChildWidth:Number = Math.max(CHILD1_WIDTH, CHILD2_WIDTH);
			var maxChildHeight:Number = Math.max(CHILD1_HEIGHT, CHILD2_HEIGHT);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult viewPortWidth not equal to max width of items.", maxChildWidth, result.viewPortWidth);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult viewPortHeight not equal to sum of tile heights.", 2 * maxChildHeight, result.viewPortHeight);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult contentWidth not equal to max width of items.", maxChildWidth, result.contentWidth);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult contentHeight not equal to sum of tile heights.", 2 * maxChildHeight, result.contentHeight);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult contentX not equal to 0 with padding and two items.", 0, result.contentX);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult contentY not equal to 0 with padding and two items.", 0, result.contentY);
		}

		[Test]
		public function testMeasureViewPortResultWithTwoChildren():void
		{
			var item1:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			this._layout.useSquareTiles = false;
			this._layout.useVirtualLayout = true;
			this._layout.typicalItem = item1;
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:Point = this._layout.measureViewPort(2, bounds);
			Assert.assertStrictlyEquals("TiledColumnsLayout measureViewPort x not equal to width of typical item.", CHILD1_WIDTH, result.x);
			Assert.assertStrictlyEquals("TiledColumnsLayout measureViewPort y not equal to typical item height multiplied by the number of items.", 2 * CHILD1_HEIGHT, result.y);
		}

		[Test]
		public function testLayoutResultWithPaddingGapAndTwoChildren():void
		{
			this._layout.useSquareTiles = false;
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
			var maxChildWidth:Number = Math.max(CHILD1_WIDTH, CHILD2_WIDTH);
			var maxChildHeight:Number = Math.max(CHILD1_HEIGHT, CHILD2_HEIGHT);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult viewPortWidth not equal to max width of items plus left and right padding.", maxChildWidth + PADDING_LEFT + PADDING_RIGHT, result.viewPortWidth);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult viewPortHeight not equal to sum of tile heights plus top and bottom padding and gap.", 2 * maxChildHeight + PADDING_TOP + PADDING_BOTTOM + GAP, result.viewPortHeight);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult contentWidth not equal to sum of max width of items plus left and right padding.", maxChildWidth + PADDING_LEFT + PADDING_RIGHT, result.contentWidth);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult contentHeight not equal to sum of tile heights plus top and bottom padding and gap.", 2 * maxChildHeight + PADDING_TOP + PADDING_BOTTOM + GAP, result.contentHeight);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult contentX not equal to 0 with two items plus padding and gap.", 0, result.contentX);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult contentY not equal to 0 with two items plus padding and gap.", 0, result.contentY);
		}

		[Test]
		public function testMeasureViewPortResultWithPaddingGapAndTwoChildren():void
		{
			var item1:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			this._layout.useSquareTiles = false;
			this._layout.paddingTop = PADDING_TOP;
			this._layout.paddingRight = PADDING_RIGHT;
			this._layout.paddingBottom = PADDING_BOTTOM;
			this._layout.paddingLeft = PADDING_LEFT;
			this._layout.gap = GAP;
			this._layout.useVirtualLayout = true;
			this._layout.typicalItem = item1;
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:Point = this._layout.measureViewPort(2, bounds);
			Assert.assertStrictlyEquals("TiledColumnsLayout measureViewPort x not equal to max width of items plus left and right padding.", CHILD1_WIDTH + PADDING_LEFT + PADDING_RIGHT, result.x);
			Assert.assertStrictlyEquals("TiledColumnsLayout measureViewPort y not equal to sum of tile heights plus top and bottom padding and gap.", 2 * CHILD1_HEIGHT + PADDING_TOP + PADDING_BOTTOM + GAP, result.y);
		}

		[Test]
		public function testLayoutResultWithRequestedRowCountLargerThanItemCount():void
		{
			this._layout.useSquareTiles = false;
			this._layout.requestedRowCount = 2;
			var item1:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult viewPortWidth not equal to max width of items with requestedRowCount larger than item count.", CHILD1_WIDTH, result.viewPortWidth);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult viewPortHeight not equal to tile height multiplied by requestedRowCount larger than item count.", 2 * CHILD1_HEIGHT, result.viewPortHeight);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult contentWidth not equal to max width of items with requestedRowCount larger than item count.", CHILD1_WIDTH, result.contentWidth);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult contentHeight not equal to tile height multiplied by requestedRowCount larger than item count.", 2 * CHILD1_HEIGHT, result.contentHeight);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult contentX not equal to 0 with requestedRowCount larger than item count.", 0, result.contentX);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult contentY not equal to 0 with requestedRowCount larger than item count.", 0, result.contentY);
		}

		[Test]
		public function testMeasureViewPortResultWithRequestedRowCountLargerThanItemCount():void
		{
			var item1:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			this._layout.useVirtualLayout = true;
			this._layout.typicalItem = item1;
			this._layout.useSquareTiles = false;
			this._layout.requestedRowCount = 2;
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:Point = this._layout.measureViewPort(1, bounds);
			Assert.assertStrictlyEquals("TiledColumnsLayout measureViewPort x not equal to max width of items with requestedRowCount larger than item count.", CHILD1_WIDTH, result.x);
			Assert.assertStrictlyEquals("TiledColumnsLayout measureViewPort y not equal to tile height multiplied by requestedRowCount larger than item count.", 2 * CHILD1_HEIGHT, result.y);
		}

		[Test]
		public function testLayoutResultWithRequestedRowCountSmallerThanItemCount():void
		{
			this._layout.useSquareTiles = false;
			this._layout.requestedRowCount = 2;
			var item1:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			var item2:Quad = new Quad(CHILD2_WIDTH, CHILD2_HEIGHT, 0xff00ff);
			var item3:Quad = new Quad(CHILD3_WIDTH, CHILD3_HEIGHT, 0xff00ff);
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1, item2, item3];
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			var maxChildWidth:Number = Math.max(CHILD1_WIDTH, CHILD2_WIDTH, CHILD3_WIDTH);
			var maxChildHeight:Number = Math.max(CHILD1_HEIGHT, CHILD2_HEIGHT, CHILD3_HEIGHT);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult viewPortWidth not equal to max width of items multiplied by column count with requestedRowCount smaller than item count.", 2 * maxChildWidth, result.viewPortWidth);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult viewPortHeight not equal to tile height multiplied by requestedRowCount smaller than item count.", 2 * maxChildHeight, result.viewPortHeight);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult contentWidth not equal to max width of items multiplied by column count with requestedRowCount smaller than item count.", 2 * maxChildWidth, result.contentWidth);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult contentHeight not equal to tile height multiplied by requestedRowCount smaller than item count.", 2 * maxChildHeight, result.contentHeight);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult contentX not equal to 0 with requestedRowCount smaller than item count.", 0, result.contentX);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult contentY not equal to 0 with requestedRowCount smaller than item count.", 0, result.contentY);
		}

		[Test]
		public function testMeasureViewPortResultWithRequestedRowCountSmallerThanItemCount():void
		{
			var item1:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			this._layout.useVirtualLayout = true;
			this._layout.typicalItem = item1;
			this._layout.useSquareTiles = false;
			this._layout.requestedRowCount = 2;
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:Point = this._layout.measureViewPort(3, bounds);
			Assert.assertStrictlyEquals("TiledColumnsLayout measureViewPort x not equal to max width of items multiplied by column count with requestedRowCount smaller than item count.", 2 * CHILD1_WIDTH, result.x);
			Assert.assertStrictlyEquals("TiledColumnsLayout measureViewPort y not equal to tile height multiplied by requestedRowCount smaller than item count.", 2 * CHILD1_HEIGHT, result.y);
		}

		[Test]
		public function testLayoutResultWithExplicitWidthSmallerThanChild():void
		{
			this._layout.useSquareTiles = false;
			var item1:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitWidth = CHILD1_WIDTH / 3;
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult viewPortWidth not equal to explicitWidth when explicitWidth is smaller than item width.", bounds.explicitWidth, result.viewPortWidth);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult contentWidth not equal to item width when explicitWidth is smaller than item width.", CHILD1_WIDTH, result.contentWidth);
		}

		[Test]
		public function testMeasureViewPortResultWithExplicitWidthSmallerThanChild():void
		{
			var item1:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			this._layout.useVirtualLayout = true;
			this._layout.typicalItem = item1;
			this._layout.useSquareTiles = false;
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitWidth = CHILD1_WIDTH / 3;
			var result:Point = this._layout.measureViewPort(1, bounds);
			Assert.assertStrictlyEquals("TiledColumnsLayout measureViewPort x not equal to explicitWidth when explicitWidth is smaller than item width.", bounds.explicitWidth, result.x);
		}

		[Test]
		public function testLayoutResultWithExplicitWidthLargerThanChild():void
		{
			this._layout.useSquareTiles = false;
			var item1:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitWidth = 3 * CHILD1_WIDTH;
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult viewPortWidth not equal to explicitWidth when explicitWidth is larger than item width.", bounds.explicitWidth, result.viewPortWidth);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult contentWidth not equal to item width when explicitWidth is larger than item width.", CHILD1_WIDTH, result.contentWidth);
		}

		[Test]
		public function testMeasureViewPortResultWithExplicitWidthLargerThanChild():void
		{
			var item1:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			this._layout.useVirtualLayout = true;
			this._layout.typicalItem = item1;
			this._layout.useSquareTiles = false;
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitWidth = 3 * CHILD1_WIDTH;
			var result:Point = this._layout.measureViewPort(1, bounds);
			Assert.assertStrictlyEquals("TiledColumnsLayout measureViewPort x not equal to explicitWidth when explicitWidth is larger than item width.", bounds.explicitWidth, result.x);
		}

		[Test]
		public function testLayoutResultWithMaxWidthSmallerThanChild():void
		{
			this._layout.useSquareTiles = false;
			var item1:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.maxWidth = CHILD1_WIDTH / 3;
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult viewPortWidth not equal to maxWidth when maxWidth is smaller than item width.", bounds.maxWidth, result.viewPortWidth);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult contentWidth not equal to item width when maxWidth is smaller than item width.", CHILD1_WIDTH, result.contentWidth);
		}

		[Test]
		public function testMeasureViewPortResultWithMaxWidthSmallerThanChild():void
		{
			var item1:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			this._layout.useVirtualLayout = true;
			this._layout.typicalItem = item1;
			this._layout.useSquareTiles = false;
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.maxWidth = CHILD1_WIDTH / 3;
			var result:Point = this._layout.measureViewPort(1, bounds);
			Assert.assertStrictlyEquals("TiledColumnsLayout measureViewPort x not equal to maxWidth when maxWidth is smaller than item width.", bounds.maxWidth, result.x);
		}

		[Test]
		public function testLayoutResultWithMinWidthLargerThanChild():void
		{
			this._layout.useSquareTiles = false;
			var item1:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.minWidth = 3 * CHILD1_WIDTH;
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult viewPortWidth not equal to minWidth when minWidth is larger than item width.", bounds.minWidth, result.viewPortWidth);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult contentWidth not equal to item width when minWidth is smaller than item width.", CHILD1_WIDTH, result.contentWidth);
		}

		[Test]
		public function testMeasureViewPortResultWithMinWidthLargerThanChild():void
		{
			var item1:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			this._layout.useVirtualLayout = true;
			this._layout.typicalItem = item1;
			this._layout.useSquareTiles = false;
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.minWidth = 3 * CHILD1_WIDTH;
			var result:Point = this._layout.measureViewPort(1, bounds);
			Assert.assertStrictlyEquals("TiledColumnsLayout measureViewPort x not equal to minWidth when minWidth is larger than item width.", bounds.minWidth, result.x);
		}

		[Test]
		public function testLayoutResultWithMaxWidthLargerThanChild():void
		{
			this._layout.useSquareTiles = false;
			var item1:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			//needs to be enough to require more than one tile
			bounds.maxWidth = 3 * CHILD1_WIDTH;
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult viewPortWidth not equal to item width when maxWidth is larger than item width.", CHILD1_WIDTH, result.viewPortWidth);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult contentWidth not equal to item width when maxWidth is larger than item width.", CHILD1_WIDTH, result.contentWidth);
		}

		[Test]
		public function testMeasureViewPortResultWithMaxWidthLargerThanChild():void
		{
			var item1:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			this._layout.useVirtualLayout = true;
			this._layout.typicalItem = item1;
			this._layout.useSquareTiles = false;
			var bounds:ViewPortBounds = new ViewPortBounds();
			//needs to be enough to require more than one tile
			bounds.maxWidth = 3 * CHILD1_WIDTH;
			var result:Point = this._layout.measureViewPort(1, bounds);
			Assert.assertStrictlyEquals("TiledColumnsLayout measureViewPort x not equal to item width when maxWidth is larger than item width.", CHILD1_WIDTH, result.x);
		}

		[Test]
		public function testLayoutResultWithMaxHeightSmallerThanChild():void
		{
			this._layout.useSquareTiles = false;
			var item1:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.maxHeight = CHILD1_HEIGHT / 3;
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult viewPortHeight not equal to maxHeight when maxHeight is smaller than child height.", bounds.maxHeight, result.viewPortHeight);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult contentHeight not equal to item height when maxHeight is smaller than child height.", CHILD1_HEIGHT, result.contentHeight);
		}

		[Test]
		public function testMeasureViewPortResultWithMaxHeightSmallerThanChild():void
		{
			var item1:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			this._layout.useVirtualLayout = true;
			this._layout.typicalItem = item1;
			this._layout.useSquareTiles = false;
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.maxHeight = CHILD1_HEIGHT / 3;
			var result:Point = this._layout.measureViewPort(1, bounds);
			Assert.assertStrictlyEquals("TiledColumnsLayout measureViewPort y not equal to maxHeight when maxHeight is smaller than child height.", bounds.maxHeight, result.y);
		}

		[Test]
		public function testLayoutResultWithMaxHeightLargerThanChild():void
		{
			this._layout.useSquareTiles = false;
			var item1:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			//needs to be enough to require more than one tile
			bounds.maxHeight = 3 * CHILD1_HEIGHT;
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult viewPortHeight not equal to child height when maxHeight is larger than child height.", CHILD1_HEIGHT, result.viewPortHeight);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult contentHeight not equal to child height when maxHeight is larger than child height.", CHILD1_HEIGHT, result.contentHeight);
		}

		[Test]
		public function testMeasureViewPortResultWithMaxHeightLargerThanChild():void
		{
			var item1:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			this._layout.useVirtualLayout = true;
			this._layout.typicalItem = item1;
			this._layout.useSquareTiles = false;
			var bounds:ViewPortBounds = new ViewPortBounds();
			//needs to be enough to require more than one tile
			bounds.maxHeight = 3 * CHILD1_HEIGHT;
			var result:Point = this._layout.measureViewPort(1, bounds);
			Assert.assertStrictlyEquals("TiledColumnsLayout measureViewPort y not equal to child height when maxHeight is larger than child height.", CHILD1_HEIGHT, result.y);
		}

		[Test]
		public function testLayoutResultWithMaxWidthLargerThanRequestedColumnCountLargerThanItemCount():void
		{
			this._layout.useSquareTiles = false;
			this._layout.requestedColumnCount = 2;
			var item1:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.maxWidth = 3 * CHILD1_WIDTH;
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult viewPortWidth not correct when maxWidth larger than requestedColumnCount and requestedColumnCount larger than item count.", 2 * CHILD1_WIDTH, result.viewPortWidth);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult contentWidth not correct when maxWidth larger than requestedColumnCount and requestedColumnCount larger than item count.", 2 * CHILD1_WIDTH, result.contentWidth);
		}

		[Test]
		public function testMeasureViewPortResultWithMaxWidthLargerThanRequestedColumnCountLargerThanItemCount():void
		{
			var item1:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			this._layout.useVirtualLayout = true;
			this._layout.typicalItem = item1;
			this._layout.useSquareTiles = false;
			this._layout.requestedColumnCount = 2;
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.maxWidth = 3 * CHILD1_WIDTH;
			var result:Point = this._layout.measureViewPort(1, bounds);
			Assert.assertStrictlyEquals("TiledColumnsLayout measureViewPort x not correct when maxWidth larger than requestedColumnCount and requestedColumnCount larger than item count.", 2 * CHILD1_WIDTH, result.x);
		}

		[Test]
		public function testLayoutResultWithMaxHeightLargerThanRequestedRowCountLargerThanItemCount():void
		{
			this._layout.useSquareTiles = false;
			this._layout.requestedRowCount = 2;
			var item1:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.maxHeight = 3 * CHILD1_HEIGHT;
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult viewPortHeight not correct when maxHeight larger than requestedRowCount and requestedRowCount larger than item count.", 2 * CHILD1_HEIGHT, result.viewPortHeight);
			Assert.assertStrictlyEquals("TiledColumnsLayout layout LayoutBoundsResult contentHeight not correct when maxHeight larger than requestedRowCount and requestedRowCount larger than item count.", 2 * CHILD1_HEIGHT, result.contentHeight);
		}

		[Test]
		public function testMeasureViewPortResultWithMaxHeightLargerThanRequestedRowCountLargerThanItemCount():void
		{
			var item1:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			this._layout.useVirtualLayout = true;
			this._layout.typicalItem = item1;
			this._layout.useSquareTiles = false;
			this._layout.requestedRowCount = 2;
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.maxHeight = 3 * CHILD1_HEIGHT;
			var result:Point = this._layout.measureViewPort(1, bounds);
			Assert.assertStrictlyEquals("TiledColumnsLayout measureViewPort y not correct when maxHeight larger than requestedRowCount and requestedRowCount larger than item count.", 2 * CHILD1_HEIGHT, result.y);
		}

		[Test]
		public function testItemXWithExplicitWidthRequestedColumnCountAndHorizontalAlignRight():void
		{
			this._layout.useSquareTiles = false;
			this._layout.requestedColumnCount = 2;
			this._layout.horizontalAlign = TiledColumnsLayout.HORIZONTAL_ALIGN_RIGHT;
			var item1:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitWidth = 3 * CHILD1_WIDTH;
			this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("TiledColumnsLayout x position of first child not correct with explicit width larger than requestedColumnCount.", CHILD1_WIDTH, item1.x);
		}

		[Test]
		public function testItemYWithExplicitHeightRequestedRowCountAndVerticalAlignBottom():void
		{
			this._layout.useSquareTiles = false;
			this._layout.requestedRowCount = 2;
			this._layout.verticalAlign = TiledColumnsLayout.VERTICAL_ALIGN_BOTTOM;
			var item1:Quad = new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff);
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitHeight = 3 * CHILD1_HEIGHT;
			this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("TiledColumnsLayout y position of first child not correct with explicit height larger than requestedRowCount.", CHILD1_HEIGHT, item1.y);
		}
	}
}
