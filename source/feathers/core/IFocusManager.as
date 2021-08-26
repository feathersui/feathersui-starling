/*
Feathers
Copyright 2012-2021 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core
{
	import feathers.core.IFeathersEventDispatcher;

	import starling.display.DisplayObjectContainer;

	/**
	 * Dispatched when the value of the <code>focus</code> property changes.
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
	 *
	 * @see #focus
	 */
	[Event(name="change",type="starling.events.Event")]

	/**
	 * Interface for focus management.
	 *
	 * @see ../../../help/focus.html Keyboard focus management in Feathers
	 * @see feathers.core.FocusManager
	 * @see feathers.core.IFocusDisplayObject
	 *
	 * @productversion Feathers 1.1.0
	 */
	public interface IFocusManager extends IFeathersEventDispatcher
	{
		/**
		 * Determines if this focus manager is enabled. A focus manager may be
		 * disabled when another focus manager has control, such as when a
		 * modal pop-up is displayed.
		 */
		function get isEnabled():Boolean;

		/**
		 * @private
		 */
		function set isEnabled(value:Boolean):void;

		/**
		 * The object that currently has focus. May return <code>null</code> if
		 * no object has focus.
		 *
		 * <p>In the following example, the focus is changed:</p>
		 *
		 * <listing version="3.0">
		 * focusManager.focus = someObject;</listing>
		 */
		function get focus():IFocusDisplayObject;

		/**
		 * @private
		 */
		function set focus(value:IFocusDisplayObject):void;

		/**
		 * The top-level container of the focus manager. This isn't necessarily
		 * the root of the display list.
		 */
		function get root():DisplayObjectContainer;
	}
}
