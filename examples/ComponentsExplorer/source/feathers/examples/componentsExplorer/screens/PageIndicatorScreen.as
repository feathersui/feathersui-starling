package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.PageIndicator;
	import feathers.controls.PanelScreen;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.system.DeviceCapabilities;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]

	public class PageIndicatorScreen extends PanelScreen
	{
		public function PageIndicatorScreen()
		{
			super();
		}

		private var _backButton:Button;
		private var _pageIndicator:PageIndicator;

		override protected function initialize():void
		{
			//never forget to call super.initialize()
			super.initialize();

			this.layout = new AnchorLayout();

			this._pageIndicator = new PageIndicator();
			this._pageIndicator.pageCount = 5;
			this._pageIndicator.addEventListener(Event.CHANGE, pageIndicator_changeHandler);
			var pageIndicatorLayoutData:AnchorLayoutData = new AnchorLayoutData();
			pageIndicatorLayoutData.left = 0;
			pageIndicatorLayoutData.right = 0;
			pageIndicatorLayoutData.verticalCenter = 0;
			this._pageIndicator.layoutData = pageIndicatorLayoutData;
			this.addChild(this._pageIndicator);

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
			header.title = "Page Indicator";
			if(!DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				header.leftItems = new <DisplayObject>
				[
					this._backButton
				];
			}
			return header;
		}

		private function onBackButton():void
		{
			this.dispatchEventWith(Event.COMPLETE);
		}

		private function pageIndicator_changeHandler(event:Event):void
		{
			trace("page indicator change:", this._pageIndicator.selectedIndex);
		}

		private function backButton_triggeredHandler(event:Event):void
		{
			this.onBackButton();
		}
	}
}
