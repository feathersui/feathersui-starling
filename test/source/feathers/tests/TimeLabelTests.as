package feathers.tests
{
	import feathers.media.MediaTimeMode;
	import feathers.media.TimeLabel;
	import feathers.tests.supportClasses.CustomMediaPlayer;

	import org.flexunit.Assert;

	public class TimeLabelTests
	{
		private static const CURRENT_TIME:int = 3737;
		private static const TOTAL_TIME:int = 5254;
		
		private var _label:TimeLabel;
		private var _mediaPlayer:CustomMediaPlayer;

		[Before]
		public function prepare():void
		{
			this._mediaPlayer = new CustomMediaPlayer(TOTAL_TIME);
			
			this._label = new TimeLabel();
			this._label.mediaPlayer = this._mediaPlayer;
			TestFeathers.starlingRoot.addChild(this._label);
			this._label.validate();
		}

		[After]
		public function cleanup():void
		{
			this._label.removeFromParent(true);
			this._label = null;
			
			this._mediaPlayer.removeEventListeners();
			this._mediaPlayer = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		/**
		 * Issue #1325
		 */
		public function testTotalTimeText():void
		{
			this._label.displayMode = MediaTimeMode.TOTAL_TIME;
			this._label.validate();
			Assert.assertStrictlyEquals("TimeLabel total time not displayed correctly", "1:27:34", this._label.text);
		}

		[Test]
		public function testCurrentTimeText():void
		{
			this._label.displayMode = MediaTimeMode.CURRENT_TIME;
			this._mediaPlayer.seek(CURRENT_TIME);
			this._label.validate();
			Assert.assertStrictlyEquals("TimeLabel total time not displayed correctly", "1:02:17", this._label.text);
		}

		[Test]
		public function testCurrentTimeAndTotalTimeText():void
		{
			this._label.displayMode = MediaTimeMode.CURRENT_AND_TOTAL_TIMES;
			this._mediaPlayer.seek(CURRENT_TIME);
			this._label.validate();
			Assert.assertStrictlyEquals("TimeLabel total time not displayed correctly", "1:02:17 / 1:27:34", this._label.text);
		}
	}
}
