package feathers.tests
{
	import feathers.controls.Header;
	import feathers.controls.text.BitmapFontTextRenderer;
	import feathers.core.ITextRenderer;
	import feathers.layout.HorizontalAlign;

	import org.flexunit.Assert;

	import starling.display.DisplayObject;
	import starling.display.Quad;

	public class HeaderInternalStateTests
	{
		private static const LEFT_ITEM_WIDTH:Number = 12;
		private static const LEFT_ITEM_HEIGHT:Number = 16;
		
		private var _header:Header;
		private var _textRenderer:BitmapFontTextRenderer;

		[Before]
		public function prepare():void
		{
			this._header = new Header();
			this._header.titleFactory = function():ITextRenderer
			{
				var textRenderer:BitmapFontTextRenderer = new BitmapFontTextRenderer();
				textRenderer.name = "title";
				return textRenderer;
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

		[Test]
		public function testBackgroundSkinResizeWhenItemsChangeButDimensionsDoNot():void
		{
			var quad:Quad = new Quad(LEFT_ITEM_WIDTH, LEFT_ITEM_HEIGHT, 0x00ff00);
			var backgroundSkin:Quad = new Quad(1, 1, 0xff00ff);
			this._header.backgroundSkin = backgroundSkin;
			this._header.leftItems = new <DisplayObject>[quad];
			this._header.validate();
			this._header.leftItems = new <DisplayObject>[quad];
			this._header.validate();
			Assert.assertStrictlyEquals("The Header backgroundSkin width was not resized correctly when changing the items",
				LEFT_ITEM_WIDTH, backgroundSkin.width);
			Assert.assertStrictlyEquals("The Header backgroundSkin height was not resized correctly when changing the items",
				LEFT_ITEM_HEIGHT, backgroundSkin.height);
			quad.dispose();
		}

		[Test]
		public function testBackgroundSkinResizeWhenExplicitDimensionsChange():void
		{
			var backgroundSkin:Quad = new Quad(1, 1, 0xff00ff);
			this._header.backgroundSkin = backgroundSkin;
			this._header.validate();
			this._header.setSize(LEFT_ITEM_WIDTH, LEFT_ITEM_HEIGHT);
			this._header.validate();
			Assert.assertStrictlyEquals("The Header backgroundSkin width was not resized correctly when setting dimensions explicitly",
				LEFT_ITEM_WIDTH, backgroundSkin.width);
			Assert.assertStrictlyEquals("The Header backgroundSkin height was not resized correctly when setting dimensions explicitly",
				LEFT_ITEM_HEIGHT, backgroundSkin.height);

			this._header.width = NaN;
			this._header.height = NaN;
			this._header.validate();
			Assert.assertStrictlyEquals("The Header backgroundSkin width was not resized correctly after reset dimensions to auto-size",
				1, backgroundSkin.width);
			Assert.assertStrictlyEquals("The Header backgroundSkin height was not resized correctly when reset dimensions to auto-size",
				1, backgroundSkin.height);
		}

		[Test]
		public function testBackgroundSkinResizeWhenTitleChanges():void
		{
			var title:String = "I am the very model of a modern major general";

			this._textRenderer.text = title;
			this._textRenderer.validate();
			
			var backgroundSkin:Quad = new Quad(1, 1, 0xff00ff);
			this._header.backgroundSkin = backgroundSkin;
			this._header.validate();
			this._header.title = title;
			this._header.validate();
			Assert.assertStrictlyEquals("The Header backgroundSkin width was not resized correctly when changing to larger title",
				this._textRenderer.width, backgroundSkin.width);
			Assert.assertStrictlyEquals("The Header backgroundSkin height was not resized correctly when changing to larger title",
				this._textRenderer.height, backgroundSkin.height);
			
			title = "I am the very model";
			this._textRenderer.text = title;
			this._textRenderer.validate();
			this._header.title = title;
			this._header.validate();
			Assert.assertStrictlyEquals("The Header backgroundSkin width was not resized correctly when changing to smaller title",
				this._textRenderer.width, backgroundSkin.width);
			Assert.assertStrictlyEquals("The Header backgroundSkin height was not resized correctly when changing to smaller title",
				this._textRenderer.height, backgroundSkin.height);
		}

		[Test]
		public function testTitleHiddenWithTitleAlignCenterAndCenterItemsNotEmpty():void
		{
			var centerItem:Quad = new Quad(10, 10, 0xff00ff);
			this._header.title = "Header";
			this._header.titleAlign = HorizontalAlign.CENTER;
			this._header.centerItems = new <DisplayObject>[centerItem];
			this._header.validate();
			Assert.assertFalse("Header title not hidden when titleAlign is HorizontalAlign.CENTER and centerItems is not empty.",
				this._header.getChildByName("title").visible);
			centerItem.dispose();
		}

		[Test]
		public function testTitleHiddenWithTitleAlignLeftAndLeftItemNotEmptyAndCenterItemsNotEmpty():void
		{
			var leftItem:Quad = new Quad(10, 10, 0xff00ff);
			var centerItem:Quad = new Quad(10, 10, 0xff00ff);
			this._header.title = "Header";
			this._header.titleAlign = HorizontalAlign.LEFT;
			this._header.leftItems = new <DisplayObject>[leftItem];
			this._header.centerItems = new <DisplayObject>[centerItem];
			this._header.validate();
			Assert.assertFalse("Header title not hidden when titleAlign is HorizontalAlign.LEFT and both leftItems and centerItems are not empty.",
				this._header.getChildByName("title").visible);
			leftItem.dispose();
			centerItem.dispose();
		}

		[Test]
		public function testTitleHiddenWithTitleAlignRightAndRightItemsNotEmptyAndCenterItemsNotEmpty():void
		{
			var rightItem:Quad = new Quad(10, 10, 0xff00ff);
			var centerItem:Quad = new Quad(10, 10, 0xff00ff);
			this._header.title = "Header";
			this._header.titleAlign = HorizontalAlign.RIGHT;
			this._header.rightItems = new <DisplayObject>[rightItem];
			this._header.centerItems = new <DisplayObject>[centerItem];
			this._header.validate();
			Assert.assertFalse("Header title not hidden when titleAlign is HorizontalAlign.RIGHT and both rightItems and centerItems are not empty.",
				this._header.getChildByName("title").visible);
			rightItem.dispose();
			centerItem.dispose();
		}

		[Test]
		public function testTitleNotHiddenWithTitleAlignRightAndRightItemsNotEmptyButCenterItemsIsEmpty():void
		{
			var rightItem:Quad = new Quad(10, 10, 0xff00ff);
			var centerItem:Quad = new Quad(10, 10, 0xff00ff);
			this._header.title = "Header";
			this._header.titleAlign = HorizontalAlign.RIGHT;
			this._header.rightItems = new <DisplayObject>[rightItem];
			this._header.validate();
			Assert.assertTrue("Header title incorrectly hidden when titleAlign is HorizontalAlign.RIGHT and rightItems is not empty but centerItems is empty.",
				this._header.getChildByName("title").visible);
			rightItem.dispose();
			centerItem.dispose();
		}

		[Test]
		public function testTitleNotHiddenWithTitleAlignLeftAndLeftItemsNotEmptyButCenterItemsIsEmpty():void
		{
			var leftItem:Quad = new Quad(10, 10, 0xff00ff);
			var centerItem:Quad = new Quad(10, 10, 0xff00ff);
			this._header.title = "Header";
			this._header.titleAlign = HorizontalAlign.LEFT;
			this._header.leftItems = new <DisplayObject>[leftItem];
			this._header.validate();
			Assert.assertTrue("Header title incorrectly hidden when titleAlign is HorizontalAlign.LEFT and leftItems is not empty but centerItems is empty.",
				this._header.getChildByName("title").visible);
			leftItem.dispose();
			centerItem.dispose();
		}
	}
}
