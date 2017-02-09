/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.supportClasses
{
	import starling.display.DisplayObject;

	/**
	 * @private
	 * A simple interface for screen navigator items to be used by
	 * <code>BaseScreenNavigator</code>.
	 *
	 * @see BaseScreenNavigator
	 *
	 * @productversion Feathers 2.1.0
	 */
	public interface IScreenNavigatorItem
	{
		/**
		 * Determines if a display object returned by <code>getScreen()</code>
		 * can be disposed or not when a screen is no longer active.
		 *
		 * @see #getScreen()
		 */
		function get canDispose():Boolean;

		/**
		 * Returns a display object instance of this screen.
		 */
		function getScreen():DisplayObject;
	}
}
