package feathers.tests
{
	import feathers.controls.TextArea;
	import feathers.tests.supportClasses.DisposeFlagQuad;

	import org.flexunit.Assert;

	public class TextAreaTests
	{
		private var _input:TextArea;

		[Before]
		public function prepare():void
		{
			this._input = new TextArea();
			TestFeathers.starlingRoot.addChild(this._input);
		}

		[After]
		public function cleanup():void
		{
			this._input.removeFromParent(true);
			this._input = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testSkinsDisposed():void
		{
			var backgroundSkin:DisposeFlagQuad = new DisposeFlagQuad();
			this._input.backgroundSkin = backgroundSkin;
			var backgroundDisabledSkin:DisposeFlagQuad = new DisposeFlagQuad();
			this._input.backgroundDisabledSkin = backgroundDisabledSkin;
			var backgroundFocusedSkin:DisposeFlagQuad = new DisposeFlagQuad();
			this._input.backgroundFocusedSkin = backgroundFocusedSkin;
			this._input.validate();
			this._input.dispose();
			Assert.assertTrue("backgroundSkin not disposed when TextArea disposed.", backgroundSkin.isDisposed);
			Assert.assertTrue("backgroundDisabledSkin not disposed when TextArea disposed.", backgroundDisabledSkin.isDisposed);
			Assert.assertTrue("backgroundFocusedSkin not disposed when TextArea disposed.", backgroundFocusedSkin.isDisposed);
		}
	}
}