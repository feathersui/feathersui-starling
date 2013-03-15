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
	import feathers.core.FeathersControl;
	import feathers.core.PropertyProxy;
	import feathers.data.HierarchicalCollection;
	import feathers.events.CollectionEventType;
	import feathers.events.FeathersEventType;
	import feathers.layout.ILayout;
	import feathers.layout.VerticalLayout;

	import flash.geom.Point;

	import starling.display.DisplayObject;
	import starling.events.Event;

	/**
	 * Dispatched when the selected item changes.
	 *
	 * @eventType starling.events.Event.CHANGE
	 */
	[Event(name="change",type="starling.events.Event")]

	/**
	 * Dispatched when the list is scrolled.
	 *
	 * @eventType starling.events.Event.SCROLL
	 */
	[Event(name="scroll",type="starling.events.Event")]

	/**
	 * Dispatched when the list finishes scrolling in either direction after
	 * being thrown.
	 *
	 * @eventType feathers.events.FeathersEventType.SCROLL_COMPLETE
	 */
	[Event(name="scrollComplete",type="starling.events.Event")]

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
	public class GroupedList extends FeathersControl
	{
		/**
		 * @private
		 */
		private static const HELPER_POINT:Point = new Point();

		/**
		 * The default value added to the <code>nameList</code> of the scroller.
		 */
		public static const DEFAULT_CHILD_NAME_SCROLLER:String = "feathers-list-scroller";

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
		 * Constructor.
		 */
		public function GroupedList()
		{
		}

		/**
		 * The value added to the <code>nameList</code> of the scroller.
		 */
		protected var scrollerName:String = DEFAULT_CHILD_NAME_SCROLLER;

		/**
		 * The grouped list's scroller sub-component.
		 */
		protected var scroller:Scroller;

		/**
		 * @private
		 * The guts of the List's functionality. Handles layout and selection.
		 */
		protected var dataViewPort:GroupedListDataViewPort;

		/**
		 * @private
		 */
		protected var _scrollToGroupIndex:int = -1;

		/**
		 * @private
		 */
		protected var _scrollToItemIndex:int = -1;

		/**
		 * @private
		 */
		protected var _scrollToHorizontalPageIndex:int = -1;

		/**
		 * @private
		 */
		protected var _scrollToVerticalPageIndex:int = -1;

		/**
		 * @private
		 */
		protected var _scrollToIndexDuration:Number;

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
		protected var _horizontalScrollPosition:Number = 0;

		/**
		 * The number of pixels the list has been scrolled horizontally (on
		 * the x-axis).
		 */
		public function get horizontalScrollPosition():Number
		{
			return this._horizontalScrollPosition;
		}

		/**
		 * @private
		 */
		public function set horizontalScrollPosition(value:Number):void
		{
			if(this._horizontalScrollPosition == value)
			{
				return;
			}
			if(isNaN(value))
			{
				throw new ArgumentError("horizontalScrollPosition cannot be NaN.");
			}
			this._horizontalScrollPosition = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
			this.dispatchEventWith(Event.SCROLL);
		}

		/**
		 * @private
		 */
		protected var _maxHorizontalScrollPosition:Number = 0;

		/**
		 * The maximum number of pixels the list may be scrolled horizontally
		 * (on the x-axis). This value is automatically calculated using the
		 * layout algorithm. The <code>horizontalScrollPosition</code> property
		 * may have a higher value than the maximum due to elastic edges.
		 * However, once the user stops interacting with the list, it will
		 * automatically animate back to the maximum (or minimum, if below 0).
		 */
		public function get maxHorizontalScrollPosition():Number
		{
			return this._maxHorizontalScrollPosition;
		}

		/**
		 * @private
		 */
		protected var _horizontalPageIndex:int = 0;

		/**
		 * The index of the horizontal page, if snapping is enabled. If snapping
		 * is disabled, the index will always be <code>0</code>.
		 */
		public function get horizontalPageIndex():int
		{
			return this._horizontalPageIndex;
		}

		/**
		 * @private
		 */
		protected var _verticalScrollPosition:Number = 0;

		/**
		 * The number of pixels the list has been scrolled vertically (on
		 * the y-axis).
		 */
		public function get verticalScrollPosition():Number
		{
			return this._verticalScrollPosition;
		}

		/**
		 * @private
		 */
		public function set verticalScrollPosition(value:Number):void
		{
			if(this._verticalScrollPosition == value)
			{
				return;
			}
			if(isNaN(value))
			{
				throw new ArgumentError("verticalScrollPosition cannot be NaN.");
			}
			this._verticalScrollPosition = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
			this.dispatchEventWith(Event.SCROLL);
		}

		/**
		 * @private
		 */
		protected var _maxVerticalScrollPosition:Number = 0;

		/**
		 * The maximum number of pixels the list may be scrolled vertically (on
		 * the y-axis). This value is automatically calculated based on the
		 * total combined height of the list's item renderers. The
		 * <code>verticalScrollPosition</code> property may have a higher value
		 * than the maximum due to elastic edges. However, once the user stops
		 * interacting with the list, it will automatically animate back to the
		 * maximum (or minimum, if below 0).
		 */
		public function get maxVerticalScrollPosition():Number
		{
			return this._maxVerticalScrollPosition;
		}

		/**
		 * @private
		 */
		protected var _verticalPageIndex:int = 0;

		/**
		 * The index of the vertical page, if snapping is enabled. If snapping
		 * is disabled, the index will always be <code>0</code>.
		 *
		 * @default 0
		 */
		public function get verticalPageIndex():int
		{
			return this._verticalPageIndex;
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
		protected var _scrollerProperties:PropertyProxy;

		/**
		 * A set of key/value pairs to be passed down to the list's scroller
		 * instance. The scroller is a <code>feathers.controls.Scroller</code> instace.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
		 * which is in a <code>Scroller</code> which is in a <code>List</code>,
		 * you can use the following syntax:</p>
		 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 * 
		 * @see feathers.controls.Scroller
		 */
		public function get scrollerProperties():Object
		{
			if(!this._scrollerProperties)
			{
				this._scrollerProperties = new PropertyProxy(childProperties_onChange);
			}
			return this._scrollerProperties;
		}

		/**
		 * @private
		 */
		public function set scrollerProperties(value:Object):void
		{
			if(this._scrollerProperties == value)
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
			if(this._scrollerProperties)
			{
				this._scrollerProperties.removeOnChangeCallback(childProperties_onChange);
			}
			this._scrollerProperties = PropertyProxy(value);
			if(this._scrollerProperties)
			{
				this._scrollerProperties.addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var currentBackgroundSkin:DisplayObject;

		/**
		 * @private
		 */
		protected var _backgroundSkin:DisplayObject;

		/**
		 * A display object displayed behind the item renderers.
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
		 * A background to display when the list is disabled.
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
		protected var _paddingTop:Number = 0;

		/**
		 * The minimum space, in pixels, between the list's top edge and the
		 * list's content.
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
		 * The minimum space, in pixels, between the list's right edge and the
		 * list's content.
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
		 * The minimum space, in pixels, between the list's bottom edge and
		 * the list's content.
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
		 * The minimum space, in pixels, between the list's left edge and the
		 * list's content.
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
		 * Scrolls the list so that the specified item is visible. If
		 * <code>animationDuration</code> is greater than zero, the scroll will
		 * animate. The duration is in seconds.
		 */
		public function scrollToDisplayIndex(groupIndex:int, itemIndex:int, animationDuration:Number = 0):void
		{
			if(this._scrollToGroupIndex == groupIndex && this._scrollToItemIndex == itemIndex)
			{
				return;
			}
			this._scrollToHorizontalPageIndex = -1;
			this._scrollToVerticalPageIndex = -1;
			this._scrollToGroupIndex = groupIndex;
			this._scrollToItemIndex = itemIndex;
			this._scrollToIndexDuration = animationDuration;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
		}

		/**
		 * Scrolls the list to a specific page, horizontally and vertically. If
		 * <code>horizontalPageIndex</code> or <code>verticalPageIndex</code> is
		 * -1, it will be ignored
		 */
		public function scrollToPageIndex(horizontalPageIndex:int, verticalPageIndex:int, animationDuration:Number = 0):void
		{
			const horizontalPageHasChanged:Boolean = (this._scrollToHorizontalPageIndex >= 0 && this._scrollToHorizontalPageIndex != horizontalPageIndex) ||
				(this._scrollToHorizontalPageIndex < 0 && this._horizontalPageIndex != horizontalPageIndex);
			const verticalPageHasChanged:Boolean = (this._scrollToVerticalPageIndex >= 0 && this._scrollToVerticalPageIndex != verticalPageIndex) ||
				(this._scrollToVerticalPageIndex < 0 && this._verticalPageIndex != verticalPageIndex);
			const durationHasChanged:Boolean = (this._scrollToHorizontalPageIndex >= 0 || this._scrollToVerticalPageIndex >= 0) && this._scrollToIndexDuration == animationDuration
			if(!horizontalPageHasChanged && !verticalPageHasChanged &&
				!durationHasChanged)
			{
				return;
			}
			this._scrollToHorizontalPageIndex = horizontalPageIndex;
			this._scrollToVerticalPageIndex = verticalPageIndex;
			this._scrollToGroupIndex = -1;
			this._scrollToItemIndex = -1;
			this._scrollToIndexDuration = animationDuration;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
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
		 * If the user is dragging the scroll, calling stopScrolling() will
		 * cause the grouped list to ignore the drag. The children of the list
		 * will still receive touches, so it's useful to call this if the
		 * children need to support touches or dragging without the list
		 * also scrolling.
		 */
		public function stopScrolling():void
		{
			if(!this.scroller)
			{
				return;
			}
			this.scroller.stopScrolling();
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
			if(!this.scroller)
			{
				this.scroller = new Scroller();
				this.scroller.nameList.add(this.scrollerName);
				this.scroller.verticalScrollPolicy = Scroller.SCROLL_POLICY_AUTO;
				this.scroller.horizontalScrollPolicy = Scroller.SCROLL_POLICY_AUTO;
				this.scroller.addEventListener(Event.SCROLL, scroller_scrollHandler);
				this.scroller.addEventListener(FeathersEventType.SCROLL_COMPLETE, scroller_scrollCompleteHandler);
				this.addChild(this.scroller);
			}

			if(!this.dataViewPort)
			{
				this.dataViewPort = new GroupedListDataViewPort();
				this.dataViewPort.owner = this;
				this.dataViewPort.addEventListener(Event.CHANGE, dataViewPort_changeHandler);
				this.scroller.viewPort = this.dataViewPort;
			}

			if(!this._layout)
			{
				const layout:VerticalLayout = new VerticalLayout();
				layout.useVirtualLayout = true;
				layout.paddingTop = layout.paddingRight = layout.paddingBottom =
					layout.paddingLeft = 0;
				layout.gap = 0;
				layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
				layout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
				this._layout = layout;
				this.scroller.verticalScrollPolicy = Scroller.SCROLL_POLICY_ON;
			}
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			const scrollInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SCROLL);
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			const stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);

			if(stylesInvalid)
			{
				this.refreshScrollerStyles();
			}

			if(sizeInvalid || stylesInvalid || stateInvalid)
			{
				this.refreshBackgroundSkin();
			}

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

			this.scroller.isEnabled = this._isEnabled;
			this.scroller.x = this._paddingLeft;
			this.scroller.y = this._paddingTop;
			this.scroller.horizontalScrollPosition = this._horizontalScrollPosition;
			this.scroller.verticalScrollPosition = this._verticalScrollPosition;

			if(sizeInvalid || stylesInvalid)
			{
				if(isNaN(this.explicitWidth))
				{
					this.scroller.width = NaN;
				}
				else
				{
					this.scroller.width = Math.max(0, this.explicitWidth - this._paddingLeft - this._paddingRight);
				}
				if(isNaN(this.explicitHeight))
				{
					this.scroller.height = NaN;
				}
				else
				{
					this.scroller.height = Math.max(0, this.explicitHeight - this._paddingTop - this._paddingBottom);
				}
				this.scroller.minWidth = Math.max(0,  this._minWidth - this._paddingLeft - this._paddingRight);
				this.scroller.maxWidth = Math.max(0, this._maxWidth - this._paddingLeft - this._paddingRight);
				this.scroller.minHeight = Math.max(0, this._minHeight - this._paddingTop - this._paddingBottom);
				this.scroller.maxHeight = Math.max(0, this._maxHeight - this._paddingTop - this._paddingBottom);
			}

			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

			if(sizeInvalid || stylesInvalid || stateInvalid)
			{
				if(this.currentBackgroundSkin)
				{
					this.currentBackgroundSkin.width = this.actualWidth;
					this.currentBackgroundSkin.height = this.actualHeight;
				}
			}

			this.scroller.validate();
			this._maxHorizontalScrollPosition = this.scroller.maxHorizontalScrollPosition;
			this._maxVerticalScrollPosition = this.scroller.maxVerticalScrollPosition;
			this._horizontalScrollPosition = this.scroller.horizontalScrollPosition;
			this._verticalScrollPosition = this.scroller.verticalScrollPosition;
			this._horizontalPageIndex = this.scroller.horizontalPageIndex;
			this._verticalPageIndex = this.scroller.verticalPageIndex;

			this.scroll();
		}

		/**
		 * @private
		 */
		protected function autoSizeIfNeeded():Boolean
		{
			const needsWidth:Boolean = isNaN(this.explicitWidth);
			const needsHeight:Boolean = isNaN(this.explicitHeight);
			if(!needsWidth && !needsHeight)
			{
				return false;
			}

			this.scroller.validate();
			var newWidth:Number = this.explicitWidth;
			var newHeight:Number = this.explicitHeight;
			if(needsWidth)
			{
				newWidth = this.scroller.width + this._paddingLeft + this._paddingRight;
			}
			if(needsHeight)
			{
				newHeight = this.scroller.height + this._paddingTop + this._paddingBottom;
			}

			return this.setSizeInternal(newWidth, newHeight, false);
		}

		/**
		 * @private
		 */
		protected function refreshScrollerStyles():void
		{
			for(var propertyName:String in this._scrollerProperties)
			{
				if(this.scroller.hasOwnProperty(propertyName))
				{
					var propertyValue:Object = this._scrollerProperties[propertyName];
					this.scroller[propertyName] = propertyValue;
				}
			}
		}

		/**
		 * @private
		 */
		protected function refreshBackgroundSkin():void
		{
			this.currentBackgroundSkin = this._backgroundSkin;
			if(!this._isEnabled && this._backgroundDisabledSkin)
			{
				if(this._backgroundSkin)
				{
					this._backgroundSkin.visible = false;
				}
				this.currentBackgroundSkin = this._backgroundDisabledSkin;
			}
			else if(this._backgroundDisabledSkin)
			{
				this._backgroundDisabledSkin.visible = false;
			}
			if(this.currentBackgroundSkin)
			{
				this.currentBackgroundSkin.visible = true;
			}
		}

		/**
		 * @private
		 */
		protected function scroll():void
		{
			if(this._scrollToHorizontalPageIndex >= 0 || this._scrollToVerticalPageIndex >= 0)
			{
				this.scroller.throwToPage(this._scrollToHorizontalPageIndex, this._scrollToVerticalPageIndex, this._scrollToIndexDuration);
				this._scrollToHorizontalPageIndex = -1;
				this._scrollToVerticalPageIndex = -1;
			}
			else if(this._scrollToGroupIndex >= 0 && this._scrollToItemIndex >= 0)
			{
				const item:Object = this._dataProvider.getItemAt(this._scrollToGroupIndex, this._scrollToItemIndex);
				if(item is Object)
				{
					this.dataViewPort.getScrollPositionForIndex(this._scrollToGroupIndex, this._scrollToItemIndex, HELPER_POINT);

					if(this._scrollToIndexDuration > 0)
					{
						this.scroller.throwTo(Math.max(0, Math.min(HELPER_POINT.x, this._maxHorizontalScrollPosition)),
							Math.max(0, Math.min(HELPER_POINT.y, this._maxVerticalScrollPosition)), this._scrollToIndexDuration);
					}
					else
					{
						this.horizontalScrollPosition = Math.max(0, Math.min(HELPER_POINT.x, this._maxHorizontalScrollPosition));
						this.verticalScrollPosition = Math.max(0, Math.min(HELPER_POINT.y, this._maxVerticalScrollPosition));
					}
				}
				this._scrollToGroupIndex = -1;
				this._scrollToItemIndex = -1;
			}
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
		protected function dataProvider_resetHandler(event:Event):void
		{
			this.horizontalScrollPosition = 0;
			this.verticalScrollPosition = 0;
		}

		/**
		 * @private
		 */
		protected function scroller_scrollHandler(event:Event):void
		{
			this._maxHorizontalScrollPosition = this.scroller.maxHorizontalScrollPosition;
			this._maxVerticalScrollPosition = this.scroller.maxVerticalScrollPosition;
			this._horizontalPageIndex = this.scroller.horizontalPageIndex;
			this._verticalPageIndex = this.scroller.verticalPageIndex;
			this._horizontalScrollPosition = this.scroller.horizontalScrollPosition;
			this._verticalScrollPosition = this.scroller.verticalScrollPosition;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
			this.dispatchEventWith(Event.SCROLL);
		}

		/**
		 * @private
		 */
		protected function scroller_scrollCompleteHandler(event:Event):void
		{
			this.dispatchEventWith(FeathersEventType.SCROLL_COMPLETE);
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
