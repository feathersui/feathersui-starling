package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.Check;
	import feathers.controls.Header;
	import feathers.controls.PanelScreen;
	import feathers.controls.ScrollPolicy;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.VerticalAlign;
	import feathers.layout.VerticalLayout;
	import feathers.system.DeviceCapabilities;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]

	public class CheckScreen extends PanelScreen
	{
		public function CheckScreen()
		{
			super();
		}

		private var _check:Check;
		private var _checked:Check;
		private var _disabled:Check;
		private var _selectedDisabled:Check;

		override protected function initialize():void
		{
			//never forget to call super.initialize()
			super.initialize();

			this.title = "Check";

			var verticalLayout:VerticalLayout = new VerticalLayout();
			verticalLayout.horizontalAlign = HorizontalAlign.LEFT;
			verticalLayout.verticalAlign = VerticalAlign.TOP;
			verticalLayout.padding = 12;
			verticalLayout.gap = 8;
			this.layout = verticalLayout;

			this.verticalScrollPolicy = ScrollPolicy.ON;

			this._check = new Check();
			this._check.label = "Default";
			this._check.addEventListener(Event.CHANGE, check_changeHandler);
			this.addChild(this._check);

			this._checked = new Check();
			this._checked.label = "Selected";
			this._checked.isSelected = true;
			this.addChild(this._checked);

			this._disabled = new Check();
			this._disabled.label = "Disabled";
			this._disabled.isEnabled = false;
			this.addChild(this._disabled);

			this._selectedDisabled = new Check();
			this._selectedDisabled.label = "Selected and Disabled";
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

		private function check_changeHandler(event:Event):void
		{
			trace("check changed:", this._check.isSelected);
		}

		private function backButton_triggeredHandler(event:Event):void
		{
			this.onBackButton();
		}
	}
}