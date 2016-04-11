package feathers.tests
{
	import feathers.controls.Button;
	import feathers.controls.ButtonState;
	import feathers.events.FeathersEventType;
	import feathers.tests.supportClasses.DisposeFlagQuad;

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
		private var _blocker:Quad;

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

		[Test(async)]
		public function testLongPressEvent():void
		{
			var hasLongPressed:Boolean = false;
			this._button.isLongPressEnabled = true;
			this._button.validate();
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

		[Test(async)]
		public function testTouchMoveOutsideBeforeLongPressEvent():void
		{
			var hasLongPressed:Boolean = false;
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
			touch.globalX = 1000; //move the touch way outside the bounds of the button
			touch.phase = TouchPhase.MOVED;
			this._button.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));

			Async.delayCall(this, function():void
			{
				Assert.assertFalse("FeathersEventType.LONG_PRESS was incorrectly dispatched after touch moved out of bounds", hasLongPressed);
			}, 600);
		}

		[Test(async)]
		public function testOtherDisplayObjectBlockingLongPressEvent():void
		{
			var hasLongPressed:Boolean = false;
			this._button.isLongPressEnabled = true;
			this._button.validate();
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
			
			this._blocker = new Quad(200, 200, 0xff0000);
			TestFeathers.starlingRoot.addChild(this._blocker);
			
			Async.delayCall(this, function():void
			{
				Assert.assertFalse("FeathersEventType.LONG_PRESS was incorrectly dispatched", hasLongPressed);
			}, 600);
		}

		[Test]
		public function testSkinsDisposed():void
		{
			var defaultSkin:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.defaultSkin = defaultSkin;
			var upSkin:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.upSkin = upSkin;
			var downSkin:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.downSkin = downSkin;
			var hoverSkin:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.hoverSkin = hoverSkin;
			var disabledSkin:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.disabledSkin = disabledSkin;
			this._button.validate();
			this._button.dispose();
			Assert.assertTrue("defaultSkin not disposed when Button disposed.", defaultSkin.isDisposed);
			Assert.assertTrue("upSkin not disposed when Button disposed.", upSkin.isDisposed);
			Assert.assertTrue("downSkin not disposed when Button disposed.", downSkin.isDisposed);
			Assert.assertTrue("hoverSkin not disposed when Button disposed.", hoverSkin.isDisposed);
			Assert.assertTrue("disabledSkin not disposed when Button disposed.", disabledSkin.isDisposed);
		}

		[Test]
		public function testIconsDisposed():void
		{
			var defaultIcon:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.defaultIcon = defaultIcon;
			var upIcon:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.upIcon = upIcon;
			var downIcon:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.downSkin = downIcon;
			var hoverIcon:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.hoverIcon = hoverIcon;
			var disabledIcon:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.disabledIcon = disabledIcon;
			this._button.validate();
			this._button.dispose();
			Assert.assertTrue("defaultIcon not disposed when Button disposed.", defaultIcon.isDisposed);
			Assert.assertTrue("upIcon not disposed when Button disposed.", upIcon.isDisposed);
			Assert.assertTrue("downIcon not disposed when Button disposed.", downIcon.isDisposed);
			Assert.assertTrue("hoverIcon not disposed when Button disposed.", hoverIcon.isDisposed);
			Assert.assertTrue("disabledIcon not disposed when Button disposed.", disabledIcon.isDisposed);
		}

		[Test]
		public function testIconsRemovedWhenSetToNull():void
		{
			var defaultIcon:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.defaultIcon = defaultIcon;
			var upIcon:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.setIconForState(ButtonState.UP, upIcon);
			var downIcon:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.setIconForState(ButtonState.DOWN, downIcon);
			var hoverIcon:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.setIconForState(ButtonState.HOVER, hoverIcon);
			var disabledIcon:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.setIconForState(ButtonState.DISABLED, disabledIcon);
			this._button.validate();
			this._button.defaultIcon = null;
			this._button.setIconForState(ButtonState.UP, null);
			this._button.setIconForState(ButtonState.DOWN, null);
			this._button.setIconForState(ButtonState.HOVER, null);
			this._button.setIconForState(ButtonState.DISABLED, null);
			//should not need to validate here
			this._button.dispose();
			Assert.assertFalse("Removed defaultIcon incorrectly disposed when Button disposed.", defaultIcon.isDisposed);
			Assert.assertFalse("Removed upIcon incorrectly disposed when Button disposed.", upIcon.isDisposed);
			Assert.assertFalse("Removed downIcon incorrectly disposed when Button disposed.", downIcon.isDisposed);
			Assert.assertFalse("Removed hoverIcon incorrectly disposed when Button disposed.", hoverIcon.isDisposed);
			Assert.assertFalse("Removed disabledIcon incorrectly disposed when Button disposed.", disabledIcon.isDisposed);
			Assert.assertNull("defaultIcon parent must be null when removed from Button.", defaultIcon.parent);
			Assert.assertNull("upIcon parent must be null when removed from Button.", upIcon.parent);
			Assert.assertNull("downIcon parent must be null when removed from Button.", downIcon.parent);
			Assert.assertNull("hoverIcon parent must be null when removed from Button.", hoverIcon.parent);
			Assert.assertNull("disabledIcon parent must be null when removed from Button.", disabledIcon.parent);
			defaultIcon.dispose();
			upIcon.dispose();
			downIcon.dispose();
			hoverIcon.dispose();
			disabledIcon.dispose();
		}

	}
}
