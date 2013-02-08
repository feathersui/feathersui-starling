package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.GroupedList;
	import feathers.controls.Header;
	import feathers.controls.Screen;
	import feathers.data.HierarchicalCollection;
	import feathers.examples.componentsExplorer.data.GroupedListSettings;

	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]
	[Event(name="showSettings",type="starling.events.Event")]

	public class GroupedListScreen extends Screen
	{
		public static const SHOW_SETTINGS:String = "showSettings";

		public function GroupedListScreen()
		{
			super();
		}

		public var settings:GroupedListSettings;

		private var _list:GroupedList;
		private var _header:Header;
		private var _backButton:Button;
		private var _settingsButton:Button;
		
		override protected function initialize():void
		{
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
			this._list.scrollerProperties.hasElasticEdges = this.settings.hasElasticEdges;
			this._list.itemRendererProperties.labelField = "text";
			this._list.addEventListener(Event.CHANGE, list_changeHandler);
			this.addChildAt(this._list, 0);

			this._backButton = new Button();
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backButtontriggeredHandler);

			this._settingsButton = new Button();
			this._settingsButton.label = "Settings";
			this._settingsButton.addEventListener(Event.TRIGGERED, settingsButtontriggeredHandler);

			this._header = new Header();
			this._header.title = "Grouped List";
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

			this._list.y = this._header.height;
			this._list.width = this.actualWidth;
			this._list.height = this.actualHeight - this._list.y;
			this._list.validate();
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