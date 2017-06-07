package feathers.tests
{
	import feathers.data.XMLListHierarchicalCollection;
	import feathers.events.CollectionEventType;

	import org.flexunit.Assert;

	import starling.events.Event;

	public class XMLListHierarchicalCollectionTests
	{
		private var _collection:XMLListHierarchicalCollection;

		[Before]
		public function prepare():void
		{
			var data:XML = <items>
				<item label="1">
					<item label="1-A"/>
					<item label="1-B">
						<item label="1-B-I"/>
					</item>
					<item label="1-C"/>
				</item>
				<item label="2">
					<item label="2-A"/>
				</item>
				<item label="3"/>
				<item label="4">
					<item label="4-A"/>
					<item label="4-B"/>
				</item>
			</items>;
			this._collection = new XMLListHierarchicalCollection(data.item);
		}

		[After]
		public function cleanup():void
		{
			this._collection = null;
		}

		[Test]
		public function testGetLength():void
		{
			var length:int = this._collection.getLength();
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: getLengthAtLocation() returned incorrect length",
				4, length);
		}

		[Test]
		public function testGetLengthNested():void
		{
			var length:int = this._collection.getLength(3);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: getLengthAtLocation() returned incorrect length",
				2, length);
		}

		[Test]
		public function testGetLengthAtLocationWithNull():void
		{
			var length:int = this._collection.getLengthAtLocation();
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: getLengthAtLocation() returned incorrect length",
				4, length);
		}

		[Test]
		public function testGetItemAt():void
		{
			var item:XML = this._collection.getItemAt(1) as XML;
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: getItemAt() returned incorrect item",
				this._collection.xmlListData[1], item);
		}

		[Test]
		public function testGetItemAtNested():void
		{
			var item:XML = this._collection.getItemAt(0, 1) as XML;
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: getItemAt() returned incorrect item",
				this._collection.xmlListData[0].elements()[1], item);
		}

		[Test]
		public function testGetItemAtLocation():void
		{
			var indices:Vector.<int> = new <int>[1];
			var item:XML = this._collection.getItemAtLocation(indices) as XML;
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: getItemAtLocation() returned incorrect item",
				this._collection.xmlListData[1], item);
		}

		[Test]
		public function testGetItemAtNestedLocation():void
		{
			var indices:Vector.<int> = new <int>[0, 1];
			var item:XML = this._collection.getItemAtLocation(indices) as XML;
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: getItemAtLocation() returned incorrect item",
				this._collection.xmlListData[0].elements()[1], item);
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
			Assert.assertTrue("XMLListHierarchicalCollection: Event.CHANGE was not dispatched after removeAll()", hasChanged);
			Assert.assertFalse("XMLListHierarchicalCollection: CollectionEventType.RESET was incorrectly dispatched after removeAll()", hasReset);
			Assert.assertTrue("XMLListHierarchicalCollection: CollectionEventType.REMOVE_ALL was not dispatched after removeAll()", hasRemovedAll);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: the getLength() value was not changed to 0 after removeAll()",
				0, this._collection.getLength());
		}

		[Test]
		public function testRemoveItemAtLocation():void
		{
			var indicesToRemove:Vector.<int> = new <int>[1];
			var itemToRemove:XML = this._collection.getItemAtLocation(indicesToRemove) as XML;
			var originalLength:int = this._collection.getLength();
			var hasChanged:Boolean = false;
			this._collection.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			var hasRemovedItem:Boolean = false;
			var indicesFromEvent:Array = null;
			this._collection.addEventListener(CollectionEventType.REMOVE_ITEM, function(event:Event, indices:Array):void
			{
				hasRemovedItem = true;
				indicesFromEvent = indices;
			});
			this._collection.removeItemAtLocation(indicesToRemove);
			Assert.assertTrue("XMLListHierarchicalCollection: Event.CHANGE was not dispatched", hasChanged);
			Assert.assertTrue("XMLListHierarchicalCollection: CollectionEventType.REMOVE_ITEM was not dispatched", hasRemovedItem);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The getLength() value was not changed",
				originalLength - 1, this._collection.getLength());
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The item was not removed",
				0, this._collection.getItemLocation(itemToRemove).length);
			Assert.failNull("XMLListHierarchicalCollection: The CollectionEventType.REMOVE_ITEM event data was not the correct location (null)",
				indicesFromEvent);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The CollectionEventType.REMOVE_ITEM event data was not the correct location (length)",
				1, indicesFromEvent.length);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The CollectionEventType.REMOVE_ITEM event data was not the correct location (value)",
				indicesToRemove[0], indicesFromEvent[0]);
		}

		[Test]
		public function testRemoveItemAtNestedLocation():void
		{
			var indicesToRemove:Vector.<int> = new <int>[0, 1];
			var itemToRemove:XML = this._collection.getItemAtLocation(indicesToRemove) as XML;
			var originalParentLength:int = this._collection.getLength(indicesToRemove[0]);
			var hasChanged:Boolean = false;
			this._collection.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			var hasRemovedItem:Boolean = false;
			var indicesFromEvent:Array = null;
			this._collection.addEventListener(CollectionEventType.REMOVE_ITEM, function(event:Event, indices:Array):void
			{
				hasRemovedItem = true;
				indicesFromEvent = indices;
			});
			this._collection.removeItemAtLocation(indicesToRemove);
			Assert.assertTrue("XMLListHierarchicalCollection: Event.CHANGE was not dispatched", hasChanged);
			Assert.assertTrue("XMLListHierarchicalCollection: CollectionEventType.REMOVE_ITEM was not dispatched", hasRemovedItem);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The getLength() value was not changed",
				originalParentLength - 1, this._collection.getLength(indicesToRemove[0]));
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The item was not removed",
				0, this._collection.getItemLocation(itemToRemove).length);
			Assert.failNull("XMLListHierarchicalCollection: The CollectionEventType.REMOVE_ITEM event data was not the correct location (null)",
				indicesFromEvent);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The CollectionEventType.REMOVE_ITEM event data was not the correct location (length)",
				2, indicesFromEvent.length);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The CollectionEventType.REMOVE_ITEM event data was not the correct location (value)",
				indicesToRemove[0], indicesFromEvent[0]);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The CollectionEventType.REMOVE_ITEM event data was not the correct location (value)",
				indicesToRemove[1], indicesFromEvent[1]);
		}

		[Test]
		public function testRemoveItemAt():void
		{
			var itemToRemove:XML = this._collection.getItemAt(1) as XML;
			var originalLength:int = this._collection.getLength();
			var expectedIndex:int = 1;
			var hasChanged:Boolean = false;
			this._collection.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			var hasRemovedItem:Boolean = false;
			var indicesFromEvent:Array = null;
			this._collection.addEventListener(CollectionEventType.REMOVE_ITEM, function(event:Event, indices:Array):void
			{
				hasRemovedItem = true;
				indicesFromEvent = indices;
			});
			this._collection.removeItemAt(expectedIndex);
			Assert.assertTrue("XMLListHierarchicalCollection: Event.CHANGE was not dispatched", hasChanged);
			Assert.assertTrue("XMLListHierarchicalCollection: CollectionEventType.REMOVE_ITEM was not dispatched", hasRemovedItem);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The getLength() value was not changed",
				originalLength - 1, this._collection.getLength());
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The item was not removed",
				0, this._collection.getItemLocation(itemToRemove).length);
			Assert.failNull("XMLListHierarchicalCollection: The CollectionEventType.REMOVE_ITEM event data was not the correct location (null)",
				indicesFromEvent);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The CollectionEventType.REMOVE_ITEM event data was not the correct location (length)",
				1, indicesFromEvent.length);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The CollectionEventType.REMOVE_ITEM event data was not the correct location (value)",
				1, indicesFromEvent[0]);
		}

		[Test]
		public function testRemoveItem():void
		{
			var expectedIndex:int = 1;
			var itemToRemove:XML = this._collection.getItemAt(expectedIndex) as XML;
			var originalLength:int = this._collection.getLength();
			var hasChanged:Boolean = false;
			this._collection.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			var hasRemovedItem:Boolean = false;
			var indicesFromEvent:Array = null;
			this._collection.addEventListener(CollectionEventType.REMOVE_ITEM, function(event:Event, indices:Array):void
			{
				hasRemovedItem = true;
				indicesFromEvent = indices;
			});
			this._collection.removeItem(itemToRemove);
			Assert.assertTrue("XMLListHierarchicalCollection: Event.CHANGE was not dispatched", hasChanged);
			Assert.assertTrue("XMLListHierarchicalCollection: CollectionEventType.REMOVE_ITEM was not dispatched", hasRemovedItem);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The getLength() value was not changed",
				originalLength - 1, this._collection.getLength());
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The item was not removed",
				0, this._collection.getItemLocation(itemToRemove).length);
			Assert.failNull("XMLListHierarchicalCollection: The CollectionEventType.REMOVE_ITEM event data was not the correct location (null)",
				indicesFromEvent);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The CollectionEventType.REMOVE_ITEM event data was not the correct location (length)",
				1, indicesFromEvent.length);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The CollectionEventType.REMOVE_ITEM event data was not the correct location (value)",
				1, indicesFromEvent[0]);
		}

		[Test]
		public function testAddItemAtLocation():void
		{
			var location:Vector.<int> = new <int>[1];
			var itemToAdd:XML = <item label="New Item"/>;
			var originalLength:int = this._collection.getLength();
			var hasChanged:Boolean = false;
			this._collection.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			var hasAddedItem:Boolean = false;
			var indicesFromEvent:Array = null;
			this._collection.addEventListener(CollectionEventType.ADD_ITEM, function(event:Event, indices:Array):void
			{
				hasAddedItem = true;
				indicesFromEvent = indices;
			});
			this._collection.addItemAtLocation(itemToAdd, location);
			Assert.assertTrue("XMLListHierarchicalCollection: Event.CHANGE was not dispatched", hasChanged);
			Assert.assertTrue("XMLListHierarchicalCollection: CollectionEventType.ADD_ITEM was not dispatched", hasAddedItem);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The getLength() value was not changed",
				originalLength + 1, this._collection.getLength());
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The item was not added",
				1, this._collection.getItemLocation(itemToAdd).length);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The item was not added at the correct index",
				location[0], this._collection.getItemLocation(itemToAdd)[0]);
			Assert.failNull("XMLListHierarchicalCollection: The CollectionEventType.ADD_ITEM event data was not the correct location (null)",
				indicesFromEvent);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The CollectionEventType.ADD_ITEM event data was not the correct location (length)",
				1, indicesFromEvent.length);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The CollectionEventType.ADD_ITEM event data was not the correct location (value)",
				location[0], indicesFromEvent[0]);
		}

		[Test]
		public function testAddItemAtNestedLocation():void
		{
			var location:Vector.<int> = new <int>[0, 1];
			var itemToAdd:XML = <item label="New Item"/>;
			var originalParentLength:int = this._collection.getLength(location[0]);
			var hasChanged:Boolean = false;
			this._collection.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			var hasAddedItem:Boolean = false;
			var indicesFromEvent:Array = null;
			this._collection.addEventListener(CollectionEventType.ADD_ITEM, function(event:Event, indices:Array):void
			{
				hasAddedItem = true;
				indicesFromEvent = indices;
			});
			this._collection.addItemAtLocation(itemToAdd, location);
			Assert.assertTrue("XMLListHierarchicalCollection: Event.CHANGE was not dispatched", hasChanged);
			Assert.assertTrue("XMLListHierarchicalCollection: CollectionEventType.ADD_ITEM was not dispatched", hasAddedItem);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The getLength() value was not changed",
				originalParentLength + 1, this._collection.getLength(location[0]));
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The item was not added",
				2, this._collection.getItemLocation(itemToAdd).length);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The item was not added at the correct index",
				location[0], this._collection.getItemLocation(itemToAdd)[0]);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The item was not added at the correct index",
				location[1], this._collection.getItemLocation(itemToAdd)[1]);
			Assert.failNull("XMLListHierarchicalCollection: The CollectionEventType.ADD_ITEM event data was not the correct location (null)",
				indicesFromEvent);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The CollectionEventType.ADD_ITEM event data was not the correct location (length)",
				2, indicesFromEvent.length);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The CollectionEventType.ADD_ITEM event data was not the correct location (value)",
				location[0], indicesFromEvent[0]);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The CollectionEventType.ADD_ITEM event data was not the correct location (value)",
				location[1], indicesFromEvent[1]);
		}

		[Test]
		public function testAddItemAt():void
		{
			var itemToAdd:XML = <item label="New Item"/>;
			var expectedIndex:int = 1;
			var originalLength:int = this._collection.getLength();
			var hasChanged:Boolean = false;
			this._collection.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			var hasAddedItem:Boolean = false;
			var indicesFromEvent:Array = null;
			this._collection.addEventListener(CollectionEventType.ADD_ITEM, function(event:Event, indices:Array):void
			{
				hasAddedItem = true;
				indicesFromEvent = indices;
			});
			this._collection.addItemAt(itemToAdd, expectedIndex);
			Assert.assertTrue("XMLListHierarchicalCollection: Event.CHANGE was not dispatched", hasChanged);
			Assert.assertTrue("XMLListHierarchicalCollection: CollectionEventType.ADD_ITEM was not dispatched", hasAddedItem);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The getLength() value was not changed",
				originalLength + 1, this._collection.getLength());
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The item was not added",
				1, this._collection.getItemLocation(itemToAdd).length);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The item was not added at the correct index",
				expectedIndex, this._collection.getItemLocation(itemToAdd)[0]);
			Assert.failNull("XMLListHierarchicalCollection: The CollectionEventType.ADD_ITEM event data was not the correct location (null)",
				indicesFromEvent);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The CollectionEventType.ADD_ITEM event data was not the correct location (length)",
				1, indicesFromEvent.length);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The CollectionEventType.ADD_ITEM event data was not the correct location (value)",
				1, indicesFromEvent[0]);
		}

		[Test]
		public function testAddItemAtNested():void
		{
			var itemToAdd:XML = <item label="New Item"/>;
			var originalParentLength:int = this._collection.getLength(0);
			var hasChanged:Boolean = false;
			this._collection.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			var hasAddedItem:Boolean = false;
			var indicesFromEvent:Array = null;
			this._collection.addEventListener(CollectionEventType.ADD_ITEM, function(event:Event, indices:Array):void
			{
				hasAddedItem = true;
				indicesFromEvent = indices;
			});
			this._collection.addItemAt(itemToAdd, 0, 1);
			Assert.assertTrue("XMLListHierarchicalCollection: Event.CHANGE was not dispatched", hasChanged);
			Assert.assertTrue("XMLListHierarchicalCollection: CollectionEventType.ADD_ITEM was not dispatched", hasAddedItem);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The getLength() value was not changed",
				originalParentLength + 1, this._collection.getLength(0));
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The item was not added",
				2, this._collection.getItemLocation(itemToAdd).length);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The item was not added at the correct index",
				0, this._collection.getItemLocation(itemToAdd)[0]);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The item was not added at the correct index",
				1, this._collection.getItemLocation(itemToAdd)[1]);
			Assert.failNull("XMLListHierarchicalCollection: The CollectionEventType.ADD_ITEM event data was not the correct location (null)",
				indicesFromEvent);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The CollectionEventType.ADD_ITEM event data was not the correct location (length)",
				2, indicesFromEvent.length);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The CollectionEventType.ADD_ITEM event data was not the correct location (value)",
				0, indicesFromEvent[0]);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The CollectionEventType.ADD_ITEM event data was not the correct location (value)",
				1, indicesFromEvent[1]);
		}

		[Test]
		public function testSetItemAt():void
		{
			var itemToAdd:XML = <item label="New Item"/>;
			var expectedIndex:int = 1;
			var originalLength:int = this._collection.getLength();
			var hasChanged:Boolean = false;
			this._collection.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			var hasReplacedItem:Boolean = false;
			var indicesFromEvent:Array = null;
			this._collection.addEventListener(CollectionEventType.REPLACE_ITEM, function(event:Event, indices:Array):void
			{
				hasReplacedItem = true;
				indicesFromEvent = indices;
			});
			this._collection.setItemAt(itemToAdd, expectedIndex);
			Assert.assertTrue("XMLListHierarchicalCollection: Event.CHANGE was not dispatched", hasChanged);
			Assert.assertTrue("XMLListHierarchicalCollection: CollectionEventType.REPLACE_ITEM was not dispatched", hasReplacedItem);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The length property was incorrectly changed",
				originalLength, this._collection.getLength());
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The item was not replaced",
				1, this._collection.getItemLocation(itemToAdd).length);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The item was not replaced at the correct index",
				expectedIndex, this._collection.getItemLocation(itemToAdd)[0]);
			Assert.failNull("XMLListHierarchicalCollection: The CollectionEventType.REPLACE_ITEM event data was not the correct location (null)",
				indicesFromEvent);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The CollectionEventType.REPLACE_ITEM event data was not the correct location (length)",
				1, indicesFromEvent.length);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The CollectionEventType.REPLACE_ITEM event data was not the correct location (value)",
				1, indicesFromEvent[0]);
		}

		[Test]
		public function testSetItemAtNested():void
		{
			var itemToAdd:XML = <item label="New Item"/>;
			var originalParentLength:int = this._collection.getLength(0);
			var hasChanged:Boolean = false;
			this._collection.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			var hasReplacedItem:Boolean = false;
			var indicesFromEvent:Array = null;
			this._collection.addEventListener(CollectionEventType.REPLACE_ITEM, function(event:Event, indices:Array):void
			{
				hasReplacedItem = true;
				indicesFromEvent = indices;
			});
			this._collection.setItemAt(itemToAdd, 0, 1);
			Assert.assertTrue("XMLListHierarchicalCollection: Event.CHANGE was not dispatched", hasChanged);
			Assert.assertTrue("XMLListHierarchicalCollection: CollectionEventType.REPLACE_ITEM was not dispatched", hasReplacedItem);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The length property was incorrectly changed",
				originalParentLength, this._collection.getLength(0));
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The item was not replaced",
				2, this._collection.getItemLocation(itemToAdd).length);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The item was not replaced at the correct index",
				0, this._collection.getItemLocation(itemToAdd)[0]);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The item was not replaced at the correct index",
				1, this._collection.getItemLocation(itemToAdd)[1]);
			Assert.failNull("XMLListHierarchicalCollection: The CollectionEventType.REPLACE_ITEM event data was not the correct location (null)",
				indicesFromEvent);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The CollectionEventType.REPLACE_ITEM event data was not the correct location (length)",
				2, indicesFromEvent.length);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The CollectionEventType.REPLACE_ITEM event data was not the correct location (value)",
				0, indicesFromEvent[0]);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The CollectionEventType.REPLACE_ITEM event data was not the correct location (value)",
				1, indicesFromEvent[1]);
		}

		[Test]
		public function testSetItemAtLocation():void
		{
			var itemToAdd:XML = <item label="New Item"/>;
			var location:Vector.<int> = new <int>[1];
			var originalLength:int = this._collection.getLength();
			var hasChanged:Boolean = false;
			this._collection.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			var hasReplacedItem:Boolean = false;
			var indicesFromEvent:Array = null;
			this._collection.addEventListener(CollectionEventType.REPLACE_ITEM, function(event:Event, indices:Array):void
			{
				hasReplacedItem = true;
				indicesFromEvent = indices;
			});
			this._collection.setItemAtLocation(itemToAdd, location);
			Assert.assertTrue("XMLListHierarchicalCollection: Event.CHANGE was not dispatched", hasChanged);
			Assert.assertTrue("XMLListHierarchicalCollection: CollectionEventType.REPLACE_ITEM was not dispatched", hasReplacedItem);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The length property was incorrectly changed",
				originalLength, this._collection.getLength());
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The item was not replaced",
				1, this._collection.getItemLocation(itemToAdd).length);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The item was not replaced at the correct index",
				location[0], this._collection.getItemLocation(itemToAdd)[0]);
			Assert.failNull("XMLListHierarchicalCollection: The CollectionEventType.REPLACE_ITEM event data was not the correct location (null)",
				indicesFromEvent);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The CollectionEventType.REPLACE_ITEM event data was not the correct location (length)",
				1, indicesFromEvent.length);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The CollectionEventType.REPLACE_ITEM event data was not the correct location (value)",
				location[0], indicesFromEvent[0]);
		}

		[Test]
		public function testSetItemAtNestedLocation():void
		{
			var itemToAdd:XML = <item label="New Item"/>;
			var location:Vector.<int> = new <int>[0, 1];
			var originalParentLength:int = this._collection.getLength(location[0]);
			var hasChanged:Boolean = false;
			this._collection.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			var hasReplacedItem:Boolean = false;
			var indicesFromEvent:Array = null;
			this._collection.addEventListener(CollectionEventType.REPLACE_ITEM, function(event:Event, indices:Array):void
			{
				hasReplacedItem = true;
				indicesFromEvent = indices;
			});
			this._collection.setItemAtLocation(itemToAdd, location);
			Assert.assertTrue("XMLListHierarchicalCollection: Event.CHANGE was not dispatched", hasChanged);
			Assert.assertTrue("XMLListHierarchicalCollection: CollectionEventType.REPLACE_ITEM was not dispatched", hasReplacedItem);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The length property was incorrectly changed",
				originalParentLength, this._collection.getLength(location[0]));
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The item was not replaced",
				2, this._collection.getItemLocation(itemToAdd).length);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The item was not replaced at the correct index",
				location[0], this._collection.getItemLocation(itemToAdd)[0]);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The item was not replaced at the correct index",
				location[1], this._collection.getItemLocation(itemToAdd)[1]);
			Assert.failNull("XMLListHierarchicalCollection: The CollectionEventType.REPLACE_ITEM event data was not the correct location (null)",
				indicesFromEvent);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The CollectionEventType.REPLACE_ITEM event data was not the correct location (length)",
				2, indicesFromEvent.length);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The CollectionEventType.REPLACE_ITEM event data was not the correct location (value)",
				location[0], indicesFromEvent[0]);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: The CollectionEventType.REPLACE_ITEM event data was not the correct location (value)",
				location[1], indicesFromEvent[1]);
		}

		[Test]
		public function testGetItemLocationWithItemInCollection():void
		{
			var expectedIndex:int = 1;
			var item:XML = this._collection.getItemAt(expectedIndex) as XML;
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: getItemLocation() returned the incorrect location (length)",
				1, this._collection.getItemLocation(item).length);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: getItemLocation() returned the incorrect location (value)",
				expectedIndex, this._collection.getItemLocation(item)[0]);
		}

		[Test]
		public function testGetItemLocationNestedWithItemInCollection():void
		{
			var location:Vector.<int> = new <int>[0, 1];
			var item:XML = this._collection.getItemAtLocation(location) as XML;
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: getItemLocation() returned the incorrect location (length)",
				location.length, this._collection.getItemLocation(item).length);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: getItemLocation() returned the incorrect location (value)",
				location[0], this._collection.getItemLocation(item)[0]);
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: getItemLocation() returned the incorrect location (value)",
				location[1], this._collection.getItemLocation(item)[1]);
		}

		[Test]
		public function testGetItemLocationWithItemNotInCollection():void
		{
			var item:XML = <notincollection/>;
			Assert.assertStrictlyEquals("XMLListHierarchicalCollection: getItemLocation() returned the incorrect location (length)",
				0, this._collection.getItemLocation(item).length);
		}
	}
}