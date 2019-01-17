/*
Feathers
Copyright 2012-2019 Bowler Hat LLC. All Rights Reserved.

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
		 * An optional event that the screen will dispatch when it's ready for
		 * the transition to start. If <code>null</code>, the transition will
		 * start immediately.
		 * 
		 * <p>Useful for loading assets or doing other long tasks to prepare
		 * the screen before it is shown. It is recommended to display some
		 * kind of progress indicator over the previous screen during this
		 * delay to ensure that users don't get confused and think that the
		 * app has frozen.</p>
		 */
		function get transitionDelayEvent():String;

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
