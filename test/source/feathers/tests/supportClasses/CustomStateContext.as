package feathers.tests.supportClasses
{
	import feathers.core.IStateContext;
	import feathers.events.FeathersEventType;

	public class CustomStateContext extends CustomToggle implements IStateContext
	{
		public function CustomStateContext()
		{
			super();
		}

		protected var _currentState:String = null;

		override public function get currentState():String
		{
			return this._currentState;
		}

		override public function set currentState(value:String):void
		{
			if(this._currentState === value)
			{
				return;
			}
			this._currentState = value;
			this.dispatchEventWith(FeathersEventType.STATE_CHANGE);
		}
	}
}
