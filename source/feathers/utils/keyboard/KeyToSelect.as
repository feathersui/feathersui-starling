/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.utils.keyboard
{
	import feathers.core.IFocusDisplayObject;
	import feathers.core.IToggle;
	import feathers.events.FeathersEventType;

	import flash.ui.Keyboard;

	import starling.events.Event;
	import starling.events.KeyboardEvent;

	/**
	 * Changes the <code>isSelected</code> property of the target when a key is
	 * pressed and released while the target has focus. The target will
	 * dispatch <code>Event.CHANGE</code>. Conveniently handles all
	 * <code>KeyboardEvent</code> listeners automatically.
	 *
	 * <p>In the following example, a custom component will be selected when a
	 * key is pressed and released:</p>
	 *
	 * <listing version="3.0">
	 * public class CustomComponent extends FeathersControl implements IFocusDisplayObject
	 * {
	 *     public function CustomComponent()
	 *     {
	 *         super();
	 *         this._keyToSelect = new KeyToSelect(this);
	 *         this._keyToSelect.keyCode = Keyboard.SPACE;
	 *     }
	 *     
	 *     private var _keyToSelect:KeyToSelect;
	 * // ...</listing>
	 *
	 * <p>Note: When combined with a <code>KeyToTrigger</code> instance, the
	 * <code>KeyToSelect</code> instance should be created second because
	 * <code>Event.TRIGGERED</code> should be dispatched before
	 * <code>Event.CHANGE</code>.</p>
	 *
	 * @see feathers.utils.touch.KeyToTrigger
	 * @see feathers.utils.touch.TapToSelect
	 */
	public class KeyToSelect
	{
		/**
		 * Constructor.
		 */
		public function KeyToSelect(target:IToggle = null)
		{
			this.target = target;
		}

		/**
		 * @private
		 */
		protected var _target:IToggle;

		/**
		 * The target component that should be selected when a key is pressed.
		 */
		public function get target():IToggle
		{
			return this._target;
		}

		/**
		 * @private
		 */
		public function set target(value:IToggle):void
		{
			if(this._target === value)
			{
				return;
			}
			if(!(value is IFocusDisplayObject))
			{
				throw new ArgumentError("Target of KeyToSelect must implement IFocusDisplayObject");
			}
			if(this._target)
			{
				this._target.removeEventListener(FeathersEventType.FOCUS_IN, target_focusInHandler);
				this._target.removeEventListener(FeathersEventType.FOCUS_OUT, target_focusOutHandler);
				this._target.removeEventListener(Event.REMOVED_FROM_STAGE, target_removedFromStageHandler);
			}
			this._target = value;
			if(this._target)
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
		 * The key that will select the target, when pressed.
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
		 * The key that will cancel the selection if the key is down.
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
		protected var _keyToDeselect:Boolean = false;

		/**
		 * May be set to <code>true</code> to allow the target to be deselected
		 * when the key is pressed.
		 *
		 * @default false
		 */
		public function get keyToDeselect():Boolean
		{
			return this._keyToDeselect;
		}

		/**
		 * @private
		 */
		public function set keyToDeselect(value:Boolean):void
		{
			this._keyToDeselect = value;
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
			this._target.stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
		}

		/**
		 * @private
		 */
		protected function target_focusOutHandler(event:Event):void
		{
			this._target.stage.removeEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
			this._target.stage.removeEventListener(KeyboardEvent.KEY_UP, stage_keyUpHandler);
		}

		/**
		 * @private
		 */
		protected function target_removedFromStageHandler(event:Event):void
		{
			this._target.stage.removeEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
			this._target.stage.removeEventListener(KeyboardEvent.KEY_UP, stage_keyUpHandler);
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
				this._target.stage.removeEventListener(KeyboardEvent.KEY_UP, stage_keyUpHandler);
			}
			else if(event.keyCode === this._keyCode)
			{
				this._target.stage.addEventListener(KeyboardEvent.KEY_UP, stage_keyUpHandler);
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
			if(this._keyToDeselect)
			{
				this._target.isSelected = !this._target.isSelected;
			}
			else
			{
				this._target.isSelected = true;
			}
			this._target.stage.removeEventListener(KeyboardEvent.KEY_UP, stage_keyUpHandler);
		}
	}
}
