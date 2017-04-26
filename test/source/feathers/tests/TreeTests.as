package feathers.tests
{
	import feathers.controls.Tree;
	import feathers.controls.renderers.DefaultTreeItemRenderer;
	import starling.display.Quad;
	import feathers.data.HierarchicalCollection;
	import org.flexunit.Assert;
	import starling.events.Event;
	import flash.geom.Point;
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchPhase;
	import starling.events.TouchEvent;
	import feathers.tests.supportClasses.AssertViewPortBoundsLayout;

	public class TreeTests
	{
		private var _tree:Tree;

		[Before]
		public function prepare():void
		{
			this._tree = new Tree();
			this._tree.dataProvider = new HierarchicalCollection(
			[
				{
					label: "A",
					children:
					[
						{
							label: "One",
							children:
							[
								{label: "I"},
								{label: "II"},
							]
						},
						{label: "Two"},
						{
							label: "Three",
							children:
							[
								{label: "III"},
								{label: "IV"},
								{label: "V"},
							]
						},
					]
				},
				{
					label: "B"
				},
			]);
			this._tree.itemRendererFactory = function():DefaultTreeItemRenderer
			{
				var itemRenderer:DefaultTreeItemRenderer = new DefaultTreeItemRenderer();
				itemRenderer.defaultSkin = new Quad(200, 200);
				return itemRenderer;
			};
			TestFeathers.starlingRoot.addChild(this._tree);
			this._tree.validate();
		}

		[After]
		public function cleanup():void
		{
			this._tree.removeFromParent(true);
			this._tree = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testNullDataProvider():void
		{
			this._tree.dataProvider = null;
			this._tree.validate();
		}

		[Test]
		public function testNullDataProviderWithTypicalItem():void
		{
			this._tree.dataProvider = null;
			this._tree.typicalItem = { label: "Typical Item" };
			this._tree.validate();
		}

		[Test]
		public function testProgrammaticSelectionChange():void
		{
			var beforeSelectedItem:Object = this._tree.selectedItem;
			var hasChanged:Boolean = false;
			this._tree.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._tree.selectedItem = this._tree.dataProvider.getItemAt(0);
			Assert.assertTrue("Tree: Event.CHANGE was not dispatched on set selectedItem", hasChanged);
			Assert.assertFalse("Tree: the selectedItem property was not changed",
				beforeSelectedItem === this._tree.selectedItem);
		}

		[Test]
		public function testInteractiveSelectionChange():void
		{
			var beforeSelectedItem:Object = this._tree.selectedItem;
			var hasChanged:Boolean = false;
			this._tree.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			var position:Point = new Point(10, 210);
			var target:DisplayObject = this._tree.stage.hitTest(position);
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
			Assert.assertTrue("Tree: Event.CHANGE was not dispatched on touch to change selection", hasChanged);
			Assert.assertFalse("Tree: the selectedItem property was not changed",
				beforeSelectedItem === this._tree.selectedItem);
		}

		[Test]
		public function testRemoveItemAfterSelectedItem():void
		{
			var beforeSelectedItem:Object = this._tree.dataProvider.getItemAt(1);
			this._tree.selectedItem = beforeSelectedItem;
			var hasChanged:Boolean = false;
			this._tree.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._tree.dataProvider.removeItemAt(2);
			Assert.assertFalse("Tree: Event.CHANGE was incorrectly dispatched", hasChanged);
			Assert.assertStrictlyEquals("Tree: the selectedItem property was incorrectly changed",
				beforeSelectedItem, this._tree.selectedItem);
		}

		[Test]
		public function testRemoveSelectedItem():void
		{
			var beforeSelectedItem:Object = this._tree.dataProvider.getItemAt(1);
			this._tree.selectedItem = beforeSelectedItem;
			var hasChanged:Boolean = false;
			this._tree.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._tree.dataProvider.removeItemAt(1);
			Assert.assertTrue("Tree: Event.CHANGE was not dispatched on remove selected item", hasChanged);
			Assert.assertStrictlyEquals("Tree: the selectedItem property was not changed to null",
				null, this._tree.selectedItem);
		}

		[Test]
		public function testReplaceSelectedItem():void
		{
			var beforeSelectedItem:Object = this._tree.dataProvider.getItemAt(1);
			this._tree.selectedItem = beforeSelectedItem;
			var hasChanged:Boolean = false;
			this._tree.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._tree.dataProvider.setItemAt({ label: "New Item" }, 1);
			Assert.assertTrue("Tree: Event.CHANGE was not dispatched on replace selected item", hasChanged);
			Assert.assertStrictlyEquals("Tree: the selectedItem property was not changed to null",
				null, this._tree.selectedItem);
		}

		[Test]
		public function testDeselectAllOnNullDataProvider():void
		{
			var beforeSelectedItem:Object = this._tree.dataProvider.getItemAt(1);
			this._tree.selectedItem = beforeSelectedItem;
			var hasChanged:Boolean = false;
			this._tree.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._tree.dataProvider = null;
			Assert.assertTrue("Tree: Event.CHANGE was not dispatched on set dataProvider to null", hasChanged);
			Assert.assertStrictlyEquals("Tree: the selectedItem property was not set to null",
				null, this._tree.selectedItem);
		}

		[Test]
		public function testDeselectAllOnDataProviderRemoveAll():void
		{
			var beforeSelectedItem:Object = this._tree.dataProvider.getItemAt(1);
			this._tree.selectedItem = beforeSelectedItem;
			var hasChanged:Boolean = false;
			this._tree.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._tree.dataProvider.removeAll();
			Assert.assertTrue("Tree: Event.CHANGE was not dispatched on dataProvider.removeAll()", hasChanged);
			Assert.assertStrictlyEquals("Tree: the selectedItem property was not set to null",
				null, this._tree.selectedItem);
		}

		[Test]
		public function testDisposeWithoutChangeEvent():void
		{
			var beforeSelectedItem:Object = this._tree.dataProvider.getItemAt(1);
			this._tree.selectedItem = beforeSelectedItem;
			var hasChanged:Boolean = false;
			this._tree.addEventListener(Event.CHANGE, function(event:Event):void
			{
				hasChanged = true;
			});
			this._tree.dispose();
			Assert.assertFalse("Tree: Event.CHANGE was incorrectly dispatched on dispose()", hasChanged);
		}

		[Test]
		public function testViewPortBoundsValues():void
		{
			this._tree.layout = new AssertViewPortBoundsLayout();
			this._tree.validate();
		}
	}
}