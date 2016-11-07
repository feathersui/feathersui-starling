package feathers.tests
{
	import feathers.controls.BasicButton;
	import feathers.controls.ButtonState;
	import feathers.events.FeathersEventType;
	import feathers.tests.supportClasses.DisposeFlagQuad;

	import flash.geom.Point;

	import org.flexunit.Assert;

	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class BasicButtonTests
	{
		private var _button:BasicButton;
		private var _blocker:Quad;

		[Before]
		public function prepare():void
		{
			this._button = new BasicButton();
			this._button.defaultSkin = new Quad(200, 200, 0xff00ff);
			TestFeathers.starlingRoot.addChild(this._button);
			this._button.validate();
		}

		[After]
		public function cleanup():void
		{
			this._button.removeFromParent(true);
			this._button = null;

			if(this._blocker)
			{
				this._blocker.removeFromParent(true);
				this._blocker = null;
			}

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
			var target:DisplayObject = this._button.stage.hitTest(position);
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
			var target:DisplayObject = this._button.stage.hitTest(position);
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

		[Test]
		public function testOtherDisplayObjectBlockingTriggeredEvent():void
		{
			var hasTriggered:Boolean = false;
			this._button.addEventListener(Event.TRIGGERED, function(event:Event):void
			{
				hasTriggered = true;
			});
			var position:Point = new Point(10, 10);
			var target:DisplayObject = this._button.stage.hitTest(position);
			var touch:Touch = new Touch(0);
			touch.target = target;
			touch.phase = TouchPhase.BEGAN;
			touch.globalX = position.x;
			touch.globalY = position.y;
			var touches:Vector.<Touch> = new <Touch>[touch];
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));

			this._blocker = new Quad(200, 200, 0xff0000);
			TestFeathers.starlingRoot.addChild(this._blocker);

			touch.phase = TouchPhase.ENDED;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));

			Assert.assertFalse("Event.TRIGGERED was incorrectly dispatched", hasTriggered);
		}

		[Test]
		public function testButtonDefaultsToButtonStateUp():void
		{
			Assert.assertStrictlyEquals("Button currentState does not default to ButtonState.UP", ButtonState.UP, this._button.currentState);
		}

		[Test]
		public function testButtonDefaultsToButtonStateDisabledWhenIsEnabledIsFalse():void
		{
			this._button.isEnabled = false;
			Assert.assertStrictlyEquals("Button currentState does not default to ButtonState.DISABLED when isEnabled is false", ButtonState.DISABLED, this._button.currentState);
		}

		[Test]
		public function testButtonStateHoverOnTouchPhaseHover():void
		{
			var hasDispatchedStateChange:Boolean = false;
			this._button.addEventListener(FeathersEventType.STATE_CHANGE, function(event:Event):void
			{
				var button:BasicButton = BasicButton(event.currentTarget);
				if(button.currentState === ButtonState.HOVER)
				{
					hasDispatchedStateChange = true;
				}
			});
			var position:Point = new Point(10, 10);
			var target:DisplayObject = this._button.stage.hitTest(position);
			var touch:Touch = new Touch(0);
			touch.target = target;
			touch.phase = TouchPhase.HOVER;
			touch.globalX = position.x;
			touch.globalY = position.y;
			var touches:Vector.<Touch> = new <Touch>[touch];
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			Assert.assertStrictlyEquals("Button currentState was not changed to ButtonState.HOVER on TouchPhase.HOVER",
				ButtonState.HOVER, this._button.currentState);
			Assert.assertTrue("Button must dispatch FeathersEventType.STATE_CHANGE when state is changed to ButtonState.HOVER",
				hasDispatchedStateChange);
		}

		[Test]
		public function testButtonStateUpAfterHoverOut():void
		{
			var position:Point = new Point(10, 10);
			var target:DisplayObject = this._button.stage.hitTest(position);
			var touch:Touch = new Touch(0);
			touch.target = target;
			touch.phase = TouchPhase.HOVER;
			touch.globalX = position.x;
			touch.globalY = position.y;
			var touches:Vector.<Touch> = new <Touch>[touch];
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			var hasDispatchedStateChange:Boolean = false;
			this._button.addEventListener(FeathersEventType.STATE_CHANGE, function(event:Event):void
			{
				var button:BasicButton = BasicButton(event.currentTarget);
				if(button.currentState === ButtonState.UP)
				{
					hasDispatchedStateChange = true;
				}
			});
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, new <Touch>[]));
			Assert.assertStrictlyEquals("Button currentState was not changed to ButtonState.UP when TouchPhase.HOVER ends",
				ButtonState.UP, this._button.currentState);
			Assert.assertTrue("Button must dispatch FeathersEventType.STATE_CHANGE when state is changed to ButtonState.UP",
				hasDispatchedStateChange);
		}

		[Test]
		public function testButtonStateDownOnTouchPhaseBegan():void
		{
			var hasDispatchedStateChange:Boolean = false;
			this._button.addEventListener(FeathersEventType.STATE_CHANGE, function(event:Event):void
			{
				var button:BasicButton = BasicButton(event.currentTarget);
				if(button.currentState === ButtonState.DOWN)
				{
					hasDispatchedStateChange = true;
				}
			});
			var position:Point = new Point(10, 10);
			var target:DisplayObject = this._button.stage.hitTest(position);
			var touch:Touch = new Touch(0);
			touch.target = target;
			touch.phase = TouchPhase.BEGAN;
			touch.globalX = position.x;
			touch.globalY = position.y;
			var touches:Vector.<Touch> = new <Touch>[touch];
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			Assert.assertStrictlyEquals("Button currentState was not changed to ButtonState.DOWN on TouchPhase.BEGAN",
				ButtonState.DOWN, this._button.currentState);
			Assert.assertTrue("Button must dispatch FeathersEventType.STATE_CHANGE when state is changed to ButtonState.DOWN",
				hasDispatchedStateChange);
		}

		[Test]
		public function testButtonStateUpOnTouchPhaseMoveOutside():void
		{
			var position:Point = new Point(10, 10);
			var target:DisplayObject = this._button.stage.hitTest(position);
			var touch:Touch = new Touch(0);
			touch.target = target;
			touch.phase = TouchPhase.BEGAN;
			touch.globalX = position.x;
			touch.globalY = position.y;
			var touches:Vector.<Touch> = new <Touch>[touch];
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			var hasDispatchedStateChange:Boolean = false;
			this._button.addEventListener(FeathersEventType.STATE_CHANGE, function(event:Event):void
			{
				var button:BasicButton = BasicButton(event.currentTarget);
				if(button.currentState === ButtonState.UP)
				{
					hasDispatchedStateChange = true;
				}
			});
			touch.phase = TouchPhase.MOVED;
			touch.globalX = 1000;
			touch.globalY = position.y;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			Assert.assertStrictlyEquals("Button currentState was not changed to ButtonState.UP on TouchPhase.MOVED when position is outside button",
				ButtonState.UP, this._button.currentState);
			Assert.assertTrue("Button must dispatch FeathersEventType.STATE_CHANGE when state is changed to ButtonState.UP",
				hasDispatchedStateChange);
		}

		[Test]
		public function testButtonStateDownOnTouchPhaseMoveOutsideAndBackInside():void
		{
			var position:Point = new Point(10, 10);
			var target:DisplayObject = this._button.stage.hitTest(position);
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
			var hasDispatchedStateChange:Boolean = false;
			this._button.addEventListener(FeathersEventType.STATE_CHANGE, function(event:Event):void
			{
				var button:BasicButton = BasicButton(event.currentTarget);
				if(button.currentState === ButtonState.DOWN)
				{
					hasDispatchedStateChange = true;
				}
			});
			touch.globalX = 10;
			touch.globalY = position.y;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			Assert.assertStrictlyEquals("Button currentState was not changed to ButtonState.DOWN on TouchPhase.MOVED when position moves outside button then back inside",
				ButtonState.DOWN, this._button.currentState);
			Assert.assertTrue("Button must dispatch FeathersEventType.STATE_CHANGE when state is changed to ButtonState.DOWN",
				hasDispatchedStateChange);
		}

		[Test]
		public function testButtonStateUpOnTouchPhaseMoveOutsideAndKeepDownStateOnRollOutIsTrue():void
		{
			this._button.keepDownStateOnRollOut = true;
			var position:Point = new Point(10, 10);
			var target:DisplayObject = this._button.stage.hitTest(position);
			var touch:Touch = new Touch(0);
			touch.target = target;
			touch.phase = TouchPhase.BEGAN;
			touch.globalX = position.x;
			touch.globalY = position.y;
			var touches:Vector.<Touch> = new <Touch>[touch];
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			var hasDispatchedStateChange:Boolean = false;
			this._button.addEventListener(FeathersEventType.STATE_CHANGE, function(event:Event):void
			{
				hasDispatchedStateChange = true;
			});
			touch.phase = TouchPhase.MOVED;
			touch.globalX = 1000;
			touch.globalY = position.y;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			Assert.assertStrictlyEquals("Button currentState was incorrectly changed from ButtonState.DOWN on TouchPhase.MOVED when position is outside button and keepDownStateOnRollOut is true",
				ButtonState.DOWN, this._button.currentState);
			Assert.assertFalse("Button must not dispatch FeathersEventType.STATE_CHANGE when keepDownStateOnRollOut is true and state does not changed on roll out",
				hasDispatchedStateChange);
		}

		[Test]
		public function testButtonStateUpOnTouchPhaseEnded():void
		{
			var position:Point = new Point(10, 10);
			var target:DisplayObject = this._button.stage.hitTest(position);
			var touch:Touch = new Touch(0);
			touch.target = target;
			touch.phase = TouchPhase.BEGAN;
			touch.globalX = position.x;
			touch.globalY = position.y;
			var touches:Vector.<Touch> = new <Touch>[touch];
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			var hasDispatchedStateChange:Boolean = false;
			this._button.addEventListener(FeathersEventType.STATE_CHANGE, function(event:Event):void
			{
				var button:BasicButton = BasicButton(event.currentTarget);
				if(button.currentState === ButtonState.UP)
				{
					hasDispatchedStateChange = true;
				}
			});
			touch.phase = TouchPhase.ENDED;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			Assert.assertStrictlyEquals("Button currentState was not changed to ButtonState.UP on TouchPhase.ENDED",
				ButtonState.UP, this._button.currentState);
			Assert.assertTrue("Button must dispatch FeathersEventType.STATE_CHANGE when state is changed to ButtonState.UP",
				hasDispatchedStateChange);
		}

		[Test]
		public function testSkinsDisposed():void
		{
			var defaultSkin:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.defaultSkin = defaultSkin;
			var upSkin:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.setSkinForState(ButtonState.UP, upSkin);
			var downSkin:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.setSkinForState(ButtonState.DOWN, downSkin);
			var hoverSkin:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.setSkinForState(ButtonState.HOVER, hoverSkin);
			var disabledSkin:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.setSkinForState(ButtonState.DISABLED, disabledSkin);
			this._button.validate();
			this._button.dispose();
			Assert.assertTrue("defaultSkin not disposed when Button disposed.", defaultSkin.isDisposed);
			Assert.assertTrue("upSkin not disposed when Button disposed.", upSkin.isDisposed);
			Assert.assertTrue("downSkin not disposed when Button disposed.", downSkin.isDisposed);
			Assert.assertTrue("hoverSkin not disposed when Button disposed.", hoverSkin.isDisposed);
			Assert.assertTrue("disabledSkin not disposed when Button disposed.", disabledSkin.isDisposed);
		}

		[Test]
		public function testSkinsRemovedWhenSetToNull():void
		{
			var defaultSkin:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.defaultSkin = defaultSkin;
			var upSkin:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.setSkinForState(ButtonState.UP, upSkin);
			var downSkin:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.setSkinForState(ButtonState.DOWN, downSkin);
			var hoverSkin:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.setSkinForState(ButtonState.HOVER, hoverSkin);
			var disabledSkin:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.setSkinForState(ButtonState.DISABLED, disabledSkin);
			this._button.validate();
			this._button.defaultSkin = null;
			this._button.setSkinForState(ButtonState.UP, null);
			this._button.setSkinForState(ButtonState.DOWN, null);
			this._button.setSkinForState(ButtonState.HOVER, null);
			this._button.setSkinForState(ButtonState.DISABLED, null);
			//should not need to validate here
			this._button.dispose();
			Assert.assertFalse("Removed defaultSkin incorrectly disposed when Button disposed.", defaultSkin.isDisposed);
			Assert.assertFalse("Removed upSkin incorrectly disposed when Button disposed.", upSkin.isDisposed);
			Assert.assertFalse("Removed downSkin incorrectly disposed when Button disposed.", downSkin.isDisposed);
			Assert.assertFalse("Removed hoverSkin incorrectly disposed when Button disposed.", hoverSkin.isDisposed);
			Assert.assertFalse("Removed disabledSkin incorrectly disposed when Button disposed.", disabledSkin.isDisposed);
			Assert.assertNull("defaultSkin parent must be null when removed from Button.", defaultSkin.parent);
			Assert.assertNull("upSkin parent must be null when removed from Button.", upSkin.parent);
			Assert.assertNull("downSkin parent must be null when removed from Button.", downSkin.parent);
			Assert.assertNull("hoverSkin parent must be null when removed from Button.", hoverSkin.parent);
			Assert.assertNull("disabledSkin parent must be null when removed from Button.", disabledSkin.parent);
			defaultSkin.dispose();
			upSkin.dispose();
			downSkin.dispose();
			hoverSkin.dispose();
			disabledSkin.dispose();
		}
	}
}
