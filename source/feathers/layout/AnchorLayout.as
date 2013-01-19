/*
 Feathers
 Copyright (c) 2012 Josh Tynjala. All Rights Reserved.

 This program is free software. You can redistribute and/or modify it in
 accordance with the terms of the accompanying license agreement.
 */
package feathers.layout
{
	import feathers.layout.ILayoutData;

	import flash.errors.IllegalOperationError;
	import flash.geom.Point;

	import starling.display.DisplayObject;

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
				this.measureViewPort(items, viewPortWidth, viewPortHeight, HELPER_POINT);
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
		protected function measureViewPort(items:Vector.<DisplayObject>, viewPortWidth:Number, viewPortHeight:Number, result:Point = null):Point
		{
			this._helperVector1.length = 0;
			this._helperVector2.length = 0;
			HELPER_POINT.x = 0;
			HELPER_POINT.y = 0;
			var mainVector:Vector.<DisplayObject> = items;
			var otherVector:Vector.<DisplayObject> = this._helperVector1;
			this.measureVector(items, otherVector, HELPER_POINT);
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
				this.measureVector(mainVector, otherVector, HELPER_POINT);
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

			if(!result)
			{
				result = HELPER_POINT.clone();
			}
			return result;
		}

		/**
		 * @private
		 */
		protected function measureVector(items:Vector.<DisplayObject>, unpositionedItems:Vector.<DisplayObject>, result:Point = null):Point
		{
			if(!result)
			{
				result = new Point();
			}

			const itemCount:int = items.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:DisplayObject = items[i];
				var layoutData:AnchorLayoutData;
				if(item is ILayoutDisplayObject)
				{
					layoutData = ILayoutDisplayObject(item).layoutData as AnchorLayoutData;
				}

				var isReadyForLayout:Boolean = !layoutData || this.isReadyForLayout(layoutData, i, items, unpositionedItems);
				if(!isReadyForLayout)
				{
					unpositionedItems.push(item);
					continue;
				}

				this.measureItem(item, result);
			}

			return result;
		}

		/**
		 * @private
		 */
		protected function measureItem(item:DisplayObject, result:Point):void
		{
			var maxX:Number = result.x;
			var maxY:Number = result.y;
			var isAnchored:Boolean = false;
			if(item is ILayoutDisplayObject)
			{
				var layoutItem:ILayoutDisplayObject = ILayoutDisplayObject(item);
				var layoutData:AnchorLayoutData = layoutItem.layoutData as AnchorLayoutData;
				if(layoutData)
				{
					maxX = Math.max(maxX, this.measureItemHorizontally(layoutItem, layoutData));
					maxY = Math.max(maxY, this.measureItemVertically(layoutItem, layoutData));
					isAnchored = true;
				}
			}
			if(!isAnchored)
			{
				maxX = Math.max(maxX, item.x + item.width);
				maxY = Math.max(maxY, item.y + item.height);
			}

			result.x = maxX;
			result.y = maxY;
		}

		/**
		 * @private
		 */
		protected function measureItemHorizontally(item:ILayoutDisplayObject, layoutData:AnchorLayoutData):Number
		{
			var right:Number = layoutData.right;
			var left:Number = layoutData.left;
			const rightAnchorDisplayObject:DisplayObject = layoutData.rightAnchorDisplayObject;
			const leftAnchorDisplayObject:DisplayObject = layoutData.leftAnchorDisplayObject;
			const hasRightPosition:Boolean = !isNaN(right);
			const hasLeftPosition:Boolean = !isNaN(left);

			if(hasLeftPosition && leftAnchorDisplayObject)
			{
				left += this.getLeftOffset(leftAnchorDisplayObject);
			}
			if(hasRightPosition && rightAnchorDisplayObject)
			{
				right += this.getRightOffset(rightAnchorDisplayObject);
			}
			if(hasLeftPosition)
			{
				if(hasRightPosition)
				{
					return left + right + item.width;
				}
				return left + item.width;
			}
			else if(hasRightPosition)
			{
				return right + item.width;
			}
			return item.width;
		}

		/**
		 * @private
		 */
		protected function measureItemVertically(item:ILayoutDisplayObject, layoutData:AnchorLayoutData):Number
		{
			var top:Number = layoutData.top;
			var bottom:Number = layoutData.bottom;
			const topAnchorDisplayObject:DisplayObject = layoutData.topAnchorDisplayObject;
			const bottomAnchorDisplayObject:DisplayObject = layoutData.bottomAnchorDisplayObject;
			const hasTopPosition:Boolean = !isNaN(top);
			const hasBottomPosition:Boolean = !isNaN(bottom);

			if(hasTopPosition && topAnchorDisplayObject)
			{
				top += this.getTopOffset(topAnchorDisplayObject);
			}
			if(hasBottomPosition && bottomAnchorDisplayObject)
			{
				bottom += this.getBottomOffset(bottomAnchorDisplayObject);
			}
			if(hasTopPosition)
			{
				if(hasBottomPosition)
				{
					return top + bottom + item.height;
				}
				return top + item.height;
			}
			else if(hasBottomPosition)
			{
				return bottom + item.height;
			}
			return item.height;
		}

		/**
		 * @private
		 */
		protected function getTopOffset(item:DisplayObject):Number
		{
			if(item is ILayoutDisplayObject)
			{
				const layoutItem:ILayoutDisplayObject = ILayoutDisplayObject(item);
				const layoutData:AnchorLayoutData = layoutItem.layoutData as AnchorLayoutData;
				if(layoutData)
				{
					var top:Number = layoutData.top;
					const hasTopPosition:Boolean = !isNaN(top);
					if(hasTopPosition)
					{
						const topAnchorDisplayObject:DisplayObject = layoutData.topAnchorDisplayObject;
						top += (hasTopPosition && topAnchorDisplayObject) ? this.getTopOffset(topAnchorDisplayObject) : 0;
						top += item.height;
					}
					else
					{
						top = item.y + item.height;
					}
					const right:Number = layoutData.right;
					const hasRightPosition:Boolean = !isNaN(right);
					if(hasRightPosition)
					{
						const rightAnchorDisplayObject:DisplayObject = layoutData.rightAnchorDisplayObject;
						if(rightAnchorDisplayObject)
						{
							top = Math.max(top, this.getTopOffset(rightAnchorDisplayObject));
						}
					}
					const bottom:Number = layoutData.bottom;
					const hasBottomPosition:Boolean = !isNaN(bottom);
					if(hasBottomPosition)
					{
						const bottomAnchorDisplayObject:DisplayObject = layoutData.bottomAnchorDisplayObject;
						if(bottomAnchorDisplayObject)
						{
							top = Math.max(top, -(bottomAnchorDisplayObject.height + bottom) + this.getTopOffset(bottomAnchorDisplayObject));
						}
					}
					const left:Number = layoutData.left;
					const hasLeftPosition:Boolean = !isNaN(left);
					if(hasLeftPosition)
					{
						const leftAnchorDisplayObject:DisplayObject = layoutData.leftAnchorDisplayObject;
						if(leftAnchorDisplayObject)
						{
							top = Math.max(top, this.getTopOffset(leftAnchorDisplayObject));
						}
					}
					return top;
				}
			}
			return item.y + item.height;
		}

		/**
		 * @private
		 */
		protected function getRightOffset(item:DisplayObject):Number
		{
			if(item is ILayoutDisplayObject)
			{
				const layoutItem:ILayoutDisplayObject = ILayoutDisplayObject(item);
				const layoutData:AnchorLayoutData = layoutItem.layoutData as AnchorLayoutData;
				if(layoutData)
				{
					var right:Number = layoutData.right;
					const hasRightPosition:Boolean = !isNaN(right);
					if(hasRightPosition)
					{
						const rightAnchorDisplayObject:DisplayObject = layoutData.rightAnchorDisplayObject;
						right += (hasRightPosition && rightAnchorDisplayObject) ? this.getRightOffset(rightAnchorDisplayObject) : 0;
						right += item.width;
					}
					else
					{
						right = item.width;
					}
					const top:Number = layoutData.top;
					const hasTopPosition:Boolean = !isNaN(top);
					if(hasTopPosition)
					{
						const topAnchorDisplayObject:DisplayObject = layoutData.topAnchorDisplayObject;
						if(topAnchorDisplayObject)
						{
							right = Math.max(right, this.getRightOffset(topAnchorDisplayObject));
						}
					}
					const bottom:Number = layoutData.bottom;
					const hasBottomPosition:Boolean = !isNaN(bottom);
					if(hasBottomPosition)
					{
						const bottomAnchorDisplayObject:DisplayObject = layoutData.bottomAnchorDisplayObject;
						if(bottomAnchorDisplayObject)
						{
							right = Math.max(right, this.getRightOffset(bottomAnchorDisplayObject));
						}
					}
					const left:Number = layoutData.left;
					const hasLeftPosition:Boolean = !isNaN(left);
					if(hasLeftPosition)
					{
						const leftAnchorDisplayObject:DisplayObject = layoutData.leftAnchorDisplayObject;
						if(leftAnchorDisplayObject)
						{
							right = Math.max(right, -(leftAnchorDisplayObject.width + left) + this.getRightOffset(leftAnchorDisplayObject));
						}
					}
					return right;
				}
			}
			return item.width;
		}

		/**
		 * @private
		 */
		protected function getBottomOffset(item:DisplayObject):Number
		{
			if(item is ILayoutDisplayObject)
			{
				const layoutItem:ILayoutDisplayObject = ILayoutDisplayObject(item);
				const layoutData:AnchorLayoutData = layoutItem.layoutData as AnchorLayoutData;
				if(layoutData)
				{
					var bottom:Number = layoutData.bottom;
					const hasBottomPosition:Boolean = !isNaN(bottom);
					if(hasBottomPosition)
					{
						const bottomAnchorDisplayObject:DisplayObject = layoutData.bottomAnchorDisplayObject;
						bottom += (hasBottomPosition && bottomAnchorDisplayObject) ? this.getBottomOffset(bottomAnchorDisplayObject) : 0;
						bottom += item.height;
					}
					else
					{
						bottom = item.height;
					}
					const right:Number = layoutData.right;
					const hasRightPosition:Boolean = !isNaN(right);
					if(hasRightPosition)
					{
						const rightAnchorDisplayObject:DisplayObject = layoutData.rightAnchorDisplayObject;
						if(rightAnchorDisplayObject)
						{
							bottom = Math.max(bottom, this.getBottomOffset(rightAnchorDisplayObject));
						}
					}
					const left:Number = layoutData.left;
					const hasLeftPosition:Boolean = !isNaN(left);
					if(hasLeftPosition)
					{
						const leftAnchorDisplayObject:DisplayObject = layoutData.leftAnchorDisplayObject;
						if(leftAnchorDisplayObject)
						{
							bottom = Math.max(bottom, this.getBottomOffset(leftAnchorDisplayObject));
						}
					}
					const top:Number = layoutData.top;
					const hasTopPosition:Boolean = !isNaN(top);
					if(hasTopPosition)
					{
						const topAnchorDisplayObject:DisplayObject = layoutData.topAnchorDisplayObject;
						if(topAnchorDisplayObject)
						{
							bottom = Math.max(bottom, -(topAnchorDisplayObject.height + top) + this.getBottomOffset(topAnchorDisplayObject));
						}
					}
					return bottom;
				}
			}
			return item.height;
		}

		/**
		 * @private
		 */
		protected function getLeftOffset(item:DisplayObject):Number
		{
			if(item is ILayoutDisplayObject)
			{
				const layoutItem:ILayoutDisplayObject = ILayoutDisplayObject(item);
				const layoutData:AnchorLayoutData = layoutItem.layoutData as AnchorLayoutData;
				if(layoutData)
				{
					var left:Number = layoutData.left;
					const hasLeftPosition:Boolean = !isNaN(left);
					if(hasLeftPosition)
					{
						const leftAnchorDisplayObject:DisplayObject = layoutData.leftAnchorDisplayObject;
						left += (hasLeftPosition && leftAnchorDisplayObject) ? this.getLeftOffset(leftAnchorDisplayObject) : 0;
						left += item.width;
					}
					else
					{
						left = item.x + item.width
					}
					const top:Number = layoutData.top;
					const hasTopPosition:Boolean = !isNaN(top);
					if(hasTopPosition)
					{
						const topAnchorDisplayObject:DisplayObject = layoutData.topAnchorDisplayObject;
						if(topAnchorDisplayObject)
						{
							left = Math.max(left, this.getLeftOffset(topAnchorDisplayObject));
						}
					}
					const bottom:Number = layoutData.bottom;
					const hasBottomPosition:Boolean = !isNaN(bottom);
					if(hasBottomPosition)
					{
						const bottomAnchorDisplayObject:DisplayObject = layoutData.bottomAnchorDisplayObject;
						if(bottomAnchorDisplayObject)
						{
							left = Math.max(left, this.getLeftOffset(bottomAnchorDisplayObject));
						}
					}
					const right:Number = layoutData.right;
					const hasRightPosition:Boolean = !isNaN(right);
					if(hasRightPosition)
					{
						const rightAnchorDisplayObject:DisplayObject = layoutData.rightAnchorDisplayObject;
						if(rightAnchorDisplayObject)
						{
							left = Math.max(left, -(rightAnchorDisplayObject.width + right) + this.getLeftOffset(rightAnchorDisplayObject));
						}
					}
					return left;
				}
			}
			return item.x + item.width;
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
			const left:Number = layoutData.left;
			const hasLeftPosition:Boolean = !isNaN(left);
			if(hasLeftPosition)
			{
				const leftAnchorDisplayObject:DisplayObject = layoutData.leftAnchorDisplayObject;
				if(leftAnchorDisplayObject)
				{
					item.x = leftAnchorDisplayObject.x + leftAnchorDisplayObject.width + left;
				}
				else
				{
					item.x = boundsX + left;
				}
			}
			const horizontalCenter:Number = layoutData.horizontalCenter;
			const hasHorizontalCenterPosition:Boolean = !isNaN(horizontalCenter);
			const right:Number = layoutData.right;
			const hasRightPosition:Boolean = !isNaN(right);
			if(hasRightPosition)
			{
				const rightAnchorDisplayObject:DisplayObject = layoutData.rightAnchorDisplayObject;
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
				else if(hasHorizontalCenterPosition)
				{
					var horizontalCenterAnchorDisplayObject:DisplayObject = layoutData.horizontalCenterAnchorDisplayObject;
					var xPositionOfCenter:Number;
					if(horizontalCenterAnchorDisplayObject)
					{
						xPositionOfCenter = horizontalCenterAnchorDisplayObject.x + (horizontalCenterAnchorDisplayObject.width / 2) + horizontalCenter;
					}
					else
					{
						xPositionOfCenter = (viewPortWidth / 2) + horizontalCenter;
					}
					var xPositionOfRight:Number;
					if(rightAnchorDisplayObject)
					{
						xPositionOfRight = rightAnchorDisplayObject.x - right;
					}
					else
					{
						xPositionOfRight = viewPortWidth - right;
					}
					item.width = 2 * (xPositionOfRight - xPositionOfCenter);
					item.x = viewPortWidth - right - item.width;
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
			else if(hasHorizontalCenterPosition)
			{
				horizontalCenterAnchorDisplayObject = layoutData.horizontalCenterAnchorDisplayObject;
				if(horizontalCenterAnchorDisplayObject)
				{
					xPositionOfCenter = horizontalCenterAnchorDisplayObject.x + (horizontalCenterAnchorDisplayObject.width / 2) + horizontalCenter;
				}
				else
				{
					xPositionOfCenter = (viewPortWidth / 2) + horizontalCenter;
				}

				if(hasLeftPosition)
				{
					item.width = 2 * (xPositionOfCenter - item.x);
				}
				else
				{
					item.x = xPositionOfCenter - (item.width / 2);
				}
			}
		}

		/**
		 * @private
		 */
		protected function positionVertically(item:ILayoutDisplayObject, layoutData:AnchorLayoutData, boundsX:Number, boundsY:Number, viewPortWidth:Number, viewPortHeight:Number):void
		{
			const top:Number = layoutData.top;
			const hasTopPosition:Boolean = !isNaN(top);
			if(hasTopPosition)
			{
				const topAnchorDisplayObject:DisplayObject = layoutData.topAnchorDisplayObject;
				if(topAnchorDisplayObject)
				{
					item.y = topAnchorDisplayObject.y + topAnchorDisplayObject.height + top;
				}
				else
				{
					item.y = boundsY + top;
				}
			}
			const verticalCenter:Number = layoutData.verticalCenter;
			const hasVerticalCenterPosition:Boolean = !isNaN(verticalCenter);
			const bottom:Number = layoutData.bottom;
			const hasBottomPosition:Boolean = !isNaN(bottom);
			if(hasBottomPosition)
			{
				const bottomAnchorDisplayObject:DisplayObject = layoutData.bottomAnchorDisplayObject;
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
				else if(hasVerticalCenterPosition)
				{
					var verticalCenterAnchorDisplayObject:DisplayObject = layoutData.verticalCenterAnchorDisplayObject;
					var yPositionOfCenter:Number;
					if(verticalCenterAnchorDisplayObject)
					{
						yPositionOfCenter = verticalCenterAnchorDisplayObject.y + (verticalCenterAnchorDisplayObject.height / 2) + verticalCenter;
					}
					else
					{
						yPositionOfCenter = (viewPortHeight / 2) + verticalCenter;
					}
					var yPositionOfBottom:Number;
					if(bottomAnchorDisplayObject)
					{
						yPositionOfBottom = bottomAnchorDisplayObject.y - bottom;
					}
					else
					{
						yPositionOfBottom = viewPortHeight - bottom;
					}
					item.height = 2 * (yPositionOfBottom - yPositionOfCenter);
					item.y = viewPortHeight - bottom - item.height;
				}
				else
				{
					if(bottomAnchorDisplayObject)
					{
						item.y = bottomAnchorDisplayObject.y - item.height - bottom;
					}
					else
					{
						item.y = boundsY + viewPortHeight - bottom - item.height;
					}
				}
			}
			else if(hasVerticalCenterPosition)
			{
				verticalCenterAnchorDisplayObject = layoutData.verticalCenterAnchorDisplayObject;
				if(verticalCenterAnchorDisplayObject)
				{
					yPositionOfCenter = verticalCenterAnchorDisplayObject.y + (verticalCenterAnchorDisplayObject.height / 2) + verticalCenter;
				}
				else
				{
					yPositionOfCenter = (viewPortHeight / 2) + verticalCenter;
				}

				if(hasTopPosition)
				{
					item.height = 2 * (yPositionOfCenter - item.y);
				}
				else
				{
					item.y = yPositionOfCenter - (item.height / 2);
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
