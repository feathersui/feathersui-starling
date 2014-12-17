package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.List;
	import feathers.controls.NumericStepper;
	import feathers.controls.PanelScreen;
	import feathers.data.ListCollection;
	import feathers.examples.componentsExplorer.data.NumericStepperSettings;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;

	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]

	public class NumericStepperSettingsScreen extends PanelScreen
	{
		public function NumericStepperSettingsScreen()
		{
			super();
		}

		public var settings:NumericStepperSettings;

		private var _list:List;
		private var _doneButton:Button;
		private var _stepStepper:NumericStepper;

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

			this.title = "Numeric Stepper Settings";

			this.layout = new AnchorLayout();

			this._stepStepper = new NumericStepper();
			this._stepStepper.minimum = 1;
			this._stepStepper.maximum = 20;
			this._stepStepper.step = 1;
			this._stepStepper.value = this.settings.step;
			this._stepStepper.addEventListener(Event.CHANGE, stepStepper_changeHandler);

			this._list = new List();
			this._list.isSelectable = false;
			this._list.dataProvider = new ListCollection(
			[
				{ label: "step", accessory: this._stepStepper },
			]);
			this._list.layoutData = new AnchorLayoutData(0, 0, 0, 0);
			this._list.clipContent = false;
			this._list.autoHideBackground = true;
			this.addChild(this._list);

			this._doneButton = new Button();
			this._doneButton.label = "Done";
			this._doneButton.addEventListener(Event.TRIGGERED, doneButton_triggeredHandler);
			//we'll add this as a child in the header factory

			this.headerFactory = this.customHeaderFactory;

			this.backButtonHandler = this.onBackButton;
		}

		private function customHeaderFactory():Header
		{
			var header:Header = new Header();
			header.rightItems = new <DisplayObject>
			[
				this._doneButton
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

		private function stepStepper_changeHandler(event:Event):void
		{
			this.settings.step = this._stepStepper.value;
		}

		private function doneButton_triggeredHandler(event:Event):void
		{
			this.onBackButton();
		}
	}
}
