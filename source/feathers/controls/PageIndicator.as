/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.core.FeathersControl;
	import feathers.core.IFeathersControl;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.ILayout;
	import feathers.layout.IVirtualLayout;
	import feathers.layout.LayoutBoundsResult;
	import feathers.layout.VerticalLayout;
	import feathers.layout.ViewPortBounds;

	import flash.geom.Point;

	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * Dispatched when the selected item changes.
	 *
	 * @eventType starling.events.Event.CHANGE
	 */
	[Event(name="change",type="starling.events.Event")]

	/**
	 * Displays a selected index, usually corresponding to a page index in
	 * another UI control, using a highlighted symbol.
	 *
	 * @see http://wiki.starling-framework.org/feathers/page-indicator
	 */
	public class PageIndicator extends FeathersControl
	{
		/**
		 * @private
		 */
		private static const LAYOUT_RESULT:LayoutBoundsResult = new LayoutBoundsResult();

		/**
		 * @private
		 */
		private static const SUGGESTED_BOUNDS:ViewPortBounds = new ViewPortBounds();

		/**
		 * @private
		 */
		private static const HELPER_POINT:Point = new Point();

		/**
		 * The page indicator's symbols will be positioned vertically, from top
		 * to bottom.
		 *
		 * @see #direction
		 */
		public static const DIRECTION_VERTICAL:String = "vertical";

		/**
		 * The page indicator's symbols will be positioned horizontally, from
		 * left to right.
		 *
		 * @see #direction
		 */
		public static const DIRECTION_HORIZONTAL:String = "horizontal";

		/**
		 * The symbols will be vertically aligned to the top.
		 *
		 * @see #verticalAlign
		 */
		public static const VERTICAL_ALIGN_TOP:String = "top";

		/**
		 * The symbols will be vertically aligned to the middle.
		 *
		 * @see #verticalAlign
		 */
		public static const VERTICAL_ALIGN_MIDDLE:String = "middle";

		/**
		 * The symbols will be vertically aligned to the bottom.
		 *
		 * @see #verticalAlign
		 */
		public static const VERTICAL_ALIGN_BOTTOM:String = "bottom";

		/**
		 * The symbols will be horizontally aligned to the left.
		 *
		 * @see #horizontalAlign
		 */
		public static const HORIZONTAL_ALIGN_LEFT:String = "left";

		/**
		 * The symbols will be horizontally aligned to the center.
		 *
		 * @see #horizontalAlign
		 */
		public static const HORIZONTAL_ALIGN_CENTER:String = "center";

		/**
		 * The symbols will be horizontally aligned to the right.
		 *
		 * @see #horizontalAlign
		 */
		public static const HORIZONTAL_ALIGN_RIGHT:String = "right";

		/**
		 * @private
		 */
		protected static function defaultSelectedSymbolFactory():Quad
		{
			return new Quad(25, 25, 0xffffff);
		}

		/**
		 * @private
		 */
		protected static function defaultNormalSymbolFactory():Quad
		{
			return new Quad(25, 25, 0xcccccc);
		}

		/**
		 * Constructor.
		 */
		public function PageIndicator()
		{
			this.isQuickHitAreaEnabled = true;
			this.addEventListener(TouchEvent.TOUCH, touchHandler);
		}

		/**
		 * @private
		 */
		protected var selectedSymbol:DisplayObject;

		/**
		 * @private
		 */
		protected var cache:Vector.<DisplayObject> = new <DisplayObject>[];

		/**
		 * @private
		 */
		protected var unselectedSymbols:Vector.<DisplayObject> = new <DisplayObject>[];

		/**
		 * @private
		 */
		protected var symbols:Vector.<DisplayObject> = new <DisplayObject>[];

		/**
		 * @private
		 */
		protected var touchPointID:int = -1;

		/**
		 * @private
		 */
		protected var _pageCount:int = 1;

		/**
		 * The number of available pages.
		 *
		 * <p>In the following example, the page count is changed:</p>
		 *
		 * <listing version="3.0">
		 * pages.pageCount = 5;</listing>
		 *
		 * @default 1
		 */
		public function get pageCount():int
		{
			return this._pageCount;
		}

		/**
		 * @private
		 */
		public function set pageCount(value:int):void
		{
			if(this._pageCount == value)
			{
				return;
			}
			this._pageCount = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _selectedIndex:int = 0;

		/**
		 * The currently selected index.
		 *
		 * <p>In the following example, the page indicator's selected index is
		 * changed:</p>
		 *
		 * <listing version="3.0">
		 * pages.selectedIndex = 2;</listing>
		 *
		 * <p>The following example listens for when selection changes and
		 * requests the selected index:</p>
		 *
		 * <listing version="3.0">
		 * function pages_changeHandler( event:Event ):void
		 * {
		 *     var pages:PageIndicator = PageIndicator( event.currentTarget );
		 *     var index:int = pages.selectedIndex;
		 *
		 * }
		 * pages.addEventListener( Event.CHANGE, pages_changeHandler );</listing>
		 *
		 * @default 0
		 */
		public function get selectedIndex():int
		{
			return this._selectedIndex;
		}

		/**
		 * @private
		 */
		public function set selectedIndex(value:int):void
		{
			value = Math.max(0, Math.min(value, this._pageCount - 1));
			if(this._selectedIndex == value)
			{
				return;
			}
			this._selectedIndex = value;
			this.invalidate(INVALIDATION_FLAG_SELECTED);
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _layout:ILayout;

		/**
		 * @private
		 */
		protected var _direction:String = DIRECTION_HORIZONTAL;

		[Inspectable(type="String",enumeration="horizontal,vertical")]
		/**
		 * The symbols may be positioned vertically or horizontally.
		 *
		 * <p>In the following example, the direction is changed to vertical:</p>
		 *
		 * <listing version="3.0">
		 * pages.direction = PageIndicator.DIRECTION_VERTICAL;</listing>
		 *
		 * @default PageIndicator.DIRECTION_HORIZONTAL
		 *
		 * @see #DIRECTION_HORIZONTAL
		 * @see #DIRECTION_VERTICAL
		 */
		public function get direction():String
		{
			return this._direction;
		}

		/**
		 * @private
		 */
		public function set direction(value:String):void
		{
			if(this._direction == value)
			{
				return;
			}
			this._direction = value;
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
		}

		/**
		 * @private
		 */
		protected var _horizontalAlign:String = HORIZONTAL_ALIGN_CENTER;

		[Inspectable(type="String",enumeration="left,center,right")]
		/**
		 * The alignment of the symbols on the horizontal axis.
		 *
		 * <p>In the following example, the symbols are horizontally aligned to
		 * the right:</p>
		 *
		 * <listing version="3.0">
		 * pages.horizontalAlign = PageIndicator.HORIZONTAL_ALIGN_RIGHT;</listing>
		 *
		 * @default PageIndicator.HORIZONTAL_ALIGN_CENTER
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
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
		}

		/**
		 * @private
		 */
		protected var _verticalAlign:String = VERTICAL_ALIGN_MIDDLE;

		[Inspectable(type="String",enumeration="top,middle,bottom")]
		/**
		 * The alignment of the symbols on the vertical axis.
		 *
		 * <p>In the following example, the symbols are vertically aligned to
		 * the bottom:</p>
		 *
		 * <listing version="3.0">
		 * pages.verticalAlign = PageIndicator.VERTICAL_ALIGN_BOTTOM;</listing>
		 *
		 * @default PageIndicator.VERTICAL_ALIGN_MIDDLE
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
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
		}

		/**
		 * @private
		 */
		protected var _gap:Number = 0;

		/**
		 * The spacing, in pixels, between symbols.
		 *
		 * <p>In the following example, the gap between symbols is set to 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * pages.gap = 20;</listing>
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
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
		}

		/**
		 * Quickly sets all padding properties to the same value. The
		 * <code>padding</code> getter always returns the value of
		 * <code>paddingTop</code>, but the other padding values may be
		 * different.
		 *
		 * <p>In the following example, the padding is set to 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * pages.padding = 20;</listing>
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
		 * The minimum space, in pixels, between the top edge of the component
		 * and the top edge of the content.
		 *
		 * <p>In the following example, the top padding is set to 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * pages.paddingTop = 20;</listing>
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
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _paddingRight:Number = 0;

		/**
		 * The minimum space, in pixels, between the right edge of the component
		 * and the right edge of the content.
		 *
		 * <p>In the following example, the right padding is set to 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * pages.paddingRight = 20;</listing>
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
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _paddingBottom:Number = 0;

		/**
		 * The minimum space, in pixels, between the bottom edge of the component
		 * and the bottom edge of the content.
		 *
		 * <p>In the following example, the bottom padding is set to 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * pages.paddingBottom = 20;</listing>
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
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _paddingLeft:Number = 0;

		/**
		 * The minimum space, in pixels, between the left edge of the component
		 * and the left edge of the content.
		 *
		 * <p>In the following example, the left padding is set to 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * pages.paddingLeft = 20;</listing>
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
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _normalSymbolFactory:Function = defaultNormalSymbolFactory;

		/**
		 * A function used to create a normal symbol. May be any Starling
		 * display object.
		 *
		 * <p>This function should have the following signature:</p>
		 * <pre>function():DisplayObject</pre>
		 *
		 * <p>In the following example, a custom normal symbol factory is provided
		 * to the page indicator:</p>
		 *
		 * <listing version="3.0">
		 * pages.normalSymbolFactory = function():DisplayObject
		 * {
		 *     return new Image( texture );
		 * };</listing>
		 *
		 * @see starling.display.DisplayObject
		 * @see #selectedSymbolFactory
		 */
		public function get normalSymbolFactory():Function
		{
			return this._normalSymbolFactory;
		}

		/**
		 * @private
		 */
		public function set normalSymbolFactory(value:Function):void
		{
			if(this._normalSymbolFactory == value)
			{
				return;
			}
			this._normalSymbolFactory = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _selectedSymbolFactory:Function = defaultSelectedSymbolFactory;

		/**
		 * A function used to create a selected symbol. May be any Starling
		 * display object.
		 *
		 * <p>This function should have the following signature:</p>
		 * <pre>function():DisplayObject</pre>
		 *
		 * <p>In the following example, a custom selected symbol factory is provided
		 * to the page indicator:</p>
		 *
		 * <listing version="3.0">
		 * pages.selectedSymbolFactory = function():DisplayObject
		 * {
		 *     return new Image( texture );
		 * };</listing>
		 *
		 * @see starling.display.DisplayObject
		 * @see #normalSymbolFactory
		 */
		public function get selectedSymbolFactory():Function
		{
			return this._selectedSymbolFactory;
		}

		/**
		 * @private
		 */
		public function set selectedSymbolFactory(value:Function):void
		{
			if(this._selectedSymbolFactory == value)
			{
				return;
			}
			this._selectedSymbolFactory = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const selectionInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SELECTED);
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			const layoutInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_LAYOUT);

			if(dataInvalid || selectionInvalid || stylesInvalid)
			{
				this.refreshSymbols(stylesInvalid);
			}

			this.layoutSymbols(layoutInvalid);
		}

		/**
		 * @private
		 */
		protected function refreshSymbols(symbolsInvalid:Boolean):void
		{
			this.symbols.length = 0;
			const temp:Vector.<DisplayObject> = this.cache;
			if(symbolsInvalid)
			{
				var symbolCount:int = this.unselectedSymbols.length;
				for(var i:int = 0; i < symbolCount; i++)
				{
					var symbol:DisplayObject = this.unselectedSymbols.shift();
					this.removeChild(symbol, true);
				}
				if(this.selectedSymbol)
				{
					this.removeChild(this.selectedSymbol, true);
					this.selectedSymbol = null;
				}
			}
			this.cache = this.unselectedSymbols;
			this.unselectedSymbols = temp;
			for(i = 0; i < this._pageCount; i++)
			{
				if(i == this._selectedIndex)
				{
					if(!this.selectedSymbol)
					{
						this.selectedSymbol = this._selectedSymbolFactory();
						this.addChild(this.selectedSymbol);
					}
					this.symbols.push(this.selectedSymbol);
					if(this.selectedSymbol is IFeathersControl)
					{
						IFeathersControl(this.selectedSymbol).validate();
					}
				}
				else
				{
					if(this.cache.length > 0)
					{
						symbol = this.cache.shift();
					}
					else
					{
						symbol = this._normalSymbolFactory();
						this.addChild(symbol);
					}
					this.unselectedSymbols.push(symbol);
					this.symbols.push(symbol);
					if(symbol is IFeathersControl)
					{
						IFeathersControl(symbol).validate();
					}
				}
			}

			symbolCount = this.cache.length;
			for(i = 0; i < symbolCount; i++)
			{
				symbol = this.cache.shift();
				this.removeChild(symbol, true);
			}

		}

		/**
		 * @private
		 */
		protected function layoutSymbols(layoutInvalid:Boolean):void
		{
			if(layoutInvalid)
			{
				if(this._direction == DIRECTION_VERTICAL && !(this._layout is VerticalLayout))
				{
					this._layout = new VerticalLayout();
					IVirtualLayout(this._layout).useVirtualLayout = false;
				}
				else if(this._direction != DIRECTION_VERTICAL && !(this._layout is HorizontalLayout))
				{
					this._layout = new HorizontalLayout();
					IVirtualLayout(this._layout).useVirtualLayout = false;
				}
				if(this._layout is VerticalLayout)
				{
					const verticalLayout:VerticalLayout = VerticalLayout(this._layout);
					verticalLayout.paddingTop = this._paddingTop;
					verticalLayout.paddingRight = this._paddingRight;
					verticalLayout.paddingBottom = this._paddingBottom;
					verticalLayout.paddingLeft = this._paddingLeft;
					verticalLayout.gap = this._gap;
					verticalLayout.horizontalAlign = this._horizontalAlign;
					verticalLayout.verticalAlign = this._verticalAlign;
				}
				if(this._layout is HorizontalLayout)
				{
					const horizontalLayout:HorizontalLayout = HorizontalLayout(this._layout);
					horizontalLayout.paddingTop = this._paddingTop;
					horizontalLayout.paddingRight = this._paddingRight;
					horizontalLayout.paddingBottom = this._paddingBottom;
					horizontalLayout.paddingLeft = this._paddingLeft;
					horizontalLayout.gap = this._gap;
					horizontalLayout.horizontalAlign = this._horizontalAlign;
					horizontalLayout.verticalAlign = this._verticalAlign;
				}
			}
			SUGGESTED_BOUNDS.x = SUGGESTED_BOUNDS.y = 0;
			SUGGESTED_BOUNDS.scrollX = SUGGESTED_BOUNDS.scrollY = 0;
			SUGGESTED_BOUNDS.explicitWidth = this.explicitWidth;
			SUGGESTED_BOUNDS.explicitHeight = this.explicitHeight;
			SUGGESTED_BOUNDS.maxWidth = this._maxWidth;
			SUGGESTED_BOUNDS.maxHeight = this._maxHeight;
			SUGGESTED_BOUNDS.minWidth = this._minWidth;
			SUGGESTED_BOUNDS.minHeight = this._minHeight;
			this._layout.layout(this.symbols, SUGGESTED_BOUNDS, LAYOUT_RESULT);
			this.setSizeInternal(LAYOUT_RESULT.contentWidth, LAYOUT_RESULT.contentHeight, false);
		}

		/**
		 * @private
		 */
		protected function touchHandler(event:TouchEvent):void
		{
			if(!this._isEnabled)
			{
				this.touchPointID = -1;
				return;
			}

			if(this.touchPointID >= 0)
			{
				var touch:Touch = event.getTouch(this, TouchPhase.ENDED, this.touchPointID);
				if(!touch)
				{
					return;
				}
				this.touchPointID = -1;
				touch.getLocation(this.stage, HELPER_POINT);
				const isInBounds:Boolean = this.contains(this.stage.hitTest(HELPER_POINT, true));
				if(isInBounds)
				{
					this.globalToLocal(HELPER_POINT, HELPER_POINT);
					if(this._direction == DIRECTION_VERTICAL)
					{
						if(HELPER_POINT.y < this.selectedSymbol.y)
						{
							this.selectedIndex = Math.max(0, this._selectedIndex - 1);
						}
						if(HELPER_POINT.y > (this.selectedSymbol.y + this.selectedSymbol.height))
						{
							this.selectedIndex = Math.min(this._pageCount - 1, this._selectedIndex + 1);
						}
					}
					else
					{
						if(HELPER_POINT.x < this.selectedSymbol.x)
						{
							this.selectedIndex = Math.max(0, this._selectedIndex - 1);
						}
						if(HELPER_POINT.x > (this.selectedSymbol.x + this.selectedSymbol.width))
						{
							this.selectedIndex = Math.min(this._pageCount - 1, this._selectedIndex + 1);
						}
					}
				}
			}
			else //if we get here, we don't have a saved touch ID yet
			{
				touch = event.getTouch(this, TouchPhase.BEGAN);
				if(!touch)
				{
					return;
				}
				this.touchPointID = touch.id;
			}
		}

	}
}
