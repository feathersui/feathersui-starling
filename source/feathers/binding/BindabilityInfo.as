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
	import mx.events.PropertyChangeEvent;

	[ExcludeClass]

	/**
	 *  @private
	 *  Bindability information for children (properties or methods)
	 *  of a given class, based on the describeType() structure for that class.
	 */
	public class BindabilityInfo
	{

		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------

		/**
		 *  Name of [Bindable] metadata.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static const BINDABLE:String = "Bindable";

		/**
		 *  Name of [Managed] metadata.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static const MANAGED:String = "Managed";

		/**
		 *  Name of [ChangeEvent] metadata.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static const CHANGE_EVENT:String = "ChangeEvent";

		/**
		 *  Name of [NonCommittingChangeEvent] metadata.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static const NON_COMMITTING_CHANGE_EVENT:String =
			"NonCommittingChangeEvent";

		/**
		 *  Name of describeType() <accessor> element.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static const ACCESSOR:String = "accessor";

		/**
		 *  Name of describeType() <method> element.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static const METHOD:String = "method";

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 *  Constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function BindabilityInfo(typeDescription:XML)
		{
			super();

			this.typeDescription = typeDescription;
		}

		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------

		/**
		 *  @private
		 */
		private var typeDescription:XML;

		/**
		 *  @private
		 *  event name -> true
		 */
		private var classChangeEvents:Object;

		/**
		 *  @private
		 *  child name -> { event name -> true }
		 */
		private var childChangeEvents:Object = {};

		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------

		/**
		 *  Object containing { eventName: true } for each change event
		 *  (class- or child-level) that applies to the specified child.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function getChangeEvents(childName:String):Object
		{
			var changeEvents:Object = childChangeEvents[childName];

			if (!changeEvents)
			{
				// Seed with class-level events.
				changeEvents = copyProps(getClassChangeEvents(), {});

				// Get child-specific events.
				var childDesc:XMLList =
					typeDescription.accessor.(@name == childName) +
					typeDescription.method.(@name == childName);

				var numChildren:int = childDesc.length();

				if (numChildren == 0)
				{
					// we've been asked for events on an unknown property
					if (!typeDescription.@dynamic)
					{
						trace("warning: no describeType entry for '" +
						childName + "' on non-dynamic type '" +
						typeDescription.@name + "'");
					}
				}
				else
				{
					if (numChildren > 1)
					{
						trace("warning: multiple describeType entries for '" +
						childName + "' on type '" + typeDescription.@name +
						"':\n" + childDesc);
					}

					addBindabilityEvents(childDesc.metadata, changeEvents);
				}

				childChangeEvents[childName] = changeEvents;
			}

			return changeEvents;
		}

		/**
		 *  @private
		 *  Build or return cached class change events object.
		 */
		private function getClassChangeEvents():Object
		{
			if (!classChangeEvents)
			{
				classChangeEvents = {};

				addBindabilityEvents(typeDescription.metadata, classChangeEvents);

				// Class-level [Managed] means all properties
				// dispatch propertyChange.
				if (typeDescription.metadata.(@name == MANAGED).length() > 0)
				{
					classChangeEvents[PropertyChangeEvent.PROPERTY_CHANGE] = true;
				}
			}

			return classChangeEvents;
		}

		/**
		 *  @private
		 */
		private function addBindabilityEvents(metadata:XMLList,
			eventListObj:Object):void
		{
			addChangeEvents(metadata.(@name == BINDABLE), eventListObj, true);
			addChangeEvents(metadata.(@name == CHANGE_EVENT), eventListObj, true);
			addChangeEvents(metadata.(@name == NON_COMMITTING_CHANGE_EVENT),
				eventListObj, false);
		}

		/**
		 *  @private
		 *  Transfer change events from a list of change-event-carrying metadata
		 *  to an event list object.
		 *  Note: metadata's first arg value is assumed to be change event name.
		 */
		private function addChangeEvents(metadata:XMLList, eventListObj:Object, isCommit:Boolean):void
		{
			for each (var md:XML in metadata)
			{
				var arg:XMLList = md.arg;
				if (arg.length() > 0)
				{
					var eventName:String = arg[0].@value;
					eventListObj[eventName] = isCommit;
				}
				else
				{
					trace("warning: unconverted Bindable metadata in class '" +
					typeDescription.@name + "'");
				}
			}
		}

		/**
		 *  @private
		 *  Copy properties from one object to another.
		 */
		private function copyProps(from:Object, to:Object):Object
		{
			for (var propName:String in from)
			{
				to[propName] = from[propName];
			}

			return to;
		}
	}
}
