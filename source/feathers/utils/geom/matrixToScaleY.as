/*
Feathers
Copyright 2012-2015 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.utils.geom
{
	import flash.geom.Matrix;

	/**
	 * Extracts the y scale value from a <code>flash.geom.Matrix</code>
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/geom/Matrix.html flash.geom.Matrix
	 */
	public function matrixToScaleY(matrix:Matrix):Number
	{
		var c:Number = matrix.c;
		var d:Number = matrix.d;
		return Math.sqrt(c * c + d * d);
	}
}
