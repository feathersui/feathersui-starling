/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.utils.geom
{
	import flash.geom.Matrix;

	/**
	 * Extracts the x scale value from a <code>flash.geom.Matrix</code>
	 *
	 * @see flash.geom.Matrix
	 */
	public function matrixToScaleX(matrix:Matrix):Number
	{
		var a:Number = matrix.a;
		var b:Number = matrix.b;
		return Math.sqrt(a * a + b * b);
	}
}
