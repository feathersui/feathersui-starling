package feathers.tests
{
	import feathers.controls.Button;

	import org.flexunit.Assert;

	public class ButtonDisposeTests
	{
		private var _button:Button;

		[Before]
		public function prepare():void
		{
			this._button = new Button();
			TestFeathers.starlingRoot.addChild(this._button);
		}

		[After]
		public function cleanup():void
		{
			this._button.removeFromParent(true);
			this._button = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testSkinsDisposed():void
		{
			var defaultSkin:DisposeFlagSkin = new DisposeFlagSkin();
			this._button.defaultSkin = defaultSkin;
			var upSkin:DisposeFlagSkin = new DisposeFlagSkin();
			this._button.upSkin = upSkin;
			var downSkin:DisposeFlagSkin = new DisposeFlagSkin();
			this._button.downSkin = downSkin;
			var hoverSkin:DisposeFlagSkin = new DisposeFlagSkin();
			this._button.hoverSkin = hoverSkin;
			var disabledSkin:DisposeFlagSkin = new DisposeFlagSkin();
			this._button.disabledSkin = disabledSkin;
			this._button.validate();
			this._button.dispose();
			Assert.assertTrue("Button defaultSkin not disposed when Button disposed.", defaultSkin.isDisposed);
			Assert.assertTrue("Button upSkin not disposed when Button disposed.", upSkin.isDisposed);
			Assert.assertTrue("Button downSkin not disposed when Button disposed.", downSkin.isDisposed);
			Assert.assertTrue("Button hoverSkin not disposed when Button disposed.", hoverSkin.isDisposed);
			Assert.assertTrue("Button disabledSkin not disposed when Button disposed.", disabledSkin.isDisposed);
		}

		[Test]
		public function testIconsDisposed():void
		{
			var defaultIcon:DisposeFlagSkin = new DisposeFlagSkin();
			this._button.defaultIcon = defaultIcon;
			var upIcon:DisposeFlagSkin = new DisposeFlagSkin();
			this._button.upIcon = upIcon;
			var downIcon:DisposeFlagSkin = new DisposeFlagSkin();
			this._button.downSkin = downIcon;
			var hoverIcon:DisposeFlagSkin = new DisposeFlagSkin();
			this._button.hoverIcon = hoverIcon;
			var disabledIcon:DisposeFlagSkin = new DisposeFlagSkin();
			this._button.disabledIcon = disabledIcon;
			this._button.validate();
			this._button.dispose();
			Assert.assertTrue("Button defaultIcon not disposed when Button disposed.", defaultIcon.isDisposed);
			Assert.assertTrue("Button upIcon not disposed when Button disposed.", upIcon.isDisposed);
			Assert.assertTrue("Button downIcon not disposed when Button disposed.", downIcon.isDisposed);
			Assert.assertTrue("Button hoverIcon not disposed when Button disposed.", hoverIcon.isDisposed);
			Assert.assertTrue("Button disabledIcon not disposed when Button disposed.", disabledIcon.isDisposed);
		}
	}
}

import starling.display.Quad;

class DisposeFlagSkin extends Quad
{
	public function DisposeFlagSkin()
	{
		super(1, 1, 0xff00ff);
	}
	
	public var isDisposed:Boolean = false;
	
	override public function dispose():void
	{
		super.dispose();
		this.isDisposed = true;
	}
}