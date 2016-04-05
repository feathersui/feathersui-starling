/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.core.FeathersControl;
	import feathers.core.IMeasureDisplayObject;
	import feathers.core.IStateContext;
	import feathers.core.IStateObserver;
	import feathers.core.IValidating;
	import feathers.events.FeathersEventType;
	import feathers.utils.skins.resetBackgroundDimensionsForMeasurement;
	import feathers.utils.touch.TapToTrigger;

	import flash.geom.Point;

	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * Dispatched when the the user taps or clicks the button. The touch must
	 * remain within the bounds of the button on release to register as a tap
	 * or a click. If focus management is enabled, the button may also be
	 * triggered by pressing the spacebar while the button has focus.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>null</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @eventType starling.events.Event.TRIGGERED
	 */
	[Event(name="triggered",type="starling.events.Event")]

	/**
	 * Dispatched when the display object's state changes.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>null</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @eventType feathers.events.FeathersEventType.STATE_CHANGE
	 *
	 * @see #currentState
	 */
	[Event(name="stateChange",type="starling.events.Event")]
	
	/**
	 * A simple button control with states, but no content, that is useful for
	 * purposes like skinning. For a more full-featured button, with a label and
	 * icon, see <code>feathers.controls.Button</code> instead.
	 * 
	 * @see feathers.controls.Button
	 */
	public class BasicButton extends FeathersControl implements IStateContext
	{
		/**
		 * @private
		 */
		private static const HELPER_POINT:Point = new Point();
		
		/**
		 * Constructor.
		 */
		public function BasicButton()
		{
			super();
			this.isQuickHitAreaEnabled = true;
			this.addEventListener(Event.REMOVED_FROM_STAGE, basicButton_removedFromStageHandler);
			this.addEventListener(TouchEvent.TOUCH, basicButton_touchHandler);
		}

		/**
		 * @private
		 */
		protected var tapToTrigger:TapToTrigger;

		/**
		 * The saved ID of the currently active touch. The value will be
		 * <code>-1</code> if there is no currently active touch.
		 *
		 * <p>For internal use in subclasses.</p>
		 */
		protected var touchPointID:int = -1;

		/**
		 * @private
		 */
		protected var _currentState:String = ButtonState.UP;

		/**
		 * The current state of the button.
		 *
		 * @see feathers.controls.ButtonState
		 * @see #event:stateChange feathers.events.FeathersEventType.STATE_CHANGE
		 */
		public function get currentState():String
		{
			return this._currentState;
		}

		/**
		 * The currently visible skin. The value will be <code>null</code> if
		 * there is no currently visible skin.
		 *
		 * <p>For internal use in subclasses.</p>
		 */
		protected var currentSkin:DisplayObject;

		/**
		 * @private
		 */
		override public function set isEnabled(value:Boolean):void
		{
			if(this._isEnabled === value)
			{
				return;
			}
			super.isEnabled = value;
			if(this._isEnabled)
			{
				//might be in another state for some reason
				//let's only change to up if needed
				if(this._currentState === ButtonState.DISABLED)
				{
					this.changeState(ButtonState.UP);
				}
			}
			else
			{
				this.resetTouchState();
			}
		}

		/**
		 * @private
		 */
		protected var _keepDownStateOnRollOut:Boolean = false;

		/**
		 * Determines if a pressed button should remain in the down state if a
		 * touch moves outside of the button's bounds. Useful for controls like
		 * <code>Slider</code> and <code>ToggleSwitch</code> to keep a thumb in
		 * the down state while it is dragged around.
		 *
		 * <p>The following example ensures that the button's down state remains
		 * active when the button is pressed but the touch moves outside the
		 * button's bounds:</p>
		 *
		 * <listing version="3.0">
		 * button.keepDownStateOnRollOut = true;</listing>
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
		protected var _defaultSkin:DisplayObject;

		/**
		 * The skin used when no other skin is defined for the current state.
		 * Intended to be used when multiple states should share the same skin.
		 *
		 * <p>The following example gives the button a default skin to use for
		 * all states when no specific skin is available:</p>
		 *
		 * <listing version="3.0">
		 * button.defaultSkin = new Image( texture );</listing>
		 *
		 * @default null
		 *
		 * @see #setSkinForState()
		 */
		public function get defaultSkin():DisplayObject
		{
			return this._defaultSkin;
		}

		/**
		 * @private
		 */
		public function set defaultSkin(value:DisplayObject):void
		{
			if(this._defaultSkin === value)
			{
				return;
			}
			this._defaultSkin = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 * Chooses an appropriate skin based on the state and the selection.
		 */
		protected var _stateToSkin:Object = {};

		/**
		 * @private
		 */
		protected var _explicitSkinWidth:Number = NaN;

		/**
		 * @private
		 */
		protected var _explicitSkinHeight:Number = NaN;

		/**
		 * @private
		 */
		protected var _explicitSkinMinWidth:Number = NaN;

		/**
		 * @private
		 */
		protected var _explicitSkinMinHeight:Number = NaN;

		/**
		 * Gets the skin to be used by the button when its
		 * <code>currentState</code> property matches the specified state value.
		 *
		 * <p>If a skin is not defined for a specific state, returns
		 * <code>null</code>.</p>
		 *
		 * @see #setSkinForState()
		 */
		public function getSkinForState(state:String):DisplayObject
		{
			return this._stateToSkin[state] as DisplayObject;
		}

		/**
		 * Sets the skin to be used by the button when its
		 * <code>currentState</code> property matches the specified state value.
		 *
		 * <p>If a skin is not defined for a specific state, the value of the
		 * <code>defaultSkin</code> property will be used instead.</p>
		 *
		 * @see #defaultSkin
		 * @see #getSkinForState()
		 * @see feathers.controls.ButtonState
		 */
		public function setSkinForState(state:String, skin:DisplayObject):void
		{
			if(skin !== null)
			{
				this._stateToSkin[state] = skin;
			}
			else
			{
				delete this._stateToSkin[state];
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		override public function dispose():void
		{
			//we don't dispose it if the button is the parent because it'll
			//already get disposed in super.dispose()
			if(this._defaultSkin !== null && this._defaultSkin.parent !== this)
			{
				this._defaultSkin.dispose();
			}
			for(var state:String in this._stateToSkin)
			{
				var skin:DisplayObject = this._stateToSkin[state] as DisplayObject;
				if(skin !== null && skin.parent !== this)
				{
					skin.dispose();
				}
			}
			super.dispose();
		}

		/**
		 * @private
		 */
		override protected function initialize():void
		{
			super.initialize();
			if(!this.tapToTrigger)
			{
				this.tapToTrigger = new TapToTrigger(this);
			}
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			var stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			var stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);

			if(stylesInvalid || stateInvalid)
			{
				this.refreshTriggeredEvents();
				this.refreshSkin();
			}

			this.autoSizeIfNeeded();

			if(stylesInvalid || stateInvalid || sizeInvalid)
			{
				this.scaleSkin();
			}
		}

		/**
		 * If the component's dimensions have not been set explicitly, it will
		 * measure its content and determine an ideal size for itself. If the
		 * <code>explicitWidth</code> or <code>explicitHeight</code> member
		 * variables are set, those value will be used without additional
		 * measurement. If one is set, but not the other, the dimension with the
		 * explicit value will not be measured, but the other non-explicit
		 * dimension will still need measurement.
		 *
		 * <p>Calls <code>setSizeInternal()</code> to set up the
		 * <code>actualWidth</code> and <code>actualHeight</code> member
		 * variables used for layout.</p>
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 */
		protected function autoSizeIfNeeded():Boolean
		{
			var needsWidth:Boolean = this._explicitWidth !== this._explicitWidth; //isNaN
			var needsHeight:Boolean = this._explicitHeight !== this._explicitHeight; //isNaN
			var needsMinWidth:Boolean = this._explicitMinWidth !== this._explicitMinWidth; //isNaN
			var needsMinHeight:Boolean = this._explicitMinHeight !== this._explicitMinHeight; //isNaN
			if(!needsWidth && !needsHeight && !needsMinWidth && !needsMinHeight)
			{
				return false;
			}

			resetBackgroundDimensionsForMeasurement(this.currentSkin,
				this._explicitWidth, this._explicitHeight,
				this._explicitMinWidth, this._explicitMinHeight,
				this._explicitSkinWidth, this._explicitSkinHeight,
				this._explicitSkinMinWidth, this._explicitSkinMinHeight);
			var measureSkin:IMeasureDisplayObject = this.currentSkin as IMeasureDisplayObject;

			if(this.currentSkin is IValidating)
			{
				IValidating(this.currentSkin).validate();
			}

			var newMinWidth:Number = this._explicitMinWidth;
			if(needsMinWidth)
			{
				if(measureSkin !== null)
				{
					newMinWidth = measureSkin.minWidth;
				}
				else if(this.currentSkin !== null)
				{
					newMinWidth = this.currentSkin.width;
				}
				else
				{
					newMinWidth = 0;
				}
			}

			var newMinHeight:Number = this._explicitMinHeight;
			if(needsMinHeight)
			{
				if(measureSkin !== null)
				{
					newMinHeight = measureSkin.minHeight;
				}
				else if(this.currentSkin !== null)
				{
					newMinHeight = this.currentSkin.height;
				}
				else
				{
					newMinHeight = 0;
				}
			}

			var newWidth:Number = this._explicitWidth;
			if(needsWidth)
			{
				if(this.currentSkin !== null)
				{
					newWidth = this.currentSkin.width;
				}
				else
				{
					newWidth = 0;
				}
			}

			var newHeight:Number = this._explicitHeight;
			if(needsHeight)
			{
				if(this.currentSkin !== null)
				{
					newHeight = this.currentSkin.height;
				}
				else
				{
					newHeight = 0;
				}
			}

			return this.saveMeasurements(newWidth, newHeight, newMinWidth, newMinHeight);
		}

		/**
		 * Sets the <code>currentSkin</code> property.
		 *
		 * <p>For internal use in subclasses.</p>
		 */
		protected function refreshSkin():void
		{
			var oldSkin:DisplayObject = this.currentSkin;
			this.currentSkin = this.getCurrentSkin();
			if(this.currentSkin !== oldSkin)
			{
				if(oldSkin)
				{
					if(oldSkin is IStateObserver)
					{
						IStateObserver(oldSkin).stateContext = null;
					}
					this.removeChild(oldSkin, false);
				}
				if(this.currentSkin)
				{
					if(this.currentSkin is IMeasureDisplayObject)
					{
						var measureSkin:IMeasureDisplayObject = IMeasureDisplayObject(this.currentSkin);
						this._explicitSkinWidth = measureSkin.explicitWidth;
						this._explicitSkinHeight = measureSkin.explicitHeight;
						this._explicitSkinMinWidth = measureSkin.explicitMinWidth;
						this._explicitSkinMinHeight = measureSkin.explicitMinHeight;
					}
					else
					{
						this._explicitSkinWidth = this.currentSkin.width;
						this._explicitSkinHeight = this.currentSkin.height;
						this._explicitSkinMinWidth = this._explicitSkinWidth;
						this._explicitSkinMinHeight = this._explicitSkinHeight;
					}
					if(this.currentSkin is IStateObserver)
					{
						IStateObserver(this.currentSkin).stateContext = this;
					}
					this.addChildAt(this.currentSkin, 0);
				}
			}
		}

		/**
		 * @private
		 */
		protected function getCurrentSkin():DisplayObject
		{
			var result:DisplayObject = this._stateToSkin[this._currentState] as DisplayObject;
			if(result !== null)
			{
				return result;
			}
			return this._defaultSkin;
		}

		/**
		 * @private
		 */
		protected function scaleSkin():void
		{
			if(!this.currentSkin)
			{
				return;
			}
			this.currentSkin.x = 0;
			this.currentSkin.y = 0;
			if(this.currentSkin.width !== this.actualWidth)
			{
				this.currentSkin.width = this.actualWidth;
			}
			if(this.currentSkin.height !== this.actualHeight)
			{
				this.currentSkin.height = this.actualHeight;
			}
			if(this.currentSkin is IValidating)
			{
				IValidating(this.currentSkin).validate();
			}
		}

		/**
		 * @private
		 */
		protected function refreshTriggeredEvents():void
		{
			this.tapToTrigger.isEnabled = this._isEnabled;
		}

		/**
		 * @private
		 */
		protected function changeState(state:String):void
		{
			if(this._currentState === state)
			{
				return;
			}
			this._currentState = state;
			this.invalidate(INVALIDATION_FLAG_STATE);
			this.dispatchEventWith(FeathersEventType.STATE_CHANGE);
		}

		/**
		 * @private
		 */
		protected function resetTouchState(touch:Touch = null):void
		{
			this.touchPointID = -1;
			if(this._isEnabled)
			{
				this.changeState(ButtonState.UP);
			}
			else
			{
				this.changeState(ButtonState.DISABLED);
			}
		}

		/**
		 * @private
		 */
		protected function basicButton_removedFromStageHandler(event:Event):void
		{
			this.resetTouchState();
		}

		/**
		 * @private
		 */
		protected function basicButton_touchHandler(event:TouchEvent):void
		{
			if(!this._isEnabled)
			{
				this.touchPointID = -1;
				return;
			}

			if(this.touchPointID >= 0)
			{
				var touch:Touch = event.getTouch(this, null, this.touchPointID);
				if(!touch)
				{
					//this should never happen
					return;
				}

				touch.getLocation(this.stage, HELPER_POINT);
				var isInBounds:Boolean = this.contains(this.stage.hitTest(HELPER_POINT));
				if(touch.phase === TouchPhase.MOVED)
				{
					if(isInBounds || this._keepDownStateOnRollOut)
					{
						this.changeState(ButtonState.DOWN);
					}
					else
					{
						this.changeState(ButtonState.UP);
					}
				}
				else if(touch.phase === TouchPhase.ENDED)
				{
					this.resetTouchState(touch);
				}
				return;
			}
			else //if we get here, we don't have a saved touch ID yet
			{
				touch = event.getTouch(this, TouchPhase.BEGAN);
				if(touch)
				{
					this.changeState(ButtonState.DOWN);
					this.touchPointID = touch.id;
					return;
				}
				touch = event.getTouch(this, TouchPhase.HOVER);
				if(touch)
				{
					this.changeState(ButtonState.HOVER);
					return;
				}

				//end of hover
				this.changeState(ButtonState.UP);
			}
		}
	}
}
