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
package org.josht.starling.foxhole.layout
{
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import org.josht.starling.foxhole.data.ListCollection;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import starling.display.DisplayObject;

	import starling.display.DisplayObject;

	/**
	 * Positions items from left to right in a single row.
	 */
	public class HorizontalLayout implements ILayout
	{
		/**
		 * The items will be aligned to the top of the bounds.
		 */
		public static const VERTICAL_ALIGN_TOP:String = "top";

		/**
		 * The items will be aligned to the middle of the bounds.
		 */
		public static const VERTICAL_ALIGN_MIDDLE:String = "middle";

		/**
		 * The items will be aligned to the bottom of the bounds.
		 */
		public static const VERTICAL_ALIGN_BOTTOM:String = "bottom";

		/**
		 * The items will fill the height of the bounds.
		 */
		public static const VERTICAL_ALIGN_JUSTIFY:String = "justify";

		/**
		 * If the total item width is smaller than the width of the bounds, the
		 * items will be aligned to the left.
		 */
		public static const HORIZONTAL_ALIGN_LEFT:String = "left";

		/**
		 * If the total item width is smaller than the width of the bounds, the
		 * items will be aligned to the center.
		 */
		public static const HORIZONTAL_ALIGN_CENTER:String = "center";

		/**
		 * If the total item width is smaller than the width of the bounds, the
		 * items will be aligned to the right.
		 */
		public static const HORIZONTAL_ALIGN_RIGHT:String = "right";

		/**
		 * Constructor.
		 */
		public function HorizontalLayout()
		{
		}

		/**
		 * @private
		 */
		private var _gap:Number = 0;

		/**
		 * The space, in pixels, between items.
		 */
		public function get gap():Number
		{
			return this._gap;
		}

		/**
		 * @private
		 */
		public function set gap(value:Number):void
		{
			if(this._gap == value)
			{
				return;
			}
			this._gap = value;
			this._onLayoutChange.dispatch(this);
		}

		/**
		 * @private
		 */
		private var _paddingTop:Number = 0;

		/**
		 * The minimum space, in pixels, above the items.
		 */
		public function get paddingTop():Number
		{
			return this._paddingTop;
		}

		/**
		 * @private
		 */
		public function set paddingTop(value:Number):void
		{
			if(this._paddingTop == value)
			{
				return;
			}
			this._paddingTop = value;
			this._onLayoutChange.dispatch(this);
		}

		/**
		 * @private
		 */
		private var _paddingRight:Number = 0;

		/**
		 * The space, in pixels, after the last item.
		 */
		public function get paddingRight():Number
		{
			return this._paddingRight;
		}

		/**
		 * @private
		 */
		public function set paddingRight(value:Number):void
		{
			if(this._paddingRight == value)
			{
				return;
			}
			this._paddingRight = value;
			this._onLayoutChange.dispatch(this);
		}

		/**
		 * @private
		 */
		private var _paddingBottom:Number = 0;

		/**
		 * The minimum space, in pixels, above the items.
		 */
		public function get paddingBottom():Number
		{
			return this._paddingBottom;
		}

		/**
		 * @private
		 */
		public function set paddingBottom(value:Number):void
		{
			if(this._paddingBottom == value)
			{
				return;
			}
			this._paddingBottom = value;
			this._onLayoutChange.dispatch(this);
		}

		/**
		 * @private
		 */
		private var _paddingLeft:Number = 0;

		/*
		 * The space, in pixels, before the first item.
		 */
		public function get paddingLeft():Number
		{
			return this._paddingLeft;
		}

		/**
		 * @private
		 */
		public function set paddingLeft(value:Number):void
		{
			if(this._paddingLeft == value)
			{
				return;
			}
			this._paddingLeft = value;
			this._onLayoutChange.dispatch(this);
		}

		/**
		 * @private
		 */
		private var _verticalAlign:String = VERTICAL_ALIGN_TOP;

		/**
		 * The alignment of the items vertically, on the y-axis.
		 */
		public function get verticalAlign():String
		{
			return this._verticalAlign;
		}

		/**
		 * @private
		 */
		public function set verticalAlign(value:String):void
		{
			if(this._verticalAlign == value)
			{
				return;
			}
			this._verticalAlign = value;
			this._onLayoutChange.dispatch(this);
		}

		/**
		 * @private
		 */
		private var _horizontalAlign:String = HORIZONTAL_ALIGN_LEFT;

		/**
		 * If the total item width is less than the bounds, the positions of
		 * the items can be aligned horizontally.
		 */
		public function get horizontalAlign():String
		{
			return this._horizontalAlign;
		}

		/**
		 * @private
		 */
		public function set horizontalAlign(value:String):void
		{
			if(this._horizontalAlign == value)
			{
				return;
			}
			this._horizontalAlign = value;
			this._onLayoutChange.dispatch(this);
		}

		/**
		 * @private
		 */
		protected var _onLayoutChange:Signal = new Signal(ILayout);

		/**
		 * @inheritDoc
		 */
		public function get onLayoutChange():ISignal
		{
			return this._onLayoutChange;
		}

		/**
		 * @inheritDoc
		 */
		public function layout(items:ListCollection, suggestedBounds:Rectangle, resultDimensions:Point = null):Point
		{
			var maxHeight:Number = 0;
			var positionX:Number = suggestedBounds.x + this._paddingLeft;
			const itemCount:int = items.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:DisplayObject = DisplayObject(items.getItemAt(i));
				item.x = positionX;
				switch(this._verticalAlign)
				{
					case VERTICAL_ALIGN_BOTTOM:
					{
						item.y = suggestedBounds.y + suggestedBounds.height - this._paddingBottom - item.height;
						break;
					}
					case VERTICAL_ALIGN_MIDDLE:
					{
						item.y = suggestedBounds.y + this._paddingTop + (suggestedBounds.height - this._paddingTop - this._paddingBottom - item.height) / 2;
						break;
					}
					case VERTICAL_ALIGN_JUSTIFY:
					{
						item.y = this._paddingTop;
						item.height = suggestedBounds.height - this._paddingTop - this._paddingBottom;
						break;
					}
					default: //top
					{
						item.y = this._paddingTop;
					}
				}
				positionX += item.width + this._gap;
				maxHeight = Math.max(maxHeight, item.height);
			}
			const totalWidth:Number = positionX - this._gap + this._paddingRight - suggestedBounds.x;
			if(totalWidth < suggestedBounds.width)
			{
				var horizontalAlignOffsetX:Number = 0;
				if(this._horizontalAlign == HORIZONTAL_ALIGN_RIGHT)
				{
					horizontalAlignOffsetX = suggestedBounds.width - totalWidth;
				}
				else if(this._horizontalAlign == HORIZONTAL_ALIGN_CENTER)
				{
					horizontalAlignOffsetX = (suggestedBounds.width - totalWidth) / 2;
				}
				if(horizontalAlignOffsetX != 0)
				{
					for(i = 0; i < itemCount; i++)
					{
						item = DisplayObject(items.getItemAt(i));
						item.x += horizontalAlignOffsetX;
					}
				}
			}

			if(!resultDimensions)
			{
				resultDimensions = new Point();
			}
			resultDimensions.x = Math.max(suggestedBounds.width, totalWidth);
			resultDimensions.y = Math.max(suggestedBounds.height, maxHeight);
			return resultDimensions;
		}
	}
}
