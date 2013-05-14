/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.layout
{
	import flash.geom.Point;

	/**
	 * A layout algorithm that supports virtualization of items so that only
	 * the visible items need to be created. Useful in lists with dozens or
	 * hundreds of items are needed, but only a small subset of the items are
	 * visible at any given moment.
	 */
	public interface IVirtualLayout extends ILayout
	{
		/**
		 * Determines if virtual layout can be used. Some components don't
		 * support virtual layouts. In those cases, the virtual layout options
		 * will be ignored.
		 */
		function get useVirtualLayout():Boolean;

		/**
		 * @private
		 */
		function set useVirtualLayout(value:Boolean):void;

		/**
		 * The width, in pixels, of a "typical" item that is used to virtually
		 * fill in blanks for the layout. This value is meant to be set by a
		 * component that is using the layout, such as a <code>List</code>. For
		 * instance, the <code>List</code> class provides a <code>typicalItem</code>
		 * property that will be used to calculate this value. If you set
		 * <code>typicalItemWidth</code> manually, your value will be completely
		 * replaced by the value calculated by the <code>List</code>. In other
		 * words, you should use that <code>typicalItem</code> property instead.
		 */
		function get typicalItemWidth():Number;

		/**
		 * @private
		 */
		function set typicalItemWidth(value:Number):void;

		/**
		 * The height, in pixels, of a "typical" item that is used to virtually
		 * fill in blanks for the layout. This value is usually set by a
		 * component that is using the layout, such as a <code>List</code>. For
		 * instance, the <code>List</code> class provides a <code>typicalItem</code>
		 * property that will be used to calculate this value. If you set
		 * <code>typicalItemHeight</code> manually, your value will be completely
		 * replaced by the value calculated by the <code>List</code>. In other
		 * words, you should use that <code>typicalItem</code> property instead.
		 */
		function get typicalItemHeight():Number;

		/**
		 * @private
		 */
		function set typicalItemHeight(value:Number):void;

		/**
		 * Using the typical item bounds and suggested bounds, returns a set of
		 * calculated dimensions for the view port.
		 */
		function measureViewPort(itemCount:int, viewPortBounds:ViewPortBounds = null, result:Point = null):Point;

		/**
		 * Determines which indices are visible with the specified view port
		 * bounds and scroll position. Indices that aren't returned are
		 * typically not displayed and can be replaced virtually.
		 */
		function getVisibleIndicesAtScrollPosition(scrollX:Number, scrollY:Number, width:Number, height:Number, itemCount:int, result:Vector.<int> = null):Vector.<int>;
	}
}
