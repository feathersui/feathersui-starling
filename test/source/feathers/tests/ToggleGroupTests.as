package feathers.tests
{
	import feathers.controls.ToggleButton;
	import feathers.core.IToggle;
	import feathers.core.ToggleGroup;

	import org.flexunit.Assert;

	import starling.events.Event;

	public class ToggleGroupTests
	{
		private var _group:ToggleGroup;

		[Before]
		public function prepare():void
		{
			this._group = new ToggleGroup();
		}

		[After]
		public function cleanup():void
		{
			var itemCount:int = this._group.numItems;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:ToggleButton = ToggleButton(this._group.getItemAt(i));
				item.dispose();
			}
			this._group = null;
		}

		[Test]
		public function testDefaultSelectedIndexIsNegativeOne():void
		{
			Assert.assertStrictlyEquals("The selectedIndex property is not equal to -1",
				-1, this._group.selectedIndex);
		}

		[Test]
		public function testUpdatesSelectedIndexWhenAddingFirstItem():void
		{
			var hasChanged:Boolean = false;
			this._group.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._group.addItem(new ToggleButton());
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertStrictlyEquals("The selectedIndex property is not equal to 0",
				0, this._group.selectedIndex);
		}

		[Test]
		public function testSettingSelectedIndexDispatchesChangeEvent():void
		{
			this._group.addItem(new ToggleButton());
			this._group.addItem(new ToggleButton());
			var hasChanged:Boolean = false;
			this._group.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._group.selectedIndex = 1;
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
		}

		[Test]
		public function testSettingSelectedIndexToSameValueDispatchesNoEvent():void
		{
			this._group.addItem(new ToggleButton());
			this._group.addItem(new ToggleButton());
			var hasChanged:Boolean = false;
			this._group.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._group.selectedIndex = 0;
			Assert.assertFalse("Event.CHANGE was not dispatched", hasChanged);
		}

		[Test]
		public function testChangingItemSelectionDispatchesChangeEvent():void
		{
			var itemAtIndex1:ToggleButton = new ToggleButton();
			this._group.addItem(new ToggleButton());
			this._group.addItem(itemAtIndex1);
			var hasChanged:Boolean = false;
			this._group.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			itemAtIndex1.isSelected = true;
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
		}

		[Test]
		public function testRemoveItemBeforeSelectedItem():void
		{
			var itemAtIndex0:ToggleButton = new ToggleButton();
			this._group.addItem(itemAtIndex0);
			this._group.addItem(new ToggleButton());
			this._group.addItem(new ToggleButton());
			this._group.selectedIndex = 1;
			var beforeSelectedIndex:int = this._group.selectedIndex;
			var beforeSelectedItem:Object = this._group.selectedItem;
			var hasChanged:Boolean = false;
			this._group.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._group.removeItem(itemAtIndex0);
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertStrictlyEquals("The selectedIndex property was not changed",
				beforeSelectedIndex - 1, this._group.selectedIndex);
			Assert.assertStrictlyEquals("The selectedItem was incorrectly changed",
				beforeSelectedItem, this._group.selectedItem);
		}

		[Test]
		public function testRemoveAfterSelectedIndex():void
		{
			var itemAtIndex2:ToggleButton = new ToggleButton();
			this._group.addItem(new ToggleButton());
			this._group.addItem(new ToggleButton());
			this._group.addItem(itemAtIndex2);
			this._group.selectedIndex = 1;
			var beforeSelectedIndex:int = this._group.selectedIndex;
			var beforeSelectedItem:Object = this._group.selectedItem;
			var hasChanged:Boolean = false;
			this._group.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._group.removeItem(itemAtIndex2);
			Assert.assertFalse("Event.CHANGE was incorrectly dispatched", hasChanged);
			Assert.assertStrictlyEquals("The selectedIndex property was incorrectly changed",
				beforeSelectedIndex, this._group.selectedIndex);
			Assert.assertStrictlyEquals("The selectedItem was incorrectly changed",
				beforeSelectedItem, this._group.selectedItem);
		}

		[Test]
		public function testRemoveSelectedItem():void
		{
			var itemAtIndex1:ToggleButton = new ToggleButton();
			this._group.addItem(new ToggleButton());
			this._group.addItem(itemAtIndex1);
			this._group.addItem(new ToggleButton());
			this._group.selectedIndex = 1;
			var beforeSelectedIndex:int = this._group.selectedIndex;
			var beforeSelectedItem:IToggle = this._group.selectedItem;
			var hasChanged:Boolean = false;
			this._group.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._group.removeItem(itemAtIndex1);
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertStrictlyEquals("The selectedIndex property was incorrectly changed",
				beforeSelectedIndex, this._group.selectedIndex);
			Assert.assertFalse("The selectedItem was not changed",
				beforeSelectedItem === this._group.selectedItem);
		}

		[Test]
		public function testDeselectAllOnRemoveAllItems():void
		{
			this._group.addItem(new ToggleButton());
			this._group.addItem(new ToggleButton());
			this._group.addItem(new ToggleButton());
			var hasChanged:Boolean = false;
			this._group.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._group.removeAllItems();
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertStrictlyEquals("The selectedIndex property was not set to -1",
				-1, this._group.selectedIndex);
			Assert.assertStrictlyEquals("The selectedItem property was not set to null",
				null, this._group.selectedItem);
		}

		[Test]
		public function testSetSelectedItemIndex():void
		{
			var itemAtIndex1:ToggleButton = new ToggleButton();
			this._group.addItem(new ToggleButton());
			this._group.addItem(itemAtIndex1);
			this._group.addItem(new ToggleButton());
			this._group.selectedIndex = 1;
			var hasChanged:Boolean = false;
			var beforeSelectedIndex:int = this._group.selectedIndex;
			var beforeSelectedItem:IToggle = this._group.selectedItem;
			this._group.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._group.setItemIndex(itemAtIndex1, 2);
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertFalse("The selectedIndex property was not changed",
				beforeSelectedIndex === this._group.selectedIndex);
			Assert.assertStrictlyEquals("The selectedItem was incorrectly changed",
				beforeSelectedItem, this._group.selectedItem);
		}

		[Test]
		public function testSetItemIndexBeforeSelectedItem():void
		{
			var itemAtIndex0:ToggleButton = new ToggleButton();
			this._group.addItem(itemAtIndex0);
			this._group.addItem(new ToggleButton());
			this._group.addItem(new ToggleButton());
			this._group.selectedIndex = 1;
			var hasChanged:Boolean = false;
			var beforeSelectedIndex:int = this._group.selectedIndex;
			var beforeSelectedItem:IToggle = this._group.selectedItem;
			this._group.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._group.setItemIndex(itemAtIndex0, 2);
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertFalse("The selectedIndex property was not changed",
				beforeSelectedIndex === this._group.selectedIndex);
			Assert.assertStrictlyEquals("The selectedItem was incorrectly changed",
				beforeSelectedItem, this._group.selectedItem);
		}

		[Test]
		public function testSetItemIndexAfterSelectedItem():void
		{
			var itemAtIndex2:ToggleButton = new ToggleButton();
			this._group.addItem(new ToggleButton());
			this._group.addItem(new ToggleButton());
			this._group.addItem(itemAtIndex2);
			this._group.selectedIndex = 1;
			var hasChanged:Boolean = false;
			var beforeSelectedIndex:int = this._group.selectedIndex;
			var beforeSelectedItem:IToggle = this._group.selectedItem;
			this._group.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._group.setItemIndex(itemAtIndex2, 0);
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertFalse("The selectedIndex property was not changed",
				beforeSelectedIndex === this._group.selectedIndex);
			Assert.assertStrictlyEquals("The selectedItem was incorrectly changed",
				beforeSelectedItem, this._group.selectedItem);
		}

		[Test]
		public function testHasItem():void
		{
			var item:ToggleButton = new ToggleButton();
			Assert.assertFalse("hasItem() incorrectly returned true.", this._group.hasItem(item));
			this._group.addItem(item);
			Assert.assertTrue("hasItem() incorrectly returned false.", this._group.hasItem(item));
			this._group.removeItem(item);
			Assert.assertFalse("hasItem() incorrectly returned true.", this._group.hasItem(item));
		}

		[Test]
		public function testDefaultNumItems():void
		{
			Assert.assertStrictlyEquals("The numItems property is not equal to 0",
				0, this._group.numItems);
		}

		[Test]
		public function testNumItemsAfterAddItem():void
		{
			this._group.addItem(new ToggleButton());
			Assert.assertStrictlyEquals("The numItems property is not equal to 1 after addItem()",
				1, this._group.numItems);
		}

		[Test(expects="RangeError")]
		public function testGetItemAtWhenEmpty():void
		{
			this._group.getItemAt(0);
		}

		[Test]
		public function testGetItemAt():void
		{
			var item:ToggleButton = new ToggleButton();
			this._group.addItem(item);
			Assert.assertStrictlyEquals("ToggleButton getItemAt() returns wrong item",
				item, this._group.getItemAt(0));
		}
	}
}
