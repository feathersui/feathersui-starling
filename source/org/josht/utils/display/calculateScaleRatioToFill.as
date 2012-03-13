package org.josht.utils.display
{
	public function calculateScaleRatioToFill(originalWidth:Number, originalHeight:Number, targetWidth:Number, targetHeight:Number):Number
	{
		var widthRatio:Number = targetWidth / originalWidth;
		var heightRatio:Number = targetHeight / originalHeight;
		return Math.max(widthRatio, heightRatio);
	}
}