/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.layout
{
	import starling.display.DisplayObject;

	/**
	 * A virtual layout that supports variable item dimensions.
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
	}
}
