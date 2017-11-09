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
package feathers.events
{
	/**
	 * Event <code>type</code> constants for collections. This class is
	 * not a subclass of <code>starling.events.Event</code> because these
	 * constants are meant to be used with <code>dispatchEventWith()</code> and
	 * take advantage of the Starling's event object pooling. The object passed
	 * to an event listener will be of type <code>starling.events.Event</code>.
	 * 
	 * @see feathers.states.State
	 * 
     * @productversion Feathers 3.5.0
	 */
	public class StateEventType
	{
		/**
		 * The <code>StateEventType.ENTER_STATE</code> constant defines the value of the
		 * <code>type</code> property of the event object for a <code>enterState</code> event.
		 *
		 * <p>This event will only be dispatched when there are one or more relevant listeners 
		 * attached to the dispatching object.</p>
		 * 
		 * <p>The properties of the event object have the following values:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>bubbles</code></td><td>false</td></tr>
		 *   <tr><td><code>cancelable</code></td><td>false</td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>The Object that defines the
		 *     event listener that handles the event. For example, if you use
		 *     <code>myButton.addEventListener()</code> to register an event listener,
		 *     myButton is the value of the <code>currentTarget</code>. </td></tr>
		 *   <tr><td><code>target</code></td><td>The Object that dispatched the event;
		 *     it is not always the Object listening for the event.
		 *     Use the <code>currentTarget</code> property to always access the
		 *     Object listening for the event.</td></tr>
		 * </table>
		 *
		 * @eventType enterState
		 */
		public static const ENTER_STATE:String = "enterState";

		/**
		 * The <code>StateEventType.EXIT_STATE</code> constant defines the value of the
		 * <code>type</code> property of the event object for a <code>exitState</code> event.
		 *
		 * <p>This event will only be dispatched when there are one or more relevant listeners 
		 * attached to the dispatching object.</p>
		 * 
		 * <p>The properties of the event object have the following values:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>bubbles</code></td><td>false</td></tr>
		 *   <tr><td><code>cancelable</code></td><td>false</td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>The Object that defines the
		 *     event listener that handles the event. For example, if you use
		 *     <code>myButton.addEventListener()</code> to register an event listener,
		 *     myButton is the value of the <code>currentTarget</code>. </td></tr>
		 *   <tr><td><code>target</code></td><td>The Object that dispatched the event;
		 *     it is not always the Object listening for the event.
		 *     Use the <code>currentTarget</code> property to always access the
		 *     Object listening for the event.</td></tr>
		 * </table>
		 *
		 * @eventType exitState
		 */
		public static const EXIT_STATE:String = "exitState";
	}
}