package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.Callout;
	import feathers.controls.Label;
	import feathers.controls.PanelScreen;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.system.DeviceCapabilities;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]

	public class CalloutScreen extends PanelScreen
	{
		private static const CONTENT_TEXT:String = "Thank you for trying Feathers.\nHappy coding.";

		public function CalloutScreen()
		{
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}

		private var _rightButton:Button;
		private var _downButton:Button;
		private var _upButton:Button;
		private var _leftButton:Button;
		private var _backButton:Button;
		private var _message:Label;

		override public function dispose():void
		{
			//the message won't be on the display list when the screen is
			//disposed, so dispose it manually
			if(this._message)
			{
				this._message.dispose();
				this._message = null;
			}
			super.dispose();
		}

		protected function initializeHandler(event:Event):void
		{
			this.layout = new AnchorLayout();

			const margin:Number = 20 * this.dpiScale;

			this._rightButton = new Button();
			this._rightButton.label = "Right";
			this._rightButton.addEventListener(Event.TRIGGERED, rightButton_triggeredHandler);
			const rightButtonLayoutData:AnchorLayoutData = new AnchorLayoutData();
			rightButtonLayoutData.top = margin;
			rightButtonLayoutData.left = margin;
			this._rightButton.layoutData = rightButtonLayoutData;
			this.addChild(this._rightButton);

			this._downButton = new Button();
			this._downButton.label = "Down";
			this._downButton.addEventListener(Event.TRIGGERED, downButton_triggeredHandler);
			const downButtonLayoutData:AnchorLayoutData = new AnchorLayoutData();
			downButtonLayoutData.top = margin;
			downButtonLayoutData.right = margin;
			this._downButton.layoutData = downButtonLayoutData;
			this.addChild(this._downButton);

			this._upButton = new Button();
			this._upButton.label = "Up";
			this._upButton.addEventListener(Event.TRIGGERED, upButton_triggeredHandler);
			const upButtonLayoutData:AnchorLayoutData = new AnchorLayoutData();
			upButtonLayoutData.bottom = margin;
			upButtonLayoutData.left = margin;
			this._upButton.layoutData = upButtonLayoutData;
			this.addChild(this._upButton);

			this._leftButton = new Button();
			this._leftButton.label = "Left";
			this._leftButton.addEventListener(Event.TRIGGERED, leftButton_triggeredHandler);
			const leftButtonLayoutData:AnchorLayoutData = new AnchorLayoutData();
			leftButtonLayoutData.right = margin;
			leftButtonLayoutData.bottom = margin;
			this._leftButton.layoutData = leftButtonLayoutData;
			this.addChild(this._leftButton);

			this.headerProperties.title = "Callout";

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

		private function showCallout(origin:DisplayObject, direction:String):void
		{
			if(!this._message)
			{
				this._message = new Label();
				this._message.text = CONTENT_TEXT;
			}
			const callout:Callout = Callout.show(DisplayObject(this._message), origin, direction);
			//we're reusing the message every time that this screen shows a
			//callout, so we don't want the message to be disposed. we'll
			//dispose of it manually later when the screen is disposed.
			callout.disposeContent = false;
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
			this.showCallout(this._rightButton, Callout.DIRECTION_RIGHT);
		}

		private function downButton_triggeredHandler(event:Event):void
		{
			this.showCallout(this._downButton, Callout.DIRECTION_DOWN);
		}

		private function upButton_triggeredHandler(event:Event):void
		{
			this.showCallout(this._upButton, Callout.DIRECTION_UP);
		}

		private function leftButton_triggeredHandler(event:Event):void
		{
			this.showCallout(this._leftButton, Callout.DIRECTION_LEFT)
		}
	}
}
