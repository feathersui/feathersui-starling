/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.supportClasses
{
	import feathers.controls.Scroller;
	import feathers.core.FeathersControl;
	import feathers.core.IFeathersControl;
	import feathers.events.FeathersEventType;
	import feathers.layout.ILayout;
	import feathers.layout.ILayoutDisplayObject;
	import feathers.layout.IVirtualLayout;
	import feathers.layout.LayoutBoundsResult;
	import feathers.layout.ViewPortBounds;

	import flash.geom.Point;

	import starling.display.DisplayObject;
	import starling.events.Event;

	/**
	 * @private
	 * Used internally by ScrollContainer. Not meant to be used on its own.
	 */
	public final class LayoutViewPort extends FeathersControl implements IViewPort
	{
		private static const HELPER_BOUNDS:ViewPortBounds = new ViewPortBounds();
		private static const HELPER_LAYOUT_RESULT:LayoutBoundsResult = new LayoutBoundsResult();

		public function LayoutViewPort()
		{
			this.addEventListener(Event.ADDED, addedHandler);
			this.addEventListener(Event.REMOVED, removedHandler);
		}

		private var _minVisibleWidth:Number = 0;

		public function get minVisibleWidth():Number
		{
			return this._minVisibleWidth;
		}

		public function set minVisibleWidth(value:Number):void
		{
			if(this._minVisibleWidth == value)
			{
				return;
			}
			if(isNaN(value))
			{
				throw new ArgumentError("minVisibleWidth cannot be NaN");
			}
			this._minVisibleWidth = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		private var _maxVisibleWidth:Number = Number.POSITIVE_INFINITY;

		public function get maxVisibleWidth():Number
		{
			return this._maxVisibleWidth;
		}

		public function set maxVisibleWidth(value:Number):void
		{
			if(this._maxVisibleWidth == value)
			{
				return;
			}
			if(isNaN(value))
			{
				throw new ArgumentError("maxVisibleWidth cannot be NaN");
			}
			this._maxVisibleWidth = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		private var _visibleWidth:Number = NaN;

		public function get visibleWidth():Number
		{
			return this._visibleWidth;
		}

		public function set visibleWidth(value:Number):void
		{
			if(this._visibleWidth == value || (isNaN(value) && isNaN(this._visibleWidth)))
			{
				return;
			}
			this._visibleWidth = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		private var _minVisibleHeight:Number = 0;

		public function get minVisibleHeight():Number
		{
			return this._minVisibleHeight;
		}

		public function set minVisibleHeight(value:Number):void
		{
			if(this._minVisibleHeight == value)
			{
				return;
			}
			if(isNaN(value))
			{
				throw new ArgumentError("minVisibleHeight cannot be NaN");
			}
			this._minVisibleHeight = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		private var _maxVisibleHeight:Number = Number.POSITIVE_INFINITY;

		public function get maxVisibleHeight():Number
		{
			return this._maxVisibleHeight;
		}

		public function set maxVisibleHeight(value:Number):void
		{
			if(this._maxVisibleHeight == value)
			{
				return;
			}
			if(isNaN(value))
			{
				throw new ArgumentError("maxVisibleHeight cannot be NaN");
			}
			this._maxVisibleHeight = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		private var _visibleHeight:Number = NaN;

		public function get visibleHeight():Number
		{
			return this._visibleHeight;
		}

		public function set visibleHeight(value:Number):void
		{
			if(this._visibleHeight == value || (isNaN(value) && isNaN(this._visibleHeight)))
			{
				return;
			}
			this._visibleHeight = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		private var _contentX:Number = 0;

		public function get contentX():Number
		{
			return this._contentX;
		}

		private var _contentY:Number = 0;

		public function get contentY():Number
		{
			return this._contentY;
		}

		public function get horizontalScrollStep():Number
		{
			return Math.min(this.actualWidth, this.actualHeight) / 10;
		}

		public function get verticalScrollStep():Number
		{
			return Math.min(this.actualWidth, this.actualHeight) / 10;
		}

		private var _horizontalScrollPosition:Number = 0;

		public function get horizontalScrollPosition():Number
		{
			return this._horizontalScrollPosition;
		}

		public function set horizontalScrollPosition(value:Number):void
		{
			if(this._horizontalScrollPosition == value)
			{
				return;
			}
			this._horizontalScrollPosition = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
		}

		private var _verticalScrollPosition:Number = 0;

		public function get verticalScrollPosition():Number
		{
			return this._verticalScrollPosition;
		}

		public function set verticalScrollPosition(value:Number):void
		{
			if(this._verticalScrollPosition == value)
			{
				return;
			}
			this._verticalScrollPosition = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
		}

		private var _ignoreChildChanges:Boolean = false;

		private var items:Vector.<DisplayObject> = new <DisplayObject>[];

		private var _layout:ILayout;

		public function get layout():ILayout
		{
			return this._layout;
		}

		public function set layout(value:ILayout):void
		{
			if(this._layout == value)
			{
				return;
			}
			if(this._layout)
			{
				this._layout.removeEventListener(Event.CHANGE, layout_changeHandler);
			}
			this._layout = value;
			if(this._layout)
			{
				if(this._layout is IVirtualLayout)
				{
					IVirtualLayout(this._layout).useVirtualLayout = false;
				}
				this._layout.addEventListener(Event.CHANGE, layout_changeHandler);
				//if we don't have a layout, nothing will need to be redrawn
				this.invalidate(INVALIDATION_FLAG_LAYOUT);
			}
		}

		/**
		 * @private
		 */
		public function readjustLayout():void
		{
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
			this.invalidateParent();
		}

		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			if(child is IFeathersControl)
			{
				child.addEventListener(FeathersEventType.RESIZE, child_resizeHandler);
			}
			if(child is ILayoutDisplayObject)
			{
				child.addEventListener(FeathersEventType.LAYOUT_DATA_CHANGE, child_layoutDataChangeHandler);
			}
			return super.addChildAt(child, index);
		}

		override public function removeChildAt(index:int, dispose:Boolean = false):DisplayObject
		{
			const child:DisplayObject = super.removeChildAt(index, dispose);
			if(child is IFeathersControl)
			{
				child.removeEventListener(FeathersEventType.RESIZE, child_resizeHandler);
			}
			if(child is ILayoutDisplayObject)
			{
				child.removeEventListener(FeathersEventType.LAYOUT_DATA_CHANGE, child_layoutDataChangeHandler);
			}
			return child;
		}

		override public function dispose():void
		{
			this.layout = null;
			super.dispose();
		}

		override protected function draw():void
		{
			const layoutInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_LAYOUT);
			const sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			const scrollInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SCROLL);

			if(sizeInvalid || layoutInvalid || scrollInvalid)
			{
				HELPER_BOUNDS.x = HELPER_BOUNDS.y = 0;
				HELPER_BOUNDS.scrollX = this._horizontalScrollPosition;
				HELPER_BOUNDS.scrollY = this._verticalScrollPosition;
				HELPER_BOUNDS.explicitWidth = this._visibleWidth;
				HELPER_BOUNDS.explicitHeight = this._visibleHeight;
				HELPER_BOUNDS.minWidth = this._minVisibleWidth;
				HELPER_BOUNDS.minHeight = this._minVisibleHeight;
				HELPER_BOUNDS.maxWidth = this._maxVisibleWidth;
				HELPER_BOUNDS.maxHeight = this._maxVisibleHeight;
				if(this._layout)
				{
					this._ignoreChildChanges = true;
					this._layout.layout(this.items, HELPER_BOUNDS, HELPER_LAYOUT_RESULT);
					this._ignoreChildChanges = false;
					this._contentX = HELPER_LAYOUT_RESULT.contentX;
					this._contentY = HELPER_LAYOUT_RESULT.contentY;
					this.setSizeInternal(HELPER_LAYOUT_RESULT.contentWidth, HELPER_LAYOUT_RESULT.contentHeight, false);
				}
				else
				{
					var minX:Number = 0;
					var minY:Number = 0;
					var maxX:Number = isNaN(HELPER_BOUNDS.explicitWidth) ? 0 : HELPER_BOUNDS.explicitWidth;
					var maxY:Number = isNaN(HELPER_BOUNDS.explicitHeight) ? 0 : HELPER_BOUNDS.explicitHeight;
					this._ignoreChildChanges = true;
					const itemCount:int = this.items.length;
					for(var i:int = 0; i < itemCount; i++)
					{
						var item:DisplayObject = this.items[i];
						if(item is IFeathersControl)
						{
							IFeathersControl(item).validate();
						}
						var itemX:Number = item.x;
						var itemY:Number = item.y;
						var itemMaxX:Number = itemX + item.width;
						var itemMaxY:Number = itemY + item.height;
						if(itemX < minX)
						{
							minX = itemX;
						}
						if(itemY < minY)
						{
							minY = itemY;
						}
						if(itemMaxX > maxX)
						{
							maxX = itemMaxX;
						}
						if(itemMaxY > maxY)
						{
							maxY = itemMaxY;
						}
					}
					this._ignoreChildChanges = false;
					this._contentX = minX;
					this._contentY = minY;
					var calculatedWidth:Number = maxX;
					if(calculatedWidth < this._minVisibleWidth)
					{
						calculatedWidth = this._minVisibleWidth;
					}
					else if(calculatedWidth > this._maxVisibleWidth)
					{
						calculatedWidth = this._maxVisibleWidth;
					}
					var calculatedHeight:Number = maxY;
					if(calculatedHeight < this._minVisibleHeight)
					{
						calculatedHeight = this._minVisibleHeight;
					}
					else if(calculatedHeight > this._maxVisibleHeight)
					{
						calculatedHeight = this._maxVisibleHeight;
					}
					this.setSizeInternal(calculatedWidth, calculatedHeight, false);
				}
			}
		}

		private function invalidateParent():void
		{
			Scroller(this.parent).invalidate(INVALIDATION_FLAG_LAYOUT);
		}

		private function layout_changeHandler(event:Event):void
		{
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
			this.invalidateParent();
		}

		private function child_resizeHandler(event:Event):void
		{
			if(this._ignoreChildChanges)
			{
				return;
			}
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
			this.invalidateParent();
		}

		private function child_layoutDataChangeHandler(event:Event):void
		{
			if(this._ignoreChildChanges)
			{
				return;
			}
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
			this.invalidateParent();
		}

		private function addedHandler(event:Event):void
		{
			const item:DisplayObject = DisplayObject(event.target);
			if(item.parent != this)
			{
				return;
			}
			const index:int = this.getChildIndex(item);
			this.items.splice(index, 0, item);
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
			this.invalidateParent();
		}

		private function removedHandler(event:Event):void
		{
			const item:DisplayObject = DisplayObject(event.target);
			if(item.parent != this)
			{
				return;
			}
			const index:int = this.items.indexOf(item);
			this.items.splice(index, 1);
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
			this.invalidateParent();
		}
	}
}
