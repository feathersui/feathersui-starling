/*
 * Copyright (C) 2007 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package feathers.utils.focus
{
	import feathers.core.IFocusDisplayObject;
	import feathers.layout.RelativePosition;

	import flash.geom.Rectangle;

	import starling.utils.Pool;

	/**
	 * Determines if <code>object1</code> is a better choice than
	 * <code>object2</code> when changing focus to the specified position
	 * relative to the current focus.
	 *
	 * <p>Note: it's acceptable pass in <code>null</code> for
	 * <code>object2</code> to check if an item is at the relative position to
	 * the focused rectangle.</p>
	 *
	 * @see feathers.layout.RelativePosition
	 */
	public function isBetterFocusForRelativePosition(object1:IFocusDisplayObject, object2:IFocusDisplayObject, focusedRect:Rectangle, relativePosition:String):Boolean
	{
		var rect:Rectangle = object1.getBounds(object1.stage, Pool.getRectangle());

		var minPrimaryDistance1:Number = calculateMinPrimaryAxisDistanceForRelativePosition(focusedRect, rect, relativePosition);
		if(minPrimaryDistance1 === Number.POSITIVE_INFINITY)
		{
			return false;
		}
		var maxPrimaryDistance1:Number = calculateMaxPrimaryAxisDistanceForRelativePosition(focusedRect, rect, relativePosition);
		var secondaryDistance1:Number = calculateSecondaryAxisDistanceForRelativePosition(focusedRect, rect, relativePosition);
		var onSameAxis1:Boolean = itemsAreOnSameAxis(focusedRect, rect, relativePosition);
		
		if(object2 === null)
		{
			var minPrimaryDistance2:Number = Number.POSITIVE_INFINITY;
			var maxPrimaryDistance2:Number = Number.POSITIVE_INFINITY;
			var secondaryDistance2:Number = Number.POSITIVE_INFINITY;
			var onSameAxis2:Boolean = false;
		}
		else
		{
			object2.getBounds(object2.stage, rect);
			minPrimaryDistance2 = calculateMinPrimaryAxisDistanceForRelativePosition(focusedRect, rect, relativePosition);
			maxPrimaryDistance2 = calculateMaxPrimaryAxisDistanceForRelativePosition(focusedRect, rect, relativePosition);
			secondaryDistance2 = calculateSecondaryAxisDistanceForRelativePosition(focusedRect, rect, relativePosition);
			onSameAxis2 = itemsAreOnSameAxis(focusedRect, rect, relativePosition);
		}

		Pool.putRectangle(rect);

		if(onSameAxis1 && onSameAxis2)
		{
			//if they're both on the same axis as the current focus,
			//choose the closer object (using minimum distances)
			return minPrimaryDistance1 > 0 && minPrimaryDistance1 < minPrimaryDistance2;
		}
		var isVertical:Boolean = relativePosition === RelativePosition.TOP || relativePosition === RelativePosition.BOTTOM;
		if(onSameAxis1)
		{
			if(isVertical)
			{
				if(minPrimaryDistance1 > 0 && minPrimaryDistance1 < maxPrimaryDistance2)
				{
					//as long as the min distance of 1 is closer than the
					//max distance of 2, it is a better focus
					return true;
				}
				//however, we may prefer items that aren't on the same axis
				//to become focus, if they are close enough on the opposite
				//axis instead. only vertically, though.
			}
			else //horizontal
			{
				//since we read text horizontally before vertically, being
				//on the same axis horizontally always takes precedence.
				return true;
			}
		}
		else if(onSameAxis2)
		{
			//see comments in previous condition above for details
			if(isVertical)
			{
				if(minPrimaryDistance2 > 0 && minPrimaryDistance2 < maxPrimaryDistance1)
				{
					return false;
				}
			}
			else //horizontal
			{
				return false;
			}
		}
		//neither is on the same axis as the current focus
		//(or one may be on the same axis vertically, but isn't closer than the other)

		//this is how android makes a best guess
		var weightedDistance1:Number = 13 * minPrimaryDistance1 * minPrimaryDistance1 +
			secondaryDistance1 * secondaryDistance1;
		var weightedDistance2:Number = 13 * minPrimaryDistance2 * minPrimaryDistance2 +
			secondaryDistance2 * secondaryDistance2;
		return weightedDistance1 < weightedDistance2;
	}
}

