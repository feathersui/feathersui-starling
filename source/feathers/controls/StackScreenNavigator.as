/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.controls.supportClasses.BaseScreenNavigator;
	import feathers.events.FeathersEventType;
	import feathers.skins.IStyleProvider;

	import starling.display.DisplayObject;
	import starling.events.Event;

	/**
	 * A "view stack"-like container that supports navigation between screens
	 * (any display object) through events.
	 *
	 * <p>The following example creates a screen navigator, adds a screen and
	 * displays it:</p>
	 *
	 * <listing version="3.0">
	 * var navigator:StackScreenNavigator = new StackScreenNavigator();
	 * navigator.addScreen( "mainMenu", new StackScreenNavigatorItem( MainMenuScreen ) );
	 * this.addChild( navigator );
	 * 
	 * navigator.rootScreenID = "mainMenu";</listing>
	 *
	 * @see ../../../help/stack-screen-navigator.html How to use the Feathers StackScreenNavigator component
	 * @see ../../../help/transitions.html Transitions for Feathers screen navigators
	 * @see feathers.controls.StackScreenNavigatorItem
	 */
	public class StackScreenNavigator extends BaseScreenNavigator
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
		 * The default <code>IStyleProvider</code> for all <code>StackScreenNavigator</code>
		 * components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * Constructor.
		 */
		public function StackScreenNavigator()
		{
			super();
			this.addEventListener(FeathersEventType.INITIALIZE, stackScreenNavigator_initializeHandler);
		}

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return StackScreenNavigator.globalStyleProvider;
		}

		/**
		 * @private
		 */
		protected var _pushTransition:Function;

		/**
		 * Typically used to provide some kind of animation or visual effect,
		 * this function that is called when the screen navigator pushes a new
		 * screen onto the stack. 
		 *
		 * <p>In the following example, the screen navigator is given a push
		 * transition that slides the screens to the left:</p>
		 *
		 * <listing version="3.0">
		 * navigator.pushTransition = Slide.createSlideLeftTransition();</listing>
		 *
		 * <p>A number of animated transitions may be found in the
		 * <a href="../motion/package-detail.html">feathers.motion</a> package.
		 * However, you are not limited to only these transitions. It's possible
		 * to create custom transitions too.</p>
		 *
		 * <p>A custom transition function should have the following signature:</p>
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
		 * when the transition effect finishes. This callback indicate to the
		 * screen navigator that the transition has finished. This function has
		 * the following signature:</p>
		 *
		 * <pre>function(cancelTransition:Boolean = false):void</pre>
		 *
		 * <p>The first argument defaults to <code>false</code>, meaning that
		 * the transition completed successfully. In most cases, this callback
		 * may be called without arguments. If a transition is cancelled before
		 * completion (perhaps through some kind of user interaction), and the
		 * previous screen should be restored, pass <code>true</code> as the
		 * first argument to the callback to inform the screen navigator that
		 * the transition is cancelled.</p>
		 *
		 * @default null
		 *
		 * @see #pushScreen()
		 * @see ../../../help/transitions.html Transitions for Feathers screen navigators
		 */
		public function get pushTransition():Function
		{
			return this._pushTransition;
		}

		/**
		 * @private
		 */
		public function set pushTransition(value:Function):void
		{
			if(this._pushTransition == value)
			{
				return;
			}
			this._pushTransition = value;
		}

		/**
		 * @private
		 */
		protected var _popTransition:Function;

		/**
		 * Typically used to provide some kind of animation or visual effect,
		 * this function that is called when the screen navigator pops a screen
		 * from the top of the stack.
		 *
		 * <p>In the following example, the screen navigator is given a pop
		 * transition that slides the screens to the right:</p>
		 *
		 * <listing version="3.0">
		 * navigator.popTransition = Slide.createSlideRightTransition();</listing>
		 *
		 * <p>A number of animated transitions may be found in the
		 * <a href="../motion/package-detail.html">feathers.motion</a> package.
		 * However, you are not limited to only these transitions. It's possible
		 * to create custom transitions too.</p>
		 *
		 * <p>A custom transition function should have the following signature:</p>
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
		 * when the transition effect finishes. This callback indicate to the
		 * screen navigator that the transition has finished. This function has
		 * the following signature:</p>
		 *
		 * <pre>function(cancelTransition:Boolean = false):void</pre>
		 *
		 * <p>The first argument defaults to <code>false</code>, meaning that
		 * the transition completed successfully. In most cases, this callback
		 * may be called without arguments. If a transition is cancelled before
		 * completion (perhaps through some kind of user interaction), and the
		 * previous screen should be restored, pass <code>true</code> as the
		 * first argument to the callback to inform the screen navigator that
		 * the transition is cancelled.</p>
		 *
		 * @default null
		 *
		 * @see #popScreen()
		 * @see ../../../help/transitions.html Transitions for Feathers screen navigators
		 */
		public function get popTransition():Function
		{
			return this._popTransition;
		}

		/**
		 * @private
		 */
		public function set popTransition(value:Function):void
		{
			if(this._popTransition == value)
			{
				return;
			}
			this._popTransition = value;
		}

		/**
		 * @private
		 */
		protected var _popToRootTransition:Function = null;

		/**
		 * Typically used to provide some kind of animation or visual effect, a
		 * function that is called when the screen navigator clears its stack,
		 * to show the first screen that was pushed onto the stack.
		 *
		 * <p>If this property is <code>null</code>, the value of the
		 * <code>popTransition</code> property will be used instead.</p>
		 *
		 * <p>In the following example, a custom pop to root transition is
		 * passed to the screen navigator:</p>
		 *
		 * <listing version="3.0">
		 * navigator.popToRootTransition = Fade.createFadeInTransition();</listing>
		 *
		 * <p>A number of animated transitions may be found in the
		 * <a href="../motion/package-detail.html">feathers.motion</a> package.
		 * However, you are not limited to only these transitions. It's possible
		 * to create custom transitions too.</p>
		 *
		 * <p>A custom transition function should have the following signature:</p>
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
		 * when the transition effect finishes. This callback indicate to the
		 * screen navigator that the transition has finished. This function has
		 * the following signature:</p>
		 *
		 * <pre>function(cancelTransition:Boolean = false):void</pre>
		 *
		 * <p>The first argument defaults to <code>false</code>, meaning that
		 * the transition completed successfully. In most cases, this callback
		 * may be called without arguments. If a transition is cancelled before
		 * completion (perhaps through some kind of user interaction), and the
		 * previous screen should be restored, pass <code>true</code> as the
		 * first argument to the callback to inform the screen navigator that
		 * the transition is cancelled.</p>
		 *
		 * @default null
		 *
		 * @see #popTransition
		 * @see #popToRootScreen()
		 * @see ../../../help/transitions.html Transitions for Feathers screen navigators
		 */
		public function get popToRootTransition():Function
		{
			return this._popToRootTransition;
		}

		/**
		 * @private
		 */
		public function set popToRootTransition(value:Function):void
		{
			if(this._popToRootTransition == value)
			{
				return;
			}
			this._popToRootTransition = value;
		}

		/**
		 * @private
		 */
		protected var _stack:Vector.<StackItem> = new <StackItem>[];

		/**
		 * @private
		 */
		protected var _pushScreenEvents:Object = {};

		/**
		 * @private
		 */
		protected var _replaceScreenEvents:Object;

		/**
		 * @private
		 */
		protected var _popScreenEvents:Vector.<String>;

		/**
		 * @private
		 */
		protected var _popToRootScreenEvents:Vector.<String>;

		/**
		 * @private
		 */
		protected var _tempRootScreenID:String;

		/**
		 * Sets the first screen at the bottom of the stack, or the root screen.
		 * When this screen is shown, there will be no transition.
		 *
		 * <p>If the stack contains screens when you set this property, they
		 * will be removed from the stack. In other words, setting this property
		 * will clear the stack, erasing the current history.</p>
		 *
		 * <p>In the following example, the root screen is set:</p>
		 *
		 * <listing version="3.0">
		 * navigator.rootScreenID = "someScreen";</listing>
		 *
		 * @see #popToRootScreen()
		 */
		public function get rootScreenID():String
		{
			if(this._tempRootScreenID !== null)
			{
				return this._tempRootScreenID;
			}
			else if(this._stack.length == 0)
			{
				return this._activeScreenID;
			}
			return this._stack[0].id;
		}

		/**
		 * @private
		 */
		public function set rootScreenID(value:String):void
		{
			if(this._isInitialized)
			{
				//we may have delayed showing the root screen until after
				//initialization, but this property could be set between when
				//_isInitialized is set to true and when the screen is actually
				//shown, so we need to clear this variable, just in case. 
				this._tempRootScreenID = null;
				
				//this clears the whole stack and starts fresh
				this._stack.length = 0;
				if(value !== null)
				{
					//show without a transition because we're not navigating.
					//we're forcibly replacing the root screen.
					this.showScreenInternal(value, null);
				}
				else
				{
					this.clearScreenInternal(null);
				}
			}
			else
			{
				this._tempRootScreenID = value;
			}
		}

		/**
		 * Registers a new screen with a string identifier that can be used
		 * to reference the screen in other calls, like <code>removeScreen()</code>
		 * or <code>pushScreen()</code>.
		 *
		 * @see #removeScreen()
		 */
		public function addScreen(id:String, item:StackScreenNavigatorItem):void
		{
			this.addScreenInternal(id, item);
		}

		/**
		 * Removes an existing screen using the identifier assigned to it in the
		 * call to <code>addScreen()</code>.
		 *
		 * @see #removeAllScreens()
		 * @see #addScreen()
		 */
		public function removeScreen(id:String):StackScreenNavigatorItem
		{
			var stackCount:int = this._stack.length;
			for(var i:int = stackCount - 1; i >= 0; i--)
			{
				var item:StackItem = this._stack[i];
				if(item.id == id)
				{
					this._stack.splice(i, 1);
				}
			}
			return StackScreenNavigatorItem(this.removeScreenInternal(id));
		}

		/**
		 * @private
		 */
		override public function removeAllScreens():void
		{
			this._stack.length = 0;
			super.removeAllScreens();
		}

		/**
		 * Returns the <code>StackScreenNavigatorItem</code> instance with the
		 * specified identifier.
		 */
		public function getScreen(id:String):StackScreenNavigatorItem
		{
			if(this._screens.hasOwnProperty(id))
			{
				return StackScreenNavigatorItem(this._screens[id]);
			}
			return null;
		}

		/**
		 * Pushes a screen onto the top of the stack.
		 *
		 * <p>A set of key-value pairs representing properties on the previous
		 * screen may be passed in. If the new screen is popped, these values
		 * may be used to restore the previous screen's state.</p>
		 *
		 * <p>An optional transition may be specified. If <code>null</code> the
		 * <code>pushTransition</code> property will be used instead.</p>
		 *
		 * <p>Returns a reference to the new screen, unless a transition is
		 * currently active. In that case, the new screen will be queued until
		 * the transition has completed, and no reference will be returned.</p>
		 *
		 * @see #pushTransition
		 */
		public function pushScreen(id:String, savedPreviousScreenProperties:Object = null, transition:Function = null):DisplayObject
		{
			if(transition === null)
			{
				var item:StackScreenNavigatorItem = this.getScreen(id);
				if(item && item.pushTransition !== null)
				{
					transition = item.pushTransition;
				}
				else
				{
					transition = this.pushTransition;
				}
			}
			if(this._activeScreenID)
			{
				this._stack[this._stack.length] = new StackItem(this._activeScreenID, savedPreviousScreenProperties);
			}
			else if(savedPreviousScreenProperties)
			{
				throw new ArgumentError("Cannot save properties for the previous screen because there is no previous screen.");
			}
			return this.showScreenInternal(id, transition);
		}

		/**
		 * Pops the current screen from the top of the stack, returning to the
		 * previous screen.
		 *
		 * <p>An optional transition may be specified. If <code>null</code> the
		 * <code>popTransition</code> property will be used instead.</p>
		 *
		 * <p>Returns a reference to the new screen, unless a transition is
		 * currently active. In that case, the new screen will be queued until
		 * the transition has completed, and no reference will be returned.</p>
		 *
		 * @see #popTransition
		 */
		public function popScreen(transition:Function = null):DisplayObject
		{
			if(this._stack.length == 0)
			{
				return this._activeScreen;
			}
			if(transition === null)
			{
				var screenItem:StackScreenNavigatorItem = this.getScreen(this._activeScreenID);
				if(screenItem && screenItem.popTransition !== null)
				{
					transition = screenItem.popTransition;
				}
				else
				{
					transition = this.popTransition;
				}
			}
			var stackItem:StackItem = this._stack.pop();
			return this.showScreenInternal(stackItem.id, transition, stackItem.properties);
		}

		/**
		 * Returns to the root screen, at the bottom of the stack.
		 *
		 * <p>An optional transition may be specified. If <code>null</code>, the
		 * <code>popToRootTransition</code> or <code>popTransition</code>
		 * property will be used instead.</p>
		 *
		 * <p>Returns a reference to the new screen, unless a transition is
		 * currently active. In that case, the new screen will be queued until
		 * the transition has completed, and no reference will be returned.</p>
		 *
		 * @see #popToRootTransition
		 * @see #popTransition
		 */
		public function popToRootScreen(transition:Function = null):DisplayObject
		{
			if(this._stack.length == 0)
			{
				return this._activeScreen;
			}
			if(transition == null)
			{
				transition = this.popToRootTransition;
				if(transition == null)
				{
					transition = this.popTransition;
				}
			}
			var item:StackItem = this._stack[0];
			this._stack.length = 0;
			return this.showScreenInternal(item.id, transition, item.properties);
		}

		/**
		 * Pops all screens from the stack, leaving the
		 * <code>StackScreenNavigator</code> empty.
		 *
		 * <p>An optional transition may be specified. If <code>null</code>, the
		 * <code>popTransition</code> property will be used instead.</p>
		 *
		 * @see #popTransition
		 */
		public function popAll(transition:Function = null):void
		{
			if(!this._activeScreen)
			{
				return;
			}
			if(transition == null)
			{
				transition = this.popTransition;
			}
			var item:StackItem = this._stack[0];
			this._stack.length = 0;
			this.clearScreenInternal(transition);
		}

		/**
		 * Returns to the root screen, at the bottom of the stack, but replaces
		 * it with a new root screen.
		 *
		 * <p>An optional transition may be specified. If <code>null</code>, the
		 * <code>popToRootTransition</code> or <code>popTransition</code>
		 * property will be used instead.</p>
		 *
		 * <p>Returns a reference to the new screen, unless a transition is
		 * currently active. In that case, the new screen will be queued until
		 * the transition has completed, and no reference will be returned.</p>
		 *
		 * @see #popToRootTransition
		 * @see #popTransition
		 */
		public function popToRootScreenAndReplace(id:String, transition:Function = null):DisplayObject
		{
			if(transition == null)
			{
				transition = this.popToRootTransition;
				if(transition == null)
				{
					transition = this.popTransition;
				}
			}
			this._stack.length = 0;
			return this.showScreenInternal(id, transition);
		}

		/**
		 * Replaces the current screen on the top of the stack with a new
		 * screen. May be used in the case where you want to navigate from
		 * screen A to screen B and then to screen C, but when popping screen C,
		 * you want to skip screen B and return to screen A.
		 * 
		 * <p>Returns a reference to the new screen, unless a transition is
		 * currently active. In that case, the new screen will be queued until
		 * the transition has completed, and no reference will be returned.</p>
		 *
		 * <p>An optional transition may be specified. If <code>null</code> the
		 * <code>pushTransition</code> property will be used instead.</p>
		 *
		 * @see #pushTransition
		 */
		public function replaceScreen(id:String, transition:Function = null):DisplayObject
		{
			if(transition === null)
			{
				var item:StackScreenNavigatorItem = this.getScreen(id);
				if(item && item.pushTransition !== null)
				{
					transition = item.pushTransition;
				}
				else
				{
					transition = this.pushTransition;
				}
			}
			return this.showScreenInternal(id, transition);
		}

		/**
		 * @private
		 */
		override protected function prepareActiveScreen():void
		{
			var item:StackScreenNavigatorItem = StackScreenNavigatorItem(this._screens[this._activeScreenID]);
			this.addPushEventsToActiveScreen(item);
			this.addReplaceEventsToActiveScreen(item);
			this.addPopEventsToActiveScreen(item);
			this.addPopToRootEventsToActiveScreen(item);
		}

		/**
		 * @private
		 */
		override protected function cleanupActiveScreen():void
		{
			var item:StackScreenNavigatorItem = StackScreenNavigatorItem(this._screens[this._activeScreenID]);
			this.removePushEventsFromActiveScreen(item);
			this.removeReplaceEventsFromActiveScreen(item);
			this.removePopEventsFromActiveScreen(item);
			this.removePopToRootEventsFromActiveScreen(item);
		}

		/**
		 * @private
		 */
		protected function addPushEventsToActiveScreen(item:StackScreenNavigatorItem):void
		{
			var events:Object = item.pushEvents;
			var savedScreenEvents:Object = {};
			for(var eventName:String in events)
			{
				var signal:Object = this._activeScreen.hasOwnProperty(eventName) ? (this._activeScreen[eventName] as BaseScreenNavigator.SIGNAL_TYPE) : null;
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
						var eventListener:Function = this.createPushScreenSignalListener(eventAction as String, signal);
						signal.add(eventListener);
					}
					else
					{
						eventListener = this.createPushScreenEventListener(eventAction as String);
						this._activeScreen.addEventListener(eventName, eventListener);
					}
					savedScreenEvents[eventName] = eventListener;
				}
				else
				{
					throw new TypeError("Unknown push event action defined for screen:", eventAction.toString());
				}
			}
			this._pushScreenEvents[this._activeScreenID] = savedScreenEvents;
		}

		/**
		 * @private
		 */
		protected function removePushEventsFromActiveScreen(item:StackScreenNavigatorItem):void
		{
			var pushEvents:Object = item.pushEvents;
			var savedScreenEvents:Object = this._pushScreenEvents[this._activeScreenID];
			for(var eventName:String in pushEvents)
			{
				var signal:Object = this._activeScreen.hasOwnProperty(eventName) ? (this._activeScreen[eventName] as BaseScreenNavigator.SIGNAL_TYPE) : null;
				var eventAction:Object = pushEvents[eventName];
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
			this._pushScreenEvents[this._activeScreenID] = null;
		}

		/**
		 * @private
		 */
		protected function addReplaceEventsToActiveScreen(item:StackScreenNavigatorItem):void
		{
			var events:Object = item.replaceEvents;
			if(!events)
			{
				return;
			}
			var savedScreenEvents:Object = {};
			for(var eventName:String in events)
			{
				var signal:Object = this._activeScreen.hasOwnProperty(eventName) ? (this._activeScreen[eventName] as BaseScreenNavigator.SIGNAL_TYPE) : null;
				var eventAction:Object = events[eventName];
				if(eventAction is String)
				{
					if(signal)
					{
						var eventListener:Function = this.createReplaceScreenSignalListener(eventAction as String, signal);
						signal.add(eventListener);
					}
					else
					{
						eventListener = this.createReplaceScreenEventListener(eventAction as String);
						this._activeScreen.addEventListener(eventName, eventListener);
					}
					savedScreenEvents[eventName] = eventListener;
				}
				else
				{
					throw new TypeError("Unknown replace event action defined for screen:", eventAction.toString());
				}
			}
			if(!this._replaceScreenEvents)
			{
				this._replaceScreenEvents = {};
			}
			this._replaceScreenEvents[this._activeScreenID] = savedScreenEvents;
		}

		/**
		 * @private
		 */
		protected function removeReplaceEventsFromActiveScreen(item:StackScreenNavigatorItem):void
		{
			var replaceEvents:Object = item.replaceEvents;
			if(!replaceEvents)
			{
				return;
			}
			var savedScreenEvents:Object = this._replaceScreenEvents[this._activeScreenID];
			for(var eventName:String in replaceEvents)
			{
				var signal:Object = this._activeScreen.hasOwnProperty(eventName) ? (this._activeScreen[eventName] as BaseScreenNavigator.SIGNAL_TYPE) : null;
				var eventAction:Object = replaceEvents[eventName];
				if(eventAction is String)
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
			this._replaceScreenEvents[this._activeScreenID] = null;
		}

		/**
		 * @private
		 */
		protected function addPopEventsToActiveScreen(item:StackScreenNavigatorItem):void
		{
			if(!item.popEvents)
			{
				return;
			}
			//creating a copy because this array could change before the screen
			//is removed.
			var popEvents:Vector.<String> = item.popEvents.slice();
			var eventCount:int = popEvents.length;
			for(var i:int = 0; i < eventCount; i++)
			{
				var eventName:String = popEvents[i];
				var signal:Object = this._activeScreen.hasOwnProperty(eventName) ? (this._activeScreen[eventName] as BaseScreenNavigator.SIGNAL_TYPE) : null;
				if(signal)
				{
					signal.add(popSignalListener);
				}
				else
				{
					this._activeScreen.addEventListener(eventName, popEventListener);
				}
			}
			this._popScreenEvents = popEvents;
		}

		/**
		 * @private
		 */
		protected function removePopEventsFromActiveScreen(item:StackScreenNavigatorItem):void
		{
			if(!this._popScreenEvents)
			{
				return;
			}
			var eventCount:int = this._popScreenEvents.length;
			for(var i:int = 0; i < eventCount; i++)
			{
				var eventName:String = this._popScreenEvents[i];
				var signal:Object = this._activeScreen.hasOwnProperty(eventName) ? (this._activeScreen[eventName] as BaseScreenNavigator.SIGNAL_TYPE) : null;
				if(signal)
				{
					signal.remove(popSignalListener);
				}
				else
				{
					this._activeScreen.removeEventListener(eventName, popEventListener);
				}
			}
			this._popScreenEvents = null;
		}

		/**
		 * @private
		 */
		protected function removePopToRootEventsFromActiveScreen(item:StackScreenNavigatorItem):void
		{
			if(!this._popToRootScreenEvents)
			{
				return;
			}
			var eventCount:int = this._popToRootScreenEvents.length;
			for(var i:int = 0; i < eventCount; i++)
			{
				var eventName:String = this._popToRootScreenEvents[i];
				var signal:Object = this._activeScreen.hasOwnProperty(eventName) ? (this._activeScreen[eventName] as BaseScreenNavigator.SIGNAL_TYPE) : null;
				if(signal)
				{
					signal.remove(popToRootSignalListener);
				}
				else
				{
					this._activeScreen.removeEventListener(eventName, popToRootEventListener);
				}
			}
			this._popToRootScreenEvents = null;
		}

		/**
		 * @private
		 */
		protected function addPopToRootEventsToActiveScreen(item:StackScreenNavigatorItem):void
		{
			if(!item.popToRootEvents)
			{
				return;
			}
			//creating a copy because this array could change before the screen
			//is removed.
			var popToRootEvents:Vector.<String> = item.popToRootEvents.slice();
			var eventCount:int = popToRootEvents.length;
			for(var i:int = 0; i < eventCount; i++)
			{
				var eventName:String = popToRootEvents[i];
				var signal:Object = this._activeScreen.hasOwnProperty(eventName) ? (this._activeScreen[eventName] as BaseScreenNavigator.SIGNAL_TYPE) : null;
				if(signal)
				{
					signal.add(popToRootSignalListener);
				}
				else
				{
					this._activeScreen.addEventListener(eventName, popToRootEventListener);
				}
			}
			this._popToRootScreenEvents = popToRootEvents;
		}

		/**
		 * @private
		 */
		protected function createPushScreenEventListener(screenID:String):Function
		{
			var self:StackScreenNavigator = this;
			var eventListener:Function = function(event:Event, data:Object):void
			{
				self.pushScreen(screenID, data);
			};

			return eventListener;
		}

		/**
		 * @private
		 */
		protected function createPushScreenSignalListener(screenID:String, signal:Object):Function
		{
			var self:StackScreenNavigator = this;
			if(signal.valueClasses.length == 1)
			{
				//shortcut to avoid the allocation of the rest array
				var signalListener:Function = function(arg0:Object):void
				{
					self.pushScreen(screenID, arg0);
				};
			}
			else
			{
				signalListener = function(...rest:Array):void
				{
					var data:Object;
					if(rest.length > 0)
					{
						data = rest[0];
					}
					self.pushScreen(screenID, data);
				};
			}

			return signalListener;
		}

		/**
		 * @private
		 */
		protected function createReplaceScreenEventListener(screenID:String):Function
		{
			var self:StackScreenNavigator = this;
			var eventListener:Function = function(event:Event):void
			{
				self.replaceScreen(screenID);
			};

			return eventListener;
		}

		/**
		 * @private
		 */
		protected function createReplaceScreenSignalListener(screenID:String, signal:Object):Function
		{
			var self:StackScreenNavigator = this;
			if(signal.valueClasses.length == 0)
			{
				//shortcut to avoid the allocation of the rest array
				var signalListener:Function = function():void
				{
					self.replaceScreen(screenID);
				};
			}
			else
			{
				signalListener = function(...rest:Array):void
				{
					self.replaceScreen(screenID);
				};
			}

			return signalListener;
		}

		/**
		 * @private
		 */
		protected function popEventListener(event:Event):void
		{
			this.popScreen();
		}

		/**
		 * @private
		 */
		protected function popSignalListener(...rest:Array):void
		{
			this.popScreen();
		}

		/**
		 * @private
		 */
		protected function popToRootEventListener(event:Event):void
		{
			this.popToRootScreen();
		}

		/**
		 * @private
		 */
		protected function popToRootSignalListener(...rest:Array):void
		{
			this.popToRootScreen();
		}

		/**
		 * @private
		 */
		protected function stackScreenNavigator_initializeHandler(event:Event):void
		{
			if(this._tempRootScreenID !== null)
			{
				var screenID:String = this._tempRootScreenID;
				this._tempRootScreenID = null;
				this.showScreenInternal(screenID, null);
			}
		}
	}
}

final class StackItem
{
	public function StackItem(id:String, properties:Object)
	{
		this.id = id;
		this.properties = properties;
	}

	public var id:String;
	public var properties:Object;
}
