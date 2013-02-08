package feathers.examples.layoutExplorer
{
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
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
	import feathers.themes.MetalWorksMobileTheme;

	import starling.display.Sprite;
	import starling.events.Event;

	public class Main extends Sprite
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

		public function Main()
		{
			super()
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}

		private var _theme:MetalWorksMobileTheme;
		private var _navigator:ScreenNavigator;
		private var _transitionManager:ScreenSlidingStackTransitionManager;

		private function addedToStageHandler(event:Event):void
		{
			this._theme = new MetalWorksMobileTheme(this.stage);

			this._navigator = new ScreenNavigator();
			this.addChild(this._navigator);

			this._navigator.addScreen(MAIN_MENU, new ScreenNavigatorItem(MainMenuScreen,
			{
				showHorizontal: HORIZONTAL,
				showVertical: VERTICAL,
				showTiledRows: TILED_ROWS,
				showTiledColumns: TILED_COLUMNS
			}));

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

			this._navigator.showScreen(MAIN_MENU);

			this._transitionManager = new ScreenSlidingStackTransitionManager(this._navigator);
			this._transitionManager.duration = 0.4;
		}
	}
}
