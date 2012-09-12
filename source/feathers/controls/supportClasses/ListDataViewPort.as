/*
 Copyright (c) 2012 Josh Tynjala

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 */
package feathers.controls.supportClasses
{
	import flash.geom.Point;
	import flash.utils.Dictionary;

	import feathers.controls.List;
	import feathers.controls.Scroller;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.FeathersControl;
	import feathers.core.PropertyProxy;
	import feathers.data.ListCollection;
	import feathers.layout.ILayout;
	import feathers.layout.IVariableVirtualLayout;
	import feathers.layout.IVirtualLayout;
	import feathers.layout.LayoutBoundsResult;
	import feathers.layout.ViewPortBounds;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * @private
	 * Used internally by List. Not meant to be used on its own.
	 */
	public class ListDataViewPort extends FeathersControl implements IViewPort
	{
		protected static const INVALIDATION_FLAG_ITEM_RENDERER_FACTORY:String = "itemRendererFactory";

		private static const helperPoint:Point = new Point();
		private static const helperBounds:ViewPortBounds = new ViewPortBounds();
		private static const helperResult:LayoutBoundsResult = new LayoutBoundsResult();
		private static const helperVector:Vector.<int> = new <int>[];

		public function ListDataViewPort()
		{
			super();
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			this.addEventListener(TouchEvent.TOUCH, touchHandler);
		}

		protected var touchPointID:int = -1;

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

		protected var actualVisibleWidth:Number = 0;

		protected var explicitVisibleWidth:Number = NaN;

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

		protected var actualVisibleHeight:Number = 0;

		protected var explicitVisibleHeight:Number = NaN;

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
				this._owner.onScroll.remove(owner_onScroll);
			}
			this._owner = value;
			if(this._owner)
			{
				this._owner.onScroll.add(owner_onScroll);
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
				this._dataProvider.onChange.remove(dataProvider_onChange);
				this._dataProvider.onItemUpdate.remove(dataProvider_onItemUpdate);
			}
			this._dataProvider = value;
			if(this._dataProvider)
			{
				this._dataProvider.onChange.add(dataProvider_onChange);
				this._dataProvider.onItemUpdate.add(dataProvider_onItemUpdate);
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

		protected var _itemRendererName:String;

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
			if(this._itemRendererName)
			{
				for(var item:Object in this._rendererMap)
				{
					var renderer:FeathersControl = this._rendererMap[item] as FeathersControl;
					if(renderer)
					{
						renderer.nameList.remove(this._itemRendererName);
					}
				}
			}
			this._itemRendererName = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
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
				this._itemRendererProperties.onChange.remove(itemRendererProperties_onChange);
			}
			this._itemRendererProperties = PropertyProxy(value);
			if(this._itemRendererProperties)
			{
				this._itemRendererProperties.onChange.add(itemRendererProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES, INVALIDATION_FLAG_SCROLL);
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
				this._layout.onLayoutChange.remove(layout_onLayoutChange);
			}
			this._layout = value;
			if(this._layout)
			{
				this._layout.onLayoutChange.add(layout_onLayoutChange);
			}
			this.invalidate(INVALIDATION_FLAG_SCROLL);
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
			this._onChange.dispatch(this);
		}

		protected var _onChange:Signal = new Signal(ListDataViewPort);

		public function get onChange():ISignal
		{
			return this._onChange;
		}

		override public function dispose():void
		{
			this._onChange.removeAll();
			super.dispose();
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
				var itemRenderer:DisplayObject = DisplayObject(this._activeRenderers[i]);
				if(itemRenderer is FeathersControl)
				{
					const uiItemRenderer:FeathersControl = FeathersControl(itemRenderer);
					if(stateInvalid || dataInvalid || scrollInvalid || itemRendererInvalid)
					{
						uiItemRenderer.isEnabled = this._isEnabled;
					}
					if(stylesInvalid && this._itemRendererName && !uiItemRenderer.nameList.contains(this._itemRendererName))
					{
						uiItemRenderer.nameList.add(this._itemRendererName);
					}
					uiItemRenderer.validate();
				}
			}

			if(scrollInvalid || dataInvalid || itemRendererInvalid || sizeInvalid)
			{
				this._ignoreRendererResizing = true;
				this._layout.layout(this._layoutItems, helperBounds, helperResult);
				this._ignoreRendererResizing = false;
				this.setSizeInternal(helperResult.contentWidth, helperResult.contentHeight, false);
				this.actualVisibleWidth = helperResult.viewPortWidth;
				this.actualVisibleHeight = helperResult.viewPortHeight;
			}
		}
		
		protected function invalidateParent():void
		{
			Scroller(this.parent.parent).invalidate(INVALIDATION_FLAG_DATA);
		}

		protected function calculateTypicalValues():void
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

		protected function refreshItemRendererStyles():void
		{
			for each(var renderer:IListItemRenderer in this._activeRenderers)
			{
				this.refreshOneItemRendererStyles(renderer);
			}
		}

		protected function refreshOneItemRendererStyles(renderer:IListItemRenderer):void
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

		protected function refreshSelection():void
		{
			this._ignoreSelectionChanges = true;
			for each(var renderer:IListItemRenderer in this._activeRenderers)
			{
				renderer.isSelected = renderer.index == this._selectedIndex;
			}
			this._ignoreSelectionChanges = false;
		}

		protected function refreshRenderers(itemRendererTypeIsInvalid:Boolean):void
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

			helperBounds.x = helperBounds.y = 0;
			helperBounds.explicitWidth = this.explicitVisibleWidth;
			helperBounds.explicitHeight = this.explicitVisibleHeight;
			helperBounds.minWidth = this._minVisibleWidth;
			helperBounds.minHeight = this._minVisibleHeight;
			helperBounds.maxWidth = this._maxVisibleWidth;
			helperBounds.maxHeight = this._maxVisibleHeight;

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
				virtualLayout.measureViewPort(itemCount, helperBounds, helperPoint);
				virtualLayout.getVisibleIndicesAtScrollPosition(this._horizontalScrollPosition, this._verticalScrollPosition, helperPoint.x, helperPoint.y, itemCount, helperVector);
			}
			const unrenderedItemCount:int = helperVector.length;
			for(var i:int = 0; i < unrenderedItemCount; i++)
			{
				var index:int = helperVector[i];
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
				renderer.onChange.add(renderer_onChange);
				var displayRenderer:FeathersControl = FeathersControl(renderer);
				if(this._itemRendererName && this._itemRendererName.length > 0)
				{
					displayRenderer.nameList.add(this._itemRendererName);
				}
				this.addChild(displayRenderer);
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
				displayRenderer = FeathersControl(renderer);
				displayRenderer.onResize.add(renderer_onResize);
			}

			return renderer;
		}

		private function destroyRenderer(renderer:IListItemRenderer):void
		{
			renderer.onChange.remove(renderer_onChange);
			const displayRenderer:FeathersControl = FeathersControl(renderer);
			displayRenderer.onResize.remove(renderer_onResize);
			this.removeChild(displayRenderer, true);
		}

		private function itemRendererProperties_onChange(proxy:PropertyProxy, name:Object):void
		{
			this.invalidate(INVALIDATION_FLAG_SCROLL, INVALIDATION_FLAG_STYLES);
		}

		private function owner_onScroll(list:List):void
		{
			this._isScrolling = true;
		}

		private function dataProvider_onChange(data:ListCollection):void
		{
			this.invalidate(INVALIDATION_FLAG_DATA);
			this.invalidateParent();
		}

		private function dataProvider_onItemUpdate(data:ListCollection, index:int):void
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

		private function layout_onLayoutChange(layout:ILayout):void
		{
			if(this._ignoreLayoutChanges)
			{
				return;
			}
			this.invalidate(INVALIDATION_FLAG_SCROLL);
			this.invalidateParent();
		}

		private function renderer_onResize(renderer:IListItemRenderer, oldWidth:Number, oldHeight:Number):void
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
			layout.resetVariableVirtualCacheAtIndex(renderer.index, DisplayObject(renderer));
			this.invalidate(INVALIDATION_FLAG_SCROLL);
			this.invalidateParent();
		}

		private function renderer_onChange(renderer:IListItemRenderer):void
		{
			if(this._ignoreSelectionChanges)
			{
				return;
			}
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
				return;
			}

			const touches:Vector.<Touch> = event.getTouches(FeathersControl(this));
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
					return;
				}
				if(touch.phase == TouchPhase.ENDED)
				{
					this.touchPointID = -1;
					return;
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
						return;
					}
				}
			}
		}
	}
}