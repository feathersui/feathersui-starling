package feathers.tests
{
	import org.flexunit.Assert;

	public class ScrollContainerValidationTests
	{
		private var _container:CustomContainer;

		[Before]
		public function prepare():void
		{
			this._container = new CustomContainer();
			TestFeathers.starlingRoot.addChild(this._container);
		}

		[After]
		public function cleanup():void
		{
			this._container.removeFromParent(true);
			this._container = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testResizeChildBeforeLayout():void
		{
			this._container.updateChildBeforeLayout = true;
			this._container.validate();
			Assert.assertFalse("ScrollContainer: must not be invalid if child resizes before layout is applied.",
				this._container.isInvalid());
		}

		[Test]
		public function testResizeChildAfterLayout():void
		{
			this._container.updateChildBeforeLayout = false;
			this._container.validate();
			Assert.assertTrue("ScrollContainer: must be invalid if child resizes after layout is applied.",
				this._container.isInvalid());
		}
	}
}

import feathers.controls.Button;
import feathers.controls.ScrollContainer;

class CustomContainer extends ScrollContainer
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