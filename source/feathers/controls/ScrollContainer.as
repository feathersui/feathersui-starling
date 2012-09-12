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
package feathers.controls
{
	import feathers.controls.supportClasses.LayoutViewPort;
	import feathers.core.FeathersControl;
	import feathers.core.PropertyProxy;
	import feathers.layout.ILayout;
	import feathers.layout.IVirtualLayout;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import starling.display.DisplayObject;

	/**
	 * A layout container that supports scrolling.
	 */
	public class ScrollContainer extends FeathersControl
	{
		/**
		 * The default value added to the <code>nameList</code> of the scroller.
		 */
		public static const DEFAULT_CHILD_NAME_SCROLLER:String = "feathers-scroll-container-scroller";

		/**
		 * Constructor.
		 */
		public function ScrollContainer()
		{
			this.viewPort = new LayoutViewPort();
		}

		/**
		 * The value added to the <code>nameList</code> of the scroller.
		 */
		protected var scrollerName:String = DEFAULT_CHILD_NAME_SCROLLER;

		/**
		 * @private
		 */
		protected var scroller:Scroller;

		/**
		 * @private
		 */
		protected var viewPort:LayoutViewPort;

		/**
		 * @private
		 */
		private var _layout:ILayout;

		/**
		 * Controls the way that the container's children are positioned and
		 * sized.
		 */
		public function get layout():ILayout
		{
			return this._layout;
		}

		/**
		 * @private
		 */
		public function set layout(value:ILayout):void
		{
			if(this._layout == value)
			{
				return;
			}
			this._layout = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		private var _horizontalScrollPosition:Number = 0;

		/**
		 * The number of pixels the list has been scrolled horizontally (on
		 * the x-axis).
		 */
		public function get horizontalScrollPosition():Number
		{
			return this._horizontalScrollPosition;
		}

		/**
		 * @private
		 */
		public function set horizontalScrollPosition(value:Number):void
		{
			if(this._horizontalScrollPosition == value)
			{
				return;
			}
			this._horizontalScrollPosition = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
			this._onScroll.dispatch(this);
		}

		/**
		 * @private
		 */
		private var _maxHorizontalScrollPosition:Number = 0;

		/**
		 * The maximum number of pixels the container may be scrolled horizontally
		 * (on the x-axis). This value is automatically calculated by the
		 * supplied layout algorithm. The <code>horizontalScrollPosition</code>
		 * property may have a higher value than the maximum due to elastic
		 * edges. However, once the user stops interacting with the container,
		 * it will automatically animate back to the maximum (or minimum, if
		 * the scroll position is below 0).
		 */
		public function get maxHorizontalScrollPosition():Number
		{
			return this._maxHorizontalScrollPosition;
		}

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
		 * The maximum number of pixels the container may be scrolled vertically
		 * (on the y-axis). This value is automatically calculated by the
		 * supplied layout algorithm. The <code>verticalScrollPosition</code>
		 * property may have a higher value than the maximum due to elastic
		 * edges. However, once the user stops interacting with the container,
		 * it will automatically animate back to the maximum (or minimum, if
		 * the scroll position is below 0).
		 */
		public function get maxVerticalScrollPosition():Number
		{
			return this._maxVerticalScrollPosition;
		}

		/**
		 * @private
		 */
		private var _scrollerProperties:PropertyProxy;

		/**
		 * A set of key/value pairs to be passed down to the container's
		 * scroller sub-component. The scroller is a
		 * <code>feathers.controls.Scroller</code> instance.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
		 * which is in a <code>Scroller</code> which is in a <code>List</code>,
		 * you can use the following syntax:</p>
		 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 * 
		 * @see feathers.controls.Scroller
		 */
		public function get scrollerProperties():Object
		{
			if(!this._scrollerProperties)
			{
				this._scrollerProperties = new PropertyProxy(scrollerProperties_onChange);
			}
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
				value = new PropertyProxy();
			}
			if(!(value is PropertyProxy))
			{
				const newValue:PropertyProxy = new PropertyProxy();
				for(var propertyName:String in value)
				{
					newValue[propertyName] = value[propertyName];
				}
				value = newValue;
			}
			if(this._scrollerProperties)
			{
				this._scrollerProperties.onChange.remove(scrollerProperties_onChange);
			}
			this._scrollerProperties = PropertyProxy(value);
			if(this._scrollerProperties)
			{
				this._scrollerProperties.onChange.add(scrollerProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _onScroll:Signal = new Signal(ScrollContainer);

		/**
		 * Dispatched when the container scrolls.
		 */
		public function get onScroll():ISignal
		{
			return this._onScroll;
		}

		/**
		 * @private
		 */
		override public function get numChildren():int
		{
			return this.viewPort.numChildren;
		}

		/**
		 * @private
		 */
		override public function getChildByName(name:String):DisplayObject
		{
			return this.viewPort.getChildByName(name);
		}

		/**
		 * @private
		 */
		override public function getChildAt(index:int):DisplayObject
		{
			return this.viewPort.getChildAt(index);
		}

		/**
		 * @private
		 */
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			return this.viewPort.addChildAt(child, index);
		}

		/**
		 * @private
		 */
		override public function removeChildAt(index:int, dispose:Boolean = false):DisplayObject
		{
			return this.viewPort.removeChildAt(index, dispose);
		}

		/**
		 * @private
		 */
		override public function getChildIndex(child:DisplayObject):int
		{
			return this.viewPort.getChildIndex(child);
		}

		/**
		 * @private
		 */
		override public function setChildIndex(child:DisplayObject, index:int):void
		{
			this.viewPort.setChildIndex(child, index);
		}

		/**
		 * @private
		 */
		override public function swapChildrenAt(index1:int, index2:int):void
		{
			this.viewPort.swapChildrenAt(index1, index2);
		}

		/**
		 * @private
		 */
		override public function sortChildren(compareFunction:Function):void
		{
			this.viewPort.sortChildren(compareFunction);
		}

		/**
		 * @private
		 */
		override public function dispose():void
		{
			this._onScroll.removeAll();
			super.dispose();
		}

		/**
		 * If the user is dragging the scroll, calling stopScrolling() will
		 * cause the container to ignore the drag. The children of the container
		 * will still receive touches, so it's useful to call this if the
		 * children need to support touches or dragging without the container
		 * also scrolling.
		 */
		public function stopScrolling():void
		{
			if(!this.scroller)
			{
				return;
			}
			this.scroller.stopScrolling();
		}

		/**
		 * @private
		 */
		override protected function initialize():void
		{
			if(!this.scroller)
			{
				this.scroller = new Scroller();
				this.scroller.viewPort = this.viewPort;
				this.scroller.nameList.add(this.scrollerName);
				this.scroller.onScroll.add(scroller_onScroll);
				super.addChildAt(this.scroller, 0);
			}
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const scrollInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SCROLL);
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);

			if(dataInvalid)
			{
				if(this._layout is IVirtualLayout)
				{
					IVirtualLayout(this._layout).useVirtualLayout = false;
				}
				this.viewPort.layout = this._layout;
			}

			if(stylesInvalid)
			{
				this.refreshScrollerStyles();
			}

			if(scrollInvalid)
			{
				this.scroller.verticalScrollPosition = this._verticalScrollPosition;
				this.scroller.horizontalScrollPosition = this._horizontalScrollPosition;
			}

			if(sizeInvalid)
			{
				if(isNaN(this.explicitWidth))
				{
					this.scroller.width = NaN;
				}
				else
				{
					this.scroller.width = Math.max(0, this.explicitWidth);
				}
				if(isNaN(this.explicitHeight))
				{
					this.scroller.height = NaN;
				}
				else
				{
					this.scroller.height = Math.max(0, this.explicitHeight);
				}
				this.scroller.minWidth = Math.max(0,  this._minWidth);
				this.scroller.maxWidth = Math.max(0, this._maxWidth);
				this.scroller.minHeight = Math.max(0, this._minHeight);
				this.scroller.maxHeight = Math.max(0, this._maxHeight);
			}

			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

			this.scroller.validate();
			this._maxHorizontalScrollPosition = this.scroller.maxHorizontalScrollPosition;
			this._maxVerticalScrollPosition = this.scroller.maxVerticalScrollPosition;
			this._horizontalScrollPosition = this.scroller.horizontalScrollPosition;
			this._verticalScrollPosition = this.scroller.verticalScrollPosition;
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

			this.scroller.validate();
			var newWidth:Number = this.explicitWidth;
			var newHeight:Number = this.explicitHeight;
			if(needsWidth)
			{
				newWidth = this.scroller.width;
			}
			if(needsHeight)
			{
				newHeight = this.scroller.height;
			}
			return this.setSizeInternal(newWidth, newHeight, false);
		}

		/**
		 * @private
		 */
		protected function refreshScrollerStyles():void
		{
			for(var propertyName:String in this._scrollerProperties)
			{
				if(this.scroller.hasOwnProperty(propertyName))
				{
					var propertyValue:Object = this._scrollerProperties[propertyName];
					this.scroller[propertyName] = propertyValue;
				}
			}
		}

		/**
		 * @private
		 */
		protected function scrollerProperties_onChange(proxy:PropertyProxy, name:Object):void
		{
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected function scroller_onScroll(scroller:Scroller):void
		{
			this._horizontalScrollPosition = this.scroller.horizontalScrollPosition;
			this._verticalScrollPosition = this.scroller.verticalScrollPosition;
			this._maxHorizontalScrollPosition = this.scroller.maxHorizontalScrollPosition;
			this._maxVerticalScrollPosition = this.scroller.maxVerticalScrollPosition;
			this._onScroll.dispatch(this);
		}
	}
}
