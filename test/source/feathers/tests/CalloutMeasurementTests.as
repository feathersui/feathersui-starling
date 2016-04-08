package feathers.tests
{
	import feathers.controls.Callout;
	import feathers.controls.LayoutGroup;
	import feathers.layout.RelativePosition;

	import org.flexunit.Assert;

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
		
		private var _callout:Callout;

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

		private function addComplexContent():void
		{
			var content:LayoutGroup = new LayoutGroup();
			content.setSize(CONTENT_WIDTH, CONTENT_HEIGHT);
			content.minWidth = CONTENT_MIN_WIDTH;
			content.minHeight = CONTENT_MIN_HEIGHT;
			this._callout.content = content;
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
	}
}
