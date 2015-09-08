package feathers.tests
{
	import feathers.controls.List;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;

	import org.flexunit.Assert;

	import starling.display.Quad;
	import starling.events.Event;

	public class ListRendererAddRemoveTests
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
			]);
			this._list.itemRendererFactory = function():DefaultListItemRenderer
			{
				var itemRenderer:DefaultListItemRenderer = new DefaultListItemRenderer();
				itemRenderer.defaultSkin = new Quad(200, 200);
				return itemRenderer;
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
			var itemRendererCount:int = 0;
			this._list.addEventListener(FeathersEventType.RENDERER_ADD, function(event:Event):void
			{
				itemRendererCount++;
			});
			this._list.validate();

			Assert.assertStrictlyEquals("FeathersEventType.RENDERER_ADD not dispatched for all visible items.", this._list.dataProvider.length, itemRendererCount);
		}

		[Test]
		public function testRendererAddEventAfterAddItem():void
		{
			this._list.validate();
			var addedRenderer:Boolean = false;
			var addedItemIndex:int = -1;
			this._list.addEventListener(FeathersEventType.RENDERER_ADD, function(event:Event, itemRenderer:IListItemRenderer):void
			{
				addedRenderer = true;
				addedItemIndex = itemRenderer.index;
			});
			this._list.dataProvider.addItem({label: "New Item"});
			this._list.validate();
			Assert.assertTrue("FeathersEventType.RENDERER_ADD not dispatched after addItem().", addedRenderer);
			Assert.assertStrictlyEquals("FeathersEventType.RENDERER_ADD not dispatched with correct item renderer after addItem().", this._list.dataProvider.length - 1, addedItemIndex);
		}

		[Test]
		public function testRendererRemoveEventAfterRemoveItemAt():void
		{
			var index:int = 1;
			this._list.validate();
			var removedRenderer:Boolean = false;
			var removedItemIndex:int = -1;
			this._list.addEventListener(FeathersEventType.RENDERER_REMOVE, function(event:Event, itemRenderer:IListItemRenderer):void
			{
				removedRenderer = true;
				removedItemIndex = itemRenderer.index;
			});
			this._list.dataProvider.removeItemAt(index);
			this._list.validate();
			Assert.assertTrue("FeathersEventType.RENDERER_REMOVE not dispatched after removeItemAt().", removedRenderer);
			Assert.assertStrictlyEquals("FeathersEventType.RENDERER_REMOVE not dispatched with correct item renderer after removeItemAt().", index, removedItemIndex);
		}

		[Test]
		public function testRendererAddAndRemoveEventsAfterSetItemAt():void
		{
			var index:int = 1;
			this._list.validate();
			var addedRenderer:Boolean = false;
			var addedItemIndex:int = -1;
			this._list.addEventListener(FeathersEventType.RENDERER_ADD, function(event:Event, itemRenderer:IListItemRenderer):void
			{
				addedRenderer = true;
				addedItemIndex = itemRenderer.index;
			});
			var removedRenderer:Boolean = false;
			var removedItemIndex:int = -1;
			this._list.addEventListener(FeathersEventType.RENDERER_REMOVE, function(event:Event, itemRenderer:IListItemRenderer):void
			{
				removedRenderer = true;
				removedItemIndex = itemRenderer.index;
			});
			this._list.dataProvider.setItemAt({label: "New Item"}, index);
			this._list.validate();
			Assert.assertTrue("FeathersEventType.RENDERER_REMOVE not dispatched after setItemAt().", removedRenderer);
			Assert.assertStrictlyEquals("FeathersEventType.RENDERER_REMOVE not dispatched with correct item renderer after setItemAt().", index, removedItemIndex);
			Assert.assertTrue("FeathersEventType.RENDERER_ADD not dispatched after setItemAt().", addedRenderer);
			Assert.assertStrictlyEquals("FeathersEventType.RENDERER_ADD not dispatched with correct item renderer after setItemAt().", index, addedItemIndex);
		}

		[Test]
		public function testRendererRemoveEventsAfterDispose():void
		{
			this._list.validate();
			var itemRendererCount:int = this._list.dataProvider.length;
			var removedRendererCount:int = 0;
			this._list.addEventListener(FeathersEventType.RENDERER_REMOVE, function(event:Event, itemRenderer:IListItemRenderer):void
			{
				removedRendererCount++;
			});
			this._list.dispose();
			Assert.assertStrictlyEquals("FeathersEventType.RENDERER_REMOVE not dispatched for all item renderers after dispose().", itemRendererCount, removedRendererCount);
		}
	}
}
