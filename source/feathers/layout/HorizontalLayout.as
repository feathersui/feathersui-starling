/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.layout
{
	import flash.geom.Point;

	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.EventDispatcher;

	/**
	 * @inheritDoc
	 */
	[Event(name="change",type="starling.events.Event")]

	/**
	 * Positions items from left to right in a single row.
	 */
	public class HorizontalLayout extends EventDispatcher implements IVariableVirtualLayout
	{
		/**
		 * @private
		 */
		private static const HELPER_VECTOR:Vector.<DisplayObject> = new <DisplayObject>[];

		/**
		 * The items will be aligned to the top of the bounds.
		 */
		public static const VERTICAL_ALIGN_TOP:String = "top";

		/**
		 * The items will be aligned to the middle of the bounds.
		 */
		public static const VERTICAL_ALIGN_MIDDLE:String = "middle";

		/**
		 * The items will be aligned to the bottom of the bounds.
		 */
		public static const VERTICAL_ALIGN_BOTTOM:String = "bottom";

		/**
		 * The items will fill the height of the bounds.
		 */
		public static const VERTICAL_ALIGN_JUSTIFY:String = "justify";

		/**
		 * If the total item width is smaller than the width of the bounds, the
		 * items will be aligned to the left.
		 */
		public static const HORIZONTAL_ALIGN_LEFT:String = "left";

		/**
		 * If the total item width is smaller than the width of the bounds, the
		 * items will be aligned to the center.
		 */
		public static const HORIZONTAL_ALIGN_CENTER:String = "center";

		/**
		 * If the total item width is smaller than the width of the bounds, the
		 * items will be aligned to the right.
		 */
		public static const HORIZONTAL_ALIGN_RIGHT:String = "right";

		/**
		 * Constructor.
		 */
		public function HorizontalLayout()
		{
		}

		/**
		 * @private
		 */
		protected var _widthCache:Array = [];

		/**
		 * @private
		 */
		protected var _gap:Number = 0;

		/**
		 * The space, in pixels, between items.
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
		 * @private
		 */
		protected var _paddingTop:Number = 0;

		/**
		 * The minimum space, in pixels, above the items.
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
		 * The space, in pixels, after the last item.
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
		 * The minimum space, in pixels, above the items.
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
		 * The space, in pixels, before the first item.
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

		[Inspectable(type="String",enumeration="top,middle,bottom,justify")]
		/**
		 * The alignment of the items vertically, on the y-axis.
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

		[Inspectable(type="String",enumeration="left,center,right")]
		/**
		 * If the total item width is less than the bounds, the positions of
		 * the items can be aligned horizontally.
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
		 * @inheritDoc
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
		protected var _scrollPositionHorizontalAlign:String = HORIZONTAL_ALIGN_CENTER;

		[Inspectable(type="String",enumeration="left,center,right")]
		/**
		 * When the scroll position is calculated for an item, an attempt will
		 * be made to align the item to this position.
		 */
		public function get scrollPositionHorizontalAlign():String
		{
			return this._scrollPositionHorizontalAlign;
		}

		/**
		 * @private
		 */
		public function set scrollPositionHorizontalAlign(value:String):void
		{
			this._scrollPositionHorizontalAlign = value;
		}

		/**
		 * @inheritDoc
		 */
		public function layout(items:Vector.<DisplayObject>, suggestedBounds:ViewPortBounds = null, result:LayoutBoundsResult = null):LayoutBoundsResult
		{
			const boundsX:Number = suggestedBounds ? suggestedBounds.x : 0;
			const boundsY:Number = suggestedBounds ? suggestedBounds.y : 0;
			const minWidth:Number = suggestedBounds ? suggestedBounds.minWidth : 0;
			const minHeight:Number = suggestedBounds ? suggestedBounds.minHeight : 0;
			const maxWidth:Number = suggestedBounds ? suggestedBounds.maxWidth : Number.POSITIVE_INFINITY;
			const maxHeight:Number = suggestedBounds ? suggestedBounds.maxHeight : Number.POSITIVE_INFINITY;
			const explicitWidth:Number = suggestedBounds ? suggestedBounds.explicitWidth : NaN;
			const explicitHeight:Number = suggestedBounds ? suggestedBounds.explicitHeight : NaN;

			HELPER_VECTOR.length = 0;
			var maxItemHeight:Number = this._useVirtualLayout ? this._typicalItemHeight : 0;
			var positionX:Number = boundsX + this._paddingLeft;
			const itemCount:int = items.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:DisplayObject = items[i];
				if(this._useVirtualLayout && !item)
				{
					if(!this._hasVariableItemDimensions || isNaN(this._widthCache[i]))
					{
						positionX += this._typicalItemWidth + this._gap;
					}
					else
					{
						positionX += this._widthCache[i] + this._gap;
					}
				}
				else
				{
					item.x = positionX;
					if(this._useVirtualLayout)
					{
						if(this._hasVariableItemDimensions)
						{
							if(isNaN(this._widthCache[i]))
							{
								this._widthCache[i] = item.width;
								this.dispatchEventWith(Event.CHANGE);
							}
						}
						else if(this._typicalItemWidth >= 0)
						{
							item.width = this._typicalItemWidth;
						}
					}
					positionX += item.width + this._gap;
					maxItemHeight = Math.max(maxItemHeight, item.height);
					if(this._useVirtualLayout)
					{
						HELPER_VECTOR.push(item);
					}
				}
			}

			const discoveredItems:Vector.<DisplayObject> = this._useVirtualLayout ? HELPER_VECTOR : items;
			const totalHeight:Number = maxItemHeight + this._paddingTop + this._paddingBottom;
			const availableHeight:Number = isNaN(explicitHeight) ? Math.min(maxHeight, Math.max(minHeight, totalHeight)) : explicitHeight;
			const discoveredItemCount:int = discoveredItems.length;
			for(i = 0; i < discoveredItemCount; i++)
			{
				item = discoveredItems[i];
				switch(this._verticalAlign)
				{
					case VERTICAL_ALIGN_BOTTOM:
					{
						item.y = boundsY + availableHeight - this._paddingBottom - item.height;
						break;
					}
					case VERTICAL_ALIGN_MIDDLE:
					{
						item.y = boundsY + this._paddingTop + (availableHeight - this._paddingTop - this._paddingBottom - item.height) / 2;
						break;
					}
					case VERTICAL_ALIGN_JUSTIFY:
					{
						item.y = boundsY + this._paddingTop;
						item.height = availableHeight - this._paddingTop - this._paddingBottom;
						break;
					}
					default: //top
					{
						item.y = boundsY + this._paddingTop;
					}
				}
			}

			const totalWidth:Number = positionX - this._gap + this._paddingRight - boundsX;
			const availableWidth:Number = isNaN(explicitWidth) ? Math.min(maxWidth, Math.max(minWidth, totalWidth)) : explicitWidth;
			if(totalWidth < availableWidth)
			{
				var horizontalAlignOffsetX:Number = 0;
				if(this._horizontalAlign == HORIZONTAL_ALIGN_RIGHT)
				{
					horizontalAlignOffsetX = availableWidth - totalWidth;
				}
				else if(this._horizontalAlign == HORIZONTAL_ALIGN_CENTER)
				{
					horizontalAlignOffsetX = (availableWidth - totalWidth) / 2;
				}
				if(horizontalAlignOffsetX != 0)
				{
					for(i = 0; i < discoveredItemCount; i++)
					{
						item = discoveredItems[i];
						item.x += horizontalAlignOffsetX;
					}
				}
			}
			HELPER_VECTOR.length = 0;

			if(!result)
			{
				result = new LayoutBoundsResult();
			}
			result.contentWidth = totalWidth;
			result.contentHeight = this._verticalAlign == VERTICAL_ALIGN_JUSTIFY ? availableHeight : totalHeight;
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

			var maxItemHeight:Number = this._typicalItemHeight;
			var positionX:Number = 0;

			if(!this._hasVariableItemDimensions)
			{
				positionX += ((this._typicalItemWidth + this._gap) * itemCount);
			}
			else
			{
				for(var i:int = 0; i < itemCount; i++)
				{
					if(isNaN(this._widthCache[i]))
					{
						positionX += this._typicalItemWidth + this._gap;
					}
					else
					{
						positionX += this._widthCache[i] + this._gap;
					}
				}
			}

			if(needsWidth)
			{
				result.x = Math.min(maxWidth, Math.max(minWidth, positionX - this._gap + this._paddingLeft + this._paddingRight));
			}
			else
			{
				result.x = explicitWidth;
			}

			if(needsHeight)
			{
				result.y = Math.min(maxHeight, Math.max(minHeight, maxItemHeight + this._paddingTop + this._paddingBottom));
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
			this._widthCache.length = 0;
		}

		/**
		 * @inheritDoc
		 */
		public function resetVariableVirtualCacheAtIndex(index:int, item:DisplayObject = null):void
		{
			delete this._widthCache[index];
			if(item)
			{
				this._widthCache[index] = item.width;
				this.dispatchEventWith(Event.CHANGE);
			}
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
			const visibleTypicalItemCount:int = Math.ceil(width / (this._typicalItemWidth + this._gap));
			if(!this._hasVariableItemDimensions)
			{
				//this case can be optimized because we know that every item has
				//the same width
				var totalItemWidth:Number = itemCount * (this._typicalItemWidth + this._gap) - this._gap;
				var indexOffset:int = 0;
				if(totalItemWidth < width)
				{
					if(this._horizontalAlign == HORIZONTAL_ALIGN_RIGHT)
					{
						indexOffset = Math.ceil((width - totalItemWidth) / (this._typicalItemWidth + this._gap));
					}
					else if(this._horizontalAlign == HORIZONTAL_ALIGN_CENTER)
					{
						indexOffset = Math.ceil(((width - totalItemWidth) / (this._typicalItemWidth + this._gap)) / 2);
					}
				}
				var minimum:int = -indexOffset + Math.max(0, (scrollX - this._paddingLeft) / (this._typicalItemWidth + this._gap));
				//if we're scrolling beyond the final item, we should keep the
				//indices consistent so that items aren't destroyed and
				//recreated unnecessarily
				var maximum:int = Math.min(itemCount - 1, minimum + visibleTypicalItemCount);
				minimum = Math.max(0, maximum - visibleTypicalItemCount);
				for(var i:int = minimum; i <= maximum; i++)
				{
					result.push(i);
				}
				return result;
			}
			const maxPositionX:Number = scrollX + width;
			var positionX:Number = this._paddingLeft;
			for(i = 0; i < itemCount; i++)
			{
				if(isNaN(this._widthCache[i]))
				{
					var itemWidth:Number = this._typicalItemWidth;
				}
				else
				{
					itemWidth = this._widthCache[i];
				}
				var oldPositionX:Number = positionX;
				positionX += itemWidth + this._gap;
				if(positionX > scrollX && oldPositionX < maxPositionX)
				{
					result.push(i);
				}

				if(positionX >= maxPositionX)
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
				const lastIndexToAdd:int = Math.max(0, firstExistingIndex - visibleItemCountDifference);
				for(i = firstExistingIndex - 1; i >= lastIndexToAdd; i--)
				{
					result.unshift(i);
				}
			}
			resultLength = result.length;
			visibleItemCountDifference = visibleTypicalItemCount - resultLength;
			if(visibleItemCountDifference > 0)
			{
				//add extra items after the last index
				const startIndex:int = resultLength > 0 ? (result[resultLength - 1] + 1) : 0;
				const endIndex:int = Math.min(itemCount, startIndex + visibleItemCountDifference);
				for(i = startIndex; i < endIndex; i++)
				{
					result.push(i);
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

			var positionX:Number = x + this._paddingLeft;
			var lastWidth:Number = 0;
			for(var i:int = 0; i <= index; i++)
			{
				var item:DisplayObject = items[i];
				if(this._useVirtualLayout && !item)
				{
					if(!this._hasVariableItemDimensions || isNaN(this._widthCache[i]))
					{
						lastWidth = this._typicalItemWidth;
					}
					else
					{
						lastWidth = this._widthCache[i];
					}
				}
				else
				{
					if(this._hasVariableItemDimensions)
					{
						if(isNaN(this._widthCache[i]))
						{
							this._widthCache[i] = item.width;
							this.dispatchEventWith(Event.CHANGE);
						}
					}
					else if(this._typicalItemWidth >= 0)
					{
						item.width = this._typicalItemWidth;
					}
					lastWidth = item.width;
				}
				positionX += lastWidth + this._gap;
			}
			positionX -= (lastWidth + this._gap);
			if(this._scrollPositionHorizontalAlign == HORIZONTAL_ALIGN_CENTER)
			{
				positionX -= (width - lastWidth) / 2;
			}
			else if(this._scrollPositionHorizontalAlign == HORIZONTAL_ALIGN_RIGHT)
			{
				positionX -= (width - lastWidth);
			}
			result.x = positionX;
			result.y = 0;

			return result;
		}
	}
}
