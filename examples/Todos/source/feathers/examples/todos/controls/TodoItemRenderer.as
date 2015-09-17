package feathers.examples.todos.controls
{
	import feathers.controls.Alert;
	import feathers.controls.Button;
	import feathers.controls.Check;
	import feathers.controls.Label;
	import feathers.controls.List;
	import feathers.controls.renderers.LayoutGroupListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.examples.todos.TodoItem;
	import feathers.layout.HorizontalLayoutData;
	import feathers.skins.IStyleProvider;

	import starling.events.Event;

	public class TodoItemRenderer extends LayoutGroupListItemRenderer
	{
		public static var globalStyleProvider:IStyleProvider;
		
		public function TodoItemRenderer()
		{
			super();
		}

		protected var check:Check;
		protected var deleteButton:Button;
		protected var label:Label;
		
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return globalStyleProvider;
		}

		private var _isEditable:Boolean = false;

		public function get isEditable():Boolean
		{
			return this._isEditable;
		}

		public function set isEditable(value:Boolean):void
		{
			if(this._isEditable == value)
			{
				return;
			}
			this._isEditable = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		override public function dispose():void
		{
			if(this.check)
			{
				this.check.removeFromParent(true);
				this.check = null;
			}
			if(this.deleteButton)
			{
				this.deleteButton.removeFromParent(true);
				this.deleteButton = null;
			}
			super.dispose();
		}
		
		override protected function initialize():void
		{
			if(!this.check)
			{
				this.check = new Check();
				this.check.addEventListener(Event.CHANGE, check_changeHandler);
				this.addChild(this.check);
			}

			if(!this.label)
			{
				this.label = new Label();
				this.label.layoutData = new HorizontalLayoutData(100);
				this.addChild(this.label);
			}

			if(!this.deleteButton)
			{
				this.deleteButton = new Button();
				this.deleteButton.styleNameList.add(Button.ALTERNATE_STYLE_NAME_DANGER_BUTTON);
				this.deleteButton.label = "Delete";
				this.deleteButton.addEventListener(Event.TRIGGERED, deleteButton_triggeredHandler);
				this.addChild(this.deleteButton);
			}
		}

		override protected function commitData():void
		{
			super.commitData();
			var item:TodoItem = this._data as TodoItem;
			if(!item)
			{
				return;
			}
			this.label.text = item.description;
			
			this.check.isSelected = item.isCompleted;
			this.check.isEnabled = this._isEnabled && !this._isEditable;
			
			this.deleteButton.includeInLayout = this._isEditable;
			this.deleteButton.visible = this._isEditable;
		}

		protected function check_changeHandler(event:Event):void
		{
			var item:TodoItem = this._data as TodoItem;
			if(!item)
			{
				return;
			}
			item.isCompleted = this.check.isSelected;
		}

		protected function deleteButton_triggeredHandler(event:Event):void
		{
			Alert.show("Are you sure that you want to delete this item? This action cannot be undone.", "Confirm delete",
				new ListCollection(
				[
					{ label: "Cancel" },
					{ label: "Delete", triggered: confirmButton_triggeredHandler },
				]));
		}

		private function confirmButton_triggeredHandler(event:Event):void
		{
			List(this._owner).dataProvider.removeItemAt(this._index);
		}
	}
}
