package feathers.examples.layoutExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.PanelScreen;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.system.DeviceCapabilities;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]

	public class AnchorLayoutScreen extends PanelScreen
	{
		public function AnchorLayoutScreen()
		{
			super();
		}

		private var _backButton:Button;

		override protected function initialize():void
		{
			//never forget to call super.initialize()
			super.initialize();

			this.title = "Anchor Layout";

			this.layout = new AnchorLayout();

			var centeredLayoutData:AnchorLayoutData = new AnchorLayoutData();
			centeredLayoutData.horizontalCenter = 0;
			centeredLayoutData.verticalCenter = 0;
			var label1:Label = new Label();
			label1.text = "(Rotate device to see the layout update!)";
			label1.layoutData = centeredLayoutData;
			this.addChild(label1);

			var topRightLayoutData:AnchorLayoutData = new AnchorLayoutData();
			topRightLayoutData.top = 20;
			topRightLayoutData.right = 20;
			var button1:Button = new Button();
			button1.label = "This button is positioned\nat the top right corner.";
			button1.layoutData = topRightLayoutData;
			this.addChild(button1);

			var fillBottomLayoutData:AnchorLayoutData = new AnchorLayoutData();
			fillBottomLayoutData.left = 20;
			fillBottomLayoutData.right = 20;
			fillBottomLayoutData.bottom = 20;
			var button2:Button = new Button();
			button2.label = "This button stretches across the bottom.";
			button2.layoutData = fillBottomLayoutData;
			this.addChild(button2);

			var relativeLayoutData:AnchorLayoutData = new AnchorLayoutData();
			relativeLayoutData.bottom = 20;
			relativeLayoutData.bottomAnchorDisplayObject = button2;
			relativeLayoutData.horizontalCenter = 0;
			var label2:Label = new Label();
			label2.text = "The label is positioned relative to the button.";
			label2.layoutData = relativeLayoutData;
			this.addChild(label2);

			if(!DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				this._backButton = new Button();
				this._backButton.styleNameList.add(Button.ALTERNATE_STYLE_NAME_BACK_BUTTON);
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
	}
}
