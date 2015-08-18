package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.DateTimeSpinner;
	import feathers.controls.Header;
	import feathers.controls.PanelScreen;
	import feathers.examples.componentsExplorer.data.DateTimeSpinnerSettings;
	import feathers.layout.AnchorLayout;
	import feathers.skins.IStyleProvider;
	import feathers.system.DeviceCapabilities;

	import starling.core.Starling;

	import starling.display.DisplayObject;

	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]
	
	public class DateTimeSpinnerScreen extends PanelScreen
	{
		public static var globalStyleProvider:IStyleProvider;
		
		public static const SHOW_SETTINGS:String = "showSettings";
		
		public function DateTimeSpinnerScreen()
		{
		}

		override protected function get defaultStyleProvider():IStyleProvider
		{
			return DateTimeSpinnerScreen.globalStyleProvider;
		}

		public var settings:DateTimeSpinnerSettings;

		private var _dateTimeSpinner:DateTimeSpinner;

		override protected function initialize():void
		{
			//never forget to call super.initialize()
			super.initialize();

			this.title = "Date Time Spinner";

			this._dateTimeSpinner = new DateTimeSpinner();
			this._dateTimeSpinner.editingMode = this.settings.editingMode;
			this._dateTimeSpinner.addEventListener(Event.CHANGE, dateTimeSpinner_changeHandler);
			this.addChild(this._dateTimeSpinner);

			this.headerFactory = this.customHeaderFactory;

			//this screen doesn't use a back button on tablets because the main
			//app's uses a split layout
			if(!DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				this.backButtonHandler = this.onBackButton;
			}
		}

		private function customHeaderFactory():Header
		{
			var header:Header = new Header();
			//this screen doesn't use a back button on tablets because the main
			//app's uses a split layout
			if(!DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				var backButton:Button = new Button();
				backButton.styleNameList.add(Button.ALTERNATE_STYLE_NAME_BACK_BUTTON);
				backButton.label = "Back";
				backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);
				header.leftItems = new <DisplayObject>
				[
					backButton
				];
			}
			var settingsButton:Button = new Button();
			settingsButton.label = "Settings";
			settingsButton.addEventListener(Event.TRIGGERED, settingsButton_triggeredHandler);
			header.rightItems = new <DisplayObject>
			[
				settingsButton
			];
			return header;
		}

		private function onBackButton():void
		{
			this.dispatchEventWith(Event.COMPLETE);
		}

		private function backButton_triggeredHandler(event:Event):void
		{
			this.onBackButton();
		}

		private function settingsButton_triggeredHandler(event:Event):void
		{
			this.dispatchEventWith(SHOW_SETTINGS);
		}

		private function dateTimeSpinner_changeHandler(event:Event):void
		{
			trace("DateTimeSpinner change:", this._dateTimeSpinner.value);
		}
	}
}
