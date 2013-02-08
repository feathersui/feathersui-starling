package feathers.examples.componentsExplorer
{
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.examples.componentsExplorer.data.ButtonSettings;
	import feathers.examples.componentsExplorer.data.GroupedListSettings;
	import feathers.examples.componentsExplorer.data.ListSettings;
	import feathers.examples.componentsExplorer.data.SliderSettings;
	import feathers.examples.componentsExplorer.screens.ButtonGroupScreen;
	import feathers.examples.componentsExplorer.screens.ButtonScreen;
	import feathers.examples.componentsExplorer.screens.ButtonSettingsScreen;
	import feathers.examples.componentsExplorer.screens.CalloutScreen;
	import feathers.examples.componentsExplorer.screens.GroupedListScreen;
	import feathers.examples.componentsExplorer.screens.GroupedListSettingsScreen;
	import feathers.examples.componentsExplorer.screens.ListScreen;
	import feathers.examples.componentsExplorer.screens.ListSettingsScreen;
	import feathers.examples.componentsExplorer.screens.MainMenuScreen;
	import feathers.examples.componentsExplorer.screens.PageIndicatorScreen;
	import feathers.examples.componentsExplorer.screens.PickerListScreen;
	import feathers.examples.componentsExplorer.screens.ProgressBarScreen;
	import feathers.examples.componentsExplorer.screens.ScrollTextScreen;
	import feathers.examples.componentsExplorer.screens.SliderScreen;
	import feathers.examples.componentsExplorer.screens.SliderSettingsScreen;
	import feathers.examples.componentsExplorer.screens.TabBarScreen;
	import feathers.examples.componentsExplorer.screens.TextInputScreen;
	import feathers.examples.componentsExplorer.screens.ToggleScreen;
	import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
	import feathers.themes.MetalWorksMobileTheme;

	import starling.display.Sprite;
	import starling.events.Event;

	public class Main extends Sprite
	{
		private static const MAIN_MENU:String = "mainMenu";
		private static const BUTTON:String = "button";
		private static const BUTTON_SETTINGS:String = "buttonSettings";
		private static const BUTTON_GROUP:String = "buttonGroup";
		private static const CALLOUT:String = "callout";
		private static const GROUPED_LIST:String = "groupedList";
		private static const GROUPED_LIST_SETTINGS:String = "groupedListSettings";
		private static const LIST:String = "list";
		private static const LIST_SETTINGS:String = "listSettings";
		private static const PAGE_INDICATOR:String = "pageIndicator";
		private static const PICKER_LIST:String = "pickerList";
		private static const PROGRESS_BAR:String = "progressBar";
		private static const SCROLL_TEXT:String = "scrollText";
		private static const SLIDER:String = "slider";
		private static const SLIDER_SETTINGS:String = "sliderSettings";
		private static const TAB_BAR:String = "tabBar";
		private static const TEXT_INPUT:String = "textInput";
		private static const TOGGLES:String = "toggles";
		
		public function Main()
		{
			super();
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
				showButton: BUTTON,
				showButtonGroup: BUTTON_GROUP,
				showCallout: CALLOUT,
				showGroupedList: GROUPED_LIST,
				showList: LIST,
				showPageIndicator: PAGE_INDICATOR,
				showPickerList: PICKER_LIST,
				showProgressBar: PROGRESS_BAR,
				showScrollText: SCROLL_TEXT,
				showSlider: SLIDER,
				showTabBar: TAB_BAR,
				showTextInput: TEXT_INPUT,
				showToggles: TOGGLES
			}));

			const buttonSettings:ButtonSettings = new ButtonSettings();
			this._navigator.addScreen(BUTTON, new ScreenNavigatorItem(ButtonScreen,
			{
				complete: MAIN_MENU,
				showSettings: BUTTON_SETTINGS
			},
			{
				settings: buttonSettings
			}));

			this._navigator.addScreen(BUTTON_SETTINGS, new ScreenNavigatorItem(ButtonSettingsScreen,
			{
				complete: BUTTON
			},
			{
				settings: buttonSettings
			}));

			this._navigator.addScreen(BUTTON_GROUP, new ScreenNavigatorItem(ButtonGroupScreen,
			{
				complete: MAIN_MENU
			}));

			this._navigator.addScreen(CALLOUT, new ScreenNavigatorItem(CalloutScreen,
			{
				complete: MAIN_MENU
			}));

			this._navigator.addScreen(SCROLL_TEXT, new ScreenNavigatorItem(ScrollTextScreen,
			{
				complete: MAIN_MENU
			}));

			const sliderSettings:SliderSettings = new SliderSettings();
			this._navigator.addScreen(SLIDER, new ScreenNavigatorItem(SliderScreen,
			{
				complete: MAIN_MENU,
				showSettings: SLIDER_SETTINGS
			},
			{
				settings: sliderSettings
			}));

			this._navigator.addScreen(SLIDER_SETTINGS, new ScreenNavigatorItem(SliderSettingsScreen,
			{
				complete: SLIDER
			},
			{
				settings: sliderSettings
			}));
			
			this._navigator.addScreen(TOGGLES, new ScreenNavigatorItem(ToggleScreen,
			{
				complete: MAIN_MENU
			}));

			const groupedListSettings:GroupedListSettings = new GroupedListSettings();
			this._navigator.addScreen(GROUPED_LIST, new ScreenNavigatorItem(GroupedListScreen,
			{
				complete: MAIN_MENU,
				showSettings: GROUPED_LIST_SETTINGS
			},
			{
				settings: groupedListSettings
			}));

			this._navigator.addScreen(GROUPED_LIST_SETTINGS, new ScreenNavigatorItem(GroupedListSettingsScreen,
			{
				complete: GROUPED_LIST
			},
			{
				settings: groupedListSettings
			}));

			const listSettings:ListSettings = new ListSettings();
			this._navigator.addScreen(LIST, new ScreenNavigatorItem(ListScreen,
			{
				complete: MAIN_MENU,
				showSettings: LIST_SETTINGS
			},
			{
				settings: listSettings
			}));

			this._navigator.addScreen(LIST_SETTINGS, new ScreenNavigatorItem(ListSettingsScreen,
			{
				complete: LIST
			},
			{
				settings: listSettings
			}));

			this._navigator.addScreen(PAGE_INDICATOR, new ScreenNavigatorItem(PageIndicatorScreen,
			{
				complete: MAIN_MENU
			}));
			
			this._navigator.addScreen(PICKER_LIST, new ScreenNavigatorItem(PickerListScreen,
			{
				complete: MAIN_MENU
			}));

			this._navigator.addScreen(TAB_BAR, new ScreenNavigatorItem(TabBarScreen,
			{
				complete: MAIN_MENU
			}));

			this._navigator.addScreen(TEXT_INPUT, new ScreenNavigatorItem(TextInputScreen,
			{
				complete: MAIN_MENU
			}));

			this._navigator.addScreen(PROGRESS_BAR, new ScreenNavigatorItem(ProgressBarScreen,
			{
				complete: MAIN_MENU
			}));
			
			this._navigator.showScreen(MAIN_MENU);
			
			this._transitionManager = new ScreenSlidingStackTransitionManager(this._navigator);
			this._transitionManager.duration = 0.4;
		}
	}
}