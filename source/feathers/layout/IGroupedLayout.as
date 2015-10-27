/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.layout
{
	/**
	 * A layout where items are divided into separate groups, with headers for
	 * each group.
	 * 
	 * @see feathers.controls.GroupedList
	 */
	public interface IGroupedLayout extends ILayout
	{
		/**
		 * Used internally by a component with grouped data to indicate which
		 * indices are headers for a group.
		 */
		function get headerIndices():Vector.<int>;

		/**
		 * @private
		 */
		function set headerIndices(value:Vector.<int>):void;
	}
}
