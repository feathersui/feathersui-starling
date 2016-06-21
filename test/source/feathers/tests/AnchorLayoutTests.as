package feathers.tests
{
	import feathers.controls.LayoutGroup;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.HorizontalLayoutData;
	import feathers.layout.ViewPortBounds;

	import org.flexunit.Assert;

	import starling.display.DisplayObject;

	public class AnchorLayoutTests
	{
		private var _layout:AnchorLayout;

		[Before]
		public function prepare():void
		{
			this._layout = new AnchorLayout();
		}

		[After]
		public function cleanup():void
		{
			this._layout = null;
		}

		[Test]
		public function testPercentWidth():void
		{
			var viewPortWidth:Number = 640;
			var item1:LayoutGroup = new LayoutGroup();
			var layoutData1:AnchorLayoutData = new AnchorLayoutData();
			layoutData1.percentWidth = 50;
			item1.layoutData = layoutData1;
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitWidth = viewPortWidth;
			bounds.explicitHeight = 640;
			this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("AnchorLayoutData with percentWidth results in incorrect item width", viewPortWidth / 2, item1.width);
		}

		[Test]
		public function testPercentWidthGreaterThan100():void
		{
			var viewPortWidth:Number = 640;
			var item1:LayoutGroup = new LayoutGroup();
			var layoutData1:AnchorLayoutData = new AnchorLayoutData();
			layoutData1.percentWidth = 150;
			item1.layoutData = layoutData1;
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitWidth = viewPortWidth;
			bounds.explicitHeight = 640;
			this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("AnchorLayoutData with percentWidth > 100 does not clamp to 100", viewPortWidth, item1.width);
		}

		[Test]
		public function testPercentWidthLessThan0():void
		{
			var viewPortWidth:Number = 640;
			var item1:LayoutGroup = new LayoutGroup();
			var layoutData1:AnchorLayoutData = new AnchorLayoutData();
			layoutData1.percentWidth = -50;
			item1.layoutData = layoutData1;
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitWidth = viewPortWidth;
			bounds.explicitHeight = 640;
			this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("AnchorLayoutData with percentWidth < 0 does not clamp to 0", 0, item1.width);
		}

		[Test]
		public function testPercentHeight():void
		{
			var viewPortHeight:Number = 640;
			var item1:LayoutGroup = new LayoutGroup();
			var layoutData1:AnchorLayoutData = new AnchorLayoutData();
			layoutData1.percentHeight = 50;
			item1.layoutData = layoutData1;
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitWidth = 640;
			bounds.explicitHeight = viewPortHeight;
			this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("AnchorLayoutData with percentHeight results in incorrect item height", viewPortHeight / 2, item1.height);
		}

		[Test]
		public function testPercentHeightGreaterThan100():void
		{
			var viewPortHeight:Number = 640;
			var item1:LayoutGroup = new LayoutGroup();
			var layoutData1:AnchorLayoutData = new AnchorLayoutData();
			layoutData1.percentHeight = 150;
			item1.layoutData = layoutData1;
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitWidth = 640;
			bounds.explicitHeight = viewPortHeight;
			this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("AnchorLayoutData with percentHeight > 100 does not clamp to 100", viewPortHeight, item1.height);
		}

		[Test]
		public function testPercentHeightLessThan0():void
		{
			var viewPortHeight:Number = 640;
			var item1:LayoutGroup = new LayoutGroup();
			var layoutData1:AnchorLayoutData = new AnchorLayoutData();
			layoutData1.percentHeight = -50;
			item1.layoutData = layoutData1;
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitWidth = 640;
			bounds.explicitHeight = viewPortHeight;
			this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("AnchorLayoutData with percentHeight < 0 does not clamp to 0", 0, item1.height);
		}
	}
}
