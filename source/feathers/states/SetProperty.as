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
	import feathers.core.FeathersControl;

	import mx.core.IDeferredInstance;
	import mx.core.mx_internal;

	use namespace mx_internal;

	/**
	 *  The SetProperty class specifies a property value that is in effect only 
	 *  during the parent view state.
	 *  You use this class in the <code>overrides</code> property of the State class.
	 * 
	 *  @mxml
	 *
	 *  <p>The <code>&lt;mx:SetProperty&gt;</code> tag
	 *  has the following attributes:</p>
	 *  
	 *  <pre>
	 *  &lt;mx:SetProperty
	 *   <b>Properties</b>
	 *   name="null"
	 *   target="null"
	 *   value="undefined"
	 *  /&gt;
	 *  </pre>
	 *
	 *  @see mx.states.State
	 *  @see mx.states.SetEventHandler
	 *  @see mx.states.SetStyle
	 *  @see mx.effects.SetPropertyAction
	 *
	 *  @includeExample examples/StatesExample.mxml
	 *
	 *  @productversion Feathers SDK 3.5.0
	 */
	public class SetProperty extends OverrideBase
	{

		/**
		 *  @private
		 *  Returns <code>true</code> if the object is an instance of a dynamic class.
		 *
		 *  @param object The object.
		 *
		 *  @return <code>true</code> if the object is an instance of a dynamic class.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		private static function isDynamicObject(object:Object):Boolean
		{
			try
			{
				// this test for checking whether an object is dynamic or not is 
				// pretty hacky, but it assumes that no-one actually has a 
				// property defined called "wootHackwoot"
				object["wootHackwoot"];
			}
			catch (e:Error)
			{
				// our object isn't an instance of a dynamic class
				return false;
			}
			return true;
		}

		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------

		/**
		 *  @private
		 *  This is a table of pseudonyms.
		 *  Whenever the property being overridden is found in this table,
		 *  the pseudonym is saved/restored instead.
		 */
		private static const PSEUDONYMS:Object =
		{
			currentState: "currentStateDeferred"
		};

		/**
		 *  @private
		 *  This is a table of related properties.
		 *  Whenever the property being overridden is found in this table,
		 *  the related property is also saved and restored.
		 */
		private static const RELATED_PROPERTIES:Object =
		{
			explicitWidth: [ "percentWidth" ],
			explicitHeight: [ "percentHeight" ],
			percentWidth: [ "explicitWidth" ],
			percentHeight: [ "explicitHeight" ]
		};

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 *  Constructor.
		 *
		 *  @param target The object whose property is being set.
		 *  By default, Flex uses the immediate parent of the State object.
		 *
		 *  @param name The property to set.
		 *
		 *  @param value The value of the property in the view state.
		 * 
		 *  @param valueFactory An optional write-only property from which to obtain 
		 *  a shared value.  This is primarily used when this override's value is 
		 *  shared by multiple states or state groups.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function SetProperty(
				target:Object = null, 
				name:String = null,                      
				value:* = undefined, 
				valueFactory:IDeferredInstance = null)
		{
			super();

			this.target = target;
			this.name = name;
			this.value = value;
			this.valueFactory = valueFactory;
		}

		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------

		/**
		 *  @private
		 *  Storage for the old property value.
		 */
		private var oldValue:Object;
		
		/**
		 *  @private
		 *  Storage for the old related property values, if used.
		 */
		private var oldRelatedValues:Array;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		//----------------------------------
		//  name
		//----------------------------------

		[Inspectable(category="General")]

		/**
		 *  The name of the property to change.
		 *  You must set this property, either in 
		 *  the SetProperty constructor or by setting
		 *  the property value directly.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public var name:String;

		//----------------------------------
		//  target
		//----------------------------------

		[Inspectable(category="General")]

		/**
		 *  The object containing the property to be changed.
		 *  If the property value is <code>null</code>, Flex uses the
		 *  immediate parent of the State object.
		 *
		 *  @default null
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public var target:Object;
		
		/**
		 *  The cached target for which we applied our override.
		 *  We keep track of the applied target while applied since
		 *  our target may be swapped out in the owning document and 
		 *  we want to make sure we roll back the correct (original) 
		 *  element. 
		 *
		 *  @private
		 */
		private var appliedTarget:Object;

		//----------------------------------
		//  value
		//----------------------------------

		[Inspectable(category="General")]
		
		/**
		 *  @private
		 *  Storage for the value property.
		 */
		public var _value:*;
		
		/**
		 *  The new value for the property.
		 *
		 *  @default undefined
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get value():*
		{
			return _value;
		}

		/**
		 *  @private
		 */
		public function set value(val:*):void
		{
			_value = val;
			
			// Reapply if necessary.
			if (applied) 
			{
				apply(parentContext);
			}
		}

		//----------------------------------
		//  valueFactory
		//----------------------------------
		
		/**
		 *  An optional write-only property from which to obtain a shared value.  This 
		 *  is primarily used when this override's value is shared by multiple states 
		 *  or state groups. 
		 *
		 *  @default undefined
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 4
		 */
		public function set valueFactory(factory:IDeferredInstance):void
		{
			// We instantiate immediately in order to retain the instantiation
			// behavior of a typical (unshared) value.  We may later enhance to
			// allow for deferred instantiation.
			if (factory)
				value = factory.getInstance();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods: IOverride
		//
		//--------------------------------------------------------------------------

		/**
		 * Utility function to return the pseudonym of the property
		 * name if it exists on the object
		 */
		private function getPseudonym(obj:*, name:String):String
		{
			var propName:String;
			propName = PSEUDONYMS[name];
			if (!(propName in obj))
			{
				if (isDynamicObject(obj))
				{
					// If this is a dynamic object we fall back immediately
					// to our original property name.
					propName = name;
				}
				else
				{
					// 'in' does not work for mx_internal properties 
					// like currentStateDeferred            
					try
					{
						// Check if we can access the property; if it doesn't
						// exist, it'll throw a ReferenceError
						var tmp:* = obj[propName];
					}
					catch (e:ReferenceError)
					{
						propName = name;
					}
				}
			}
			return propName;
		}
		
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		override public function apply(parent:FeathersControl):void
		{   
			parentContext = parent;
			var obj:* = getOverrideContext(target, parent);
			if (obj != null)
			{
				appliedTarget = obj;
				var propName:String = PSEUDONYMS[name] ? getPseudonym(obj, name) : name;
		
				var relatedProps:Array = RELATED_PROPERTIES[propName] ?
										RELATED_PROPERTIES[propName] :
										null;
		
				var newValue:* = value;
		
				// Remember the original value so it can be restored later
				// after we are asked to remove our override (and only if we
				// aren't being asked to re-apply a value).
				if (!applied)
				{
					oldValue = obj[propName];
				}
		
				if (relatedProps)
				{
					oldRelatedValues = [];
		
					for (var i:int = 0; i < relatedProps.length; i++)
						oldRelatedValues[i] = obj[relatedProps[i]];
				}
		
				// Special case for width and height. If they are percentage values,
				// set the percentWidth/percentHeight instead.
				if (name == "width" || name == "height")
				{
					if (newValue is String && newValue.indexOf("%") >= 0)
					{
						propName = name == "width" ? "percentWidth" : "percentHeight";
						newValue = newValue.slice(0, newValue.indexOf("%"));
					}
					else
					{
						// Need to set width/height instead of explicitWidth/explicitHeight
						// otherwise width/height are out of sync until the target is validated.
						propName = name;
					}
				}
		
				// Set new value
				setPropertyValue(obj, propName, newValue, oldValue);
				
				// Disable bindings for the base property if appropriate. If the binding
				// fires while our override is applied, the correct value will automatically
				// be applied when the binding is later enabled.
				enableBindings(obj, parent, propName, false);
			}
			else if (!applied)
			{
				// Our target context is unavailable so we attempt to register
				// a listener on our parent document to detect when/if it becomes
				// valid.
				addContextListener(target);
			}
			
			// Save state in case our value or target is changed while applied. This
			// can occur when our value property is databound or when a target is 
			// deferred instantiated.
			applied = true;
		}

		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		override public function remove(parent:FeathersControl):void
		{   
			var obj:* = getOverrideContext(appliedTarget, parent);
			if (obj != null && appliedTarget)
			{
				var propName:String = PSEUDONYMS[name] ? getPseudonym(obj, name) : name;
				
				var relatedProps:Array = RELATED_PROPERTIES[propName] ?
										RELATED_PROPERTIES[propName] :
										null;
		
				// Special case for width and height. Restore the "width" and
				// "height" properties instead of explicitWidth/explicitHeight
				// so they can be kept in sync.
				if ((name == "width" || name == "height") && !isNaN(Number(oldValue)))
				{
					propName = name;
				}
				
				// Restore the old value
				setPropertyValue(obj, propName, oldValue, oldValue);
		
				// Re-enable bindings for the base property if appropriate. If the binding
				// fired while our override was applied, the current value will automatically
				// be applied once enabled.
				enableBindings(obj, parent, propName);
				
				// Restore related value, if needed
				if (relatedProps)
				{
					for (var i:int = 0; i < relatedProps.length; i++)
					{
						setPropertyValue(obj, relatedProps[i],
								oldRelatedValues[i], oldRelatedValues[i]);
					}
				}
			}
			else
			{
				// It seems our override is no longer active, but we were never
				// able to successfully apply ourselves, so remove our context
				// listener if applicable.
				removeContextListener();
			}
			
			// Clear our flags and override context.
			applied = false;
			parentContext = null;
			appliedTarget = null;
		}

		/**
		 *  @private
		 *  Sets the property to a value, coercing if necessary.
		 */
		private function setPropertyValue(obj:Object, name:String, value:*,
										valueForType:Object):void
		{
			// special-case undefined and null: we don't want to cast it 
			// to some special type and lose that information
			if (value === undefined || value === null)
				obj[name] = value;
			else if (valueForType is Number)
				obj[name] = Number(value);
			else if (valueForType is Boolean)
				obj[name] = toBoolean(value);
			else
				obj[name] = value;
		}

		/**
		 *  @private
		 *  Converts a value to a Boolean true/false.
		 */
		private function toBoolean(value:Object):Boolean
		{
			if (value is String)
				return value.toLowerCase() == "true";

			return value != false;
		}
	}
}