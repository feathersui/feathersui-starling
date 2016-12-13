/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.layout
{
	import flash.geom.Point;

	import starling.display.DisplayObject;

	/**
	 * A layout algorithm that supports virtualization of items so that only
	 * the visible items need to be created. Useful in lists with dozens or
	 * hundreds of items are needed, but only a small subset of the items are
	 * visible at any given moment.
	 *
	 * @productversion Feathers 1.0.0
	 */
	public interface IVirtualLayout extends ILayout
	{
		/**
		 * Determines if virtual layout should be used. Some components don't
		 * support virtual layouts, and they will always change this property to
		 * <code>false</code>. In those cases, the virtual layout options
		 * will be ignored.
		 */
		function get useVirtualLayout():Boolean;

		/**
		 * @private
		 */
		function set useVirtualLayout(value:Boolean):void;

		/**
		 * Used internally by a component that supports layout virtualization,
		 * such as <code>List</code>, to provide a display object with
		 * dimensions that represent a "typical" item in the layout. These
		 * dimensions will be used to fill in blanks for the layout when an
		 * item is virtual and isn't actually on the display list. If you are
		 * simply passing a layout to a component, setting this property will
		 * have no effect. It is meant to be used by the component, and the
		 * component will replace any value you pass to this property.
		 */
		function get typicalItem():DisplayObject;

		/**
		 * @private
		 */
		function set typicalItem(value:DisplayObject):void;

		/**
		 * Used internally by a component, such as <code>List</code>, to measure
		 * the view port based on the typical item dimensions or cached
		 * dimensions, if available.
		 *
		 * <p>This function is meant to be called by the <code>List</code> or
		 * other component that uses the virtual layout. If you're simply
		 * creating a layout for a <code>List</code> or another component, do
		 * not call this function. It is meant for developers creating custom
		 * components only.</p>
		 *
		 * @see #typicalItemWidth
		 * @see #typicalItemHeight
		 */
		function measureViewPort(itemCount:int, viewPortBounds:ViewPortBounds = null, result:Point = null):Point;

		/**
		 * Used internally by a component, such as <code>List</code>, to
		 * determines which indices are visible with the specified view port
		 * bounds and scroll position. Indices that aren't returned are
		 * typically not displayed and can be replaced virtually. Uses the
		 * typical items dimensions, or cached dimensions, if available.
		 *
		 * <p>This function is meant to be called by the <code>List</code> or
		 * other component that uses the virtual layout. If you're simply
		 * creating a layout for a <code>List</code> or another component, do
		 * not call this function. It is meant for developers creating custom
		 * components only.</p>
		 */
		function getVisibleIndicesAtScrollPosition(scrollX:Number, scrollY:Number, width:Number, height:Number, itemCount:int, result:Vector.<int> = null):Vector.<int>;
	}
}
