package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.controls.ToggleSwitch;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.examples.componentsExplorer.data.TextInputSettings;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;

	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]

	public class TextInputSettingsScreen extends PanelScreen
	{
		public function TextInputSettingsScreen()
		{
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}

		public var settings:TextInputSettings;

		private var _list:List;
		private var _backButton:Button;
		private var _displayAsPasswordToggle:ToggleSwitch;

		protected function initializeHandler(event:Event):void
		{
			this.layout = new AnchorLayout();

			this._displayAsPasswordToggle = new ToggleSwitch();
			this._displayAsPasswordToggle.isSelected = this.settings.displayAsPassword;
			this._displayAsPasswordToggle.addEventListener(Event.CHANGE, displayAsPasswordToggle_changeHandler);

			this._list = new List();
			this._list.isSelectable = false;
			this._list.dataProvider = new ListCollection(
			[
				{ label: "displayAsPassword", accessory: this._displayAsPasswordToggle },
			]);
			this._list.layoutData = new AnchorLayoutData(0, 0, 0, 0);
			this.addChild(this._list);

			this._backButton = new Button();
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);

			this.headerProperties.title = "Text Input Settings";
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

		private function displayAsPasswordToggle_changeHandler(event:Event):void
		{
			this.settings.displayAsPassword = this._displayAsPasswordToggle.isSelected;
		}

		private function backButton_triggeredHandler(event:Event):void
		{
			this.onBackButton();
		}
	}
}
