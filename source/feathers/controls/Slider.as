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
package feathers.controls
{
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import feathers.core.FeathersControl;
	import feathers.core.PropertyProxy;
	import feathers.utils.math.clamp;
	import feathers.utils.math.roundToNearest;

	import flash.utils.Timer;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * Select a value between a minimum and a maximum by dragging a thumb over
	 * the bounds of a track. The slider's track is divided into two parts split
	 * by the thumb.
	 */
	public class Slider extends FeathersControl
	{
		/**
		 * @private
		 */
		private static const HELPER_POINT:Point = new Point();

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
		 * the slider. In this layout mode, the minimum track is displayed and
		 * fills the entire length of the slider. The maximum track will not
		 * exist.
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
		 * The default value added to the <code>nameList</code> of the minimum
		 * track.
		 */
		public static const DEFAULT_CHILD_NAME_MINIMUM_TRACK:String = "feathers-slider-minimum-track";

		/**
		 * The default value added to the <code>nameList</code> of the maximum
		 * track.
		 */
		public static const DEFAULT_CHILD_NAME_MAXIMUM_TRACK:String = "feathers-slider-maximum-track";

		/**
		 * The default value added to the <code>nameList</code> of the thumb.
		 */
		public static const DEFAULT_CHILD_NAME_THUMB:String = "feathers-slider-thumb";
		
		/**
		 * Constructor.
		 */
		public function Slider()
		{
			super();
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}

		/**
		 * The value added to the <code>nameList</code> of the minimum track.
		 */
		protected var minimumTrackName:String = DEFAULT_CHILD_NAME_MINIMUM_TRACK;

		/**
		 * The value added to the <code>nameList</code> of the maximum track.
		 */
		protected var maximumTrackName:String = DEFAULT_CHILD_NAME_MAXIMUM_TRACK;

		/**
		 * The value added to the <code>nameList</code> of the thumb.
		 */
		protected var thumbName:String = DEFAULT_CHILD_NAME_THUMB;
		
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
		private var _page:Number = NaN;

		/**
		 * If the slider's track is touched, and the thumb is shown, the slider
		 * value will be incremented or decremented by the page value. If the
		 * thumb is hidden, this value is ignored, and the track may be dragged
		 * instead.
		 *
		 * <p>If this value is <code>NaN</code>, the step value will be used
		 * instead.</p>
		 */
		public function get page():Number
		{
			return this._page;
		}

		/**
		 * @private
		 */
		public function set page(value:Number):void
		{
			if(this._page == value)
			{
				return;
			}
			this._page = value;
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
		protected var _minimumPadding:Number = 0;

		/**
		 * The space, in pixels, between the minimum position of the thumb and
		 * the minimum edge of the track. May be negative to extend the range of
		 * the thumb.
		 */
		public function get minimumPadding():Number
		{
			return this._minimumPadding;
		}

		/**
		 * @private
		 */
		public function set minimumPadding(value:Number):void
		{
			if(this._minimumPadding == value)
			{
				return;
			}
			this._minimumPadding = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _maximumPadding:Number = 0;

		/**
		 * The space, in pixels, between the maximum position of the thumb and
		 * the maximum edge of the track. May be negative to extend the range
		 * of the thumb.
		 */
		public function get maximumPadding():Number
		{
			return this._maximumPadding;
		}

		/**
		 * @private
		 */
		public function set maximumPadding(value:Number):void
		{
			if(this._maximumPadding == value)
			{
				return;
			}
			this._maximumPadding = value;
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
		protected var currentRepeatAction:Function;

		/**
		 * @private
		 */
		protected var _repeatTimer:Timer;

		/**
		 * @private
		 */
		protected var _repeatDelay:Number = 0.05;

		/**
		 * The time, in seconds, before actions are repeated. The first repeat
		 * happens after a delay that is five times longer than the following
		 * repeats.
		 */
		public function get repeatDelay():Number
		{
			return this._repeatDelay;
		}

		/**
		 * @private
		 */
		public function set repeatDelay(value:Number):void
		{
			if(this._repeatDelay == value)
			{
				return;
			}
			this._repeatDelay = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _minimumTrackProperties:PropertyProxy;

		/**
		 * A set of key/value pairs to be passed down to the slider's minimum
		 * track sub-component. The minimum track is a
		 * <code>feathers.controls.Button</code> instance.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
		 * which is in a <code>Scroller</code> which is in a <code>List</code>,
		 * you can use the following syntax:</p>
		 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 * 
		 * @see feathers.controls.Button
		 */
		public function get minimumTrackProperties():Object
		{
			if(!this._minimumTrackProperties)
			{
				this._minimumTrackProperties = new PropertyProxy(minimumTrackProperties_onChange);
			}
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
		private var _maximumTrackProperties:PropertyProxy;
		
		/**
		 * A set of key/value pairs to be passed down to the slider's maximum
		 * track sub-component. The maximum track is a
		 * <code>feathers.controls.Button</code> instance.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
		 * which is in a <code>Scroller</code> which is in a <code>List</code>,
		 * you can use the following syntax:</p>
		 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 * 
		 * @see feathers.controls.Button
		 */
		public function get maximumTrackProperties():Object
		{
			if(!this._maximumTrackProperties)
			{
				this._maximumTrackProperties = new PropertyProxy(maximumTrackProperties_onChange);
			}
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
		private var _thumbProperties:PropertyProxy;
		
		/**
		 * A set of key/value pairs to be passed down to the slider's thumb
		 * sub-component. The thumb is a <code>feathers.controls.Button</code>
		 * instance.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
		 * which is in a <code>Scroller</code> which is in a <code>List</code>,
		 * you can use the following syntax:</p>
		 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 * 
		 * @see feathers.controls.Button
		 */
		public function get thumbProperties():Object
		{
			if(!this._thumbProperties)
			{
				this._thumbProperties = new PropertyProxy(thumbProperties_onChange);
			}
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
		private var _touchValue:Number;
		
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
				this.minimumTrack.nameList.add(this.minimumTrackName);
				this.minimumTrack.label = "";
				this.minimumTrack.keepDownStateOnRollOut = true;
				this.minimumTrack.addEventListener(TouchEvent.TOUCH, track_touchHandler);
				this.addChild(this.minimumTrack);
			}
			
			if(!this.thumb)
			{
				this.thumb = new Button();
				this.thumb.nameList.add(this.thumbName);
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
				this.thumb.isEnabled = this.minimumTrack.isEnabled = this._isEnabled;
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
				const trackScrollableHeight:Number = this.actualHeight - this.thumb.height - this._minimumPadding - this._maximumPadding;
				this.thumb.x = (this.actualWidth - this.thumb.width) / 2;
				this.thumb.y = this._minimumPadding + trackScrollableHeight * (1 - (this._value - this._minimum) / (this._maximum - this._minimum));
			}
			else
			{
				const trackScrollableWidth:Number = this.actualWidth - this.thumb.width - this._minimumPadding - this._maximumPadding;
				this.thumb.x = this._minimumPadding + (trackScrollableWidth * (this._value - this._minimum) / (this._maximum - this._minimum));
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
					this.maximumTrack.nameList.add(this.maximumTrackName);
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
		protected function locationToValue(location:Point):Number
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

			return this._minimum + percentage * (this._maximum - this._minimum);
		}

		/**
		 * @private
		 */
		protected function startRepeatTimer(action:Function):void
		{
			this.currentRepeatAction = action;
			if(this._repeatDelay > 0)
			{
				if(!this._repeatTimer)
				{
					this._repeatTimer = new Timer(this._repeatDelay * 1000);
					this._repeatTimer.addEventListener(TimerEvent.TIMER, repeatTimer_timerHandler);
				}
				else
				{
					this._repeatTimer.reset();
					this._repeatTimer.delay = this._repeatDelay * 1000;
				}
				this._repeatTimer.start();
			}
		}

		/**
		 * @private
		 */
		protected function adjustPage():void
		{
			const page:Number = isNaN(this._page) ? this._step : this._page;
			if(this._touchValue < this._value)
			{
				var newValue:Number = Math.max(this._touchValue, this._value - page);
				if(page != 0)
				{
					newValue = roundToNearest(newValue, this._step);
				}
				this.value = newValue;
			}
			else if(this._touchValue > this._value)
			{
				newValue = Math.min(this._touchValue, this._value + page);
				if(page != 0)
				{
					newValue = roundToNearest(newValue, page);
				}
				this.value = newValue;
			}
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
		protected function removedFromStageHandler(event:Event):void
		{
			this._touchPointID = -1;
			const wasDragging:Boolean = this.isDragging;
			this.isDragging = false;
			if(wasDragging && !this.liveDragging)
			{
				this._onChange.dispatch(this);
			}
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
			const touches:Vector.<Touch> = event.getTouches(DisplayObject(event.currentTarget));
			if(this._touchPointID >= 0)
			{
				var touch:Touch;
				for each(var currentTouch:Touch in touches)
				{
					if(currentTouch.id == this._touchPointID)
					{
						touch = currentTouch;
						break;
					}
				}
				if(!touch)
				{
					return;
				}
				if(!this._showThumb && touch.phase == TouchPhase.MOVED)
				{
					touch.getLocation(this, HELPER_POINT);
					this.value = this.locationToValue(HELPER_POINT);
				}
				else if(touch.phase == TouchPhase.ENDED)
				{
					if(this._repeatTimer)
					{
						this._repeatTimer.stop();
					}
					this._touchPointID = -1;
					this.isDragging = false;
					if(!this.liveDragging)
					{
						this._onChange.dispatch(this);
					}
					this._onDragEnd.dispatch(this);
					return;
				}
			}
			else
			{
				for each(touch in touches)
				{
					if(touch.phase == TouchPhase.BEGAN)
					{
						touch.getLocation(this, HELPER_POINT);
						this._touchPointID = touch.id;
						if(this._direction == DIRECTION_VERTICAL)
						{
							this._thumbStartX = HELPER_POINT.x;
							this._thumbStartY = Math.min(this.actualHeight - this.thumb.height, Math.max(0, HELPER_POINT.y - this.thumb.height / 2));
						}
						else //horizontal
						{
							this._thumbStartX = Math.min(this.actualWidth - this.thumb.width, Math.max(0, HELPER_POINT.x - this.thumb.width / 2));
							this._thumbStartY = HELPER_POINT.y;
						}
						this._touchStartX = HELPER_POINT.x;
						this._touchStartY = HELPER_POINT.y;
						this._touchValue = this.locationToValue(HELPER_POINT);
						this.isDragging = true;
						this._onDragStart.dispatch(this);
						if(this._showThumb)
						{
							this.adjustPage();
							this.startRepeatTimer(this.adjustPage);
						}
						else
						{
							this.value = this._touchValue;
						}
					}
				}
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
			const touches:Vector.<Touch> = event.getTouches(this.thumb);
			if(touches.length == 0)
			{
				return;
			}
			if(this._touchPointID >= 0)
			{
				var touch:Touch;
				for each(var currentTouch:Touch in touches)
				{
					if(currentTouch.id == this._touchPointID)
					{
						touch = currentTouch;
						break;
					}
				}
				if(!touch)
				{
					return;
				}
				if(touch.phase == TouchPhase.MOVED)
				{
					touch.getLocation(this, HELPER_POINT);
					this.value = this.locationToValue(HELPER_POINT);
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
					return;
				}
			}
			else
			{
				for each(touch in touches)
				{
					if(touch.phase == TouchPhase.BEGAN)
					{
						touch.getLocation(this, HELPER_POINT);
						this._touchPointID = touch.id;
						this._thumbStartX = this.thumb.x;
						this._thumbStartY = this.thumb.y;
						this._touchStartX = HELPER_POINT.x;
						this._touchStartY = HELPER_POINT.y;
						this.isDragging = true;
						this._onDragStart.dispatch(this);
						return;
					}
				}
			}
		}

		/**
		 * @private
		 */
		protected function repeatTimer_timerHandler(event:TimerEvent):void
		{
			if(this._repeatTimer.currentCount < 5)
			{
				return;
			}
			this.currentRepeatAction();
		}
	}
}