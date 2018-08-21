/*
Feathers
Copyright 2012-2018 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.core.FeathersControl;
	import feathers.core.IFocusDisplayObject;
	import feathers.core.IMeasureDisplayObject;
	import feathers.core.ITextBaselineControl;
	import feathers.core.IValidating;
	import feathers.core.PropertyProxy;
	import feathers.core.ToggleGroup;
	import feathers.data.IListCollection;
	import feathers.dragDrop.DragData;
	import feathers.dragDrop.DragDropManager;
	import feathers.dragDrop.IDragSource;
	import feathers.dragDrop.IDropTarget;
	import feathers.events.CollectionEventType;
	import feathers.events.DragDropEvent;
	import feathers.events.ExclusiveTouch;
	import feathers.events.FeathersEventType;
	import feathers.layout.Direction;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.LayoutBoundsResult;
	import feathers.layout.VerticalAlign;
	import feathers.layout.VerticalLayout;
	import feathers.layout.ViewPortBounds;
	import feathers.skins.IStyleProvider;

	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;

	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.Pool;

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
	 * @see #style:customTabStyleName
	 * @see #style:customLastTabStyleName
	 */
	[Style(name="customFirstTabStyleName",type="String")]

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
	 * @see #style:customTabStyleName
	 * @see #style:customFirstTabStyleName
	 */
	[Style(name="customLastTabStyleName",type="String")]

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
	 * @see #style:customFirstTabStyleName
	 * @see #style:customLastTabStyleName
	 */
	[Style(name="customTabStyleName",type="String")]

	/**
	 * The tab bar layout is either vertical or horizontal.
	 *
	 * <p>In the following example, the tab bar's direction is set to
	 * vertical:</p>
	 *
	 * <listing version="3.0">
	 * tabs.direction = Direction.VERTICAL;</listing>
	 * 
	 * <p><strong>Note:</strong> The <code>Direction.NONE</code>
	 * constant is not supported.</p>
	 *
	 * @default feathers.layout.Direction.HORIZONTAL
	 *
	 * @see feathers.layout.Direction#HORIZONTAL
	 * @see feathers.layout.Direction#VERTICAL
	 */
	[Style(name="direction",type="String")]

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
	 * tabs.direction = Direction.VERTICAL;
	 * tabs.verticalAlign = VerticalAlign.MIDDLE;
	 * tabs.distributeTabSizes = false;</listing>
	 *
	 * @default true
	 */
	[Style(name="distributeTabSizes",type="Boolean")]

	/**
	 * A skin to display when dragging one an item to indicate where it can be
	 * dropped.
	 *
	 * <p>In the following example, the tab bar's drop indicator is provided:</p>
	 *
	 * <listing version="3.0">
	 * tabs.dropIndicatorSkin = new Image( texture );</listing>
	 *
	 * @default null
	 */
	[Style(name="dropIndicatorSkin",type="starling.display.DisplayObject")]

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
	 * @see #style:gap
	 * @see #style:lastGap
	 */
	[Style(name="firstGap",type="Number")]

	/**
	 * Space, in pixels, between tabs.
	 *
	 * <p>In the following example, the tab bar's gap is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * tabs.gap = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:firstGap
	 * @see #style:lastGap
	 */
	[Style(name="gap",type="Number")]

	/**
	 * Determines how the tabs are horizontally aligned within the bounds
	 * of the tab bar (on the x-axis).
	 *
	 * <p>The following example aligns the tabs to the left:</p>
	 *
	 * <listing version="3.0">
	 * tabs.horizontalAlign = HorizontalAlign.LEFT;</listing>
	 *
	 * @default feathers.layout.HorizontalAlign.JUSTIFY
	 *
	 * @see feathers.layout.HorizontalAlign#LEFT
	 * @see feathers.layout.HorizontalAlign#CENTER
	 * @see feathers.layout.HorizontalAlign#RIGHT
	 * @see feathers.layout.HorizontalAlign#JUSTIFY
	 */
	[Style(name="horizontalAlign",type="String")]

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
	 * @see #style:gap
	 * @see #style:firstGap
	 */
	[Style(name="lastGap",type="Number")]

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
	 * @see #style:paddingTop
	 * @see #style:paddingRight
	 * @see #style:paddingBottom
	 * @see #style:paddingLeft
	 */
	[Style(name="padding",type="Number")]

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
	 *
	 * @see #style:padding
	 */
	[Style(name="paddingTop",type="Number")]

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
	 *
	 * @see #style:padding
	 */
	[Style(name="paddingRight",type="Number")]

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
	 *
	 * @see #style:padding
	 */
	[Style(name="paddingBottom",type="Number")]

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
	 *
	 * @see #style:padding
	 */
	[Style(name="paddingLeft",type="Number")]

	/**
	 * The time, in seconds, of the animation that changes the position and
	 * size of the <code>selectionSkin</code> skin when the selected
	 * tab changes.
	 *
	 * <p>The following example customizes the duration to 500ms:</p>
	 *
	 * <listing version="3.0">
	 * tabs.selectionChangeDuration = 0.5;</listing>
	 *
	 * @default 0.25
	 *
	 * @see #style:selectionSkin
	 * @see #style:selectionChangeEase
	 */
	[Style(name="selectionChangeDuration",type="Number")]

	/**
	 * The easing function used for moving and resizing the
	 * <code>selectionSkin</code> when the selected tab changes.
	 *
	 * <p>In the following example, the ease of the animation that moves
	 * the <code>selectionSkin</code> is customized:</p>
	 *
	 * <listing version="3.0">
	 * tabs.selectionChangeEase = Transitions.EASE_IN_OUT;</listing>
	 *
	 * @default starling.animation.Transitions.EASE_OUT
	 *
	 * @see http://doc.starling-framework.org/core/starling/animation/Transitions.html starling.animation.Transitions
	 * @see #style:selectionSkin
	 * @see #style:selectionChangeDuration
	 */
	[Style(name="selectionChangeEase",type="Object")]

	/**
	 * A skin displayed over the selected tab. Its position is animated when
	 * the selection changes.
	 *
	 * <p>The following example passes the tab bar a selection skin:</p>
	 *
	 * <listing version="3.0">
	 * var skin:Image = new Image(texture)
	 * skin.scale9Grid = new Rectangle(1, 2, 4, 4);
	 * tabs.selectionSkin = skin;</listing>
	 *
	 * @default null
	 *
	 * @see #style:selectionChangeDuration
	 * @see #style:selectionChangeEase
	 */
	[Style(name="selectionSkin",type="starling.display.DisplayObject")]

	/**
	 * Determines how the tabs are vertically aligned within the bounds
	 * of the tab bar (on the y-axis).
	 *
	 * <p>The following example aligns the tabs to the top:</p>
	 *
	 * <listing version="3.0">
	 * tabs.verticalAlign = VerticalAlign.TOP;</listing>
	 *
	 * @default feathers.layout.VerticalAlign.JUSTIFY
	 *
	 * @see feathers.layout.VerticalAlign#TOP
	 * @see feathers.layout.VerticalAlign#MIDDLE
	 * @see feathers.layout.VerticalAlign#BOTTOM
	 * @see feathers.layout.VerticalAlign#JUSTIFY
	 */
	[Style(name="verticalAlign",type="String")]

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
	 * @see #selectedItem
	 * @see #selectedIndex
	 *
	 * @eventType starling.events.Event.CHANGE
	 */
	[Event(name="change",type="starling.events.Event")]

	/**
	 * Dispatched when one of the tabs is triggered. The <code>data</code>
	 * property of the event contains the item from the data provider that is
	 * associated with the tab that was triggered.
	 *
	 * <p>The following example listens to <code>Event.TRIGGERED</code> on the
	 * tab bar:</p>
	 *
	 * <listing version="3.0">
	 * tabs.dataProvider = new ArrayCollection(
	 * [
	 *     { label: "1" },
	 *     { label: "2" },
	 *     { label: "3" },
	 * ]);
	 * tabs.addEventListener( Event.TRIGGERED, function( event:Event, data:Object ):void
	 * {
	 *    trace( "The tab with label \"" + data.label + "\" was triggered." );
	 * }</listing>
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>The item associated with the tab
	 *   that was triggered.</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @eventType starling.events.Event.TRIGGERED
	 */
	[Event(name="triggered", type="starling.events.Event")]

	/**
	 * A line of tabs (vertical or horizontal), where one may be selected at a
	 * time.
	 *
	 * <p>The following example sets the data provider, selects the second tab,
	 * and listens for when the selection changes:</p>
	 *
	 * <listing version="3.0">
	 * var tabs:TabBar = new TabBar();
	 * tabs.dataProvider = new ArrayCollection(
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
	 *
	 * @productversion Feathers 1.0.0
	 */
	public class TabBar extends FeathersControl implements IFocusDisplayObject, ITextBaselineControl, IDragSource, IDropTarget
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
			"upIcon",
			"downIcon",
			"hoverIcon",
			"disabledIcon",
			"defaultSelectedIcon",
			"selectedUpIcon",
			"selectedDownIcon",
			"selectedHoverIcon",
			"selectedDisabledIcon",
			"name"
		];

		/**
		 * @private
		 */
		protected static const DEFAULT_DRAG_FORMAT:String = "feathers-tab-bar-item";

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
		 * @see #style:customTabStyleName
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
		 * <code>customFirstTabStyleName</code>.</p>
		 *
		 * @see #style:customFirstTabStyleName
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
		 * <code>customLastTabStyleName</code>.</p>
		 *
		 * @see #style:customLastTabStyleName
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
		protected var _tabToItem:Dictionary = new Dictionary(true);

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
		protected var _dataProvider:IListCollection;

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
		 *     <li>name</li>
		 * </ul>
		 *
		 * <p>The following example passes in a data provider:</p>
		 *
		 * <listing version="3.0">
		 * list.dataProvider = new ArrayCollection(
		 * [
		 *     { label: "General", defaultIcon: new Image( generalTexture ) },
		 *     { label: "Security", defaultIcon: new Image( securityTexture ) },
		 *     { label: "Advanced", defaultIcon: new Image( advancedTexture ) },
		 * ]);</listing>
		 *
		 * @default null
		 *
		 * @see #tabInitializer
		 * @see feathers.data.ArrayCollection
		 * @see feathers.data.VectorCollection
		 * @see feathers.data.XMLListCollection
		 */
		public function get dataProvider():IListCollection
		{
			return this._dataProvider;
		}

		/**
		 * @private
		 */
		public function set dataProvider(value:IListCollection):void
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
				this._dataProvider.removeEventListener(CollectionEventType.REMOVE_ALL, dataProvider_removeAllHandler);
				this._dataProvider.removeEventListener(CollectionEventType.REPLACE_ITEM, dataProvider_replaceItemHandler);
				this._dataProvider.removeEventListener(CollectionEventType.FILTER_CHANGE, dataProvider_filterChangeHandler);
				this._dataProvider.removeEventListener(CollectionEventType.SORT_CHANGE, dataProvider_sortChangeHandler);
				this._dataProvider.removeEventListener(CollectionEventType.UPDATE_ITEM, dataProvider_updateItemHandler);
				this._dataProvider.removeEventListener(CollectionEventType.UPDATE_ALL, dataProvider_updateAllHandler);
				this._dataProvider.removeEventListener(CollectionEventType.RESET, dataProvider_resetHandler);
			}
			this._dataProvider = value;
			if(this._dataProvider)
			{
				this._dataProvider.addEventListener(CollectionEventType.ADD_ITEM, dataProvider_addItemHandler);
				this._dataProvider.addEventListener(CollectionEventType.REMOVE_ITEM, dataProvider_removeItemHandler);
				this._dataProvider.addEventListener(CollectionEventType.REMOVE_ALL, dataProvider_removeAllHandler);
				this._dataProvider.addEventListener(CollectionEventType.REPLACE_ITEM, dataProvider_replaceItemHandler);
				this._dataProvider.addEventListener(CollectionEventType.FILTER_CHANGE, dataProvider_filterChangeHandler);
				this._dataProvider.addEventListener(CollectionEventType.SORT_CHANGE, dataProvider_sortChangeHandler);
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
		protected var _direction:String = Direction.HORIZONTAL;

		[Inspectable(type="String",enumeration="horizontal,vertical")]
		/**
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._direction === value)
			{
				return;
			}
			this._direction = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _horizontalAlign:String = HorizontalAlign.JUSTIFY;

		[Inspectable(type="String",enumeration="left,center,right,justify")]
		/**
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._horizontalAlign === value)
			{
				return;
			}
			this._horizontalAlign = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _verticalAlign:String = VerticalAlign.JUSTIFY;

		[Inspectable(type="String",enumeration="top,middle,bottom,justify")]
		/**
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._verticalAlign === value)
			{
				return;
			}
			this._verticalAlign = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _selectionSkin:DisplayObject;

		/**
		 * @private
		 */
		public function get selectionSkin():DisplayObject
		{
			return this._selectionSkin;
		}

		/**
		 * @private
		 */
		public function set selectionSkin(value:DisplayObject):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				if(value !== null)
				{
					value.dispose();
				}
				return;
			}
			if(this._selectionSkin === value)
			{
				return;
			}
			if(this._selectionSkin !== null &&
				this._selectionSkin.parent === this)
			{
				this._selectionSkin.removeFromParent(false);
			}
			this._selectionSkin = value;
			if(this._selectionSkin !== null)
			{
				this._selectionSkin.touchable = false;
				this.addChild(this._selectionSkin);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _selectionChangeTween:Tween;

		/**
		 * @private
		 */
		protected var _selectionChangeDuration:Number = 0.25;

		/**
		 * @private
		 */
		public function get selectionChangeDuration():Number
		{
			return this._selectionChangeDuration;
		}

		/**
		 * @private
		 */
		public function set selectionChangeDuration(value:Number):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			this._selectionChangeDuration = value;
		}

		/**
		 * @private
		 */
		protected var _selectionChangeEase:Object = Transitions.EASE_OUT;

		/**
		 * @private
		 */
		public function get selectionChangeEase():Object
		{
			return this._selectionChangeEase;
		}

		/**
		 * @private
		 */
		public function set selectionChangeEase(value:Object):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			this._selectionChangeEase = value;
		}

		/**
		 * @private
		 */
		protected var _distributeTabSizes:Boolean = true;

		/**
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._distributeTabSizes === value)
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
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
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
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
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
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._lastGap == value)
			{
				return;
			}
			this._lastGap = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
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
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
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
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
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
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
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
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
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
		 * Creates each tab. A tab must be an instance of
		 * <code>ToggleButton</code>. This factory can be used to change
		 * properties on the tabs when they are first created. For instance, if
		 * you are skinning Feathers components without a theme, you might use
		 * this factory to set skins and other styles on a tab.
		 * 
		 * <p>Optionally, the first tab and the last tab may be different than
		 * the other tabs in the middle. Use the <code>firstTabFactory</code>
		 * and/or the <code>lastTabFactory</code> to customize one or both of
		 * these tabs.</p> 
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
		 * If not <code>null</code>, creates the first tab. If the
		 * <code>firstTabFactory</code> is <code>null</code>, then the tab bar
		 * will use the <code>tabFactory</code>. The first tab must be an
		 * instance of <code>ToggleButton</code>. This factory can be used to
		 * change properties on the first tab when it is initially created. For
		 * instance, if you are skinning Feathers components without a theme,
		 * you might use this factory to set skins and other styles on the first
		 * tab.
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
		 * If not <code>null</code>, creates the last tab. If the
		 * <code>lastTabFactory</code> is <code>null</code>, then the tab bar
		 * will use the <code>tabFactory</code>. The last tab must be an
		 * instance of <code>ToggleButton</code>. This factory can be used to
		 * change properties on the last tab when it is initially created. For
		 * instance, if you are skinning Feathers components without a theme,
		 * you might use this factory to set skins and other styles on the last
		 * tab.
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
		 * @see #tabReleaser
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
		protected var _tabReleaser:Function = defaultTabReleaser;

		/**
		 * Resets the properties of an individual tab, using the item from the
		 * data provider that was associated with the tab.
		 *
		 * <p>This function is expected to have one of the following signatures:</p>
		 * <pre>function( tab:ToggleButton ):void</pre>
		 * <pre>function( tab:ToggleButton, oldItem:Object ):void</pre>
		 *
		 * <p>In the following example, a custom tab releaser is passed to the
		 * tab bar:</p>
		 *
		 * <listing version="3.0">
		 * tabs.tabReleaser = function( tab:ToggleButton, oldItem:Object ):void
		 * {
		 *     tab.label = null;
		 *     tab.defaultIcon = null;
		 * };</listing>
		 *
		 * @see #tabInitializer
		 */
		public function get tabReleaser():Function
		{
			return this._tabReleaser;
		}

		/**
		 * @private
		 */
		public function set tabReleaser(value:Function):void
		{
			if(this._tabReleaser == value)
			{
				return;
			}
			this._tabReleaser = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _labelField:String = "label";

		/**
		 * The field in the item that contains the label text to be displayed by
		 * the tabs. If the item does not have this field, and a
		 * <code>labelFunction</code> is not defined, then the tabs will
		 * default to calling <code>toString()</code> on the item.
		 *
		 * <p>All of the label fields and functions, ordered by priority:</p>
		 * <ol>
		 *     <li><code>labelFunction</code></li>
		 *     <li><code>labelField</code></li>
		 * </ol>
		 *
		 * <p>In the following example, the label field is customized:</p>
		 *
		 * <listing version="3.0">
		 * tabs.labelField = "text";</listing>
		 *
		 * @default "label"
		 *
		 * @see #labelFunction
		 */
		public function get labelField():String
		{
			return this._labelField;
		}

		/**
		 * @private
		 */
		public function set labelField(value:String):void
		{
			if(this._labelField == value)
			{
				return;
			}
			this._labelField = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _labelFunction:Function;

		/**
		 * A function used to generate label text for a specific tab. If this
		 * function is not <code>null</code>, then the <code>labelField</code>
		 * will be ignored.
		 *
		 * <p>The function is expected to have the following signature:</p>
		 * <pre>function( item:Object ):String</pre>
		 *
		 * <p>All of the label fields and functions, ordered by priority:</p>
		 * <ol>
		 *     <li><code>labelFunction</code></li>
		 *     <li><code>labelField</code></li>
		 * </ol>
		 *
		 * <p>In the following example, the label function is customized:</p>
		 *
		 * <listing version="3.0">
		 * tabs.labelFunction = function( item:Object ):String
		 * {
		 *    return item.label + " (" + item.unread + ")";
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see #labelField
		 */
		public function get labelFunction():Function
		{
			return this._labelFunction;
		}

		/**
		 * @private
		 */
		public function set labelFunction(value:Function):void
		{
			if(this._labelFunction == value)
			{
				return;
			}
			this._labelFunction = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _enabledField:String = "isEnabled";

		/**
		 * The field in the item that determines if the tab is enabled. If the
		 * item does not have this field, and a <code>enabledFunction</code> is
		 * not defined, then the tab will default to being enabled, unless the
		 * tab bar is not enabled. All tabs will always be disabled if the tab
		 * bar is disabled.
		 *
		 * <p>All of the label fields and functions, ordered by priority:</p>
		 * <ol>
		 *     <li><code>enabledFunction</code></li>
		 *     <li><code>enabledField</code></li>
		 * </ol>
		 *
		 * <p>In the following example, the enabled field is customized:</p>
		 *
		 * <listing version="3.0">
		 * tabs.enabledField = "isEnabled";</listing>
		 *
		 * @default "enabled"
		 *
		 * @see #enabledFunction
		 */
		public function get enabledField():String
		{
			return this._enabledField;
		}

		/**
		 * @private
		 */
		public function set enabledField(value:String):void
		{
			if(this._enabledField == value)
			{
				return;
			}
			this._enabledField = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _iconField:String = "defaultIcon";
		//I'd like to use "icon" here instead, but defaultIcon is needed for
		//backwards compatibility...

		/**
		 * The field in the item that contains a display object to be displayed
		 * as an icon or other graphic next to the label in the tab.
		 *
		 * <p>Warning: It is your responsibility to dispose all icons
		 * included in the data provider and accessed with <code>iconField</code>,
		 * or any display objects returned by <code>iconFunction</code>.
		 * These display objects will not be disposed when the list is disposed.
		 * Not disposing an icon may result in a memory leak.</p>
		 *
		 * <p>All of the icon fields and functions, ordered by priority:</p>
		 * <ol>
		 *     <li><code>iconFunction</code></li>
		 *     <li><code>iconField</code></li>
		 * </ol>
		 *
		 * <p>In the following example, the icon field is customized:</p>
		 *
		 * <listing version="3.0">
		 * tabs.iconField = "photo";</listing>
		 *
		 * @default "icon"
		 *
		 * @see #iconFunction
		 */
		public function get iconField():String
		{
			return this._iconField;
		}

		/**
		 * @private
		 */
		public function set iconField(value:String):void
		{
			if(this._iconField == value)
			{
				return;
			}
			this._iconField = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _iconFunction:Function;

		/**
		 * A function used to generate an icon for a specific tab, based on its
		 * associated item in the data provider.
		 *
		 * <p>Note: This function may be called more than once for each
		 * individual item in the tab bar's data provider. The function should
		 * not simply return a new icon every time. This will result in the
		 * unnecessary creation and destruction of many icons, which will
		 * overwork the garbage collector, hurt performance, and possibly lead
		 * to memory leaks. It's better to return a new icon the first time this
		 * function is called for a particular item and then return the same
		 * icon if that item is passed to this function again.</p>
		 *
		 * <p>Warning: It is your responsibility to dispose all icons
		 * included in the data provider and accessed with <code>iconField</code>,
		 * or any display objects returned by <code>iconFunction</code>.
		 * These display objects will not be disposed when the list is disposed.
		 * Not disposing an icon may result in a memory leak.</p>
		 *
		 * <p>The function is expected to have the following signature:</p>
		 * <pre>function( item:Object ):DisplayObject</pre>
		 *
		 * <p>All of the icon fields and functions, ordered by priority:</p>
		 * <ol>
		 *     <li><code>iconFunction</code></li>
		 *     <li><code>iconField</code></li>
		 * </ol>
		 *
		 * <p>In the following example, the icon function is customized:</p>
		 *
		 * <listing version="3.0">
		 * var cachedIcons:Dictionary = new Dictionary( true );
		 * tabs.iconFunction = function( item:Object ):DisplayObject
		 * {
		 *    if(item in cachedIcons)
		 *    {
		 *        return cachedIcons[item];
		 *    }
		 *    var icon:Image = new Image( textureAtlas.getTexture( item.textureName ) );
		 *    cachedIcons[item] = icon;
		 *    return icon;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see #iconField
		 */
		public function get iconFunction():Function
		{
			return this._iconFunction;
		}

		/**
		 * @private
		 */
		public function set iconFunction(value:Function):void
		{
			if(this._iconFunction == value)
			{
				return;
			}
			this._iconFunction = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _enabledFunction:Function;

		/**
		 * A function used to determine if a specific tab is enabled. If this
		 * function is not <code>null</code>, then the <code>enabledField</code>
		 * will be ignored.
		 *
		 * <p>The function is expected to have the following signature:</p>
		 * <pre>function( item:Object ):Boolean</pre>
		 *
		 * <p>All of the enabled fields and functions, ordered by priority:</p>
		 * <ol>
		 *     <li><code>enabledFunction</code></li>
		 *     <li><code>enabledField</code></li>
		 * </ol>
		 *
		 * <p>In the following example, the enabled function is customized:</p>
		 *
		 * <listing version="3.0">
		 * tabs.enabledFunction = function( item:Object ):Boolean
		 * {
		 *    return item.isEnabled;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see #enabledField
		 */
		public function get enabledFunction():Function
		{
			return this._enabledFunction;
		}

		/**
		 * @private
		 */
		public function set enabledFunction(value:Function):void
		{
			if(this._enabledFunction == value)
			{
				return;
			}
			this._enabledFunction = value;
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
			this._animateSelectionChange = false;
			if(this._selectedIndex == value)
			{
				return;
			}
			this._selectedIndex = value;
			this.refreshSelectedItem();
			this.invalidate(INVALIDATION_FLAG_SELECTED);
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _selectedItem:Object = null;

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
			return this._selectedItem;
		}

		/**
		 * @private
		 */
		public function set selectedItem(value:Object):void
		{
			if(this._selectedItem === value)
			{
				return;
			}
			//we don't need to set _animateSelectionChange to false because we
			//always call the selectedIndex setter below, which sets it;
			if(this._dataProvider === null)
			{
				this.selectedIndex = -1;
				return;
			}
			var newIndex:int = this._dataProvider.getItemIndex(value);
			if(newIndex == -1)
			{
				this.selectedIndex = -1;
			}
			else if(this._selectedIndex != newIndex)
			{
				this.selectedIndex = newIndex;
			}
			else
			{
				//it's possible for the item to change, but not the index
				this._animateSelectionChange = false;
				this._selectedItem = value;
				this.invalidate(INVALIDATION_FLAG_SELECTED);
				this.dispatchEventWith(Event.CHANGE);
			}
		}

		/**
		 * @private
		 */
		protected var _customTabStyleName:String;

		/**
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._customTabStyleName === value)
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
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._customFirstTabStyleName === value)
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
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._customLastTabStyleName === value)
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
		 * tabs.tabProperties.iconPosition = RelativePosition.RIGHT;</listing>
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
		 * @inheritDoc
		 */
		public function get baseline():Number
		{
			if(!this.activeTabs || this.activeTabs.length == 0)
			{
				return this.scaledActualHeight;
			}
			var firstTab:ToggleButton = this.activeTabs[0];
			return this.scaleY * (firstTab.y + firstTab.baseline);
		}

		/**
		 * @private
		 */
		protected var _animateSelectionChange:Boolean = false;

		/**
		 * @private
		 */
		protected var _dragFormat:String = DEFAULT_DRAG_FORMAT;

		/**
		 * Drag and drop is restricted to components that have the same
		 * <code>dragFormat</code>.
		 * 
		 * <p>In the following example, the drag format of two tab bars is customized:</p>
		 *
		 * <listing version="3.0">
		 * tabs1.dragFormat = "my-custom-format";
		 * tabs2.dragFormat = "my-custom-format";</listing>
		 * 
		 * @default "feathers-tab-bar-item"
		 */
		public function get dragFormat():String
		{
			return this._dragFormat;
		}

		/**
		 * @private
		 */
		public function set dragFormat(value:String):void
		{
			if(!value)
			{
				value = DEFAULT_DRAG_FORMAT;
			}
			if(this._dragFormat == value)
			{
				return;
			}
			this._dragFormat = value;
		}

		/**
		 * @private
		 */
		protected var _dragTouchPointID:int = -1;

		/**
		 * @private
		 */
		protected var _droppedOnSelf:Boolean = false;

		/**
		 * @private
		 */
		protected var _dragEnabled:Boolean = false;

		/**
		 * Indicates if this tab bar can initiate drag and drop operations by
		 * touching an item and dragging it. The <code>dragEnabled</code>
		 * property enables dragging items, but dropping items must be enabled
		 * separately with the <code>dropEnabled</code> property.
		 * 
		 * <p>In the following example, a tab bar's items may be dragged:</p>
		 *
		 * <listing version="3.0">
		 * tabs.dragEnabled = true;</listing>
		 * 
		 * @see #dropEnabled
		 * @see #dragFormat
		 */
		public function get dragEnabled():Boolean
		{
			return this._dragEnabled;
		}

		/**
		 * @private
		 */
		public function set dragEnabled(value:Boolean):void
		{
			if(this._dragEnabled == value)
			{
				return;
			}
			this._dragEnabled = value;
			if(this._dragEnabled)
			{
				this.addEventListener(DragDropEvent.DRAG_COMPLETE, dragCompleteHandler);
			}
			else
			{
				this.removeEventListener(DragDropEvent.DRAG_COMPLETE, dragCompleteHandler);
			}
		}

		/**
		 * @private
		 */
		protected var _dropEnabled:Boolean = false;

		/**
		 * Indicates if this tab bar can accept items that are dragged and
		 * dropped over the tab bar's hit area.
		 * 
		 * <p>In the following example, a tab bar's items may be dropped:</p>
		 *
		 * <listing version="3.0">
		 * tabs.dropEnabled = true;</listing>
		 * 
		 * @see #dragEnabled
		 * @see #dragFormat
		 */
		public function get dropEnabled():Boolean
		{
			return this._dropEnabled;
		}

		/**
		 * @private
		 */
		public function set dropEnabled(value:Boolean):void
		{
			if(this._dropEnabled == value)
			{
				return;
			}
			this._dropEnabled = value;
			if(this._dropEnabled)
			{
				this.addEventListener(DragDropEvent.DRAG_ENTER, dragEnterHandler);
				this.addEventListener(DragDropEvent.DRAG_MOVE, dragMoveHandler);
				this.addEventListener(DragDropEvent.DRAG_EXIT, dragExitHandler);
				this.addEventListener(DragDropEvent.DRAG_DROP, dragDropHandler);
			}
			else
			{
				this.removeEventListener(DragDropEvent.DRAG_ENTER, dragEnterHandler);
				this.removeEventListener(DragDropEvent.DRAG_MOVE, dragMoveHandler);
				this.removeEventListener(DragDropEvent.DRAG_EXIT, dragExitHandler);
				this.removeEventListener(DragDropEvent.DRAG_DROP, dragDropHandler);
			}
		}

		/**
		 * @private
		 */
		protected var _explicitDropIndicatorWidth:Number = NaN;

		/**
		 * @private
		 */
		protected var _explicitDropIndicatorHeight:Number = NaN;

		/**
		 * @private
		 */
		protected var _dropIndicatorSkin:DisplayObject = null;

		/**
		 * @private
		 */
		public function get dropIndicatorSkin():DisplayObject
		{
			return this._dropIndicatorSkin;
		}

		/**
		 * @private
		 */
		public function set dropIndicatorSkin(value:DisplayObject):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				if(value !== null)
				{
					value.dispose();
				}
				return;
			}
			this._dropIndicatorSkin = value;
			if(this._dropIndicatorSkin is IMeasureDisplayObject)
			{
				var measureSkin:IMeasureDisplayObject = IMeasureDisplayObject(this._dropIndicatorSkin);
				this._explicitDropIndicatorWidth = measureSkin.explicitWidth;
				this._explicitDropIndicatorHeight = measureSkin.explicitHeight;
			}
			else if(this._dropIndicatorSkin)
			{
				this._explicitDropIndicatorWidth = this._dropIndicatorSkin.width;
				this._explicitDropIndicatorHeight = this._dropIndicatorSkin.height;
			}
		}

		/**
		 * @private
		 */
		override public function dispose():void
		{
			if(this._dropIndicatorSkin !== null &&
				this._dropIndicatorSkin.parent === null)
			{
				this._dropIndicatorSkin.dispose();
				this._dropIndicatorSkin = null;
			}

			//clearing selection now so that the data provider setter won't
			//cause a selection change that triggers events.
			this._selectedIndex = -1;
			//this flag also ensures that removing items from the ToggleGroup
			//won't result in selection events
			this._ignoreSelectionChanges = true;

			//the tabs may contain things that shouldn't be disposed, so clean
			//them up before super.dispose()
			var tabCount:int = this.activeTabs.length;
			for(var i:int = 0; i < tabCount; i++)
			{
				var tab:ToggleButton = this.activeTabs.shift();
				this.destroyTab(tab);
			}

			//ensures that listeners are removed to avoid memory leaks
			this.dataProvider = null;

			super.dispose();
		}

		/**
		 * Changes the <code>selectedIndex</code> property, but animates the
		 * <code>selectionSkin</code> to the new position, as if the user
		 * triggered a tab.
		 *
		 * @see #selectedIndex
		 */
		public function setSelectedIndexWithAnimation(selectedIndex:int):void
		{
			if(this._selectedIndex == selectedIndex)
			{
				return;
			}
			this._selectedIndex = selectedIndex;
			this.refreshSelectedItem();
			//set this flag before dispatching the event because the TabBar
			//might be forced to validate in an event listener
			this._animateSelectionChange = true;
			this.invalidate(INVALIDATION_FLAG_SELECTED);
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * Changes the <code>selectedItem</code> property, but animates the
		 * <code>selectionSkin</code> to the new position, as if the user
		 * triggered a tab.
		 *
		 * @see #selectedItem
		 * @see #selectedIndex
		 * @see #setSelectedIndexWithAnimation()
		 */
		public function setSelectedItemWithAnimation(selectedItem:Object):void
		{
			if(this.selectedItem == selectedItem)
			{
				return;
			}
			var selectedIndex:int = -1;
			if(this._dataProvider !== null)
			{
				selectedIndex = this._dataProvider.getItemIndex(selectedItem);
			}
			this.setSelectedIndexWithAnimation(selectedIndex);
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

			if(dataInvalid || tabFactoryInvalid || stateInvalid)
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
			if(this._direction == Direction.VERTICAL)
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
				this.verticalLayout.verticalAlign = (this._verticalAlign == VerticalAlign.JUSTIFY) ? VerticalAlign.TOP : this._verticalAlign;
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
				this.horizontalLayout.horizontalAlign = (this._horizontalAlign == HorizontalAlign.JUSTIFY) ? HorizontalAlign.LEFT : this._horizontalAlign;
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
		protected function commitTabData(tab:ToggleButton, item:Object):void
		{
			if(item !== null)
			{
				if(this._labelFunction !== null)
				{
					tab.label = this._labelFunction(item);
				}
				else if(this._labelField !== null && item !== null && this._labelField in item)
				{
					tab.label = item[this._labelField];
				}
				else if(item is String)
				{
					tab.label = item as String;
				}
				else
				{
					tab.label = item.toString();
				}
				if(this._iconFunction !== null)
				{
					tab.defaultIcon = this._iconFunction(item);
				}
				else if(this._iconField !== null && item !== null && this._iconField in item)
				{
					tab.defaultIcon = item[this._iconField] as DisplayObject;
				}
				if(this._enabledFunction !== null)
				{
					//we account for this._isEnabled later
					tab.isEnabled = this._enabledFunction(item);
				}
				else if(this._enabledField !== null && item !== null && this._enabledField in item)
				{
					//we account for this._isEnabled later
					tab.isEnabled = item[this._enabledField] as Boolean;
				}
				else
				{
					tab.isEnabled = this._isEnabled;
				}
				if(this._tabInitializer !== null)
				{
					this._tabInitializer(tab, item);
				}
			}
			else
			{
				tab.label = "";
				tab.isEnabled = this._isEnabled;
			}
		}

		/**
		 * @private
		 */
		protected function defaultTabInitializer(tab:ToggleButton, item:Object):void
		{
			if(item !== null)
			{
				for each(var field:String in DEFAULT_TAB_FIELDS)
				{
					if(item.hasOwnProperty(field))
					{
						tab[field] = item[field];
					}
				}
			}
		}

		/**
		 * @private
		 */
		protected function defaultTabReleaser(tab:ToggleButton, oldItem:Object):void
		{
			for each(var field:String in DEFAULT_TAB_FIELDS)
			{
				if(oldItem.hasOwnProperty(field))
				{
					tab[field] = null;
				}
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
			var isNewInstance:Boolean = false;
			if(this.inactiveFirstTab !== null)
			{
				var tab:ToggleButton = this.inactiveFirstTab;
				this.releaseTab(tab);
				this.inactiveFirstTab = null;
			}
			else
			{
				isNewInstance = true;
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
			this.commitTabData(tab, item);
			this._tabToItem[tab] = item;
			if(isNewInstance)
			{
				//we need to listen for events after the initializer
				//is called to avoid runtime errors because the tab may be
				//disposed by the time listeners in the initializer are called.
				this.addTabListeners(tab);
			}
			return tab;
		}

		/**
		 * @private
		 */
		protected function createLastTab(item:Object):ToggleButton
		{
			var isNewInstance:Boolean = false;
			if(this.inactiveLastTab !== null)
			{
				var tab:ToggleButton = this.inactiveLastTab;
				this.releaseTab(tab);
				this.inactiveLastTab = null;
			}
			else
			{
				isNewInstance = true;
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
			this.commitTabData(tab, item);
			this._tabToItem[tab] = item;
			if(isNewInstance)
			{
				//we need to listen for events after the initializer
				//is called to avoid runtime errors because the tab may be
				//disposed by the time listeners in the initializer are called.
				this.addTabListeners(tab);
			}
			return tab;
		}

		/**
		 * @private
		 */
		protected function createTab(item:Object):ToggleButton
		{
			var isNewInstance:Boolean = false;
			if(this.inactiveTabs.length == 0)
			{
				isNewInstance = true;
				var tab:ToggleButton = ToggleButton(this._tabFactory());
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
				this.releaseTab(tab);
			}
			this.commitTabData(tab, item);
			this._tabToItem[tab] = item;
			if(isNewInstance)
			{
				//we need to listen for events after the initializer
				//is called to avoid runtime errors because the tab may be
				//disposed by the time listeners in the initializer are called.
				this.addTabListeners(tab);
			}
			return tab;
		}

		protected function addTabListeners(tab:ToggleButton):void
		{
			tab.addEventListener(Event.TRIGGERED, tab_triggeredHandler);
			tab.addEventListener(TouchEvent.TOUCH, tab_drag_touchHandler);
		}

		/**
		 * @private
		 */
		protected function releaseTab(tab:ToggleButton):void
		{
			var item:Object = this._tabToItem[tab];
			delete this._tabToItem[tab];
			if(this._labelFunction !== null || this._labelField in item)
			{
				tab.label = null;
			}
			if(this._iconFunction !== null || this._iconField in item)
			{
				tab.defaultIcon = null;
			}
			if(this._tabReleaser !== null)
			{
				if(this._tabReleaser.length == 1)
				{
					this._tabReleaser(tab);
				}
				else
				{
					this._tabReleaser(tab, item);
				}
			}
		}

		/**
		 * @private
		 */
		protected function destroyTab(tab:ToggleButton):void
		{
			this.toggleGroup.removeItem(tab);
			this.releaseTab(tab);
			tab.removeEventListener(Event.TRIGGERED, tab_triggeredHandler);
			tab.removeEventListener(TouchEvent.TOUCH, tab_drag_touchHandler);
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
			this._viewPortBounds.explicitWidth = this._explicitWidth;
			this._viewPortBounds.explicitHeight = this._explicitHeight;
			this._viewPortBounds.minWidth = this._explicitMinWidth;
			this._viewPortBounds.minHeight = this._explicitMinHeight;
			this._viewPortBounds.maxWidth = this._explicitMaxWidth;
			this._viewPortBounds.maxHeight = this._explicitMaxHeight;
			if(this.verticalLayout)
			{
				this.verticalLayout.layout(this._layoutItems, this._viewPortBounds, this._layoutResult);
			}
			else if(this.horizontalLayout)
			{
				this.horizontalLayout.layout(this._layoutItems, this._viewPortBounds, this._layoutResult);
			}

			var contentWidth:Number = this._layoutResult.contentWidth;
			var contentHeight:Number = this._layoutResult.contentHeight;
			//minimum dimensions are the same as the measured dimensions
			this.saveMeasurements(contentWidth, contentHeight, contentWidth, contentHeight);

			//final validation to avoid juggler next frame issues
			for each(var tab:ToggleButton in this.activeTabs)
			{
				tab.validate();
			}
			if(this._selectionSkin !== null)
			{
				//always on top
				this.setChildIndex(this._selectionSkin, this.numChildren - 1);

				if(this._selectionChangeTween !== null)
				{
					this._selectionChangeTween.advanceTime(this._selectionChangeTween.totalTime);
				}
				if(this._selectedIndex >= 0)
				{
					this._selectionSkin.visible = true;
					tab = this.activeTabs[this._selectedIndex];
					if(this._animateSelectionChange)
					{
						this._selectionChangeTween = new Tween(this._selectionSkin, this._selectionChangeDuration, this._selectionChangeEase);
						if(this._direction === Direction.VERTICAL)
						{
							this._selectionChangeTween.animate("y", tab.y);
							this._selectionChangeTween.animate("height", tab.height);
						}
						else //horizontal
						{
							this._selectionChangeTween.animate("x", tab.x);
							this._selectionChangeTween.animate("width", tab.width);
						}
						this._selectionChangeTween.onComplete = selectionChangeTween_onComplete;
						Starling.juggler.add(this._selectionChangeTween);
					}
					else
					{
						if(this._direction === Direction.VERTICAL)
						{
							this._selectionSkin.y = tab.y;
							this._selectionSkin.height = tab.height;
						}
						else //horizontal
						{
							this._selectionSkin.x = tab.x;
							this._selectionSkin.width = tab.width;
						}
					}
				}
				else
				{
					this._selectionSkin.visible = false;
				}
				this._animateSelectionChange = false;
				if(this._selectionSkin is IValidating)
				{
					IValidating(this._selectionSkin).validate();
				}
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
		protected function refreshSelectedItem():void
		{
			if(this._selectedIndex == -1)
			{
				this._selectedItem = null;
			}
			else
			{
				this._selectedItem = this._dataProvider.getItemAt(this._selectedIndex);
			}
		}

		/**
		 * @private
		 */
		protected function getDropIndex(event:DragDropEvent):int
		{
			var point:Point = Pool.getPoint(event.localX, event.localY);
			this.localToGlobal(point, point);
			var globalX:Number = point.x;
			var globalY:Number = point.y;
			Pool.putPoint(point);

			var tabCount:int = this.activeTabs.length;
			for(var i:int = 0; i < tabCount; i++)
			{
				var tab:ToggleButton = this.activeTabs[i];
				if(this._direction === Direction.HORIZONTAL)
				{
					point = Pool.getPoint(tab.width / 2, 0);
				}
				else
				{
					point = Pool.getPoint(0, tab.height / 2);
				}
				tab.localToGlobal(point, point);
				var tabGlobalMiddleX:Number = point.x;
				var tabGlobalMiddleY:Number = point.y;
				Pool.putPoint(point);
				if(this._direction === Direction.VERTICAL)
				{
					if(globalY < tabGlobalMiddleY)
					{
						return i;
					}
				}
				else //horizontal
				{
					if(globalX < tabGlobalMiddleX)
					{
						return i;
					}
				}
			}
			return tabCount;
		}

		/**
		 * @private
		 */
		protected function refreshDropIndicator(event:DragDropEvent):void
		{
			if(!this._dropIndicatorSkin)
			{
				return;
			}
			var dropIndex:int = this.getDropIndex(event);
			if(this._direction == Direction.VERTICAL)
			{
				var dropIndicatorY:Number = 0;
				if(dropIndex == this.activeTabs.length)
				{
					dropIndicatorY = this.actualHeight - this._dropIndicatorSkin.height;
				}
				else if(dropIndex == 0)
				{
					dropIndicatorY = 0;
				}
				else
				{
					var tab:ToggleButton = this.activeTabs[dropIndex];
					dropIndicatorY = tab.y - (this._gap + this._dropIndicatorSkin.height) / 2;
				}
				this._dropIndicatorSkin.x = 0;
				this._dropIndicatorSkin.y = dropIndicatorY;
				this._dropIndicatorSkin.width = this.actualWidth;
				//just in case the direction changed, reset this value
				this._dropIndicatorSkin.height = this._explicitDropIndicatorHeight;
			}
			else //horizontal
			{
				var dropIndicatorX:Number = 0;
				if(dropIndex == this.activeTabs.length)
				{
					dropIndicatorX = this.actualWidth - this._dropIndicatorSkin.width;
				}
				else if(dropIndex == 0)
				{
					dropIndicatorX = 0;
				}
				else
				{
					tab = this.activeTabs[dropIndex];
					dropIndicatorX = tab.x - (this._gap + this._dropIndicatorSkin.width) / 2;
				}
				this._dropIndicatorSkin.x = dropIndicatorX;
				this._dropIndicatorSkin.y = 0;
				//just in case the direction changed, reset this value
				this._dropIndicatorSkin.width = this._explicitDropIndicatorWidth;
				this._dropIndicatorSkin.height = this.actualHeight;
			}
			this.addChild(this._dropIndicatorSkin);
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
		protected function selectionChangeTween_onComplete():void
		{
			this._selectionChangeTween = null;
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
		
		/**
		 * @private
		 */
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
			if(!this._dataProvider || this._dataProvider.length == 0)
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
			else if(event.keyCode == Keyboard.UP || event.keyCode == Keyboard.LEFT)
			{
				newFocusedTabIndex--;
				if(newFocusedTabIndex < 0)
				{
					newFocusedTabIndex = maxFocusedTabIndex;
				}
			}
			else if(event.keyCode == Keyboard.DOWN || event.keyCode == Keyboard.RIGHT)
			{
				newFocusedTabIndex++;
				if(newFocusedTabIndex > maxFocusedTabIndex)
				{
					newFocusedTabIndex = 0;
				}
			}

			if(newFocusedTabIndex >= 0 && newFocusedTabIndex != this._focusedTabIndex)
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
		protected function tab_triggeredHandler(event:Event):void
		{
			//if this was called after dispose, ignore it
			if(!this._dataProvider || !this.activeTabs)
			{
				return;
			}
			var tab:ToggleButton = ToggleButton(event.currentTarget);
			var index:int = this.activeTabs.indexOf(tab);
			var item:Object = this._dataProvider.getItemAt(index);
			this.dispatchEventWith(Event.TRIGGERED, false, item);
		}

		/**
		 * @private
		 */
		protected function dragEnterHandler(event:DragDropEvent):void
		{
			if(!this._dropEnabled)
			{
				return;
			}
			if(!event.dragData.hasDataForFormat(this._dragFormat))
			{
				return;
			}
			DragDropManager.acceptDrag(this);
			this.refreshDropIndicator(event);
		}

		/**
		 * @private
		 */
		protected function dragMoveHandler(event:DragDropEvent):void
		{
			if(!this._dropEnabled)
			{
				return;
			}
			if(!event.dragData.hasDataForFormat(this._dragFormat))
			{
				return;
			}
			this.refreshDropIndicator(event);
		}

		/**
		 * @private
		 */
		protected function dragExitHandler(event:DragDropEvent):void
		{
			if(this._dropIndicatorSkin)
			{
				this._dropIndicatorSkin.removeFromParent(false);
			}
		}

		/**
		 * @private
		 */
		protected function dragDropHandler(event:DragDropEvent):void
		{
			if(this._dropIndicatorSkin)
			{
				this._dropIndicatorSkin.removeFromParent(false);
			}
			var index:int = this.getDropIndex(event);
			var item:Object = event.dragData.getDataForFormat(this._dragFormat);
			var selectItem:Boolean = this._selectedItem == item;
			if(event.dragSource == this)
			{
				//if we wait to remove this item in the dragComplete handler,
				//the wrong index might be removed.
				var oldIndex:int = this._dataProvider.getItemIndex(item);
				this._dataProvider.removeItemAt(oldIndex);
				this._droppedOnSelf = true;
				if(index > oldIndex)
				{
					index--;
				}
			}
			this._dataProvider.addItemAt(item, index);
			if(selectItem)
			{
				this.selectedIndex = index;
			}
			
		}

		/**
		 * @private
		 */
		protected function dragCompleteHandler(event:DragDropEvent):void
		{
			if(!event.isDropped)
			{
				//nothing to modify
				return;
			}
			if(this._droppedOnSelf)
			{
				//already modified the data provider in the dragDrop handler
				this._droppedOnSelf = false;
				return;
			}
			var item:Object = event.dragData.getDataForFormat(this._dragFormat);
			this._dataProvider.removeItem(item);
		}

		/**
		 * @private
		 */
		protected function tab_drag_touchHandler(event:TouchEvent):void
		{
			if(!this._dragEnabled)
			{
				this._dragTouchPointID = -1;
				return;
			}
			if(DragDropManager.isDragging)
			{
				this._dragTouchPointID = -1;
				return;
			}
			var tab:ToggleButton = ToggleButton(event.currentTarget);
			if(this._dragTouchPointID != -1)
			{
				var exclusiveTouch:ExclusiveTouch = ExclusiveTouch.forStage(tab.stage);
				if(exclusiveTouch.getClaim(this._dragTouchPointID))
				{
					this._dragTouchPointID = -1;
					return;
				}
				var touch:Touch = event.getTouch(tab, null, this._dragTouchPointID);
				if(touch.phase == TouchPhase.MOVED)
				{
					var index:int = this.activeTabs.indexOf(tab);
					var item:Object = this._dataProvider.getItemAt(index);
					var dragData:DragData = new DragData();
					dragData.setDataForFormat(this._dragFormat, item);
					var avatar:ToggleButton = this.createTab(item);
					avatar.width = tab.width;
					avatar.height = tab.height;
					avatar.alpha = 0.8;
					var point:Point = Pool.getPoint();
					touch.getLocation(tab, point);
					this._droppedOnSelf = false;
					DragDropManager.startDrag(this, touch, dragData, avatar, -point.x, -point.y);
					Pool.putPoint(point);
					exclusiveTouch.claimTouch(this._dragTouchPointID, tab);
					this._dragTouchPointID = -1;
				}
				else if(touch.phase == TouchPhase.ENDED)
				{
					this._dragTouchPointID = -1;
				}
			}
			else
			{
				
				//we aren't tracking another touch, so let's look for a new one.
				touch = event.getTouch(tab, TouchPhase.BEGAN);
				if(!touch)
				{
					//we only care about the began phase. ignore all other
					//phases when we don't have a saved touch ID.
					return;
				}
				this._dragTouchPointID = touch.id;
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
			//it should only get here if the change happened by the user
			//triggering a tab.
			this.setSelectedIndexWithAnimation(this.toggleGroup.selectedIndex);
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
		protected function dataProvider_removeAllHandler(event:Event):void
		{
			this.selectedIndex = -1;
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
					this.refreshSelectedItem();
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
					this.refreshSelectedItem();
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
				this.refreshSelectedItem();
				this.invalidate(INVALIDATION_FLAG_SELECTED);
				this.dispatchEventWith(Event.CHANGE);
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected function refreshSelectedIndicesAfterFilterOrSort():void
		{
			var oldIndex:int = this._dataProvider.getItemIndex(this._selectedItem);
			if(oldIndex == -1)
			{
				//the selected item was filtered
				var newIndex:int = this._selectedIndex;
				var maxIndex:int = this._dataProvider.length - 1;
				if(newIndex > maxIndex)
				{
					//try to keep the same selectedIndex, but use the largest
					//index if the same one can't be used
					newIndex = maxIndex;
				}
				if(newIndex != -1)
				{
					this.selectedItem = this._dataProvider.getItemAt(newIndex);
				}
				else
				{
					this.selectedIndex = -1;
				}
			}
			else if(oldIndex != this._selectedIndex)
			{
				//the selectedItem is the same, but its index has changed
				this.selectedIndex = oldIndex;
			}
		}

		protected function dataProvider_sortChangeHandler(event:Event):void
		{
			this.refreshSelectedIndicesAfterFilterOrSort();
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected function dataProvider_filterChangeHandler(event:Event):void
		{
			this.refreshSelectedIndicesAfterFilterOrSort();
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
