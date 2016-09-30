package feathers.tests
{
	import feathers.controls.LayoutGroup;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.HorizontalLayoutData;
	import feathers.layout.LayoutBoundsResult;
	import feathers.layout.ViewPortBounds;

	import org.flexunit.Assert;

	import starling.display.DisplayObject;
	import starling.display.Quad;

	public class HorizontalLayoutTests
	{
		private var _layout:HorizontalLayout;

		[Before]
		public function prepare():void
		{
			this._layout = new HorizontalLayout();
			this._layout.useVirtualLayout = false;
		}

		[After]
		public function cleanup():void
		{
			this._layout = null;
		}

		[Test]
		public function testPercentWidthWithOneItem():void
		{
			var viewPortWidth:Number = 640;
			var item1:LayoutGroup = new LayoutGroup();
			var layoutData1:HorizontalLayoutData = new HorizontalLayoutData(50);
			item1.layoutData = layoutData1;
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitWidth = viewPortWidth;
			bounds.explicitHeight = 640;
			this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("HorizontalLayoutData with percentWidth results in incorrect item width", viewPortWidth / 2, item1.width);
		}

		[Test]
		public function testPercentWidthGreaterThan100WithOneItem():void
		{
			var viewPortWidth:Number = 640;
			var item1:LayoutGroup = new LayoutGroup();
			var layoutData1:HorizontalLayoutData = new HorizontalLayoutData(200);
			item1.layoutData = layoutData1;
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitWidth = viewPortWidth;
			bounds.explicitHeight = 640;
			this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("HorizontalLayoutData with percentWidth > 100 not clamped to 100", viewPortWidth, item1.width);
		}

		[Test]
		public function testPercentWidthLessThan0WithOneItem():void
		{
			var viewPortWidth:Number = 640;
			var item1:LayoutGroup = new LayoutGroup();
			var layoutData1:HorizontalLayoutData = new HorizontalLayoutData(-50);
			item1.layoutData = layoutData1;
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitWidth = viewPortWidth;
			bounds.explicitHeight = 640;
			this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("HorizontalLayoutData with percentWidth < 0 not clamped to 0", 0, item1.width);
		}

		[Test]
		public function testPercentWidthWithTwoItems():void
		{
			var viewPortWidth:Number = 640;
			var item1:LayoutGroup = new LayoutGroup();
			var item1Percent:Number = 50;
			var layoutData1:HorizontalLayoutData = new HorizontalLayoutData(item1Percent);
			item1.layoutData = layoutData1;
			var item2:LayoutGroup = new LayoutGroup();
			var item2Percent:Number = 25;
			var layoutData2:HorizontalLayoutData = new HorizontalLayoutData(item2Percent);
			item2.layoutData = layoutData2;
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1, item2];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitWidth = viewPortWidth;
			bounds.explicitHeight = 640;
			this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("HorizontalLayoutData with percentWidth results in incorrect item width for first item (of 2)", viewPortWidth / (100 / item1Percent), item1.width);
			Assert.assertStrictlyEquals("HorizontalLayoutData with percentWidth results in incorrect item width for second item (of 2)", viewPortWidth / (100 / item2Percent), item2.width);
		}

		[Test]
		public function testPercentWidthGreaterThan100WithTwoItems():void
		{
			var viewPortWidth:Number = 640;
			var item1:LayoutGroup = new LayoutGroup();
			var item1Percent:Number = 100;
			var layoutData1:HorizontalLayoutData = new HorizontalLayoutData(item1Percent);
			item1.layoutData = layoutData1;
			var item2:LayoutGroup = new LayoutGroup();
			var item2Percent:Number = 150;
			var layoutData2:HorizontalLayoutData = new HorizontalLayoutData(item2Percent);
			item2.layoutData = layoutData2;
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1, item2];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitWidth = viewPortWidth;
			bounds.explicitHeight = 640;
			this._layout.layout(items, bounds);
			var totalPercent:Number = item1Percent + item2Percent;
			Assert.assertStrictlyEquals("HorizontalLayoutData with percentWidth > 100 results in incorrect item width for first item (of 2)", viewPortWidth / (totalPercent / item1Percent), item1.width);
			Assert.assertStrictlyEquals("HorizontalLayoutData with percentWidth > 100 results in incorrect item width for second item (of 2)", viewPortWidth / (totalPercent / item2Percent), item2.width);
		}

		[Test]
		public function testPercentHeight():void
		{
			var viewPortHeight:Number = 640;
			var item1:LayoutGroup = new LayoutGroup();
			var layoutData1:HorizontalLayoutData = new HorizontalLayoutData(NaN, 50);
			item1.layoutData = layoutData1;
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitWidth = 640;
			bounds.explicitHeight = viewPortHeight;
			this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("HorizontalLayoutData with percentHeight results in incorrect item height", viewPortHeight / 2, item1.height);
		}

		[Test]
		public function testPercentHeightGreaterThan100():void
		{
			var viewPortHeight:Number = 640;
			var item1:LayoutGroup = new LayoutGroup();
			var layoutData1:HorizontalLayoutData = new HorizontalLayoutData(NaN, 150);
			item1.layoutData = layoutData1;
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitWidth = 640;
			bounds.explicitHeight = viewPortHeight;
			this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("HorizontalLayoutData with percentHeight > 100 does not clamp to 100", viewPortHeight, item1.height);
		}

		[Test]
		public function testPercentHeightLessThan0():void
		{
			var viewPortHeight:Number = 640;
			var item1:LayoutGroup = new LayoutGroup();
			var layoutData1:HorizontalLayoutData = new HorizontalLayoutData(NaN, -50);
			item1.layoutData = layoutData1;
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitWidth = 640;
			bounds.explicitHeight = viewPortHeight;
			this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("HorizontalLayoutData with percentHeight < 0 does not clamp to 0", 0, item1.height);
		}

		[Test]
		public function testDistributeWidths():void
		{
			this._layout.distributeWidths = true;
			var viewPortWidth:Number = 640;
			var item1:LayoutGroup = new LayoutGroup();
			var item2:LayoutGroup = new LayoutGroup();
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1, item2];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitWidth = viewPortWidth;
			bounds.explicitHeight = 640;
			this._layout.layout(items, bounds);
			var itemWidth:Number = viewPortWidth / items.length;
			Assert.assertStrictlyEquals("HorizontalLayout with distributeWidths results in wrong item width",
				itemWidth, item1.width);
			Assert.assertStrictlyEquals("HorizontalLayout with distributeWidths results in wrong item width",
				itemWidth, item2.width);
		}

		[Test]
		public function testDistributeWidthsWithLargerItemWidths():void
		{
			this._layout.distributeWidths = true;
			var viewPortWidth:Number = 640;
			var item1:LayoutGroup = new LayoutGroup();
			item1.width = 720;
			var item2:LayoutGroup = new LayoutGroup();
			item2.width = 820;
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1, item2];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitWidth = viewPortWidth;
			bounds.explicitHeight = 640;
			this._layout.layout(items, bounds);
			var itemWidth:Number = viewPortWidth / items.length;
			Assert.assertStrictlyEquals("HorizontalLayout with distributeWidths and larger item width results in wrong item width",
				itemWidth, item1.width);
			Assert.assertStrictlyEquals("HorizontalLayout with distributeWidths and larger item width results in wrong item width",
				itemWidth, item2.width);
		}

		[Test]
		public function testDistributeWidthsWithoutExplicitWidth():void
		{
			this._layout.distributeWidths = true;
			var item1:LayoutGroup = new LayoutGroup();
			item1.width = 480;
			var item2:LayoutGroup = new LayoutGroup();
			item2.width = 640;
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1, item2];
			this._layout.layout(items, new ViewPortBounds());
			var largerWidth:Number = Math.max(item1.width, item2.width);
			var itemWidth:Number = largerWidth * items.length;
			Assert.assertStrictlyEquals("HorizontalLayout with distributeWidths and no explicit width results in wrong item width",
				itemWidth, item1.width);
			Assert.assertStrictlyEquals("HorizontalLayout with distributeWidths and no explicit width results in wrong item width",
				itemWidth, item2.width);
		}

		[Test]
		public function testDistributeWidthsWithUseVirtualLayout():void
		{
			this._layout.distributeWidths = true;
			this._layout.useVirtualLayout = true;
			var viewPortWidth:Number = 640;
			var item1:LayoutGroup = new LayoutGroup();
			var item2:LayoutGroup = new LayoutGroup();
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1, item2];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitWidth = viewPortWidth;
			bounds.explicitHeight = 640;
			this._layout.layout(items, bounds);
			var itemWidth:Number = viewPortWidth / items.length;
			Assert.assertStrictlyEquals("HorizontalLayout with distributeWidths and useVirtualLayout results in wrong item width",
				itemWidth, item1.width);
			Assert.assertStrictlyEquals("HorizontalLayout with distributeWidths and useVirtualLayout results in wrong item width",
				itemWidth, item2.width);
		}

		[Test]
		public function testSmallerMaxColumnCount():void
		{
			this._layout.maxColumnCount = 2;
			var item1:LayoutGroup = new LayoutGroup();
			item1.setSize(100, 100);
			var item2:LayoutGroup = new LayoutGroup();
			item2.setSize(100, 100);
			var item3:LayoutGroup = new LayoutGroup();
			item3.setSize(100, 100);
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1, item2, item3];
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("HorizontalLayout with smaller maxColumnCount results in wrong view port width",
				200, result.viewPortWidth);
			Assert.assertStrictlyEquals("HorizontalLayout with smaller maxColumnCount results in wrong content width",
				300, result.contentWidth);
		}

		[Test]
		public function testSmallerMaxColumnCountAndUseVirtualLayout():void
		{
			this._layout.maxColumnCount = 2;
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
			Assert.assertStrictlyEquals("HorizontalLayout with smaller maxColumnCount and useVirtualLayout results in wrong view port width",
				200, result.viewPortWidth);
			Assert.assertStrictlyEquals("HorizontalLayout with smaller maxColumnCount and useVirtualLayout results in wrong content width",
				300, result.contentWidth);
		}

		[Test]
		public function testLargerMaxColumnCount():void
		{
			this._layout.maxColumnCount = 4;
			var item1:LayoutGroup = new LayoutGroup();
			item1.setSize(100, 100);
			var item2:LayoutGroup = new LayoutGroup();
			item2.setSize(100, 100);
			var item3:LayoutGroup = new LayoutGroup();
			item3.setSize(100, 100);
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1, item2, item3];
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("HorizontalLayout with larger maxColumnCount results in wrong view port width",
				300, result.viewPortWidth);
			Assert.assertStrictlyEquals("HorizontalLayout with larger maxColumnCount results in wrong content width",
				300, result.contentWidth);
		}

		[Test]
		public function testLargerMaxColumnCountAndUseVirtualLayout():void
		{
			this._layout.maxColumnCount = 4;
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
			Assert.assertStrictlyEquals("HorizontalLayout with larger maxColumnCount and useVirtualLayout results in wrong view port width",
				300, result.viewPortWidth);
			Assert.assertStrictlyEquals("HorizontalLayout with larger maxColumnCount and useVirtualLayout results in wrong content width",
				300, result.contentWidth);
		}

		[Test]
		public function testSmallerRequestedColumnCount():void
		{
			this._layout.requestedColumnCount = 2;
			var item1:LayoutGroup = new LayoutGroup();
			item1.setSize(100, 100);
			var item2:LayoutGroup = new LayoutGroup();
			item2.setSize(100, 100);
			var item3:LayoutGroup = new LayoutGroup();
			item3.setSize(100, 100);
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1, item2, item3];
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("HorizontalLayout with smaller requestedColumnCount results in wrong view port width",
				200, result.viewPortWidth);
			Assert.assertStrictlyEquals("HorizontalLayout with smaller requestedColumnCount results in wrong content width",
				300, result.contentWidth);
		}

		[Test]
		public function testSmallerRequestedColumnCountAndUseVirtualLayout():void
		{
			this._layout.requestedColumnCount = 2;
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
			Assert.assertStrictlyEquals("HorizontalLayout with smaller requestedColumnCount and useVirtualLayout results in wrong view port width",
				200, result.viewPortWidth);
			Assert.assertStrictlyEquals("HorizontalLayout with smaller requestedColumnCount and useVirtualLayout results in wrong content width",
				300, result.contentWidth);
		}

		[Test]
		public function testLargerRequestedColumnCount():void
		{
			this._layout.requestedColumnCount = 4;
			var item1:LayoutGroup = new LayoutGroup();
			item1.setSize(100, 100);
			var item2:LayoutGroup = new LayoutGroup();
			item2.setSize(100, 100);
			var item3:LayoutGroup = new LayoutGroup();
			item3.setSize(100, 100);
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1, item2, item3];
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("HorizontalLayout with larger requestedColumnCount results in wrong view port width",
				400, result.viewPortWidth);
			Assert.assertStrictlyEquals("HorizontalLayout with larger requestedColumnCount results in wrong content width",
				300, result.contentWidth);
		}

		[Test]
		public function testLargerRequestedColumnCountAndUseVirtualLayout():void
		{
			this._layout.requestedColumnCount = 4;
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
			Assert.assertStrictlyEquals("HorizontalLayout with larger requestedColumnCount and useVirtualLayout results in wrong view port width",
				400, result.viewPortWidth);
			Assert.assertStrictlyEquals("HorizontalLayout with larger requestedColumnCount and useVirtualLayout results in wrong content width",
				300, result.contentWidth);
		}

		[Test]
		public function testChildWithCalculatedMinHeightAndPercentHeight():void
		{
			var item1:LayoutGroup = new LayoutGroup();
			item1.layoutData = new HorizontalLayoutData(100, 100);
			var child:Quad = new Quad(100, 100, 0xff00ff);
			item1.addChild(child);
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("HorizontalLayout without explicit view port height and child with percentHeight and calculated minHeight results in wrong view port height",
				100, result.viewPortHeight);
		}

		[Test]
		public function testChildWithExplicitMinHeightAndPercentHeight():void
		{
			var item1:LayoutGroup = new LayoutGroup();
			item1.layoutData = new HorizontalLayoutData(100, 100);
			var child:Quad = new Quad(100, 100, 0xff00ff);
			item1.minHeight = 200;
			item1.addChild(child);
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("HorizontalLayout without explicit view port height and child with percentHeight and explicit minHeight results in wrong view port height",
				200, result.viewPortHeight);
			Assert.assertStrictlyEquals("HorizontalLayout without explicit view port height and child with percentHeight and explicit minHeight results in wrong child height",
				200, item1.height);
		}

		[Test]
		public function testChildWithCalculatedMinHeightAndPercentHeightWithExplicitHeight():void
		{
			var item1:LayoutGroup = new LayoutGroup();
			item1.layoutData = new HorizontalLayoutData(100, 100);
			var child:Quad = new Quad(100, 100, 0xff00ff);
			item1.addChild(child);
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitHeight = 50;
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("HorizontalLayout with explicit view port height and child with percentHeight and calculated minHeight results in wrong view port height",
				50, result.viewPortHeight);
			Assert.assertStrictlyEquals("HorizontalLayout with explicit view port height and child with percentHeight and calculated minHeight results in wrong child height",
				50, item1.height);
		}


		[Test]
		public function testChildWithCalculatedMinHeightAndPercentHeightWithViewPortMinHeight():void
		{
			var item1:LayoutGroup = new LayoutGroup();
			item1.layoutData = new HorizontalLayoutData(100, 100);
			var child:Quad = new Quad(100, 100, 0xff00ff);
			item1.addChild(child);
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.minHeight = 10;
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("HorizontalLayout with explicit view port minHeight and child with percentHeight and calculated minHeight results in wrong view port height",
				100, result.viewPortHeight);
			Assert.assertStrictlyEquals("HorizontalLayout with explicit view port minHeight and child with percentHeight and calculated minHeight results in wrong child height",
				100, item1.height);
		}

		[Test]
		public function testChildWithCalculatedHeightAndSmallerCalculatedMinHeightAndPercentHeight():void
		{
			var item1:LayoutGroup = new LayoutGroup();
			item1.layoutData = new HorizontalLayoutData(100, 100);
			var child:LayoutGroup = new LayoutGroup();
			child.width = 100;
			child.height = 100;
			child.minWidth = 50;
			child.minHeight = 50;
			item1.backgroundSkin = child;
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("HorizontalLayout without explicit view port height and child with percentHeight, calculated height, and calculated minHeight results in wrong view port height",
				100, result.viewPortHeight);
			Assert.assertStrictlyEquals("HorizontalLayout without explicit view port height and child with percentHeight, calculated height, and calculated minHeight results in wrong child height",
				100, item1.height);
		}
	}
}
