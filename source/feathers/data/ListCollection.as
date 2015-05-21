/*
Feathers
Copyright 2012-2015 Joshua Tynjala. All Rights Reserved.

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
	 * Dispatched when a property of an item in the collection has changed
	 * and the item doesn't have its own change event or signal. This event
	 * is only dispatched when the <code>updateItemAt()</code> function is
	 * called on the <code>ListCollection</code>.
	 *
	 * <p>In general, it's better for the items themselves to dispatch events
	 * or signals when their properties change.</p>
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
	 * @eventType feathers.events.CollectionEventType.UPDATE_ITEM
	 */
	[Event(name="updateItem",type="starling.events.Event")]

	/**
	 * Wraps a data source with a common API for use with UI controls, like
	 * lists, that support one dimensional collections of data. Supports custom
	 * "data descriptors" so that unexpected data sources may be used. Supports
	 * Arrays, Vectors, and XMLLists automatically.
	 * 
	 * @see ArrayListCollectionDataDescriptor
	 * @see VectorListCollectionDataDescriptor
	 * @see XMLListListCollectionDataDescriptor
	 */
	public class ListCollection extends EventDispatcher
	{
		/**
		 * Constructor
		 */
		public function ListCollection(data:Object = null)
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
		 * <code>ListCollection</code>.
		 * 
		 * <p>Data sources of type Array, Vector, and XMLList are automatically
		 * detected, and no <code>dataDescriptor</code> needs to be set if the
		 * <code>ListCollection</code> uses one of these types.</p>
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
			//we'll automatically detect an array, vector, or xmllist for convenience
			if(this._data is Array && !(this._dataDescriptor is ArrayListCollectionDataDescriptor))
			{
				this._dataDescriptor = new ArrayListCollectionDataDescriptor();
			}
			else if(this._data is Vector.<Number> && !(this._dataDescriptor is VectorNumberListCollectionDataDescriptor))
			{
				this._dataDescriptor = new VectorNumberListCollectionDataDescriptor();
			}
			else if(this._data is Vector.<int> && !(this._dataDescriptor is VectorIntListCollectionDataDescriptor))
			{
				this._dataDescriptor = new VectorIntListCollectionDataDescriptor();
			}
			else if(this._data is Vector.<uint> && !(this._dataDescriptor is VectorUintListCollectionDataDescriptor))
			{
				this._dataDescriptor = new VectorUintListCollectionDataDescriptor();
			}
			else if(this._data is Vector.<*> && !(this._dataDescriptor is VectorListCollectionDataDescriptor))
			{
				this._dataDescriptor = new VectorListCollectionDataDescriptor();
			}
			else if(this._data is XMLList && !(this._dataDescriptor is XMLListListCollectionDataDescriptor))
			{
				this._dataDescriptor = new XMLListListCollectionDataDescriptor();
			}
			if(this._data === null)
			{
				this._dataDescriptor = null;
			}
			this.dispatchEventWith(CollectionEventType.RESET);
			this.dispatchEventWith(Event.CHANGE);
		}
		
		/**
		 * @private
		 */
		protected var _dataDescriptor:IListCollectionDataDescriptor;

		/**
		 * Describes the underlying data source by translating APIs.
		 * 
		 * @see IListCollectionDataDescriptor
		 */
		public function get dataDescriptor():IListCollectionDataDescriptor
		{
			return this._dataDescriptor;
		}
		
		/**
		 * @private
		 */
		public function set dataDescriptor(value:IListCollectionDataDescriptor):void
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
		 * The number of items in the collection.
		 */
		public function get length():int
		{
			if(!this._dataDescriptor)
			{
				return 0;
			}
			return this._dataDescriptor.getLength(this._data);
		}

		/**
		 * If an item doesn't dispatch an event or signal to indicate that it
		 * has changed, you can manually tell the collection about the change,
		 * and the collection will dispatch the <code>CollectionEventType.UPDATE_ITEM</code>
		 * event to manually notify the component that renders the data.
		 */
		public function updateItemAt(index:int):void
		{
			this.dispatchEventWith(CollectionEventType.UPDATE_ITEM, false, index);
		}

		[Bindable(event="change")]
		/**
		 * Returns the item at the specified index in the collection.
		 */
		public function getItemAt(index:int):Object
		{
			return this._dataDescriptor.getItemAt(this._data, index);
		}

		[Bindable(event="change")]
		/**
		 * Determines which index the item appears at within the collection. If
		 * the item isn't in the collection, returns <code>-1</code>.
		 */
		public function getItemIndex(item:Object):int
		{
			return this._dataDescriptor.getItemIndex(this._data, item);
		}
		
		/**
		 * Adds an item to the collection, at the specified index.
		 */
		public function addItemAt(item:Object, index:int):void
		{
			this._dataDescriptor.addItemAt(this._data, item, index);
			this.dispatchEventWith(Event.CHANGE);
			this.dispatchEventWith(CollectionEventType.ADD_ITEM, false, index);
		}
		
		/**
		 * Removes the item at the specified index from the collection and
		 * returns it.
		 */
		public function removeItemAt(index:int):Object
		{
			var item:Object = this._dataDescriptor.removeItemAt(this._data, index);
			this.dispatchEventWith(Event.CHANGE);
			this.dispatchEventWith(CollectionEventType.REMOVE_ITEM, false, index);
			return item;
		}
		
		/**
		 * Removes a specific item from the collection.
		 */
		public function removeItem(item:Object):void
		{
			var index:int = this.getItemIndex(item);
			if(index >= 0)
			{
				this.removeItemAt(index);
			}
		}

		/**
		 * Removes all items from the collection.
		 */
		public function removeAll():void
		{
			if(this.length == 0)
			{
				return;
			}
			this._dataDescriptor.removeAll(this._data);
			this.dispatchEventWith(Event.CHANGE);
			this.dispatchEventWith(CollectionEventType.RESET, false);
		}
		
		/**
		 * Replaces the item at the specified index with a new item.
		 */
		public function setItemAt(item:Object, index:int):void
		{
			this._dataDescriptor.setItemAt(this._data, item, index);
			this.dispatchEventWith(Event.CHANGE);
			this.dispatchEventWith(CollectionEventType.REPLACE_ITEM, false, index);
		}

		/**
		 * Adds an item to the end of the collection.
		 */
		public function addItem(item:Object):void
		{
			this.addItemAt(item, this.length);
		}

		/**
		 * Adds an item to the end of the collection.
		 */
		public function push(item:Object):void
		{
			this.addItemAt(item, this.length);
		}

		/**
		 * Adds all items from another collection.
		 */
		public function addAll(collection:ListCollection):void
		{
			var otherCollectionLength:int = collection.length;
			for(var i:int = 0; i < otherCollectionLength; i++)
			{
				var item:Object = collection.getItemAt(i);
				this.addItem(item);
			}
		}

		/**
		 * Adds all items from another collection, placing the items at a
		 * specific index in this collection.
		 */
		public function addAllAt(collection:ListCollection, index:int):void
		{
			var otherCollectionLength:int = collection.length;
			var currentIndex:int = index;
			for(var i:int = 0; i < otherCollectionLength; i++)
			{
				var item:Object = collection.getItemAt(i);
				this.addItemAt(item, currentIndex);
				currentIndex++;
			}
		}
		
		/**
		 * Removes the item from the end of the collection and returns it.
		 */
		public function pop():Object
		{
			return this.removeItemAt(this.length - 1);
		}
		
		/**
		 * Adds an item to the beginning of the collection.
		 */
		public function unshift(item:Object):void
		{
			this.addItemAt(item, 0);
		}
		
		/**
		 * Removed the item from the beginning of the collection and returns it. 
		 */
		public function shift():Object
		{
			return this.removeItemAt(0);
		}

		[Bindable(event="change")]
		/**
		 * Determines if the specified item is in the collection.
		 */
		public function contains(item:Object):Boolean
		{
			return this.getItemIndex(item) >= 0;
		}

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
		 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#dispose() starling.display.DisplayObject.dispose()
		 * @see http://doc.starling-framework.org/core/starling/textures/Texture.html#dispose() starling.textures.Texture.dispose()
		 */
		public function dispose(disposeItem:Function):void
		{
			var itemCount:int = this.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:Object = this.getItemAt(i);
				disposeItem(item);
			}
		}
	}
}