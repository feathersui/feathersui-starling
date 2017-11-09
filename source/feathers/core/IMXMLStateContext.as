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
package feathers.core
{
	/**
	 * A component that supports view states.
	 * 
	 * @see feathers.states.State
	 *  
	 * @productversion Feathers SDK 3.5.0
	 */
	public interface IMXMLStateContext extends IStateContext
	{

		[ArrayElementType("feathers.states.State")]
		/**
		 * The set of view state objects.
		 */
		function get states():Array;

		/**
		 * @private
		 */
		function set states(value:Array):void;
    
		/**
		 * Determines whether the specified state has been defined on this
		 * component. 
		 *
		 * @param stateName The name of the state being checked. 
		 *
		 * @return <code>true</code> if the specified state has been defined and <code>false</code> if not
		 */
		function hasState(stateName:String):Boolean
	}
}
