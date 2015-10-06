/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.data
{
	import feathers.events.CollectionEventType;

	import starling.events.Event;
	import starling.events.EventDispatcher;

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
	 * been re[;aced. It is of type <code>Array</code> and contains objects of
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
	 * <code>HierarchicalCollection</code>.
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
	 * <code>HierarchicalCollection</code>.
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
	 * Wraps a two-dimensional data source with a common API for use with UI
	 * controls that support this type of data.
	 */
	public class HierarchicalCollection extends EventDispatcher
	{
		public function HierarchicalCollection(data:Object = null)
		{
			if(!data)
			{
				//default to an array if no data is provided
				data = [];
			}
			this.data = data;
		}

		/**
		 * @private
		 */
		protected var _data:Object;

		/**
		 * The data source for this collection. May be any type of data, but a
		 * <code>dataDescriptor</code> needs to be provided to translate from
		 * the data source's APIs to something that can be understood by
		 * <code>HierarchicalCollection</code>.
		 */
		public function get data():Object
		{
			return _data;
		}

		/**
		 * @private
		 */
		public function set data(value:Object):void
		{
			if(this._data == value)
			{
				return;
			}
			this._data = value;
			this.dispatchEventWith(CollectionEventType.RESET);
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _dataDescriptor:IHierarchicalCollectionDataDescriptor = new ArrayChildrenHierarchicalCollectionDataDescriptor();

		/**
		 * Describes the underlying data source by translating APIs.
		 */
		public function get dataDescriptor():IHierarchicalCollectionDataDescriptor
		{
			return this._dataDescriptor;
		}

		/**
		 * @private
		 */
		public function set dataDescriptor(value:IHierarchicalCollectionDataDescriptor):void
		{
			if(this._dataDescriptor == value)
			{
				return;
			}
			this._dataDescriptor = value;
			this.dispatchEventWith(CollectionEventType.RESET);
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * Determines if a node from the data source is a branch.
		 */
		public function isBranch(node:Object):Boolean
		{
			return this._dataDescriptor.isBranch(node);
		}

		/**
		 * The number of items at the specified location in the collection.
		 */
		public function getLength(...rest:Array):int
		{
			rest.unshift(this._data);
			return this._dataDescriptor.getLength.apply(null, rest);
		}

		/**
		 * Call <code>updateItemAt()</code> to manually inform any component
		 * rendering the <code>HierarchicalCollection</code> that the properties
		 * of a single item in the collection have changed, and that any views
		 * associated with the item should be updated. The collection will
		 * dispatch the <code>CollectionEventType.UPDATE_ITEM</code> event.
		 * 
		 * <p>Alternatively, the item can dispatch an event when one of its
		 * properties has changed, and item renderers can listen for that event
		 * and update themselves automatically.</p>
		 * 
		 * @see #updateAll()
		 */
		public function updateItemAt(index:int, ...rest:Array):void
		{
			rest.unshift(index);
			this.dispatchEventWith(CollectionEventType.UPDATE_ITEM, false, rest);
		}

		/**
		 * Call <code>updateAll()</code> to manually inform any component
		 * rendering the <code>HierarchicalCollection</code> that the properties
		 * of all, or many, of the collection's items have changed, and that any
		 * rendered views should be updated. The collection will dispatch the
		 * <code>CollectionEventType.UPDATE_ALL</code> event.
		 *
		 * <p>Alternatively, the item can dispatch an event when one of its
		 * properties has changed, and item renderers can listen for that event
		 * and update themselves automatically.</p>
		 *
		 * @see #updateItemAt()
		 */
		public function updateAll():void
		{
			this.dispatchEventWith(CollectionEventType.UPDATE_ALL);
		}

		/**
		 * Returns the item at the specified location in the collection.
		 */
		public function getItemAt(index:int, ...rest:Array):Object
		{
			rest.unshift(index);
			rest.unshift(this._data);
			return this._dataDescriptor.getItemAt.apply(null, rest);
		}

		/**
		 * Determines which location the item appears at within the collection. If
		 * the item isn't in the collection, returns <code>null</code>.
		 */
		public function getItemLocation(item:Object, result:Vector.<int> = null):Vector.<int>
		{
			return this._dataDescriptor.getItemLocation(this._data, item, result);
		}

		/**
		 * Adds an item to the collection, at the specified location.
		 */
		public function addItemAt(item:Object, index:int, ...rest:Array):void
		{
			rest.unshift(index);
			rest.unshift(item);
			rest.unshift(this._data);
			this._dataDescriptor.addItemAt.apply(null, rest);
			this.dispatchEventWith(Event.CHANGE);
			rest.shift();
			rest.shift();
			this.dispatchEventWith(CollectionEventType.ADD_ITEM, false, rest);
		}

		/**
		 * Removes the item at the specified location from the collection and
		 * returns it.
		 */
		public function removeItemAt(index:int, ...rest:Array):Object
		{
			rest.unshift(index);
			rest.unshift(this._data);
			var item:Object = this._dataDescriptor.removeItemAt.apply(null, rest);
			this.dispatchEventWith(Event.CHANGE);
			rest.shift();
			this.dispatchEventWith(CollectionEventType.REMOVE_ITEM, false, rest);
			return item;
		}

		/**
		 * Removes a specific item from the collection.
		 */
		public function removeItem(item:Object):void
		{
			var location:Vector.<int> = this.getItemLocation(item);
			if(location)
			{
				//this is hacky. a future version probably won't use rest args.
				var locationAsArray:Array = [];
				var indexCount:int = location.length;
				for(var i:int = 0; i < indexCount; i++)
				{
					locationAsArray.push(location[i]);
				}
				this.removeItemAt.apply(this, locationAsArray);
			}
		}

		/**
		 * Removes all items from the collection.
		 */
		public function removeAll():void
		{
			if(this.getLength() == 0)
			{
				return;
			}
			this._dataDescriptor.removeAll(this._data);
			this.dispatchEventWith(Event.CHANGE);
			this.dispatchEventWith(CollectionEventType.RESET, false);
		}

		/**
		 * Replaces the item at the specified location with a new item.
		 */
		public function setItemAt(item:Object, index:int, ...rest:Array):void
		{
			rest.unshift(index);
			rest.unshift(item);
			rest.unshift(this._data);
			this._dataDescriptor.setItemAt.apply(null, rest);
			rest.shift();
			rest.shift();
			this.dispatchEventWith(CollectionEventType.REPLACE_ITEM, false, rest);
			this.dispatchEventWith(Event.CHANGE);
		}

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
		public function dispose(disposeGroup:Function, disposeItem:Function):void
		{
			var groupCount:int = this.getLength();
			var path:Array = [];
			for(var i:int = 0; i < groupCount; i++)
			{
				var group:Object = this.getItemAt(i);
				path[0] = i;
				this.disposeGroupInternal(group, path, disposeGroup, disposeItem);
				path.length = 0;
			}
		}

		/**
		 * @private
		 */
		protected function disposeGroupInternal(group:Object, path:Array, disposeGroup:Function, disposeItem:Function):void
		{
			if(disposeGroup != null)
			{
				disposeGroup(group);
			}

			var itemCount:int = this.getLength.apply(this, path);
			for(var i:int = 0; i < itemCount; i++)
			{
				path[path.length] = i;
				var item:Object = this.getItemAt.apply(this, path);
				if(this.isBranch(item))
				{
					this.disposeGroupInternal(item, path, disposeGroup, disposeItem);
				}
				else if(disposeItem != null)
				{
					disposeItem(item);
				}
				path.length--;
			}
		}
	}
}
