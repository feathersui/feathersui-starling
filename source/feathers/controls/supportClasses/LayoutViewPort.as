/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.supportClasses
{
	import feathers.controls.LayoutGroup;
	import feathers.core.IFeathersControl;

	import starling.display.DisplayObject;

	/**
	 * @private
	 * Used internally by ScrollContainer. Not meant to be used on its own.
	 */
	public final class LayoutViewPort extends LayoutGroup implements IViewPort
	{
		public function LayoutViewPort()
		{
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

			super.draw();

			if(scrollInvalid || sizeInvalid || layoutInvalid)
			{
				if(this._layout)
				{
					this._contentX = this._layoutResult.contentX;
					this._contentY = this._layoutResult.contentY;
				}
			}
		}

		override protected function refreshViewPortBounds():void
		{
			this.viewPortBounds.x = 0;
			this.viewPortBounds.y = 0;
			this.viewPortBounds.scrollX = this._horizontalScrollPosition;
			this.viewPortBounds.scrollY = this._verticalScrollPosition;
			this.viewPortBounds.explicitWidth = this._visibleWidth;
			this.viewPortBounds.explicitHeight = this._visibleHeight;
			this.viewPortBounds.minWidth = this._minVisibleWidth;
			this.viewPortBounds.minHeight = this._minVisibleHeight;
			this.viewPortBounds.maxWidth = this._maxVisibleWidth;
			this.viewPortBounds.maxHeight = this._maxVisibleHeight;
		}

		override protected function handleManualLayout():Boolean
		{
			var minX:Number = 0;
			var minY:Number = 0;
			var maxX:Number = isNaN(this.viewPortBounds.explicitWidth) ? 0 : this.viewPortBounds.explicitWidth;
			var maxY:Number = isNaN(this.viewPortBounds.explicitHeight) ? 0 : this.viewPortBounds.explicitHeight;
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
				if(!isNaN(itemX) && itemX < minX)
				{
					minX = itemX;
				}
				if(!isNaN(itemY) && itemY < minY)
				{
					minY = itemY;
				}
				if(!isNaN(itemMaxX) && itemMaxX > maxX)
				{
					maxX = itemMaxX;
				}
				if(!isNaN(itemMaxY) && itemMaxY > maxY)
				{
					maxY = itemMaxY;
				}
			}
			this._contentX = minX;
			this._contentY = minY;
			var minWidth:Number = this.viewPortBounds.minWidth;
			var maxWidth:Number = this.viewPortBounds.maxWidth;
			var minHeight:Number = this.viewPortBounds.minHeight;
			var maxHeight:Number = this.viewPortBounds.maxHeight;
			var calculatedWidth:Number = maxX;
			if(calculatedWidth < minWidth)
			{
				calculatedWidth = minWidth;
			}
			else if(calculatedWidth > maxWidth)
			{
				calculatedWidth = maxWidth;
			}
			var calculatedHeight:Number = maxY;
			if(calculatedHeight < minHeight)
			{
				calculatedHeight = minHeight;
			}
			else if(calculatedHeight > maxHeight)
			{
				calculatedHeight = maxHeight;
			}
			this._ignoreChildChanges = false;
			return this.setSizeInternal(calculatedWidth, calculatedHeight, false)
		}
	}
}
