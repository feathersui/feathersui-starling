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

	import feathers.controls.GroupedList;
	import feathers.controls.Scroller;
	import feathers.controls.renderers.IGroupedListHeaderOrFooterRenderer;
	import feathers.controls.renderers.IGroupedListItemRenderer;
	import feathers.core.FeathersControl;
	import feathers.core.PropertyProxy;
	import feathers.data.HierarchicalCollection;
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
	 * Used internally by GroupedList. Not meant to be used on its own.
	 */
	public class GroupedListDataViewPort extends FeathersControl implements IViewPort
	{
		protected static const INVALIDATION_FLAG_ITEM_RENDERER_FACTORY:String = "itemRendererFactory";

		private static const helperPoint:Point = new Point();
		private static const helperBounds:ViewPortBounds = new ViewPortBounds();
		private static const helperResult:LayoutBoundsResult = new LayoutBoundsResult();
		private static const helperVector:Vector.<int> = new <int>[];

		public function GroupedListDataViewPort()
		{
			super();
			this.addEventListener(TouchEvent.TOUCH, touchHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
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

		private var _typicalHeaderWidth:Number = NaN;

		public function get typicalHeaderWidth():Number
		{
			return this._typicalHeaderWidth;
		}

		private var _typicalHeaderHeight:Number = NaN;

		public function get typicalHeaderHeight():Number
		{
			return this._typicalHeaderHeight;
		}

		private var _typicalFooterWidth:Number = NaN;

		public function get typicalFooterWidth():Number
		{
			return this._typicalFooterWidth;
		}

		private var _typicalFooterHeight:Number = NaN;

		public function get typicalFooterHeight():Number
		{
			return this._typicalFooterHeight;
		}

		private var _layoutItems:Vector.<DisplayObject> = new <DisplayObject>[];
		private var _unrenderedItems:Array = [];
		private var _inactiveItemRenderers:Vector.<IGroupedListItemRenderer> = new <IGroupedListItemRenderer>[];
		private var _activeItemRenderers:Vector.<IGroupedListItemRenderer> = new <IGroupedListItemRenderer>[];
		private var _itemRendererMap:Dictionary = new Dictionary(true);
		private var _unrenderedHeaders:Vector.<int> = new <int>[];
		private var _inactiveHeaderRenderers:Vector.<IGroupedListHeaderOrFooterRenderer> = new <IGroupedListHeaderOrFooterRenderer>[];
		private var _activeHeaderRenderers:Vector.<IGroupedListHeaderOrFooterRenderer> = new <IGroupedListHeaderOrFooterRenderer>[];
		private var _headerRendererMap:Dictionary = new Dictionary(true);
		private var _unrenderedFooters:Vector.<int> = new <int>[];
		private var _inactiveFooterRenderers:Vector.<IGroupedListHeaderOrFooterRenderer> = new <IGroupedListHeaderOrFooterRenderer>[];
		private var _activeFooterRenderers:Vector.<IGroupedListHeaderOrFooterRenderer> = new <IGroupedListHeaderOrFooterRenderer>[];
		private var _footerRendererMap:Dictionary = new Dictionary(true);
		private var _headerIndices:Vector.<int> = new <int>[];
		private var _footerIndices:Vector.<int> = new <int>[];

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

		protected var _isSelectable:Boolean = true;

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
				this.setSelectedLocation(-1, -1);
			}
			this.invalidate(INVALIDATION_FLAG_SELECTED);
		}

		protected var _selectedGroupIndex:int = -1;

		public function get selectedGroupIndex():int
		{
			return this._selectedGroupIndex;
		}

		private var _selectedItemIndex:int = -1;

		public function get selectedItemIndex():int
		{
			return this._selectedItemIndex;
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
					var renderer:FeathersControl = this._itemRendererMap[item] as FeathersControl;
					if(renderer)
					{
						renderer.nameList.remove(this._itemRendererName);
					}
				}
			}
			this._itemRendererName = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
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
				for(var index:Object in this._headerRendererMap)
				{
					var renderer:FeathersControl = this._headerRendererMap[index] as FeathersControl;
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
				for(var index:Object in this._footerRendererMap)
				{
					var renderer:FeathersControl = this._footerRendererMap[index] as FeathersControl;
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
				if(this._layout is IVariableVirtualLayout)
				{
					IVariableVirtualLayout(this._layout).hasVariableItemDimensions = true;
				}
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

		private var _minimumItemCount:int;
		private var _minimumHeaderCount:int;
		private var _minimumFooterCount:int;

		private var _ignoreSelectionChanges:Boolean = false;

		protected var _onChange:Signal = new Signal(GroupedListDataViewPort);

		public function get onChange():ISignal
		{
			return this._onChange;
		}

		override public function dispose():void
		{
			this._onChange.removeAll();
			super.dispose();
		}

		public function setSelectedLocation(groupIndex:int, itemIndex:int):void
		{
			if(this._selectedGroupIndex == groupIndex && this._selectedItemIndex == itemIndex)
			{
				return;
			}
			if((groupIndex < 0 && itemIndex >= 0) || (groupIndex >= 0 && itemIndex < 0))
			{
				throw new ArgumentError("To deselect items, group index and item index must both be < 0.");
			}
			this._selectedGroupIndex = groupIndex;
			this._selectedItemIndex = itemIndex;

			this.invalidate(INVALIDATION_FLAG_SELECTED);
			this._onChange.dispatch(this);
		}

		public function getScrollPositionForIndex(groupIndex:int, itemIndex:int, result:Point = null):Point
		{
			if(!result)
			{
				result = new Point();
			}

			const displayIndex:int = this.locationToDisplayIndex(groupIndex, itemIndex);
			return this._layout.getScrollPositionForIndex(displayIndex, this._layoutItems, 0, 0, this.actualVisibleWidth, this.actualVisibleHeight, result);
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
				this.refreshHeaderRendererStyles();
				this.refreshFooterRendererStyles();
				this.refreshItemRendererStyles();
			}
			if(scrollInvalid || selectionInvalid || sizeInvalid || dataInvalid || itemRendererInvalid)
			{
				this.refreshSelection();
			}
			var rendererCount:int = this._activeItemRenderers.length;
			for(var i:int = 0; i < rendererCount; i++)
			{
				var renderer:DisplayObject = DisplayObject(this._activeItemRenderers[i]);
				if(renderer is FeathersControl)
				{
					var uiRenderer:FeathersControl = FeathersControl(renderer);
					if(stateInvalid || dataInvalid || scrollInvalid || itemRendererInvalid)
					{
						uiRenderer.isEnabled = this._isEnabled;
					}
					if(stylesInvalid && this._itemRendererName && !uiRenderer.nameList.contains(this._itemRendererName))
					{
						uiRenderer.nameList.add(this._itemRendererName);
					}
					uiRenderer.validate();
				}
			}
			rendererCount = this._activeHeaderRenderers.length;
			for(i = 0; i < rendererCount; i++)
			{
				renderer = DisplayObject(this._activeHeaderRenderers[i]);
				if(renderer is FeathersControl)
				{
					uiRenderer = FeathersControl(renderer);
					if(stateInvalid || dataInvalid || scrollInvalid || itemRendererInvalid)
					{
						uiRenderer.isEnabled = this._isEnabled;
					}
					if(stylesInvalid && this._headerRendererName && !uiRenderer.nameList.contains(this._headerRendererName))
					{
						uiRenderer.nameList.add(this._headerRendererName);
					}
					uiRenderer.validate();
				}
			}
			rendererCount = this._activeFooterRenderers.length;
			for(i = 0; i < rendererCount; i++)
			{
				renderer = DisplayObject(this._activeFooterRenderers[i]);
				if(renderer is FeathersControl)
				{
					uiRenderer = FeathersControl(renderer);
					if(stateInvalid || dataInvalid || scrollInvalid || itemRendererInvalid)
					{
						uiRenderer.isEnabled = this._isEnabled;
					}
					if(stylesInvalid && this._footerRendererName && !uiRenderer.nameList.contains(this._footerRendererName))
					{
						uiRenderer.nameList.add(this._footerRendererName);
					}
					uiRenderer.validate();
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
			var typicalHeader:Object = this._typicalHeader;
			var typicalFooter:Object = this._typicalFooter;
			if(!typicalHeader || !typicalFooter)
			{
				if(this._dataProvider && this._dataProvider.getLength() > 0)
				{
					var group:Object = this._dataProvider.getItemAt(0);
					if(!typicalHeader)
					{
						typicalHeader = this._owner.groupToHeaderData(group);
					}
					if(!typicalFooter)
					{
						typicalFooter = this._owner.groupToFooterData(group);
					}
				}
				else
				{
					this._typicalHeaderWidth = 0;
					this._typicalFooterWidth = 0;
					this._typicalFooterHeight= 0;
					this._typicalHeaderHeight = 0;
				}
			}

			//headers are optional
			if(typicalHeader)
			{
				const typicalHeaderRenderer:IGroupedListHeaderOrFooterRenderer = this.createHeaderRenderer(typicalHeader, 0, 0, true);
				this.refreshOneHeaderRendererStyles(typicalHeaderRenderer);
				if(typicalHeaderRenderer is FeathersControl)
				{
					FeathersControl(typicalHeaderRenderer).validate();
				}
				var displayRenderer:DisplayObject = DisplayObject(typicalHeaderRenderer);
				this._typicalHeaderWidth = displayRenderer.width;
				this._typicalHeaderHeight = displayRenderer.height;
				this.destroyHeaderRenderer(typicalHeaderRenderer);
			}

			//footers are optional
			if(typicalFooter)
			{
				const typicalFooterRenderer:IGroupedListHeaderOrFooterRenderer = this.createFooterRenderer(typicalFooter, 0, 0, true);
				this.refreshOneFooterRendererStyles(typicalFooterRenderer);
				if(typicalFooterRenderer is FeathersControl)
				{
					FeathersControl(typicalFooterRenderer).validate();
				}
				displayRenderer = DisplayObject(typicalFooterRenderer);
				this._typicalFooterWidth = displayRenderer.width;
				this._typicalFooterHeight = displayRenderer.height;
				this.destroyFooterRenderer(typicalFooterRenderer);
			}

			var typicalItem:Object = this._typicalItem;
			if(!typicalItem)
			{
				if(this._dataProvider && this._dataProvider.getLength() > 0)
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

			const typicalItemRenderer:IGroupedListItemRenderer = this.createItemRenderer(typicalItem, 0, 0, 0, true);
			this.refreshOneItemRendererStyles(typicalItemRenderer);
			if(typicalItemRenderer is FeathersControl)
			{
				FeathersControl(typicalItemRenderer).validate();
			}
			displayRenderer = DisplayObject(typicalItemRenderer);
			this._typicalItemWidth = displayRenderer.width;
			this._typicalItemHeight = displayRenderer.height;
			this.destroyItemRenderer(typicalItemRenderer);
		}

		protected function refreshItemRendererStyles():void
		{
			for each(var renderer:IGroupedListItemRenderer in this._activeItemRenderers)
			{
				this.refreshOneItemRendererStyles(renderer);
			}
		}

		protected function refreshHeaderRendererStyles():void
		{
			for each(var renderer:IGroupedListHeaderOrFooterRenderer in this._activeHeaderRenderers)
			{
				this.refreshOneHeaderRendererStyles(renderer);
			}
		}

		protected function refreshFooterRendererStyles():void
		{
			for each(var renderer:IGroupedListHeaderOrFooterRenderer in this._activeFooterRenderers)
			{
				this.refreshOneFooterRendererStyles(renderer);
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

		protected function refreshOneHeaderRendererStyles(renderer:IGroupedListHeaderOrFooterRenderer):void
		{
			const displayRenderer:DisplayObject = DisplayObject(renderer);
			for(var propertyName:String in this._headerRendererProperties)
			{
				if(displayRenderer.hasOwnProperty(propertyName))
				{
					var propertyValue:Object = this._headerRendererProperties[propertyName];
					displayRenderer[propertyName] = propertyValue;
				}
			}
		}

		protected function refreshOneFooterRendererStyles(renderer:IGroupedListHeaderOrFooterRenderer):void
		{
			const displayRenderer:DisplayObject = DisplayObject(renderer);
			for(var propertyName:String in this._footerRendererProperties)
			{
				if(displayRenderer.hasOwnProperty(propertyName))
				{
					var propertyValue:Object = this._footerRendererProperties[propertyName];
					displayRenderer[propertyName] = propertyValue;
				}
			}
		}

		protected function refreshSelection():void
		{
			this._ignoreSelectionChanges = true;
			for each(var renderer:IGroupedListItemRenderer in this._activeItemRenderers)
			{
				renderer.isSelected = renderer.groupIndex == this._selectedGroupIndex &&
					renderer.itemIndex == this._selectedItemIndex;
			}
			this._ignoreSelectionChanges = false;
		}

		protected function refreshRenderers(itemRendererTypeIsInvalid:Boolean):void
		{
			const temp:Vector.<IGroupedListItemRenderer> = this._inactiveItemRenderers;
			this._inactiveItemRenderers = this._activeItemRenderers;
			this._activeItemRenderers = temp;
			this._activeItemRenderers.length = 0;
			var temp2:Vector.<IGroupedListHeaderOrFooterRenderer> = this._inactiveHeaderRenderers;
			this._inactiveHeaderRenderers = this._activeHeaderRenderers;
			this._activeHeaderRenderers = temp2;
			this._activeHeaderRenderers.length = 0;
			temp2 = this._inactiveFooterRenderers;
			this._inactiveFooterRenderers = this._activeFooterRenderers;
			this._activeFooterRenderers = temp2;
			this._activeFooterRenderers.length = 0;
			if(itemRendererTypeIsInvalid)
			{
				this.recoverInactiveRenderers();
				this.freeInactiveRenderers();
			}
			this._headerIndices.length = 0;
			this._footerIndices.length = 0;

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
			const groupCount:int = this._dataProvider ? this._dataProvider.getLength() : 0;
			var totalLayoutCount:int = 0;
			var totalHeaderCount:int = 0;
			var totalFooterCount:int = 0;
			var averageItemsPerGroup:int = 0;
			for(var i:int = 0; i < groupCount; i++)
			{
				var group:Object = this._dataProvider.getItemAt(i);
				if(this._owner.groupToHeaderData(group) !== null)
				{
					this._headerIndices.push(totalLayoutCount);
					totalLayoutCount++;
					totalHeaderCount++;
				}
				var currentItemCount:int = this._dataProvider.getLength(i);
				totalLayoutCount += currentItemCount;
				averageItemsPerGroup += currentItemCount;
				if(this._owner.groupToFooterData(group) !== null)
				{
					this._footerIndices.push(totalLayoutCount);
					totalLayoutCount++;
					totalFooterCount++;
				}
			}
			this._layoutItems.length = totalLayoutCount;
			const virtualLayout:IVirtualLayout = this._layout as IVirtualLayout;
			const useVirtualLayout:Boolean = virtualLayout && virtualLayout.useVirtualLayout;
			if(useVirtualLayout)
			{
				this._ignoreLayoutChanges = true;
				virtualLayout.typicalItemWidth = this._typicalItemWidth;
				virtualLayout.typicalItemHeight = this._typicalItemHeight;
				this._ignoreLayoutChanges = false;
				virtualLayout.measureViewPort(totalLayoutCount, helperBounds, helperPoint);
				virtualLayout.getVisibleIndicesAtScrollPosition(this._horizontalScrollPosition, this._verticalScrollPosition, helperPoint.x, helperPoint.y, totalLayoutCount, helperVector);

				averageItemsPerGroup /= groupCount;
				this._minimumHeaderCount = this._minimumFooterCount = Math.ceil(helperPoint.y / (this._typicalItemHeight * averageItemsPerGroup));
				this._minimumHeaderCount = Math.min(this._minimumHeaderCount, totalHeaderCount);
				this._minimumFooterCount = Math.min(this._minimumFooterCount, totalFooterCount);

				//assumes that zero headers/footers might be visible
				this._minimumItemCount = Math.ceil(helperPoint.y / this._typicalItemHeight) + 1;
			}
			var currentIndex:int = 0;
			for(i = 0; i < groupCount; i++)
			{
				group = this._dataProvider.getItemAt(i);
				var header:Object = this._owner.groupToHeaderData(group);
				if(header !== null)
				{
					//the end index is included in the visible items
					if(useVirtualLayout && helperVector.indexOf(currentIndex) < 0)
					{
						this._layoutItems[currentIndex] = null;
					}
					else
					{
						var headerOrFooterRenderer:IGroupedListHeaderOrFooterRenderer = IGroupedListHeaderOrFooterRenderer(this._headerRendererMap[header]);
						if(headerOrFooterRenderer)
						{
							headerOrFooterRenderer.layoutIndex = currentIndex;
							headerOrFooterRenderer.groupIndex = i;
							this._activeHeaderRenderers.push(headerOrFooterRenderer);
							this._inactiveHeaderRenderers.splice(this._inactiveHeaderRenderers.indexOf(headerOrFooterRenderer), 1);
							var displayRenderer:DisplayObject = DisplayObject(headerOrFooterRenderer);
							displayRenderer.visible = true;
							this._layoutItems[currentIndex] = displayRenderer;
						}
						else
						{
							this._unrenderedHeaders.push(i);
							this._unrenderedHeaders.push(currentIndex);
						}
					}
					currentIndex++;
				}
				currentItemCount = this._dataProvider.getLength(i);
				for(var j:int = 0; j < currentItemCount; j++)
				{
					if(useVirtualLayout && helperVector.indexOf(currentIndex) < 0)
					{
						this._layoutItems[currentIndex] = null;
					}
					else
					{
						var item:Object = this._dataProvider.getItemAt(i, j);
						var itemRenderer:IGroupedListItemRenderer = IGroupedListItemRenderer(this._itemRendererMap[item]);
						if(itemRenderer)
						{
							itemRenderer.groupIndex = i;
							itemRenderer.itemIndex = j;
							itemRenderer.layoutIndex = currentIndex;
							this._activeItemRenderers.push(itemRenderer);
							this._inactiveItemRenderers.splice(this._inactiveItemRenderers.indexOf(itemRenderer), 1);
							displayRenderer = DisplayObject(itemRenderer);
							displayRenderer.visible = true;
							this._layoutItems[currentIndex] = displayRenderer;
						}
						else
						{
							this._unrenderedItems.push(i);
							this._unrenderedItems.push(j);
							this._unrenderedItems.push(currentIndex);
						}
					}
					currentIndex++;
				}
				var footer:Object = this._owner.groupToFooterData(group);
				if(footer !== null)
				{
					if(useVirtualLayout && helperVector.indexOf(currentIndex) < 0)
					{
						this._layoutItems[currentIndex] = null;
					}
					else
					{
						headerOrFooterRenderer = IGroupedListHeaderOrFooterRenderer(this._footerRendererMap[footer]);
						if(headerOrFooterRenderer)
						{
							headerOrFooterRenderer.groupIndex = i;
							headerOrFooterRenderer.layoutIndex = currentIndex;
							this._activeFooterRenderers.push(headerOrFooterRenderer);
							this._inactiveFooterRenderers.splice(this._inactiveFooterRenderers.indexOf(headerOrFooterRenderer), 1);
							displayRenderer = DisplayObject(headerOrFooterRenderer);
							displayRenderer.visible = true;
							this._layoutItems[currentIndex] = displayRenderer;
						}
						else
						{
							this._unrenderedFooters.push(i);
							this._unrenderedFooters.push(currentIndex);
						}
					}
					currentIndex++;
				}
			}
		}

		private function renderUnrenderedData():void
		{
			var rendererCount:int = this._unrenderedItems.length;
			for(var i:int = 0; i < rendererCount; i += 3)
			{
				var groupIndex:int = this._unrenderedItems.shift();
				var itemIndex:int = this._unrenderedItems.shift();
				var layoutIndex:int = this._unrenderedItems.shift();
				var item:Object = this._dataProvider.getItemAt(groupIndex, itemIndex);
				var itemRenderer:IGroupedListItemRenderer = this.createItemRenderer(item, groupIndex, itemIndex, layoutIndex, false);
				this._layoutItems[layoutIndex] = DisplayObject(itemRenderer);
			}

			rendererCount = this._unrenderedHeaders.length;
			for(i = 0; i < rendererCount; i += 2)
			{
				groupIndex = this._unrenderedHeaders.shift();
				layoutIndex = this._unrenderedHeaders.shift();
				item = this._dataProvider.getItemAt(groupIndex);
				item = this._owner.groupToHeaderData(item);
				var headerOrFooterRenderer:IGroupedListHeaderOrFooterRenderer = this.createHeaderRenderer(item, groupIndex, layoutIndex, false);
				this._layoutItems[layoutIndex] = DisplayObject(headerOrFooterRenderer);
			}

			rendererCount = this._unrenderedFooters.length;
			for(i = 0; i < rendererCount; i += 2)
			{
				groupIndex = this._unrenderedFooters.shift();
				layoutIndex = this._unrenderedFooters.shift();
				item = this._dataProvider.getItemAt(groupIndex);
				item = this._owner.groupToFooterData(item);
				headerOrFooterRenderer = this.createFooterRenderer(item, groupIndex, layoutIndex, false);
				this._layoutItems[layoutIndex] = DisplayObject(headerOrFooterRenderer);
			}
		}

		private function recoverInactiveRenderers():void
		{
			var rendererCount:int = this._inactiveItemRenderers.length;
			for(var i:int = 0; i < rendererCount; i++)
			{
				var itemRenderer:IGroupedListItemRenderer = this._inactiveItemRenderers[i];
				delete this._itemRendererMap[itemRenderer.data];
			}

			rendererCount = this._inactiveHeaderRenderers.length;
			for(i = 0; i < rendererCount; i++)
			{
				var headerOrFooterRenderer:IGroupedListHeaderOrFooterRenderer = this._inactiveHeaderRenderers[i];
				delete this._headerRendererMap[headerOrFooterRenderer.data];
			}

			rendererCount = this._inactiveFooterRenderers.length;
			for(i = 0; i < rendererCount; i++)
			{
				headerOrFooterRenderer = this._inactiveFooterRenderers[i];
				delete this._footerRendererMap[headerOrFooterRenderer.data];
			}
		}

		private function freeInactiveRenderers():void
		{
			//we may keep around some extra renderers to avoid too much
			//allocation and garbage collection. they'll be hidden.
			var keepCount:int = Math.min(this._minimumItemCount - this._activeItemRenderers.length, this._inactiveItemRenderers.length);
			for(var i:int = 0; i < keepCount; i++)
			{
				var itemRenderer:IGroupedListItemRenderer = this._inactiveItemRenderers.shift();
				DisplayObject(itemRenderer).visible = false;
				this._activeItemRenderers.push(itemRenderer);
			}
			var rendererCount:int = this._inactiveItemRenderers.length;
			for(i = 0; i < rendererCount; i++)
			{
				itemRenderer = this._inactiveItemRenderers.shift();
				this.destroyItemRenderer(itemRenderer);
			}

			keepCount = Math.min(this._minimumHeaderCount - this._activeHeaderRenderers.length, this._inactiveHeaderRenderers.length);
			for(i = 0; i < keepCount; i++)
			{
				var headerOrFooterRenderer:IGroupedListHeaderOrFooterRenderer = this._inactiveHeaderRenderers.shift();
				DisplayObject(headerOrFooterRenderer).visible = false;
				this._activeHeaderRenderers.push(headerOrFooterRenderer);
			}
			rendererCount = this._inactiveHeaderRenderers.length;
			for(i = 0; i < rendererCount; i++)
			{
				headerOrFooterRenderer = this._inactiveHeaderRenderers.shift();
				this.destroyHeaderRenderer(headerOrFooterRenderer);
			}

			keepCount = Math.min(this._minimumFooterCount - this._activeFooterRenderers.length, this._inactiveFooterRenderers.length);
			for(i = 0; i < keepCount; i++)
			{
				headerOrFooterRenderer = this._inactiveFooterRenderers.shift();
				DisplayObject(headerOrFooterRenderer).visible = false;
				this._activeFooterRenderers.push(headerOrFooterRenderer);
			}
			rendererCount = this._inactiveFooterRenderers.length;
			for(i = 0; i < rendererCount; i++)
			{
				headerOrFooterRenderer = this._inactiveFooterRenderers.shift();
				this.destroyFooterRenderer(headerOrFooterRenderer);
			}
		}

		private function createItemRenderer(item:Object, groupIndex:int, itemIndex:int, layoutIndex:int, isTemporary:Boolean = false):IGroupedListItemRenderer
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
				renderer = this._inactiveItemRenderers.shift();
			}
			renderer.data = item;
			renderer.groupIndex = groupIndex;
			renderer.itemIndex = itemIndex;
			renderer.layoutIndex = layoutIndex;
			renderer.owner = this._owner;
			DisplayObject(renderer).visible = true;

			if(!isTemporary)
			{
				this._itemRendererMap[item] = renderer;
				this._activeItemRenderers.push(renderer);
				displayRenderer = FeathersControl(renderer);
				displayRenderer.onResize.add(itemRenderer_onResize);
			}

			return renderer;
		}

		private function createHeaderRenderer(header:Object, groupIndex:int, layoutIndex:int, isTemporary:Boolean = false):IGroupedListHeaderOrFooterRenderer
		{
			if(isTemporary || this._inactiveHeaderRenderers.length == 0)
			{
				var renderer:IGroupedListHeaderOrFooterRenderer;
				if(this._headerRendererFactory != null)
				{
					renderer = IGroupedListHeaderOrFooterRenderer(this._headerRendererFactory());
				}
				else
				{
					renderer = new this._headerRendererType();
				}
				var displayRenderer:FeathersControl = FeathersControl(renderer);
				this.addChild(displayRenderer);
			}
			else
			{
				renderer = this._inactiveHeaderRenderers.shift();
			}
			renderer.data = header;
			renderer.groupIndex = groupIndex;
			renderer.layoutIndex = layoutIndex;
			renderer.owner = this._owner;
			DisplayObject(renderer).visible = true;

			if(!isTemporary)
			{
				this._headerRendererMap[header] = renderer;
				this._activeHeaderRenderers.push(renderer);
				displayRenderer = FeathersControl(renderer);
				displayRenderer.onResize.add(headerOrFooterRenderer_onResize);
			}

			return renderer;
		}

		private function createFooterRenderer(footer:Object, groupIndex:int, layoutIndex:int, isTemporary:Boolean = false):IGroupedListHeaderOrFooterRenderer
		{
			if(isTemporary || this._inactiveFooterRenderers.length == 0)
			{
				var renderer:IGroupedListHeaderOrFooterRenderer;
				if(this._footerRendererFactory != null)
				{
					renderer = IGroupedListHeaderOrFooterRenderer(this._footerRendererFactory());
				}
				else
				{
					renderer = new this._footerRendererType();
				}
				var displayRenderer:FeathersControl = FeathersControl(renderer);
				this.addChild(displayRenderer);
			}
			else
			{
				renderer = this._inactiveFooterRenderers.shift();
			}
			renderer.data = footer;
			renderer.groupIndex = groupIndex;
			renderer.layoutIndex = layoutIndex;
			renderer.owner = this._owner;
			DisplayObject(renderer).visible = true;

			if(!isTemporary)
			{
				this._footerRendererMap[footer] = renderer;
				this._activeFooterRenderers.push(renderer);
				displayRenderer = FeathersControl(renderer);
				displayRenderer.onResize.add(headerOrFooterRenderer_onResize);
			}

			return renderer;
		}

		private function destroyItemRenderer(renderer:IGroupedListItemRenderer):void
		{
			renderer.onChange.remove(renderer_onChange);
			const displayRenderer:FeathersControl = FeathersControl(renderer);
			displayRenderer.onResize.remove(itemRenderer_onResize);
			this.removeChild(displayRenderer, true);
		}

		private function destroyHeaderRenderer(renderer:IGroupedListHeaderOrFooterRenderer):void
		{
			const displayRenderer:FeathersControl = FeathersControl(renderer);
			displayRenderer.onResize.remove(headerOrFooterRenderer_onResize);
			this.removeChild(displayRenderer, true);
		}

		private function destroyFooterRenderer(renderer:IGroupedListHeaderOrFooterRenderer):void
		{
			const displayRenderer:FeathersControl = FeathersControl(renderer);
			displayRenderer.onResize.remove(headerOrFooterRenderer_onResize);
			this.removeChild(displayRenderer, true);
		}

		private function locationToDisplayIndex(groupIndex:int, itemIndex:int):int
		{
			var displayIndex:int = 0;
			const groupCount:int = this._dataProvider.getLength();
			for(var i:int = 0; i < groupCount; i++)
			{
				var group:Object = this._dataProvider.getItemAt(i);
				var header:Object = this._owner.groupToHeaderData(group);
				if(header)
				{
					displayIndex++;
				}
				var groupLength:int = this._dataProvider.getLength(i);
				for(var j:int = 0; j < groupLength; j++)
				{
					if(groupIndex == i && itemIndex == j)
					{
						return displayIndex;
					}
					displayIndex++;
				}
				var footer:Object = this._owner.groupToFooterData(group);
				if(footer)
				{
					displayIndex++;
				}
			}
			return -1;
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
			this.invalidateParent();
		}

		private function dataProvider_onItemUpdate(data:HierarchicalCollection, index:int):void
		{
			const item:Object = this._dataProvider.getItemAt(index);
			const renderer:IGroupedListItemRenderer = IGroupedListItemRenderer(this._itemRendererMap[item]);
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

		private function itemRenderer_onResize(renderer:IGroupedListItemRenderer, oldWidth:Number, oldHeight:Number):void
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
			layout.resetVariableVirtualCacheAtIndex(renderer.layoutIndex, DisplayObject(renderer));
			this.invalidate(INVALIDATION_FLAG_SCROLL);
			this.invalidateParent();
		}

		private function headerOrFooterRenderer_onResize(renderer:IGroupedListHeaderOrFooterRenderer, oldWidth:Number, oldHeight:Number):void
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
			layout.resetVariableVirtualCacheAtIndex(renderer.layoutIndex, DisplayObject(renderer));
			this.invalidate(INVALIDATION_FLAG_SCROLL);
		}

		private function renderer_onChange(renderer:IGroupedListItemRenderer):void
		{
			if(this._ignoreSelectionChanges)
			{
				return;
			}
			const isAlreadySelected:Boolean = this._selectedGroupIndex == renderer.groupIndex &&
				this._selectedItemIndex == renderer.itemIndex;
			if(!this._isSelectable || this._isScrolling || isAlreadySelected)
			{
				//reset to the old value
				renderer.isSelected = isAlreadySelected;
				return;
			}
			this.setSelectedLocation(renderer.groupIndex, renderer.itemIndex);
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
