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
package org.josht.starling.display
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.utils.transformCoords;
	
	public class Sprite extends starling.display.Sprite implements IDisplayObjectWithScrollRect
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
			resultRect = super.getBounds(targetSpace, resultRect);
			if(this._scrollRect)
			{
				if(targetSpace == this)
				{
					resultRect.width = this._scrollRect.width;
					resultRect.height = this._scrollRect.height;
				}
				else
				{
					this.getTransformationMatrix(targetSpace, helperMatrix);
					resultRect.width = helperMatrix.a * this._scrollRect.width + helperMatrix.c * this._scrollRect.height;
					resultRect.height = helperMatrix.d * this._scrollRect.height + helperMatrix.b * this._scrollRect.width;
				}
			}
			
			return resultRect;
		}
		
		override public function render(support:RenderSupport, alpha:Number):void
		{
			if(this._scrollRect)
			{
				support.finishQuadBatch();
				this.getBounds(this.stage, helperRect);
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
				if (forTouch && (!visible || !touchable))
					return null;
				
				//make sure we're in the bounds of this sprite first
				if(!this.getBounds(this, helperRect).containsPoint(localPoint))
				{
					return null;
				}
				
				//now, check each of the children
				var localX:Number = localPoint.x + this._scrollRect.x;
				var localY:Number = localPoint.y + this._scrollRect.y;
				
				var numChildren:int = this.numChildren
				for (var i:int=numChildren-1; i>=0; --i) // front to back!
				{
					var child:DisplayObject = this.getChildAt(i);
					getTransformationMatrix(child, helperMatrix);
					
					transformCoords(helperMatrix, localX, localY, helperPoint);
					var target:DisplayObject = child.hitTest(helperPoint, forTouch);
					
					if (target) return target;
				}
				
				return null;
			}
			return super.hitTest(localPoint, forTouch);
		}
	}
}