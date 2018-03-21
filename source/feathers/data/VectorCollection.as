/*
Feathers
Copyright 2012-2018 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.data
{
	import feathers.events.CollectionEventType;

	import starling.events.Event;
	import starling.events.EventDispatcher;

	[Exclude(name="data",kind="property")]

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
	 * Wraps a <code>Vector</code> in the common <code>IListCollection</code>
	 * API used by many Feathers UI controls, including <code>List</code> and
	 * <code>TabBar</code>.
	 *
	 * @productversion Feathers 3.3.0
	 */
	public class VectorCollection extends EventDispatcher implements IListCollection
	{
		/**
		 * Constructor
		 */
		public function VectorCollection(data:Object = null)
		{
			if(data === null)
			{
				data = new <*>[];
			}
			else if(!(data is Vector.<*>))
			{
				throw new ArgumentError("VectorCollection data must be of type Vector");
			}
			this._vectorData = data;
		}

		/**
		 * @private
		 */
		protected var _filterAndSortData:Object;

		/**
		 * @private
		 * Due to bugs in the older ASC1 compiler, we cannot type this variable
		 * as Vector.<*>. It will result in failures decoding abc bytecode.
		 */
		protected var _vectorData:Object;

		/**
		 * The <code>Vector</code> data source for this collection.
		 * 
		 * <p>Note: Ideally, this property would be typed as something other
		 * than <code>Object</code>, but there is no type that will accept all
		 * <code>Vector</code> objects without requiring a cast first.</p>
		 */
		public function get vectorData():Object
		{
			return this._vectorData;
		}

		/**
		 * @private
		 */
		public function set vectorData(value:Object):void
		{
			if(this._vectorData === value)
			{
				return;
			}
			else if(value !== null && !(value is Vector.<*>))
			{
				throw new ArgumentError("VectorCollection vectorData must be of type Vector");
			}
			this._vectorData = value as Vector.<*>;
			this.dispatchEventWith(CollectionEventType.RESET);
			this.dispatchEventWith(Event.CHANGE);
		}

		[Deprecated(replacement="vectorData",since="3.3.0")]
		/**
		 * @private
		 * This will be removed when the deprecated IListCollection data
		 * property is removed. 
		 */
		public function get data():Object
		{
			return this.vectorData;
		}

		[Deprecated(replacement="vectorData",since="3.3.0")]
		/**
		 * @private
		 */
		public function set data(value:Object):void
		{
			this.vectorData = value;
		}

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
			if(this._pendingRefresh)
			{
				this.refreshFilterAndSort();
			}
			if(this._filterAndSortData !== null)
			{
				return (this._filterAndSortData as Vector.<*>).length;
			}
			return (this._vectorData as Vector.<*>).length;
		}

		[Deprecated(message="Use refresh() instead of refreshFilter().")]
		/**
		 * @private
		 */
		public function refreshFilter():void
		{
			this.refresh();
		}

		/**
		 * @copy feathers.data.IListCollection#refreshFilter()
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
				var result:Vector.<*> = this._filterAndSortData as Vector.<*>;
				if(result !== null)
				{
					//reuse the old array to avoid garbage collection
					result.length = 0;
				}
				else
				{
					result = new <*>[];
				}
				var vectorData:Vector.<*> = this._vectorData as Vector.<*>;
				var itemCount:int = vectorData.length;
				var pushIndex:int = 0;
				for(var i:int = 0; i < itemCount; i++)
				{
					var item:Object = vectorData[i];
					if(this._filterFunction(item))
					{
						result[pushIndex] = item;
						pushIndex++;
					}
				}
				this._filterAndSortData = result;
			}
			else if(this._sortCompareFunction !== null) //no filter
			{
				itemCount = this._vectorData.length;
				result = this._filterAndSortData as Vector.<*>;
				if(result !== null)
				{
					result.length = itemCount;
					for(i = 0; i < itemCount; i++)
					{
						result[i] = this._vectorData[i];
					}
				}
				else
				{
					//simply make a copy!
					result = this._vectorData.slice();
				}
				this._filterAndSortData = result;
			}
			else //no filter or sort
			{
				this._filterAndSortData = null;
			}
			if(this._sortCompareFunction !== null)
			{
				this._filterAndSortData.sort(this._sortCompareFunction);
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

		/**
		 * @copy feathers.data.IListCollection#getItemAt()
		 */
		public function getItemAt(index:int):Object
		{
			if(this._pendingRefresh)
			{
				this.refreshFilterAndSort();
			}
			if(this._filterAndSortData !== null)
			{
				return this._filterAndSortData[index];
			}
			return (this._vectorData as Vector.<*>)[index];
		}

		/**
		 * @copy feathers.data.IListCollection#getItemIndex()
		 */
		public function getItemIndex(item:Object):int
		{
			if(this._pendingRefresh)
			{
				this.refreshFilterAndSort();
			}
			if(this._filterAndSortData !== null)
			{
				return (this._filterAndSortData as Vector.<*>).indexOf(item);
			}
			return (this._vectorData as Vector.<*>).indexOf(item);
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
			var filteredData:Vector.<*> = this._filterAndSortData as Vector.<*>;
			var vectorData:Vector.<*> = this._vectorData as Vector.<*>;
			if(this._filterAndSortData !== null)
			{
				if(index < filteredData.length)
				{
					//find the item at the index in the filtered data, and use
					//its index from the unfiltered data
					var oldItem:Object = filteredData[index];
					var unfilteredIndex:int = vectorData.indexOf(oldItem);
				}
				else
				{
					//if the item is added at the end of the filtered data
					//then add it at the end of the unfiltered data
					unfilteredIndex = vectorData.length;
				}
				//always add to the original data
				vectorData.insertAt(unfilteredIndex, item);
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
					filteredData.insertAt(sortedIndex, item);
					//don't dispatch these events if the item is filtered!
					this.dispatchEventWith(Event.CHANGE);
					this.dispatchEventWith(CollectionEventType.ADD_ITEM, false, sortedIndex);
				}
			}
			else //no filter or sort
			{
				vectorData.insertAt(index, item);
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
			var filteredData:Vector.<*> = this._filterAndSortData as Vector.<*>;
			var vectorData:Vector.<*> = this._vectorData as Vector.<*>;
			if(this._filterAndSortData !== null)
			{
				var item:Object = filteredData.removeAt(index);
				var unfilteredIndex:int = vectorData.indexOf(item);
				vectorData.removeAt(unfilteredIndex);
			}
			else
			{
				item = vectorData.removeAt(index);
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
			if(this.length === 0)
			{
				return;
			}
			if(this._filterAndSortData !== null)
			{
				(this._filterAndSortData as Vector.<*>).length = 0;
			}
			else
			{
				(this._vectorData as Vector.<*>).length = 0;
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
			var filteredData:Vector.<*> = this._filterAndSortData as Vector.<*>;
			var vectorData:Vector.<*> = this._vectorData as Vector.<*>;
			if(this._filterAndSortData !== null)
			{
				var oldItem:Object = filteredData[index];
				var unfilteredIndex:int = vectorData.indexOf(oldItem);
				vectorData[unfilteredIndex] = item;
				if(this._filterFunction !== null)
				{
					var includeItem:Boolean = this._filterFunction(item);
					if(includeItem)
					{
						filteredData[index] = item;
						this.dispatchEventWith(Event.CHANGE);
						this.dispatchEventWith(CollectionEventType.REPLACE_ITEM, false, index);
						return;
					}
					else
					{
						//if the item is excluded, the item at this index is
						//removed instead of being replaced by the new item
						filteredData.removeAt(index);
						this.dispatchEventWith(Event.CHANGE);
						this.dispatchEventWith(CollectionEventType.REMOVE_ITEM, false, index);
						return;
					}
				}
				else if(this._sortCompareFunction !== null)
				{
					//remove the old item first!
					this._filterAndSortData.removeAt(index);
					//then try to figure out where the new item goes when inserted
					var sortedIndex:int = this.getSortedInsertionIndex(item);
					this._filterAndSortData[sortedIndex] = item;
					this.dispatchEventWith(Event.CHANGE);
					this.dispatchEventWith(CollectionEventType.REPLACE_ITEM, false, index);
					return;
				}
			}
			else //no filter or sort
			{
				vectorData[index] = item;
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
			var vectorData:Vector.<*> = this._vectorData as Vector.<*>;
			var pushIndex:int = vectorData.length;
			for(var i:int = 0; i < otherCollectionLength; i++)
			{
				var item:Object = collection.getItemAt(i);
				vectorData[pushIndex] = item;
				pushIndex++;
			}
		}

		/**
		 * @copy feathers.data.IListCollection#addAllAt()
		 */
		public function addAllAt(collection:IListCollection, index:int):void
		{
			var otherCollectionLength:int = collection.length;
			var currentIndex:int = index;
			var vectorData:Vector.<*> = this._vectorData as Vector.<*>;
			for(var i:int = 0; i < otherCollectionLength; i++)
			{
				var item:Object = collection.getItemAt(i);
				vectorData.insertAt(currentIndex, item);
				currentIndex++;
			}
		}

		/**
		 * @copy feathers.data.IListCollection#reset()
		 */
		public function reset(collection:IListCollection):void
		{
			var vectorData:Vector.<*> = this._vectorData as Vector.<*>;
			vectorData.length = 0;
			var otherCollectionLength:int = collection.length;
			for(var i:int = 0; i < otherCollectionLength; i++)
			{
				var item:Object = collection.getItemAt(i);
				vectorData[i] = item;
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

		/**
		 * @copy feathers.data.IListCollection#contains()
		 */
		public function contains(item:Object):Boolean
		{
			return (this._vectorData as Vector.<*>).indexOf(item) !== -1;
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

 			var vectorData:Vector.<*> = this._vectorData as Vector.<*>;
			var itemCount:int = vectorData.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:Object = vectorData[i];
				disposeItem(item);
			}
		}

		/**
		 * @private
		 */
		protected function getSortedInsertionIndex(item:Object):int
		{
			var itemCount:int = this._filterAndSortData.length;
			if(this._sortCompareFunction === null)
			{
				return itemCount;
			}
			for(var i:int = 0; i < itemCount; i++)
			{
				var otherItem:Object = this._filterAndSortData[i];
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
