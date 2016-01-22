package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.PanelScreen;
	import feathers.controls.ToggleButton;
	import feathers.skins.IStyleProvider;
	import feathers.system.DeviceCapabilities;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]

	public class ButtonScreen extends PanelScreen
	{
		public static var globalStyleProvider:IStyleProvider;

		public static const CHILD_STYLE_NAME_ICON_BUTTON:String = "components-explorer-button-screen-icon-button";
		
		public function ButtonScreen()
		{
			super();
		}

		private var _normalButton:Button;
		private var _disabledButton:Button;
		private var _iconButton:Button;
		private var _toggleButton:ToggleButton;
		private var _callToActionButton:Button;
		private var _quietButton:Button;
		private var _dangerButton:Button;
		private var _sampleBackButton:Button;
		private var _forwardButton:Button;

		override protected function get defaultStyleProvider():IStyleProvider
		{
			return ButtonScreen.globalStyleProvider;
		}
		
		override protected function initialize():void
		{
			//never forget to call super.initialize()
			super.initialize();

			this.title = "Button";
			
			this._normalButton = new Button();
			this._normalButton.label = "Normal Button";
			this._normalButton.addEventListener(Event.TRIGGERED, normalButton_triggeredHandler);
			this.addChild(this._normalButton);

			this._disabledButton = new Button();
			this._disabledButton.label = "Disabled Button";
			this._disabledButton.isEnabled = false;
			this.addChild(this._disabledButton);
			
			this._iconButton = new Button();
			//since it's a skin, we'll specify an icon in the theme
			this._iconButton.styleNameList.add(CHILD_STYLE_NAME_ICON_BUTTON);
			this._iconButton.label = "Icon Button";
			this.addChild(this._iconButton);

			this._toggleButton = new ToggleButton();
			this._toggleButton.label = "Toggle Button";
			this._toggleButton.isSelected = true;
			this._toggleButton.addEventListener(Event.CHANGE, toggleButton_changeHandler);
			this.addChild(this._toggleButton);

			this._callToActionButton = new Button();
			this._callToActionButton.styleNameList.add(Button.ALTERNATE_STYLE_NAME_CALL_TO_ACTION_BUTTON);
			this._callToActionButton.label = "Call to Action Button";
			this.addChild(this._callToActionButton);

			this._dangerButton = new Button();
			this._dangerButton.styleNameList.add(Button.ALTERNATE_STYLE_NAME_DANGER_BUTTON);
			this._dangerButton.label = "Danger Button";
			this.addChild(this._dangerButton);

			this._sampleBackButton = new Button();
			this._sampleBackButton.styleNameList.add(Button.ALTERNATE_STYLE_NAME_BACK_BUTTON);
			this._sampleBackButton.label = "Back Button";
			this.addChild(this._sampleBackButton);

			this._forwardButton = new Button();
			this._forwardButton.styleNameList.add(Button.ALTERNATE_STYLE_NAME_FORWARD_BUTTON);
			this._forwardButton.label = "Forward Button";
			this.addChild(this._forwardButton);

			this.headerFactory = this.customHeaderFactory;

			//this screen doesn't use a back button on tablets because the main
			//app's uses a split layout
			if(!DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				this.backButtonHandler = this.onBackButton;
			}
		}

		private function customHeaderFactory():Header
		{
			var header:Header = new Header();
			//this screen doesn't use a back button on tablets because the main
			//app's uses a split layout
			if(!DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				var backButton:Button = new Button();
				backButton.styleNameList.add(Button.ALTERNATE_STYLE_NAME_BACK_BUTTON);
				backButton.label = "Back";
				backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);
				header.leftItems = new <DisplayObject>
				[
					backButton
				];
			}
			this._quietButton = new Button();
			this._quietButton.styleNameList.add(Button.ALTERNATE_STYLE_NAME_QUIET_BUTTON);
			this._quietButton.label = "Quiet Button";
			header.rightItems = new <DisplayObject>
			[
				this._quietButton
			];
			return header;
		}
		
		private function onBackButton():void
		{
			this.dispatchEventWith(Event.COMPLETE);
		}

		private function normalButton_triggeredHandler(event:Event):void
		{
			trace("normal button triggered.")
		}

		private function toggleButton_changeHandler(event:Event):void
		{
			trace("toggle button changed:", this._toggleButton.isSelected);
		}
		
		private function backButton_triggeredHandler(event:Event):void
		{
			this.onBackButton();
		}
	}
}