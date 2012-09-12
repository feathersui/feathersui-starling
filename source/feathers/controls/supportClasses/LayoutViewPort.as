/*
 Copyright (c) 2012 Josh Tynjala

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 */
package feathers.controls.supportClasses
{
	import flash.geom.Point;

	import feathers.core.FeathersControl;
	import feathers.layout.ILayout;
	import feathers.layout.IVirtualLayout;
	import feathers.layout.LayoutBoundsResult;
	import feathers.layout.ViewPortBounds;

	import starling.display.DisplayObject;
	import starling.events.Event;

	/**
	 * @private
	 * Used internally by ScrollContainer. Not meant to be used on its own.
	 */
	public class LayoutViewPort extends FeathersControl implements IViewPort
	{
		private static const helperPoint:Point = new Point();
		private static const helperBounds:ViewPortBounds = new ViewPortBounds();
		private static const helperResult:LayoutBoundsResult = new LayoutBoundsResult();

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

		protected var _visibleWidth:Number = NaN;

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

		protected var _visibleHeight:Number = NaN;

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

		private var _horizontalScrollPosition:Number = 0;

		public function get horizontalScrollPosition():Number
		{
			return this._horizontalScrollPosition;
		}

		public function set horizontalScrollPosition(value:Number):void
		{
			this._horizontalScrollPosition = value;
		}

		private var _verticalScrollPosition:Number = 0;

		public function get verticalScrollPosition():Number
		{
			return this._verticalScrollPosition;
		}

		public function set verticalScrollPosition(value:Number):void
		{
			this._verticalScrollPosition = value;
		}

		private var _ignoreChildResizing:Boolean = false;

		protected var items:Vector.<DisplayObject> = new <DisplayObject>[];

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
				this._layout.onLayoutChange.remove(layout_onLayoutChange);
			}
			this._layout = value;
			if(this._layout)
			{
				if(this._layout is IVirtualLayout)
				{
					IVirtualLayout(this._layout).useVirtualLayout = false;
				}
				this._layout.onLayoutChange.add(layout_onLayoutChange);
				//if we don't have a layout, nothing will need to be redrawn
				this.invalidate(INVALIDATION_FLAG_DATA);
			}
		}

		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			if(child is FeathersControl)
			{
				FeathersControl(child).onResize.add(child_onResize);
			}
			return super.addChildAt(child, index);
		}

		override public function removeChildAt(index:int, dispose:Boolean = false):DisplayObject
		{
			const child:DisplayObject = super.removeChildAt(index, dispose);
			if(child is FeathersControl)
			{
				FeathersControl(child).onResize.remove(child_onResize);
			}
			return child;
		}

		override public function dispose():void
		{
			if(this._layout)
			{
				this._layout.onLayoutChange.remove(layout_onLayoutChange);
			}
			super.dispose();
		}

		override protected function draw():void
		{
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);

			if(sizeInvalid || dataInvalid)
			{
				const itemCount:int = this.items.length;
				for(var i:int = 0; i < itemCount; i++)
				{
					var control:FeathersControl = this.items[i] as FeathersControl;
					if(control)
					{
						control.validate();
					}
				}

				helperBounds.x = helperBounds.y = 0;
				helperBounds.explicitWidth = this._visibleWidth;
				helperBounds.explicitHeight = this._visibleHeight;
				helperBounds.minWidth = this._minVisibleWidth;
				helperBounds.minHeight = this._minVisibleHeight;
				helperBounds.maxWidth = this._maxVisibleWidth;
				helperBounds.maxHeight = this._maxVisibleHeight;
				if(this._layout)
				{
					this._ignoreChildResizing = true;
					this._layout.layout(this.items, helperBounds, helperResult);
					this._ignoreChildResizing = false;
					this.setSizeInternal(helperResult.contentWidth, helperResult.contentHeight, false);
				}
				else
				{
					var maxX:Number = isNaN(helperBounds.explicitWidth) ? 0 : helperBounds.explicitWidth;
					var maxY:Number = isNaN(helperBounds.explicitHeight) ? 0 : helperBounds.explicitHeight;
					for each(var item:DisplayObject in this.items)
					{
						maxX = Math.max(maxX, item.x + item.width);
						maxY = Math.max(maxY, item.y + item.height);
					}
					helperPoint.x = Math.max(Math.min(maxX, this._maxVisibleWidth), this._minVisibleWidth);
					helperPoint.y = Math.max(Math.min(maxY, this._maxVisibleHeight), this._minVisibleHeight);
					this.setSizeInternal(helperPoint.x, helperPoint.y, false);
				}
			}
		}

		protected function layout_onLayoutChange(layout:ILayout):void
		{
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		protected function child_onResize(child:FeathersControl, oldWidth:Number, oldHeight:Number):void
		{
			if(this._ignoreChildResizing)
			{
				return;
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		protected function addedHandler(event:Event):void
		{
			const item:DisplayObject = DisplayObject(event.target);
			if(item.parent != this)
			{
				return;
			}
			const index:int = this.getChildIndex(item);
			this.items.splice(index, 0, item);
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		protected function removedHandler(event:Event):void
		{
			const item:DisplayObject = DisplayObject(event.target);
			if(item.parent != this)
			{
				return;
			}
			const index:int = this.items.indexOf(item);
			this.items.splice(index, 1);
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
	}
}
