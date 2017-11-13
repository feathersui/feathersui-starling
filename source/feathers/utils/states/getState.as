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
	 *  Returns the state with the specified name, or null if it doesn't exist.
	 *  If multiple states have the same name the first one will be returned.
	 */
	public function getState(target:IMXMLStateContext, stateName:String, throwOnUndefined:Boolean=true):State
	{
		if (!target || !target.states || isBaseState(stateName))
			return null;

		// Do a simple linear search for now. This can
		// be optimized later if needed.
		for (var i:int = 0; i < target.states.length; i++)
		{
			if (target.states[i].name == stateName)
				return target.states[i];
		}
		
		if (throwOnUndefined)
		{
			throw new ArgumentError("Undefined state '" + stateName + "'.");
		}
		return null;
	}
}