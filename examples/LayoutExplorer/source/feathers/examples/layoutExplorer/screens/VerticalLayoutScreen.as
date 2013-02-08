package feathers.examples.layoutExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.examples.layoutExplorer.data.VerticalLayoutSettings;
	import feathers.layout.VerticalLayout;
	import feathers.system.DeviceCapabilities;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]

	[Event(name="showSettings",type="starling.events.Event")]

	public class VerticalLayoutScreen extends Screen
	{
		public static const SHOW_SETTINGS:String = "showSettings";

		public function VerticalLayoutScreen()
		{
			super();
		}

		public var settings:VerticalLayoutSettings;

		private var _container:ScrollContainer;
		private var _header:Header;
		private var _backButton:Button;
		private var _settingsButton:Button;

		override protected function initialize():void
		{
			const layout:VerticalLayout = new VerticalLayout();
			layout.gap = this.settings.gap;
			layout.paddingTop = this.settings.paddingTop;
			layout.paddingRight = this.settings.paddingRight;
			layout.paddingBottom = this.settings.paddingBottom;
			layout.paddingLeft = this.settings.paddingLeft;
			layout.horizontalAlign = this.settings.horizontalAlign;
			layout.verticalAlign = this.settings.verticalAlign;

			this._container = new ScrollContainer();
			this._container.layout = layout;
			//when the scroll policy is set to on, the "elastic" edges will be
			//active even when the max scroll position is zero
			this._container.verticalScrollPolicy = ScrollContainer.SCROLL_POLICY_ON;
			this._container.snapScrollPositionsToPixels = true;
			this.addChild(this._container);
			for(var i:int = 0; i < this.settings.itemCount; i++)
			{
				var size:Number = (44 + 88 * Math.random()) * this.dpiScale;
				var quad:Quad = new Quad(size, size, 0xff8800);
				this._container.addChild(quad);
			}

			this._header = new Header();
			this._header.title = "Vertical Layout";
			this.addChild(this._header);

			if(!DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				this._backButton = new Button();
				this._backButton.label = "Back";
				this._backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);

				this._header.leftItems = new <DisplayObject>
				[
					this._backButton
				];
			}

			this._settingsButton = new Button();
			this._settingsButton.label = "Settings";
			this._settingsButton.addEventListener(Event.TRIGGERED, settingsButton_triggeredHandler);

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

			this._container.y = this._header.height;
			this._container.width = this.actualWidth;
			this._container.height = this.actualHeight - this._container.y;
		}

		private function onBackButton():void
		{
			this.dispatchEventWith(Event.COMPLETE);
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
