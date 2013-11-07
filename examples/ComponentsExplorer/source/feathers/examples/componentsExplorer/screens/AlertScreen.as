package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Alert;
	import feathers.controls.Button;
	import feathers.controls.PanelScreen;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
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
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}

		private var _backButton:Button;
		private var _alertButton:Button;

		protected function initializeHandler(event:Event):void
		{
			this.layout = new AnchorLayout();

			this._alertButton = new Button();
			this._alertButton.label = "Show Alert";
			this._alertButton.addEventListener(Event.TRIGGERED, alertButton_triggeredHandler);
			const buttonGroupLayoutData:AnchorLayoutData = new AnchorLayoutData();
			buttonGroupLayoutData.horizontalCenter = 0;
			buttonGroupLayoutData.verticalCenter = 0;
			this._alertButton.layoutData = buttonGroupLayoutData;
			this.addChild(this._alertButton);

			this.headerProperties.title = "Alert";

			if(!DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				this._backButton = new Button();
				this._backButton.nameList.add(Button.ALTERNATE_NAME_BACK_BUTTON);
				this._backButton.label = "Back";
				this._backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);

				this.headerProperties.leftItems = new <DisplayObject>
				[
					this._backButton
				];

				this.backButtonHandler = this.onBackButton;
			}
		}

		private function onBackButton():void
		{
			this.dispatchEventWith(Event.COMPLETE);
		}

		private function backButton_triggeredHandler(event:Event):void
		{
			this.onBackButton();
		}

		private function alertButton_triggeredHandler(event:Event):void
		{
			Alert.show("I just wanted you to know that I have a very important message to share with you.", "Alert", new ListCollection(
			[
				{ label: "OK" }
			]));
		}
	}
}
