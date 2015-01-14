/*
Feathers
Copyright 2012-2015 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.utils.display
{
	/**
	 * Calculates a scale value to maintain aspect ratio and fit inside the
	 * required bounds (with the possibility of a bit of empty space on the
	 * edges).
	 */
	public function calculateScaleRatioToFit(originalWidth:Number, originalHeight:Number, targetWidth:Number, targetHeight:Number):Number
	{
		var widthRatio:Number = targetWidth / originalWidth;
		var heightRatio:Number = targetHeight / originalHeight;
		if(widthRatio < heightRatio)
		{
			return widthRatio;
		}
		return heightRatio;
	}
}