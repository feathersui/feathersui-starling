package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Alert;
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.PanelScreen;
	import feathers.data.ArrayCollection;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;

	import starling.events.Event;
	import feathers.system.DeviceCapabilities;
	import starling.core.Starling;
	import starling.display.DisplayObject;

	public class AlertScreen extends PanelScreen
	{
		public function AlertScreen()
		{
			super();
		}

		private var _showAlertButton:Button;

		override protected function initialize():void
		{
			//never forget to call super.initialize()
			super.initialize();

			this.title = "Alert";

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
			var alert:Alert = Alert.show("I just wanted you to know that I have a very important message to share with you.", "Alert", new ArrayCollection(
			[
				{ label: "OK" },
				{ label: "Cancel" }
			]));
			//when the enter key is pressed, treat it as OK
			alert.acceptButtonIndex = 0;
			//when the back or escape key is pressed, treat it as cancel
			alert.cancelButtonIndex = 1;
			alert.addEventListener(Event.CLOSE, alert_closeHandler);
		}

		private function alert_closeHandler(event:Event, data:Object):void
		{
			if(data)
			{
				trace("alert closed with item:", data.label);
			}
			else
			{
				trace("alert closed without item");
			}
		}
	}
}
