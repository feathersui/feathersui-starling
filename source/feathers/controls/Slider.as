/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.core.FeathersControl;
	import feathers.core.IFeathersControl;
	import feathers.core.IFocusDisplayObject;
	import feathers.core.IMeasureDisplayObject;
	import feathers.core.IValidating;
	import feathers.core.PropertyProxy;
	import feathers.events.ExclusiveTouch;
	import feathers.events.FeathersEventType;
	import feathers.layout.Direction;
	import feathers.skins.IStyleProvider;
	import feathers.utils.math.clamp;
	import feathers.utils.math.roundToNearest;

	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.Timer;

	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * Dispatched when the slider's value changes.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>null</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @eventType starling.events.Event.CHANGE
	 */
	[Event(name="change",type="starling.events.Event")]

	/**
	 * Dispatched when the user starts dragging the slider's thumb or track.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>null</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @eventType feathers.events.FeathersEventType.BEGIN_INTERACTION
	 */
	[Event(name="beginInteraction",type="starling.events.Event")]

	/**
	 * Dispatched when the user stops dragging the slider's thumb or track.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>null</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @eventType feathers.events.FeathersEventType.END_INTERACTION
	 */
	[Event(name="endInteraction",type="starling.events.Event")]

	/**
	 * Select a value between a minimum and a maximum by dragging a thumb over
	 * the bounds of a track. The slider's track is divided into two parts split
	 * by the thumb.
	 *
	 * <p>The following example sets the slider's range and listens for when the
	 * value changes:</p>
	 *
	 * <listing version="3.0">
	 * var slider:Slider = new Slider();
	 * slider.minimum = 0;
	 * slider.maximum = 100;
	 * slider.step = 1;
	 * slider.page = 10;
	 * slider.value = 12;
	 * slider.addEventListener( Event.CHANGE, slider_changeHandler );
	 * this.addChild( slider );</listing>
	 *
	 * @see ../../../help/slider.html How to use the Feathers Slider component
	 */
	public class Slider extends FeathersControl implements IDirectionalScrollBar, IFocusDisplayObject
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
		 * @private
		 */
		protected static const INVALIDATION_FLAG_MINIMUM_TRACK_FACTORY:String = "minimumTrackFactory";

		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_MAXIMUM_TRACK_FACTORY:String = "maximumTrackFactory";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.Direction.HORIZONTAL</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const DIRECTION_HORIZONTAL:String = "horizontal";
		
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.Direction.VERTICAL</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const DIRECTION_VERTICAL:String = "vertical";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.TrackLayoutMode.SINGLE</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const TRACK_LAYOUT_MODE_SINGLE:String = "single";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.TrackLayoutMode.SPLIT</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const TRACK_LAYOUT_MODE_MIN_MAX:String = "minMax";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.TrackLayoutMode.EXACT_FIT</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const TRACK_SCALE_MODE_EXACT_FIT:String = "exactFit";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.TrackLayoutMode.DIRECTIONAL</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const TRACK_SCALE_MODE_DIRECTIONAL:String = "directional";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.TrackInteractionMode.TO_VALUE</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const TRACK_INTERACTION_MODE_TO_VALUE:String = "toValue";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.TrackInteractionMode.BY_PAGE</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const TRACK_INTERACTION_MODE_BY_PAGE:String = "byPage";

		/**
		 * The default value added to the <code>styleNameList</code> of the
		 * minimum track.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_MINIMUM_TRACK:String = "feathers-slider-minimum-track";

		/**
		 * The default value added to the <code>styleNameList</code> of the
		 * maximum track.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_MAXIMUM_TRACK:String = "feathers-slider-maximum-track";

		/**
		 * The default value added to the <code>styleNameList</code> of the thumb.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_THUMB:String = "feathers-slider-thumb";

		/**
		 * The default <code>IStyleProvider</code> for all <code>Slider</code>
		 * components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * @private
		 */
		protected static function defaultThumbFactory():BasicButton
		{
			return new Button();
		}

		/**
		 * @private
		 */
		protected static function defaultMinimumTrackFactory():BasicButton
		{
			return new Button();
		}

		/**
		 * @private
		 */
		protected static function defaultMaximumTrackFactory():BasicButton
		{
			return new Button();
		}
		
		/**
		 * Constructor.
		 */
		public function Slider()
		{
			super();
			this.addEventListener(Event.REMOVED_FROM_STAGE, slider_removedFromStageHandler);
		}

		/**
		 * The value added to the <code>styleNameList</code> of the minimum
		 * track. This variable is <code>protected</code> so that sub-classes
		 * can customize the minimum track style name in their constructors
		 * instead of using the default style name defined by
		 * <code>DEFAULT_CHILD_STYLE_NAME_MINIMUM_TRACK</code>.
		 *
		 * <p>To customize the minimum track style name without subclassing, see
		 * <code>customMinimumTrackStyleName</code>.</p>
		 *
		 * @see #customMinimumTrackStyleName
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var minimumTrackStyleName:String = DEFAULT_CHILD_STYLE_NAME_MINIMUM_TRACK;

		/**
		 * The value added to the <code>styleNameList</code> of the maximum
		 * track. This variable is <code>protected</code> so that sub-classes
		 * can customize the maximum track style name in their constructors
		 * instead of using the default style name defined by
		 * <code>DEFAULT_CHILD_STYLE_NAME_MAXIMUM_TRACK</code>.
		 *
		 * <p>To customize the maximum track style name without subclassing, see
		 * <code>customMaximumTrackStyleName</code>.</p>
		 *
		 * @see #customMaximumTrackStyleName
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var maximumTrackStyleName:String = DEFAULT_CHILD_STYLE_NAME_MAXIMUM_TRACK;

		/**
		 * The value added to the <code>styleNameList</code> of the thumb. This
		 * variable is <code>protected</code> so that sub-classes can customize
		 * the thumb style name in their constructors instead of using the
		 * default style name defined by <code>DEFAULT_CHILD_STYLE_NAME_THUMB</code>.
		 *
		 * <p>To customize the thumb style name without subclassing, see
		 * <code>customThumbStyleName</code>.</p>
		 *
		 * @see #customThumbStyleName
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var thumbStyleName:String = DEFAULT_CHILD_STYLE_NAME_THUMB;

		/**
		 * The thumb sub-component.
		 *
		 * <p>For internal use in subclasses.</p>
		 *
		 * @see #thumbFactory
		 * @see #createThumb()
		 */
		protected var thumb:DisplayObject;
		
		/**
		 * The minimum track sub-component.
		 *
		 * <p>For internal use in subclasses.</p>
		 *
		 * @see #minimumTrackFactory
		 * @see #createMinimumTrack()
		 */
		protected var minimumTrack:DisplayObject;

		/**
		 * The maximum track sub-component.
		 *
		 * <p>For internal use in subclasses.</p>
		 *
		 * @see #maximumTrackFactory
		 * @see #createMaximumTrack()
		 */
		protected var maximumTrack:DisplayObject;

		/**
		 * @private
		 */
		protected var _minimumTrackSkinExplicitWidth:Number;

		/**
		 * @private
		 */
		protected var _minimumTrackSkinExplicitHeight:Number;

		/**
		 * @private
		 */
		protected var _minimumTrackSkinExplicitMinWidth:Number;

		/**
		 * @private
		 */
		protected var _minimumTrackSkinExplicitMinHeight:Number;

		/**
		 * @private
		 */
		protected var _maximumTrackSkinExplicitWidth:Number;

		/**
		 * @private
		 */
		protected var _maximumTrackSkinExplicitHeight:Number;

		/**
		 * @private
		 */
		protected var _maximumTrackSkinExplicitMinWidth:Number;

		/**
		 * @private
		 */
		protected var _maximumTrackSkinExplicitMinHeight:Number;

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return Slider.globalStyleProvider;
		}
		
		/**
		 * @private
		 */
		protected var _direction:String = Direction.HORIZONTAL;

		[Inspectable(type="String",enumeration="horizontal,vertical")]
		/**
		 * Determines if the slider's thumb can be dragged horizontally or
		 * vertically. When this value changes, the slider's width and height
		 * values do not change automatically.
		 *
		 * <p>In the following example, the direction is changed to vertical:</p>
		 *
		 * <listing version="3.0">
		 * slider.direction = Direction.VERTICAL;</listing>
		 *
		 * @default feathers.layout.Direction.HORIZONTAL
		 *
		 * @see feathers.layout.Direction#HORIZONTAL
		 * @see feathers.layout.Direction#VERTICAL
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
			this.invalidate(INVALIDATION_FLAG_MINIMUM_TRACK_FACTORY);
			this.invalidate(INVALIDATION_FLAG_MAXIMUM_TRACK_FACTORY);
			this.invalidate(INVALIDATION_FLAG_THUMB_FACTORY);
		}
		
		/**
		 * @private
		 */
		protected var _value:Number = 0;
		
		/**
		 * The value of the slider, between the minimum and maximum.
		 *
		 * <p>In the following example, the value is changed to 12:</p>
		 *
		 * <listing version="3.0">
		 * slider.minimum = 0;
		 * slider.maximum = 100;
		 * slider.step = 1;
		 * slider.page = 10
		 * slider.value = 12;</listing>
		 *
		 * @default 0
		 *
		 * @see #minimum
		 * @see #maximum
		 * @see #step
		 * @see #page
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
			if(this._step != 0 && newValue != this._maximum && newValue != this._minimum)
			{
				newValue = roundToNearest(newValue - this._minimum, this._step) + this._minimum;
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
				this.dispatchEventWith(Event.CHANGE);
			}
		}
		
		/**
		 * @private
		 */
		protected var _minimum:Number = 0;
		
		/**
		 * The slider's value will not go lower than the minimum.
		 *
		 * <p>In the following example, the minimum is set to 0:</p>
		 *
		 * <listing version="3.0">
		 * slider.minimum = 0;
		 * slider.maximum = 100;
		 * slider.step = 1;
		 * slider.page = 10
		 * slider.value = 12;</listing>
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
		 * The slider's value will not go higher than the maximum. The maximum
		 * is zero (<code>0</code>), by default, and it should almost always be
		 * changed to something more appropriate.
		 *
		 * <p>In the following example, the maximum is set to 100:</p>
		 *
		 * <listing version="3.0">
		 * slider.minimum = 0;
		 * slider.maximum = 100;
		 * slider.step = 1;
		 * slider.page = 10
		 * slider.value = 12;</listing>
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
		 * As the slider's thumb is dragged, the value is snapped to a multiple
		 * of the step. Paging using the slider's track will use the <code>step</code>
		 * value if the <code>page</code> value is <code>NaN</code>. If the
		 * <code>step</code> is zero (<code>0</code>), paging with the track will not be possible.
		 *
		 * <p>In the following example, the step is changed to 1:</p>
		 *
		 * <listing version="3.0">
		 * slider.minimum = 0;
		 * slider.maximum = 100;
		 * slider.step = 1;
		 * slider.page = 10;
		 * slider.value = 10;</listing>
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
			if(this._step == value)
			{
				return;
			}
			this._step = value;
		}

		/**
		 * @private
		 */
		protected var _page:Number = NaN;

		/**
		 * If the <code>trackInteractionMode</code> property is set to
		 * <code>TrackInteractionMode.BY_PAGE</code>, and the slider's
		 * track is touched, and the thumb is shown, the slider value will be
		 * incremented or decremented by the page value. If the
		 * <code>trackInteractionMode</code> property is set to
		 * <code>TrackInteractionMode.TO_VALUE</code>, this property will be
		 * ignored.
		 *
		 * <p>If this value is <code>NaN</code>, the <code>step</code> value
		 * will be used instead. If the <code>step</code> value is zero, paging
		 * with the track is not possible.</p>
		 *
		 * <p>In the following example, the page is changed to 10:</p>
		 *
		 * <listing version="3.0">
		 * slider.minimum = 0;
		 * slider.maximum = 100;
		 * slider.step = 1;
		 * slider.page = 10
		 * slider.value = 12;</listing>
		 *
		 * @default NaN
		 *
		 * @see #value
		 * @see #page
		 * @see #trackInteractionMode
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
		 * Determines if the slider dispatches the <code>Event.CHANGE</code>
		 * event every time the thumb moves, or only once it stops moving.
		 *
		 * <p>In the following example, live dragging is disabled:</p>
		 *
		 * <listing version="3.0">
		 * slider.liveDragging = false;</listing>
		 *
		 * @default true
		 */
		public var liveDragging:Boolean = true;
		
		/**
		 * @private
		 */
		protected var _showThumb:Boolean = true;
		
		/**
		 * Determines if the thumb should be displayed.
		 *
		 * <p>In the following example, the thumb is hidden:</p>
		 *
		 * <listing version="3.0">
		 * slider.showThumb = false;</listing>
		 *
		 * @default true
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
		protected var _thumbOffset:Number = 0;

		/**
		 *
		 * Offsets the position of the thumb by a certain number of pixels in a
		 * direction perpendicular to the track. This does not affect the
		 * measurement of the slider. The slider will measure itself as if the
		 * thumb were not offset from its original position.
		 *
		 * <p>In the following example, the thumb is offset by 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * slider.thumbOffset = 20;</listing>
		 *
		 * @default 0
		 */
		public function get thumbOffset():Number
		{
			return this._thumbOffset;
		}

		/**
		 * @private
		 */
		public function set thumbOffset(value:Number):void
		{
			if(this._thumbOffset == value)
			{
				return;
			}
			this._thumbOffset = value;
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
		 *
		 * <p>In the following example, minimum padding is set to 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * slider.minimumPadding = 20;</listing>
		 *
		 * @default 0
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
		 *
		 * <p>In the following example, maximum padding is set to 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * slider.maximumPadding = 20;</listing>
		 *
		 * @default 0
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
		protected var _trackLayoutMode:String = TrackLayoutMode.SINGLE;

		[Inspectable(type="String",enumeration="single,split")]
		/**
		 * Determines how the minimum and maximum track skins are positioned and
		 * sized.
		 *
		 * <p>In the following example, the slider is given two tracks:</p>
		 *
		 * <listing version="3.0">
		 * slider.trackLayoutMode = TrackLayoutMode.SPLIT;</listing>
		 *
		 * @default feathers.controls.TrackLayoutMode.SINGLE
		 *
		 * @see feathers.controls.TrackLayoutMode#SINGLE
		 * @see feathers.controls.TrackLayoutMode#SPLIT
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
			if(value === TRACK_LAYOUT_MODE_MIN_MAX)
			{
				value = TrackLayoutMode.SPLIT;
			}
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
		protected var _trackScaleMode:String = TrackScaleMode.DIRECTIONAL;

		[Inspectable(type="String",enumeration="exactFit,directional")]
		/**
		 * Determines how the minimum and maximum track skins are positioned and
		 * sized.
		 *
		 * <p>In the following example, the slider's track layout is customized:</p>
		 *
		 * <listing version="3.0">
		 * slider.trackScaleMode = TrackScaleMode.EXACT_FIT;</listing>
		 *
		 * @default feathers.controls.TrackScaleMode.DIRECTIONAL
		 *
		 * @see feathers.controls.TrackScaleMode#DIRECTIONAL
		 * @see feathers.controls.TrackScaleMode#EXACT_FIT
		 * @see #trackLayoutMode
		 */
		public function get trackScaleMode():String
		{
			return this._trackScaleMode;
		}

		/**
		 * @private
		 */
		public function set trackScaleMode(value:String):void
		{
			if(this._trackScaleMode == value)
			{
				return;
			}
			this._trackScaleMode = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _trackInteractionMode:String = TrackInteractionMode.TO_VALUE;

		[Inspectable(type="String",enumeration="toValue,byPage")]
		/**
		 * Determines how the slider's value changes when the track is touched.
		 *
		 * <p>If <code>showThumb</code> is set to <code>false</code>, the slider
		 * will always behave as if <code>trackInteractionMode</code> has been
		 * set to <code>TrackInteractionMode.TO_VALUE</code>. In other
		 * words, the value of <code>trackInteractionMode</code> may be ignored
		 * if the thumb is hidden.</p>
		 *
		 * <p>In the following example, the slider's track interaction is changed:</p>
		 *
		 * <listing version="3.0">
		 * slider.trackScaleMode = TrackInteractionMode.BY_PAGE;</listing>
		 *
		 * @default TrackInteractionMode.TO_VALUE
		 *
		 * @see feathers.controls.TrackInteractionMode#TO_VALUE
		 * @see feathers.controls.TrackInteractionMode#BY_PAGE
		 * @see #page
		 */
		public function get trackInteractionMode():String
		{
			return this._trackInteractionMode;
		}

		/**
		 * @private
		 */
		public function set trackInteractionMode(value:String):void
		{
			this._trackInteractionMode = value;
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
		 * <p>In the following example, the slider's repeat delay is set to
		 * 500 milliseconds:</p>
		 *
		 * <listing version="3.0">
		 * slider.repeatDelay = 0.5;</listing>
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
		protected var _minimumTrackFactory:Function;

		/**
		 * A function used to generate the slider's minimum track sub-component.
		 * The minimum track must be an instance of <code>BasicButton</code> (or
		 * a subclass). This factory can be used to change properties on the
		 * minimum track when it is first created. For instance, if you are
		 * skinning Feathers components without a theme, you might use this
		 * factory to set skins and other styles on the minimum track.
		 *
		 * <p>The function should have the following signature:</p>
		 * <pre>function():BasicButton</pre>
		 *
		 * <p>In the following example, a custom minimum track factory is passed
		 * to the slider:</p>
		 *
		 * <listing version="3.0">
		 * slider.minimumTrackFactory = function():BasicButton
		 * {
		 *     var track:BasicButton = new BasicButton();
		 *     var skin:ImageSkin = new ImageSkin( upTexture );
		 *     skin.setTextureForState( ButtonState.DOWN, downTexture );
		 *     track.defaultSkin = skin;
		 *     return track;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.BasicButton
		 */
		public function get minimumTrackFactory():Function
		{
			return this._minimumTrackFactory;
		}

		/**
		 * @private
		 */
		public function set minimumTrackFactory(value:Function):void
		{
			if(this._minimumTrackFactory == value)
			{
				return;
			}
			this._minimumTrackFactory = value;
			this.invalidate(INVALIDATION_FLAG_MINIMUM_TRACK_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _customMinimumTrackStyleName:String;

		/**
		 * A style name to add to the slider's minimum track sub-component.
		 * Typically used by a theme to provide different styles to different
		 * sliders.
		 *
		 * <p>In the following example, a custom minimum track style name is
		 * passed to the slider:</p>
		 *
		 * <listing version="3.0">
		 * slider.customMinimumTrackStyleName = "my-custom-minimum-track";</listing>
		 *
		 * <p>In your theme, you can target this sub-component style name to
		 * provide different styles than the default:</p>
		 *
		 * <listing version="3.0">
		 * getStyleProviderForClass( Button ).setFunctionForStyleName( "my-custom-minimum-track", setCustomMinimumTrackStyles );</listing>
		 *
		 * @default null
		 *
		 * @see #DEFAULT_CHILD_STYLE_NAME_MINIMUM_TRACK
		 * @see feathers.core.FeathersControl#styleNameList
		 * @see #minimumTrackFactory
		 * @see #minimumTrackProperties
		 */
		public function get customMinimumTrackStyleName():String
		{
			return this._customMinimumTrackStyleName;
		}

		/**
		 * @private
		 */
		public function set customMinimumTrackStyleName(value:String):void
		{
			if(this._customMinimumTrackStyleName == value)
			{
				return;
			}
			this._customMinimumTrackStyleName = value;
			this.invalidate(INVALIDATION_FLAG_MINIMUM_TRACK_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _minimumTrackProperties:PropertyProxy;

		/**
		 * An object that stores properties for the slider's "minimum" track,
		 * and the properties will be passed down to the "minimum" track when
		 * the slider validates. For a list of available properties, refer to
		 * <a href="BasicButton.html"><code>feathers.controls.BasicButton</code></a>.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
		 * which is in a <code>List</code>, you can use the following syntax:</p>
		 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * <p>Setting properties in a <code>minimumTrackFactory</code> function
		 * instead of using <code>minimumTrackProperties</code> will result in
		 * better performance.</p>
		 *
		 * <p>In the following example, the slider's minimum track properties
		 * are updated:</p>
		 *
		 * <listing version="3.0">
		 * slider.minimumTrackProperties.defaultSkin = new Image( upTexture );
		 * slider.minimumTrackProperties.downSkin = new Image( downTexture );</listing>
		 *
		 * @default null
		 *
		 * @see #minimumTrackFactory
		 * @see feathers.controls.BasicButton
		 */
		public function get minimumTrackProperties():Object
		{
			if(!this._minimumTrackProperties)
			{
				this._minimumTrackProperties = new PropertyProxy(childProperties_onChange);
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
				var newValue:PropertyProxy = new PropertyProxy();
				for(var propertyName:String in value)
				{
					newValue[propertyName] = value[propertyName];
				}
				value = newValue;
			}
			if(this._minimumTrackProperties)
			{
				this._minimumTrackProperties.removeOnChangeCallback(childProperties_onChange);
			}
			this._minimumTrackProperties = PropertyProxy(value);
			if(this._minimumTrackProperties)
			{
				this._minimumTrackProperties.addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _maximumTrackFactory:Function;

		/**
		 * A function used to generate the slider's maximum track sub-component.
		 * The maximum track must be an instance of <code>BasicButton</code> (or
		 * a subclass). This factory can be used to change properties on the
		 * maximum track when it is first created. For instance, if you are
		 * skinning Feathers components without a theme, you might use this
		 * factory to set skins and other styles on the maximum track.
		 *
		 * <p>The function should have the following signature:</p>
		 * <pre>function():BasicButton</pre>
		 *
		 * <p>In the following example, a custom maximum track factory is passed
		 * to the slider:</p>
		 *
		 * <listing version="3.0">
		 * slider.maximumTrackFactory = function():BasicButton
		 * {
		 *     var track:BasicButton = new BasicButton();
		 *     var skin:ImageSkin = new ImageSkin( upTexture );
		 *     skin.setTextureForState( ButtonState.DOWN, downTexture );
		 *     track.defaultSkin = skin;
		 *     return track;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.BasicButton
		 */
		public function get maximumTrackFactory():Function
		{
			return this._maximumTrackFactory;
		}

		/**
		 * @private
		 */
		public function set maximumTrackFactory(value:Function):void
		{
			if(this._maximumTrackFactory == value)
			{
				return;
			}
			this._maximumTrackFactory = value;
			this.invalidate(INVALIDATION_FLAG_MAXIMUM_TRACK_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _customMaximumTrackStyleName:String;

		/**
		 * A style name to add to the slider's maximum track sub-component.
		 * Typically used by a theme to provide different skins to different
		 * sliders.
		 *
		 * <p>In the following example, a custom maximum track style name is
		 * passed to the slider:</p>
		 *
		 * <listing version="3.0">
		 * slider.customMaximumTrackStyleName = "my-custom-maximum-track";</listing>
		 *
		 * <p>In your theme, you can target this sub-component style name to
		 * provide different styles than the default:</p>
		 *
		 * <listing version="3.0">
		 * getStyleProviderForClass( Button ).setFunctionForStyleName( "my-custom-maximum-track", setCustomMaximumTrackStyles );</listing>
		 *
		 * @default null
		 *
		 * @see #DEFAULT_CHILD_STYLE_NAME_MAXIMUM_TRACK
		 * @see feathers.core.FeathersControl#styleNameList
		 * @see #maximumTrackFactory
		 * @see #maximumTrackProperties
		 */
		public function get customMaximumTrackStyleName():String
		{
			return this._customMaximumTrackStyleName;
		}

		/**
		 * @private
		 */
		public function set customMaximumTrackStyleName(value:String):void
		{
			if(this._customMaximumTrackStyleName == value)
			{
				return;
			}
			this._customMaximumTrackStyleName = value;
			this.invalidate(INVALIDATION_FLAG_MAXIMUM_TRACK_FACTORY);
		}
		
		/**
		 * @private
		 */
		protected var _maximumTrackProperties:PropertyProxy;
		
		/**
		 * An object that stores properties for the slider's "maximum" track,
		 * and the properties will be passed down to the "maximum" track when
		 * the slider validates. For a list of available properties, refer to
		 * <a href="BasicButton.html"><code>feathers.controls.BasicButton</code></a>.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
		 * which is in a <code>List</code>, you can use the following syntax:</p>
		 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * <p>Setting properties in a <code>maximumTrackFactory</code> function
		 * instead of using <code>maximumTrackProperties</code> will result in
		 * better performance.</p>
		 *
		 * <p>In the following example, the slider's maximum track properties
		 * are updated:</p>
		 *
		 * <listing version="3.0">
		 * slider.maximumTrackProperties.defaultSkin = new Image( upTexture );
		 * slider.maximumTrackProperties.downSkin = new Image( downTexture );</listing>
		 *
		 * @default null
		 *
		 * @see #maximumTrackFactory
		 * @see feathers.controls.BasicButton
		 */
		public function get maximumTrackProperties():Object
		{
			if(!this._maximumTrackProperties)
			{
				this._maximumTrackProperties = new PropertyProxy(childProperties_onChange);
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
				var newValue:PropertyProxy = new PropertyProxy();
				for(var propertyName:String in value)
				{
					newValue[propertyName] = value[propertyName];
				}
				value = newValue;
			}
			if(this._maximumTrackProperties)
			{
				this._maximumTrackProperties.removeOnChangeCallback(childProperties_onChange);
			}
			this._maximumTrackProperties = PropertyProxy(value);
			if(this._maximumTrackProperties)
			{
				this._maximumTrackProperties.addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _thumbFactory:Function;

		/**
		 * A function used to generate the slider's thumb sub-component.
		 * The thumb must be an instance of <code>BasicButton</code> (or a
		 * subclass). This factory can be used to change properties on the thumb
		 * when it is first created. For instance, if you are skinning Feathers
		 * components without a theme, you might use this factory to set skins
		 * and other styles on the thumb.
		 *
		 * <p>The function should have the following signature:</p>
		 * <pre>function():BasicButton</pre>
		 *
		 * <p>In the following example, a custom thumb factory is passed
		 * to the slider:</p>
		 *
		 * <listing version="3.0">
		 * slider.thumbFactory = function():BasicButton
		 * {
		 *     var thumb:BasicButton = new BasicButton();
		 *     var skin:ImageSkin = new ImageSkin( upTexture );
		 *     skin.setTextureForState( ButtonState.DOWN, downTexture );
		 *     thumb.defaultSkin = skin;
		 *     return thumb;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.BasicButton
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
		protected var _customThumbStyleName:String;

		/**
		 * A style name to add to the slider's thumb sub-component. Typically
		 * used by a theme to provide different styles to different sliders.
		 *
		 * <p>In the following example, a custom thumb style name is passed
		 * to the slider:</p>
		 *
		 * <listing version="3.0">
		 * slider.customThumbStyleName = "my-custom-thumb";</listing>
		 *
		 * <p>In your theme, you can target this sub-component style name to
		 * provide different styles than the default:</p>
		 *
		 * <listing version="3.0">
		 * getStyleProviderForClass( Button ).setFunctionForStyleName( "my-custom-thumb", setCustomThumbStyles );</listing>
		 *
		 * @default null
		 *
		 * @see #DEFAULT_CHILD_STYLE_NAME_THUMB
		 * @see feathers.core.FeathersControl#styleNameList
		 * @see #thumbFactory
		 * @see #thumbProperties
		 */
		public function get customThumbStyleName():String
		{
			return this._customThumbStyleName;
		}

		/**
		 * @private
		 */
		public function set customThumbStyleName(value:String):void
		{
			if(this._customThumbStyleName == value)
			{
				return;
			}
			this._customThumbStyleName = value;
			this.invalidate(INVALIDATION_FLAG_THUMB_FACTORY);
		}
		
		/**
		 * @private
		 */
		protected var _thumbProperties:PropertyProxy;
		
		/**
		 * An object that stores properties for the slider's thumb, and the
		 * properties will be passed down to the thumb when the slider
		 * validates. For a list of available properties, refer to
		 * <a href="BasicButton.html"><code>feathers.controls.BasicButton</code></a>.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
		 * which is in a <code>List</code>, you can use the following syntax:</p>
		 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * <p>Setting properties in a <code>thumbFactory</code> function instead
		 * of using <code>thumbProperties</code> will result in better
		 * performance.</p>
		 *
		 * <p>In the following example, the slider's thumb properties
		 * are updated:</p>
		 *
		 * <listing version="3.0">
		 * slider.thumbProperties.defaultSkin = new Image( upTexture );
		 * slider.thumbProperties.downSkin = new Image( downTexture );</listing>
		 *
		 * @default null
		 * 
		 * @see feathers.controls.BasicButton
		 * @see #thumbFactory
		 */
		public function get thumbProperties():Object
		{
			if(!this._thumbProperties)
			{
				this._thumbProperties = new PropertyProxy(childProperties_onChange);
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
				var newValue:PropertyProxy = new PropertyProxy();
				for(var propertyName:String in value)
				{
					newValue[propertyName] = value[propertyName];
				}
				value = newValue;
			}
			if(this._thumbProperties)
			{
				this._thumbProperties.removeOnChangeCallback(childProperties_onChange);
			}
			this._thumbProperties = PropertyProxy(value);
			if(this._thumbProperties)
			{
				this._thumbProperties.addOnChangeCallback(childProperties_onChange);
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
			if(this._value < this._minimum)
			{
				this.value = this._minimum;
			}
			else if(this._value > this._maximum)
			{
				this.value = this._maximum;
			}
		}
		
		/**
		 * @private
		 */
		override protected function draw():void
		{
			var stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			var stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			var focusInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_FOCUS);
			var layoutInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_LAYOUT);
			var thumbFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_THUMB_FACTORY);
			var minimumTrackFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_MINIMUM_TRACK_FACTORY);
			var maximumTrackFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_MAXIMUM_TRACK_FACTORY);

			if(thumbFactoryInvalid)
			{
				this.createThumb();
			}

			if(minimumTrackFactoryInvalid)
			{
				this.createMinimumTrack();
			}

			if(maximumTrackFactoryInvalid || layoutInvalid)
			{
				this.createMaximumTrack();
			}

			if(thumbFactoryInvalid || stylesInvalid)
			{
				this.refreshThumbStyles();
			}
			if(minimumTrackFactoryInvalid || stylesInvalid)
			{
				this.refreshMinimumTrackStyles();
			}
			if((maximumTrackFactoryInvalid || layoutInvalid || stylesInvalid) && this.maximumTrack)
			{
				this.refreshMaximumTrackStyles();
			}
			
			if(stateInvalid || thumbFactoryInvalid || minimumTrackFactoryInvalid ||
				maximumTrackFactoryInvalid)
			{
				this.refreshEnabled();
			}

			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

			this.layoutChildren();

			if(sizeInvalid || focusInvalid)
			{
				this.refreshFocusIndicator();
			}
		}

		/**
		 * If the component's dimensions have not been set explicitly, it will
		 * measure its content and determine an ideal size for itself. If the
		 * <code>explicitWidth</code> or <code>explicitHeight</code> member
		 * variables are set, those value will be used without additional
		 * measurement. If one is set, but not the other, the dimension with the
		 * explicit value will not be measured, but the other non-explicit
		 * dimension will still need measurement.
		 *
		 * <p>Calls <code>saveMeasurements()</code> to set up the
		 * <code>actualWidth</code> and <code>actualHeight</code> member
		 * variables used for layout.</p>
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 */
		protected function autoSizeIfNeeded():Boolean
		{
			if(this._direction === Direction.VERTICAL)
			{
				return this.measureVertical();
			}
			return this.measureHorizontal();
		}

		/**
		 * @private
		 */
		protected function measureVertical():Boolean
		{
			var needsWidth:Boolean = this._explicitWidth !== this._explicitWidth; //isNaN
			var needsHeight:Boolean = this._explicitHeight !== this._explicitHeight; //isNaN
			var needsMinWidth:Boolean = this._explicitMinWidth !== this._explicitMinWidth; //isNaN
			var needsMinHeight:Boolean = this._explicitMinHeight !== this._explicitMinHeight; //isNaN
			if(!needsWidth && !needsHeight && !needsMinWidth && !needsMinHeight)
			{
				return false;
			}
			var isSingle:Boolean = this._trackLayoutMode === TrackLayoutMode.SINGLE;
			if(needsHeight)
			{
				this.minimumTrack.height = this._minimumTrackSkinExplicitHeight;
			}
			else if(isSingle)
			{
				this.minimumTrack.height = this._explicitHeight;
			}
			if(this.minimumTrack is IMeasureDisplayObject)
			{
				var measureMinTrack:IMeasureDisplayObject = IMeasureDisplayObject(this.minimumTrack);
				if(needsMinHeight)
				{
					measureMinTrack.minHeight = this._minimumTrackSkinExplicitMinHeight;
				}
				else if(isSingle)
				{
					var minTrackMinHeight:Number = this._explicitMinHeight;
					if(this._minimumTrackSkinExplicitMinHeight > minTrackMinHeight)
					{
						minTrackMinHeight = this._minimumTrackSkinExplicitMinHeight;
					}
					measureMinTrack.minHeight = minTrackMinHeight;
				}
			}
			if(!isSingle)
			{
				if(needsHeight)
				{
					this.maximumTrack.height = this._maximumTrackSkinExplicitHeight;
				}
				if(this.maximumTrack is IMeasureDisplayObject)
				{
					var measureMaxTrack:IMeasureDisplayObject = IMeasureDisplayObject(this.maximumTrack);
					if(needsMinHeight)
					{
						measureMaxTrack.minHeight = this._maximumTrackSkinExplicitMinHeight;
					}
				}
			}
			if(this.minimumTrack is IValidating)
			{
				IValidating(this.minimumTrack).validate();
			}
			if(this.maximumTrack is IValidating)
			{
				IValidating(this.maximumTrack).validate();
			}
			if(this.thumb is IValidating)
			{
				IValidating(this.thumb).validate();
			}
			var newWidth:Number = this._explicitWidth;
			var newHeight:Number = this._explicitHeight;
			var newMinWidth:Number = this._explicitMinWidth;
			var newMinHeight:Number = this._explicitMinHeight;
			if(needsWidth)
			{
				newWidth = this.minimumTrack.width;
				if(!isSingle && //split
					this.maximumTrack.width > newWidth)
				{
					newWidth = this.maximumTrack.width;
				}
				if(this.thumb.width > newWidth)
				{
					newWidth = this.thumb.width;
				}
			}
			if(needsHeight)
			{
				newHeight = this.minimumTrack.height;
				if(!isSingle) //split
				{
					if(this.maximumTrack.height > newHeight)
					{
						newHeight = this.maximumTrack.height;
					}
					newHeight += this.thumb.height / 2;
				}
			}
			if(needsMinWidth)
			{
				if(measureMinTrack !== null)
				{
					newMinWidth = measureMinTrack.minWidth;
				}
				else
				{
					newMinWidth = this.minimumTrack.width;
				}
				if(!isSingle) //split
				{
					if(measureMaxTrack !== null)
					{
						if(measureMaxTrack.minWidth > newMinWidth)
						{
							newMinWidth = measureMaxTrack.minWidth;
						}
					}
					else if(this.maximumTrack.width > newMinWidth)
					{
						newMinWidth = this.maximumTrack.width;
					}
				}
				if(this.thumb is IMeasureDisplayObject)
				{
					var measureThumb:IMeasureDisplayObject = IMeasureDisplayObject(this.thumb);
					if(measureThumb.minWidth > newMinWidth)
					{
						newMinWidth = measureThumb.minWidth;
					}
				}
				else if(this.thumb.width > newMinWidth)
				{
					newMinWidth = this.thumb.width;
				}
			}
			if(needsMinHeight)
			{
				if(measureMinTrack !== null)
				{
					newMinHeight = measureMinTrack.minHeight;
				}
				else
				{
					newMinHeight = this.minimumTrack.height;
				}
				if(!isSingle) //split
				{
					if(measureMaxTrack !== null)
					{
						if(measureMaxTrack.minHeight > newMinHeight)
						{
							newMinHeight = measureMaxTrack.minHeight;
						}
					}
					else
					{
						newMinHeight = this.maximumTrack.height;
					}
					if(this.thumb is IMeasureDisplayObject)
					{
						newMinHeight += IMeasureDisplayObject(this.thumb).minHeight / 2;
					}
					else
					{
						newMinHeight += this.thumb.height / 2;
					}
				}
			}
			return this.saveMeasurements(newWidth, newHeight, newMinWidth, newMinHeight);
		}

		/**
		 * @private
		 */
		protected function measureHorizontal():Boolean
		{
			var needsWidth:Boolean = this._explicitWidth !== this._explicitWidth; //isNaN
			var needsHeight:Boolean = this._explicitHeight !== this._explicitHeight; //isNaN
			var needsMinWidth:Boolean = this._explicitMinWidth !== this._explicitMinWidth; //isNaN
			var needsMinHeight:Boolean = this._explicitMinHeight !== this._explicitMinHeight; //isNaN
			if(!needsWidth && !needsHeight && !needsMinWidth && !needsMinHeight)
			{
				return false;
			}
			var isSingle:Boolean = this._trackLayoutMode === TrackLayoutMode.SINGLE;
			if(needsWidth)
			{
				this.minimumTrack.width = this._minimumTrackSkinExplicitWidth;
			}
			else if(isSingle)
			{
				this.minimumTrack.width = this._explicitWidth;
			}
			if(this.minimumTrack is IMeasureDisplayObject)
			{
				var measureMinTrack:IMeasureDisplayObject = IMeasureDisplayObject(this.minimumTrack);
				if(needsMinWidth)
				{
					measureMinTrack.minWidth = this._minimumTrackSkinExplicitMinWidth;
				}
				else if(isSingle)
				{
					var minTrackMinWidth:Number = this._explicitMinWidth;
					if(this._minimumTrackSkinExplicitMinWidth > minTrackMinWidth)
					{
						minTrackMinWidth = this._minimumTrackSkinExplicitMinWidth;
					}
					measureMinTrack.minWidth = minTrackMinWidth;
				}
			}
			if(!isSingle)
			{
				if(needsWidth)
				{
					this.maximumTrack.width = this._maximumTrackSkinExplicitWidth;
				}
				if(this.maximumTrack is IMeasureDisplayObject)
				{
					var measureMaxTrack:IMeasureDisplayObject = IMeasureDisplayObject(this.maximumTrack);
					if(needsMinWidth)
					{
						measureMaxTrack.minWidth = this._maximumTrackSkinExplicitMinWidth;
					}
				}
			}
			if(this.minimumTrack is IValidating)
			{
				IValidating(this.minimumTrack).validate();
			}
			if(this.maximumTrack is IValidating)
			{
				IValidating(this.maximumTrack).validate();
			}
			if(this.thumb is IValidating)
			{
				IValidating(this.thumb).validate();
			}
			var newWidth:Number = this._explicitWidth;
			var newHeight:Number = this._explicitHeight;
			var newMinWidth:Number = this._explicitMinWidth;
			var newMinHeight:Number = this._explicitMinHeight;
			if(needsWidth)
			{
				newWidth = this.minimumTrack.width;
				if(!isSingle) //split
				{
					if(this.maximumTrack.width > newWidth)
					{
						newWidth = this.maximumTrack.width;
					}
					newWidth += this.thumb.width / 2;
				}
			}
			if(needsHeight)
			{
				newHeight = this.minimumTrack.height;
				if(!isSingle && //split
					this.maximumTrack.height > newHeight)
				{
					newHeight = this.maximumTrack.height;
				}
				if(this.thumb.height > newHeight)
				{
					newHeight = this.thumb.height;
				}
			}
			if(needsMinWidth)
			{
				if(measureMinTrack !== null)
				{
					newMinWidth = measureMinTrack.minWidth;
				}
				else
				{
					newMinWidth = this.minimumTrack.width;
				}
				if(!isSingle) //split
				{
					if(measureMaxTrack !== null)
					{
						if(measureMaxTrack.minWidth > newMinWidth)
						{
							newMinWidth = measureMaxTrack.minWidth;
						}
					}
					else if(this.maximumTrack.width > newMinWidth)
					{
						newMinWidth = this.maximumTrack.width;
					}
					if(this.thumb is IMeasureDisplayObject)
					{
						newMinWidth += IMeasureDisplayObject(this.thumb).minWidth / 2;
					}
					else
					{
						newMinWidth += this.thumb.width / 2;
					}
				}
			}
			if(needsMinHeight)
			{
				if(measureMinTrack !== null)
				{
					newMinHeight = measureMinTrack.minHeight;
				}
				else
				{
					newMinHeight = this.minimumTrack.height;
				}
				if(!isSingle) //split
				{
					if(measureMaxTrack !== null)
					{
						if(measureMaxTrack.minHeight > newMinHeight)
						{
							newMinHeight = measureMaxTrack.minHeight;
						}
					}
					else if(this.maximumTrack.height > newMinHeight)
					{
						newMinHeight = this.maximumTrack.height;
					}
				}
				if(this.thumb is IMeasureDisplayObject)
				{
					var measureThumb:IMeasureDisplayObject = IMeasureDisplayObject(this.thumb);
					if(measureThumb.minHeight > newMinHeight)
					{
						newMinHeight = measureThumb.minHeight;
					}
				}
				else if(this.thumb.height > newMinHeight)
				{
					newMinHeight = this.thumb.height;
				}
			}
			return this.saveMeasurements(newWidth, newHeight, newMinWidth, newMinHeight);
		}

		/**
		 * Creates and adds the <code>thumb</code> sub-component and
		 * removes the old instance, if one exists.
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 *
		 * @see #thumb
		 * @see #thumbFactory
		 * @see #customThumbStyleName
		 */
		protected function createThumb():void
		{
			if(this.thumb)
			{
				this.thumb.removeFromParent(true);
				this.thumb = null;
			}

			var factory:Function = this._thumbFactory != null ? this._thumbFactory : defaultThumbFactory;
			var thumbStyleName:String = this._customThumbStyleName != null ? this._customThumbStyleName : this.thumbStyleName;
			var thumb:BasicButton = BasicButton(factory());
			thumb.styleNameList.add(thumbStyleName);
			thumb.keepDownStateOnRollOut = true;
			thumb.addEventListener(TouchEvent.TOUCH, thumb_touchHandler);
			this.addChild(thumb);
			this.thumb = thumb;
		}

		/**
		 * Creates and adds the <code>minimumTrack</code> sub-component and
		 * removes the old instance, if one exists.
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 *
		 * @see #minimumTrack
		 * @see #minimumTrackFactory
		 * @see #customMinimumTrackStyleName
		 */
		protected function createMinimumTrack():void
		{
			if(this.minimumTrack)
			{
				this.minimumTrack.removeFromParent(true);
				this.minimumTrack = null;
			}

			var factory:Function = this._minimumTrackFactory != null ? this._minimumTrackFactory : defaultMinimumTrackFactory;
			var minimumTrackStyleName:String = this._customMinimumTrackStyleName != null ? this._customMinimumTrackStyleName : this.minimumTrackStyleName;
			var minimumTrack:BasicButton = BasicButton(factory());
			minimumTrack.styleNameList.add(minimumTrackStyleName);
			minimumTrack.keepDownStateOnRollOut = true;
			minimumTrack.addEventListener(TouchEvent.TOUCH, track_touchHandler);
			this.addChildAt(minimumTrack, 0);
			this.minimumTrack = minimumTrack;

			if(this.minimumTrack is IMeasureDisplayObject)
			{
				var measureMinTrack:IMeasureDisplayObject = IMeasureDisplayObject(this.minimumTrack);
				this._minimumTrackSkinExplicitWidth = measureMinTrack.explicitWidth;
				this._minimumTrackSkinExplicitHeight = measureMinTrack.explicitHeight;
				this._minimumTrackSkinExplicitMinWidth = measureMinTrack.explicitMinWidth;
				this._minimumTrackSkinExplicitMinHeight = measureMinTrack.explicitMinHeight;
			}
			else
			{
				//this is a regular display object, and we'll treat its
				//measurements as explicit when we auto-size the slider
				this._minimumTrackSkinExplicitWidth = this.minimumTrack.width;
				this._minimumTrackSkinExplicitHeight = this.minimumTrack.height;
				this._minimumTrackSkinExplicitMinWidth = this._minimumTrackSkinExplicitWidth;
				this._minimumTrackSkinExplicitMinHeight = this._minimumTrackSkinExplicitHeight
			}
		}

		/**
		 * Creates and adds the <code>maximumTrack</code> sub-component and
		 * removes the old instance, if one exists. If the maximum track is not
		 * needed, it will not be created.
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 *
		 * @see #maximumTrack
		 * @see #maximumTrackFactory
		 * @see #customMaximumTrackStyleName
		 */
		protected function createMaximumTrack():void
		{
			if(this.maximumTrack !== null)
			{
				this.maximumTrack.removeFromParent(true);
				this.maximumTrack = null;
			}
			if(this._trackLayoutMode === TrackLayoutMode.SINGLE)
			{
				return;
			}
			
			var factory:Function = this._maximumTrackFactory != null ? this._maximumTrackFactory : defaultMaximumTrackFactory;
			var maximumTrackStyleName:String = this._customMaximumTrackStyleName != null ? this._customMaximumTrackStyleName : this.maximumTrackStyleName;
			var maximumTrack:BasicButton = BasicButton(factory());
			maximumTrack.styleNameList.add(maximumTrackStyleName);
			maximumTrack.keepDownStateOnRollOut = true;
			maximumTrack.addEventListener(TouchEvent.TOUCH, track_touchHandler);
			this.addChildAt(maximumTrack, 1);
			this.maximumTrack = maximumTrack;

			if(this.maximumTrack is IMeasureDisplayObject)
			{
				var measureMaxTrack:IMeasureDisplayObject = IMeasureDisplayObject(this.maximumTrack);
				this._maximumTrackSkinExplicitWidth = measureMaxTrack.explicitWidth;
				this._maximumTrackSkinExplicitHeight = measureMaxTrack.explicitHeight;
				this._maximumTrackSkinExplicitMinWidth = measureMaxTrack.explicitMinWidth;
				this._maximumTrackSkinExplicitMinHeight = measureMaxTrack.explicitMinHeight;
			}
			else
			{
				//this is a regular display object, and we'll treat its
				//measurements as explicit when we auto-size the slider
				this._maximumTrackSkinExplicitWidth = this.maximumTrack.width;
				this._maximumTrackSkinExplicitHeight = this.maximumTrack.height;
				this._maximumTrackSkinExplicitMinWidth = this._maximumTrackSkinExplicitWidth;
				this._maximumTrackSkinExplicitMinHeight = this._maximumTrackSkinExplicitHeight
			}
		}
		
		/**
		 * @private
		 */
		protected function refreshThumbStyles():void
		{
			for(var propertyName:String in this._thumbProperties)
			{
				var propertyValue:Object = this._thumbProperties[propertyName];
				this.thumb[propertyName] = propertyValue;
			}
			this.thumb.visible = this._showThumb;
		}
		
		/**
		 * @private
		 */
		protected function refreshMinimumTrackStyles():void
		{
			for(var propertyName:String in this._minimumTrackProperties)
			{
				var propertyValue:Object = this._minimumTrackProperties[propertyName];
				this.minimumTrack[propertyName] = propertyValue;
			}
		}

		/**
		 * @private
		 */
		protected function refreshMaximumTrackStyles():void
		{
			if(!this.maximumTrack)
			{
				return;
			}
			for(var propertyName:String in this._maximumTrackProperties)
			{
				var propertyValue:Object = this._maximumTrackProperties[propertyName];
				this.maximumTrack[propertyName] = propertyValue;
			}
		}

		/**
		 * @private
		 */
		protected function refreshEnabled():void
		{
			if(this.thumb is IFeathersControl)
			{
				IFeathersControl(this.thumb).isEnabled = this._isEnabled;
			}
			if(this.minimumTrack is IFeathersControl)
			{
				IFeathersControl(this.minimumTrack).isEnabled = this._isEnabled;
			}
			if(this.maximumTrack is IFeathersControl)
			{
				IFeathersControl(this.maximumTrack).isEnabled = this._isEnabled;
			}
		}

		/**
		 * @private
		 */
		protected function layoutChildren():void
		{
			this.layoutThumb();

			if(this._trackLayoutMode == TrackLayoutMode.SPLIT)
			{
				this.layoutTrackWithMinMax();
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
			if(this.thumb is IValidating)
			{
				IValidating(this.thumb).validate();
			}
			
			if(this._minimum === this._maximum)
			{
				var percentage:Number = 1;
			}
			else
			{
				percentage = (this._value - this._minimum) / (this._maximum - this._minimum);
				if(percentage < 0)
				{
					percentage = 0;
				}
				else if(percentage > 1)
				{
					percentage = 1;
				}
			}
			if(this._direction == Direction.VERTICAL)
			{
				var trackScrollableHeight:Number = this.actualHeight - this.thumb.height - this._minimumPadding - this._maximumPadding;
				this.thumb.x = Math.round((this.actualWidth - this.thumb.width) / 2) + this._thumbOffset;
				//maximum is at the top, so we need to start the y position of
				//the thumb from the maximum padding
				this.thumb.y = Math.round(this._maximumPadding + trackScrollableHeight * (1 - percentage));
			}
			else //horizontal
			{
				var trackScrollableWidth:Number = this.actualWidth - this.thumb.width - this._minimumPadding - this._maximumPadding;
				//minimum is at the left, so we need to start the x position of
				//the thumb from the minimum padding
				this.thumb.x = Math.round(this._minimumPadding + (trackScrollableWidth * percentage));
				this.thumb.y = Math.round((this.actualHeight - this.thumb.height) / 2) + this._thumbOffset;
			}
		}

		/**
		 * @private
		 */
		protected function layoutTrackWithMinMax():void
		{
			if(this._direction === Direction.VERTICAL)
			{
				var maximumTrackHeight:Number = Math.round(this.thumb.y + (this.thumb.height / 2));
				this.maximumTrack.y = 0;
				this.maximumTrack.height = maximumTrackHeight;
				this.minimumTrack.y = maximumTrackHeight;
				this.minimumTrack.height = this.actualHeight - maximumTrackHeight;
				if(this._trackScaleMode === TrackScaleMode.EXACT_FIT)
				{
					this.maximumTrack.x = 0;
					this.maximumTrack.width = this.actualWidth;
					this.minimumTrack.x = 0;
					this.minimumTrack.width = this.actualWidth;
				}
				else //directional
				{
					this.maximumTrack.width = this._maximumTrackSkinExplicitWidth;
					this.minimumTrack.width = this._minimumTrackSkinExplicitWidth;
				}
				
				//final validation to avoid juggler next frame issues
				if(this.minimumTrack is IValidating)
				{
					IValidating(this.minimumTrack).validate();
				}
				if(this.maximumTrack is IValidating)
				{
					IValidating(this.maximumTrack).validate();
				}

				if(this._trackScaleMode === TrackScaleMode.DIRECTIONAL)
				{
					this.maximumTrack.x = Math.round((this.actualWidth - this.maximumTrack.width) / 2);
					this.minimumTrack.x = Math.round((this.actualWidth - this.minimumTrack.width) / 2);
				}
			}
			else //horizontal
			{
				var minimumTrackWidth:Number = Math.round(this.thumb.x + (this.thumb.width / 2));
				this.minimumTrack.x = 0;
				this.minimumTrack.width = minimumTrackWidth;
				this.maximumTrack.x = minimumTrackWidth;
				this.maximumTrack.width = this.actualWidth - minimumTrackWidth;

				if(this._trackScaleMode === TrackScaleMode.EXACT_FIT)
				{
					this.minimumTrack.y = 0;
					this.minimumTrack.height = this.actualHeight;
					this.maximumTrack.y = 0;
					this.maximumTrack.height = this.actualHeight;
				}
				else //directional
				{
					this.minimumTrack.height = this._minimumTrackSkinExplicitHeight;
					this.maximumTrack.height = this._maximumTrackSkinExplicitHeight;
				}

				//final validation to avoid juggler next frame issues
				if(this.minimumTrack is IValidating)
				{
					IValidating(this.minimumTrack).validate();
				}
				if(this.maximumTrack is IValidating)
				{
					IValidating(this.maximumTrack).validate();
				}

				if(this._trackScaleMode === TrackScaleMode.DIRECTIONAL)
				{
					this.minimumTrack.y = Math.round((this.actualHeight - this.minimumTrack.height) / 2);
					this.maximumTrack.y = Math.round((this.actualHeight - this.maximumTrack.height) / 2);
				}
			}
		}

		/**
		 * @private
		 */
		protected function layoutTrackWithSingle():void
		{
			if(this._direction === Direction.VERTICAL)
			{
				this.minimumTrack.y = 0;
				this.minimumTrack.height = this.actualHeight;
				if(this._trackScaleMode === TrackScaleMode.EXACT_FIT)
				{
					this.minimumTrack.x = 0;
					this.minimumTrack.width = this.actualWidth;
				}
				else //directional
				{
					//we'll calculate x after validation in case the track needs
					//to auto-size
					this.minimumTrack.width = this._minimumTrackSkinExplicitWidth;
				}

				//final validation to avoid juggler next frame issues
				if(this.minimumTrack is IValidating)
				{
					IValidating(this.minimumTrack).validate();
				}
				
				if(this._trackScaleMode === TrackScaleMode.DIRECTIONAL)
				{
					this.minimumTrack.x = Math.round((this.actualWidth - this.minimumTrack.width) / 2);
				}
			}
			else //horizontal
			{
				this.minimumTrack.x = 0;
				this.minimumTrack.width = this.actualWidth;
				if(this._trackScaleMode === TrackScaleMode.EXACT_FIT)
				{
					this.minimumTrack.y = 0;
					this.minimumTrack.height = this.actualHeight;
				}
				else //directional
				{
					//we'll calculate y after validation in case the track needs
					//to auto-size
					this.minimumTrack.height = this._minimumTrackSkinExplicitHeight;
				}

				//final validation to avoid juggler next frame issues
				if(this.minimumTrack is IValidating)
				{
					IValidating(this.minimumTrack).validate();
				}

				if(this._trackScaleMode === TrackScaleMode.DIRECTIONAL)
				{
					this.minimumTrack.y = Math.round((this.actualHeight - this.minimumTrack.height) / 2);
				}
			}
		}

		/**
		 * @private
		 */
		protected function locationToValue(location:Point):Number
		{
			var percentage:Number;
			if(this._direction == Direction.VERTICAL)
			{
				var trackScrollableHeight:Number = this.actualHeight - this.thumb.height - this._minimumPadding - this._maximumPadding;
				var yOffset:Number = location.y - this._touchStartY - this._maximumPadding;
				var yPosition:Number = Math.min(Math.max(0, this._thumbStartY + yOffset), trackScrollableHeight);
				percentage = 1 - (yPosition / trackScrollableHeight);
			}
			else //horizontal
			{
				var trackScrollableWidth:Number = this.actualWidth - this.thumb.width - this._minimumPadding - this._maximumPadding;
				var xOffset:Number = location.x - this._touchStartX - this._minimumPadding;
				var xPosition:Number = Math.min(Math.max(0, this._thumbStartX + xOffset), trackScrollableWidth);
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
			var page:Number = this._page;
			if(page !== page) //isNaN
			{
				page = this._step;
			}
			if(this._touchValue < this._value)
			{
				this.value = Math.max(this._touchValue, this._value - page);
			}
			else if(this._touchValue > this._value)
			{
				this.value = Math.min(this._touchValue, this._value + page);
			}
		}

		/**
		 * @private
		 */
		protected function childProperties_onChange(proxy:PropertyProxy, name:Object):void
		{
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected function slider_removedFromStageHandler(event:Event):void
		{
			this._touchPointID = -1;
			var wasDragging:Boolean = this.isDragging;
			this.isDragging = false;
			if(wasDragging && !this.liveDragging)
			{
				this.dispatchEventWith(Event.CHANGE);
			}
		}

		/**
		 * @private
		 */
		override protected function focusInHandler(event:Event):void
		{
			super.focusInHandler(event);
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
		}

		/**
		 * @private
		 */
		override protected function focusOutHandler(event:Event):void
		{
			super.focusOutHandler(event);
			this.stage.removeEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
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

			var track:DisplayObject = DisplayObject(event.currentTarget);
			if(this._touchPointID >= 0)
			{
				var touch:Touch = event.getTouch(track, null, this._touchPointID);
				if(!touch)
				{
					return;
				}
				if(touch.phase === TouchPhase.MOVED)
				{
					touch.getLocation(this, HELPER_POINT);
					this.value = this.locationToValue(HELPER_POINT);
				}
				else if(touch.phase === TouchPhase.ENDED)
				{
					if(this._repeatTimer)
					{
						this._repeatTimer.stop();
					}
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
				touch = event.getTouch(track, TouchPhase.BEGAN);
				if(!touch)
				{
					return;
				}
				touch.getLocation(this, HELPER_POINT);
				this._touchPointID = touch.id;
				if(this._direction == Direction.VERTICAL)
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
				this.dispatchEventWith(FeathersEventType.BEGIN_INTERACTION);
				if(this._showThumb && this._trackInteractionMode === TrackInteractionMode.BY_PAGE)
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
		
		/**
		 * @private
		 */
		protected function thumb_touchHandler(event:TouchEvent):void
		{
			if(!this._isEnabled)
			{
				this._touchPointID = -1;
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
					var exclusiveTouch:ExclusiveTouch = ExclusiveTouch.forStage(this.stage);
					var claim:DisplayObject = exclusiveTouch.getClaim(this._touchPointID);
					if(claim != this)
					{
						if(claim)
						{
							//already claimed by another display object
							return;
						}
						else
						{
							exclusiveTouch.claimTouch(this._touchPointID, this);
						}
					}
					touch.getLocation(this, HELPER_POINT);
					this.value = this.locationToValue(HELPER_POINT);
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
		protected function stage_keyDownHandler(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.HOME)
			{
				this.value = this._minimum;
				return;
			}
			if(event.keyCode == Keyboard.END)
			{
				this.value = this._maximum;
				return;
			}
			var page:Number = this._page;
			if(page !== page) //isNaN
			{
				page = this._step;
			}
			if(this._direction == Direction.VERTICAL)
			{
				if(event.keyCode == Keyboard.UP)
				{
					if(event.shiftKey)
					{
						this.value += page;
					}
					else
					{
						this.value += this._step;
					}
				}
				else if(event.keyCode == Keyboard.DOWN)
				{
					if(event.shiftKey)
					{
						this.value -= page;
					}
					else
					{
						this.value -= this._step;
					}
				}
			}
			else
			{
				if(event.keyCode == Keyboard.LEFT)
				{
					if(event.shiftKey)
					{
						this.value -= page;
					}
					else
					{
						this.value -= this._step;
					}
				}
				else if(event.keyCode == Keyboard.RIGHT)
				{
					if(event.shiftKey)
					{
						this.value += page;
					}
					else
					{
						this.value += this._step;
					}
				}
			}
		}

		/**
		 * @private
		 */
		protected function repeatTimer_timerHandler(event:TimerEvent):void
		{
			var exclusiveTouch:ExclusiveTouch = ExclusiveTouch.forStage(this.stage);
			var claim:DisplayObject = exclusiveTouch.getClaim(this._touchPointID);
			if(claim && claim != this)
			{
				return;
			}
			if(this._repeatTimer.currentCount < 5)
			{
				return;
			}
			this.currentRepeatAction();
		}
	}
}