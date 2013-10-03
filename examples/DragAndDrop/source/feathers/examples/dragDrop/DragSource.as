package feathers.examples.dragDrop
{
	import feathers.controls.LayoutGroup;
	import feathers.dragDrop.DragData;
	import feathers.dragDrop.DragDropManager;
	import feathers.dragDrop.IDragSource;
	import feathers.events.DragDropEvent;

	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class DragSource extends LayoutGroup implements IDragSource
	{
		public function DragSource(dragFormat:String)
		{
			this._dragFormat = dragFormat;
			this.addEventListener(TouchEvent.TOUCH, touchHandler);
			this.addEventListener(DragDropEvent.DRAG_START, dragStartHandler);
			this.addEventListener(DragDropEvent.DRAG_COMPLETE, dragCompleteHandler);
		}

		private var _background:Quad;
		private var _touchID:int = -1;
		private var _draggedObject:DisplayObject;
		private var _dragFormat:String;

		override protected function initialize():void
		{
			this._background = new Quad(1, 1, 0xffffff);
			this.addChildAt(this._background, 0);
		}

		override protected function draw():void
		{
			super.draw();
			this._background.width = this.actualWidth;
			this._background.height = this.actualHeight;
		}

		private function touchHandler(event:TouchEvent):void
		{
			if(DragDropManager.isDragging)
			{
				//one drag at a time, please
				return;
			}
			if(this._touchID >= 0)
			{
				var touch:Touch = event.getTouch(this._draggedObject, null, this._touchID);
				if(touch.phase == TouchPhase.MOVED)
				{
					this._touchID = -1;

					var avatar:Quad = new Quad(100, 100, 0x00A7FC);
					avatar.alpha = 0.5;

					var dragData:DragData = new DragData();
					dragData.setDataForFormat(this._dragFormat, this._draggedObject);
					DragDropManager.startDrag(this, touch, dragData, avatar, -avatar.width / 2, -avatar.height / 2);
				}
				else if(touch.phase == TouchPhase.ENDED)
				{
					this._touchID = -1;
				}
			}
			else
			{
				touch = event.getTouch(this, TouchPhase.BEGAN);
				if(!touch || touch.target == this || touch.target == this._background)
				{
					return;
				}
				this._touchID = touch.id;
				this._draggedObject = touch.target;
			}
		}

		private function dragStartHandler(event:DragDropEvent, dragData:DragData):void
		{
			//the drag was started with the call to DragDropManager.startDrag()
		}

		private function dragCompleteHandler(event:DragDropEvent, dragData:DragData):void
		{
			if(event.isDropped)
			{
				//the object was dropped somewhere
			}
			else
			{
				//the drag cancelled and the object was not dropped
			}
		}
	}
}
