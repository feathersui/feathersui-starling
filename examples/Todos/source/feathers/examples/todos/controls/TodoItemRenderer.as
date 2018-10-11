package feathers.examples.todos.controls
{
	import feathers.controls.Alert;
	import feathers.controls.Button;
	import feathers.controls.Check;
	import feathers.controls.Label;
	import feathers.controls.List;
	import feathers.controls.renderers.LayoutGroupListItemRenderer;
	import feathers.data.ArrayCollection;
	import feathers.examples.todos.TodoItem;
	import feathers.layout.HorizontalLayoutData;
	import feathers.skins.IStyleProvider;

	import starling.events.Event;
	import starling.display.DisplayObject;
	import feathers.controls.renderers.IDragAndDropItemRenderer;
	import feathers.controls.LayoutGroup;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.VerticalAlign;

	public class TodoItemRenderer extends LayoutGroupListItemRenderer implements IDragAndDropItemRenderer
	{
		public static const EVENT_DELETE_ITEM:String = "deleteItem";

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

		private var _dragEnabled:Boolean = false;

		public function get dragEnabled():Boolean
		{
			return this._dragEnabled;
		}

		public function set dragEnabled(value:Boolean):void
		{
			if(this._dragEnabled == value)
			{
				return;
			}
			this._dragEnabled = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		public function get dragProxy():DisplayObject
		{
			return this._dragIcon;
		}

		private var _dragIconContainer:LayoutGroup;

		private var _dragIcon:DisplayObject;

		public function get dragIcon():DisplayObject
		{
			return this._dragIcon;
		}

		public function set dragIcon(value:DisplayObject):void
		{
			if(this._dragIcon == value)
			{
				return;
			}
			if(this._dragIcon && this._dragIcon.parent == this._dragIconContainer)
			{
				this._dragIcon.removeFromParent(false);
			}
			this._dragIcon = value;
			if(this._dragIcon)
			{
				if(!this._dragIconContainer)
				{
					this._dragIconContainer = new LayoutGroup();
					var layout:HorizontalLayout = new HorizontalLayout();
					layout.horizontalAlign = HorizontalAlign.CENTER;
					layout.verticalAlign = VerticalAlign.MIDDLE;
					this._dragIconContainer.layout = layout;
					this.addChildAt(this._dragIconContainer, 0);
				}
				this._dragIconContainer.addChild(this._dragIcon)
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
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

		override protected function preLayout():void
		{
			if(this._dragIconContainer)
			{
				this.check.validate();
				this._dragIconContainer.width = this.check.width;
				this._dragIconContainer.height = this.check.height;
				this.setChildIndex(this._dragIconContainer, 0);
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
			this.check.isEnabled = this._isEnabled;
			this.check.includeInLayout = !this._dragEnabled;
			this.check.visible = !this._dragEnabled;
			
			this.deleteButton.includeInLayout = this._dragEnabled;
			this.deleteButton.visible = this._dragEnabled;
			
			if(this._dragIconContainer)
			{
				this._dragIconContainer.includeInLayout = this._dragEnabled;
				this._dragIconContainer.visible = this._dragEnabled;
			}
		}

		protected function check_changeHandler(event:Event):void
		{
			var item:TodoItem = this._data as TodoItem;
			if(!item)
			{
				return;
			}
			var isCompleted:Boolean = this.check.isSelected;
			if(item.isCompleted == isCompleted)
			{
				return;
			}
			item.isCompleted = isCompleted;
			this.dispatchEventWith(Event.CHANGE);
		}

		protected function deleteButton_triggeredHandler(event:Event):void
		{
			Alert.show("Are you sure that you want to delete this item? This action cannot be undone.", "Confirm delete",
				new ArrayCollection(
				[
					{ label: "Cancel" },
					{ label: "Delete", triggered: confirmButton_triggeredHandler },
				]));
		}

		private function confirmButton_triggeredHandler(event:Event):void
		{
			this.dispatchEventWith(EVENT_DELETE_ITEM, false, this._data);
		}
	}
}
