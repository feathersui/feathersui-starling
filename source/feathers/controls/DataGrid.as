/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.controls.DataGrid;
	import feathers.controls.DataGridColumn;
	import feathers.controls.Scroller;
	import feathers.controls.renderers.DefaultDataGridHeaderRenderer;
	import feathers.controls.renderers.IDataGridHeaderRenderer;
	import feathers.controls.supportClasses.DataGridDataViewPort;
	import feathers.core.IValidating;
	import feathers.data.ArrayCollection;
	import feathers.data.IListCollection;
	import feathers.data.ListCollection;
	import feathers.data.SortOrder;
	import feathers.display.RenderDelegate;
	import feathers.dragDrop.DragData;
	import feathers.dragDrop.DragDropManager;
	import feathers.dragDrop.IDragSource;
	import feathers.dragDrop.IDropTarget;
	import feathers.events.CollectionEventType;
	import feathers.events.DragDropEvent;
	import feathers.events.FeathersEventType;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.HorizontalLayoutData;
	import feathers.layout.ILayout;
	import feathers.layout.IVariableVirtualLayout;
	import feathers.layout.VerticalAlign;
	import feathers.layout.VerticalLayout;
	import feathers.skins.IStyleProvider;
	import feathers.system.DeviceCapabilities;

	import flash.errors.IllegalOperationError;
	import flash.events.KeyboardEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;

	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.Pool;
	import starling.utils.SystemUtil;

	/**
	 * A skin to display when dragging one of the data grid's headers to
	 * highlight the column where it was orignally located.
	 *
	 * <p>In the following example, the data grid's column overlay skin is provided:</p>
	 *
	 * <listing version="3.0">
	 * var skin:Quad = new Quad(1, 1, 0x999999);
	 * skin.alpha = 0.5;
	 * grid.columnDragOverlaySkin = skin;</listing>
	 *
	 * @default null
	 * 
	 * @see #reorderColumns
	 */
	[Style(name="columnDragOverlaySkin",type="starling.display.DisplayObject")]

	/**
	 * A skin to display when resizing one of the data grid's headers to
	 * indicate how it will be resized.
	 *
	 * <p>In the following example, the data grid's column resize skin is provided:</p>
	 *
	 * <listing version="3.0">
	 * grid.columnResizeSkin = new Image( texture );</listing>
	 *
	 * @default null
	 * 
	 * @see #resizableColumns
	 * @see feathers.controls.DataGridColumn#resizable
	 */
	[Style(name="columnResizeSkin",type="starling.display.DisplayObject")]

	/**
	 * Specifies a custom style name for cell renderers that will be used if
	 * the <code>customCellRendererStyleName</code> property from a
	 * <code>DataGridColumn</code> is <code>null</code>.
	 *
	 * <p>The following example sets the cell renderer style name:</p>
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
	[Style(name="customCellRendererStyleName",type="String")]

	/**
	 * Specifies a custom style name for header renderers that will be used if
	 * the <code>customHeaderRendererStyleName</code> property from a
	 * <code>DataGridColumn</code> is <code>null</code>.
	 *
	 * <p>The following example sets the header renderer style name:</p>
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
	[Style(name="customHeaderRendererStyleName",type="String")]

	/**
	 * Determines if the height of the column drop indicator is equal to the
	 * height of the headers, or if it extends to the full height of the data
	 * grid's view port.
	 *
	 * <p>In the following example, the data grid's column drop skin is extended:</p>
	 *
	 * <listing version="3.0">
	 * grid.extendedColumnDropIndicator = true;</listing>
	 *
	 * @default false
	 * 
	 * @see #reorderColumns
	 * @see #style:columnDropIndicatorSkin
	 */
	[Style(name="extendedColumnDropIndicator",type="Boolean")]

	/**
	 * The default background to display in the data grid's header.
	 *
	 * <p>In the following example, the data grid's header is given a background skin:</p>
	 *
	 * <listing version="3.0">
	 * scroller.headerBackgroundSkin = new Image( texture );</listing>
	 *
	 * @default null
	 * 
	 * @see #style:headerBackgroundDisabledSkin
	 */
	[Style(name="headerBackgroundSkin",type="starling.display.DisplayObject")]

	/**
	 * A function that returns new dividers that separate each of the data
	 * grid's header renderers. If <code>null</code>, no dividers will appear
	 * between the header renderers.
	 *
	 * <p>The function is expected to have the following signature:</p>
	 * 
	 * <pre>function():DisplayObject</pre>
	 *
	 * <p>The following example provides a factory for the header dividers:</p>
	 *
	 * <listing version="3.0">
	 * grid.headerDividerFactory = function():DisplayObject
	 * {
	 *     return = new ImageSkin( texture );
	 * };</listing>
	 *
	 * @default null
	 */
	[Style(name="headerDividerFactory",type="Function")]

	/**
	 * A background to display in the data grid's header when the container is
	 * disabled.
	 *
	 * <p>In the following example, the data grid's header is given a disabled background skin:</p>
	 *
	 * <listing version="3.0">
	 * grid.headerBackgroundDisabledSkin = new Image( texture );</listing>
	 *
	 * @default null
	 *
	 * @see #style:headerBackgroundSkin
	 */
	[Style(name="headerBackgroundDisabledSkin",type="starling.display.DisplayObject")]

	/**
	 * The alpha value used for the column's drag avatar.
	 *
	 * <p>In the following example, the data grid's column drag avatar alpha value is customized:</p>
	 *
	 * <listing version="3.0">
	 * grid.columnDragAvatarAlpha = 0.5;</listing>
	 *
	 * @default 0.8
	 * 
	 * @see #reorderColumns
	 */
	[Style(name="columnDragAvatarAlpha",type="Number")]

	/**
	 * A skin to display when dragging one of the data grid's headers to indicate where
	 * it can be dropped.
	 *
	 * <p>In the following example, the data grid's header drag indicator is provided:</p>
	 *
	 * <listing version="3.0">
	 * grid.columnDropIndicatorSkin = new Image( texture );</listing>
	 *
	 * @default null
	 * 
	 * @see #reorderColumns
	 * @see #style:extendedColumnDropIndicator
	 */
	[Style(name="columnDropIndicatorSkin",type="starling.display.DisplayObject")]

	/**
	 * The duration, in seconds, of the animation when the selected item is
	 * changed by keyboard navigation and the item scrolls into view.
	 *
	 * <p>In the following example, the duration of the animation that
	 * scrolls the list to a new selected item is set to 500 milliseconds:</p>
	 *
	 * <listing version="3.0">
	 * list.keyScrollDuration = 0.5;</listing>
	 *
	 * @default 0.25
	 */
	[Style(name="keyScrollDuration",type="Number")]

	/**
	 * A function that returns new dividers that separate each of the data
	 * grid's columns. If <code>null</code>, no dividers will appear between
	 * columns.
	 *
	 * <p>The function is expected to have the following signature:</p>
	 * 
	 * <pre>function():DisplayObject</pre>
	 *
	 * <p>The following example provides a factory for the vertical dividers:</p>
	 *
	 * <listing version="3.0">
	 * grid.verticalDividerFactory = function():DisplayObject
	 * {
	 *     return = new ImageSkin( texture );
	 * };</listing>
	 *
	 * @default null
	 */
	[Style(name="verticalDividerFactory",type="Function")]

	/**
	 * Dispatched when the selected item changes.
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
	 * @see #selectedItem
	 * @see #selectedIndex
	 *
	 * @eventType starling.events.Event.CHANGE
	 */
	[Event(name="change",type="starling.events.Event")]

	/**
	 * Displays a collection of items as a table. Each item is rendered as a
	 * row, divided into columns for each of the item's fields. Supports
	 * scrolling, custom cell renderers, sorting columns, resizing columns, and
	 * drag and drop reordering of columns.
	 *
	 * <p>The following example creates a data grid, gives it a data provider,
	 * defines its columns, and listens for when the selection changes:</p>
	 *
	 * <listing version="3.0">
	 * var grid:DataGrid = new DataGrid();
	 * 
	 * grid.dataProvider = new ArrayCollection(
	 * [
	 *     { item: "Chicken breast", dept: "Meat", price: "5.90" },
	 *     { item: "Butter", dept: "Dairy", price: "4.69" },
	 *     { item: "Broccoli", dept: "Produce", price: "2.99" },
	 *     { item: "Whole Wheat Bread", dept: "Bakery", price: "2.49" },
	 * ]);
	 * 
	 * grid.columns = new ArrayCollection(
	 * [
	 *     new DataGridColumn("item", "Item"),
	 *     new DataGridColumn("dept", "Department"),
	 *     new DataGridColumn("price", "Unit Price"),
	 * ]);
	 * 
	 * grid.addEventListener( Event.CHANGE, grid_changeHandler );
	 * 
	 * this.addChild( grid );</listing>
	 *
	 * <p><strong>Beta Component:</strong> This is a new component, and its APIs
	 * may need some changes between now and the next version of Feathers to
	 * account for overlooked requirements or other issues. Upgrading to future
	 * versions of Feathers may involve manual changes to your code that uses
	 * this component. The
	 * <a href="https://feathersui.com/help/deprecation-policy.html">Feathers deprecation policy</a>
	 * will not go into effect until this component's status is upgraded from
	 * beta to stable.</p>
	 *
	 * @see ../../../help/data-grid.html How to use the Feathers DataGrid component
	 * 
	 * @productversion Feathers 3.4.0
	 */
	public class DataGrid extends Scroller implements IDragSource, IDropTarget
	{
		/**
		 * @private
		 */
		protected static function defaultSortCompareFunction(a:Object, b:Object):int
		{
			var aString:String = a.toString().toLowerCase();
			var bString:String = b.toString().toLowerCase();
			if(aString < bString)
			{
				return -1;
			}
			if(aString > bString)
			{
				return 1;
			}
			return 0;
		}

		/**
		 * @private
		 */
		protected static function defaultHeaderRendererFactory():IDataGridHeaderRenderer
		{
			return new DefaultDataGridHeaderRenderer();
		}

		/**
		 * @private
		 */
		protected static const DATA_GRID_HEADER_DRAG_FORMAT:String = "feathers-data-grid-header";

		/**
		 * The default <code>IStyleProvider</code> for all <code>List</code>
		 * components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * Constructor.
		 */
		public function DataGrid()
		{
			super();
			this.addEventListener(DragDropEvent.DRAG_ENTER, dataGrid_dragEnterHandler);
			this.addEventListener(DragDropEvent.DRAG_MOVE, dataGrid_dragMoveHandler);
			this.addEventListener(DragDropEvent.DRAG_DROP, dataGrid_dragDropHandler);
			this._selectedIndices.addEventListener(Event.CHANGE, selectedIndices_changeHandler);
		}

		/**
		 * @private
		 * The guts of the DataGrid's functionality. Handles layout and selection.
		 */
		protected var dataViewPort:DataGridDataViewPort;

		/**
		 * @private
		 */
		protected var _headerGroup:LayoutGroup = null;

		/**
		 * @private
		 */
		protected var _headerDividerGroup:LayoutGroup = null;

		/**
		 * @private
		 */
		protected var _verticalDividerGroup:LayoutGroup = null;

		/**
		 * @private
		 */
		protected var _headerLayout:HorizontalLayout = null;

		/**
		 * @private
		 */
		protected var _headerRendererMap:Dictionary = new Dictionary(true);

		/**
		 * @private
		 */
		protected var _unrenderedHeaders:Vector.<int> = new <int>[];

		/**
		 * @private
		 */
		protected var _headerStorage:HeaderRendererFactoryStorage = new HeaderRendererFactoryStorage();

		/**
		 * @private
		 */
		protected var _headerDividerStorage:DividerFactoryStorage = new DividerFactoryStorage();

		/**
		 * @private
		 */
		protected var _verticalDividerStorage:DividerFactoryStorage = new DividerFactoryStorage();

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return DataGrid.globalStyleProvider;
		}

		/**
		 * @private
		 */
		override public function get isFocusEnabled():Boolean
		{
			return (this._isSelectable || this._minHorizontalScrollPosition != this._maxHorizontalScrollPosition ||
				this._minVerticalScrollPosition != this._maxVerticalScrollPosition) &&
				this._isEnabled && this._isFocusEnabled;
		}

		/**
		 * @private
		 */
		protected var _isChildFocusEnabled:Boolean = true;

		/**
		 * @copy feathers.core.IFocusContainer#isChildFocusEnabled
		 *
		 * @default true
		 *
		 * @see #isFocusEnabled
		 */
		public function get isChildFocusEnabled():Boolean
		{
			return this._isEnabled && this._isChildFocusEnabled;
		}

		/**
		 * @private
		 */
		public function set isChildFocusEnabled(value:Boolean):void
		{
			this._isChildFocusEnabled = value;
		}

		/**
		 * @private
		 */
		protected var _reorderColumns:Boolean = false;

		/**
		 * Determines if the data grid's columns may be reordered using drag
		 * and drop.
		 *
		 * <p>The following example enables column reordering:</p>
		 *
		 * <listing version="3.0">
		 * grid.reorderColumns = true;</listing>
		 *
		 * @default false
		 */
		public function get reorderColumns():Boolean
		{
			return this._reorderColumns;
		}

		/**
		 * @private
		 */
		public function set reorderColumns(value:Boolean):void
		{
			this._reorderColumns = value;
		}

		/**
		 * @private
		 */
		protected var _sortableColumns:Boolean = false;

		/**
		 * Determines if the data grid's columns may be sorted.
		 *
		 * <p>The following example enables column sorting:</p>
		 *
		 * <listing version="3.0">
		 * grid.sortableColumns = true;</listing>
		 *
		 * @default false
		 * 
		 * @see feathers.controls.DataGridColumn#sortOrder
		 */
		public function get sortableColumns():Boolean
		{
			return this._sortableColumns;
		}

		/**
		 * @private
		 */
		public function set sortableColumns(value:Boolean):void
		{
			this._sortableColumns = value;
		}

		/**
		 * @private
		 */
		protected var _resizableColumns:Boolean = false;

		/**
		 * Determines if the data grid's columns may be resized.
		 *
		 * <p>The following example enables column resizing:</p>
		 *
		 * <listing version="3.0">
		 * grid.resizableColumns = true;</listing>
		 *
		 * @default false
		 * 
		 * @see #style:columnResizeSkin
		 */
		public function get resizableColumns():Boolean
		{
			return this._resizableColumns;
		}

		/**
		 * @private
		 */
		public function set resizableColumns(value:Boolean):void
		{
			this._resizableColumns = value;
		}

		/**
		 * @private
		 */
		protected var _currentColumnDropIndicatorSkin:DisplayObject = null;

		/**
		 * @private
		 */
		protected var _columnDropIndicatorSkin:DisplayObject = null;

		/**
		 * @private
		 */
		public function get columnDropIndicatorSkin():DisplayObject
		{
			return this._columnDropIndicatorSkin;
		}

		/**
		 * @private
		 */
		public function set columnDropIndicatorSkin(value:DisplayObject):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				if(value !== null)
				{
					value.dispose();
				}
				return;
			}
			this._columnDropIndicatorSkin = value;
		}

		/**
		 * @private
		 */
		protected var _currentColumnResizeSkin:DisplayObject = null;

		/**
		 * @private
		 */
		protected var _columnResizeSkin:DisplayObject = null;

		/**
		 * @private
		 */
		public function get columnResizeSkin():DisplayObject
		{
			return this._columnResizeSkin;
		}

		/**
		 * @private
		 */
		public function set columnResizeSkin(value:DisplayObject):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				if(value !== null)
				{
					value.dispose();
				}
				return;
			}
			this._columnResizeSkin = value;
		}

		/**
		 * @private
		 */
		protected var _currentColumnDragOverlaySkin:DisplayObject = null;

		/**
		 * @private
		 */
		protected var _columnDragOverlaySkin:DisplayObject = null;

		/**
		 * @private
		 */
		public function get columnDragOverlaySkin():DisplayObject
		{
			return this._columnDragOverlaySkin;
		}

		/**
		 * @private
		 */
		public function set columnDragOverlaySkin(value:DisplayObject):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				if(value !== null)
				{
					value.dispose();
				}
				return;
			}
			this._columnDragOverlaySkin = value;
		}

		/**
		 * @private
		 */
		protected var _columnDragAvatarAlpha:Number = 0.8;

		/**
		 * @private
		 */
		public function get columnDragAvatarAlpha():Number
		{
			return this._columnDragAvatarAlpha;
		}

		/**
		 * @private
		 */
		public function set columnDragAvatarAlpha(value:Number):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			this._columnDragAvatarAlpha = value;
		}

		/**
		 * @private
		 */
		protected var _extendedColumnDropIndicator:Boolean = false;

		/**
		 * @private
		 */
		public function get extendedColumnDropIndicator():Boolean
		{
			return this._extendedColumnDropIndicator;
		}

		/**
		 * @private
		 */
		public function set extendedColumnDropIndicator(value:Boolean):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			this._extendedColumnDropIndicator = value;
		}

		/**
		 * @private
		 */
		protected var _layout:ILayout = null;

		/**
		 * @private
		 */
		protected function get layout():ILayout
		{
			return this._layout;
		}

		/**
		 * @private
		 */
		protected function set layout(value:ILayout):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._layout === value)
			{
				return;
			}
			if(this._layout)
			{
				this._layout.removeEventListener(Event.SCROLL, layout_scrollHandler);
			}
			this._layout = value;
			if(this._layout is IVariableVirtualLayout)
			{
				this._layout.addEventListener(Event.SCROLL, layout_scrollHandler);
			}
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
		}

		/**
		 * @private
		 */
		protected var _updateForDataReset:Boolean = false;

		/**
		 * @private
		 */
		protected var _dataProvider:IListCollection;

		/**
		 * The collection of data displayed by the data grid. Changing this
		 * property to a new value is considered a drastic change to the data
		 * grid's data, so the horizontal and vertical scroll positions will be
		 * reset, and the data grid's selection will be cleared.
		 *
		 * <p>The following example passes in a data provider and columns:</p>
		 *
		 * <listing version="3.0">
		 * grid.dataProvider = new ArrayCollection(
		 * [
		 *     { item: "Chicken breast", dept: "Meat", price: "5.90" },
		 *     { item: "Butter", dept: "Dairy", price: "4.69" },
		 *     { item: "Broccoli", dept: "Produce", price: "2.99" },
		 *     { item: "Whole Wheat Bread", dept: "Bakery", price: "2.49" },
		 * ]);
		 * 
		 * grid.columns = new ArrayCollection(
		 * [
		 *     new DataGridColumn("item", "Item"),
		 *     new DataGridColumn("dept", "Department"),
		 *     new DataGridColumn("price", "Unit Price"),
		 * ]);</listing>
		 *
		 * <p><em>Warning:</em> A data grid's data provider cannot contain
		 * duplicate items. To display the same item in multiple item
		 * renderers, you must create separate objects with the same
		 * properties. This restriction exists because it significantly improves
		 * performance.</p>
		 *
		 * <p><em>Warning:</em> If the data provider contains display objects,
		 * concrete textures, or anything that needs to be disposed, those
		 * objects will not be automatically disposed when the data grid is
		 * disposed. Similar to how <code>starling.display.Image</code> cannot
		 * automatically dispose its texture because the texture may be used
		 * by other display objects, a data grid cannot dispose its data
		 * provider because the data provider may be used by other data grids.
		 * See the <code>dispose()</code> function on
		 * <code>IListCollection</code> to see how the data provider can be
		 * disposed properly.</p>
		 *
		 * @default null
		 *
		 * @see #columns
		 * @see feathers.data.IListCollection#dispose()
		 * @see feathers.data.ArrayCollection
		 * @see feathers.data.VectorCollection
		 * @see feathers.data.XMLListCollection
		 */
		public function get dataProvider():IListCollection
		{
			return this._dataProvider;
		}

		/**
		 * @private
		 */
		public function set dataProvider(value:IListCollection):void
		{
			if(this._dataProvider == value)
			{
				return;
			}
			if(this._dataProvider)
			{
				this._dataProvider.removeEventListener(CollectionEventType.FILTER_CHANGE, dataProvider_filterChangeHandler);
				this._dataProvider.removeEventListener(CollectionEventType.SORT_CHANGE, dataProvider_sortChangeHandler);
				this._dataProvider.removeEventListener(CollectionEventType.ADD_ITEM, dataProvider_addItemHandler);
				this._dataProvider.removeEventListener(CollectionEventType.REMOVE_ITEM, dataProvider_removeItemHandler);
				this._dataProvider.removeEventListener(CollectionEventType.REMOVE_ALL, dataProvider_removeAllHandler);
				this._dataProvider.removeEventListener(CollectionEventType.REPLACE_ITEM, dataProvider_replaceItemHandler);
				this._dataProvider.removeEventListener(CollectionEventType.RESET, dataProvider_resetHandler);
				this._dataProvider.removeEventListener(Event.CHANGE, dataProvider_changeHandler);
			}
			this._dataProvider = value;
			if(this._dataProvider)
			{
				this._dataProvider.addEventListener(CollectionEventType.FILTER_CHANGE, dataProvider_filterChangeHandler);
				this._dataProvider.addEventListener(CollectionEventType.SORT_CHANGE, dataProvider_sortChangeHandler);
				this._dataProvider.addEventListener(CollectionEventType.ADD_ITEM, dataProvider_addItemHandler);
				this._dataProvider.addEventListener(CollectionEventType.REMOVE_ITEM, dataProvider_removeItemHandler);
				this._dataProvider.addEventListener(CollectionEventType.REMOVE_ALL, dataProvider_removeAllHandler);
				this._dataProvider.addEventListener(CollectionEventType.REPLACE_ITEM, dataProvider_replaceItemHandler);
				this._dataProvider.addEventListener(CollectionEventType.RESET, dataProvider_resetHandler);
				this._dataProvider.addEventListener(Event.CHANGE, dataProvider_changeHandler);
			}

			//reset the scroll position because this is a drastic change and
			//the data is probably completely different
			this.horizontalScrollPosition = 0;
			this.verticalScrollPosition = 0;

			//clear the selection for the same reason
			this.selectedIndex = -1;

			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _columns:IListCollection = null;

		/**
		 * Defines the columns to display for each item in the data provider.
		 * If <code>null</code>, the data grid will attempt to populate the
		 * columns automatically.
		 *
		 * <p>The following example passes in a data provider and columns:</p>
		 *
		 * <listing version="3.0">
		 * grid.dataProvider = new ArrayCollection(
		 * [
		 *     { item: "Chicken breast", dept: "Meat", price: "5.90" },
		 *     { item: "Butter", dept: "Dairy", price: "4.69" },
		 *     { item: "Broccoli", dept: "Produce", price: "2.99" },
		 *     { item: "Whole Wheat Bread", dept: "Bakery", price: "2.49" },
		 * ]);
		 * 
		 * grid.columns = new ArrayCollection(
		 * [
		 *     new DataGridColumn("item", "Item"),
		 *     new DataGridColumn("dept", "Department"),
		 *     new DataGridColumn("price", "Unit Price"),
		 * ]);</listing>
		 *
		 * @default null
		 * 
		 * @see #dataProvider
		 * @see feathers.controls.DataGridColumn
		 */
		public function get columns():IListCollection
		{
			return this._columns;
		}

		/**
		 * @private
		 */
		public function set columns(value:IListCollection):void
		{
			if(this._columns === value)
			{
				return;
			}
			if(this._columns !== null)
			{
				this._columns.removeEventListener(Event.CHANGE, columns_changeHandler);
				this._columns.removeEventListener(CollectionEventType.RESET, columns_resetHandler);
				this._columns.removeEventListener(CollectionEventType.UPDATE_ALL, columns_updateAllHandler);
			}
			this._columns = value;
			if(this._columns !== null)
			{
				this._columns.addEventListener(Event.CHANGE, columns_changeHandler);
				this._columns.addEventListener(CollectionEventType.RESET, columns_resetHandler);
				this._columns.addEventListener(CollectionEventType.UPDATE_ALL, columns_updateAllHandler);
			}

			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _isSelectable:Boolean = true;

		/**
		 * Determines if items in the data grid may be selected. By default
		 * only a single item may be selected at any given time. In other
		 * words, if item A is selected, and the user selects item B, item A
		 * will be deselected automatically. Set
		 * <code>allowMultipleSelection</code> to <code>true</code> to select
		 * more than one item without automatically deselecting other items.
		 *
		 * <p>The following example disables selection:</p>
		 *
		 * <listing version="3.0">
		 * grid.isSelectable = false;</listing>
		 *
		 * @default true
		 *
		 * @see #selectedItem
		 * @see #selectedIndex
		 * @see #allowMultipleSelection
		 */
		public function get isSelectable():Boolean
		{
			return this._isSelectable;
		}
		
		/**
		 * @private
		 */
		public function set isSelectable(value:Boolean):void
		{
			if(this._isSelectable == value)
			{
				return;
			}
			this._isSelectable = value;
			if(!this._isSelectable)
			{
				this.selectedIndex = -1;
			}
			this.invalidate(INVALIDATION_FLAG_SELECTED);
		}
		
		/**
		 * @private
		 */
		protected var _selectedIndex:int = -1;
		
		/**
		 * The index of the currently selected item. Returns <code>-1</code> if
		 * no item is selected.
		 *
		 * <p>The following example selects an item by its index:</p>
		 *
		 * <listing version="3.0">
		 * grid.selectedIndex = 2;</listing>
		 *
		 * <p>The following example clears the selected index:</p>
		 *
		 * <listing version="3.0">
		 * grid.selectedIndex = -1;</listing>
		 *
		 * <p>The following example listens for when selection changes and
		 * requests the selected index:</p>
		 *
		 * <listing version="3.0">
		 * function grid_changeHandler( event:Event ):void
		 * {
		 *     var grid:DataGrid = DataGrid( event.currentTarget );
		 *     var index:int = grid.selectedIndex;
		 *
		 * }
		 * grid.addEventListener( Event.CHANGE, grid_changeHandler );</listing>
		 *
		 * @default -1
		 *
		 * @see #selectedItem
		 * @see #allowMultipleSelection
		 * @see #selectedItems
		 * @see #selectedIndices
		 */
		public function get selectedIndex():int
		{
			return this._selectedIndex;
		}

		/**
		 * @private
		 */
		public function set selectedIndex(value:int):void
		{
			if(this._selectedIndex == value)
			{
				return;
			}
			if(value >= 0)
			{
				this._selectedIndices.data = new <int>[value];
			}
			else
			{
				this._selectedIndices.removeAll();
			}
			this.invalidate(INVALIDATION_FLAG_SELECTED);
		}

		/**
		 * The currently selected item. Returns <code>null</code> if no item is
		 * selected.
		 *
		 * <p>The following example changes the selected item:</p>
		 *
		 * <listing version="3.0">
		 * grid.selectedItem = grid.dataProvider.getItemAt(0);</listing>
		 *
		 * <p>The following example clears the selected item:</p>
		 *
		 * <listing version="3.0">
		 * grid.selectedItem = null;</listing>
		 *
		 * <p>The following example listens for when selection changes and
		 * requests the selected item:</p>
		 *
		 * <listing version="3.0">
		 * function grid_changeHandler( event:Event ):void
		 * {
		 *     var grid:DataGrid = DataGrid( event.currentTarget );
		 *     var item:Object = grid.selectedItem;
		 *
		 * }
		 * grid.addEventListener( Event.CHANGE, grid_changeHandler );</listing>
		 *
		 * @default null
		 *
		 * @see #selectedIndex
		 * @see #allowMultipleSelection
		 * @see #selectedItems
		 * @see #selectedIndices
		 */
		public function get selectedItem():Object
		{
			if(!this._dataProvider || this._selectedIndex < 0 || this._selectedIndex >= this._dataProvider.length)
			{
				return null;
			}

			return this._dataProvider.getItemAt(this._selectedIndex);
		}

		/**
		 * @private
		 */
		public function set selectedItem(value:Object):void
		{
			if(!this._dataProvider)
			{
				this.selectedIndex = -1;
				return;
			}
			this.selectedIndex = this._dataProvider.getItemIndex(value);
		}

		/**
		 * @private
		 */
		protected var _allowMultipleSelection:Boolean = false;

		/**
		 * If <code>true</code> multiple items may be selected at a time. If
		 * <code>false</code>, then only a single item may be selected at a
		 * time, and if the selection changes, other items are deselected. Has
		 * no effect if <code>isSelectable</code> is <code>false</code>.
		 *
		 * <p>In the following example, multiple selection is enabled:</p>
		 *
		 * <listing version="3.0">
		 * grid.allowMultipleSelection = true;</listing>
		 *
		 * @default false
		 *
		 * @see #isSelectable
		 * @see #selectedIndices
		 * @see #selectedItems
		 */
		public function get allowMultipleSelection():Boolean
		{
			return this._allowMultipleSelection;
		}

		/**
		 * @private
		 */
		public function set allowMultipleSelection(value:Boolean):void
		{
			if(this._allowMultipleSelection == value)
			{
				return;
			}
			this._allowMultipleSelection = value;
			this.invalidate(INVALIDATION_FLAG_SELECTED);
		}

		/**
		 * @private
		 */
		protected var _selectedIndices:ListCollection = new ListCollection(new <int>[]);

		/**
		 * The indices of the currently selected items. Returns an empty <code>Vector.&lt;int&gt;</code>
		 * if no items are selected. If <code>allowMultipleSelection</code> is
		 * <code>false</code>, only one item may be selected at a time.
		 *
		 * <p>The following example selects two items by their indices:</p>
		 *
		 * <listing version="3.0">
		 * grid.selectedIndices = new &lt;int&gt;[ 2, 3 ];</listing>
		 *
		 * <p>The following example clears the selected indices:</p>
		 *
		 * <listing version="3.0">
		 * grid.selectedIndices = null;</listing>
		 *
		 * <p>The following example listens for when selection changes and
		 * requests the selected indices:</p>
		 *
		 * <listing version="3.0">
		 * function grid_changeHandler( event:Event ):void
		 * {
		 *     var grid:DataGrid = DataGrid( event.currentTarget );
		 *     var indices:Vector.&lt;int&gt; = grid.selectedIndices;
		 *
		 * }
		 * grid.addEventListener( Event.CHANGE, grid_changeHandler );</listing>
		 *
		 * @see #allowMultipleSelection
		 * @see #selectedItems
		 * @see #selectedIndex
		 * @see #selectedItem
		 */
		public function get selectedIndices():Vector.<int>
		{
			return this._selectedIndices.data as Vector.<int>;
		}

		/**
		 * @private
		 */
		public function set selectedIndices(value:Vector.<int>):void
		{
			var oldValue:Vector.<int> = this._selectedIndices.data as Vector.<int>;
			if(oldValue == value)
			{
				return;
			}
			if(!value)
			{
				if(this._selectedIndices.length == 0)
				{
					return;
				}
				this._selectedIndices.removeAll();
			}
			else
			{
				if(!this._allowMultipleSelection && value.length > 0)
				{
					value.length = 1;
				}
				this._selectedIndices.data = value;
			}
			this.invalidate(INVALIDATION_FLAG_SELECTED);
		}

		/**
		 * @private
		 */
		protected var _selectedItems:Vector.<Object> = new <Object>[];

		/**
		 * The currently selected item. The getter returns an empty
		 * <code>Vector.&lt;Object&gt;</code> if no item is selected. If any
		 * items are selected, the getter creates a new
		 * <code>Vector.&lt;Object&gt;</code> to return a list of selected
		 * items.
		 *
		 * <p>The following example selects two items:</p>
		 *
		 * <listing version="3.0">
		 * grid.selectedItems = new &lt;Object&gt;[ grid.dataProvider.getItemAt(2) , grid.dataProvider.getItemAt(3) ];</listing>
		 *
		 * <p>The following example clears the selected items:</p>
		 *
		 * <listing version="3.0">
		 * grid.selectedItems = null;</listing>
		 *
		 * <p>The following example listens for when selection changes and
		 * requests the selected items:</p>
		 *
		 * <listing version="3.0">
		 * function grid_changeHandler( event:Event ):void
		 * {
		 *     var grid:DataGrid = DataGrid( event.currentTarget );
		 *     var items:Vector.&lt;Object&gt; = grid.selectedItems;
		 *
		 * }
		 * grid.addEventListener( Event.CHANGE, grid_changeHandler );</listing>
		 *
		 * @see #allowMultipleSelection
		 * @see #selectedIndices
		 * @see #selectedIndex
		 * @see #selectedItem
		 */
		public function get selectedItems():Vector.<Object>
		{
			return this._selectedItems;
		}

		/**
		 * @private
		 */
		public function set selectedItems(value:Vector.<Object>):void
		{
			if(!value || !this._dataProvider)
			{
				this.selectedIndex = -1;
				return;
			}
			var indices:Vector.<int> = new <int>[];
			var itemCount:int = value.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:Object = value[i];
				var index:int = this._dataProvider.getItemIndex(item);
				if(index >= 0)
				{
					indices.push(index);
				}
			}
			this.selectedIndices = indices;
		}

		/**
		 * Returns the selected items, with the ability to pass in an optional
		 * result vector. Better for performance than the <code>selectedItems</code>
		 * getter because it can avoid the allocation, and possibly garbage
		 * collection, of the result object.
		 *
		 * @see #selectedItems
		 */
		public function getSelectedItems(result:Vector.<Object> = null):Vector.<Object>
		{
			if(result !== null)
			{
				result.length = 0;
			}
			else
			{
				result = new <Object>[];
			}
			if(!this._dataProvider)
			{
				return result;
			}
			var indexCount:int = this._selectedIndices.length;
			for(var i:int = 0; i < indexCount; i++)
			{
				var index:int = this._selectedIndices.getItemAt(i) as int;
				var item:Object = this._dataProvider.getItemAt(index);
				result[i] = item;
			}
			return result;
		}
		
		/**
		 * @private
		 */
		protected var _typicalItem:Object = null;
		
		/**
		 * Used to auto-size the data grid when a virtualized layout is used.
		 * If the data grid's width or height is unknown, the data grid will
		 * try to automatically pick an ideal size. This item is used to create
		 * a sample item renderer to measure item renderers that are virtual
		 * and not visible in the viewport.
		 *
		 * <p>The following example provides a typical item:</p>
		 *
		 * <listing version="3.0">
		 * grid.typicalItem = { text: "A typical item", thumbnail: texture };</listing>
		 *
		 * @default null
		 */
		public function get typicalItem():Object
		{
			return this._typicalItem;
		}
		
		/**
		 * @private
		 */
		public function set typicalItem(value:Object):void
		{
			if(this._typicalItem == value)
			{
				return;
			}
			this._typicalItem = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _keyScrollDuration:Number = 0.25;

		/**
		 * @private
		 */
		public function get keyScrollDuration():Number
		{
			return this._keyScrollDuration;
		}

		/**
		 * @private
		 */
		public function set keyScrollDuration(value:Number):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			this._keyScrollDuration = value;
		}

		/**
		 * @private
		 */
		protected var _headerBackgroundSkin:DisplayObject = null;

		/**
		 * @private
		 */
		public function get headerBackgroundSkin():DisplayObject
		{
			return this._headerBackgroundSkin;
		}

		/**
		 * @private
		 */
		public function set headerBackgroundSkin(value:DisplayObject):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				if(value !== null)
				{
					value.dispose();
				}
				return;
			}
			if(this._headerBackgroundSkin === value)
			{
				return;
			}
			this._headerBackgroundSkin = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _headerBackgroundDisabledSkin:DisplayObject = null;

		/**
		 * @private
		 */
		public function get headerBackgroundDisabledSkin():DisplayObject
		{
			return this._headerBackgroundDisabledSkin;
		}

		/**
		 * @private
		 */
		public function set headerBackgroundDisabledSkin(value:DisplayObject):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				if(value !== null)
				{
					value.dispose();
				}
				return;
			}
			if(this._headerBackgroundDisabledSkin === value)
			{
				return;
			}
			this._headerBackgroundDisabledSkin = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _verticalDividerFactory:Function = null;

		/**
		 * @private
		 * 
		 * @see #style:verticalDividerFactory
		 */
		public function get verticalDividerFactory():Function
		{
			return this._verticalDividerFactory;
		}

		/**
		 * @private
		 */
		public function set verticalDividerFactory(value:Function):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._verticalDividerFactory === value)
			{
				return;
			}
			this._verticalDividerFactory = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _headerDividerFactory:Function = null;

		/**
		 * @private
		 * 
		 * @see #style:headerDividerFactory
		 */
		public function get headerDividerFactory():Function
		{
			return this._headerDividerFactory;
		}

		/**
		 * @private
		 */
		public function set headerDividerFactory(value:Function):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._headerDividerFactory === value)
			{
				return;
			}
			this._headerDividerFactory = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _cellRendererFactory:Function = null;
		
		/**
		 * Specifies a default factory for cell renderers that will be used if
		 * the <code>cellRendererFactory</code> from a
		 * <code>DataGridColumn</code> is <code>null</code>.
		 *
		 * <p>The function is expected to have the following signature:</p>
		 *
		 * <pre>function():IDataGridCellRenderer</pre>
		 *
		 * <p>The following example provides a factory for the data grid:</p>
		 *
		 * <listing version="3.0">
		 * grid.cellRendererFactory = function():IDataGridCellRenderer
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
		 * @private
		 * 
		 * @see #style:customCellRendererStyleName
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
		 * Specifies a default factory for header renderers that will be used if
		 * the <code>headerRendererFactory</code> from a
		 * <code>DataGridColumn</code> is <code>null</code>.
		 *
		 * <p>The function is expected to have the following signature:</p>
		 *
		 * <pre>function():IDataGridHeaderRenderer</pre>
		 *
		 * <p>The following example provides a factory for the data grid:</p>
		 *
		 * <listing version="3.0">
		 * grid.headerRendererFactory = function():IDataGridHeaderRenderer
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
		 * @private
		 * 
		 * @see #style:customHeaderRendererStyleName
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
		protected var _draggedHeaderIndex:int = -1;

		/**
		 * @private
		 */
		protected var _headerTouchID:int = -1;

		/**
		 * @private
		 */
		protected var _headerTouchX:Number;

		/**
		 * @private
		 */
		protected var _headerTouchY:Number;

		/**
		 * @private
		 */
		protected var _headerDividerTouchID:int = -1;

		/**
		 * @private
		 */
		protected var _headerDividerTouchX:Number;
		
		/**
		 * @private
		 */
		protected var _resizingColumnIndex:int = -1;

		/**
		 * @private
		 */
		protected var _customColumnSizes:Vector.<Number> = null;

		/**
		 * The pending item index to scroll to after validating. A value of
		 * <code>-1</code> means that the scroller won't scroll to an item after
		 * validating.
		 */
		protected var pendingItemIndex:int = -1;

		/**
		 * @private
		 */
		override public function scrollToPosition(horizontalScrollPosition:Number, verticalScrollPosition:Number, animationDuration:Number = NaN):void
		{
			this.pendingItemIndex = -1;
			super.scrollToPosition(horizontalScrollPosition, verticalScrollPosition, animationDuration);
		}

		/**
		 * @private
		 */
		override public function scrollToPageIndex(horizontalPageIndex:int, verticalPageIndex:int, animationDuration:Number = NaN):void
		{
			this.pendingItemIndex = -1;
			super.scrollToPageIndex(horizontalPageIndex, verticalPageIndex, animationDuration);
		}
		
		/**
		 * Scrolls the data grid so that the specified item is visible. If
		 * <code>animationDuration</code> is greater than zero, the scroll will
		 * animate. The duration is in seconds.
		 *
		 * <p>If the layout is virtual with variable item dimensions, this
		 * function may not accurately scroll to the exact correct position. A
		 * virtual layout with variable item dimensions is often forced to
		 * estimate positions, so the results aren't guaranteed to be accurate.</p>
		 *
		 * <p>If you want to scroll to the end of the data grid, it is better
		 * to use <code>scrollToPosition()</code> with
		 * <code>maxHorizontalScrollPosition</code> or
		 * <code>maxVerticalScrollPosition</code>.</p>
		 *
		 * <p>In the following example, the data grid is scrolled to display index 10:</p>
		 *
		 * <listing version="3.0">
		 * grid.scrollToDisplayIndex( 10 );</listing>
		 * 
		 * @param index The integer index of an item from the data provider.
		 * @param animationDuration The length of time, in seconds, of the animation. May be zero to scroll instantly.
		 *
		 * @see #scrollToPosition()
		 */
		public function scrollToDisplayIndex(index:int, animationDuration:Number = 0):void
		{
			//cancel any pending scroll to a different page or scroll position.
			//we can have only one type of pending scroll at a time.
			this.hasPendingHorizontalPageIndex = false;
			this.hasPendingVerticalPageIndex = false;
			this.pendingHorizontalScrollPosition = NaN;
			this.pendingVerticalScrollPosition = NaN;
			if(this.pendingItemIndex == index &&
				this.pendingScrollDuration == animationDuration)
			{
				return;
			}
			this.pendingItemIndex = index;
			this.pendingScrollDuration = animationDuration;
			this.invalidate(INVALIDATION_FLAG_PENDING_SCROLL);
		}

		/**
		 * @private
		 */
		override public function dispose():void
		{
			if(this._columnDropIndicatorSkin !== null &&
				this._columnDropIndicatorSkin.parent === null)
			{
				this._columnDropIndicatorSkin.dispose();
				this._columnDropIndicatorSkin = null;
			}
			if(this._columnDragOverlaySkin !== null &&
				this._columnDragOverlaySkin.parent === null)
			{
				this._columnDragOverlaySkin.dispose();
				this._columnDragOverlaySkin = null;
			}
			this.refreshInactiveHeaderDividers(true);
			this.refreshInactiveVerticalDividers(true);
			//clearing selection now so that the data provider setter won't
			//cause a selection change that triggers events.
			this._selectedIndices.removeEventListeners();
			this._selectedIndex = -1;
			this.dataProvider = null;
			this.columns = null;
			this.layout = null;
			super.dispose();
		}

		/**
		 * @private
		 */
		override protected function initialize():void
		{
			var hasLayout:Boolean = this._layout !== null;

			super.initialize();

			if(!this.dataViewPort)
			{
				this.viewPort = this.dataViewPort = new DataGridDataViewPort();
				this.dataViewPort.owner = this;
				this.viewPort = this.dataViewPort;
			}

			if(this._verticalDividerGroup === null)
			{
				this._verticalDividerGroup = new LayoutGroup();
				this._verticalDividerGroup.touchable = false;
				this.addChild(this._verticalDividerGroup);
			}

			if(this._headerLayout === null)
			{
				this._headerLayout = new HorizontalLayout();
				this._headerLayout.useVirtualLayout = false;
				this._headerLayout.verticalAlign = VerticalAlign.JUSTIFY;
			}

			if(this._headerGroup === null)
			{
				this._headerGroup = new LayoutGroup();
				this.addChild(this._headerGroup);
			}

			this._headerGroup.layout = this._headerLayout;

			if(this._headerDividerGroup === null)
			{
				this._headerDividerGroup = new LayoutGroup();
				this.addChild(this._headerDividerGroup);
			}

			if(!hasLayout)
			{
				if(this._hasElasticEdges &&
					this._verticalScrollPolicy === ScrollPolicy.AUTO &&
					this._scrollBarDisplayMode !== ScrollBarDisplayMode.FIXED)
				{
					//so that the elastic edges work even when the max scroll
					//position is 0, similar to iOS.
					this._verticalScrollPolicy = ScrollPolicy.ON;
				}

				var layout:VerticalLayout = new VerticalLayout();
				layout.useVirtualLayout = true;
				layout.horizontalAlign = HorizontalAlign.JUSTIFY;
				this.ignoreNextStyleRestriction();
				this.layout = layout;
			}
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			var stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);

			if(stylesInvalid)
			{
				this.refreshHeaderStyles();
			}

			this.refreshColumns();

			this.refreshHeaderRenderers();
			this.refreshDataViewPortProperties();
			super.draw();
		}

		/**
		 * @private
		 * If the columns are not defined, we can try to create them automatically.
		 */
		protected function refreshColumns():void
		{
			if(this._columns !== null || this._dataProvider === null || this._dataProvider.length === 0)
			{
				return;
			}
			var columns:Array = [];
			var firstItem:Object = this._dataProvider.getItemAt(0);
			var pushIndex:int = 0;
			for(var key:String in firstItem)
			{
				columns[pushIndex] = new DataGridColumn(key);
				pushIndex++;
			}
			this._columns = new ArrayCollection(columns);
		}

		/**
		 * @private
		 */
		protected function refreshHeaderStyles():void
		{
			this._headerGroup.backgroundSkin = this._headerBackgroundSkin;
			this._headerGroup.backgroundDisabledSkin = this._headerBackgroundDisabledSkin;
		}

		/**
		 * @private
		 */
		override protected function calculateViewPortOffsets(forceScrollBars:Boolean = false, useActualBounds:Boolean = false):void
		{
			super.calculateViewPortOffsets(forceScrollBars, useActualBounds);

			this._headerLayout.paddingLeft = this._leftViewPortOffset;
			this._headerLayout.paddingRight = this._rightViewPortOffset;
			if(useActualBounds)
			{
				this._headerGroup.width = this.actualWidth;
			}
			else
			{
				this._headerGroup.width = this._explicitWidth;
			}
			this._headerGroup.validate();
			this._topViewPortOffset += this._headerGroup.height;
		}

		/**
		 * @private
		 */
		override protected function layoutChildren():void
		{
			this.validateCustomColumnSizes();
			this.layoutHeaderRenderers();

			this._headerLayout.paddingLeft = this._leftViewPortOffset;
			this._headerLayout.paddingRight = this._rightViewPortOffset;
			this._headerGroup.width = this.actualWidth;
			this._headerGroup.validate();
			this._headerGroup.x = 0;
			this._headerGroup.y = this._topViewPortOffset - this._headerGroup.height;
			this._headerDividerGroup.x = this._headerGroup.x;
			this._headerDividerGroup.y = this._headerGroup.y;
			this._headerDividerGroup.width = this._headerGroup.width;

			super.layoutChildren();

			this._verticalDividerGroup.x = this._headerGroup.x;
			this._verticalDividerGroup.y = this._headerGroup.y + this._headerGroup.height;
			this._verticalDividerGroup.width = this._headerGroup.width;
			this._verticalDividerGroup.height = this.viewPort.visibleHeight;

			this.refreshHeaderDividers();
			this.refreshVerticalDividers();
		}

		/**
		 * @private
		 */
		protected function validateCustomColumnSizes():void
		{
			if(this._customColumnSizes === null || this._customColumnSizes.length < this._columns.length)
			{
				return;
			}

			var availableWidth:Number = this.actualWidth - this._leftViewPortOffset - this._rightViewPortOffset;
			var count:int = this._customColumnSizes.length;
			var totalWidth:Number = 0;
			var indices:Vector.<int> = new <int>[];
			for(var i:int = 0; i < count; i++)
			{
				var column:DataGridColumn = DataGridColumn(this._columns.getItemAt(i));
				if(column.width === column.width) //!isNaN
				{
					//if the width is set explicitly, skip it!
					availableWidth -= column.width;
					continue;
				}
				var size:Number = this._customColumnSizes[i];
				totalWidth += size;
				indices[i] = i;
			}
			if(totalWidth === availableWidth)
			{
				return;
			}

			//make a copy so that this is detected as a change
			this._customColumnSizes = this._customColumnSizes.slice();

			var widthToDistribute:Number = availableWidth - totalWidth;
			this.distributeWidthToIndices(widthToDistribute, indices, totalWidth);
			this.dataViewPort.customColumnSizes = this._customColumnSizes;
		}

		/**
		 * @private
		 */
		protected function distributeWidthToIndices(widthToDistribute:Number, indices:Vector.<int>, totalWidthOfIndices:Number):void
		{
			while(Math.abs(widthToDistribute) > 1)
			{
				//this will be the store value if we need to loop again
				var nextWidthToDistribute:Number = widthToDistribute;
				var count:int = indices.length;
				for(var i:int = count - 1; i >= 0; i--)
				{
					var index:int = indices[i];
					var headerRenderer:IDataGridHeaderRenderer = IDataGridHeaderRenderer(this._headerGroup.getChildAt(index));
					var columnWidth:Number = headerRenderer.width;
					var column:DataGridColumn = DataGridColumn(this._columns.getItemAt(index));
					var percent:Number = columnWidth / totalWidthOfIndices;
					var offset:Number = widthToDistribute * percent;
					var newWidth:Number = this._customColumnSizes[index] + offset;
					if(newWidth < column.minWidth)
					{
						offset += (column.minWidth - newWidth);
						newWidth = column.minWidth;
						//we've hit the minimum, so skip it if we loop again
						indices.removeAt(i);
						//also readjust the total to exclude this column
						//so that the percentages still add up to 100%
						totalWidthOfIndices -= columnWidth;
					}
					this._customColumnSizes[index] = newWidth;
					nextWidthToDistribute -= offset;
				}
				widthToDistribute = nextWidthToDistribute;
			}

			if(widthToDistribute !== 0)
			{
				//if we have less than a pixel left, just add it to the
				//final column and exit the loop
				this._customColumnSizes[this._customColumnSizes.length - 1] += widthToDistribute;
			}
		}

		/**
		 * @private
		 */
		protected function layoutHeaderRenderers():void
		{
			var columnCount:int = 0;
			if(this._columns !== null)
			{
				columnCount = this._columns.length;
			}
			for(var i:int = 0; i < columnCount; i++)
			{
				var headerRenderer:IDataGridHeaderRenderer = IDataGridHeaderRenderer(this._headerGroup.getChildAt(i));
				var column:DataGridColumn = DataGridColumn(this._columns.getItemAt(i));
				if(column.width === column.width) //!isNaN
				{
					headerRenderer.width = column.width;
					headerRenderer.layoutData = null;
				}
				else if(this._customColumnSizes !== null && i < this._customColumnSizes.length)
				{
					headerRenderer.width = this._customColumnSizes[i];
					headerRenderer.layoutData = null;
				}
				else if(headerRenderer.layoutData === null)
				{
					headerRenderer.layoutData = new HorizontalLayoutData(100);
				}
				headerRenderer.minWidth = column.minWidth;
			}
		}

		/**
		 * @private
		 */
		protected function refreshVerticalDividers():void
		{
			this.refreshInactiveVerticalDividers(this._verticalDividerStorage.factory !== this._verticalDividerFactory);
			this._verticalDividerStorage.factory = this._verticalDividerFactory;

			var columnCount:int = 0;
			if(this._columns !== null)
			{
				columnCount = this._columns.length;
			}
			var dividerCount:int = 0;
			if(this._verticalDividerFactory !== null)
			{
				dividerCount = columnCount - 1;
			}

			this._headerGroup.validate();
			var activeDividers:Vector.<DisplayObject> = this._verticalDividerStorage.activeDividers;
			var inactiveDividers:Vector.<DisplayObject> = this._verticalDividerStorage.inactiveDividers;
			for(var i:int = 0; i < dividerCount; i++)
			{
				var verticalDivider:DisplayObject = null;
				if(inactiveDividers.length > 0)
				{
					verticalDivider = inactiveDividers.shift();
					this._verticalDividerGroup.setChildIndex(verticalDivider, i);
				}
				else
				{
					verticalDivider = DisplayObject(this._verticalDividerFactory());
					this._verticalDividerGroup.addChildAt(verticalDivider, i);
				}
				activeDividers[i] = verticalDivider;
				verticalDivider.height = this._viewPort.visibleHeight;
				if(verticalDivider is IValidating)
				{
					IValidating(verticalDivider).validate();
				}
				var headerRenderer:IDataGridHeaderRenderer = IDataGridHeaderRenderer(this._headerGroup.getChildAt(i));
				verticalDivider.x = headerRenderer.x + headerRenderer.width - (verticalDivider.width / 2);
				verticalDivider.y = 0;
			}
			this.freeInactiveVerticalDividers();
		}

		/**
		 * @private
		 */
		protected function refreshInactiveVerticalDividers(forceCleanup:Boolean):void
		{
			var temp:Vector.<DisplayObject> = this._verticalDividerStorage.inactiveDividers;
			this._verticalDividerStorage.inactiveDividers = this._verticalDividerStorage.activeDividers;
			this._verticalDividerStorage.activeDividers = temp;
			if(forceCleanup)
			{
				this.freeInactiveVerticalDividers();
			}
		}

		/**
		 * @private
		 */
		protected function freeInactiveVerticalDividers():void
		{
			var inactiveDividers:Vector.<DisplayObject> = this._verticalDividerStorage.inactiveDividers;
			var dividerCount:int = inactiveDividers.length;
			for(var i:int = 0; i < dividerCount; i++)
			{
				var verticalDivider:DisplayObject = inactiveDividers.shift();
				verticalDivider.removeFromParent(true);
			}
		}

		/**
		 * @private
		 */
		protected function refreshHeaderDividers():void
		{
			this.refreshInactiveHeaderDividers(this._headerDividerStorage.factory !== this._headerDividerFactory);
			this._headerDividerStorage.factory = this._headerDividerFactory;

			var dividerCount:int = 0;
			if(this._columns !== null)
			{
				dividerCount = this._columns.length;
				if(this._scrollBarDisplayMode !== ScrollBarDisplayMode.FIXED ||
					this._minVerticalScrollPosition === this._maxVerticalScrollPosition)
				{
					dividerCount--;
				}
			}

			this._headerGroup.validate();
			var activeDividers:Vector.<DisplayObject> = this._headerDividerStorage.activeDividers;
			var inactiveDividers:Vector.<DisplayObject> = this._headerDividerStorage.inactiveDividers;
			for(var i:int = 0; i < dividerCount; i++)
			{
				var headerDivider:DisplayObject = null;
				if(inactiveDividers.length > 0)
				{
					headerDivider = inactiveDividers.shift();
					this._headerDividerGroup.setChildIndex(headerDivider, i);
				}
				else if(this._headerDividerFactory !== null)
				{
					headerDivider = DisplayObject(this._headerDividerFactory());
					headerDivider.addEventListener(TouchEvent.TOUCH, headerDivider_touchHandler);
					this._headerDividerGroup.addChildAt(headerDivider, i);
				}
				else
				{
					headerDivider = new Quad(3, 1, 0xff00ff);
					headerDivider.alpha = 0;
					if(!SystemUtil.isDesktop)
					{
						headerDivider.width = 22;
					}
					headerDivider.addEventListener(TouchEvent.TOUCH, headerDivider_touchHandler);
					this._headerDividerGroup.addChildAt(headerDivider, i);
				}
				activeDividers[i] = headerDivider;
				var headerRenderer:IDataGridHeaderRenderer = IDataGridHeaderRenderer(this._headerGroup.getChildAt(i));
				headerDivider.height = headerRenderer.height;
				if(headerDivider is IValidating)
				{
					IValidating(headerDivider).validate();
				}
				headerDivider.x = headerRenderer.x + headerRenderer.width - (headerDivider.width / 2);
				headerDivider.y = headerRenderer.y;
			}
			this.freeInactiveHeaderDividers();
		}

		/**
		 * @private
		 */
		protected function refreshInactiveHeaderDividers(forceCleanup:Boolean):void
		{
			var temp:Vector.<DisplayObject> = this._headerDividerStorage.inactiveDividers;
			this._headerDividerStorage.inactiveDividers = this._headerDividerStorage.activeDividers;
			this._headerDividerStorage.activeDividers = temp;
			if(forceCleanup)
			{
				this.freeInactiveHeaderDividers();
			}
		}

		/**
		 * @private
		 */
		protected function freeInactiveHeaderDividers():void
		{
			var inactiveDividers:Vector.<DisplayObject> = this._headerDividerStorage.inactiveDividers;
			var dividerCount:int = inactiveDividers.length;
			for(var i:int = 0; i < dividerCount; i++)
			{
				var headerDivider:DisplayObject = inactiveDividers.shift();
				headerDivider.removeEventListener(TouchEvent.TOUCH, headerDivider_touchHandler);
				headerDivider.removeFromParent(true);
			}
		}

		/**
		 * @private
		 */
		protected function refreshHeaderRenderers():void
		{
			this.findUnrenderedData();
			this.recoverInactiveHeaderRenderers();
			this.renderUnrenderedData();
			this.freeInactiveHeaderRenderers();
			this._updateForDataReset = false;
		}

		/**
		 * @private
		 */
		protected function findUnrenderedData():void
		{
			var temp:Vector.<IDataGridHeaderRenderer> = this._headerStorage.inactiveHeaderRenderers;
			this._headerStorage.inactiveHeaderRenderers = this._headerStorage.activeHeaderRenderers;
			this._headerStorage.activeHeaderRenderers = temp;

			var activeHeaderRenderers:Vector.<IDataGridHeaderRenderer> = this._headerStorage.activeHeaderRenderers;
			var inactiveHeaderRenderers:Vector.<IDataGridHeaderRenderer> = this._headerStorage.inactiveHeaderRenderers;

			var columnCount:int = 0;
			if(this._columns !== null)
			{
				columnCount = this._columns.length;
			}

			var activePushIndex:int = activeHeaderRenderers.length;
			var unrenderedDataLastIndex:int = this._unrenderedHeaders.length;
			for(var i:int = 0; i < columnCount; i++)
			{
				var column:DataGridColumn = DataGridColumn(this._columns.getItemAt(i));
				var headerRenderer:IDataGridHeaderRenderer = this._headerRendererMap[column] as IDataGridHeaderRenderer;
				if(headerRenderer !== null)
				{
					headerRenderer.columnIndex = i;
					headerRenderer.visible = true;
					if(column === this._sortedColumn)
					{
						if(this._reverseSort)
						{
							headerRenderer.sortOrder = SortOrder.DESCENDING;
						}
						else
						{
							headerRenderer.sortOrder = SortOrder.ASCENDING;
						}
					}
					else
					{
						headerRenderer.sortOrder = SortOrder.NONE;
					}
					this._headerGroup.setChildIndex(DisplayObject(headerRenderer), i);
					if(this._updateForDataReset)
					{
						//similar to calling updateItemAt(), replacing the data
						//provider or resetting its source means that we should
						//trick the item renderer into thinking it has new data.
						//many developers seem to expect this behavior, so while
						//it's not the most optimal for performance, it saves on
						//support time in the forums. thankfully, it's still
						//somewhat optimized since the same item renderer will
						//receive the same data, and the children generally
						//won't have changed much, if at all.
						headerRenderer.data = null;
						headerRenderer.data = column;
					}
					activeHeaderRenderers[activePushIndex] = headerRenderer;
					activePushIndex++;

					var inactiveIndex:int = inactiveHeaderRenderers.indexOf(headerRenderer);
					if(inactiveIndex >= 0)
					{
						inactiveHeaderRenderers[inactiveIndex] = null;
					}
					else
					{
						throw new IllegalOperationError("DataGrid: header renderer map contains bad data. This may be caused by duplicate items in the columns collection, which is not allowed.");
					}
				}
				else
				{
					this._unrenderedHeaders[unrenderedDataLastIndex] = i;
					unrenderedDataLastIndex++;
				}
			}
		}

		/**
		 * @private
		 */
		protected function recoverInactiveHeaderRenderers():void
		{
			var inactiveHeaderRenderers:Vector.<IDataGridHeaderRenderer> = this._headerStorage.inactiveHeaderRenderers;
			var count:int = inactiveHeaderRenderers.length;
			for(var i:int = 0; i < count; i++)
			{
				var headerRenderer:IDataGridHeaderRenderer = inactiveHeaderRenderers[i];
				if(headerRenderer === null || headerRenderer.data === null)
				{
					continue;
				}
				this.dispatchEventWith(FeathersEventType.RENDERER_REMOVE, false, headerRenderer);
				delete this._headerRendererMap[headerRenderer.data];
			}
		}

		/**
		 * @private
		 */
		protected function renderUnrenderedData():void
		{
			var headerRendererCount:int = this._unrenderedHeaders.length;
			for(var i:int = 0; i < headerRendererCount; i++)
			{
				var columnIndex:int = this._unrenderedHeaders.shift();
				var column:DataGridColumn = DataGridColumn(this._columns.getItemAt(columnIndex));
				this.createHeaderRenderer(column, columnIndex);
			}
		}

		/**
		 * @private
		 */
		protected function freeInactiveHeaderRenderers():void
		{
			var inactiveHeaderRenderers:Vector.<IDataGridHeaderRenderer> = this._headerStorage.inactiveHeaderRenderers;
			var count:int = inactiveHeaderRenderers.length;
			for(var i:int = 0; i < count; i++)
			{
				var headerRenderer:IDataGridHeaderRenderer = inactiveHeaderRenderers.shift();
				if(headerRenderer === null)
				{
					continue;
				}
				this.destroyHeaderRenderer(headerRenderer);
			}
		}

		/**
		 * @private
		 */
		protected function createHeaderRenderer(column:DataGridColumn, columnIndex:int):IDataGridHeaderRenderer
		{
			var headerRendererFactory:Function = column.headerRendererFactory;
			if(headerRendererFactory === null)
			{
				headerRendererFactory = this._headerRendererFactory;
			}
			if(headerRendererFactory === null)
			{
				headerRendererFactory = defaultHeaderRendererFactory;
			}
			var customHeaderRendererStyleName:String = column.customHeaderRendererStyleName;
			if(customHeaderRendererStyleName === null)
			{
				customHeaderRendererStyleName = this._customHeaderRendererStyleName;
			}
			var inactiveHeaderRenderers:Vector.<IDataGridHeaderRenderer> = this._headerStorage.inactiveHeaderRenderers;
			var activeHeaderRenderers:Vector.<IDataGridHeaderRenderer> = this._headerStorage.activeHeaderRenderers;
			var headerRenderer:IDataGridHeaderRenderer = null;
			do
			{
				if(inactiveHeaderRenderers.length === 0)
				{
					headerRenderer = IDataGridHeaderRenderer(headerRendererFactory());
					headerRenderer.addEventListener(TouchEvent.TOUCH, headerRenderer_touchHandler);
					headerRenderer.addEventListener(Event.TRIGGERED, headerRenderer_triggeredHandler);
					if(customHeaderRendererStyleName !== null && customHeaderRendererStyleName.length > 0)
					{
						headerRenderer.styleNameList.add(customHeaderRendererStyleName);
					}
					this._headerGroup.addChild(DisplayObject(headerRenderer));
				}
				else
				{
					headerRenderer = inactiveHeaderRenderers.shift();
				}
			}
			while(headerRenderer === null)
			headerRenderer.data = column;
			headerRenderer.columnIndex = columnIndex;
			headerRenderer.owner = this;

			this._headerRendererMap[column] = headerRenderer;
			activeHeaderRenderers[activeHeaderRenderers.length] = headerRenderer;
			this.dispatchEventWith(FeathersEventType.RENDERER_ADD, false, headerRenderer);

			column.addEventListener(Event.CHANGE, column_changeHandler);

			return headerRenderer;
		}

		/**
		 * @private
		 */
		protected function destroyHeaderRenderer(headerRenderer:IDataGridHeaderRenderer):void
		{
			if(headerRenderer.data !== null)
			{
				headerRenderer.data.removeEventListener(Event.CHANGE, column_changeHandler);
			}
			headerRenderer.removeEventListener(Event.TRIGGERED, headerRenderer_triggeredHandler);
			headerRenderer.removeEventListener(TouchEvent.TOUCH, headerRenderer_touchHandler);
			headerRenderer.owner = null;
			headerRenderer.data = null;
			headerRenderer.columnIndex = -1;
			this._headerGroup.removeChild(DisplayObject(headerRenderer), true);
		}

		/**
		 * @private
		 */
		protected function refreshDataViewPortProperties():void
		{
			this.dataViewPort.isSelectable = this._isSelectable;
			this.dataViewPort.allowMultipleSelection = this._allowMultipleSelection;
			this.dataViewPort.selectedIndices = this._selectedIndices;
			this.dataViewPort.dataProvider = this._dataProvider;
			this.dataViewPort.columns = this._columns;
			this.dataViewPort.typicalItem = this._typicalItem;
			this.dataViewPort.layout = this._layout;
			this.dataViewPort.customColumnSizes = this._customColumnSizes;
		}

		/**
		 * @private
		 */
		override protected function handlePendingScroll():void
		{
			if(this.pendingItemIndex >= 0)
			{
				var item:Object = null;
				if(this._dataProvider !== null)
				{
					item = this._dataProvider.getItemAt(this.pendingItemIndex);
				}
				if(item is Object)
				{
					var point:Point = Pool.getPoint();
					this.dataViewPort.getScrollPositionForIndex(this.pendingItemIndex, point);
					this.pendingItemIndex = -1;

					var targetHorizontalScrollPosition:Number = point.x;
					var targetVerticalScrollPosition:Number = point.y;
					Pool.putPoint(point);
					if(targetHorizontalScrollPosition < this._minHorizontalScrollPosition)
					{
						targetHorizontalScrollPosition = this._minHorizontalScrollPosition;
					}
					else if(targetHorizontalScrollPosition > this._maxHorizontalScrollPosition)
					{
						targetHorizontalScrollPosition = this._maxHorizontalScrollPosition;
					}
					if(targetVerticalScrollPosition < this._minVerticalScrollPosition)
					{
						targetVerticalScrollPosition = this._minVerticalScrollPosition;
					}
					else if(targetVerticalScrollPosition > this._maxVerticalScrollPosition)
					{
						targetVerticalScrollPosition = this._maxVerticalScrollPosition;
					}
					this.throwTo(targetHorizontalScrollPosition, targetVerticalScrollPosition, this.pendingScrollDuration);
				}
			}
			super.handlePendingScroll();
		}

		/**
		 * @private
		 */
		protected function column_changeHandler(event:Event):void
		{
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		override protected function nativeStage_keyDownHandler(event:KeyboardEvent):void
		{
			if(!this._isSelectable)
			{
				//not selectable, but should scroll
				super.nativeStage_keyDownHandler(event);
				return;
			}
			if(event.isDefaultPrevented())
			{
				return;
			}
			if(!this._dataProvider)
			{
				return;
			}
			if(this._selectedIndex !== -1 && (event.keyCode === Keyboard.SPACE ||
				((event.keyLocation === 4 || DeviceCapabilities.simulateDPad) && event.keyCode === Keyboard.ENTER)))
			{
				this.dispatchEventWith(Event.TRIGGERED, false, this.selectedItem);
			}
			if(event.keyCode === Keyboard.HOME || event.keyCode === Keyboard.END ||
				event.keyCode === Keyboard.PAGE_UP ||event.keyCode === Keyboard.PAGE_DOWN ||
				event.keyCode === Keyboard.UP ||event.keyCode === Keyboard.DOWN ||
				event.keyCode === Keyboard.LEFT ||event.keyCode === Keyboard.RIGHT)
			{
				var newIndex:int = this.dataViewPort.calculateNavigationDestination(this.selectedIndex, event.keyCode);
				if(this.selectedIndex !== newIndex)
				{
					event.preventDefault();
					this.selectedIndex = newIndex;
					var point:Point = Pool.getPoint();
					this.dataViewPort.getNearestScrollPositionForIndex(this.selectedIndex, point);
					this.scrollToPosition(point.x, point.y, this._keyScrollDuration);
					Pool.putPoint(point);
				}
			}
		}

		/**
		 * @private
		 */
		override protected function stage_gestureDirectionalTapHandler(event:TransformGestureEvent):void
		{
			if(event.isDefaultPrevented())
			{
				//something else has already handled this event
				return;
			}
			var keyCode:uint = int.MAX_VALUE;
			if(event.offsetY < 0)
			{
				keyCode = Keyboard.UP;
			}
			else if(event.offsetY > 0)
			{
				keyCode = Keyboard.DOWN;
			}
			else if(event.offsetX > 0)
			{
				keyCode = Keyboard.RIGHT;
			}
			else if(event.offsetX < 0)
			{
				keyCode = Keyboard.LEFT;
			}
			if(keyCode === int.MAX_VALUE)
			{
				return;
			}
			var newIndex:int = this.dataViewPort.calculateNavigationDestination(this.selectedIndex, keyCode);
			if(this.selectedIndex !== newIndex)
			{
				event.stopImmediatePropagation();
				//event.preventDefault();
				this.selectedIndex = newIndex;
				var point:Point = Pool.getPoint();
				this.dataViewPort.getNearestScrollPositionForIndex(this.selectedIndex, point);
				this.scrollToPosition(point.x, point.y, this._keyScrollDuration);
				Pool.putPoint(point);
			}
		}

		/**
		 * @private
		 */
		protected function columns_changeHandler(event:Event):void
		{
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected function columns_resetHandler(event:Event):void
		{
			this._updateForDataReset = true;
		}

		/**
		 * @private
		 */
		protected function columns_updateAllHandler(event:Event):void
		{
			//we're treating this similar to the RESET event because enough
			//users are treating UPDATE_ALL similarly. technically, UPDATE_ALL
			//is supposed to affect only existing items, but it's confusing when
			//new items are added and not displayed.
			this._updateForDataReset = true;
		}

		/**
		 * @private
		 */
		protected function dataProvider_changeHandler(event:Event):void
		{
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected function dataProvider_resetHandler(event:Event):void
		{
			this.horizontalScrollPosition = 0;
			this.verticalScrollPosition = 0;

			//the entire data provider was replaced. select no item.
			this._selectedIndices.removeAll();
		}

		/**
		 * @private
		 */
		protected function dataProvider_addItemHandler(event:Event, index:int):void
		{
			if(this._selectedIndex == -1)
			{
				return;
			}
			var selectionChanged:Boolean = false;
			var newIndices:Vector.<int> = new <int>[];
			var indexCount:int = this._selectedIndices.length;
			for(var i:int = 0; i < indexCount; i++)
			{
				var currentIndex:int = this._selectedIndices.getItemAt(i) as int;
				if(currentIndex >= index)
				{
					currentIndex++;
					selectionChanged = true;
				}
				newIndices.push(currentIndex);
			}
			if(selectionChanged)
			{
				this._selectedIndices.data = newIndices;
			}
		}

		/**
		 * @private
		 */
		protected function dataProvider_removeAllHandler(event:Event):void
		{
			this.selectedIndex = -1;
		}

		/**
		 * @private
		 */
		protected function dataProvider_removeItemHandler(event:Event, index:int):void
		{
			if(this._selectedIndex == -1)
			{
				return;
			}
			var selectionChanged:Boolean = false;
			var newIndices:Vector.<int> = new <int>[];
			var indexCount:int = this._selectedIndices.length;
			for(var i:int = 0; i < indexCount; i++)
			{
				var currentIndex:int = this._selectedIndices.getItemAt(i) as int;
				if(currentIndex == index)
				{
					selectionChanged = true;
				}
				else
				{
					if(currentIndex > index)
					{
						currentIndex--;
						selectionChanged = true;
					}
					newIndices.push(currentIndex);
				}
			}
			if(selectionChanged)
			{
				this._selectedIndices.data = newIndices;
			}
		}

		/**
		 * @private
		 */
		protected function dataProvider_sortChangeHandler(event:Event):void
		{
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected function dataProvider_filterChangeHandler(event:Event):void
		{
			if(this._selectedIndex === -1)
			{
				return;
			}
			var selectionChanged:Boolean = false;
			var newIndices:Vector.<int> = new <int>[];
			var pushIndex:int = 0;
			var count:int = this._selectedItems.length;
			for(var i:int = 0; i < count; i++)
			{
				var selectedItem:Object = this._selectedItems[i];
				var oldIndex:int = this._selectedIndices.getItemAt(i) as int;
				var newIndex:int = this._dataProvider.getItemIndex(selectedItem);
				if(newIndex >= 0)
				{
					if(newIndex !== oldIndex)
					{
						//the item was not filtered, but it moved to a new index
						selectionChanged = true;
					}
					newIndices[pushIndex] = newIndex;
					pushIndex++;
				}
				else
				{
					//the item is filtered, so it should not be selected
					selectionChanged = true;
				}
			}
			if(selectionChanged)
			{
				this._selectedIndices.data = newIndices;
			}
		}

		/**
		 * @private
		 */
		protected function dataProvider_replaceItemHandler(event:Event, index:int):void
		{
			if(this._selectedIndex == -1)
			{
				return;
			}
			var indexOfIndex:int = this._selectedIndices.getItemIndex(index);
			if(indexOfIndex >= 0)
			{
				this._selectedIndices.removeItemAt(indexOfIndex);
			}
		}

		/**
		 * @private
		 */
		protected function selectedIndices_changeHandler(event:Event):void
		{
			this.getSelectedItems(this._selectedItems);
			if(this._selectedIndices.length > 0)
			{
				this._selectedIndex = this._selectedIndices.getItemAt(0) as int;
			}
			else
			{
				if(this._selectedIndex < 0)
				{
					//no change
					return;
				}
				this._selectedIndex = -1;
			}
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected function layout_scrollHandler(event:Event, scrollOffset:Point):void
		{
			var layout:IVariableVirtualLayout = IVariableVirtualLayout(this._layout);
			if(!this.isScrolling || !layout.useVirtualLayout || !layout.hasVariableItemDimensions)
			{
				return;
			}

			var scrollOffsetX:Number = scrollOffset.x;
			this._startHorizontalScrollPosition += scrollOffsetX;
			this._horizontalScrollPosition += scrollOffsetX;
			if(this._horizontalAutoScrollTween)
			{
				this._targetHorizontalScrollPosition += scrollOffsetX;
				this.throwTo(this._targetHorizontalScrollPosition, NaN, this._horizontalAutoScrollTween.totalTime - this._horizontalAutoScrollTween.currentTime);
			}

			var scrollOffsetY:Number = scrollOffset.y;
			this._startVerticalScrollPosition += scrollOffsetY;
			this._verticalScrollPosition += scrollOffsetY;
			if(this._verticalAutoScrollTween)
			{
				this._targetVerticalScrollPosition += scrollOffsetY;
				this.throwTo(NaN, this._targetVerticalScrollPosition, this._verticalAutoScrollTween.totalTime - this._verticalAutoScrollTween.currentTime);
			}
		}

		/**
		 * @private
		 */
		protected function headerRenderer_triggeredHandler(event:Event):void
		{
			var headerRenderer:IDataGridHeaderRenderer = IDataGridHeaderRenderer(event.currentTarget);
			var column:DataGridColumn = headerRenderer.data;
			if(!this._sortableColumns || column.sortOrder === SortOrder.NONE)
			{
				return;
			}
			if(this._sortedColumn !== column)
			{
				this._sortedColumn = column;
				this._reverseSort = column.sortOrder === SortOrder.DESCENDING;
			}
			else
			{
				this._reverseSort = !this._reverseSort;
			}
			if(this._reverseSort)
			{
				this._dataProvider.sortCompareFunction = this.reverseSortCompareFunction;
			}
			else
			{
				this._dataProvider.sortCompareFunction = this.sortCompareFunction;
			}
			//the sortCompareFunction might not have changed if we're sorting a
			//different column, so force a refresh.
			this._dataProvider.refresh();
		}

		/**
		 * @private
		 */
		protected var _reverseSort:Boolean = false;

		/**
		 * @private
		 */
		protected var _sortedColumn:DataGridColumn = null;

		/**
		 * @private
		 */
		protected function reverseSortCompareFunction(a:Object, b:Object):int
		{
			return -this.sortCompareFunction(a, b);
		}

		/**
		 * @private
		 */
		protected function sortCompareFunction(a:Object, b:Object):int
		{
			var aField:Object = a[this._sortedColumn.dataField];
			var bField:Object = b[this._sortedColumn.dataField];
			var sortCompareFunction:Function = this._sortedColumn.sortCompareFunction;
			if(sortCompareFunction === null)
			{
				sortCompareFunction = defaultSortCompareFunction;
			}
			return sortCompareFunction(aField, bField);
		}

		/**
		 * @private
		 */
		protected function dataGrid_touchHandler(event:TouchEvent):void
		{
			if(this._headerTouchID !== -1)
			{
				//a touch has begun, so we'll ignore all other touches.
				var touch:Touch = event.getTouch(this, null, this._headerTouchID);
				if(touch === null)
				{
					//this should not happen.
					return;
				}

				if(touch.phase === TouchPhase.ENDED)
				{
					this.removeEventListener(TouchEvent.TOUCH, dataGrid_touchHandler);
					//these might be null if there was no TouchPhase.MOVED
					if(this._currentColumnDropIndicatorSkin !== null)
					{
						this._currentColumnDropIndicatorSkin.removeFromParent(this._currentColumnDropIndicatorSkin !== this._columnDropIndicatorSkin);
						this._currentColumnDropIndicatorSkin = null;
					}
					if(this._currentColumnDragOverlaySkin !== null)
					{
						this._currentColumnDragOverlaySkin.removeFromParent(this._currentColumnDragOverlaySkin !== this._columnDragOverlaySkin);
						this._currentColumnDragOverlaySkin = null;
					}
					this._headerTouchID = -1;
				}
			}
		}

		/**
		 * @private
		 */
		protected function headerRenderer_touchHandler(event:TouchEvent):void
		{
			var headerRenderer:IDataGridHeaderRenderer = IDataGridHeaderRenderer(event.currentTarget);
			if(!this._isEnabled)
			{
				this._headerTouchID = -1;
				return;
			}
			if(this._headerTouchID !== -1)
			{
				//a touch has begun, so we'll ignore all other touches.
				var touch:Touch = event.getTouch(DisplayObject(headerRenderer), null, this._headerTouchID);
				if(touch === null)
				{
					//this should not happen.
					return;
				}

				if(touch.phase === TouchPhase.MOVED)
				{
					if(!DragDropManager.isDragging && this._reorderColumns)
					{
						var column:DataGridColumn = DataGridColumn(this._columns.getItemAt(headerRenderer.columnIndex));
						var dragData:DragData = new DragData();
						dragData.setDataForFormat(DATA_GRID_HEADER_DRAG_FORMAT, column);
						var self:DataGrid = this;
						var avatar:RenderDelegate = new RenderDelegate(DisplayObject(headerRenderer));
						avatar.alpha = this._columnDragAvatarAlpha;
						DragDropManager.startDrag(this, touch, dragData, avatar);
						if(this._columnDropIndicatorSkin === null)
						{
							this._currentColumnDropIndicatorSkin = new Quad(1, 1, 0x000000);
						}
						if(this._columnDropIndicatorSkin !== null)
						{
							this._currentColumnDropIndicatorSkin = this._columnDropIndicatorSkin;
						}
						//start out invisible and TouchPhase.MOVED will reveal it, if necessary
						this._currentColumnDropIndicatorSkin.visible = false;
						this.addChild(this._currentColumnDropIndicatorSkin);

						if(this._columnDragOverlaySkin === null)
						{
							this._currentColumnDragOverlaySkin = new Quad(1, 1, 0xff00ff);
							this._currentColumnDragOverlaySkin.alpha = 0;
						}
						else
						{
							this._currentColumnDragOverlaySkin = this._columnDragOverlaySkin;
						}
						this._currentColumnDragOverlaySkin.x = this._headerGroup.x + headerRenderer.x;
						this._currentColumnDragOverlaySkin.y = this._headerGroup.y + headerRenderer.y;
						this._currentColumnDragOverlaySkin.width = headerRenderer.width;
						this._currentColumnDragOverlaySkin.height = this._viewPort.y + this._viewPort.visibleHeight - this._headerGroup.y;
						this.addChild(this._currentColumnDragOverlaySkin);
					}
				}
			}
			else if(!DragDropManager.isDragging && this._reorderColumns)
			{
				//we aren't tracking another touch, so let's look for a new one.
				touch = event.getTouch(DisplayObject(headerRenderer), TouchPhase.BEGAN);
				if(touch === null)
				{
					//we only care about the began phase. ignore all other
					//phases when we don't have a saved touch ID.
					return;
				}
				this._headerTouchID = touch.id;
				this._headerTouchX = touch.globalX;
				this._headerTouchY = touch.globalX;
				this._draggedHeaderIndex = headerRenderer.columnIndex;
				//we want to check for TouchPhase.ENDED after it's bubbled
				//beyond the header renderer
				this.addEventListener(TouchEvent.TOUCH, dataGrid_touchHandler);
			}
		}

		/**
		 * @private
		 */
		protected function getHeaderDropIndex(globalX:Number):int
		{
			var headerCount:int = this._headerGroup.numChildren;
			for(var i:int = 0; i < headerCount; i++)
			{
				var header:IDataGridHeaderRenderer = IDataGridHeaderRenderer(this._headerGroup.getChildAt(i));
				var point:Point = Pool.getPoint(header.width / 2, 0);
				header.localToGlobal(point, point);
				var headerGlobalMiddleX:Number = point.x;
				Pool.putPoint(point);
				if(globalX < headerGlobalMiddleX)
				{
					return i;
				}
			}
			return headerCount;
		}

		/**
		 * @private
		 */
		protected function dataGrid_dragEnterHandler(event:DragDropEvent):void
		{
			if(DragDropManager.dragSource !== this || !event.dragData.hasDataForFormat(DATA_GRID_HEADER_DRAG_FORMAT))
			{
				return;
			}
			DragDropManager.acceptDrag(this);
		}

		/**
		 * @private
		 */
		protected function dataGrid_dragMoveHandler(event:DragDropEvent):void
		{
			if(DragDropManager.dragSource !== this || !event.dragData.hasDataForFormat(DATA_GRID_HEADER_DRAG_FORMAT))
			{
				return;
			}
			var point:Point = Pool.getPoint(event.localX, event.localY);
			this.localToGlobal(point, point);
			var globalDropX:Number = point.x;
			Pool.putPoint(point);
			var dropIndex:int = this.getHeaderDropIndex(globalDropX);
			var showDropIndicator:Boolean = dropIndex !== this._draggedHeaderIndex &&
				dropIndex !== (this._draggedHeaderIndex + 1);
			this._currentColumnDropIndicatorSkin.visible = showDropIndicator;
			if(!showDropIndicator)
			{
				return;
			}
			if(this._extendedColumnDropIndicator)
			{
				this._currentColumnDropIndicatorSkin.height = this._headerGroup.height + this._viewPort.visibleHeight;
			}
			else
			{
				this._currentColumnDropIndicatorSkin.height = this._headerGroup.height;
			}
			if(this._currentColumnDropIndicatorSkin is IValidating)
			{
				IValidating(this._currentColumnDropIndicatorSkin).validate();
			}
			var dropIndicatorX:Number = 0;
			if(dropIndex === this._columns.length)
			{
				var header:DisplayObject = this._headerGroup.getChildAt(dropIndex - 1);
				dropIndicatorX = header.x + header.width;
			}
			else
			{
				header = this._headerGroup.getChildAt(dropIndex);
				dropIndicatorX = header.x;
			}
			this._currentColumnDropIndicatorSkin.x = this._headerGroup.x + dropIndicatorX - (this._currentColumnDropIndicatorSkin.width / 2);
			this._currentColumnDropIndicatorSkin.y = this._headerGroup.y;
		}

		/**
		 * @private
		 */
		protected function dataGrid_dragDropHandler(event:DragDropEvent):void
		{
			if(DragDropManager.dragSource !== this || !event.dragData.hasDataForFormat(DATA_GRID_HEADER_DRAG_FORMAT))
			{
				return;
			}
			var point:Point = Pool.getPoint(event.localX, event.localY);
			this.localToGlobal(point, point);
			var globalDropX:Number = point.x;
			Pool.putPoint(point);
			var dropIndex:int = this.getHeaderDropIndex(globalDropX);
			if(dropIndex === this._draggedHeaderIndex ||
				(dropIndex === (this._draggedHeaderIndex + 1)))
			{
				//it's the same position, so do nothing
				return;
			}
			if(dropIndex > this._draggedHeaderIndex)
			{
				dropIndex--;
			}
			var column:DataGridColumn = DataGridColumn(this._columns.removeItemAt(this._draggedHeaderIndex));
			this._columns.addItemAt(column, dropIndex);
		}

		/**
		 * @private
		 */
		protected function headerDivider_touchHandler(event:TouchEvent):void
		{
			var divider:DisplayObject = DisplayObject(event.currentTarget);
			if(!this._isEnabled)
			{
				this._headerDividerTouchID = -1;
				return;
			}
			var dividerIndex:int = this._headerDividerStorage.activeDividers.indexOf(divider);
			if(dividerIndex === (this._headerDividerStorage.activeDividers.length - 1) &&
				this._scrollBarDisplayMode === ScrollBarDisplayMode.FIXED &&
					this._minVerticalScrollPosition !== this._maxVerticalScrollPosition)
			{
				//no resizing!
				return;
			}
			if(this._headerDividerTouchID !== -1)
			{
				//a touch has begun, so we'll ignore all other touches.
				var touch:Touch = event.getTouch(divider, null, this._headerDividerTouchID);
				if(touch === null)
				{
					//this should not happen.
					return;
				}

				if(touch.phase === TouchPhase.ENDED)
				{
					this.calculateResizedColumnWidth();
					this._resizingColumnIndex = -1;

					this._currentColumnResizeSkin.removeFromParent(this._currentColumnResizeSkin !== this._columnResizeSkin);
					this._currentColumnResizeSkin = null;
					this._headerDividerTouchID = -1;
				}
				else if(touch.phase === TouchPhase.MOVED)
				{
					var column:DataGridColumn = DataGridColumn(this._columns.getItemAt(this._resizingColumnIndex));
					var headerRenderer:IDataGridHeaderRenderer = IDataGridHeaderRenderer(this._headerGroup.getChildAt(this._resizingColumnIndex));
					var minX:Number = headerRenderer.x + column.minWidth;
					var maxX:Number = this.actualWidth - this._currentColumnResizeSkin.width - this._rightViewPortOffset;
					var difference:Number = touch.globalX - this._headerDividerTouchX;
					var newX:Number = divider.x + (divider.width / 2) - (this._currentColumnResizeSkin.width / 2) + difference;
					if(newX < minX)
					{
						newX = minX;
					}
					else if(newX > maxX)
					{
						newX = maxX;
					}
					this._currentColumnResizeSkin.x = newX;
					this._currentColumnResizeSkin.y = this._headerGroup.y;
					this._currentColumnResizeSkin.height = this.actualHeight - this._bottomViewPortOffset - this._currentColumnResizeSkin.y;
				}
			}
			else if(this._resizableColumns)
			{
				//we aren't tracking another touch, so let's look for a new one.
				touch = event.getTouch(divider, TouchPhase.BEGAN);
				if(touch === null)
				{
					return;
				}
				column = DataGridColumn(this._columns.getItemAt(dividerIndex));
				if(!column.resizable)
				{
					return;
				}
				this._resizingColumnIndex = dividerIndex;
				this._headerDividerTouchID = touch.id;
				this._headerDividerTouchX = touch.globalX;
				headerRenderer = IDataGridHeaderRenderer(this._headerGroup.getChildAt(dividerIndex));
				if(this._columnResizeSkin === null)
				{
					this._currentColumnResizeSkin = new Quad(1, 1, 0x000000);
				}
				else
				{
					this._currentColumnResizeSkin = this._columnResizeSkin;
				}
				this._currentColumnResizeSkin.height = this.actualHeight;
				this.addChild(this._currentColumnResizeSkin);
				if(this._currentColumnResizeSkin is IValidating)
				{
					IValidating(this._currentColumnResizeSkin).validate();
				}
				this._currentColumnResizeSkin.x = divider.x + (divider.width / 2) - (this._currentColumnResizeSkin.width / 2);
			}
		}

		/**
		 * @private
		 */
		protected function calculateResizedColumnWidth():void
		{
			var columnCount:int = this._columns.length;
			if(this._customColumnSizes === null)
			{
				this._customColumnSizes = new Vector.<Number>(columnCount);
			}
			else
			{
				//make a copy so that it will be detected as a change
				this._customColumnSizes = this._customColumnSizes.slice();
				//try to keep any column widths we already saved
				this._customColumnSizes.length = columnCount;
			}
			var column:DataGridColumn = DataGridColumn(this._columns.getItemAt(this._resizingColumnIndex));
			//clear the explicit width because the user resized it
			column.width = NaN;
			var headerRenderer:IDataGridHeaderRenderer = IDataGridHeaderRenderer(this._headerGroup.getChildAt(this._resizingColumnIndex));
			var preferredWidth:Number = this._currentColumnResizeSkin.x + (this._currentColumnResizeSkin.width / 2) - headerRenderer.x;
			var totalMinWidth:Number = 0;
			var originalWidth:Number = headerRenderer.width;
			var totalWidthAfter:Number = 0;
			var indicesAfter:Vector.<int> = new <int>[];
			for(var i:int = 0; i < columnCount; i++)
			{
				var currentColumn:DataGridColumn = DataGridColumn(this._columns.getItemAt(i));
				if(i === this._resizingColumnIndex)
				{
					continue;
				}
				else if(i < this._resizingColumnIndex)
				{
					//we want these columns to maintain their width so that the
					//resized one will start at the same x position
					//however, we're not setting the width property on the
					//DataGridColumn because we want them to be able to resize
					//later if the whole DataGrid resizes.
					headerRenderer = IDataGridHeaderRenderer(this._headerGroup.getChildAt(i));
					this._customColumnSizes[i] = headerRenderer.width;
					totalMinWidth += headerRenderer.width;
				}
				else
				{
					if(currentColumn.width === currentColumn.width) //!isNaN
					{
						totalMinWidth += currentColumn.width;
						continue;
					}
					else
					{
						totalMinWidth += currentColumn.minWidth;
					}
					headerRenderer = IDataGridHeaderRenderer(this._headerGroup.getChildAt(i));
					var columnWidth:Number = headerRenderer.width;
					totalWidthAfter += columnWidth;
					this._customColumnSizes[i] = columnWidth;
					indicesAfter[indicesAfter.length] = i;
				}
			}
			if(indicesAfter.length === 0)
			{
				//if all of the columns after the resizing one have explicit
				//widths, we need to force one to be resized
				var index:int = this._resizingColumnIndex + 1;
				indicesAfter[0] = index;
				column = DataGridColumn(this._columns.getItemAt(index));
				totalWidthAfter = column.width;
				totalMinWidth -= totalWidthAfter;
				totalMinWidth += column.minWidth;
				this._customColumnSizes[index] = totalWidthAfter;
				column.width = NaN;
			}
			var newWidth:Number = preferredWidth;
			var maxWidth:Number = this._headerGroup.width - totalMinWidth - this._leftViewPortOffset - this._rightViewPortOffset;
			if(newWidth > maxWidth)
			{
				newWidth = maxWidth;
			}
			if(newWidth < column.minWidth)
			{
				newWidth = column.minWidth;
			}
			this._customColumnSizes[this._resizingColumnIndex] = newWidth;

			//the width to distribute may be positive or negative, depending on
			//whether the resized column was made smaller or larger
			var widthToDistribute:Number = originalWidth - newWidth;
			this.distributeWidthToIndices(widthToDistribute, indicesAfter, totalWidthAfter);
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
		}
	}
}

import feathers.controls.renderers.IDataGridHeaderRenderer;

import starling.display.DisplayObject;

class HeaderRendererFactoryStorage
{
	public var activeHeaderRenderers:Vector.<IDataGridHeaderRenderer> = new <IDataGridHeaderRenderer>[];
	public var inactiveHeaderRenderers:Vector.<IDataGridHeaderRenderer> = new <IDataGridHeaderRenderer>[];
	public var factory:Function = null;
	public var customHeaderRendererStyleName:String = null;
	public var columnIndex:int = -1;
}

class DividerFactoryStorage
{
	public var activeDividers:Vector.<DisplayObject> = new <DisplayObject>[];
	public var inactiveDividers:Vector.<DisplayObject> = new <DisplayObject>[];
	public var factory:Function = null;
}