package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.NumericStepper;
	import feathers.controls.PanelScreen;
	import feathers.controls.PickerList;
	import feathers.controls.Slider;
	import feathers.controls.ToggleSwitch;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.examples.componentsExplorer.data.SliderSettings;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;

	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]

	public class SliderSettingsScreen extends PanelScreen
	{
		public function SliderSettingsScreen()
		{
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}

		public var settings:SliderSettings;

		private var _list:List;
		private var _backButton:Button;
		private var _directionPicker:PickerList;
		private var _liveDraggingToggle:ToggleSwitch;
		private var _stepStepper:NumericStepper;
		private var _pageStepper:NumericStepper;

		protected function initializeHandler(event:Event):void
		{
			this.layout = new AnchorLayout();

			this._directionPicker = new PickerList();
			this._directionPicker.typicalItem = Slider.DIRECTION_HORIZONTAL;
			this._directionPicker.dataProvider = new ListCollection(new <String>
			[
				Slider.DIRECTION_HORIZONTAL,
				Slider.DIRECTION_VERTICAL
			]);
			this._directionPicker.listProperties.typicalItem = Slider.DIRECTION_HORIZONTAL;
			this._directionPicker.selectedItem = this.settings.direction;
			this._directionPicker.addEventListener(Event.CHANGE, directionPicker_changeHandler);

			this._liveDraggingToggle = new ToggleSwitch();
			this._liveDraggingToggle.isSelected = this.settings.liveDragging;
			this._liveDraggingToggle.addEventListener(Event.CHANGE, liveDraggingToggle_changeHandler);

			this._stepStepper = new NumericStepper();
			this._stepStepper.minimum = 1;
			this._stepStepper.maximum = 20;
			this._stepStepper.step = 1;
			this._stepStepper.value = this.settings.step;
			this._stepStepper.addEventListener(Event.CHANGE, stepStepper_changeHandler);

			this._pageStepper = new NumericStepper();
			this._pageStepper.minimum = 1;
			this._pageStepper.maximum = 20;
			this._pageStepper.step = 1;
			this._pageStepper.value = this.settings.page;
			this._pageStepper.addEventListener(Event.CHANGE, pageStepper_changeHandler);

			this._list = new List();
			this._list.isSelectable = false;
			this._list.dataProvider = new ListCollection(
			[
				{ label: "direction", accessory: this._directionPicker },
				{ label: "liveDragging", accessory: this._liveDraggingToggle },
				{ label: "step", accessory: this._stepStepper },
				{ label: "page", accessory: this._pageStepper },
			]);
			this._list.layoutData = new AnchorLayoutData(0, 0, 0, 0);
			this._list.clipContent = false;
			this._list.autoHideBackground = true;
			this.addChild(this._list);

			this._backButton = new Button();
			this._backButton.nameList.add(Button.ALTERNATE_NAME_BACK_BUTTON);
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);

			this.headerProperties.title = "Slider Settings";
			this.headerProperties.leftItems = new <DisplayObject>
			[
				this._backButton
			];

			this.backButtonHandler = this.onBackButton;
		}

		private function onBackButton():void
		{
			this.dispatchEventWith(Event.COMPLETE);
		}

		private function directionPicker_changeHandler(event:Event):void
		{
			this.settings.direction = this._directionPicker.selectedItem as String;
		}

		private function liveDraggingToggle_changeHandler(event:Event):void
		{
			this.settings.liveDragging = this._liveDraggingToggle.isSelected;
		}

		private function stepStepper_changeHandler(event:Event):void
		{
			this.settings.step = this._stepStepper.value;
		}

		private function pageStepper_changeHandler(event:Event):void
		{
			this.settings.page = this._pageStepper.value;
		}

		private function backButton_triggeredHandler(event:Event):void
		{
			this.onBackButton();
		}
	}
}
