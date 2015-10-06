/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

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
	import feathers.core.IValidating;
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
	public class ListDataViewPort extends FeathersControl implements IViewPort
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
			if(value !== value) //isNaN
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
			if(value !== value) //isNaN
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
			if(this.explicitVisibleWidth == value ||
				(value !== value && this.explicitVisibleWidth !== this.explicitVisibleWidth)) //isNaN
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
			if(value !== value) //isNaN
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
			if(value !== value) //isNaN
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
			if(this.explicitVisibleHeight == value ||
				(value !== value && this.explicitVisibleHeight !== this.explicitVisibleHeight)) //isNaN
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
		private var _defaultStorage:ItemRendererFactoryStorage = new ItemRendererFactoryStorage();
		private var _storageMap:Object;
		private var _rendererMap:Dictionary = new Dictionary(true);
		private var _minimumItemCount:int;

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

		private var _updateForDataReset:Boolean = false;

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
				this._dataProvider.removeEventListener(CollectionEventType.UPDATE_ALL, dataProvider_updateAllHandler);
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
				this._dataProvider.addEventListener(CollectionEventType.UPDATE_ALL, dataProvider_updateAllHandler);
			}
			if(this._layout is IVariableVirtualLayout)
			{
				IVariableVirtualLayout(this._layout).resetVariableVirtualCache();
			}
			this._updateForDataReset = true;
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

		/**
		 * @private
		 */
		public function set itemRendererFactories(value:Object):void
		{
			if(this._itemRendererFactories === value)
			{
				return;
			}

			this._itemRendererFactories = value;
			if(value !== null)
			{
				this._storageMap = {};
			}
			this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		}
		
		private var _factoryIDFunction:Function;
		
		public function get factoryIDFunction():Function
		{
			return this._factoryIDFunction;
		}

		/**
		 * @private
		 */
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
			return this._layout.getScrollPositionForIndex(index, this._layoutItems,
				0, 0, this.actualVisibleWidth, this.actualVisibleHeight, result);
		}

		public function getNearestScrollPositionForIndex(index:int, result:Point = null):Point
		{
			if(!result)
			{
				result = new Point();
			}
			return this._layout.getNearestScrollPositionForIndex(index,
				this._horizontalScrollPosition, this._verticalScrollPosition,
				this._layoutItems, 0, 0, this.actualVisibleWidth, this.actualVisibleHeight, result);
		}

		override public function dispose():void
		{
			this.refreshInactiveRenderers(this._defaultStorage, true);
			if(this._storageMap)
			{
				for(var factoryID:String in this._storageMap)
				{
					var storage:ItemRendererFactoryStorage = ItemRendererFactoryStorage(this._storageMap[factoryID]);
					this.refreshInactiveRenderers(storage, true);
				}
			}
			this.owner = null;
			this.layout = null;
			this.dataProvider = null;
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
			if(basicsInvalid)
			{
				this.refreshInactiveRenderers(this._defaultStorage, itemRendererInvalid);
				if(this._storageMap)
				{
					for(var factoryID:String in this._storageMap)
					{
						var storage:ItemRendererFactoryStorage = ItemRendererFactoryStorage(this._storageMap[factoryID]);
						this.refreshInactiveRenderers(storage, itemRendererInvalid);
					}
				}
			}
			if(dataInvalid || layoutInvalid || itemRendererInvalid)
			{
				this.refreshLayoutTypicalItem();
			}
			if(basicsInvalid)
			{
				this.refreshRenderers();
			}
			if(stylesInvalid || basicsInvalid)
			{
				this.refreshItemRendererStyles();
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
			var itemCount:int = this._layoutItems.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:IValidating = this._layoutItems[i] as IValidating;
				if(item)
				{
					item.validate();
				}
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
			if(typicalItem !== null)
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
			}

			if(typicalItem !== null)
			{
				var typicalRenderer:IListItemRenderer = IListItemRenderer(this._rendererMap[typicalItem]);
				if(typicalRenderer)
				{
					//the index may have changed if items were added, removed or
					//reordered in the data provider
					typicalRenderer.index = typicalItemIndex;
				}
				if(!typicalRenderer && this._typicalItemRenderer)
				{
					//we can reuse the typical item renderer if the old typical item
					//wasn't in the data provider.
					var canReuse:Boolean = !this._typicalItemIsInDataProvider;
					if(!canReuse)
					{
						//we can also reuse the typical item renderer if the old
						//typical item was in the data provider, but it isn't now.
						canReuse = this._dataProvider.getItemIndex(this._typicalItemRenderer.data) < 0;
					}
					if(canReuse)
					{
						//if the old typical item was in the data provider, remove
						//it from the renderer map.
						if(this._typicalItemIsInDataProvider)
						{
							delete this._rendererMap[this._typicalItemRenderer.data];
						}
						typicalRenderer = this._typicalItemRenderer;
						typicalRenderer.data = typicalItem;
						typicalRenderer.index = typicalItemIndex;
						//if the new typical item is in the data provider, add it
						//to the renderer map.
						if(newTypicalItemIsInDataProvider)
						{
							this._rendererMap[typicalItem] = typicalRenderer;
						}
					}
				}
				if(!typicalRenderer)
				{
					//if we still don't have a typical item renderer, we need to
					//create a new one.
					typicalRenderer = this.createRenderer(typicalItem, typicalItemIndex, false, !newTypicalItemIsInDataProvider);
					if(!this._typicalItemIsInDataProvider && this._typicalItemRenderer)
					{
						//get rid of the old typical item renderer if it isn't
						//needed anymore.  since it was not in the data provider, we
						//don't need to mess with the renderer map dictionary.
						this.destroyRenderer(this._typicalItemRenderer);
						this._typicalItemRenderer = null;
					}
				}
			}

			virtualLayout.typicalItem = DisplayObject(typicalRenderer);
			this._typicalItemRenderer = typicalRenderer;
			this._typicalItemIsInDataProvider = newTypicalItemIsInDataProvider;
			if(this._typicalItemRenderer && !this._typicalItemIsInDataProvider)
			{
				//we need to know if this item renderer resizes to adjust the
				//layout because the layout may use this item renderer to resize
				//the other item renderers
				this._typicalItemRenderer.addEventListener(FeathersEventType.RESIZE, renderer_resizeHandler);
			}
		}

		private function refreshItemRendererStyles():void
		{
			for each(var item:DisplayObject in this._layoutItems)
			{
				var itemRenderer:IListItemRenderer = item as IListItemRenderer;
				if(itemRenderer)
				{
					this.refreshOneItemRendererStyles(itemRenderer);
				}
			}
		}

		private function refreshOneItemRendererStyles(renderer:IListItemRenderer):void
		{
			var displayRenderer:DisplayObject = DisplayObject(renderer);
			for(var propertyName:String in this._itemRendererProperties)
			{
				var propertyValue:Object = this._itemRendererProperties[propertyName];
				displayRenderer[propertyName] = propertyValue;
			}
		}

		private function refreshSelection():void
		{
			for each(var item:DisplayObject in this._layoutItems)
			{
				var itemRenderer:IListItemRenderer = item as IListItemRenderer;
				if(itemRenderer)
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
				if(control)
				{
					control.isEnabled = this._isEnabled;
				}
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

		private function refreshInactiveRenderers(storage:ItemRendererFactoryStorage, itemRendererTypeIsInvalid:Boolean):void
		{
			var temp:Vector.<IListItemRenderer> = storage.inactiveItemRenderers;
			storage.inactiveItemRenderers = storage.activeItemRenderers;
			storage.activeItemRenderers = temp;
			if(storage.activeItemRenderers.length > 0)
			{
				throw new IllegalOperationError("ListDataViewPort: active renderers should be empty.");
			}
			if(itemRendererTypeIsInvalid)
			{
				this.recoverInactiveRenderers(storage);
				this.freeInactiveRenderers(storage, 0);
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
			if(this._typicalItemRenderer)
			{
				if(this._typicalItemIsInDataProvider)
				{
					var storage:ItemRendererFactoryStorage = this.factoryIDToStorage(this._typicalItemRenderer.factoryID);
					var inactiveItemRenderers:Vector.<IListItemRenderer> = storage.inactiveItemRenderers;
					var activeItemRenderers:Vector.<IListItemRenderer> = storage.activeItemRenderers;
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
				//we need to set the typical item renderer's properties here
				//because they may be needed for proper measurement in a virtual
				//layout.
				this.refreshOneItemRendererStyles(this._typicalItemRenderer);
			}

			this.findUnrenderedData();
			this.recoverInactiveRenderers(this._defaultStorage);
			if(this._storageMap)
			{
				for(var factoryID:String in this._storageMap)
				{
					storage = ItemRendererFactoryStorage(this._storageMap[factoryID]);
					this.recoverInactiveRenderers(storage);
				}
			}
			this.renderUnrenderedData();
			this.freeInactiveRenderers(this._defaultStorage, this._minimumItemCount);
			if(this._storageMap)
			{
				for(factoryID in this._storageMap)
				{
					storage = ItemRendererFactoryStorage(this._storageMap[factoryID]);
					this.freeInactiveRenderers(storage, 1);
				}
			}
			this._updateForDataReset = false;
		}

		private function findUnrenderedData():void
		{
			var itemCount:int = this._dataProvider ? this._dataProvider.length : 0;
			var virtualLayout:IVirtualLayout = this._layout as IVirtualLayout;
			var useVirtualLayout:Boolean = virtualLayout && virtualLayout.useVirtualLayout;
			if(useVirtualLayout)
			{
				virtualLayout.measureViewPort(itemCount, this._viewPortBounds, HELPER_POINT);
				virtualLayout.getVisibleIndicesAtScrollPosition(this._horizontalScrollPosition, this._verticalScrollPosition, HELPER_POINT.x, HELPER_POINT.y, itemCount, HELPER_VECTOR);
			}

			var unrenderedItemCount:int = useVirtualLayout ? HELPER_VECTOR.length : itemCount;
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
			var canUseBeforeAndAfter:Boolean = this._layout is ITrimmedVirtualLayout && useVirtualLayout &&
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
				var afterItemCount:int = itemCount - 1 - maxIndex;
				var sequentialVirtualLayout:ITrimmedVirtualLayout = ITrimmedVirtualLayout(this._layout);
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

			var unrenderedDataLastIndex:int = this._unrenderedData.length;
			for(i = 0; i < unrenderedItemCount; i++)
			{
				index = useVirtualLayout ? HELPER_VECTOR[i] : i;
				if(index < 0 || index >= itemCount)
				{
					continue;
				}
				var item:Object = this._dataProvider.getItemAt(index);
				var itemRenderer:IListItemRenderer = IListItemRenderer(this._rendererMap[item]);
				if(itemRenderer)
				{
					//the index may have changed if items were added, removed or
					//reordered in the data provider
					itemRenderer.index = index;
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
					if(this._typicalItemRenderer != itemRenderer)
					{
						var storage:ItemRendererFactoryStorage = this.factoryIDToStorage(itemRenderer.factoryID);
						var activeItemRenderers:Vector.<IListItemRenderer> = storage.activeItemRenderers;
						var inactiveItemRenderers:Vector.<IListItemRenderer> = storage.inactiveItemRenderers;
						activeItemRenderers[activeItemRenderers.length] = itemRenderer;
						var inactiveIndex:int = inactiveItemRenderers.indexOf(itemRenderer);
						if(inactiveIndex >= 0)
						{
							inactiveItemRenderers[inactiveIndex] = null;
						}
						else
						{
							throw new IllegalOperationError("ListDataViewPort: renderer map contains bad data.");
						}
					}
					this._layoutItems[index + this._layoutIndexOffset] = DisplayObject(itemRenderer);
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
			var itemCount:int = this._unrenderedData.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:Object = this._unrenderedData.shift();
				var index:int = this._dataProvider.getItemIndex(item);
				var renderer:IListItemRenderer = this.createRenderer(item, index, true, false);
				renderer.visible = true;
				this._layoutItems[index + this._layoutIndexOffset] = DisplayObject(renderer);
			}
		}

		private function recoverInactiveRenderers(storage:ItemRendererFactoryStorage):void
		{
			var inactiveItemRenderers:Vector.<IListItemRenderer> = storage.inactiveItemRenderers;
			
			var itemCount:int = inactiveItemRenderers.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var itemRenderer:IListItemRenderer = inactiveItemRenderers[i];
				if(!itemRenderer || itemRenderer.index < 0)
				{
					continue;
				}
				this._owner.dispatchEventWith(FeathersEventType.RENDERER_REMOVE, false, itemRenderer);
				delete this._rendererMap[itemRenderer.data];
			}
		}

		private function freeInactiveRenderers(storage:ItemRendererFactoryStorage, minimumItemCount:int):void
		{
			var inactiveItemRenderers:Vector.<IListItemRenderer> = storage.inactiveItemRenderers;
			var activeItemRenderers:Vector.<IListItemRenderer> = storage.activeItemRenderers;
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
				var itemRenderer:IListItemRenderer = inactiveItemRenderers.shift();
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
				this.destroyRenderer(itemRenderer);
			}
		}

		private function createRenderer(item:Object, index:int, useCache:Boolean, isTemporary:Boolean):IListItemRenderer
		{
			var factoryID:String = null;
			if(this._factoryIDFunction !== null)
			{
				if(this._factoryIDFunction.length === 1)
				{
					factoryID = this._factoryIDFunction(item);
				}
				else
				{
					factoryID = this._factoryIDFunction(item, index);
				}
			}
			var itemRendererFactory:Function = this.factoryIDToFactory(factoryID);
			var storage:ItemRendererFactoryStorage = this.factoryIDToStorage(factoryID);
			var inactiveItemRenderers:Vector.<IListItemRenderer> = storage.inactiveItemRenderers;
			var activeItemRenderers:Vector.<IListItemRenderer> = storage.activeItemRenderers;
			var itemRenderer:IListItemRenderer;
			do
			{
				if(!useCache || isTemporary || inactiveItemRenderers.length === 0)
				{
					if(itemRendererFactory !== null)
					{
						itemRenderer = IListItemRenderer(itemRendererFactory());
					}
					else
					{
						itemRenderer = IListItemRenderer(new this._itemRendererType());
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
			itemRenderer.index = index;
			itemRenderer.owner = this._owner;
			itemRenderer.factoryID = factoryID;

			if(!isTemporary)
			{
				this._rendererMap[item] = itemRenderer;
				activeItemRenderers[activeItemRenderers.length] = itemRenderer;
				itemRenderer.addEventListener(Event.TRIGGERED, renderer_triggeredHandler);
				itemRenderer.addEventListener(Event.CHANGE, renderer_changeHandler);
				itemRenderer.addEventListener(FeathersEventType.RESIZE, renderer_resizeHandler);
				this._owner.dispatchEventWith(FeathersEventType.RENDERER_ADD, false, itemRenderer);
			}

			return itemRenderer;
		}

		private function destroyRenderer(renderer:IListItemRenderer):void
		{
			renderer.removeEventListener(Event.TRIGGERED, renderer_triggeredHandler);
			renderer.removeEventListener(Event.CHANGE, renderer_changeHandler);
			renderer.removeEventListener(FeathersEventType.RESIZE, renderer_resizeHandler);
			renderer.owner = null;
			renderer.data = null;
			renderer.factoryID = null;
			this.removeChild(DisplayObject(renderer), true);
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
				if(id in this._storageMap)
				{
					return ItemRendererFactoryStorage(this._storageMap[id]);
				}
				var storage:ItemRendererFactoryStorage = new ItemRendererFactoryStorage();
				this._storageMap[id] = storage;
				return storage;
			}
			return this._defaultStorage;
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

		private function dataProvider_updateItemHandler(event:Event, index:int):void
		{
			var item:Object = this._dataProvider.getItemAt(index);
			var renderer:IListItemRenderer = IListItemRenderer(this._rendererMap[item]);
			if(!renderer)
			{
				return;
			}
			renderer.data = null;
			renderer.data = item;
		}

		private function dataProvider_updateAllHandler(event:Event):void
		{
			for(var item:Object in this._rendererMap)
			{
				var renderer:IListItemRenderer = IListItemRenderer(this._rendererMap[item]);
				if(!renderer)
				{
					return;
				}
				renderer.data = null;
				renderer.data = item;
			}
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
			var renderer:IListItemRenderer = IListItemRenderer(event.currentTarget);
			layout.resetVariableVirtualCacheAtIndex(renderer.index, DisplayObject(renderer));
		}

		private function renderer_triggeredHandler(event:Event):void
		{
			var renderer:IListItemRenderer = IListItemRenderer(event.currentTarget);
			this.parent.dispatchEventWith(Event.TRIGGERED, false, renderer.data);
		}

		private function renderer_changeHandler(event:Event):void
		{
			if(this._ignoreSelectionChanges)
			{
				return;
			}
			var renderer:IListItemRenderer = IListItemRenderer(event.currentTarget);
			if(!this._isSelectable || this._isScrolling)
			{
				renderer.isSelected = false;
				return;
			}
			var isSelected:Boolean = renderer.isSelected;
			var index:int = renderer.index;
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

import feathers.controls.renderers.IListItemRenderer;

class ItemRendererFactoryStorage
{
	public var activeItemRenderers:Vector.<IListItemRenderer> = new <IListItemRenderer>[];
	public var inactiveItemRenderers:Vector.<IListItemRenderer> = new <IListItemRenderer>[];
}