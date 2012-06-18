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
package org.josht.starling.foxhole.controls
{
	import flash.geom.Point;

	import org.josht.starling.foxhole.core.FoxholeControl;
	import org.josht.starling.foxhole.core.PropertyProxy;
	import org.josht.utils.math.clamp;
	import org.josht.utils.math.roundToNearest;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * Select a value between a minimum and a maximum by dragging a thumb over
	 * a physical range.
	 */
	public class SimpleScrollBar extends FoxholeControl implements IScrollBar
	{
		/**
		 * The scrollbar's thumb may be dragged horizontally (on the x-axis).
		 */
		public static const DIRECTION_HORIZONTAL:String = "horizontal";

		/**
		 * The scrollbar's thumb may be dragged vertically (on the y-axis).
		 */
		public static const DIRECTION_VERTICAL:String = "vertical";

		/**
		 * Constructor.
		 */
		public function SimpleScrollBar()
		{
		}

		/**
		 * The value added to the <code>nameList</code> of the thumb.
		 */
		protected var defaultThumbName:String = "foxhole-simple-scroll-bar-thumb";

		/**
		 * @private
		 */
		protected var thumbOriginalWidth:Number = NaN;

		/**
		 * @private
		 */
		protected var thumbOriginalHeight:Number = NaN;

		/**
		 * @private
		 */
		protected var thumb:Button;

		/**
		 * @private
		 */
		protected var _direction:String = DIRECTION_HORIZONTAL;

		/**
		 * Determines if the scroll bar's thumb can be dragged horizontally or
		 * vertically. When this value changes, the scroll bar's width and
		 * height values do not change automatically.
		 */
		public function get direction():String
		{
			return this._direction;
		}

		/**
		 * @private
		 */
		public function set direction(value:String):void
		{
			if(this._direction == value)
			{
				return;
			}
			this._direction = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * Determines if the value should be clamped to the range between the
		 * minimum and maximum. If false and the value is outside of the range,
		 * the thumb will shrink as if the range were increasing.
		 */
		public var clampToRange:Boolean = false;

		/**
		 * @private
		 */
		protected var _value:Number = 0;

		/**
		 * @inheritDoc
		 */
		public function get value():Number
		{
			return this._value;
		}

		/**
		 * @private
		 */
		public function set value(newValue:Number):void
		{
			if(this._step != 0)
			{
				newValue = roundToNearest(newValue, this._step);
			}
			if(this.clampToRange)
			{
				newValue = clamp(newValue, this._minimum, this._maximum);
			}
			if(this._value == newValue)
			{
				return;
			}
			this._value = newValue;
			this.invalidate(INVALIDATION_FLAG_DATA);
			if(this.liveDragging || !this.isDragging)
			{
				this._onChange.dispatch(this);
			}
		}

		/**
		 * @private
		 */
		protected var _minimum:Number = 0;

		/**
		 * @inheritDoc
		 */
		public function get minimum():Number
		{
			return this._minimum;
		}

		/**
		 * @private
		 */
		public function set minimum(value:Number):void
		{
			if(this._minimum == value)
			{
				return;
			}
			this._minimum = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _maximum:Number = 0;

		/**
		 * @inheritDoc
		 */
		public function get maximum():Number
		{
			return this._maximum;
		}

		/**
		 * @private
		 */
		public function set maximum(value:Number):void
		{
			if(this._maximum == value)
			{
				return;
			}
			this._maximum = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _step:Number = 0;

		/**
		 * @inheritDoc
		 */
		public function get step():Number
		{
			return this._step;
		}

		/**
		 * @private
		 */
		public function set step(value:Number):void
		{
			if(this._step == value)
			{
				return;
			}
			this._step = value;
		}

		/**
		 * @private
		 */
		private var _pageStep:Number = 0;

		/**
		 * @inheritDoc
		 */
		public function get page():Number
		{
			return this._pageStep;
		}

		/**
		 * @private
		 */
		public function set page(value:Number):void
		{
			if(this._pageStep == value)
			{
				return;
			}
			this._pageStep = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _paddingTop:Number = 0;

		/**
		 * The minimum space, in pixels, above the thumb.
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
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _paddingRight:Number = 0;

		/**
		 * The minimum space, in pixels, to the right of the thumb.
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
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _paddingBottom:Number = 0;

		/**
		 * The minimum space, in pixels, below the thumb.
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
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _paddingLeft:Number = 0;

		/**
		 * The minimum space, in pixels, to the left of the thumb.
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
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var isDragging:Boolean = false;

		/**
		 * Determines if the scroll bar dispatches the <code>onChange</code>
		 * signal every time the thumb moves, or only once it stops moving.
		 */
		public var liveDragging:Boolean = true;

		/**
		 * @private
		 */
		protected var _onChange:Signal = new Signal(SimpleScrollBar);

		/**
		 * Dispatched when the <code>value</code> property changes.
		 */
		public function get onChange():ISignal
		{
			return this._onChange;
		}

		/**
		 * @private
		 */
		protected var _onDragStart:Signal = new Signal(SimpleScrollBar);

		/**
		 * Dispatched when the user begins dragging the thumb.
		 */
		public function get onDragStart():ISignal
		{
			return this._onDragStart;
		}

		/**
		 * @private
		 */
		protected var _onDragEnd:Signal = new Signal(SimpleScrollBar);

		/**
		 * Dispatched when the user stops dragging the thumb.
		 */
		public function get onDragEnd():ISignal
		{
			return this._onDragEnd;
		}

		/**
		 * @private
		 */
		private var _thumbProperties:PropertyProxy = new PropertyProxy(thumbProperties_onChange);

		/**
		 * A set of key/value pairs to be passed down to the scroll bar's thumb
		 * instance. The thumb is a Foxhole Button control.
		 */
		public function get thumbProperties():Object
		{
			return this._thumbProperties;
		}

		/**
		 * @private
		 */
		public function set thumbProperties(value:Object):void
		{
			if(this._thumbProperties == value)
			{
				return;
			}
			if(!value)
			{
				value = new PropertyProxy();
			}
			if(!(value is PropertyProxy))
			{
				const newValue:PropertyProxy = new PropertyProxy();
				for(var propertyName:String in value)
				{
					newValue[propertyName] = value[propertyName];
				}
				value = newValue;
			}
			if(this._thumbProperties)
			{
				this._thumbProperties.onChange.remove(thumbProperties_onChange);
			}
			this._thumbProperties = PropertyProxy(value);
			if(this._thumbProperties)
			{
				this._thumbProperties.onChange.add(thumbProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		private var _touchPointID:int = -1;
		private var _touchStartX:Number = NaN;
		private var _touchStartY:Number = NaN;
		private var _thumbStartX:Number = NaN;
		private var _thumbStartY:Number = NaN;

		/**
		 * @inheritDoc
		 */
		override public function dispose():void
		{
			this._onChange.removeAll();
			this._onDragEnd.removeAll();
			this._onDragStart.removeAll();
			super.dispose();
		}

		/**
		 * @private
		 */
		override protected function initialize():void
		{
			if(!this.thumb)
			{
				this.thumb = new Button();
				this.thumb.nameList.add(this.defaultThumbName);
				this.thumb.label = "";
				this.thumb.keepDownStateOnRollOut = true;
				this.thumb.addEventListener(TouchEvent.TOUCH, thumb_touchHandler);
				this.addChild(this.thumb);
			}
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			const stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);

			if(stylesInvalid)
			{
				this.refreshThumbStyles();
			}

			if(stateInvalid)
			{
				this.thumb.isEnabled = isEnabled;
			}

			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

			if(dataInvalid || stylesInvalid || sizeInvalid)
			{
				this.layout();
			}
		}

		/**
		 * @private
		 */
		protected function autoSizeIfNeeded():Boolean
		{
			if(isNaN(this.thumbOriginalWidth) || isNaN(this.thumbOriginalHeight))
			{
				this.thumb.validate();
				this.thumbOriginalWidth = this.thumb.width;
				this.thumbOriginalHeight = this.thumb.height;
			}

			const needsWidth:Boolean = isNaN(this.explicitWidth);
			const needsHeight:Boolean = isNaN(this.explicitHeight);
			if(!needsWidth && !needsHeight)
			{
				return false;
			}

			const range:Number = this._maximum - this._minimum;
			if(range <= 0)
			{
				return false;
			}

			//we're just going to make something up in this case
			const adjustedPageStep:Number = this._pageStep == 0 ? range / 10 : this._pageStep;
			var newWidth:Number = this.explicitWidth;
			var newHeight:Number = this.explicitHeight;
			if(needsWidth)
			{
				if(this._direction == DIRECTION_VERTICAL)
				{
					newWidth = this.thumbOriginalWidth;
				}
				else //horizontal
				{
					newWidth = Math.max(this.thumbOriginalWidth, this.thumbOriginalWidth * range / adjustedPageStep);
				}
				newWidth += this._paddingLeft + this._paddingRight;
			}
			if(needsHeight)
			{
				if(this._direction == DIRECTION_VERTICAL)
				{
					newHeight = Math.max(this.thumbOriginalHeight, this.thumbOriginalHeight * range / adjustedPageStep);
				}
				else //horizontal
				{
					newHeight = this.thumbOriginalHeight;
				}
				newHeight += this._paddingTop + this._paddingBottom;
			}
			return this.setSizeInternal(newWidth, newHeight, false);
		}

		/**
		 * @private
		 */
		protected function refreshThumbStyles():void
		{
			for(var propertyName:String in this._thumbProperties)
			{
				if(this.thumb.hasOwnProperty(propertyName))
				{
					var propertyValue:Object = this._thumbProperties[propertyName];
					this.thumb[propertyName] = propertyValue;
				}
			}
		}

		/**
		 * @private
		 */
		protected function layout():void
		{
			const range:Number = this._maximum - this._minimum;
			this.thumb.visible = range > 0;
			if(!this.thumb.visible)
			{
				return;
			}

			//this will auto-size the thumb, if needed
			this.thumb.validate();

			const contentWidth:Number = this.actualWidth - this._paddingLeft - this._paddingRight;
			const contentHeight:Number = this.actualHeight - this._paddingTop - this._paddingBottom;
			const adjustedPageStep:Number = Math.min(range, this._pageStep == 0 ? range : this._pageStep);
			var adjustedRange:Number = range;
			if(this._value < this._minimum)
			{
				adjustedRange += (this._minimum - this._value);
			}
			if(this._value > this._maximum)
			{
				adjustedRange += (this._value - this._maximum);
			}

			if(this._direction == DIRECTION_VERTICAL)
			{
				this.thumb.width = this.thumbOriginalWidth;
				this.thumb.height = Math.max(this.thumbOriginalHeight, contentHeight * adjustedPageStep / (adjustedRange + adjustedPageStep));
				const trackScrollableHeight:Number = contentHeight - this.thumb.height;
				this.thumb.x = (this.actualWidth - this.thumb.width) / 2;
				this.thumb.y = this._paddingTop + Math.max(0, Math.min(trackScrollableHeight, trackScrollableHeight * (this._value - this._minimum) / range));
			}
			else //horizontal
			{
				this.thumb.width = Math.max(this.thumbOriginalWidth, contentWidth * adjustedPageStep / (adjustedRange + adjustedPageStep));
				this.thumb.height = this.thumbOriginalHeight;
				const trackScrollableWidth:Number = contentWidth - this.thumb.width;
				this.thumb.x = this._paddingLeft + Math.max(0, Math.min(trackScrollableWidth, trackScrollableWidth * (this._value - this._minimum) / range));
				this.thumb.y = (this.actualHeight - this.thumb.height) / 2;
			}
		}

		/**
		 * @private
		 */
		protected function dragTo(location:Point):void
		{
			var percentage:Number;
			if(this._direction == DIRECTION_VERTICAL)
			{
				const trackScrollableHeight:Number = this.actualHeight - this.thumb.height;
				const yOffset:Number = location.y - this._touchStartY;
				const yPosition:Number = Math.min(Math.max(0, this._thumbStartY + yOffset), trackScrollableHeight);
				percentage = yPosition / trackScrollableHeight;
			}
			else //horizontal
			{
				const trackScrollableWidth:Number = this.actualWidth - this.thumb.width;
				const xOffset:Number = location.x - this._touchStartX;
				const xPosition:Number = Math.min(Math.max(0, this._thumbStartX + xOffset), trackScrollableWidth);
				percentage = xPosition / trackScrollableWidth;
			}

			this.value = this._minimum + percentage * (this._maximum - this._minimum);
		}

		/**
		 * @private
		 */
		protected function thumbProperties_onChange(proxy:PropertyProxy, name:Object):void
		{
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected function thumb_touchHandler(event:TouchEvent):void
		{
			if(!this._isEnabled)
			{
				return;
			}
			const touch:Touch = event.getTouch(this.thumb);
			if(!touch || (this._touchPointID >= 0 && this._touchPointID != touch.id))
			{
				return;
			}
			event.stopPropagation();
			const location:Point = touch.getLocation(this);
			if(touch.phase == TouchPhase.BEGAN)
			{
				this._touchPointID = touch.id;
				this._thumbStartX = this.thumb.x;
				this._thumbStartY = this.thumb.y;
				this._touchStartX = location.x;
				this._touchStartY = location.y;
				this.isDragging = true;
				this._onDragStart.dispatch(this);
			}
			else if(touch.phase == TouchPhase.MOVED)
			{
				this.dragTo(location);
			}
			else if(touch.phase == TouchPhase.ENDED)
			{
				this._touchPointID = -1;
				this.isDragging = false;
				if(!this.liveDragging)
				{
					this._onChange.dispatch(this);
				}
				this._onDragEnd.dispatch(this);
			}
		}
	}
}
