package feathers.tests
{
	import feathers.controls.BasicButton;
	import feathers.controls.Slider;
	import feathers.skins.IStyleProvider;
	import feathers.skins.StyleProviderRegistry;
	import feathers.tests.supportClasses.CustomStyleProvider;

	import org.flexunit.Assert;

	public class StyleProviderRegistryTests
	{
		private var _registry:StyleProviderRegistry;

		[After]
		public function cleanup():void
		{
			this._registry.dispose();
			this._registry = null;
		}

		[Test]
		public function testHasStyleProvider():void
		{
			this._registry = new StyleProviderRegistry(false);
			Assert.assertFalse("StyleProviderRegistry incorrectly returns true from hasStyleProvider() when class is not in registry.",
				this._registry.hasStyleProvider(BasicButton));
			
			var styleProvider:IStyleProvider = this._registry.getStyleProvider(BasicButton);
			Assert.assertTrue("StyleProviderRegistry must return true from hasStyleProvider() when class is in registry.",
				this._registry.hasStyleProvider(BasicButton));
			Assert.assertFalse("StyleProviderRegistry must return false from hasStyleProvider() when class is not in registry.",
				this._registry.hasStyleProvider(Slider));
		}

		[Test]
		public function testGetStyleProvider():void
		{
			this._registry = new StyleProviderRegistry(false);
			var styleProvider:IStyleProvider = this._registry.getStyleProvider(BasicButton);
			Assert.assertNotNull("StyleProviderRegistry must return non-null value from getStyleProvider().",
				styleProvider);
			var otherStyleProvider:IStyleProvider = this._registry.getStyleProvider(BasicButton);
			Assert.assertStrictlyEquals("StyleProviderRegistry must return same value from getStyleProvider() when called multiple times.",
				styleProvider, otherStyleProvider);
			var thirdStyleProvider:IStyleProvider = this._registry.getStyleProvider(Slider);
			Assert.assertTrue("StyleProviderRegistry must return different value from getStyleProvider() when called with different classes.",
				styleProvider !== thirdStyleProvider);
		}

		[Test]
		public function testClearStyleProvider():void
		{
			this._registry = new StyleProviderRegistry(false);
			var styleProvider:IStyleProvider = this._registry.getStyleProvider(BasicButton);
			var clearedStyleProvider:IStyleProvider = this._registry.clearStyleProvider(BasicButton);
			Assert.assertFalse("StyleProviderRegistry incorrectly returns true from hasStyleProvider() when class is cleared from registry.",
				this._registry.hasStyleProvider(BasicButton));
			Assert.assertStrictlyEquals("StyleProviderRegistry must return same value from clearStyleProvider() as getStyleProvider().",
				styleProvider, clearedStyleProvider);
		}

		[Test]
		public function testDispose():void
		{
			this._registry = new StyleProviderRegistry(false);
			var styleProvider1:IStyleProvider = this._registry.getStyleProvider(BasicButton);
			var styleProvider2:IStyleProvider = this._registry.getStyleProvider(Slider);
			this._registry.dispose();
			Assert.assertFalse("StyleProviderRegistry incorrectly returns true from hasStyleProvider() after dispose() is called.",
				this._registry.hasStyleProvider(BasicButton));
			Assert.assertFalse("StyleProviderRegistry incorrectly returns true from hasStyleProvider() after dispose() is called.",
				this._registry.hasStyleProvider(Slider));
		}

		[Test]
		public function testGetStyleProviderGlobal():void
		{
			this._registry = new StyleProviderRegistry(true);
			var styleProvider:IStyleProvider = this._registry.getStyleProvider(BasicButton);
			Assert.assertNotNull("StyleProviderRegistry must register globalStyleProvider when calling getStyleProvider().",
				BasicButton.globalStyleProvider);
			Assert.assertStrictlyEquals("StyleProviderRegistry must return same value from getStyleProvider() as it sets on globalStyleProvider.",
				BasicButton.globalStyleProvider, styleProvider);
		}

		[Test]
		public function testClearStyleProviderGlobal():void
		{
			this._registry = new StyleProviderRegistry(false);
			var styleProvider:IStyleProvider = this._registry.getStyleProvider(BasicButton);
			this._registry.clearStyleProvider(BasicButton);
			Assert.assertNull("StyleProviderRegistry failed to set globalStyleProvider to null after clearStyleProvider().",
				BasicButton.globalStyleProvider);
		}

		[Test]
		public function testDisposeGlobal():void
		{
			this._registry = new StyleProviderRegistry(false);
			var styleProvider:IStyleProvider = this._registry.getStyleProvider(BasicButton);
			this._registry.dispose();
			Assert.assertNull("StyleProviderRegistry failed to set globalStyleProvider to null after dispose().",
				BasicButton.globalStyleProvider);
		}

		[Test]
		public function testClearStyleProviderAfterChangeGlobal():void
		{
			this._registry = new StyleProviderRegistry(false);
			var styleProvider:IStyleProvider = this._registry.getStyleProvider(BasicButton);
			var replacementStyleProvider:CustomStyleProvider = new CustomStyleProvider();
			BasicButton.globalStyleProvider = replacementStyleProvider;
			this._registry.clearStyleProvider(BasicButton);
			Assert.assertStrictlyEquals("StyleProviderRegistry incorrectly set globalStyleProvider to null after clearStyleProvider() when global did not match.",
				replacementStyleProvider, BasicButton.globalStyleProvider);
			BasicButton.globalStyleProvider = null;
		}
	}
}
