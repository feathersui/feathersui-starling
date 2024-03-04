/*
Feathers
Copyright 2012-2021 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.data
{
	import feathers.core.IFeathersEventDispatcher;

	/**
	 * Dispatched when the underlying data source changes and components will
	 * need to redraw the data.
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
	 * Dispatched when the collection has changed drastically, such as when
	 * the underlying data source is replaced completely.
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
	 * @eventType feathers.events.CollectionEventType.RESET
	 */
	[Event(name="reset",type="starling.events.Event")]

	/**
	 * Dispatched when an item is added to the collection.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>The index of the item that has been
	 * added. It is of type <code>int</code>.</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @eventType feathers.events.CollectionEventType.ADD_ITEM
	 */
	[Event(name="addItem",type="starling.events.Event")]

	/**
	 * Dispatched when an item is removed from the collection.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>The index of the item that has been
	 * removed. It is of type <code>int</code>.</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @eventType feathers.events.CollectionEventType.REMOVE_ITEM
	 */
	[Event(name="removeItem",type="starling.events.Event")]

	/**
	 * Dispatched when an item is replaced in the collection.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>The index of the item that has been
	 * replaced. It is of type <code>int</code>.</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @eventType feathers.events.CollectionEventType.REPLACE_ITEM
	 */
	[Event(name="replaceItem",type="starling.events.Event")]

	/**
	 * Dispatched when the <code>updateItemAt()</code> function is called on the
	 * <code>IListCollection</code>.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>The index of the item that has been
	 * updated. It is of type <code>int</code>.</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @see #updateItemAt()
	 *
	 * @eventType feathers.events.CollectionEventType.UPDATE_ITEM
	 */
	[Event(name="updateItem",type="starling.events.Event")]

	/**
	 * Dispatched when the <code>updateAll()</code> function is called on the
	 * <code>IListCollection</code>.
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
	 * @see #updateAll()
	 *
	 * @eventType feathers.events.CollectionEventType.UPDATE_ALL
	 */
	[Event(name="updateAll",type="starling.events.Event")]

	/**
	 * Dispatched when the <code>filterFunction</code> property changes or the
	 * <code>refresh()</code> function is called on the <code>IListCollection</code>.
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
	 * @see #filterFunction
	 * @see #refresh()
	 *
	 * @eventType feathers.events.CollectionEventType.FILTER_CHANGE
	 */
	[Event(name="filterChange",type="starling.events.Event")]

	/**
	 * Dispatched when the <code>sortCompareFunction</code> property changes or
	 * the <code>refresh()</code> function is called on the <code>IListCollection</code>.
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
	 * @see #sortCompareFunction
	 * @see #refresh()
	 *
	 * @eventType feathers.events.CollectionEventType.SORT_CHANGE
	 */
	[Event(name="sortChange",type="starling.events.Event")]

	/**
	 * Interface for list collections.
	 *
	 * @productversion Feathers 3.3.0
	 */
	public interface IListCollection extends IFeathersEventDispatcher
	{
		/**
		 * The number of items in the collection.
		 */
		function get length():int;

		/**
		 * A function to determine if each item in the collection should be
		 * included or excluded from visibility through APIs like
		 * <code>length</code> and <code>getItemAt()</code>.
		 *
		 * <p>The function is expected to have the following signature:</p>
		 * <pre>function( item:Object ):Boolean</pre>
		 *
		 * <p>In the following example, the filter function is based on the
		 * text of a <code>TextInput</code> component:</p>
		 *
		 * <listing version="3.0">
		 * var collection:IListCollection; //this would be created from a concrete implementation
		 * 
		 * var list:List = new List();
		 * list.dataProvider = collection;
		 * this.addChild( list );
		 * 
		 * var input:TextInput = new TextInput();
		 * input.addEventListener( Event.CHANGE, function():void
		 * {
		 *    if( input.text.length == 0 )
		 *    {
		 *        collection.filterFunction = null;
		 *        return;
		 *    }
		 *    collection.filterFunction = function( item:Object ):Boolean
		 *    {
		 *        var itemText:String = item.label.toLowerCase();
		 *        var filterText:String = input.text.toLowerCase();
		 *        return itemText.indexOf( filterText ) >= 0;
		 *    };
		 * } );
		 * this.addChild( input );</listing>
		 *
		 * @default null
		 */
		function get filterFunction():Function;

		/**
		 * @private
		 */
		function set filterFunction(value:Function):void;

		/**
		 * A function to compare each item in the collection to determine the
		 * order when sorted.
		 *
		 * <p>The function is expected to have the following signature:</p>
		 * <pre>function( a:Object, b:Object ):int</pre>
		 *
		 * <p>The return value should be <code>-1</code> if the first item
		 * should appear before the second item when the collection is sorted.
		 * The return value should be <code>1</code> if the first item should
		 * appear after the second item when the collection in sorted. Finally,
		 * the return value should be <code>0</code> if both items have the
		 * same sort order.</p>
		 *
		 * @default null
		 */
		function get sortCompareFunction():Function;

		/**
		 * @private
		 */
		function set sortCompareFunction(value:Function):void;

		/**
		 * Refreshes the collection using the <code>filterFunction</code>
		 * or <code>sortCompareFunction</code> without passing in a new values
		 * for these properties. Useful when either of these functions relies
		 * on external variables that have changed.
		 */
		function refresh():void;

		/**
		 * Call <code>updateItemAt()</code> to manually inform any component
		 * rendering the <code>IListCollection</code> that the properties of a
		 * single item in the collection have changed, and that any views
		 * associated with the item should be updated. The collection will
		 * dispatch the <code>CollectionEventType.UPDATE_ITEM</code> event.
		 *
		 * <p>Alternatively, the item can dispatch an event when one of its
		 * properties has changed, and a custom item renderer can listen for
		 * that event and update itself automatically.</p>
		 *
		 * @see #updateAll()
		 */
		function updateItemAt(index:int):void;

		/**
		 * Call <code>updateAll()</code> to manually inform any component
		 * rendering the <code>IListCollection</code> that the properties of all,
		 * or many, of the collection's items have changed, and that any
		 * rendered views should be updated. The collection will dispatch the
		 * <code>CollectionEventType.UPDATE_ALL</code> event.
		 *
		 * <p>Alternatively, the item can dispatch an event when one of its
		 * properties has changed, and a custom item renderer can listen for
		 * that event and update itself automatically.</p>
		 *
		 * @see #updateItemAt()
		 */
		function updateAll():void;

		/**
		 * Returns the item at the specified index in the collection.
		 */
		function getItemAt(index:int):Object;

		/**
		 * Determines which index the item appears at within the collection. If
		 * the item isn't in the collection, returns <code>-1</code>.
		 *
		 * <p>If the collection is filtered, <code>getItemIndex()</code> will
		 * return <code>-1</code> for items that are excluded by the filter.</p>
		 */
		function getItemIndex(item:Object):int;

		/**
		 * Adds an item to the collection, at the specified index.
		 *
		 * <p>If the collection is filtered, the index is the position in the
		 * filtered data, rather than position in the unfiltered data.</p>
		 */
		function addItemAt(item:Object, index:int):void;

		/**
		 * Removes the item at the specified index from the collection and
		 * returns it.
		 *
		 * <p>If the collection is filtered, the index is the position in the
		 * filtered data, rather than position in the unfiltered data.</p>
		 */
		function removeItemAt(index:int):Object;

		/**
		 * Removes a specific item from the collection.
		 *
		 * <p>If the collection is filtered, <code>removeItem()</code> will not
		 * remove the item from the unfiltered data if it is not included in the
		 * filtered data. If the item is not removed,
		 * <code>CollectionEventType.REMOVE_ITEM</code> will not be dispatched.</p>
		 */
		function removeItem(item:Object):void;

		/**
		 * Removes all items from the collection.
		 */
		function removeAll():void;

		/**
		 * Replaces the item at the specified index with a new item.
		 */
		function setItemAt(item:Object, index:int):void;

		/**
		 * Adds an item to the end of the collection.
		 *
		 * <p>If the collection is filtered, <code>addItem()</code> may add
		 * the item to the unfiltered data, but omit it from the filtered data.
		 * If the item is omitted from the filtered data,
		 * <code>CollectionEventType.ADD_ITEM</code> will not be dispatched.</p>
		 */
		function addItem(item:Object):void;

		/**
		 * Adds all items from another collection.
		 */
		function addAll(collection:IListCollection):void;

		/**
		 * Adds all items from another collection, placing the items at a
		 * specific index in this collection.
		 */
		function addAllAt(collection:IListCollection, index:int):void;

		/**
		 * Replaces the collection's data with data from another collection.
		 */
		function reset(collection:IListCollection):void;

		/**
		 * A convenient alias for <code>addItem()</code>.
		 *
		 * @see #addItem()
		 */
		function push(item:Object):void;

		/**
		 * Removes the item from the end of the collection and returns it.
		 */
		function pop():Object;

		/**
		 * Adds an item to the beginning of the collection.
		 */
		function unshift(item:Object):void;

		/**
		 * Removes the first item in the collection and returns it.
		 */
		function shift():Object;

		/**
		 * Determines if the specified item is in the collection.
		 *
		 * <p>If the collection is filtered, <code>contains()</code> will return
		 * <code>false</code> for items that are excluded by the filter.</p>
		 */
		function contains(item:Object):Boolean;

		/**
		 * Calls a function for each item in the collection that may be used
		 * to dispose any properties on the item. For example, display objects
		 * or textures may need to be disposed.
		 *
		 * <p>The function is expected to have the following signature:</p>
		 * <pre>function( item:Object ):void</pre>
		 *
		 * <p>In the following example, the items in the collection are disposed:</p>
		 *
		 * <listing version="3.0">
		 * collection.dispose( function( item:Object ):void
		 * {
		 *     var accessory:DisplayObject = DisplayObject(item.accessory);
		 *     accessory.dispose();
		 * }</listing>
		 *
		 * <p>If the collection has a <code>filterFunction</code>, it will be
		 * removed, and it will not be restored.</p>
		 *
		 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#dispose() starling.display.DisplayObject.dispose()
		 * @see http://doc.starling-framework.org/core/starling/textures/Texture.html#dispose() starling.textures.Texture.dispose()
		 */
		function dispose(disposeItem:Function):void;
	}
}
