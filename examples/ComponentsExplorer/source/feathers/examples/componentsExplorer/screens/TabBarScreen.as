package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Label;
	import feathers.controls.Screen;
	import feathers.controls.TabBar;
	import feathers.data.ListCollection;

	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]

	public class TabBarScreen extends Screen
	{
		public function TabBarScreen()
		{
		}

		private var _header:Header;
		private var _backButton:Button;
		private var _tabBar:TabBar;
		private var _label:Label;

		override protected function initialize():void
		{
			this._tabBar = new TabBar();
			this._tabBar.dataProvider = new ListCollection(
			[
				{ label: "One" },
				{ label: "Two" },
				{ label: "Three" },
			]);
			this._tabBar.addEventListener(Event.CHANGE, tabBar_changeHandler);
			this.addChild(this._tabBar);

			this._label = new Label();
			this._label.text = "selectedIndex: " + this._tabBar.selectedIndex.toString();
			this.addChild(DisplayObject(this._label));

			this._backButton = new Button();
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);

			this._header = new Header();
			this._header.title = "Tab Bar";
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

			this._tabBar.width = this.actualWidth;
			this._tabBar.validate();
			this._tabBar.y = this.actualHeight - this._tabBar.height;

			this._label.validate();
			this._label.x = (this.actualWidth - this._label.width) / 2;
			this._label.y = this._header.height + (this.actualHeight - this._header.height - this._tabBar.height - this._label.height) / 2;
		}

		private function onBackButton():void
		{
			this.dispatchEventWith(Event.COMPLETE);
		}

		private function backButton_triggeredHandler(event:Event):void
		{
			this.onBackButton();
		}

		private function tabBar_changeHandler(event:Event):void
		{
			this._label.text = "selectedIndex: " + this._tabBar.selectedIndex.toString();
			this.invalidate();
		}
	}
}
