/*
Feathers
Copyright 2012-2015 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.layout
{
	import feathers.core.IValidating;

	import flash.errors.IllegalOperationError;

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
	 * A layout with multiple columns of equal width where items may have
	 * variable heights. Items are added to the layout in order, but they may be
	 * added to any of the available columns. The layout selects the column
	 * where the column's height plus the item's height will result in the
	 * smallest possible total height.
	 *
	 * @see ../../../help/waterfall-layout.html How to use WaterfallLayout with Feathers containers
	 */
	public class WaterfallLayout extends EventDispatcher implements IVariableVirtualLayout
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

		[Bindable(event="change")]
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

		[Bindable(event="change")]
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

		[Bindable(event="change")]
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

		[Bindable(event="change")]
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

		[Bindable(event="change")]
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

		[Bindable(event="change")]
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

		[Bindable(event="change")]
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

		[Bindable(event="change")]
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

		[Bindable(event="change")]
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

		[Bindable(event="change")]
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
		 * @private
		 */
		protected var _useVirtualLayout:Boolean = true;

		[Bindable(event="change")]
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
			if(this._useVirtualLayout == value)
			{
				return;
			}
			this._useVirtualLayout = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _typicalItem:DisplayObject;

		[Bindable(event="change")]
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
			if(this._typicalItem == value)
			{
				return;
			}
			this._typicalItem = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _hasVariableItemDimensions:Boolean = true;

		[Bindable(event="change")]
		/**
		 * When the layout is virtualized, and this value is true, the items may
		 * have variable height values. If false, the items will all share the
		 * same height value with the typical item.
		 *
		 * @default true
		 */
		public function get hasVariableItemDimensions():Boolean
		{
			return this._hasVariableItemDimensions;
		}

		/**
		 * @private
		 */
		public function set hasVariableItemDimensions(value:Boolean):void
		{
			if(this._hasVariableItemDimensions == value)
			{
				return;
			}
			this._hasVariableItemDimensions = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		[Bindable(event="change")]
		/**
		 * @inheritDoc
		 */
		public function get requiresLayoutOnScroll():Boolean
		{
			return this._useVirtualLayout;
		}

		/**
		 * @private
		 */
		protected var _heightCache:Array = [];

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

			if(this._useVirtualLayout)
			{
				//if the layout is virtualized, we'll need the dimensions of the
				//typical item so that we have fallback values when an item is null
				if(this._typicalItem is IValidating)
				{
					IValidating(this._typicalItem).validate();
				}
				var calculatedTypicalItemWidth:Number = this._typicalItem ? this._typicalItem.width : 0;
				var calculatedTypicalItemHeight:Number = this._typicalItem ? this._typicalItem.height : 0;
			}

			var columnWidth:Number = 0;
			if(this._useVirtualLayout)
			{
				columnWidth = calculatedTypicalItemWidth;
			}
			else if(items.length > 0)
			{
				var item:DisplayObject = items[0];
				if(item is IValidating)
				{
					IValidating(item).validate();
				}
				columnWidth = item.width;
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
				item = items[i];
				if(this._useVirtualLayout && this._hasVariableItemDimensions)
				{
					var cachedHeight:Number = this._heightCache[i];
				}
				if(this._useVirtualLayout && !item)
				{
					if(!this._hasVariableItemDimensions ||
						cachedHeight !== cachedHeight) //isNaN
					{
						//if all items must have the same height, we will
						//use the height of the typical item (calculatedTypicalItemHeight).

						//if items may have different heights, we first check
						//the cache for a height value. if there isn't one, then
						//we'll use calculatedTypicalItemHeight as a fallback.
						var itemHeight:Number = calculatedTypicalItemHeight;
					}
					else
					{
						itemHeight = cachedHeight;
					}
				}
				else
				{
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
					//first, scale the items to fit into the column width
					var scaleFactor:Number = columnWidth / item.width;
					item.width *= scaleFactor;
					if(item is IValidating)
					{
						//if we changed the width, we need to recalculate the
						//height.
						IValidating(item).validate();
					}
					if(this._useVirtualLayout)
					{
						if(this._hasVariableItemDimensions)
						{
							itemHeight = item.height;
							if(itemHeight != cachedHeight)
							{
								//update the cache if needed. this will notify
								//the container that the virtualized layout has
								//changed, and it the view port may need to be
								//re-measured.
								this._heightCache[i] = itemHeight;
								this.dispatchEventWith(Event.CHANGE);
							}
						}
						else
						{
							item.height = itemHeight = calculatedTypicalItemHeight;
						}
					}
					else
					{
						itemHeight = item.height;
					}
				}
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
				if(item)
				{
					item.x = item.pivotX + boundsX + horizontalAlignOffset + this._paddingLeft + targetColumnIndex * (columnWidth + this._horizontalGap);
					item.y = item.pivotY + boundsY + targetColumnHeight - itemHeight;
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

			if(this._typicalItem is IValidating)
			{
				IValidating(this._typicalItem).validate();
			}
			var calculatedTypicalItemWidth:Number = this._typicalItem ? this._typicalItem.width : 0;
			var calculatedTypicalItemHeight:Number = this._typicalItem ? this._typicalItem.height : 0;

			var columnWidth:Number = calculatedTypicalItemWidth;
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

			if(needsWidth)
			{
				result.x = this._paddingLeft + this._paddingRight + (columnCount * (columnWidth + this._horizontalGap)) - this._horizontalGap;
			}
			else
			{
				result.x = explicitWidth;
			}

			if(needsHeight)
			{
				if(this._hasVariableItemDimensions)
				{
					var columnHeights:Vector.<Number> = new <Number>[];
					for(var i:int = 0; i < columnCount; i++)
					{
						columnHeights[i] = this._paddingTop;
					}
					columnHeights.fixed = true;

					var targetColumnIndex:int = 0;
					var targetColumnHeight:Number = columnHeights[targetColumnIndex];
					for(i = 0; i < itemCount; i++)
					{
						if(this._hasVariableItemDimensions)
						{
							var itemHeight:Number = this._heightCache[i];
							if(itemHeight !== itemHeight) //isNaN
							{
								itemHeight = calculatedTypicalItemHeight;
							}
						}
						else
						{
							itemHeight = calculatedTypicalItemHeight;
						}
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
					if(totalHeight < minHeight)
					{
						totalHeight = minHeight;
					}
					else if(totalHeight > maxHeight)
					{
						totalHeight = maxHeight;
					}
					result.y = totalHeight;
				}
				else
				{
					result.y = this._paddingTop + this._paddingBottom + (Math.ceil(itemCount / columnCount) * (calculatedTypicalItemHeight + this._verticalGap)) - this._verticalGap;
				}
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
			if(result)
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

			if(this._typicalItem is IValidating)
			{
				IValidating(this._typicalItem).validate();
			}
			var calculatedTypicalItemWidth:Number = this._typicalItem ? this._typicalItem.width : 0;
			var calculatedTypicalItemHeight:Number = this._typicalItem ? this._typicalItem.height : 0;

			var columnWidth:Number = calculatedTypicalItemWidth;
			var columnCount:int = int((width + this._horizontalGap - this._paddingLeft - this._paddingRight) / (columnWidth + this._horizontalGap));
			if(this._requestedColumnCount > 0 && columnCount > this._requestedColumnCount)
			{
				columnCount = this._requestedColumnCount;
			}
			else if(columnCount < 1)
			{
				columnCount = 1;
			}
			var resultLastIndex:int = 0;
			if(this._hasVariableItemDimensions)
			{
				var columnHeights:Vector.<Number> = new <Number>[];
				for(var i:int = 0; i < columnCount; i++)
				{
					columnHeights[i] = this._paddingTop;
				}
				columnHeights.fixed = true;

				var maxPositionY:Number = scrollY + height;
				var targetColumnIndex:int = 0;
				var targetColumnHeight:Number = columnHeights[targetColumnIndex];
				for(i = 0; i < itemCount; i++)
				{
					if(this._hasVariableItemDimensions)
					{
						var itemHeight:Number = this._heightCache[i];
						if(itemHeight !== itemHeight) //isNaN
						{
							itemHeight = calculatedTypicalItemHeight;
						}
					}
					else
					{
						itemHeight = calculatedTypicalItemHeight;
					}
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
					if(targetColumnHeight > scrollY && (targetColumnHeight - itemHeight) < maxPositionY)
					{
						result[resultLastIndex] = i;
						resultLastIndex++;
					}
					targetColumnHeight += this._verticalGap;
					columnHeights[targetColumnIndex] = targetColumnHeight;
				}
				return result;
			}
			//this case can be optimized because we know that every item has
			//the same height

			//we add one extra here because the first item renderer in view may
			//be partially obscured, which would reveal an extra item renderer.
			var maxVisibleTypicalItemCount:int = Math.ceil(height / (calculatedTypicalItemHeight + this._verticalGap)) + 1;
			//we're calculating the minimum and maximum rows
			var minimum:int = (scrollY - this._paddingTop) / (calculatedTypicalItemHeight + this._verticalGap);
			if(minimum < 0)
			{
				minimum = 0;
			}
			//if we're scrolling beyond the final item, we should keep the
			//indices consistent so that items aren't destroyed and
			//recreated unnecessarily
			var maximum:int = minimum + maxVisibleTypicalItemCount;
			if(maximum >= itemCount)
			{
				maximum = itemCount - 1;
			}
			minimum = maximum - maxVisibleTypicalItemCount;
			if(minimum < 0)
			{
				minimum = 0;
			}
			for(i = minimum; i <= maximum; i++)
			{
				for(j = 0; j < columnCount; j++)
				{
					var index:int = (i * columnCount) + j;
					if(index >= 0 && i < itemCount)
					{
						result[resultLastIndex] = index;
					}
					else if(index < 0)
					{
						result[resultLastIndex] = itemCount + index;
					}
					else if(index >= itemCount)
					{
						result[resultLastIndex] = index - itemCount;
					}
					resultLastIndex++;
				}
			}
			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function resetVariableVirtualCache():void
		{
			this._heightCache.length = 0;
		}

		/**
		 * @inheritDoc
		 */
		public function resetVariableVirtualCacheAtIndex(index:int, item:DisplayObject = null):void
		{
			delete this._heightCache[index];
			if(item)
			{
				this._heightCache[index] = item.height;
				this.dispatchEventWith(Event.CHANGE);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function addToVariableVirtualCacheAtIndex(index:int, item:DisplayObject = null):void
		{
			var heightValue:* = item ? item.height : undefined;
			this._heightCache.splice(index, 0, heightValue);
		}

		/**
		 * @inheritDoc
		 */
		public function removeFromVariableVirtualCacheAtIndex(index:int):void
		{
			this._heightCache.splice(index, 1);
		}

		/**
		 * @inheritDoc
		 */
		public function getNearestScrollPositionForIndex(index:int, scrollX:Number, scrollY:Number, items:Vector.<DisplayObject>, x:Number, y:Number, width:Number, height:Number, result:Point = null):Point
		{
			var maxScrollY:Number = this.calculateMaxScrollYOfIndex(index, items, x, y, width, height);

			if(this._useVirtualLayout)
			{
				if(this._hasVariableItemDimensions)
				{
					var itemHeight:Number = this._heightCache[index];
					if(itemHeight !== itemHeight) //isNaN
					{
						itemHeight = this._typicalItem.height;
					}
				}
				else
				{
					itemHeight = this._typicalItem.height;
				}
			}
			else
			{
				itemHeight = items[index].height;
			}

			if(!result)
			{
				result = new Point();
			}
			result.x = 0;

			var bottomPosition:Number = maxScrollY - (height - itemHeight);
			if(scrollY >= bottomPosition && scrollY <= maxScrollY)
			{
				//keep the current scroll position because the item is already
				//fully visible
				result.y = scrollY;
			}
			else
			{
				var topDifference:Number = Math.abs(maxScrollY - scrollY);
				var bottomDifference:Number = Math.abs(bottomPosition - scrollY);
				if(bottomDifference < topDifference)
				{
					result.y = bottomPosition;
				}
				else
				{
					result.y = maxScrollY;
				}
			}

			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function getScrollPositionForIndex(index:int, items:Vector.<DisplayObject>, x:Number, y:Number, width:Number, height:Number, result:Point = null):Point
		{
			var maxScrollY:Number = this.calculateMaxScrollYOfIndex(index, items, x, y, width, height);

			if(this._useVirtualLayout)
			{
				if(this._hasVariableItemDimensions)
				{
					var itemHeight:Number = this._heightCache[index];
					if(itemHeight !== itemHeight) //isNaN
					{
						itemHeight = this._typicalItem.height;
					}
				}
				else
				{
					itemHeight = this._typicalItem.height;
				}
			}
			else
			{
				itemHeight = items[index].height;
			}

			if(!result)
			{
				result = new Point();
			}
			result.x = 0;
			result.y = maxScrollY - Math.round((height - itemHeight) / 2);
			return result;
		}

		/**
		 * @private
		 */
		protected function calculateMaxScrollYOfIndex(index:int, items:Vector.<DisplayObject>, x:Number, y:Number, width:Number, height:Number):Number
		{
			if(items.length == 0)
			{
				return 0;
			}

			if(this._useVirtualLayout)
			{
				//if the layout is virtualized, we'll need the dimensions of the
				//typical item so that we have fallback values when an item is null
				if(this._typicalItem is IValidating)
				{
					IValidating(this._typicalItem).validate();
				}
				var calculatedTypicalItemWidth:Number = this._typicalItem ? this._typicalItem.width : 0;
				var calculatedTypicalItemHeight:Number = this._typicalItem ? this._typicalItem.height : 0;
			}

			var columnWidth:Number = 0;
			if(this._useVirtualLayout)
			{
				columnWidth = calculatedTypicalItemWidth;
			}
			else if(items.length > 0)
			{
				var item:DisplayObject = items[0];
				if(item is IValidating)
				{
					IValidating(item).validate()
				}
				columnWidth = item.width;
			}

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
				item = items[i];
				if(this._useVirtualLayout && this._hasVariableItemDimensions)
				{
					var cachedHeight:Number = this._heightCache[i];
				}
				if(this._useVirtualLayout && !item)
				{
					if(!this._hasVariableItemDimensions ||
						cachedHeight !== cachedHeight) //isNaN
					{
						//if all items must have the same height, we will
						//use the height of the typical item (calculatedTypicalItemHeight).

						//if items may have different heights, we first check
						//the cache for a height value. if there isn't one, then
						//we'll use calculatedTypicalItemHeight as a fallback.
						var itemHeight:Number = calculatedTypicalItemHeight;
					}
					else
					{
						itemHeight = cachedHeight;
					}
				}
				else
				{
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
					//first, scale the items to fit into the column width
					var scaleFactor:Number = columnWidth / item.width;
					item.width *= scaleFactor;
					if(item is IValidating)
					{
						IValidating(item).validate();
					}
					if(this._useVirtualLayout)
					{
						if(this._hasVariableItemDimensions)
						{
							itemHeight = item.height;
							if(itemHeight != cachedHeight)
							{
								this._heightCache[i] = itemHeight;
								this.dispatchEventWith(Event.CHANGE);
							}
						}
						else
						{
							item.height = itemHeight = calculatedTypicalItemHeight;
						}
					}
					else
					{
						itemHeight = item.height;
					}
				}
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
					return targetColumnHeight - itemHeight;
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
			return totalHeight;
		}
	}
}
