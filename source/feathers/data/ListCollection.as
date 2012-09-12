/*
Copyright (c) 2012 Josh Tynjala

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
*/
package feathers.data
{
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

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
	public class ListCollection
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
		protected var _onChange:Signal = new Signal(ListCollection);
		
		/**
		 * Dispatched when the underlying data source changes and the list will
		 * need to redraw the data.
		 */
		public function get onChange():ISignal
		{
			return this._onChange;
		}
		
		/**
		 * @private
		 */
		protected var _onAdd:Signal = new Signal(ListCollection, int);
		
		/**
		 * Dispatched when an item is added to the collection.
		 *
		 * <p>Listeners are expected to have the following function signature:</p>
		 * <pre>function(collection:ListCollection, itemIndex:int):void</pre>
		 */
		public function get onAdd():ISignal
		{
			return this._onAdd;
		}
		
		/**
		 * @private
		 */
		protected var _onRemove:Signal = new Signal(ListCollection, int);
		
		/**
		 * Dispatched when an item is removed from the collection.
		 *
		 * <p>Listeners are expected to have the following function signature:</p>
		 * <pre>function(collection:ListCollection, itemIndex:int):void</pre>
		 */
		public function get onRemove():ISignal
		{
			return this._onRemove;
		}
		
		/**
		 * @private
		 */
		protected var _onReplace:Signal = new Signal(ListCollection, int);
		
		/**
		 * Dispatched when an item is replaced in the collection.
		 */
		public function get onReplace():ISignal
		{
			return this._onReplace;
		}
		
		/**
		 * @private
		 */
		protected var _onReset:Signal = new Signal(ListCollection);
		
		/**
		 * Dispatched when the collection has changed drastically, such as when
		 * the underlying data source is replaced completely.
		 */
		public function get onReset():ISignal
		{
			return this._onReset;
		}

		/**
		 * @private
		 */
		protected var _onItemUpdate:Signal = new Signal(ListCollection, int);

		/**
		 * Dispatched when a property of an item in the collection has changed
		 * and the item doesn't have its own change event or signal. This signal
		 * is only dispatched when the <code>updateItemAt()</code> function is
		 * called on the <code>ListCollection</code>.
		 *
		 * <p>In general, it's better for the items themselves to dispatch events
		 * or signals when their properties change.</p>
		 *
		 * <p>Listeners are expected to have the following function signature:</p>
		 * <pre>function(collection:ListCollection, itemIndex:int):void</pre>
		 */
		public function get onItemUpdate():ISignal
		{
			return this._onItemUpdate;
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
				this.dataDescriptor = new ArrayListCollectionDataDescriptor();
			}
			else if(this._data is Vector.<Number> && !(this._dataDescriptor is VectorNumberListCollectionDataDescriptor))
			{
				this.dataDescriptor = new VectorNumberListCollectionDataDescriptor();
			}
			else if(this._data is Vector.<int> && !(this._dataDescriptor is VectorIntListCollectionDataDescriptor))
			{
				this.dataDescriptor = new VectorIntListCollectionDataDescriptor();
			}
			else if(this._data is Vector.<uint> && !(this._dataDescriptor is VectorUintListCollectionDataDescriptor))
			{
				this.dataDescriptor = new VectorUintListCollectionDataDescriptor();
			}
			else if(this._data is Vector.<*> && !(this._dataDescriptor is VectorListCollectionDataDescriptor))
			{
				this.dataDescriptor = new VectorListCollectionDataDescriptor();
			}
			else if(this._data is XMLList && !(this._dataDescriptor is XMLListListCollectionDataDescriptor))
			{
				this.dataDescriptor = new XMLListListCollectionDataDescriptor();
			}
			this._onReset.dispatch(this);
			this._onChange.dispatch(this);
		}
		
		/**
		 * @private
		 */
		private var _dataDescriptor:IListCollectionDataDescriptor;

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
			this._onReset.dispatch(this);
			this._onChange.dispatch(this);
		}

		/**
		 * The number of items in the collection.
		 */
		public function get length():int
		{
			return this._dataDescriptor.getLength(this._data);
		}

		/**
		 * If an item doesn't dispatch an event or signal to indicate that it
		 * has changed, you can manually tell the collection about the change,
		 * and the collection will dispatch the <code>onItemUpdate</code> signal
		 * to manually notify the component that renders the data.
		 */
		public function updateItemAt(index:int):void
		{
			this._onItemUpdate.dispatch(this, index);
		}
		
		/**
		 * Returns the item at the specified index in the collection.
		 */
		public function getItemAt(index:int):Object
		{
			return this._dataDescriptor.getItemAt(this._data, index);
		}
		
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
			this._onChange.dispatch(this);
			this._onAdd.dispatch(this, index);
		}
		
		/**
		 * Removes the item at the specified index from the collection and
		 * returns it.
		 */
		public function removeItemAt(index:int):Object
		{
			const item:Object = this._dataDescriptor.removeItemAt(this._data, index);
			this._onChange.dispatch(this);
			this._onRemove.dispatch(this, index);
			return item;
		}
		
		/**
		 * Removes a specific item from the collection.
		 */
		public function removeItem(item:Object):void
		{
			const index:int = this.getItemIndex(item);
			if(index >= 0)
			{
				this.removeItemAt(index);
			}
		}
		
		/**
		 * Replaces the item at the specified index with a new item.
		 */
		public function setItemAt(item:Object, index:int):void
		{
			this._dataDescriptor.setItemAt(this._data, item, index);
			this._onReplace.dispatch(this, index);
			this._onChange.dispatch(this);
		}
		
		/**
		 * Adds an item to the end of the collection.
		 */
		public function push(item:Object):void
		{
			this.addItemAt(item, this.length);
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
	}
}