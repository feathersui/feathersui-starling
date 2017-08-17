/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.supportClasses
{
	import feathers.controls.BasicButton;
	import feathers.controls.DataGrid;
	import feathers.controls.DataGridColumn;
	import feathers.controls.LayoutGroup;
	import feathers.controls.List;
	import feathers.controls.renderers.IDataGridCellRenderer;
	import feathers.core.FeathersControl;
	import feathers.core.IFeathersControl;
	import feathers.core.IToggle;
	import feathers.data.IListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.HorizontalLayoutData;
	import feathers.layout.LayoutBoundsResult;
	import feathers.layout.VerticalAlign;
	import feathers.layout.ViewPortBounds;
	import feathers.skins.IStyleProvider;
	import feathers.utils.touch.DelayedDownTouchToState;
	import feathers.utils.touch.TapToSelect;
	import feathers.utils.touch.TapToTrigger;

	import starling.display.DisplayObject;
	import starling.events.Event;
	import flash.utils.Dictionary;
	import flash.errors.IllegalOperationError;
	import feathers.events.CollectionEventType;

	/**
	 * @private
	 * Used internally by DataGrid. Not meant to be used on its own.
	 * 
	 * @see feathers.controls.DataGrid
	 *
	 * @productversion Feathers 3.4.0
	 */
	public class DataGridRowRenderer extends LayoutGroup implements IToggle
	{
		/**
		 * Constructor.
		 */
		public function DataGridRowRenderer()
		{
			super();
		}

		/**
		 * @private
		 */
		protected var _tapToTrigger:TapToTrigger = null;

		/**
		 * @private
		 */
		protected var _tapToSelect:TapToSelect = null;

		/**
		 * @private
		 */
		protected var _unrenderedData:Vector.<int> = new <int>[];

		/**
		 * @private
		 */
		protected var _cellRendererMap:Dictionary = new Dictionary(true);

		/**
		 * @private
		 */
		protected var _inactiveCellRenderers:Vector.<IDataGridCellRenderer> = new <IDataGridCellRenderer>[];

		/**
		 * @private
		 */
		protected var _activeCellRenderers:Vector.<IDataGridCellRenderer> = new <IDataGridCellRenderer>[];

		/**
		 * @private
		 */
		protected var _index:int = -1;

		/**
		 * The index (numeric position, starting from zero) of the item within
		 * the data grid's dat provider.
		 *
		 * <p>This property is set by the data grid, and should not be set manually.</p>
		 */
		public function get index():int
		{
			return this._index;
		}

		/**
		 * @private
		 */
		public function set index(value:int):void
		{
			if(this._index === value)
			{
				return;
			}
			this._index = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _owner:DataGrid = null;

		/**
		 * The <code>DataGrid</code> component that owns this row renderer.
		 *
		 * <p>This property is set by the data grid, and should not be set manually.</p>
		 */
		public function get owner():DataGrid
		{
			return this._owner;
		}

		/**
		 * @private
		 */
		public function set owner(value:DataGrid):void
		{
			if(this._owner === value)
			{
				return;
			}
			this._owner = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _data:Object = null;

		/**
		 * The item from the data provider that is rendered by this row.
		 *
		 * <p>This property is set by the data grid, and should not be set manually.</p>
		 */
		public function get data():Object
		{
			return this._data;
		}

		/**
		 * @private
		 */
		public function set data(value:Object):void
		{
			if(this._data === value)
			{
				return;
			}
			this._data = value;
			if(value === null)
			{
				//ensure that the data property of each cell renderer
				//is set to null before being set to any new value
				this._updateForDataReset = true;
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _updateForDataReset:Boolean = false;

		/**
		 * @private
		 */
		protected var _columns:IListCollection = null;

		/**
		 * The columns from the data grid.
		 *
		 * <p>This property is set by the data grid, and should not be set manually.</p>
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
			this._updateForDataReset = true;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _isSelected:Boolean;

		/**
		 * Indicates if the row is selected or not.
		 *
		 * <p>This property is set by the data grid, and should not be set manually.</p>
		 */
		public function get isSelected():Boolean
		{
			return this._isSelected;
		}

		/**
		 * @private
		 */
		public function set isSelected(value:Boolean):void
		{
			if(this._isSelected === value)
			{
				return;
			}
			this._isSelected = value;
			this.invalidate(INVALIDATION_FLAG_SELECTED);
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * Returns the cell renderer for the specified column index, or
		 * <code>null</code>, if no cell renderer can be found.
		 */
		public function getCellRendererForColumn(columnIndex:int):IDataGridCellRenderer
		{
			if(columnIndex < 0 || columnIndex > this._activeCellRenderers.length)
			{
				return null;
			}
			return IDataGridCellRenderer(this._activeCellRenderers[columnIndex]);
		}

		/**
		 * @private
		 */
		override public function dispose():void
		{
			this.refreshInactiveCellRenderers(true);
			this.owner = null;
			this.data = null;
			this.columns = null;
			super.dispose();
		}

		/**
		 * @private
		 */
		override protected function initialize():void
		{
			super.initialize();

			if(this._layout === null)
			{
				var layout:HorizontalLayout = new HorizontalLayout();
				layout.verticalAlign = VerticalAlign.MIDDLE;
				layout.useVirtualLayout = false;
				this._layout = layout;
			}

			if(this._tapToTrigger === null)
			{
				this._tapToTrigger = new TapToTrigger(this);
			}

			if(this._tapToSelect === null)
			{
				this._tapToSelect = new TapToSelect(this);
			}
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			var oldIgnoreChildChanges:Boolean = this._ignoreChildChanges;
			this._ignoreChildChanges = true;
			this.preLayout();
			this._ignoreChildChanges = oldIgnoreChildChanges;

			super.draw();
		}

		/**
		 * @private
		 */
		protected function preLayout():void
		{
			this.refreshInactiveCellRenderers(false);
			this.findUnrenderedData();
			this.recoverInactiveCellRenderers();
			this.renderUnrenderedData();
			this.freeInactiveCellRenderers()
		}

		/**
		 * @private
		 */
		protected function createCellRenderer(columnIndex:int, column:DataGridColumn):IDataGridCellRenderer
		{
			var cellRenderer:IDataGridCellRenderer = null;
			do
			{
				if(this._inactiveCellRenderers.length === 0)
				{
					var cellRendererFactory:Function = column.cellRendererFactory;
					cellRenderer = IDataGridCellRenderer(cellRendererFactory());
					this.addChildAt(DisplayObject(cellRenderer), columnIndex);
				}
				else
				{
					cellRenderer = this._inactiveCellRenderers.shift();
				}
				//wondering why this all is in a loop?
				//_inactiveRenderers.shift() may return null because we're
				//storing null values instead of calling splice() to improve
				//performance.
			}
			while(cellRenderer === null)
			this.refreshCellRendererProperties(cellRenderer, columnIndex, column);

			this._cellRendererMap[column] = cellRenderer;
			this._activeCellRenderers[this._activeCellRenderers.length] = cellRenderer;
			this._owner.dispatchEventWith(FeathersEventType.RENDERER_ADD, false, cellRenderer);

			return cellRenderer;
		}

		/**
		 * @private
		 */
		protected function destroyCellRenderer(cellRenderer:IDataGridCellRenderer):void
		{
			cellRenderer.data = null;
			cellRenderer.owner = null;
			cellRenderer.rowIndex = -1;
			cellRenderer.columnIndex = -1;
			this.removeChild(DisplayObject(cellRenderer), true);
		}

		/**
		 * @private
		 */
		protected function refreshInactiveCellRenderers(forceCleanup:Boolean):void
		{
			var temp:Vector.<IDataGridCellRenderer> = this._inactiveCellRenderers;
			this._inactiveCellRenderers = this._activeCellRenderers;
			this._activeCellRenderers = temp;
			if(this._activeCellRenderers.length > 0)
			{
				throw new IllegalOperationError("DataGridRowRenderer: active cell renderers should be empty.");
			}
			if(forceCleanup)
			{
				this.recoverInactiveCellRenderers();
				this.freeInactiveCellRenderers()
			}
		}

		/**
		 * @private
		 */
		protected function findUnrenderedData():void
		{
			var columns:IListCollection = this._owner.columns;
			var columnCount:int = columns.length;
			var unrenderedDataLastIndex:int = this._unrenderedData.length;
			for(var i:int = 0; i < columnCount; i++)
			{
				if(i < 0 || i >= columnCount)
				{
					continue;
				}
				var column:DataGridColumn = DataGridColumn(columns.getItemAt(i));
				var cellRenderer:IDataGridCellRenderer = this._cellRendererMap[column] as IDataGridCellRenderer;
				if(cellRenderer !== null)
				{
					//the properties may have changed if items were added, removed or
					//reordered in the data provider
					this.refreshCellRendererProperties(cellRenderer, i, column);

					this._activeCellRenderers[this._activeCellRenderers.length] = cellRenderer;
					var inactiveIndex:int = this._inactiveCellRenderers.indexOf(cellRenderer);
					if(inactiveIndex >= 0)
					{
						this._inactiveCellRenderers[inactiveIndex] = null;
					}
					else
					{
						throw new IllegalOperationError("DataGridRowRenderer: cell renderer map contains bad data. This may be caused by duplicate items in the data provider, which is not allowed.");
					}
				}
				else
				{
					this._unrenderedData[unrenderedDataLastIndex] = i;
					unrenderedDataLastIndex++;
				}
			}
		}

		/**
		 * @private
		 */
		protected function recoverInactiveCellRenderers():void
		{
			var itemCount:int = this._inactiveCellRenderers.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var cellRenderer:IDataGridCellRenderer = this._inactiveCellRenderers[i];
				if(cellRenderer === null || cellRenderer.column === null)
				{
					continue;
				}
				this._owner.dispatchEventWith(FeathersEventType.RENDERER_REMOVE, false, cellRenderer);
				delete this._cellRendererMap[cellRenderer.column];
			}
		}

		/**
		 * @private
		 */
		protected function renderUnrenderedData():void
		{
			var columns:IListCollection = this._owner.columns;
			var cellRendererCount:int = this._unrenderedData.length;
			for(var i:int = 0; i < cellRendererCount; i++)
			{
				var columnIndex:int = this._unrenderedData.shift();
				var column:DataGridColumn = DataGridColumn(columns.getItemAt(i));
				var cellRenderer:IDataGridCellRenderer = this.createCellRenderer(columnIndex, column);
			}
		}

		/**
		 * @private
		 */
		protected function freeInactiveCellRenderers():void
		{
			var activeCellRenderersCount:int = this._activeCellRenderers.length;
			var itemCount:int = this._inactiveCellRenderers.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var cellRenderer:IDataGridCellRenderer = this._inactiveCellRenderers.shift();
				if(cellRenderer === null)
				{
					continue;
				}
				this.destroyCellRenderer(cellRenderer);
			}
		}

		/**
		 * @private
		 */
		protected function refreshCellRendererProperties(cellRenderer:IDataGridCellRenderer, columnIndex:int, column:DataGridColumn):void
		{
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
				cellRenderer.data = null;
				cellRenderer.column = null;
			}
			cellRenderer.owner = this._owner;
			cellRenderer.data = this._data;
			cellRenderer.rowIndex = this._index;
			cellRenderer.column = column;
			cellRenderer.columnIndex = columnIndex;
			cellRenderer.isSelected = this._isSelected;
			cellRenderer.dataField = column.dataField;
			cellRenderer.minWidth = column.minWidth;
			if(column.width === column.width) //!isNaN
			{
				cellRenderer.width = column.width;
				cellRenderer.layoutData = null;
			}
			else
			{
				var layoutData:HorizontalLayoutData = cellRenderer.layoutData as HorizontalLayoutData;
				if(layoutData === null)
				{
					cellRenderer.layoutData = new HorizontalLayoutData(100, NaN);
				}
				else
				{
					layoutData.percentWidth = 100;
					layoutData.percentHeight = NaN;
				}
			}
			this.setChildIndex(DisplayObject(cellRenderer), columnIndex);
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
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
	}
}