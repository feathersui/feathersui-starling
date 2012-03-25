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
	import org.josht.starling.foxhole.core.FoxholeControl;
	import org.josht.starling.foxhole.data.ListCollection;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	import starling.display.DisplayObject;
	import starling.events.TouchEvent;
	
	public class List extends FoxholeControl
	{
		public static const VERTICAL_ALIGN_TOP:String = "top";
		public static const VERTICAL_ALIGN_MIDDLE:String = "middle";
		public static const VERTICAL_ALIGN_BOTTOM:String = "bottom";
		
		public function List()
		{
			super();
		}
		
		private var _background:DisplayObject;
		private var _scroller:Scroller;
		private var _dataContainer:ListDataContainer;
		
		private var _scrollToIndex:int = -1;
		
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
			this._dataProvider = value;
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
			this.invalidate(INVALIDATION_FLAG_SELECTED);
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
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		private var _isMoving:Boolean = false;
		
		protected var _onChange:Signal = new Signal(List);
		
		public function get onChange():ISignal
		{
			return this._onChange;
		}
		
		protected var _onScroll:Signal = new Signal(List);
		
		public function get onScroll():ISignal
		{
			return this._onScroll;
		}
		
		protected var _onItemTouch:Signal = new Signal(List, Object, int, TouchEvent);
		
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
		
		private var _itemRendererType:Class = SimpleItemRenderer;
		
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
			this.invalidate(INVALIDATION_FLAG_STYLES);
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
			else if(this._labelField != null && item && item.hasOwnProperty(this._labelField))
			{
				return item[this._labelField] as String;
			}
			else if(item)
			{
				return item.toString();
			}
			return "";
		}
		
		public function scrollToDisplayIndex(index:int):void
		{
			this._scrollToIndex = index;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
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
			if(!this._scroller)
			{
				this._scroller = new Scroller();
				this._scroller.verticalScrollPolicy = Scroller.SCROLL_POLICY_AUTO;
				this._scroller.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
				this._scroller.onScroll.add(scroller_onScroll);
				this.addChild(this._scroller);
			}
			
			if(!this._dataContainer)
			{
				this._dataContainer = new ListDataContainer();
				this._dataContainer.owner = this;
				this._dataContainer.onChange.add(dataContainer_onChange);
				this._dataContainer.onItemTouch.add(dataContainer_onItemTouch);
				this._scroller.viewPort = this._dataContainer;
			}
		}
		
		override protected function draw():void
		{
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			var scrollInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SCROLL);
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			const stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			
			if(sizeInvalid || stylesInvalid || stateInvalid)
			{
				this.refreshBackgroundSkin();
			}
			
			if(!isNaN(this._width))
			{
				this._dataContainer.width = this._width - 2 * this._contentPadding;
			}
			if(!isNaN(this._height))
			{
				this._dataContainer.visibleHeight = this._height - 2 * contentPadding;
			}
			else
			{
				this._dataContainer.visibleHeight = NaN;
			}
			this._dataContainer.selectedIndex = this._selectedIndex;
			this._dataContainer.dataProvider = this._dataProvider;
			this._dataContainer.itemRendererType = this._itemRendererType;
			this._dataContainer.itemRendererFunction = this._itemRendererFunction;
			this._dataContainer.itemRendererProperties = this._itemRendererProperties;
			this._dataContainer.typicalItem = this._typicalItem;
			this._dataContainer.useVirtualLayout = this._useVirtualLayout;
			this._dataContainer.verticalScrollPosition = this._verticalScrollPosition;
			this._dataContainer.validate();
			if(isNaN(this._width))
			{
				this.width = this._dataContainer.width + 2 * this._contentPadding;
			}
			if(isNaN(this._height))
			{
				this.height = this._dataContainer.height + 2 * this._contentPadding;
			}
			
			if(this._scrollToIndex >= 0 && this._dataProvider)
			{
				const rowHeight:Number = this._dataContainer.height / this._dataProvider.length;
				const visibleRowCount:int = Math.ceil(this._dataContainer.visibleHeight / rowHeight);
				this.verticalScrollPosition = rowHeight * Math.max(0, Math.min(this._dataProvider.length - visibleRowCount, this._scrollToIndex - visibleRowCount / 2));
				this._scrollToIndex = -1;
			}
			
			this._scroller.width = this._width - 2 * this._contentPadding;
			this._scroller.height = this._height - 2 * this._contentPadding;
			this._scroller.x = this._contentPadding;
			this._scroller.y = this._contentPadding;
			this._scroller.clipContent = this._clipContent;
			this._scroller.verticalAlign = this._verticalAlign;
			this._scroller.verticalScrollPosition = this._verticalScrollPosition;
			this._scroller.validate();
			this._maxVerticalScrollPosition = this._scroller.maxVerticalScrollPosition;
			this._verticalScrollPosition = this._scroller.verticalScrollPosition;
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
		
		protected function scroller_onScroll(scroller:Scroller):void
		{
			this.verticalScrollPosition = this._scroller.verticalScrollPosition;
		}
		
		protected function dataContainer_onChange(dataContainer:ListDataContainer):void
		{
			this.selectedIndex = this._dataContainer.selectedIndex;
		}
		
		protected function dataContainer_onItemTouch(dataContainer:ListDataContainer, item:Object, index:int, event:TouchEvent):void
		{
			this._onItemTouch.dispatch(this, item, index, event);
		}
	}
}