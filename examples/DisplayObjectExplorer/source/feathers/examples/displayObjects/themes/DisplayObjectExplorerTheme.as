package feathers.examples.displayObjects.themes
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.PanelScreen;
	import feathers.examples.displayObjects.screens.Scale3ImageScreen;
	import feathers.examples.displayObjects.screens.Scale9ImageScreen;
	import feathers.examples.displayObjects.screens.TiledImageScreen;
	import feathers.themes.MetalWorksMobileTheme;

	import starling.display.Image;
	import starling.textures.Texture;

	public class DisplayObjectExplorerTheme extends MetalWorksMobileTheme
	{
		[Embed(source="/../assets/images/horizontal-grip.png")]
		private static const HORIZONTAL_GRIP:Class;

		[Embed(source="/../assets/images/vertical-grip.png")]
		private static const VERTICAL_GRIP:Class;

		public static const THEME_NAME_RIGHT_GRIP:String = "right-grip";
		public static const THEME_NAME_BOTTOM_GRIP:String = "bottom-grip";

		public function DisplayObjectExplorerTheme()
		{
			super();
		}

		private var _rightGripTexture:Texture;
		private var _bottomGripTexture:Texture;

		override protected function initializeTextures():void
		{
			super.initializeTextures();
			this._rightGripTexture = Texture.fromEmbeddedAsset(VERTICAL_GRIP, false);
			this._bottomGripTexture = Texture.fromEmbeddedAsset(HORIZONTAL_GRIP, false);
		}

		override protected function initializeStyleProviders():void
		{
			super.initializeStyleProviders();
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_RIGHT_GRIP, setRightGripStyles);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(THEME_NAME_BOTTOM_GRIP, setBottomGripStyles);
			this.getStyleProviderForClass(Scale9ImageScreen).defaultStyleFunction = setScale9ImageScreenStyles;
			this.getStyleProviderForClass(Scale3ImageScreen).defaultStyleFunction = setScale3ImageScreenStyles;
			this.getStyleProviderForClass(TiledImageScreen).defaultStyleFunction = setTiledImageScreenStyles;
		}

		private function setRightGripStyles(button:Button):void
		{
			var rightSkin:Image = new Image(this._rightGripTexture);
			rightSkin.scaleX = rightSkin.scaleY = this.scale;
			button.defaultSkin = rightSkin;
		}

		private function setBottomGripStyles(button:Button):void
		{
			var bottomSkin:Image = new Image(this._bottomGripTexture);
			bottomSkin.scaleX = bottomSkin.scaleY = this.scale;
			button.defaultSkin = bottomSkin;
		}

		private function setScale9ImageScreenStyles(screen:Scale9ImageScreen):void
		{
			screen.horizontalScrollPolicy = PanelScreen.SCROLL_POLICY_OFF;
			screen.verticalScrollPolicy = PanelScreen.SCROLL_POLICY_OFF;
			screen.padding = 30 * this.scale;
		}

		private function setScale3ImageScreenStyles(screen:Scale3ImageScreen):void
		{
			screen.horizontalScrollPolicy = PanelScreen.SCROLL_POLICY_OFF;
			screen.verticalScrollPolicy = PanelScreen.SCROLL_POLICY_OFF;
			screen.padding = 30 * this.scale;
		}

		private function setTiledImageScreenStyles(screen:TiledImageScreen):void
		{
			screen.horizontalScrollPolicy = PanelScreen.SCROLL_POLICY_OFF;
			screen.verticalScrollPolicy = PanelScreen.SCROLL_POLICY_OFF;
			screen.padding = 30 * this.scale;
		}
	}
}
