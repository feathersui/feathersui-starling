package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.ImageLoader;
	import feathers.controls.PanelScreen;
	import feathers.controls.ScrollPolicy;
	import feathers.controls.ToggleButton;
	import feathers.examples.componentsExplorer.data.EmbeddedAssets;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.VerticalAlign;
	import feathers.layout.VerticalLayout;
	import feathers.system.DeviceCapabilities;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]

	public class ButtonScreen extends PanelScreen
	{
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
		
		override protected function initialize():void
		{
			//never forget to call super.initialize()
			super.initialize();

			this.title = "Button";
			
			var verticalLayout:VerticalLayout = new VerticalLayout();
			verticalLayout.horizontalAlign = HorizontalAlign.CENTER;
			verticalLayout.verticalAlign = VerticalAlign.TOP;
			verticalLayout.padding = 12;
			verticalLayout.gap = 8;
			this.layout = verticalLayout;

			this.verticalScrollPolicy = ScrollPolicy.ON;
			
			this._normalButton = new Button();
			this._normalButton.label = "Normal Button";
			this._normalButton.addEventListener(Event.TRIGGERED, normalButton_triggeredHandler);
			this.addChild(this._normalButton);

			this._disabledButton = new Button();
			this._disabledButton.label = "Disabled Button";
			this._disabledButton.isEnabled = false;
			this.addChild(this._disabledButton);
			
			this._iconButton = new Button();
			this._iconButton.label = "Icon Button";
			var icon:ImageLoader = new ImageLoader();
			//the source can be either a texture or a URL
			icon.source = EmbeddedAssets.SKULL_ICON_DARK;
			this._iconButton.defaultIcon = icon;
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