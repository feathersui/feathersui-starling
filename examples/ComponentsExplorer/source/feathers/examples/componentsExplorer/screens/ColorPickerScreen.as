package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.PanelScreen;
	import feathers.controls.color.ColorPicker;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.system.DeviceCapabilities;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;

	public class ColorPickerScreen extends PanelScreen
	{
		public function ColorPickerScreen()
		{
			super();
		}

		private var _colorPicker:ColorPicker;

		override protected function initialize():void
		{
			//never forget to call super.initialize()
			super.initialize();

			this.title = "Color Picker";

			this.layout = new AnchorLayout();

			this._colorPicker = new ColorPicker();
			this._colorPicker.addEventListener(Event.CHANGE, colorPicker_changeHandler);
			var colorPickerLayoutData:AnchorLayoutData = new AnchorLayoutData();
			colorPickerLayoutData.horizontalCenter = 0;
			colorPickerLayoutData.verticalCenter = 0;
			this._colorPicker.layoutData = colorPickerLayoutData;
			this.addChild(this._colorPicker);

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

		private function colorPicker_changeHandler(event:Event):void
		{
			trace("color picker change:", this._colorPicker.color.toString(16));
		}
	}
}
