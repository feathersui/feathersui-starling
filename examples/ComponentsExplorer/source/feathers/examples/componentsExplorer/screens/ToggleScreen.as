package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.Check;
	import feathers.controls.Header;
	import feathers.controls.Panel;
	import feathers.controls.PanelScreen;
	import feathers.controls.Radio;
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.controls.ToggleSwitch;
	import feathers.core.ToggleGroup;
	import feathers.events.FeathersEventType;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	import feathers.system.DeviceCapabilities;

	import starling.core.Starling;

	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]

	public class ToggleScreen extends PanelScreen
	{
		public function ToggleScreen()
		{
			super();
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}

		private var _toggleSwitchContainer:ScrollContainer;
		private var _checkContainer:ScrollContainer;
		private var _radioContainer:ScrollContainer;
		private var _toggleSwitch:ToggleSwitch;
		private var _check1:Check;
		private var _check2:Check;
		private var _check3:Check;
		private var _radio1:Radio;
		private var _radio2:Radio;
		private var _radio3:Radio;
		private var _radioGroup:ToggleGroup;
		private var _backButton:Button;
		
		protected function initializeHandler(event:Event):void
		{
			const layout:VerticalLayout = new VerticalLayout();
			layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			layout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
			layout.gap = 44 * this.dpiScale;
			this.layout = layout;

			const containerLayout:HorizontalLayout = new HorizontalLayout();
			containerLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
			containerLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			containerLayout.gap = 20 * this.dpiScale;

			this._toggleSwitchContainer = new ScrollContainer();
			this._toggleSwitchContainer.layout = containerLayout;
			this._toggleSwitchContainer.horizontalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
			this._toggleSwitchContainer.verticalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
			this.addChild(this._toggleSwitchContainer);

			this._toggleSwitch = new ToggleSwitch();
			this._toggleSwitch.isSelected = false;
			this._toggleSwitch.addEventListener(Event.CHANGE, toggleSwitch_changeHandler);
			this._toggleSwitchContainer.addChild(this._toggleSwitch);

			this._checkContainer = new ScrollContainer();
			this._checkContainer.layout = containerLayout;
			this._checkContainer.horizontalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
			this._checkContainer.verticalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
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

			this._radioContainer = new ScrollContainer();
			this._radioContainer.layout = containerLayout;
			this._radioContainer.horizontalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
			this._radioContainer.verticalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
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

			this.headerProperties.title = "Toggles";

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