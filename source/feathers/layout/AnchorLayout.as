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
		protected static const CIRCULAR_REFERENCE_ERROR:String = "Circular reference in AnchorLayoutData.";

		/**
		 * @private
		 */
		private static const HELPER_VECTOR:Vector.<DisplayObject> = new <DisplayObject>[];

		/**
		 * Constructor.
		 */
		public function AnchorLayout()
		{
		}

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

			const viewPortWidth:Number = isNaN(explicitWidth) ? Math.min(maxWidth, Math.max(minWidth, 640)) : explicitWidth;
			const viewPortHeight:Number = isNaN(explicitHeight) ? Math.min(maxHeight, Math.max(minHeight, 640)) : explicitHeight;

			HELPER_VECTOR.length = 0;
			this.layoutVector(items, boundsX, boundsY, viewPortWidth, viewPortHeight);
			var currentLength:Number = HELPER_VECTOR.length;
			while(currentLength > 0)
			{
				this.layoutVector(HELPER_VECTOR, boundsX, boundsY, viewPortWidth, viewPortHeight);
				var oldLength:Number = currentLength;
				currentLength = HELPER_VECTOR.length;
				if(oldLength == currentLength)
				{
					HELPER_VECTOR.length = 0;
					throw new IllegalOperationError(CIRCULAR_REFERENCE_ERROR);
				}
			}

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
		protected function layoutVector(items:Vector.<DisplayObject>, boundsX:Number, boundsY:Number, viewPortWidth:Number, viewPortHeight:Number):void
		{
			const itemCount:int = items.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:DisplayObject = items[i];
				if(item is ILayoutDisplayObject)
				{
					var layoutItem:ILayoutDisplayObject = ILayoutDisplayObject(item);
					var layoutData:ILayoutData = layoutItem.layoutData;
					if(layoutData is AnchorLayoutData)
					{
						var anchorLayoutData:AnchorLayoutData = AnchorLayoutData(layoutData);
						var left:Number = anchorLayoutData.left;
						var hasLeftPosition:Boolean = !isNaN(left);
						var leftAnchorDisplayObject:DisplayObject = anchorLayoutData.leftAnchorDisplayObject;
						if(hasLeftPosition)
						{
							if(leftAnchorDisplayObject)
							{
								if(items.lastIndexOf(leftAnchorDisplayObject, i - 1) >= 0 && HELPER_VECTOR.indexOf(leftAnchorDisplayObject) >= 0)
								{
									HELPER_VECTOR.push(layoutItem);
									continue;
								}
								item.x = leftAnchorDisplayObject.x + leftAnchorDisplayObject.width + left;
							}
							else
							{
								item.x = boundsX + left;
							}
						}
						var right:Number = anchorLayoutData.right;
						var hasRightPosition:Boolean = !isNaN(right);
						var rightAnchorDisplayObject:DisplayObject = anchorLayoutData.rightAnchorDisplayObject;
						if(hasRightPosition)
						{
							if(rightAnchorDisplayObject)
							{
								if(items.lastIndexOf(rightAnchorDisplayObject, i - 1) >= 0 && HELPER_VECTOR.indexOf(rightAnchorDisplayObject) >= 0)
								{
									HELPER_VECTOR.push(layoutItem);
									continue;
								}
							}

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
						var top:Number = anchorLayoutData.top;
						var hasTopPosition:Boolean = !isNaN(top);
						var topAnchorDisplayObject:DisplayObject = anchorLayoutData.topAnchorDisplayObject;
						if(hasTopPosition)
						{
							if(topAnchorDisplayObject)
							{
								if(items.lastIndexOf(topAnchorDisplayObject, i - 1) >= 0 && HELPER_VECTOR.indexOf(topAnchorDisplayObject) >= 0)
								{
									HELPER_VECTOR.push(layoutItem);
									continue;
								}
								item.y = topAnchorDisplayObject.x + topAnchorDisplayObject.height + top;
							}
							else
							{
								item.y = boundsY + top;
							}
						}
						var bottom:Number = anchorLayoutData.bottom;
						var hasBottomPosition:Boolean = !isNaN(bottom);
						var bottomAnchorDisplayObject:DisplayObject = anchorLayoutData.bottomAnchorDisplayObject;
						if(hasBottomPosition)
						{
							if(bottomAnchorDisplayObject)
							{
								if(items.lastIndexOf(bottomAnchorDisplayObject, i - 1) >= 0 && HELPER_VECTOR.indexOf(bottomAnchorDisplayObject) >= 0)
								{
									HELPER_VECTOR.push(layoutItem);
									continue;
								}
							}
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
				}
			}
		}
	}
}
