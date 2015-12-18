/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.utils.touch
{
	import feathers.core.IToggle;

	import flash.geom.Point;

	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Stage;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * Changes the <code>isSelected</code> property of the target when the
	 * target is tapped (which will dispatch <code>Event.CHANGE</code>).
	 * Conveniently handles all <code>TouchEvent</code> listeners automatically.
	 * Useful for custom item renderers that should be selected when tapped.
	 *
	 * <p>In the following example, a custom item renderer will be selected when
	 * tapped:</p>
	 *
	 * <listing version="3.0">
	 * public class CustomItemRenderer extends LayoutGroupListItemRenderer
	 * {
	 *     public function CustomItemRenderer()
	 *     {
	 *         super();
	 *         this._tapToSelect = new TapToSelect(this);
	 *     }
	 *     
	 *     private var _tapToSelect:TapToSelect;
	 * }</listing>
	 *
	 * <p>Note: When combined with a <code>TapToTrigger</code> instance, the
	 * <code>TapToSelect</code> instance should be created second because
	 * <code>Event.TRIGGERED</code> should be dispatched before
	 * <code>Event.CHANGE</code>.</p>
	 * 
	 * @see feathers.utils.touch.TapToTrigger
	 * @see feathers.utils.touch.LongPress
	 */
	public class TapToSelect
	{
		/**
		 * @private
		 */
		private static const HELPER_POINT:Point = new Point();

		/**
		 * Constructor.
		 */
		public function TapToSelect(target:IToggle = null)
		{
			this.target = target;
		}

		/**
		 * @private
		 */
		protected var _target:IToggle;

		/**
		 * The target component that should be selected when tapped.
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
		protected var _tapToDeselect:Boolean = false;

		/**
		 * May be set to <code>true</code> to allow the target to be deselected
		 * when tapped.
		 */
		public function get tapToDeselect():Boolean
		{
			return this._tapToDeselect;
		}

		/**
		 * @private
		 */
		public function set tapToDeselect(value:Boolean):void
		{
			this._tapToDeselect = value;
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
				var touch:Touch = event.getTouch(DisplayObject(this._target), null, this._touchPointID);
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
						if(this._tapToDeselect)
						{
							this._target.isSelected = !this._target.isSelected;
						}
						else
						{
							this._target.isSelected = true;
						}
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