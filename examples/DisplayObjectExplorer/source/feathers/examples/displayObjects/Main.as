package feathers.examples.displayObjects
{
	import feathers.controls.Button;
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.TabBar;
	import feathers.data.ListCollection;
	import feathers.examples.displayObjects.screens.Scale3ImageScreen;
	import feathers.examples.displayObjects.screens.Scale9ImageScreen;
	import feathers.examples.displayObjects.screens.TiledImageScreen;
	import feathers.motion.transitions.TabBarSlideTransitionManager;
	import feathers.system.DeviceCapabilities;
	import feathers.themes.MetalWorksMobileTheme;

	import starling.display.Image;
	import starling.events.Event;
	import starling.events.ResizeEvent;
	import starling.textures.Texture;

	public class Main extends ScreenNavigator
	{
		private static const SCALE_9_IMAGE:String = "scale9Image";
		private static const SCALE_3_IMAGE:String = "scale3Image";
		private static const TILED_IMAGE:String = "tiledImage";

		[Embed(source="/../assets/images/horizontal-grip.png")]
		private static const HORIZONTAL_GRIP:Class;

		[Embed(source="/../assets/images/vertical-grip.png")]
		private static const VERTICAL_GRIP:Class;

		public function Main()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}

		private var _theme:MetalWorksMobileTheme;
		private var _tabBar:TabBar;
		private var _transitionManager:TabBarSlideTransitionManager;

		private var _rightGripTexture:Texture = Texture.fromBitmap(new VERTICAL_GRIP(), false);
		private var _bottomGripTexture:Texture = Texture.fromBitmap(new HORIZONTAL_GRIP(), false);

		private function layout(w:Number, h:Number):void
		{
			this._tabBar.width = w;
			this._tabBar.x = (w - this._tabBar.width) / 2;
			this._tabBar.y = h - this._tabBar.height;
		}

		private function rightGripInitializer(button:Button):void
		{
			const rightSkin:Image = new Image(this._rightGripTexture);
			rightSkin.scaleX = rightSkin.scaleY = DeviceCapabilities.dpi / this._theme.originalDPI;
			button.defaultSkin = rightSkin;
		}

		private function bottomGripInitializer(button:Button):void
		{
			const bottomSkin:Image = new Image(this._bottomGripTexture);
			bottomSkin.scaleX = bottomSkin.scaleY = DeviceCapabilities.dpi / this._theme.originalDPI;
			button.defaultSkin = bottomSkin;
		}

		private function addedToStageHandler(event:Event):void
		{
			this.stage.addEventListener(ResizeEvent.RESIZE, stage_resizeHandler);

			this._theme = new MetalWorksMobileTheme();
			this._theme.setInitializerForClass(Button, rightGripInitializer, "right-grip");
			this._theme.setInitializerForClass(Button, bottomGripInitializer, "bottom-grip");

			this.addEventListener(Event.CHANGE, navigator_changeHandler);

			this.addScreen(SCALE_9_IMAGE, new ScreenNavigatorItem(Scale9ImageScreen));

			this.addScreen(SCALE_3_IMAGE, new ScreenNavigatorItem(Scale3ImageScreen));

			this.addScreen(TILED_IMAGE, new ScreenNavigatorItem(TiledImageScreen));

			this._tabBar = new TabBar();
			this._tabBar.addEventListener(Event.CHANGE, tabBar_changeHandler);
			this.addChild(this._tabBar);
			this._tabBar.dataProvider = new ListCollection(
			[
				{ label: "Scale 9", action: SCALE_9_IMAGE },
				{ label: "Scale 3", action: SCALE_3_IMAGE },
				{ label: "Tiled", action: TILED_IMAGE }
			]);
			this._tabBar.validate();
			this.layout(this.stage.stageWidth, this.stage.stageHeight);

			this.showScreen(SCALE_9_IMAGE);

			this._transitionManager = new TabBarSlideTransitionManager(this, this._tabBar);
			this._transitionManager.duration = 0.4;
		}

		private function navigator_changeHandler(event:Event):void
		{
			const dataProvider:ListCollection = this._tabBar.dataProvider;
			const itemCount:int = dataProvider.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:Object = dataProvider.getItemAt(i);
				if(this.activeScreenID == item.action)
				{
					this._tabBar.selectedIndex = i;
					break;
				}
			}
		}

		private function tabBar_changeHandler(event:Event):void
		{
			this.showScreen(this._tabBar.selectedItem.action);
		}

		private function stage_resizeHandler(event:ResizeEvent):void
		{
			this.layout(event.width, event.height);
		}
	}
}
