package feathers.tests
{
	import feathers.controls.Label;
	import feathers.tests.supportClasses.DisposeFlagQuad;

	import org.flexunit.Assert;

	public class LabelTests
	{
		protected var label:Label;

		[Before]
		public function prepare():void
		{
			this.label = new Label();
			TestFeathers.starlingRoot.addChild(this.label);
		}

		[After]
		public function cleanup():void
		{
			this.label.removeFromParent(true);
			this.label = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testSkinsDisposed():void
		{
			var backgroundSkin:DisposeFlagQuad = new DisposeFlagQuad();
			this.label.backgroundSkin = backgroundSkin;
			var backgroundDisabledSkin:DisposeFlagQuad = new DisposeFlagQuad();
			this.label.backgroundDisabledSkin = backgroundDisabledSkin;
			this.label.validate();
			this.label.dispose();
			Assert.assertTrue("backgroundSkin not disposed when Label disposed.", backgroundSkin.isDisposed);
			Assert.assertTrue("backgroundDisabledSkin not disposed when Label disposed.", backgroundDisabledSkin.isDisposed);
		}
	}
}
