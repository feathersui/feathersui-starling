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
		return Math.min(widthRatio, heightRatio);
	}
}