/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.core.FeathersControl;
	import feathers.core.IFocusDisplayObject;
	import feathers.core.PropertyProxy;
	import feathers.core.ToggleGroup;
	import feathers.data.ListCollection;
	import feathers.events.CollectionEventType;
	import feathers.events.FeathersEventType;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.LayoutBoundsResult;
	import feathers.layout.VerticalLayout;
	import feathers.layout.ViewPortBounds;
	import feathers.skins.IStyleProvider;

	import flash.ui.Keyboard;

	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.KeyboardEvent;

	/**
	 * Dispatched when the selected tab changes.
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
	 * A line of tabs (vertical or horizontal), where one may be selected at a
	 * time.
	 *
	 * <p>The following example sets the data provider, selects the second tab,
	 * and listens for when the selection changes:</p>
	 *
	 * <listing version="3.0">
	 * var tabs:TabBar = new TabBar();
	 * tabs.dataProvider = new ListCollection(
	 * [
	 *     { label: "One" },
	 *     { label: "Two" },
	 *     { label: "Three" },
	 * ]);
	 * tabs.selectedIndex = 1;
	 * tabs.addEventListener( Event.CHANGE, tabs_changeHandler );
	 * this.addChild( tabs );</listing>
	 *
	 * @see ../../../help/tab-bar.html How to use the Feathers TabBar component
	 */
	public class TabBar extends FeathersControl implements IFocusDisplayObject
	{
		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_TAB_FACTORY:String = "tabFactory";

		/**
		 * @private
		 */
		private static const DEFAULT_TAB_FIELDS:Vector.<String> = new <String>
		[
			"defaultIcon",
			"upIcon",
			"downIcon",
			"hoverIcon",
			"disabledIcon",
			"defaultSelectedIcon",
			"selectedUpIcon",
			"selectedDownIcon",
			"selectedHoverIcon",
			"selectedDisabledIcon",
			"isEnabled"
		];

		/**
		 * The tabs are displayed in order from left to right.
		 *
		 * @see #direction
		 */
		public static const DIRECTION_HORIZONTAL:String = "horizontal";

		/**
		 * The tabs are displayed in order from top to bottom.
		 *
		 * @see #direction
		 */
		public static const DIRECTION_VERTICAL:String = "vertical";

		/**
		 * The tabs will be aligned horizontally to the left edge of the tab
		 * bar.
		 *
		 * @see #horizontalAlign
		 */
		public static const HORIZONTAL_ALIGN_LEFT:String = "left";

		/**
		 * The tabs will be aligned horizontally to the center of the tab bar.
		 *
		 * @see #horizontalAlign
		 */
		public static const HORIZONTAL_ALIGN_CENTER:String = "center";

		/**
		 * The tabs will be aligned horizontally to the right edge of the tab
		 * bar.
		 *
		 * @see #horizontalAlign
		 */
		public static const HORIZONTAL_ALIGN_RIGHT:String = "right";

		/**
		 * If the direction is vertical, each tab will fill the entire width of
		 * the tab bar, and if the direction is horizontal, the alignment will
		 * behave the same as <code>HORIZONTAL_ALIGN_LEFT</code>.
		 *
		 * @see #horizontalAlign
		 * @see #direction
		 */
		public static const HORIZONTAL_ALIGN_JUSTIFY:String = "justify";

		/**
		 * The tabs will be aligned vertically to the top edge of the tab bar.
		 *
		 * @see #verticalAlign
		 */
		public static const VERTICAL_ALIGN_TOP:String = "top";

		/**
		 * The tabs will be aligned vertically to the middle of the tab bar.
		 *
		 * @see #verticalAlign
		 */
		public static const VERTICAL_ALIGN_MIDDLE:String = "middle";

		/**
		 * The tabs will be aligned vertically to the bottom edge of the tab
		 * bar.
		 *
		 * @see #verticalAlign
		 */
		public static const VERTICAL_ALIGN_BOTTOM:String = "bottom";

		/**
		 * If the direction is horizontal, each tab will fill the entire height
		 * of the tab bar. If the direction is vertical, the alignment will
		 * behave the same as <code>VERTICAL_ALIGN_TOP</code>.
		 *
		 * @see #verticalAlign
		 * @see #direction
		 */
		public static const VERTICAL_ALIGN_JUSTIFY:String = "justify";

		/**
		 * The default value added to the <code>styleNameList</code> of the tabs.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_TAB:String = "feathers-tab-bar-tab";

		/**
		 * The default <code>IStyleProvider</code> for all <code>TabBar</code>
		 * components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * @private
		 */
		protected static function defaultTabFactory():ToggleButton
		{
			return new ToggleButton();
		}

		/**
		 * Constructor.
		 */
		public function TabBar()
		{
			super();
		}

		/**
		 * The value added to the <code>styleNameList</code> of the tabs. This
		 * variable is <code>protected</code> so that sub-classes can customize
		 * the tab style name in their constructors instead of using the default
		 * style name defined by <code>DEFAULT_CHILD_STYLE_NAME_TAB</code>.
		 *
		 * <p>To customize the tab style name without subclassing, see
		 * <code>customTabStyleName</code>.</p>
		 *
		 * @see #customTabStyleName
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var tabStyleName:String = DEFAULT_CHILD_STYLE_NAME_TAB;

		/**
		 * The value added to the <code>styleNameList</code> of the first tab.
		 * This variable is <code>protected</code> so that sub-classes can
		 * customize the first tab style name in their constructors instead of
		 * using the default style name defined by
		 * <code>DEFAULT_CHILD_STYLE_NAME_TAB</code>.
		 *
		 * <p>To customize the first tab name without subclassing, see
		 * <code>customFirstTabName</code>.</p>
		 *
		 * @see #customFirstTabName
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var firstTabStyleName:String = DEFAULT_CHILD_STYLE_NAME_TAB;

		/**
		 * The value added to the <code>styleNameList</code> of the last tab.
		 * This variable is <code>protected</code> so that sub-classes can
		 * customize the last tab style name in their constructors instead of
		 * using the default style name defined by
		 * <code>DEFAULT_CHILD_STYLE_NAME_TAB</code>.
		 *
		 * <p>To customize the last tab name without subclassing, see
		 * <code>customLastTabName</code>.</p>
		 *
		 * @see #customLastTabName
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var lastTabStyleName:String = DEFAULT_CHILD_STYLE_NAME_TAB;

		/**
		 * The toggle group.
		 */
		protected var toggleGroup:ToggleGroup;

		/**
		 * @private
		 */
		protected var activeFirstTab:ToggleButton;

		/**
		 * @private
		 */
		protected var inactiveFirstTab:ToggleButton;

		/**
		 * @private
		 */
		protected var activeLastTab:ToggleButton;

		/**
		 * @private
		 */
		protected var inactiveLastTab:ToggleButton;

		/**
		 * @private
		 */
		protected var _layoutItems:Vector.<DisplayObject> = new <DisplayObject>[];

		/**
		 * @private
		 */
		protected var activeTabs:Vector.<ToggleButton> = new <ToggleButton>[];

		/**
		 * @private
		 */
		protected var inactiveTabs:Vector.<ToggleButton> = new <ToggleButton>[];

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return TabBar.globalStyleProvider;
		}

		/**
		 * @private
		 */
		protected var _dataProvider:ListCollection;

		/**
		 * The collection of data to be displayed with tabs. The default
		 * <em>tab initializer</em> interprets this data to customize the tabs
		 * with various fields available to buttons, including the following:
		 *
		 * <ul>
		 *     <li>label</li>
		 *     <li>defaultIcon</li>
		 *     <li>upIcon</li>
		 *     <li>downIcon</li>
		 *     <li>hoverIcon</li>
		 *     <li>disabledIcon</li>
		 *     <li>defaultSelectedIcon</li>
		 *     <li>selectedUpIcon</li>
		 *     <li>selectedDownIcon</li>
		 *     <li>selectedHoverIcon</li>
		 *     <li>selectedDisabledIcon</li>
		 *     <li>isEnabled</li>
		 * </ul>
		 *
		 * <p>The following example passes in a data provider:</p>
		 *
		 * <listing version="3.0">
		 * list.dataProvider = new ListCollection(
		 * [
		 *     { label: "General", defaultIcon: new Image( generalTexture ) },
		 *     { label: "Security", defaultIcon: new Image( securityTexture ) },
		 *     { label: "Advanced", defaultIcon: new Image( advancedTexture ) },
		 * ]);</listing>
		 *
		 * @default null
		 *
		 * @see #tabInitializer
		 */
		public function get dataProvider():ListCollection
		{
			return this._dataProvider;
		}

		/**
		 * @private
		 */
		public function set dataProvider(value:ListCollection):void
		{
			if(this._dataProvider == value)
			{
				return;
			}
			var oldSelectedIndex:int = this.selectedIndex;
			var oldSelectedItem:Object = this.selectedItem;
			if(this._dataProvider)
			{
				this._dataProvider.removeEventListener(CollectionEventType.ADD_ITEM, dataProvider_addItemHandler);
				this._dataProvider.removeEventListener(CollectionEventType.REMOVE_ITEM, dataProvider_removeItemHandler);
				this._dataProvider.removeEventListener(CollectionEventType.REPLACE_ITEM, dataProvider_replaceItemHandler);
				this._dataProvider.removeEventListener(CollectionEventType.UPDATE_ITEM, dataProvider_updateItemHandler);
				this._dataProvider.removeEventListener(CollectionEventType.UPDATE_ALL, dataProvider_updateAllHandler);
				this._dataProvider.removeEventListener(CollectionEventType.RESET, dataProvider_resetHandler);
			}
			this._dataProvider = value;
			if(this._dataProvider)
			{
				this._dataProvider.addEventListener(CollectionEventType.ADD_ITEM, dataProvider_addItemHandler);
				this._dataProvider.addEventListener(CollectionEventType.REMOVE_ITEM, dataProvider_removeItemHandler);
				this._dataProvider.addEventListener(CollectionEventType.REPLACE_ITEM, dataProvider_replaceItemHandler);
				this._dataProvider.addEventListener(CollectionEventType.UPDATE_ITEM, dataProvider_updateItemHandler);
				this._dataProvider.addEventListener(CollectionEventType.UPDATE_ALL, dataProvider_updateAllHandler);
				this._dataProvider.addEventListener(CollectionEventType.RESET, dataProvider_resetHandler);
			}
			if(!this._dataProvider || this._dataProvider.length == 0)
			{
				this.selectedIndex = -1;
			}
			else
			{
				this.selectedIndex = 0;
			}
			//this ensures that Event.CHANGE will dispatch for selectedItem
			//changing, even if selectedIndex has not changed.
			if(this.selectedIndex == oldSelectedIndex && this.selectedItem != oldSelectedItem)
			{
				this.dispatchEventWith(Event.CHANGE);
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var verticalLayout:VerticalLayout;

		/**
		 * @private
		 */
		protected var horizontalLayout:HorizontalLayout;

		/**
		 * @private
		 */
		protected var _viewPortBounds:ViewPortBounds = new ViewPortBounds();

		/**
		 * @private
		 */
		protected var _layoutResult:LayoutBoundsResult = new LayoutBoundsResult();

		/**
		 * @private
		 */
		protected var _direction:String = DIRECTION_HORIZONTAL;

		[Inspectable(type="String",enumeration="horizontal,vertical")]
		/**
		 * The tab bar layout is either vertical or horizontal.
		 *
		 * <p>In the following example, the tab bar's direction is set to
		 * vertical:</p>
		 *
		 * <listing version="3.0">
		 * tabs.direction = TabBar.DIRECTION_VERTICAL;</listing>
		 *
		 * @default TabBar.DIRECTION_HORIZONTAL
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
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _horizontalAlign:String = HORIZONTAL_ALIGN_JUSTIFY;

		[Inspectable(type="String",enumeration="left,center,right,justify")]
		/**
		 * Determines how the tabs are horizontally aligned within the bounds
		 * of the tab bar (on the x-axis).
		 *
		 * <p>The following example aligns the tabs to the left:</p>
		 *
		 * <listing version="3.0">
		 * tabs.horizontalAlign = TabBar.HORIZONTAL_ALIGN_LEFT;</listing>
		 *
		 * @default TabBar.HORIZONTAL_ALIGN_JUSTIFY
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
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _verticalAlign:String = VERTICAL_ALIGN_JUSTIFY;

		[Inspectable(type="String",enumeration="top,middle,bottom,justify")]
		/**
		 * Determines how the tabs are vertically aligned within the bounds
		 * of the tab bar (on the y-axis).
		 *
		 * <p>The following example aligns the tabs to the top:</p>
		 *
		 * <listing version="3.0">
		 * tabs.verticalAlign = TabBar.VERTICAL_ALIGN_TOP;</listing>
		 *
		 * @default TabBar.VERTICAL_ALIGN_JUSTIFY
		 *
		 * @see #VERTICAL_ALIGN_TOP
		 * @see #VERTICAL_ALIGN_MIDDLE
		 * @see #VERTICAL_ALIGN_BOTTOM
		 * @see #VERTICAL_ALIGN_JUSTIFY
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
		protected var _distributeTabSizes:Boolean = true;

		/**
		 * If <code>true</code>, the tabs will be equally sized in the direction
		 * of the layout. In other words, if the tab bar is horizontal, each tab
		 * will have the same width, and if the tab bar is vertical, each tab
		 * will have the same height. If <code>false</code>, the tabs will be
		 * sized to their ideal dimensions.
		 *
		 * <p>The following example aligns the tabs to the middle without distributing them:</p>
		 *
		 * <listing version="3.0">
		 * tabs.direction = TabBar.DIRECTION_VERTICAL;
		 * tabs.verticalAlign = TabBar.VERTICAL_ALIGN_MIDDLE;
		 * tabs.distributeTabSizes = false;</listing>
		 *
		 * @default true
		 */
		public function get distributeTabSizes():Boolean
		{
			return this._distributeTabSizes;
		}

		/**
		 * @private
		 */
		public function set distributeTabSizes(value:Boolean):void
		{
			if(this._distributeTabSizes == value)
			{
				return;
			}
			this._distributeTabSizes = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _gap:Number = 0;

		/**
		 * Space, in pixels, between tabs.
		 *
		 * <p>In the following example, the tab bar's gap is set to 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * tabs.gap = 20;</listing>
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
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _firstGap:Number = NaN;

		/**
		 * Space, in pixels, between the first two tabs. If <code>NaN</code>,
		 * the default <code>gap</code> property will be used.
		 *
		 * <p>The following example sets the gap between the first and second
		 * tab to a different value than the standard gap:</p>
		 *
		 * <listing version="3.0">
		 * tabs.firstGap = 30;
		 * tabs.gap = 20;</listing>
		 *
		 * @default NaN
		 *
		 * @see #gap
		 * @see #lastGap
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
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _lastGap:Number = NaN;

		/**
		 * Space, in pixels, between the last two tabs. If <code>NaN</code>,
		 * the default <code>gap</code> property will be used.
		 *
		 * <p>The following example sets the gap between the last and next to last
		 * tab to a different value than the standard gap:</p>
		 *
		 * <listing version="3.0">
		 * tabs.lastGap = 30;
		 * tabs.gap = 20;</listing>
		 *
		 * @default NaN
		 *
		 * @see #gap
		 * @see #firstGap
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
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * Quickly sets all padding properties to the same value. The
		 * <code>padding</code> getter always returns the value of
		 * <code>paddingTop</code>, but the other padding values may be
		 * different.
		 *
		 * <p>In the following example, the padding of all sides of the tab bar
		 * is set to 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * tabs.padding = 20;</listing>
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
		 * The minimum space, in pixels, between the tab bar's top edge and the
		 * tabs.
		 *
		 * <p>In the following example, the padding on the top edge of the
		 * tab bar is set to 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * tabs.paddingTop = 20;</listing>
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
		 * The minimum space, in pixels, between the tab bar's right edge and
		 * the tabs.
		 *
		 * <p>In the following example, the padding on the right edge of the
		 * tab bar is set to 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * tabs.paddingRight = 20;</listing>
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
		 * The minimum space, in pixels, between the tab bar's bottom edge and
		 * the tabs.
		 *
		 * <p>In the following example, the padding on the bottom edge of the
		 * tab bar is set to 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * tabs.paddingBottom = 20;</listing>
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
		 * The minimum space, in pixels, between the tab bar's left edge and the
		 * tabs.
		 *
		 * <p>In the following example, the padding on the left edge of the
		 * tab bar is set to 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * tabs.paddingLeft = 20;</listing>
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
		protected var _tabFactory:Function = defaultTabFactory;

		/**
		 * Creates a new tab. A tab must be an instance of <code>ToggleButton</code>.
		 * This factory can be used to change properties on the tabs when they
		 * are first created. For instance, if you are skinning Feathers
		 * components without a theme, you might use this factory to set skins
		 * and other styles on a tab.
		 *
		 * <p>This function is expected to have the following signature:</p>
		 *
		 * <pre>function():ToggleButton</pre>
		 *
		 * <p>In the following example, a custom tab factory is passed to the
		 * tab bar:</p>
		 *
		 * <listing version="3.0">
		 * tabs.tabFactory = function():ToggleButton
		 * {
		 *     var tab:ToggleButton = new ToggleButton();
		 *     tab.defaultSkin = new Image( upTexture );
		 *     tab.defaultSelectedSkin = new Image( selectedTexture );
		 *     tab.downSkin = new Image( downTexture );
		 *     return tab;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.ToggleButton
		 * @see #firstTabFactory
		 * @see #lastTabFactory
		 */
		public function get tabFactory():Function
		{
			return this._tabFactory;
		}

		/**
		 * @private
		 */
		public function set tabFactory(value:Function):void
		{
			if(this._tabFactory == value)
			{
				return;
			}
			this._tabFactory = value;
			this.invalidate(INVALIDATION_FLAG_TAB_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _firstTabFactory:Function;

		/**
		 * Creates a new first tab. If the <code>firstTabFactory</code> is
		 * <code>null</code>, then the tab bar will use the <code>tabFactory</code>.
		 * The first tab must be an instance of <code>ToggleButton</code>. This
		 * factory can be used to change properties on the first tab when it
		 * is first created. For instance, if you are skinning Feathers
		 * components without a theme, you might use this factory to set skins
		 * and other styles on the first tab.
		 *
		 * <p>This function is expected to have the following signature:</p>
		 *
		 * <pre>function():ToggleButton</pre>
		 *
		 * <p>In the following example, a custom first tab factory is passed to the
		 * tab bar:</p>
		 *
		 * <listing version="3.0">
		 * tabs.firstTabFactory = function():ToggleButton
		 * {
		 *     var tab:ToggleButton = new ToggleButton();
		 *     tab.defaultSkin = new Image( upTexture );
		 *     tab.defaultSelectedSkin = new Image( selectedTexture );
		 *     tab.downSkin = new Image( downTexture );
		 *     return tab;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.ToggleButton
		 * @see #tabFactory
		 * @see #lastTabFactory
		 */
		public function get firstTabFactory():Function
		{
			return this._firstTabFactory;
		}

		/**
		 * @private
		 */
		public function set firstTabFactory(value:Function):void
		{
			if(this._firstTabFactory == value)
			{
				return;
			}
			this._firstTabFactory = value;
			this.invalidate(INVALIDATION_FLAG_TAB_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _lastTabFactory:Function;

		/**
		 * Creates a new last tab. If the <code>lastTabFactory</code> is
		 * <code>null</code>, then the tab bar will use the <code>tabFactory</code>.
		 * The last tab must be an instance of <code>Button</code>. This
		 * factory can be used to change properties on the last tab when it
		 * is first created. For instance, if you are skinning Feathers
		 * components without a theme, you might use this factory to set skins
		 * and other styles on the last tab.
		 *
		 * <p>This function is expected to have the following signature:</p>
		 *
		 * <pre>function():ToggleButton</pre>
		 *
		 * <p>In the following example, a custom last tab factory is passed to the
		 * tab bar:</p>
		 *
		 * <listing version="3.0">
		 * tabs.lastTabFactory = function():ToggleButton
		 * {
		 *     var tab:ToggleButton = new Button();
		 *     tab.defaultSkin = new Image( upTexture );
		 *     tab.defaultSelectedSkin = new Image( selectedTexture );
		 *     tab.downSkin = new Image( downTexture );
		 *     return tab;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.ToggleButton
		 * @see #tabFactory
		 * @see #firstTabFactory
		 */
		public function get lastTabFactory():Function
		{
			return this._lastTabFactory;
		}

		/**
		 * @private
		 */
		public function set lastTabFactory(value:Function):void
		{
			if(this._lastTabFactory == value)
			{
				return;
			}
			this._lastTabFactory = value;
			this.invalidate(INVALIDATION_FLAG_TAB_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _tabInitializer:Function = defaultTabInitializer;

		/**
		 * Modifies the properties of an individual tab, using an item from the
		 * data provider. The default initializer will set the tab's label and
		 * icons. A custom tab initializer can be provided to update additional
		 * properties or to use different field names in the data provider.
		 *
		 * <p>This function is expected to have the following signature:</p>
		 * <pre>function( tab:ToggleButton, item:Object ):void</pre>
		 *
		 * <p>In the following example, a custom tab initializer is passed to the
		 * tab bar:</p>
		 *
		 * <listing version="3.0">
		 * tabs.tabInitializer = function( tab:ToggleButton, item:Object ):void
		 * {
		 *     tab.label = item.text;
		 *     tab.defaultIcon = item.icon;
		 * };</listing>
		 *
		 * @see #dataProvider
		 */
		public function get tabInitializer():Function
		{
			return this._tabInitializer;
		}

		/**
		 * @private
		 */
		public function set tabInitializer(value:Function):void
		{
			if(this._tabInitializer == value)
			{
				return;
			}
			this._tabInitializer = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _ignoreSelectionChanges:Boolean = false;

		/**
		 * @private
		 */
		protected var _selectedIndex:int = -1;

		/**
		 * The index of the currently selected tab. Returns -1 if no tab is
		 * selected.
		 *
		 * <p>In the following example, the tab bar's selected index is changed:</p>
		 *
		 * <listing version="3.0">
		 * tabs.selectedIndex = 2;</listing>
		 *
		 * <p>The following example listens for when selection changes and
		 * requests the selected index:</p>
		 *
		 * <listing version="3.0">
		 * function tabs_changeHandler( event:Event ):void
		 * {
		 *     var tabs:TabBar = TabBar( event.currentTarget );
		 *     var index:int = tabs.selectedIndex;
		 *
		 * }
		 * tabs.addEventListener( Event.CHANGE, tabs_changeHandler );</listing>
		 *
		 * @default -1
		 *
		 * @see #selectedItem
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
			if(this._selectedIndex == value)
			{
				return;
			}
			this._selectedIndex = value;
			this.invalidate(INVALIDATION_FLAG_SELECTED);
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * The currently selected item from the data provider. Returns
		 * <code>null</code> if no item is selected.
		 *
		 * <p>In the following example, the tab bar's selected item is changed:</p>
		 *
		 * <listing version="3.0">
		 * tabs.selectedItem = tabs.dataProvider.getItemAt(2);</listing>
		 *
		 * <p>The following example listens for when selection changes and
		 * requests the selected item:</p>
		 *
		 * <listing version="3.0">
		 * function tabs_changeHandler( event:Event ):void
		 * {
		 *     var tabs:TabBar = TabBar( event.currentTarget );
		 *     var item:Object = tabs.selectedItem;
		 *
		 * }
		 * tabs.addEventListener( Event.CHANGE, tabs_changeHandler );</listing>
		 *
		 * @default null
		 *
		 * @see #selectedIndex
		 */
		public function get selectedItem():Object
		{
			var index:int = this.selectedIndex;
			if(!this._dataProvider || index < 0 || index >= this._dataProvider.length)
			{
				return null;
			}
			return this._dataProvider.getItemAt(index);
		}

		/**
		 * @private
		 */
		public function set selectedItem(value:Object):void
		{
			if(!this._dataProvider)
			{
				this.selectedIndex = -1;
				return;
			}
			this.selectedIndex = this._dataProvider.getItemIndex(value);
		}

		/**
		 * @private
		 */
		protected var _customTabStyleName:String;

		/**
		 * A style name to add to all tabs in this tab bar. Typically used by a
		 * theme to provide different styles to different tab bars.
		 *
		 * <p>In the following example, a custom tab style name is provided to
		 * the tab bar:</p>
		 *
		 * <listing version="3.0">
		 * tabs.customTabStyleName = "my-custom-tab";</listing>
		 *
		 * <p>In your theme, you can target this sub-component style name to
		 * provide different styles than the default:</p>
		 *
		 * <listing version="3.0">
		 * getStyleProviderForClass( ToggleButton ).setFunctionForStyleName( "my-custom-tab", setCustomTabStyles );</listing>
		 *
		 * @default null
		 *
		 * @see #DEFAULT_CHILD_STYLE_NAME_TAB
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public function get customTabStyleName():String
		{
			return this._customTabStyleName;
		}

		/**
		 * @private
		 */
		public function set customTabStyleName(value:String):void
		{
			if(this._customTabStyleName == value)
			{
				return;
			}
			this._customTabStyleName = value;
			this.invalidate(INVALIDATION_FLAG_TAB_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _customFirstTabStyleName:String;

		/**
		 * A style name to add to the first tab in this tab bar. Typically used
		 * by a theme to provide different styles to the first tab.
		 *
		 * <p>In the following example, a custom first tab style name is
		 * provided to the tab bar:</p>
		 *
		 * <listing version="3.0">
		 * tabs.customFirstTabStyleName = "my-custom-first-tab";</listing>
		 *
		 * <p>In your theme, you can target this sub-component style name to
		 * provide different styles than the default:</p>
		 *
		 * <listing version="3.0">
		 * getStyleProviderForClass( ToggleButton ).setFunctionForStyleName( "my-custom-first-tab", setCustomFirstTabStyles );</listing>
		 *
		 * @default null
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public function get customFirstTabStyleName():String
		{
			return this._customFirstTabStyleName;
		}

		/**
		 * @private
		 */
		public function set customFirstTabStyleName(value:String):void
		{
			if(this._customFirstTabStyleName == value)
			{
				return;
			}
			this._customFirstTabStyleName = value;
			this.invalidate(INVALIDATION_FLAG_TAB_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _customLastTabStyleName:String;

		/**
		 * A style name to add to the last tab in this tab bar. Typically used
		 * by a theme to provide different styles to the last tab.
		 *
		 * <p>In the following example, a custom last tab style name is provided
		 * to the tab bar:</p>
		 *
		 * <listing version="3.0">
		 * tabs.customLastTabStyleName = "my-custom-last-tab";</listing>
		 *
		 * <p>In your theme, you can target this sub-component style name to
		 * provide different styles than the default:</p>
		 *
		 * <listing version="3.0">
		 * getStyleProviderForClass( ToggleButton ).setFunctionForStyleName( "my-custom-last-tab", setCustomLastTabStyles );</listing>
		 *
		 * @default null
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public function get customLastTabStyleName():String
		{
			return this._customLastTabStyleName;
		}

		/**
		 * @private
		 */
		public function set customLastTabStyleName(value:String):void
		{
			if(this._customLastTabStyleName == value)
			{
				return;
			}
			this._customLastTabStyleName = value;
			this.invalidate(INVALIDATION_FLAG_TAB_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _tabProperties:PropertyProxy;

		/**
		 * An object that stores properties for all of the tab bar's tabs, and
		 * the properties will be passed down to every tab when the tab bar
		 * validates. For a list of available properties, refer to
		 * <a href="ToggleButton.html"><code>feathers.controls.ToggleButton</code></a>.
		 *
		 * <p>These properties are shared by every tab, so anything that cannot
		 * be shared (such as display objects, which cannot be added to multiple
		 * parents) should be passed to tabs using the <code>tabFactory</code>
		 * or in the theme.</p>
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
		 * which is in a <code>List</code>, you can use the following syntax:</p>
		 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * <p>Setting properties in a <code>tabFactory</code> function instead
		 * of using <code>tabProperties</code> will result in better
		 * performance.</p>
		 *
		 * <p>In the following example, the tab bar's tab properties are updated:</p>
		 *
		 * <listing version="3.0">
		 * tabs.tabProperties.iconPosition = Button.ICON_POSITION_RIGHT;</listing>
		 *
		 * @default null
		 *
		 * @see #tabFactory
		 * @see feathers.controls.ToggleButton
		 */
		public function get tabProperties():Object
		{
			if(!this._tabProperties)
			{
				this._tabProperties = new PropertyProxy(childProperties_onChange);
			}
			return this._tabProperties;
		}

		/**
		 * @private
		 */
		public function set tabProperties(value:Object):void
		{
			if(this._tabProperties == value)
			{
				return;
			}
			if(!value)
			{
				value = new PropertyProxy();
			}
			if(!(value is PropertyProxy))
			{
				var newValue:PropertyProxy = new PropertyProxy();
				for(var propertyName:String in value)
				{
					newValue[propertyName] = value[propertyName];
				}
				value = newValue;
			}
			if(this._tabProperties)
			{
				this._tabProperties.removeOnChangeCallback(childProperties_onChange);
			}
			this._tabProperties = PropertyProxy(value);
			if(this._tabProperties)
			{
				this._tabProperties.addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		override public function dispose():void
		{
			//clearing selection now so that the data provider setter won't
			//cause a selection change that triggers events.
			this._selectedIndex = -1;
			this.dataProvider = null;
			super.dispose();
		}

		/**
		 * @private
		 */
		override protected function initialize():void
		{
			this.toggleGroup = new ToggleGroup();
			this.toggleGroup.isSelectionRequired = true;
			this.toggleGroup.addEventListener(Event.CHANGE, toggleGroup_changeHandler);
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			var stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			var stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			var selectionInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SELECTED);
			var tabFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_TAB_FACTORY);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);

			if(dataInvalid || tabFactoryInvalid)
			{
				this.refreshTabs(tabFactoryInvalid);
			}

			if(dataInvalid || tabFactoryInvalid || stylesInvalid)
			{
				this.refreshTabStyles();
			}

			if(dataInvalid || tabFactoryInvalid || selectionInvalid)
			{
				this.commitSelection();
			}

			if(dataInvalid || tabFactoryInvalid || stateInvalid)
			{
				this.commitEnabled();
			}

			if(stylesInvalid)
			{
				this.refreshLayoutStyles();
			}

			this.layoutTabs();
		}

		/**
		 * @private
		 */
		protected function commitSelection():void
		{
			this.toggleGroup.selectedIndex = this._selectedIndex;
		}

		/**
		 * @private
		 */
		protected function commitEnabled():void
		{
			for each(var tab:ToggleButton in this.activeTabs)
			{
				tab.isEnabled &&= this._isEnabled;
			}
		}

		/**
		 * @private
		 */
		protected function refreshTabStyles():void
		{
			for(var propertyName:String in this._tabProperties)
			{
				var propertyValue:Object = this._tabProperties[propertyName];
				for each(var tab:ToggleButton in this.activeTabs)
				{
					tab[propertyName] = propertyValue;
				}
			}
		}

		/**
		 * @private
		 */
		protected function refreshLayoutStyles():void
		{
			if(this._direction == DIRECTION_VERTICAL)
			{
				if(this.horizontalLayout)
				{
					this.horizontalLayout = null;
				}
				if(!this.verticalLayout)
				{
					this.verticalLayout = new VerticalLayout();
					this.verticalLayout.useVirtualLayout = false;
				}
				this.verticalLayout.distributeHeights = this._distributeTabSizes;
				this.verticalLayout.horizontalAlign = this._horizontalAlign;
				this.verticalLayout.verticalAlign = (this._verticalAlign == VERTICAL_ALIGN_JUSTIFY) ? VERTICAL_ALIGN_TOP : this._verticalAlign;
				this.verticalLayout.gap = this._gap;
				this.verticalLayout.firstGap = this._firstGap;
				this.verticalLayout.lastGap = this._lastGap;
				this.verticalLayout.paddingTop = this._paddingTop;
				this.verticalLayout.paddingRight = this._paddingRight;
				this.verticalLayout.paddingBottom = this._paddingBottom;
				this.verticalLayout.paddingLeft = this._paddingLeft;
			}
			else //horizontal
			{
				if(this.verticalLayout)
				{
					this.verticalLayout = null;
				}
				if(!this.horizontalLayout)
				{
					this.horizontalLayout = new HorizontalLayout();
					this.horizontalLayout.useVirtualLayout = false;
				}
				this.horizontalLayout.distributeWidths = this._distributeTabSizes;
				this.horizontalLayout.horizontalAlign = (this._horizontalAlign == HORIZONTAL_ALIGN_JUSTIFY) ? HORIZONTAL_ALIGN_LEFT : this._horizontalAlign;
				this.horizontalLayout.verticalAlign = this._verticalAlign;
				this.horizontalLayout.gap = this._gap;
				this.horizontalLayout.firstGap = this._firstGap;
				this.horizontalLayout.lastGap = this._lastGap;
				this.horizontalLayout.paddingTop = this._paddingTop;
				this.horizontalLayout.paddingRight = this._paddingRight;
				this.horizontalLayout.paddingBottom = this._paddingBottom;
				this.horizontalLayout.paddingLeft = this._paddingLeft;
			}
		}

		/**
		 * @private
		 */
		protected function defaultTabInitializer(tab:ToggleButton, item:Object):void
		{
			if(item is Object)
			{
				if(item.hasOwnProperty("label"))
				{
					tab.label = item.label;
				}
				else
				{
					tab.label = item.toString();
				}
				for each(var field:String in DEFAULT_TAB_FIELDS)
				{
					if(item.hasOwnProperty(field))
					{
						tab[field] = item[field];
					}
				}
			}
			else
			{
				tab.label = "";
			}

		}

		/**
		 * @private
		 */
		protected function refreshTabs(isFactoryInvalid:Boolean):void
		{
			var oldIgnoreSelectionChanges:Boolean = this._ignoreSelectionChanges;
			this._ignoreSelectionChanges = true;
			var oldSelectedIndex:int = this.toggleGroup.selectedIndex;
			this.toggleGroup.removeAllItems();
			var temp:Vector.<ToggleButton> = this.inactiveTabs;
			this.inactiveTabs = this.activeTabs;
			this.activeTabs = temp;
			this.activeTabs.length = 0;
			this._layoutItems.length = 0;
			temp = null;
			if(isFactoryInvalid)
			{
				this.clearInactiveTabs();
			}
			else
			{
				if(this.activeFirstTab)
				{
					this.inactiveTabs.shift();
				}
				this.inactiveFirstTab = this.activeFirstTab;

				if(this.activeLastTab)
				{
					this.inactiveTabs.pop();
				}
				this.inactiveLastTab = this.activeLastTab;
			}
			this.activeFirstTab = null;
			this.activeLastTab = null;

			var pushIndex:int = 0;
			var itemCount:int = this._dataProvider ? this._dataProvider.length : 0;
			var lastItemIndex:int = itemCount - 1;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:Object = this._dataProvider.getItemAt(i);
				if(i == 0)
				{
					var tab:ToggleButton = this.activeFirstTab = this.createFirstTab(item);
				}
				else if(i == lastItemIndex)
				{
					tab = this.activeLastTab = this.createLastTab(item);
				}
				else
				{
					tab = this.createTab(item);
				}
				this.toggleGroup.addItem(tab);
				this.activeTabs[pushIndex] = tab;
				this._layoutItems[pushIndex] = tab;
				pushIndex++;
			}

			this.clearInactiveTabs();
			this._ignoreSelectionChanges = oldIgnoreSelectionChanges;
			if(oldSelectedIndex >= 0)
			{
				var newSelectedIndex:int = this.activeTabs.length - 1;
				if(oldSelectedIndex < newSelectedIndex)
				{
					newSelectedIndex = oldSelectedIndex;
				}
				//removing all items from the ToggleGroup clears the selection,
				//so we need to set it back to the old value (or a new clamped
				//value). we want the change event to dispatch only if the old
				//value and the new value don't match.
				this._ignoreSelectionChanges = oldSelectedIndex == newSelectedIndex;
				this.toggleGroup.selectedIndex = newSelectedIndex;
				this._ignoreSelectionChanges = oldIgnoreSelectionChanges;
			}
		}

		/**
		 * @private
		 */
		protected function clearInactiveTabs():void
		{
			var itemCount:int = this.inactiveTabs.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var tab:ToggleButton = this.inactiveTabs.shift();
				this.destroyTab(tab);
			}

			if(this.inactiveFirstTab)
			{
				this.destroyTab(this.inactiveFirstTab);
				this.inactiveFirstTab = null;
			}

			if(this.inactiveLastTab)
			{
				this.destroyTab(this.inactiveLastTab);
				this.inactiveLastTab = null;
			}
		}

		/**
		 * @private
		 */
		protected function createFirstTab(item:Object):ToggleButton
		{
			if(this.inactiveFirstTab)
			{
				var tab:ToggleButton = this.inactiveFirstTab;
				this.inactiveFirstTab = null;
			}
			else
			{
				var factory:Function = this._firstTabFactory != null ? this._firstTabFactory : this._tabFactory;
				tab = ToggleButton(factory());
				if(this._customFirstTabStyleName)
				{
					tab.styleNameList.add(this._customFirstTabStyleName);
				}
				else if(this._customTabStyleName)
				{
					tab.styleNameList.add(this._customTabStyleName);
				}
				else
				{
					tab.styleNameList.add(this.firstTabStyleName);
				}
				tab.isToggle = true;
				this.addChild(tab);
			}
			this._tabInitializer(tab, item);
			return tab;
		}

		/**
		 * @private
		 */
		protected function createLastTab(item:Object):ToggleButton
		{
			if(this.inactiveLastTab)
			{
				var tab:ToggleButton = this.inactiveLastTab;
				this.inactiveLastTab = null;
			}
			else
			{
				var factory:Function = this._lastTabFactory != null ? this._lastTabFactory : this._tabFactory;
				tab = ToggleButton(factory());
				if(this._customLastTabStyleName)
				{
					tab.styleNameList.add(this._customLastTabStyleName);
				}
				else if(this._customTabStyleName)
				{
					tab.styleNameList.add(this._customTabStyleName);
				}
				else
				{
					tab.styleNameList.add(this.lastTabStyleName);
				}
				tab.isToggle = true;
				this.addChild(tab);
			}
			this._tabInitializer(tab, item);
			return tab;
		}

		/**
		 * @private
		 */
		protected function createTab(item:Object):ToggleButton
		{
			if(this.inactiveTabs.length == 0)
			{
				var tab:ToggleButton = this._tabFactory();
				if(this._customTabStyleName)
				{
					tab.styleNameList.add(this._customTabStyleName);
				}
				else
				{
					tab.styleNameList.add(this.tabStyleName);
				}
				tab.isToggle = true;
				this.addChild(tab);
			}
			else
			{
				tab = this.inactiveTabs.shift();
			}
			this._tabInitializer(tab, item);
			return tab;
		}

		/**
		 * @private
		 */
		protected function destroyTab(tab:ToggleButton):void
		{
			this.toggleGroup.removeItem(tab);
			this.removeChild(tab, true);
		}

		/**
		 * @private
		 */
		protected function layoutTabs():void
		{
			this._viewPortBounds.x = 0;
			this._viewPortBounds.y = 0;
			this._viewPortBounds.scrollX = 0;
			this._viewPortBounds.scrollY = 0;
			this._viewPortBounds.explicitWidth = this.explicitWidth;
			this._viewPortBounds.explicitHeight = this.explicitHeight;
			this._viewPortBounds.minWidth = this._minWidth;
			this._viewPortBounds.minHeight = this._minHeight;
			this._viewPortBounds.maxWidth = this._maxWidth;
			this._viewPortBounds.maxHeight = this._maxHeight;
			if(this.verticalLayout)
			{
				this.verticalLayout.layout(this._layoutItems, this._viewPortBounds, this._layoutResult);
			}
			else if(this.horizontalLayout)
			{
				this.horizontalLayout.layout(this._layoutItems, this._viewPortBounds, this._layoutResult);
			}
			this.setSizeInternal(this._layoutResult.contentWidth, this._layoutResult.contentHeight, false);
			//final validation to avoid juggler next frame issues
			for each(var tab:ToggleButton in this.activeTabs)
			{
				tab.validate();
			}
		}

		/**
		 * @private
		 */
		override public function showFocus():void
		{
			if(!this._hasFocus)
			{
				return;
			}

			this._showFocus = true;
			this.showFocusedTab();
			this.invalidate(INVALIDATION_FLAG_FOCUS);
		}

		/**
		 * @private
		 */
		override public function hideFocus():void
		{
			if(!this._hasFocus)
			{
				return;
			}
			this._showFocus = false;
			this.hideFocusedTab();
			this.invalidate(INVALIDATION_FLAG_FOCUS);
		}

		/**
		 * @private
		 */
		protected function hideFocusedTab():void
		{
			if(this._focusedTabIndex < 0)
			{
				return;
			}
			var focusedTab:ToggleButton = this.activeTabs[this._focusedTabIndex];
			focusedTab.hideFocus();
		}

		/**
		 * @private
		 */
		protected function showFocusedTab():void
		{
			if(!this._showFocus || this._focusedTabIndex < 0)
			{
				return;
			}
			var tab:ToggleButton = this.activeTabs[this._focusedTabIndex];
			tab.showFocus();
		}

		/**
		 * @private
		 */
		protected function focusedTabFocusIn():void
		{
			if(this._focusedTabIndex < 0)
			{
				return;
			}
			var tab:ToggleButton = this.activeTabs[this._focusedTabIndex];
			tab.dispatchEventWith(FeathersEventType.FOCUS_IN);
		}

		/**
		 * @private
		 */
		protected function focusedTabFocusOut():void
		{
			if(this._focusedTabIndex < 0)
			{
				return;
			}
			var tab:ToggleButton = this.activeTabs[this._focusedTabIndex];
			tab.dispatchEventWith(FeathersEventType.FOCUS_OUT);
		}

		/**
		 * @private
		 */
		protected function childProperties_onChange(proxy:PropertyProxy, name:String):void
		{
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		override protected function focusInHandler(event:Event):void
		{
			super.focusInHandler(event);
			this._focusedTabIndex = this._selectedIndex;
			this.focusedTabFocusIn();
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
		}

		/**
		 * @private
		 */
		override protected function focusOutHandler(event:Event):void
		{
			super.focusOutHandler(event);
			this.hideFocusedTab();
			this.focusedTabFocusOut();
			this.stage.removeEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
		}
		
		protected var _focusedTabIndex:int = -1;

		/**
		 * @private
		 */
		protected function stage_keyDownHandler(event:KeyboardEvent):void
		{
			if(!this._isEnabled)
			{
				return;
			}
			if(!this._dataProvider || this._dataProvider.length === 0)
			{
				return;
			}
			var newFocusedTabIndex:int = this._focusedTabIndex;
			var maxFocusedTabIndex:int = this._dataProvider.length - 1;
			if(event.keyCode == Keyboard.HOME)
			{
				this.selectedIndex = newFocusedTabIndex = 0;
			}
			else if(event.keyCode == Keyboard.END)
			{
				this.selectedIndex = newFocusedTabIndex = maxFocusedTabIndex;
			}
			else if(event.keyCode == Keyboard.PAGE_UP)
			{
				newFocusedTabIndex--;
				if(newFocusedTabIndex < 0)
				{
					newFocusedTabIndex = maxFocusedTabIndex;
				}
				this.selectedIndex = newFocusedTabIndex;
			}
			else if(event.keyCode == Keyboard.PAGE_DOWN)
			{
				newFocusedTabIndex++;
				if(newFocusedTabIndex > maxFocusedTabIndex)
				{
					newFocusedTabIndex = 0;
				}
				this.selectedIndex = newFocusedTabIndex;
			}
			else if(event.keyCode === Keyboard.UP || event.keyCode === Keyboard.LEFT)
			{
				newFocusedTabIndex--;
				if(newFocusedTabIndex < 0)
				{
					newFocusedTabIndex = maxFocusedTabIndex;
				}
			}
			else if(event.keyCode === Keyboard.DOWN || event.keyCode === Keyboard.RIGHT)
			{
				newFocusedTabIndex++;
				if(newFocusedTabIndex > maxFocusedTabIndex)
				{
					newFocusedTabIndex = 0;
				}
			}

			if(newFocusedTabIndex >= 0 && newFocusedTabIndex !== this._focusedTabIndex)
			{
				this.hideFocusedTab();
				this.focusedTabFocusOut();
				this._focusedTabIndex = newFocusedTabIndex;
				this.focusedTabFocusIn();
				this.showFocusedTab();
			}
		}

		/**
		 * @private
		 */
		protected function toggleGroup_changeHandler(event:Event):void
		{
			if(this._ignoreSelectionChanges)
			{
				return;
			}
			this.selectedIndex = this.toggleGroup.selectedIndex;
		}

		/**
		 * @private
		 */
		protected function dataProvider_addItemHandler(event:Event, index:int):void
		{
			if(this._selectedIndex >= index)
			{
				//we're keeping the same selected item, but the selected index
				//will change, so we need to manually dispatch the change event
				this.selectedIndex += 1;
				this.invalidate(INVALIDATION_FLAG_SELECTED);
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected function dataProvider_removeItemHandler(event:Event, index:int):void
		{
			if(this._selectedIndex > index)
			{
				//the same item is selected, but its index has changed.
				this.selectedIndex -= 1;
			}
			else if(this._selectedIndex == index)
			{
				var oldIndex:int = this._selectedIndex;
				var newIndex:int = oldIndex;
				var maxIndex:int = this._dataProvider.length - 1;
				if(newIndex > maxIndex)
				{
					newIndex = maxIndex;
				}
				if(oldIndex == newIndex)
				{
					//we're keeping the same selected index, but the selected
					//item will change, so we need to manually dispatch the
					//change event
					this.invalidate(INVALIDATION_FLAG_SELECTED);
					this.dispatchEventWith(Event.CHANGE);
				}
				else
				{
					//we're selecting both a different index and a different
					//item, so we'll just call the selectedIndex setter
					this.selectedIndex = newIndex;
				}
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected function dataProvider_resetHandler(event:Event):void
		{
			if(this._dataProvider.length > 0)
			{
				//the data provider has changed drastically. we should reset the
				//selection to the first item.
				if(this._selectedIndex != 0)
				{
					this.selectedIndex = 0;
				}
				else
				{
					//we're keeping the same selected index, but the selected
					//item will change, so we need to manually dispatch the
					//change event
					this.invalidate(INVALIDATION_FLAG_SELECTED);
					this.dispatchEventWith(Event.CHANGE);
				}
			}
			else if(this._selectedIndex >= 0)
			{
				this.selectedIndex = -1;
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected function dataProvider_replaceItemHandler(event:Event, index:int):void
		{
			if(this._selectedIndex == index)
			{
				//we're keeping the same selected index, but the selected
				//item will change, so we need to manually dispatch the
				//change event
				this.invalidate(INVALIDATION_FLAG_SELECTED);
				this.dispatchEventWith(Event.CHANGE);
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected function dataProvider_updateItemHandler(event:Event, index:int):void
		{
			//no need to dispatch a change event. the index and the item are the
			//same. the item's properties have changed, but that doesn't require
			//a change event.
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected function dataProvider_updateAllHandler(event:Event):void
		{
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
	}
}
