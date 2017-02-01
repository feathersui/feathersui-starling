/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.utils.math
{
	/**
	 * Rounds a Number <em>down</em> to the nearest multiple of an input. For example, by rounding
	 * 16 down to the nearest 10, you will receive 10. Similar to the built-in function Math.floor().
	 * 
	 * @param	numberToRound		the number to round down
	 * @param	nearest				the number whose mutiple must be found
	 * @return	the rounded number
	 * 
	 * @see Math#floor
	 *
	 * @productversion Feathers 1.0.0
	 */
	public function roundDownToNearest(number:Number, nearest:Number = 1):Number
	{
		if(nearest == 0)
		{
			return number;
		}
		return Math.floor(roundToPrecision(number / nearest, 10)) * nearest;
	}
}