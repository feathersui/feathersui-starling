package feathers.tests
{
	import feathers.controls.Button;
	import feathers.controls.ScrollBar;

	import flash.geom.Point;

	import org.flexunit.Assert;

	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class ScrollBarHorizontalTests
	{
		private static const DECREMENT_BUTTON_NAME:String = "decrement-button";
		private static const INCREMENT_BUTTON_NAME:String = "increment-button";
		private static const THUMB_NAME:String = "thumb";
		private static const TRACK_NAME:String = "track";
		private static const TRACK_WIDTH:Number = 200;
		private static const TRACK_HEIGHT:Number = 20;
		private static const THUMB_WIDTH:Number = 20;
		private static const THUMB_HEIGHT:Number = 20;
		private static const DECREMENT_BUTTON_WIDTH:Number = 30;
		private static const DECREMENT_BUTTON_HEIGHT:Number = 20;
		private static const INCREMENT_BUTTON_WIDTH:Number = 30;
		private static const INCREMENT_BUTTON_HEIGHT:Number = 20;

		private var _scrollBar:ScrollBar;

		[Before]
		public function prepare():void
		{
			this._scrollBar = new ScrollBar();
			this._scrollBar.direction = ScrollBar.DIRECTION_HORIZONTAL;
			this._scrollBar.trackLayoutMode = ScrollBar.TRACK_LAYOUT_MODE_SINGLE;
			this._scrollBar.decrementButtonFactory = function():Button
			{
				var decrementButton:Button = new Button();
				decrementButton.name = DECREMENT_BUTTON_NAME;
				decrementButton.defaultSkin = new Quad(DECREMENT_BUTTON_WIDTH, DECREMENT_BUTTON_HEIGHT);
				return decrementButton;
			};
			this._scrollBar.incrementButtonFactory = function():Button
			{
				var incrementButton:Button = new Button();
				incrementButton.name = INCREMENT_BUTTON_NAME;
				incrementButton.defaultSkin = new Quad(INCREMENT_BUTTON_WIDTH, INCREMENT_BUTTON_HEIGHT);
				return incrementButton;
			};
			this._scrollBar.minimumTrackFactory = function():Button
			{
				var track:Button = new Button();
				track.name = TRACK_NAME;
				track.defaultSkin = new Quad(TRACK_WIDTH, TRACK_HEIGHT);
				return track;
			};
			this._scrollBar.thumbFactory = function():Button
			{
				var thumb:Button = new Button();
				thumb.name = THUMB_NAME;
				thumb.defaultSkin = new Quad(THUMB_WIDTH, THUMB_HEIGHT);
				return thumb;
			};
			TestFeathers.starlingRoot.addChild(this._scrollBar);
			this._scrollBar.validate();
		}

		[After]
		public function cleanup():void
		{
			this._scrollBar.removeFromParent(true);
			this._scrollBar = null;
		}

		[Test]
		public function testSingleTrackAutoSize():void
		{
			Assert.assertStrictlyEquals("The width of the scroll bar was not calculated correctly.",
				TRACK_WIDTH + INCREMENT_BUTTON_WIDTH + DECREMENT_BUTTON_WIDTH, this._scrollBar.width);
			Assert.assertStrictlyEquals("The height of the scroll bar was not calculated correctly.",
				TRACK_HEIGHT, this._scrollBar.height);
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
			var position:Point = new Point(DECREMENT_BUTTON_WIDTH + TRACK_WIDTH / 2, THUMB_HEIGHT / 2);
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
			var position:Point = new Point(INCREMENT_BUTTON_WIDTH + TRACK_WIDTH / 2, THUMB_HEIGHT / 2);
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
			touch.globalX = position.x + TRACK_WIDTH + INCREMENT_BUTTON_WIDTH;
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
			var position:Point = new Point(DECREMENT_BUTTON_WIDTH + TRACK_WIDTH / 2, THUMB_HEIGHT / 2);
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
			touch.globalX = position.x - TRACK_WIDTH - DECREMENT_BUTTON_WIDTH;
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
			var thumbWidth:Number = this._scrollBar.getChildByName(THUMB_NAME).width;
			var position:Point = new Point(DECREMENT_BUTTON_WIDTH + (TRACK_WIDTH - thumbWidth) / 4, THUMB_HEIGHT / 2);
			var target:DisplayObject = this._scrollBar.stage.hitTest(position, true);

			Assert.assertStrictlyEquals("The hit test did not return the scroll bar's track",
				this._scrollBar.getChildByName(TRACK_NAME).name, target.name);

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
			Assert.assertStrictlyEquals("The value property was not less than the previous value minus the page",
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
			var thumbWidth:Number = this._scrollBar.getChildByName(THUMB_NAME).width;
			var position:Point = new Point(DECREMENT_BUTTON_WIDTH + 3 * (TRACK_WIDTH - thumbWidth) / 4, THUMB_HEIGHT / 2);
			var target:DisplayObject = this._scrollBar.stage.hitTest(position, true);

			Assert.assertStrictlyEquals("The hit test did not return the scroll bar's track",
				this._scrollBar.getChildByName(TRACK_NAME).name, target.name);

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
			Assert.assertStrictlyEquals("The value property was not the previous value plus the page",
				beforeValue + page, this._scrollBar.value);
		}

		[Test]
		public function testInteractiveSelectionChangeByTappingDecrementButton():void
		{
			var beforeValue:Number = 5;
			var step:Number = 1;
			this._scrollBar.minimum = 0;
			this._scrollBar.maximum = 10;
			this._scrollBar.step = step;
			this._scrollBar.page = 2;
			this._scrollBar.value = beforeValue;
			//validate to position the thumb correctly.
			this._scrollBar.validate();
			var hasChanged:Boolean = false;
			this._scrollBar.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			var position:Point = new Point(DECREMENT_BUTTON_WIDTH / 2, THUMB_HEIGHT / 2);
			var target:DisplayObject = this._scrollBar.stage.hitTest(position, true);

			Assert.assertStrictlyEquals("The hit test did not return the scroll bar's decrement button",
				this._scrollBar.getChildByName(DECREMENT_BUTTON_NAME).name, target.name);

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
			Assert.assertStrictlyEquals("The value property was not equal to the previous value minus the step",
				beforeValue - step, this._scrollBar.value);
		}

		[Test]
		public function testInteractiveSelectionChangeByTappingIncrementButton():void
		{
			var beforeValue:Number = 5;
			var step:Number = 1;
			this._scrollBar.minimum = 0;
			this._scrollBar.maximum = 10;
			this._scrollBar.step = step;
			this._scrollBar.page = 2;
			this._scrollBar.value = beforeValue;
			//validate to position the thumb correctly.
			this._scrollBar.validate();
			var hasChanged:Boolean = false;
			this._scrollBar.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			var position:Point = new Point(this._scrollBar.width - INCREMENT_BUTTON_WIDTH / 2, THUMB_HEIGHT / 2);
			var target:DisplayObject = this._scrollBar.stage.hitTest(position, true);

			Assert.assertStrictlyEquals("The hit test did not return the scroll bar's increment button",
				this._scrollBar.getChildByName(INCREMENT_BUTTON_NAME).name, target.name);

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
			Assert.assertStrictlyEquals("The value property was not equal to the previous value plus the step",
				beforeValue + step, this._scrollBar.value);
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
			var thumbWidth:Number = this._scrollBar.getChildByName(THUMB_NAME).width;
			var position:Point = new Point(DECREMENT_BUTTON_WIDTH + (TRACK_WIDTH - thumbWidth) / 4, THUMB_HEIGHT / 2);
			var target:DisplayObject = this._scrollBar.stage.hitTest(position, true);

			Assert.assertStrictlyEquals("The hit test did not return the scroll bar's track",
				this._scrollBar.getChildByName(TRACK_NAME).name, target.name);

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
