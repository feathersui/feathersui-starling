/*
Feathers
Copyright 2012-2021 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.utils.keyboard
{
	import feathers.controls.ButtonState;
	import feathers.core.IFocusDisplayObject;
	import feathers.core.IStateContext;
	import feathers.events.FeathersEventType;
	import feathers.system.DeviceCapabilities;

	import flash.ui.Keyboard;

	import starling.display.Stage;
	import starling.events.Event;
	import starling.events.KeyboardEvent;

	/**
	 * Changes a target's state when a key is pressed or released on the
	 * keyboard. Conveniently handles all <code>KeyboardEvent</code> listeners
	 * automatically.
	 *
	 * @see feathers.utils.touch.TouchToState
	 *
	 * @productversion Feathers 3.2.0
	 */
	public class KeyToState
	{
		/**
		 * Constructor.
		 */
		public function KeyToState(target:IFocusDisplayObject = null, callback:Function = null)
		{
			this.target = target;
			this.callback = callback;
		}

		/**
		 * @private
		 */
		protected var _stage:Stage;

		/**
		 * @private
		 */
		protected var _hasFocus:Boolean = false;

		/**
		 * @private
		 */
		protected var _target:IFocusDisplayObject;

		/**
		 * The target component that should change state when a key is pressed
		 * or released.
		 */
		public function get target():IFocusDisplayObject
		{
			return this._target;
		}

		/**
		 * @private
		 */
		public function set target(value:IFocusDisplayObject):void
		{
			if(this._target === value)
			{
				return;
			}
			if(value !== null && !(value is IFocusDisplayObject))
			{
				throw new ArgumentError("Target of KeyToState must implement IFocusDisplayObject");
			}
			if(this._stage !== null)
			{
				//if the target changes while the old target has focus, remove
				//the listeners to avoid possible errors
				this._stage.removeEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
				this._stage.removeEventListener(KeyboardEvent.KEY_UP, stage_keyUpHandler);
				this._stage = null;
			}
			if(this._target !== null)
			{
				this._target.removeEventListener(FeathersEventType.FOCUS_IN, target_focusInHandler);
				this._target.removeEventListener(FeathersEventType.FOCUS_OUT, target_focusOutHandler);
				this._target.removeEventListener(Event.REMOVED_FROM_STAGE, target_removedFromStageHandler);
			}
			this._target = value;
			if(this._target !== null)
			{
				this._currentState = this._upState;
				this._target.addEventListener(FeathersEventType.FOCUS_IN, target_focusInHandler);
				this._target.addEventListener(FeathersEventType.FOCUS_OUT, target_focusOutHandler);
				this._target.addEventListener(Event.REMOVED_FROM_STAGE, target_removedFromStageHandler);
			}
		}

		/**
		 * @private
		 */
		protected var _callback:Function;

		/**
		 * The function to call when the state is changed.
		 *
		 * <p>The callback is expected to have the following signature:</p>
		 * <pre>function(currentState:String):void</pre>
		 */
		public function get callback():Function
		{
			return this._callback;
		}

		/**
		 * @private
		 */
		public function set callback(value:Function):void
		{
			if(this._callback === value)
			{
				return;
			}
			this._callback = value;
			if(this._callback !== null)
			{
				this._callback(this._currentState);
			}
		}

		/**
		 * @private
		 */
		protected var _keyCode:uint = Keyboard.SPACE;

		/**
		 * The key that will change the state of the target, when pressed.
		 *
		 * @default flash.ui.Keyboard.SPACE
		 */
		public function get keyCode():uint
		{
			return this._keyCode;
		}

		/**
		 * @private
		 */
		public function set keyCode(value:uint):void
		{
			this._keyCode = value;
		}

		/**
		 * @private
		 */
		protected var _cancelKeyCode:uint = Keyboard.ESCAPE;

		/**
		 * The key that will cancel the state change if the key is down.
		 *
		 * @default flash.ui.Keyboard.ESCAPE
		 */
		public function get cancelKeyCode():uint
		{
			return this._cancelKeyCode;
		}

		/**
		 * @private
		 */
		public function set cancelKeyCode(value:uint):void
		{
			this._cancelKeyCode = value;
		}

		/**
		 * @private
		 */
		protected var _keyLocation:uint = uint.MAX_VALUE;

		/**
		 * The location of the key that will change the state, when pressed.
		 * If <code>uint.MAX_VALUE</code>, then any key location is allowed.
		 *
		 * @default uint.MAX_VALUE
		 *
		 * @see flash.ui.KeyLocation
		 */
		public function get keyLocation():uint
		{
			return this._keyLocation;
		}

		/**
		 * @private
		 */
		public function set keyLocation(value:uint):void
		{
			this._keyLocation = value;
		}

		/**
		 * @private
		 */
		protected var _isEnabled:Boolean = true;

		/**
		 * May be set to <code>false</code> to disable state changes temporarily
		 * until set back to <code>true</code>.
		 */
		public function get isEnabled():Boolean
		{
			return this._isEnabled;
		}

		/**
		 * @private
		 */
		public function set isEnabled(value:Boolean):void
		{
			this._isEnabled = value;
		}

		/**
		 * @private
		 */
		protected var _currentState:String = ButtonState.UP;

		/**
		 * The current state of the utility. May be different than the state
		 * of the target.
		 */
		public function get currentState():String
		{
			return this._currentState;
		}

		/**
		 * @private
		 */
		protected var _upState:String = ButtonState.UP;

		/**
		 * The value for the "up" state.
		 *
		 * @default feathers.controls.ButtonState.UP
		 */
		public function get upState():String
		{
			return this._upState;
		}

		/**
		 * @private
		 */
		public function set upState(value:String):void
		{
			this._upState = value;
		}

		/**
		 * @private
		 */
		protected var _downState:String = ButtonState.DOWN;

		/**
		 * The value for the "down" state.
		 *
		 * @default feathers.controls.ButtonState.DOWN
		 */
		public function get downState():String
		{
			return this._downState;
		}

		/**
		 * @private
		 */
		public function set downState(value:String):void
		{
			this._downState = value;
		}

		/**
		 * @private
		 */
		protected function changeState(value:String):void
		{
			var oldState:String = this._currentState;
			if(this._target is IStateContext)
			{
				oldState = IStateContext(this._target).currentState;
			}
			this._currentState = value;
			if(oldState === value)
			{
				return;
			}
			if(this._callback !== null)
			{
				this._callback(value);
			}
		}

		/**
		 * @private
		 */
		protected function focusOut():void
		{
			this._hasFocus = false;
			if(this._stage !== null)
			{
				this._stage.removeEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
				this._stage.removeEventListener(KeyboardEvent.KEY_UP, stage_keyUpHandler);
				this._stage = null;
			}
			this.changeState(this._upState);
		}

		/**
		 * @private
		 */
		protected function target_focusInHandler(event:Event):void
		{
			this._hasFocus = true;
			this._stage = this._target.stage;
			this._stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);

			//don't change the state on focus in because the state may be
			//managed by another utility
		}

		/**
		 * @private
		 */
		protected function target_focusOutHandler(event:Event):void
		{
			this.focusOut();
		}

		/**
		 * @private
		 */
		protected function target_removedFromStageHandler(event:Event):void
		{
			this.focusOut();
		}

		/**
		 * @private
		 */
		protected function stage_keyDownHandler(event:KeyboardEvent):void
		{
			if(!this._isEnabled)
			{
				return;
			}
			if(event.currentTarget !== this._stage)
			{
				//Github issue #1762: the stage may have been set to null in a
				//previous KeyboardEvent.KEY_DOWN listener
				return;
			}
			if(event.keyCode == this._cancelKeyCode)
			{
				this._stage.removeEventListener(KeyboardEvent.KEY_UP, stage_keyUpHandler);
				this.changeState(this._upState);
				return;
			}
			if(event.keyCode != this._keyCode)
			{
				return;
			}
			if(this._keyLocation != uint.MAX_VALUE &&
				!((event.keyLocation == this._keyLocation) || (this._keyLocation == 4 && DeviceCapabilities.simulateDPad)))
			{
				return;	
			}
			this._stage.addEventListener(KeyboardEvent.KEY_UP, stage_keyUpHandler);
			this.changeState(this._downState);
		}

		/**
		 * @private
		 */
		protected function stage_keyUpHandler(event:KeyboardEvent):void
		{
			if(!this._isEnabled)
			{
				return;
			}
			if(event.keyCode != this._keyCode)
			{
				return;
			}
			if(this._keyLocation != uint.MAX_VALUE &&
				!((event.keyLocation == this._keyLocation) || (this._keyLocation == 4 && DeviceCapabilities.simulateDPad)))
			{
				return;	
			}
			var stage:Stage = Stage(event.currentTarget);
			stage.removeEventListener(KeyboardEvent.KEY_UP, stage_keyUpHandler);
			if(this._stage !== stage)
			{
				return;
			}
			this.changeState(this._upState);
		}
	}
}
