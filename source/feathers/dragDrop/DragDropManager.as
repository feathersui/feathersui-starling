/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.dragDrop
{
	import feathers.core.PopUpManager;
	import feathers.events.DragDropEvent;

	import flash.errors.IllegalOperationError;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Stage;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * Handles drag and drop operations based on Starling touch events.
	 *
	 * @see feathers.dragDrop.IDragSource
	 * @see feathers.dragDrop.IDropTarget
	 * @see feathers.dragDrop.DragData
	 *
	 * @productversion Feathers 1.0.0
	 */
	public class DragDropManager
	{
		/**
		 * @private
		 */
		private static const HELPER_POINT:Point = new Point();

		/**
		 * @private
		 */
		protected static var _touchPointID:int = -1;

		/**
		 * The ID of the touch that initiated the current drag. Returns <code>-1</code>
		 * if there is not an active drag action. In multi-touch applications,
		 * knowing the touch ID is useful if additional actions need to happen
		 * using the same touch.
		 */
		public static function get touchPointID():int
		{
			return _touchPointID;
		}

		/**
		 * @private
		 */
		protected static var _dragSource:IDragSource;

		/**
		 * The <code>IDragSource</code> that started the current drag.
		 */
		public static function get dragSource():IDragSource
		{
			return _dragSource;
		}

		/**
		 * @private
		 */
		protected static var _dragData:DragData;

		/**
		 * Determines if the drag and drop manager is currently handling a drag.
		 * Only one drag may be active at a time.
		 */
		public static function get isDragging():Boolean
		{
			return _dragData != null;
		}

		/**
		 * The data associated with the current drag. Returns <code>null</code>
		 * if there is not a current drag.
		 */
		public static function get dragData():DragData
		{
			return _dragData;
		}

		/**
		 * @private
		 * The current target of the current drag.
		 */
		protected static var dropTarget:IDropTarget;

		/**
		 * @private
		 * Indicates if the current drag has been accepted by the dropTarget.
		 */
		protected static var isAccepted:Boolean = false;

		/**
		 * @private
		 * The avatar for the current drag data.
		 */
		protected static var avatar:DisplayObject;

		/**
		 * @private
		 */
		protected static var avatarOffsetX:Number;

		/**
		 * @private
		 */
		protected static var avatarOffsetY:Number;

		/**
		 * @private
		 */
		protected static var dropTargetLocalX:Number;

		/**
		 * @private
		 */
		protected static var dropTargetLocalY:Number;

		/**
		 * @private
		 */
		protected static var avatarOldTouchable:Boolean;

		/**
		 * Starts a new drag. If another drag is currently active, it is
		 * immediately cancelled. Includes an optional "avatar", a visual
		 * representation of the data that is being dragged.
		 */
		public static function startDrag(source:IDragSource, touch:Touch, data:DragData, dragAvatar:DisplayObject = null, dragAvatarOffsetX:Number = 0, dragAvatarOffsetY:Number = 0):void
		{
			if(isDragging)
			{
				cancelDrag();
			}
			if(!source)
			{
				throw new ArgumentError("Drag source cannot be null.");
			}
			if(!data)
			{
				throw new ArgumentError("Drag data cannot be null.");
			}
			_dragSource = source;
			_dragData = data;
			_touchPointID = touch.id;
			avatar = dragAvatar;
			avatarOffsetX = dragAvatarOffsetX;
			avatarOffsetY = dragAvatarOffsetY;
			var stage:Stage = DisplayObject(source).stage;
			touch.getLocation(stage, HELPER_POINT);
			if(avatar)
			{
				avatarOldTouchable = avatar.touchable;
				avatar.touchable = false;
				avatar.x = HELPER_POINT.x + avatarOffsetX;
				avatar.y = HELPER_POINT.y + avatarOffsetY;
				PopUpManager.addPopUp(avatar, false, false);
			}
			stage.addEventListener(TouchEvent.TOUCH, stage_touchHandler);
			var starling:Starling = stage.starling;
			starling.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, nativeStage_keyDownHandler, false, 0, true);
			_dragSource.dispatchEvent(new DragDropEvent(DragDropEvent.DRAG_START, data, false));

			updateDropTarget(HELPER_POINT);
		}

		/**
		 * Tells the drag and drop manager if the target will accept the current
		 * drop. Meant to be called in a listener for the target's
		 * <code>DragDropEvent.DRAG_ENTER</code> event.
		 */
		public static function acceptDrag(target:IDropTarget):void
		{
			if(dropTarget != target)
			{
				throw new ArgumentError("Drop target cannot accept a drag at this time. Acceptance may only happen after the DragDropEvent.DRAG_ENTER event is dispatched and before the DragDropEvent.DRAG_EXIT event is dispatched.");
			}
			isAccepted = true;
		}

		/**
		 * Immediately cancels the current drag.
		 */
		public static function cancelDrag():void
		{
			if(!isDragging)
			{
				return;
			}
			completeDrag(false);
		}

		/**
		 * @private
		 */
		protected static function completeDrag(isDropped:Boolean):void
		{
			if(!isDragging)
			{
				throw new IllegalOperationError("Drag cannot be completed because none is currently active.");
			}
			if(dropTarget)
			{
				dropTarget.dispatchEvent(new DragDropEvent(DragDropEvent.DRAG_EXIT, _dragData, false, dropTargetLocalX, dropTargetLocalY));
				dropTarget = null;
			}
			var source:IDragSource = _dragSource;
			var data:DragData = _dragData;
			cleanup();
			source.dispatchEvent(new DragDropEvent(DragDropEvent.DRAG_COMPLETE, data, isDropped));
		}

		/**
		 * @private
		 */
		protected static function cleanup():void
		{
			if(avatar)
			{
				//may have been removed from parent already in the drop listener
				if(PopUpManager.isPopUp(avatar))
				{
					PopUpManager.removePopUp(avatar);
				}
				avatar.touchable = avatarOldTouchable;
				avatar = null;
			}
			var stage:Stage = DisplayObject(_dragSource).stage;
			var starling:Starling = stage.starling;
			stage.removeEventListener(TouchEvent.TOUCH, stage_touchHandler);
			starling.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN, nativeStage_keyDownHandler);
			_dragSource = null;
			_dragData = null;
		}

		/**
		 * @private
		 */
		protected static function updateDropTarget(location:Point):void
		{
			var stage:Stage = DisplayObject(_dragSource).stage;
			var target:DisplayObject = stage.hitTest(location);
			while(target && !(target is IDropTarget))
			{
				target = target.parent;
			}
			if(target)
			{
				target.globalToLocal(location, location);
			}
			if(target != dropTarget)
			{
				if(dropTarget)
				{
					//notice that we can reuse the previously saved location
					dropTarget.dispatchEvent(new DragDropEvent(DragDropEvent.DRAG_EXIT, _dragData, false, dropTargetLocalX, dropTargetLocalY));
				}
				dropTarget = IDropTarget(target);
				isAccepted = false;
				if(dropTarget)
				{
					dropTargetLocalX = location.x;
					dropTargetLocalY = location.y;
					dropTarget.dispatchEvent(new DragDropEvent(DragDropEvent.DRAG_ENTER, _dragData, false, dropTargetLocalX, dropTargetLocalY));
				}
			}
			else if(dropTarget)
			{
				dropTargetLocalX = location.x;
				dropTargetLocalY = location.y;
				dropTarget.dispatchEvent(new DragDropEvent(DragDropEvent.DRAG_MOVE, _dragData, false, dropTargetLocalX, dropTargetLocalY));
			}
		}

		/**
		 * @private
		 */
		protected static function nativeStage_keyDownHandler(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.ESCAPE || event.keyCode == Keyboard.BACK)
			{
				event.preventDefault();
				cancelDrag();
			}
		}

		/**
		 * @private
		 */
		protected static function stage_touchHandler(event:TouchEvent):void
		{
			var stage:Stage = Stage(event.currentTarget);
			var touch:Touch = event.getTouch(stage, null, _touchPointID);
			if(!touch)
			{
				return;
			}
			if(touch.phase == TouchPhase.MOVED)
			{
				touch.getLocation(stage, HELPER_POINT);
				if(avatar)
				{
					avatar.x = HELPER_POINT.x + avatarOffsetX;
					avatar.y = HELPER_POINT.y + avatarOffsetY;
				}
				updateDropTarget(HELPER_POINT);
			}
			else if(touch.phase == TouchPhase.ENDED)
			{
				_touchPointID = -1;
				var isDropped:Boolean = false;
				if(dropTarget && isAccepted)
				{
					dropTarget.dispatchEvent(new DragDropEvent(DragDropEvent.DRAG_DROP, _dragData, true, dropTargetLocalX, dropTargetLocalY));
					isDropped = true;
				}
				dropTarget = null;
				completeDrag(isDropped);
			}
		}
	}
}
