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
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import org.josht.starling.display.Sprite;
	import org.josht.starling.foxhole.core.FoxholeControl;
	import org.josht.starling.foxhole.data.ListCollection;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class List extends FoxholeControl
	{
		public static const VERTICAL_ALIGN_TOP:String = "top";
		public static const VERTICAL_ALIGN_MIDDLE:String = "middle";
		public static const VERTICAL_ALIGN_BOTTOM:String = "bottom";
		
		private static const INVALIDATION_FLAG_ITEM_RENDERER:String = "itemRenderer";
		private static const INVALIDATION_FLAG_CLIPPING:String = "clipping";
		
		private static const MINIMUM_DRAG_DISTANCE:Number = 0.04;
		private static const FRICTION:Number = 0.5;
		
		public function List()
		{
			super();
			
			this.addEventListener(TouchEvent.TOUCH, touchHandler);
		}
		
		private var _background:DisplayObject;
		private var _itemRendererContainer:Sprite;
		
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
			this._onScroll.dispatch(this);
		}
		
		private var _maxVerticalScrollPosition:Number = 0;
		
		public function get maxVerticalScrollPosition():Number
		{
			return this._maxVerticalScrollPosition;
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
			this.verticalScrollPosition = 0; //reset the scroll position
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		private var _labelField:String = "label";
		
		public function get labelField():String
		{
			return this._labelField;
		}
		
		public function set labelField(value:String):void
		{
			if(this._labelField == value)
			{
				return;
			}
			this._labelField = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		private var _labelFunction:Function;
		
		public function get labelFunction():Function
		{
			return this._labelFunction;
		}
		
		public function set labelFunction(value:Function):void
		{
			this._labelFunction = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		private var _rowHeight:Number = NaN;
		
		public function get rowHeight():Number
		{
			return this._rowHeight;
		}
		
		public function set rowHeight(value:Number):void
		{
			if(this._rowHeight == value)
			{
				return;
			}
			this._rowHeight = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
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
		
		public function get selectedItem():Object
		{
			if(!this._dataProvider || this._selectedIndex < 0 || this._selectedIndex >= this._dataProvider.length)
			{
				return null;
			}
			
			return this._dataProvider.getItemAt(this._selectedIndex);
		}
		
		public function set selectedItem(value:Object):void
		{
			this.selectedIndex = this._dataProvider.getItemIndex(value);
		}
		
		private var _clipContent:Boolean = false;
		
		public function get clipContent():Boolean
		{
			return this._clipContent;
		}
		
		public function set clipContent(value:Boolean):void
		{
			if(this._clipContent == value)
			{
				return;
			}
			this._clipContent = value;
			this.invalidate(INVALIDATION_FLAG_CLIPPING);
		}
		
		private var _touchPointID:int = -1;
		private var _startTouchTime:int;
		private var _startTouchY:Number;
		private var _startVerticalScrollPosition:Number;
		private var _targetVerticalScrollPosition:Number;
		
		private var _autoScrolling:Boolean = false;
		private var _isMoving:Boolean = false;
		
		private var _inactiveRenderers:Vector.<IListItemRenderer> = new <IListItemRenderer>[];
		private var _activeRenderers:Vector.<IListItemRenderer> = new <IListItemRenderer>[];
		private var _rendererMap:Dictionary = new Dictionary(true);
		
		private var _onChange:Signal = new Signal(List);
		
		public function get onChange():ISignal
		{
			return this._onChange;
		}
		
		private var _onScroll:Signal = new Signal(List);
		
		public function get onScroll():ISignal
		{
			return this._onScroll;
		}
		
		private var _onItemTouch:Signal = new Signal(List, Object, int, TouchEvent);
		
		public function get onItemTouch():ISignal
		{
			return this._onItemTouch;
		}
		
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
		
		private var _backgroundSkin:DisplayObject;

		public function get backgroundSkin():DisplayObject
		{
			return this._backgroundSkin;
		}

		public function set backgroundSkin(value:DisplayObject):void
		{
			if(this._backgroundSkin == value)
			{
				return;
			}
			
			if(this._backgroundSkin && this._backgroundSkin != this._backgroundDisabledSkin)
			{
				this.removeChild(this._backgroundSkin);
			}
			this._backgroundSkin = value;
			if(this._backgroundSkin && this._backgroundSkin.parent != this)
			{
				this._backgroundSkin.visible = false;
				this.addChildAt(this._backgroundSkin, 0);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		private var _backgroundDisabledSkin:DisplayObject;

		public function get backgroundDisabledSkin():DisplayObject
		{
			return this._backgroundDisabledSkin;
		}

		public function set backgroundDisabledSkin(value:DisplayObject):void
		{
			if(this._backgroundDisabledSkin == value)
			{
				return;
			}
			
			if(this._backgroundDisabledSkin && this._backgroundDisabledSkin != this._backgroundSkin)
			{
				this.removeChild(this._backgroundDisabledSkin);
			}
			this._backgroundDisabledSkin = value;
			if(this._backgroundDisabledSkin && this._backgroundDisabledSkin.parent != this)
			{
				this._backgroundDisabledSkin.visible = false;
				this.addChildAt(this._backgroundSkin, 0);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		protected var _contentPadding:Number = 0;
		
		public function get contentPadding():Number
		{
			return _contentPadding;
		}
		
		public function set contentPadding(value:Number):void
		{
			if(this._contentPadding == value)
			{
				return;
			}
			this._contentPadding = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		protected var _verticalAlign:String = VERTICAL_ALIGN_TOP;
		
		public function get verticalAlign():String
		{
			return _verticalAlign;
		}
		
		public function set verticalAlign(value:String):void
		{
			if(this._verticalAlign == value)
			{
				return;
			}
			this._verticalAlign = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
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

		public function setItemRendererProperty(propertyName:String, propertyValue:Object):void
		{
			this._itemRendererProperties[propertyName] = propertyValue;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		public function itemToLabel(item:Object):String
		{
			if(this._labelFunction != null)
			{
				return this._labelFunction(item) as String;
			}
			else if(this._labelField != null)
			{
				return item[this._labelField] as String;
			}
			else if(item)
			{
				return item.toString();
			}
			return "";
		}
		
		override public function dispose():void
		{
			this._onChange.removeAll();
			this._onScroll.removeAll();
			this._onItemTouch.removeAll();
			super.dispose();
		}
		
		override protected function initialize():void
		{
			if(!this._itemRendererContainer)
			{
				this._itemRendererContainer = new Sprite();
				this.addChild(this._itemRendererContainer);
			}
		}
		
		override protected function draw():void
		{
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			var scrollInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SCROLL);
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			const stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			const selectionInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SELECTED);
			const itemRendererInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_ITEM_RENDERER);
			const clippingInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_CLIPPING);
			
			if(isNaN(this._width))
			{
				this._width = 320;
				sizeInvalid = true;
			}
			if(isNaN(this._height))
			{
				this._height = 320;
				sizeInvalid = true;
			}
			
			if(sizeInvalid || stylesInvalid || stateInvalid)
			{
				this.refreshBackgroundSkin();
			}
			
			if(dataInvalid || sizeInvalid || itemRendererInvalid || scrollInvalid)
			{
				if((dataInvalid || itemRendererInvalid) && isNaN(this._rowHeight) && this._dataProvider && this._dataProvider.length > 0)
				{
					const typicalRenderer:IListItemRenderer = this.createRenderer(this._dataProvider.getItemAt(0), 0, true);
					this.refreshOneItemRendererStyles(typicalRenderer);
					if(typicalRenderer is FoxholeControl)
					{
						FoxholeControl(typicalRenderer).validate();
					}
					this._rowHeight = DisplayObject(typicalRenderer).height;
					this.destroyRenderer(typicalRenderer);
				}
				this.refreshScrollBounds();
				this.refreshRenderers(itemRendererInvalid);
				this.drawRenderers();
			}
			
			if(dataInvalid || sizeInvalid || itemRendererInvalid || stylesInvalid)
			{
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
			
			if(dataInvalid || scrollInvalid || clippingInvalid)
			{
				this.scrollContent();
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
		
		protected function refreshScrollBounds():void
		{
			var availableHeight:Number = this._height - 2 * this._contentPadding;
			if(this._dataProvider)
			{
				var contentHeight:Number = this._dataProvider.length * this._rowHeight;
				this._maxVerticalScrollPosition = Math.max(0, contentHeight - availableHeight);
			}
			else
			{
				this._maxVerticalScrollPosition = 0;
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
		
		protected function refreshBackgroundSkin():void
		{
			var backgroundSkin:DisplayObject = this._backgroundSkin;
			if(!this._isEnabled && this._backgroundDisabledSkin)
			{
				this._backgroundSkin.visible = false;
				backgroundSkin = this._backgroundDisabledSkin;
			}
			if(backgroundSkin)
			{
				backgroundSkin.visible = true;
				backgroundSkin.width = this._width;
				backgroundSkin.height = this._height;
			}
		}
		
		protected function scrollContent():void
		{	
			this._itemRendererContainer.x = this._contentPadding;
			this._itemRendererContainer.y = this._contentPadding;
			
			const contentWidth:Number = this._width - 2 * this._contentPadding;
			const contentHeight:Number = this._height - 2 * this._contentPadding;
			if(this._clipContent)
			{
				if(!this._itemRendererContainer.scrollRect)
				{
					this._itemRendererContainer.scrollRect = new Rectangle();
				}
				
				const scrollRect:Rectangle = this._itemRendererContainer.scrollRect;
				scrollRect.width = contentWidth;
				scrollRect.height = contentHeight;
				scrollRect.y = this._verticalScrollPosition;
			}
			else
			{
				if(this._itemRendererContainer.scrollRect)
				{
					this._itemRendererContainer.scrollRect = null;
				}
				this._itemRendererContainer.y -= this._verticalScrollPosition;
			}
		}
		
		protected function drawRenderers():void
		{	
			const contentWidth:Number = this._width - 2 * this._contentPadding;
			const availableContentHeight:Number = this._height - 2 * this._contentPadding;
			const actualContentHeight:Number = this._dataProvider.length * this._rowHeight
			var offsetY:Number = 0;
			if(actualContentHeight < availableContentHeight)
			{
				if(this._verticalAlign == VERTICAL_ALIGN_MIDDLE)
				{
					offsetY = (availableContentHeight - actualContentHeight) / 2;
				}
				else if(this._verticalAlign == VERTICAL_ALIGN_BOTTOM)
				{
					offsetY = availableContentHeight - actualContentHeight;	
				}
			}
			
			const itemCount:int = this._activeRenderers.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var renderer:IListItemRenderer = this._activeRenderers[i];
				var displayRenderer:DisplayObject = DisplayObject(renderer);
				displayRenderer.width = contentWidth;
				displayRenderer.height = this._rowHeight;
				displayRenderer.y = offsetY + this._rowHeight * renderer.index;
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
				this._itemRendererContainer.addChild(displayRenderer);
			}
			else
			{
				renderer = this._inactiveRenderers.shift();
			}
			renderer.data = item;
			renderer.index = index;
			renderer.owner = this;
			
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
			this._itemRendererContainer.removeChild(displayRenderer);
		}
		
		private function updateScrollFromTouchPosition(touchX:Number, touchY:Number):void
		{
			var offset:Number = this._startTouchY - touchY;
			var position:Number = this._startVerticalScrollPosition + offset;
			if(this._verticalScrollPosition < 0)
			{
				position /= 2;
			}
			else if(position > this._maxVerticalScrollPosition)
			{
				position -= (position - this._maxVerticalScrollPosition) / 2;
			}
			
			var oldPosition:Number = this._verticalScrollPosition;
			this.verticalScrollPosition = position;
		}
		
		private function finishScrolling():void
		{
			if(!this._autoScrolling)
			{
				var maxDifference:Number = this._verticalScrollPosition - this._maxVerticalScrollPosition;
				if(maxDifference >= 1)
				{
					this._autoScrolling = true;
					this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
					this._targetVerticalScrollPosition = this._maxVerticalScrollPosition;
				}
				else if(this._verticalScrollPosition < 0)
				{
					this._autoScrolling = true;
					this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
					this._targetVerticalScrollPosition = 0;
				}
				else
				{
					//we should never get here, but there have been some weird
					//cases where selection doesn't work
					this._isMoving = false;
					this._autoScrolling = false;
				}
			}
			else
			{
				this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
				this._autoScrolling = false;
				this._isMoving = false;
			}
		}
		
		private function enterFrameHandler(event:Event):void
		{
			var difference:Number = this._verticalScrollPosition - this._targetVerticalScrollPosition;
			var offset:Number = difference * FRICTION;
			this.verticalScrollPosition -= offset;
			if(Math.abs(difference) < 1)
			{
				this.finishScrolling();
				return;
			}
		}
		
		private function touchHandler(event:TouchEvent):void
		{
			if(!this._isEnabled)
			{
				return;
			}
			const touch:Touch = event.getTouch(this);
			if(!touch || (this._touchPointID >= 0 && touch.id != this._touchPointID))
			{
				return;
			}
			const location:Point = touch.getLocation(this);
			if(touch.phase == TouchPhase.BEGAN)
			{
				if(this._autoScrolling)
				{
					this._autoScrolling = false;
					this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
				}
				
				this._touchPointID = touch.id;
				this._startTouchTime = getTimer();
				this._startTouchY = location.y;
				this._startVerticalScrollPosition = this._verticalScrollPosition;
				this._isMoving = false;
			}
			else if(touch.phase == TouchPhase.MOVED)
			{
				const inchesMoved:Number = Math.abs(location.y - this._startTouchY) / Capabilities.screenDPI;
				if(!this._isMoving && inchesMoved >= MINIMUM_DRAG_DISTANCE)
				{
					this._isMoving = true;
				}
				if(this._isMoving)
				{
					if(!this._autoScrolling)
					{
						this.updateScrollFromTouchPosition(location.x, location.y);
					}
				}
			}
			else if(touch.phase == TouchPhase.ENDED)
			{
				this._touchPointID = -1;
				if(this._verticalScrollPosition <= 0 || this._verticalScrollPosition >= this._maxVerticalScrollPosition)
				{
					this.finishScrolling();
					return;
				}
				
				const distance:Number = location.y - this._startTouchY;
				const pixelsPerMS:Number = distance / (getTimer() - this._startTouchTime); 
				var pixelsPerFrame:Number = 1.5 * (pixelsPerMS * 1000) / Starling.current.nativeStage.frameRate;
				this._targetVerticalScrollPosition = this._verticalScrollPosition;
				
				//TODO: there's probably some physics equation for this...
				while(Math.abs(pixelsPerFrame) >= 1)
				{
					this._targetVerticalScrollPosition -= pixelsPerFrame;
					if(this._targetVerticalScrollPosition < 0 || this._targetVerticalScrollPosition > this._maxVerticalScrollPosition)
					{
						pixelsPerFrame /= 2;
						this._targetVerticalScrollPosition += pixelsPerFrame;
					}
					pixelsPerFrame *= (1 - FRICTION);
				}
			}
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
			if(this._isSelectable && !this._isMoving && touch && touch.phase == TouchPhase.ENDED)
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