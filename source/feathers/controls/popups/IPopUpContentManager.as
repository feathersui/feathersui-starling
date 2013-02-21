/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.popups
{
	import starling.display.DisplayObject;

	/**
	 * Dispatched when the pop-up content closes.
	 *
	 * @eventType starling.events.Event.CLOSE
	 */
	[Event(name="close",type="starling.events.Event")]

	/**
	 * Automatically manages pop-up content layout and positioning.
	 */
	public interface IPopUpContentManager
	{
		/**
		 * Displays the pop-up content.
		 *
		 * @param content		The content for the pop-up content manager to display.
		 * @param source		The source of the pop-up. May be used to position and/or size the pop-up. May be completely ignored instead.
		 */
		function open(content:DisplayObject, source:DisplayObject):void;

		/**
		 * Closes the pop-up content. If it is not opened, nothing happens.
		 */
		function close():void;

		/**
		 * Cleans up the manager.
		 */
		function dispose():void;
	}
}
