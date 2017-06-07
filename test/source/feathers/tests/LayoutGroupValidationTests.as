package feathers.tests
{
	import org.flexunit.Assert;

	public class LayoutGroupValidationTests
	{
		private var _group:CustomGroup;

		[Before]
		public function prepare():void
		{
			this._group = new CustomGroup();
			TestFeathers.starlingRoot.addChild(this._group);
		}

		[After]
		public function cleanup():void
		{
			this._group.removeFromParent(true);
			this._group = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testResizeChildBeforeLayout():void
		{
			this._group.updateChildBeforeLayout = true;
			this._group.validate();
			Assert.assertFalse("LayoutGroup: must not be invalid if child resizes before layout is applied.",
				this._group.isInvalid());
		}

		[Test]
		public function testResizeChildAfterLayout():void
		{
			this._group.updateChildBeforeLayout = false;
			this._group.validate();
			Assert.assertTrue("LayoutGroup: must be invalid if child resizes after layout is applied.",
				this._group.isInvalid());
		}
	}
}

import feathers.controls.LayoutGroup;
import feathers.controls.Button;

class CustomGroup extends LayoutGroup
{
	private var _child:Button;

	public var updateChildBeforeLayout:Boolean = true;

	override protected function initialize():void
	{
		super.initialize();

		this._child = new Button();
		this._child.label = "Click Me";
		this.addChild(this._child);
	}

	override protected function draw():void
	{
		if(this.updateChildBeforeLayout)
		{
			this.updateChild();
		}
		super.draw();
		if(!this.updateChildBeforeLayout)
		{
			this.updateChild();
		}
	}

	private function updateChild():void
	{
		this._child.width = Math.random() * 100;
		this._child.width = 150;
	}
}