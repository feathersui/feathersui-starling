package feathers.examples.todos
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.controls.ScrollContainer;
	import feathers.controls.TextInput;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.examples.todos.controls.TodoItemRenderer;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;

	import starling.display.DisplayObject;
	import starling.events.Event;

	public class Main extends PanelScreen
	{
		public function Main()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}

		private var _input:TextInput;
		private var _list:List;
		private var _editButton:Button;
		private var _toolbar:ScrollContainer;

		private function customHeaderFactory():Header
		{
			const header:Header = new Header();
			header.title = "TODOS";
			header.titleAlign = Header.TITLE_ALIGN_PREFER_LEFT;

			if(!this._input)
			{
				this._input = new TextInput();
				this._input.prompt = "What needs to be done?";

				//we can't get an enter key event without changing the returnKeyLabel
				//not using ReturnKeyLabel.GO here so that it will build for web
				this._input.textEditorProperties.returnKeyLabel = "go";

				this._input.addEventListener(FeathersEventType.ENTER, input_enterHandler);
			}

			header.rightItems = new <DisplayObject>
			[
				this._input
			];

			return header;
		}

		private function customFooterFactory():ScrollContainer
		{
			if(!this._toolbar)
			{
				this._toolbar = new ScrollContainer();
				this._toolbar.nameList.add(ScrollContainer.ALTERNATE_NAME_TOOLBAR);
			}
			else
			{
				this._toolbar.removeChildren();
			}

			if(!this._editButton)
			{
				this._editButton = new Button();
				this._editButton.isToggle = true;
				this._editButton.label = "Edit";
				this._editButton.addEventListener(Event.CHANGE, editButton_changeHandler);
			}
			this._toolbar.addChild(this._editButton);

			return this._toolbar;
		}

		private function initializeHandler():void
		{
			new TodosTheme();

			this.width = this.stage.stageWidth;
			this.height = this.stage.stageHeight;

			this.layout = new AnchorLayout();

			this.headerFactory = this.customHeaderFactory;
			this.footerFactory = this.customFooterFactory;

			this._list = new List();
			this._list.isSelectable = false;
			this._list.dataProvider = new ListCollection();
			this._list.itemRendererType = TodoItemRenderer;
			this._list.itemRendererProperties.labelField = "description";
			const listLayoutData:AnchorLayoutData = new AnchorLayoutData(0, 0, 0, 0);
			listLayoutData.topAnchorDisplayObject = this._input;
			this._list.layoutData = listLayoutData;
			this.addChild(this._list);
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

			this._list.dataProvider.addItem(new TodoItem(this._input.text));
			this._input.text = "";
		}

		private function editButton_changeHandler(event:Event):void
		{
			const isEditing:Boolean = this._editButton.isSelected;
			this._list.itemRendererProperties.isEditable = isEditing;
			this._input.visible = !isEditing;
		}

		private function stage_resizeHandler():void
		{
			this.width = this.stage.stageWidth;
			this.height = this.stage.stageHeight;
		}
	}
}
