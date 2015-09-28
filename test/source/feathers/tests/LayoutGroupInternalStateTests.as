package feathers.tests
{
	import org.flexunit.Assert;

	import starling.display.Quad;
	import starling.events.Event;

	public class LayoutGroupInternalStateTests
	{

		private var _group:ExposedLayoutGroup;

		[Before]
		public function prepare():void
		{
			this._group = new ExposedLayoutGroup();
			TestFeathers.starlingRoot.addChild(this._group);
			this._group.validate();
		}

		[After]
		public function cleanup():void
		{
			this._group.removeFromParent(true);
			this._group = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testItemsLengthAfterAdd():void
		{
			var child:Quad = new Quad(100, 100, 0xff00ff);
			this._group.addChild(child);
			Assert.assertStrictlyEquals("LayoutGroup items not properly updated after adding child.", 1, this._group.internalItems.length);
		}

		[Test]
		public function testItemsLengthAfterRemove():void
		{
			var child:Quad = new Quad(100, 100, 0xff00ff);
			this._group.addChild(child);
			this._group.removeChild(child);
			Assert.assertStrictlyEquals("LayoutGroup items not properly updated after removing child.", 0, this._group.internalItems.length);
		}

		[Test]
		public function testItemsLengthAfterRemoveInRemovedFromStage():void
		{
			var child1:Quad = new Quad(100, 100, 0xff00ff);
			this._group.addChild(child1);
			var child2:Quad = new Quad(100, 100, 0xffff00);
			this._group.addChild(child2);
			child2.addEventListener(Event.REMOVED_FROM_STAGE, function():void
			{
				child1.removeFromParent(true);
			});
			child2.removeFromParent(true);
			Assert.assertStrictlyEquals("LayoutGroup items not properly updated after removing child in Event.REMOVED_FROM_STAGE listener for other child.", 0, this._group.internalItems.length);
		}
	}
}

import feathers.controls.LayoutGroup;

import starling.display.DisplayObject;

class ExposedLayoutGroup extends LayoutGroup
{
	public function get internalItems():Vector.<DisplayObject>
	{
		return this.items;
	}
}