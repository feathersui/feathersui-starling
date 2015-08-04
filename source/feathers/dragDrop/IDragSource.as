/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.dragDrop
{
	import starling.events.Event;

	/**
	 * Dispatched when the drag and drop manager begins the drag.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>Same as the dragData property.</td></tr>
	 * <tr><td><code>dragData</code></td><td>The <code>feathers.dragDrop.DragData</code>
	 *   instance associated with this drag.</td></tr>
	 * <tr><td><code>isDropped</code></td><td>false</td></tr>
	 * <tr><td><code>localX</code></td><td>NaN</td></tr>
	 * <tr><td><code>localY</code></td><td>NaN</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @eventType feathers.events.DragDropEvent.DRAG_START
	 */
	[Event(name="dragStart",type="feathers.events.DragDropEvent")]

	/**
	 * Dispatched when the drop has been completed or when the drag has been
	 * cancelled.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>Same as the dragData property.</td></tr>
	 * <tr><td><code>dragData</code></td><td>The <code>feathers.dragDrop.DragData</code>
	 *   instance associated with this drag.</td></tr>
	 * <tr><td><code>isDropped</code></td><td>true, if the dragged object was dropped; false, if it was not.</td></tr>
	 * <tr><td><code>localX</code></td><td>NaN</td></tr>
	 * <tr><td><code>localY</code></td><td>NaN</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @eventType feathers.events.DragDropEvent.DRAG_COMPLETE
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
