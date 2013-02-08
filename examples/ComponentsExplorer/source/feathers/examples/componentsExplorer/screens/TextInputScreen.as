package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Screen;
	import feathers.controls.TextInput;

	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]

	public class TextInputScreen extends Screen
	{
		public function TextInputScreen()
		{
		}

		private var _header:Header;
		private var _backButton:Button;
		private var _input:TextInput;

		override protected function initialize():void
		{
			this._input = new TextInput();
			this.addChild(this._input);

			this._backButton = new Button();
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);

			this._header = new Header();
			this._header.title = "Text Input";
			this.addChild(this._header);
			this._header.leftItems = new <DisplayObject>
			[
				this._backButton
			];

			// handles the back hardware key on android
			this.backButtonHandler = this.onBackButton;
		}

		override protected function draw():void
		{
			this._header.width = this.actualWidth;
			this._header.validate();

			this._input.validate();
			this._input.x = (this.actualWidth - this._input.width) / 2;
			this._input.y = this._header.height + (this.actualHeight - this._header.height - this._input.height) / 2;
		}

		private function onBackButton():void
		{
			this.dispatchEventWith(Event.COMPLETE);
		}

		private function backButton_triggeredHandler(event:Event):void
		{
			this.onBackButton();
		}
	}
}
