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

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testSetValueProgramaticallyWithMinimum():void
		{
			this._progress.minimum = 5;
			this._progress.maximum = 10;
			this._progress.value = 2;
			Assert.assertEquals("Setting value smaller than minimum not changed to minimum.", this._progress.minimum, this._progress.value);
		}

		[Test]
		public function testSetValueProgramaticallyWithMaximum():void
		{
			this._progress.minimum = 5;
			this._progress.maximum = 10;
			this._progress.value = 12;
			Assert.assertEquals("Setting value larger than maximum not changed to maximum.", this._progress.maximum, this._progress.value);
		}
	}
}
