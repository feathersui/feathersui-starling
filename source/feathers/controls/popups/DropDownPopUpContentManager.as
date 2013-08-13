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
	import feathers.utils.display.getDisplayObjectDepthFromStage;

	import flash.errors.IllegalOperationError;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
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
	 * Displays pop-up content as a desktop-style drop-down.
	 */
	public class DropDownPopUpContentManager extends EventDispatcher implements IPopUpContentManager
	{
		/**
		 * Constructor.
		 */
		public function DropDownPopUpContentManager()
		{
		}

		/**
		 * @private
		 */
		protected var content:DisplayObject;

		/**
		 * @private
		 */
		protected var source:DisplayObject;

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
			this.source = source;
			PopUpManager.addPopUp(this.content, false, false);
			if(this.content is IFeathersControl)
			{
				this.content.addEventListener(FeathersEventType.RESIZE, content_resizeHandler);
			}
			this.layout();
			Starling.current.stage.addEventListener(TouchEvent.TOUCH, stage_touchHandler);
			Starling.current.stage.addEventListener(ResizeEvent.RESIZE, stage_resizeHandler);

			//using priority here is a hack so that objects higher up in the
			//display list have a chance to cancel the event first.
			var priority:int = -getDisplayObjectDepthFromStage(this.content);
			Starling.current.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, nativeStage_keyDownHandler, false, priority, true);
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
			Starling.current.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN, nativeStage_keyDownHandler);
			if(this.content is IFeathersControl)
			{
				this.content.removeEventListener(FeathersEventType.RESIZE, content_resizeHandler);
			}
			PopUpManager.removePopUp(this.content);
			this.content = null;
			this.source = null;
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
			const globalOrigin:Rectangle = this.source.getBounds(Starling.current.stage);

			if(this.source is IFeathersControl)
			{
				IFeathersControl(this.source).validate();
			}
			if(this.content is IFeathersControl)
			{
				const uiContent:IFeathersControl = IFeathersControl(this.content);
				uiContent.minWidth = Math.max(uiContent.minWidth, this.source.width);
				uiContent.validate();
			}
			else
			{
				this.content.width = Math.max(this.content.width, this.source.width);
			}

			const downSpace:Number = (Starling.current.stage.stageHeight - this.content.height) - (globalOrigin.y + globalOrigin.height);
			if(downSpace >= 0)
			{
				layoutBelow(globalOrigin);
				return;
			}

			const upSpace:Number = globalOrigin.y - this.content.height;
			if(upSpace >= 0)
			{
				layoutAbove(globalOrigin);
				return;
			}

			//worst case: pick the side that has the most available space
			if(upSpace >= downSpace)
			{
				layoutAbove(globalOrigin);
			}
			else
			{
				layoutBelow(globalOrigin);
			}

		}

		/**
		 * @private
		 */
		protected function layoutAbove(globalOrigin:Rectangle):void
		{
			const idealXPosition:Number = globalOrigin.x + (globalOrigin.width - this.content.width) / 2;
			const xPosition:Number = Math.max(0, Math.min(Starling.current.stage.stageWidth - this.content.width, idealXPosition));
			this.content.x = xPosition;
			this.content.y = globalOrigin.y - this.content.height;
		}

		/**
		 * @private
		 */
		protected function layoutBelow(globalOrigin:Rectangle):void
		{
			const idealXPosition:Number = globalOrigin.x;
			const xPosition:Number = Math.max(0, Math.min(Starling.current.stage.stageWidth - this.content.width, idealXPosition));
			this.content.x = xPosition;
			this.content.y = globalOrigin.y + globalOrigin.height;
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
		protected function nativeStage_keyDownHandler(event:KeyboardEvent):void
		{
			if(event.isDefaultPrevented())
			{
				//someone else already handled this one
				return;
			}
			if(event.keyCode != Keyboard.BACK && event.keyCode != Keyboard.ESCAPE)
			{
				return;
			}
			//don't let the OS handle the event
			event.preventDefault();

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
			const target:DisplayObject = DisplayObject(event.target);
			if(this.content == target || (this.content is DisplayObjectContainer && DisplayObjectContainer(this.content).contains(target)))
			{
				return;
			}
			if(this.source == target || (this.source is DisplayObjectContainer && DisplayObjectContainer(this.source).contains(target)))
			{
				return;
			}
			if(!PopUpManager.isTopLevelPopUp(this.content))
			{
				return;
			}
			//any began touch is okay here. we don't need to check all touches
			const touch:Touch = event.getTouch(Starling.current.stage, TouchPhase.BEGAN);
			if(!touch)
			{
				return;
			}
			this.close();
		}
	}
}
