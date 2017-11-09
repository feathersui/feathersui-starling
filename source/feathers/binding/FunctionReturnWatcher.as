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

	import flash.events.IEventDispatcher;

	import mx.core.mx_internal;

	import starling.events.EventDispatcher;

	use namespace mx_internal;

	[ExcludeClass]

	/**
	 *  @private
	 */
	public class FunctionReturnWatcher extends Watcher
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 *  @private
		 *  Constructor.
		 */
		public function FunctionReturnWatcher(functionName:String,
			document:Object,
			parameterFunction:Function,
			events:Object,
			listeners:Array,
			functionGetter:Function = null)
		{
			super(listeners);

			this.functionName = functionName;
			this.document = document;
			this.parameterFunction = parameterFunction;
			this.events = events;
			this.functionGetter = functionGetter;
		}

		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------

		/**
		 *  @private
		 *  The name of the property, used to actually get the property
		 *  and for comparison in propertyChanged events.
		 */
		private var functionName:String;

		/**
		 *  @private
		 *  The document is what we need to use to execute the parameter function.
		 */
		private var document:Object;

		/**
		 *  @private
		 *  The function that will give us the parameters for calling the function.
		 */
		private var parameterFunction:Function;

		/**
		 *  @private
		 *  The events that indicate the property has changed.
		 */
		private var events:Object;

		/**
		 *  @private
		 *  The parent object of this function.
		 */
		private var parentObj:Object;

		/**
		 *  @private
		 *  The watcher holding onto the parent object.
		 */
		public var parentWatcher:Watcher;

		/**
		 *  Storage for the functionGetter property.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		private var functionGetter:Function;

		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------

		/**
		 *  @private
		 */
		override public function updateParent(parent:Object):void
		{
			if (!(parent is Watcher))
				setupParentObj(parent);

			else if (parent == parentWatcher)
				setupParentObj(parentWatcher.value);

			updateFunctionReturn();
		}

		/**
		 *  @private
		 */
		override protected function shallowClone():Watcher
		{
			var clone:FunctionReturnWatcher = new FunctionReturnWatcher(functionName,
				document,
				parameterFunction,
				events,
				listeners,
				functionGetter);

			return clone;
		}

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		/**
		 *  @private
		 *  Get the new return value of the function.
		 */
		public function updateFunctionReturn():void
		{
			wrapUpdate(function():void
			{
				if (functionGetter != null)
				{
					value = functionGetter(functionName).apply(parentObj,
						parameterFunction.apply(document));
				}
				else
				{
					value = parentObj[functionName].apply(parentObj,
						parameterFunction.apply(document));
				}

				updateChildren();
			});
		}

		/**
		 *  @private
		 */
		private function setupParentObj(newParent:Object):void
		{
			var eventName:String;

			// Remove listeners from the old "watched" object.
			if (parentObj != null)
			{
				// events can be null when watching a function marked with
				// [Bindable(style="true")].
				if (events != null)
				{
					for (eventName in events)
					{
						if (eventName != "__NoChangeEvent__")
						{
							if(parentObj is EventDispatcher)
							{
								var starlingEventDispatcher:EventDispatcher = EventDispatcher(parentObj);
								starlingEventDispatcher.removeEventListener(eventName, eventHandler);
							}
							else if(parentObj is IEventDispatcher)
							{
								var staticIEventDispatcher:IEventDispatcher = IEventDispatcher(parentObj);
								staticIEventDispatcher.removeEventListener(eventName, eventHandler);
							}
						}
					}
				}
			}

			parentObj = newParent;

			// Add listeners the new "watched" object.
			if (parentObj != null)
			{
				// events can be null when watching a function marked with
				// [Bindable(style="true")].
				if (events != null)
				{
					for (eventName in events)
					{
						if (eventName != "__NoChangeEvent__")
						{
							if(parentObj is EventDispatcher)
							{
								starlingEventDispatcher = EventDispatcher(parentObj);
								starlingEventDispatcher.addEventListener(eventName, eventHandler);
							}
							else if(parentObj is IEventDispatcher)
							{
								staticIEventDispatcher = IEventDispatcher(parentObj);
								staticIEventDispatcher.addEventListener(eventName, eventHandler,
									false,
									BINDING_EVENT_PRIORITY,
									true);
							}
						}
					}
				}
			}
		}

		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------

		/**
		 *  @private
		 */
		public function eventHandler(event:Object):void
		{
			updateFunctionReturn();

			// events can be null when watching a function marked with
			// [Bindable(style="true")].
			if (events != null)
			{
				var eventType:String = event.type as String;
				notifyListeners(events[eventType]);
			}
		}
	}

}
