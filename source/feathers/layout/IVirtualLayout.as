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
	 * A layout algorithm that supports virtualization of items so that only
	 * the visible items need to be created. Useful in lists with dozens or
	 * hundreds of items are needed, but only a small subset of the items are
	 * visible at any given moment.
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
		 * Used internally by a component that supports virtualized layouts,
		 * such as <code>List</code>, to provide a display object with
		 * dimensions that represent a "typical" item in the layout. These
		 * dimensions will be used to fill in blanks for the layout when an
		 * item is virtual and isn't actually on the display list.
		 *
		 * <p>The <code>typicalItem</code> property is considered
		 * exclusively internal to Feathers components like <code>List</code>
		 * and other components that support layout virtualization. However,
		 * the <code>typicalItemWidth</code> and <code>typicalItemHeight</code>
		 * properties may be used anywhere and they take precedence over
		 * <code>typicalItem</code>. <strong>If you are simply setting a layout
		 * on a component, use <code>typicalItemWidth</code> and
		 * <code>typicalItemHeight</code> instead of <code>typicalItem</code>.</strong></p>
		 *
		 * @see #typicalItemWidth
		 * @see #typicalItemHeight
		 */
		function get typicalItem():DisplayObject;

		/**
		 * @private
		 */
		function set typicalItem(value:DisplayObject):void;

		/**
		 * Used to provide the width, in pixels, of a "typical" item that is
		 * used to virtually fill in blanks for the layout when an
		 * item is virtual and isn't actually on the display list.
		 *
		 * <p>The related <code>typicalItem</code> property is considered
		 * exclusively internal to Feathers components like <code>List</code>
		 * and other components that support layout virtualization. However,
		 * the <code>typicalItemWidth</code> and <code>typicalItemHeight</code>
		 * properties may be used anywhere and they take precedence over
		 * <code>typicalItem</code>.</p>
		 *
		 * @see #typicalItemHeight
		 */
		function get typicalItemWidth():Number;

		/**
		 * @private
		 */
		function set typicalItemWidth(value:Number):void;

		/**
		 * Used to provide the height, in pixels, of a "typical" item that is
		 * used to virtually fill in blanks for the layout when an
		 * item is virtual and isn't actually on the display list.
		 *
		 * <p>The related <code>typicalItem</code> property is considered
		 * exclusively internal to Feathers components like <code>List</code>
		 * and other components that support layout virtualization. However,
		 * the <code>typicalItemWidth</code> and <code>typicalItemHeight</code>
		 * properties may be used anywhere and they take precedence over
		 * <code>typicalItem</code>.</p>
		 *
		 * @see #typicalItemWidth
		 */
		function get typicalItemHeight():Number;

		/**
		 * @private
		 */
		function set typicalItemHeight(value:Number):void;

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
