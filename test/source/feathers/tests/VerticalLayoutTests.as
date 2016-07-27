package feathers.tests
{
	import feathers.controls.Label;
	import feathers.controls.LayoutGroup;
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
	}
}
