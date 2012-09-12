package feathers.display
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import starling.display.DisplayObject;

	/**
	 * Utilities for working with display objects that have a <code>scrollRect</code>.
	 *
	 * @see IDisplayObjectWithScrollRect
	 */
	public class ScrollRectManager
	{
		/**
		 * @private
		 */
		public static var scrollRectOffsetX:Number = 0;

		/**
		 * @private
		 */
		public static var scrollRectOffsetY:Number = 0;

		/**
		 * @private
		 */
		public static var currentScissorRect:Rectangle;

		/**
		 * Adjusts the result of the <code>getLocation()</code> method on the
		 * <code>Touch</code> class to account for <code>scrollRect</code> on
		 * the target's parent or any other containing display object.
		 *
		 * @see starling.events.Touch#getLocation()
		 */
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

		/**
		 * Corrects a transformed point in the target coordinate system that has
		 * been affected by <code>scrollRect</code> to stage coordinates.
		 */
		public static function toStageCoordinates(location:Point, target:DisplayObject):void
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
					location.x -= scrollRect.x * matrix.a;
					location.y -= scrollRect.y * matrix.d;
				}
			}
		}

		/**
		 * Enhances <code>getBounds()</code> with correction for <code>scrollRect</code>
		 * offsets.
		 */
		public static function getBounds(object:DisplayObject, targetSpace:DisplayObject, result:Rectangle = null):Rectangle
		{
			if(!result)
			{
				result = new Rectangle();
			}

			object.getBounds(targetSpace, result);

			var matrix:Matrix;
			var newTarget:DisplayObject = object;
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
					matrix = newTarget.getTransformationMatrix(object, matrix);
					result.x -= scrollRect.x * matrix.a;
					result.y -= scrollRect.y * matrix.d;
				}
			}
			return result;
		}
	}
}