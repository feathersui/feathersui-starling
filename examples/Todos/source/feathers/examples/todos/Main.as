package feathers.examples.todos
{
	import feathers.controls.Alert;
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.LayoutGroup;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.controls.TextInput;
	import feathers.controls.ToggleButton;
	import feathers.controls.text.StageTextTextEditor;
	import feathers.core.FeathersControl;
	import feathers.core.IFeathersControl;
	import feathers.core.ITextEditor;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.examples.todos.controls.TodoItemRenderer;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.HorizontalLayoutData;

	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

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
		private var _toolbar:LayoutGroup;
		private var _input:TextInput;
		private var _clearButton:Button;
		private var _editButton:ToggleButton;
		
		private var _touchID:int = -1;
		private var _previousGlobalTouchY:Number;

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

			this._list = new List();
			this._list.isSelectable = false;
			this._list.dataProvider = new ListCollection();
			this._list.itemRendererType = TodoItemRenderer;
			this.addChild(this._list);

			this._toolbar = new LayoutGroup();
			this._toolbar.styleNameList.add(LayoutGroup.ALTERNATE_STYLE_NAME_TOOLBAR);
			this.addChild(this._toolbar);
			
			this._clearButton = new Button();
			this._clearButton.styleNameList.add(Button.ALTERNATE_STYLE_NAME_DANGER_BUTTON);
			this._clearButton.label = "Delete All Checked Items";
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
			
			var listLayoutData:AnchorLayoutData = new AnchorLayoutData();
			listLayoutData.top = 0;
			listLayoutData.topAnchorDisplayObject = this._toolbar;
			listLayoutData.right = 0;
			listLayoutData.bottom = 0;
			listLayoutData.left = 0;
			this._list.layoutData = listLayoutData;
			this._list.addEventListener(TouchEvent.TOUCH, list_touchHandler);
		}

		private function dragToolbar(touch:Touch):void
		{
			var currentGlobalTouchY:Number = touch.globalY;
			var newPosition:Number = this._toolbar.y + currentGlobalTouchY - this._previousGlobalTouchY;
			var minHeaderPosition:Number = -this._toolbar.height;
			if(newPosition < minHeaderPosition)
			{
				newPosition = minHeaderPosition;
			}
			if(newPosition > 0)
			{
				newPosition = 0;
			}
			this._previousGlobalTouchY = currentGlobalTouchY;

			var headerLayoutData:AnchorLayoutData = AnchorLayoutData(this._toolbar.layoutData);
			headerLayoutData.top = newPosition;
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
			var isEditing:Boolean = this._editButton.isSelected;
			this._list.itemRendererProperties.isEditable = isEditing;
			this._clearButton.visible = isEditing;
			this._clearButton.includeInLayout = isEditing;
			this._input.visible = !isEditing;
			this._input.includeInLayout = !isEditing;
		}
		
		private function clearButton_triggeredHandler(event:Event):void
		{
			var hasCompletedItem:Boolean = false;
			var itemCount:int = this._list.dataProvider.length;
			for(var i:int = itemCount - 1; i >= 0; i--)
			{
				var item:TodoItem = TodoItem(this._list.dataProvider.getItemAt(i));
				if(item.isCompleted)
				{
					hasCompletedItem = true;
					break;
				}
			}
			if(!hasCompletedItem)
			{
				return;
			}
			
			Alert.show("Are you sure that you want to delete all checked items? This action cannot be undone.", "Confirm delete",
				new ListCollection(
				[
					{ label: "Cancel" },
					{ label: "Delete", triggered: confirmButton_triggeredHandler },
				]));
		}
		
		private function confirmButton_triggeredHandler(event:Event):void
		{
			var itemCount:int = this._list.dataProvider.length;
			for(var i:int = itemCount - 1; i >= 0; i--)
			{
				var item:TodoItem = TodoItem(this._list.dataProvider.getItemAt(i));
				if(item.isCompleted)
				{
					this._list.dataProvider.removeItemAt(i);
				}
			}
		}

		private function stage_resizeHandler():void
		{
			this.width = this.stage.stageWidth;
			this.height = this.stage.stageHeight;
		}
		
		private function list_touchHandler(event:TouchEvent):void
		{
			if(this._touchID >= 0)
			{
				var touch:Touch = event.getTouch(this._list, null, this._touchID);
				if(!touch)
				{
					return;
				}
				if(touch.phase == TouchPhase.MOVED)
				{
					this.dragToolbar(touch);
				}
				else if(touch.phase == TouchPhase.ENDED)
				{
					this._touchID = -1;
				}
			}
			else
			{
				touch = event.getTouch(this._list, TouchPhase.BEGAN);
				if(!touch)
				{
					return;
				}
				this._touchID = touch.id;
				this._previousGlobalTouchY = touch.globalY;
			}
		}
	}
}
