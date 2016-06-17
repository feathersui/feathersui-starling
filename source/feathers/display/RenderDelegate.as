/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.display
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import starling.display.DisplayObject;
	import starling.rendering.Painter;
	import starling.utils.MatrixUtil;
	import starling.utils.Pool;

	/**
	 * Passes rendering to another display object, but provides its own separate
	 * transformation.
	 * 
	 * <p>Touching the delegate does not pass touches to the target. The
	 * delegate is a separate display object. However, interacting with the
	 * target may affect the rendering of the delegate.</p>
	 */
	public class RenderDelegate extends DisplayObject
	{
		/**
		 * @private
		 */
		private static const HELPER_POINT:Point = new Point();

		/**
		 * Constructor.
		 */
		public function RenderDelegate(target:DisplayObject)
		{
			this.target = target;
		}

		/**
		 * @private
		 */
		protected var _target:DisplayObject;

		/**
		 * The displaying object being rendered.
		 */
		public function get target():DisplayObject
		{
			return this._target;
		}

		/**
		 * @private
		 */
		public function set target(value:DisplayObject):void
		{
			if(this._target === value)
			{
				return;
			}
			this._target = value;
			this.setRequiresRedraw();
		}

		/**
		 * @private
		 */
		override public function getBounds(targetSpace:DisplayObject, resultRect:Rectangle = null):Rectangle
		{
			resultRect = this._target.getBounds(this._target, resultRect);
			var matrix:Matrix = Pool.getMatrix();
			this.getTransformationMatrix(targetSpace, matrix);
			var minX:Number = Number.MAX_VALUE;
			var maxX:Number = -Number.MAX_VALUE;
			var minY:Number = Number.MAX_VALUE;
			var maxY:Number = -Number.MAX_VALUE;
			for(var i:int = 0; i < 4; i++)
			{
				MatrixUtil.transformCoords(matrix, i % 2 == 0 ? 0 : resultRect.width, i < 2 ? 0 : resultRect.height, HELPER_POINT);
				if(HELPER_POINT.x < minX)
				{
					minX = HELPER_POINT.x;
				}
				if(HELPER_POINT.x > maxX)
				{
					maxX = HELPER_POINT.x;
				}
				if(HELPER_POINT.y < minY)
				{
					minY = HELPER_POINT.y;
				}
				if(HELPER_POINT.y > maxY)
				{
					maxY = HELPER_POINT.y;
				}
			}
			Pool.putMatrix(matrix);
			resultRect.setTo(minX, minY, maxX - minX, maxY - minY);
			return resultRect;
		}

		/**
		 * @private
		 */
		override public function render(painter:Painter):void
		{
			this._target.setRequiresRedraw();
			var oldAlpha:Number = this._target.alpha;
			this._target.alpha = this.alpha;
			this._target.render(painter);
			this._target.alpha = oldAlpha;
		}
	}
}
