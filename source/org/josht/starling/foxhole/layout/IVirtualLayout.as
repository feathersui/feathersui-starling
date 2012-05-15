package org.josht.starling.foxhole.layout
{
	import flash.geom.Point;

	public interface IVirtualLayout extends ILayout
	{
		function get useVirtualLayout():Boolean;
		function set useVirtualLayout(value:Boolean):void;

		function get typicalItemWidth():Number;
		function set typicalItemWidth(value:Number):void;
		function get typicalItemHeight():Number;
		function set typicalItemHeight(value:Number):void;

		function getMinimumItemIndexAtScrollPosition(scrollX:Number, scrollY:Number, width:Number, height:Number):int;
		function getMaximumItemIndexAtScrollPosition(scrollX:Number, scrollY:Number, width:Number, height:Number):int;

		/**
		 * Calculates a scroll position that will ensures that a given index
		 * will be visible within the specified bounds.
		 */
		function getScrollPositionForItemIndexAndBounds(index:int, width:Number, height:Number, result:Point = null):Point;
	}
}
