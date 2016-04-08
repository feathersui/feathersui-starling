package feathers.tests
{
	import feathers.controls.Button;
	import feathers.controls.Slider;
	import feathers.controls.TrackLayoutMode;
	import feathers.layout.Direction;

	import flash.geom.Point;

	import org.flexunit.Assert;

	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class SliderHorizontalTests
	{
		private static const THUMB_NAME:String = "thumb";
		private static const TRACK_NAME:String = "track";
		private static const TRACK_WIDTH:Number = 200;
		private static const TRACK_HEIGHT:Number = 20;
		private static const THUMB_WIDTH:Number = 20;
		private static const THUMB_HEIGHT:Number = 20;

		private var _slider:Slider;

		[Before]
		public function prepare():void
		{
			this._slider = new Slider();
			this._slider.direction = Direction.HORIZONTAL;
			this._slider.trackLayoutMode = TrackLayoutMode.SINGLE;
			this._slider.minimumTrackFactory = function():Button
			{
				var track:Button = new Button();
				track.name = TRACK_NAME;
				track.defaultSkin = new Quad(TRACK_WIDTH, TRACK_HEIGHT);
				return track;
			};
			this._slider.thumbFactory = function():Button
			{
				var thumb:Button = new Button();
				thumb.name = THUMB_NAME;
				thumb.defaultSkin = new Quad(THUMB_WIDTH, THUMB_HEIGHT);
				return thumb;
			};
			TestFeathers.starlingRoot.addChild(this._slider);
			this._slider.validate();
		}

		[After]
		public function cleanup():void
		{
			this._slider.removeFromParent(true);
			this._slider = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testSetValueProgramaticallyWithMinimum():void
		{
			this._slider.minimum = 5;
			this._slider.maximum = 10;
			this._slider.value = 2;
			Assert.assertEquals("Setting value smaller than minimum not changed to minimum.", this._slider.minimum, this._slider.value);
		}

		[Test]
		public function testSetValueProgramaticallyWithMaximum():void
		{
			this._slider.minimum = 5;
			this._slider.maximum = 10;
			this._slider.value = 12;
			Assert.assertEquals("Setting value larger than maximum not changed to maximum.", this._slider.maximum, this._slider.value);
		}

		[Test]
		public function testProgrammaticSelectionChange():void
		{
			this._slider.minimum = 0;
			this._slider.maximum = 10;
			this._slider.value = 5;
			var hasChanged:Boolean = false;
			this._slider.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._slider.value = 6;
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
		}

		[Test]
		public function testInteractiveSelectionChangeWithDraggingThumb():void
		{
			var beforeValue:Number = 5;
			this._slider.minimum = 0;
			this._slider.maximum = 10;
			this._slider.value = beforeValue;
			//validate to position the thumb correctly.
			this._slider.validate();
			var hasChanged:Boolean = false;
			this._slider.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			var position:Point = new Point(TRACK_WIDTH / 2, THUMB_HEIGHT / 2);
			var target:DisplayObject = this._slider.stage.hitTest(position);

			Assert.assertStrictlyEquals("The hit test did not return the slider's thumb",
				this._slider.getChildByName(THUMB_NAME).name, target.name);

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
				beforeValue < this._slider.value);
		}

		[Test]
		public function testInteractiveSelectionChangeWithDraggingThumbBeyondRightEdgeOfTrack():void
		{
			var beforeValue:Number = 5;
			this._slider.minimum = 0;
			this._slider.maximum = 10;
			this._slider.value = beforeValue;
			//validate to position the thumb correctly.
			this._slider.validate();
			var hasChanged:Boolean = false;
			this._slider.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			var position:Point = new Point(TRACK_WIDTH / 2, THUMB_HEIGHT / 2);
			var target:DisplayObject = this._slider.stage.hitTest(position);

			Assert.assertStrictlyEquals("The hit test did not return the slider's thumb",
				this._slider.getChildByName(THUMB_NAME).name, target.name);

			var touch:Touch = new Touch(0);
			touch.target = target;
			touch.phase = TouchPhase.BEGAN;
			touch.globalX = position.x;
			touch.globalY = position.y;
			var touches:Vector.<Touch> = new <Touch>[touch];
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			touch.phase = TouchPhase.MOVED;
			touch.globalX = position.x + TRACK_WIDTH;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			touch.phase = TouchPhase.ENDED;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));

			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertStrictlyEquals("The value property was not equal to the maximum value",
				this._slider.maximum, this._slider.value);
		}

		[Test]
		public function testInteractiveSelectionChangeWithDraggingThumbBeyondLeftEdgeOfTrack():void
		{
			var beforeValue:Number = 5;
			this._slider.minimum = 0;
			this._slider.maximum = 10;
			this._slider.value = beforeValue;
			//validate to position the thumb correctly.
			this._slider.validate();
			var hasChanged:Boolean = false;
			this._slider.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			var position:Point = new Point(TRACK_WIDTH / 2, THUMB_HEIGHT / 2);
			var target:DisplayObject = this._slider.stage.hitTest(position);

			Assert.assertStrictlyEquals("The hit test did not return the slider's thumb",
				this._slider.getChildByName(THUMB_NAME).name, target.name);

			var touch:Touch = new Touch(0);
			touch.target = target;
			touch.phase = TouchPhase.BEGAN;
			touch.globalX = position.x;
			touch.globalY = position.y;
			var touches:Vector.<Touch> = new <Touch>[touch];
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			touch.phase = TouchPhase.MOVED;
			touch.globalX = position.x - TRACK_WIDTH;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			touch.phase = TouchPhase.ENDED;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));

			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertStrictlyEquals("The value property was not equal to the minimum value",
				this._slider.minimum, this._slider.value);
		}

		[Test]
		public function testInteractiveSelectionChangeWithTouchToLeftOfThumb():void
		{
			var beforeValue:Number = 5;
			this._slider.minimum = 0;
			this._slider.maximum = 10;
			this._slider.value = beforeValue;
			//validate to position the thumb correctly.
			this._slider.validate();
			var hasChanged:Boolean = false;
			this._slider.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			var position:Point = new Point(TRACK_WIDTH / 3, THUMB_HEIGHT / 2);
			var target:DisplayObject = this._slider.stage.hitTest(position);

			Assert.assertStrictlyEquals("The hit test did not return the slider's track",
				this._slider.getChildByName(TRACK_NAME).name, target.name);

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
			Assert.assertTrue("The value property was not less than the previous value",
				beforeValue > this._slider.value);
		}

		[Test]
		public function testInteractiveSelectionChangeWithTouchToRightOfThumb():void
		{
			var beforeValue:Number = 5;
			this._slider.minimum = 0;
			this._slider.maximum = 10;
			this._slider.value = beforeValue;
			//validate to position the thumb correctly.
			this._slider.validate();
			var hasChanged:Boolean = false;
			this._slider.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			var position:Point = new Point(2 * TRACK_WIDTH / 3, THUMB_HEIGHT / 2);
			var target:DisplayObject = this._slider.stage.hitTest(position);

			Assert.assertStrictlyEquals("The hit test did not return the slider's track",
				this._slider.getChildByName(TRACK_NAME).name, target.name);

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
			Assert.assertTrue("The value property was not greater than the previous value",
				beforeValue < this._slider.value);
		}
	}
}
