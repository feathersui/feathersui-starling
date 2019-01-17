/*
Feathers
Copyright 2012-2019 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.popups
{
	import feathers.core.IFeathersControl;
	import feathers.core.IValidating;
	import feathers.core.PopUpManager;
	import feathers.events.FeathersEventType;
	import feathers.utils.display.getDisplayObjectDepthFromStage;
	import feathers.utils.geom.matrixToScaleX;
	import feathers.utils.geom.matrixToScaleY;

	import flash.errors.IllegalOperationError;
	import flash.events.KeyboardEvent;
	import flash.geom.Matrix;
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
	 * Displays a pop-up at the center of the stage, filling the vertical space.
	 * The content will be sized horizontally so that it is no larger than the
	 * the width or height of the stage (whichever is smaller).
	 *
	 * @productversion Feathers 1.0.0
	 */
	public class VerticalCenteredPopUpContentManager extends EventDispatcher implements IPopUpContentManager
	{
		/**
		 * Constructor.
		 */
		public function VerticalCenteredPopUpContentManager()
		{
		}

		/**
		 * Quickly sets all margin properties to the same value. The
		 * <code>margin</code> getter always returns the value of
		 * <code>marginTop</code>, but the other padding values may be
		 * different.
		 *
		 * <p>The following example gives the pop-up a minimum of 20 pixels of
		 * margin on all sides:</p>
		 *
		 * <listing version="3.0">
		 * manager.margin = 20;</listing>
		 *
		 * @default 0
		 *
		 * @see #marginTop
		 * @see #marginRight
		 * @see #marginBottom
		 * @see #marginLeft
		 */
		public function get margin():Number
		{
			return this.marginTop;
		}

		/**
		 * @private
		 */
		public function set margin(value:Number):void
		{
			this.marginTop = value;
			this.marginRight = value;
			this.marginBottom = value;
			this.marginLeft = value;
		}

		/**
		 * The minimum space, in pixels, between the top edge of the content and
		 * the top edge of the stage.
		 *
		 * <p>The following example gives the pop-up a minimum of 20 pixels of
		 * margin on the top:</p>
		 *
		 * <listing version="3.0">
		 * manager.marginTop = 20;</listing>
		 *
		 * @default 0
		 *
		 * @see #margin
		 */
		public var marginTop:Number = 0;

		/**
		 * The minimum space, in pixels, between the right edge of the content
		 * and the right edge of the stage.
		 *
		 * <p>The following example gives the pop-up a minimum of 20 pixels of
		 * margin on the right:</p>
		 *
		 * <listing version="3.0">
		 * manager.marginRight = 20;</listing>
		 *
		 * @default 0
		 *
		 * @see #margin
		 */
		public var marginRight:Number = 0;

		/**
		 * The minimum space, in pixels, between the bottom edge of the content
		 * and the bottom edge of the stage.
		 *
		 * <p>The following example gives the pop-up a minimum of 20 pixels of
		 * margin on the bottom:</p>
		 *
		 * <listing version="3.0">
		 * manager.marginBottom = 20;</listing>
		 *
		 * @default 0
		 *
		 * @see #margin
		 */
		public var marginBottom:Number = 0;

		/**
		 * The minimum space, in pixels, between the left edge of the content
		 * and the left edge of the stage.
		 *
		 * <p>The following example gives the pop-up a minimum of 20 pixels of
		 * margin on the left:</p>
		 *
		 * <listing version="3.0">
		 * manager.marginLeft = 20;</listing>
		 *
		 * @default 0
		 *
		 * @see #margin
		 */
		public var marginLeft:Number = 0;

		/**
		 * @private
		 */
		protected var _overlayFactory:Function = null;

		/**
		 * This function may be used to customize the modal overlay displayed by
		 * the pop-up manager. If the value of <code>overlayFactory</code> is
		 * <code>null</code>, the pop-up manager's default overlay factory will
		 * be used instead.
		 *
		 * <p>This function is expected to have the following signature:</p>
		 * <pre>function():DisplayObject</pre>
		 *
		 * <p>In the following example, the overlay is customized:</p>
		 *
		 * <listing version="3.0">
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
		protected var content:DisplayObject;

		/**
		 * @private
		 */
		protected var touchPointID:int = -1;

		/**
		 * @inheritDoc
		 */
		public function get isOpen():Boolean
		{
			return this.content !== null;
		}

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
			PopUpManager.addPopUp(this.content, true, false, this._overlayFactory);
			if(this.content is IFeathersControl)
			{
				this.content.addEventListener(FeathersEventType.RESIZE, content_resizeHandler);
			}
			this.content.addEventListener(Event.REMOVED_FROM_STAGE, content_removedFromStageHandler);
			this.layout();
			var stage:Stage = Starling.current.stage;
			stage.addEventListener(TouchEvent.TOUCH, stage_touchHandler);
			stage.addEventListener(ResizeEvent.RESIZE, stage_resizeHandler);

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
			var stage:Stage = Starling.current.stage;
			stage.removeEventListener(TouchEvent.TOUCH, stage_touchHandler);
			stage.removeEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
			Starling.current.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN, nativeStage_keyDownHandler);
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
			var stage:Stage = Starling.current.stage;
			var point:Point = Pool.getPoint(stage.stageWidth, stage.stageHeight);
			PopUpManager.root.globalToLocal(point, point);
			var parentWidth:Number = point.x;
			var parentHeight:Number = point.y;
			Pool.putPoint(point);
			var maxWidth:Number = parentWidth;
			if(maxWidth > parentHeight)
			{
				maxWidth = parentHeight;
			}
			maxWidth -= (this.marginLeft + this.marginRight);
			var maxHeight:Number = parentHeight - this.marginTop - this.marginBottom;
			var hasSetBounds:Boolean = false;
			if(this.content is IFeathersControl)
			{
				//if it's a ui control that is able to auto-size, this section
				//will ensure that the control stays within the required bounds.
				var uiContent:IFeathersControl = IFeathersControl(this.content);
				uiContent.minWidth = maxWidth;
				uiContent.maxWidth = maxWidth;
				uiContent.maxHeight = maxHeight;
				hasSetBounds = true;
			}
			if(this.content is IValidating)
			{
				IValidating(this.content).validate();
			}
			if(!hasSetBounds)
			{
				//if it's not a ui control, and the control's explicit width and
				//height values are greater than our maximum bounds, then we
				//will enforce the maximum bounds the hard way.
				if(this.content.width > maxWidth)
				{
					this.content.width = maxWidth;
				}
				if(this.content.height > maxHeight)
				{
					this.content.height = maxHeight;
				}
			}
			//round to the nearest pixel to avoid unnecessary smoothing
			this.content.x = Math.round((parentWidth - this.content.width) / 2);
			this.content.y = Math.round((parentHeight - this.content.height) / 2);
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
			if(!PopUpManager.isTopLevelPopUp(this.content))
			{
				return;
			}
			var stage:Stage = Starling.current.stage;
			if(this.touchPointID >= 0)
			{
				var touch:Touch = event.getTouch(stage, TouchPhase.ENDED, this.touchPointID);
				if(!touch)
				{
					return;
				}
				var point:Point = Pool.getPoint();
				touch.getLocation(stage, point);
				var hitTestResult:DisplayObject = stage.hitTest(point);
				Pool.putPoint(point);
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
				point = Pool.getPoint();
				touch.getLocation(stage, point);
				hitTestResult = stage.hitTest(point);
				Pool.putPoint(point);
				isInBounds = false;
				if(this.content is DisplayObjectContainer)
				{
					isInBounds = DisplayObjectContainer(this.content).contains(hitTestResult);
				}
				else
				{
					isInBounds = this.content == hitTestResult;
				}
				if(isInBounds)
				{
					return;
				}
				this.touchPointID = touch.id;
			}
		}


	}
}
