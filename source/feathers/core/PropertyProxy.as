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
package feathers.core
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	/**
	 * Detects when its own properties have changed and dispatches a signal
	 * to notify listeners.
	 *
	 * <p>Supports nested <code>PropertyProxy</code> instances using attribute
	 * <code>&#64;</code> notation. Placing an <code>&#64;</code> before a property name
	 * is like saying, "If this nested <code>PropertyProxy</code> doesn't exist
	 * yet, create one. If it does, use the existing one."</p>
	 */
	public dynamic class PropertyProxy extends Proxy
	{
		public static function fromObject(source:Object, onChangeListener:Function = null):PropertyProxy
		{
			const newValue:PropertyProxy = new PropertyProxy(onChangeListener);
			for(var propertyName:String in source)
			{
				newValue[propertyName] = source[propertyName];
			}
			return newValue;
		}

		/**
		 * Constructor.
		 */
		public function PropertyProxy(onChange:Function = null)
		{
			if(onChange != null)
			{
				this._onChange.add(onChange);
			}
		}

		/**
		 * @private
		 */
		private var _names:Array = [];

		/**
		 * @private
		 */
		private var _storage:Object = {};

		/**
		 * @private
		 */
		private var _onChange:Signal = new Signal(PropertyProxy, Object);

		/**
		 * Dispatched when a property changes.
		 *
		 * <p>Listeners are expected to have the following function signature:</p>
		 * <pre>function(proxy:PropertyProxy, propertyName:String):void</pre>
		 */
		public function get onChange():ISignal
		{
			return this._onChange;
		}

		/**
		 * @private
		 */
		override flash_proxy function hasProperty(name:*):Boolean
		{
			return this._storage.hasOwnProperty(name);
		}

		/**
		 * @private
		 */
		override flash_proxy function getProperty(name:*):*
		{
			if(this.flash_proxy::isAttribute(name))
			{
				const nameAsString:String = name is QName ? QName(name).localName : name.toString();
				if(!this._storage.hasOwnProperty(nameAsString))
				{
					this._storage[nameAsString] = new PropertyProxy();
					this._names.push(nameAsString);
					this._onChange.dispatch(this, nameAsString);
				}
				return this._storage[nameAsString];
			}
			return this._storage[name];
		}

		/**
		 * @private
		 */
		override flash_proxy function setProperty(name:*, value:*):void
		{
			this._storage[name] = value;
			if(this._names.indexOf(name) < 0)
			{
				this._names.push(name);
			}
			this._onChange.dispatch(this, name);
		}

		/**
		 * @private
		 */
		override flash_proxy function deleteProperty(name:*):Boolean
		{
			const index:int = this._names.indexOf(name);
			if(index >= 0)
			{
				this._names.splice(index, 1);
			}
			const result:Boolean = delete this._storage[name];
			if(result)
			{
				this._onChange.dispatch(this, name);
			}
			return result;
		}

		/**
		 * @private
		 */
		override flash_proxy function nextNameIndex(index:int):int
		{
			if(index < this._names.length)
			{
				return index + 1;
			}
			return 0;
		}

		/**
		 * @private
		 */
		override flash_proxy function nextName(index:int):String
		{
			return this._names[index - 1];
		}

		/**
		 * @private
		 */
		override flash_proxy function nextValue(index:int):*
		{
			const name:* = this._names[index - 1];
			return this._storage[name];
		}
	}
}
