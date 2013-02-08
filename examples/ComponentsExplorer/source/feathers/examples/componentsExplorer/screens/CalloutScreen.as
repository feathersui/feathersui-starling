package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.Callout;
	import feathers.controls.Header;
	import feathers.controls.Label;
	import feathers.controls.Screen;

	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]

	public class CalloutScreen extends Screen
	{
		private static const CONTENT_TEXT:String = "Thank you for trying Feathers.\nHappy coding.";

		public function CalloutScreen()
		{
		}

		private var _rightButton:Button;
		private var _downButton:Button;
		private var _upButton:Button;
		private var _leftButton:Button;
		private var _header:Header;
		private var _backButton:Button;

		override protected function initialize():void
		{
			this._rightButton = new Button();
			this._rightButton.label = "Right";
			this._rightButton.addEventListener(Event.TRIGGERED, rightButton_triggeredHandler);
			this.addChild(this._rightButton);

			this._downButton = new Button();
			this._downButton.label = "Down";
			this._downButton.addEventListener(Event.TRIGGERED, downButton_triggeredHandler);
			this.addChild(this._downButton);

			this._upButton = new Button();
			this._upButton.label = "Up";
			this._upButton.addEventListener(Event.TRIGGERED, upButton_triggeredHandler);
			this.addChild(this._upButton);

			this._leftButton = new Button();
			this._leftButton.label = "Left";
			this._leftButton.addEventListener(Event.TRIGGERED, leftButton_triggeredHandler);
			this.addChild(this._leftButton);

			this._backButton = new Button();
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);

			this._header = new Header();
			this._header.title = "Callout";
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

			const margin:Number = this._header.height * 0.25;

			this._rightButton.validate();
			this._rightButton.x = margin;
			this._rightButton.y = this._header.height + margin;

			this._downButton.validate();
			this._downButton.x = this.actualWidth - this._downButton.width - margin;
			this._downButton.y = this._header.height + margin;

			this._upButton.validate();
			this._upButton.x = margin;
			this._upButton.y = this.actualHeight - this._upButton.height - margin;

			this._leftButton.validate();
			this._leftButton.x = this.actualWidth - this._leftButton.width - margin;
			this._leftButton.y = this.actualHeight - this._leftButton.height - margin;
		}

		private function onBackButton():void
		{
			this.dispatchEventWith(Event.COMPLETE);
		}

		private function backButton_triggeredHandler(event:Event):void
		{
			this.onBackButton();
		}

		private function rightButton_triggeredHandler(event:Event):void
		{
			const content:Label = new Label();
			content.text = CONTENT_TEXT;
			Callout.show(DisplayObject(content), this._rightButton, Callout.DIRECTION_RIGHT);
		}

		private function downButton_triggeredHandler(event:Event):void
		{
			const content:Label = new Label();
			content.text = CONTENT_TEXT;
			Callout.show(DisplayObject(content), this._downButton, Callout.DIRECTION_DOWN);
		}

		private function upButton_triggeredHandler(event:Event):void
		{
			const content:Label = new Label();
			content.text = CONTENT_TEXT;
			Callout.show(DisplayObject(content), this._upButton, Callout.DIRECTION_UP);
		}

		private function leftButton_triggeredHandler(event:Event):void
		{
			const content:Label = new Label();
			content.text = CONTENT_TEXT;
			Callout.show(DisplayObject(content), this._leftButton, Callout.DIRECTION_LEFT);
		}
	}
}
