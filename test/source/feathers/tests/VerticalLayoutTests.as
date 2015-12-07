package feathers.tests
{
	import feathers.layout.LayoutBoundsResult;
	import feathers.layout.VerticalLayout;
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
	}
}
