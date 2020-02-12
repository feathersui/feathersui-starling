/*
Feathers
Copyright 2012-2020 Bowler Hat LLC. All Rights Reserved.

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

	[DefaultProperty("arrayData")]
	/**
	 * Wraps an <code>Array</code> data source with a common API for use with
	 * UI controls that support hierarchical data.
	 *
	 * @productversion Feathers 3.3.0
	 */
	public class ArrayHierarchicalCollection extends EventDispatcher implements IHierarchicalCollection
	{
		/**
		 * Constructor.
		 */
		public function ArrayHierarchicalCollection(arrayData:Array = null)
		{
			if(arrayData === null)
			{
				arrayData = [];
			}
			this._arrayData = arrayData;
		}

		/**
		 * @private
		 */
		protected var _arrayData:Array = null;

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
		protected var _childrenField:String = "children";

		/**
		 * The field of a branch object used to access its children. The
		 * field's type must be <code>Array</code> to be treated as a branch.
		 */
		public function get childrenField():String
		{
			return this._childrenField;
		}

		public function set childrenField(value:String):void
		{
			this._childrenField = value;
		}

		/**
		 * @copy feathers.data.IHierarchicalCollection#isBranch()
		 */
		public function isBranch(node:Object):Boolean
		{
			if(node === null)
			{
				return false;
			}
			return node.hasOwnProperty(this._childrenField) && node[this._childrenField] is Array;
		}

		/**
		 * @copy feathers.data.IHierarchicalCollection#getLength()
		 *
		 * @see #getLengthAtLocation()
		 *
		 * @throws RangeError Branch not found at specified location
		 */
		public function getLength(...rest:Array):int
		{
			var branch:Array = this._arrayData;
			var indexCount:int = rest.length;
			for(var i:int = 0; i < indexCount; i++)
			{
				var index:int = rest[i] as int;
				branch = branch[index][this._childrenField] as Array;
				if(branch === null)
				{
					throw new RangeError("Branch not found at location: " + rest);
				}
			}
			return branch.length;
		}

		/**
		 * @copy feathers.data.IHierarchicalCollection#getLengthAtLocation()
		 *
		 * @throws RangeError Branch not found at specified location
		 */
		public function getLengthAtLocation(location:Vector.<int> = null):int
		{
			var branch:Array = this._arrayData;
			if(location !== null)
			{
				var indexCount:int = location.length;
				for(var i:int = 0; i < indexCount; i++)
				{
					var index:int = location[i];
					branch = branch[index][this._childrenField] as Array;
					if(branch === null)
					{
						throw new RangeError("Branch not found at location: " + location);
					}
				}
			}
			return branch.length;
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

		/**
		 * @copy feathers.data.IHierarchicalCollection#updateAll()
		 *
		 * @see #updateItemAt()
		 */
		public function updateAll():void
		{
			this.dispatchEventWith(CollectionEventType.UPDATE_ALL);
		}

		/**
		 * @copy feathers.data.IHierarchicalCollection#getItemAt()
		 *
		 * @see #getItemAtLocation()
		 */
		public function getItemAt(index:int, ...rest:Array):Object
		{
			rest.insertAt(0, index);
			var branch:Array = this._arrayData;
			var indexCount:int = rest.length - 1;
			for(var i:int = 0; i < indexCount; i++)
			{
				index = rest[i] as int;
				branch = branch[index][this._childrenField] as Array;
				if(branch === null)
				{
					return null;
				}
			}
			var lastIndex:int = rest[indexCount] as int;
			return branch[lastIndex];
		}

		/**
		 * @copy feathers.data.IHierarchicalCollection#getItemAtLocation()
		 */
		public function getItemAtLocation(location:Vector.<int>):Object
		{
			if(location === null || location.length == 0)
			{
				return null;
			}
			var branch:Array = this._arrayData;
			var indexCount:int = location.length - 1;
			for(var i:int = 0; i < indexCount; i++)
			{
				var index:int = location[i];
				branch = branch[index][this._childrenField] as Array;
				if(branch === null)
				{
					return null;
				}
			}
			index = location[indexCount];
			return branch[index];
		}

		/**
		 * @copy feathers.data.IHierarchicalCollection#getItemLocation()
		 */
		public function getItemLocation(item:Object, result:Vector.<int> = null):Vector.<int>
		{
			if(!result)
			{
				result = new <int>[];
			}
			else
			{
				result.length = 0;
			}
			var branch:Array = this._arrayData;
			this.findItemInBranch(branch, item, result);
			return result;
		}

		/**
		 * @copy feathers.data.IHierarchicalCollection#addItemAt()
		 *
		 * @see #addItemAtLocation()
		 *
		 * @throws RangeError Branch not found at specified location
		 */
		public function addItemAt(item:Object, index:int, ...rest:Array):void
		{
			rest.insertAt(0, index);
			var branch:Array = this._arrayData;
			var indexCount:int = rest.length - 1;
			for(var i:int = 0; i < indexCount; i++)
			{
				index = rest[i] as int;
				branch = branch[index][this._childrenField] as Array;
				if(branch === null)
				{
					throw new RangeError("Branch not found at location: " + rest);
				}
			}
			index = rest[indexCount] as int;
			branch.insertAt(index, item);
			this.dispatchEventWith(Event.CHANGE);
			this.dispatchEventWith(CollectionEventType.ADD_ITEM, false, rest);
		}

		/**
		 * @copy feathers.data.IHierarchicalCollection#addItemAtLocation()
		 *
		 * @throws RangeError Branch not found at specified location
		 */
		public function addItemAtLocation(item:Object, location:Vector.<int>):void
		{
			if(location === null || location.length == 0)
			{
				throw new RangeError("Branch not found at location: " + location);
			}
			var eventIndices:Array = [];
			var branch:Array = this._arrayData;
			var indexCount:int = location.length - 1;
			for(var i:int = 0; i < indexCount; i++)
			{
				var index:int = location[i];
				branch = branch[index][this._childrenField] as Array;
				if(branch === null)
				{
					throw new RangeError("Branch not found at location: " + location);
				}
				eventIndices[i] = index;
			}
			index = location[indexCount];
			eventIndices[indexCount] = index;
			branch.insertAt(index, item);
			this.dispatchEventWith(Event.CHANGE);
			this.dispatchEventWith(CollectionEventType.ADD_ITEM, false, eventIndices);
		}

		/**
		 * @copy feathers.data.IHierarchicalCollection#removeItemAt()
		 * 
		 * @see #removeItemAtLocation()
		 *
		 * @throws RangeError Branch not found at specified location
		 */
		public function removeItemAt(index:int, ...rest:Array):Object
		{
			rest.insertAt(0, index);
			var branch:Array = this._arrayData;
			var indexCount:int = rest.length - 1;
			for(var i:int = 0; i < indexCount; i++)
			{
				index = rest[i] as int;
				branch = branch[index][this._childrenField] as Array;
				if(branch === null)
				{
					throw new RangeError("Branch not found at location: " + rest);
				}
			}
			index = rest[indexCount] as int;
			var item:Object = branch.removeAt(index);
			this.dispatchEventWith(Event.CHANGE);
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
			if(location === null || location.length == 0)
			{
				throw new RangeError("Branch not found at location: " + location);
			}
			var eventIndices:Array = [];
			var branch:Array = this._arrayData;
			var indexCount:int = location.length - 1;
			for(var i:int = 0; i < indexCount; i++)
			{
				var index:int = location[i];
				branch = branch[index][this._childrenField] as Array;
				if(branch === null)
				{
					throw new RangeError("Branch not found at location: " + location);
				}
				eventIndices[i] = index;
			}
			index = location[indexCount];
			eventIndices[indexCount] = index;
			var item:Object = branch.removeAt(index);
			this.dispatchEventWith(Event.CHANGE);
			this.dispatchEventWith(CollectionEventType.REMOVE_ITEM, false, eventIndices);
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
				this.removeItemAtLocation(location)
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
			this._arrayData.length = 0;
			this.dispatchEventWith(CollectionEventType.REMOVE_ALL);
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @copy feathers.data.IHierarchicalCollection#setItemAt()
		 *
		 * @see #setItemAtLocation()
		 *
		 * @throws RangeError Branch not found at specified location
		 */
		public function setItemAt(item:Object, index:int, ...rest:Array):void
		{
			rest.insertAt(0, index);
			var branch:Array = this._arrayData;
			var indexCount:int = rest.length - 1;
			for(var i:int = 0; i < indexCount; i++)
			{
				index = rest[i] as int;
				branch = branch[index][this._childrenField] as Array;
				if(branch === null)
				{
					throw new RangeError("Branch not found at location: " + rest);
				}
			}
			index = rest[indexCount] as int;
			branch[index] = item;
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
			if(location === null || location.length == 0)
			{
				throw new RangeError("Branch not found at location: " + location);
			}
			var eventIndices:Array = [];
			var branch:Array = this._arrayData;
			var indexCount:int = location.length - 1;
			for(var i:int = 0; i < indexCount; i++)
			{
				var index:int = location[i];
				branch = branch[index][this._childrenField] as Array;
				if(branch === null)
				{
					throw new RangeError("Branch not found at location: " + location);
				}
				eventIndices[i] = index;
			}
			index = location[indexCount];
			eventIndices[indexCount] = index;
			branch[index] = item;
			this.dispatchEventWith(Event.CHANGE);
			this.dispatchEventWith(CollectionEventType.REPLACE_ITEM, false, eventIndices);
		}

		/**
		 * @copy feathers.data.IHierarchicalCollection#dispose()
		 *
		 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#dispose() starling.display.DisplayObject.dispose()
		 * @see http://doc.starling-framework.org/core/starling/textures/Texture.html#dispose() starling.textures.Texture.dispose()
		 */
		public function dispose(disposeBranch:Function, disposeItem:Function):void
		{
			var groupCount:int = this._arrayData.length;
			var path:Array = [];
			for(var i:int = 0; i < groupCount; i++)
			{
				var group:Object = this._arrayData[i];
				path[0] = i;
				this.disposeGroupInternal(group, path, disposeBranch, disposeItem);
				path.length = 0;
			}
		}

		/**
		 * @private
		 */
		protected function disposeGroupInternal(group:Object, path:Array, disposeBranch:Function, disposeItem:Function):void
		{
			if(disposeBranch !== null)
			{
				disposeBranch(group);
			}

			var itemCount:int = this.getLength.apply(this, path);
			for(var i:int = 0; i < itemCount; i++)
			{
				path[path.length] = i;
				var item:Object = this.getItemAt.apply(this, path);
				if(this.isBranch(item))
				{
					this.disposeGroupInternal(item, path, disposeBranch, disposeItem);
				}
				else if(disposeItem !== null)
				{
					disposeItem(item);
				}
				path.length--;
			}
		}

		/**
		 * @private
		 */
		protected function findItemInBranch(branch:Array, item:Object, result:Vector.<int>):Boolean
		{
			var insertIndex:int = result.length;
			var branchLength:int = branch.length;
			for(var i:int = 0; i < branchLength; i++)
			{
				var branchItem:Object = branch[i];
				if(branchItem === item)
				{
					result[insertIndex] = i;
					return true;
				}
				if(this.isBranch(branchItem))
				{
					result[insertIndex] = i;
					var children:Array = branchItem[this._childrenField] as Array;
					var isFound:Boolean = this.findItemInBranch(children, item, result);
					if(isFound)
					{
						return true;
					}
					result.pop();
				}
			}
			return false;
		}
	}
}
