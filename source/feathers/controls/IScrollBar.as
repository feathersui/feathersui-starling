/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.core.IFeathersControl;

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
	public interface IScrollBar extends IFeathersControl
	{
		/**
		 * The minimum value of the scroll bar.
		 *
		 * <p>In the following example, the minimum is changed to 0:</p>
		 *
		 * <listing version="3.0">
		 * scrollBar.minimum = 0;
		 * scrollBar.maximum = 100;
		 * scrollBar.step = 1;
		 * scrollBar.page = 10
		 * scrollBar.value = 12;</listing>
		 */
		function get minimum():Number;

		/**
		 * @private
		 */
		function set minimum(value:Number):void;

		/**
		 * The maximum value of the scroll bar.
		 *
		 * <p>In the following example, the maximum is changed to 100:</p>
		 *
		 * <listing version="3.0">
		 * scrollBar.minimum = 0;
		 * scrollBar.maximum = 100;
		 * scrollBar.step = 1;
		 * scrollBar.page = 10
		 * scrollBar.value = 12;</listing>
		 */
		function get maximum():Number;

		/**
		 * @private
		 */
		function set maximum(value:Number):void;

		/**
		 * The current value of the scroll bar.
		 *
		 * <p>In the following example, the value is changed to 12:</p>
		 *
		 * <listing version="3.0">
		 * scrollBar.minimum = 0;
		 * scrollBar.maximum = 100;
		 * scrollBar.step = 1;
		 * scrollBar.page = 10
		 * scrollBar.value = 12;</listing>
		 */
		function get value():Number;

		/**
		 * @private
		 */
		function set value(value:Number):void;

		/**
		 * The amount the scroll bar value must change to increment or
		 * decrement.
		 *
		 * <p>In the following example, the step is changed to 1:</p>
		 *
		 * <listing version="3.0">
		 * scrollBar.minimum = 0;
		 * scrollBar.maximum = 100;
		 * scrollBar.step = 1;
		 * scrollBar.page = 10
		 * scrollBar.value = 12;</listing>
		 */
		function get step():Number;

		/**
		 * @private
		 */
		function set step(value:Number):void;

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
