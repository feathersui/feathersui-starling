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
	 *
	 * Wraps an <code>Array</code> in the common <code>IListCollection</code>
	 * API used by many Feathers UI controls, including <code>List</code> and
	 * <code>TabBar</code>.
	 *
	 * @productversion Feathers 3.3.0
	 */
	public class ArrayCollection extends EventDispatcher implements IListCollection
	{
		/**
		 * Constructor
		 */
		public function ArrayCollection(data:Array = null)
		{
			if(data === null)
			{
				data = [];
			}
			this._arrayData = data;
		}

		/**
		 * @private
		 */
		protected var _filterAndSortData:Array;

		/**
		 * @private
		 */
		protected var _arrayData:Array;

		/**
		 * The <code>Array</code> data source for this collection.
		 */
		public function get arrayData():Array
		{
			return this._arrayData;
		}

		/**
		 * @private
		 */
		public function set arrayData(value:Array):void
		{
			if(this._arrayData === value)
			{
				return;
			}
			this._arrayData = value;
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
				return this._filterAndSortData.length;
			}
			return this._arrayData.length;
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
				var result:Array = this._filterAndSortData;
				if(result !== null)
				{
					//reuse the old array to avoid garbage collection
					result.length = 0;
				}
				else
				{
					result = [];
				}
				var itemCount:int = this._arrayData.length;
				var pushIndex:int = 0;
				for(var i:int = 0; i < itemCount; i++)
				{
					var item:Object = this._arrayData[i];
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
				itemCount = this._arrayData.length;
				result = this._filterAndSortData;
				if(result !== null)
				{
					result.length = itemCount;
					for(i = 0; i < itemCount; i++)
					{
						result[i] = this._arrayData[i];
					}
				}
				else
				{
					//simply make a copy!
					result = this._arrayData.slice();
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
			return this._arrayData[index];
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
				return this._filterAndSortData.indexOf(item);
			}
			return this._arrayData.indexOf(item);
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
			if(this._filterAndSortData !== null)
			{
				if(index < this._filterAndSortData.length)
				{
					//find the item at the index in the filtered data, and use
					//its index from the unfiltered data
					var oldItem:Object = this._filterAndSortData[index];
					var unfilteredIndex:int = this._arrayData.indexOf(oldItem);
				}
				else
				{
					//if the item is added at the end of the filtered data
					//then add it at the end of the unfiltered data
					unfilteredIndex = this._arrayData.length;
				}
				//always add to the original data
				this._arrayData.insertAt(unfilteredIndex, item);
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
					this._filterAndSortData.insertAt(sortedIndex, item);
					//don't dispatch these events if the item is filtered!
					this.dispatchEventWith(Event.CHANGE);
					this.dispatchEventWith(CollectionEventType.ADD_ITEM, false, sortedIndex);
				}
			}
			else //no filter or sort
			{
				this._arrayData.insertAt(index, item);
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
			if(this._filterAndSortData !== null)
			{
				var item:Object = this._filterAndSortData.removeAt(index);
				var unfilteredIndex:int = this._arrayData.indexOf(item);
				this._arrayData.removeAt(unfilteredIndex);
			}
			else
			{
				item = this._arrayData.removeAt(index);
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
			if(this._filterAndSortData !== null)
			{
				this._filterAndSortData.length = 0;
			}
			else
			{
				this._arrayData.length = 0;
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
			if(this._filterAndSortData !== null)
			{
				var oldItem:Object = this._filterAndSortData[index];
				var unfilteredIndex:int = this._arrayData.indexOf(oldItem);
				this._arrayData[unfilteredIndex] = item;
				if(this._filterFunction !== null)
				{
					var includeItem:Boolean = this._filterFunction(item);
					if(includeItem)
					{
						this._filterAndSortData[index] = item;
						this.dispatchEventWith(Event.CHANGE);
						this.dispatchEventWith(CollectionEventType.REPLACE_ITEM, false, index);
						return;
					}
					else
					{
						//if the item is excluded, the item at this index is
						//removed instead of being replaced by the new item
						this._filterAndSortData.removeAt(index);
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
				this._arrayData[index] = item;
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
			var pushIndex:int = this._arrayData.length;
			for(var i:int = 0; i < otherCollectionLength; i++)
			{
				var item:Object = collection.getItemAt(i);
				this._arrayData[pushIndex] = item;
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
			for(var i:int = 0; i < otherCollectionLength; i++)
			{
				var item:Object = collection.getItemAt(i);
				this._arrayData.insertAt(currentIndex, item);
				currentIndex++;
			}
		}

		/**
		 * @copy feathers.data.IListCollection#reset()
		 */
		public function reset(collection:IListCollection):void
		{
			this._arrayData.length = 0;
			var otherCollectionLength:int = collection.length;
			for(var i:int = 0; i < otherCollectionLength; i++)
			{
				var item:Object = collection.getItemAt(i);
				this._arrayData[i] = item;
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
			return this._arrayData.indexOf(item) != -1;
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

			var itemCount:int = this._arrayData.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:Object = this._arrayData[i];
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
