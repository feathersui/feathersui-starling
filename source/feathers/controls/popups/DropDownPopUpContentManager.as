/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.popups
{
	import feathers.core.IFeathersControl;
	import feathers.core.IValidating;
	import feathers.core.PopUpManager;
	import feathers.core.ValidationQueue;
	import feathers.events.FeathersEventType;
	import feathers.layout.RelativePosition;
	import feathers.utils.display.getDisplayObjectDepthFromStage;
	import feathers.utils.display.stageToStarling;

	import flash.errors.IllegalOperationError;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
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
	 * Dispatched when the pop-up content opens.
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
	 * @eventType starling.events.Event.OPEN
	 */
	[Event(name="open",type="starling.events.Event")]

	/**
	 * Dispatched when the pop-up content closes.
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
	 * @eventType starling.events.Event.CLOSE
	 */
	[Event(name="close",type="starling.events.Event")]

	/**
	 * Displays pop-up content as a desktop-style drop-down.
	 */
	public class DropDownPopUpContentManager extends EventDispatcher implements IPopUpContentManager
	{
		/**
		 * @private
		 */
		private static const HELPER_RECTANGLE:Rectangle = new Rectangle();

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.RelativePosition.BOTTOM</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const PRIMARY_DIRECTION_DOWN:String = "down";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.RelativePosition.TOP</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const PRIMARY_DIRECTION_UP:String = "up";

		/**
		 * Constructor.
		 */
		public function DropDownPopUpContentManager()
		{
			super();
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
		public function get isOpen():Boolean
		{
			return this.content !== null;
		}

		/**
		 * @private
		 */
		protected var _isModal:Boolean = false;

		/**
		 * Determines if the pop-up will be modal or not.
		 *
		 * <p>Note: If you change this value while a pop-up is displayed, the
		 * new value will not go into effect until the pop-up is removed and a
		 * new pop-up is added.</p>
		 *
		 * <p>In the following example, the pop-up is modal:</p>
		 *
		 * <listing version="3.0">
		 * manager.isModal = true;</listing>
		 *
		 * @default false
		 */
		public function get isModal():Boolean
		{
			return this._isModal;
		}

		/**
		 * @private
		 */
		public function set isModal(value:Boolean):void
		{
			this._isModal = value;
		}

		/**
		 * @private
		 */
		protected var _overlayFactory:Function;

		/**
		 * If <code>isModal</code> is <code>true</code>, this function may be
		 * used to customize the modal overlay displayed by the pop-up manager.
		 * If the value of <code>overlayFactory</code> is <code>null</code>, the
		 * pop-up manager's default overlay factory will be used instead.
		 *
		 * <p>This function is expected to have the following signature:</p>
		 * <pre>function():DisplayObject</pre>
		 *
		 * <p>In the following example, the overlay is customized:</p>
		 *
		 * <listing version="3.0">
		 * manager.isModal = true;
		 * manager.overlayFactory = function():DisplayObject
		 * {
		 *     var quad:Quad = new Quad(1, 1, 0xff00ff);
		 *     quad.alpha = 0;
		 *     return quad;
		 * };</listing>
		 *
		 * @default null
		 * 
		 * @see feathers.core.PopUpManager#overlayFactory
		 */
		public function get overlayFactory():Function
		{
			return this._overlayFactory;
		}

		/**
		 * @private
		 */
		public function set overlayFactory(value:Function):void
		{
			this._overlayFactory = value;
		}

		/**
		 * @private
		 */
		protected var _gap:Number = 0;

		/**
		 * The space, in pixels, between the source and the pop-up.
		 */
		public function get gap():Number
		{
			return this._gap;
		}

		/**
		 * @private
		 */
		public function set gap(value:Number):void
		{
			this._gap = value;
		}

		/**
		 * @private
		 */
		protected var _primaryDirection:String = RelativePosition.BOTTOM;

		/**
		 * The preferred position of the pop-up, relative to the source. If
		 * there is not enough space to position pop-up at the preferred
		 * position, it may be positioned elsewhere.
		 * 
		 * @default feathers.layout.RelativePosition.BOTTOM
		 * 
		 * @see feathers.layout.RelativePosition#BOTTOM
		 * @see feathers.layout.RelativePosition#TOP
		 */
		public function get primaryDirection():String
		{
			return this._primaryDirection;
		}

		/**
		 * @private
		 */
		public function set primaryDirection(value:String):void
		{
			if(value === PRIMARY_DIRECTION_UP)
			{
				value = RelativePosition.TOP;
			}
			else if(value === PRIMARY_DIRECTION_DOWN)
			{
				value = RelativePosition.BOTTOM;
			}
			this._primaryDirection = value;
		}

		/**
		 * @private
		 */
		protected var _fitContentMinWidthToOrigin:Boolean = true;

		/**
		 * If enabled, the pop-up content's <code>minWidth</code> property will
		 * be set to the <code>width</code> property of the origin, if it is
		 * smaller.
		 *
		 * @default true
		 */
		public function get fitContentMinWidthToOrigin():Boolean
		{
			return this._fitContentMinWidthToOrigin;
		}

		/**
		 * @private
		 */
		public function set fitContentMinWidthToOrigin(value:Boolean):void
		{
			this._fitContentMinWidthToOrigin = value;
		}

		/**
		 * @private
		 */
		protected var _lastGlobalX:Number;

		/**
		 * @private
		 */
		protected var _lastGlobalY:Number;

		/**
		 * @inheritDoc
		 */
		public function open(content:DisplayObject, source:DisplayObject):void
		{
			if(this.isOpen)
			{
				throw new IllegalOperationError("Pop-up content is already open. Close the previous content before opening new content.");
			}

			this.content = content;
			this.source = source;
			PopUpManager.addPopUp(this.content, this._isModal, false, this._overlayFactory);
			if(this.content is IFeathersControl)
			{
				this.content.addEventListener(FeathersEventType.RESIZE, content_resizeHandler);
			}
			this.content.addEventListener(Event.REMOVED_FROM_STAGE, content_removedFromStageHandler);
			this.layout();
			var stage:Stage = this.source.stage;
			stage.addEventListener(TouchEvent.TOUCH, stage_touchHandler);
			stage.addEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
			stage.addEventListener(Event.ENTER_FRAME, stage_enterFrameHandler);

			//using priority here is a hack so that objects higher up in the
			//display list have a chance to cancel the event first.
			var priority:int = -getDisplayObjectDepthFromStage(this.content);
			Starling.current.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, nativeStage_keyDownHandler, false, priority, true);
			this.dispatchEventWith(Event.OPEN);
		}

		/**
		 * @inheritDoc
		 */
		public function close():void
		{
			if(!this.isOpen)
			{
				return;
			}
			var content:DisplayObject = this.content;
			this.content = null;
			this.source = null;
			var stage:Stage = content.stage;
			stage.removeEventListener(TouchEvent.TOUCH, stage_touchHandler);
			stage.removeEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
			stage.removeEventListener(Event.ENTER_FRAME, stage_enterFrameHandler);
			var starling:Starling = stageToStarling(stage);
			starling.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN, nativeStage_keyDownHandler);
			if(content is IFeathersControl)
			{
				content.removeEventListener(FeathersEventType.RESIZE, content_resizeHandler);
			}
			content.removeEventListener(Event.REMOVED_FROM_STAGE, content_removedFromStageHandler);
			if(content.parent)
			{
				content.removeFromParent(false);
			}
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
			if(this.source is IValidating)
			{
				IValidating(this.source).validate();
				if(!this.isOpen)
				{
					//it's possible that the source will close its pop-up during
					//validation, so we should check for that.
					return;
				}
			}

			var sourceWidth:Number = this.source.width;
			var hasSetBounds:Boolean = false;
			var uiContent:IFeathersControl = this.content as IFeathersControl;
			if(this._fitContentMinWidthToOrigin && uiContent && uiContent.minWidth < sourceWidth)
			{
				uiContent.minWidth = sourceWidth;
				hasSetBounds = true;
			}
			if(this.content is IValidating)
			{
				uiContent.validate();
			}
			if(!hasSetBounds && this._fitContentMinWidthToOrigin && this.content.width < sourceWidth)
			{
				this.content.width = sourceWidth;
			}

			var stage:Stage = this.source.stage;
			
			//we need to be sure that the source is properly positioned before
			//positioning the content relative to it.
			var starling:Starling = stageToStarling(stage);
			var validationQueue:ValidationQueue = ValidationQueue.forStarling(starling);
			if(validationQueue && !validationQueue.isValidating)
			{
				//force a COMPLETE validation of everything
				//but only if we're not already doing that...
				validationQueue.advanceTime(0);
			}

			var globalOrigin:Rectangle = this.source.getBounds(stage);
			this._lastGlobalX = globalOrigin.x;
			this._lastGlobalY = globalOrigin.y;

			var downSpace:Number = (stage.stageHeight - this.content.height) - (globalOrigin.y + globalOrigin.height + this._gap);
			//skip this if the primary direction is up
			if(this._primaryDirection == RelativePosition.BOTTOM && downSpace >= 0)
			{
				layoutBelow(globalOrigin);
				return;
			}

			var upSpace:Number = globalOrigin.y - this._gap - this.content.height;
			if(upSpace >= 0)
			{
				layoutAbove(globalOrigin);
				return;
			}
			
			//do what we skipped earlier if the primary direction is up
			if(this._primaryDirection == RelativePosition.TOP && downSpace >= 0)
			{
				layoutBelow(globalOrigin);
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

			//the content is too big for the space, so we need to adjust it to
			//fit properly
			var newMaxHeight:Number = stage.stageHeight - (globalOrigin.y + globalOrigin.height);
			if(uiContent)
			{
				if(uiContent.maxHeight > newMaxHeight)
				{
					uiContent.maxHeight = newMaxHeight;
				}
			}
			else if(this.content.height > newMaxHeight)
			{
				this.content.height = newMaxHeight;
			}
		}

		/**
		 * @private
		 */
		protected function layoutAbove(globalOrigin:Rectangle):void
		{
			var idealXPosition:Number = globalOrigin.x;
			var xPosition:Number = this.content.stage.stageWidth - this.content.width;
			if(xPosition > idealXPosition)
			{
				xPosition = idealXPosition;
			}
			if(xPosition < 0)
			{
				xPosition = 0;
			}
			this.content.x = xPosition;
			this.content.y = globalOrigin.y - this.content.height - this._gap;
		}

		/**
		 * @private
		 */
		protected function layoutBelow(globalOrigin:Rectangle):void
		{
			var idealXPosition:Number = globalOrigin.x;
			var xPosition:Number = this.content.stage.stageWidth - this.content.width;
			if(xPosition > idealXPosition)
			{
				xPosition = idealXPosition;
			}
			if(xPosition < 0)
			{
				xPosition = 0;
			}
			this.content.x = xPosition;
			this.content.y = globalOrigin.y + globalOrigin.height + this._gap;
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
		protected function stage_enterFrameHandler(event:Event):void
		{
			this.source.getBounds(this.source.stage, HELPER_RECTANGLE);
			if(HELPER_RECTANGLE.x != this._lastGlobalX || HELPER_RECTANGLE.y != this._lastGlobalY)
			{
				this.layout();
			}
		}

		/**
		 * @private
		 */
		protected function content_removedFromStageHandler(event:Event):void
		{
			this.close();
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
			var target:DisplayObject = DisplayObject(event.target);
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
			var stage:Stage = Stage(event.currentTarget);
			var touch:Touch = event.getTouch(stage, TouchPhase.BEGAN);
			if(!touch)
			{
				return;
			}
			this.close();
		}
	}
}
