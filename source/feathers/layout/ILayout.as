/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

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
		 * Determines if the container calls <code>layout()</code> when the
		 * scroll position changes. Useful for transforming items as the view
		 * port scrolls. This value should be <code>true</code> for layouts that
		 * implement the <code>IVirtualLayout</code> interface and the
		 * <code>useVirtualLayout</code> property is set to <code>true</code>.
		 * May also be used by layouts that toggle item visibility as the items
		 * scroll into and out of the view port.
		 */
		function get requiresLayoutOnScroll():Boolean;

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
		 * @see feathers.core.FeathersControl#validate()
		 */
		function layout(items:Vector.<DisplayObject>, viewPortBounds:ViewPortBounds = null, result:LayoutBoundsResult = null):LayoutBoundsResult;


		/**
		 * Using the item dimensions, calculates a scroll position that will
		 * ensure that the item at a given index will be visible within the
		 * specified bounds.
		 *
		 * <p>This function should always be called <em>after</em> the
		 * <code>layout()</code> function. The width and height arguments are
		 * the final bounds of the view port.</p>
		 */
		function getScrollPositionForIndex(index:int, items:Vector.<DisplayObject>, x:Number, y:Number, width:Number, height:Number, result:Point = null):Point;
	}
}
