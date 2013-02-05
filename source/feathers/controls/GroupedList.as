/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.controls.renderers.DefaultGroupedListHeaderOrFooterRenderer;
	import feathers.controls.renderers.DefaultGroupedListItemRenderer;
	import feathers.controls.supportClasses.GroupedListDataViewPort;
	import feathers.core.IFocusDisplayObject;
	import feathers.core.PropertyProxy;
	import feathers.data.HierarchicalCollection;
	import feathers.events.CollectionEventType;
	import feathers.events.FeathersEventType;
	import feathers.layout.ILayout;
	import feathers.layout.VerticalLayout;

	import flash.geom.Point;
	import flash.ui.Keyboard;

	import starling.events.Event;
	import starling.events.KeyboardEvent;

	/**
	 * Dispatched when the selected item changes.
	 *
	 * @eventType starling.events.Event.CHANGE
	 */
	[Event(name="change",type="starling.events.Event")]

	/**
	 * Dispatched when an item renderer is added to the list. When the layout is
	 * virtualized, item renderers may not exist for every item in the data
	 * provider. This event can be used to track which items currently have
	 * renderers.
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
	 * @see http://wiki.starling-framework.org/feathers/grouped-list
	 */
	public class GroupedList extends Scroller implements IFocusDisplayObject
	{
		/**
		 * @private
		 */
		private static const HELPER_POINT:Point = new Point();

		/**
		 * An alternate name to use with GroupedList to allow a theme to give it
		 * an inset style. If a theme does not provide a skin for this name, it
		 * will fall back to its default style instead of leaving the list
		 * unskinned.
		 */
		public static const ALTERNATE_NAME_INSET_GROUPED_LIST:String = "feathers-inset-grouped-list";

		/**
		 * The default name to use with header renderers.
		 */
		public static const DEFAULT_CHILD_NAME_HEADER_RENDERER:String = "feathers-grouped-list-header-renderer";

		/**
		 * An alternate name to use with header renderers to give them an inset
		 * style.
		 */
		public static const ALTERNATE_CHILD_NAME_INSET_HEADER_RENDERER:String = "feathers-grouped-list-inset-header-renderer";

		/**
		 * The default name to use with footer renderers.
		 */
		public static const DEFAULT_CHILD_NAME_FOOTER_RENDERER:String = "feathers-grouped-list-footer-renderer";

		/**
		 * An alternate name to use with footer renderers to give them an inset
		 * style.
		 */
		public static const ALTERNATE_CHILD_NAME_INSET_FOOTER_RENDERER:String = "feathers-grouped-list-inset-footer-renderer";

		/**
		 * An alternate name to use with item renderers to give them an inset
		 * style.
		 */
		public static const ALTERNATE_CHILD_NAME_INSET_ITEM_RENDERER:String = "feathers-grouped-list-inset-item-renderer";

		/**
		 * An alternate name to use for item renderers to give them an inset
		 * style. Typically meant to be used for the renderer of the first item
		 * in a group.
		 */
		public static const ALTERNATE_CHILD_NAME_INSET_FIRST_ITEM_RENDERER:String = "feathers-grouped-list-inset-first-item-renderer";

		/**
		 * An alternate name to use for item renderers to give them an inset
		 * style. Typically meant to be used for the renderer of the last item
		 * in a group.
		 */
		public static const ALTERNATE_CHILD_NAME_INSET_LAST_ITEM_RENDERER:String = "feathers-grouped-list-inset-last-item-renderer";

		/**
		 * An alternate name to use for item renderers to give them an inset
		 * style. Typically meant to be used for the renderer of an item in a
		 * group that has no other items.
		 */
		public static const ALTERNATE_CHILD_NAME_INSET_SINGLE_ITEM_RENDERER:String = "feathers-grouped-list-inset-single-item-renderer";

		/**
		 * @copy feathers.controls.Scroller#SCROLL_POLICY_AUTO
		 */
		public static const SCROLL_POLICY_AUTO:String = "auto";

		/**
		 * @copy feathers.controls.Scroller#SCROLL_POLICY_ON
		 */
		public static const SCROLL_POLICY_ON:String = "on";

		/**
		 * @copy feathers.controls.Scroller#SCROLL_POLICY_OFF
		 */
		public static const SCROLL_POLICY_OFF:String = "off";

		/**
		 * @copy feathers.controls.Scroller#SCROLL_BAR_DISPLAY_MODE_FLOAT
		 */
		public static const SCROLL_BAR_DISPLAY_MODE_FLOAT:String = "float";

		/**
		 * @copy feathers.controls.Scroller#SCROLL_BAR_DISPLAY_MODE_FIXED
		 */
		public static const SCROLL_BAR_DISPLAY_MODE_FIXED:String = "fixed";

		/**
		 * @copy feathers.controls.Scroller#SCROLL_BAR_DISPLAY_MODE_NONE
		 */
		public static const SCROLL_BAR_DISPLAY_MODE_NONE:String = "none";

		/**
		 * @copy feathers.controls.Scroller#INTERACTION_MODE_TOUCH
		 */
		public static const INTERACTION_MODE_TOUCH:String = "touch";

		/**
		 * @copy feathers.controls.Scroller#INTERACTION_MODE_MOUSE
		 */
		public static const INTERACTION_MODE_MOUSE:String = "mouse";

		/**
		 * Constructor.
		 */
		public function GroupedList()
		{
			super();
			this.addEventListener(FeathersEventType.FOCUS_IN, list_focusInHandler);
			this.addEventListener(FeathersEventType.FOCUS_OUT, list_focusOutHandler);
		}

		/**
		 * @private
		 * The guts of the List's functionality. Handles layout and selection.
		 */
		protected var dataViewPort:GroupedListDataViewPort;

		/**
		 * @private
		 */
		protected var _layout:ILayout;

		/**
		 * The layout algorithm used to position and, optionally, size the
		 * list's items.
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
			this._layout = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
		}

		/**
		 * @private
		 */
		protected var _dataProvider:HierarchicalCollection;

		/**
		 * The collection of data displayed by the list.
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
				this._dataProvider.removeEventListener(CollectionEventType.RESET, dataProvider_resetHandler);
			}
			this._dataProvider = value;
			if(this._dataProvider)
			{
				this._dataProvider.addEventListener(CollectionEventType.RESET, dataProvider_resetHandler);
			}

			//reset the scroll position because this is a drastic change and
			//the data is probably completely different
			this.horizontalScrollPosition = 0;
			this.verticalScrollPosition = 0;

			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _isSelectable:Boolean = true;

		/**
		 * Determines if an item in the list may be selected.
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
		 * The group index of the currently selected item. Returns -1 if no item
		 * is selected.
		 *
		 * @see #selectedItemIndex
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
		 * The item index of the currently selected item. Returns -1 if no item
		 * is selected.
		 *
		 * @see #selectedGroupIndex
		 */
		public function get selectedItemIndex():int
		{
			return this._selectedItemIndex;
		}

		/**
		 * The currently selected item. Returns null if no item is selected.
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
			const result:Vector.<int> = this._dataProvider.getItemLocation(value);
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
		 * The class used to instantiate item renderers.
		 *
		 * @see feathers.controls.renderer.IGroupedListItemRenderer
		 * @see #itemRendererFactory
		 * @see #firstItemRendererType
		 * @see #firstItemRendererFactory
		 * @see #lastItemRendererType
		 * @see #lastItemRendererFactory
		 * @see #singleItemRendererType
		 * @see #singleItemRendererFactory
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
		 * @see feathers.controls.renderers.IGroupedListItemRenderer
		 * @see #itemRendererType
		 * @see #firstItemRendererType
		 * @see #firstItemRendererFactory
		 * @see #lastItemRendererType
		 * @see #lastItemRendererFactory
		 * @see #singleItemRendererType
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
		 * An item used to create a sample item renderer used for virtual layout
		 * measurement.
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
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _itemRendererName:String;

		/**
		 * A name to add to all item renderers in this list. Typically used by a
		 * theme to provide different skins to different lists.
		 *
		 * @see feathers.core.FeathersControl#nameList
		 * @see #firstItemRendererName
		 * @see #lastItemRendererName
		 * @see #singleItemRendererName
		 */
		public function get itemRendererName():String
		{
			return this._itemRendererName;
		}

		/**
		 * @private
		 */
		public function set itemRendererName(value:String):void
		{
			if(this._itemRendererName == value)
			{
				return;
			}
			this._itemRendererName = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _itemRendererProperties:PropertyProxy;

		/**
		 * A set of key/value pairs to be passed down to all of the list's item
		 * renderers. These values are shared by each item renderer, so values
		 * that cannot be shared (such as display objects that need to be added
		 * to the display list) should be passed to the item renderers using an
		 * <code>itemRendererFactory</code> or with a theme.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
		 * which is in a <code>Scroller</code> which is in a <code>List</code>,
		 * you can use the following syntax:</p>
		 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * @see feathers.controls.renderers.IGroupedListItemRenderer
		 * @see #itemRendererFactory
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
				const newValue:PropertyProxy = new PropertyProxy();
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
		 * a group.
		 *
		 * @see feathers.controls.renderer.IGroupedListItemRenderer
		 * @see #firstItemRendererFactory
		 * @see #itemRendererType
		 * @see #itemRendererFactory
		 * @see #lastItemRendererType
		 * @see #lastItemRendererFactory
		 * @see #singleItemRendererType
		 * @see #singleItemRendererFactory
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
		 * @see feathers.controls.renderers.IGroupedListItemRenderer
		 * @see #firstItemRendererType
		 * @see #itemRendererType
		 * @see #itemRendererFactory
		 * @see #lastItemRendererType
		 * @see #lastItemRendererFactory
		 * @see #singleItemRendererType
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
		protected var _firstItemRendererName:String;

		/**
		 * A name to add to all item renderers in this list that are the first
		 * item in a group. Typically used by a theme to provide different skins
		 * to different lists, and to differentiate first items from regular
		 * items if they are created with the same class. If this value is null
		 * the regular <code>itemRendererName</code> will be used instead.
		 *
		 * @see feathers.core.FeathersControl#nameList
		 * @see #itemRendererName
		 * @see #lastItemRendererName
		 * @see #singleItemRendererName
		 */
		public function get firstItemRendererName():String
		{
			return this._firstItemRendererName;
		}

		/**
		 * @private
		 */
		public function set firstItemRendererName(value:String):void
		{
			if(this._firstItemRendererName == value)
			{
				return;
			}
			this._firstItemRendererName = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _lastItemRendererType:Class;

		/**
		 * The class used to instantiate the item renderer for the last item in
		 * a group.
		 *
		 * @see feathers.controls.renderer.IGroupedListItemRenderer
		 * @see #lastItemRendererFactory
		 * @see #itemRendererType
		 * @see #itemRendererFactory
		 * @see #firstItemRendererType
		 * @see #firstItemRendererFactory
		 * @see #singleItemRendererType
		 * @see #singleItemRendererFactory
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
		 * @see feathers.controls.renderers.IGroupedListItemRenderer
		 * @see #lastItemRendererType
		 * @see #itemRendererType
		 * @see #itemRendererFactory
		 * @see #firstItemRendererType
		 * @see #firstItemRendererFactory
		 * @see #singleItemRendererType
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
		protected var _lastItemRendererName:String;

		/**
		 * A name to add to all item renderers in this list that are the last
		 * item in a group. Typically used by a theme to provide different skins
		 * to different lists, and to differentiate last items from regular
		 * items if they are created with the same class. If this value is null
		 * the regular <code>itemRendererName</code> will be used instead.
		 *
		 * @see feathers.core.FeathersControl#nameList
		 * @see #itemRendererName
		 * @see #firstItemRendererName
		 * @see #singleItemRendererName
		 */
		public function get lastItemRendererName():String
		{
			return this._lastItemRendererName;
		}

		/**
		 * @private
		 */
		public function set lastItemRendererName(value:String):void
		{
			if(this._lastItemRendererName == value)
			{
				return;
			}
			this._lastItemRendererName = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _singleItemRendererType:Class;

		/**
		 * The class used to instantiate the item renderer for an item in a
		 * group with no other items.
		 *
		 * @see feathers.controls.renderer.IGroupedListItemRenderer
		 * @see #singleItemRendererFactory
		 * @see #itemRendererType
		 * @see #itemRendererFactory
		 * @see #firstItemRendererType
		 * @see #firstItemRendererFactory
		 * @see #lastItemRendererType
		 * @see #lastItemRendererFactory
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
		 * @see feathers.controls.renderers.IGroupedListItemRenderer
		 * @see #singleItemRendererType
		 * @see #itemRendererType
		 * @see #itemRendererFactory
		 * @see #firstItemRendererType
		 * @see #firstItemRendererFactory
		 * @see #lastItemRendererType
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
		protected var _singleItemRendererName:String;

		/**
		 * A name to add to all item renderers in this list that are an item in
		 * a group with no other items. Typically used by a theme to provide
		 * different skins to different lists, and to differentiate single items
		 * from other items if they are created with the same class. If this
		 * value is null the regular <code>itemRendererName</code> will be used
		 * instead.
		 *
		 * @see feathers.core.FeathersControl#nameList
		 * @see #itemRendererName
		 * @see #firstItemRendererName
		 * @see #lastItemRendererName
		 */
		public function get singleItemRendererName():String
		{
			return this._singleItemRendererName;
		}

		/**
		 * @private
		 */
		public function set singleItemRendererName(value:String):void
		{
			if(this._singleItemRendererName == value)
			{
				return;
			}
			this._singleItemRendererName = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _headerRendererType:Class = DefaultGroupedListHeaderOrFooterRenderer;

		/**
		 * The class used to instantiate header renderers.
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
		protected var _typicalHeader:Object = null;

		/**
		 * Used to auto-size the grouped list. If the list's width or height is
		 * NaN, the grouped list will try to automatically pick an ideal size.
		 * This data is used in that process to create a sample header renderer.
		 */
		public function get typicalHeader():Object
		{
			return this._typicalHeader;
		}

		/**
		 * @private
		 */
		public function set typicalHeader(value:Object):void
		{
			if(this._typicalHeader == value)
			{
				return;
			}
			this._typicalHeader = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _headerRendererName:String = DEFAULT_CHILD_NAME_HEADER_RENDERER;

		/**
		 * A name to add to all header renderers in this grouped list. Typically
		 * used by a theme to provide different skins to different lists.
		 *
		 * @see feathers.core.FeathersControl#nameList
		 */
		public function get headerRendererName():String
		{
			return this._headerRendererName;
		}

		/**
		 * @private
		 */
		public function set headerRendererName(value:String):void
		{
			if(this._headerRendererName == value)
			{
				return;
			}
			this._headerRendererName = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
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
		 * header renderers using a <code>headerRendererFactory</code> or with a
		 * theme.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
		 * which is in a <code>Scroller</code> which is in a <code>List</code>,
		 * you can use the following syntax:</p>
		 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * @see #headerRendererFactory
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
				const newValue:PropertyProxy = new PropertyProxy();
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
		 * The class used to instantiate footer renderers.
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
		protected var _typicalFooter:Object = null;

		/**
		 * Used to auto-size the grouped list. If the grouped list's width or
		 * height is NaN, the grouped list will try to automatically pick an
		 * ideal size. This data is used in that process to create a sample
		 * footer renderer.
		 */
		public function get typicalFooter():Object
		{
			return this._typicalFooter;
		}

		/**
		 * @private
		 */
		public function set typicalFooter(value:Object):void
		{
			if(this._typicalFooter == value)
			{
				return;
			}
			this._typicalFooter = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _footerRendererName:String = DEFAULT_CHILD_NAME_FOOTER_RENDERER;

		/**
		 * A name to add to all footer renderers in this grouped list. Typically
		 * used by a theme to provide different skins to different lists.
		 *
		 * @see feathers.core.FeathersControl#nameList
		 */
		public function get footerRendererName():String
		{
			return this._footerRendererName;
		}

		/**
		 * @private
		 */
		public function set footerRendererName(value:String):void
		{
			if(this._footerRendererName == value)
			{
				return;
			}
			this._footerRendererName = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
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
		 * a theme.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
		 * which is in a <code>Scroller</code> which is in a <code>List</code>,
		 * you can use the following syntax:</p>
		 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * @see #itemRendererFactory
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
				const newValue:PropertyProxy = new PropertyProxy();
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
		 * <p>All of the header fields and functions, ordered by priority:</p>
		 * <ol>
		 *     <li><code>headerFunction</code></li>
		 *     <li><code>headerField</code></li>
		 * </ol>
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
		 * <p>All of the footer fields and functions, ordered by priority:</p>
		 * <ol>
		 *     <li><code>footerFunction</code></li>
		 *     <li><code>footerField</code></li>
		 * </ol>
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
		override public function scrollToPosition(horizontalScrollPosition:Number, verticalScrollPosition:Number, animationDuration:Number = 0):void
		{
			this.pendingItemIndex = -1;
			super.scrollToPosition(horizontalScrollPosition, verticalScrollPosition, animationDuration);
		}

		/**
		 * @private
		 */
		override public function scrollToPageIndex(horizontalPageIndex:int, verticalPageIndex:int, animationDuration:Number = 0):void
		{
			this.pendingGroupIndex = -1;
			this.pendingItemIndex = -1;
			super.scrollToPageIndex(horizontalPageIndex, verticalPageIndex, animationDuration);
		}

		/**
		 * After the next validation, scrolls the list so that the specified
		 * item is visible. If <code>animationDuration</code> is greater than
		 * zero, the scroll will animate. The duration is in seconds.
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
			const hasLayout:Boolean = this._layout != null;

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

				const layout:VerticalLayout = new VerticalLayout();
				layout.useVirtualLayout = true;
				layout.paddingTop = layout.paddingRight = layout.paddingBottom =
					layout.paddingLeft = 0;
				layout.gap = 0;
				layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
				layout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
				this._layout = layout;
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

			this.dataViewPort.itemRendererType = this._itemRendererType;
			this.dataViewPort.itemRendererFactory = this._itemRendererFactory;
			this.dataViewPort.itemRendererProperties = this._itemRendererProperties;
			this.dataViewPort.itemRendererName = this._itemRendererName;
			this.dataViewPort.typicalItem = this._typicalItem;

			this.dataViewPort.firstItemRendererType = this._firstItemRendererType;
			this.dataViewPort.firstItemRendererFactory = this._firstItemRendererFactory;
			this.dataViewPort.firstItemRendererName = this._firstItemRendererName;

			this.dataViewPort.lastItemRendererType = this._lastItemRendererType;
			this.dataViewPort.lastItemRendererFactory = this._lastItemRendererFactory;
			this.dataViewPort.lastItemRendererName = this._lastItemRendererName;

			this.dataViewPort.singleItemRendererType = this._singleItemRendererType;
			this.dataViewPort.singleItemRendererFactory = this._singleItemRendererFactory;
			this.dataViewPort.singleItemRendererName = this._singleItemRendererName;

			this.dataViewPort.headerRendererType = this._headerRendererType;
			this.dataViewPort.headerRendererFactory = this._headerRendererFactory;
			this.dataViewPort.headerRendererProperties = this._headerRendererProperties;
			this.dataViewPort.headerRendererName = this._headerRendererName;
			this.dataViewPort.typicalHeader = this._typicalHeader;

			this.dataViewPort.footerRendererType = this._footerRendererType;
			this.dataViewPort.footerRendererFactory = this._footerRendererFactory;
			this.dataViewPort.footerRendererProperties = this._footerRendererProperties;
			this.dataViewPort.footerRendererName = this._footerRendererName;
			this.dataViewPort.typicalFooter = this._typicalFooter;

			this.dataViewPort.layout = this._layout;
		}

		/**
		 * @private
		 */
		override protected function handlePendingScroll():void
		{
			if(this.pendingGroupIndex >= 0 && this.pendingItemIndex >= 0)
			{
				const item:Object = this._dataProvider.getItemAt(this.pendingGroupIndex, this.pendingItemIndex);
				if(item is Object)
				{
					this.dataViewPort.getScrollPositionForIndex(this.pendingGroupIndex, this.pendingItemIndex, HELPER_POINT);
					this.pendingGroupIndex = -1;
					this.pendingItemIndex = -1;

					if(this.pendingScrollDuration > 0)
					{
						this.throwTo(Math.max(0, Math.min(HELPER_POINT.x, this._maxHorizontalScrollPosition)),
							Math.max(0, Math.min(HELPER_POINT.y, this._maxVerticalScrollPosition)), this.pendingScrollDuration);
					}
					else
					{
						this.horizontalScrollPosition = Math.max(0, Math.min(HELPER_POINT.x, this._maxHorizontalScrollPosition));
						this.verticalScrollPosition = Math.max(0, Math.min(HELPER_POINT.y, this._maxVerticalScrollPosition));
					}
				}
			}
			super.handlePendingScroll();
		}

		/**
		 * @private
		 */
		protected function list_focusInHandler(event:Event):void
		{
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
		}

		/**
		 * @private
		 */
		protected function list_focusOutHandler(event:Event):void
		{
			this.stage.removeEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
		}

		/**
		 * @private
		 */
		protected function stage_keyDownHandler(event:KeyboardEvent):void
		{
			if(!this._dataProvider)
			{
				return;
			}
			if(event.keyCode == Keyboard.HOME)
			{
				if(this._dataProvider.getLength() > 0 && this._dataProvider.getLength(0) > 0)
				{
					this.setSelectedLocation(0, 0);
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
					const groupCount:int = this._dataProvider.getLength();
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
				}
			}
		}

		/**
		 * @private
		 */
		protected function dataProvider_resetHandler(event:Event):void
		{
			this.horizontalScrollPosition = 0;
			this.verticalScrollPosition = 0;
		}

		/**
		 * @private
		 */
		protected function dataViewPort_changeHandler(event:Event):void
		{
			this.setSelectedLocation(this.dataViewPort.selectedGroupIndex, this.dataViewPort.selectedItemIndex);
		}
	}
}
