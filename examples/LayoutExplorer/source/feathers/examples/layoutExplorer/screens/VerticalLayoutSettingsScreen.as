package feathers.examples.layoutExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.List;
	import feathers.controls.NumericStepper;
	import feathers.controls.PanelScreen;
	import feathers.controls.PickerList;
	import feathers.data.ListCollection;
	import feathers.examples.layoutExplorer.data.VerticalLayoutSettings;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.VerticalAlign;

	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]

	public class VerticalLayoutSettingsScreen extends PanelScreen
	{
		public function VerticalLayoutSettingsScreen()
		{
			super();
		}

		public var settings:VerticalLayoutSettings;

		private var _list:List;

		private var _itemCountStepper:NumericStepper;
		private var _gapStepper:NumericStepper;
		private var _paddingTopStepper:NumericStepper;
		private var _paddingRightStepper:NumericStepper;
		private var _paddingBottomStepper:NumericStepper;
		private var _paddingLeftStepper:NumericStepper;
		private var _horizontalAlignPicker:PickerList;
		private var _verticalAlignPicker:PickerList;

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

			this.title = "Vertical Layout Settings";

			this.layout = new AnchorLayout();

			this._itemCountStepper = new NumericStepper();
			this._itemCountStepper.minimum = 1;
			//the layout can certainly handle more. this value is arbitrary.
			this._itemCountStepper.maximum = 100;
			this._itemCountStepper.step = 1;
			this._itemCountStepper.value = this.settings.itemCount;
			this._itemCountStepper.addEventListener(Event.CHANGE, itemCountStepper_changeHandler);

			this._horizontalAlignPicker = new PickerList();
			this._horizontalAlignPicker.typicalItem = HorizontalAlign.CENTER;
			this._horizontalAlignPicker.dataProvider = new ListCollection(new <String>
			[
				HorizontalAlign.LEFT,
				HorizontalAlign.CENTER,
				HorizontalAlign.RIGHT,
				HorizontalAlign.JUSTIFY
			]);
			this._horizontalAlignPicker.selectedItem = this.settings.horizontalAlign;
			this._horizontalAlignPicker.addEventListener(Event.CHANGE, horizontalAlignPicker_changeHandler);

			this._verticalAlignPicker = new PickerList();
			this._verticalAlignPicker.typicalItem = VerticalAlign.BOTTOM;
			this._verticalAlignPicker.dataProvider = new ListCollection(new <String>
			[
				VerticalAlign.TOP,
				VerticalAlign.MIDDLE,
				VerticalAlign.BOTTOM
			]);
			this._verticalAlignPicker.selectedItem = this.settings.verticalAlign;
			this._verticalAlignPicker.addEventListener(Event.CHANGE, verticalAlignPicker_changeHandler);

			this._gapStepper = new NumericStepper();
			this._gapStepper.minimum = 0;
			//these maximum values are completely arbitrary
			this._gapStepper.maximum = 100;
			this._gapStepper.step = 1;
			this._gapStepper.value = this.settings.gap;
			this._gapStepper.addEventListener(Event.CHANGE, gapStepper_changeHandler);

			this._paddingTopStepper = new NumericStepper();
			this._paddingTopStepper.minimum = 0;
			this._paddingTopStepper.maximum = 100;
			this._paddingTopStepper.step = 1;
			this._paddingTopStepper.value = this.settings.paddingTop;
			this._paddingTopStepper.addEventListener(Event.CHANGE, paddingTopStepper_changeHandler);

			this._paddingRightStepper = new NumericStepper();
			this._paddingRightStepper.minimum = 0;
			this._paddingRightStepper.maximum = 100;
			this._paddingRightStepper.step = 1;
			this._paddingRightStepper.value = this.settings.paddingRight;
			this._paddingRightStepper.addEventListener(Event.CHANGE, paddingRightStepper_changeHandler);

			this._paddingBottomStepper = new NumericStepper();
			this._paddingBottomStepper.minimum = 0;
			this._paddingBottomStepper.maximum = 100;
			this._paddingBottomStepper.step = 1;
			this._paddingBottomStepper.value = this.settings.paddingBottom;
			this._paddingBottomStepper.addEventListener(Event.CHANGE, paddingBottomStepper_changeHandler);

			this._paddingLeftStepper = new NumericStepper();
			this._paddingLeftStepper.minimum = 0;
			this._paddingLeftStepper.maximum = 100;
			this._paddingLeftStepper.step = 1;
			this._paddingLeftStepper.value = this.settings.paddingLeft;
			this._paddingLeftStepper.addEventListener(Event.CHANGE, paddingLeftStepper_changeHandler);

			this._list = new List();
			this._list.isSelectable = false;
			this._list.dataProvider = new ListCollection(
			[
				{ label: "Item Count", accessory: this._itemCountStepper },
				{ label: "horizontalAlign", accessory: this._horizontalAlignPicker },
				{ label: "verticalAlign", accessory: this._verticalAlignPicker },
				{ label: "gap", accessory: this._gapStepper },
				{ label: "paddingTop", accessory: this._paddingTopStepper },
				{ label: "paddingRight", accessory: this._paddingRightStepper },
				{ label: "paddingBottom", accessory: this._paddingBottomStepper },
				{ label: "paddingLeft", accessory: this._paddingLeftStepper },
			]);
			this._list.layoutData = new AnchorLayoutData(0, 0, 0, 0);
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

		private function doneButton_triggeredHandler(event:Event):void
		{
			this.onBackButton();
		}

		private function itemCountStepper_changeHandler(event:Event):void
		{
			this.settings.itemCount = this._itemCountStepper.value;
		}

		private function horizontalAlignPicker_changeHandler(event:Event):void
		{
			this.settings.horizontalAlign = this._horizontalAlignPicker.selectedItem as String;
		}

		private function verticalAlignPicker_changeHandler(event:Event):void
		{
			this.settings.verticalAlign = this._verticalAlignPicker.selectedItem as String;
		}

		private function gapStepper_changeHandler(event:Event):void
		{
			this.settings.gap = this._gapStepper.value;
		}

		private function paddingTopStepper_changeHandler(event:Event):void
		{
			this.settings.paddingTop = this._paddingTopStepper.value;
		}

		private function paddingRightStepper_changeHandler(event:Event):void
		{
			this.settings.paddingRight = this._paddingRightStepper.value;
		}

		private function paddingBottomStepper_changeHandler(event:Event):void
		{
			this.settings.paddingBottom = this._paddingBottomStepper.value;
		}

		private function paddingLeftStepper_changeHandler(event:Event):void
		{
			this.settings.paddingLeft = this._paddingLeftStepper.value;
		}
	}
}
