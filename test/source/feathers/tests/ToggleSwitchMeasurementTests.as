package feathers.tests
{
	import feathers.controls.BasicButton;
	import feathers.controls.ToggleSwitch;
	import feathers.controls.TrackLayoutMode;

	import org.flexunit.Assert;

	import starling.display.Quad;

	public class ToggleSwitchMeasurementTests
	{
		private static const SINGLE_TRACK_WIDTH:Number = 200;
		private static const SINGLE_TRACK_HEIGHT:Number = 50;
		private static const SINGLE_TRACK_MIN_WIDTH:Number = 150;
		private static const SINGLE_TRACK_MIN_HEIGHT:Number = 30;

		private static const ON_TRACK_WIDTH:Number = 100;
		private static const ON_TRACK_HEIGHT:Number = 50;
		private static const ON_TRACK_MIN_WIDTH:Number = 80;
		private static const ON_TRACK_MIN_HEIGHT:Number = 20;

		private static const OFF_TRACK_WIDTH:Number = 110;
		private static const OFF_TRACK_HEIGHT:Number = 55;
		private static const OFF_TRACK_MIN_WIDTH:Number = 90;
		private static const OFF_TRACK_MIN_HEIGHT:Number = 25;

		private static const THUMB_WIDTH:Number = 30;
		private static const SMALL_THUMB_HEIGHT:Number = 40;
		private static const LARGE_THUMB_HEIGHT:Number = 60;

		private static const THUMB_MIN_WIDTH:Number = 20;
		private static const SMALL_THUMB_MIN_HEIGHT:Number = 20;
		private static const LARGE_THUMB_MIN_HEIGHT:Number = 40;
		
		private var _toggle:ToggleSwitch;

		[Before]
		public function prepare():void
		{
			this._toggle = new ToggleSwitch();
			TestFeathers.starlingRoot.addChild(this._toggle);
		}

		[After]
		public function cleanup():void
		{
			this._toggle.removeFromParent(true);
			this._toggle = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testAutoSizeWithTrackLayoutModeSingle():void
		{
			this._toggle.trackLayoutMode = TrackLayoutMode.SINGLE;
			this._toggle.thumbFactory = function():BasicButton
			{
				var thumb:BasicButton = new BasicButton();
				thumb.defaultSkin = new Quad(THUMB_WIDTH, SMALL_THUMB_HEIGHT, 0xff00ff);
				return thumb;
			};
			this._toggle.onTrackFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(SINGLE_TRACK_WIDTH, SINGLE_TRACK_HEIGHT, 0xffff00);
				return button;
			};
			this._toggle.validate();
			Assert.assertStrictlyEquals("The width of the ToggleSwitch was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SINGLE.",
				SINGLE_TRACK_WIDTH, this._toggle.width);
			Assert.assertStrictlyEquals("The minWidth of the ToggleSwitch was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SINGLE.",
				SINGLE_TRACK_WIDTH, this._toggle.minWidth);
			Assert.assertStrictlyEquals("The height of the ToggleSwitch was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SINGLE.",
				SINGLE_TRACK_HEIGHT, this._toggle.height);
			Assert.assertStrictlyEquals("The minHeight of the ToggleSwitch was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SINGLE.",
				SINGLE_TRACK_HEIGHT, this._toggle.minHeight);
		}

		[Test]
		public function testAutoSizeHeightWithTrackLayoutModeSingleAndLargerThumb():void
		{
			this._toggle.trackLayoutMode = TrackLayoutMode.SINGLE;
			this._toggle.thumbFactory = function():BasicButton
			{
				var thumb:BasicButton = new BasicButton();
				thumb.defaultSkin = new Quad(THUMB_WIDTH, LARGE_THUMB_HEIGHT, 0xff00ff);
				return thumb;
			};
			this._toggle.onTrackFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(SINGLE_TRACK_WIDTH, SINGLE_TRACK_HEIGHT, 0xffff00);
				return button;
			};
			this._toggle.validate();
			Assert.assertStrictlyEquals("The height of the ToggleSwitch was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SINGLE and larger thumb.",
				LARGE_THUMB_HEIGHT, this._toggle.height);
			Assert.assertStrictlyEquals("The minHeight of the ToggleSwitch was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SINGLE and larger thumb.",
				LARGE_THUMB_HEIGHT, this._toggle.minHeight);
		}

		[Test]
		public function testAutoSizeWithTrackLayoutModeSingleAndMinDimensions():void
		{
			this._toggle.trackLayoutMode = TrackLayoutMode.SINGLE;
			this._toggle.thumbFactory = function():BasicButton
			{
				var thumb:BasicButton = new BasicButton();
				thumb.defaultSkin = new Quad(THUMB_WIDTH, SMALL_THUMB_HEIGHT, 0xff00ff);
				thumb.minWidth = THUMB_MIN_WIDTH;
				thumb.minHeight = SMALL_THUMB_MIN_HEIGHT;
				return thumb;
			};
			this._toggle.onTrackFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(SINGLE_TRACK_WIDTH, SINGLE_TRACK_HEIGHT, 0xffff00);
				button.minWidth = SINGLE_TRACK_MIN_WIDTH;
				button.minHeight = SINGLE_TRACK_MIN_HEIGHT;
				return button;
			};
			this._toggle.validate();
			Assert.assertStrictlyEquals("The minWidth of the ToggleSwitch was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SINGLE when the track's minWidth is set.",
				SINGLE_TRACK_MIN_WIDTH, this._toggle.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the ToggleSwitch was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SINGLE when the track's minHeight is set.",
				SINGLE_TRACK_MIN_HEIGHT, this._toggle.minHeight);
		}

		[Test]
		public function testAutoSizeMinHeightWithTrackLayoutModeSingleAndLargerThumb():void
		{
			this._toggle.trackLayoutMode = TrackLayoutMode.SINGLE;
			this._toggle.thumbFactory = function():BasicButton
			{
				var thumb:BasicButton = new BasicButton();
				thumb.defaultSkin = new Quad(THUMB_WIDTH, LARGE_THUMB_HEIGHT, 0xff00ff);
				thumb.minWidth = THUMB_MIN_WIDTH;
				thumb.minHeight = LARGE_THUMB_MIN_HEIGHT;
				return thumb;
			};
			this._toggle.onTrackFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(SINGLE_TRACK_WIDTH, SINGLE_TRACK_HEIGHT, 0xffff00);
				button.minWidth = SINGLE_TRACK_MIN_WIDTH;
				button.minHeight = SINGLE_TRACK_MIN_HEIGHT;
				return button;
			};
			this._toggle.validate();
			Assert.assertStrictlyEquals("The minHeight of the ToggleSwitch was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SINGLE and larger thumb minHeight.",
				LARGE_THUMB_MIN_HEIGHT, this._toggle.minHeight);
		}

		[Test]
		public function testAutoSizeWithTrackLayoutModeSplit():void
		{
			this._toggle.trackLayoutMode = TrackLayoutMode.SPLIT;
			this._toggle.thumbFactory = function():BasicButton
			{
				var thumb:BasicButton = new BasicButton();
				thumb.defaultSkin = new Quad(THUMB_WIDTH, SMALL_THUMB_HEIGHT, 0xff00ff);
				return thumb;
			};
			this._toggle.onTrackFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(ON_TRACK_WIDTH, ON_TRACK_HEIGHT, 0xffff00);
				return button;
			};
			this._toggle.offTrackFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(OFF_TRACK_WIDTH, OFF_TRACK_HEIGHT, 0x00ffff);
				return button;
			};
			this._toggle.validate();
			Assert.assertStrictlyEquals("The width of the ToggleSwitch was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SPLIT.",
				ON_TRACK_WIDTH + THUMB_WIDTH / 2, this._toggle.width);
			Assert.assertStrictlyEquals("The minWidth of the ToggleSwitch was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SPLIT.",
				ON_TRACK_WIDTH + THUMB_WIDTH / 2, this._toggle.minWidth);
			Assert.assertStrictlyEquals("The height of the ToggleSwitch was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SPLIT.",
				OFF_TRACK_HEIGHT, this._toggle.height);
			Assert.assertStrictlyEquals("The minHeight of the ToggleSwitch was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SPLIT.",
				OFF_TRACK_HEIGHT, this._toggle.minHeight);
		}

		[Test]
		public function testAutoSizeHeightWithTrackLayoutModeSplitAndLargerThumb():void
		{
			this._toggle.trackLayoutMode = TrackLayoutMode.SPLIT;
			this._toggle.thumbFactory = function():BasicButton
			{
				var thumb:BasicButton = new BasicButton();
				thumb.defaultSkin = new Quad(THUMB_WIDTH, LARGE_THUMB_HEIGHT, 0xff00ff);
				return thumb;
			};
			this._toggle.onTrackFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(ON_TRACK_WIDTH, ON_TRACK_HEIGHT, 0xffff00);
				return button;
			};
			this._toggle.offTrackFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(OFF_TRACK_WIDTH, OFF_TRACK_HEIGHT, 0x00ffff);
				return button;
			};
			this._toggle.validate();
			Assert.assertStrictlyEquals("The height of the ToggleSwitch was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SPLIT and larger thumb.",
				LARGE_THUMB_HEIGHT, this._toggle.height);
			Assert.assertStrictlyEquals("The minHeight of the ToggleSwitch was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SPLIT and larger thumb.",
				LARGE_THUMB_HEIGHT, this._toggle.minHeight);
		}

		[Test]
		public function testAutoSizeWithTrackLayoutModeSplitAndMinDimensions():void
		{
			this._toggle.trackLayoutMode = TrackLayoutMode.SPLIT;
			this._toggle.thumbFactory = function():BasicButton
			{
				var thumb:BasicButton = new BasicButton();
				thumb.defaultSkin = new Quad(THUMB_WIDTH, SMALL_THUMB_HEIGHT, 0xff00ff);
				thumb.minWidth = THUMB_MIN_WIDTH;
				thumb.minHeight = SMALL_THUMB_MIN_HEIGHT;
				return thumb;
			};
			this._toggle.onTrackFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(ON_TRACK_WIDTH, ON_TRACK_HEIGHT, 0xffff00);
				button.minWidth = ON_TRACK_MIN_WIDTH;
				button.minHeight = ON_TRACK_MIN_HEIGHT;
				return button;
			};
			this._toggle.offTrackFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(OFF_TRACK_WIDTH, OFF_TRACK_HEIGHT, 0x00ffff);
				button.minWidth = OFF_TRACK_MIN_WIDTH;
				button.minHeight = OFF_TRACK_MIN_HEIGHT;
				return button;
			};
			this._toggle.validate();
			Assert.assertStrictlyEquals("The minWidth of the ToggleSwitch was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SPLIT when the track's minWidth is set.",
				ON_TRACK_MIN_WIDTH + THUMB_MIN_WIDTH / 2, this._toggle.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the ToggleSwitch was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SPLIT when the track's minHeight is set.",
				OFF_TRACK_MIN_HEIGHT, this._toggle.minHeight);
		}

		[Test]
		public function testAutoSizeMinHeightWithTrackLayoutModeSplitAndLargerThumb():void
		{
			this._toggle.trackLayoutMode = TrackLayoutMode.SPLIT;
			this._toggle.thumbFactory = function():BasicButton
			{
				var thumb:BasicButton = new BasicButton();
				thumb.defaultSkin = new Quad(THUMB_WIDTH, LARGE_THUMB_HEIGHT, 0xff00ff);
				thumb.minWidth = THUMB_MIN_WIDTH;
				thumb.minHeight = LARGE_THUMB_MIN_HEIGHT;
				return thumb;
			};
			this._toggle.onTrackFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(ON_TRACK_WIDTH, ON_TRACK_HEIGHT, 0xffff00);
				button.minWidth = ON_TRACK_MIN_WIDTH;
				button.minHeight = ON_TRACK_MIN_HEIGHT;
				return button;
			};
			this._toggle.offTrackFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(OFF_TRACK_WIDTH, OFF_TRACK_HEIGHT, 0x00ffff);
				button.minWidth = OFF_TRACK_MIN_WIDTH;
				button.minHeight = OFF_TRACK_MIN_HEIGHT;
				return button;
			};
			this._toggle.validate();
			Assert.assertStrictlyEquals("The minHeight of the ToggleSwitch was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SPLIT and larger thumb minHeight.",
				LARGE_THUMB_MIN_HEIGHT, this._toggle.minHeight);
		}
	}
}
