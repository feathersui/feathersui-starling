package feathers.tests
{
	import feathers.controls.BasicButton;
	import feathers.controls.Slider;
	import feathers.controls.TrackLayoutMode;
	import feathers.layout.Direction;

	import org.flexunit.Assert;

	import starling.display.Quad;

	public class SliderVerticalMeasurementTests
	{
		private static const SINGLE_TRACK_WIDTH:Number = 50;
		private static const SINGLE_TRACK_HEIGHT:Number = 200;
		private static const SINGLE_TRACK_MIN_WIDTH:Number = 30;
		private static const SINGLE_TRACK_MIN_HEIGHT:Number = 150;

		private static const MINIMUM_TRACK_WIDTH:Number = 50;
		private static const MINIMUM_TRACK_HEIGHT:Number = 100;
		private static const MINIMUM_TRACK_MIN_WIDTH:Number = 20;
		private static const MINIMUM_TRACK_MIN_HEIGHT:Number = 80;

		private static const MAXIMUM_TRACK_WIDTH:Number = 55;
		private static const MAXIMUM_TRACK_HEIGHT:Number = 110;
		private static const MAXIMUM_TRACK_MIN_WIDTH:Number = 25;
		private static const MAXIMUM_TRACK_MIN_HEIGHT:Number = 90;

		private static const SMALL_THUMB_WIDTH:Number = 40;
		private static const LARGE_THUMB_WIDTH:Number = 60;
		private static const THUMB_HEIGHT:Number = 30;

		private static const SMALL_THUMB_MIN_WIDTH:Number = 20;
		private static const LARGE_THUMB_MIN_WIDTH:Number = 40;
		private static const THUMB_MIN_HEIGHT:Number = 18;

		private var _slider:Slider;

		[Before]
		public function prepare():void
		{
			this._slider = new Slider();
			this._slider.direction = Direction.VERTICAL;
			TestFeathers.starlingRoot.addChild(this._slider);
		}

		[After]
		public function cleanup():void
		{
			this._slider.removeFromParent(true);
			this._slider = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testAutoSizeWithTrackLayoutModeSingle():void
		{
			this._slider.trackLayoutMode = TrackLayoutMode.SINGLE;
			this._slider.thumbFactory = function():BasicButton
			{
				var thumb:BasicButton = new BasicButton();
				thumb.defaultSkin = new Quad(SMALL_THUMB_WIDTH, THUMB_HEIGHT, 0xff00ff);
				return thumb;
			};
			this._slider.minimumTrackFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(SINGLE_TRACK_WIDTH, SINGLE_TRACK_HEIGHT, 0xffff00);
				return button;
			};
			this._slider.validate();
			Assert.assertStrictlyEquals("The width of the vertical Slider was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SINGLE.",
				SINGLE_TRACK_WIDTH, this._slider.width);
			Assert.assertStrictlyEquals("The minWidth of the vertical Slider was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SINGLE.",
				SINGLE_TRACK_WIDTH, this._slider.minWidth);
			Assert.assertStrictlyEquals("The height of the vertical Slider was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SINGLE.",
				SINGLE_TRACK_HEIGHT, this._slider.height);
			Assert.assertStrictlyEquals("The minHeight of the vertical Slider was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SINGLE.",
				SINGLE_TRACK_HEIGHT, this._slider.minHeight);
		}

		[Test]
		public function testAutoSizeWidthWithTrackLayoutModeSingleAndLargerThumb():void
		{
			this._slider.trackLayoutMode = TrackLayoutMode.SINGLE;
			this._slider.thumbFactory = function():BasicButton
			{
				var thumb:BasicButton = new BasicButton();
				thumb.defaultSkin = new Quad(LARGE_THUMB_WIDTH, THUMB_HEIGHT, 0xff00ff);
				return thumb;
			};
			this._slider.minimumTrackFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(SINGLE_TRACK_WIDTH, SINGLE_TRACK_HEIGHT, 0xffff00);
				return button;
			};
			this._slider.validate();
			Assert.assertStrictlyEquals("The width of the vertical Slider was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SINGLE and larger thumb.",
				LARGE_THUMB_WIDTH, this._slider.width);
			Assert.assertStrictlyEquals("The minWidth of the vertical Slider was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SINGLE and larger thumb.",
				LARGE_THUMB_WIDTH, this._slider.minWidth);
		}

		[Test]
		public function testAutoSizeWithTrackLayoutModeSingleAndMinDimensions():void
		{
			this._slider.trackLayoutMode = TrackLayoutMode.SINGLE;
			this._slider.thumbFactory = function():BasicButton
			{
				var thumb:BasicButton = new BasicButton();
				thumb.defaultSkin = new Quad(SMALL_THUMB_WIDTH, THUMB_HEIGHT, 0xff00ff);
				thumb.minWidth = SMALL_THUMB_MIN_WIDTH;
				thumb.minHeight = THUMB_MIN_HEIGHT;
				return thumb;
			};
			this._slider.minimumTrackFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(SINGLE_TRACK_WIDTH, SINGLE_TRACK_HEIGHT, 0xffff00);
				button.minWidth = SINGLE_TRACK_MIN_WIDTH;
				button.minHeight = SINGLE_TRACK_MIN_HEIGHT;
				return button;
			};
			this._slider.validate();
			Assert.assertStrictlyEquals("The minWidth of the vertical Slider was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SINGLE and the track's minWidth is set.",
				SINGLE_TRACK_MIN_WIDTH, this._slider.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the vertical Slider was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SINGLE and the track's minHeight is set.",
				SINGLE_TRACK_MIN_HEIGHT, this._slider.minHeight);
		}

		[Test]
		public function testAutoSizeMinWidthWithTrackLayoutModeSingleAndLargerThumb():void
		{
			this._slider.trackLayoutMode = TrackLayoutMode.SINGLE;
			this._slider.thumbFactory = function():BasicButton
			{
				var thumb:BasicButton = new BasicButton();
				thumb.defaultSkin = new Quad(SMALL_THUMB_WIDTH, THUMB_HEIGHT, 0xff00ff);
				thumb.minWidth = LARGE_THUMB_MIN_WIDTH;
				thumb.minHeight = THUMB_MIN_HEIGHT;
				return thumb;
			};
			this._slider.minimumTrackFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(SINGLE_TRACK_WIDTH, SINGLE_TRACK_HEIGHT, 0xffff00);
				button.minWidth = SINGLE_TRACK_MIN_WIDTH;
				button.minHeight = SINGLE_TRACK_MIN_HEIGHT;
				return button;
			};
			this._slider.validate();
			Assert.assertStrictlyEquals("The minWidth of the vertical Slider was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SINGLE and larger thumb minHeight.",
				LARGE_THUMB_MIN_WIDTH, this._slider.minWidth);
		}

		[Test]
		public function testAutoSizeWithTrackLayoutModeSplit():void
		{
			this._slider.trackLayoutMode = TrackLayoutMode.SPLIT;
			this._slider.thumbFactory = function():BasicButton
			{
				var thumb:BasicButton = new BasicButton();
				thumb.defaultSkin = new Quad(SMALL_THUMB_WIDTH, THUMB_HEIGHT, 0xff00ff);
				return thumb;
			};
			this._slider.minimumTrackFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(MINIMUM_TRACK_WIDTH, MINIMUM_TRACK_HEIGHT, 0xffff00);
				return button;
			};
			this._slider.maximumTrackFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(MAXIMUM_TRACK_WIDTH, MAXIMUM_TRACK_HEIGHT, 0x00ffff);
				return button;
			};
			this._slider.validate();
			Assert.assertStrictlyEquals("The width of the vertical Slider was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SPLIT.",
				MAXIMUM_TRACK_WIDTH, this._slider.width);
			Assert.assertStrictlyEquals("The minWidth of the vertical Slider was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SPLIT.",
				MAXIMUM_TRACK_WIDTH, this._slider.minWidth);
			Assert.assertStrictlyEquals("The height of the vertical Slider was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SPLIT.",
				MAXIMUM_TRACK_HEIGHT + THUMB_HEIGHT / 2, this._slider.height);
			Assert.assertStrictlyEquals("The minHeight of the vertical Slider was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SPLIT.",
				MAXIMUM_TRACK_HEIGHT + THUMB_HEIGHT / 2, this._slider.minHeight);
		}

		[Test]
		public function testAutoSizeWidthWithTrackLayoutModeSplitAndLargerThumb():void
		{
			this._slider.trackLayoutMode = TrackLayoutMode.SPLIT;
			this._slider.thumbFactory = function():BasicButton
			{
				var thumb:BasicButton = new BasicButton();
				thumb.defaultSkin = new Quad(LARGE_THUMB_WIDTH, THUMB_HEIGHT, 0xff00ff);
				return thumb;
			};
			this._slider.minimumTrackFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(MINIMUM_TRACK_WIDTH, MINIMUM_TRACK_HEIGHT, 0xffff00);
				return button;
			};
			this._slider.maximumTrackFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(MAXIMUM_TRACK_WIDTH, MAXIMUM_TRACK_HEIGHT, 0x00ffff);
				return button;
			};
			this._slider.validate();
			Assert.assertStrictlyEquals("The width of the vertical Slider was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SPLIT and larger thumb.",
				LARGE_THUMB_WIDTH, this._slider.width);
			Assert.assertStrictlyEquals("The minWidth of the vertical Slider was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SPLIT and larger thumb.",
				LARGE_THUMB_WIDTH, this._slider.minWidth);
		}

		[Test]
		public function testAutoSizeWithTrackLayoutModeSplitAndMinDimensions():void
		{
			this._slider.trackLayoutMode = TrackLayoutMode.SPLIT;
			this._slider.thumbFactory = function():BasicButton
			{
				var thumb:BasicButton = new BasicButton();
				thumb.defaultSkin = new Quad(SMALL_THUMB_WIDTH, THUMB_HEIGHT, 0xff00ff);
				thumb.minWidth = SMALL_THUMB_MIN_WIDTH;
				thumb.minHeight = THUMB_MIN_HEIGHT;
				return thumb;
			};
			this._slider.minimumTrackFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(MINIMUM_TRACK_WIDTH, MINIMUM_TRACK_HEIGHT, 0xffff00);
				button.minWidth = MINIMUM_TRACK_MIN_WIDTH;
				button.minHeight = MINIMUM_TRACK_MIN_HEIGHT;
				return button;
			};
			this._slider.maximumTrackFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(MAXIMUM_TRACK_WIDTH, MAXIMUM_TRACK_HEIGHT, 0x00ffff);
				button.minWidth = MAXIMUM_TRACK_MIN_WIDTH;
				button.minHeight = MAXIMUM_TRACK_MIN_HEIGHT;
				return button;
			};
			this._slider.validate();
			Assert.assertStrictlyEquals("The minWidth of the vertical Slider was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SPLIT when the track's minWidth is set.",
				MAXIMUM_TRACK_MIN_WIDTH, this._slider.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the vertical Slider was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SPLIT when the track's minHeight is set.",
				MAXIMUM_TRACK_MIN_HEIGHT + THUMB_MIN_HEIGHT / 2, this._slider.minHeight);
		}

		[Test]
		public function testAutoSizeMinWidthtWithTrackLayoutModeSplitAndLargerThumb():void
		{
			this._slider.trackLayoutMode = TrackLayoutMode.SPLIT;
			this._slider.thumbFactory = function():BasicButton
			{
				var thumb:BasicButton = new BasicButton();
				thumb.defaultSkin = new Quad(LARGE_THUMB_WIDTH, THUMB_HEIGHT, 0xff00ff);
				thumb.minWidth = LARGE_THUMB_MIN_WIDTH;
				thumb.minHeight = THUMB_MIN_HEIGHT;
				return thumb;
			};
			this._slider.minimumTrackFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(MINIMUM_TRACK_WIDTH, MINIMUM_TRACK_HEIGHT, 0xffff00);
				button.minWidth = MINIMUM_TRACK_MIN_WIDTH;
				button.minHeight = MINIMUM_TRACK_MIN_HEIGHT;
				return button;
			};
			this._slider.maximumTrackFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(MAXIMUM_TRACK_WIDTH, MAXIMUM_TRACK_HEIGHT, 0x00ffff);
				button.minWidth = MAXIMUM_TRACK_MIN_WIDTH;
				button.minHeight = MAXIMUM_TRACK_MIN_HEIGHT;
				return button;
			};
			this._slider.validate();
			Assert.assertStrictlyEquals("The minWidth of the vertical Slider was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SPLIT and larger thumb minHeight.",
				LARGE_THUMB_MIN_WIDTH, this._slider.minWidth);
		}
	}
}
