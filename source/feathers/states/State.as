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
	import feathers.events.StateEventType;

	import mx.core.mx_internal;

	import starling.events.EventDispatcher;

	use namespace mx_internal;

	//--------------------------------------
	//  Events
	//--------------------------------------

	/**
	 *  Dispatched after a view state has been entered.
	 *
	 *  @eventType feathers.events.StateEventType.ENTER_STATE
	 */
	[Event(name="enterState", type="starling.events.Event")]

	/**
	 *  Dispatched just before a view state is exited.
	 *  This event is dispatched before the changes
	 *  to the default view state have been removed.
	 *
	 *  @eventType feathers.events.StateEventType.EXIT_STATE
	 */
	[Event(name="exitState", type="starling.events.Event")]

	//--------------------------------------
	//  Other metadata
	//--------------------------------------

	[DefaultProperty("overrides")]

	/**
	 *  The State class defines a view state, a particular view of a component.
	 *  For example, a product thumbnail could have two view states;
	 *  a base view state with minimal information, and a rich view state with
	 *  additional information.
	 *  The <code>overrides</code> property specifies a set of child classes
	 *  to add or remove from the base view state, and properties, styles, and event
	 *  handlers to set when the view state is in effect.
	 *
	 *  <p>You use the State class in the <code>states</code> property
	 *  of Flex components.
	 *  You can only specify a <code>states</code> property at the root of an
	 *  application or a custom control, not on child controls.</p>
	 *
	 *  <p>You enable a view state by setting a component's
	 *  <code>currentState</code> property.</p>
	 *
	 *  @mxml
	 *  <p>The <code>&lt;mx:State&gt;</code> tag has the following attributes:</p>
	 *
	 *  <pre>
	 *  &lt;mx:State
	 *  <b>Properties</b>
	 *  basedOn="null"
	 *  name="null"
	 *  overrides="null"
	 *  /&gt;
	 *  </pre>
	 *
	 *  @see mx.states.AddChild
	 *  @see mx.states.RemoveChild
	 *  @see mx.states.SetEventHandler
	 *  @see mx.states.SetProperty
	 *  @see mx.states.SetStyle
	 *  @see mx.states.Transition
	 *
	 *  @productversion Feathers SDK 3.5.0
	 */
	public class State extends EventDispatcher
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 *  Constructor.
		 *
		 *  @param properties Object containing property settings for this State.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function State(properties:Object=null)
		{
			super();
			
			// Initialize from object if provided.
			for (var p:String in properties)
			{
				this[p] = properties[p];
			}
		}

		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------

		/**
		 *  @private
		 *  Initialized flag
		 */
		private var initialized:Boolean = false;

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		//----------------------------------
		//  basedOn
		//----------------------------------

		[Inspectable(category="General")]

		/**
		 *  The name of the view state upon which this view state is based, or
		 *  <code>null</code> if this view state is not based on a named view state.
		 *  If this value is <code>null</code>, the view state is based on a root
		 *  state that consists of the properties, styles, event handlers, and
		 *  children that you define for a component without using a State class.
		 *
		 *  @default null
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public var basedOn:String;

		//----------------------------------
		//  name
		//----------------------------------

		[Inspectable(category="General")]

		/**
		 *  The name of the view state.
		 *  State names must be unique for a given component.
		 *  This property must be set.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public var name:String;

		//----------------------------------
		//  overrides
		//----------------------------------

		[ArrayElementType("mx.states.IOverride")]
		[Inspectable(category="General")]

		/**
		 *  The overrides for this view state, as an Array of objects that implement
		 *  the IOverride interface. These overrides are applied in order when the
		 *  state is entered, and removed in reverse order when the state is exited.
		 *
		 *  <p>The following Flex classes implement the IOverride interface and let you
		 *  define the view state characteristics:</p>
		 *  <ul>
		 *      <li>AddChild</li>
		 *      <li>RemoveChild</li>
		 *      <li>SetEventHandler</li>
		 *      <li>SetProperty</li>
		 *      <li>SetStyle</li>
		 *  </ul>
		 *
		 *  <p>The <code>overrides</code> property is the default property of the
		 *  State class. You can omit the <code>&lt;mx:overrides&gt;</code> tag
		 *  and its child <code>&lt;mx:Array&gt;</code>tag if you use MXML tag
		 *  syntax to define the overrides.</p>
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public var overrides:Array /* of IOverride */ = [];

		//----------------------------------
		//  stateGroups
		//----------------------------------

		[ArrayElementType("String")]
		[Inspectable(category="General")]

		/**
		 *  The state groups that this view state belongs to as an array of String.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public var stateGroups:Array /* of String */ = [];
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		/**
		 *  @private
		 *  Initialize this state and all of its overrides.
		 */
		mx_internal function initialize():void
		{
			if (!initialized)
			{
				initialized = true;
				for (var i:int = 0; i < overrides.length; i++)
				{
					IOverride(overrides[i]).initialize();
				}
			}
		}

		/**
		 *  @private
		 *  Dispatches the "enterState" event.
		 */
		mx_internal function dispatchEnterState():void
		{
			if (hasEventListener(StateEventType.ENTER_STATE))
				dispatchEventWith(StateEventType.ENTER_STATE);
		}

		/**
		 *  @private
		 *  Dispatches the "exitState" event.
		 */
		mx_internal function dispatchExitState():void
		{
			if (hasEventListener(StateEventType.EXIT_STATE))
				dispatchEventWith(StateEventType.EXIT_STATE);
		}
	}
}