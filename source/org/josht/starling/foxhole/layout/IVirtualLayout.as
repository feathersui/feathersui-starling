package org.josht.starling.foxhole.layout
{
	import flash.geom.Point;

	/**
	 * A layout algorithm that supports virtualization of items so that only
	 * the visible items need to be created. Useful in lists with dozens or
	 * hundreds of items are needed, but only a small subset is visible at any
	 * given monent.
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
		 * fill in blanks for the layout.
		 */
		function get typicalItemWidth():Number;

		/**
		 * @private
		 */
		function set typicalItemWidth(value:Number):void;

		/**
		 * The width, in pixels, of a "typical" item that is used to virtually
		 * fill in blanks for the layout.
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
		 * Determines which index (using the typical item dimensions) is the
		 * first to appear at the specified scroll position (it may be partially
		 * cut off at the edge). Items appearing before the specified index are
		 * typically not displayed and can be replaced virtually by the typical
		 * item.
		 */
		function getMinimumItemIndexAtScrollPosition(scrollX:Number, scrollY:Number, width:Number, height:Number, itemCount:int):int;

		/**
		 * Determines which index (using the typical item dimensions) is the
		 * last to appear at the specified scroll position (it may be partially
		 * cut off at the edge). Items appearing after the specified index are
		 * typically not displayed and can be replaced virtually by the typical
		 * item.
		 */
		function getMaximumItemIndexAtScrollPosition(scrollX:Number, scrollY:Number, width:Number, height:Number, itemCount:int):int;

		/**
		 * Using the typical item dimensions, calculates a scroll position that
		 * will ensure that the item at a given index will be visible within the
		 * specified bounds.
		 */
		function getScrollPositionForItemIndexAndBounds(index:int, width:Number, height:Number, result:Point = null):Point;
	}
}
