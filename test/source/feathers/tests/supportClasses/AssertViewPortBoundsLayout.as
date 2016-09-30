package feathers.tests.supportClasses
{
	import feathers.layout.ILayout;
	import feathers.layout.LayoutBoundsResult;
	import feathers.layout.ViewPortBounds;

	import flash.geom.Point;

	import org.flexunit.Assert;

	import starling.display.DisplayObject;
	import starling.events.EventDispatcher;

	public class AssertViewPortBoundsLayout extends EventDispatcher implements ILayout
	{
		public function AssertViewPortBoundsLayout()
		{
		}

		public function get requiresLayoutOnScroll():Boolean
		{
			return false;
		}

		public function layout(items:Vector.<DisplayObject>, viewPortBounds:ViewPortBounds = null, result:LayoutBoundsResult = null):LayoutBoundsResult
		{
			if(result === null)
			{
				result = new LayoutBoundsResult();
			}
			if(viewPortBounds !== null)
			{
				Assert.assertFalse("ViewPortBounds minWidth must not be NaN", isNaN(viewPortBounds.minWidth));
				Assert.assertFalse("ViewPortBounds minHeight must not be NaN", isNaN(viewPortBounds.minHeight));
				Assert.assertFalse("ViewPortBounds maxWidth must not be NaN", isNaN(viewPortBounds.maxWidth));
				Assert.assertFalse("ViewPortBounds maxHeight must not be NaN", isNaN(viewPortBounds.maxHeight));
			}
			return result;
		}

		public function getScrollPositionForIndex(index:int, items:Vector.<DisplayObject>,
			x:Number, y:Number, width:Number, height:Number, result:Point = null):Point
		{
			if(result === null)
			{
				result = new Point();
			}
			return result;
		}

		public function getNearestScrollPositionForIndex(index:int, scrollX:Number, scrollY:Number,
			items:Vector.<DisplayObject>, x:Number, y:Number, width:Number, height:Number, result:Point = null):Point
		{
			if(result === null)
			{
				result = new Point();
			}
			return result;
		}
	}
}
