package feathers.examples.displayObjects.screens
{
	import flash.geom.Rectangle;

	import feathers.display.Scale9Image;
	import feathers.controls.Button;
	import feathers.controls.Screen;
	import feathers.controls.Header;
	import feathers.textures.Scale9Textures;

	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	public class Scale9ImageScreen extends Screen
	{
		[Embed(source="/../assets/images/scale9.png")]
		private static const SCALE_9_TEXTURE:Class;

		public function Scale9ImageScreen()
		{
		}

		private var _header:Header;
		private var _image:Scale9Image;
		private var _rightButton:Button;
		private var _bottomButton:Button;

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

		override protected function initialize():void
		{
			this._header = new Header();
			this._header.title = "Scale 9 Image";
			this.addChild(this._header);

			const texture:Texture = Texture.fromBitmap(new SCALE_9_TEXTURE(), false);
			const textures:Scale9Textures = new Scale9Textures(texture, new Rectangle(20, 20, 20, 20));
			this._image = new Scale9Image(textures, this.dpiScale);
			this._minDisplayObjectWidth = 40;
			this._minDisplayObjectHeight = 40;
			this.addChild(this._image);

			this._rightButton = new Button();
			this._rightButton.nameList.add("right-grip");
			this._rightButton.addEventListener(TouchEvent.TOUCH, rightButton_touchHandler);
			this.addChild(this._rightButton);

			this._bottomButton = new Button();
			this._bottomButton.nameList.add("bottom-grip");
			this._bottomButton.addEventListener(TouchEvent.TOUCH, bottomButton_touchHandler);
			this.addChild(this._bottomButton);
		}

		override protected function draw():void
		{
			this._header.width = this.actualWidth;
			this._header.validate();

			this._image.x = 30 * this.dpiScale;
			this._image.y = this._header.height + 30 * this.dpiScale;

			this._rightButton.validate();
			this._bottomButton.validate();

			this._maxDisplayObjectWidth = this.actualWidth - this._rightButton.width - this._image.x;
			this._maxDisplayObjectHeight = this.actualHeight - this._bottomButton.height - this._image.y - this._header.height;

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
	}
}
