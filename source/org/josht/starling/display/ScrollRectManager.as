package org.josht.starling.display
{
	import flash.geom.Rectangle;
	
	import spark.primitives.Rect;

	internal class ScrollRectManager
	{
		public static var scrollRectOffsetX:Number = 0;
		public static var scrollRectOffsetY:Number = 0;
		public static var currentScissorRect:Rectangle;
	}
}