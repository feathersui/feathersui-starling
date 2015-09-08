package feathers.tests
{
	import feathers.controls.TextInput;
	import feathers.tests.supportClasses.DisposeFlagQuad;

	import org.flexunit.Assert;

	public class TextInputTests
	{
		private var _input:TextInput;

		[Before]
		public function prepare():void
		{
			this._input = new TextInput();
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
			var backgroundEnabledSkin:DisposeFlagQuad = new DisposeFlagQuad();
			this._input.backgroundEnabledSkin = backgroundEnabledSkin;
			var backgroundDisabledSkin:DisposeFlagQuad = new DisposeFlagQuad();
			this._input.backgroundDisabledSkin = backgroundDisabledSkin;
			var backgroundFocusedSkin:DisposeFlagQuad = new DisposeFlagQuad();
			this._input.backgroundFocusedSkin = backgroundFocusedSkin;
			this._input.validate();
			this._input.dispose();
			Assert.assertTrue("backgroundSkin not disposed when TextInput disposed.", backgroundSkin.isDisposed);
			Assert.assertTrue("backgroundEnabledSkin not disposed when TextInput disposed.", backgroundEnabledSkin.isDisposed);
			Assert.assertTrue("backgroundDisabledSkin not disposed when TextInput disposed.", backgroundDisabledSkin.isDisposed);
			Assert.assertTrue("backgroundFocusedSkin not disposed when TextInput disposed.", backgroundFocusedSkin.isDisposed);
		}

		[Test]
		public function testIconsDisposed():void
		{
			var defaultIcon:DisposeFlagQuad = new DisposeFlagQuad();
			this._input.defaultIcon = defaultIcon;
			var enabledIcon:DisposeFlagQuad = new DisposeFlagQuad();
			this._input.enabledIcon = enabledIcon;
			var focusedIcon:DisposeFlagQuad = new DisposeFlagQuad();
			this._input.focusedIcon = focusedIcon;
			var disabledIcon:DisposeFlagQuad = new DisposeFlagQuad();
			this._input.disabledIcon = disabledIcon;
			this._input.validate();
			this._input.dispose();
			Assert.assertTrue("defaultIcon not disposed when TextInput disposed.", defaultIcon.isDisposed);
			Assert.assertTrue("enabledIcon not disposed when TextInput disposed.", enabledIcon.isDisposed);
			Assert.assertTrue("disabledIcon not disposed when TextInput disposed.", disabledIcon.isDisposed);
			Assert.assertTrue("focusedIcon not disposed when TextInput disposed.", focusedIcon.isDisposed);
		}
	}
}