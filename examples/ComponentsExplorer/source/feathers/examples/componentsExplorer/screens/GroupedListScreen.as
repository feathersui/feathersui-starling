package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.GroupedList;
	import feathers.controls.PanelScreen;
	import feathers.data.HierarchicalCollection;
	import feathers.events.FeathersEventType;
	import feathers.examples.componentsExplorer.data.GroupedListSettings;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.system.DeviceCapabilities;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]
	[Event(name="showSettings",type="starling.events.Event")]

	public class GroupedListScreen extends PanelScreen
	{
		public static const SHOW_SETTINGS:String = "showSettings";

		public function GroupedListScreen()
		{
			super();
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}

		public var settings:GroupedListSettings;

		private var _list:GroupedList;
		private var _backButton:Button;
		private var _settingsButton:Button;
		
		protected function initializeHandler(event:Event):void
		{
			this.layout = new AnchorLayout();

			var groups:Array =
			[
				{
					header: "A",
					children:
					[
						{ text: "Aardvark" },
						{ text: "Alligator" },
						{ text: "Alpaca" },
						{ text: "Anteater" },
					]
				},
				{
					header: "B",
					children:
					[
						{ text: "Baboon" },
						{ text: "Bear" },
						{ text: "Beaver" },
					]
				},
				{
					header: "C",
					children:
					[
						{ text: "Canary" },
						{ text: "Cat" },
					]
				},
				{
					header: "D",
					children:
					[
						{ text: "Deer" },
						{ text: "Dingo" },
						{ text: "Dog" },
						{ text: "Dolphin" },
						{ text: "Donkey" },
						{ text: "Dragonfly" },
						{ text: "Duck" },
						{ text: "Dung Beetle" },
					]
				},
				{
					header: "E",
					children:
					[
						{ text: "Eagle" },
						{ text: "Earthworm" },
						{ text: "Eel" },
						{ text: "Elk" },
					]
				}
			];
			groups.fixed = true;
			
			this._list = new GroupedList();
			if(this.settings.style == GroupedListSettings.STYLE_INSET)
			{
				this._list.nameList.add(GroupedList.ALTERNATE_NAME_INSET_GROUPED_LIST);
			}
			this._list.dataProvider = new HierarchicalCollection(groups);
			this._list.typicalItem = { text: "Item 1000" };
			this._list.typicalHeader = "Group 10";
			this._list.typicalFooter = "Footer 10";
			this._list.isSelectable = this.settings.isSelectable;
			this._list.hasElasticEdges = this.settings.hasElasticEdges;
			this._list.itemRendererProperties.labelField = "text";
			this._list.addEventListener(Event.CHANGE, list_changeHandler);
			this._list.layoutData = new AnchorLayoutData(0, 0, 0, 0);
			this.addChildAt(this._list, 0);

			this.headerProperties.title = "Grouped List";

			if(!DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				this._backButton = new Button();
				this._backButton.label = "Back";
				this._backButton.addEventListener(Event.TRIGGERED, backButtontriggeredHandler);

				this.headerProperties.leftItems = new <DisplayObject>
				[
					this._backButton
				];
			}

			this._settingsButton = new Button();
			this._settingsButton.label = "Settings";
			this._settingsButton.addEventListener(Event.TRIGGERED, settingsButtontriggeredHandler);

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
		
		private function backButtontriggeredHandler(event:Event):void
		{
			this.onBackButton();
		}

		private function settingsButtontriggeredHandler(event:Event):void
		{
			this.dispatchEventWith(SHOW_SETTINGS);
		}

		private function list_changeHandler(event:Event):void
		{
			trace("GroupedList onChange:", this._list.selectedGroupIndex, this._list.selectedItemIndex);
		}
	}
}