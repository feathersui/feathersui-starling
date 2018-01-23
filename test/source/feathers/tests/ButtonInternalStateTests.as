package feathers.tests
{
	import feathers.controls.ButtonState;
	import feathers.controls.text.BitmapFontTextRenderer;
	import feathers.text.BitmapFontTextFormat;

	import flash.geom.Point;

	import org.flexunit.Assert;

	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.BitmapFont;

	public class ButtonInternalStateTests
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
		public function testGetIconForStateWithoutSetIconForState():void
		{
			Assert.assertNull("Button getIconForState(ButtonState.UP) must be null when setIconForState() is not called", this._button.getIconForState(ButtonState.UP));
			Assert.assertNull("Button getIconForState(ButtonState.HOVER) must be null when setIconForState() is not called", this._button.getIconForState(ButtonState.HOVER));
			Assert.assertNull("Button getIconForState(ButtonState.DOWN) must be null when setIconForState() is not called", this._button.getIconForState(ButtonState.DOWN));
			Assert.assertNull("Button getIconForState(ButtonState.DISABLED) must be null when setIconForState() is not called", this._button.getIconForState(ButtonState.DISABLED));
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

			Assert.assertStrictlyEquals("Button getIconForState(ButtonState.UP) does not match value passed to setIconForState()", upIcon, this._button.getIconForState(ButtonState.UP));
			Assert.assertStrictlyEquals("Button getIconForState(ButtonState.HOVER) does not match value passed to setIconForState()", hoverIcon, this._button.getIconForState(ButtonState.HOVER));
			Assert.assertStrictlyEquals("Button getIconForState(ButtonState.DOWN) does not match value passed to setIconForState()", downIcon, this._button.getIconForState(ButtonState.DOWN));
			Assert.assertStrictlyEquals("Button getIconForState(ButtonState.DISABLED) does not match value passed to setIconForState()", disabledIcon, this._button.getIconForState(ButtonState.DISABLED));
		}

		[Test]
		public function testDefaultCurrentIcon():void
		{
			var defaultIcon:Quad = new Quad(200, 200);
			this._button.defaultIcon = defaultIcon;

			this._button.validate();
			Assert.assertStrictlyEquals("Button state is not ButtonState.UP with no touch", ButtonState.UP, this._button.currentState);
			Assert.assertStrictlyEquals("Button icon is not defaultIcon when currentState is ButtonState.UP and icon not provided for this state", defaultIcon, this._button.currentIconInternal);

			this._button.isEnabled = false;
			this._button.validate();
			Assert.assertStrictlyEquals("Button state is not ButtonState.DISABLED when isEnabled is false", ButtonState.DISABLED, this._button.currentState);
			Assert.assertStrictlyEquals("Button icon is not defaultIcon when currentState is ButtonState.DISABLED and icon not provided for this state", defaultIcon, this._button.currentIconInternal);

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
			Assert.assertStrictlyEquals("Button state is not ButtonState.HOVER on TouchPhase.HOVER", ButtonState.HOVER, this._button.currentState);
			Assert.assertStrictlyEquals("Button icon is not defaultIcon when currentState is ButtonState.HOVER and icon not provided for this state", defaultIcon, this._button.currentIconInternal);

			touch.phase = TouchPhase.BEGAN;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			this._button.validate();
			Assert.assertStrictlyEquals("Button state is not ButtonState.DOWN on TouchPhase.BEGAN", ButtonState.DOWN, this._button.currentState);
			Assert.assertStrictlyEquals("Button icon is not defaultIcon when currentState is ButtonState.DOWN and icon not provided for this state", defaultIcon, this._button.currentIconInternal);
		}

		[Test]
		public function testCurrentIconWithSetIconForState():void
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

			this._button.validate();
			Assert.assertStrictlyEquals("Button state is not ButtonState.UP with no touch", ButtonState.UP, this._button.currentState);
			Assert.assertStrictlyEquals("Button icon does not match icon set with setIconForState() when currentState is ButtonState.UP", upIcon, this._button.currentIconInternal);

			this._button.isEnabled = false;
			this._button.validate();
			Assert.assertStrictlyEquals("Button state is not ButtonState.DISABLED when isEnabled is false", ButtonState.DISABLED, this._button.currentState);
			Assert.assertStrictlyEquals("Button icon does not match icon set with setIconForState() when currentState is ButtonState.DISABLED", disabledIcon, this._button.currentIconInternal);

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
			Assert.assertStrictlyEquals("Button state is not ButtonState.HOVER on TouchPhase.HOVER", ButtonState.HOVER, this._button.currentState);
			Assert.assertStrictlyEquals("Button icon does not match icon set with setIconForState() when currentState is ButtonState.HOVER and icon not provided for this state", hoverIcon, this._button.currentIconInternal);

			touch.phase = TouchPhase.BEGAN;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			this._button.validate();
			Assert.assertStrictlyEquals("Button state is not ButtonState.DOWN on TouchPhase.BEGAN", ButtonState.DOWN, this._button.currentState);
			Assert.assertStrictlyEquals("Button icon does not match icon set with setIconForState() when currentState is ButtonState.DOWN and icon not provided for this state", downIcon, this._button.currentIconInternal);
		}

		[Test]
		public function testDefaultLabelProperties():void
		{
			this._button.defaultSkin = new Quad(200, 200);
			
			var defaultFontSize:Number = 10;

			this._button.defaultLabelProperties.textFormat = new BitmapFontTextFormat(new BitmapFont(), defaultFontSize);

			this._button.validate();
			var textRenderer:BitmapFontTextRenderer = BitmapFontTextRenderer(this._button.labelTextRendererInternal);

			Assert.assertStrictlyEquals("Button state is not ButtonState.UP with no touch", ButtonState.UP, this._button.currentState);
			Assert.assertStrictlyEquals("Button label font size does not match format set with defaultLabelProperties", defaultFontSize, textRenderer.textFormat.size);

			this._button.isEnabled = false;
			this._button.validate();
			Assert.assertStrictlyEquals("Button state is not ButtonState.DISABLED when isEnabled is false", ButtonState.DISABLED, this._button.currentState);
			Assert.assertStrictlyEquals("Button label font size does not match format set with defaultLabelProperties", defaultFontSize, textRenderer.textFormat.size);

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
			Assert.assertStrictlyEquals("Button state is not ButtonState.HOVER on TouchPhase.HOVER", ButtonState.HOVER, this._button.currentState);
			Assert.assertStrictlyEquals("Button label font size does not match format set with defaultLabelProperties", defaultFontSize, textRenderer.textFormat.size);

			touch.phase = TouchPhase.BEGAN;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			this._button.validate();
			Assert.assertStrictlyEquals("Button state is not ButtonState.DOWN on TouchPhase.BEGAN", ButtonState.DOWN, this._button.currentState);
			Assert.assertStrictlyEquals("Button label font size does not match format set with defaultLabelProperties", defaultFontSize, textRenderer.textFormat.size);
		}

		[Test]
		public function testLabelProperties():void
		{
			this._button.defaultSkin = new Quad(200, 200);
			
			var defaultFontSize:Number = 10;
			var upFontSize:Number = 11;
			var hoverFontSize:Number = 12;
			var downFontSize:Number = 13;
			var disabledFontSize:Number = 14;
			
			var font:BitmapFont = new BitmapFont();
			this._button.defaultLabelProperties.textFormat = new BitmapFontTextFormat(font, defaultFontSize);
			//the following lines will produce deprecation warnings.
			//these are expected, and this test will be removed when they are
			//removed in the future.
			this._button.upLabelProperties.textFormat = new BitmapFontTextFormat(font, upFontSize);
			this._button.hoverLabelProperties.textFormat = new BitmapFontTextFormat(font, hoverFontSize);
			this._button.downLabelProperties.textFormat = new BitmapFontTextFormat(font, downFontSize);
			this._button.disabledLabelProperties.textFormat = new BitmapFontTextFormat(font, disabledFontSize);
			
			this._button.validate();
			var textRenderer:BitmapFontTextRenderer = BitmapFontTextRenderer(this._button.labelTextRendererInternal);
			
			Assert.assertStrictlyEquals("Button state is not ButtonState.UP with no touch", ButtonState.UP, this._button.currentState);
			Assert.assertStrictlyEquals("Button label font size does not match format set with upLabelProperties when currentState is ButtonState.UP", upFontSize, textRenderer.textFormat.size);

			this._button.isEnabled = false;
			this._button.validate();
			Assert.assertStrictlyEquals("Button state is not ButtonState.DISABLED when isEnabled is false", ButtonState.DISABLED, this._button.currentState);
			Assert.assertStrictlyEquals("Button label font size does not match format set with disabledLabelProperties when currentState is ButtonState.DISABLED", disabledFontSize, textRenderer.textFormat.size);

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
			Assert.assertStrictlyEquals("Button state is not ButtonState.HOVER on TouchPhase.HOVER", ButtonState.HOVER, this._button.currentState);
			Assert.assertStrictlyEquals("Button label font size does not match format set with hoverLabelProperties when currentState is ButtonState.HOVER and icon not provided for this state", hoverFontSize, textRenderer.textFormat.size);

			touch.phase = TouchPhase.BEGAN;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			this._button.validate();
			Assert.assertStrictlyEquals("Button state is not ButtonState.DOWN on TouchPhase.BEGAN", ButtonState.DOWN, this._button.currentState);
			Assert.assertStrictlyEquals("Button icon label font size does not match format set with downLabelProperties when currentState is ButtonState.DOWN and icon not provided for this state", downFontSize, textRenderer.textFormat.size);
		}

		[Test]
		public function testGetScaleForStateWithoutSetSkinForState():void
		{
			Assert.assertTrue("Button getScaleForState(ButtonState.UP) must be NaN when setScaleForState() is not called",
				isNaN(this._button.getScaleForState(ButtonState.UP)));
			Assert.assertTrue("Button getScaleForState(ButtonState.HOVER) must be NaN when setScaleForState() is not called",
				isNaN(this._button.getScaleForState(ButtonState.HOVER)));
			Assert.assertTrue("Button getScaleForState(ButtonState.DOWN) must be NaN when setScaleForState() is not called",
				isNaN(this._button.getScaleForState(ButtonState.DOWN)));
			Assert.assertTrue("Button getScaleForState(ButtonState.DISABLED) must be NaN when setScaleForState() is not called",
				isNaN(this._button.getScaleForState(ButtonState.DISABLED)));
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

			Assert.assertStrictlyEquals("Button getScaleForState(ButtonState.UP) does not match value passed to setScaleForState()", upScale, this._button.getScaleForState(ButtonState.UP));
			Assert.assertStrictlyEquals("Button getScaleForState(ButtonState.HOVER) does not match value passed to setScaleForState()", hoverScale, this._button.getScaleForState(ButtonState.HOVER));
			Assert.assertStrictlyEquals("Button getScaleForState(ButtonState.DOWN) does not match value passed to setScaleForState()", downScale, this._button.getScaleForState(ButtonState.DOWN));
			Assert.assertStrictlyEquals("Button getScaleForState(ButtonState.DISABLED) does not match value passed to setScaleForState()", disabledScale, this._button.getScaleForState(ButtonState.DISABLED));
		}

		[Test]
		public function testDefaultCurrentScale():void
		{
			this._button.defaultSkin = new Quad(200, 200);

			this._button.isEnabled = false;
			this._button.validate();
			Assert.assertStrictlyEquals("Button state is not ButtonState.DISABLED when isEnabled is false",
				ButtonState.DISABLED, this._button.currentState);
			Assert.assertStrictlyEquals("Button scale is not 1 when currentState is ButtonState.DISABLED and scale not provided for this state",
				1, this._button.currentScaleInternal);

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
			Assert.assertStrictlyEquals("Button state is not ButtonState.HOVER on TouchPhase.HOVER",
				ButtonState.HOVER, this._button.currentState);
			Assert.assertStrictlyEquals("Button scale is not 1 when currentState is ButtonState.HOVER and scale not provided for this state",
				1, this._button.currentScaleInternal);

			touch.phase = TouchPhase.BEGAN;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			this._button.validate();
			Assert.assertStrictlyEquals("Button state is not ButtonState.DOWN on TouchPhase.BEGAN",
				ButtonState.DOWN, this._button.currentState);
			Assert.assertStrictlyEquals("Button scale is not 1 when currentState is ButtonState.DOWN and scale not provided for this state",
				1, this._button.currentScaleInternal);
		}

		[Test]
		public function testCurrentScaleWithSetScaleForState():void
		{
			this._button.defaultSkin = new Quad(200, 200);

			var upScale:Number = 1.1;
			this._button.setScaleForState(ButtonState.UP, upScale);

			var hoverScale:Number = 1.2;
			this._button.setScaleForState(ButtonState.HOVER, hoverScale);

			var downScale:Number = 1.3;
			this._button.setScaleForState(ButtonState.DOWN, downScale);

			var disabledScale:Number = 1.4;
			this._button.setScaleForState(ButtonState.DISABLED, disabledScale);

			this._button.validate();
			Assert.assertStrictlyEquals("Button state is not ButtonState.UP with no touch",
				ButtonState.UP, this._button.currentState);
			Assert.assertStrictlyEquals("Button scale does not match scale set with setScaleForState() when currentState is ButtonState.UP",
				upScale, this._button.currentScaleInternal);

			this._button.isEnabled = false;
			this._button.validate();
			Assert.assertStrictlyEquals("Button state is not ButtonState.DISABLED when isEnabled is false",
				ButtonState.DISABLED, this._button.currentState);
			Assert.assertStrictlyEquals("Button scale does not match scale set with setScaleForState() when currentState is ButtonState.DISABLED",
				disabledScale, this._button.currentScaleInternal);

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
			Assert.assertStrictlyEquals("Button state is not ButtonState.HOVER on TouchPhase.HOVER",
				ButtonState.HOVER, this._button.currentState);
			Assert.assertStrictlyEquals("Button scale does not match scale set with setScaleForState() when currentState is ButtonState.HOVER and scale not provided for this state",
				hoverScale, this._button.currentScaleInternal);

			touch.phase = TouchPhase.BEGAN;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			this._button.validate();
			Assert.assertStrictlyEquals("Button state is not ButtonState.DOWN on TouchPhase.BEGAN",
				ButtonState.DOWN, this._button.currentState);
			Assert.assertStrictlyEquals("Button scale does not match scale set with setScaleForState() when currentState is ButtonState.DOWN and scale not provided for this state",
				downScale, this._button.currentScaleInternal);
		}
	}
}

import feathers.controls.Button;
import feathers.core.ITextRenderer;

import starling.display.DisplayObject;

class ButtonWithInternalState extends Button
{
	public function ButtonWithInternalState()
	{
		super();
	}

	public function get labelTextRendererInternal():ITextRenderer
	{
		return this.labelTextRenderer;
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