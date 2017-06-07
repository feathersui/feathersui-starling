/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.data
{
	import feathers.core.IFeathersEventDispatcher;

	/**
	 * Dispatched when the suggestions finish loading.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>A <code>ListCollection</code> containing
	 *   the suggestions to display.</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @eventType starling.events.Event.COMPLETE
	 */
	[Event(name="complete",type="starling.events.Event")]

	/**
	 * A source of items to display in the pop-up list of an
	 * <code>AutoComplete</code> component.
	 *
	 * @see feathers.controls.AutoComplete
	 *
	 * @productversion Feathers 2.1.0
	 */
	public interface IAutoCompleteSource extends IFeathersEventDispatcher
	{
		/**
		 * Loads suggestions based on the text entered into an
		 * <code>AutoComplete</code> component.
		 *
		 * <p>If an existing <code>ListCollection</code> is passed in as the
		 * result, all items will be removed before new items are added.</p>
		 */
		function load(textToMatch:String, suggestionsResult:IListCollection = null):void;
	}
}
