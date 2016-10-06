package feathers.tests
{
	import feathers.controls.Label;
	import feathers.controls.LayoutGroup;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
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

		[Test]
		public function testPercentWidthWithExplicitMinWidth():void
		{
			var viewPortWidth:Number = 640;
			var item1:LayoutGroup = new LayoutGroup();
			item1.minWidth = 400;
			var layoutData1:AnchorLayoutData = new AnchorLayoutData();
			layoutData1.percentWidth = 50;
			item1.layoutData = layoutData1;
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitWidth = viewPortWidth;
			bounds.explicitHeight = 640;
			this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("AnchorLayoutData with percentWidth and larger item explicitMinWidth results in incorrect item width",
				400, item1.width);
		}

		[Test]
		public function testPercentHeightWithExplicitMinHeight():void
		{
			var viewPortHeight:Number = 640;
			var item1:LayoutGroup = new LayoutGroup();
			item1.minHeight = 400;
			var layoutData1:AnchorLayoutData = new AnchorLayoutData();
			layoutData1.percentHeight = 50;
			item1.layoutData = layoutData1;
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitWidth = 640;
			bounds.explicitHeight = viewPortHeight;
			this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("AnchorLayoutData with percentHeight and larger item explicitMinHeight results in incorrect item height",
				400, item1.height);
		}

		[Test]
		public function testPercentWidthWithExplicitMaxWidth():void
		{
			var viewPortWidth:Number = 640;
			var item1:LayoutGroup = new LayoutGroup();
			item1.maxWidth = 250;
			var layoutData1:AnchorLayoutData = new AnchorLayoutData();
			layoutData1.percentWidth = 50;
			item1.layoutData = layoutData1;
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitWidth = viewPortWidth;
			bounds.explicitHeight = 640;
			this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("AnchorLayoutData with percentWidth and smaller item explicitMaxWidth results in incorrect item width",
				250, item1.width);
		}

		[Test]
		public function testPercentHeightWithExplicitMaxHeight():void
		{
			var viewPortHeight:Number = 640;
			var item1:LayoutGroup = new LayoutGroup();
			item1.maxHeight = 250;
			var layoutData1:AnchorLayoutData = new AnchorLayoutData();
			layoutData1.percentHeight = 50;
			item1.layoutData = layoutData1;
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitWidth = 640;
			bounds.explicitHeight = viewPortHeight;
			this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("AnchorLayoutData with percentHeight and larger item explicitMaxHeight results in incorrect item height",
				250, item1.height);
		}

		[Test]
		public function testPercentWidthWithWrappingLabelAndMaxWidth():void
		{
			var viewPortMaxWidth:Number = 100;
			var item1:Label = new Label();
			item1.text = "I am the very model of a modern Major General";
			item1.wordWrap = true;
			item1.validate();
			var unwrappedHeight:Number = item1.height;
			var layoutData1:AnchorLayoutData = new AnchorLayoutData();
			layoutData1.percentWidth = 100;
			item1.layoutData = layoutData1;
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.maxWidth = viewPortMaxWidth;
			this._layout.layout(items, bounds);
			//since we're setting maxWidth, the width may actually be smaller
			Assert.assertTrue("AnchorLayoutData with percentWidth with a wrapping Label results in incorrect width",
				viewPortMaxWidth >= item1.width);
			//we're only checking that it has more than one line
			Assert.assertTrue("AnchorLayoutData with percentWidth on a wrapping Label results in height that is too small",
				unwrappedHeight < item1.height);
		}

		[Test]
		public function testLeftAndRightWithWrappingLabelAndMaxWidth():void
		{
			var viewPortMaxWidth:Number = 100;
			var left:Number = 10;
			var right:Number = 15;
			var item1:Label = new Label();
			item1.text = "I am the very model of a modern Major General";
			item1.wordWrap = true;
			item1.validate();
			var unwrappedHeight:Number = item1.height;
			var layoutData1:AnchorLayoutData = new AnchorLayoutData();
			layoutData1.left = left;
			layoutData1.right = right;
			item1.layoutData = layoutData1;
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.maxWidth = viewPortMaxWidth;
			this._layout.layout(items, bounds);
			//since we're setting maxWidth, the width may actually be smaller
			Assert.assertTrue("AnchorLayoutData with left and right on a wrapping Label results in incorrect width",
				viewPortMaxWidth - left - right >= item1.width);
			//we're only checking that it has more than one line
			Assert.assertTrue("AnchorLayoutData with left and right on a wrapping Label results in height that is too small",
				unwrappedHeight < item1.height);
		}
	}
}
