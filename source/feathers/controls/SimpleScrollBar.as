/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.core.FeathersControl;
	import feathers.core.PropertyProxy;
	import feathers.events.FeathersEventType;
	import feathers.utils.math.clamp;
	import feathers.utils.math.roundToNearest;

	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;

	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * Dispatched when the scroll bar's value changes.
	 *
	 * @eventType starling.events.Event.CHANGE
	 */
	[Event(name="change",type="starling.events.Event")]

	/**
	 * Dispatched when the user starts dragging the scroll bar's thumb.
	 *
	 * @eventType feathers.events.FeathersEventType.BEGIN_INTERACTION
	 */
	[Event(name="beginInteraction",type="starling.events.Event")]

	/**
	 * Dispatched when the user stops dragging the scroll bar's thumb.
	 *
	 * @eventType feathers.events.FeathersEventType.END_INTERACTION
	 */
	[Event(name="endInteraction",type="starling.events.Event")]

	/**
	 * Select a value between a minimum and a maximum by dragging a thumb over
	 * a physical range. This type of scroll bar does not have a visible track,
	 * and it does not have increment and decrement buttons. It is ideal for
	 * mobile applications where the scroll bar is often simply a visual element
	 * to indicate the scroll position. For a more feature-rich scroll bar,
	 * see the <code>ScrollBar</code> component.
	 *
	 * <p>The following example updates a list to use simple scroll bars:</p>
	 *
	 * <listing version="3.0">
	 * list.horizontalScrollBarFactory = function():IScrollBar
	 * {
	 *     return new SimpleScrollBar();
	 * };
	 * list.verticalScrollBarFactory = function():IScrollBar
	 * {
	 *     return new SimpleScrollBar();
	 * };</listing>
	 *
	 * @see http://wiki.starling-framework.org/feathers/simple-scroll-bar
	 * @see ScrollBar
	 */
	public class SimpleScrollBar extends FeathersControl implements IScrollBar
	{
		/**
		 * @private
		 */
		private static const HELPER_POINT:Point = new Point();

		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_THUMB_FACTORY:String = "thumbFactory";

		/**
		 * The scroll bar's thumb may be dragged horizontally (on the x-axis).
		 *
		 * @see #direction
		 */
		public static const DIRECTION_HORIZONTAL:String = "horizontal";

		/**
		 * The scroll bar's thumb may be dragged vertically (on the y-axis).
		 *
		 * @see #direction
		 */
		public static const DIRECTION_VERTICAL:String = "vertical";

		/**
		 * The default value added to the <code>nameList</code> of the thumb.
		 *
		 * @see feathers.core.IFeathersControl#nameList
		 */
		public static const DEFAULT_CHILD_NAME_THUMB:String = "feathers-simple-scroll-bar-thumb";

		/**
		 * @private
		 */
		protected static function defaultThumbFactory():Button
		{
			return new Button();
		}

		/**
		 * Constructor.
		 */
		public function SimpleScrollBar()
		{
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}

		/**
		 * The value added to the <code>nameList</code> of the thumb. This
		 * variable is <code>protected</code> so that sub-classes can customize
		 * the thumb name in their constructors instead of using the default
		 * name defined by <code>DEFAULT_CHILD_NAME_THUMB</code>.
		 *
		 * <p>To customize the thumb name without subclassing, see
		 * <code>customThumbName</code>.</p>
		 *
		 * @see #customThumbName
		 * @see feathers.core.IFeathersControl#nameList
		 */
		protected var thumbName:String = DEFAULT_CHILD_NAME_THUMB;

		/**
		 * @private
		 */
		protected var thumbOriginalWidth:Number = NaN;

		/**
		 * @private
		 */
		protected var thumbOriginalHeight:Number = NaN;

		/**
		 * The thumb sub-component.
		 */
		protected var thumb:Button;

		/**
		 * @private
		 */
		protected var track:Quad;

		/**
		 * @private
		 */
		protected var _direction:String = DIRECTION_HORIZONTAL;

		[Inspectable(type="String",enumeration="horizontal,vertical")]
		/**
		 * Determines if the scroll bar's thumb can be dragged horizontally or
		 * vertically. When this value changes, the scroll bar's width and
		 * height values do not change automatically.
		 *
		 * <p>In the following example, the direction is changed to vertical:</p>
		 *
		 * <listing version="3.0">
		 * scrollBar.direction = SimpleScrollBar.DIRECTION_VERTICAL;</listing>
		 *
		 * @default SimpleScrollBar.DIRECTION_HORIZONTAL
		 *
		 * @see #DIRECTION_HORIZONTAL
		 * @see #DIRECTION_VERTICAL
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
			this.invalidate(INVALIDATION_FLAG_THUMB_FACTORY);
		}

		/**
		 * Determines if the value should be clamped to the range between the
		 * minimum and maximum. If <code>false</code> and the value is outside of the range,
		 * the thumb will shrink as if the range were increasing.
		 *
		 * <p>In the following example, the clamping behavior is updated:</p>
		 *
		 * <listing version="3.0">
		 * scrollBar.clampToRange = true;</listing>
		 *
		 * @default false
		 */
		public var clampToRange:Boolean = false;

		/**
		 * @private
		 */
		protected var _value:Number = 0;

		/**
		 * @inheritDoc
		 *
		 * @default 0
		 *
		 * @see #maximum
		 * @see #minimum
		 * @see #step
		 * @see #page
		 * @see #event:change
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
				this.dispatchEventWith(Event.CHANGE);
			}
		}

		/**
		 * @private
		 */
		protected var _minimum:Number = 0;

		/**
		 * @inheritDoc
		 *
		 * @default 0
		 *
		 * @see #value
		 * @see #maximum
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
		 *
		 * @default 0
		 *
		 * @see #value
		 * @see #minimum
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
		 *
		 * @default 0
		 *
		 * @see #value
		 * @see #page
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
			this._step = value;
		}

		/**
		 * @private
		 */
		protected var _page:Number = 0;

		/**
		 * @inheritDoc
		 *
		 * @default 0
		 *
		 * @see #value
		 * @see #step
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
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * Quickly sets all padding properties to the same value. The
		 * <code>padding</code> getter always returns the value of
		 * <code>paddingTop</code>, but the other padding values may be
		 * different.
		 *
		 * <p>In the following example, the padding is changed to 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * scrollBar.padding = 20;</listing>
		 *
		 * @default 0
		 *
		 * @see #paddingTop
		 * @see #paddingRight
		 * @see #paddingBottom
		 * @see #paddingLeft
		 */
		public function get padding():Number
		{
			return this._paddingTop;
		}

		/**
		 * @private
		 */
		public function set padding(value:Number):void
		{
			this.paddingTop = value;
			this.paddingRight = value;
			this.paddingBottom = value;
			this.paddingLeft = value;
		}

		/**
		 * @private
		 */
		protected var _paddingTop:Number = 0;

		/**
		 * The minimum space, in pixels, above the thumb.
		 *
		 * <p>In the following example, the top padding is changed to 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * scrollBar.paddingTop = 20;</listing>
		 *
		 * @default 0
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
		 *
		 * <p>In the following example, the right padding is changed to 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * scrollBar.paddingRight = 20;</listing>
		 *
		 * @default 0
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
		 *
		 * <p>In the following example, the bottom padding is changed to 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * scrollBar.paddingBottom = 20;</listing>
		 *
		 * @default 0
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
		 *
		 * <p>In the following example, the left padding is changed to 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * scrollBar.paddingLeft = 20;</listing>
		 *
		 * @default 0
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
		 *
		 * <p>In the following example, the repeat delay is changed to 500 milliseconds:</p>
		 *
		 * <listing version="3.0">
		 * scrollBar.repeatDelay = 0.5;</listing>
		 *
		 * @default 0.05
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
		protected var isDragging:Boolean = false;

		/**
		 * Determines if the scroll bar dispatches the <code>Event.CHANGE</code>
		 * event every time the thumb moves, or only once it stops moving.
		 *
		 * <p>In the following example, live dragging is disabled:</p>
		 *
		 * <listing version="3.0">
		 * scrollBar.liveDragging = false;</listing>
		 *
		 * @default true
		 */
		public var liveDragging:Boolean = true;

		/**
		 * @private
		 */
		protected var _thumbFactory:Function;

		/**
		 * A function used to generate the scroll bar's thumb sub-component.
		 * The thumb must be an instance of <code>Button</code>. This factory
		 * can be used to change properties on the thumb when it is first
		 * created. For instance, if you are skinning Feathers components
		 * without a theme, you might use this factory to set skins and other
		 * styles on the thumb.
		 *
		 * <p>The function should have the following signature:</p>
		 * <pre>function():Button</pre>
		 *
		 * <p>In the following example, a custom thumb factory is passed
		 * to the scroll bar:</p>
		 *
		 * <listing version="3.0">
		 * scrollBar.thumbFactory = function():Button
		 * {
		 *     var thumb:Button = new Button();
		 *     thumb.defaultSkin = new Image( upTexture );
		 *     thumb.downSkin = new Image( downTexture );
		 *     return thumb;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.Button
		 * @see #thumbProperties
		 */
		public function get thumbFactory():Function
		{
			return this._thumbFactory;
		}

		/**
		 * @private
		 */
		public function set thumbFactory(value:Function):void
		{
			if(this._thumbFactory == value)
			{
				return;
			}
			this._thumbFactory = value;
			this.invalidate(INVALIDATION_FLAG_THUMB_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _customThumbName:String;

		/**
		 * A name to add to the scroll bar's thumb sub-component. Typically
		 * used by a theme to provide different skins to different scroll bars.
		 *
		 * <p>In the following example, a custom thumb name is passed
		 * to the scroll bar:</p>
		 *
		 * <listing version="3.0">
		 * scrollBar.customThumbName = "my-custom-thumb";</listing>
		 *
		 * <p>In your theme, you can target this sub-component name to provide
		 * different skins than the default style:</p>
		 *
		 * <listing version="3.0">
		 * setInitializerForClass( Button, customThumbInitializer, "my-custom-thumb");</listing>
		 *
		 * @default null
		 *
		 * @see #DEFAULT_CHILD_NAME_THUMB
		 * @see feathers.core.FeathersControl#nameList
		 * @see feathers.core.DisplayListWatcher
		 * @see #thumbFactory
		 * @see #thumbProperties
		 */
		public function get customThumbName():String
		{
			return this._customThumbName;
		}

		/**
		 * @private
		 */
		public function set customThumbName(value:String):void
		{
			if(this._customThumbName == value)
			{
				return;
			}
			this._customThumbName = value;
			this.invalidate(INVALIDATION_FLAG_THUMB_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _thumbProperties:PropertyProxy;

		/**
		 * A set of key/value pairs to be passed down to the scroll bar's thumb
		 * sub-component. The thumb is a <code>feathers.controls.Button</code>
		 * instance that is created by <code>thumbFactory</code>.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
		 * which is in a <code>Scroller</code> which is in a <code>List</code>,
		 * you can use the following syntax:</p>
		 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * <p>Setting properties in a <code>thumbFactory</code> function instead
		 * of using <code>thumbProperties</code> will result in better
		 * performance.</p>
		 *
		 * <p>In the following example, the scroll bar's thumb properties
		 * are updated:</p>
		 *
		 * <listing version="3.0">
		 * scrollBar.thumbProperties.defaultSkin = new Image( upTexture );
		 * scrollBar.thumbProperties.downSkin = new Image( downTexture );</listing>
		 *
		 * @default null
		 *
		 * @see #thumbFactory
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
				this._thumbProperties.removeOnChangeCallback(thumbProperties_onChange);
			}
			this._thumbProperties = PropertyProxy(value);
			if(this._thumbProperties)
			{
				this._thumbProperties.addOnChangeCallback(thumbProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _touchPointID:int = -1;

		/**
		 * @private
		 */
		protected var _touchStartX:Number = NaN;

		/**
		 * @private
		 */
		protected var _touchStartY:Number = NaN;

		/**
		 * @private
		 */
		protected var _thumbStartX:Number = NaN;

		/**
		 * @private
		 */
		protected var _thumbStartY:Number = NaN;

		/**
		 * @private
		 */
		protected var _touchValue:Number;

		/**
		 * @private
		 */
		override protected function initialize():void
		{
			if(!this.track)
			{
				this.track = new Quad(10, 10, 0xff00ff);
				this.track.alpha = 0;
				this.track.addEventListener(TouchEvent.TOUCH, track_touchHandler);
				this.addChild(this.track);
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
			const thumbFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_THUMB_FACTORY);

			if(thumbFactoryInvalid)
			{
				this.createThumb();
			}

			if(thumbFactoryInvalid || stylesInvalid)
			{
				this.refreshThumbStyles();
			}

			if(thumbFactoryInvalid || stateInvalid)
			{
				this.thumb.isEnabled = this._isEnabled;
			}

			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

			if(thumbFactoryInvalid || dataInvalid || stylesInvalid || sizeInvalid)
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
			//we're just going to make something up in this case
			const adjustedPageStep:Number = this._page == 0 ? range / 10 : this._page;
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
					if(range > 0)
					{
						newWidth = 0;
					}
					else
					{
						if(adjustedPageStep == 0)
						{
							newWidth = this.thumbOriginalWidth;
						}
						else
						{
							newWidth = Math.max(this.thumbOriginalWidth, this.thumbOriginalWidth * range / adjustedPageStep);
						}
					}
				}
				newWidth += this._paddingLeft + this._paddingRight;
			}
			if(needsHeight)
			{
				if(this._direction == DIRECTION_VERTICAL)
				{
					if(range > 0)
					{
						newHeight = 0;
					}
					else
					{
						if(adjustedPageStep == 0)
						{
							newHeight = this.thumbOriginalHeight;
						}
						else
						{
							newHeight = Math.max(this.thumbOriginalHeight, this.thumbOriginalHeight * range / adjustedPageStep);
						}
					}
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
		protected function createThumb():void
		{
			if(this.thumb)
			{
				this.thumb.removeFromParent(true);
				this.thumb = null;
			}

			const factory:Function = this._thumbFactory != null ? this._thumbFactory : defaultThumbFactory;
			const thumbName:String = this._customThumbName != null ? this._customThumbName : this.thumbName;
			this.thumb = Button(factory());
			this.thumb.nameList.add(thumbName);
			this.thumb.isFocusEnabled = false;
			this.thumb.keepDownStateOnRollOut = true;
			this.thumb.addEventListener(TouchEvent.TOUCH, thumb_touchHandler);
			this.addChild(this.thumb);
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
			this.track.width = this.actualWidth;
			this.track.height = this.actualHeight;

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
			const adjustedPageStep:Number = Math.min(range, this._page == 0 ? range : this._page);
			var valueOffset:Number = 0;
			if(this._value < this._minimum)
			{
				valueOffset = (this._minimum - this._value);
			}
			if(this._value > this._maximum)
			{
				valueOffset = (this._value - this._maximum);
			}
			if(this._direction == DIRECTION_VERTICAL)
			{
				this.thumb.width = this.thumbOriginalWidth;
				const thumbMinHeight:Number = this.thumb.minHeight > 0 ? this.thumb.minHeight : this.thumbOriginalHeight;
				var thumbHeight:Number = contentHeight * adjustedPageStep / range;
				var heightOffset:Number = contentHeight - thumbHeight;
				if(heightOffset > thumbHeight)
				{
					heightOffset = thumbHeight;
				}
				heightOffset *=  valueOffset / (range * thumbHeight / contentHeight);
				thumbHeight -= heightOffset;
				if(thumbHeight < thumbMinHeight)
				{
					thumbHeight = thumbMinHeight;
				}
				this.thumb.height = thumbHeight;
				this.thumb.x = this._paddingLeft + (this.actualWidth - this._paddingLeft - this._paddingRight - this.thumb.width) / 2;
				const trackScrollableHeight:Number = contentHeight - this.thumb.height;
				var thumbY:Number = trackScrollableHeight * (this._value - this._minimum) / range;
				if(thumbY > trackScrollableHeight)
				{
					thumbY = trackScrollableHeight;
				}
				else if(thumbY < 0)
				{
					thumbY = 0;
				}
				this.thumb.y = this._paddingTop + thumbY;
			}
			else //horizontal
			{
				const thumbMinWidth:Number = this.thumb.minWidth > 0 ? this.thumb.minWidth : this.thumbOriginalWidth;
				var thumbWidth:Number = contentWidth * adjustedPageStep / range;
				var widthOffset:Number = contentWidth - thumbWidth;
				if(widthOffset > thumbWidth)
				{
					widthOffset = thumbWidth;
				}
				widthOffset *= valueOffset / (range * thumbWidth / contentWidth);
				thumbWidth -= widthOffset;
				if(thumbWidth < thumbMinWidth)
				{
					thumbWidth = thumbMinWidth;
				}
				this.thumb.width = thumbWidth;
				this.thumb.height = this.thumbOriginalHeight;
				const trackScrollableWidth:Number = contentWidth - this.thumb.width;
				var thumbX:Number = trackScrollableWidth * (this._value - this._minimum) / range;
				if(thumbX > trackScrollableWidth)
				{
					thumbX = trackScrollableWidth;
				}
				else if(thumbX < 0)
				{
					thumbX = 0;
				}
				this.thumb.x = this._paddingLeft + thumbX;
				this.thumb.y = this._paddingTop + (this.actualHeight - this._paddingTop - this._paddingBottom - this.thumb.height) / 2;
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
				const trackScrollableHeight:Number = this.actualHeight - this.thumb.height - this._paddingTop - this._paddingBottom;
				const yOffset:Number = location.y - this._touchStartY - this._paddingTop;
				const yPosition:Number = Math.min(Math.max(0, this._thumbStartY + yOffset), trackScrollableHeight);
				percentage = yPosition / trackScrollableHeight;
			}
			else //horizontal
			{
				const trackScrollableWidth:Number = this.actualWidth - this.thumb.width - this._paddingLeft - this._paddingRight;
				const xOffset:Number = location.x - this._touchStartX - this._paddingLeft;
				const xPosition:Number = Math.min(Math.max(0, this._thumbStartX + xOffset), trackScrollableWidth);
				percentage = xPosition / trackScrollableWidth;
			}

			return this._minimum + percentage * (this._maximum - this._minimum);
		}

		/**
		 * @private
		 */
		protected function adjustPage():void
		{
			if(this._touchValue < this._value)
			{
				var newValue:Number = Math.max(this._touchValue, this._value - this._page);
				if(this._step != 0 && newValue != this._maximum && newValue != this._minimum)
				{
					newValue = roundToNearest(newValue, this._step);
				}
				this.value = newValue;
			}
			else if(this._touchValue > this._value)
			{
				newValue = Math.min(this._touchValue, this._value + this._page);
				if(this._step != 0 && newValue != this._maximum && newValue != this._minimum)
				{
					newValue = roundToNearest(newValue, this._step);
				}
				this.value = newValue;
			}
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
			if(this._repeatTimer)
			{
				this._repeatTimer.stop();
			}
		}

		/**
		 * @private
		 */
		protected function track_touchHandler(event:TouchEvent):void
		{
			if(!this._isEnabled)
			{
				this._touchPointID = -1;
				return;
			}

			if(this._touchPointID >= 0)
			{
				var touch:Touch = event.getTouch(this.track, TouchPhase.ENDED, this._touchPointID);
				if(!touch)
				{
					return;
				}
				this._touchPointID = -1;
				this._repeatTimer.stop();
			}
			else
			{
				touch = event.getTouch(this.track, TouchPhase.BEGAN);
				if(!touch)
				{
					return;
				}
				this._touchPointID = touch.id;
				touch.getLocation(this, HELPER_POINT);
				this._touchStartX = HELPER_POINT.x;
				this._touchStartY = HELPER_POINT.y;
				this._thumbStartX = HELPER_POINT.x;
				this._thumbStartY = HELPER_POINT.y;
				this._touchValue = this.locationToValue(HELPER_POINT);
				this.adjustPage();
				this.startRepeatTimer(this.adjustPage);
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

			if(this._touchPointID >= 0)
			{
				var touch:Touch = event.getTouch(this.thumb, null, this._touchPointID);
				if(!touch)
				{
					return;
				}

				if(touch.phase == TouchPhase.MOVED)
				{
					touch.getLocation(this, HELPER_POINT);
					var newValue:Number = this.locationToValue(HELPER_POINT);
					if(this._step != 0 && newValue != this._maximum && newValue != this._minimum)
					{
						newValue = roundToNearest(newValue, this._step);
					}
					this.value = newValue;
				}
				else if(touch.phase == TouchPhase.ENDED)
				{
					this._touchPointID = -1;
					this.isDragging = false;
					if(!this.liveDragging)
					{
						this.dispatchEventWith(Event.CHANGE);
					}
					this.dispatchEventWith(FeathersEventType.END_INTERACTION);
				}
			}
			else
			{
				touch = event.getTouch(this.thumb, TouchPhase.BEGAN);
				if(!touch)
				{
					return;
				}
				touch.getLocation(this, HELPER_POINT);
				this._touchPointID = touch.id;
				this._thumbStartX = this.thumb.x;
				this._thumbStartY = this.thumb.y;
				this._touchStartX = HELPER_POINT.x;
				this._touchStartY = HELPER_POINT.y;
				this.isDragging = true;
				this.dispatchEventWith(FeathersEventType.BEGIN_INTERACTION);
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
