package feathers.tests
{
	import feathers.controls.LayoutGroup;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.HorizontalLayoutData;
	import feathers.layout.ViewPortBounds;

	import org.flexunit.Assert;

	import starling.display.DisplayObject;

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
	}
}
