/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.utils.skins
{
	import feathers.core.IMeasureDisplayObject;

	import starling.display.DisplayObject;

	public function resetFluidChildDimensionsForMeasurement(skin:DisplayObject,
		parentExplicitWidth:Number, parentExplicitHeight:Number,
		parentExplicitMinWidth:Number, parentExplicitMinHeight:Number,
		skinExplicitWidth:Number, skinExplicitHeight:Number,
		skinExplicitMinWidth:Number, skinExplicitMinHeight:Number):void
	{
		if(skin === null)
		{
			return;
		}
		var needsWidth:Boolean = parentExplicitWidth !== parentExplicitWidth; //isNaN
		var needsHeight:Boolean = parentExplicitHeight !== parentExplicitHeight; //isNaN
		if(needsWidth)
		{
			skin.width = skinExplicitWidth;
		}
		else
		{
			skin.width = parentExplicitWidth;
		}
		if(needsHeight)
		{
			skin.height = skinExplicitHeight;
		}
		else
		{
			skin.height = parentExplicitHeight;
		}
		var measureSkin:IMeasureDisplayObject = skin as IMeasureDisplayObject;
		if(measureSkin !== null)
		{
			var skinMinWidth:Number = parentExplicitMinWidth;
			if(skinMinWidth !== skinMinWidth || //isNaN
				skinExplicitMinWidth > skinMinWidth)
			{
				skinMinWidth = skinExplicitMinWidth;
			}
			measureSkin.minWidth = skinMinWidth;
			var skinMinHeight:Number = parentExplicitMinHeight;
			if(skinMinHeight !== skinMinHeight || //isNaN
				skinExplicitMinHeight > skinMinHeight)
			{
				skinMinHeight = skinExplicitMinHeight;
			}
			measureSkin.minHeight = skinMinHeight;
		}
	}
}
