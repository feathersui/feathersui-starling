/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.utils.touch
{
	import flash.geom.Point;

	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Stage;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * Dispatches <code>Event.TRIGGERED</code> from the target when the target
	 * is tapped. Conveniently handles all <code>TouchEvent</code> listeners
	 * automatically. Useful for custom item renderers that should be triggered
	 * when tapped.
	 *
	 * <p>In the following example, a custom item renderer will be triggered
	 * when tapped:</p>
	 *
	 * <listing version="3.0">
	 * public class CustomItemRenderer extends LayoutGroupListItemRenderer
	 * {
	 *     public function CustomItemRenderer()
	 *     {
	 *         super();
	 *         this._tapToTrigger = new TapToTrigger(this);
	 *     }
	 *     
	 *     private var _tapToTrigger:TapToTrigger;
	 * }</listing>
	 * 
	 * <p>Note: When combined with a <code>TapToSelect</code> instance, the
	 * <code>TapToTrigger</code> instance should be created first because
	 * <code>Event.TRIGGERED</code> should be dispatched before
	 * <code>Event.CHANGE</code>.</p>
	 * 
	 * @see http://doc.starling-framework.org/current/starling/events/Event.html#TRIGGERED starling.events.Event.TRIGGERED
	 * @see feathers.utils.touch.TapToSelect
	 * @see feathers.utils.touch.LongPress
	 */
	public class TapToTrigger
	{
		/**
		 * @private
		 */
		private static const HELPER_POINT:Point = new Point();

		/**
		 * Constructor.
		 */
		public function TapToTrigger(target:DisplayObject = null)
		{
			this.target = target;
		}

		/**
		 * @private
		 */
		protected var _target:DisplayObject;

		/**
		 * The target component that should dispatch
		 * <code>Event.TRIGGERED</code> when tapped.
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
		protected var _touchPointID:int = -1;

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
				
				if(touch.phase == TouchPhase.ENDED)
				{
					var stage:Stage = this._target.stage;
					touch.getLocation(stage, HELPER_POINT);
					if(this._target is DisplayObjectContainer)
					{
						var isInBounds:Boolean = DisplayObjectContainer(this._target).contains(stage.hitTest(HELPER_POINT));
					}
					else
					{
						isInBounds = this._target === stage.hitTest(HELPER_POINT);
					}
					if(isInBounds)
					{
						this._target.dispatchEventWith(Event.TRIGGERED);
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
				
				//save the touch ID so that we can track this touch's phases.
				this._touchPointID = touch.id;
			}
		}
	}
}