/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.popups
{
	import feathers.core.IFeathersControl;
	import feathers.core.PopUpManager;
	import feathers.events.FeathersEventType;

	import flash.errors.IllegalOperationError;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Stage;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.events.ResizeEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * @inheritDoc
	 */
	[Event(name="close",type="starling.events.Event")]

	/**
	 * Displays a pop-up at the center of the stage, filling the vertical space.
	 * The content will be sized horizontally so that it is no larger than the
	 * the width or height of the stage (whichever is smaller).
	 */
	public class VerticalCenteredPopUpContentManager extends EventDispatcher implements IPopUpContentManager
	{
		/**
		 * @private
		 */
		private static const HELPER_POINT:Point = new Point();

		/**
		 * Constructor.
		 */
		public function VerticalCenteredPopUpContentManager()
		{
		}

		/**
		 * The minimum space, in pixels, between the top edge of the content and
		 * the top edge of the stage.
		 */
		public var marginTop:Number = 0;

		/**
		 * The minimum space, in pixels, between the right edge of the content
		 * and the right edge of the stage.
		 */
		public var marginRight:Number = 0;

		/**
		 * The minimum space, in pixels, between the bottom edge of the content
		 * and the bottom edge of the stage.
		 */
		public var marginBottom:Number = 0;

		/**
		 * The minimum space, in pixels, between the left edge of the content
		 * and the left edge of the stage.
		 */
		public var marginLeft:Number = 0;

		/**
		 * @private
		 */
		protected var content:DisplayObject;

		/**
		 * @private
		 */
		protected var touchPointID:int = -1;

		/**
		 * @inheritDoc
		 */
		public function open(content:DisplayObject, source:DisplayObject):void
		{
			if(this.content)
			{
				throw new IllegalOperationError("Pop-up content is already defined.");
			}

			this.content = content;
			PopUpManager.addPopUp(this.content, true, false);
			if(this.content is IFeathersControl)
			{
				const uiContent:IFeathersControl = IFeathersControl(this.content);
				this.content.addEventListener(FeathersEventType.RESIZE, content_resizeHandler);
			}
			this.layout();
			Starling.current.stage.addEventListener(TouchEvent.TOUCH, stage_touchHandler);
			Starling.current.stage.addEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
			Starling.current.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler, false, int.MAX_VALUE, true);
		}

		/**
		 * @inheritDoc
		 */
		public function close():void
		{
			if(!this.content)
			{
				return;
			}
			Starling.current.stage.removeEventListener(TouchEvent.TOUCH, stage_touchHandler);
			Starling.current.stage.removeEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
			Starling.current.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
			if(this.content is IFeathersControl)
			{
				this.content.removeEventListener(FeathersEventType.RESIZE, content_resizeHandler);
			}
			PopUpManager.removePopUp(this.content);
			this.content = null;
			this.dispatchEventWith(Event.CLOSE);
		}

		/**
		 * @inheritDoc
		 */
		public function dispose():void
		{
			this.close();
		}

		/**
		 * @private
		 */
		protected function layout():void
		{
			const maxWidth:Number = Math.min(Starling.current.stage.stageWidth, Starling.current.stage.stageHeight) - this.marginLeft - this.marginRight;
			const maxHeight:Number = Starling.current.stage.stageHeight - this.marginTop - this.marginBottom;
			if(this.content is IFeathersControl)
			{
				const uiContent:IFeathersControl = IFeathersControl(this.content);
				uiContent.minWidth = uiContent.maxWidth = maxWidth;
				uiContent.maxHeight = maxHeight;
				uiContent.validate();
			}

			//if it's a ui control that is able to auto-size, the above
			//section will ensure that the control stays within the required
			//bounds.
			//if it's not a ui control, or if the control's explicit width
			//and height values are greater than our maximum bounds, then we
			//will enforce the maximum bounds the hard way.
			if(this.content.width > maxWidth)
			{
				this.content.width = maxWidth;
			}
			if(this.content.height > maxHeight)
			{
				this.content.height = maxHeight;
			}
			this.content.x = (Starling.current.stage.stageWidth - this.content.width) / 2;
			this.content.y = (Starling.current.stage.stageHeight - this.content.height) / 2;
		}

		/**
		 * @private
		 */
		protected function content_resizeHandler(event:Event):void
		{
			this.layout();
		}

		/**
		 * @private
		 */
		protected function stage_keyDownHandler(event:KeyboardEvent):void
		{
			if(event.keyCode != Keyboard.BACK && event.keyCode != Keyboard.ESCAPE)
			{
				return;
			}
			//don't let the OS handle the event
			event.preventDefault();
			//don't let other event handlers handle the event
			event.stopImmediatePropagation();
			this.close();
		}

		/**
		 * @private
		 */
		protected function stage_resizeHandler(event:ResizeEvent):void
		{
			this.layout();
		}

		/**
		 * @private
		 */
		protected function stage_touchHandler(event:TouchEvent):void
		{
			if(!PopUpManager.isTopLevelPopUp(this.content))
			{
				return;
			}
			const stage:Stage = Starling.current.stage;
			if(this.touchPointID >= 0)
			{
				var touch:Touch = event.getTouch(stage, TouchPhase.ENDED, this.touchPointID);
				if(!touch)
				{
					return;
				}
				touch.getLocation(stage, HELPER_POINT);
				const hitTestResult:DisplayObject = stage.hitTest(HELPER_POINT, true);
				var isInBounds:Boolean = false;
				if(this.content is DisplayObjectContainer)
				{
					isInBounds = DisplayObjectContainer(this.content).contains(hitTestResult);
				}
				else
				{
					isInBounds = this.content == hitTestResult;
				}
				if(!isInBounds)
				{
					this.touchPointID = -1;
					this.close();
				}
			}
			else
			{
				touch = event.getTouch(stage, TouchPhase.BEGAN);
				if(!touch)
				{
					return;
				}
				this.touchPointID = touch.id;
			}
		}


	}
}
