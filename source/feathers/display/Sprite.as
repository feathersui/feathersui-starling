/*
Copyright (c) 2012 Josh Tynjala

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
*/
package feathers.display
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.utils.MatrixUtil;

	/**
	 * Adds <code>scrollRect</code> to <code>Sprite</code>.
	 */
	public class Sprite extends starling.display.Sprite implements IDisplayObjectWithScrollRect
	{
		private static var helperPoint:Point = new Point();
		private static var helperMatrix:Matrix = new Matrix();
		private static var helperRect:Rectangle = new Rectangle();
		
		/**
		 * Constructor.
		 */
		public function Sprite()
		{
			super();
		}
		
		/**
		 * @private
		 */
		private var _scrollRect:Rectangle;
		
		/**
		 * @inheritDoc
		 */
		public function get scrollRect():Rectangle
		{
			return this._scrollRect;
		}
		
		/**
		 * @private
		 */
		public function set scrollRect(value:Rectangle):void
		{
			this._scrollRect = value;
			if(this._scrollRect)
			{
				if(!this._scaledScrollRectXY)
				{
					this._scaledScrollRectXY = new Point();
				}
				if(!this._scissorRect)
				{
					this._scissorRect = new Rectangle();
				}
			}
			else
			{
				this._scaledScrollRectXY = null;
				this._scissorRect = null;
			}
		}
		
		private var _scaledScrollRectXY:Point;
		private var _scissorRect:Rectangle;
		
		/**
		 * @inheritDoc
		 */
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
					MatrixUtil.transformCoords(helperMatrix, 0, 0, helperPoint);
					resultRect.x = helperPoint.x;
					resultRect.y = helperPoint.y;
					resultRect.width = helperMatrix.a * this._scrollRect.width + helperMatrix.c * this._scrollRect.height;
					resultRect.height = helperMatrix.d * this._scrollRect.height + helperMatrix.b * this._scrollRect.width;
				}
				return resultRect;
			}
			
			return super.getBounds(targetSpace, resultRect);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function render(support:RenderSupport, alpha:Number):void
		{
			if(this._scrollRect)
			{
				const scale:Number = Starling.contentScaleFactor;
				this.getBounds(this.stage, this._scissorRect);
				this._scissorRect.x *= scale;
				this._scissorRect.y *= scale;
				this._scissorRect.width *= scale;
				this._scissorRect.height *= scale;
				
				this.getTransformationMatrix(this.stage, helperMatrix);
				this._scaledScrollRectXY.x = this._scrollRect.x * helperMatrix.a;
				this._scaledScrollRectXY.y = this._scrollRect.y * helperMatrix.d;
				
				const oldRect:Rectangle = ScrollRectManager.currentScissorRect;
				if(oldRect)
				{
					this._scissorRect.x += ScrollRectManager.scrollRectOffsetX * scale;
					this._scissorRect.y += ScrollRectManager.scrollRectOffsetY * scale;
					this._scissorRect = this._scissorRect.intersection(oldRect);
				}
				//isEmpty() && <= 0 don't work here for some reason
				if(this._scissorRect.width < 1 || this._scissorRect.height < 1 ||
					this._scissorRect.x >= Starling.current.nativeStage.stageWidth ||
					this._scissorRect.y >= Starling.current.nativeStage.stageHeight ||
					(this._scissorRect.x + this._scissorRect.width) <= 0 ||
					(this._scissorRect.y + this._scissorRect.height) <= 0)
				{
					return;
				}
				support.finishQuadBatch();
				Starling.context.setScissorRectangle(this._scissorRect);
				ScrollRectManager.currentScissorRect = this._scissorRect;
				ScrollRectManager.scrollRectOffsetX -= this._scaledScrollRectXY.x;
				ScrollRectManager.scrollRectOffsetY -= this._scaledScrollRectXY.y;
				support.translateMatrix(-this._scrollRect.x, -this._scrollRect.y);
			}
			super.render(support, alpha);
			if(this._scrollRect)
			{
				support.finishQuadBatch();
				support.translateMatrix(this._scrollRect.x, this._scrollRect.y);
				ScrollRectManager.scrollRectOffsetX += this._scaledScrollRectXY.x;
				ScrollRectManager.scrollRectOffsetY += this._scaledScrollRectXY.y;
				ScrollRectManager.currentScissorRect = oldRect;
				Starling.context.setScissorRectangle(oldRect);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function hitTest(localPoint:Point, forTouch:Boolean = false):DisplayObject
		{
			if(this._scrollRect)
			{
				//make sure we're in the bounds of this sprite first
				if(this.getBounds(this, helperRect).containsPoint(localPoint))
				{
					localPoint.x += this._scrollRect.x;
					localPoint.y += this._scrollRect.y;
					var result:DisplayObject = super.hitTest(localPoint, forTouch);
					localPoint.x -= this._scrollRect.x;
					localPoint.y -= this._scrollRect.y;
					return result;
				}
				return null;
			}
			return super.hitTest(localPoint, forTouch);
		}
	}
}