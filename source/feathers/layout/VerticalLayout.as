/*
Feathers
Copyright 2012-2015 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.layout
{
	import feathers.core.IFeathersControl;
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
	 * Positions items from top to bottom in a single column.
	 *
	 * @see ../../../help/vertical-layout.html How to use VerticalLayout with Feathers containers
	 */
	public class VerticalLayout extends EventDispatcher implements IVariableVirtualLayout, ITrimmedVirtualLayout
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
		 * The items will be aligned to the left of the bounds.
		 *
		 * @see #horizontalAlign
		 */
		public static const HORIZONTAL_ALIGN_LEFT:String = "left";

		/**
		 * The items will be aligned to the center of the bounds.
		 *
		 * @see #horizontalAlign
		 */
		public static const HORIZONTAL_ALIGN_CENTER:String = "center";

		/**
		 * The items will be aligned to the right of the bounds.
		 *
		 * @see #horizontalAlign
		 */
		public static const HORIZONTAL_ALIGN_RIGHT:String = "right";

		/**
		 * The items will fill the width of the bounds.
		 *
		 * @see #horizontalAlign
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
		protected var _discoveredItemsCache:Vector.<DisplayObject> = new <DisplayObject>[];

		/**
		 * @private
		 */
		protected var _gap:Number = 0;

		[Bindable(event="change")]
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

		[Bindable(event="change")]
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

		[Bindable(event="change")]
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
		 * The space, in pixels, that appears on top, before the first item.
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
		protected var _paddingBottom:Number = 0;

		[Bindable(event="change")]
		/**
		 * The space, in pixels, that appears on the bottom, after the last
		 * item.
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
		protected var _verticalAlign:String = VERTICAL_ALIGN_TOP;

		[Bindable(event="change")]
		[Inspectable(type="String",enumeration="top,middle,bottom")]
		/**
		 * If the total item height is less than the bounds, the positions of
		 * the items can be aligned vertically.
		 *
		 * @default VerticalLayout.VERTICAL_ALIGN_TOP
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
		protected var _horizontalAlign:String = HORIZONTAL_ALIGN_LEFT;

		[Bindable(event="change")]
		[Inspectable(type="String",enumeration="left,center,right,justify")]
		/**
		 * The alignment of the items horizontally, on the x-axis.
		 *
		 * <p>If the <code>horizontalAlign</code> property is set to
		 * <code>VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY</code>, the
		 * <code>width</code>, <code>minWidth</code>, and <code>maxWidth</code>
		 * properties of the items may be changed, and their original values
		 * ignored by the layout. In this situation, if the width needs to be
		 * constrained, the <code>width</code>, <code>minWidth</code>, or
		 * <code>maxWidth</code> properties should instead be set on the parent
		 * container using the layout.</p>
		 *
		 * @default VerticalLayout.HORIZONTAL_ALIGN_LEFT
		 *
		 * @see #HORIZONTAL_ALIGN_LEFT
		 * @see #HORIZONTAL_ALIGN_CENTER
		 * @see #HORIZONTAL_ALIGN_RIGHT
		 * @see #HORIZONTAL_ALIGN_JUSTIFY
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
		protected var _hasVariableItemDimensions:Boolean = false;

		[Bindable(event="change")]
		/**
		 * When the layout is virtualized, and this value is true, the items may
		 * have variable height values. If false, the items will all share the
		 * same height value with the typical item.
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
		protected var _manageVisibility:Boolean = false;

		[Bindable(event="change")]
		/**
		 * Determines if items will be set invisible if they are outside the
		 * view port. If <code>true</code>, you will not be able to manually
		 * change the <code>visible</code> property of any items in the layout.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 2.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.
		 * Originally, the <code>manageVisibility</code> property could be used
		 * to improve performance of non-virtual layouts by hiding items that
		 * were outside the view port. However, other performance improvements
		 * have made it so that setting <code>manageVisibility</code> can now
		 * sometimes hurt performance instead of improving it.</p>
		 *
		 * @default false
		 */
		public function get manageVisibility():Boolean
		{
			return this._manageVisibility;
		}

		/**
		 * @private
		 */
		public function set manageVisibility(value:Boolean):void
		{
			if(this._manageVisibility == value)
			{
				return;
			}
			this._manageVisibility = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _beforeVirtualizedItemCount:int = 0;

		[Bindable(event="change")]
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

		[Bindable(event="change")]
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

		[Bindable(event="change")]
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

		[Bindable(event="change")]
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

		[Bindable(event="change")]
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

		[Bindable(event="change")]
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
		protected var _scrollPositionVerticalAlign:String = VERTICAL_ALIGN_MIDDLE;

		[Bindable(event="change")]
		[Inspectable(type="String",enumeration="top,middle,bottom")]
		/**
		 * When the scroll position is calculated for an item, an attempt will
		 * be made to align the item to this position.
		 *
		 * @default VerticalLayout.VERTICAL_ALIGN_MIDDLE
		 *
		 * @see #VERTICAL_ALIGN_TOP
		 * @see #VERTICAL_ALIGN_MIDDLE
		 * @see #VERTICAL_ALIGN_BOTTOM
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
		 * @inheritDoc
		 */
		public function get requiresLayoutOnScroll():Boolean
		{
			return this._useVirtualLayout || this._manageVisibility;
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

			if(!this._useVirtualLayout || this._hasVariableItemDimensions || this._distributeHeights ||
				this._horizontalAlign != HORIZONTAL_ALIGN_JUSTIFY ||
				explicitWidth !== explicitWidth) //isNaN
			{
				//in some cases, we may need to validate all of the items so
				//that we can use their dimensions below.
				this.validateItems(items, explicitWidth - this._paddingLeft - this._paddingRight,
					minWidth - this._paddingLeft - this._paddingRight,
					maxWidth - this._paddingLeft - this._paddingRight,
					explicitHeight);
			}

			if(!this._useVirtualLayout)
			{
				//handle the percentHeight property from VerticalLayoutData,
				//if available.
				this.applyPercentHeights(items, explicitHeight, minHeight, maxHeight);
			}

			var distributedHeight:Number;
			if(this._distributeHeights)
			{
				//distribute the height evenly among all items
				distributedHeight = this.calculateDistributedHeight(items, explicitHeight, minHeight, maxHeight);
			}
			var hasDistributedHeight:Boolean = distributedHeight === distributedHeight; //!isNaN

			//this section prepares some variables needed for the following loop
			var hasFirstGap:Boolean = this._firstGap === this._firstGap; //!isNaN
			var hasLastGap:Boolean = this._lastGap === this._lastGap; //!isNaN
			var maxItemWidth:Number = this._useVirtualLayout ? calculatedTypicalItemWidth : 0;
			var positionY:Number = boundsY + this._paddingTop;
			var indexOffset:int = 0;
			var itemCount:int = items.length;
			var totalItemCount:int = itemCount;
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

			//this first loop sets the y position of items, and it calculates
			//the total height of all items
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:DisplayObject = items[i];
				//if we're trimming some items at the beginning, we need to
				//adjust i to account for the missing items in the array
				var iNormalized:int = i + indexOffset;

				//pick the gap that will follow this item. the first and second
				//to last items may have different gaps.
				var gap:Number = this._gap;
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
					var cachedHeight:Number = this._heightCache[iNormalized];
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
					if(item is ILayoutDisplayObject && !ILayoutDisplayObject(item).includeInLayout)
					{
						continue;
					}
					item.y = item.pivotY + positionY;
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
								this._heightCache[iNormalized] = itemHeight;

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
							item.height = itemHeight = calculatedTypicalItemHeight;
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
			var totalHeight:Number = positionY - this._gap + this._paddingBottom - boundsY;
			//the available height is the height of the viewport. if the explicit
			//height is NaN, we need to calculate the viewport height ourselves
			//based on the total height of all items.
			var availableHeight:Number = explicitHeight;
			if(availableHeight !== availableHeight) //isNaN
			{
				availableHeight = totalHeight;
				if(this._requestedRowCount > 0)
				{
					availableHeight = this._requestedRowCount * (calculatedTypicalItemHeight + this._gap) - this._gap + this._paddingTop + this._paddingBottom;
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

			//in this section, we handle vertical alignment. items will be
			//aligned vertically if the total height of all items is less than
			//the available height of the view port.
			if(totalHeight < availableHeight)
			{
				var verticalAlignOffsetY:Number = 0;
				if(this._verticalAlign == VERTICAL_ALIGN_BOTTOM)
				{
					verticalAlignOffsetY = availableHeight - totalHeight;
				}
				else if(this._verticalAlign == VERTICAL_ALIGN_MIDDLE)
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

			for(i = 0; i < discoveredItemCount; i++)
			{
				item = discoveredItems[i];
				var layoutItem:ILayoutDisplayObject = item as ILayoutDisplayObject;
				if(layoutItem && !layoutItem.includeInLayout)
				{
					continue;
				}

				//in this section, we handle horizontal alignment and percent
				//width from VerticalLayoutData
				if(this._horizontalAlign == HORIZONTAL_ALIGN_JUSTIFY)
				{
					//if we justify items horizontally, we can skip percent width
					item.x = item.pivotX + boundsX + this._paddingLeft;
					item.width = availableWidth - this._paddingLeft - this._paddingRight;
				}
				else
				{
					if(layoutItem)
					{
						var layoutData:VerticalLayoutData = layoutItem.layoutData as VerticalLayoutData;
						if(layoutData)
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
								itemWidth = percentWidth * (availableWidth - this._paddingLeft - this._paddingRight) / 100;
								if(item is IFeathersControl)
								{
									var feathersItem:IFeathersControl = IFeathersControl(item);
									var itemMinWidth:Number = feathersItem.minWidth;
									if(itemWidth < itemMinWidth)
									{
										itemWidth = itemMinWidth;
									}
									else
									{
										var itemMaxWidth:Number = feathersItem.maxWidth;
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
						case HORIZONTAL_ALIGN_RIGHT:
						{
							item.x = item.pivotX + boundsX + horizontalAlignWidth - this._paddingRight - item.width;
							break;
						}
						case HORIZONTAL_ALIGN_CENTER:
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

				if(this._manageVisibility)
				{
					item.visible = ((item.y - item.pivotY + item.height) >= (boundsY + scrollY)) && ((item.y - item.pivotY) < (scrollY + availableHeight));
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
			result.contentWidth = this._horizontalAlign == HORIZONTAL_ALIGN_JUSTIFY ? availableWidth : totalWidth;
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
						var cachedHeight:Number = this._heightCache[i];
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
				this.dispatchEventWith(Event.CHANGE);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function addToVariableVirtualCacheAtIndex(index:int, item:DisplayObject = null):void
		{
			var heightValue:* = item ? item.height : undefined;
			this._heightCache.splice(index, 0, heightValue);
		}

		/**
		 * @inheritDoc
		 */
		public function removeFromVariableVirtualCacheAtIndex(index:int):void
		{
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
					if(this._verticalAlign == VERTICAL_ALIGN_BOTTOM)
					{
						indexOffset = Math.ceil((height - totalItemHeight) / (calculatedTypicalItemHeight + this._gap));
					}
					else if(this._verticalAlign == VERTICAL_ALIGN_MIDDLE)
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
			var secondToLastIndex:int = itemCount - 2;
			var maxPositionY:Number = scrollY + height;
			var positionY:Number = this._paddingTop;
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
				var cachedHeight:Number = this._heightCache[i];
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
					result.unshift(i);
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
			var maxScrollY:Number = this.calculateMaxScrollYOfIndex(index, items, x, y, width, height);

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

			var bottomPosition:Number = maxScrollY - (height - itemHeight);
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
			var maxScrollY:Number = this.calculateMaxScrollYOfIndex(index, items, x, y, width, height);

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

			if(this._scrollPositionVerticalAlign == VERTICAL_ALIGN_MIDDLE)
			{
				maxScrollY -= Math.round((height - itemHeight) / 2);
			}
			else if(this._scrollPositionVerticalAlign == VERTICAL_ALIGN_BOTTOM)
			{
				maxScrollY -= (height - itemHeight);
			}
			result.y = maxScrollY;

			return result;
		}

		/**
		 * @private
		 */
		protected function validateItems(items:Vector.<DisplayObject>, explicitWidth:Number,
			minWidth:Number, maxWidth:Number, distributedHeight:Number):void
		{
			//if the alignment is justified, then we want to set the width of
			//each item before validating because setting one dimension may
			//cause the other dimension to change, and that will invalidate the
			//layout if it happens after validation, causing more invalidation
			var isJustified:Boolean = this._horizontalAlign == HORIZONTAL_ALIGN_JUSTIFY;
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
				if(this._distributeHeights)
				{
					item.height = distributedHeight;
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
			if(this._horizontalAlign == HORIZONTAL_ALIGN_JUSTIFY &&
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

		/**
		 * @private
		 */
		protected function calculateDistributedHeight(items:Vector.<DisplayObject>, explicitHeight:Number, minHeight:Number, maxHeight:Number):Number
		{
			var itemCount:int = items.length;
			if(explicitHeight !== explicitHeight) //isNaN
			{
				var maxItemHeight:Number = 0;
				for(var i:int = 0; i < itemCount; i++)
				{
					var item:DisplayObject = items[i];
					var itemHeight:Number = item.height;
					if(itemHeight > maxItemHeight)
					{
						maxItemHeight = itemHeight;
					}
				}
				explicitHeight = maxItemHeight * itemCount + this._paddingTop + this._paddingBottom + this._gap * (itemCount - 1);
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
			var availableSpace:Number = explicitHeight - this._paddingTop - this._paddingBottom - this._gap * (itemCount - 1);
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
							if(layoutItem is IFeathersControl)
							{
								var feathersItem:IFeathersControl = IFeathersControl(layoutItem);
								totalMinHeight += feathersItem.minHeight;
							}
							totalPercentHeight += percentHeight;
							this._discoveredItemsCache[pushIndex] = item;
							pushIndex++;
							continue;
						}
					}
				}
				totalExplicitHeight += item.height;
			}
			totalExplicitHeight += this._gap * (itemCount - 1);
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
					var itemHeight:Number = percentToPixels * percentHeight;
					if(layoutItem is IFeathersControl)
					{
						feathersItem = IFeathersControl(layoutItem);
						var itemMinHeight:Number = feathersItem.minHeight;
						if(itemHeight < itemMinHeight)
						{
							itemHeight = itemMinHeight;
							remainingHeight -= itemHeight;
							totalPercentHeight -= percentHeight;
							this._discoveredItemsCache[i] = null;
							needsAnotherPass = true;
						}
						else
						{
							var itemMaxHeight:Number = feathersItem.maxHeight;
							if(itemHeight > itemMaxHeight)
							{
								itemHeight = itemMaxHeight;
								remainingHeight -= itemHeight;
								totalPercentHeight -= percentHeight;
								this._discoveredItemsCache[i] = null;
								needsAnotherPass = true;
							}
						}
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
		protected function calculateMaxScrollYOfIndex(index:int, items:Vector.<DisplayObject>, x:Number, y:Number, width:Number, height:Number):Number
		{
			if(this._useVirtualLayout)
			{
				this.prepareTypicalItem(width - this._paddingLeft - this._paddingRight);
				var calculatedTypicalItemWidth:Number = this._typicalItem ? this._typicalItem.width : 0;
				var calculatedTypicalItemHeight:Number = this._typicalItem ? this._typicalItem.height : 0;
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
					var cachedHeight:Number = this._heightCache[iNormalized];
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
								this._heightCache[iNormalized] = itemHeight;
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
			}
			positionY -= (lastHeight + gap);
			return positionY;
		}
	}
}
