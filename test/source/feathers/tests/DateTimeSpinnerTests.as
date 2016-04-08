package feathers.tests
{
	import feathers.controls.DateTimeSpinner;
	import feathers.controls.renderers.DefaultListItemRenderer;

	import org.flexunit.Assert;

	import starling.display.Quad;

	public class DateTimeSpinnerTests
	{
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
			
			this._spinner.editingMode = DateTimeSpinner.EDITING_MODE_DATE;
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
			
			this._spinner.editingMode = DateTimeSpinner.EDITING_MODE_TIME;
			this._spinner.locale = "fr_FR";
			this._spinner.value = new Date(2016, 2, 24, 2);
			this._spinner.validate();
			this._spinner.locale = "en_US";
			this._spinner.validate();
		}
	}
}
