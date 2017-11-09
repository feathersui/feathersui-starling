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
	import flash.utils.Dictionary;

	import mx.core.mx_internal;

	use namespace mx_internal;

	[ExcludeClass]

	/**
	 *  @private
	 */
	public class Binding
	{

		// Certain errors are normal during binding execution, so we swallow them.
		// 1507 - invalid null argument 
		// 2005 - argument error (null gets converted to 0) 
		mx_internal static var allowedErrors:Object = generateAllowedErrors();
		mx_internal static function generateAllowedErrors():Object
		{
			var o:Object = {};
			o[1507] = 1;
			o[2005] = 1;
			return o;
		}

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 *  Create a Binding object
		 *
		 *  @param document The document that is the target of all of this work.
		 *
		 *  @param srcFunc The function that returns us the value
		 *  to use in this Binding.
		 *
		 *  @param destFunc The function that will take a value
		 *  and assign it to the destination.
		 *
		 *  @param destString The destination represented as a String.
		 *  We can then tell the ValidationManager to validate this field.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function Binding(document:Object, srcFunc:Function,
			destFunc:Function, destString:String,
			srcString:String = null)
		{
			super();

			this.document = document;
			this.srcFunc = srcFunc;
			this.destFunc = destFunc;
			this.destString = destString;
			this.srcString = srcString;
			this.destFuncFailed = false;

			if (this.srcFunc == null)
			{
				this.srcFunc = defaultSrcFunc;
			}

			if (this.destFunc == null)
			{
				this.destFunc = defaultDestFunc;
			}

			_isEnabled = true;
			isExecuting = false;
			isHandlingEvent = false;
			hasHadValue = false;
			uiComponentWatcher = -1;

			BindingManager.addBinding(document, destString, this);
		}

		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------

		/**
		 *  @private
		 *  Internal storage for isEnabled property.
		 */
		mx_internal var _isEnabled:Boolean;

		/**
		 *  @private
		 *  Indicates that a Binding is enabled.
		 *  Used to disable bindings.
		 */
		mx_internal function get isEnabled():Boolean
		{
			return _isEnabled;
		}

		/**
		 *  @private
		 */
		mx_internal function set isEnabled(value:Boolean):void
		{
			_isEnabled = value;

			if (value)
			{
				processDisabledRequests();
			}
		}

		/**
		 *  @private
		 *  Indicates that a Binding is executing.
		 *  Used to prevent circular bindings from causing infinite loops.
		 */
		mx_internal var isExecuting:Boolean;

		/**
		 *  @private
		 *  Indicates that the binding is currently handling an event.
		 *  Used to prevent us from infinitely causing an event
		 *  that re-executes the the binding.
		 */
		mx_internal var isHandlingEvent:Boolean;

		/**
		 *  @private
		 *  Queue of watchers that fired while we were disabled.
		 *  We will resynch with our binding if isEnabled is set to true
		 *  and one or more of our watchers fired while we were disabled.
		 */
		mx_internal var disabledRequests:Dictionary;

		/**
		 *  @private
		 *  True as soon as a non-null or non-empty-string value has been used.
		 *  We don't auto-validate until this is true
		 */
		private var hasHadValue:Boolean;

		/**
		 *  @private
		 *  This is no longer used in Flex 3.0, but it is required to load
		 *  Flex 2.0.0 and Flex 2.0.1 modules.
		 */
		public var uiComponentWatcher:int;

		/**
		 *  @private
		 *  It's possible that there is a two-way binding set up, in which case
		 *  we'll do a rudimentary optimization by not executing ourselves
		 *  if our counterpart is already executing.
		 */
		public var twoWayCounterpart:Binding;

		/**
		 *  @private
		 *  If there is a twoWayCounterpart, hasHadValue is false, and
		 *  isTwoWayPrimary is true, then the twoWayCounterpart will be
		 *  executed first.
		 */
		public var isTwoWayPrimary:Boolean;

		/**
		 *  @private
		 *  True if a wrapped function call does not throw an error.  This is used by
		 *  innerExecute() to tell if the srcFunc completed successfully.
		 */
		private var wrappedFunctionSuccessful:Boolean;

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		/**
		 *  All Bindings hang off of a document for now,
		 *  but really it's just the root of where these functions live.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		mx_internal var document:Object;

		/**
		 *  The function that will return us the value.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		mx_internal var srcFunc:Function;

		/**
		 *  The function that takes the value and assigns it.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		mx_internal var destFunc:Function;

		/**
		 * @private
		 */
		mx_internal var destFuncFailed:Boolean;

		/**
		 *  The destination represented as a String.
		 *  This will be used so we can signal validation on a field.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		mx_internal var destString:String;

		/**
		 *  The source represented as a String.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 4
		 */
		mx_internal var srcString:String;

		/**
		 * 	@private
		 *  Used to suppress calls to destFunc when incoming value is either
		 *	a) an XML node identical to the previously assigned XML node, or
		 *  b) an XMLList containing the identical node sequence as the previously assigned XMLList
		 */
		private var lastValue:Object;


		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		private function defaultDestFunc(value:Object):void
		{
			var chain:Array = destString.split(".");
			var element:Object = document;
			var i:uint = 0;

			if (chain[0] == "this")
			{
				i++;
			}

			while (i < (chain.length - 1))
			{
				element = element[chain[i++]];
				//if the element does not exist : avoid exception as it's heavy on memory allocations
				if (element == null) {
					destFuncFailed = true;
					if (BindingManager.debugDestinationStrings[destString])
					{
						trace("Binding: destString = " + destString + ", error = 1009");
					}
					return;
				}
			}

			element[chain[i]] = value;
		}

		private function defaultSrcFunc():Object
		{
			return document[srcString];
		}

		/**
		 *  Execute the binding.
		 *  Call the source function and get the value we'll use.
		 *  Then call the destination function passing the value as an argument.
		 *  Finally try to validate the destination.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function execute(o:Object = null):void
		{
			if (!isEnabled)
			{
				if (o != null)
				{
					registerDisabledExecute(o);
				}
				return;
			}

			if (twoWayCounterpart && !twoWayCounterpart.hasHadValue && twoWayCounterpart.isTwoWayPrimary)
			{
				twoWayCounterpart.execute();
				hasHadValue = true;
				return;
			}

			if (isExecuting || (twoWayCounterpart && twoWayCounterpart.isExecuting))
			{
				// If there is a twoWayCounterpart already executing, that means that it is
				// assigning something of value so even though we won't execute we should be
				// sure to mark ourselves as having had a value so that future executions will
				// be correct.  If isExecuting is true but we re-entered, that means we
				// clearly had a value so setting hasHadValue is safe.
				hasHadValue = true;
				return;
			}

			try
			{
				isExecuting = true;
				wrapFunctionCall(this, innerExecute, o);
			}
			catch(error:Error)
			{
				if (allowedErrors[error.errorID] == null)
					throw error;
			}
			finally
			{
				isExecuting = false;
			}
		}

		/**
		 * @private
		 * Take note of any execute request that occur when we are disabled.
		 */
		private function registerDisabledExecute(o:Object):void
		{
			if (o != null)
			{
				disabledRequests = (disabledRequests != null) ? disabledRequests :
					new Dictionary(true);

				disabledRequests[o] = true;
			}
		}

		/**
		 * @private
		 * Resynch with any watchers that may have updated while we were disabled.
		 */
		private function processDisabledRequests():void
		{
			if (disabledRequests != null)
			{
				for (var key:Object in disabledRequests)
				{
					execute(key);
				}

				disabledRequests = null;
			}
		}


		/**
		 *  @private
		 *  Note: use of this wrapper needs to be reexamined. Currently there's at least one situation where a
		 *	wrapped function invokes another wrapped function, which is unnecessary (i.e., only the inner function
		 *  will throw), and also risks future errors due to the 'wrappedFunctionSuccessful' member variable
		 *  being stepped on. Leaving alone for now to minimize pre-GMC volatility, but should be revisited for
		 *  an early dot release.
		 *  Also note that the set of suppressed error codes below is repeated verbatim in Watcher.wrapUpdate.
		 *  These need to be consolidated and the motivations for each need to be documented.
		 */
		protected function wrapFunctionCall(thisArg:Object, wrappedFunction:Function, object:Object = null, ...args):Object
		{
			wrappedFunctionSuccessful = false;

			try
			{
				var result:Object = wrappedFunction.apply(thisArg, args);
				if(destFuncFailed == true) {
					destFuncFailed = false;
					return null;
				}
				wrappedFunctionSuccessful = true;
				return result;
			}
			catch(error:Error)
			{
				if (error is RangeError) {
					if (BindingManager.debugDestinationStrings[destString])
					{
						trace("Binding: destString = " + destString + ", error = " + error);
					}
				} else {
					// Certain errors are normal when executing a srcFunc or destFunc,
					// so we swallow them:
					//   Error #1006: Call attempted on an object that is not a function.
					//   Error #1009: null has no properties.
					//   Error #1010: undefined has no properties.
					//   Error #1055: - has no properties.
					//   Error #1069: Property - not found on - and there is no default value
					// We allow any other errors to be thrown.
					if ((error.errorID != 1006) &&
						(error.errorID != 1009) &&
						(error.errorID != 1010) &&
						(error.errorID != 1055) &&
						(error.errorID != 1069))
					{
						throw error;
					}
					else
					{
						if (BindingManager.debugDestinationStrings[destString])
						{
							trace("Binding: destString = " + destString + ", error = " + error);
						}
					}
				}
			}

			return null;
		}

		/**
		 *	@private
		 *  true iff XMLLists x and y contain the same node sequence.
		 */
		private function nodeSeqEqual(x:XMLList, y:XMLList):Boolean
		{
			var n:uint = x.length();
			if (n == y.length())
			{
				for (var i:uint = 0; i < n && x[i] === y[i]; i++)
				{
				}
				return i == n;
			}
			else
			{
				return false;
			}
		}

		/**
		 *  @private
		 */
		private function innerExecute():void
		{
			destFuncFailed = false;
			var value:Object = wrapFunctionCall(document, srcFunc);

			if (BindingManager.debugDestinationStrings[destString])
			{
				trace("Binding: destString = " + destString + ", srcFunc result = " + value);
			}

			if (hasHadValue || wrappedFunctionSuccessful)
			{
				//	Suppress binding assignments on non-simple XML: identical single nodes, or
				//	lists over identical node sequences.
				//	Note: outer tests are inline for efficiency
				if (!(lastValue is XML && lastValue.hasComplexContent() && lastValue === value) &&
					!(lastValue is XMLList && lastValue.hasComplexContent() && value is XMLList &&
					nodeSeqEqual(lastValue as XMLList, value as XMLList)))
				{
					destFunc.call(document, value);

					if(destFuncFailed == false) {
						//	Note: state is not updated if destFunc throws
						lastValue = value;
						hasHadValue = true;
					}
				}
			}
		}

		/**
		 *  This function is called when one of this binding's watchers
		 *  detects a property change.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function watcherFired(commitEvent:Boolean, cloneIndex:int):void
		{
			if (isHandlingEvent)
				return;

			try
			{
				isHandlingEvent = true;
				execute(cloneIndex);
			}
			finally
			{
				isHandlingEvent = false;
			}
		}
	}
}
