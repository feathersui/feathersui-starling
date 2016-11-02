package feathers.tests
{
	import feathers.data.ListCollection;
	import feathers.events.CollectionEventType;

	import org.flexunit.Assert;

	import starling.events.Event;

	public class ListCollectionFilterTests
	{
		private var _collection:ListCollection;

		private var _includedItem:Object;
		private var _excludedItem:Object;
		private var _addedIncludedItem:Object;
		private var _addedExcludedItem:Object;

		[Before]
		public function prepare():void
		{
			this._includedItem = { label: "Included" };
			this._excludedItem = { label: "Excluded" };
			this._addedIncludedItem = { label: "Added and Included" };
			this._addedExcludedItem = { label: "Added and Excluded" };
			this._collection = new ListCollection(
			[
				this._includedItem,
				this._excludedItem,
			]);
			this._collection.filterFunction = this.filterFunction;
		}

		[After]
		public function cleanup():void
		{
			this._collection = null;
		}

		private function filterFunction(item:Object):Boolean
		{
			if(this._addedExcludedItem !== null && item === this._addedExcludedItem)
			{
				return false;
			}
			if(this._addedIncludedItem !== null && item === this._addedIncludedItem)
			{
				return true;
			}
			if(this._excludedItem !== null && item === this._excludedItem)
			{
				return false;
			}
			if(this._includedItem !== null && item === this._includedItem)
			{
				return true;
			}
			throw new Error("This should not happen");
		}

	//-- length

		[Test]
		public function testLengthWithFilterFunction():void
		{
			Assert.assertStrictlyEquals("ListCollection filterFunction must update length if items are excluded.",
				1, this._collection.length);
		}

		[Test]
		public function testLengthWithFilterFunctionAndSetFilterFunctionToNull():void
		{
			this._collection.filterFunction = null;
			Assert.assertStrictlyEquals("ListCollection must update length if filterFunction is set to null.",
				2, this._collection.length);
		}

	//-- contains()

		[Test]
		public function testContainsWithFilterFunction():void
		{
			Assert.assertTrue("ListCollection contains() must return true if filterFunction is set to function, and item is included.",
				this._collection.contains(this._includedItem));
			Assert.assertFalse("ListCollection contains() must return false if filterFunction is set to function, and item is excluded.",
				this._collection.contains(this._excludedItem));
		}

		[Test]
		public function testContainsWithFilterFunctionAndSetFilterFunctionToNull():void
		{
			this._collection.filterFunction = null;
			Assert.assertTrue("ListCollection contains() must return true for included item if filterFunction is set to null.",
				this._collection.contains(this._includedItem));
			Assert.assertTrue("ListCollection contains() must return true for excluded item if filterFunction is set to null.",
				this._collection.contains(this._excludedItem));
		}

	//-- addItem

		[Test]
		public function testAddItemWithFilterFunctionIncludedItem():void
		{
			var addItemDispatched:Boolean = false;
			var addItemIndex:int = -1;
			this._collection.addEventListener(CollectionEventType.ADD_ITEM, function(event:Event, index:int):void
			{
				addItemDispatched = true;
				addItemIndex = index;
			});
			this._collection.addItem(this._addedIncludedItem);
			Assert.assertStrictlyEquals("ListCollection filterFunction must increase length if item passed to addItem() is included.",
				2, this._collection.length);
			Assert.assertStrictlyEquals("ListCollection getItemAt() returns incorrect item with filterFunction after item passed to addItem() is included.",
				this._collection.getItemAt(1), this._addedIncludedItem);
			Assert.assertTrue("ListCollection contains() must return true with filterFunction if item passed to addItem() is included.",
				this._collection.contains(this._addedIncludedItem));
			Assert.assertStrictlyEquals("ListCollection getItemIndex() must return correct index with filterFunction if item passed to addItem() is included.",
				1, this._collection.getItemIndex(this._addedIncludedItem));
			Assert.assertTrue("ListCollection must dispatch CollectionEventType.ADD_ITEM with filterFunction if item passed to addItem() is included.",
				addItemDispatched);
			Assert.assertStrictlyEquals("ListCollection must include correct index with CollectionEventType.ADD_ITEM with filterFunction if item passed to addItem() is included.",
				1, addItemIndex);
		}

		[Test]
		public function testAddItemWithFilterFunctionExcludedItem():void
		{
			var addItemDispatched:Boolean = false;
			this._collection.addEventListener(CollectionEventType.ADD_ITEM, function(event:Event):void
			{
				addItemDispatched = true;
			});
			this._collection.addItem(this._addedExcludedItem);
			Assert.assertStrictlyEquals("ListCollection filterFunction must not change length if item passed to addItem() is excluded.",
				1, this._collection.length);
			Assert.assertFalse("ListCollection contains() must return false with filterFunction if item passed to addItem() is excluded.",
				this._collection.contains(this._addedExcludedItem));
			Assert.assertStrictlyEquals("ListCollection getItemIndex() must return -1 with filterFunction if item passed to addItem() is excluded.",
				-1, this._collection.getItemIndex(this._addedExcludedItem));
			Assert.assertFalse("ListCollection must not dispatch CollectionEventType.ADD_ITEM with filterFunction if item passed to addItem() is excluded.",
				addItemDispatched);
		}

		[Test]
		public function testAddItemWithFilterFunctionExcludedItemAndSetFilterFunctionToNull():void
		{
			this._collection.addItem(this._addedExcludedItem);
			this._collection.filterFunction = null;
			Assert.assertStrictlyEquals("ListCollection filterFunction must restore length after filterFunction is set to null.",
				3, this._collection.length);
			Assert.assertTrue("ListCollection contains() must return true for excluded item after filterFunction is set to null.",
				this._collection.contains(this._addedExcludedItem));
			Assert.assertStrictlyEquals("ListCollection getItemIndex() must return correct index for excluded item after filterFunction is set to null.",
				2, this._collection.getItemIndex(this._addedExcludedItem));
		}

	//-- addItemAt

		[Test]
		public function testAddItemAtWithFilterFunctionIncludedItem():void
		{
			var addItemDispatched:Boolean = false;
			var addItemIndex:int = -1;
			this._collection.addEventListener(CollectionEventType.ADD_ITEM, function(event:Event, index:int):void
			{
				addItemDispatched = true;
				addItemIndex = index;
			});
			this._collection.addItemAt(this._addedIncludedItem, 0);
			Assert.assertStrictlyEquals("ListCollection filterFunction must increase length if item passed to addItem() is included.",
				2, this._collection.length);
			Assert.assertStrictlyEquals("ListCollection getItemAt() returns incorrect item with filterFunction after item passed to addItem() is included.",
				this._collection.getItemAt(0), this._addedIncludedItem);
			Assert.assertTrue("ListCollection contains() must return true with filterFunction if item passed to addItem() is included.",
				this._collection.contains(this._addedIncludedItem));
			Assert.assertStrictlyEquals("ListCollection getItemIndex() must return correct index with filterFunction if item passed to addItem() is included.",
				0, this._collection.getItemIndex(this._addedIncludedItem));
			Assert.assertTrue("ListCollection must dispatch CollectionEventType.ADD_ITEM with filterFunction if item passed to addItem() is included.",
				addItemDispatched);
			Assert.assertStrictlyEquals("ListCollection must include correct index with CollectionEventType.ADD_ITEM with filterFunction if item passed to addItem() is included.",
				0, addItemIndex);
		}

		[Test]
		public function testAddItemAtWithFilterFunctionExcludedItem():void
		{
			var addItemDispatched:Boolean = false;
			this._collection.addEventListener(CollectionEventType.ADD_ITEM, function(event:Event):void
			{
				addItemDispatched = true;
			});
			this._collection.addItemAt(this._addedExcludedItem, 0);
			Assert.assertStrictlyEquals("ListCollection filterFunction must not change length if item passed to addItem() is excluded.",
				1, this._collection.length);
			Assert.assertFalse("ListCollection contains() must return false with filterFunction if item passed to addItem() is excluded.",
				this._collection.contains(this._addedExcludedItem));
			Assert.assertStrictlyEquals("ListCollection getItemIndex() must return -1 with filterFunction if item passed to addItem() is excluded.",
				-1, this._collection.getItemIndex(this._addedExcludedItem));
			Assert.assertFalse("ListCollection must not dispatch CollectionEventType.ADD_ITEM with filterFunction if item passed to addItem() is excluded.",
				addItemDispatched);
		}

		[Test]
		public function testAddItemAtWithFilterFunctionExcludedItemAndSetFilterFunctionToNull():void
		{
			this._collection.addItemAt(this._addedExcludedItem, 0);
			this._collection.filterFunction = null;
			Assert.assertStrictlyEquals("ListCollection filterFunction must restore length after filterFunction is set to null.",
				3, this._collection.length);
			Assert.assertTrue("ListCollection contains() must return true for excluded item after filterFunction is set to null.",
				this._collection.contains(this._addedExcludedItem));
			Assert.assertStrictlyEquals("ListCollection getItemIndex() must return correct index for excluded item after filterFunction is set to null.",
				0, this._collection.getItemIndex(this._addedExcludedItem));
		}

		[Test]
		public function testAddItemAtWithFilterFunctionExcludedItemThenAddItemAtWithIncludedItemAndSetFilterFunctionToNull():void
		{
			//the included item is added to index 0 after the excluded item, but
			//because the collection is filtered, the included item is relative
			//to another included item, which isn't at index 0 in the unfiltered
			//collection.
			this._collection.addItemAt(this._addedExcludedItem, 0);
			this._collection.addItemAt(this._addedIncludedItem, 0);
			this._collection.filterFunction = null;
			Assert.assertStrictlyEquals("ListCollection getItemIndex() must return correct index for excluded item after filterFunction is set to null.",
				0, this._collection.getItemIndex(this._addedExcludedItem));
			Assert.assertStrictlyEquals("ListCollection getItemIndex() must return correct index for included item after filterFunction is set to null.",
				1, this._collection.getItemIndex(this._addedIncludedItem));
		}

	//-- removeItem

		[Test]
		public function testRemoveItemWithFilterFunctionIncludedItem():void
		{
			var removeItemDispatched:Boolean = false;
			var removeItemIndex:int = -1;
			this._collection.addEventListener(CollectionEventType.REMOVE_ITEM, function(event:Event, index:int):void
			{
				removeItemDispatched = true;
				removeItemIndex = index;
			});
			this._collection.removeItem(this._includedItem);
			Assert.assertStrictlyEquals("ListCollection filterFunction must decrease length if item passed to removeItem() is included.",
				0, this._collection.length);
			Assert.assertFalse("ListCollection contains() must return false with filterFunction if item passed to removeItem() is included.",
				this._collection.contains(this._addedIncludedItem));
			Assert.assertStrictlyEquals("ListCollection getItemIndex() must return -1 with filterFunction if item passed to removeItem() is included.",
				-1, this._collection.getItemIndex(this._addedIncludedItem));
			Assert.assertTrue("ListCollection must dispatch CollectionEventType.REMOVE_ITEM with filterFunction if item passed to removeItem() is included.",
				removeItemDispatched);
			Assert.assertStrictlyEquals("ListCollection must include correct index with CollectionEventType.REMOVE_ITEM with filterFunction if item passed to removeItem() is included.",
				0, removeItemIndex);
		}

		[Test]
		public function testRemoveItemWithFilterFunctionExcludedItem():void
		{
			var removeItemDispatched:Boolean = false;
			this._collection.addEventListener(CollectionEventType.REMOVE_ITEM, function(event:Event, index:int):void
			{
				removeItemDispatched = true;
			});
			this._collection.removeItem(this._excludedItem);
			Assert.assertStrictlyEquals("ListCollection filterFunction must not change length if item passed to removeItem() is excluded.",
				1, this._collection.length);
			Assert.assertFalse("ListCollection must not dispatch CollectionEventType.REMOVE_ITEM with filterFunction if item passed to removeItem() is excluded.",
				removeItemDispatched);
		}

		[Test]
		public function testRemoveItemWithFilterFunctionIncludedItemAndSetFilterFunctionToNull():void
		{
			this._collection.removeItem(this._includedItem);
			this._collection.filterFunction = null;
			Assert.assertStrictlyEquals("ListCollection filterFunction must restore length after filterFunction is set to null.",
				1, this._collection.length);
			Assert.assertFalse("ListCollection contains() must return false for included item after filterFunction is set to null.",
				this._collection.contains(this._includedItem));
			Assert.assertStrictlyEquals("ListCollection getItemIndex() must return -1 for included item that was removed after filterFunction is set to null.",
				-1, this._collection.getItemIndex(this._includedItem));
		}

		[Test]
		public function testRemoveItemWithFilterFunctionExcludedItemAndSetFilterFunctionToNull():void
		{
			this._collection.removeItem(this._excludedItem);
			this._collection.filterFunction = null;
			Assert.assertStrictlyEquals("ListCollection filterFunction must restore length after filterFunction is set to null.",
				2, this._collection.length);
			Assert.assertTrue("ListCollection contains() must return true for excluded item after filterFunction is set to null.",
				this._collection.contains(this._excludedItem));
			Assert.assertStrictlyEquals("ListCollection getItemIndex() must return correct index for excluded item after filterFunction is set to null.",
				1, this._collection.getItemIndex(this._excludedItem));
		}

	//-- setItemAt

		[Test]
		public function testSetItemAtWithFilterFunctionIncludedItem():void
		{
			var replaceItemDispatched:Boolean = false;
			var replaceItemIndex:int = -1;
			this._collection.addEventListener(CollectionEventType.REPLACE_ITEM, function(event:Event, index:int):void
			{
				replaceItemDispatched = true;
				replaceItemIndex = index;
			});
			this._collection.setItemAt(this._addedIncludedItem, 0);
			Assert.assertStrictlyEquals("ListCollection filterFunction must maintain length if item passed to setItemAt() is included.",
				1, this._collection.length);
			Assert.assertTrue("ListCollection contains() must return true with filterFunction if item passed to setItemAt() is included.",
				this._collection.contains(this._addedIncludedItem));
			Assert.assertStrictlyEquals("ListCollection getItemIndex() must return correct index with filterFunction if item passed to setItemAt() is included.",
				0, this._collection.getItemIndex(this._addedIncludedItem));
			Assert.assertTrue("ListCollection must dispatch CollectionEventType.REPLACE_ITEM with filterFunction if item passed to setItemAt() is included.",
				replaceItemDispatched);
			Assert.assertStrictlyEquals("ListCollection must include correct index with CollectionEventType.REPLACE_ITEM with filterFunction if item passed to setItemAt() is included.",
				0, replaceItemIndex);
		}

		[Test]
		public function testSetItemAtWithFilterFunctionExcludedItem():void
		{
			var replaceItemDispatched:Boolean = false;
			this._collection.addEventListener(CollectionEventType.REPLACE_ITEM, function(event:Event):void
			{
				replaceItemDispatched = true;
			});
			var removeItemDispatched:Boolean = false;
			var removeItemIndex:int = -1;
			this._collection.addEventListener(CollectionEventType.REMOVE_ITEM, function(event:Event, index:int):void
			{
				removeItemDispatched = true;
				removeItemIndex = index;
			});
			this._collection.setItemAt(this._addedExcludedItem, 0);
			Assert.assertStrictlyEquals("ListCollection filterFunction must reduce length if item passed to setItemAt() is excluded and old item was included.",
				0, this._collection.length);
			Assert.assertFalse("ListCollection contains() must return true with filterFunction if item passed to setItemAt() is excluded.",
				this._collection.contains(this._addedExcludedItem));
			Assert.assertStrictlyEquals("ListCollection getItemIndex() must return -1 with filterFunction if item passed to setItemAt() is excluded.",
				-1, this._collection.getItemIndex(this._addedExcludedItem));
			Assert.assertFalse("ListCollection must not dispatch CollectionEventType.REPLACE_ITEM with filterFunction if item passed to setItemAt() is excluded.",
				replaceItemDispatched);
			Assert.assertTrue("ListCollection must dispatch CollectionEventType.REMOVE_ITEM with filterFunction if item passed to setItemAt() is excluded.",
				removeItemDispatched);
			Assert.assertStrictlyEquals("ListCollection must include correct index with CollectionEventType.REMOVE_ITEM with filterFunction if item passed to setItemAt() is excluded.",
				0, removeItemIndex);
		}

		[Test]
		public function testSetItemAtWithFilterFunctionIncludedItemAndSetFilterFunctionToNull():void
		{
			this._collection.setItemAt(this._addedIncludedItem, 0);
			this._collection.filterFunction = null;
			Assert.assertStrictlyEquals("ListCollection filterFunction must maintain length if item passed to setItemAt() is included.",
				2, this._collection.length);
			Assert.assertTrue("ListCollection contains() must return true with filterFunction if item passed to setItemAt() is included.",
				this._collection.contains(this._addedIncludedItem));
			Assert.assertStrictlyEquals("ListCollection getItemIndex() must return correct index with filterFunction if item passed to setItemAt() is included.",
				0, this._collection.getItemIndex(this._addedIncludedItem));
		}

		[Test]
		public function testSetItemAtWithFilterFunctionExcludedItemAndSetFilterFunctionToNull():void
		{
			this._collection.setItemAt(this._addedExcludedItem, 0);
			this._collection.filterFunction = null;
			Assert.assertStrictlyEquals("ListCollection filterFunction must maintain length if item passed to setItemAt() is excluded after filterFunction is set to null.",
				2, this._collection.length);
			Assert.assertTrue("ListCollection contains() must return true with filterFunction if item passed to setItemAt() is excluded after filterFunction is set to null.",
				this._collection.contains(this._addedExcludedItem));
			Assert.assertStrictlyEquals("ListCollection getItemIndex() must return correct index with filterFunction if item passed to setItemAt() is excluded after filterFunction is set to null.",
				0, this._collection.getItemIndex(this._addedExcludedItem));
		}
	}
}
