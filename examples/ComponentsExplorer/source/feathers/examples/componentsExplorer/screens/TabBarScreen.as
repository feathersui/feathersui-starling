package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Label;
	import feathers.controls.PanelScreen;
	import feathers.controls.TabBar;
	import feathers.data.ListCollection;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.system.DeviceCapabilities;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]

	public class TabBarScreen extends PanelScreen
	{
		public function TabBarScreen()
		{
			super();
		}

		private var _backButton:Button;
		private var _tabBar:TabBar;
		private var _label:Label;

		override protected function initialize():void
		{
			//never forget to call super.initialize()
			super.initialize();

			this.title = "Tab Bar";

			this.layout = new AnchorLayout();

			this._tabBar = new TabBar();
			this._tabBar.dataProvider = new ListCollection(
			[
				{ label: "One" },
				{ label: "Two" },
				{ label: "Three" },
			]);
			this._tabBar.addEventListener(Event.CHANGE, tabBar_changeHandler);
			this._tabBar.layoutData = new AnchorLayoutData(NaN, 0, 0, 0);
			this.addChild(this._tabBar);

			this._label = new Label();
			this._label.text = "selectedIndex: " + this._tabBar.selectedIndex.toString();
			var labelLayoutData:AnchorLayoutData = new AnchorLayoutData();
			labelLayoutData.horizontalCenter = 0;
			labelLayoutData.verticalCenter = 0;
			this._label.layoutData = labelLayoutData;
			this.addChild(DisplayObject(this._label));

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
		}
	}
}
