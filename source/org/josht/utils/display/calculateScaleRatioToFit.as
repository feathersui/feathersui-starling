package org.josht.utils.display
{
	public function calculateScaleRatioToFit(originalWidth:Number, originalHeight:Number, targetWidth:Number, targetHeight:Number):Number
	{
		var widthRatio:Number = targetWidth / originalWidth;
		var heightRatio:Number = targetHeight / originalHeight;
		return Math.min(widthRatio, heightRatio);
	}
}