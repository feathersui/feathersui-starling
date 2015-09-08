package feathers.tests
{
	import feathers.controls.LayoutGroup;
	import feathers.events.FeathersEventType;

	import org.flexunit.Assert;

	import starling.events.Event;

	public class ComponentLifecycleTests
	{
		private var _control:LayoutGroup;

		[Before]
		public function prepare():void
		{
			this._control = new LayoutGroup();
		}

		[After]
		public function cleanup():void
		{
			this._control.removeFromParent(true);
			this._control = null;
			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testInitializeEventAfterAddedToStage():void
		{
			var hasInitialized:Boolean = false;
			this._control.addEventListener(FeathersEventType.INITIALIZE, function(event:Event):void
			{
				hasInitialized = true;
			});
			TestFeathers.starlingRoot.addChild(this._control);
			Assert.assertTrue("FeathersEventType.INITIALIZE was not dispatched after added to stage", hasInitialized);
		}

		[Test]
		public function testInitializeEventAfterValidateOffStage():void
		{
			var hasInitialized:Boolean = false;
			this._control.addEventListener(FeathersEventType.INITIALIZE, function(event:Event):void
			{
				hasInitialized = true;
			});
			this._control.validate();
			Assert.assertTrue("FeathersEventType.INITIALIZE was not dispatched after validate()", hasInitialized);
		}

		[Test]
		public function testIsInitializedProperty():void
		{
			Assert.assertFalse("isInitialized is not false before after added to stage", this._control.isInitialized);
			TestFeathers.starlingRoot.addChild(this._control);
			Assert.assertTrue("isInitialized was not changed to true after added to stage", this._control.isInitialized);
		}

		[Test]
		public function testCreationCompleteEventAfterValidate():void
		{
			var isCreated:Boolean = false;
			this._control.addEventListener(FeathersEventType.CREATION_COMPLETE, function(event:Event):void
			{
				isCreated = true;
			});
			this._control.validate();
			Assert.assertTrue("FeathersEventType.CREATION_COMPLETE was not dispatched after validate()", isCreated);
		}

		[Test]
		public function testIsCreatedProperty():void
		{
			Assert.assertFalse("isCreated is not false before validate()", this._control.isCreated);
			this._control.validate();
			Assert.assertTrue("isCreated was not changed to true after validate()", this._control.isCreated);
		}
	}
}
