package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.GroupedList;
	import feathers.controls.Header;
	import feathers.controls.PanelScreen;
	import feathers.controls.renderers.DefaultGroupedListItemRenderer;
	import feathers.controls.renderers.IGroupedListItemRenderer;
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
		}

		public var settings:GroupedListSettings;

		private var _list:GroupedList;
		private var _backButton:Button;
		private var _settingsButton:Button;

		override protected function initialize():void
		{
			//never forget to call super.initialize()
			super.initialize();

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
				},
				{
					header: "F",
					children:
					[
						{ text: "Fox" },
					]
				}
			];
			groups.fixed = true;
			
			this._list = new GroupedList();
			if(this.settings.style == GroupedListSettings.STYLE_INSET)
			{
				this._list.styleNameList.add(GroupedList.ALTERNATE_STYLE_NAME_INSET_GROUPED_LIST);
			}
			this._list.dataProvider = new HierarchicalCollection(groups);
			this._list.typicalItem = { text: "Item 1000" };
			this._list.isSelectable = this.settings.isSelectable;
			this._list.hasElasticEdges = this.settings.hasElasticEdges;
			this._list.clipContent = false;
			this._list.autoHideBackground = true;
			this._list.itemRendererFactory = function():IGroupedListItemRenderer
			{
				var renderer:DefaultGroupedListItemRenderer = new DefaultGroupedListItemRenderer();

				//enable the quick hit area to optimize hit tests when an item
				//is only selectable and doesn't have interactive children.
				renderer.isQuickHitAreaEnabled = true;

				renderer.labelField = "text";
				return renderer;
			};
			this._list.addEventListener(Event.CHANGE, list_changeHandler);
			this._list.layoutData = new AnchorLayoutData(0, 0, 0, 0);
			this.addChildAt(this._list, 0);

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

			this._settingsButton = new Button();
			this._settingsButton.label = "Settings";
			this._settingsButton.addEventListener(Event.TRIGGERED, settingsButton_triggeredHandler);
			//we'll add this as a child in the header factory

			this.addEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, transitionInCompleteHandler);
		}

		private function customHeaderFactory():Header
		{
			var header:Header = new Header();
			header.title = "Grouped List";
			if(this._backButton)
			{
				header.leftItems = new <DisplayObject>
				[
					this._backButton
				];
			}
			header.rightItems = new <DisplayObject>
			[
				this._settingsButton
			];
			return header;
		}
		
		private function onBackButton():void
		{
			this.dispatchEventWith(Event.COMPLETE);
		}

		private function transitionInCompleteHandler(event:Event):void
		{
			this._list.revealScrollBars();
		}
		
		private function backButton_triggeredHandler(event:Event):void
		{
			this.onBackButton();
		}

		private function settingsButton_triggeredHandler(event:Event):void
		{
			this.dispatchEventWith(SHOW_SETTINGS);
		}

		private function list_changeHandler(event:Event):void
		{
			trace("GroupedList onChange:", this._list.selectedGroupIndex, this._list.selectedItemIndex);
		}
	}
}