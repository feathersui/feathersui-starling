package feathers.tests
{
	import feathers.controls.LayoutGroup;
	import feathers.layout.TiledColumnsLayout;

	import org.flexunit.Assert;

	import starling.display.Quad;

	public class LayoutGroupTiledColumnsLayoutTests
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

		private var _group:LayoutGroup;
		private var _layout:TiledColumnsLayout;

		[Before]
		public function prepare():void
		{
			this._group = new LayoutGroup();
			this._layout = new TiledColumnsLayout();
			this._group.layout = this._layout;
			TestFeathers.starlingRoot.addChild(this._group);
		}

		[After]
		public function cleanup():void
		{
			this._group.removeFromParent(true);
			this._group = null;
			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testDimensionsWithNoChildren():void
		{
			this._group.validate();
			Assert.assertStrictlyEquals("TiledColumnsLayout width not equal to 0 with no children.", 0, this._group.width);
			Assert.assertStrictlyEquals("TiledColumnsLayout height not equal to 0 with no children.", 0, this._group.height);
		}

		[Test]
		public function testDimensionsWithPaddingGapAndNoChildren():void
		{
			this._layout.paddingTop = PADDING_TOP;
			this._layout.paddingRight = PADDING_RIGHT;
			this._layout.paddingBottom = PADDING_BOTTOM;
			this._layout.paddingLeft = PADDING_LEFT;
			this._layout.gap = GAP;
			this._group.validate();
			Assert.assertStrictlyEquals("TiledColumnsLayout width not equal to sum of left and right padding with no children.", PADDING_LEFT + PADDING_RIGHT, this._group.width);
			Assert.assertStrictlyEquals("TiledColumnsLayout height not equal to sum of top and bottom padding with no children.", PADDING_TOP + PADDING_BOTTOM, this._group.height);
		}

		[Test]
		public function testDimensionsWithOneChildAndSquareTiles():void
		{
			this._group.addChild(new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff));
			this._group.validate();
			var tileSize:Number = Math.max(CHILD1_WIDTH, CHILD1_HEIGHT);
			Assert.assertStrictlyEquals("TiledColumnsLayout width not equal to child width.", tileSize, this._group.width);
			Assert.assertStrictlyEquals("TiledColumnsLayout height not equal to child height.", tileSize, this._group.height);
		}

		[Test]
		public function testDimensionsWithOneChildAndNotSquareTiles():void
		{
			this._layout.useSquareTiles = false;
			this._group.addChild(new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff));
			this._group.validate();
			Assert.assertStrictlyEquals("TiledColumnsLayout width not equal to child width.", CHILD1_WIDTH, this._group.width);
			Assert.assertStrictlyEquals("TiledColumnsLayout height not equal to child height.", CHILD1_HEIGHT, this._group.height);
		}

		[Test]
		public function testDimensionsWithPaddingGapAndOneChild():void
		{
			this._layout.useSquareTiles = false;
			this._layout.paddingTop = PADDING_TOP;
			this._layout.paddingRight = PADDING_RIGHT;
			this._layout.paddingBottom = PADDING_BOTTOM;
			this._layout.paddingLeft = PADDING_LEFT;
			this._layout.gap = GAP;
			this._group.addChild(new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff));
			this._group.validate();
			Assert.assertStrictlyEquals("TiledColumnsLayout width not equal to sum of left and right padding and width of child.", CHILD1_WIDTH + PADDING_LEFT + PADDING_RIGHT, this._group.width);
			Assert.assertStrictlyEquals("TiledColumnsLayout height not equal to sum of top and bottom padding and height of child.", CHILD1_HEIGHT + PADDING_TOP + PADDING_BOTTOM, this._group.height);
		}

		[Test]
		public function testDimensionsWithTwoChildren():void
		{
			this._layout.useSquareTiles = false;
			this._group.addChild(new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff));
			this._group.addChild(new Quad(CHILD2_WIDTH, CHILD2_HEIGHT, 0xff00ff));
			this._group.validate();
			var maxChildWidth:Number = Math.max(CHILD1_WIDTH, CHILD2_WIDTH);
			var maxChildHeight:Number = Math.max(CHILD1_HEIGHT, CHILD2_HEIGHT);
			Assert.assertStrictlyEquals("TiledColumnsLayout width not equal to max width of children.", maxChildWidth, this._group.width);
			Assert.assertStrictlyEquals("TiledColumnsLayout height not equal to sum of child heights.", 2 * maxChildHeight, this._group.height);
		}

		[Test]
		public function testDimensionsWithPaddingGapAndTwoChildren():void
		{
			this._layout.useSquareTiles = false;
			this._layout.paddingTop = PADDING_TOP;
			this._layout.paddingRight = PADDING_RIGHT;
			this._layout.paddingBottom = PADDING_BOTTOM;
			this._layout.paddingLeft = PADDING_LEFT;
			this._layout.gap = GAP;
			this._group.addChild(new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff));
			this._group.addChild(new Quad(CHILD2_WIDTH, CHILD2_HEIGHT, 0xff00ff));
			this._group.validate();
			var maxChildWidth:Number = Math.max(CHILD1_WIDTH, CHILD2_WIDTH);
			var maxChildHeight:Number = Math.max(CHILD1_HEIGHT, CHILD2_HEIGHT);
			Assert.assertStrictlyEquals("TiledColumnsLayout width not equal to max width of children plus left and right padding.", maxChildWidth + PADDING_LEFT + PADDING_RIGHT, this._group.width);
			Assert.assertStrictlyEquals("TiledColumnsLayout height not equal to sum of child heights plus top and bottom padding and gap.", 2 * maxChildHeight + PADDING_TOP + PADDING_BOTTOM + GAP, this._group.height);
		}

		[Test]
		public function testDimensionsWithRequestedRowCount():void
		{
			this._layout.useSquareTiles = false;
			this._layout.requestedRowCount = 2;
			this._group.addChild(new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff));
			this._group.addChild(new Quad(CHILD2_WIDTH, CHILD2_HEIGHT, 0xff00ff));
			this._group.addChild(new Quad(CHILD3_WIDTH, CHILD3_HEIGHT, 0xff00ff));
			this._group.validate();
			var maxChildWidth:Number = Math.max(CHILD1_WIDTH, CHILD2_WIDTH, CHILD3_WIDTH);
			var maxChildHeight:Number = Math.max(CHILD1_HEIGHT, CHILD2_HEIGHT, CHILD3_HEIGHT);
			Assert.assertStrictlyEquals("TiledColumnsLayout width not correct with requestedColumnCount.", 2 * maxChildWidth, this._group.width);
			Assert.assertStrictlyEquals("TiledColumnsLayout height not correct width requestedColumnCount.", 2 * maxChildHeight, this._group.height);
		}

		[Test]
		public function testWidthWithMaxWidthSmallerThanChild():void
		{
			this._layout.useSquareTiles = false;
			this._group.maxWidth = CHILD1_WIDTH / 3;
			this._group.addChild(new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff));
			this._group.validate();
			Assert.assertStrictlyEquals("TiledColumnsLayout width not equal to maxWidth when maxWidth is smaller than child width.", this._group.maxWidth, this._group.width);
		}

		[Test]
		public function testDimensionsWithMaxWidthLargerThanChild():void
		{
			this._layout.useSquareTiles = false;
			//needs to be enough to require more than one tile
			this._group.maxWidth = 3 * CHILD1_WIDTH;
			this._group.addChild(new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff));
			this._group.validate();
			Assert.assertStrictlyEquals("TiledColumnsLayout width not equal to child width when maxWidth is larger than child width.", CHILD1_WIDTH, this._group.width);
		}

		[Test]
		public function testWidthWithMaxHeightSmallerThanChild():void
		{
			this._layout.useSquareTiles = false;
			this._group.maxHeight = CHILD1_HEIGHT / 3;
			this._group.addChild(new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff));
			this._group.validate();
			Assert.assertStrictlyEquals("TiledColumnsLayout height not equal to maxHeight when maxHeight is smaller than child height.", this._group.maxHeight, this._group.height);
		}

		[Test]
		public function testDimensionsWithMaxHeightLargerThanChild():void
		{
			this._layout.useSquareTiles = false;
			//needs to be enough to require more than one tile
			this._group.maxHeight = 3 * CHILD1_HEIGHT;
			this._group.addChild(new Quad(CHILD1_WIDTH, CHILD1_HEIGHT, 0xff00ff));
			this._group.validate();
			Assert.assertStrictlyEquals("TiledColumnsLayout height not equal to child height when maxHeight is larger than child height.", CHILD1_HEIGHT, this._group.height);
		}
	}
}
