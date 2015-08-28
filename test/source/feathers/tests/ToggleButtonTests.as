package feathers.tests
{
	import feathers.controls.ToggleButton;
	import feathers.tests.supportClasses.DisposeFlagQuad;

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

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
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
			var defaultSelectedSkin:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.defaultSelectedSkin = defaultSelectedSkin;
			var selectedUpSkin:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.selectedUpSkin = selectedUpSkin;
			var selectedDownSkin:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.selectedDownSkin = selectedDownSkin;
			var selectedHoverSkin:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.selectedHoverSkin = selectedHoverSkin;
			var selectedDisabledSkin:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.selectedDisabledSkin = selectedDisabledSkin;
			this._button.validate();
			this._button.dispose();
			Assert.assertTrue("defaultSkin not disposed when ToggleButton disposed.", defaultSkin.isDisposed);
			Assert.assertTrue("upSkin not disposed when ToggleButton disposed.", upSkin.isDisposed);
			Assert.assertTrue("downSkin not disposed when ToggleButton disposed.", downSkin.isDisposed);
			Assert.assertTrue("hoverSkin not disposed when ToggleButton disposed.", hoverSkin.isDisposed);
			Assert.assertTrue("disabledSkin not disposed when ToggleButton disposed.", disabledSkin.isDisposed);
			Assert.assertTrue("defaultSelectedSkin not disposed when ToggleButton disposed.", defaultSelectedSkin.isDisposed);
			Assert.assertTrue("selectedUpSkin not disposed when ToggleButton disposed.", selectedUpSkin.isDisposed);
			Assert.assertTrue("selectedDownSkin not disposed when ToggleButton disposed.", selectedDownSkin.isDisposed);
			Assert.assertTrue("selectedHoverSkin not disposed when ToggleButton disposed.", selectedHoverSkin.isDisposed);
			Assert.assertTrue("selectedDisabledSkin not disposed when ToggleButton disposed.", selectedDisabledSkin.isDisposed);
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
			var defaultSelectedIcon:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.defaultSelectedIcon = defaultSelectedIcon;
			var selectedUpIcon:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.selectedUpIcon = selectedUpIcon;
			var selectedDownIcon:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.selectedDownIcon = selectedDownIcon;
			var selectedHoverIcon:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.selectedHoverIcon = selectedHoverIcon;
			var selectedDisabledIcon:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.selectedDisabledIcon = selectedDisabledIcon;
			this._button.validate();
			this._button.dispose();
			Assert.assertTrue("defaultIcon not disposed when ToggleButton disposed.", defaultIcon.isDisposed);
			Assert.assertTrue("upIcon not disposed when ToggleButton disposed.", upIcon.isDisposed);
			Assert.assertTrue("downIcon not disposed when ToggleButton disposed.", downIcon.isDisposed);
			Assert.assertTrue("hoverIcon not disposed when ToggleButton disposed.", hoverIcon.isDisposed);
			Assert.assertTrue("disabledIcon not disposed when ToggleButton disposed.", disabledIcon.isDisposed);
			Assert.assertTrue("defaultSelectedIcon not disposed when ToggleButton disposed.", defaultSelectedIcon.isDisposed);
			Assert.assertTrue("selectedUpIcon not disposed when ToggleButton disposed.", selectedUpIcon.isDisposed);
			Assert.assertTrue("selectedDownIcon not disposed when ToggleButton disposed.", selectedDownIcon.isDisposed);
			Assert.assertTrue("selectedHoverIcon not disposed when ToggleButton disposed.", selectedHoverIcon.isDisposed);
			Assert.assertTrue("selectedDisabledIcon not disposed when ToggleButton disposed.", selectedDisabledIcon.isDisposed);
		}
	}
}
