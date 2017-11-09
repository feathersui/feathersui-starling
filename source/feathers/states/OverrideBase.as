/*
Feathers SDK
Copyright 2012-2017 Bowler Hat LLC

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
package feathers.states
{
	import feathers.binding.BindingManager;
	import feathers.core.FeathersControl;
	import feathers.events.PropertyChangeEventData;

	import starling.events.Event;
	import starling.events.EventDispatcher;

	/**
	 *  The OverrideBase class is the base class for the 
	 *  override classes used by view states. 
	 *
	 *  @productversion Feathers SDK 3.5.0
	 */
	public class OverrideBase extends EventDispatcher implements IOverride
	{
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
		public function OverrideBase() {}

		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  Flag which tracks if we're actively overriding a property.
		 */
		protected var applied:Boolean = false;
		
		/**
		 *  @private
		 *  Our most recent parent context.
		 */
		protected var parentContext:FeathersControl;
		
		/**
		 *  @private
		 */  
		private var targetProperty:String;
		
		/**
		 *  @private
		 *  Specifies whether or not a property-centric 
		 *  state override's base value is data bound.
		 *  
		 *  This value is intended for use by the MXML 
		 *  compiler only.
		 */
		public var isBaseValueDataBound:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  IOverride interface method; this class implements it as an empty method.
		 * 
		 *  @copy IOverride#initialize()
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function initialize():void {}
		
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function apply(parent:FeathersControl):void {}
		
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function remove(parent:FeathersControl):void {}
		
		/**
		 * @private 
		 * Initialize this object from a descriptor.
		 */
		public function initializeFromObject(properties:Object):Object
		{
			for (var p:String in properties)
			{
				this[p] = properties[p];
			}
			
			return Object(this);
		}
		
		/**
		 * @private
		 * @param parent The document level context for this override.
		 * @param target The component level context for this override.
		 */
		protected function getOverrideContext(target:Object, parent:FeathersControl):Object
		{
			if (target == null)
				return parent;
		
			if (target is String)
				return parent[target];
		
			return target;
		}
	
		/**
		 * @private
		 * If the target of our override is a String (representing a property), 
		 * we register a PROPERTY_CHANGE listener to determine when/if our target 
		 * context becomes available or changes.  
		 */ 
		protected function addContextListener(target:Object):void
		{
			if (target is String && parentContext != null)
			{
				targetProperty = target as String;
				parentContext.addEventListener("propertyChange",
					context_propertyChangeHandler);
			}
		}
		
		/**
		 * @private
		 * Unregister our PROPERTY_CHANGE listener.
		 */ 
		protected function removeContextListener():void
		{
			if (parentContext != null)
			{
				parentContext.removeEventListener("propertyChange",
					context_propertyChangeHandler);
			}
		}
		
		/**
		 * @private
		 * Called when our target context is set.  We re-apply our override
		 * if appropriate.
		 */
		protected function context_propertyChangeHandler(event:Event, data:PropertyChangeEventData):void
		{
			if (data.property == targetProperty && data.newValue != null)
			{
				apply(parentContext);
				removeContextListener();
			}
		}
		
		/**
		 * @private 
		 * Disables or enables binding associated with a property override.
		 */
		protected function enableBindings(target:Object, parent:FeathersControl, property:String, enable:Boolean=true):void
		{
			if (isBaseValueDataBound && target && parent && property)
			{
				var document:Object = null;//target.hasOwnProperty("document") ? target.document : null;
				//document = !document && parent.hasOwnProperty("document") ? parent.document : document;
				
				var name:String = target.hasOwnProperty("id") ? target.id : null;
				name = !name && target.hasOwnProperty("name") ? target.name : name;
				
				if (document && name)
				{
					var root:String = (document == target) ? "this" : name;
					BindingManager.enableBindings(document, root + "." + property, enable);
				}
			}
		}
	}
}