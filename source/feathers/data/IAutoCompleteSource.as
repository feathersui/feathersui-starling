/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.data
{
	import feathers.core.IFeathersEventDispatcher;
	import feathers.data.ListCollection;

	/**
	 * A source of items to display in the pop-up list of an
	 * <code>AutoComplete</code> component.
	 *
	 * @see feathers.controls.AutoComplete
	 */
	public interface IAutoCompleteSource extends IFeathersEventDispatcher
	{
		/**
		 * Loads suggestions based on the text from an <code>AutoComplete</code>
		 * text input.
		 *
		 * <p>If an existing <code>ListCollection</code> is passed in as the
		 * result, all items will be removed before new items are added.</p>
		 */
		function load(text:String, result:ListCollection = null):void;
	}
}
