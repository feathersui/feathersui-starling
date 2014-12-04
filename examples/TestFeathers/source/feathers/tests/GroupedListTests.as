package feathers.tests
{
	import feathers.controls.GroupedList;
	import feathers.controls.renderers.DefaultGroupedListHeaderOrFooterRenderer;
	import feathers.controls.renderers.DefaultGroupedListItemRenderer;
	import feathers.data.HierarchicalCollection;

	import flash.geom.Point;

	import org.flexunit.Assert;

	import starling.display.DisplayObject;

	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class GroupedListTests
	{
		private var _list:GroupedList;

		[Before]
		public function prepare():void
		{
			this._list = new GroupedList();
			this._list.dataProvider = new HierarchicalCollection(
			[
				{
					header: { label: "A" },
					children:
					[
						{label: "One"},
						{label: "Two"},
						{label: "Three"},
					]
				},
				{
					header: { label: "B" },
					children:
					[
						{label: "Four"},
						{label: "Five"},
						{label: "Six"},
					]
				}
			]);
			this._list.itemRendererFactory = function():DefaultGroupedListItemRenderer
			{
				var itemRenderer:DefaultGroupedListItemRenderer = new DefaultGroupedListItemRenderer();
				itemRenderer.defaultSkin = new Quad(200, 200);
				return itemRenderer;
			};
			this._list.headerRendererFactory = function():DefaultGroupedListHeaderOrFooterRenderer
			{
				var headerRenderer:DefaultGroupedListHeaderOrFooterRenderer = new DefaultGroupedListHeaderOrFooterRenderer();
				headerRenderer.backgroundSkin = new Quad(200, 200);
				return headerRenderer;
			};
			TestFeathers.starlingRoot.addChild(this._list);
			this._list.validate();
		}

		[After]
		public function cleanup():void
		{
			this._list.removeFromParent(true);
			this._list = null;
		}

		[Test]
		public function testProgrammaticSelectionChange():void
		{
			var beforeSelectedGroupIndex:int = this._list.selectedGroupIndex;
			var beforeSelectedItemIndex:int = this._list.selectedItemIndex;
			var beforeSelectedItem:Object = this._list.selectedItem;
			var hasChanged:Boolean = false;
			this._list.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._list.setSelectedLocation(0, 1);
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertFalse("The selectedGroupIndex property was not changed",
				beforeSelectedGroupIndex === this._list.selectedGroupIndex);
			Assert.assertFalse("The selectedItemIndex property was not changed",
				beforeSelectedItemIndex === this._list.selectedItemIndex);
			Assert.assertFalse("The selectedItem property was not changed",
				beforeSelectedItem === this._list.selectedItem);
		}

		[Test]
		public function testInteractiveSelectionChange():void
		{
			var beforeSelectedGroupIndex:int = this._list.selectedGroupIndex;
			var beforeSelectedItemIndex:int = this._list.selectedItemIndex;
			var hasChanged:Boolean = false;
			this._list.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			var position:Point = new Point(10, 410);
			var target:DisplayObject = this._list.stage.hitTest(position, true);
			var touch:Touch = new Touch(0);
			touch.target = target;
			touch.phase = TouchPhase.BEGAN;
			touch.globalX = position.x;
			touch.globalY = position.y;
			var touches:Vector.<Touch> = new <Touch>[touch];
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			//this touch does not move at all, so it should result in triggering
			//the button.
			touch.phase = TouchPhase.ENDED;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertFalse("The selectedGroupIndex property was not changed",
				beforeSelectedGroupIndex === this._list.selectedGroupIndex);
			Assert.assertFalse("The selectedItemIndex property was not changed",
				beforeSelectedItemIndex === this._list.selectedItemIndex);
		}

		[Test]
		public function testRemoveItemBeforeSelectedItemIndex():void
		{
			this._list.setSelectedLocation(1, 1);
			var beforeSelectedGroupIndex:int = this._list.selectedGroupIndex;
			var beforeSelectedItemIndex:int = this._list.selectedItemIndex;
			var beforeSelectedItem:Object = this._list.selectedItem;
			var hasChanged:Boolean = false;
			this._list.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._list.dataProvider.removeItemAt(1, 0);
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertStrictlyEquals("The selectedGroupIndex property was incorrectly changed",
				beforeSelectedGroupIndex, this._list.selectedGroupIndex);
			Assert.assertFalse("The selectedItemIndex property was not changed",
				beforeSelectedItemIndex === this._list.selectedItemIndex);
			Assert.assertStrictlyEquals("The selectedItem property was incorrectly changed",
				beforeSelectedItem, this._list.selectedItem);
		}

		[Test]
		public function testRemoveItemAfterSelectedItemIndex():void
		{
			this._list.setSelectedLocation(1, 1);
			var beforeSelectedGroupIndex:int = this._list.selectedGroupIndex;
			var beforeSelectedItemIndex:int = this._list.selectedItemIndex;
			var beforeSelectedItem:Object = this._list.selectedItem;
			var hasChanged:Boolean = false;
			this._list.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._list.dataProvider.removeItemAt(1, 2);
			Assert.assertFalse("Event.CHANGE was incorrectly dispatched", hasChanged);
			Assert.assertStrictlyEquals("The selectedGroupIndex property was incorrectly changed",
				beforeSelectedGroupIndex, this._list.selectedGroupIndex);
			Assert.assertStrictlyEquals("The selectedItemIndex property was incorrectly changed",
				beforeSelectedItemIndex, this._list.selectedItemIndex);
			Assert.assertStrictlyEquals("The selectedItem property was incorrectly changed",
				beforeSelectedItem, this._list.selectedItem);
		}

		[Test]
		public function testRemoveSelectedItemIndex():void
		{
			this._list.setSelectedLocation(1, 1);
			var hasChanged:Boolean = false;
			this._list.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._list.dataProvider.removeItemAt(1, 1);
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertStrictlyEquals("The selectedIndex property was not changed to -1",
				-1, this._list.selectedGroupIndex);
			Assert.assertStrictlyEquals("The selectedIndex property was not changed to -1",
				-1, this._list.selectedItemIndex);
			Assert.assertStrictlyEquals("The selectedItem property was not changed to null",
				null, this._list.selectedItem);
		}

		[Test]
		public function testReplaceItemAtSelectedItemIndex():void
		{
			this._list.setSelectedLocation(1, 1);
			var beforeSelectedGroupIndex:int = this._list.selectedGroupIndex;
			var beforeSelectedItemIndex:int = this._list.selectedItemIndex;
			var hasChanged:Boolean = false;
			this._list.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._list.dataProvider.setItemAt({ label: "New Item" }, beforeSelectedGroupIndex, beforeSelectedItemIndex);
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertStrictlyEquals("The selectedGroupIndex property was not changed to -1",
				-1, this._list.selectedGroupIndex);
			Assert.assertStrictlyEquals("The selectedItemIndex property was not changed to -1",
				-1, this._list.selectedItemIndex);
			Assert.assertStrictlyEquals("The selectedItem property was not changed to null",
				null, this._list.selectedItem);
		}

		[Test]
		public function testDeselectAllOnNullDataProvider():void
		{
			this._list.setSelectedLocation(1, 1);
			var hasChanged:Boolean = false;
			this._list.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._list.dataProvider = null;
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertStrictlyEquals("The selectedGroupIndex property was not set to -1",
				-1, this._list.selectedGroupIndex);
			Assert.assertStrictlyEquals("The selectedItemIndex property was not set to -1",
				-1, this._list.selectedItemIndex);
			Assert.assertStrictlyEquals("The selectedItem property was not set to null",
				null, this._list.selectedItem);
		}

		[Test]
		public function testDeselectAllOnDataProviderRemoveAll():void
		{
			this._list.setSelectedLocation(1, 1);
			var hasChanged:Boolean = false;
			this._list.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._list.dataProvider.removeAll();
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertStrictlyEquals("The selectedGroupIndex property was not set to -1",
				-1, this._list.selectedGroupIndex);
			Assert.assertStrictlyEquals("The selectedItemIndex property was not set to -1",
				-1, this._list.selectedItemIndex);
			Assert.assertStrictlyEquals("The selectedItem property was not set to null",
				null, this._list.selectedItem);
		}

		[Test]
		public function testAddItemBeforeSelectedItemIndex():void
		{
			this._list.setSelectedLocation(1, 1);
			var hasChanged:Boolean = false;
			var beforeSelectedGroupIndex:int = this._list.selectedGroupIndex;
			var beforeSelectedItemIndex:int = this._list.selectedItemIndex;
			var beforeSelectedItem:Object = this._list.selectedItem;
			this._list.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._list.dataProvider.addItemAt({label: "New Item"}, 1, 0);
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertStrictlyEquals("The selectedGroupIndex property was incorrectly changed",
				beforeSelectedGroupIndex, this._list.selectedGroupIndex);
			Assert.assertFalse("The selectedItemIndex property was not changed",
				beforeSelectedItemIndex === this._list.selectedItemIndex);
			Assert.assertStrictlyEquals("The selectedItem property was incorrectly changed",
				beforeSelectedItem, this._list.selectedItem);
		}

		[Test]
		public function testAddGroupBeforeSelectedGroupIndex():void
		{
			this._list.setSelectedLocation(1, 1);
			var hasChanged:Boolean = false;
			var beforeSelectedGroupIndex:int = this._list.selectedGroupIndex;
			var beforeSelectedItemIndex:int = this._list.selectedItemIndex;
			var beforeSelectedItem:Object = this._list.selectedItem;
			this._list.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._list.dataProvider.addItemAt(
			{
				header: "New Group",
				children:
				[
					{ label: "New Item 1" },
					{ label: "New Item 2" },
				]
			}, 0);
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertFalse("The selectedGroupIndex property was not changed",
				beforeSelectedGroupIndex === this._list.selectedGroupIndex);
			Assert.assertStrictlyEquals("The selectedItemIndex property was incorrectly changed",
				beforeSelectedItemIndex, this._list.selectedItemIndex);
			Assert.assertStrictlyEquals("The selectedItem property was incorrectly changed",
				beforeSelectedItem, this._list.selectedItem);
		}

		[Test]
		public function testRemoveGroupBeforeSelectedGroupIndex():void
		{
			this._list.setSelectedLocation(1, 1);
			var beforeSelectedGroupIndex:int = this._list.selectedGroupIndex;
			var beforeSelectedItemIndex:int = this._list.selectedItemIndex;
			var beforeSelectedItem:Object = this._list.selectedItem;
			var hasChanged:Boolean = false;
			this._list.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._list.dataProvider.removeItemAt(0);
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertFalse("The selectedGroupIndex property was not changed",
				beforeSelectedGroupIndex === this._list.selectedGroupIndex);
			Assert.assertStrictlyEquals("The selectedItemIndex property was incorrectly changed",
				beforeSelectedItemIndex, this._list.selectedItemIndex);
			Assert.assertStrictlyEquals("The selectedItem property was incorrectly changed",
				beforeSelectedItem, this._list.selectedItem);
		}

		[Test]
		public function testRemoveGroupAfterSelectedGroupIndex():void
		{
			this._list.setSelectedLocation(1, 1);
			var beforeSelectedGroupIndex:int = this._list.selectedGroupIndex;
			var beforeSelectedItemIndex:int = this._list.selectedItemIndex;
			var beforeSelectedItem:Object = this._list.selectedItem;
			var hasChanged:Boolean = false;
			this._list.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._list.dataProvider.removeItemAt(2);
			Assert.assertFalse("Event.CHANGE was incorrectly dispatched", hasChanged);
			Assert.assertStrictlyEquals("The selectedGroupIndex property was incorrectly changed",
				beforeSelectedGroupIndex, this._list.selectedGroupIndex);
			Assert.assertStrictlyEquals("The selectedItemIndex property was incorrectly changed",
				beforeSelectedItemIndex, this._list.selectedItemIndex);
			Assert.assertStrictlyEquals("The selectedItem property was incorrectly changed",
				beforeSelectedItem, this._list.selectedItem);
		}

		[Test]
		public function testRemoveGroupAtSelectedGroupIndex():void
		{
			this._list.setSelectedLocation(1, 1);
			var hasChanged:Boolean = false;
			this._list.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._list.dataProvider.removeItemAt(1);
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertStrictlyEquals("The selectedIndex property was not changed to -1",
				-1, this._list.selectedGroupIndex);
			Assert.assertStrictlyEquals("The selectedIndex property was not changed to -1",
				-1, this._list.selectedItemIndex);
			Assert.assertStrictlyEquals("The selectedItem property was not changed to null",
				null, this._list.selectedItem);
		}

		[Test]
		public function testReplaceGroupAtSelectedGroupIndex():void
		{
			this._list.setSelectedLocation(1, 1);
			var beforeSelectedGroupIndex:int = this._list.selectedGroupIndex;
			var hasChanged:Boolean = false;
			this._list.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._list.dataProvider.setItemAt(
			{
				header: "New Group",
				children:
				[
					{ label: "New Item 1" },
					{ label: "New Item 2" },
				]
			}, beforeSelectedGroupIndex);
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertStrictlyEquals("The selectedGroupIndex property was not changed to -1",
				-1, this._list.selectedGroupIndex);
			Assert.assertStrictlyEquals("The selectedItemIndex property was not changed to -1",
				-1, this._list.selectedItemIndex);
			Assert.assertStrictlyEquals("The selectedItem property was not changed to null",
				null, this._list.selectedItem);
		}
	}
}
