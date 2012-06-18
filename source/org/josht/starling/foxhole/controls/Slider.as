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
	import flash.geom.Rectangle;

	import org.josht.starling.foxhole.core.FoxholeControl;
	import org.josht.starling.foxhole.core.PropertyProxy;
	import org.josht.utils.math.clamp;
	import org.josht.utils.math.roundToNearest;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * Select a value between a minimum and a maximum by dragging a thumb over
	 * the bounds of a track. The slider's track is divided into two parts split
	 * by the thumb.
	 */
	public class Slider extends FoxholeControl
	{
		/**
		 * The slider's thumb may be dragged horizontally (on the x-axis).
		 */
		public static const DIRECTION_HORIZONTAL:String = "horizontal";
		
		/**
		 * The slider's thumb may be dragged vertically (on the y-axis).
		 */
		public static const DIRECTION_VERTICAL:String = "vertical";

		/**
		 * The slider has only one track, stretching to fill the full length of
		 * the slider. In this layout mode, the minimum track is displayed, but
		 * the maximum track is hidden.
		 */
		public static const TRACK_LAYOUT_MODE_SINGLE:String = "single";

		/**
		 * The slider's minimum and maximum track will by resized by changing
		 * their width and height values. Consider using a special display
		 * object such as a Scale9Image, Scale3Image or a TiledImage if the
		 * skins should be resizable.
		 */
		public static const TRACK_LAYOUT_MODE_STRETCH:String = "stretch";

		/**
		 * The slider's minimum and maximum tracks will be resized and cropped
		 * using a scrollRect to ensure that the skins maintain a static
		 * appearance without altering the aspect ratio.
		 */
		public static const TRACK_LAYOUT_MODE_SCROLL:String = "scroll";
		
		/**
		 * Constructor.
		 */
		public function Slider()
		{
			super();
		}

		/**
		 * The value added to the <code>nameList</code> of the minimum track.
		 */
		protected var defaultMinimumTrackName:String = "foxhole-slider-minimum-track";

		/**
		 * The value added to the <code>nameList</code> of the maximum track.
		 */
		protected var defaultMaximumTrackName:String = "foxhole-slider-maximum-track";

		/**
		 * The value added to the <code>nameList</code> of the thumb.
		 */
		protected var defaultThumbName:String = "foxhole-slider-thumb";
		
		/**
		 * @private
		 */
		protected var minimumTrack:Button;

		/**
		 * @private
		 */
		protected var maximumTrack:Button;

		/**
		 * @private
		 */
		protected var minimumTrackOriginalWidth:Number = NaN;

		/**
		 * @private
		 */
		protected var minimumTrackOriginalHeight:Number = NaN;

		/**
		 * @private
		 */
		protected var maximumTrackOriginalWidth:Number = NaN;

		/**
		 * @private
		 */
		protected var maximumTrackOriginalHeight:Number = NaN;
		
		/**
		 * @private
		 */
		protected var thumb:Button;
		
		/**
		 * @private
		 */
		protected var _onChange:Signal = new Signal(Slider);
		
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
		protected var _onDragStart:Signal = new Signal(Slider);

		/**
		 * Dispatched when the user begins dragging slider (using either the
		 * thumb or the track).
		 */
		public function get onDragStart():ISignal
		{
			return this._onDragStart;
		}

		/**
		 * @private
		 */
		protected var _onDragEnd:Signal = new Signal(Slider);

		/**
		 * Dispatched when the user stops dragging slider (using either the
		 * thumb or the track).
		 */
		public function get onDragEnd():ISignal
		{
			return this._onDragEnd;
		}
		
		/**
		 * @private
		 */
		protected var _direction:String = DIRECTION_HORIZONTAL;
		
		/**
		 * Determines if the slider's thumb can be dragged horizontally or
		 * vertically. When this value changes, the slider's width and height
		 * values do not change automatically.
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
		 * @private
		 */
		protected var _value:Number = 0;
		
		/**
		 * The value of the slider, between the minimum and maximum.
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
			newValue = clamp(newValue, this._minimum, this._maximum);
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
		 * The slider's value will not go lower than the minimum.
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
		 * The slider's value will not go higher than the maximum.
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
		 * As the slider's thumb is dragged, the value is snapped to a multiple
		 * of the step.
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
		protected var isDragging:Boolean = false;
		
		/**
		 * Determines if the slider dispatches the onChange signal every time
		 * the thumb moves, or only once it stops moving.
		 */
		public var liveDragging:Boolean = true;
		
		/**
		 * @private
		 */
		protected var _showThumb:Boolean = true;
		
		/**
		 * Determines if the thumb should be displayed.
		 */
		public function get showThumb():Boolean
		{
			return this._showThumb;
		}
		
		/**
		 * @private
		 */
		public function set showThumb(value:Boolean):void
		{
			if(this._showThumb == value)
			{
				return;
			}
			this._showThumb = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _trackLayoutMode:String = TRACK_LAYOUT_MODE_SINGLE;

		/**
		 * Determines how the minimum and maximum track skins are positioned and
		 * sized.
		 */
		public function get trackLayoutMode():String
		{
			return this._trackLayoutMode;
		}

		/**
		 * @private
		 */
		public function set trackLayoutMode(value:String):void
		{
			if(this._trackLayoutMode == value)
			{
				return;
			}
			this._trackLayoutMode = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _minimumTrackProperties:PropertyProxy = new PropertyProxy(minimumTrackProperties_onChange);

		/**
		 * A set of key/value pairs to be passed down to the slider's minimum
		 * track instance. The minimum track is a Foxhole Button control.
		 */
		public function get minimumTrackProperties():Object
		{
			return this._minimumTrackProperties;
		}

		/**
		 * @private
		 */
		public function set minimumTrackProperties(value:Object):void
		{
			if(this._minimumTrackProperties == value)
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
			if(this._minimumTrackProperties)
			{
				this._minimumTrackProperties.onChange.remove(minimumTrackProperties_onChange);
			}
			this._minimumTrackProperties = PropertyProxy(value);
			if(this._minimumTrackProperties)
			{
				this._minimumTrackProperties.onChange.add(minimumTrackProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		/**
		 * @private
		 */
		private var _maximumTrackProperties:PropertyProxy = new PropertyProxy(maximumTrackProperties_onChange);
		
		/**
		 * A set of key/value pairs to be passed down to the slider's maximum
		 * track instance. The maximum track is a Foxhole Button control.
		 */
		public function get maximumTrackProperties():Object
		{
			return this._maximumTrackProperties;
		}
		
		/**
		 * @private
		 */
		public function set maximumTrackProperties(value:Object):void
		{
			if(this._maximumTrackProperties == value)
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
			if(this._maximumTrackProperties)
			{
				this._maximumTrackProperties.onChange.remove(maximumTrackProperties_onChange);
			}
			this._maximumTrackProperties = PropertyProxy(value);
			if(this._maximumTrackProperties)
			{
				this._maximumTrackProperties.onChange.add(maximumTrackProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		/**
		 * @private
		 */
		private var _thumbProperties:PropertyProxy = new PropertyProxy(thumbProperties_onChange);
		
		/**
		 * A set of key/value pairs to be passed down to the slider's thumb
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
			if(!this.minimumTrack)
			{
				this.minimumTrack = new Button();
				this.minimumTrack.nameList.add(this.defaultMinimumTrackName);
				this.minimumTrack.label = "";
				this.minimumTrack.keepDownStateOnRollOut = true;
				this.minimumTrack.addEventListener(TouchEvent.TOUCH, track_touchHandler);
				this.addChild(this.minimumTrack);
			}
			
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

			this.createOrDestroyMaximumTrackIfNeeded();

			if(stylesInvalid)
			{
				this.refreshThumbStyles();
				this.refreshTrackStyles();
			}
			
			if(stateInvalid)
			{
				this.thumb.isEnabled = this.minimumTrack.isEnabled = isEnabled;
				if(this.maximumTrack)
				{
					this.maximumTrack.isEnabled = this._isEnabled;
				}
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
			if(isNaN(this.minimumTrackOriginalWidth) || isNaN(this.minimumTrackOriginalHeight))
			{
				this.minimumTrack.validate();
				this.minimumTrackOriginalWidth = this.minimumTrack.width;
				this.minimumTrackOriginalHeight = this.minimumTrack.height;
			}
			if(this.maximumTrack)
			{
				if(isNaN(this.maximumTrackOriginalWidth) || isNaN(this.maximumTrackOriginalHeight))
				{
					this.maximumTrack.validate();
					this.maximumTrackOriginalWidth = this.maximumTrack.width;
					this.maximumTrackOriginalHeight = this.maximumTrack.height;
				}
			}

			const needsWidth:Boolean = isNaN(this.explicitWidth);
			const needsHeight:Boolean = isNaN(this.explicitHeight);
			if(!needsWidth && !needsHeight)
			{
				return false;
			}
			this.thumb.validate();
			var newWidth:Number = this.explicitWidth;
			var newHeight:Number = this.explicitHeight;
			if(needsWidth)
			{
				if(this._direction == DIRECTION_VERTICAL)
				{
					if(this.maximumTrack)
					{
						newWidth = Math.max(this.minimumTrackOriginalWidth, this.maximumTrackOriginalWidth);
					}
					else
					{
						newWidth = this.minimumTrackOriginalWidth;
					}
				}
				else //horizontal
				{
					if(this.maximumTrack)
					{
						newWidth = Math.min(this.minimumTrackOriginalWidth, this.maximumTrackOriginalWidth) + this.thumb.width / 2;
					}
					else
					{
						newWidth = this.minimumTrackOriginalWidth;
					}
				}
			}
			if(needsHeight)
			{
				if(this._direction == DIRECTION_VERTICAL)
				{
					if(this.maximumTrack)
					{
						newHeight = Math.min(this.minimumTrackOriginalHeight, this.maximumTrackOriginalHeight) + this.thumb.height / 2;
					}
					else
					{
						newHeight = this.minimumTrackOriginalHeight;
					}
				}
				else //horizontal
				{
					if(this.maximumTrack)
					{
						newHeight = Math.max(this.minimumTrackOriginalHeight, this.maximumTrackOriginalHeight);
					}
					else
					{
						newHeight = this.minimumTrackOriginalHeight;
					}
				}
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
			this.thumb.visible = this._showThumb;
		}
		
		/**
		 * @private
		 */
		protected function refreshTrackStyles():void
		{
			for(var propertyName:String in this._minimumTrackProperties)
			{
				if(this.minimumTrack.hasOwnProperty(propertyName))
				{
					var propertyValue:Object = this._minimumTrackProperties[propertyName];
					this.minimumTrack[propertyName] = propertyValue;
				}
			}
			if(this.maximumTrack)
			{
				for(propertyName in this._maximumTrackProperties)
				{
					if(this.maximumTrack.hasOwnProperty(propertyName))
					{
						propertyValue = this._maximumTrackProperties[propertyName];
						this.maximumTrack[propertyName] = propertyValue;
					}
				}
			}
		}

		/**
		 * @private
		 */
		protected function layout():void
		{
			this.layoutThumb();

			if(this._trackLayoutMode == TRACK_LAYOUT_MODE_SCROLL)
			{
				this.layoutTrackWithScrollRect();
			}
			else if(this._trackLayoutMode == TRACK_LAYOUT_MODE_STRETCH)
			{
				this.layoutTrackWithStretch();
			}
			else //single
			{
				this.layoutTrackWithSingle();
			}
		}

		/**
		 * @private
		 */
		protected function layoutThumb():void
		{
			//this will auto-size the thumb, if needed
			this.thumb.validate();

			if(this._direction == DIRECTION_VERTICAL)
			{
				const trackScrollableHeight:Number = this.actualHeight - this.thumb.height;
				this.thumb.x = (this.actualWidth - this.thumb.width) / 2;
				this.thumb.y = trackScrollableHeight * (1 - (this._value - this._minimum) / (this._maximum - this._minimum));
			}
			else
			{
				const trackScrollableWidth:Number = this.actualWidth - this.thumb.width;
				this.thumb.x = (trackScrollableWidth * (this._value - this._minimum) / (this._maximum - this._minimum));
				this.thumb.y = (this.actualHeight - this.thumb.height) / 2;
			}
		}

		/**
		 * @private
		 */
		protected function layoutTrackWithScrollRect():void
		{
			if(this._direction == DIRECTION_VERTICAL)
			{
				//we want to scale the skins to match the height of the slider,
				//but we also want to keep the original aspect ratio.
				const minimumTrackScaledHeight:Number = this.minimumTrackOriginalHeight * this.actualWidth / this.minimumTrackOriginalWidth;
				const maximumTrackScaledHeight:Number = this.maximumTrackOriginalHeight * this.actualWidth / this.maximumTrackOriginalWidth;
				this.minimumTrack.width = this.actualWidth;
				this.minimumTrack.height = minimumTrackScaledHeight;
				this.maximumTrack.width = this.actualWidth;
				this.maximumTrack.height = maximumTrackScaledHeight;

				var middleOfThumb:Number = this.thumb.y + this.thumb.height / 2;
				this.maximumTrack.x = 0;
				this.maximumTrack.y = 0;
				var currentScrollRect:Rectangle = this.maximumTrack.scrollRect;
				if(!currentScrollRect)
				{
					currentScrollRect = new Rectangle();
				}
				currentScrollRect.x = 0;
				currentScrollRect.y = 0;
				currentScrollRect.width = this.actualWidth;
				currentScrollRect.height = Math.min(maximumTrackScaledHeight, middleOfThumb);
				this.maximumTrack.scrollRect = currentScrollRect;

				this.minimumTrack.x = 0;
				this.minimumTrack.y = Math.max(this.actualHeight - minimumTrackScaledHeight, middleOfThumb);
				currentScrollRect = this.minimumTrack.scrollRect;
				if(!currentScrollRect)
				{
					currentScrollRect = new Rectangle();
				}
				currentScrollRect.width = this.actualWidth;
				currentScrollRect.height = Math.min(minimumTrackScaledHeight, this.actualHeight - middleOfThumb);
				currentScrollRect.x = 0;
				currentScrollRect.y = Math.max(0, minimumTrackScaledHeight - currentScrollRect.height);
				this.minimumTrack.scrollRect = currentScrollRect;
			}
			else //horizontal
			{
				//we want to scale the skins to match the height of the slider,
				//but we also want to keep the original aspect ratio.
				const minimumTrackScaledWidth:Number = this.minimumTrackOriginalWidth * this.actualHeight / this.minimumTrackOriginalHeight;
				const maximumTrackScaledWidth:Number = this.maximumTrackOriginalWidth * this.actualHeight / this.maximumTrackOriginalHeight;
				this.minimumTrack.width = minimumTrackScaledWidth;
				this.minimumTrack.height = this.actualHeight;
				this.maximumTrack.width = maximumTrackScaledWidth;
				this.maximumTrack.height = this.actualHeight;

				middleOfThumb = this.thumb.x + this.thumb.width / 2;
				this.minimumTrack.x = 0;
				this.minimumTrack.y = 0;
				currentScrollRect = this.minimumTrack.scrollRect;
				if(!currentScrollRect)
				{
					currentScrollRect = new Rectangle();
				}
				currentScrollRect.x = 0;
				currentScrollRect.y = 0;
				currentScrollRect.width = Math.min(minimumTrackScaledWidth, middleOfThumb);
				currentScrollRect.height = this.actualHeight;
				this.minimumTrack.scrollRect = currentScrollRect;

				this.maximumTrack.x = Math.max(this.actualWidth - maximumTrackScaledWidth, middleOfThumb);
				this.maximumTrack.y = 0;
				currentScrollRect = this.maximumTrack.scrollRect;
				if(!currentScrollRect)
				{
					currentScrollRect = new Rectangle();
				}
				currentScrollRect.width = Math.min(maximumTrackScaledWidth, this.actualWidth - middleOfThumb);
				currentScrollRect.height = this.actualHeight;
				currentScrollRect.x = Math.max(0, maximumTrackScaledWidth - currentScrollRect.width);
				currentScrollRect.y = 0;
				this.maximumTrack.scrollRect = currentScrollRect;
			}
		}

		/**
		 * @private
		 */
		protected function layoutTrackWithStretch():void
		{
			if(this.minimumTrack.scrollRect)
			{
				this.minimumTrack.scrollRect = null;
			}
			if(this.maximumTrack.scrollRect)
			{
				this.maximumTrack.scrollRect = null;
			}

			if(this._direction == DIRECTION_VERTICAL)
			{
				this.maximumTrack.x = 0;
				this.maximumTrack.y = 0;
				this.maximumTrack.width = this.actualWidth;
				this.maximumTrack.height = this.thumb.y + this.thumb.height / 2;

				this.minimumTrack.x = 0;
				this.minimumTrack.y = this.maximumTrack.height;
				this.minimumTrack.width = this.actualWidth;
				this.minimumTrack.height = this.actualHeight - this.minimumTrack.y;
			}
			else //horizontal
			{
				this.minimumTrack.x = 0;
				this.minimumTrack.y = 0;
				this.minimumTrack.width = this.thumb.x + this.thumb.width / 2;
				this.minimumTrack.height = this.actualHeight;

				this.maximumTrack.x = this.minimumTrack.width;
				this.maximumTrack.y = 0;
				this.maximumTrack.width = this.actualWidth - this.maximumTrack.x;
				this.maximumTrack.height = this.actualHeight;
			}
		}

		/**
		 * @private
		 */
		protected function layoutTrackWithSingle():void
		{
			if(this.minimumTrack.scrollRect)
			{
				this.minimumTrack.scrollRect = null;
			}
			this.minimumTrack.x = 0;
			this.minimumTrack.y = 0;
			this.minimumTrack.width = this.actualWidth;
			this.minimumTrack.height = this.actualHeight;
		}

		/**
		 * @private
		 */
		protected function createOrDestroyMaximumTrackIfNeeded():void
		{
			if(this._trackLayoutMode == TRACK_LAYOUT_MODE_SCROLL || this._trackLayoutMode == TRACK_LAYOUT_MODE_STRETCH)
			{
				if(!this.maximumTrack)
				{
					this.maximumTrack = new Button();
					this.maximumTrack.nameList.add(this.defaultMaximumTrackName);
					this.maximumTrack.label = "";
					this.maximumTrack.keepDownStateOnRollOut = true;
					this.maximumTrack.addEventListener(TouchEvent.TOUCH, track_touchHandler);
					this.addChildAt(this.maximumTrack, 1);
				}
			}
			else if(this.maximumTrack) //single
			{
				this.maximumTrack.removeFromParent(true);
				this.maximumTrack = null;
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
				percentage = 1 - (yPosition / trackScrollableHeight);
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
		protected function minimumTrackProperties_onChange(proxy:PropertyProxy, name:Object):void
		{
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected function maximumTrackProperties_onChange(proxy:PropertyProxy, name:Object):void
		{
			this.invalidate(INVALIDATION_FLAG_STYLES);
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
		protected function track_touchHandler(event:TouchEvent):void
		{
			if(!this._isEnabled)
			{
				return;
			}
			const touch:Touch = event.getTouch(DisplayObject(event.currentTarget));
			if(!touch || (this._touchPointID >= 0 && this._touchPointID != touch.id))
			{
				return;
			}

			event.stopPropagation();
			if(touch.phase == TouchPhase.BEGAN || touch.phase == TouchPhase.MOVED)
			{
				const location:Point = touch.getLocation(this);
				if(touch.phase == TouchPhase.BEGAN)
				{
					this._touchPointID = touch.id;
					if(this._direction == DIRECTION_VERTICAL)
					{
						this._thumbStartX = location.x;
						this._thumbStartY = Math.min(this.actualHeight - this.thumb.height, Math.max(0, location.y - this.thumb.height / 2));
					}
					else //horizontal
					{
						this._thumbStartX = Math.min(this.actualWidth - this.thumb.width, Math.max(0, location.x - this.thumb.width / 2));
						this._thumbStartY = location.y;
					}
					this._touchStartX = location.x;
					this._touchStartY = location.y;
					this.isDragging = true;
					this._onDragStart.dispatch(this);
				}
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