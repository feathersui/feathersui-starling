package feathers.examples.gallery.layout
{
	import feathers.layout.ILayout;
	import feathers.layout.LayoutBoundsResult;
	import feathers.layout.ViewPortBounds;

	import flash.errors.IllegalOperationError;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import starling.display.DisplayObject;
	import starling.events.EventDispatcher;
	import starling.utils.Pool;

	public class GalleryItemRendererLayout extends EventDispatcher implements ILayout
	{
		public function GalleryItemRendererLayout()
		{
			super();
		}

		public function get requiresLayoutOnScroll():Boolean
		{
			return false;
		}

		public function layout(items:Vector.<DisplayObject>, viewPortBounds:ViewPortBounds = null, result:LayoutBoundsResult = null):LayoutBoundsResult
		{
			var itemCount:int = items.length;
			if(itemCount > 1)
			{
				throw new IllegalOperationError("GalleryItemLayout may not have more than one item.");
			}
			if(!result)
			{
				result = new LayoutBoundsResult();
			}
			var minX:Number = Number.POSITIVE_INFINITY;
			var minY:Number = Number.POSITIVE_INFINITY;
			var maxX:Number = Number.NEGATIVE_INFINITY;
			var maxY:Number = Number.NEGATIVE_INFINITY;
			if(itemCount > 0)
			{
				var item:DisplayObject = items[0];
				var itemBounds:Rectangle = item.getBounds(item.parent, Pool.getRectangle());
				if(itemBounds.x < minX)
				{
					minX = itemBounds.x;
				}
				if(itemBounds.y < minY)
				{
					minY = itemBounds.y;
				}
				var itemMaxX:Number = itemBounds.x + itemBounds.width;
				if(itemMaxX > maxX)
				{
					maxX = itemMaxX;
				}
				var itemMaxY:Number = itemBounds.y + itemBounds.height;
				if(itemMaxY > maxY)
				{
					maxY = itemMaxY;
				}
				Pool.putRectangle(itemBounds);
			}
			if(minX === Number.POSITIVE_INFINITY)
			{
				minX = 0;
			}
			if(minY === Number.POSITIVE_INFINITY)
			{
				minY = 0;
			}
			if(maxX === Number.NEGATIVE_INFINITY)
			{
				maxX = 0;
			}
			if(maxY === Number.NEGATIVE_INFINITY)
			{
				maxY = 0;
			}
			var contentX:Number = minX;
			var contentY:Number = minY;
			var contentWidth:Number = maxX - minX;
			var contentHeight:Number = maxY - minY;
			var viewPortWidth:Number = contentWidth;
			var viewPortHeight:Number = contentHeight;
			if(viewPortBounds && viewPortBounds.explicitWidth === viewPortBounds.explicitWidth)
			{
				viewPortWidth = viewPortBounds.explicitWidth;
			}
			if(viewPortBounds && viewPortBounds.explicitHeight === viewPortBounds.explicitHeight)
			{
				viewPortHeight = viewPortBounds.explicitHeight;
			}
			if(contentWidth <= viewPortWidth)
			{
				contentX -= (viewPortWidth - contentWidth) / 2;
				contentWidth = viewPortWidth;
			}
			if(contentHeight <= viewPortHeight)
			{
				contentY -= (viewPortHeight - contentHeight) / 2;
				contentHeight = viewPortHeight;
			}
			result.contentX = contentX;
			result.contentY = contentY;
			result.contentWidth = contentWidth;
			result.contentHeight = contentHeight;
			result.viewPortWidth = viewPortWidth;
			result.viewPortHeight = viewPortHeight;
			return result;
		}

		public function calculateNavigationDestination(items:Vector.<DisplayObject>, index:int, keyCode:uint, bounds:LayoutBoundsResult):int
		{
			return 0;
		}

		public function getScrollPositionForIndex(index:int, items:Vector.<DisplayObject>,
			x:Number, y:Number, width:Number, height:Number, result:Point = null):Point
		{
			if(!result)
			{
				return new Point(0, 0);
			}
			result.setTo(0, 0);
			return result;
		}

		public function getNearestScrollPositionForIndex(index:int, scrollX:Number, scrollY:Number,
			items:Vector.<DisplayObject>, x:Number, y:Number, width:Number, height:Number, result:Point = null):Point
		{
			return getScrollPositionForIndex(index, items, x, y, width, height, result);
		}
	}
}