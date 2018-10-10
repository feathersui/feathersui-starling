package feathers.examples.todos
{
	import feathers.controls.Alert;
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.LayoutGroup;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.controls.TabBar;
	import feathers.controls.TextInput;
	import feathers.controls.ToggleButton;
	import feathers.controls.text.StageTextTextEditor;
	import feathers.core.FeathersControl;
	import feathers.core.IFeathersControl;
	import feathers.core.ITextEditor;
	import feathers.data.ArrayCollection;
	import feathers.data.VectorCollection;
	import feathers.events.FeathersEventType;
	import feathers.examples.todos.TodoItem;
	import feathers.examples.todos.controls.TodoItemRenderer;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.HorizontalLayoutData;

	import starling.display.DisplayObject;
	import starling.events.Event;

	public class Main extends PanelScreen
	{
		public function Main()
		{
			//set up the theme right away!
			new TodosTheme();
			super();

			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}

		private var _list:List;
		private var _tabs:TabBar;
		private var _toolbar:LayoutGroup;
		private var _input:TextInput;
		private var _clearButton:Button;
		private var _editButton:ToggleButton;
		private var _items:VectorCollection;

		private function customHeaderFactory():IFeathersControl
		{
			var header:Header = new Header();

			if(!this._editButton)
			{
				this._editButton = new ToggleButton();
				this._editButton.styleNameList.add(Button.ALTERNATE_STYLE_NAME_QUIET_BUTTON);
				this._editButton.label = "Edit";
				this._editButton.addEventListener(Event.CHANGE, editButton_changeHandler);
			}

			header.rightItems = new <DisplayObject>
			[
				this._editButton
			];

			return header;
		}

		override protected function initialize():void
		{
			//never forget to call super.initialize()
			super.initialize();

			this.title = "TODOS";

			this.width = this.stage.stageWidth;
			this.height = this.stage.stageHeight;

			this.layout = new AnchorLayout();

			this.headerFactory = this.customHeaderFactory;

			this._tabs = new TabBar();
			this._tabs.dataProvider = new ArrayCollection(
			[
				{label: "All"},
				{label: "Active"},
				{label: "Completed"},
			]);
			this._tabs.addEventListener(Event.CHANGE, tabs_changeHandler);
			this.addChild(this._tabs);

			this._items = new VectorCollection(new <TodoItem>[]);

			this._list = new List();
			this._list.isSelectable = false;
			this._list.dataProvider = this._items;
			this._list.itemRendererType = TodoItemRenderer;
			this.addChild(this._list);

			this._toolbar = new LayoutGroup();
			this._toolbar.styleNameList.add(LayoutGroup.ALTERNATE_STYLE_NAME_TOOLBAR);
			this.addChild(this._toolbar);

			this._clearButton = new Button();
			this._clearButton.styleNameList.add(Button.ALTERNATE_STYLE_NAME_DANGER_BUTTON);
			this._clearButton.label = "Clear All Completed Items";
			this._clearButton.includeInLayout = false;
			this._clearButton.visible = false;
			this._clearButton.addEventListener(Event.TRIGGERED, clearButton_triggeredHandler);
			this._toolbar.addChild(this._clearButton);

			this._input = new TextInput();
			this._input.prompt = "What needs to be done?";
			this._input.textEditorFactory = function():ITextEditor
			{
				var textEditor:StageTextTextEditor = FeathersControl.defaultTextEditorFactory() as StageTextTextEditor;
				if(textEditor)
				{
					//we can't get an enter key event without changing the value
					//of returnKeyLabel.
					//we didn't use using ReturnKeyLabel.GO here so that it will
					//build the demo for Flash Player. That class is AIR only.
					textEditor.returnKeyLabel = "go";
				}
				return textEditor;
			};
			this._input.layoutData = new HorizontalLayoutData(100);
			this._input.addEventListener(FeathersEventType.ENTER, input_enterHandler);
			this._toolbar.addChild(this._input);

			var toolbarLayoutData:AnchorLayoutData = new AnchorLayoutData();
			toolbarLayoutData.top = 0;
			toolbarLayoutData.right = 0;
			toolbarLayoutData.left = 0;
			this._toolbar.layoutData = toolbarLayoutData;

			var tabsLayoutData:AnchorLayoutData = new AnchorLayoutData();
			tabsLayoutData.bottom = 0;
			tabsLayoutData.right = 0;
			tabsLayoutData.left = 0;
			this._tabs.layoutData = tabsLayoutData;

			var listLayoutData:AnchorLayoutData = new AnchorLayoutData();
			listLayoutData.top = 0;
			listLayoutData.topAnchorDisplayObject = this._toolbar;
			listLayoutData.right = 0;
			listLayoutData.bottom = 0;
			listLayoutData.bottomAnchorDisplayObject = this._tabs;
			listLayoutData.left = 0;
			this._list.layoutData = listLayoutData;
		}

		private function includeActiveItems(item:TodoItem):Boolean
		{
			return !item.isCompleted;
		}

		private function includeCompletedItems(item:TodoItem):Boolean
		{
			return item.isCompleted;
		}

		private function refreshFilterFunction():void
		{
			if(this._tabs.selectedIndex === 1)
			{
				this._items.filterFunction = this.includeActiveItems;
			}
			else if(this._tabs.selectedIndex === 2)
			{
				this._items.filterFunction = this.includeCompletedItems;
			}
			else
			{
				this._items.filterFunction = null;
			}
		}

		private function addedToStageHandler():void
		{
			this.stage.addEventListener(Event.RESIZE, stage_resizeHandler);
		}

		private function removedFromStageHandler():void
		{
			this.stage.removeEventListener(Event.RESIZE, stage_resizeHandler);
		}

		private function input_enterHandler():void
		{
			if(!this._input.text)
			{
				return;
			}

			this._items.addItem(new TodoItem(this._input.text));
			this._input.text = "";
		}

		private function editButton_changeHandler(event:Event):void
		{
			var isEditing:Boolean = this._editButton.isSelected;

			this._list.dragEnabled = isEditing;
			this._list.dropEnabled = isEditing;

			this._clearButton.visible = isEditing;
			this._clearButton.includeInLayout = isEditing;

			this._input.visible = !isEditing;
			this._input.includeInLayout = !isEditing;
		}

		private function clearButton_triggeredHandler(event:Event):void
		{
			//the completed items may currently be filtered, so temporarily
			//disable the filter.
			this._items.filterFunction = null;
			var hasCompletedItem:Boolean = false;
			var itemCount:int = this._items.length;
			for(var i:int = itemCount - 1; i >= 0; i--)
			{
				var item:TodoItem = TodoItem(this._items.getItemAt(i));
				if(item.isCompleted)
				{
					hasCompletedItem = true;
					break;
				}
			}
			//be sure to restore the filter
			this.refreshFilterFunction();
			if(!hasCompletedItem)
			{
				return;
			}

			Alert.show("Are you sure that you want to delete all completed items? This action cannot be undone.", "Confirm delete",
				new ArrayCollection(
				[
					{ label: "Cancel" },
					{ label: "Delete", triggered: confirmButton_triggeredHandler },
				]));
		}

		private function confirmButton_triggeredHandler(event:Event):void
		{
			//the completed items may currently be filtered, so temporarily
			//disable the filter.
			this._items.filterFunction = null;
			var itemCount:int = this._items.length;
			for(var i:int = itemCount - 1; i >= 0; i--)
			{
				var item:TodoItem = TodoItem(this._items.getItemAt(i));
				if(item.isCompleted)
				{
					this._items.removeItemAt(i);
				}
			}
			//be sure to restore the filter
			this.refreshFilterFunction();
		}

		private function stage_resizeHandler():void
		{
			this.width = this.stage.stageWidth;
			this.height = this.stage.stageHeight;
		}

		private function tabs_changeHandler(event:Event):void
		{
			this.refreshFilterFunction();
		}
	}
}
