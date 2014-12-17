package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Label;
	import feathers.controls.PanelScreen;
	import feathers.skins.IStyleProvider;
	import feathers.system.DeviceCapabilities;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]

	public class LabelScreen extends PanelScreen
	{
		public static var globalStyleProvider:IStyleProvider;

		public function LabelScreen()
		{
			super();
		}

		private var _normalLabel:Label;
		private var _disabledLabel:Label;
		private var _headingLabel:Label;
		private var _detailLabel:Label;

		private var _backButton:Button;

		override protected function get defaultStyleProvider():IStyleProvider
		{
			return LabelScreen.globalStyleProvider;
		}

		override protected function initialize():void
		{
			//never forget to call super.initialize()
			super.initialize();

			this._normalLabel = new Label();
			this._normalLabel.text = "This is a normal label.";
			this.addChild(this._normalLabel);

			this._disabledLabel = new Label();
			this._disabledLabel.text = "A label may be disabled.";
			this._disabledLabel.isEnabled = false;
			this.addChild(this._disabledLabel);

			this._headingLabel = new Label();
			this._headingLabel.styleNameList.add(Label.ALTERNATE_STYLE_NAME_HEADING);
			this._headingLabel.text = "A heading label is for larger, more important text.";
			this.addChild(this._headingLabel);

			this._detailLabel = new Label();
			this._detailLabel.styleNameList.add(Label.ALTERNATE_STYLE_NAME_DETAIL);
			this._detailLabel.text = "While a detail label is for smaller, less important text.";
			this.addChild(this._detailLabel);

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
			header.title = "Label";
			if(this._backButton)
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
	}
}