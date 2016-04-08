package feathers.tests
{
	import feathers.controls.Header;
	import feathers.controls.LayoutGroup;
	import feathers.controls.text.BitmapFontTextRenderer;
	import feathers.core.ITextRenderer;

	import org.flexunit.Assert;

	import starling.display.DisplayObject;
	import starling.display.Quad;

	public class HeaderMeasurementTests
	{
		private static const BACKGROUND_WIDTH:Number = 200;
		private static const BACKGROUND_HEIGHT:Number = 250;

		private static const COMPLEX_BACKGROUND_WIDTH:Number = 340;
		private static const COMPLEX_BACKGROUND_HEIGHT:Number = 350;
		private static const COMPLEX_BACKGROUND_MIN_WIDTH:Number = 280;
		private static const COMPLEX_BACKGROUND_MIN_HEIGHT:Number = 290;

		private static const PADDING_TOP:Number = 50;
		private static const PADDING_RIGHT:Number = 54;
		private static const PADDING_BOTTOM:Number = 59;
		private static const PADDING_LEFT:Number = 60;
		
		private static const GAP:Number = 5;
		private static const TITLE_GAP:Number = 7;

		private static const LEFT_ITEM_WIDTH:Number = 12;
		private static const LEFT_ITEM_HEIGHT:Number = 16;

		private static const RIGHT_ITEM_WIDTH:Number = 17;
		private static const RIGHT_ITEM_HEIGHT:Number = 31;

		private static const CENTER_ITEM_WIDTH:Number = 14;
		private static const CENTER_ITEM_HEIGHT:Number = 37;

		private var _header:Header;
		private var _textRenderer:BitmapFontTextRenderer;

		[Before]
		public function prepare():void
		{
			this._header = new Header();
			this._header.titleFactory = function():ITextRenderer
			{
				return new BitmapFontTextRenderer();
			};
			TestFeathers.starlingRoot.addChild(this._header);
			
			this._textRenderer = new BitmapFontTextRenderer();
			TestFeathers.starlingRoot.addChild(this._textRenderer);
		}

		[After]
		public function cleanup():void
		{
			this._header.removeFromParent(true);
			this._header = null;
			
			this._textRenderer.removeFromParent(true);
			this._textRenderer = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		private function addSimpleBackground():void
		{
			this._header.backgroundSkin = new Quad(BACKGROUND_WIDTH, BACKGROUND_HEIGHT, 0xff00ff);
		}

		private function addComplexBackground():void
		{
			var backgroundSkin:LayoutGroup = new LayoutGroup();
			backgroundSkin.width = COMPLEX_BACKGROUND_WIDTH;
			backgroundSkin.height = COMPLEX_BACKGROUND_HEIGHT;
			backgroundSkin.minWidth = COMPLEX_BACKGROUND_MIN_WIDTH;
			backgroundSkin.minHeight = COMPLEX_BACKGROUND_MIN_HEIGHT;
			this._header.backgroundSkin = backgroundSkin;
		}

		[Test]
		public function testAutoSizeNoBackgroundAndNoItems():void
		{
			this._header.validate();
			Assert.assertStrictlyEquals("The width of the Header was not calculated correctly when empty.",
				0, this._header.width);
			Assert.assertStrictlyEquals("The height of the Header was not calculated correctly when empty.",
				0, this._header.height);
			Assert.assertStrictlyEquals("The minWidth of the Header was not calculated correctly when empty.",
				0, this._header.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Header was not calculated correctly when empty.",
				0, this._header.minHeight);
		}

		[Test]
		public function testAutoSizeWithSimpleBackgroundAndNoChildren():void
		{
			this.addSimpleBackground();
			this._header.validate();
			Assert.assertStrictlyEquals("The width of the Header was not calculated correctly with background skin and no children.",
				BACKGROUND_WIDTH, this._header.width);
			Assert.assertStrictlyEquals("The height of the Header was not calculated correctly with background skin and no children.",
				BACKGROUND_HEIGHT, this._header.height);
			Assert.assertStrictlyEquals("The minWidth of the Header was not calculated correctly with background skin and no children.",
				BACKGROUND_WIDTH, this._header.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Header was not calculated correctly with background skin and no children.",
				BACKGROUND_HEIGHT, this._header.minHeight);
		}

		[Test]
		public function testAutoSizeWithComplexBackgroundAndNoChildren():void
		{
			this.addComplexBackground();
			this._header.validate();
			Assert.assertStrictlyEquals("The width of the Header was not calculated correctly with complex background skin and no children.",
				COMPLEX_BACKGROUND_WIDTH, this._header.width);
			Assert.assertStrictlyEquals("The height of the Header was not calculated correctly with complex background skin and no children.",
				COMPLEX_BACKGROUND_HEIGHT, this._header.height);
			Assert.assertStrictlyEquals("The minWidth of the Header was not calculated correctly with complex background skin and no children.",
				COMPLEX_BACKGROUND_MIN_WIDTH, this._header.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Header was not calculated correctly with complex background skin and no children.",
				COMPLEX_BACKGROUND_MIN_HEIGHT, this._header.minHeight);
		}

		[Test]
		public function testDimensionsWithPaddingGapTitleGapNoChildren():void
		{
			this._header.paddingTop = PADDING_TOP;
			this._header.paddingRight = PADDING_RIGHT;
			this._header.paddingBottom = PADDING_BOTTOM;
			this._header.paddingLeft = PADDING_LEFT;
			this._header.gap = GAP;
			this._header.titleGap = TITLE_GAP;
			this._header.validate();
			Assert.assertStrictlyEquals("The width of the Header was not calculated correctly with left and right padding.",
				PADDING_LEFT + PADDING_RIGHT, this._header.width);
			Assert.assertStrictlyEquals("The height of the Header was not calculated correctly with top and bottom padding.",
				PADDING_TOP + PADDING_BOTTOM, this._header.height);
			Assert.assertStrictlyEquals("The minWidth of the Header was not calculated correctly with left and right padding.",
				PADDING_LEFT + PADDING_RIGHT, this._header.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Header was not calculated correctly with top and bottom padding.",
				PADDING_TOP + PADDING_BOTTOM, this._header.minHeight);
		}

		[Test]
		public function testDimensionsWithTitle():void
		{
			var title:String = "I am the very model of a modern major general";
			
			this._header.title = title;
			this._header.validate();

			this._textRenderer.text = title;
			this._textRenderer.validate();
			
			Assert.assertStrictlyEquals("The width of the Header was not calculated correctly with title.",
				this._textRenderer.width, this._header.width);
			Assert.assertStrictlyEquals("The height of the Header was not calculated correctly with title.",
				this._textRenderer.height, this._header.height);
			Assert.assertStrictlyEquals("The minWidth of the Header was not calculated correctly with title.",
				this._textRenderer.minWidth, this._header.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Header was not calculated correctly with title.",
				this._textRenderer.minHeight, this._header.minHeight);
		}

		[Test]
		public function testDimensionsWithTitleAndSimpleBackground():void
		{
			var title:String = "I am the very model of a modern major general";

			this.addSimpleBackground();
			this._header.title = title;
			this._header.validate();

			this._textRenderer.text = title;
			this._textRenderer.validate();

			Assert.assertStrictlyEquals("The width of the Header was not calculated correctly with title.",
				this._textRenderer.width, this._header.width);
			Assert.assertStrictlyEquals("The height of the Header was not calculated correctly with title.", 
				BACKGROUND_HEIGHT, this._header.height);
			Assert.assertStrictlyEquals("The minWidth of the Header was not calculated correctly with title.",
				this._textRenderer.minWidth, this._header.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Header was not calculated correctly with title.",
				BACKGROUND_HEIGHT, this._header.minHeight);
		}

		[Test]
		public function testDimensionsWithTitlePaddingGapAndTitleGap():void
		{
			var title:String = "I am the very model of a modern major general";

			this._header.title = title;
			this._header.paddingTop = PADDING_TOP;
			this._header.paddingRight = PADDING_RIGHT;
			this._header.paddingBottom = PADDING_BOTTOM;
			this._header.paddingLeft = PADDING_LEFT;
			this._header.gap = GAP;
			this._header.titleGap = TITLE_GAP;
			this._header.validate();

			this._textRenderer.text = title;
			this._textRenderer.validate();

			Assert.assertStrictlyEquals("The width of the Header was not calculated correctly with title and left and right padding.",
				this._textRenderer.width + PADDING_LEFT + PADDING_RIGHT, this._header.width);
			Assert.assertStrictlyEquals("The height of the Header was not calculated correctly with title and top and bottom padding.",
				this._textRenderer.height + PADDING_TOP + PADDING_BOTTOM, this._header.height);
			Assert.assertStrictlyEquals("The minWidth of the Header was not calculated correctly with title and left and right padding.",
				this._textRenderer.minWidth + PADDING_LEFT + PADDING_RIGHT, this._header.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Header was not calculated correctly with title and top and bottom padding.",
				this._textRenderer.minHeight + PADDING_TOP + PADDING_BOTTOM, this._header.minHeight);
		}

		[Test]
		public function testDimensionsWithTitleOneLeftItemPaddingGapAndTitleGap():void
		{
			var title:String = "I am the very model of a modern major general";

			this._header.title = title;
			this._header.paddingTop = PADDING_TOP;
			this._header.paddingRight = PADDING_RIGHT;
			this._header.paddingBottom = PADDING_BOTTOM;
			this._header.paddingLeft = PADDING_LEFT;
			this._header.gap = GAP;
			this._header.titleGap = TITLE_GAP;
			this._header.leftItems = new <DisplayObject>[new Quad(LEFT_ITEM_WIDTH, LEFT_ITEM_HEIGHT, 0x0000ff)];
			this._header.validate();

			this._textRenderer.text = title;
			this._textRenderer.validate();

			Assert.assertStrictlyEquals("The width of the Header was not calculated correctly with title, one left item, and left and right padding, gap, and title gap.",
				this._textRenderer.width + LEFT_ITEM_WIDTH + TITLE_GAP + PADDING_LEFT + PADDING_RIGHT, this._header.width);
			Assert.assertStrictlyEquals("The height of the Header was not calculated correctly with title, one left item, and top and bottom padding.",
				LEFT_ITEM_HEIGHT + PADDING_TOP + PADDING_BOTTOM, this._header.height);
			Assert.assertStrictlyEquals("The minWidth of the Header was not calculated correctly with title, one left item, and left and right padding, gap, and title gap.",
				this._textRenderer.minWidth + LEFT_ITEM_WIDTH + TITLE_GAP + PADDING_LEFT + PADDING_RIGHT, this._header.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Header was not calculated correctly with title, one left item, and top and bottom padding.",
				LEFT_ITEM_HEIGHT + PADDING_TOP + PADDING_BOTTOM, this._header.minHeight);
		}

		[Test]
		public function testDimensionsWithTitleOneRightItemGapAndTitleGap():void
		{
			var title:String = "I am the very model of a modern major general";

			this._header.title = title;
			this._header.gap = GAP;
			this._header.titleGap = TITLE_GAP;
			this._header.rightItems = new <DisplayObject>[new Quad(RIGHT_ITEM_WIDTH, RIGHT_ITEM_HEIGHT, 0x0000ff)];
			this._header.validate();

			this._textRenderer.text = title;
			this._textRenderer.validate();

			Assert.assertStrictlyEquals("The width of the Header was not calculated correctly with title, one right item, gap, and title gap.",
				this._textRenderer.width + RIGHT_ITEM_WIDTH + TITLE_GAP, this._header.width);
			Assert.assertStrictlyEquals("The height of the Header was not calculated correctly with title and one right item.",
				RIGHT_ITEM_HEIGHT, this._header.height);
			Assert.assertStrictlyEquals("The minWidth of the Header was not calculated correctly with title, one right item, gap, and title gap.",
				this._textRenderer.minWidth + RIGHT_ITEM_WIDTH + TITLE_GAP, this._header.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Header was not calculated correctly with title and one right item.",
				RIGHT_ITEM_HEIGHT, this._header.minHeight);
		}

		[Test]
		public function testDimensionsWithTitleTwoLeftItemsPaddingGapAndTitleGap():void
		{
			var title:String = "I am the very model of a modern major general";

			this._header.title = title;
			this._header.paddingTop = PADDING_TOP;
			this._header.paddingRight = PADDING_RIGHT;
			this._header.paddingBottom = PADDING_BOTTOM;
			this._header.paddingLeft = PADDING_LEFT;
			this._header.gap = GAP;
			this._header.titleGap = TITLE_GAP;
			this._header.leftItems = new <DisplayObject>
			[
				new Quad(LEFT_ITEM_WIDTH, LEFT_ITEM_HEIGHT, 0x0000ff),
				new Quad(LEFT_ITEM_WIDTH, LEFT_ITEM_HEIGHT, 0x00ffff),
			];
			this._header.validate();

			this._textRenderer.text = title;
			this._textRenderer.validate();

			Assert.assertStrictlyEquals("The width of the Header was not calculated correctly with title, two left items, and left and right padding, gap, and title gap.",
				this._textRenderer.width + 2 * LEFT_ITEM_WIDTH + GAP + TITLE_GAP + PADDING_LEFT + PADDING_RIGHT, this._header.width);
			Assert.assertStrictlyEquals("The height of the Header was not calculated correctly with title, two left items, and top and bottom padding.",
				LEFT_ITEM_HEIGHT + PADDING_TOP + PADDING_BOTTOM, this._header.height);
			Assert.assertStrictlyEquals("The minWidth of the Header was not calculated correctly with title, two left items, and left and right padding, gap, and title gap.",
				this._textRenderer.minWidth + 2 * LEFT_ITEM_WIDTH + GAP + TITLE_GAP + PADDING_LEFT + PADDING_RIGHT, this._header.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Header was not calculated correctly with title, two left items, and top and bottom padding.",
				LEFT_ITEM_HEIGHT + PADDING_TOP + PADDING_BOTTOM, this._header.minHeight);
		}

		[Test]
		public function testDimensionsWithTitleTwoLeftItemsOneRightItemPaddingGapAndTitleGap():void
		{
			var title:String = "I am the very model of a modern major general";

			this._header.title = title;
			this._header.paddingTop = PADDING_TOP;
			this._header.paddingRight = PADDING_RIGHT;
			this._header.paddingBottom = PADDING_BOTTOM;
			this._header.paddingLeft = PADDING_LEFT;
			this._header.gap = GAP;
			this._header.titleGap = TITLE_GAP;
			this._header.leftItems = new <DisplayObject>
			[
				new Quad(LEFT_ITEM_WIDTH, LEFT_ITEM_HEIGHT, 0x0000ff),
				new Quad(LEFT_ITEM_WIDTH, LEFT_ITEM_HEIGHT, 0x00ffff),
			];
			this._header.rightItems = new <DisplayObject>
			[
				new Quad(RIGHT_ITEM_WIDTH, RIGHT_ITEM_HEIGHT, 0x0000ff),
			];
			this._header.validate();

			this._textRenderer.text = title;
			this._textRenderer.validate();

			Assert.assertStrictlyEquals("The width of the Header was not calculated correctly with title, two left items, one right item, and left and right padding, gap, and title gap.",
				this._textRenderer.width + 2 * LEFT_ITEM_WIDTH + RIGHT_ITEM_WIDTH + GAP + 2 * TITLE_GAP + PADDING_LEFT + PADDING_RIGHT, this._header.width);
			Assert.assertStrictlyEquals("The height of the Header was not calculated correctly with title, two left items, one right item, and top and bottom padding.",
				RIGHT_ITEM_HEIGHT + PADDING_TOP + PADDING_BOTTOM, this._header.height);
			Assert.assertStrictlyEquals("The minWidth of the Header was not calculated correctly with title, two left items, one right item, and left and right padding, gap, and title gap.",
				this._textRenderer.minWidth + 2 * LEFT_ITEM_WIDTH + RIGHT_ITEM_WIDTH + GAP + 2 * TITLE_GAP + PADDING_LEFT + PADDING_RIGHT, this._header.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Header was not calculated correctly with title, two left items, one right item, and top and bottom padding.",
				RIGHT_ITEM_HEIGHT + PADDING_TOP + PADDING_BOTTOM, this._header.minHeight);
		}

		[Test]
		public function testDimensionsWithTitleTwoLeftItemsOneRightItemThreeCenterItemsPaddingGapAndTitleGap():void
		{
			var title:String = "I am the very model of a modern major general";

			this._header.title = title;
			this._header.paddingTop = PADDING_TOP;
			this._header.paddingRight = PADDING_RIGHT;
			this._header.paddingBottom = PADDING_BOTTOM;
			this._header.paddingLeft = PADDING_LEFT;
			this._header.gap = GAP;
			this._header.titleGap = TITLE_GAP;
			this._header.leftItems = new <DisplayObject>
			[
				new Quad(LEFT_ITEM_WIDTH, LEFT_ITEM_HEIGHT, 0x0000ff),
				new Quad(LEFT_ITEM_WIDTH, LEFT_ITEM_HEIGHT, 0x00ffff),
			];
			this._header.rightItems = new <DisplayObject>
			[
				new Quad(RIGHT_ITEM_WIDTH, RIGHT_ITEM_HEIGHT, 0x0000ff),
			];
			this._header.centerItems = new <DisplayObject>
			[
				new Quad(CENTER_ITEM_WIDTH, CENTER_ITEM_HEIGHT, 0x0000ff),
				new Quad(CENTER_ITEM_WIDTH, CENTER_ITEM_HEIGHT, 0x0000ff),
				new Quad(CENTER_ITEM_WIDTH, CENTER_ITEM_HEIGHT, 0x0000ff),
			];
			this._header.validate();

			Assert.assertStrictlyEquals("The width of the Header was not calculated correctly with title, two left items, one right item, three center items, and left and right padding, gap, and title gap.",
				2 * LEFT_ITEM_WIDTH + RIGHT_ITEM_WIDTH + 3 * CENTER_ITEM_WIDTH + 5 * GAP + PADDING_LEFT + PADDING_RIGHT, this._header.width);
			Assert.assertStrictlyEquals("The height of the Header was not calculated correctly with title, two left items, one right item, three center items, and top and bottom padding.",
				CENTER_ITEM_HEIGHT + PADDING_TOP + PADDING_BOTTOM, this._header.height);
			Assert.assertStrictlyEquals("The minWidth of the Header was not calculated correctly with title, two left items, one right item, three center items, and left and right padding, gap, and title gap.",
				2 * LEFT_ITEM_WIDTH + RIGHT_ITEM_WIDTH + 3 * CENTER_ITEM_WIDTH + 5 * GAP + PADDING_LEFT + PADDING_RIGHT, this._header.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Header was not calculated correctly with title, two left items, one right item, three center items, and top and bottom padding.",
				CENTER_ITEM_HEIGHT + PADDING_TOP + PADDING_BOTTOM, this._header.minHeight);
		}
	}
}
