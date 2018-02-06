package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Label;
	import feathers.controls.PanelScreen;
	import feathers.controls.Radio;
	import feathers.controls.ScrollPolicy;
	import feathers.core.ToggleGroup;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.VerticalAlign;
	import feathers.layout.VerticalLayout;
	import feathers.system.DeviceCapabilities;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]

	public class RadioScreen extends PanelScreen
	{
		public function RadioScreen()
		{
			super();
		}

		private var _group1:ToggleGroup;
		private var _title1:Label;
		private var _radio1:Radio;
		private var _radio2:Radio;
		private var _radio3:Radio;
		private var _radio4:Radio;
		
		private var _group2:ToggleGroup;
		private var _title2:Label;
		private var _radioA:Radio;
		private var _radioB:Radio;
		private var _radioC:Radio;

		override protected function initialize():void
		{
			//never forget to call super.initialize()
			super.initialize();

			this.title = "Radio";

			var verticalLayout:VerticalLayout = new VerticalLayout();
			verticalLayout.horizontalAlign = HorizontalAlign.LEFT;
			verticalLayout.verticalAlign = VerticalAlign.TOP;
			verticalLayout.padding = 12;
			verticalLayout.gap = 8;
			this.layout = verticalLayout;

			this.verticalScrollPolicy = ScrollPolicy.ON;

			this._group1 = new ToggleGroup();

			this._title1 = new Label();
			this._title1.styleNameList.add(Label.ALTERNATE_STYLE_NAME_HEADING);
			this._title1.text = "Group 1";
			this.addChild(this._title1);

			this._radio1 = new Radio();
			this._radio1.label = "Option 1";
			this._radio1.toggleGroup = this._group1;
			this.addChild(this._radio1);

			this._radio2 = new Radio();
			this._radio2.label = "Option 2";
			this._radio2.isSelected = true;
			this._radio2.toggleGroup = this._group1;
			this.addChild(this._radio2);

			this._radio3 = new Radio();
			this._radio3.label = "Option 3";
			this._radio3.toggleGroup = this._group1;
			this.addChild(this._radio3);

			this._radio4 = new Radio();
			this._radio4.label = "Option 4 (Disabled)";
			this._radio4.isEnabled = false;
			this._radio4.toggleGroup = this._group1;
			this.addChild(this._radio4);

			this._group1.addEventListener(Event.CHANGE, group1_changeHandler);

			//radios may be added to different groups
			this._group2 = new ToggleGroup();

			this._title2 = new Label();
			this._title2.styleNameList.add(Label.ALTERNATE_STYLE_NAME_HEADING);
			this._title2.text = "Group 2";
			this.addChild(this._title2);

			this._radioA = new Radio();
			this._radioA.label = "Option A";
			this.addChild(this._radioA);

			this._radioB = new Radio();
			this._radioB.label = "Option B";
			this.addChild(this._radioB);

			this._radioC = new Radio();
			this._radioC.label = "Option C";
			this.addChild(this._radioC);

			this._group2.selectedItem = this._radioA;

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

		private function group1_changeHandler(event:Event):void
		{
			trace("radio group changed:", this._group1.selectedIndex);
		}

		private function backButton_triggeredHandler(event:Event):void
		{
			this.onBackButton();
		}
	}
}