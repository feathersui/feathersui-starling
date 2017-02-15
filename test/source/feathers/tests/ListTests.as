package feathers.tests
{
	import feathers.controls.List;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.tests.supportClasses.AssertViewPortBoundsLayout;

	import flash.geom.Point;

	import org.flexunit.Assert;

	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class ListTests
	{
		private var _list:List;

		[Before]
		public function prepare():void
		{
			this._list = new List();
			this._list.dataProvider = new ListCollection(
			[
				{ label: "One" },
				{ label: "Two" },
				{ label: "Three" },
				{ label: "Four" },
			]);
			this._list.itemRendererFactory = function():DefaultListItemRenderer
			{
				var itemRenderer:DefaultListItemRenderer = new DefaultListItemRenderer();
				itemRenderer.defaultSkin = new Quad(200, 200);
				return itemRenderer;
			};
			TestFeathers.starlingRoot.addChild(this._list);
			this._list.validate();
		}

		[After]
		public function cleanup():void
		{
			this._list.removeFromParent(true);
			this._list = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testNullDataProvider():void
		{
			this._list.dataProvider = null;
			this._list.validate();
		}

		[Test]
		public function testNullDataProviderWithTypicalItem():void
		{
			this._list.dataProvider = null;
			this._list.typicalItem = { label: "Typical Item" };
			this._list.validate();
		}

		[Test]
		public function testProgrammaticSelectionChange():void
		{
			var beforeSelectedIndex:int = this._list.selectedIndex;
			var beforeSelectedItem:Object = this._list.selectedItem;
			var hasChanged:Boolean = false;
			this._list.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._list.selectedIndex = 1;
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertFalse("The selectedIndex property was not changed",
				beforeSelectedIndex === this._list.selectedIndex);
			Assert.assertFalse("The selectedItem property was not changed",
				beforeSelectedItem === this._list.selectedItem);
		}

		[Test]
		public function testInteractiveSelectionChange():void
		{
			var beforeSelectedIndex:int = this._list.selectedIndex;
			var hasChanged:Boolean = false;
			this._list.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			var position:Point = new Point(10, 210);
			var target:DisplayObject = this._list.stage.hitTest(position);
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
			Assert.assertFalse("The selectedIndex property was not changed",
				beforeSelectedIndex === this._list.selectedIndex);
		}

		[Test]
		public function testRemoveItemBeforeSelectedIndex():void
		{
			this._list.selectedIndex = 1;
			var beforeSelectedIndex:int = this._list.selectedIndex;
			var beforeSelectedItem:Object = this._list.selectedItem;
			var hasChanged:Boolean = false;
			this._list.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._list.dataProvider.removeItemAt(0);
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertStrictlyEquals("The selectedIndex property was not changed",
				beforeSelectedIndex - 1, this._list.selectedIndex);
			Assert.assertStrictlyEquals("The selectedItem property was incorrectly changed",
				beforeSelectedItem, this._list.selectedItem);
		}

		[Test]
		public function testRemoveItemAfterSelectedIndex():void
		{
			this._list.selectedIndex = 1;
			var beforeSelectedIndex:int = this._list.selectedIndex;
			var beforeSelectedItem:Object = this._list.selectedItem;
			var hasChanged:Boolean = false;
			this._list.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._list.dataProvider.removeItemAt(2);
			Assert.assertFalse("Event.CHANGE was incorrectly dispatched", hasChanged);
			Assert.assertStrictlyEquals("The selectedIndex property was incorrectly changed",
				beforeSelectedIndex, this._list.selectedIndex);
			Assert.assertStrictlyEquals("The selectedItem property was incorrectly changed",
				beforeSelectedItem, this._list.selectedItem);
		}

		[Test]
		public function testRemoveSelectedIndex():void
		{
			this._list.selectedIndex = 1;
			var hasChanged:Boolean = false;
			this._list.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._list.dataProvider.removeItemAt(1);
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertStrictlyEquals("The selectedIndex property was not changed to -1",
				-1, this._list.selectedIndex);
			Assert.assertStrictlyEquals("The selectedItem property was not changed to null",
				null, this._list.selectedItem);
		}

		[Test]
		public function testReplaceItemAtSelectedIndex():void
		{
			this._list.selectedIndex = 1;
			var beforeSelectedIndex:int = this._list.selectedIndex;
			var hasChanged:Boolean = false;
			this._list.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._list.dataProvider.setItemAt({ label: "New Item" }, beforeSelectedIndex);
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertStrictlyEquals("The selectedIndex property was not changed to -1",
				-1, this._list.selectedIndex);
			Assert.assertStrictlyEquals("The selectedItem property was not changed to null",
				null, this._list.selectedItem);
		}

		[Test]
		public function testDeselectAllOnNullDataProvider():void
		{
			this._list.selectedIndex = 1;
			var hasChanged:Boolean = false;
			this._list.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._list.dataProvider = null;
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertStrictlyEquals("The selectedIndex property was not set to -1",
				-1, this._list.selectedIndex);
			Assert.assertStrictlyEquals("The selectedItem property was not set to null",
				null, this._list.selectedItem);
		}

		[Test]
		public function testDeselectAllOnDataProviderRemoveAll():void
		{
			this._list.selectedIndex = 1;
			var hasChanged:Boolean = false;
			this._list.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._list.dataProvider.removeAll();
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertStrictlyEquals("The selectedIndex property was not set to -1",
				-1, this._list.selectedIndex);
			Assert.assertStrictlyEquals("The selectedItem property was not set to null",
				null, this._list.selectedItem);
		}

		[Test]
		public function testAddItemBeforeSelectedIndex():void
		{
			this._list.selectedIndex = 1;
			var hasChanged:Boolean = false;
			var beforeSelectedIndex:int = this._list.selectedIndex;
			var beforeSelectedItem:Object = this._list.selectedItem;
			this._list.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._list.dataProvider.addItemAt({label: "New Item"}, 0);
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertStrictlyEquals("The selectedIndex property was not changed",
				beforeSelectedIndex + 1, this._list.selectedIndex);
			Assert.assertStrictlyEquals("The selectedItem property was incorrectly changed",
				beforeSelectedItem, this._list.selectedItem);
		}

		[Test]
		public function testFilterSelectedIndex():void
		{
			this._list.selectedIndex = 1;
			var hasChanged:Boolean = false;
			this._list.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			var selectedItem:Object = this._list.dataProvider.getItemAt(1);
			this._list.dataProvider.filterFunction = function(item:Object):Boolean
			{
				return item !== selectedItem;
			};
			Assert.assertTrue("Event.CHANGE must be dispatched when item is filtered", hasChanged);
			Assert.assertStrictlyEquals("The selectedIndex property was not changed to -1 when selected item is filtered",
				-1, this._list.selectedIndex);
			Assert.assertStrictlyEquals("The selectedItem property was not changed to null when selected item is filtered",
				null, this._list.selectedItem);
		}

		[Test]
		public function testDisposeWithoutChangeEvent():void
		{
			this._list.selectedIndex = 1;
			var hasChanged:Boolean = false;
			this._list.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._list.dispose();
			Assert.assertFalse("Event.CHANGE was incorrectly dispatched", hasChanged);
		}

		[Test]
		public function testItemToItemRenderer():void
		{
			this._list.height = 20;
			this._list.validate();
			var item0:Object = this._list.dataProvider.getItemAt(0);
			var itemRenderer0:IListItemRenderer = this._list.itemToItemRenderer(item0);
			var item1:Object = this._list.dataProvider.getItemAt(1);
			var itemRenderer1:IListItemRenderer = this._list.itemToItemRenderer(item1);
			var item3:Object = this._list.dataProvider.getItemAt(3);
			var itemRenderer3:IListItemRenderer = this._list.itemToItemRenderer(item3);
			Assert.assertNotNull("itemToItemRenderer() incorrectly returned null for item that should have an item renderer", itemRenderer0);
			Assert.assertStrictlyEquals("Item renderer returned by itemToItemRenderer() has incorrect data", item0, itemRenderer0.data);
			Assert.assertStrictlyEquals("Item renderer returned by itemToItemRenderer() has incorrect index", 0, itemRenderer0.index);
			Assert.assertNotNull("itemToItemRenderer() incorrectly returned null for item that should have an item renderer", itemRenderer1);
			Assert.assertStrictlyEquals("Item renderer returned by itemToItemRenderer() has incorrect data", item1, itemRenderer1.data);
			Assert.assertStrictlyEquals("Item renderer returned by itemToItemRenderer() has incorrect index", 1, itemRenderer1.index);
			Assert.assertNull("itemToItemRenderer() incorrectly returned item renderer for item that should not have one", itemRenderer3);
		}

		[Test]
		public function testResizeOnUpdateItemAtWithLongerText():void
		{
			this._list.dataProvider.getItemAt(1).label = "I am the very model of a modern major general. I've information vegetable, animal, and mineral.";
			this._list.dataProvider.updateItemAt(1);
			var hasResized:Boolean = false;
			this._list.addEventListener(Event.RESIZE, function(event:Event):void
			{
				hasResized = true;
			});
			this._list.validate();
			Assert.assertTrue("List Event.RESIZE was not dispatched when item was updated with longer text and width was not explicit", hasResized);
		}

		[Test]
		public function testNewMaskDimensionsOnAddItemToDataProvider():void
		{
			var mask:DisplayObject = this._list.viewPort.mask;
			var oldMaskHeight:Number = mask.height;
			this._list.dataProvider.addItem({ label: "New Item" });
			this._list.validate();
			Assert.assertTrue("List with VerticalLayout must resize mask when item is added to data provider and height is not explicit", mask.height > oldMaskHeight);
		}

		[Test]
		public function testViewPortBoundsValues():void
		{
			this._list.layout = new AssertViewPortBoundsLayout();
			this._list.validate();
		}

		[Test]
		public function testScrollToDisplayIndexAndSetDataProviderToNull():void
		{
			this._list.scrollToDisplayIndex(1, 2);
			this._list.dataProvider = null;
			this._list.validate();
		}

		[Test]
		public function testScrollToDisplayIndex():void
		{
			var hasDispatchedScrollStart:Boolean = false;
			this._list.addEventListener(FeathersEventType.SCROLL_START, function(event:Event):void
			{
				hasDispatchedScrollStart = true;
			});
			var hasDispatchedScrollComplete:Boolean = false;
			this._list.addEventListener(FeathersEventType.SCROLL_COMPLETE, function(event:Event):void
			{
				hasDispatchedScrollComplete = true;
			});
			this._list.height = 200;
			this._list.scrollToDisplayIndex(1);
			this._list.validate();
			Assert.assertTrue("List: scrollToDisplayIndex() set incorrect verticalScrollPosition", this._list.verticalScrollPosition > 0);
			Assert.assertTrue("List: scrollToDisplayIndex() with duration 0 did not dispatch FeathersEventType.SCROLL_START",
				hasDispatchedScrollStart);
			Assert.assertTrue("List: scrollToDisplayIndex() with duration 0 did not dispatch FeathersEventType.SCROLL_COMPLETE",
				hasDispatchedScrollComplete);
		}
	}
}
