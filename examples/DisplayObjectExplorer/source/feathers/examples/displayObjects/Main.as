package feathers.examples.displayObjects
{
	import feathers.controls.Button;
	import feathers.controls.LayoutGroup;
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.TabBar;
	import feathers.data.ListCollection;
	import feathers.examples.displayObjects.screens.Scale3ImageScreen;
	import feathers.examples.displayObjects.screens.Scale9ImageScreen;
	import feathers.examples.displayObjects.screens.TiledImageScreen;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.motion.transitions.TabBarSlideTransitionManager;
	import feathers.system.DeviceCapabilities;
	import feathers.themes.MetalWorksMobileTheme;

	import starling.display.Image;
	import starling.events.Event;
	import starling.events.ResizeEvent;
	import starling.textures.Texture;

	public class Main extends LayoutGroup
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
		}

		private var _theme:MetalWorksMobileTheme;
		private var _navigator:ScreenNavigator;
		private var _tabBar:TabBar;
		private var _transitionManager:TabBarSlideTransitionManager;

		private var _rightGripTexture:Texture = Texture.fromBitmap(new VERTICAL_GRIP(), false);
		private var _bottomGripTexture:Texture = Texture.fromBitmap(new HORIZONTAL_GRIP(), false);

		override protected function initialize():void
		{
			super.initialize();

			this.layout = new AnchorLayout();

			this.setSize(this.stage.stageWidth, this.stage.stageHeight);

			this.stage.addEventListener(ResizeEvent.RESIZE, stage_resizeHandler);

			this._theme = new MetalWorksMobileTheme();
			this._theme.setInitializerForClass(Button, rightGripInitializer, "right-grip");
			this._theme.setInitializerForClass(Button, bottomGripInitializer, "bottom-grip");

			this._navigator = new ScreenNavigator();
			this._navigator.addScreen(SCALE_9_IMAGE, new ScreenNavigatorItem(Scale9ImageScreen));
			this._navigator.addScreen(SCALE_3_IMAGE, new ScreenNavigatorItem(Scale3ImageScreen));
			this._navigator.addScreen(TILED_IMAGE, new ScreenNavigatorItem(TiledImageScreen));
			this._navigator.addEventListener(Event.CHANGE, navigator_changeHandler);
			this.addChild(this._navigator);

			this._tabBar = new TabBar();
			this._tabBar.addEventListener(Event.CHANGE, tabBar_changeHandler);
			this.addChild(this._tabBar);
			this._tabBar.dataProvider = new ListCollection(
			[
				{ label: "Scale 9", action: SCALE_9_IMAGE },
				{ label: "Scale 3", action: SCALE_3_IMAGE },
				{ label: "Tiled", action: TILED_IMAGE }
			]);

			var tabBarLayoutData:AnchorLayoutData = new AnchorLayoutData();
			tabBarLayoutData.right = 0;
			tabBarLayoutData.bottom = 0;
			tabBarLayoutData.left = 0;
			this._tabBar.layoutData = tabBarLayoutData;

			var navigatorLayoutData:AnchorLayoutData = new AnchorLayoutData();
			navigatorLayoutData.top = 0;
			navigatorLayoutData.right = 0;
			navigatorLayoutData.bottom = 0;
			navigatorLayoutData.left = 0;
			navigatorLayoutData.bottomAnchorDisplayObject = this._tabBar;
			this._navigator.layoutData = navigatorLayoutData;

			this._navigator.showScreen(SCALE_9_IMAGE);

			this._transitionManager = new TabBarSlideTransitionManager(this._navigator, this._tabBar);
			this._transitionManager.duration = 0.4;
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

		private function navigator_changeHandler(event:Event):void
		{
			const dataProvider:ListCollection = this._tabBar.dataProvider;
			const itemCount:int = dataProvider.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:Object = dataProvider.getItemAt(i);
				if(this._navigator.activeScreenID == item.action)
				{
					this._tabBar.selectedIndex = i;
					break;
				}
			}
		}

		private function tabBar_changeHandler(event:Event):void
		{
			this._navigator.showScreen(this._tabBar.selectedItem.action);
		}

		private function stage_resizeHandler(event:ResizeEvent):void
		{
			this.setSize(this.stage.stageWidth, this.stage.stageHeight);
		}
	}
}
