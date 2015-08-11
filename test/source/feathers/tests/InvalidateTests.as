package feathers.tests
{
	import feathers.controls.LayoutGroup;
	import feathers.core.FeathersControl;

	import org.flexunit.Assert;

	public class InvalidateTests
	{
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
		public function testIsInvalidAfterInitialize():void
		{
			Assert.assertTrue("Control must be invalid after initialize", this._control.isInvalid());
			Assert.assertTrue("Control must be invalid with flag after initialize", this._control.isInvalid(FeathersControl.INVALIDATION_FLAG_DATA));
		}

		[Test]
		public function testNotInvalidAfterValidate():void
		{
			this._control.validate();
			Assert.assertFalse("Control must not be invalid after validate", this._control.isInvalid());
			Assert.assertFalse("Control must not be invalid with flag after initialize", this._control.isInvalid(FeathersControl.INVALIDATION_FLAG_DATA));
		}

		[Test]
		public function testInvalidateWithNoFlags():void
		{
			this._control.validate();
			this._control.invalidate();
			Assert.assertTrue("Control must be invalid after invalidate()", this._control.isInvalid());
			Assert.assertTrue("Control must be invalid with flag after invalidate()", this._control.isInvalid(FeathersControl.INVALIDATION_FLAG_DATA));
		}

		[Test]
		public function testInvalidateWithFlag():void
		{
			this._control.validate();
			this._control.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
			Assert.assertTrue("Control must be invalid after invalidate() with flag", this._control.isInvalid());
			Assert.assertTrue("Control must be invalid with flag after invalidate() with same flag", this._control.isInvalid(FeathersControl.INVALIDATION_FLAG_DATA));
			Assert.assertFalse("Control must not be invalid with flag after invalidate() with different flag", this._control.isInvalid(FeathersControl.INVALIDATION_FLAG_STYLES));
		}
	}
}
