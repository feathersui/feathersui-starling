/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.layout
{
	/**
	 * Optimizes a virtual layout by skipping a specific number of items before
	 * and after the set that is passed to <code>layout()</code>.
	 */
	public interface ITrimmedVirtualLayout extends IVirtualLayout
	{
		/**
		 * The number of virtualized items that appear before the items passed
		 * to <code>layout()</code>. Allows the array of items to be smaller
		 * than the full size. Does not work if the layout has variable item
		 * dimensions.
		 */
		function get beforeVirtualizedItemCount():int;

		/**
		 * @private
		 */
		function set beforeVirtualizedItemCount(value:int):void;

		/**
		 * The number of virtualized items that appear after the items passed
		 * to <code>layout()</code>. Allows the array of items to be smaller
		 * than the full size. Does not work if the layout has variable item
		 * dimensions.
		 */
		function get afterVirtualizedItemCount():int;

		/**
		 * @private
		 */
		function set afterVirtualizedItemCount(value:int):void;
	}
}
