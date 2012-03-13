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
package org.josht.starling.foxhole.data
{
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	public class ListCollection
	{
		public function ListCollection(data:Object = null)
		{
			this.data = data;
		}
		
		private var _onChange:Signal = new Signal(ListCollection);
		
		public function get onChange():ISignal
		{
			return this._onChange;
		}
		
		private var _onAdd:Signal = new Signal(ListCollection, int);
		
		public function get onAdd():ISignal
		{
			return this._onAdd;
		}
		
		private var _onRemove:Signal = new Signal(ListCollection, int);
		
		public function get onRemove():ISignal
		{
			return this._onRemove;
		}
		
		private var _onReplace:Signal = new Signal(ListCollection, int);
		
		public function get onReplace():ISignal
		{
			return this._onReplace;
		}
		
		private var _onReset:Signal = new Signal(ListCollection);
		
		public function get onReset():ISignal
		{
			return this._onReset;
		}
		
		protected var _data:Object;

		public function get data():Object
		{
			return _data;
		}

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
		
		private var _dataDescriptor:IListCollectionDataDescriptor;

		public function get dataDescriptor():IListCollectionDataDescriptor
		{
			return this._dataDescriptor;
		}

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

		public function get length():int
		{
			return this._dataDescriptor.getLength(this._data);
		}
		
		public function getItemAt(index:int):Object
		{
			return this._dataDescriptor.getItemAt(this._data, index);
		}
		
		public function getItemIndex(item:Object):int
		{
			return this._dataDescriptor.getItemIndex(this._data, item);
		}
		
		public function addItemAt(item:Object, index:int):void
		{
			this._dataDescriptor.addItemAt(this._data, item, index);
			this._onChange.dispatch(this);
			this._onAdd.dispatch(this, index);
		}
		
		public function removeItemAt(index:int):Object
		{
			const item:Object = this._dataDescriptor.removeItemAt(this._data, index);
			this._onChange.dispatch(this);
			this._onRemove.dispatch(this, index);
			return item;
		}
		
		public function removeItem(item:Object):void
		{
			const index:int = this.getItemIndex(item);
			if(index >= 0)
			{
				this.removeItemAt(index);
			}
		}
		
		public function setItemAt(item:Object, index:int):void
		{
			this._dataDescriptor.setItemAt(this._data, item, index);
			this._onReplace.dispatch(this);
			this._onChange.dispatch(this);
		}
		
		public function push(item:Object):void
		{
			this.addItemAt(item, this.length);
		}
		
		public function pop():Object
		{
			return this.removeItemAt(this.length - 1);
		}
		
		public function unshift(item:Object):void
		{
			this.addItemAt(item, 0);
		}
		
		public function shift():Object
		{
			return this.removeItemAt(0);
		}
	}
}