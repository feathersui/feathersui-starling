/*
Feathers
Copyright 2012-2019 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.data
{
	import feathers.events.CollectionEventType;

	import starling.events.Event;
	import starling.events.EventDispatcher;

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
	
	[DefaultProperty("data")]
	/**
	 * Wraps a two-dimensional data source with a common API for use with UI
	 * controls that support this type of data.
	 *
	 * @productversion Feathers 1.0.0
	 */
	public class HierarchicalCollection extends EventDispatcher implements IHierarchicalCollection
	{
		/**
		 * Constructor.
		 */
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
		 * hierarchical collection.
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

		[Bindable(event="change")]
		/**
		 * @copy feathers.data.IHierarchicalCollection#isBranch()
		 */
		public function isBranch(node:Object):Boolean
		{
			return this._dataDescriptor.isBranch(node);
		}

		[Bindable(event="change")]
		/**
		 * @copy feathers.data.IHierarchicalCollection#getLength()
		 *
		 * @see #getLengthAtLocation()
		 */
		public function getLength(...rest:Array):int
		{
			rest.insertAt(0, this._data);
			return this._dataDescriptor.getLength.apply(null, rest);
		}

		/**
		 * @copy feathers.data.IHierarchicalCollection#getLengthAtLocation()
		 */
		public function getLengthAtLocation(location:Vector.<int> = null):int
		{
			return this._dataDescriptor.getLengthAtLocation(this._data, location);
		}

		/**
		 * @copy feathers.data.IHierarchicalCollection#updateItemAt()
		 * 
		 * @see #updateAll()
		 */
		public function updateItemAt(index:int, ...rest:Array):void
		{
			rest.insertAt(0, index);
			this.dispatchEventWith(CollectionEventType.UPDATE_ITEM, false, rest);
		}

		[Bindable(event="change")]
		/**
		 * @copy feathers.data.IHierarchicalCollection#updateAll()
		 *
		 * @see #updateItemAt()
		 */
		public function updateAll():void
		{
			this.dispatchEventWith(CollectionEventType.UPDATE_ALL);
		}

		[Bindable(event="change")]
		/**
		 * @copy feathers.data.IHierarchicalCollection#getItemAt()
		 *
		 * @see #getItemAtLocation()
		 */
		public function getItemAt(index:int, ...rest:Array):Object
		{
			rest.insertAt(0, index);
			rest.insertAt(0, this._data);
			return this._dataDescriptor.getItemAt.apply(null, rest);
		}

		[Bindable(event="change")]
		/**
		 * @copy feathers.data.IHierarchicalCollection#getItemAtLocation()
		 */
		public function getItemAtLocation(location:Vector.<int>):Object
		{
			return this._dataDescriptor.getItemAtLocation(this._data, location);
		}

		/**
		 * @copy feathers.data.IHierarchicalCollection#getItemLocation()
		 */
		public function getItemLocation(item:Object, result:Vector.<int> = null):Vector.<int>
		{
			return this._dataDescriptor.getItemLocation(this._data, item, result);
		}

		/**
		 * @copy feathers.data.IHierarchicalCollection#addItemAt()
		 *
		 * @see #addItemAtLocation()
		 */
		public function addItemAt(item:Object, index:int, ...rest:Array):void
		{
			rest.insertAt(0, index);
			rest.insertAt(0, item);
			rest.insertAt(0, this._data);
			this._dataDescriptor.addItemAt.apply(null, rest);
			this.dispatchEventWith(Event.CHANGE);
			rest.shift();
			rest.shift();
			this.dispatchEventWith(CollectionEventType.ADD_ITEM, false, rest);
		}

		/**
		 * @copy feathers.data.IHierarchicalCollection#addItemAtLocation()
		 *
		 * @throws RangeError Branch not found at specified location
		 */
		public function addItemAtLocation(item:Object, location:Vector.<int>):void
		{
			this._dataDescriptor.addItemAtLocation(this._data, item, location);
			this.dispatchEventWith(Event.CHANGE);
			var result:Array = [];
			var locationCount:int = location.length;
			for(var i:int = 0; i < locationCount; i++)
			{
				result[i] = location[i];
			}
			this.dispatchEventWith(CollectionEventType.ADD_ITEM, false, result);
		}

		/**
		 * @copy feathers.data.IHierarchicalCollection#removeItemAt()
		 * 
		 * @see #removeItemAtLocation()
		 */
		public function removeItemAt(index:int, ...rest:Array):Object
		{
			rest.insertAt(0, index);
			rest.insertAt(0, this._data);
			var item:Object = this._dataDescriptor.removeItemAt.apply(null, rest);
			this.dispatchEventWith(Event.CHANGE);
			rest.shift();
			this.dispatchEventWith(CollectionEventType.REMOVE_ITEM, false, rest);
			return item;
		}

		/**
		 * @copy feathers.data.IHierarchicalCollection#removeItemAtLocation()
		 *
		 * @throws RangeError Branch not found at specified location
		 */
		public function removeItemAtLocation(location:Vector.<int>):Object
		{
			var item:Object = this._dataDescriptor.removeItemAtLocation(this._data, location);
			var result:Array = [];
			var locationCount:int = location.length;
			for(var i:int = 0; i < locationCount; i++)
			{
				result[i] = location[i];
			}
			this.dispatchEventWith(Event.CHANGE);
			this.dispatchEventWith(CollectionEventType.REMOVE_ITEM, false, result);
			return item;
		}

		/**
		 * @copy feathers.data.IHierarchicalCollection#removeItem()
		 */
		public function removeItem(item:Object):void
		{
			var location:Vector.<int> = this.getItemLocation(item);
			if(location !== null)
			{
				this.removeItemAtLocation(location);
			}
		}

		/**
		 * @copy feathers.data.IHierarchicalCollection#removeAll()
		 */
		public function removeAll():void
		{
			if(this.getLength() == 0)
			{
				return;
			}
			this._dataDescriptor.removeAll(this._data);
			this.dispatchEventWith(CollectionEventType.REMOVE_ALL);
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @copy feathers.data.IHierarchicalCollection#setItemAt()
		 *
		 * @see #setItemAtLocation()
		 */
		public function setItemAt(item:Object, index:int, ...rest:Array):void
		{
			rest.insertAt(0, index);
			rest.insertAt(0, item);
			rest.insertAt(0, this._data);
			this._dataDescriptor.setItemAt.apply(null, rest);
			rest.shift();
			rest.shift();
			this.dispatchEventWith(CollectionEventType.REPLACE_ITEM, false, rest);
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @copy feathers.data.IHierarchicalCollection#setItemAtLocation()
		 *
		 * @throws RangeError Branch not found at specified location
		 */
		public function setItemAtLocation(item:Object, location:Vector.<int>):void
		{
			this._dataDescriptor.setItemAtLocation(data, item, location);
			this.dispatchEventWith(Event.CHANGE);
			var result:Array = [];
			var locationCount:int = location.length;
			for(var i:int = 0; i < locationCount; i++)
			{
				result[i] = location[i];
			}
			this.dispatchEventWith(CollectionEventType.REPLACE_ITEM, false, result);
		}

		/**
		 * @copy feathers.data.IHierarchicalCollection#dispose()
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
