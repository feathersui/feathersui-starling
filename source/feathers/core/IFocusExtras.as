/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core
{
	import starling.display.DisplayObject;

	/**
	 * A container that may have extra children that aren't accessible from the
	 * standard display list functions like <code>getChildAt()</code>, but those
	 * "extra" children may still need to receive focus. An example of this
	 * would be a container with "chrome", such as <code>feathers.controls.Panel</code>.
	 *
	 * @see feathers.core.IFocusManager
	 */
	public interface IFocusExtras
	{
		/**
		 * Extra display objects that are not accessible through standard
		 * display list functions like <code>getChildAt()</code>, but should
		 * appear before those children in the focus order. Typically, this is
		 * for containers that have chrome that is hidden from the normal
		 * display list API.
		 *
		 * <p>May return <code>null</code> if there are no extra children.</p>
		 */
		function get focusExtrasBefore():Vector.<DisplayObject>;

		/**
		 * Extra display objects that are not accessible through standard
		 * display list functions like <code>getChildAt()</code>, but should
		 * appear after those children in the focus order. Typically, this is
		 * for containers that have chrome that is hidden from the normal
		 * display list API.
		 *
		 * <p>May return <code>null</code> if there are no extra children.</p>
		 */
		function get focusExtrasAfter():Vector.<DisplayObject>;
	}
}
