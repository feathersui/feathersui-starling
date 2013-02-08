package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.PageIndicator;
	import feathers.controls.Screen;

	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]

	public class PageIndicatorScreen extends Screen
	{
		public function PageIndicatorScreen()
		{
		}

		private var _header:Header;
		private var _backButton:Button;
		private var _pageIndicator:PageIndicator;

		override protected function initialize():void
		{
			this._pageIndicator = new PageIndicator();
			this._pageIndicator.pageCount = 5;
			this._pageIndicator.addEventListener(Event.CHANGE, pageIndicator_changeHandler);
			this.addChild(this._pageIndicator);

			this._backButton = new Button();
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);

			this._header = new Header();
			this._header.title = "Page Indicator";
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

			this._pageIndicator.width = this.actualWidth;
			this._pageIndicator.validate();
			this._pageIndicator.y = this._header.height + (this.actualHeight - this._header.height - this._pageIndicator.height) / 2;
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
