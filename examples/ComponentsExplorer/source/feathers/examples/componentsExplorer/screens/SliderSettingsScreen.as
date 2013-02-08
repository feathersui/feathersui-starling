package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.List;
	import feathers.controls.PickerList;
	import feathers.controls.Screen;
	import feathers.controls.Slider;
	import feathers.controls.ToggleSwitch;
	import feathers.data.ListCollection;
	import feathers.examples.componentsExplorer.data.SliderSettings;

	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]

	public class SliderSettingsScreen extends Screen
	{
		public function SliderSettingsScreen()
		{
		}

		public var settings:SliderSettings;

		private var _header:Header;
		private var _list:List;
		private var _backButton:Button;
		private var _directionPicker:PickerList;
		private var _liveDraggingToggle:ToggleSwitch;
		private var _stepSlider:Slider;
		private var _pageSlider:Slider;

		override protected function initialize():void
		{
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

			this._stepSlider = new Slider();
			this._stepSlider.minimum = 1;
			this._stepSlider.maximum = 20;
			this._stepSlider.step = 1;
			this._stepSlider.value = this.settings.step;
			this._stepSlider.addEventListener(Event.CHANGE, stepSlider_changeHandler);

			this._pageSlider = new Slider();
			this._pageSlider.minimum = 1;
			this._pageSlider.maximum = 20;
			this._pageSlider.step = 1;
			this._pageSlider.value = this.settings.page;
			this._pageSlider.addEventListener(Event.CHANGE, pageSlider_changeHandler);

			this._list = new List();
			this._list.isSelectable = false;
			this._list.dataProvider = new ListCollection(
			[
				{ label: "direction", accessory: this._directionPicker },
				{ label: "liveDragging", accessory: this._liveDraggingToggle },
				{ label: "step", accessory: this._stepSlider },
				{ label: "page", accessory: this._pageSlider },
			]);
			this.addChild(this._list);

			this._backButton = new Button();
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);

			this._header = new Header();
			this._header.title = "Slider Settings";
			this.addChild(this._header);
			this._header.leftItems = new <DisplayObject>
			[
				this._backButton
			];

			this.backButtonHandler = this.onBackButton;
		}

		override protected function draw():void
		{
			this._header.width = this.actualWidth;
			this._header.validate();

			this._list.y = this._header.height;
			this._list.width = this.actualWidth;
			this._list.height = this.actualHeight - this._list.y;
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

		private function stepSlider_changeHandler(event:Event):void
		{
			this.settings.step = this._stepSlider.value;
		}

		private function pageSlider_changeHandler(event:Event):void
		{
			this.settings.page = this._pageSlider.value;
		}

		private function backButton_triggeredHandler(event:Event):void
		{
			this.onBackButton();
		}
	}
}
