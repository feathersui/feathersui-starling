/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.utils.keyboard
{
	import feathers.core.DefaultFocusManager;
	import feathers.core.IFocusDisplayObject;
	import feathers.events.FeathersEventType;
	import feathers.system.DeviceCapabilities;

	import flash.ui.Keyboard;

	import starling.display.Stage;
	import starling.events.Event;
	import starling.events.KeyboardEvent;

	/**
	 * Dispatches an event from the target when a key is pressed and released
	 * and the target has focus. Conveniently handles all
	 * <code>KeyboardEvent</code> listeners automatically.
	 *
	 * <p>In the following example, a custom item renderer will be triggered
	 * when a key is pressed and released:</p>
	 *
	 * <listing version="3.0">
	 * public class CustomComponent extends FeathersControl implements IFocusDisplayObject
	 * {
	 *     public function CustomComponent()
	 *     {
	 *         super();
	 *         this._keyToEvent = new KeyToEvent(this, Event.TRIGGERED);
	 *         this._keyToEvent.keyCode = Keyboard.SPACE;
	 *     }
	 *     
	 *     private var _keyToEvent:KeyToEvent;
	 * // ...</listing>
	 *
	 * @see feathers.utils.keyboard.KeyToTrigger
	 * @see feathers.utils.keyboard.KeyToSelect
	 *
	 * @productversion Feathers 3.4.0
	 */
	public class KeyToEvent
	{
		/**
		 * Constructor.
		 */
		public function KeyToEvent(target:IFocusDisplayObject = null, keyCode:uint = Keyboard.SPACE, eventType:String = null)
		{
			this.target = target;
			this.keyCode = keyCode;
			this.eventType = eventType;
		}

		/**
		 * @private
		 */
		protected var _stage:Stage;

		/**
		 * @private
		 */
		protected var _target:IFocusDisplayObject;

		/**
		 * The target component that should be selected when a key is pressed.
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
				this._target.addEventListener(FeathersEventType.FOCUS_IN, target_focusInHandler);
				this._target.addEventListener(FeathersEventType.FOCUS_OUT, target_focusOutHandler);
				this._target.addEventListener(Event.REMOVED_FROM_STAGE, target_removedFromStageHandler);
			}
		}

		/**
		 * @private
		 */
		protected var _keyCode:uint = Keyboard.SPACE;

		/**
		 * The key that will dispatch the event, when pressed.
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
		 * The key that will cancel the event if the key is down.
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
		 * The location of the key that will dispatch the event, when pressed.
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
		protected var _eventType:String = null;

		/**
		 * The event type that will be dispatched when pressed.
		 */
		public function get eventType():String
		{
			return this._eventType;
		}

		/**
		 * @private
		 */
		public function set eventType(value:String):void
		{
			this._eventType = value;
		}

		/**
		 * @private
		 */
		protected var _isEnabled:Boolean = true;

		/**
		 * May be set to <code>false</code> to disable event dispatching
		 * temporarily until set back to <code>true</code>.
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
		protected function target_focusInHandler(event:Event):void
		{
			var focusManager:DefaultFocusManager = this._target.focusManager as DefaultFocusManager;
			this._stage = this._target.stage;
			this._stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
		}

		/**
		 * @private
		 */
		protected function target_focusOutHandler(event:Event):void
		{
			if(this._stage !== null)
			{
				this._stage.removeEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
				this._stage.removeEventListener(KeyboardEvent.KEY_UP, stage_keyUpHandler);
				this._stage = null;
			}
		}

		/**
		 * @private
		 */
		protected function target_removedFromStageHandler(event:Event):void
		{
			if(this._stage !== null)
			{
				this._stage.removeEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
				this._stage.removeEventListener(KeyboardEvent.KEY_UP, stage_keyUpHandler);
				this._stage = null;
			}
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
			if(event.keyCode === this._cancelKeyCode)
			{
				this._stage.removeEventListener(KeyboardEvent.KEY_UP, stage_keyUpHandler);
				return;
			}
			if(event.keyCode !== this._keyCode)
			{
				return;
			}
			if(this._keyLocation !== uint.MAX_VALUE &&
				!((event.keyLocation === this._keyLocation) || (this._keyLocation === 4 && DeviceCapabilities.simulateDPad)))
			{
				return;	
			}
			this._stage.addEventListener(KeyboardEvent.KEY_UP, stage_keyUpHandler);
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
			if(event.keyCode !== this._keyCode)
			{
				return;
			}
			if(this._keyLocation !== uint.MAX_VALUE &&
				!((event.keyLocation === this._keyLocation) || (this._keyLocation === 4 && DeviceCapabilities.simulateDPad)))
			{
				return;	
			}
			var stage:Stage = Stage(event.currentTarget);
			stage.removeEventListener(KeyboardEvent.KEY_UP, stage_keyUpHandler);
			if(this._stage !== stage)
			{
				return;
			}
			this._target.dispatchEventWith(this._eventType);
		}
	}
}
