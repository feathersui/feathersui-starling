package org.josht.utils.math
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
	 */
	public function roundToPrecision(number:Number, precision:int = 0):Number
	{
		var decimalPlaces:Number = Math.pow(10, precision);
		return Math.round(decimalPlaces * number) / decimalPlaces;
	}
}