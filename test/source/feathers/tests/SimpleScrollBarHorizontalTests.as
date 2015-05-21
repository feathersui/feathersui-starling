package feathers.tests
{
	import feathers.controls.Button;
	import feathers.controls.SimpleScrollBar;

	import flash.geom.Point;

	import org.flexunit.Assert;

	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class SimpleScrollBarHorizontalTests
	{
		private static const THUMB_NAME:String = "thumb";
		private static const THUMB_WIDTH:Number = 20;
		private static const THUMB_HEIGHT:Number = 20;
		private static const SCROLL_BAR_WIDTH:Number = 200;

		private var _scrollBar:SimpleScrollBar;

		[Before]
		public function prepare():void
		{
			this._scrollBar = new SimpleScrollBar();
			this._scrollBar.direction = SimpleScrollBar.DIRECTION_HORIZONTAL;
			this._scrollBar.thumbFactory = function():Button
			{
				var thumb:Button = new Button();
				thumb.name = THUMB_NAME;
				thumb.defaultSkin = new Quad(THUMB_WIDTH, THUMB_HEIGHT);
				return thumb;
			};
			this._scrollBar.width = SCROLL_BAR_WIDTH;
			TestFeathers.starlingRoot.addChild(this._scrollBar);
			this._scrollBar.validate();
		}

		[After]
		public function cleanup():void
		{
			this._scrollBar.removeFromParent(true);
			this._scrollBar = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testSingleTrackAutoSize():void
		{
			Assert.assertStrictlyEquals("The height of the scroll bar was not calculated correctly.",
				THUMB_HEIGHT, this._scrollBar.height);
		}

		[Test]
		public function testProgrammaticSelectionChange():void
		{
			this._scrollBar.minimum = 0;
			this._scrollBar.maximum = 10;
			this._scrollBar.step = 1;
			this._scrollBar.page = 2;
			this._scrollBar.value = 5;
			var hasChanged:Boolean = false;
			this._scrollBar.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._scrollBar.value = 6;
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
		}

		[Test]
		public function testInteractiveSelectionChangeWithDraggingThumb():void
		{
			var beforeValue:Number = 5;
			this._scrollBar.minimum = 0;
			this._scrollBar.maximum = 10;
			this._scrollBar.step = 1;
			this._scrollBar.page = 2;
			this._scrollBar.value = beforeValue;
			//validate to position the thumb correctly.
			this._scrollBar.validate();
			var hasChanged:Boolean = false;
			this._scrollBar.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			var position:Point = new Point(SCROLL_BAR_WIDTH / 2, THUMB_HEIGHT / 2);
			var target:DisplayObject = this._scrollBar.stage.hitTest(position, true);

			Assert.assertStrictlyEquals("The hit test did not return the scroll bar's thumb",
				this._scrollBar.getChildByName(THUMB_NAME).name, target.name);

			var touch:Touch = new Touch(0);
			touch.target = target;
			touch.phase = TouchPhase.BEGAN;
			touch.globalX = position.x;
			touch.globalY = position.y;
			var touches:Vector.<Touch> = new <Touch>[touch];
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			touch.phase = TouchPhase.MOVED;
			touch.globalX = position.x + THUMB_WIDTH * 2;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			touch.phase = TouchPhase.ENDED;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));

			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertTrue("The value property was not changed to a greater value",
				beforeValue < this._scrollBar.value);
		}

		[Test]
		public function testInteractiveSelectionChangeWithDraggingThumbBeyondRightEdgeOfTrack():void
		{
			var beforeValue:Number = 5;
			this._scrollBar.minimum = 0;
			this._scrollBar.maximum = 10;
			this._scrollBar.step = 1;
			this._scrollBar.page = 2;
			this._scrollBar.value = beforeValue;
			//validate to position the thumb correctly.
			this._scrollBar.validate();
			var hasChanged:Boolean = false;
			this._scrollBar.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			var position:Point = new Point(SCROLL_BAR_WIDTH / 2, THUMB_HEIGHT / 2);
			var target:DisplayObject = this._scrollBar.stage.hitTest(position, true);

			Assert.assertStrictlyEquals("The hit test did not return the scroll bar's thumb",
				this._scrollBar.getChildByName(THUMB_NAME).name, target.name);

			var touch:Touch = new Touch(0);
			touch.target = target;
			touch.phase = TouchPhase.BEGAN;
			touch.globalX = position.x;
			touch.globalY = position.y;
			var touches:Vector.<Touch> = new <Touch>[touch];
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			touch.phase = TouchPhase.MOVED;
			touch.globalX = position.x + SCROLL_BAR_WIDTH;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			touch.phase = TouchPhase.ENDED;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));

			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertStrictlyEquals("The value property was not equal to the maximum value",
				this._scrollBar.maximum, this._scrollBar.value);
		}

		[Test]
		public function testInteractiveSelectionChangeWithDraggingThumbBeyondLeftEdgeOfTrack():void
		{
			var beforeValue:Number = 5;
			this._scrollBar.minimum = 0;
			this._scrollBar.maximum = 10;
			this._scrollBar.step = 1;
			this._scrollBar.page = 2;
			this._scrollBar.value = beforeValue;
			//validate to position the thumb correctly.
			this._scrollBar.validate();
			var hasChanged:Boolean = false;
			this._scrollBar.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			var position:Point = new Point(SCROLL_BAR_WIDTH / 2, THUMB_HEIGHT / 2);
			var target:DisplayObject = this._scrollBar.stage.hitTest(position, true);

			Assert.assertStrictlyEquals("The hit test did not return the scroll bar's thumb",
				this._scrollBar.getChildByName(THUMB_NAME).name, target.name);

			var touch:Touch = new Touch(0);
			touch.target = target;
			touch.phase = TouchPhase.BEGAN;
			touch.globalX = position.x;
			touch.globalY = position.y;
			var touches:Vector.<Touch> = new <Touch>[touch];
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			touch.phase = TouchPhase.MOVED;
			touch.globalX = position.x - SCROLL_BAR_WIDTH;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			touch.phase = TouchPhase.ENDED;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));

			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertStrictlyEquals("The value property was not equal to the minimum value",
				this._scrollBar.minimum, this._scrollBar.value);
		}

		[Test]
		public function testInteractiveSelectionChangeWithTouchToLeftOfThumb():void
		{
			var beforeValue:Number = 5;
			var page:Number = 2;
			this._scrollBar.minimum = 0;
			this._scrollBar.maximum = 10;
			this._scrollBar.step = 1;
			this._scrollBar.page = page;
			this._scrollBar.value = beforeValue;
			//validate to position the thumb correctly.
			this._scrollBar.validate();
			var hasChanged:Boolean = false;
			this._scrollBar.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			var position:Point = new Point(SCROLL_BAR_WIDTH / 4, THUMB_HEIGHT / 2);
			var target:DisplayObject = this._scrollBar.stage.hitTest(position, true);
			
			Assert.assertTrue("The hit test did not return a display object contained by the scroll bar",
				this._scrollBar.contains(target));
			Assert.assertFalse("The hit test incorrectly returned the scroll bar's thumb",
				this._scrollBar.getChildByName(THUMB_NAME).name === target.name);

			var touch:Touch = new Touch(0);
			touch.target = target;
			touch.phase = TouchPhase.BEGAN;
			touch.globalX = position.x;
			touch.globalY = position.y;
			var touches:Vector.<Touch> = new <Touch>[touch];
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			touch.phase = TouchPhase.ENDED;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));

			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertStrictlyEquals("The value property was not equal to the previous value minus the page",
				beforeValue - page, this._scrollBar.value);
		}

		[Test]
		public function testInteractiveSelectionChangeWithTouchToRightOfThumb():void
		{
			var beforeValue:Number = 5;
			var page:Number = 2;
			this._scrollBar.minimum = 0;
			this._scrollBar.maximum = 10;
			this._scrollBar.step = 1;
			this._scrollBar.page = page;
			this._scrollBar.value = beforeValue;
			//validate to position the thumb correctly.
			this._scrollBar.validate();
			var hasChanged:Boolean = false;
			this._scrollBar.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			var position:Point = new Point(3 * SCROLL_BAR_WIDTH / 4, THUMB_HEIGHT / 2);
			var target:DisplayObject = this._scrollBar.stage.hitTest(position, true);

			Assert.assertTrue("The hit test did not return a display object contained by the scroll bar",
				this._scrollBar.contains(target));
			Assert.assertFalse("The hit test incorrectly returned the scroll bar's thumb",
				this._scrollBar.getChildByName(THUMB_NAME).name === target.name);

			var touch:Touch = new Touch(0);
			touch.target = target;
			touch.phase = TouchPhase.BEGAN;
			touch.globalX = position.x;
			touch.globalY = position.y;
			var touches:Vector.<Touch> = new <Touch>[touch];
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			touch.phase = TouchPhase.ENDED;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));

			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertStrictlyEquals("The value property was not equal to the previous value plus the page",
				beforeValue + page, this._scrollBar.value);
		}

		[Test]
		public function testFallBackToStepWhenPageIsZero():void
		{
			var beforeValue:Number = 5;
			var step:Number = 1;
			this._scrollBar.minimum = 0;
			this._scrollBar.maximum = 10;
			this._scrollBar.step = step;
			this._scrollBar.page = 0;
			this._scrollBar.value = beforeValue;
			//validate to position the thumb correctly.
			this._scrollBar.validate();
			var hasChanged:Boolean = false;
			this._scrollBar.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			var position:Point = new Point(SCROLL_BAR_WIDTH / 3, THUMB_HEIGHT / 2);
			var target:DisplayObject = this._scrollBar.stage.hitTest(position, true);

			Assert.assertTrue("The hit test did not return a display object contained by the scroll bar",
				this._scrollBar.contains(target));
			Assert.assertFalse("The hit test incorrectly returned the scroll bar's thumb",
				this._scrollBar.getChildByName(THUMB_NAME).name === target.name);

			var touch:Touch = new Touch(0);
			touch.target = target;
			touch.phase = TouchPhase.BEGAN;
			touch.globalX = position.x;
			touch.globalY = position.y;
			var touches:Vector.<Touch> = new <Touch>[touch];
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			touch.phase = TouchPhase.ENDED;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));

			Assert.assertStrictlyEquals("The value property was not equal to the the previous value minus the step value",
				beforeValue - step, this._scrollBar.value);
		}
	}
}
