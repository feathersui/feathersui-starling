package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.NumericStepper;
	import feathers.controls.PanelScreen;
	import feathers.controls.PickerList;
	import feathers.controls.Slider;
	import feathers.controls.ToggleSwitch;
	import feathers.controls.renderers.BaseDefaultItemRenderer;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.examples.componentsExplorer.data.ItemRendererSettings;
	import feathers.examples.componentsExplorer.data.SliderSettings;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;

	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]

	public class ItemRendererSettingsScreen extends PanelScreen
	{
		public function ItemRendererSettingsScreen()
		{
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}

		public var settings:ItemRendererSettings;

		private var _list:List;
		private var _backButton:Button;
		private var _hasIconToggle:ToggleSwitch;
		private var _hasAccessoryToggle:ToggleSwitch;
		private var _layoutOrderPicker:PickerList;
		private var _iconPositionPicker:PickerList;
		private var _accessoryPositionPicker:PickerList;
		private var _accessoryTypePicker:PickerList;

		protected function initializeHandler(event:Event):void
		{
			this.layout = new AnchorLayout();

			this._hasIconToggle = new ToggleSwitch();
			this._hasIconToggle.isSelected = this.settings.hasIcon;
			this._hasIconToggle.addEventListener(Event.CHANGE, hasIconToggle_changeHandler);

			this._iconPositionPicker = new PickerList();
			this._iconPositionPicker.typicalItem = Button.ICON_POSITION_RIGHT_BASELINE;
			this._iconPositionPicker.dataProvider = new ListCollection(new <String>
			[
				Button.ICON_POSITION_TOP,
				Button.ICON_POSITION_RIGHT,
				Button.ICON_POSITION_BOTTOM,
				Button.ICON_POSITION_LEFT,
				Button.ICON_POSITION_LEFT_BASELINE,
				Button.ICON_POSITION_RIGHT_BASELINE,
				//Button.ICON_POSITION_MANUAL,
			]);
			this._iconPositionPicker.listProperties.typicalItem = Button.ICON_POSITION_RIGHT_BASELINE;
			this._iconPositionPicker.selectedItem = this.settings.iconPosition;
			this._iconPositionPicker.addEventListener(Event.CHANGE, iconPositionPicker_changeHandler);

			this._hasAccessoryToggle = new ToggleSwitch();
			this._hasAccessoryToggle.isSelected = this.settings.hasAccessory;
			this._hasAccessoryToggle.addEventListener(Event.CHANGE, hasAccessoryToggle_changeHandler);

			this._accessoryTypePicker = new PickerList();
			this._accessoryTypePicker.typicalItem = ItemRendererSettings.ACCESSORY_TYPE_DISPLAY_OBJECT;
			this._accessoryTypePicker.dataProvider = new ListCollection(new <String>
			[
				ItemRendererSettings.ACCESSORY_TYPE_DISPLAY_OBJECT,
				ItemRendererSettings.ACCESSORY_TYPE_TEXTURE,
				ItemRendererSettings.ACCESSORY_TYPE_LABEL,
			]);
			this._accessoryTypePicker.listProperties.typicalItem = ItemRendererSettings.ACCESSORY_TYPE_DISPLAY_OBJECT;
			this._accessoryTypePicker.selectedItem = this.settings.accessoryType;
			this._accessoryTypePicker.addEventListener(Event.CHANGE, accessoryTypePicker_changeHandler);

			this._accessoryPositionPicker = new PickerList();
			this._accessoryPositionPicker.typicalItem = BaseDefaultItemRenderer.ACCESSORY_POSITION_BOTTOM;
			this._accessoryPositionPicker.dataProvider = new ListCollection(new <String>
			[
				BaseDefaultItemRenderer.ACCESSORY_POSITION_TOP,
				BaseDefaultItemRenderer.ACCESSORY_POSITION_RIGHT,
				BaseDefaultItemRenderer.ACCESSORY_POSITION_BOTTOM,
				BaseDefaultItemRenderer.ACCESSORY_POSITION_LEFT,
				//BaseDefaultItemRenderer.ACCESSORY_POSITION_MANUAL,
			]);
			this._accessoryPositionPicker.listProperties.typicalItem = BaseDefaultItemRenderer.ACCESSORY_POSITION_BOTTOM;
			this._accessoryPositionPicker.selectedItem = this.settings.accessoryPosition;
			this._accessoryPositionPicker.addEventListener(Event.CHANGE, accessoryPositionPicker_changeHandler);

			this._layoutOrderPicker = new PickerList();
			this._layoutOrderPicker.typicalItem = BaseDefaultItemRenderer.LAYOUT_ORDER_LABEL_ACCESSORY_ICON;
			this._layoutOrderPicker.dataProvider = new ListCollection(new <String>
			[
				BaseDefaultItemRenderer.LAYOUT_ORDER_LABEL_ICON_ACCESSORY,
				BaseDefaultItemRenderer.LAYOUT_ORDER_LABEL_ACCESSORY_ICON,
			]);
			this._layoutOrderPicker.listProperties.typicalItem = BaseDefaultItemRenderer.LAYOUT_ORDER_LABEL_ACCESSORY_ICON;
			this._layoutOrderPicker.selectedItem = this.settings.layoutOrder;
			this._layoutOrderPicker.addEventListener(Event.CHANGE, layoutOrderPicker_changeHandler);

			this._list = new List();
			this._list.isSelectable = false;
			this._list.dataProvider = new ListCollection(
			[
				{ label: "Has Icon", accessory: this._hasIconToggle },
				{ label: "iconPosition", accessory: this._iconPositionPicker },
				{ label: "Has Accessory", accessory: this._hasAccessoryToggle },
				{ label: "Accessory Type", accessory: this._accessoryTypePicker },
				{ label: "accessoryPosition", accessory: this._accessoryPositionPicker },
				{ label: "layoutOrder", accessory: this._layoutOrderPicker },
			]);
			this._list.layoutData = new AnchorLayoutData(0, 0, 0, 0);
			this.addChild(this._list);

			this._backButton = new Button();
			this._backButton.nameList.add(Button.ALTERNATE_NAME_BACK_BUTTON);
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);

			this.headerProperties.title = "Item Renderer Settings";
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

		private function hasIconToggle_changeHandler(event:Event):void
		{
			this.settings.hasIcon = this._hasIconToggle.isSelected
		}

		private function iconPositionPicker_changeHandler(event:Event):void
		{
			this.settings.iconPosition = this._iconPositionPicker.selectedItem as String;
		}

		private function hasAccessoryToggle_changeHandler(event:Event):void
		{
			this.settings.hasAccessory = this._hasAccessoryToggle.isSelected
		}

		private function accessoryTypePicker_changeHandler(event:Event):void
		{
			this.settings.accessoryType = this._accessoryTypePicker.selectedItem as String;
		}

		private function accessoryPositionPicker_changeHandler(event:Event):void
		{
			this.settings.accessoryPosition = this._accessoryPositionPicker.selectedItem as String;
		}

		private function layoutOrderPicker_changeHandler(event:Event):void
		{
			this.settings.layoutOrder = this._layoutOrderPicker.selectedItem as String;
		}

		private function backButton_triggeredHandler(event:Event):void
		{
			this.onBackButton();
		}
	}
}
