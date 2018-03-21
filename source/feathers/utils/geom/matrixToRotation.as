/*
Feathers
Copyright 2012-2018 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.utils.geom
{
	import flash.geom.Matrix;

	/**
	 * Extracts the rotation value (in radians) from a <code>flash.geom.Matrix</code>
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/geom/Matrix.html flash.geom.Matrix
	 *
	 * @productversion Feathers 1.2.0
	 */
	public function matrixToRotation(matrix:Matrix):Number
	{
		var c:Number = matrix.c;
		var d:Number = matrix.d;
		return -Math.atan(c / d);
	}
}
