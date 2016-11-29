package feathers.tests
{
	import feathers.controls.Header;
	import feathers.controls.Label;
	import feathers.tests.supportClasses.DisposeFlagQuad;

	import org.flexunit.Assert;

	public class HeaderTests
	{
		protected var header:Header;

		[Before]
		public function prepare():void
		{
			this.header = new Header();
			TestFeathers.starlingRoot.addChild(this.header);
		}

		[After]
		public function cleanup():void
		{
			this.header.removeFromParent(true);
			this.header = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testSkinsDisposed():void
		{
			var backgroundSkin:DisposeFlagQuad = new DisposeFlagQuad();
			this.header.backgroundSkin = backgroundSkin;
			var backgroundDisabledSkin:DisposeFlagQuad = new DisposeFlagQuad();
			this.header.backgroundDisabledSkin = backgroundDisabledSkin;
			this.header.validate();
			this.header.dispose();
			Assert.assertTrue("backgroundSkin not disposed when Header disposed.", backgroundSkin.isDisposed);
			Assert.assertTrue("backgroundDisabledSkin not disposed when Header disposed.", backgroundDisabledSkin.isDisposed);
		}
	}
}
