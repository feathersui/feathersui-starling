package feathers.tests
{
	import feathers.controls.LayoutGroup;
	import feathers.controls.ProgressBar;

	import org.flexunit.Assert;

	import starling.display.Quad;

	public class ProgressBarMeasurementTests
	{
		private static const BACKGROUND_WIDTH:Number = 200;
		private static const BACKGROUND_HEIGHT:Number = 20;
		private static const FILL_WIDTH:Number = 18;
		private static const FILL_HEIGHT:Number = 14;
		private static const BACKGROUND_WIDTH2:Number = 125;
		private static const BACKGROUND_HEIGHT2:Number = 20;
		private static const BACKGROUND_WIDTH3:Number = 150;
		private static const BACKGROUND_HEIGHT3:Number = 30;

		private static const PADDING_TOP:Number = 4;
		private static const PADDING_RIGHT:Number = 100;
		private static const PADDING_BOTTOM:Number = 3;
		private static const PADDING_LEFT:Number = 90;
		
		private var _progress:ProgressBar;

		[Before]
		public function prepare():void
		{
			this._progress = new ProgressBar();
			this._progress.minimum = 0;
			this._progress.maximum = 10;
			this._progress.value = 5;
			TestFeathers.starlingRoot.addChild(this._progress);
		}

		[After]
		public function cleanup():void
		{
			this._progress.removeFromParent(true);
			this._progress = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}
		
		protected function addSimpleBackgroundSkin():void
		{
			this._progress.backgroundSkin = new Quad(BACKGROUND_WIDTH, BACKGROUND_HEIGHT);
		}

		protected function addSimpleFillSkin():void
		{
			this._progress.fillSkin = new Quad(FILL_WIDTH, FILL_HEIGHT);
		}

		[Test]
		public function testAutoSize():void
		{
			this.addSimpleBackgroundSkin();
			this.addSimpleFillSkin();
			this._progress.validate();
			
			Assert.assertStrictlyEquals("The width of the progress bar was not calculated correctly based on the original background width.",
			BACKGROUND_WIDTH, this._progress.width);
			Assert.assertStrictlyEquals("The height of the progress bar was not calculated correctly based on the original background height.",
			BACKGROUND_HEIGHT, this._progress.height);
			Assert.assertStrictlyEquals("The minWidth of the progress bar was not calculated correctly based on the original background width.",
			BACKGROUND_WIDTH, this._progress.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the progress bar was not calculated correctly based on the original background height.",
			BACKGROUND_HEIGHT, this._progress.minHeight);
		}

		[Test]
		public function testAutoSizeWhereFillAndPaddingIsLargerThanBackground():void
		{
			this.addSimpleBackgroundSkin();
			this.addSimpleFillSkin();
			this._progress.paddingTop = PADDING_TOP;
			this._progress.paddingRight = PADDING_RIGHT;
			this._progress.paddingBottom = PADDING_BOTTOM;
			this._progress.paddingLeft = PADDING_LEFT;
			this._progress.validate();

			Assert.assertStrictlyEquals("The width of the progress bar was not calculated correctly based on the original fill width plus padding left and right.",
			FILL_WIDTH + PADDING_LEFT + PADDING_RIGHT, this._progress.width);
			Assert.assertStrictlyEquals("The height of the progress bar was not calculated correctly based on the original fill height plus padding top and bottom.",
			FILL_HEIGHT + PADDING_TOP + PADDING_BOTTOM, this._progress.height);
			Assert.assertStrictlyEquals("The minWidth of the progress bar was not calculated correctly based on the original fill width plus padding left and right.",
			FILL_WIDTH + PADDING_LEFT + PADDING_RIGHT, this._progress.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the progress bar was not calculated correctly based on the original fill height plus padding top and bottom.",
			FILL_HEIGHT + PADDING_TOP + PADDING_BOTTOM, this._progress.minHeight);
		}

		[Test]
		public function testAutoSizeWithFeathersControlWithMinDimensions():void
		{
			var backgroundSkin:LayoutGroup = new LayoutGroup();
			backgroundSkin.minWidth = BACKGROUND_WIDTH2;
			backgroundSkin.minHeight = BACKGROUND_HEIGHT2;
			backgroundSkin.width = BACKGROUND_WIDTH3;
			backgroundSkin.height = BACKGROUND_HEIGHT3;
			this._progress.backgroundSkin = backgroundSkin;
			this.addSimpleFillSkin();
			this._progress.validate();

			Assert.assertStrictlyEquals("The width of the progress bar was not calculated correctly based on an IFeathersControl background skin width.",
			BACKGROUND_WIDTH3, this._progress.width);
			Assert.assertStrictlyEquals("The height of the progress bar was not calculated correctly based on an IFeathersControl background skin height.",
			BACKGROUND_HEIGHT3, this._progress.height);
			Assert.assertStrictlyEquals("The minWidth of the progress bar was not calculated correctly based on an IFeathersControl background skin minWidth.",
			BACKGROUND_WIDTH2, this._progress.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the progress bar was not calculated correctly based on an IFeathersControl background skin minHeight.",
			BACKGROUND_HEIGHT2, this._progress.minHeight);
		}
	}
}
