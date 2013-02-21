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
		 */
		function get minimum():Number;

		/**
		 * @private
		 */
		function set minimum(value:Number):void;

		/**
		 * The maximum value of the scroll bar.
		 */
		function get maximum():Number;

		/**
		 * @private
		 */
		function set maximum(value:Number):void;

		/**
		 * The current value of the scroll bar.
		 */
		function get value():Number;

		/**
		 * @private
		 */
		function set value(value:Number):void;

		/**
		 * The amount the scroll bar value must change to increment or
		 * decrement.
		 */
		function get step():Number;

		/**
		 * @private
		 */
		function set step(value:Number):void;

		/**
		 * The amount the scroll bar value must change to get from one "page" to
		 * the next.
		 */
		function get page():Number;

		/**
		 * @private
		 */
		function set page(value:Number):void;
	}
}
