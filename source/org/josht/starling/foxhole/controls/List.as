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
	import org.josht.starling.foxhole.controls.supportClasses.ListDataContainer;
	import org.josht.starling.foxhole.core.FoxholeControl;
	import org.josht.starling.foxhole.data.ListCollection;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	import starling.display.DisplayObject;
	import starling.events.TouchEvent;
	
	/**
	 * Displays a one-dimensional list of items. Supports scrolling.
	 */
	public class List extends FoxholeControl
	{
		/**
		 * If the list content does not fill the entire available vertical
		 * space, it will be aligned to the top.
		 */
		public static const VERTICAL_ALIGN_TOP:String = "top";
		
		/**
		 * If the list content does not fill the entire available vertical
		 * space, it will be aligned to the middle.
		 */
		public static const VERTICAL_ALIGN_MIDDLE:String = "middle";
		
		/**
		 * If the list content does not fill the entire available vertical
		 * space, it will be aligned to the bottom.
		 */
		public static const VERTICAL_ALIGN_BOTTOM:String = "bottom";
		
		/**
		 * Constructor.
		 */
		public function List()
		{
			super();
		}
		
		protected var _background:DisplayObject;
		protected var _scroller:Scroller;
		protected var _dataContainer:ListDataContainer;
		
		/**
		 * @private
		 */
		private var _scrollToIndex:int = -1;
		
		/**
		 * @private
		 */
		private var _verticalScrollPosition:Number = 0;
		
		/**
		 * The number of pixels the list has been scrolled vertically (on
		 * the y-axis).
		 */
		public function get verticalScrollPosition():Number
		{
			return this._verticalScrollPosition;
		}
		
		/**
		 * @private
		 */
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
		
		/**
		 * @private
		 */
		private var _maxVerticalScrollPosition:Number = 0;
		
		/**
		 * The maximum number of pixels the list may be scrolled vertically (on
		 * the y-axis). This value is automatically calculated based on the
		 * total combined height of the list's item renderers. The
		 * <code>verticalScrollPosition</code> property may have a higher value
		 * than the maximum due to elastic edges. However, once the user stops
		 * interacting with the list, it will automatically animate back to the
		 * maximum (or minimum, if below 0).
		 */
		public function get maxVerticalScrollPosition():Number
		{
			return this._maxVerticalScrollPosition;
		}
		
		/**
		 * @private
		 */
		private var _dataProvider:ListCollection;
		
		/**
		 * The collection of data displayed by the list.
		 */
		public function get dataProvider():ListCollection
		{
			return this._dataProvider;
		}
		
		/**
		 * @private
		 */
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
		
		/**
		 * @private
		 */
		private var _labelField:String = "label";
		
		/**
		 * The field in each item that contains the label text. If the item does
		 * not have this field, then the field name is ignored.
		 */
		public function get labelField():String
		{
			return this._labelField;
		}
		
		/**
		 * @private
		 */
		public function set labelField(value:String):void
		{
			if(this._labelField == value)
			{
				return;
			}
			this._labelField = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		/**
		 * @private
		 */
		private var _labelFunction:Function;
		
		/**
		 * A function used to generate a label for a specific item.
		 */
		public function get labelFunction():Function
		{
			return this._labelFunction;
		}
		
		/**
		 * @private
		 */
		public function set labelFunction(value:Function):void
		{
			this._labelFunction = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		/**
		 * @private
		 */
		private var _isSelectable:Boolean = true;
		
		/**
		 * Determines if an item in the list may be selected.
		 */
		public function get isSelectable():Boolean
		{
			return this._isSelectable;
		}
		
		/**
		 * @private
		 */
		public function set isSelectable(value:Boolean):void
		{
			if(this._isSelectable == value)
			{
				return;
			}
			this._isSelectable = value;
			if(!this._isSelectable)
			{
				this.selectedIndex = -1;
			}
			this.invalidate(INVALIDATION_FLAG_SELECTED);
		}
		
		/**
		 * @private
		 */
		private var _selectedIndex:int = -1;
		
		/**
		 * The index of the currently selected item. Returns -1 if no item is
		 * selected.
		 */
		public function get selectedIndex():int
		{
			return this._selectedIndex;
		}
		
		/**
		 * @private
		 */
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
		
		/**
		 * The currently selected item. Returns null if no item is selected.
		 */
		public function get selectedItem():Object
		{
			if(!this._dataProvider || this._selectedIndex < 0 || this._selectedIndex >= this._dataProvider.length)
			{
				return null;
			}
			
			return this._dataProvider.getItemAt(this._selectedIndex);
		}
		
		/**
		 * @private
		 */
		public function set selectedItem(value:Object):void
		{
			this.selectedIndex = this._dataProvider.getItemIndex(value);
		}
		
		/**
		 * @private
		 */
		private var _clipContent:Boolean = false;
		
		/**
		 * If true, the list's content will be clipped to the lists's bounds. In
		 * other words, anything appearing outside the list's bounds will
		 * not be visible.
		 */
		public function get clipContent():Boolean
		{
			return this._clipContent;
		}
		
		/**
		 * @private
		 */
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
		
		/**
		 * @private
		 */
		protected var _onChange:Signal = new Signal(List);
		
		/**
		 * Dispatched when the selected item changes.
		 */
		public function get onChange():ISignal
		{
			return this._onChange;
		}
		
		/**
		 * @private
		 */
		protected var _onScroll:Signal = new Signal(List);
		
		/**
		 * Dispatched when the list is scrolled.
		 */
		public function get onScroll():ISignal
		{
			return this._onScroll;
		}
		
		/**
		 * @private
		 */
		protected var _onItemTouch:Signal = new Signal(List, Object, int, TouchEvent);
		
		/**
		 * Dispatched when an item in the list is touched (in any touch phase).
		 */
		public function get onItemTouch():ISignal
		{
			return this._onItemTouch;
		}
		
		/**
		 * @private
		 */
		private var _scrollerProperties:Object = {};
		
		/**
		 * A set of key/value pairs to be passed down to the list's scroller
		 * instance. The scroller is a Foxhole Scroller control.
		 */
		public function get scrollerProperties():Object
		{
			return this._scrollerProperties;
		}
		
		/**
		 * @private
		 */
		public function set scrollerProperties(value:Object):void
		{
			if(this._scrollerProperties == value)
			{
				return;
			}
			if(!value)
			{
				value = {};
			}
			this._scrollerProperties = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		/**
		 * @private
		 */
		private var _itemRendererProperties:Object = {};

		/**
		 * A set of key/value pairs to be passed down to all of the list's item
		 * renderers. These values are shared by each item renderer, so values
		 * that cannot be shared (such as display objects that need to be added
		 * to the display list) should be passed to item renderers in another
		 * way (such as with an <code>AddedWatcher</code>).
		 * 
		 * @see AddedWatcher
		 */
		public function get itemRendererProperties():Object
		{
			return this._itemRendererProperties;
		}

		/**
		 * @private
		 */
		public function set itemRendererProperties(value:Object):void
		{
			if(this._itemRendererProperties == value)
			{
				return;
			}
			if(!value)
			{
				value = {};
			}
			this._itemRendererProperties = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		/**
		 * @private
		 */
		private var _backgroundSkin:DisplayObject;
		
		/**
		 * A display object displayed behind the item renderers.
		 */
		public function get backgroundSkin():DisplayObject
		{
			return this._backgroundSkin;
		}
		
		/**
		 * @private
		 */
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
		
		/**
		 * @private
		 */
		private var _backgroundDisabledSkin:DisplayObject;
		
		/**
		 * A background to display when the list is disabled.
		 */
		public function get backgroundDisabledSkin():DisplayObject
		{
			return this._backgroundDisabledSkin;
		}
		
		/**
		 * @private
		 */
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
				this.addChildAt(this._backgroundDisabledSkin, 0);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		/**
		 * @private
		 */
		protected var _contentPadding:Number = 0;
		
		/**
		 * The space, in pixels, around the edges of the list's content.
		 */
		public function get contentPadding():Number
		{
			return _contentPadding;
		}
		
		/**
		 * @private
		 */
		public function set contentPadding(value:Number):void
		{
			if(this._contentPadding == value)
			{
				return;
			}
			this._contentPadding = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		/**
		 * @private
		 */
		protected var _verticalAlign:String = VERTICAL_ALIGN_TOP;
		
		/**
		 * If the list's content height is less than the list's height, it will
		 * be aligned to the top, middle, or bottom of the list.
		 * 
		 * @see VERTICAL_ALIGN_TOP
		 * @see VERTICAL_ALIGN_MIDDLE
		 * @see VERTICAL_ALIGN_BOTTOM
		 */
		public function get verticalAlign():String
		{
			return _verticalAlign;
		}
		
		/**
		 * @private
		 */
		public function set verticalAlign(value:String):void
		{
			if(this._verticalAlign == value)
			{
				return;
			}
			this._verticalAlign = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		/**
		 * @private
		 */
		private var _itemRendererType:Class = SimpleItemRenderer;
		
		/**
		 * The class used to instantiate item renderers.
		 */
		public function get itemRendererType():Class
		{
			return this._itemRendererType;
		}
		
		/**
		 * @private
		 */
		public function set itemRendererType(value:Class):void
		{
			if(this._itemRendererType == value)
			{
				return;
			}
			
			this._itemRendererType = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		/**
		 * @private
		 */
		private var _itemRendererFunction:Function;
		
		/**
		 * A function called that is expected to return a new item renderer. Has
		 * a higher priority than <code>itemRendererType</code>.
		 * 
		 * @see itemRendererType
		 */
		public function get itemRendererFunction():Function
		{
			return this._itemRendererFunction;
		}
		
		/**
		 * @private
		 */
		public function set itemRendererFunction(value:Function):void
		{
			if(this._itemRendererFunction === value)
			{
				return;
			}
			
			this._itemRendererFunction = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		/**
		 * @private
		 */
		private var _typicalItem:Object = null;
		
		/**
		 * Used to auto-size the list. If the list's width or height is NaN, the
		 * list will try to automatically pick an ideal size. This item is
		 * used in that process to create a sample item renderer.
		 */
		public function get typicalItem():Object
		{
			return this._typicalItem;
		}
		
		/**
		 * @private
		 */
		public function set typicalItem(value:Object):void
		{
			if(this._typicalItem == value)
			{
				return;
			}
			this._typicalItem = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		/**
		 * @private
		 */
		private var _useVirtualLayout:Boolean = true;
		
		/**
		 * Determines if the list creates item renderers for every single item
		 * (<code>false</code>), or if it only creates enough item renderers to
		 * fill the list's bounds (<code>true</code>). If virtual layout is
		 * enabled, item renderers are reused, and their data may change.
		 */
		public function get useVirtualLayout():Boolean
		{
			return this._useVirtualLayout;
		}
		
		/**
		 * @private
		 */
		public function set useVirtualLayout(value:Boolean):void
		{
			if(this._useVirtualLayout == value)
			{
				return;
			}
			this._useVirtualLayout = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
		}
		
		/**
		 * Sets a single property on the list's scroller instance. The
		 * scroller is a Foxhole Scroller control.
		 */
		public function setScrollerProperty(propertyName:String, propertyValue:Object):void
		{
			this._scrollerProperties[propertyName] = propertyValue;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		/**
		 * Sets a property value for all of the list's item renderers. This
		 * property will be shared by all item renderers, so skins and similar
		 * objects that can only be used in one place should be initialized in
		 * a different way.
		 */
		public function setItemRendererProperty(propertyName:String, propertyValue:Object):void
		{
			this._itemRendererProperties[propertyName] = propertyValue;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		/**
		 * Using <code>labelField</code> and <code>labelFunction</code>,
		 * generates a label for a particular item. May be called by item
		 * renderers or externally. Item renderers will not receive a generated
		 * label value automatically.
		 */
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
		
		/**
		 * Scrolls the list so that the specified item is visible.
		 */
		public function scrollToDisplayIndex(index:int):void
		{
			this._scrollToIndex = index;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function dispose():void
		{
			this._onChange.removeAll();
			this._onScroll.removeAll();
			this._onItemTouch.removeAll();
			super.dispose();
		}
		
		/**
		 * If the user is dragging the scroll, calling stopScrolling() will
		 * cause the list to ignore the drag.
		 */
		public function stopScrolling():void
		{
			if(!this._scroller)
			{
				return;
			}
			this._scroller.stopScrolling();
		}
		
		/**
		 * @private
		 */
		override protected function initialize():void
		{
			if(!this._scroller)
			{
				this._scroller = new Scroller();
				this._scroller.nameList.add("foxhole-list-scroller");
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
		
		/**
		 * @private
		 */
		override protected function draw():void
		{
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			var scrollInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SCROLL);
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			const stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			
			if(stylesInvalid)
			{
				this.refreshScrollerStyles();
			}
			
			if(sizeInvalid || stylesInvalid || stateInvalid)
			{
				this.refreshBackgroundSkin();
			}
			
			if(!isNaN(this.explicitWidth))
			{
				this._dataContainer.width = this.explicitWidth - 2 * this._contentPadding;
			}
			if(!isNaN(this.explicitHeight))
			{
				this._dataContainer.visibleHeight = this.explicitHeight - 2 * contentPadding;
			}
			else
			{
				this._dataContainer.visibleHeight = NaN;
			}
			this._dataContainer.isEnabled = this._isEnabled;
			this._dataContainer.isSelectable = this._isSelectable;
			this._dataContainer.selectedIndex = this._selectedIndex;
			this._dataContainer.dataProvider = this._dataProvider;
			this._dataContainer.itemRendererType = this._itemRendererType;
			this._dataContainer.itemRendererFunction = this._itemRendererFunction;
			this._dataContainer.itemRendererProperties = this._itemRendererProperties;
			this._dataContainer.typicalItem = this._typicalItem;
			this._dataContainer.useVirtualLayout = this._useVirtualLayout;
			this._dataContainer.verticalScrollPosition = this._verticalScrollPosition;
			this._dataContainer.validate();
			
			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;
			
			if(this._scrollToIndex >= 0 && this._dataProvider)
			{
				const rowHeight:Number = this._dataContainer.height / this._dataProvider.length;
				const visibleRowCount:int = Math.ceil(this._dataContainer.visibleHeight / rowHeight);
				this.verticalScrollPosition = rowHeight * Math.max(0, Math.min(this._dataProvider.length - visibleRowCount, this._scrollToIndex - visibleRowCount / 2));
				this._scrollToIndex = -1;
			}
			
			this._scroller.isEnabled = this._isEnabled;
			this._scroller.width = this.actualWidth - 2 * this._contentPadding;
			this._scroller.height = this.actualHeight - 2 * this._contentPadding;
			this._scroller.x = this._contentPadding;
			this._scroller.y = this._contentPadding;
			this._scroller.clipContent = this._clipContent;
			this._scroller.verticalAlign = this._verticalAlign;
			this._scroller.verticalScrollPosition = this._verticalScrollPosition;
			this._scroller.validate();
			this._maxVerticalScrollPosition = this._scroller.maxVerticalScrollPosition;
			this._verticalScrollPosition = this._scroller.verticalScrollPosition;
		}

		/**
		 * @private
		 */
		protected function autoSizeIfNeeded():Boolean
		{
			const needsWidth:Boolean = isNaN(this.explicitWidth);
			const needsHeight:Boolean = isNaN(this.explicitHeight);
			if(!needsWidth && !needsHeight)
			{
				return false;
			}

			var newWidth:Number = this.explicitWidth;
			var newHeight:Number = this.explicitHeight;
			if(needsWidth)
			{
				newWidth = this._dataContainer.width + 2 * this._contentPadding;
			}
			if(needsHeight)
			{
				newHeight = this._dataContainer.height + 2 * this._contentPadding;
			}
			this.setSizeInternal(newWidth, newHeight, false);
			return true;
		}
		
		/**
		 * @private
		 */
		protected function refreshScrollerStyles():void
		{
			for(var propertyName:String in this._scrollerProperties)
			{
				if(this._scroller.hasOwnProperty(propertyName))
				{
					var propertyValue:Object = this._scrollerProperties[propertyName];
					this._scroller[propertyName] = propertyValue;
				}
			}
		}
		
		/**
		 * @private
		 */
		protected function refreshBackgroundSkin():void
		{
			var backgroundSkin:DisplayObject = this._backgroundSkin;
			if(!this._isEnabled && this._backgroundDisabledSkin)
			{
				if(this._backgroundSkin)
				{
					this._backgroundSkin.visible = false;
				}
				backgroundSkin = this._backgroundDisabledSkin;
			}
			else if(this._backgroundDisabledSkin)
			{
				this._backgroundDisabledSkin.visible = false;
			}
			if(backgroundSkin)
			{
				backgroundSkin.visible = true;
				backgroundSkin.width = this.actualWidth;
				backgroundSkin.height = this.actualHeight;
			}
		}
		
		/**
		 * @private
		 */
		protected function scroller_onScroll(scroller:Scroller):void
		{
			this.verticalScrollPosition = this._scroller.verticalScrollPosition;
		}
		
		/**
		 * @private
		 */
		protected function dataContainer_onChange(dataContainer:ListDataContainer):void
		{
			this.selectedIndex = this._dataContainer.selectedIndex;
		}
		
		/**
		 * @private
		 */
		protected function dataContainer_onItemTouch(dataContainer:ListDataContainer, item:Object, index:int, event:TouchEvent):void
		{
			this._onItemTouch.dispatch(this, item, index, event);
		}
	}
}