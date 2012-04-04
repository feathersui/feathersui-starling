package org.josht.starling.display
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.display.DisplayObject;
	
	public class ScrollRectManager
	{
		public static var scrollRectOffsetX:Number = 0;
		public static var scrollRectOffsetY:Number = 0;
		public static var currentScissorRect:Rectangle;
		
		public static function adjustTouchLocation(location:Point, target:DisplayObject):void
		{
			var matrix:Matrix;
			var newTarget:DisplayObject = target;
			while(newTarget.parent)
			{
				newTarget = newTarget.parent;
				if(newTarget is IDisplayObjectWithScrollRect)
				{
					var targetWithScrollRect:IDisplayObjectWithScrollRect = IDisplayObjectWithScrollRect(newTarget);
					var scrollRect:Rectangle = targetWithScrollRect.scrollRect;
					if(!scrollRect || (scrollRect.x == 0 && scrollRect.y == 0))
					{
						continue;
					}
					matrix = newTarget.getTransformationMatrix(target, matrix);
					location.x += scrollRect.x * matrix.a;
					location.y += scrollRect.y * matrix.d;
				}
			}
		}
	}
}