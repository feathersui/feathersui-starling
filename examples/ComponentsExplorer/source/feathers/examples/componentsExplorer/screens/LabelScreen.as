package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.PanelScreen;
	import feathers.events.FeathersEventType;
	import feathers.layout.VerticalLayout;
	import feathers.system.DeviceCapabilities;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]

	public class LabelScreen extends PanelScreen
	{
		public function LabelScreen()
		{
			super();
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}

		private var _normalLabel:Label;
		private var _disabledLabel:Label;
		private var _headingLabel:Label;
		private var _detailLabel:Label;

		private var _backButton:Button;

		protected function initializeHandler(event:Event):void
		{
			const verticalLayout:VerticalLayout = new VerticalLayout();
			verticalLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			verticalLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			verticalLayout.padding = 20 * this.dpiScale;
			verticalLayout.gap = 16 * this.dpiScale;
			verticalLayout.manageVisibility = true;
			this.layout = verticalLayout;

			this._normalLabel = new Label();
			this._normalLabel.text = "This is a normal label.";
			this.addChild(this._normalLabel);

			this._disabledLabel = new Label();
			this._disabledLabel.text = "A label may be disabled.";
			this._disabledLabel.isEnabled = false;
			this.addChild(this._disabledLabel);

			this._headingLabel = new Label();
			this._headingLabel.nameList.add(Label.ALTERNATE_NAME_HEADING);
			this._headingLabel.text = "A heading label is for larger, more important text.";
			this.addChild(this._headingLabel);

			this._detailLabel = new Label();
			this._detailLabel.nameList.add(Label.ALTERNATE_NAME_DETAIL);
			this._detailLabel.text = "While a detail label is for smaller, less important text.";
			this.addChild(this._detailLabel);

			this.headerProperties.title = "Label";

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
	}
}