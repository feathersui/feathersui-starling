package feathers.tests
{
	import feathers.controls.ToggleButton;

	import org.flexunit.Assert;

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
		public function testChangeEvent():void
		{
			var beforeIsSelected:Boolean = this._button.isSelected;
			var hasChanged:Boolean = false;
			this._button.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
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
			Assert.assertTrue(hasChanged);
			Assert.assertFalse(beforeIsSelected === this._button.isSelected);
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
			Assert.assertFalse(hasChanged);
			Assert.assertTrue(beforeIsSelected === this._button.isSelected);
		}
	}
}
