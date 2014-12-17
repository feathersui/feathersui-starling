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
	import feathers.motion.transitions.Cover;
	import feathers.motion.transitions.Reveal;
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
		};

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

			var anchorItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(AnchorLayoutScreen);
			anchorItem.addPopEvent(Event.COMPLETE);
			this._navigator.addScreen(ANCHOR, anchorItem);

			var horizontalLayoutSettings:HorizontalLayoutSettings = new HorizontalLayoutSettings();
			var horizontalItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(HorizontalLayoutScreen);
			horizontalItem.setScreenIDForPushEvent(HorizontalLayoutScreen.SHOW_SETTINGS, HORIZONTAL_SETTINGS);
			horizontalItem.addPopEvent(Event.COMPLETE);
			horizontalItem.properties.settings = horizontalLayoutSettings;
			this._navigator.addScreen(HORIZONTAL, horizontalItem);

			var horizontalSettingsItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(HorizontalLayoutSettingsScreen);
			horizontalSettingsItem.addPopEvent(Event.COMPLETE);
			horizontalSettingsItem.properties.settings = horizontalLayoutSettings;
			horizontalSettingsItem.pushTransition = Cover.createCoverUpTransition();
			horizontalSettingsItem.popTransition = Reveal.createRevealDownTransition();
			this._navigator.addScreen(HORIZONTAL_SETTINGS, horizontalSettingsItem);

			var verticalLayoutSettings:VerticalLayoutSettings = new VerticalLayoutSettings();
			var verticalItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(VerticalLayoutScreen);
			verticalItem.setScreenIDForPushEvent(VerticalLayoutScreen.SHOW_SETTINGS, VERTICAL_SETTINGS);
			verticalItem.addPopEvent(Event.COMPLETE);
			verticalItem.properties.settings = verticalLayoutSettings;
			this._navigator.addScreen(VERTICAL, verticalItem);

			var verticalSettingsItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(VerticalLayoutSettingsScreen);
			verticalSettingsItem.addPopEvent(Event.COMPLETE);
			verticalSettingsItem.properties.settings = verticalLayoutSettings;
			verticalSettingsItem.pushTransition = Cover.createCoverUpTransition();
			verticalSettingsItem.popTransition = Reveal.createRevealDownTransition();
			this._navigator.addScreen(VERTICAL_SETTINGS, verticalSettingsItem);

			var tiledRowsLayoutSettings:TiledRowsLayoutSettings = new TiledRowsLayoutSettings();
			var tiledRowsItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(TiledRowsLayoutScreen);
			tiledRowsItem.setScreenIDForPushEvent(TiledRowsLayoutScreen.SHOW_SETTINGS, TILED_ROWS_SETTINGS);
			tiledRowsItem.addPopEvent(Event.COMPLETE);
			tiledRowsItem.properties.settings = tiledRowsLayoutSettings;
			this._navigator.addScreen(TILED_ROWS, tiledRowsItem);

			var tiledRowsSettingsItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(TiledRowsLayoutSettingsScreen);
			tiledRowsSettingsItem.addPopEvent(Event.COMPLETE);
			tiledRowsSettingsItem.properties.settings = tiledRowsLayoutSettings;
			tiledRowsSettingsItem.pushTransition = Cover.createCoverUpTransition();
			tiledRowsSettingsItem.popTransition = Reveal.createRevealDownTransition();
			this._navigator.addScreen(TILED_ROWS_SETTINGS, tiledRowsSettingsItem);

			var tiledColumnsLayoutSettings:TiledColumnsLayoutSettings = new TiledColumnsLayoutSettings();
			var tiledColumnsItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(TiledColumnsLayoutScreen);
			tiledColumnsItem.setScreenIDForPushEvent(TiledColumnsLayoutScreen.SHOW_SETTINGS, TILED_COLUMNS_SETTINGS);
			tiledColumnsItem.addPopEvent(Event.COMPLETE);
			tiledColumnsItem.properties.settings = tiledColumnsLayoutSettings;
			this._navigator.addScreen(TILED_COLUMNS, tiledColumnsItem);

			var tiledColumnsSettingsItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(TiledColumnsLayoutSettingsScreen);
			tiledColumnsSettingsItem.addPopEvent(Event.COMPLETE);
			tiledColumnsSettingsItem.properties.settings = tiledColumnsLayoutSettings;
			tiledColumnsSettingsItem.pushTransition = Cover.createCoverUpTransition();
			tiledColumnsSettingsItem.popTransition = Reveal.createRevealDownTransition();
			this._navigator.addScreen(TILED_COLUMNS_SETTINGS, tiledColumnsSettingsItem);

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
				var mainMenuItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(MainMenuScreen);
				mainMenuItem.setScreenIDForPushEvent(MainMenuScreen.SHOW_ANCHOR, ANCHOR);
				mainMenuItem.setScreenIDForPushEvent(MainMenuScreen.SHOW_HORIZONTAL, HORIZONTAL);
				mainMenuItem.setScreenIDForPushEvent(MainMenuScreen.SHOW_VERTICAL, VERTICAL);
				mainMenuItem.setScreenIDForPushEvent(MainMenuScreen.SHOW_TILED_ROWS, TILED_ROWS);
				mainMenuItem.setScreenIDForPushEvent(MainMenuScreen.SHOW_TILED_COLUMNS, TILED_COLUMNS);
				this._navigator.addScreen(MAIN_MENU, mainMenuItem);
				this._navigator.rootScreenID = MAIN_MENU;
			}

			this._navigator.pushTransition = Slide.createSlideLeftTransition();
			this._navigator.popTransition = Slide.createSlideRightTransition();
		}

		private function mainMenuEventHandler(event:Event):void
		{
			var screenName:String = MAIN_MENU_EVENTS[event.type] as String;
			//since this navigation is triggered by an external menu, we don't
			//want to push a new screen onto the stack. we want to start fresh.
			this._navigator.rootScreenID = screenName;
		}
	}
}
