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

		[Test]
		public function testNoInvalidationWhenSettingMinWidthWithExplicitWidth():void
		{
			this._control.width = EXPLICIT_SIZE_SMALLER_THAN_MIN_SIZE;
			this._control.validate();
			this._control.minWidth = MIN_SIZE;
			Assert.assertFalse("The component incorrectly invalidated when setting minWidth, but component has explicitWidth", this._control.isInvalid());
		}

		[Test]
		public function testNoInvalidationWhenSettingMinHeightWithExplicitHeight():void
		{
			this._control.height = EXPLICIT_SIZE_SMALLER_THAN_MIN_SIZE;
			this._control.validate();
			this._control.minHeight = MIN_SIZE;
			Assert.assertFalse("The component incorrectly invalidated when setting minHeight, but component has explicitHeight", this._control.isInvalid());
		}

		[Test]
		public function testNoInvalidationWhenSettingMinWidthWithLargerActualWidth():void
		{
			this._control.addChild(new Quad(EXPLICIT_SIZE_LARGER_THAN_MAX_SIZE, EXPLICIT_SIZE_LARGER_THAN_MAX_SIZE, 0xff00ff));
			this._control.validate();
			this._control.minWidth = MIN_SIZE;
			Assert.assertFalse("The component incorrectly invalidated when setting minWidth, but component actualWidth is currently larger", this._control.isInvalid());
		}

		[Test]
		public function testNoInvalidationWhenSettingMinHeightWithLargerActualHeight():void
		{
			this._control.addChild(new Quad(EXPLICIT_SIZE_LARGER_THAN_MAX_SIZE, EXPLICIT_SIZE_LARGER_THAN_MAX_SIZE, 0xff00ff));
			this._control.validate();
			this._control.minHeight = MIN_SIZE;
			Assert.assertFalse("The component incorrectly invalidated when setting minHeight, but component actualHeight is currently larger", this._control.isInvalid());
		}

		[Test]
		public function testNoInvalidationWhenSettingMinWidthEqualToActualWidth():void
		{
			this._control.addChild(new Quad(MIN_SIZE, MIN_SIZE, 0xff00ff));
			this._control.validate();
			this._control.minWidth = MIN_SIZE;
			Assert.assertFalse("The component incorrectly invalidated when setting minWidth, but component actualWidth is equal", this._control.isInvalid());
		}

		[Test]
		public function testNoInvalidationWhenSettingMinHeightEqualToActualHeight():void
		{
			this._control.addChild(new Quad(MIN_SIZE, MIN_SIZE, 0xff00ff));
			this._control.validate();
			this._control.minHeight = MIN_SIZE;
			Assert.assertFalse("The component incorrectly invalidated when setting minHeight, but component actualHeight is equal", this._control.isInvalid());
		}

		[Test]
		public function testNoInvalidationWhenSettingMaxWidthWithExplicitWidth():void
		{
			this._control.width = EXPLICIT_SIZE_LARGER_THAN_MAX_SIZE;
			this._control.validate();
			this._control.maxWidth = MAX_SIZE;
			Assert.assertFalse("The component incorrectly invalidated when setting maxWidth, but component has explicitWidth", this._control.isInvalid());
		}

		[Test]
		public function testNoInvalidationWhenSettingMaxHeightWithExplicitHeight():void
		{
			this._control.height = EXPLICIT_SIZE_LARGER_THAN_MAX_SIZE;
			this._control.validate();
			this._control.maxHeight = MAX_SIZE;
			Assert.assertFalse("The component incorrectly invalidated when setting maxHeight, but component has explicitHeight", this._control.isInvalid());
		}

		[Test]
		public function testNoInvalidationWhenSettingMaxWidthWithSmallerActualWidth():void
		{
			this._control.addChild(new Quad(EXPLICIT_SIZE_SMALLER_THAN_MIN_SIZE, EXPLICIT_SIZE_SMALLER_THAN_MIN_SIZE, 0xff00ff));
			this._control.validate();
			this._control.maxWidth = MAX_SIZE;
			Assert.assertFalse("The component incorrectly invalidated when setting maxWidth, but component actualWidth is currently smaller", this._control.isInvalid());
		}

		[Test]
		public function testNoInvalidationWhenSettingMaxHeightWithSmallerActualHeight():void
		{
			this._control.addChild(new Quad(EXPLICIT_SIZE_SMALLER_THAN_MIN_SIZE, EXPLICIT_SIZE_SMALLER_THAN_MIN_SIZE, 0xff00ff));
			this._control.validate();
			this._control.maxHeight = MAX_SIZE;
			Assert.assertFalse("The component incorrectly invalidated when setting maxHeight, but component actualHeight is currently smaller", this._control.isInvalid());
		}

		[Test]
		public function testNoInvalidationWhenSettingMaxWidthEqualToActualWidth():void
		{
			this._control.addChild(new Quad(MAX_SIZE, MAX_SIZE, 0xff00ff));
			this._control.validate();
			this._control.maxWidth = MAX_SIZE;
			Assert.assertFalse("The component incorrectly invalidated when setting maxWidth, but component actualWidth is equal", this._control.isInvalid());
		}

		[Test]
		public function testNoInvalidationWhenSettingMaxHeightEqualToActualHeight():void
		{
			this._control.addChild(new Quad(MAX_SIZE, MAX_SIZE, 0xff00ff));
			this._control.validate();
			this._control.maxHeight = MAX_SIZE;
			Assert.assertFalse("The component incorrectly invalidated when setting maxHeight, but component actualHeight is equal", this._control.isInvalid());
		}

		[Test]
		public function testInvalidAfterSettingMinWidthLargerThanActualWidth():void
		{
			this._control.backgroundSkin = new Quad(40, 50);
			this._control.validate();
			this._control.minWidth = 183;
			Assert.assertTrue("The component failed to set invalidate flag after setting minWidth larger than actualWidth",
				this._control.isInvalid());
		}

		[Test]
		public function testInvalidAfterSettingMinHeightLargerThanActualHeight():void
		{
			this._control.backgroundSkin = new Quad(40, 50);
			this._control.validate();
			this._control.minHeight = 183;
			Assert.assertTrue("The component failed to set invalidate flag after setting minHeight larger than actualHeight",
				this._control.isInvalid());
		}
	}
}
