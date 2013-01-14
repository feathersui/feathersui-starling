/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.dragDrop
{
	import starling.events.Event;

	/**
	 * Dispatched when the touch enters the drop target's bounds. Call
	 * <code>acceptDrag()</code> on the drag and drop manager to allow
	 * the drag to the be dropped on the target.
	 *
	 * @eventType = feathers.events.DragDropEvent.DRAG_ENTER
	 */
	[Event(name="dragEnter",type="feathers.events.DragDropEvent")]

	/**
	 * Dispatched when the touch moves within the drop target's bounds.
	 *
	 * @eventType = feathers.events.DragDropEvent.DRAG_MOVE
	 */
	[Event(name="dragMove",type="feathers.events.DragDropEvent")]

	/**
	 * Dispatched when the touch exits the drop target's bounds or when
	 * the drag is cancelled while the touch is within the drop target's
	 * bounds. Will <em>not</em> be dispatched if the drop target hasn't
	 * accepted the drag.
	 *
	 * @eventType = feathers.events.DragDropEvent.DRAG_EXIT
	 */
	[Event(name="dragExit",type="feathers.events.DragDropEvent")]

	/**
	 * Dispatched when an accepted drag is dropped on the target. Will
	 * <em>not</em> be dispatched if the drop target hasn't accepted the
	 * drag.
	 *
	 * @eventType = feathers.events.DragDropEvent.DRAG_DROP
	 */
	[Event(name="dragDrop",type="feathers.events.DragDropEvent")]

	/**
	 * A display object that can accept data dropped by the drag and drop
	 * manager.
	 *
	 * @see DragDropManager
	 */
	public interface IDropTarget
	{
		function dispatchEvent(event:Event):void;
		function dispatchEventWith(type:String, bubbles:Boolean = false, data:Object = null):void;
	}
}
