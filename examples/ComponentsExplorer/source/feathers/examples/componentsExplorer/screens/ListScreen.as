package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.List;
	import feathers.controls.Screen;
	import feathers.data.ListCollection;
	import feathers.examples.componentsExplorer.data.ListSettings;

	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]
	[Event(name="showSettings",type="starling.events.Event")]

	public class ListScreen extends Screen
	{
		public static const SHOW_SETTINGS:String = "showSettings";

		public function ListScreen()
		{
			super();
		}

		public var settings:ListSettings;

		private var _list:List;
		private var _header:Header;
		private var _backButton:Button;
		private var _settingsButton:Button;
		
		override protected function initialize():void
		{
			var items:Array = [];
			for(var i:int = 0; i < 150; i++)
			{
				var item:Object = {text: "Item " + (i + 1).toString()};
				items.push(item);
			}
			items.fixed = true;
			
			this._list = new List();
			this._list.dataProvider = new ListCollection(items);
			this._list.typicalItem = {text: "Item 1000"};
			this._list.isSelectable = this.settings.isSelectable;
			this._list.scrollerProperties.hasElasticEdges = this.settings.hasElasticEdges;
			this._list.itemRendererProperties.labelField = "text";
			this._list.addEventListener(Event.CHANGE, list_changeHandler);
			this.addChildAt(this._list, 0);

			this._backButton = new Button();
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);

			this._settingsButton = new Button();
			this._settingsButton.label = "Settings";
			this._settingsButton.addEventListener(Event.TRIGGERED, settingsButton_triggeredHandler);

			this._header = new Header();
			this._header.title = "List";
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
		}
		
		private function onBackButton():void
		{
			this.dispatchEventWith(Event.COMPLETE);
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
			trace("List onChange:", this._list.selectedIndex);
		}
	}
}