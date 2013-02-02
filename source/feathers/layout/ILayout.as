/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.layout
{
	import feathers.core.IFeathersEventDispatcher;

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
	public interface ILayout extends IFeathersEventDispatcher
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
		 * <p>If a layout implementation needs to access accurate <code>width</code>
		 * and <code>height</code> values from items that are of type
		 * <code>IFeathersControl</code>, it must call <code>validate()</code>
		 * manually. For performance reasons, the container that is the parent
		 * of the items will not call <code>validate()</code> before passing the
		 * items to a layout implementation. Meeting this requirement may be as
		 * simple as looping through the items at the beginning of
		 * <code>layout()</code> and validating all items that are Feathers UI
		 * controls:</p>
		 *
		 * <listing version="3.0">
		 * const itemCount:int = items.length;
		 * for(var i:int = 0; i &lt; itemCount; i++)
		 * {
		 *     var item:IFeathersControl = items[i] as IFeathersControl;
		 *     if(item)
		 *     {
		 *         item.validate();
		 *     }
		 * }</listing>
		 * 
		 * @see feathers.core.IFeathersControl#validate()  
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
