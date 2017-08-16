/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.renderers
{
	import feathers.controls.DataGrid;
	import feathers.core.IToggle;
	import feathers.layout.ILayoutDisplayObject;

	/**
	 * Interface to implement a renderer for a data grid cell.
	 *
	 * @productversion Feathers 3.4.0
	 */
	public interface IDataGridCellRenderer extends IToggle, ILayoutDisplayObject
	{
		/**
		 * An item from the data grid's data provider. The data may change if this
		 * item renderer is reused for a new item because it's no longer needed
		 * for the original item.
		 *
		 * <p>This property is set by the data grid, and should not be set manually.</p>
		 * 
		 * @see #dataField
		 */
		function get data():Object;
		
		/**
		 * @private
		 */
		function set data(value:Object):void;
		
		/**
		 * The index (numeric position, starting from zero) of the item within
		 * the data grid's columns.
		 *
		 * <p>This property is set by the data grid, and should not be set manually.</p>
		 */
		function get columnIndex():int;
		
		/**
		 * @private
		 */
		function set columnIndex(value:int):void;
		
		/**
		 * The index (numeric position, starting from zero) of the item within
		 * the data grid's data provider. Like the <code>data</code> property,
		 * this value may change if this item renderer is reused by the list
		 * for a different item.
		 *
		 * <p>This property is set by the data grid, and should not be set manually.</p>
		 */
		function get rowIndex():int;
		
		/**
		 * @private
		 */
		function set rowIndex(value:int):void;
		
		/**
		 * The field used to access this column's data from the item within the
		 * data grid's data provider. Like the <code>data</code> property, this
		 * value may change if this item renderer is reused by the data grid
		 * for a different item.
		 *
		 * <p>This property is set by the data grid, and should not be set manually.</p>
		 * 
		 * @see #data
		 */
		function get dataField():String;
		
		/**
		 * @private
		 */
		function set dataField(value:String):void;
		
		/**
		 * The data grid that contains this cell renderer.
		 *
		 * <p>This property is set by the data grid, and should not be set manually.</p>
		 */
		function get owner():DataGrid;
		
		/**
		 * @private
		 */
		function set owner(value:DataGrid):void;
	}
}