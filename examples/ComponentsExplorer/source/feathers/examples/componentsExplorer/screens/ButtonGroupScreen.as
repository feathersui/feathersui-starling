package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.controls.PanelScreen;
	import feathers.data.ListCollection;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.system.DeviceCapabilities;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]

	public class ButtonGroupScreen extends PanelScreen
	{
		public function ButtonGroupScreen()
		{
			super();
		}

		private var _backButton:Button;
		private var _buttonGroup:ButtonGroup;

		override protected function initialize():void
		{
			//never forget to call super.initialize()
			super.initialize();

			this.layout = new AnchorLayout();

			this._buttonGroup = new ButtonGroup();
			this._buttonGroup.dataProvider = new ListCollection(
			[
				{ label: "One", triggered: button_triggeredHandler },
				{ label: "Two", triggered: button_triggeredHandler },
				{ label: "Three", triggered: button_triggeredHandler },
				{ label: "Four", triggered: button_triggeredHandler },
			]);
			var buttonGroupLayoutData:AnchorLayoutData = new AnchorLayoutData();
			buttonGroupLayoutData.horizontalCenter = 0;
			buttonGroupLayoutData.verticalCenter = 0;
			this._buttonGroup.layoutData = buttonGroupLayoutData;
			this.addChild(this._buttonGroup);

			this.headerProperties.title = "Button Group";

			if(!DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				this._backButton = new Button();
				this._backButton.styleNameList.add(Button.ALTERNATE_NAME_BACK_BUTTON);
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

		private function button_triggeredHandler(event:Event):void
		{
			var button:Button = Button(event.currentTarget);
			trace(button.label + " triggered.");
		}
	}
}
