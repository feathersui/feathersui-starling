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
	 * Positions items in rows following a grid with a specific number of
	 * columns, defaulting to <code>12</code> columns. Automatically flows from
	 * row to row.
	 *
	 * @see http://wiki.starling-framework.org/feathers/multi-column-grid-layout
	 * @see MultiColumnGridLayoutData
	 */
	public class MultiColumnGridLayout extends EventDispatcher implements ILayout
	{
		/**
		 * Constructor.
		 */
		public function MultiColumnGridLayout()
		{
		}

		/**
		 * @private
		 */
		public var _columnCount:int = 12;

		/**
		 * The number of columns in the grid.
		 */
		public function get columnCount():int
		{
			return this._columnCount;
		}

		/**
		 * @private
		 */
		public function set columnCount(value:int):void
		{
			if(this._columnCount == value)
			{
				return;
			}
			this._columnCount = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		public var _columnGap:Number = 0;

		/**
		 * The size, in pixels, of the gap between columns.
		 */
		public function get columnGap():Number
		{
			return this._columnGap
		}

		/**
		 * @private
		 */
		public function set columnGap(value:Number):void
		{
			if(this._columnGap == value)
			{
				return;
			}
			this._columnGap = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		public var _rowGap:Number = 0;

		/**
		 * The size, in pixels, of the gap between rows.
		 */
		public function get rowGap():Number
		{
			return this._rowGap
		}

		/**
		 * @private
		 */
		public function set rowGap(value:Number):void
		{
			if(this._rowGap == value)
			{
				return;
			}
			this._rowGap = value;
			this.dispatchEventWith(Event.CHANGE);
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

			var viewPortWidthPixels:Number = isNaN(explicitWidth) ? minWidth : explicitWidth;
			const contentHeight:Number = this.layoutItems(items, boundsX, boundsY, viewPortWidthPixels);
			var viewPortHeightPixels:Number = Math.min(maxHeight, Math.max(minHeight, contentHeight));

			if(!result)
			{
				result = new LayoutBoundsResult();
			}
			result.contentWidth = viewPortWidthPixels;
			result.contentHeight = contentHeight;
			result.viewPortWidth = viewPortWidthPixels;
			result.viewPortHeight = viewPortHeightPixels;
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
			result.x = 0;
			result.y = 0;
			return result;
		}

		/**
		 * @private
		 */
		protected function layoutItems(items:Vector.<DisplayObject>, boundsX:Number, boundsY:Number, viewPortWidthPixels:Number):Number
		{
			const columnWidth:Number = ((viewPortWidthPixels + this._columnGap) / this._columnCount) - this._columnGap;
			var totalOffset:int = 0;
			var yPosition:Number = boundsY;
			var maxRowHeight:Number = 0;
			const itemCount:int = items.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:DisplayObject = items[i];
				var layoutData:MultiColumnGridLayoutData = null;
				if(item is ILayoutDisplayObject)
				{
					var layoutItem:ILayoutDisplayObject = ILayoutDisplayObject(item);
					if(!layoutItem.includeInLayout)
					{
						continue;
					}

					layoutData = layoutItem.layoutData as MultiColumnGridLayoutData;
				}
				var span:int = this.getSpanFromData(layoutData);
				span = Math.min(this._columnCount, span);
				var offset:int = this.getOffsetFromData(layoutData);
				offset = Math.min(this._columnCount - span, offset);
				if(totalOffset + offset + span > this._columnCount)
				{
					totalOffset = 0;
					yPosition += maxRowHeight + this._rowGap;
					maxRowHeight = 0;
				}
				totalOffset += offset;
				this.fillColumns(item, span, totalOffset, columnWidth, boundsX, yPosition);
				totalOffset += span;
				if(!isNaN(item.height))
				{
					maxRowHeight = Math.max(maxRowHeight, item.height);
				}
				if(layoutData && layoutData.forceEndOfRow)
				{
					totalOffset = 0;
					yPosition += maxRowHeight + this._rowGap;
					maxRowHeight = 0;
				}
			}
			if(maxRowHeight == 0)
			{
				yPosition -= this._rowGap;
			}
			yPosition -= boundsY;
			return yPosition + maxRowHeight;
		}

		/**
		 * @private
		 */
		protected function getSpanFromData(layoutData:MultiColumnGridLayoutData):int
		{
			if(!layoutData)
			{
				return 1;
			}

			return layoutData.getSpan();
		}

		/**
		 * @private
		 */
		protected function getOffsetFromData(layoutData:MultiColumnGridLayoutData):int
		{
			if(!layoutData)
			{
				return 0;
			}

			return layoutData.getOffset();
		}

		/**
		 * @private
		 */
		protected function fillColumns(item:DisplayObject, span:int, offset:int, columnWidth:Number, boundsX:Number, yPosition:Number):void
		{
			item.x = boundsX + (offset == 0 ? 0 : ((columnWidth + this._columnGap) * offset));
			item.y = yPosition;
			item.width = span == 0 ? 0 : ((columnWidth + this._columnGap) * span) - this._columnGap;
		}
	}
}
