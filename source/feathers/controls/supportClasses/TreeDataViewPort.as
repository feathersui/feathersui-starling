/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.supportClasses
{
	import feathers.core.FeathersControl;
	import feathers.controls.Tree;
	import feathers.layout.IVariableVirtualLayout;
	import feathers.layout.ILayout;
	import feathers.controls.Scroller;
	import feathers.data.IHierarchicalCollection;
	import feathers.controls.renderers.ITreeItemRenderer;

	import starling.events.Event;
	import feathers.layout.ViewPortBounds;
	import feathers.layout.LayoutBoundsResult;
	import starling.display.DisplayObject;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.errors.IllegalOperationError;
	import feathers.events.FeathersEventType;
	import feathers.events.CollectionEventType;

	public class TreeDataViewPort extends FeathersControl implements IViewPort
	{
		private static const INVALIDATION_FLAG_ITEM_RENDERER_FACTORY:String = "itemRendererFactory";

		public function TreeDataViewPort()
		{
			super();
		}

		private var _viewPortBounds:ViewPortBounds = new ViewPortBounds();

		private var _layoutResult:LayoutBoundsResult = new LayoutBoundsResult();

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

		private var _actualVisibleWidth:Number = NaN;

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

		private var _actualVisibleHeight:Number;

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

		public function get horizontalScrollStep():Number
		{
			if(this._typicalItemRenderer === null)
			{
				return 0;
			}
			var itemRendererWidth:Number = this._typicalItemRenderer.width;
			var itemRendererHeight:Number = this._typicalItemRenderer.height;
			if(itemRendererWidth < itemRendererHeight)
			{
				return itemRendererWidth;
			}
			return itemRendererHeight;
		}

		public function get verticalScrollStep():Number
		{
			if(this._typicalItemRenderer === null)
			{
				return 0;
			}
			var itemRendererWidth:Number = this._typicalItemRenderer.width;
			var itemRendererHeight:Number = this._typicalItemRenderer.height;
			if(itemRendererWidth < itemRendererHeight)
			{
				return itemRendererWidth;
			}
			return itemRendererHeight;
		}

		private var _owner:Tree;

		public function get owner():Tree
		{
			return this._owner;
		}

		public function set owner(value:Tree):void
		{
			this._owner = value;
		}

		private var _updateForDataReset:Boolean = false;

		private var _dataProvider:IHierarchicalCollection;

		public function get dataProvider():IHierarchicalCollection
		{
			return this._dataProvider;
		}

		public function set dataProvider(value:IHierarchicalCollection):void
		{
			if(this._dataProvider == value)
			{
				return;
			}
			if(this._dataProvider)
			{
				this._dataProvider.removeEventListener(Event.CHANGE, dataProvider_changeHandler);
				/*this._dataProvider.removeEventListener(CollectionEventType.RESET, dataProvider_resetHandler);
				this._dataProvider.removeEventListener(CollectionEventType.ADD_ITEM, dataProvider_addItemHandler);
				this._dataProvider.removeEventListener(CollectionEventType.REMOVE_ITEM, dataProvider_removeItemHandler);
				this._dataProvider.removeEventListener(CollectionEventType.REPLACE_ITEM, dataProvider_replaceItemHandler);
				this._dataProvider.removeEventListener(CollectionEventType.UPDATE_ITEM, dataProvider_updateItemHandler);
				this._dataProvider.removeEventListener(CollectionEventType.UPDATE_ALL, dataProvider_updateAllHandler);*/
			}
			this._dataProvider = value;
			if(this._dataProvider)
			{
				this._dataProvider.addEventListener(Event.CHANGE, dataProvider_changeHandler);
				/*this._dataProvider.addEventListener(CollectionEventType.RESET, dataProvider_resetHandler);
				this._dataProvider.addEventListener(CollectionEventType.ADD_ITEM, dataProvider_addItemHandler);
				this._dataProvider.addEventListener(CollectionEventType.REMOVE_ITEM, dataProvider_removeItemHandler);
				this._dataProvider.addEventListener(CollectionEventType.REPLACE_ITEM, dataProvider_replaceItemHandler);
				this._dataProvider.addEventListener(CollectionEventType.UPDATE_ITEM, dataProvider_updateItemHandler);
				this._dataProvider.addEventListener(CollectionEventType.UPDATE_ALL, dataProvider_updateAllHandler);*/
			}
			if(this._layout is IVariableVirtualLayout)
			{
				IVariableVirtualLayout(this._layout).resetVariableVirtualCache();
			}
			this._updateForDataReset = true;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		private var _ignoreLayoutChanges:Boolean = false;
		private var _ignoreRendererResizing:Boolean = false;

		private var _layout:ILayout;

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
					var variableVirtualLayout:IVariableVirtualLayout = IVariableVirtualLayout(this._layout);

					//headers and footers are almost always going to have a
					//different height, so we might as well force it because if
					//we don't, there will be a lot of support requests
					variableVirtualLayout.hasVariableItemDimensions = true;
					
					variableVirtualLayout.resetVariableVirtualCache();
				}
				this._layout.addEventListener(Event.CHANGE, layout_changeHandler);
			}
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
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

		public function get requiresMeasurementOnScroll():Boolean
		{
			return this._layout.requiresLayoutOnScroll &&
				(this._explicitVisibleWidth !== this._explicitVisibleWidth ||
				this._explicitVisibleHeight !== this._explicitVisibleHeight);
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
			if(!this._isSelectable)
			{
				this.selectedItem = null;
			}
			this.invalidate(INVALIDATION_FLAG_SELECTED);
		}

		private var _selectedItem:Object = null;

		public function get selectedItem():Object
		{
			return this._selectedItem;
		}

		public function set selectedItem(value:Object):void
		{
			if(this._selectedItem == value)
			{
				return;
			}
			this._selectedItem = value;
			this.invalidate(INVALIDATION_FLAG_SELECTED);
			this.dispatchEventWith(Event.CHANGE);
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

		private var _itemRendererType:Class;

		public function get itemRendererType():Class
		{
			return this._itemRendererType;
		}

		public function set itemRendererType(value:Class):void
		{
			if(this._itemRendererType == value)
			{
				return;
			}

			this._itemRendererType = value;
			this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		}

		private var _itemRendererFactory:Function;

		public function get itemRendererFactory():Function
		{
			return this._itemRendererFactory;
		}

		public function set itemRendererFactory(value:Function):void
		{
			if(this._itemRendererFactory === value)
			{
				return;
			}

			this._itemRendererFactory = value;
			this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		}

		private var _itemRendererFactories:Object;

		public function get itemRendererFactories():Object
		{
			return this._itemRendererFactories;
		}

		public function set itemRendererFactories(value:Object):void
		{
			if(this._itemRendererFactories === value)
			{
				return;
			}

			this._itemRendererFactories = value;
			this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		}

		private var _factoryIDFunction:Function;

		public function get factoryIDFunction():Function
		{
			return this._factoryIDFunction;
		}

		public function set factoryIDFunction(value:Function):void
		{
			if(this._factoryIDFunction === value)
			{
				return;
			}

			this._factoryIDFunction = value;
			this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		}

		private var _customItemRendererStyleName:String;

		public function get customItemRendererStyleName():String
		{
			return this._customItemRendererStyleName;
		}

		public function set customItemRendererStyleName(value:String):void
		{
			if(this._customItemRendererStyleName == value)
			{
				return;
			}
			this._customItemRendererStyleName = value;
			this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		}

		private var _typicalItemIsInDataProvider:Boolean = false;
		private var _typicalItemRenderer:ITreeItemRenderer;

		private var _layoutItems:Vector.<DisplayObject> = new <DisplayObject>[];

		private var _unrenderedItems:Vector.<int> = new <int>[];
		private var _defaultItemRendererStorage:ItemRendererFactoryStorage = new ItemRendererFactoryStorage();
		private var _itemStorageMap:Object = {};
		private var _itemRendererMap:Dictionary = new Dictionary(true);

		public function calculateNavigationDestination(groupIndex:int, itemIndex:int, keyCode:uint, result:Vector.<int>):void
		{
			var displayIndex:int = this.locationToDisplayIndex(groupIndex, itemIndex);
			var newDisplayIndex:int = this._layout.calculateNavigationDestination(this._layoutItems, displayIndex, keyCode, this._layoutResult);
			this.displayIndexToLocation(newDisplayIndex, result);
			trace(displayIndex, newDisplayIndex, result);
		}

		public function getScrollPositionForIndex(groupIndex:int, itemIndex:int, result:Point = null):Point
		{
			if(!result)
			{
				result = new Point();
			}

			var displayIndex:int = this.locationToDisplayIndex(groupIndex, itemIndex);
			return this._layout.getScrollPositionForIndex(displayIndex, this._layoutItems,
				0, 0, this._actualVisibleWidth, this._actualVisibleHeight, result);
		}

		public function getNearestScrollPositionForIndex(groupIndex:int, itemIndex:int, result:Point = null):Point
		{
			if(!result)
			{
				result = new Point();
			}

			var displayIndex:int = this.locationToDisplayIndex(groupIndex, itemIndex);
			return this._layout.getNearestScrollPositionForIndex(displayIndex, this._horizontalScrollPosition,
				this._verticalScrollPosition, this._layoutItems, 0, 0, this._actualVisibleWidth, this._actualVisibleHeight, result);
		}

		public function itemToItemRenderer(item:Object):ITreeItemRenderer
		{
			return ITreeItemRenderer(this._itemRendererMap[item]);
		}

		override public function dispose():void
		{
			this.refreshInactiveItemRenderers(null, true);
			if(this._itemStorageMap)
			{
				for(var factoryID:String in this._itemStorageMap)
				{
					this.refreshInactiveItemRenderers(factoryID, true);
				}
			}
			this.owner = null;
			this.dataProvider = null;
			this.layout = null;
			super.dispose();
		}

		override protected function draw():void
		{
			var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			var scrollInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SCROLL);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			var selectionInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SELECTED);
			var itemRendererInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
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
		}

		private function displayIndexToLocation(displayIndex:int, result:Vector.<int>):void
		{
		}

		private function locationToDisplayIndex(groupIndex:int, itemIndex:int):int
		{
			return -1;
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

		private function refreshInactiveItemRenderers(factoryID:String, itemRendererTypeIsInvalid:Boolean):void
		{
			if(factoryID !== null)
			{
				var storage:ItemRendererFactoryStorage = ItemRendererFactoryStorage(this._itemStorageMap[factoryID]);
			}
			else
			{
				storage = this._defaultItemRendererStorage;
			}
			var temp:Vector.<ITreeItemRenderer> = storage.inactiveItemRenderers;
			storage.inactiveItemRenderers = storage.activeItemRenderers;
			storage.activeItemRenderers = temp;
			if(storage.activeItemRenderers.length > 0)
			{
				throw new IllegalOperationError("ListDataViewPort: active renderers should be empty.");
			}
			if(itemRendererTypeIsInvalid)
			{
				this.recoverInactiveItemRenderers(storage);
				this.freeInactiveItemRenderers(storage, 0);
				if(this._typicalItemRenderer && this._typicalItemRenderer.factoryID === factoryID)
				{
					if(this._typicalItemIsInDataProvider)
					{
						delete this._itemRendererMap[this._typicalItemRenderer.data];
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
			var inactiveItemRenderers:Vector.<ITreeItemRenderer> = storage.inactiveItemRenderers;
			
			var itemCount:int = inactiveItemRenderers.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var itemRenderer:ITreeItemRenderer = inactiveItemRenderers[i];
				if(itemRenderer === null || itemRenderer.data === null)
				{
					continue;
				}
				this._owner.dispatchEventWith(FeathersEventType.RENDERER_REMOVE, false, itemRenderer);
				delete this._itemRendererMap[itemRenderer.data];
			}
		}

		private function freeInactiveItemRenderers(storage:ItemRendererFactoryStorage, minimumItemCount:int):void
		{
			var inactiveItemRenderers:Vector.<ITreeItemRenderer> = storage.inactiveItemRenderers;
			var activeItemRenderers:Vector.<ITreeItemRenderer> = storage.activeItemRenderers;
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
				var itemRenderer:ITreeItemRenderer = inactiveItemRenderers.shift();
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

		private function createItemRenderer(item:Object, layoutIndex:int, useCache:Boolean, isTemporary:Boolean):ITreeItemRenderer
		{
			var factoryID:String = null;
			if(this._factoryIDFunction !== null)
			{
				factoryID = this.getFactoryID(item);
			}
			var itemRendererFactory:Function = this.factoryIDToFactory(factoryID);
			var storage:ItemRendererFactoryStorage = this.factoryIDToStorage(factoryID);
			var inactiveItemRenderers:Vector.<ITreeItemRenderer> = storage.inactiveItemRenderers;
			var activeItemRenderers:Vector.<ITreeItemRenderer> = storage.activeItemRenderers;
			var itemRenderer:ITreeItemRenderer;
			do
			{
				if(!useCache || isTemporary || inactiveItemRenderers.length === 0)
				{
					if(itemRendererFactory !== null)
					{
						itemRenderer = ITreeItemRenderer(itemRendererFactory());
					}
					else
					{
						itemRenderer = ITreeItemRenderer(new this._itemRendererType());
					}
					if(this._customItemRendererStyleName && this._customItemRendererStyleName.length > 0)
					{
						itemRenderer.styleNameList.add(this._customItemRendererStyleName);
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
			itemRenderer.owner = this._owner;
			itemRenderer.factoryID = factoryID;
			itemRenderer.layoutIndex = layoutIndex;

			if(!isTemporary)
			{
				this._itemRendererMap[item] = itemRenderer;
				activeItemRenderers[activeItemRenderers.length] = itemRenderer;
				itemRenderer.addEventListener(Event.TRIGGERED, itemRenderer_triggeredHandler);
				itemRenderer.addEventListener(Event.CHANGE, itemRenderer_changeHandler);
				itemRenderer.addEventListener(FeathersEventType.RESIZE, itemRenderer_resizeHandler);
				this._owner.dispatchEventWith(FeathersEventType.RENDERER_ADD, false, itemRenderer);
			}

			return itemRenderer;
		}

		private function destroyItemRenderer(itemRenderer:ITreeItemRenderer):void
		{
			itemRenderer.removeEventListener(Event.TRIGGERED, itemRenderer_triggeredHandler);
			itemRenderer.removeEventListener(Event.CHANGE, itemRenderer_changeHandler);
			itemRenderer.removeEventListener(FeathersEventType.RESIZE, itemRenderer_resizeHandler);
			itemRenderer.owner = null;
			itemRenderer.data = null;
			itemRenderer.factoryID = null;
			this.removeChild(DisplayObject(itemRenderer), true);
		}
		
		private function getFactoryID(item:Object):String
		{
			if(this._factoryIDFunction === null)
			{
				return null;
			}
			return this._factoryIDFunction(item);
		}
		
		private function factoryIDToFactory(id:String):Function
		{
			if(id !== null)
			{
				if(id in this._itemRendererFactories)
				{
					return this._itemRendererFactories[id] as Function;
				}
				else
				{
					throw new ReferenceError("Cannot find item renderer factory for ID \"" + id + "\".")
				}
			}
			return this._itemRendererFactory;
		}

		private function factoryIDToStorage(id:String):ItemRendererFactoryStorage
		{
			if(id !== null)
			{
				if(id in this._itemStorageMap)
				{
					return ItemRendererFactoryStorage(this._itemStorageMap[id]);
				}
				var storage:ItemRendererFactoryStorage = new ItemRendererFactoryStorage();
				this._itemStorageMap[id] = storage;
				return storage;
			}
			return this._defaultItemRendererStorage;
		}

		private function invalidateParent(flag:String = INVALIDATION_FLAG_ALL):void
		{
			Scroller(this.parent).invalidate(flag);
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

		private function dataProvider_changeHandler(event:Event):void
		{
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		private function itemRenderer_triggeredHandler(event:Event):void
		{
			var itemRenderer:ITreeItemRenderer = ITreeItemRenderer(event.currentTarget);
			this.parent.dispatchEventWith(Event.TRIGGERED, false, itemRenderer.data);
		}

		private function itemRenderer_changeHandler(event:Event):void
		{
			if(this._ignoreSelectionChanges)
			{
				return;
			}
			var itemRenderer:ITreeItemRenderer = ITreeItemRenderer(event.currentTarget);
			if(!this._isSelectable || this._owner.isScrolling)
			{
				itemRenderer.isSelected = false;
				return;
			}
			var isSelected:Boolean = itemRenderer.isSelected;
			if(isSelected)
			{
				this.selectedItem = itemRenderer.data;
			}
			else
			{
				this.selectedItem = null;
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
			var itemRenderer:ITreeItemRenderer = ITreeItemRenderer(event.currentTarget);
			layout.resetVariableVirtualCacheAtIndex(itemRenderer.layoutIndex, DisplayObject(itemRenderer));
		}
	}
}

import feathers.controls.renderers.ITreeItemRenderer;

class ItemRendererFactoryStorage
{
	public function ItemRendererFactoryStorage()
	{

	}
	
	public var activeItemRenderers:Vector.<ITreeItemRenderer> = new <ITreeItemRenderer>[];
	public var inactiveItemRenderers:Vector.<ITreeItemRenderer> = new <ITreeItemRenderer>[];
}