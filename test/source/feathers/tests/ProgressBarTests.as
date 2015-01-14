package feathers.tests
{
	import feathers.controls.ProgressBar;

	import org.flexunit.Assert;

	import starling.display.Quad;

	public class ProgressBarTests
	{
		private static const BACKGROUND_WIDTH:Number = 200;
		private static const BACKGROUND_HEIGHT:Number = 20;
		private static const FILL_WIDTH:Number = 18;
		private static const FILL_HEIGHT:Number = 14;

		private var _progress:ProgressBar;

		[Before]
		public function prepare():void
		{
			this._progress = new ProgressBar();
			this._progress.minimum = 0;
			this._progress.maximum = 10;
			this._progress.value = 5;
			this._progress.backgroundSkin = new Quad(BACKGROUND_WIDTH, BACKGROUND_HEIGHT);
			this._progress.fillSkin = new Quad(FILL_WIDTH, FILL_HEIGHT);
			TestFeathers.starlingRoot.addChild(this._progress);
			this._progress.validate();
		}

		[After]
		public function cleanup():void
		{
			this._progress.removeFromParent(true);
			this._progress = null;
		}

		[Test]
		public function testAutoSize():void
		{
			Assert.assertStrictlyEquals("The width of the progress bar was not calculated correctly.",
				BACKGROUND_WIDTH, this._progress.width);
			Assert.assertStrictlyEquals("The height of the progress bar was not calculated correctly.",
				BACKGROUND_HEIGHT, this._progress.height);
		}
	}
}
