/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.layout
{
	import flash.geom.Point;

	import starling.display.DisplayObject;

	/**
	 * Dispatched when a property of the layout changes, indicating that a
	 * redraw is probably needed.
	 *
	 * @eventType starling.events.Event.CHANGE
	 */
	[Event(name="change",type="starling.events.Event")]

	/**
	 * Interface providing layout capabilities for containers.
	 */
	public interface ILayout
	{
		/**
		 * Positions (and possibly resizes) the supplied items within the
		 * optional bounds argument. If no bounds are specified, the layout
		 * algorithm will assume that the bounds start a 0,0 and have unbounded
		 * dimensions. Returns the actual bounds of the content, which may
		 * be different than the specified bounds.
		 *
		 * <p>Note: The items are <strong>not</strong> absolutely
		 * restricted to appear only within the bounds. The bounds can affect
		 * positioning, but the algorithm may very well ignore them completely.</p>
		 *
		 */
		function layout(items:Vector.<DisplayObject>, viewPortBounds:ViewPortBounds = null, result:LayoutBoundsResult = null):LayoutBoundsResult;


		/**
		 * Using the item dimensions, calculates a scroll position that will
		 * ensure that the item at a given index will be visible within the
		 * specified bounds.
		 */
		function getScrollPositionForIndex(index:int, items:Vector.<DisplayObject>, x:Number, y:Number, width:Number, height:Number, result:Point = null):Point;
	}
}
