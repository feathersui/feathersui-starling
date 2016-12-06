package feathers.tests
{
	import feathers.controls.DateTimeMode;
	import feathers.controls.DateTimeSpinner;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.tests.supportClasses.DisposeFlagQuad;

	import org.flexunit.Assert;

	import starling.display.Quad;

	public class DateTimeSpinnerTests
	{
		private static const BACKGROUND_WIDTH:Number = 4000;
		private static const BACKGROUND_HEIGHT:Number = 4100;

		private static const PADDING_TOP:Number = 4000;
		private static const PADDING_RIGHT:Number = 1000;
		private static const PADDING_BOTTOM:Number = 3000;
		private static const PADDING_LEFT:Number = 900;

		private var _spinner:DateTimeSpinner;

		[Before]
		public function prepare():void
		{
			this._spinner = new DateTimeSpinner();
			this._spinner.itemRendererFactory = function():DefaultListItemRenderer
			{
				var itemRenderer:DefaultListItemRenderer = new DefaultListItemRenderer();
				itemRenderer.defaultSkin = new Quad(200, 88, 0xffffff);
				return itemRenderer;
			};
			TestFeathers.starlingRoot.addChild(this._spinner);
		}

		[After]
		public function cleanup():void
		{
			this._spinner.removeFromParent(true);
			this._spinner = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testSetValueProgramaticallyWithoutMinimumOrMaximumWithoutRuntimeError():void
		{
			this._spinner.value = new Date();
		}

		[Test]
		public function testSetValueProgramaticallyNotEqual():void
		{
			var value:Date = new Date();
			this._spinner.value = value;
			Assert.assertFalse("Incorrectly uses same Date object when setting value property.", value === this._spinner.value);
		}

		[Test]
		public function testSetValueProgramaticallyWithMinimum():void
		{
			this._spinner.minimum = new Date(2015, 6, 15);
			this._spinner.value = new Date(2015, 6, 14);
			Assert.assertEquals("Setting value smaller than minimum not changed to minimum.", this._spinner.minimum.valueOf(), this._spinner.value.valueOf());
		}

		[Test]
		public function testSetValueProgramaticallyWithMaximum():void
		{
			this._spinner.maximum = new Date(2015, 6, 15);
			this._spinner.value = new Date(2015, 6, 16);
			Assert.assertEquals("Setting value larger than maximum not changed to maximum.", this._spinner.maximum.valueOf(), this._spinner.value.valueOf());
		}

		[Test]
		public function testDateEditingModeAndSetMinimumToDateThenToNull():void
		{
			//this test catches a potential runtime error with the internal year
			//list not having a data descriptor

			this._spinner.editingMode = DateTimeMode.DATE;
			var value:Date = new Date(2016, 2, 24);
			this._spinner.minimum = new Date(1960, 0, 1);
			this._spinner.maximum = new Date(value.fullYear + 5, 0, 1);
			this._spinner.value = value;
			this._spinner.validate();
			this._spinner.minimum = null;
			this._spinner.validate();
		}

		[Test]
		public function testTimeEditingModeAndChangeLocaleWithDifferentMeridiem():void
		{
			//this test catches some runtime errors with the internal meridiem
			//and hours lists not having data descriptors

			this._spinner.editingMode = DateTimeMode.TIME;
			this._spinner.locale = "fr_FR";
			this._spinner.value = new Date(2016, 2, 24, 2);
			this._spinner.validate();
			this._spinner.locale = "en_US";
			this._spinner.validate();
		}

		[Test]
		public function testBackgroundSkinMeasurement():void
		{
			var backgroundSkin:Quad = new Quad(BACKGROUND_WIDTH, BACKGROUND_HEIGHT);
			this._spinner.backgroundSkin = backgroundSkin;
			this._spinner.validate();
			Assert.assertStrictlyEquals("DateTimeSpinner: backgroundSkin width not used for measurement.",
				BACKGROUND_WIDTH, this._spinner.width);
			Assert.assertStrictlyEquals("DateTimeSpinner: backgroundSkin height not used for measurement.",
				BACKGROUND_HEIGHT, this._spinner.height);
		}

		[Test]
		public function testPaddingMeasurement():void
		{
			this._spinner.paddingTop = PADDING_TOP;
			this._spinner.paddingRight = PADDING_RIGHT;
			this._spinner.paddingBottom = PADDING_BOTTOM;
			this._spinner.paddingLeft = PADDING_LEFT;
			this._spinner.validate();
			Assert.assertTrue("DateTimeSpinner: padding left/right not used for width measurement.",
				(PADDING_LEFT + PADDING_RIGHT) < this._spinner.width);
			Assert.assertTrue("DateTimeSpinner:  padding top/bottom not used for height measurement.",
				(PADDING_TOP + PADDING_BOTTOM) < this._spinner.height);
		}

		[Test]
		public function testSkinsDisposed():void
		{
			var backgroundSkin:DisposeFlagQuad = new DisposeFlagQuad();
			this._spinner.backgroundSkin = backgroundSkin;
			var backgroundDisabledSkin:DisposeFlagQuad = new DisposeFlagQuad();
			this._spinner.backgroundDisabledSkin = backgroundDisabledSkin;
			this._spinner.validate();
			this._spinner.dispose();
			Assert.assertTrue("backgroundSkin not disposed when LayoutGroup disposed.", backgroundSkin.isDisposed);
			Assert.assertTrue("backgroundDisabledSkin not disposed when LayoutGroup disposed.", backgroundDisabledSkin.isDisposed);
		}
	}
}
