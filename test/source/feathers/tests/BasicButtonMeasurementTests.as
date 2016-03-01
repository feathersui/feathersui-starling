package feathers.tests
{
	import feathers.controls.BasicButton;
	import feathers.controls.LayoutGroup;

	import org.flexunit.Assert;

	import starling.display.Quad;

	public class BasicButtonMeasurementTests
	{
		private static const BACKGROUND_WIDTH:Number = 10;
		private static const BACKGROUND_HEIGHT:Number = 12;
		private static const COMPLEX_BACKGROUND_WIDTH:Number = 54;
		private static const COMPLEX_BACKGROUND_HEIGHT:Number = 55;
		private static const COMPLEX_BACKGROUND_MIN_WIDTH:Number = 38;
		private static const COMPLEX_BACKGROUND_MIN_HEIGHT:Number = 39;

		private var _button:BasicButton;

		[Before]
		public function prepare():void
		{
			this._button = new BasicButton();
			TestFeathers.starlingRoot.addChild(this._button);
		}

		[After]
		public function cleanup():void
		{
			this._button.removeFromParent(true);
			this._button = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		private function addSimpleBackground():void
		{
			this._button.defaultSkin = new Quad(BACKGROUND_WIDTH, BACKGROUND_HEIGHT, 0xff00ff);
		}

		private function addComplexBackground():void
		{
			var backgroundSkin:LayoutGroup = new LayoutGroup();
			backgroundSkin.width = COMPLEX_BACKGROUND_WIDTH;
			backgroundSkin.height = COMPLEX_BACKGROUND_HEIGHT;
			backgroundSkin.minWidth = COMPLEX_BACKGROUND_MIN_WIDTH;
			backgroundSkin.minHeight = COMPLEX_BACKGROUND_MIN_HEIGHT;
			this._button.defaultSkin = backgroundSkin;
		}

		[Test]
		public function testAutoSizeWithSimpleBackgroundSkin():void
		{
			this.addSimpleBackground();
			this._button.validate();

			Assert.assertStrictlyEquals("The width of the BasicButton was not calculated correctly based on the background width.",
				BACKGROUND_WIDTH, this._button.width);
			Assert.assertStrictlyEquals("The height of the BasicButton was not calculated correctly based on the background height.",
				BACKGROUND_HEIGHT, this._button.height);
			Assert.assertStrictlyEquals("The minWidth of the BasicButton was not calculated correctly based on the background width.",
				BACKGROUND_WIDTH, this._button.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the BasicButton was not calculated correctly based on the background height.",
				BACKGROUND_HEIGHT, this._button.minHeight);
		}

		[Test]
		public function testAutoSizeWithComplexBackground():void
		{
			this.addComplexBackground();
			this._button.validate();

			Assert.assertStrictlyEquals("The width of the BasicButton was not calculated correctly based on the complex background width.",
				COMPLEX_BACKGROUND_WIDTH, this._button.width);
			Assert.assertStrictlyEquals("The height of the BasicButton was not calculated correctly based on the complex background height.",
				COMPLEX_BACKGROUND_HEIGHT, this._button.height);
			Assert.assertStrictlyEquals("The minWidth of the BasicButton was not calculated correctly based on the complex background minWidth.",
				COMPLEX_BACKGROUND_MIN_WIDTH, this._button.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the BasicButton was not calculated correctly based on the complex background minHeight.",
				COMPLEX_BACKGROUND_MIN_HEIGHT, this._button.minHeight);
		}
	}
}
