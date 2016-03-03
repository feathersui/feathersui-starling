/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

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
	 * var navigator:ScreenNavigator = new ScreenNavigator();
	 * navigator.addScreen( "mainMenu", new ScreenNavigatorItem( MainMenuScreen ) );
	 * this.addChild( navigator );
	 * navigator.showScreen( "mainMenu" );</listing>
	 *
	 * @see ../../../help/screen-navigator.html How to use the Feathers ScreenNavigator component
	 * @see ../../../help/transitions.html Transitions for Feathers screen navigators
	 * @see feathers.controls.ScreenNavigatorItem
	 */
	public class ScreenNavigator extends BaseScreenNavigator
	{
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.AutoSizeMode.STAGE</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const AUTO_SIZE_MODE_STAGE:String = "stage";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.AutoSizeMode.CONTENT</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const AUTO_SIZE_MODE_CONTENT:String = "content";

		/**
		 * The default <code>IStyleProvider</code> for all <code>ScreenNavigator</code>
		 * components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * Constructor.
		 */
		public function ScreenNavigator()
		{
			super();
		}

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return ScreenNavigator.globalStyleProvider;
		}

		/**
		 * @private
		 */
		protected var _transition:Function;

		/**
		 * Typically used to provide some kind of animation or visual effect,
		 * this function is called when a new screen is shown. 
		 *
		 * <p>In the following example, the screen navigator is given a
		 * transition that fades in the new screen on top of the old screen:</p>
		 *
		 * <listing version="3.0">
		 * navigator.transition = Fade.createFadeInTransition();</listing>
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
		 * when the transition effect finishes.This callback indicate to the
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
		 * @see #showScreen()
		 * @see #clearScreen()
		 * @see ../../../help/transitions.html Transitions for Feathers screen navigators
		 */
		public function get transition():Function
		{
			return this._transition;
		}

		/**
		 * @private
		 */
		public function set transition(value:Function):void
		{
			if(this._transition == value)
			{
				return;
			}
			this._transition = value;
		}

		/**
		 * @private
		 */
		protected var _screenEvents:Object = {};

		/**
		 * Registers a new screen with a string identifier that can be used
		 * to reference the screen in other calls, like <code>removeScreen()</code>
		 * or <code>showScreen()</code>.
		 *
		 * @see #removeScreen()
		 */
		public function addScreen(id:String, item:ScreenNavigatorItem):void
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
		public function removeScreen(id:String):ScreenNavigatorItem
		{
			return ScreenNavigatorItem(this.removeScreenInternal(id));
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
		 * Displays a screen and returns a reference to it. If a previous
		 * transition is running, the new screen will be queued, and no
		 * reference will be returned.
		 *
		 * <p>An optional transition may be specified. If <code>null</code> the
		 * <code>transition</code> property will be used instead.</p>
		 *
		 * @see #transition
		 */
		public function showScreen(id:String, transition:Function = null):DisplayObject
		{
			if(transition === null)
			{
				transition = this._transition;
			}
			return this.showScreenInternal(id, transition);
		}

		/**
		 * Removes the current screen, leaving the <code>ScreenNavigator</code>
		 * empty.
		 *
		 * <p>An optional transition may be specified. If <code>null</code> the
		 * <code>transition</code> property will be used instead.</p>
		 *
		 * @see #transition
		 */
		public function clearScreen(transition:Function = null):void
		{
			if(transition == null)
			{
				transition = this._transition;
			}
			this.clearScreenInternal(transition);
			this.dispatchEventWith(FeathersEventType.CLEAR);
		}

		/**
		 * @private
		 */
		override protected function prepareActiveScreen():void
		{
			var item:ScreenNavigatorItem = ScreenNavigatorItem(this._screens[this._activeScreenID]);
			var events:Object = item.events;
			var savedScreenEvents:Object = {};
			for(var eventName:String in events)
			{
				var signal:Object = null;
				if(BaseScreenNavigator.SIGNAL_TYPE !== null &&
					this._activeScreen.hasOwnProperty(eventName))
				{
					signal = this._activeScreen[eventName] as BaseScreenNavigator.SIGNAL_TYPE;
				}
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
						var eventListener:Function = this.createShowScreenSignalListener(eventAction as String, signal);
						signal.add(eventListener);
					}
					else
					{
						eventListener = this.createShowScreenEventListener(eventAction as String);
						this._activeScreen.addEventListener(eventName, eventListener);
					}
					savedScreenEvents[eventName] = eventListener;
				}
				else
				{
					throw new TypeError("Unknown event action defined for screen:", eventAction.toString());
				}
			}
			this._screenEvents[this._activeScreenID] = savedScreenEvents;
		}

		/**
		 * @private
		 */
		override protected function cleanupActiveScreen():void
		{
			var item:ScreenNavigatorItem = ScreenNavigatorItem(this._screens[this._activeScreenID]);
			var events:Object = item.events;
			var savedScreenEvents:Object = this._screenEvents[this._activeScreenID];
			for(var eventName:String in events)
			{
				var signal:Object = null;
				if(BaseScreenNavigator.SIGNAL_TYPE !== null &&
					this._activeScreen.hasOwnProperty(eventName))
				{
					signal = this._activeScreen[eventName] as BaseScreenNavigator.SIGNAL_TYPE;
				}
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
			this._screenEvents[this._activeScreenID] = null;
		}

		/**
		 * @private
		 */
		protected function createShowScreenEventListener(screenID:String):Function
		{
			var self:ScreenNavigator = this;
			var eventListener:Function = function(event:Event):void
			{
				self.showScreen(screenID);
			};

			return eventListener;
		}

		/**
		 * @private
		 */
		protected function createShowScreenSignalListener(screenID:String, signal:Object):Function
		{
			var self:ScreenNavigator = this;
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
	}

}