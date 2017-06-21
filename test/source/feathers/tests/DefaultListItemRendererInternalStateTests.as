package feathers.tests
{
	import feathers.controls.ButtonState;
	import feathers.controls.ImageLoader;
	import feathers.controls.LayoutGroup;
	import feathers.controls.List;

	import flash.geom.Point;

	import org.flexunit.Assert;

	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	public class DefaultListItemRendererInternalStateTests
	{
		private var _itemRenderer:DefaultListItemRendererWithInternalState;
		private var _list:List;

		[Before]
		public function prepare():void
		{
			this._list = new List();
			
			this._itemRenderer = new DefaultListItemRendererWithInternalState();
			this._itemRenderer.owner = this._list;
			this._itemRenderer.index = 0;
			this._itemRenderer.data = {};
			this._itemRenderer.useStateDelayTimer = false;
			TestFeathers.starlingRoot.addChild(this._itemRenderer);
		}

		[After]
		public function cleanup():void
		{
			this._itemRenderer.removeFromParent(true);
			this._itemRenderer = null;
			
			this._list.dispose();
			this._list = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testGetAccessoryForStateWithoutSetAccessoryForState():void
		{
			Assert.assertNull("DefaultListItemRenderer getAccessoryForState(ButtonState.UP) must be null when setAccessoryForState() is not called", this._itemRenderer.getAccessoryForState(ButtonState.UP));
			Assert.assertNull("DefaultListItemRenderer getAccessoryForState(ButtonState.HOVER) must be null when setAccessoryForState() is not called", this._itemRenderer.getAccessoryForState(ButtonState.HOVER));
			Assert.assertNull("DefaultListItemRenderer getAccessoryForState(ButtonState.DOWN) must be null when setAccessoryForState() is not called", this._itemRenderer.getAccessoryForState(ButtonState.DOWN));
			Assert.assertNull("DefaultListItemRenderer getAccessoryForState(ButtonState.DISABLED) must be null when setAccessoryForState() is not called", this._itemRenderer.getAccessoryForState(ButtonState.DISABLED));
		}

		[Test]
		public function testGetAccessoryForState():void
		{
			this._itemRenderer.isQuickHitAreaEnabled = true;
			this._itemRenderer.itemHasAccessory = false;

			var defaultAccessory:Quad = new Quad(200, 200);
			this._itemRenderer.defaultAccessory = defaultAccessory;

			var upAccessory:Quad = new Quad(200, 200);
			this._itemRenderer.setAccessoryForState(ButtonState.UP, upAccessory);

			var hoverAccessory:Quad = new Quad(200, 200);
			this._itemRenderer.setAccessoryForState(ButtonState.HOVER, hoverAccessory);

			var downAccessory:Quad = new Quad(200, 200);
			this._itemRenderer.setAccessoryForState(ButtonState.DOWN, downAccessory);

			var disabledAccessory:Quad = new Quad(200, 200);
			this._itemRenderer.setAccessoryForState(ButtonState.DISABLED, disabledAccessory);

			Assert.assertStrictlyEquals("Item Renderer getAccessoryForState(ButtonState.UP) does not match value passed to setAccessoryForState()", upAccessory, this._itemRenderer.getAccessoryForState(ButtonState.UP));
			Assert.assertStrictlyEquals("Item Renderer getAccessoryForState(ButtonState.HOVER) does not match value passed to setAccessoryForState()", hoverAccessory, this._itemRenderer.getAccessoryForState(ButtonState.HOVER));
			Assert.assertStrictlyEquals("Item Renderer getAccessoryForState(ButtonState.DOWN) does not match value passed to setAccessoryForState()", downAccessory, this._itemRenderer.getAccessoryForState(ButtonState.DOWN));
			Assert.assertStrictlyEquals("Item Renderer getAccessoryForState(ButtonState.DISABLED) does not match value passed to setAccessoryForState()", disabledAccessory, this._itemRenderer.getAccessoryForState(ButtonState.DISABLED));
		}

		[Test]
		public function testDefaultCurrentAccessory():void
		{
			this._itemRenderer.isQuickHitAreaEnabled = true;
			this._itemRenderer.itemHasAccessory = false;

			var defaultAccessory:Quad = new Quad(200, 200);
			this._itemRenderer.defaultAccessory = defaultAccessory;

			this._itemRenderer.validate();
			Assert.assertStrictlyEquals("Item Renderer state is not ButtonState.UP with no touch", ButtonState.UP, this._itemRenderer.currentState);
			Assert.assertStrictlyEquals("Item Renderer accessory is not defaultAccessory when currentState is ButtonState.UP and accessory not provided for this state", defaultAccessory, this._itemRenderer.currentAccessoryInternal);
			
			this._itemRenderer.isEnabled = false;
			this._itemRenderer.validate();
			Assert.assertStrictlyEquals("Item Renderer state is not ButtonState.DISABLED when isEnabled is false", ButtonState.DISABLED, this._itemRenderer.currentState);
			Assert.assertStrictlyEquals("Item Renderer accessory is not defaultAccessory when currentState is ButtonState.DISABLED and accessory not provided for this state", defaultAccessory, this._itemRenderer.currentAccessoryInternal);

			this._itemRenderer.isEnabled = true;

			var position:Point = new Point(10, 10);
			var target:DisplayObject = this._itemRenderer.stage.hitTest(position);
			Assert.assertStrictlyEquals("Touch target must be item renderer", this._itemRenderer, target);
			var touch:Touch = new Touch(0);
			touch.target = target;
			touch.phase = TouchPhase.HOVER;
			touch.globalX = position.x;
			touch.globalY = position.y;
			var touches:Vector.<Touch> = new <Touch>[touch];
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			this._itemRenderer.validate();
			Assert.assertStrictlyEquals("Item Renderer state is not ButtonState.HOVER on TouchPhase.HOVER", ButtonState.HOVER, this._itemRenderer.currentState);
			Assert.assertStrictlyEquals("Item Renderer accessory is not defaultAccessory when currentState is ButtonState.HOVER and accessory not provided for this state", defaultAccessory, this._itemRenderer.currentAccessoryInternal);

			touch.phase = TouchPhase.BEGAN;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			this._itemRenderer.validate();
			Assert.assertStrictlyEquals("Item Renderer state is not ButtonState.DOWN on TouchPhase.BEGAN", ButtonState.DOWN, this._itemRenderer.currentState);
			Assert.assertStrictlyEquals("Item Renderer accessory is not defaultAccessory when currentState is ButtonState.DOWN and accessory not provided for this state", defaultAccessory, this._itemRenderer.currentAccessoryInternal);
		}

		[Test]
		public function testCurrentAccessoryWithSetAccessoryForState():void
		{
			this._itemRenderer.isQuickHitAreaEnabled = true;
			this._itemRenderer.itemHasAccessory = false;
			
			var defaultAccessory:Quad = new Quad(200, 200);
			this._itemRenderer.defaultAccessory = defaultAccessory;

			var upAccessory:Quad = new Quad(200, 200);
			this._itemRenderer.setAccessoryForState(ButtonState.UP, upAccessory);

			var hoverAccessory:Quad = new Quad(200, 200);
			this._itemRenderer.setAccessoryForState(ButtonState.HOVER, hoverAccessory);

			var downAccessory:Quad = new Quad(200, 200);
			this._itemRenderer.setAccessoryForState(ButtonState.DOWN, downAccessory);

			var disabledAccessory:Quad = new Quad(200, 200);
			this._itemRenderer.setAccessoryForState(ButtonState.DISABLED, disabledAccessory);

			this._itemRenderer.validate();
			Assert.assertStrictlyEquals("Item Renderer state is not ButtonState.UP with no touch", ButtonState.UP, this._itemRenderer.currentState);
			Assert.assertStrictlyEquals("Item Renderer accessory does not match accessory set with setAccessoryForState() when currentState is ButtonState.UP", upAccessory, this._itemRenderer.currentAccessoryInternal);

			this._itemRenderer.isEnabled = false;
			this._itemRenderer.validate();
			Assert.assertStrictlyEquals("Item Renderer state is not ButtonState.DISABLED when isEnabled is false", ButtonState.DISABLED, this._itemRenderer.currentState);
			Assert.assertStrictlyEquals("Item Renderer accessory does not match accessory set with setAccessoryForState() when currentState is ButtonState.DISABLED", disabledAccessory, this._itemRenderer.currentAccessoryInternal);

			this._itemRenderer.isEnabled = true;

			var position:Point = new Point(10, 10);
			var target:DisplayObject = this._itemRenderer.stage.hitTest(position);
			Assert.assertStrictlyEquals("Touch target must be item renderer", this._itemRenderer, target);
			var touch:Touch = new Touch(0);
			touch.target = target;
			touch.phase = TouchPhase.HOVER;
			touch.globalX = position.x;
			touch.globalY = position.y;
			var touches:Vector.<Touch> = new <Touch>[touch];
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			this._itemRenderer.validate();
			Assert.assertStrictlyEquals("Item Renderer state is not ButtonState.HOVER on TouchPhase.HOVER",
				ButtonState.HOVER, this._itemRenderer.currentState);
			Assert.assertStrictlyEquals("Item Renderer accessory does not match accessory set with setAccessoryForState() when currentState is ButtonState.HOVER and accessory not provided for this state",
				hoverAccessory, this._itemRenderer.currentAccessoryInternal);

			touch.phase = TouchPhase.BEGAN;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			this._itemRenderer.validate();
			Assert.assertStrictlyEquals("Item Renderer state is not ButtonState.DOWN on TouchPhase.BEGAN", ButtonState.DOWN, this._itemRenderer.currentState);
			Assert.assertStrictlyEquals("Item Renderer accessory does not match accessory set with setAccessoryForState() when currentState is ButtonState.DOWN and accessory not provided for this state", downAccessory, this._itemRenderer.currentAccessoryInternal);
		}

		[Test]
		public function testTapToSelectIsEnabledWhenIsSelectableOnAccessoryTouchIsFalseWithAccessorySourceFunction():void
		{
			var accessory:ImageLoader;
			var texture:Texture;
			this._itemRenderer.itemHasAccessory = true;
			this._itemRenderer.accessoryLoaderFactory = function():ImageLoader
			{
				accessory = new ImageLoader();
				return accessory;
			}
			this._itemRenderer.accessorySourceFunction = function():Texture
			{
				if(texture)
				{
					texture.dispose();
				}
				texture = Texture.fromColor(200, 200, 0xff00ff);
				return texture;
			}
			this._itemRenderer.isSelectableOnAccessoryTouch = false;
			this._itemRenderer.hasLabelTextRenderer = false;
			this._itemRenderer.validate();

			var position:Point = new Point(20, 20);
			var target:DisplayObject = this._itemRenderer.stage.hitTest(position);
			Assert.assertStrictlyEquals("Touch target must be item renderer accessory", accessory, target);
			var touch:Touch = new Touch(0);
			touch.target = target;
			touch.phase = TouchPhase.BEGAN;
			touch.globalX = position.x;
			touch.globalY = position.y;
			var touches:Vector.<Touch> = new <Touch>[touch];
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			this._itemRenderer.validate();
			Assert.assertTrue("Item Renderer TapToSelect is incorrectly disabled when isSelectableOnAccessoryTouch is false on TouchPhase.BEGAN", this._itemRenderer.tapToSelectInternal.isEnabled);

			touch.phase = TouchPhase.ENDED;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			this._itemRenderer.validate();
			Assert.assertTrue("Item Renderer TapToSelect is incorrectly disabled when isSelectableOnAccessoryTouch is false on TouchPhase.ENDED", this._itemRenderer.tapToSelectInternal.isEnabled);

			texture.dispose();
		}

		[Test]
		public function testTapToSelectIsEnabledWhenIsSelectableOnAccessoryTouchIsTrueWithAccessorySourceFunction():void
		{
			var accessory:ImageLoader;
			var texture:Texture;
			this._itemRenderer.itemHasAccessory = true;
			this._itemRenderer.accessoryLoaderFactory = function():ImageLoader
			{
				accessory = new ImageLoader();
				return accessory;
			}
			this._itemRenderer.accessorySourceFunction = function():Texture
			{
				if(texture)
				{
					texture.dispose();
				}
				texture = Texture.fromColor(200, 200, 0xff00ff);
				return texture;
			}
			this._itemRenderer.isSelectableOnAccessoryTouch = true;
			this._itemRenderer.hasLabelTextRenderer = false;
			this._itemRenderer.validate();

			var position:Point = new Point(20, 20);
			var target:DisplayObject = this._itemRenderer.stage.hitTest(position);
			Assert.assertStrictlyEquals("Touch target must be item renderer accessory", accessory, target);
			var touch:Touch = new Touch(0);
			touch.target = target;
			touch.phase = TouchPhase.BEGAN;
			touch.globalX = position.x;
			touch.globalY = position.y;
			var touches:Vector.<Touch> = new <Touch>[touch];
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			this._itemRenderer.validate();
			Assert.assertTrue("Item Renderer TapToSelect is incorrectly disabled when isSelectableOnAccessoryTouch is true on TouchPhase.BEGAN", this._itemRenderer.tapToSelectInternal.isEnabled);

			touch.phase = TouchPhase.ENDED;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			this._itemRenderer.validate();
			Assert.assertTrue("Item Renderer TapToSelect is incorrectly disabled when isSelectableOnAccessoryTouch is true on TouchPhase.ENDED", this._itemRenderer.tapToSelectInternal.isEnabled);

			texture.dispose();
		}

		[Test]
		public function testTapToSelectIsEnabledWhenIsSelectableOnAccessoryTouchIsFalseWithDefaultAccessory():void
		{
			this._itemRenderer.itemHasAccessory = false;
			var defaultAccessory:LayoutGroup = new LayoutGroup();
			defaultAccessory.backgroundSkin = new Quad(200, 200);
			this._itemRenderer.defaultAccessory = defaultAccessory;
			this._itemRenderer.isSelectableOnAccessoryTouch = false;
			this._itemRenderer.hasLabelTextRenderer = false;
			this._itemRenderer.validate();

			var position:Point = new Point(20, 20);
			var target:DisplayObject = this._itemRenderer.stage.hitTest(position);
			Assert.assertStrictlyEquals("Touch target must be item renderer accessory", defaultAccessory, target);
			var touch:Touch = new Touch(0);
			touch.target = target;
			touch.phase = TouchPhase.BEGAN;
			touch.globalX = position.x;
			touch.globalY = position.y;
			var touches:Vector.<Touch> = new <Touch>[touch];
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			this._itemRenderer.validate();
			Assert.assertFalse("Item Renderer TapToSelect is incorrectly enabled when isSelectableOnAccessoryTouch is false on TouchPhase.BEGAN", this._itemRenderer.tapToSelectInternal.isEnabled);

			touch.phase = TouchPhase.ENDED;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			this._itemRenderer.validate();
			Assert.assertTrue("Item Renderer TapToSelect is incorrectly disabled when isSelectableOnAccessoryTouch is false on TouchPhase.ENDED", this._itemRenderer.tapToSelectInternal.isEnabled);
		}

		[Test]
		public function testTapToSelectIsEnabledWhenIsSelectableOnAccessoryTouchIsTrueWithDefaultAccessory():void
		{
			this._itemRenderer.itemHasAccessory = false;
			var defaultAccessory:LayoutGroup = new LayoutGroup();
			defaultAccessory.backgroundSkin = new Quad(200, 200);
			this._itemRenderer.defaultAccessory = defaultAccessory;
			this._itemRenderer.isSelectableOnAccessoryTouch = true;
			this._itemRenderer.hasLabelTextRenderer = false;
			this._itemRenderer.validate();

			var position:Point = new Point(20, 20);
			var target:DisplayObject = this._itemRenderer.stage.hitTest(position);
			Assert.assertStrictlyEquals("Touch target must be item renderer accessory", defaultAccessory, target);
			var touch:Touch = new Touch(0);
			touch.target = target;
			touch.phase = TouchPhase.BEGAN;
			touch.globalX = position.x;
			touch.globalY = position.y;
			var touches:Vector.<Touch> = new <Touch>[touch];
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			this._itemRenderer.validate();
			Assert.assertTrue("Item Renderer TapToSelect is incorrectly disabled when isSelectableOnAccessoryTouch is true on TouchPhase.BEGAN", this._itemRenderer.tapToSelectInternal.isEnabled);

			touch.phase = TouchPhase.ENDED;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			this._itemRenderer.validate();
			Assert.assertTrue("Item Renderer TapToSelect is incorrectly disabled when isSelectableOnAccessoryTouch is true on TouchPhase.ENDED", this._itemRenderer.tapToSelectInternal.isEnabled);
		}
	}
}

import feathers.controls.renderers.DefaultListItemRenderer;
import feathers.utils.touch.TapToSelect;

import starling.display.DisplayObject;

class DefaultListItemRendererWithInternalState extends DefaultListItemRenderer
{
	public function DefaultListItemRendererWithInternalState()
	{
		super();
	}

	public function get tapToSelectInternal():TapToSelect
	{
		return this.tapToSelect;
	}

	public function get currentAccessoryInternal():DisplayObject
	{
		return this.currentAccessory;
	}
}