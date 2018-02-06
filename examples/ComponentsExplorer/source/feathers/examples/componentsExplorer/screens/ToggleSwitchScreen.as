package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.PanelScreen;
	import feathers.controls.ToggleSwitch;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.TiledRowsLayout;
	import feathers.layout.VerticalAlign;
	import feathers.system.DeviceCapabilities;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]

	public class ToggleSwitchScreen extends PanelScreen
	{
		public function ToggleSwitchScreen()
		{
			super();
		}

		private var _toggle:ToggleSwitch;
		private var _selected:ToggleSwitch;
		private var _disabled:ToggleSwitch;
		private var _selectedDisabled:ToggleSwitch;

		override protected function initialize():void
		{
			//never forget to call super.initialize()
			super.initialize();

			this.title = "Toggle Switch";
			
			var layout:TiledRowsLayout = new TiledRowsLayout();
			layout.requestedColumnCount = 2;
			layout.useSquareTiles = false;
			layout.horizontalAlign = HorizontalAlign.CENTER;
			layout.verticalAlign = VerticalAlign.TOP;
			layout.tileHorizontalAlign = HorizontalAlign.CENTER;
			layout.tileVerticalAlign = VerticalAlign.TOP;
			layout.padding = 12;
			layout.horizontalGap = 12;
			layout.verticalGap = 44;
			this.layout = layout;

			this._toggle = new ToggleSwitch();
			this._toggle.addEventListener(Event.CHANGE, toggleSwitch_changeHandler);
			this.addChild(this._toggle);

			this._selected = new ToggleSwitch();
			this._selected.isSelected = true;
			this.addChild(this._selected);

			this._disabled = new ToggleSwitch();
			this._disabled.isEnabled = false;
			this.addChild(this._disabled);

			this._selectedDisabled = new ToggleSwitch();
			this._selectedDisabled.isSelected = true;
			this._selectedDisabled.isEnabled = false;
			this.addChild(this._selectedDisabled);

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
			return header;
		}

		private function onBackButton():void
		{
			this.dispatchEventWith(Event.COMPLETE);
		}

		private function toggleSwitch_changeHandler(event:Event):void
		{
			trace("toggle switch changed:", this._toggle.isSelected);
		}

		private function backButton_triggeredHandler(event:Event):void
		{
			this.onBackButton();
		}
	}
}