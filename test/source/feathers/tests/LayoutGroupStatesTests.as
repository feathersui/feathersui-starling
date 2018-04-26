package feathers.tests
{
	import feathers.tests.supportClasses.LayoutGroupWithStates;

	import org.flexunit.Assert;
	import starling.events.Event;
	import feathers.events.FeathersEventType;

	public class LayoutGroupStatesTests
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

		private var _group:LayoutGroupWithStates;

		[Before]
		public function prepare():void
		{
			this._group = new LayoutGroupWithStates();
			TestFeathers.starlingRoot.addChild(this._group);
			this._group.validate();
		}

		[After]
		public function cleanup():void
		{
			this._group.removeFromParent(true);
			this._group = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testDefaultCurrentState():void
		{
			Assert.assertStrictlyEquals("LayoutGroup: default value of currentState must be the name of the first state",
				DEFAULT_STATE_NAME, this._group.currentState);
			Assert.assertStrictlyEquals("LayoutGroup: default state should have no SetProperty overrides applied",
				DEFAULT_PROPERTY_VALUE, this._group[SET_PROPERTY_NAME]);
			Assert.assertStrictlyEquals("LayoutGroup: default state should have no SetEventHandler overrides applied",
				false, this._group.hasEventListener(SET_EVENT_HANDLER_EVENT));
			Assert.assertStrictlyEquals("LayoutGroup: default state should have no includeIn overrides applied",
				null, this._group.includeInChild);
			Assert.assertStrictlyEquals("LayoutGroup: default state should have no excludeFrom overrides applied",
				this._group, this._group.excludeFromChild.parent);
		}

		[Test]
		public function testSetCurrentStateDispatchesStateChange():void
		{
			var stateChanged:Boolean = false;
			this._group.addEventListener(FeathersEventType.STATE_CHANGE, function():void
			{
				stateChanged = true;
			});
			this._group.currentState = SET_PROPERTY_STATE_NAME;
			Assert.assertStrictlyEquals("LayoutGroup: must dispatch FeathersEventType.STATE_CHANGE when changing currentState",
				true, stateChanged);
		}

		[Test]
		public function testSetCurrentStateToNull():void
		{
			this._group.currentState = SET_PROPERTY_STATE_NAME;
			this._group.currentState = null;
			Assert.assertStrictlyEquals("LayoutGroup: setting currentState to null must change to the first state",
				DEFAULT_STATE_NAME, this._group.currentState);
		}

		[Test]
		public function testSetCurrentStateToEmptyString():void
		{
			this._group.currentState = SET_PROPERTY_STATE_NAME;
			this._group.currentState = "";
			Assert.assertStrictlyEquals("LayoutGroup: setting currentState to empty string must change to the first state",
				DEFAULT_STATE_NAME, this._group.currentState);
		}

		[Test]
		public function testSetPropertyOverride():void
		{
			this._group.currentState = SET_PROPERTY_STATE_NAME;
			Assert.assertStrictlyEquals("LayoutGroup: changing state must apply SetProperty overrides",
				SET_PROPERTY_VALUE, this._group[SET_PROPERTY_NAME]);
		}

		[Test]
		public function testResetToDefaultStateAfterSetPropertyOverride():void
		{
			this._group.currentState = SET_PROPERTY_STATE_NAME;
			this._group.currentState = DEFAULT_STATE_NAME;
			Assert.assertStrictlyEquals("LayoutGroup: changing state to default must remove SetProperty overrides",
				DEFAULT_PROPERTY_VALUE, this._group[SET_PROPERTY_NAME]);
		}

		[Test]
		public function testSetEventHandlerOverride():void
		{
			this._group.currentState = SET_EVENT_HANDLER_STATE_NAME;
			Assert.assertStrictlyEquals("LayoutGroup: changing state must apply SetEventHandler overrides",
				true, this._group.hasEventListener(SET_EVENT_HANDLER_EVENT));
		}

		[Test]
		public function testResetToDefaultStateAfterSetEventHandlerOverride():void
		{
			this._group.currentState = SET_EVENT_HANDLER_STATE_NAME;
			this._group.currentState = DEFAULT_STATE_NAME;
			Assert.assertStrictlyEquals("LayoutGroup: changing state to default must remove SetEventHandler overrides",
				false, this._group.hasEventListener(SET_EVENT_HANDLER_EVENT));
		}

		[Test]
		public function testIncludeInOverride():void
		{
			this._group.currentState = INCLUDE_IN_STATE_NAME;
			Assert.assertStrictlyEquals("LayoutGroup: changing state must apply includeIn overrides",
				true, this._group.includeInChild !== null);
			Assert.assertStrictlyEquals("LayoutGroup: changing state must apply includeIn overrides",
				this._group, this._group.includeInChild.parent);
		}

		[Test]
		public function testResetToDefaultStateAfterIncludeInOverride():void
		{
			this._group.currentState = INCLUDE_IN_STATE_NAME;
			this._group.currentState = DEFAULT_STATE_NAME;
			Assert.assertStrictlyEquals("LayoutGroup: changing state to default must remove includeIn overrides",
				true, this._group.includeInChild !== null);
			Assert.assertStrictlyEquals("LayoutGroup: changing state to default must remove includeIn overrides",
				null, this._group.includeInChild.parent);
		}

		[Test]
		public function testExcludeFromOverride():void
		{
			this._group.currentState = EXCLUDE_FROM_STATE_NAME;
			Assert.assertStrictlyEquals("LayoutGroup: changing state must apply excludeFrom overrides",
				null, this._group.excludeFromChild.parent);
		}

		[Test]
		public function testResetToDefaultStateAfterExcludeFromOverride():void
		{
			this._group.currentState = EXCLUDE_FROM_STATE_NAME;
			this._group.currentState = DEFAULT_STATE_NAME;
			Assert.assertStrictlyEquals("LayoutGroup: changing state to default must remove excludeFrom overrides",
				this._group, this._group.excludeFromChild.parent);
		}
	}	
}