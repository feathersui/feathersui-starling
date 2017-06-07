/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.controls.supportClasses.TreeDataViewPort;
	import feathers.data.IHierarchicalCollection;
	import feathers.events.CollectionEventType;
	import starling.events.Event;
	import feathers.controls.Scroller;
	import feathers.layout.IVariableVirtualLayout;
	import feathers.layout.ILayout;
	import feathers.layout.VerticalLayout;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.VerticalAlign;
	import flash.geom.Point;
	import feathers.skins.IStyleProvider;
	import feathers.controls.renderers.ITreeItemRenderer;
	import feathers.controls.renderers.DefaultTreeItemRenderer;
	import feathers.data.ArrayCollection;

	/**
	 * A style name to add to all item renderers in this tree. Typically
	 * used by a theme to provide different styles to different trees.
	 *
	 * <p>The following example sets the item renderer style name:</p>
	 *
	 * <listing version="3.0">
	 * tree.customItemRendererStyleName = "my-custom-item-renderer";</listing>
	 *
	 * <p>In your theme, you can target this sub-component style name to
	 * provide different skins than the default:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( DefaultTreeItemRenderer ).setFunctionForStyleName( "my-custom-item-renderer", setCustomItemRendererStyles );</listing>
	 *
	 * @default null
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	[Style(name="customItemRendererStyleName",type="String")]

	/**
	 * The duration, in seconds, of the animation when the selected item is
	 * changed by keyboard navigation and the item scrolls into view.
	 *
	 * <p>In the following example, the duration of the animation that
	 * scrolls the tree to a new selected item is set to 500 milliseconds:</p>
	 *
	 * <listing version="3.0">
	 * tree.keyScrollDuration = 0.5;</listing>
	 *
	 * @default 0.25
	 */
	[Style(name="keyScrollDuration",type="Number")]

	/**
	 * The layout algorithm used to position and, optionally, size the
	 * tree's items.
	 *
	 * <p>By default, if no layout is provided by the time that the tree
	 * initializes, a vertical layout with options targeted at touch screens
	 * is created.</p>
	 *
	 * <p>The following example tells the tree to use a horizontal layout:</p>
	 *
	 * <listing version="3.0">
	 * var layout:HorizontalLayout = new HorizontalLayout();
	 * layout.gap = 20;
	 * layout.padding = 20;
	 * tree.layout = layout;</listing>
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
	 *
	 * @eventType starling.events.Event.CHANGE
	 */
	[Event(name="change",type="starling.events.Event")]

	/**
	 * Dispatched when the the user taps or clicks an item renderer in the tree.
	 * The touch must remain within the bounds of the item renderer on release,
	 * and the tree must not have scrolled, to register as a tap or a click.
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
	 * Dispatched when an item renderer is added to the tree. When the layout is
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
	 * Dispatched when an item renderer is removed from the tree. When the layout is
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
	 * Dispatched when a branch is opened.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>The data for the branch that was opened</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @eventType starling.events.Event.OPEN
	 *
	 * @see #event:close starling.events.Event.CLOSE
	 * @see #isBranchOpen()
	 * @see #toggleBranch()
	 */
	[Event(name="open",type="starling.events.Event")]

	/**
	 * Dispatched when a branch is closed.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>The data for the branch that was closed</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @eventType starling.events.Event.CLOSE
	 *
	 * @see #event:open starling.events.Event.OPEN
	 * @see #isBranchOpen()
	 * @see #toggleBranch()
	 */
	[Event(name="close",type="starling.events.Event")]

	[DefaultProperty("dataProvider")]
	/**
	 * Displays a hierarchical tree of items. Supports scrolling, custom item
	 * renderers, and custom layouts.
	 *
	 * <p>The following example creates a tree, gives it a data provider, and
	 * tells the item renderer how to interpret the data:</p>
	 *
	 * <listing version="3.0">
	 * var tree:Tree = new Tree();
	 * 
	 * tree.dataProvider = new ArrayHierarchicalCollection(
	 * [
	 *     {
	 *         text: "Node 1",
	 *         children:
	 *         [
	 *             {
	 *                 text: "Node 1A",
	 *                 children:
	 *                 [
	 *                     { text: "Node 1A-I" },
	 *                     { text: "Node 1A-II" },
	 *                 ]
	 *             },
	 *             { text: "Node 1B" },
	 *         ]
	 *     },
	 *     { text: "Node 2" },
	 *     {
	 *         text: "Node 3",
	 *         children:
	 *         [
	 *             { text: "Node 4A" },
	 *             { text: "Node 4B" },
	 *             { text: "Node 4C" },
	 *         ]
	 *     }
	 * ]);
	 * 
	 * tree.itemRendererFactory = function():ITreeItemRenderer
	 * {
	 *     var itemRenderer:DefaultTreeItemRenderer = new DefaultTreeItemRenderer();
	 *     itemRenderer.labelField = "text";
	 *     return itemRenderer;
	 * };
	 * 
	 * this.addChild( tree );</listing>
	 *
	 * @see ../../../help/tree.html How to use the Feathers Tree component
	 * @see ../../../help/default-item-renderers.html How to use the Feathers default item renderer
	 * @see ../../../help/item-renderers.html Creating custom item renderers for the Feathers Tree component
	 *
	 * @productversion Feathers 3.3.0
	 */
	public class Tree extends Scroller
	{
		/**
		 * The default <code>IStyleProvider</code> for all <code>Tree</code>
		 * components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * Constructor
		 */
		public function Tree()
		{
			super();
		}

		/**
		 * @private
		 * The guts of the Tree's functionality. Handles layout and selection.
		 */
		protected var dataViewPort:TreeDataViewPort;

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return Tree.globalStyleProvider;
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
		protected var _dataProvider:IHierarchicalCollection = null;

		/**
		 * The collection of data displayed by the tree. Changing this property
		 * to a new value is considered a drastic change to the tree's data, so
		 * the horizontal and vertical scroll positions will be reset, and the
		 * tree's selection will be cleared.
		 *
		 * <p>The following example passes in a data provider and tells the item
		 * renderer how to interpret the data:</p>
		 *
		 * <listing version="3.0"> 
		 * tree.dataProvider = new ArrayHierarchicalCollection(
		 * [
		 *     {
		 *         text: "Node 1",
		 *         children:
		 *         [
		 *             {
		 *                 text: "Node 1A",
		 *                 children:
		 *                 [
		 *                     { text: "Node 1A-I" },
		 *                     { text: "Node 1A-II" },
		 *                 ]
		 *             },
		 *             { text: "Node 1B" },
		 *         ]
		 *     },
		 *     { text: "Node 2" },
		 *     {
		 *         text: "Node 3",
		 *         children:
		 *         [
		 *             { text: "Node 4A" },
		 *             { text: "Node 4B" },
		 *             { text: "Node 4C" },
		 *         ]
		 *     }
		 * ]);
		 * 
		 * tree.itemRendererFactory = function():ITreeItemRenderer
		 * {
		 *     var itemRenderer:DefaultTreeItemRenderer = new DefaultTreeItemRenderer();
		 *     itemRenderer.labelField = "text";
		 *     return itemRenderer;
		 * };</listing>
		 *
		 * <p><em>Warning:</em> A tree's data provider cannot contain duplicate
		 * items. To display the same item in multiple item renderers, you must
		 * create separate objects with the same properties. This limitation
		 * exists because it significantly improves performance.</p>
		 *
		 * <p><em>Warning:</em> If the data provider contains display objects,
		 * concrete textures, or anything that needs to be disposed, those
		 * objects will not be automatically disposed when the list is disposed.
		 * Similar to how <code>starling.display.Image</code> cannot
		 * automatically dispose its texture because the texture may be used
		 * by other display objects, a list cannot dispose its data provider
		 * because the data provider may be used by other lists. See the
		 * <code>dispose()</code> function on <code>IHierarchicalCollection</code> to
		 * see how the data provider can be disposed properly.</p>
		 *
		 * @default null
		 *
		 * @see feathers.data.IHierarchicalCollection#dispose()
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
			if(this._dataProvider === value)
			{
				return;
			}
			if(this._dataProvider !== null)
			{
				this._dataProvider.removeEventListener(CollectionEventType.REMOVE_ITEM, dataProvider_removeItemHandler);
				this._dataProvider.removeEventListener(CollectionEventType.REMOVE_ALL, dataProvider_removeAllHandler);
				this._dataProvider.removeEventListener(CollectionEventType.REPLACE_ITEM, dataProvider_replaceItemHandler);
				this._dataProvider.removeEventListener(CollectionEventType.RESET, dataProvider_resetHandler);
				this._dataProvider.removeEventListener(Event.CHANGE, dataProvider_changeHandler);
			}
			this._dataProvider = value;
			if(this._dataProvider !== null)
			{
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
			this.selectedItem = null;

			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _isSelectable:Boolean = true;

		/**
		 * Determines if an item in the tree may be selected.
		 *
		 * <p>The following example disables selection:</p>
		 *
		 * <listing version="3.0">
	 	 * tree.isSelectable = false;</listing>
		 *
		 * @default true
		 *
		 * @see #selectedItem
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
			if(this._isSelectable === value)
			{
				return;
			}
			this._isSelectable = value;
			if(!this._isSelectable)
			{
				this.selectedItem = null;
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
		protected var _selectedItem:Object = null;

		/**
		 * The currently selected item. Returns <code>null</code> if no item is
		 * selected.
		 *
		 * <p>The following example listens for when selection changes and
		 * requests the selected item:</p>
		 *
		 * <listing version="3.0">
		 * function tree_changeHandler( event:Event ):void
		 * {
		 *     var tree:Tree = Tree( event.currentTarget );
		 *     var item:Object = tree.selectedItem;
		 *
		 * }
		 * tree.addEventListener( Event.CHANGE, tree_changeHandler );</listing>
		 *
		 * @default null
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
			if(this._dataProvider === null)
			{
				value = null;
			}
			if(value !== null)
			{
				var result:Vector.<int> = this._dataProvider.getItemLocation(value, this._helperLocation);
				if(result === null || result.length === 0)
				{
					value = null;
				}
			}
			if(this._selectedItem === value)
			{
				return;
			}
			this._selectedItem = value;
			this.dispatchEventWith(Event.CHANGE);
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
			if(this._layout === value)
			{
				return;
			}
			if(this._layout !== null)
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
		protected var _itemRendererType:Class = DefaultTreeItemRenderer;

		/**
		 * The class used to instantiate item renderers. Must implement the
		 * <code>ITreeItemRenderer</code> interface.
		 *
		 * <p>To customize properties on the item renderer, use
		 * <code>itemRendererFactory</code> instead.</p>
		 *
		 * <p>The following example changes the item renderer type:</p>
		 *
		 * <listing version="3.0">
		 * tree.itemRendererType = CustomItemRendererClass;</listing>
		 *
		 * @default feathers.controls.renderers.DefaultTreeItemRenderer
		 *
		 * @see feathers.controls.renderers.ITreeItemRenderer
		 * @see #itemRendererFactory
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
			if(this._itemRendererType === value)
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
		 * <pre>function():ITreeItemRenderer</pre>
		 *
		 * <p>The following example provides a factory for the item renderer:</p>
		 *
		 * <listing version="3.0">
		 * tree.itemRendererFactory = function():ITreeItemRenderer
		 * {
		 *     var renderer:CustomItemRendererClass = new CustomItemRendererClass();
		 *     renderer.backgroundSkin = new Quad( 10, 10, 0xff0000 );
		 *     return renderer;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.renderers.ITreeItemRenderer
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
		 * When a tree requires multiple item renderer types, this function is
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
		 * <pre>function(item:Object, location:Vector.&lt;int&gt;):String</pre>
		 *
		 * <p>The following example provides a <code>factoryIDFunction</code>:</p>
		 *
		 * <listing version="3.0">
		 * function regularItemFactory():ITreeItemRenderer
		 * {
		 *     return new DefaultTreeItemRenderer();
		 * }
		 * function firstItemFactory():ITreeItemRenderer
		 * {
		 *     return new CustomItemRenderer();
		 * }
		 * tree.setItemRendererFactoryWithID( "regular-item", regularItemFactory );
		 * tree.setItemRendererFactoryWithID( "first-item", firstItemFactory );
		 *
		 * tree.factoryIDFunction = function( item:Object, location:Vector.&lt;int&gt; ):String
		 * {
		 *     if(location.length === 1 &amp;&amp; location[0] === 0)
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
		 * Used to auto-size the tree when a virtualized layout is used. If the
		 * tree's width or height is unknown, the tree will try to automatically
		 * pick an ideal size. This item is used to create a sample item
		 * renderer to measure item renderers that are virtual and not visible
		 * in the viewport.
		 *
		 * <p>The following example provides a typical item:</p>
		 *
		 * <listing version="3.0">
		 * tree.typicalItem = { text: "A typical item", thumbnail: texture };</listing>
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
			if(this._typicalItem === value)
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
			if(this._keyScrollDuration === value)
			{
				return;
			}
			this._keyScrollDuration = value;
		}

		/**
		 * @private
		 */
		override public function dispose():void
		{
			//clearing selection now so that the data provider setter won't
			//cause a selection change that triggers events.
			this._selectedItem = null;
			this.dataProvider = null;
			this.layout = null;
			super.dispose();
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
		 * types of item renderers may be displayed in the tree. A custom
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
		 * Returns the current item renderer used to render a specific item. May
		 * return <code>null</code> if an item doesn't currently have an item
		 * renderer. Most trees use virtual layouts where only the visible items
		 * will have an item renderer, so the result will usually be
		 * <code>null</code> for most items in the data provider.
		 *
		 * @see ../../../help/faq/layout-virtualization.html What is layout virtualization?
		 */
		public function itemToItemRenderer(item:Object):ITreeItemRenderer
		{
			return this.dataViewPort.itemToItemRenderer(item);
		}

		/**
		 * @private
		 */
		protected var _openBranches:ArrayCollection = new ArrayCollection();

		/**
		 * Opens or closes a branch.
		 *
		 * @see #isBranchOpen()
		 * @see #event:open starling.events.Event.OPEN
		 * @see #event:close starling.events.Event.CLOSE
		 */
		public function toggleBranch(branch:Object, open:Boolean):void
		{
			if(this._dataProvider === null || !this._dataProvider.isBranch(branch))
			{
				throw new ArgumentError("toggleBranch() may not open an item that is not a branch.");
			}
			var index:int = this._openBranches.getItemIndex(branch);
			if(open)
			{
				if(index !== -1)
				{
					//the branch is already open
					return;
				}
				this._openBranches.addItem(branch);
				this.dispatchEventWith(Event.OPEN, false, branch);
			}
			else //close
			{
				if(index === -1)
				{
					//the branch is already closed
					return;
				}
				this._openBranches.removeItem(branch);
				this.dispatchEventWith(Event.CLOSE, false, branch);
			}
		}

		/**
		 * Indicates if a branch from the data provider is open or closed.
		 *
		 * @see #toggleBranch()
		 * @see #event:open starling.events.Event.OPEN
		 * @see #event:close starling.events.Event.CLOSE
		 */
		public function isBranchOpen(branch:Object):Boolean
		{
			if(this._dataProvider === null || !this._dataProvider.isBranch(branch))
			{
				return false;
			}
			return this._openBranches.getItemIndex(branch) !== -1;
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
				this.viewPort = this.dataViewPort = new TreeDataViewPort();
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
			this.dataViewPort.selectedItem = this._selectedItem;
			this.dataViewPort.dataProvider = this._dataProvider;
			this.dataViewPort.typicalItem = this._typicalItem;
			this.dataViewPort.openBranches = this._openBranches;

			this.dataViewPort.itemRendererType = this._itemRendererType;
			this.dataViewPort.itemRendererFactory = this._itemRendererFactory;
			this.dataViewPort.itemRendererFactories = this._itemRendererFactories;
			this.dataViewPort.factoryIDFunction = this._factoryIDFunction;
			this.dataViewPort.customItemRendererStyleName = this._customItemRendererStyleName;

			this.dataViewPort.layout = this._layout;
		}

		/**
		 * @private
		 */
		protected function validateSelectedItemIsInCollection():void
		{
			if(this._selectedItem === null)
			{
				return;
			}
			var selectedItemLocation:Vector.<int> = this._dataProvider.getItemLocation(this._selectedItem, this._helperLocation);
			if(selectedItemLocation === null || selectedItemLocation.length === 0)
			{
				this.selectedItem = null;
			}
		}

		/**
		 * @private
		 */
		protected function dataViewPort_changeHandler(event:Event):void
		{
			this.selectedItem = this.dataViewPort.selectedItem;
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
			this.selectedItem = null;
		}

		/**
		 * @private
		 */
		protected function dataProvider_removeAllHandler(event:Event):void
		{
			this.selectedItem = null;
		}

		/**
		 * @private
		 */
		protected function dataProvider_removeItemHandler(event:Event, indices:Array):void
		{
			this.validateSelectedItemIsInCollection();
		}

		/**
		 * @private
		 */
		protected function dataProvider_filterChangeHandler(event:Event):void
		{
			this.validateSelectedItemIsInCollection();
		}

		/**
		 * @private
		 */
		protected function dataProvider_replaceItemHandler(event:Event, indices:Array):void
		{
			this.validateSelectedItemIsInCollection();
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