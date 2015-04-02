/*
Feathers
Copyright 2012-2015 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.layout
{
	import feathers.core.IValidating;

	import flash.errors.IllegalOperationError;

	import flash.geom.Point;

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
	 * Positions items of different dimensions from left to right in multiple
	 * rows. When the width of a row reaches the width of the container, a new
	 * row will be started. Constrained to the suggested width, the flow layout
	 * will change in height as the number of items increases or decreases.
	 *
	 * @see ../../../help/flow-layout.html How to use FlowLayout with Feathers containers
	 */
	public class FlowLayout extends EventDispatcher implements IVariableVirtualLayout
	{
		/**
		 * If the total item height is smaller than the height of the bounds,
		 * the items will be aligned to the top.
		 *
		 * @see #rowVerticalAlign
		 */
		public static const VERTICAL_ALIGN_TOP:String = "top";

		/**
		 * If the total item height is smaller than the height of the bounds,
		 * the items will be aligned to the middle.
		 *
		 * @see #rowVerticalAlign
		 */
		public static const VERTICAL_ALIGN_MIDDLE:String = "middle";

		/**
		 * If the total item height is smaller than the height of the bounds,
		 * the items will be aligned to the bottom.
		 *
		 * @see #rowVerticalAlign
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
		 * Constructor.
		 */
		public function FlowLayout()
		{
		}

		/**
		 * @private
		 */
		protected var _rowItems:Vector.<DisplayObject> = new <DisplayObject>[];

		[Bindable(event="change")]
		/**
		 * Quickly sets both <code>horizontalGap</code> and <code>verticalGap</code>
		 * to the same value. The <code>gap</code> getter always returns the
		 * value of <code>horizontalGap</code>, but the value of
		 * <code>verticalGap</code> may be different.
		 *
		 * @default 0
		 *
		 * @see #horizontalGap
		 * @see #verticalGap
		 */
		public function get gap():Number
		{
			return this._horizontalGap;
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

		[Bindable(event="change")]
		/**
		 * The horizontal space, in pixels, between items.
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

		[Bindable(event="change")]
		/**
		 * The vertical space, in pixels, between items.
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

		[Bindable(event="change")]
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

		[Bindable(event="change")]
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

		[Bindable(event="change")]
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

		[Bindable(event="change")]
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

		[Bindable(event="change")]
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
		protected var _horizontalAlign:String = HORIZONTAL_ALIGN_LEFT;

		[Bindable(event="change")]
		[Inspectable(type="String",enumeration="left,center,right")]
		/**
		 * If the total row width is less than the bounds, the items in the row
		 * can be aligned horizontally.
		 *
		 * @default FlowLayout.HORIZONTAL_ALIGN_LEFT
		 *
		 * @see #HORIZONTAL_ALIGN_LEFT
		 * @see #HORIZONTAL_ALIGN_CENTER
		 * @see #HORIZONTAL_ALIGN_RIGHT
		 * @see #verticalAlign
		 * @see #rowVerticalAlign
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
		protected var _verticalAlign:String = VERTICAL_ALIGN_TOP;

		[Bindable(event="change")]
		[Inspectable(type="String",enumeration="top,middle,bottom")]
		/**
		 * If the total height of the content is less than the bounds, the
		 * content may be aligned vertically.
		 *
		 * @default FlowLayout.VERTICAL_ALIGN_TOP
		 *
		 * @see #VERTICAL_ALIGN_TOP
		 * @see #VERTICAL_ALIGN_MIDDLE
		 * @see #VERTICAL_ALIGN_BOTTOM
		 * @see #horizontalAlign
		 * @see #rowVerticalAlign
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
		protected var _rowVerticalAlign:String = VERTICAL_ALIGN_TOP;

		[Bindable(event="change")]
		[Inspectable(type="String",enumeration="top,middle,bottom")]
		/**
		 * If the height of an item is less than the height of a row, it can be
		 * aligned vertically.
		 *
		 * @default FlowLayout.VERTICAL_ALIGN_TOP
		 *
		 * @see #VERTICAL_ALIGN_TOP
		 * @see #VERTICAL_ALIGN_MIDDLE
		 * @see #VERTICAL_ALIGN_BOTTOM
		 * @see #horizontalAlign
		 * @see #verticalAlign
		 */
		public function get rowVerticalAlign():String
		{
			return this._rowVerticalAlign;
		}

		/**
		 * @private
		 */
		public function set rowVerticalAlign(value:String):void
		{
			if(this._rowVerticalAlign == value)
			{
				return;
			}
			this._rowVerticalAlign = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _useVirtualLayout:Boolean = true;

		[Bindable(event="change")]
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
		protected var _typicalItem:DisplayObject;

		[Bindable(event="change")]
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
		protected var _hasVariableItemDimensions:Boolean = true;

		[Bindable(event="change")]
		/**
		 * When the layout is virtualized, and this value is true, the items may
		 * have variable width and height values. If false, the items will all
		 * share the same dimensions with the typical item.
		 *
		 * @default true
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

		[Bindable(event="change")]
		/**
		 * @inheritDoc
		 */
		public function get requiresLayoutOnScroll():Boolean
		{
			return this._useVirtualLayout;
		}

		/**
		 * @private
		 */
		protected var _widthCache:Array = [];

		/**
		 * @private
		 */
		protected var _heightCache:Array = [];

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
			var boundsX:Number = viewPortBounds ? viewPortBounds.x : 0;
			var boundsY:Number = viewPortBounds ? viewPortBounds.y : 0;
			var minWidth:Number = viewPortBounds ? viewPortBounds.minWidth : 0;
			var minHeight:Number = viewPortBounds ? viewPortBounds.minHeight : 0;
			var maxWidth:Number = viewPortBounds ? viewPortBounds.maxWidth : Number.POSITIVE_INFINITY;
			var maxHeight:Number = viewPortBounds ? viewPortBounds.maxHeight : Number.POSITIVE_INFINITY;
			var explicitWidth:Number = viewPortBounds ? viewPortBounds.explicitWidth : NaN;
			var explicitHeight:Number = viewPortBounds ? viewPortBounds.explicitHeight : NaN;
			
			//let's figure out if we can show multiple rows
			var supportsMultipleRows:Boolean = true;
			var availableRowWidth:Number = explicitWidth;
			if(availableRowWidth !== availableRowWidth) //isNaN
			{
				availableRowWidth = maxWidth;
				if(availableRowWidth === Number.POSITIVE_INFINITY)
				{
					supportsMultipleRows = false;
				}
			}

			if(this._useVirtualLayout)
			{
				//if the layout is virtualized, we'll need the dimensions of the
				//typical item so that we have fallback values when an item is null
				if(this._typicalItem is IValidating)
				{
					IValidating(this._typicalItem).validate();
				}
				var calculatedTypicalItemWidth:Number = this._typicalItem ? this._typicalItem.width : 0;
				var calculatedTypicalItemHeight:Number = this._typicalItem ? this._typicalItem.height : 0;
			}

			var i:int = 0;
			var itemCount:int = items.length;
			var positionY:Number = boundsY + this._paddingTop;
			var maxItemHeight:Number = 0;
			var horizontalGap:Number = this._horizontalGap;
			var verticalGap:Number = this._verticalGap;
			do
			{
				if(i > 0)
				{
					positionY += maxItemHeight + verticalGap;
				}
				//this section prepares some variables needed for the following loop
				maxItemHeight = this._useVirtualLayout ? calculatedTypicalItemHeight : 0;
				var positionX:Number = boundsX + this._paddingLeft;
				//we save the items in this row to align them later.
				this._rowItems.length = 0;
				var rowItemCount:int = 0;
	
				//this first loop sets the x position of items, and it calculates
				//the total width of all items
				for(; i < itemCount; i++)
				{
					var item:DisplayObject = items[i];
	
					if(this._useVirtualLayout && this._hasVariableItemDimensions)
					{
						var cachedWidth:Number = this._widthCache[i];
						var cachedHeight:Number = this._heightCache[i];
					}
					if(this._useVirtualLayout && !item)
					{
						//the item is null, and the layout is virtualized, so we
						//need to estimate the width of the item.
						
						if(this._hasVariableItemDimensions)
						{
							if(cachedWidth !== cachedWidth)
							{
								var itemWidth:Number = calculatedTypicalItemWidth;
							}
							else
							{
								itemWidth = cachedWidth;
							}
							if(cachedHeight !== cachedHeight)
							{
								var itemHeight:Number = calculatedTypicalItemHeight;
							}
							else
							{
								itemHeight = cachedHeight;
							}
						}
						else
						{
							itemWidth = calculatedTypicalItemWidth;
							itemHeight = calculatedTypicalItemHeight;
						}
					}
					else
					{
						//we get here if the item isn't null. it is never null if
						//the layout isn't virtualized.
						if(item is ILayoutDisplayObject && !ILayoutDisplayObject(item).includeInLayout)
						{
							continue;
						}
						if(item is IValidating)
						{
							IValidating(item).validate();
						}
						itemWidth = item.width;
						itemHeight = item.height;
						if(this._useVirtualLayout)
						{
							if(this._hasVariableItemDimensions)
							{
								if(itemWidth != cachedWidth)
								{
									//update the cache if needed. this will notify
									//the container that the virtualized layout has
									//changed, and it the view port may need to be
									//re-measured.
									this._widthCache[i] = itemWidth;
									this.dispatchEventWith(Event.CHANGE);
								}
								if(itemHeight != cachedHeight)
								{
									this._heightCache[i] = itemHeight;
									this.dispatchEventWith(Event.CHANGE);
								}
							}
							else
							{
								if(calculatedTypicalItemWidth >= 0)
								{
									item.width = itemWidth = calculatedTypicalItemWidth;
								}
								if(calculatedTypicalItemHeight >= 0)
								{
									item.height = itemHeight = calculatedTypicalItemHeight;
								}
							}
						}
					}
					if(supportsMultipleRows && rowItemCount > 0 && (positionX + itemWidth) > (availableRowWidth - this._paddingRight))
					{
						//we've reached the end of the row, so go to next
						break;
					}
					if(item)
					{
						this._rowItems[this._rowItems.length] = item;
						item.x = item.pivotX + positionX;
					}
					positionX += itemWidth + horizontalGap;
					//we compare with > instead of Math.max() because the rest
					//arguments on Math.max() cause extra garbage collection and
					//hurt performance
					if(itemHeight > maxItemHeight)
					{
						//we need to know the maximum height of the items in the
						//case where the height of the view port needs to be
						//calculated by the layout.
						maxItemHeight = itemHeight;
					}
					rowItemCount++;
				}
	
				//this is the total width of all items in the row
				var totalRowWidth:Number = positionX - horizontalGap + this._paddingRight - boundsX;
				rowItemCount = this._rowItems.length;
	
				if(supportsMultipleRows)
				{
					//in this section, we handle horizontal alignment.
					var horizontalAlignOffsetX:Number = 0;
					if(this._horizontalAlign == HORIZONTAL_ALIGN_RIGHT)
					{
						horizontalAlignOffsetX = availableRowWidth - totalRowWidth;
					}
					else if(this._horizontalAlign == HORIZONTAL_ALIGN_CENTER)
					{
						horizontalAlignOffsetX = Math.round((availableRowWidth - totalRowWidth) / 2);
					}
					if(horizontalAlignOffsetX != 0)
					{
						for(var j:int = 0; j < rowItemCount; j++)
						{
							item = this._rowItems[j];
							if(item is ILayoutDisplayObject && !ILayoutDisplayObject(item).includeInLayout)
							{
								continue;
							}
							item.x += horizontalAlignOffsetX;
						}
					}
				}
	
				for(j = 0; j < rowItemCount; j++)
				{
					item = this._rowItems[j];
					var layoutItem:ILayoutDisplayObject = item as ILayoutDisplayObject;
					if(layoutItem && !layoutItem.includeInLayout)
					{
						continue;
					}
					//handle all other vertical alignment values. the y position
					//of all items is set here.
					switch(this._rowVerticalAlign)
					{
						case VERTICAL_ALIGN_BOTTOM:
						{
							item.y = item.pivotY + positionY + maxItemHeight - item.height;
							break;
						}
						case VERTICAL_ALIGN_MIDDLE:
						{
							//round to the nearest pixel when dividing by 2 to
							//align in the middle
							item.y = item.pivotY + positionY + Math.round((maxItemHeight - item.height) / 2);
							break;
						}
						default: //top
						{
							item.y = item.pivotY + positionY;
						}
					}
				}
			}
			while(i < itemCount)
			//we don't want to keep a reference to any of the items, so clear
			//this cache
			this._rowItems.length = 0;

			var totalHeight:Number = positionY + maxItemHeight + this._paddingBottom;
			//the available height is the height of the viewport. if the explicit
			//height is NaN, we need to calculate the viewport height ourselves
			//based on the total height of all items.
			var availableHeight:Number = explicitHeight;
			if(availableHeight !== availableHeight) //isNaN
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
			
			if(totalHeight < availableHeight &&
				this._verticalAlign != VERTICAL_ALIGN_TOP)
			{
				var verticalAlignOffset:Number = availableHeight - totalHeight;
				if(this._verticalAlign === VERTICAL_ALIGN_MIDDLE)
				{
					verticalAlignOffset /= 2;
				}
				for(i = 0; i < itemCount; i++)
				{
					item = items[i];
					if(!item || (item is ILayoutDisplayObject && !ILayoutDisplayObject(item).includeInLayout))
					{
						continue;
					}
					item.y += verticalAlignOffset;
				}
			}

			//finally, we want to calculate the result so that the container
			//can use it to adjust its viewport and determine the minimum and
			//maximum scroll positions (if needed)
			if(!result)
			{
				result = new LayoutBoundsResult();
			}
			result.contentX = 0;
			result.contentWidth = availableRowWidth;
			result.contentY = 0;
			result.contentHeight = totalHeight;
			result.viewPortWidth = availableRowWidth;
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
			//this function is very long because it may be called every frame,
			//in some situations. testing revealed that splitting this function
			//into separate, smaller functions affected performance.
			//since the SWC compiler cannot inline functions, we can't use that
			//feature either.

			//since viewPortBounds can be null, we may need to provide some defaults
			var boundsX:Number = viewPortBounds ? viewPortBounds.x : 0;
			var boundsY:Number = viewPortBounds ? viewPortBounds.y : 0;
			var minWidth:Number = viewPortBounds ? viewPortBounds.minWidth : 0;
			var minHeight:Number = viewPortBounds ? viewPortBounds.minHeight : 0;
			var maxWidth:Number = viewPortBounds ? viewPortBounds.maxWidth : Number.POSITIVE_INFINITY;
			var maxHeight:Number = viewPortBounds ? viewPortBounds.maxHeight : Number.POSITIVE_INFINITY;
			var explicitWidth:Number = viewPortBounds ? viewPortBounds.explicitWidth : NaN;
			var explicitHeight:Number = viewPortBounds ? viewPortBounds.explicitHeight : NaN;

			//let's figure out if we can show multiple rows
			var supportsMultipleRows:Boolean = true;
			var availableRowWidth:Number = explicitWidth;
			if(availableRowWidth !== availableRowWidth) //isNaN
			{
				availableRowWidth = maxWidth;
				if(availableRowWidth === Number.POSITIVE_INFINITY)
				{
					supportsMultipleRows = false;
				}
			}
			
			if(this._typicalItem is IValidating)
			{
				IValidating(this._typicalItem).validate();
			}
			var calculatedTypicalItemWidth:Number = this._typicalItem ? this._typicalItem.width : 0;
			var calculatedTypicalItemHeight:Number = this._typicalItem ? this._typicalItem.height : 0;

			var i:int = 0;
			var positionY:Number = boundsY + this._paddingTop;
			var maxItemHeight:Number = 0;
			var horizontalGap:Number = this._horizontalGap;
			var verticalGap:Number = this._verticalGap;
			do
			{
				if(i > 0)
				{
					positionY += maxItemHeight + verticalGap;
				}
				//this section prepares some variables needed for the following loop
				maxItemHeight = this._useVirtualLayout ? calculatedTypicalItemHeight : 0;
				var positionX:Number = boundsX + this._paddingLeft;
				var rowItemCount:int = 0;

				//this first loop sets the x position of items, and it calculates
				//the total width of all items
				for(; i < itemCount; i++)
				{
					if(this._hasVariableItemDimensions)
					{
						var cachedWidth:Number = this._widthCache[i];
						var cachedHeight:Number = this._heightCache[i];
						if(cachedWidth !== cachedWidth)
						{
							var itemWidth:Number = calculatedTypicalItemWidth;
						}
						else
						{
							itemWidth = cachedWidth;
						}
						if(cachedHeight !== cachedHeight)
						{
							var itemHeight:Number = calculatedTypicalItemHeight;
						}
						else
						{
							itemHeight = cachedHeight;
						}
					}
					else
					{
						itemWidth = calculatedTypicalItemWidth;
						itemHeight = calculatedTypicalItemHeight;
					}
					if(supportsMultipleRows && rowItemCount > 0 && (positionX + itemWidth) > (availableRowWidth - this._paddingRight))
					{
						//we've reached the end of the row, so go to next
						break;
					}
					positionX += itemWidth + horizontalGap;
					//we compare with > instead of Math.max() because the rest
					//arguments on Math.max() cause extra garbage collection and
					//hurt performance
					if(itemHeight > maxItemHeight)
					{
						//we need to know the maximum height of the items in the
						//case where the height of the view port needs to be
						//calculated by the layout.
						maxItemHeight = itemHeight;
					}
					rowItemCount++;
				}
			}
			while(i < itemCount)
			
			var totalHeight:Number = positionY + maxItemHeight + this._paddingBottom;
			//the available height is the height of the viewport. if the explicit
			//height is NaN, we need to calculate the viewport height ourselves
			//based on the total height of all items.
			var availableHeight:Number = explicitHeight;
			if(availableHeight !== availableHeight) //isNaN
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

			result.x = availableRowWidth;
			result.y = availableHeight;
			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function getNearestScrollPositionForIndex(index:int, scrollX:Number, scrollY:Number, items:Vector.<DisplayObject>,
			x:Number, y:Number, width:Number, height:Number, result:Point = null):Point
		{
			result = this.calculateMaxScrollYAndRowHeightOfIndex(index, items, x, y, width, height, result);
			var maxScrollY:Number = result.x;
			var rowHeight:Number = result.y;
			
			result.x = 0;
			
			var bottomPosition:Number = maxScrollY - (height - rowHeight);
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
		public function getScrollPositionForIndex(index:int, items:Vector.<DisplayObject>, x:Number, y:Number, width:Number, height:Number, result:Point = null):Point
		{
			result = this.calculateMaxScrollYAndRowHeightOfIndex(index, items, x, y, width, height, result);
			var maxScrollY:Number = result.x;
			var rowHeight:Number = result.y;

			if(this._useVirtualLayout)
			{
				if(this._hasVariableItemDimensions)
				{
					var itemHeight:Number = this._heightCache[index];
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
			result.y = maxScrollY - Math.round((height - itemHeight) / 2);

			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function resetVariableVirtualCache():void
		{
			this._widthCache.length = 0;
			this._heightCache.length = 0;
		}

		/**
		 * @inheritDoc
		 */
		public function resetVariableVirtualCacheAtIndex(index:int, item:DisplayObject = null):void
		{
			delete this._widthCache[index];
			delete this._heightCache[index];
			if(item)
			{
				this._widthCache[index] = item.width;
				this._heightCache[index] = item.height;
				this.dispatchEventWith(Event.CHANGE);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function addToVariableVirtualCacheAtIndex(index:int, item:DisplayObject = null):void
		{
			var widthValue:* = item ? item.width: undefined;
			this._widthCache.splice(index, 0, widthValue);
			
			var heightValue:* = item ? item.height : undefined;
			this._heightCache.splice(index, 0, heightValue);
		}

		/**
		 * @inheritDoc
		 */
		public function removeFromVariableVirtualCacheAtIndex(index:int):void
		{
			this._widthCache.splice(index, 1);
			this._heightCache.splice(index, 1);
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

			if(this._typicalItem is IValidating)
			{
				IValidating(this._typicalItem).validate();
			}
			var calculatedTypicalItemWidth:Number = this._typicalItem ? this._typicalItem.width : 0;
			var calculatedTypicalItemHeight:Number = this._typicalItem ? this._typicalItem.height : 0;

			var resultLastIndex:int = 0;

			var i:int = 0;
			var positionY:Number = this._paddingTop;
			var maxItemHeight:Number = 0;
			var horizontalGap:Number = this._horizontalGap;
			var verticalGap:Number = this._verticalGap;
			var maxPositionY:Number = scrollY + height;
			do
			{
				if(i > 0)
				{
					positionY += maxItemHeight + verticalGap;
					if(positionY >= maxPositionY)
					{
						//the following rows will not be visible, so we can stop
						break;
					}
				}
				//this section prepares some variables needed for the following loop
				maxItemHeight = calculatedTypicalItemHeight;
				var positionX:Number = this._paddingLeft;
				var rowItemCount:int = 0;

				//this first loop sets the x position of items, and it calculates
				//the total width of all items
				for(; i < itemCount; i++)
				{
					if(this._hasVariableItemDimensions)
					{
						var cachedWidth:Number = this._widthCache[i];
						var cachedHeight:Number = this._heightCache[i];
					}
					if(this._hasVariableItemDimensions)
					{
						if(cachedWidth !== cachedWidth)
						{
							var itemWidth:Number = calculatedTypicalItemWidth;
						}
						else
						{
							itemWidth = cachedWidth;
						}
						if(cachedHeight !== cachedHeight)
						{
							var itemHeight:Number = calculatedTypicalItemHeight;
						}
						else
						{
							itemHeight = cachedHeight;
						}
					}
					else
					{
						itemWidth = calculatedTypicalItemWidth;
						itemHeight = calculatedTypicalItemHeight;
					}
					if(rowItemCount > 0 && (positionX + itemWidth) > (width - this._paddingRight))
					{
						//we've reached the end of the row, so go to next
						break;
					}
					if((positionY + itemHeight) > scrollY)
					{
						result[resultLastIndex] = i;
						resultLastIndex++;
					}
					positionX += itemWidth + horizontalGap;
					//we compare with > instead of Math.max() because the rest
					//arguments on Math.max() cause extra garbage collection and
					//hurt performance
					if(itemHeight > maxItemHeight)
					{
						//we need to know the maximum height of the items in the
						//case where the height of the view port needs to be
						//calculated by the layout.
						maxItemHeight = itemHeight;
					}
					rowItemCount++;
				}
			}
			while(i < itemCount)
			return result;
		}

		/**
		 * @private
		 */
		protected function calculateMaxScrollYAndRowHeightOfIndex(index:int, items:Vector.<DisplayObject>,
			x:Number, y:Number, width:Number, height:Number, result:Point = null):Point
		{
			if(!result)
			{
				result = new Point();
			}
			if(this._useVirtualLayout)
			{
				//if the layout is virtualized, we'll need the dimensions of the
				//typical item so that we have fallback values when an item is null
				if(this._typicalItem is IValidating)
				{
					IValidating(this._typicalItem).validate();
				}
				var calculatedTypicalItemWidth:Number = this._typicalItem ? this._typicalItem.width : 0;
				var calculatedTypicalItemHeight:Number = this._typicalItem ? this._typicalItem.height : 0;
			}

			var horizontalGap:Number = this._horizontalGap;
			var verticalGap:Number = this._verticalGap;
			var maxItemHeight:Number = 0;
			var positionY:Number = y + this._paddingTop;
			var i:int = 0;
			var itemCount:int = items.length;
			var isLastRow:Boolean = false;
			do
			{
				if(isLastRow)
				{
					break;
				}
				if(i > 0)
				{
					positionY += maxItemHeight + verticalGap;
				}
				//this section prepares some variables needed for the following loop
				maxItemHeight = this._useVirtualLayout ? calculatedTypicalItemHeight : 0;
				var positionX:Number = x + this._paddingLeft;
				var rowItemCount:int = 0;
				for(; i < itemCount; i++)
				{
					var item:DisplayObject = items[i];

					if(this._useVirtualLayout && this._hasVariableItemDimensions)
					{
						var cachedWidth:Number = this._widthCache[i];
						var cachedHeight:Number = this._heightCache[i];
					}
					if(this._useVirtualLayout && !item)
					{
						//the item is null, and the layout is virtualized, so we
						//need to estimate the width of the item.

						if(this._hasVariableItemDimensions)
						{
							if(cachedWidth !== cachedWidth) //isNaN
							{
								var itemWidth:Number = calculatedTypicalItemWidth;
							}
							else
							{
								itemWidth = cachedWidth;
							}
							if(cachedHeight !== cachedHeight) //isNaN
							{
								var itemHeight:Number = calculatedTypicalItemHeight;
							}
							else
							{
								itemHeight = cachedHeight;
							}
						}
						else
						{
							itemWidth = calculatedTypicalItemWidth;
							itemHeight = calculatedTypicalItemHeight;
						}
					}
					else
					{
						//we get here if the item isn't null. it is never null if
						//the layout isn't virtualized.
						if(item is ILayoutDisplayObject && !ILayoutDisplayObject(item).includeInLayout)
						{
							continue;
						}
						if(item is IValidating)
						{
							IValidating(item).validate();
						}
						itemWidth = item.width;
						itemHeight = item.height;
						if(this._useVirtualLayout && this._hasVariableItemDimensions)
						{
							if(this._hasVariableItemDimensions)
							{
								if(itemWidth != cachedWidth)
								{
									this._widthCache[i] = itemWidth;
									this.dispatchEventWith(Event.CHANGE);
								}
								if(itemHeight != cachedHeight)
								{
									this._heightCache[i] = itemHeight;
									this.dispatchEventWith(Event.CHANGE);
								}
							}
							else
							{
								if(calculatedTypicalItemWidth >= 0)
								{
									itemWidth = calculatedTypicalItemWidth;
								}
								if(calculatedTypicalItemHeight >= 0)
								{
									itemHeight = calculatedTypicalItemHeight;
								}
							}
						}
					}
					if(rowItemCount > 0 && (positionX + itemWidth) > (width - this._paddingRight))
					{
						//we've reached the end of the row, so go to next
						break;
					}
					//we don't check this at the beginning of the loop because
					//it may break to start a new row and then redo this item
					if(i === index)
					{
						isLastRow = true;
					}
					//we compare with > instead of Math.max() because the rest
					//arguments on Math.max() cause extra garbage collection and
					//hurt performance
					if(itemHeight > maxItemHeight)
					{
						//we need to know the maximum height of the items in the
						//case where the height of the view port needs to be
						//calculated by the layout.
						maxItemHeight = itemHeight;
					}
					positionX += itemWidth + horizontalGap;
					rowItemCount++;
				}
			}
			while(i < itemCount)
			result.setTo(positionY, maxItemHeight);
			return result;
		}
	}
}
