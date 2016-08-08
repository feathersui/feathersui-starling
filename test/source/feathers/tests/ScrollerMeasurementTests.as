package feathers.tests
{
	import feathers.controls.LayoutGroup;
	import feathers.controls.Scroller;
	import feathers.tests.supportClasses.ScrollerViewPort;

	import org.flexunit.Assert;

	import starling.display.Quad;

	public class ScrollerMeasurementTests
	{
		private static const BACKGROUND_WIDTH:Number = 200;
		private static const BACKGROUND_HEIGHT:Number = 250;
		
		private static const COMPLEX_BACKGROUND_WIDTH:Number = 540;
		private static const COMPLEX_BACKGROUND_HEIGHT:Number = 550;
		private static const COMPLEX_BACKGROUND_MIN_WIDTH:Number = 380;
		private static const COMPLEX_BACKGROUND_MIN_HEIGHT:Number = 390;
		
		private static const VIEW_PORT_WIDTH:Number = 230;
		private static const VIEW_PORT_HEIGHT:Number = 270;
		private static const VIEW_PORT_MIN_WIDTH:Number = 210;
		private static const VIEW_PORT_MIN_HEIGHT:Number = 260;

		private static const PADDING_TOP:Number = 50;
		private static const PADDING_RIGHT:Number = 54;
		private static const PADDING_BOTTOM:Number = 59;
		private static const PADDING_LEFT:Number = 60;

		private var _scroller:Scroller;
		private var _viewPort:ScrollerViewPort;

		[Before]
		public function prepare():void
		{
			this._viewPort = new ScrollerViewPort();

			this._scroller = new Scroller();
			this._scroller.viewPort = this._viewPort;
			TestFeathers.starlingRoot.addChild(this._scroller);
		}

		[After]
		public function cleanup():void
		{
			this._scroller.removeFromParent(true);
			this._scroller = null;

			this._viewPort = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		private function addSimpleBackground():void
		{
			this._scroller.backgroundSkin = new Quad(BACKGROUND_WIDTH, BACKGROUND_HEIGHT, 0xff00ff);
		}

		private function addComplexBackground():void
		{
			var backgroundSkin:LayoutGroup = new LayoutGroup();
			backgroundSkin.width = COMPLEX_BACKGROUND_WIDTH;
			backgroundSkin.height = COMPLEX_BACKGROUND_HEIGHT;
			backgroundSkin.minWidth = COMPLEX_BACKGROUND_MIN_WIDTH;
			backgroundSkin.minHeight = COMPLEX_BACKGROUND_MIN_HEIGHT;
			this._scroller.backgroundSkin = backgroundSkin;
		}

		[Test]
		public function testAutoSizeWithNoBackgroundSkin():void
		{
			this._scroller.validate();
			Assert.assertStrictlyEquals("The width of the Scroller was not calculated correctly when empty.",
				0, this._scroller.width);
			Assert.assertStrictlyEquals("The height of the Scroller was not calculated correctly when empty.",
				0, this._scroller.height);
			Assert.assertStrictlyEquals("The minWidth of the Scroller was not calculated correctly when empty.",
				0, this._scroller.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Scroller was not calculated correctly when empty.",
				0, this._scroller.minHeight);
		}

		[Test]
		public function testAutoSizeWithPadding():void
		{
			this._scroller.paddingTop = PADDING_TOP;
			this._scroller.paddingRight = PADDING_RIGHT;
			this._scroller.paddingBottom = PADDING_BOTTOM;
			this._scroller.paddingLeft = PADDING_LEFT;
			this._scroller.validate();

			Assert.assertStrictlyEquals("The width of the Scroller was not calculated correctly based on the left and right padding.",
				PADDING_LEFT + PADDING_RIGHT, this._scroller.width);
			Assert.assertStrictlyEquals("The height of the Scroller was not calculated correctly based on the top and bottom padding.",
				PADDING_TOP + PADDING_BOTTOM, this._scroller.height);
			Assert.assertStrictlyEquals("The minWidth of the Scroller was not calculated correctly based on the left and right padding.",
				PADDING_LEFT + PADDING_RIGHT, this._scroller.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Scroller was not calculated correctly based on the top and bottom padding.",
				PADDING_TOP + PADDING_BOTTOM, this._scroller.minHeight);
		}

		[Test]
		public function testAutoSizeWithSimpleBackgroundSkin():void
		{
			this.addSimpleBackground();
			this._scroller.validate();
			
			Assert.assertStrictlyEquals("The width of the Scroller was not calculated correctly based on the background width.",
				BACKGROUND_WIDTH, this._scroller.width);
			Assert.assertStrictlyEquals("The height of the Scroller was not calculated correctly based on the background width.",
				BACKGROUND_HEIGHT, this._scroller.height);
			Assert.assertStrictlyEquals("The minWidth of the Scroller was not calculated correctly based on the background height.",
				BACKGROUND_WIDTH, this._scroller.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Scroller was not calculated correctly based on the background width.",
				BACKGROUND_HEIGHT, this._scroller.minHeight);
		}

		[Test]
		public function testAutoSizeWithComplexBackground():void
		{
			this.addComplexBackground();
			this._scroller.validate();

			Assert.assertStrictlyEquals("The width of the Scroller was not calculated correctly based on the complex background width.",
				COMPLEX_BACKGROUND_WIDTH, this._scroller.width);
			Assert.assertStrictlyEquals("The height of the Scroller was not calculated correctly based on the complex background height.",
				COMPLEX_BACKGROUND_HEIGHT, this._scroller.height);
			Assert.assertStrictlyEquals("The minWidth of the Scroller was not calculated correctly based on the complex background minWidth.",
				COMPLEX_BACKGROUND_MIN_WIDTH, this._scroller.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Scroller was not calculated correctly based on the complex background minHeight.",
				COMPLEX_BACKGROUND_MIN_HEIGHT, this._scroller.minHeight);
		}

		[Test]
		public function testAutoSizeWithViewPort():void
		{
			//the explicit dimensions of the view port are saved when the
			//viewPort property is set, so let's be sure they get saved.
			this._scroller.viewPort = null;
			this._viewPort.width = VIEW_PORT_WIDTH;
			this._viewPort.height = VIEW_PORT_HEIGHT;
			this._viewPort.minWidth = VIEW_PORT_MIN_WIDTH;
			this._viewPort.minHeight = VIEW_PORT_MIN_HEIGHT;
			this._scroller.viewPort = this._viewPort;
			this._scroller.validate();

			Assert.assertStrictlyEquals("The width of the Scroller was not calculated correctly based on the view port width.",
				VIEW_PORT_WIDTH, this._scroller.width);
			Assert.assertStrictlyEquals("The height of the Scroller was not calculated correctly based on the view port height.",
				VIEW_PORT_HEIGHT, this._scroller.height);
			Assert.assertStrictlyEquals("The minWidth of the Scroller was not calculated correctly based on the view port minWidth.",
				VIEW_PORT_MIN_WIDTH, this._scroller.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Scroller was not calculated correctly based on the view port minHeight.",
				VIEW_PORT_MIN_HEIGHT, this._scroller.minHeight);
		}

		[Test]
		public function testAutoSizeWithViewPortWhenMeasureViewPortIsFalse():void
		{
			this._scroller.measureViewPort = false;
			//the explicit dimensions of the view port are saved when the
			//viewPort property is set, so let's be sure they get saved.
			this._scroller.viewPort = null;
			this._viewPort.width = VIEW_PORT_WIDTH;
			this._viewPort.height = VIEW_PORT_HEIGHT;
			this._viewPort.height = VIEW_PORT_HEIGHT;
			this._viewPort.minWidth = VIEW_PORT_MIN_WIDTH;
			this._viewPort.minHeight = VIEW_PORT_MIN_HEIGHT;
			this._scroller.viewPort = this._viewPort;
			this._scroller.validate();

			Assert.assertStrictlyEquals("The width of the Scroller was not calculated correctly when measureViewPort is false.",
				0, this._scroller.width);
			Assert.assertStrictlyEquals("The height of the Scroller was not calculated correctly when measureViewPort is false.",
				0, this._scroller.height);
			Assert.assertStrictlyEquals("The minWidth of the Scroller was not calculated correctly when measureViewPort is false.",
				0, this._scroller.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Scroller was not calculated correctly when measureViewPort is false.",
				0, this._scroller.minHeight);
		}

		[Test]
		public function testMaxScrollPositionChangeWhenViewPortResizesOnScroll():void
		{
			//the explicit dimensions of the view port are saved when the
			//viewPort property is set, so let's be sure they get saved.
			this._scroller.viewPort = null;
			this._viewPort.width = VIEW_PORT_WIDTH;
			this._viewPort.height = VIEW_PORT_HEIGHT;
			this._viewPort.height = VIEW_PORT_HEIGHT;
			this._viewPort.minWidth = VIEW_PORT_MIN_WIDTH;
			this._viewPort.minHeight = VIEW_PORT_MIN_HEIGHT;
			this._scroller.viewPort = this._viewPort;
			this._scroller.validate();
			var oldMaxHSP:Number = this._scroller.maxHorizontalScrollPosition;
			var oldMaxVSP:Number = this._scroller.maxVerticalScrollPosition;
			this._viewPort.resizeOnScroll = true;
			this._scroller.verticalScrollPosition++;
			this._scroller.validate();

			Assert.assertTrue("The maxHorizontalScrollPosition of the Scroller did not change correctly when view port width changed during scrolling.",
				oldMaxHSP !== this._scroller.maxHorizontalScrollPosition);
			Assert.assertTrue("The maxVerticalScrollPosition of the Scroller did not change correctly when view port height changed during scrolling.",
				oldMaxVSP !== this._scroller.maxVerticalScrollPosition);
		}
	}
}
