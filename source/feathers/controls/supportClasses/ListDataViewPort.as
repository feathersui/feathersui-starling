/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.supportClasses
{
	import feathers.controls.List;
	import feathers.controls.Scroller;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.FeathersControl;
	import feathers.core.IFeathersControl;
	import feathers.core.PropertyProxy;
	import feathers.data.ListCollection;
	import feathers.events.CollectionEventType;
	import feathers.events.FeathersEventType;
	import feathers.layout.ILayout;
	import feathers.layout.ITrimmedVirtualLayout;
	import feathers.layout.IVariableVirtualLayout;
	import feathers.layout.IVirtualLayout;
	import feathers.layout.LayoutBoundsResult;
	import feathers.layout.ViewPortBounds;

	import flash.errors.IllegalOperationError;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * @private
	 * Used internally by List. Not meant to be used on its own.
	 */
	public final class ListDataViewPort extends FeathersControl implements IViewPort
	{
		private static const INVALIDATION_FLAG_ITEM_RENDERER_FACTORY:String = "itemRendererFactory";

		private static const HELPER_POINT:Point = new Point();
		private static const HELPER_VECTOR:Vector.<int> = new <int>[];

		public function ListDataViewPort()
		{
			super();
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			this.addEventListener(TouchEvent.TOUCH, touchHandler);
		}

		private var touchPointID:int = -1;

		private var _viewPortBounds:ViewPortBounds = new ViewPortBounds();

		private var _layoutResult:LayoutBoundsResult = new LayoutBoundsResult();

		private var _minVisibleWidth:Number = 0;

		public function get minVisibleWidth():Number
		{
			return this._minVisibleWidth;
		}

		public function set minVisibleWidth(value:Number):void
		{
			if(this._minVisibleWidth == value)
			{
				return;
			}
			if(isNaN(value))
			{
				throw new ArgumentError("minVisibleWidth cannot be NaN");
			}
			this._minVisibleWidth = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
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
			if(isNaN(value))
			{
				throw new ArgumentError("maxVisibleWidth cannot be NaN");
			}
			this._maxVisibleWidth = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		private var actualVisibleWidth:Number = 0;

		private var explicitVisibleWidth:Number = NaN;

		public function get visibleWidth():Number
		{
			return this.actualVisibleWidth;
		}

		public function set visibleWidth(value:Number):void
		{
			if(this.explicitVisibleWidth == value || (isNaN(value) && isNaN(this.explicitVisibleWidth)))
			{
				return;
			}
			this.explicitVisibleWidth = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		private var _minVisibleHeight:Number = 0;

		public function get minVisibleHeight():Number
		{
			return this._minVisibleHeight;
		}

		public function set minVisibleHeight(value:Number):void
		{
			if(this._minVisibleHeight == value)
			{
				return;
			}
			if(isNaN(value))
			{
				throw new ArgumentError("minVisibleHeight cannot be NaN");
			}
			this._minVisibleHeight = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
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
			if(isNaN(value))
			{
				throw new ArgumentError("maxVisibleHeight cannot be NaN");
			}
			this._maxVisibleHeight = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		private var actualVisibleHeight:Number = 0;

		private var explicitVisibleHeight:Number = NaN;

		public function get visibleHeight():Number
		{
			return this.actualVisibleHeight;
		}

		public function set visibleHeight(value:Number):void
		{
			if(this.explicitVisibleHeight == value || (isNaN(value) && isNaN(this.explicitVisibleHeight)))
			{
				return;
			}
			this.explicitVisibleHeight = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
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

		private var _typicalItemIsInDataProvider:Boolean = false;
		private var _typicalItemRenderer:IListItemRenderer;
		private var _unrenderedData:Array = [];
		private var _layoutItems:Vector.<DisplayObject> = new <DisplayObject>[];
		private var _inactiveRenderers:Vector.<IListItemRenderer> = new <IListItemRenderer>[];
		private var _activeRenderers:Vector.<IListItemRenderer> = new <IListItemRenderer>[];
		private var _rendererMap:Dictionary = new Dictionary(true);

		private var _layoutIndexOffset:int = 0;

		private var _isScrolling:Boolean = false;

		private var _owner:List;

		public function get owner():List
		{
			return this._owner;
		}

		public function set owner(value:List):void
		{
			if(this._owner == value)
			{
				return;
			}
			if(this._owner)
			{
				this._owner.removeEventListener(FeathersEventType.SCROLL_START, owner_scrollStartHandler);
			}
			this._owner = value;
			if(this._owner)
			{
				this._owner.addEventListener(FeathersEventType.SCROLL_START, owner_scrollStartHandler);
			}
		}

		private var _dataProvider:ListCollection;

		public function get dataProvider():ListCollection
		{
			return this._dataProvider;
		}

		public function set dataProvider(value:ListCollection):void
		{
			if(this._dataProvider == value)
			{
				return;
			}
			if(this._dataProvider)
			{
				this._dataProvider.removeEventListener(Event.CHANGE, dataProvider_changeHandler);
				this._dataProvider.removeEventListener(CollectionEventType.RESET, dataProvider_resetHandler);
				this._dataProvider.removeEventListener(CollectionEventType.ADD_ITEM, dataProvider_addItemHandler);
				this._dataProvider.removeEventListener(CollectionEventType.REMOVE_ITEM, dataProvider_removeItemHandler);
				this._dataProvider.removeEventListener(CollectionEventType.REPLACE_ITEM, dataProvider_replaceItemHandler);
				this._dataProvider.removeEventListener(CollectionEventType.UPDATE_ITEM, dataProvider_updateItemHandler);
			}
			this._dataProvider = value;
			if(this._dataProvider)
			{
				this._dataProvider.addEventListener(Event.CHANGE, dataProvider_changeHandler);
				this._dataProvider.addEventListener(CollectionEventType.RESET, dataProvider_resetHandler);
				this._dataProvider.addEventListener(CollectionEventType.ADD_ITEM, dataProvider_addItemHandler);
				this._dataProvider.addEventListener(CollectionEventType.REMOVE_ITEM, dataProvider_removeItemHandler);
				this._dataProvider.addEventListener(CollectionEventType.REPLACE_ITEM, dataProvider_replaceItemHandler);
				this._dataProvider.addEventListener(CollectionEventType.UPDATE_ITEM, dataProvider_updateItemHandler);
			}
			if(this._layout is IVariableVirtualLayout)
			{
				IVariableVirtualLayout(this._layout).resetVariableVirtualCache();
			}
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

		private var _itemRendererName:String;

		public function get itemRendererName():String
		{
			return this._itemRendererName;
		}

		public function set itemRendererName(value:String):void
		{
			if(this._itemRendererName == value)
			{
				return;
			}
			this._itemRendererName = value;
			this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
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

		private var _itemRendererProperties:PropertyProxy;

		public function get itemRendererProperties():PropertyProxy
		{
			return this._itemRendererProperties;
		}

		public function set itemRendererProperties(value:PropertyProxy):void
		{
			if(this._itemRendererProperties == value)
			{
				return;
			}
			if(this._itemRendererProperties)
			{
				this._itemRendererProperties.removeOnChangeCallback(childProperties_onChange);
			}
			this._itemRendererProperties = PropertyProxy(value);
			if(this._itemRendererProperties)
			{
				this._itemRendererProperties.addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
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
				EventDispatcher(this._layout).removeEventListener(Event.CHANGE, layout_changeHandler);
			}
			this._layout = value;
			if(this._layout)
			{
				if(this._layout is IVariableVirtualLayout)
				{
					IVariableVirtualLayout(this._layout).resetVariableVirtualCache();
				}
				EventDispatcher(this._layout).addEventListener(Event.CHANGE, layout_changeHandler);
			}
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
		}

		public function get horizontalScrollStep():Number
		{
			if(this._activeRenderers.length == 0)
			{
				return 0;
			}
			var itemRenderer:IListItemRenderer = this._activeRenderers[0];
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
			if(this._activeRenderers.length == 0)
			{
				return 0;
			}
			var itemRenderer:IListItemRenderer = this._activeRenderers[0];
			var itemRendererWidth:Number = itemRenderer.width;
			var itemRendererHeight:Number = itemRenderer.height;
			if(itemRendererWidth < itemRendererHeight)
			{
				return itemRendererWidth;
			}
			return itemRendererHeight;
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

		public function getScrollPositionForIndex(index:int, result:Point = null):Point
		{
			if(!result)
			{
				result = new Point();
			}
			return this._layout.getScrollPositionForIndex(index, this._layoutItems, 0, 0, this.actualVisibleWidth, this.actualVisibleHeight, result);
		}

		override public function dispose():void
		{
			this.owner = null;
			this.layout = null;
			this.dataProvider = null;
			super.dispose();
		}

		override protected function draw():void
		{
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const scrollInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SCROLL);
			const sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			const selectionInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SELECTED);
			const itemRendererInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			const stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			const layoutInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_LAYOUT);

			var oldIgnoreRendererResizing:Boolean = this._ignoreRendererResizing;
			this._ignoreRendererResizing = true;
			var oldIgnoreLayoutChanges:Boolean = this._ignoreLayoutChanges;
			this._ignoreLayoutChanges = true;
			var oldIgnoreSelectionChanges:Boolean = this._ignoreSelectionChanges;
			this._ignoreSelectionChanges = true;

			if(scrollInvalid || sizeInvalid)
			{
				this.refreshViewPortBounds();
			}
			if(scrollInvalid || sizeInvalid || dataInvalid || layoutInvalid || itemRendererInvalid)
			{
				this.refreshInactiveRenderers(itemRendererInvalid);
			}
			if(stylesInvalid || dataInvalid || layoutInvalid || itemRendererInvalid)
			{
				this.refreshLayoutTypicalItem();
			}
			if(scrollInvalid || sizeInvalid || dataInvalid || layoutInvalid || itemRendererInvalid)
			{
				this.refreshRenderers();
			}
			if(scrollInvalid || stylesInvalid || sizeInvalid || dataInvalid || layoutInvalid || itemRendererInvalid)
			{
				this.refreshItemRendererStyles();
			}
			if(scrollInvalid || selectionInvalid || sizeInvalid || dataInvalid || layoutInvalid || itemRendererInvalid)
			{
				this.refreshSelection();
			}
			if(scrollInvalid || stateInvalid || sizeInvalid || dataInvalid || layoutInvalid || itemRendererInvalid)
			{
				this.refreshEnabled();
			}
			this._ignoreLayoutChanges = oldIgnoreLayoutChanges;
			this._ignoreSelectionChanges = oldIgnoreSelectionChanges;

			this._layout.layout(this._layoutItems, this._viewPortBounds, this._layoutResult);

			this._ignoreRendererResizing = oldIgnoreRendererResizing;

			this._contentX = this._layoutResult.contentX;
			this._contentY = this._layoutResult.contentY;
			this.setSizeInternal(this._layoutResult.contentWidth, this._layoutResult.contentHeight, false);
			this.actualVisibleWidth = this._layoutResult.viewPortWidth;
			this.actualVisibleHeight = this._layoutResult.viewPortHeight;

			//final validation to avoid juggler next frame issues
			this.validateItemRenderers();
		}
		
		private function invalidateParent(flag:String = INVALIDATION_FLAG_ALL):void
		{
			Scroller(this.parent).invalidate(flag);
		}

		private function validateItemRenderers():void
		{
			var rendererCount:int = this._activeRenderers.length;
			for(var i:int = 0; i < rendererCount; i++)
			{
				var renderer:IListItemRenderer = this._activeRenderers[i];
				renderer.validate();
			}
		}

		private function refreshLayoutTypicalItem():void
		{
			var virtualLayout:IVirtualLayout = this._layout as IVirtualLayout;

			if(!virtualLayout || !virtualLayout.useVirtualLayout)
			{
				//the old layout was virtual, but this one isn't
				if(!this._typicalItemIsInDataProvider && this._typicalItemRenderer)
				{
					//it's safe to destroy this renderer
					this.destroyRenderer(this._typicalItemRenderer);
					this._typicalItemRenderer = null;
				}
				return;
			}
			var typicalItemIndex:int = 0;
			var newTypicalItemIsInDataProvider:Boolean = false;
			var typicalItem:Object = this._typicalItem;
			if(typicalItem)
			{
				if(this._dataProvider)
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
				if(this._dataProvider && this._dataProvider.length > 0)
				{
					typicalItem = this._dataProvider.getItemAt(0);
				}
				else
				{
					virtualLayout.typicalItem = null;
					return;
				}
			}

			var typicalRenderer:IListItemRenderer = IListItemRenderer(this._rendererMap[typicalItem]);
			if(!typicalRenderer && !newTypicalItemIsInDataProvider && !this._typicalItemIsInDataProvider && this._typicalItemRenderer)
			{
				//can use reuse the old item renderer instance
				//since it is not in the data provider, we don't need to mess
				//with the renderer map dictionary.
				typicalRenderer = this._typicalItemRenderer;
				typicalRenderer.data = typicalItem;
				typicalRenderer.index = typicalItemIndex;
			}
			if(!typicalRenderer)
			{
				typicalRenderer = this.createRenderer(typicalItem, typicalItemIndex, false, !newTypicalItemIsInDataProvider);
				if(!this._typicalItemIsInDataProvider && this._typicalItemRenderer)
				{
					//get rid of the old one if it isn't needed anymore
					//since it is not in the data provider, we don't need to mess
					//with the renderer map dictionary.
					this.destroyRenderer(this._typicalItemRenderer);
					this._typicalItemRenderer = null;
				}
			}

			this.refreshOneItemRendererStyles(typicalRenderer);
			virtualLayout.typicalItem = DisplayObject(typicalRenderer);
			this._typicalItemRenderer = typicalRenderer;
			this._typicalItemIsInDataProvider = newTypicalItemIsInDataProvider;
		}

		private function refreshItemRendererStyles():void
		{
			for each(var renderer:IListItemRenderer in this._activeRenderers)
			{
				this.refreshOneItemRendererStyles(renderer);
			}
		}

		private function refreshOneItemRendererStyles(renderer:IListItemRenderer):void
		{
			const displayRenderer:DisplayObject = DisplayObject(renderer);
			for(var propertyName:String in this._itemRendererProperties)
			{
				if(displayRenderer.hasOwnProperty(propertyName))
				{
					var propertyValue:Object = this._itemRendererProperties[propertyName];
					displayRenderer[propertyName] = propertyValue;
				}
			}
		}

		private function refreshSelection():void
		{
			const rendererCount:int = this._activeRenderers.length;
			for(var i:int = 0; i < rendererCount; i++)
			{
				var renderer:IListItemRenderer = this._activeRenderers[i];
				renderer.isSelected = this._selectedIndices.getItemIndex(renderer.index) >= 0;
			}
		}

		private function refreshEnabled():void
		{
			const rendererCount:int = this._activeRenderers.length;
			for(var i:int = 0; i < rendererCount; i++)
			{
				const itemRenderer:IFeathersControl = IFeathersControl(this._activeRenderers[i]);
				itemRenderer.isEnabled = this._isEnabled;
			}
		}

		private function refreshViewPortBounds():void
		{
			this._viewPortBounds.x = this._viewPortBounds.y = 0;
			this._viewPortBounds.scrollX = this._horizontalScrollPosition;
			this._viewPortBounds.scrollY = this._verticalScrollPosition;
			this._viewPortBounds.explicitWidth = this.explicitVisibleWidth;
			this._viewPortBounds.explicitHeight = this.explicitVisibleHeight;
			this._viewPortBounds.minWidth = this._minVisibleWidth;
			this._viewPortBounds.minHeight = this._minVisibleHeight;
			this._viewPortBounds.maxWidth = this._maxVisibleWidth;
			this._viewPortBounds.maxHeight = this._maxVisibleHeight;
		}

		private function refreshInactiveRenderers(itemRendererTypeIsInvalid:Boolean):void
		{
			const temp:Vector.<IListItemRenderer> = this._inactiveRenderers;
			this._inactiveRenderers = this._activeRenderers;
			this._activeRenderers = temp;
			if(this._activeRenderers.length > 0)
			{
				throw new IllegalOperationError("ListDataViewPort: active renderers should be empty.");
			}
			if(itemRendererTypeIsInvalid)
			{
				this.recoverInactiveRenderers();
				this.freeInactiveRenderers();
				if(this._typicalItemRenderer)
				{
					if(this._typicalItemIsInDataProvider)
					{
						delete this._rendererMap[this._typicalItemRenderer.data];
					}
					this.destroyRenderer(this._typicalItemRenderer);
					this._typicalItemRenderer = null;
					this._typicalItemIsInDataProvider = false;
				}
			}

			this._layoutItems.length = 0;
		}

		private function refreshRenderers():void
		{
			if(this._typicalItemRenderer && this._typicalItemIsInDataProvider)
			{
				//this renderer is already is use by the typical item, so we
				//don't want to allow it to be used by other items.
				var inactiveIndex:int = this._inactiveRenderers.indexOf(this._typicalItemRenderer);
				if(inactiveIndex >= 0)
				{
					this._inactiveRenderers[inactiveIndex] = null;
				}
				//if refreshLayoutTypicalItem() was called, it will have already
				//added the typical item renderer to the active renderers. if
				//not, we need to do it here.
				var activeRendererCount:int = this._activeRenderers.length;
				if(activeRendererCount == 0)
				{
					this._activeRenderers[activeRendererCount] = this._typicalItemRenderer;
				}
			}

			this.findUnrenderedData();
			this.recoverInactiveRenderers();
			this.renderUnrenderedData();
			this.freeInactiveRenderers();
		}

		private function findUnrenderedData():void
		{
			const itemCount:int = this._dataProvider ? this._dataProvider.length : 0;
			const virtualLayout:IVirtualLayout = this._layout as IVirtualLayout;
			const useVirtualLayout:Boolean = virtualLayout && virtualLayout.useVirtualLayout;
			if(useVirtualLayout)
			{
				virtualLayout.measureViewPort(itemCount, this._viewPortBounds, HELPER_POINT);
				virtualLayout.getVisibleIndicesAtScrollPosition(this._horizontalScrollPosition, this._verticalScrollPosition, HELPER_POINT.x, HELPER_POINT.y, itemCount, HELPER_VECTOR);
			}

			const unrenderedItemCount:int = useVirtualLayout ? HELPER_VECTOR.length : itemCount;
			const canUseBeforeAndAfter:Boolean = this._layout is ITrimmedVirtualLayout && useVirtualLayout &&
				(!(this._layout is IVariableVirtualLayout) || !IVariableVirtualLayout(this._layout).hasVariableItemDimensions) &&
				unrenderedItemCount > 0;
			if(canUseBeforeAndAfter)
			{
				var minIndex:int = HELPER_VECTOR[0];
				var maxIndex:int = minIndex;
				for(var i:int = 1; i < unrenderedItemCount; i++)
				{
					var index:int = HELPER_VECTOR[i];
					if(index < minIndex)
					{
						minIndex = index;
					}
					if(index > maxIndex)
					{
						maxIndex = index;
					}
				}
				var beforeItemCount:int = minIndex - 1;
				if(beforeItemCount < 0)
				{
					beforeItemCount = 0;
				}
				const afterItemCount:int = itemCount - 1 - maxIndex;
				const sequentialVirtualLayout:ITrimmedVirtualLayout = ITrimmedVirtualLayout(this._layout);
				sequentialVirtualLayout.beforeVirtualizedItemCount = beforeItemCount;
				sequentialVirtualLayout.afterVirtualizedItemCount = afterItemCount;
				this._layoutItems.length = itemCount - beforeItemCount - afterItemCount;
				this._layoutIndexOffset = -beforeItemCount;
			}
			else
			{
				this._layoutIndexOffset = 0;
				this._layoutItems.length = itemCount;
			}

			var activeRenderersLastIndex:int = this._activeRenderers.length;
			var unrenderedDataLastIndex:int = this._unrenderedData.length;
			for(i = 0; i < unrenderedItemCount; i++)
			{
				index = useVirtualLayout ? HELPER_VECTOR[i] : i;
				if(index < 0 || index >= itemCount)
				{
					continue;
				}
				var item:Object = this._dataProvider.getItemAt(index);
				var renderer:IListItemRenderer = IListItemRenderer(this._rendererMap[item]);
				if(renderer)
				{
					//the index may have changed if data was added or removed
					renderer.index = index;
					//if this item renderer used to be the typical item
					//renderer, but it isn't anymore, it may have been set invisible!
					renderer.visible = true;

					//the typical item renderer is a special case, and we will
					//have already put it into the active renderers, so we don't
					//want to do it again!
					if(this._typicalItemRenderer != renderer)
					{
						this._activeRenderers[activeRenderersLastIndex] = renderer;
						activeRenderersLastIndex++;
						var inactiveIndex:int = this._inactiveRenderers.indexOf(renderer);
						if(inactiveIndex >= 0)
						{
							this._inactiveRenderers[inactiveIndex] = null;
						}
						else
						{
							throw new IllegalOperationError("ListDataViewPort: renderer map contains bad data.");
						}
					}
					this._layoutItems[index + this._layoutIndexOffset] = DisplayObject(renderer);
				}
				else
				{
					this._unrenderedData[unrenderedDataLastIndex] = item;
					unrenderedDataLastIndex++;
				}
			}
			//update the typical item renderer's visibility
			if(this._typicalItemRenderer)
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
			const itemCount:int = this._unrenderedData.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:Object = this._unrenderedData.shift();
				var index:int = this._dataProvider.getItemIndex(item);
				var renderer:IListItemRenderer = this.createRenderer(item, index, true, false);
				renderer.visible = true;
				this._layoutItems[index + this._layoutIndexOffset] = DisplayObject(renderer);
			}
		}

		private function recoverInactiveRenderers():void
		{
			const itemCount:int = this._inactiveRenderers.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var renderer:IListItemRenderer = this._inactiveRenderers[i];
				if(!renderer)
				{
					continue;
				}
				this._owner.dispatchEventWith(FeathersEventType.RENDERER_REMOVE, false, renderer);
				delete this._rendererMap[renderer.data];
			}
		}

		private function freeInactiveRenderers():void
		{
			const itemCount:int = this._inactiveRenderers.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var renderer:IListItemRenderer = this._inactiveRenderers.shift();
				if(!renderer)
				{
					continue;
				}
				this.destroyRenderer(renderer);
			}
		}

		private function createRenderer(item:Object, index:int, useCache:Boolean, isTemporary:Boolean):IListItemRenderer
		{
			var renderer:IListItemRenderer;
			do
			{
				if(!useCache || isTemporary || this._inactiveRenderers.length == 0)
				{
					if(this._itemRendererFactory != null)
					{
						renderer = IListItemRenderer(this._itemRendererFactory());
					}
					else
					{
						renderer = new this._itemRendererType();
					}
					var uiRenderer:IFeathersControl = IFeathersControl(renderer);
					if(this._itemRendererName && this._itemRendererName.length > 0)
					{
						uiRenderer.nameList.add(this._itemRendererName);
					}
					this.addChild(DisplayObject(renderer));
				}
				else
				{
					renderer = this._inactiveRenderers.shift();
				}
				//wondering why this all is in a loop?
				//_inactiveRenderers.shift() may return null because we're
				//storing null values instead of calling splice() to improve
				//performance.
			}
			while(!renderer)
			renderer.data = item;
			renderer.index = index;
			renderer.owner = this._owner;

			if(!isTemporary)
			{
				this._rendererMap[item] = renderer;
				this._activeRenderers[this._activeRenderers.length] = renderer;
				renderer.addEventListener(Event.CHANGE, renderer_changeHandler);
				renderer.addEventListener(FeathersEventType.RESIZE, renderer_resizeHandler);
				this._owner.dispatchEventWith(FeathersEventType.RENDERER_ADD, false, renderer);
			}

			return renderer;
		}

		private function destroyRenderer(renderer:IListItemRenderer):void
		{
			renderer.removeEventListener(Event.CHANGE, renderer_changeHandler);
			renderer.removeEventListener(FeathersEventType.RESIZE, renderer_resizeHandler);
			renderer.owner = null;
			renderer.data = null;
			this.removeChild(DisplayObject(renderer), true);
		}

		private function childProperties_onChange(proxy:PropertyProxy, name:String):void
		{
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		private function owner_scrollStartHandler(event:Event):void
		{
			this._isScrolling = true;
		}

		private function dataProvider_changeHandler(event:Event):void
		{
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		private function dataProvider_addItemHandler(event:Event, index:int):void
		{
			var selectionChanged:Boolean = false;
			const newIndices:Vector.<int> = new <int>[];
			const indexCount:int = this._selectedIndices.length;
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

			const layout:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
			if(!layout || !layout.hasVariableItemDimensions)
			{
				return;
			}
			layout.addToVariableVirtualCacheAtIndex(index);
		}

		private function dataProvider_removeItemHandler(event:Event, index:int):void
		{
			var selectionChanged:Boolean = false;
			const newIndices:Vector.<int> = new <int>[];
			const indexCount:int = this._selectedIndices.length;
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

			const layout:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
			if(!layout || !layout.hasVariableItemDimensions)
			{
				return;
			}
			layout.removeFromVariableVirtualCacheAtIndex(index);
		}

		private function dataProvider_replaceItemHandler(event:Event, index:int):void
		{
			const indexOfIndex:int = this._selectedIndices.getItemIndex(index);
			if(indexOfIndex >= 0)
			{
				this._selectedIndices.removeItemAt(indexOfIndex);
			}

			const layout:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
			if(!layout || !layout.hasVariableItemDimensions)
			{
				return;
			}
			layout.resetVariableVirtualCacheAtIndex(index);
		}

		private function dataProvider_resetHandler(event:Event):void
		{
			this._selectedIndices.removeAll();

			const layout:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
			if(!layout || !layout.hasVariableItemDimensions)
			{
				return;
			}
			layout.resetVariableVirtualCache();
		}

		private function dataProvider_updateItemHandler(event:Event, index:int):void
		{
			const item:Object = this._dataProvider.getItemAt(index);
			const renderer:IListItemRenderer = IListItemRenderer(this._rendererMap[item]);
			if(!renderer)
			{
				return;
			}
			renderer.data = null;
			renderer.data = item;
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

		private function renderer_resizeHandler(event:Event):void
		{
			if(this._ignoreRendererResizing)
			{
				return;
			}
			const layout:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
			if(!layout || !layout.hasVariableItemDimensions)
			{
				return;
			}
			const renderer:IListItemRenderer = IListItemRenderer(event.currentTarget);
			layout.resetVariableVirtualCacheAtIndex(renderer.index, DisplayObject(renderer));
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
			this.invalidateParent(INVALIDATION_FLAG_LAYOUT);
		}

		private function renderer_changeHandler(event:Event):void
		{
			if(this._ignoreSelectionChanges)
			{
				return;
			}
			const renderer:IListItemRenderer = IListItemRenderer(event.currentTarget);
			if(!this._isSelectable || this._isScrolling)
			{
				renderer.isSelected = false;
				return;
			}
			const isSelected:Boolean = renderer.isSelected;
			const index:int = renderer.index;
			if(this._allowMultipleSelection)
			{
				const indexOfIndex:int = this._selectedIndices.getItemIndex(index);
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

		private function selectedIndices_changeHandler(event:Event):void
		{
			this.invalidate(INVALIDATION_FLAG_SELECTED);
		}

		private function removedFromStageHandler(event:Event):void
		{
			this.touchPointID = -1;
		}

		private function touchHandler(event:TouchEvent):void
		{
			if(!this._isEnabled)
			{
				this.touchPointID = -1;
				return;
			}

			if(this.touchPointID >= 0)
			{
				var touch:Touch = event.getTouch(this, TouchPhase.ENDED, this.touchPointID);
				if(!touch)
				{
					return;
				}
				this.touchPointID = -1;
			}
			else
			{
				touch = event.getTouch(this, TouchPhase.BEGAN);
				if(!touch)
				{
					return;
				}
				this.touchPointID = touch.id;
				this._isScrolling = false;
			}
		}
	}
}