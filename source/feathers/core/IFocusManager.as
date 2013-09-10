/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core
{
	/**
	 * Interface for focus management.
	 *
	 * @see feathers.core.IFocusDisplayObject
	 * @see feathers.core.FocusManager
	 */
	public interface IFocusManager
	{
		/**
		 * Determines if this focus manager is enabled. A focus manager may be
		 * disabled when another focus manager has control, such as when a
		 * modal pop-up is displayed.
		 */
		function get isEnabled():Boolean;

		/**
		 * @private
		 */
		function set isEnabled(value:Boolean):void;

		/**
		 * The object that currently has focus. May be <code>null</code> if no
		 * object has focus.
		 *
		 * <p>In the following example, the focus is changed:</p>
		 *
		 * <listing version="3.0">
		 * object.focus = someObject;</listing>
		 */
		function get focus():IFocusDisplayObject;

		/**
		 * @private
		 */
		function set focus(value:IFocusDisplayObject):void;
	}
}
