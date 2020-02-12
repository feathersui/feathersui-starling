/*
Feathers
Copyright 2012-2020 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.utils.display
{
	/**
	 * Calculates a scale value to maintain aspect ratio and fill the required
	 * bounds (with the possibility of cutting of the edges a bit).
	 *
	 * @productversion Feathers 1.0.0
	 */
	public function calculateScaleRatioToFill(originalWidth:Number, originalHeight:Number, targetWidth:Number, targetHeight:Number):Number
	{
		var widthRatio:Number = targetWidth / originalWidth;
		var heightRatio:Number = targetHeight / originalHeight;
		if(widthRatio > heightRatio)
		{
			return widthRatio;
		}
		return heightRatio;
	}
}