package feathers.tests
{
	import feathers.layout.HorizontalSpinnerLayout;
	import feathers.layout.LayoutBoundsResult;
	import feathers.layout.VerticalSpinnerLayout;
	import feathers.layout.ViewPortBounds;

	import org.flexunit.Assert;

	import starling.display.DisplayObject;

	import starling.display.Quad;

	public class HorizontalSpinnerLayoutTests
	{
		private var _layout:HorizontalSpinnerLayout;

		[Before]
		public function prepare():void
		{
			this._layout = new HorizontalSpinnerLayout();
		}

		[After]
		public function cleanup():void
		{
			this._layout = null;
		}

		[Test]
		public function testMinimumAndMaximumScrollPositionsWhenRepeatItemsIsTrue():void
		{
			this._layout.repeatItems = true;
			var item1:Quad = new Quad(200, 200);
			var item2:Quad = new Quad(200, 200);
			var item3:Quad = new Quad(200, 200);
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1, item2, item3];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitWidth = 200;
			this._layout.typicalItem = item1;
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("HorizontalSpinnerLayout layout() LayoutBoundsResult contentX not equal to Number.NEGATIVE_INFINITY when repeatItems is true and the total item width is larger than the view port width", Number.NEGATIVE_INFINITY, result.contentX);
			Assert.assertStrictlyEquals("HorizontalSpinnerLayout layout() LayoutBoundsResult contentWidth not equal to Number.POSITIVE_INFINITY when repeatItems is true and the total item width is larger than the view port width", Number.POSITIVE_INFINITY, result.contentWidth);
		}

		[Test]
		public function testMinimumAndMaximumScrollPositionsWhenRepeatItemsIsFalse():void
		{
			var itemSize:Number = 200;
			this._layout.repeatItems = false;
			var item1:Quad = new Quad(itemSize, itemSize);
			var item2:Quad = new Quad(itemSize, itemSize);
			var item3:Quad = new Quad(itemSize, itemSize);
			var items:Vector.<DisplayObject> = new <DisplayObject>[item1, item2, item3];
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.explicitWidth = 200;
			this._layout.typicalItem = item1;
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("HorizontalSpinnerLayout layout() LayoutBoundsResult contentX not equal to 0 when repeatItems is false and the total item width is larger than the view port width", 0, result.contentX);
			Assert.assertStrictlyEquals("HorizontalSpinnerLayout layout() LayoutBoundsResult contentWidth not equal to total width of items minus view port width when repeatItems is false and the total item width is larger than the view port width", items.length * itemSize, result.contentWidth);
		}
	}
}
