package feathers.examples.componentsExplorer
{
	import feathers.controls.Drawers;
	import feathers.controls.StackScreenNavigator;
	import feathers.controls.StackScreenNavigatorItem;
	import feathers.examples.componentsExplorer.data.DateTimeSpinnerSettings;
	import feathers.examples.componentsExplorer.data.EmbeddedAssets;
	import feathers.examples.componentsExplorer.data.GroupedListSettings;
	import feathers.examples.componentsExplorer.data.ItemRendererSettings;
	import feathers.examples.componentsExplorer.data.ListSettings;
	import feathers.examples.componentsExplorer.data.NumericStepperSettings;
	import feathers.examples.componentsExplorer.data.SliderSettings;
	import feathers.examples.componentsExplorer.screens.AlertScreen;
	import feathers.examples.componentsExplorer.screens.AutoCompleteScreen;
	import feathers.examples.componentsExplorer.screens.ButtonGroupScreen;
	import feathers.examples.componentsExplorer.screens.ButtonScreen;
	import feathers.examples.componentsExplorer.screens.CalloutScreen;
	import feathers.examples.componentsExplorer.screens.CheckScreen;
	import feathers.examples.componentsExplorer.screens.ColorPickerScreen;
	import feathers.examples.componentsExplorer.screens.DateTimeSpinnerScreen;
	import feathers.examples.componentsExplorer.screens.DateTimeSpinnerSettingsScreen;
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
	import feathers.examples.componentsExplorer.screens.RadioScreen;
	import feathers.examples.componentsExplorer.screens.ScrollTextScreen;
	import feathers.examples.componentsExplorer.screens.SliderScreen;
	import feathers.examples.componentsExplorer.screens.SliderSettingsScreen;
	import feathers.examples.componentsExplorer.screens.SpinnerListScreen;
	import feathers.examples.componentsExplorer.screens.TabBarScreen;
	import feathers.examples.componentsExplorer.screens.TextCalloutScreen;
	import feathers.examples.componentsExplorer.screens.TextInputScreen;
	import feathers.examples.componentsExplorer.screens.ToggleSwitchScreen;
	import feathers.examples.componentsExplorer.screens.WebViewScreen;
	import feathers.examples.componentsExplorer.themes.ComponentsExplorerTheme;
	import feathers.layout.Orientation;
	import feathers.motion.Cover;
	import feathers.motion.Reveal;
	import feathers.motion.Slide;
	import feathers.system.DeviceCapabilities;

	import flash.system.Capabilities;

	import starling.core.Starling;
	import starling.events.Event;

	public class Main extends Drawers
	{
		public function Main()
		{
			//set up the theme right away!
			new ComponentsExplorerTheme();
			super();
		}

		private var _navigator:StackScreenNavigator;
		private var _menu:MainMenuScreen;
		
		override protected function initialize():void
		{
			//never forget to call super.initialize()
			super.initialize();

			EmbeddedAssets.initialize();

			this._navigator = new StackScreenNavigator();
			this.content = this._navigator;

			var alertItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(AlertScreen);
			alertItem.addPopEvent(Event.COMPLETE);
			this._navigator.addScreen(ScreenID.ALERT, alertItem);

			var autoCompleteItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(AutoCompleteScreen);
			autoCompleteItem.addPopEvent(Event.COMPLETE);
			this._navigator.addScreen(ScreenID.AUTO_COMPLETE, autoCompleteItem);

			var buttonItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(ButtonScreen);
			buttonItem.addPopEvent(Event.COMPLETE);
			this._navigator.addScreen(ScreenID.BUTTON, buttonItem);

			var buttonGroupItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(ButtonGroupScreen);
			buttonGroupItem.addPopEvent(Event.COMPLETE);
			this._navigator.addScreen(ScreenID.BUTTON_GROUP, buttonGroupItem);

			var calloutItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(CalloutScreen);
			calloutItem.addPopEvent(Event.COMPLETE);
			this._navigator.addScreen(ScreenID.CALLOUT, calloutItem);

			var checkItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(CheckScreen);
			checkItem.addPopEvent(Event.COMPLETE);
			this._navigator.addScreen(ScreenID.CHECK, checkItem);

			var colorPickerItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(ColorPickerScreen);
			colorPickerItem.addPopEvent(Event.COMPLETE);
			this._navigator.addScreen(ScreenID.COLOR_PICKER, colorPickerItem);

			var dateTimeSpinnerSettings:DateTimeSpinnerSettings = new DateTimeSpinnerSettings();
			var dateTimeSpinnerItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(DateTimeSpinnerScreen);
			dateTimeSpinnerItem.setScreenIDForPushEvent(DateTimeSpinnerScreen.SHOW_SETTINGS, ScreenID.DATE_TIME_SPINNER_SETTINGS);
			dateTimeSpinnerItem.addPopEvent(Event.COMPLETE);
			dateTimeSpinnerItem.properties.settings = dateTimeSpinnerSettings;
			this._navigator.addScreen(ScreenID.DATE_TIME_SPINNER, dateTimeSpinnerItem);

			var dateTimeSpinnerSettingsItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(DateTimeSpinnerSettingsScreen);
			dateTimeSpinnerSettingsItem.addPopEvent(Event.COMPLETE);
			dateTimeSpinnerSettingsItem.properties.settings = dateTimeSpinnerSettings;
			//custom push and pop transitions for this settings screen
			dateTimeSpinnerSettingsItem.pushTransition = Cover.createCoverUpTransition();
			dateTimeSpinnerSettingsItem.popTransition = Reveal.createRevealDownTransition();
			this._navigator.addScreen(ScreenID.DATE_TIME_SPINNER_SETTINGS, dateTimeSpinnerSettingsItem);

			var groupedListSettings:GroupedListSettings = new GroupedListSettings();
			var groupedListItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(GroupedListScreen);
			groupedListItem.setScreenIDForPushEvent(GroupedListScreen.SHOW_SETTINGS, ScreenID.GROUPED_LIST_SETTINGS);
			groupedListItem.addPopEvent(Event.COMPLETE);
			groupedListItem.properties.settings = groupedListSettings;
			this._navigator.addScreen(ScreenID.GROUPED_LIST, groupedListItem);

			var groupedListSettingsItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(GroupedListSettingsScreen);
			groupedListSettingsItem.addPopEvent(Event.COMPLETE);
			groupedListSettingsItem.properties.settings = groupedListSettings;
			//custom push and pop transitions for this settings screen
			groupedListSettingsItem.pushTransition = Cover.createCoverUpTransition();
			groupedListSettingsItem.popTransition = Reveal.createRevealDownTransition();
			this._navigator.addScreen(ScreenID.GROUPED_LIST_SETTINGS, groupedListSettingsItem);

			var itemRendererSettings:ItemRendererSettings = new ItemRendererSettings();
			var itemRendererItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(ItemRendererScreen);
			itemRendererItem.setScreenIDForPushEvent(ItemRendererScreen.SHOW_SETTINGS, ScreenID.ITEM_RENDERER_SETTINGS);
			itemRendererItem.addPopEvent(Event.COMPLETE);
			itemRendererItem.properties.settings = itemRendererSettings;
			this._navigator.addScreen(ScreenID.ITEM_RENDERER, itemRendererItem);

			var itemRendererSettingsItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(ItemRendererSettingsScreen);
			itemRendererSettingsItem.addPopEvent(Event.COMPLETE);
			itemRendererSettingsItem.properties.settings = itemRendererSettings;
			//custom push and pop transitions for this settings screen
			itemRendererSettingsItem.pushTransition = Cover.createCoverUpTransition();
			itemRendererSettingsItem.popTransition = Reveal.createRevealDownTransition();
			this._navigator.addScreen(ScreenID.ITEM_RENDERER_SETTINGS, itemRendererSettingsItem);

			var labelItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(LabelScreen);
			labelItem.addPopEvent(Event.COMPLETE);
			this._navigator.addScreen(ScreenID.LABEL, labelItem);

			var listSettings:ListSettings = new ListSettings();
			var listItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(ListScreen);
			listItem.setScreenIDForPushEvent(ListScreen.SHOW_SETTINGS, ScreenID.LIST_SETTINGS);
			listItem.addPopEvent(Event.COMPLETE);
			listItem.properties.settings = listSettings;
			this._navigator.addScreen(ScreenID.LIST, listItem);

			var listSettingsItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(ListSettingsScreen);
			listSettingsItem.addPopEvent(Event.COMPLETE);
			listSettingsItem.properties.settings = listSettings;
			//custom push and pop transitions for this settings screen
			listSettingsItem.pushTransition = Cover.createCoverUpTransition();
			listSettingsItem.popTransition = Reveal.createRevealDownTransition();
			this._navigator.addScreen(ScreenID.LIST_SETTINGS, listSettingsItem);

			var numericStepperSettings:NumericStepperSettings = new NumericStepperSettings();
			var numericStepperItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(NumericStepperScreen);
			numericStepperItem.setScreenIDForPushEvent(NumericStepperScreen.SHOW_SETTINGS, ScreenID.NUMERIC_STEPPER_SETTINGS);
			numericStepperItem.addPopEvent(Event.COMPLETE);
			numericStepperItem.properties.settings = numericStepperSettings;
			this._navigator.addScreen(ScreenID.NUMERIC_STEPPER, numericStepperItem);

			var numericStepperSettingsItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(NumericStepperSettingsScreen);
			numericStepperSettingsItem.addPopEvent(Event.COMPLETE);
			numericStepperSettingsItem.properties.settings = numericStepperSettings;
			//custom push and pop transitions for this settings screen
			numericStepperSettingsItem.pushTransition = Cover.createCoverUpTransition();
			numericStepperSettingsItem.popTransition = Reveal.createRevealDownTransition();
			this._navigator.addScreen(ScreenID.NUMERIC_STEPPER_SETTINGS, numericStepperSettingsItem);

			var pageIndicatorItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(PageIndicatorScreen);
			pageIndicatorItem.addPopEvent(Event.COMPLETE);
			this._navigator.addScreen(ScreenID.PAGE_INDICATOR, pageIndicatorItem);

			var pickerListItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(PickerListScreen);
			pickerListItem.addPopEvent(Event.COMPLETE);
			this._navigator.addScreen(ScreenID.PICKER_LIST, pickerListItem);

			var progressBarItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(ProgressBarScreen);
			progressBarItem.addPopEvent(Event.COMPLETE);
			this._navigator.addScreen(ScreenID.PROGRESS_BAR, progressBarItem);

			var radioItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(RadioScreen);
			radioItem.addPopEvent(Event.COMPLETE);
			this._navigator.addScreen(ScreenID.RADIO, radioItem);

			var scrollTextItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(ScrollTextScreen);
			scrollTextItem.addPopEvent(Event.COMPLETE);
			this._navigator.addScreen(ScreenID.SCROLL_TEXT, scrollTextItem);

			var sliderSettings:SliderSettings = new SliderSettings();
			var sliderItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(SliderScreen);
			sliderItem.setScreenIDForPushEvent(SliderScreen.SHOW_SETTINGS, ScreenID.SLIDER_SETTINGS);
			sliderItem.addPopEvent(Event.COMPLETE);
			sliderItem.properties.settings = sliderSettings;
			this._navigator.addScreen(ScreenID.SLIDER, sliderItem);

			var sliderSettingsItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(SliderSettingsScreen);
			sliderSettingsItem.addPopEvent(Event.COMPLETE);
			sliderSettingsItem.properties.settings = sliderSettings;
			//custom push and pop transitions for this settings screen
			sliderSettingsItem.pushTransition = Cover.createCoverUpTransition();
			sliderSettingsItem.popTransition = Reveal.createRevealDownTransition();
			this._navigator.addScreen(ScreenID.SLIDER_SETTINGS, sliderSettingsItem);

			var spinnerListItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(SpinnerListScreen);
			spinnerListItem.addPopEvent(Event.COMPLETE);
			this._navigator.addScreen(ScreenID.SPINNER_LIST, spinnerListItem);

			var tabBarItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(TabBarScreen);
			tabBarItem.addPopEvent(Event.COMPLETE);
			this._navigator.addScreen(ScreenID.TAB_BAR, tabBarItem);

			var textCalloutItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(TextCalloutScreen);
			textCalloutItem.addPopEvent(Event.COMPLETE);
			this._navigator.addScreen(ScreenID.TEXT_CALLOUT, textCalloutItem);

			var textInputItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(TextInputScreen);
			textInputItem.addPopEvent(Event.COMPLETE);
			this._navigator.addScreen(ScreenID.TEXT_INPUT, textInputItem);

			var togglesItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(ToggleSwitchScreen);
			togglesItem.addPopEvent(Event.COMPLETE);
			this._navigator.addScreen(ScreenID.TOGGLES, togglesItem);

			if(Capabilities.playerType == "Desktop") //this means AIR, even for mobile
			{
				var webViewItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(WebViewScreen);
				webViewItem.addPopEvent(Event.COMPLETE);
				this._navigator.addScreen(ScreenID.WEB_VIEW, webViewItem);
			}

			if(DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				//we don't want the screens bleeding outside the navigator's
				//bounds on top of a drawer when a transition is active, so
				//enable clipping.
				this._navigator.clipContent = true;
				this._menu = new MainMenuScreen();
				this._menu.addEventListener(Event.CHANGE, mainMenu_tabletChangeHandler);
				this._menu.height = 200;
				this.leftDrawer = this._menu;
				this.leftDrawerDockMode = Orientation.BOTH;
			}
			else
			{
				var mainMenuItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(MainMenuScreen);
				mainMenuItem.setFunctionForPushEvent(Event.CHANGE, mainMenu_phoneChangeHandler);
				this._navigator.addScreen(ScreenID.MAIN_MENU, mainMenuItem);
				this._navigator.rootScreenID = ScreenID.MAIN_MENU;
			}

			this._navigator.pushTransition = Slide.createSlideLeftTransition();
			this._navigator.popTransition = Slide.createSlideRightTransition();
		}

		private function mainMenu_phoneChangeHandler(event:Event):void
		{
			//when MainMenuScreen dispatches Event.CHANGE, its selectedScreenID
			//property has been updated. use that to show the correct screen.
			var screen:MainMenuScreen = MainMenuScreen(event.currentTarget);
			this._navigator.pushScreen(screen.selectedScreenID, event.data);
			//pass the data from the event to save it for when we pop back.
		}

		private function mainMenu_tabletChangeHandler(event:Event):void
		{
			//since this navigation is triggered by an external menu, we don't
			//want to push a new screen onto the stack. we want to start fresh.
			var screen:MainMenuScreen = MainMenuScreen(event.currentTarget);
			this._navigator.rootScreenID = screen.selectedScreenID;
		}
	}
}