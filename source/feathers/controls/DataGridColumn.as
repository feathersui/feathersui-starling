/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.core.FeathersControl;
	import starling.events.EventDispatcher;
	import starling.events.Event;
	import feathers.controls.renderers.IDataGridItemRenderer;
	import feathers.controls.renderers.DefaultDataGridItemRenderer;
	import feathers.controls.renderers.IDataGridHeaderRenderer;
	import feathers.controls.renderers.DefaultDataGridHeaderRenderer;

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
	 * 
	 * @productversion Feathers 3.4.0
	 */
	public class DataGridColumn extends EventDispatcher
	{
		/**
		 * @private
		 */
		public static function defaultItemRendererFactory():IDataGridItemRenderer
		{
			return new DefaultDataGridItemRenderer();
		}

		/**
		 * @private
		 */
		public static function defaultHeaderRendererFactory():IDataGridHeaderRenderer
		{
			return new DefaultDataGridHeaderRenderer();
		}

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
		 * the item renderers in this column. If the item does not have this
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
		protected var _itemRendererFactory:Function = defaultItemRendererFactory;
		
		/**
		 * A function called that is expected to return a new item renderer.
		 *
		 * <p>The function is expected to have the following signature:</p>
		 *
		 * <pre>function():IDataGridItemRenderer</pre>
		 *
		 * <p>The following example provides a factory for the item renderer:</p>
		 *
		 * <listing version="3.0">
		 * column.itemRendererFactory = function():IDataGridItemRenderer
		 * {
		 *     var itemRenderer:CustomItemRendererClass = new CustomItemRendererClass();
		 *     itemRenderer.backgroundSkin = new Quad( 10, 10, 0xff0000 );
		 *     return itemRenderer;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.renderers.IDataGridItemRenderer
		 */
		public function get itemRendererFactory():Function
		{
			return this._itemRendererFactory;
		}
		
		/**
		 * @private
		 */
		public function set itemRendererFactory(value:Function):void
		{
			if(this._itemRendererFactory === value)
			{
				return;
			}
			this._itemRendererFactory = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _customItemRendererStyleName:String = null;

		/**
		 * A style name to add to all item renderers in this column. Typically
		 * used by a theme to provide different skins to different columns.
		 *
		 * <p>The following example sets the item renderer name:</p>
		 *
		 * <listing version="3.0">
		 * column.customItemRendererStyleName = "my-custom-item-renderer";</listing>
		 *
		 * <p>In your theme, you can target this sub-component name to provide
		 * different skins than the default style:</p>
		 *
		 * <listing version="3.0">
		 * getStyleProviderForClass( DefaultDataGridItemRenderer ).setFunctionForStyleName( "my-custom-item-renderer", setCustomItemRendererStyles );</listing>
		 *
		 * @default null
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public function get customItemRendererStyleName():String
		{
			return this._customItemRendererStyleName;
		}

		/**
		 * @private
		 */
		public function set customItemRendererStyleName(value:String):void
		{
			if(this._customItemRendererStyleName === value)
			{
				return;
			}
			this._customItemRendererStyleName = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _headerRendererFactory:Function = defaultHeaderRendererFactory;
		
		/**
		 * A function called that is expected to return a new header renderer.
		 *
		 * <p>The function is expected to have the following signature:</p>
		 *
		 * <pre>function():IDataGridHeaderRenderer</pre>
		 *
		 * <p>The following example provides a factory for the item renderer:</p>
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
		 * column.customHeaderRendererStyleName = "my-header-item-renderer";</listing>
		 *
		 * <p>In your theme, you can target this sub-component name to provide
		 * different skins than the default style:</p>
		 *
		 * <listing version="3.0">
		 * getStyleProviderForClass( DefaultDataGridHeaderRenderer ).setFunctionForStyleName( "my-custom-item-renderer", setCustomHeaderRendererStyles );</listing>
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
	}
}