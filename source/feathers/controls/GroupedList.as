/*
Feathers
Copyright 2012-2021 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.controls.renderers.DefaultGroupedListHeaderOrFooterRenderer;
	import feathers.controls.renderers.DefaultGroupedListItemRenderer;
	import feathers.controls.renderers.IGroupedListFooterRenderer;
	import feathers.controls.renderers.IGroupedListHeaderRenderer;
	import feathers.controls.renderers.IGroupedListItemRenderer;
	import feathers.controls.supportClasses.GroupedListDataViewPort;
	import feathers.core.IFocusContainer;
	import feathers.core.PropertyProxy;
	import feathers.data.IHierarchicalCollection;
	import feathers.events.CollectionEventType;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.ILayout;
	import feathers.layout.IVariableVirtualLayout;
	import feathers.layout.VerticalAlign;
	import feathers.layout.VerticalLayout;
	import feathers.skins.IStyleProvider;
	import feathers.system.DeviceCapabilities;

	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;

	import starling.events.Event;
	import starling.utils.Pool;

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
	 * @see #style:customFirstItemRendererStyleName
	 * @see #style:customLastItemRendererStyleName
	 * @see #style:customSingleItemRendererStyleName
	 */
	[Style(name="customItemRendererStyleName",type="String")]

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
	 * @see #style:customItemRendererStyleName
	 * @see #style:customLastItemRendererStyleName
	 * @see #style:customSingleItemRendererStyleName
	 */
	[Style(name="customFirstItemRendererStyleName",type="String")]

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
	 * @see #style:customItemRendererStyleName
	 * @see #style:customFirstItemRendererStyleName
	 * @see #style:customSingleItemRendererStyleName
	 */
	[Style(name="customLastItemRendererStyleName",type="String")]

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
	 * @see #style:customItemRendererStyleName
	 * @see #style:customFirstItemRendererStyleName
	 * @see #style:customLastItemRendererStyleName
	 */
	[Style(name="customSingleItemRendererStyleName",type="String")]

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
	[Style(name="customHeaderRendererStyleName",type="String")]

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
	[Style(name="customFooterRendererStyleName",type="String")]

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
	[Style(name="keyScrollDuration",type="Number")]

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
	[Style(name="layout",type="feathers.layout.ILayout")]

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
	 * @see #selectedItem
	 * @see #selectedGroupIndex
	 * @see #selectedItemIndex
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
	 * list.dataProvider = new ArrayHierarchicalCollection(
	 * [
	 *     {
	 *         header: "Dairy",
	 *         children:
	 *         [
	 *             { text: "Milk", thumbnail: textureAtlas.getTexture( "milk" ) },
	 *             { text: "Cheese", thumbnail: textureAtlas.getTexture( "cheese" ) },
	 *         ]
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
	 *
	 * @productversion Feathers 1.0.0
	 */
	public class GroupedList extends Scroller implements IFocusContainer
	{
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
		 * The default name to use with header renderers.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_HEADER_RENDERER:String = "feathers-grouped-list-header-renderer";

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
		 * The default name to use with footer renderers.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_FOOTER_RENDERER:String = "feathers-grouped-list-footer-renderer";

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
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
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
		protected var _dataProvider:IHierarchicalCollection;

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
		 * list.dataProvider = new ArrayHierarchicalCollection(
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
		 * <p><em>Warning:</em> A grouped list's data provider cannot contain
		 * duplicate items. To display the same item in multiple item renderers,
		 * you must create separate objects with the same properties. This
		 * restriction exists because it significantly improves performance.</p>
		 *
		 * <p><em>Warning:</em> If the data provider contains display objects,
		 * concrete textures, or anything that needs to be disposed, those
		 * objects will not be automatically disposed when the grouped list is
		 * disposed. Similar to how <code>starling.display.Image</code> cannot
		 * automatically dispose its texture because the texture may be used
		 * by other display objects, a list cannot dispose its data provider
		 * because the data provider may be used by other lists. See the
		 * <code>dispose()</code> function on <code>IHierarchicalCollection</code>
		 * to see how the data provider can be disposed properly.</p>
		 *
		 * @default null
		 *
		 * @see feathers.data.ArrayHierarchicalCollection
		 * @see feathers.data.VectorHierarchicalCollection
		 * @see feathers.data.XMLListHierarchicalCollection
		 */
		public function get dataProvider():IHierarchicalCollection
		{
			return this._dataProvider;
		}

		/**
		 * @private
		 */
		public function set dataProvider(value:IHierarchicalCollection):void
		{
			if(this._dataProvider == value)
			{
				return;
			}
			if(this._dataProvider)
			{
				this._dataProvider.removeEventListener(CollectionEventType.ADD_ITEM, dataProvider_addItemHandler);
				this._dataProvider.removeEventListener(CollectionEventType.REMOVE_ITEM, dataProvider_removeItemHandler);
				this._dataProvider.removeEventListener(CollectionEventType.REMOVE_ALL, dataProvider_removeAllHandler);
				this._dataProvider.removeEventListener(CollectionEventType.REPLACE_ITEM, dataProvider_replaceItemHandler);
				this._dataProvider.removeEventListener(CollectionEventType.RESET, dataProvider_resetHandler);
				this._dataProvider.removeEventListener(Event.CHANGE, dataProvider_changeHandler);
			}
			this._dataProvider = value;
			if(this._dataProvider)
			{
				this._dataProvider.addEventListener(CollectionEventType.ADD_ITEM, dataProvider_addItemHandler);
				this._dataProvider.addEventListener(CollectionEventType.REMOVE_ITEM, dataProvider_removeItemHandler);
				this._dataProvider.addEventListener(CollectionEventType.REMOVE_ALL, dataProvider_removeAllHandler);
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
		 *
		 * @see #selectedItem
		 * @see #selectedGroupIndex
		 * @see #selectedItemIndex
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
		protected var _helperLocation:Vector.<int> = new <int>[];

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
			this._helperLocation.length = 2;
			this._helperLocation[0] = this._selectedGroupIndex;
			this._helperLocation[1] = this._selectedItemIndex;
			var result:Object = this._dataProvider.getItemAt(this._selectedGroupIndex, this._selectedItemIndex);
			this._helperLocation.length = 0;
			return result;
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
		protected var _itemRendererFactories:Object;

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
		 * @see #setItemRendererFactoryWithID()
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
		protected var _factoryIDFunction:Function;

		/**
		 * When a list requires multiple item renderer types, this function is
		 * used to determine which type of item renderer is required for a
		 * specific item (or index). Returns the ID of the item renderer type
		 * to use for the item, or <code>null</code> if the default
		 * <code>itemRendererFactory</code> should be used.
		 *
		 * <p>The function is expected to have one of the following
		 * signatures:</p>
		 *
		 * <pre>function(item:Object):String</pre>
		 *
		 * <pre>function(item:Object, groupIndex:int, itemIndex:int):String</pre>
		 *
		 * <p>The following example provides a <code>factoryIDFunction</code>:</p>
		 *
		 * <listing version="3.0">
		 * function regularItemFactory():IGroupedListItemRenderer
		 * {
		 *     return new DefaultGroupedListItemRenderer();
		 * }
		 * function firstItemFactory():IGroupedListItemRenderer
		 * {
		 *     return new CustomItemRenderer();
		 * }
		 * list.setItemRendererFactoryWithID( "regular-item", regularItemFactory );
		 * list.setItemRendererFactoryWithID( "first-item", firstItemFactory );
		 * 
		 * list.factoryIDFunction = function( item:Object, groupIndex:int, itemIndex:int ):String
		 * {
		 *     if(index == 0)
		 *     {
		 *         return "first-item";
		 *     }
		 *     return "regular-item";
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see #setItemRendererFactoryWithID()
		 * @see #itemRendererFactory
		 */
		public function get factoryIDFunction():Function
		{
			return this._factoryIDFunction;
		}

		/**
		 * @private
		 */
		public function set factoryIDFunction(value:Function):void
		{
			if(this._factoryIDFunction === value)
			{
				return;
			}
			this._factoryIDFunction = value;
			if(value !== null && this._itemRendererFactories === null)
			{
				this._itemRendererFactories = {};
			}
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
		 * list.typicalItem = { text: "A typical item", thumbnail: texture };</listing>
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
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._customItemRendererStyleName === value)
			{
				return;
			}
			this._customItemRendererStyleName = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _itemRendererProperties:PropertyProxy;

		/**
		 * An object that stores properties for all of the list's item
		 * renderers, and the properties will be passed down to every item
		 * renderer when the list validates. The available properties
		 * depend on which <code>IGroupedListItemRenderer</code> implementation
		 * is returned by <code>itemRendererFactory</code>.
		 *
		 * <p>By default, the <code>itemRendererFactory</code> will return a
		 * <code>DefaultGroupedListItemRenderer</code> instance. If you aren't
		 * using a custom item renderer, you can refer to
		 * <a href="renderers/DefaultGroupedListItemRenderer.html"><code>feathers.controls.renderers.DefaultGroupedListItemRenderer</code></a>
		 * for a list of available properties.</p>
		 *
		 * <p>These properties are shared by every item renderer, so anything
		 * that cannot be shared (such as display objects, which cannot be added
		 * to multiple parents) should be passed to item renderers using the
		 * <code>itemRendererFactory</code> or in the theme.</p>
		 *
		 * <p>The following example customizes some item renderer properties
		 * (this example assumes that the item renderer's label text renderer
		 * is a <code>BitmapFontTextRenderer</code>):</p>
		 *
		 * <listing version="3.0">
		 * list.itemRendererProperties.labelField = "text";
		 * list.itemRendererProperties.accessoryField = "control";</listing>
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
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._customFirstItemRendererStyleName === value)
			{
				return;
			}
			this._customFirstItemRendererStyleName = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
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
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._customLastItemRendererStyleName === value)
			{
				return;
			}
			this._customLastItemRendererStyleName = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
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
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._customSingleItemRendererStyleName === value)
			{
				return;
			}
			this._customSingleItemRendererStyleName = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
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
		protected var _headerRendererFactories:Object;

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
		 * @see #setHeaderRendererFactoryWithID()
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
		protected var _headerFactoryIDFunction:Function;

		/**
		 * When a list requires multiple header renderer types, this function is
		 * used to determine which type of header renderer is required for a
		 * specific header (or group index). Returns the ID of the factory
		 * to use for the header, or <code>null</code> if the default
		 * <code>headerRendererFactory</code> should be used.
		 *
		 * <p>The function is expected to have one of the following
		 * signatures:</p>
		 *
		 * <pre>function(header:Object):String</pre>
		 *
		 * <pre>function(header:Object, groupIndex:int):String</pre>
		 *
		 * <p>The following example provides a <code>headerFactoryIDFunction</code>:</p>
		 *
		 * <listing version="3.0">
		 * function regularHeaderFactory():IGroupedListHeaderRenderer
		 * {
		 *     return new DefaultGroupedListHeaderOrFooterRenderer();
		 * }
		 * function customHeaderFactory():IGroupedListHeaderRenderer
		 * {
		 *     return new CustomHeaderRenderer();
		 * }
		 * list.setHeaderRendererFactoryWithID( "regular-header", regularHeaderFactory );
		 * list.setHeaderRendererFactoryWithID( "custom-header", customHeaderFactory );
		 * 
		 * list.headerFactoryIDFunction = function( header:Object, groupIndex:int ):String
		 * {
		 *     //check if the subTitle property exists in the header data
		 *     if( "subTitle" in header )
		 *     {
		 *         return "custom-header";
		 *     }
		 *     return "regular-header";
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see #setHeaderRendererFactoryWithID()
		 * @see #headerRendererFactory
		 */
		public function get headerFactoryIDFunction():Function
		{
			return this._headerFactoryIDFunction;
		}

		/**
		 * @private
		 */
		public function set headerFactoryIDFunction(value:Function):void
		{
			if(this._headerFactoryIDFunction === value)
			{
				return;
			}
			this._headerFactoryIDFunction = value;
			if(value !== null && this._headerRendererFactories === null)
			{
				this._headerRendererFactories = {};
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _customHeaderRendererStyleName:String = DEFAULT_CHILD_STYLE_NAME_HEADER_RENDERER;

		/**
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._customHeaderRendererStyleName === value)
			{
				return;
			}
			this._customHeaderRendererStyleName = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _headerRendererProperties:PropertyProxy;

		/**
		 * An object that stores properties for all of the list's header
		 * renderers, and the properties will be passed down to every header
		 * renderer when the list validates. The available properties
		 * depend on which <code>IGroupedListHeaderOrFooterRenderer</code>
		 * implementation is returned by <code>headerRendererFactory</code>.
		 *
		 * <p>By default, the <code>headerRendererFactory</code> will return a
		 * <code>DefaultGroupedListHeaderOrFooterRenderer</code> instance. If
		 * you aren't using a custom header renderer, you can refer to
		 * <a href="renderers/DefaultGroupedListHeaderOrFooterRenderer.html"><code>feathers.controls.renderers.DefaultGroupedListHeaderOrFooterRenderer</code></a>
		 * for a list of available properties.</p>
		 *
		 * <p>These properties are shared by every header renderer, so anything
		 * that cannot be shared (such as display objects, which cannot be added
		 * to multiple parents) should be passed to header renderers using the
		 * <code>headerRendererFactory</code> or in the theme.</p>
		 *
		 * <p>The following example customizes some header renderer properties:</p>
		 *
		 * <listing version="3.0">
		 * list.headerRendererProperties.contentLabelField = "headerText";
		 * list.headerRendererProperties.contentLabelStyleName = "custom-header-renderer-content-label";</listing>
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
		protected var _footerRendererFactories:Object;

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
		 * @see #setFooterRendererFactoryWithID()
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
		protected var _footerFactoryIDFunction:Function;

		/**
		 * When a list requires multiple footer renderer types, this function is
		 * used to determine which type of footer renderer is required for a
		 * specific footer (or group index). Returns the ID of the factory
		 * to use for the footer, or <code>null</code> if the default
		 * <code>footerRendererFactory</code> should be used.
		 *
		 * <p>The function is expected to have one of the following
		 * signatures:</p>
		 *
		 * <pre>function(footer:Object):String</pre>
		 *
		 * <pre>function(footer:Object, groupIndex:int):String</pre>
		 *
		 * <p>The following example provides a <code>footerFactoryIDFunction</code>:</p>
		 *
		 * <listing version="3.0">
		 * function regularFooterFactory():IGroupedListFooterRenderer
		 * {
		 *     return new DefaultGroupedListHeaderOrFooterRenderer();
		 * }
		 * function customFooterFactory():IGroupedListFooterRenderer
		 * {
		 *     return new CustomFooterRenderer();
		 * }
		 * list.setFooterRendererFactoryWithID( "regular-footer", regularFooterFactory );
		 * list.setFooterRendererFactoryWithID( "custom-footer", customFooterFactory );
		 * 
		 * list.footerFactoryIDFunction = function( footer:Object, groupIndex:int ):String
		 * {
		 *     //check if the footerAccessory property exists in the footer data
		 *     if( "footerAccessory" in footer )
		 *     {
		 *         return "custom-footer";
		 *     }
		 *     return "regular-footer";
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see #setFooterRendererFactoryWithID()
		 * @see #footerRendererFactory
		 */
		public function get footerFactoryIDFunction():Function
		{
			return this._footerFactoryIDFunction;
		}

		/**
		 * @private
		 */
		public function set footerFactoryIDFunction(value:Function):void
		{
			if(this._footerFactoryIDFunction === value)
			{
				return;
			}
			this._footerFactoryIDFunction = value;
			if(value !== null && this._footerRendererFactories === null)
			{
				this._footerRendererFactories = {};
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _customFooterRendererStyleName:String = DEFAULT_CHILD_STYLE_NAME_FOOTER_RENDERER;

		/**
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._customFooterRendererStyleName === value)
			{
				return;
			}
			this._customFooterRendererStyleName = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _footerRendererProperties:PropertyProxy;

		/**
		 * An object that stores properties for all of the list's footer
		 * renderers, and the properties will be passed down to every footer
		 * renderer when the list validates. The available properties
		 * depend on which <code>IGroupedListHeaderOrFooterRenderer</code>
		 * implementation is returned by <code>footerRendererFactory</code>.
		 *
		 * <p>By default, the <code>footerRendererFactory</code> will return a
		 * <code>DefaultGroupedListHeaderOrFooterRenderer</code> instance. If
		 * you aren't using a custom footer renderer, you can refer to
		 * <a href="renderers/DefaultGroupedListHeaderOrFooterRenderer.html"><code>feathers.controls.renderers.DefaultGroupedListHeaderOrFooterRenderer</code></a>
		 * for a list of available properties.</p>
		 *
		 * <p>These properties are shared by every footer renderer, so anything
		 * that cannot be shared (such as display objects, which cannot be added
		 * to multiple parents) should be passed to footer renderers using the
		 * <code>footerRendererFactory</code> or in the theme.</p>
		 *
		 * <p>The following example customizes some footer renderer properties:</p>
		 *
		 * <listing version="3.0">
		 * list.footerRendererProperties.contentLabelField = "footerText";
		 * list.footerRendererProperties.contentLabelStyleName = "custom-footer-renderer-content-label";</listing>
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
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._keyScrollDuration == value)
			{
				return;
			}
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
		 * <p>The <code>itemIndex</code> parameter is optional. If set to
		 * <code>-1</code>, the list will scroll to the start of the specified
		 * group.</p>
		 *
		 * <p>In the following example, the list is scrolled to display the
		 * third item in the second group:</p>
		 *
		 * <listing version="3.0">
		 * list.scrollToDisplayIndex( 1, 2 );</listing>
		 *
		 * <p>In the following example, the list is scrolled to display the
		 * third group:</p>
		 *
		 * <listing version="3.0">
		 * list.scrollToDisplayIndex( 2 );</listing>
		 */
		public function scrollToDisplayIndex(groupIndex:int, itemIndex:int = -1, animationDuration:Number = 0):void
		{
			//cancel any pending scroll to a different page or scroll position.
			//we can have only one type of pending scroll at a time.
			this.hasPendingHorizontalPageIndex = false;
			this.hasPendingVerticalPageIndex = false;
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
		 * Returns the item renderer factory associated with a specific ID.
		 * Returns <code>null</code> if no factory is associated with the ID.
		 *
		 * @see #setItemRendererFactoryWithID()
		 */
		public function getItemRendererFactoryWithID(id:String):Function
		{
			if(this._itemRendererFactories && (id in this._itemRendererFactories))
			{
				return this._itemRendererFactories[id] as Function;
			}
			return null;
		}

		/**
		 * Associates an item renderer factory with an ID to allow multiple
		 * types of item renderers may be displayed in the list. A custom
		 * <code>factoryIDFunction</code> may be specified to return the ID of
		 * the factory to use for a specific item in the data provider.
		 *
		 * @see #factoryIDFunction
		 * @see #getItemRendererFactoryWithID()
		 */
		public function setItemRendererFactoryWithID(id:String, factory:Function):void
		{
			if(id === null)
			{
				this.itemRendererFactory = factory;
				return;
			}
			if(this._itemRendererFactories === null)
			{
				this._itemRendererFactories = {};
			}
			if(factory !== null)
			{
				this._itemRendererFactories[id] = factory;
			}
			else
			{
				delete this._itemRendererFactories[id];
			}
		}

		/**
		 * Returns the header renderer factory associated with a specific ID.
		 * Returns <code>null</code> if no factory is associated with the ID.
		 *
		 * @see #setHeaderRendererFactoryWithID()
		 */
		public function getHeaderRendererFactoryWithID(id:String):Function
		{
			if(this._headerRendererFactories && (id in this._headerRendererFactories))
			{
				return this._headerRendererFactories[id] as Function;
			}
			return null;
		}

		/**
		 * Associates a header renderer factory with an ID to allow multiple
		 * types of header renderers may be displayed in the list. A custom
		 * <code>headerFactoryIDFunction</code> may be specified to return the
		 * ID of the factory to use for a specific header in the data provider.
		 *
		 * @see #headerFactoryIDFunction
		 * @see #getHeaderRendererFactoryWithID()
		 */
		public function setHeaderRendererFactoryWithID(id:String, factory:Function):void
		{
			if(id === null)
			{
				this.headerRendererFactory = factory;
				return;
			}
			if(this._headerRendererFactories === null)
			{
				this._headerRendererFactories = {};
			}
			if(factory !== null)
			{
				this._headerRendererFactories[id] = factory;
			}
			else
			{
				delete this._headerRendererFactories[id];
			}
		}

		/**
		 * Returns the footer renderer factory associated with a specific ID.
		 * Returns <code>null</code> if no factory is associated with the ID.
		 *
		 * @see #setFooterRendererFactoryWithID()
		 */
		public function getFooterRendererFactoryWithID(id:String):Function
		{
			if(this._footerRendererFactories && (id in this._footerRendererFactories))
			{
				return this._footerRendererFactories[id] as Function;
			}
			return null;
		}

		/**
		 * Associates a footer renderer factory with an ID to allow multiple
		 * types of footer renderers may be displayed in the list. A custom
		 * <code>footerFactoryIDFunction</code> may be specified to return the
		 * ID of the factory to use for a specific footer in the data provider.
		 *
		 * @see #footerFactoryIDFunction
		 * @see #getFooterRendererFactoryWithID()
		 */
		public function setFooterRendererFactoryWithID(id:String, factory:Function):void
		{
			if(id === null)
			{
				this.footerRendererFactory = factory;
				return;
			}
			if(this._footerRendererFactories === null)
			{
				this._footerRendererFactories = {};
			}
			if(factory !== null)
			{
				this._footerRendererFactories[id] = factory;
			}
			else
			{
				delete this._footerRendererFactories[id];
			}
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
		 * Returns the current item renderer used to render a specific item. May
		 * return <code>null</code> if an item doesn't currently have an item
		 * renderer. Most lists use virtual layouts where only the visible items
		 * will have an item renderer, so the result will usually be
		 * <code>null</code> for most items in the data provider.
		 *
		 * @see ../../../help/faq/layout-virtualization.html What is layout virtualization?
		 */
		public function itemToItemRenderer(item:Object):IGroupedListItemRenderer
		{
			return this.dataViewPort.itemToItemRenderer(item);
		}

		/**
		 * Returns the current header renderer used to render specific header
		 * data. May return <code>null</code> if the header data doesn't
		 * currently have a header renderer. Most lists use virtual layouts
		 * where only the visible headers will have a header renderer, so the
		 * result will usually be <code>null</code> for most header data in the
		 * data provider.
		 *
		 * @see #groupToHeaderData()
		 * @see ../../../help/faq/layout-virtualization.html What is layout virtualization?
		 */
		public function headerDataToHeaderRenderer(headerData:Object):IGroupedListHeaderRenderer
		{
			return this.dataViewPort.headerDataToHeaderRenderer(headerData);
		}

		/**
		 * Returns the current footer renderer used to render specific footer
		 * data. May return <code>null</code> if the footer data doesn't
		 * currently have a footer renderer. Most lists use virtual layouts
		 * where only the visible footers will have a footer renderer, so the
		 * result will usually be <code>null</code> for most footer data in the
		 * data provider.
		 *
		 * @see #groupToFooterData()
		 * @see ../../../help/faq/layout-virtualization.html What is layout virtualization?
		 */
		public function footerDataToFooterRenderer(footerData:Object):IGroupedListFooterRenderer
		{
			return this.dataViewPort.footerDataToFooterRenderer(footerData);
		}

		/**
		 * @private
		 */
		override protected function initialize():void
		{
			var hasLayout:Boolean = this._layout !== null;

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
					this._verticalScrollPolicy === ScrollPolicy.AUTO &&
					this._scrollBarDisplayMode !== ScrollBarDisplayMode.FIXED)
				{
					//so that the elastic edges work even when the max scroll
					//position is 0, similar to iOS.
					this._verticalScrollPolicy = ScrollPolicy.ON;
				}

				var layout:VerticalLayout = new VerticalLayout();
				layout.useVirtualLayout = true;
				layout.padding = 0;
				layout.gap = 0;
				layout.horizontalAlign = HorizontalAlign.JUSTIFY;
				layout.verticalAlign = VerticalAlign.TOP;
				layout.stickyHeader = !this._styleNameList.contains(ALTERNATE_STYLE_NAME_INSET_GROUPED_LIST);
				this.ignoreNextStyleRestriction();
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
			this.dataViewPort.itemRendererFactories = this._itemRendererFactories;
			this.dataViewPort.factoryIDFunction = this._factoryIDFunction;
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
			this.dataViewPort.headerRendererFactories = this._headerRendererFactories;
			this.dataViewPort.headerFactoryIDFunction = this._headerFactoryIDFunction;
			this.dataViewPort.headerRendererProperties = this._headerRendererProperties;
			this.dataViewPort.customHeaderRendererStyleName = this._customHeaderRendererStyleName;

			this.dataViewPort.footerRendererType = this._footerRendererType;
			this.dataViewPort.footerRendererFactory = this._footerRendererFactory;
			this.dataViewPort.footerRendererFactories = this._footerRendererFactories;
			this.dataViewPort.footerFactoryIDFunction = this._footerFactoryIDFunction;
			this.dataViewPort.footerRendererProperties = this._footerRendererProperties;
			this.dataViewPort.customFooterRendererStyleName = this._customFooterRendererStyleName;

			this.dataViewPort.layout = this._layout;
		}

		/**
		 * @private
		 */
		override protected function handlePendingScroll():void
		{
			if(this.pendingGroupIndex >= 0)
			{
				var pendingData:Object = null;
				if(this._dataProvider !== null)
				{
					if(this.pendingItemIndex >= 0)
					{
						this._helperLocation.length = 2;
						this._helperLocation[0] = this._selectedGroupIndex;
						this._helperLocation[1] = this._selectedItemIndex;
						pendingData = this._dataProvider.getItemAt(this.pendingGroupIndex, this.pendingItemIndex);
						this._helperLocation.length = 0;
					}
					else
					{
						this._helperLocation.length = 1;
						this._helperLocation[0] = this._selectedGroupIndex;
						pendingData = this._dataProvider.getItemAt(this.pendingGroupIndex);
						this._helperLocation.length = 0;
					}
				}
				if(pendingData is Object)
				{
					var point:Point = Pool.getPoint();
					this.dataViewPort.getScrollPositionForIndex(this.pendingGroupIndex, this.pendingItemIndex, point);
					this.pendingGroupIndex = -1;
					this.pendingItemIndex = -1;

					var targetHorizontalScrollPosition:Number = point.x;
					var targetVerticalScrollPosition:Number = point.y;
					Pool.putPoint(point);
					if(targetHorizontalScrollPosition < this._minHorizontalScrollPosition)
					{
						targetHorizontalScrollPosition = this._minHorizontalScrollPosition;
					}
					else if(targetHorizontalScrollPosition > this._maxHorizontalScrollPosition)
					{
						targetHorizontalScrollPosition = this._maxHorizontalScrollPosition;
					}
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
		override protected function nativeStage_keyDownHandler(event:KeyboardEvent):void
		{
			if(!this._isSelectable)
			{
				//not selectable, but should scroll
				super.nativeStage_keyDownHandler(event);
				return;
			}
			if(event.isDefaultPrevented())
			{
				return;
			}
			if(!this._dataProvider)
			{
				return;
			}
			if(this._selectedGroupIndex != -1 && this._selectedItemIndex != -1 &&
				(event.keyCode == Keyboard.SPACE ||
				((event.keyLocation == 4 || DeviceCapabilities.simulateDPad) && event.keyCode == Keyboard.ENTER)))
			{
				this.dispatchEventWith(Event.TRIGGERED, false, this.selectedItem);
			}
			if(event.keyCode == Keyboard.HOME || event.keyCode == Keyboard.END ||
				event.keyCode == Keyboard.PAGE_UP || event.keyCode == Keyboard.PAGE_DOWN ||
				event.keyCode == Keyboard.UP || event.keyCode == Keyboard.DOWN ||
				event.keyCode == Keyboard.LEFT || event.keyCode == Keyboard.RIGHT)
			{
				this.dataViewPort.calculateNavigationDestination(this._selectedGroupIndex, this._selectedItemIndex, event.keyCode, this._helperLocation);
				var newGroupIndex:int = this._helperLocation[0];
				var newItemIndex:int = this._helperLocation[1];
				if(newGroupIndex == -1 || newItemIndex == -1)
				{
					this.setSelectedLocation(-1, -1);
				}
				else if(this._selectedGroupIndex != newGroupIndex || this._selectedItemIndex != newItemIndex)
				{
					event.preventDefault();
					this.setSelectedLocation(newGroupIndex, newItemIndex);
					var point:Point = Pool.getPoint();
					this.dataViewPort.getNearestScrollPositionForIndex(this._selectedGroupIndex, this.selectedItemIndex, point);
					this.scrollToPosition(point.x, point.y, this._keyScrollDuration);
					Pool.putPoint(point);
				}
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
		protected function dataProvider_removeAllHandler(event:Event):void
		{
			this.setSelectedLocation(-1, -1);
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
