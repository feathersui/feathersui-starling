package feathers.tests
{
	import feathers.controls.ButtonState;
	import feathers.utils.touch.TouchToState;

	import flash.geom.Point;

	import org.flexunit.Assert;

	import starling.display.DisplayObject;

	import starling.display.Quad;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class TouchToStateTests
	{
		private var _target:Quad;
		private var _blocker:Quad;
		private var _touchToState:TouchToState;

		[Before]
		public function prepare():void
		{
			this._target = new Quad(200, 200, 0xff00ff);
			TestFeathers.starlingRoot.addChild(this._target);

			this._touchToState = new TouchToState(this._target);
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

			this._touchToState = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testDownState():void
		{
			var hasCalledCallback:Boolean = false;
			var currentState:String = ButtonState.UP;
			this._touchToState.callback = function(value:String):void
			{
				if(currentState === value)
				{
					return;
				}
				hasCalledCallback = true;
				currentState = value;
			};
			var position:Point = new Point(10, 10);
			var target:DisplayObject = this._target.stage.hitTest(position);
			var touch:Touch = new Touch(0);
			touch.target = target;
			touch.phase = TouchPhase.BEGAN;
			touch.globalX = position.x;
			touch.globalY = position.y;
			var touches:Vector.<Touch> = new <Touch>[touch];
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			Assert.assertTrue("TouchToState callback was not called on TouchPhase.BEGAN",
				hasCalledCallback);
			Assert.assertStrictlyEquals("TouchToState did not change state to ButtonState.DOWN on TouchPhase.BEGAN",
				ButtonState.DOWN, this._touchToState.currentState);
			Assert.assertStrictlyEquals("TouchToState did not pass the correct state to callback TouchPhase.BEGAN",
				ButtonState.DOWN, currentState);
		}

		[Test]
		public function testHoverState():void
		{
			var hasCalledCallback:Boolean = false;
			var currentState:String = ButtonState.UP;
			this._touchToState.callback = function(value:String):void
			{
				if(currentState === value)
				{
					return;
				}
				hasCalledCallback = true;
				currentState = value;
			};
			var position:Point = new Point(10, 10);
			var target:DisplayObject = this._target.stage.hitTest(position);
			var touch:Touch = new Touch(0);
			touch.target = target;
			touch.phase = TouchPhase.HOVER;
			touch.globalX = position.x;
			touch.globalY = position.y;
			var touches:Vector.<Touch> = new <Touch>[touch];
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			Assert.assertTrue("TouchToState callback was not called on TouchPhase.HOVER",
				hasCalledCallback);
			Assert.assertStrictlyEquals("TouchToState did not change state to ButtonState.HOVER on TouchPhase.HOVER",
				ButtonState.HOVER, this._touchToState.currentState);
			Assert.assertStrictlyEquals("TouchToState did not pass the correct state to callback on TouchPhase.HOVER",
				ButtonState.HOVER, currentState);
		}

		[Test]
		public function testUpStateAfterHoverEnd():void
		{
			var position:Point = new Point(10, 10);
			var target:DisplayObject = this._target.stage.hitTest(position);
			var touch:Touch = new Touch(0);
			touch.target = target;
			touch.phase = TouchPhase.HOVER;
			touch.globalX = position.x;
			touch.globalY = position.y;
			var touches:Vector.<Touch> = new <Touch>[touch];
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			var hasCalledCallback:Boolean = false;
			var currentState:String = ButtonState.HOVER;
			this._touchToState.callback = function(value:String):void
			{
				if(currentState === value)
				{
					return;
				}
				hasCalledCallback = true;
				currentState = value;
			};
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, new <Touch>[]));

			Assert.assertTrue("TouchToState callback was not called on no touches",
				hasCalledCallback);
			Assert.assertStrictlyEquals("TouchToState did not change state to ButtonState.UP on no touches",
				ButtonState.UP, this._touchToState.currentState);
			Assert.assertStrictlyEquals("TouchToState did not pass the correct state to callback on TouchPhase.HOVER end",
				ButtonState.UP, currentState);
		}

		[Test]
		public function testUpStateOnTouchEndedIfNoHoverBeforeBegan():void
		{
			var position:Point = new Point(10, 10);
			var target:DisplayObject = this._target.stage.hitTest(position);
			var touch:Touch = new Touch(0);
			touch.target = target;
			touch.phase = TouchPhase.HOVER;
			touch.globalX = position.x;
			touch.globalY = position.y;
			var touches:Vector.<Touch> = new <Touch>[touch];
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			var hasCalledCallback:Boolean = false;
			var currentState:String = ButtonState.DOWN;
			this._touchToState.callback = function(value:String):void
			{
				if(currentState === value)
				{
					return;
				}
				hasCalledCallback = true;
				currentState = value;
			};
			touch.phase = TouchPhase.ENDED;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));

			Assert.assertTrue("TouchToState callback was not called on TouchPhase.ENDED",
				hasCalledCallback);
			Assert.assertStrictlyEquals("TouchToState did not change state to ButtonState.UP on TouchPhase.ENDED",
				ButtonState.UP, this._touchToState.currentState);
			Assert.assertStrictlyEquals("TouchToState did not pass the correct state to callback on TouchPhase.ENDED",
				ButtonState.UP, currentState);
		}

		[Test]
		public function testUpStateOnRemovedFromStage():void
		{
			var position:Point = new Point(10, 10);
			var target:DisplayObject = this._target.stage.hitTest(position);
			var touch:Touch = new Touch(0);
			touch.target = target;
			touch.phase = TouchPhase.BEGAN;
			touch.globalX = position.x;
			touch.globalY = position.y;
			var touches:Vector.<Touch> = new <Touch>[touch];
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			var hasCalledCallback:Boolean = false;
			var currentState:String = ButtonState.DOWN;
			this._touchToState.callback = function(value:String):void
			{
				if(currentState === value)
				{
					return;
				}
				hasCalledCallback = true;
				currentState = value;
			};
			this._target.removeFromParent(false);

			Assert.assertTrue("TouchToState callback was not called on removed from stage",
				hasCalledCallback);
			Assert.assertStrictlyEquals("TouchToState did not change state to ButtonState.UP on removed from stage",
				ButtonState.UP, this._touchToState.currentState);
			Assert.assertStrictlyEquals("TouchToState did not pass the correct state to callback on removed from stage",
				ButtonState.UP, currentState);
		}

		[Test]
		public function testUpStateOnTouchPhaseMoveOutside():void
		{
			var position:Point = new Point(10, 10);
			var target:DisplayObject = this._target.stage.hitTest(position);
			var touch:Touch = new Touch(0);
			touch.target = target;
			touch.phase = TouchPhase.BEGAN;
			touch.globalX = position.x;
			touch.globalY = position.y;
			var touches:Vector.<Touch> = new <Touch>[touch];
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			var hasCalledCallback:Boolean = false;
			var currentState:String = ButtonState.DOWN;
			this._touchToState.callback = function(value:String):void
			{
				if(currentState === value)
				{
					return;
				}
				hasCalledCallback = true;
				currentState = value;
			};
			touch.phase = TouchPhase.MOVED;
			touch.globalX = 1000;
			touch.globalY = position.y;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));

			Assert.assertTrue("TouchToState callback was not called on TouchPhase.MOVED outside",
				hasCalledCallback);
			Assert.assertStrictlyEquals("TouchToState did not change state to ButtonState.UP on TouchPhase.MOVED outside",
				ButtonState.UP, this._touchToState.currentState);
			Assert.assertStrictlyEquals("TouchToState did not pass the correct state to callback on TouchPhase.MOVED outside",
				ButtonState.UP, currentState);
		}

		[Test]
		public function testUpStateOnTouchPhaseMoveOutsideAndBackIn():void
		{
			var position:Point = new Point(10, 10);
			var target:DisplayObject = this._target.stage.hitTest(position);
			var touch:Touch = new Touch(0);
			touch.target = target;
			touch.phase = TouchPhase.BEGAN;
			touch.globalX = position.x;
			touch.globalY = position.y;
			var touches:Vector.<Touch> = new <Touch>[touch];
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			touch.phase = TouchPhase.MOVED;
			touch.globalX = 1000;
			touch.globalY = position.y;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			var hasCalledCallback:Boolean = false;
			var currentState:String = ButtonState.UP;
			this._touchToState.callback = function(value:String):void
			{
				if(currentState === value)
				{
					return;
				}
				hasCalledCallback = true;
				currentState = value;
			};
			touch.globalX = position.x;
			touch.globalY = position.y;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));

			Assert.assertTrue("TouchToState callback was not called on TouchPhase.MOVED outside and back in",
				hasCalledCallback);
			Assert.assertStrictlyEquals("TouchToState did not change state to ButtonState.DOWN on TouchPhase.MOVED outside and back in",
				ButtonState.DOWN, this._touchToState.currentState);
			Assert.assertStrictlyEquals("TouchToState did not pass the correct state to callback on TouchPhase.MOVED outside and back in",
				ButtonState.DOWN, currentState);
		}

		[Test]
		public function testDownStateOnTouchPhaseMoveOutsideAndKeepDownStateOnRollOut():void
		{
			this._touchToState.keepDownStateOnRollOut = true;
			var position:Point = new Point(10, 10);
			var target:DisplayObject = this._target.stage.hitTest(position);
			var touch:Touch = new Touch(0);
			touch.target = target;
			touch.phase = TouchPhase.BEGAN;
			touch.globalX = position.x;
			touch.globalY = position.y;
			var touches:Vector.<Touch> = new <Touch>[touch];
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			var hasCalledCallback:Boolean = false;
			var currentState:String = ButtonState.DOWN;
			this._touchToState.callback = function(value:String):void
			{
				if(currentState === value)
				{
					return;
				}
				hasCalledCallback = true;
				currentState = value;
			};
			touch.phase = TouchPhase.MOVED;
			touch.globalX = 1000;
			touch.globalY = position.y;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));

			Assert.assertFalse("TouchToState callback must not be called on TouchPhase.MOVED outside when keepDownStateOnRollOut is true",
				hasCalledCallback);
			Assert.assertStrictlyEquals("TouchToState must not change state on TouchPhase.MOVED outside when keepDownStateOnRollOut is true",
				ButtonState.DOWN, this._touchToState.currentState);
		}

		[Test]
		public function testHoverStateOnTouchEndedIfHoverBeforeBegan():void
		{
			var position:Point = new Point(10, 10);
			var target:DisplayObject = this._target.stage.hitTest(position);
			var touch:Touch = new Touch(0);
			touch.target = target;
			touch.phase = TouchPhase.HOVER;
			touch.globalX = position.x;
			touch.globalY = position.y;
			var touches:Vector.<Touch> = new <Touch>[touch];
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			touch.phase = TouchPhase.BEGAN;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			var currentState:String = ButtonState.DOWN;
			this._touchToState.callback = function(value:String):void
			{
				if(currentState === value)
				{
					return;
				}
				currentState = value;
			};
			touch.phase = TouchPhase.ENDED;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));

			Assert.assertStrictlyEquals("TouchToState must change state to ButtonState.HOVER on TouchPhase.ENDED if TouchPhase.HOVER is dispatched before TouchPhase.BEGAN",
				ButtonState.HOVER, this._touchToState.currentState);
		}
	}
}
