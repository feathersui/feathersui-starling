package feathers.tests
{
	import feathers.controls.Button;
	import feathers.events.FeathersEventType;

	import org.flexunit.Assert;
	import org.flexunit.async.Async;

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
		}

		[Test]
		public function testTriggeredEvent():void
		{
			var hasTriggered:Boolean = false;
			this._button.addEventListener(Event.TRIGGERED, function(event:Event):void
			{
				hasTriggered = true;
			});
			var touch:Touch = new Touch(0);
			touch.target = this._button;
			touch.phase = TouchPhase.BEGAN;
			touch.globalX = 10;
			touch.globalY = 10;
			var touches:Vector.<Touch> = new <Touch>[touch];
			this._button.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			//this touch does not move at all, so it should result in triggering
			//the button.
			touch.phase = TouchPhase.ENDED;
			this._button.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			Assert.assertTrue(hasTriggered);
		}

		[Test]
		public function testTouchMoveOutsideBeforeTriggeredEvent():void
		{
			var hasTriggered:Boolean = false;
			this._button.addEventListener(Event.TRIGGERED, function(event:Event):void
			{
				hasTriggered = true;
			});
			var touch:Touch = new Touch(0);
			touch.target = this._button;
			touch.phase = TouchPhase.BEGAN;
			touch.globalX = 10;
			touch.globalY = 10;
			var touches:Vector.<Touch> = new <Touch>[touch];
			this._button.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			touch.globalX = 1000; //move the touch way outside the bounds of the button
			touch.phase = TouchPhase.MOVED;
			this._button.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			touch.phase = TouchPhase.ENDED;
			this._button.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			Assert.assertFalse(hasTriggered);
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
				Assert.assertTrue(hasLongPressed);
			}, 600);
		}

	}
}
