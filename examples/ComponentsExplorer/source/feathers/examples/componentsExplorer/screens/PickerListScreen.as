package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.controls.PickerList;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.system.DeviceCapabilities;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]

	public class PickerListScreen extends PanelScreen
	{
		public function PickerListScreen()
		{
			super();
		}

		private var _backButton:Button;
		private var _list:PickerList;

		override protected function initialize():void
		{
			//never forget to call super.initialize()
			super.initialize();

			this.layout = new AnchorLayout();

			var items:Array = [];
			for(var i:int = 0; i < 150; i++)
			{
				var item:Object = {text: "Item " + (i + 1).toString()};
				items[i] = item;
			}
			items.fixed = true;

			this._list = new PickerList();
			this._list.prompt = "Select an Item";
			this._list.dataProvider = new ListCollection(items);
			//normally, the first item is selected, but let's show the prompt
			this._list.selectedIndex = -1;
			var listLayoutData:AnchorLayoutData = new AnchorLayoutData();
			listLayoutData.horizontalCenter = 0;
			listLayoutData.verticalCenter = 0;
			this._list.layoutData = listLayoutData;
			this.addChildAt(this._list, 0);

			//the typical item helps us set an ideal width for the button
			//if we don't use a typical item, the button will resize to fit
			//the currently selected item.
			this._list.typicalItem = { text: "Select an Item" };
			this._list.labelField = "text";

			this._list.listFactory = function():List
			{
				var list:List = new List();
				//notice that we're setting typicalItem on the list separately. we
				//may want to have the list measure at a different width, so it
				//might need a different typical item than the picker list's button.
				list.typicalItem = { text: "Item 1000" };
				list.itemRendererFactory = function():IListItemRenderer
				{
					var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
					//notice that we're setting labelField on the item renderers
					//separately. the default item renderer has a labelField property,
					//but a custom item renderer may not even have a label, so
					//PickerList cannot simply pass its labelField down to item
					//renderers automatically
					renderer.labelField = "text";
					return renderer;
				};
				return list;
			};

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
			header.title = "Picker List";
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
	}
}