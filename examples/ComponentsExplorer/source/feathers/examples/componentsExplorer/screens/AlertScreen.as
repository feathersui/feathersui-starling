package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Alert;
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.PanelScreen;
	import feathers.data.ListCollection;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.system.DeviceCapabilities;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;

	public class AlertScreen extends PanelScreen
	{
		public function AlertScreen()
		{
			super();
		}

		private var _backButton:Button;
		private var _showAlertButton:Button;

		override protected function initialize():void
		{
			//never forget to call super.initialize()
			super.initialize();

			this.layout = new AnchorLayout();

			this._showAlertButton = new Button();
			this._showAlertButton.label = "Show Alert";
			this._showAlertButton.addEventListener(Event.TRIGGERED, showAlertButton_triggeredHandler);
			var buttonGroupLayoutData:AnchorLayoutData = new AnchorLayoutData();
			buttonGroupLayoutData.horizontalCenter = 0;
			buttonGroupLayoutData.verticalCenter = 0;
			this._showAlertButton.layoutData = buttonGroupLayoutData;
			this.addChild(this._showAlertButton);

			this.headerFactory = this.customHeaderFactory;

			//we don't display the back button on tablets because the app's
			//layout puts the main component list side by side with the selected
			//component.
			if(!DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				this._backButton = new Button();
				this._backButton.styleNameList.add(Button.ALTERNATE_STYLE_NAME_BACK_BUTTON);
				this._backButton.label = "Back";
				this._backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);
				//we'll add this as a child in the header factory

				this.backButtonHandler = this.onBackButton;
			}
		}

		private function customHeaderFactory():Header
		{
			var header:Header = new Header();
			header.title = "Alert";
			if(!DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				header.leftItems = new <DisplayObject>
				[
					this._backButton
				];
			}
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

		private function showAlertButton_triggeredHandler(event:Event):void
		{
			var alert:Alert = Alert.show("I just wanted you to know that I have a very important message to share with you.", "Alert", new ListCollection(
			[
				{ label: "OK" },
				{ label: "Cancel" }
			]));
			alert.addEventListener(Event.CLOSE, alert_closeHandler);
		}

		private function alert_closeHandler(event:Event, data:Object):void
		{
			if(data)
			{
				trace("alert closed with button:", data.label);
			}
			else
			{
				trace("alert closed without button");
			}
		}
	}
}
