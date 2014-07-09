package feathers.examples.displayObjects.screens
{
	import feathers.controls.Button;
	import feathers.controls.Check;
	import feathers.controls.Header;
	import feathers.controls.Screen;
	import feathers.display.Scale3Image;
	import feathers.textures.Scale3Textures;

	import starling.events.Event;

	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	public class Scale3ImageScreen extends Screen
	{
		[Embed(source="/../assets/images/scale3.png")]
		private static const SCALE_3_TEXTURE:Class;

		[Embed(source="/../assets/images/scale3-tile-pattern.png")]
		private static const SCALE_3_TILED_TEXTURE:Class;

		[Embed(source="/../assets/images/scale3-vertical.png")]
		private static const SCALE_3_TEXTURE_VERTICAL:Class;

		[Embed(source="/../assets/images/scale3-tile-pattern-vertical.png")]
		private static const SCALE_3_TILED_TEXTURE_VERTICAL:Class;

		public function Scale3ImageScreen()
		{
		}

		private var _header:Header;
		private var _image:Scale3Image;
		private var _rightButton:Button;
		private var _bottomButton:Button;
		private var _gridCheckbox:Check;
		private var _tiledCheckbox:Check;
		private var _verticalCheckbox:Check;

		private var _minDisplayObjectWidth:Number;
		private var _minDisplayObjectHeight:Number;
		private var _maxDisplayObjectWidth:Number;
		private var _maxDisplayObjectHeight:Number;
		private var _startX:Number;
		private var _startY:Number;
		private var _startWidth:Number;
		private var _startHeight:Number;
		private var _rightTouchPointID:int = -1;
		private var _bottomTouchPointID:int = -1;

		const texture:Texture = Texture.fromBitmap(new SCALE_3_TEXTURE(), false);
		const textures:Scale3Textures = new Scale3Textures(texture, 60, 80, Scale3Textures.DIRECTION_HORIZONTAL);

		const gridTexture:Texture = Texture.fromBitmap(new SCALE_3_TILED_TEXTURE(), false);
		const gridTextures:Scale3Textures = new Scale3Textures(gridTexture, 60, 120, Scale3Textures.DIRECTION_HORIZONTAL);

		const textureVertical:Texture = Texture.fromBitmap(new SCALE_3_TEXTURE_VERTICAL(), false);
		const texturesVertical:Scale3Textures = new Scale3Textures(textureVertical, 60, 80, Scale3Textures.DIRECTION_VERTICAL);

		const gridTextureVertical:Texture = Texture.fromBitmap(new SCALE_3_TILED_TEXTURE_VERTICAL(), false);
		const gridTexturesVertical:Scale3Textures = new Scale3Textures(gridTextureVertical, 60, 120, Scale3Textures.DIRECTION_VERTICAL);

		override protected function initialize():void
		{
			this._header = new Header();
			this._header.title = "Scale 3 Image";
			this.addChild(this._header);

			this._image = new Scale3Image(textures, this.dpiScale);
			this._image.width /= 2;
			this._image.height /= 2;
			this._minDisplayObjectWidth = 20 * this.dpiScale;
			this._minDisplayObjectHeight = 20 * this.dpiScale;
			this.addChild(this._image);

			this._rightButton = new Button();
			this._rightButton.nameList.add("right-grip");
			this._rightButton.addEventListener(TouchEvent.TOUCH, rightButton_touchHandler);
			this.addChild(this._rightButton);

			this._bottomButton = new Button();
			this._bottomButton.nameList.add("bottom-grip");
			this._bottomButton.addEventListener(TouchEvent.TOUCH, bottomButton_touchHandler);
			this.addChild(this._bottomButton);

			this._tiledCheckbox = new Check();
			this._tiledCheckbox.label = "tiled";
			this._tiledCheckbox.addEventListener(Event.CHANGE, onTiledChange);
			this.addChild(this._tiledCheckbox);

			this._gridCheckbox = new Check();
			this._gridCheckbox.label = "show grid";
			this._gridCheckbox.addEventListener(Event.CHANGE, onTextureChange);
			this.addChild(this._gridCheckbox);

			this._verticalCheckbox = new Check();
			this._verticalCheckbox.label = "vertical";
			this._verticalCheckbox.addEventListener(Event.CHANGE, onTextureChange);
			this.addChild(this._verticalCheckbox);
		}

		override protected function draw():void
		{
			this._header.width = this.actualWidth;
			this._header.validate();

			this._image.x = 30 * this.dpiScale;
			this._image.y = this._header.height + 30 * this.dpiScale;

			this._rightButton.validate();
			this._bottomButton.validate();
			this._gridCheckbox.validate();
			this._tiledCheckbox.validate();
			this._verticalCheckbox.validate();

			this._gridCheckbox.x = this.width - 30 * this.dpiScale - this._gridCheckbox.width;
			this._gridCheckbox.y = this._header.height + 30 * this.dpiScale;

			this._tiledCheckbox.x = this._gridCheckbox.x;
			this._tiledCheckbox.y = this._header.height + this._gridCheckbox.height + 60 * this.dpiScale;

			this._verticalCheckbox.x = this._gridCheckbox.x;
			this._verticalCheckbox.y = this._header.height + this._gridCheckbox.height + this._tiledCheckbox.height + 90 * this.dpiScale;

			this._maxDisplayObjectWidth = this.actualWidth - this._rightButton.width - this._image.x;
			this._maxDisplayObjectHeight = this.actualHeight - this._bottomButton.height - this._image.y;

			this._image.width = Math.max(this._minDisplayObjectWidth, Math.min(this._maxDisplayObjectWidth, this._image.width));
			this._image.height = Math.max(this._minDisplayObjectHeight, Math.min(this._maxDisplayObjectHeight, this._image.height));

			this.layoutButtons();
		}

		private function layoutButtons():void
		{
			this._rightButton.x = this._image.x + this._image.width;
			this._rightButton.y = this._image.y + (this._image.height - this._rightButton.height) / 2;

			this._bottomButton.x = this._image.x + (this._image.width - this._bottomButton.width) / 2;
			this._bottomButton.y = this._image.y + this._image.height;
		}

		private function rightButton_touchHandler(event:TouchEvent):void
		{
			const touch:Touch = event.getTouch(this._rightButton);
			if(!touch || (this._rightTouchPointID >= 0 && touch.id != this._rightTouchPointID))
			{
				return;
			}

			if(touch.phase == TouchPhase.BEGAN)
			{
				this._rightTouchPointID = touch.id;
				this._startX = touch.globalX;
				this._startWidth = this._image.width;
			}
			else if(touch.phase == TouchPhase.MOVED)
			{
				this._image.width = Math.min(this._maxDisplayObjectWidth, Math.max(this._minDisplayObjectWidth, this._startWidth + touch.globalX - this._startX));
				this.layoutButtons()
			}
			else if(touch.phase == TouchPhase.ENDED)
			{
				this._rightTouchPointID = -1;
			}
		}

		private function bottomButton_touchHandler(event:TouchEvent):void
		{
			const touch:Touch = event.getTouch(this._bottomButton);
			if(!touch || (this._bottomTouchPointID >= 0 && touch.id != this._bottomTouchPointID))
			{
				return;
			}

			if(touch.phase == TouchPhase.BEGAN)
			{
				this._bottomTouchPointID = touch.id;
				this._startY = touch.globalY;
				this._startHeight = this._image.height;
			}
			else if(touch.phase == TouchPhase.MOVED)
			{
				this._image.height = Math.min(this._maxDisplayObjectHeight, Math.max(this._minDisplayObjectHeight, this._startHeight + touch.globalY - this._startY));
				this.layoutButtons()
			}
			else if(touch.phase == TouchPhase.ENDED)
			{
				this._bottomTouchPointID = -1;
			}
		}

		private function onTiledChange(event:Event):void
		{
			var check:Check = Check(event.currentTarget);
			this._image.isTiled = check.isSelected;
		}

		private function onTextureChange(event:Event):void
		{
			if (_gridCheckbox.isSelected)
			{
				if (_verticalCheckbox.isSelected)
				{
					this._image.textures = gridTexturesVertical;
				}
				else
				{
					this._image.textures = gridTextures;
				}
			}
			else
			{
				if (_verticalCheckbox.isSelected)
				{
					this._image.textures = texturesVertical;
				}
				else
				{
					this._image.textures = textures;
				}
			}
		}
	}
}
