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
	 * Dispatched when the drag and drop manager begins the drag.
	 *
	 * @eventType = feathers.events.DragDropEvent.DRAG_START
	 */
	[Event(name="dragStart",type="feathers.events.DragDropEvent")]

	/**
	 * Dispatched when the drop has been completed or when the drag has been
	 * cancelled.
	 *
	 * @eventType = feathers.events.DragDropEvent.DRAG_COMPLETE
	 */
	[Event(name="dragComplete",type="feathers.events.DragDropEvent")]

	/**
	 * An object that can initiate drag actions with the drag and drop manager.
	 *
	 * @see DragDropManager
	 */
	public interface IDragSource
	{
		function dispatchEvent(event:Event):void;
		function dispatchEventWith(type:String, bubbles:Boolean = false, data:Object = null):void;
	}
}
