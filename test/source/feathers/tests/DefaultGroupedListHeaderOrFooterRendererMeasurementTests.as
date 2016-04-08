package feathers.tests
{
	import feathers.controls.GroupedList;
	import feathers.controls.LayoutGroup;
	import feathers.controls.renderers.DefaultGroupedListHeaderOrFooterRenderer;
	import feathers.controls.text.BitmapFontTextRenderer;

	import org.flexunit.Assert;

	import starling.display.Quad;

	public class DefaultGroupedListHeaderOrFooterRendererMeasurementTests
	{
		private static const SMALL_BACKGROUND_WIDTH:Number = 10;
		private static const SMALL_BACKGROUND_HEIGHT:Number = 12;
		private static const LARGE_BACKGROUND_WIDTH:Number = 100;
		private static const LARGE_BACKGROUND_HEIGHT:Number = 110;
		private static const COMPLEX_BACKGROUND_WIDTH:Number = 54;
		private static const COMPLEX_BACKGROUND_HEIGHT:Number = 55;
		private static const COMPLEX_BACKGROUND_MIN_WIDTH:Number = 38;
		private static const COMPLEX_BACKGROUND_MIN_HEIGHT:Number = 39;

		private static const SMALL_CONTENT_WIDTH:Number = 13;
		private static const SMALL_CONTENT_HEIGHT:Number = 11;
		private static const LARGE_CONTENT_WIDTH:Number = 105;
		private static const LARGE_CONTENT_HEIGHT:Number = 115;
		private static const COMPLEX_CONTENT_WIDTH:Number = 23;
		private static const COMPLEX_CONTENT_HEIGHT:Number = 25;
		private static const COMPLEX_CONTENT_MIN_WIDTH:Number = 18;
		private static const COMPLEX_CONTENT_MIN_HEIGHT:Number = 19;

		private static const PADDING_TOP:Number = 50;
		private static const PADDING_RIGHT:Number = 54;
		private static const PADDING_BOTTOM:Number = 59;
		private static const PADDING_LEFT:Number = 60;

		private var _headerOrFooterRenderer:DefaultGroupedListHeaderOrFooterRenderer;
		private var _textRenderer:BitmapFontTextRenderer;
		private var _list:GroupedList;

		[Before]
		public function prepare():void
		{
			this._list = new GroupedList();

			this._headerOrFooterRenderer = new DefaultGroupedListHeaderOrFooterRenderer();
			this._headerOrFooterRenderer.owner = this._list;
			this._headerOrFooterRenderer.groupIndex = 0;
			this._headerOrFooterRenderer.data = { label: null };
			this._headerOrFooterRenderer.contentLabelFactory = function():BitmapFontTextRenderer
			{
				return new BitmapFontTextRenderer();
			};
			TestFeathers.starlingRoot.addChild(this._headerOrFooterRenderer);

			this._textRenderer = new BitmapFontTextRenderer();
			TestFeathers.starlingRoot.addChild(this._textRenderer);
		}

		[After]
		public function cleanup():void
		{
			this._headerOrFooterRenderer.removeFromParent(true);
			this._headerOrFooterRenderer = null;

			this._list.dispose();
			this._list = null;

			this._textRenderer.removeFromParent(true);
			this._textRenderer = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}
		
		private function addSmallSimpleBackground():void
		{
			this._headerOrFooterRenderer.backgroundSkin = new Quad(SMALL_BACKGROUND_WIDTH, SMALL_BACKGROUND_HEIGHT, 0xff00ff);
		}

		private function addLargeSimpleBackground():void
		{
			this._headerOrFooterRenderer.backgroundSkin = new Quad(LARGE_BACKGROUND_WIDTH, LARGE_BACKGROUND_HEIGHT, 0xff00ff);
		}

		private function addComplexBackground():void
		{
			var backgroundSkin:LayoutGroup = new LayoutGroup();
			backgroundSkin.width = COMPLEX_BACKGROUND_WIDTH;
			backgroundSkin.height = COMPLEX_BACKGROUND_HEIGHT;
			backgroundSkin.minWidth = COMPLEX_BACKGROUND_MIN_WIDTH;
			backgroundSkin.minHeight = COMPLEX_BACKGROUND_MIN_HEIGHT;
			this._headerOrFooterRenderer.backgroundSkin = backgroundSkin;
		}

		[Test]
		public function testAutoSizeWithPadding():void
		{
			this._headerOrFooterRenderer.paddingTop = PADDING_TOP;
			this._headerOrFooterRenderer.paddingRight = PADDING_RIGHT;
			this._headerOrFooterRenderer.paddingBottom = PADDING_BOTTOM;
			this._headerOrFooterRenderer.paddingLeft = PADDING_LEFT;
			this._headerOrFooterRenderer.validate();

			Assert.assertStrictlyEquals("The width of the DefaultGroupedListHeaderOrFooterRenderer was not calculated correctly based on the left and right padding.",
				PADDING_LEFT + PADDING_RIGHT, this._headerOrFooterRenderer.width);
			Assert.assertStrictlyEquals("The height of the DefaultGroupedListHeaderOrFooterRenderer was not calculated correctly based on the top and bottom padding.",
				PADDING_TOP + PADDING_BOTTOM, this._headerOrFooterRenderer.height);
			Assert.assertStrictlyEquals("The minWidth of the DefaultGroupedListHeaderOrFooterRenderer was not calculated correctly based on the left and right padding.",
				PADDING_LEFT + PADDING_RIGHT, this._headerOrFooterRenderer.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the DefaultGroupedListHeaderOrFooterRenderer was not calculated correctly based on the top and bottom padding.",
				PADDING_TOP + PADDING_BOTTOM, this._headerOrFooterRenderer.minHeight);
		}

		[Test]
		public function testAutoSizeWithLabel():void
		{
			var labelText:String = "I am the very model of a modern major general";
			this._textRenderer.text = labelText;
			this._textRenderer.validate();

			this._headerOrFooterRenderer.data = { label: labelText };
			this._headerOrFooterRenderer.validate();

			Assert.assertTrue("The width of the DefaultGroupedListHeaderOrFooterRenderer was not greater than 0 when using a label.",
				this._headerOrFooterRenderer.width > 0);
			Assert.assertTrue("The height of the DefaultGroupedListHeaderOrFooterRenderer was not greater than 0 when using a label.",
				this._headerOrFooterRenderer.height > 0);
			Assert.assertTrue("The minWidth of the DefaultGroupedListHeaderOrFooterRenderer was not greater than 0 when using a label.",
				this._headerOrFooterRenderer.minWidth > 0);
			Assert.assertTrue("The minHeight of the DefaultGroupedListHeaderOrFooterRenderer was not greater than 0 when using a label.",
				this._headerOrFooterRenderer.minHeight > 0);
			Assert.assertStrictlyEquals("The width of the DefaultGroupedListHeaderOrFooterRenderer was not calculated correctly based on the label.",
				this._textRenderer.width, this._headerOrFooterRenderer.width);
			Assert.assertStrictlyEquals("The height of the DefaultGroupedListHeaderOrFooterRenderer was not calculated correctly based on the label.",
				this._textRenderer.height, this._headerOrFooterRenderer.height);
			Assert.assertStrictlyEquals("The minWidth of the DefaultGroupedListHeaderOrFooterRenderer was not calculated correctly based on the label.",
				this._textRenderer.width, this._headerOrFooterRenderer.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the DefaultGroupedListHeaderOrFooterRenderer was not calculated correctly based on the label.",
				this._textRenderer.height, this._headerOrFooterRenderer.minHeight);
		}

		[Test]
		public function testAutoSizeWithLabelAndPadding():void
		{
			var labelText:String = "I am the very model of a modern major general";
			this._textRenderer.text = labelText;
			this._textRenderer.validate();

			this._headerOrFooterRenderer.data = { label: labelText };
			this._headerOrFooterRenderer.paddingTop = PADDING_TOP;
			this._headerOrFooterRenderer.paddingRight = PADDING_RIGHT;
			this._headerOrFooterRenderer.paddingBottom = PADDING_BOTTOM;
			this._headerOrFooterRenderer.paddingLeft = PADDING_LEFT;
			this._headerOrFooterRenderer.validate();

			Assert.assertStrictlyEquals("The width of the DefaultGroupedListHeaderOrFooterRenderer was not calculated correctly based on the label and left and right padding.",
				this._textRenderer.width + PADDING_LEFT + PADDING_RIGHT, this._headerOrFooterRenderer.width);
			Assert.assertStrictlyEquals("The height of the DefaultGroupedListHeaderOrFooterRenderer was not calculated correctly based on the label and top and bottom padding.",
				this._textRenderer.height + PADDING_TOP + PADDING_BOTTOM, this._headerOrFooterRenderer.height);
			Assert.assertStrictlyEquals("The minWidth of the DefaultGroupedListHeaderOrFooterRenderer was not calculated correctly based on the label and left and right padding.",
				this._textRenderer.width + PADDING_LEFT + PADDING_RIGHT, this._headerOrFooterRenderer.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the DefaultGroupedListHeaderOrFooterRenderer was not calculated correctly based on the label and top and bottom padding.",
				this._textRenderer.height + PADDING_TOP + PADDING_BOTTOM, this._headerOrFooterRenderer.minHeight);
		}

		[Test]
		public function testAutoSizeWithSimpleContent():void
		{
			var content:Quad = new Quad(SMALL_CONTENT_WIDTH, SMALL_CONTENT_HEIGHT, 0xff00ff);
			this._headerOrFooterRenderer.data = { content: content };
			this._headerOrFooterRenderer.validate();

			Assert.assertStrictlyEquals("The width of the DefaultGroupedListHeaderOrFooterRenderer was not calculated correctly based on the content width.",
				SMALL_CONTENT_WIDTH, this._headerOrFooterRenderer.width);
			Assert.assertStrictlyEquals("The height of the DefaultGroupedListHeaderOrFooterRenderer was not calculated correctly based on the content height.",
				SMALL_CONTENT_HEIGHT, this._headerOrFooterRenderer.height);
			Assert.assertStrictlyEquals("The minWidth of the DefaultGroupedListHeaderOrFooterRenderer was not calculated correctly based on the content width.",
				SMALL_CONTENT_WIDTH, this._headerOrFooterRenderer.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the DefaultGroupedListHeaderOrFooterRenderer was not calculated correctly based on the content height.",
				SMALL_CONTENT_HEIGHT, this._headerOrFooterRenderer.minHeight);

			content.dispose();
		}

		[Test]
		public function testAutoSizeWithSimpleContentAndPadding():void
		{
			var content:Quad = new Quad(SMALL_CONTENT_WIDTH, SMALL_CONTENT_HEIGHT, 0xff00ff);
			this._headerOrFooterRenderer.data = { content: content };
			this._headerOrFooterRenderer.paddingTop = PADDING_TOP;
			this._headerOrFooterRenderer.paddingRight = PADDING_RIGHT;
			this._headerOrFooterRenderer.paddingBottom = PADDING_BOTTOM;
			this._headerOrFooterRenderer.paddingLeft = PADDING_LEFT;
			this._headerOrFooterRenderer.validate();

			Assert.assertStrictlyEquals("The width of the DefaultGroupedListHeaderOrFooterRenderer was not calculated correctly based on the content width and left and right padding.",
				SMALL_CONTENT_WIDTH + PADDING_LEFT + PADDING_RIGHT, this._headerOrFooterRenderer.width);
			Assert.assertStrictlyEquals("The height of the DefaultGroupedListHeaderOrFooterRenderer was not calculated correctly based on the content height and top and bottom padding.",
				SMALL_CONTENT_HEIGHT + PADDING_TOP + PADDING_BOTTOM, this._headerOrFooterRenderer.height);
			Assert.assertStrictlyEquals("The minWidth of the DefaultGroupedListHeaderOrFooterRenderer was not calculated correctly based on the content width and left and right padding.",
				SMALL_CONTENT_WIDTH + PADDING_LEFT + PADDING_RIGHT, this._headerOrFooterRenderer.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the DefaultGroupedListHeaderOrFooterRenderer was not calculated correctly based on the content height and top and bottom padding.",
				SMALL_CONTENT_HEIGHT + PADDING_TOP + PADDING_BOTTOM, this._headerOrFooterRenderer.minHeight);

			content.dispose();
		}

		[Test]
		public function testAutoSizeWithComplexContent():void
		{
			var content:LayoutGroup = new LayoutGroup();
			content.setSize(COMPLEX_CONTENT_WIDTH, COMPLEX_CONTENT_HEIGHT);
			content.minWidth = COMPLEX_CONTENT_MIN_WIDTH;
			content.minHeight = COMPLEX_CONTENT_MIN_HEIGHT;
			this._headerOrFooterRenderer.data = { content: content };
			this._headerOrFooterRenderer.validate();

			Assert.assertStrictlyEquals("The width of the DefaultGroupedListHeaderOrFooterRenderer was not calculated correctly based on the content width.",
				COMPLEX_CONTENT_WIDTH, this._headerOrFooterRenderer.width);
			Assert.assertStrictlyEquals("The height of the DefaultGroupedListHeaderOrFooterRenderer was not calculated correctly based on the content height.",
				COMPLEX_CONTENT_HEIGHT, this._headerOrFooterRenderer.height);
			Assert.assertStrictlyEquals("The minWidth of the DefaultGroupedListHeaderOrFooterRenderer was not calculated correctly based on the content width.",
				COMPLEX_CONTENT_MIN_WIDTH, this._headerOrFooterRenderer.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the DefaultGroupedListHeaderOrFooterRenderer was not calculated correctly based on the content height.",
				COMPLEX_CONTENT_MIN_HEIGHT, this._headerOrFooterRenderer.minHeight);

			content.dispose();
		}

		[Test]
		public function testAutoSizeWithComplexContentAndPadding():void
		{
			var content:LayoutGroup = new LayoutGroup();
			content.setSize(COMPLEX_CONTENT_WIDTH, COMPLEX_CONTENT_HEIGHT);
			content.minWidth = COMPLEX_CONTENT_MIN_WIDTH;
			content.minHeight = COMPLEX_CONTENT_MIN_HEIGHT;
			this._headerOrFooterRenderer.data = { content: content };
			this._headerOrFooterRenderer.paddingTop = PADDING_TOP;
			this._headerOrFooterRenderer.paddingRight = PADDING_RIGHT;
			this._headerOrFooterRenderer.paddingBottom = PADDING_BOTTOM;
			this._headerOrFooterRenderer.paddingLeft = PADDING_LEFT;
			this._headerOrFooterRenderer.validate();

			Assert.assertStrictlyEquals("The width of the DefaultGroupedListHeaderOrFooterRenderer was not calculated correctly based on the content width and left and right padding.",
				COMPLEX_CONTENT_WIDTH + PADDING_LEFT + PADDING_RIGHT, this._headerOrFooterRenderer.width);
			Assert.assertStrictlyEquals("The height of the DefaultGroupedListHeaderOrFooterRenderer was not calculated correctly based on the content height and top and bottom padding.",
				COMPLEX_CONTENT_HEIGHT + PADDING_TOP + PADDING_BOTTOM, this._headerOrFooterRenderer.height);
			Assert.assertStrictlyEquals("The minWidth of the DefaultGroupedListHeaderOrFooterRenderer was not calculated correctly based on the content width and left and right padding.",
				COMPLEX_CONTENT_MIN_WIDTH + PADDING_LEFT + PADDING_RIGHT, this._headerOrFooterRenderer.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the DefaultGroupedListHeaderOrFooterRenderer was not calculated correctly based on the content height and top and bottom padding.",
				COMPLEX_CONTENT_MIN_HEIGHT + PADDING_TOP + PADDING_BOTTOM, this._headerOrFooterRenderer.minHeight);

			content.dispose();
		}

		[Test]
		public function testAutoSizeWithSimpleBackgroundSkin():void
		{
			this.addSmallSimpleBackground();
			this._headerOrFooterRenderer.validate();

			Assert.assertStrictlyEquals("The width of the DefaultGroupedListHeaderOrFooterRenderer was not calculated correctly based on the background width.",
				SMALL_BACKGROUND_WIDTH, this._headerOrFooterRenderer.width);
			Assert.assertStrictlyEquals("The height of the DefaultGroupedListHeaderOrFooterRenderer was not calculated correctly based on the background height.",
				SMALL_BACKGROUND_HEIGHT, this._headerOrFooterRenderer.height);
			Assert.assertStrictlyEquals("The minWidth of the DefaultGroupedListHeaderOrFooterRenderer was not calculated correctly based on the background width.",
				SMALL_BACKGROUND_WIDTH, this._headerOrFooterRenderer.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the DefaultGroupedListHeaderOrFooterRenderer was not calculated correctly based on the background height.",
				SMALL_BACKGROUND_HEIGHT, this._headerOrFooterRenderer.minHeight);
		}

		[Test]
		public function testAutoSizeWithSmallSimpleBackgroundSkinAndLargeSimpleContent():void
		{
			this.addSmallSimpleBackground();
			var content:Quad = new Quad(LARGE_CONTENT_WIDTH, LARGE_CONTENT_HEIGHT, 0xff00ff);
			this._headerOrFooterRenderer.data = { content: content };
			this._headerOrFooterRenderer.validate();

			Assert.assertStrictlyEquals("The width of the DefaultGroupedListHeaderOrFooterRenderer was not calculated correctly based on the content width.",
				LARGE_CONTENT_WIDTH, this._headerOrFooterRenderer.width);
			Assert.assertStrictlyEquals("The height of the DefaultGroupedListHeaderOrFooterRenderer was not calculated correctly based on the content height.",
				LARGE_CONTENT_HEIGHT, this._headerOrFooterRenderer.height);
			Assert.assertStrictlyEquals("The minWidth of the DefaultGroupedListHeaderOrFooterRenderer was not calculated correctly based on the content width.",
				LARGE_CONTENT_WIDTH, this._headerOrFooterRenderer.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the DefaultGroupedListHeaderOrFooterRenderer was not calculated correctly based on the content height.",
				LARGE_CONTENT_HEIGHT, this._headerOrFooterRenderer.minHeight);

			content.dispose();
		}

		[Test]
		public function testAutoSizeWithLargeSimpleBackgroundSkinAndSmallSimpleContent():void
		{
			this.addLargeSimpleBackground();
			var content:Quad = new Quad(SMALL_CONTENT_WIDTH, SMALL_CONTENT_HEIGHT, 0xff00ff);
			this._headerOrFooterRenderer.data = { content: content };
			this._headerOrFooterRenderer.validate();

			Assert.assertStrictlyEquals("The width of the DefaultGroupedListHeaderOrFooterRenderer was not calculated correctly based on the background width.",
				LARGE_BACKGROUND_WIDTH, this._headerOrFooterRenderer.width);
			Assert.assertStrictlyEquals("The height of the DefaultGroupedListHeaderOrFooterRenderer was not calculated correctly based on the background height.",
				LARGE_BACKGROUND_HEIGHT, this._headerOrFooterRenderer.height);
			Assert.assertStrictlyEquals("The minWidth of the DefaultGroupedListHeaderOrFooterRenderer was not calculated correctly based on the background width.",
				LARGE_BACKGROUND_WIDTH, this._headerOrFooterRenderer.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the DefaultGroupedListHeaderOrFooterRenderer was not calculated correctly based on the background height.",
				LARGE_BACKGROUND_HEIGHT, this._headerOrFooterRenderer.minHeight);
			
			content.dispose();
		}

		[Test]
		public function testAutoSizeWithComplexBackground():void
		{
			this.addComplexBackground();
			this._headerOrFooterRenderer.validate();

			Assert.assertStrictlyEquals("The width of the DefaultGroupedListHeaderOrFooterRenderer was not calculated correctly based on the complex background width.",
				COMPLEX_BACKGROUND_WIDTH, this._headerOrFooterRenderer.width);
			Assert.assertStrictlyEquals("The height of the DefaultGroupedListHeaderOrFooterRenderer was not calculated correctly based on the complex background height.",
				COMPLEX_BACKGROUND_HEIGHT, this._headerOrFooterRenderer.height);
			Assert.assertStrictlyEquals("The minWidth of the DefaultGroupedListHeaderOrFooterRenderer was not calculated correctly based on the complex background minWidth.",
				COMPLEX_BACKGROUND_MIN_WIDTH, this._headerOrFooterRenderer.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the DefaultGroupedListHeaderOrFooterRenderer was not calculated correctly based on the complex background minHeight.",
				COMPLEX_BACKGROUND_MIN_HEIGHT, this._headerOrFooterRenderer.minHeight);
		}
	}
}
