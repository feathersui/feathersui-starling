package feathers.tests
{
	import feathers.data.ArrayCollection;
	import feathers.data.ListCollection;
	import feathers.events.CollectionEventType;

	import org.flexunit.Assert;

	import starling.events.Event;

	public class ArrayCollectionTests
	{
		private var _collection:ArrayCollection;
		private var _a:Object;
		private var _b:Object;
		private var _c:Object;
		private var _d:Object;

		[Before]
		public function prepare():void
		{
			this._a = { label: "One", value: 0 };
			this._b = { label: "Two", value: 2 };
			this._c = { label: "Three", value: 3 };
			this._d = { label: "Four", value: 1 };
			this._collection = new ArrayCollection(
			[
				this._a,
				this._b,
				this._c,
				this._d,
			]);
		}

		[After]
		public function cleanup():void
		{
			this._collection = null;
		}

		private function filterFunction(item:Object):Boolean
		{
			if(item === this._a || item === this._c)
			{
				return false;
			}
			return true;
		}

		private function sortCompareFunction(a:Object, b:Object):int
		{
			var valueA:Number = a.value as Number;
			var valueB:Number = b.value as Number;
			if(valueA < valueB)
			{
				return -1;
			}
			if(valueA > valueB)
			{
				return 1;
			}
			return 0;
		}

		[Test]
		public function testRemoveAll():void
		{
			var hasChanged:Boolean = false;
			this._collection.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			var hasRemovedAll:Boolean = false;
			this._collection.addEventListener(CollectionEventType.REMOVE_ALL, function(event:Event):void
			{
				hasRemovedAll = true;
			});
			var hasReset:Boolean = false;
			this._collection.addEventListener(CollectionEventType.RESET, function(event:Event):void
			{
				hasReset = true;
			});
			this._collection.removeAll();
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			//reset used to be dispatched, but REMOVE_ALL is better
			Assert.assertFalse("CollectionEventType.RESET was incorrectly dispatched", hasReset);
			Assert.assertTrue("CollectionEventType.REMOVE_ALL was not dispatched", hasRemovedAll);
			Assert.assertStrictlyEquals("The length property was not changed to 0",
				0, this._collection.length);
		}

		[Test]
		public function testRemoveItemAt():void
		{
			var itemToRemove:Object = this._collection.getItemAt(1);
			var originalLength:int = this._collection.length;
			var expectedIndex:int = 1;
			var hasChanged:Boolean = false;
			this._collection.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			var hasRemovedItem:Boolean = false;
			var indexFromEvent:int = -1;
			this._collection.addEventListener(CollectionEventType.REMOVE_ITEM, function(event:Event, index:int):void
			{
				hasRemovedItem = true;
				indexFromEvent = index;
			});
			this._collection.removeItemAt(expectedIndex);
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertTrue("CollectionEventType.REMOVE_ITEM was not dispatched", hasRemovedItem);
			Assert.assertStrictlyEquals("The length property was not changed",
				originalLength - 1, this._collection.length);
			Assert.assertStrictlyEquals("The item was not removed",
				-1, this._collection.getItemIndex(itemToRemove));
			Assert.assertStrictlyEquals("The CollectionEventType.REMOVE_ITEM event data was not the correct index",
				expectedIndex, indexFromEvent);
		}

		[Test]
		public function testRemoveItem():void
		{
			var expectedIndex:int = 1;
			var itemToRemove:Object = this._collection.getItemAt(expectedIndex);
			var originalLength:int = this._collection.length;
			var hasChanged:Boolean = false;
			this._collection.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			var hasRemovedItem:Boolean = false;
			var indexFromEvent:int = -1;
			this._collection.addEventListener(CollectionEventType.REMOVE_ITEM, function(event:Event, index:int):void
			{
				hasRemovedItem = true;
				indexFromEvent = index;
			});
			this._collection.removeItem(itemToRemove);
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertTrue("CollectionEventType.REMOVE_ITEM was not dispatched", hasRemovedItem);
			Assert.assertStrictlyEquals("The length property was not changed",
				originalLength - 1, this._collection.length);
			Assert.assertStrictlyEquals("The item was not removed",
				-1, this._collection.getItemIndex(itemToRemove));
			Assert.assertStrictlyEquals("The CollectionEventType.REMOVE_ITEM event data was not the correct index",
				expectedIndex, indexFromEvent);
		}

		[Test]
		public function testShift():void
		{
			var itemToRemove:Object = this._collection.getItemAt(0);
			var originalLength:int = this._collection.length;
			var expectedIndex:int = 0;
			var hasChanged:Boolean = false;
			this._collection.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			var hasRemovedItem:Boolean = false;
			var indexFromEvent:int = -1;
			this._collection.addEventListener(CollectionEventType.REMOVE_ITEM, function(event:Event, index:int):void
			{
				hasRemovedItem = true;
				indexFromEvent = index;
			});
			this._collection.shift();
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertTrue("CollectionEventType.REMOVE_ITEM was not dispatched", hasRemovedItem);
			Assert.assertStrictlyEquals("The length property was not changed",
				originalLength - 1, this._collection.length);
			Assert.assertStrictlyEquals("The item was not removed",
				-1, this._collection.getItemIndex(itemToRemove));
			Assert.assertStrictlyEquals("The CollectionEventType.REMOVE_ITEM event data was not the correct index",
				expectedIndex, indexFromEvent);
		}

		[Test]
		public function testPop():void
		{
			var originalLength:int = this._collection.length;
			var itemToRemove:Object = this._collection.getItemAt(originalLength - 1);
			var expectedIndex:int = originalLength - 1;
			var hasChanged:Boolean = false;
			this._collection.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			var hasRemovedItem:Boolean = false;
			var indexFromEvent:int = -1;
			this._collection.addEventListener(CollectionEventType.REMOVE_ITEM, function(event:Event, index:int):void
			{
				hasRemovedItem = true;
				indexFromEvent = index;
			});
			this._collection.pop();
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertTrue("CollectionEventType.REMOVE_ITEM was not dispatched", hasRemovedItem);
			Assert.assertStrictlyEquals("The length property was not changed",
				originalLength - 1, this._collection.length);
			Assert.assertStrictlyEquals("The item was not removed",
				-1, this._collection.getItemIndex(itemToRemove));
			Assert.assertStrictlyEquals("The CollectionEventType.REMOVE_ITEM event data was not the correct index",
				expectedIndex, indexFromEvent);
		}

		[Test]
		public function testAddItem():void
		{
			var itemToAdd:Object = { label: "New Item" };
			var originalLength:int = this._collection.length;
			var expectedIndex:int = originalLength;
			var hasChanged:Boolean = false;
			this._collection.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			var hasAddedItem:Boolean = false;
			var indexFromEvent:int = -1;
			this._collection.addEventListener(CollectionEventType.ADD_ITEM, function(event:Event, index:int):void
			{
				hasAddedItem = true;
				indexFromEvent = index;
			});
			this._collection.addItem(itemToAdd);
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertTrue("CollectionEventType.ADD_ITEM was not dispatched", hasAddedItem);
			Assert.assertStrictlyEquals("The length property was not changed",
				originalLength + 1, this._collection.length);
			Assert.assertStrictlyEquals("The item was not added at the correct index",
				expectedIndex, this._collection.getItemIndex(itemToAdd));
			Assert.assertStrictlyEquals("The CollectionEventType.ADD_ITEM event data was not the correct index",
				expectedIndex, indexFromEvent);
		}

		[Test]
		public function testAddItemAt():void
		{
			var itemToAdd:Object = { label: "New Item" };
			var expectedIndex:int = 1;
			var originalLength:int = this._collection.length;
			var hasChanged:Boolean = false;
			this._collection.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			var hasAddedItem:Boolean = false;
			var indexFromEvent:int = -1;
			this._collection.addEventListener(CollectionEventType.ADD_ITEM, function(event:Event, index:int):void
			{
				hasAddedItem = true;
				indexFromEvent = index;
			});
			this._collection.addItemAt(itemToAdd, expectedIndex);
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertTrue("CollectionEventType.ADD_ITEM was not dispatched", hasAddedItem);
			Assert.assertStrictlyEquals("The length property was not changed",
				originalLength + 1, this._collection.length);
			Assert.assertStrictlyEquals("The item was not added at the correct index",
				expectedIndex, this._collection.getItemIndex(itemToAdd));
			Assert.assertStrictlyEquals("The CollectionEventType.ADD_ITEM event data was not the correct index",
				expectedIndex, indexFromEvent);
		}

		[Test]
		public function testUnshift():void
		{
			var itemToAdd:Object = { label: "New Item" };
			var expectedIndex:int = 0;
			var originalLength:int = this._collection.length;
			var hasChanged:Boolean = false;
			this._collection.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			var hasAddedItem:Boolean = false;
			var indexFromEvent:int = -1;
			this._collection.addEventListener(CollectionEventType.ADD_ITEM, function(event:Event, index:int):void
			{
				hasAddedItem = true;
				indexFromEvent = index;
			});
			this._collection.unshift(itemToAdd);
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertTrue("CollectionEventType.ADD_ITEM was not dispatched", hasAddedItem);
			Assert.assertStrictlyEquals("The length property was not changed",
				originalLength + 1, this._collection.length);
			Assert.assertStrictlyEquals("The item was not added at the correct index",
				expectedIndex, this._collection.getItemIndex(itemToAdd));
			Assert.assertStrictlyEquals("The CollectionEventType.ADD_ITEM event data was not the correct index",
				expectedIndex, indexFromEvent);
		}

		[Test]
		public function testPush():void
		{
			var itemToAdd:Object = { label: "New Item" };
			var originalLength:int = this._collection.length;
			var expectedIndex:int = originalLength;
			var hasChanged:Boolean = false;
			this._collection.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			var hasAddedItem:Boolean = false;
			var indexFromEvent:int = -1;
			this._collection.addEventListener(CollectionEventType.ADD_ITEM, function(event:Event, index:int):void
			{
				hasAddedItem = true;
				indexFromEvent = index;
			});
			this._collection.push(itemToAdd);
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertTrue("CollectionEventType.ADD_ITEM was not dispatched", hasAddedItem);
			Assert.assertStrictlyEquals("The length property was not changed",
				originalLength + 1, this._collection.length);
			Assert.assertStrictlyEquals("The item was not added at the correct index",
				expectedIndex, this._collection.getItemIndex(itemToAdd));
			Assert.assertStrictlyEquals("The CollectionEventType.ADD_ITEM event data was not the correct index",
				expectedIndex, indexFromEvent);
		}

		[Test]
		public function testSetItemAt():void
		{
			var itemToAdd:Object = { label: "New Item" };
			var expectedIndex:int = 1;
			var originalLength:int = this._collection.length;
			var hasChanged:Boolean = false;
			this._collection.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			var hasAddedItem:Boolean = false;
			var indexFromEvent:int = -1;
			this._collection.addEventListener(CollectionEventType.REPLACE_ITEM, function(event:Event, index:int):void
			{
				hasAddedItem = true;
				indexFromEvent = index;
			});
			this._collection.setItemAt(itemToAdd, expectedIndex);
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertTrue("CollectionEventType.REPLACE_ITEM was not dispatched", hasAddedItem);
			Assert.assertStrictlyEquals("The length property was incorrectly changed",
				originalLength, this._collection.length);
			Assert.assertStrictlyEquals("The item was not added at the correct index",
				expectedIndex, this._collection.getItemIndex(itemToAdd));
			Assert.assertStrictlyEquals("The CollectionEventType.REPLACE_ITEM event data was not the correct index",
				expectedIndex, indexFromEvent);
		}

		[Test]
		public function testContainsWithItemInCollection():void
		{
			var item:Object = this._collection.getItemAt(1);
			Assert.assertStrictlyEquals("contains() incorrectly returned false",
				true, this._collection.contains(item));
		}

		[Test]
		public function testContainsWithItemNotInCollection():void
		{
			var item:Object = {};
			Assert.assertStrictlyEquals("contains() incorrectly returned true",
				false, this._collection.contains(item));
		}

		[Test]
		public function testGetItemIndexWithItemInCollection():void
		{
			var expectedIndex:int = 1;
			var item:Object = this._collection.getItemAt(expectedIndex);
			Assert.assertStrictlyEquals("getItemIndex() returned the incorrect value",
				expectedIndex, this._collection.getItemIndex(item));
		}

		[Test]
		public function testGetItemIndexWithItemNotInCollection():void
		{
			var item:Object = {};
			Assert.assertStrictlyEquals("getItemIndex() returned the incorrect value",
				-1, this._collection.getItemIndex(item));
		}

		[Test]
		public function testDispose():void
		{
			var itemCount:int = this._collection.length;
			var disposedCount:int = 0;
			this._collection.dispose(function(item:Object):void
			{
				item.isDisposed = true;
				disposedCount++;
			});
			Assert.assertStrictlyEquals("Incorrect number of items disposed when calling dispose() on ArrayCollection",
				itemCount, disposedCount);
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:Object = this._collection.getItemAt(i);
				Assert.assertTrue("Item was not included when calling dispose() on ArrayCollection", item.isDisposed);
			}
		}

		[Test]
		public function testDisposeWithFilterFunction():void
		{
			var itemCount:int = this._collection.length;
			this._collection.filterFunction = function(item:Object):Boolean
			{
				return item.label.charAt(0) === "O";
			};
			var filteredCount:int = this._collection.length;
			Assert.assertFalse("Filtered collection length must change", itemCount === filteredCount);
			var disposedCount:int = 0;
			this._collection.dispose(function(item:Object):void
			{
				item.isDisposed = true;
				disposedCount++;
			});
			Assert.assertStrictlyEquals("Incorrect number of items disposed when calling dispose() on ArrayCollection",
				itemCount, disposedCount);
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:Object = this._collection.getItemAt(i);
				Assert.assertTrue("Item was not included when calling dispose() on ArrayCollection", item.isDisposed);
			}
		}

		[Test]
		public function testSortCompareFunction():void
		{
			this._collection.sortCompareFunction = this.sortCompareFunction;
			Assert.assertStrictlyEquals("ArrayCollection: sortCompareFunction order is incorrect.",
				this._a, this._collection.getItemAt(0));
			Assert.assertStrictlyEquals("ArrayCollection: sortCompareFunction order is incorrect.",
				this._d, this._collection.getItemAt(1));
			Assert.assertStrictlyEquals("ArrayCollection: sortCompareFunction order is incorrect.",
				this._b, this._collection.getItemAt(2));
			Assert.assertStrictlyEquals("ArrayCollection: sortCompareFunction order is incorrect.",
				this._c, this._collection.getItemAt(3));
		}

		[Test]
		public function testSortCompareFunctionAndFilterFunction():void
		{
			this._collection.sortCompareFunction = this.sortCompareFunction;
			this._collection.filterFunction = this.filterFunction;
			Assert.assertStrictlyEquals("ArrayCollection: sortCompareFunction and filterFunction length is incorrect.",
				2, this._collection.length);
			Assert.assertStrictlyEquals("ArrayCollection: sortCompareFunction order is incorrect with filterFunction.",
				this._d, this._collection.getItemAt(0));
			Assert.assertStrictlyEquals("ArrayCollection: sortCompareFunction order is incorrect with filterFunction.",
				this._b, this._collection.getItemAt(1));
		}

		[Test]
		public function testSetSortCompareFunctionToNull():void
		{
			this._collection.sortCompareFunction = this.sortCompareFunction;
			//get an item so that we know the sorting was applied
			Assert.assertStrictlyEquals("ArrayCollection: sortCompareFunction order is incorrect.",
				this._c, this._collection.getItemAt(3));

			this._collection.sortCompareFunction = null;
			Assert.assertStrictlyEquals("ArrayCollection: set sortCompareFunction to null order is incorrect.",
				this._a, this._collection.getItemAt(0));
			Assert.assertStrictlyEquals("ArrayCollection: set sortCompareFunction to null order is incorrect.",
				this._b, this._collection.getItemAt(1));
			Assert.assertStrictlyEquals("ArrayCollection: set sortCompareFunction to null order is incorrect.",
				this._c, this._collection.getItemAt(2));
			Assert.assertStrictlyEquals("ArrayCollection: set sortCompareFunction to null order is incorrect.",
				this._d, this._collection.getItemAt(3));
		}

		[Test]
		public function testSortCompareFunctionWithAddItem():void
		{
			var newItem:Object = { label: "New Item", value: 1.5 };
			this._collection.sortCompareFunction = this.sortCompareFunction;
			this._collection.addItem(newItem);
			Assert.assertStrictlyEquals("ArrayCollection: addItem() with sortCompareFunction does not add at correctly sorted index.",
				newItem, this._collection.getItemAt(2));
		}
	}
}
