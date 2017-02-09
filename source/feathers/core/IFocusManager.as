/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core
{
	import starling.display.DisplayObjectContainer;

	/**
	 * Interface for focus management.
	 *
	 * @see ../../../help/focus.html Keyboard focus management in Feathers
	 * @see feathers.core.FocusManager
	 * @see feathers.core.IFocusDisplayObject
	 *
	 * @productversion Feathers 1.1.0
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
		 * The object that currently has focus. May return <code>null</code> if
		 * no object has focus.
		 *
		 * <p>In the following example, the focus is changed:</p>
		 *
		 * <listing version="3.0">
		 * focusManager.focus = someObject;</listing>
		 */
		function get focus():IFocusDisplayObject;

		/**
		 * @private
		 */
		function set focus(value:IFocusDisplayObject):void;

		/**
		 * The top-level container of the focus manager. This isn't necessarily
		 * the root of the display list.
		 */
		function get root():DisplayObjectContainer;
	}
}
