/*
Feathers
Copyright 2012-2018 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.layout
{
	import starling.display.DisplayObject;

	/**
	 * Dispatched when the layout would like to adjust the container's scroll
	 * position. Typically, this is used when the virtual dimensions of an item
	 * differ from its real dimensions. This event allows the container to
	 * adjust scrolling so that it appears smooth, without jarring jumps or
	 * shifts when an item resizes.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>A <code>flash.geom.Point</code> object
	 *   representing how much the scroll position should be adjusted in both
	 *   horizontal and vertical directions. Measured in pixels.</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @eventType starling.events.Event.SCROLL
	 */
	[Event(name="scroll",type="starling.events.Event")]

	/**
	 * A virtual layout that supports variable item dimensions.
	 *
	 * @productversion Feathers 1.0.0
	 */
	public interface IVariableVirtualLayout extends IVirtualLayout
	{
		/**
		 * When the layout is virtualized, and this value is true, the items may
		 * have variable dimensions. If false, the items will all share the
		 * same dimensions as the typical item. Performance is better for
		 * layouts where all items have the same dimensions.
		 */
		function get hasVariableItemDimensions():Boolean;

		/**
		 * @private
		 */
		function set hasVariableItemDimensions(value:Boolean):void;

		/**
		 * Clears the cached dimensions for all virtualized indices.
		 */
		function resetVariableVirtualCache():void;

		/**
		 * Clears the cached dimensions for one specific virtualized index.
		 */
		function resetVariableVirtualCacheAtIndex(index:int, item:DisplayObject = null):void;

		/**
		 * Inserts an item in to the cache at the specified index, pushing the
		 * old cached value at that index, and all following values, up one
		 * index.
		 */
		function addToVariableVirtualCacheAtIndex(index:int, item:DisplayObject = null):void;

		/**
		 * Removes an item in to the cache at the specified index, moving the
		 * values at following indexes down by one.
		 */
		function removeFromVariableVirtualCacheAtIndex(index:int):void;
	}
}
