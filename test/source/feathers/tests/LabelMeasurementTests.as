package feathers.tests
{
	import feathers.controls.Label;
	import feathers.controls.LayoutGroup;
	import feathers.controls.text.BitmapFontTextRenderer;

	import org.flexunit.Assert;

	import starling.display.Quad;

	public class LabelMeasurementTests
	{
		private static const SIMPLE_TEXT:String = "Huge Mayo";
		
		private static const BACKGROUND_WIDTH:Number = 200;
		private static const BACKGROUND_HEIGHT:Number = 250;
		private static const BACKGROUND_WIDTH2:Number = 125;
		private static const BACKGROUND_HEIGHT2:Number = 100;
		private static const BACKGROUND_WIDTH3:Number = 150;
		private static const BACKGROUND_HEIGHT3:Number = 175;
		
		private static const PADDING_TOP:Number = 4;
		private static const PADDING_RIGHT:Number = 10;
		private static const PADDING_BOTTOM:Number = 3;
		private static const PADDING_LEFT:Number = 16;
		
		protected var textRenderer:BitmapFontTextRenderer;
		protected var label:Label;

		[Before]
		public function prepare():void
		{
			this.label = new Label();
			TestFeathers.starlingRoot.addChild(this.label);

			this.textRenderer = new BitmapFontTextRenderer();
			TestFeathers.starlingRoot.addChild(this.textRenderer);
		}

		[After]
		public function cleanup():void
		{
			this.textRenderer.removeFromParent(true);
			this.textRenderer = null;

			this.label.removeFromParent(true);
			this.label = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		protected function addSimpleBackgroundSkin():void
		{
			this.label.backgroundSkin = new Quad(BACKGROUND_WIDTH, BACKGROUND_HEIGHT);
		}

		protected function addComplexBackgroundSkin():void
		{
			var backgroundSkin:LayoutGroup = new LayoutGroup();
			backgroundSkin.minWidth = BACKGROUND_WIDTH2;
			backgroundSkin.minHeight = BACKGROUND_HEIGHT2;
			backgroundSkin.width = BACKGROUND_WIDTH3;
			backgroundSkin.height = BACKGROUND_HEIGHT3;
			this.label.backgroundSkin = backgroundSkin;
		}

		[Test]
		public function testAutoSize():void
		{
			this.textRenderer.text = SIMPLE_TEXT;
			this.textRenderer.validate();
			
			this.label.text = SIMPLE_TEXT;
			this.label.validate();

			Assert.assertStrictlyEquals("Label width not equal to text renderer width", this.textRenderer.width, this.label.width);
			Assert.assertStrictlyEquals("Label height not equal to text renderer height", this.textRenderer.height, this.label.height);
			Assert.assertStrictlyEquals("Label minWidth not equal to 0 when explicitWidth not set", 0, this.label.minWidth);
			Assert.assertStrictlyEquals("Label minHeight not equal to text renderer height", this.textRenderer.height, this.label.minHeight);
		}

		[Test]
		public function testAutoSizeWithPadding():void
		{
			this.textRenderer.text = SIMPLE_TEXT;
			this.textRenderer.validate();

			this.label.paddingTop = PADDING_TOP;
			this.label.paddingRight = PADDING_RIGHT;
			this.label.paddingBottom = PADDING_BOTTOM;
			this.label.paddingLeft = PADDING_LEFT;
			this.label.text = SIMPLE_TEXT;
			this.label.validate();

			Assert.assertStrictlyEquals("Label width not equal to text renderer width plus padding left and padding right", this.textRenderer.width + PADDING_LEFT + PADDING_RIGHT, this.label.width);
			Assert.assertStrictlyEquals("Label height not equal to text renderer height plus padding top and padding bottom", this.textRenderer.height + PADDING_TOP + PADDING_BOTTOM, this.label.height);
			Assert.assertStrictlyEquals("Label minWidth not equal padding left and padding right", PADDING_LEFT + PADDING_RIGHT, this.label.minWidth);
			Assert.assertStrictlyEquals("Label minHeight not equal to text renderer height plus padding top and padding bottom", this.textRenderer.height + PADDING_TOP + PADDING_BOTTOM, this.label.minHeight);
		}

		[Test]
		public function testAutoSizeWithSimpleBackground():void
		{
			this.addSimpleBackgroundSkin();
			this.label.text = SIMPLE_TEXT;
			this.label.validate();

			Assert.assertStrictlyEquals("Label width not equal to simple background width", BACKGROUND_WIDTH, this.label.width);
			Assert.assertStrictlyEquals("Label height not equal to simple background height", BACKGROUND_HEIGHT, this.label.height);
			Assert.assertStrictlyEquals("Label minWidth not equal to simple background width", BACKGROUND_WIDTH, this.label.minWidth);
			Assert.assertStrictlyEquals("Label minHeight not equal to simple background height", BACKGROUND_HEIGHT, this.label.minHeight);
		}

		[Test]
		public function testAutoSizeWithSimpleBackgroundAndPadding():void
		{
			this.textRenderer.text = SIMPLE_TEXT;
			this.textRenderer.validate();

			this.addSimpleBackgroundSkin();
			this.label.paddingTop = PADDING_TOP;
			this.label.paddingRight = PADDING_RIGHT;
			this.label.paddingBottom = PADDING_BOTTOM;
			this.label.paddingLeft = PADDING_LEFT;
			this.label.text = SIMPLE_TEXT;
			this.label.validate();

			Assert.assertStrictlyEquals("Label width not equal to simple background width", BACKGROUND_WIDTH, this.label.width);
			Assert.assertStrictlyEquals("Label height not equal to simple background height", BACKGROUND_HEIGHT, this.label.height);
			Assert.assertStrictlyEquals("Label minWidth not equal to simple background width", BACKGROUND_WIDTH, this.label.minWidth);
			Assert.assertStrictlyEquals("Label minHeight not equal to simple background height", BACKGROUND_HEIGHT, this.label.minHeight);
		}

		[Test]
		public function testAutoSizeWithComplexBackground():void
		{
			this.addComplexBackgroundSkin();
			this.label.text = SIMPLE_TEXT;
			this.label.validate();

			Assert.assertStrictlyEquals("Label width not equal to simple background width", BACKGROUND_WIDTH3, this.label.width);
			Assert.assertStrictlyEquals("Label height not equal to simple background height", BACKGROUND_HEIGHT3, this.label.height);
			Assert.assertStrictlyEquals("Label minWidth not equal to simple background width", BACKGROUND_WIDTH2, this.label.minWidth);
			Assert.assertStrictlyEquals("Label minHeight not equal to simple background height", BACKGROUND_HEIGHT2, this.label.minHeight);
		}
	}
}
