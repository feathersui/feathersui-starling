package feathers.examples.layoutExplorer.screens
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

	[Event(name="showHorizontal",type="starling.events.Event")]

	[Event(name="showVertical",type="starling.events.Event")]

	[Event(name="showTiledRows",type="starling.events.Event")]

	[Event(name="showTiledColumns",type="starling.events.Event")]

	public class MainMenuScreen extends PanelScreen
	{
		public static const SHOW_HORIZONTAL:String = "showHorizontal";
		public static const SHOW_VERTICAL:String = "showVertical";
		public static const SHOW_TILED_ROWS:String = "showTiledRows";
		public static const SHOW_TILED_COLUMNS:String = "showTiledColumns";

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

			this.headerProperties.title = "Layouts in Feathers";

			this._list = new List();
			this._list.dataProvider = new ListCollection(
			[
				{ text: "Horizontal", event: SHOW_HORIZONTAL },
				{ text: "Vertical", event: SHOW_VERTICAL },
				{ text: "Tiled Rows", event: SHOW_TILED_ROWS },
				{ text: "Tiled Columns", event: SHOW_TILED_COLUMNS },
			]);
			this._list.layoutData = new AnchorLayoutData(0, 0, 0, 0);
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

				renderer.labelField = "text";
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
