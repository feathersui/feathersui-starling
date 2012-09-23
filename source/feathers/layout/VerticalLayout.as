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
package feathers.layout
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
		private static const helperVector:Vector.<DisplayObject> = new <DisplayObject>[];

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
		protected var _heightCache:Array = [];

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
		private var _hasVariableItemDimensions:Boolean = false;

		/**
		 * When the layout is virtualized, and this value is true, the items may
		 * have variable width values. If false, the items will all share the
		 * same width value with the typical item.
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
			this._onLayoutChange.dispatch(this);
		}

		/**
		 * @private
		 */
		private var _typicalItemWidth:Number = -1;

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
		private var _typicalItemHeight:Number = -1;

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

		/**
		 * When the scroll position is calculated for an item, an attempt will
		 * be made to align the item to this position.
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

			helperVector.length = 0;
			var maxItemWidth:Number = this._useVirtualLayout ? this._typicalItemWidth : 0;
			var positionY:Number = boundsY + this._paddingTop;
			const itemCount:int = items.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:DisplayObject = items[i];
				if(this._useVirtualLayout && !item)
				{
					if(!this._hasVariableItemDimensions || isNaN(this._heightCache[i]))
					{
						positionY += this._typicalItemHeight + this._gap;
					}
					else
					{
						positionY += this._heightCache[i] + this._gap;
					}
				}
				else
				{
					item.y = positionY;
					if(this._useVirtualLayout)
					{
						if(this._hasVariableItemDimensions)
						{
							if(isNaN(this._heightCache[i]))
							{
								this._heightCache[i] = item.height;
								this._onLayoutChange.dispatch(this);
							}
						}
						else if(this._typicalItemHeight >= 0)
						{
							item.height = this._typicalItemHeight;
						}
					}
					positionY += item.height + this._gap;
					maxItemWidth = Math.max(maxItemWidth, item.width);
					if(this._useVirtualLayout)
					{
						helperVector.push(item);
					}
				}
			}

			const discoveredItems:Vector.<DisplayObject> = this._useVirtualLayout ? helperVector : items;
			const totalWidth:Number = maxItemWidth + this._paddingLeft + this._paddingRight;
			const availableWidth:Number = isNaN(explicitWidth) ? Math.min(maxWidth, Math.max(minWidth, totalWidth)) : explicitWidth;
			const discoveredItemCount:int = discoveredItems.length;
			for(i = 0; i < discoveredItemCount; i++)
			{
				item = discoveredItems[i];
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
					for(i = 0; i < discoveredItemCount; i++)
					{
						item = discoveredItems[i];
						item.y += verticalAlignOffsetY;
					}
				}
			}
			helperVector.length = 0;

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
				this._onLayoutChange.dispatch(this);
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
				var minimum:int = -indexOffset + Math.max(0, (scrollY - this._paddingTop) / (this._typicalItemHeight + this._gap));
				var maximum:int = minimum + Math.ceil(height / (this._typicalItemHeight + this._gap));
				for(var i:int = minimum; i <= maximum; i++)
				{
					result.push(i);
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
					result.push(i);
				}

				if(positionY >= maxPositionY)
				{
					return result;
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
			var lastHeight:Number = 0;
			for(var i:int = 0; i <= index; i++)
			{
				var item:DisplayObject = items[i];
				if(this._useVirtualLayout && !item)
				{
					if(!this._hasVariableItemDimensions || isNaN(this._heightCache[i]))
					{
						lastHeight = this._typicalItemHeight;
					}
					else
					{
						lastHeight = this._heightCache[i];
					}
				}
				else
				{
					if(this._hasVariableItemDimensions)
					{
						if(isNaN(this._heightCache[i]))
						{
							this._heightCache[i] = item.height;
							this._onLayoutChange.dispatch(this);
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
	}
}
