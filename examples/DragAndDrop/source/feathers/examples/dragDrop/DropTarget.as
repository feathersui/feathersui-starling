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
		private static const DEFAULT_COLOR:uint = 0x36322e;
		private static const HOVER_COLOR:uint = 0x26221e;

		public function DropTarget(dragFormat:String)
		{
			this._dragFormat = dragFormat;
			this.addEventListener(DragDropEvent.DRAG_ENTER, dragEnterHandler);
			this.addEventListener(DragDropEvent.DRAG_EXIT, dragExitHandler);
			this.addEventListener(DragDropEvent.DRAG_DROP, dragDropHandler);
		}

		private var _dragFormat:String;
		private var _backgroundQuad:Quad;

		override protected function initialize():void
		{
			this._backgroundQuad = new Quad(1, 1, DEFAULT_COLOR);
			this.backgroundSkin = this._backgroundQuad;
		}

		private function dragEnterHandler(event:DragDropEvent, dragData:DragData):void
		{
			if(!dragData.hasDataForFormat(this._dragFormat))
			{
				return;
			}
			DragDropManager.acceptDrag(this);
			this._backgroundQuad.color = HOVER_COLOR;
		}

		private function dragExitHandler(event:DragDropEvent, dragData:DragData):void
		{
			this._backgroundQuad.color = DEFAULT_COLOR;
		}

		private function dragDropHandler(event:DragDropEvent, dragData:DragData):void
		{
			var droppedObject:DisplayObject = DisplayObject(dragData.getDataForFormat(this._dragFormat))
			droppedObject.x = Math.min(Math.max(event.localX - droppedObject.width / 2,
				0), this.actualWidth - droppedObject.width); //keep within the bounds of the target
			droppedObject.y = Math.min(Math.max(event.localY - droppedObject.height / 2,
				0), this.actualHeight - droppedObject.height); //keep within the bounds of the target
			this.addChild(droppedObject);

			this._backgroundQuad.color = DEFAULT_COLOR;
		}
	}
}
