package feathers.tests
{
	import feathers.controls.Button;
	import feathers.controls.LayoutGroup;
	import feathers.tests.supportClasses.DisposeFlagQuad;

	import org.flexunit.Assert;

	import starling.display.Quad;
	import starling.events.Event;

	public class LayoutGroupTests
	{
		//note: the background width is purposefully smaller than the item width
		private static const BACKGROUND_WIDTH:Number = 200;
		//note: the background height is purposefully larger than the item height
		private static const BACKGROUND_HEIGHT:Number = 250;

		//note: the item width is purposefully larger than the background width
		private static const ITEM_WIDTH:Number = 210;
		//note: the item height is purposefully smaller than the background height
		private static const ITEM_HEIGHT:Number = 160;

		private var _group:LayoutGroup;

		[Before]
		public function prepare():void
		{
			this._group = new LayoutGroup();
			TestFeathers.starlingRoot.addChild(this._group);
			this._group.validate();
		}

		[After]
		public function cleanup():void
		{
			this._group.removeFromParent(true);
			this._group = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testAutoSizeWithBackground():void
		{
			this._group.backgroundSkin = new Quad(BACKGROUND_WIDTH, BACKGROUND_HEIGHT);
			this._group.validate();
			Assert.assertStrictlyEquals("The width of the layout group was not calculated correctly.",
				BACKGROUND_WIDTH, this._group.width);
			Assert.assertStrictlyEquals("The height of the layout group was not calculated correctly.",
				BACKGROUND_HEIGHT, this._group.height);
		}

		[Test]
		public function testAutoSizeWithChildAtOrigin():void
		{
			this._group.addChild(new Quad(ITEM_WIDTH, ITEM_HEIGHT));
			this._group.validate();
			Assert.assertStrictlyEquals("The width of the layout group was not calculated correctly.",
				ITEM_WIDTH, this._group.width);
			Assert.assertStrictlyEquals("The height of the layout group was not calculated correctly.",
				ITEM_HEIGHT, this._group.height);
		}

		[Test]
		public function testAutoSizeWithChild():void
		{
			var child:Quad = new Quad(ITEM_WIDTH, ITEM_HEIGHT);
			child.x = 120;
			child.y = 130;
			this._group.addChild(child);
			this._group.validate();
			Assert.assertStrictlyEquals("The width of the layout group was not calculated correctly.",
				child.x + ITEM_WIDTH, this._group.width);
			Assert.assertStrictlyEquals("The height of the layout group was not calculated correctly.",
				child.y + ITEM_HEIGHT, this._group.height);
		}

		[Test]
		public function testAutoSizeWithChildPositionedWithBoundsFullyInNegative():void
		{
			var child:Quad = new Quad(ITEM_WIDTH, ITEM_HEIGHT);
			child.x = -420;
			child.y = -430;
			this._group.addChild(child);
			this._group.validate();
			Assert.assertStrictlyEquals("The width of the layout group was not calculated correctly.",
				0, this._group.width);
			Assert.assertStrictlyEquals("The height of the layout group was not calculated correctly.",
				0, this._group.height);
		}

		[Test]
		public function testAutoSizeWithChildPositionedWithBoundsInBothPositiveAndNegative():void
		{
			var child:Quad = new Quad(ITEM_WIDTH, ITEM_HEIGHT);
			child.x = -Math.round(ITEM_WIDTH / 4);
			child.y = -Math.round(ITEM_HEIGHT / 3);
			this._group.addChild(child);
			this._group.validate();
			Assert.assertStrictlyEquals("The width of the layout group was not calculated correctly.",
				child.x + ITEM_WIDTH, this._group.width);
			Assert.assertStrictlyEquals("The height of the layout group was not calculated correctly.",
				child.y + ITEM_HEIGHT, this._group.height);
		}

		[Test]
		public function testAutoSizeWithMultipleChildren():void
		{
			var child1:Quad = new Quad(ITEM_WIDTH, ITEM_HEIGHT);
			child1.x = 0;
			child1.y = 130;
			this._group.addChild(child1);
			var child2:Quad = new Quad(ITEM_WIDTH, ITEM_HEIGHT);
			child2.x = 120;
			child2.y = 0;
			this._group.addChild(child2);
			this._group.validate();
			Assert.assertStrictlyEquals("The width of the layout group was not calculated correctly.",
				child2.x + ITEM_WIDTH, this._group.width);
			Assert.assertStrictlyEquals("The height of the layout group was not calculated correctly.",
				child1.y + ITEM_HEIGHT, this._group.height);
		}

		[Test]
		public function testAutoSizeChildAndBackground():void
		{
			this._group.addChild(new Quad(ITEM_WIDTH, ITEM_HEIGHT));
			this._group.backgroundSkin = new Quad(BACKGROUND_WIDTH, BACKGROUND_HEIGHT);
			this._group.validate();
			Assert.assertStrictlyEquals("The width of the layout group was not calculated correctly.",
				ITEM_WIDTH, this._group.width);
			Assert.assertStrictlyEquals("The height of the layout group was not calculated correctly.",
				BACKGROUND_HEIGHT, this._group.height);
		}

		[Test]
		public function testResizeWhenAddingChild():void
		{
			var originalWidth:Number = this._group.width;
			var originalHeight:Number = this._group.height;
			var hasResized:Boolean = false;
			this._group.addEventListener(Event.RESIZE, function(event:Event):void
			{
				hasResized = true;
			});
			this._group.addChild(new Quad(ITEM_WIDTH, ITEM_HEIGHT));
			this._group.validate();
			Assert.assertTrue("Event.RESIZE was not dispatched", hasResized);
			Assert.assertFalse("The width of the layout group was not changed.",
				originalWidth === this._group.width);
			Assert.assertFalse("The height of the layout group was not changed.",
				originalHeight === this._group.height);
		}

		[Test]
		public function testResizeWhenRemovingChild():void
		{
			var child:Quad = new Quad(ITEM_WIDTH, ITEM_HEIGHT);
			this._group.addChild(child);
			this._group.validate();
			var originalWidth:Number = this._group.width;
			var originalHeight:Number = this._group.height;

			var hasResized:Boolean = false;
			this._group.addEventListener(Event.RESIZE, function(event:Event):void
			{
				hasResized = true;
			});
			this._group.removeChild(child);
			this._group.validate();
			Assert.assertTrue("Event.RESIZE was not dispatched", hasResized);
			Assert.assertFalse("The width of the layout group was not changed.",
				originalWidth === this._group.width);
			Assert.assertFalse("The height of the layout group was not changed.",
				originalHeight === this._group.height);
		}

		[Test]
		public function testResizeWhenResizingFeathersControlChild():void
		{
			var child:Button = new Button();
			child.defaultSkin = new Quad(ITEM_WIDTH, ITEM_HEIGHT);
			this._group.addChild(child);
			this._group.validate();

			var originalWidth:Number = this._group.width;
			var originalHeight:Number = this._group.height;
			var hasResized:Boolean = false;
			this._group.addEventListener(Event.RESIZE, function(event:Event):void
			{
				hasResized = true;
			});
			child.width = ITEM_WIDTH * 2;
			child.height = ITEM_HEIGHT * 2;
			this._group.validate();
			Assert.assertTrue("Event.RESIZE was not dispatched", hasResized);
			Assert.assertFalse("The width of the layout group was not changed.",
				originalWidth === this._group.width);
			Assert.assertFalse("The height of the layout group was not changed.",
				originalHeight === this._group.height);
		}

		[Test]
		public function testSkinsDisposed():void
		{
			var backgroundSkin:DisposeFlagQuad = new DisposeFlagQuad();
			this._group.backgroundSkin = backgroundSkin;
			var backgroundDisabledSkin:DisposeFlagQuad = new DisposeFlagQuad();
			this._group.backgroundDisabledSkin = backgroundDisabledSkin;
			this._group.validate();
			this._group.dispose();
			Assert.assertTrue("backgroundSkin not disposed when LayoutGroup disposed.", backgroundSkin.isDisposed);
			Assert.assertTrue("backgroundDisabledSkin not disposed when LayoutGroup disposed.", backgroundDisabledSkin.isDisposed);
		}
	}
}
