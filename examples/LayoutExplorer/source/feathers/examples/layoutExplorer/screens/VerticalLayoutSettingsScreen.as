package feathers.examples.layoutExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.List;
	import feathers.controls.PickerList;
	import feathers.controls.Screen;
	import feathers.controls.Slider;
	import feathers.data.ListCollection;
	import feathers.examples.layoutExplorer.data.VerticalLayoutSettings;
	import feathers.layout.VerticalLayout;

	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]

	public class VerticalLayoutSettingsScreen extends Screen
	{
		public function VerticalLayoutSettingsScreen()
		{
		}

		public var settings:VerticalLayoutSettings;

		private var _header:Header;
		private var _list:List;
		private var _backButton:Button;

		private var _itemCountSlider:Slider;
		private var _gapSlider:Slider;
		private var _paddingTopSlider:Slider;
		private var _paddingRightSlider:Slider;
		private var _paddingBottomSlider:Slider;
		private var _paddingLeftSlider:Slider;
		private var _horizontalAlignPicker:PickerList;
		private var _verticalAlignPicker:PickerList;

		override protected function initialize():void
		{
			this._itemCountSlider = new Slider();
			this._itemCountSlider.direction = Slider.DIRECTION_HORIZONTAL;
			this._itemCountSlider.minimum = 1;
			this._itemCountSlider.maximum = 100;
			this._itemCountSlider.step = 1;
			this._itemCountSlider.value = this.settings.itemCount;
			this._itemCountSlider.addEventListener(Event.CHANGE, itemCountSlider_changeHandler);

			this._horizontalAlignPicker = new PickerList();
			this._horizontalAlignPicker.typicalItem = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			this._horizontalAlignPicker.dataProvider = new ListCollection(new <String>
			[
				VerticalLayout.HORIZONTAL_ALIGN_LEFT,
				VerticalLayout.HORIZONTAL_ALIGN_CENTER,
				VerticalLayout.HORIZONTAL_ALIGN_RIGHT,
				VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY
			]);
			this._horizontalAlignPicker.selectedItem = this.settings.horizontalAlign;
			this._horizontalAlignPicker.addEventListener(Event.CHANGE, horizontalAlignPicker_changeHandler);

			this._verticalAlignPicker = new PickerList();
			this._verticalAlignPicker.typicalItem = VerticalLayout.VERTICAL_ALIGN_BOTTOM;
			this._verticalAlignPicker.dataProvider = new ListCollection(new <String>
			[
				VerticalLayout.VERTICAL_ALIGN_TOP,
				VerticalLayout.VERTICAL_ALIGN_MIDDLE,
				VerticalLayout.VERTICAL_ALIGN_BOTTOM
			]);
			this._verticalAlignPicker.selectedItem = this.settings.verticalAlign;
			this._verticalAlignPicker.addEventListener(Event.CHANGE, verticalAlignPicker_changeHandler);

			this._gapSlider = new Slider();
			this._gapSlider.direction = Slider.DIRECTION_HORIZONTAL;
			this._gapSlider.minimum = 0;
			this._gapSlider.maximum = 100;
			this._gapSlider.step = 1;
			this._gapSlider.value = this.settings.gap;
			this._gapSlider.addEventListener(Event.CHANGE, gapSlider_changeHandler);

			this._paddingTopSlider = new Slider();
			this._paddingTopSlider.direction = Slider.DIRECTION_HORIZONTAL;
			this._paddingTopSlider.minimum = 0;
			this._paddingTopSlider.maximum = 100;
			this._paddingTopSlider.step = 1;
			this._paddingTopSlider.value = this.settings.paddingTop;
			this._paddingTopSlider.addEventListener(Event.CHANGE, paddingTopSlider_changeHandler);

			this._paddingRightSlider = new Slider();
			this._paddingRightSlider.direction = Slider.DIRECTION_HORIZONTAL;
			this._paddingRightSlider.minimum = 0;
			this._paddingRightSlider.maximum = 100;
			this._paddingRightSlider.step = 1;
			this._paddingRightSlider.value = this.settings.paddingRight;
			this._paddingRightSlider.addEventListener(Event.CHANGE, paddingRightSlider_changeHandler);

			this._paddingBottomSlider = new Slider();
			this._paddingBottomSlider.direction = Slider.DIRECTION_HORIZONTAL;
			this._paddingBottomSlider.minimum = 0;
			this._paddingBottomSlider.maximum = 100;
			this._paddingBottomSlider.step = 1;
			this._paddingBottomSlider.value = this.settings.paddingBottom;
			this._paddingBottomSlider.addEventListener(Event.CHANGE, paddingBottomSlider_changeHandler);

			this._paddingLeftSlider = new Slider();
			this._paddingLeftSlider.direction = Slider.DIRECTION_HORIZONTAL;
			this._paddingLeftSlider.minimum = 0;
			this._paddingLeftSlider.maximum = 100;
			this._paddingLeftSlider.step = 1;
			this._paddingLeftSlider.value = this.settings.paddingLeft;
			this._paddingLeftSlider.addEventListener(Event.CHANGE, paddingLeftSlider_changeHandler);

			this._list = new List();
			this._list.isSelectable = false;
			this._list.dataProvider = new ListCollection(
			[
				{ label: "Item Count", accessory: this._itemCountSlider },
				{ label: "horizontalAlign", accessory: this._horizontalAlignPicker },
				{ label: "verticalAlign", accessory: this._verticalAlignPicker },
				{ label: "gap", accessory: this._gapSlider },
				{ label: "paddingTop", accessory: this._paddingTopSlider },
				{ label: "paddingRight", accessory: this._paddingRightSlider },
				{ label: "paddingBottom", accessory: this._paddingBottomSlider },
				{ label: "paddingLeft", accessory: this._paddingLeftSlider },
			]);
			this.addChild(this._list);

			this._backButton = new Button();
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);

			this._header = new Header();
			this._header.title = "Vertical Layout Settings";
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

		private function backButton_triggeredHandler(event:Event):void
		{
			this.onBackButton();
		}

		private function itemCountSlider_changeHandler(event:Event):void
		{
			this.settings.itemCount = this._itemCountSlider.value;
		}

		private function horizontalAlignPicker_changeHandler(event:Event):void
		{
			this.settings.horizontalAlign = this._horizontalAlignPicker.selectedItem as String;
		}

		private function verticalAlignPicker_changeHandler(event:Event):void
		{
			this.settings.verticalAlign = this._verticalAlignPicker.selectedItem as String;
		}

		private function gapSlider_changeHandler(event:Event):void
		{
			this.settings.gap = this._gapSlider.value;
		}

		private function paddingTopSlider_changeHandler(event:Event):void
		{
			this.settings.paddingTop = this._paddingTopSlider.value;
		}

		private function paddingRightSlider_changeHandler(event:Event):void
		{
			this.settings.paddingRight = this._paddingRightSlider.value;
		}

		private function paddingBottomSlider_changeHandler(event:Event):void
		{
			this.settings.paddingBottom = this._paddingBottomSlider.value;
		}

		private function paddingLeftSlider_changeHandler(event:Event):void
		{
			this.settings.paddingLeft = this._paddingLeftSlider.value;
		}
	}
}
