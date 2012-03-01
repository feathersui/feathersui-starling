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
	import org.josht.utils.math.clamp;
	import org.josht.utils.math.roundToNearest;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class Slider extends FoxholeControl
	{
		public static const DIRECTION_HORIZONTAL:String = "horizontal";
		public static const DIRECTION_VERTICAL:String = "vertical";
		
		public function Slider()
		{
			super();
		}
		
		protected var track:Button;
		protected var thumb:Button;
		
		private var _onChange:Signal = new Signal(Slider);
		
		public function get onChange():ISignal
		{
			return this._onChange;
		}
		
		private var _direction:String = DIRECTION_HORIZONTAL;
		
		public function get direction():String
		{
			return this._direction;
		}
		
		public function set direction(value:String):void
		{
			if(this._direction == value)
			{
				return;
			}
			this._direction = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		private var _value:Number = 0;
		
		public function get value():Number
		{
			return this._value;
		}
		
		public function set value(newValue:Number):void
		{
			newValue = clamp(newValue, this._minimum, this._maximum);
			if(this._step != 0)
			{
				newValue = roundToNearest(newValue, this._step);
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
		
		private var _minimum:Number = 0;
		
		public function get minimum():Number
		{
			return this._minimum;
		}
		
		public function set minimum(value:Number):void
		{
			if(this._minimum == value)
			{
				return;
			}
			this._minimum = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		private var _maximum:Number = 0;
		
		public function get maximum():Number
		{
			return this._maximum;
		}
		
		public function set maximum(value:Number):void
		{
			if(this._maximum == value)
			{
				return;
			}
			this._maximum = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		private var _step:Number = 0;
		
		public function get step():Number
		{
			return this._step;
		}
		
		public function set step(value:Number):void
		{
			if(this._step == value)
			{
				return;
			}
			this._step = value;
		}
		
		protected var isDragging:Boolean = false;
		public var liveDragging:Boolean = true;
		
		private var _showThumb:Boolean = true;
		
		public function get showThumb():Boolean
		{
			return this._showThumb;
		}
		
		public function set showThumb(value:Boolean):void
		{
			if(this._showThumb == value)
			{
				return;
			}
			this._showThumb = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		private var _trackProperties:Object = {};

		public function get trackProperties():Object
		{
			return this._trackProperties;
		}

		public function set trackProperties(value:Object):void
		{
			if(this._trackProperties == value)
			{
				return;
			}
			this._trackProperties = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		private var _thumbProperties:Object = {};

		public function get thumbProperties():Object
		{
			return this._thumbProperties;
		}

		public function set thumbProperties(value:Object):void
		{
			if(this._thumbProperties == value)
			{
				return;
			}
			this._thumbProperties = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		private var _touchPointID:int = -1;
		private var _touchStartX:Number = NaN;
		private var _touchStartY:Number = NaN;
		private var _thumbStartX:Number = NaN;
		private var _thumbStartY:Number = NaN;
		
		public function setThumbProperty(propertyName:String, propertyValue:Object):void
		{
			this._thumbProperties[propertyName] = propertyValue;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		public function setTrackProperty(propertyName:String, propertyValue:Object):void
		{
			this._trackProperties[propertyName] = propertyValue;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		override public function dispose():void
		{
			this._onChange.removeAll();
			super.dispose();
		}

		override protected function initialize():void
		{
			if(!this.track)
			{
				this.track = new Button();
				this.track.label = "";
				this.track.addEventListener(TouchEvent.TOUCH, track_touchHandler);
				this.addChild(this.track);
			}
			
			if(!this.thumb)
			{
				this.thumb = new Button();
				this.thumb.label = "";
				this.thumb.keepDownStateOnRollOut = true;
				this.thumb.addEventListener(TouchEvent.TOUCH, thumb_touchHandler);
				this.addChild(this.thumb);
			}
		}
		
		override protected function draw():void
		{
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			const stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			
			if(stylesInvalid)
			{
				this.refreshThumbStyles();
				this.refreshTrackStyles();
			}
			
			if(stateInvalid)
			{
				this.thumb.isEnabled = this.track.isEnabled = this._isEnabled;
			}
			
			//the slider will autosize based on the track skin (or track
			//properties) if width or height wasn't defined.
			if(isNaN(this._width) || isNaN(this._height))
			{
				this.track.validate();
				if(isNaN(this._width))
				{
					if(isNaN(this.track.width))
					{
						this._width = 160;
					}
					else
					{
						this._width = this.track.width;
					}
				}
				if(isNaN(this._height))
				{
					if(isNaN(this.track.height))
					{
						this._height = 22;
					}
					else
					{
						this._height = this.track.width;
					}
				}
				sizeInvalid = true;
			}
			
			if(stylesInvalid || sizeInvalid)
			{
				this.track.width = this._width;
				this.track.height = this._height;
			}
			
			if(dataInvalid || stylesInvalid || sizeInvalid)
			{
				if(this._direction == DIRECTION_HORIZONTAL)
				{
					const trackScrollableWidth:Number = this._width - this.thumb.width;
					this.thumb.x = (trackScrollableWidth * (this._value - this._minimum) / (this._maximum - this._minimum));
					this.thumb.y = (this._height - this.thumb.height) / 2;
				}
				else //vertical
				{
					const trackScrollableHeight:Number = this._height - this.thumb.height;
					this.thumb.x = (this._width - this.thumb.width) / 2;
					this.thumb.y = (trackScrollableHeight * (this._value - this._minimum) / (this._maximum - this._minimum));
				}
			}
			
			this.thumb.validate();
			this.track.validate();
		}
		
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
		
		protected function refreshTrackStyles():void
		{
			for(var propertyName:String in this._trackProperties)
			{
				if(this.track.hasOwnProperty(propertyName))
				{
					var propertyValue:Object = this._trackProperties[propertyName];
					this.track[propertyName] = propertyValue;
				}
			}
		}
		
		private function track_touchHandler(event:TouchEvent):void
		{
			if(!this._isEnabled)
			{
				return;
			}
			const touch:Touch = event.getTouch(this.track);
			if(!touch || touch.phase != TouchPhase.ENDED || this._touchPointID >= 0)
			{
				return;
			}
			var location:Point = touch.getLocation(this);
			var percentage:Number;
			if(this._direction == DIRECTION_HORIZONTAL)
			{
				percentage = location.x / this._width; 
			}
			else //vertical
			{
				percentage = location.y / this._height;
			}
			
			this.value = this._minimum + percentage * (this._maximum - this._minimum);
		}
		
		private function thumb_touchHandler(event:TouchEvent):void
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
			var location:Point = touch.getLocation(this);
			if(touch.phase == TouchPhase.BEGAN)
			{
				this._touchPointID = touch.id;
				this._thumbStartX = this.thumb.x;
				this._thumbStartY = this.thumb.y;
				this._touchStartX = location.x;
				this._touchStartY = location.y;
				this.isDragging = true;
			}
			else if(touch.phase == TouchPhase.MOVED)
			{
				var percentage:Number;
				if(this._direction == DIRECTION_HORIZONTAL)
				{
					const trackScrollableWidth:Number = this._width - this.thumb.width;
					const xOffset:Number = location.x - this._touchStartX;
					const xPosition:Number = Math.min(Math.max(0, this._thumbStartX + xOffset), trackScrollableWidth);
					percentage = xPosition / trackScrollableWidth;
				}
				else //vertical
				{
					const trackScrollableHeight:Number = this._height - this.thumb.height;
					const yOffset:Number = location.y - this._touchStartY;
					const yPosition:Number = Math.min(Math.max(0, this._thumbStartY + yOffset), trackScrollableHeight);
					percentage = xPosition / trackScrollableWidth;
				}
				
				this.value = this._minimum + percentage * (this._maximum - this._minimum);
			}
			else if(touch.phase == TouchPhase.ENDED)
			{
				this._touchPointID = -1;
				this.isDragging = false;
				if(!this.liveDragging)
				{
					this._onChange.dispatch(this);
				}
			}
		}
	}
}