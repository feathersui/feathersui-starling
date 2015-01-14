/*
Feathers
Copyright 2012-2015 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.controls.supportClasses.BaseScreenNavigator;
	import feathers.controls.supportClasses.IScreenNavigatorItem;
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
	 * navigator.addScreen( "mainMenu", new StackScreenNavigatorItem( MainMenuScreen );
	 * this.addChild( navigator );
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
		 * A function that is called when the screen navigator pushes a new
		 * screen a new screen onto the stack. Typically used to provide some
		 * kind of animation.
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
		 * A function that is called when the screen navigator pops a screen
		 * from the top of the stack. Typically used to provide some kind of
		 * animation.
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
		 * A function that is called when the screen navigator clears its stack,
		 * to show the first screen that was pushed onto the stack.
		 * Typically used to provide some kind of animation.
		 *
		 * <p>If this property is <code>null</code>, the value of the
		 * <code>popTransition</code> property will be used instead.</p>
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
		protected var _popScreenEvents:Vector.<String>;

		/**
		 * @private
		 */
		protected var _popToRootScreenEvents:Vector.<String>;

		/**
		 * Sets the first screen at the bottom of the stack, or the root screen.
		 * When this screen is shown, there will be no transition.
		 *
		 * <p>If the stack contains screens when you set this property, they
		 * will be removed from the stack. In other words, setting this property
		 * will clear the stack, erasing the current history.</p>
		 *
		 * @see #popToRootScreen()
		 */
		public function get rootScreenID():String
		{
			if(this._stack.length == 0)
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
			this._stack.length = 0;
			if(value !== null)
			{
				this.showScreenInternal(value, null);
			}
			else
			{
				this.clearScreenInternal(null);
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
		 * Displays a screen and returns a reference to it. If a previous
		 * transition is running, the new screen will be queued, and no
		 * reference will be returned.
		 *
		 * <p>A set of key-value pairs representing properties on the previous
		 * screen may be passed in. If the new screen is popped, these values
		 * may be used to restore the previous screen's state.</p>
		 *
		 * <p>An optional transition may be specified. If <code>null</code> the
		 * <code>pushTransition</code> property will be used instead.</p>
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
		 * Removes the current screen, leaving the <code>ScreenNavigator</code>
		 * empty.
		 *
		 * <p>An optional transition may be specified. If <code>null</code> the
		 * <code>popTransition</code> property will be used instead.</p>
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
		 * Removes the current screen, leaving the <code>ScreenNavigator</code>
		 * empty.
		 *
		 * <p>An optional transition may be specified. If <code>null</code> the
		 * <code>popToRootTransition</code> or <code>popTransition</code>
		 * property will be used instead.</p>
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
		 * @private
		 */
		override protected function prepareActiveScreen():void
		{
			var item:StackScreenNavigatorItem = StackScreenNavigatorItem(this._screens[this._activeScreenID]);
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
					throw new TypeError("Unknown event action defined for screen:", eventAction.toString());
				}
			}
			this._pushScreenEvents[this._activeScreenID] = savedScreenEvents;
			if(item.popEvents)
			{
				//creating a copy because this array could change before the screen
				//is removed.
				var popEvents:Vector.<String> = item.popEvents.slice();
				var eventCount:int = popEvents.length;
				for(var i:int = 0; i < eventCount; i++)
				{
					eventName = popEvents[i];
					signal = this._activeScreen.hasOwnProperty(eventName) ? (this._activeScreen[eventName] as BaseScreenNavigator.SIGNAL_TYPE) : null;
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
			if(item.popToRootEvents)
			{
				//creating a copy because this array could change before the screen
				//is removed.
				var popToRootEvents:Vector.<String> = item.popToRootEvents.slice();
				eventCount = popToRootEvents.length;
				for(i = 0; i < eventCount; i++)
				{
					eventName = popToRootEvents[i];
					signal = this._activeScreen.hasOwnProperty(eventName) ? (this._activeScreen[eventName] as BaseScreenNavigator.SIGNAL_TYPE) : null;
					if(signal)
					{
						signal.add(popToRootSignalListener);
					}
					else
					{
						this._activeScreen.addEventListener(eventName, popToRootEventListener);
					}
				}
				this._popToRootScreenEvents = popEvents;
			}
		}

		/**
		 * @private
		 */
		override protected function cleanupActiveScreen():void
		{
			var item:StackScreenNavigatorItem = StackScreenNavigatorItem(this._screens[this._activeScreenID]);
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
			if(this._popScreenEvents)
			{
				var eventCount:int = this._popScreenEvents.length;
				for(var i:int = 0; i < eventCount; i++)
				{
					eventName = this._popScreenEvents[i];
					signal = this._activeScreen.hasOwnProperty(eventName) ? (this._activeScreen[eventName] as BaseScreenNavigator.SIGNAL_TYPE) : null;
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
			if(this._popToRootScreenEvents)
			{
				eventCount = this._popToRootScreenEvents.length;
				for(i = 0; i < eventCount; i++)
				{
					eventName = this._popToRootScreenEvents[i];
					signal = this._activeScreen.hasOwnProperty(eventName) ? (this._activeScreen[eventName] as BaseScreenNavigator.SIGNAL_TYPE) : null;
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
