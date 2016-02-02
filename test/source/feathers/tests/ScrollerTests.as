package feathers.tests
{
	import feathers.controls.Scroller;
	import feathers.events.FeathersEventType;
	import feathers.system.DeviceCapabilities;
	import feathers.tests.supportClasses.DisposeFlagQuad;
	import feathers.tests.supportClasses.ScrollerViewPort;

	import flash.geom.Point;

	import org.flexunit.Assert;
	import org.flexunit.async.Async;

	import starling.display.DisplayObject;

	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class ScrollerTests
	{
		private static const BACKGROUND_WIDTH:Number = 200;
		private static const BACKGROUND_HEIGHT:Number = 250;
		
		private static const LARGE_VIEW_PORT_WIDTH:Number = 1000;
		private static const LARGE_VIEW_PORT_HEIGHT:Number = 1100;

		private static const SMALL_VIEW_PORT_WIDTH:Number = 100;
		private static const SMALL_VIEW_PORT_HEIGHT:Number = 105;

		private static const NEGATIVE_CONTENT_X:Number = -10;
		private static const NEGATIVE_CONTENT_Y:Number = -12;

		private static const VERTICAL_DRAG_OFFSET:Number = 100;
		private static const HORIZONTAL_DRAG_OFFSET:Number = 90;
		
		private var _scroller:Scroller;
		private var _viewPort:ScrollerViewPort;

		[Before]
		public function prepare():void
		{
			this._viewPort = new ScrollerViewPort();
			
			this._scroller = new Scroller();
			this._scroller.viewPort = this._viewPort;
			TestFeathers.starlingRoot.addChild(this._scroller);
		}

		[After]
		public function cleanup():void
		{
			this._scroller.removeFromParent(true);
			this._scroller = null;

			this._viewPort = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testSkinsDisposed():void
		{
			var backgroundSkin:DisposeFlagQuad = new DisposeFlagQuad();
			this._scroller.backgroundSkin = backgroundSkin;
			var backgroundDisabledSkin:DisposeFlagQuad = new DisposeFlagQuad();
			this._scroller.backgroundDisabledSkin = backgroundDisabledSkin;
			this._scroller.validate();
			this._scroller.dispose();
			Assert.assertTrue("backgroundSkin not disposed when Scroller disposed.", backgroundSkin.isDisposed);
			Assert.assertTrue("backgroundDisabledSkin not disposed when Scroller disposed.", backgroundDisabledSkin.isDisposed);
		}

		[Test]
		public function testAutoSizeNoViewPortContentNoBackground():void
		{
			this._scroller.validate();
			Assert.assertStrictlyEquals("The width of the scroller was not calculated correctly when empty.",
				0, this._scroller.width);
			Assert.assertStrictlyEquals("The height of the scroller was not calculated correctly when empty.",
				0, this._scroller.height);
		}

		[Test]
		public function testAutoSizeMinDimensionsNoViewPortContentNoBackground():void
		{
			this._scroller.minWidth = BACKGROUND_WIDTH;
			this._scroller.minHeight = BACKGROUND_HEIGHT;
			this._scroller.validate();
			Assert.assertStrictlyEquals("The width of the scroller was not calculated correctly when empty.",
			BACKGROUND_WIDTH, this._scroller.width);
			Assert.assertStrictlyEquals("The height of the scroller was not calculated correctly when empty.",
			BACKGROUND_HEIGHT, this._scroller.height);
		}

		[Test]
		public function testAutoSizeWithBackgroundAndNoViewPortContent():void
		{
			this._scroller.backgroundSkin = new Quad(BACKGROUND_WIDTH, BACKGROUND_HEIGHT);
			this._scroller.validate();
			Assert.assertStrictlyEquals("The width of the scroller was not calculated correctly with background skin and no children.",
				BACKGROUND_WIDTH, this._scroller.width);
			Assert.assertStrictlyEquals("The height of the scroller was not calculated correctly with background skin and no children.",
				BACKGROUND_HEIGHT, this._scroller.height);
		}

		[Test]
		public function testResizeBackgroundWithSmallerMaxDimensions():void
		{
			this._scroller.maxWidth = BACKGROUND_WIDTH / 3;
			this._scroller.maxHeight = BACKGROUND_HEIGHT / 3;
			var backgroundSkin:Quad = new Quad(BACKGROUND_WIDTH, BACKGROUND_HEIGHT);
			this._scroller.backgroundSkin = backgroundSkin;
			this._scroller.validate();
			Assert.assertStrictlyEquals("The Scroller with smaller maxWidth did not set the width of the background skin.",
				this._scroller.maxWidth, backgroundSkin.width);
			Assert.assertStrictlyEquals("The Scroller with smaller maxHeight did not set the height of the background skin.",
				this._scroller.maxHeight, backgroundSkin.height);
		}

		[Test]
		public function testResizeBackgroundWithLargerMinDimensions():void
		{
			this._scroller.minWidth = 3 * BACKGROUND_WIDTH;
			this._scroller.minHeight = 3 * BACKGROUND_HEIGHT;
			var backgroundSkin:Quad = new Quad(BACKGROUND_WIDTH, BACKGROUND_HEIGHT);
			this._scroller.backgroundSkin = backgroundSkin;
			this._scroller.validate();
			Assert.assertStrictlyEquals("The Scroller with larger minWidth did not set the width of the background skin.",
				this._scroller.minWidth, backgroundSkin.width);
			Assert.assertStrictlyEquals("The Scroller with larger minHeight did not set the height of the background skin.",
				this._scroller.minHeight, backgroundSkin.height);
		}

		[Test]
		public function testMaxVerticalScrollPositionWithLargerViewPortHeight():void
		{
			this._scroller.width = BACKGROUND_WIDTH;
			this._scroller.height = BACKGROUND_HEIGHT;
			this._viewPort.height = LARGE_VIEW_PORT_HEIGHT;
			this._scroller.validate();
			Assert.assertStrictlyEquals("The maxVerticalScrollPosition of the scroller was not calculated correctly with a larger view port height.",
				LARGE_VIEW_PORT_HEIGHT - BACKGROUND_HEIGHT, this._scroller.maxVerticalScrollPosition);
		}

		[Test]
		public function testMaxHorizontalScrollPositionWithLargerViewPortWidth():void
		{
			this._scroller.width = BACKGROUND_WIDTH;
			this._scroller.height = BACKGROUND_HEIGHT;
			this._viewPort.width = LARGE_VIEW_PORT_WIDTH;
			this._scroller.validate();
			Assert.assertStrictlyEquals("The maxHorizontalScrollPosition of the scroller was not calculated correctly with a larger view port width.",
				LARGE_VIEW_PORT_WIDTH - BACKGROUND_WIDTH, this._scroller.maxHorizontalScrollPosition);
		}

		[Test]
		public function testMaxVerticalScrollPositionWithSmallerViewPortHeight():void
		{
			this._scroller.width = BACKGROUND_WIDTH;
			this._scroller.height = BACKGROUND_HEIGHT;
			this._viewPort.height = SMALL_VIEW_PORT_HEIGHT;
			this._scroller.validate();
			Assert.assertStrictlyEquals("The maxVerticalScrollPosition of the scroller was not calculated correctly with a smaller view port height.",
				0, this._scroller.maxVerticalScrollPosition);
		}

		[Test]
		public function testMaxHorizontalScrollPositionWithSmallerViewPortWidth():void
		{
			this._scroller.width = BACKGROUND_WIDTH;
			this._scroller.height = BACKGROUND_HEIGHT;
			this._viewPort.width = SMALL_VIEW_PORT_WIDTH;
			this._scroller.validate();
			Assert.assertStrictlyEquals("The maxHorizontalScrollPosition of the scroller was not calculated correctly with a smaller view port width.",
				0, this._scroller.maxHorizontalScrollPosition);
		}

		[Test]
		public function testDefaultMinVerticalScrollPosition():void
		{
			this._scroller.validate();
			Assert.assertStrictlyEquals("The default minVerticalScrollPosition of the scroller was not calculated correctly.",
				0, this._scroller.minVerticalScrollPosition);
		}

		[Test]
		public function testDefaultMinHorizontalScrollPosition():void
		{
			this._scroller.validate();
			Assert.assertStrictlyEquals("The default minHorizontalScrollPosition of the scroller was not calculated correctly.",
				0, this._scroller.minHorizontalScrollPosition);
		}

		[Test]
		public function testMinVerticalScrollPositionWithNegativeContentY():void
		{
			this._viewPort.contentY = NEGATIVE_CONTENT_Y;
			this._scroller.validate();
			Assert.assertStrictlyEquals("The minVerticalScrollPosition of the scroller was not calculated correctly with contentY < 0.",
				NEGATIVE_CONTENT_Y, this._scroller.minVerticalScrollPosition);
		}

		[Test]
		public function testMinHorizontalScrollPositionWithNegativeContentX():void
		{
			this._viewPort.contentX = NEGATIVE_CONTENT_X;
			this._scroller.validate();
			Assert.assertStrictlyEquals("The minHorizontalScrollPosition of the scroller was not calculated correctly with contentX < 0.",
				NEGATIVE_CONTENT_X, this._scroller.minHorizontalScrollPosition);
		}

		[Test(async)]
		public function testDragVerticallyToScroll():void
		{
			this._scroller.width = BACKGROUND_WIDTH;
			this._scroller.height = BACKGROUND_HEIGHT;
			this._viewPort.width = BACKGROUND_WIDTH;
			this._viewPort.height = LARGE_VIEW_PORT_HEIGHT;
			this._scroller.validate();

			var hasDispatchedScrollStart:Boolean = false;
			this._scroller.addEventListener(FeathersEventType.SCROLL_START, function(event:Event):void
			{
				hasDispatchedScrollStart = true;
			});
			
			var position:Point = new Point(10, 10);
			var target:DisplayObject = this._scroller.stage.hitTest(position);
			var touch:Touch = new Touch(0);
			touch.target = target;
			touch.phase = TouchPhase.BEGAN;
			touch.globalX = position.x;
			touch.globalY = position.y;
			var touches:Vector.<Touch> = new <Touch>[touch];
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));

			var self:Object = this;
			var scroller:Scroller = this._scroller;
			Async.delayCall(this, function():void
			{
				touch.globalY = VERTICAL_DRAG_OFFSET; //move the touch a bit to drag
				touch.phase = TouchPhase.MOVED;
				target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
				
				Async.delayCall(self, function():void
				{
					touch.phase = TouchPhase.ENDED;
					target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
					
					Assert.assertTrue("Scroller FeathersEventType.SCROLL_START was not dispatched when dragging", hasDispatchedScrollStart);
					Assert.assertTrue("Scroller isScrolling was not set to true when dragging", scroller.isScrolling);
				}, 25);
			}, 25);
		}

		[Test(async)]
		public function testDragHorizontallyToScroll():void
		{
			this._scroller.width = BACKGROUND_WIDTH;
			this._scroller.height = BACKGROUND_HEIGHT;
			this._viewPort.width = LARGE_VIEW_PORT_WIDTH;
			this._viewPort.height = BACKGROUND_HEIGHT;
			this._scroller.validate();

			var hasDispatchedScrollStart:Boolean = false;
			this._scroller.addEventListener(FeathersEventType.SCROLL_START, function(event:Event):void
			{
				hasDispatchedScrollStart = true;
			});

			var position:Point = new Point(10, 10);
			var target:DisplayObject = this._scroller.stage.hitTest(position);
			var touch:Touch = new Touch(0);
			touch.target = target;
			touch.phase = TouchPhase.BEGAN;
			touch.globalX = position.x;
			touch.globalY = position.y;
			var touches:Vector.<Touch> = new <Touch>[touch];
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));

			var self:Object = this;
			var scroller:Scroller = this._scroller;
			Async.delayCall(this, function():void
			{
				touch.globalX = HORIZONTAL_DRAG_OFFSET; //move the touch a bit to drag
				touch.phase = TouchPhase.MOVED;
				target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));

				Async.delayCall(self, function():void
				{
					touch.phase = TouchPhase.ENDED;
					target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));

					Assert.assertTrue("Scroller FeathersEventType.SCROLL_START was not dispatched when dragging", hasDispatchedScrollStart);
					Assert.assertTrue("Scroller isScrolling was not set to true when dragging", scroller.isScrolling);
				}, 25);
			}, 25);
		}

		[Test(async)]
		public function testScrollCompleteEventOnRemovedFromStage():void
		{
			this._scroller.width = BACKGROUND_WIDTH;
			this._scroller.height = BACKGROUND_HEIGHT;
			this._viewPort.width = LARGE_VIEW_PORT_WIDTH;
			this._viewPort.height = BACKGROUND_HEIGHT;
			this._scroller.validate();

			var hasDispatchedScrollComplete:Boolean = false;
			this._scroller.addEventListener(FeathersEventType.SCROLL_COMPLETE, function(event:Event):void
			{
				hasDispatchedScrollComplete = true;
			});

			var position:Point = new Point(10, 10);
			var target:DisplayObject = this._scroller.stage.hitTest(position);
			var touch:Touch = new Touch(0);
			touch.target = target;
			touch.phase = TouchPhase.BEGAN;
			touch.globalX = position.x;
			touch.globalY = position.y;
			var touches:Vector.<Touch> = new <Touch>[touch];
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));

			var self:Object = this;
			var scroller:Scroller = this._scroller;
			Async.delayCall(this, function():void
			{
				touch.globalX = HORIZONTAL_DRAG_OFFSET; //move the touch a bit to drag
				touch.phase = TouchPhase.MOVED;
				target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));

				Async.delayCall(self, function():void
				{
					touch.phase = TouchPhase.ENDED;
					target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
					
					scroller.removeFromParent();

					Assert.assertTrue("Scroller FeathersEventType.SCROLL_COMPLETE was not dispatched when removed from stage", hasDispatchedScrollComplete);
				}, 25);
			}, 25);
		}
	}
}
