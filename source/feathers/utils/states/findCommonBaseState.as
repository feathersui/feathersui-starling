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
package feathers.utils.states
{
	import feathers.core.IMXMLStateContext;
	import feathers.states.State;

	[Exclude]
	/**
	 *  @private
	 *  Find the deepest common state between two states. For example:
	 *
	 *  State A
	 *  State B basedOn A
	 *  State C basedOn A
	 *
	 *  findCommonBaseState(B, C) returns A
	 *
	 *  If there are no common base states, the root state ("") is returned.
	 */
	public function findCommonBaseState(target:IMXMLStateContext, state1:String, state2:String):String
	{
		var firstState:State = getState(target, state1);
		var secondState:State = getState(target, state2);

		// Quick exit if either state is the base state
		if (!firstState || !secondState)
			return "";

		// Quick exit if both states are not based on other states
		if (isBaseState(firstState.basedOn) && isBaseState(secondState.basedOn))
			return "";

		// Get the base states for each state and walk from the top
		// down until we find the deepest common base state.
		var firstBaseStates:Array = getBaseStates(target, firstState);
		var secondBaseStates:Array = getBaseStates(target, secondState);
		var commonBase:String = "";

		while (firstBaseStates[firstBaseStates.length - 1] ==
			secondBaseStates[secondBaseStates.length - 1])
		{
			commonBase = firstBaseStates.pop();
			secondBaseStates.pop();

			if (!firstBaseStates.length || !secondBaseStates.length)
				break;
		}

		// Finally, check to see if one of the states is directly based on the other.
		if (firstBaseStates.length &&
			firstBaseStates[firstBaseStates.length - 1] == secondState.name)
		{
			commonBase = secondState.name;
		}
		else if (secondBaseStates.length &&
				secondBaseStates[secondBaseStates.length - 1] == firstState.name)
		{
			commonBase = firstState.name;
		}

		return commonBase;
	}
}