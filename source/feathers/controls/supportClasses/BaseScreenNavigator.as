/*
Feathers
Copyright 2012-2021 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.supportClasses
{
	import feathers.controls.AutoSizeMode;
	import feathers.controls.IScreen;
	import feathers.core.FeathersControl;
	import feathers.core.IFeathersControl;
	import feathers.core.IMeasureDisplayObject;
	import feathers.core.IValidating;
	import feathers.events.FeathersEventType;
	import feathers.utils.skins.resetFluidChildDimensionsForMeasurement;

	import flash.errors.IllegalOperationError;
	import flash.utils.getDefinitionByName;

	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
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
	 * @see #activeScreen
	 * @see #activeScreenID
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
	 *
	 * @productversion Feathers 2.1.0
	 */
	public class BaseScreenNavigator extends FeathersControl
	{
		/**
		 * @private
		 */
		protected static var SIGNAL_TYPE:Class;

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
			this.screenContainer = this;
			this.addEventListener(Event.ADDED_TO_STAGE, screenNavigator_addedToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, screenNavigator_removedFromStageHandler);
		}

		/**
		 * @private
		 */
		protected var _activeScreenID:String;

		[Bindable(event="change")]
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

		[Bindable(event="change")]
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
		protected var screenContainer:DisplayObjectContainer;

		/**
		 * @private
		 */
		protected var _activeScreenExplicitWidth:Number;

		/**
		 * @private
		 */
		protected var _activeScreenExplicitHeight:Number;

		/**
		 * @private
		 */
		protected var _activeScreenExplicitMinWidth:Number;

		/**
		 * @private
		 */
		protected var _activeScreenExplicitMinHeight:Number;

		/**
		 * @private
		 */
		protected var _activeScreenExplicitMaxWidth:Number;

		/**
		 * @private
		 */
		protected var _activeScreenExplicitMaxHeight:Number;

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
		protected var _delayedTransition:Function = null;

		/**
		 * @private
		 */
		protected var _waitingForDelayedTransition:Boolean = false;

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
			if(!value)
			{
				this.mask = null;
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _autoSizeMode:String = AutoSizeMode.STAGE;

		[Inspectable(type="String",enumeration="stage,content")]
		/**
		 * Determines how the screen navigator will set its own size when its
		 * dimensions (width and height) aren't set explicitly.
		 *
		 * <p>In the following example, the screen navigator will be sized to
		 * match its content:</p>
		 *
		 * <listing version="3.0">
		 * navigator.autoSizeMode = AutoSizeMode.CONTENT;</listing>
		 *
		 * @default feathers.controls.AutoSizeMode.STAGE
		 *
		 * @see feathers.controls.AutoSizeMode#STAGE
		 * @see feathers.controls.AutoSizeMode#CONTENT
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
				if(this._autoSizeMode == AutoSizeMode.CONTENT)
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
			if(this._activeScreen)
			{
				this.cleanupActiveScreen();
				this._activeScreen = null;
				this._activeScreenID = null;
			}
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
				//if someone meant to have a transition, they would have called
				//clearScreen()
				this.clearScreenInternal(null);
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

			this.layoutChildren();

			if(stylesInvalid || sizeInvalid)
			{
				this.refreshMask();
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
		 * <p>Calls <code>saveMeasurements()</code> to set up the
		 * <code>actualWidth</code> and <code>actualHeight</code> member
		 * variables used for layout.</p>
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 */
		protected function autoSizeIfNeeded():Boolean
		{
			var needsWidth:Boolean = this._explicitWidth !== this._explicitWidth; //isNaN
			var needsHeight:Boolean = this._explicitHeight !== this._explicitHeight; //isNaN
			var needsMinWidth:Boolean = this._explicitMinWidth !== this._explicitMinWidth; //isNaN
			var needsMinHeight:Boolean = this._explicitMinHeight !== this._explicitMinHeight; //isNaN
			if(!needsWidth && !needsHeight && !needsMinWidth && !needsMinHeight)
			{
				return false;
			}

			var needsToMeasureContent:Boolean = this._autoSizeMode === AutoSizeMode.CONTENT || this.stage === null;
			var measureScreen:IMeasureDisplayObject = this._activeScreen as IMeasureDisplayObject;
			if(needsToMeasureContent)
			{
				if(this._activeScreen !== null)
				{
					resetFluidChildDimensionsForMeasurement(this._activeScreen,
						this._explicitWidth, this._explicitHeight,
						this._explicitMinWidth, this._explicitMinHeight,
						this._explicitMaxWidth, this._explicitMaxHeight,
						this._activeScreenExplicitWidth, this._activeScreenExplicitHeight,
						this._activeScreenExplicitMinWidth, this._activeScreenExplicitMinHeight,
						this._activeScreenExplicitMaxWidth, this._activeScreenExplicitMaxHeight);
					if(this._activeScreen is IValidating)
					{
						IValidating(this._activeScreen).validate();
					}
				}
			}

			var newWidth:Number = this._explicitWidth;
			if(needsWidth)
			{
				if(needsToMeasureContent)
				{
					if(this._activeScreen !== null)
					{
						newWidth = this._activeScreen.width;
					}
					else
					{
						newWidth = 0;
					}
				}
				else
				{
					newWidth = this.stage.stageWidth;
				}
			}

			var newHeight:Number = this._explicitHeight;
			if(needsHeight)
			{
				if(needsToMeasureContent)
				{
					if(this._activeScreen !== null)
					{
						newHeight = this._activeScreen.height;
					}
					else
					{
						newHeight = 0;
					}
				}
				else
				{
					newHeight = this.stage.stageHeight;
				}
			}

			var newMinWidth:Number = this._explicitMinWidth;
			if(needsMinWidth)
			{
				if(needsToMeasureContent)
				{
					if(measureScreen !== null)
					{
						newMinWidth = measureScreen.minWidth;
					}
					else if(this._activeScreen !== null)
					{
						newMinWidth = this._activeScreen.width;
					}
					else
					{
						newMinWidth = 0;
					}
				}
				else
				{
					newMinWidth = this.stage.stageWidth;
				}
			}

			var newMinHeight:Number = this._explicitMinHeight;
			if(needsMinHeight)
			{
				if(needsToMeasureContent)
				{
					if(measureScreen !== null)
					{
						newMinHeight = measureScreen.minHeight;
					}
					else if(this._activeScreen !== null)
					{
						newMinHeight = this._activeScreen.height;
					}
					else
					{
						newMinHeight = 0;
					}
				}
				else
				{
					newMinHeight = this.stage.stageHeight;
				}
			}

			return this.saveMeasurements(newWidth, newHeight, newMinWidth, newMinHeight);
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
		protected function refreshMask():void
		{
			if(!this._clipContent)
			{
				return;
			}
			var mask:DisplayObject = this.mask as Quad;
			if(mask)
			{
				mask.width = this.actualWidth;
				mask.height = this.actualHeight;
			}
			else
			{
				mask = new Quad(1, 1, 0xff00ff);
				//the initial dimensions cannot be 0 or there's a runtime error,
				//and these values might be 0
				mask.width = this.actualWidth;
				mask.height = this.actualHeight;
				this.mask = mask;
			}
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
				throw new IllegalOperationError("Cannot remove a screen while it is transitioning in or out.");
			}
			if(this._activeScreenID == id)
			{
				//if someone meant to have a transition, they would have called
				//clearScreen()
				this.clearScreenInternal(null);
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

			this._previousScreenInTransition = this._activeScreen;
			this._previousScreenInTransitionID = this._activeScreenID;
			if(this._activeScreen !== null)
			{
				this.cleanupActiveScreen();
			}

			this._isTransitionActive = true;

			var item:IScreenNavigatorItem = IScreenNavigatorItem(this._screens[id]);
			this._activeScreen = item.getScreen();
			this._activeScreenID = id;
			if(item.transitionDelayEvent !== null)
			{
				this._waitingForDelayedTransition = true;
				this._activeScreen.addEventListener(item.transitionDelayEvent, screen_transitionDelayHandler);
			}
			else
			{
				this._waitingForDelayedTransition = false;
			}
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
			if(this._autoSizeMode === AutoSizeMode.CONTENT || !this.stage)
			{
				this._activeScreen.addEventListener(Event.RESIZE, activeScreen_resizeHandler);
			}
			this.prepareActiveScreen();
			var isSameInstance:Boolean = this._previousScreenInTransition === this._activeScreen;
			this.screenContainer.addChild(this._activeScreen);
			if(this._activeScreen is IFeathersControl)
			{
				IFeathersControl(this._activeScreen).initializeNow();
			}
			var measureScreen:IMeasureDisplayObject = this._activeScreen as IMeasureDisplayObject;
			if(measureScreen !== null)
			{
				this._activeScreenExplicitWidth = measureScreen.explicitWidth;
				this._activeScreenExplicitHeight = measureScreen.explicitHeight;
				this._activeScreenExplicitMinWidth = measureScreen.explicitMinWidth;
				this._activeScreenExplicitMinHeight = measureScreen.explicitMinHeight;
				this._activeScreenExplicitMaxWidth = measureScreen.explicitMaxWidth;
				this._activeScreenExplicitMaxHeight = measureScreen.explicitMaxHeight;
			}
			else
			{
				this._activeScreenExplicitWidth = this._activeScreen.width;
				this._activeScreenExplicitHeight = this._activeScreen.height;
				this._activeScreenExplicitMinWidth = this._activeScreenExplicitWidth;
				this._activeScreenExplicitMinHeight = this._activeScreenExplicitHeight;
				this._activeScreenExplicitMaxWidth = this._activeScreenExplicitWidth;
				this._activeScreenExplicitMaxHeight = this._activeScreenExplicitHeight;
			}

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

			if(isSameInstance)
			{
				//we can't transition if both screens are the same display
				//object, so skip the transition!
				this._previousScreenInTransition = null;
				this._previousScreenInTransitionID = null;
				this._isTransitionActive = false;
			}
			else if(item.transitionDelayEvent !== null && this._waitingForDelayedTransition)
			{
				this._waitingForDelayedTransition = false;
				this._activeScreen.visible = false;
				this._delayedTransition = transition;
			}
			else
			{
				if(item.transitionDelayEvent !== null)
				{
					//if we skipped the delay because the event was already
					//dispatched, then don't forget to remove the listener
					this._activeScreen.removeEventListener(item.transitionDelayEvent, screen_transitionDelayHandler);
				}
				this.startTransition(transition);
			}

			this.dispatchEventWith(Event.CHANGE);
			return this._activeScreen;
		}

		/**
		 * @private
		 */
		protected function clearScreenInternal(transition:Function = null):void
		{
			if(this._activeScreen === null)
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

			this._isTransitionActive = true;
			this._previousScreenInTransition = this._activeScreen;
			this._previousScreenInTransitionID = this._activeScreenID;
			this._activeScreen = null;
			this._activeScreenID = null;

			this.dispatchEventWith(FeathersEventType.TRANSITION_START);
			this._previousScreenInTransition.dispatchEventWith(FeathersEventType.TRANSITION_OUT_START);
			if(transition !== null)
			{
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
		protected function layoutChildren():void
		{
			if(this._activeScreen !== null)
			{
				if(this._activeScreen.width != this.actualWidth)
				{
					this._activeScreen.width = this.actualWidth;
				}
				if(this._activeScreen.height != this.actualHeight)
				{
					this._activeScreen.height = this.actualHeight;
				}
				if(this._activeScreen is IValidating)
				{
					IValidating(this._activeScreen).validate();
				}
			}
		}

		/**
		 * @private
		 */
		protected function startTransition(transition:Function):void
		{
			this.dispatchEventWith(FeathersEventType.TRANSITION_START);
			this._activeScreen.dispatchEventWith(FeathersEventType.TRANSITION_IN_START);
			if(this._previousScreenInTransition !== null)
			{
				this._previousScreenInTransition.dispatchEventWith(FeathersEventType.TRANSITION_OUT_START);
			}
			if(transition !== null && transition !== defaultTransition)
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
				//the screen may have been hidden if the transition was delayed
				this._activeScreen.visible = true;
				defaultTransition(this._previousScreenInTransition, this._activeScreen, transitionComplete);
			}
		}

		/**
		 * @private
		 */
		protected function startWaitingTransition():void
		{
			this.removeEventListener(Event.ENTER_FRAME, waitingForTransition_enterFrameHandler);
			if(this._activeScreen)
			{
				this._activeScreen.visible = true;
			}

			var transition:Function = this._waitingTransition;
			this._waitingTransition = null;
			transition(this._previousScreenInTransition, this._activeScreen, transitionComplete);
		}

		/**
		 * @private
		 */
		protected function transitionComplete(cancelTransition:Boolean = false):void
		{
			//consider the transition still active if something is already
			//queued up to happen next. if an event listener asks to show a new
			//screen, it needs to replace what is queued up.
			this._isTransitionActive = this._clearAfterTransition || this._nextScreenID;
			if(cancelTransition)
			{
				if(this._activeScreen !== null)
				{
					var item:IScreenNavigatorItem = IScreenNavigatorItem(this._screens[this._activeScreenID]);
					this.cleanupActiveScreen();
					this.screenContainer.removeChild(this._activeScreen, item.canDispose);
					if(!item.canDispose)
					{
						this._activeScreen.width = this._activeScreenExplicitWidth;
						this._activeScreen.height = this._activeScreenExplicitHeight;
						var measureScreen:IMeasureDisplayObject = this._activeScreen as IMeasureDisplayObject;
						if(measureScreen !== null)
						{
							measureScreen.minWidth = this._activeScreenExplicitMinWidth;
							measureScreen.minHeight = this._activeScreenExplicitMinHeight;
						}
					}
				}
				this._activeScreen = this._previousScreenInTransition;
				this._activeScreenID = this._previousScreenInTransitionID;
				this._previousScreenInTransition = null;
				this._previousScreenInTransitionID = null;
				this.prepareActiveScreen();
				this.dispatchEventWith(FeathersEventType.TRANSITION_CANCEL);
				this.dispatchEventWith(Event.CHANGE);
			}
			else
			{
				//we need to save these in local variables because a new
				//transition may be started in the listeners for the transition
				//complete events, and that will overwrite them.
				var activeScreen:DisplayObject = this._activeScreen;
				var previousScreen:DisplayObject = this._previousScreenInTransition;
				var previousScreenID:String = this._previousScreenInTransitionID;
				item = IScreenNavigatorItem(this._screens[previousScreenID]);
				this._previousScreenInTransition = null;
				this._previousScreenInTransitionID = null;
				if(previousScreen !== null)
				{
					previousScreen.dispatchEventWith(FeathersEventType.TRANSITION_OUT_COMPLETE);
				}
				if(activeScreen !== null)
				{
					activeScreen.dispatchEventWith(FeathersEventType.TRANSITION_IN_COMPLETE);
				}
				//we need to dispatch this event before the previous screen's
				//owner property is set to null because legacy code that was
				//written before TRANSITION_OUT_COMPLETE existed may be using
				//this event for the same purpose.
				this.dispatchEventWith(FeathersEventType.TRANSITION_COMPLETE);
				if(previousScreen !== null)
				{
					if(previousScreen is IScreen)
					{
						var screen:IScreen = IScreen(previousScreen);
						screen.screenID = null;
						screen.owner = null;
					}
					previousScreen.removeEventListener(Event.RESIZE, activeScreen_resizeHandler);
					this.screenContainer.removeChild(previousScreen, item.canDispose);
				}
			}

			this._isTransitionActive = false;
			var nextTransition:Function = this._nextScreenTransition;
			this._nextScreenTransition = null;
			if(this._clearAfterTransition)
			{
				this._clearAfterTransition = false;
				this.clearScreenInternal(nextTransition);
			}
			else if(this._nextScreenID !== null)
			{
				var nextScreenID:String = this._nextScreenID;
				this._nextScreenID = null;
				this.showScreenInternal(nextScreenID, nextTransition);
			}
		}

		/**
		 * @private
		 */
		protected function screenNavigator_addedToStageHandler(event:Event):void
		{
			if(this._autoSizeMode === AutoSizeMode.STAGE)
			{
				//if we validated before being added to the stage, or if we've
				//been removed from stage and added again, we need to be sure
				//that the new stage dimensions are accounted for.
				this.invalidate(INVALIDATION_FLAG_SIZE);
			}
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
			if(this._isValidating || this._autoSizeMode != AutoSizeMode.CONTENT)
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
		protected function screen_transitionDelayHandler(event:Event):void
		{
			this._activeScreen.removeEventListener(event.type, screen_transitionDelayHandler);
			var wasWaiting:Boolean = this._waitingForDelayedTransition;
			this._waitingForDelayedTransition = false;
			if(wasWaiting)
			{
				return;
			}
			var transition:Function = this._delayedTransition;
			this._delayedTransition = null;
			this.startTransition(transition);
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
			this.startWaitingTransition();
		}
	}
}
