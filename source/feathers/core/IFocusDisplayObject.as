/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core
{
	/**
	 * Dispatched when the display object receives focus.
	 *
	 * @eventType feathers.events.FeathersEventType.FOCUS_IN
	 */
	[Event(name="focusIn",type="starling.events.Event")]

	/**
	 * Dispatched when the display object loses focus.
	 *
	 * @eventType feathers.events.FeathersEventType.FOCUS_OUT
	 */
	[Event(name="focusOut",type="starling.events.Event")]

	/**
	 * A component that can receive focus.
	 *
	 * @see feathers.core.IFocusManager
	 */
	public interface IFocusDisplayObject extends IFeathersDisplayObject
	{
		/**
		 * The current focus manager for this component.
		 */
		function get focusManager():IFocusManager;

		/**
		 * @private
		 */
		function set focusManager(value:IFocusManager):void;

		/**
		 * Determines if this component can receive focus.
		 */
		function get isFocusEnabled():Boolean;

		/**
		 * @private
		 */
		function set isFocusEnabled(value:Boolean):void;

		/**
		 * The next object that will receive focus when the tab key is pressed.
		 * If <code>null</code>, defaults to the next child on the display list.
		 */
		function get nextTabFocus():IFocusDisplayObject;

		/**
		 * @private
		 */
		function set nextTabFocus(value:IFocusDisplayObject):void;

		/**
		 * The previous object that will receive focus when the tab key is
		 * pressed while holding shift. If <code>null</code>, defaults to the
		 * previous child on the display list.
		 */
		function get previousTabFocus():IFocusDisplayObject;

		/**
		 * @private
		 */
		function set previousTabFocus(value:IFocusDisplayObject):void;
	}
}
