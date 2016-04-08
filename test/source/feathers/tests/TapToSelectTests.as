package feathers.tests
{
	import feathers.tests.supportClasses.CustomToggle;
	import feathers.utils.touch.TapToSelect;

	import flash.geom.Point;

	import org.flexunit.Assert;

	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class TapToSelectTests
	{
		private var _target:CustomToggle;
		private var _blocker:Quad;
		private var _tapToSelect:TapToSelect;

		[Before]
		public function prepare():void
		{
			this._target = new CustomToggle();
			TestFeathers.starlingRoot.addChild(this._target);
			this._target.validate();

			this._tapToSelect = new TapToSelect(this._target);
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

			this._tapToSelect = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testChangeEvent():void
		{
			this._target.isSelected = false;
			
			var hasChanged:Boolean = false;
			this._target.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			var position:Point = new Point(10, 10);
			var target:DisplayObject = this._target.stage.hitTest(position);
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
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertTrue("isSelected was not changed to true after tap", this._target.isSelected);
		}

		[Test]
		public function testDisabled():void
		{
			this._target.isSelected = false;
			this._tapToSelect.isEnabled = false;
			
			var hasChanged:Boolean = false;
			this._target.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			var position:Point = new Point(10, 10);
			var target:DisplayObject = this._target.stage.hitTest(position);
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
			Assert.assertFalse("Event.CHANGE was incorrectly dispatched when disabled", hasChanged);
			Assert.assertFalse("isSelected was incorrectly changed to true after tap when disabled", this._target.isSelected);
		}

		[Test]
		public function testTouchMoveOutsideBeforeChangeEvent():void
		{
			this._target.isSelected = false;
			
			var hasChanged:Boolean = false;
			this._target.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			var position:Point = new Point(10, 10);
			var target:DisplayObject = this._target.stage.hitTest(position);
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
			Assert.assertFalse("Event.CHANGE was incorrectly dispatched after touch moved out of bounds", hasChanged);
			Assert.assertFalse("isSelected was incorrectly changed to true after touch moved out of bounds", this._target.isSelected);
		}

		[Test]
		public function testOtherDisplayObjectBlockingChangeEvent():void
		{
			this._target.isSelected = false;
			
			var hasChanged:Boolean = false;
			this._target.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			var position:Point = new Point(10, 10);
			var target:DisplayObject = this._target.stage.hitTest(position);
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

			Assert.assertFalse("Event.CHANGE was incorrectly dispatched when another display object blocked the touch", hasChanged);
			Assert.assertFalse("isSelected was incorrectly changed to true when another display object blocked the touch", this._target.isSelected);
		}

		[Test]
		public function testDeselect():void
		{
			this._tapToSelect.tapToDeselect = true;
			this._target.isSelected = true;
			
			var position:Point = new Point(10, 10);
			var target:DisplayObject = this._target.stage.hitTest(position);
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
			Assert.assertFalse("isSelected was not changed to false when tapToDeselect set to true", this._target.isSelected);
		}

		[Test]
		public function testDisabledDeselect():void
		{
			this._tapToSelect.tapToDeselect = false;
			this._target.isSelected = true;

			var position:Point = new Point(10, 10);
			var target:DisplayObject = this._target.stage.hitTest(position);
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
			Assert.assertTrue("isSelected was incorrectly changed to false when tapToDeselect set to false", this._target.isSelected);
		}

		[Test]
		public function testRemovedBeforeTriggeredEvent():void
		{
			this._target.isSelected = false;

			var hasChanged:Boolean = false;
			this._target.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			var position:Point = new Point(10, 10);
			var target:DisplayObject = this._target.stage.hitTest(position);
			var touch:Touch = new Touch(0);
			touch.target = target;
			touch.phase = TouchPhase.BEGAN;
			touch.globalX = position.x;
			touch.globalY = position.y;
			var touches:Vector.<Touch> = new <Touch>[touch];
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));

			this._target.removeFromParent(false);

			touch.phase = TouchPhase.ENDED;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));

			//while it's good to check that Event.CHANGE isn't dispatched,
			//this test also ensures that no runtime errors are thrown after the
			//target is removed (its stage property is null, and that is used
			//by TapToSelect)

			Assert.assertFalse("Event.CHANGE was incorrectly dispatched when target was removed", hasChanged);
			Assert.assertFalse("isSelected was incorrectly changed to true when target was removed", this._target.isSelected);
		}
	}
}