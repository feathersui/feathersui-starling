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
	 * Positions items as tiles (equal width and height) from top to bottom
	 * in multiple columns. Constrained to the suggested height, the tiled
	 * columns layout will change in width as the number of items increases or
	 * decreases.
	 *
	 * @see http://wiki.starling-framework.org/feathers/tiled-columns-layout
	 */
	public class TiledColumnsLayout extends EventDispatcher implements IVirtualLayout
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
		 * If an item height is smaller than the height of a tile, the item will
		 * be aligned to the top edge of the tile.
		 *
		 * @see #tileVerticalAlign
		 */
		public static const TILE_VERTICAL_ALIGN_TOP:String = "top";

		/**
		 * If an item height is smaller than the height of a tile, the item will
		 * be aligned to the middle of the tile.
		 *
		 * @see #tileVerticalAlign
		 */
		public static const TILE_VERTICAL_ALIGN_MIDDLE:String = "middle";

		/**
		 * If an item height is smaller than the height of a tile, the item will
		 * be aligned to the bottom edge of the tile.
		 *
		 * @see #tileVerticalAlign
		 */
		public static const TILE_VERTICAL_ALIGN_BOTTOM:String = "bottom";

		/**
		 * The item will be resized to fit the height of the tile.
		 *
		 * @see #tileVerticalAlign
		 */
		public static const TILE_VERTICAL_ALIGN_JUSTIFY:String = "justify";

		/**
		 * If an item width is smaller than the width of a tile, the item will
		 * be aligned to the left edge of the tile.
		 *
		 * @see #tileHorizontalAlign
		 */
		public static const TILE_HORIZONTAL_ALIGN_LEFT:String = "left";

		/**
		 * If an item width is smaller than the width of a tile, the item will
		 * be aligned to the center of the tile.
		 *
		 * @see #tileHorizontalAlign
		 */
		public static const TILE_HORIZONTAL_ALIGN_CENTER:String = "center";

		/**
		 * If an item width is smaller than the width of a tile, the item will
		 * be aligned to the right edge of the tile.
		 *
		 * @see #tileHorizontalAlign
		 */
		public static const TILE_HORIZONTAL_ALIGN_RIGHT:String = "right";

		/**
		 * The item will be resized to fit the width of the tile.
		 *
		 * @see #tileHorizontalAlign
		 */
		public static const TILE_HORIZONTAL_ALIGN_JUSTIFY:String = "justify";

		/**
		 * The items will be positioned in pages horizontally from left to right.
		 *
		 * @see #paging
		 */
		public static const PAGING_HORIZONTAL:String = "horizontal";

		/**
		 * The items will be positioned in pages vertically from top to bottom.
		 *
		 * @see #paging
		 */
		public static const PAGING_VERTICAL:String = "vertical";

		/**
		 * The items will not be paged. In other words, they will be positioned
		 * in a continuous set of columns without gaps.
		 *
		 * @see #paging
		 */
		public static const PAGING_NONE:String = "none";

		/**
		 * Constructor.
		 */
		public function TiledColumnsLayout()
		{
		}

		/**
		 * @private
		 */
		protected var _discoveredItemsCache:Vector.<DisplayObject> = new <DisplayObject>[];

		/**
		 * Quickly sets both <code>horizontalGap</code> and <code>verticalGap</code>
		 * to the same value. The <code>gap</code> getter always returns the
		 * value of <code>verticalGap</code>, but the value of
		 * <code>horizontalGap</code> may be different.
		 *
		 * @default 0
		 *
		 * @see #horizontalGap
		 * @see #verticalGap
		 */
		public function get gap():Number
		{
			return this._verticalGap;
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
		 * The horizontal space, in pixels, between tiles.
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
		 * The vertical space, in pixels, between tiles.
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
		 * The space, in pixels, above of items.
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
		 * The space, in pixels, to the right of the items.
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
		 * The space, in pixels, below the items.
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
		 * The space, in pixels, to the left of the items.
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
		 * If the total column height is less than the bounds, the items in the
		 * column can be aligned vertically.
		 *
		 * @default TiledColumnsLayout.VERTICAL_ALIGN_TOP
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
		protected var _horizontalAlign:String = HORIZONTAL_ALIGN_CENTER;

		[Inspectable(type="String",enumeration="left,center,right")]
		/**
		 * If the total row width is less than the bounds, the items in the row
		 * can be aligned horizontally.
		 *
		 * @default TiledColumnsLayout.HORIZONTAL_ALIGN_CENTER
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
		protected var _tileVerticalAlign:String = TILE_VERTICAL_ALIGN_MIDDLE;

		[Inspectable(type="String",enumeration="top,middle,bottom,justify")]
		/**
		 * If an item's height is less than the tile bounds, the position of the
		 * item can be aligned vertically.
		 *
		 * @default TiledColumnsLayout.TILE_VERTICAL_ALIGN_MIDDLE
		 *
		 * @see #TILE_VERTICAL_ALIGN_TOP
		 * @see #TILE_VERTICAL_ALIGN_MIDDLE
		 * @see #TILE_VERTICAL_ALIGN_BOTTOM
		 * @see #TILE_VERTICAL_ALIGN_JUSTIFY
		 */
		public function get tileVerticalAlign():String
		{
			return this._tileVerticalAlign;
		}

		/**
		 * @private
		 */
		public function set tileVerticalAlign(value:String):void
		{
			if(this._tileVerticalAlign == value)
			{
				return;
			}
			this._tileVerticalAlign = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _tileHorizontalAlign:String = TILE_HORIZONTAL_ALIGN_CENTER;

		[Inspectable(type="String",enumeration="left,center,right,justify")]
		/**
		 * If the item's width is less than the tile bounds, the position of the
		 * item can be aligned horizontally.
		 *
		 * @default TiledColumnsLayout.TILE_HORIZONTAL_ALIGN_CENTER
		 *
		 * @see #TILE_HORIZONTAL_ALIGN_LEFT
		 * @see #TILE_HORIZONTAL_ALIGN_CENTER
		 * @see #TILE_HORIZONTAL_ALIGN_RIGHT
		 * @see #TILE_HORIZONTAL_ALIGN_JUSTIFY
		 */
		public function get tileHorizontalAlign():String
		{
			return this._tileHorizontalAlign;
		}

		/**
		 * @private
		 */
		public function set tileHorizontalAlign(value:String):void
		{
			if(this._tileHorizontalAlign == value)
			{
				return;
			}
			this._tileHorizontalAlign = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _paging:String = PAGING_NONE;

		/**
		 * If the total combined width of the columns is larger than the width
		 * of the view port, the layout will be split into pages where each
		 * page is filled with the maximum number of columns that may be
		 * displayed without cutting off any items.
		 *
		 * @default TiledColumnsLayout.PAGING_NONE
		 *
		 * @see #PAGING_NONE
		 * @see #PAGING_HORIZONTAL
		 * @see #PAGING_VERTICAL
		 */
		public function get paging():String
		{
			return this._paging;
		}

		/**
		 * @private
		 */
		public function set paging(value:String):void
		{
			if(this._paging == value)
			{
				return;
			}
			this._paging = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _useSquareTiles:Boolean = true;

		/**
		 * Determines if the tiles must be square or if their width and height
		 * may have different values.
		 *
		 * @default true
		 */
		public function get useSquareTiles():Boolean
		{
			return this._useSquareTiles;
		}

		/**
		 * @private
		 */
		public function set useSquareTiles(value:Boolean):void
		{
			if(this._useSquareTiles == value)
			{
				return;
			}
			this._useSquareTiles = value;
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
		protected var _typicalItemWidth:Number = 0;

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
		protected var _typicalItemHeight:Number = 0;

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
		 * @inheritDoc
		 */
		public function layout(items:Vector.<DisplayObject>, viewPortBounds:ViewPortBounds = null, result:LayoutBoundsResult = null):LayoutBoundsResult
		{
			if(!result)
			{
				result = new LayoutBoundsResult();
			}
			if(items.length == 0)
			{
				result.contentWidth = 0;
				result.contentHeight = 0;
				result.viewPortWidth = 0;
				result.viewPortHeight = 0;
				return result;
			}

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

			if(!this._useSquareTiles || !this._useVirtualLayout)
			{
				this.validateItems(items);
			}

			this._discoveredItemsCache.length = 0;
			const itemCount:int = items.length;
			var tileWidth:Number = this._typicalItemWidth;
			var tileHeight:Number = this._typicalItemHeight;
			//a virtual layout assumes that all items are the same size as
			//the typical item, so we don't need to measure every item in
			//that case
			if(!this._useVirtualLayout)
			{
				for(var i:int = 0; i < itemCount; i++)
				{
					var item:DisplayObject = items[i];
					if(!item)
					{
						continue;
					}
					if(item is ILayoutDisplayObject && !ILayoutDisplayObject(item).includeInLayout)
					{
						continue;
					}
					var itemWidth:Number = item.width;
					var itemHeight:Number = item.height;
					if(itemWidth > tileWidth)
					{
						tileWidth = itemWidth;
					}
					if(itemHeight > tileHeight)
					{
						tileHeight = itemHeight;
					}
				}
			}
			if(tileWidth < 0)
			{
				tileWidth = 0;
			}
			if(tileHeight < 0)
			{
				tileHeight = 0;
			}
			if(this._useSquareTiles)
			{
				if(tileWidth > tileHeight)
				{
					tileHeight = tileWidth;
				}
				else if(tileHeight > tileWidth)
				{
					tileWidth = tileHeight;
				}
			}

			var availableWidth:Number = NaN;
			var availableHeight:Number = NaN;

			var horizontalTileCount:int = 1;
			if(!isNaN(explicitWidth))
			{
				availableWidth = explicitWidth;
				horizontalTileCount = (explicitWidth - this._paddingLeft - this._paddingRight + this._horizontalGap) / (tileWidth + this._horizontalGap);
			}
			else if(!isNaN(maxWidth))
			{
				availableWidth = maxWidth;
				horizontalTileCount = (maxWidth - this._paddingLeft - this._paddingRight + this._horizontalGap) / (tileWidth + this._horizontalGap);
			}
			if(horizontalTileCount < 1)
			{
				horizontalTileCount = 1;
			}
			var verticalTileCount:int = itemCount;
			if(!isNaN(explicitHeight))
			{
				availableHeight = explicitHeight;
				verticalTileCount = (explicitHeight - this._paddingTop - this._paddingBottom + this._verticalGap) / (tileHeight + this._verticalGap);
			}
			else if(!isNaN(maxHeight))
			{
				availableHeight = maxHeight;
				verticalTileCount = (maxHeight - this._paddingTop - this._paddingBottom + this._verticalGap) / (tileHeight + this._verticalGap);
			}
			if(verticalTileCount < 1)
			{
				verticalTileCount = 1;
			}

			const totalPageWidth:Number = horizontalTileCount * (tileWidth + this._horizontalGap) - this._horizontalGap + this._paddingLeft + this._paddingRight;
			const totalPageHeight:Number = verticalTileCount * (tileHeight + this._verticalGap) - this._verticalGap + this._paddingTop + this._paddingBottom;
			const availablePageWidth:Number = isNaN(availableWidth) ? totalPageWidth : availableWidth;
			const availablePageHeight:Number = isNaN(availableHeight) ? totalPageHeight : availableHeight;

			const startX:Number = boundsX + this._paddingLeft;
			const startY:Number = boundsY + this._paddingTop;

			const perPage:int = horizontalTileCount * verticalTileCount;
			var pageIndex:int = 0;
			var nextPageStartIndex:int = perPage;
			var pageStartY:Number = startY;
			var positionX:Number = startX;
			var positionY:Number = startY;
			var itemIndex:int = 0;
			var discoveredItemsCachePushIndex:int = 0;
			for(i = 0; i < itemCount; i++)
			{
				item = items[i];
				if(item is ILayoutDisplayObject && !ILayoutDisplayObject(item).includeInLayout)
				{
					continue;
				}
				if(itemIndex != 0 && i % verticalTileCount == 0)
				{
					positionX += tileWidth + this._horizontalGap;
					positionY = pageStartY;
				}
				if(itemIndex == nextPageStartIndex)
				{
					//we're starting a new page, so handle alignment of the
					//items on the current page and update the positions
					if(this._paging != PAGING_NONE)
					{
						var discoveredItems:Vector.<DisplayObject> = this._useVirtualLayout ? this._discoveredItemsCache : items;
						var discoveredItemsFirstIndex:int = this._useVirtualLayout ? 0 : (itemIndex - perPage);
						var discoveredItemsLastIndex:int = this._useVirtualLayout ? (this._discoveredItemsCache.length - 1) : (itemIndex - 1);
						this.applyHorizontalAlign(discoveredItems, discoveredItemsFirstIndex, discoveredItemsLastIndex, totalPageWidth, availablePageWidth);
						this.applyVerticalAlign(discoveredItems, discoveredItemsFirstIndex, discoveredItemsLastIndex, totalPageHeight, availablePageHeight);
						if(this.manageVisibility)
						{
							this.applyVisible(discoveredItems, discoveredItemsFirstIndex, discoveredItemsLastIndex,
								boundsX + scrollX, scrollX + availableWidth, boundsY + scrollY, scrollY + availableHeight);
						}
						this._discoveredItemsCache.length = 0;
						discoveredItemsCachePushIndex = 0;
					}
					pageIndex++;
					nextPageStartIndex += perPage;

					//we can use availableWidth and availableHeight here without
					//checking if they're NaN because we will never reach a
					//new page without them already being calculated.
					if(this._paging == PAGING_HORIZONTAL)
					{
						positionX = startX + availableWidth * pageIndex;
					}
					else if(this._paging == PAGING_VERTICAL)
					{
						positionX = startX;
						positionY = pageStartY = startY + availableHeight * pageIndex;
					}
				}
				if(item)
				{
					switch(this._tileHorizontalAlign)
					{
						case TILE_HORIZONTAL_ALIGN_JUSTIFY:
						{
							item.x = positionX;
							item.width = tileWidth;
							break;
						}
						case TILE_HORIZONTAL_ALIGN_LEFT:
						{
							item.x = positionX;
							break;
						}
						case TILE_HORIZONTAL_ALIGN_RIGHT:
						{
							item.x = positionX + tileWidth - item.width;
							break;
						}
						default: //center or unknown
						{
							item.x = positionX + (tileWidth - item.width) / 2;
						}
					}
					switch(this._tileVerticalAlign)
					{
						case TILE_VERTICAL_ALIGN_JUSTIFY:
						{
							item.y = positionY;
							item.height = tileHeight;
							break;
						}
						case TILE_VERTICAL_ALIGN_TOP:
						{
							item.y = positionY;
							break;
						}
						case TILE_VERTICAL_ALIGN_BOTTOM:
						{
							item.y = positionY + tileHeight - item.height;
							break;
						}
						default: //middle or unknown
						{
							item.y = positionY + (tileHeight - item.height) / 2;
						}
					}
					if(this._useVirtualLayout)
					{
						this._discoveredItemsCache[discoveredItemsCachePushIndex] = item;
						discoveredItemsCachePushIndex++;
					}
				}
				positionY += tileHeight + this._verticalGap;
				itemIndex++;
			}
			//align the last page
			if(this._paging != PAGING_NONE)
			{
				discoveredItems = this._useVirtualLayout ? this._discoveredItemsCache : items;
				discoveredItemsFirstIndex = this._useVirtualLayout ? 0 : (nextPageStartIndex - perPage);
				discoveredItemsLastIndex = this._useVirtualLayout ? (this._discoveredItemsCache.length - 1) : (i - 1);
				this.applyHorizontalAlign(discoveredItems, discoveredItemsFirstIndex, discoveredItemsLastIndex, totalPageWidth, availablePageWidth);
				this.applyVerticalAlign(discoveredItems, discoveredItemsFirstIndex, discoveredItemsLastIndex, totalPageHeight, availablePageHeight);
				if(this.manageVisibility)
				{
					this.applyVisible(discoveredItems, discoveredItemsFirstIndex, discoveredItemsLastIndex,
						boundsX + scrollX, scrollX + availableWidth, boundsY + scrollY, scrollY + availableHeight);
				}
			}

			var totalWidth:Number = positionX + tileWidth + this._paddingRight;
			if(!isNaN(availableWidth))
			{
				if(this._paging == PAGING_VERTICAL)
				{
					totalWidth = availableWidth;
				}
				else if(this._paging == PAGING_HORIZONTAL)
				{
					totalWidth = Math.ceil(itemCount / perPage) * availableWidth;
				}
			}
			var totalHeight:Number = totalPageHeight;
			if(!isNaN(availableHeight) && this._paging == PAGING_VERTICAL)
			{
				totalHeight = Math.ceil(itemCount / perPage) * availableHeight;
			}

			if(isNaN(availableWidth))
			{
				availableWidth = totalWidth;
			}
			if(isNaN(availableHeight))
			{
				availableHeight = totalHeight;
			}
			if(availableWidth < minWidth)
			{
				availableWidth = minWidth;
			}
			if(availableHeight < minHeight)
			{
				availableHeight = minHeight;
			}

			if(this._paging == PAGING_NONE)
			{
				discoveredItems = this._useVirtualLayout ? this._discoveredItemsCache : items;
				discoveredItemsLastIndex = discoveredItems.length - 1;
				this.applyHorizontalAlign(discoveredItems, 0, discoveredItemsLastIndex, totalWidth, availableWidth);
				this.applyVerticalAlign(discoveredItems, 0, discoveredItemsLastIndex, totalHeight, availableHeight);
				if(this.manageVisibility)
				{
					this.applyVisible(discoveredItems, discoveredItemsFirstIndex, discoveredItemsLastIndex,
						boundsX + scrollX, scrollX + availableWidth, boundsY + scrollY, scrollY + availableHeight);
				}
			}
			this._discoveredItemsCache.length = 0;

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

			const boundsX:Number = viewPortBounds ? viewPortBounds.x : 0;
			const boundsY:Number = viewPortBounds ? viewPortBounds.y : 0;
			const minWidth:Number = viewPortBounds ? viewPortBounds.minWidth : 0;
			const minHeight:Number = viewPortBounds ? viewPortBounds.minHeight : 0;
			const maxWidth:Number = viewPortBounds ? viewPortBounds.maxWidth : Number.POSITIVE_INFINITY;
			const maxHeight:Number = viewPortBounds ? viewPortBounds.maxHeight : Number.POSITIVE_INFINITY;

			var tileWidth:Number = this._typicalItemWidth;
			var tileHeight:Number = this._typicalItemHeight;
			if(tileWidth < 0)
			{
				tileWidth = 0;
			}
			if(tileHeight < 0)
			{
				tileHeight = 0;
			}
			if(this._useSquareTiles)
			{
				if(tileWidth > tileHeight)
				{
					tileHeight = tileWidth;
				}
				else if(tileHeight > tileWidth)
				{
					tileWidth = tileHeight;
				}
			}
			var availableWidth:Number = NaN;
			var availableHeight:Number = NaN;
			var horizontalTileCount:int = 1;
			if(!isNaN(explicitWidth))
			{
				availableWidth = explicitWidth;
				horizontalTileCount = (explicitWidth - this._paddingLeft - this._paddingRight + this._horizontalGap) / (tileWidth + this._horizontalGap);
			}
			else if(!isNaN(maxWidth))
			{
				availableWidth = maxWidth;
				horizontalTileCount = (maxWidth - this._paddingLeft - this._paddingRight + this._horizontalGap) / (tileWidth + this._horizontalGap);
			}
			if(horizontalTileCount < 1)
			{
				horizontalTileCount = 1;
			}
			var verticalTileCount:int = itemCount;
			if(!isNaN(explicitHeight))
			{
				availableHeight = explicitHeight;
				verticalTileCount = (explicitHeight - this._paddingTop - this._paddingBottom + this._verticalGap) / (tileHeight + this._verticalGap);
			}
			else if(!isNaN(maxHeight))
			{
				availableHeight = maxHeight;
				verticalTileCount = (maxHeight - this._paddingTop - this._paddingBottom + this._verticalGap) / (tileHeight + this._verticalGap);
			}
			if(verticalTileCount < 1)
			{
				verticalTileCount = 1;
			}

			const totalPageHeight:Number = verticalTileCount * (tileHeight + this._verticalGap) - this._verticalGap + this._paddingTop + this._paddingBottom;

			const startX:Number = boundsX + this._paddingLeft;

			const perPage:int = horizontalTileCount * verticalTileCount;
			var pageIndex:int = 0;
			var nextPageStartIndex:int = perPage;
			var positionX:Number = startX;
			for(var i:int = 0; i < itemCount; i++)
			{
				if(i != 0 && i % verticalTileCount == 0)
				{
					positionX += tileWidth + this._horizontalGap;
				}
				if(i == nextPageStartIndex)
				{
					pageIndex++;
					nextPageStartIndex += perPage;

					//we can use availableWidth and availableHeight here without
					//checking if they're NaN because we will never reach a
					//new page without them already being calculated.
					if(this._paging == PAGING_HORIZONTAL)
					{
						positionX = startX + availableWidth * pageIndex;
					}
					else if(this._paging == PAGING_VERTICAL)
					{
						positionX = startX;
					}
				}
			}

			var totalWidth:Number = positionX + tileWidth + this._paddingRight;
			if(!isNaN(availableWidth))
			{
				if(this._paging == PAGING_VERTICAL)
				{
					totalWidth = availableWidth;
				}
				else if(this._paging == PAGING_HORIZONTAL)
				{
					totalWidth = Math.ceil(itemCount / perPage) * availableWidth;
				}
			}
			var totalHeight:Number = totalPageHeight;
			if(!isNaN(availableHeight) && this._paging == PAGING_VERTICAL)
			{
				totalHeight = Math.ceil(itemCount / perPage) * availableHeight;
			}

			if(needsWidth)
			{
				var resultX:Number = totalWidth;
				if(resultX < minWidth)
				{
					resultX = minWidth;
				}
				else if(resultX > maxWidth)
				{
					resultX = maxWidth;
				}
				result.x = resultX;
			}
			else
			{
				result.x = explicitWidth;
			}
			if(needsHeight)
			{
				var resultY:Number = totalHeight;
				if(resultY < minHeight)
				{
					resultY = minHeight;
				}
				else if(resultY > maxHeight)
				{
					resultY = maxHeight;
				}
				result.y = resultY;
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
			if(!result)
			{
				result = new <int>[];
			}
			result.length = 0;

			if(this._paging == PAGING_HORIZONTAL)
			{
				this.getVisibleIndicesAtScrollPositionWithHorizontalPaging(scrollX, scrollY, width, height, itemCount, result);
			}
			else if(this._paging == PAGING_VERTICAL)
			{
				this.getVisibleIndicesAtScrollPositionWithVerticalPaging(scrollX, scrollY, width, height, itemCount, result);
			}
			else
			{
				this.getVisibleIndicesAtScrollPositionWithoutPaging(scrollX, scrollY, width, height, itemCount, result);
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

			const itemCount:int = items.length;
			var tileWidth:Number = this._typicalItemWidth;
			var tileHeight:Number = this._typicalItemHeight;
			//a virtual layout assumes that all items are the same size as
			//the typical item, so we don't need to measure every item in
			//that case
			if(!this._useVirtualLayout)
			{
				for(var i:int = 0; i < itemCount; i++)
				{
					var item:DisplayObject = items[i];
					if(!item)
					{
						continue;
					}
					if(item is ILayoutDisplayObject && !ILayoutDisplayObject(item).includeInLayout)
					{
						continue;
					}
					var itemWidth:Number = item.width;
					var itemHeight:Number = item.height;
					if(itemWidth > tileWidth)
					{
						tileWidth = itemWidth;
					}
					if(itemHeight > tileHeight)
					{
						tileHeight = itemHeight;
					}
				}
			}
			if(tileWidth < 0)
			{
				tileWidth = 0;
			}
			if(tileHeight < 0)
			{
				tileHeight = 0;
			}
			if(this._useSquareTiles)
			{
				if(tileWidth > tileHeight)
				{
					tileHeight = tileWidth;
				}
				else if(tileHeight > tileWidth)
				{
					tileWidth = tileHeight;
				}
			}
			var verticalTileCount:int = (height - this._paddingTop - this._paddingBottom + this._verticalGap) / (tileHeight + this._verticalGap);
			if(verticalTileCount < 1)
			{
				verticalTileCount = 1;
			}
			if(this._paging != PAGING_NONE)
			{
				var horizontalTileCount:int = (width - this._paddingLeft - this._paddingRight + this._horizontalGap) / (tileWidth + this._horizontalGap);
				if(horizontalTileCount < 1)
				{
					horizontalTileCount = 1;
				}
				const perPage:Number = horizontalTileCount * verticalTileCount;
				const pageIndex:int = index / perPage;
				if(this._paging == PAGING_HORIZONTAL)
				{
					result.x = pageIndex * width;
					result.y = 0;
				}
				else
				{
					result.x = 0;
					result.y = pageIndex * height;
				}
			}
			else
			{
				result.x = this._paddingLeft + ((tileWidth + this._horizontalGap) * index / verticalTileCount) + (width - tileWidth) / 2;
				result.y = 0;
			}
			return result;
		}

		/**
		 * @private
		 */
		protected function applyVisible(items:Vector.<DisplayObject>, startIndex:int, endIndex:int, startX:Number, endX:Number, startY:Number, endY:Number):void
		{
			for(var i:int = startIndex; i <= endIndex; i++)
			{
				var item:DisplayObject = items[i];
				if(item is ILayoutDisplayObject && !ILayoutDisplayObject(item).includeInLayout)
				{
					continue;
				}
				var itemX:Number = item.x;
				var itemY:Number = item.y;
				item.visible = ((itemX + item.width) >= startX) && (itemX < endX) &&
					((itemY + item.height) >= startY) && (itemY < endY);
			}
		}

		/**
		 * @private
		 */
		protected function applyHorizontalAlign(items:Vector.<DisplayObject>, startIndex:int, endIndex:int, totalItemWidth:Number, availableWidth:Number):void
		{
			if(totalItemWidth >= availableWidth)
			{
				return;
			}
			var horizontalAlignOffsetX:Number = 0;
			if(this._horizontalAlign == HORIZONTAL_ALIGN_RIGHT)
			{
				horizontalAlignOffsetX = availableWidth - totalItemWidth;
			}
			else if(this._horizontalAlign != HORIZONTAL_ALIGN_LEFT)
			{
				//we're going to default to center if we encounter an
				//unknown value
				horizontalAlignOffsetX = (availableWidth - totalItemWidth) / 2;
			}
			if(horizontalAlignOffsetX != 0)
			{
				for(var i:int = startIndex; i <= endIndex; i++)
				{
					var item:DisplayObject = items[i];
					if(item is ILayoutDisplayObject && !ILayoutDisplayObject(item).includeInLayout)
					{
						continue;
					}
					item.x += horizontalAlignOffsetX;
				}
			}
		}

		/**
		 * @private
		 */
		protected function applyVerticalAlign(items:Vector.<DisplayObject>, startIndex:int, endIndex:int, totalItemHeight:Number, availableHeight:Number):void
		{
			if(totalItemHeight >= availableHeight)
			{
				return;
			}
			var verticalAlignOffsetY:Number = 0;
			if(this._verticalAlign == VERTICAL_ALIGN_BOTTOM)
			{
				verticalAlignOffsetY = availableHeight - totalItemHeight;
			}
			else if(this._verticalAlign == VERTICAL_ALIGN_MIDDLE)
			{
				verticalAlignOffsetY = (availableHeight - totalItemHeight) / 2;
			}
			if(verticalAlignOffsetY != 0)
			{
				for(var i:int = startIndex; i <= endIndex; i++)
				{
					var item:DisplayObject = items[i];
					if(item is ILayoutDisplayObject && !ILayoutDisplayObject(item).includeInLayout)
					{
						continue;
					}
					item.y += verticalAlignOffsetY;
				}
			}
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

		/**
		 * @private
		 */
		protected function getVisibleIndicesAtScrollPositionWithHorizontalPaging(scrollX:Number, scrollY:Number, width:Number, height:Number, itemCount:int, result:Vector.<int>):void
		{
			var tileWidth:Number = this._typicalItemWidth;
			var tileHeight:Number = this._typicalItemHeight;
			if(tileWidth < 0)
			{
				tileWidth = 0;
			}
			if(tileHeight < 0)
			{
				tileHeight = 0;
			}
			if(this._useSquareTiles)
			{
				if(tileWidth > tileHeight)
				{
					tileHeight = tileWidth;
				}
				else if(tileHeight > tileWidth)
				{
					tileWidth = tileHeight;
				}
			}
			var horizontalTileCount:int = (width - this._paddingLeft - this._paddingRight + this._horizontalGap) / (tileWidth + this._horizontalGap);
			if(horizontalTileCount < 1)
			{
				horizontalTileCount = 1;
			}
			var verticalTileCount:int = (height - this._paddingTop - this._paddingBottom + this._verticalGap) / (tileHeight + this._verticalGap);
			if(verticalTileCount < 1)
			{
				verticalTileCount = 1;
			}
			const perPage:int = horizontalTileCount * verticalTileCount;
			var minimumItemCount:int = perPage + 2 * verticalTileCount;
			if(minimumItemCount > itemCount)
			{
				minimumItemCount = itemCount;
			}

			var startPageIndex:int = Math.round(scrollX / width);
			var minimum:int = startPageIndex * perPage;
			var totalRowWidth:Number = horizontalTileCount * (tileWidth + this._horizontalGap) - this._horizontalGap;
			var leftSideOffset:Number = 0;
			var rightSideOffset:Number = 0;
			if(totalRowWidth < width)
			{
				if(this._horizontalAlign == HORIZONTAL_ALIGN_RIGHT)
				{
					leftSideOffset = width - this._paddingLeft - this._paddingRight - totalRowWidth;
					rightSideOffset = 0;
				}
				else if(this._horizontalAlign == HORIZONTAL_ALIGN_CENTER)
				{
					leftSideOffset = rightSideOffset = (width - this._paddingLeft - this._paddingRight - totalRowWidth) / 2;
				}
				else if(this._horizontalAlign == HORIZONTAL_ALIGN_LEFT)
				{
					leftSideOffset = 0;
					rightSideOffset = width - this._paddingLeft - this._paddingRight - totalRowWidth;
				}
			}
			var columnOffset:int = 0;
			var pageStartPosition:Number = startPageIndex * width;
			var partialPageSize:Number = scrollX - pageStartPosition;
			if(partialPageSize < 0)
			{
				partialPageSize = -partialPageSize - this._paddingRight - rightSideOffset;
				if(partialPageSize < 0)
				{
					partialPageSize = 0;
				}
				columnOffset = -Math.floor(partialPageSize / (tileWidth + this._horizontalGap)) - 1;
				minimum += columnOffset * verticalTileCount;
			}
			else if(partialPageSize > 0)
			{
				partialPageSize = partialPageSize - this._paddingLeft - leftSideOffset;
				if(partialPageSize < 0)
				{
					partialPageSize = 0;
				}
				columnOffset = Math.floor(partialPageSize / (tileWidth + this._horizontalGap));
				minimum += columnOffset * verticalTileCount;
			}
			if(minimum < 0)
			{
				minimum = 0;
				columnOffset = 0;
			}

			var maximum:int = minimum + minimumItemCount;
			if(maximum > itemCount)
			{
				maximum = itemCount;
			}
			minimum = maximum - minimumItemCount;
			var resultPushIndex:int = result.length;
			for(var i:int = minimum; i < maximum; i++)
			{
				result[resultPushIndex] = i;
				resultPushIndex++;
			}
		}

		/**
		 * @private
		 */
		protected function getVisibleIndicesAtScrollPositionWithVerticalPaging(scrollX:Number, scrollY:Number, width:Number, height:Number, itemCount:int, result:Vector.<int>):void
		{
			var tileWidth:Number = this._typicalItemWidth;
			var tileHeight:Number = this._typicalItemHeight;
			if(tileWidth < 0)
			{
				tileWidth = 0;
			}
			if(tileHeight < 0)
			{
				tileHeight = 0;
			}
			if(this._useSquareTiles)
			{
				if(tileWidth > tileHeight)
				{
					tileHeight = tileWidth;
				}
				else if(tileHeight > tileWidth)
				{
					tileWidth = tileHeight;
				}
			}
			var horizontalTileCount:int = (width - this._paddingLeft - this._paddingRight + this._horizontalGap) / (tileWidth + this._horizontalGap);
			if(horizontalTileCount < 1)
			{
				horizontalTileCount = 1;
			}
			var verticalTileCount:int = (height - this._paddingTop - this._paddingBottom + this._verticalGap) / (tileHeight + this._verticalGap);
			if(verticalTileCount < 1)
			{
				verticalTileCount = 1;
			}
			const perPage:int = horizontalTileCount * verticalTileCount;
			var minimumItemCount:int = perPage + 2 * verticalTileCount;
			if(minimumItemCount > itemCount)
			{
				minimumItemCount = itemCount;
			}

			var startPageIndex:int = Math.round(scrollY / height);
			var minimum:int = startPageIndex * perPage;
			var totalColumnHeight:Number = verticalTileCount * (tileHeight + this._verticalGap) - this._verticalGap;
			var topSideOffset:Number = 0;
			var bottomSideOffset:Number = 0;
			if(totalColumnHeight < height)
			{
				if(this._verticalAlign == VERTICAL_ALIGN_BOTTOM)
				{
					topSideOffset = height - this._paddingTop - this._paddingBottom - totalColumnHeight;
					bottomSideOffset = 0;
				}
				else if(this._horizontalAlign == VERTICAL_ALIGN_MIDDLE)
				{
					topSideOffset = bottomSideOffset = (height - this._paddingTop - this._paddingBottom - totalColumnHeight) / 2;
				}
				else if(this._horizontalAlign == VERTICAL_ALIGN_TOP)
				{
					topSideOffset = 0;
					bottomSideOffset = height - this._paddingTop - this._paddingBottom - totalColumnHeight;
				}
			}
			var rowOffset:int = 0;
			var pageStartPosition:Number = startPageIndex * height;
			var partialPageSize:Number = scrollY - pageStartPosition;
			if(partialPageSize < 0)
			{
				partialPageSize = -partialPageSize - this._paddingBottom - bottomSideOffset;
				if(partialPageSize < 0)
				{
					partialPageSize = 0;
				}
				rowOffset = -Math.floor(partialPageSize / (tileWidth + this._verticalGap)) - 1;
				minimum += -perPage + horizontalTileCount + rowOffset;
			}
			else if(partialPageSize > 0)
			{
				partialPageSize = partialPageSize - this._paddingTop - topSideOffset;
				if(partialPageSize < 0)
				{
					partialPageSize = 0;
				}
				rowOffset = Math.floor(partialPageSize / (tileWidth + this._verticalGap));
				minimum += rowOffset;
			}
			if(minimum < 0)
			{
				minimum = 0;
				rowOffset = 0;
			}

			if(minimum + minimumItemCount >= itemCount)
			{
				//an optimized path when we're on or near the last page
				minimum = itemCount - minimumItemCount;
				var resultPushIndex:int = result.length;
				for(var i:int = minimum; i < itemCount; i++)
				{
					result[resultPushIndex] = i;
					resultPushIndex++;
				}
			}
			else
			{
				var columnIndex:int = 0;
				var rowIndex:int = (verticalTileCount + rowOffset) % verticalTileCount;
				var pageStart:int = int(minimum / perPage) * perPage;
				i = minimum;
				var resultLength:int = 0;
				do
				{
					if(i < itemCount)
					{
						result[resultLength] = i;
						resultLength++;
					}
					columnIndex++;
					if(columnIndex == horizontalTileCount)
					{
						columnIndex = 0;
						rowIndex++;
						if(rowIndex == verticalTileCount)
						{
							rowIndex = 0;
							pageStart += perPage;
						}
						i = pageStart + rowIndex - verticalTileCount;
					}
					i += verticalTileCount;
				}
				while(resultLength < minimumItemCount && pageStart < itemCount)
			}
		}

		/**
		 * @private
		 */
		protected function getVisibleIndicesAtScrollPositionWithoutPaging(scrollX:Number, scrollY:Number, width:Number, height:Number, itemCount:int, result:Vector.<int>):void
		{
			var tileWidth:Number = this._typicalItemWidth;
			var tileHeight:Number = this._typicalItemHeight;
			if(tileWidth < 0)
			{
				tileWidth = 0;
			}
			if(tileHeight < 0)
			{
				tileHeight = 0;
			}
			if(this._useSquareTiles)
			{
				if(tileWidth > tileHeight)
				{
					tileHeight = tileWidth;
				}
				else if(tileHeight > tileWidth)
				{
					tileWidth = tileHeight;
				}
			}
			var verticalTileCount:int = (height - this._paddingTop - this._paddingBottom + this._verticalGap) / (tileHeight + this._verticalGap);
			if(verticalTileCount < 1)
			{
				verticalTileCount = 1;
			}
			var horizontalTileCount:int = Math.ceil((width - this._paddingLeft + this._horizontalGap) / (tileWidth + this._horizontalGap)) + 1;
			var minimumItemCount:int = verticalTileCount * horizontalTileCount;
			if(minimumItemCount > itemCount)
			{
				minimumItemCount = itemCount;
			}
			var columnIndexOffset:int = 0;
			const totalColumnWidth:Number = Math.ceil(itemCount / verticalTileCount) * (tileWidth + this._horizontalGap) - this._horizontalGap;
			if(totalColumnWidth < width)
			{
				if(this._verticalAlign == VERTICAL_ALIGN_BOTTOM)
				{
					columnIndexOffset = Math.ceil((width - totalColumnWidth) / (tileWidth + this._horizontalGap));
				}
				else if(this._verticalAlign == VERTICAL_ALIGN_MIDDLE)
				{
					columnIndexOffset = Math.ceil((width - totalColumnWidth) / (tileWidth + this._horizontalGap) / 2);
				}
			}
			const columnIndex:int = -columnIndexOffset + Math.floor((scrollX - this._paddingLeft + this._horizontalGap) / (tileWidth + this._horizontalGap));
			var minimum:int = columnIndex * verticalTileCount;
			if(minimum < 0)
			{
				minimum = 0;
			}
			var maximum:int = minimum + minimumItemCount;
			if(maximum > itemCount)
			{
				maximum = itemCount;
			}
			minimum = maximum - minimumItemCount;
			var resultPushIndex:int = result.length;
			for(var i:int = minimum; i < maximum; i++)
			{
				result[resultPushIndex] = i;
				resultPushIndex++;
			}
		}
	}
}
