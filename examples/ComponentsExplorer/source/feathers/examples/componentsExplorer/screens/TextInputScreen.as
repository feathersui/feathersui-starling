package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.PanelScreen;
	import feathers.controls.TextInput;
	import feathers.events.FeathersEventType;
	import feathers.layout.VerticalLayout;
	import feathers.system.DeviceCapabilities;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]

	public class TextInputScreen extends PanelScreen
	{
		public function TextInputScreen()
		{
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}

		private var _backButton:Button;
		private var _input:TextInput;
		private var _disabledInput:TextInput;
		private var _passwordInput:TextInput;
		private var _notEditableInput:TextInput;
		private var _searchInput:TextInput;

		protected function initializeHandler(event:Event):void
		{
			var verticalLayout:VerticalLayout = new VerticalLayout();
			verticalLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			verticalLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			verticalLayout.padding = 20 * this.dpiScale;
			verticalLayout.gap = 16 * this.dpiScale;
			verticalLayout.manageVisibility = true;
			this.layout = verticalLayout;

			this._input = new TextInput();
			this._input.prompt = "Normal Text Input";
			this.addChild(this._input);

			this._disabledInput = new TextInput();
			this._disabledInput.prompt = "Disabled Input";
			this._disabledInput.isEnabled = false;
			this.addChild(this._disabledInput);

			this._searchInput = new TextInput();
			this._searchInput.styleNameList.add(TextInput.ALTERNATE_NAME_SEARCH_TEXT_INPUT);
			this._searchInput.prompt = "Search Input";
			this.addChild(this._searchInput);

			this._passwordInput = new TextInput();
			this._passwordInput.prompt = "Password Input";
			this._passwordInput.displayAsPassword = true;
			this.addChild(this._passwordInput);

			this._notEditableInput = new TextInput();
			this._notEditableInput.prompt = "Not Editable";
			this._notEditableInput.isEditable = false;
			this.addChild(this._notEditableInput);

			this.headerProperties.title = "Text Input";

			if(!DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				this._backButton = new Button();
				this._backButton.styleNameList.add(Button.ALTERNATE_NAME_BACK_BUTTON);
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
