package feathers.examples.layoutExplorer
{
	import feathers.controls.Drawers;
	import feathers.controls.StackScreenNavigator;
	import feathers.controls.StackScreenNavigatorItem;
	import feathers.examples.layoutExplorer.data.HorizontalLayoutSettings;
	import feathers.examples.layoutExplorer.data.TiledColumnsLayoutSettings;
	import feathers.examples.layoutExplorer.data.TiledRowsLayoutSettings;
	import feathers.examples.layoutExplorer.data.VerticalLayoutSettings;
	import feathers.examples.layoutExplorer.screens.AnchorLayoutScreen;
	import feathers.examples.layoutExplorer.screens.HorizontalLayoutScreen;
	import feathers.examples.layoutExplorer.screens.HorizontalLayoutSettingsScreen;
	import feathers.examples.layoutExplorer.screens.MainMenuScreen;
	import feathers.examples.layoutExplorer.screens.TiledColumnsLayoutScreen;
	import feathers.examples.layoutExplorer.screens.TiledColumnsLayoutSettingsScreen;
	import feathers.examples.layoutExplorer.screens.TiledRowsLayoutScreen;
	import feathers.examples.layoutExplorer.screens.TiledRowsLayoutSettingsScreen;
	import feathers.examples.layoutExplorer.screens.VerticalLayoutScreen;
	import feathers.examples.layoutExplorer.screens.VerticalLayoutSettingsScreen;
	import feathers.motion.transitions.Slide;
	import feathers.system.DeviceCapabilities;
	import feathers.themes.MetalWorksMobileTheme;

	import starling.core.Starling;
	import starling.events.Event;

	public class Main extends Drawers
	{
		private static const MAIN_MENU:String = "mainMenu";
		private static const ANCHOR:String = "anchor";
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
			showAnchor: ANCHOR,
			showHorizontal: HORIZONTAL,
			showVertical: VERTICAL,
			showTiledRows: TILED_ROWS,
			showTiledColumns: TILED_COLUMNS
		}

		public function Main()
		{
			super();
		}

		private var _navigator:StackScreenNavigator;
		private var _menu:MainMenuScreen;

		override protected function initialize():void
		{
			//never forget to call super.initialize()
			super.initialize();

			new MetalWorksMobileTheme();

			this._navigator = new StackScreenNavigator();
			//we're using Drawers because we want to display the menu on the
			//side when running on tablets.
			this.content = this._navigator;

			this._navigator.addScreen(ANCHOR, new StackScreenNavigatorItem(AnchorLayoutScreen,
				null, Event.COMPLETE));

			var horizontalLayoutSettings:HorizontalLayoutSettings = new HorizontalLayoutSettings();
			this._navigator.addScreen(HORIZONTAL, new StackScreenNavigatorItem(HorizontalLayoutScreen,
			{
				showSettings: HORIZONTAL_SETTINGS
			}, Event.COMPLETE,
			{
				settings: horizontalLayoutSettings
			}));
			this._navigator.addScreen(HORIZONTAL_SETTINGS, new StackScreenNavigatorItem(HorizontalLayoutSettingsScreen, null, Event.COMPLETE,
			{
				settings: horizontalLayoutSettings
			}));

			var verticalLayoutSettings:VerticalLayoutSettings = new VerticalLayoutSettings();
			this._navigator.addScreen(VERTICAL, new StackScreenNavigatorItem(VerticalLayoutScreen,
			{
				showSettings: VERTICAL_SETTINGS
			}, Event.COMPLETE,
			{
				settings: verticalLayoutSettings
			}));
			this._navigator.addScreen(VERTICAL_SETTINGS, new StackScreenNavigatorItem(VerticalLayoutSettingsScreen, null, Event.COMPLETE,
			{
				settings: verticalLayoutSettings
			}));

			var tiledRowsLayoutSettings:TiledRowsLayoutSettings = new TiledRowsLayoutSettings();
			this._navigator.addScreen(TILED_ROWS, new StackScreenNavigatorItem(TiledRowsLayoutScreen,
			{
				showSettings: TILED_ROWS_SETTINGS
			}, Event.COMPLETE,
			{
				settings: tiledRowsLayoutSettings
			}));
			this._navigator.addScreen(TILED_ROWS_SETTINGS, new StackScreenNavigatorItem(TiledRowsLayoutSettingsScreen, null, Event.COMPLETE,
			{
				settings: tiledRowsLayoutSettings
			}));

			var tiledColumnsLayoutSettings:TiledColumnsLayoutSettings = new TiledColumnsLayoutSettings();
			this._navigator.addScreen(TILED_COLUMNS, new StackScreenNavigatorItem(TiledColumnsLayoutScreen,
			{
				showSettings: TILED_COLUMNS_SETTINGS
			}, Event.COMPLETE,
			{
				settings: tiledColumnsLayoutSettings
			}));
			this._navigator.addScreen(TILED_COLUMNS_SETTINGS, new StackScreenNavigatorItem(TiledColumnsLayoutSettingsScreen, null, Event.COMPLETE,
			{
				settings: tiledColumnsLayoutSettings
			}));

			if(DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				//we don't want the screens bleeding outside the navigator's
				//bounds on top of a drawer when a transition is active, so
				//enable clipping.
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
				this._navigator.addScreen(MAIN_MENU, new StackScreenNavigatorItem(MainMenuScreen, MAIN_MENU_EVENTS));
				this._navigator.rootScreen = MAIN_MENU;
			}

			this._navigator.pushTransition = Slide.createSlideLeftTransition();
			this._navigator.popTransition = Slide.createSlideRightTransition();
		}

		private function mainMenuEventHandler(event:Event):void
		{
			var screenName:String = MAIN_MENU_EVENTS[event.type];
			//since this navigation is triggered by an external menu, we don't
			//want to push a new screen onto the stack. we want to start fresh.
			this._navigator.rootScreen = screenName;
		}
	}
}
