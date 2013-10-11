package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Header;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.controls.Screen;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.skins.StandardIcons;
	import feathers.system.DeviceCapabilities;

	import starling.core.Starling;

	import starling.events.Event;
	import starling.textures.Texture;

	[Event(name="complete",type="starling.events.Event")]
	[Event(name="showAlert",type="starling.events.Event")]
	[Event(name="showButton",type="starling.events.Event")]
	[Event(name="showButtonGroup",type="starling.events.Event")]
	[Event(name="showCallout",type="starling.events.Event")]
	[Event(name="showGroupedList",type="starling.events.Event")]
	[Event(name="showItemRenderer",type="starling.events.Event")]
	[Event(name="showList",type="starling.events.Event")]
	[Event(name="showNumericStepper",type="starling.events.Event")]
	[Event(name="showPageIndicator",type="starling.events.Event")]
	[Event(name="showPickerList",type="starling.events.Event")]
	[Event(name="showProgressBar",type="starling.events.Event")]
	[Event(name="showScrollText",type="starling.events.Event")]
	[Event(name="showSlider",type="starling.events.Event")]
	[Event(name="showTabBar",type="starling.events.Event")]
	[Event(name="showTextInput",type="starling.events.Event")]
	[Event(name="showToggles",type="starling.events.Event")]

	public class MainMenuScreen extends PanelScreen
	{
		public static const SHOW_ALERT:String = "showAlert";
		public static const SHOW_BUTTON:String = "showButton";
		public static const SHOW_BUTTON_GROUP:String = "showButtonGroup";
		public static const SHOW_CALLOUT:String = "showCallout";
		public static const SHOW_GROUPED_LIST:String = "showGroupedList";
		public static const SHOW_ITEM_RENDERER:String = "showItemRenderer";
		public static const SHOW_LABEL:String = "showLabel";
		public static const SHOW_LIST:String = "showList";
		public static const SHOW_NUMERIC_STEPPER:String = "showNumericStepper";
		public static const SHOW_PAGE_INDICATOR:String = "showPageIndicator";
		public static const SHOW_PICKER_LIST:String = "showPickerList";
		public static const SHOW_PROGRESS_BAR:String = "showProgressBar";
		public static const SHOW_SCROLL_TEXT:String = "showScrollText";
		public static const SHOW_SLIDER:String = "showSlider";
		public static const SHOW_TAB_BAR:String = "showTabBar";
		public static const SHOW_TEXT_INPUT:String = "showTextInput";
		public static const SHOW_TOGGLES:String = "showToggles";
		
		public function MainMenuScreen()
		{
			super();
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}

		private var _list:List;
		
		protected function initializeHandler(event:Event):void
		{
			var isTablet:Boolean = DeviceCapabilities.isTablet(Starling.current.nativeStage);

			this.layout = new AnchorLayout();

			this.headerProperties.title = "Feathers";

			this._list = new List();
			this._list.dataProvider = new ListCollection(
			[
				{ label: "Alert", event: SHOW_ALERT },
				{ label: "Button", event: SHOW_BUTTON },
				{ label: "Button Group", event: SHOW_BUTTON_GROUP },
				{ label: "Callout", event: SHOW_CALLOUT },
				{ label: "Grouped List", event: SHOW_GROUPED_LIST },
				{ label: "Item Renderer", event: SHOW_ITEM_RENDERER },
				{ label: "Label", event: SHOW_LABEL },
				{ label: "List", event: SHOW_LIST },
				{ label: "Numeric Stepper", event: SHOW_NUMERIC_STEPPER },
				{ label: "Page Indicator", event: SHOW_PAGE_INDICATOR },
				{ label: "Picker List", event: SHOW_PICKER_LIST },
				{ label: "Progress Bar", event: SHOW_PROGRESS_BAR },
				{ label: "Scroll Text", event: SHOW_SCROLL_TEXT },
				{ label: "Slider", event: SHOW_SLIDER},
				{ label: "Tab Bar", event: SHOW_TAB_BAR },
				{ label: "Text Input", event: SHOW_TEXT_INPUT },
				{ label: "Toggles", event: SHOW_TOGGLES },
			]);
			this._list.layoutData = new AnchorLayoutData(0, 0, 0, 0);
			this._list.clipContent = false;
			this._list.autoHideBackground = true;
			this._list.addEventListener(Event.CHANGE, list_changeHandler);

			var itemRendererAccessorySourceFunction:Function = null;
			if(!isTablet)
			{
				itemRendererAccessorySourceFunction = this.accessorySourceFunction;
			}
			this._list.itemRendererFactory = function():IListItemRenderer
			{
				var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();

				//enable the quick hit area to optimize hit tests when an item
				//is only selectable and doesn't have interactive children.
				renderer.isQuickHitAreaEnabled = true;

				renderer.labelField = "label";
				renderer.accessorySourceFunction = itemRendererAccessorySourceFunction;
				return renderer;
			};

			if(isTablet)
			{
				this._list.selectedIndex = 0;
			}
			this.addChild(this._list);
		}

		private function accessorySourceFunction(item:Object):Texture
		{
			return StandardIcons.listDrillDownAccessoryTexture;
		}
		
		private function list_changeHandler(event:Event):void
		{
			const eventType:String = this._list.selectedItem.event as String;
			this.dispatchEventWith(eventType);
		}
	}
}