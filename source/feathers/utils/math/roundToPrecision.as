/*
Feathers
Copyright 2012-2019 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.utils.math
{
	/**
	 * Rounds a number to a certain level of precision. Useful for limiting the number of
	 * decimal places on a fractional number.
	 * 
	 * @param		number		the input number to round.
	 * @param		precision	the number of decimal digits to keep
	 * @return		the rounded number, or the original input if no rounding is needed
	 * 
	 * @see Math#round
	 *
	 * @productversion Feathers 1.0.0
	 */
	public function roundToPrecision(number:Number, precision:int = 0):Number
	{
		var decimalPlaces:Number = Math.pow(10, precision);
		return Math.round(decimalPlaces * number) / decimalPlaces;
	}
}