/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

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
	 * Dispatched when the layout would like to adjust the container's scroll
	 * position. Typically, this is used when the virtual dimensions of an item
	 * differ from its real dimensions. This event allows the container to
	 * adjust scrolling so that it appears smooth, without jarring jumps or
	 * shifts when an item resizes.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>A <code>flash.geom.Point</code> object
	 *   representing how much the scroll position should be adjusted in both
	 *   horizontal and vertical directions. Measured in pixels.</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @eventType starling.events.Event.SCROLL
	 */
	[Event(name="scroll",type="starling.events.Event")]

	/**
	 * Positions items from left to right in a single row.
	 *
	 * @see ../../../help/horizontal-layout.html How to use HorizontalLayout with Feathers containers
	 */
	public class HorizontalLayout extends EventDispatcher implements IVariableVirtualLayout, ITrimmedVirtualLayout
	{
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

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.VerticalAlign.JUSTIFY</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const VERTICAL_ALIGN_JUSTIFY:String = "justify";

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
		 * @private
		 */
		protected var _firstGap:Number = NaN;

		/**
		 * The space, in pixels, between the first and second items. If the
		 * value of <code>firstGap</code> is <code>NaN</code>, the value of the
		 * <code>gap</code> property will be used instead.
		 *
		 * @default NaN
		 */
		public function get firstGap():Number
		{
			return this._firstGap;
		}

		/**
		 * @private
		 */
		public function set firstGap(value:Number):void
		{
			if(this._firstGap == value)
			{
				return;
			}
			this._firstGap = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _lastGap:Number = NaN;

		/**
		 * The space, in pixels, between the last and second to last items. If
		 * the value of <code>lastGap</code> is <code>NaN</code>, the value of
		 * the <code>gap</code> property will be used instead.
		 *
		 * @default NaN
		 */
		public function get lastGap():Number
		{
			return this._lastGap;
		}

		/**
		 * @private
		 */
		public function set lastGap(value:Number):void
		{
			if(this._lastGap == value)
			{
				return;
			}
			this._lastGap = value;
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
		 * The space, in pixels, that appears to the right, after the last item.
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
		 * The space, in pixels, that appears to the left, before the first
		 * item.
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
		protected var _verticalAlign:String = VerticalAlign.TOP;

		[Inspectable(type="String",enumeration="top,middle,bottom,justify")]
		/**
		 * The alignment of the items vertically, on the y-axis.
		 *
		 * <p>If the <code>verticalAlign</code> property is set to
		 * <code>VerticalAlign.JUSTIFY</code>, the
		 * <code>height</code>, <code>minHeight</code>, and
		 * <code>maxHeight</code> properties of the items may be changed, and
		 * their original values ignored by the layout. In this situation, if
		 * the height needs to be constrained, the <code>height</code>,
		 * <code>minHeight</code>, or <code>maxHeight</code> properties should
		 * instead be set on the parent container that is using this layout.</p>
		 *
		 * @default feathers.layout.VerticalAlign.TOP
		 *
		 * @see feathers.layout.VerticalAlign#TOP
		 * @see feathers.layout.VerticalAlign#MIDDLE
		 * @see feathers.layout.VerticalAlign#BOTTOM
		 * @see feathers.layout.VerticalAlign#JUSTIFY
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
		protected var _horizontalAlign:String = HorizontalAlign.LEFT;

		[Inspectable(type="String",enumeration="left,center,right")]
		/**
		 * If the total item width is less than the bounds, the positions of
		 * the items can be aligned horizontally.
		 *
		 * @default feathers.layout.HorizontalAlign.LEFT
		 *
		 * @see feathers.layout.HorizontalAlign#LEFT
		 * @see feathers.layout.HorizontalAlign#CENTER
		 * @see feathers.layout.HorizontalAlign#RIGHT
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
		 * When the layout is virtualized, and this value is true, the items may
		 * have variable width values. If false, the items will all share the
		 * same width value with the typical item.
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
		 * @private
		 */
		protected var _requestedColumnCount:int = 0;

		/**
		 * Requests that the layout set the view port dimensions to display a
		 * specific number of columns (plus gaps and padding), if possible. If
		 * the explicit width of the view port is set, then this value will be
		 * ignored. If the view port's minimum and/or maximum width are set,
		 * the actual number of visible columns may be adjusted to meet those
		 * requirements. Set this value to <code>0</code> to display as many
		 * columns as possible.
		 *
		 * @default 0
		 */
		public function get requestedColumnCount():int
		{
			return this._requestedColumnCount;
		}

		/**
		 * @private
		 */
		public function set requestedColumnCount(value:int):void
		{
			if(value < 0)
			{
				throw RangeError("requestedColumnCount requires a value >= 0");
			}
			if(this._requestedColumnCount == value)
			{
				return;
			}
			this._requestedColumnCount = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _distributeWidths:Boolean = false;

		/**
		 * Distributes the width of the view port equally to each item. If the
		 * view port width needs to be measured, the largest item's width will
		 * be used for all items, subject to any specified minimum and maximum
		 * width values.
		 *
		 * @default false
		 */
		public function get distributeWidths():Boolean
		{
			return this._distributeWidths;
		}

		/**
		 * @private
		 */
		public function set distributeWidths(value:Boolean):void
		{
			if(this._distributeWidths == value)
			{
				return;
			}
			this._distributeWidths = value;
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
		protected var _scrollPositionHorizontalAlign:String = HorizontalAlign.CENTER;

		[Inspectable(type="String",enumeration="left,center,right")]
		/**
		 * When the scroll position is calculated for an item, an attempt will
		 * be made to align the item to this position.
		 *
		 * @default feathers.layout.HorizontalAlign.CENTER
		 *
		 * @see feathers.layout.HorizontalAlign#LEFT
		 * @see feathers.layout.HorizontalAlign#CENTER
		 * @see feathers.layout.HorizontalAlign#RIGHT
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
		public function get requiresLayoutOnScroll():Boolean
		{
			return this._useVirtualLayout;
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
				this.prepareTypicalItem(explicitHeight - this._paddingTop - this._paddingBottom);
				var calculatedTypicalItemWidth:Number = this._typicalItem ? this._typicalItem.width : 0;
				var calculatedTypicalItemHeight:Number = this._typicalItem ? this._typicalItem.height : 0;
			}

			if(!this._useVirtualLayout || this._hasVariableItemDimensions || this._distributeWidths ||
				this._verticalAlign != VerticalAlign.JUSTIFY ||
				explicitHeight !== explicitHeight) //isNaN
			{
				//in some cases, we may need to validate all of the items so
				//that we can use their dimensions below.
				this.validateItems(items, explicitHeight - this._paddingTop - this._paddingBottom,
					minHeight - this._paddingTop - this._paddingBottom,
					maxHeight - this._paddingTop - this._paddingBottom,
					explicitWidth);
			}

			if(!this._useVirtualLayout)
			{
				//handle the percentWidth property from HorizontalLayoutData,
				//if available.
				this.applyPercentWidths(items, explicitWidth, minWidth, maxWidth);
			}

			var distributedWidth:Number;
			if(this._distributeWidths)
			{
				//distribute the width evenly among all items
				distributedWidth = this.calculateDistributedWidth(items, explicitWidth, minWidth, maxWidth);
			}
			var hasDistributedWidth:Boolean = distributedWidth === distributedWidth; //!isNaN

			//this section prepares some variables needed for the following loop
			var hasFirstGap:Boolean = this._firstGap === this._firstGap; //!isNaN
			var hasLastGap:Boolean = this._lastGap === this._lastGap; //!isNaN
			var maxItemHeight:Number = this._useVirtualLayout ? calculatedTypicalItemHeight : 0;
			var positionX:Number = boundsX + this._paddingLeft;
			var itemCount:int = items.length;
			var totalItemCount:int = itemCount;
			if(this._useVirtualLayout && !this._hasVariableItemDimensions)
			{
				//if the layout is virtualized, and the items all have the same
				//width, we can make our loops smaller by skipping some items
				//at the beginning and end. this improves performance.
				totalItemCount += this._beforeVirtualizedItemCount + this._afterVirtualizedItemCount;
				positionX += (this._beforeVirtualizedItemCount * (calculatedTypicalItemWidth + this._gap));
				if(hasFirstGap && this._beforeVirtualizedItemCount > 0)
				{
					positionX = positionX - this._gap + this._firstGap;
				}
			}
			var secondToLastIndex:int = totalItemCount - 2;
			//this cache is used to save non-null items in virtual layouts. by
			//using a smaller array, we can improve performance by spending less
			//time in the upcoming loops.
			this._discoveredItemsCache.length = 0;
			var discoveredItemsCacheLastIndex:int = 0;

			//if there are no items in layout, then we don't want to subtract
			//any gap when calculating the total width, so default to 0.
			var gap:Number = 0;

			//this first loop sets the x position of items, and it calculates
			//the total width of all items
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:DisplayObject = items[i];
				//if we're trimming some items at the beginning, we need to
				//adjust i to account for the missing items in the array
				var iNormalized:int = i + this._beforeVirtualizedItemCount;

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
					var cachedWidth:Number = this._widthCache[iNormalized];
				}
				if(this._useVirtualLayout && !item)
				{
					//the item is null, and the layout is virtualized, so we
					//need to estimate the width of the item.

					if(!this._hasVariableItemDimensions ||
						cachedWidth !== cachedWidth) //isNaN
					{
						//if all items must have the same width, we will
						//use the width of the typical item (calculatedTypicalItemWidth).

						//if items may have different widths, we first check
						//the cache for a width value. if there isn't one, then
						//we'll use calculatedTypicalItemWidth as a fallback.
						positionX += calculatedTypicalItemWidth + gap;
					}
					else
					{
						//if we have variable item widths, we should use a
						//cached width when there's one available. it will be
						//more accurate than the typical item's width.
						positionX += cachedWidth + gap;
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
					item.x = item.pivotX + positionX;
					var itemWidth:Number;
					if(hasDistributedWidth)
					{
						item.width = itemWidth = distributedWidth;
					}
					else
					{
						itemWidth = item.width;
					}
					var itemHeight:Number = item.height;
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
								this._widthCache[iNormalized] = itemWidth;

								//attempt to adjust the scroll position so that
								//it looks like we're scrolling smoothly after
								//this item resizes.
								if(positionX < scrollX &&
									cachedWidth !== cachedWidth && //isNaN
									itemWidth != calculatedTypicalItemWidth)
								{
									this.dispatchEventWith(Event.SCROLL, false, new Point(itemWidth - calculatedTypicalItemWidth, 0));
								}

								this.dispatchEventWith(Event.CHANGE);
							}
						}
						else if(calculatedTypicalItemWidth >= 0)
						{
							//if all items must have the same width, we will
							//use the width of the typical item (calculatedTypicalItemWidth).
							item.width = itemWidth = calculatedTypicalItemWidth;
						}
					}
					positionX += itemWidth + gap;
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
					if(this._useVirtualLayout)
					{
						this._discoveredItemsCache[discoveredItemsCacheLastIndex] = item;
						discoveredItemsCacheLastIndex++;
					}
				}
			}
			if(this._useVirtualLayout && !this._hasVariableItemDimensions)
			{
				//finish the final calculation of the x position so that it can
				//be used for the total width of all items
				positionX += (this._afterVirtualizedItemCount * (calculatedTypicalItemWidth + this._gap));
				if(hasLastGap && this._afterVirtualizedItemCount > 0)
				{
					positionX = positionX - this._gap + this._lastGap;
				}
			}

			//this array will contain all items that are not null. see the
			//comment above where the discoveredItemsCache is initialized for
			//details about why this is important.
			var discoveredItems:Vector.<DisplayObject> = this._useVirtualLayout ? this._discoveredItemsCache : items;
			var discoveredItemCount:int = discoveredItems.length;

			var totalHeight:Number = maxItemHeight + this._paddingTop + this._paddingBottom;
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

			//this is the total width of all items
			var totalWidth:Number = positionX - gap + this._paddingRight - boundsX;
			//the available width is the width of the viewport. if the explicit
			//width is NaN, we need to calculate the viewport width ourselves
			//based on the total width of all items.
			var availableWidth:Number = explicitWidth;
			if(availableWidth !== availableWidth) //isNaN
			{
				if(this._requestedColumnCount > 0)
				{
					availableWidth = (calculatedTypicalItemWidth + this._gap) * this._requestedColumnCount - this._gap + this._paddingLeft + this._paddingRight
				}
				else
				{
					availableWidth = totalWidth;
				}
				if(availableWidth < minWidth)
				{
					availableWidth = minWidth;
				}
				else if(availableWidth > maxWidth)
				{
					availableWidth = maxWidth;
				}
			}

			//in this section, we handle horizontal alignment. items will be
			//aligned horizontally if the total width of all items is less than
			//the available width of the view port.
			if(totalWidth < availableWidth)
			{
				var horizontalAlignOffsetX:Number = 0;
				if(this._horizontalAlign == HorizontalAlign.RIGHT)
				{
					horizontalAlignOffsetX = availableWidth - totalWidth;
				}
				else if(this._horizontalAlign == HorizontalAlign.CENTER)
				{
					horizontalAlignOffsetX = Math.round((availableWidth - totalWidth) / 2);
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
				var layoutItem:ILayoutDisplayObject = item as ILayoutDisplayObject;
				if(layoutItem && !layoutItem.includeInLayout)
				{
					continue;
				}

				//in this section, we handle vertical alignment and percent
				//height from HorizontalLayoutData
				if(this._verticalAlign == VerticalAlign.JUSTIFY)
				{
					//if we justify items vertically, we can skip percent height
					item.y = item.pivotY + boundsY + this._paddingTop;
					item.height = availableHeight - this._paddingTop - this._paddingBottom;
				}
				else
				{
					if(layoutItem)
					{
						var layoutData:HorizontalLayoutData = layoutItem.layoutData as HorizontalLayoutData;
						if(layoutData)
						{
							//in this section, we handle percentage width if
							//VerticalLayoutData is available.
							var percentHeight:Number = layoutData.percentHeight;
							if(percentHeight === percentHeight) //!isNaN
							{
								if(percentHeight < 0)
								{
									percentHeight = 0;
								}
								if(percentHeight > 100)
								{
									percentHeight = 100;
								}
								itemHeight = percentHeight * (availableHeight - this._paddingTop - this._paddingBottom) / 100;
								if(item is IFeathersControl)
								{
									var feathersItem:IFeathersControl = IFeathersControl(item);
									var itemMinHeight:Number = feathersItem.minHeight;
									if(itemHeight < itemMinHeight)
									{
										itemHeight = itemMinHeight;
									}
									else
									{
										var itemMaxHeight:Number = feathersItem.maxHeight;
										if(itemHeight > itemMaxHeight)
										{
											itemHeight = itemMaxHeight;
										}
									}
								}
								item.height = itemHeight;
							}
						}
					}
					//handle all other vertical alignment values (we handled
					//justify already). the y position of all items is set here.
					var verticalAlignHeight:Number = availableHeight;
					if(totalHeight > verticalAlignHeight)
					{
						verticalAlignHeight = totalHeight;
					}
					switch(this._verticalAlign)
					{
						case VerticalAlign.BOTTOM:
						{
							item.y = item.pivotY + boundsY + verticalAlignHeight - this._paddingBottom - item.height;
							break;
						}
						case VerticalAlign.MIDDLE:
						{
							item.y = item.pivotY + boundsY + this._paddingTop + Math.round((verticalAlignHeight - this._paddingTop - this._paddingBottom - item.height) / 2);
							break;
						}
						default: //top
						{
							item.y = item.pivotY + boundsY + this._paddingTop;
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
			result.contentWidth = totalWidth;
			result.contentY = 0;
			result.contentHeight = this._verticalAlign == VerticalAlign.JUSTIFY ? availableHeight : totalHeight;
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

			this.prepareTypicalItem(explicitHeight - this._paddingTop - this._paddingBottom);
			var calculatedTypicalItemWidth:Number = this._typicalItem ? this._typicalItem.width : 0;
			var calculatedTypicalItemHeight:Number = this._typicalItem ? this._typicalItem.height : 0;

			var hasFirstGap:Boolean = this._firstGap === this._firstGap; //!isNaN
			var hasLastGap:Boolean = this._lastGap === this._lastGap; //!isNaN
			var positionX:Number;
			if(this._distributeWidths)
			{
				positionX = (calculatedTypicalItemWidth + this._gap) * itemCount;
			}
			else
			{
				positionX = 0;
				var maxItemHeight:Number = calculatedTypicalItemHeight;
				if(!this._hasVariableItemDimensions)
				{
					positionX += ((calculatedTypicalItemWidth + this._gap) * itemCount);
				}
				else
				{
					for(var i:int = 0; i < itemCount; i++)
					{
						var cachedWidth:Number = this._widthCache[i];
						if(cachedWidth !== cachedWidth) //isNaN
						{
							positionX += calculatedTypicalItemWidth + this._gap;
						}
						else
						{
							positionX += cachedWidth + this._gap;
						}
					}
				}
			}
			positionX -= this._gap;
			if(hasFirstGap && itemCount > 1)
			{
				positionX = positionX - this._gap + this._firstGap;
			}
			if(hasLastGap && itemCount > 2)
			{
				positionX = positionX - this._gap + this._lastGap;
			}

			if(needsWidth)
			{
				if(this._requestedColumnCount > 0)
				{
					var resultWidth:Number = (calculatedTypicalItemWidth + this._gap) * this._requestedColumnCount - this._gap + this._paddingLeft + this._paddingRight
				}
				else
				{
					resultWidth = positionX + this._paddingLeft + this._paddingRight;
				}
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
			var widthValue:* = item ? item.width : undefined;
			this._widthCache.insertAt(index, widthValue);
		}

		/**
		 * @inheritDoc
		 */
		public function removeFromVariableVirtualCacheAtIndex(index:int):void
		{
			this._widthCache.removeAt(index);
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

			var hasFirstGap:Boolean = this._firstGap === this._firstGap; //!isNaN
			var hasLastGap:Boolean = this._lastGap === this._lastGap; //!isNaN
			var resultLastIndex:int = 0;
			//we add one extra here because the first item renderer in view may
			//be partially obscured, which would reveal an extra item renderer.
			var maxVisibleTypicalItemCount:int = Math.ceil(width / (calculatedTypicalItemWidth + this._gap)) + 1;
			if(!this._hasVariableItemDimensions)
			{
				//this case can be optimized because we know that every item has
				//the same width
				var totalItemWidth:Number = itemCount * (calculatedTypicalItemWidth + this._gap) - this._gap;
				if(hasFirstGap && itemCount > 1)
				{
					totalItemWidth = totalItemWidth - this._gap + this._firstGap;
				}
				if(hasLastGap && itemCount > 2)
				{
					totalItemWidth = totalItemWidth - this._gap + this._lastGap;
				}
				var indexOffset:int = 0;
				if(totalItemWidth < width)
				{
					if(this._horizontalAlign == HorizontalAlign.RIGHT)
					{
						indexOffset = Math.ceil((width - totalItemWidth) / (calculatedTypicalItemWidth + this._gap));
					}
					else if(this._horizontalAlign == HorizontalAlign.CENTER)
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
			var secondToLastIndex:int = itemCount - 2;
			var maxPositionX:Number = scrollX + width;
			var positionX:Number = this._paddingLeft;
			for(i = 0; i < itemCount; i++)
			{
				var gap:Number = this._gap;
				if(hasFirstGap && i == 0)
				{
					gap = this._firstGap;
				}
				else if(hasLastGap && i > 0 && i == secondToLastIndex)
				{
					gap = this._lastGap;
				}
				var cachedWidth:Number = this._widthCache[i];
				if(cachedWidth !== cachedWidth) //isNaN
				{
					var itemWidth:Number = calculatedTypicalItemWidth;
				}
				else
				{
					itemWidth = cachedWidth;
				}
				var oldPositionX:Number = positionX;
				positionX += itemWidth + gap;
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
					result.insertAt(0, i);
				}
			}
			resultLength = result.length;
			resultLastIndex = resultLength;
			visibleItemCountDifference = maxVisibleTypicalItemCount - resultLength;
			if(visibleItemCountDifference > 0)
			{
				//add extra items after the last index
				var startIndex:int = resultLength > 0 ? (result[resultLength - 1] + 1) : 0;
				var endIndex:int = startIndex + visibleItemCountDifference;
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
		public function getNearestScrollPositionForIndex(index:int, scrollX:Number, scrollY:Number, items:Vector.<DisplayObject>,
			x:Number, y:Number, width:Number, height:Number, result:Point = null):Point
		{
			var maxScrollX:Number = this.calculateMaxScrollXOfIndex(index, items, x, y, width, height);

			if(this._useVirtualLayout)
			{
				if(this._hasVariableItemDimensions)
				{
					var itemWidth:Number = this._widthCache[index];
					if(itemWidth !== itemWidth)
					{
						itemWidth = this._typicalItem.width;
					}
				}
				else
				{
					itemWidth = this._typicalItem.width;
				}
			}
			else
			{
				itemWidth = items[index].width;
			}

			if(!result)
			{
				result = new Point();
			}

			var rightPosition:Number = maxScrollX - (width - itemWidth);
			if(scrollX >= rightPosition && scrollX <= maxScrollX)
			{
				//keep the current scroll position because the item is already
				//fully visible
				result.x = scrollX;
			}
			else
			{
				var leftDifference:Number = Math.abs(maxScrollX - scrollX);
				var rightDifference:Number = Math.abs(rightPosition - scrollX);
				if(rightDifference < leftDifference)
				{
					result.x = rightPosition;
				}
				else
				{
					result.x = maxScrollX;
				}
			}
			result.y = 0;

			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function getScrollPositionForIndex(index:int, items:Vector.<DisplayObject>, x:Number, y:Number, width:Number, height:Number, result:Point = null):Point
		{
			var maxScrollX:Number = this.calculateMaxScrollXOfIndex(index, items, x, y, width, height);
			if(this._useVirtualLayout)
			{
				if(this._hasVariableItemDimensions)
				{
					var itemWidth:Number = this._widthCache[index];
					if(itemWidth !== itemWidth)
					{
						itemWidth = this._typicalItem.width;
					}
				}
				else
				{
					itemWidth = this._typicalItem.width;
				}
			}
			else
			{
				itemWidth = items[index].width;
			}
			if(this._scrollPositionHorizontalAlign == HorizontalAlign.CENTER)
			{
				maxScrollX -= Math.round((width - itemWidth) / 2);
			}
			else if(this._scrollPositionHorizontalAlign == HorizontalAlign.RIGHT)
			{
				maxScrollX -= (width - itemWidth);
			}
			result.x = maxScrollX;
			result.y = 0;

			return result;
		}

		/**
		 * @private
		 */
		protected function validateItems(items:Vector.<DisplayObject>, explicitHeight:Number,
			minHeight:Number, maxHeight:Number, distributedWidth:Number):void
		{
			//if the alignment is justified, then we want to set the height of
			//each item before validating because setting one dimension may
			//cause the other dimension to change, and that will invalidate the
			//layout if it happens after validation, causing more invalidation
			var isJustified:Boolean = this._verticalAlign == VerticalAlign.JUSTIFY;
			var itemCount:int = items.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:DisplayObject = items[i];
				if(!item || (item is ILayoutDisplayObject && !ILayoutDisplayObject(item).includeInLayout))
				{
					continue;
				}
				if(this._distributeWidths)
				{
					item.width = distributedWidth;
				}
				if(isJustified)
				{
					//the alignment is justified, but we don't yet have a width
					//to use, so we need to ensure that we accurately measure
					//the items instead of using an old justified height that
					//may be wrong now!
					item.height = explicitHeight;
					if(item is IFeathersControl)
					{
						var feathersItem:IFeathersControl = IFeathersControl(item);
						feathersItem.minHeight = minHeight;
						feathersItem.maxHeight = maxHeight;
					}
				}
				else if(item is ILayoutDisplayObject)
				{
					var layoutItem:ILayoutDisplayObject = ILayoutDisplayObject(item);
					var layoutData:HorizontalLayoutData = layoutItem.layoutData as HorizontalLayoutData;
					if(layoutData !== null)
					{
						var percentWidth:Number = layoutData.percentWidth;
						var percentHeight:Number = layoutData.percentHeight;
						if(percentWidth === percentWidth) //!isNaN
						{
							//we need to clear the explicitWidth because some
							//components may change their minWidth based on
							//whether it is set or not, and the minWidth is used
							//with percentWidth calculations
							item.width = NaN;
						}
						if(percentHeight === percentHeight) //!isNaN
						{
							if(percentHeight < 0)
							{
								percentHeight = 0;
							}
							if(percentHeight > 100)
							{
								percentHeight = 100;
							}
							var itemHeight:Number = explicitHeight * percentHeight / 100;
							var measureItem:IMeasureDisplayObject = IMeasureDisplayObject(item);
							//we use the explicitMinHeight to make an accurate
							//measurement, and we'll use the component's
							//measured minHeight later, after we validate it.
							var itemExplicitMinHeight:Number = measureItem.explicitMinHeight;
							//see comment above about doNothing()
							this.doNothing();
							if(itemExplicitMinHeight === itemExplicitMinHeight && //!isNaN
								itemHeight < itemExplicitMinHeight)
							{
								itemHeight = itemExplicitMinHeight;
							}
							item.height = itemHeight;
						}
					}
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
			var hasSetHeight:Boolean = false;
			if(this._verticalAlign == VerticalAlign.JUSTIFY &&
				justifyHeight === justifyHeight) //!isNaN
			{
				hasSetHeight = true;
				this._typicalItem.height = justifyHeight;
			}
			else if(this._typicalItem is ILayoutDisplayObject)
			{
				var layoutItem:ILayoutDisplayObject = ILayoutDisplayObject(this._typicalItem);
				var layoutData:VerticalLayoutData = layoutItem.layoutData as VerticalLayoutData;
				if(layoutData !== null)
				{
					var percentHeight:Number = layoutData.percentHeight;
					if(percentHeight === percentHeight) //!isNaN
					{
						if(percentHeight < 0)
						{
							percentHeight = 0;
						}
						if(percentHeight > 100)
						{
							percentHeight = 100;
						}
						hasSetHeight = true;
						this._typicalItem.height = justifyHeight * percentHeight / 100;
					}
				}
			}
			if(!hasSetHeight && this._resetTypicalItemDimensionsOnMeasure)
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
		protected function calculateDistributedWidth(items:Vector.<DisplayObject>, explicitWidth:Number, minWidth:Number, maxWidth:Number):Number
		{
			var itemCount:int = items.length;
			if(explicitWidth !== explicitWidth) //isNaN
			{
				var maxItemWidth:Number = 0;
				for(var i:int = 0; i < itemCount; i++)
				{
					var item:DisplayObject = items[i];
					var itemWidth:Number = item.width;
					if(itemWidth > maxItemWidth)
					{
						maxItemWidth = itemWidth;
					}
				}
				explicitWidth = maxItemWidth * itemCount + this._paddingLeft + this._paddingRight + this._gap * (itemCount - 1);
				var needsRecalculation:Boolean = false;
				if(explicitWidth > maxWidth)
				{
					explicitWidth = maxWidth;
					needsRecalculation = true;
				}
				else if(explicitWidth < minWidth)
				{
					explicitWidth = minWidth;
					needsRecalculation = true;
				}
				if(!needsRecalculation)
				{
					return maxItemWidth;
				}
			}
			var availableSpace:Number = explicitWidth - this._paddingLeft - this._paddingRight - this._gap * (itemCount - 1);
			if(itemCount > 1 && this._firstGap === this._firstGap) //!isNaN
			{
				availableSpace += this._gap - this._firstGap;
			}
			if(itemCount > 2 && this._lastGap === this._lastGap) //!isNaN
			{
				availableSpace += this._gap - this._lastGap;
			}
			return availableSpace / itemCount;
		}

		/**
		 * @private
		 */
		protected function applyPercentWidths(items:Vector.<DisplayObject>, explicitWidth:Number, minWidth:Number, maxWidth:Number):void
		{
			var remainingWidth:Number = explicitWidth;
			this._discoveredItemsCache.length = 0;
			var totalExplicitWidth:Number = 0;
			var totalMinWidth:Number = 0;
			var totalPercentWidth:Number = 0;
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
					var layoutData:HorizontalLayoutData = layoutItem.layoutData as HorizontalLayoutData;
					if(layoutData)
					{
						var percentWidth:Number = layoutData.percentWidth;
						if(percentWidth === percentWidth) //!isNaN
						{
							if(layoutItem is IFeathersControl)
							{
								var feathersItem:IFeathersControl = IFeathersControl(layoutItem);
								totalMinWidth += feathersItem.minWidth;
							}
							totalPercentWidth += percentWidth;
							this._discoveredItemsCache[pushIndex] = item;
							pushIndex++;
							continue;
						}
					}
				}
				totalExplicitWidth += item.width;
			}
			totalExplicitWidth += this._gap * (itemCount - 1);
			if(this._firstGap === this._firstGap && itemCount > 1)
			{
				totalExplicitWidth += (this._firstGap - this._gap);
			}
			else if(this._lastGap === this._lastGap && itemCount > 2)
			{
				totalExplicitWidth += (this._lastGap - this._gap);
			}
			totalExplicitWidth += this._paddingLeft + this._paddingRight;
			if(totalPercentWidth < 100)
			{
				totalPercentWidth = 100;
			}
			if(remainingWidth !== remainingWidth) //isNaN
			{
				remainingWidth = totalExplicitWidth + totalMinWidth;
				if(remainingWidth < minWidth)
				{
					remainingWidth = minWidth;
				}
				else if(remainingWidth > maxWidth)
				{
					remainingWidth = maxWidth;
				}
			}
			remainingWidth -= totalExplicitWidth;
			if(remainingWidth < 0)
			{
				remainingWidth = 0;
			}
			do
			{
				var needsAnotherPass:Boolean = false;
				var percentToPixels:Number = remainingWidth / totalPercentWidth;
				for(i = 0; i < pushIndex; i++)
				{
					layoutItem = ILayoutDisplayObject(this._discoveredItemsCache[i]);
					if(!layoutItem)
					{
						continue;
					}
					layoutData = HorizontalLayoutData(layoutItem.layoutData);
					percentWidth = layoutData.percentWidth;
					var itemWidth:Number = percentToPixels * percentWidth;
					if(layoutItem is IFeathersControl)
					{
						feathersItem = IFeathersControl(layoutItem);
						var itemMinWidth:Number = feathersItem.minWidth;
						if(itemWidth < itemMinWidth)
						{
							itemWidth = itemMinWidth;
							remainingWidth -= itemWidth;
							totalPercentWidth -= percentWidth;
							this._discoveredItemsCache[i] = null;
							needsAnotherPass = true;
						}
						else
						{
							var itemMaxWidth:Number = feathersItem.maxWidth;
							if(itemWidth > itemMaxWidth)
							{
								itemWidth = itemMaxWidth;
								remainingWidth -= itemWidth;
								totalPercentWidth -= percentWidth;
								this._discoveredItemsCache[i] = null;
								needsAnotherPass = true;
							}
						}
					}
					layoutItem.width = itemWidth;
					if(layoutItem is IValidating)
					{
						//changing the width of the item may cause its height
						//to change, so we need to validate. the height is
						//needed for measurement.
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
		protected function calculateMaxScrollXOfIndex(index:int, items:Vector.<DisplayObject>, x:Number, y:Number, width:Number, height:Number):Number
		{
			if(this._useVirtualLayout)
			{
				this.prepareTypicalItem(height - this._paddingTop - this._paddingBottom);
				var calculatedTypicalItemWidth:Number = this._typicalItem ? this._typicalItem.width : 0;
				var calculatedTypicalItemHeight:Number = this._typicalItem ? this._typicalItem.height : 0;
			}

			var hasFirstGap:Boolean = this._firstGap === this._firstGap; //!isNaN
			var hasLastGap:Boolean = this._lastGap === this._lastGap; //!isNaN
			var positionX:Number = x + this._paddingLeft;
			var lastWidth:Number = 0;
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
					lastWidth = calculatedTypicalItemWidth;
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
					positionX += (endIndexOffset * (calculatedTypicalItemWidth + this._gap));
				}
				positionX += (startIndexOffset * (calculatedTypicalItemWidth + this._gap));
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
					var cachedWidth:Number = this._widthCache[iNormalized];
				}
				if(this._useVirtualLayout && !item)
				{
					if(!this._hasVariableItemDimensions ||
						cachedWidth !== cachedWidth) //isNaN
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
					lastWidth = itemWidth;
				}
				positionX += lastWidth + gap;
			}
			positionX -= (lastWidth + gap);
			return positionX;
		}

		/**
		 * @private
		 * This function is here to work around a bug in the Flex 4.6 SDK
		 * compiler. For explanation, see the places where it gets called.
		 */
		protected function doNothing():void {}
	}
}
