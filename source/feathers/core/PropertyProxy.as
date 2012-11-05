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

	/**
	 * Detects when its own properties have changed and dispatches a signal
	 * to notify listeners.
	 *
	 * <p>Supports nested <code>PropertyProxy</code> instances using attribute
	 * <code>&#64;</code> notation. Placing an <code>&#64;</code> before a property name
	 * is like saying, "If this nested <code>PropertyProxy</code> doesn't exist
	 * yet, create one. If it does, use the existing one."</p>
	 */
	public final dynamic class PropertyProxy extends Proxy
	{
		/**
		 * Creates a <code>PropertyProxy</code> from a regular old <code>Object</code>.
		 */
		public static function fromObject(source:Object, onChangeCallback:Function = null):PropertyProxy
		{
			const newValue:PropertyProxy = new PropertyProxy(onChangeCallback);
			for(var propertyName:String in source)
			{
				newValue[propertyName] = source[propertyName];
			}
			return newValue;
		}

		/**
		 * Constructor.
		 */
		public function PropertyProxy(onChangeCallback:Function = null)
		{
			if(onChangeCallback != null)
			{
				this._onChangeCallbacks.push(onChangeCallback);
			}
		}

		/**
		 * @private
		 */
		private var _subProxyName:String;

		/**
		 * @private
		 */
		private var _onChangeCallbacks:Vector.<Function> = new <Function>[];

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
					const subProxy:PropertyProxy = new PropertyProxy(subProxy_onChange);
					subProxy._subProxyName = nameAsString;
					this._storage[nameAsString] = subProxy;
					this._names.push(nameAsString);
					this.fireOnChangeCallback(nameAsString);
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
			this.fireOnChangeCallback(name);
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
				this.fireOnChangeCallback(name);
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

		/**
		 * Adds a callback to react to property changes.
		 */
		public function addOnChangeCallback(callback:Function):void
		{
			this._onChangeCallbacks.push(callback);
		}

		/**
		 * Removes a callback.
		 */
		public function removeOnChangeCallback(callback:Function):void
		{
			const index:int = this._onChangeCallbacks.indexOf(callback);
			if(index >= 0)
			{
				this._onChangeCallbacks.splice(index, 1);
			}
		}

		/**
		 * @private
		 */
		private function fireOnChangeCallback(forName:String):void
		{
			const callbackCount:int = this._onChangeCallbacks.length;
			for(var i:int = 0; i < callbackCount; i++)
			{
				var callback:Function = this._onChangeCallbacks[i] as Function;
				callback(this, forName);
			}
		}

		/**
		 * @private
		 */
		private function subProxy_onChange(proxy:PropertyProxy, name:String):void
		{
			this.fireOnChangeCallback(proxy._subProxyName);
		}
	}
}
