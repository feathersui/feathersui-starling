package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.DataGrid;
	import feathers.controls.DataGridColumn;
	import feathers.controls.Header;
	import feathers.controls.PanelScreen;
	import feathers.data.ArrayCollection;
	import feathers.events.FeathersEventType;
	import feathers.examples.componentsExplorer.data.DataGridSettings;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.system.DeviceCapabilities;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]
	[Event(name="showSettings",type="starling.events.Event")]

	public class DataGridScreen extends PanelScreen
	{
		public static const SHOW_SETTINGS:String = "showSettings";

		public function DataGridScreen()
		{
			super();
		}

		public var settings:DataGridSettings;

		private var _grid:DataGrid;

		override protected function initialize():void
		{
			//never forget to call super.initialize()
			super.initialize();

			this.title = "Data Grid";

			this.layout = new AnchorLayout();

			var items:Array =
			[
				{ item: "Chicken breast", dept: "Meat", price: "5.90" },
				{ item: "Bacon", dept: "Meat", price: "4.49" },
				{ item: "2% Milk", dept: "Dairy", price: "2.49" },
				{ item: "Butter", dept: "Dairy", price: "4.69" },
				{ item: "Lettuce", dept: "Produce", price: "1.29" },
				{ item: "Broccoli", dept: "Produce", price: "2.99" },
				{ item: "Whole Wheat Bread", dept: "Bakery", price: "2.49" },
				{ item: "English Muffins", dept: "Bakery", price: "2.99" },
			];
			var columns:Array =
			[
				new DataGridColumn("item", "Item"),
				new DataGridColumn("dept", "Department"),
				new DataGridColumn("price", "Unit Price"),
			];

			this._grid = new DataGrid();
			this._grid.dataProvider = new ArrayCollection(items);
			this._grid.columns = new ArrayCollection(columns);

			this._grid.sortableColumns = this.settings.sortableColumns;
			this._grid.resizableColumns = this.settings.resizableColumns;
			this._grid.reorderColumns = this.settings.reorderColumns;

			//optimization: since this grid fills the entire screen, there's no
			//need for clipping. clipping should not be disabled if there's a
			//chance that item renderers could be visible if they appear outside
			//the list's bounds
			this._grid.clipContent = false;
			//optimization: when the background is covered by all item
			//renderers, don't render it
			this._grid.autoHideBackground = true;
			this._grid.addEventListener(Event.CHANGE, list_changeHandler);
			this._grid.layoutData = new AnchorLayoutData(0, 0, 0, 0);
			this.addChild(this._grid);

			this.headerFactory = this.customHeaderFactory;

			//this screen doesn't use a back button on tablets because the main
			//app's uses a split layout
			if(!DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				this.backButtonHandler = this.onBackButton;
			}

			this.addEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, transitionInCompleteHandler);
		}

		private function customHeaderFactory():Header
		{
			var header:Header = new Header();
			//this screen doesn't use a back button on tablets because the main
			//app's uses a split layout
			if(!DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				var backButton:Button = new Button();
				backButton.styleNameList.add(Button.ALTERNATE_STYLE_NAME_BACK_BUTTON);
				backButton.label = "Back";
				backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);
				header.leftItems = new <DisplayObject>
				[
					backButton
				];
			}
			var settingsButton:Button = new Button();
			settingsButton.label = "Settings";
			settingsButton.addEventListener(Event.TRIGGERED, settingsButton_triggeredHandler);
			header.rightItems = new <DisplayObject>
			[
				settingsButton
			];
			return header;
		}
		
		private function onBackButton():void
		{
			this.dispatchEventWith(Event.COMPLETE);
		}

		private function transitionInCompleteHandler(event:Event):void
		{
			this._grid.revealScrollBars();
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
			var selectedIndices:Vector.<int> = this._grid.selectedIndices;
			trace("List change:", selectedIndices.length > 0 ? selectedIndices : this._grid.selectedIndex);
		}
	}
}