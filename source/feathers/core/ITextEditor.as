/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core
{
	import flash.geom.Point;

	/**
	 * Dispatched when the text property changes.
	 */
	[Event(name="change",type="starling.events.Event")]

	/**
	 * Dispatched when the user presses the Enter key while the editor has focus.
	 *
	 * @eventType feathers.events.FeathersEventType.ENTER
	 */
	[Event(name="enter",type="starling.events.Event")]

	/**
	 * Dispatched when the text editor receives focus.
	 *
	 * @eventType feathers.events.FeathersEventType.FOCUS_IN
	 */
	[Event(name="focusIn",type="starling.events.Event")]

	/**
	 * Dispatched when the text editor loses focus.
	 *
	 * @eventType feathers.events.FeathersEventType.FOCUS_OUT
	 */
	[Event(name="focusOut",type="starling.events.Event")]

	/**
	 * Handles the editing of text.
	 *
	 * @see http://wiki.starling-framework.org/feathers/text-editors
	 */
	public interface ITextEditor extends IFeathersControl
	{
		/**
		 * The text displayed by the editor.
		 */
		function get text():String;

		/**
		 * @private
		 */
		function set text(value:String):void;

		/**
		 * Gives focus to the text editor. Includes an optional position which
		 * may be used by the text editor to determine the cursor position. The
		 * position may be outside of the editors bounds.
		 */
		function setFocus(position:Point = null):void;

		/**
		 * Removes focus from the text editor.
		 */
		function clearFocus():void;

		/**
		 * Sets the range of selected characters. If both values are the same,
		 * the text insertion position is changed and nothing is selected.
		 */
		function selectRange(startIndex:int, endIndex:int):void;
	}
}
