package feathers.examples.layoutExplorer
{
	import feathers.controls.Drawers;
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.events.FeathersEventType;
	import feathers.examples.layoutExplorer.data.HorizontalLayoutSettings;
	import feathers.examples.layoutExplorer.data.TiledColumnsLayoutSettings;
	import feathers.examples.layoutExplorer.data.TiledRowsLayoutSettings;
	import feathers.examples.layoutExplorer.data.VerticalLayoutSettings;
	import feathers.examples.layoutExplorer.screens.HorizontalLayoutScreen;
	import feathers.examples.layoutExplorer.screens.HorizontalLayoutSettingsScreen;
	import feathers.examples.layoutExplorer.screens.MainMenuScreen;
	import feathers.examples.layoutExplorer.screens.TiledColumnsLayoutScreen;
	import feathers.examples.layoutExplorer.screens.TiledColumnsLayoutSettingsScreen;
	import feathers.examples.layoutExplorer.screens.TiledRowsLayoutScreen;
	import feathers.examples.layoutExplorer.screens.TiledRowsLayoutSettingsScreen;
	import feathers.examples.layoutExplorer.screens.VerticalLayoutScreen;
	import feathers.examples.layoutExplorer.screens.VerticalLayoutSettingsScreen;
	import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
	import feathers.system.DeviceCapabilities;
	import feathers.themes.MetalWorksMobileTheme;

	import starling.core.Starling;
	import starling.events.Event;

	public class Main extends Drawers
	{
		private static const MAIN_MENU:String = "mainMenu";
		private static const HORIZONTAL:String = "horizontal";
		private static const VERTICAL:String = "vertical";
		private static const TILED_ROWS:String = "tiledRows";
		private static const TILED_COLUMNS:String = "tiledColumns";
		private static const HORIZONTAL_SETTINGS:String = "horizontalSettings";
		private static const VERTICAL_SETTINGS:String = "verticalSettings";
		private static const TILED_ROWS_SETTINGS:String = "tiledRowsSettings";
		private static const TILED_COLUMNS_SETTINGS:String = "tiledColumnsSettings";

		private static const MAIN_MENU_EVENTS:Object =
		{
			showHorizontal: HORIZONTAL,
			showVertical: VERTICAL,
			showTiledRows: TILED_ROWS,
			showTiledColumns: TILED_COLUMNS
		}

		public function Main()
		{
			super();
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}

		private var _navigator:ScreenNavigator;
		private var _menu:MainMenuScreen;
		private var _transitionManager:ScreenSlidingStackTransitionManager;

		private function initializeHandler(event:Event):void
		{
			new MetalWorksMobileTheme();

			this._navigator = new ScreenNavigator();
			this.content = this._navigator;

			const horizontalLayoutSettings:HorizontalLayoutSettings = new HorizontalLayoutSettings();
			this._navigator.addScreen(HORIZONTAL, new ScreenNavigatorItem(HorizontalLayoutScreen,
			{
				complete: MAIN_MENU,
				showSettings: HORIZONTAL_SETTINGS
			},
			{
				settings: horizontalLayoutSettings
			}));
			this._navigator.addScreen(HORIZONTAL_SETTINGS, new ScreenNavigatorItem(HorizontalLayoutSettingsScreen,
			{
				complete: HORIZONTAL
			},
			{
				settings: horizontalLayoutSettings
			}));

			const verticalLayoutSettings:VerticalLayoutSettings = new VerticalLayoutSettings();
			this._navigator.addScreen(VERTICAL, new ScreenNavigatorItem(VerticalLayoutScreen,
			{
				complete: MAIN_MENU,
				showSettings: VERTICAL_SETTINGS
			},
			{
				settings: verticalLayoutSettings
			}));
			this._navigator.addScreen(VERTICAL_SETTINGS, new ScreenNavigatorItem(VerticalLayoutSettingsScreen,
			{
				complete: VERTICAL
			},
			{
				settings: verticalLayoutSettings
			}));

			const tiledRowsLayoutSettings:TiledRowsLayoutSettings = new TiledRowsLayoutSettings();
			this._navigator.addScreen(TILED_ROWS, new ScreenNavigatorItem(TiledRowsLayoutScreen,
			{
				complete: MAIN_MENU,
				showSettings: TILED_ROWS_SETTINGS
			},
			{
				settings: tiledRowsLayoutSettings
			}));
			this._navigator.addScreen(TILED_ROWS_SETTINGS, new ScreenNavigatorItem(TiledRowsLayoutSettingsScreen,
			{
				complete: TILED_ROWS
			},
			{
				settings: tiledRowsLayoutSettings
			}));

			const tiledColumnsLayoutSettings:TiledColumnsLayoutSettings = new TiledColumnsLayoutSettings();
			this._navigator.addScreen(TILED_COLUMNS, new ScreenNavigatorItem(TiledColumnsLayoutScreen,
			{
				complete: MAIN_MENU,
				showSettings: TILED_COLUMNS_SETTINGS
			},
			{
				settings: tiledColumnsLayoutSettings
			}));
			this._navigator.addScreen(TILED_COLUMNS_SETTINGS, new ScreenNavigatorItem(TiledColumnsLayoutSettingsScreen,
			{
				complete: TILED_COLUMNS
			},
			{
				settings: tiledColumnsLayoutSettings
			}));

			this._transitionManager = new ScreenSlidingStackTransitionManager(this._navigator);
			this._transitionManager.duration = 0.4;

			if(DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				//we don't want the screens bleeding outside the navigator's
				//bounds when a transition is active, so clip it.
				this._navigator.clipContent = true;
				this._menu = new MainMenuScreen();
				for(var eventType:String in MAIN_MENU_EVENTS)
				{
					this._menu.addEventListener(eventType, mainMenuEventHandler);
				}
				this.leftDrawer = this._menu;
				this.leftDrawerDockMode = Drawers.DOCK_MODE_BOTH;
			}
			else
			{
				this._navigator.addScreen(MAIN_MENU, new ScreenNavigatorItem(MainMenuScreen, MAIN_MENU_EVENTS));
				this._navigator.showScreen(MAIN_MENU);
			}
		}

		private function mainMenuEventHandler(event:Event):void
		{
			const screenName:String = MAIN_MENU_EVENTS[event.type];
			//because we're controlling the navigation externally, it doesn't
			//make sense to transition or keep a history
			this._transitionManager.clearStack();
			this._transitionManager.skipNextTransition = true;
			this._navigator.showScreen(screenName);
		}
	}
}
