/*
Feathers
Copyright 2012-2018 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.layout
{
	import starling.display.DisplayObject;
	import starling.errors.AbstractClassError;
	import starling.events.Event;

	/**
	 * Abstract base class for <code>HorizontalLayout</code> and <code>VerticalLayout</code>.
	 *
	 * @productversion Feathers 3.3.0
	 *
	 * @see feathers.layout.HorizontalLayout
	 * @see feathers.layout.VerticalLayout
	 */
	public class BaseLinearLayout extends BaseVariableVirtualLayout
	{
		/**
		 * Constructor.
		 */
		public function BaseLinearLayout()
		{
			super();
			if(Object(this).constructor == BaseLinearLayout)
			{
				throw new AbstractClassError()
			}
		}

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
		 * The space, in pixels, that appears on top.
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
		 * The space, in pixels, that appears on the bottom.
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
		protected var _verticalAlign:String = VerticalAlign.TOP;

		[Bindable(event="change")]
		/**
		 * The alignment of the items vertically, on the x-axis.
		 *
		 * @default feathers.layout.VerticalAlign.TOP
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

		[Bindable(event="change")]
		/**
		 * The alignment of the items horizontally, on the x-axis.
		 *
		 * @default feathers.layout.HorizontalAlign.LEFT
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
		protected var _beforeVirtualizedItemCount:int = 0;

		[Bindable(event="change")]
		/**
		 * @copy feathers.layout.ITrimmedLayout#beforeVirtualizedItemCount
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
		 * @copy feathers.layout.ITrimmedLayout#afterVirtualizedItemCount
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
	}
}
