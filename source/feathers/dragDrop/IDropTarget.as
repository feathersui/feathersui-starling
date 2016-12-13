/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

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
	 * <tr><td><code>localX</code></td><td>The x location, in pixels, of the
	 * current action, in the local coordinate system of the <code>IDropTarget</code>.</td></tr>
	 * <tr><td><code>localY</code></td><td>The y location, in pixels, of the
	 * current action, in the local coordinate system of the <code>IDropTarget</code>.</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @eventType feathers.events.DragDropEvent.DRAG_ENTER
	 */
	[Event(name="dragEnter",type="feathers.events.DragDropEvent")]

	/**
	 * Dispatched when the touch moves within the drop target's bounds.
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
	 * <tr><td><code>localX</code></td><td>The x location, in pixels, of the
	 * current action, in the local coordinate system of the <code>IDropTarget</code>.</td></tr>
	 * <tr><td><code>localY</code></td><td>The y location, in pixels, of the
	 * current action, in the local coordinate system of the <code>IDropTarget</code>.</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @eventType feathers.events.DragDropEvent.DRAG_MOVE
	 */
	[Event(name="dragMove",type="feathers.events.DragDropEvent")]

	/**
	 * Dispatched when the touch exits the drop target's bounds or when
	 * the drag is cancelled while the touch is within the drop target's
	 * bounds. Will <em>not</em> be dispatched if the drop target hasn't
	 * accepted the drag.
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
	 * <tr><td><code>localX</code></td><td>The x location, in pixels, of the
	 * current action, in the local coordinate system of the <code>IDropTarget</code>.</td></tr>
	 * <tr><td><code>localY</code></td><td>The y location, in pixels, of the
	 * current action, in the local coordinate system of the <code>IDropTarget</code>.</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @eventType feathers.events.DragDropEvent.DRAG_EXIT
	 */
	[Event(name="dragExit",type="feathers.events.DragDropEvent")]

	/**
	 * Dispatched when an accepted drag is dropped on the target. Will
	 * <em>not</em> be dispatched if the drop target hasn't accepted the
	 * drag.
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
	 * <tr><td><code>isDropped</code></td><td>true</td></tr>
	 * <tr><td><code>localX</code></td><td>The x location, in pixels, of the
	 * current action, in the local coordinate system of the <code>IDropTarget</code>.</td></tr>
	 * <tr><td><code>localY</code></td><td>The y location, in pixels, of the
	 * current action, in the local coordinate system of the <code>IDropTarget</code>.</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @eventType feathers.events.DragDropEvent.DRAG_DROP
	 */
	[Event(name="dragDrop",type="feathers.events.DragDropEvent")]

	/**
	 * A display object that can accept data dropped by the drag and drop
	 * manager.
	 *
	 * @see feathers.dragDrop.DragDropManager
	 *
	 * @productversion Feathers 1.0.0
	 */
	public interface IDropTarget
	{
		function dispatchEvent(event:Event):void;
		function dispatchEventWith(type:String, bubbles:Boolean = false, data:Object = null):void;
	}
}
