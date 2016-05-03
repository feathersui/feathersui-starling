package feathers.tests
{
	import feathers.controls.BasicButton;
	import feathers.core.IFeathersControl;
	import feathers.skins.AddOnFunctionStyleProvider;
	import feathers.skins.FunctionStyleProvider;
	import feathers.tests.supportClasses.CustomStyleProvider;

	import org.flexunit.Assert;

	import starling.display.Quad;

	public class AddOnFunctionStyleProviderTests
	{
		private var _target:BasicButton;
		private var _styleProvider:AddOnFunctionStyleProvider;
		private var _otherStyleProvider:CustomStyleProvider;
		private var _afterFunctionCalled:Boolean;
		private var _beforeFunctionCalled:Boolean;

		[Before]
		public function prepare():void
		{
			this._afterFunctionCalled = false;
			this._beforeFunctionCalled = false;

			this._otherStyleProvider = new CustomStyleProvider();

			this._target = new BasicButton();
			this._target.defaultSkin = new Quad(200, 200, 0xff00ff);
		}

		[After]
		public function cleanup():void
		{
			this._target.removeFromParent(true);
			this._target = null;

			this._styleProvider = null;
			this._otherStyleProvider = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		private function afterFunction(target:IFeathersControl):void
		{
			this._afterFunctionCalled = true;
			if(this._styleProvider.originalStyleProvider !== null)
			{
				Assert.assertTrue("AddOnFunctionStyleProvider did not call originalStyleProvider.applyStyles() before addon function.", this._otherStyleProvider.appliedStyles);
			}
		}

		private function beforeFunction(target:IFeathersControl):void
		{
			this._beforeFunctionCalled = true;
			if(this._styleProvider.originalStyleProvider !== null)
			{
				Assert.assertFalse("AddOnFunctionStyleProvider called originalStyleProvider.applyStyles() before addon function.", this._otherStyleProvider.appliedStyles);
			}
		}

		[Test]
		public function testNullOriginalStyleProviderAndAfterFunction():void
		{
			this._styleProvider = new AddOnFunctionStyleProvider(null, afterFunction);
			this._styleProvider.callBeforeOriginalStyleProvider = false;
			this._styleProvider.applyStyles(this._target);
			Assert.assertFalse("AddOnFunctionStyleProvider incorrectly called originalStyleProvider.applyStyles()", this._otherStyleProvider.appliedStyles);
			Assert.assertTrue("AddOnFunctionStyleProvider did not call the after function after null originalStyleProvider", this._afterFunctionCalled);
		}

		[Test]
		public function testNullOriginalStyleProviderAndBeforeFunction():void
		{
			this._styleProvider = new AddOnFunctionStyleProvider(null, beforeFunction);
			this._styleProvider.callBeforeOriginalStyleProvider = true;
			this._styleProvider.applyStyles(this._target);
			Assert.assertFalse("AddOnFunctionStyleProvider incorrectly called originalStyleProvider.applyStyles()", this._otherStyleProvider.appliedStyles);
			Assert.assertTrue("AddOnFunctionStyleProvider did not call the before function after null originalStyleProvider", this._beforeFunctionCalled);
		}

		[Test]
		public function testBeforeFunctionCalled():void
		{
			this._styleProvider = new AddOnFunctionStyleProvider(this._otherStyleProvider, beforeFunction);
			this._styleProvider.callBeforeOriginalStyleProvider = true;
			this._styleProvider.applyStyles(this._target);
			Assert.assertTrue("AddOnFunctionStyleProvider must call originalStyleProvider.applyStyles()", this._otherStyleProvider.appliedStyles);
			Assert.assertTrue("AddOnFunctionStyleProvider must call the function", this._beforeFunctionCalled);
		}

		[Test]
		public function testAfterFunctionCalled():void
		{
			this._styleProvider = new AddOnFunctionStyleProvider(this._otherStyleProvider, afterFunction);
			this._styleProvider.callBeforeOriginalStyleProvider = false;
			this._styleProvider.applyStyles(this._target);
			Assert.assertTrue("AddOnFunctionStyleProvider must call originalStyleProvider.applyStyles()", this._otherStyleProvider.appliedStyles);
			Assert.assertTrue("AddOnFunctionStyleProvider must call the after function", this._afterFunctionCalled);
		}
	}
}
