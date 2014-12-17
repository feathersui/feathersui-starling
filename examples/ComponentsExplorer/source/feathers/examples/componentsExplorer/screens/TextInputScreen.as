package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.PanelScreen;
	import feathers.controls.TextInput;
	import feathers.skins.IStyleProvider;
	import feathers.system.DeviceCapabilities;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]

	public class TextInputScreen extends PanelScreen
	{
		public static var globalStyleProvider:IStyleProvider;

		public function TextInputScreen()
		{
		}

		private var _backButton:Button;
		private var _input:TextInput;
		private var _disabledInput:TextInput;
		private var _passwordInput:TextInput;
		private var _notEditableInput:TextInput;
		private var _searchInput:TextInput;

		override protected function get defaultStyleProvider():IStyleProvider
		{
			return TextInputScreen.globalStyleProvider;
		}

		override protected function initialize():void
		{
			//never forget to call super.initialize()
			super.initialize();

			this.title = "Text Input";

			this._input = new TextInput();
			this._input.prompt = "Normal Text Input";
			this.addChild(this._input);

			this._disabledInput = new TextInput();
			this._disabledInput.prompt = "Disabled Input";
			this._disabledInput.isEnabled = false;
			this.addChild(this._disabledInput);

			this._searchInput = new TextInput();
			this._searchInput.styleNameList.add(TextInput.ALTERNATE_STYLE_NAME_SEARCH_TEXT_INPUT);
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

			this.headerFactory = this.customHeaderFactory;

			//we don't display the back button on tablets because the app's
			//layout puts the main component list side by side with the selected
			//component.
			if(!DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				this._backButton = new Button();
				this._backButton.styleNameList.add(Button.ALTERNATE_STYLE_NAME_BACK_BUTTON);
				this._backButton.label = "Back";
				this._backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);
				//we'll add this as a child in the header factory

				this.backButtonHandler = this.onBackButton;
			}
		}

		private function customHeaderFactory():Header
		{
			var header:Header = new Header();
			if(!DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				header.leftItems = new <DisplayObject>
				[
					this._backButton
				];
			}
			return header;
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
