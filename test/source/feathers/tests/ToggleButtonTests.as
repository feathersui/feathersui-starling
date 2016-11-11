package feathers.tests
{
	import feathers.controls.ButtonState;
	import feathers.controls.ToggleButton;
	import feathers.core.ToggleGroup;
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
		private var _blocker:Quad;

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

			if(this._blocker)
			{
				this._blocker.removeFromParent(true);
				this._blocker = null;
			}

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
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertFalse("This isSelected property was not changed", beforeIsSelected === this._button.isSelected);
		}

		[Test]
		public function testRemoveBeforeInteractiveChangeEvent():void
		{
			var beforeIsSelected:Boolean = this._button.isSelected;
			var hasChanged:Boolean = false;
			this._button.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
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
			this._button.removeFromParent(false);
			Assert.assertFalse("Event.CHANGE most not be dispatched after removed from stage", hasChanged);
			Assert.assertTrue("This isSelected property must not be changed after removed from stage", beforeIsSelected === this._button.isSelected);
		}

		[Test]
		public function testSetIsToggleToFalse():void
		{
			this._button.isToggle = false;
			this._button.validate();
			var beforeIsSelected:Boolean = this._button.isSelected;
			var hasChanged:Boolean = false;
			this._button.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
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
			Assert.assertFalse("Event.CHANGE was incorrectly dispatched", hasChanged);
			Assert.assertTrue("This isSelected property was incorrectly changed", beforeIsSelected === this._button.isSelected);
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
			var target:DisplayObject = this._button.stage.hitTest(position);
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
		public function testOtherDisplayObjectBlockingChangeEvent():void
		{
			var beforeIsSelected:Boolean = this._button.isSelected;
			var hasChanged:Boolean = false;
			this._button.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
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
			var defaultSelectedSkin:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.defaultSelectedSkin = defaultSelectedSkin;
			var selectedUpSkin:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.setSkinForState(ButtonState.UP_AND_SELECTED, selectedUpSkin);
			var selectedDownSkin:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.setSkinForState(ButtonState.DOWN_AND_SELECTED, selectedDownSkin);
			var selectedHoverSkin:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.setSkinForState(ButtonState.HOVER_AND_SELECTED, selectedHoverSkin);
			var selectedDisabledSkin:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.setSkinForState(ButtonState.DISABLED_AND_SELECTED, selectedDisabledSkin);
			this._button.validate();
			this._button.defaultSkin = null;
			this._button.setSkinForState(ButtonState.UP, null);
			this._button.setSkinForState(ButtonState.DOWN, null);
			this._button.setSkinForState(ButtonState.HOVER, null);
			this._button.setSkinForState(ButtonState.DISABLED, null);
			this._button.defaultSelectedSkin = null;
			this._button.setSkinForState(ButtonState.UP_AND_SELECTED, null);
			this._button.setSkinForState(ButtonState.DOWN_AND_SELECTED, null);
			this._button.setSkinForState(ButtonState.HOVER_AND_SELECTED, null);
			this._button.setSkinForState(ButtonState.DISABLED_AND_SELECTED, null);
			//should not need to validate here
			this._button.dispose();
			Assert.assertFalse("Removed defaultSkin incorrectly disposed when ToggleButton disposed.", defaultSkin.isDisposed);
			Assert.assertFalse("Removed upSkin incorrectly disposed when ToggleButton disposed.", upSkin.isDisposed);
			Assert.assertFalse("Removed downSkin incorrectly disposed when ToggleButton disposed.", downSkin.isDisposed);
			Assert.assertFalse("Removed hoverSkin incorrectly disposed when ToggleButton disposed.", hoverSkin.isDisposed);
			Assert.assertFalse("Removed disabledSkin incorrectly disposed when ToggleButton disposed.", disabledSkin.isDisposed);
			Assert.assertFalse("Removed defaultSelectedSkin incorrectly disposed when ToggleButton disposed.", defaultSelectedSkin.isDisposed);
			Assert.assertFalse("Removed selectedUpSkin incorrectly disposed when ToggleButton disposed.", selectedUpSkin.isDisposed);
			Assert.assertFalse("Removed selectedDownSkin incorrectly disposed when ToggleButton disposed.", selectedDownSkin.isDisposed);
			Assert.assertFalse("Removed selectedHoverSkin incorrectly disposed when ToggleButton disposed.", selectedHoverSkin.isDisposed);
			Assert.assertFalse("Removed selectedDisabledSkin incorrectly disposed when ToggleButton disposed.", selectedDisabledSkin.isDisposed);
			Assert.assertNull("defaultSkin parent must be null when removed from ToggleButton.", defaultSkin.parent);
			Assert.assertNull("upSkin parent must be null when removed from ToggleButton.", upSkin.parent);
			Assert.assertNull("downSkin parent must be null when removed from ToggleButton.", downSkin.parent);
			Assert.assertNull("hoverSkin parent must be null when removed from ToggleButton.", hoverSkin.parent);
			Assert.assertNull("disabledSkin parent must be null when removed from ToggleButton.", disabledSkin.parent);
			Assert.assertNull("defaultSelectedSkin parent must be null when removed from ToggleButton.", defaultSelectedSkin.parent);
			Assert.assertNull("selectedUpSkin parent must be null when removed from ToggleButton.", selectedUpSkin.parent);
			Assert.assertNull("selectedDownSkin parent must be null when removed from ToggleButton.", selectedDownSkin.parent);
			Assert.assertNull("selectedHoverSkin parent must be null when removed from ToggleButton.", selectedHoverSkin.parent);
			Assert.assertNull("selectedDisabledSkin parent must be null when removed from ToggleButton.", selectedDisabledSkin.parent);
			defaultSkin.dispose();
			upSkin.dispose();
			downSkin.dispose();
			hoverSkin.dispose();
			disabledSkin.dispose();
			defaultSelectedSkin.dispose();
			selectedUpSkin.dispose();
			selectedDownSkin.dispose();
			selectedHoverSkin.dispose();
			selectedDisabledSkin.dispose();
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
			var defaultSelectedIcon:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.defaultSelectedIcon = defaultSelectedIcon;
			var selectedUpIcon:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.setIconForState(ButtonState.UP_AND_SELECTED, selectedUpIcon);
			var selectedDownIcon:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.setIconForState(ButtonState.DOWN_AND_SELECTED, selectedDownIcon);
			var selectedHoverIcon:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.setIconForState(ButtonState.HOVER_AND_SELECTED, selectedHoverIcon);
			var selectedDisabledIcon:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.setIconForState(ButtonState.DISABLED_AND_SELECTED, selectedDisabledIcon);
			this._button.validate();
			this._button.defaultIcon = null;
			this._button.setIconForState(ButtonState.UP, null);
			this._button.setIconForState(ButtonState.DOWN, null);
			this._button.setIconForState(ButtonState.HOVER, null);
			this._button.setIconForState(ButtonState.DISABLED, null);
			this._button.defaultSelectedIcon = null;
			this._button.setIconForState(ButtonState.UP_AND_SELECTED, null);
			this._button.setIconForState(ButtonState.DOWN_AND_SELECTED, null);
			this._button.setIconForState(ButtonState.HOVER_AND_SELECTED, null);
			this._button.setIconForState(ButtonState.DISABLED_AND_SELECTED, null);
			//should not need to validate here
			this._button.dispose();
			Assert.assertFalse("Removed defaultIcon incorrectly disposed when ToggleButton disposed.", defaultIcon.isDisposed);
			Assert.assertFalse("Removed upIcon incorrectly disposed when ToggleButton disposed.", upIcon.isDisposed);
			Assert.assertFalse("Removed downIcon incorrectly disposed when ToggleButton disposed.", downIcon.isDisposed);
			Assert.assertFalse("Removed hoverIcon incorrectly disposed when ToggleButton disposed.", hoverIcon.isDisposed);
			Assert.assertFalse("Removed disabledIcon incorrectly disposed when ToggleButton disposed.", disabledIcon.isDisposed);
			Assert.assertFalse("Removed defaultSelectedIcon incorrectly disposed when ToggleButton disposed.", defaultSelectedIcon.isDisposed);
			Assert.assertFalse("Removed selectedUpIcon incorrectly disposed when ToggleButton disposed.", selectedUpIcon.isDisposed);
			Assert.assertFalse("Removed selectedDownIcon incorrectly disposed when ToggleButton disposed.", selectedDownIcon.isDisposed);
			Assert.assertFalse("Removed selectedHoverIcon incorrectly disposed when ToggleButton disposed.", selectedHoverIcon.isDisposed);
			Assert.assertFalse("Removed selectedDisabledIcon incorrectly disposed when ToggleButton disposed.", selectedDisabledIcon.isDisposed);
			Assert.assertNull("defaultIcon parent must be null when removed from ToggleButton.", defaultIcon.parent);
			Assert.assertNull("upIcon parent must be null when removed from ToggleButton.", upIcon.parent);
			Assert.assertNull("downIcon parent must be null when removed from ToggleButton.", downIcon.parent);
			Assert.assertNull("hoverIcon parent must be null when removed from ToggleButton.", hoverIcon.parent);
			Assert.assertNull("disabledIcon parent must be null when removed from ToggleButton.", disabledIcon.parent);
			Assert.assertNull("defaultSelectedIcon parent must be null when removed from ToggleButton.", defaultSelectedIcon.parent);
			Assert.assertNull("selectedUpIcon parent must be null when removed from ToggleButton.", selectedUpIcon.parent);
			Assert.assertNull("selectedDownIcon parent must be null when removed from ToggleButton.", selectedDownIcon.parent);
			Assert.assertNull("selectedHoverIcon parent must be null when removed from ToggleButton.", selectedHoverIcon.parent);
			Assert.assertNull("selectedDisabledIcon parent must be null when removed from ToggleButton.", selectedDisabledIcon.parent);
			defaultIcon.dispose();
			upIcon.dispose();
			downIcon.dispose();
			hoverIcon.dispose();
			disabledIcon.dispose();
			defaultSelectedIcon.dispose();
			selectedUpIcon.dispose();
			selectedDownIcon.dispose();
			selectedHoverIcon.dispose();
			selectedDisabledIcon.dispose();
		}

		[Test]
		public function testToggleGroupPropertyAfterAddingExternally():void
		{
			var group:ToggleGroup = new ToggleGroup();
			group.addItem(this._button);
			Assert.assertNotNull("toggleGroup property must not be null after adding a ToggleButton to a ToggleGroup.", this._button.toggleGroup);
		}

		[Test]
		public function testToggleGroupPropertyAfterRemovingExternally():void
		{
			var group:ToggleGroup = new ToggleGroup();
			group.addItem(this._button);
			group.removeItem(this._button);
			Assert.assertNull("toggleGroup property must be null after removing a ToggleButton to a ToggleGroup.", this._button.toggleGroup);
		}

		[Test]
		public function testButtonStateHoverOnTouchPhaseHover():void
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
			Assert.assertStrictlyEquals("ToggleButton currentState was not changed to ButtonState.HOVER_AND_SELECTED on TouchPhase.HOVER", ButtonState.HOVER_AND_SELECTED, this._button.currentState);
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
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, new <Touch>[]));
			Assert.assertStrictlyEquals("ToggleButton currentState was not changed to ButtonState.UP_AND_SELECTED when TouchPhase.HOVER ends", ButtonState.UP_AND_SELECTED, this._button.currentState);
		}

		[Test]
		public function testButtonStateDownOnTouchPhaseBegan():void
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
			Assert.assertStrictlyEquals("ToggleButton currentState was not changed to ButtonState.DOWN_AND_SELECTED on TouchPhase.BEGAN", ButtonState.DOWN_AND_SELECTED, this._button.currentState);
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
			touch.phase = TouchPhase.MOVED;
			touch.globalX = 1000;
			touch.globalY = position.y;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			Assert.assertStrictlyEquals("ToggleButton currentState was not changed to ButtonState.UP_AND_SELECTED on TouchPhase.MOVED when position is outside button", ButtonState.UP_AND_SELECTED, this._button.currentState);
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
			touch.globalX = 10;
			touch.globalY = position.y;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			Assert.assertStrictlyEquals("ToggleButton currentState was not changed to ButtonState.DOWN_AND_SELECTED on TouchPhase.MOVED when position moves outside button then back inside", ButtonState.DOWN_AND_SELECTED, this._button.currentState);
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
			touch.phase = TouchPhase.MOVED;
			touch.globalX = 1000;
			touch.globalY = position.y;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			Assert.assertStrictlyEquals("ToggleButton currentState was incorrectly changed from ButtonState.DOWN_AND_SELECTED on TouchPhase.MOVED when position is outside button and keepDownStateOnRollOut is true", ButtonState.DOWN_AND_SELECTED, this._button.currentState);
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
			touch.phase = TouchPhase.ENDED;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			Assert.assertStrictlyEquals("ToggleButton currentState was not changed to ButtonState.UP on TouchPhase.ENDED (which toggles isSelected)", ButtonState.UP, this._button.currentState);
		}
	}
}
