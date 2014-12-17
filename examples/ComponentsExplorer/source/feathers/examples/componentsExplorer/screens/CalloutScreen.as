package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.Callout;
	import feathers.controls.Header;
	import feathers.controls.Label;
	import feathers.controls.PanelScreen;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.skins.IStyleProvider;
	import feathers.system.DeviceCapabilities;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]

	public class CalloutScreen extends PanelScreen
	{
		private static const CONTENT_TEXT:String = "Thank you for trying Feathers.\nHappy coding.";

		public static var globalStyleProvider:IStyleProvider;

		public function CalloutScreen()
		{
			super();
		}

		private var _rightButton:Button;
		private var _downButton:Button;
		private var _upButton:Button;
		private var _leftButton:Button;
		private var _backButton:Button;
		private var _message:Label;

		private var _topLeftLayoutData:AnchorLayoutData;
		private var _topRightLayoutData:AnchorLayoutData;
		private var _bottomRightLayoutData:AnchorLayoutData;
		private var _bottomLeftLayoutData:AnchorLayoutData;

		private var _layoutPadding:Number = 0;

		public function get layoutPadding():Number
		{
			return this._layoutPadding;
		}

		public function set layoutPadding(value:Number):void
		{
			if(this._layoutPadding == value)
			{
				return;
			}
			this._layoutPadding = value;
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
		}

		override protected function get defaultStyleProvider():IStyleProvider
		{
			return CalloutScreen.globalStyleProvider;
		}

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

		override protected function initialize():void
		{
			//never forget to call super.initialize()
			super.initialize();

			this.title = "Callout";

			this.layout = new AnchorLayout();
			this._topLeftLayoutData = new AnchorLayoutData();
			this._topRightLayoutData = new AnchorLayoutData();
			this._bottomRightLayoutData = new AnchorLayoutData();
			this._bottomLeftLayoutData = new AnchorLayoutData();

			this._rightButton = new Button();
			this._rightButton.label = "Right";
			this._rightButton.addEventListener(Event.TRIGGERED, rightButton_triggeredHandler);
			this._rightButton.layoutData = this._topLeftLayoutData;
			this.addChild(this._rightButton);

			this._downButton = new Button();
			this._downButton.label = "Down";
			this._downButton.addEventListener(Event.TRIGGERED, downButton_triggeredHandler);
			this._downButton.layoutData = this._topRightLayoutData;
			this.addChild(this._downButton);

			this._upButton = new Button();
			this._upButton.label = "Up";
			this._upButton.addEventListener(Event.TRIGGERED, upButton_triggeredHandler);
			this._upButton.layoutData = this._bottomLeftLayoutData;
			this.addChild(this._upButton);

			this._leftButton = new Button();
			this._leftButton.label = "Left";
			this._leftButton.addEventListener(Event.TRIGGERED, leftButton_triggeredHandler);
			this._leftButton.layoutData = this._bottomRightLayoutData;
			this.addChild(this._leftButton);

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
				this._topLeftLayoutData.top = this._layoutPadding;
				this._topLeftLayoutData.left = this._layoutPadding;
				this._topRightLayoutData.top = this._layoutPadding;
				this._topRightLayoutData.right = this._layoutPadding;
				this._bottomLeftLayoutData.bottom = this._layoutPadding;
				this._bottomLeftLayoutData.left = this._layoutPadding;
				this._bottomRightLayoutData.bottom = this._layoutPadding;
				this._bottomRightLayoutData.right = this._layoutPadding;
			}

			//never forget to call super.draw()
			super.draw();
		}

		private function showCallout(origin:DisplayObject, direction:String):void
		{
			if(!this._message)
			{
				this._message = new Label();
				this._message.text = CONTENT_TEXT;
			}
			var callout:Callout = Callout.show(DisplayObject(this._message), origin, direction);
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
