package feathers.tests
{
	import feathers.controls.Button;
	import feathers.controls.ToggleButton;

	import org.flexunit.Assert;

	public class ToggleButtonDisposeTests
	{
		private var _button:ToggleButton;

		[Before]
		public function prepare():void
		{
			this._button = new ToggleButton();
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
			var defaultSelectedSkin:DisposeFlagSkin = new DisposeFlagSkin();
			this._button.defaultSelectedSkin = defaultSelectedSkin;
			var selectedUpSkin:DisposeFlagSkin = new DisposeFlagSkin();
			this._button.selectedUpSkin = selectedUpSkin;
			var selectedDownSkin:DisposeFlagSkin = new DisposeFlagSkin();
			this._button.selectedDownSkin = selectedDownSkin;
			var selectedHoverSkin:DisposeFlagSkin = new DisposeFlagSkin();
			this._button.selectedHoverSkin = selectedHoverSkin;
			var selectedDisabledSkin:DisposeFlagSkin = new DisposeFlagSkin();
			this._button.selectedDisabledSkin = selectedDisabledSkin;
			this._button.validate();
			this._button.dispose();
			Assert.assertTrue("Button defaultSkin not disposed when Button disposed.", defaultSkin.isDisposed);
			Assert.assertTrue("Button upSkin not disposed when Button disposed.", upSkin.isDisposed);
			Assert.assertTrue("Button downSkin not disposed when Button disposed.", downSkin.isDisposed);
			Assert.assertTrue("Button hoverSkin not disposed when Button disposed.", hoverSkin.isDisposed);
			Assert.assertTrue("Button disabledSkin not disposed when Button disposed.", disabledSkin.isDisposed);
			Assert.assertTrue("Button defaultSelectedSkin not disposed when Button disposed.", defaultSelectedSkin.isDisposed);
			Assert.assertTrue("Button selectedUpSkin not disposed when Button disposed.", selectedUpSkin.isDisposed);
			Assert.assertTrue("Button selectedDownSkin not disposed when Button disposed.", selectedDownSkin.isDisposed);
			Assert.assertTrue("Button selectedHoverSkin not disposed when Button disposed.", selectedHoverSkin.isDisposed);
			Assert.assertTrue("Button selectedDisabledSkin not disposed when Button disposed.", selectedDisabledSkin.isDisposed);
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
			var defaultSelectedIcon:DisposeFlagSkin = new DisposeFlagSkin();
			this._button.defaultSelectedIcon = defaultSelectedIcon;
			var selectedUpIcon:DisposeFlagSkin = new DisposeFlagSkin();
			this._button.selectedUpIcon = selectedUpIcon;
			var selectedDownIcon:DisposeFlagSkin = new DisposeFlagSkin();
			this._button.selectedDownIcon = selectedDownIcon;
			var selectedHoverIcon:DisposeFlagSkin = new DisposeFlagSkin();
			this._button.selectedHoverIcon = selectedHoverIcon;
			var selectedDisabledIcon:DisposeFlagSkin = new DisposeFlagSkin();
			this._button.selectedDisabledIcon = selectedDisabledIcon;
			this._button.validate();
			this._button.dispose();
			Assert.assertTrue("Button defaultIcon not disposed when Button disposed.", defaultIcon.isDisposed);
			Assert.assertTrue("Button upIcon not disposed when Button disposed.", upIcon.isDisposed);
			Assert.assertTrue("Button downIcon not disposed when Button disposed.", downIcon.isDisposed);
			Assert.assertTrue("Button hoverIcon not disposed when Button disposed.", hoverIcon.isDisposed);
			Assert.assertTrue("Button disabledIcon not disposed when Button disposed.", disabledIcon.isDisposed);
			Assert.assertTrue("Button defaultSelectedIcon not disposed when Button disposed.", defaultSelectedIcon.isDisposed);
			Assert.assertTrue("Button selectedUpIcon not disposed when Button disposed.", selectedUpIcon.isDisposed);
			Assert.assertTrue("Button selectedDownIcon not disposed when Button disposed.", selectedDownIcon.isDisposed);
			Assert.assertTrue("Button selectedHoverIcon not disposed when Button disposed.", selectedHoverIcon.isDisposed);
			Assert.assertTrue("Button selectedDisabledIcon not disposed when Button disposed.", selectedDisabledIcon.isDisposed);
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