package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.List;
	import feathers.controls.Screen;
	import feathers.controls.ToggleSwitch;
	import feathers.data.ListCollection;
	import feathers.examples.componentsExplorer.data.ListSettings;

	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]

	public class ListSettingsScreen extends Screen
	{
		public function ListSettingsScreen()
		{
		}

		public var settings:ListSettings;

		private var _header:Header;
		private var _list:List;
		private var _backButton:Button;

		private var _isSelectableToggle:ToggleSwitch;
		private var _hasElasticEdgesToggle:ToggleSwitch;

		override protected function initialize():void
		{
			this._isSelectableToggle = new ToggleSwitch();
			this._isSelectableToggle.isSelected = this.settings.isSelectable;
			this._isSelectableToggle.addEventListener(Event.CHANGE, isSelectableToggle_changeHandler);

			this._hasElasticEdgesToggle = new ToggleSwitch();
			this._hasElasticEdgesToggle.isSelected = this.settings.hasElasticEdges;
			this._hasElasticEdgesToggle.addEventListener(Event.CHANGE, hasElasticEdgesToggle_changeHandler);

			this._list = new List();
			this._list.isSelectable = false;
			this._list.dataProvider = new ListCollection(
			[
				{ label: "isSelectable", accessory: this._isSelectableToggle },
				{ label: "hasElasticEdges", accessory: this._hasElasticEdgesToggle },
			]);
			this.addChild(this._list);

			this._backButton = new Button();
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);

			this._header = new Header();
			this._header.title = "List Settings";
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

		private function isSelectableToggle_changeHandler(event:Event):void
		{
			this.settings.isSelectable = this._isSelectableToggle.isSelected;
		}

		private function hasElasticEdgesToggle_changeHandler(event:Event):void
		{
			this.settings.hasElasticEdges = this._hasElasticEdgesToggle.isSelected;
		}
	}
}
