package feathers.examples.dragDrop
{
	import feathers.controls.LayoutGroup;
	import feathers.dragDrop.DragData;
	import feathers.dragDrop.DragDropManager;
	import feathers.dragDrop.IDropTarget;
	import feathers.events.DragDropEvent;

	import starling.display.DisplayObject;
	import starling.display.Quad;

	public class DropTarget extends LayoutGroup implements IDropTarget
	{
		private static const DEFAULT_COLOR:uint = 0xffffff;
		private static const HOVER_COLOR:uint = 0x9AD8FF;

		public function DropTarget(dragFormat:String)
		{
			this._dragFormat = dragFormat;
			this.addEventListener(DragDropEvent.DRAG_ENTER, dragEnterHandler);
			this.addEventListener(DragDropEvent.DRAG_EXIT, dragExitHandler);
			this.addEventListener(DragDropEvent.DRAG_DROP, dragDropHandler);
		}

		private var _background:Quad;
		private var _dragFormat:String;

		override protected function initialize():void
		{
			this._background = new Quad(1, 1, DEFAULT_COLOR);
			this.addChildAt(this._background, 0);
		}

		override protected function draw():void
		{
			super.draw();
			this._background.width = this.actualWidth;
			this._background.height = this.actualHeight;
		}

		private function dragEnterHandler(event:DragDropEvent, dragData:DragData):void
		{
			if(!dragData.hasDataForFormat(this._dragFormat))
			{
				return;
			}
			DragDropManager.acceptDrag(this);
			this._background.color = HOVER_COLOR;
		}

		private function dragExitHandler(event:DragDropEvent, dragData:DragData):void
		{
			this._background.color = DEFAULT_COLOR;
		}

		private function dragDropHandler(event:DragDropEvent, dragData:DragData):void
		{
			var droppedObject:DisplayObject = DisplayObject(dragData.getDataForFormat(this._dragFormat))
			droppedObject.x = event.localX - droppedObject.width / 2;
			droppedObject.y = event.localY - droppedObject.height / 2;
			this.addChild(droppedObject);

			this._background.color = DEFAULT_COLOR;
		}
	}
}
