package feathers.tests
{
	import feathers.controls.Label;
	import feathers.controls.LayoutGroup;
	import feathers.layout.LayoutBoundsResult;
	import feathers.layout.VerticalLayout;
	import feathers.layout.VerticalLayoutData;
	import feathers.layout.ViewPortBounds;

	import org.flexunit.Assert;

	import starling.display.DisplayObject;
	import starling.display.Quad;

	public class VerticalLayoutTests
	{
		private var _layout:VerticalLayout;

		[Before]
		public function prepare():void
		{
			this._layout = new VerticalLayout();
			this._layout.useVirtualLayout = false;
		}

		[After]
		public function cleanup():void
		{
			this._layout = null;
		}

		[Test]
		public function testNoRuntimeErrorOnScrollBeyondStickyHeaderInLayout():void
		{
			this._layout.headerIndices = new <int>[0];
			this._layout.stickyHeader = true;
			var item1:Quad = new Quad(200, 200);
			var item2:Quad = new Quad(200, 200);
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1, item2];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitWidth = 640;
			bounds.explicitHeight = 640;
			bounds.scrollY = 100;
			this._layout.layout(items, bounds);
		}

		[Test]
		public function testNoRuntimeErrorOnScrollBeyondStickyHeaderInGetVisibleIndicesAtScrollPosition():void
		{
			this._layout.useVirtualLayout = true;
			this._layout.headerIndices = new <int>[0];
			this._layout.stickyHeader = true;
			this._layout.hasVariableItemDimensions = true;
			var item1:Quad = new Quad(200, 200);
			this._layout.typicalItem = item1;
			this._layout.getVisibleIndicesAtScrollPosition(0, 210, 640, 640, 2);
		}

		[Test]
		public function testVisibleIndicesOnScrollBeyondStickyHeader():void
		{
			this._layout.useVirtualLayout = true;
			this._layout.headerIndices = new <int>[0, 20];
			this._layout.stickyHeader = true;
			this._layout.hasVariableItemDimensions = true;
			var item1:Quad = new Quad(200, 200);
			this._layout.typicalItem = item1;
			var result:Vector.<int> = this._layout.getVisibleIndicesAtScrollPosition(0, 810, 640, 640, 30);
			Assert.assertTrue("getVisibleIndicesAtScrollPosition() does not return correct sticky header", result.indexOf(0) === 0);
			Assert.assertTrue("getVisibleIndicesAtScrollPosition() returns incorrect sticky header", result.indexOf(20) === -1);
		}

		[Test]
		public function testPercentHeightWithOneItem():void
		{
			var viewPortHeight:Number = 640;
			var item1:LayoutGroup = new LayoutGroup();
			var layoutData1:VerticalLayoutData = new VerticalLayoutData(NaN, 50);
			item1.layoutData = layoutData1;
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitWidth = 640;
			bounds.explicitHeight = viewPortHeight;
			this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("VerticalLayoutData with percentHeight results in incorrect item height", viewPortHeight / 2, item1.height);
		}

		[Test]
		public function testPercentHeightGreaterThan100WithOneItem():void
		{
			var viewPortHeight:Number = 640;
			var item1:LayoutGroup = new LayoutGroup();
			var layoutData1:VerticalLayoutData = new VerticalLayoutData(NaN, 200);
			item1.layoutData = layoutData1;
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitWidth = 640;
			bounds.explicitHeight = viewPortHeight;
			this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("VerticalLayoutData with percentHeight > 100 not clamped to 100", viewPortHeight, item1.height);
		}

		[Test]
		public function testPercentHeightLessThan0WithOneItem():void
		{
			var viewPortHeight:Number = 640;
			var item1:LayoutGroup = new LayoutGroup();
			var layoutData1:VerticalLayoutData = new VerticalLayoutData(NaN, -50);
			item1.layoutData = layoutData1;
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitWidth = 640;
			bounds.explicitHeight = viewPortHeight;
			this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("VerticalLayoutData with percentHeight < 0 not clamped to 0", 0, item1.height);
		}

		[Test]
		public function testPercentHeightWithTwoItems():void
		{
			var viewPortHeight:Number = 640;
			var item1:LayoutGroup = new LayoutGroup();
			var item1Percent:Number = 50;
			var layoutData1:VerticalLayoutData = new VerticalLayoutData(NaN, item1Percent);
			item1.layoutData = layoutData1;
			var item2:LayoutGroup = new LayoutGroup();
			var item2Percent:Number = 25;
			var layoutData2:VerticalLayoutData = new VerticalLayoutData(NaN, item2Percent);
			item2.layoutData = layoutData2;
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1, item2];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitWidth = 640;
			bounds.explicitHeight = viewPortHeight;
			this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("VerticalLayoutData with percentHeight results in incorrect item height for first item (of 2)", viewPortHeight / (100 / item1Percent), item1.height);
			Assert.assertStrictlyEquals("VerticalLayoutData with percentHeight results in incorrect item height for second item (of 2)", viewPortHeight / (100 / item2Percent), item2.height);
		}

		[Test]
		public function testPercentHeightGreaterThan100WithTwoItems():void
		{
			var viewPortHeight:Number = 640;
			var item1:LayoutGroup = new LayoutGroup();
			var item1Percent:Number = 100;
			var layoutData1:VerticalLayoutData = new VerticalLayoutData(NaN, item1Percent);
			item1.layoutData = layoutData1;
			var item2:LayoutGroup = new LayoutGroup();
			var item2Percent:Number = 150;
			var layoutData2:VerticalLayoutData = new VerticalLayoutData(NaN, item2Percent);
			item2.layoutData = layoutData2;
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1, item2];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitWidth = 640;
			bounds.explicitHeight = viewPortHeight;
			this._layout.layout(items, bounds);
			var totalPercent:Number = item1Percent + item2Percent;
			Assert.assertStrictlyEquals("VerticalLayoutData with percentHeight > 100 results in incorrect item height for first item (of 2)", viewPortHeight / (totalPercent / item1Percent), item1.height);
			Assert.assertStrictlyEquals("VerticalLayoutData with percentHeight > 100 results in incorrect item height for second item (of 2)", viewPortHeight / (totalPercent / item2Percent), item2.height);
		}

		[Test]
		public function testPercentWidth():void
		{
			var viewPortWidth:Number = 640;
			var item1:LayoutGroup = new LayoutGroup();
			var layoutData1:VerticalLayoutData = new VerticalLayoutData(50);
			item1.layoutData = layoutData1;
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitWidth = viewPortWidth;
			bounds.explicitHeight = 640;
			this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("VerticalLayoutData with percentWidth results in incorrect item width", viewPortWidth / 2, item1.width);
		}

		[Test]
		public function testPercentWidthGreaterThan100():void
		{
			var viewPortWidth:Number = 640;
			var item1:LayoutGroup = new LayoutGroup();
			var layoutData1:VerticalLayoutData = new VerticalLayoutData(150);
			item1.layoutData = layoutData1;
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitWidth = viewPortWidth;
			bounds.explicitHeight = 640;
			this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("VerticalLayoutData with percentWidth > 100 does not clamp to 100", viewPortWidth, item1.width);
		}

		[Test]
		public function testPercentWidthLessThan0():void
		{
			var viewPortWidth:Number = 640;
			var item1:LayoutGroup = new LayoutGroup();
			var layoutData1:VerticalLayoutData = new VerticalLayoutData(-50);
			item1.layoutData = layoutData1;
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitWidth = viewPortWidth;
			bounds.explicitHeight = 640;
			this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("VerticalLayoutData with percentWidth < 0 does not clamp to 0", 0, item1.width);
		}

		[Test]
		public function testPercentWidthWithWrappingLabelAndMaxWidth():void
		{
			var viewPortMaxWidth:Number = 100;
			var item1:Label = new Label();
			item1.text = "I am the very model of a modern Major General";
			item1.wordWrap = true;
			item1.validate();
			var unwrappedWidth:Number = item1.width;
			var unwrappedHeight:Number = item1.height;
			var layoutData1:VerticalLayoutData = new VerticalLayoutData();
			layoutData1.percentWidth = 100;
			item1.layoutData = layoutData1;
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.maxWidth = viewPortMaxWidth;
			this._layout.layout(items, bounds);
			//since we're setting maxWidth, the width may actually be smaller
			Assert.assertTrue("VerticalLayoutData with percentWidth with a wrapping Label results in incorrect width",
				viewPortMaxWidth >= item1.width);
			//we're only checking that it has more than one line
			Assert.assertTrue("VerticalLayoutData with percentWidth on a wrapping Label results in height that is too small",
				unwrappedHeight < item1.height);
		}

		[Test]
		public function testPercentWidthWithExplicitMinWidth():void
		{
			var viewPortWidth:Number = 640;
			var item1:LayoutGroup = new LayoutGroup();
			item1.minWidth = 400;
			var layoutData1:VerticalLayoutData = new VerticalLayoutData(50, NaN);
			item1.layoutData = layoutData1;
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitWidth = viewPortWidth;
			bounds.explicitHeight = 640;
			this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("VerticalLayoutData with percentWidth and larger item explicitMinWidth results in incorrect item width",
				400, item1.width);
		}

		[Test]
		public function testPercentHeightWithExplicitMinHeight():void
		{
			var viewPortHeight:Number = 640;
			var item1:LayoutGroup = new LayoutGroup();
			item1.minHeight = 400;
			var layoutData1:VerticalLayoutData = new VerticalLayoutData(NaN, 50);
			item1.layoutData = layoutData1;
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitWidth = 640;
			bounds.explicitHeight = viewPortHeight;
			this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("VerticalLayoutData with percentHeight and larger item explicitMinHeight results in incorrect item height",
				400, item1.height);
		}

		[Test]
		public function testPercentWidthWithExplicitMaxWidth():void
		{
			var viewPortWidth:Number = 640;
			var item1:LayoutGroup = new LayoutGroup();
			item1.maxWidth = 250;
			var layoutData1:VerticalLayoutData = new VerticalLayoutData(50, NaN);
			item1.layoutData = layoutData1;
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitWidth = viewPortWidth;
			bounds.explicitHeight = 640;
			this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("VerticalLayoutData with percentWidth and smaller item explicitMaxWidth results in incorrect item width",
				250, item1.width);
		}

		[Test]
		public function testDistributeHeights():void
		{
			this._layout.distributeHeights = true;
			var viewPortHeight:Number = 640;
			var item1:LayoutGroup = new LayoutGroup();
			var item2:LayoutGroup = new LayoutGroup();
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1, item2];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitWidth = 640;
			bounds.explicitHeight = viewPortHeight;
			this._layout.layout(items, bounds);
			var itemHeight:Number = viewPortHeight / items.length;
			Assert.assertStrictlyEquals("VerticalLayout with distributeHeights results in wrong item height",
				itemHeight, item1.height);
			Assert.assertStrictlyEquals("VerticalLayout with distributeHeights results in wrong item height",
				itemHeight, item2.height);
		}

		[Test]
		public function testDistributeHeightsWithIncludeInLayoutFalse():void
		{
			this._layout.distributeHeights = true;
			var viewPortHeight:Number = 640;
			var item1:LayoutGroup = new LayoutGroup();
			var item2:LayoutGroup = new LayoutGroup();
			item2.includeInLayout = false;
			var item3:LayoutGroup = new LayoutGroup();
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1, item2, item3];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitWidth = 640;
			bounds.explicitHeight = viewPortHeight;
			this._layout.layout(items, bounds);
			var itemHeight:Number = viewPortHeight / (items.length - 1);
			Assert.assertStrictlyEquals("VerticalLayout with distributeHeights and an item with includeInLayout set to false results in wrong item height",
				itemHeight, item1.height);
			Assert.assertStrictlyEquals("VerticalLayout with distributeHeights and an item with includeInLayout set to false results in wrong item height",
				0, item2.height);
			Assert.assertStrictlyEquals("VerticalLayout with distributeHeights and an item with includeInLayout set to false results in wrong item height",
				itemHeight, item3.height);
		}

		[Test]
		public function testDistributeHeightsWithLargerItemHeights():void
		{
			this._layout.distributeHeights = true;
			var viewPortHeight:Number = 640;
			var item1:LayoutGroup = new LayoutGroup();
			item1.height = 720;
			var item2:LayoutGroup = new LayoutGroup();
			item2.height = 800;
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1, item2];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitWidth = 640;
			bounds.explicitHeight = viewPortHeight;
			this._layout.layout(items, bounds);
			var itemHeight:Number = viewPortHeight / items.length;
			Assert.assertStrictlyEquals("VerticalLayout with distributeHeights with larger item heights results in wrong item height",
				itemHeight, item1.height);
			Assert.assertStrictlyEquals("VerticalLayout with distributeHeights with larger item heights results in wrong item height",
				itemHeight, item2.height);
		}

		[Test]
		public function testDistributeHeightsWithoutExplicitHeight():void
		{
			this._layout.distributeHeights = true;
			var item1:LayoutGroup = new LayoutGroup();
			item1.height = 480;
			var item2:LayoutGroup = new LayoutGroup();
			item2.height = 640;
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1, item2];
			this._layout.layout(items, new ViewPortBounds());
			var largerHeight:Number = Math.max(item1.height, item2.height);
			var itemHeight:Number = largerHeight * items.length;
			Assert.assertStrictlyEquals("VerticalLayout with distributeHeights and no explicit height results in wrong item height",
				itemHeight, item1.height);
			Assert.assertStrictlyEquals("VerticalLayout with distributeHeights and no explicit height results in wrong item height",
				itemHeight, item2.height);
		}

		[Test]
		public function testDistributeHeightsWithUseVirtualLayout():void
		{
			this._layout.distributeHeights = true;
			this._layout.useVirtualLayout = true;
			var viewPortHeight:Number = 640;
			var item1:LayoutGroup = new LayoutGroup();
			var item2:LayoutGroup = new LayoutGroup();
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1, item2];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitWidth = 640;
			bounds.explicitHeight = viewPortHeight;
			this._layout.layout(items, bounds);
			var itemHeight:Number = viewPortHeight / items.length;
			Assert.assertStrictlyEquals("VerticalLayout with distributeHeights and useVirtualLayout results in wrong item height",
				itemHeight, item1.height);
			Assert.assertStrictlyEquals("VerticalLayout with distributeHeights and useVirtualLayout results in wrong item height",
				itemHeight, item2.height);
		}

		[Test]
		public function testSmallerMaxRowCount():void
		{
			this._layout.maxRowCount = 2;
			var item1:LayoutGroup = new LayoutGroup();
			item1.setSize(100, 100);
			var item2:LayoutGroup = new LayoutGroup();
			item2.setSize(100, 100);
			var item3:LayoutGroup = new LayoutGroup();
			item3.setSize(100, 100);
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1, item2, item3];
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("VerticalLayout with smaller maxRowCount results in wrong view port height",
				200, result.viewPortHeight);
			Assert.assertStrictlyEquals("VerticalLayout with smaller maxRowCount results in wrong content height",
				300, result.contentHeight);
		}

		[Test]
		public function testSmallerMaxRowCountAndUseVirtualLayout():void
		{
			this._layout.maxRowCount = 2;
			this._layout.useVirtualLayout = true;
			var item1:LayoutGroup = new LayoutGroup();
			item1.setSize(100, 100);
			var item2:LayoutGroup = new LayoutGroup();
			item2.setSize(100, 100);
			var item3:LayoutGroup = new LayoutGroup();
			item3.setSize(100, 100);
			this._layout.typicalItem = item1;
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1, item2, item3];
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("VerticalLayout with smaller maxRowCount and useVirtualLayout results in wrong view port height",
				200, result.viewPortHeight);
			Assert.assertStrictlyEquals("VerticalLayout with smaller maxRowCount and useVirtualLayout results in wrong content height",
				300, result.contentHeight);
		}

		[Test]
		public function testLargerMaxRowCount():void
		{
			this._layout.maxRowCount = 4;
			var item1:LayoutGroup = new LayoutGroup();
			item1.setSize(100, 100);
			var item2:LayoutGroup = new LayoutGroup();
			item2.setSize(100, 100);
			var item3:LayoutGroup = new LayoutGroup();
			item3.setSize(100, 100);
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1, item2, item3];
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("VerticalLayout with larger maxRowCount results in wrong view port height",
				300, result.viewPortHeight);
			Assert.assertStrictlyEquals("VerticalLayout with larger maxRowCount results in wrong content height",
				300, result.contentHeight);
		}

		[Test]
		public function testLargerMaxRowCountAndUseVirtualLayout():void
		{
			this._layout.maxRowCount = 4;
			this._layout.useVirtualLayout = true;
			var item1:LayoutGroup = new LayoutGroup();
			item1.setSize(100, 100);
			var item2:LayoutGroup = new LayoutGroup();
			item2.setSize(100, 100);
			var item3:LayoutGroup = new LayoutGroup();
			item3.setSize(100, 100);
			this._layout.typicalItem = item1;
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1, item2, item3];
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("VerticalLayout with larger maxRowCount and useVirtualLayout results in wrong view port height",
				300, result.viewPortHeight);
			Assert.assertStrictlyEquals("VerticalLayout with larger maxRowCount and useVirtualLayout results in wrong content height",
				300, result.contentHeight);
		}

		[Test]
		public function testRequestedRowCountWithZeroItems():void
		{
			this._layout.requestedRowCount = 3;
			var items:Vector.<DisplayObject> = new <DisplayObject>[];
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("VerticalLayout with requestedRowCount and zero items results in wrong view port height",
				0, result.viewPortHeight);
			Assert.assertStrictlyEquals("VerticalLayout with requestedRowCount and zero items results in wrong content height",
				0, result.contentHeight);
		}

		[Test]
		public function testSmallerRequestedRowCount():void
		{
			this._layout.requestedRowCount = 2;
			var item1:LayoutGroup = new LayoutGroup();
			item1.setSize(100, 100);
			var item2:LayoutGroup = new LayoutGroup();
			item2.setSize(100, 100);
			var item3:LayoutGroup = new LayoutGroup();
			item3.setSize(100, 100);
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1, item2, item3];
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("VerticalLayout with smaller requestedRowCount results in wrong view port height",
				200, result.viewPortHeight);
			Assert.assertStrictlyEquals("VerticalLayout with smaller requestedRowCount results in wrong content height",
				300, result.contentHeight);
		}

		[Test]
		public function testSmallerRequestedRowCountAndUseVirtualLayout():void
		{
			this._layout.requestedRowCount = 2;
			this._layout.useVirtualLayout = true;
			var item1:LayoutGroup = new LayoutGroup();
			item1.setSize(100, 100);
			var item2:LayoutGroup = new LayoutGroup();
			item2.setSize(100, 100);
			var item3:LayoutGroup = new LayoutGroup();
			item3.setSize(100, 100);
			this._layout.typicalItem = item1;
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1, item2, item3];
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("VerticalLayout with smaller requestedRowCount and useVirtualLayout results in wrong view port height",
				200, result.viewPortHeight);
			Assert.assertStrictlyEquals("VerticalLayout with smaller requestedRowCount and useVirtualLayout results in wrong content height",
				300, result.contentHeight);
		}

		[Test]
		public function testLargerRequestedRowCount():void
		{
			this._layout.requestedRowCount = 4;
			var item1:LayoutGroup = new LayoutGroup();
			item1.setSize(100, 100);
			var item2:LayoutGroup = new LayoutGroup();
			item2.setSize(100, 100);
			var item3:LayoutGroup = new LayoutGroup();
			item3.setSize(100, 100);
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1, item2, item3];
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("VerticalLayout with larger requestedRowCount results in wrong view port height",
				400, result.viewPortHeight);
			Assert.assertStrictlyEquals("VerticalLayout with larger requestedRowCount results in wrong content height",
				300, result.contentHeight);
		}

		[Test]
		public function testLargerRequestedRowCountAndUseVirtualLayout():void
		{
			this._layout.requestedRowCount = 4;
			this._layout.useVirtualLayout = true;
			var item1:LayoutGroup = new LayoutGroup();
			item1.setSize(100, 100);
			var item2:LayoutGroup = new LayoutGroup();
			item2.setSize(100, 100);
			var item3:LayoutGroup = new LayoutGroup();
			item3.setSize(100, 100);
			this._layout.typicalItem = item1;
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1, item2, item3];
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("VerticalLayout with larger requestedRowCount and useVirtualLayout results in wrong view port height",
				400, result.viewPortHeight);
			Assert.assertStrictlyEquals("VerticalLayout with larger requestedRowCount and useVirtualLayout results in wrong content height",
				300, result.contentHeight);
		}

		[Test]
		public function testChildWithCalculatedMinWidthAndPercentWidth():void
		{
			var item1:LayoutGroup = new LayoutGroup();
			item1.layoutData = new VerticalLayoutData(100, 100);
			var child:Quad = new Quad(100, 100, 0xff00ff);
			item1.addChild(child);
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("VerticalLayout without explicit view port width and child with percentWidth and calculated minWidth results in wrong view port width",
				100, result.viewPortWidth);
		}

		[Test]
		public function testChildWithExplicitMinWidthAndPercentWidth():void
		{
			var item1:LayoutGroup = new LayoutGroup();
			item1.layoutData = new VerticalLayoutData(100, 100);
			var child:Quad = new Quad(100, 100, 0xff00ff);
			item1.minWidth = 200;
			item1.addChild(child);
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("VerticalLayout without explicit view port width and child with percentWidth and explicit minWidth results in wrong view port width",
				200, result.viewPortWidth);
			Assert.assertStrictlyEquals("VerticalLayout without explicit view port width and child with percentWidth and explicit minWidth results in wrong child width",
				200, item1.width);
		}

		[Test]
		public function testChildWithCalculatedMinWidthAndPercentWidthWithExplicitWidth():void
		{
			var item1:LayoutGroup = new LayoutGroup();
			item1.layoutData = new VerticalLayoutData(100, 100);
			var child:Quad = new Quad(100, 100, 0xff00ff);
			item1.addChild(child);
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitWidth = 50;
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("VerticalLayout with explicit view port width and child with percentWidth and calculated minWidth results in wrong view port width",
				50, result.viewPortWidth);
			Assert.assertStrictlyEquals("VerticalLayout with explicit view port width and child with percentWidth and calculated minWidth results in wrong child width",
				50, item1.width);
		}


		[Test]
		public function testChildWithCalculatedMinWidthAndPercentWidthWithViewPortMinWidth():void
		{
			var item1:LayoutGroup = new LayoutGroup();
			item1.layoutData = new VerticalLayoutData(100, 100);
			var child:Quad = new Quad(100, 100, 0xff00ff);
			item1.addChild(child);
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.minWidth = 10;
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("VerticalLayout with explicit view port minWidth and child with percentWidth and calculated minWidth results in wrong view port width",
				100, result.viewPortWidth);
			Assert.assertStrictlyEquals("VerticalLayout with explicit view port minWidth and child with percentWidth and calculated minWidth results in wrong child width",
				100, item1.width);
		}

		[Test]
		public function testChildWithCalculatedWidthAndSmallerCalculatedMinWidthAndPercentWidth():void
		{
			var item1:LayoutGroup = new LayoutGroup();
			item1.layoutData = new VerticalLayoutData(100, 100);
			var child:LayoutGroup = new LayoutGroup();
			child.width = 100;
			child.height = 100;
			child.minWidth = 50;
			child.minHeight = 50;
			item1.backgroundSkin = child;
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("VerticalLayout without explicit view port width and child with percentWidth, calculated width, and calculated minWidth results in wrong view port width",
				100, result.viewPortWidth);
			Assert.assertStrictlyEquals("VerticalLayout without explicit view port width and child with percentWidth, calculated width, and calculated minWidth results in wrong child width",
				100, item1.width);
		}
	}
}
