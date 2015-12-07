package feathers.tests
{
	import feathers.controls.List;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;

	import flash.utils.Dictionary;

	import org.flexunit.Assert;

	import starling.display.Quad;
	import starling.events.Event;

	public class ListFactoryIDFunctionTests
	{
		private static const FACTORY_ONE:String = "custom-factory1";
		private static const CUSTOM_STYLE_NAME:String = "custom-style-name";
		
		private var _list:List;
		
		private var _itemRendererMap:Dictionary;

		[Before]
		public function prepare():void
		{
			this._itemRendererMap = new Dictionary(true);
			
			this._list = new List();
			this._list.dataProvider = new ListCollection(
			[
				{ label: "One", factory: 0 },
				{ label: "Two", factory: 0 },
				{ label: "Three", factory: 1 },
			]);
			this._list.itemRendererFactory = function():DefaultListItemRenderer
			{
				var itemRenderer:DefaultListItemRenderer = new DefaultListItemRenderer();
				itemRenderer.defaultSkin = new Quad(200, 200);
				return itemRenderer;
			};
			this._list.setItemRendererFactoryWithID(FACTORY_ONE, function():DefaultListItemRenderer
			{
				var itemRenderer:DefaultListItemRenderer = new DefaultListItemRenderer();
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
			Assert.assertNull("Item renderer factoryID should be null if factoryIDFunction is null.", this.getItemRendererAt(0).factoryID);
			Assert.assertNull("Item renderer factoryID should be null if factoryIDFunction is null.", this.getItemRendererAt(1).factoryID);
			Assert.assertNull("Item renderer factoryID should be null if factoryIDFunction is null.", this.getItemRendererAt(2).factoryID);
		}

		[Test]
		public function testOneArgumentFactoryIDFunction():void
		{
			this._list.factoryIDFunction = oneArgumentFactoryIDFunction;
			this._list.validate();
		}

		[Test]
		public function testTwoArgumentFactoryIDFunction():void
		{
			this._list.factoryIDFunction = twoArgumentFactoryIDFunction;
			this._list.validate();
		}

		[Test]
		public function testFactoryIDFunction():void
		{
			this._list.factoryIDFunction = factoryIDFunction;
			this._list.validate();
			Assert.assertNull("Item renderer factoryID not set to result of factoryIDFunction.", this.getItemRendererAt(0).factoryID);
			Assert.assertNull("Item renderer factoryID not set to result of factoryIDFunction.", this.getItemRendererAt(1).factoryID);
			var itemRenderer2:IListItemRenderer = this.getItemRendererAt(2);
			Assert.assertStrictlyEquals("Item renderer factoryID not set to result of factoryIDFunction.", FACTORY_ONE, itemRenderer2.factoryID);
			Assert.assertTrue("Incorrect factory called to create item renderer.", itemRenderer2.styleNameList.contains(CUSTOM_STYLE_NAME));
		}

		[Test]
		public function testSetItemAtWithDifferentFactoryID():void
		{
			var itemToSet:Object = { label: "New", factory: 1 };
			this._list.factoryIDFunction = factoryIDFunction;
			this._list.validate();
			this._list.dataProvider.setItemAt(itemToSet, 1);
			this._list.validate();
			var itemRenderer:IListItemRenderer = this.getItemRendererAt(1);
			Assert.assertStrictlyEquals("Item renderer factoryID not changed to new result of factoryIDFunction after calling setItemAt().", FACTORY_ONE, itemRenderer.factoryID);
			Assert.assertStrictlyEquals("Item renderer data not changed with new result of factoryIDFunction after calling setItemAt().", itemToSet, itemRenderer.data);
		}

		[Test]
		public function testSetTypicalItemAtWithDifferentFactoryID():void
		{
			var index:int = 0;
			this._list.typicalItem = this._list.dataProvider.getItemAt(index);
			var itemToSet:Object = { label: "Replacement Item", factory: 1 };
			this._list.factoryIDFunction = factoryIDFunction;
			this._list.validate();
			this._list.dataProvider.setItemAt(itemToSet, index);
			this._list.validate();
			var itemRenderer:IListItemRenderer = this.getItemRendererAt(index);
			Assert.assertStrictlyEquals("Typical item renderer factoryID not changed to new result of factoryIDFunction after calling setItemAt().", FACTORY_ONE, itemRenderer.factoryID);
			Assert.assertStrictlyEquals("Typical item renderer data not changed with new result of factoryIDFunction after calling setItemAt().", itemToSet, itemRenderer.data);
		}

		[Test]
		public function testSetItemAtWithDifferentFactoryIDAndRemoveItemBefore():void
		{
			var itemToSet:Object = { label: "Replacement Item", factory: 1 };
			this._list.factoryIDFunction = factoryIDFunction;
			this._list.validate();
			this._list.dataProvider.setItemAt(itemToSet, 1);
			this._list.dataProvider.removeItemAt(0);
			this._list.validate();
			var itemRenderer:IListItemRenderer = this.getItemRendererAt(0);
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
			this._list.dataProvider.setItemAt(itemToSet, 0);
			this._list.dataProvider.addItemAt(itemToAdd, 0);
			this._list.validate();
			Assert.assertStrictlyEquals("factoryID of changed typical item not changed to result of factoryIDFunction.", FACTORY_ONE, this.getItemRendererAt(0).factoryID);
			var itemRenderer1:IListItemRenderer = this.getItemRendererAt(1);
			Assert.assertStrictlyEquals("Item renderer factoryID not changed to new result of factoryIDFunction after calling setItemAt() and addItemAt() for previous item.", FACTORY_ONE, itemRenderer1.factoryID);
			Assert.assertStrictlyEquals("Item renderer data not changed with new result of factoryIDFunction after calling setItemAt() and addItemAt() for previous item.", itemToSet, itemRenderer1.data);
		}

		[Test]
		public function testNewTypicalItemWithDifferentFactoryAndRemoveTypicalItemAfterDispose():void
		{
			var itemToSet:Object = { label: "Replacement Item", factory: 1 };
			this._list.factoryIDFunction = factoryIDFunction;
			this._list.validate();
			this._list.dataProvider.setItemAt(itemToSet, 1);
			this._list.dataProvider.removeItemAt(0);
			this._list.validate();
			var itemRendererCount:int = this._list.dataProvider.length;
			var removedRendererCount:int = 0;
			this._list.addEventListener(FeathersEventType.RENDERER_REMOVE, function(event:Event, itemRenderer:IListItemRenderer):void
			{
				removedRendererCount++;
				Assert.assertNotNull("Item renderer incorrectly has null owner during dispose().", itemRenderer.owner);
				Assert.assertNotNull("Item renderer incorrectly has null data during dispose().", itemRenderer.data);
				Assert.assertTrue("Item renderer incorrectly has negative index during dispose().", itemRenderer.index >= 0);
			});
			this._list.dispose();
			Assert.assertStrictlyEquals("FeathersEventType.RENDERER_REMOVE not dispatched for all item renderers after dispose().", itemRendererCount, removedRendererCount);
		}
		
		private function getItemRendererAt(index:int):IListItemRenderer
		{
			for(var item:Object in this._itemRendererMap)
			{
				var itemRenderer:IListItemRenderer = IListItemRenderer(this._itemRendererMap[item]);
				if(itemRenderer.index === index)
				{
					return itemRenderer;
				}
			}
			return null;
		}
		
		private function list_rendererAddHandler(event:Event, itemRenderer:IListItemRenderer)
		{
			this._itemRendererMap[itemRenderer.data] = itemRenderer;
		}

		private function list_rendererRemoveHandler(event:Event, itemRenderer:IListItemRenderer)
		{
			delete this._itemRendererMap[itemRenderer.data];
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

		private function twoArgumentFactoryIDFunction(item:Object, index:int):String
		{
			Assert.assertNotNull("Item passed to factoryIDFunction should not be null.", item);
			Assert.assertTrue("Index passed to factoryIDFunction is out of range.", index >= 0 && index < this._list.dataProvider.length);
			return null;
		}
	}
}
