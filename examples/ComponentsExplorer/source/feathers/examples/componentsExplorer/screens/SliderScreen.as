package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Label;
	import feathers.controls.Screen;
	import feathers.controls.Slider;
	import feathers.examples.componentsExplorer.data.SliderSettings;

	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]
	[Event(name="showSettings",type="starling.events.Event")]

	public class SliderScreen extends Screen
	{
		public static const SHOW_SETTINGS:String = "showSettings";

		public function SliderScreen()
		{
			super();
		}

		public var settings:SliderSettings;

		private var _slider:Slider;
		private var _header:Header;
		private var _backButton:Button;
		private var _settingsButton:Button;
		private var _valueLabel:Label;
		
		override protected function initialize():void
		{
			this._slider = new Slider();
			this._slider.minimum = 0;
			this._slider.maximum = 100;
			this._slider.value = 50;
			this._slider.step = this.settings.step;
			this._slider.page = this.settings.page;
			this._slider.direction = this.settings.direction;
			this._slider.liveDragging = this.settings.liveDragging;
			this._slider.addEventListener(Event.CHANGE, slider_changeHandler);
			this.addChild(this._slider);
			
			this._valueLabel = new Label();
			this._valueLabel.text = this._slider.value.toString();
			this.addChild(DisplayObject(this._valueLabel));

			this._backButton = new Button();
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);

			this._settingsButton = new Button();
			this._settingsButton.label = "Settings";
			this._settingsButton.addEventListener(Event.TRIGGERED, settingsButton_triggeredHandler);

			this._header = new Header();
			this._header.title = "Slider";
			this.addChild(this._header);
			this._header.leftItems = new <DisplayObject>
			[
				this._backButton
			];
			this._header.rightItems = new <DisplayObject>
			[
				this._settingsButton
			];
			
			// handles the back hardware key on android
			this.backButtonHandler = this.onBackButton;
		}
		
		override protected function draw():void
		{
			this._header.width = this.actualWidth;
			this._header.validate();

			const spacingX:Number = this._header.height * 0.2;

			//auto-size the slider and label so that we can position them properly
			this._slider.validate();

			this._valueLabel.validate();

			const contentWidth:Number = this._slider.width + spacingX + this._valueLabel.width;
			this._slider.x = (this.actualWidth - contentWidth) / 2;
			this._slider.y = this._header.height + (this.actualHeight - this._header.height - this._slider.height) / 2;
			this._valueLabel.x = this._slider.x + this._slider.width + spacingX;
			this._valueLabel.y = this._slider.y + (this._slider.height - this._valueLabel.height) / 2;
		}
		
		private function onBackButton():void
		{
			this.dispatchEventWith(Event.COMPLETE);
		}
		
		private function slider_changeHandler(event:Event):void
		{
			this._valueLabel.text = this._slider.value.toString();
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