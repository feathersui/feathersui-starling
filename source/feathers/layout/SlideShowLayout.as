/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.layout
{
	import feathers.core.IValidating;
	import feathers.layout.Direction;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.VerticalAlign;

	import flash.errors.IllegalOperationError;
	import flash.geom.Point;
	import flash.ui.Keyboard;

	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.utils.Pool;

	/**
	 * Dispatched when a property of the layout changes, indicating that a
	 * redraw is probably needed.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>null</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @eventType starling.events.Event.CHANGE
	 */
	[Event(name="change",type="starling.events.Event")]

	/**
	 * Displays one item per page.
	 *
	 * @see ../../../help/slide-show-layout.html How to use SlideShowLayout with Feathers containers
	 *
	 * @productversion Feathers 3.3.0
	 */
	public class SlideShowLayout extends EventDispatcher implements IVirtualLayout, ITrimmedVirtualLayout
	{
		/**
		 * @private
		 */
		protected static const FUZZY_PAGE_DETECTION:Number = 0.000001;

		/**
		 * Constructor.
		 */
		public function SlideShowLayout()
		{
			super();
		}

		/**
		 * @private
		 */
		protected var _direction:String = Direction.HORIZONTAL;

		[Inspectable(type="String",enumeration="horizontal,vertical")]
		/**
		 * Determines if pages are positioned from left-to-right or from top-to-bottom.
		 *
		 * @default feathers.layout.Direction.HORIZONTAL
		 *
		 * @see feathers.layout.Direction#HORIZONTAL
		 * @see feathers.layout.Direction#VERTICAL
		 */
		public function get direction():String
		{
			return this._direction;
		}

		/**
		 * @private
		 */
		public function set direction(value:String):void
		{
			if(this._direction === value)
			{
				return;
			}
			this._direction = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * Quickly sets all padding properties to the same value. The
		 * <code>padding</code> getter always returns the value of
		 * <code>paddingTop</code>, but the other padding values may be
		 * different.
		 *
		 * @default 0
		 *
		 * @see #paddingTop
		 * @see #paddingRight
		 * @see #paddingBottom
		 * @see #paddingLeft
		 */
		public function get padding():Number
		{
			return this._paddingTop;
		}

		/**
		 * @private
		 */
		public function set padding(value:Number):void
		{
			this.paddingTop = value;
			this.paddingRight = value;
			this.paddingBottom = value;
			this.paddingLeft = value;
		}

		/**
		 * @private
		 */
		protected var _paddingTop:Number = 0;

		/**
		 * The space, in pixels, that appears on top of each item.
		 *
		 * @default 0
		 */
		public function get paddingTop():Number
		{
			return this._paddingTop;
		}

		/**
		 * @private
		 */
		public function set paddingTop(value:Number):void
		{
			if(this._paddingTop === value)
			{
				return;
			}
			this._paddingTop = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _paddingRight:Number = 0;

		/**
		 * The minimum space, in pixels, to the right of each item.
		 *
		 * @default 0
		 */
		public function get paddingRight():Number
		{
			return this._paddingRight;
		}

		/**
		 * @private
		 */
		public function set paddingRight(value:Number):void
		{
			if(this._paddingRight === value)
			{
				return;
			}
			this._paddingRight = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _paddingBottom:Number = 0;

		/**
		 * The space, in pixels, that appears on the bottom of each item.
		 * item.
		 *
		 * @default 0
		 */
		public function get paddingBottom():Number
		{
			return this._paddingBottom;
		}

		/**
		 * @private
		 */
		public function set paddingBottom(value:Number):void
		{
			if(this._paddingBottom === value)
			{
				return;
			}
			this._paddingBottom = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _paddingLeft:Number = 0;

		/**
		 * The minimum space, in pixels, to the left of each item.
		 *
		 * @default 0
		 */
		public function get paddingLeft():Number
		{
			return this._paddingLeft;
		}

		/**
		 * @private
		 */
		public function set paddingLeft(value:Number):void
		{
			if(this._paddingLeft === value)
			{
				return;
			}
			this._paddingLeft = value;
			this.dispatchEventWith(Event.CHANGE);
		}


		/**
		 * @private
		 */
		protected var _verticalAlign:String = VerticalAlign.MIDDLE;

		[Inspectable(type="String",enumeration="top,middle,bottom,justify")]
		/**
		 * The alignment of each item vertically, on the y-axis.
		 *
		 * @default feathers.layout.VerticalAlign.MIDDLE
		 *
		 * @see feathers.layout.VerticalAlign#TOP
		 * @see feathers.layout.VerticalAlign#MIDDLE
		 * @see feathers.layout.VerticalAlign#BOTTOM
		 * @see feathers.layout.VerticalAlign#JUSTIFY
		 */
		public function get verticalAlign():String
		{
			return this._verticalAlign;
		}

		/**
		 * @private
		 */
		public function set verticalAlign(value:String):void
		{
			if(this._verticalAlign === value)
			{
				return;
			}
			this._verticalAlign = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _horizontalAlign:String = HorizontalAlign.CENTER;

		[Inspectable(type="String",enumeration="left,center,right,justify")]
		/**
		 * The alignment of each item horizontally, on the x-axis.
		 *
		 * @default feathers.layout.HorizontalAlign.CENTER
		 *
		 * @see feathers.layout.HorizontalAlign#LEFT
		 * @see feathers.layout.HorizontalAlign#CENTER
		 * @see feathers.layout.HorizontalAlign#RIGHT
		 * @see feathers.layout.HorizontalAlign#JUSTIFY
		 */
		public function get horizontalAlign():String
		{
			return this._horizontalAlign;
		}

		/**
		 * @private
		 */
		public function set horizontalAlign(value:String):void
		{
			if(this._horizontalAlign === value)
			{
				return;
			}
			this._horizontalAlign = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _useVirtualLayout:Boolean = true;

		/**
		 * @inheritDoc
		 *
		 * @default true
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
			if(this._useVirtualLayout === value)
			{
				return;
			}
			this._useVirtualLayout = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _beforeVirtualizedItemCount:int = 0;

		/**
		 * @inheritDoc
		 */
		public function get beforeVirtualizedItemCount():int
		{
			return this._beforeVirtualizedItemCount;
		}

		/**
		 * @private
		 */
		public function set beforeVirtualizedItemCount(value:int):void
		{
			if(this._beforeVirtualizedItemCount === value)
			{
				return;
			}
			this._beforeVirtualizedItemCount = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _afterVirtualizedItemCount:int = 0;

		/**
		 * @inheritDoc
		 */
		public function get afterVirtualizedItemCount():int
		{
			return this._afterVirtualizedItemCount;
		}

		/**
		 * @private
		 */
		public function set afterVirtualizedItemCount(value:int):void
		{
			if(this._afterVirtualizedItemCount === value)
			{
				return;
			}
			this._afterVirtualizedItemCount = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _typicalItem:DisplayObject;

		/**
		 * @inheritDoc
		 */
		public function get typicalItem():DisplayObject
		{
			return this._typicalItem;
		}

		/**
		 * @private
		 */
		public function set typicalItem(value:DisplayObject):void
		{
			if(this._typicalItem === value)
			{
				return;
			}
			this._typicalItem = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _minimumItemCount:int = 1;

		/**
		 * If the layout is virtualized, specifies the minimum total number of
		 * items that will be created, even if some are not currently visible
		 * in the view port.
		 * 
		 * @default 1
		 *
		 * @see #useVirtualLayout
		 */
		public function get minimumItemCount():int
		{
			return this._minimumItemCount;
		}

		/**
		 * @private
		 */
		public function set minimumItemCount(value:int):void
		{
			if(this._minimumItemCount === value)
			{
				return;
			}
			this._minimumItemCount = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @inheritDoc
		 */
		public function get requiresLayoutOnScroll():Boolean
		{
			return this._useVirtualLayout;
		}

		/**
		 * @inheritDoc
		 */
		public function layout(items:Vector.<DisplayObject>, viewPortBounds:ViewPortBounds = null, result:LayoutBoundsResult = null):LayoutBoundsResult
		{
			//since viewPortBounds can be null, we may need to provide some defaults
			var scrollX:Number = viewPortBounds !== null ? viewPortBounds.scrollX : 0;
			var scrollY:Number = viewPortBounds !== null ? viewPortBounds.scrollY : 0;
			var boundsX:Number = viewPortBounds !== null ? viewPortBounds.x : 0;
			var boundsY:Number = viewPortBounds !== null ? viewPortBounds.y : 0;
			var minWidth:Number = viewPortBounds !== null ? viewPortBounds.minWidth : 0;
			var minHeight:Number = viewPortBounds !== null ? viewPortBounds.minHeight : 0;
			var maxWidth:Number = viewPortBounds !== null ? viewPortBounds.maxWidth : Number.POSITIVE_INFINITY;
			var maxHeight:Number = viewPortBounds !== null ? viewPortBounds.maxHeight : Number.POSITIVE_INFINITY;
			var explicitWidth:Number = viewPortBounds !== null ? viewPortBounds.explicitWidth : NaN;
			var explicitHeight:Number = viewPortBounds !== null ? viewPortBounds.explicitHeight : NaN;
			var itemCount:int = items.length;

			if(this._useVirtualLayout)
			{
				//if the layout is virtualized, we'll need the dimensions of the
				//typical item so that we have fallback values when an item is null
				this.prepareTypicalItem(explicitWidth - this._paddingLeft - this._paddingRight,
					explicitHeight - this._paddingTop - this._paddingBottom);
				var calculatedTypicalItemWidth:Number = this._typicalItem ? this._typicalItem.width : 0;
				var calculatedTypicalItemHeight:Number = this._typicalItem ? this._typicalItem.height : 0;
			}

			var needsExplicitWidth:Boolean = explicitWidth !== explicitWidth;
			var needsExplicitHeight:Boolean = explicitHeight !== explicitHeight;
			var viewPortWidth:Number = explicitWidth;
			if(needsExplicitWidth)
			{
				viewPortWidth = calculatedTypicalItemWidth;
			}
			var viewPortHeight:Number = explicitHeight;
			if(needsExplicitHeight)
			{
				viewPortHeight = calculatedTypicalItemHeight;
			}

			if(!this._useVirtualLayout ||
				this._horizontalAlign !== HorizontalAlign.JUSTIFY ||
				this._verticalAlign !== VerticalAlign.JUSTIFY ||
				needsExplicitWidth || needsExplicitHeight)
			{
				//in some cases, we may need to validate all of the items so
				//that we can use their dimensions below.
				this.validateItems(items, explicitWidth - this._paddingLeft - this._paddingRight,
					explicitHeight - this._paddingTop - this._paddingBottom);
			}

			//if the layout isn't virtual and the view port dimensions aren't
			//explicit, we need to calculate them
			if(!this._useVirtualLayout && (needsExplicitWidth || needsExplicitHeight))
			{
				var maxItemWidth:Number = this._useVirtualLayout ? calculatedTypicalItemWidth : 0;
				var maxItemHeight:Number = this._useVirtualLayout ? calculatedTypicalItemHeight : 0;
				for(var i:int = 0; i < itemCount; i++)
				{
					var item:DisplayObject = items[i];
					if(maxItemWidth < item.width)
					{
						maxItemWidth = item.width;
					}
					if(maxItemHeight < item.height)
					{
						maxItemHeight = item.height;
					}
				}
				if(needsExplicitWidth)
				{
					viewPortWidth = maxItemWidth + this._paddingLeft + this._paddingRight;
				}
				if(needsExplicitHeight)
				{
					viewPortHeight = maxItemHeight + this._paddingTop + this._paddingBottom;
				}
			}
			if(needsExplicitWidth)
			{
				if(viewPortWidth < minWidth)
				{
					viewPortWidth = minWidth;
				}
				else if(viewPortWidth > maxWidth)
				{
					viewPortWidth = maxWidth;
				}
			}
			if(needsExplicitHeight)
			{
				if(viewPortHeight < minHeight)
				{
					viewPortHeight = minHeight;
				}
				else if(viewPortHeight > maxHeight)
				{
					viewPortHeight = maxHeight;
				}
			}
			if(this._direction === Direction.VERTICAL)
			{
				var startPosition:Number = boundsY;
			}
			else
			{
				startPosition = boundsX;
			}
			var position:Number = startPosition;
			if(this._useVirtualLayout)
			{
				//if the layout is virtualized, we can make our loops shorter
				//by skipping some items at the beginning and end. this
				//improves performance.
				if(this._direction === Direction.VERTICAL)
				{
					position += (this._beforeVirtualizedItemCount * viewPortHeight);
				}
				else //horizontal
				{
					position += (this._beforeVirtualizedItemCount * viewPortWidth);
				}
			}
			var contentWidth:Number = viewPortWidth - this._paddingLeft - this._paddingRight;
			var contentHeight:Number = viewPortHeight - this._paddingTop - this._paddingBottom;
			for(i = 0; i < itemCount; i++)
			{
				item = items[i];
				if(item !== null)
				{
					//we get here if the item isn't null. it is never null if
					//the layout isn't virtualized.
					var layoutItem:ILayoutDisplayObject = item as ILayoutDisplayObject;
					if(layoutItem !== null && !layoutItem.includeInLayout)
					{
						continue;
					}
					var xPosition:Number = this._direction === Direction.VERTICAL ? 0 : position;
					switch(this._horizontalAlign)
					{
						case HorizontalAlign.JUSTIFY:
						{
							xPosition += this._paddingLeft;
							item.width = contentWidth;
							break;
						}
						case HorizontalAlign.LEFT:
						{
							xPosition += this._paddingLeft;
							break;
						}
						case HorizontalAlign.RIGHT:
						{
							xPosition += contentWidth - item.width;
							break;
						}
						case HorizontalAlign.CENTER:
						{
							xPosition += Math.round((contentWidth - item.width) / 2);
							break;
						}
					}
					item.x = xPosition;
					var yPosition:Number = this._direction === Direction.VERTICAL ? position : 0;
					switch(this._verticalAlign)
					{
						case VerticalAlign.JUSTIFY:
						{
							yPosition += this._paddingTop;
							item.height = contentHeight;
							break;
						}
						case VerticalAlign.TOP:
						{
							yPosition += this._paddingTop;
							break;
						}
						case VerticalAlign.BOTTOM:
						{
							yPosition += contentHeight - item.height;
							break;
						}
						case VerticalAlign.MIDDLE:
						{
							yPosition += Math.round((contentHeight - item.height) / 2);
							break;
						}
					}
					item.y = yPosition;
				}
				if(this._direction === Direction.VERTICAL)
				{
					position += viewPortHeight;
				}
				else //horizontal
				{
					position += viewPortWidth;
				}
			}
			if(position === startPosition)
			{
				//require at least one page
				if(this._direction === Direction.VERTICAL)
				{
					position += viewPortHeight;
				}
				else //horizontal
				{
					position += viewPortWidth;
				}
			}
			if(this._useVirtualLayout)
			{
				position += (viewPortWidth * this._afterVirtualizedItemCount);
			}

			if(!result)
			{
				result = new LayoutBoundsResult();
			}
			result.contentX = 0;
			result.contentY = 0;
			if(this._direction === Direction.VERTICAL)
			{
				result.contentWidth = viewPortWidth;
				result.contentHeight = position;
			}
			else //horizontal
			{
				result.contentWidth = position;
				result.contentHeight = viewPortHeight;
			}
			result.viewPortWidth = viewPortWidth;
			result.viewPortHeight = viewPortHeight;
			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function measureViewPort(itemCount:int, viewPortBounds:ViewPortBounds = null, result:Point = null):Point
		{
			if(!result)
			{
				result = new Point();
			}
			if(!this._useVirtualLayout)
			{
				throw new IllegalOperationError("measureViewPort() may be called only if useVirtualLayout is true.")
			}

			var explicitWidth:Number = viewPortBounds ? viewPortBounds.explicitWidth : NaN;
			var explicitHeight:Number = viewPortBounds ? viewPortBounds.explicitHeight : NaN;
			var needsWidth:Boolean = explicitWidth !== explicitWidth; //isNaN
			var needsHeight:Boolean = explicitHeight !== explicitHeight; //isNaN
			if(!needsWidth && !needsHeight)
			{
				result.x = explicitWidth;
				result.y = explicitHeight;
				return result;
			}
			var minWidth:Number = viewPortBounds ? viewPortBounds.minWidth : 0;
			var minHeight:Number = viewPortBounds ? viewPortBounds.minHeight : 0;
			var maxWidth:Number = viewPortBounds ? viewPortBounds.maxWidth : Number.POSITIVE_INFINITY;
			var maxHeight:Number = viewPortBounds ? viewPortBounds.maxHeight : Number.POSITIVE_INFINITY;

			this.prepareTypicalItem(explicitWidth - this._paddingLeft - this._paddingRight,
				explicitHeight - this._paddingTop - this._paddingBottom);
			var calculatedTypicalItemWidth:Number = this._typicalItem ? this._typicalItem.width : 0;
			var calculatedTypicalItemHeight:Number = this._typicalItem ? this._typicalItem.height : 0;

			if(needsWidth)
			{
				var resultWidth:Number = calculatedTypicalItemWidth + this._paddingLeft + this._paddingRight;
				if(resultWidth < minWidth)
				{
					resultWidth = minWidth;
				}
				else if(resultWidth > maxWidth)
				{
					resultWidth = maxWidth;
				}
				result.x = resultWidth;
			}
			else
			{
				result.x = explicitWidth;
			}

			if(needsHeight)
			{
				var resultHeight:Number = calculatedTypicalItemHeight + this._paddingTop + this._paddingBottom;
				if(resultHeight < minHeight)
				{
					resultHeight = minHeight;
				}
				else if(resultHeight > maxHeight)
				{
					resultHeight = maxHeight;
				}
				result.y = resultHeight;
			}
			else
			{
				result.y = explicitHeight;
			}

			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function getVisibleIndicesAtScrollPosition(scrollX:Number, scrollY:Number, width:Number, height:Number, itemCount:int, result:Vector.<int> = null):Vector.<int>
		{
			if(result !== null)
			{
				result.length = 0;
			}
			else
			{
				result = new <int>[];
			}
			if(!this._useVirtualLayout)
			{
				throw new IllegalOperationError("getVisibleIndicesAtScrollPosition() may be called only if useVirtualLayout is true.")
			}
			if(this._direction === Direction.VERTICAL)
			{
				var baseIndex:int = scrollY / height;
				var isBetweenPages:Boolean = ((scrollY / height) - baseIndex) > FUZZY_PAGE_DETECTION;
			}
			else //horizontal
			{
				baseIndex = scrollX / width;
				isBetweenPages = ((scrollX / width) - baseIndex) > FUZZY_PAGE_DETECTION;
			}
			var extraBeforeCount:int = int(this._minimumItemCount / 2);
			var startIndex:int = baseIndex - extraBeforeCount;
			if(startIndex < 0)
			{
				extraBeforeCount += startIndex;
				startIndex = 0;
			}
			var extraAfterCount:int = this._minimumItemCount - extraBeforeCount;
			if(!isBetweenPages || this._minimumItemCount > 2)
			{
				extraAfterCount--;
			}
			var endIndex:int = baseIndex + extraAfterCount;
			var maxIndex:int = itemCount - 1;
			if(endIndex > maxIndex)
			{
				endIndex = maxIndex;
			}
			var pushIndex:int = 0;
			for(var i:int = startIndex; i <= endIndex; i++)
			{
				result[pushIndex] = i;
				pushIndex++;
			}
			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function getNearestScrollPositionForIndex(index:int, scrollX:Number, scrollY:Number, items:Vector.<DisplayObject>,
			x:Number, y:Number, width:Number, height:Number, result:Point = null):Point
		{
			return this.getScrollPositionForIndex(index, items, x, y, width, height, result);
		}

		/**
		 * @inheritDoc
		 */
		public function calculateNavigationDestination(items:Vector.<DisplayObject>, index:int, keyCode:uint, bounds:LayoutBoundsResult):int
		{
			var itemArrayCount:int = items.length;
			var itemCount:int = itemArrayCount + this._beforeVirtualizedItemCount + this._afterVirtualizedItemCount;

			var result:int = index;
			if(keyCode === Keyboard.HOME)
			{
				if(itemCount > 0)
				{
					result = 0;
				}
			}
			else if(keyCode === Keyboard.END)
			{
				result = itemCount - 1;
			}
			else if(keyCode === Keyboard.PAGE_UP ||
				(this._direction === Direction.VERTICAL && keyCode === Keyboard.UP) ||
				(this._direction === Direction.HORIZONTAL && keyCode === Keyboard.LEFT))
			{
				result--;
			}
			else if(keyCode === Keyboard.PAGE_DOWN ||
				(this._direction === Direction.VERTICAL && keyCode === Keyboard.DOWN) ||
				(this._direction === Direction.HORIZONTAL && keyCode === Keyboard.RIGHT))
			{
				result++;
			}
			if(result < 0)
			{
				result = 0;
			}
			if(result >= itemCount)
			{
				result = itemCount - 1;
			}
			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function getScrollPositionForIndex(index:int, items:Vector.<DisplayObject>, x:Number, y:Number, width:Number, height:Number, result:Point = null):Point
		{
			if(result === null)
			{
				result = new Point();
			}
			if(this._direction === Direction.VERTICAL)
			{
				result.x = 0;
				result.y = height * index;
			}
			else //horizontal
			{
				result.x = width * index;
				result.y = 0;
			}

			return result;
		}

		/**
		 * @private
		 */
		protected function validateItems(items:Vector.<DisplayObject>,
			explicitWidth:Number, explicitHeight:Number):void
		{
			//if the alignment is justified, then we want to set the width of
			//each item before validating because setting one dimension may
			//cause the other dimension to change, and that will invalidate the
			//layout if it happens after validation, causing more invalidation
			var itemCount:int = items.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:DisplayObject = items[i];
				if(!item || (item is ILayoutDisplayObject && !ILayoutDisplayObject(item).includeInLayout))
				{
					continue;
				}
				if(this._horizontalAlign === HorizontalAlign.JUSTIFY)
				{
					//the alignment is justified, but we don't yet have a width
					//to use, so we need to ensure that we accurately measure
					//the items instead of using an old justified width that may
					//be wrong now!
					item.width = explicitWidth;
				}
				if(this._verticalAlign === VerticalAlign.JUSTIFY)
				{
					item.height = explicitHeight;
				}
				if(item is IValidating)
				{
					IValidating(item).validate();
				}
			}
		}

		/**
		 * @private
		 */
		protected function prepareTypicalItem(justifyWidth:Number, justifyHeight:Number):void
		{
			if(!this._typicalItem)
			{
				return;
			}
			if(this._horizontalAlign === HorizontalAlign.JUSTIFY &&
				justifyWidth === justifyWidth) //!isNaN
			{
				this._typicalItem.width = justifyWidth;
			}
			if(this._verticalAlign === VerticalAlign.JUSTIFY &&
				justifyHeight === justifyHeight) //!isNaN
			{
				this._typicalItem.height = justifyHeight;
			}
			if(this._typicalItem is IValidating)
			{
				IValidating(this._typicalItem).validate();
			}
		}
	}
}
