/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

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
	 * @eventType starling.events.Event.CHANGE
	 */
	[Event(name="change",type="starling.events.Event")]

	/**
	 * Dispatched when the collection has changed drastically, such as when
	 * the underlying data source is replaced completely.
	 *
	 * @eventType feathers.events.CollectionEventType.RESET
	 */
	[Event(name="reset",type="starling.events.Event")]

	/**
	 * Dispatched when an item is added to the collection.
	 *
	 * <p>The <code>data</code> property of the event is the index path of the
	 * item that has been added. It is of type <code>Array</code> and contains
	 * objects of type <code>int</code>.</p>
	 *
	 * @eventType feathers.events.CollectionEventType.ADD_ITEM
	 */
	[Event(name="addItem",type="starling.events.Event")]

	/**
	 * Dispatched when an item is removed from the collection.
	 *
	 * <p>The <code>data</code> property of the event is the index path of the
	 * item that has been removed. It is of type <code>Array</code> and contains
	 * objects of type <code>int</code>.</p>
	 *
	 * @eventType feathers.events.CollectionEventType.REMOVE_ITEM
	 */
	[Event(name="removeItem",type="starling.events.Event")]

	/**
	 * Dispatched when an item is replaced in the collection.
	 *
	 * <p>The <code>data</code> property of the event is the index path of the
	 * item that has been replaced. It is of type <code>Array</code> and contains
	 * objects of type <code>int</code>.</p>
	 *
	 * @eventType feathers.events.CollectionEventType.REPLACE_ITEM
	 */
	[Event(name="replaceItem",type="starling.events.Event")]

	/**
	 * Dispatched when a property of an item in the collection has changed
	 * and the item doesn't have its own change event or signal. This event
	 * is only dispatched when the <code>updateItemAt()</code> function is
	 * called on the <code>HierarchicalCollection</code>.
	 *
	 * <p>In general, it's better for the items themselves to dispatch events
	 * or signals when their properties change.</p>
	 *
	 * <p>The <code>data</code> property of the event is the index path of the
	 * item that has been updated. It is of type <code>Array</code> and contains
	 * objects of type <code>int</code>.</p>
	 *
	 * @eventType feathers.events.CollectionEventType.UPDATE_ITEM
	 */
	[Event(name="updateItem",type="starling.events.Event")]

	[DefaultProperty("data")]
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
		 * If an item doesn't dispatch an event or signal to indicate that it
		 * has changed, you can manually tell the collection about the change,
		 * and the collection will dispatch the <code>CollectionEventType.UPDATE_ITEM</code>
		 * event to manually notify the component that renders the data.
		 */
		public function updateItemAt(index:int, ...rest:Array):void
		{
			rest.unshift(index);
			this.dispatchEventWith(CollectionEventType.UPDATE_ITEM, false, rest);
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
			const item:Object = this._dataDescriptor.removeItemAt.apply(null, rest);
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
			const location:Vector.<int> = this.getItemLocation(item);
			if(location)
			{
				//this is hacky. a future version probably won't use rest args.
				const locationAsArray:Array = [];
				const indexCount:int = location.length;
				for(var i:int = 0; i < indexCount; i++)
				{
					locationAsArray.push(location[i]);
				}
				this.removeItemAt.apply(this, locationAsArray);
			}
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
	}
}
