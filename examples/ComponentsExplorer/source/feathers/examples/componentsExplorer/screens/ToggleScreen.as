package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.Check;
	import feathers.controls.Header;
	import feathers.controls.LayoutGroup;
	import feathers.controls.PanelScreen;
	import feathers.controls.Radio;
	import feathers.controls.ToggleSwitch;
	import feathers.core.ToggleGroup;
	import feathers.layout.ILayout;
	import feathers.skins.IStyleProvider;
	import feathers.system.DeviceCapabilities;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]

	public class ToggleScreen extends PanelScreen
	{
		public static var globalStyleProvider:IStyleProvider;

		public function ToggleScreen()
		{
			super();
		}

		private var _toggleSwitchContainer:LayoutGroup;
		private var _checkContainer:LayoutGroup;
		private var _radioContainer:LayoutGroup;
		private var _toggleSwitch:ToggleSwitch;
		private var _check1:Check;
		private var _check2:Check;
		private var _check3:Check;
		private var _radio1:Radio;
		private var _radio2:Radio;
		private var _radio3:Radio;
		private var _radioGroup:ToggleGroup;
		private var _backButton:Button;

		override protected function get defaultStyleProvider():IStyleProvider
		{
			return ToggleScreen.globalStyleProvider;
		}

		protected var _innerLayout:ILayout;

		public function get innerLayout():ILayout
		{
			return this._innerLayout;
		}

		public function set innerLayout(value:ILayout):void
		{
			if(this._innerLayout == value)
			{
				return;
			}
			this._innerLayout = value;
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
		}

		override protected function initialize():void
		{
			//never forget to call super.initialize()
			super.initialize();

			this.title = "Toggles";

			this._toggleSwitchContainer = new LayoutGroup();
			this.addChild(this._toggleSwitchContainer);

			this._toggleSwitch = new ToggleSwitch();
			this._toggleSwitch.isSelected = false;
			this._toggleSwitch.addEventListener(Event.CHANGE, toggleSwitch_changeHandler);
			this._toggleSwitchContainer.addChild(this._toggleSwitch);

			this._checkContainer = new LayoutGroup();
			this.addChild(this._checkContainer);

			this._check1 = new Check();
			this._check1.isSelected = false;
			this._check1.label = "Check 1";
			this._checkContainer.addChild(this._check1);

			this._check2 = new Check();
			this._check2.isSelected = false;
			this._check2.label = "Check 2";
			this._checkContainer.addChild(this._check2);

			this._check3 = new Check();
			this._check3.isSelected = false;
			this._check3.label = "Check 3";
			this._checkContainer.addChild(this._check3);

			this._radioGroup = new ToggleGroup();
			this._radioGroup.addEventListener(Event.CHANGE, radioGroup_changeHandler);

			this._radioContainer = new LayoutGroup();
			this.addChild(this._radioContainer);

			this._radio1 = new Radio();
			this._radio1.label = "Radio 1";
			this._radioGroup.addItem(this._radio1);
			this._radioContainer.addChild(this._radio1);

			this._radio2 = new Radio();
			this._radio2.label = "Radio 2";
			this._radioGroup.addItem(this._radio2);
			this._radioContainer.addChild(this._radio2);

			this._radio3 = new Radio();
			this._radio3.label = "Radio 3";
			this._radioGroup.addItem(this._radio3);
			this._radioContainer.addChild(this._radio3);

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

		override protected function draw():void
		{
			var layoutInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_LAYOUT);

			if(layoutInvalid)
			{
				this._toggleSwitchContainer.layout = this._innerLayout;
				this._checkContainer.layout = this._innerLayout;
				this._radioContainer.layout = this._innerLayout;
			}

			super.draw();
		}

		private function onBackButton():void
		{
			this.dispatchEventWith(Event.COMPLETE);
		}
		
		private function toggleSwitch_changeHandler(event:Event):void
		{
			trace("toggle switch isSelected:", this._toggleSwitch.isSelected);
		}

		private function radioGroup_changeHandler(event:Event):void
		{
			trace("radio group change:", this._radioGroup.selectedIndex);
		}
		
		private function backButton_triggeredHandler(event:Event):void
		{
			this.onBackButton();
		}
	}
}