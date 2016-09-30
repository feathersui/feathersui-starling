package feathers.tests
{
	import feathers.layout.LayoutBoundsResult;
	import feathers.layout.VerticalSpinnerLayout;
	import feathers.layout.ViewPortBounds;

	import org.flexunit.Assert;

	import starling.display.DisplayObject;
	import starling.display.Quad;

	public class VerticalSpinnerLayoutTests
	{
		private var _layout:VerticalSpinnerLayout;

		[Before]
		public function prepare():void
		{
			this._layout = new VerticalSpinnerLayout();
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
			bounds.explicitHeight = 200;
			this._layout.typicalItem = item1;
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("VerticalSpinnerLayout layout() LayoutBoundsResult contentY not equal to Number.NEGATIVE_INFINITY when repeatItems is true and the total item height is larger than the view port height", Number.NEGATIVE_INFINITY, result.contentY);
			Assert.assertStrictlyEquals("VerticalSpinnerLayout layout() LayoutBoundsResult contentHeight not equal to Number.POSITIVE_INFINITY when repeatItems is true and the total item height is larger than the view port height", Number.POSITIVE_INFINITY, result.contentHeight);
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
			bounds.explicitHeight = 200;
			this._layout.typicalItem = item1;
			var result:LayoutBoundsResult = this._layout.layout(items, bounds);
			Assert.assertStrictlyEquals("VerticalSpinnerLayout layout() LayoutBoundsResult contentY not equal to 0 when repeatItems is false and the total item height is larger than the view port height", 0, result.contentY);
			Assert.assertStrictlyEquals("VerticalSpinnerLayout layout() LayoutBoundsResult contentHeight not equal to total height of items minus view port height when repeatItems is false and the total item height is larger than the view port height", items.length * itemSize, result.contentHeight);
		}

		[Test]
		public function testVisibleIndicesWithOneItemVisibleAndRepeatingWithGap():void
		{
			//Github issue #1257
			var itemSize:Number = 256;
			var gap:Number = 64;
			this._layout.useVirtualLayout = true;
			this._layout.gap = gap;
			this._layout.requestedRowCount = 1;
			var item1:Quad = new Quad(itemSize, itemSize);
			this._layout.typicalItem = item1;
			var result:Vector.<int> = this._layout.getVisibleIndicesAtScrollPosition(0, (itemSize + gap) * 9.8, 320, 320, 5);
			Assert.assertTrue("VerticalSpinnerLayout getVisibleIndicesAtScrollPosition() does not contain and index that should be visible", result.indexOf(4) >= 0)
		}
	}
}
