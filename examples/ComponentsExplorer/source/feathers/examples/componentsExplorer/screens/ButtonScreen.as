package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Screen;
	import feathers.examples.componentsExplorer.data.ButtonSettings;

	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;

	[Event(name="complete",type="starling.events.Event")]
	[Event(name="showSettings",type="starling.events.Event")]

	public class ButtonScreen extends Screen
	{
		[Embed(source="/../assets/images/skull.png")]
		private static const SKULL_ICON:Class;

		public static const SHOW_SETTINGS:String = "showSettings";
		
		public function ButtonScreen()
		{
			super();
		}

		public var settings:ButtonSettings;

		private var _button:Button;
		private var _header:Header;
		private var _backButton:Button;
		private var _settingsButton:Button;
		
		private var _icon:Image;
		
		override protected function initialize():void
		{
			this._icon = new Image(Texture.fromBitmap(new SKULL_ICON()));
			this._icon.scaleX = this._icon.scaleY = this.dpiScale;
			
			this._button = new Button();
			this._button.label = "Click Me";
			this._button.isToggle = this.settings.isToggle;
			if(this.settings.hasIcon)
			{
				this._button.defaultIcon = this._icon;
			}
			this._button.horizontalAlign = this.settings.horizontalAlign;
			this._button.verticalAlign = this.settings.verticalAlign;
			this._button.iconPosition = this.settings.iconPosition;
			this._button.iconOffsetX = this.settings.iconOffsetX;
			this._button.iconOffsetY = this.settings.iconOffsetY;
			this._button.width = 264 * this.dpiScale;
			this._button.height = 264 * this.dpiScale;
			this._button.addEventListener(Event.TRIGGERED, button_triggeredHandler);
			this.addChild(this._button);

			this._backButton = new Button();
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);

			this._settingsButton = new Button();
			this._settingsButton.label = "Settings";
			this._settingsButton.addEventListener(Event.TRIGGERED, settingsButton_triggeredHandler);

			this._header = new Header();
			this._header.title = "Button";
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

			this._button.validate();
			this._button.x = (this.actualWidth - this._button.width) / 2;
			this._button.y = this._header.height + (this.actualHeight - this._header.height - this._button.height) / 2;
		}
		
		private function onBackButton():void
		{
			this.dispatchEventWith(Event.COMPLETE);
		}

		private function button_triggeredHandler(event:Event):void
		{
			trace("button triggered.")
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