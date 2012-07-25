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
package org.josht.starling.foxhole.layout
{
	import flash.geom.Point;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import starling.display.DisplayObject;

	/**
	 * Positions items from left to right in a single row.
	 */
	public class HorizontalLayout implements IVariableVirtualLayout
	{
		private static var helperPoint:Point;

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
		private var _gap:Number = 0;

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
			this._onLayoutChange.dispatch(this);
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
			this._onLayoutChange.dispatch(this);
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
			this._onLayoutChange.dispatch(this);
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
			this._onLayoutChange.dispatch(this);
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
			this._onLayoutChange.dispatch(this);
		}

		/**
		 * @private
		 */
		private var _verticalAlign:String = VERTICAL_ALIGN_TOP;

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
			this._onLayoutChange.dispatch(this);
		}

		/**
		 * @private
		 */
		private var _horizontalAlign:String = HORIZONTAL_ALIGN_LEFT;

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
			this._onLayoutChange.dispatch(this);
		}

		/**
		 * @private
		 */
		private var _useVirtualLayout:Boolean = true;

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
			this._onLayoutChange.dispatch(this);
		}

		/**
		 * @private
		 */
		private var _indexToItemBoundsFunction:Function;

		/**
		 * @inheritDoc
		 */
		public function get indexToItemBoundsFunction():Function
		{
			return this._indexToItemBoundsFunction;
		}

		/**
		 * @private
		 */
		public function set indexToItemBoundsFunction(value:Function):void
		{
			if(this._indexToItemBoundsFunction == value)
			{
				return;
			}
			this._indexToItemBoundsFunction = value;
		}

		/**
		 * @private
		 */
		private var _typicalItemWidth:Number = 0;

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
		private var _typicalItemHeight:Number = 0;

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
		protected var _onLayoutChange:Signal = new Signal(ILayout);

		/**
		 * @inheritDoc
		 */
		public function get onLayoutChange():ISignal
		{
			return this._onLayoutChange;
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

			var maxItemHeight:Number = 0;
			var positionX:Number = boundsX + this._paddingLeft;
			const itemCount:int = items.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:DisplayObject = items[i];
				if(this._useVirtualLayout && !item)
				{
					if(this._indexToItemBoundsFunction != null)
					{
						helperPoint = this._indexToItemBoundsFunction(i, helperPoint);
						positionX += helperPoint.x + this._gap;
						maxItemHeight = Math.max(maxItemHeight, helperPoint.y);
					}
					else
					{
						positionX += this._typicalItemWidth + this._gap;
						maxItemHeight = Math.max(maxItemHeight, this._typicalItemHeight);
					}
				}
				else
				{
					item.x = positionX;
					if(this._useVirtualLayout)
					{
						if(this._indexToItemBoundsFunction != null)
						{
							helperPoint = this._indexToItemBoundsFunction(i, helperPoint);
							item.width = helperPoint.x;
							item.height = helperPoint.y;
						}
						else
						{
							item.width = this._typicalItemWidth;
							item.height = this._typicalItemHeight;
						}
					}
					positionX += item.width + this._gap;
					maxItemHeight = Math.max(maxItemHeight, item.height);
				}
			}

			const totalHeight:Number = maxItemHeight + this._paddingTop + this._paddingBottom;
			const availableHeight:Number = isNaN(explicitHeight) ? Math.min(maxHeight, Math.max(minHeight, totalHeight)) : explicitHeight;
			for(i = 0; i < itemCount; i++)
			{
				item = items[i];
				if(!item)
				{
					continue;
				}
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
						item.y = this._paddingTop;
						item.height = availableHeight - this._paddingTop - this._paddingBottom;
						break;
					}
					default: //top
					{
						item.y = this._paddingTop;
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
					for(i = 0; i < itemCount; i++)
					{
						item = items[i];
						if(!item)
						{
							continue;
						}
						item.x += horizontalAlignOffsetX;
					}
				}
			}

			if(!result)
			{
				result = new LayoutBoundsResult();
			}
			result.contentWidth = totalWidth;
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

			var maxItemHeight:Number = 0;
			var positionX:Number = 0;
			if(this._indexToItemBoundsFunction != null)
			{
				for(var i:int = 0; i < itemCount; i++)
				{
					helperPoint = this._indexToItemBoundsFunction(i, helperPoint);
					positionX += helperPoint.x + this._gap;
					maxItemHeight = Math.max(maxItemHeight, helperPoint.y);
				}
			}
			else
			{
				positionX += itemCount * (this._typicalItemWidth + this._gap);
				maxItemHeight = this._typicalItemHeight;
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
		public function getMinimumItemIndexAtScrollPosition(scrollX:Number, scrollY:Number, width:Number, height:Number, itemCount:int):int
		{
			if(this._indexToItemBoundsFunction == null)
			{
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
				return -indexOffset + Math.max(0, (scrollX - this._paddingLeft) / (this._typicalItemWidth + this._gap));
			}

			totalItemWidth = this._paddingLeft;
			for(var i:int = 0; i < itemCount; i++)
			{
				helperPoint = this._indexToItemBoundsFunction(i, helperPoint);
				totalItemWidth += helperPoint.x;
				if(totalItemWidth > scrollX)
				{
					return i;
				}
				totalItemWidth += this._gap;
			}
			//this should probably never happen...
			return itemCount - 1;
		}

		/**
		 * @inheritDoc
		 */
		public function getMaximumItemIndexAtScrollPosition(scrollX:Number, scrollY:Number, width:Number, height:Number, itemCount:int):int
		{
			const minimum:int = this.getMinimumItemIndexAtScrollPosition(scrollX, scrollY, width, height, itemCount);
			if(this._indexToItemBoundsFunction == null)
			{
				return minimum + Math.ceil(width / (this._typicalItemWidth + this._gap));
			}
			const maxX:Number = scrollX + width;
			var totalItemWidth:Number = scrollX;
			for(var i:int = minimum + 1; i < itemCount; i++)
			{
				helperPoint = this._indexToItemBoundsFunction(i, helperPoint);
				totalItemWidth += helperPoint.x;
				if(totalItemWidth > maxX)
				{
					return i;
				}
				totalItemWidth += this._gap;
			}
			return itemCount - 1;
		}

		/**
		 * @inheritDoc
		 */
		public function getScrollPositionForItemIndexAndBounds(index:int, width:Number, height:Number, result:Point = null):Point
		{
			if(!result)
			{
				result = new Point();
			}

			result.y = 0;
			if(this._indexToItemBoundsFunction == null)
			{
				const typicalItemWidth:Number = this._typicalItemWidth;
				result.x = this._paddingLeft + (typicalItemWidth + this._gap) * index - (width - typicalItemWidth) / 2;
			}
			else
			{
				var totalItemWidth:Number = this._paddingLeft;
				for(var i:int = 0; i < index; i++)
				{
					helperPoint = this._indexToItemBoundsFunction(i, helperPoint);
					totalItemWidth += helperPoint.x + this._gap;
				}
				totalItemWidth -= (width - helperPoint.x) / 2;
				result.x = totalItemWidth;
			}
			return result;
		}
	}
}
