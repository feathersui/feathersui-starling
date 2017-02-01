/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

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
	 * Dispatched when the <code>updateItemAt()</code> function is called on the
	 * <code>ListCollection</code>.
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
	 * <code>ListCollection</code>.
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
	 * Wraps a data source with a common API for use with UI controls, like
	 * lists, that support one dimensional collections of data. Supports custom
	 * "data descriptors" so that unexpected data sources may be used. Supports
	 * Arrays, Vectors, and XMLLists automatically.
	 * 
	 * @see ArrayListCollectionDataDescriptor
	 * @see VectorListCollectionDataDescriptor
	 * @see XMLListListCollectionDataDescriptor
	 *
	 * @productversion Feathers 1.0.0
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
		protected var _localDataDescriptor:ArrayListCollectionDataDescriptor;

		/**
		 * @private
		 */
		protected var _localData:Array;

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
		 * @private
		 */
		protected var _pendingRefresh:Boolean = false;

		/**
		 * @private
		 */
		protected var _filterFunction:Function;

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
		 * var collection:ListCollection = new ListCollection( data );
		 * 
		 * var list:List = new List();
		 * list.dataProvider = collection;
		 * this.addChild( list);
		 * 
		 * var input:TextInput = new TextInput();
		 * input.addEventListener( Event.CHANGE, function():void
		 * {
		 *    if( input.text.length === 0 )
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
		public function get filterFunction():Function
		{
			return this._filterFunction;
		}

		/**
		 * @private
		 */
		public function set filterFunction(value:Function):void
		{
			if(this._filterFunction === value)
			{
				return;
			}
			this._filterFunction = value;
			this._pendingRefresh = true;
			this.dispatchEventWith(Event.CHANGE);
			this.dispatchEventWith(CollectionEventType.FILTER_CHANGE);
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
			if(this._pendingRefresh)
			{
				this.refresh();
			}
			if(this._localData !== null)
			{
				return this._localDataDescriptor.getLength(this._localData);
			}
			return this._dataDescriptor.getLength(this._data);
		}

		/**
		 * @private
		 */
		protected function refresh():void
		{
			this._pendingRefresh = false;
			if(this._filterFunction !== null)
			{
				var result:Array = this._localData;
				if(result !== null)
				{
					//reuse the old array to avoid garbage collection
					result.length = 0;
				}
				else
				{
					result = [];
				}
				var count:int = this._dataDescriptor.getLength(this._data);
				var pushIndex:int = 0;
				for(var i:int = 0; i < count; i++)
				{
					var item:Object = this._dataDescriptor.getItemAt(this._data, i);
					if(this._filterFunction(item))
					{
						result[pushIndex] = item;
						pushIndex++;
					}
				}
				this._localData = result;
				this._localDataDescriptor = new ArrayListCollectionDataDescriptor();
			}
			else
			{
				this._localData = null;
				this._localDataDescriptor = null;
			}
		}

		/**
		 * Call <code>updateItemAt()</code> to manually inform any component
		 * rendering the <code>ListCollection</code> that the properties of a
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
		public function updateItemAt(index:int):void
		{
			this.dispatchEventWith(CollectionEventType.UPDATE_ITEM, false, index);
		}

		/**
		 * Call <code>updateAll()</code> to manually inform any component
		 * rendering the <code>ListCollection</code> that the properties of all,
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
		public function updateAll():void
		{
			this.dispatchEventWith(CollectionEventType.UPDATE_ALL);
		}

		/**
		 * Returns the item at the specified index in the collection.
		 */
		public function getItemAt(index:int):Object
		{
			if(this._pendingRefresh)
			{
				this.refresh();
			}
			if(this._localData !== null)
			{
				return this._localDataDescriptor.getItemAt(this._localData, index);
			}
			return this._dataDescriptor.getItemAt(this._data, index);
		}

		/**
		 * Determines which index the item appears at within the collection. If
		 * the item isn't in the collection, returns <code>-1</code>.
		 * 
		 * <p>If the collection is filtered, <code>getItemIndex()</code> will
		 * return <code>-1</code> for items that are excluded by the filter.</p>
		 */
		public function getItemIndex(item:Object):int
		{
			if(this._pendingRefresh)
			{
				this.refresh();
			}
			if(this._localData !== null)
			{
				return this._localDataDescriptor.getItemIndex(this._localData, item);
			}
			return this._dataDescriptor.getItemIndex(this._data, item);
		}

		/**
		 * Adds an item to the collection, at the specified index.
		 *
		 * <p>If the collection is filtered, the index is the position in the
		 * filtered data, rather than position in the unfiltered data.</p>
		 */
		public function addItemAt(item:Object, index:int):void
		{
			if(this._pendingRefresh)
			{
				this.refresh();
			}
			if(this._localData !== null)
			{
				if(index < this._localDataDescriptor.getLength(this._localData))
				{
					//find the item at the index in the filtered data, and use
					//its index from the unfiltered data
					var oldItem:Object = this._localDataDescriptor.getItemAt(this._localData, index);
					var unfilteredIndex:int = this._dataDescriptor.getItemIndex(this._data, oldItem);
				}
				else
				{
					//if the item is added at the end of the filtered data
					//then add it at the end of the unfiltered data
					unfilteredIndex = this._dataDescriptor.getLength(this._data);
				}
				//always add to the original data
				this._dataDescriptor.addItemAt(this._data, item, unfilteredIndex);
				//but check if the item should be in the filtered data
				var includeItem:Boolean = true;
				if(this._filterFunction !== null)
				{
					includeItem = this._filterFunction(item);
				}
				if(includeItem)
				{
					this._localDataDescriptor.addItemAt(this._localData, item, index);
					//don't dispatch these events if the item is filtered!
					this.dispatchEventWith(Event.CHANGE);
					this.dispatchEventWith(CollectionEventType.ADD_ITEM, false, index);
				}
			}
			else
			{
				this._dataDescriptor.addItemAt(this._data, item, index);
				this.dispatchEventWith(Event.CHANGE);
				this.dispatchEventWith(CollectionEventType.ADD_ITEM, false, index);
			}
		}

		/**
		 * Removes the item at the specified index from the collection and
		 * returns it.
		 * 
		 * <p>If the collection is filtered, the index is the position in the
		 * filtered data, rather than position in the unfiltered data.</p>
		 */
		public function removeItemAt(index:int):Object
		{
			if(this._pendingRefresh)
			{
				this.refresh();
			}
			if(this._localData !== null)
			{
				var item:Object = this._localDataDescriptor.removeItemAt(this._localData, index);
				var unfilteredIndex:int = this._dataDescriptor.getItemIndex(this._data, item);
				this._dataDescriptor.removeItemAt(this._data, unfilteredIndex);
			}
			else
			{
				item = this._dataDescriptor.removeItemAt(this._data, index);
			}
			this.dispatchEventWith(Event.CHANGE);
			this.dispatchEventWith(CollectionEventType.REMOVE_ITEM, false, index);
			return item;
		}

		/**
		 * Removes a specific item from the collection.
		 *
		 * <p>If the collection is filtered, <code>removeItem()</code> will not
		 * remove the item from the unfiltered data if it is not included in the
		 * filtered data. If the item is not removed,
		 * <code>CollectionEventType.REMOVE_ITEM</code> will not be dispatched.</p>
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
			if(this._pendingRefresh)
			{
				this.refresh();
			}
			if(this.length === 0)
			{
				return;
			}
			if(this._localData !== null)
			{
				this._localDataDescriptor.removeAll(this._localData);
			}
			else
			{
				this._dataDescriptor.removeAll(this._data);
			}
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * Replaces the item at the specified index with a new item.
		 */
		public function setItemAt(item:Object, index:int):void
		{
			if(this._pendingRefresh)
			{
				this.refresh();
			}
			if(this._localData !== null)
			{
				var oldItem:Object = this._localDataDescriptor.getItemAt(this._localData, index);
				var unfilteredIndex:int = this._dataDescriptor.getItemIndex(this._data, oldItem);
				this._dataDescriptor.setItemAt(this._data, item, unfilteredIndex);
				if(this._filterFunction !== null)
				{
					var includeItem:Boolean = this._filterFunction(item);
					if(includeItem)
					{
						this._localDataDescriptor.setItemAt(this._localData, item, index);
						this.dispatchEventWith(Event.CHANGE);
						this.dispatchEventWith(CollectionEventType.REPLACE_ITEM, false, index);
						return;
					}
					else
					{
						//if the item is excluded, the item at this index is
						//removed instead of being replaced by the new item
						this._localDataDescriptor.removeItemAt(this._localData, index);
						this.dispatchEventWith(Event.CHANGE);
						this.dispatchEventWith(CollectionEventType.REMOVE_ITEM, false, index);
					}
				}
			}
			else
			{
				this._dataDescriptor.setItemAt(this._data, item, index);
				this.dispatchEventWith(Event.CHANGE);
				this.dispatchEventWith(CollectionEventType.REPLACE_ITEM, false, index);
			}
		}

		/**
		 * Adds an item to the end of the collection.
		 *
		 * <p>If the collection is filtered, <code>addItem()</code> may add
		 * the item to the unfiltered data, but omit it from the filtered data.
		 * If the item is omitted from the filtered data,
		 * <code>CollectionEventType.ADD_ITEM</code> will not be dispatched.</p>
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

		/**
		 * Determines if the specified item is in the collection.
		 *
		 * <p>If the collection is filtered, <code>contains()</code> will return
		 * <code>false</code> for items that are excluded by the filter.</p>
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
		 * <p>If the collection has a <code>filterFunction</code>, it will be
		 * removed, and it will not be restored.</p>
		 *
		 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#dispose() starling.display.DisplayObject.dispose()
		 * @see http://doc.starling-framework.org/core/starling/textures/Texture.html#dispose() starling.textures.Texture.dispose()
		 */
		public function dispose(disposeItem:Function):void
		{
			//if we're disposing the collection, filters don't matter anymore,
			//and we should ensure that all items are disposed.
			this._filterFunction = null;
			this.refresh();

			var itemCount:int = this.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:Object = this.getItemAt(i);
				disposeItem(item);
			}
		}
	}
}