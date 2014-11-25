package feathers.examples.componentsExplorer
{
	import feathers.controls.Drawers;
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.StackScreenNavigator;
	import feathers.controls.StackScreenNavigatorItem;
	import feathers.examples.componentsExplorer.data.EmbeddedAssets;
	import feathers.examples.componentsExplorer.data.GroupedListSettings;
	import feathers.examples.componentsExplorer.data.ItemRendererSettings;
	import feathers.examples.componentsExplorer.data.ListSettings;
	import feathers.examples.componentsExplorer.data.NumericStepperSettings;
	import feathers.examples.componentsExplorer.data.SliderSettings;
	import feathers.examples.componentsExplorer.screens.AlertScreen;
	import feathers.examples.componentsExplorer.screens.ButtonGroupScreen;
	import feathers.examples.componentsExplorer.screens.ButtonScreen;
	import feathers.examples.componentsExplorer.screens.CalloutScreen;
	import feathers.examples.componentsExplorer.screens.GroupedListScreen;
	import feathers.examples.componentsExplorer.screens.GroupedListSettingsScreen;
	import feathers.examples.componentsExplorer.screens.ItemRendererScreen;
	import feathers.examples.componentsExplorer.screens.ItemRendererSettingsScreen;
	import feathers.examples.componentsExplorer.screens.LabelScreen;
	import feathers.examples.componentsExplorer.screens.ListScreen;
	import feathers.examples.componentsExplorer.screens.ListSettingsScreen;
	import feathers.examples.componentsExplorer.screens.MainMenuScreen;
	import feathers.examples.componentsExplorer.screens.NumericStepperScreen;
	import feathers.examples.componentsExplorer.screens.NumericStepperSettingsScreen;
	import feathers.examples.componentsExplorer.screens.PageIndicatorScreen;
	import feathers.examples.componentsExplorer.screens.PickerListScreen;
	import feathers.examples.componentsExplorer.screens.ProgressBarScreen;
	import feathers.examples.componentsExplorer.screens.ScrollTextScreen;
	import feathers.examples.componentsExplorer.screens.SliderScreen;
	import feathers.examples.componentsExplorer.screens.SliderSettingsScreen;
	import feathers.examples.componentsExplorer.screens.TabBarScreen;
	import feathers.examples.componentsExplorer.screens.TextInputScreen;
	import feathers.examples.componentsExplorer.screens.ToggleScreen;
	import feathers.examples.componentsExplorer.themes.ComponentsExplorerTheme;
	import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
	import feathers.motion.transitions.Slide;
	import feathers.system.DeviceCapabilities;

	import starling.core.Starling;
	import starling.events.Event;

	public class Main extends Drawers
	{
		private static const MAIN_MENU:String = "mainMenu";
		private static const ALERT:String = "alert";
		private static const BUTTON:String = "button";
		private static const BUTTON_SETTINGS:String = "buttonSettings";
		private static const BUTTON_GROUP:String = "buttonGroup";
		private static const CALLOUT:String = "callout";
		private static const GROUPED_LIST:String = "groupedList";
		private static const GROUPED_LIST_SETTINGS:String = "groupedListSettings";
		private static const ITEM_RENDERER:String = "itemRenderer";
		private static const ITEM_RENDERER_SETTINGS:String = "itemRendererSettings";
		private static const LABEL:String = "label";
		private static const LIST:String = "list";
		private static const LIST_SETTINGS:String = "listSettings";
		private static const NUMERIC_STEPPER:String = "numericStepper";
		private static const NUMERIC_STEPPER_SETTINGS:String = "numericStepperSettings";
		private static const PAGE_INDICATOR:String = "pageIndicator";
		private static const PICKER_LIST:String = "pickerList";
		private static const PROGRESS_BAR:String = "progressBar";
		private static const SCROLL_TEXT:String = "scrollText";
		private static const SLIDER:String = "slider";
		private static const SLIDER_SETTINGS:String = "sliderSettings";
		private static const TAB_BAR:String = "tabBar";
		private static const TEXT_INPUT:String = "textInput";
		private static const TOGGLES:String = "toggles";

		private static const MAIN_MENU_EVENTS:Object =
		{
			showAlert: ALERT,
			showButton: BUTTON,
			showButtonGroup: BUTTON_GROUP,
			showCallout: CALLOUT,
			showGroupedList: GROUPED_LIST,
			showItemRenderer: ITEM_RENDERER,
			showLabel: LABEL,
			showList: LIST,
			showNumericStepper: NUMERIC_STEPPER,
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
		}

		private var _navigator:StackScreenNavigator;
		private var _menu:MainMenuScreen;
		
		override protected function initialize():void
		{
			//never forget to call super.initialize()
			super.initialize();

			EmbeddedAssets.initialize();

			new ComponentsExplorerTheme();
			
			this._navigator = new StackScreenNavigator();
			this.content = this._navigator;

			this._navigator.addScreen(ALERT, new StackScreenNavigatorItem(AlertScreen,
				null, Event.COMPLETE));

			this._navigator.addScreen(BUTTON, new StackScreenNavigatorItem(ButtonScreen,
			{
				showSettings: BUTTON_SETTINGS
			}, Event.COMPLETE));

			this._navigator.addScreen(BUTTON_GROUP, new StackScreenNavigatorItem(ButtonGroupScreen,
				null, Event.COMPLETE));

			this._navigator.addScreen(CALLOUT, new StackScreenNavigatorItem(CalloutScreen,
				null, Event.COMPLETE));

			this._navigator.addScreen(SCROLL_TEXT, new StackScreenNavigatorItem(ScrollTextScreen,
				null, Event.COMPLETE));

			var sliderSettings:SliderSettings = new SliderSettings();
			this._navigator.addScreen(SLIDER, new StackScreenNavigatorItem(SliderScreen,
			{
				showSettings: SLIDER_SETTINGS
			}, Event.COMPLETE,
			{
				settings: sliderSettings
			}));

			this._navigator.addScreen(SLIDER_SETTINGS, new StackScreenNavigatorItem(SliderSettingsScreen, null, Event.COMPLETE,
			{
				settings: sliderSettings
			}));
			
			this._navigator.addScreen(TOGGLES, new StackScreenNavigatorItem(ToggleScreen,
				null, Event.COMPLETE));

			var groupedListSettings:GroupedListSettings = new GroupedListSettings();
			this._navigator.addScreen(GROUPED_LIST, new StackScreenNavigatorItem(GroupedListScreen,
			{
				showSettings: GROUPED_LIST_SETTINGS
			}, Event.COMPLETE,
			{
				settings: groupedListSettings
			}));

			this._navigator.addScreen(GROUPED_LIST_SETTINGS, new StackScreenNavigatorItem(GroupedListSettingsScreen, null, Event.COMPLETE,
			{
				settings: groupedListSettings
			}));

			var itemRendererSettings:ItemRendererSettings = new ItemRendererSettings();
			this._navigator.addScreen(ITEM_RENDERER, new StackScreenNavigatorItem(ItemRendererScreen,
			{
				showSettings: ITEM_RENDERER_SETTINGS
			}, Event.COMPLETE,
			{
				settings: itemRendererSettings
			}));

			this._navigator.addScreen(ITEM_RENDERER_SETTINGS, new StackScreenNavigatorItem(ItemRendererSettingsScreen, null, Event.COMPLETE,
			{
				settings: itemRendererSettings
			}));

			this._navigator.addScreen(LABEL, new StackScreenNavigatorItem(LabelScreen,
				null, Event.COMPLETE));

			var listSettings:ListSettings = new ListSettings();
			this._navigator.addScreen(LIST, new StackScreenNavigatorItem(ListScreen,
			{
				showSettings: LIST_SETTINGS
			}, Event.COMPLETE,
			{
				settings: listSettings
			}));

			this._navigator.addScreen(LIST_SETTINGS, new StackScreenNavigatorItem(ListSettingsScreen, null, Event.COMPLETE,
			{
				settings: listSettings
			}));

			var numericStepperSettings:NumericStepperSettings = new NumericStepperSettings();
			this._navigator.addScreen(NUMERIC_STEPPER, new StackScreenNavigatorItem(NumericStepperScreen,
			{
				showSettings: NUMERIC_STEPPER_SETTINGS
			}, Event.COMPLETE,
			{
				settings: numericStepperSettings
			}));

			this._navigator.addScreen(NUMERIC_STEPPER_SETTINGS, new StackScreenNavigatorItem(NumericStepperSettingsScreen, null, Event.COMPLETE,
			{
				settings: numericStepperSettings
			}));

			this._navigator.addScreen(PAGE_INDICATOR, new StackScreenNavigatorItem(PageIndicatorScreen,
				null, Event.COMPLETE));
			
			this._navigator.addScreen(PICKER_LIST, new StackScreenNavigatorItem(PickerListScreen,
				null, Event.COMPLETE));

			this._navigator.addScreen(TAB_BAR, new StackScreenNavigatorItem(TabBarScreen,
				null, Event.COMPLETE));

			this._navigator.addScreen(TEXT_INPUT, new StackScreenNavigatorItem(TextInputScreen,
				null, Event.COMPLETE));

			this._navigator.addScreen(PROGRESS_BAR, new StackScreenNavigatorItem(ProgressBarScreen,
				null, Event.COMPLETE));

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
				this._menu.height = 200;
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