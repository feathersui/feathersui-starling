package feathers.examples.layoutExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.PanelScreen;
	import feathers.controls.ScrollContainer;
	import feathers.events.FeathersEventType;
	import feathers.examples.layoutExplorer.data.HorizontalLayoutSettings;
	import feathers.layout.HorizontalLayout;
	import feathers.system.DeviceCapabilities;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]

	[Event(name="showSettings",type="starling.events.Event")]

	public class HorizontalLayoutScreen extends PanelScreen
	{
		public static const SHOW_SETTINGS:String = "showSettings";

		public function HorizontalLayoutScreen()
		{
			super();
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}

		public var settings:HorizontalLayoutSettings;

		private var _backButton:Button;
		private var _settingsButton:Button;

		protected function initializeHandler(event:Event):void
		{
			const layout:HorizontalLayout = new HorizontalLayout();
			layout.gap = this.settings.gap;
			layout.paddingTop = this.settings.paddingTop;
			layout.paddingRight = this.settings.paddingRight;
			layout.paddingBottom = this.settings.paddingBottom;
			layout.paddingLeft = this.settings.paddingLeft;
			layout.horizontalAlign = this.settings.horizontalAlign;
			layout.verticalAlign = this.settings.verticalAlign;
			layout.manageVisibility = true;

			this.layout = layout;
			//when the scroll policy is set to on, the "elastic" edges will be
			//active even when the max scroll position is zero
			this.horizontalScrollPolicy = ScrollContainer.SCROLL_POLICY_ON;
			this.snapScrollPositionsToPixels = true;
			for(var i:int = 0; i < this.settings.itemCount; i++)
			{
				var size:Number = (44 + 88 * Math.random()) * this.dpiScale;
				var quad:Quad = new Quad(size, size, 0xff8800);
				this.addChild(quad);
			}

			this.headerProperties.title = "Horizontal Layout";

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

			this._settingsButton = new Button();
			this._settingsButton.label = "Settings";
			this._settingsButton.addEventListener(Event.TRIGGERED, settingsButton_triggeredHandler);

			this.headerProperties.rightItems = new <DisplayObject>
			[
				this._settingsButton
			];
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
