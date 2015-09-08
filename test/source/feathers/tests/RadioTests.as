package feathers.tests
{
	import feathers.controls.Radio;
	import feathers.core.ToggleGroup;

	import flexunit.framework.Assert;

	import starling.display.Quad;

	public class RadioTests
	{
		private var _radio:Radio;

		[Before]
		public function prepare():void
		{
			this._radio = new Radio();
			this._radio.isSelected = true;
			this._radio.label = "Click Me";
			this._radio.defaultSkin = new Quad(200, 200);
			TestFeathers.starlingRoot.addChild(this._radio);
			this._radio.validate();
		}

		[After]
		public function cleanup():void
		{
			this._radio.removeFromParent(true);
			this._radio = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testDefaultToggleGroup():void
		{
			Assert.assertStrictlyEquals("toggleGroup property must be equal to Radio.defaultRadioGroup if not added to another group.", Radio.defaultRadioGroup, this._radio.toggleGroup);
		}

		[Test]
		public function testToggleGroupPropertyAfterAddingExternally():void
		{
			var group:ToggleGroup = new ToggleGroup();
			group.addItem(this._radio);
			Assert.assertStrictlyEquals("toggleGroup property must be equal to ToggleGroup after adding to that group.", group, this._radio.toggleGroup);
		}

		[Test]
		public function testToggleGroupPropertyAfterRemovingExternally():void
		{
			var group:ToggleGroup = new ToggleGroup();
			group.addItem(this._radio);
			group.removeItem(this._radio);
			Assert.assertStrictlyEquals("toggleGroup property must be equal to Radio.defaultRadioGroup after removing a ToggleButton from another ToggleGroup.", Radio.defaultRadioGroup, this._radio.toggleGroup);
		}
	}
}
