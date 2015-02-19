package feathers.tests
{
	import feathers.controls.ToggleButton;

	import flash.geom.Point;

	import org.flexunit.Assert;

	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class ToggleButtonTests
	{
		private var _button:ToggleButton;

		[Before]
		public function prepare():void
		{
			this._button = new ToggleButton();
			this._button.isSelected = true;
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
		public function testProgrammaticChangeEvent():void
		{
			var beforeIsSelected:Boolean = this._button.isSelected;
			var hasChanged:Boolean = false;
			this._button.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._button.isSelected = !this._button.isSelected;
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertFalse("This isSelected property was not changed", beforeIsSelected === this._button.isSelected);
		}

		[Test]
		public function testInteractiveChangeEvent():void
		{
			var beforeIsSelected:Boolean = this._button.isSelected;
			var hasChanged:Boolean = false;
			this._button.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
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
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertFalse("This isSelected property was not changed", beforeIsSelected === this._button.isSelected);
		}

		[Test]
		public function testTouchMoveOutsideBeforeChangeEvent():void
		{
			var beforeIsSelected:Boolean = this._button.isSelected;
			var hasChanged:Boolean = false;
			this._button.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			var position:Point = new Point(10, 10);
			var target:DisplayObject = this._button.stage.hitTest(position, true);
			var touch:Touch = new Touch(0);
			touch.target = target;
			touch.phase = TouchPhase.BEGAN;
			touch.globalX = position.x;
			touch.globalY = position.x;
			var touches:Vector.<Touch> = new <Touch>[touch];
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			touch.globalX = 1000; //move the touch way outside the bounds of the button
			touch.phase = TouchPhase.MOVED;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			touch.phase = TouchPhase.ENDED;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			Assert.assertFalse("Event.CHANGE was incorrectly dispatched", hasChanged);
			Assert.assertStrictlyEquals("The isSelected property was incorrectly changed",
				beforeIsSelected, this._button.isSelected);
		}
	}
}
