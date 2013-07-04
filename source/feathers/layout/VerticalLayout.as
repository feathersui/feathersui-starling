/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.layout
{
	import feathers.core.IFeathersControl;

	import flash.geom.Point;

	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.EventDispatcher;

	/**
	 * Dispatched when a property of the layout changes, indicating that a
	 * redraw is probably needed.
	 *
	 * @eventType starling.events.Event.CHANGE
	 */
	[Event(name="change",type="starling.events.Event")]

	/**
	 * Positions items from top to bottom in a single column.
	 *
	 * @see http://wiki.starling-framework.org/feathers/vertical-layout
	 */
	public class VerticalLayout extends EventDispatcher implements IVariableVirtualLayout, ITrimmedVirtualLayout
	{
		/**
		 * If the total item height is smaller than the height of the bounds,
		 * the items will be aligned to the top.
		 *
		 * @see #verticalAlign
		 */
		public static const VERTICAL_ALIGN_TOP:String = "top";

		/**
		 * If the total item height is smaller than the height of the bounds,
		 * the items will be aligned to the middle.
		 *
		 * @see #verticalAlign
		 */
		public static const VERTICAL_ALIGN_MIDDLE:String = "middle";

		/**
		 * If the total item height is smaller than the height of the bounds,
		 * the items will be aligned to the bottom.
		 *
		 * @see #verticalAlign
		 */
		public static const VERTICAL_ALIGN_BOTTOM:String = "bottom";

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
		 * The items will fill the width of the bounds.
		 *
		 * @see #horizontalAlign
		 */
		public static const HORIZONTAL_ALIGN_JUSTIFY:String = "justify";

		/**
		 * Constructor.
		 */
		public function VerticalLayout()
		{
		}

		/**
		 * @private
		 */
		protected var _heightCache:Array = [];

		/**
		 * @private
		 */
		protected var _discoveredItemsCache:Vector.<DisplayObject> = new <DisplayObject>[];

		/**
		 * @private
		 */
		protected var _gap:Number = 0;

		/**
		 * The space, in pixels, between items.
		 *
		 * @default 0
		 */
		public function get gap():Number
		{
			return this._gap;
		}

		/**
		 * @private
		 */
		public function set gap(value:Number):void
		{
			if(this._gap == value)
			{
				return;
			}
			this._gap = value;
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
		 * The space, in pixels, that appears on top, before the first item.
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
		 * The space, in pixels, that appears on the bottom, after the last
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
		protected var _verticalAlign:String = VERTICAL_ALIGN_TOP;

		[Inspectable(type="String",enumeration="top,middle,bottom")]
		/**
		 * If the total item height is less than the bounds, the positions of
		 * the items can be aligned vertically.
		 *
		 * @default VerticalLayout.VERTICAL_ALIGN_TOP
		 *
		 * @see #VERTICAL_ALIGN_TOP
		 * @see #VERTICAL_ALIGN_MIDDLE
		 * @see #VERTICAL_ALIGN_BOTTOM
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
			if(this._verticalAlign == value)
			{
				return;
			}
			this._verticalAlign = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _horizontalAlign:String = HORIZONTAL_ALIGN_LEFT;

		[Inspectable(type="String",enumeration="left,center,right,justify")]
		/**
		 * The alignment of the items horizontally, on the x-axis.
		 *
		 * @default VerticalLayout.HORIZONTAL_ALIGN_LEFT
		 *
		 * @see #HORIZONTAL_ALIGN_LEFT
		 * @see #HORIZONTAL_ALIGN_CENTER
		 * @see #HORIZONTAL_ALIGN_RIGHT
		 * @see #HORIZONTAL_ALIGN_JUSTIFY
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
		protected var _hasVariableItemDimensions:Boolean = false;

		/**
		 * When the layout is virtualized, and this value is true, the items may
		 * have variable width values. If false, the items will all share the
		 * same width value with the typical item.
		 *
		 * @default false
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

		/**
		 * Determines if items will be set invisible if they are outside the
		 * view port. Can improve performance, especially for non-virtual
		 * layouts. If <code>true</code>, you will not be able to manually
		 * change the <code>visible</code> property of any items in the layout.
		 *
		 * @default false
		 */
		public var manageVisibility:Boolean = false;

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
			if(this._beforeVirtualizedItemCount == value)
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
			if(this._afterVirtualizedItemCount == value)
			{
				return;
			}
			this._afterVirtualizedItemCount = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _typicalItemWidth:Number = -1;

		/**
		 * @inheritDoc
		 */
		public function get typicalItemWidth():Number
		{
			return this._typicalItemWidth;
		}

		/**
		 * @private
		 */
		public function set typicalItemWidth(value:Number):void
		{
			if(this._typicalItemWidth == value)
			{
				return;
			}
			this._typicalItemWidth = value;
		}

		/**
		 * @private
		 */
		protected var _typicalItemHeight:Number = -1;

		/**
		 * @inheritDoc
		 */
		public function get typicalItemHeight():Number
		{
			return this._typicalItemHeight;
		}

		/**
		 * @private
		 */
		public function set typicalItemHeight(value:Number):void
		{
			if(this._typicalItemHeight == value)
			{
				return;
			}
			this._typicalItemHeight = value;
		}

		/**
		 * @private
		 */
		protected var _scrollPositionVerticalAlign:String = VERTICAL_ALIGN_MIDDLE;

		[Inspectable(type="String",enumeration="top,middle,bottom")]
		/**
		 * When the scroll position is calculated for an item, an attempt will
		 * be made to align the item to this position.
		 *
		 * @default VerticalLayout.VERTICAL_ALIGN_MIDDLE
		 *
		 * @see #VERTICAL_ALIGN_TOP
		 * @see #VERTICAL_ALIGN_MIDDLE
		 * @see #VERTICAL_ALIGN_BOTTOM
		 */
		public function get scrollPositionVerticalAlign():String
		{
			return this._scrollPositionVerticalAlign;
		}

		/**
		 * @private
		 */
		public function set scrollPositionVerticalAlign(value:String):void
		{
			this._scrollPositionVerticalAlign = value;
		}

		/**
		 * @inheritDoc
		 */
		public function layout(items:Vector.<DisplayObject>, viewPortBounds:ViewPortBounds = null, result:LayoutBoundsResult = null):LayoutBoundsResult
		{
			const scrollX:Number = viewPortBounds ? viewPortBounds.scrollX : 0;
			const scrollY:Number = viewPortBounds ? viewPortBounds.scrollY : 0;
			const boundsX:Number = viewPortBounds ? viewPortBounds.x : 0;
			const boundsY:Number = viewPortBounds ? viewPortBounds.y : 0;
			const minWidth:Number = viewPortBounds ? viewPortBounds.minWidth : 0;
			const minHeight:Number = viewPortBounds ? viewPortBounds.minHeight : 0;
			const maxWidth:Number = viewPortBounds ? viewPortBounds.maxWidth : Number.POSITIVE_INFINITY;
			const maxHeight:Number = viewPortBounds ? viewPortBounds.maxHeight : Number.POSITIVE_INFINITY;
			const explicitWidth:Number = viewPortBounds ? viewPortBounds.explicitWidth : NaN;
			const explicitHeight:Number = viewPortBounds ? viewPortBounds.explicitHeight : NaN;

			if(!this._useVirtualLayout || this._hasVariableItemDimensions ||
				this._horizontalAlign != HORIZONTAL_ALIGN_JUSTIFY || isNaN(explicitWidth))
			{
				this.validateItems(items);
			}

			this._discoveredItemsCache.length = 0;
			var maxItemWidth:Number = this._useVirtualLayout ? this._typicalItemWidth : 0;
			var positionY:Number = boundsY + this._paddingTop;
			var indexOffset:int = 0;
			if(this._useVirtualLayout && !this._hasVariableItemDimensions)
			{
				indexOffset = this._beforeVirtualizedItemCount;
				positionY += (this._beforeVirtualizedItemCount * (this._typicalItemHeight + this._gap));
			}
			const itemCount:int = items.length;
			var discoveredItemsCacheLastIndex:int = 0;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:DisplayObject = items[i];
				var iNormalized:int = i + indexOffset;
				if(this._useVirtualLayout && !item)
				{
					if(!this._hasVariableItemDimensions || isNaN(this._heightCache[iNormalized]))
					{
						positionY += this._typicalItemHeight + this._gap;
					}
					else
					{
						positionY += this._heightCache[iNormalized] + this._gap;
					}
				}
				else
				{
					if(item is ILayoutDisplayObject && !ILayoutDisplayObject(item).includeInLayout)
					{
						continue;
					}
					item.y = positionY;
					if(this._useVirtualLayout)
					{
						if(this._hasVariableItemDimensions)
						{
							if(isNaN(this._heightCache[iNormalized]))
							{
								this._heightCache[iNormalized] = item.height;
								this.dispatchEventWith(Event.CHANGE);
							}
						}
						else if(this._typicalItemHeight >= 0)
						{
							item.height = this._typicalItemHeight;
						}
					}
					positionY += item.height + this._gap;
					var itemWidth:Number = item.width;
					if(itemWidth > maxItemWidth)
					{
						maxItemWidth = itemWidth;
					}
					if(this._useVirtualLayout)
					{
						this._discoveredItemsCache[discoveredItemsCacheLastIndex] = item;
						discoveredItemsCacheLastIndex++;
					}
				}
			}
			if(this._useVirtualLayout && !this._hasVariableItemDimensions)
			{
				positionY += (this._afterVirtualizedItemCount * (this._typicalItemHeight + this._gap));
			}

			const discoveredItems:Vector.<DisplayObject> = this._useVirtualLayout ? this._discoveredItemsCache : items;
			const totalWidth:Number = maxItemWidth + this._paddingLeft + this._paddingRight;
			var availableWidth:Number = explicitWidth;
			if(isNaN(availableWidth))
			{
				availableWidth = totalWidth;
				if(availableWidth < minWidth)
				{
					availableWidth = minWidth;
				}
				else if(availableWidth > maxWidth)
				{
					availableWidth = maxWidth;
				}
			}
			const discoveredItemCount:int = discoveredItems.length;

			const totalHeight:Number = positionY - this._gap + this._paddingBottom - boundsY;
			var availableHeight:Number = explicitHeight;
			if(isNaN(availableHeight))
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
			if(totalHeight < availableHeight)
			{
				var verticalAlignOffsetY:Number = 0;
				if(this._verticalAlign == VERTICAL_ALIGN_BOTTOM)
				{
					verticalAlignOffsetY = availableHeight - totalHeight;
				}
				else if(this._verticalAlign == VERTICAL_ALIGN_MIDDLE)
				{
					verticalAlignOffsetY = (availableHeight - totalHeight) / 2;
				}
				if(verticalAlignOffsetY != 0)
				{
					for(i = 0; i < discoveredItemCount; i++)
					{
						item = discoveredItems[i];
						if(item is ILayoutDisplayObject && !ILayoutDisplayObject(item).includeInLayout)
						{
							continue;
						}
						item.y += verticalAlignOffsetY;
					}
				}
			}

			for(i = 0; i < discoveredItemCount; i++)
			{
				item = discoveredItems[i];
				if(item is ILayoutDisplayObject && !ILayoutDisplayObject(item).includeInLayout)
				{
					continue;
				}
				switch(this._horizontalAlign)
				{
					case HORIZONTAL_ALIGN_RIGHT:
					{
						item.x = boundsX + availableWidth - this._paddingRight - item.width;
						break;
					}
					case HORIZONTAL_ALIGN_CENTER:
					{
						item.x = boundsX + this._paddingLeft + (availableWidth - this._paddingLeft - this._paddingRight - item.width) / 2;
						break;
					}
					case HORIZONTAL_ALIGN_JUSTIFY:
					{
						item.x = boundsX + this._paddingLeft;
						item.width = availableWidth - this._paddingLeft - this._paddingRight;
						break;
					}
					default: //left
					{
						item.x = boundsX + this._paddingLeft;
					}
				}
				if(this.manageVisibility)
				{
					item.visible = ((item.y + item.height) >= (boundsY + scrollY)) && (item.y < (scrollY + availableHeight));
				}
			}

			this._discoveredItemsCache.length = 0;

			if(!result)
			{
				result = new LayoutBoundsResult();
			}
			result.contentWidth = this._horizontalAlign == HORIZONTAL_ALIGN_JUSTIFY ? availableWidth : totalWidth;
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
			const explicitWidth:Number = viewPortBounds ? viewPortBounds.explicitWidth : NaN;
			const explicitHeight:Number = viewPortBounds ? viewPortBounds.explicitHeight : NaN;
			const needsWidth:Boolean = isNaN(explicitWidth);
			const needsHeight:Boolean = isNaN(explicitHeight);
			if(!needsWidth && !needsHeight)
			{
				result.x = explicitWidth;
				result.y = explicitHeight;
				return result;
			}

			const minWidth:Number = viewPortBounds ? viewPortBounds.minWidth : 0;
			const minHeight:Number = viewPortBounds ? viewPortBounds.minHeight : 0;
			const maxWidth:Number = viewPortBounds ? viewPortBounds.maxWidth : Number.POSITIVE_INFINITY;
			const maxHeight:Number = viewPortBounds ? viewPortBounds.maxHeight : Number.POSITIVE_INFINITY;

			var positionY:Number = 0;
			var maxItemWidth:Number = this._typicalItemWidth;
			if(!this._hasVariableItemDimensions)
			{
				positionY += ((this._typicalItemHeight + this._gap) * itemCount);
			}
			else
			{
				for(var i:int = 0; i < itemCount; i++)
				{
					if(isNaN(this._heightCache[i]))
					{
						positionY += this._typicalItemHeight + this._gap;
					}
					else
					{
						positionY += this._heightCache[i] + this._gap;
					}
				}
			}

			if(needsWidth)
			{
				var resultWidth:Number = maxItemWidth + this._paddingLeft + this._paddingRight;
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
				var resultHeight:Number = positionY - this._gap + this._paddingTop + this._paddingBottom;
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
			const heightValue:* = item ? item.height : undefined;
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
		public function getVisibleIndicesAtScrollPosition(scrollX:Number, scrollY:Number, width:Number, height:Number, itemCount:int, result:Vector.<int> = null):Vector.<int>
		{
			if(!result)
			{
				result = new <int>[];
			}
			result.length = 0;
			var resultLastIndex:int = 0;
			const visibleTypicalItemCount:int = Math.ceil(height / (this._typicalItemHeight + this._gap));
			if(!this._hasVariableItemDimensions)
			{
				//this case can be optimized because we know that every item has
				//the same height
				var indexOffset:int = 0;
				var totalItemHeight:Number = itemCount * (this._typicalItemHeight + this._gap) - this._gap;
				if(totalItemHeight < height)
				{
					if(this._verticalAlign == VERTICAL_ALIGN_BOTTOM)
					{
						indexOffset = Math.ceil((height - totalItemHeight) / (this._typicalItemHeight + this._gap));
					}
					else if(this._verticalAlign == VERTICAL_ALIGN_MIDDLE)
					{
						indexOffset = Math.ceil(((height - totalItemHeight) / (this._typicalItemHeight + this._gap)) / 2);
					}
				}
				var minimum:int = (scrollY - this._paddingTop) / (this._typicalItemHeight + this._gap);
				if(minimum < 0)
				{
					minimum = 0;
				}
				minimum -= indexOffset;
				//if we're scrolling beyond the final item, we should keep the
				//indices consistent so that items aren't destroyed and
				//recreated unnecessarily
				var maximum:int = minimum + visibleTypicalItemCount;
				if(maximum >= itemCount)
				{
					maximum = itemCount - 1;
				}
				minimum = maximum - visibleTypicalItemCount;
				if(minimum < 0)
				{
					minimum = 0;
				}
				for(var i:int = minimum; i <= maximum; i++)
				{
					result[resultLastIndex] = i;
					resultLastIndex++;
				}
				return result;
			}
			const maxPositionY:Number = scrollY + height;
			var positionY:Number = this._paddingTop;
			for(i = 0; i < itemCount; i++)
			{
				if(isNaN(this._heightCache[i]))
				{
					var itemHeight:Number = this._typicalItemHeight;
				}
				else
				{
					itemHeight = this._heightCache[i];
				}
				var oldPositionY:Number = positionY;
				positionY += itemHeight + this._gap;
				if(positionY > scrollY && oldPositionY < maxPositionY)
				{
					result[resultLastIndex] = i;
					resultLastIndex++;
				}

				if(positionY >= maxPositionY)
				{
					break;
				}
			}

			//similar to above, in order to avoid costly destruction and
			//creation of item renderers, we're going to fill in some extra
			//indices
			var resultLength:int = result.length;
			var visibleItemCountDifference:int = visibleTypicalItemCount - resultLength;
			if(visibleItemCountDifference > 0 && resultLength > 0)
			{
				//add extra items before the first index
				const firstExistingIndex:int = result[0];
				var lastIndexToAdd:int = firstExistingIndex - visibleItemCountDifference;
				if(lastIndexToAdd < 0)
				{
					lastIndexToAdd = 0;
				}
				for(i = firstExistingIndex - 1; i >= lastIndexToAdd; i--)
				{
					result.unshift(i);
				}
			}
			resultLength = result.length;
			visibleItemCountDifference = visibleTypicalItemCount - resultLength;
			resultLastIndex = resultLength;
			if(visibleItemCountDifference > 0)
			{
				//add extra items after the last index
				const startIndex:int = (resultLength > 0) ? (result[resultLength - 1] + 1) : 0;
				var endIndex:int = startIndex + visibleItemCountDifference;
				if(endIndex > itemCount)
				{
					endIndex = itemCount;
				}
				for(i = startIndex; i < endIndex; i++)
				{
					result[resultLastIndex] = i;
					resultLastIndex++;
				}
			}
			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function getScrollPositionForIndex(index:int, items:Vector.<DisplayObject>, x:Number, y:Number, width:Number, height:Number, result:Point = null):Point
		{
			if(!result)
			{
				result = new Point();
			}

			var positionY:Number = y + this._paddingTop;
			var startIndexOffset:int = 0;
			var endIndexOffset:Number = 0;
			if(this._useVirtualLayout && !this._hasVariableItemDimensions)
			{
				startIndexOffset = this._beforeVirtualizedItemCount;
				positionY += (this._beforeVirtualizedItemCount * (this._typicalItemHeight + this._gap));

				endIndexOffset = index - items.length - this._beforeVirtualizedItemCount + 1;
				if(endIndexOffset < 0)
				{
					endIndexOffset = 0;
				}
				positionY += (endIndexOffset * (this._typicalItemHeight + this._gap));
			}
			index -= (startIndexOffset + endIndexOffset);
			var lastHeight:Number = 0;
			for(var i:int = 0; i <= index; i++)
			{
				var item:DisplayObject = items[i];
				var iNormalized:int = i + startIndexOffset;
				if(this._useVirtualLayout && !item)
				{
					if(!this._hasVariableItemDimensions || isNaN(this._heightCache[iNormalized]))
					{
						lastHeight = this._typicalItemHeight;
					}
					else
					{
						lastHeight = this._heightCache[iNormalized];
					}
				}
				else
				{
					if(this._hasVariableItemDimensions)
					{
						if(isNaN(this._heightCache[iNormalized]))
						{
							this._heightCache[iNormalized] = item.height;
							this.dispatchEventWith(Event.CHANGE);
						}
					}
					else if(this._typicalItemHeight >= 0)
					{
						item.height = this._typicalItemHeight;
					}
					lastHeight = item.height;
				}
				positionY += lastHeight + this._gap;
			}
			positionY -= (lastHeight + this._gap);
			if(this._scrollPositionVerticalAlign == VERTICAL_ALIGN_MIDDLE)
			{
				positionY -= (height - lastHeight) / 2;
			}
			else if(this._scrollPositionVerticalAlign == VERTICAL_ALIGN_BOTTOM)
			{
				positionY -= (height - lastHeight);
			}
			result.x = 0;
			result.y = positionY;

			return result;
		}

		/**
		 * @private
		 */
		protected function validateItems(items:Vector.<DisplayObject>):void
		{
			const itemCount:int = items.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:DisplayObject = items[i];
				if(item is ILayoutDisplayObject && !ILayoutDisplayObject(item).includeInLayout)
				{
					continue;
				}
				if(!(item is IFeathersControl))
				{
					continue;
				}
				IFeathersControl(item).validate();
			}
		}
	}
}
