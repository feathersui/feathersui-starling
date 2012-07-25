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
	 * Positions items from top to bottom in a single column.
	 */
	public class VerticalLayout implements IVariableVirtualLayout
	{
		private static var helperPoint:Point;

		/**
		 * If the total item height is smaller than the height of the bounds,
		 * the items will be aligned to the top.
		 */
		public static const VERTICAL_ALIGN_TOP:String = "top";

		/**
		 * If the total item height is smaller than the height of the bounds,
		 * the items will be aligned to the middle.
		 */
		public static const VERTICAL_ALIGN_MIDDLE:String = "middle";

		/**
		 * If the total item height is smaller than the height of the bounds,
		 * the items will be aligned to the bottom.
		 */
		public static const VERTICAL_ALIGN_BOTTOM:String = "bottom";

		/**
		 * The items will be aligned to the left of the bounds.
		 */
		public static const HORIZONTAL_ALIGN_LEFT:String = "left";

		/**
		 * The items will be aligned to the center of the bounds.
		 */
		public static const HORIZONTAL_ALIGN_CENTER:String = "center";

		/**
		 * The items will be aligned to the right of the bounds.
		 */
		public static const HORIZONTAL_ALIGN_RIGHT:String = "right";

		/**
		 * The items will fill the width of the bounds.
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
		private var _gap:Number = 0;

		/**
		 * THe space, in pixels, between items.
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
		 * The space, in pixels, that appears on top, before the first item.
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
		 * The minimum space, in pixels, to the right of the items.
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
		 * The space, in pixels, that appears on the bottom, after the last
		 * item.
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
		 * The minimum space, in pixels, to the left of the items.
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
		 * If the total item height is less than the bounds, the positions of
		 * the items can be aligned vertically.
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
		 * The alignment of the items horizontally, on the x-axis.
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
		public function layout(items:Vector.<DisplayObject>, viewPortBounds:ViewPortBounds = null, result:LayoutBoundsResult = null):LayoutBoundsResult
		{
			const boundsX:Number = viewPortBounds ? viewPortBounds.x : 0;
			const boundsY:Number = viewPortBounds ? viewPortBounds.y : 0;
			const minWidth:Number = viewPortBounds ? viewPortBounds.minWidth : 0;
			const minHeight:Number = viewPortBounds ? viewPortBounds.minHeight : 0;
			const maxWidth:Number = viewPortBounds ? viewPortBounds.maxWidth : Number.POSITIVE_INFINITY;
			const maxHeight:Number = viewPortBounds ? viewPortBounds.maxHeight : Number.POSITIVE_INFINITY;
			const explicitWidth:Number = viewPortBounds ? viewPortBounds.explicitWidth : NaN;
			const explicitHeight:Number = viewPortBounds ? viewPortBounds.explicitHeight : NaN;

			var maxItemWidth:Number = 0;
			var positionY:Number = boundsY + this._paddingTop;
			const itemCount:int = items.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:DisplayObject = items[i];
				if(this._useVirtualLayout && !item)
				{
					if(this._indexToItemBoundsFunction != null)
					{
						helperPoint = this._indexToItemBoundsFunction(i, helperPoint);
						positionY += helperPoint.y + this._gap;
						maxItemWidth = Math.max(maxItemWidth, helperPoint.x);
					}
					else
					{
						positionY += this._typicalItemHeight + this._gap;
						maxItemWidth = Math.max(maxItemWidth, this._typicalItemWidth);
					}
				}
				else
				{
					item.y = positionY;
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
					positionY += item.height + this._gap;
					maxItemWidth = Math.max(maxItemWidth, item.width);
				}
			}

			const totalWidth:Number = maxItemWidth + this._paddingLeft + this._paddingRight;
			const availableWidth:Number = isNaN(explicitWidth) ? Math.min(maxWidth, Math.max(minWidth, totalWidth)) : explicitWidth;
			for(i = 0; i < itemCount; i++)
			{
				item = items[i];
				if(!item)
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
						item.x = this._paddingLeft;
						item.width = availableWidth - this._paddingLeft - this._paddingRight;
						break;
					}
					default: //top
					{
						item.x = this._paddingLeft;
					}
				}
			}

			const totalHeight:Number = positionY - this._gap + this._paddingBottom - boundsY;
			const availableHeight:Number = isNaN(explicitHeight) ? Math.min(maxHeight, Math.max(minHeight, totalHeight)) : explicitHeight;
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
					for(i = 0; i < itemCount; i++)
					{
						item = items[i];
						if(!item)
						{
							continue;
						}
						item.y += verticalAlignOffsetY;
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

			var positionY:Number = 0;
			var maxItemWidth:Number = 0;
			if(this._indexToItemBoundsFunction != null)
			{
				for(var i:int = 0; i < itemCount; i++)
				{
					helperPoint = this._indexToItemBoundsFunction(i, helperPoint);
					positionY += helperPoint.y + this._gap;
					maxItemWidth = Math.max(maxItemWidth, helperPoint.x);
				}
			}
			else
			{
				positionY += itemCount * (this._typicalItemHeight + this._gap);
				maxItemWidth = this._typicalItemWidth;
			}

			if(needsWidth)
			{
				result.x = Math.min(maxWidth, Math.max(minWidth, maxItemWidth + this._paddingLeft + this._paddingRight));
			}
			else
			{
				result.x = explicitWidth;
			}

			if(needsHeight)
			{
				result.y = Math.min(maxHeight, Math.max(minHeight, positionY - this._gap + this._paddingTop + this._paddingBottom));
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
				return -indexOffset + Math.max(0, (scrollY - this._paddingTop) / (this._typicalItemHeight + this._gap));
			}

			totalItemHeight = this._paddingTop;
			for(var i:int = 0; i < itemCount; i++)
			{
				helperPoint = this._indexToItemBoundsFunction(i, helperPoint);
				totalItemHeight += helperPoint.y;
				if(totalItemHeight > scrollY)
				{
					return i;
				}
				totalItemHeight += this._gap;
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
				return minimum + Math.ceil(height / (this._typicalItemHeight + this._gap));
			}
			const maxY:Number = scrollY + height;
			var totalItemHeight:Number = scrollY;
			for(var i:int = minimum + 1; i < itemCount; i++)
			{
				helperPoint = this._indexToItemBoundsFunction(i, helperPoint);
				totalItemHeight += helperPoint.y;
				if(totalItemHeight > maxY)
				{
					return i;
				}
				totalItemHeight += this._gap;
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

			result.x = 0;
			if(this._indexToItemBoundsFunction == null)
			{
				const typicalItemHeight:Number = this._typicalItemHeight;
				result.y = this._paddingTop + (typicalItemHeight + this._gap) * index - (height - typicalItemHeight) / 2;
			}
			else
			{
				var totalItemHeight:Number = this._paddingTop;
				for(var i:int = 0; i < index; i++)
				{
					helperPoint = this._indexToItemBoundsFunction(i, helperPoint);
					totalItemHeight += helperPoint.y + this._gap;
				}
				totalItemHeight -= (height - helperPoint.y) / 2;
				result.y = totalItemHeight;
			}
			return result;
		}
	}
}
