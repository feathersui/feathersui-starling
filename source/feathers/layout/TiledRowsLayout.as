/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

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
	 * Positions items as tiles (equal width and height) from left to right
	 * in multiple rows. Constrained to the suggested width, the tiled rows
	 * layout will change in height as the number of items increases or
	 * decreases.
	 *
	 * @see ../../../help/tiled-rows-layout.html How to use TiledRowsLayout with Feathers containers
	 */
	public class TiledRowsLayout extends EventDispatcher implements IVirtualLayout
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
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.VerticalAlign.TOP</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const TILE_VERTICAL_ALIGN_TOP:String = "top";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.VerticalAlign.MIDDLE</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const TILE_VERTICAL_ALIGN_MIDDLE:String = "middle";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.VerticalAlign.BOTTOM</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const TILE_VERTICAL_ALIGN_BOTTOM:String = "bottom";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.VerticalAlign.JUSTIFY</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const TILE_VERTICAL_ALIGN_JUSTIFY:String = "justify";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.HorizontalAlign.LEFT</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const TILE_HORIZONTAL_ALIGN_LEFT:String = "left";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.HorizontalAlign.CENTER</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const TILE_HORIZONTAL_ALIGN_CENTER:String = "center";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.HorizontalAlign.RIGHT</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const TILE_HORIZONTAL_ALIGN_RIGHT:String = "right";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.HorizontalAlign.JUSTIFY</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
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
		 * in a continuous set of rows without gaps.
		 *
		 * @see #paging
		 */
		public static const PAGING_NONE:String = "none";

		/**
		 * Constructor.
		 */
		public function TiledRowsLayout()
		{
		}

		/**
		 * @private
		 */
		protected var _discoveredItemsCache:Vector.<DisplayObject> = new <DisplayObject>[];

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
		protected var _requestedColumnCount:int = 0;

		/**
		 * Requests that the layout uses a specific number of columns in a row,
		 * if possible. Set to <code>0</code> to calculate the maximum of
		 * columns that will fit in the available space.
		 *
		 * <p>If the view port's explicit or maximum width is not large enough
		 * to fit the requested number of columns, it will use fewer. If the
		 * view port doesn't have an explicit width and the maximum width is
		 * equal to <code>Number.POSITIVE_INFINITY</code>, the width will be
		 * calculated automatically to fit the exact number of requested
		 * columns.</p>
		 *
		 * <p>If paging is enabled, this value will be used to calculate the
		 * number of columns in a page. If paging isn't enabled, this value will
		 * be used to calculate a minimum number of columns, even if there
		 * aren't enough items to fill each column.</p>
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
		protected var _requestedRowCount:int = 0;

		/**
		 * Requests that the layout uses a specific number of rows, if possible.
		 * If the view port's explicit or maximum height is not large enough to
		 * fit the requested number of rows, it will use fewer. Set to <code>0</code>
		 * to calculate the number of rows automatically based on width and
		 * height.
		 *
		 * <p>If paging is enabled, this value will be used to calculate the
		 * number of rows in a page. If paging isn't enabled, this value will
		 * be used to calculate a minimum number of rows, even if there aren't
		 * enough items to fill each row.</p>
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
		protected var _verticalAlign:String = VerticalAlign.TOP;

		[Inspectable(type="String",enumeration="top,middle,bottom")]
		/**
		 * If the total column height is less than the bounds, the items in the
		 * column can be aligned vertically.
		 *
		 * @default feathers.layout.VerticalAlign.TOP
		 *
		 * @see feathers.layout.VerticalAlign#TOP
		 * @see feathers.layout.VerticalAlign#MIDDLE
		 * @see feathers.layout.VerticalAlign#BOTTOM
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
		protected var _horizontalAlign:String = HorizontalAlign.CENTER;

		[Inspectable(type="String",enumeration="left,center,right")]
		/**
		 * If the total row width is less than the bounds, the items in the row
		 * can be aligned horizontally.
		 *
		 * @default feathers.layout.HorizontalAlign.CENTER
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
		protected var _tileVerticalAlign:String = VerticalAlign.MIDDLE;

		[Inspectable(type="String",enumeration="top,middle,bottom,justify")]
		/**
		 * If an item's height is less than the tile bounds, the position of the
		 * item can be aligned vertically.
		 *
		 * @default feathers.layout.VerticalAlign.MIDDLE
		 *
		 * @see feathers.layout.VerticalAlign#TOP
		 * @see feathers.layout.VerticalAlign#MIDDLE
		 * @see feathers.layout.VerticalAlign#BOTTOM
		 * @see feathers.layout.VerticalAlign#JUSTIFY
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
		protected var _tileHorizontalAlign:String = HorizontalAlign.CENTER;

		[Inspectable(type="String",enumeration="left,center,right,justify")]
		/**
		 * If the item's width is less than the tile bounds, the position of the
		 * item can be aligned horizontally.
		 *
		 * @default feathers.layout.HorizontalAlign.CENTER
		 *
		 * @see feathers.layout.HorizontalAlign#LEFT
		 * @see feathers.layout.HorizontalAlign#CENTER
		 * @see feathers.layout.HorizontalAlign#RIGHT
		 * @see feathers.layout.HorizontalAlign#JUSTIFY
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
		 * If the total combined height of the rows is larger than the height
		 * of the view port, the layout will be split into pages where each
		 * page is filled with the maximum number of rows that may be displayed
		 * without cutting off any items.
		 *
		 * @default TiledRowsLayout.PAGING_NONE
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
			if(!result)
			{
				result = new LayoutBoundsResult();
			}
			if(items.length === 0)
			{
				result.contentX = 0;
				result.contentY = 0;
				result.contentWidth = this._paddingLeft + this._paddingRight;
				result.contentHeight = this._paddingTop + this._paddingBottom;
				result.viewPortWidth = result.contentWidth;
				result.viewPortHeight = result.contentHeight;
				return result;
			}

			var scrollX:Number = viewPortBounds ? viewPortBounds.scrollX : 0;
			var scrollY:Number = viewPortBounds? viewPortBounds.scrollY : 0;
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
				this.prepareTypicalItem();
				var calculatedTypicalItemWidth:Number = this._typicalItem ? this._typicalItem.width : 0;
				var calculatedTypicalItemHeight:Number = this._typicalItem ? this._typicalItem.height : 0;
			}

			this.validateItems(items);

			this._discoveredItemsCache.length = 0;
			var itemCount:int = items.length;
			var tileWidth:Number = this._useVirtualLayout ? calculatedTypicalItemWidth : 0;
			var tileHeight:Number = this._useVirtualLayout ? calculatedTypicalItemHeight : 0;
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
			
			var horizontalTileCount:int = this.calculateHorizontalTileCount(tileWidth,
				explicitWidth, maxWidth, this._paddingLeft + this._paddingRight,
				this._horizontalGap, this._requestedColumnCount, itemCount);
			var verticalTileCount:int = this.calculateVerticalTileCount(tileHeight,
				explicitHeight, maxHeight, this._paddingTop + this._paddingBottom,
				this._verticalGap, this._requestedRowCount, itemCount, horizontalTileCount);
			if(explicitWidth === explicitWidth) //!isNaN
			{
				var availableWidth:Number = explicitWidth;
			}
			else
			{
				availableWidth = this._paddingLeft + this._paddingRight + ((tileWidth + this._horizontalGap) * horizontalTileCount) - this._horizontalGap;
				if(availableWidth < minWidth)
				{
					availableWidth = minWidth;
				}
				else if(availableWidth > maxWidth)
				{
					availableWidth = maxWidth;
				}
			}
			if(explicitHeight === explicitHeight) //!isNaN
			{
				var availableHeight:Number = explicitHeight;
			}
			else
			{
				availableHeight = this._paddingTop + this._paddingBottom + ((tileHeight + this._verticalGap) * verticalTileCount) - this._verticalGap;
				if(availableHeight < minHeight)
				{
					availableHeight = minHeight;
				}
				else if(availableHeight > maxHeight)
				{
					availableHeight = maxHeight;
				}
			}

			var totalPageContentWidth:Number = horizontalTileCount * (tileWidth + this._horizontalGap) - this._horizontalGap + this._paddingLeft + this._paddingRight;
			var totalPageContentHeight:Number = verticalTileCount * (tileHeight + this._verticalGap) - this._verticalGap + this._paddingTop + this._paddingBottom;
			
			var startX:Number = boundsX + this._paddingLeft;
			var startY:Number = boundsY + this._paddingTop;

			var perPage:int = horizontalTileCount * verticalTileCount;
			var pageIndex:int = 0;
			var nextPageStartIndex:int = perPage;
			var pageStartX:Number = startX;
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
				if(itemIndex != 0 && itemIndex % horizontalTileCount == 0)
				{
					positionX = pageStartX;
					positionY += tileHeight + this._verticalGap;
				}
				if(itemIndex == nextPageStartIndex)
				{
					//we're starting a new page, so handle alignment of the
					//items on the current page and update the positions
					if(this._paging !== PAGING_NONE)
					{
						var discoveredItems:Vector.<DisplayObject> = this._useVirtualLayout ? this._discoveredItemsCache : items;
						var discoveredItemsFirstIndex:int = this._useVirtualLayout ? 0 : (itemIndex - perPage);
						var discoveredItemsLastIndex:int = this._useVirtualLayout ? (this._discoveredItemsCache.length - 1) : (itemIndex - 1);
						this.applyHorizontalAlign(discoveredItems, discoveredItemsFirstIndex, discoveredItemsLastIndex, totalPageContentWidth, availableWidth);
						this.applyVerticalAlign(discoveredItems, discoveredItemsFirstIndex, discoveredItemsLastIndex, totalPageContentHeight, availableHeight);
						this._discoveredItemsCache.length = 0;
						discoveredItemsCachePushIndex = 0;
					}
					pageIndex++;
					nextPageStartIndex += perPage;

					//we can use availableWidth and availableHeight here without
					//checking if they're NaN because we will never reach a
					//new page without them already being calculated.
					if(this._paging === PAGING_HORIZONTAL)
					{
						positionX = pageStartX = startX + availableWidth * pageIndex;
						positionY = startY;
					}
					else if(this._paging === PAGING_VERTICAL)
					{
						positionY = startY + availableHeight * pageIndex;
					}
				}
				if(item)
				{
					switch(this._tileHorizontalAlign)
					{
						case HorizontalAlign.JUSTIFY:
						{
							item.x = item.pivotX + positionX;
							item.width = tileWidth;
							break;
						}
						case HorizontalAlign.LEFT:
						{
							item.x = item.pivotX + positionX;
							break;
						}
						case HorizontalAlign.RIGHT:
						{
							item.x = item.pivotX + positionX + tileWidth - item.width;
							break;
						}
						default: //center or unknown
						{
							item.x = item.pivotX + positionX + Math.round((tileWidth - item.width) / 2);
						}
					}
					switch(this._tileVerticalAlign)
					{
						case VerticalAlign.JUSTIFY:
						{
							item.y = item.pivotY + positionY;
							item.height = tileHeight;
							break;
						}
						case VerticalAlign.TOP:
						{
							item.y = item.pivotY + positionY;
							break;
						}
						case VerticalAlign.BOTTOM:
						{
							item.y = item.pivotY + positionY + tileHeight - item.height;
							break;
						}
						default: //middle or unknown
						{
							item.y = item.pivotY + positionY + Math.round((tileHeight - item.height) / 2);
						}
					}
					if(this._useVirtualLayout)
					{
						this._discoveredItemsCache[discoveredItemsCachePushIndex] = item;
						discoveredItemsCachePushIndex++;
					}
				}
				positionX += tileWidth + this._horizontalGap;
				itemIndex++;
			}
			//align the last page
			if(this._paging !== PAGING_NONE)
			{
				discoveredItems = this._useVirtualLayout ? this._discoveredItemsCache : items;
				discoveredItemsFirstIndex = this._useVirtualLayout ? 0 : (nextPageStartIndex - perPage);
				discoveredItemsLastIndex = this._useVirtualLayout ? (discoveredItems.length - 1) : (i - 1);
				this.applyHorizontalAlign(discoveredItems, discoveredItemsFirstIndex, discoveredItemsLastIndex, totalPageContentWidth, availableWidth);
				this.applyVerticalAlign(discoveredItems, discoveredItemsFirstIndex, discoveredItemsLastIndex, totalPageContentHeight, availableHeight);
			}

			if(this._paging === PAGING_HORIZONTAL)
			{
				var totalWidth:Number = Math.ceil(itemCount / perPage) * availableWidth;
			}
			else //vertical or none
			{
				totalWidth = totalPageContentWidth;
			}
			if(this._paging === PAGING_HORIZONTAL)
			{
				var totalHeight:Number = availableHeight;
			}
			else if(this._paging === PAGING_VERTICAL)
			{
				totalHeight = Math.ceil(itemCount / perPage) * availableHeight;
			}
			else //none
			{
				totalHeight = positionY + tileHeight + this._paddingBottom;
				if(totalHeight < totalPageContentHeight)
				{
					totalHeight = totalPageContentHeight;
				}
			}

			if(this._paging === PAGING_NONE)
			{
				discoveredItems = this._useVirtualLayout ? this._discoveredItemsCache : items;
				discoveredItemsLastIndex = discoveredItems.length - 1;
				this.applyHorizontalAlign(discoveredItems, 0, discoveredItemsLastIndex, totalWidth, availableWidth);
				this.applyVerticalAlign(discoveredItems, 0, discoveredItemsLastIndex, totalHeight, availableHeight);
			}
			this._discoveredItemsCache.length = 0;

			result.contentX = 0;
			result.contentY = 0;
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
			if(!this._useVirtualLayout)
			{
				throw new IllegalOperationError("measureViewPort() may be called only if useVirtualLayout is true.")
			}

			var explicitWidth:Number = viewPortBounds ? viewPortBounds.explicitWidth : NaN;
			var explicitHeight:Number = viewPortBounds ? viewPortBounds.explicitHeight : NaN;
			var needsWidth:Boolean = explicitWidth !== explicitWidth; //isNaN;
			var needsHeight:Boolean = explicitHeight !== explicitHeight; //isNaN
			if(!needsWidth && !needsHeight)
			{
				result.x = explicitWidth;
				result.y = explicitHeight;
				return result;
			}
			var boundsX:Number = viewPortBounds ? viewPortBounds.x : 0;
			var boundsY:Number = viewPortBounds ? viewPortBounds.y : 0;
			var minWidth:Number = viewPortBounds ? viewPortBounds.minWidth : 0;
			var minHeight:Number = viewPortBounds ? viewPortBounds.minHeight : 0;
			var maxWidth:Number = viewPortBounds ? viewPortBounds.maxWidth : Number.POSITIVE_INFINITY;
			var maxHeight:Number = viewPortBounds ? viewPortBounds.maxHeight : Number.POSITIVE_INFINITY;

			this.prepareTypicalItem();
			var calculatedTypicalItemWidth:Number = this._typicalItem ? this._typicalItem.width : 0;
			var calculatedTypicalItemHeight:Number = this._typicalItem ? this._typicalItem.height : 0;

			var tileWidth:Number = calculatedTypicalItemWidth;
			var tileHeight:Number = calculatedTypicalItemHeight;
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

			var horizontalTileCount:int = this.calculateHorizontalTileCount(tileWidth,
				explicitWidth, maxWidth, this._paddingLeft + this._paddingRight,
				this._horizontalGap, this._requestedColumnCount, itemCount);
			var verticalTileCount:int = this.calculateVerticalTileCount(tileHeight,
				explicitHeight, maxHeight, this._paddingTop + this._paddingBottom,
				this._verticalGap, this._requestedRowCount, itemCount, horizontalTileCount);
			if(explicitWidth === explicitWidth)
			{
				var availableWidth:Number = explicitWidth;
			}
			else
			{
				availableWidth = this._paddingLeft + this._paddingRight + ((tileWidth + this._horizontalGap) * horizontalTileCount) - this._horizontalGap;
				if(availableWidth < minWidth)
				{
					availableWidth = minWidth;
				}
				else if(availableWidth > maxWidth)
				{
					availableWidth = maxWidth;
				}
			}
			if(explicitHeight === explicitHeight) //!isNaN
			{
				var availableHeight:Number = explicitHeight;
			}
			else
			{
				availableHeight = this._paddingTop + this._paddingBottom + ((tileHeight + this._verticalGap) * verticalTileCount) - this._verticalGap;
				if(availableHeight < minHeight)
				{
					availableHeight = minHeight;
				}
				else if(availableHeight > maxHeight)
				{
					availableHeight = maxHeight;
				}
			}

			var totalPageContentWidth:Number = horizontalTileCount * (tileWidth + this._horizontalGap) - this._horizontalGap + this._paddingLeft + this._paddingRight;
			var totalPageContentHeight:Number = verticalTileCount * (tileHeight + this._verticalGap) - this._verticalGap + this._paddingTop + this._paddingBottom;

			var startX:Number = boundsX + this._paddingLeft;
			var startY:Number = boundsY + this._paddingTop;

			var perPage:int = horizontalTileCount * verticalTileCount;
			var pageIndex:int = 0;
			var nextPageStartIndex:int = perPage;
			var pageStartX:Number = startX;
			var positionX:Number = startX;
			var positionY:Number = startY;
			for(var i:int = 0; i < itemCount; i++)
			{
				if(i != 0 && i % horizontalTileCount == 0)
				{
					positionX = pageStartX;
					positionY += tileHeight + this._verticalGap;
				}
				if(i == nextPageStartIndex)
				{
					pageIndex++;
					nextPageStartIndex += perPage;

					//we can use availableWidth and availableHeight here without
					//checking if they're NaN because we will never reach a
					//new page without them already being calculated.
					if(this._paging === PAGING_HORIZONTAL)
					{
						positionX = pageStartX = startX + availableWidth * pageIndex;
						positionY = startY;
					}
					else if(this._paging === PAGING_VERTICAL)
					{
						positionY = startY + availableHeight * pageIndex;
					}
				}
			}

			if(this._paging === PAGING_HORIZONTAL)
			{
				var totalWidth:Number = Math.ceil(itemCount / perPage) * availableWidth;
			}
			else
			{
				totalWidth = totalPageContentWidth;
			}
			if(this._paging === PAGING_HORIZONTAL)
			{
				var totalHeight:Number = availableHeight;
			}
			else if(this._paging === PAGING_VERTICAL)
			{
				totalHeight = Math.ceil(itemCount / perPage) * availableHeight;
			}
			else
			{
				totalHeight = positionY + tileHeight + this._paddingBottom;
				if(totalHeight < totalPageContentHeight)
				{
					totalHeight = totalPageContentHeight;
				}
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

			if(this._paging === PAGING_HORIZONTAL)
			{
				this.getVisibleIndicesAtScrollPositionWithHorizontalPaging(scrollX, scrollY, width, height, itemCount, result);
			}
			else if(this._paging === PAGING_VERTICAL)
			{
				this.getVisibleIndicesAtScrollPositionWithVerticalPaging(scrollX, scrollY, width, height, itemCount, result);
			}
			else //none
			{
				this.getVisibleIndicesAtScrollPositionWithoutPaging(scrollX, scrollY, width, height, itemCount, result);
			}

			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function getNearestScrollPositionForIndex(index:int, scrollX:Number, scrollY:Number, items:Vector.<DisplayObject>,
			x:Number, y:Number, width:Number, height:Number, result:Point = null):Point
		{
			return this.calculateScrollPositionForIndex(index, items, x, y, width, height, result, true, scrollX, scrollY);
		}

		/**
		 * @inheritDoc
		 */
		public function getScrollPositionForIndex(index:int, items:Vector.<DisplayObject>, x:Number, y:Number, width:Number, height:Number, result:Point = null):Point
		{
			return this.calculateScrollPositionForIndex(index, items, x, y, width, height, result, false);
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
			if(this._horizontalAlign === HorizontalAlign.RIGHT)
			{
				horizontalAlignOffsetX = availableWidth - totalItemWidth;
			}
			else if(this._horizontalAlign !== HorizontalAlign.LEFT)
			{
				//we're going to default to center if we encounter an
				//unknown value
				horizontalAlignOffsetX = Math.round((availableWidth - totalItemWidth) / 2);
			}
			if(horizontalAlignOffsetX !== 0)
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
			if(this._verticalAlign === VerticalAlign.BOTTOM)
			{
				verticalAlignOffsetY = availableHeight - totalItemHeight;
			}
			else if(this._verticalAlign === VerticalAlign.MIDDLE)
			{
				verticalAlignOffsetY = Math.round((availableHeight - totalItemHeight) / 2);
			}
			if(verticalAlignOffsetY !== 0)
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
		protected function getVisibleIndicesAtScrollPositionWithHorizontalPaging(scrollX:Number, scrollY:Number, width:Number, height:Number, itemCount:int, result:Vector.<int>):void
		{
			this.prepareTypicalItem();
			var calculatedTypicalItemWidth:Number = this._typicalItem ? this._typicalItem.width : 0;
			var calculatedTypicalItemHeight:Number = this._typicalItem ? this._typicalItem.height : 0;

			var tileWidth:Number = calculatedTypicalItemWidth;
			var tileHeight:Number = calculatedTypicalItemHeight;
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
			var horizontalTileCount:int = this.calculateHorizontalTileCount(tileWidth,
				width, width, this._paddingLeft + this._paddingRight,
				this._horizontalGap, this._requestedColumnCount, itemCount);
			var verticalTileCount:int = this.calculateVerticalTileCount(tileHeight, 
				height, height, this._paddingTop + this._paddingBottom, 
				this._verticalGap, this._requestedRowCount, itemCount, horizontalTileCount);
			var perPage:int = horizontalTileCount * verticalTileCount;
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
				if(this._horizontalAlign === HorizontalAlign.RIGHT)
				{
					leftSideOffset = width - this._paddingLeft - this._paddingRight - totalRowWidth;
					rightSideOffset = 0;
				}
				else if(this._horizontalAlign === HorizontalAlign.CENTER)
				{
					leftSideOffset = rightSideOffset = Math.round((width - this._paddingLeft - this._paddingRight - totalRowWidth) / 2);
				}
				else //left
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
				minimum += -perPage + horizontalTileCount + columnOffset;
			}
			else if(partialPageSize > 0)
			{
				partialPageSize = partialPageSize - this._paddingLeft - leftSideOffset;
				if(partialPageSize < 0)
				{
					partialPageSize = 0;
				}
				columnOffset = Math.floor(partialPageSize / (tileWidth + this._horizontalGap));
				minimum += columnOffset;
			}
			if(minimum < 0)
			{
				minimum = 0;
				columnOffset = 0;
			}
			if(minimum + minimumItemCount >= itemCount)
			{
				var resultPushIndex:int = result.length;
				//an optimized path when we're on or near the last page
				minimum = itemCount - minimumItemCount;
				for(var i:int = minimum; i < itemCount; i++)
				{
					result[resultPushIndex] = i;
					resultPushIndex++;
				}
			}
			else
			{
				var rowIndex:int = 0;
				var columnIndex:int = (horizontalTileCount + columnOffset) % horizontalTileCount;
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
					rowIndex++;
					if(rowIndex == verticalTileCount)
					{
						rowIndex = 0;
						columnIndex++;
						if(columnIndex == horizontalTileCount)
						{
							columnIndex = 0;
							pageStart += perPage;
						}
						i = pageStart + columnIndex - horizontalTileCount;
					}
					i += horizontalTileCount;
				}
				while(resultLength < minimumItemCount && pageStart < itemCount)
			}
		}

		/**
		 * @private
		 */
		protected function getVisibleIndicesAtScrollPositionWithVerticalPaging(scrollX:Number, scrollY:Number, width:Number, height:Number, itemCount:int, result:Vector.<int>):void
		{
			this.prepareTypicalItem();
			var calculatedTypicalItemWidth:Number = this._typicalItem ? this._typicalItem.width : 0;
			var calculatedTypicalItemHeight:Number = this._typicalItem ? this._typicalItem.height : 0;

			var tileWidth:Number = calculatedTypicalItemWidth;
			var tileHeight:Number = calculatedTypicalItemHeight;
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
			var horizontalTileCount:int = this.calculateHorizontalTileCount(tileWidth,
				width, width, this._paddingLeft + this._paddingRight,
				this._horizontalGap, this._requestedColumnCount, itemCount);
			var verticalTileCount:int = this.calculateVerticalTileCount(tileHeight,
				height, height, this._paddingTop + this._paddingBottom,
				this._verticalGap, this._requestedRowCount, itemCount, horizontalTileCount);
			var perPage:int = horizontalTileCount * verticalTileCount;
			var minimumItemCount:int = perPage + 2 * horizontalTileCount;
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
				if(this._verticalAlign === VerticalAlign.BOTTOM)
				{
					topSideOffset = height - this._paddingTop - this._paddingBottom - totalColumnHeight;
					bottomSideOffset = 0;
				}
				else if(this._verticalAlign === VerticalAlign.MIDDLE)
				{
					topSideOffset = bottomSideOffset = Math.round((height - this._paddingTop - this._paddingBottom - totalColumnHeight) / 2);
				}
				else //top
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
				rowOffset = -Math.floor(partialPageSize / (tileHeight + this._verticalGap)) - 1;
				minimum += horizontalTileCount * rowOffset;
			}
			else if(partialPageSize > 0)
			{
				partialPageSize = partialPageSize - this._paddingTop - topSideOffset;
				if(partialPageSize < 0)
				{
					partialPageSize = 0;
				}
				rowOffset = Math.floor(partialPageSize / (tileHeight + this._verticalGap));
				minimum += horizontalTileCount * rowOffset;
			}
			if(minimum < 0)
			{
				minimum = 0;
				rowOffset = 0;
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
		protected function getVisibleIndicesAtScrollPositionWithoutPaging(scrollX:Number, scrollY:Number, width:Number, height:Number, itemCount:int, result:Vector.<int>):void
		{
			this.prepareTypicalItem();
			var calculatedTypicalItemWidth:Number = this._typicalItem ? this._typicalItem.width : 0;
			var calculatedTypicalItemHeight:Number = this._typicalItem ? this._typicalItem.height : 0;

			var tileWidth:Number = calculatedTypicalItemWidth;
			var tileHeight:Number = calculatedTypicalItemHeight;
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
			var horizontalTileCount:int = this.calculateHorizontalTileCount(tileWidth,
				width, width, this._paddingLeft + this._paddingRight,
				this._horizontalGap, this._requestedColumnCount, itemCount);
			var verticalTileCount:int = Math.ceil((height + this._verticalGap) / (tileHeight + this._verticalGap)) + 1;
			var minimumItemCount:int = verticalTileCount * horizontalTileCount;
			if(minimumItemCount > itemCount)
			{
				minimumItemCount = itemCount;
			}
			var rowIndexOffset:int = 0;
			var totalRowHeight:Number = Math.ceil(itemCount / horizontalTileCount) * (tileHeight + this._verticalGap) - this._verticalGap;
			if(totalRowHeight < height)
			{
				if(this._verticalAlign === VerticalAlign.BOTTOM)
				{
					rowIndexOffset = Math.ceil((height - totalRowHeight) / (tileHeight + this._verticalGap));
				}
				else if(this._verticalAlign === VerticalAlign.MIDDLE)
				{
					rowIndexOffset = Math.ceil((height - totalRowHeight) / (tileHeight + this._verticalGap) / 2);
				}
			}
			var rowIndex:int = -rowIndexOffset + Math.floor((scrollY - this._paddingTop + this._verticalGap) / (tileHeight + this._verticalGap));
			var minimum:int = rowIndex * horizontalTileCount;
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

		/**
		 * @private
		 */
		protected function validateItems(items:Vector.<DisplayObject>):void
		{
			var itemCount:int = items.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:DisplayObject = items[i];
				if(item is ILayoutDisplayObject && !ILayoutDisplayObject(item).includeInLayout)
				{
					continue;
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
		protected function prepareTypicalItem():void
		{
			if(!this._typicalItem)
			{
				return;
			}
			if(this._resetTypicalItemDimensionsOnMeasure)
			{
				this._typicalItem.width = this._typicalItemWidth;
				this._typicalItem.height = this._typicalItemHeight;
			}
			if(this._typicalItem is IValidating)
			{
				IValidating(this._typicalItem).validate();
			}
		}

		/**
		 * @inheritDoc
		 */
		public function calculateScrollPositionForIndex(index:int, items:Vector.<DisplayObject>,
			x:Number, y:Number, width:Number, height:Number, result:Point = null,
			nearest:Boolean = false, scrollX:Number = 0, scrollY:Number = 0):Point
		{
			if(!result)
			{
				result = new Point();
			}

			if(this._useVirtualLayout)
			{
				this.prepareTypicalItem();
				var calculatedTypicalItemWidth:Number = this._typicalItem ? this._typicalItem.width : 0;
				var calculatedTypicalItemHeight:Number = this._typicalItem ? this._typicalItem.height : 0;
			}

			var itemCount:int = items.length;
			var tileWidth:Number = this._useVirtualLayout ? calculatedTypicalItemWidth : 0;
			var tileHeight:Number = this._useVirtualLayout ? calculatedTypicalItemHeight : 0;
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
			var horizontalTileCount:int = (width - this._paddingLeft - this._paddingRight + this._horizontalGap) / (tileWidth + this._horizontalGap);
			if(horizontalTileCount < 1)
			{
				horizontalTileCount = 1;
			}
			else if(this._requestedColumnCount > 0 && horizontalTileCount > this._requestedColumnCount)
			{
				horizontalTileCount = this._requestedColumnCount;
			}
			if(this._paging !== PAGING_NONE)
			{
				var verticalTileCount:int = (height - this._paddingTop - this._paddingBottom + this._verticalGap) / (tileHeight + this._verticalGap);
				if(verticalTileCount < 1)
				{
					verticalTileCount = 1;
				}
				var perPage:Number = horizontalTileCount * verticalTileCount;
				var pageIndex:int = index / perPage;
				if(this._paging === PAGING_HORIZONTAL)
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
				var resultY:Number = this._paddingTop + ((tileHeight + this._verticalGap) * int(index / horizontalTileCount));
				if(nearest)
				{
					var bottomPosition:Number = resultY - (height - tileHeight);
					if(scrollY >= bottomPosition && scrollY <= resultY)
					{
						//keep the current scroll position because the item is already
						//fully visible
						resultY = scrollY;
					}
					else
					{
						var topDifference:Number = Math.abs(resultY - scrollY);
						var bottomDifference:Number = Math.abs(bottomPosition - scrollY);
						if(bottomDifference < topDifference)
						{
							resultY = bottomPosition;
						}
					}
				}
				else
				{
					resultY -= Math.round((height - tileHeight) / 2);
				}
				result.x = 0;
				result.y = resultY;
			}
			return result;
		}

		/**
		 * @private
		 */
		protected function calculateHorizontalTileCount(tileWidth:Number,
			explicitWidth:Number, maxWidth:Number, paddingLeftAndRight:Number,
			horizontalGap:Number, requestedColumnCount:int, totalItemCount:int):int
		{
			var tileCount:int;
			if(explicitWidth === explicitWidth) //!isNaN
			{
				//in this case, the exact width is known
				tileCount = (explicitWidth - paddingLeftAndRight + horizontalGap) / (tileWidth + horizontalGap);
				if(requestedColumnCount > 0 && tileCount > requestedColumnCount)
				{
					return requestedColumnCount;
				}
				if(tileCount > totalItemCount)
				{
					tileCount = totalItemCount;
				}
				if(tileCount < 1)
				{
					//we must have at least one tile per row
					tileCount = 1;
				}
				return tileCount;
			}
			
			//in this case, the width is not known, but it may have a maximum
			if(requestedColumnCount > 0)
			{
				tileCount = requestedColumnCount;
			}
			else
			{
				tileCount = totalItemCount;
			}
			
			var maxTileCount:int = int.MAX_VALUE;
			if(maxWidth === maxWidth && //!isNaN
				maxWidth < Number.POSITIVE_INFINITY)
			{
				maxTileCount = (maxWidth - paddingLeftAndRight + horizontalGap) / (tileWidth + horizontalGap);
				if(maxTileCount < 1)
				{
					//we must have at least one tile per row
					maxTileCount = 1;
				}
			}
			if(tileCount > maxTileCount)
			{
				tileCount = maxTileCount;
			}
			if(tileCount < 1)
			{
				//we must have at least one tile per row
				tileCount = 1;
			}
			return tileCount;
		}

		/**
		 * @private
		 */
		protected function calculateVerticalTileCount(tileHeight:Number,
			explicitHeight:Number, maxHeight:Number, paddingTopAndBottom:Number,
			verticalGap:Number, requestedRowCount:int, totalItemCount:int,
			horizontalTileCount:int):int
		{
			//using the horizontal tile count, calculate how many rows would be
			//required for the total number of items if there were no restrictions.
			var defaultVerticalTileCount:int = Math.ceil(totalItemCount / horizontalTileCount);
			
			var verticalTileCount:int;
			if(explicitHeight === explicitHeight) //!isNaN
			{
				//in this case, the exact height is known
				verticalTileCount = (explicitHeight - paddingTopAndBottom + verticalGap) / (tileHeight + verticalGap);
				if(requestedRowCount > 0 && verticalTileCount > requestedRowCount)
				{
					return requestedRowCount;
				}
				if(verticalTileCount > defaultVerticalTileCount)
				{
					verticalTileCount = defaultVerticalTileCount;
				}
				if(verticalTileCount < 1)
				{
					//we must have at least one tile per row
					verticalTileCount = 1;
				}
				return verticalTileCount;
			}

			//in this case, the height is not known, but it may have a maximum
			if(requestedRowCount > 0)
			{
				verticalTileCount = requestedRowCount;
			}
			else
			{
				verticalTileCount = defaultVerticalTileCount;
			}

			var maxVerticalTileCount:int = int.MAX_VALUE;
			if(maxHeight === maxHeight && //!isNaN
				maxHeight < Number.POSITIVE_INFINITY)
			{
				maxVerticalTileCount = (maxHeight - paddingTopAndBottom + verticalGap) / (tileHeight + verticalGap);
				if(maxVerticalTileCount < 1)
				{
					//we must have at least one tile per row
					maxVerticalTileCount = 1;
				}
			}
			if(verticalTileCount > maxVerticalTileCount)
			{
				verticalTileCount = maxVerticalTileCount;
			}
			if(verticalTileCount < 1)
			{
				//we must have at least one tile per row
				verticalTileCount = 1;
			}
			return verticalTileCount;
		}
	}
}
