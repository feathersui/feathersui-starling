package feathers.tests
{
	import feathers.controls.GroupedList;
	import feathers.controls.renderers.DefaultGroupedListItemRenderer;
	import feathers.controls.renderers.IGroupedListHeaderRenderer;
	import feathers.controls.renderers.IGroupedListItemRenderer;
	import feathers.core.IFeathersControl;
	import feathers.data.HierarchicalCollection;
	import feathers.events.FeathersEventType;

	import flash.utils.Dictionary;

	import org.flexunit.Assert;

	import starling.display.Quad;
	import starling.events.Event;

	public class GroupedListFactoryIDFunctionTests
	{
		private static const FACTORY_ONE:String = "custom-factory1";
		private static const CUSTOM_STYLE_NAME:String = "custom-style-name";

		private var _list:GroupedList;

		private var _itemRendererMap:Dictionary;

		[Before]
		public function prepare():void
		{
			this._itemRendererMap = new Dictionary(true);

			this._list = new GroupedList();
			this._list.dataProvider = new HierarchicalCollection(
			[	
				{
					header: { label: "Group A" },
					children:
					[
						{ label: "One", factory: 0 },
						{ label: "Two", factory: 0 },
						{ label: "Three", factory: 1 },
					]
				},
				{
					header: { label: "Group B" },
					children:
					[
						{ label: "Four", factory: 0 }
					]
				},
			]);
			this._list.itemRendererFactory = function():DefaultGroupedListItemRenderer
			{
				var itemRenderer:DefaultGroupedListItemRenderer = new DefaultGroupedListItemRenderer();
				itemRenderer.defaultSkin = new Quad(200, 200);
				return itemRenderer;
			};
			this._list.setItemRendererFactoryWithID(FACTORY_ONE, function():DefaultGroupedListItemRenderer
			{
				var itemRenderer:DefaultGroupedListItemRenderer = new DefaultGroupedListItemRenderer();
				itemRenderer.styleNameList.add(CUSTOM_STYLE_NAME);
				itemRenderer.defaultSkin = new Quad(200, 200);
				return itemRenderer;
			});
			this._list.addEventListener(FeathersEventType.RENDERER_ADD, list_rendererAddHandler);
			this._list.addEventListener(FeathersEventType.RENDERER_REMOVE, list_rendererRemoveHandler);
			TestFeathers.starlingRoot.addChild(this._list);
			this._list.validate();
		}

		[After]
		public function cleanup():void
		{
			this._list.removeFromParent(true);
			this._list = null;

			this._itemRendererMap = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testNoFactoryIDFunction():void
		{
			Assert.assertNull("Item renderer factoryID should be null if factoryIDFunction is null.", this.getItemRendererAt(0, 0).factoryID);
			Assert.assertNull("Item renderer factoryID should be null if factoryIDFunction is null.", this.getItemRendererAt(0, 1).factoryID);
			Assert.assertNull("Item renderer factoryID should be null if factoryIDFunction is null.", this.getItemRendererAt(0, 2).factoryID);
		}

		[Test]
		public function testOneArgumentFactoryIDFunction():void
		{
			this._list.factoryIDFunction = oneArgumentFactoryIDFunction;
			this._list.validate();
		}

		[Test]
		public function testThreeArgumentFactoryIDFunction():void
		{
			this._list.factoryIDFunction = threeArgumentFactoryIDFunction;
			this._list.validate();
		}

		[Test]
		public function testFactoryIDFunction():void
		{
			this._list.factoryIDFunction = factoryIDFunction;
			this._list.validate();
			Assert.assertNull("Item renderer factoryID not set to result of factoryIDFunction.", this.getItemRendererAt(0, 0).factoryID);
			Assert.assertNull("Item renderer factoryID not set to result of factoryIDFunction.", this.getItemRendererAt(0, 1).factoryID);
			var itemRenderer2:IGroupedListItemRenderer = this.getItemRendererAt(0, 2);
			Assert.assertStrictlyEquals("Item renderer factoryID not set to result of factoryIDFunction.", FACTORY_ONE, itemRenderer2.factoryID);
			Assert.assertTrue("Incorrect factory called to create item renderer.", itemRenderer2.styleNameList.contains(CUSTOM_STYLE_NAME));
		}

		[Test]
		public function testSetItemAtWithDifferentFactoryID():void
		{
			var itemToSet:Object = { label: "New", factory: 1 };
			this._list.factoryIDFunction = factoryIDFunction;
			this._list.validate();
			this._list.dataProvider.setItemAt(itemToSet, 0, 1);
			this._list.validate();
			var itemRenderer:IGroupedListItemRenderer = this.getItemRendererAt(0, 1);
			Assert.assertStrictlyEquals("Item renderer factoryID not changed to new result of factoryIDFunction after calling setItemAt().", FACTORY_ONE, itemRenderer.factoryID);
			Assert.assertStrictlyEquals("Item renderer data not changed with new result of factoryIDFunction after calling setItemAt().", itemToSet, itemRenderer.data);
		}

		[Test]
		public function testSetTypicalItemAtWithDifferentFactoryID():void
		{
			this._list.typicalItem = this._list.dataProvider.getItemAt(0);
			var itemToSet:Object = { label: "Replacement Item", factory: 1 };
			this._list.factoryIDFunction = factoryIDFunction;
			this._list.validate();
			this._list.dataProvider.setItemAt(itemToSet, 0, 0);
			this._list.validate();
			var itemRenderer:IGroupedListItemRenderer = this.getItemRendererAt(0, 0);
			Assert.assertStrictlyEquals("Typical item renderer factoryID not changed to new result of factoryIDFunction after calling setItemAt().", FACTORY_ONE, itemRenderer.factoryID);
			Assert.assertStrictlyEquals("Typical item renderer data not changed with new result of factoryIDFunction after calling setItemAt().", itemToSet, itemRenderer.data);
		}

		[Test]
		public function testSetItemAtWithDifferentFactoryIDAndRemoveItemBefore():void
		{
			var itemToSet:Object = { label: "Replacement Item", factory: 1 };
			this._list.factoryIDFunction = factoryIDFunction;
			this._list.validate();
			this._list.dataProvider.setItemAt(itemToSet, 0, 1);
			this._list.dataProvider.removeItemAt(0, 0);
			this._list.validate();
			var itemRenderer:IGroupedListItemRenderer = this.getItemRendererAt(0, 0);
			Assert.assertStrictlyEquals("Item renderer factoryID not changed to new result of factoryIDFunction after calling setItemAt() and removeItemAt() for previous item.", FACTORY_ONE, itemRenderer.factoryID);
			Assert.assertStrictlyEquals("Item renderer data not changed with new result of factoryIDFunction after calling setItemAt() and removeItemAt() for previous item.", itemToSet, itemRenderer.data);
		}

		[Test]
		public function testSetItemAtWithDifferentFactoryIDAndAddItemBefore():void
		{
			var itemToAdd:Object = { label: "Added Item", factory: 1 };
			var itemToSet:Object = { label: "Replacement Item", factory: 1 };
			this._list.factoryIDFunction = factoryIDFunction;
			this._list.validate();
			this._list.dataProvider.setItemAt(itemToSet, 0, 0);
			this._list.dataProvider.addItemAt(itemToAdd, 0, 0);
			this._list.validate();
			Assert.assertStrictlyEquals("factoryID of changed typical item not changed to result of factoryIDFunction.", FACTORY_ONE, this.getItemRendererAt(0, 0).factoryID);
			var itemRenderer1:IGroupedListItemRenderer = this.getItemRendererAt(0, 1);
			Assert.assertStrictlyEquals("Item renderer factoryID not changed to new result of factoryIDFunction after calling setItemAt() and addItemAt() for previous item.", FACTORY_ONE, itemRenderer1.factoryID);
			Assert.assertStrictlyEquals("Item renderer data not changed with new result of factoryIDFunction after calling setItemAt() and addItemAt() for previous item.", itemToSet, itemRenderer1.data);
		}

		[Test]
		public function testNewTypicalItemWithDifferentFactoryAndRemoveTypicalItemAfterDispose():void
		{
			var itemToSet:Object = { label: "Replacement Item", factory: 1 };
			this._list.factoryIDFunction = factoryIDFunction;
			this._list.validate();
			this._list.dataProvider.setItemAt(itemToSet, 0, 1);
			this._list.dataProvider.removeItemAt(0, 0);
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

		private function getItemRendererAt(groupIndex:int, itemIndex:int):IGroupedListItemRenderer
		{
			for(var item:Object in this._itemRendererMap)
			{
				var renderer:Object = this._itemRendererMap[item];
				if(renderer is IGroupedListItemRenderer)
				{
					var itemRenderer:IGroupedListItemRenderer = IGroupedListItemRenderer(renderer);
					if(itemRenderer.groupIndex === groupIndex &&
							itemRenderer.itemIndex === itemIndex)
					{
						return itemRenderer;
					}
				}
			}
			return null;
		}

		private function list_rendererAddHandler(event:Event, renderer:Object)
		{
			if(renderer is IGroupedListItemRenderer)
			{
				var itemRenderer:IGroupedListItemRenderer = IGroupedListItemRenderer(renderer);
				this._itemRendererMap[itemRenderer.data] = itemRenderer;
			}
		}

		private function list_rendererRemoveHandler(event:Event, renderer:Object)
		{
			if(renderer is IGroupedListItemRenderer)
			{
				var itemRenderer:IGroupedListItemRenderer = IGroupedListItemRenderer(renderer);
				delete this._itemRendererMap[itemRenderer.data];
			}
		}

		private function factoryIDFunction(item:Object):String
		{
			if(item.factory === 1)
			{
				return FACTORY_ONE;
			}
			return null;
		}

		private function oneArgumentFactoryIDFunction(item:Object):String
		{
			Assert.assertNotNull("Item passed to factoryIDFunction should not be null.", item);
			return null;
		}

		private function threeArgumentFactoryIDFunction(item:Object, groupIndex:int, itemIndex:int):String
		{
			Assert.assertNotNull("Item passed to factoryIDFunction should not be null.", item);
			Assert.assertTrue("Group index passed to factoryIDFunction is out of range.", groupIndex >= 0 && groupIndex < this._list.dataProvider.getLength());
			Assert.assertTrue("Item index passed to factoryIDFunction is out of range.", itemIndex >= 0 && itemIndex < this._list.dataProvider.getLength(groupIndex));
			return null;
		}
	}
}
