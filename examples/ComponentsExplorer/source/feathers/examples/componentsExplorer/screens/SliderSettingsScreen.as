package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.List;
	import feathers.controls.NumericStepper;
	import feathers.controls.PanelScreen;
	import feathers.controls.PickerList;
	import feathers.controls.ToggleSwitch;
	import feathers.controls.TrackInteractionMode;
	import feathers.data.ArrayCollection;
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
			super();
		}

		public var settings:SliderSettings;

		private var _list:List;
		private var _liveDraggingToggle:ToggleSwitch;
		private var _stepStepper:NumericStepper;
		private var _pageStepper:NumericStepper;
		private var _trackInteractionModePicker:PickerList;

		override public function dispose():void
		{
			//icon and accessory display objects in the list's data provider
			//won't be automatically disposed because feathers cannot know if
			//they need to be used again elsewhere or not. we need to dispose
			//them manually.
			this._list.dataProvider.dispose(disposeItemAccessory);

			//never forget to call super.dispose() because you don't want to
			//create a memory leak!
			super.dispose();
		}

		override protected function initialize():void
		{
			//never forget to call super.initialize()
			super.initialize();

			this.title = "Slider Settings";

			this.layout = new AnchorLayout();

			this._liveDraggingToggle = new ToggleSwitch();
			this._liveDraggingToggle.isSelected = this.settings.liveDragging;
			this._liveDraggingToggle.addEventListener(Event.CHANGE, liveDraggingToggle_changeHandler);

			this._stepStepper = new NumericStepper();
			this._stepStepper.minimum = 1;
			this._stepStepper.maximum = 20;
			this._stepStepper.step = 1;
			this._stepStepper.value = this.settings.step;
			this._stepStepper.addEventListener(Event.CHANGE, stepStepper_changeHandler);

			this._trackInteractionModePicker = new PickerList();
			this._trackInteractionModePicker.typicalItem = TrackInteractionMode.TO_VALUE;
			this._trackInteractionModePicker.dataProvider = new ArrayCollection(
			[
				TrackInteractionMode.TO_VALUE,
				TrackInteractionMode.BY_PAGE,
			]);
			this._trackInteractionModePicker.selectedItem = this.settings.trackInteractionMode;
			this._trackInteractionModePicker.addEventListener(Event.CHANGE, trackInteractionModePicker_changeHandler);

			this._pageStepper = new NumericStepper();
			this._pageStepper.minimum = 1;
			this._pageStepper.maximum = 20;
			this._pageStepper.step = 1;
			this._pageStepper.value = this.settings.page;
			this._pageStepper.addEventListener(Event.CHANGE, pageStepper_changeHandler);

			this._list = new List();
			this._list.isSelectable = false;
			this._list.dataProvider = new ArrayCollection(
			[
				{ label: "liveDragging", accessory: this._liveDraggingToggle },
				{ label: "step", accessory: this._stepStepper },
				{ label: "trackInteractionMode", accessory: this._trackInteractionModePicker },
				{ label: "page", accessory: this._pageStepper },
			]);
			this._list.layoutData = new AnchorLayoutData(0, 0, 0, 0);
			this._list.clipContent = false;
			this._list.autoHideBackground = true;
			this.addChild(this._list);

			this.headerFactory = this.customHeaderFactory;

			this.backButtonHandler = this.onBackButton;
		}

		private function customHeaderFactory():Header
		{
			var header:Header = new Header();
			var doneButton:Button = new Button();
			doneButton.label = "Done";
			doneButton.addEventListener(Event.TRIGGERED, doneButton_triggeredHandler);
			header.rightItems = new <DisplayObject>
			[
				doneButton
			];
			return header;
		}

		private function disposeItemAccessory(item:Object):void
		{
			DisplayObject(item.accessory).dispose();
		}

		private function onBackButton():void
		{
			this.dispatchEventWith(Event.COMPLETE);
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

		private function trackInteractionModePicker_changeHandler(event:Event):void
		{
			this.settings.trackInteractionMode = this._trackInteractionModePicker.selectedItem as String;
		}

		private function doneButton_triggeredHandler(event:Event):void
		{
			this.onBackButton();
		}
	}
}
