/*
Feathers
Copyright 2012-2018 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.data
{
	import feathers.core.IFeathersEventDispatcher;

	/**
	 * Dispatched when the underlying data source changes and the ui will
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
	 * <tr><td><code>data</code></td><td>The index path of the item that has
	 * been added. It is of type <code>Array</code> and contains objects of
	 * type <code>int</code>.</td></tr>
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
	 * <tr><td><code>data</code></td><td>The index path of the item that has
	 * been removed. It is of type <code>Array</code> and contains objects of
	 * type <code>int</code>.</td></tr>
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
	 * <tr><td><code>data</code></td><td>The index path of the item that has
	 * been replaced. It is of type <code>Array</code> and contains objects of
	 * type <code>int</code>.</td></tr>
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
	 * hierarchical collection.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>The index path of the item that has
	 * been updated. It is of type <code>Array</code> and contains objects of
	 * type <code>int</code>.</td></tr>
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
	 * hierarchical collection.
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
	 * An interface for hierarchical collections.
	 * 
	 * @productversion 3.3.0
	 */
	public interface IHierarchicalCollection extends IFeathersEventDispatcher
	{
		[Deprecated(message="Cast to appropriate IHierarchicalCollection implementation and set a more specific property. For example, if the dataProvider is an ArrayHierarchicalCollection, set the arrayData property.")]
		/**
		 * @private
		 */
		function get data():Object;

		[Deprecated(message="Cast to appropriate IHierarchicalCollection implementation and set a more specific property. For example, if the dataProvider is an ArrayHierarchicalCollection, set the arrayData property.")]
		/**
		 * @private
		 */
		function set data(value:Object):void;

		/**
		 * Determines if a node from the data source is a branch.
		 */
		function isBranch(node:Object):Boolean;

		/**
		 * The number of items at the specified location in the collection.
		 *
		 * <p>Calling <code>getLengthOfBranch()</code> instead is recommended
		 * because the <code>Vector.&lt;int&gt;</code> location may be reused to
		 * avoid excessive garbage collection from temporary objects created by
		 * <code>...rest</code> arguments.</p>
		 */
		function getLength(...rest:Array):int;

		/**
		 * The number of items at the specified location in the collection.
		 */
		function getLengthAtLocation(location:Vector.<int> = null):int;

		/**
		 * Call <code>updateItemAt()</code> to manually inform any component
		 * rendering the hierarchical collection that the properties of a
		 * single item in the collection have changed, and that any views
		 * associated with the item should be updated. The collection will
		 * dispatch the <code>CollectionEventType.UPDATE_ITEM</code> event.
		 *
		 * <p>Alternatively, the item can dispatch an event when one of its
		 * properties has changed, and  a custom item renderer can listen for
		 * that event and update itself automatically.</p>
		 *
		 * @see #updateAll()
		 */
		function updateItemAt(index:int, ...rest:Array):void;

		/**
		 * Call <code>updateAll()</code> to manually inform any component
		 * rendering the hierarchical collection that the properties of all, or
		 * many, of the collection's items have changed, and that any rendered
		 * views should be updated. The collection will dispatch the
		 * <code>CollectionEventType.UPDATE_ALL</code> event.
		 *
		 * <p>Alternatively, the item can dispatch an event when one of its
		 * properties has changed, and  a custom item renderer can listen for
		 * that event and update itself automatically.</p>
		 *
		 * @see #updateItemAt()
		 */
		function updateAll():void;

		/**
		 * Returns the item at the specified location in the collection.
		 *
		 * <p>Calling <code>getItemAtLocation()</code> instead is recommended
		 * because the <code>Vector.&lt;int&gt;</code> location may be reused to
		 * avoid excessive garbage collection from temporary objects created by
		 * <code>...rest</code> arguments.</p>
		 */
		function getItemAt(index:int, ...rest:Array):Object;

		/**
		 * Returns the item at the specified location in the collection.
		 */
		function getItemAtLocation(location:Vector.<int>):Object;

		/**
		 * Determines which location the item appears at within the collection. If
		 * the item isn't in the collection, returns an empty vector.
		 */
		function getItemLocation(item:Object, result:Vector.<int> = null):Vector.<int>;

		/**
		 * Adds an item to the collection, at the specified location.
		 *
		 * <p>Calling <code>addItemAtLocation()</code> instead is recommended
		 * because the <code>Vector.&lt;int&gt;</code> location may be reused to
		 * avoid excessive garbage collection from temporary objects created by
		 * <code>...rest</code> arguments.</p>
		 */
		function addItemAt(item:Object, index:int, ...rest:Array):void;

		/**
		 * Adds an item to the collection, at the specified location.
		 */
		function addItemAtLocation(item:Object, location:Vector.<int>):void;

		/**
		 * Removes the item at the specified location from the collection and
		 * returns it.
		 *
		 * <p>Calling <code>removeItemAtLocation()</code> instead is recommended
		 * because the <code>Vector.&lt;int&gt;</code> location may be reused to
		 * avoid excessive garbage collection from temporary objects created by
		 * <code>...rest</code> arguments.</p>
		 */
		function removeItemAt(index:int, ...rest:Array):Object;

		/**
		 * Removes the item at the specified location from the collection and
		 * returns it.
		 */
		function removeItemAtLocation(location:Vector.<int>):Object;

		/**
		 * Removes a specific item from the collection.
		 */
		function removeItem(item:Object):void;

		/**
		 * Removes all items from the collection.
		 */
		function removeAll():void;

		/**
		 * Replaces the item at the specified location with a new item.
		 *
		 * <p>Calling <code>setItemAtLocation()</code> instead is recommended
		 * because the <code>Vector.&lt;int&gt;</code> location may be reused to
		 * avoid excessive garbage collection from temporary objects created by
		 * <code>...rest</code> arguments.</p>
		 */
		function setItemAt(item:Object, index:int, ...rest:Array):void;

		/**
		 * Replaces the item at the specified location with a new item.
		 */
		function setItemAtLocation(item:Object, location:Vector.<int>):void;

		/**
		 * Calls a function for each group in the collection and another
		 * function for each item in a group, where each function handles any
		 * properties that require disposal on these objects. For example,
		 * display objects or textures may need to be disposed. You may pass in
		 * a value of <code>null</code> for either function if you don't have
		 * anything to dispose in one or the other.
		 *
		 * <p>The function to dispose a group is expected to have the following signature:</p>
		 * <pre>function( group:Object ):void</pre>
		 *
		 * <p>The function to dispose an item is expected to have the following signature:</p>
		 * <pre>function( item:Object ):void</pre>
		 *
		 * <p>In the following example, the items in the collection are disposed:</p>
		 *
		 * <listing version="3.0">
		 * collection.dispose( function( group:Object ):void
		 * {
		 *     var content:DisplayObject = DisplayObject(group.content);
		 *     content.dispose();
		 * },
		 * function( item:Object ):void
		 * {
		 *     var accessory:DisplayObject = DisplayObject(item.accessory);
		 *     accessory.dispose();
		 * },)</listing>
		 *
		 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#dispose() starling.display.DisplayObject.dispose()
		 * @see http://doc.starling-framework.org/core/starling/textures/Texture.html#dispose() starling.textures.Texture.dispose()
		 */
		function dispose(disposeGroup:Function, disposeItem:Function):void;
	}
}
