package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.PanelScreen;
	import feathers.controls.Slider;
	import feathers.examples.componentsExplorer.data.SliderSettings;
	import feathers.skins.IStyleProvider;
	import feathers.system.DeviceCapabilities;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]
	[Event(name="showSettings",type="starling.events.Event")]

	public class SliderScreen extends PanelScreen
	{
		public static const SHOW_SETTINGS:String = "showSettings";

		public static var globalStyleProvider:IStyleProvider;

		public function SliderScreen()
		{
			super();
		}

		public var settings:SliderSettings;

		private var _horizontalSlider:Slider;
		private var _verticalSlider:Slider;
		private var _backButton:Button;
		private var _settingsButton:Button;

		override protected function get defaultStyleProvider():IStyleProvider
		{
			return SliderScreen.globalStyleProvider;
		}
		
		override protected function initialize():void
		{
			//never forget to call super.initialize()
			super.initialize();

			this.title = "Slider";

			this._horizontalSlider = new Slider();
			this._horizontalSlider.direction = Slider.DIRECTION_HORIZONTAL;
			this._horizontalSlider.minimum = 0;
			this._horizontalSlider.maximum = 100;
			this._horizontalSlider.value = 50;
			this._horizontalSlider.step = this.settings.step;
			this._horizontalSlider.page = this.settings.page;
			this._horizontalSlider.liveDragging = this.settings.liveDragging;
			this._horizontalSlider.addEventListener(Event.CHANGE, horizontalSlider_changeHandler);
			this.addChild(this._horizontalSlider);

			this._verticalSlider = new Slider();
			this._verticalSlider.direction = Slider.DIRECTION_VERTICAL;
			this._verticalSlider.minimum = 0;
			this._verticalSlider.maximum = 100;
			this._verticalSlider.value = 50;
			this._verticalSlider.step = this.settings.step;
			this._verticalSlider.page = this.settings.page;
			this._verticalSlider.liveDragging = this.settings.liveDragging;
			this._verticalSlider.addEventListener(Event.CHANGE, horizontalSlider_changeHandler);
			this.addChild(this._verticalSlider);

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

			this._settingsButton = new Button();
			this._settingsButton.label = "Settings";
			this._settingsButton.addEventListener(Event.TRIGGERED, settingsButton_triggeredHandler);
			//we'll add this as a child in the header factory
		}

		private function customHeaderFactory():Header
		{
			var header:Header = new Header();
			if(this._backButton)
			{
				header.leftItems = new <DisplayObject>
				[
					this._backButton
				];
			}
			header.rightItems = new <DisplayObject>
			[
				this._settingsButton
			];
			return header;
		}
		
		private function onBackButton():void
		{
			this.dispatchEventWith(Event.COMPLETE);
		}
		
		private function horizontalSlider_changeHandler(event:Event):void
		{
			trace("slider change:", this._horizontalSlider.value.toString());
		}
		
		private function backButton_triggeredHandler(event:Event):void
		{
			this.onBackButton();
		}

		private function settingsButton_triggeredHandler(event:Event):void
		{
			this.dispatchEventWith(SHOW_SETTINGS);
		}
	}
}