package feathers.tests
{
	import feathers.controls.BasicButton;
	import feathers.core.IFeathersControl;
	import feathers.skins.ConditionalStyleProvider;
	import feathers.tests.supportClasses.CustomStyleProvider;

	import org.flexunit.Assert;

	import starling.display.Quad;

	public class ConditionalStyleProviderTests
	{
		private var _target:BasicButton;
		private var _styleProvider:ConditionalStyleProvider;
		private var _falseStyleProvider:CustomStyleProvider;
		private var _trueStyleProvider:CustomStyleProvider;

		[Before]
		public function prepare():void
		{
			this._target = new BasicButton();
			this._target.defaultSkin = new Quad(200, 200, 0xff00ff);

			this._falseStyleProvider = new CustomStyleProvider();
			this._trueStyleProvider = new CustomStyleProvider();
		}

		[After]
		public function cleanup():void
		{
			this._target.removeFromParent(true);
			this._target = null;

			this._styleProvider = null;
			this._falseStyleProvider = null;
			this._trueStyleProvider = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		private function falseConditionalFunction(target:IFeathersControl):Boolean
		{
			return false;
		}

		private function trueConditionalFunction(target:IFeathersControl):Boolean
		{
			return true;
		}

		[Test]
		public function testNoErrorWithNullConditionalFunction():void
		{
			this._styleProvider = new ConditionalStyleProvider(null);
			this._styleProvider.applyStyles(this._target);
		}

		[Test]
		public function testNoErrorWithNullStyleProviders():void
		{
			this._styleProvider = new ConditionalStyleProvider(falseConditionalFunction);
			this._styleProvider.applyStyles(this._target);
		}

		[Test]
		public function testNoErrorWithNullFalseStyleProvider():void
		{
			this._styleProvider = new ConditionalStyleProvider(falseConditionalFunction,
				this._trueStyleProvider, null);
			this._styleProvider.applyStyles(this._target);
		}

		[Test]
		public function testNoErrorWithNullTrueStyleProvider():void
		{
			this._styleProvider = new ConditionalStyleProvider(trueConditionalFunction,
				null, this._falseStyleProvider);
			this._styleProvider.applyStyles(this._target);
		}

		[Test]
		public function testFalseStyleProvider():void
		{
			this._styleProvider = new ConditionalStyleProvider(falseConditionalFunction,
				this._trueStyleProvider, this._falseStyleProvider);
			this._styleProvider.applyStyles(this._target);
			Assert.assertTrue("When ConditionalStyleProvider condition is false, falseStyleProvider.applyStyles() must be called.",
				this._falseStyleProvider.appliedStyles);
			Assert.assertFalse("When ConditionalStyleProvider condition is false, trueStyleProvider.applyStyles() must not be called.",
				this._trueStyleProvider.appliedStyles);
		}

		[Test]
		public function testTrueStyleProvider():void
		{
			this._styleProvider = new ConditionalStyleProvider(trueConditionalFunction,
				this._trueStyleProvider, this._falseStyleProvider);
			this._styleProvider.applyStyles(this._target);
			Assert.assertTrue("When ConditionalStyleProvider condition is true, trueStyleProvider.applyStyles() must be called.",
				this._trueStyleProvider.appliedStyles);
			Assert.assertFalse("When ConditionalStyleProvider condition is true, falseStyleProvider.applyStyles() must not be called.",
				this._falseStyleProvider.appliedStyles);
		}
	}
}
