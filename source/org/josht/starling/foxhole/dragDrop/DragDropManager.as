/*
 Copyright (c) 2012 Josh Tynjala

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 */
package org.josht.starling.foxhole.dragDrop
{
	import flash.errors.IllegalOperationError;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;

	import org.josht.starling.foxhole.core.PopUpManager;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Stage;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * Handles drag and drop operations based on Starling touch events.
	 *
	 * @see IDragSource
	 * @see IDropTarget
	 * @see DragData
	 */
	public class DragDropManager
	{
		/**
		 * @private
		 * The ID of the touch that initiated the current drag.
		 */
		protected static var touchPointID:int = -1;

		/**
		 * @private
		 * The source of the current drag.
		 */
		protected static var dragSource:IDragSource;

		/**
		 * @private
		 * The data associated with the current drag.
		 */
		protected static var dragData:DragData;

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
		 * Determines if the drag and drop manager is currently handling a drag.
		 * Only one drag may be active at a time.
		 */
		public static function get isDragging():Boolean
		{
			return dragData != null;
		}

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
			dragSource = source;
			dragData = data;
			touchPointID = touch.id;
			avatar = dragAvatar;
			avatarOffsetX = dragAvatarOffsetX;
			avatarOffsetY = dragAvatarOffsetY;
			if(avatar)
			{
				avatar.touchable = false;
				const location:Point = touch.getLocation(Starling.current.stage)
				avatar.x = location.x + avatarOffsetX;
				avatar.y = location.y + avatarOffsetX;
				PopUpManager.addPopUp(avatar, false, false);
			}
			Starling.current.stage.addEventListener(TouchEvent.TOUCH, stage_touchHandler);
			Starling.current.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, nativeStage_keyDownHandler, false, 0, true);
			dragSource.onDragStart.dispatch(dragSource, data);
		}

		/**
		 * Tells the drag and drop manager if the target will accept the current
		 * drop. Meant to be called in a listener for the target's
		 * <code>onDragEnter</code> signal.
		 */
		public static function acceptDrag(target:IDropTarget):void
		{
			if(dropTarget != target)
			{
				throw new ArgumentError("Drop target cannot accept a drag at this time. Acceptance may only happen after the onDragEnter signal is dispatched and before the onDragExit signal is dispatched.");
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
				dropTarget.onDragExit.dispatch(dropTarget, dragData, dropTargetLocalX, dropTargetLocalY);
				dropTarget = null;
			}
			const source:IDragSource = dragSource;
			const data:DragData = dragData;
			cleanup();
			source.onDragComplete.dispatch(source, data, isDropped);
		}

		/**
		 * @private
		 */
		protected static function cleanup():void
		{
			if(avatar)
			{
				PopUpManager.removePopUp(avatar);
				avatar = null;
			}
			Starling.current.stage.removeEventListener(TouchEvent.TOUCH, stage_touchHandler);
			Starling.current.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN, nativeStage_keyDownHandler);
			dragSource = null;
			dragData = null;
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
			const stage:Stage = Starling.current.stage;
			const touches:Vector.<Touch> = event.getTouches(stage);
			if(touches.length == 0 || touchPointID < 0)
			{
				return;
			}
			var touch:Touch;
			for each(var currentTouch:Touch in touches)
			{
				if(currentTouch.id == touchPointID)
				{
					touch = currentTouch;
					break;
				}
			}
			if(!touch)
			{
				return;
			}
			if(touch.phase == TouchPhase.MOVED)
			{
				var location:Point = touch.getLocation(stage);
				if(avatar)
				{
					avatar.x = location.x + avatarOffsetX;
					avatar.y = location.y + avatarOffsetY;
				}
				var target:DisplayObject = stage.hitTest(location, true);
				while(target && !(target is IDropTarget))
				{
					target = target.parent;
				}
				if(target)
				{
					location = target.globalToLocal(location);
				}
				if(target != dropTarget)
				{
					if(dropTarget && isAccepted)
					{
						//notice that we can reuse the previously saved location
						dropTarget.onDragExit.dispatch(dropTarget, dragData, dropTargetLocalX, dropTargetLocalY);
					}
					dropTarget = IDropTarget(target);
					isAccepted = false;
					if(dropTarget)
					{
						dropTargetLocalX = location.x;
						dropTargetLocalY = location.y;
						dropTarget.onDragEnter.dispatch(dropTarget, dragData, dropTargetLocalX, dropTargetLocalY);
					}
				}
				else if(dropTarget)
				{
					dropTargetLocalX = location.x;
					dropTargetLocalY = location.y;
					dropTarget.onDragMove.dispatch(dropTarget, dragData, dropTargetLocalX, dropTargetLocalY)
				}
			}
			else if(touch.phase == TouchPhase.ENDED)
			{
				touchPointID = -1;
				var isDropped:Boolean = false;
				if(dropTarget && isAccepted)
				{
					dropTarget.onDragDrop.dispatch(dropTarget, dragData, dropTargetLocalX, dropTargetLocalY);
					isDropped = true;
				}
				dropTarget = null;
				completeDrag(isDropped);
				return;
			}
		}
	}
}
