package feathers.examples.displayObjects.screens
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.PanelScreen;
	import feathers.controls.Screen;
	import feathers.display.TiledImage;
	import feathers.examples.displayObjects.themes.DisplayObjectExplorerTheme;
	import feathers.skins.IStyleProvider;

	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	public class TiledImageScreen extends PanelScreen
	{
		[Embed(source="/../assets/images/tile-pattern.png")]
		private static const TILE_TEXTURE:Class;

		public static var globalStyleProvider:IStyleProvider;

		public function TiledImageScreen()
		{
		}

		private var _image:TiledImage;
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

		private var _texture:Texture;

		override protected function get defaultStyleProvider():IStyleProvider
		{
			return TiledImageScreen.globalStyleProvider;
		}

		override public function dispose():void
		{
			if(this._texture)
			{
				this._texture.dispose();
				this._texture = null;
			}
			super.dispose();
		}

		override protected function initialize():void
		{
			super.initialize();
			
			this.title = "Tiled Image";
			
			this._texture = Texture.fromEmbeddedAsset(TILE_TEXTURE);

			this._image = new TiledImage(this._texture);
			this._minDisplayObjectWidth = this._image.width;
			this._minDisplayObjectHeight = this._image.height;
			this.addChild(this._image);

			this._rightButton = new Button();
			this._rightButton.styleNameList.add(DisplayObjectExplorerTheme.THEME_NAME_RIGHT_GRIP);
			this._rightButton.addEventListener(TouchEvent.TOUCH, rightButton_touchHandler);
			this.addChild(this._rightButton);

			this._bottomButton = new Button();
			this._bottomButton.styleNameList.add(DisplayObjectExplorerTheme.THEME_NAME_BOTTOM_GRIP);
			this._bottomButton.addEventListener(TouchEvent.TOUCH, bottomButton_touchHandler);
			this.addChild(this._bottomButton);
		}

		override protected function layoutChildren():void
		{
			super.layoutChildren();

			this._rightButton.validate();
			this._bottomButton.validate();

			this._maxDisplayObjectWidth = this.actualWidth - this._paddingLeft - this._rightButton.width - this._image.x;
			this._maxDisplayObjectHeight = this.actualHeight - this.header.height - this._paddingTop - this._bottomButton.height - this._image.y;

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
			var touch:Touch = event.getTouch(this._rightButton);
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
			var touch:Touch = event.getTouch(this._bottomButton);
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
