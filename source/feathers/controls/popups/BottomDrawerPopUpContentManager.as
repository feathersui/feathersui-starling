/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.popups
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Panel;
	import feathers.core.PopUpManager;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.VerticalLayout;
	import feathers.utils.display.getDisplayObjectDepthFromStage;

	import flash.errors.IllegalOperationError;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;

	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
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
	 * Displays pop-up content as a mobile-style drawer that opens from the
	 * bottom of the stage.
	 *
	 * @productversion Feathers 2.3.0
	 */
	public class BottomDrawerPopUpContentManager extends EventDispatcher implements IPersistentPopUpContentManager, IPopUpContentManagerWithPrompt
	{
		/**
		 * Constructor.
		 */
		public function BottomDrawerPopUpContentManager()
		{
			super();
		}

		/**
		 * @private
		 */
		protected var panel:Panel;

		/**
		 * @private
		 */
		protected var content:DisplayObject;

		/**
		 * @private
		 */
		protected var isClosing:Boolean = false;

		/**
		 * @inheritDoc
		 */
		public function get isOpen():Boolean
		{
			return this.content !== null;
		}

		/**
		 * Adds a style name to the panel that wraps the content.
		 *
		 * <p>In the following example, a custom style name is provided:</p>
		 *
		 * <listing version="3.0">
		 * manager.customPanelStyleName = "my-custom-pop-up-panel";</listing>
		 *
		 * @default null
		 */
		public var customPanelStyleName:String;

		/**
		 * @private
		 */
		protected var _prompt:String;

		/**
		 * A prompt to display in the panel's title.
		 * 
		 * <p>Note: If using this manager with a component that has its own
		 * prompt (like <code>PickerList</code>), this value may be overridden
		 * by the component.</p>
		 *
		 * <p>In the following example, a custom title is provided:</p>
		 *
		 * <listing version="3.0">
		 * manager.prompt = "Pick a value";</listing>
		 *
		 * @default null
		 */
		public function get prompt():String
		{
			return this._prompt;
		}

		/**
		 * @private
		 */
		public function set prompt(value:String):void
		{
			this._prompt = value;
		}

		/**
		 * @private
		 */
		protected var _closeButtonLabel:String = "Done";

		/**
		 * The text to display in the label of the close button.
		 *
		 * <p>In the following example, a custom close button label is provided:</p>
		 *
		 * <listing version="3.0">
		 * manager.closeButtonLabel = "Save";</listing>
		 *
		 * @default "Done"
		 */
		public function get closeButtonLabel():String
		{
			return this._closeButtonLabel;
		}

		/**
		 * @private
		 */
		public function set closeButtonLabel(value:String):void
		{
			this._closeButtonLabel = value;
		}

		/**
		 * @private
		 */
		protected var _openOrCloseDuration:Number = 0.5;

		/**
		 * The duration, in seconds, of the animation to open or close the
		 * pop-up.
		 *
		 * <p>In the following example, the duration is changed to 2 seconds:</p>
		 *
		 * <listing version="3.0">
		 * manager.openOrCloseDuration = 2.0;</listing>
		 *
		 * @default 0.5
		 */
		public function get openOrCloseDuration():Number
		{
			return this._openOrCloseDuration;
		}

		/**
		 * @private
		 */
		public function set openOrCloseDuration(value:Number):void
		{
			this._openOrCloseDuration = value;
		}

		/**
		 * @private
		 */
		protected var _openOrCloseEase:Object = Transitions.EASE_OUT;

		/**
		 * The easing function used for opening or closing the pop-up.
		 *
		 * <p>In the following example, the animation ease is changed:</p>
		 *
		 * <listing version="3.0">
		 * manager.openOrCloseEase = Transitions.EASE_IN_OUT;</listing>
		 *
		 * @default starling.animation.Transitions.EASE_OUT
		 *
		 * @see http://doc.starling-framework.org/core/starling/animation/Transitions.html starling.animation.Transitions
		 * @see #openOrCloseDuration
		 */
		public function get openOrCloseEase():Object
		{
			return this._openOrCloseEase;
		}

		/**
		 * @private
		 */
		public function set openOrCloseEase(value:Object):void
		{
			this._openOrCloseEase = value;
		}

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
		protected var touchPointID:int = -1;

		/**
		 * @private
		 */
		protected var openTween:Tween;

		/**
		 * @private
		 */
		protected var closeTween:Tween;

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
			
			var layout:VerticalLayout = new VerticalLayout();
			layout.horizontalAlign = HorizontalAlign.JUSTIFY;
			
			this.panel = new Panel();
			if(this.customPanelStyleName)
			{
				this.panel.styleNameList.add(this.customPanelStyleName);
			}
			this.panel.title = this._prompt;
			this.panel.layout = layout;
			this.panel.headerFactory = headerFactory;
			this.panel.touchable = false;
			this.panel.addChild(content);
			PopUpManager.addPopUp(this.panel, true, false, this._overlayFactory);
			this.layout();
			
			this.panel.addEventListener(Event.REMOVED_FROM_STAGE, panel_removedFromStageHandler);
			
			var stage:Stage = Starling.current.stage;
			stage.addEventListener(TouchEvent.TOUCH, stage_touchHandler);
			stage.addEventListener(ResizeEvent.RESIZE, stage_resizeHandler);

			//using priority here is a hack so that objects higher up in the
			//display list have a chance to cancel the event first.
			var priority:int = -getDisplayObjectDepthFromStage(this.panel);
			Starling.current.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, nativeStage_keyDownHandler, false, priority, true);

			this.panel.y = this.panel.stage.stageHeight;
			this.openTween = new Tween(this.panel, this.openOrCloseDuration, this.openOrCloseEase);
			this.openTween.moveTo(0, this.panel.stage.stageHeight - this.panel.height);
			this.openTween.onComplete = openTween_onComplete;
			Starling.juggler.add(this.openTween);
		}

		/**
		 * @inheritDoc
		 */
		public function close():void
		{
			if(!this.isOpen || this.isClosing)
			{
				return;
			}

			if(this.openTween)
			{
				Starling.juggler.remove(this.openTween);
				this.openTween = null;
			}
			if(this.content.stage)
			{
				this.isClosing = true;
				this.panel.touchable = false;
				this.closeTween = new Tween(this.panel, this.openOrCloseDuration, this.openOrCloseEase);
				this.closeTween.moveTo(0, this.panel.stage.stageHeight);
				this.closeTween.onComplete = closeTween_onComplete;
				Starling.juggler.add(this.closeTween);
			}
			else
			{
				this.cleanup();
				this.dispatchEventWith(Event.CLOSE);
			}
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
		protected function headerFactory():Header
		{
			var header:Header = new Header();
			var closeButton:Button = new Button();
			closeButton.label = this.closeButtonLabel;
			closeButton.addEventListener(Event.TRIGGERED, closeButton_triggeredHandler);
			header.rightItems = new <DisplayObject>[closeButton];
			return header;
		}

		/**
		 * @private
		 */
		protected function layout():void
		{
			this.panel.width = this.panel.stage.stageWidth;
			this.panel.x = 0;
			this.panel.maxHeight = this.panel.stage.stageHeight;
			this.panel.validate();
			this.panel.y = this.panel.stage.stageHeight - this.panel.height;
		}

		/**
		 * @private
		 */
		protected function cleanup():void
		{
			var stage:Stage = Starling.current.stage;
			stage.removeEventListener(TouchEvent.TOUCH, stage_touchHandler);
			stage.removeEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
			Starling.current.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN, nativeStage_keyDownHandler);

			if(this.panel)
			{
				this.panel.removeEventListener(Event.REMOVED_FROM_STAGE, panel_removedFromStageHandler);
				if(this.panel.contains(this.content))
				{
					this.panel.removeChild(this.content, false);
				}
				this.panel.removeFromParent(true);
				this.panel = null;
			}
			this.content = null;
		}

		/**
		 * @private
		 */
		protected function openTween_onComplete():void
		{
			this.openTween = null;
			this.panel.touchable = true;
			this.dispatchEventWith(Event.OPEN);
		}

		/**
		 * @private
		 */
		protected function closeTween_onComplete():void
		{
			this.isClosing = false;
			this.closeTween = null;
			this.cleanup();
			this.dispatchEventWith(Event.CLOSE);
		}

		/**
		 * @private
		 */
		protected function closeButton_triggeredHandler(event:Event):void
		{
			this.close();
		}

		/**
		 * @private
		 */
		protected function panel_removedFromStageHandler(event:Event):void
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
			if(this.closeTween)
			{
				this.closeTween.advanceTime(this.closeTween.totalTime);
				//the onComplete callback will remove the panel, so no layout is
				//required.
				return;
			}

			if(this.openTween)
			{
				//just stop the animation and go to the final layout
				Starling.juggler.remove(this.openTween);
				this.openTween = null;
			}
			this.layout();
		}

		/**
		 * @private
		 */
		protected function stage_touchHandler(event:TouchEvent):void
		{
			if(!PopUpManager.isTopLevelPopUp(this.panel))
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
				if(!this.panel.contains(hitTestResult))
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
				if(this.panel.contains(hitTestResult))
				{
					return;
				}
				this.touchPointID = touch.id;
			}
		}
	}
}
