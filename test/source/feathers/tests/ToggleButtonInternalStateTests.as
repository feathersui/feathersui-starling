package feathers.tests
{
	import feathers.controls.ButtonState;

	import flash.geom.Point;

	import org.flexunit.Assert;

	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class ToggleButtonInternalStateTests
	{
		private var _button:ToggleButtonWithInternalState;

		[Before]
		public function prepare():void
		{
			this._button = new ToggleButtonWithInternalState();
			TestFeathers.starlingRoot.addChild(this._button);
		}

		[After]
		public function cleanup():void
		{
			this._button.removeFromParent(true);
			this._button = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testGetSkinForStateWithoutSetSkinForState():void
		{
			Assert.assertNull("ToggleButton getSkinForState(ButtonState.UP) must be null when setSkinForState() is not called", this._button.getSkinForState(ButtonState.UP));
			Assert.assertNull("ToggleButton getSkinForState(ButtonState.HOVER) must be null when setSkinForState() is not called", this._button.getSkinForState(ButtonState.HOVER));
			Assert.assertNull("ToggleButton getSkinForState(ButtonState.DOWN) must be null when setSkinForState() is not called", this._button.getSkinForState(ButtonState.DOWN));
			Assert.assertNull("ToggleButton getSkinForState(ButtonState.DISABLED) must be null when setSkinForState() is not called", this._button.getSkinForState(ButtonState.DISABLED));
			Assert.assertNull("ToggleButton getSkinForState(ButtonState.UP_AND_SELECTED) must be null when setSkinForState() is not called", this._button.getSkinForState(ButtonState.UP_AND_SELECTED));
			Assert.assertNull("ToggleButton getSkinForState(ButtonState.HOVER_AND_SELECTED) must be null when setSkinForState() is not called", this._button.getSkinForState(ButtonState.HOVER_AND_SELECTED));
			Assert.assertNull("ToggleButton getSkinForState(ButtonState.DOWN_AND_SELECTED) must be null when setSkinForState() is not called", this._button.getSkinForState(ButtonState.DOWN_AND_SELECTED));
			Assert.assertNull("ToggleButton getSkinForState(ButtonState.DISABLED_AND_SELECTED) must be null when setSkinForState() is not called", this._button.getSkinForState(ButtonState.DISABLED_AND_SELECTED));
		}

		[Test]
		public function testGetSkinForState():void
		{
			var defaultSkin:Quad = new Quad(200, 200);
			this._button.defaultSkin = defaultSkin;

			var upSkin:Quad = new Quad(200, 200);
			this._button.setSkinForState(ButtonState.UP, upSkin);

			var hoverSkin:Quad = new Quad(200, 200);
			this._button.setSkinForState(ButtonState.HOVER, hoverSkin);

			var downSkin:Quad = new Quad(200, 200);
			this._button.setSkinForState(ButtonState.DOWN, downSkin);

			var disabledSkin:Quad = new Quad(200, 200);
			this._button.setSkinForState(ButtonState.DISABLED, disabledSkin);

			var defaultSelectedSkin:Quad = new Quad(200, 200);
			this._button.defaultSkin = defaultSelectedSkin;

			var selectedUpSkin:Quad = new Quad(200, 200);
			this._button.setSkinForState(ButtonState.UP_AND_SELECTED, selectedUpSkin);

			var selectedHoverSkin:Quad = new Quad(200, 200);
			this._button.setSkinForState(ButtonState.HOVER_AND_SELECTED, selectedHoverSkin);

			var selectedDownSkin:Quad = new Quad(200, 200);
			this._button.setSkinForState(ButtonState.DOWN_AND_SELECTED, selectedDownSkin);

			var selectedDisabledSkin:Quad = new Quad(200, 200);
			this._button.setSkinForState(ButtonState.DISABLED_AND_SELECTED, selectedDisabledSkin);

			Assert.assertStrictlyEquals("ToggleButton getSkinForState(ButtonState.UP) does not match value passed to setSkinForState()", upSkin, this._button.getSkinForState(ButtonState.UP));
			Assert.assertStrictlyEquals("ToggleButton getSkinForState(ButtonState.HOVER) does not match value passed to setSkinForState()", hoverSkin, this._button.getSkinForState(ButtonState.HOVER));
			Assert.assertStrictlyEquals("ToggleButton getSkinForState(ButtonState.DOWN) does not match value passed to setSkinForState()", downSkin, this._button.getSkinForState(ButtonState.DOWN));
			Assert.assertStrictlyEquals("ToggleButton getSkinForState(ButtonState.DISABLED) does not match value passed to setSkinForState()", disabledSkin, this._button.getSkinForState(ButtonState.DISABLED));
			Assert.assertStrictlyEquals("ToggleButton getSkinForState(ButtonState.UP_AND_SELECTED) does not match value passed to setSkinForState()", selectedUpSkin, this._button.getSkinForState(ButtonState.UP_AND_SELECTED));
			Assert.assertStrictlyEquals("ToggleButton getSkinForState(ButtonState.HOVER_AND_SELECTED) does not match value passed to setSkinForState()", selectedHoverSkin, this._button.getSkinForState(ButtonState.HOVER_AND_SELECTED));
			Assert.assertStrictlyEquals("ToggleButton getSkinForState(ButtonState.DOWN_AND_SELECTED) does not match value passed to setSkinForState()", selectedDownSkin, this._button.getSkinForState(ButtonState.DOWN_AND_SELECTED));
			Assert.assertStrictlyEquals("ToggleButton getSkinForState(ButtonState.DISABLED_AND_SELECTED) does not match value passed to setSkinForState()", selectedDisabledSkin, this._button.getSkinForState(ButtonState.DISABLED_AND_SELECTED));
		}

		[Test]
		public function testDefaultCurrentSkin():void
		{
			this._button.isSelected = true;

			var defaultSelectedSkin:Quad = new Quad(200, 200);
			this._button.defaultSelectedSkin = defaultSelectedSkin;

			this._button.validate();
			Assert.assertStrictlyEquals("ToggleButton state is not ButtonState.UP_AND_SELECTED with no touch and isSelected is true", ButtonState.UP_AND_SELECTED, this._button.currentState);
			Assert.assertStrictlyEquals("ToggleButton skin is not defaultSkin when currentState is ButtonState.UP_AND_SELECTED and skin not provided for this state", defaultSelectedSkin, this._button.currentSkinInternal);

			this._button.isEnabled = false;
			this._button.validate();
			Assert.assertStrictlyEquals("ToggleButton state is not ButtonState.DISABLED_AND_SELECTED when isEnabled is false and isSelected is true", ButtonState.DISABLED_AND_SELECTED, this._button.currentState);
			Assert.assertStrictlyEquals("ToggleButton skin is not defaultSkin when currentState is ButtonState.DISABLED_AND_SELECTED and skin not provided for this state", defaultSelectedSkin, this._button.currentSkinInternal);

			this._button.isEnabled = true;

			var position:Point = new Point(10, 10);
			var target:DisplayObject = this._button.stage.hitTest(position);
			Assert.assertStrictlyEquals("Touch target must be button", this._button, target);
			var touch:Touch = new Touch(0);
			touch.target = target;
			touch.phase = TouchPhase.HOVER;
			touch.globalX = position.x;
			touch.globalY = position.y;
			var touches:Vector.<Touch> = new <Touch>[touch];
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			this._button.validate();
			Assert.assertStrictlyEquals("ToggleButton state is not ButtonState.HOVER_AND_SELECTED on TouchPhase.HOVER and isSelected is true", ButtonState.HOVER_AND_SELECTED, this._button.currentState);
			Assert.assertStrictlyEquals("ToggleButton skin is not defaultSkin when currentState is ButtonState.HOVER and skin not provided for this state", defaultSelectedSkin, this._button.currentSkinInternal);

			touch.phase = TouchPhase.BEGAN;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			this._button.validate();
			Assert.assertStrictlyEquals("ToggleButton state is not ButtonState.DOWN_AND_SELECTED on TouchPhase.BEGAN and isSelected is true", ButtonState.DOWN_AND_SELECTED, this._button.currentState);
			Assert.assertStrictlyEquals("ToggleButton skin is not defaultSkin when currentState is ButtonState.DOWN and skin not provided for this state", defaultSelectedSkin, this._button.currentSkinInternal);
		}

		[Test]
		public function testCurrentSkinWithSetSkinForState():void
		{
			this._button.isSelected = true;

			var defaultSelectedSkin:Quad = new Quad(200, 200);
			this._button.defaultSkin = defaultSelectedSkin;

			var selectedUpSkin:Quad = new Quad(200, 200);
			this._button.setSkinForState(ButtonState.UP_AND_SELECTED, selectedUpSkin);

			var selectedHoverSkin:Quad = new Quad(200, 200);
			this._button.setSkinForState(ButtonState.HOVER_AND_SELECTED, selectedHoverSkin);

			var selectedDownSkin:Quad = new Quad(200, 200);
			this._button.setSkinForState(ButtonState.DOWN_AND_SELECTED, selectedDownSkin);

			var selectedDisabledSkin:Quad = new Quad(200, 200);
			this._button.setSkinForState(ButtonState.DISABLED_AND_SELECTED, selectedDisabledSkin);

			this._button.validate();
			Assert.assertStrictlyEquals("ToggleButton state is not ButtonState.UP_AND_SELECTED with no touch and isSelected is true", ButtonState.UP_AND_SELECTED, this._button.currentState);
			Assert.assertStrictlyEquals("ToggleButton skin does not match skin set with setSkinForState() when currentState is ButtonState.UP_AND_SELECTED", selectedUpSkin, this._button.currentSkinInternal);

			this._button.isEnabled = false;
			this._button.validate();
			Assert.assertStrictlyEquals("ToggleButton state is not ButtonState.DISABLED_AND_SELECTED when isEnabled is false and isSelected is true", ButtonState.DISABLED_AND_SELECTED, this._button.currentState);
			Assert.assertStrictlyEquals("ToggleButton skin does not match skin set with setSkinForState() when currentState is ButtonState.DISABLED_AND_SELECTED", selectedDisabledSkin, this._button.currentSkinInternal);

			this._button.isEnabled = true;

			var position:Point = new Point(10, 10);
			var target:DisplayObject = this._button.stage.hitTest(position);
			Assert.assertStrictlyEquals("Touch target must be button", this._button, target);
			var touch:Touch = new Touch(0);
			touch.target = target;
			touch.phase = TouchPhase.HOVER;
			touch.globalX = position.x;
			touch.globalY = position.y;
			var touches:Vector.<Touch> = new <Touch>[touch];
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			this._button.validate();
			Assert.assertStrictlyEquals("ToggleButton state is not ButtonState.HOVER_AND_SELECTED on TouchPhase.HOVER and isSelected is true", ButtonState.HOVER_AND_SELECTED, this._button.currentState);
			Assert.assertStrictlyEquals("ToggleButton skin does not match skin set with setSkinForState() when currentState is ButtonState.HOVER_AND_SELECTED and skin not provided for this state", selectedHoverSkin, this._button.currentSkinInternal);

			touch.phase = TouchPhase.BEGAN;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			this._button.validate();
			Assert.assertStrictlyEquals("ToggleButton state is not ButtonState.DOWN_AND_SELECTED on TouchPhase.BEGAN and isSelected is true", ButtonState.DOWN_AND_SELECTED, this._button.currentState);
			Assert.assertStrictlyEquals("ToggleButton skin does not match skin set with setSkinForState() when currentState is ButtonState.DOWN_AND_SELECTED and skin not provided for this state", selectedDownSkin, this._button.currentSkinInternal);
		}

		[Test]
		public function testGetIconForStateWithoutSetIconForState():void
		{
			Assert.assertNull("ToggleButton getIconForState(ButtonState.UP) must be null when setIconForState() is not called", this._button.getIconForState(ButtonState.UP));
			Assert.assertNull("ToggleButton getIconForState(ButtonState.HOVER) must be null when setIconForState() is not called", this._button.getIconForState(ButtonState.HOVER));
			Assert.assertNull("ToggleButton getIconForState(ButtonState.DOWN) must be null when setIconForState() is not called", this._button.getIconForState(ButtonState.DOWN));
			Assert.assertNull("ToggleButton getIconForState(ButtonState.DISABLED) must be null when setIconForState() is not called", this._button.getIconForState(ButtonState.DISABLED));
			Assert.assertNull("ToggleButton getIconForState(ButtonState.UP_AND_SELECTED) must be null when setIconForState() is not called", this._button.getIconForState(ButtonState.UP_AND_SELECTED));
			Assert.assertNull("ToggleButton getIconForState(ButtonState.HOVER_AND_SELECTED) must be null when setIconForState() is not called", this._button.getIconForState(ButtonState.HOVER_AND_SELECTED));
			Assert.assertNull("ToggleButton getIconForState(ButtonState.DOWN_AND_SELECTED) must be null when setIconForState() is not called", this._button.getIconForState(ButtonState.DOWN_AND_SELECTED));
			Assert.assertNull("ToggleButton getIconForState(ButtonState.DISABLED_AND_SELECTED) must be null when setIconForState() is not called", this._button.getIconForState(ButtonState.DISABLED_AND_SELECTED));
		}

		[Test]
		public function testGetIconForState():void
		{
			var defaultIcon:Quad = new Quad(200, 200);
			this._button.defaultIcon = defaultIcon;

			var upIcon:Quad = new Quad(200, 200);
			this._button.setIconForState(ButtonState.UP, upIcon);

			var hoverIcon:Quad = new Quad(200, 200);
			this._button.setIconForState(ButtonState.HOVER, hoverIcon);

			var downIcon:Quad = new Quad(200, 200);
			this._button.setIconForState(ButtonState.DOWN, downIcon);

			var disabledIcon:Quad = new Quad(200, 200);
			this._button.setIconForState(ButtonState.DISABLED, disabledIcon);

			var defaultSelectedIcon:Quad = new Quad(200, 200);
			this._button.defaultSelectedIcon = defaultSelectedIcon;

			var selectedUpIcon:Quad = new Quad(200, 200);
			this._button.setIconForState(ButtonState.UP_AND_SELECTED, selectedUpIcon);

			var selectedHoverIcon:Quad = new Quad(200, 200);
			this._button.setIconForState(ButtonState.HOVER_AND_SELECTED, selectedHoverIcon);

			var selectedDownIcon:Quad = new Quad(200, 200);
			this._button.setIconForState(ButtonState.DOWN_AND_SELECTED, selectedDownIcon);

			var selectedDisabledIcon:Quad = new Quad(200, 200);
			this._button.setIconForState(ButtonState.DISABLED_AND_SELECTED, selectedDisabledIcon);

			Assert.assertStrictlyEquals("ToggleButton getIconForState(ButtonState.UP) does not match value passed to setIconForState()", upIcon, this._button.getIconForState(ButtonState.UP));
			Assert.assertStrictlyEquals("ToggleButton getIconForState(ButtonState.HOVER) does not match value passed to setIconForState()", hoverIcon, this._button.getIconForState(ButtonState.HOVER));
			Assert.assertStrictlyEquals("ToggleButton getIconForState(ButtonState.DOWN) does not match value passed to setIconForState()", downIcon, this._button.getIconForState(ButtonState.DOWN));
			Assert.assertStrictlyEquals("ToggleButton getIconForState(ButtonState.DISABLED) does not match value passed to setIconForState()", disabledIcon, this._button.getIconForState(ButtonState.DISABLED));
			Assert.assertStrictlyEquals("ToggleButton getIconForState(ButtonState.UP_AND_SELECTED) does not match value passed to setIconForState()", selectedUpIcon, this._button.getIconForState(ButtonState.UP_AND_SELECTED));
			Assert.assertStrictlyEquals("ToggleButton getIconForState(ButtonState.HOVER_AND_SELECTED) does not match value passed to setIconForState()", selectedHoverIcon, this._button.getIconForState(ButtonState.HOVER_AND_SELECTED));
			Assert.assertStrictlyEquals("ToggleButton getIconForState(ButtonState.DOWN_AND_SELECTED) does not match value passed to setIconForState()", selectedDownIcon, this._button.getIconForState(ButtonState.DOWN_AND_SELECTED));
			Assert.assertStrictlyEquals("ToggleButton getIconForState(ButtonState.DISABLED_AND_SELECTED) does not match value passed to setIconForState()", selectedDisabledIcon, this._button.getIconForState(ButtonState.DISABLED_AND_SELECTED));
		}

		[Test]
		public function testDefaultCurrentIcon():void
		{
			this._button.isSelected = true;

			var defaultSelectedIcon:Quad = new Quad(200, 200);
			this._button.defaultSelectedIcon = defaultSelectedIcon;

			this._button.validate();
			Assert.assertStrictlyEquals("ToggleButton state is not ButtonState.UP_AND_SELECTED with no touch and isSelected is true", ButtonState.UP_AND_SELECTED, this._button.currentState);
			Assert.assertStrictlyEquals("ToggleButton icon is not defaultSelectedIcon when currentState is ButtonState.UP_AND_SELECTED and icon not provided for this state", defaultSelectedIcon, this._button.currentIconInternal);

			this._button.isEnabled = false;
			this._button.validate();
			Assert.assertStrictlyEquals("ToggleButton state is not ButtonState.DISABLED_AND_SELECTED when isEnabled is false and isSelected is true", ButtonState.DISABLED_AND_SELECTED, this._button.currentState);
			Assert.assertStrictlyEquals("ToggleButton icon is not defaultSelectedIcon when currentState is ButtonState.DISABLED_AND_SELECTED and icon not provided for this state", defaultSelectedIcon, this._button.currentIconInternal);

			this._button.isEnabled = true;

			var position:Point = new Point(10, 10);
			var target:DisplayObject = this._button.stage.hitTest(position);
			Assert.assertStrictlyEquals("Touch target must be button", this._button, target);
			var touch:Touch = new Touch(0);
			touch.target = target;
			touch.phase = TouchPhase.HOVER;
			touch.globalX = position.x;
			touch.globalY = position.y;
			var touches:Vector.<Touch> = new <Touch>[touch];
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			this._button.validate();
			Assert.assertStrictlyEquals("ToggleButton state is not ButtonState.HOVER_AND_SELECTED on TouchPhase.HOVER and isSelected is true", ButtonState.HOVER_AND_SELECTED, this._button.currentState);
			Assert.assertStrictlyEquals("ToggleButton icon is not defaultSelectedIcon when currentState is ButtonState.HOVER and icon not provided for this state", defaultSelectedIcon, this._button.currentIconInternal);

			touch.phase = TouchPhase.BEGAN;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			this._button.validate();
			Assert.assertStrictlyEquals("ToggleButton state is not ButtonState.DOWN_AND_SELECTED on TouchPhase.BEGAN and isSelected is true", ButtonState.DOWN_AND_SELECTED, this._button.currentState);
			Assert.assertStrictlyEquals("ToggleButton icon is not defaultSelectedIcon when currentState is ButtonState.DOWN and icon not provided for this state", defaultSelectedIcon, this._button.currentIconInternal);
		}

		[Test]
		public function testCurrentIconWithSetIconForState():void
		{
			this._button.isSelected = true;
			
			var defaultSelectedIcon:Quad = new Quad(200, 200);
			this._button.defaultSelectedIcon = defaultSelectedIcon;

			var selectedUpIcon:Quad = new Quad(200, 200);
			this._button.setIconForState(ButtonState.UP_AND_SELECTED, selectedUpIcon);

			var selectedHoverIcon:Quad = new Quad(200, 200);
			this._button.setIconForState(ButtonState.HOVER_AND_SELECTED, selectedHoverIcon);

			var selectedDownIcon:Quad = new Quad(200, 200);
			this._button.setIconForState(ButtonState.DOWN_AND_SELECTED, selectedDownIcon);

			var selectedDisabledIcon:Quad = new Quad(200, 200);
			this._button.setIconForState(ButtonState.DISABLED_AND_SELECTED, selectedDisabledIcon);

			this._button.validate();
			Assert.assertStrictlyEquals("ToggleButton state is not ButtonState.UP_AND_SELECTED with no touch and isSelected is true", ButtonState.UP_AND_SELECTED, this._button.currentState);
			Assert.assertStrictlyEquals("ToggleButton icon does not match icon set with setIconForState() when currentState is ButtonState.UP_AND_SELECTED", selectedUpIcon, this._button.currentIconInternal);

			this._button.isEnabled = false;
			this._button.validate();
			Assert.assertStrictlyEquals("ToggleButton state is not ButtonState.DISABLED_AND_SELECTED when isEnabled is false and isSelected is true", ButtonState.DISABLED_AND_SELECTED, this._button.currentState);
			Assert.assertStrictlyEquals("ToggleButton icon does not match icon set with setIconForState() when currentState is ButtonState.DISABLED_AND_SELECTED", selectedDisabledIcon, this._button.currentIconInternal);

			this._button.isEnabled = true;

			var position:Point = new Point(10, 10);
			var target:DisplayObject = this._button.stage.hitTest(position);
			Assert.assertStrictlyEquals("Touch target must be button", this._button, target);
			var touch:Touch = new Touch(0);
			touch.target = target;
			touch.phase = TouchPhase.HOVER;
			touch.globalX = position.x;
			touch.globalY = position.y;
			var touches:Vector.<Touch> = new <Touch>[touch];
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			this._button.validate();
			Assert.assertStrictlyEquals("ToggleButton state is not ButtonState.HOVER_AND_SELECTED on TouchPhase.HOVER and isSelected is true", ButtonState.HOVER_AND_SELECTED, this._button.currentState);
			Assert.assertStrictlyEquals("ToggleButton icon does not match icon set with setIconForState() when currentState is ButtonState.HOVER_AND_SELECTED and icon not provided for this state", selectedHoverIcon, this._button.currentIconInternal);

			touch.phase = TouchPhase.BEGAN;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			this._button.validate();
			Assert.assertStrictlyEquals("ToggleButton state is not ButtonState.DOWN_AND_SELECTED on TouchPhase.BEGAN and isSelected is true", ButtonState.DOWN_AND_SELECTED, this._button.currentState);
			Assert.assertStrictlyEquals("ToggleButton icon does not match icon set with setIconForState() when currentState is ButtonState.DOWN_AND_SELECTED and icon not provided for this state", selectedDownIcon, this._button.currentIconInternal);
		}

		[Test]
		public function testGetScaleForStateWithoutSetSkinForState():void
		{
			Assert.assertStrictlyEquals("ToggleButton scaleWhenSelected must be NaN by default",
				1, this._button.scaleWhenSelected);
			Assert.assertTrue("ToggleButton getScaleForState(ButtonState.UP) must be NaN when setScaleForState() is not called",
				isNaN(this._button.getScaleForState(ButtonState.UP)));
			Assert.assertTrue("ToggleButton getScaleForState(ButtonState.HOVER) must be NaN when setScaleForState() is not called",
				isNaN(this._button.getScaleForState(ButtonState.HOVER)));
			Assert.assertTrue("ToggleButton getScaleForState(ButtonState.DOWN) must be NaN when setScaleForState() is not called",
				isNaN(this._button.getScaleForState(ButtonState.DOWN)));
			Assert.assertTrue("ToggleButton getScaleForState(ButtonState.DISABLED) must be NaN when setScaleForState() is not called",
				isNaN(this._button.getScaleForState(ButtonState.DISABLED)));
			Assert.assertTrue("ToggleButton getScaleForState(ButtonState.UP_AND_SELECTED) must be NaN when setScaleForState() is not called",
				isNaN(this._button.getScaleForState(ButtonState.UP_AND_SELECTED)));
			Assert.assertTrue("ToggleButton getScaleForState(ButtonState.HOVER_AND_SELECTED) must be NaN when setScaleForState() is not called",
				isNaN(this._button.getScaleForState(ButtonState.HOVER_AND_SELECTED)));
			Assert.assertTrue("ToggleButton getScaleForState(ButtonState.DOWN_AND_SELECTED) must be NaN when setScaleForState() is not called",
				isNaN(this._button.getScaleForState(ButtonState.DOWN_AND_SELECTED)));
			Assert.assertTrue("ToggleButton getScaleForState(ButtonState.DISABLED_AND_SELECTED) must be NaN when setScaleForState() is not called",
				isNaN(this._button.getScaleForState(ButtonState.DISABLED_AND_SELECTED)));
		}

		[Test]
		public function testGetScaleForState():void
		{
			var upScale:Number = 1.1;
			this._button.setScaleForState(ButtonState.UP, upScale);

			var hoverScale:Number = 1.2;
			this._button.setScaleForState(ButtonState.HOVER, hoverScale);

			var downScale:Number = 1.3;
			this._button.setScaleForState(ButtonState.DOWN, downScale);

			var disabledScale:Number = 1.4;
			this._button.setScaleForState(ButtonState.DISABLED, disabledScale);

			var scaleWhenSelected:Number = 1.5;
			this._button.scaleWhenSelected = scaleWhenSelected;

			var selectedUpScale:Number = 1.6;
			this._button.setScaleForState(ButtonState.UP_AND_SELECTED, selectedUpScale);

			var selectedHoverScale:Number = 1.7;
			this._button.setScaleForState(ButtonState.HOVER_AND_SELECTED, selectedHoverScale);

			var selectedDownScale:Number = 1.8;
			this._button.setScaleForState(ButtonState.DOWN_AND_SELECTED, selectedDownScale);

			var selectedDisabledScale:Number = 1.9;
			this._button.setScaleForState(ButtonState.DISABLED_AND_SELECTED, selectedDisabledScale);

			Assert.assertStrictlyEquals("ToggleButton getScaleForState(ButtonState.UP) does not match value passed to setScaleForState()", upScale, this._button.getScaleForState(ButtonState.UP));
			Assert.assertStrictlyEquals("ToggleButton getScaleForState(ButtonState.HOVER) does not match value passed to setScaleForState()", hoverScale, this._button.getScaleForState(ButtonState.HOVER));
			Assert.assertStrictlyEquals("ToggleButton getScaleForState(ButtonState.DOWN) does not match value passed to setScaleForState()", downScale, this._button.getScaleForState(ButtonState.DOWN));
			Assert.assertStrictlyEquals("ToggleButton getScaleForState(ButtonState.DISABLED) does not match value passed to setScaleForState()", disabledScale, this._button.getScaleForState(ButtonState.DISABLED));
			Assert.assertStrictlyEquals("ToggleButton getScaleForState(ButtonState.UP_AND_SELECTED) does not match value passed to setScaleForState()", selectedUpScale, this._button.getScaleForState(ButtonState.UP_AND_SELECTED));
			Assert.assertStrictlyEquals("ToggleButton getScaleForState(ButtonState.HOVER_AND_SELECTED) does not match value passed to setScaleForState()", selectedHoverScale, this._button.getScaleForState(ButtonState.HOVER_AND_SELECTED));
			Assert.assertStrictlyEquals("ToggleButton getScaleForState(ButtonState.DOWN_AND_SELECTED) does not match value passed to setScaleForState()", selectedDownScale, this._button.getScaleForState(ButtonState.DOWN_AND_SELECTED));
			Assert.assertStrictlyEquals("ToggleButton getScaleForState(ButtonState.DISABLED_AND_SELECTED) does not match value passed to setScaleForState()", selectedDisabledScale, this._button.getScaleForState(ButtonState.DISABLED_AND_SELECTED));
		}

		[Test]
		public function testDefaultCurrentScale():void
		{
			this._button.defaultSkin = new Quad(200, 200);
			this._button.isSelected = true;

			var scaleWhenSelected:Number = 1.5;
			this._button.scaleWhenSelected = scaleWhenSelected;

			this._button.validate();
			Assert.assertStrictlyEquals("ToggleButton state is not ButtonState.UP_AND_SELECTED with no touch and isSelected is true", ButtonState.UP_AND_SELECTED, this._button.currentState);
			Assert.assertStrictlyEquals("ToggleButton scale is not scaleWhenSelected when currentState is ButtonState.UP_AND_SELECTED and scale not provided for this state", scaleWhenSelected, this._button.currentScaleInternal);

			this._button.isEnabled = false;
			this._button.validate();
			Assert.assertStrictlyEquals("ToggleButton state is not ButtonState.DISABLED_AND_SELECTED when isEnabled is false and isSelected is true", ButtonState.DISABLED_AND_SELECTED, this._button.currentState);
			Assert.assertStrictlyEquals("ToggleButton scale is not scaleWhenSelected when currentState is ButtonState.DISABLED_AND_SELECTED and scale not provided for this state", scaleWhenSelected, this._button.currentScaleInternal);

			this._button.isEnabled = true;

			var position:Point = new Point(10, 10);
			var target:DisplayObject = this._button.stage.hitTest(position);
			Assert.assertStrictlyEquals("Touch target must be button", this._button, target);
			var touch:Touch = new Touch(0);
			touch.target = target;
			touch.phase = TouchPhase.HOVER;
			touch.globalX = position.x;
			touch.globalY = position.y;
			var touches:Vector.<Touch> = new <Touch>[touch];
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			this._button.validate();
			Assert.assertStrictlyEquals("ToggleButton state is not ButtonState.HOVER_AND_SELECTED on TouchPhase.HOVER and isSelected is true", ButtonState.HOVER_AND_SELECTED, this._button.currentState);
			Assert.assertStrictlyEquals("ToggleButton scale is not scaleWhenSelected when currentState is ButtonState.HOVER and scale not provided for this state", scaleWhenSelected, this._button.currentScaleInternal);

			touch.phase = TouchPhase.BEGAN;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			this._button.validate();
			Assert.assertStrictlyEquals("ToggleButton state is not ButtonState.DOWN_AND_SELECTED on TouchPhase.BEGAN and isSelected is true", ButtonState.DOWN_AND_SELECTED, this._button.currentState);
			Assert.assertStrictlyEquals("ToggleButton scale is not scaleWhenSelected when currentState is ButtonState.DOWN and scale not provided for this state", scaleWhenSelected, this._button.currentScaleInternal);
		}

		[Test]
		public function testCurrentScaleWithSetScaleForState():void
		{
			this._button.defaultSkin = new Quad(200, 200);
			this._button.isSelected = true;
			
			var scaleWhenSelected:Number = 2.0;
			this._button.scaleWhenSelected = scaleWhenSelected;

			var selectedUpScale:Number = 1.1;
			this._button.setScaleForState(ButtonState.UP_AND_SELECTED, selectedUpScale);

			var selectedHoverScale:Number = 1.2;
			this._button.setScaleForState(ButtonState.HOVER_AND_SELECTED, selectedHoverScale);

			var selectedDownScale:Number = 1.3;
			this._button.setScaleForState(ButtonState.DOWN_AND_SELECTED, selectedDownScale);

			var selectedDisabledScale:Number = 1.4;
			this._button.setScaleForState(ButtonState.DISABLED_AND_SELECTED, selectedDisabledScale);

			this._button.validate();
			Assert.assertStrictlyEquals("ToggleButton state is not ButtonState.UP_AND_SELECTED with no touch and isSelected is true", ButtonState.UP_AND_SELECTED, this._button.currentState);
			Assert.assertStrictlyEquals("ToggleButton scale does not match scale set with setScaleForState() when currentState is ButtonState.UP_AND_SELECTED", selectedUpScale, this._button.currentScaleInternal);

			this._button.isEnabled = false;
			this._button.validate();
			Assert.assertStrictlyEquals("ToggleButton state is not ButtonState.DISABLED_AND_SELECTED when isEnabled is false and isSelected is true", ButtonState.DISABLED_AND_SELECTED, this._button.currentState);
			Assert.assertStrictlyEquals("ToggleButton scale does not match scale set with setScaleForState() when currentState is ButtonState.DISABLED_AND_SELECTED", selectedDisabledScale, this._button.currentScaleInternal);

			this._button.isEnabled = true;

			var position:Point = new Point(10, 10);
			var target:DisplayObject = this._button.stage.hitTest(position);
			Assert.assertStrictlyEquals("Touch target must be button", this._button, target);
			var touch:Touch = new Touch(0);
			touch.target = target;
			touch.phase = TouchPhase.HOVER;
			touch.globalX = position.x;
			touch.globalY = position.y;
			var touches:Vector.<Touch> = new <Touch>[touch];
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			this._button.validate();
			Assert.assertStrictlyEquals("ToggleButton state is not ButtonState.HOVER_AND_SELECTED on TouchPhase.HOVER and isSelected is true", ButtonState.HOVER_AND_SELECTED, this._button.currentState);
			Assert.assertStrictlyEquals("ToggleButton scale does not match scale set with setScaleForState() when currentState is ButtonState.HOVER_AND_SELECTED and scale not provided for this state", selectedHoverScale, this._button.currentScaleInternal);

			touch.phase = TouchPhase.BEGAN;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			this._button.validate();
			Assert.assertStrictlyEquals("ToggleButton state is not ButtonState.DOWN_AND_SELECTED on TouchPhase.BEGAN and isSelected is true", ButtonState.DOWN_AND_SELECTED, this._button.currentState);
			Assert.assertStrictlyEquals("ToggleButton scale does not match scale set with setScaleForState() when currentState is ButtonState.DOWN_AND_SELECTED and scale not provided for this state", selectedDownScale, this._button.currentScaleInternal);
		}
	}
}

import feathers.controls.ToggleButton;
import feathers.core.ITextRenderer;

import starling.display.DisplayObject;

class ToggleButtonWithInternalState extends ToggleButton
{
	public function ToggleButtonWithInternalState()
	{
		super();
	}

	public function get labelTextRendererInternal():ITextRenderer
	{
		return this.labelTextRenderer;
	}

	public function get currentSkinInternal():DisplayObject
	{
		return this.currentSkin;
	}

	public function get currentIconInternal():DisplayObject
	{
		return this.currentIcon;
	}

	public function get currentScaleInternal():Number
	{
		return this.getCurrentScale();
	}
}