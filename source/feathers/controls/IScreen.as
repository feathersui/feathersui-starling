/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.core.IFeathersControl;

	/**
	 * A screen to display in a screen navigator.
	 *
	 * @see StackScreenNavigator
	 * @see ScreenNavigator
	 */
	public interface IScreen extends IFeathersControl
	{
		/**
		 * The identifier for the screen. This value is passed in by the
		 * <code>ScreenNavigator</code> when the screen is instantiated.
		 */
		function get screenID():String;

		/**
		 * @private
		 */
		function set screenID(value:String):void;

		/**
		 * The screen navigator that is currently displaying this screen.
		 */
		function get owner():Object;

		/**
		 * @private
		 */
		function set owner(value:Object):void;
	}
}
