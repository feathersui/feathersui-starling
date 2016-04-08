package feathers.tests
{
	import feathers.controls.BasicButton;
	import feathers.controls.ScrollBar;
	import feathers.controls.TrackLayoutMode;
	import feathers.layout.Direction;

	import org.flexunit.Assert;

	import starling.display.Quad;

	public class ScrollBarHorizontalMeasurementTests
	{
		private static const SINGLE_TRACK_WIDTH:Number = 200;
		private static const SINGLE_TRACK_HEIGHT:Number = 50;
		private static const SINGLE_TRACK_MIN_WIDTH:Number = 150;
		private static const SINGLE_TRACK_MIN_HEIGHT:Number = 30;

		private static const MINIMUM_TRACK_WIDTH:Number = 100;
		private static const MINIMUM_TRACK_HEIGHT:Number = 50;
		private static const MINIMUM_TRACK_MIN_WIDTH:Number = 80;
		private static const MINIMUM_TRACK_MIN_HEIGHT:Number = 20;

		private static const MAXIMUM_TRACK_WIDTH:Number = 110;
		private static const MAXIMUM_TRACK_HEIGHT:Number = 55;
		private static const MAXIMUM_TRACK_MIN_WIDTH:Number = 90;
		private static const MAXIMUM_TRACK_MIN_HEIGHT:Number = 25;

		private static const THUMB_WIDTH:Number = 30;
		private static const SMALL_THUMB_HEIGHT:Number = 40;
		private static const LARGE_THUMB_HEIGHT:Number = 60;

		private static const THUMB_MIN_WIDTH:Number = 18;
		private static const SMALL_THUMB_MIN_HEIGHT:Number = 20;
		private static const LARGE_THUMB_MIN_HEIGHT:Number = 40;

		private static const DECREMENT_BUTTON_WIDTH:Number = 28;
		private static const SMALL_DECREMENT_BUTTON_HEIGHT:Number = 38;
		private static const LARGE_DECREMENT_BUTTON_HEIGHT:Number = 62;

		private static const DECREMENT_BUTTON_MIN_WIDTH:Number = 20;
		private static const SMALL_DECREMENT_BUTTON_MIN_HEIGHT:Number = 18;
		private static const LARGE_DECREMENT_BUTTON_MIN_HEIGHT:Number = 50;

		private static const INCREMENT_BUTTON_WIDTH:Number = 26;
		private static const SMALL_INCREMENT_BUTTON_HEIGHT:Number = 36;
		private static const LARGE_INCREMENT_BUTTON_HEIGHT:Number = 64;

		private static const INCREMENT_BUTTON_MIN_WIDTH:Number = 24;
		private static const SMALL_INCREMENT_BUTTON_MIN_HEIGHT:Number = 14;
		private static const LARGE_INCREMENT_BUTTON_MIN_HEIGHT:Number = 62;

		private var _scrollBar:ScrollBar;

		[Before]
		public function prepare():void
		{
			this._scrollBar = new ScrollBar();
			this._scrollBar.direction = Direction.HORIZONTAL;
			TestFeathers.starlingRoot.addChild(this._scrollBar);
		}

		[After]
		public function cleanup():void
		{
			this._scrollBar.removeFromParent(true);
			this._scrollBar = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testAutoSizeWithTrackLayoutModeSingle():void
		{
			this._scrollBar.trackLayoutMode = TrackLayoutMode.SINGLE;
			this._scrollBar.thumbFactory = function():BasicButton
			{
				var thumb:BasicButton = new BasicButton();
				thumb.defaultSkin = new Quad(THUMB_WIDTH, SMALL_THUMB_HEIGHT, 0xff00ff);
				return thumb;
			};
			this._scrollBar.minimumTrackFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(SINGLE_TRACK_WIDTH, SINGLE_TRACK_HEIGHT, 0xffff00);
				return button;
			};
			this._scrollBar.decrementButtonFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(DECREMENT_BUTTON_WIDTH, SMALL_DECREMENT_BUTTON_HEIGHT, 0x00ff00);
				return button;
			};
			this._scrollBar.incrementButtonFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(INCREMENT_BUTTON_WIDTH, SMALL_INCREMENT_BUTTON_HEIGHT, 0x00ffff);
				return button;
			};
			this._scrollBar.validate();
			Assert.assertStrictlyEquals("The width of the horizontal ScrollBar was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SINGLE.",
				SINGLE_TRACK_WIDTH + DECREMENT_BUTTON_WIDTH + INCREMENT_BUTTON_WIDTH, this._scrollBar.width);
			Assert.assertStrictlyEquals("The minWidth of the horizontal ScrollBar was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SINGLE.",
				SINGLE_TRACK_WIDTH + DECREMENT_BUTTON_WIDTH + INCREMENT_BUTTON_WIDTH, this._scrollBar.minWidth);
			Assert.assertStrictlyEquals("The height of the horizontal ScrollBar was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SINGLE.",
				SINGLE_TRACK_HEIGHT, this._scrollBar.height);
			Assert.assertStrictlyEquals("The minHeight of the horizontal ScrollBar was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SINGLE.",
				SINGLE_TRACK_HEIGHT, this._scrollBar.minHeight);
		}

		[Test]
		public function testAutoSizeHeightWithTrackLayoutModeSingleAndLargerThumb():void
		{
			this._scrollBar.trackLayoutMode = TrackLayoutMode.SINGLE;
			this._scrollBar.thumbFactory = function():BasicButton
			{
				var thumb:BasicButton = new BasicButton();
				thumb.defaultSkin = new Quad(THUMB_WIDTH, LARGE_THUMB_HEIGHT, 0xff00ff);
				return thumb;
			};
			this._scrollBar.minimumTrackFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(SINGLE_TRACK_WIDTH, SINGLE_TRACK_HEIGHT, 0xffff00);
				return button;
			};
			this._scrollBar.decrementButtonFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(DECREMENT_BUTTON_WIDTH, SMALL_DECREMENT_BUTTON_HEIGHT, 0x00ff00);
				return button;
			};
			this._scrollBar.incrementButtonFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(INCREMENT_BUTTON_WIDTH, SMALL_INCREMENT_BUTTON_HEIGHT, 0x00ffff);
				return button;
			};
			this._scrollBar.validate();
			Assert.assertStrictlyEquals("The height of the horizontal ScrollBar was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SINGLE and larger thumb.",
				LARGE_THUMB_HEIGHT, this._scrollBar.height);
			Assert.assertStrictlyEquals("The minHeight of the horizontal ScrollBar was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SINGLE and larger thumb.",
				LARGE_THUMB_HEIGHT, this._scrollBar.minHeight);
		}

		[Test]
		public function testAutoSizeHeightWithTrackLayoutModeSingleAndLargerDecrementButton():void
		{
			this._scrollBar.trackLayoutMode = TrackLayoutMode.SINGLE;
			this._scrollBar.thumbFactory = function():BasicButton
			{
				var thumb:BasicButton = new BasicButton();
				thumb.defaultSkin = new Quad(THUMB_WIDTH, SMALL_THUMB_HEIGHT, 0xff00ff);
				return thumb;
			};
			this._scrollBar.minimumTrackFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(SINGLE_TRACK_WIDTH, SINGLE_TRACK_HEIGHT, 0xffff00);
				return button;
			};
			this._scrollBar.decrementButtonFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(DECREMENT_BUTTON_WIDTH, LARGE_DECREMENT_BUTTON_HEIGHT, 0x00ff00);
				return button;
			};
			this._scrollBar.incrementButtonFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(INCREMENT_BUTTON_WIDTH, SMALL_INCREMENT_BUTTON_HEIGHT, 0x00ffff);
				return button;
			};
			this._scrollBar.validate();
			Assert.assertStrictlyEquals("The height of the horizontal ScrollBar was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SINGLE and larger decrement button.",
				LARGE_DECREMENT_BUTTON_HEIGHT, this._scrollBar.height);
			Assert.assertStrictlyEquals("The minHeight of the horizontal ScrollBar was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SINGLE and larger decrement button.",
				LARGE_DECREMENT_BUTTON_HEIGHT, this._scrollBar.minHeight);
		}

		[Test]
		public function testAutoSizeHeightWithTrackLayoutModeSingleAndLargerIncrementButton():void
		{
			this._scrollBar.trackLayoutMode = TrackLayoutMode.SINGLE;
			this._scrollBar.thumbFactory = function():BasicButton
			{
				var thumb:BasicButton = new BasicButton();
				thumb.defaultSkin = new Quad(THUMB_WIDTH, SMALL_THUMB_HEIGHT, 0xff00ff);
				return thumb;
			};
			this._scrollBar.minimumTrackFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(SINGLE_TRACK_WIDTH, SINGLE_TRACK_HEIGHT, 0xffff00);
				return button;
			};
			this._scrollBar.decrementButtonFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(DECREMENT_BUTTON_WIDTH, SMALL_DECREMENT_BUTTON_HEIGHT, 0x00ff00);
				return button;
			};
			this._scrollBar.incrementButtonFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(INCREMENT_BUTTON_WIDTH, LARGE_INCREMENT_BUTTON_HEIGHT, 0x00ffff);
				return button;
			};
			this._scrollBar.validate();
			Assert.assertStrictlyEquals("The height of the horizontal ScrollBar was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SINGLE and larger increment button.",
				LARGE_INCREMENT_BUTTON_HEIGHT, this._scrollBar.height);
			Assert.assertStrictlyEquals("The minHeight of the horizontal ScrollBar was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SINGLE and larger increment button.",
				LARGE_INCREMENT_BUTTON_HEIGHT, this._scrollBar.minHeight);
		}

		[Test]
		public function testAutoSizeWithTrackLayoutModeSingleAndMinDimensions():void
		{
			this._scrollBar.trackLayoutMode = TrackLayoutMode.SINGLE;
			this._scrollBar.thumbFactory = function():BasicButton
			{
				var thumb:BasicButton = new BasicButton();
				thumb.defaultSkin = new Quad(THUMB_WIDTH, SMALL_THUMB_HEIGHT, 0xff00ff);
				thumb.minWidth = THUMB_MIN_WIDTH;
				thumb.minHeight = SMALL_THUMB_MIN_HEIGHT;
				return thumb;
			};
			this._scrollBar.minimumTrackFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(SINGLE_TRACK_WIDTH, SINGLE_TRACK_HEIGHT, 0xffff00);
				button.minWidth = SINGLE_TRACK_MIN_WIDTH;
				button.minHeight = SINGLE_TRACK_MIN_HEIGHT;
				return button;
			};
			this._scrollBar.decrementButtonFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(DECREMENT_BUTTON_WIDTH, SMALL_DECREMENT_BUTTON_HEIGHT, 0x00ff00);
				button.minWidth = DECREMENT_BUTTON_MIN_WIDTH;
				button.minHeight = SMALL_DECREMENT_BUTTON_MIN_HEIGHT;
				return button;
			};
			this._scrollBar.incrementButtonFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(INCREMENT_BUTTON_WIDTH, SMALL_INCREMENT_BUTTON_HEIGHT, 0x00ffff);
				button.minWidth = INCREMENT_BUTTON_MIN_WIDTH;
				button.minHeight = SMALL_INCREMENT_BUTTON_MIN_HEIGHT;
				return button;
			};
			this._scrollBar.validate();
			Assert.assertStrictlyEquals("The minWidth of the horizontal ScrollBar was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SINGLE and the track's minWidth is set.",
				SINGLE_TRACK_MIN_WIDTH + DECREMENT_BUTTON_MIN_WIDTH + INCREMENT_BUTTON_MIN_WIDTH, this._scrollBar.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the horizontal ScrollBar was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SINGLE and the track's minHeight is set.",
				SINGLE_TRACK_MIN_HEIGHT, this._scrollBar.minHeight);
		}

		[Test]
		public function testAutoSizeMinHeightWithTrackLayoutModeSingleAndLargerThumb():void
		{
			this._scrollBar.trackLayoutMode = TrackLayoutMode.SINGLE;
			this._scrollBar.thumbFactory = function():BasicButton
			{
				var thumb:BasicButton = new BasicButton();
				thumb.defaultSkin = new Quad(THUMB_WIDTH, LARGE_THUMB_HEIGHT, 0xff00ff);
				thumb.minWidth = THUMB_MIN_WIDTH;
				thumb.minHeight = LARGE_THUMB_MIN_HEIGHT;
				return thumb;
			};
			this._scrollBar.minimumTrackFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(SINGLE_TRACK_WIDTH, SINGLE_TRACK_HEIGHT, 0xffff00);
				button.minWidth = SINGLE_TRACK_MIN_WIDTH;
				button.minHeight = SINGLE_TRACK_MIN_HEIGHT;
				return button;
			};
			this._scrollBar.decrementButtonFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(DECREMENT_BUTTON_WIDTH, SMALL_DECREMENT_BUTTON_HEIGHT, 0x00ff00);
				button.minWidth = DECREMENT_BUTTON_MIN_WIDTH;
				button.minHeight = SMALL_DECREMENT_BUTTON_MIN_HEIGHT;
				return button;
			};
			this._scrollBar.incrementButtonFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(INCREMENT_BUTTON_WIDTH, SMALL_INCREMENT_BUTTON_HEIGHT, 0x00ffff);
				button.minWidth = INCREMENT_BUTTON_MIN_WIDTH;
				button.minHeight = SMALL_INCREMENT_BUTTON_MIN_HEIGHT;
				return button;
			};
			this._scrollBar.validate();
			Assert.assertStrictlyEquals("The minHeight of the horizontal ScrollBar was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SINGLE and larger thumb minHeight.",
				LARGE_THUMB_MIN_HEIGHT, this._scrollBar.minHeight);
		}

		[Test]
		public function testAutoSizeMinHeightWithTrackLayoutModeSingleAndLargerDecrementButton():void
		{
			this._scrollBar.trackLayoutMode = TrackLayoutMode.SINGLE;
			this._scrollBar.thumbFactory = function():BasicButton
			{
				var thumb:BasicButton = new BasicButton();
				thumb.defaultSkin = new Quad(THUMB_WIDTH, SMALL_THUMB_HEIGHT, 0xff00ff);
				thumb.minWidth = THUMB_MIN_WIDTH;
				thumb.minHeight = LARGE_THUMB_MIN_HEIGHT;
				return thumb;
			};
			this._scrollBar.minimumTrackFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(SINGLE_TRACK_WIDTH, SINGLE_TRACK_HEIGHT, 0xffff00);
				button.minWidth = SINGLE_TRACK_MIN_WIDTH;
				button.minHeight = SINGLE_TRACK_MIN_HEIGHT;
				return button;
			};
			this._scrollBar.decrementButtonFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(DECREMENT_BUTTON_WIDTH, LARGE_DECREMENT_BUTTON_HEIGHT, 0x00ff00);
				button.minWidth = DECREMENT_BUTTON_MIN_WIDTH;
				button.minHeight = LARGE_DECREMENT_BUTTON_MIN_HEIGHT;
				return button;
			};
			this._scrollBar.incrementButtonFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(INCREMENT_BUTTON_WIDTH, SMALL_INCREMENT_BUTTON_HEIGHT, 0x00ffff);
				button.minWidth = INCREMENT_BUTTON_MIN_WIDTH;
				button.minHeight = SMALL_INCREMENT_BUTTON_MIN_HEIGHT;
				return button;
			};
			this._scrollBar.validate();
			Assert.assertStrictlyEquals("The minHeight of the horizontal ScrollBar was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SINGLE and larger decrement button minHeight.",
				LARGE_DECREMENT_BUTTON_MIN_HEIGHT, this._scrollBar.minHeight);
		}

		[Test]
		public function testAutoSizeMinHeightWithTrackLayoutModeSingleAndLargerIncrementButton():void
		{
			this._scrollBar.trackLayoutMode = TrackLayoutMode.SINGLE;
			this._scrollBar.thumbFactory = function():BasicButton
			{
				var thumb:BasicButton = new BasicButton();
				thumb.defaultSkin = new Quad(THUMB_WIDTH, SMALL_THUMB_HEIGHT, 0xff00ff);
				thumb.minWidth = THUMB_MIN_WIDTH;
				thumb.minHeight = LARGE_THUMB_MIN_HEIGHT;
				return thumb;
			};
			this._scrollBar.minimumTrackFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(SINGLE_TRACK_WIDTH, SINGLE_TRACK_HEIGHT, 0xffff00);
				button.minWidth = SINGLE_TRACK_MIN_WIDTH;
				button.minHeight = SINGLE_TRACK_MIN_HEIGHT;
				return button;
			};
			this._scrollBar.decrementButtonFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(DECREMENT_BUTTON_WIDTH, SMALL_DECREMENT_BUTTON_HEIGHT, 0x00ff00);
				button.minWidth = DECREMENT_BUTTON_MIN_WIDTH;
				button.minHeight = SMALL_DECREMENT_BUTTON_MIN_HEIGHT;
				return button;
			};
			this._scrollBar.incrementButtonFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(INCREMENT_BUTTON_WIDTH, LARGE_INCREMENT_BUTTON_HEIGHT, 0x00ffff);
				button.minWidth = INCREMENT_BUTTON_MIN_WIDTH;
				button.minHeight = LARGE_INCREMENT_BUTTON_MIN_HEIGHT;
				return button;
			};
			this._scrollBar.validate();
			Assert.assertStrictlyEquals("The minHeight of the horizontal ScrollBar was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SINGLE and larger increment button minHeight.",
				LARGE_INCREMENT_BUTTON_MIN_HEIGHT, this._scrollBar.minHeight);
		}

		[Test]
		public function testAutoSizeWithTrackLayoutModeSplit():void
		{
			this._scrollBar.trackLayoutMode = TrackLayoutMode.SPLIT;
			this._scrollBar.thumbFactory = function():BasicButton
			{
				var thumb:BasicButton = new BasicButton();
				thumb.defaultSkin = new Quad(THUMB_WIDTH, SMALL_THUMB_HEIGHT, 0xff00ff);
				return thumb;
			};
			this._scrollBar.minimumTrackFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(MINIMUM_TRACK_WIDTH, MINIMUM_TRACK_HEIGHT, 0xffff00);
				return button;
			};
			this._scrollBar.maximumTrackFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(MAXIMUM_TRACK_WIDTH, MAXIMUM_TRACK_HEIGHT, 0x00ffff);
				return button;
			};
			this._scrollBar.decrementButtonFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(DECREMENT_BUTTON_WIDTH, SMALL_DECREMENT_BUTTON_HEIGHT, 0x00ff00);
				return button;
			};
			this._scrollBar.incrementButtonFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(INCREMENT_BUTTON_WIDTH, SMALL_INCREMENT_BUTTON_HEIGHT, 0x00ffff);
				return button;
			};
			this._scrollBar.validate();
			Assert.assertStrictlyEquals("The width of the horizontal ScrollBar was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SPLIT.",
				MINIMUM_TRACK_WIDTH + MAXIMUM_TRACK_WIDTH + DECREMENT_BUTTON_WIDTH + INCREMENT_BUTTON_WIDTH, this._scrollBar.width);
			Assert.assertStrictlyEquals("The minWidth of the horizontal ScrollBar was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SPLIT.",
				MINIMUM_TRACK_WIDTH + MAXIMUM_TRACK_WIDTH + DECREMENT_BUTTON_WIDTH + INCREMENT_BUTTON_WIDTH, this._scrollBar.minWidth);
			Assert.assertStrictlyEquals("The height of the horizontal ScrollBar was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SPLIT.",
				MAXIMUM_TRACK_HEIGHT, this._scrollBar.height);
			Assert.assertStrictlyEquals("The minHeight of the horizontal ScrollBar was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SPLIT.",
				MAXIMUM_TRACK_HEIGHT, this._scrollBar.minHeight);
		}

		[Test]
		public function testAutoSizeHeightWithTrackLayoutModeSplitAndLargerThumb():void
		{
			this._scrollBar.trackLayoutMode = TrackLayoutMode.SPLIT;
			this._scrollBar.thumbFactory = function():BasicButton
			{
				var thumb:BasicButton = new BasicButton();
				thumb.defaultSkin = new Quad(THUMB_WIDTH, LARGE_THUMB_HEIGHT, 0xff00ff);
				return thumb;
			};
			this._scrollBar.minimumTrackFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(MINIMUM_TRACK_WIDTH, MINIMUM_TRACK_HEIGHT, 0xffff00);
				return button;
			};
			this._scrollBar.maximumTrackFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(MAXIMUM_TRACK_WIDTH, MAXIMUM_TRACK_HEIGHT, 0x00ffff);
				return button;
			};
			this._scrollBar.decrementButtonFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(DECREMENT_BUTTON_WIDTH, SMALL_DECREMENT_BUTTON_HEIGHT, 0x00ff00);
				return button;
			};
			this._scrollBar.incrementButtonFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(INCREMENT_BUTTON_WIDTH, SMALL_INCREMENT_BUTTON_HEIGHT, 0x00ffff);
				return button;
			};
			this._scrollBar.validate();
			Assert.assertStrictlyEquals("The height of the horizontal ScrollBar was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SPLIT and larger thumb.",
				LARGE_THUMB_HEIGHT, this._scrollBar.height);
			Assert.assertStrictlyEquals("The minHeight of the horizontal ScrollBar was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SPLIT and larger thumb.",
				LARGE_THUMB_HEIGHT, this._scrollBar.minHeight);
		}

		[Test]
		public function testAutoSizeHeightWithTrackLayoutModeSplitAndLargerDecrementButton():void
		{
			this._scrollBar.trackLayoutMode = TrackLayoutMode.SPLIT;
			this._scrollBar.thumbFactory = function():BasicButton
			{
				var thumb:BasicButton = new BasicButton();
				thumb.defaultSkin = new Quad(THUMB_WIDTH, SMALL_THUMB_HEIGHT, 0xff00ff);
				return thumb;
			};
			this._scrollBar.minimumTrackFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(MINIMUM_TRACK_WIDTH, MINIMUM_TRACK_HEIGHT, 0xffff00);
				return button;
			};
			this._scrollBar.maximumTrackFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(MAXIMUM_TRACK_WIDTH, MAXIMUM_TRACK_HEIGHT, 0x00ffff);
				return button;
			};
			this._scrollBar.decrementButtonFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(DECREMENT_BUTTON_WIDTH, LARGE_DECREMENT_BUTTON_HEIGHT, 0x00ff00);
				return button;
			};
			this._scrollBar.incrementButtonFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(INCREMENT_BUTTON_WIDTH, SMALL_INCREMENT_BUTTON_HEIGHT, 0x00ffff);
				return button;
			};
			this._scrollBar.validate();
			Assert.assertStrictlyEquals("The height of the horizontal ScrollBar was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SPLIT and larger decrement button.",
				LARGE_DECREMENT_BUTTON_HEIGHT, this._scrollBar.height);
			Assert.assertStrictlyEquals("The minHeight of the horizontal ScrollBar was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SPLIT and larger decrement button.",
				LARGE_DECREMENT_BUTTON_HEIGHT, this._scrollBar.minHeight);
		}

		[Test]
		public function testAutoSizeHeightWithTrackLayoutModeSplitAndLargerIncrementButton():void
		{
			this._scrollBar.trackLayoutMode = TrackLayoutMode.SPLIT;
			this._scrollBar.thumbFactory = function():BasicButton
			{
				var thumb:BasicButton = new BasicButton();
				thumb.defaultSkin = new Quad(THUMB_WIDTH, SMALL_THUMB_HEIGHT, 0xff00ff);
				return thumb;
			};
			this._scrollBar.minimumTrackFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(MINIMUM_TRACK_WIDTH, MINIMUM_TRACK_HEIGHT, 0xffff00);
				return button;
			};
			this._scrollBar.maximumTrackFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(MAXIMUM_TRACK_WIDTH, MAXIMUM_TRACK_HEIGHT, 0x00ffff);
				return button;
			};
			this._scrollBar.decrementButtonFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(DECREMENT_BUTTON_WIDTH, SMALL_DECREMENT_BUTTON_HEIGHT, 0x00ff00);
				return button;
			};
			this._scrollBar.incrementButtonFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(INCREMENT_BUTTON_WIDTH, LARGE_INCREMENT_BUTTON_HEIGHT, 0x00ffff);
				return button;
			};
			this._scrollBar.validate();
			Assert.assertStrictlyEquals("The height of the horizontal ScrollBar was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SPLIT and larger increment button.",
				LARGE_INCREMENT_BUTTON_HEIGHT, this._scrollBar.height);
			Assert.assertStrictlyEquals("The minHeight of the horizontal ScrollBar was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SPLIT and larger increment button.",
				LARGE_INCREMENT_BUTTON_HEIGHT, this._scrollBar.minHeight);
		}

		[Test]
		public function testAutoSizeWithTrackLayoutModeSplitAndMinDimensions():void
		{
			this._scrollBar.trackLayoutMode = TrackLayoutMode.SPLIT;
			this._scrollBar.thumbFactory = function():BasicButton
			{
				var thumb:BasicButton = new BasicButton();
				thumb.defaultSkin = new Quad(THUMB_WIDTH, SMALL_THUMB_HEIGHT, 0xff00ff);
				thumb.minWidth = THUMB_MIN_WIDTH;
				thumb.minHeight = SMALL_THUMB_MIN_HEIGHT;
				return thumb;
			};
			this._scrollBar.minimumTrackFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(MINIMUM_TRACK_WIDTH, MINIMUM_TRACK_HEIGHT, 0xffff00);
				button.minWidth = MINIMUM_TRACK_MIN_WIDTH;
				button.minHeight = MINIMUM_TRACK_MIN_HEIGHT;
				return button;
			};
			this._scrollBar.maximumTrackFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(MAXIMUM_TRACK_WIDTH, MAXIMUM_TRACK_HEIGHT, 0x00ffff);
				button.minWidth = MAXIMUM_TRACK_MIN_WIDTH;
				button.minHeight = MAXIMUM_TRACK_MIN_HEIGHT;
				return button;
			};
			this._scrollBar.decrementButtonFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(DECREMENT_BUTTON_WIDTH, SMALL_DECREMENT_BUTTON_HEIGHT, 0x00ff00);
				button.minWidth = DECREMENT_BUTTON_MIN_WIDTH;
				button.minHeight = SMALL_DECREMENT_BUTTON_MIN_HEIGHT;
				return button;
			};
			this._scrollBar.incrementButtonFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(INCREMENT_BUTTON_WIDTH, SMALL_INCREMENT_BUTTON_HEIGHT, 0x00ffff);
				button.minWidth = INCREMENT_BUTTON_MIN_WIDTH;
				button.minHeight = SMALL_INCREMENT_BUTTON_MIN_HEIGHT;
				return button;
			};
			this._scrollBar.validate();
			Assert.assertStrictlyEquals("The minWidth of the horizontal ScrollBar was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SPLIT when the track's minWidth is set.",
				MINIMUM_TRACK_MIN_WIDTH + MAXIMUM_TRACK_MIN_WIDTH + DECREMENT_BUTTON_MIN_WIDTH + INCREMENT_BUTTON_MIN_WIDTH, this._scrollBar.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the horizontal ScrollBar was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SPLIT when the track's minHeight is set.",
				MAXIMUM_TRACK_MIN_HEIGHT, this._scrollBar.minHeight);
		}

		[Test]
		public function testAutoSizeMinHeightWithTrackLayoutModeSplitAndLargerThumb():void
		{
			this._scrollBar.trackLayoutMode = TrackLayoutMode.SPLIT;
			this._scrollBar.thumbFactory = function():BasicButton
			{
				var thumb:BasicButton = new BasicButton();
				thumb.defaultSkin = new Quad(THUMB_WIDTH, LARGE_THUMB_HEIGHT, 0xff00ff);
				thumb.minWidth = THUMB_MIN_WIDTH;
				thumb.minHeight = LARGE_THUMB_MIN_HEIGHT;
				return thumb;
			};
			this._scrollBar.minimumTrackFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(MINIMUM_TRACK_WIDTH, MINIMUM_TRACK_HEIGHT, 0xffff00);
				button.minWidth = MINIMUM_TRACK_MIN_WIDTH;
				button.minHeight = MINIMUM_TRACK_MIN_HEIGHT;
				return button;
			};
			this._scrollBar.maximumTrackFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(MAXIMUM_TRACK_WIDTH, MAXIMUM_TRACK_HEIGHT, 0x00ffff);
				button.minWidth = MAXIMUM_TRACK_MIN_WIDTH;
				button.minHeight = MAXIMUM_TRACK_MIN_HEIGHT;
				return button;
			};
			this._scrollBar.decrementButtonFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(DECREMENT_BUTTON_WIDTH, SMALL_DECREMENT_BUTTON_HEIGHT, 0x00ff00);
				button.minWidth = DECREMENT_BUTTON_MIN_WIDTH;
				button.minHeight = SMALL_DECREMENT_BUTTON_MIN_HEIGHT;
				return button;
			};
			this._scrollBar.incrementButtonFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(INCREMENT_BUTTON_WIDTH, SMALL_INCREMENT_BUTTON_HEIGHT, 0x00ffff);
				button.minWidth = INCREMENT_BUTTON_MIN_WIDTH;
				button.minHeight = SMALL_INCREMENT_BUTTON_MIN_HEIGHT;
				return button;
			};
			this._scrollBar.validate();
			Assert.assertStrictlyEquals("The minHeight of the horizontal ScrollBar was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SPLIT and larger thumb minHeight.",
				LARGE_THUMB_MIN_HEIGHT, this._scrollBar.minHeight);
		}

		[Test]
		public function testAutoSizeMinHeightWithTrackLayoutModeSplitAndLargerDecrementButton():void
		{
			this._scrollBar.trackLayoutMode = TrackLayoutMode.SPLIT;
			this._scrollBar.thumbFactory = function():BasicButton
			{
				var thumb:BasicButton = new BasicButton();
				thumb.defaultSkin = new Quad(THUMB_WIDTH, SMALL_THUMB_HEIGHT, 0xff00ff);
				thumb.minWidth = THUMB_MIN_WIDTH;
				thumb.minHeight = SMALL_THUMB_MIN_HEIGHT;
				return thumb;
			};
			this._scrollBar.minimumTrackFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(MINIMUM_TRACK_WIDTH, MINIMUM_TRACK_HEIGHT, 0xffff00);
				button.minWidth = MINIMUM_TRACK_MIN_WIDTH;
				button.minHeight = MINIMUM_TRACK_MIN_HEIGHT;
				return button;
			};
			this._scrollBar.maximumTrackFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(MAXIMUM_TRACK_WIDTH, MAXIMUM_TRACK_HEIGHT, 0x00ffff);
				button.minWidth = MAXIMUM_TRACK_MIN_WIDTH;
				button.minHeight = MAXIMUM_TRACK_MIN_HEIGHT;
				return button;
			};
			this._scrollBar.decrementButtonFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(DECREMENT_BUTTON_WIDTH, LARGE_DECREMENT_BUTTON_HEIGHT, 0x00ff00);
				button.minWidth = DECREMENT_BUTTON_MIN_WIDTH;
				button.minHeight = LARGE_DECREMENT_BUTTON_MIN_HEIGHT;
				return button;
			};
			this._scrollBar.incrementButtonFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(INCREMENT_BUTTON_WIDTH, SMALL_INCREMENT_BUTTON_HEIGHT, 0x00ffff);
				button.minWidth = INCREMENT_BUTTON_MIN_WIDTH;
				button.minHeight = SMALL_INCREMENT_BUTTON_MIN_HEIGHT;
				return button;
			};
			this._scrollBar.validate();
			Assert.assertStrictlyEquals("The minHeight of the horizontal ScrollBar was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SPLIT and larger decrement button minHeight.",
				LARGE_DECREMENT_BUTTON_MIN_HEIGHT, this._scrollBar.minHeight);
		}

		[Test]
		public function testAutoSizeMinHeightWithTrackLayoutModeSplitAndLargerIncrementButton():void
		{
			this._scrollBar.trackLayoutMode = TrackLayoutMode.SPLIT;
			this._scrollBar.thumbFactory = function():BasicButton
			{
				var thumb:BasicButton = new BasicButton();
				thumb.defaultSkin = new Quad(THUMB_WIDTH, SMALL_THUMB_HEIGHT, 0xff00ff);
				thumb.minWidth = THUMB_MIN_WIDTH;
				thumb.minHeight = SMALL_THUMB_MIN_HEIGHT;
				return thumb;
			};
			this._scrollBar.minimumTrackFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(MINIMUM_TRACK_WIDTH, MINIMUM_TRACK_HEIGHT, 0xffff00);
				button.minWidth = MINIMUM_TRACK_MIN_WIDTH;
				button.minHeight = MINIMUM_TRACK_MIN_HEIGHT;
				return button;
			};
			this._scrollBar.maximumTrackFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(MAXIMUM_TRACK_WIDTH, MAXIMUM_TRACK_HEIGHT, 0x00ffff);
				button.minWidth = MAXIMUM_TRACK_MIN_WIDTH;
				button.minHeight = MAXIMUM_TRACK_MIN_HEIGHT;
				return button;
			};
			this._scrollBar.decrementButtonFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(DECREMENT_BUTTON_WIDTH, SMALL_DECREMENT_BUTTON_HEIGHT, 0x00ff00);
				button.minWidth = DECREMENT_BUTTON_MIN_WIDTH;
				button.minHeight = SMALL_DECREMENT_BUTTON_MIN_HEIGHT;
				return button;
			};
			this._scrollBar.incrementButtonFactory = function():BasicButton
			{
				var button:BasicButton = new BasicButton();
				button.defaultSkin = new Quad(INCREMENT_BUTTON_WIDTH, LARGE_INCREMENT_BUTTON_HEIGHT, 0x00ffff);
				button.minWidth = INCREMENT_BUTTON_MIN_WIDTH;
				button.minHeight = LARGE_INCREMENT_BUTTON_MIN_HEIGHT;
				return button;
			};
			this._scrollBar.validate();
			Assert.assertStrictlyEquals("The minHeight of the horizontal ScrollBar was not calculated correctly with trackLayoutMode set to TrackLayoutMode.SPLIT and larger increment button minHeight.",
				LARGE_INCREMENT_BUTTON_MIN_HEIGHT, this._scrollBar.minHeight);
		}
	}
}
