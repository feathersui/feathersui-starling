package org.josht.starling.display
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import spark.primitives.Rect;
	
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.utils.transformCoords;
	
	public class Sprite extends starling.display.Sprite
	{
		private static var helperPoint:Point = new Point();
		private static var helperMatrix:Matrix = new Matrix();
		private static var helperRect:Rectangle = new Rectangle();
		
		public function Sprite()
		{
			super();
		}
		
		private var _scrollRect:Rectangle;
		
		public function get scrollRect():Rectangle
		{
			return this._scrollRect;
		}
		
		public function set scrollRect(value:Rectangle):void
		{
			this._scrollRect = value;
		}
		
		override public function getBounds(targetSpace:DisplayObject, resultRect:Rectangle=null):Rectangle
		{
			if(this._scrollRect)
			{
				if(!resultRect)
				{
					resultRect = new Rectangle();
				}
				if(targetSpace == this)
				{
					resultRect.x = 0;
					resultRect.y = 0;
					resultRect.width = this._scrollRect.width;
					resultRect.height = this._scrollRect.height;
				}
				else
				{
					this.getTransformationMatrix(targetSpace, helperMatrix);
					
					helperPoint.x = -this._scrollRect.x;
					helperPoint.y = -this._scrollRect.y;
					transformCoords(helperMatrix, helperPoint.x, helperPoint.y, helperPoint);
					resultRect.x = helperPoint.x;
					resultRect.y = helperPoint.y;
					
					helperPoint.x = this._scrollRect.width - this._scrollRect.x;
					helperPoint.y = this._scrollRect.height - this._scrollRect.y;
					transformCoords(helperMatrix, helperPoint.x, helperPoint.y, helperPoint);
					resultRect.width = helperPoint.x - resultRect.x;
					resultRect.height = helperPoint.y - resultRect.y;
				}
				return resultRect;
			}
			
			return super.getBounds(targetSpace, resultRect);
		}
		
		override public function render(support:RenderSupport, alpha:Number):void
		{
			if(this._scrollRect)
			{
				support.finishQuadBatch();
				this.getBounds(this.stage, helperRect);
				helperRect.x += this._scrollRect.x * this.scaleX;
				helperRect.y += this._scrollRect.y * this.scaleY;
				support.translateMatrix(-this._scrollRect.x, -this._scrollRect.y);
				Starling.context.setScissorRectangle(helperRect);
			}
			super.render(support, alpha);
			if(this._scrollRect)
			{
				support.finishQuadBatch();
				support.translateMatrix(this._scrollRect.x, this._scrollRect.y);
				Starling.context.setScissorRectangle(null);
			}
		}
		
		override public function hitTest(localPoint:Point, forTouch:Boolean = false):DisplayObject
		{
			if(this._scrollRect)
			{
				const originalBounds:Rectangle = super.getBounds(this, helperRect);
				localPoint.x += this._scrollRect.x;
				localPoint.y += this._scrollRect.y;
				if(this._scrollRect.contains(localPoint.x, localPoint.y) &&
					originalBounds.contains(localPoint.x, localPoint.y))
				{
					return this;
				}
				return null;
			}
			return super.hitTest(localPoint, forTouch);
		}
	}
}