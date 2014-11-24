/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.controls.supportClasses.IScreenNavigatorItem;

	import starling.display.DisplayObject;

	public class StackScreenNavigatorItem implements IScreenNavigatorItem
	{
		/**
		 * Constructor.
		 *
		 * @param screen The screen to display. Must be a <code>Class</code>, <code>Function</code>, or Starling display object.
		 * @param pushEvents The screen navigator push a new screen when these events are dispatched.
		 * @param popEvent An event that pops the screen from the top of the stack.
		 * @param properties A set of key-value pairs to pass to the screen when it is shown.
		 */
		public function StackScreenNavigatorItem(screen:Object, pushEvents:Object = null, popEvent:String = null, properties:Object = null)
		{
			this._screen = screen;
			this._pushEvents = pushEvents ? pushEvents : {};
			if(popEvent)
			{
				this.addPopEvent(popEvent);
			}
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
		 * <code>ScreenNavigator</code> When the screen is shown again, its
		 * state will remain the same as when it was previously hidden. However,
		 * the screen will be kept in memory even when it isn't visible,
		 * limiting the resources available for other screens.</p>
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
		protected var _pushEvents:Object;

		/**
		 * A set of key-value pairs representing actions that should be
		 * triggered when events are dispatched by the screen when it is shown.
		 * A pair's key is the event type to listen for (or the property name of
		 * an <code>ISignal</code> instance), and a pair's value is one of two
		 * possible types. When this event is dispatched, and a pair's value
		 * is a <code>String</code>, the <code>StackScreenNavigator</code> will
		 * show another screen with an ID equal to the string value. When this
		 * event is dispatched, and the pair's value is a <code>Function</code>,
		 * the function will be called as if it were a listener for the event.
		 *
		 * @see #setFunctionForPushEvent()
		 * @see #setScreenIDForPushEvent()
		 */
		public function get pushEvents():Object
		{
			return this._pushEvents;
		}

		/**
		 * @private
		 */
		public function set pushEvents(value:Object):void
		{
			if(!value)
			{
				value = {};
			}
			this._pushEvents = value;
		}

		/**
		 * @private
		 */
		protected var _popEvents:Vector.<String>;

		/**
		 * A list of events that will cause the screen navigator to pop this
		 * screen off the top of the stack.
		 *
		 * @see #addPopEvent()
		 * @see #removePopEvent()
		 */
		public function get popEvents():Vector.<String>
		{
			return this._popEvents;
		}

		/**
		 * @private
		 */
		public function set popEvents(value:Vector.<String>):void
		{
			if(!value)
			{
				value = new <String>[];
			}
			this._popEvents = value;
		}

		/**
		 * @private
		 */
		protected var _popToRootEvents:Vector.<String>;

		/**
		 * A list of events that will cause the screen navigator to clear its
		 * stack and show the first screen added to the stack.
		 *
		 * @see #addPopToRootEvent()
		 * @see #removePopToRootEvent()
		 */
		public function get popToRootEvents():Vector.<String>
		{
			return this._popToRootEvents;
		}

		/**
		 * @private
		 */
		public function set popToRootEvents(value:Vector.<String>):void
		{
			this._popToRootEvents = value;
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
		 * Specifies a function to call when an event is dispatched by the
		 * screen.
		 *
		 * <p>If the screen is currently being displayed by a
		 * <code>StackScreenNavigator</code>, and you call
		 * <code>setFunctionForPushEvent()</code> on the <code>StackScreenNavigatorItem</code>,
		 * the <code>StackScreenNavigator</code> won't listen for the event
		 * until the next time that the screen is shown.</p>
		 *
		 * @see #setScreenIDForPushEvent()
		 * @see #clearEvent()
		 * @see #events
		 */
		public function setFunctionForPushEvent(eventType:String, action:Function):void
		{
			this._pushEvents[eventType] = action;
		}

		/**
		 * Specifies another screen to push on the stack when an event is
		 * dispatched by this screen. The other screen should be specified by
		 * its ID that was registered with a call to <code>addScreen()</code> on
		 * the <code>StackScreenNavigator</code>.
		 *
		 * <p>If the screen is currently being displayed by a
		 * <code>StackScreenNavigator</code>, and you call
		 * <code>setScreenIDForPushEvent()</code> on the <code>StackScreenNavigatorItem</code>,
		 * the <code>StackScreenNavigator</code> won't listen for the event
		 * until the next time that the screen is shown.</p>
		 *
		 * @see #setFunctionForPushEvent()
		 * @see #clearPushEvent()
		 * @see #pushEvents
		 */
		public function setScreenIDForPushEvent(eventType:String, screenID:String):void
		{
			this._pushEvents[eventType] = screenID;
		}

		/**
		 * Cancels the action previously registered to be triggered when the
		 * screen dispatches an event.
		 *
		 * @see #pushEvents
		 */
		public function clearPushEvent(eventType:String):void
		{
			delete this._pushEvents[eventType];
		}

		/**
		 * Specifies an event dispatched by the screen that will cause the
		 * <code>StackScreenNavigator</code> to pop the screen off the top of
		 * the stack and return to the previous screen.
		 *
		 * <p>If the screen is currently being displayed by a
		 * <code>StackScreenNavigator</code>, and you call
		 * <code>addPopEvent()</code> on the <code>StackScreenNavigatorItem</code>,
		 * the <code>StackScreenNavigator</code> won't listen for the event
		 * until the next time that the screen is shown.</p>
		 *
		 * @see #removePopEvent()
		 * @see #popEvents
		 */
		public function addPopEvent(eventType:String):void
		{
			if(!this._popEvents)
			{
				this._popEvents = new <String>[];
			}
			var index:int = this._popEvents.indexOf(eventType);
			if(index >= 0)
			{
				return;
			}
			this._popEvents[this._popEvents.length] = eventType;
		}

		/**
		 * Removes an event that would cause the <code>StackScreenNavigator</code>
		 * to remove this screen from the top of the stack.
		 *
		 * <p>If the screen is currently being displayed by a
		 * <code>StackScreenNavigator</code>, and you call
		 * <code>removePopEvent()</code> on the <code>StackScreenNavigatorItem</code>,
		 * the <code>StackScreenNavigator</code> won't remove the listener for
		 * the event on the currently displayed screen. The event listener won't
		 * be added the next time that the screen is shown.</p>
		 *
		 * @see #addPopEvent()
		 * @see #popEvents
		 */
		public function removePopEvent(eventType:String):void
		{
			if(!this._popEvents)
			{
				return;
			}
			var index:int = this._popEvents.indexOf(eventType);
			if(index >= 0)
			{
				return;
			}
			this._popEvents.splice(index, 1);
		}

		/**
		 * Specifies an event dispatched by the screen that will cause the
		 * <code>StackScreenNavigator</code> to pop the screen off the top of
		 * the stack and return to the previous screen.
		 *
		 * <p>If the screen is currently being displayed by a
		 * <code>StackScreenNavigator</code>, and you call
		 * <code>addPopToRootEvent()</code> on the <code>StackScreenNavigatorItem</code>,
		 * the <code>StackScreenNavigator</code> won't listen for the event
		 * until the next time that the screen is shown.</p>
		 *
		 * @see #removePopToRootEvent()
		 * @see #popToRootEvents
		 */
		public function addPopToRootEvent(eventType:String):void
		{
			if(!this._popToRootEvents)
			{
				this._popToRootEvents = new <String>[];
			}
			var index:int = this._popToRootEvents.indexOf(eventType);
			if(index >= 0)
			{
				return;
			}
			this._popToRootEvents[this._popToRootEvents.length] = eventType;
		}

		/**
		 * Removes an event that would have cause the <code>StackScreenNavigator</code>
		 * to clear its stack to show the first screen added to the stack.
		 *
		 * <p>If the screen is currently being displayed by a
		 * <code>StackScreenNavigator</code>, and you call
		 * <code>removePopEvent()</code> on the <code>StackScreenNavigatorItem</code>,
		 * the <code>StackScreenNavigator</code> won't remove the listener for
		 * the event on the currently displayed screen. The event listener won't
		 * be added the next time that the screen is shown.</p>
		 *
		 * @see #addPopToRootEvent()
		 * @see #popToRootEvents
		 */
		public function removePopToRootEvent(eventType:String):void
		{
			if(!this._popToRootEvents)
			{
				return;
			}
			var index:int = this._popToRootEvents.indexOf(eventType);
			if(index >= 0)
			{
				return;
			}
			this._popToRootEvents.splice(index, 1);
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
