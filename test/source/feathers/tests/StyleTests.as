package feathers.tests
{
	import feathers.controls.LayoutGroup;

	import org.flexunit.Assert;

	import starling.events.Event;

	public class StyleTests
	{
		private var _control:LayoutGroup;
		private var _styleProvider:FunctionStyleProviderWithEvents;
		private var _appliedStyles:Boolean = false;

		[Before]
		public function prepare():void
		{
			this._appliedStyles = false;
			this._control = new LayoutGroup();
			this._styleProvider = new FunctionStyleProviderWithEvents(setExtraStyles);
		}

		private function setExtraStyles(target:LayoutGroup):void
		{
			this._appliedStyles = true;
		}

		[After]
		public function cleanup():void
		{
			this._control.removeFromParent(true);
			this._control = null;
			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testSetStyleProviderBeforeInitialize():void
		{
			this._control.styleProvider = this._styleProvider;
			Assert.assertFalse("FeathersControl: must not apply styles before initialization", this._appliedStyles);
		}

		[Test]
		public function testSetStyleProviderAfterInitialize():void
		{
			this._control.validate();
			this._appliedStyles = false;
			this._control.styleProvider = this._styleProvider;
			Assert.assertTrue("FeathersControl: must apply styles after initialization", this._appliedStyles);
		}

		[Test]
		public function testAddToStyleNameListBeforeInitialize():void
		{
			this._control.styleProvider = this._styleProvider;
			this._control.styleNameList.add("custom-style-name");
			Assert.assertFalse("FeathersControl: when adding to style name list, must not apply styles before initialization", this._appliedStyles);
		}

		[Test]
		public function testAddToStyleNameListAfterInitialize():void
		{
			this._control.styleProvider = this._styleProvider;
			this._control.validate();
			this._appliedStyles = false;
			this._control.styleNameList.add("custom-style-name");
			Assert.assertTrue("FeathersControl: when adding to style name list, must apply styles after initialization", this._appliedStyles);
		}

		[Test]
		public function testStyleProviderChangeEventBeforeInitialize():void
		{
			this._control.styleProvider = this._styleProvider;
			this._styleProvider.dispatchEventWith(Event.CHANGE);
			Assert.assertFalse("FeathersControl: when style provider dispatches Event.CHANGE, must not apply styles before initialization", this._appliedStyles);
		}

		[Test]
		public function testStyleProviderChangeEventAfterInitialize():void
		{
			this._control.styleProvider = this._styleProvider;
			this._control.validate();
			this._appliedStyles = false;
			this._styleProvider.dispatchEventWith(Event.CHANGE);
			Assert.assertTrue("FeathersControl: when style provider dispatches Event.CHANGE, must apply styles after initialization", this._appliedStyles);
		}
	}
}

import feathers.core.IFeathersControl;
import feathers.skins.IStyleProvider;

import starling.events.EventDispatcher;

class FunctionStyleProviderWithEvents extends EventDispatcher implements IStyleProvider
{
	public function FunctionStyleProviderWithEvents(fn:Function)
	{
		this._fn = fn;
	}

	private var _fn:Function;

	public function applyStyles(target:IFeathersControl):void
	{
		this._fn(target);
	}
}