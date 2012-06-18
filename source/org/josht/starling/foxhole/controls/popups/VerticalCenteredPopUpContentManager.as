package org.josht.starling.foxhole.controls.popups
{
	import flash.errors.IllegalOperationError;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	import org.josht.starling.foxhole.controls.popups.IPopUpContentManager;

	import org.josht.starling.foxhole.core.FoxholeControl;
	import org.josht.starling.foxhole.core.PopUpManager;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.ResizeEvent;

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
			if(this.content is FoxholeControl)
			{
				const foxholeContent:FoxholeControl = FoxholeControl(this.content);
				FoxholeControl(this.content).onResize.add(content_resizeHandler);
			}
			this.layout();
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
			Starling.current.stage.removeEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
			Starling.current.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
			if(this.content is FoxholeControl)
			{
				FoxholeControl(this.content).onResize.remove(content_resizeHandler);
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
			if(this.content is FoxholeControl)
			{
				const foxholeContent:FoxholeControl = FoxholeControl(this.content);
				foxholeContent.minWidth = foxholeContent.maxWidth = maxWidth;
				foxholeContent.maxHeight = maxHeight;
				foxholeContent.validate();
			}

			//if it's a foxhole control that is able to auto-size, the above
			//section will ensure that the control stays within the required
			//bounds.
			//if it's not a foxhole control, or if the control's explicit width
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
		protected function content_resizeHandler(content:FoxholeControl):void
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

	}
}
