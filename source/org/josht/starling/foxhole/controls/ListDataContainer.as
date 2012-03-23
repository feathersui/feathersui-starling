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
package org.josht.starling.foxhole.controls
{
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
	
	public class ListDataContainer extends FoxholeControl
	{
		protected static const INVALIDATION_FLAG_ITEM_RENDERER:String = "itemRenderer";
		
		public function ListDataContainer()
		{
			super();
		}
		
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
			if(!value)
			{
				this.selectedIndex = -1;
			}
			this._isSelectable = value;
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
		
		private var _onChange:Signal = new Signal(ListDataContainer);
		
		public function get onChange():ISignal
		{
			return this._onChange;
		}
		
		private var _onItemTouch:Signal = new Signal(ListDataContainer, Object, int, TouchEvent);
		
		public function get onItemTouch():ISignal
		{
			return this._onItemTouch;
		}
		
		override protected function draw():void
		{
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const selectionInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SELECTED);
			const itemRendererInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_ITEM_RENDERER);
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			
			if(dataInvalid || stylesInvalid || itemRendererInvalid)
			{
				if((dataInvalid || itemRendererInvalid) && isNaN(this._rowHeight) && this._dataProvider && this._dataProvider.length > 0)
				{
					const typicalRenderer:IListItemRenderer = this.createRenderer(this._dataProvider.getItemAt(0), 0, true);
					this.refreshOneItemRendererStyles(typicalRenderer);
					if(typicalRenderer is FoxholeControl)
					{
						FoxholeControl(typicalRenderer).validate();
					}
					if(isNaN(this._width))
					{
						this.width = DisplayObject(typicalRenderer).width;
					}
					this._rowHeight = DisplayObject(typicalRenderer).height;
					this.destroyRenderer(typicalRenderer);
				}
				
				this.height = this._dataProvider ? (this._rowHeight * this._dataProvider.length) : 0;
				this.refreshRenderers(itemRendererInvalid);
				this.drawRenderers();
				this.refreshItemRendererStyles();
			}
			
			if(dataInvalid || selectionInvalid)
			{
				this.refreshSelection();
			}
			
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
			var itemCount:int = this._dataProvider ? this._dataProvider.length : 0;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:Object = this._dataProvider.getItemAt(i);
				var renderer:IListItemRenderer = this.itemToItemRenderer(item);
				renderer.isSelected = this._selectedIndex == i;
			}
		}
		
		protected function drawRenderers():void
		{	
			const actualContentHeight:Number = this._dataProvider.length * this._rowHeight
			
			const itemCount:int = this._activeRenderers.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var renderer:IListItemRenderer = this._activeRenderers[i];
				var displayRenderer:DisplayObject = DisplayObject(renderer);
				displayRenderer.width = this._width;
				displayRenderer.height = this._rowHeight;
				displayRenderer.y = this._rowHeight * renderer.index;
			}
		}
		
		protected function refreshRenderers(cellRendererTypeIsInvalid:Boolean):void
		{
			if(!cellRendererTypeIsInvalid)
			{
				this._inactiveRenderers = this._activeRenderers;
			}
			this._activeRenderers = new <IListItemRenderer>[];
			
			if(this._dataProvider)
			{
				var unrenderedData:Array = this.findUnrenderedData();
				this.recoverInactiveRenderers();
				this.renderUnrenderedData(unrenderedData);
				this.freeInactiveRenderers();
			}
		}
		
		private function findUnrenderedData():Array
		{
			var unrenderedData:Array = [];
			var itemCount:int = this._dataProvider ? this._dataProvider.length : 0;
			for(var i:int = 0; i < itemCount; i++)
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
					unrenderedData.push(item);
				}
			}
			return unrenderedData;
		}
		
		private function renderUnrenderedData(unrenderedData:Array):void
		{
			var itemCount:int = unrenderedData.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:Object = unrenderedData[i];
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
			if(this._isSelectable && !this._isScrolling && touch && touch.phase == TouchPhase.ENDED)
			{
				const location:Point = touch.getLocation(displayRenderer);
				const isInBounds:Boolean = location.x >= 0 && location.y >= 0 && 
					location.x < displayRenderer.width / displayRenderer.scaleX &&
					location.y < displayRenderer.height / displayRenderer.scaleY;
				if(isInBounds)
				{
					this.selectedIndex = renderer.index;
				}
			}
			
			this._onItemTouch.dispatch(this, renderer.data, renderer.index, event);
		}
	}
}