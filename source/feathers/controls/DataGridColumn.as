/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.controls.renderers.DefaultDataGridCellRenderer;
	import feathers.controls.renderers.DefaultDataGridHeaderRenderer;
	import feathers.controls.renderers.IDataGridCellRenderer;
	import feathers.controls.renderers.IDataGridHeaderRenderer;
	import feathers.core.FeathersControl;
	import feathers.data.SortOrder;

	import starling.events.Event;
	import starling.events.EventDispatcher;

	/**
	 * Dispatched when a property of the column changes.
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
	 */
	[Event(name="change",type="starling.events.Event")]

	/**
	 * Configures a column in a <code>DataGrid</code> component.
	 * 
	 * @see feathers.controls.DataGrid
	 * 
	 * @productversion Feathers 3.4.0
	 */
	public class DataGridColumn extends EventDispatcher
	{
		/**
		 * Constructor.
		 */
		public function DataGridColumn(dataField:String = null, headerText:String = null)
		{
			super();
			this.dataField = dataField;
			this.headerText = headerText;
		}

		/**
		 * @private
		 */
		protected var _headerText:String = null;

		/**
		 * The text to display in the column's header.
		 *
		 * <p>In the following example, the header text is customized:</p>
		 *
		 * <listing version="3.0">
		 * column.headerText = "Customer Name";</listing>
		 *
		 * @default null
		 */
		public function get headerText():String
		{
			return this._headerText;
		}

		/**
		 * @private
		 */
		public function set headerText(value:String):void
		{
			if(this._headerText === value)
			{
				return;
			}
			this._headerText = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _dataField:String = null;

		/**
		 * The field in the item that contains the data to be displayed by
		 * the cell renderers in this column. If the item does not have this
		 * field, then the renderer may default to calling <code>toString()</code>
		 * on the item.
		 *
		 * <p>In the following example, the data field is customized:</p>
		 *
		 * <listing version="3.0">
		 * column.dataField = "name";</listing>
		 *
		 * @default null
		 */
		public function get dataField():String
		{
			return this._dataField;
		}

		/**
		 * @private
		 */
		public function set dataField(value:String):void
		{
			if(this._dataField === value)
			{
				return;
			}
			this._dataField = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _cellRendererFactory:Function = null;
		
		/**
		 * A function called that is expected to return a new cell renderer.
		 *
		 * <p>The function is expected to have the following signature:</p>
		 *
		 * <pre>function():IDataGridCellRenderer</pre>
		 *
		 * <p>The following example provides a factory for the cell renderer:</p>
		 *
		 * <listing version="3.0">
		 * column.cellRendererFactory = function():IDataGridCellRenderer
		 * {
		 *     var cellRenderer:CustomCellRendererClass = new CustomCellRendererClass();
		 *     cellRenderer.backgroundSkin = new Quad( 10, 10, 0xff0000 );
		 *     return cellRenderer;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.renderers.IDataGridCellRenderer
		 */
		public function get cellRendererFactory():Function
		{
			return this._cellRendererFactory;
		}
		
		/**
		 * @private
		 */
		public function set cellRendererFactory(value:Function):void
		{
			if(this._cellRendererFactory === value)
			{
				return;
			}
			this._cellRendererFactory = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _customCellRendererStyleName:String = null;

		/**
		 * A style name to add to all cell renderers in this column. Typically
		 * used by a theme to provide different skins to different columns.
		 *
		 * <p>The following example sets the cell renderer name:</p>
		 *
		 * <listing version="3.0">
		 * column.customCellRendererStyleName = "my-custom-cell-renderer";</listing>
		 *
		 * <p>In your theme, you can target this sub-component name to provide
		 * different skins than the default style:</p>
		 *
		 * <listing version="3.0">
		 * getStyleProviderForClass( DefaultDataGridCellRenderer ).setFunctionForStyleName( "my-custom-cell-renderer", setCustomCellRendererStyles );</listing>
		 *
		 * @default null
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public function get customCellRendererStyleName():String
		{
			return this._customCellRendererStyleName;
		}

		/**
		 * @private
		 */
		public function set customCellRendererStyleName(value:String):void
		{
			if(this._customCellRendererStyleName === value)
			{
				return;
			}
			this._customCellRendererStyleName = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _headerRendererFactory:Function = null;
		
		/**
		 * A function called that is expected to return a new header renderer.
		 *
		 * <p>The function is expected to have the following signature:</p>
		 *
		 * <pre>function():IDataGridHeaderRenderer</pre>
		 *
		 * <p>The following example provides a factory for the header renderer:</p>
		 *
		 * <listing version="3.0">
		 * column.headerRendererFactory = function():IDataGridHeaderRenderer
		 * {
		 *     var headerRenderer:CustomHeaderRendererClass = new CustomHeaderRendererClass();
		 *     headerRenderer.backgroundSkin = new Quad( 10, 10, 0xff0000 );
		 *     return headerRenderer;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.renderers.IDataGridHeaderRenderer
		 */
		public function get headerRendererFactory():Function
		{
			return this._headerRendererFactory;
		}
		
		/**
		 * @private
		 */
		public function set headerRendererFactory(value:Function):void
		{
			if(this._headerRendererFactory === value)
			{
				return;
			}
			this._headerRendererFactory = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _customHeaderRendererStyleName:String = null;

		/**
		 * A style name to add to all header renderers in this column. Typically
		 * used by a theme to provide different skins to different columns.
		 *
		 * <p>The following example sets the header renderer name:</p>
		 *
		 * <listing version="3.0">
		 * column.customHeaderRendererStyleName = "my-custom-header-renderer";</listing>
		 *
		 * <p>In your theme, you can target this sub-component name to provide
		 * different skins than the default style:</p>
		 *
		 * <listing version="3.0">
		 * getStyleProviderForClass( DefaultDataGridHeaderRenderer ).setFunctionForStyleName( "my-custom-header-renderer", setCustomHeaderRendererStyles );</listing>
		 *
		 * @default null
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public function get customHeaderRendererStyleName():String
		{
			return this._customHeaderRendererStyleName;
		}

		/**
		 * @private
		 */
		public function set customHeaderRendererStyleName(value:String):void
		{
			if(this._customHeaderRendererStyleName === value)
			{
				return;
			}
			this._customHeaderRendererStyleName = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _minWidth:Number = NaN;

		/**
		 * The minimum width of the column, in pixels. If the
		 * <code>minWidth</code> is set to <code>NaN</code>, the column's
		 * minimum width will be determined automatically by the data grid's layout.
		 *
		 * <p>The following example sets the column minimum width:</p>
		 *
		 * <listing version="3.0">
		 * column.minWidth = 200;</listing>
		 *
		 * @default NaN
		 */
		public function get minWidth():Number
		{
			return this._minWidth;
		}

		/**
		 * @private
		 */
		public function set minWidth(value:Number):void
		{
			if(this._minWidth === value)
			{
				return;
			}
			this._minWidth = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _width:Number = NaN;

		/**
		 * The width of the column, in pixels. If the width is set to
		 * <code>NaN</code>, the column will be sized automatically by the
		 * data grid's layout.
		 *
		 * <p>The following example sets the column width:</p>
		 *
		 * <listing version="3.0">
		 * column.width = 200;</listing>
		 *
		 * @default NaN
		 */
		public function get width():Number
		{
			return this._width;
		}

		/**
		 * @private
		 */
		public function set width(value:Number):void
		{
			if(this._width === value)
			{
				return;
			}
			this._width = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _sortCompareFunction:Function = null;

		/**
		 * A function to compare each item in the collection to determine the
		 * order when sorted.
		 *
		 * <p>The function is expected to have the following signature:</p>
		 * <pre>function( a:Object, b:Object ):int</pre>
		 * 
		 * <p>The return value should be <code>-1</code> if the first item
		 * should appear before the second item when the collection is sorted.
		 * The return value should be <code>1</code> if the first item should
		 * appear after the second item when the collection in sorted. Finally,
		 * the return value should be <code>0</code> if both items have the
		 * same sort order.</p>
		 * 
		 * @default null
		 * 
		 * @see #sortOrder
		 */
		public function get sortCompareFunction():Function
		{
			return this._sortCompareFunction;
		}

		/**
		 * @private
		 */
		public function set sortCompareFunction(value:Function):void
		{
			if(this._sortCompareFunction === value)
			{
				return;
			}
			this._sortCompareFunction = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _sortOrder:String = SortOrder.ASCENDING;

		/**
		 * Indicates if the column may be sorted by triggering the
		 * header renderer, and which direction it should be sorted
		 * by default (ascending or descending).
		 * 
		 * <p>Setting this property will not start a sort. It only provides the
		 * initial order of the sort when triggered by the user.</p>
		 *
		 * <p>The following example disables sorting:</p>
		 *
		 * <listing version="3.0">
		 * column.sortOrder = SortOrder.NONE;</listing>
		 *
		 * @default feathers.data.SortOrder.ASCENDING
		 * 
		 * @see #sortCompareFunction
		 * @see feathers.data.SortOrder#ASCENDING
		 * @see feathers.data.SortOrder#DESCENDING
		 * @see feathers.data.SortOrder#NONE
		 */
		public function get sortOrder():String
		{
			return this._sortOrder;
		}

		/**
		 * @private
		 */
		public function set sortOrder(value:String):void
		{
			if(this._sortOrder === value)
			{
				return;
			}
			this._sortOrder = value;
			this.dispatchEventWith(Event.CHANGE);
		}
	}
}