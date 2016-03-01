package feathers.tests
{
	import feathers.controls.Button;
	import feathers.controls.ButtonState;

	import flash.geom.Point;

	import org.flexunit.Assert;

	import starling.display.DisplayObject;

	import starling.display.Quad;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class BasicButtonInternalStateTests
	{
		private var _button:ButtonWithInternalState;

		[Before]
		public function prepare():void
		{
			this._button = new ButtonWithInternalState();
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
			Assert.assertNull("BasicButton getSkinForState(ButtonState.UP) must be null when setSkinForState() is not called", this._button.getSkinForState(ButtonState.UP));
			Assert.assertNull("BasicButton getSkinForState(ButtonState.HOVER) must be null when setSkinForState() is not called", this._button.getSkinForState(ButtonState.HOVER));
			Assert.assertNull("BasicButton getSkinForState(ButtonState.DOWN) must be null when setSkinForState() is not called", this._button.getSkinForState(ButtonState.DOWN));
			Assert.assertNull("BasicButton getSkinForState(ButtonState.DISABLED) must be null when setSkinForState() is not called", this._button.getSkinForState(ButtonState.DISABLED));
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
			
			Assert.assertStrictlyEquals("BasicButton getSkinForState(ButtonState.UP) does not match value passed to setSkinForState()", upSkin, this._button.getSkinForState(ButtonState.UP));
			Assert.assertStrictlyEquals("BasicButton getSkinForState(ButtonState.HOVER) does not match value passed to setSkinForState()", hoverSkin, this._button.getSkinForState(ButtonState.HOVER));
			Assert.assertStrictlyEquals("BasicButton getSkinForState(ButtonState.DOWN) does not match value passed to setSkinForState()", downSkin, this._button.getSkinForState(ButtonState.DOWN));
			Assert.assertStrictlyEquals("BasicButton getSkinForState(ButtonState.DISABLED) does not match value passed to setSkinForState()", disabledSkin, this._button.getSkinForState(ButtonState.DISABLED));
		}
		
		[Test]
		public function testDefaultCurrentSkin():void
		{
			var defaultSkin:Quad = new Quad(200, 200);
			this._button.defaultSkin = defaultSkin;
			
			this._button.validate();
			Assert.assertStrictlyEquals("BasicButton state is not ButtonState.UP with no touch", ButtonState.UP, this._button.currentState);
			Assert.assertStrictlyEquals("BasicButton skin is not defaultSkin when currentState is ButtonState.UP and skin not provided for this state", defaultSkin, this._button.currentSkinInternal);

			this._button.isEnabled = false;
			this._button.validate();
			Assert.assertStrictlyEquals("BasicButton state is not ButtonState.DISABLED when isEnabled is false", ButtonState.DISABLED, this._button.currentState);
			Assert.assertStrictlyEquals("BasicButton skin is not defaultSkin when currentState is ButtonState.DISABLED and skin not provided for this state", defaultSkin, this._button.currentSkinInternal);

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
			Assert.assertStrictlyEquals("BasicButton state is not ButtonState.HOVER on TouchPhase.HOVER", ButtonState.HOVER, this._button.currentState);
			Assert.assertStrictlyEquals("BasicButton skin is not defaultSkin when currentState is ButtonState.HOVER and skin not provided for this state", defaultSkin, this._button.currentSkinInternal);
			
			touch.phase = TouchPhase.BEGAN;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			this._button.validate();
			Assert.assertStrictlyEquals("BasicButton state is not ButtonState.DOWN on TouchPhase.BEGAN", ButtonState.DOWN, this._button.currentState);
			Assert.assertStrictlyEquals("BasicButton skin is not defaultSkin when currentState is ButtonState.DOWN and skin not provided for this state", defaultSkin, this._button.currentSkinInternal);
		}

		[Test]
		public function testCurrentSkinWithSetSkinForState():void
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

			this._button.validate();
			Assert.assertStrictlyEquals("BasicButton state is not ButtonState.UP with no touch", ButtonState.UP, this._button.currentState);
			Assert.assertStrictlyEquals("BasicButton skin does not match skin set with setSkinForState() when currentState is ButtonState.UP", upSkin, this._button.currentSkinInternal);
			
			this._button.isEnabled = false;
			this._button.validate();
			Assert.assertStrictlyEquals("BasicButton state is not ButtonState.DISABLED when isEnabled is false", ButtonState.DISABLED, this._button.currentState);
			Assert.assertStrictlyEquals("BasicButton skin does not match skin set with setSkinForState() when currentState is ButtonState.DISABLED", disabledSkin, this._button.currentSkinInternal);

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
			Assert.assertStrictlyEquals("BasicButton state is not ButtonState.HOVER on TouchPhase.HOVER", ButtonState.HOVER, this._button.currentState);
			Assert.assertStrictlyEquals("BasicButton skin does not match skin set with setSkinForState() when currentState is ButtonState.HOVER and skin not provided for this state", hoverSkin, this._button.currentSkinInternal);

			touch.phase = TouchPhase.BEGAN;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			this._button.validate();
			Assert.assertStrictlyEquals("BasicButton state is not ButtonState.DOWN on TouchPhase.BEGAN", ButtonState.DOWN, this._button.currentState);
			Assert.assertStrictlyEquals("BasicButton skin does not match skin set with setSkinForState() when currentState is ButtonState.DOWN and skin not provided for this state", downSkin, this._button.currentSkinInternal);
		}
	}
}

import feathers.controls.BasicButton;

import starling.display.DisplayObject;

class ButtonWithInternalState extends BasicButton
{
	public function ButtonWithInternalState()
	{
		super();
	}
	
	public function get currentSkinInternal():DisplayObject
	{
		return this.currentSkin;
	}
}