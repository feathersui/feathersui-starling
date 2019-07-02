/*
Feathers
Copyright 2012-2019 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.layout
{
	import starling.display.DisplayObject;
	import flash.geom.Rectangle;

	/**
	 * Methods for layouts that support drag and drop.
	 */
	public interface IDragDropLayout extends ILayout
	{
		/**
		 * Returns the index of the item if it were dropped at the specified
		 * location.
		 */
		function getDropIndex(x:Number, y:Number, items:Vector.<DisplayObject>,
			boundsX:Number, boundsY:Number, width:Number, height:Number):int;

		/**
		 * Positions the drop indicator in the layout. Must be called after
		 * <code>layout()</code>.
		 */
		function positionDropIndicator(dropIndicator:DisplayObject, index:int,
			x:Number, y: Number, items:Vector.<DisplayObject>, width:Number, height:Number):void;
	}
}