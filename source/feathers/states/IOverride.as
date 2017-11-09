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

	/**
	 *  The IOverride interface is used for view state overrides.
	 *  All entries in the State class <code>overrides</code>
	 *  property array must implement this interface.
	 *
	 *  @see feathers.states.State
	 *
	 *  @productversion Feathers SDK 3.5.0
	 */
	public interface IOverride
	{
		/**
		 *  Initializes the override.
		 *  Flex calls this method before the first call to the
		 *  <code>apply()</code> method, so you put one-time initialization
		 *  code for the override in this method.
		 *
		 *  <p>Flex calls this method automatically when the state is entered.
		 *  It should not be called directly.</p>
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		function initialize():void

		/**
		 *  Applies the override. Flex retains the original value, so that it can 
		 *  restore the value later in the <code>remove()</code> method.
		 *
		 *  <p>This method is called automatically when the state is entered.
		 *  It should not be called directly.</p>
		 *
		 *  @param parent The parent of the state object containing this override.
		 *  The override should use this as its target if an explicit target was
		 *  not specified.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		function apply(parent:FeathersControl):void;

		/**
		 *  Removes the override. The value remembered in the <code>apply()</code>
		 *  method is restored.
		 *
		 *  <p>This method is called automatically when the state is entered.
		 *  It should not be called directly.</p>
		 *
		 *  @param parent The parent of the state object containing this override.
		 *  The override should use this as its target if an explicit target was
		 *  not specified.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		function remove(parent:FeathersControl):void;
	}
}