/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.supportClasses
{
	import feathers.controls.IScreen;
	import feathers.core.FeathersControl;
	import feathers.core.IValidating;
	import feathers.events.FeathersEventType;

	import flash.errors.IllegalOperationError;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;

	import starling.display.DisplayObject;
	import starling.errors.AbstractMethodError;
	import starling.events.Event;

	/**
	 * Dispatched when the active screen changes.
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
	 * @eventType starling.events.Event.CHANGE
	 */
	[Event(name="change",type="starling.events.Event")]

	/**
	 * Dispatched when the current screen is removed and there is no active
	 * screen.
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
	 * @eventType feathers.events.FeathersEventType.CLEAR
	 */
	[Event(name="clear",type="starling.events.Event")]

	/**
	 * Dispatched when the transition between screens begins.
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
	 * @eventType feathers.events.FeathersEventType.TRANSITION_START
	 */
	[Event(name="transitionStart",type="starling.events.Event")]

	/**
	 * Dispatched when the transition between screens has completed.
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
	 * @eventType feathers.events.FeathersEventType.TRANSITION_COMPLETE
	 */
	[Event(name="transitionComplete",type="starling.events.Event")]

	/**
	 * A base class for screen navigator components that isn't meant to be
	 * instantiated directly. It should only be subclassed.
	 *
	 * @see feathers.controls.StackScreenNavigator
	 * @see feathers.controls.ScreenNavigator
	 */
	public class BaseScreenNavigator extends FeathersControl
	{
		/**
		 * @private
		 */
		protected static var SIGNAL_TYPE:Class;

		/**
		 * The screen navigator will auto size itself to fill the entire stage.
		 *
		 * @see #autoSizeMode
		 */
		public static const AUTO_SIZE_MODE_STAGE:String = "stage";

		/**
		 * The screen navigator will auto size itself to fit its content.
		 *
		 * @see #autoSizeMode
		 */
		public static const AUTO_SIZE_MODE_CONTENT:String = "content";

		/**
		 * The default transition function.
		 */
		protected static function defaultTransition(oldScreen:DisplayObject, newScreen:DisplayObject, completeCallback:Function):void
		{
			//in short, do nothing
			completeCallback();
		}

		/**
		 * Constructor.
		 */
		public function BaseScreenNavigator()
		{
			super();
			if(Object(this).constructor == BaseScreenNavigator)
			{
				throw new Error(FeathersControl.ABSTRACT_CLASS_ERROR);
			}
			if(!SIGNAL_TYPE)
			{
				try
				{
					SIGNAL_TYPE = Class(getDefinitionByName("org.osflash.signals.ISignal"));
				}
				catch(error:Error)
				{
					//signals not being used
				}
			}
		}

		/**
		 * @private
		 */
		protected var _activeScreenID:String;

		/**
		 * The string identifier for the currently active screen.
		 */
		public function get activeScreenID():String
		{
			return this._activeScreenID;
		}

		/**
		 * @private
		 */
		protected var _activeScreen:DisplayObject;

		/**
		 * A reference to the currently active screen.
		 */
		public function get activeScreen():DisplayObject
		{
			return this._activeScreen;
		}

		/**
		 * @private
		 */
		protected var _screens:Object = {};

		/**
		 * @private
		 */
		protected var _previousScreenInTransitionID:String;

		/**
		 * @private
		 */
		protected var _previousScreenInTransition:DisplayObject;

		/**
		 * @private
		 */
		protected var _nextScreenID:String = null;

		/**
		 * @private
		 */
		protected var _nextScreenTransition:Function = null;

		/**
		 * @private
		 */
		protected var _clearAfterTransition:Boolean = false;

		/**
		 * @private
		 */
		protected var _clipContent:Boolean = false;

		/**
		 * Determines if the navigator's content should be clipped to the width
		 * and height.
		 *
		 * <p>In the following example, clipping is enabled:</p>
		 *
		 * <listing version="3.0">
		 * navigator.clipContent = true;</listing>
		 *
		 * @default false
		 */
		public function get clipContent():Boolean
		{
			return this._clipContent;
		}

		/**
		 * @private
		 */
		public function set clipContent(value:Boolean):void
		{
			if(this._clipContent == value)
			{
				return;
			}
			this._clipContent = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _autoSizeMode:String = AUTO_SIZE_MODE_STAGE;

		[Inspectable(type="String",enumeration="stage,content")]
		/**
		 * Determines how the screen navigator will set its own size when its
		 * dimensions (width and height) aren't set explicitly.
		 *
		 * <p>In the following example, the screen navigator will be sized to
		 * match its content:</p>
		 *
		 * <listing version="3.0">
		 * navigator.autoSizeMode = ScreenNavigator.AUTO_SIZE_MODE_CONTENT;</listing>
		 *
		 * @default ScreenNavigator.AUTO_SIZE_MODE_STAGE
		 *
		 * @see #AUTO_SIZE_MODE_STAGE
		 * @see #AUTO_SIZE_MODE_CONTENT
		 */
		public function get autoSizeMode():String
		{
			return this._autoSizeMode;
		}

		/**
		 * @private
		 */
		public function set autoSizeMode(value:String):void
		{
			if(this._autoSizeMode == value)
			{
				return;
			}
			this._autoSizeMode = value;
			if(this._activeScreen)
			{
				if(this._autoSizeMode == AUTO_SIZE_MODE_CONTENT)
				{
					this._activeScreen.addEventListener(Event.RESIZE, activeScreen_resizeHandler);
				}
				else
				{
					this._activeScreen.removeEventListener(Event.RESIZE, activeScreen_resizeHandler);
				}
			}
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		/**
		 * @private
		 */
		protected var _waitingTransition:Function;

		/**
		 * @private
		 */
		private var _waitingForTransitionFrameCount:int = 1;

		/**
		 * @private
		 */
		protected var _isTransitionActive:Boolean = false;

		/**
		 * Indicates whether the screen navigator is currently transitioning
		 * between screens.
		 */
		public function get isTransitionActive():Boolean
		{
			return this._isTransitionActive;
		}

		/**
		 * @private
		 */
		override public function dispose():void
		{
			this.clearScreenInternal();
			super.dispose();
		}

		/**
		 * Removes all screens that were added with <code>addScreen()</code>.
		 *
		 * @see #addScreen()
		 */
		public function removeAllScreens():void
		{
			if(this._isTransitionActive)
			{
				throw new IllegalOperationError("Cannot remove all screens while a transition is active.");
			}
			if(this._activeScreen)
			{
				this.clearScreenInternal(defaultTransition);
				this.dispatchEventWith(FeathersEventType.CLEAR);
			}
			for(var id:String in this._screens)
			{
				delete this._screens[id];
			}
		}

		/**
		 * Determines if the specified screen identifier has been added with
		 * <code>addScreen()</code>.
		 *
		 * @see #addScreen()
		 */
		public function hasScreen(id:String):Boolean
		{
			return this._screens.hasOwnProperty(id);
		}

		/**
		 * Returns a list of the screen identifiers that have been added.
		 */
		public function getScreenIDs(result:Vector.<String> = null):Vector.<String>
		{
			if(result)
			{
				result.length = 0;
			}
			else
			{
				result = new <String>[];
			}
			var pushIndex:int = 0;
			for(var id:String in this._screens)
			{
				result[pushIndex] = id;
				pushIndex++;
			}
			return result;
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			var selectionInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SELECTED);
			var stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);

			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

			if(sizeInvalid || selectionInvalid)
			{
				if(this._activeScreen)
				{
					if(this._activeScreen.width != this.actualWidth)
					{
						this._activeScreen.width = this.actualWidth;
					}
					if(this._activeScreen.height != this.actualHeight)
					{
						this._activeScreen.height = this.actualHeight;
					}
				}
			}

			if(stylesInvalid || sizeInvalid)
			{
				if(this._clipContent)
				{
					var clipRect:Rectangle = this.clipRect;
					if(!clipRect)
					{
						clipRect = new Rectangle();
					}
					clipRect.width = this.actualWidth;
					clipRect.height = this.actualHeight;
					this.clipRect = clipRect;
				}
				else
				{
					this.clipRect = null;
				}
			}
		}

		/**
		 * If the component's dimensions have not been set explicitly, it will
		 * measure its content and determine an ideal size for itself. If the
		 * <code>explicitWidth</code> or <code>explicitHeight</code> member
		 * variables are set, those value will be used without additional
		 * measurement. If one is set, but not the other, the dimension with the
		 * explicit value will not be measured, but the other non-explicit
		 * dimension will still need measurement.
		 *
		 * <p>Calls <code>setSizeInternal()</code> to set up the
		 * <code>actualWidth</code> and <code>actualHeight</code> member
		 * variables used for layout.</p>
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 */
		protected function autoSizeIfNeeded():Boolean
		{
			var needsWidth:Boolean = this.explicitWidth !== this.explicitWidth; //isNaN
			var needsHeight:Boolean = this.explicitHeight !== this.explicitHeight; //isNaN
			if(!needsWidth && !needsHeight)
			{
				return false;
			}

			if((this._autoSizeMode == AUTO_SIZE_MODE_CONTENT || !this.stage) &&
				this._activeScreen is IValidating)
			{
				IValidating(this._activeScreen).validate();
			}

			var newWidth:Number = this.explicitWidth;
			if(needsWidth)
			{
				if(this._autoSizeMode == AUTO_SIZE_MODE_CONTENT || !this.stage)
				{
					newWidth = this._activeScreen ? this._activeScreen.width : 0;
				}
				else
				{
					newWidth = this.stage.stageWidth;
				}
			}

			var newHeight:Number = this.explicitHeight;
			if(needsHeight)
			{
				if(this._autoSizeMode == AUTO_SIZE_MODE_CONTENT || !this.stage)
				{
					newHeight = this._activeScreen ? this._activeScreen.height : 0;
				}
				else
				{
					newHeight = this.stage.stageHeight;
				}
			}

			return this.setSizeInternal(newWidth, newHeight, false);
		}

		/**
		 * @private
		 */
		protected function addScreenInternal(id:String, item:IScreenNavigatorItem):void
		{
			if(this._screens.hasOwnProperty(id))
			{
				throw new ArgumentError("Screen with id '" + id + "' already defined. Cannot add two screens with the same id.");
			}
			this._screens[id] = item;
		}

		/**
		 * @private
		 */
		protected function removeScreenInternal(id:String):IScreenNavigatorItem
		{
			if(!this._screens.hasOwnProperty(id))
			{
				throw new ArgumentError("Screen '" + id + "' cannot be removed because it has not been added.");
			}
			if(this._isTransitionActive && (id == this._previousScreenInTransitionID || id == this._activeScreenID))
			{
				throw new IllegalOperationError("Cannot remove a screen while it is transitioning in or out.")
			}
			if(this._activeScreenID == id)
			{
				//if someone meant to have a transition, they would have called
				//clearScreen()
				this.clearScreenInternal(defaultTransition);
				this.dispatchEventWith(FeathersEventType.CLEAR);
			}
			var item:IScreenNavigatorItem = IScreenNavigatorItem(this._screens[id]);
			delete this._screens[id];
			return item;
		}

		/**
		 * @private
		 */
		protected function showScreenInternal(id:String, transition:Function, properties:Object = null):DisplayObject
		{
			if(!this.hasScreen(id))
			{
				throw new ArgumentError("Screen with id '" + id + "' cannot be shown because it has not been defined.");
			}

			if(this._isTransitionActive)
			{
				this._nextScreenID = id;
				this._nextScreenTransition = transition;
				this._clearAfterTransition = false;
				return null;
			}

			if(this._activeScreenID == id)
			{
				return this._activeScreen;
			}

			this._previousScreenInTransition = this._activeScreen;
			this._previousScreenInTransitionID = this._activeScreenID;
			if(this._activeScreen)
			{
				this.clearScreenInternal();
			}

			this._isTransitionActive = true;

			var item:IScreenNavigatorItem = IScreenNavigatorItem(this._screens[id]);
			this._activeScreen = item.getScreen();
			this._activeScreenID = id;
			for(var propertyName:String in properties)
			{
				this._activeScreen[propertyName] = properties[propertyName];
			}
			if(this._activeScreen is IScreen)
			{
				var screen:IScreen = IScreen(this._activeScreen);
				screen.screenID = this._activeScreenID;
				screen.owner = this; //subclasses will implement the interface
			}
			if(this._autoSizeMode == AUTO_SIZE_MODE_CONTENT || !this.stage)
			{
				this._activeScreen.addEventListener(Event.RESIZE, activeScreen_resizeHandler);
			}
			this.prepareActiveScreen();
			this.addChild(this._activeScreen);

			this.invalidate(INVALIDATION_FLAG_SELECTED);
			if(this._validationQueue && !this._validationQueue.isValidating)
			{
				//force a COMPLETE validation of everything
				//but only if we're not already doing that...
				this._validationQueue.advanceTime(0);
			}
			else if(!this._isValidating)
			{
				this.validate();
			}

			this.dispatchEventWith(FeathersEventType.TRANSITION_START);
			this._activeScreen.dispatchEventWith(FeathersEventType.TRANSITION_IN_START);
			if(this._previousScreenInTransition)
			{
				this._previousScreenInTransition.dispatchEventWith(FeathersEventType.TRANSITION_OUT_START);
			}
			if(transition != null)
			{
				//temporarily make the active screen invisible because the
				//transition doesn't start right away.
				this._activeScreen.visible = false;
				this._waitingForTransitionFrameCount = 0;
				this._waitingTransition = transition;
				//this is a workaround for an issue with transition performance.
				//see the comment in the listener for details.
				this.addEventListener(Event.ENTER_FRAME, waitingForTransition_enterFrameHandler);
			}
			else
			{
				defaultTransition(this._previousScreenInTransition, this._activeScreen, transitionComplete);
			}

			this.dispatchEventWith(Event.CHANGE);
			return this._activeScreen;
		}

		/**
		 * @private
		 */
		protected function clearScreenInternal(transition:Function = null):void
		{
			if(!this._activeScreen)
			{
				//no screen visible.
				return;
			}

			if(this._isTransitionActive)
			{
				this._nextScreenID = null;
				this._clearAfterTransition = true;
				this._nextScreenTransition = transition;
				return;
			}

			this.cleanupActiveScreen();

			if(transition != null)
			{
				this._isTransitionActive = true;
				this._previousScreenInTransition = this._activeScreen;
				this._previousScreenInTransitionID = this._activeScreenID;
			}
			this._activeScreen = null;
			this._activeScreenID = null;
			if(transition !== null)
			{
				this.dispatchEventWith(FeathersEventType.TRANSITION_START);
				this._previousScreenInTransition.dispatchEventWith(FeathersEventType.TRANSITION_OUT_START);

				this._waitingForTransitionFrameCount = 0;
				this._waitingTransition = transition;
				//this is a workaround for an issue with transition performance.
				//see the comment in the listener for details.
				this.addEventListener(Event.ENTER_FRAME, waitingForTransition_enterFrameHandler);
			}
			this.invalidate(INVALIDATION_FLAG_SELECTED);
		}

		/**
		 * @private
		 */
		protected function prepareActiveScreen():void
		{
			throw new AbstractMethodError();
		}

		/**
		 * @private
		 */
		protected function cleanupActiveScreen():void
		{
			throw new AbstractMethodError();
		}

		/**
		 * @private
		 */
		protected function transitionComplete(cancelTransition:Boolean = false):void
		{
			this._isTransitionActive = false;
			if(cancelTransition)
			{
				if(this._activeScreen)
				{
					var item:IScreenNavigatorItem = IScreenNavigatorItem(this._screens[this._activeScreenID]);
					this.clearScreenInternal();
					this.removeChild(this._activeScreen, item.canDispose);
				}
				this._activeScreen = this._previousScreenInTransition;
				this._activeScreenID = this._previousScreenInTransitionID;
				this._previousScreenInTransition = null;
				this._previousScreenInTransitionID = null;
				this.prepareActiveScreen();
				this.dispatchEventWith(FeathersEventType.TRANSITION_CANCEL);
			}
			else
			{
				if(this._previousScreenInTransition)
				{
					this._previousScreenInTransition.dispatchEventWith(FeathersEventType.TRANSITION_OUT_COMPLETE)
				}
				if(this._activeScreen)
				{
					this._activeScreen.dispatchEventWith(FeathersEventType.TRANSITION_IN_COMPLETE)
				}
				this.dispatchEventWith(FeathersEventType.TRANSITION_COMPLETE);
				if(this._previousScreenInTransition)
				{
					item = IScreenNavigatorItem(this._screens[this._previousScreenInTransitionID]);
					if(this._previousScreenInTransition is IScreen)
					{
						var screen:IScreen = IScreen(this._previousScreenInTransition);
						screen.screenID = null;
						screen.owner = null;
					}
					this._previousScreenInTransition.removeEventListener(Event.RESIZE, activeScreen_resizeHandler);
					this.removeChild(this._previousScreenInTransition, item.canDispose);
					this._previousScreenInTransition = null;
					this._previousScreenInTransitionID = null;
				}
			}

			if(this._clearAfterTransition)
			{
				this.clearScreenInternal(this._nextScreenTransition);
			}
			else if(this._nextScreenID)
			{
				this.showScreenInternal(this._nextScreenID, this._nextScreenTransition);
			}

			this._nextScreenID = null;
			this._nextScreenTransition = null;
			this._clearAfterTransition = false;
		}

		/**
		 * @private
		 */
		protected function screenNavigator_addedToStageHandler(event:Event):void
		{
			this.stage.addEventListener(Event.RESIZE, stage_resizeHandler);
		}

		/**
		 * @private
		 */
		protected function screenNavigator_removedFromStageHandler(event:Event):void
		{
			this.stage.removeEventListener(Event.RESIZE, stage_resizeHandler);
		}

		/**
		 * @private
		 */
		protected function activeScreen_resizeHandler(event:Event):void
		{
			if(this._isValidating || this._autoSizeMode != AUTO_SIZE_MODE_CONTENT)
			{
				return;
			}
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		/**
		 * @private
		 */
		protected function stage_resizeHandler(event:Event):void
		{
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		/**
		 * @private
		 */
		private function waitingForTransition_enterFrameHandler(event:Event):void
		{
			//we need to wait a couple of frames before we can start the
			//transition to make it as smooth as possible. this feels a little
			//hacky, to be honest, but I can't figure out why waiting only one
			//frame won't do the trick. the delay is so small though that it's
			//virtually impossible to notice.
			if(this._waitingForTransitionFrameCount < 2)
			{
				this._waitingForTransitionFrameCount++;
				return;
			}
			this.removeEventListener(Event.ENTER_FRAME, waitingForTransition_enterFrameHandler);
			if(this._activeScreen)
			{
				this._activeScreen.visible = true;
			}

			var transition:Function = this._waitingTransition;
			this._waitingTransition = null;
			transition(this._previousScreenInTransition, this._activeScreen, transitionComplete);
		}
	}
}
