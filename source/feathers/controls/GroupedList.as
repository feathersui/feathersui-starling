/*
Feathers
Copyright 2012-2015 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.controls.renderers.DefaultGroupedListHeaderOrFooterRenderer;
	import feathers.controls.renderers.DefaultGroupedListItemRenderer;
	import feathers.controls.supportClasses.GroupedListDataViewPort;
	import feathers.core.IFocusContainer;
	import feathers.core.PropertyProxy;
	import feathers.data.HierarchicalCollection;
	import feathers.events.CollectionEventType;
	import feathers.layout.ILayout;
	import feathers.layout.IVariableVirtualLayout;
	import feathers.layout.VerticalLayout;
	import feathers.skins.IStyleProvider;

	import flash.geom.Point;
	import flash.ui.Keyboard;

	import starling.events.Event;
	import starling.events.KeyboardEvent;

	/**
	 * Dispatched when the selected item changes.
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
	 * Dispatched when the the user taps or clicks an item renderer in the list.
	 * The touch must remain within the bounds of the item renderer on release,
	 * and the list must not have scrolled, to register as a tap or a click.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>The item associated with the item
	 *   renderer that was triggered.</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @eventType starling.events.Event.TRIGGERED
	 */
	[Event(name="triggered",type="starling.events.Event")]

	/**
	 * Dispatched when an item renderer is added to the list. When the layout is
	 * virtualized, item renderers may not exist for every item in the data
	 * provider. This event can be used to track which items currently have
	 * renderers.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>The item renderer that was added</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @eventType feathers.events.FeathersEventType.RENDERER_ADD
	 */
	[Event(name="rendererAdd",type="starling.events.Event")]

	/**
	 * Dispatched when an item renderer is removed from the list. When the layout is
	 * virtualized, item renderers may not exist for every item in the data
	 * provider. This event can be used to track which items currently have
	 * renderers.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>The item renderer that was removed</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @eventType feathers.events.FeathersEventType.RENDERER_REMOVE
	 */
	[Event(name="rendererRemove",type="starling.events.Event")]

	[DefaultProperty("dataProvider")]
	/**
	 * Displays a list of items divided into groups or sections. Takes a
	 * hierarchical provider limited to two levels of hierarchy. This component
	 * supports scrolling, custom item (and header and footer) renderers, and
	 * custom layouts.
	 *
	 * <p>Layouts may be, and are highly encouraged to be, <em>virtual</em>,
	 * meaning that the List is capable of creating a limited number of item
	 * renderers to display a subset of the data provider instead of creating a
	 * renderer for every single item. This allows for optimal performance with
	 * very large data providers.</p>
	 *
	 * <p>The following example creates a grouped list, gives it a data
	 * provider, tells the item renderer how to interpret the data, and listens
	 * for when the selection changes:</p>
	 *
	 * <listing version="3.0">
	 * var list:GroupedList = new GroupedList();
	 *
	 * list.dataProvider = new HierarchicalCollection(
	 * [
	 *     {
	 *     	   header: "Dairy",
	 *     	   children:
	 *     	   [
	 *     	       { text: "Milk", thumbnail: textureAtlas.getTexture( "milk" ) },
	 *     	       { text: "Cheese", thumbnail: textureAtlas.getTexture( "cheese" ) },
	 *     	   ]
	 *     },
	 *     {
	 *         header: "Bakery",
	 *         children:
	 *         [
	 *             { text: "Bread", thumbnail: textureAtlas.getTexture( "bread" ) },
	 *         ]
	 *     },
	 *     {
	 *         header: "Produce",
	 *         children:
	 *         [
	 *             { text: "Bananas", thumbnail: textureAtlas.getTexture( "bananas" ) },
	 *             { text: "Lettuce", thumbnail: textureAtlas.getTexture( "lettuce" ) },
	 *             { text: "Onion", thumbnail: textureAtlas.getTexture( "onion" ) },
	 *         ]
	 *     },
	 * ]);
	 *
	 * list.itemRendererFactory = function():IGroupedListItemRenderer
	 * {
	 *     var renderer:DefaultGroupedListItemRenderer = new DefaultGroupedListItemRenderer();
	 *     renderer.labelField = "text";
	 *     renderer.iconSourceField = "thumbnail";
	 *     return renderer;
	 * };
	 *
	 * list.addEventListener( Event.CHANGE, list_changeHandler );
	 *
	 * this.addChild( list );</listing>
	 *
	 * @see ../../../help/grouped-list.html How to use the Feathers GroupedList component
	 * @see ../../../help/default-item-renderers.html How to use the Feathers default item renderer
	 * @see ../../../help/item-renderers.html Creating custom item renderers for the Feathers List and GroupedList components
	 * @see feathers.controls.List
	 */
	public class GroupedList extends Scroller implements IFocusContainer
	{
		/**
		 * @private
		 */
		private static const HELPER_POINT:Point = new Point();

		/**
		 * The default <code>IStyleProvider</code> for all <code>GroupedList</code>
		 * components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * An alternate style name to use with <code>GroupedList</code> to allow
		 * a theme to give it an inset style. If a theme does not provide a
		 * style for an inset grouped list, the theme will automatically fall
		 * back to using the default grouped list style.
		 *
		 * <p>An alternate style name should always be added to a component's
		 * <code>styleNameList</code> before the component is initialized. If
		 * the style name is added later, it will be ignored.</p>
		 *
		 * <p>In the following example, the inset style is applied to a grouped
		 * list:</p>
		 *
		 * <listing version="3.0">
		 * var list:GroupedList = new GroupedList();
		 * list.styleNameList.add( GroupedList.ALTERNATE_STYLE_NAME_INSET_GROUPED_LIST );
		 * this.addChild( list );</listing>
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const ALTERNATE_STYLE_NAME_INSET_GROUPED_LIST:String = "feathers-inset-grouped-list";

		/**
		 * DEPRECATED: Replaced by <code>GroupedList.ALTERNATE_STYLE_NAME_INSET_GROUPED_LIST</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 2.1. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 *
		 * @see GroupedList#ALTERNATE_STYLE_NAME_INSET_GROUPED_LIST
		 */
		public static const ALTERNATE_NAME_INSET_GROUPED_LIST:String = ALTERNATE_STYLE_NAME_INSET_GROUPED_LIST;

		/**
		 * The default name to use with header renderers.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_HEADER_RENDERER:String = "feathers-grouped-list-header-renderer";

		/**
		 * DEPRECATED: Replaced by <code>GroupedList.DEFAULT_CHILD_STYLE_NAME_HEADER_RENDERER</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 2.1. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 *
		 * @see GroupedList#DEFAULT_CHILD_STYLE_NAME_HEADER_RENDERER
		 */
		public static const DEFAULT_CHILD_NAME_HEADER_RENDERER:String = DEFAULT_CHILD_STYLE_NAME_HEADER_RENDERER;

		/**
		 * An alternate name to use with header renderers to give them an inset
		 * style. This name is usually only referenced inside themes.
		 *
		 * <p>In the following example, the inset style is applied to a grouped
		 * list's header:</p>
		 *
		 * <listing version="3.0">
		 * list.customHeaderRendererStyleName = GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_HEADER_RENDERER;</listing>
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const ALTERNATE_CHILD_STYLE_NAME_INSET_HEADER_RENDERER:String = "feathers-grouped-list-inset-header-renderer";

		/**
		 * DEPRECATED: Replaced by <code>GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_HEADER_RENDERER</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 2.1. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 *
		 * @see GroupedList#ALTERNATE_CHILD_STYLE_NAME_INSET_HEADER_RENDERER
		 */
		public static const ALTERNATE_CHILD_NAME_INSET_HEADER_RENDERER:String = ALTERNATE_CHILD_STYLE_NAME_INSET_HEADER_RENDERER;

		/**
		 * The default name to use with footer renderers.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_FOOTER_RENDERER:String = "feathers-grouped-list-footer-renderer";

		/**
		 * DEPRECATED: Replaced by <code>GroupedList.DEFAULT_CHILD_STYLE_NAME_FOOTER_RENDERER</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 2.1. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 *
		 * @see GroupedList#DEFAULT_CHILD_STYLE_NAME_FOOTER_RENDERER
		 */
		public static const DEFAULT_CHILD_NAME_FOOTER_RENDERER:String = DEFAULT_CHILD_STYLE_NAME_FOOTER_RENDERER;

		/**
		 * An alternate name to use with footer renderers to give them an inset
		 * style. This name is usually only referenced inside themes.
		 *
		 * <p>In the following example, the inset style is applied to a grouped
		 * list's footer:</p>
		 *
		 * <listing version="3.0">
		 * list.customFooterRendererStyleName = GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_FOOTER_RENDERER;</listing>
		 */
		public static const ALTERNATE_CHILD_STYLE_NAME_INSET_FOOTER_RENDERER:String = "feathers-grouped-list-inset-footer-renderer";

		/**
		 * DEPRECATED: Replaced by <code>GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_FOOTER_RENDERER</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 2.1. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 *
		 * @see GroupedList#ALTERNATE_CHILD_STYLE_NAME_INSET_FOOTER_RENDERER
		 */
		public static const ALTERNATE_CHILD_NAME_INSET_FOOTER_RENDERER:String = ALTERNATE_CHILD_STYLE_NAME_INSET_FOOTER_RENDERER;

		/**
		 * An alternate name to use with item renderers to give them an inset
		 * style. This name is usually only referenced inside themes.
		 *
		 * <p>In the following example, the inset style is applied to a grouped
		 * list's item renderer:</p>
		 *
		 * <listing version="3.0">
		 * list.customItemRendererStyleName = GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_ITEM_RENDERER;</listing>
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const ALTERNATE_CHILD_STYLE_NAME_INSET_ITEM_RENDERER:String = "feathers-grouped-list-inset-item-renderer";

		/**
		 * DEPRECATED: Replaced by <code>GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_ITEM_RENDERER</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 2.1. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 *
		 * @see GroupedList#ALTERNATE_CHILD_STYLE_NAME_INSET_ITEM_RENDERER
		 */
		public static const ALTERNATE_CHILD_NAME_INSET_ITEM_RENDERER:String = ALTERNATE_CHILD_STYLE_NAME_INSET_ITEM_RENDERER;

		/**
		 * An alternate name to use for item renderers to give them an inset
		 * style. Typically meant to be used for the renderer of the first item
		 * in a group. This name is usually only referenced inside themes.
		 *
		 * <p>In the following example, the inset style is applied to a grouped
		 * list's first item renderer:</p>
		 *
		 * <listing version="3.0">
		 * list.customFirstItemRendererStyleName = GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_FIRST_ITEM_RENDERER;</listing>
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const ALTERNATE_CHILD_STYLE_NAME_INSET_FIRST_ITEM_RENDERER:String = "feathers-grouped-list-inset-first-item-renderer";

		/**
		 * DEPRECATED: Replaced by <code>GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_FIRST_ITEM_RENDERER</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 2.1. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 *
		 * @see GroupedList#ALTERNATE_CHILD_STYLE_NAME_INSET_FIRST_ITEM_RENDERER
		 */
		public static const ALTERNATE_CHILD_NAME_INSET_FIRST_ITEM_RENDERER:String = ALTERNATE_CHILD_STYLE_NAME_INSET_FIRST_ITEM_RENDERER;

		/**
		 * An alternate name to use for item renderers to give them an inset
		 * style. Typically meant to be used for the renderer of the last item
		 * in a group. This name is usually only referenced inside themes.
		 *
		 * <p>In the following example, the inset style is applied to a grouped
		 * list's last item renderer:</p>
		 *
		 * <listing version="3.0">
		 * list.customLastItemRendererStyleName = GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_LAST_ITEM_RENDERER;</listing>
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const ALTERNATE_CHILD_STYLE_NAME_INSET_LAST_ITEM_RENDERER:String = "feathers-grouped-list-inset-last-item-renderer";

		/**
		 * DEPRECATED: Replaced by <code>GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_LAST_ITEM_RENDERER</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 2.1. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 *
		 * @see GroupedList#ALTERNATE_CHILD_STYLE_NAME_INSET_LAST_ITEM_RENDERER
		 */
		public static const ALTERNATE_CHILD_NAME_INSET_LAST_ITEM_RENDERER:String = ALTERNATE_CHILD_STYLE_NAME_INSET_LAST_ITEM_RENDERER;

		/**
		 * An alternate name to use for item renderers to give them an inset
		 * style. Typically meant to be used for the renderer of an item in a
		 * group that has no other items. This name is usually only referenced
		 * inside themes.
		 *
		 * <p>In the following example, the inset style is applied to a grouped
		 * list's single item renderer:</p>
		 *
		 * <listing version="3.0">
		 * list.customSingleItemRendererStyleName = GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_SINGLE_ITEM_RENDERER;</listing>
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const ALTERNATE_CHILD_STYLE_NAME_INSET_SINGLE_ITEM_RENDERER:String = "feathers-grouped-list-inset-single-item-renderer";

		/**
		 * DEPRECATED: Replaced by <code>GroupedList.ALTERNATE_CHILD_STYLE_NAME_INSET_SINGLE_ITEM_RENDERER</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 2.1. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 *
		 * @see GroupedList#ALTERNATE_CHILD_STYLE_NAME_INSET_SINGLE_ITEM_RENDERER
		 */
		public static const ALTERNATE_CHILD_NAME_INSET_SINGLE_ITEM_RENDERER:String = ALTERNATE_CHILD_STYLE_NAME_INSET_SINGLE_ITEM_RENDERER;

		/**
		 * @copy feathers.controls.Scroller#SCROLL_POLICY_AUTO
		 *
		 * @see feathers.controls.Scroller#horizontalScrollPolicy
		 * @see feathers.controls.Scroller#verticalScrollPolicy
		 */
		public static const SCROLL_POLICY_AUTO:String = "auto";

		/**
		 * @copy feathers.controls.Scroller#SCROLL_POLICY_ON
		 *
		 * @see feathers.controls.Scroller#horizontalScrollPolicy
		 * @see feathers.controls.Scroller#verticalScrollPolicy
		 */
		public static const SCROLL_POLICY_ON:String = "on";

		/**
		 * @copy feathers.controls.Scroller#SCROLL_POLICY_OFF
		 *
		 * @see feathers.controls.Scroller#horizontalScrollPolicy
		 * @see feathers.controls.Scroller#verticalScrollPolicy
		 */
		public static const SCROLL_POLICY_OFF:String = "off";

		/**
		 * @copy feathers.controls.Scroller#SCROLL_BAR_DISPLAY_MODE_FLOAT
		 *
		 * @see feathers.controls.Scroller#scrollBarDisplayMode
		 */
		public static const SCROLL_BAR_DISPLAY_MODE_FLOAT:String = "float";

		/**
		 * @copy feathers.controls.Scroller#SCROLL_BAR_DISPLAY_MODE_FIXED
		 *
		 * @see feathers.controls.Scroller#scrollBarDisplayMode
		 */
		public static const SCROLL_BAR_DISPLAY_MODE_FIXED:String = "fixed";

		/**
		 * @copy feathers.controls.Scroller#SCROLL_BAR_DISPLAY_MODE_NONE
		 *
		 * @see feathers.controls.Scroller#scrollBarDisplayMode
		 */
		public static const SCROLL_BAR_DISPLAY_MODE_NONE:String = "none";

		/**
		 * The vertical scroll bar will be positioned on the right.
		 *
		 * @see feathers.controls.Scroller#verticalScrollBarPosition
		 */
		public static const VERTICAL_SCROLL_BAR_POSITION_RIGHT:String = "right";

		/**
		 * The vertical scroll bar will be positioned on the left.
		 *
		 * @see feathers.controls.Scroller#verticalScrollBarPosition
		 */
		public static const VERTICAL_SCROLL_BAR_POSITION_LEFT:String = "left";

		/**
		 * @copy feathers.controls.Scroller#INTERACTION_MODE_TOUCH
		 *
		 * @see feathers.controls.Scroller#interactionMode
		 */
		public static const INTERACTION_MODE_TOUCH:String = "touch";

		/**
		 * @copy feathers.controls.Scroller#INTERACTION_MODE_MOUSE
		 *
		 * @see feathers.controls.Scroller#interactionMode
		 */
		public static const INTERACTION_MODE_MOUSE:String = "mouse";

		/**
		 * @copy feathers.controls.Scroller#INTERACTION_MODE_TOUCH_AND_SCROLL_BARS
		 *
		 * @see feathers.controls.Scroller#interactionMode
		 */
		public static const INTERACTION_MODE_TOUCH_AND_SCROLL_BARS:String = "touchAndScrollBars";

		/**
		 * @copy feathers.controls.Scroller#MOUSE_WHEEL_SCROLL_DIRECTION_VERTICAL
		 *
		 * @see feathers.controls.Scroller#verticalMouseWheelScrollDirection
		 */
		public static const MOUSE_WHEEL_SCROLL_DIRECTION_VERTICAL:String = "vertical";

		/**
		 * @copy feathers.controls.Scroller#MOUSE_WHEEL_SCROLL_DIRECTION_HORIZONTAL
		 *
		 * @see feathers.controls.Scroller#verticalMouseWheelScrollDirection
		 */
		public static const MOUSE_WHEEL_SCROLL_DIRECTION_HORIZONTAL:String = "horizontal";

		/**
		 * @copy feathers.controls.Scroller#DECELERATION_RATE_NORMAL
		 *
		 * @see feathers.controls.Scroller#decelerationRate
		 */
		public static const DECELERATION_RATE_NORMAL:Number = 0.998;

		/**
		 * @copy feathers.controls.Scroller#DECELERATION_RATE_FAST
		 *
		 * @see feathers.controls.Scroller#decelerationRate
		 */
		public static const DECELERATION_RATE_FAST:Number = 0.99;

		/**
		 * Constructor.
		 */
		public function GroupedList()
		{
			super();
		}

		/**
		 * @private
		 * The guts of the List's functionality. Handles layout and selection.
		 */
		protected var dataViewPort:GroupedListDataViewPort;

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return GroupedList.globalStyleProvider;
		}

		/**
		 * @private
		 */
		override public function get isFocusEnabled():Boolean
		{
			return (this._isSelectable || this._minHorizontalScrollPosition != this._maxHorizontalScrollPosition ||
				this._minVerticalScrollPosition != this._maxVerticalScrollPosition) &&
				this._isEnabled && this._isFocusEnabled;
		}

		/**
		 * @private
		 */
		protected var _isChildFocusEnabled:Boolean = true;

		/**
		 * @copy feathers.core.IFocusContainer#isChildFocusEnabled
		 *
		 * @default true
		 *
		 * @see #isFocusEnabled
		 */
		public function get isChildFocusEnabled():Boolean
		{
			return this._isEnabled && this._isChildFocusEnabled;
		}

		/**
		 * @private
		 */
		public function set isChildFocusEnabled(value:Boolean):void
		{
			this._isChildFocusEnabled = value;
		}

		/**
		 * @private
		 */
		protected var _layout:ILayout;

		/**
		 * The layout algorithm used to position and, optionally, size the
		 * list's items.
		 *
		 * <p>By default, if no layout is provided by the time that the list
		 * initializes, a vertical layout with options targeted at touch screens
		 * is created.</p>
		 *
		 * <p>The following example tells the list to use a horizontal layout:</p>
		 *
		 * <listing version="3.0">
		 * var layout:HorizontalLayout = new HorizontalLayout();
		 * layout.gap = 20;
		 * layout.padding = 20;
		 * list.layout = layout;</listing>
		 */
		public function get layout():ILayout
		{
			return this._layout;
		}

		/**
		 * @private
		 */
		public function set layout(value:ILayout):void
		{
			if(this._layout == value)
			{
				return;
			}
			if(this._layout)
			{
				this._layout.removeEventListener(Event.SCROLL, layout_scrollHandler);
			}
			this._layout = value;
			if(this._layout is IVariableVirtualLayout)
			{
				this._layout.addEventListener(Event.SCROLL, layout_scrollHandler);
			}
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
		}

		/**
		 * @private
		 */
		protected var _dataProvider:HierarchicalCollection;

		/**
		 * The collection of data displayed by the list. Changing this property
		 * to a new value is considered a drastic change to the list's data, so
		 * the horizontal and vertical scroll positions will be reset, and the
		 * list's selection will be cleared.
		 *
		 * <p>The following example passes in a data provider and tells the item
		 * renderer how to interpret the data:</p>
		 *
		 * <listing version="3.0">
		 * list.dataProvider = new HierarchicalCollection(
		 * [
		 *     {
		 *     	   header: "Dairy",
		 *     	   children:
		 *     	   [
		 *     	       { text: "Milk", thumbnail: textureAtlas.getTexture( "milk" ) },
		 *     	       { text: "Cheese", thumbnail: textureAtlas.getTexture( "cheese" ) },
		 *     	   ]
		 *     },
		 *     {
		 *         header: "Bakery",
		 *         children:
		 *         [
		 *             { text: "Bread", thumbnail: textureAtlas.getTexture( "bread" ) },
		 *         ]
		 *     },
		 *     {
		 *         header: "Produce",
		 *         children:
		 *         [
		 *             { text: "Bananas", thumbnail: textureAtlas.getTexture( "bananas" ) },
		 *             { text: "Lettuce", thumbnail: textureAtlas.getTexture( "lettuce" ) },
		 *             { text: "Onion", thumbnail: textureAtlas.getTexture( "onion" ) },
		 *         ]
		 *     },
		 * ]);
		 *
		 * list.itemRendererFactory = function():IGroupedListItemRenderer
		 * {
		 *     var renderer:DefaultGroupedListItemRenderer = new DefaultGroupedListItemRenderer();
		 *     renderer.labelField = "text";
		 *     renderer.iconSourceField = "thumbnail";
		 *     return renderer;
		 * };</listing>
		 *
		 * <p>By default, a <code>HierarchicalCollection</code> accepts an
		 * <code>Array</code> containing objects for each group. By default, the
		 * <code>header</code> and <code>footer</code> fields in each group will
		 * contain data to pass to the header and footer renderers of the
		 * grouped list. The <code>children</code> field of each group should be
		 * be an <code>Array</code> of data where each item is passed to an item
		 * renderer.</p>
		 *
		 * <p>A custom <em>data descriptor</em> may be passed to the
		 * <code>HierarchicalCollection</code> to tell it to parse the data
		 * source differently than the default behavior described above. For
		 * instance, you might want to use <code>Vector</code> instead of
		 * <code>Array</code> or structure the data differently. Custom data
		 * descriptors may be implemented with the
		 * <code>IHierarchicalCollectionDataDescriptor</code> interface.</p>
		 *
		 * <p><em>Warning:</em> A grouped list's data provider cannot contain
		 * duplicate items. To display the same item in multiple item renderers,
		 * you must create separate objects with the same properties. This
		 * limitation exists because it significantly improves performance.</p>
		 *
		 * <p><em>Warning:</em> If the data provider contains display objects,
		 * concrete textures, or anything that needs to be disposed, those
		 * objects will not be automatically disposed when the grouped list is
		 * disposed. Similar to how <code>starling.display.Image</code> cannot
		 * automatically dispose its texture because the texture may be used
		 * by other display objects, a list cannot dispose its data provider
		 * because the data provider may be used by other lists. See the
		 * <code>dispose()</code> function on <code>HierarchicalCollection</code>
		 * to see how the data provider can be disposed properly.</p>
		 *
		 * @default null
		 *
		 * @see feathers.data.HierarchicalCollection
		 * @see feathers.data.IHierarchicalCollectionDataDescriptor
		 */
		public function get dataProvider():HierarchicalCollection
		{
			return this._dataProvider;
		}

		/**
		 * @private
		 */
		public function set dataProvider(value:HierarchicalCollection):void
		{
			if(this._dataProvider == value)
			{
				return;
			}
			if(this._dataProvider)
			{
				this._dataProvider.removeEventListener(CollectionEventType.ADD_ITEM, dataProvider_addItemHandler);
				this._dataProvider.removeEventListener(CollectionEventType.REMOVE_ITEM, dataProvider_removeItemHandler);
				this._dataProvider.removeEventListener(CollectionEventType.REPLACE_ITEM, dataProvider_replaceItemHandler);
				this._dataProvider.removeEventListener(CollectionEventType.RESET, dataProvider_resetHandler);
				this._dataProvider.removeEventListener(Event.CHANGE, dataProvider_changeHandler);
			}
			this._dataProvider = value;
			if(this._dataProvider)
			{
				this._dataProvider.addEventListener(CollectionEventType.ADD_ITEM, dataProvider_addItemHandler);
				this._dataProvider.addEventListener(CollectionEventType.REMOVE_ITEM, dataProvider_removeItemHandler);
				this._dataProvider.addEventListener(CollectionEventType.REPLACE_ITEM, dataProvider_replaceItemHandler);
				this._dataProvider.addEventListener(CollectionEventType.RESET, dataProvider_resetHandler);
				this._dataProvider.addEventListener(Event.CHANGE, dataProvider_changeHandler);
			}

			//reset the scroll position because this is a drastic change and
			//the data is probably completely different
			this.horizontalScrollPosition = 0;
			this.verticalScrollPosition = 0;

			//clear the selection for the same reason
			this.setSelectedLocation(-1, -1);

			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _isSelectable:Boolean = true;

		/**
		 * Determines if an item in the list may be selected.
		 *
		 * <p>The following example disables selection:</p>
		 *
		 * <listing version="3.0">
	 	 * list.isSelectable = false;</listing>
		 *
		 * @default true
		 */
		public function get isSelectable():Boolean
		{
			return this._isSelectable;
		}

		/**
		 * @private
		 */
		public function set isSelectable(value:Boolean):void
		{
			if(this._isSelectable == value)
			{
				return;
			}
			this._isSelectable = value;
			if(!this._isSelectable)
			{
				this.setSelectedLocation(-1, -1);
			}
			this.invalidate(INVALIDATION_FLAG_SELECTED);
		}

		/**
		 * @private
		 */
		protected var _selectedGroupIndex:int = -1;

		/**
		 * The group index of the currently selected item. Returns <code>-1</code>
		 * if no item is selected.
		 *
		 * <p>Because the selection consists of both a group index and an item
		 * index, this property does not have a setter. To change the selection,
		 * call <code>setSelectedLocation()</code> instead.</p>
		 *
		 * <p>The following example listens for when selection changes and
		 * requests the selected group index and selected item index:</p>
		 *
		 * <listing version="3.0">
		 * function list_changeHandler( event:Event ):void
		 * {
		 *     var list:List = GroupedList(event.currentTarget);
		 *     var groupIndex:int = list.selectedGroupIndex;
		 *     var itemIndex:int = list.selectedItemIndex;
		 *
		 * }
		 * list.addEventListener( Event.CHANGE, list_changeHandler );</listing>
		 *
		 * @default -1
		 *
		 * @see #selectedItemIndex
		 * @see #setSelectedLocation()
		 */
		public function get selectedGroupIndex():int
		{
			return this._selectedGroupIndex;
		}

		/**
		 * @private
		 */
		protected var _selectedItemIndex:int = -1;

		/**
		 * The item index of the currently selected item. Returns <code>-1</code>
		 * if no item is selected.
		 *
		 * <p>Because the selection consists of both a group index and an item
		 * index, this property does not have a setter. To change the selection,
		 * call <code>setSelectedLocation()</code> instead.</p>
		 *
		 * <p>The following example listens for when selection changes and
		 * requests the selected group index and selected item index:</p>
		 *
		 * <listing version="3.0">
		 * function list_changeHandler( event:Event ):void
		 * {
		 *     var list:GroupedList = GroupedList( event.currentTarget );
		 *     var groupIndex:int = list.selectedGroupIndex;
		 *     var itemIndex:int = list.selectedItemIndex;
		 *
		 * }
		 * list.addEventListener( Event.CHANGE, list_changeHandler );</listing>
		 *
		 * @default -1
		 *
		 * @see #selectedGroupIndex
		 * @see #setSelectedLocation()
		 */
		public function get selectedItemIndex():int
		{
			return this._selectedItemIndex;
		}

		/**
		 * The currently selected item. Returns <code>null</code> if no item is
		 * selected.
		 *
		 * <p>The following example listens for when selection changes and
		 * requests the selected item:</p>
		 *
		 * <listing version="3.0">
		 * function list_changeHandler( event:Event ):void
		 * {
		 *     var list:GroupedList = GroupedList( event.currentTarget );
		 *     var item:Object = list.selectedItem;
		 *
		 * }
		 * list.addEventListener( Event.CHANGE, list_changeHandler );</listing>
		 *
		 * @default null
		 */
		public function get selectedItem():Object
		{
			if(!this._dataProvider || this._selectedGroupIndex < 0 || this._selectedItemIndex < 0)
			{
				return null;
			}
			return this._dataProvider.getItemAt(this._selectedGroupIndex, this._selectedItemIndex);
		}

		/**
		 * @private
		 */
		public function set selectedItem(value:Object):void
		{
			if(!this._dataProvider)
			{
				this.setSelectedLocation(-1, -1);
				return;
			}
			var result:Vector.<int> = this._dataProvider.getItemLocation(value);
			if(result.length == 2)
			{
				this.setSelectedLocation(result[0], result[1]);
			}
			else
			{
				this.setSelectedLocation(-1, -1);
			}
		}

		/**
		 * @private
		 */
		protected var _itemRendererType:Class = DefaultGroupedListItemRenderer;

		/**
		 * The class used to instantiate item renderers. Must implement the
		 * <code>IGroupedListItemRenderer</code> interface.
		 *
		 * <p>To customize properties on the item renderer, use
		 * <code>itemRendererFactory</code> instead.</p>
		 *
		 * <p>The following example changes the item renderer type:</p>
		 *
		 * <listing version="3.0">
		 * list.itemRendererType = CustomItemRendererClass;</listing>
		 *
		 * <p>The first item and last item in a group may optionally use
		 * different item renderer types, if desired. Use the
		 * <code>firstItemRendererType</code> and <code>lastItemRendererType</code>,
		 * respectively. Additionally, if a group contains only one item, it may
		 * also have a different type. Use the <code>singleItemRendererType</code>.
		 * Finally, factories for each of these types may also be customized.</p>
		 *
		 * @default feathers.controls.renderers.DefaultGroupedListItemRenderer
		 *
		 * @see feathers.controls.renderers.IGroupedListItemRenderer
		 * @see #itemRendererFactory
		 * @see #firstItemRendererType
		 * @see #lastItemRendererType
		 * @see #singleItemRendererType
		 */
		public function get itemRendererType():Class
		{
			return this._itemRendererType;
		}

		/**
		 * @private
		 */
		public function set itemRendererType(value:Class):void
		{
			if(this._itemRendererType == value)
			{
				return;
			}

			this._itemRendererType = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _itemRendererFactory:Function;

		/**
		 * A function called that is expected to return a new item renderer. Has
		 * a higher priority than <code>itemRendererType</code>. Typically, you
		 * would use an <code>itemRendererFactory</code> instead of an
		 * <code>itemRendererType</code> if you wanted to initialize some
		 * properties on each separate item renderer, such as skins.
		 *
		 * <p>The function is expected to have the following signature:</p>
		 *
		 * <pre>function():IGroupedListItemRenderer</pre>
		 *
		 * <p>The following example provides a factory for the item renderer:</p>
		 *
		 * <listing version="3.0">
		 * list.itemRendererFactory = function():IGroupedListItemRenderer
		 * {
		 *     var renderer:CustomItemRendererClass = new CustomItemRendererClass();
		 *     renderer.backgroundSkin = new Quad( 10, 10, 0xff0000 );
		 *     return renderer;
		 * };</listing>
		 *
		 * <p>The first item and last item in a group may optionally use
		 * different item renderer factories, if desired. Use the
		 * <code>firstItemRendererFactory</code> and <code>lastItemRendererFactory</code>,
		 * respectively. Additionally, if a group contains only one item, it may
		 * also have a different factory. Use the <code>singleItemRendererFactory</code>.</p>
		 *
		 * @default null
		 *
		 * @see feathers.controls.renderers.IGroupedListItemRenderer
		 * @see #itemRendererType
		 * @see #firstItemRendererFactory
		 * @see #lastItemRendererFactory
		 * @see #singleItemRendererFactory
		 */
		public function get itemRendererFactory():Function
		{
			return this._itemRendererFactory;
		}

		/**
		 * @private
		 */
		public function set itemRendererFactory(value:Function):void
		{
			if(this._itemRendererFactory === value)
			{
				return;
			}

			this._itemRendererFactory = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _typicalItem:Object = null;

		/**
		 * Used to auto-size the list when a virtualized layout is used. If the
		 * list's width or height is unknown, the list will try to automatically
		 * pick an ideal size. This item is used to create a sample item
		 * renderer to measure item renderers that are virtual and not visible
		 * in the viewport.
		 *
		 * <p>The following example provides a typical item:</p>
		 *
		 * <listing version="3.0">
		 * list.typicalItem = { text: "A typical item", thumbnail: texture };
		 * list.itemRendererProperties.labelField = "text";
		 * list.itemRendererProperties.iconSourceField = "thumbnail";</listing>
		 *
		 * @default null
		 */
		public function get typicalItem():Object
		{
			return this._typicalItem;
		}

		/**
		 * @private
		 */
		public function set typicalItem(value:Object):void
		{
			if(this._typicalItem == value)
			{
				return;
			}
			this._typicalItem = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _customItemRendererStyleName:String;

		/**
		 * A style name to add to all item renderers in this list. Typically
		 * used by a theme to provide different styles to different grouped
		 * lists.
		 *
		 * <p>The following example sets the item renderer style name:</p>
		 *
		 * <listing version="3.0">
		 * list.customItemRendererStyleName = "my-custom-item-renderer";</listing>
		 *
		 * <p>In your theme, you can target this sub-component style name to
		 * provide different skins than the default:</p>
		 *
		 * <listing version="3.0">
		 * getStyleProviderForClass( DefaultGroupedListItemRenderer ).setFunctionForStyleName( "my-custom-item-renderer", setCustomItemRendererStyles );</listing>
		 *
		 * @default null
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 * @see #customFirstItemRendererStyleName
		 * @see #customLastItemRendererStyleName
		 * @see #customSingleItemRendererStyleName
		 */
		public function get customItemRendererStyleName():String
		{
			return this._customItemRendererStyleName;
		}

		/**
		 * @private
		 */
		public function set customItemRendererStyleName(value:String):void
		{
			if(this._customItemRendererStyleName == value)
			{
				return;
			}
			this._customItemRendererStyleName = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * DEPRECATED: Replaced by <code>customItemRendererStyleName</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 2.1. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 *
		 * @see #customItemRendererStyleName
		 */
		public function get itemRendererName():String
		{
			return this.customItemRendererStyleName;
		}

		/**
		 * @private
		 */
		public function set itemRendererName(value:String):void
		{
			this.customItemRendererStyleName = value;
		}

		/**
		 * @private
		 */
		protected var _itemRendererProperties:PropertyProxy;

		/**
		 * A set of key/value pairs to be passed down to all of the list's item
		 * renderers. These values are shared by each item renderer, so values
		 * that cannot be shared (such as display objects that need to be added
		 * to the display list) should be passed to the item renderers using the
		 * <code>itemRendererFactory</code> or with a theme. The item renderers
		 * are instances of <code>IGroupedListItemRenderer</code>. The available
		 * properties depend on which <code>IGroupedListItemRenderer</code>
		 * implementation is returned by <code>itemRendererFactory</code>.
		 *
		 * <p>The following example customizes some item renderer properties
		 * (this example assumes that the item renderer's label text renderer
		 * is a <code>BitmapFontTextRenderer</code>):</p>
		 *
		 * <listing version="3.0">
		 * list.itemRendererProperties.&#64;defaultLabelProperties.textFormat = new BitmapFontTextFormat( bitmapFont );
		 * list.itemRendererProperties.padding = 20;</listing>
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
		 * which is in a <code>List</code>, you can use the following syntax:</p>
		 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * <p>Setting properties in a <code>itemRendererFactory</code> function instead
		 * of using <code>itemRendererProperties</code> will result in better
		 * performance.</p>
		 *
		 * @default null
		 *
		 * @see #itemRendererFactory
		 * @see feathers.controls.renderers.IGroupedListItemRenderer
		 * @see feathers.controls.renderers.DefaultGroupedListItemRenderer
		 */
		public function get itemRendererProperties():Object
		{
			if(!this._itemRendererProperties)
			{
				this._itemRendererProperties = new PropertyProxy(childProperties_onChange);
			}
			return this._itemRendererProperties;
		}

		/**
		 * @private
		 */
		public function set itemRendererProperties(value:Object):void
		{
			if(this._itemRendererProperties == value)
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
			if(this._itemRendererProperties)
			{
				this._itemRendererProperties.removeOnChangeCallback(childProperties_onChange);
			}
			this._itemRendererProperties = PropertyProxy(value);
			if(this._itemRendererProperties)
			{
				this._itemRendererProperties.addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _firstItemRendererType:Class;

		/**
		 * The class used to instantiate the item renderer for the first item in
		 * a group. Must implement the <code>IGroupedListItemRenderer</code>
		 * interface.
		 *
		 * <p>The following example changes the first item renderer type:</p>
		 *
		 * <listing version="3.0">
		 * list.firstItemRendererType = CustomItemRendererClass;</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.renderer.IGroupedListItemRenderer
		 * @see #itemRendererType
		 * @see #lastItemRendererType
		 * @see #singleItemRendererType
		 */
		public function get firstItemRendererType():Class
		{
			return this._firstItemRendererType;
		}

		/**
		 * @private
		 */
		public function set firstItemRendererType(value:Class):void
		{
			if(this._firstItemRendererType == value)
			{
				return;
			}

			this._firstItemRendererType = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _firstItemRendererFactory:Function;

		/**
		 * A function called that is expected to return a new item renderer for
		 * the first item in a group. Has a higher priority than
		 * <code>firstItemRendererType</code>. Typically, you would use an
		 * <code>firstItemRendererFactory</code> instead of an
		 * <code>firstItemRendererType</code> if you wanted to initialize some
		 * properties on each separate item renderer, such as skins.
		 *
		 * <p>The function is expected to have the following signature:</p>
		 *
		 * <pre>function():IGroupedListItemRenderer</pre>
		 *
		 * <p>The following example provides a factory for the item renderer
		 * used for the first item in a group:</p>
		 *
		 * <listing version="3.0">
		 * list.firstItemRendererFactory = function():IGroupedListItemRenderer
		 * {
		 *     var renderer:CustomItemRendererClass = new CustomItemRendererClass();
		 *     renderer.backgroundSkin = new Quad( 10, 10, 0xff0000 );
		 *     return renderer;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.renderers.IGroupedListItemRenderer
		 * @see #firstItemRendererType
		 * @see #itemRendererFactory
		 * @see #lastItemRendererFactory
		 * @see #singleItemRendererFactory
		 */
		public function get firstItemRendererFactory():Function
		{
			return this._firstItemRendererFactory;
		}

		/**
		 * @private
		 */
		public function set firstItemRendererFactory(value:Function):void
		{
			if(this._firstItemRendererFactory === value)
			{
				return;
			}

			this._firstItemRendererFactory = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _customFirstItemRendererStyleName:String;

		/**
		 * A style name to add to all item renderers in this grouped list that
		 * are the first item in a group. Typically used by a theme to provide
		 * different styles to different grouped lists, and to differentiate
		 * first items from regular items if they are created with the same
		 * class. If this value is <code>null</code>, the regular
		 * <code>customItemRendererStyleName</code> will be used instead.
		 *
		 * <p>The following example provides a style name for the first item
		 * renderer in each group:</p>
		 *
		 * <listing version="3.0">
		 * list.customFirstItemRendererStyleName = "my-custom-first-item-renderer";</listing>
		 *
		 * <p>In your theme, you can target this sub-component style name to
		 * provide different styles than the default:</p>
		 *
		 * <listing version="3.0">
		 * getStyleProviderForClass( DefaultGroupedListItemRenderer ).setFunctionForStyleName( "my-custom-first-item-renderer", setCustomFirstItemRendererStyles );</listing>
		 *
		 * @default null
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 * @see #customItemRendererStyleName
		 * @see #customLastItemRendererStyleName
		 * @see #customSingleItemRendererStyleName
		 */
		public function get customFirstItemRendererStyleName():String
		{
			return this._customFirstItemRendererStyleName;
		}

		/**
		 * @private
		 */
		public function set customFirstItemRendererStyleName(value:String):void
		{
			if(this._customFirstItemRendererStyleName == value)
			{
				return;
			}
			this._customFirstItemRendererStyleName = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * DEPRECATED: Replaced by <code>customFirstItemRendererStyleName</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 2.1. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 *
		 * @see #customFirstItemRendererStyleName
		 */
		public function get firstItemRendererName():String
		{
			return this.customFirstItemRendererStyleName;
		}

		/**
		 * @private
		 */
		public function set firstItemRendererName(value:String):void
		{
			this.customFirstItemRendererStyleName = value;
		}

		/**
		 * @private
		 */
		protected var _lastItemRendererType:Class;

		/**
		 * The class used to instantiate the item renderer for the last item in
		 * a group. Must implement the <code>IGroupedListItemRenderer</code>
		 * interface.
		 *
		 * <p>The following example changes the last item renderer type:</p>
		 *
		 * <listing version="3.0">
		 * list.lastItemRendererType = CustomItemRendererClass;</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.renderer.IGroupedListItemRenderer
		 * @see #lastItemRendererFactory
		 * @see #itemRendererType
		 * @see #firstItemRendererType
		 * @see #singleItemRendererType
		 */
		public function get lastItemRendererType():Class
		{
			return this._lastItemRendererType;
		}

		/**
		 * @private
		 */
		public function set lastItemRendererType(value:Class):void
		{
			if(this._lastItemRendererType == value)
			{
				return;
			}

			this._lastItemRendererType = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _lastItemRendererFactory:Function;

		/**
		 * A function called that is expected to return a new item renderer for
		 * the last item in a group. Has a higher priority than
		 * <code>lastItemRendererType</code>. Typically, you would use an
		 * <code>lastItemRendererFactory</code> instead of an
		 * <code>lastItemRendererType</code> if you wanted to initialize some
		 * properties on each separate item renderer, such as skins.
		 *
		 * <p>The function is expected to have the following signature:</p>
		 *
		 * <pre>function():IGroupedListItemRenderer</pre>
		 *
		 * <p>The following example provides a factory for the item renderer
		 * used for the last item in a group:</p>
		 *
		 * <listing version="3.0">
		 * list.firstItemRendererFactory = function():IGroupedListItemRenderer
		 * {
		 *     var renderer:CustomItemRendererClass = new CustomItemRendererClass();
		 *     renderer.backgroundSkin = new Quad( 10, 10, 0xff0000 );
		 *     return renderer;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.renderers.IGroupedListItemRenderer
		 * @see #lastItemRendererType
		 * @see #itemRendererFactory
		 * @see #firstItemRendererFactory
		 * @see #singleItemRendererFactory
		 */
		public function get lastItemRendererFactory():Function
		{
			return this._lastItemRendererFactory;
		}

		/**
		 * @private
		 */
		public function set lastItemRendererFactory(value:Function):void
		{
			if(this._lastItemRendererFactory === value)
			{
				return;
			}

			this._lastItemRendererFactory = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _customLastItemRendererStyleName:String;

		/**
		 * A style name to add to all item renderers in this grouped list that
		 * are the last item in a group. Typically used by a theme to provide
		 * different styles to different grouped lists, and to differentiate
		 * last items from regular items if they are created with the same
		 * class. If this value is <code>null</code> the regular
		 * <code>customItemRendererStyleName</code> will be used instead.
		 *
		 * <p>The following example provides a style name for the last item
		 * renderer in each group:</p>
		 *
		 * <listing version="3.0">
		 * list.customLastItemRendererStyleName = "my-custom-last-item-renderer";</listing>
		 *
		 * <p>In your theme, you can target this sub-component style name to
		 * provide different styles than the default:</p>
		 *
		 * <listing version="3.0">
		 * getStyleProviderForClass( DefaultGroupedListItemRenderer ).setFunctionForStyleName( "my-custom-last-item-renderer", setCustomLastItemRendererStyles );</listing>
		 *
		 * @default null
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 * @see #customItemRendererStyleName
		 * @see #customFirstItemRendererStyleName
		 * @see #customSingleItemRendererStyleName
		 */
		public function get customLastItemRendererStyleName():String
		{
			return this._customLastItemRendererStyleName;
		}

		/**
		 * @private
		 */
		public function set customLastItemRendererStyleName(value:String):void
		{
			if(this._customLastItemRendererStyleName == value)
			{
				return;
			}
			this._customLastItemRendererStyleName = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * DEPRECATED: Replaced by <code>customLastItemRendererStyleName</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 2.1. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 *
		 * @see #customLastItemRendererStyleName
		 */
		public function get lastItemRendererName():String
		{
			return this.customLastItemRendererStyleName;
		}

		/**
		 * @private
		 */
		public function set lastItemRendererName(value:String):void
		{
			this.customLastItemRendererStyleName = value;
		}

		/**
		 * @private
		 */
		protected var _singleItemRendererType:Class;

		/**
		 * The class used to instantiate the item renderer for an item in a
		 * group with no other items. Must implement the
		 * <code>IGroupedListItemRenderer</code> interface.
		 *
		 * <p>The following example changes the single item renderer type:</p>
		 *
		 * <listing version="3.0">
		 * list.singleItemRendererType = CustomItemRendererClass;</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.renderer.IGroupedListItemRenderer
		 * @see #singleItemRendererFactory
		 * @see #itemRendererType
		 * @see #firstItemRendererType
		 * @see #lastItemRendererType
		 */
		public function get singleItemRendererType():Class
		{
			return this._singleItemRendererType;
		}

		/**
		 * @private
		 */
		public function set singleItemRendererType(value:Class):void
		{
			if(this._singleItemRendererType == value)
			{
				return;
			}

			this._singleItemRendererType = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _singleItemRendererFactory:Function;

		/**
		 * A function called that is expected to return a new item renderer for
		 * an item in a group with no other items. Has a higher priority than
		 * <code>singleItemRendererType</code>. Typically, you would use an
		 * <code>singleItemRendererFactory</code> instead of an
		 * <code>singleItemRendererType</code> if you wanted to initialize some
		 * properties on each separate item renderer, such as skins.
		 *
		 * <p>The function is expected to have the following signature:</p>
		 *
		 * <pre>function():IGroupedListItemRenderer</pre>
		 *
		 * <p>The following example provides a factory for the item renderer
		 * used for when only one item appears in a group:</p>
		 *
		 * <listing version="3.0">
		 * list.firstItemRendererFactory = function():IGroupedListItemRenderer
		 * {
		 *     var renderer:CustomItemRendererClass = new CustomItemRendererClass();
		 *     renderer.backgroundSkin = new Quad( 10, 10, 0xff0000 );
		 *     return renderer;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.renderers.IGroupedListItemRenderer
		 * @see #singleItemRendererType
		 * @see #itemRendererFactory
		 * @see #firstItemRendererFactory
		 * @see #lastItemRendererFactory
		 */
		public function get singleItemRendererFactory():Function
		{
			return this._singleItemRendererFactory;
		}

		/**
		 * @private
		 */
		public function set singleItemRendererFactory(value:Function):void
		{
			if(this._singleItemRendererFactory === value)
			{
				return;
			}

			this._singleItemRendererFactory = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _customSingleItemRendererStyleName:String;

		/**
		 * A style name to add to all item renderers in this grouped list that
		 * are a single item in a group with no other items. Typically used by a
		 * theme to provide different styles to different grouped lists, and to
		 * differentiate single items from regular items if they are created
		 * with the same class. If this value is <code>null</code> the regular
		 * <code>customItemRendererStyleName</code> will be used instead.
		 *
		 * <p>The following example provides a style name for a single item
		 * renderer in each group:</p>
		 *
		 * <listing version="3.0">
		 * list.customSingleItemRendererStyleName = "my-custom-single-item-renderer";</listing>
		 *
		 * <p>In your theme, you can target this sub-component style name to
		 * provide different skins than the default style:</p>
		 *
		 * <listing version="3.0">
		 * getStyleProviderForClass( DefaultGroupedListItemRenderer ).setFunctionForStyleName( "my-custom-single-item-renderer", setCustomSingleItemRendererStyles );</listing>
		 *
		 * @default null
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 * @see #customItemRendererStyleName
		 * @see #customFirstItemRendererStyleName
		 * @see #customLastItemRendererStyleName
		 */
		public function get customSingleItemRendererStyleName():String
		{
			return this._customSingleItemRendererStyleName;
		}

		/**
		 * @private
		 */
		public function set customSingleItemRendererStyleName(value:String):void
		{
			if(this._customSingleItemRendererStyleName == value)
			{
				return;
			}
			this._customSingleItemRendererStyleName = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * DEPRECATED: Replaced by <code>customLastItemRendererStyleName</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 2.1. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 *
		 * @see #customLastItemRendererStyleName
		 */
		public function get singleItemRendererName():String
		{
			return this.customSingleItemRendererStyleName;
		}

		/**
		 * @private
		 */
		public function set singleItemRendererName(value:String):void
		{
			this.customSingleItemRendererStyleName = value;
		}

		/**
		 * @private
		 */
		protected var _headerRendererType:Class = DefaultGroupedListHeaderOrFooterRenderer;

		/**
		 * The class used to instantiate header renderers. Must implement the
		 * <code>IGroupedListHeaderOrFooterRenderer</code> interface.
		 *
		 * <p>The following example changes the header renderer type:</p>
		 *
		 * <listing version="3.0">
		 * list.headerRendererType = CustomHeaderRendererClass;</listing>
		 *
		 * @default feathers.controls.renderers.DefaultGroupedListHeaderOrFooterRenderer
		 *
		 * @see feathers.controls.renderers.IGroupedListHeaderOrFooterRenderer
		 * @see #headerRendererFactory
		 */
		public function get headerRendererType():Class
		{
			return this._headerRendererType;
		}

		/**
		 * @private
		 */
		public function set headerRendererType(value:Class):void
		{
			if(this._headerRendererType == value)
			{
				return;
			}

			this._headerRendererType = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _headerRendererFactory:Function;

		/**
		 * A function called that is expected to return a new header renderer.
		 * Has a higher priority than <code>headerRendererType</code>.
		 * Typically, you would use an <code>headerRendererFactory</code>
		 * instead of a <code>headerRendererType</code> if you wanted to
		 * initialize some properties on each separate header renderer, such as
		 * skins.
		 *
		 * <p>The function is expected to have the following signature:</p>
		 *
		 * <pre>function():IGroupedListHeaderOrFooterRenderer</pre>
		 *
		 * <p>The following example provides a factory for the header renderer:</p>
		 *
		 * <listing version="3.0">
		 * list.itemRendererFactory = function():IGroupedListHeaderOrFooterRenderer
		 * {
		 *     var renderer:CustomHeaderRendererClass = new CustomHeaderRendererClass();
		 *     renderer.backgroundSkin = new Quad( 10, 10, 0xff0000 );
		 *     return renderer;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.renderers.IGroupedListHeaderOrFooterRenderer
		 * @see #headerRendererType
		 */
		public function get headerRendererFactory():Function
		{
			return this._headerRendererFactory;
		}

		/**
		 * @private
		 */
		public function set headerRendererFactory(value:Function):void
		{
			if(this._headerRendererFactory === value)
			{
				return;
			}

			this._headerRendererFactory = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _customHeaderRendererStyleName:String = DEFAULT_CHILD_STYLE_NAME_HEADER_RENDERER;

		/**
		 * A style name to add to all header renderers in this grouped list.
		 * Typically used by a theme to provide different styles to different
		 * grouped lists.
		 *
		 * <p>The following example sets the header renderer style name:</p>
		 *
		 * <listing version="3.0">
		 * list.customHeaderRendererStyleName = "my-custom-header-renderer";</listing>
		 *
		 * <p>In your theme, you can target this sub-component style name to
		 * provide different skins than the default:</p>
		 *
		 * <listing version="3.0">
		 * getStyleProviderForClass( DefaultGroupedListHeaderOrFooterRenderer ).setFunctionForStyleName( "my-custom-header-renderer", setCustomHeaderRendererStyles );</listing>
		 *
		 * @default null
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public function get customHeaderRendererStyleName():String
		{
			return this._customHeaderRendererStyleName;
		}

		/**
		 * @private
		 */
		public function set customHeaderRendererStyleName(value:String):void
		{
			if(this._customHeaderRendererStyleName == value)
			{
				return;
			}
			this._customHeaderRendererStyleName = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * DEPRECATED: Replaced by <code>customHeaderRendererStyleName</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 2.1. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 *
		 * @see #customHeaderRendererStyleName
		 */
		public function get headerRendererName():String
		{
			return this.customHeaderRendererStyleName;
		}

		/**
		 * @private
		 */
		public function set headerRendererName(value:String):void
		{
			this.customHeaderRendererStyleName = value;
		}

		/**
		 * @private
		 */
		protected var _headerRendererProperties:PropertyProxy;

		/**
		 * A set of key/value pairs to be passed down to all of the grouped
		 * list's header renderers. These values are shared by each header
		 * renderer, so values that cannot be shared (such as display objects
		 * that need to be added to the display list) should be passed to the
		 * header renderers using the <code>headerRendererFactory</code> or in a
		 * theme. The header renderers are instances of
		 * <code>IGroupedListHeaderOrFooterRenderer</code>. The available
		 * properties depend on which <code>IGroupedListItemRenderer</code>
		 * implementation is returned by <code>headerRendererFactory</code>.
		 *
		 * <p>The following example customizes some header renderer properties:</p>
		 *
		 * <listing version="3.0">
		 * list.headerRendererProperties.&#64;contentLabelProperties.textFormat = new BitmapFontTextFormat( bitmapFont );
		 * list.headerRendererProperties.padding = 20;</listing>
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
		 * which is in a <code>List</code>, you can use the following syntax:</p>
		 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * <p>Setting properties in a <code>headerRendererFactory</code> function instead
		 * of using <code>headerRendererProperties</code> will result in better
		 * performance.</p>
		 *
		 * @default null
		 *
		 * @see #headerRendererFactory
		 * @see feathers.controls.renderers.IGroupedListHeaderOrFooterRenderer
		 * @see feathers.controls.renderers.DefaultGroupedListHeaderOrFooterRenderer
		 */
		public function get headerRendererProperties():Object
		{
			if(!this._headerRendererProperties)
			{
				this._headerRendererProperties = new PropertyProxy(childProperties_onChange);
			}
			return this._headerRendererProperties;
		}

		/**
		 * @private
		 */
		public function set headerRendererProperties(value:Object):void
		{
			if(this._headerRendererProperties == value)
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
			if(this._headerRendererProperties)
			{
				this._headerRendererProperties.removeOnChangeCallback(childProperties_onChange);
			}
			this._headerRendererProperties = PropertyProxy(value);
			if(this._headerRendererProperties)
			{
				this._headerRendererProperties.addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _footerRendererType:Class = DefaultGroupedListHeaderOrFooterRenderer;

		/**
		 * The class used to instantiate footer renderers. Must implement the
		 * <code>IGroupedListHeaderOrFooterRenderer</code> interface.
		 *
		 * <p>The following example changes the footer renderer type:</p>
		 *
		 * <listing version="3.0">
		 * list.footerRendererType = CustomFooterRendererClass;</listing>
		 *
		 * @default feathers.controls.renderers.DefaultGroupedListHeaderOrFooterRenderer
		 *
		 * @see feathers.controls.renderers.IGroupedListHeaderOrFooterRenderer
		 * @see #footerRendererFactory
		 */
		public function get footerRendererType():Class
		{
			return this._footerRendererType;
		}

		/**
		 * @private
		 */
		public function set footerRendererType(value:Class):void
		{
			if(this._footerRendererType == value)
			{
				return;
			}

			this._footerRendererType = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _footerRendererFactory:Function;

		/**
		 * A function called that is expected to return a new footer renderer.
		 * Has a higher priority than <code>footerRendererType</code>.
		 * Typically, you would use an <code>footerRendererFactory</code>
		 * instead of a <code>footerRendererType</code> if you wanted to
		 * initialize some properties on each separate footer renderer, such as
		 * skins.
		 *
		 * <p>The function is expected to have the following signature:</p>
		 *
		 * <pre>function():IGroupedListHeaderOrFooterRenderer</pre>
		 *
		 * <p>The following example provides a factory for the footer renderer:</p>
		 *
		 * <listing version="3.0">
		 * list.itemRendererFactory = function():IGroupedListHeaderOrFooterRenderer
		 * {
		 *     var renderer:CustomFooterRendererClass = new CustomFooterRendererClass();
		 *     renderer.backgroundSkin = new Quad( 10, 10, 0xff0000 );
		 *     return renderer;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.renderers.IGroupedListHeaderOrFooterRenderer
		 * @see #footerRendererType
		 */
		public function get footerRendererFactory():Function
		{
			return this._footerRendererFactory;
		}

		/**
		 * @private
		 */
		public function set footerRendererFactory(value:Function):void
		{
			if(this._footerRendererFactory === value)
			{
				return;
			}

			this._footerRendererFactory = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _customFooterRendererStyleName:String = DEFAULT_CHILD_STYLE_NAME_FOOTER_RENDERER;

		/**
		 * A style name to add to all footer renderers in this grouped list.
		 * Typically used by a theme to provide different styles to different
		 * grouped lists.
		 *
		 * <p>The following example sets the footer renderer style name:</p>
		 *
		 * <listing version="3.0">
		 * list.customFooterRendererStyleName = "my-custom-footer-renderer";</listing>
		 *
		 * <p>In your theme, you can target this sub-component style name to
		 * provide different styles than the default:</p>
		 *
		 * <listing version="3.0">
		 * getStyleProviderForClass( DefaultGroupedListHeaderOrFooterRenderer ).setFunctionForStyleName( "my-custom-footer-renderer", setCustomFooterRendererStyles );</listing>
		 *
		 * @default null
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public function get customFooterRendererStyleName():String
		{
			return this._customFooterRendererStyleName;
		}

		/**
		 * @private
		 */
		public function set customFooterRendererStyleName(value:String):void
		{
			if(this._customFooterRendererStyleName == value)
			{
				return;
			}
			this._customFooterRendererStyleName = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * DEPRECATED: Replaced by <code>customFooterRendererStyleName</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 2.1. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 *
		 * @see #customFooterRendererStyleName
		 */
		public function get footerRendererName():String
		{
			return this.customFooterRendererStyleName;
		}

		/**
		 * @private
		 */
		public function set footerRendererName(value:String):void
		{
			this.customFooterRendererStyleName = value;
		}

		/**
		 * @private
		 */
		protected var _footerRendererProperties:PropertyProxy;

		/**
		 * A set of key/value pairs to be passed down to all of the grouped
		 * list's footer renderers. These values are shared by each footer
		 * renderer, so values that cannot be shared (such as display objects
		 * that need to be added to the display list) should be passed to the
		 * footer renderers using a <code>footerRendererFactory</code> or with
		 * a theme. The header renderers are instances of
		 * <code>IGroupedListHeaderOrFooterRenderer</code>. The available
		 * properties depend on which <code>IGroupedListItemRenderer</code>
		 * implementation is returned by <code>headerRendererFactory</code>.
		 *
		 * <p>The following example customizes some header renderer properties:</p>
		 *
		 * <listing version="3.0">
		 * list.footerRendererProperties.&#64;contentLabelProperties.textFormat = new BitmapFontTextFormat( bitmapFont );
		 * list.footerRendererProperties.padding = 20;</listing>
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
		 * which is in a <code>List</code>, you can use the following syntax:</p>
		 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * <p>Setting properties in a <code>footerRendererFactory</code> function instead
		 * of using <code>footerRendererProperties</code> will result in better
		 * performance.</p>
		 *
		 * @default null
		 *
		 * @see #footerRendererFactory
		 * @see feathers.controls.renderers.IGroupedListHeaderOrFooterRenderer
		 * @see feathers.controls.renderers.DefaultGroupedListHeaderOrFooterRenderer
		 */
		public function get footerRendererProperties():Object
		{
			if(!this._footerRendererProperties)
			{
				this._footerRendererProperties = new PropertyProxy(childProperties_onChange);
			}
			return this._footerRendererProperties;
		}

		/**
		 * @private
		 */
		public function set footerRendererProperties(value:Object):void
		{
			if(this._footerRendererProperties == value)
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
			if(this._footerRendererProperties)
			{
				this._footerRendererProperties.removeOnChangeCallback(childProperties_onChange);
			}
			this._footerRendererProperties = PropertyProxy(value);
			if(this._footerRendererProperties)
			{
				this._footerRendererProperties.addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _headerField:String = "header";

		/**
		 * The field in a group that contains the data for a header. If the
		 * group does not have this field, and a <code>headerFunction</code> is
		 * not defined, then no header will be displayed for the group. In other
		 * words, a header is optional, and a group may not have one.
		 *
		 * <p>All of the header fields and functions, ordered by priority:</p>
		 * <ol>
		 *     <li><code>headerFunction</code></li>
		 *     <li><code>headerField</code></li>
		 * </ol>
		 *
		 * <p>The following example sets the header field:</p>
		 *
		 * <listing version="3.0">
		 * list.headerField = "alphabet";</listing>
		 *
		 * @default "header"
		 *
		 * @see #headerFunction
		 */
		public function get headerField():String
		{
			return this._headerField;
		}

		/**
		 * @private
		 */
		public function set headerField(value:String):void
		{
			if(this._headerField == value)
			{
				return;
			}
			this._headerField = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _headerFunction:Function;

		/**
		 * A function used to generate header data for a specific group. If this
		 * function is not null, then the <code>headerField</code> will be
		 * ignored.
		 *
		 * <p>The function is expected to have the following signature:</p>
		 * <pre>function( item:Object ):Object</pre>
		 *
		 * <p>All of the header fields and functions, ordered by priority:</p>
		 * <ol>
		 *     <li><code>headerFunction</code></li>
		 *     <li><code>headerField</code></li>
		 * </ol>
		 *
		 * <p>The following example sets the header function:</p>
		 *
		 * <listing version="3.0">
		 * list.headerFunction = function( group:Object ):Object
		 * {
		 *    return group.header;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see #headerField
		 */
		public function get headerFunction():Function
		{
			return this._headerFunction;
		}

		/**
		 * @private
		 */
		public function set headerFunction(value:Function):void
		{
			if(this._headerFunction == value)
			{
				return;
			}
			this._headerFunction = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _footerField:String = "footer";

		/**
		 * The field in a group that contains the data for a footer. If the
		 * group does not have this field, and a <code>footerFunction</code> is
		 * not defined, then no footer will be displayed for the group. In other
		 * words, a footer is optional, and a group may not have one.
		 *
		 * <p>All of the footer fields and functions, ordered by priority:</p>
		 * <ol>
		 *     <li><code>footerFunction</code></li>
		 *     <li><code>footerField</code></li>
		 * </ol>
		 *
		 * <p>The following example sets the footer field:</p>
		 *
		 * <listing version="3.0">
		 * list.footerField = "controls";</listing>
		 *
		 * @default "footer"
		 *
		 * @see #footerFunction
		 */
		public function get footerField():String
		{
			return this._footerField;
		}

		/**
		 * @private
		 */
		public function set footerField(value:String):void
		{
			if(this._footerField == value)
			{
				return;
			}
			this._footerField = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _footerFunction:Function;

		/**
		 * A function used to generate footer data for a specific group. If this
		 * function is not null, then the <code>footerField</code> will be
		 * ignored.
		 *
		 * <p>The function is expected to have the following signature:</p>
		 * <pre>function( item:Object ):Object</pre>
		 *
		 * <p>All of the footer fields and functions, ordered by priority:</p>
		 * <ol>
		 *     <li><code>footerFunction</code></li>
		 *     <li><code>footerField</code></li>
		 * </ol>
		 *
		 * <p>The following example sets the footer function:</p>
		 *
		 * <listing version="3.0">
		 * list.footerFunction = function( group:Object ):Object
		 * {
		 *    return group.footer;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see #footerField
		 */
		public function get footerFunction():Function
		{
			return this._footerFunction;
		}

		/**
		 * @private
		 */
		public function set footerFunction(value:Function):void
		{
			if(this._footerFunction == value)
			{
				return;
			}
			this._footerFunction = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _keyScrollDuration:Number = 0.25;

		/**
		 * The duration, in seconds, of the animation when the selected item is
		 * changed by keyboard navigation and the item scrolls into view.
		 *
		 * <p>In the following example, the duration of the animation that
		 * scrolls the list to a new selected item is set to 500 milliseconds:</p>
		 *
		 * <listing version="3.0">
		 * list.keyScrollDuration = 0.5;</listing>
		 *
		 * @default 0.25
		 */
		public function get keyScrollDuration():Number
		{
			return this._keyScrollDuration;
		}

		/**
		 * @private
		 */
		public function set keyScrollDuration(value:Number):void
		{
			this._keyScrollDuration = value;
		}

		/**
		 * The pending group index to scroll to after validating. A value of
		 * <code>-1</code> means that the scroller won't scroll to a group after
		 * validating.
		 */
		protected var pendingGroupIndex:int = -1;

		/**
		 * The pending item index to scroll to after validating. A value of
		 * <code>-1</code> means that the scroller won't scroll to an item after
		 * validating.
		 */
		protected var pendingItemIndex:int = -1;

		/**
		 * @private
		 */
		override public function dispose():void
		{
			//clearing selection now so that the data provider setter won't
			//cause a selection change that triggers events.
			this._selectedGroupIndex = -1;
			this._selectedItemIndex = -1;
			this.dataProvider = null;
			this.layout = null;
			super.dispose();
		}

		/**
		 * @private
		 */
		override public function scrollToPosition(horizontalScrollPosition:Number, verticalScrollPosition:Number, animationDuration:Number = NaN):void
		{
			this.pendingItemIndex = -1;
			super.scrollToPosition(horizontalScrollPosition, verticalScrollPosition, animationDuration);
		}

		/**
		 * @private
		 */
		override public function scrollToPageIndex(horizontalPageIndex:int, verticalPageIndex:int, animationDuration:Number = NaN):void
		{
			this.pendingGroupIndex = -1;
			this.pendingItemIndex = -1;
			super.scrollToPageIndex(horizontalPageIndex, verticalPageIndex, animationDuration);
		}

		/**
		 * After the next validation, scrolls the list so that the specified
		 * item is visible. If <code>animationDuration</code> is greater than
		 * zero, the scroll will animate. The duration is in seconds.
		 *
		 * <p>In the following example, the list is scrolled to display the
		 * third item in the second group:</p>
		 *
		 * <listing version="3.0">
		 * list.scrollToDisplayIndex( 1, 2 );</listing>
		 */
		public function scrollToDisplayIndex(groupIndex:int, itemIndex:int, animationDuration:Number = 0):void
		{
			this.pendingHorizontalPageIndex = -1;
			this.pendingVerticalPageIndex = -1;
			this.pendingHorizontalScrollPosition = NaN;
			this.pendingVerticalScrollPosition = NaN;
			if(this.pendingGroupIndex == groupIndex &&
				this.pendingItemIndex == itemIndex &&
				this.pendingScrollDuration == animationDuration)
			{
				return;
			}
			this.pendingGroupIndex = groupIndex;
			this.pendingItemIndex = itemIndex;
			this.pendingScrollDuration = animationDuration;
			this.invalidate(INVALIDATION_FLAG_PENDING_SCROLL);
		}

		/**
		 * Sets the selected group and item index.
		 *
		 * <p>In the following example, the third item in the second group
		 * is selected:</p>
		 *
		 * <listing version="3.0">
		 * list.setSelectedLocation( 1, 2 );</listing>
		 *
		 * <p>In the following example, the selection is cleared:</p>
		 *
		 * <listing version="3.0">
		 * list.setSelectedLocation( -1, -1 );</listing>
		 *
		 * @see #selectedGroupIndex
		 * @see #selectedItemIndex
		 * @see #selectedItem
		 */
		public function setSelectedLocation(groupIndex:int, itemIndex:int):void
		{
			if(this._selectedGroupIndex == groupIndex && this._selectedItemIndex == itemIndex)
			{
				return;
			}
			if((groupIndex < 0 && itemIndex >= 0) || (groupIndex >= 0 && itemIndex < 0))
			{
				throw new ArgumentError("To deselect items, group index and item index must both be < 0.");
			}
			this._selectedGroupIndex = groupIndex;
			this._selectedItemIndex = itemIndex;

			this.invalidate(INVALIDATION_FLAG_SELECTED);
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * Extracts header data from a group object.
		 */
		public function groupToHeaderData(group:Object):Object
		{
			if(this._headerFunction != null)
			{
				return this._headerFunction(group);
			}
			else if(this._headerField != null && group && group.hasOwnProperty(this._headerField))
			{
				return group[this._headerField];
			}

			return null;
		}

		/**
		 * Extracts footer data from a group object.
		 */
		public function groupToFooterData(group:Object):Object
		{
			if(this._footerFunction != null)
			{
				return this._footerFunction(group);
			}
			else if(this._footerField != null && group && group.hasOwnProperty(this._footerField))
			{
				return group[this._footerField];
			}

			return null;
		}

		/**
		 * @private
		 */
		override protected function initialize():void
		{
			var hasLayout:Boolean = this._layout != null;

			super.initialize();

			if(!this.dataViewPort)
			{
				this.viewPort = this.dataViewPort = new GroupedListDataViewPort();
				this.dataViewPort.owner = this;
				this.dataViewPort.addEventListener(Event.CHANGE, dataViewPort_changeHandler);
				this.viewPort = this.dataViewPort;
			}

			if(!hasLayout)
			{
				if(this._hasElasticEdges &&
					this._verticalScrollPolicy == SCROLL_POLICY_AUTO &&
					this._scrollBarDisplayMode != SCROLL_BAR_DISPLAY_MODE_FIXED)
				{
					//so that the elastic edges work even when the max scroll
					//position is 0, similar to iOS.
					this.verticalScrollPolicy = SCROLL_POLICY_ON;
				}

				var layout:VerticalLayout = new VerticalLayout();
				layout.useVirtualLayout = true;
				layout.padding = 0;
				layout.gap = 0;
				layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
				layout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
				this.layout = layout;
			}
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			this.refreshDataViewPortProperties();
			super.draw();
		}

		/**
		 * @private
		 */
		protected function refreshDataViewPortProperties():void
		{
			this.dataViewPort.isSelectable = this._isSelectable;
			this.dataViewPort.setSelectedLocation(this._selectedGroupIndex, this._selectedItemIndex);
			this.dataViewPort.dataProvider = this._dataProvider;
			this.dataViewPort.typicalItem = this._typicalItem;

			this.dataViewPort.itemRendererType = this._itemRendererType;
			this.dataViewPort.itemRendererFactory = this._itemRendererFactory;
			this.dataViewPort.itemRendererProperties = this._itemRendererProperties;
			this.dataViewPort.customItemRendererStyleName = this._customItemRendererStyleName;

			this.dataViewPort.firstItemRendererType = this._firstItemRendererType;
			this.dataViewPort.firstItemRendererFactory = this._firstItemRendererFactory;
			this.dataViewPort.customFirstItemRendererStyleName = this._customFirstItemRendererStyleName;

			this.dataViewPort.lastItemRendererType = this._lastItemRendererType;
			this.dataViewPort.lastItemRendererFactory = this._lastItemRendererFactory;
			this.dataViewPort.customLastItemRendererStyleName = this._customLastItemRendererStyleName;

			this.dataViewPort.singleItemRendererType = this._singleItemRendererType;
			this.dataViewPort.singleItemRendererFactory = this._singleItemRendererFactory;
			this.dataViewPort.customSingleItemRendererStyleName = this._customSingleItemRendererStyleName;

			this.dataViewPort.headerRendererType = this._headerRendererType;
			this.dataViewPort.headerRendererFactory = this._headerRendererFactory;
			this.dataViewPort.headerRendererProperties = this._headerRendererProperties;
			this.dataViewPort.customHeaderRendererStyleName = this._customHeaderRendererStyleName;

			this.dataViewPort.footerRendererType = this._footerRendererType;
			this.dataViewPort.footerRendererFactory = this._footerRendererFactory;
			this.dataViewPort.footerRendererProperties = this._footerRendererProperties;
			this.dataViewPort.customFooterRendererStyleName = this._customFooterRendererStyleName;

			this.dataViewPort.layout = this._layout;
		}

		/**
		 * @private
		 */
		override protected function handlePendingScroll():void
		{
			if(this.pendingGroupIndex >= 0 && this.pendingItemIndex >= 0)
			{
				var item:Object = this._dataProvider.getItemAt(this.pendingGroupIndex, this.pendingItemIndex);
				if(item is Object)
				{
					this.dataViewPort.getScrollPositionForIndex(this.pendingGroupIndex, this.pendingItemIndex, HELPER_POINT);
					this.pendingGroupIndex = -1;
					this.pendingItemIndex = -1;

					var targetHorizontalScrollPosition:Number = HELPER_POINT.x;
					if(targetHorizontalScrollPosition < this._minHorizontalScrollPosition)
					{
						targetHorizontalScrollPosition = this._minHorizontalScrollPosition;
					}
					else if(targetHorizontalScrollPosition > this._maxHorizontalScrollPosition)
					{
						targetHorizontalScrollPosition = this._maxHorizontalScrollPosition;
					}
					var targetVerticalScrollPosition:Number = HELPER_POINT.y;
					if(targetVerticalScrollPosition < this._minVerticalScrollPosition)
					{
						targetVerticalScrollPosition = this._minVerticalScrollPosition;
					}
					else if(targetVerticalScrollPosition > this._maxVerticalScrollPosition)
					{
						targetVerticalScrollPosition = this._maxVerticalScrollPosition;
					}
					this.throwTo(targetHorizontalScrollPosition, targetVerticalScrollPosition, this.pendingScrollDuration);
				}
			}
			super.handlePendingScroll();
		}

		/**
		 * @private
		 */
		override protected function stage_keyDownHandler(event:KeyboardEvent):void
		{
			if(!this._dataProvider)
			{
				return;
			}
			var changedSelection:Boolean = false;
			if(event.keyCode == Keyboard.HOME)
			{
				if(this._dataProvider.getLength() > 0 && this._dataProvider.getLength(0) > 0)
				{
					this.setSelectedLocation(0, 0);
					changedSelection = true;
				}
			}
			if(event.keyCode == Keyboard.END)
			{
				var groupIndex:int = this._dataProvider.getLength();
				var itemIndex:int = -1;
				do
				{
					groupIndex--;
					if(groupIndex >= 0)
					{
						itemIndex = this._dataProvider.getLength(groupIndex) - 1;
					}
				}
				while(groupIndex > 0 && itemIndex < 0)
				if(groupIndex >= 0 && itemIndex >= 0)
				{
					this.setSelectedLocation(groupIndex, itemIndex);
					changedSelection = true;
				}
			}
			else if(event.keyCode == Keyboard.UP)
			{
				groupIndex = this._selectedGroupIndex;
				itemIndex = this._selectedItemIndex - 1;
				if(itemIndex < 0)
				{
					do
					{
						groupIndex--;
						if(groupIndex >= 0)
						{
							itemIndex = this._dataProvider.getLength(groupIndex) - 1;
						}
					}
					while(groupIndex > 0 && itemIndex < 0)
				}
				if(groupIndex >= 0 && itemIndex >= 0)
				{
					this.setSelectedLocation(groupIndex, itemIndex);
					changedSelection = true;
				}
			}
			else if(event.keyCode == Keyboard.DOWN)
			{
				groupIndex = this._selectedGroupIndex;
				if(groupIndex < 0)
				{
					itemIndex = -1;
				}
				else
				{
					itemIndex = this._selectedItemIndex + 1;
				}
				if(groupIndex < 0 || itemIndex >= this._dataProvider.getLength(groupIndex))
				{
					itemIndex = -1;
					groupIndex++;
					var groupCount:int = this._dataProvider.getLength();
					while(groupIndex < groupCount && itemIndex < 0)
					{
						if(this._dataProvider.getLength(groupIndex) > 0)
						{
							itemIndex = 0;
						}
						else
						{
							groupIndex++;
						}
					}
				}
				if(groupIndex >= 0 && itemIndex >= 0)
				{
					this.setSelectedLocation(groupIndex, itemIndex);
					changedSelection = true;
				}
			}
			if(changedSelection)
			{
				this.dataViewPort.getNearestScrollPositionForIndex(this._selectedGroupIndex, this.selectedItemIndex, HELPER_POINT);
				this.scrollToPosition(HELPER_POINT.x, HELPER_POINT.y, this._keyScrollDuration);
			}
		}

		/**
		 * @private
		 */
		protected function dataProvider_changeHandler(event:Event):void
		{
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected function dataProvider_resetHandler(event:Event):void
		{
			this.horizontalScrollPosition = 0;
			this.verticalScrollPosition = 0;

			//the entire data provider was replaced. select no item.
			this.setSelectedLocation(-1, -1);
		}

		/**
		 * @private
		 */
		protected function dataProvider_addItemHandler(event:Event, indices:Array):void
		{
			if(this._selectedGroupIndex == -1)
			{
				return;
			}
			var groupIndex:int = indices[0] as int;
			if(indices.length > 1) //adding an item to a group
			{
				var itemIndex:int = indices[1] as int;
				if(this._selectedGroupIndex == groupIndex && this._selectedItemIndex >= itemIndex)
				{
					//adding an item at an index that is less than or equal to
					//the item that is selected. need to update the selected
					//item index.
					this.setSelectedLocation(this._selectedGroupIndex, this._selectedItemIndex + 1);
				}
			}
			else //adding an entire group
			{
				//adding a group before the group that the selected item is in.
				//need to update the selected group index.
				this.setSelectedLocation(this._selectedGroupIndex + 1, this._selectedItemIndex);
			}
		}

		/**
		 * @private
		 */
		protected function dataProvider_removeItemHandler(event:Event, indices:Array):void
		{
			if(this._selectedGroupIndex == -1)
			{
				return;
			}
			var groupIndex:int = indices[0] as int;
			if(indices.length > 1) //removing an item from a group
			{
				var itemIndex:int = indices[1] as int;
				if(this._selectedGroupIndex == groupIndex)
				{
					if(this._selectedItemIndex == itemIndex)
					{
						//removing the item that was selected.
						//now, nothing will be selected.
						this.setSelectedLocation(-1, -1);
					}
					else if(this._selectedItemIndex > itemIndex)
					{
						//removing an item from the same group that appears
						//before the item that is selected. need to update the
						//selected item index.
						this.setSelectedLocation(this._selectedGroupIndex, this._selectedItemIndex - 1);
					}
				}
			}
			else //removing an entire group
			{
				if(this._selectedGroupIndex == groupIndex)
				{
					//removing the group that the selected item was in.
					//now, nothing will be selected.
					this.setSelectedLocation(-1, -1);
				}
				else if(this._selectedGroupIndex > groupIndex)
				{
					//removing a group before the group that the selected item
					//is in. need to update the selected group index.
					this.setSelectedLocation(this._selectedGroupIndex - 1, this._selectedItemIndex);
				}
			}
		}

		/**
		 * @private
		 */
		protected function dataProvider_replaceItemHandler(event:Event, indices:Array):void
		{
			if(this._selectedGroupIndex == -1)
			{
				return;
			}
			var groupIndex:int = indices[0] as int;
			if(indices.length > 1) //replacing an item from a group
			{
				var itemIndex:int = indices[1] as int;
				if(this._selectedGroupIndex == groupIndex && this._selectedItemIndex == itemIndex)
				{
					//replacing the selected item.
					//now, nothing will be selected.
					this.setSelectedLocation(-1, -1);
				}
			}
			else if(this._selectedGroupIndex == groupIndex) //replacing an entire group
			{
				//replacing the group with the selected item.
				//now, nothing will be selected.
				this.setSelectedLocation(-1, -1);
			}
		}

		/**
		 * @private
		 */
		protected function dataViewPort_changeHandler(event:Event):void
		{
			this.setSelectedLocation(this.dataViewPort.selectedGroupIndex, this.dataViewPort.selectedItemIndex);
		}

		/**
		 * @private
		 */
		private function layout_scrollHandler(event:Event, scrollOffset:Point):void
		{
			var layout:IVariableVirtualLayout = IVariableVirtualLayout(this._layout);
			if(!this.isScrolling || !layout.useVirtualLayout || !layout.hasVariableItemDimensions)
			{
				return;
			}

			var scrollOffsetX:Number = scrollOffset.x;
			this._startHorizontalScrollPosition += scrollOffsetX;
			this._horizontalScrollPosition += scrollOffsetX;
			if(this._horizontalAutoScrollTween)
			{
				this._targetHorizontalScrollPosition += scrollOffsetX;
				this.throwTo(this._targetHorizontalScrollPosition, NaN, this._horizontalAutoScrollTween.totalTime - this._horizontalAutoScrollTween.currentTime);
			}

			var scrollOffsetY:Number = scrollOffset.y;
			this._startVerticalScrollPosition += scrollOffsetY;
			this._verticalScrollPosition += scrollOffsetY;
			if(this._verticalAutoScrollTween)
			{
				this._targetVerticalScrollPosition += scrollOffsetY;
				this.throwTo(NaN, this._targetVerticalScrollPosition, this._verticalAutoScrollTween.totalTime - this._verticalAutoScrollTween.currentTime);
			}
		}
	}
}
