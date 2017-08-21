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
	import feathers.controls.renderers.IDataGridHeaderRenderer;
	import feathers.controls.supportClasses.DataGridDataViewPort;
	import feathers.core.IValidating;
	import feathers.data.IListCollection;
	import feathers.data.ListCollection;
	import feathers.display.RenderDelegate;
	import feathers.dragDrop.DragData;
	import feathers.dragDrop.DragDropManager;
	import feathers.dragDrop.IDragSource;
	import feathers.dragDrop.IDropTarget;
	import feathers.events.CollectionEventType;
	import feathers.events.DragDropEvent;
	import feathers.events.FeathersEventType;
	import feathers.layout.FlowLayout;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.HorizontalLayoutData;
	import feathers.layout.ILayout;
	import feathers.layout.ISpinnerLayout;
	import feathers.layout.IVariableVirtualLayout;
	import feathers.layout.VerticalLayout;
	import feathers.skins.IStyleProvider;
	import feathers.system.DeviceCapabilities;

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

	/**
	 * Determines if the height of the header drag indicator is equal to the
	 * height of the headers, or if it extends to the full height of the data
	 * grid's view port.
	 *
	 * <p>In the following example, the data grid's header drag indicator is extended:</p>
	 *
	 * <listing version="3.0">
	 * grid.extendedHeaderDragIndicator = true;</listing>
	 *
	 * @default false
	 */
	[Style(name="extendedHeaderDragIndicator",type="Boolean")]

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
	 * The alpha value used for the header's drag avatar.
	 *
	 * <p>In the following example, the data grid's header drag avatar alpha value is customized:</p>
	 *
	 * <listing version="3.0">
	 * grid.headerDragAvatarAlpha = 0.5;</listing>
	 *
	 * @default 0.8
	 * 
	 * @see #reorderColumns
	 */
	[Style(name="headerDragAvatarAlpha",type="Number")]

	/**
	 * A skin to display when dragging one of the data grid's headers to
	 * highlight the column where it was orignally located.
	 *
	 * <p>In the following example, the data grid's column overlay skin is provided:</p>
	 *
	 * <listing version="3.0">
	 * var skin:Quad = new Quad(1, 1, 0x999999);
	 * skin.alpha = 0.5;
	 * grid.headerDragColumnOverlaySkin = skin;</listing>
	 *
	 * @default null
	 * 
	 * @see #reorderColumns
	 */
	[Style(name="headerDragColumnOverlaySkin",type="starling.display.DisplayObject")]

	/**
	 * A skin to display when dragging one of the data grid's headers to indicate where
	 * it can be dropped.
	 *
	 * <p>In the following example, the data grid's header drag indicator is provided:</p>
	 *
	 * <listing version="3.0">
	 * grid.headerDragIndicatorSkin = new Image( texture );</listing>
	 *
	 * @default null
	 * 
	 * @see #reorderColumns
	 */
	[Style(name="headerDragIndicatorSkin",type="starling.display.DisplayObject")]

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
	 * 
	 * @productversion Feathers 3.4.0
	 */
	public class DataGrid extends Scroller implements IDragSource, IDropTarget
	{
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
		 * <p>The following example enables colum reordering:</p>
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
		protected var _headerDragIndicatorSkin:DisplayObject = null;

		/**
		 * @private
		 */
		public function get headerDragIndicatorSkin():DisplayObject
		{
			return this._headerDragIndicatorSkin;
		}

		/**
		 * @private
		 */
		public function set headerDragIndicatorSkin(value:DisplayObject):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				if(value !== null)
				{
					value.dispose();
				}
				return;
			}
			this._headerDragIndicatorSkin = value;
		}

		/**
		 * @private
		 */
		protected var _headerDragColumnOverlaySkin:DisplayObject = null;

		/**
		 * @private
		 */
		public function get headerDragColumnOverlaySkin():DisplayObject
		{
			return this._headerDragColumnOverlaySkin;
		}

		/**
		 * @private
		 */
		public function set headerDragColumnOverlaySkin(value:DisplayObject):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				if(value !== null)
				{
					value.dispose();
				}
				return;
			}
			this._headerDragColumnOverlaySkin = value;
		}

		/**
		 * @private
		 */
		protected var _headerDragAvatarAlpha:Number = 0.8;

		/**
		 * @private
		 */
		public function get headerDragAvatarAlpha():Number
		{
			return this._headerDragAvatarAlpha;
		}

		/**
		 * @private
		 */
		public function set headerDragAvatarAlpha(value:Number):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			this._headerDragAvatarAlpha = value;
		}

		/**
		 * @private
		 */
		protected var _extendedHeaderDragIndicator:Boolean = false;

		/**
		 * @private
		 */
		public function get extendedHeaderDragIndicator():Boolean
		{
			return this._extendedHeaderDragIndicator;
		}

		/**
		 * @private
		 */
		public function set extendedHeaderDragIndicator(value:Boolean):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			this._extendedHeaderDragIndicator = value;
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
		 * 
		 *
		 * @default null
		 * 
		 * @see #dataProvider
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
			if(this._headerDragIndicatorSkin !== null &&
				this._headerDragIndicatorSkin.parent === null)
			{
				this._headerDragIndicatorSkin.dispose();
				this._headerDragIndicatorSkin = null;
			}
			if(this._headerDragColumnOverlaySkin !== null &&
				this._headerDragColumnOverlaySkin.parent === null)
			{
				this._headerDragColumnOverlaySkin.dispose();
				this._headerDragColumnOverlaySkin = null;
			}
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

			if(this._headerLayout === null)
			{
				this._headerLayout = new HorizontalLayout();
			}

			if(this._headerGroup === null)
			{
				this._headerGroup = new LayoutGroup();
				this.addChild(this._headerGroup);
			}

			this._headerGroup.layout = this._headerLayout;

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

			this.refreshHeaderRenderers();
			this.refreshDataViewPortProperties();
			super.draw();
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
			this._headerLayout.paddingRight = this._rightViewPortOffset;
			this._headerGroup.width = this.actualWidth;
			this._headerGroup.validate();
			this._headerGroup.x = 0;
			this._headerGroup.y = this._topViewPortOffset - this._headerGroup.height;

			super.layoutChildren();
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
			var columnCount:int = 0;
			if(this._columns !== null)
			{
				columnCount = this._columns.length;
			}

			var unrenderedDataLastIndex:int = this._unrenderedHeaders.length;
			for(var i:int = 0; i < columnCount; i++)
			{
				var column:DataGridColumn = DataGridColumn(this._columns.getItemAt(i));
				var headerRenderer:IDataGridHeaderRenderer = this._headerRendererMap[column] as IDataGridHeaderRenderer;
				if(headerRenderer !== null)
				{
					headerRenderer.columnIndex = i;
					if(column.width === column.width) //!isNaN
					{
						headerRenderer.width = column.width;
						headerRenderer.layoutData = null;
					}
					else if(headerRenderer.layoutData === null)
					{
						headerRenderer.layoutData = new HorizontalLayoutData(100);
					}
					headerRenderer.minWidth = column.minWidth;
					headerRenderer.visible = true;
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
			var customHeaderRendererStyleName:String = column.customHeaderRendererStyleName;
			var inactiveHeaderRenderers:Vector.<IDataGridHeaderRenderer> = this._headerStorage.inactiveHeaderRenderers;
			var activeHeaderRenderers:Vector.<IDataGridHeaderRenderer> = this._headerStorage.activeHeaderRenderers;
			var headerRenderer:IDataGridHeaderRenderer;
			do
			{
				if(inactiveHeaderRenderers.length === 0)
				{
					headerRenderer = IDataGridHeaderRenderer(headerRendererFactory());
					headerRenderer.addEventListener(TouchEvent.TOUCH, headerRenderer_touchHandler);
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
			while(!headerRenderer)
			headerRenderer.data = column;
			headerRenderer.columnIndex = columnIndex;
			headerRenderer.owner = this;
			if(column.width === column.width) //!isNaN
			{
				headerRenderer.width = column.width;
				headerRenderer.layoutData = null;
			}
			else if(headerRenderer.layoutData === null)
			{
				headerRenderer.layoutData = new HorizontalLayoutData(100);
			}
			headerRenderer.minWidth = column.minWidth;

			this._headerRendererMap[column] = headerRenderer;
			activeHeaderRenderers[activeHeaderRenderers.length] = headerRenderer;
			this.dispatchEventWith(FeathersEventType.RENDERER_ADD, false, headerRenderer);

			return headerRenderer;
		}

		/**
		 * @private
		 */
		protected function destroyHeaderRenderer(headerRenderer:IDataGridHeaderRenderer):void
		{
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

				if(touch.phase === TouchPhase.ENDED)
				{
					if(this._headerDragIndicatorSkin !== null &&
						this._headerDragIndicatorSkin.parent !== null)
					{
						this._headerDragIndicatorSkin.removeFromParent(false);
					}
					if(this._headerDragColumnOverlaySkin !== null &&
						this._headerDragColumnOverlaySkin.parent !== null)
					{
						this._headerDragColumnOverlaySkin.removeFromParent(false);
					}
					this._headerTouchID = -1;
				}
				else if(touch.phase === TouchPhase.MOVED)
				{
					if(!DragDropManager.isDragging && this._reorderColumns)
					{
						var column:DataGridColumn = DataGridColumn(this._columns.getItemAt(headerRenderer.columnIndex));
						var dragData:DragData = new DragData();
						dragData.setDataForFormat(DATA_GRID_HEADER_DRAG_FORMAT, column);
						var self:DataGrid = this;
						var avatar:RenderDelegate = new RenderDelegate(DisplayObject(headerRenderer));
						avatar.alpha = this._headerDragAvatarAlpha;
						DragDropManager.startDrag(this, touch, dragData, avatar);

						if(this._headerDragColumnOverlaySkin !== null)
						{
							this._headerDragColumnOverlaySkin.x = this._headerGroup.x + headerRenderer.x;
							this._headerDragColumnOverlaySkin.y = this._headerGroup.y + headerRenderer.y;
							this._headerDragColumnOverlaySkin.width = headerRenderer.width;
							this._headerDragColumnOverlaySkin.height = this._viewPort.y + this._viewPort.visibleHeight - this._headerGroup.y;
							this.addChild(this._headerDragColumnOverlaySkin);
						}
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
			var showDragIndicator:Boolean = dropIndex !== this._draggedHeaderIndex &&
				dropIndex !== (this._draggedHeaderIndex + 1);
			if(this._headerDragIndicatorSkin !== null)
			{
				this._headerDragIndicatorSkin.visible = showDragIndicator;
				if(showDragIndicator)
				{
					if(this._headerDragIndicatorSkin.parent === null)
					{
						this.addChild(this._headerDragIndicatorSkin);
					}
					if(this._extendedHeaderDragIndicator)
					{
						this._headerDragIndicatorSkin.height = this._headerGroup.height + this._viewPort.visibleHeight;
					}
					else
					{
						this._headerDragIndicatorSkin.height = this._headerGroup.height;
					}
					if(this._headerDragIndicatorSkin is IValidating)
					{
						IValidating(this._headerDragIndicatorSkin).validate();
					}
					var dragIndicatorX:Number = 0;
					if(dropIndex === this._columns.length)
					{
						var header:DisplayObject = this._headerGroup.getChildAt(dropIndex - 1);
						dragIndicatorX = header.x + header.width;
					}
					else
					{
						header = this._headerGroup.getChildAt(dropIndex);
						dragIndicatorX = header.x;
					}
					this._headerDragIndicatorSkin.x = this._headerGroup.x + dragIndicatorX - (this._headerDragIndicatorSkin.width / 2);
					this._headerDragIndicatorSkin.y = this._headerGroup.y;
				}
			}
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
	}
}

import feathers.controls.renderers.IDataGridHeaderRenderer;

class HeaderRendererFactoryStorage
{
	public function HeaderRendererFactoryStorage()
	{

	}
	
	public var activeHeaderRenderers:Vector.<IDataGridHeaderRenderer> = new <IDataGridHeaderRenderer>[];
	public var inactiveHeaderRenderers:Vector.<IDataGridHeaderRenderer> = new <IDataGridHeaderRenderer>[];
	public var factory:Function = null;
	public var customHeaderRendererStyleName:String = null;
	public var columnIndex:int = -1;
}