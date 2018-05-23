/*
Feathers
Copyright 2012-2018 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.layout
{
	import feathers.core.IFeathersControl;
	import feathers.core.IMeasureDisplayObject;
	import feathers.core.IValidating;

	import flash.errors.IllegalOperationError;
	import flash.geom.Point;
	import flash.ui.Keyboard;

	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	import starling.utils.Pool;

	/**
	 * Positions items from top to bottom in a single column.
	 *
	 * @see ../../../help/vertical-layout.html How to use VerticalLayout with Feathers containers
	 *
	 * @productversion Feathers 1.0.0
	 */
	public class VerticalLayout extends BaseLinearLayout implements IVariableVirtualLayout, ITrimmedVirtualLayout, IGroupedLayout
	{
		[Deprecated(replacement="feathers.layout.VerticalAlign.TOP",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.VerticalAlign.TOP</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const VERTICAL_ALIGN_TOP:String = "top";

		[Deprecated(replacement="feathers.layout.VerticalAlign.MIDDLE",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.VerticalAlign.MIDDLE</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const VERTICAL_ALIGN_MIDDLE:String = "middle";

		[Deprecated(replacement="feathers.layout.VerticalAlign.BOTTOM",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.VerticalAlign.BOTTOM</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const VERTICAL_ALIGN_BOTTOM:String = "bottom";

		[Deprecated(replacement="feathers.layout.HorizontalAlign.LEFT",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.HorizontalAlign.LEFT</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const HORIZONTAL_ALIGN_LEFT:String = "left";

		[Deprecated(replacement="feathers.layout.HorizontalAlign.CENTER",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.HorizontalAlign.CENTER</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const HORIZONTAL_ALIGN_CENTER:String = "center";

		[Deprecated(replacement="feathers.layout.HorizontalAlign.RIGHT",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.HorizontalAlign.RIGHT</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const HORIZONTAL_ALIGN_RIGHT:String = "right";

		[Deprecated(replacement="feathers.layout.HorizontalAlign.JUSTIFY",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.HorizontalAlign.JUSTIFY</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const HORIZONTAL_ALIGN_JUSTIFY:String = "justify";

		/**
		 * Constructor.
		 */
		public function VerticalLayout()
		{
			super();
		}

		[Bindable(event="change")]
		[Inspectable(type="String",enumeration="left,center,right,justify")]
		/**
		 * The alignment of the items horizontally, on the x-axis.
		 *
		 * <p>If the <code>horizontalAlign</code> property is set to
		 * <code>feathers.layout.HorizontalAlign.JUSTIFY</code>, the
		 * <code>width</code>, <code>minWidth</code>, and <code>maxWidth</code>
		 * properties of the items may be changed, and their original values
		 * ignored by the layout. In this situation, if the width needs to be
		 * constrained, the <code>width</code>, <code>minWidth</code>, or
		 * <code>maxWidth</code> properties should instead be set on the parent
		 * container using the layout.</p>
		 *
		 * @default feathers.layout.HorizontalAlign.LEFT
		 *
		 * @see feathers.layout.HorizontalAlign#LEFT
		 * @see feathers.layout.HorizontalAlign#CENTER
		 * @see feathers.layout.HorizontalAlign#RIGHT
		 * @see feathers.layout.HorizontalAlign#JUSTIFY
		 */
		override public function get horizontalAlign():String
		{
			//this is an override so that this class can have its own documentation.
			return this._horizontalAlign;
		}


		[Bindable(event="change")]
		[Inspectable(type="String",enumeration="top,middle,bottom")]
		/**
		 * If the total item height is less than the bounds, the positions of
		 * the items can be aligned vertically, on the y-axis.
		 *
		 * @default feathers.layout.VerticalAlign.TOP
		 *
		 * @see feathers.layout.VerticalAlign#TOP
		 * @see feathers.layout.VerticalAlign#MIDDLE
		 * @see feathers.layout.VerticalAlign#BOTTOM
		 */
		override public function get verticalAlign():String
		{
			//this is an override so that this class can have its own documentation.
			return this._verticalAlign;
		}

		/**
		 * @private
		 */
		protected var _stickyHeader:Boolean = false;

		/**
		 * If a non-null value for the <code>headerIndices</code> property is
		 * provided (by a component like <code>GroupedList</code>), and the
		 * <code>stickyHeader</code> property is set to <code>true</code>, a
		 * header will stick to the top of the view port until the current group
		 * completely scrolls out of the view port.
		 *
		 * @default false
		 */
		public function get stickyHeader():Boolean
		{
			return this._stickyHeader;
		}

		/**
		 * @private
		 */
		public function set stickyHeader(value:Boolean):void
		{
			if(this._stickyHeader == value)
			{
				return;
			}
			this._stickyHeader = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _headerIndices:Vector.<int>;

		/**
		 * @inheritDoc
		 */
		public function get headerIndices():Vector.<int>
		{
			return this._headerIndices;
		}

		/**
		 * @private
		 */
		public function set headerIndices(value:Vector.<int>):void
		{
			if(this._headerIndices == value)
			{
				return;
			}
			this._headerIndices = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _distributeHeights:Boolean = false;

		[Bindable(event="change")]
		/**
		 * Distributes the height of the view port equally to each item. If the
		 * view port height needs to be measured, the largest item's height will
		 * be used for all items, subject to any specified minimum and maximum
		 * height values.
		 *
		 * @default false
		 */
		public function get distributeHeights():Boolean
		{
			return this._distributeHeights;
		}

		/**
		 * @private
		 */
		public function set distributeHeights(value:Boolean):void
		{
			if(this._distributeHeights == value)
			{
				return;
			}
			this._distributeHeights = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _requestedRowCount:int = 0;

		[Bindable(event="change")]
		/**
		 * Requests that the layout set the view port dimensions to display a
		 * specific number of rows (plus gaps and padding), if possible. If the
		 * explicit height of the view port is set, then this value will be
		 * ignored. If the view port's minimum and/or maximum height are set,
		 * the actual number of visible rows may be adjusted to meet those
		 * requirements. Set this value to <code>0</code> to display as many
		 * rows as possible.
		 *
		 * @default 0
		 *
		 * @see #maxRowCount
		 */
		public function get requestedRowCount():int
		{
			return this._requestedRowCount;
		}

		/**
		 * @private
		 */
		public function set requestedRowCount(value:int):void
		{
			if(value < 0)
			{
				throw RangeError("requestedRowCount requires a value >= 0");
			}
			if(this._requestedRowCount == value)
			{
				return;
			}
			this._requestedRowCount = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _maxRowCount:int = 0;

		/**
		 * The maximum number of rows to display. If the explicit height of the
		 * view port is set or if <code>requestedRowCount</code> is set, then
		 * this value will be ignored. If the view port's minimum and/or maximum
		 * height are set, the actual number of visible rows may be adjusted to
		 * meet those requirements. Set this value to <code>0</code> to display
		 * as many rows as possible.
		 *
		 * @default 0
		 */
		public function get maxRowCount():int
		{
			return this._maxRowCount;
		}

		/**
		 * @private
		 */
		public function set maxRowCount(value:int):void
		{
			if(value < 0)
			{
				throw RangeError("maxRowCount requires a value >= 0");
			}
			if(this._maxRowCount == value)
			{
				return;
			}
			this._maxRowCount = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _scrollPositionVerticalAlign:String = VerticalAlign.MIDDLE;

		[Bindable(event="change")]
		[Inspectable(type="String",enumeration="top,middle,bottom")]
		/**
		 * When the scroll position is calculated for an item, an attempt will
		 * be made to align the item to this position.
		 *
		 * @default feathers.layout.VerticalAlign.MIDDLE
		 *
		 * @see feathers.layout.VerticalAlign#TOP
		 * @see feathers.layout.VerticalAlign#MIDDLE
		 * @see feathers.layout.VerticalAlign#BOTTOM
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

		[Bindable(event="change")]
		/**
		 * @private
		 */
		protected var _headerScrollPositionVerticalAlign:String = VerticalAlign.TOP;

		[Inspectable(type="String",enumeration="top,middle,bottom")]
		/**
		 * When the scroll position is calculated for a header (specified by a
		 * <code>GroupedList</code> or another component with the
		 * <code>headerIndicies</code> property, an attempt will be made to
		 * align the header to this position.
		 *
		 * @default feathers.layout.VerticalAlign.TOP
		 *
		 * @see feathers.layout.VerticalAlign#TOP
		 * @see feathers.layout.VerticalAlign#MIDDLE
		 * @see feathers.layout.VerticalAlign#BOTTOM
		 * @see #headerIndices
		 * @see #scrollPositionVerticalAlign
		 */
		public function get headerScrollPositionVerticalAlign():String
		{
			return this._headerScrollPositionVerticalAlign;
		}

		/**
		 * @private
		 */
		public function set headerScrollPositionVerticalAlign(value:String):void
		{
			this._headerScrollPositionVerticalAlign = value;
		}

		/**
		 * @inheritDoc
		 */
		override public function get requiresLayoutOnScroll():Boolean
		{
			return this._useVirtualLayout ||
				(this._headerIndices && this._stickyHeader); //the header needs to stick!
		}

		/**
		 * @inheritDoc
		 */
		public function layout(items:Vector.<DisplayObject>, viewPortBounds:ViewPortBounds = null, result:LayoutBoundsResult = null):LayoutBoundsResult
		{
			//this function is very long because it may be called every frame,
			//in some situations. testing revealed that splitting this function
			//into separate, smaller functions affected performance.
			//since the SWC compiler cannot inline functions, we can't use that
			//feature either.

			//since viewPortBounds can be null, we may need to provide some defaults
			var scrollX:Number = viewPortBounds ? viewPortBounds.scrollX : 0;
			var scrollY:Number = viewPortBounds ? viewPortBounds.scrollY : 0;
			var boundsX:Number = viewPortBounds ? viewPortBounds.x : 0;
			var boundsY:Number = viewPortBounds ? viewPortBounds.y : 0;
			var minWidth:Number = viewPortBounds ? viewPortBounds.minWidth : 0;
			var minHeight:Number = viewPortBounds ? viewPortBounds.minHeight : 0;
			var maxWidth:Number = viewPortBounds ? viewPortBounds.maxWidth : Number.POSITIVE_INFINITY;
			var maxHeight:Number = viewPortBounds ? viewPortBounds.maxHeight : Number.POSITIVE_INFINITY;
			var explicitWidth:Number = viewPortBounds ? viewPortBounds.explicitWidth : NaN;
			var explicitHeight:Number = viewPortBounds ? viewPortBounds.explicitHeight : NaN;

			if(this._useVirtualLayout)
			{
				//if the layout is virtualized, we'll need the dimensions of the
				//typical item so that we have fallback values when an item is null
				this.prepareTypicalItem(explicitWidth - this._paddingLeft - this._paddingRight);
				var calculatedTypicalItemWidth:Number = this._typicalItem ? this._typicalItem.width : 0;
				var calculatedTypicalItemHeight:Number = this._typicalItem ? this._typicalItem.height : 0;
			}

			var needsExplicitWidth:Boolean = explicitWidth !== explicitWidth; //isNaN
			var needsExplicitHeight:Boolean = explicitHeight !== explicitHeight; //isNaN
			var distributedHeight:Number;
			if(!needsExplicitHeight && this._distributeHeights)
			{
				//we need to calculate this before validateItems() because it
				//needs to be passed in there.
				distributedHeight = this.calculateDistributedHeight(items, explicitHeight, minHeight, maxHeight, false);
				if(this._useVirtualLayout)
				{
					calculatedTypicalItemHeight = distributedHeight;
				}
			}

			if(!this._useVirtualLayout || this._hasVariableItemDimensions || this._distributeHeights ||
				this._horizontalAlign != HorizontalAlign.JUSTIFY ||
				needsExplicitWidth) //isNaN
			{
				//in some cases, we may need to validate all of the items so
				//that we can use their dimensions below.
				this.validateItems(items, explicitWidth - this._paddingLeft - this._paddingRight,
					minWidth - this._paddingLeft - this._paddingRight,
					maxWidth - this._paddingLeft - this._paddingRight,
					explicitHeight - this._paddingTop - this._paddingBottom,
					minHeight - this._paddingTop - this._paddingBottom,
					maxHeight - this._paddingTop - this._paddingBottom, distributedHeight);
			}

			if(needsExplicitHeight && this._distributeHeights)
			{
				//if we didn't calculate this before, we need to do it now.
				distributedHeight = this.calculateDistributedHeight(items, explicitHeight, minHeight, maxHeight, true);
			}
			var hasDistributedHeight:Boolean = distributedHeight === distributedHeight; //!isNaN

			if(!this._useVirtualLayout)
			{
				//handle the percentHeight property from VerticalLayoutData,
				//if available.
				this.applyPercentHeights(items, explicitHeight, minHeight, maxHeight);
			}

			//this section prepares some variables needed for the following loop
			var hasFirstGap:Boolean = this._firstGap === this._firstGap; //!isNaN
			var hasLastGap:Boolean = this._lastGap === this._lastGap; //!isNaN
			var maxItemWidth:Number = this._useVirtualLayout ? calculatedTypicalItemWidth : 0;
			var startPositionY:Number = boundsY + this._paddingTop;
			var positionY:Number = startPositionY;
			var indexOffset:int = 0;
			var itemCount:int = items.length;
			var totalItemCount:int = itemCount;
			var requestedRowAvailableHeight:Number = 0;
			var maxRowAvailableHeight:Number = Number.POSITIVE_INFINITY;
			if(this._useVirtualLayout && !this._hasVariableItemDimensions)
			{
				//if the layout is virtualized, and the items all have the same
				//height, we can make our loops smaller by skipping some items
				//at the beginning and end. this improves performance.
				totalItemCount += this._beforeVirtualizedItemCount + this._afterVirtualizedItemCount;
				indexOffset = this._beforeVirtualizedItemCount;
				positionY += (this._beforeVirtualizedItemCount * (calculatedTypicalItemHeight + this._gap));
				if(hasFirstGap && this._beforeVirtualizedItemCount > 0)
				{
					positionY = positionY - this._gap + this._firstGap;
				}
			}
			var secondToLastIndex:int = totalItemCount - 2;
			//this cache is used to save non-null items in virtual layouts. by
			//using a smaller array, we can improve performance by spending less
			//time in the upcoming loops.
			this._discoveredItemsCache.length = 0;
			var discoveredItemsCacheLastIndex:int = 0;

			//if there are no items in layout, then we don't want to subtract
			//any gap when calculating the total height, so default to 0.
			var gap:Number = 0;
			
			var headerIndicesIndex:int = -1;
			var nextHeaderIndex:int = -1;
			var headerCount:int = 0;
			var stickyHeaderMaxY:Number = Number.POSITIVE_INFINITY;
			if(this._headerIndices && this._stickyHeader)
			{
				headerCount = this._headerIndices.length;
				if(headerCount > 0)
				{
					headerIndicesIndex = 0;
					nextHeaderIndex = this._headerIndices[headerIndicesIndex];
				}
			}

			//this first loop sets the y position of items, and it calculates
			//the total height of all items
			for(var i:int = 0; i < itemCount; i++)
			{
				if(!this._useVirtualLayout)
				{
					if(this._maxRowCount > 0 && this._maxRowCount == i)
					{
						maxRowAvailableHeight = positionY;
					}
					if(this._requestedRowCount > 0 && this._requestedRowCount == i)
					{
						requestedRowAvailableHeight = positionY;
					}
				}
				var item:DisplayObject = items[i];
				//if we're trimming some items at the beginning, we need to
				//adjust i to account for the missing items in the array
				var iNormalized:int = i + indexOffset;

				if(nextHeaderIndex == iNormalized)
				{
					//if the sticky header is enabled, we need to find its index
					//we look for the first header that is visible at the top of
					//the view port. the previous one should be sticky.
					if(positionY < scrollY)
					{
						headerIndicesIndex++;
						if(headerIndicesIndex < headerCount)
						{
							nextHeaderIndex = this._headerIndices[headerIndicesIndex];
						}
					}
					else
					{
						headerIndicesIndex--;
						if(headerIndicesIndex >= 0)
						{
							//this is the index of the "sticky" header, but we
							//need to save it for later.
							nextHeaderIndex = this._headerIndices[headerIndicesIndex];
							stickyHeaderMaxY = positionY;
						}
					}
				}

				//pick the gap that will follow this item. the first and second
				//to last items may have different gaps.
				gap = this._gap;
				if(hasFirstGap && iNormalized == 0)
				{
					gap = this._firstGap;
				}
				else if(hasLastGap && iNormalized > 0 && iNormalized == secondToLastIndex)
				{
					gap = this._lastGap;
				}

				if(this._useVirtualLayout && this._hasVariableItemDimensions)
				{
					var cachedHeight:Number = this._virtualCache[iNormalized];
				}
				if(this._useVirtualLayout && !item)
				{
					//the item is null, and the layout is virtualized, so we
					//need to estimate the height of the item.

					if(!this._hasVariableItemDimensions ||
						cachedHeight !== cachedHeight) //isNaN
					{
						//if all items must have the same height, we will
						//use the height of the typical item (calculatedTypicalItemHeight).

						//if items may have different heights, we first check
						//the cache for a height value. if there isn't one, then
						//we'll use calculatedTypicalItemHeight as a fallback.
						positionY += calculatedTypicalItemHeight + gap;
					}
					else
					{
						//if we have variable item heights, we should use a
						//cached height when there's one available. it will be
						//more accurate than the typical item's height.
						positionY += cachedHeight + gap;
					}
				}
				else
				{
					//we get here if the item isn't null. it is never null if
					//the layout isn't virtualized.
					var layoutItem:ILayoutDisplayObject = item as ILayoutDisplayObject;
					if(layoutItem !== null && !layoutItem.includeInLayout)
					{
						continue;
					}
					var pivotY:Number = item.pivotY;
					if(pivotY != 0)
					{
						pivotY *= item.scaleY;
					}
					item.y = pivotY + positionY;
					var itemWidth:Number = item.width;
					var itemHeight:Number;
					if(hasDistributedHeight)
					{
						item.height = itemHeight = distributedHeight;
					}
					else
					{
						itemHeight = item.height;
					}
					if(this._useVirtualLayout)
					{
						if(this._hasVariableItemDimensions)
						{
							if(itemHeight != cachedHeight)
							{
								//update the cache if needed. this will notify
								//the container that the virtualized layout has
								//changed, and it the view port may need to be
								//re-measured.
								this._virtualCache[iNormalized] = itemHeight;

								//attempt to adjust the scroll position so that
								//it looks like we're scrolling smoothly after
								//this item resizes.
								if(positionY < scrollY &&
									cachedHeight !== cachedHeight && //isNaN
									itemHeight != calculatedTypicalItemHeight)
								{
									this.dispatchEventWith(Event.SCROLL, false, new Point(0, itemHeight - calculatedTypicalItemHeight));
								}

								this.dispatchEventWith(Event.CHANGE);
							}
						}
						else if(calculatedTypicalItemHeight >= 0)
						{
							//if all items must have the same height, we will
							//use the height of the typical item (calculatedTypicalItemHeight).
							itemHeight = calculatedTypicalItemHeight;
							if(item !== this._typicalItem || item.height != itemHeight)
							{
								//ensure that the typical item's height is not
								//set explicitly so that it can resize
								item.height = itemHeight;
							}
						}
					}
					positionY += itemHeight + gap;
					//we compare with > instead of Math.max() because the rest
					//arguments on Math.max() cause extra garbage collection and
					//hurt performance
					if(itemWidth > maxItemWidth)
					{
						//we need to know the maximum width of the items in the
						//case where the width of the view port needs to be
						//calculated by the layout.
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
				//finish the final calculation of the y position so that it can
				//be used for the total height of all items
				positionY += (this._afterVirtualizedItemCount * (calculatedTypicalItemHeight + this._gap));
				if(hasLastGap && this._afterVirtualizedItemCount > 0)
				{
					positionY = positionY - this._gap + this._lastGap;
				}
			}
			if(nextHeaderIndex >= 0)
			{
				//position the "sticky" header at the top of the view port.
				//it should not cover the following header.
				var header:DisplayObject = items[nextHeaderIndex];
				this.positionStickyHeader(header, scrollY, stickyHeaderMaxY);
			}
			if(!this._useVirtualLayout && this._requestedRowCount > itemCount)
			{
				if(itemCount > 0)
				{
					requestedRowAvailableHeight = this._requestedRowCount * positionY / itemCount;
				}
				else
				{
					requestedRowAvailableHeight = 0;
				}
			}

			//this array will contain all items that are not null. see the
			//comment above where the discoveredItemsCache is initialized for
			//details about why this is important.
			var discoveredItems:Vector.<DisplayObject> = this._useVirtualLayout ? this._discoveredItemsCache : items;
			var discoveredItemCount:int = discoveredItems.length;

			var totalWidth:Number = maxItemWidth + this._paddingLeft + this._paddingRight;
			//the available width is the width of the viewport. if the explicit
			//width is NaN, we need to calculate the viewport width ourselves
			//based on the total width of all items.
			var availableWidth:Number = explicitWidth;
			if(availableWidth !== availableWidth) //isNaN
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

			//this is the total height of all items
			var totalHeight:Number = positionY - gap + this._paddingBottom - boundsY;
			//the available height is the height of the viewport. if the explicit
			//height is NaN, we need to calculate the viewport height ourselves
			//based on the total height of all items.
			var availableHeight:Number = explicitHeight;
			if(availableHeight !== availableHeight) //isNaN
			{
				availableHeight = totalHeight;
				if(this._requestedRowCount > 0)
				{
					if(this._useVirtualLayout)
					{
						availableHeight = this._requestedRowCount * (calculatedTypicalItemHeight + this._gap) - this._gap + this._paddingTop + this._paddingBottom;
					}
					else
					{
						availableHeight = requestedRowAvailableHeight;
					}
				}
				else
				{
					availableHeight = totalHeight;
					if(this._maxRowCount > 0)
					{
						if(this._useVirtualLayout)
						{
							maxRowAvailableHeight = this._maxRowCount * (calculatedTypicalItemHeight + this._gap) - this._gap + this._paddingTop + this._paddingBottom;
						}
						if(maxRowAvailableHeight < availableHeight)
						{
							availableHeight = maxRowAvailableHeight;
						}
					}
				}
				if(availableHeight < minHeight)
				{
					availableHeight = minHeight;
				}
				else if(availableHeight > maxHeight)
				{
					availableHeight = maxHeight;
				}
			}

			//in this section, we handle vertical alignment. items will be
			//aligned vertically if the total height of all items is less than
			//the available height of the view port.
			if(totalHeight < availableHeight)
			{
				var verticalAlignOffsetY:Number = 0;
				if(this._verticalAlign == VerticalAlign.BOTTOM)
				{
					verticalAlignOffsetY = availableHeight - totalHeight;
				}
				else if(this._verticalAlign == VerticalAlign.MIDDLE)
				{
					verticalAlignOffsetY = Math.round((availableHeight - totalHeight) / 2);
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

			var availableWidthMinusPadding:Number = availableWidth - this._paddingLeft - this._paddingRight;
			for(i = 0; i < discoveredItemCount; i++)
			{
				item = discoveredItems[i];
				layoutItem = item as ILayoutDisplayObject;
				if(layoutItem !== null && !layoutItem.includeInLayout)
				{
					continue;
				}

				var pivotX:Number = item.pivotX;
				if(pivotX != 0)
				{
					pivotX *= item.scaleX;
				}

				//in this section, we handle horizontal alignment and percent
				//width from VerticalLayoutData
				if(this._horizontalAlign == HorizontalAlign.JUSTIFY)
				{
					//if we justify items horizontally, we can skip percent width
					item.x = pivotX + boundsX + this._paddingLeft;
					item.width = availableWidthMinusPadding;
				}
				else
				{
					if(layoutItem !== null)
					{
						var layoutData:VerticalLayoutData = layoutItem.layoutData as VerticalLayoutData;
						if(layoutData !== null)
						{
							//in this section, we handle percentage width if
							//VerticalLayoutData is available.
							var percentWidth:Number = layoutData.percentWidth;
							if(percentWidth === percentWidth) //!isNaN
							{
								if(percentWidth < 0)
								{
									percentWidth = 0;
								}
								if(percentWidth > 100)
								{
									percentWidth = 100;
								}
								itemWidth = percentWidth * availableWidthMinusPadding / 100;
								if(item is IFeathersControl)
								{
									var feathersItem:IFeathersControl = IFeathersControl(item);
									var itemMinWidth:Number = feathersItem.explicitMinWidth;
									//we try to respect the minWidth, but not
									//when it's larger than 100%
									if(itemMinWidth > availableWidthMinusPadding)
									{
										itemMinWidth = availableWidthMinusPadding;
									}
									if(itemWidth < itemMinWidth)
									{
										itemWidth = itemMinWidth;
									}
									else
									{
										var itemMaxWidth:Number = feathersItem.explicitMaxWidth;
										if(itemWidth > itemMaxWidth)
										{
											itemWidth = itemMaxWidth;
										}
									}
								}
								item.width = itemWidth;
							}
						}
					}
					//handle all other horizontal alignment values (we handled
					//justify already). the x position of all items is set.
					var horizontalAlignWidth:Number = availableWidth;
					if(totalWidth > horizontalAlignWidth)
					{
						horizontalAlignWidth = totalWidth;
					}
					switch(this._horizontalAlign)
					{
						case HorizontalAlign.RIGHT:
						{
							item.x = pivotX + boundsX + horizontalAlignWidth - this._paddingRight - item.width;
							break;
						}
						case HorizontalAlign.CENTER:
						{
							//round to the nearest pixel when dividing by 2 to
							//align in the center
							item.x = pivotX + boundsX + this._paddingLeft + Math.round((horizontalAlignWidth - this._paddingLeft - this._paddingRight - item.width) / 2);
							break;
						}
						default: //left
						{
							item.x = pivotX + boundsX + this._paddingLeft;
						}
					}
				}
			}
			//we don't want to keep a reference to any of the items, so clear
			//this cache
			this._discoveredItemsCache.length = 0;

			//finally, we want to calculate the result so that the container
			//can use it to adjust its viewport and determine the minimum and
			//maximum scroll positions (if needed)
			if(!result)
			{
				result = new LayoutBoundsResult();
			}
			result.contentX = 0;
			result.contentWidth = this._horizontalAlign == HorizontalAlign.JUSTIFY ? availableWidth : totalWidth;
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

			this.prepareTypicalItem(explicitWidth - this._paddingLeft - this._paddingRight);
			var calculatedTypicalItemWidth:Number = this._typicalItem ? this._typicalItem.width : 0;
			var calculatedTypicalItemHeight:Number = this._typicalItem ? this._typicalItem.height : 0;

			var hasFirstGap:Boolean = this._firstGap === this._firstGap; //!isNaN
			var hasLastGap:Boolean = this._lastGap === this._lastGap; //!isNaN
			var positionY:Number;
			if(this._distributeHeights)
			{
				positionY = (calculatedTypicalItemHeight + this._gap) * itemCount;
			}
			else
			{
				positionY = 0;
				var maxItemWidth:Number = calculatedTypicalItemWidth;
				if(!this._hasVariableItemDimensions)
				{
					positionY += ((calculatedTypicalItemHeight + this._gap) * itemCount);
				}
				else
				{
					for(var i:int = 0; i < itemCount; i++)
					{
						var cachedHeight:Number = this._virtualCache[i];
						if(cachedHeight !== cachedHeight) //isNaN
						{
							positionY += calculatedTypicalItemHeight + this._gap;
						}
						else
						{
							positionY += cachedHeight + this._gap;
						}
					}
				}
			}
			positionY -= this._gap;
			if(hasFirstGap && itemCount > 1)
			{
				positionY = positionY - this._gap + this._firstGap;
			}
			if(hasLastGap && itemCount > 2)
			{
				positionY = positionY - this._gap + this._lastGap;
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
				if(this._requestedRowCount > 0)
				{
					var resultHeight:Number = (calculatedTypicalItemHeight + this._gap) * this._requestedRowCount - this._gap;
				}
				else
				{
					resultHeight = positionY;
					if(this._maxRowCount > 0)
					{
						var maxRowResultHeight:Number = (calculatedTypicalItemHeight + this._gap) * this._maxRowCount - this._gap;
						if(maxRowResultHeight < resultHeight)
						{
							resultHeight = maxRowResultHeight;
						}
					}
				}
				resultHeight += this._paddingTop + this._paddingBottom;
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

			this.prepareTypicalItem(width - this._paddingLeft - this._paddingRight);
			var calculatedTypicalItemWidth:Number = this._typicalItem ? this._typicalItem.width : 0;
			var calculatedTypicalItemHeight:Number = this._typicalItem ? this._typicalItem.height : 0;

			var hasFirstGap:Boolean = this._firstGap === this._firstGap; //!isNaN
			var hasLastGap:Boolean = this._lastGap === this._lastGap; //!isNaN
			var resultLastIndex:int = 0;
			//we add one extra here because the first item renderer in view may
			//be partially obscured, which would reveal an extra item renderer.
			var maxVisibleTypicalItemCount:int = Math.ceil(height / (calculatedTypicalItemHeight + this._gap)) + 1;
			if(!this._hasVariableItemDimensions)
			{
				//this case can be optimized because we know that every item has
				//the same height
				var totalItemHeight:Number = itemCount * (calculatedTypicalItemHeight + this._gap) - this._gap;
				if(hasFirstGap && itemCount > 1)
				{
					totalItemHeight = totalItemHeight - this._gap + this._firstGap;
				}
				if(hasLastGap && itemCount > 2)
				{
					totalItemHeight = totalItemHeight - this._gap + this._lastGap;
				}
				var indexOffset:int = 0;
				if(totalItemHeight < height)
				{
					if(this._verticalAlign == VerticalAlign.BOTTOM)
					{
						indexOffset = Math.ceil((height - totalItemHeight) / (calculatedTypicalItemHeight + this._gap));
					}
					else if(this._verticalAlign == VerticalAlign.MIDDLE)
					{
						indexOffset = Math.ceil(((height - totalItemHeight) / (calculatedTypicalItemHeight + this._gap)) / 2);
					}
				}
				var minimum:int = (scrollY - this._paddingTop) / (calculatedTypicalItemHeight + this._gap);
				if(minimum < 0)
				{
					minimum = 0;
				}
				minimum -= indexOffset;
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
				for(var i:int = minimum; i <= maximum; i++)
				{
					if(i >= 0 && i < itemCount)
					{
						result[resultLastIndex] = i;
					}
					else if(i < 0)
					{
						result[resultLastIndex] = itemCount + i;
					}
					else if(i >= itemCount)
					{
						result[resultLastIndex] = i - itemCount;
					}
					resultLastIndex++;
				}
				return result;
			}

			var headerIndicesIndex:int = -1;
			var nextHeaderIndex:int = -1;
			var headerCount:int = 0;
			if(this._headerIndices && this._stickyHeader)
			{
				headerCount = this._headerIndices.length;
				if(headerCount > 0)
				{
					headerIndicesIndex = 0;
					nextHeaderIndex = this._headerIndices[headerIndicesIndex];
				}
			}
			
			var secondToLastIndex:int = itemCount - 2;
			var maxPositionY:Number = scrollY + height;
			var startPositionY:Number = this._paddingTop;
			var foundSticky:Boolean = false;
			var positionY:Number = startPositionY;
			for(i = 0; i < itemCount; i++)
			{
				if(nextHeaderIndex == i)
				{
					if(positionY < scrollY)
					{
						headerIndicesIndex++;
						if(headerIndicesIndex < headerCount)
						{
							nextHeaderIndex = this._headerIndices[headerIndicesIndex];
						}
					}
					else
					{
						headerIndicesIndex--;
						if(headerIndicesIndex >= 0)
						{
							//this is the index of the "sticky" header
							nextHeaderIndex = this._headerIndices[headerIndicesIndex];
							foundSticky = true;
						}
					}
				}
				
				var gap:Number = this._gap;
				if(hasFirstGap && i == 0)
				{
					gap = this._firstGap;
				}
				else if(hasLastGap && i > 0 && i == secondToLastIndex)
				{
					gap = this._lastGap;
				}
				var cachedHeight:Number = this._virtualCache[i];
				if(cachedHeight !== cachedHeight) //isNaN
				{
					var itemHeight:Number = calculatedTypicalItemHeight;
				}
				else
				{
					itemHeight = cachedHeight;
				}
				var oldPositionY:Number = positionY;
				positionY += itemHeight + gap;
				if(positionY > scrollY && oldPositionY < maxPositionY)
				{
					result[resultLastIndex] = i;
					resultLastIndex++;
				}

				if(positionY >= maxPositionY)
				{
					if(!foundSticky)
					{
						headerIndicesIndex--;
						if(headerIndicesIndex >= 0)
						{
							//this is the index of the "sticky" header
							nextHeaderIndex = this._headerIndices[headerIndicesIndex];
						}
					}
					break;
				}
			}
			if(nextHeaderIndex >= 0 && result.indexOf(nextHeaderIndex) < 0)
			{
				var addedStickyHeader:Boolean = false;
				for(i = 0; i < resultLastIndex; i++)
				{
					if(nextHeaderIndex <= result[i])
					{
						result.insertAt(i, nextHeaderIndex);
						addedStickyHeader = true;
						break;
					}
				}
				if(!addedStickyHeader)
				{
					result[resultLastIndex] = nextHeaderIndex;
				}
				resultLastIndex++;
			}

			//similar to above, in order to avoid costly destruction and
			//creation of item renderers, we're going to fill in some extra
			//indices
			var resultLength:int = result.length;
			var visibleItemCountDifference:int = maxVisibleTypicalItemCount - resultLength;
			if(visibleItemCountDifference > 0 && resultLength > 0)
			{
				//add extra items before the first index
				var firstExistingIndex:int = result[0];
				var lastIndexToAdd:int = firstExistingIndex - visibleItemCountDifference;
				if(lastIndexToAdd < 0)
				{
					lastIndexToAdd = 0;
				}
				for(i = firstExistingIndex - 1; i >= lastIndexToAdd; i--)
				{
					if(i == nextHeaderIndex)
					{
						continue;
					}
					result.insertAt(0, i);
				}
			}
			resultLength = result.length;
			visibleItemCountDifference = maxVisibleTypicalItemCount - resultLength;
			resultLastIndex = resultLength;
			if(visibleItemCountDifference > 0)
			{
				//add extra items after the last index
				var startIndex:int = (resultLength > 0) ? (result[resultLength - 1] + 1) : 0;
				var endIndex:int = startIndex + visibleItemCountDifference;
				if(endIndex > itemCount)
				{
					endIndex = itemCount;
				}
				for(i = startIndex; i < endIndex; i++)
				{
					if(i == nextHeaderIndex)
					{
						continue;
					}
					result[resultLastIndex] = i;
					resultLastIndex++;
				}
			}
			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function getNearestScrollPositionForIndex(index:int, scrollX:Number, scrollY:Number, items:Vector.<DisplayObject>,
			x:Number, y:Number, width:Number, height:Number, result:Point = null):Point
		{
			var point:Point = Pool.getPoint();
			this.calculateScrollRangeOfIndex(index, items, x, y, width, height, point);
			var minScrollY:Number = point.x;
			var maxScrollY:Number = point.y;
			var scrollRange:Number = maxScrollY - minScrollY;
			Pool.putPoint(point);

			if(this._useVirtualLayout)
			{
				if(this._hasVariableItemDimensions)
				{
					var itemHeight:Number = this._virtualCache[index];
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

			var bottomPosition:Number = maxScrollY - (scrollRange - itemHeight);
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
		public function calculateNavigationDestination(items:Vector.<DisplayObject>, index:int, keyCode:uint, bounds:LayoutBoundsResult):int
		{
			var itemArrayCount:int = items.length;
			var itemCount:int = itemArrayCount + this._beforeVirtualizedItemCount + this._afterVirtualizedItemCount;
			if(this._useVirtualLayout)
			{
				//if the layout is virtualized, we'll need the dimensions of the
				//typical item so that we have fallback values when an item is null
				this.prepareTypicalItem(bounds.viewPortWidth - this._paddingLeft - this._paddingRight);
				var calculatedTypicalItemHeight:Number = this._typicalItem ? this._typicalItem.height : 0;
			}

			var backwards:Boolean = false;
			var result:int = index;
			if(keyCode == Keyboard.HOME)
			{
				backwards = true;
				if(itemCount > 0)
				{
					result = 0;
				}
			}
			else if(keyCode == Keyboard.END)
			{
				result = itemCount - 1;
			}
			else if(keyCode == Keyboard.PAGE_UP)
			{
				backwards = true;
				var indexOffset:int = 0;
				if(this._useVirtualLayout && this._hasVariableItemDimensions)
				{
					indexOffset = -this._beforeVirtualizedItemCount;
				}
				var yPosition:Number = 0;
				for(var i:int = index; i >= 0; i--)
				{
					var iNormalized:int = i + indexOffset;
					if(this._useVirtualLayout && this._hasVariableItemDimensions)
					{
						var cachedHeight:Number = this._virtualCache[i];
					}
					if(iNormalized < 0 || iNormalized >= itemArrayCount)
					{
						if(cachedHeight === cachedHeight) //!isNaN
						{
							yPosition += cachedHeight;
						}
						else
						{
							yPosition += calculatedTypicalItemHeight;
						}
					}
					else
					{
						var item:DisplayObject = items[iNormalized];
						if(item === null)
						{
							if(cachedHeight === cachedHeight) //!isNaN
							{
								yPosition += cachedHeight;
							}
							else
							{
								yPosition += calculatedTypicalItemHeight;
							}
						}
						else
						{
							yPosition += item.height;
						}
					}
					if(yPosition > bounds.viewPortHeight)
					{
						break;
					}
					yPosition += this._gap;
					result = i;
				}
			}
			else if(keyCode == Keyboard.PAGE_DOWN)
			{
				yPosition = 0;
				indexOffset = 0;
				if(this._useVirtualLayout && this._hasVariableItemDimensions)
				{
					indexOffset = -this._beforeVirtualizedItemCount;
				}
				for(i = index; i < itemCount; i++)
				{
					iNormalized = i + indexOffset;
					if(this._useVirtualLayout && this._hasVariableItemDimensions)
					{
						cachedHeight = this._virtualCache[i];
					}
					if(iNormalized < 0 || iNormalized >= itemArrayCount)
					{
						if(cachedHeight === cachedHeight) //!isNaN
						{
							yPosition += cachedHeight;
						}
						else
						{
							yPosition += calculatedTypicalItemHeight;
						}
					}
					else
					{
						item = items[iNormalized];
						if(item === null)
						{
							if(cachedHeight === cachedHeight) //!isNaN
							{
								yPosition += cachedHeight;
							}
							else
							{
								yPosition += calculatedTypicalItemHeight;
							}
						}
						else
						{
							yPosition += item.height;
						}
					}
					if(yPosition > bounds.viewPortHeight)
					{
						break;
					}
					yPosition += this._gap;
					result = i;
				}
			}
			else if(keyCode == Keyboard.UP)
			{
				backwards = true;
				result--;
			}
			else if(keyCode == Keyboard.DOWN)
			{
				result++;
			}
			if(result < 0)
			{
				result = 0;
			}
			if(result >= itemCount)
			{
				result = itemCount - 1;
			}
			while(this._headerIndices !== null && this._headerIndices.indexOf(result) != -1)
			{
				if(backwards)
				{
					if(result == 0)
					{
						backwards = false;
						result++;
					}
					else
					{
						result--;
					}
				}
				else
				{
					result++;
				}
			}
			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function getScrollPositionForIndex(index:int, items:Vector.<DisplayObject>, x:Number, y:Number, width:Number, height:Number, result:Point = null):Point
		{
			var point:Point = Pool.getPoint();
			this.calculateScrollRangeOfIndex(index, items, x, y, width, height, point);
			var minScrollY:Number = point.x;
			var maxScrollY:Number = point.y;
			var scrollRange:Number = maxScrollY - minScrollY;
			Pool.putPoint(point);

			if(this._useVirtualLayout)
			{
				if(this._hasVariableItemDimensions)
				{
					var itemHeight:Number = this._virtualCache[index];
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

			var verticalAlign:String = this._scrollPositionVerticalAlign;
			if(this._headerIndices !== null &&
				this._headerIndices.indexOf(index) != -1)
			{
				verticalAlign = this._headerScrollPositionVerticalAlign;
			}
			if(verticalAlign === VerticalAlign.MIDDLE)
			{
				maxScrollY -= Math.round((scrollRange - itemHeight) / 2);
			}
			else if(verticalAlign === VerticalAlign.BOTTOM)
			{
				maxScrollY -= (scrollRange - itemHeight);
			}
			result.y = maxScrollY;

			return result;
		}

		/**
		 * @private
		 */
		protected function validateItems(items:Vector.<DisplayObject>,
			explicitWidth:Number, minWidth:Number, maxWidth:Number,
			explicitHeight:Number, minHeight:Number, maxHeight:Number,
			distributedHeight:Number):void
		{
			var needsHeight:Boolean = explicitHeight !== explicitHeight; //isNaN
			var containerHeight:Number = explicitHeight;
			if(needsHeight)
			{
				containerHeight = minHeight;
			}
			//if the alignment is justified, then we want to set the width of
			//each item before validating because setting one dimension may
			//cause the other dimension to change, and that will invalidate the
			//layout if it happens after validation, causing more invalidation
			var isJustified:Boolean = this._horizontalAlign == HorizontalAlign.JUSTIFY;
			var itemCount:int = items.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:DisplayObject = items[i];
				if(!item || (item is ILayoutDisplayObject && !ILayoutDisplayObject(item).includeInLayout))
				{
					continue;
				}
				if(isJustified)
				{
					//the alignment is justified, but we don't yet have a width
					//to use, so we need to ensure that we accurately measure
					//the items instead of using an old justified width that may
					//be wrong now!
					item.width = explicitWidth;
					if(item is IFeathersControl)
					{
						var feathersItem:IFeathersControl = IFeathersControl(item);
						feathersItem.minWidth = minWidth;
						feathersItem.maxWidth = maxWidth;
					}
				}
				else if(item is ILayoutDisplayObject)
				{
					var layoutItem:ILayoutDisplayObject = ILayoutDisplayObject(item);
					var layoutData:VerticalLayoutData = layoutItem.layoutData as VerticalLayoutData;
					if(layoutData !== null)
					{
						var percentWidth:Number = layoutData.percentWidth;
						var percentHeight:Number = layoutData.percentHeight;
						if(percentWidth === percentWidth) //!isNaN
						{
							if(percentWidth < 0)
							{
								percentWidth = 0;
							}
							if(percentWidth > 100)
							{
								percentWidth = 100;
							}
							var itemWidth:Number = explicitWidth * percentWidth / 100;
							var measureItem:IMeasureDisplayObject = IMeasureDisplayObject(item);
							//we use the explicitMinWidth to make an accurate
							//measurement, and we'll use the component's
							//measured minWidth later, after we validate it.
							var itemExplicitMinWidth:Number = measureItem.explicitMinWidth;
							if(measureItem.explicitMinWidth === measureItem.explicitMinWidth && //!isNaN
								itemWidth < itemExplicitMinWidth)
							{
								itemWidth = itemExplicitMinWidth;
							}
							if(itemWidth > maxWidth)
							{
								itemWidth = maxWidth;
							}
							//unlike below, where we set maxHeight, we can set
							//the width explicitly here
							//in fact, it's required because we need to make
							//an accurate measurement of the total view port
							//width
							item.width = itemWidth;
							//if itemWidth is NaN, we need to set a maximum
							//width instead. this is important for items where
							//the height becomes larger when their width becomes
							//smaller (such as word-wrapped text)
							if(measureItem.explicitWidth !== measureItem.explicitWidth && //isNaN
								measureItem.maxWidth > maxWidth)
							{
								measureItem.maxWidth = maxWidth;
							}
						}
						if(percentHeight === percentHeight) //!isNaN
						{
							var itemHeight:Number = containerHeight * percentHeight / 100;
							measureItem = IMeasureDisplayObject(item);
							//we use the explicitMinHeight to make an accurate
							//measurement, and we'll use the component's
							//measured minHeight later, after we validate it.
							var itemExplicitMinHeight:Number = measureItem.explicitMinHeight;
							if(measureItem.explicitMinHeight === measureItem.explicitMinHeight && //!isNaN
								itemHeight < itemExplicitMinHeight)
							{
								itemHeight = itemExplicitMinHeight;
							}
							//validating this component may be expensive if we
							//don't limit the height! we want to ensure that a
							//component like a vertical list with many item
							//renderers doesn't completely bypass layout
							//virtualization, so we limit the height to the
							//maximum possible value if it were the only item in
							//the layout.
							//this doesn't need to be perfectly accurate because
							//it's just a maximum
							measureItem.maxHeight = itemHeight;
							//we also need to clear the explicit height because,
							//for many components, it will affect the minHeight
							//which is used in the final calculation
							item.height = NaN;
						}
					}
				}
				if(this._distributeHeights)
				{
					item.height = distributedHeight;
				}
				if(item is IValidating)
				{
					IValidating(item).validate();
				}
			}
		}

		/**
		 * @private
		 */
		protected function prepareTypicalItem(justifyWidth:Number):void
		{
			if(!this._typicalItem)
			{
				return;
			}
			var hasSetWidth:Boolean = false;
			if(this._horizontalAlign == HorizontalAlign.JUSTIFY &&
				justifyWidth === justifyWidth) //!isNaN
			{
				hasSetWidth = true;
				this._typicalItem.width = justifyWidth;
			}
			else if(this._typicalItem is ILayoutDisplayObject)
			{
				var layoutItem:ILayoutDisplayObject = ILayoutDisplayObject(this._typicalItem);
				var layoutData:VerticalLayoutData = layoutItem.layoutData as VerticalLayoutData;
				if(layoutData !== null)
				{
					var percentWidth:Number = layoutData.percentWidth;
					if(percentWidth === percentWidth) //!isNaN
					{
						if(percentWidth < 0)
						{
							percentWidth = 0;
						}
						if(percentWidth > 100)
						{
							percentWidth = 100;
						}
						hasSetWidth = true;
						this._typicalItem.width = justifyWidth * percentWidth / 100;
					}
				}
			}
			if(!hasSetWidth && this._resetTypicalItemDimensionsOnMeasure)
			{
				this._typicalItem.width = this._typicalItemWidth;
			}
			if(this._resetTypicalItemDimensionsOnMeasure)
			{
				this._typicalItem.height = this._typicalItemHeight;
			}
			if(this._typicalItem is IValidating)
			{
				IValidating(this._typicalItem).validate();
			}
		}

		/**
		 * @private
		 */
		protected function calculateDistributedHeight(items:Vector.<DisplayObject>, explicitHeight:Number, minHeight:Number, maxHeight:Number, measureItems:Boolean):Number
		{
			var needsHeight:Boolean = explicitHeight !== explicitHeight; //isNaN
			var includedItemCount:int = 0;
			var maxItemHeight:Number = 0;
			var itemCount:int = items.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:DisplayObject = items[i];
				if(item is ILayoutDisplayObject && !ILayoutDisplayObject(item).includeInLayout)
				{
					continue;
				}
				includedItemCount++;
				var itemHeight:Number = item.height;
				if(itemHeight > maxItemHeight)
				{
					maxItemHeight = itemHeight;
				}
			}
			if(measureItems && needsHeight)
			{
				explicitHeight = maxItemHeight * includedItemCount + this._paddingTop + this._paddingBottom + this._gap * (includedItemCount - 1);
				var needsRecalculation:Boolean = false;
				if(explicitHeight > maxHeight)
				{
					explicitHeight = maxHeight;
					needsRecalculation = true;
				}
				else if(explicitHeight < minHeight)
				{
					explicitHeight = minHeight;
					needsRecalculation = true;
				}
				if(!needsRecalculation)
				{
					return maxItemHeight;
				}
			}
			var availableSpace:Number = explicitHeight;
			if(needsHeight && maxHeight < Number.POSITIVE_INFINITY)
			{
				availableSpace = maxHeight;
			}
			availableSpace = availableSpace - this._paddingTop - this._paddingBottom - this._gap * (includedItemCount - 1);
			if(includedItemCount > 1 && this._firstGap === this._firstGap) //!isNaN
			{
				availableSpace += this._gap - this._firstGap;
			}
			if(includedItemCount > 2 && this._lastGap === this._lastGap) //!isNaN
			{
				availableSpace += this._gap - this._lastGap;
			}
			return availableSpace / includedItemCount;
		}

		/**
		 * @private
		 */
		protected function applyPercentHeights(items:Vector.<DisplayObject>, explicitHeight:Number, minHeight:Number, maxHeight:Number):void
		{
			var remainingHeight:Number = explicitHeight;
			this._discoveredItemsCache.length = 0;
			var totalExplicitHeight:Number = 0;
			var totalMinHeight:Number = 0;
			var totalPercentHeight:Number = 0;
			var itemCount:int = items.length;
			var pushIndex:int = 0;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:DisplayObject = items[i];
				if(item is ILayoutDisplayObject)
				{
					var layoutItem:ILayoutDisplayObject = ILayoutDisplayObject(item);
					if(!layoutItem.includeInLayout)
					{
						continue;
					}
					var layoutData:VerticalLayoutData = layoutItem.layoutData as VerticalLayoutData;
					if(layoutData)
					{
						var percentHeight:Number = layoutData.percentHeight;
						if(percentHeight === percentHeight) //!isNaN
						{
							if(percentHeight < 0)
							{
								percentHeight = 0;
							}
							if(layoutItem is IFeathersControl)
							{
								var feathersItem:IFeathersControl = IFeathersControl(layoutItem);
								totalMinHeight += feathersItem.minHeight;
							}
							totalPercentHeight += percentHeight;
							totalExplicitHeight += this._gap;
							this._discoveredItemsCache[pushIndex] = item;
							pushIndex++;
							continue;
						}
					}
				}
				totalExplicitHeight += item.height + this._gap;
			}
			totalExplicitHeight -= this._gap;
			if(this._firstGap === this._firstGap && itemCount > 1)
			{
				totalExplicitHeight += (this._firstGap - this._gap);
			}
			else if(this._lastGap === this._lastGap && itemCount > 2)
			{
				totalExplicitHeight += (this._lastGap - this._gap);
			}
			totalExplicitHeight += this._paddingTop + this._paddingBottom;
			if(totalPercentHeight < 100)
			{
				totalPercentHeight = 100;
			}
			if(remainingHeight !== remainingHeight) //isNaN
			{
				remainingHeight = totalExplicitHeight + totalMinHeight;
				if(remainingHeight < minHeight)
				{
					remainingHeight = minHeight;
				}
				else if(remainingHeight > maxHeight)
				{
					remainingHeight = maxHeight;
				}
			}
			remainingHeight -= totalExplicitHeight;
			if(remainingHeight < 0)
			{
				remainingHeight = 0;
			}
			do
			{
				var needsAnotherPass:Boolean = false;
				var percentToPixels:Number = remainingHeight / totalPercentHeight;
				for(i = 0; i < pushIndex; i++)
				{
					layoutItem = ILayoutDisplayObject(this._discoveredItemsCache[i]);
					if(!layoutItem)
					{
						continue;
					}
					layoutData = VerticalLayoutData(layoutItem.layoutData);
					percentHeight = layoutData.percentHeight;
					if(percentHeight < 0)
					{
						percentHeight = 0;
					}
					var itemHeight:Number = percentToPixels * percentHeight;
					if(layoutItem is IFeathersControl)
					{
						feathersItem = IFeathersControl(layoutItem);
						var itemMinHeight:Number = feathersItem.explicitMinHeight;
						if(itemMinHeight > remainingHeight)
						{
							//we try to respect the item's minimum height, but
							//if it's larger than the remaining space, we need
							//to force it to fit
							itemMinHeight = remainingHeight;
						}
						if(itemHeight < itemMinHeight)
						{
							itemHeight = itemMinHeight;
							remainingHeight -= itemHeight;
							totalPercentHeight -= percentHeight;
							this._discoveredItemsCache[i] = null;
							needsAnotherPass = true;
						}
						//we don't check maxHeight here because it is used in
						//validateItems() for performance optimization, so it
						//isn't a real maximum
					}
					layoutItem.height = itemHeight;
					if(layoutItem is IValidating)
					{
						//changing the height of the item may cause its width
						//to change, so we need to validate. the width is needed
						//for measurement.
						IValidating(layoutItem).validate();
					}
				}
			}
			while(needsAnotherPass)
			this._discoveredItemsCache.length = 0;
		}

		/**
		 * @private
		 */
		protected function calculateScrollRangeOfIndex(index:int, items:Vector.<DisplayObject>, x:Number, y:Number, width:Number, height:Number, result:Point):void
		{
			if(this._useVirtualLayout)
			{
				this.prepareTypicalItem(width - this._paddingLeft - this._paddingRight);
				var calculatedTypicalItemWidth:Number = this._typicalItem ? this._typicalItem.width : 0;
				var calculatedTypicalItemHeight:Number = this._typicalItem ? this._typicalItem.height : 0;
			}
			var headerIndicesIndex:int = -1;
			var nextHeaderIndex:int = -1;
			var headerCount:int = 0;
			var lastHeaderHeight:Number = 0;
			if(this._headerIndices && this._stickyHeader)
			{
				headerCount = this._headerIndices.length;
				if(headerCount > 0)
				{
					headerIndicesIndex = 0;
					nextHeaderIndex = this._headerIndices[headerIndicesIndex];
				}
			}
			var hasFirstGap:Boolean = this._firstGap === this._firstGap; //!isNaN
			var hasLastGap:Boolean = this._lastGap === this._lastGap; //!isNaN
			var positionY:Number = y + this._paddingTop;
			var lastHeight:Number = 0;
			var gap:Number = this._gap;
			var startIndexOffset:int = 0;
			var endIndexOffset:Number = 0;
			var itemCount:int = items.length;
			var totalItemCount:int = itemCount;
			if(this._useVirtualLayout && !this._hasVariableItemDimensions)
			{
				totalItemCount += this._beforeVirtualizedItemCount + this._afterVirtualizedItemCount;
				if(index < this._beforeVirtualizedItemCount)
				{
					//this makes it skip the loop below
					startIndexOffset = index + 1;
					lastHeight = calculatedTypicalItemHeight;
					gap = this._gap;
				}
				else
				{
					startIndexOffset = this._beforeVirtualizedItemCount;
					endIndexOffset = index - items.length - this._beforeVirtualizedItemCount + 1;
					if(endIndexOffset < 0)
					{
						endIndexOffset = 0;
					}
					positionY += (endIndexOffset * (calculatedTypicalItemHeight + this._gap));
				}
				positionY += (startIndexOffset * (calculatedTypicalItemHeight + this._gap));
			}
			index -= (startIndexOffset + endIndexOffset);
			var secondToLastIndex:int = totalItemCount - 2;
			for(var i:int = 0; i <= index; i++)
			{
				var item:DisplayObject = items[i];
				var iNormalized:int = i + startIndexOffset;
				if(hasFirstGap && iNormalized == 0)
				{
					gap = this._firstGap;
				}
				else if(hasLastGap && iNormalized > 0 && iNormalized == secondToLastIndex)
				{
					gap = this._lastGap;
				}
				else
				{
					gap = this._gap;
				}
				if(this._useVirtualLayout && this._hasVariableItemDimensions)
				{
					var cachedHeight:Number = this._virtualCache[iNormalized];
				}
				if(this._useVirtualLayout && !item)
				{
					if(!this._hasVariableItemDimensions ||
						cachedHeight !== cachedHeight) //isNaN
					{
						lastHeight = calculatedTypicalItemHeight;
					}
					else
					{
						lastHeight = cachedHeight;
					}
				}
				else
				{
					var itemHeight:Number = item.height;
					if(this._useVirtualLayout)
					{
						if(this._hasVariableItemDimensions)
						{
							if(itemHeight != cachedHeight)
							{
								this._virtualCache[iNormalized] = itemHeight;
								this.dispatchEventWith(Event.CHANGE);
							}
						}
						else if(calculatedTypicalItemHeight >= 0)
						{
							item.height = itemHeight = calculatedTypicalItemHeight;
						}
					}
					lastHeight = itemHeight;
				}
				positionY += lastHeight + gap;
				if(nextHeaderIndex == iNormalized)
				{
					lastHeaderHeight = lastHeight;
					//if the sticky header is enabled, we need to find its index
					//we look for the first header that is visible at the top of
					//the view port. the previous one should be sticky.
					headerIndicesIndex++;
					if(headerIndicesIndex < headerCount)
					{
						nextHeaderIndex = this._headerIndices[headerIndicesIndex];
					}
				}
			}
			positionY -= (lastHeight + gap);
			result.x = positionY - height;
			if(this._stickyHeader &&
				this._headerIndices !== null &&
				this._headerIndices.indexOf(index) == -1)
			{
				//if the headers are sticky, adjust the scroll range if we're
				//scrolling to an item because the sticky header should not hide
				//the item
				//unlike items, though, headers have a full scroll range
				positionY -= lastHeaderHeight;
			}
			result.y = positionY;
		}

		/**
		 * @private
		 */
		protected function positionStickyHeader(header:DisplayObject, scrollY:Number, maxY:Number):void
		{
			if(!header || header.y >= scrollY)
			{
				return;
			}
			if(header is IValidating)
			{
				IValidating(header).validate();
			}
			maxY -= header.height;
			if(maxY > scrollY)
			{
				maxY = scrollY;
			}
			header.y = maxY;
			//ensure that the sticky header is always on top!
			var headerParent:DisplayObjectContainer = header.parent;
			if(headerParent)
			{
				headerParent.setChildIndex(header, headerParent.numChildren - 1);
			}
		}
	}
}
