/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	/**
	 * Dispatched when the scroll bar's value changes.
	 *
	 * @eventType starling.events.Event.CHANGE
	 */
	[Event(name="change",type="starling.events.Event")]

	/**
	 * Minimum requirements for a scroll bar to be usable with a <code>Scroller</code>
	 * component.
	 *
	 * @see Scroller
	 */
	public interface IScrollBar extends IRange
	{

		/**
		 * The amount the scroll bar value must change to get from one "page" to
		 * the next.
		 *
		 * <p>In the following example, the page is changed to 10:</p>
		 *
		 * <listing version="3.0">
		 * scrollBar.minimum = 0;
		 * scrollBar.maximum = 100;
		 * scrollBar.step = 1;
		 * scrollBar.page = 10
		 * scrollBar.value = 12;</listing>
		 */
		function get page():Number;

		/**
		 * @private
		 */
		function set page(value:Number):void;
	}
}
