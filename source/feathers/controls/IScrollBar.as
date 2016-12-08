/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	/**
	 * Dispatched when the scroll bar's value changes.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>null</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @eventType starling.events.Event.CHANGE
	 */
	[Event(name="change",type="starling.events.Event")]

	/**
	 * Minimum requirements for a scroll bar to be usable with a <code>Scroller</code>
	 * component.
	 *
	 * @see Scroller
	 *
	 * @productversion Feathers 1.0.0
	 */
	public interface IScrollBar extends IRange
	{
		/**
		 * The amount the scroll bar value must change to get from one "page" to
		 * the next.
		 * 
		 * <p>If this value is <code>0</code>, the <code>step</code> value
		 * will be used instead. If the <code>step</code> value is
		 * <code>0</code>, paging is not possible.</p>
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
