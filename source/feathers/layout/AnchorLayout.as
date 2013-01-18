/*
 Feathers
 Copyright (c) 2012 Josh Tynjala. All Rights Reserved.

 This program is free software. You can redistribute and/or modify it in
 accordance with the terms of the accompanying license agreement.
 */
package feathers.layout
{
	import flash.errors.IllegalOperationError;
	import flash.geom.Point;

	import starling.display.DisplayObject;
	import starling.events.EventDispatcher;

	/**
	 * Positions and sizes items based on anchor positions.
	 *
	 * @see http://wiki.starling-framework.org/feathers/anchor-layout
	 * @see AnchorLayoutData
	 */
	public class AnchorLayout extends EventDispatcher implements ILayout
	{
		/**
		 * @private
		 */
		protected static const CIRCULAR_REFERENCE_ERROR:String = "It is impossible to create this layout due to a circular reference in the AnchorLayoutData.";

		/**
		 * @private
		 */
		private static const HELPER_POINT:Point = new Point();

		/**
		 * Constructor.
		 */
		public function AnchorLayout()
		{
		}

		/**
		 * @private
		 */
		protected var _helperVector1:Vector.<DisplayObject> = new <DisplayObject>[];

		/**
		 * @private
		 */
		protected var _helperVector2:Vector.<DisplayObject> = new <DisplayObject>[];

		/**
		 * @inheritDoc
		 */
		public function layout(items:Vector.<DisplayObject>, viewPortBounds:ViewPortBounds = null, result:LayoutBoundsResult = null):LayoutBoundsResult
		{
			const boundsX:Number = viewPortBounds ? viewPortBounds.x : 0;
			const boundsY:Number = viewPortBounds ? viewPortBounds.y : 0;
			const minWidth:Number = viewPortBounds ? viewPortBounds.minWidth : 0;
			const minHeight:Number = viewPortBounds ? viewPortBounds.minHeight : 0;
			const maxWidth:Number = viewPortBounds ? viewPortBounds.maxWidth : Number.POSITIVE_INFINITY;
			const maxHeight:Number = viewPortBounds ? viewPortBounds.maxHeight : Number.POSITIVE_INFINITY;
			const explicitWidth:Number = viewPortBounds ? viewPortBounds.explicitWidth : NaN;
			const explicitHeight:Number = viewPortBounds ? viewPortBounds.explicitHeight : NaN;

			var viewPortWidth:Number = explicitWidth;
			var viewPortHeight:Number = explicitHeight;

			const needsWidth:Boolean = isNaN(explicitWidth);
			const needsHeight:Boolean = isNaN(explicitHeight);
			if(needsWidth || needsHeight)
			{
				this.measureViewPort(viewPortWidth, viewPortHeight, HELPER_POINT);
				if(needsWidth)
				{
					viewPortWidth = Math.min(maxWidth, Math.max(minWidth, HELPER_POINT.x));
				}
				if(needsHeight)
				{
					viewPortHeight = Math.min(maxHeight, Math.max(minHeight, HELPER_POINT.y));
				}
			}

			this.layoutWithBounds(items, boundsX, boundsY, viewPortWidth, viewPortHeight);

			if(!result)
			{
				result = new LayoutBoundsResult();
			}
			result.contentWidth = viewPortWidth;
			result.contentHeight = viewPortHeight;
			result.viewPortWidth = viewPortWidth;
			result.viewPortHeight = viewPortHeight;
			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function getScrollPositionForIndex(index:int, items:Vector.<DisplayObject>, x:Number, y:Number, width:Number, height:Number, result:Point = null):Point
		{
			if(!result)
			{
				result = new Point();
			}
			result.x = 0;
			result.y = 0;
			return result;
		}

		/**
		 * @private
		 */
		protected function measureViewPort(viewPortWidth:Number, viewPortHeight:Number, result:Point = null):Point
		{
			if(!result)
			{
				result = new Point();
			}
			result.x = 0;
			result.y = 0;
			return result;
		}

		/**
		 * @private
		 */
		protected function layoutWithBounds(items:Vector.<DisplayObject>, x:Number, y:Number, width:Number, height:Number):void
		{
			this._helperVector1.length = 0;
			this._helperVector2.length = 0;
			var mainVector:Vector.<DisplayObject> = items;
			var otherVector:Vector.<DisplayObject> = this._helperVector1;
			this.layoutVector(items, otherVector, x, y, width, height);
			var currentLength:Number = otherVector.length;
			while(currentLength > 0)
			{
				if(otherVector == this._helperVector1)
				{
					mainVector = this._helperVector1;
					otherVector = this._helperVector2;
				}
				else
				{
					mainVector = this._helperVector2;
					otherVector = this._helperVector1;
				}
				this.layoutVector(mainVector, otherVector, x, y, width, height);
				var oldLength:Number = currentLength;
				currentLength = otherVector.length;
				if(oldLength == currentLength)
				{
					this._helperVector1.length = 0;
					this._helperVector2.length = 0;
					throw new IllegalOperationError(CIRCULAR_REFERENCE_ERROR);
				}
			}
			this._helperVector1.length = 0;
			this._helperVector2.length = 0;
		}

		/**
		 * @private
		 */
		protected function layoutVector(items:Vector.<DisplayObject>, unpositionedItems:Vector.<DisplayObject>, boundsX:Number, boundsY:Number, viewPortWidth:Number, viewPortHeight:Number):void
		{
			const itemCount:int = items.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:ILayoutDisplayObject = items[i] as ILayoutDisplayObject;
				if(!item)
				{
					continue;
				}
				var layoutData:AnchorLayoutData = item.layoutData as AnchorLayoutData;
				if(!layoutData)
				{
					continue;
				}

				var isReadyForLayout:Boolean = this.isReadyForLayout(layoutData, i, items, unpositionedItems);
				if(!isReadyForLayout)
				{
					unpositionedItems.push(item);
					continue;
				}

				this.positionHorizontally(item, layoutData, boundsX, boundsY, viewPortWidth, viewPortHeight);
				this.positionVertically(item, layoutData, boundsX, boundsY, viewPortWidth, viewPortHeight);
			}
		}

		/**
		 * @private
		 */
		protected function positionHorizontally(item:ILayoutDisplayObject, layoutData:AnchorLayoutData, boundsX:Number, boundsY:Number, viewPortWidth:Number, viewPortHeight:Number):void
		{
			var left:Number = layoutData.left;
			var hasLeftPosition:Boolean = !isNaN(left);
			if(hasLeftPosition)
			{
				var leftAnchorDisplayObject:DisplayObject = layoutData.leftAnchorDisplayObject;
				if(leftAnchorDisplayObject)
				{
					item.x = leftAnchorDisplayObject.x + leftAnchorDisplayObject.width + left;
				}
				else
				{
					item.x = boundsX + left;
				}
			}
			var right:Number = layoutData.right;
			var hasRightPosition:Boolean = !isNaN(right);
			if(hasRightPosition)
			{
				var rightAnchorDisplayObject:DisplayObject = layoutData.rightAnchorDisplayObject;
				if(hasLeftPosition)
				{
					var leftRightWidth:Number = viewPortWidth;
					if(rightAnchorDisplayObject)
					{
						leftRightWidth = rightAnchorDisplayObject.x;
					}
					if(leftAnchorDisplayObject)
					{
						leftRightWidth -= (leftAnchorDisplayObject.x + leftAnchorDisplayObject.width);
					}
					item.width = leftRightWidth - right - left;
				}
				else
				{
					if(rightAnchorDisplayObject)
					{
						item.x = rightAnchorDisplayObject.x - item.width - right;
					}
					else
					{
						item.x = boundsX + viewPortWidth - right - item.width;
					}
				}
			}
		}

		/**
		 * @private
		 */
		protected function positionVertically(item:ILayoutDisplayObject, layoutData:AnchorLayoutData, boundsX:Number, boundsY:Number, viewPortWidth:Number, viewPortHeight:Number):void
		{
			var top:Number = layoutData.top;
			var hasTopPosition:Boolean = !isNaN(top);
			if(hasTopPosition)
			{
				var topAnchorDisplayObject:DisplayObject = layoutData.topAnchorDisplayObject;
				if(topAnchorDisplayObject)
				{
					item.y = topAnchorDisplayObject.x + topAnchorDisplayObject.height + top;
				}
				else
				{
					item.y = boundsY + top;
				}
			}
			var bottom:Number = layoutData.bottom;
			var hasBottomPosition:Boolean = !isNaN(bottom);
			if(hasBottomPosition)
			{
				var bottomAnchorDisplayObject:DisplayObject = layoutData.bottomAnchorDisplayObject;
				if(hasTopPosition)
				{
					var topBottomHeight:Number = viewPortHeight;
					if(bottomAnchorDisplayObject)
					{
						topBottomHeight = bottomAnchorDisplayObject.y;
					}
					if(topAnchorDisplayObject)
					{
						topBottomHeight -= (topAnchorDisplayObject.y + topAnchorDisplayObject.height);
					}
					item.height = topBottomHeight - bottom - top;
				}
				else
				{
					if(bottomAnchorDisplayObject)
					{
						item.y = bottomAnchorDisplayObject.x - item.height - bottom;
					}
					else
					{
						item.y = boundsY + viewPortHeight - bottom - item.height;
					}
				}
			}
		}

		/**
		 * @private
		 */
		protected function isReadyForLayout(layoutData:AnchorLayoutData, index:int, items:Vector.<DisplayObject>, unpositionedItems:Vector.<DisplayObject>):Boolean
		{
			const lastIndex:int = index - 1;
			const leftAnchorDisplayObject:DisplayObject = layoutData.leftAnchorDisplayObject;
			if(leftAnchorDisplayObject && items.lastIndexOf(leftAnchorDisplayObject, lastIndex) >= 0 && unpositionedItems.indexOf(leftAnchorDisplayObject) >= 0)
			{
				return false;
			}
			const rightAnchorDisplayObject:DisplayObject = layoutData.rightAnchorDisplayObject;
			if(rightAnchorDisplayObject && items.lastIndexOf(rightAnchorDisplayObject, lastIndex) >= 0 && unpositionedItems.indexOf(rightAnchorDisplayObject) >= 0)
			{
				return false;
			}
			const topAnchorDisplayObject:DisplayObject = layoutData.topAnchorDisplayObject;
			if(topAnchorDisplayObject && items.lastIndexOf(topAnchorDisplayObject, lastIndex) >= 0 && unpositionedItems.indexOf(topAnchorDisplayObject) >= 0)
			{
				return false;
			}
			const bottomAnchorDisplayObject:DisplayObject = layoutData.bottomAnchorDisplayObject;
			if(bottomAnchorDisplayObject && items.lastIndexOf(bottomAnchorDisplayObject, lastIndex) >= 0 && unpositionedItems.indexOf(bottomAnchorDisplayObject) >= 0)
			{
				return false
			}
			return true;
		}
	}
}
