/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.color
{
	import feathers.core.*;
	import feathers.layout.ILayoutDisplayObject;

	/**
	 * Dispatched when the <code>color</code> property changes.
	 */
	[Event(name="change",type="starling.events.Event")]

	/**
	 * Dispatched to preview a potential new color value that has not been
	 * selected yet. For example, when the mouse hovers over a color swatch,
	 * <code>Event.UPDATE</code> may be dispatched to preview the color. The
	 * event's <code>data</code> property contains the preview color value.
	 */
	[Event(name="update",type="starling.events.Event")]

	/**
	 * A Feathers component that displays, and possibly, selects a color.
	 */
	public interface IColorControl extends IFeathersControl, IFocusDisplayObject, ILayoutDisplayObject
	{
		/**
		 * The currently selected color value, in the range 0x000000 to
		 * 0xffffff.
		 */
		function get color():uint;

		/**
		 * @private
		 */
		function set color(newValue:uint):void;
	}
}
