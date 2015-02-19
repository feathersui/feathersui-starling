package feathers.tests
{
	import feathers.controls.Button;
	import feathers.controls.Slider;
	import feathers.controls.ToggleSwitch;

	import flash.geom.Point;

	import org.flexunit.Assert;

	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class ToggleSwitchTests
	{
		private static const THUMB_NAME:String = "thumb";
		private static const TRACK_NAME:String = "track";
		private static const TRACK_WIDTH:Number = 50;
		private static const TRACK_HEIGHT:Number = 20;
		private static const THUMB_WIDTH:Number = 20;
		private static const THUMB_HEIGHT:Number = 20;

		private var _toggle:ToggleSwitch;

		[Before]
		public function prepare():void
		{
			this._toggle = new ToggleSwitch();
			this._toggle.trackLayoutMode = Slider.TRACK_LAYOUT_MODE_SINGLE;
			this._toggle.onTrackFactory = function():Button
			{
				var track:Button = new Button();
				track.name = TRACK_NAME;
				track.defaultSkin = new Quad(TRACK_WIDTH, TRACK_HEIGHT);
				return track;
			};
			this._toggle.thumbFactory = function():Button
			{
				var thumb:Button = new Button();
				thumb.name = THUMB_NAME;
				thumb.defaultSkin = new Quad(THUMB_WIDTH, THUMB_HEIGHT, 0xff0000);
				return thumb;
			};
			TestFeathers.starlingRoot.addChild(this._toggle);
			this._toggle.validate();
		}

		[After]
		public function cleanup():void
		{
			this._toggle.removeFromParent(true);
			this._toggle = null;
		}

		[Test]
		public function testSingleTrackAutoSize():void
		{
			Assert.assertStrictlyEquals("The width of the toggle switch was not calculated correctly.",
				TRACK_WIDTH, this._toggle.width);
			Assert.assertStrictlyEquals("The height of the toggle switch was not calculated correctly.",
				TRACK_HEIGHT, this._toggle.height);
		}

		[Test]
		public function testProgrammaticSelectionChange():void
		{
			this._toggle.isSelected = false;
			var hasChanged:Boolean = false;
			this._toggle.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._toggle.isSelected = true;
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
		}

		[Test]
		public function testInteractiveSelectionChangeWithDraggingThumb():void
		{
			var oldSelected:Boolean = false;
			this._toggle.isSelected = oldSelected;
			//validate to position the thumb correctly.
			this._toggle.validate();
			var hasChanged:Boolean = false;
			this._toggle.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			var position:Point = new Point(THUMB_WIDTH / 2, THUMB_HEIGHT / 2);
			var target:DisplayObject = this._toggle.stage.hitTest(position, true);

			Assert.assertStrictlyEquals("The hit test did not return the toggle switch's thumb",
				this._toggle.getChildByName(THUMB_NAME).name, target.name);

			var touch:Touch = new Touch(0);
			touch.target = target;
			touch.phase = TouchPhase.BEGAN;
			touch.globalX = position.x;
			touch.globalY = position.y;
			var touches:Vector.<Touch> = new <Touch>[touch];
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			touch.phase = TouchPhase.MOVED;
			touch.globalX = TRACK_WIDTH - THUMB_WIDTH / 2;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			touch.phase = TouchPhase.ENDED;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));

			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertFalse("The isSelected property was not changed",
				oldSelected === this._toggle.isSelected);
		}

		[Test]
		public function testInteractiveSelectionChangeWithTapThumb():void
		{
			var oldSelected:Boolean = false;
			this._toggle.isSelected = oldSelected;
			//validate to position the thumb correctly.
			this._toggle.validate();
			var hasChanged:Boolean = false;
			this._toggle.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			var position:Point = new Point(THUMB_WIDTH / 2, THUMB_HEIGHT / 2);
			var target:DisplayObject = this._toggle.stage.hitTest(position, true);

			Assert.assertStrictlyEquals("The hit test did not return the toggle switch's thumb",
				this._toggle.getChildByName(THUMB_NAME).name, target.name);

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
			Assert.assertFalse("The isSelected property was not changed",
				oldSelected === this._toggle.isSelected);
		}

		[Test]
		public function testInteractiveSelectionChangeWithTapTrack():void
		{
			var oldSelected:Boolean = false;
			this._toggle.isSelected = oldSelected;
			//validate to position the thumb correctly.
			this._toggle.validate();
			var hasChanged:Boolean = false;
			this._toggle.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			var position:Point = new Point(TRACK_WIDTH - THUMB_WIDTH / 2, THUMB_HEIGHT / 2);
			var target:DisplayObject = this._toggle.stage.hitTest(position, true);

			//we don't care what is hit as long as its not the thumb
			Assert.assertTrue("The hit test did not return a display object contained by the toggle switch",
				this._toggle.contains(target));
			Assert.assertFalse("The hit test incorrectly returned the toggle switch's thumb",
				this._toggle.getChildByName(THUMB_NAME).name === target.name);

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
			Assert.assertFalse("The isSelected property was not changed",
				oldSelected === this._toggle.isSelected);
		}
	}
}
