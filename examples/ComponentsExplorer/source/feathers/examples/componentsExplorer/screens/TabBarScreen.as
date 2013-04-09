package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.PanelScreen;
	import feathers.controls.TabBar;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
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
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}

		private var _backButton:Button;
		private var _tabBar:TabBar;
		private var _label:Label;

		protected function initializeHandler(event:Event):void
		{
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
			const labelLayoutData:AnchorLayoutData = new AnchorLayoutData();
			labelLayoutData.horizontalCenter = 0;
			labelLayoutData.verticalCenter = 0;
			this._label.layoutData = labelLayoutData;
			this.addChild(DisplayObject(this._label));

			this.headerProperties.title = "Tab Bar";

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
