/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core
{
	import feathers.controls.Label;

	import flash.utils.getTimer;

	import starling.animation.DelayedCall;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * The default <code>IToolTipManager</code> implementation.
	 *
	 * @see ../../../help/tool-tips.html Tool tips in Feathers
	 * @see feathers.core.ToolTipManager
	 */
	public class DefaultToolTipManager implements IToolTipManager
	{
		/**
		 * The default factory that creates a tool tip. Creates a
		 * <code>Label</code> with the style name
		 * <code>Label.ALTERNATE_STYLE_NAME_TOOL_TIP</code>.
		 *
		 * @see #toolTipFactory
		 * @see feathers.controls.Label
		 * @see feathers.controls.Label#ALTERNATE_STYLE_NAME_TOOL_TIP
		 */
		public static function defaultToolTipFactory():IToolTip
		{
			var toolTip:Label = new Label();
			toolTip.styleNameList.add(Label.ALTERNATE_STYLE_NAME_TOOL_TIP);
			return toolTip;
		}
		
		/**
		 * Constructor.
		 */
		public function DefaultToolTipManager(root:DisplayObjectContainer)
		{
			this._root = root;
			this._root.addEventListener(TouchEvent.TOUCH, root_touchHandler);
		}

		/**
		 * @private
		 */
		protected var _touchPointID:int = -1;
		
		/**
		 * @private
		 */
		protected var _delayedCall:DelayedCall;

		/**
		 * @private
		 */
		protected var _toolTipX:Number = 0;

		/**
		 * @private
		 */
		protected var _toolTipY:Number = 0;

		/**
		 * @private
		 */
		protected var _hideTime:int = 0;

		/**
		 * @private
		 */
		protected var _root:DisplayObjectContainer;

		/**
		 * @private
		 */
		protected var _target:IFeathersControl;

		/**
		 * @private
		 */
		protected var _toolTip:IToolTip;

		/**
		 * @private
		 */
		protected var _toolTipFactory:Function;

		/**
		 * A function that creates a tool tip.
		 *
		 * <p>This function is expected to have the following signature:</p>
		 * <pre>function():IToolTip</pre>
		 *
		 * @see feathers.core.IToolTip
		 */
		public function get toolTipFactory():Function
		{
			return this._toolTipFactory;
		}

		/**
		 * @private
		 */
		public function set toolTipFactory(value:Function):void
		{
			if(this._toolTipFactory === value)
			{
				return;
			}
			this._toolTipFactory = value;
			if(this._toolTip)
			{
				this._toolTip.removeFromParent(true);
				this._toolTip = null;
			}
		}

		/**
		 * @private
		 */
		protected var _showDelay:Number = 0.5;

		/**
		 * The delay, in seconds, before a tool tip may be displayed when the
		 * mouse is idle over a component with a tool tip.
		 * 
		 * @default 0.5
		 */
		public function get showDelay():Number
		{
			return this._showDelay;
		}

		/**
		 * @private
		 */
		public function set showDelay(value:Number):void
		{
			this._showDelay = value;
		}

		/**
		 * @private
		 */
		protected var _delayThreshold:Number = 0.1;

		/**
		 * The time, in seconds, after hiding a tool tip before the
		 * <code>showDelay</code> is required to show a new tool tip for another
		 * component. If the mouse is over a component before this threshold,
		 * the tool tip will be shown immediately. This allows tooltips for
		 * adjacent components, such as those appearing in toolbars, to be shown
		 * quickly.
		 * 
		 * <p>To disable this behavior, set the <code>delayThreshold</code> to
		 * <code>0</code>.
		 *
		 * @default 0.1
		 */
		public function get delayThreshold():Number
		{
			return this._delayThreshold;
		}

		/**
		 * @private
		 */
		public function set delayThreshold(value:Number):void
		{
			this._delayThreshold = value;
		}

		/**
		 * @private
		 */
		protected var _offsetX:Number = 0;

		/**
		 * The offset, in pixels, of the tool tip position on the x axis.
		 * 
		 * @default 0
		 */
		public function get offsetX():Number
		{
			return this._offsetX;
		}

		/**
		 * @private
		 */
		public function set offsetX(value:Number):void
		{
			this._offsetX = value;
		}

		/**
		 * @private
		 */
		protected var _offsetY:Number = 0;

		/**
		 * The offset, in pixels, of the tool tip position on the y axis.
		 *
		 * @default 0
		 */
		public function get offsetY():Number
		{
			return this._offsetY;
		}

		/**
		 * @private
		 */
		public function set offsetY(value:Number):void
		{
			this._offsetY = value;
		}
		
		/**
		 * @copy feathers.core.IToolTipManager#dispose()
		 */
		public function dispose():void
		{
			this._root.removeEventListener(TouchEvent.TOUCH, root_touchHandler);
			this._root = null;
			
			if(Starling.juggler.contains(this._delayedCall))
			{
				Starling.juggler.remove(this._delayedCall);
				this._delayedCall = null;
			}
			
			if(this._toolTip)
			{
				this._toolTip.removeFromParent(true);
				this._toolTip = null;
			}
		}

		/**
		 * @private
		 */
		protected function getTarget(touch:Touch):IFeathersControl
		{
			var target:DisplayObject = touch.target;
			while(target !== null)
			{
				if(target is IFeathersControl)
				{
					var toolTipSource:IFeathersControl = IFeathersControl(target);
					if(toolTipSource.toolTip)
					{
						return toolTipSource;
					}
				}
				target = target.parent;
			}
			return null;
		}

		/**
		 * @private
		 */
		protected function hoverDelayCallback():void
		{
			if(!this._toolTip)
			{
				var factory:Function = this._toolTipFactory !== null ? this._toolTipFactory : defaultToolTipFactory;
				var toolTip:Label = factory();
				toolTip.touchable = false;
				this._toolTip = toolTip;
			}
			this._toolTip.text = this._target.toolTip;
			this._toolTip.validate();
			var toolTipX:Number = this._toolTipX + this._offsetX;
			if(toolTipX < 0)
			{
				toolTipX = 0;
			}
			else if((toolTipX + this._toolTip.width) > this._target.stage.stageWidth)
			{
				toolTipX = this._target.stage.stageWidth - this._toolTip.width;
			}
			var toolTipY:Number = this._toolTipY - this._toolTip.height + this._offsetY;
			if(toolTipY < 0)
			{
				toolTipY = 0;
			}
			else if((toolTipY + this._toolTip.height) > this._target.stage.stageHeight)
			{
				toolTipY = this._target.stage.stageHeight - this._toolTip.height;
			}
			this._toolTip.x = toolTipX;
			this._toolTip.y = toolTipY;
			PopUpManager.addPopUp(DisplayObject(this._toolTip), false, false);
		}

		/**
		 * @private
		 */
		protected function root_touchHandler(event:TouchEvent):void
		{
			if(this._toolTip !== null && this._toolTip.parent !== null)
			{
				var touch:Touch = event.getTouch(DisplayObject(this._target), null, this._touchPointID);
				if(!touch || touch.phase !== TouchPhase.HOVER)
				{
					//to avoid excessive garbage collection, we reuse the
					//tooltip object
					PopUpManager.removePopUp(DisplayObject(this._toolTip), false);
					this._touchPointID = -1;
					this._target = null;
					this._hideTime = getTimer();
				}
				return;
			}
			if(this._target !== null)
			{
				touch = event.getTouch(DisplayObject(this._target), null, this._touchPointID);
				if(!touch || touch.phase !== TouchPhase.HOVER)
				{
					Starling.juggler.remove(this._delayedCall);
					this._touchPointID = -1;
					this._target = null;
					return;
				}
				
				//every time TouchPhase.HOVER is dispatched, the mouse has
				//moved. we need to reset the timer and update the position
				//where the tool tip will appear when the timer completes
				this._toolTipX = touch.globalX;
				this._toolTipY = touch.globalY;
				this._delayedCall.reset(hoverDelayCallback, this._showDelay);
			}
			else
			{
				touch = event.getTouch(this._root, TouchPhase.HOVER);
				if(!touch)
				{
					return;
				}
				this._target = this.getTarget(touch);
				if(!this._target)
				{
					return;
				}
				this._touchPointID = touch.id;
				this._toolTipX = touch.globalX;
				this._toolTipY = touch.globalY;
				var timeSinceHide:Number = (getTimer() - this._hideTime) / 1000;
				if(timeSinceHide < this._delayThreshold)
				{
					this.hoverDelayCallback();
					return;
				}
				if(this._delayedCall)
				{
					//to avoid excessive garbage collection, we reuse the
					//DelayedCall object.
					this._delayedCall.reset(hoverDelayCallback, this._showDelay);
				}
				else
				{
					this._delayedCall = new DelayedCall(hoverDelayCallback, this._showDelay);
				}
				Starling.juggler.add(this._delayedCall);
			}
		}
	}
}
