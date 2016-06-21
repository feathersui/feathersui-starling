package feathers.tests
{
	import feathers.controls.AutoSizeMode;
	import feathers.controls.Button;
	import feathers.controls.ScrollContainer;
	import feathers.tests.supportClasses.AssertViewPortBoundsLayout;

	import org.flexunit.Assert;

	import starling.display.Quad;
	import starling.events.Event;

	public class ScrollContainerTests
	{
		private static const ITEM_WIDTH:Number = 210;
		private static const ITEM_HEIGHT:Number = 160;

		private var _container:ScrollContainer;

		[Before]
		public function prepare():void
		{
			this._container = new ScrollContainer();
			TestFeathers.starlingRoot.addChild(this._container);
			this._container.validate();
		}

		[After]
		public function cleanup():void
		{
			this._container.removeFromParent(true);
			this._container = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testDefaultAutoSizeMode():void
		{
			this._container.validate();
			Assert.assertStrictlyEquals("The default value of LayoutGroup autoSizeMode must be AutoSizeMode.CONTENT, if not root.", AutoSizeMode.CONTENT, this._container.autoSizeMode);
		}

		[Test]
		public function testNoErrorValidatingWithoutStage():void
		{
			var container:ScrollContainer = new ScrollContainer();
			container.validate();
			container.dispose();
		}

		[Test]
		public function testResizeWhenAddingChild():void
		{
			var originalWidth:Number = this._container.width;
			var originalHeight:Number = this._container.height;
			var hasResized:Boolean = false;
			this._container.addEventListener(Event.RESIZE, function(event:Event):void
			{
				hasResized = true;
			});
			this._container.addChild(new Quad(ITEM_WIDTH, ITEM_HEIGHT));
			this._container.validate();
			Assert.assertTrue("Event.RESIZE was not dispatched", hasResized);
			Assert.assertFalse("The width of the layout group was not changed.",
				originalWidth === this._container.width);
			Assert.assertFalse("The height of the layout group was not changed.",
				originalHeight === this._container.height);
		}

		[Test]
		public function testResizeWhenRemovingChild():void
		{
			var child:Quad = new Quad(ITEM_WIDTH, ITEM_HEIGHT);
			this._container.addChild(child);
			this._container.validate();
			var originalWidth:Number = this._container.width;
			var originalHeight:Number = this._container.height;

			var hasResized:Boolean = false;
			this._container.addEventListener(Event.RESIZE, function(event:Event):void
			{
				hasResized = true;
			});
			this._container.removeChild(child);
			this._container.validate();
			Assert.assertTrue("Event.RESIZE was not dispatched", hasResized);
			Assert.assertFalse("The width of the layout group was not changed.",
				originalWidth === this._container.width);
			Assert.assertFalse("The height of the layout group was not changed.",
				originalHeight === this._container.height);
		}

		[Test]
		public function testResizeWhenResizingFeathersControlChild():void
		{
			var child:Button = new Button();
			child.defaultSkin = new Quad(ITEM_WIDTH, ITEM_HEIGHT);
			this._container.addChild(child);
			this._container.validate();

			var originalWidth:Number = this._container.width;
			var originalHeight:Number = this._container.height;
			var hasResized:Boolean = false;
			this._container.addEventListener(Event.RESIZE, function(event:Event):void
			{
				hasResized = true;
			});
			child.width = ITEM_WIDTH * 2;
			child.height = ITEM_HEIGHT * 2;
			this._container.validate();
			Assert.assertTrue("Event.RESIZE was not dispatched", hasResized);
			Assert.assertFalse("The width of the layout group was not changed.",
				originalWidth === this._container.width);
			Assert.assertFalse("The height of the layout group was not changed.",
				originalHeight === this._container.height);
		}

		[Test]
		public function testMaxScrollPositionWithOneChildAndSameDimensions():void
		{
			var child:Quad = new Quad(ITEM_WIDTH, ITEM_HEIGHT);
			this._container.addChild(child);
			this._container.validate();
			Assert.assertStrictlyEquals("The maxHorizontalScrollPosition of the scroll container was not calculated correctly.",
				0, this._container.maxHorizontalScrollPosition);
			Assert.assertStrictlyEquals("The maxVerticalScrollPosition of the scroll container was not calculated correctly.",
				0, this._container.maxVerticalScrollPosition);
		}

		[Test]
		public function testMaxScrollPositionWithSmallerChild():void
		{
			var child:Quad = new Quad(ITEM_WIDTH, ITEM_HEIGHT);
			this._container.addChild(child);
			this._container.setSize(ITEM_WIDTH * 3, ITEM_HEIGHT * 3);
			this._container.validate();
			Assert.assertStrictlyEquals("The maxHorizontalScrollPosition of the scroll container was not calculated correctly.",
				0, this._container.maxHorizontalScrollPosition);
			Assert.assertStrictlyEquals("The maxVerticalScrollPosition of the scroll container was not calculated correctly.",
				0, this._container.maxVerticalScrollPosition);
		}

		[Test]
		public function testMaxScrollPositionWithLargerChild():void
		{
			var child:Quad = new Quad(ITEM_WIDTH, ITEM_HEIGHT);
			this._container.addChild(child);
			this._container.setSize(ITEM_WIDTH - 10, ITEM_HEIGHT - 10);
			this._container.validate();
			Assert.assertStrictlyEquals("The maxHorizontalScrollPosition of the scroll container was not calculated correctly when scrolling is required.",
				child.width - this._container.width, this._container.maxHorizontalScrollPosition);
			Assert.assertStrictlyEquals("The maxVerticalScrollPosition of the scroll container was not calculated correctly when scrolling is required.",
				child.height - this._container.height, this._container.maxVerticalScrollPosition);
		}

		[Test]
		public function testViewPortBoundsValues():void
		{
			this._container.layout = new AssertViewPortBoundsLayout();
			this._container.validate();
		}
	}
}
