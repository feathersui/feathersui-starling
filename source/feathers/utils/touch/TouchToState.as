/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.utils.touch
{
	import feathers.controls.ButtonState;

	import flash.geom.Point;

	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Stage;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.Pool;

	/**
	 * Changes a target's state based on the <code>TouchPhase</code> when the
	 * target is touched. Conveniently handles all <code>TouchEvent</code> listeners
	 * automatically. Useful for custom item renderers that should be change
	 * state based on touch.
	 * 
	 * @see feathers.utils.touch.KeyToState
	 */
	public class TouchToState
	{
		/**
		 * Constructor.
		 */
		public function TouchToState(target:DisplayObject = null, callback:Function = null)
		{
			this.target = target;
			this.callback = callback;
		}

		/**
		 * @private
		 */
		protected var _target:DisplayObject;

		/**
		 * The target component that should change state based on touch phases.
		 */
		public function get target():DisplayObject
		{
			return this._target;
		}

		/**
		 * @private
		 */
		public function set target(value:DisplayObject):void
		{
			if(this._target == value)
			{
				return;
			}
			if(this._target !== null)
			{
				this._target.removeEventListener(TouchEvent.TOUCH, target_touchHandler);
				this._target.removeEventListener(Event.REMOVED_FROM_STAGE, target_removedFromStageHandler);
			}
			this._target = value;
			if(this._target !== null)
			{
				//if we're changing targets, and a touch is active, we want to
				//clear it.
				this._touchPointID = -1;
				this._target.addEventListener(TouchEvent.TOUCH, target_touchHandler);
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
		protected var _currentState:String = ButtonState.UP;

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
		protected var _hoverState:String = ButtonState.HOVER;

		/**
		 * The value for the "hover" state.
		 *
		 * @default feathers.controls.ButtonState.HOVER
		 */
		public function get hoverState():String
		{
			return this._hoverState;
		}

		/**
		 * @private
		 */
		public function set hoverState(value:String):void
		{
			this._hoverState = value;
		}

		/**
		 * @private
		 */
		protected var _touchPointID:int = -1;

		/**
		 * @private
		 */
		protected var _isEnabled:Boolean = true;

		/**
		 * May be set to <code>false</code> to disable the state changes
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
			if(this._isEnabled === value)
			{
				return;
			}
			this._isEnabled = value;
			if(!value)
			{
				this._touchPointID = -1;
			}
		}

		/**
		 * @private
		 */
		protected var _customHitTest:Function;

		/**
		 * In addition to a normal call to <code>hitTest()</code>, a custom
		 * function may impose additional rules that determine if the target
		 * should change state. Called on <code>TouchPhase.BEGAN</code>.
		 *
		 * <p>The function must have the following signature:</p>
		 *
		 * <pre>function(localPosition:Point):Boolean;</pre>
		 *
		 * <p>The function should return <code>true</code> if the target should
		 * be triggered, and <code>false</code> if it should not be
		 * triggered.</p>
		 */
		public function get customHitTest():Function
		{
			return this._customHitTest;
		}

		/**
		 * @private
		 */
		public function set customHitTest(value:Function):void
		{
			this._customHitTest = value;
		}

		/**
		 * @private
		 */
		protected var _keepDownStateOnRollOut:Boolean = false;

		/**
		 * If <code>true</code>, the button state will remain as
		 * <code>downState</code> until <code>TouchPhase.ENDED</code>. If
		 * <code>false</code>, and the touch leaves the bounds of the button
		 * after <code>TouchPhase.BEGAN</code>, the button state will change to
		 * <code>upState</code>.
		 * 
		 * @default false
		 */
		public function get keepDownStateOnRollOut():Boolean
		{
			return this._keepDownStateOnRollOut;
		}

		/**
		 * @private
		 */
		public function set keepDownStateOnRollOut(value:Boolean):void
		{
			this._keepDownStateOnRollOut = value;
		}

		/**
		 * @private
		 */
		protected function handleCustomHitTest(touch:Touch):Boolean
		{
			if(this._customHitTest === null)
			{
				return true;
			}
			var point:Point = Pool.getPoint();
			touch.getLocation(DisplayObject(this._target), point);
			var isInBounds:Boolean = this._customHitTest(point);
			Pool.putPoint(point);
			return isInBounds;
		}

		/**
		 * @private
		 */
		protected function changeState(value:String):void
		{
			if(this._currentState === value)
			{
				return;
			}
			this._currentState = value;
			if(this._callback !== null)
			{
				this._callback(value);
			}
		}

		/**
		 * @private
		 */
		protected function resetTouchState():void
		{
			this._touchPointID = -1;
			this.changeState(this._upState);
		}

		/**
		 * @private
		 */
		protected function target_removedFromStageHandler(event:Event):void
		{
			this.resetTouchState();
		}

		/**
		 * @private
		 */
		protected function target_touchHandler(event:TouchEvent):void
		{
			if(!this._isEnabled)
			{
				this._touchPointID = -1;
				return;
			}

			if(this._touchPointID >= 0)
			{
				//a touch has begun, so we'll ignore all other touches.
				var touch:Touch = event.getTouch(this._target, null, this._touchPointID);
				if(!touch)
				{
					return;
				}

				var stage:Stage = this._target.stage;
				if(stage !== null)
				{
					var point:Point = Pool.getPoint();
					touch.getLocation(stage, point);
					if(this._target is DisplayObjectContainer)
					{
						var isInBounds:Boolean = DisplayObjectContainer(this._target).contains(stage.hitTest(point));
					}
					else
					{
						isInBounds = this._target === stage.hitTest(point);
					}
					isInBounds &&= this.handleCustomHitTest(touch);
					Pool.putPoint(point);
					if(touch.phase === TouchPhase.MOVED)
					{
						if(this._keepDownStateOnRollOut)
						{
							//nothing to change!
							return;
						}
						if(isInBounds)
						{
							this.changeState(this._downState);
							return;
						}
						else
						{
							this.changeState(this._upState);
							return;
						}
					}
					else if(touch.phase === TouchPhase.ENDED)
					{
						this.resetTouchState();
						return;
					}
				}
			}
			else
			{
				//we aren't tracking another touch, so let's look for a new one.
				touch = event.getTouch(this._target, TouchPhase.BEGAN);
				if(touch !== null && this.handleCustomHitTest(touch))
				{
					this.changeState(this._downState);
					this._touchPointID = touch.id;
					return;
				}
				touch = event.getTouch(this._target, TouchPhase.HOVER);
				if(touch !== null && this.handleCustomHitTest(touch))
				{
					this.changeState(this._hoverState);
					return;
				}

				//end of hover
				this.changeState(this._upState);
			}
		}
	}
}