/*
Feathers
Copyright 2012-2021 Bowler Hat LLC. All Rights Reserved.

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

	[DefaultProperty("data")]
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
	 * Wraps a data source with a common API for use with UI controls, like
	 * lists, that support one dimensional collections of data. Supports custom
	 * "data descriptors" so that unexpected data sources may be used. Supports
	 * Arrays, Vectors, and XMLLists automatically.
	 *
	 * @productversion Feathers 1.0.0
	 */
	public class ListCollection extends EventDispatcher implements IListCollection
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

		[Bindable(event="change")]
		/**
		 * @private
		 */
		protected var _pendingRefresh:Boolean = false;

		/**
		 * @private
		 */
		protected var _filterFunction:Function = null;

		/**
		 * @copy feathers.data.IListCollection#filterFunction
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
		 * @private
		 */
		protected var _sortCompareFunction:Function = null;

		/**
		 * @copy feathers.data.IListCollection#sortCompareFunction
		 */
		public function get sortCompareFunction():Function
		{
			return this._sortCompareFunction;
		}

		/**
		 * @private
		 */
		public function set sortCompareFunction(value:Function):void
		{
			if(this._sortCompareFunction === value)
			{
				return;
			}
			this._sortCompareFunction = value;
			this._pendingRefresh = true;
			this.dispatchEventWith(Event.CHANGE);
			this.dispatchEventWith(CollectionEventType.SORT_CHANGE);
		}

		/**
		 * @copy feathers.data.IListCollection#length
		 */
		public function get length():int
		{
			if(!this._dataDescriptor)
			{
				return 0;
			}
			if(this._pendingRefresh)
			{
				this.refreshFilterAndSort();
			}
			if(this._localData !== null)
			{
				return this._localDataDescriptor.getLength(this._localData);
			}
			return this._dataDescriptor.getLength(this._data);
		}

		/**
		 * @copy feathers.data.IListCollection#refresh()
		 */
		public function refresh():void
		{
			if(this._filterFunction === null && this._sortCompareFunction === null)
			{
				return;
			}
			this._pendingRefresh = true;
			this.dispatchEventWith(Event.CHANGE);
			if(this._filterFunction !== null)
			{
				this.dispatchEventWith(CollectionEventType.FILTER_CHANGE);
			}
			if(this._sortCompareFunction !== null)
			{
				this.dispatchEventWith(CollectionEventType.SORT_CHANGE);
			}
		}

		/**
		 * @private
		 */
		protected function refreshFilterAndSort():void
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
			else if(this._sortCompareFunction !== null) //no filter
			{
				count = this._dataDescriptor.getLength(this._data);
				if(this._localData === null)
				{
					this._localData = new Array(count);
				}
				else
				{
					this._localData.length = count;
				}
				for(i = 0; i < count; i++)
				{
					this._localData[i] = this._dataDescriptor.getItemAt(this._data, i);
				}
				this._localDataDescriptor = new ArrayListCollectionDataDescriptor();
			}
			else //no filter or sort
			{
				this._localData = null;
				this._localDataDescriptor = null;
			}
			if(this._sortCompareFunction !== null)
			{
				this._localData.sort(this._sortCompareFunction);
			}
		}

		/**
		 * @copy feathers.data.IListCollection#updateItemAt()
		 *
		 * @see #updateAll()
		 */
		public function updateItemAt(index:int):void
		{
			this.dispatchEventWith(CollectionEventType.UPDATE_ITEM, false, index);
		}

		/**
		 * @copy feathers.data.IListCollection#updateAll()
		 *
		 * @see #updateItemAt()
		 */
		public function updateAll():void
		{
			this.dispatchEventWith(CollectionEventType.UPDATE_ALL);
		}

		[Bindable(event="change")]
		/**
		 * @copy feathers.data.IListCollection#getItemAt()
		 */
		public function getItemAt(index:int):Object
		{
			if(this._pendingRefresh)
			{
				this.refreshFilterAndSort();
			}
			if(this._localData !== null)
			{
				return this._localDataDescriptor.getItemAt(this._localData, index);
			}
			return this._dataDescriptor.getItemAt(this._data, index);
		}

		[Bindable(event="change")]
		/**
		 * @copy feathers.data.IListCollection#getItemIndex()
		 */
		public function getItemIndex(item:Object):int
		{
			if(this._pendingRefresh)
			{
				this.refreshFilterAndSort();
			}
			if(this._localData !== null)
			{
				return this._localDataDescriptor.getItemIndex(this._localData, item);
			}
			return this._dataDescriptor.getItemIndex(this._data, item);
		}

		/**
		 * @copy feathers.data.IListCollection#addItemAt()
		 */
		public function addItemAt(item:Object, index:int):void
		{
			if(this._pendingRefresh)
			{
				this.refreshFilterAndSort();
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
					var sortedIndex:int = index;
					if(this._sortCompareFunction !== null)
					{
						sortedIndex = this.getSortedInsertionIndex(item);
					}
					this._localDataDescriptor.addItemAt(this._localData, item, sortedIndex);
					//don't dispatch these events if the item is filtered!
					this.dispatchEventWith(Event.CHANGE);
					this.dispatchEventWith(CollectionEventType.ADD_ITEM, false, sortedIndex);
				}
			}
			else //no filter or sort
			{
				this._dataDescriptor.addItemAt(this._data, item, index);
				this.dispatchEventWith(Event.CHANGE);
				this.dispatchEventWith(CollectionEventType.ADD_ITEM, false, index);
			}
		}

		/**
		 * @copy feathers.data.IListCollection#removeItemAt()
		 */
		public function removeItemAt(index:int):Object
		{
			if(this._pendingRefresh)
			{
				this.refreshFilterAndSort();
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
		 * @copy feathers.data.IListCollection#removeItem()
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
		 * @copy feathers.data.IListCollection#removeAll()
		 */
		public function removeAll():void
		{
			if(this._pendingRefresh)
			{
				this.refreshFilterAndSort();
			}
			if(this.length == 0)
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
			this.dispatchEventWith(CollectionEventType.REMOVE_ALL);
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @copy feathers.data.IListCollection#setItemAt()
		 */
		public function setItemAt(item:Object, index:int):void
		{
			if(this._pendingRefresh)
			{
				this.refreshFilterAndSort();
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
				else if(this._sortCompareFunction !== null)
				{
					//remove the old item first!
					this._localDataDescriptor.removeItemAt(this._localData, index);
					//then try to figure out where the new item goes when inserted
					var sortedIndex:int = this.getSortedInsertionIndex(item);
					this._localDataDescriptor.setItemAt(this._localData, item, sortedIndex);
					this.dispatchEventWith(Event.CHANGE);
					this.dispatchEventWith(CollectionEventType.REPLACE_ITEM, false, index);
					return;
				}
			}
			else //no filter or sort
			{
				this._dataDescriptor.setItemAt(this._data, item, index);
				this.dispatchEventWith(Event.CHANGE);
				this.dispatchEventWith(CollectionEventType.REPLACE_ITEM, false, index);
			}
		}

		/**
		 * @copy feathers.data.IListCollection#addItem()
		 */
		public function addItem(item:Object):void
		{
			this.addItemAt(item, this.length);
		}

		/**
		 * @copy feathers.data.IListCollection#push()
		 *
		 * @see #addItem()
		 */
		public function push(item:Object):void
		{
			this.addItemAt(item, this.length);
		}

		/**
		 * @copy feathers.data.IListCollection#addAll()
		 */
		public function addAll(collection:IListCollection):void
		{
			var otherCollectionLength:int = collection.length;
			for(var i:int = 0; i < otherCollectionLength; i++)
			{
				var item:Object = collection.getItemAt(i);
				this.addItem(item);
			}
		}

		/**
		 * @copy feathers.data.IListCollection#addAllAt()
		 */
		public function addAllAt(collection:IListCollection, index:int):void
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
		 * @copy feathers.data.IListCollection#reset()
		 */
		public function reset(collection:IListCollection):void
		{
			this._dataDescriptor.removeAll(this._data);
			var otherCollectionLength:int = collection.length;
			for(var i:int = 0; i < otherCollectionLength; i++)
			{
				var item:Object = collection.getItemAt(i);
				this._dataDescriptor.addItemAt(this._data, item, i);
			}
			this.dispatchEventWith(CollectionEventType.RESET);
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @copy feathers.data.IListCollection#pop()
		 */
		public function pop():Object
		{
			return this.removeItemAt(this.length - 1);
		}

		/**
		 * @copy feathers.data.IListCollection#unshift()
		 */
		public function unshift(item:Object):void
		{
			this.addItemAt(item, 0);
		}

		/**
		 * @copy feathers.data.IListCollection#shift()
		 */
		public function shift():Object
		{
			return this.removeItemAt(0);
		}

		[Bindable(event="change")]
		/**
		 * @copy feathers.data.IListCollection#contains()
		 */
		public function contains(item:Object):Boolean
		{
			return this.getItemIndex(item) >= 0;
		}

		/**
		 * @copy feathers.data.IListCollection#dispose()
		 *
		 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#dispose() starling.display.DisplayObject.dispose()
		 * @see http://doc.starling-framework.org/core/starling/textures/Texture.html#dispose() starling.textures.Texture.dispose()
		 */
		public function dispose(disposeItem:Function):void
		{
			//if we're disposing the collection, filters don't matter anymore,
			//and we should ensure that all items are disposed.
			this._filterFunction = null;
			this.refreshFilterAndSort();

			var itemCount:int = this.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:Object = this.getItemAt(i);
				disposeItem(item);
			}
		}

		/**
		 * @private
		 */
		protected function getSortedInsertionIndex(item:Object):int
		{
			var itemCount:int = this._localDataDescriptor.getLength(this._localData);
			if(this._sortCompareFunction === null)
			{
				return itemCount;
			}
			for(var i:int = 0; i < itemCount; i++)
			{
				var otherItem:Object = this._localDataDescriptor.getItemAt(this._localData, i);
				var result:int = this._sortCompareFunction(item, otherItem);
				if(result < 1)
				{
					return i;
				}
			}
			return itemCount;
		}
	}
}