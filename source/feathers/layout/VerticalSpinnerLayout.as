/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.layout
{
	import feathers.core.IFeathersControl;
	import feathers.core.IValidating;

	import flash.errors.IllegalOperationError;
	import flash.geom.Point;
	import flash.ui.Keyboard;

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
	 * For use with the <code>SpinnerList</code> component, positions items from
	 * top to bottom in a single column and repeats infinitely.
	 *
	 * @see ../../../help/vertical-spinner-layout.html How to use VerticalSpinnerLayout with the Feathers SpinnerList component
	 *
	 * @productversion Feathers 2.1.0
	 */
	public class VerticalSpinnerLayout extends EventDispatcher implements ISpinnerLayout, ITrimmedVirtualLayout
	{
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
		public function VerticalSpinnerLayout()
		{
			super();
		}

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
		 * <code>paddingLeft</code>, but the other padding values may be
		 * different.
		 *
		 * @default 0
		 *
		 * @see #paddingRight
		 * @see #paddingLeft
		 */
		public function get padding():Number
		{
			return this._paddingLeft;
		}

		/**
		 * @private
		 */
		public function set padding(value:Number):void
		{
			this.paddingRight = value;
			this.paddingLeft = value;
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
		protected var _horizontalAlign:String = HorizontalAlign.JUSTIFY;

		[Inspectable(type="String",enumeration="left,center,right,justify")]
		/**
		 * The alignment of the items horizontally, on the x-axis.
		 *
		 * @default feathers.layout.HorizontalAlign.JUSTIFY
		 *
		 * @see feathers.layout.HorizontalAlign#LEFT
		 * @see feathers.layout.HorizontalAlign#CENTER
		 * @see feathers.layout.HorizontalAlign#RIGHT
		 * @see feathers.layout.HorizontalAlign#JUSTIFY
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
		protected var _requestedRowCount:int = 0;

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
		 *
		 * @see #resetTypicalItemDimensionsOnMeasure
		 * @see #typicalItemWidth
		 * @see #typicalItemHeight
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
		protected var _repeatItems:Boolean = true;

		/**
		 * If set to <code>true</code>, the layout will repeat the items
		 * infinitely, if there are enough items to allow this behavior. If the
		 * total height of the items is smaller than the height of the view
		 * port, the items cannot repeat.
		 *
		 * @default true
		 */
		public function get repeatItems():Boolean
		{
			return this._repeatItems;
		}

		/**
		 * @private
		 */
		public function set repeatItems(value:Boolean):void
		{
			if(this._repeatItems == value)
			{
				return;
			}
			this._repeatItems = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @copy feathers.layout.ISpinnerLayout#snapInterval
		 */
		public function get snapInterval():Number
		{
			if(this._typicalItem === null)
			{
				return 0;
			}
			return this._typicalItem.height + this._gap;
		}

		/**
		 * @inheritDoc
		 */
		public function get requiresLayoutOnScroll():Boolean
		{
			return true;
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

			if(!this._useVirtualLayout || this._horizontalAlign != HorizontalAlign.JUSTIFY ||
				explicitWidth !== explicitWidth) //isNaN
			{
				//in some cases, we may need to validate all of the items so
				//that we can use their dimensions below.
				this.validateItems(items, explicitWidth - this._paddingLeft - this._paddingRight, explicitHeight);
			}

			//this section prepares some variables needed for the following loop
			var maxItemWidth:Number = this._useVirtualLayout ? calculatedTypicalItemWidth : 0;
			var positionY:Number = boundsY;
			var gap:Number = this._gap;
			var itemCount:int = items.length;
			var totalItemCount:int = itemCount;
			if(this._useVirtualLayout)
			{
				//if the layout is virtualized, and the items all have the same
				//height, we can make our loops smaller by skipping some items
				//at the beginning and end. this improves performance.
				totalItemCount += this._beforeVirtualizedItemCount + this._afterVirtualizedItemCount;
				positionY += (this._beforeVirtualizedItemCount * (calculatedTypicalItemHeight + gap));
			}
			//this cache is used to save non-null items in virtual layouts. by
			//using a smaller array, we can improve performance by spending less
			//time in the upcoming loops.
			this._discoveredItemsCache.length = 0;
			var discoveredItemsCacheLastIndex:int = 0;

			//this first loop sets the y position of items, and it calculates
			//the total height of all items
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:DisplayObject = items[i];
				if(item)
				{
					//we get here if the item isn't null. it is never null if
					//the layout isn't virtualized.
					if(item is ILayoutDisplayObject && !ILayoutDisplayObject(item).includeInLayout)
					{
						continue;
					}
					item.y = item.pivotY + positionY;
					item.height = calculatedTypicalItemHeight;
					var itemWidth:Number = item.width;
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
				positionY += calculatedTypicalItemHeight + gap;
			}
			if(this._useVirtualLayout)
			{
				//finish the final calculation of the y position so that it can
				//be used for the total height of all items
				positionY += (this._afterVirtualizedItemCount * (calculatedTypicalItemHeight + gap));
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
			var totalHeight:Number = positionY - gap - boundsY;
			//the available height is the height of the viewport. if the explicit
			//height is NaN, we need to calculate the viewport height ourselves
			//based on the total height of all items.
			var availableHeight:Number = explicitHeight;
			if(availableHeight !== availableHeight) //isNaN
			{
				if(this._requestedRowCount > 0)
				{
					availableHeight = this._requestedRowCount * (calculatedTypicalItemHeight + gap) - gap;
				}
				else
				{
					availableHeight = totalHeight;
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

			var canRepeatItems:Boolean = this._repeatItems && totalHeight > availableHeight;
			if(canRepeatItems)
			{
				totalHeight += gap;
			}

			//in this section, we handle vertical alignment. the selected item
			//needs to be centered vertically.
			var verticalAlignOffsetY:Number = Math.round((availableHeight - calculatedTypicalItemHeight) / 2);
			if(!canRepeatItems)
			{
				totalHeight += 2 * verticalAlignOffsetY;
			}
			for(i = 0; i < discoveredItemCount; i++)
			{
				item = discoveredItems[i];
				if(item is ILayoutDisplayObject && !ILayoutDisplayObject(item).includeInLayout)
				{
					continue;
				}
				item.y += verticalAlignOffsetY;
			}

			for(i = 0; i < discoveredItemCount; i++)
			{
				item = discoveredItems[i];
				var layoutItem:ILayoutDisplayObject = item as ILayoutDisplayObject;
				if(layoutItem && !layoutItem.includeInLayout)
				{
					continue;
				}

				//if we're repeating items, then we may need to adjust the y
				//position of some items so that they appear inside the viewport
				if(canRepeatItems)
				{
					var adjustedScrollY:Number = scrollY - verticalAlignOffsetY;
					if(adjustedScrollY > 0)
					{
						item.y += totalHeight * int((adjustedScrollY + availableHeight) / totalHeight);
						if(item.y >= (scrollY + availableHeight))
						{
							item.y -= totalHeight;
						}
					}
					else if(adjustedScrollY < 0)
					{
						item.y += totalHeight * (int(adjustedScrollY / totalHeight) - 1);
						if((item.y + item.height) < scrollY)
						{
							item.y += totalHeight;
						}
					}
				}

				//in this section, we handle horizontal alignment
				if(this._horizontalAlign == HorizontalAlign.JUSTIFY)
				{
					//if we justify items horizontally, we can skip percent width
					item.x = item.pivotX + boundsX + this._paddingLeft;
					item.width = availableWidth - this._paddingLeft - this._paddingRight;
				}
				else
				{
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
							item.x = item.pivotX + boundsX + horizontalAlignWidth - this._paddingRight - item.width;
							break;
						}
						case HorizontalAlign.CENTER:
						{
							//round to the nearest pixel when dividing by 2 to
							//align in the center
							item.x = item.pivotX + boundsX + this._paddingLeft + Math.round((horizontalAlignWidth - this._paddingLeft - this._paddingRight - item.width) / 2);
							break;
						}
						default: //left
						{
							item.x = item.pivotX + boundsX + this._paddingLeft;
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
			if(canRepeatItems)
			{
				result.contentY = Number.NEGATIVE_INFINITY;
				result.contentHeight = Number.POSITIVE_INFINITY;
			}
			else
			{
				result.contentY = 0;
				result.contentHeight = totalHeight;
			}
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

			var gap:Number = this._gap;
			var positionY:Number = 0;

			var maxItemWidth:Number = calculatedTypicalItemWidth;
			positionY += ((calculatedTypicalItemHeight + gap) * itemCount);
			positionY -= gap;

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
					var resultHeight:Number = (calculatedTypicalItemHeight + gap) * this._requestedRowCount - gap;
				}
				else
				{
					resultHeight = positionY;
				}
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
			var calculatedTypicalItemHeight:Number = this._typicalItem ? this._typicalItem.height : 0;
			var gap:Number = this._gap;

			var resultLastIndex:int = 0;
			//we add one extra here because the first item renderer in view may
			//be partially obscured, which would reveal an extra item renderer.
			var maxVisibleTypicalItemCount:int = Math.ceil(height / (calculatedTypicalItemHeight + gap)) + 1;

			var totalItemHeight:Number = itemCount * (calculatedTypicalItemHeight + gap) - gap;

			scrollY -= Math.round((height - calculatedTypicalItemHeight) / 2);

			var canRepeatItems:Boolean = this._repeatItems && totalItemHeight > height;
			if(canRepeatItems)
			{
				//if we're repeating, then there's an extra gap
				totalItemHeight += gap;
				scrollY %= totalItemHeight;
				if(scrollY < 0)
				{
					scrollY += totalItemHeight;
				}
				var minimum:int = scrollY / (calculatedTypicalItemHeight + gap);
				var maximum:int = minimum + maxVisibleTypicalItemCount;
			}
			else
			{
				minimum = scrollY / (calculatedTypicalItemHeight + gap);
				if(minimum < 0)
				{
					minimum = 0;
				}
				//if we're scrolling beyond the final item, we should keep the
				//indices consistent so that items aren't destroyed and
				//recreated unnecessarily
				maximum = minimum + maxVisibleTypicalItemCount;
				if(maximum >= itemCount)
				{
					maximum = itemCount - 1;
				}
				minimum = maximum - maxVisibleTypicalItemCount;
				if(minimum < 0)
				{
					minimum = 0;
				}
			}
			for(var i:int = minimum; i <= maximum; i++)
			{
				if(!canRepeatItems || (i >= 0 && i < itemCount))
				{
					result[resultLastIndex] = i;
				}
				else if(i < 0)
				{
					result[resultLastIndex] = itemCount + i;
				}
				else if(i >= itemCount)
				{
					var loopedI:int = i - itemCount;
					if(loopedI === minimum)
					{
						//we don't want to repeat items!
						break;
					}
					result[resultLastIndex] = loopedI;
				}
				resultLastIndex++;
			}
			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function calculateNavigationDestination(items:Vector.<DisplayObject>, index:int, keyCode:uint, bounds:LayoutBoundsResult):int
		{
			var result:int = index;
			if(keyCode === Keyboard.HOME)
			{
				if(items.length > 0)
				{
					result = 0;
				}
			}
			else if(keyCode === Keyboard.END)
			{
				result = items.length - 1;
			}
			else if(keyCode === Keyboard.UP)
			{
				result--;
			}
			else if(keyCode === Keyboard.DOWN)
			{
				result++;
			}
			if(result < 0)
			{
				return 0;
			}
			if(result >= items.length)
			{
				return items.length - 1;
			}
			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function getNearestScrollPositionForIndex(index:int, scrollX:Number, scrollY:Number, items:Vector.<DisplayObject>,
			x:Number, y:Number, width:Number, height:Number, result:Point = null):Point
		{
			//normally, this isn't acceptable, but because the selection is
			//based on the scroll position, it must work this way.
			return this.getScrollPositionForIndex(index, items, x, y, width, height, result);
		}

		/**
		 * @inheritDoc
		 */
		public function getScrollPositionForIndex(index:int, items:Vector.<DisplayObject>, x:Number, y:Number, width:Number, height:Number, result:Point = null):Point
		{
			this.prepareTypicalItem(width - this._paddingLeft - this._paddingRight);
			var calculatedTypicalItemHeight:Number = this._typicalItem ? this._typicalItem.height : 0;

			if(!result)
			{
				result = new Point();
			}
			result.x = 0;
			result.y = calculatedTypicalItemHeight * index;

			return result;
		}

		/**
		 * @private
		 */
		protected function validateItems(items:Vector.<DisplayObject>, justifyWidth:Number, distributedHeight:Number):void
		{
			//if the alignment is justified, then we want to set the width of
			//each item before validating because setting one dimension may
			//cause the other dimension to change, and that will invalidate the
			//layout if it happens after validation, causing more invalidation
			var isJustified:Boolean = this._horizontalAlign == HorizontalAlign.JUSTIFY;
			var mustSetJustifyWidth:Boolean = isJustified && justifyWidth === justifyWidth; //!isNaN
			var itemCount:int = items.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:DisplayObject = items[i];
				if(!item || (item is ILayoutDisplayObject && !ILayoutDisplayObject(item).includeInLayout))
				{
					continue;
				}
				if(mustSetJustifyWidth)
				{
					item.width = justifyWidth;
				}
				else if(isJustified && item is IFeathersControl)
				{
					//the alignment is justified, but we don't yet have a width
					//to use, so we need to ensure that we accurately measure
					//the items instead of using an old justified width that may
					//be wrong now!
					item.width = NaN;
				}
				if(item is IValidating)
				{
					IValidating(item).validate()
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
			if(this._horizontalAlign == HorizontalAlign.JUSTIFY &&
				justifyWidth === justifyWidth) //!isNaN
			{
				this._typicalItem.width = justifyWidth;
			}
			else if(this._resetTypicalItemDimensionsOnMeasure)
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
	}
}
