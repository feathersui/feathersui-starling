package feathers.tests
{
	import feathers.controls.BasicButton;
	import feathers.controls.ButtonState;
	import feathers.events.FeathersEventType;
	import feathers.tests.supportClasses.DisposeFlagQuad;

	import flash.geom.Point;

	import org.flexunit.Assert;

	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import feathers.core.FeathersControl;

	public class FocusIndicatorTests
	{
		private var _control:CustomFocusControl;

		[Before]
		public function prepare():void
		{
			this._control = new CustomFocusControl();
			TestFeathers.starlingRoot.addChild(this._control);
		}

		[After]
		public function cleanup():void
		{
			this._control.removeFromParent(true);
			this._control = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testSkinsDisposed():void
		{
			var focusIndicatorSkin:DisposeFlagQuad = new DisposeFlagQuad();
			this._control.focusIndicatorSkin = focusIndicatorSkin;
			this._control.validate();
			this._control.dispose();
			Assert.assertTrue("focusIndicatorSkin not disposed when IFocusDisplayObject disposed.", focusIndicatorSkin.isDisposed);
		}

		[Test]
		public function testSkinsRemovedWhenSetToNull():void
		{
			var focusIndicatorSkin:DisposeFlagQuad = new DisposeFlagQuad();
			this._control.focusIndicatorSkin = focusIndicatorSkin;
			this._control.validate();
			this._control.focusIndicatorSkin = null;
			//should not need to validate here
			this._control.dispose();
			Assert.assertFalse("Removed focusIndicatorSkin incorrectly disposed when Button disposed.", focusIndicatorSkin.isDisposed);
			focusIndicatorSkin.dispose();
		}
	}
}

import feathers.core.IFocusDisplayObject;
import feathers.core.FeathersControl;

class CustomFocusControl extends FeathersControl implements IFocusDisplayObject
{
	public function CustomFocusControl()
	{

	}
}