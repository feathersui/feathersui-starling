/*
Feathers SDK
Copyright 2012-2015 Bowler Hat LLC

See the NOTICE file distributed with this work for additional information
regarding copyright ownership. The author licenses this file to You under the
Apache License, Version 2.0 (the "License"); you may not use this file except in
compliance with the License.  You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied. See the License for the
specific language governing permissions and limitations under the License.
*/
package feathers.binding.utils
{
	import feathers.events.PropertyChangeEventData;

	import flash.events.IEventDispatcher;

	import mx.events.PropertyChangeEvent;

	import starling.events.Event;
	import starling.events.EventDispatcher;

	/**
	 *  The ChangeWatcher class defines utility methods
	 *  that you can use with bindable Flex properties.
	 *  These methods let you define an event handler that is executed
	 *  whenever a bindable property is updated.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public class ChangeWatcher
	{
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------

		/**
		 *  Creates and starts a ChangeWatcher instance.
		 *  A single ChangeWatcher instance can watch one property,
		 *  or a property chain.
		 *  A property chain is a sequence of properties accessible from
		 *  a host object.
		 *  For example, the expression
		 *  <code>obj.a.b.c</code> contains the property chain (a, b, c).
		 *
		 *  @param host The object that hosts the property or property chain
		 *  to be watched.
		 *  You can use the use the <code>reset()</code> method to change
		 *  the value of the <code>host</code> argument after creating
		 *  the ChangeWatcher instance.
		 *  The <code>host</code> maintains a list of <code>handlers</code> to invoke
		 *  when <code>prop</code> changes.
		 *
		 *  @param chain A value specifying the property or chain to be watched.
		 *  Legal values are:
		 *  <ul>
		 *    <li>A String containing the name of a public bindable property
		 *    of the host object.</li>
		 *
		 *    <li>An Object in the form:
		 *    <code>{ name: <i>property name</i>, getter: function(host) { return host[name] } }</code>.
		 *    The Object contains the name of a public bindable property,
		 *    and a function which serves as a getter for that property.</li>
		 *
		 *    <li>A non-empty Array containing any combination
		 *    of the first two options.
		 *    This represents a chain of bindable properties
		 *    accessible from the host.
		 *    For example, to watch the property <code>host.a.b.c</code>,
		 *    call the method as: <code>watch(host, ["a","b","c"], ...)</code>.</li>
		 *  </ul>
		 *
		 *  <p>Note: The property or properties named in the <code>chain</code> argument
		 *  must be public, because the <code>describeType()</code> method suppresses all information
		 *  about non-public properties, including the bindability metadata
		 *  that ChangeWatcher scans to find the change events that are exposed
		 *  for a given property.
		 *  However, the getter function supplied when using the <code>{ name, getter }</code>
		 *  argument form described above can be used to associate an arbitrary
		 *  computed value with the named (public) property.</p>
		 *
		 *  @param handler An event handler function called when the value of the
		 *  watched property (or any property in a watched chain) is modified.
		 *  The modification is signaled when any host object in the watcher
		 *  chain dispatches the event that has been specified in that host object's
		 *  <code>[Bindable]</code> metadata tag for the corresponding watched property.
		 *  The default event is named <code>propertyChange</code>.
		 *
		 *  <p>The event object dispatched by the bindable property is passed
		 *  to this handler function without modification.
		 *  By default, Flex dispatches an event object of type PropertyChangeEvent.
		 *  However, you can define your own event type when you use the
		 *  <code>[Bindable]</code> metadata tag to define a bindable property.</p>
		 *
		 *  @param commitOnly Set to <code>true</code> if the handler should be
		 *  called only on committing change events;
		 *  set to <code>false</code> if the handler should be called on both
		 *  committing and non-committing change events.
		 *  Note: the presence of non-committing change events for a property is
		 *  indicated by the <code>[NonCommittingChangeEvent(&lt;event-name&gt;)]</code> metadata tag.
		 *  Typically these tags are used to indicate fine-grained value changes,
		 *  such as modifications in a text field prior to confirmation.
		 *
		 *  @param useWeakReference (default = false) Determines whether
		 *  the reference to <code>handler</code> is strong or weak. A strong
		 *  reference (the default) prevents <code>handler</code> from being
		 *  garbage-collected. A weak reference does not.
		 *
		 *  @return The ChangeWatcher instance, if at least one property name has
		 *  been specified to the <code>chain</code> argument; null otherwise.
		 *  Note that the returned watcher is not guaranteed to have successfully
		 *  discovered and attached itself to change events, since none may have
		 *  been exposed on the given property or chain by the host.
		 *  You can use the <code>isWatching()</code> method to determine the
		 *  watcher's state.
		 *
		 *  @see mx.events.PropertyChangeEvent
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function watch(host:Object, chain:Object,
			handler:Function,
			commitOnly:Boolean = false,
			useWeakReference:Boolean = false):ChangeWatcher
		{
			if (!(chain is Array))
				chain = [ chain ];

			if (chain.length > 0)
			{
				var w:ChangeWatcher =
					new ChangeWatcher(chain[0], handler, commitOnly,
						watch(null, chain.slice(1), handler, commitOnly));
				w.useWeakReference = useWeakReference;
				w.reset(host);
				return w;
			}
			else
			{
				return null;
			}
		}

		/**
		 *  Lets you determine if the host exposes a data-binding event
		 *  on the property.
		 *
		 *  <p>NOTE: Property chains are not supported by the <code>canWatch()</code> method.
		 * They are supported by the <code>watch()</code> method.</p>
		 *
		 *  @param host The host of the property.
		 *  See the <code>watch()</code> method for more information.
		 *
		 *  @param name The name of the property.
		 *  See the <code>watch()</code> method for more information.
		 *
		 *  @param commitOnly Set to <code>true</code> if the handler
		 *  should be called only on committing change events.
		 *  See the <code>watch()</code> method for more information.
		 *
		 *  @return <code>true</code> if <code>host</code> exposes
		 *  any change events on <code>name</code>.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function canWatch(host:Object, name:String,
			commitOnly:Boolean = false):Boolean
		{
			return !isEmpty(getEvents(host, name, commitOnly));
		}

		/**
		 *  Returns all binding events for a bindable property in the host object.
		 *
		 *  @param host The host of the property.
		 *  See the <code>watch()</code> method for more information.
		 *
		 *  @param name The name of the property, or property chain.
		 *  See the <code>watch()</code> method for more information.
		 *
		 *  @param commitOnly Controls inclusion of non-committing
		 *  change events in the returned value.
		 *
		 *  @return Object of the form <code>{ eventName: isCommitting, ... }</code>
		 *  containing all change events for the property.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function getEvents(host:Object, name:String,
			commitOnly:Boolean = false):Object
		{
			if (host is EventDispatcher || host is IEventDispatcher)
			{
				// Get { eventName: isCommitting, ... } for all change events
				// defined by host's class on prop <name>
				var allEvents:Object = DescribeTypeCache.describeType(host).
					bindabilityInfo.getChangeEvents(name);
				if (commitOnly)
				{
					// Filter out non-committing events.
					var commitOnlyEvents:Object = {};
					for (var ename:String in allEvents)
						if (allEvents[ename])
							commitOnlyEvents[ename] = true;
					return commitOnlyEvents;
				}
				else
				{
					return allEvents;
				}
			}
			else
			{
				// If host is not a Starling EventDispatcher or a native
				// IEventDispatcher, no events will be dispatched, regardless of
				// metadata.
				// User-supplied [Bindable("eventname")] metadata within a
				// non-IEventDispatcher class is unlikely,
				// but not specifically prohibited by the compiler currently.
				return {};
			}
		}

		/**
		 *  Lets you determine if an Object has any properties.
		 *
		 *  @param Object to inspect.
		 *
		 *  @return <code>true</code> if Object has no properties.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		private static function isEmpty(obj:Object):Boolean
		{
			for (var p:String in obj)
			{
				return false;
			}
			return true;
		}

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 *  Constructor.
		 *  Not for public use. This method is called only from the <code>watch()</code> method.
		 *  See the <code>watch()</code> method for parameter usage.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function ChangeWatcher(access:Object, handler:Function,
			commitOnly:Boolean = false,
			next:ChangeWatcher = null)
		{
			super();

			host = null;
			name = access is String ? access as String : access.name;
			getter = access is String ? null : access.getter;
			this.handler = handler;
			this.commitOnly = commitOnly;
			this.next = next;
			events = {};
			useWeakReference = false;
			isExecuting = false;
		}

		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------

		/**
		 *  Host object.
		 *  Volatile; may be reset, and will fluctuate in non-root watchers
		 *  due to property value changes.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		private var host:Object;

		/**
		 *  Name of watched property.
		 *  Nonvolatile.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		private var name:String;

		/**
		 *  Optional user-supplied getter function.
		 *  Nonvolatile.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		private var getter:Function;

		/**
		 *  User-supplied event handler function.
		 *  Nonvolatile.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		private var handler:Function;

		/**
		 *  True iff watching only committing events.
		 *  Nonvolatile.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		private var commitOnly:Boolean;

		/**
		 *  If watching a chain, this is a watcher on the next property
		 *  in the chain: next.host == host[name].
		 *  Null otherwise. Nonvolatile.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		private var next:ChangeWatcher;

		/**
		 *  Object { <event-name>: <is-committing>, ... } for current host[name].
		 *  Volatile; varies with host.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		private var events:Object;

		/**
		 * True while handling a change event.  Used to prevent two way
		 * bindings from getting into an infinite loop.
		 */
		private var isExecuting:Boolean;

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		//----------------------------------
		//  useWeakReference
		//----------------------------------

		/**
		 *  Determines whether the reference to <code>handler</code>
		 *  is strong or weak.
		 *  A strong reference (the default) prevents
		 *  <code>handler</code> from being garbage-collected.
		 *  A weak reference does not.
		 *
		 *  @default false
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public var useWeakReference:Boolean;

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		/**
		 *  Detaches this ChangeWatcher instance, and its handler function,
		 *  from the current host.
		 *  You can use the <code>reset()</code> method to reattach
		 *  the ChangeWatcher instance, or watch the same property
		 *  or chain on a different host object.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function unwatch():void
		{
			reset(null);
		}

		/**
		 *  Retrieves the current value of the watched property or property chain,
		 *  or null if the host object is null.
		 *  For example:
		 *  <pre>
		 *  watch(obj, ["a","b","c"], ...).getValue() === obj.a.b.c
		 *  </pre>
		 *
		 *  @return The current value of the watched property or property chain.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function getValue():Object
		{
			return host == null ?
				null :
				next == null ?
					getHostPropertyValue() :
					next.getValue();
		}

		/**
		 *  Sets the handler function.
		 *
		 *  @param handler The handler function. This argument must not be null.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function setHandler(handler:Function):void
		{
			this.handler = handler;
			if (next)
				next.setHandler(handler);
		}

		/**
		 *  Returns <code>true</code> if each watcher in the chain is attached
		 *  to at least one change event.
		 *  Note that the <code>isWatching()</code> method
		 *  varies with host, since different hosts may expose different change
		 *  events for the watcher's chosen property.
		 *
		 *  @return <code>true</code> if each watcher in the chain is attached
		 *  to at least one change event.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function isWatching():Boolean
		{
			return !isEmpty(events) && (next == null || next.isWatching());
		}

		/**
		 *  Resets this ChangeWatcher instance to use a new host object.
		 *  You can call this method to reuse a watcher instance
		 *  on a different host.
		 *
		 *  @param newHost The new host of the property.
		 *  See the <code>watch()</code> method for more information.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function reset(newHost:Object):void
		{
			var p:String;

			if (host != null)
			{
				for (p in events)
				{
					if (host is EventDispatcher)
					{
						EventDispatcher(host).removeEventListener(p, wrapHandler);
					}
					else if (host is IEventDispatcher)
					{
						IEventDispatcher(host).removeEventListener(p, wrapHandler);
					}

				}
				events = {};
			}

			host = newHost;

			if (host != null)
			{
				events = getEvents(host, name, commitOnly);
				for (p in events)
				{
					if (host is EventDispatcher)
					{
						EventDispatcher(host).addEventListener(p, wrapHandler);
					}
					else if (host is IEventDispatcher)
					{
						IEventDispatcher(host).addEventListener(p, wrapHandler,
							false, BINDING_EVENT_PRIORITY, useWeakReference);
					}
				}
			}

			if (next)
				next.reset(getHostPropertyValue());
		}

		/**
		 *  @private
		 *  Retrieves the current value of the root watched property,
		 *  or null if host is null.
		 *  I.e. watch(obj, ["a","b","c"], ...).getHostPropertyValue() === obj.a
		 */
		private function getHostPropertyValue():Object
		{
			return host == null ? null : getter != null ? getter(host) : host[name];
		}

		/**
		 *  @private
		 *  Listener for change events.
		 *  Resets chained watchers and calls user-supplied handler.
		 */
		private function wrapHandler(event:Object):void
		{
			if (!isExecuting)
			{
				try
				{
					isExecuting = true;

					if (next)
						next.reset(getHostPropertyValue());

					if (event is Event && event.data is PropertyChangeEventData)
					{
						if (PropertyChangeEventData(event.data).property == name)
							handler(event as Event);
					}
					else if (event is PropertyChangeEvent)
					{
						if (PropertyChangeEvent(event).property == name)
							handler(event as PropertyChangeEvent);
					}
					else
					{
						handler(event);
					}
				}
				finally
				{
					isExecuting = false;
				}
			}
		}

	}

}
