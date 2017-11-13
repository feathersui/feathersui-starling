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
	import starling.events.Event;
	import feathers.states.State;
	import feathers.events.StateEventType;

	[Exclude]
	/**
	 * @private
	 */
	public function commitCurrentState(target:IMXMLStateContext, currentState:String, requestedCurrentState:String):String
	{
		if(!target)
		{
			return null;
		}
		var commonBaseState:String = findCommonBaseState(target, currentState, requestedCurrentState);
		var event:Event;
		var oldState:String = currentState ? currentState : "";
		var destination:State = getState(target, requestedCurrentState);
		/*var prevTransitionEffect:Object;
		var tmpPropertyChanges:Array;*/
		
		// First, make sure we've loaded the Effect class - some of the logic 
		// below requires it
		/*if (nextTransition && !effectLoaded)
		{
			effectLoaded = true;
			if (ApplicationDomain.currentDomain.hasDefinition("mx.effects.Effect"))
				effectType = Class(ApplicationDomain.currentDomain.
					getDefinition("mx.effects.Effect"));
		}*/

		// Stop any transition that may still be playing
		/*var prevTransitionFraction:Number;
		if (_currentTransition)
		{
			// Remove the event listener, we don't want to trigger it as it
			// dispatches FlexEvent.STATE_CHANGE_COMPLETE and we are
			// interrupting _currentTransition instead.
			_currentTransition.effect.removeEventListener(EffectEvent.EFFECT_END, transition_effectEndHandler);

			// 'stop' interruptions take precedence over autoReverse behavior
			if (nextTransition && _currentTransition.interruptionBehavior == "stop")
			{
				prevTransitionEffect = _currentTransition.effect;
				prevTransitionEffect.transitionInterruption = true;
				// This logic stops the effect from applying the end values
				// so that we can capture the interrupted values correctly
				// in captureStartValues() below. Save the values in the
				// tmp variable because stop() clears out propertyChangesArray
				// from the effect.
				tmpPropertyChanges = prevTransitionEffect.propertyChangesArray;
				prevTransitionEffect.applyEndValuesWhenDone = false;
				prevTransitionEffect.stop();
				prevTransitionEffect.applyEndValuesWhenDone = true;
			}
			else
			{
				if (_currentTransition.autoReverse &&
					transitionFromState == requestedCurrentState &&
					transitionToState == _currentState)
				{
					if (_currentTransition.effect.duration == 0)
						prevTransitionFraction = 0;
					else
						prevTransitionFraction = 
							_currentTransition.effect.playheadTime /
							getTotalDuration(_currentTransition.effect);
				}
				_currentTransition.effect.end();
			}

			// The current transition is being interrupted, dispatch an event
			if (hasEventListener(FlexEvent.STATE_CHANGE_INTERRUPTED))
				dispatchEvent(new FlexEvent(FlexEvent.STATE_CHANGE_INTERRUPTED));
			_currentTransition = null;
		}*/

		// Initialize the state we are going to.
		initializeState(target, requestedCurrentState);

		// Capture transition start values
		/*if (nextTransition)
			nextTransition.effect.captureStartValues();
		
		// Now that we've captured the start values, apply the end values of
		// the effect as normal. This makes sure that objects unaffected by the
		// next transition have their correct end values from the previous
		// transition
		if (tmpPropertyChanges)
			prevTransitionEffect.applyEndValues(tmpPropertyChanges,
				prevTransitionEffect.targets);*/
		
		// Dispatch currentStateChanging event
		/*if (hasEventListener(StateChangeEvent.CURRENT_STATE_CHANGING)) 
		{
			event = new StateChangeEvent(StateChangeEvent.CURRENT_STATE_CHANGING);
			event.oldState = oldState;
			event.newState = requestedCurrentState ? requestedCurrentState : "";
			dispatchEvent(event);
		}*/
		
		// If we're leaving the base state, send an exitState event
		if (isBaseState(currentState) && target.hasEventListener(StateEventType.EXIT_STATE))
			target.dispatchEventWith(StateEventType.EXIT_STATE, false, oldState);

		// Remove the existing state
		removeState(target, currentState, commonBaseState);
		currentState = requestedCurrentState;

		// Check for state specific styles
		//stateChanged(oldState, _currentState, true);

		// If we're going back to the base state, dispatch an
		// enter state event, otherwise apply the state.
		if (isBaseState(currentState)) 
		{
			if (target.hasEventListener(StateEventType.ENTER_STATE))
				target.dispatchEventWith(StateEventType.ENTER_STATE, false, currentState ? currentState : ""); 
		}
		else
			applyState(target, currentState, commonBaseState);

		// Dispatch currentStateChange
		/*if (hasEventListener(StateChangeEvent.CURRENT_STATE_CHANGE))
		{
			event = new StateChangeEvent(StateChangeEvent.CURRENT_STATE_CHANGE);
			event.oldState = oldState;
			event.newState = _currentState ? _currentState : "";
			dispatchEvent(event);
		}*/
		
		/*if (nextTransition)
		{
			var reverseTransition:Boolean =  
				nextTransition && nextTransition.autoReverse &&
				(nextTransition.toState == oldState ||
				nextTransition.fromState == _currentState);
			// Force a validation before playing the transition effect
			UIComponentGlobals.layoutManager.validateNow();
			_currentTransition = nextTransition;
			transitionFromState = oldState;
			transitionToState = _currentState;
			// Tell the effect whether it is running in interruption mode, in which
			// case it should grab values from the states instead of from current
			// property values
			Object(nextTransition.effect).transitionInterruption = 
				(prevTransitionEffect != null);
			nextTransition.effect.addEventListener(EffectEvent.EFFECT_END, 
				transition_effectEndHandler);
			nextTransition.effect.play(null, reverseTransition);
			if (!isNaN(prevTransitionFraction) && 
				nextTransition.effect.duration != 0)
				nextTransition.effect.playheadTime = (1 - prevTransitionFraction) * 
					getTotalDuration(nextTransition.effect);
		}
		else
		{
			// Dispatch an event that the transition has completed.
			if (hasEventListener(FlexEvent.STATE_CHANGE_COMPLETE))
				dispatchEvent(new FlexEvent(FlexEvent.STATE_CHANGE_COMPLETE));
		}*/
		return currentState;
	}
}