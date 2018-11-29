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
	import feathers.controls.Toast;
	import feathers.controls.ButtonGroup;

	public class ToastScreen extends PanelScreen
	{
		public function ToastScreen()
		{
			super();
		}

		private var _showToastButtons:ButtonGroup;

		override protected function initialize():void
		{
			//never forget to call super.initialize()
			super.initialize();

			this.title = "Toast";

			this.layout = new AnchorLayout();

			this._showToastButtons = new ButtonGroup();
			this._showToastButtons.dataProvider = new ArrayCollection(
			[
				{ label: "Show Toast with Message", triggered: showMessageButton_triggeredHandler },
				{ label: "Show Toast with Actions", triggered: showActionsButton_triggeredHandler },
			])
			var buttonGroupLayoutData:AnchorLayoutData = new AnchorLayoutData();
			buttonGroupLayoutData.horizontalCenter = 0;
			buttonGroupLayoutData.verticalCenter = 0;
			this._showToastButtons.layoutData = buttonGroupLayoutData;
			this.addChild(this._showToastButtons);

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

		private function showMessageButton_triggeredHandler(event:Event):void
		{
			Toast.showMessage("Hi, there!");
		}

		private function showActionsButton_triggeredHandler(event:Event):void
		{
			Toast.showMessageWithActions("I have an action", new ArrayCollection(
			[
				{ label: "Neat!" }
			]));
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
