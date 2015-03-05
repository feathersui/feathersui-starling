/*
Feathers
Copyright 2012-2015 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.layout
{
	import feathers.core.IValidating;

	import flash.geom.Point;

	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.EventDispatcher;

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
	 * A layout that optimally positions items in multiple columns of equal
	 * width.
	 *
	 * @see ../../../help/waterfall-layout.html How to use WaterfallLayout with Feathers containers
	 */
	public class WaterfallLayout extends EventDispatcher implements ILayout
	{
		/**
		 * The items will be aligned to the left of the bounds.
		 *
		 * @see #horizontalAlign
		 */
		public static const HORIZONTAL_ALIGN_LEFT:String = "left";

		/**
		 * The items will be aligned to the center of the bounds.
		 *
		 * @see #horizontalAlign
		 */
		public static const HORIZONTAL_ALIGN_CENTER:String = "center";

		/**
		 * The items will be aligned to the right of the bounds.
		 *
		 * @see #horizontalAlign
		 */
		public static const HORIZONTAL_ALIGN_RIGHT:String = "right";
		
		/**
		 * Constructor.
		 */
		public function WaterfallLayout()
		{
		}

		/**
		 * Quickly sets both <code>horizontalGap</code> and <code>verticalGap</code>
		 * to the same value. The <code>gap</code> getter always returns the
		 * value of <code>horizontalGap</code>, but the value of
		 * <code>verticalGap</code> may be different.
		 *
		 * @default 0
		 *
		 * @see #horizontalGap
		 * @see #verticalGap
		 */
		public function get gap():Number
		{
			return this._horizontalGap;
		}

		/**
		 * @private
		 */
		public function set gap(value:Number):void
		{
			this.horizontalGap = value;
			this.verticalGap = value;
		}

		/**
		 * @private
		 */
		protected var _horizontalGap:Number = 0;

		/**
		 * The horizontal space, in pixels, between columns.
		 *
		 * @default 0
		 */
		public function get horizontalGap():Number
		{
			return this._horizontalGap;
		}

		/**
		 * @private
		 */
		public function set horizontalGap(value:Number):void
		{
			if(this._horizontalGap == value)
			{
				return;
			}
			this._horizontalGap = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _verticalGap:Number = 0;

		/**
		 * The vertical space, in pixels, between items in a column.
		 *
		 * @default 0
		 */
		public function get verticalGap():Number
		{
			return this._verticalGap;
		}

		/**
		 * @private
		 */
		public function set verticalGap(value:Number):void
		{
			if(this._verticalGap == value)
			{
				return;
			}
			this._verticalGap = value;
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
		 * The space, in pixels, that appears on top, above the items.
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
			if(this._paddingTop == value)
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
		 * The minimum space, in pixels, to the right of the items.
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
			if(this._paddingRight == value)
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
		 * The space, in pixels, that appears on the bottom, below the items.
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
			if(this._paddingBottom == value)
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
		 * The minimum space, in pixels, to the left of the items.
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
			if(this._paddingLeft == value)
			{
				return;
			}
			this._paddingLeft = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _horizontalAlign:String = HORIZONTAL_ALIGN_CENTER;

		[Inspectable(type="String",enumeration="left,center,right")]
		/**
		 * The alignment of the items horizontally, on the x-axis.
		 *
		 * @default WaterfallLayout.HORIZONTAL_ALIGN_CENTER
		 *
		 * @see #HORIZONTAL_ALIGN_LEFT
		 * @see #HORIZONTAL_ALIGN_CENTER
		 * @see #HORIZONTAL_ALIGN_RIGHT
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
			if(this._horizontalAlign == value)
			{
				return;
			}
			this._horizontalAlign = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _requestedColumnCount:int = 0;

		/**
		 * Requests that the layout uses a specific number of columns, if
		 * possible. Set to <code>0</code> to calculate the maximum of columns
		 * that will fit in the available space.
		 * 
		 * <p>If the view port's explicit or maximum width is not large enough
		 * to fit the requested number of columns, it will use fewer. If the
		 * view port doesn't have an explicit width and the maximum width is
		 * equal to <code>Number.POSITIVE_INFINITY</code>, the width will be
		 * calculated automatically to fit the exact number of requested
		 * columns.</p>
		 *
		 * @default 0
		 */
		public function get requestedColumnCount():int
		{
			return this._requestedColumnCount;
		}

		/**
		 * @private
		 */
		public function set requestedColumnCount(value:int):void
		{
			if(value < 0)
			{
				throw RangeError("requestedColumnCount requires a value >= 0");
			}
			if(this._requestedColumnCount == value)
			{
				return;
			}
			this._requestedColumnCount = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @inheritDoc
		 */
		public function get requiresLayoutOnScroll():Boolean
		{
			return false;
		}

		/**
		 * @inheritDoc
		 */
		public function layout(items:Vector.<DisplayObject>, viewPortBounds:ViewPortBounds = null, result:LayoutBoundsResult = null):LayoutBoundsResult
		{
			var boundsX:Number = viewPortBounds ? viewPortBounds.x : 0;
			var boundsY:Number = viewPortBounds ? viewPortBounds.y : 0;
			var minWidth:Number = viewPortBounds ? viewPortBounds.minWidth : 0;
			var minHeight:Number = viewPortBounds ? viewPortBounds.minHeight : 0;
			var maxWidth:Number = viewPortBounds ? viewPortBounds.maxWidth : Number.POSITIVE_INFINITY;
			var maxHeight:Number = viewPortBounds ? viewPortBounds.maxHeight : Number.POSITIVE_INFINITY;
			var explicitWidth:Number = viewPortBounds ? viewPortBounds.explicitWidth : NaN;
			var explicitHeight:Number = viewPortBounds ? viewPortBounds.explicitHeight : NaN;
			
			var needsWidth:Boolean = explicitWidth !== explicitWidth; //isNaN
			var needsHeight:Boolean = explicitHeight !== explicitHeight; //isNaN
			
			//in some cases, we may need to validate all of the items so
			//that we can use their dimensions below.
			this.validateItems(items);
				
			var columnWidth:Number = 0;
			if(items.length > 0)
			{
				columnWidth = items[0].width;
			}
			var availableWidth:Number = explicitWidth;
			if(needsWidth)
			{
				if(maxWidth < Number.POSITIVE_INFINITY)
				{
					availableWidth = maxWidth;
				}
				else if(this._requestedColumnCount > 0)
				{
					availableWidth = ((columnWidth + this._horizontalGap) * this._requestedColumnCount) - this._horizontalGap;
				}
				else
				{
					availableWidth = columnWidth;
				}
				availableWidth += this._paddingLeft + this._paddingRight;
				if(availableWidth < minWidth)
				{
					availableWidth = minWidth;
				}
				else if(availableWidth > maxWidth)
				{
					availableWidth = maxWidth;
				}
			}
			var columnCount:int = int((availableWidth + this._horizontalGap - this._paddingLeft - this._paddingRight) / (columnWidth + this._horizontalGap));
			if(this._requestedColumnCount > 0 && columnCount > this._requestedColumnCount)
			{
				columnCount = this._requestedColumnCount;
			}
			else if(columnCount < 1)
			{
				columnCount = 1;
			}
			var columnHeights:Vector.<Number> = new <Number>[];
			for(var i:int = 0; i < columnCount; i++)
			{
				columnHeights[i] = this._paddingTop;
			}
			columnHeights.fixed = true;
			
			var horizontalAlignOffset:Number = 0;
			if(this._horizontalAlign == HORIZONTAL_ALIGN_RIGHT)
			{
				horizontalAlignOffset = (availableWidth - this._paddingLeft - this._paddingRight) - ((columnCount * (columnWidth + this._horizontalGap)) - this._horizontalGap);
			}
			else if(this._horizontalAlign == HORIZONTAL_ALIGN_CENTER)
			{
				horizontalAlignOffset = Math.round(((availableWidth - this._paddingLeft - this._paddingRight) - ((columnCount * (columnWidth + this._horizontalGap)) - this._horizontalGap)) / 2);
			}
			
			var itemCount:int = items.length;
			var targetColumnIndex:int = 0;
			var targetColumnHeight:Number = columnHeights[targetColumnIndex];
			for(i = 0; i < itemCount; i++)
			{
				var item:DisplayObject = items[i];
				//first, scale the items to fit into the column width
				var scaleFactor:Number = columnWidth / item.width;
				item.width *= scaleFactor;
				if(item is ILayoutDisplayObject)
				{
					var layoutItem:ILayoutDisplayObject = ILayoutDisplayObject(item);
					if(!layoutItem.includeInLayout)
					{
						continue;
					}
				}
				if(item is IValidating)
				{
					IValidating(item).validate();
				}
				var itemHeight:Number = item.height;
				targetColumnHeight += itemHeight;
				for(var j:int = 0; j < columnCount; j++)
				{
					if(j === targetColumnIndex)
					{
						continue;
					}
					var columnHeight:Number = columnHeights[j] + itemHeight;
					if(columnHeight < targetColumnHeight)
					{
						targetColumnIndex = j;
						targetColumnHeight = columnHeight;
					}
				}
				item.x = horizontalAlignOffset + this._paddingLeft + targetColumnIndex * (columnWidth + this._horizontalGap);
				item.y = targetColumnHeight - itemHeight;
				targetColumnHeight += this._verticalGap;
				columnHeights[targetColumnIndex] = targetColumnHeight;
			}
			var totalHeight:Number = columnHeights[0];
			for(i = 1; i < columnCount; i++)
			{
				columnHeight = columnHeights[i];
				if(columnHeight > totalHeight)
				{
					totalHeight = columnHeight;
				}
			}
			totalHeight -= this._verticalGap;
			totalHeight += this._paddingBottom;
			if(totalHeight < 0)
			{
				totalHeight = 0;
			}

			var availableHeight:Number = explicitHeight;
			if(needsHeight)
			{
				availableHeight = totalHeight;
				if(availableHeight < minHeight)
				{
					availableHeight = minHeight;
				}
				else if(availableHeight > maxHeight)
				{
					availableHeight = maxHeight;
				}
			}

			//finally, we want to calculate the result so that the container
			//can use it to adjust its viewport and determine the minimum and
			//maximum scroll positions (if needed)
			if(!result)
			{
				result = new LayoutBoundsResult();
			}
			result.contentX = 0;
			result.contentWidth = availableWidth;
			result.contentY = 0;
			result.contentHeight = totalHeight;
			result.viewPortWidth = availableWidth;
			result.viewPortHeight = availableHeight;
			return result;
			
		}

		/**
		 * @inheritDoc
		 */
		public function getNearestScrollPositionForIndex(index:int, scrollX:Number, scrollY:Number, items:Vector.<DisplayObject>, x:Number, y:Number, width:Number, height:Number, result:Point = null):Point
		{
			return this.getScrollPositionForIndex(index, items, x, y, width, height, result);
		}

		/**
		 * @inheritDoc
		 */
		public function getScrollPositionForIndex(index:int, items:Vector.<DisplayObject>, x:Number, y:Number, width:Number, height:Number, result:Point = null):Point
		{
			if(items.length == 0)
			{
				if(!result)
				{
					result = new Point();
				}
				result.setTo(0, 0);
				return result;
			}

			//all items will be the same width, calculated in layout()
			var columnWidth:Number = items[0].width;
			var columnCount:int = int((width + this._horizontalGap - this._paddingLeft - this._paddingRight) / (columnWidth + this._horizontalGap));
			if(this._requestedColumnCount > 0 && columnCount > this._requestedColumnCount)
			{
				columnCount = this._requestedColumnCount;
			}
			else if(columnCount < 1)
			{
				columnCount = 1;
			}
			var columnHeights:Vector.<Number> = new <Number>[];
			for(var i:int = 0; i < columnCount; i++)
			{
				columnHeights[i] = this._paddingTop;
			}
			columnHeights.fixed = true;

			var itemCount:int = items.length;
			var targetColumnIndex:int = 0;
			var targetColumnHeight:Number = columnHeights[targetColumnIndex];
			for(i = 0; i < itemCount; i++)
			{
				var item:DisplayObject = items[i];
				if(item is ILayoutDisplayObject)
				{
					var layoutItem:ILayoutDisplayObject = ILayoutDisplayObject(item);
					if(!layoutItem.includeInLayout)
					{
						continue;
					}
				}
				var itemHeight:Number = item.height;
				targetColumnHeight += itemHeight;
				for(var j:int = 0; j < columnCount; j++)
				{
					if(j === targetColumnIndex)
					{
						continue;
					}
					var columnHeight:Number = columnHeights[j] + itemHeight;
					if(columnHeight < targetColumnHeight)
					{
						targetColumnIndex = j;
						targetColumnHeight = columnHeight;
					}
				}
				if(i === index)
				{
					result.x = 0;
					result.y = targetColumnHeight - itemHeight;
					return result;
				}
				targetColumnHeight += this._verticalGap;
				columnHeights[targetColumnIndex] = targetColumnHeight;
			}
			var totalHeight:Number = columnHeights[0];
			for(i = 1; i < columnCount; i++)
			{
				columnHeight = columnHeights[i];
				if(columnHeight > totalHeight)
				{
					totalHeight = columnHeight;
				}
			}
			totalHeight -= this._verticalGap;
			totalHeight += this._paddingBottom;
			//subtracting the height gives us the maximum scroll position
			totalHeight -= height;
			if(totalHeight < 0)
			{
				totalHeight = 0;
			}
			result.x = 0;
			result.y = totalHeight;
			return result;
		}

		/**
		 * @private
		 */
		protected function validateItems(items:Vector.<DisplayObject>):void
		{
			var itemCount:int = items.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:DisplayObject = items[i];
				if(!item || (item is ILayoutDisplayObject && !ILayoutDisplayObject(item).includeInLayout))
				{
					continue;
				}
				if(item is IValidating)
				{
					IValidating(item).validate()
				}
			}
		}
	}
}
