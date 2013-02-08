package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.PanelScreen;
	import feathers.events.FeathersEventType;
	import feathers.examples.componentsExplorer.data.ButtonSettings;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.system.DeviceCapabilities;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.textures.Texture;

	[Event(name="complete",type="starling.events.Event")]
	[Event(name="showSettings",type="starling.events.Event")]

	public class ButtonScreen extends PanelScreen
	{
		[Embed(source="/../assets/images/skull.png")]
		private static const SKULL_ICON:Class;

		public static const SHOW_SETTINGS:String = "showSettings";
		
		public function ButtonScreen()
		{
			super();
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}

		public var settings:ButtonSettings;

		private var _button:Button;
		private var _backButton:Button;
		private var _settingsButton:Button;
		
		private var _icon:ImageLoader;
		private var _iconTexture:Texture;

		override public function dispose():void
		{
			if(this._iconTexture)
			{
				//since we created this texture, it's up to us to dispose it
				this._iconTexture.dispose();
			}
			super.dispose();
		}
		
		protected function initializeHandler(event:Event):void
		{
			this.layout = new AnchorLayout();

			this._iconTexture = Texture.fromBitmap(new SKULL_ICON());
			this._icon = new ImageLoader();
			this._icon.source = this._iconTexture;
			//the icon will be blurry if it's not on a whole pixel. ImageLoader
			//can snap to pixels to fix that issue.
			this._icon.snapToPixels = true;
			this._icon.textureScale = this.dpiScale;
			
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
			const buttonLayoutData:AnchorLayoutData = new AnchorLayoutData();
			buttonLayoutData.horizontalCenter = 0;
			buttonLayoutData.verticalCenter = 0;
			this._button.layoutData = buttonLayoutData;
			this._button.addEventListener(Event.TRIGGERED, button_triggeredHandler);
			this.addChild(this._button);

			this.headerProperties.title = "Button";

			if(!DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				this._backButton = new Button();
				this._backButton.label = "Back";
				this._backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);

				this.headerProperties.leftItems = new <DisplayObject>
				[
					this._backButton
				];
			}

			this._settingsButton = new Button();
			this._settingsButton.label = "Settings";
			this._settingsButton.addEventListener(Event.TRIGGERED, settingsButton_triggeredHandler);

			this.headerProperties.rightItems = new <DisplayObject>
			[
				this._settingsButton
			];
			
			// handles the back hardware key on android
			this.backButtonHandler = this.onBackButton;
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