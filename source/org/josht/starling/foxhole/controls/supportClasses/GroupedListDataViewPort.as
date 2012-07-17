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
package org.josht.starling.foxhole.controls.supportClasses
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	import org.josht.starling.foxhole.controls.GroupedList;
	import org.josht.starling.foxhole.controls.renderers.IGroupedListItemRenderer;
	import org.josht.starling.foxhole.core.FoxholeControl;
	import org.josht.starling.foxhole.core.PropertyProxy;
	import org.josht.starling.foxhole.data.HierarchicalCollection;
	import org.josht.starling.foxhole.layout.ILayout;
	import org.josht.starling.foxhole.layout.IVirtualLayout;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class GroupedListDataViewPort extends FoxholeControl implements IViewPort
	{
		protected static const INVALIDATION_FLAG_ITEM_RENDERER_FACTORY:String = "itemRendererFactory";

		private static const helperPoint:Point = new Point();
		private static const helperRect:Rectangle = new Rectangle();

		public function GroupedListDataViewPort()
		{
		}

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

		protected var actualVisibleWidth:Number = NaN;

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

		protected var actualVisibleHeight:Number;

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

		private var _layoutItems:Vector.<DisplayObject> = new <DisplayObject>[];
		private var _unrenderedItems:Array = [];
		private var _inactiveItemRenderers:Vector.<IGroupedListItemRenderer> = new <IGroupedListItemRenderer>[];
		private var _activeItemRenderers:Vector.<IGroupedListItemRenderer> = new <IGroupedListItemRenderer>[];
		private var _itemRendererMap:Dictionary = new Dictionary(true);
		private var _headerRendererMap:Dictionary = new Dictionary(true);
		private var _footerRendererMap:Dictionary = new Dictionary(true);

		private var _isScrolling:Boolean = false;

		private var _owner:GroupedList;

		public function get owner():GroupedList
		{
			return this._owner;
		}

		public function set owner(value:GroupedList):void
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

		private var _dataProvider:HierarchicalCollection;

		public function get dataProvider():HierarchicalCollection
		{
			return this._dataProvider;
		}

		public function set dataProvider(value:HierarchicalCollection):void
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
				for(var item:Object in this._itemRendererMap)
				{
					var renderer:FoxholeControl = this._itemRendererMap[item] as FoxholeControl;
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

		private var _typicalHeader:Object = null;

		public function get typicalHeader():Object
		{
			return this._typicalHeader;
		}

		public function set typicalHeader(value:Object):void
		{
			if(this._typicalHeader == value)
			{
				return;
			}
			this._typicalHeader = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
		}

		private var _typicalFooter:Object = null;

		public function get typicalFooter():Object
		{
			return this._typicalFooter;
		}

		public function set typicalFooter(value:Object):void
		{
			if(this._typicalFooter == value)
			{
				return;
			}
			this._typicalFooter = value;
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

		private var _headerRendererType:Class;

		public function get headerRendererType():Class
		{
			return this._headerRendererType;
		}

		public function set headerRendererType(value:Class):void
		{
			if(this._headerRendererType == value)
			{
				return;
			}

			this._headerRendererType = value;
			this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		}

		private var _headerRendererFactory:Function;

		public function get headerRendererFactory():Function
		{
			return this._headerRendererFactory;
		}

		public function set headerRendererFactory(value:Function):void
		{
			if(this._headerRendererFactory === value)
			{
				return;
			}

			this._headerRendererFactory = value;
			this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		}

		protected var _headerRendererName:String;

		public function get headerRendererName():String
		{
			return this._headerRendererName;
		}

		public function set headerRendererName(value:String):void
		{
			if(this._headerRendererName == value)
			{
				return;
			}
			if(this._headerRendererName)
			{
				for(var item:Object in this._headerRendererMap)
				{
					var renderer:FoxholeControl = this._headerRendererMap[item] as FoxholeControl;
					if(renderer)
					{
						renderer.nameList.remove(this._headerRendererName);
					}
				}
			}
			this._headerRendererName = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		private var _headerRendererProperties:PropertyProxy;

		public function get headerRendererProperties():PropertyProxy
		{
			return this._headerRendererProperties;
		}

		public function set headerRendererProperties(value:PropertyProxy):void
		{
			if(this._headerRendererProperties == value)
			{
				return;
			}
			if(this._headerRendererProperties)
			{
				this._headerRendererProperties.onChange.remove(headerRendererProperties_onChange);
			}
			this._headerRendererProperties = PropertyProxy(value);
			if(this._headerRendererProperties)
			{
				this._headerRendererProperties.onChange.add(headerRendererProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES, INVALIDATION_FLAG_SCROLL);
		}

		private var _footerRendererType:Class;

		public function get footerRendererType():Class
		{
			return this._footerRendererType;
		}

		public function set footerRendererType(value:Class):void
		{
			if(this._footerRendererType == value)
			{
				return;
			}

			this._footerRendererType = value;
			this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		}

		private var _footerRendererFactory:Function;

		public function get footerRendererFactory():Function
		{
			return this._footerRendererFactory;
		}

		public function set footerRendererFactory(value:Function):void
		{
			if(this._footerRendererFactory === value)
			{
				return;
			}

			this._footerRendererFactory = value;
			this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER_FACTORY);
		}

		protected var _footerRendererName:String;

		public function get footerRendererName():String
		{
			return this._footerRendererName;
		}

		public function set footerRendererName(value:String):void
		{
			if(this._footerRendererName == value)
			{
				return;
			}
			if(this._footerRendererName)
			{
				for(var item:Object in this._footerRendererMap)
				{
					var renderer:FoxholeControl = this._footerRendererMap[item] as FoxholeControl;
					if(renderer)
					{
						renderer.nameList.remove(this._footerRendererName);
					}
				}
			}
			this._footerRendererName = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		private var _footerRendererProperties:PropertyProxy;

		public function get footerRendererProperties():PropertyProxy
		{
			return this._footerRendererProperties;
		}

		public function set footerRendererProperties(value:PropertyProxy):void
		{
			if(this._footerRendererProperties == value)
			{
				return;
			}
			if(this._footerRendererProperties)
			{
				this._footerRendererProperties.onChange.remove(footerRendererProperties_onChange);
			}
			this._footerRendererProperties = PropertyProxy(value);
			if(this._footerRendererProperties)
			{
				this._footerRendererProperties.onChange.add(footerRendererProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES, INVALIDATION_FLAG_SCROLL);
		}

		private var _ignoreLayoutChanges:Boolean = false;

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

		protected var _onChange:Signal = new Signal(GroupedListDataViewPort);

		public function get onChange():ISignal
		{
			return this._onChange;
		}

		protected var _onItemTouch:Signal = new Signal(GroupedListDataViewPort, Object, int, int, TouchEvent);

		public function get onItemTouch():ISignal
		{
			return this._onItemTouch;
		}

		override public function dispose():void
		{
			this._onChange.removeAll();
			this._onItemTouch.removeAll();
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

			if(stylesInvalid || dataInvalid || itemRendererInvalid)
			{
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
			/*if(scrollInvalid || selectionInvalid || sizeInvalid || dataInvalid || itemRendererInvalid)
			{
				this.refreshSelection();
			}*/
			const rendererCount:int = this._activeItemRenderers.length;
			for(var i:int = 0; i < rendererCount; i++)
			{
				var itemRenderer:DisplayObject = DisplayObject(this._activeItemRenderers[i]);
				if(itemRenderer is FoxholeControl)
				{
					const foxholeItemRenderer:FoxholeControl = FoxholeControl(itemRenderer);
					if(stateInvalid || dataInvalid || scrollInvalid || itemRendererInvalid)
					{
						foxholeItemRenderer.isEnabled = this._isEnabled;
					}
					if(stylesInvalid && this._itemRendererName && !foxholeItemRenderer.nameList.contains(this._itemRendererName))
					{
						foxholeItemRenderer.nameList.add(this._itemRendererName);
					}
					foxholeItemRenderer.validate();
				}
			}

			if(scrollInvalid || dataInvalid || itemRendererInvalid || sizeInvalid)
			{
				helperRect.x = helperRect.y = 0;
				helperRect.width = this.actualVisibleWidth;
				helperRect.height = this.actualVisibleHeight;
				this._layout.layout(this._layoutItems, helperRect, helperPoint);
				this.setSizeInternal(helperPoint.x, helperPoint.y, false);
			}
		}

		protected function calculateTypicalValues():void
		{
			var typicalItem:Object = this._typicalItem;
			if(!typicalItem && this._dataProvider && this._dataProvider.length > 0)
			{
				typicalItem = this._dataProvider.getItemAt(0);
			}

			const typicalRenderer:IGroupedListItemRenderer = this.createRenderer(typicalItem, 0, 0, true);
			this.refreshOneItemRendererStyles(typicalRenderer);
			if(typicalRenderer is FoxholeControl)
			{
				FoxholeControl(typicalRenderer).validate();
			}
			this._typicalItemWidth = DisplayObject(typicalRenderer).width;
			this._typicalItemHeight = DisplayObject(typicalRenderer).height;
			this.destroyRenderer(typicalRenderer);
		}

		public function itemToItemRenderer(item:Object):IGroupedListItemRenderer
		{
			return IGroupedListItemRenderer(this._itemRendererMap[item]);
		}

		protected function refreshItemRendererStyles():void
		{
			for each(var renderer:IGroupedListItemRenderer in this._activeItemRenderers)
			{
				this.refreshOneItemRendererStyles(renderer);
			}
		}

		protected function refreshOneItemRendererStyles(renderer:IGroupedListItemRenderer):void
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

		/*protected function refreshSelection():void
		{
			this._ignoreSelectionChanges = true;
			for each(var renderer:IGroupedListItemRenderer in this._activeItemRenderers)
			{
				renderer.isSelected = renderer.index == this._selectedIndex;
			}
			this._ignoreSelectionChanges = false;
		}*/

		protected function refreshRenderers(itemRendererTypeIsInvalid:Boolean):void
		{
			const temp:Vector.<IGroupedListItemRenderer> = this._inactiveItemRenderers;
			this._inactiveItemRenderers = this._activeItemRenderers;
			this._activeItemRenderers = temp;
			this._activeItemRenderers.length = 0;
			if(itemRendererTypeIsInvalid)
			{
				this.recoverInactiveRenderers();
				this.freeInactiveRenderers();
			}

			this._layoutItems.length = this._dataProvider ? this._dataProvider.length : 0;

			if(isNaN(this.explicitVisibleWidth))
			{
				this.actualVisibleWidth = Math.min(this._maxVisibleWidth, Math.max(0, this._minVisibleWidth, this._typicalItemWidth));
			}
			else
			{
				this.actualVisibleWidth = Math.max(0, this.explicitVisibleWidth);
			}
			if(isNaN(this.explicitVisibleHeight))
			{
				const itemCount:int = this._dataProvider ? this._dataProvider.length : 0;
				this.actualVisibleHeight = Math.min(this._maxVisibleHeight, Math.max(0, this._minVisibleHeight, itemCount * this._typicalItemHeight));
			}
			else
			{
				this.actualVisibleHeight = Math.max(0, this.explicitVisibleHeight);
			}

			this.findUnrenderedData();
			this.recoverInactiveRenderers();
			this.renderUnrenderedData();
			this.freeInactiveRenderers();
		}

		private function findUnrenderedData():void
		{
			const itemCount:int = this._dataProvider ? this._dataProvider.length : 0;
			var startIndex:int = 0;
			var endIndex:int = itemCount;
			const virtualLayout:IVirtualLayout = this._layout as IVirtualLayout;
			const useVirtualLayout:Boolean = virtualLayout && virtualLayout.useVirtualLayout;
			if(useVirtualLayout)
			{
				this._ignoreLayoutChanges = true;
				virtualLayout.typicalItemWidth = this._typicalItemWidth;
				virtualLayout.typicalItemHeight = this._typicalItemHeight;
				this._ignoreLayoutChanges = false;
				startIndex = virtualLayout.getMinimumItemIndexAtScrollPosition(this._horizontalScrollPosition, this._verticalScrollPosition, this.actualVisibleWidth, this.actualVisibleHeight, itemCount);
				endIndex = virtualLayout.getMaximumItemIndexAtScrollPosition(this._horizontalScrollPosition, this._verticalScrollPosition, this.actualVisibleWidth, this.actualVisibleHeight, itemCount);
			}
			for(var i:int = 0; i < itemCount; i++)
			{
				if(i < startIndex || i >= endIndex)
				{
					this._layoutItems[i] = null;
				}
				else
				{
					var item:Object = this._dataProvider.getItemAt(i);
					var renderer:IGroupedListItemRenderer = IGroupedListItemRenderer(this._itemRendererMap[item]);
					if(renderer)
					{
						//the index may have changed if data was added or removed
						renderer.index = i;
						this._activeItemRenderers.push(renderer);
						this._inactiveItemRenderers.splice(this._inactiveItemRenderers.indexOf(renderer), 1);
						var displayRenderer:DisplayObject = DisplayObject(renderer);
						this._layoutItems[i] = displayRenderer;
					}
					else
					{
						this._unrenderedItems.push(item);
					}
				}
			}
		}

		private function renderUnrenderedData():void
		{
			const itemCount:int = this._unrenderedItems.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:Object = this._unrenderedItems.shift();
				var indices:Vector.<int> = this._dataProvider.getItemIndex(item);
				var renderer:IGroupedListItemRenderer = this.createRenderer(item, indices[0], indices[1], false);
				var displayRenderer:DisplayObject = DisplayObject(renderer);
				this._layoutItems[index] = displayRenderer;
			}
		}

		private function recoverInactiveRenderers():void
		{
			const itemCount:int = this._inactiveItemRenderers.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var renderer:IGroupedListItemRenderer = this._inactiveItemRenderers[i];
				delete this._itemRendererMap[renderer.data];
			}
		}

		private function freeInactiveRenderers():void
		{
			const itemCount:int = this._inactiveItemRenderers.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var renderer:IGroupedListItemRenderer = this._inactiveItemRenderers.shift();
				this.destroyRenderer(renderer);
			}
		}

		private function createRenderer(item:Object, groupIndex:int, itemIndex:int, isTemporary:Boolean = false):IGroupedListItemRenderer
		{
			if(isTemporary || this._inactiveItemRenderers.length == 0)
			{
				var renderer:IGroupedListItemRenderer;
				if(this._itemRendererFactory != null)
				{
					renderer = IGroupedListItemRenderer(this._itemRendererFactory());
				}
				else
				{
					renderer = new this._itemRendererType();
				}
				//renderer.onChange.add(renderer_onChange);
				const displayRenderer:DisplayObject = DisplayObject(renderer);
				displayRenderer.addEventListener(TouchEvent.TOUCH, renderer_touchHandler);
				this.addChild(displayRenderer);
			}
			else
			{
				renderer = this._inactiveItemRenderers.shift();
			}
			renderer.data = item;
			renderer.groupIndex = groupIndex;
			renderer.itemIndex = itemIndex;
			renderer.owner = this.owner;

			if(!isTemporary)
			{
				this._itemRendererMap[item] = renderer;
				this._activeItemRenderers.push(renderer);
			}

			return renderer;
		}

		private function destroyRenderer(renderer:IGroupedListItemRenderer):void
		{
			//renderer.onChange.remove(renderer_onChange);
			const displayRenderer:DisplayObject = DisplayObject(renderer);
			displayRenderer.removeEventListener(TouchEvent.TOUCH, renderer_touchHandler);
			this.removeChild(displayRenderer, true);
		}

		private function itemRendererProperties_onChange(proxy:PropertyProxy, name:Object):void
		{
			this.invalidate(INVALIDATION_FLAG_SCROLL, INVALIDATION_FLAG_STYLES);
		}

		private function headerRendererProperties_onChange(proxy:PropertyProxy, name:Object):void
		{
			this.invalidate(INVALIDATION_FLAG_SCROLL, INVALIDATION_FLAG_STYLES);
		}

		private function footerRendererProperties_onChange(proxy:PropertyProxy, name:Object):void
		{
			this.invalidate(INVALIDATION_FLAG_SCROLL, INVALIDATION_FLAG_STYLES);
		}

		private function owner_onScroll(list:GroupedList):void
		{
			this._isScrolling = true;
		}

		private function dataProvider_onChange(data:HierarchicalCollection):void
		{
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		private function dataProvider_onItemUpdate(data:HierarchicalCollection, index:int):void
		{
			const item:Object = this._dataProvider.getItemAt(index);
			const renderer:IGroupedListItemRenderer = IGroupedListItemRenderer(this._itemRendererMap[item]);
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
		}

		/*private function renderer_onChange(renderer:IGroupedListItemRenderer):void
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
		}*/

		private function renderer_touchHandler(event:TouchEvent):void
		{
			if(!this._isEnabled)
			{
				return;
			}

			const renderer:IGroupedListItemRenderer = IGroupedListItemRenderer(event.currentTarget);
			const displayRenderer:DisplayObject = DisplayObject(renderer);
			const touch:Touch = event.getTouch(displayRenderer);
			if(touch && touch.phase == TouchPhase.BEGAN)
			{
				//if this flag gets set to true before the touch phase ends, we
				//won't change selection.
				this._isScrolling = false;
			}

			this._onItemTouch.dispatch(this, renderer.data, renderer.groupIndex, renderer.itemIndex, event);
		}
	}
}
