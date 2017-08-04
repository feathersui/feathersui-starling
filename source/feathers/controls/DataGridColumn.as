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
		public static function defaultItemRendererFactory():IDataGridItemRenderer
		{
			return new DefaultDataGridItemRenderer();
		}

		/**
		 * Constructor.
		 */
		public function DataGridColumn(dataField:String = null)
		{
			super();
			this.dataField = dataField;
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
		 * renderer.dataField = "name";</listing>
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
		 * grid.itemRendererFactory = function():IDataGridItemRenderer
		 * {
		 *     var renderer:CustomItemRendererClass = new CustomItemRendererClass();
		 *     renderer.backgroundSkin = new Quad( 10, 10, 0xff0000 );
		 *     return renderer;
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
		protected var _headerRendererFactory:Function = null;
		
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
		 * grid.headerRendererFactory = function():IDataGridHeaderRenderer
		 * {
		 *     var renderer:CustomHeaderRendererClass = new CustomHeaderRendererClass();
		 *     renderer.backgroundSkin = new Quad( 10, 10, 0xff0000 );
		 *     return renderer;
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
	}
}