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
	import org.josht.starling.foxhole.controls.*;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import org.josht.starling.foxhole.core.FoxholeControl;
	import org.josht.starling.foxhole.data.ListCollection;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * @private
	 * Used internally by List. Not meant to be used on its own.
	 */
	public class ListDataContainer extends FoxholeControl
	{
		protected static const INVALIDATION_FLAG_ITEM_RENDERER:String = "itemRenderer";
		
		public function ListDataContainer()
		{
			super();
		}
		
		private var _unrenderedData:Array = [];
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
			}
			this._dataProvider = value;
			if(this._dataProvider)
			{
				this._dataProvider.onChange.add(dataProvider_onChange);
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
			this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER);
		}
		
		private var _itemRendererFunction:Function;
		
		public function get itemRendererFunction():Function
		{
			return this._itemRendererFunction;
		}
		
		public function set itemRendererFunction(value:Function):void
		{
			if(this._itemRendererFunction === value)
			{
				return;
			}
			
			this._itemRendererFunction = value;
			this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER);
		}

		private var _typicalItemWidth:Number = NaN;
		
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
			this._typicalItemWidth = NaN;
			this.invalidate(INVALIDATION_FLAG_ITEM_RENDERER);
		}
		
		private var _rowHeight:Number = NaN;
		
		private var _itemRendererProperties:Object = {};
		
		public function get itemRendererProperties():Object
		{
			return this._itemRendererProperties;
		}
		
		public function set itemRendererProperties(value:Object):void
		{
			if(this._itemRendererProperties == value)
			{
				return;
			}
			this._itemRendererProperties = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		private var _useVirtualLayout:Boolean = true;

		public function get useVirtualLayout():Boolean
		{
			return this._useVirtualLayout;
		}

		public function set useVirtualLayout(value:Boolean):void
		{
			if(this._useVirtualLayout == value)
			{
				return;
			}
			this._useVirtualLayout = value;
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
		
		private var _visibleHeight:Number = NaN;

		public function get visibleHeight():Number
		{
			return this._visibleHeight;
		}

		public function set visibleHeight(value:Number):void
		{
			if(this._visibleHeight == value)
			{
				return;
			}
			this._visibleHeight = value;
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
		
		protected var _onChange:Signal = new Signal(ListDataContainer);
		
		public function get onChange():ISignal
		{
			return this._onChange;
		}
		
		protected var _onItemTouch:Signal = new Signal(ListDataContainer, Object, int, TouchEvent);
		
		public function get onItemTouch():ISignal
		{
			return this._onItemTouch;
		}
		
		override protected function draw():void
		{
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const scrollInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SCROLL);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			const selectionInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SELECTED);
			const itemRendererInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_ITEM_RENDERER);
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);

			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;
			
			this.refreshRenderers(itemRendererInvalid);
			this.drawRenderers();
			this.refreshItemRendererStyles();
			
			this.refreshSelection();
			
			var rendererCount:int = this._activeRenderers.length;
			for(var i:int = 0; i < rendererCount; i++)
			{
				var itemRenderer:DisplayObject = DisplayObject(this._activeRenderers[i]);
				if(itemRenderer is FoxholeControl)
				{
					FoxholeControl(itemRenderer).validate();
				}
			}
		}

		protected function autoSizeIfNeeded():Boolean
		{
			const needsTypicalItemWidth:Boolean = isNaN(this.explicitWidth) && isNaN(this._typicalItemWidth);
			const needsRowHeight:Boolean = isNaN(this._rowHeight);

			if(needsTypicalItemWidth || needsRowHeight)
			{
				var typicalItem:Object = this._typicalItem;
				if(!typicalItem && this._dataProvider && this._dataProvider.length > 0)
				{
					typicalItem = this._dataProvider.getItemAt(0);
				}
				if(typicalItem)
				{
					const typicalRenderer:IListItemRenderer = this.createRenderer(typicalItem, 0, true);
					this.refreshOneItemRendererStyles(typicalRenderer);
					if(typicalRenderer is FoxholeControl)
					{
						FoxholeControl(typicalRenderer).validate();
					}
					if(needsTypicalItemWidth)
					{
						this._typicalItemWidth = DisplayObject(typicalRenderer).width;
					}
					if(needsRowHeight)
					{
						this._rowHeight = DisplayObject(typicalRenderer).height;
					}
					this.destroyRenderer(typicalRenderer);
				}
			}
			var newWidth:Number = isNaN(this.explicitWidth) ? this._typicalItemWidth : this.explicitWidth;
			var newHeight:Number = isNaN(this._rowHeight) ? 0 : (this._rowHeight * this._dataProvider.length);
			this.setSizeInternal(newWidth, newHeight, false);
			return true;
		}
		
		protected function itemToItemRenderer(item:Object):IListItemRenderer
		{
			return IListItemRenderer(this._rendererMap[item]);
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
		
		protected function drawRenderers():void
		{	
			if(!this._dataProvider)
			{
				return;
			}
			const actualContentHeight:Number = this._dataProvider.length * this._rowHeight;
			
			const itemCount:int = this._activeRenderers.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var renderer:IListItemRenderer = this._activeRenderers[i];
				var displayRenderer:DisplayObject = DisplayObject(renderer);
				displayRenderer.width = this.actualWidth;
				displayRenderer.height = this._rowHeight;
				displayRenderer.y = this._rowHeight * renderer.index;
			}
		}
		
		protected function refreshRenderers(cellRendererTypeIsInvalid:Boolean):void
		{
			if(!cellRendererTypeIsInvalid)
			{
				var temp:Vector.<IListItemRenderer> = this._inactiveRenderers;
				this._inactiveRenderers = this._activeRenderers;
				this._activeRenderers = temp;
			}
			this._activeRenderers.length = 0;
			
			this.findUnrenderedData();
			this.recoverInactiveRenderers();
			this.renderUnrenderedData();
			this.freeInactiveRenderers();
		}
		
		private function findUnrenderedData():void
		{
			var startIndex:int = 0;
			var endIndex:int = this._dataProvider ? this._dataProvider.length : 0;
			if(this._useVirtualLayout && !isNaN(this._visibleHeight) && endIndex * this._rowHeight > this._visibleHeight)
			{
				startIndex = Math.max(startIndex, this._verticalScrollPosition / this._rowHeight);
				endIndex = Math.min(endIndex, startIndex + Math.ceil(this._visibleHeight / this._rowHeight) + 1);
			}
			for(var i:int = startIndex; i < endIndex; i++)
			{
				var item:Object = this._dataProvider.getItemAt(i);
				var renderer:IListItemRenderer = IListItemRenderer(this._rendererMap[item]);
				if(renderer)
				{
					this._activeRenderers.push(renderer);
					this._inactiveRenderers.splice(this._inactiveRenderers.indexOf(renderer), 1);
				}
				else
				{
					this._unrenderedData.push(item);
				}
			}
		}
		
		private function renderUnrenderedData():void
		{
			var itemCount:int = this._unrenderedData.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:Object = this._unrenderedData.shift();
				var index:int = this._dataProvider.getItemIndex(item);
				this.createRenderer(item, index);
			}
		}
		
		private function recoverInactiveRenderers():void
		{
			var itemCount:int = this._inactiveRenderers.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var renderer:IListItemRenderer = this._inactiveRenderers[i];
				delete this._rendererMap[renderer.data];
			}
		}
		
		private function freeInactiveRenderers():void
		{
			var itemCount:int = this._inactiveRenderers.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var renderer:IListItemRenderer = this._inactiveRenderers.shift();
				this.destroyRenderer(renderer);
			}
		}
		
		private function createRenderer(item:Object, index:int, isTemporary:Boolean = false):IListItemRenderer
		{
			if(this._inactiveRenderers.length == 0)
			{
				var renderer:IListItemRenderer;
				if(this._itemRendererFunction != null)
				{
					renderer = IListItemRenderer(this._itemRendererFunction(item));
				}
				else
				{
					renderer = new this._itemRendererType();
				}
				renderer.onChange.add(renderer_onChange);
				const displayRenderer:DisplayObject = DisplayObject(renderer);
				displayRenderer.addEventListener(TouchEvent.TOUCH, renderer_touchHandler);
				this.addChild(displayRenderer);
			}
			else
			{
				renderer = this._inactiveRenderers.shift();
			}
			renderer.data = item;
			renderer.index = index;
			renderer.owner = this.owner;
			if(renderer is FoxholeControl)
			{
				FoxholeControl(renderer).isEnabled = this._isEnabled;
			}
			
			if(!isTemporary)
			{
				this._rendererMap[item] = renderer;
				this._activeRenderers.push(renderer);
			}
			
			return renderer;
		}
		
		private function destroyRenderer(renderer:IListItemRenderer):void
		{
			const displayRenderer:DisplayObject = DisplayObject(renderer);
			displayRenderer.removeEventListener(TouchEvent.TOUCH, renderer_touchHandler);
			this.removeChild(displayRenderer);
		}
		
		private function owner_onScroll(list:List):void
		{
			this._isScrolling = true;
		}
		
		private function dataProvider_onChange(data:ListCollection):void
		{
			this.invalidate(INVALIDATION_FLAG_DATA);
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
		
		private function renderer_touchHandler(event:TouchEvent):void
		{
			if(!this._isEnabled)
			{
				return;
			}
			
			const renderer:IListItemRenderer = IListItemRenderer(event.currentTarget);
			const displayRenderer:DisplayObject = DisplayObject(renderer);
			const touch:Touch = event.getTouch(displayRenderer);
			if(touch && touch.phase == TouchPhase.BEGAN)
			{
				//if this flag gets set to true before the touch phase ends, we
				//won't change selection.
				this._isScrolling = false;
			}
			
			this._onItemTouch.dispatch(this, renderer.data, renderer.index, event);
		}
	}
}