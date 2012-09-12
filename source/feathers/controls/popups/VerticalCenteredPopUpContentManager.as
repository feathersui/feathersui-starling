/*
 Copyright (c) 2012 Josh Tynjala

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 */
package feathers.controls.popups
{
	import flash.errors.IllegalOperationError;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	import feathers.core.FeathersControl;
	import feathers.core.PopUpManager;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.ResizeEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * Displays a pop-up at the center of the stage, filling the vertical space.
	 * The content will be sized horizontally so that it is no larger than the
	 * the width or height of the stage (whichever is smaller).
	 */
	public class VerticalCenteredPopUpContentManager implements IPopUpContentManager
	{
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
		 * @private
		 */
		private var _onClose:Signal = new Signal(VerticalCenteredPopUpContentManager);

		/**
		 * @inheritDoc
		 */
		public function get onClose():ISignal
		{
			return this._onClose;
		}

		/**
		 * @inheritDoc
		 */
		public function open(content:DisplayObject, source:DisplayObject):void
		{
			if(this.content)
			{
				throw new IllegalOperationError("Pop-up content is already defined.")
			}

			this.content = content;
			PopUpManager.addPopUp(this.content, true, false);
			if(this.content is FeathersControl)
			{
				const uiContent:FeathersControl = FeathersControl(this.content);
				uiContent.onResize.add(content_resizeHandler);
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
			if(this.content is FeathersControl)
			{
				FeathersControl(this.content).onResize.remove(content_resizeHandler);
			}
			PopUpManager.removePopUp(this.content);
			this.content = null;
			this._onClose.dispatch(this);
		}

		/**
		 * @inheritDoc
		 */
		public function dispose():void
		{
			this.close();
			this._onClose.removeAll();
		}

		/**
		 * @private
		 */
		protected function layout():void
		{
			const maxWidth:Number = Math.min(Starling.current.stage.stageWidth, Starling.current.stage.stageHeight) - this.marginLeft - this.marginRight;
			const maxHeight:Number = Starling.current.stage.stageHeight - this.marginTop - this.marginBottom;
			if(this.content is FeathersControl)
			{
				const uiContent:FeathersControl = FeathersControl(this.content);
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
		protected function content_resizeHandler(content:FeathersControl, oldWidth:Number, oldHeight:Number):void
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
			if(event.interactsWith(this.content))
			{
				return;
			}
			const touches:Vector.<Touch> = event.getTouches(Starling.current.stage);
			if(touches.length == 0)
			{
				return;
			}
			if(this.touchPointID >= 0)
			{
				var touch:Touch;
				for each(var currentTouch:Touch in touches)
				{
					if(currentTouch.id == this.touchPointID)
					{
						touch = currentTouch;
						break;
					}
				}
				if(!touch)
				{
					return;
				}
				if(touch.phase == TouchPhase.ENDED)
				{
					this.touchPointID = -1;
					this.close();
					return;
				}
			}
			else
			{
				for each(touch in touches)
				{
					if(touch.phase == TouchPhase.BEGAN)
					{
						this.touchPointID = touch.id;
						return;
					}
				}
			}
		}


	}
}
