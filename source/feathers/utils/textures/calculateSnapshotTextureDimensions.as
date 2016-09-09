/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.utils.textures
{
	import flash.display3D.Context3DProfile;
	import flash.geom.Point;

	import starling.core.Starling;
	import starling.utils.MathUtil;

	/**
	 * Calculates the dimensions of the texture needed to display an item with
	 * the specified width and height, accepting a maximum where the snapshot
	 * must be split into multiple textures. If Starling's profile is
	 * <code>Context3DProfile.BASELINE_CONSTRAINED</code>, will calculate
	 * power-of-two dimensions for the texture.
	 */
	public function calculateSnapshotTextureDimensions(width:Number, height:Number, maximum:Number = 2048, starling:Starling = null, result:Point = null):Point
	{
		var snapshotWidth:Number = width;
		var snapshotHeight:Number = height;
		if(starling === null)
		{
			starling = Starling.current;
		}
		var supportsRectangleTexture:Boolean = starling.profile !== Context3DProfile.BASELINE_CONSTRAINED;
		if(!supportsRectangleTexture)
		{
			if(snapshotWidth > maximum)
			{
				snapshotWidth = int(snapshotWidth / maximum) * maximum + MathUtil.getNextPowerOfTwo(snapshotWidth % maximum);
			}
			else
			{
				snapshotWidth = MathUtil.getNextPowerOfTwo(snapshotWidth);
			}
		}
		else if(snapshotWidth > maximum)
		{
			snapshotWidth = int(snapshotWidth / maximum) * maximum + (snapshotWidth % maximum);
		}
		if(!supportsRectangleTexture)
		{
			if(snapshotHeight > maximum)
			{
				snapshotHeight = int(snapshotHeight / maximum) * maximum + MathUtil.getNextPowerOfTwo(snapshotHeight % maximum);
			}
			else
			{
				snapshotHeight = MathUtil.getNextPowerOfTwo(snapshotHeight);
			}
		}
		else if(snapshotHeight > maximum)
		{
			snapshotHeight = int(snapshotHeight / maximum) * maximum + (snapshotHeight % maximum);
		}
		if(result === null)
		{
			result = new Point(snapshotWidth, snapshotHeight);
		}
		else
		{
			result.setTo(snapshotWidth, snapshotHeight);
		}
		return result;
	}
}
