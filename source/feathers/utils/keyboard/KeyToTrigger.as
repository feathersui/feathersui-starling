/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.utils.keyboard
{
	import feathers.core.IFocusDisplayObject;
	import feathers.events.FeathersEventType;

	import flash.ui.Keyboard;

	import starling.display.Stage;
	import starling.events.Event;
	import starling.events.KeyboardEvent;

	/**
	 * Dispatches <code>Event.TRIGGERED</code> from the target when a key is
	 * pressed and released and the target has focus. Conveniently handles all
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
	 *         this._keyToTrigger = new KeyToTrigger(this);
	 *         this._keyToTrigger.keyCode = Keyboard.SPACE;
	 *     }
	 *     
	 *     private var _keyToTrigger:KeyToTrigger;
	 * // ...</listing>
	 *
	 * <p>Note: When combined with a <code>KeyToSelect</code> instance, the
	 * <code>KeyToTrigger</code> instance should be created first because
	 * <code>Event.TRIGGERED</code> should be dispatched before
	 * <code>Event.CHANGE</code>.</p>
	 *
	 * @see http://doc.starling-framework.org/current/starling/events/Event.html#TRIGGERED starling.events.Event.TRIGGERED
	 * @see feathers.utils.keyboard.KeyToSelect
	 * @see feathers.utils.touch.TapToTrigger
	 *
	 * @productversion Feathers 3.0.0
	 */
	public class KeyToTrigger
	{
		/**
		 * Constructor.
		 */
		public function KeyToTrigger(target:IFocusDisplayObject = null)
		{
			this.target = target;
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
		 * The key that will trigger the target, when pressed.
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
		 * The key that will cancel the trigger if the key is down.
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
		protected var _isEnabled:Boolean = true;

		/**
		 * May be set to <code>false</code> to disable selection temporarily
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
		protected function target_focusInHandler(event:Event):void
		{
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
			}
			else if(event.keyCode === this._keyCode)
			{
				this._stage.addEventListener(KeyboardEvent.KEY_UP, stage_keyUpHandler);
			}
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
			var stage:Stage = Stage(event.currentTarget);
			stage.removeEventListener(KeyboardEvent.KEY_UP, stage_keyUpHandler);
			if(this._stage !== stage)
			{
				return;
			}
			this._target.dispatchEventWith(Event.TRIGGERED);
		}
	}
}
