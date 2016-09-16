package feathers.tests
{
	import feathers.skins.FunctionStyleProvider;

	import org.flexunit.Assert;

	public class RestrictedStyleTests
	{
		private static const STYLE_PROVIDER_VALUE:Number = 2;
		private static const STYLE_PROVIDER_VALUE2:Number = 5;
		private static const CUSTOM_VALUE:Number = 3;
		private static const CUSTOM_VALUE2:Number = 4;

		private var _control:CustomControl;

		[Before]
		public function prepare():void
		{
			this._control = new CustomControl();
		}

		[After]
		public function cleanup():void
		{
			this._control.dispose();
			this._control = null;
		}

		private function setControlStyles(control:CustomControl):void
		{
			this._control.style = STYLE_PROVIDER_VALUE;
		}

		private function setControlStyles2(control:CustomControl):void
		{
			this._control.style = STYLE_PROVIDER_VALUE2;
		}

		[Test]
		public function testStyleProviderStyle():void
		{
			this._control.styleProvider = new FunctionStyleProvider(setControlStyles);
			this._control.validate();
			Assert.assertStrictlyEquals("Unrestricted style incorrectly rejects value from style provider.",
				STYLE_PROVIDER_VALUE, this._control.style);
		}

		[Test]
		public function testRestrictedStyle():void
		{
			this._control.styleProvider = new FunctionStyleProvider(setControlStyles);
			this._control.style = CUSTOM_VALUE;
			this._control.validate();
			Assert.assertStrictlyEquals("Custom value outside of style provider must restrict style.",
				CUSTOM_VALUE, this._control.style);
		}

		[Test]
		public function testReplaceStyleProvider():void
		{
			this._control.styleProvider = new FunctionStyleProvider(setControlStyles);
			this._control.validate();
			this._control.styleProvider = new FunctionStyleProvider(setControlStyles2);
			this._control.validate();
			Assert.assertStrictlyEquals("Unrestricted style incorrectly rejects value from new style provider.",
				STYLE_PROVIDER_VALUE2, this._control.style);
		}

		[Test]
		public function testReplaceRestrictedStyle():void
		{
			this._control.styleProvider = new FunctionStyleProvider(setControlStyles);
			this._control.style = CUSTOM_VALUE;
			this._control.validate();
			this._control.style = CUSTOM_VALUE2;
			this._control.validate();
			Assert.assertStrictlyEquals("Restricted style incorrectly rejects replacement value from outside style provider.",
				CUSTOM_VALUE2, this._control.style);
		}
	}
}

import feathers.core.FeathersControl;

class CustomControl extends FeathersControl
{
	public function CustomControl()
	{
		super();
	}

	private var _style:Number = -1;

	public function get style():Number
	{
		return this._style;
	}

	public function set style(value:Number):void
	{
		if(this.processStyleRestriction(arguments.callee))
		{
			return;
		}
		this._style = value;
	}
}