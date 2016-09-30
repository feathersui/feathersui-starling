package feathers.tests
{
	import feathers.controls.LayoutGroup;

	import org.flexunit.Assert;

	import starling.display.Quad;

	public class ScaleTests
	{
		private static const BASE_WIDTH:Number = 100;
		private static const BASE_HEIGHT:Number = 140;

		private static const LARGER_WIDTH:Number = 280;
		private static const LARGER_HEIGHT:Number = 300;
		private static const LARGER_MIN_WIDTH:Number = 270;
		private static const LARGER_MIN_HEIGHT:Number = 290;
		
		private static const LARGER_SCALEX:Number = 2;
		private static const SMALLER_SCALEY:Number = 0.25;
		private static const SMALLER_SCALE:Number = 0.5;
		
		private var _control:LayoutGroup;

		[Before]
		public function prepare():void
		{
			this._control = new LayoutGroup();
			this._control.backgroundSkin = new Quad(BASE_WIDTH, BASE_HEIGHT, 0xff00ff);
			TestFeathers.starlingRoot.addChild(this._control);
		}

		[After]
		public function cleanup():void
		{
			this._control.removeFromParent(true);
			this._control = null;
			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testInitialDimensions():void
		{
			this._control.validate();
			Assert.assertStrictlyEquals("Component initial width incorrect.", BASE_WIDTH, this._control.width);
			Assert.assertStrictlyEquals("Component initial height incorrect.", BASE_HEIGHT, this._control.height);
			Assert.assertStrictlyEquals("Component initial minWidth incorrect.", BASE_WIDTH, this._control.minWidth);
			Assert.assertStrictlyEquals("Component initial minHeight incorrect.", BASE_HEIGHT, this._control.minHeight);
		}

		[Test]
		public function testSetScaleXAndScaleY():void
		{
			this._control.scaleX = LARGER_SCALEX;
			this._control.scaleY = SMALLER_SCALEY;
			this._control.validate();
			Assert.assertStrictlyEquals("Component calculated width incorrect after setting scaleX.", BASE_WIDTH * LARGER_SCALEX, this._control.width);
			Assert.assertStrictlyEquals("Component calculated height incorrect after setting scaleY.", BASE_HEIGHT * SMALLER_SCALEY, this._control.height);
			Assert.assertStrictlyEquals("Component calculated minWidth incorrect after setting scaleX.", BASE_WIDTH * LARGER_SCALEX, this._control.minWidth);
			Assert.assertStrictlyEquals("Component calculated minHeight incorrect after setting scaleY.", BASE_HEIGHT * SMALLER_SCALEY, this._control.minHeight);
		}

		[Test]
		public function testSetScale():void
		{
			this._control.scale = SMALLER_SCALE;
			this._control.validate();
			Assert.assertStrictlyEquals("Component calculated width incorrect after setting scale.", BASE_WIDTH * SMALLER_SCALE, this._control.width);
			Assert.assertStrictlyEquals("Component calculated height incorrect after setting scale.", BASE_HEIGHT * SMALLER_SCALE, this._control.height);
			Assert.assertStrictlyEquals("Component calculated minWidth incorrect after setting scale.", BASE_WIDTH * SMALLER_SCALE, this._control.minWidth);
			Assert.assertStrictlyEquals("Component calculated minHeight incorrect after setting scale.", BASE_HEIGHT * SMALLER_SCALE, this._control.minHeight);
		}

		[Test]
		public function testSetScaleXAndScaleYThenWidthAndHeight():void
		{
			this._control.scaleX = LARGER_SCALEX;
			this._control.scaleY = SMALLER_SCALEY;
			this._control.width = LARGER_WIDTH;
			this._control.height = LARGER_HEIGHT;
			this._control.minWidth = LARGER_MIN_WIDTH;
			this._control.minHeight = LARGER_MIN_HEIGHT;
			this._control.validate();
			Assert.assertStrictlyEquals("Component width incorrect after setting scaleX then width.", LARGER_WIDTH, this._control.width);
			Assert.assertStrictlyEquals("Component height incorrect after setting scaleY then height.", LARGER_HEIGHT, this._control.height);
			Assert.assertStrictlyEquals("Component minWidth incorrect after setting scaleX then minWidth.", LARGER_MIN_WIDTH, this._control.minWidth);
			Assert.assertStrictlyEquals("Component minHeight incorrect after setting scaleY then minHeight.", LARGER_MIN_HEIGHT, this._control.minHeight);
		}

		[Test]
		public function testSetWidthAndHeightThenScaleXAndScaleY():void
		{
			this._control.width = LARGER_WIDTH;
			this._control.height = LARGER_HEIGHT;
			this._control.minWidth = LARGER_MIN_WIDTH;
			this._control.minHeight = LARGER_MIN_HEIGHT;
			this._control.scaleX = LARGER_SCALEX;
			this._control.scaleY = SMALLER_SCALEY;
			this._control.validate();
			Assert.assertStrictlyEquals("Component width incorrect after setting width then scaleX.", LARGER_WIDTH * LARGER_SCALEX, this._control.width);
			Assert.assertStrictlyEquals("Component height incorrect after setting height then scaleY.", LARGER_HEIGHT * SMALLER_SCALEY, this._control.height);
			Assert.assertStrictlyEquals("Component minWidth incorrect after setting minWidth then scaleX.", LARGER_MIN_WIDTH * LARGER_SCALEX, this._control.minWidth);
			Assert.assertStrictlyEquals("Component minHeight incorrect after setting minHeight then scaleY.", LARGER_MIN_HEIGHT * SMALLER_SCALEY, this._control.minHeight);
		}

		[Test]
		public function testSetWidthAndHeightThenScaleXAndScaleYThenWidthAndHeightBackToOriginal():void
		{
			this._control.width = LARGER_WIDTH;
			this._control.height = LARGER_HEIGHT;
			this._control.minWidth = LARGER_MIN_WIDTH;
			this._control.minHeight = LARGER_MIN_HEIGHT;
			this._control.scaleX = LARGER_SCALEX;
			this._control.scaleY = SMALLER_SCALEY;
			this._control.width = LARGER_WIDTH;
			this._control.height = LARGER_HEIGHT;
			this._control.minWidth = LARGER_MIN_WIDTH;
			this._control.minHeight = LARGER_MIN_HEIGHT;
			this._control.validate();
			Assert.assertStrictlyEquals("Component width incorrect after setting width then scaleX then width back to original.", LARGER_WIDTH, this._control.width);
			Assert.assertStrictlyEquals("Component height incorrect after setting height then scaleY then height back to original.", LARGER_HEIGHT, this._control.height);
			Assert.assertStrictlyEquals("Component minWidth incorrect after setting minWidth then scaleX then minWidth back to original.", LARGER_MIN_WIDTH, this._control.minWidth);
			Assert.assertStrictlyEquals("Component minHeight incorrect after setting minHeight then scaleY then minHeight back to original.", LARGER_MIN_HEIGHT, this._control.minHeight);
		}
	}
}
