/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core
{
	/**
	 * A toggle associated with a specific group.
	 *
	 * @see ToggleGroup
	 */
	public interface IGroupedToggle extends IToggle
	{
		/**
		 * The group that the toggle has been added to.
		 */
		function get toggleGroup():ToggleGroup;

		/**
		 * @private
		 */
		function set toggleGroup(value:ToggleGroup):void;
	}
}
