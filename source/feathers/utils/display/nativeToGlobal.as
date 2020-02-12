/*
Feathers
Copyright 2012-2020 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.utils.display
{
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import starling.core.Starling;

	/**
	 * Converts from native coordinates to Starling global coordinates.
	 *
	 * @productversion Feathers 3.5.0
	 */
	public function nativeToGlobal(nativePosition:Point, starling:Starling = null, result:Point = null):Point
	{
		if(starling === null)
		{
			starling = Starling.current;
		}

		var nativeScaleFactor:Number = 1;
		if(starling.supportHighResolutions)
		{
			nativeScaleFactor = starling.nativeStage.contentsScaleFactor;
		}
		var scaleFactor:Number = starling.contentScaleFactor / nativeScaleFactor;

		var viewPort:Rectangle = starling.viewPort;
		var resultX:Number = (nativePosition.x - viewPort.x) / scaleFactor;
		var resultY:Number = (nativePosition.y - viewPort.y) / scaleFactor;

		if(result === null)
		{
			result = new Point(resultX, resultY);
		}
		else
		{
			result.setTo(resultX, resultY);
		}
		return result;
	}
}
