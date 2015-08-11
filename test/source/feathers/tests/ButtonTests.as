package feathers.tests
{
	import feathers.controls.Button;
	import feathers.events.FeathersEventType;

	import flash.geom.Point;

	import org.flexunit.Assert;
	import org.flexunit.async.Async;

	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class ButtonTests
	{
		private var _button:Button;

		[Before]
		public function prepare():void
		{
			this._button = new Button();
			this._button.label = "Click Me";
			this._button.defaultSkin = new Quad(200, 200);
			TestFeathers.starlingRoot.addChild(this._button);
			this._button.validate();
		}

		[After]
		public function cleanup():void
		{
			this._button.removeFromParent(true);
			this._button = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testTriggeredEvent():void
		{
			var hasTriggered:Boolean = false;
			this._button.addEventListener(Event.TRIGGERED, function(event:Event):void
			{
				hasTriggered = true;
			});
			var position:Point = new Point(10, 10);
			var target:DisplayObject = this._button.stage.hitTest(position, true);
			var touch:Touch = new Touch(0);
			touch.target = target;
			touch.phase = TouchPhase.BEGAN;
			touch.globalX = position.x;
			touch.globalY = position.y;
			var touches:Vector.<Touch> = new <Touch>[touch];
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			//this touch does not move at all, so it should result in triggering
			//the button.
			touch.phase = TouchPhase.ENDED;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			Assert.assertTrue("Event.TRIGGERED was not dispatched", hasTriggered);
		}

		[Test]
		public function testTouchMoveOutsideBeforeTriggeredEvent():void
		{
			var hasTriggered:Boolean = false;
			this._button.addEventListener(Event.TRIGGERED, function(event:Event):void
			{
				hasTriggered = true;
			});
			var position:Point = new Point(10, 10);
			var target:DisplayObject = this._button.stage.hitTest(position, true);
			var touch:Touch = new Touch(0);
			touch.target = target;
			touch.phase = TouchPhase.BEGAN;
			touch.globalX = position.x;
			touch.globalY = position.y;
			var touches:Vector.<Touch> = new <Touch>[touch];
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			touch.globalX = 1000; //move the touch way outside the bounds of the button
			touch.phase = TouchPhase.MOVED;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			touch.phase = TouchPhase.ENDED;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			Assert.assertFalse("Event.TRIGGERED was incorrectly dispatched", hasTriggered);
		}

		[Test(async)]
		public function testLongPressEvent():void
		{
			var hasLongPressed:Boolean = false;
			this._button.isLongPressEnabled = true;
			this._button.addEventListener(FeathersEventType.LONG_PRESS, function():void
			{
				hasLongPressed = true;
			});
			var touch:Touch = new Touch(0);
			touch.target = this._button;
			touch.phase = TouchPhase.BEGAN;
			touch.globalX = 10;
			touch.globalY = 10;
			var touches:Vector.<Touch> = new <Touch>[touch];
			this._button.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			Async.delayCall(this, function():void
			{
				Assert.assertTrue("FeathersEventType.LONG_PRESS was not dispatched", hasLongPressed);
			}, 600);
		}

	}
}
