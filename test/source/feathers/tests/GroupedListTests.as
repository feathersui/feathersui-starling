package feathers.tests
{
	import feathers.controls.GroupedList;
	import feathers.controls.renderers.DefaultGroupedListHeaderOrFooterRenderer;
	import feathers.controls.renderers.DefaultGroupedListItemRenderer;
	import feathers.controls.renderers.IGroupedListHeaderRenderer;
	import feathers.controls.renderers.IGroupedListItemRenderer;
	import feathers.data.HierarchicalCollection;
	import feathers.events.FeathersEventType;

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
				},
				{
					header: { label: "C" },
					children:
					[
						{label: "Seven"},
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

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
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
			Assert.assertStrictlyEquals("The selectedItemIndex property was not changed",
				beforeSelectedItemIndex - 1, this._list.selectedItemIndex);
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
			Assert.assertStrictlyEquals("The selectedItemIndex property was not changed",
				beforeSelectedItemIndex + 1, this._list.selectedItemIndex);
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

		[Test]
		public function testDisposeWithoutChangeEvent():void
		{
			this._list.setSelectedLocation(1, 1);
			var hasChanged:Boolean = false;
			this._list.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._list.dispose();
			Assert.assertFalse("Event.CHANGE was incorrectly dispatched", hasChanged);
		}

		[Test]
		public function testFirstItemRendererFactoryWithMultipleItemsInGroup():void
		{
			var firstItemName:String = "first-item";
			this._list.firstItemRendererFactory = function():DefaultGroupedListItemRenderer
			{
				var itemRenderer:DefaultGroupedListItemRenderer = _list.itemRendererFactory();
				itemRenderer.name = firstItemName;
				return itemRenderer;
			};
			var usedFirstItemRendererFactory:Boolean = false;
			this._list.addEventListener(FeathersEventType.RENDERER_ADD, function(event:Event):void
			{
				if(!(event.data is IGroupedListItemRenderer))
				{
					return;
				}
				var itemRenderer:IGroupedListItemRenderer = IGroupedListItemRenderer(event.data);
				if(itemRenderer.groupIndex === 1 && itemRenderer.itemIndex === 0 &&
					itemRenderer.name === firstItemName)
				{
					usedFirstItemRendererFactory = true;
				}
			})
			this._list.validate();
			Assert.assertTrue("firstItemRendererFactory not used when data provider has multiple items in group", usedFirstItemRendererFactory);
		}

		[Test]
		public function testCustomFirstItemRendererStyleNameWithMultipleItemsInGroup():void
		{
			var firstStyleName:String = "custom-first-item";
			this._list.customFirstItemRendererStyleName = firstStyleName;
			var containsFirstItemRendererStyleName:Boolean = false;
			this._list.addEventListener(FeathersEventType.RENDERER_ADD, function(event:Event):void
			{
				if(!(event.data is IGroupedListItemRenderer))
				{
					return;
				}
				var itemRenderer:IGroupedListItemRenderer = IGroupedListItemRenderer(event.data);
				if(itemRenderer.groupIndex === 1 && itemRenderer.itemIndex === 0 &&
					itemRenderer.styleNameList.contains(firstStyleName))
				{
					containsFirstItemRendererStyleName = true;
				}
			})
			this._list.validate();
			Assert.assertTrue("customFirstItemRendererStyleName not used when data provider has multiple items in group", containsFirstItemRendererStyleName);
		}

		[Test]
		public function testLastItemRendererFactoryWithMultipleItemsInGroup():void
		{
			var lastItemName:String = "last-item";
			this._list.lastItemRendererFactory = function():DefaultGroupedListItemRenderer
			{
				var itemRenderer:DefaultGroupedListItemRenderer = _list.itemRendererFactory();
				itemRenderer.name = lastItemName;
				return itemRenderer;
			};
			var usedLastItemRendererFactory:Boolean = false;
			this._list.addEventListener(FeathersEventType.RENDERER_ADD, function(event:Event):void
			{
				if(!(event.data is IGroupedListItemRenderer))
				{
					return;
				}
				var itemRenderer:IGroupedListItemRenderer = IGroupedListItemRenderer(event.data);
				if(itemRenderer.groupIndex === 1 && itemRenderer.itemIndex === 2 &&
					itemRenderer.name === lastItemName)
				{
					usedLastItemRendererFactory = true;
				}
			})
			this._list.validate();
			Assert.assertTrue("lastItemRendererFactory not used when data provider has multiple items in group", usedLastItemRendererFactory);
		}

		[Test]
		public function testCustomLastItemRendererStyleNameWithMultipleItemsInGroup():void
		{
			var lastStyleName:String = "custom-last-item";
			this._list.customLastItemRendererStyleName = lastStyleName;
			var containsLastItemRendererStyleName:Boolean = false;
			this._list.addEventListener(FeathersEventType.RENDERER_ADD, function(event:Event):void
			{
				if(!(event.data is IGroupedListItemRenderer))
				{
					return;
				}
				var itemRenderer:IGroupedListItemRenderer = IGroupedListItemRenderer(event.data);
				if(itemRenderer.groupIndex === 1 && itemRenderer.itemIndex === 2 &&
					itemRenderer.styleNameList.contains(lastStyleName))
				{
					containsLastItemRendererStyleName = true;
				}
			})
			this._list.validate();
			Assert.assertTrue("customLastItemRendererStyleName not used when data provider has multiple items in group", containsLastItemRendererStyleName);
		}

		[Test]
		public function testFirstItemRendererFactoryWithOneItemAndCustomLastItemRendererFactory():void
		{
			var firstItemName:String = "first-item";
			var lastItemName:String = "last-item";
			this._list.firstItemRendererFactory = function():DefaultGroupedListItemRenderer
			{
				var itemRenderer:DefaultGroupedListItemRenderer = _list.itemRendererFactory();
				itemRenderer.name = firstItemName;
				return itemRenderer;
			};
			this._list.lastItemRendererFactory = function():DefaultGroupedListItemRenderer
			{
				var itemRenderer:DefaultGroupedListItemRenderer = _list.itemRendererFactory();
				itemRenderer.name = lastItemName;
				return itemRenderer;
			};
			var usedFirstItemRendererFactory:Boolean = false;
			this._list.addEventListener(FeathersEventType.RENDERER_ADD, function(event:Event):void
			{
				if(!(event.data is IGroupedListItemRenderer))
				{
					return;
				}
				var itemRenderer:IGroupedListItemRenderer = IGroupedListItemRenderer(event.data);
				if(itemRenderer.groupIndex === 2 && itemRenderer.itemIndex === 0 &&
					itemRenderer.name === firstItemName)
				{
					usedFirstItemRendererFactory = true;
				}
			})
			this._list.validate();
			Assert.assertTrue("firstItemRendererFactory not used when data provider has only one item in group and lastItemRendererFactory is defined", usedFirstItemRendererFactory);
		}

		[Test]
		public function testCustomFirstItemRendererStyleNameWithOneItemAndCustomLastItemRendererStyleName():void
		{
			var firstStyleName:String = "custom-first-item";
			var lastStyleName:String = "custom-last-item";
			this._list.customFirstItemRendererStyleName = firstStyleName;
			this._list.customLastItemRendererStyleName = lastStyleName;
			var containsFirstItemRendererStyleName:Boolean = false;
			this._list.addEventListener(FeathersEventType.RENDERER_ADD, function(event:Event):void
			{
				if(!(event.data is IGroupedListItemRenderer))
				{
					return;
				}
				var itemRenderer:IGroupedListItemRenderer = IGroupedListItemRenderer(event.data);
				if(itemRenderer.groupIndex === 2 && itemRenderer.itemIndex === 0 &&
					itemRenderer.styleNameList.contains(firstStyleName))
				{
					containsFirstItemRendererStyleName = true;
				}
			})
			this._list.validate();
			Assert.assertTrue("customFirstItemRendererStyleName not used when data provider has only one item in group and customLastItemRendererStyleName is defined", containsFirstItemRendererStyleName);
		}

		[Test]
		public function testSingleItemRendererFactoryWithOneItemAndOtherFactories():void
		{
			var firstItemName:String = "first-item";
			var lastItemName:String = "last-item";
			var singleItemName:String = "single-item";
			this._list.firstItemRendererFactory = function():DefaultGroupedListItemRenderer
			{
				var itemRenderer:DefaultGroupedListItemRenderer = _list.itemRendererFactory();
				itemRenderer.name = firstItemName;
				return itemRenderer;
			};
			this._list.lastItemRendererFactory = function():DefaultGroupedListItemRenderer
			{
				var itemRenderer:DefaultGroupedListItemRenderer = _list.itemRendererFactory();
				itemRenderer.name = lastItemName;
				return itemRenderer;
			};
			this._list.singleItemRendererFactory = function():DefaultGroupedListItemRenderer
			{
				var itemRenderer:DefaultGroupedListItemRenderer = _list.itemRendererFactory();
				itemRenderer.name = singleItemName;
				return itemRenderer;
			};
			var usedSingleItemRendererFactory:Boolean = false;
			this._list.addEventListener(FeathersEventType.RENDERER_ADD, function(event:Event):void
			{
				if(!(event.data is IGroupedListItemRenderer))
				{
					return;
				}
				var itemRenderer:IGroupedListItemRenderer = IGroupedListItemRenderer(event.data);
				if(itemRenderer.groupIndex === 2 && itemRenderer.itemIndex === 0 &&
					itemRenderer.name === singleItemName)
				{
					usedSingleItemRendererFactory = true;
				}
			})
			this._list.validate();
			Assert.assertTrue("singleItemRendererFactory not used when data provider has only one item in group and firstItemRendererFactory and lastItemRendererFactory are defined", singleItemName);
		}

		[Test]
		public function testCustomSingleItemRendererStyleNameWithOneItemAndOtherStyleNames():void
		{
			var firstStyleName:String = "custom-first-item";
			var lastStyleName:String = "custom-last-item";
			var singleStyleName:String = "custom-single-item";
			this._list.customFirstItemRendererStyleName = firstStyleName;
			this._list.customLastItemRendererStyleName = lastStyleName;
			this._list.customSingleItemRendererStyleName = singleStyleName;
			var containsSingleItemRendererStyleName:Boolean = false;
			this._list.addEventListener(FeathersEventType.RENDERER_ADD, function(event:Event):void
			{
				if(!(event.data is IGroupedListItemRenderer))
				{
					return;
				}
				var itemRenderer:IGroupedListItemRenderer = IGroupedListItemRenderer(event.data);
				if(itemRenderer.groupIndex === 2 && itemRenderer.itemIndex === 0 &&
					itemRenderer.styleNameList.contains(singleStyleName))
				{
					containsSingleItemRendererStyleName = true;
				}
			})
			this._list.validate();
			Assert.assertTrue("containsSingleItemRendererStyleName not used when data provider has only one item in group and customFirstItemRendererStyleName or customLastItemRendererStyleName are defined", containsSingleItemRendererStyleName);
		}

		[Test]
		public function testLastItemRendererFactoryWithOneItem():void
		{
			var componentName:String = "last-item";
			this._list.lastItemRendererFactory = function():DefaultGroupedListItemRenderer
			{
				var itemRenderer:DefaultGroupedListItemRenderer = _list.itemRendererFactory();
				itemRenderer.name = componentName;
				return itemRenderer;
			};
			var usedLastItemRendererFactory:Boolean = false;
			this._list.addEventListener(FeathersEventType.RENDERER_ADD, function(event:Event):void
			{
				if(!(event.data is IGroupedListItemRenderer))
				{
					return;
				}
				var itemRenderer:IGroupedListItemRenderer = IGroupedListItemRenderer(event.data);
				if(itemRenderer.groupIndex === 2 && itemRenderer.itemIndex === 0 &&
					itemRenderer.name === componentName)
				{
					usedLastItemRendererFactory = true;
				}
			})
			this._list.validate();
			Assert.assertTrue("lastItemRendererFactory not used when data provider has only one item in group and neither firstItemRendererFactory or singleItemRendererFactory are defined", usedLastItemRendererFactory);
		}

		[Test]
		public function testCustomLastItemRendererStyleNameWithOneItem():void
		{
			var styleName:String = "custom-last-item";
			this._list.customLastItemRendererStyleName = styleName;
			var containsLastItemRendererStyleName:Boolean = false;
			this._list.addEventListener(FeathersEventType.RENDERER_ADD, function(event:Event):void
			{
				if(!(event.data is IGroupedListItemRenderer))
				{
					return;
				}
				var itemRenderer:IGroupedListItemRenderer = IGroupedListItemRenderer(event.data);
				if(itemRenderer.groupIndex === 2 && itemRenderer.itemIndex === 0 &&
					itemRenderer.styleNameList.contains(styleName))
				{
					containsLastItemRendererStyleName = true;
				}
			})
			this._list.validate();
			Assert.assertTrue("customLastItemRendererStyleName not used when data provider has only one item in group and neither customFirstItemRendererStyleName or customSingleItemRendererStyleName are defined", containsLastItemRendererStyleName);
		}

		[Test]
		public function testItemToItemRenderer():void
		{
			this._list.height = 220;
			this._list.validate();
			var item00:Object = this._list.dataProvider.getItemAt(0, 0);
			var itemRenderer00:IGroupedListItemRenderer = this._list.itemToItemRenderer(item00);
			var item01:Object = this._list.dataProvider.getItemAt(0, 1);
			var itemRenderer01:IGroupedListItemRenderer = this._list.itemToItemRenderer(item01);
			var item20:Object = this._list.dataProvider.getItemAt(2, 0);
			var itemRenderer20:IGroupedListItemRenderer = this._list.itemToItemRenderer(item20);
			Assert.assertNotNull("itemToItemRenderer() incorrectly returned null for item at index 0,0 that should have an item renderer", itemRenderer00);
			Assert.assertStrictlyEquals("Item renderer returned by itemToItemRenderer() has incorrect data", item00, itemRenderer00.data);
			Assert.assertStrictlyEquals("Item renderer returned by itemToItemRenderer() has incorrect group index", 0, itemRenderer00.groupIndex);
			Assert.assertStrictlyEquals("Item renderer returned by itemToItemRenderer() has incorrect item index", 0, itemRenderer00.itemIndex);
			Assert.assertNotNull("itemToItemRenderer() incorrectly returned null for item at index 0,1 that should have an item renderer", itemRenderer01);
			Assert.assertStrictlyEquals("Item renderer returned by itemToItemRenderer() has incorrect data", item01, itemRenderer01.data);
			Assert.assertStrictlyEquals("Item renderer returned by itemToItemRenderer() has incorrect group index", 0, itemRenderer01.groupIndex);
			Assert.assertStrictlyEquals("Item renderer returned by itemToItemRenderer() has incorrect item index", 1, itemRenderer01.itemIndex);
			Assert.assertNull("itemToItemRenderer() incorrectly returned item renderer for item that should not have one", itemRenderer20);
		}

		[Test]
		public function testHeaderDataToHeaderRenderer():void
		{
			this._list.height = 20;
			this._list.validate();
			var group0:Object = this._list.dataProvider.getItemAt(0);
			var header0:Object = this._list.groupToHeaderData(group0);
			var headerRenderer0:IGroupedListHeaderRenderer = this._list.headerDataToHeaderRenderer(header0);
			var group1:Object = this._list.dataProvider.getItemAt(1);
			var header1:Object = this._list.groupToHeaderData(group1);
			var headerRenderer1:IGroupedListHeaderRenderer = this._list.headerDataToHeaderRenderer(header1);
			Assert.assertNotNull("headerDataToHeaderRenderer() incorrectly returned null for header at group index 0", headerRenderer0);
			Assert.assertStrictlyEquals("Header renderer returned by headerDataToHeaderRenderer() has incorrect header data", header0, headerRenderer0.data);
			Assert.assertStrictlyEquals("Header renderer returned by headerDataToHeaderRenderer() has incorrect group index", 0, headerRenderer0.groupIndex);
			Assert.assertNull("headerDataToHeaderRenderer() incorrectly returned header renderer for header data that should not have one", headerRenderer1);
		}

		[Test]
		public function testGroupToHeaderData():void
		{
			var rawData:Object = this._list.dataProvider.data;
			var group0:Object = this._list.dataProvider.getItemAt(0);
			var header0:Object = this._list.groupToHeaderData(group0);
			var group1:Object = this._list.dataProvider.getItemAt(1);
			var header1:Object = this._list.groupToHeaderData(group1);
			Assert.assertStrictlyEquals("groupToHeaderData() incorrectly returned wrong header data for index 0", header0, rawData[0].header);
			Assert.assertStrictlyEquals("groupToHeaderData() incorrectly returned wrong header data for index 1", header1, rawData[1].header);
		}
	}
}
