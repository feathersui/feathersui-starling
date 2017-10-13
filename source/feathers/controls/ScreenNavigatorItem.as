/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.controls.supportClasses.IScreenNavigatorItem;

	import starling.display.DisplayObject;

	/**
	 * Data for an individual screen that will be displayed by a
	 * <code>ScreenNavigator</code> component.
	 *
	 * <p>The following example creates a new <code>ScreenNavigatorItem</code>
	 * using the <code>SettingsScreen</code> class to instantiate the screen
	 * instance. When the screen is shown, its <code>settings</code> property
	 * will be set. When the screen instance dispatches
	 * <code>Event.COMPLETE</code>, the <code>ScreenNavigator</code> will
	 * navigate to a screen with the ID <code>"mainMenu"</code>.</p>
	 *
	 * <listing version="3.0">
	 * var settingsData:Object = { volume: 0.8, difficulty: "hard" };
	 * var item:ScreenNavigatorItem = new ScreenNavigatorItem( SettingsScreen );
	 * item.properties.settings = settingsData;
	 * item.setScreenIDForEvent( Event.COMPLETE, "mainMenu" );
	 * navigator.addScreen( "settings", item );</listing>
	 *
	 * @see ../../../help/screen-navigator.html How to use the Feathers ScreenNavigator component
	 * @see feathers.controls.ScreenNavigator
	 *
	 * @productversion Feathers 1.0.0
	 */
	public class ScreenNavigatorItem implements IScreenNavigatorItem
	{
		/**
		 * Constructor.
		 */
		public function ScreenNavigatorItem(screen:Object = null, events:Object = null, properties:Object = null)
		{
			this._screen = screen;
			this._events = events ? events : {};
			this._properties = properties ? properties : {};
		}

		/**
		 * @private
		 */
		protected var _screen:Object;
		
		/**
		 * The screen to be displayed by the <code>ScreenNavigator</code>. It
		 * may be one of several possible types:
		 *
		 * <ul>
		 *     <li>a <code>Class</code> that may be instantiated to create a <code>DisplayObject</code></li>
		 *     <li>a <code>Function</code> that returns a <code>DisplayObject</code></li>
		 *     <li>a Starling <code>DisplayObject</code> that is already instantiated</li>
		 * </ul>
		 *
		 * <p>If the screen is a <code>Class</code> or a <code>Function</code>,
		 * a new instance of the screen will be instantiated every time that it
		 * is shown by the <code>ScreenNavigator</code>. The screen's state
		 * will not be saved automatically. The screen's state may be saved in
		 * <code>properties</code>, if needed.</p>
		 *
		 * <p>If the screen is a <code>DisplayObject</code>, the same instance
		 * will be reused every time that it is shown by the
		 * <code>ScreenNavigator</code>. When the screen is shown again, its
		 * state will remain the same as when it was previously hidden. However,
		 * the screen will also be kept in memory even when it isn't visible,
		 * limiting the resources that are available for other screens.</p>
		 *
		 * @default null
		 */
		public function get screen():Object
		{
			return this._screen;
		}

		/**
		 * @private
		 */
		public function set screen(value:Object):void
		{
			this._screen = value;
		}

		/**
		 * @private
		 */
		protected var _events:Object;
		
		/**
		 * A set of key-value pairs representing actions that should be
		 * triggered when events are dispatched by the screen when it is shown.
		 * A pair's key is the event type to listen for (or the property name of
		 * an <code>ISignal</code> instance), and a pair's value is one of two
		 * possible types. When this event is dispatched, and a pair's value
		 * is a <code>String</code>, the <code>ScreenNavigator</code> will show
		 * another screen with an ID equal to the string value. When this event
		 * is dispatched, and the pair's value is a <code>Function</code>, the
		 * function will be called as if it were a listener for the event.
		 *
		 * @see #setFunctionForEvent()
		 * @see #setScreenIDForEvent()
		 */
		public function get events():Object
		{
			return this._events;
		}

		/**
		 * @private
		 */
		public function set events(value:Object):void
		{
			if(!value)
			{
				value = {};
			}
			this._events = value;
		}

		/**
		 * @private
		 */
		protected var _properties:Object;
		
		/**
		 * A set of key-value pairs representing properties to be set on the
		 * screen when it is shown. A pair's key is the name of the screen's
		 * property, and a pair's value is the value to be passed to the
		 * screen's property.
		 */
		public function get properties():Object
		{
			return this._properties;
		}

		/**
		 * @private
		 */
		public function set properties(value:Object):void
		{
			if(!value)
			{
				value = {};
			}
			this._properties = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get canDispose():Boolean
		{
			return !(this._screen is DisplayObject);
		}

		/**
		 * @private
		 */
		protected var _transitionDelayEvent:String = null;

		/**
		 * @inheritDoc
		 */
		public function get transitionDelayEvent():String
		{
			return this._transitionDelayEvent;
		}

		/**
		 * @private
		 */
		public function set transitionDelayEvent(value:String):void
		{
			this._transitionDelayEvent = value;
		}

		/**
		 * Specifies a function to call when an event is dispatched by the
		 * screen.
		 *
		 * <p>If the screen is currently being displayed by a
		 * <code>ScreenNavigator</code>, and you call
		 * <code>setFunctionForEvent()</code> on the <code>ScreenNavigatorItem</code>,
		 * the <code>ScreenNavigator</code> won't listen for the event until
		 * the next time that the screen is shown.</p>
		 *
		 * @see #setScreenIDForEvent()
		 * @see #clearEvent()
		 * @see #events
		 */
		public function setFunctionForEvent(eventType:String, action:Function):void
		{
			this._events[eventType] = action;
		}

		/**
		 * Specifies another screen to navigate to when an event is dispatched
		 * by this screen. The other screen should be specified by its ID that
		 * is registered with the <code>ScreenNavigator</code>.
		 *
		 * <p>If the screen is currently being displayed by a
		 * <code>ScreenNavigator</code>, and you call
		 * <code>setScreenIDForEvent()</code> on the <code>ScreenNavigatorItem</code>,
		 * the <code>ScreenNavigator</code> won't listen for the event until the
		 * next time that the screen is shown.</p>
		 *
		 * @see #setFunctionForEvent()
		 * @see #clearEvent()
		 * @see #events
		 */
		public function setScreenIDForEvent(eventType:String, screenID:String):void
		{
			this._events[eventType] = screenID;
		}

		/**
		 * Cancels the action previously registered to be triggered when the
		 * screen dispatches an event.
		 *
		 * @see #events
		 */
		public function clearEvent(eventType:String):void
		{
			delete this._events[eventType];
		}
		
		/**
		 * @inheritDoc
		 */
		public function getScreen():DisplayObject
		{
			var screenInstance:DisplayObject;
			if(this._screen is Class)
			{
				var ScreenType:Class = Class(this._screen);
				screenInstance = new ScreenType();
			}
			else if(this._screen is Function)
			{
				screenInstance = DisplayObject((this._screen as Function)());
			}
			else
			{
				screenInstance = DisplayObject(this._screen);
			}
			if(!(screenInstance is DisplayObject))
			{
				throw new ArgumentError("ScreenNavigatorItem \"getScreen()\" must return a Starling display object.");
			}
			
			if(this._properties)
			{
				for(var propertyName:String in this._properties)
				{
					screenInstance[propertyName] = this._properties[propertyName];
				}
			}
			
			return screenInstance;
		}
	}
}