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
package feathers.binding
{
	import feathers.binding.utils.BINDING_EVENT_PRIORITY;
	import feathers.events.PropertyChangeEventData;

	import flash.events.IEventDispatcher;

	import mx.events.PropertyChangeEvent;

	import starling.events.Event;
	import starling.events.EventDispatcher;

	[ExcludeClass]

	/**
	 *  @private
	 */
	public class StaticPropertyWatcher extends Watcher
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 *  Create a StaticPropertyWatcher
		 *
		 *  @param prop The name of the static property to watch.
		 *  @param event The event type that indicates the static property has changed.
		 *  @param listeners The binding objects that are listening to this Watcher.
		 *  @param propertyGetter A helper function used to access non-public variables.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function StaticPropertyWatcher(propertyName:String,
			events:Object,
			listeners:Array,
			propertyGetter:Function = null)
		{
			super(listeners);

			_propertyName = propertyName;
			this.events = events;
			this.propertyGetter = propertyGetter;
		}

		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------

		/**
		 *  The parent class of this static property.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		private var parentObj:Class;

		/**
		 *  The events that indicate the static property has changed
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		protected var events:Object;

		/**
		 *  Storage for the propertyGetter property.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		private var propertyGetter:Function;

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		//----------------------------------
		//  propertyName
		//----------------------------------

		/**
		 *  Storage for the propertyName property.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		private var _propertyName:String;

		/**
		 *  The name of the property this Watcher is watching.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get propertyName():String
		{
			return _propertyName;
		}

		//--------------------------------------------------------------------------
		//
		//  Overridden methods: Watcher
		//
		//--------------------------------------------------------------------------

		/**
		 *  If the parent has changed we need to update ourselves
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		override public function updateParent(parent:Object):void
		{
			// The assumption is that parent is of type, Class, and that
			// the class has a static variable or property,
			// staticEventDispatcher, of type IEventDispatcher.
			parentObj = Class(parent);

			var staticEventDispatcher:Object = parentObj["staticEventDispatcher"];
			if (staticEventDispatcher != null)
			{
				for (var eventType:String in events)
				{
					if (eventType != "__NoChangeEvent__")
					{
						if(staticEventDispatcher is EventDispatcher)
						{
							var staticStarlingEventDispatcher:EventDispatcher = EventDispatcher(parentObj["staticEventDispatcher"]);
							staticStarlingEventDispatcher.addEventListener(eventType, eventHandler);
						}
						else if(staticEventDispatcher is IEventDispatcher)
						{
							var staticIEventDispatcher:IEventDispatcher = IEventDispatcher(parentObj["staticEventDispatcher"]);
							staticIEventDispatcher.addEventListener(eventType, eventHandler, false,
								BINDING_EVENT_PRIORITY, true);
						}
					}
				}
			}

			// Now get our property.
			wrapUpdate(updateProperty);
		}

		/**
		 *  @private
		 */
		override protected function shallowClone():Watcher
		{
			var clone:StaticPropertyWatcher = new StaticPropertyWatcher(_propertyName,
				events,
				listeners,
				propertyGetter);

			return clone;
		}

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		/**
		 *  @private
		 */
		private function traceInfo():String
		{
			return ("StaticPropertyWatcher(" + parentObj + "." + _propertyName +
			"): events = [" + eventNamesToString() + "]");
		}

		/**
		 *  @private
		 */
		private function eventNamesToString():String
		{
			var s:String = " ";

			for (var ev:String in events)
			{
				s += ev + " ";
			}

			return s;
		}

		/**
		 *  Gets the actual property then updates
		 *  the Watcher's children appropriately.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		private function updateProperty():void
		{
			if (parentObj)
			{
				if (propertyGetter != null)
				{
					value = propertyGetter.apply(parentObj, [ _propertyName ]);
				}
				else
				{
					value = parentObj[_propertyName];
				}
			}
			else
			{
				value = null;
			}

			updateChildren();
		}

		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------

		/**
		 *  The generic event handler.
		 *  The only event we'll hear indicates that the property has changed.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function eventHandler(event:Object):void
		{
			if (event is Event && event.data is PropertyChangeEventData)
			{
				var starlingEvent:Event = Event(event);
				var propName:Object = PropertyChangeEventData(starlingEvent.data).property;
				if (propName != _propertyName)
				{
					return;
				}
			}
			else if (event is PropertyChangeEvent)
			{
				propName = PropertyChangeEvent(event).property;

				if (propName != _propertyName)
					return;
			}

			wrapUpdate(updateProperty);

			var eventType:String = event.type as String;
			notifyListeners(events[eventType]);
		}
	}

}
