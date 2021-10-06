/*
Feathers
Copyright 2012-2021 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.supportClasses
{
	import feathers.controls.DataGrid;
	import feathers.controls.Scroller;
	import feathers.controls.renderers.IDataGridCellRenderer;
	import feathers.controls.supportClasses.DataGridRowRenderer;
	import feathers.controls.supportClasses.IViewPort;
	import feathers.core.FeathersControl;
	import feathers.core.IFeathersControl;
	import feathers.core.IValidating;
	import feathers.data.IListCollection;
	import feathers.data.ListCollection;
	import feathers.events.CollectionEventType;
	import feathers.events.FeathersEventType;
	import feathers.layout.ILayout;
	import feathers.layout.IVariableVirtualLayout;
	import feathers.layout.IVirtualLayout;
	import feathers.layout.LayoutBoundsResult;
	import feathers.layout.ViewPortBounds;

	import flash.errors.IllegalOperationError;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.utils.Pool;

	/**
	 * @private
	 * Used internally by DataGrid. Not meant to be used on its own.
	 * 
	 * @see feathers.controls.DataGrid
	 * 
	 * @productversion Feathers 3.4.0
	 */
	public class DataGridDataViewPort extends FeathersControl implements IViewPort
	{
		private static const INVALIDATION_FLAG_ROW_RENDERER_FACTORY:String = "rowRendererFactory";
		private static const HELPER_VECTOR:Vector.<int> = new <int>[];

		public function DataGridDataViewPort()
		{
			super();
		}

		private var _viewPortBounds:ViewPortBounds = new ViewPortBounds();

		private var _layoutResult:LayoutBoundsResult = new LayoutBoundsResult();

		private var _typicalRowIsInDataProvider:Boolean = false;
		private var _typicalRowRenderer:DataGridRowRenderer;
		private var _rows:Vector.<DisplayObject> = new <DisplayObject>[];
		private var _rowRendererMap:Dictionary = new Dictionary(true);
		private var _unrenderedRows:Vector.<int> = new <int>[];
		private var _rowStorage:RowRendererFactoryStorage = new RowRendererFactoryStorage();
		private var _minimumRowCount:int = 0;

		private var _actualMinVisibleWidth:Number = 0;

		private var _explicitMinVisibleWidth:Number;

		public function get minVisibleWidth():Number
		{
			if(this._explicitMinVisibleWidth !== this._explicitMinVisibleWidth) //isNaN
			{
				return this._actualMinVisibleWidth;
			}
			return this._explicitMinVisibleWidth;
		}

		public function set minVisibleWidth(value:Number):void
		{
			if(this._explicitMinVisibleWidth == value)
			{
				return;
			}
			var valueIsNaN:Boolean = value !== value; //isNaN
			if(valueIsNaN &&
				this._explicitMinVisibleWidth !== this._explicitMinVisibleWidth) //isNaN
			{
				return;
			}
			var oldValue:Number = this._explicitMinVisibleWidth;
			this._explicitMinVisibleWidth = value;
			if(valueIsNaN)
			{
				this._actualMinVisibleWidth = 0;
				this.invalidate(INVALIDATION_FLAG_SIZE);
			}
			else
			{
				this._actualMinVisibleWidth = value;
				if(this._explicitVisibleWidth !== this._explicitVisibleWidth && //isNaN
					(this._actualVisibleWidth < value || this._actualVisibleWidth == oldValue))
				{
					//only invalidate if this change might affect the visibleWidth
					this.invalidate(INVALIDATION_FLAG_SIZE);
				}
			}
		}

		private var _maxVisibleWidth:Number = Number.POSITIVE_INFINITY;

		public function get maxVisibleWidth():Number
		{
			return this._maxVisibleWidth;
		}

		public function set maxVisibleWidth(value:Number):void
		{
			if(this._maxVisibleWidth == value)
			{
				return;
			}
			if(value !== value) //isNaN
			{
				throw new ArgumentError("maxVisibleWidth cannot be NaN");
			}
			var oldValue:Number = this._maxVisibleWidth;
			this._maxVisibleWidth = value;
			if(this._explicitVisibleWidth !== this._explicitVisibleWidth && //isNaN
				(this._actualVisibleWidth > value || this._actualVisibleWidth == oldValue))
			{
				//only invalidate if this change might affect the visibleWidth
				this.invalidate(INVALIDATION_FLAG_SIZE);
			}
		}

		private var _actualVisibleWidth:Number = 0;

		private var _explicitVisibleWidth:Number = NaN;

		public function get visibleWidth():Number
		{
			return this._actualVisibleWidth;
		}

		public function set visibleWidth(value:Number):void
		{
			if(this._explicitVisibleWidth == value ||
				(value !== value && this._explicitVisibleWidth !== this._explicitVisibleWidth)) //isNaN
			{
				return;
			}
			this._explicitVisibleWidth = value;
			if(this._actualVisibleWidth != value)
			{
				this.invalidate(INVALIDATION_FLAG_SIZE);
			}
		}

		private var _actualMinVisibleHeight:Number = 0;

		private var _explicitMinVisibleHeight:Number;

		public function get minVisibleHeight():Number
		{
			if(this._explicitMinVisibleHeight !== this._explicitMinVisibleHeight) //isNaN
			{
				return this._actualMinVisibleHeight;
			}
			return this._explicitMinVisibleHeight;
		}

		public function set minVisibleHeight(value:Number):void
		{
			if(this._explicitMinVisibleHeight == value)
			{
				return;
			}
			var valueIsNaN:Boolean = value !== value; //isNaN
			if(valueIsNaN &&
				this._explicitMinVisibleHeight !== this._explicitMinVisibleHeight) //isNaN
			{
				return;
			}
			var oldValue:Number = this._explicitMinVisibleHeight;
			this._explicitMinVisibleHeight = value;
			if(valueIsNaN)
			{
				this._actualMinVisibleHeight = 0;
				this.invalidate(INVALIDATION_FLAG_SIZE);
			}
			else
			{
				this._actualMinVisibleHeight = value;
				if(this._explicitVisibleHeight !== this._explicitVisibleHeight && //isNaN
					(this._actualVisibleHeight < value || this._actualVisibleHeight == oldValue))
				{
					//only invalidate if this change might affect the visibleHeight
					this.invalidate(INVALIDATION_FLAG_SIZE);
				}
			}
		}

		private var _maxVisibleHeight:Number = Number.POSITIVE_INFINITY;

		public function get maxVisibleHeight():Number
		{
			return this._maxVisibleHeight;
		}

		public function set maxVisibleHeight(value:Number):void
		{
			if(this._maxVisibleHeight == value)
			{
				return;
			}
			if(value !== value) //isNaN
			{
				throw new ArgumentError("maxVisibleHeight cannot be NaN");
			}
			var oldValue:Number = this._maxVisibleHeight;
			this._maxVisibleHeight = value;
			if(this._explicitVisibleHeight !== this._explicitVisibleHeight && //isNaN
				(this._actualVisibleHeight > value || this._actualVisibleHeight == oldValue))
			{
				//only invalidate if this change might affect the visibleHeight
				this.invalidate(INVALIDATION_FLAG_SIZE);
			}
		}

		private var _actualVisibleHeight:Number = 0;

		private var _explicitVisibleHeight:Number = NaN;

		public function get visibleHeight():Number
		{
			return this._actualVisibleHeight;
		}

		public function set visibleHeight(value:Number):void
		{
			if(this._explicitVisibleHeight == value ||
				(value !== value && this._explicitVisibleHeight !== this._explicitVisibleHeight)) //isNaN
			{
				return;
			}
			this._explicitVisibleHeight = value;
			if(this._actualVisibleHeight != value)
			{
				this.invalidate(INVALIDATION_FLAG_SIZE);
			}
		}

		protected var _contentX:Number = 0;

		public function get contentX():Number
		{
			return this._contentX;
		}

		protected var _contentY:Number = 0;

		public function get contentY():Number
		{
			return this._contentY;
		}

		private var _horizontalScrollPosition:Number = 0;

		public function get horizontalScrollPosition():Number
		{
			return this._horizontalScrollPosition;
		}

		public function set horizontalScrollPosition(value:Number):void
		{
			if(this._horizontalScrollPosition == value)
			{
				return;
			}
			this._horizontalScrollPosition = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
		}

		private var _verticalScrollPosition:Number = 0;

		public function get verticalScrollPosition():Number
		{
			return this._verticalScrollPosition;
		}

		public function set verticalScrollPosition(value:Number):void
		{
			if(this._verticalScrollPosition == value)
			{
				return;
			}
			this._verticalScrollPosition = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
		}

		public function get horizontalScrollStep():Number
		{
			var rowRenderer:DisplayObject = null;
			var virtualLayout:IVirtualLayout = this._layout as IVirtualLayout;
			if(virtualLayout === null || !virtualLayout.useVirtualLayout)
			{
				if(this._rows.length > 0)
				{
					rowRenderer = this._rows[0] as DisplayObject;
				}
			}
			if(rowRenderer === null)
			{
				rowRenderer = this._typicalRowRenderer as DisplayObject;
			}
			if(rowRenderer === null)
			{
				return 0;
			}
			var rowRendererWidth:Number = rowRenderer.width;
			var rowRendererHeight:Number = rowRenderer.height;
			if(rowRendererWidth < rowRendererHeight)
			{
				return rowRendererWidth;
			}
			return rowRendererHeight;
		}

		public function get verticalScrollStep():Number
		{
			var rowRenderer:DisplayObject = null;
			var virtualLayout:IVirtualLayout = this._layout as IVirtualLayout;
			if(virtualLayout === null || !virtualLayout.useVirtualLayout)
			{
				if(this._rows.length > 0)
				{
					rowRenderer = this._rows[0] as DisplayObject;
				}
			}
			if(rowRenderer === null)
			{
				rowRenderer = this._typicalRowRenderer as DisplayObject;
			}
			if(rowRenderer === null)
			{
				return 0;
			}
			var rowRendererWidth:Number = rowRenderer.width;
			var rowRendererHeight:Number = rowRenderer.height;
			if(rowRendererWidth < rowRendererHeight)
			{
				return rowRendererWidth;
			}
			return rowRendererHeight;
		}

		private var _owner:DataGrid = null;

		public function get owner():DataGrid
		{
			return this._owner;
		}

		public function set owner(value:DataGrid):void
		{
			this._owner = value;
		}

		private var _updateForDataReset:Boolean = false;

		private var _dataProvider:IListCollection = null;

		public function get dataProvider():IListCollection
		{
			return this._dataProvider;
		}

		public function set dataProvider(value:IListCollection):void
		{
			if(this._dataProvider == value)
			{
				return;
			}
			if(this._dataProvider)
			{
				this._dataProvider.removeEventListener(Event.CHANGE, dataProvider_changeHandler);
				this._dataProvider.removeEventListener(CollectionEventType.RESET, dataProvider_resetHandler);
				this._dataProvider.removeEventListener(CollectionEventType.FILTER_CHANGE, dataProvider_filterChangeHandler);
				this._dataProvider.removeEventListener(CollectionEventType.ADD_ITEM, dataProvider_addItemHandler);
				this._dataProvider.removeEventListener(CollectionEventType.REMOVE_ITEM, dataProvider_removeItemHandler);
				this._dataProvider.removeEventListener(CollectionEventType.REPLACE_ITEM, dataProvider_replaceItemHandler);
				this._dataProvider.removeEventListener(CollectionEventType.UPDATE_ITEM, dataProvider_updateItemHandler);
				this._dataProvider.removeEventListener(CollectionEventType.UPDATE_ALL, dataProvider_updateAllHandler);
			}
			this._dataProvider = value;
			if(this._dataProvider)
			{
				this._dataProvider.addEventListener(Event.CHANGE, dataProvider_changeHandler);
				this._dataProvider.addEventListener(CollectionEventType.RESET, dataProvider_resetHandler);
				this._dataProvider.addEventListener(CollectionEventType.FILTER_CHANGE, dataProvider_filterChangeHandler);
				this._dataProvider.addEventListener(CollectionEventType.ADD_ITEM, dataProvider_addItemHandler);
				this._dataProvider.addEventListener(CollectionEventType.REMOVE_ITEM, dataProvider_removeItemHandler);
				this._dataProvider.addEventListener(CollectionEventType.REPLACE_ITEM, dataProvider_replaceItemHandler);
				this._dataProvider.addEventListener(CollectionEventType.UPDATE_ITEM, dataProvider_updateItemHandler);
				this._dataProvider.addEventListener(CollectionEventType.UPDATE_ALL, dataProvider_updateAllHandler);
			}
			if(this._layout is IVariableVirtualLayout)
			{
				IVariableVirtualLayout(this._layout).resetVariableVirtualCache();
			}
			this._updateForDataReset = true;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		protected var _columns:IListCollection = null;

		public function get columns():IListCollection
		{
			return this._columns;
		}

		public function set columns(value:IListCollection):void
		{
			if(this._columns == value)
			{
				return;
			}
			if(this._columns)
			{
				this._columns.removeEventListener(Event.CHANGE, columns_changeHandler);
			}
			this._columns = value;
			if(this._columns)
			{
				this._columns.addEventListener(Event.CHANGE, columns_changeHandler);
			}

			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		private var _ignoreLayoutChanges:Boolean = false;
		private var _ignoreRendererResizing:Boolean = false;

		private var _layout:ILayout = null;

		public function get layout():ILayout
		{
			return this._layout;
		}

		public function set layout(value:ILayout):void
		{
			if(this._layout == value)
			{
				return;
			}
			if(this._layout)
			{
				this._layout.removeEventListener(Event.CHANGE, layout_changeHandler);
			}
			this._layout = value;
			if(this._layout)
			{
				if(this._layout is IVariableVirtualLayout)
				{
					IVariableVirtualLayout(this._layout).resetVariableVirtualCache();
				}
				this._layout.addEventListener(Event.CHANGE, layout_changeHandler);
			}
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
		}

		private var _typicalItem:Object = null;

		public function get typicalItem():Object
		{
			return this._typicalItem;
		}

		public function set typicalItem(value:Object):void
		{
			if(this._typicalItem == value)
			{
				return;
			}
			this._typicalItem = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		private var _customColumnSizes:Vector.<Number> = null;

		public function get customColumnSizes():Vector.<Number>
		{
			return this._customColumnSizes;
		}

		public function set customColumnSizes(value:Vector.<Number>):void
		{
			if(this._customColumnSizes === value)
			{
				return;
			}
			this._customColumnSizes = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		private var _ignoreSelectionChanges:Boolean = false;

		private var _isSelectable:Boolean = true;

		public function get isSelectable():Boolean
		{
			return this._isSelectable;
		}

		public function set isSelectable(value:Boolean):void
		{
			if(this._isSelectable == value)
			{
				return;
			}
			this._isSelectable = value;
			if(!value)
			{
				this.selectedIndices = null;
			}
		}

		private var _allowMultipleSelection:Boolean = false;

		public function get allowMultipleSelection():Boolean
		{
			return this._allowMultipleSelection;
		}

		public function set allowMultipleSelection(value:Boolean):void
		{
			this._allowMultipleSelection = value;
		}

		private var _selectedIndices:ListCollection;

		public function get selectedIndices():ListCollection
		{
			return this._selectedIndices;
		}

		public function set selectedIndices(value:ListCollection):void
		{
			if(this._selectedIndices == value)
			{
				return;
			}
			if(this._selectedIndices)
			{
				this._selectedIndices.removeEventListener(Event.CHANGE, selectedIndices_changeHandler);
			}
			this._selectedIndices = value;
			if(this._selectedIndices)
			{
				this._selectedIndices.addEventListener(Event.CHANGE, selectedIndices_changeHandler);
			}
			this.invalidate(INVALIDATION_FLAG_SELECTED);
		}

		public function get requiresMeasurementOnScroll():Boolean
		{
			return this._layout.requiresLayoutOnScroll &&
				(this._explicitVisibleWidth !== this._explicitVisibleWidth || //isNaN
				this._explicitVisibleHeight !== this._explicitVisibleHeight); //isNaN
		}

		public function calculateNavigationDestination(index:int, keyCode:uint):int
		{
			return this._layout.calculateNavigationDestination(this._rows, index, keyCode, this._layoutResult);
		}

		public function getScrollPositionForIndex(index:int, result:Point = null):Point
		{
			if(!result)
			{
				result = new Point();
			}
			return this._layout.getScrollPositionForIndex(index, this._rows,
				0, 0, this._actualVisibleWidth, this._actualVisibleHeight, result);
		}

		public function getNearestScrollPositionForIndex(index:int, result:Point = null):Point
		{
			if(!result)
			{
				result = new Point();
			}
			return this._layout.getNearestScrollPositionForIndex(index,
				this._horizontalScrollPosition, this._verticalScrollPosition,
				this._rows, 0, 0, this._actualVisibleWidth, this._actualVisibleHeight, result);
		}

		public function itemToCellRenderer(item:Object, columnIndex:int):IDataGridCellRenderer
		{
			var rowRenderer:DataGridRowRenderer = this._rowRendererMap[item] as DataGridRowRenderer;
			if(rowRenderer === null)
			{
				return null;
			}
			return rowRenderer.getCellRendererForColumn(columnIndex);
		}

		override public function dispose():void
		{
			this.refreshInactiveRowRenderers(true);
			this.owner = null;
			this.layout = null;
			this.dataProvider = null;
			this.columns = null;
			super.dispose();
		}

		override protected function draw():void
		{
			var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			var scrollInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SCROLL);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			var selectionInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SELECTED);
			var rowRendererInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_ROW_RENDERER_FACTORY);
			var stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			var stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			var layoutInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_LAYOUT);

			//scrolling only affects the layout is requiresLayoutOnScroll is true
			if(!layoutInvalid && scrollInvalid && this._layout && this._layout.requiresLayoutOnScroll)
			{
				layoutInvalid = true;
			}

			var basicsInvalid:Boolean = sizeInvalid || dataInvalid || layoutInvalid || rowRendererInvalid;

			var oldIgnoreRendererResizing:Boolean = this._ignoreRendererResizing;
			this._ignoreRendererResizing = true;
			var oldIgnoreLayoutChanges:Boolean = this._ignoreLayoutChanges;
			this._ignoreLayoutChanges = true;

			if(scrollInvalid || sizeInvalid)
			{
				this.refreshViewPortBounds();
			}
			if(basicsInvalid)
			{
				this.refreshInactiveRowRenderers(false);
			}
			if(dataInvalid || layoutInvalid || rowRendererInvalid)
			{
				this.refreshLayoutTypicalItem();
			}
			if(basicsInvalid)
			{
				this.refreshRowRenderers();
			}
			if(selectionInvalid || basicsInvalid)
			{
				//unlike resizing renderers and layout changes, we only want to
				//stop listening for selection changes when we're forcibly
				//updating selection. other property changes on item renderers
				//can validly change selection, and we need to detect that.
				var oldIgnoreSelectionChanges:Boolean = this._ignoreSelectionChanges;
				this._ignoreSelectionChanges = true;
				this.refreshSelection();
				this._ignoreSelectionChanges = oldIgnoreSelectionChanges;
			}
			if(stateInvalid || basicsInvalid)
			{
				this.refreshEnabled();
			}
			this._ignoreLayoutChanges = oldIgnoreLayoutChanges;

			if(stateInvalid || selectionInvalid || stylesInvalid || basicsInvalid)
			{
				this._layout.layout(this._rows, this._viewPortBounds, this._layoutResult);
			}

			this._ignoreRendererResizing = oldIgnoreRendererResizing;

			this._contentX = this._layoutResult.contentX;
			this._contentY = this._layoutResult.contentY;
			this.saveMeasurements(this._layoutResult.contentWidth, this._layoutResult.contentHeight,
				this._layoutResult.contentWidth, this._layoutResult.contentHeight);
			this._actualVisibleWidth = this._layoutResult.viewPortWidth;
			this._actualVisibleHeight = this._layoutResult.viewPortHeight;
			this._actualMinVisibleWidth = this._layoutResult.viewPortWidth;
			this._actualMinVisibleHeight = this._layoutResult.viewPortHeight;

			//final validation to avoid juggler next frame issues
			this.validateRowRenderers();
		}

		private function refreshViewPortBounds():void
		{
			var needsMinWidth:Boolean = this._explicitMinVisibleWidth !== this._explicitMinVisibleWidth; //isNaN
			var needsMinHeight:Boolean = this._explicitMinVisibleHeight !== this._explicitMinVisibleHeight; //isNaN
			this._viewPortBounds.x = 0;
			this._viewPortBounds.y = 0;
			this._viewPortBounds.scrollX = this._horizontalScrollPosition;
			this._viewPortBounds.scrollY = this._verticalScrollPosition;
			this._viewPortBounds.explicitWidth = this._explicitVisibleWidth;
			this._viewPortBounds.explicitHeight = this._explicitVisibleHeight;
			if(needsMinWidth)
			{
				this._viewPortBounds.minWidth = 0;
			}
			else
			{
				this._viewPortBounds.minWidth = this._explicitMinVisibleWidth;
			}
			if(needsMinHeight)
			{
				this._viewPortBounds.minHeight = 0;
			}
			else
			{
				this._viewPortBounds.minHeight = this._explicitMinVisibleHeight;
			}
			this._viewPortBounds.maxWidth = this._maxVisibleWidth;
			this._viewPortBounds.maxHeight = this._maxVisibleHeight;
		}

		private function refreshInactiveRowRenderers(forceCleanup:Boolean):void
		{
			var temp:Vector.<DataGridRowRenderer> = this._rowStorage.inactiveRowRenderers;
			this._rowStorage.inactiveRowRenderers = this._rowStorage.activeRowRenderers;
			this._rowStorage.activeRowRenderers = temp;
			if(this._rowStorage.activeRowRenderers.length > 0)
			{
				throw new IllegalOperationError("DataGridDataViewPort: active row renderers should be empty.");
			}
			if(forceCleanup)
			{
				this.recoverInactiveRowRenderers();
				this.freeInactiveRowRenderers(0);
				if(this._typicalRowRenderer !== null)
				{
					if(this._typicalRowIsInDataProvider)
					{
						delete this._rowRendererMap[this._typicalRowRenderer.data];
					}
					this.destroyRowRenderer(this._typicalRowRenderer);
					this._typicalRowRenderer = null;
					this._typicalRowIsInDataProvider = false;
				}
			}
			this._rows.length = 0;
		}

		private function recoverInactiveRowRenderers():void
		{
			var inactiveRowRenderers:Vector.<DataGridRowRenderer> = this._rowStorage.inactiveRowRenderers;
			var itemCount:int = inactiveRowRenderers.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var rowRenderer:DataGridRowRenderer = inactiveRowRenderers[i];
				if(rowRenderer === null || rowRenderer.data === null)
				{
					continue;
				}
				this._owner.dispatchEventWith(FeathersEventType.RENDERER_REMOVE, false, rowRenderer);
				delete this._rowRendererMap[rowRenderer.data];
			}
		}

		private function freeInactiveRowRenderers(minimumItemCount:int):void
		{
			var inactiveRowRenderers:Vector.<DataGridRowRenderer> = this._rowStorage.inactiveRowRenderers;
			var activeRowRenderers:Vector.<DataGridRowRenderer> = this._rowStorage.activeRowRenderers;
			var activeRowRenderersCount:int = activeRowRenderers.length;

			//we may keep around some extra renderers to avoid too much
			//allocation and garbage collection. they'll be hidden.
			var itemCount:int = inactiveRowRenderers.length;
			var keepCount:int = minimumItemCount - activeRowRenderersCount;
			if(keepCount > itemCount)
			{
				keepCount = itemCount;
			}
			for(var i:int = 0; i < keepCount; i++)
			{
				var rowRenderer:DataGridRowRenderer = inactiveRowRenderers.shift();
				if(rowRenderer === null)
				{
					keepCount++;
					if(itemCount < keepCount)
					{
						keepCount = itemCount;
					}
					continue;
				}
				rowRenderer.data = null;
				rowRenderer.columns = null;
				rowRenderer.index = -1;
				rowRenderer.visible = false;
				rowRenderer.customColumnSizes = null;
				activeRowRenderers[activeRowRenderersCount] = rowRenderer;
				activeRowRenderersCount++;
			}
			itemCount -= keepCount;
			for(i = 0; i < itemCount; i++)
			{
				rowRenderer = inactiveRowRenderers.shift();
				if(rowRenderer === null)
				{
					continue;
				}
				this.destroyRowRenderer(rowRenderer);
			}
		}

		private function createRowRenderer(item:Object, rowIndex:int, useCache:Boolean, isTemporary:Boolean):DataGridRowRenderer
		{
			var inactiveRowRenderers:Vector.<DataGridRowRenderer> = this._rowStorage.inactiveRowRenderers;
			var activeRowRenderers:Vector.<DataGridRowRenderer> = this._rowStorage.activeRowRenderers;
			var rowRenderer:DataGridRowRenderer = null;
			do
			{
				if(!useCache || isTemporary || inactiveRowRenderers.length == 0)
				{
					rowRenderer = new DataGridRowRenderer();
					this.addChild(DisplayObject(rowRenderer));
				}
				else
				{
					rowRenderer = inactiveRowRenderers.shift();
				}
				//wondering why this all is in a loop?
				//_inactiveRenderers.shift() may return null because we're
				//storing null values instead of calling splice() to improve
				//performance.
			}
			while(rowRenderer === null);
			rowRenderer.data = item;
			rowRenderer.columns = this._columns;
			rowRenderer.index = rowIndex;
			rowRenderer.owner = this._owner;
			rowRenderer.customColumnSizes = this._customColumnSizes;

			if(!isTemporary)
			{
				this._rowRendererMap[item] = rowRenderer;
				activeRowRenderers[activeRowRenderers.length] = rowRenderer;
				rowRenderer.addEventListener(Event.TRIGGERED, rowRenderer_triggeredHandler);
				rowRenderer.addEventListener(Event.CHANGE, rowRenderer_changeHandler);
				rowRenderer.addEventListener(FeathersEventType.RESIZE, rowRenderer_resizeHandler);
				this._owner.dispatchEventWith(FeathersEventType.RENDERER_ADD, false, rowRenderer);
			}

			return rowRenderer;
		}

		private function destroyRowRenderer(rowRenderer:DataGridRowRenderer):void
		{
			rowRenderer.removeEventListener(Event.TRIGGERED, rowRenderer_triggeredHandler);
			rowRenderer.removeEventListener(Event.CHANGE, rowRenderer_changeHandler);
			rowRenderer.removeEventListener(FeathersEventType.RESIZE, rowRenderer_resizeHandler);
			rowRenderer.data = null;
			rowRenderer.columns = null;
			rowRenderer.index = -1;
			this.removeChild(DisplayObject(rowRenderer), true);
			rowRenderer.owner = null;
		}

		private function refreshLayoutTypicalItem():void
		{
			var virtualLayout:IVirtualLayout = this._layout as IVirtualLayout;
			if(virtualLayout === null || !virtualLayout.useVirtualLayout)
			{
				//the old layout was virtual, but this one isn't
				if(!this._typicalRowIsInDataProvider && this._typicalRowRenderer !== null)
				{
					//it's safe to destroy this renderer
					this.destroyRowRenderer(this._typicalRowRenderer);
					this._typicalRowRenderer = null;
				}
				return;
			}
			var typicalItemIndex:int = 0;
			var newTypicalItemIsInDataProvider:Boolean = false;
			var typicalItem:Object = this._typicalItem;
			if(typicalItem !== null)
			{
				if(this._dataProvider !== null)
				{
					typicalItemIndex = this._dataProvider.getItemIndex(typicalItem);
					newTypicalItemIsInDataProvider = typicalItemIndex >= 0;
				}
				if(typicalItemIndex < 0)
				{
					typicalItemIndex = 0;
				}
			}
			else
			{
				if(this._dataProvider !== null && this._dataProvider.length > 0)
				{
					newTypicalItemIsInDataProvider = true;
					typicalItem = this._dataProvider.getItemAt(0);
				}
			}

			//#1645 The typicalItem can be null if the data provider contains
			//a null value at index 0. this is the only time we allow null.
			if(typicalItem !== null || newTypicalItemIsInDataProvider)
			{
				var typicalRenderer:DataGridRowRenderer = this._rowRendererMap[typicalItem] as DataGridRowRenderer;
				if(typicalRenderer !== null)
				{
					//at this point, the item already has a row renderer.
					//(this doesn't necessarily mean that the current typical
					//item was the typical item last time this function was
					//called)

					//the index may have changed if items were added, removed or
					//reordered in the data provider
					typicalRenderer.index = typicalItemIndex;
				}
				if(typicalRenderer === null && this._typicalRowRenderer !== null)
				{
					//the typical item has changed, and doesn't have a row
					//renderer yet. the previous typical item had a row
					//renderer, so we will try to reuse it.

					//we can reuse the existing typical row renderer if the old
					//typical item wasn't in the data provider. otherwise, it
					//may still be needed for the same item.
					var canReuse:Boolean = !this._typicalRowIsInDataProvider;
					var oldTypicalItemRemoved:Boolean = this._typicalRowIsInDataProvider &&
						this._dataProvider && this._dataProvider.getItemIndex(this._typicalRowRenderer.data) < 0;
					if(!canReuse && oldTypicalItemRemoved)
					{
						//special case: if the old typical item was in the data
						//provider, but it has been removed, it's safe to reuse.
						canReuse = true;
					}
					if(canReuse)
					{
						//we can reuse the item renderer used for the old
						//typical item!

						//if the old typical item was in the data provider,
						//remove it from the renderer map.
						if(this._typicalRowIsInDataProvider)
						{
							delete this._rowRendererMap[this._typicalRowRenderer.data];
						}
						typicalRenderer = this._typicalRowRenderer;
						typicalRenderer.data = typicalItem;
						typicalRenderer.index = typicalItemIndex;
						//if the new typical item is in the data provider, add it
						//to the renderer map.
						if(newTypicalItemIsInDataProvider)
						{
							this._rowRendererMap[typicalItem] = typicalRenderer;
						}
					}
				}
				if(typicalRenderer === null)
				{
					//if we still don't have a typical row renderer, we need to
					//create a new one.
					typicalRenderer = this.createRowRenderer(typicalItem, typicalItemIndex, false, !newTypicalItemIsInDataProvider);
					if(!this._typicalRowIsInDataProvider && this._typicalRowRenderer !== null)
					{
						//get rid of the old typical row renderer if it isn't
						//needed anymore.  since it was not in the data
						//provider, we don't need to mess with the renderer map
						//dictionary or dispatch any events.
						this.destroyRowRenderer(this._typicalRowRenderer);
						this._typicalRowRenderer = null;
					}
				}
			}

			virtualLayout.typicalItem = DisplayObject(typicalRenderer);
			this._typicalRowRenderer = typicalRenderer;
			this._typicalRowIsInDataProvider = newTypicalItemIsInDataProvider;
			if(this._typicalRowRenderer !== null && !this._typicalRowIsInDataProvider)
			{
				//we need to know if this item renderer resizes to adjust the
				//layout because the layout may use this item renderer to resize
				//the other item renderers
				this._typicalRowRenderer.addEventListener(FeathersEventType.RESIZE, rowRenderer_resizeHandler);
			}
		}

		private function refreshRowRenderers():void
		{
			if(this._typicalRowRenderer !== null && this._typicalRowIsInDataProvider)
			{
				var inactiveRowRenderers:Vector.<DataGridRowRenderer> = this._rowStorage.inactiveRowRenderers;
				var activeRowRenderers:Vector.<DataGridRowRenderer> = this._rowStorage.activeRowRenderers;
				//this renderer is already is use by the typical item, so we
				//don't want to allow it to be used by other items.
				var inactiveIndex:int = inactiveRowRenderers.indexOf(this._typicalRowRenderer);
				if(inactiveIndex >= 0)
				{
					inactiveRowRenderers[inactiveIndex] = null;
				}
				//if refreshLayoutTypicalItem() was called, it will have already
				//added the typical row renderer to the active renderers. if
				//not, we need to do it here.
				var activeRendererCount:int = activeRowRenderers.length;
				if(activeRendererCount == 0)
				{
					activeRowRenderers[activeRendererCount] = this._typicalRowRenderer;
				}
			}

			this.findUnrenderedRowData();
			this.recoverInactiveRowRenderers();
			this.renderUnrenderedRowData();
			this.freeInactiveRowRenderers(this._minimumRowCount);
		}

		private function findUnrenderedRowData():void
		{
			var itemCount:int = 0;
			if(this._dataProvider !== null)
			{
				itemCount = this._dataProvider.length;
			}
			var virtualLayout:IVirtualLayout = this._layout as IVirtualLayout;
			var useVirtualLayout:Boolean = virtualLayout && virtualLayout.useVirtualLayout;
			if(useVirtualLayout)
			{
				var point:Point = Pool.getPoint();
				virtualLayout.measureViewPort(itemCount, this._viewPortBounds, point);
				virtualLayout.getVisibleIndicesAtScrollPosition(this._horizontalScrollPosition, this._verticalScrollPosition, point.x, point.y, itemCount, HELPER_VECTOR);
				Pool.putPoint(point);
			}

			this._rows.length = itemCount;

			var unrenderedItemCount:int = itemCount;
			if(useVirtualLayout)
			{
				unrenderedItemCount = HELPER_VECTOR.length;
			}
			if(useVirtualLayout && this._typicalRowIsInDataProvider && this._typicalRowRenderer &&
				HELPER_VECTOR.indexOf(this._typicalRowRenderer.index) >= 0)
			{
				//add an extra item renderer if the typical item is from the
				//data provider and it is visible. this helps keep the number of
				//item renderers constant!
				this._minimumRowCount = unrenderedItemCount + 1;
			}
			else
			{
				this._minimumRowCount = unrenderedItemCount;
			}

			var unrenderedDataLastIndex:int = this._unrenderedRows.length;
			for(var i:int = 0; i < unrenderedItemCount; i++)
			{
				var index:int = i;
				if(useVirtualLayout)
				{
					index = HELPER_VECTOR[i];
				}
				if(index < 0 || index >= itemCount)
				{
					continue;
				}
				var item:Object = this._dataProvider.getItemAt(index);
				var rowRenderer:DataGridRowRenderer = this._rowRendererMap[item] as DataGridRowRenderer;
				if(rowRenderer !== null)
				{
					//the index may have changed if items were added, removed or
					//reordered in the data provider
					rowRenderer.index = index;
					//if this row renderer used to be the typical row
					//renderer, but it isn't anymore, it may have been set invisible!
					rowRenderer.visible = true;
					rowRenderer.customColumnSizes = this._customColumnSizes;
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
						rowRenderer.data = null;
						rowRenderer.data = item;
					}

					//the typical row renderer is a special case, and we will
					//have already put it into the active renderers, so we don't
					//want to do it again!
					if(this._typicalRowRenderer !== rowRenderer)
					{
						var activeRowRenderers:Vector.<DataGridRowRenderer> = this._rowStorage.activeRowRenderers;
						var inactiveRowRenderers:Vector.<DataGridRowRenderer> = this._rowStorage.inactiveRowRenderers;
						activeRowRenderers[activeRowRenderers.length] = rowRenderer;
						var inactiveIndex:int = inactiveRowRenderers.indexOf(rowRenderer);
						if(inactiveIndex >= 0)
						{
							inactiveRowRenderers[inactiveIndex] = null;
						}
						else
						{
							throw new IllegalOperationError("DataGridDataViewPort: row renderer map contains bad data. This may be caused by duplicate items in the data provider, which is not allowed.");
						}
					}
					this._rows[index] = DisplayObject(rowRenderer);
				}
				else
				{
					this._unrenderedRows[unrenderedDataLastIndex] = index;
					unrenderedDataLastIndex++;
				}
			}
			//update the typical row renderer's visibility
			if(this._typicalRowRenderer !== null)
			{
				if(useVirtualLayout && this._typicalRowIsInDataProvider)
				{
					index = HELPER_VECTOR.indexOf(this._typicalRowRenderer.index);
					if(index >= 0)
					{
						this._typicalRowRenderer.visible = true;
					}
					else
					{
						this._typicalRowRenderer.visible = false;

						//uncomment these lines to see a hidden typical row for
						//debugging purposes...
						/*this._typicalRowRenderer.visible = true;
						this._typicalRowRenderer.x = this._horizontalScrollPosition;
						this._typicalRowRenderer.y = this._verticalScrollPosition;*/
					}
				}
				else
				{
					this._typicalRowRenderer.visible = this._typicalRowIsInDataProvider;
				}
			}
			HELPER_VECTOR.length = 0;
		}

		private function renderUnrenderedRowData():void
		{
			var rowRendererCount:int = this._unrenderedRows.length;
			for(var i:int = 0; i < rowRendererCount; i++)
			{
				var rowIndex:int = this._unrenderedRows.shift();
				var item:Object = this._dataProvider.getItemAt(rowIndex);
				var rowRenderer:DataGridRowRenderer = this.createRowRenderer(
					item, rowIndex, true, false);
				rowRenderer.visible = true;
				this._rows[rowIndex] = DisplayObject(rowRenderer);
			}
		}

		private function refreshSelection():void
		{
			var itemCount:int = this._rows.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var rowRenderer:DataGridRowRenderer = this._rows[i] as DataGridRowRenderer;
				if(rowRenderer !== null)
				{
					rowRenderer.isSelected = this._selectedIndices.getItemIndex(rowRenderer.index) >= 0;
				}
			}
		}

		private function refreshEnabled():void
		{
			var itemCount:int = this._rows.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var control:IFeathersControl = this._rows[i] as IFeathersControl;
				if(control !== null)
				{
					control.isEnabled = this._isEnabled;
				}
			}
		}

		private function validateRowRenderers():void
		{
			var itemCount:int = this._rows.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:IValidating = this._rows[i] as IValidating;
				if(item !== null)
				{
					item.validate();
				}
			}
		}

		private function invalidateParent(flag:String = INVALIDATION_FLAG_ALL):void
		{
			Scroller(this.parent).invalidate(flag);
		}

		private function columns_changeHandler(event:Event):void
		{
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		private function dataProvider_changeHandler(event:Event):void
		{
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		private function dataProvider_addItemHandler(event:Event, index:int):void
		{
			var layout:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
			if(!layout || !layout.hasVariableItemDimensions)
			{
				return;
			}
			layout.addToVariableVirtualCacheAtIndex(index);
		}

		private function dataProvider_removeItemHandler(event:Event, index:int):void
		{
			var layout:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
			if(!layout || !layout.hasVariableItemDimensions)
			{
				return;
			}
			layout.removeFromVariableVirtualCacheAtIndex(index);
		}

		private function dataProvider_replaceItemHandler(event:Event, index:int):void
		{
			var layout:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
			if(!layout || !layout.hasVariableItemDimensions)
			{
				return;
			}
			layout.resetVariableVirtualCacheAtIndex(index);
		}

		private function dataProvider_resetHandler(event:Event):void
		{
			this._updateForDataReset = true;

			var layout:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
			if(!layout || !layout.hasVariableItemDimensions)
			{
				return;
			}
			layout.resetVariableVirtualCache();
		}

		private function dataProvider_filterChangeHandler(event:Event):void
		{
			var layout:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
			if(!layout || !layout.hasVariableItemDimensions)
			{
				return;
			}
			//we don't know exactly which indices have changed, so reset the
			//whole cache.
			layout.resetVariableVirtualCache();
		}

		private function dataProvider_updateItemHandler(event:Event, index:int):void
		{
			var item:Object = this._dataProvider.getItemAt(index);
			var rowRenderer:DataGridRowRenderer = this._rowRendererMap[item] as DataGridRowRenderer;
			if(rowRenderer === null)
			{
				return;
			}
			//in order to display the same item with modified properties, this
			//hack tricks the item renderer into thinking that it has been given
			//a different item to render.
			rowRenderer.data = null;
			rowRenderer.data = item;
			if(this._explicitVisibleWidth !== this._explicitVisibleWidth || //isNaN
				this._explicitVisibleHeight !== this._explicitVisibleHeight) //isNaN
			{
				this.invalidate(INVALIDATION_FLAG_SIZE);
				this.invalidateParent(INVALIDATION_FLAG_SIZE);
			}
		}

		private function dataProvider_updateAllHandler(event:Event):void
		{
			//we're treating this similar to the RESET event because enough
			//users are treating UPDATE_ALL similarly. technically, UPDATE_ALL
			//is supposed to affect only existing items, but it's confusing when
			//new items are added and not displayed.
			this._updateForDataReset = true;
			this.invalidate(INVALIDATION_FLAG_DATA);

			var layout:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
			if(!layout || !layout.hasVariableItemDimensions)
			{
				return;
			}
			layout.resetVariableVirtualCache();
		}

		private function rowRenderer_triggeredHandler(event:Event):void
		{
			var rowRenderer:DataGridRowRenderer = DataGridRowRenderer(event.currentTarget);
			this.parent.dispatchEventWith(Event.TRIGGERED, false, rowRenderer.data);
		}

		private function rowRenderer_changeHandler(event:Event):void
		{
			if(this._ignoreSelectionChanges)
			{
				return;
			}
			var rowRenderer:DataGridRowRenderer = DataGridRowRenderer(event.currentTarget);
			if(!this._isSelectable || this._owner.isScrolling)
			{
				rowRenderer.isSelected = false;
				return;
			}
			var isSelected:Boolean = rowRenderer.isSelected;
			var index:int = rowRenderer.index;
			if(this._allowMultipleSelection)
			{
				var indexOfIndex:int = this._selectedIndices.getItemIndex(index);
				if(isSelected && indexOfIndex < 0)
				{
					this._selectedIndices.addItem(index);
				}
				else if(!isSelected && indexOfIndex >= 0)
				{
					this._selectedIndices.removeItemAt(indexOfIndex);
				}
			}
			else if(isSelected)
			{
				this._selectedIndices.data = new <int>[index];
			}
			else
			{
				this._selectedIndices.removeAll();
			}
		}

		private function rowRenderer_resizeHandler(event:Event):void
		{
			if(this._ignoreRendererResizing)
			{
				return;
			}
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
			this.invalidateParent(INVALIDATION_FLAG_LAYOUT);
			if(event.currentTarget === this._typicalRowRenderer && !this._typicalRowIsInDataProvider)
			{
				return;
			}
			var layout:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
			if(!layout || !layout.hasVariableItemDimensions)
			{
				return;
			}
			var rowRenderer:DataGridRowRenderer = DataGridRowRenderer(event.currentTarget);
			layout.resetVariableVirtualCacheAtIndex(rowRenderer.index, DisplayObject(rowRenderer));
		}

		private function layout_changeHandler(event:Event):void
		{
			if(this._ignoreLayoutChanges)
			{
				return;
			}
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
			this.invalidateParent(INVALIDATION_FLAG_LAYOUT);
		}

		private function selectedIndices_changeHandler(event:Event):void
		{
			this.invalidate(INVALIDATION_FLAG_SELECTED);
		}
	}
}

import feathers.controls.supportClasses.DataGridRowRenderer;

class RowRendererFactoryStorage
{
	public function RowRendererFactoryStorage()
	{

	}

	public var activeRowRenderers:Vector.<DataGridRowRenderer> = new <DataGridRowRenderer>[];
	public var inactiveRowRenderers:Vector.<DataGridRowRenderer> = new <DataGridRowRenderer>[];
}