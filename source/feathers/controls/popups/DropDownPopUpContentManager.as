/*
Feathers
Copyright 2012-2020 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.popups
{
	import feathers.core.IFeathersControl;
	import feathers.core.IValidating;
	import feathers.core.PopUpManager;
	import feathers.core.ValidationQueue;
	import feathers.display.RenderDelegate;
	import feathers.events.FeathersEventType;
	import feathers.layout.RelativePosition;
	import feathers.utils.display.getDisplayObjectDepthFromStage;
	import feathers.utils.geom.matrixToScaleX;
	import feathers.utils.geom.matrixToScaleY;

	import flash.errors.IllegalOperationError;
	import flash.events.KeyboardEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;

	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.display.Stage;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.events.ResizeEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.Pool;

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
	 *
	 * @productversion Feathers 1.0.0
	 */
	public class DropDownPopUpContentManager extends EventDispatcher implements IPopUpContentManager
	{
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
		 * @private
		 */
		protected var _delegate:RenderDelegate;

		/**
		 * @private
		 * Stores the same value as the content property, but the content
		 * property may be set to null before the animation ends.
		 */
		protected var _openCloseTweenTarget:DisplayObject;

		/**
		 * @private
		 */
		protected var _openCloseTween:Tween;

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
		protected var _openCloseDuration:Number = 0.2;

		/**
		 * The duration, in seconds, of the open and close animation.
		 */
		public function get openCloseDuration():Number
		{
			return this._openCloseDuration;
		}

		/**
		 * @private
		 */
		public function set openCloseDuration(value:Number):void
		{
			this._openCloseDuration = value;
		}

		/**
		 * @private
		 */
		protected var _openCloseEase:Object = Transitions.EASE_OUT;

		/**
		 * The easing function to use for the open and close animation.
		 */
		public function get openCloseEase():Object
		{
			return this._openCloseEase;
		}

		/**
		 * @private
		 */
		public function set openCloseEase(value:Object):void
		{
			this._openCloseEase = value;
		}

		/**
		 * @private
		 */
		protected var _actualDirection:String;

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
			if(value === "up")
			{
				value = RelativePosition.TOP;
			}
			else if(value === "down")
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
		protected var _lastOriginX:Number;

		/**
		 * @private
		 */
		protected var _lastOriginY:Number;

		/**
		 * @inheritDoc
		 */
		public function open(content:DisplayObject, source:DisplayObject):void
		{
			if(this.isOpen)
			{
				throw new IllegalOperationError("Pop-up content is already open. Close the previous content before opening new content.");
			}

			//make sure the content is scaled the same as the source
			var matrix:Matrix = Pool.getMatrix();
			source.getTransformationMatrix(PopUpManager.root, matrix);
			content.scaleX = matrixToScaleX(matrix)
			content.scaleY = matrixToScaleY(matrix);
			Pool.putMatrix(matrix);

			this.content = content;
			this.source = source;
			PopUpManager.addPopUp(content, this._isModal, false, this._overlayFactory);
			if(content is IFeathersControl)
			{
				content.addEventListener(FeathersEventType.RESIZE, content_resizeHandler);
			}
			content.addEventListener(Event.REMOVED_FROM_STAGE, content_removedFromStageHandler);
			this.layout();
			if(this._openCloseTween !== null)
			{
				this._openCloseTween.advanceTime(this._openCloseTween.totalTime);
			}
			if(this._openCloseDuration > 0)
			{
				this._delegate = new RenderDelegate(content);
				this._delegate.scaleX = content.scaleX;
				this._delegate.scaleY = content.scaleY;
				//temporarily hide the content while the delegate is displayed
				content.visible = false;
				PopUpManager.addPopUp(this._delegate, false, false);
				this._delegate.x = content.x;
				if(this._actualDirection === RelativePosition.TOP)
				{
					this._delegate.y = content.y + content.height;
				}
				else //bottom
				{
					this._delegate.y = content.y - content.height;
				}
				var mask:Quad = new Quad(1, 1, 0xff00ff);
				mask.width = content.width / content.scaleX;
				mask.height = 0;
				this._delegate.mask = mask;
				mask.height = 0;
				this._openCloseTween = new Tween(this._delegate, this._openCloseDuration, this._openCloseEase);
				this._openCloseTweenTarget = content;
				this._openCloseTween.animate("y", content.y);
				this._openCloseTween.onUpdate = openCloseTween_onUpdate;
				this._openCloseTween.onComplete = openTween_onComplete;
				Starling.juggler.add(this._openCloseTween);
			}
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
			if(this._openCloseTween !== null)
			{
				this._openCloseTween.advanceTime(this._openCloseTween.totalTime);
			}
			var content:DisplayObject = this.content;
			this.source = null;
			this.content = null;
			var stage:Stage = content.stage;
			stage.removeEventListener(TouchEvent.TOUCH, stage_touchHandler);
			stage.removeEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
			stage.removeEventListener(Event.ENTER_FRAME, stage_enterFrameHandler);
			stage.starling.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN, nativeStage_keyDownHandler);
			if(content is IFeathersControl)
			{
				content.removeEventListener(FeathersEventType.RESIZE, content_resizeHandler);
			}
			content.removeEventListener(Event.REMOVED_FROM_STAGE, content_removedFromStageHandler);
			if(content.parent)
			{
				content.removeFromParent(false);
			}
			if(this._openCloseDuration > 0)
			{
				this._delegate = new RenderDelegate(content);
				this._delegate.scaleX = content.scaleX;
				this._delegate.scaleY = content.scaleY;
				PopUpManager.addPopUp(this._delegate, false, false);
				this._delegate.x = content.x;
				this._delegate.y = content.y;
				var mask:Quad = new Quad(1, 1, 0xff00ff);
				mask.width = content.width / content.scaleX;
				mask.height = content.height / content.scaleY;
				this._delegate.mask = mask;
				this._openCloseTween = new Tween(this._delegate, this._openCloseDuration, this._openCloseEase);
				this._openCloseTweenTarget = content;
				if(this._actualDirection === RelativePosition.TOP)
				{
					this._openCloseTween.animate("y", content.y + content.height);
				}
				else
				{
					this._openCloseTween.animate("y", content.y - content.height);
				}
				this._openCloseTween.onUpdate = openCloseTween_onUpdate;
				this._openCloseTween.onComplete = closeTween_onComplete;
				Starling.juggler.add(this._openCloseTween);
			}
			else
			{
				this.dispatchEventWith(Event.CLOSE);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function dispose():void
		{
			this.openCloseDuration = 0;
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

			var originBoundsInParent:Rectangle = this.source.getBounds(PopUpManager.root);
			var sourceWidth:Number = originBoundsInParent.width;
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
			var validationQueue:ValidationQueue = ValidationQueue.forStarling(stage.starling);
			if(validationQueue && !validationQueue.isValidating)
			{
				//force a COMPLETE validation of everything
				//but only if we're not already doing that...
				validationQueue.advanceTime(0);
			}

			originBoundsInParent = this.source.getBounds(PopUpManager.root);
			this._lastOriginX = originBoundsInParent.x;
			this._lastOriginY = originBoundsInParent.y;

			var stageDimensionsInParent:Point = new Point(stage.stageWidth, stage.stageHeight);
			PopUpManager.root.globalToLocal(stageDimensionsInParent, stageDimensionsInParent);

			var downSpace:Number = (stageDimensionsInParent.y - this.content.height) - (originBoundsInParent.y + originBoundsInParent.height + this._gap);
			//skip this if the primary direction is up
			if(this._primaryDirection == RelativePosition.BOTTOM && downSpace >= 0)
			{
				layoutBelow(originBoundsInParent, stageDimensionsInParent);
				return;
			}

			var upSpace:Number = originBoundsInParent.y - this._gap - this.content.height;
			if(upSpace >= 0)
			{
				layoutAbove(originBoundsInParent, stageDimensionsInParent);
				return;
			}

			//do what we skipped earlier if the primary direction is up
			if(this._primaryDirection == RelativePosition.TOP && downSpace >= 0)
			{
				layoutBelow(originBoundsInParent, stageDimensionsInParent);
				return;
			}

			//worst case: pick the side that has the most available space
			if(upSpace >= downSpace)
			{
				layoutAbove(originBoundsInParent, stageDimensionsInParent);
			}
			else
			{
				layoutBelow(originBoundsInParent, stageDimensionsInParent);
			}

			//the content is too big for the space, so we need to adjust it to
			//fit properly
			var newMaxHeight:Number = stageDimensionsInParent.y - (originBoundsInParent.y + originBoundsInParent.height);
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
		protected function layoutAbove(originBoundsInParent:Rectangle, stageDimensionsInParent:Point):void
		{
			this._actualDirection = RelativePosition.TOP;
			this.content.x = this.calculateXPosition(originBoundsInParent, stageDimensionsInParent);
			this.content.y = originBoundsInParent.y - this.content.height - this._gap;
		}

		/**
		 * @private
		 */
		protected function layoutBelow(originBoundsInParent:Rectangle, stageDimensionsInParent:Point):void
		{
			this._actualDirection = RelativePosition.BOTTOM;
			this.content.x = this.calculateXPosition(originBoundsInParent, stageDimensionsInParent);
			this.content.y = originBoundsInParent.y + originBoundsInParent.height + this._gap;
		}

		/**
		 * @private
		 */
		protected function calculateXPosition(originBoundsInParent:Rectangle, stageDimensionsInParent:Point):Number
		{
			var idealXPosition:Number = originBoundsInParent.x;
			var fallbackXPosition:Number = idealXPosition + originBoundsInParent.width - this.content.width;
			var maxXPosition:Number = stageDimensionsInParent.x - this.content.width;
			var xPosition:Number = idealXPosition;
			if(xPosition > maxXPosition)
			{
				if(fallbackXPosition >= 0)
				{
					xPosition = fallbackXPosition;
				}
				else
				{
					xPosition = maxXPosition;
				}
			}
			if(xPosition < 0)
			{
				xPosition = 0;
			}
			return xPosition;
		}

		/**
		 * @private
		 */
		protected function openCloseTween_onUpdate():void
		{
			var mask:DisplayObject = this._delegate.mask;
			if(this._actualDirection === RelativePosition.TOP)
			{
				mask.height = (this._openCloseTweenTarget.height - (this._delegate.y - this._openCloseTweenTarget.y)) / this._openCloseTweenTarget.scaleY;
				mask.y = 0;
			}
			else
			{
				mask.height = (this._openCloseTweenTarget.height - (this._openCloseTweenTarget.y - this._delegate.y)) / this._openCloseTweenTarget.scaleY;
				mask.y = (this._openCloseTweenTarget.height / this._openCloseTweenTarget.scaleY) - mask.height;
			}
		}

		/**
		 * @private
		 */
		protected function openCloseTween_onComplete():void
		{
			this._openCloseTween = null;
			this._delegate.removeFromParent(true);
			this._delegate = null;
		}

		/**
		 * @private
		 */
		protected function openTween_onComplete():void
		{
			this.openCloseTween_onComplete();
			this.content.visible = true;
		}

		/**
		 * @private
		 */
		protected function closeTween_onComplete():void
		{
			this.openCloseTween_onComplete();
			this.dispatchEventWith(Event.CLOSE);
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
			var rect:Rectangle = Pool.getRectangle();
			this.source.getBounds(PopUpManager.root, rect);
			var rectX:Number = rect.x;
			var rectY:Number = rect.y;
			Pool.putRectangle(rect);
			if(rectY != this._lastOriginX || rectY != this._lastOriginY)
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