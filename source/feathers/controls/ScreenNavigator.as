/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.core.FeathersControl;
	import feathers.core.IFeathersControl;
	import feathers.events.FeathersEventType;

	import flash.errors.IllegalOperationError;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;

	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.ResizeEvent;

	/**
	 * Dispatched when the active screen changes.
	 *
	 * @eventType starling.events.Event.CHANGE
	 */
	[Event(name="change",type="starling.events.Event")]

	/**
	 * Dispatched when the current screen is removed and there is no active
	 * screen.
	 *
	 * @eventType feathers.events.FeathersEventType.CLEAR
	 */
	[Event(name="clear",type="starling.events.Event")]

	/**
	 * Dispatched when the transition between screens begins.
	 *
	 * @eventType feathers.events.FeathersEventType.TRANSITION_START
	 */
	[Event(name="transitionStart",type="starling.events.Event")]

	/**
	 * Dispatched when the transition between screens has completed.
	 *
	 * @eventType feathers.events.FeathersEventType.TRANSITION_COMPLETE
	 */
	[Event(name="transitionComplete",type="starling.events.Event")]

	/**
	 * A "view stack"-like container that supports navigation between screens
	 * (any display object) through events.
	 *
	 * <p>The following example creates a screen navigator, adds a screen and
	 * displays it:</p>
	 *
	 * <listing version="3.0">
	 * var navigator:ScreenNavigator = new ScreenNavigator();
	 * navigator.addScreen( "mainMenu", new ScreenNavigatorItem( MainMenuScreen );
	 * this.addChild( navigator );
	 *
	 * navigator.showScreen( "mainMenu" );</listing>
	 *
	 * @see http://wiki.starling-framework.org/feathers/screen-navigator
	 * @see http://wiki.starling-framework.org/feathers/transitions
	 * @see feathers.controls.ScreenNavigatorItem
	 */
	public class ScreenNavigator extends FeathersControl
	{
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
		public function ScreenNavigator()
		{
			super();
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
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
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
		 * A function that is called when the <code>ScreenNavigator</code> is
		 * changing screens that is intended to display a transition effect and
		 * to notify the <code>ScreenNavigator</code> when the effect is
		 * finished.
		 *
		 * <p>The function should have the following signature:</p>
		 * <pre>function(oldScreen:DisplayObject, newScreen:DisplayObject, completeCallback:Function):void</pre>
		 *
		 * <p>Either of the <code>oldScreen</code> and <code>newScreen</code>
		 * arguments may be <code>null</code>, but never both. The
		 * <code>oldScreen</code> argument will be <code>null</code> when the
		 * first screen is displayed or when a new screen is displayed after
		 * clearing the screen. The <code>newScreen</code> argument will
		 * be null when clearing the screen.</p>
		 *
		 * <p>The <code>completeCallback</code> function <em>must</em> be called
		 * when the transition effect finishes. It takes zero arguments and
		 * returns nothing. In other words, it has the following signature:</p>
		 *
		 * <pre>function():void</pre>
		 *
		 * <p>In the future, it may be possible for a transition to cancel
		 * itself. If this happens, the <code>completeCallback</code> may begin
		 * accepting arguments, but they will have default values and existing
		 * uses of <code>completeCallback</code> should continue to work.</p>
		 *
		 * @see #showScreen()
		 * @see #clearScreen()
		 * @see http://wiki.starling-framework.org/feathers/transitions
		 */
		public var transition:Function = defaultTransition;

		/**
		 * @private
		 */
		protected var _screens:Object = {};

		/**
		 * @private
		 */
		protected var _screenEvents:Object = {};

		/**
		 * @private
		 */
		protected var _transitionIsActive:Boolean = false;

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
		protected var _clearAfterTransition:Boolean = false;

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
					this._activeScreen.addEventListener(FeathersEventType.RESIZE, activeScreen_resizeHandler);
				}
				else
				{
					this._activeScreen.removeEventListener(FeathersEventType.RESIZE, activeScreen_resizeHandler);
				}
			}
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		/**
		 * Displays a screen and returns a reference to it. If a previous
		 * transition is running, the new screen will be queued, and no
		 * reference will be returned.
		 */
		public function showScreen(id:String):DisplayObject
		{
			if(!this._screens.hasOwnProperty(id))
			{
				throw new IllegalOperationError("Screen with id '" + id + "' cannot be shown because it has not been defined.");
			}

			if(this._activeScreenID == id)
			{
				return this._activeScreen;
			}

			if(this._transitionIsActive)
			{
				this._nextScreenID = id;
				this._clearAfterTransition = false;
				return null;
			}

			this._previousScreenInTransition = this._activeScreen;
			this._previousScreenInTransitionID = this._activeScreenID;
			if(this._activeScreen)
			{
				this.clearScreenInternal(false);
			}
			
			this._transitionIsActive = true;

			const item:ScreenNavigatorItem = ScreenNavigatorItem(this._screens[id]);
			this._activeScreen = item.getScreen();
			if(this._activeScreen is IScreen)
			{
				const screen:IScreen = IScreen(this._activeScreen);
				screen.screenID = id;
				screen.owner = this;
			}
			this._activeScreenID = id;

			const events:Object = item.events;
			const savedScreenEvents:Object = {};
			for(var eventName:String in events)
			{
				var signal:Object = this._activeScreen.hasOwnProperty(eventName) ? (this._activeScreen[eventName] as SIGNAL_TYPE) : null;
				var eventAction:Object = events[eventName];
				if(eventAction is Function)
				{
					if(signal)
					{
						signal.add(eventAction as Function);
					}
					else
					{
						this._activeScreen.addEventListener(eventName, eventAction as Function);
					}
				}
				else if(eventAction is String)
				{
					if(signal)
					{
						var eventListener:Function = this.createScreenSignalListener(eventAction as String, signal);
						signal.add(eventListener);
					}
					else
					{
						eventListener = this.createScreenEventListener(eventAction as String);
						this._activeScreen.addEventListener(eventName, eventListener);
					}
					savedScreenEvents[eventName] = eventListener;
				}
				else
				{
					throw new TypeError("Unknown event action defined for screen:", eventAction.toString());
				}
			}

			this._screenEvents[id] = savedScreenEvents;

			if(this._autoSizeMode == AUTO_SIZE_MODE_CONTENT)
			{
				this._activeScreen.addEventListener(FeathersEventType.RESIZE, activeScreen_resizeHandler);
			}
			this.addChild(this._activeScreen);

			this.invalidate(INVALIDATION_FLAG_SELECTED);
			if(!VALIDATION_QUEUE.isValidating)
			{
				//force a COMPLETE validation of everything
				//but only if we're not already doing that...
				VALIDATION_QUEUE.advanceTime(0);
			}

			this.dispatchEventWith(FeathersEventType.TRANSITION_START);
			this.transition(this._previousScreenInTransition, this._activeScreen, transitionComplete);

			this.dispatchEventWith(Event.CHANGE);
			return this._activeScreen;
		}

		/**
		 * Removes the current screen, leaving the <code>ScreenNavigator</code>
		 * empty.
		 */
		public function clearScreen():void
		{
			if(this._transitionIsActive)
			{
				this._nextScreenID = null;
				this._clearAfterTransition = true;
				return;
			}

			this.clearScreenInternal(true);
			this.dispatchEventWith(FeathersEventType.CLEAR);
		}

		/**
		 * @private
		 */
		protected function clearScreenInternal(displayTransition:Boolean):void
		{
			if(!this._activeScreen)
			{
				//no screen visible.
				return;
			}

			const item:ScreenNavigatorItem = ScreenNavigatorItem(this._screens[this._activeScreenID]);
			const events:Object = item.events;
			const savedScreenEvents:Object = this._screenEvents[this._activeScreenID];
			for(var eventName:String in events)
			{
				var signal:Object = this._activeScreen.hasOwnProperty(eventName) ? (this._activeScreen[eventName] as SIGNAL_TYPE) : null;
				var eventAction:Object = events[eventName];
				if(eventAction is Function)
				{
					if(signal)
					{
						signal.remove(eventAction as Function);
					}
					else
					{
						this._activeScreen.removeEventListener(eventName, eventAction as Function);
					}
				}
				else if(eventAction is String)
				{
					var eventListener:Function = savedScreenEvents[eventName] as Function;
					if(signal)
					{
						signal.remove(eventListener);
					}
					else
					{
						this._activeScreen.removeEventListener(eventName, eventListener);
					}
				}
			}

			if(displayTransition)
			{
				this._transitionIsActive = true;
				this._previousScreenInTransition = this._activeScreen;
				this._previousScreenInTransitionID = this._activeScreenID;
			}
			this._screenEvents[this._activeScreenID] = null;
			this._activeScreen = null;
			this._activeScreenID = null;
			if(displayTransition)
			{
				this.transition(this._previousScreenInTransition, null, transitionComplete);
			}
			this.invalidate(INVALIDATION_FLAG_SELECTED);
		}

		/**
		 * Registers a new screen by its identifier.
		 */
		public function addScreen(id:String, item:ScreenNavigatorItem):void
		{
			if(this._screens.hasOwnProperty(id))
			{
				throw new IllegalOperationError("Screen with id '" + id + "' already defined. Cannot add two screens with the same id.");
			}

			this._screens[id] = item;
		}

		/**
		 * Removes an existing screen using its identifier.
		 */
		public function removeScreen(id:String):void
		{
			if(!this._screens.hasOwnProperty(id))
			{
				throw new IllegalOperationError("Screen '" + id + "' cannot be removed because it has not been added.");
			}
			if(this._activeScreenID == id)
			{
				this.clearScreen();
			}
			delete this._screens[id];
		}

		/**
		 * Removes all screens.
		 */
		public function removeAllScreens():void
		{
			this.clearScreen();
			for(var id:String in this._screens)
			{
				delete this._screens[id];
			}
		}

		/**
		 * Determines if the specified screen identifier has been added.
		 */
		public function hasScreen(id:String):Boolean
		{
			return this._screens.hasOwnProperty(id);
		}

		/**
		 * Returns the <code>ScreenNavigatorItem</code> instance with the
		 * specified identifier.
		 */
		public function getScreen(id:String):ScreenNavigatorItem
		{
			if(this._screens.hasOwnProperty(id))
			{
				return ScreenNavigatorItem(this._screens[id]);
			}
			return null;
		}

		/**
		 * Returns a list of the screen identifiers that have been added.
		 */
		public function getScreenIDs(result:Vector.<String> = null):Vector.<String>
		{
			if(!result)
			{
				result = new <String>[];
			}

			for(var id:String in this._screens)
			{
				result.push(id);
			}
			return result;
		}

		/**
		 * @private
		 */
		override public function dispose():void
		{
			this.clearScreenInternal(false);
			super.dispose();
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			const selectionInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SELECTED);
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);

			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

			if(sizeInvalid || selectionInvalid)
			{
				if(this._activeScreen && this._autoSizeMode != AUTO_SIZE_MODE_CONTENT)
				{
					this._activeScreen.width = this.actualWidth;
					this._activeScreen.height = this.actualHeight;
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
			const needsWidth:Boolean = isNaN(this.explicitWidth);
			const needsHeight:Boolean = isNaN(this.explicitHeight);
			if(!needsWidth && !needsHeight)
			{
				return false;
			}

			if(this._autoSizeMode == AUTO_SIZE_MODE_CONTENT &&
				this._activeScreen is IFeathersControl)
			{
				IFeathersControl(this._activeScreen).validate();
			}

			var newWidth:Number = this.explicitWidth;
			if(needsWidth)
			{
				if(this._autoSizeMode == AUTO_SIZE_MODE_CONTENT)
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
				if(this._autoSizeMode == AUTO_SIZE_MODE_CONTENT)
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
		protected function transitionComplete():void
		{
			this._transitionIsActive = false;
			this.dispatchEventWith(FeathersEventType.TRANSITION_COMPLETE);
			if(this._previousScreenInTransition)
			{
				const item:ScreenNavigatorItem = this._screens[this._previousScreenInTransitionID];
				const canBeDisposed:Boolean = !(item.screen is DisplayObject);
				if(this._previousScreenInTransition is IScreen)
				{
					const screen:IScreen = IScreen(this._previousScreenInTransition);
					screen.screenID = null;
					screen.owner = null;
				}
				if(this._autoSizeMode == AUTO_SIZE_MODE_CONTENT)
				{
					this._previousScreenInTransition.removeEventListener(FeathersEventType.RESIZE, activeScreen_resizeHandler);
				}
				this.removeChild(this._previousScreenInTransition, canBeDisposed);
				this._previousScreenInTransition = null;
				this._previousScreenInTransitionID = null;
			}

			if(this._clearAfterTransition)
			{
				this.clearScreen();
			}
			else if(this._nextScreenID)
			{
				this.showScreen(this._nextScreenID);
			}

			this._nextScreenID = null;
			this._clearAfterTransition = false;
		}

		/**
		 * @private
		 */
		protected function createScreenEventListener(screenID:String):Function
		{
			const self:ScreenNavigator = this;
			const eventListener:Function = function(event:Event):void
			{
				self.showScreen(screenID);
			};

			return eventListener;
		}

		/**
		 * @private
		 */
		protected function createScreenSignalListener(screenID:String, signal:Object):Function
		{
			const self:ScreenNavigator = this;
			if(signal.valueClasses.length == 1)
			{
				//shortcut to avoid the allocation of the rest array
				var signalListener:Function = function(arg0:Object):void
				{
					self.showScreen(screenID);
				};
			}
			else
			{
				signalListener = function(...rest:Array):void
				{
					self.showScreen(screenID);
				};
			}

			return signalListener;
		}

		/**
		 * @private
		 */
		protected function addedToStageHandler(event:Event):void
		{
			this.stage.addEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
		}

		/**
		 * @private
		 */
		protected function removedFromStageHandler(event:Event):void
		{
			this.stage.removeEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
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
		protected function stage_resizeHandler(event:ResizeEvent):void
		{
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}
	}

}