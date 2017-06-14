package feathers.tests
{
	import feathers.controls.Callout;
	import feathers.controls.Label;
	import feathers.controls.LayoutGroup;
	import feathers.layout.RelativePosition;

	import org.flexunit.Assert;

	import starling.display.DisplayObject;
	import starling.display.Quad;

	public class CalloutMeasurementTests
	{
		//note: the background width is purposefully smaller than the item width
		private static const BACKGROUND_WIDTH:Number = 200;
		//note: the background height is purposefully larger than the item height
		private static const BACKGROUND_HEIGHT:Number = 250;
		private static const BACKGROUND_MIN_WIDTH:Number = 180;
		private static const BACKGROUND_MIN_HEIGHT:Number = 140;

		//note: the content width is purposefully larger than the background width
		private static const CONTENT_WIDTH:Number = 210;
		//note: the content height is purposefully smaller than the background height
		private static const CONTENT_HEIGHT:Number = 160;
		private static const SMALL_CONTENT_WIDTH:Number = 50;
		private static const SMALL_CONTENT_HEIGHT:Number = 60;
		private static const CONTENT_MIN_WIDTH:Number = 160;
		private static const CONTENT_MIN_HEIGHT:Number = 150;
		
		private static const TOP_ARROW_WIDTH:Number = 20;
		private static const TOP_ARROW_HEIGHT:Number = 8;
		private static const RIGHT_ARROW_WIDTH:Number = 14;
		private static const RIGHT_ARROW_HEIGHT:Number = 22;
		private static const BOTTOM_ARROW_WIDTH:Number = 19;
		private static const BOTTOM_ARROW_HEIGHT:Number = 12;
		private static const LEFT_ARROW_WIDTH:Number = 23;
		private static const LEFT_ARROW_HEIGHT:Number = 16;

		private static const ORIGIN_WIDTH:Number = 44;
		private static const ORIGIN_HEIGHT:Number = 42;
		
		private var _callout:Callout;
		private var _origin:DisplayObject;

		[Before]
		public function prepare():void
		{
			this._callout = new Callout();
			this._callout.disposeContent = true;
			TestFeathers.starlingRoot.addChild(this._callout);
		}

		[After]
		public function cleanup():void
		{
			this._callout.removeFromParent(true);
			this._callout = null;

			if(this._origin)
			{
				this._origin.removeFromParent(true);
				this._origin = null;
			}

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		private function addArrows():void
		{
			this._callout.topArrowSkin = new Quad(TOP_ARROW_WIDTH, TOP_ARROW_HEIGHT);
			this._callout.rightArrowSkin = new Quad(RIGHT_ARROW_WIDTH, RIGHT_ARROW_HEIGHT);
			this._callout.bottomArrowSkin = new Quad(BOTTOM_ARROW_WIDTH, BOTTOM_ARROW_HEIGHT);
			this._callout.leftArrowSkin = new Quad(LEFT_ARROW_WIDTH, LEFT_ARROW_HEIGHT);
		}

		private function addSimpleBackground():void
		{
			this._callout.backgroundSkin = new Quad(BACKGROUND_WIDTH, BACKGROUND_HEIGHT);
		}

		private function addComplexBackground():void
		{
			var backgroundSkin:LayoutGroup = new LayoutGroup();
			backgroundSkin.setSize(BACKGROUND_WIDTH, BACKGROUND_HEIGHT);
			backgroundSkin.minWidth = BACKGROUND_MIN_WIDTH;
			backgroundSkin.minHeight = BACKGROUND_MIN_HEIGHT;
			this._callout.backgroundSkin = backgroundSkin;
		}
		
		private function addSimpleContent():void
		{
			this._callout.content = new Quad(CONTENT_WIDTH, CONTENT_HEIGHT);
		}
		
		private function addSmallAutoSizeContent():void
		{
			var content:LayoutGroup = new LayoutGroup();
			content.backgroundSkin = new Quad(SMALL_CONTENT_WIDTH, SMALL_CONTENT_HEIGHT);
			this._callout.content = content;
		}

		private function addComplexContent():void
		{
			var content:LayoutGroup = new LayoutGroup();
			content.setSize(CONTENT_WIDTH, CONTENT_HEIGHT);
			content.minWidth = CONTENT_MIN_WIDTH;
			content.minHeight = CONTENT_MIN_HEIGHT;
			this._callout.content = content;
		}
		
		private function addOrigin():void
		{
			this._origin = new Quad(ORIGIN_WIDTH, ORIGIN_HEIGHT);
			TestFeathers.starlingRoot.addChild(this._origin);
			this._callout.origin = this._origin;
		}

		[Test]
		public function testAutoSizeNoContentNoBackground():void
		{
			this._callout.validate();
			Assert.assertStrictlyEquals("The width of the Callout was not calculated correctly when empty.",
				0, this._callout.width);
			Assert.assertStrictlyEquals("The height of the Callout was not calculated correctly when empty.",
				0, this._callout.height);
			Assert.assertStrictlyEquals("The minWidth of the Callout was not calculated correctly when empty.",
				0, this._callout.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Callout was not calculated correctly when empty.",
				0, this._callout.minHeight);
		}

		[Test]
		public function testAutoSizeWithSimpleBackgroundAndNoContent():void
		{
			this.addSimpleBackground();
			this._callout.validate();
			Assert.assertStrictlyEquals("The width of the Callout was not calculated correctly with background skin and no content.",
				BACKGROUND_WIDTH, this._callout.width);
			Assert.assertStrictlyEquals("The height of the Callout was not calculated correctly with background skin and no content.",
				BACKGROUND_HEIGHT, this._callout.height);
			Assert.assertStrictlyEquals("The minWidth of the Callout was not calculated correctly with background skin and no content.",
				BACKGROUND_WIDTH, this._callout.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Callout was not calculated correctly with background skin and no content.",
				BACKGROUND_HEIGHT, this._callout.minHeight);
		}

		[Test]
		public function testAutoSizeWithComplexBackgroundAndNoContent():void
		{
			this.addComplexBackground();
			this._callout.validate();
			Assert.assertStrictlyEquals("The width of the Callout was not calculated correctly with complex background skin and no content.",
				BACKGROUND_WIDTH, this._callout.width);
			Assert.assertStrictlyEquals("The height of the Callout was not calculated correctly with complex background skin and no content.",
				BACKGROUND_HEIGHT, this._callout.height);
			Assert.assertStrictlyEquals("The minWidth of the Callout was not calculated correctly with complex background skin and no content.",
				BACKGROUND_MIN_WIDTH, this._callout.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Callout was not calculated correctly with complex background skin and no content.",
				BACKGROUND_MIN_HEIGHT, this._callout.minHeight);
		}

		[Test]
		public function testAutoSizeWithSimpleContent():void
		{
			this.addSimpleContent();
			this._callout.validate();
			Assert.assertStrictlyEquals("The width of the Callout was not calculated correctly.",
				CONTENT_WIDTH, this._callout.width);
			Assert.assertStrictlyEquals("The height of the Callout was not calculated correctly.",
				CONTENT_HEIGHT, this._callout.height);
			Assert.assertStrictlyEquals("The minWidth of the Callout was not calculated correctly.",
				CONTENT_WIDTH, this._callout.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Callout was not calculated correctly.",
				CONTENT_HEIGHT, this._callout.minHeight);
		}

		[Test]
		public function testAutoSizeWithComplexContent():void
		{
			this.addComplexContent();
			this._callout.validate();
			Assert.assertStrictlyEquals("The width of the Callout was not calculated correctly.",
				CONTENT_WIDTH, this._callout.width);
			Assert.assertStrictlyEquals("The height of the Callout was not calculated correctly.",
				CONTENT_HEIGHT, this._callout.height);
			Assert.assertStrictlyEquals("The minWidth of the Callout was not calculated correctly.",
				CONTENT_MIN_WIDTH, this._callout.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Callout was not calculated correctly.",
				CONTENT_MIN_HEIGHT, this._callout.minHeight);
		}

		[Test]
		public function testAutoSizeWithSimpleContentAndBackground():void
		{
			this.addSimpleBackground();
			this.addSimpleContent();
			this._callout.validate();
			Assert.assertStrictlyEquals("The width of the Callout was not calculated correctly.",
				CONTENT_WIDTH, this._callout.width);
			Assert.assertStrictlyEquals("The height of the Callout was not calculated correctly.",
				BACKGROUND_HEIGHT, this._callout.height);
			Assert.assertStrictlyEquals("The minWidth of the Callout was not calculated correctly.",
				CONTENT_WIDTH, this._callout.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Callout was not calculated correctly.",
				BACKGROUND_HEIGHT, this._callout.minHeight);
		}

		[Test]
		public function testAutoSizeWithComplexContentAndBackground():void
		{
			this.addComplexBackground();
			this.addComplexContent();
			this._callout.validate();
			Assert.assertStrictlyEquals("The width of the Callout was not calculated correctly.",
				CONTENT_WIDTH, this._callout.width);
			Assert.assertStrictlyEquals("The height of the Callout was not calculated correctly.",
				BACKGROUND_HEIGHT, this._callout.height);
			Assert.assertStrictlyEquals("The minWidth of the Callout was not calculated correctly.",
				BACKGROUND_MIN_WIDTH, this._callout.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Callout was not calculated correctly.",
				CONTENT_MIN_HEIGHT, this._callout.minHeight);
		}

		[Test]
		public function testAutoSizeWithTopArrow():void
		{
			this.addSimpleBackground();
			this.addArrows();
			this._callout.arrowPosition = RelativePosition.TOP;
			this._callout.validate();
			Assert.assertStrictlyEquals("The width of the Callout was not calculated correctly.",
				BACKGROUND_WIDTH, this._callout.width);
			Assert.assertStrictlyEquals("The height of the Callout was not calculated correctly.",
				BACKGROUND_HEIGHT + TOP_ARROW_HEIGHT, this._callout.height);
			Assert.assertStrictlyEquals("The minWidth of the Callout was not calculated correctly.",
				BACKGROUND_WIDTH, this._callout.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Callout was not calculated correctly.",
				BACKGROUND_HEIGHT + TOP_ARROW_HEIGHT, this._callout.minHeight);
		}

		[Test]
		public function testAutoSizeWithRightArrow():void
		{
			this.addSimpleBackground();
			this.addArrows();
			this._callout.arrowPosition = RelativePosition.RIGHT;
			this._callout.validate();
			Assert.assertStrictlyEquals("The width of the Callout was not calculated correctly.",
				BACKGROUND_WIDTH + RIGHT_ARROW_WIDTH, this._callout.width);
			Assert.assertStrictlyEquals("The height of the Callout was not calculated correctly.",
				BACKGROUND_HEIGHT, this._callout.height);
			Assert.assertStrictlyEquals("The minWidth of the Callout was not calculated correctly.",
				BACKGROUND_WIDTH + RIGHT_ARROW_WIDTH, this._callout.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Callout was not calculated correctly.",
				BACKGROUND_HEIGHT, this._callout.minHeight);
		}

		[Test]
		public function testAutoSizeWithBottomArrow():void
		{
			this.addSimpleBackground();
			this.addArrows();
			this._callout.arrowPosition = RelativePosition.BOTTOM;
			this._callout.validate();
			Assert.assertStrictlyEquals("The width of the Callout was not calculated correctly.",
				BACKGROUND_WIDTH, this._callout.width);
			Assert.assertStrictlyEquals("The height of the Callout was not calculated correctly.",
				BACKGROUND_HEIGHT + BOTTOM_ARROW_HEIGHT, this._callout.height);
			Assert.assertStrictlyEquals("The minWidth of the Callout was not calculated correctly.",
				BACKGROUND_WIDTH, this._callout.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Callout was not calculated correctly.",
				BACKGROUND_HEIGHT + BOTTOM_ARROW_HEIGHT, this._callout.minHeight);
		}

		[Test]
		public function testAutoSizeWithLeftArrow():void
		{
			this.addSimpleBackground();
			this.addArrows();
			this._callout.arrowPosition = RelativePosition.LEFT;
			this._callout.validate();
			Assert.assertStrictlyEquals("The width of the Callout was not calculated correctly.",
				BACKGROUND_WIDTH + LEFT_ARROW_WIDTH, this._callout.width);
			Assert.assertStrictlyEquals("The height of the Callout was not calculated correctly.",
				BACKGROUND_HEIGHT, this._callout.height);
			Assert.assertStrictlyEquals("The minWidth of the Callout was not calculated correctly.",
				BACKGROUND_WIDTH + LEFT_ARROW_WIDTH, this._callout.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Callout was not calculated correctly.",
				BACKGROUND_HEIGHT, this._callout.minHeight);
		}

		[Test]
		public function testWrappingLabel():void
		{
			var label:Label = new Label();
			label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
			label.wordWrap = true;

			var label2:Label = new Label();
			label2.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
			label2.validate();
			label2.dispose();

			this._callout.content = label;
			this._callout.validate();

			Assert.assertTrue("Callout: when content is set to Label with wordWrap true, the numLines should be greater than 1",
				label.numLines > 1);
			Assert.assertTrue("Callout: when content is set to Label with wordWrap true, the height should be greater than the height for 1 line",
				label.height > label2.height);
		}

		[Test]
		/**
		 * issue #1573
		 */
		public function testMoveOriginAndBackgroundLargerThanContent():void
		{
			this.addSimpleBackground();
			this.addSmallAutoSizeContent();
			this.addOrigin();
			this._callout.supportedPositions = new <String>[RelativePosition.RIGHT];
			this._callout.validate();
			//make sure that the position of the arrow does not change when
			//moving the origin, or this test won't be able to catch the bug
			//that it's trying to catch. the callout cannot invalidate!
			this._origin.x += 50;
			this._origin.stage.starling.nextFrame();
			Assert.assertFalse("Callout: must not be invalid.",
				this._callout.isInvalid());
			Assert.assertStrictlyEquals("Callout: content width must be changed if background width is larger",
				BACKGROUND_WIDTH, this._callout.content.width);
			Assert.assertStrictlyEquals("Callout: content height must be changed if background height is larger",
				BACKGROUND_HEIGHT, this._callout.content.height);
		}
	}
}
