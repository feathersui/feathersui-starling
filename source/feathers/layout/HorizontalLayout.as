/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.layout
{
	import feathers.core.IFeathersControl;

	import flash.errors.IllegalOperationError;
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
	 * Positions items from left to right in a single row.
	 *
	 * @see http://wiki.starling-framework.org/feathers/horizontal-layout
	 */
	public class HorizontalLayout extends EventDispatcher implements IVariableVirtualLayout, ITrimmedVirtualLayout
	{
		/**
		 * The items will be aligned to the top of the bounds.
		 *
		 * @see #verticalAlign
		 */
		public static const VERTICAL_ALIGN_TOP:String = "top";

		/**
		 * The items will be aligned to the middle of the bounds.
		 *
		 * @see #verticalAlign
		 */
		public static const VERTICAL_ALIGN_MIDDLE:String = "middle";

		/**
		 * The items will be aligned to the bottom of the bounds.
		 *
		 * @see #verticalAlign
		 */
		public static const VERTICAL_ALIGN_BOTTOM:String = "bottom";

		/**
		 * The items will fill the height of the bounds.
		 *
		 * @see #verticalAlign
		 */
		public static const VERTICAL_ALIGN_JUSTIFY:String = "justify";

		/**
		 * If the total item width is smaller than the width of the bounds, the
		 * items will be aligned to the left.
		 *
		 * @see #horizontalAlign
		 */
		public static const HORIZONTAL_ALIGN_LEFT:String = "left";

		/**
		 * If the total item width is smaller than the width of the bounds, the
		 * items will be aligned to the center.
		 *
		 * @see #horizontalAlign
		 */
		public static const HORIZONTAL_ALIGN_CENTER:String = "center";

		/**
		 * If the total item width is smaller than the width of the bounds, the
		 * items will be aligned to the right.
		 *
		 * @see #horizontalAlign
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
		 * The minimum space, in pixels, above the items.
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
		 * The space, in pixels, after the last item.
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
		 * The minimum space, in pixels, above the items.
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
		 * The space, in pixels, before the first item.
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

		[Inspectable(type="String",enumeration="top,middle,bottom,justify")]
		/**
		 * The alignment of the items vertically, on the y-axis.
		 *
		 * @default HorizontalLayout.VERTICAL_ALIGN_TOP
		 *
		 * @see #VERTICAL_ALIGN_TOP
		 * @see #VERTICAL_ALIGN_MIDDLE
		 * @see #VERTICAL_ALIGN_BOTTOM
		 * @see #VERTICAL_ALIGN_JUSTIFY
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
		 *
		 * @default HorizontalLayout.HORIZONTAL_ALIGN_LEFT
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
		 * @inheritDoc
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
		protected var _resetTypicalItemDimensionsOnMeasure:Boolean = false;

		/**
		 * If set to <code>true</code>, the width and height of the
		 * <code>typicalItem</code> will be reset to <code>typicalItemWidth</code>
		 * and <code>typicalItemHeight</code>, respectively, whenever the
		 * typical item needs to be measured. The measured dimensions of the
		 * typical item are used to fill in the blanks of a virtualized layout
		 * for virtual items that don't have their own display objects to
		 * measure yet.
		 *
		 * @default false
		 *
		 * @see #typicalItemWidth
		 * @see #typicalItemHeight
		 * @see #typicalItem
		 */
		public function get resetTypicalItemDimensionsOnMeasure():Boolean
		{
			return this._resetTypicalItemDimensionsOnMeasure;
		}

		/**
		 * @private
		 */
		public function set resetTypicalItemDimensionsOnMeasure(value:Boolean):void
		{
			if(this._resetTypicalItemDimensionsOnMeasure == value)
			{
				return;
			}
			this._resetTypicalItemDimensionsOnMeasure = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _typicalItemWidth:Number = NaN;

		/**
		 * Used to reset the width, in pixels, of the <code>typicalItem</code>
		 * for measurement. The measured dimensions of the typical item are used
		 * to fill in the blanks of a virtualized layout for virtual items that
		 * don't have their own display objects to measure yet.
		 *
		 * <p>This value is only used when <code>resetTypicalItemDimensionsOnMeasure</code>
		 * is set to <code>true</code>. If <code>resetTypicalItemDimensionsOnMeasure</code>
		 * is set to <code>false</code>, this value will be ignored and the
		 * <code>typicalItem</code> dimensions will not be reset before
		 * measurement.</p>
		 *
		 * <p>If <code>typicalItemWidth</code> is set to <code>NaN</code>, the
		 * typical item will auto-size itself to its preferred width. If you
		 * pass a valid <code>Number</code> value, the typical item's width will
		 * be set to a fixed size. May be used in combination with
		 * <code>typicalItemHeight</code>.</p>
		 *
		 * @default NaN
		 *
		 * @see #resetTypicalItemDimensionsOnMeasure
		 * @see #typicalItemHeight
		 * @see #typicalItem
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
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _typicalItemHeight:Number = NaN;

		/**
		 * Used to reset the height, in pixels, of the <code>typicalItem</code>
		 * for measurement. The measured dimensions of the typical item are used
		 * to fill in the blanks of a virtualized layout for virtual items that
		 * don't have their own display objects to measure yet.
		 *
		 * <p>This value is only used when <code>resetTypicalItemDimensionsOnMeasure</code>
		 * is set to <code>true</code>. If <code>resetTypicalItemDimensionsOnMeasure</code>
		 * is set to <code>false</code>, this value will be ignored and the
		 * <code>typicalItem</code> dimensions will not be reset before
		 * measurement.</p>
		 *
		 * <p>If <code>typicalItemHeight</code> is set to <code>NaN</code>, the
		 * typical item will auto-size itself to its preferred height. If you
		 * pass a valid <code>Number</code> value, the typical item's height will
		 * be set to a fixed size. May be used in combination with
		 * <code>typicalItemWidth</code>.</p>
		 *
		 * @default NaN
		 *
		 * @see #resetTypicalItemDimensionsOnMeasure
		 * @see #typicalItemWidth
		 * @see #typicalItem
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
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _scrollPositionHorizontalAlign:String = HORIZONTAL_ALIGN_CENTER;

		[Inspectable(type="String",enumeration="left,center,right")]
		/**
		 * When the scroll position is calculated for an item, an attempt will
		 * be made to align the item to this position.
		 *
		 * @default HorizontalLayout.HORIZONTAL_ALIGN_CENTER
		 *
		 * @see #HORIZONTAL_ALIGN_LEFT
		 * @see #HORIZONTAL_ALIGN_CENTER
		 * @see #HORIZONTAL_ALIGN_RIGHT
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

			if(this._useVirtualLayout)
			{
				this.prepareTypicalItem(explicitHeight - this._paddingTop - this._paddingBottom);
				var calculatedTypicalItemWidth:Number = this._typicalItem ? this._typicalItem.width : 0;
				var calculatedTypicalItemHeight:Number = this._typicalItem ? this._typicalItem.height : 0;
			}

			if(!this._useVirtualLayout || this._hasVariableItemDimensions ||
				this._verticalAlign != VERTICAL_ALIGN_JUSTIFY || isNaN(explicitHeight))
			{
				this.validateItems(items, explicitHeight - this._paddingTop - this._paddingBottom);
			}

			this._discoveredItemsCache.length = 0;
			var maxItemHeight:Number = this._useVirtualLayout ? calculatedTypicalItemHeight : 0;
			var positionX:Number = boundsX + this._paddingLeft;
			if(this._useVirtualLayout && !this._hasVariableItemDimensions)
			{
				positionX += (this._beforeVirtualizedItemCount * (calculatedTypicalItemWidth + this._gap));
			}
			const itemCount:int = items.length;
			var discoveredItemsCacheLastIndex:int = 0;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:DisplayObject = items[i];
				var iNormalized:int = i + this._beforeVirtualizedItemCount;
				if(this._useVirtualLayout && this._hasVariableItemDimensions)
				{
					var cachedWidth:Number = this._widthCache[iNormalized];
				}
				if(this._useVirtualLayout && !item)
				{
					if(!this._hasVariableItemDimensions || isNaN(cachedWidth))
					{
						positionX += calculatedTypicalItemWidth + this._gap;
					}
					else
					{
						positionX += cachedWidth + this._gap;
					}
				}
				else
				{
					if(item is ILayoutDisplayObject && !ILayoutDisplayObject(item).includeInLayout)
					{
						continue;
					}
					item.x = positionX;
					var itemWidth:Number = item.width;
					var itemHeight:Number = item.height;
					if(this._useVirtualLayout)
					{
						if(this._hasVariableItemDimensions)
						{
							if(itemWidth != cachedWidth)
							{
								this._widthCache[iNormalized] = itemWidth;
								this.dispatchEventWith(Event.CHANGE);
							}
						}
						else if(calculatedTypicalItemWidth >= 0)
						{
							item.width = itemWidth = calculatedTypicalItemWidth;
						}
					}
					positionX += itemWidth + this._gap;
					if(itemHeight > maxItemHeight)
					{
						maxItemHeight = itemHeight;
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
				positionX += (this._afterVirtualizedItemCount * (calculatedTypicalItemWidth + this._gap));
			}

			const discoveredItems:Vector.<DisplayObject> = this._useVirtualLayout ? this._discoveredItemsCache : items;
			const discoveredItemCount:int = discoveredItems.length;

			const totalHeight:Number = maxItemHeight + this._paddingTop + this._paddingBottom;
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
			const totalWidth:Number = positionX - this._gap + this._paddingRight - boundsX;
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
						if(item is ILayoutDisplayObject && !ILayoutDisplayObject(item).includeInLayout)
						{
							continue;
						}
						item.x += horizontalAlignOffsetX;
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
				if(this.manageVisibility)
				{
					item.visible = ((item.x + item.width) >= (boundsX + scrollX)) && (item.x < (scrollX + availableWidth));
				}
			}
			this._discoveredItemsCache.length = 0;

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
			if(!this._useVirtualLayout)
			{
				throw new IllegalOperationError("measureViewPort() may be called only if useVirtualLayout is true.")
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

			this.prepareTypicalItem(explicitHeight - this._paddingTop - this._paddingBottom);
			var calculatedTypicalItemWidth:Number = this._typicalItem ? this._typicalItem.width : 0;
			var calculatedTypicalItemHeight:Number = this._typicalItem ? this._typicalItem.height : 0;

			var maxItemHeight:Number = calculatedTypicalItemHeight;
			var positionX:Number = 0;

			if(!this._hasVariableItemDimensions)
			{
				positionX += ((calculatedTypicalItemWidth + this._gap) * itemCount);
			}
			else
			{
				for(var i:int = 0; i < itemCount; i++)
				{
					if(isNaN(this._widthCache[i]))
					{
						positionX += calculatedTypicalItemWidth + this._gap;
					}
					else
					{
						positionX += this._widthCache[i] + this._gap;
					}
				}
			}

			if(needsWidth)
			{
				var resultWidth:Number = positionX - this._gap + this._paddingLeft + this._paddingRight;
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
				var resultHeight:Number = maxItemHeight + this._paddingTop + this._paddingBottom;
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
		public function addToVariableVirtualCacheAtIndex(index:int, item:DisplayObject = null):void
		{
			const widthValue:* = item ? item.width : undefined;
			this._widthCache.splice(index, 0, widthValue);
		}

		/**
		 * @inheritDoc
		 */
		public function removeFromVariableVirtualCacheAtIndex(index:int):void
		{
			this._widthCache.splice(index, 1);
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

			this.prepareTypicalItem(height - this._paddingTop - this._paddingBottom);
			var calculatedTypicalItemWidth:Number = this._typicalItem ? this._typicalItem.width : 0;
			var calculatedTypicalItemHeight:Number = this._typicalItem ? this._typicalItem.height : 0;

			var resultLastIndex:int = 0;
			const visibleTypicalItemCount:int = Math.ceil(width / (calculatedTypicalItemWidth + this._gap));
			if(!this._hasVariableItemDimensions)
			{
				//this case can be optimized because we know that every item has
				//the same width
				var totalItemWidth:Number = itemCount * (calculatedTypicalItemWidth + this._gap) - this._gap;
				var indexOffset:int = 0;
				if(totalItemWidth < width)
				{
					if(this._horizontalAlign == HORIZONTAL_ALIGN_RIGHT)
					{
						indexOffset = Math.ceil((width - totalItemWidth) / (calculatedTypicalItemWidth + this._gap));
					}
					else if(this._horizontalAlign == HORIZONTAL_ALIGN_CENTER)
					{
						indexOffset = Math.ceil(((width - totalItemWidth) / (calculatedTypicalItemWidth + this._gap)) / 2);
					}
				}
				var minimum:int = (scrollX - this._paddingLeft) / (calculatedTypicalItemWidth + this._gap);
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
			const maxPositionX:Number = scrollX + width;
			var positionX:Number = this._paddingLeft;
			for(i = 0; i < itemCount; i++)
			{
				if(isNaN(this._widthCache[i]))
				{
					var itemWidth:Number = calculatedTypicalItemWidth;
				}
				else
				{
					itemWidth = this._widthCache[i];
				}
				var oldPositionX:Number = positionX;
				positionX += itemWidth + this._gap;
				if(positionX > scrollX && oldPositionX < maxPositionX)
				{
					result[resultLastIndex] = i;
					resultLastIndex++;
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
			resultLastIndex = resultLength;
			visibleItemCountDifference = visibleTypicalItemCount - resultLength;
			if(visibleItemCountDifference > 0)
			{
				//add extra items after the last index
				const startIndex:int = resultLength > 0 ? (result[resultLength - 1] + 1) : 0;
				var endIndex:int = Math.min(itemCount, startIndex + visibleItemCountDifference);
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

			if(this._useVirtualLayout)
			{
				this.prepareTypicalItem(height - this._paddingTop - this._paddingBottom);
				var calculatedTypicalItemWidth:Number = this._typicalItem ? this._typicalItem.width : 0;
				var calculatedTypicalItemHeight:Number = this._typicalItem ? this._typicalItem.height : 0;
			}

			var positionX:Number = x + this._paddingLeft;
			var startIndexOffset:int = 0;
			var endIndexOffset:Number = 0;
			if(this._useVirtualLayout && !this._hasVariableItemDimensions)
			{
				startIndexOffset = this._beforeVirtualizedItemCount;
				positionX += (this._beforeVirtualizedItemCount * (calculatedTypicalItemWidth + this._gap));

				endIndexOffset = index - items.length - this._beforeVirtualizedItemCount + 1;
				if(endIndexOffset < 0)
				{
					endIndexOffset = 0;
				}
				positionX += (endIndexOffset * (calculatedTypicalItemWidth + this._gap));
			}
			index -= (startIndexOffset + endIndexOffset);
			var lastWidth:Number = 0;
			for(var i:int = 0; i <= index; i++)
			{
				var item:DisplayObject = items[i];
				if(this._useVirtualLayout && this._hasVariableItemDimensions)
				{
					var cachedWidth:Number = this._widthCache[iNormalized];
				}
				var iNormalized:int = i + startIndexOffset;
				if(this._useVirtualLayout && !item)
				{
					if(!this._hasVariableItemDimensions || isNaN(cachedWidth))
					{
						lastWidth = calculatedTypicalItemWidth;
					}
					else
					{
						lastWidth = cachedWidth;
					}
				}
				else
				{
					var itemWidth:Number = item.width;
					if(this._useVirtualLayout)
					{
						if(this._hasVariableItemDimensions)
						{
							if(isNaN(cachedWidth))
							{
								this._widthCache[iNormalized] = itemWidth;
								this.dispatchEventWith(Event.CHANGE);
							}
						}
						else if(calculatedTypicalItemWidth >= 0)
						{
							item.width = itemWidth = calculatedTypicalItemWidth;
						}
					}
					lastWidth = itemWidth;
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

		/**
		 * @private
		 */
		protected function validateItems(items:Vector.<DisplayObject>, justifyHeight:Number):void
		{
			//if the alignment is justified, then we want to set the height of
			//each item before validating because setting one dimension may
			//cause the other dimension to change, and that will invalidate the
			//layout if it happens after validation, causing more invalidation
			var mustSetJustifyHeight:Boolean = this._verticalAlign == VERTICAL_ALIGN_JUSTIFY && !isNaN(justifyHeight);

			const itemCount:int = items.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:DisplayObject = items[i];
				if(!item || (item is ILayoutDisplayObject && !ILayoutDisplayObject(item).includeInLayout))
				{
					continue;
				}
				if(mustSetJustifyHeight)
				{
					item.height = justifyHeight;
				}
				if(item is IFeathersControl)
				{
					IFeathersControl(item).validate()
				}
			}
		}

		/**
		 * @private
		 */
		protected function prepareTypicalItem(justifyHeight:Number):void
		{
			if(!this._typicalItem)
			{
				return;
			}
			if(this._resetTypicalItemDimensionsOnMeasure)
			{
				this._typicalItem.width = this._typicalItemWidth;
			}
			if(this._verticalAlign == VERTICAL_ALIGN_JUSTIFY && !isNaN(justifyHeight))
			{
				this._typicalItem.height = justifyHeight;
			}
			else if(this._resetTypicalItemDimensionsOnMeasure)
			{
				this._typicalItem.height = this._typicalItemHeight;
			}
			if(this._typicalItem is IFeathersControl)
			{
				IFeathersControl(this._typicalItem).validate();
			}
		}
	}
}
