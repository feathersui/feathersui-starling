package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.PanelScreen;
	import feathers.controls.TextCallout;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.RelativePosition;
	import feathers.skins.IStyleProvider;
	import feathers.system.DeviceCapabilities;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]

	public class TextCalloutScreen extends PanelScreen
	{
		private static const MESSAGE:String = "Thank you for trying Feathers.\nHappy coding.";

		public static var globalStyleProvider:IStyleProvider;

		public function TextCalloutScreen()
		{
			super();
		}

		private var _rightButton:Button;
		private var _bottomButton:Button;
		private var _topButton:Button;
		private var _leftButton:Button;

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
			return TextCalloutScreen.globalStyleProvider;
		}

		override protected function initialize():void
		{
			//never forget to call super.initialize()
			super.initialize();

			this.title = " Text Callout";

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

			this._bottomButton = new Button();
			this._bottomButton.label = "Bottom";
			this._bottomButton.addEventListener(Event.TRIGGERED, bottomButton_triggeredHandler);
			this._bottomButton.layoutData = this._topRightLayoutData;
			this.addChild(this._bottomButton);

			this._topButton = new Button();
			this._topButton.label = "Top";
			this._topButton.addEventListener(Event.TRIGGERED, topButton_triggeredHandler);
			this._topButton.layoutData = this._bottomLeftLayoutData;
			this.addChild(this._topButton);

			this._leftButton = new Button();
			this._leftButton.label = "Left";
			this._leftButton.addEventListener(Event.TRIGGERED, leftButton_triggeredHandler);
			this._leftButton.layoutData = this._bottomRightLayoutData;
			this.addChild(this._leftButton);

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
			TextCallout.show(MESSAGE, this._rightButton, new <String>[RelativePosition.RIGHT]);
		}

		private function bottomButton_triggeredHandler(event:Event):void
		{
			TextCallout.show(MESSAGE, this._bottomButton, new <String>[RelativePosition.BOTTOM]);
		}

		private function topButton_triggeredHandler(event:Event):void
		{
			TextCallout.show(MESSAGE, this._topButton, new <String>[RelativePosition.TOP]);
		}

		private function leftButton_triggeredHandler(event:Event):void
		{
			TextCallout.show(MESSAGE, this._leftButton, new <String>[RelativePosition.LEFT]);
		}
	}
}
