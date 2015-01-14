/*
Feathers
Copyright 2012-2015 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.supportClasses
{
	import feathers.controls.LayoutGroup;
	import feathers.core.IValidating;

	import starling.display.DisplayObject;

	/**
	 * @private
	 * Used internally by ScrollContainer. Not meant to be used on its own.
	 */
	public class LayoutViewPort extends LayoutGroup implements IViewPort
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
			if(value !== value) //isNaN
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
			if(value !== value) //isNaN
			{
				throw new ArgumentError("maxVisibleWidth cannot be NaN");
			}
			this._maxVisibleWidth = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		private var _actualVisibleWidth:Number = 0;

		private var _explicitVisibleWidth:Number = NaN;

		public function get visibleWidth():Number
		{
			if(this._explicitVisibleWidth !== this._explicitVisibleWidth) //isNaN
			{
				return this._actualVisibleWidth;
			}
			return this._explicitVisibleWidth;
		}

		public function set visibleWidth(value:Number):void
		{
			if(this._explicitVisibleWidth == value ||
				(value !== value && this._explicitVisibleWidth !== this._explicitVisibleWidth)) //isNaN
			{
				return;
			}
			this._explicitVisibleWidth = value;
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
			if(value !== value) //isNaN
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
			if(value !== value) //isNaN
			{
				throw new ArgumentError("maxVisibleHeight cannot be NaN");
			}
			this._maxVisibleHeight = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		private var _actualVisibleHeight:Number = 0;

		private var _explicitVisibleHeight:Number = NaN;

		public function get visibleHeight():Number
		{
			if(this._explicitVisibleHeight !== this._explicitVisibleHeight) //isNaN
			{
				return this._actualVisibleHeight;
			}
			return this._explicitVisibleHeight;
		}

		public function set visibleHeight(value:Number):void
		{
			if(this._explicitVisibleHeight == value ||
				(value !== value && this._explicitVisibleHeight !== this._explicitVisibleHeight)) //isNaN
			{
				return;
			}
			this._explicitVisibleHeight = value;
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
			if(this.actualWidth < this.actualHeight)
			{
				return this.actualWidth / 10;
			}
			return this.actualHeight / 10;
		}

		public function get verticalScrollStep():Number
		{
			if(this.actualWidth < this.actualHeight)
			{
				return this.actualWidth / 10;
			}
			return this.actualHeight / 10;
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
			var layoutInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_LAYOUT);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			var scrollInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SCROLL);

			super.draw();

			if(scrollInvalid || sizeInvalid || layoutInvalid)
			{
				if(this._layout)
				{
					this._contentX = this._layoutResult.contentX;
					this._contentY = this._layoutResult.contentY;
					this._actualVisibleWidth = this._layoutResult.viewPortWidth;
					this._actualVisibleHeight = this._layoutResult.viewPortHeight;
				}
			}
		}

		override protected function refreshViewPortBounds():void
		{
			this.viewPortBounds.x = 0;
			this.viewPortBounds.y = 0;
			this.viewPortBounds.scrollX = this._horizontalScrollPosition;
			this.viewPortBounds.scrollY = this._verticalScrollPosition;
			if(this._autoSizeMode == AUTO_SIZE_MODE_STAGE &&
				this._explicitVisibleWidth !== this._explicitVisibleWidth)
			{
				this.viewPortBounds.explicitWidth = this.stage.stageWidth;
			}
			else
			{
				this.viewPortBounds.explicitWidth = this._explicitVisibleWidth;
			}
			if(this._autoSizeMode == AUTO_SIZE_MODE_STAGE &&
				this._explicitVisibleHeight !== this._explicitVisibleHeight)
			{
				this.viewPortBounds.explicitHeight = this.stage.stageHeight;
			}
			else
			{
				this.viewPortBounds.explicitHeight = this._explicitVisibleHeight;
			}
			this.viewPortBounds.minWidth = this._minVisibleWidth;
			this.viewPortBounds.minHeight = this._minVisibleHeight;
			this.viewPortBounds.maxWidth = this._maxVisibleWidth;
			this.viewPortBounds.maxHeight = this._maxVisibleHeight;
		}

		override protected function handleManualLayout():void
		{
			var minX:Number = 0;
			var minY:Number = 0;
			var explicitViewPortWidth:Number = this.viewPortBounds.explicitWidth;
			var maxX:Number = explicitViewPortWidth;
			if(maxX !== maxX) //isNaN
			{
				maxX = 0;
			}
			var explicitViewPortHeight:Number = this.viewPortBounds.explicitHeight;
			var maxY:Number = explicitViewPortHeight;
			if(maxY !== maxY) //isNaN
			{
				maxY = 0;
			}
			this._ignoreChildChanges = true;
			var itemCount:int = this.items.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:DisplayObject = this.items[i];
				if(item is IValidating)
				{
					IValidating(item).validate();
				}
				var itemX:Number = item.x;
				var itemY:Number = item.y;
				var itemMaxX:Number = itemX + item.width;
				var itemMaxY:Number = itemY + item.height;
				if(itemX === itemX && //!isNaN
					itemX < minX)
				{
					minX = itemX;
				}
				if(itemY === itemY && //!isNaN
					itemY < minY)
				{
					minY = itemY;
				}
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
			this._contentX = minX;
			this._contentY = minY;
			var minWidth:Number = this.viewPortBounds.minWidth;
			var maxWidth:Number = this.viewPortBounds.maxWidth;
			var minHeight:Number = this.viewPortBounds.minHeight;
			var maxHeight:Number = this.viewPortBounds.maxHeight;
			var calculatedWidth:Number = maxX - minX;
			if(calculatedWidth < minWidth)
			{
				calculatedWidth = minWidth;
			}
			else if(calculatedWidth > maxWidth)
			{
				calculatedWidth = maxWidth;
			}
			var calculatedHeight:Number = maxY - minY;
			if(calculatedHeight < minHeight)
			{
				calculatedHeight = minHeight;
			}
			else if(calculatedHeight > maxHeight)
			{
				calculatedHeight = maxHeight;
			}
			this._ignoreChildChanges = false;
			if(explicitViewPortWidth !== explicitViewPortWidth) //isNaN
			{
				this._actualVisibleWidth = calculatedWidth;
			}
			else
			{
				this._actualVisibleWidth = explicitViewPortWidth;
			}
			if(explicitViewPortHeight !== explicitViewPortHeight) //isNaN
			{
				this._actualVisibleHeight = calculatedHeight;
			}
			else
			{
				this._actualVisibleHeight = explicitViewPortHeight;
			}
			this._layoutResult.contentX = 0;
			this._layoutResult.contentY = 0;
			this._layoutResult.contentWidth = calculatedWidth;
			this._layoutResult.contentHeight = calculatedHeight;
			this._layoutResult.viewPortWidth = this._actualVisibleWidth;
			this._layoutResult.viewPortHeight = this._actualVisibleHeight;
		}
	}
}
