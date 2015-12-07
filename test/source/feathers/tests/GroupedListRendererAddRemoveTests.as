package feathers.tests
{
	import feathers.controls.GroupedList;
	import feathers.controls.renderers.DefaultGroupedListHeaderOrFooterRenderer;
	import feathers.controls.renderers.DefaultGroupedListItemRenderer;
	import feathers.controls.renderers.IGroupedListHeaderRenderer;
	import feathers.controls.renderers.IGroupedListItemRenderer;
	import feathers.core.IFeathersControl;
	import feathers.data.HierarchicalCollection;
	import feathers.events.FeathersEventType;

	import flexunit.framework.Assert;

	import starling.display.Quad;
	import starling.events.Event;

	public class GroupedListRendererAddRemoveTests
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
		}

		[After]
		public function cleanup():void
		{
			this._list.removeFromParent(true);
			this._list = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testRendererAddEventWithDataProvider():void
		{
			var headerRendererCount:int = 0;
			var itemRendererCount:int = 0;
			this._list.addEventListener(FeathersEventType.RENDERER_ADD, function(event:Event, renderer:IFeathersControl):void
			{
				if(renderer is IGroupedListHeaderRenderer)
				{
					headerRendererCount++;
				}
				else if(renderer is IGroupedListItemRenderer)
				{
					itemRendererCount++;
				}
			});
			this._list.validate();
			
			var expectedItemRendererCount:int = 0;
			var groupCount:int = this._list.dataProvider.getLength();
			for(var i:int = 0; i < groupCount; i++)
			{
				expectedItemRendererCount += this._list.dataProvider.getLength(i);
			}

			Assert.assertStrictlyEquals("FeathersEventType.RENDERER_ADD not dispatched for all visible headers.", groupCount, headerRendererCount);
			Assert.assertStrictlyEquals("FeathersEventType.RENDERER_ADD not dispatched for all visible headers.", expectedItemRendererCount, itemRendererCount);
		}

		[Test]
		public function testRendererAddEventAfterAddItem():void
		{
			var groupIndex:int = 1;
			var itemIndex:int = 1;
			this._list.validate();
			var addedRenderer:Boolean = false;
			var addedGroupIndex:int = -1;
			var addedItemIndex:int = -1;
			function rendererAddListener(event:Event, itemRenderer:IGroupedListItemRenderer):void
			{
				addedRenderer = true;
				addedGroupIndex = itemRenderer.groupIndex;
				addedItemIndex = itemRenderer.itemIndex;
			}
			this._list.addEventListener(FeathersEventType.RENDERER_ADD, rendererAddListener);
			this._list.dataProvider.addItemAt({label: "New Item"}, groupIndex, itemIndex);
			this._list.validate();
			this._list.removeEventListener(FeathersEventType.RENDERER_ADD, rendererAddListener);
			Assert.assertTrue("FeathersEventType.RENDERER_ADD not dispatched after addItemAt().", addedRenderer);
			Assert.assertStrictlyEquals("FeathersEventType.RENDERER_ADD not dispatched with correct item renderer after addItemAt().", groupIndex, addedGroupIndex);
			Assert.assertStrictlyEquals("FeathersEventType.RENDERER_ADD not dispatched with correct item renderer after addItemAt().", itemIndex, addedItemIndex);
		}

		[Test]
		public function testRendererRemoveEventAfterRemoveItemAt():void
		{
			var groupIndex:int = 1;
			var itemIndex:int = 1;
			this._list.validate();
			var removedRenderer:Boolean = false;
			var removedGroupIndex:int = -1;
			var removedItemIndex:int = -1;
			function rendererRemoveListener(event:Event, itemRenderer:IGroupedListItemRenderer):void
			{
				removedRenderer = true;
				removedGroupIndex = itemRenderer.groupIndex;
				removedItemIndex = itemRenderer.itemIndex;
			}
			this._list.addEventListener(FeathersEventType.RENDERER_REMOVE, rendererRemoveListener);
			this._list.dataProvider.removeItemAt(groupIndex, itemIndex);
			this._list.validate();
			this._list.removeEventListener(FeathersEventType.RENDERER_REMOVE, rendererRemoveListener);
			Assert.assertTrue("FeathersEventType.RENDERER_REMOVE not dispatched after removeItemAt().", removedRenderer);
			Assert.assertStrictlyEquals("FeathersEventType.RENDERER_REMOVE not dispatched with correct item renderer after removeItemAt().", groupIndex, removedGroupIndex);
			Assert.assertStrictlyEquals("FeathersEventType.RENDERER_REMOVE not dispatched with correct item renderer after removeItemAt().", itemIndex, removedItemIndex);
		}

		[Test]
		public function testRendererAddAndRemoveEventsAfterSetItemAt():void
		{
			var groupIndex:int = 1;
			var itemIndex:int = 1;
			this._list.validate();
			var addedRenderer:Boolean = false;
			var addedGroupIndex:int = -1;
			var addedItemIndex:int = -1;
			function rendererAddListener(event:Event, itemRenderer:IGroupedListItemRenderer):void
			{
				Assert.assertTrue("FeathersEventType.RENDERER_REMOVE not dispatched before FeathersEventType.RENDERER_ADD when calling setItemAt().", removedRenderer);
				addedRenderer = true;
				addedGroupIndex = itemRenderer.groupIndex;
				addedItemIndex = itemRenderer.itemIndex;
			}
			this._list.addEventListener(FeathersEventType.RENDERER_ADD, rendererAddListener);
			var removedRenderer:Boolean = false;
			var removedGroupIndex:int = -1;
			var removedItemIndex:int = -1;
			function rendererRemoveListener(event:Event, itemRenderer:IGroupedListItemRenderer):void
			{
				removedRenderer = true;
				removedGroupIndex = itemRenderer.groupIndex;
				removedItemIndex = itemRenderer.itemIndex;
			}
			this._list.addEventListener(FeathersEventType.RENDERER_REMOVE, rendererRemoveListener);
			this._list.dataProvider.setItemAt({label: "New Item"}, groupIndex, itemIndex);
			this._list.validate();
			this._list.removeEventListener(FeathersEventType.RENDERER_ADD, rendererAddListener);
			this._list.removeEventListener(FeathersEventType.RENDERER_REMOVE, rendererRemoveListener);
			Assert.assertTrue("FeathersEventType.RENDERER_REMOVE not dispatched after setItemAt().", removedRenderer);
			Assert.assertStrictlyEquals("FeathersEventType.RENDERER_REMOVE not dispatched with correct item renderer after setItemAt().", groupIndex, removedGroupIndex);
			Assert.assertStrictlyEquals("FeathersEventType.RENDERER_REMOVE not dispatched with correct item renderer after setItemAt().", itemIndex, removedItemIndex);
			Assert.assertTrue("FeathersEventType.RENDERER_ADD not dispatched after setItemAt().", addedRenderer);
			Assert.assertStrictlyEquals("FeathersEventType.RENDERER_ADD not dispatched with correct item renderer after setItemAt().", groupIndex, addedGroupIndex);
			Assert.assertStrictlyEquals("FeathersEventType.RENDERER_ADD not dispatched with correct item renderer after setItemAt().", itemIndex, addedItemIndex);
		}

		[Test]
		public function testRendererAddAndRemoveEventAfterChangeTypicalItemFromDefaultToCustom():void
		{
			this._list.validate();
			this._list.typicalItem = { label: "Typical Item" };
			var addedRenderer:Boolean = false;
			function rendererAddListener(event:Event, itemRenderer:Object):void
			{
				addedRenderer = true;
			}
			this._list.addEventListener(FeathersEventType.RENDERER_ADD, rendererAddListener);
			var removedRenderer:Boolean = false;
			function rendererRemoveListener(event:Event, itemRenderer:Object):void
			{
				removedRenderer = true;
			}
			this._list.addEventListener(FeathersEventType.RENDERER_REMOVE, rendererRemoveListener);
			this._list.validate();
			Assert.assertFalse("FeathersEventType.RENDERER_REMOVE incorrectly dispatched after change typicalItem from default to custom.", removedRenderer);
			Assert.assertFalse("FeathersEventType.RENDERER_ADD incorrectly dispatched after change typicalItem from default to custom.", addedRenderer);
		}

		[Test]
		public function testRendererRemoveEventsAfterDispose():void
		{
			this._list.validate();

			var expectedItemRendererCount:int = 0;
			var groupCount:int = this._list.dataProvider.getLength();
			for(var i:int = 0; i < groupCount; i++)
			{
				expectedItemRendererCount += this._list.dataProvider.getLength(i);
			}
			
			var headerRendererCount:int = 0;
			var itemRendererCount:int = 0;
			this._list.addEventListener(FeathersEventType.RENDERER_REMOVE, function(event:Event, renderer:IFeathersControl):void
			{
				if(renderer is IGroupedListHeaderRenderer)
				{
					var headerRenderer:IGroupedListHeaderRenderer = IGroupedListHeaderRenderer(renderer);
					Assert.assertNotNull("Header renderer incorrectly has null owner during dispose().", headerRenderer.owner);
					Assert.assertNotNull("Header renderer incorrectly has null data during dispose().", headerRenderer.data);
					Assert.assertTrue("Header renderer incorrectly has negative group index during dispose().", headerRenderer.groupIndex >= 0);
					headerRendererCount++;
				}
				else if(renderer is IGroupedListItemRenderer)
				{
					var itemRenderer:IGroupedListItemRenderer = IGroupedListItemRenderer(renderer);
					Assert.assertNotNull("Item renderer incorrectly has null owner during dispose().", itemRenderer.owner);
					Assert.assertNotNull("Item renderer incorrectly has null data during dispose().", itemRenderer.data);
					Assert.assertTrue("Item renderer incorrectly has negative group index during dispose().", itemRenderer.groupIndex >= 0);
					Assert.assertTrue("Item renderer incorrectly has negative item index during dispose().", itemRenderer.itemIndex >= 0);
					itemRendererCount++;
				}
			});
			this._list.dispose();
			Assert.assertStrictlyEquals("FeathersEventType.RENDERER_REMOVE not dispatched for all header renderers after dispose().", groupCount, headerRendererCount);
			Assert.assertStrictlyEquals("FeathersEventType.RENDERER_REMOVE not dispatched for all item renderers after dispose().", expectedItemRendererCount, itemRendererCount);
		}
	}
}
