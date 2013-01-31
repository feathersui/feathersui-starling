/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core
{
	/**
	 * Dispatched when the selection changes.
	 *
	 * @eventType starling.events.Event.CHANGE
	 */
	[Event(name="change",type="starling.events.Event")]

	/**
	 * An interface for something that may be selected.
	 */
	public interface IToggle extends IFeathersControl
	{
		/**
		 * Indicates if the IToggle is selected or not.
		 */
		function get isSelected():Boolean;
		
		/**
		 * @private
		 */
		function set isSelected(value:Boolean):void;
	}
}