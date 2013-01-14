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
	import feathers.layout.IVariableVirtualLayout;
	import feathers.layout.IVirtualLayout;
	import feathers.layout.LayoutBoundsResult;
	import feathers.layout.ViewPortBounds;

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
		private static const HELPER_BOUNDS:ViewPortBounds = new ViewPortBounds();
		private static const HELPER_LAYOUT_RESULT:LayoutBoundsResult = new LayoutBoundsResult();
		private static const HELPER_VECTOR:Vector.<int> = new <int>[];
		private static const HELPER_TOUCHES_VECTOR:Vector.<Touch> = new <Touch>[];

		public function ListDataViewPort()
		{
			super();
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			this.addEventListener(TouchEvent.TOUCH, touchHandler);
		}

		private var touchPointID:int = -1;

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

		private var _unrenderedData:Array = [];
		private var _layoutItems:Vector.<DisplayObject> = new <DisplayObject>[];
		private var _inactiveRenderers:Vector.<IListItemRenderer> = new <IListItemRenderer>[];
		private var _activeRenderers:Vector.<IListItemRenderer> = new <IListItemRenderer>[];
		private var _rendererMap:Dictionary = new Dictionary(true);

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
				this._owner.removeEventListener(Event.SCROLL, owner_scrollHandler);
			}
			this._owner = value;
			if(this._owner)
			{
				this._owner.addEventListener(Event.SCROLL, owner_scrollHandler);
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
				this._dataProvider.removeEventListener(CollectionEventType.UPDATE_ITEM, dataProvider_updateItemHandler);
			}
			this._dataProvider = value;
			if(this._dataProvider)
			{
				this._dataProvider.addEventListener(Event.CHANGE, dataProvider_changeHandler);
				this._dataProvider.addEventListener(CollectionEventType.UPDATE_ITEM, dataProvider_updateItemHandler);
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

		private var _typicalItemWidth:Number = NaN;

		public function get typicalItemWidth():Number
		{
			return this._typicalItemWidth;
		}

		private var _typicalItemHeight:Number = NaN;

		public function get typicalItemHeight():Number
		{
			return this._typicalItemHeight;
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
			this.invalidate(INVALIDATION_FLAG_SCROLL);
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
			this.invalidate(INVALIDATION_FLAG_SCROLL);
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
				EventDispatcher(this._layout).addEventListener(Event.CHANGE, layout_changeHandler);
			}
			this.invalidate(INVALIDATION_FLAG_SCROLL);
		}

		public function get horizontalScrollStep():Number
		{
			return this._typicalItemWidth;
		}

		public function get verticalScrollStep():Number
		{
			return this._typicalItemHeight;
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
				this.selectedIndex = -1;
			}
		}

		private var _selectedIndex:int = -1;

		public function get selectedIndex():int
		{
			return this._selectedIndex;
		}

		public function set selectedIndex(value:int):void
		{
			if(this._selectedIndex == value)
			{
				return;
			}
			this._selectedIndex = value;
			this.invalidate(INVALIDATION_FLAG_SELECTED);
			this.dispatchEventWith(Event.CHANGE);
		}

		public function getScrollPositionForIndex(index:int, result:Point = null):Point
		{
			if(!result)
			{
				result = new Point();
			}
			return this._layout.getScrollPositionForIndex(index, this._layoutItems, 0, 0, this.actualVisibleWidth, this.actualVisibleHeight, result);
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

			if(stylesInvalid || dataInvalid || itemRendererInvalid)
			{
				if(this._layout is IVariableVirtualLayout)
				{
					IVariableVirtualLayout(this._layout).resetVariableVirtualCache();
				}
				this.calculateTypicalValues();
			}

			if(scrollInvalid || sizeInvalid || dataInvalid || itemRendererInvalid)
			{
				this.refreshRenderers(itemRendererInvalid);
			}
			if(scrollInvalid || sizeInvalid || dataInvalid || stylesInvalid || itemRendererInvalid)
			{
				this.refreshItemRendererStyles();
			}
			if(scrollInvalid || selectionInvalid || sizeInvalid || dataInvalid || itemRendererInvalid)
			{
				this.refreshSelection();
			}
			const rendererCount:int = this._activeRenderers.length;
			for(var i:int = 0; i < rendererCount; i++)
			{
				const itemRenderer:IFeathersControl = IFeathersControl(this._activeRenderers[i]);
				if(stateInvalid || dataInvalid || scrollInvalid || itemRendererInvalid)
				{
					itemRenderer.isEnabled = this._isEnabled;
				}
				itemRenderer.validate();
			}

			if(scrollInvalid || dataInvalid || itemRendererInvalid || sizeInvalid)
			{
				this._ignoreRendererResizing = true;
				this._layout.layout(this._layoutItems, HELPER_BOUNDS, HELPER_LAYOUT_RESULT);
				this._ignoreRendererResizing = false;
				this.setSizeInternal(HELPER_LAYOUT_RESULT.contentWidth, HELPER_LAYOUT_RESULT.contentHeight, false);
				this.actualVisibleWidth = HELPER_LAYOUT_RESULT.viewPortWidth;
				this.actualVisibleHeight = HELPER_LAYOUT_RESULT.viewPortHeight;
			}
		}
		
		private function invalidateParent():void
		{
			Scroller(this.parent.parent).invalidate(INVALIDATION_FLAG_DATA);
		}

		private function calculateTypicalValues():void
		{
			var typicalItem:Object = this._typicalItem;
			if(!typicalItem)
			{
				if(this._dataProvider && this._dataProvider.length > 0)
				{
					typicalItem = this._dataProvider.getItemAt(0);
				}
				else
				{
					this._typicalItemWidth = 0;
					this._typicalItemHeight = 0;
					return;
				}
			}

			const typicalRenderer:IListItemRenderer = this.createRenderer(typicalItem, 0, true);
			this.refreshOneItemRendererStyles(typicalRenderer);
			if(typicalRenderer is FeathersControl)
			{
				FeathersControl(typicalRenderer).validate();
			}
			this._typicalItemWidth = DisplayObject(typicalRenderer).width;
			this._typicalItemHeight = DisplayObject(typicalRenderer).height;
			this.destroyRenderer(typicalRenderer);
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
			this._ignoreSelectionChanges = true;
			for each(var renderer:IListItemRenderer in this._activeRenderers)
			{
				renderer.isSelected = renderer.index == this._selectedIndex;
			}
			this._ignoreSelectionChanges = false;
		}

		private function refreshRenderers(itemRendererTypeIsInvalid:Boolean):void
		{
			const temp:Vector.<IListItemRenderer> = this._inactiveRenderers;
			this._inactiveRenderers = this._activeRenderers;
			this._activeRenderers = temp;
			this._activeRenderers.length = 0;
			if(itemRendererTypeIsInvalid)
			{
				this.recoverInactiveRenderers();
				this.freeInactiveRenderers();
			}

			this._layoutItems.length = 0;
			this._layoutItems.length = this._dataProvider ? this._dataProvider.length : 0;

			HELPER_BOUNDS.x = HELPER_BOUNDS.y = 0;
			HELPER_BOUNDS.explicitWidth = this.explicitVisibleWidth;
			HELPER_BOUNDS.explicitHeight = this.explicitVisibleHeight;
			HELPER_BOUNDS.minWidth = this._minVisibleWidth;
			HELPER_BOUNDS.minHeight = this._minVisibleHeight;
			HELPER_BOUNDS.maxWidth = this._maxVisibleWidth;
			HELPER_BOUNDS.maxHeight = this._maxVisibleHeight;

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
				this._ignoreLayoutChanges = true;
				virtualLayout.typicalItemWidth = this._typicalItemWidth;
				virtualLayout.typicalItemHeight = this._typicalItemHeight;
				this._ignoreLayoutChanges = false;
				virtualLayout.measureViewPort(itemCount, HELPER_BOUNDS, HELPER_POINT);
				virtualLayout.getVisibleIndicesAtScrollPosition(this._horizontalScrollPosition, this._verticalScrollPosition, HELPER_POINT.x, HELPER_POINT.y, itemCount, HELPER_VECTOR);
			}
			const unrenderedItemCount:int = useVirtualLayout ? HELPER_VECTOR.length : itemCount;
			for(var i:int = 0; i < unrenderedItemCount; i++)
			{
				var index:int = useVirtualLayout ? HELPER_VECTOR[i] : i;
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
					this._activeRenderers.push(renderer);
					this._inactiveRenderers.splice(this._inactiveRenderers.indexOf(renderer), 1);
					var displayRenderer:DisplayObject = DisplayObject(renderer);
					this._layoutItems[index] = displayRenderer;
				}
				else
				{
					this._unrenderedData.push(item);
				}
			}
		}

		private function renderUnrenderedData():void
		{
			const itemCount:int = this._unrenderedData.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:Object = this._unrenderedData.shift();
				var index:int = this._dataProvider.getItemIndex(item);
				var renderer:IListItemRenderer = this.createRenderer(item, index, false);
				var displayRenderer:DisplayObject = DisplayObject(renderer);
				this._layoutItems[index] = displayRenderer;
			}
		}

		private function recoverInactiveRenderers():void
		{
			const itemCount:int = this._inactiveRenderers.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var renderer:IListItemRenderer = this._inactiveRenderers[i];
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
				this.destroyRenderer(renderer);
			}
		}

		private function createRenderer(item:Object, index:int, isTemporary:Boolean = false):IListItemRenderer
		{
			if(isTemporary || this._inactiveRenderers.length == 0)
			{
				var renderer:IListItemRenderer;
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
			renderer.data = item;
			renderer.index = index;
			renderer.owner = this._owner;

			if(!isTemporary)
			{
				this._rendererMap[item] = renderer;
				this._activeRenderers.push(renderer);
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

		private function owner_scrollHandler(event:Event):void
		{
			this._isScrolling = true;
		}

		private function dataProvider_changeHandler(event:Event):void
		{
			this.invalidate(INVALIDATION_FLAG_DATA);
			this.invalidateParent();
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
			this.invalidate(INVALIDATION_FLAG_SCROLL);
			this.invalidateParent();
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
			this.invalidate(INVALIDATION_FLAG_SCROLL);
			this.invalidateParent();
		}

		private function renderer_changeHandler(event:Event):void
		{
			if(this._ignoreSelectionChanges)
			{
				return;
			}
			const renderer:IListItemRenderer = IListItemRenderer(event.currentTarget);
			if(!this._isSelectable || this._isScrolling || this._selectedIndex == renderer.index)
			{
				//reset to the old value
				renderer.isSelected = this._selectedIndex == renderer.index;
				return;
			}
			this.selectedIndex = renderer.index;
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

			const touches:Vector.<Touch> = event.getTouches(this, null, HELPER_TOUCHES_VECTOR);
			if(touches.length == 0)
			{
				return;
			}
			if(this.touchPointID >= 0)
			{
				var touch:Touch;
				for each(var currentTouch:Touch in touches)
				{
					if(currentTouch.id == this.touchPointID)
					{
						touch = currentTouch;
						break;
					}
				}
				if(!touch)
				{
					HELPER_TOUCHES_VECTOR.length = 0;
					return;
				}
				if(touch.phase == TouchPhase.ENDED)
				{
					this.touchPointID = -1;
				}
			}
			else
			{
				for each(touch in touches)
				{
					if(touch.phase == TouchPhase.BEGAN)
					{
						this.touchPointID = touch.id;
						this._isScrolling = false;
						break;
					}
				}
			}
			HELPER_TOUCHES_VECTOR.length = 0;
		}
	}
}