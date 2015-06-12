package feathers.examples.displayObjects
{
	import feathers.controls.LayoutGroup;
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.TabBar;
	import feathers.data.ListCollection;
	import feathers.examples.displayObjects.screens.Scale3ImageScreen;
	import feathers.examples.displayObjects.screens.Scale9ImageScreen;
	import feathers.examples.displayObjects.screens.TiledImageScreen;
	import feathers.examples.displayObjects.themes.DisplayObjectExplorerTheme;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.motion.transitions.TabBarSlideTransitionManager;

	import starling.events.Event;

	public class Main extends LayoutGroup
	{
		private static const SCALE_9_IMAGE:String = "scale9Image";
		private static const SCALE_3_IMAGE:String = "scale3Image";
		private static const TILED_IMAGE:String = "tiledImage";

		public function Main()
		{
			//set up the theme right away!
			new DisplayObjectExplorerTheme();
			super();
		}

		private var _navigator:ScreenNavigator;
		private var _tabBar:TabBar;
		private var _transitionManager:TabBarSlideTransitionManager;

		override protected function initialize():void
		{
			super.initialize();
			
			this.autoSizeMode = LayoutGroup.AUTO_SIZE_MODE_STAGE;
			this.layout = new AnchorLayout();

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

		private function navigator_changeHandler(event:Event):void
		{
			var dataProvider:ListCollection = this._tabBar.dataProvider;
			var itemCount:int = dataProvider.length;
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
	}
}
