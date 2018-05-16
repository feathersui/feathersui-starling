package feathers.tests
{
	import feathers.tests.supportClasses.ScrollContainerWithStates;

	import org.flexunit.Assert;
	import starling.events.Event;
	import feathers.events.FeathersEventType;

	public class ScrollContainerStatesTests
	{
		private static const DEFAULT_STATE_NAME:String = "default";
		private static const DEFAULT_PROPERTY_VALUE:String = "default_property";

		private static const SET_PROPERTY_STATE_NAME:String = "setPropertyState";
		private static const SET_PROPERTY_NAME:String = "name";
		private static const SET_PROPERTY_VALUE:String = "set_property";

		private static const SET_EVENT_HANDLER_STATE_NAME:String = "setEventHandlerState";
		private static const SET_EVENT_HANDLER_EVENT:String = Event.REMOVED;

		private static const INCLUDE_IN_STATE_NAME:String = "includeInState";

		private static const EXCLUDE_FROM_STATE_NAME:String = "excludeFromState";

		private static const GROUP1_STATE_NAME:String = "groupedState1";
		private static const GROUP2_STATE_NAME:String = "groupedState2";
		private static const GROUP_PROPERTY_NAME:String = "name";
		private static const GROUP1_PROPERTY_VALUE:String = "group1";
		private static const GROUP2_PROPERTY_VALUE:String = "group2";

		private var _container:ScrollContainerWithStates;

		[Before]
		public function prepare():void
		{
			this._container = new ScrollContainerWithStates();
			TestFeathers.starlingRoot.addChild(this._container);
			this._container.validate();
		}

		[After]
		public function cleanup():void
		{
			this._container.removeFromParent(true);
			this._container = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testDefaultCurrentState():void
		{
			Assert.assertStrictlyEquals("ScrollContainer: default value of currentState must be the name of the first state",
				DEFAULT_STATE_NAME, this._container.currentState);
			Assert.assertStrictlyEquals("ScrollContainer: default state should have no SetProperty overrides applied",
				DEFAULT_PROPERTY_VALUE, this._container[SET_PROPERTY_NAME]);
			Assert.assertStrictlyEquals("ScrollContainer: default state should have no SetEventHandler overrides applied",
				false, this._container.hasEventListener(SET_EVENT_HANDLER_EVENT));
			Assert.assertStrictlyEquals("ScrollContainer: default state should have no includeIn overrides applied",
				null, this._container.includeInChild);
			Assert.assertStrictlyEquals("ScrollContainer: default state should have no excludeFrom overrides applied",
				this._container.viewPort, this._container.excludeFromChild.parent);
		}

		[Test]
		public function testSetCurrentStateDispatchesStateChange():void
		{
			var stateChanged:Boolean = false;
			this._container.addEventListener(FeathersEventType.STATE_CHANGE, function():void
			{
				stateChanged = true;
			});
			this._container.currentState = SET_PROPERTY_STATE_NAME;
			Assert.assertStrictlyEquals("ScrollContainer: must dispatch FeathersEventType.STATE_CHANGE when changing currentState",
				true, stateChanged);
		}

		[Test]
		public function testSetCurrentStateToNull():void
		{
			this._container.currentState = SET_PROPERTY_STATE_NAME;
			this._container.currentState = null;
			Assert.assertStrictlyEquals("ScrollContainer: setting currentState to null must change to the first state",
				DEFAULT_STATE_NAME, this._container.currentState);
		}

		[Test]
		public function testSetCurrentStateToEmptyString():void
		{
			this._container.currentState = SET_PROPERTY_STATE_NAME;
			this._container.currentState = "";
			Assert.assertStrictlyEquals("ScrollContainer: setting currentState to empty string must change to the first state",
				DEFAULT_STATE_NAME, this._container.currentState);
		}

		[Test]
		public function testSetPropertyOverride():void
		{
			this._container.currentState = SET_PROPERTY_STATE_NAME;
			Assert.assertStrictlyEquals("ScrollContainer: changing state must apply SetProperty overrides",
				SET_PROPERTY_VALUE, this._container[SET_PROPERTY_NAME]);
		}

		[Test]
		public function testResetToDefaultStateAfterSetPropertyOverride():void
		{
			this._container.currentState = SET_PROPERTY_STATE_NAME;
			this._container.currentState = DEFAULT_STATE_NAME;
			Assert.assertStrictlyEquals("ScrollContainer: changing state to default must remove SetProperty overrides",
				DEFAULT_PROPERTY_VALUE, this._container[SET_PROPERTY_NAME]);
		}

		[Test]
		public function testSetEventHandlerOverride():void
		{
			this._container.currentState = SET_EVENT_HANDLER_STATE_NAME;
			Assert.assertStrictlyEquals("ScrollContainer: changing state must apply SetEventHandler overrides",
				true, this._container.hasEventListener(SET_EVENT_HANDLER_EVENT));
		}

		[Test]
		public function testResetToDefaultStateAfterSetEventHandlerOverride():void
		{
			this._container.currentState = SET_EVENT_HANDLER_STATE_NAME;
			this._container.currentState = DEFAULT_STATE_NAME;
			Assert.assertStrictlyEquals("ScrollContainer: changing state to default must remove SetEventHandler overrides",
				false, this._container.hasEventListener(SET_EVENT_HANDLER_EVENT));
		}

		[Test]
		public function testIncludeInOverride():void
		{
			this._container.currentState = INCLUDE_IN_STATE_NAME;
			Assert.assertStrictlyEquals("ScrollContainer: changing state must apply includeIn overrides",
				true, this._container.includeInChild !== null);
			Assert.assertStrictlyEquals("ScrollContainer: changing state must apply includeIn overrides",
				this._container.viewPort, this._container.includeInChild.parent);
		}

		[Test]
		public function testResetToDefaultStateAfterIncludeInOverride():void
		{
			this._container.currentState = INCLUDE_IN_STATE_NAME;
			this._container.currentState = DEFAULT_STATE_NAME;
			Assert.assertStrictlyEquals("ScrollContainer: changing state to default must remove includeIn overrides",
				true, this._container.includeInChild !== null);
			Assert.assertStrictlyEquals("ScrollContainer: changing state to default must remove includeIn overrides",
				null, this._container.includeInChild.parent);
		}

		[Test]
		public function testExcludeFromOverride():void
		{
			this._container.currentState = EXCLUDE_FROM_STATE_NAME;
			Assert.assertStrictlyEquals("ScrollContainer: changing state must apply excludeFrom overrides",
				null, this._container.excludeFromChild.parent);
		}

		[Test]
		public function testResetToDefaultStateAfterExcludeFromOverride():void
		{
			this._container.currentState = EXCLUDE_FROM_STATE_NAME;
			this._container.currentState = DEFAULT_STATE_NAME;
			Assert.assertStrictlyEquals("ScrollContainer: changing state to default must remove excludeFrom overrides",
				this._container.viewPort, this._container.excludeFromChild.parent);
		}

		[Test]
		public function testStateGroupOverride():void
		{
			this._container.currentState = GROUP1_STATE_NAME;
			Assert.assertStrictlyEquals("ScrollContainer: changing state must apply group overrides",
				GROUP1_PROPERTY_VALUE, this._container[GROUP_PROPERTY_NAME]);
		}

		[Test]
		public function testResetToDefaultStateAfterStateGroupOverride():void
		{
			this._container.currentState = GROUP1_STATE_NAME;
			this._container.currentState = DEFAULT_STATE_NAME;
			Assert.assertStrictlyEquals("ScrollContainer: changing state to default must remove group overrides",
				DEFAULT_PROPERTY_VALUE, this._container[GROUP_PROPERTY_NAME]);
		}

		[Test]
		public function testChangeToDifferentStateGroupOverride():void
		{
			this._container.currentState = GROUP1_STATE_NAME;
			this._container.currentState = GROUP2_STATE_NAME;
			Assert.assertStrictlyEquals("ScrollContainer: changing state to another group must change group overrides",
				GROUP2_PROPERTY_VALUE, this._container[GROUP_PROPERTY_NAME]);
		}
	}	
}