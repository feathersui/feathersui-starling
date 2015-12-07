package feathers.tests
{
	import feathers.controls.DateTimeSpinner;

	import org.flexunit.Assert;

	public class DateTimeSpinnerTests
	{
		private var _spinner:DateTimeSpinner;

		[Before]
		public function prepare():void
		{
			this._spinner = new DateTimeSpinner();
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
	}
}
