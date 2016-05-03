package feathers.tests
{
	import feathers.controls.BasicButton;
	import feathers.core.IFeathersControl;
	import feathers.skins.StyleNameFunctionStyleProvider;

	import org.flexunit.Assert;

	import starling.display.Quad;

	public class StyleNameFunctionStyleProviderTests
	{
		private static const STYLE_NAME_ONE:String = "one";
		private static const STYLE_NAME_TWO:String = "two";
		
		private var _target:BasicButton;
		private var _styleProvider:StyleNameFunctionStyleProvider;
		private var _defaultCalled:Boolean;
		private var _oneCalled:Boolean;
		private var _twoCalled:Boolean;

		[Before]
		public function prepare():void
		{
			this._defaultCalled = false;
			this._oneCalled = false;
			this._twoCalled = false;
			
			this._target = new BasicButton();
			this._target.defaultSkin = new Quad(200, 200, 0xff00ff);
			TestFeathers.starlingRoot.addChild(this._target);
		}

		[After]
		public function cleanup():void
		{
			this._target.removeFromParent(true);
			this._target = null;

			this._styleProvider = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		private function defaultFunction(target:IFeathersControl):void
		{
			this._defaultCalled = true;
		}

		private function oneFunction(target:IFeathersControl):void
		{
			this._oneCalled = true;
		}

		private function twoFunction(target:IFeathersControl):void
		{
			this._twoCalled = true;
		}

		[Test]
		public function testNoErrorWithNullDefaultFunction():void
		{
			this._styleProvider = new StyleNameFunctionStyleProvider();
			this._styleProvider.applyStyles(this._target);
			Assert.assertFalse("Default function must not be called when not used", this._defaultCalled);
		}

		[Test]
		public function testDefaultFunction():void
		{
			this._styleProvider = new StyleNameFunctionStyleProvider(defaultFunction);
			this._styleProvider.applyStyles(this._target);
			Assert.assertTrue("Default function must be called", this._defaultCalled);
		}

		[Test]
		public function testOnlyDefaultFunctionCalledWhenOthersRegistered():void
		{
			this._styleProvider = new StyleNameFunctionStyleProvider(defaultFunction);
			this._styleProvider.setFunctionForStyleName(STYLE_NAME_ONE, oneFunction);
			this._styleProvider.setFunctionForStyleName(STYLE_NAME_TWO, twoFunction);
			this._styleProvider.applyStyles(this._target);
			Assert.assertTrue("Default function must be called", this._defaultCalled);
			Assert.assertFalse("Style name function must not be called", this._oneCalled);
			Assert.assertFalse("Style name function must not be called", this._twoCalled);
		}

		[Test]
		public function testDefaultNotCalledWhenStyleNameMatched():void
		{
			this._styleProvider = new StyleNameFunctionStyleProvider(defaultFunction);
			this._styleProvider.setFunctionForStyleName(STYLE_NAME_ONE, oneFunction);
			this._styleProvider.setFunctionForStyleName(STYLE_NAME_TWO, twoFunction);
			this._target.styleNameList.add(STYLE_NAME_ONE);
			this._styleProvider.applyStyles(this._target);
			Assert.assertFalse("Default function must not be called", this._defaultCalled);
			Assert.assertTrue("Style name function must be called", this._oneCalled);
			Assert.assertFalse("Style name function must not be called", this._twoCalled);
		}

		[Test]
		public function testMultipleStyleNamesMatched():void
		{
			this._styleProvider = new StyleNameFunctionStyleProvider(defaultFunction);
			this._styleProvider.setFunctionForStyleName(STYLE_NAME_ONE, oneFunction);
			this._styleProvider.setFunctionForStyleName(STYLE_NAME_TWO, twoFunction);
			this._target.styleNameList.add(STYLE_NAME_ONE);
			this._target.styleNameList.add(STYLE_NAME_TWO);
			this._styleProvider.applyStyles(this._target);
			Assert.assertFalse("Default function must not be called", this._defaultCalled);
			Assert.assertTrue("Style name function must be called", this._oneCalled);
			Assert.assertTrue("Style name function must be called", this._twoCalled);
		}
	}
}
