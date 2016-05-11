/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.layout
{
	import feathers.core.IFeathersControl;

	import flash.errors.IllegalOperationError;
	import flash.geom.Point;

	import starling.display.DisplayObject;
	import starling.events.EventDispatcher;

	/**
	 * Dispatched when a property of the layout changes, indicating that a
	 * redraw is probably needed.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>null</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @eventType starling.events.Event.CHANGE
	 */
	[Event(name="change",type="starling.events.Event")]

	/**
	 * Positions and sizes items by anchoring their edges (or center points)
	 * to their parent container or to other items.
	 *
	 * @see ../../../help/anchor-layout How to use AnchorLayout with Feathers containers
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
		public function get requiresLayoutOnScroll():Boolean
		{
			return false;
		}

		/**
		 * @inheritDoc
		 */
		public function layout(items:Vector.<DisplayObject>, viewPortBounds:ViewPortBounds = null, result:LayoutBoundsResult = null):LayoutBoundsResult
		{
			var boundsX:Number = viewPortBounds ? viewPortBounds.x : 0;
			var boundsY:Number = viewPortBounds ? viewPortBounds.y : 0;
			var minWidth:Number = viewPortBounds ? viewPortBounds.minWidth : 0;
			var minHeight:Number = viewPortBounds ? viewPortBounds.minHeight : 0;
			var maxWidth:Number = viewPortBounds ? viewPortBounds.maxWidth : Number.POSITIVE_INFINITY;
			var maxHeight:Number = viewPortBounds ? viewPortBounds.maxHeight : Number.POSITIVE_INFINITY;
			var explicitWidth:Number = viewPortBounds ? viewPortBounds.explicitWidth : NaN;
			var explicitHeight:Number = viewPortBounds ? viewPortBounds.explicitHeight : NaN;

			var viewPortWidth:Number = explicitWidth;
			var viewPortHeight:Number = explicitHeight;

			var needsWidth:Boolean = explicitWidth !== explicitWidth; //isNaN
			var needsHeight:Boolean = explicitHeight !== explicitHeight; //isNaN
			if(needsWidth || needsHeight)
			{
				this.validateItems(items, explicitWidth, explicitHeight,
					maxWidth, maxHeight, true);
				this.measureViewPort(items, viewPortWidth, viewPortHeight, HELPER_POINT);
				if(needsWidth)
				{
					viewPortWidth = HELPER_POINT.x;
					if(viewPortWidth < minWidth)
					{
						viewPortWidth = minWidth;
					}
					else if(viewPortWidth > maxWidth)
					{
						viewPortWidth = maxWidth;
					}
				}
				if(needsHeight)
				{
					viewPortHeight = HELPER_POINT.y;
					if(viewPortHeight < minHeight)
					{
						viewPortHeight = minHeight;
					}
					else if(viewPortHeight > maxHeight)
					{
						viewPortHeight = maxHeight;
					}
				}
			}
			else
			{
				this.validateItems(items, explicitWidth, explicitHeight,
					maxWidth, maxHeight, false);
			}

			this.layoutWithBounds(items, boundsX, boundsY, viewPortWidth, viewPortHeight);

			this.measureContent(items, viewPortWidth, viewPortHeight, HELPER_POINT);

			if(!result)
			{
				result = new LayoutBoundsResult();
			}
			result.contentWidth = HELPER_POINT.x;
			result.contentHeight = HELPER_POINT.y;
			result.viewPortWidth = viewPortWidth;
			result.viewPortHeight = viewPortHeight;
			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function getNearestScrollPositionForIndex(index:int, scrollX:Number, scrollY:Number, items:Vector.<DisplayObject>, x:Number, y:Number, width:Number, height:Number, result:Point = null):Point
		{
			return this.getScrollPositionForIndex(index, items, x, y, width, height, result);
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

			unpositionedItems.length = 0;
			var itemCount:int = items.length;
			var pushIndex:int = 0;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:DisplayObject = items[i];
				var layoutData:AnchorLayoutData;
				if(item is ILayoutDisplayObject)
				{
					var layoutItem:ILayoutDisplayObject = ILayoutDisplayObject(item);
					if(!layoutItem.includeInLayout)
					{
						continue;
					}
					layoutData = layoutItem.layoutData as AnchorLayoutData;
				}
				var isReadyForLayout:Boolean = !layoutData || this.isReadyForLayout(layoutData, i, items, unpositionedItems);
				if(!isReadyForLayout)
				{
					unpositionedItems[pushIndex] = item;
					pushIndex++;
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
					var measurement:Number = this.measureItemHorizontally(layoutItem, layoutData);
					if(measurement > maxX)
					{
						maxX = measurement;
					}
					measurement = this.measureItemVertically(layoutItem, layoutData);
					if(measurement > maxY)
					{
						maxY = measurement;
					}
					isAnchored = true;
				}
			}
			if(!isAnchored)
			{
				measurement = item.x - item.pivotX + item.width;
				if(measurement > maxX)
				{
					maxX = measurement;
				}
				measurement = item.y - item.pivotY + item.height;
				if(measurement > maxY)
				{
					maxY = measurement;
				}
			}

			result.x = maxX;
			result.y = maxY;
		}

		/**
		 * @private
		 */
		protected function measureItemHorizontally(item:ILayoutDisplayObject, layoutData:AnchorLayoutData):Number
		{
			var itemWidth:Number = item.width;
			if(layoutData && item is IFeathersControl)
			{
				var percentWidth:Number = layoutData.percentWidth;
				//for some reason, if we don't call a function right here,
				//compiling with the flex 4.6 SDK will throw a VerifyError
				//for a stack overflow.
				//we could change the === check back to !isNaN() instead, but
				//isNaN() can allocate an object, so we should call a different
				//function without allocation.
				this.doNothing();
				if(percentWidth === percentWidth) //!isNaN
				{
					itemWidth = IFeathersControl(item).minWidth;
				}
			}
			var displayItem:DisplayObject = DisplayObject(item);
			var left:Number = this.getLeftOffset(displayItem);
			var right:Number = this.getRightOffset(displayItem);
			return itemWidth + left + right;
		}

		/**
		 * @private
		 */
		protected function measureItemVertically(item:ILayoutDisplayObject, layoutData:AnchorLayoutData):Number
		{
			var itemHeight:Number = item.height;
			if(layoutData && item is IFeathersControl)
			{
				var percentHeight:Number = layoutData.percentHeight;
				//for some reason, if we don't call a function right here,
				//compiling with the flex 4.6 SDK will throw a VerifyError
				//for a stack overflow.
				//we could change the === check back to !isNaN() instead, but
				//isNaN() can allocate an object, so we should call a different
				//function without allocation.
				this.doNothing();
				if(percentHeight === percentHeight) //!isNaN
				{
					itemHeight = IFeathersControl(item).minHeight;
				}
			}
			var displayItem:DisplayObject = DisplayObject(item);
			var top:Number = this.getTopOffset(displayItem);
			var bottom:Number = this.getBottomOffset(displayItem);
			return itemHeight + top + bottom;
		}

		/**
		 * @private
		 * This function is here to work around a bug in the Flex 4.6 SDK
		 * compiler. For explanation, see the places where it gets called.
		 */
		protected function doNothing():void {}

		/**
		 * @private
		 */
		protected function getTopOffset(item:DisplayObject):Number
		{
			if(item is ILayoutDisplayObject)
			{
				var layoutItem:ILayoutDisplayObject = ILayoutDisplayObject(item);
				var layoutData:AnchorLayoutData = layoutItem.layoutData as AnchorLayoutData;
				if(layoutData)
				{
					var top:Number = layoutData.top;
					var hasTopPosition:Boolean = top === top; //!isNaN
					if(hasTopPosition)
					{
						var topAnchorDisplayObject:DisplayObject = layoutData.topAnchorDisplayObject;
						if(topAnchorDisplayObject)
						{
							top += topAnchorDisplayObject.height + this.getTopOffset(topAnchorDisplayObject);
						}
						else
						{
							return top;
						}
					}
					else
					{
						top = 0;
					}
					var bottom:Number = layoutData.bottom;
					var hasBottomPosition:Boolean = bottom === bottom; //!isNaN
					if(hasBottomPosition)
					{
						var bottomAnchorDisplayObject:DisplayObject = layoutData.bottomAnchorDisplayObject;
						if(bottomAnchorDisplayObject)
						{
							top = Math.max(top, -bottomAnchorDisplayObject.height - bottom + this.getTopOffset(bottomAnchorDisplayObject));
						}
					}
					var verticalCenter:Number = layoutData.verticalCenter;
					var hasVerticalCenterPosition:Boolean = verticalCenter === verticalCenter; //!isNaN
					if(hasVerticalCenterPosition)
					{
						var verticalCenterAnchorDisplayObject:DisplayObject = layoutData.verticalCenterAnchorDisplayObject;
						if(verticalCenterAnchorDisplayObject)
						{
							var verticalOffset:Number = verticalCenter - Math.round((item.height - verticalCenterAnchorDisplayObject.height) / 2);
							top = Math.max(top, verticalOffset + this.getTopOffset(verticalCenterAnchorDisplayObject));
						}
						else if(verticalCenter > 0)
						{
							return verticalCenter * 2;
						}
					}
					return top;
				}
			}
			return 0;
		}

		/**
		 * @private
		 */
		protected function getRightOffset(item:DisplayObject):Number
		{
			if(item is ILayoutDisplayObject)
			{
				var layoutItem:ILayoutDisplayObject = ILayoutDisplayObject(item);
				var layoutData:AnchorLayoutData = layoutItem.layoutData as AnchorLayoutData;
				if(layoutData)
				{
					var right:Number = layoutData.right;
					var hasRightPosition:Boolean = right === right; //!isNaN
					if(hasRightPosition)
					{
						var rightAnchorDisplayObject:DisplayObject = layoutData.rightAnchorDisplayObject;
						if(rightAnchorDisplayObject)
						{
							right += rightAnchorDisplayObject.width + this.getRightOffset(rightAnchorDisplayObject);
						}
						else
						{
							return right;
						}
					}
					else
					{
						right = 0;
					}
					var left:Number = layoutData.left;
					var hasLeftPosition:Boolean = left === left; //!isNaN
					if(hasLeftPosition)
					{
						var leftAnchorDisplayObject:DisplayObject = layoutData.leftAnchorDisplayObject;
						if(leftAnchorDisplayObject)
						{
							right = Math.max(right, -leftAnchorDisplayObject.width - left + this.getRightOffset(leftAnchorDisplayObject));
						}
					}
					var horizontalCenter:Number = layoutData.horizontalCenter;
					var hasHorizontalCenterPosition:Boolean = horizontalCenter === horizontalCenter; //!isNaN
					if(hasHorizontalCenterPosition)
					{
						var horizontalCenterAnchorDisplayObject:DisplayObject = layoutData.horizontalCenterAnchorDisplayObject;
						if(horizontalCenterAnchorDisplayObject)
						{
							var horizontalOffset:Number = -horizontalCenter - Math.round((item.width - horizontalCenterAnchorDisplayObject.width) / 2);
							right = Math.max(right, horizontalOffset + this.getRightOffset(horizontalCenterAnchorDisplayObject));
						}
						else if(horizontalCenter < 0)
						{
							return -horizontalCenter * 2;
						}
					}
					return right;
				}
			}
			return 0;
		}

		/**
		 * @private
		 */
		protected function getBottomOffset(item:DisplayObject):Number
		{
			if(item is ILayoutDisplayObject)
			{
				var layoutItem:ILayoutDisplayObject = ILayoutDisplayObject(item);
				var layoutData:AnchorLayoutData = layoutItem.layoutData as AnchorLayoutData;
				if(layoutData)
				{
					var bottom:Number = layoutData.bottom;
					var hasBottomPosition:Boolean = bottom === bottom; //!isNaN
					if(hasBottomPosition)
					{
						var bottomAnchorDisplayObject:DisplayObject = layoutData.bottomAnchorDisplayObject;
						if(bottomAnchorDisplayObject)
						{
							bottom += bottomAnchorDisplayObject.height + this.getBottomOffset(bottomAnchorDisplayObject);
						}
						else
						{
							return bottom;
						}
					}
					else
					{
						bottom = 0;
					}
					var top:Number = layoutData.top;
					var hasTopPosition:Boolean = top === top; //!isNaN
					if(hasTopPosition)
					{
						var topAnchorDisplayObject:DisplayObject = layoutData.topAnchorDisplayObject;
						if(topAnchorDisplayObject)
						{
							bottom = Math.max(bottom, -topAnchorDisplayObject.height - top + this.getBottomOffset(topAnchorDisplayObject));
						}
					}
					var verticalCenter:Number = layoutData.verticalCenter;
					var hasVerticalCenterPosition:Boolean = verticalCenter === verticalCenter; //!isNaN
					if(hasVerticalCenterPosition)
					{
						var verticalCenterAnchorDisplayObject:DisplayObject = layoutData.verticalCenterAnchorDisplayObject;
						if(verticalCenterAnchorDisplayObject)
						{
							var verticalOffset:Number = -verticalCenter - Math.round((item.height - verticalCenterAnchorDisplayObject.height) / 2);
							bottom = Math.max(bottom, verticalOffset + this.getBottomOffset(verticalCenterAnchorDisplayObject));
						}
						else if(verticalCenter < 0)
						{
							return -verticalCenter * 2;
						}
					}
					return bottom;
				}
			}
			return 0;
		}

		/**
		 * @private
		 */
		protected function getLeftOffset(item:DisplayObject):Number
		{
			if(item is ILayoutDisplayObject)
			{
				var layoutItem:ILayoutDisplayObject = ILayoutDisplayObject(item);
				var layoutData:AnchorLayoutData = layoutItem.layoutData as AnchorLayoutData;
				if(layoutData)
				{
					var left:Number = layoutData.left;
					var hasLeftPosition:Boolean = left === left; //!isNaN
					if(hasLeftPosition)
					{
						var leftAnchorDisplayObject:DisplayObject = layoutData.leftAnchorDisplayObject;
						if(leftAnchorDisplayObject)
						{
							left += leftAnchorDisplayObject.width + this.getLeftOffset(leftAnchorDisplayObject);
						}
						else
						{
							return left;
						}
					}
					else
					{
						left = 0;
					}
					var right:Number = layoutData.right;
					var hasRightPosition:Boolean = right === right; //!isNaN;
					if(hasRightPosition)
					{
						var rightAnchorDisplayObject:DisplayObject = layoutData.rightAnchorDisplayObject;
						if(rightAnchorDisplayObject)
						{
							left = Math.max(left, -rightAnchorDisplayObject.width - right + this.getLeftOffset(rightAnchorDisplayObject));
						}
					}
					var horizontalCenter:Number = layoutData.horizontalCenter;
					var hasHorizontalCenterPosition:Boolean = horizontalCenter === horizontalCenter; //!isNaN
					if(hasHorizontalCenterPosition)
					{
						var horizontalCenterAnchorDisplayObject:DisplayObject = layoutData.horizontalCenterAnchorDisplayObject;
						if(horizontalCenterAnchorDisplayObject)
						{
							var horizontalOffset:Number = horizontalCenter - Math.round((item.width - horizontalCenterAnchorDisplayObject.width) / 2);
							left = Math.max(left, horizontalOffset + this.getLeftOffset(horizontalCenterAnchorDisplayObject));
						}
						else if(horizontalCenter > 0)
						{
							return horizontalCenter * 2;
						}
					}
					return left;
				}
			}
			return 0;
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
			unpositionedItems.length = 0;
			var itemCount:int = items.length;
			var pushIndex:int = 0;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:DisplayObject = items[i];
				var layoutItem:ILayoutDisplayObject = item as ILayoutDisplayObject;
				if(!layoutItem || !layoutItem.includeInLayout)
				{
					continue;
				}
				var layoutData:AnchorLayoutData = layoutItem.layoutData as AnchorLayoutData;
				if(!layoutData)
				{
					continue;
				}

				var isReadyForLayout:Boolean = this.isReadyForLayout(layoutData, i, items, unpositionedItems);
				if(!isReadyForLayout)
				{
					unpositionedItems[pushIndex] = item;
					pushIndex++;
					continue;
				}
				this.positionHorizontally(layoutItem, layoutData, boundsX, boundsY, viewPortWidth, viewPortHeight);
				this.positionVertically(layoutItem, layoutData, boundsX, boundsY, viewPortWidth, viewPortHeight);
			}
		}

		/**
		 * @private
		 */
		protected function positionHorizontally(item:ILayoutDisplayObject, layoutData:AnchorLayoutData, boundsX:Number, boundsY:Number, viewPortWidth:Number, viewPortHeight:Number):void
		{
			var uiItem:IFeathersControl = item as IFeathersControl;
			var percentWidth:Number = layoutData.percentWidth;
			if(percentWidth === percentWidth) //!isNaN
			{
				if(percentWidth < 0)
				{
					percentWidth = 0;
				}
				else if(percentWidth > 100)
				{
					percentWidth = 100;
				}
				var itemWidth:Number = percentWidth * 0.01 * viewPortWidth;
				if(uiItem)
				{
					var minWidth:Number = uiItem.minWidth;
					var maxWidth:Number = uiItem.maxWidth;
					if(itemWidth < minWidth)
					{
						itemWidth = minWidth;
					}
					else if(itemWidth > maxWidth)
					{
						itemWidth = maxWidth;
					}
				}
				if(itemWidth > viewPortWidth)
				{
					itemWidth = viewPortWidth;
				}
				item.width = itemWidth;
			}
			var left:Number = layoutData.left;
			var hasLeftPosition:Boolean = left === left; //!isNaN
			if(hasLeftPosition)
			{
				var leftAnchorDisplayObject:DisplayObject = layoutData.leftAnchorDisplayObject;
				if(leftAnchorDisplayObject)
				{
					item.x = item.pivotX + leftAnchorDisplayObject.x - leftAnchorDisplayObject.pivotX + leftAnchorDisplayObject.width + left;
				}
				else
				{
					item.x = item.pivotX + boundsX + left;
				}
			}
			var horizontalCenter:Number = layoutData.horizontalCenter;
			var hasHorizontalCenterPosition:Boolean = horizontalCenter === horizontalCenter; //!isNaN
			var right:Number = layoutData.right;
			var hasRightPosition:Boolean = right === right; //!isNaN
			if(hasRightPosition)
			{
				var rightAnchorDisplayObject:DisplayObject = layoutData.rightAnchorDisplayObject;
				if(hasLeftPosition)
				{
					var leftRightWidth:Number = viewPortWidth;
					if(rightAnchorDisplayObject)
					{
						leftRightWidth = rightAnchorDisplayObject.x - rightAnchorDisplayObject.pivotX;
					}
					if(leftAnchorDisplayObject)
					{
						leftRightWidth -= (leftAnchorDisplayObject.x - leftAnchorDisplayObject.pivotX + leftAnchorDisplayObject.width);
					}
					item.width = leftRightWidth - right - left;
				}
				else if(hasHorizontalCenterPosition)
				{
					var horizontalCenterAnchorDisplayObject:DisplayObject = layoutData.horizontalCenterAnchorDisplayObject;
					var xPositionOfCenter:Number;
					if(horizontalCenterAnchorDisplayObject)
					{
						xPositionOfCenter = horizontalCenterAnchorDisplayObject.x - horizontalCenterAnchorDisplayObject.pivotX + Math.round(horizontalCenterAnchorDisplayObject.width / 2) + horizontalCenter;
					}
					else
					{
						xPositionOfCenter = Math.round(viewPortWidth / 2) + horizontalCenter;
					}
					var xPositionOfRight:Number;
					if(rightAnchorDisplayObject)
					{
						xPositionOfRight = rightAnchorDisplayObject.x - rightAnchorDisplayObject.pivotX - right;
					}
					else
					{
						xPositionOfRight = viewPortWidth - right;
					}
					item.width = 2 * (xPositionOfRight - xPositionOfCenter);
					item.x = item.pivotX + viewPortWidth - right - item.width;
				}
				else
				{
					if(rightAnchorDisplayObject)
					{
						item.x = item.pivotX + rightAnchorDisplayObject.x - rightAnchorDisplayObject.pivotX - item.width - right;
					}
					else
					{
						item.x = item.pivotX + boundsX + viewPortWidth - right - item.width;
					}
				}
			}
			else if(hasHorizontalCenterPosition)
			{
				horizontalCenterAnchorDisplayObject = layoutData.horizontalCenterAnchorDisplayObject;
				if(horizontalCenterAnchorDisplayObject)
				{
					xPositionOfCenter = horizontalCenterAnchorDisplayObject.x - horizontalCenterAnchorDisplayObject.pivotX + Math.round(horizontalCenterAnchorDisplayObject.width / 2) + horizontalCenter;
				}
				else
				{
					xPositionOfCenter = Math.round(viewPortWidth / 2) + horizontalCenter;
				}

				if(hasLeftPosition)
				{
					item.width = 2 * (xPositionOfCenter - item.x + item.pivotX);
				}
				else
				{
					item.x = item.pivotX + xPositionOfCenter - Math.round(item.width / 2);
				}
			}
		}

		/**
		 * @private
		 */
		protected function positionVertically(item:ILayoutDisplayObject, layoutData:AnchorLayoutData, boundsX:Number, boundsY:Number, viewPortWidth:Number, viewPortHeight:Number):void
		{
			var uiItem:IFeathersControl = item as IFeathersControl;
			var percentHeight:Number = layoutData.percentHeight;
			if(percentHeight === percentHeight) //!isNaN
			{
				if(percentHeight < 0)
				{
					percentHeight = 0;
				}
				else if(percentHeight > 100)
				{
					percentHeight = 100;
				}
				var itemHeight:Number = percentHeight * 0.01 * viewPortHeight;
				if(uiItem)
				{
					var minHeight:Number = uiItem.minHeight;
					var maxHeight:Number = uiItem.maxHeight;
					if(itemHeight < minHeight)
					{
						itemHeight = minHeight;
					}
					else if(itemHeight > maxHeight)
					{
						itemHeight = maxHeight;
					}
				}
				if(itemHeight > viewPortHeight)
				{
					itemHeight = viewPortHeight;
				}
				item.height = itemHeight;
			}
			var top:Number = layoutData.top;
			var hasTopPosition:Boolean = top === top; //!isNaN
			if(hasTopPosition)
			{
				var topAnchorDisplayObject:DisplayObject = layoutData.topAnchorDisplayObject;
				if(topAnchorDisplayObject)
				{
					item.y = item.pivotY + topAnchorDisplayObject.y - topAnchorDisplayObject.pivotY + topAnchorDisplayObject.height + top;
				}
				else
				{
					item.y = item.pivotY + boundsY + top;
				}
			}
			var verticalCenter:Number = layoutData.verticalCenter;
			var hasVerticalCenterPosition:Boolean = verticalCenter === verticalCenter; //!isNaN
			var bottom:Number = layoutData.bottom;
			var hasBottomPosition:Boolean = bottom === bottom; //!isNaN
			if(hasBottomPosition)
			{
				var bottomAnchorDisplayObject:DisplayObject = layoutData.bottomAnchorDisplayObject;
				if(hasTopPosition)
				{
					var topBottomHeight:Number = viewPortHeight;
					if(bottomAnchorDisplayObject)
					{
						topBottomHeight = bottomAnchorDisplayObject.y - bottomAnchorDisplayObject.pivotY;
					}
					if(topAnchorDisplayObject)
					{
						topBottomHeight -= (topAnchorDisplayObject.y - topAnchorDisplayObject.pivotY + topAnchorDisplayObject.height);
					}
					item.height = topBottomHeight - bottom - top;
				}
				else if(hasVerticalCenterPosition)
				{
					var verticalCenterAnchorDisplayObject:DisplayObject = layoutData.verticalCenterAnchorDisplayObject;
					var yPositionOfCenter:Number;
					if(verticalCenterAnchorDisplayObject)
					{
						yPositionOfCenter = verticalCenterAnchorDisplayObject.y - verticalCenterAnchorDisplayObject.pivotY + Math.round(verticalCenterAnchorDisplayObject.height / 2) + verticalCenter;
					}
					else
					{
						yPositionOfCenter = Math.round(viewPortHeight / 2) + verticalCenter;
					}
					var yPositionOfBottom:Number;
					if(bottomAnchorDisplayObject)
					{
						yPositionOfBottom = bottomAnchorDisplayObject.y - bottomAnchorDisplayObject.pivotY - bottom;
					}
					else
					{
						yPositionOfBottom = viewPortHeight - bottom;
					}
					item.height = 2 * (yPositionOfBottom - yPositionOfCenter);
					item.y = item.pivotY + viewPortHeight - bottom - item.height;
				}
				else
				{
					if(bottomAnchorDisplayObject)
					{
						item.y = item.pivotY + bottomAnchorDisplayObject.y - bottomAnchorDisplayObject.pivotY - item.height - bottom;
					}
					else
					{
						item.y = item.pivotY + boundsY + viewPortHeight - bottom - item.height;
					}
				}
			}
			else if(hasVerticalCenterPosition)
			{
				verticalCenterAnchorDisplayObject = layoutData.verticalCenterAnchorDisplayObject;
				if(verticalCenterAnchorDisplayObject)
				{
					yPositionOfCenter = verticalCenterAnchorDisplayObject.y - verticalCenterAnchorDisplayObject.pivotY + Math.round(verticalCenterAnchorDisplayObject.height / 2) + verticalCenter;
				}
				else
				{
					yPositionOfCenter = Math.round(viewPortHeight / 2) + verticalCenter;
				}

				if(hasTopPosition)
				{
					item.height = 2 * (yPositionOfCenter - item.y + item.pivotY);
				}
				else
				{
					item.y = item.pivotY + yPositionOfCenter - Math.round(item.height / 2);
				}
			}
		}

		/**
		 * @private
		 */
		protected function measureContent(items:Vector.<DisplayObject>, viewPortWidth:Number, viewPortHeight:Number, result:Point = null):Point
		{
			var maxX:Number = viewPortWidth;
			var maxY:Number = viewPortHeight;
			var itemCount:int = items.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:DisplayObject = items[i];
				var itemMaxX:Number = item.x - item.pivotX + item.width;
				var itemMaxY:Number = item.y - item.pivotY + item.height;
				if(itemMaxX === itemMaxX && //!isNaN
					itemMaxX > maxX)
				{
					maxX = itemMaxX;
				}
				if(itemMaxY === itemMaxY && //!isNaN
					itemMaxY > maxY)
				{
					maxY = itemMaxY;
				}
			}
			result.x = maxX;
			result.y = maxY;
			return result;
		}

		/**
		 * @private
		 */
		protected function isReadyForLayout(layoutData:AnchorLayoutData, index:int, items:Vector.<DisplayObject>, unpositionedItems:Vector.<DisplayObject>):Boolean
		{
			var nextIndex:int = index + 1;
			var leftAnchorDisplayObject:DisplayObject = layoutData.leftAnchorDisplayObject;
			if(leftAnchorDisplayObject && (items.indexOf(leftAnchorDisplayObject, nextIndex) >= nextIndex || unpositionedItems.indexOf(leftAnchorDisplayObject) >= 0))
			{
				return false;
			}
			var rightAnchorDisplayObject:DisplayObject = layoutData.rightAnchorDisplayObject;
			if(rightAnchorDisplayObject && (items.indexOf(rightAnchorDisplayObject, nextIndex) >= nextIndex || unpositionedItems.indexOf(rightAnchorDisplayObject) >= 0))
			{
				return false;
			}
			var topAnchorDisplayObject:DisplayObject = layoutData.topAnchorDisplayObject;
			if(topAnchorDisplayObject && (items.indexOf(topAnchorDisplayObject, nextIndex) >= nextIndex || unpositionedItems.indexOf(topAnchorDisplayObject) >= 0))
			{
				return false;
			}
			var bottomAnchorDisplayObject:DisplayObject = layoutData.bottomAnchorDisplayObject;
			if(bottomAnchorDisplayObject && (items.indexOf(bottomAnchorDisplayObject, nextIndex) >= nextIndex || unpositionedItems.indexOf(bottomAnchorDisplayObject) >= 0))
			{
				return false
			}
			var horizontalCenterAnchorDisplayObject:DisplayObject = layoutData.horizontalCenterAnchorDisplayObject;
			if(horizontalCenterAnchorDisplayObject && (items.indexOf(horizontalCenterAnchorDisplayObject, nextIndex) >= nextIndex || unpositionedItems.indexOf(horizontalCenterAnchorDisplayObject) >= 0))
			{
				return false
			}
			var verticalCenterAnchorDisplayObject:DisplayObject = layoutData.verticalCenterAnchorDisplayObject;
			if(verticalCenterAnchorDisplayObject && (items.indexOf(verticalCenterAnchorDisplayObject, nextIndex) >= nextIndex || unpositionedItems.indexOf(verticalCenterAnchorDisplayObject) >= 0))
			{
				return false
			}
			return true;
		}

		/**
		 * @private
		 */
		protected function isReferenced(item:DisplayObject, items:Vector.<DisplayObject>):Boolean
		{
			var itemCount:int = items.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var otherItem:ILayoutDisplayObject = items[i] as ILayoutDisplayObject;
				if(!otherItem || otherItem == item)
				{
					continue;
				}
				var layoutData:AnchorLayoutData = otherItem.layoutData as AnchorLayoutData;
				if(!layoutData)
				{
					continue;
				}
				if(layoutData.leftAnchorDisplayObject == item || layoutData.horizontalCenterAnchorDisplayObject == item ||
					layoutData.rightAnchorDisplayObject == item || layoutData.topAnchorDisplayObject == item ||
					layoutData.verticalCenterAnchorDisplayObject == item || layoutData.bottomAnchorDisplayObject == item)
				{
					return true;
				}
			}
			return false;
		}

		/**
		 * @private
		 */
		protected function validateItems(items:Vector.<DisplayObject>,
			explicitWidth:Number, explicitHeight:Number,
			maxWidth:Number, maxHeight:Number, force:Boolean):void
		{
			var needsWidth:Boolean = explicitWidth !== explicitWidth; //isNaN
			var needsHeight:Boolean = explicitHeight !== explicitHeight; //isNaN
			var itemCount:int = items.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var control:IFeathersControl = items[i] as IFeathersControl;
				if(control)
				{
					if(control is ILayoutDisplayObject)
					{
						var layoutControl:ILayoutDisplayObject = ILayoutDisplayObject(control);
						if(!layoutControl.includeInLayout)
						{
							continue;
						}
						var layoutData:AnchorLayoutData = layoutControl.layoutData as AnchorLayoutData;
						if(layoutData)
						{
							var left:Number = layoutData.left;
							var hasLeftPosition:Boolean = left === left; //!isNaN
							var leftAnchor:DisplayObject = layoutData.leftAnchorDisplayObject;
							var right:Number = layoutData.right;
							var rightAnchor:DisplayObject = layoutData.rightAnchorDisplayObject;
							var hasRightPosition:Boolean = right === right; //!isNaN
							var percentWidth:Number = layoutData.percentWidth;
							var hasPercentWidth:Boolean = percentWidth === percentWidth; //!isNaN
							if(!needsWidth)
							{
								//optimization: set the child width before
								//validation if the container width is explicit
								//or has a maximum
								var containerWidth:Number = maxWidth;
								if(explicitWidth === explicitWidth) //!isNaN
								{
									containerWidth = explicitWidth;
								}
								if(hasLeftPosition && leftAnchor === null &&
									hasRightPosition && rightAnchor === null)
								{
									control.width = containerWidth - left - right;
								}
								else if(hasPercentWidth)
								{
									if(percentWidth < 0)
									{
										percentWidth = 0;
									}
									else if(percentWidth > 100)
									{
										percentWidth = 100;
									}
									control.width = percentWidth * 0.01 * containerWidth;
								}
							}
							var horizontalCenter:Number = layoutData.horizontalCenter;
							var hasHorizontalCenterPosition:Boolean = horizontalCenter === horizontalCenter; //!isNaN

							var top:Number = layoutData.top;
							var hasTopPosition:Boolean = top === top; //!isNaN
							var topAnchor:DisplayObject = layoutData.topAnchorDisplayObject;
							var bottom:Number = layoutData.bottom;
							var hasBottomPosition:Boolean = bottom === bottom; //!isNaN
							var bottomAnchor:DisplayObject = layoutData.bottomAnchorDisplayObject;
							var percentHeight:Number = layoutData.percentHeight;
							var hasPercentHeight:Boolean = percentHeight === percentHeight; //!isNaN
							if(!needsHeight)
							{
								//optimization: set the child height before
								//validation if the container height is explicit
								//or has a maximum.
								var containerHeight:Number = maxHeight;
								if(explicitHeight === explicitHeight) //!isNaN
								{
									containerHeight = explicitHeight;
								}
								if(hasTopPosition && topAnchor === null &&
									hasBottomPosition && bottomAnchor === null)
								{
									control.height = containerHeight - top - bottom;
								}
								else if(hasPercentHeight)
								{
									if(percentHeight < 0)
									{
										percentHeight = 0;
									}
									else if(percentHeight > 100)
									{
										percentHeight = 100;
									}
									control.height = percentHeight * 0.01 * containerHeight; 
								}
							}
							var verticalCenter:Number = layoutData.verticalCenter;
							var hasVerticalCenterPosition:Boolean = verticalCenter === verticalCenter; //!isNaN

							if((hasRightPosition && !hasLeftPosition && !hasHorizontalCenterPosition) ||
								hasHorizontalCenterPosition)
							{
								control.validate();
								continue;
							}
							else if((hasBottomPosition && !hasTopPosition && !hasVerticalCenterPosition) ||
								hasVerticalCenterPosition)
							{
								control.validate();
								continue;
							}
						}
					}
					if(force)
					{
						control.validate();
						continue;
					}
					if(this.isReferenced(DisplayObject(control), items))
					{
						control.validate();
						continue;
					}
				}
			}
		}
	}
}
