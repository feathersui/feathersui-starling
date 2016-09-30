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

		private var _texture1:Texture;
		private var _texture2:Texture;
		private var _texture3:Texture;

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

			if(this._texture1 !== null)
			{
				this._texture1.dispose();
				this._texture1 = null;
			}

			if(this._texture2 !== null)
			{
				this._texture2.dispose();
				this._texture2 = null;
			}

			if(this._texture3 !== null)
			{
				this._texture3.dispose();
				this._texture3 = null;
			}

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
			this._texture1 = Texture.fromColor(10, 10, 0xff00ff);
			this._skin.defaultTexture = this._texture1;
			this._texture2 = Texture.fromColor(10, 10, 0xff0000);
			this._skin.setTextureForState(STATE_ONE, this._texture2);
			this._texture3 = Texture.fromColor(10, 10, 0x00ff00);
			this._skin.setTextureForState(STATE_TWO, this._texture3);

			Assert.assertStrictlyEquals("ImageSkin getTextureForState(STATE_ONE) does not match value passed to setTextureForState()", this._texture2, this._skin.getTextureForState(STATE_ONE));
			Assert.assertStrictlyEquals("ImageSkin getTextureForState(STATE_TWO) does not match value passed to setTextureForState()", this._texture3, this._skin.getTextureForState(STATE_TWO));
		}

		[Test]
		public function testDefaultTexture():void
		{
			this._texture1 = Texture.fromColor(10, 10, 0xff00ff);
			this._skin.defaultTexture = this._texture1;

			Assert.assertStrictlyEquals("ImageSkin texture is not defaultTexture when texture not provided for current state", this._texture1, this._skin.texture);

			this._context.isEnabled = false;
			Assert.assertStrictlyEquals("ImageSkin texture is not defaultTexture when disabled texture not provided", this._texture1, this._skin.texture);

			this._context.isEnabled = true;

			this._context.currentState = STATE_ONE;
			Assert.assertStrictlyEquals("ImageSkin texture is not defaultTexture when texture not provided for specific state", this._texture1, this._skin.texture);

			this._context.currentState = STATE_TWO;
			Assert.assertStrictlyEquals("ImageSkin texture is not defaultTexture when texture not provided for specific state", this._texture1, this._skin.texture);
		}

		[Test]
		public function testCurrentTextureWithSetTextureForState():void
		{
			this._texture1 = Texture.fromColor(10, 10, 0xff00ff);
			this._skin.defaultTexture = this._texture1;
			this._texture2 = Texture.fromColor(10, 10, 0xff0000);
			this._skin.setTextureForState(STATE_ONE, this._texture2);
			this._texture3 = Texture.fromColor(10, 10, 0x00ff00);
			this._skin.setTextureForState(STATE_TWO, this._texture3);

			this._context.currentState = STATE_ONE;
			Assert.assertStrictlyEquals("ImageSkin texture is does not match texture passed to setTextureForState() for current state", this._texture2, this._skin.texture);

			this._context.currentState = STATE_TWO;
			Assert.assertStrictlyEquals("ImageSkin texture is does not match texture passed to setTextureForState() for current state", this._texture3, this._skin.texture);
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

		[Test]
		public function testClearExplicitDimensions():void
		{
			var textureWidth:Number = 150;
			var textureHeight:Number = 200;
			var explicitWidth:Number = 250;
			var explicitHeight:Number = 300;
			this._texture1 = Texture.fromColor(textureWidth, textureHeight, 0xff00ff);
			this._skin.defaultTexture = this._texture1;
			this._skin.width = explicitWidth;
			this._skin.height = explicitHeight;

			Assert.assertStrictlyEquals("ImageSkin width is does not match explicit width",
				explicitWidth, this._skin.width);
			Assert.assertStrictlyEquals("ImageSkin width is does not match explicit height",
				explicitHeight, this._skin.height);

			this._skin.width = NaN;
			this._skin.height = NaN;

			Assert.assertStrictlyEquals("ImageSkin width is does not match texture width",
				textureWidth, this._skin.width);
			Assert.assertStrictlyEquals("ImageSkin width is does not match texture height",
				textureHeight, this._skin.height);
		}
	}
}

import feathers.core.FeathersControl;
import feathers.core.IStateContext;
import feathers.events.FeathersEventType;

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