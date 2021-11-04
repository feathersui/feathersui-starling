/*
Feathers
Copyright 2012-2021 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.core.IFeathersControl;

	/**
	 * Dispatched when the value changes.
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
	 * @see #value
	 *
	 * @eventType starling.events.Event.CHANGE
	 */
	[Event(name="change",type="starling.events.Event")]

	/**
	 * A UI component that displays a range of values from a minimum to a maximum.
	 *
	 * @productversion Feathers 1.3.0
	 */
	public interface IRange extends IFeathersControl
	{
		/**
		 * The minimum numeric value of the range.
		 *
		 * <p>In the following example, the minimum is changed to 0:</p>
		 *
		 * <listing version="3.0">
		 * component.minimum = 0;
		 * component.maximum = 100;
		 * component.step = 1;
		 * component.page = 10
		 * component.value = 12;</listing>
		 */
		function get minimum():Number;

		/**
		 * @private
		 */
		function set minimum(value:Number):void;

		/**
		 * The maximum numeric value of the range.
		 *
		 * <p>In the following example, the maximum is changed to 100:</p>
		 *
		 * <listing version="3.0">
		 * component.minimum = 0;
		 * component.maximum = 100;
		 * component.step = 1;
		 * component.page = 10
		 * component.value = 12;</listing>
		 */
		function get maximum():Number;

		/**
		 * @private
		 */
		function set maximum(value:Number):void;

		/**
		 * The current numeric value.
		 *
		 * <p>In the following example, the value is changed to 12:</p>
		 *
		 * <listing version="3.0">
		 * component.minimum = 0;
		 * component.maximum = 100;
		 * component.step = 1;
		 * component.page = 10
		 * component.value = 12;</listing>
		 */
		function get value():Number;

		/**
		 * @private
		 */
		function set value(value:Number):void;

		/**
		 * The amount the value must change to increment or decrement.
		 *
		 * <p>In the following example, the step is changed to 1:</p>
		 *
		 * <listing version="3.0">
		 * component.minimum = 0;
		 * component.maximum = 100;
		 * component.step = 1;
		 * component.page = 10
		 * component.value = 12;</listing>
		 */
		function get step():Number;

		/**
		 * @private
		 */
		function set step(value:Number):void;
	}
}
