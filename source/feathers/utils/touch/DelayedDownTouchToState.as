/*
Feathers
Copyright 2012-2019 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.utils.touch
{
	import feathers.controls.ButtonState;

	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import starling.display.DisplayObject;

	/**
	 * Similar to <code>TouchToState</code>, but delays the "down" state by a
	 * specified number of seconds. Useful for delayed state changes in
	 * scrolling containers.
	 *
	 * @productversion Feathers 3.2.0
	 */
	public class DelayedDownTouchToState extends TouchToState
	{
		/**
		 * Constructor.
		 */
		public function DelayedDownTouchToState(target:DisplayObject = null, callback:Function = null)
		{
			super(target, callback);
		}

		/**
		 * @private
		 */
		override public function set target(value:DisplayObject):void
		{
			super.target = value;
			if(this._target === null && this._stateDelayTimer !== null)
			{
				if(this._stateDelayTimer.running)
				{
					this._stateDelayTimer.stop();
				}
				this._stateDelayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, stateDelayTimer_timerCompleteHandler);
				this._stateDelayTimer = null;
			}
		}

		/**
		 * @private
		 */
		protected var _delayedCurrentState:String;

		/**
		 * @private
		 */
		protected var _stateDelayTimer:Timer;

		/**
		 * @private
		 */
		protected var _delay:Number = 0.25;

		/**
		 * The time, in seconds, to delay the state.
		 * 
		 * @default 0.25
		 */
		public function get delay():Number
		{
			return this._delay;
		}

		/**
		 * @private
		 */
		public function set delay(value:Number):void
		{
			this._delay = value;
		}

		/**
		 * @private
		 */
		override protected function changeState(value:String):void
		{
			if(this._stateDelayTimer && this._stateDelayTimer.running)
			{
				this._delayedCurrentState = value;
				return;
			}

			if(value === ButtonState.DOWN)
			{
				if(this._currentState === value)
				{
					return;
				}
				this._delayedCurrentState = value;
				if(this._stateDelayTimer)
				{
					this._stateDelayTimer.reset();
				}
				else
				{
					this._stateDelayTimer = new Timer(this._delay * 1000, 1);
					this._stateDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, stateDelayTimer_timerCompleteHandler);
				}
				this._stateDelayTimer.start();
				return;
			}
			super.changeState(value);
		}

		/**
		 * @private
		 */
		protected function stateDelayTimer_timerCompleteHandler(event:TimerEvent):void
		{
			super.changeState(this._delayedCurrentState);
			this._delayedCurrentState = null;
		}
	}
}
