/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.supportClasses
{
	import feathers.core.FeathersControl;
	import feathers.controls.supportClasses.IViewPort;
	import feathers.controls.DataGrid;
	import feathers.layout.LayoutBoundsResult;
	import feathers.layout.ViewPortBounds;
	import feathers.layout.IVirtualLayout;
	import starling.display.DisplayObject;
	import feathers.layout.ILayout;
	import starling.events.Event;
	import feathers.layout.IVariableVirtualLayout;
	import flash.geom.Point;
	import feathers.data.ListCollection;
	import feathers.controls.renderers.IDataGridItemRenderer;
	import feathers.controls.Scroller;
	import feathers.events.CollectionEventType;
	import feathers.data.IListCollection;
	import flash.utils.Dictionary;
	import feathers.core.IValidating;
	import feathers.core.IFeathersControl;
	import flash.errors.IllegalOperationError;
	import feathers.events.FeathersEventType;
	import feathers.controls.DataGridColumn;
	import feathers.layout.ITrimmedVirtualLayout;
	import starling.utils.Pool;
	import feathers.controls.LayoutGroup;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.HorizontalLayoutData;

	/**
	 * 
	 * @productversion Feathers 3.4.0
	 */
	public class DataGridDataViewPort extends FeathersControl implements IViewPort
	{
		private static const HELPER_VECTOR:Vector.<int> = new <int>[];

		public function DataGridDataViewPort()
		{
			super();
		}

		private var _viewPortBounds:ViewPortBounds = new ViewPortBounds();

		private var _layoutResult:LayoutBoundsResult = new LayoutBoundsResult();

		private var _typicalItemIsInDataProvider:Boolean = false;
		private var _typicalItemRenderer:IDataGridItemRenderer;
		private var _layoutItems:Vector.<DisplayObject> = new <DisplayObject>[];
		private var _itemRendererMaps:Vector.<Dictionary> = new <Dictionary>[];
		private var _unrenderedItems:Vector.<int> = new <int>[];
		private var _itemStorage:Vector.<ItemRendererFactoryStorage> = new <ItemRendererFactoryStorage>[];
		private var _minimumItemCount:int;

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
					(this._actualVisibleWidth < value || this._actualVisibleWidth === oldValue))
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
				(this._actualVisibleWidth > value || this._actualVisibleWidth === oldValue))
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
			if(this._actualVisibleWidth !== value)
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
					(this._actualVisibleHeight < value || this._actualVisibleHeight === oldValue))
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
				(this._actualVisibleHeight > value || this._actualVisibleHeight === oldValue))
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
			if(this._actualVisibleHeight !== value)
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
			var itemRenderer:DisplayObject = null;
			var virtualLayout:IVirtualLayout = this._layout as IVirtualLayout;
			if(virtualLayout === null || !virtualLayout.useVirtualLayout)
			{
				if(this._layoutItems.length > 0)
				{
					itemRenderer = this._layoutItems[0] as DisplayObject;
				}
			}
			if(itemRenderer === null)
			{
				itemRenderer = this._typicalItemRenderer as DisplayObject;
			}
			if(itemRenderer === null)
			{
				return 0;
			}
			var itemRendererWidth:Number = itemRenderer.width;
			var itemRendererHeight:Number = itemRenderer.height;
			if(itemRendererWidth < itemRendererHeight)
			{
				return itemRendererWidth;
			}
			return itemRendererHeight;
		}

		public function get verticalScrollStep():Number
		{
			var itemRenderer:DisplayObject = null;
			var virtualLayout:IVirtualLayout = this._layout as IVirtualLayout;
			if(virtualLayout === null || !virtualLayout.useVirtualLayout)
			{
				if(this._layoutItems.length > 0)
				{
					itemRenderer = this._layoutItems[0] as DisplayObject;
				}
			}
			if(itemRenderer === null)
			{
				itemRenderer = this._typicalItemRenderer as DisplayObject;
			}
			if(itemRenderer === null)
			{
				return 0;
			}
			var itemRendererWidth:Number = itemRenderer.width;
			var itemRendererHeight:Number = itemRenderer.height;
			if(itemRendererWidth < itemRendererHeight)
			{
				return itemRendererWidth;
			}
			return itemRendererHeight;
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
				(this._explicitVisibleWidth !== this._explicitVisibleWidth ||
				this._explicitVisibleHeight !== this._explicitVisibleHeight);
		}

		public function calculateNavigationDestination(index:int, keyCode:uint):int
		{
			return this._layout.calculateNavigationDestination(this._layoutItems, index, keyCode, this._layoutResult);
		}

		public function getScrollPositionForIndex(index:int, result:Point = null):Point
		{
			if(!result)
			{
				result = new Point();
			}
			return this._layout.getScrollPositionForIndex(index, this._layoutItems,
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
				this._layoutItems, 0, 0, this._actualVisibleWidth, this._actualVisibleHeight, result);
		}
		
		public function itemToItemRenderer(item:Object, columnIndex:int):IDataGridItemRenderer
		{
			var map:Dictionary = null;
			if(this._itemRendererMaps.length > columnIndex)
			{
				map = this._itemRendererMaps[columnIndex] as Dictionary;
			}
			if(map === null)
			{
				return null;
			}
			return map[item] as IDataGridItemRenderer;
		}

		override public function dispose():void
		{
			var count:int = this._itemStorage.length;
			for(var i:int = 0; i < count; i++)
			{
				this.refreshInactiveItemRenderers(i, true);
			}
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
			var itemRendererInvalid:Boolean = false;//this.isInvalid(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
			var stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			var stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			var layoutInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_LAYOUT);

			//scrolling only affects the layout is requiresLayoutOnScroll is true
			if(!layoutInvalid && scrollInvalid && this._layout && this._layout.requiresLayoutOnScroll)
			{
				layoutInvalid = true;
			}

			var basicsInvalid:Boolean = sizeInvalid || dataInvalid || layoutInvalid || itemRendererInvalid;

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
				var count:int = this._itemStorage.length;
				for(var i:int = 0; i < count; i++)
				{
					this.refreshInactiveItemRenderers(i, false);
				}
			}
			if(dataInvalid || layoutInvalid || itemRendererInvalid)
			{
				this.refreshLayoutTypicalItem();
			}
			if(basicsInvalid)
			{
				this.refreshItemRenderers();
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
				this._layout.layout(this._layoutItems, this._viewPortBounds, this._layoutResult);
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
			this.validateItemRenderers();
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

		private function refreshInactiveItemRenderers(columnIndex:int, forceCleanup:Boolean):void
		{
			var storage:ItemRendererFactoryStorage = ItemRendererFactoryStorage(this._itemStorage[columnIndex]);
			var temp:Vector.<IDataGridItemRenderer> = storage.inactiveItemRenderers;
			storage.inactiveItemRenderers = storage.activeItemRenderers;
			storage.activeItemRenderers = temp;
			if(storage.activeItemRenderers.length > 0)
			{
				throw new IllegalOperationError("DataGridDataViewPort: active renderers should be empty.");
			}
			var column:DataGridColumn = null;
			if(this._columns !== null && columnIndex < this._columns.length)
			{
				column = DataGridColumn(this._columns.getItemAt(columnIndex));
			}
			if(forceCleanup || column === null || column.itemRendererFactory !== storage.factory ||
				column.customItemRendererStyleName !== storage.customItemRendererStyleName)
			{
				this.recoverInactiveItemRenderers(storage);
				this.freeInactiveItemRenderers(storage, 0);
				if(this._typicalItemRenderer !== null)
				{
					if(this._typicalItemIsInDataProvider)
					{
						var map:Dictionary = this._itemRendererMaps[storage.columnIndex] as Dictionary;
						delete map[this._typicalItemRenderer.data];
					}
					this.destroyItemRenderer(this._typicalItemRenderer);
					this._typicalItemRenderer = null;
					this._typicalItemIsInDataProvider = false;
				}
			}

			this._layoutItems.length = 0;
		}

		private function recoverInactiveItemRenderers(storage:ItemRendererFactoryStorage):void
		{
			var inactiveItemRenderers:Vector.<IDataGridItemRenderer> = storage.inactiveItemRenderers;
			
			var itemCount:int = inactiveItemRenderers.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var itemRenderer:IDataGridItemRenderer = inactiveItemRenderers[i];
				if(itemRenderer === null || itemRenderer.data === null)
				{
					continue;
				}
				this._owner.dispatchEventWith(FeathersEventType.RENDERER_REMOVE, false, itemRenderer);
				var map:Dictionary = this._itemRendererMaps[storage.columnIndex] as Dictionary;
				delete map[itemRenderer.data];
			}
		}

		private function freeInactiveItemRenderers(storage:ItemRendererFactoryStorage, minimumItemCount:int):void
		{
			var inactiveItemRenderers:Vector.<IDataGridItemRenderer> = storage.inactiveItemRenderers;
			var activeItemRenderers:Vector.<IDataGridItemRenderer> = storage.activeItemRenderers;
			var activeItemRenderersCount:int = activeItemRenderers.length;
			
			//we may keep around some extra renderers to avoid too much
			//allocation and garbage collection. they'll be hidden.
			var itemCount:int = inactiveItemRenderers.length;
			var keepCount:int = minimumItemCount - activeItemRenderersCount;
			if(keepCount > itemCount)
			{
				keepCount = itemCount;
			}
			for(var i:int = 0; i < keepCount; i++)
			{
				var itemRenderer:IDataGridItemRenderer = inactiveItemRenderers.shift();
				if(!itemRenderer)
				{
					keepCount++;
					if(itemCount < keepCount)
					{
						keepCount = itemCount;
					}
					continue;
				}
				itemRenderer.data = null;
				itemRenderer.index = -1;
				itemRenderer.layoutIndex = -1;
				itemRenderer.visible = false;
				activeItemRenderers[activeItemRenderersCount] = itemRenderer;
				activeItemRenderersCount++;
			}
			itemCount -= keepCount;
			for(i = 0; i < itemCount; i++)
			{
				itemRenderer = inactiveItemRenderers.shift();
				if(!itemRenderer)
				{
					continue;
				}
				this.destroyItemRenderer(itemRenderer);
			}
		}

		private function createItemRenderer(item:Object, rowIndex:int, columnIndex:int, layoutIndex:int, useCache:Boolean, isTemporary:Boolean):IDataGridItemRenderer
		{
			var column:DataGridColumn = DataGridColumn(this._columns.getItemAt(columnIndex));
			var itemRendererFactory:Function = column.itemRendererFactory;
			var customItemRendererStyleName:String = column.customItemRendererStyleName;
			var storage:ItemRendererFactoryStorage = null;
			if(columnIndex < this._itemStorage.length)
			{
				storage = this._itemStorage[columnIndex];
			}
			else
			{
				storage = new ItemRendererFactoryStorage();
				storage.columnIndex = columnIndex;
				storage.factory = column.itemRendererFactory;
				storage.customItemRendererStyleName = column.customItemRendererStyleName;
				this._itemStorage[columnIndex] = storage;
			}
			var inactiveItemRenderers:Vector.<IDataGridItemRenderer> = storage.inactiveItemRenderers;
			var activeItemRenderers:Vector.<IDataGridItemRenderer> = storage.activeItemRenderers;
			var itemRenderer:IDataGridItemRenderer;
			do
			{
				if(!useCache || isTemporary || inactiveItemRenderers.length === 0)
				{
					itemRenderer = IDataGridItemRenderer(itemRendererFactory());
					if(customItemRendererStyleName !== null && customItemRendererStyleName.length > 0)
					{
						itemRenderer.styleNameList.add(customItemRendererStyleName);
					}
					this.addChild(DisplayObject(itemRenderer));
				}
				else
				{
					itemRenderer = inactiveItemRenderers.shift();
				}
				//wondering why this all is in a loop?
				//_inactiveRenderers.shift() may return null because we're
				//storing null values instead of calling splice() to improve
				//performance.
			}
			while(!itemRenderer)
			itemRenderer.data = item;
			itemRenderer.index = rowIndex;
			itemRenderer.dataField = column.dataField;
			itemRenderer.layoutIndex = layoutIndex;
			itemRenderer.owner = this._owner;

			if(!isTemporary)
			{
				var map:Dictionary = null;
				if(this._itemRendererMaps.length > columnIndex)
				{
					map = this._itemRendererMaps[columnIndex] as Dictionary;
				}
				if(map === null)
				{
					map = new Dictionary(true);
					this._itemRendererMaps[columnIndex] = map;
				}
				map[item] = itemRenderer;
				activeItemRenderers[activeItemRenderers.length] = itemRenderer;
				itemRenderer.addEventListener(Event.TRIGGERED, itemRenderer_triggeredHandler);
				itemRenderer.addEventListener(Event.CHANGE, itemRenderer_changeHandler);
				itemRenderer.addEventListener(FeathersEventType.RESIZE, itemRenderer_resizeHandler);
				this._owner.dispatchEventWith(FeathersEventType.RENDERER_ADD, false, itemRenderer);
			}

			return itemRenderer;
		}

		private function destroyItemRenderer(itemRenderer:IDataGridItemRenderer):void
		{
			itemRenderer.removeEventListener(Event.TRIGGERED, itemRenderer_triggeredHandler);
			itemRenderer.removeEventListener(Event.CHANGE, itemRenderer_changeHandler);
			itemRenderer.removeEventListener(FeathersEventType.RESIZE, itemRenderer_resizeHandler);
			itemRenderer.owner = null;
			itemRenderer.data = null;
			itemRenderer.index = -1;
			itemRenderer.layoutIndex = -1;
			this.removeChild(DisplayObject(itemRenderer), true);
		}

		private function refreshLayoutTypicalItem():void
		{
			var virtualLayout:IVirtualLayout = this._layout as IVirtualLayout;
			if(virtualLayout === null || !virtualLayout.useVirtualLayout)
			{
				//the old layout was virtual, but this one isn't
				if(!this._typicalItemIsInDataProvider && this._typicalItemRenderer !== null)
				{
					//it's safe to destroy this renderer
					this.destroyItemRenderer(this._typicalItemRenderer);
					this._typicalItemRenderer = null;
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
				newTypicalItemIsInDataProvider = true;
				if(this._dataProvider !== null && this._dataProvider.length > 0)
				{
					typicalItem = this._dataProvider.getItemAt(0);
				}
			}

			if(typicalItem !== null)
			{
				var typicalRenderer:IDataGridItemRenderer = null;
				var map:Dictionary = null;
				if(this._itemRendererMaps.length > 0)
				{
					map = this._itemRendererMaps[0] as Dictionary;
				}
				if(map !== null)
				{
					typicalRenderer = map[typicalItem] as IDataGridItemRenderer;
				}
				if(typicalRenderer !== null)
				{
					//at this point, the item already has an item renderer.
					//(this doesn't necessarily mean that the current typical
					//item was the typical item last time this function was
					//called)
					
					//the index may have changed if items were added, removed or
					//reordered in the data provider
					typicalRenderer.index = typicalItemIndex;
				}
				if(typicalRenderer === null && this._typicalItemRenderer)
				{
					//the typical item has changed, and doesn't have an item
					//renderer yet. the previous typical item had an item
					//renderer, so we will try to reuse it.
					
					//we can reuse the existing typical item renderer if the old
					//typical item wasn't in the data provider. otherwise, it
					//may still be needed for the same item.
					var canReuse:Boolean = !this._typicalItemIsInDataProvider;
					var oldTypicalItemRemoved:Boolean = this._typicalItemIsInDataProvider &&
						this._dataProvider && this._dataProvider.getItemIndex(this._typicalItemRenderer.data) < 0;
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
						if(this._typicalItemIsInDataProvider)
						{
							delete map[this._typicalItemRenderer.data];
						}
						typicalRenderer = this._typicalItemRenderer;
						typicalRenderer.data = typicalItem;
						typicalRenderer.index = typicalItemIndex;
						var column:DataGridColumn = DataGridColumn(this._columns.getItemAt(0));
						typicalRenderer.dataField = column.dataField;
						//if the new typical item is in the data provider, add it
						//to the renderer map.
						if(newTypicalItemIsInDataProvider)
						{
							map[typicalItem] = typicalRenderer;
						}
					}
				}
				if(typicalRenderer === null)
				{
					//if we still don't have a typical item renderer, we need to
					//create a new one.
					typicalRenderer = this.createItemRenderer(typicalItem, typicalItemIndex, 0, 0, false, !newTypicalItemIsInDataProvider);
					if(!this._typicalItemIsInDataProvider && this._typicalItemRenderer !== null)
					{
						//get rid of the old typical item renderer if it isn't
						//needed anymore.  since it was not in the data
						//provider, we don't need to mess with the renderer map
						//dictionary or dispatch any events.
						this.destroyItemRenderer(this._typicalItemRenderer);
						this._typicalItemRenderer = null;
					}
				}
			}

			virtualLayout.typicalItem = DisplayObject(typicalRenderer);
			this._typicalItemRenderer = typicalRenderer;
			this._typicalItemIsInDataProvider = newTypicalItemIsInDataProvider;
			if(this._typicalItemRenderer !== null && !this._typicalItemIsInDataProvider)
			{
				//we need to know if this item renderer resizes to adjust the
				//layout because the layout may use this item renderer to resize
				//the other item renderers
				this._typicalItemRenderer.addEventListener(FeathersEventType.RESIZE, itemRenderer_resizeHandler);
			}
		}

		private function refreshItemRenderers():void
		{
			if(this._typicalItemRenderer !== null && this._typicalItemIsInDataProvider)
			{
				var storage:ItemRendererFactoryStorage = this._itemStorage[0];
				var inactiveItemRenderers:Vector.<IDataGridItemRenderer> = storage.inactiveItemRenderers;
				var activeItemRenderers:Vector.<IDataGridItemRenderer> = storage.activeItemRenderers;
				//this renderer is already is use by the typical item, so we
				//don't want to allow it to be used by other items.
				var inactiveIndex:int = inactiveItemRenderers.indexOf(this._typicalItemRenderer);
				if(inactiveIndex >= 0)
				{
					inactiveItemRenderers[inactiveIndex] = null;
				}
				//if refreshLayoutTypicalItem() was called, it will have already
				//added the typical item renderer to the active renderers. if
				//not, we need to do it here.
				var activeRendererCount:int = activeItemRenderers.length;
				if(activeRendererCount === 0)
				{
					activeItemRenderers[activeRendererCount] = this._typicalItemRenderer;
				}
			}

			this.findUnrenderedData();
			var count:int = this._itemStorage.length;
			for(var i:int = 0; i < count; i++)
			{
				storage = this._itemStorage[i];
				this.recoverInactiveItemRenderers(storage);
			}
			this.renderUnrenderedData();
			for(i = 0; i < count; i++)
			{
				storage = this._itemStorage[i];
				this.freeInactiveItemRenderers(storage, this._minimumItemCount);
			}
			this._updateForDataReset = false;
		}

		private function findUnrenderedData():void
		{
			var columnCount:int = 0;
			if(this._columns !== null)
			{
				columnCount = this._columns.length;
			}
			var itemCount:int = 0;
			if(this._dataProvider !== null)
			{
				itemCount = this._dataProvider.length;
			}
			itemCount *= columnCount;
			var virtualLayout:IVirtualLayout = this._layout as IVirtualLayout;
			var useVirtualLayout:Boolean = virtualLayout && virtualLayout.useVirtualLayout;
			if(useVirtualLayout)
			{
				var point:Point = Pool.getPoint();
				virtualLayout.measureViewPort(itemCount, this._viewPortBounds, point);
				virtualLayout.getVisibleIndicesAtScrollPosition(this._horizontalScrollPosition, this._verticalScrollPosition, point.x, point.y, itemCount, HELPER_VECTOR);
				Pool.putPoint(point);
			}

			this._layoutItems.length = itemCount;

			var unrenderedItemCount:int = itemCount;
			if(useVirtualLayout)
			{
				unrenderedItemCount = HELPER_VECTOR.length;
			}
			if(useVirtualLayout && this._typicalItemIsInDataProvider && this._typicalItemRenderer &&
				HELPER_VECTOR.indexOf(this._typicalItemRenderer.index) >= 0)
			{
				//add an extra item renderer if the typical item is from the
				//data provider and it is visible. this helps keep the number of
				//item renderers constant!
				this._minimumItemCount = unrenderedItemCount + 1;
			}
			else
			{
				this._minimumItemCount = unrenderedItemCount;
			}

			var unrenderedDataLastIndex:int = this._unrenderedItems.length;
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
				var rowIndex:int = index / columnCount;
				var columnIndex:int = index % columnCount;
				var item:Object = this._dataProvider.getItemAt(rowIndex);

				var itemRenderer:IDataGridItemRenderer = null;
				var map:Dictionary = null;
				if(this._itemRendererMaps.length > columnIndex)
				{
					map = this._itemRendererMaps[columnIndex] as Dictionary;
				}
				if(map !== null)
				{
					itemRenderer = map[item] as IDataGridItemRenderer;
				}
				if(itemRenderer !== null)
				{
					//the index may have changed if items were added, removed or
					//reordered in the data provider
					itemRenderer.index = rowIndex;
					itemRenderer.layoutIndex = index;
					//if this item renderer used to be the typical item
					//renderer, but it isn't anymore, it may have been set invisible!
					itemRenderer.visible = true;
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
						itemRenderer.data = null;
						itemRenderer.data = item;
					}

					//the typical item renderer is a special case, and we will
					//have already put it into the active renderers, so we don't
					//want to do it again!
					if(this._typicalItemRenderer !== itemRenderer)
					{
						var storage:ItemRendererFactoryStorage = this._itemStorage[columnIndex];
						var activeItemRenderers:Vector.<IDataGridItemRenderer> = storage.activeItemRenderers;
						var inactiveItemRenderers:Vector.<IDataGridItemRenderer> = storage.inactiveItemRenderers;
						activeItemRenderers[activeItemRenderers.length] = itemRenderer;
						var inactiveIndex:int = inactiveItemRenderers.indexOf(itemRenderer);
						if(inactiveIndex >= 0)
						{
							inactiveItemRenderers[inactiveIndex] = null;
						}
						else
						{
							throw new IllegalOperationError("DataGridDataViewPort: renderer map contains bad data. This may be caused by duplicate items in the data provider, which is not allowed.");
						}
					}
					this._layoutItems[index] = DisplayObject(itemRenderer);
				}
				else
				{
					this._unrenderedItems[unrenderedDataLastIndex] = rowIndex;
					unrenderedDataLastIndex++;
					this._unrenderedItems[unrenderedDataLastIndex] = columnIndex;
					unrenderedDataLastIndex++;
					this._unrenderedItems[unrenderedDataLastIndex] = index;
					unrenderedDataLastIndex++;
				}
			}
			//update the typical item renderer's visibility
			if(this._typicalItemRenderer !== null)
			{
				if(useVirtualLayout && this._typicalItemIsInDataProvider)
				{
					index = HELPER_VECTOR.indexOf(this._typicalItemRenderer.index);
					if(index >= 0)
					{
						this._typicalItemRenderer.visible = true;
					}
					else
					{
						this._typicalItemRenderer.visible = false;

						//uncomment these lines to see a hidden typical item for
						//debugging purposes...
						/*this._typicalItemRenderer.visible = true;
						this._typicalItemRenderer.x = this._horizontalScrollPosition;
						this._typicalItemRenderer.y = this._verticalScrollPosition;*/
					}
				}
				else
				{
					this._typicalItemRenderer.visible = this._typicalItemIsInDataProvider;
				}
			}
			HELPER_VECTOR.length = 0;
		}

		private function renderUnrenderedData():void
		{
			var itemRendererCount:int = this._unrenderedItems.length;
			for(var i:int = 0; i < itemRendererCount; i += 3)
			{
				var rowIndex:int = this._unrenderedItems.shift();
				var columnIndex:int = this._unrenderedItems.shift();
				var layoutIndex:int = this._unrenderedItems.shift();
				var item:Object = this._dataProvider.getItemAt(rowIndex);
				var itemRenderer:IDataGridItemRenderer = this.createItemRenderer(
					item, rowIndex, columnIndex, layoutIndex, true, false);
				itemRenderer.visible = true;
				this._layoutItems[layoutIndex] = DisplayObject(itemRenderer);
			}
		}

		private function refreshSelection():void
		{
			for each(var item:DisplayObject in this._layoutItems)
			{
				var itemRenderer:IDataGridItemRenderer = item as IDataGridItemRenderer;
				if(itemRenderer !== null)
				{
					itemRenderer.isSelected = this._selectedIndices.getItemIndex(itemRenderer.index) >= 0;
				}
			}
		}

		private function refreshEnabled():void
		{
			for each(var item:DisplayObject in this._layoutItems)
			{
				var control:IFeathersControl = item as IFeathersControl;
				if(control !== null)
				{
					control.isEnabled = this._isEnabled;
				}
			}
		}

		private function validateItemRenderers():void
		{
			var itemCount:int = this._layoutItems.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:IValidating = this._layoutItems[i] as IValidating;
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
			/*var map:Dictionary = this._itemRendererMaps[columnIndex] as Dictionary;
			var itemRenderers:Vector.<IDataGridItemRenderer> = this._itemRendererMap[item] as Vector.<IDataGridItemRenderer>;
			if(itemRenderers === null)
			{
				return;
			}
			var count:int = itemRenderers.length;
			for(var i:int = 0; i < count; i++)
			{
				//in order to display the same item with modified properties, this
				//hack tricks the item renderer into thinking that it has been given
				//a different item to render.
				var itemRenderer:IDataGridItemRenderer = itemRenderers[i];
				itemRenderer.data = null;
				itemRenderer.data = item;
			}
			if(this._explicitVisibleWidth !== this._explicitVisibleWidth ||
				this._explicitVisibleHeight !== this._explicitVisibleHeight)
			{
				this.invalidate(INVALIDATION_FLAG_SIZE);
				this.invalidateParent(INVALIDATION_FLAG_SIZE);
			}*/
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

		private function itemRenderer_triggeredHandler(event:Event):void
		{
			var itemRenderer:IDataGridItemRenderer = IDataGridItemRenderer(event.currentTarget);
			this.parent.dispatchEventWith(Event.TRIGGERED, false, itemRenderer.data);
		}

		private function itemRenderer_changeHandler(event:Event):void
		{
			if(this._ignoreSelectionChanges)
			{
				return;
			}
			var itemRenderer:IDataGridItemRenderer = IDataGridItemRenderer(event.currentTarget);
			if(!this._isSelectable || this._owner.isScrolling)
			{
				itemRenderer.isSelected = false;
				return;
			}
			var isSelected:Boolean = itemRenderer.isSelected;
			var index:int = itemRenderer.index;
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

		private function itemRenderer_resizeHandler(event:Event):void
		{
			if(this._ignoreRendererResizing)
			{
				return;
			}
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
			this.invalidateParent(INVALIDATION_FLAG_LAYOUT);
			if(event.currentTarget === this._typicalItemRenderer && !this._typicalItemIsInDataProvider)
			{
				return;
			}
			var layout:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
			if(!layout || !layout.hasVariableItemDimensions)
			{
				return;
			}
			var itemRenderer:IDataGridItemRenderer = IDataGridItemRenderer(event.currentTarget);
			layout.resetVariableVirtualCacheAtIndex(itemRenderer.layoutIndex, DisplayObject(itemRenderer));
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

import feathers.controls.renderers.IDataGridItemRenderer;

class ItemRendererFactoryStorage
{
	public function ItemRendererFactoryStorage()
	{

	}
	
	public var activeItemRenderers:Vector.<IDataGridItemRenderer> = new <IDataGridItemRenderer>[];
	public var inactiveItemRenderers:Vector.<IDataGridItemRenderer> = new <IDataGridItemRenderer>[];
	public var factory:Function = null;
	public var customItemRendererStyleName:String = null;
	public var columnIndex:int = -1;
}