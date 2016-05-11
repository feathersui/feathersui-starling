/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.core.FeathersControl;
	import feathers.core.IFeathersControl;
	import feathers.core.IMeasureDisplayObject;
	import feathers.core.ITextRenderer;
	import feathers.core.IValidating;
	import feathers.core.PropertyProxy;
	import feathers.events.FeathersEventType;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.LayoutBoundsResult;
	import feathers.layout.VerticalAlign;
	import feathers.layout.ViewPortBounds;
	import feathers.skins.IStyleProvider;
	import feathers.system.DeviceCapabilities;
	import feathers.utils.skins.resetFluidChildDimensionsForMeasurement;

	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.FullScreenEvent;
	import flash.geom.Point;
	import flash.system.Capabilities;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;

	/**
	 * A header that displays an optional title along with a horizontal regions
	 * on the sides for additional UI controls. The left side is typically for
	 * navigation (to display a back button, for example) and the right for
	 * additional actions. The title is displayed in the center by default,
	 * but it may be aligned to the left or right if there are no items on the
	 * desired side.
	 *
	 * <p>In the following example, a header is created, given a title, and a
	 * back button:</p>
	 *
	 * <listing version="3.0">
	 * var header:Header = new Header();
	 * header.title = "I'm a header";
	 * 
	 * var backButton:Button = new Button();
	 * backButton.label = "Back";
	 * backButton.styleNameList.add( Button.ALTERNATE_STYLE_NAME_BACK_BUTTON );
	 * backButton.addEventListener( Event.TRIGGERED, backButton_triggeredHandler );
	 * header.leftItems = new &lt;DisplayObject&gt;[ backButton ];
	 * 
	 * this.addChild( header );</listing>
	 *
	 * @see ../../../help/header.html How to use the Feathers Header component
	 */
	public class Header extends FeathersControl
	{
		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_LEFT_CONTENT:String = "leftContent";

		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_RIGHT_CONTENT:String = "rightContent";

		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_CENTER_CONTENT:String = "centerContent";

		/**
		 * @private
		 */
		protected static const IOS_STATUS_BAR_HEIGHT:Number = 20;

		/**
		 * @private
		 */
		protected static const IPAD_1X_DPI:Number = 132;

		/**
		 * @private
		 */
		protected static const IPHONE_1X_DPI:Number = 163;

		/**
		 * @private
		 */
		protected static const IOS_NAME_PREFIX:String = "iPhone OS ";

		/**
		 * @private
		 */
		protected static const STATUS_BAR_MIN_IOS_VERSION:int = 7;

		/**
		 * The default <code>IStyleProvider</code> for all <code>Header</code>
		 * components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.HorizontalAlign.CENTER</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const TITLE_ALIGN_CENTER:String = "center";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.HorizontalAlign.LEFT</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const TITLE_ALIGN_PREFER_LEFT:String = "preferLeft";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.HorizontalAlign.RIGHT</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const TITLE_ALIGN_PREFER_RIGHT:String = "preferRight";

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
		 * The default value added to the <code>styleNameList</code> of the header's
		 * items.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_ITEM:String = "feathers-header-item";

		/**
		 * The default value added to the <code>styleNameList</code> of the header's
		 * title.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_TITLE:String = "feathers-header-title";

		/**
		 * @private
		 */
		private static const HELPER_BOUNDS:ViewPortBounds = new ViewPortBounds();

		/**
		 * @private
		 */
		private static const HELPER_LAYOUT_RESULT:LayoutBoundsResult = new LayoutBoundsResult();

		/**
		 * @private
		 */
		private static const HELPER_POINT:Point = new Point();

		/**
		 * Constructor.
		 */
		public function Header()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, header_addedToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, header_removedFromStageHandler);
		}

		/**
		 * The text renderer for the header's title.
		 *
		 * <p>For internal use in subclasses.</p>
		 *
		 * @see #title
		 * @see #titleFactory
		 * @see #createTitle()
		 */
		protected var titleTextRenderer:ITextRenderer;

		/**
		 * The value added to the <code>styleNameList</code> of the header's
		 * title text renderer. This variable is <code>protected</code> so that
		 * sub-classes can customize the title text renderer style name in their
		 * constructors instead of using the default style name defined by
		 * <code>DEFAULT_CHILD_STYLE_NAME_TITLE</code>.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var titleStyleName:String = DEFAULT_CHILD_STYLE_NAME_TITLE;

		/**
		 * The value added to the <code>styleNameList</code> of each of the
		 * header's items. This variable is <code>protected</code> so that
		 * sub-classes can customize the item style name in their constructors
		 * instead of using the default style name defined by
		 * <code>DEFAULT_CHILD_STYLE_NAME_ITEM</code>.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var itemStyleName:String = DEFAULT_CHILD_STYLE_NAME_ITEM;

		/**
		 * @private
		 */
		protected var leftItemsWidth:Number = 0;

		/**
		 * @private
		 */
		protected var rightItemsWidth:Number = 0;

		/**
		 * @private
		 * The layout algorithm. Shared by both sides.
		 */
		protected var _layout:HorizontalLayout;

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return Header.globalStyleProvider;
		}

		/**
		 * @private
		 */
		protected var _title:String = null;

		/**
		 * The text displayed for the header's title.
		 *
		 * <p>In the following example, the header's title is set:</p>
		 *
		 * <listing version="3.0">
		 * header.title = "I'm a Header";</listing>
		 *
		 * @default ""
		 *
		 * @see #titleFactory
		 */
		public function get title():String
		{
			return this._title;
		}

		/**
		 * @private
		 */
		public function set title(value:String):void
		{
			if(this._title === value)
			{
				return;
			}
			this._title = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _titleFactory:Function;

		/**
		 * A function used to instantiate the header's title text renderer
		 * sub-component. By default, the header will use the global text
		 * renderer factory, <code>FeathersControl.defaultTextRendererFactory()</code>,
		 * to create the title text renderer. The title text renderer must be an
		 * instance of <code>ITextRenderer</code>. This factory can be used to
		 * change properties on the title text renderer when it is first
		 * created. For instance, if you are skinning Feathers components
		 * without a theme, you might use this factory to style the title text
		 * renderer.
		 *
		 * <p>If you are not using a theme, the title factory can be used to
		 * provide skin the title with appropriate text styles.</p>
		 *
		 * <p>The factory should have the following function signature:</p>
		 * <pre>function():ITextRenderer</pre>
		 *
		 * <p>In the following example, a custom title factory is passed to the
		 * header:</p>
		 *
		 * <listing version="3.0">
		 * header.titleFactory = function():ITextRenderer
		 * {
		 *     var titleRenderer:TextFieldTextRenderer = new TextFieldTextRenderer();
		 *     titleRenderer.textFormat = new TextFormat( "_sans", 12, 0xff0000 );
		 *     return titleRenderer;
		 * }</listing>
		 *
		 * @default null
		 *
		 * @see #title
		 * @see feathers.core.ITextRenderer
		 * @see feathers.core.FeathersControl#defaultTextRendererFactory
		 */
		public function get titleFactory():Function
		{
			return this._titleFactory;
		}

		/**
		 * @private
		 */
		public function set titleFactory(value:Function):void
		{
			if(this._titleFactory == value)
			{
				return;
			}
			this._titleFactory = value;
			this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
		}

		/**
		 * @private
		 */
		protected var _disposeItems:Boolean = true;

		/**
		 * Determines if the <code>leftItems</code>, <code>centerItems</code>,
		 * and <code>rightItems</code> are disposed or not when the header is
		 * disposed.
		 *
		 * <p>If you change this value to <code>false</code>, you must dispose
		 * the items manually. Failing to dispose the items may result in a
		 * memory leak.</p>
		 *
		 * @default true
		 */
		public function get disposeItems():Boolean
		{
			return this._disposeItems;
		}

		/**
		 * @private
		 */
		public function set disposeItems(value:Boolean):void
		{
			this._disposeItems = value;
		}

		/**
		 * @private
		 */
		protected var _leftItems:Vector.<DisplayObject>;

		/**
		 * The UI controls that appear in the left region of the header.
		 * 
		 * <p>If <code>leftItems</code> is not empty, and
		 * <code>titleAlign</code> is <code>HorizontalAlign.LEFT</code>, the
		 * title text renderer will appear to the right of the left items.</p>
		 *
		 * <p>In the following example, a back button is displayed on the left
		 * side of the header:</p>
		 *
		 * <listing version="3.0">
		 * var backButton:Button = new Button();
		 * backButton.label = "Back";
		 * backButton.styleNameList.add( Button.ALTERNATE_STYLE_NAME_BACK_BUTTON );
		 * backButton.addEventListener( Event.TRIGGERED, backButton_triggeredHandler );
		 * header.leftItems = new &lt;DisplayObject&gt;[ backButton ];</listing>
		 *
		 * @default null
		 */
		public function get leftItems():Vector.<DisplayObject>
		{
			return this._leftItems;
		}

		/**
		 * @private
		 */
		public function set leftItems(value:Vector.<DisplayObject>):void
		{
			if(this._leftItems == value)
			{
				return;
			}
			if(this._leftItems)
			{
				for each(var item:DisplayObject in this._leftItems)
				{
					if(item is IFeathersControl)
					{
						IFeathersControl(item).styleNameList.remove(this.itemStyleName);
						item.removeEventListener(FeathersEventType.RESIZE, item_resizeHandler);
					}
					item.removeFromParent();
				}
			}
			this._leftItems = value;
			if(this._leftItems)
			{
				for each(item in this._leftItems)
				{
					if(item is IFeathersControl)
					{
						item.addEventListener(FeathersEventType.RESIZE, item_resizeHandler);
					}
				}
			}
			this.invalidate(INVALIDATION_FLAG_LEFT_CONTENT);
		}

		/**
		 * @private
		 */
		protected var _centerItems:Vector.<DisplayObject>;

		/**
		 * The UI controls that appear in the center region of the header. If
		 * <code>centerItems</code> is not empty, and <code>titleAlign</code>
		 * is <code>HorizontalAlign.CENTER</code>, the title text renderer will
		 * be hidden.
		 *
		 * <p>In the following example, a settings button is displayed in the
		 * center of the header:</p>
		 *
		 * <listing version="3.0">
		 * var settingsButton:Button = new Button();
		 * settingsButton.label = "Settings";
		 * settingsButton.addEventListener( Event.TRIGGERED, settingsButton_triggeredHandler );
		 * header.centerItems = new &lt;DisplayObject&gt;[ settingsButton ];</listing>
		 *
		 * @default null
		 */
		public function get centerItems():Vector.<DisplayObject>
		{
			return this._centerItems;
		}

		/**
		 * @private
		 */
		public function set centerItems(value:Vector.<DisplayObject>):void
		{
			if(this._centerItems == value)
			{
				return;
			}
			if(this._centerItems)
			{
				for each(var item:DisplayObject in this._centerItems)
				{
					if(item is IFeathersControl)
					{
						IFeathersControl(item).styleNameList.remove(this.itemStyleName);
						item.removeEventListener(FeathersEventType.RESIZE, item_resizeHandler);
					}
					item.removeFromParent();
				}
			}
			this._centerItems = value;
			if(this._centerItems)
			{
				for each(item in this._centerItems)
				{
					if(item is IFeathersControl)
					{
						item.addEventListener(FeathersEventType.RESIZE, item_resizeHandler);
					}
				}
			}
			this.invalidate(INVALIDATION_FLAG_CENTER_CONTENT);
		}

		/**
		 * @private
		 */
		protected var _rightItems:Vector.<DisplayObject>;

		/**
		 * The UI controls that appear in the right region of the header.
		 *
		 * <p>If <code>rightItems</code> is not empty, and
		 * <code>titleAlign</code> is <code>HorizontalAlign.RIGHT</code>, the
		 * title text renderer will appear to the left of the right items.</p>
		 *
		 * <p>In the following example, a settings button is displayed on the
		 * right side of the header:</p>
		 *
		 * <listing version="3.0">
		 * var settingsButton:Button = new Button();
		 * settingsButton.label = "Settings";
		 * settingsButton.addEventListener( Event.TRIGGERED, settingsButton_triggeredHandler );
		 * header.rightItems = new &lt;DisplayObject&gt;[ settingsButton ];</listing>
		 *
		 * @default null
		 */
		public function get rightItems():Vector.<DisplayObject>
		{
			return this._rightItems;
		}

		/**
		 * @private
		 */
		public function set rightItems(value:Vector.<DisplayObject>):void
		{
			if(this._rightItems == value)
			{
				return;
			}
			if(this._rightItems)
			{
				for each(var item:DisplayObject in this._rightItems)
				{
					if(item is IFeathersControl)
					{
						IFeathersControl(item).styleNameList.remove(this.itemStyleName);
						item.removeEventListener(FeathersEventType.RESIZE, item_resizeHandler);
					}
					item.removeFromParent();
				}
			}
			this._rightItems = value;
			if(this._rightItems)
			{
				for each(item in this._rightItems)
				{
					if(item is IFeathersControl)
					{
						item.addEventListener(FeathersEventType.RESIZE, item_resizeHandler);
					}
				}
			}
			this.invalidate(INVALIDATION_FLAG_RIGHT_CONTENT);
		}

		/**
		 * Quickly sets all padding properties to the same value. The
		 * <code>padding</code> getter always returns the value of
		 * <code>paddingTop</code>, but the other padding values may be
		 * different.
		 *
		 * <p>In the following example, the header's padding is set to 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * header.padding = 20;</listing>
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
		 * The minimum space, in pixels, between the header's top edge and the
		 * header's content.
		 *
		 * <p>In the following example, the header's top padding is set to 20
		 * pixels:</p>
		 *
		 * <listing version="3.0">
		 * header.paddingTop = 20;</listing>
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
		 * The minimum space, in pixels, between the header's right edge and the
		 * header's content.
		 *
		 * <p>In the following example, the header's right padding is set to 20
		 * pixels:</p>
		 *
		 * <listing version="3.0">
		 * header.paddingRight = 20;</listing>
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
		 * The minimum space, in pixels, between the header's bottom edge and
		 * the header's content.
		 *
		 * <p>In the following example, the header's bottom padding is set to 20
		 * pixels:</p>
		 *
		 * <listing version="3.0">
		 * header.paddingBottom = 20;</listing>
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
		 * The minimum space, in pixels, between the header's left edge and the
		 * header's content.
		 *
		 * <p>In the following example, the header's left padding is set to 20
		 * pixels:</p>
		 *
		 * <listing version="3.0">
		 * header.paddingLeft = 20;</listing>
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
		protected var _gap:Number = 0;

		/**
		 * Space, in pixels, between items. The same value is used with the
		 * <code>leftItems</code> and <code>rightItems</code>.
		 *
		 * <p>Set the <code>titleGap</code> to make the gap on the left and
		 * right of the title use a different value.</p>
		 *
		 * <p>In the following example, the header's gap between items is set to
		 * 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * header.gap = 20;</listing>
		 *
		 * @default 0
		 *
		 * @see #titleGap
		 * @see #leftItems
		 * @see #rightItems
		 */
		public function get gap():Number
		{
			return _gap;
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
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _titleGap:Number = NaN;

		/**
		 * Space, in pixels, between the title and the left or right groups of
		 * items. If <code>NaN</code> (the default), the default <code>gap</code>
		 * property is used instead.
		 *
		 * <p>In the following example, the header's title gap is set to 20
		 * pixels:</p>
		 *
		 * <listing version="3.0">
		 * header.titleGap = 20;</listing>
		 *
		 * @default NaN
		 *
		 * @see #gap
		 */
		public function get titleGap():Number
		{
			return _titleGap;
		}

		/**
		 * @private
		 */
		public function set titleGap(value:Number):void
		{
			if(this._titleGap == value)
			{
				return;
			}
			this._titleGap = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _useExtraPaddingForOSStatusBar:Boolean = false;

		/**
		 * If enabled, the header's top padding will be increased to account for
		 * the height of the OS status bar when the app is rendered under the OS
		 * status bar. The header will not add extra padding to apps that aren't
		 * rendered under the OS status bar.
		 *
		 * <p>iOS started rendering apps that aren't full screen under the OS
		 * status bar in version 7.</p>
		 *
		 * <p>In the following example, the header's padding will account for
		 * the iOS status bar height:</p>
		 *
		 * <listing version="3.0">
		 * header.useExtraPaddingForOSStatusBar = true;</listing>
		 *
		 * @default false;
		 *
		 * @see #paddingTop
		 */
		public function get useExtraPaddingForOSStatusBar():Boolean
		{
			return this._useExtraPaddingForOSStatusBar;
		}

		/**
		 * @private
		 */
		public function set useExtraPaddingForOSStatusBar(value:Boolean):void
		{
			if(this._useExtraPaddingForOSStatusBar == value)
			{
				return;
			}
			this._useExtraPaddingForOSStatusBar = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _verticalAlign:String = VerticalAlign.MIDDLE;

		[Inspectable(type="String",enumeration="top,middle,bottom")]
		/**
		 * The alignment of the items vertically, on the y-axis.
		 *
		 * <p>In the following example, the header's vertical alignment is set
		 * to the middle:</p>
		 *
		 * <listing version="3.0">
		 * header.verticalAlign = VerticalAlign.MIDDLE;</listing>
		 *
		 * @default feathers.layout.VerticalAlign.MIDDLE
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
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var currentBackgroundSkin:DisplayObject;

		/**
		 * @private
		 */
		protected var _explicitBackgroundWidth:Number;

		/**
		 * @private
		 */
		protected var _explicitBackgroundHeight:Number;

		/**
		 * @private
		 */
		protected var _explicitBackgroundMinWidth:Number;

		/**
		 * @private
		 */
		protected var _explicitBackgroundMinHeight:Number;

		/**
		 * @private
		 */
		protected var _backgroundSkin:DisplayObject;

		/**
		 * A display object displayed behind the header's content.
		 *
		 * <p>In the following example, the header's background skin is set to
		 * a <code>Quad</code>:</p>
		 *
		 * <listing version="3.0">
		 * header.backgroundSkin = new Quad( 10, 10, 0xff0000 );</listing>
		 *
		 * @default null
		 */
		public function get backgroundSkin():DisplayObject
		{
			return this._backgroundSkin;
		}

		/**
		 * @private
		 */
		public function set backgroundSkin(value:DisplayObject):void
		{
			if(this._backgroundSkin == value)
			{
				return;
			}

			if(this._backgroundSkin && this._backgroundSkin != this._backgroundDisabledSkin)
			{
				this.removeChild(this._backgroundSkin);
			}
			this._backgroundSkin = value;
			if(this._backgroundSkin && this._backgroundSkin.parent != this)
			{
				this._backgroundSkin.visible = false;
				this.addChildAt(this._backgroundSkin, 0);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _backgroundDisabledSkin:DisplayObject;

		/**
		 * A background to display when the header is disabled. If the property
		 * is <code>null</code>, the value of the <code>backgroundSkin</code>
		 * property will be used instead.
		 *
		 * <p>In the following example, the header's disabled background skin is
		 * set to a <code>Quad</code>:</p>
		 *
		 * <listing version="3.0">
		 * header.backgroundDisabledSkin = new Quad( 10, 10, 0x999999 );</listing>
		 *
		 * @default null
		 */
		public function get backgroundDisabledSkin():DisplayObject
		{
			return this._backgroundDisabledSkin;
		}

		/**
		 * @private
		 */
		public function set backgroundDisabledSkin(value:DisplayObject):void
		{
			if(this._backgroundDisabledSkin == value)
			{
				return;
			}

			if(this._backgroundDisabledSkin && this._backgroundDisabledSkin != this._backgroundSkin)
			{
				this.removeChild(this._backgroundDisabledSkin);
			}
			this._backgroundDisabledSkin = value;
			if(this._backgroundDisabledSkin && this._backgroundDisabledSkin.parent != this)
			{
				this._backgroundDisabledSkin.visible = false;
				this.addChildAt(this._backgroundDisabledSkin, 0);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _customTitleStyleName:String;

		/**
		 * A style name to add to the header's title text renderer
		 * sub-component. Typically used by a theme to provide different styles
		 * to different headers.
		 *
		 * <p>In the following example, a custom title style name is passed to
		 * the header:</p>
		 *
		 * <listing version="3.0">
		 * header.customTitleStyleName = "my-custom-header-title";</listing>
		 *
		 * <p>In your theme, you can target this sub-component style name to
		 * provide different styles than the default:</p>
		 *
		 * <listing version="3.0">
		 * getStyleProviderForClass( BitmapFontTextRenderer ).setFunctionForStyleName( "my-custom-header-title", setCustomHeaderTitleStyles );</listing>
		 *
		 * @default null
		 *
		 * @see #DEFAULT_CHILD_STYLE_NAME_TITLE
		 * @see feathers.core.FeathersControl#styleNameList
		 * @see #titleFactory
		 */
		public function get customTitleStyleName():String
		{
			return this._customTitleStyleName;
		}

		/**
		 * @private
		 */
		public function set customTitleStyleName(value:String):void
		{
			if(this._customTitleStyleName == value)
			{
				return;
			}
			this._customTitleStyleName = value;
			this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
		}

		/**
		 * @private
		 */
		protected var _titleProperties:PropertyProxy;

		/**
		 * An object that stores properties for the header's title text renderer
		 * sub-component, and the properties will be passed down to the text
		 * renderer when the header validates. The available properties
		 * depend on which <code>ITextRenderer</code> implementation is returned
		 * by <code>textRendererFactory</code>. Refer to
		 * <a href="../core/ITextRenderer.html"><code>feathers.core.ITextRenderer</code></a>
		 * for a list of available text renderer implementations.
		 *
		 * <p>In the following example, some properties are set for the header's
		 * title text renderer (this example assumes that the title text renderer
		 * is a <code>BitmapFontTextRenderer</code>):</p>
		 *
		 * <listing version="3.0">
		 * header.titleProperties.textFormat = new BitmapFontTextFormat( bitmapFont );
		 * header.titleProperties.wordWrap = true;</listing>
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
		 * which is in a <code>List</code>, you can use the following syntax:</p>
		 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * <p>Setting properties in a <code>titleFactory</code> function instead
		 * of using <code>titleProperties</code> will result in better
		 * performance.</p>
		 *
		 * @default null
		 *
		 * @see #titleFactory
		 * @see feathers.core.ITextRenderer
		 */
		public function get titleProperties():Object
		{
			if(!this._titleProperties)
			{
				this._titleProperties = new PropertyProxy(titleProperties_onChange);
			}
			return this._titleProperties;
		}

		/**
		 * @private
		 */
		public function set titleProperties(value:Object):void
		{
			if(this._titleProperties == value)
			{
				return;
			}
			if(value && !(value is PropertyProxy))
			{
				value = PropertyProxy.fromObject(value);
			}
			if(this._titleProperties)
			{
				this._titleProperties.removeOnChangeCallback(titleProperties_onChange);
			}
			this._titleProperties = PropertyProxy(value);
			if(this._titleProperties)
			{
				this._titleProperties.addOnChangeCallback(titleProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _titleAlign:String = HorizontalAlign.CENTER;

		[Inspectable(type="String",enumeration="center,preferLeft,preferRight")]
		/**
		 * The preferred horizontal position of the title.
		 * 
		 * <p>If <code>titleAlign</code> is set to
		 * <code>HorizontalAlign.LEFT</code>, but <code>leftItems</code> is not
		 * empty, the title will be positioned slightly to the right of the
		 * left items. If <code>centerItems</code> is also not empty, the title
		 * will not be displayed.</p>
		 *
		 * <p>If <code>titleAlign</code> is set to
		 * <code>HorizontalAlign.RIGHT</code>, but <code>rightItems</code> is
		 * not empty, the title will be positioned slightly to the left of the
		 * right items. If <code>centerItems</code> is also not empty, the title
		 * will not be displayed.</p>
		 * 
		 * <p>If <code>titleAlign</code> is set to
		 * <code>HorizontalAlign.CENTER</code>, but <code>centerItems</code> is
		 * not <code>null</code>, the title will not be displayed.</p>
		 *
		 * <p>In the following example, the header's title alignment is set to
		 * prefer the left side:</p>
		 *
		 * <listing version="3.0">
		 * header.titleAlign = HorizontalAlign.LEFT;</listing>
		 *
		 * @default feathers.layout.HorizontalAlign.CENTER
		 *
		 * @see feathers.layout.HorizontalAlign#CENTER
		 * @see feathers.layout.HorizontalAlign#LEFT
		 * @see feathers.layout.HorizontalAlign#RIGHT
		 */
		public function get titleAlign():String
		{
			return this._titleAlign;
		}

		/**
		 * @private
		 */
		public function set titleAlign(value:String):void
		{
			if(this._titleAlign == value)
			{
				return;
			}
			this._titleAlign = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		override public function dispose():void
		{
			if(this._disposeItems)
			{
				for each(var item:DisplayObject in this._leftItems)
				{
					item.dispose();
				}
				for each(item in this._centerItems)
				{
					item.dispose();
				}
				for each(item in this._rightItems)
				{
					item.dispose();
				}
			}
			this.leftItems = null;
			this.rightItems = null;
			this.centerItems = null;
			super.dispose();
		}

		/**
		 * @private
		 */
		override protected function initialize():void
		{
			if(!this._layout)
			{
				this._layout = new HorizontalLayout();
				this._layout.useVirtualLayout = false;
				this._layout.verticalAlign = VerticalAlign.MIDDLE;
			}
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			var stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			var stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			var leftContentInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_LEFT_CONTENT);
			var rightContentInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_RIGHT_CONTENT);
			var centerContentInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_CENTER_CONTENT);
			var textRendererInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_TEXT_RENDERER);

			if(textRendererInvalid)
			{
				this.createTitle();
			}

			if(textRendererInvalid || dataInvalid)
			{
				this.titleTextRenderer.text = this._title;
			}

			if(stateInvalid || stylesInvalid)
			{
				this.refreshBackground();
			}

			if(textRendererInvalid || stylesInvalid || sizeInvalid)
			{
				this.refreshLayout();
			}
			if(textRendererInvalid || stylesInvalid)
			{
				this.refreshTitleStyles();
			}

			if(leftContentInvalid)
			{
				if(this._leftItems)
				{
					for each(var item:DisplayObject in this._leftItems)
					{
						if(item is IFeathersControl)
						{
							IFeathersControl(item).styleNameList.add(this.itemStyleName);
						}
						this.addChild(item);
					}
				}
			}

			if(rightContentInvalid)
			{
				if(this._rightItems)
				{
					for each(item in this._rightItems)
					{
						if(item is IFeathersControl)
						{
							IFeathersControl(item).styleNameList.add(this.itemStyleName);
						}
						this.addChild(item);
					}
				}
			}

			if(centerContentInvalid)
			{
				if(this._centerItems)
				{
					for each(item in this._centerItems)
					{
						if(item is IFeathersControl)
						{
							IFeathersControl(item).styleNameList.add(this.itemStyleName);
						}
						this.addChild(item);
					}
				}
			}

			if(stateInvalid || textRendererInvalid)
			{
				this.refreshEnabled();
			}

			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

			this.layoutBackground();

			if(sizeInvalid || leftContentInvalid || rightContentInvalid || centerContentInvalid || stylesInvalid)
			{
				this.leftItemsWidth = 0;
				this.rightItemsWidth = 0;
				if(this._leftItems)
				{
					this.layoutLeftItems();
				}
				if(this._rightItems)
				{
					this.layoutRightItems();
				}
				if(this._centerItems)
				{
					this.layoutCenterItems();
				}
			}

			if(textRendererInvalid || sizeInvalid || stylesInvalid || dataInvalid || leftContentInvalid || rightContentInvalid || centerContentInvalid)
			{
				this.layoutTitle();
			}

		}

		/**
		 * If the component's dimensions have not been set explicitly, it will
		 * measure its content and determine an ideal size for itself. If the
		 * <code>explicitWidth</code> or <code>explicitHeight</code> member
		 * variables are set, those value will be used without additional
		 * measurement. If one is set, but not the other, the dimension with the
		 * explicit value will not be measured, but the other non-explicit
		 * dimension will still need measurement.
		 *
		 * <p>Calls <code>saveMeasurements()</code> to set up the
		 * <code>actualWidth</code> and <code>actualHeight</code> member
		 * variables used for layout.</p>
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 */
		protected function autoSizeIfNeeded():Boolean
		{
			var needsWidth:Boolean = this._explicitWidth !== this._explicitWidth; //isNaN
			var needsHeight:Boolean = this._explicitHeight !== this._explicitHeight; //isNaN
			var needsMinWidth:Boolean = this._explicitMinWidth !== this._explicitMinWidth; //isNaN
			var needsMinHeight:Boolean = this._explicitMinHeight !== this._explicitMinHeight; //isNaN
			if(!needsWidth && !needsHeight && !needsMinWidth && !needsMinHeight)
			{
				return false;
			}

			resetFluidChildDimensionsForMeasurement(this.currentBackgroundSkin,
				this._explicitWidth, this._explicitHeight,
				this._explicitMinWidth, this._explicitMinHeight,
				this._explicitBackgroundWidth, this._explicitBackgroundHeight,
				this._explicitBackgroundMinWidth, this._explicitBackgroundMinHeight);
			var measureSkin:IMeasureDisplayObject = this.currentBackgroundSkin as IMeasureDisplayObject;
			if(this.currentBackgroundSkin is IValidating)
			{
				IValidating(this.currentBackgroundSkin).validate();
			}

			var extraPaddingTop:Number = this.calculateExtraOSStatusBarPadding();

			var totalContentWidth:Number = 0;
			var maxContentHeight:Number = 0;
			var hasLeftItems:Boolean = this._leftItems !== null && this._leftItems.length > 0;
			var hasRightItems:Boolean = this._rightItems !== null && this._rightItems.length > 0;
			var hasCenterItems:Boolean = this._centerItems !== null && this._centerItems.length > 0;
			if(hasLeftItems)
			{
				var itemCount:int = this._leftItems.length;
				for(var i:int = 0; i < itemCount; i++)
				{
					var item:DisplayObject = this._leftItems[i];
					if(item is IValidating)
					{
						IValidating(item).validate();
					}
					var itemWidth:Number = item.width;
					if(itemWidth === itemWidth) //!isNaN
					{
						totalContentWidth += itemWidth;
						if(i > 0)
						{
							totalContentWidth += this._gap;
						}
					}
					var itemHeight:Number = item.height;
					if(itemHeight === itemHeight && //!isNaN
						itemHeight > maxContentHeight)
					{
						maxContentHeight = itemHeight;
					}
				}
			}
			if(hasCenterItems)
			{
				itemCount = this._centerItems.length;
				for(i = 0; i < itemCount; i++)
				{
					item = this._centerItems[i];
					if(item is IValidating)
					{
						IValidating(item).validate();
					}
					itemWidth = item.width;
					if(itemWidth === itemWidth) //!isNaN
					{
						totalContentWidth += itemWidth;
						if(i > 0)
						{
							totalContentWidth += this._gap;
						}
					}
					itemHeight = item.height;
					if(itemHeight === itemHeight && //!isNaN
						itemHeight > maxContentHeight)
					{
						maxContentHeight = itemHeight;
					}
				}
			}
			if(hasRightItems)
			{
				itemCount = this._rightItems.length;
				for(i = 0; i < itemCount; i++)
				{
					item = this._rightItems[i];
					if(item is IValidating)
					{
						IValidating(item).validate();
					}
					itemWidth = item.width;
					if(itemWidth === itemWidth) //!isNaN
					{
						totalContentWidth += itemWidth;
						if(i > 0)
						{
							totalContentWidth += this._gap;
						}
					}
					itemHeight = item.height;
					if(itemHeight === itemHeight && //!isNaN
						itemHeight > maxContentHeight)
					{
						maxContentHeight = itemHeight;
					}
				}
			}

			if(this._titleAlign === HorizontalAlign.CENTER && hasCenterItems)
			{
				if(hasLeftItems)
				{
					totalContentWidth += this._gap;
				}
				if(hasRightItems)
				{
					totalContentWidth += this._gap;
				}
			}
			else if(this._title !== null)
			{
				var calculatedTitleGap:Number = this._titleGap;
				if(calculatedTitleGap !== calculatedTitleGap) //isNaN
				{
					calculatedTitleGap = this._gap;
				}
				var maxTitleWidth:Number = this._explicitWidth;
				if(needsWidth)
				{
					maxTitleWidth = this._maxWidth;
				}
				maxTitleWidth -= totalContentWidth;
				if(hasLeftItems)
				{
					maxTitleWidth -= calculatedTitleGap;
				}
				if(hasCenterItems)
				{
					maxTitleWidth -= calculatedTitleGap;
				}
				if(hasRightItems)
				{
					maxTitleWidth -= calculatedTitleGap;
				}
				if(maxTitleWidth < 0)
				{
					maxTitleWidth = 0;
				}
				this.titleTextRenderer.maxWidth = maxTitleWidth;
				this.titleTextRenderer.measureText(HELPER_POINT);
				var measuredTitleWidth:Number = HELPER_POINT.x;
				var measuredTitleHeight:Number = HELPER_POINT.y;
				if(measuredTitleWidth === measuredTitleWidth) //!isNaN
				{
					if(hasLeftItems)
					{
						measuredTitleWidth += calculatedTitleGap;
					}
					if(hasRightItems)
					{
						measuredTitleWidth += calculatedTitleGap;
					}
				}
				else
				{
					measuredTitleWidth = 0;
				}
				totalContentWidth += measuredTitleWidth;
				if(measuredTitleHeight === measuredTitleHeight && //!isNaN
					measuredTitleHeight > maxContentHeight)
				{
					maxContentHeight = measuredTitleHeight;
				}
			}

			var newWidth:Number = this._explicitWidth;
			if(needsWidth)
			{
				newWidth = totalContentWidth + this._paddingLeft + this._paddingRight;
				if(this.currentBackgroundSkin !== null &&
					this.currentBackgroundSkin.width > newWidth)
				{
					newWidth = this.currentBackgroundSkin.width;
				}
			}

			var newHeight:Number = this._explicitHeight;
			if(needsHeight)
			{
				newHeight = maxContentHeight;
				newHeight += this._paddingTop + this._paddingBottom;
				if(extraPaddingTop > 0)
				{
					//account for the minimum height before adding the padding
					if(newHeight < this._explicitMinHeight)
					{
						newHeight = this._explicitMinHeight;
					}
					newHeight += extraPaddingTop;
				}
				if(this.currentBackgroundSkin !== null &&
					this.currentBackgroundSkin.height > newHeight)
				{
					newHeight = this.currentBackgroundSkin.height;
				}
			}
			
			var newMinWidth:Number = this._explicitMinWidth;
			if(needsMinWidth)
			{
				newMinWidth = totalContentWidth + this._paddingLeft + this._paddingRight;
				if(this.currentBackgroundSkin !== null)
				{
					if(measureSkin !== null)
					{
						if(measureSkin.minWidth > newMinWidth)
						{
							newMinWidth = measureSkin.minWidth;
						}
					}
					else if(this._explicitBackgroundMinWidth > newMinWidth)
					{
						newMinWidth = this._explicitBackgroundMinWidth;
					}
				}
			}
			
			var newMinHeight:Number = this._explicitMinHeight;
			if(needsMinHeight)
			{
				newMinHeight = maxContentHeight;
				newMinHeight += this._paddingTop + this._paddingBottom;
				if(extraPaddingTop > 0)
				{
					//account for the minimum height before adding the padding
					if(newMinHeight < this._explicitMinHeight)
					{
						newMinHeight = this._explicitMinHeight;
					}
					newMinHeight += extraPaddingTop;
				}
				if(this.currentBackgroundSkin !== null)
				{
					if(measureSkin !== null)
					{
						if(measureSkin.minHeight > newMinHeight)
						{
							newMinHeight = measureSkin.minHeight;
						}
					}
					else if(this._explicitBackgroundMinHeight > newMinHeight)
					{
						newMinHeight = this._explicitBackgroundMinHeight;
					}
				}
			}

			return this.saveMeasurements(newWidth, newHeight, newMinWidth, newMinHeight);
		}

		/**
		 * Creates and adds the <code>titleTextRenderer</code> sub-component and
		 * removes the old instance, if one exists.
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 *
		 * @see #title
		 * @see #titleTextRenderer
		 * @see #titleFactory
		 */
		protected function createTitle():void
		{
			if(this.titleTextRenderer)
			{
				this.removeChild(DisplayObject(this.titleTextRenderer), true);
				this.titleTextRenderer = null;
			}

			var factory:Function = this._titleFactory != null ? this._titleFactory : FeathersControl.defaultTextRendererFactory;
			this.titleTextRenderer = ITextRenderer(factory());
			var uiTitleRenderer:IFeathersControl = IFeathersControl(this.titleTextRenderer);
			var titleStyleName:String = this._customTitleStyleName != null ? this._customTitleStyleName : this.titleStyleName;
			uiTitleRenderer.styleNameList.add(titleStyleName);
			this.addChild(DisplayObject(uiTitleRenderer));
		}

		/**
		 * @private
		 */
		protected function refreshBackground():void
		{
			this.currentBackgroundSkin = this._backgroundSkin;
			if(!this._isEnabled && this._backgroundDisabledSkin)
			{
				if(this._backgroundSkin !== null)
				{
					this._backgroundSkin.visible = false;
				}
				this.currentBackgroundSkin = this._backgroundDisabledSkin;
			}
			else if(this._backgroundDisabledSkin !== null)
			{
				this._backgroundDisabledSkin.visible = false;
			}
			if(this.currentBackgroundSkin !== null)
			{
				this.currentBackgroundSkin.visible = true;
				
				if(this.currentBackgroundSkin is IMeasureDisplayObject)
				{
					var measureSkin:IMeasureDisplayObject = IMeasureDisplayObject(this.currentBackgroundSkin);
					this._explicitBackgroundWidth = measureSkin.explicitWidth;
					this._explicitBackgroundHeight = measureSkin.explicitHeight;
					this._explicitBackgroundMinWidth = measureSkin.explicitMinWidth;
					this._explicitBackgroundMinHeight = measureSkin.explicitMinHeight;
				}
				else
				{
					this._explicitBackgroundWidth = this.currentBackgroundSkin.width;
					this._explicitBackgroundHeight = this.currentBackgroundSkin.height;
					this._explicitBackgroundMinWidth = this._explicitBackgroundWidth;
					this._explicitBackgroundMinHeight = this._explicitBackgroundHeight;
				}
			}
		}

		/**
		 * @private
		 */
		protected function refreshLayout():void
		{
			this._layout.gap = this._gap;
			this._layout.paddingTop = this._paddingTop + this.calculateExtraOSStatusBarPadding();
			this._layout.paddingBottom = this._paddingBottom;
			this._layout.verticalAlign = this._verticalAlign;
		}

		/**
		 * @private
		 */
		protected function refreshEnabled():void
		{
			this.titleTextRenderer.isEnabled = this._isEnabled;
		}

		/**
		 * @private
		 */
		protected function refreshTitleStyles():void
		{
			for(var propertyName:String in this._titleProperties)
			{
				var propertyValue:Object = this._titleProperties[propertyName];
				this.titleTextRenderer[propertyName] = propertyValue;
			}
		}

		/**
		 * @private
		 */
		protected function calculateExtraOSStatusBarPadding():Number
		{
			if(!this._useExtraPaddingForOSStatusBar)
			{
				return 0;
			}
			//first, we check if it's iOS or not. at this time, we only need to
			//use extra padding on iOS. android and others are fine.
			var os:String = Capabilities.os;
			if(os.indexOf(IOS_NAME_PREFIX) != 0 || parseInt(os.substr(IOS_NAME_PREFIX.length, 1), 10) < STATUS_BAR_MIN_IOS_VERSION)
			{
				return 0;
			}
			//next, we check if the app is full screen or not. if it is full
			//screen, then the status bar isn't visible, and we don't need the
			//extra padding.
			var nativeStage:Stage = Starling.current.nativeStage;
			if(nativeStage.displayState != StageDisplayState.NORMAL)
			{
				return 0;
			}
			
			if(DeviceCapabilities.dpi % IPAD_1X_DPI === 0)
			{
				return IOS_STATUS_BAR_HEIGHT * Math.floor(DeviceCapabilities.dpi / IPAD_1X_DPI) / Starling.current.contentScaleFactor;
			}
			return IOS_STATUS_BAR_HEIGHT * Math.floor(DeviceCapabilities.dpi / IPHONE_1X_DPI) / Starling.current.contentScaleFactor;
		}

		/**
		 * @private
		 */
		protected function layoutBackground():void
		{
			if(!this.currentBackgroundSkin)
			{
				return;
			}
			this.currentBackgroundSkin.width = this.actualWidth;
			this.currentBackgroundSkin.height = this.actualHeight;
		}

		/**
		 * @private
		 */
		protected function layoutLeftItems():void
		{
			for each(var item:DisplayObject in this._leftItems)
			{
				if(item is IValidating)
				{
					IValidating(item).validate();
				}
			}
			HELPER_BOUNDS.x = HELPER_BOUNDS.y = 0;
			HELPER_BOUNDS.scrollX = HELPER_BOUNDS.scrollY = 0;
			HELPER_BOUNDS.explicitWidth = this.actualWidth;
			HELPER_BOUNDS.explicitHeight = this.actualHeight;
			this._layout.horizontalAlign = HorizontalAlign.LEFT;
			this._layout.paddingRight = 0;
			this._layout.paddingLeft = this._paddingLeft;
			this._layout.layout(this._leftItems, HELPER_BOUNDS, HELPER_LAYOUT_RESULT);
			this.leftItemsWidth = HELPER_LAYOUT_RESULT.contentWidth;
			if(this.leftItemsWidth !== this.leftItemsWidth) //isNaN
			{
				this.leftItemsWidth = 0;
			}

		}

		/**
		 * @private
		 */
		protected function layoutRightItems():void
		{
			for each(var item:DisplayObject in this._rightItems)
			{
				if(item is IValidating)
				{
					IValidating(item).validate();
				}
			}
			HELPER_BOUNDS.x = HELPER_BOUNDS.y = 0;
			HELPER_BOUNDS.scrollX = HELPER_BOUNDS.scrollY = 0;
			HELPER_BOUNDS.explicitWidth = this.actualWidth;
			HELPER_BOUNDS.explicitHeight = this.actualHeight;
			this._layout.horizontalAlign = HorizontalAlign.RIGHT;
			this._layout.paddingRight = this._paddingRight;
			this._layout.paddingLeft = 0;
			this._layout.layout(this._rightItems, HELPER_BOUNDS, HELPER_LAYOUT_RESULT);
			this.rightItemsWidth = HELPER_LAYOUT_RESULT.contentWidth;
			if(this.rightItemsWidth !== this.rightItemsWidth) //isNaN
			{
				this.rightItemsWidth = 0;
			}
		}

		/**
		 * @private
		 */
		protected function layoutCenterItems():void
		{
			for each(var item:DisplayObject in this._centerItems)
			{
				if(item is IValidating)
				{
					IValidating(item).validate();
				}
			}
			HELPER_BOUNDS.x = HELPER_BOUNDS.y = 0;
			HELPER_BOUNDS.scrollX = HELPER_BOUNDS.scrollY = 0;
			HELPER_BOUNDS.explicitWidth = this.actualWidth;
			HELPER_BOUNDS.explicitHeight = this.actualHeight;
			this._layout.horizontalAlign = HorizontalAlign.CENTER;
			this._layout.paddingRight = this._paddingRight;
			this._layout.paddingLeft = this._paddingLeft;
			this._layout.layout(this._centerItems, HELPER_BOUNDS, HELPER_LAYOUT_RESULT);
		}

		/**
		 * @private
		 */
		protected function layoutTitle():void
		{
			var hasLeftItems:Boolean = this._leftItems !== null && this._leftItems.length > 0;
			var hasRightItems:Boolean = this._rightItems !== null && this._rightItems.length > 0;
			var hasCenterItems:Boolean = this._centerItems !== null && this._centerItems.length > 0;
			if(this._titleAlign === HorizontalAlign.CENTER && hasCenterItems)
			{
				this.titleTextRenderer.visible = false;
				return;
			}
			if(this._titleAlign === HorizontalAlign.LEFT && hasLeftItems && hasCenterItems)
			{
				this.titleTextRenderer.visible = false;
				return;
			}
			if(this._titleAlign === HorizontalAlign.RIGHT && hasRightItems && hasCenterItems)
			{
				this.titleTextRenderer.visible = false;
				return;
			}
			this.titleTextRenderer.visible = true;
			var calculatedTitleGap:Number = this._titleGap;
			if(calculatedTitleGap !== calculatedTitleGap) //isNaN
			{
				calculatedTitleGap = this._gap;
			}
			var leftOffset:Number = this._paddingLeft;
			if(hasLeftItems)
			{
				//leftItemsWidth already includes padding
				leftOffset = this.leftItemsWidth + calculatedTitleGap;
			}
			var rightOffset:Number = this._paddingRight;
			if(hasRightItems)
			{
				//rightItemsWidth already includes padding
				rightOffset = this.rightItemsWidth + calculatedTitleGap;
			}
			if(this._titleAlign === HorizontalAlign.LEFT)
			{
				var titleMaxWidth:Number = this.actualWidth - leftOffset - rightOffset;
				if(titleMaxWidth < 0)
				{
					titleMaxWidth = 0;
				}
				this.titleTextRenderer.maxWidth = titleMaxWidth;
				this.titleTextRenderer.validate();
				this.titleTextRenderer.x = leftOffset;
			}
			else if(this._titleAlign === HorizontalAlign.RIGHT)
			{
				titleMaxWidth = this.actualWidth - leftOffset - rightOffset;
				if(titleMaxWidth < 0)
				{
					titleMaxWidth = 0;
				}
				this.titleTextRenderer.maxWidth = titleMaxWidth;
				this.titleTextRenderer.validate();
				this.titleTextRenderer.x = this.actualWidth - this.titleTextRenderer.width - rightOffset;
			}
			else //center
			{
				var actualWidthMinusPadding:Number = this.actualWidth - this._paddingLeft - this._paddingRight;
				if(actualWidthMinusPadding < 0)
				{
					actualWidthMinusPadding = 0;
				}
				var actualWidthMinusOffsets:Number = this.actualWidth - leftOffset - rightOffset;
				if(actualWidthMinusOffsets < 0)
				{
					actualWidthMinusOffsets = 0;
				}
				this.titleTextRenderer.maxWidth = actualWidthMinusOffsets;
				this.titleTextRenderer.validate();
				//we try to keep the title centered between the paddings, if
				//possible. however, if the combined width of the left or right
				//items is too large to allow that, we center between the items.
				//this seems to match the behavior on iOS.
				var idealTitlePosition:Number = this._paddingLeft + Math.round((actualWidthMinusPadding - this.titleTextRenderer.width) / 2);
				if(leftOffset > idealTitlePosition ||
					(idealTitlePosition + this.titleTextRenderer.width) > (this.actualWidth - rightOffset))
				{
					this.titleTextRenderer.x = leftOffset + Math.round((actualWidthMinusOffsets - this.titleTextRenderer.width) / 2);
				}
				else
				{
					this.titleTextRenderer.x = idealTitlePosition;
				}
			}
			var paddingTop:Number = this._paddingTop + this.calculateExtraOSStatusBarPadding();
			switch(this._verticalAlign)
			{
				case VerticalAlign.TOP:
				{
					this.titleTextRenderer.y = paddingTop;
					break;
				}
				case VerticalAlign.BOTTOM:
				{
					this.titleTextRenderer.y = this.actualHeight - this._paddingBottom - this.titleTextRenderer.height;
					break;
				}
				default: //center
				{
					this.titleTextRenderer.y = paddingTop + Math.round((this.actualHeight - paddingTop - this._paddingBottom - this.titleTextRenderer.height) / 2);
					break;
				}
			}
		}

		/**
		 * @private
		 */
		protected function header_addedToStageHandler(event:Event):void
		{
			Starling.current.nativeStage.addEventListener("fullScreen", nativeStage_fullScreenHandler);
		}

		/**
		 * @private
		 */
		protected function header_removedFromStageHandler(event:Event):void
		{
			Starling.current.nativeStage.removeEventListener("fullScreen", nativeStage_fullScreenHandler);
		}

		/**
		 * @private
		 */
		protected function nativeStage_fullScreenHandler(event:FullScreenEvent):void
		{
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		/**
		 * @private
		 */
		protected function titleProperties_onChange(proxy:PropertyProxy, propertyName:String):void
		{
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected function item_resizeHandler(event:Event):void
		{
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}
	}
}
