/*
Feathers
Copyright 2012-2019 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.utils.touch
{
	import feathers.events.FeathersEventType;

	import flash.geom.Point;
	import flash.utils.getTimer;

	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Stage;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.Pool;

	/**
	 * Dispatches <code>FeathersEventType.LONG_PRESS</code> from the target when
	 * the target is long-pressed. Conveniently handles all
	 * <code>TouchEvent</code> listeners automatically. Useful for custom item
	 * renderers that should dispatch a long press event.
	 *
	 * <p>In the following example, a custom item renderer will dispatch
	 * a long press event when tapped:</p>
	 *
	 * <listing version="3.0">
	 * public class CustomItemRenderer extends LayoutGroupListItemRenderer
	 * {
	 *     public function CustomItemRenderer()
	 *     {
	 *         super();
	 *         this._longPress = new LongPress(this);
	 *     }
	 *     
	 *     private var _longPress:LongPress;
	 * }</listing>
	 *
	 * <p>Note: When combined with <code>TapToSelect</code> or
	 * <code>TapToTrigger</code>, the <code>LongPress</code> instance should be
	 * created first because it needs a higher priority for the
	 * <code>TouchEvent.TOUCH</code> event so that it can disable the other
	 * events.</p>
	 *
	 * @see feathers.events.FeathersEventType.LONG_PRESS
	 * @see feathers.utils.touch.TapToTrigger
	 * @see feathers.utils.touch.TapToSelect
	 *
	 * @productversion Feathers 2.3.0
	 */
	public class LongPress
	{
		/**
		 * Constructor.
		 */
		public function LongPress(target:DisplayObject = null)
		{
			this.target = target;
		}

		/**
		 * @private
		 */
		protected var _target:DisplayObject;

		/**
		 * The target component that should dispatch
		 * <code>FeathersEventType.LONG_PRESS</code> when tapped.
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
			if(this._target)
			{
				this._target.removeEventListener(TouchEvent.TOUCH, target_touchHandler);
				this._target.removeEventListener(Event.ENTER_FRAME, target_enterFrameHandler);
			}
			this._target = value;
			if(this._target)
			{
				//if we're changing targets, and a touch is active, we want to
				//clear it.
				this._touchPointID = -1;
				this._target.addEventListener(TouchEvent.TOUCH, target_touchHandler);
			}
		}

		/**
		 * @private
		 */
		protected var _longPressDuration:Number = 0.5;

		/**
		 * The duration, in seconds, of a long press.
		 *
		 * <p>The following example changes the long press duration to one full second:</p>
		 *
		 * <listing version="3.0">
		 * longPress.longPressDuration = 1.0;</listing>
		 *
		 * @default 0.5
		 */
		public function get longPressDuration():Number
		{
			return this._longPressDuration;
		}

		/**
		 * @private
		 */
		public function set longPressDuration(value:Number):void
		{
			this._longPressDuration = value;
		}

		/**
		 * @private
		 */
		protected var _touchPointID:int = -1;

		/**
		 * @private
		 */
		protected var _touchLastGlobalPosition:Point = new Point();

		/**
		 * @private
		 */
		protected var _touchBeginTime:int;

		/**
		 * @private
		 */
		protected var _isEnabled:Boolean = true;

		/**
		 * May be set to <code>false</code> to disable the triggered event
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
		protected var _tapToTrigger:TapToTrigger;

		/**
		 * If the target can be triggered by tapping, the
		 * <code>TapToTrigger</code> instance should be passed in so that it can
		 * be temporarily disabled when a long press is detected.
		 */
		public function get tapToTrigger():TapToTrigger
		{
			return this._tapToTrigger;
		}

		/**
		 * @private
		 */
		public function set tapToTrigger(value:TapToTrigger):void
		{
			this._tapToTrigger = value;
		}

		/**
		 * @private
		 */
		protected var _tapToSelect:TapToSelect;

		/**
		 * If the target can be selected by tapping, the
		 * <code>TapToSelect</code> instance should be passed in so that it can
		 * be temporarily disabled when a long press is detected.
		 */
		public function get tapToSelect():TapToSelect
		{
			return this._tapToSelect;
		}

		/**
		 * @private
		 */
		public function set tapToSelect(value:TapToSelect):void
		{
			this._tapToSelect = value
		}

		/**
		 * @private
		 */
		protected var _customHitTest:Function;

		/**
		 * In addition to a normal call to <code>hitTest()</code>, a custom
		 * function may impose additional rules that determine if the target
		 * should be long pressed. Called on <code>TouchPhase.BEGAN</code>.
		 *
		 * <p>The function must have the following signature:</p>
		 *
		 * <pre>function(localPosition:Point):Boolean;</pre>
		 *
		 * <p>The function should return <code>true</code> if the target should
		 * be long pressed, and <code>false</code> if it should not be
		 * long pressed.</p>
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
					//this should not happen.
					return;
				}

				if(touch.phase == TouchPhase.MOVED)
				{
					this._touchLastGlobalPosition.x = touch.globalX;
					this._touchLastGlobalPosition.y = touch.globalY;
				}
				else if(touch.phase == TouchPhase.ENDED)
				{
					this._target.removeEventListener(Event.ENTER_FRAME, target_enterFrameHandler);

					//re-enable the other events
					if(this._tapToTrigger)
					{
						this._tapToTrigger.isEnabled = true;
					}
					if(this._tapToSelect)
					{
						this._tapToSelect.isEnabled = true;
					}

					//the touch has ended, so now we can start watching for a
					//new one.
					this._touchPointID = -1;
				}
				return;
			}
			else
			{
				//we aren't tracking another touch, so let's look for a new one.
				touch = event.getTouch(DisplayObject(this._target), TouchPhase.BEGAN);
				if(!touch)
				{
					//we only care about the began phase. ignore all other
					//phases when we don't have a saved touch ID.
					return;
				}
				if(this._customHitTest !== null)
				{
					var point:Point = Pool.getPoint();
					touch.getLocation(DisplayObject(this._target), point);
					var isInBounds:Boolean = this._customHitTest(point);
					Pool.putPoint(point);
					if(!isInBounds)
					{
						return;
					}
				}

				//save the touch ID so that we can track this touch's phases.
				this._touchPointID = touch.id;

				//save the position so that we can do a final hit test
				this._touchLastGlobalPosition.x = touch.globalX;
				this._touchLastGlobalPosition.y = touch.globalY;
				
				this._touchBeginTime = getTimer();
				this._target.addEventListener(Event.ENTER_FRAME, target_enterFrameHandler);
			}
		}

		/**
		 * @private
		 */
		protected function target_enterFrameHandler(event:Event):void
		{
			var accumulatedTime:Number = (getTimer() - this._touchBeginTime) / 1000;
			if(accumulatedTime >= this._longPressDuration)
			{
				this._target.removeEventListener(Event.ENTER_FRAME, target_enterFrameHandler);

				var stage:Stage = this._target.stage;
				if(this._target is DisplayObjectContainer)
				{
					var isInBounds:Boolean = DisplayObjectContainer(this._target).contains(stage.hitTest(this._touchLastGlobalPosition));
				}
				else
				{
					isInBounds = this._target === stage.hitTest(this._touchLastGlobalPosition);
				}
				if(isInBounds)
				{
					//disable the other events
					if(this._tapToTrigger)
					{
						this._tapToTrigger.isEnabled = false;
					}
					if(this._tapToSelect)
					{
						this._tapToSelect.isEnabled = false;
					}

					this._target.dispatchEventWith(FeathersEventType.LONG_PRESS);
				}
			}
		}
	}
}
