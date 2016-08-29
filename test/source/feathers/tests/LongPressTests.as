package feathers.tests
{
	import feathers.events.FeathersEventType;
	import feathers.utils.touch.LongPress;

	import flash.geom.Point;

	import flexunit.framework.Assert;

	import org.flexunit.async.Async;

	import starling.display.Quad;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class LongPressTests
	{
		private var _target:Quad;
		private var _blocker:Quad;
		private var _longPress:LongPress;

		[Before]
		public function prepare():void
		{
			this._target = new Quad(200, 200, 0xff00ff);
			TestFeathers.starlingRoot.addChild(this._target);
			
			this._longPress = new LongPress(this._target);
		}

		[After]
		public function cleanup():void
		{
			this._target.removeFromParent(true);
			this._target = null;
			
			if(this._blocker)
			{
				this._blocker.removeFromParent(true);
				this._blocker = null;
			}

			this._longPress = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test(async)]
		public function testLongPressEvent():void
		{
			var hasLongPressed:Boolean = false;
			this._target.addEventListener(FeathersEventType.LONG_PRESS, function():void
			{
				hasLongPressed = true;
			});
			var touch:Touch = new Touch(0);
			touch.target = this._target;
			touch.phase = TouchPhase.BEGAN;
			touch.globalX = 10;
			touch.globalY = 10;
			var touches:Vector.<Touch> = new <Touch>[touch];
			this._target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			Async.delayCall(this, function():void
			{
				Assert.assertTrue("FeathersEventType.LONG_PRESS was not dispatched", hasLongPressed);
			}, 600);
		}

		[Test(async)]
		public function testTouchMoveOutsideBeforeLongPressEvent():void
		{
			var hasLongPressed:Boolean = false;
			this._target.addEventListener(FeathersEventType.LONG_PRESS, function():void
			{
				hasLongPressed = true;
			});
			var touch:Touch = new Touch(0);
			touch.target = this._target;
			touch.phase = TouchPhase.BEGAN;
			touch.globalX = 10;
			touch.globalY = 10;
			var touches:Vector.<Touch> = new <Touch>[touch];
			this._target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			touch.globalX = 1000; //move the touch way outside the bounds of the button
			touch.phase = TouchPhase.MOVED;
			this._target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));

			Async.delayCall(this, function():void
			{
				Assert.assertFalse("FeathersEventType.LONG_PRESS was incorrectly dispatched after touch moved out of bounds", hasLongPressed);
			}, 600);
		}

		[Test(async)]
		public function testOtherDisplayObjectBlockingLongPressEvent():void
		{
			var hasLongPressed:Boolean = false;
			this._target.addEventListener(FeathersEventType.LONG_PRESS, function():void
			{
				hasLongPressed = true;
			});
			var touch:Touch = new Touch(0);
			touch.target = this._target;
			touch.phase = TouchPhase.BEGAN;
			touch.globalX = 10;
			touch.globalY = 10;
			var touches:Vector.<Touch> = new <Touch>[touch];
			this._target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			
			this._blocker = new Quad(200, 200, 0xff0000);
			TestFeathers.starlingRoot.addChild(this._blocker);
			
			Async.delayCall(this, function():void
			{
				Assert.assertFalse("FeathersEventType.LONG_PRESS was incorrectly dispatched when another display object blocked the touch", hasLongPressed);
			}, 600);
		}

		[Test(async)]
		public function testRemovedBeforeLongPressEvent():void
		{
			var hasLongPressed:Boolean = false;
			this._target.addEventListener(FeathersEventType.LONG_PRESS, function():void
			{
				hasLongPressed = true;
			});
			var touch:Touch = new Touch(0);
			touch.target = this._target;
			touch.phase = TouchPhase.BEGAN;
			touch.globalX = 10;
			touch.globalY = 10;
			var touches:Vector.<Touch> = new <Touch>[touch];
			this._target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));

			this._target.removeFromParent(false);

			Async.delayCall(this, function():void
			{
				Assert.assertFalse("FeathersEventType.LONG_PRESS was incorrectly dispatched when target was removed", hasLongPressed);
			}, 600);
		}

		[Test(async)]
		public function testDisabled():void
		{
			this._longPress.isEnabled = false;

			var hasLongPressed:Boolean = false;
			this._target.addEventListener(FeathersEventType.LONG_PRESS, function():void
			{
				hasLongPressed = true;
			});
			var touch:Touch = new Touch(0);
			touch.target = this._target;
			touch.phase = TouchPhase.BEGAN;
			touch.globalX = 10;
			touch.globalY = 10;
			var touches:Vector.<Touch> = new <Touch>[touch];
			this._target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));

			Async.delayCall(this, function():void
			{
				Assert.assertFalse("FeathersEventType.LONG_PRESS was incorrectly dispatched when disabled", hasLongPressed);
			}, 600);
		}

		[Test(async)]
		public function testCustomHitTestReturnTrue():void
		{
			this._longPress.customHitTest = function customHitTest(localPosition:Point):Boolean
			{
				return localPosition.x <= 100;
			};
			var hasLongPressed:Boolean = false;
			this._target.addEventListener(FeathersEventType.LONG_PRESS, function ():void
			{
				hasLongPressed = true;
			});
			var touch:Touch = new Touch(0);
			touch.target = this._target;
			touch.phase = TouchPhase.BEGAN;
			touch.globalX = 10;
			touch.globalY = 10;
			var touches:Vector.<Touch> = new <Touch>[touch];
			Async.delayCall(this, function ():void
			{
				Assert.assertFalse("FeathersEventType.LONG_PRESS was not dispatched when customHitTest returned true", hasLongPressed);
			}, 600);
		}

		[Test(async)]
		public function testCustomHitTestReturnFalse():void
		{
			this._longPress.customHitTest = function customHitTest(localPosition:Point):Boolean
			{
				return localPosition.x <= 100;
			};
			var hasLongPressed:Boolean = false;
			this._target.addEventListener(FeathersEventType.LONG_PRESS, function ():void
			{
				hasLongPressed = true;
			});
			var touch:Touch = new Touch(0);
			touch.target = this._target;
			touch.phase = TouchPhase.BEGAN;
			touch.globalX = 150;
			touch.globalY = 10;
			var touches:Vector.<Touch> = new <Touch>[touch];
			Async.delayCall(this, function ():void
			{
				Assert.assertFalse("FeathersEventType.LONG_PRESS was incorrect dispatched when customHitTest returned false", hasLongPressed);
			}, 600);
		}
	}
}
