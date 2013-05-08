package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.PanelScreen;
	import feathers.events.FeathersEventType;
	import feathers.examples.componentsExplorer.data.EmbeddedAssets;
	import feathers.layout.VerticalLayout;
	import feathers.system.DeviceCapabilities;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.textures.Texture;

	[Event(name="complete",type="starling.events.Event")]

	public class ButtonScreen extends PanelScreen
	{
		
		public function ButtonScreen()
		{
			super();
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}

		private var _normalButton:Button;
		private var _disabledButton:Button;
		private var _iconButton:Button;
		private var _toggleButton:Button;
		private var _callToActionButton:Button;
		private var _quietButton:Button;
		private var _dangerButton:Button;
		private var _sampleBackButton:Button;
		private var _forwardButton:Button;

		private var _backButton:Button;
		
		private var _icon:ImageLoader;
		
		protected function initializeHandler(event:Event):void
		{
			const verticalLayout:VerticalLayout = new VerticalLayout();
			verticalLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			verticalLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			verticalLayout.padding = 20 * this.dpiScale;
			verticalLayout.gap = 16 * this.dpiScale;
			verticalLayout.manageVisibility = true;
			this.layout = verticalLayout;
			
			this._normalButton = new Button();
			this._normalButton.label = "Normal Button";
			this._normalButton.addEventListener(Event.TRIGGERED, normalButton_triggeredHandler);
			this.addChild(this._normalButton);

			this._disabledButton = new Button();
			this._disabledButton.label = "Disabled Button";
			this._disabledButton.isEnabled = false;
			this.addChild(this._disabledButton);

			this._icon = new ImageLoader();
			this._icon.source = EmbeddedAssets.SKULL_ICON_DARK;
			//the icon will be blurry if it's not on a whole pixel. ImageLoader
			//can snap to pixels to fix that issue.
			this._icon.snapToPixels = true;
			this._icon.textureScale = this.dpiScale;

			this._iconButton = new Button();
			this._iconButton.label = "Icon Button";
			this._iconButton.defaultIcon = this._icon;
			this.addChild(this._iconButton);

			this._toggleButton = new Button();
			this._toggleButton.label = "Toggle Button";
			this._toggleButton.isToggle = true;
			this._toggleButton.isSelected = true;
			this._toggleButton.addEventListener(Event.CHANGE, toggleButton_changeHandler);
			this.addChild(this._toggleButton);

			this._callToActionButton = new Button();
			this._callToActionButton.nameList.add(Button.ALTERNATE_NAME_CALL_TO_ACTION_BUTTON);
			this._callToActionButton.label = "Call to Action Button";
			this.addChild(this._callToActionButton);

			this._quietButton = new Button();
			this._quietButton.nameList.add(Button.ALTERNATE_NAME_QUIET_BUTTON);
			this._quietButton.label = "Quiet Button";
			this.addChild(this._quietButton);

			this._dangerButton = new Button();
			this._dangerButton.nameList.add(Button.ALTERNATE_NAME_DANGER_BUTTON);
			this._dangerButton.label = "Danger Button";
			this.addChild(this._dangerButton);

			this._sampleBackButton = new Button();
			this._sampleBackButton.nameList.add(Button.ALTERNATE_NAME_BACK_BUTTON);
			this._sampleBackButton.label = "Back Button";
			this.addChild(this._sampleBackButton);

			this._forwardButton = new Button();
			this._forwardButton.nameList.add(Button.ALTERNATE_NAME_FORWARD_BUTTON);
			this._forwardButton.label = "Forward Button";
			this.addChild(this._forwardButton);

			this.headerProperties.title = "Button";

			if(!DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				this._backButton = new Button();
				this._backButton.nameList.add(Button.ALTERNATE_NAME_BACK_BUTTON);
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