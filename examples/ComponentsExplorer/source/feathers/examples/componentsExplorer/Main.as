package feathers.examples.componentsExplorer
{
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.ScrollContainer;
	import feathers.examples.componentsExplorer.data.ButtonSettings;
	import feathers.examples.componentsExplorer.data.GroupedListSettings;
	import feathers.examples.componentsExplorer.data.ListSettings;
	import feathers.examples.componentsExplorer.data.SliderSettings;
	import feathers.examples.componentsExplorer.data.TextInputSettings;
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
	import feathers.examples.componentsExplorer.screens.TextInputSettingsScreen;
	import feathers.examples.componentsExplorer.screens.ToggleScreen;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
	import feathers.system.DeviceCapabilities;
	import feathers.themes.MetalWorksMobileTheme;

	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.ResizeEvent;

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
		private static const TEXT_INPUT_SETTINGS:String = "textInputSettings";
		private static const TOGGLES:String = "toggles";

		private static const MAIN_MENU_EVENTS:Object =
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
		};
		
		public function Main()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		private var _theme:MetalWorksMobileTheme;
		private var _container:ScrollContainer;
		private var _navigator:ScreenNavigator;
		private var _menu:MainMenuScreen;
		private var _transitionManager:ScreenSlidingStackTransitionManager;

		private function layoutForTablet():void
		{
			this._container.width = this.stage.stageWidth;
			this._container.height = this.stage.stageHeight;
		}
		
		private function addedToStageHandler(event:Event):void
		{
			this._theme = new MetalWorksMobileTheme();
			
			this._navigator = new ScreenNavigator();

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

			const textInputSettings:TextInputSettings = new TextInputSettings();
			this._navigator.addScreen(TEXT_INPUT, new ScreenNavigatorItem(TextInputScreen,
			{
				complete: MAIN_MENU,
				showSettings: TEXT_INPUT_SETTINGS
			},
			{
				settings: textInputSettings
			}));
			this._navigator.addScreen(TEXT_INPUT_SETTINGS, new ScreenNavigatorItem(TextInputSettingsScreen,
			{
				complete: TEXT_INPUT
			},
			{
				settings: textInputSettings
			}));

			this._navigator.addScreen(PROGRESS_BAR, new ScreenNavigatorItem(ProgressBarScreen,
			{
				complete: MAIN_MENU
			}));

			this._transitionManager = new ScreenSlidingStackTransitionManager(this._navigator);
			this._transitionManager.duration = 0.4;

			if(DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				this.stage.addEventListener(ResizeEvent.RESIZE, stage_resizeHandler);

				this._container = new ScrollContainer();
				this._container.layout = new AnchorLayout();
				this._container.horizontalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
				this._container.verticalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
				this.addChild(this._container);

				this._menu = new MainMenuScreen();
				for(var eventType:String in MAIN_MENU_EVENTS)
				{
					this._menu.addEventListener(eventType, mainMenuEventHandler);
				}
				const menuLayoutData:AnchorLayoutData = new AnchorLayoutData();
				menuLayoutData.top = 0;
				menuLayoutData.bottom = 0;
				menuLayoutData.left = 0;
				this._menu.layoutData = menuLayoutData;
				this._container.addChild(this._menu);

				this._navigator.clipContent = true;
				const navigatorLayoutData:AnchorLayoutData = new AnchorLayoutData();
				navigatorLayoutData.top = 0;
				navigatorLayoutData.right = 0;
				navigatorLayoutData.bottom = 0;
				navigatorLayoutData.leftAnchorDisplayObject = this._menu;
				navigatorLayoutData.left = 0;
				this._navigator.layoutData = navigatorLayoutData;
				this._container.addChild(this._navigator);

				this.layoutForTablet();
			}
			else
			{
				this._navigator.addScreen(MAIN_MENU, new ScreenNavigatorItem(MainMenuScreen, MAIN_MENU_EVENTS));

				this.addChild(this._navigator);

				this._navigator.showScreen(MAIN_MENU);
			}
		}

		private function removedFromStageHandler(event:Event):void
		{
			this.stage.removeEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
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

		private function stage_resizeHandler(event:ResizeEvent):void
		{
			//we don't need to layout for phones because ScreenNavigator knows
			//to automatically resize itself to fill the stage if we don't give
			//it a width and height.
			this.layoutForTablet();
		}
	}
}