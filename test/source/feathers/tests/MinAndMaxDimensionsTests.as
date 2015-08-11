package feathers.tests
{
	import feathers.controls.LayoutGroup;

	import org.flexunit.Assert;

	import starling.display.Quad;

	public class MinAndMaxDimensionsTests
	{
		private static const MIN_SIZE:Number = 100;
		private static const EXPLICIT_SIZE_SMALLER_THAN_MIN_SIZE:Number = 50;
		private static const MAX_SIZE:Number = 100;
		private static const EXPLICIT_SIZE_LARGER_THAN_MAX_SIZE:Number = 150;
		
		private var _control:LayoutGroup;

		[Before]
		public function prepare():void
		{
			this._control = new LayoutGroup();
			TestFeathers.starlingRoot.addChild(this._control);
		}

		[After]
		public function cleanup():void
		{
			this._control.removeFromParent(true);
			this._control = null;
			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testMinWidth():void
		{
			this._control.minWidth = MIN_SIZE;
			this._control.validate();
			Assert.assertStrictlyEquals("The width of the component was not calculated correctly because it is smaller than the minWidth", this._control.width, MIN_SIZE);
		}

		[Test]
		public function testExplicitWidthWithMinWidth():void
		{
			this._control.minWidth = MIN_SIZE;
			this._control.width = EXPLICIT_SIZE_SMALLER_THAN_MIN_SIZE;
			this._control.validate();
			Assert.assertStrictlyEquals("The minWidth was incorrectly used to calculate the component's width when the width was set explicitly", this._control.width, EXPLICIT_SIZE_SMALLER_THAN_MIN_SIZE);
		}

		[Test]
		public function testMinHeight():void
		{
			this._control.minHeight = MIN_SIZE;
			this._control.validate();
			Assert.assertStrictlyEquals("The height of the component was not calculated correctly because it is smaller than the minHeight", this._control.height, MIN_SIZE);
		}

		[Test]
		public function testExplicitHeightWithMinHeight():void
		{
			this._control.minHeight = MIN_SIZE;
			this._control.height = EXPLICIT_SIZE_SMALLER_THAN_MIN_SIZE;
			this._control.validate();
			Assert.assertStrictlyEquals("The minHeight was incorrectly used to calculate the component's height when the height was set explicitly", this._control.height, EXPLICIT_SIZE_SMALLER_THAN_MIN_SIZE);
		}

		[Test]
		public function testMaxWidth():void
		{
			this._control.addChild(new Quad(EXPLICIT_SIZE_LARGER_THAN_MAX_SIZE, EXPLICIT_SIZE_LARGER_THAN_MAX_SIZE, 0xff00ff));
			this._control.maxWidth = MAX_SIZE;
			this._control.validate();
			Assert.assertStrictlyEquals("The width of the component was not calculated correctly because it is larger than the maxWidth", this._control.width, MAX_SIZE);
		}

		[Test]
		public function testExplicitWidthWithMaxWidth():void
		{
			this._control.maxWidth = MAX_SIZE;
			this._control.width = EXPLICIT_SIZE_LARGER_THAN_MAX_SIZE;
			this._control.validate();
			Assert.assertStrictlyEquals("The maxWidth was incorrectly used to calculate the component's width when the width was set explicitly", this._control.width, EXPLICIT_SIZE_LARGER_THAN_MAX_SIZE);
		}

		[Test]
		public function testMaxHeight():void
		{
			this._control.addChild(new Quad(EXPLICIT_SIZE_LARGER_THAN_MAX_SIZE, EXPLICIT_SIZE_LARGER_THAN_MAX_SIZE, 0xff00ff));
			this._control.maxHeight = MAX_SIZE;
			this._control.validate();
			Assert.assertStrictlyEquals("The height was set explicitly, but the value after validation is different when using maxHeight", this._control.height, MAX_SIZE);
		}

		[Test]
		public function testExplicitHeightWithMaxHeight():void
		{
			this._control.maxHeight = MAX_SIZE;
			this._control.height = EXPLICIT_SIZE_LARGER_THAN_MAX_SIZE;
			this._control.validate();
			Assert.assertStrictlyEquals("The maxHeight was incorrectly used to calculate the component's height when the height was set explicitly", this._control.height, EXPLICIT_SIZE_LARGER_THAN_MAX_SIZE);
		}
	}
}