import feathers.layout.RelativePosition;

import flash.geom.Rectangle;

function calculateSecondaryAxisDistanceForRelativePosition(globalRect1:Rectangle, globalRect2:Rectangle, position:String):Number
{
	if(position === RelativePosition.TOP || position === RelativePosition.BOTTOM)
	{
		return Math.abs((globalRect1.x + globalRect1.width / 2) - (globalRect2.x + globalRect2.width / 2));
	}
	//left or right
	return Math.abs((globalRect1.y + globalRect1.height / 2) - (globalRect2.y + globalRect2.height / 2));
}

function calculateMaxPrimaryAxisDistanceForRelativePosition(globalRect1:Rectangle, globalRect2:Rectangle, position:String):Number
{
	switch(position)
	{
		case RelativePosition.TOP:
		{
			if(globalRect1.bottom > globalRect2.bottom || globalRect1.y >= globalRect2.bottom)
			{
				var result:Number = globalRect1.bottom - globalRect2.y;
				if(result > 0)
				{
					return result;
				}
			}
			break;
		}
		case RelativePosition.RIGHT:
		{
			if(globalRect1.x < globalRect2.x || globalRect1.right <= globalRect2.x)
			{
				result = globalRect2.right - globalRect1.x;
				if(result > 0)
				{
					return result;
				}
			}
			break;
		}
		case RelativePosition.BOTTOM:
		{
			if(globalRect1.y < globalRect2.y || globalRect1.bottom <= globalRect2.y)
			{
				result = globalRect2.bottom - globalRect1.y;
				if(result > 0)
				{
					return result;
				}
			}
			break;
		}
		case RelativePosition.LEFT:
		{
			if(globalRect1.right > globalRect2.right || globalRect1.x >= globalRect2.right)
			{
				result = globalRect1.right - globalRect2.x;
				if(result > 0)
				{
					return result;
				}
			}
			break;
		}
	}
	return Number.POSITIVE_INFINITY;
}

function calculateMinPrimaryAxisDistanceForRelativePosition(globalRect1:Rectangle, globalRect2:Rectangle, position:String):Number
{
	switch(position)
	{
		case RelativePosition.TOP:
		{
			if(globalRect1.bottom > globalRect2.bottom || globalRect1.y >= globalRect2.bottom)
			{
				var result:Number = globalRect1.bottom - globalRect2.bottom;
				if(result > 0)
				{
					return result;
				}
			}
			break;
		}
		case RelativePosition.RIGHT:
		{
			if(globalRect1.x < globalRect2.x || globalRect1.right <= globalRect2.x)
			{
				result = globalRect2.x - globalRect1.x;
				if(result > 0)
				{
					return result;
				}
			}
			break;
		}
		case RelativePosition.BOTTOM:
		{
			if(globalRect1.y < globalRect2.y || globalRect1.bottom <= globalRect2.y)
			{
				result = globalRect2.y - globalRect1.y;
				if(result > 0)
				{
					return result;
				}
			}
			break;
		}
		case RelativePosition.LEFT:
		{
			if(globalRect1.right > globalRect2.right || globalRect1.x >= globalRect2.right)
			{
				result = globalRect1.right - globalRect2.right;
				if(result > 0)
				{
					return result;
				}
			}
			break;
		}
	}
	return Number.POSITIVE_INFINITY;
}

function itemsAreOnSameAxis(globalRect1:Rectangle, globalRect2:Rectangle, position:String):Boolean
{
	if(position === RelativePosition.TOP || position === RelativePosition.BOTTOM)
	{
		return globalRect1.x <= globalRect2.right && globalRect2.x <= globalRect1.right;
	}
	//left or right
	return globalRect1.y <= globalRect2.bottom && globalRect2.y <= globalRect1.bottom;
}