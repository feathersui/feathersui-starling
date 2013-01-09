/*
 Feathers
 Copyright (c) 2012 Josh Tynjala. All Rights Reserved.

 This program is free software. You can redistribute and/or modify it in
 accordance with the terms of the accompanying license agreement.
 */
package feathers.layout
{
	import flash.geom.Point;

	import starling.display.DisplayObject;
	import starling.events.EventDispatcher;

	/**
	 * Positions and sizes items based on anchor positions.
	 *
	 * @see AnchorLayoutData
	 */
	public class AnchorLayout extends EventDispatcher implements ILayout
	{
		public function AnchorLayout()
		{
		}

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
	}
}
