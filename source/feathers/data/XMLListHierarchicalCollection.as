/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.data
{
	import feathers.events.CollectionEventType;
	import feathers.utils.xml.xmlListInsertAt;

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

	/**
	 * Wraps an XML data source with a common API for use with UI controls that
	 * support hierarchical data.
	 *
	 * @productversion Feathers 3.3.0
	 */
	public class XMLListHierarchicalCollection extends EventDispatcher implements IHierarchicalCollection
	{
		/**
		 * Constructor.
		 */
		public function XMLListHierarchicalCollection(xmlListData:XMLList = null)
		{
			if(xmlListData === null)
			{
				xmlListData = new XMLList();
			}
			this._xmlListData = xmlListData;
		}

		/**
		 * @private
		 */
		protected var _xmlListData:XMLList = null;

		/**
		 * The <code>XMLList</code> data source for this collection. 
		 */
		public function get xmlListData():XMLList
		{
			return this._xmlListData;
		}

		/**
		 * @private
		 */
		public function set xmlListData(value:XMLList):void
		{
			if(this._xmlListData === value)
			{
				return;
			}
			this._xmlListData = value;
			this.dispatchEventWith(CollectionEventType.RESET);
			this.dispatchEventWith(Event.CHANGE);
		}

		[Deprecated(replacement="xmlListData",since="3.3.0")]
		/**
		 * @private
		 */
		public function get data():Object
		{
			return this.xmlListData;
		}

		[Deprecated(replacement="xmlListData",since="3.3.0")]
		/**
		 * @private
		 */
		public function set data(value:Object):void
		{
			if(!(value is XMLList))
			{
				throw new ArgumentError("XMLListHierarchicalCollection data must be of type XMLList.");
			}
			this.xmlListData = value as XMLList;
		}

		/**
		 * @copy feathers.data.IHierarchicalCollection#isBranch()
		 */
		public function isBranch(node:Object):Boolean
		{
			var xml:XML = node as XML;
			if(xml === null)
			{
				return false;
			}
			return xml.elements().length() > 0;
		}

		/**
		 * @copy feathers.data.IHierarchicalCollection#getLength()
		 *
		 * @see #getLengthAtLocation()
		 */
		public function getLength(...rest:Array):int
		{
			var branch:XMLList = this._xmlListData;
			var indexCount:int = rest.length;
			for(var i:int = 0; i < indexCount; i++)
			{
				var index:int = rest[i] as int;
				branch = branch[index].elements();
			}

			return branch.length();
		}

		/**
		 * @copy feathers.data.IHierarchicalCollection#getLengthAtLocation()
		 */
		public function getLengthAtLocation(location:Vector.<int> = null):int
		{
			var branch:XMLList = this._xmlListData;
			if(location !== null)
			{
				var indexCount:int = location.length;
				for(var i:int = 0; i < indexCount; i++)
				{
					var index:int = location[i];
					branch = branch[index].elements();
				}
			}
			return branch.length();
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
			var branch:XMLList = this._xmlListData;
			var indexCount:int = rest.length - 1;
			for(var i:int = 0; i < indexCount; i++)
			{
				index = rest[i] as int;
				branch = branch[index].elements();
			}
			index = rest[indexCount] as int;
			return branch[index] as XML;
		}

		/**
		 * @copy feathers.data.IHierarchicalCollection#getItemAtLocation()
		 */
		public function getItemAtLocation(location:Vector.<int>):Object
		{
			var branch:XMLList = this._xmlListData;
			var indexCount:int = location.length - 1;
			for(var i:int = 0; i < indexCount; i++)
			{
				var index:int = location[i];
				branch = branch[index].elements();
			}
			index = location[indexCount];
			return branch[index] as XML;
		}

		/**
		 * @copy feathers.data.IHierarchicalCollection#getItemLocation()
		 */
		public function getItemLocation(item:Object, result:Vector.<int> = null):Vector.<int>
		{
			if(result === null)
			{
				result = new <int>[];
			}
			else
			{
				result.length = 0;
			}
			var xmlItem:XML = item as XML;
			if(xmlItem === null)
			{
				return result;
			}
			this.findItemInBranch(this._xmlListData, xmlItem, result);
			return result;
		}

		/**
		 * @copy feathers.data.IHierarchicalCollection#addItemAt()
		 *
		 * @see #addItemAtLocation()
		 */
		public function addItemAt(item:Object, index:int, ...rest:Array):void
		{
			rest.insertAt(0, index);
			var parentOfBranch:XML = null;
			var branch:XMLList = this._xmlListData;
			var indexCount:int = rest.length - 1;
			for(var i:int = 0; i < indexCount; i++)
			{
				index = rest[i] as int;
				parentOfBranch = branch[index] as XML;
				branch = parentOfBranch.elements();
			}
			index = rest[indexCount] as int;
			branch = xmlListInsertAt(branch, index, item as XML);
			if(parentOfBranch === null)
			{
				this._xmlListData = branch;
			}
			else
			{
				parentOfBranch.setChildren(branch);
			}
			this.dispatchEventWith(Event.CHANGE);
			this.dispatchEventWith(CollectionEventType.ADD_ITEM, false, rest);
		}

		/**
		 * @copy feathers.data.IHierarchicalCollection#addItemAtLocation()
		 */
		public function addItemAtLocation(item:Object, location:Vector.<int>):void
		{
			var eventIndices:Array = [];
			var parentOfBranch:XML = null;
			var branch:XMLList = this._xmlListData;
			var indexCount:int = location.length - 1;
			for(var i:int = 0; i < indexCount; i++)
			{
				var index:int = location[i];
				parentOfBranch = branch[index] as XML;
				branch = parentOfBranch.elements();
				eventIndices[i] = index;
			}
			index = location[indexCount];
			eventIndices[indexCount] = index;
			branch = xmlListInsertAt(branch, index, item as XML);
			if(parentOfBranch === null)
			{
				this._xmlListData = branch;
			}
			else
			{
				parentOfBranch.setChildren(branch);
			}
			this.dispatchEventWith(Event.CHANGE);
			this.dispatchEventWith(CollectionEventType.ADD_ITEM, false, eventIndices);
		}

		/**
		 * @copy feathers.data.IHierarchicalCollection#removeItemAt()
		 * 
		 * @see #removeItemAtLocation()
		 */
		public function removeItemAt(index:int, ...rest:Array):Object
		{
			rest.insertAt(0, index);
			var branch:XMLList = this._xmlListData;
			var indexCount:int = rest.length - 1;
			for(var i:int = 0; i < indexCount; i++)
			{
				index = rest[i] as int;
				branch = branch[index].elements();
			}
			index = rest[indexCount] as int;
			var item:XML = branch[index] as XML;
			delete branch[index];
			this.dispatchEventWith(Event.CHANGE);
			this.dispatchEventWith(CollectionEventType.REMOVE_ITEM, false, rest);
			return item;
		}

		/**
		 * @copy feathers.data.IHierarchicalCollection#removeItemAtLocation()
		 */
		public function removeItemAtLocation(location:Vector.<int>):Object
		{
			var eventIndices:Array = [];
			var branch:XMLList = this._xmlListData;
			var indexCount:int = location.length - 1;
			for(var i:int = 0; i < indexCount; i++)
			{
				var index:int = location[i];
				branch = branch[index].elements();
				eventIndices[i] = index;
			}
			index = location[indexCount];
			eventIndices[indexCount] = index;
			var item:XML = branch[index] as XML;
			delete branch[index];
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
				this.removeItemAtLocation(location);
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
			this._xmlListData = new XMLList();
			this.dispatchEventWith(CollectionEventType.REMOVE_ALL);
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @copy feathers.data.IHierarchicalCollection#setItemAt()
		 *
		 * @see #setItemAtLocation()
		 */
		public function setItemAt(item:Object, index:int, ...rest:Array):void
		{
			rest.insertAt(0, index);
			var branch:XMLList = this._xmlListData;
			var indexCount:int = rest.length - 1;
			for(var i:int = 0; i < indexCount; i++)
			{
				index = rest[i] as int;
				branch = branch[index].elements();
			}
			index = rest[indexCount] as int;
			branch[index] = item;
			this.dispatchEventWith(CollectionEventType.REPLACE_ITEM, false, rest);
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @copy feathers.data.IHierarchicalCollection#setItemAtLocation()
		 */
		public function setItemAtLocation(item:Object, location:Vector.<int>):void
		{
			var eventIndices:Array = [];
			var branch:XMLList = this._xmlListData;
			var indexCount:int = location.length - 1;
			for(var i:int = 0; i < indexCount; i++)
			{
				var index:int = location[i];
				branch = branch[index].elements();
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
		public function dispose(disposeGroup:Function, disposeItem:Function):void
		{
			var groupCount:int = this.getLength();
			var path:Array = [];
			for(var i:int = 0; i < groupCount; i++)
			{
				var group:Object = this.getItemAt(i);
				path[0] = i;
				this.disposeGroupInternal(group, path, disposeGroup, disposeItem);
				path.length = 0;
			}
		}

		/**
		 * @private
		 */
		protected function disposeGroupInternal(group:Object, path:Array, disposeGroup:Function, disposeItem:Function):void
		{
			if(disposeGroup != null)
			{
				disposeGroup(group);
			}

			var itemCount:int = this.getLength.apply(this, path);
			for(var i:int = 0; i < itemCount; i++)
			{
				path[path.length] = i;
				var item:Object = this.getItemAt.apply(this, path);
				if(this.isBranch(item))
				{
					this.disposeGroupInternal(item, path, disposeGroup, disposeItem);
				}
				else if(disposeItem != null)
				{
					disposeItem(item);
				}
				path.length--;
			}
		}

		/**
		 * @private
		 */
		protected function findItemInBranch(branch:XMLList, item:XML, result:Vector.<int>):Boolean
		{
			var branchLength:int = branch.length();
			var insertIndex:int = result.length;
			for(var i:int = 0; i < branchLength; i++)
			{
				var branchItem:XML = branch[i] as XML;
				//don't use strict equality here or it may not be possible to
				//find items that were added
				if(branchItem == item)
				{
					result[insertIndex] = i;
					return true;
				}
				if(this.isBranch(branchItem))
				{
					result[insertIndex] = i;
					var isFound:Boolean = this.findItemInBranch(branchItem.elements(), item, result);
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
