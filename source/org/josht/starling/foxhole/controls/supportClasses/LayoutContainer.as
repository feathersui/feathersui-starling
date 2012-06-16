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
package org.josht.starling.foxhole.controls.supportClasses
{
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import org.josht.starling.foxhole.core.FoxholeControl;
	import org.josht.starling.foxhole.layout.ILayout;
	import org.josht.starling.foxhole.layout.IVirtualLayout;

	import starling.display.DisplayObject;
	import starling.events.Event;

	/**
	 * @private
	 * Used internally by ScrollContainer. Not meant to be used on its own.
	 */
	public class LayoutContainer extends FoxholeControl
	{
		private static const HELPER_POINT:Point = new Point();
		private static const HELPER_RECT:Rectangle = new Rectangle();

		public function LayoutContainer()
		{
			this.addEventListener(Event.ADDED, addedHandler);
			this.addEventListener(Event.REMOVED, removedHandler);
		}

		protected var _visibleWidth:Number = NaN;

		public function get visibleWidth():Number
		{
			return this._visibleWidth;
		}

		public function set visibleWidth(value:Number):void
		{
			if(this._visibleWidth == value || (isNaN(this._visibleWidth) && isNaN(value)))
			{
				return;
			}
			this._visibleWidth = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		protected var _visibleHeight:Number = NaN;

		public function get visibleHeight():Number
		{
			return this._visibleHeight;
		}

		public function set visibleHeight(value:Number):void
		{
			if(this._visibleHeight == value || (isNaN(this._visibleHeight) && isNaN(value)))
			{
				return;
			}
			this._visibleHeight = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

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
					var control:FoxholeControl = this.items[i] as FoxholeControl;
					if(control)
					{
						control.validate();
					}
				}

				HELPER_RECT.x = HELPER_RECT.y = 0;
				HELPER_RECT.width = this._visibleWidth;
				HELPER_RECT.height = this._visibleHeight;
				if(this._layout)
				{
					this._layout.layout(this.items, HELPER_RECT, HELPER_POINT);
					this.setSizeInternal(HELPER_POINT.x, HELPER_POINT.y, false);
				}
				else
				{
					var maxX:Number = isNaN(HELPER_RECT.width) ? 0 : HELPER_RECT.width;
					var maxY:Number = isNaN(HELPER_RECT.height) ? 0 : HELPER_RECT.height;
					for each(var item:DisplayObject in this.items)
					{
						maxX = Math.max(maxX, item.x + item.width);
						maxY = Math.max(maxY, item.y + item.height);
					}
					this.setSizeInternal(maxX, maxY, false);
				}
			}
		}

		protected function layout_onLayoutChange(layout:ILayout):void
		{
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		protected function child_resizeHandler(child:FoxholeControl):void
		{
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
