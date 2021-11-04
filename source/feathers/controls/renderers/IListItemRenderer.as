/*
Feathers
Copyright 2012-2021 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.renderers
{
	import feathers.controls.List;
	import feathers.core.IToggle;

	/**
	 * Dispatched when the the user taps or clicks the item renderer. The touch
	 * must remain within the bounds of the item renderer on release to register
	 * as a tap or a click.
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
	 * @eventType starling.events.Event.TRIGGERED
	 *
	 * @see feathers.utils.touch.TapToTrigger
	 */
	[Event(name="triggered",type="starling.events.Event")]

	/**
	 * Interface to implement a renderer for a list item.
	 *
	 * @productversion Feathers 1.0.0
	 */
	public interface IListItemRenderer extends IToggle
	{
		/**
		 * An item from the list's data provider. The data may change if this
		 * item renderer is reused for a new item because it's no longer needed
		 * for the original item.
		 *
		 * <p>This property is set by the list, and should not be set manually.</p>
		 */
		function get data():Object;

		/**
		 * @private
		 */
		function set data(value:Object):void;

		/**
		 * The index (numeric position, starting from zero) of the item within
		 * the list's data provider. Like the <code>data</code> property, this
		 * value may change if this item renderer is reused by the list for a
		 * different item.
		 *
		 * <p>This property is set by the list, and should not be set manually.</p>
		 */
		function get index():int;

		/**
		 * @private
		 */
		function set index(value:int):void;

		/**
		 * The list that contains this item renderer.
		 *
		 * <p>This property is set by the list, and should not be set manually.</p>
		 */
		function get owner():List;

		/**
		 * @private
		 */
		function set owner(value:List):void;

		/**
		 * The ID of the factory used to create this item renderer.
		 *
		 * <p>This property is set by the list, and should not be set manually.</p>
		 */
		function get factoryID():String;

		/**
		 * @private
		 */
		function set factoryID(value:String):void;
	}
}