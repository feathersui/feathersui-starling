package feathers.tests
{
	import feathers.skins.ImageSkin;

	import org.flexunit.Assert;

	import starling.textures.Texture;

	public class ImageSkinTests
	{
		private static const STATE_ONE:String = "one";
		private static const STATE_TWO:String = "two";

		private static const DEFAULT_COLOR:uint = 0xcccccc;
		private static const COLOR_ONE:uint = 0x999999;
		private static const COLOR_TWO:uint = 0x666666;
		
		private var _skin:ImageSkin;
		private var _context:StateContext;

		[Before]
		public function prepare():void
		{
			this._context = new StateContext();
			this._context.currentState = STATE_ONE;
			TestFeathers.starlingRoot.addChild(this._context);
			
			this._skin = new ImageSkin(null);
			this._context.addChild(this._skin);
			this._skin.stateContext = this._context;
		}

		[After]
		public function cleanup():void
		{
			this._context.removeFromParent(true);
			this._context = null;
			this._skin = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testGetTextureForStateWithoutSetTextureForState():void
		{
			Assert.assertNull("ImageSkin getTextureForState(STATE_ONE) must be null when setTextureForState() is not called", this._skin.getTextureForState(STATE_ONE));
			Assert.assertNull("ImageSkin getTextureForState(STATE_TWO) must be null when setTextureForState() is not called", this._skin.getTextureForState(STATE_TWO));
		}

		[Test]
		public function testDefaultTextureWithNoStateTextures():void
		{
			Assert.assertStrictlyEquals("ImageSkin texture must be null when defaultTexture and setTextureForState() are not used", null, this._skin.texture);
		}

		[Test]
		public function testGetTextureForState():void
		{
			var defaultTexture:Texture = Texture.fromColor(10, 10, 0xff00ff);
			this._skin.defaultTexture = defaultTexture;
			var textureOne:Texture = Texture.fromColor(10, 10, 0xff0000);
			this._skin.setTextureForState(STATE_ONE, textureOne);
			var textureTwo:Texture = Texture.fromColor(10, 10, 0x00ff00);
			this._skin.setTextureForState(STATE_TWO, textureTwo);

			Assert.assertStrictlyEquals("ImageSkin getTextureForState(STATE_ONE) does not match value passed to setTextureForState()", textureOne, this._skin.getTextureForState(STATE_ONE));
			Assert.assertStrictlyEquals("ImageSkin getTextureForState(STATE_TWO) does not match value passed to setTextureForState()", textureTwo, this._skin.getTextureForState(STATE_TWO));

			defaultTexture.dispose();
			textureOne.dispose();
			textureTwo.dispose();
		}

		[Test]
		public function testDefaultTexture():void
		{
			var defaultTexture:Texture = Texture.fromColor(10, 10, 0xff00ff);
			this._skin.defaultTexture = defaultTexture;

			Assert.assertStrictlyEquals("ImageSkin texture is not defaultTexture when texture not provided for current state", defaultTexture, this._skin.texture);

			this._context.isEnabled = false;
			Assert.assertStrictlyEquals("ImageSkin texture is not defaultTexture when disabled texture not provided", defaultTexture, this._skin.texture);

			this._context.isEnabled = true;

			this._context.currentState = STATE_ONE;
			Assert.assertStrictlyEquals("ImageSkin texture is not defaultTexture when texture not provided for specific state", defaultTexture, this._skin.texture);

			this._context.currentState = STATE_TWO;
			Assert.assertStrictlyEquals("ImageSkin texture is not defaultTexture when texture not provided for specific state", defaultTexture, this._skin.texture);
		}

		[Test]
		public function testCurrentTextureWithSetTextureForState():void
		{
			var defaultTexture:Texture = Texture.fromColor(10, 10, 0xff00ff);
			this._skin.defaultTexture = defaultTexture;
			var textureOne:Texture = Texture.fromColor(10, 10, 0xff0000);
			this._skin.setTextureForState(STATE_ONE, textureOne);
			var textureTwo:Texture = Texture.fromColor(10, 10, 0x00ff00);
			this._skin.setTextureForState(STATE_TWO, textureTwo);

			this._context.currentState = STATE_ONE;
			Assert.assertStrictlyEquals("ImageSkin texture is does not match texture passed to setTextureForState() for current state", textureOne, this._skin.texture);

			this._context.currentState = STATE_TWO;
			Assert.assertStrictlyEquals("ImageSkin texture is does not match texture passed to setTextureForState() for current state", textureTwo, this._skin.texture);

			defaultTexture.dispose();
			textureOne.dispose();
			textureTwo.dispose();
		}

		[Test]
		public function testGetColorForStateWithoutSetColorForState():void
		{
			Assert.assertStrictlyEquals("ImageSkin getColorForState(STATE_ONE) must be uint.MAX_VALUE when setColorForState() is not called", uint.MAX_VALUE, this._skin.getColorForState(STATE_ONE));
			Assert.assertStrictlyEquals("ImageSkin getColorForState(STATE_TWO) must be uint.MAX_VALUE when setColorForState() is not called", uint.MAX_VALUE, this._skin.getColorForState(STATE_TWO));
		}

		[Test]
		public function testDefaultColorWithNoStateColors():void
		{
			Assert.assertStrictlyEquals("ImageSkin color must be 0xffffff when defaultColor and setColorForState() are not used", 0xffffff, this._skin.color);
		}

		[Test]
		public function testGetColorForState():void
		{
			this._skin.defaultColor = DEFAULT_COLOR;
			this._skin.setColorForState(STATE_ONE, COLOR_ONE);
			this._skin.setColorForState(STATE_TWO, COLOR_TWO);

			Assert.assertStrictlyEquals("ImageSkin getColorForState(STATE_ONE) does not match value passed to setColorForState()", COLOR_ONE, this._skin.getColorForState(STATE_ONE));
			Assert.assertStrictlyEquals("ImageSkin getColorForState(STATE_TWO) does not match value passed to setColorForState()", COLOR_TWO, this._skin.getColorForState(STATE_TWO));
		}

		[Test]
		public function testDefaultColor():void
		{
			this._skin.defaultColor = DEFAULT_COLOR;

			Assert.assertStrictlyEquals("ImageSkin color is not defaultColor when color not provided for current state", DEFAULT_COLOR, this._skin.color);

			this._context.isEnabled = false;
			Assert.assertStrictlyEquals("ImageSkin color is not defaultColor when disabled color not provided", DEFAULT_COLOR, this._skin.color);

			this._context.isEnabled = true;

			this._context.currentState = STATE_ONE;
			Assert.assertStrictlyEquals("ImageSkin color is not defaultColor when color not provided for specific state", DEFAULT_COLOR, this._skin.color);

			this._context.currentState = STATE_TWO;
			Assert.assertStrictlyEquals("ImageSkin color is not defaultColor when color not provided for specific state", DEFAULT_COLOR, this._skin.color);
		}

		[Test]
		public function testCurrentColorWithSetColorForState():void
		{
			this._skin.defaultColor = DEFAULT_COLOR;
			this._skin.setColorForState(STATE_ONE, COLOR_ONE);
			this._skin.setColorForState(STATE_TWO, COLOR_TWO);

			this._context.currentState = STATE_ONE;
			Assert.assertStrictlyEquals("ImageSkin color is does not match color passed to setColorForState() for current state", COLOR_ONE, this._skin.color);

			this._context.currentState = STATE_TWO;
			Assert.assertStrictlyEquals("ImageSkin color is does not match color passed to setColorForState() for current state", COLOR_TWO, this._skin.color);
		}
	}
}

import feathers.core.FeathersControl;
import feathers.core.IStateContext;
import feathers.events.FeathersEventType;

import starling.events.EventDispatcher;

class StateContext extends FeathersControl implements IStateContext
{
	public function StateContext()
	{
		super();
	}
	
	protected var _currentState:String;
	
	public function get currentState():String
	{
		return this._currentState;
	}

	public function set currentState(value:String):void
	{
		if(this._currentState === value)
		{
			return;
		}
		this._currentState = value;
		this.dispatchEventWith(FeathersEventType.STATE_CHANGE);
	}
}