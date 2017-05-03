package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ArrayCollection;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.examples.componentsExplorer.ScreenID;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.system.DeviceCapabilities;

	import flash.system.Capabilities;

	import starling.core.Starling;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]
	[Event(name="change",type="starling.events.Event")]

	public class MainMenuScreen extends PanelScreen
	{
		public function MainMenuScreen()
		{
			super();
		}

		private var _list:List;

		public var savedVerticalScrollPosition:Number = 0;
		public var savedSelectedIndex:int = -1;

		private var _selectedScreenID:String = null;

		public function get selectedScreenID():String
		{
			return this._selectedScreenID;
		}

		override protected function initialize():void
		{
			//never forget to call super.initialize()
			super.initialize();

			this.title = "Feathers";

			this.layout = new AnchorLayout();

			this._list = new List();
			this._list.dataProvider = new ArrayCollection(
			[
				{ label: "Alert", screen: ScreenID.ALERT },
				{ label: "Auto-complete", screen: ScreenID.AUTO_COMPLETE },
				{ label: "Button", screen: ScreenID.BUTTON },
				{ label: "Button Group", screen: ScreenID.BUTTON_GROUP },
				{ label: "Callout", screen: ScreenID.CALLOUT },
				{ label: "Check", screen: ScreenID.CHECK },
				{ label: "Date Time Spinner", screen: ScreenID.DATE_TIME_SPINNER },
				{ label: "Grouped List", screen: ScreenID.GROUPED_LIST },
				{ label: "Item Renderer", screen: ScreenID.ITEM_RENDERER },
				{ label: "Label", screen: ScreenID.LABEL },
				{ label: "List", screen: ScreenID.LIST },
				{ label: "Numeric Stepper", screen: ScreenID.NUMERIC_STEPPER },
				{ label: "Page Indicator", screen: ScreenID.PAGE_INDICATOR },
				{ label: "Panel", screen: ScreenID.PANEL },
				{ label: "Picker List", screen: ScreenID.PICKER_LIST },
				{ label: "Progress Bar", screen: ScreenID.PROGRESS_BAR },
				{ label: "Radio", screen: ScreenID.RADIO },
				{ label: "Scroll Text", screen: ScreenID.SCROLL_TEXT },
				{ label: "Slider", screen: ScreenID.SLIDER},
				{ label: "Spinner List", screen: ScreenID.SPINNER_LIST },
				{ label: "Tab Bar", screen: ScreenID.TAB_BAR },
				{ label: "Text Callout", screen: ScreenID.TEXT_CALLOUT },
				{ label: "Text Input and Text Area", screen: ScreenID.TEXT_INPUT },
				{ label: "Toggle Switch", screen: ScreenID.TOGGLES },
				{ label: "Tree", screen: ScreenID.TREE },
			]);
			if(Capabilities.playerType == "Desktop") //this means AIR, even for mobile
			{
				this._list.dataProvider.addItem( { label: "Web View", screen: ScreenID.WEB_VIEW } );
			}
			this._list.layoutData = new AnchorLayoutData(0, 0, 0, 0);
			this._list.clipContent = false;
			this._list.autoHideBackground = true;
			this._list.verticalScrollPosition = this.savedVerticalScrollPosition;

			this._list.itemRendererFactory = this.createItemRenderer;

			var isTablet:Boolean = DeviceCapabilities.isTablet(Starling.current.nativeStage);
			if(isTablet)
			{
				this._list.addEventListener(Event.CHANGE, list_changeHandler);
				this._list.selectedIndex = 0;
				this._list.revealScrollBars();
			}
			else
			{
				this._list.selectedIndex = this.savedSelectedIndex;
				this.addEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, transitionInCompleteHandler);
			}
			this.addChild(this._list);
		}
		
		private function createItemRenderer():IListItemRenderer
		{
			var isTablet:Boolean = DeviceCapabilities.isTablet(Starling.current.nativeStage);
			
			var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
			if(!isTablet)
			{
				renderer.styleNameList.add(DefaultListItemRenderer.ALTERNATE_STYLE_NAME_DRILL_DOWN);
			}

			//enable the quick hit area to optimize hit tests when an item
			//is only selectable and doesn't have interactive children.
			renderer.isQuickHitAreaEnabled = true;

			renderer.labelField = "label";
			return renderer;
		}
		
		private function transitionInCompleteHandler(event:Event):void
		{
			if(!DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				this._list.selectedIndex = -1;
				this._list.addEventListener(Event.CHANGE, list_changeHandler);
			}
			this._list.revealScrollBars();
		}
		
		private function list_changeHandler(event:Event):void
		{
			this._selectedScreenID = this._list.selectedItem.screen as String;
			if(DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				this.dispatchEventWith(Event.CHANGE);
				return;
			}

			//save the list's scroll position and selected index so that we
			//can restore some context when this screen when we return to it
			//again later.
			this.dispatchEventWith(Event.CHANGE, false,
			{
				savedVerticalScrollPosition: this._list.verticalScrollPosition,
				savedSelectedIndex: this._list.selectedIndex
			});
		}
	}
}