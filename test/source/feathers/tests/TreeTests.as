package feathers.tests
{
	import feathers.controls.Tree;
	import feathers.controls.renderers.DefaultTreeItemRenderer;
	import starling.display.Quad;
	import feathers.data.HierarchicalCollection;
	import org.flexunit.Assert;
	import starling.events.Event;

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
			Assert.assertTrue("Event.CHANGE was not dispatched", hasChanged);
			Assert.assertFalse("The selectedItem property was not changed",
				beforeSelectedItem === this._tree.selectedItem);
		}
	}
}