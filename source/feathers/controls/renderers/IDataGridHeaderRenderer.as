/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.renderers
{
	import feathers.controls.DataGrid;
	import feathers.controls.DataGridColumn;
	import feathers.core.IFeathersControl;
	import feathers.layout.ILayoutDisplayObject;

	/**
	 * Dispatched when the the user taps or clicks the header renderer. The touch
	 * must remain within the bounds of the header renderer on release to register
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
	 * Interface to implement a renderer for a data grid header.
	 *
	 * @productversion Feathers 3.4.0
	 */
	public interface IDataGridHeaderRenderer extends IFeathersControl, ILayoutDisplayObject
	{
		/**
		 * A column from a data grid. The data may change if this header
		 * renderer is reused for a new column because it's no longer needed
		 * for the original column.
		 *
		 * <p>This property is set by the data grid, and should not be set manually.</p>
		 */
		function get data():DataGridColumn;
		
		/**
		 * @private
		 */
		function set data(value:DataGridColumn):void;
		
		/**
		 * The index of the header within the layout.
		 *
		 * <p>This property is set by the data grid, and should not be set manually.</p>
		 */
		function get columnIndex():int;
		
		/**
		 * @private
		 */
		function set columnIndex(value:int):void;
		
		/**
		 * The data grid that contains this header renderer.
		 *
		 * <p>This property is set by the data grid, and should not be set manually.</p>
		 */
		function get owner():DataGrid;
		
		/**
		 * @private
		 */
		function set owner(value:DataGrid):void;
		
		/**
		 * Indicates if this column is sorted.
		 *
		 * <p>This property is set by the data grid, and should not be set manually.</p>
		 * 
		 * @see feathers.data.SortOrder
		 */
		function get sortOrder():String;
		
		/**
		 * @private
		 */
		function set sortOrder(value:String):void;
	}
}