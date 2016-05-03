package feathers.tests
{
	import feathers.controls.BasicButton;
	import feathers.core.IFeathersControl;
	import feathers.skins.FunctionStyleProvider;

	import org.flexunit.Assert;

	import starling.display.Quad;

	public class FunctionStyleProviderTests
	{
		private var _target:BasicButton;
		private var _styleProvider:FunctionStyleProvider;
		private var _functionCalled:Boolean;

		[Before]
		public function prepare():void
		{
			this._functionCalled = false;

			this._target = new BasicButton();
			this._target.defaultSkin = new Quad(200, 200, 0xff00ff);
		}

		[After]
		public function cleanup():void
		{
			this._target.removeFromParent(true);
			this._target = null;

			this._styleProvider = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}
		
		private function setStyles(target:IFeathersControl):void
		{
			this._functionCalled = true;
		}

		[Test]
		public function testNoErrorWithNullFunction():void
		{
			this._styleProvider = new FunctionStyleProvider(null);
			this._styleProvider.applyStyles(this._target);
			Assert.assertFalse("FunctionStyleProvider incorrectly called the function", this._functionCalled);
		}

		[Test]
		public function testFunctionCalled():void
		{
			this._styleProvider = new FunctionStyleProvider(setStyles);
			this._styleProvider.applyStyles(this._target);
			Assert.assertTrue("FunctionStyleProvider must call the function", this._functionCalled);
		}
	}
}
