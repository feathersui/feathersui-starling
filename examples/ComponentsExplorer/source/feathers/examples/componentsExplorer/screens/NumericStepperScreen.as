package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.NumericStepper;
	import feathers.controls.PanelScreen;
	import feathers.examples.componentsExplorer.data.NumericStepperSettings;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.system.DeviceCapabilities;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]
	[Event(name="showSettings",type="starling.events.Event")]

	public class NumericStepperScreen extends PanelScreen
	{
		public static const SHOW_SETTINGS:String = "showSettings";

		public function NumericStepperScreen()
		{
			super();
		}

		public var settings:NumericStepperSettings;

		private var _stepper:NumericStepper;

		override protected function initialize():void
		{
			//never forget to call super.initialize()
			super.initialize();

			this.title = "Numeric Stepper";

			this.layout = new AnchorLayout();

			this._stepper = new NumericStepper();
			this._stepper.minimum = 0;
			this._stepper.maximum = 100;
			this._stepper.value = 50;
			this._stepper.step = this.settings.step;
			this._stepper.addEventListener(Event.CHANGE, slider_changeHandler);
			var stepperLayoutData:AnchorLayoutData = new AnchorLayoutData();
			stepperLayoutData.horizontalCenter = 0;
			stepperLayoutData.verticalCenter = 0;
			this._stepper.layoutData = stepperLayoutData;
			this.addChild(this._stepper);

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

		private function slider_changeHandler(event:Event):void
		{
			trace("numeric stepper change:", this._stepper.value);
		}

		private function backButton_triggeredHandler(event:Event):void
		{
			this.onBackButton();
		}

		private function settingsButton_triggeredHandler(event:Event):void
		{
			this.dispatchEventWith(SHOW_SETTINGS);
		}
	}
}