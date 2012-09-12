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
	 * Wraps a two-dimensional data source with a common API for use with UI
	 * controls that support this type of data.
	 */
	public class HierarchicalCollection
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
		protected var _onChange:Signal = new Signal(HierarchicalCollection);

		/**
		 * Dispatched when the underlying data source changes and the ui will
		 * need to redraw the data.
		 */
		public function get onChange():ISignal
		{
			return this._onChange;
		}

		/**
		 * @private
		 */
		protected var _onReset:Signal = new Signal(HierarchicalCollection);

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
		protected var _onAdd:Signal = new Signal(HierarchicalCollection, int);

		/**
		 * Dispatched when an item is added to the collection.
		 *
		 * <p>Listeners are expected to have the following function signature:</p>
		 * <pre>function(collection:HierarchicalCollection, index:int, ...rest:Array):void</pre>
		 */
		public function get onAdd():ISignal
		{
			return this._onAdd;
		}

		/**
		 * @private
		 */
		protected var _onRemove:Signal = new Signal(HierarchicalCollection, int);

		/**
		 * Dispatched when an item is removed from the collection.
		 *
		 * <p>Listeners are expected to have the following function signature:</p>
		 * <pre>function(collection:HierarchicalCollection, index:int, ...rest:Array):void</pre>
		 */
		public function get onRemove():ISignal
		{
			return this._onRemove;
		}

		/**
		 * @private
		 */
		protected var _onReplace:Signal = new Signal(HierarchicalCollection, int);

		/**
		 * Dispatched when an item is replaced in the collection.
		 *
		 * <p>Listeners are expected to have the following function signature:</p>
		 * <pre>function(collection:HierarchicalCollection, index:int, ...rest:Array):void</pre>
		 */
		public function get onReplace():ISignal
		{
			return this._onReplace;
		}

		/**
		 * @private
		 */
		protected var _onItemUpdate:Signal = new Signal(HierarchicalCollection, int);

		/**
		 * Dispatched when a property of an item in the collection has changed
		 * and the item doesn't have its own change event or signal. This signal
		 * is only dispatched when the <code>updateItemAt()</code> function is
		 * called on the <code>HierarchicalCollection</code>.
		 *
		 * <p>In general, it's better for the items themselves to dispatch events
		 * or signals when their properties change.</p>
		 *
		 * <p>Listeners are expected to have the following function signature:</p>
		 * <pre>function(collection:HierarchicalCollection, index:int, ...rest:Array):void</pre>
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
			this._onReset.dispatch(this);
			this._onChange.dispatch(this);
		}

		/**
		 * @private
		 */
		private var _dataDescriptor:IHierarchicalCollectionDataDescriptor = new ArrayChildrenHierarchicalCollectionDataDescriptor();

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
			this._onReset.dispatch(this);
			this._onChange.dispatch(this);
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
			rest.unshift(this._data)
			return this._dataDescriptor.getLength.apply(null, rest);
		}

		/**
		 * If an item doesn't dispatch an event or signal to indicate that it
		 * has changed, you can manually tell the collection about the change,
		 * and the collection will dispatch the <code>onItemUpdate</code> signal
		 * to manually notify the component that renders the data.
		 */
		public function updateItemAt(index:int, ...rest:Array):void
		{
			rest.unshift(index);
			rest.unshift(this);
			this._onItemUpdate.dispatch.apply(null, rest);
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
			this._onChange.dispatch(this);
			rest.shift();
			rest.shift();
			rest.unshift(this);
			this._onAdd.dispatch.apply(null, rest);
		}

		/**
		 * Removes the item at the specified location from the collection and
		 * returns it.
		 */
		public function removeItemAt(index:int, ...rest:Array):Object
		{
			rest.push(index);
			rest.push(this._data);
			const item:Object = this._dataDescriptor.removeItemAt.apply(null, rest);
			this._onChange.dispatch(this);
			rest.shift();
			rest.unshift(this);
			this._onRemove.dispatch.apply(null, rest);
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
				this.removeItemAt.apply(this, location);
			}
		}

		/**
		 * Replaces the item at the specified location with a new item.
		 */
		public function setItemAt(item:Object, index:int, ...rest:Array):void
		{
			rest.push(index);
			rest.push(item);
			rest.push(this._data);
			this._dataDescriptor.setItemAt.apply(null, rest);
			rest.shift();
			rest.shift();
			rest.unshift(this);
			this._onReplace.dispatch.apply(null, rest);
			this._onChange.dispatch(this);
		}
	}
}
