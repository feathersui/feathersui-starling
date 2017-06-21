package feathers.tests
{
	import feathers.controls.LayoutGroup;
	import feathers.controls.List;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.text.BitmapFontTextRenderer;

	import org.flexunit.Assert;

	import starling.display.Quad;

	public class DefaultListItemRendererMeasurementTests
	{
		private static const SMALL_BACKGROUND_WIDTH:Number = 10;
		private static const SMALL_BACKGROUND_HEIGHT:Number = 12;
		private static const LARGE_BACKGROUND_WIDTH:Number = 100;
		private static const LARGE_BACKGROUND_HEIGHT:Number = 110;
		private static const COMPLEX_BACKGROUND_WIDTH:Number = 54;
		private static const COMPLEX_BACKGROUND_HEIGHT:Number = 55;
		private static const COMPLEX_BACKGROUND_MIN_WIDTH:Number = 38;
		private static const COMPLEX_BACKGROUND_MIN_HEIGHT:Number = 39;

		private static const SMALL_ICON_WIDTH:Number = 13;
		private static const SMALL_ICON_HEIGHT:Number = 11;
		private static const LARGE_ICON_WIDTH:Number = 105;
		private static const LARGE_ICON_HEIGHT:Number = 115;
		private static const COMPLEX_ICON_WIDTH:Number = 23;
		private static const COMPLEX_ICON_HEIGHT:Number = 25;
		private static const COMPLEX_ICON_MIN_WIDTH:Number = 18;
		private static const COMPLEX_ICON_MIN_HEIGHT:Number = 19;

		private static const SMALL_ACCESSORY_WIDTH:Number = 14;
		private static const SMALL_ACCESSORY_HEIGHT:Number = 12;
		private static const LARGE_ACCESSORY_WIDTH:Number = 106;
		private static const LARGE_ACCESSORY_HEIGHT:Number = 116;
		private static const COMPLEX_ACCESSORY_WIDTH:Number = 24;
		private static const COMPLEX_ACCESSORY_HEIGHT:Number = 26;
		private static const COMPLEX_ACCESSORY_MIN_WIDTH:Number = 19;
		private static const COMPLEX_ACCESSORY_MIN_HEIGHT:Number = 20;

		private static const PADDING_TOP:Number = 50;
		private static const PADDING_RIGHT:Number = 54;
		private static const PADDING_BOTTOM:Number = 59;
		private static const PADDING_LEFT:Number = 60;
		private static const GAP:Number = 6;
		
		private var _itemRenderer:DefaultListItemRenderer;
		private var _textRenderer:BitmapFontTextRenderer;
		private var _list:List;

		[Before]
		public function prepare():void
		{
			this._list = new List();

			this._itemRenderer = new DefaultListItemRenderer();
			this._itemRenderer.owner = this._list;
			this._itemRenderer.index = 0;
			this._itemRenderer.data = {};
			this._itemRenderer.useStateDelayTimer = false;
			this._itemRenderer.labelFactory = function():BitmapFontTextRenderer
			{
				return new BitmapFontTextRenderer();
			};
			TestFeathers.starlingRoot.addChild(this._itemRenderer);

			this._textRenderer = new BitmapFontTextRenderer();
			TestFeathers.starlingRoot.addChild(this._textRenderer);
		}

		[After]
		public function cleanup():void
		{
			this._itemRenderer.removeFromParent(true);
			this._itemRenderer = null;

			this._list.dispose();
			this._list = null;

			this._textRenderer.removeFromParent(true);
			this._textRenderer = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		private function addSmallSimpleAccessory():void
		{
			this._itemRenderer.itemHasAccessory = false;
			this._itemRenderer.defaultAccessory = new Quad(SMALL_ACCESSORY_WIDTH, SMALL_ACCESSORY_HEIGHT, 0xff00ff);
		}

		private function addLargeSimpleAccessory():void
		{
			this._itemRenderer.itemHasAccessory = false;
			this._itemRenderer.defaultAccessory = new Quad(LARGE_ACCESSORY_WIDTH, LARGE_ACCESSORY_HEIGHT, 0xff00ff);
		}

		private function addComplexAccessory():void
		{
			this._itemRenderer.itemHasAccessory = false;
			var icon:LayoutGroup = new LayoutGroup();
			icon.width = COMPLEX_ACCESSORY_WIDTH;
			icon.height = COMPLEX_ACCESSORY_HEIGHT;
			icon.minWidth = COMPLEX_ACCESSORY_MIN_WIDTH;
			icon.minHeight = COMPLEX_ACCESSORY_MIN_HEIGHT;
			this._itemRenderer.defaultAccessory = icon;
		}

		private function addComplexAutoSizingAccessory():void
		{
			this._itemRenderer.itemHasAccessory = false;
			var icon:LayoutGroup = new LayoutGroup();
			icon.backgroundSkin = new Quad(COMPLEX_ACCESSORY_WIDTH, COMPLEX_ACCESSORY_HEIGHT);
			this._itemRenderer.defaultAccessory = icon;
		}

		private function addSmallSimpleIcon():void
		{
			this._itemRenderer.itemHasIcon = false;
			this._itemRenderer.defaultIcon = new Quad(SMALL_ICON_WIDTH, SMALL_ICON_HEIGHT, 0xff00ff);
		}

		private function addLargeSimpleIcon():void
		{
			this._itemRenderer.itemHasIcon = false;
			this._itemRenderer.defaultIcon = new Quad(LARGE_ICON_WIDTH, LARGE_ICON_HEIGHT, 0xff00ff);
		}

		private function addComplexIcon():void
		{
			this._itemRenderer.itemHasIcon = false;
			var icon:LayoutGroup = new LayoutGroup();
			icon.width = COMPLEX_ICON_WIDTH;
			icon.height = COMPLEX_ICON_HEIGHT;
			icon.minWidth = COMPLEX_ICON_MIN_WIDTH;
			icon.minHeight = COMPLEX_ICON_MIN_HEIGHT;
			this._itemRenderer.defaultIcon = icon;
		}

		private function addComplexAutoSizingIcon():void
		{
			this._itemRenderer.itemHasIcon = false;
			var icon:LayoutGroup = new LayoutGroup();
			icon.backgroundSkin = new Quad(COMPLEX_ICON_WIDTH, COMPLEX_ICON_HEIGHT);
			this._itemRenderer.defaultIcon = icon;
		}

		private function addSmallSimpleBackground():void
		{
			this._itemRenderer.itemHasSkin = false;
			this._itemRenderer.defaultSkin = new Quad(SMALL_BACKGROUND_WIDTH, SMALL_BACKGROUND_HEIGHT, 0xff00ff);
		}

		private function addLargeSimpleBackground():void
		{
			this._itemRenderer.itemHasSkin = false;
			this._itemRenderer.defaultSkin = new Quad(LARGE_BACKGROUND_WIDTH, LARGE_BACKGROUND_HEIGHT, 0xff00ff);
		}

		private function addComplexBackground():void
		{
			this._itemRenderer.itemHasSkin = false;
			var backgroundSkin:LayoutGroup = new LayoutGroup();
			backgroundSkin.width = COMPLEX_BACKGROUND_WIDTH;
			backgroundSkin.height = COMPLEX_BACKGROUND_HEIGHT;
			backgroundSkin.minWidth = COMPLEX_BACKGROUND_MIN_WIDTH;
			backgroundSkin.minHeight = COMPLEX_BACKGROUND_MIN_HEIGHT;
			this._itemRenderer.defaultSkin = backgroundSkin;
		}

		[Test]
		public function testAutoSizeWithPadding():void
		{
			this._itemRenderer.hasLabelTextRenderer = false;
			this._itemRenderer.paddingTop = PADDING_TOP;
			this._itemRenderer.paddingRight = PADDING_RIGHT;
			this._itemRenderer.paddingBottom = PADDING_BOTTOM;
			this._itemRenderer.paddingLeft = PADDING_LEFT;
			this._itemRenderer.validate();

			Assert.assertStrictlyEquals("The width of the DefaultListItemRenderer was not calculated correctly based on the left and right padding.",
				PADDING_LEFT + PADDING_RIGHT, this._itemRenderer.width);
			Assert.assertStrictlyEquals("The height of the DefaultListItemRenderer was not calculated correctly based on the top and bottom padding.",
				PADDING_TOP + PADDING_BOTTOM, this._itemRenderer.height);
			Assert.assertStrictlyEquals("The minWidth of the DefaultListItemRenderer was not calculated correctly based on the left and right padding.",
				PADDING_LEFT + PADDING_RIGHT, this._itemRenderer.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the DefaultListItemRenderer was not calculated correctly based on the top and bottom padding.",
				PADDING_TOP + PADDING_BOTTOM, this._itemRenderer.minHeight);
		}

		[Test]
		public function testAutoSizeWithLabel():void
		{
			var labelText:String = "I am the very model of a modern major general";
			this._textRenderer.text = labelText;
			this._textRenderer.validate();

			this._itemRenderer.data = { label: labelText };
			this._itemRenderer.validate();

			Assert.assertTrue("The width of the DefaultListItemRenderer was not greater than 0 when using a label.",
				this._itemRenderer.width > 0);
			Assert.assertTrue("The height of the DefaultListItemRenderer was not greater than 0 when using a label.",
				this._itemRenderer.height > 0);
			Assert.assertTrue("The minWidth of the DefaultListItemRenderer was not greater than 0 when using a label.",
				this._itemRenderer.minWidth > 0);
			Assert.assertTrue("The minHeight of the DefaultListItemRenderer was not greater than 0 when using a label.",
				this._itemRenderer.minHeight > 0);
			Assert.assertStrictlyEquals("The width of the DefaultListItemRenderer was not calculated correctly based on the label.",
				this._textRenderer.width, this._itemRenderer.width);
			Assert.assertStrictlyEquals("The height of the DefaultListItemRenderer was not calculated correctly based on the label.",
				this._textRenderer.height, this._itemRenderer.height);
			Assert.assertStrictlyEquals("The minWidth of the DefaultListItemRenderer was not calculated correctly based on the label.",
				this._textRenderer.width, this._itemRenderer.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the DefaultListItemRenderer was not calculated correctly based on the label.",
				this._textRenderer.height, this._itemRenderer.minHeight);
		}

		[Test]
		public function testAutoSizeWithLabelAndPadding():void
		{
			var labelText:String = "I am the very model of a modern major general";
			this._textRenderer.text = labelText;
			this._textRenderer.validate();

			this._itemRenderer.data = { label: labelText };
			this._itemRenderer.paddingTop = PADDING_TOP;
			this._itemRenderer.paddingRight = PADDING_RIGHT;
			this._itemRenderer.paddingBottom = PADDING_BOTTOM;
			this._itemRenderer.paddingLeft = PADDING_LEFT;
			this._itemRenderer.validate();

			Assert.assertStrictlyEquals("The width of the DefaultListItemRenderer was not calculated correctly based on the label and left and right padding.",
				this._textRenderer.width + PADDING_LEFT + PADDING_RIGHT, this._itemRenderer.width);
			Assert.assertStrictlyEquals("The height of the DefaultListItemRenderer was not calculated correctly based on the label and top and bottom padding.",
				this._textRenderer.height + PADDING_TOP + PADDING_BOTTOM, this._itemRenderer.height);
			Assert.assertStrictlyEquals("The minWidth of the DefaultListItemRenderer was not calculated correctly based on the label and left and right padding.",
				this._textRenderer.width + PADDING_LEFT + PADDING_RIGHT, this._itemRenderer.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the DefaultListItemRenderer was not calculated correctly based on the label and top and bottom padding.",
				this._textRenderer.height + PADDING_TOP + PADDING_BOTTOM, this._itemRenderer.minHeight);
		}

		[Test]
		public function testAutoSizeWithLabelAndSimpleIcon():void
		{
			var labelText:String = "I am the very model of a modern major general";
			this._textRenderer.text = labelText;
			this._textRenderer.validate();

			this.addLargeSimpleIcon();
			this._itemRenderer.data = { label: labelText };
			this._itemRenderer.validate();

			Assert.assertStrictlyEquals("The width of the DefaultListItemRenderer was not calculated correctly based on the label and icon.",
				this._textRenderer.width + LARGE_ICON_WIDTH, this._itemRenderer.width);
			Assert.assertStrictlyEquals("The height of the DefaultListItemRenderer was not calculated correctly based on the label and icon.",
				LARGE_ICON_HEIGHT, this._itemRenderer.height);
			Assert.assertStrictlyEquals("The minWidth of the DefaultListItemRenderer was not calculated correctly based on the label and icon.",
				this._textRenderer.width + LARGE_ICON_WIDTH, this._itemRenderer.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the DefaultListItemRenderer was not calculated correctly based on the label and icon.",
				LARGE_ICON_HEIGHT, this._itemRenderer.minHeight);
		}

		[Test]
		public function testAutoSizeWithLabelGapAndSimpleIcon():void
		{
			var labelText:String = "I am the very model of a modern major general";
			this._textRenderer.text = labelText;
			this._textRenderer.validate();

			this.addLargeSimpleIcon();
			this._itemRenderer.data = { label: labelText };
			this._itemRenderer.gap = GAP;
			this._itemRenderer.validate();

			Assert.assertStrictlyEquals("The width of the DefaultListItemRenderer was not calculated correctly based on the label, gap, and icon.",
				this._textRenderer.width + GAP + LARGE_ICON_WIDTH, this._itemRenderer.width);
			Assert.assertStrictlyEquals("The height of the DefaultListItemRenderer was not calculated correctly based on the label, gap, and icon.",
				LARGE_ICON_HEIGHT, this._itemRenderer.height);
			Assert.assertStrictlyEquals("The minWidth of the DefaultListItemRenderer was not calculated correctly based on the label, gap, and icon.",
				this._textRenderer.width + GAP + LARGE_ICON_WIDTH, this._itemRenderer.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the DefaultListItemRenderer was not calculated correctly based on the label, and icon.",
				LARGE_ICON_HEIGHT, this._itemRenderer.minHeight);
		}

		[Test]
		public function testAutoSizeWithLabelGapPaddingAndSimpleIcon():void
		{
			var labelText:String = "I am the very model of a modern major general";
			this._textRenderer.text = labelText;
			this._textRenderer.validate();

			this.addLargeSimpleIcon();
			this._itemRenderer.data = { label: labelText };
			this._itemRenderer.paddingTop = PADDING_TOP;
			this._itemRenderer.paddingRight = PADDING_RIGHT;
			this._itemRenderer.paddingBottom = PADDING_BOTTOM;
			this._itemRenderer.paddingLeft = PADDING_LEFT;
			this._itemRenderer.gap = GAP;
			this._itemRenderer.validate();

			Assert.assertStrictlyEquals("The width of the DefaultListItemRenderer was not calculated correctly based on the label, gap, left and right padding, and icon.",
				this._textRenderer.width + GAP + LARGE_ICON_WIDTH + PADDING_LEFT + PADDING_RIGHT, this._itemRenderer.width);
			Assert.assertStrictlyEquals("The height of the DefaultListItemRenderer was not calculated correctly based on the label, gap, top and bottom padding, and icon.",
				LARGE_ICON_HEIGHT + PADDING_TOP + PADDING_BOTTOM, this._itemRenderer.height);
			Assert.assertStrictlyEquals("The minWidth of the DefaultListItemRenderer was not calculated correctly based on the label, gap, left and right padding, and icon.",
				this._textRenderer.width + GAP + LARGE_ICON_WIDTH + PADDING_LEFT + PADDING_RIGHT, this._itemRenderer.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the DefaultListItemRenderer was not calculated correctly based on the label, gap, top and bottom padding, and icon.",
				LARGE_ICON_HEIGHT + PADDING_TOP + PADDING_BOTTOM, this._itemRenderer.minHeight);
		}

		[Test]
		public function testAutoSizeWithSimpleIcon():void
		{
			this.addLargeSimpleIcon();
			this._itemRenderer.hasLabelTextRenderer = false;
			this._itemRenderer.validate();

			Assert.assertStrictlyEquals("The width of the DefaultListItemRenderer was not calculated correctly based on the icon width.",
				LARGE_ICON_WIDTH, this._itemRenderer.width);
			Assert.assertStrictlyEquals("The height of the DefaultListItemRenderer was not calculated correctly based on the icon height.",
				LARGE_ICON_HEIGHT, this._itemRenderer.height);
			Assert.assertStrictlyEquals("The minWidth of the DefaultListItemRenderer was not calculated correctly based on the icon width.",
				LARGE_ICON_WIDTH, this._itemRenderer.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the DefaultListItemRenderer was not calculated correctly based on the icon height.",
				LARGE_ICON_HEIGHT, this._itemRenderer.minHeight);
		}

		[Test]
		public function testAutoSizeWithComplexIcon():void
		{
			this.addComplexIcon();
			this._itemRenderer.hasLabelTextRenderer = false;
			this._itemRenderer.validate();

			Assert.assertStrictlyEquals("The width of the DefaultListItemRenderer was not calculated correctly based on the complex icon width.",
				COMPLEX_ICON_WIDTH, this._itemRenderer.width);
			Assert.assertStrictlyEquals("The height of the DefaultListItemRenderer was not calculated correctly based on the complex icon height.",
				COMPLEX_ICON_HEIGHT, this._itemRenderer.height);

			//the item renderer never resizes the icon, so we ignore its minimum
			//dimensions
			Assert.assertStrictlyEquals("The minWidth of the DefaultListItemRenderer was not calculated correctly based on the complex icon minWidth.",
				COMPLEX_ICON_WIDTH, this._itemRenderer.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the DefaultListItemRenderer was not calculated correctly based on the complex icon minHeight.",
				COMPLEX_ICON_HEIGHT, this._itemRenderer.minHeight);
		}

		[Test]
		public function testAutoSizeWithComplexAutoSizingIcon():void
		{
			this.addComplexAutoSizingIcon();
			this._itemRenderer.hasLabelTextRenderer = false;
			this._itemRenderer.validate();

			Assert.assertStrictlyEquals("The width of the DefaultListItemRenderer was not calculated correctly based on the complex icon width.",
				COMPLEX_ICON_WIDTH, this._itemRenderer.width);
			Assert.assertStrictlyEquals("The height of the DefaultListItemRenderer was not calculated correctly based on the complex icon height.",
				COMPLEX_ICON_HEIGHT, this._itemRenderer.height);
			
			//the item renderer never resizes the icon, so we ignore its
			//minimum dimensions
			Assert.assertStrictlyEquals("The minWidth of the DefaultListItemRenderer was not calculated correctly based on the complex icon minWidth.",
				COMPLEX_ICON_WIDTH, this._itemRenderer.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the DefaultListItemRenderer was not calculated correctly based on the complex icon minHeight.",
				COMPLEX_ICON_HEIGHT, this._itemRenderer.minHeight);
		}

		[Test]
		public function testAutoSizeWithSimpleAccessory():void
		{
			this.addLargeSimpleAccessory();
			this._itemRenderer.hasLabelTextRenderer = false;
			this._itemRenderer.validate();

			Assert.assertStrictlyEquals("The width of the DefaultListItemRenderer was not calculated correctly based on the accessory width.",
				LARGE_ACCESSORY_WIDTH, this._itemRenderer.width);
			Assert.assertStrictlyEquals("The height of the DefaultListItemRenderer was not calculated correctly based on the accessory height.",
				LARGE_ACCESSORY_HEIGHT, this._itemRenderer.height);
			Assert.assertStrictlyEquals("The minWidth of the DefaultListItemRenderer was not calculated correctly based on the accessory width.",
				LARGE_ACCESSORY_WIDTH, this._itemRenderer.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the DefaultListItemRenderer was not calculated correctly based on the accessory height.",
				LARGE_ACCESSORY_HEIGHT, this._itemRenderer.minHeight);
		}

		[Test]
		public function testAutoSizeWithComplexAccessory():void
		{
			this.addComplexAccessory();
			this._itemRenderer.hasLabelTextRenderer = false;
			this._itemRenderer.validate();

			Assert.assertStrictlyEquals("The width of the DefaultListItemRenderer was not calculated correctly based on the complex accessory width.",
				COMPLEX_ACCESSORY_WIDTH, this._itemRenderer.width);
			Assert.assertStrictlyEquals("The height of the DefaultListItemRenderer was not calculated correctly based on the complex accessory height.",
				COMPLEX_ACCESSORY_HEIGHT, this._itemRenderer.height);
			
			//the item renderer never resizes the accessory, so we ignore its
			//minimum dimensions
			Assert.assertStrictlyEquals("The minWidth of the DefaultListItemRenderer was not calculated correctly based on the complex accessory minWidth.",
				COMPLEX_ACCESSORY_WIDTH, this._itemRenderer.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the DefaultListItemRenderer was not calculated correctly based on the complex accessory minHeight.",
				COMPLEX_ACCESSORY_HEIGHT, this._itemRenderer.minHeight);
		}

		[Test]
		public function testAutoSizeWithComplexAutoSizingAccessory():void
		{
			this.addComplexAutoSizingAccessory();
			this._itemRenderer.hasLabelTextRenderer = false;
			this._itemRenderer.validate();

			Assert.assertStrictlyEquals("The width of the DefaultListItemRenderer was not calculated correctly based on the complex accessory width.",
				COMPLEX_ACCESSORY_WIDTH, this._itemRenderer.width);
			Assert.assertStrictlyEquals("The height of the DefaultListItemRenderer was not calculated correctly based on the complex accessory height.",
				COMPLEX_ACCESSORY_HEIGHT, this._itemRenderer.height);
			
			//the item renderer never resizes the accessory, so we ignore its
			//minimum dimensions
			Assert.assertStrictlyEquals("The minWidth of the DefaultListItemRenderer was not calculated correctly based on the complex accessory minWidth.",
				COMPLEX_ACCESSORY_WIDTH, this._itemRenderer.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the DefaultListItemRenderer was not calculated correctly based on the complex accessory minHeight.",
				COMPLEX_ACCESSORY_HEIGHT, this._itemRenderer.minHeight);
		}

		[Test]
		public function testAutoSizeWithSimpleBackgroundSkin():void
		{
			this.addSmallSimpleBackground();
			this._itemRenderer.hasLabelTextRenderer = false;
			this._itemRenderer.validate();

			Assert.assertStrictlyEquals("The width of the DefaultListItemRenderer was not calculated correctly based on the background width.",
				SMALL_BACKGROUND_WIDTH, this._itemRenderer.width);
			Assert.assertStrictlyEquals("The height of the DefaultListItemRenderer was not calculated correctly based on the background height.",
				SMALL_BACKGROUND_HEIGHT, this._itemRenderer.height);
			Assert.assertStrictlyEquals("The minWidth of the DefaultListItemRenderer was not calculated correctly based on the background width.",
				SMALL_BACKGROUND_WIDTH, this._itemRenderer.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the DefaultListItemRenderer was not calculated correctly based on the background height.",
				SMALL_BACKGROUND_HEIGHT, this._itemRenderer.minHeight);
		}

		[Test]
		public function testAutoSizeWithSmallSimpleBackgroundSkinAndLargeSimpleIcon():void
		{
			this.addSmallSimpleBackground();
			this.addLargeSimpleIcon();
			this._itemRenderer.hasLabelTextRenderer = false;
			this._itemRenderer.validate();

			Assert.assertStrictlyEquals("The width of the DefaultListItemRenderer was not calculated correctly based on the icon width.",
				LARGE_ICON_WIDTH, this._itemRenderer.width);
			Assert.assertStrictlyEquals("The height of the DefaultListItemRenderer was not calculated correctly based on the icon height.",
				LARGE_ICON_HEIGHT, this._itemRenderer.height);
			Assert.assertStrictlyEquals("The minWidth of the DefaultListItemRenderer was not calculated correctly based on the icon width.",
				LARGE_ICON_WIDTH, this._itemRenderer.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the DefaultListItemRenderer was not calculated correctly based on the icon height.",
				LARGE_ICON_HEIGHT, this._itemRenderer.minHeight);
		}

		[Test]
		public function testAutoSizeWithLargeSimpleBackgroundSkinAndSmallSimpleIcon():void
		{
			this.addLargeSimpleBackground();
			this.addSmallSimpleIcon();
			this._itemRenderer.hasLabelTextRenderer = false;
			this._itemRenderer.validate();

			Assert.assertStrictlyEquals("The width of the DefaultListItemRenderer was not calculated correctly based on the background width.",
				LARGE_BACKGROUND_WIDTH, this._itemRenderer.width);
			Assert.assertStrictlyEquals("The height of the DefaultListItemRenderer was not calculated correctly based on the background height.",
				LARGE_BACKGROUND_HEIGHT, this._itemRenderer.height);
			Assert.assertStrictlyEquals("The minWidth of the DefaultListItemRenderer was not calculated correctly based on the background width.",
				LARGE_BACKGROUND_WIDTH, this._itemRenderer.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the DefaultListItemRenderer was not calculated correctly based on the background height.",
				LARGE_BACKGROUND_HEIGHT, this._itemRenderer.minHeight);
		}

		[Test]
		public function testAutoSizeWithComplexBackground():void
		{
			this.addComplexBackground();
			this._itemRenderer.hasLabelTextRenderer = false;
			this._itemRenderer.validate();

			Assert.assertStrictlyEquals("The width of the DefaultListItemRenderer was not calculated correctly based on the complex background width.",
				COMPLEX_BACKGROUND_WIDTH, this._itemRenderer.width);
			Assert.assertStrictlyEquals("The height of the DefaultListItemRenderer was not calculated correctly based on the complex background height.",
				COMPLEX_BACKGROUND_HEIGHT, this._itemRenderer.height);
			Assert.assertStrictlyEquals("The minWidth of the DefaultListItemRenderer was not calculated correctly based on the complex background minWidth.",
				COMPLEX_BACKGROUND_MIN_WIDTH, this._itemRenderer.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the DefaultListItemRenderer was not calculated correctly based on the complex background minHeight.",
				COMPLEX_BACKGROUND_MIN_HEIGHT, this._itemRenderer.minHeight);
		}
	}
}
