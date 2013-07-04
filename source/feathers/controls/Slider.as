/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.core.FeathersControl;
	import feathers.core.IFocusDisplayObject;
	import feathers.core.PropertyProxy;
	import feathers.events.FeathersEventType;
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
	 * @eventType starling.events.Event.CHANGE
	 */
	[Event(name="change",type="starling.events.Event")]

	/**
	 * Dispatched when the user starts dragging the slider's thumb or track.
	 *
	 * @eventType feathers.events.FeathersEventType.BEGIN_INTERACTION
	 */
	[Event(name="beginInteraction",type="starling.events.Event")]

	/**
	 * Dispatched when the user stops dragging the slider's thumb or track.
	 *
	 * @eventType feathers.events.FeathersEventType.END_INTERACTION
	 */
	[Event(name="endInteraction",type="starling.events.Event")]

	/**
	 * Select a value between a minimum and a maximum by dragging a thumb over
	 * the bounds of a track. The slider's track is divided into two parts split
	 * by the thumb.
	 *
	 * <p>The following example sets the slider's values and listens for when
	 * when the value changes:</p>
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
	 * @see http://wiki.starling-framework.org/feathers/slider
	 */
	public class Slider extends FeathersControl implements IScrollBar, IFocusDisplayObject
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
		 * The slider's thumb may be dragged horizontally (on the x-axis).
		 *
		 * @see #direction
		 */
		public static const DIRECTION_HORIZONTAL:String = "horizontal";
		
		/**
		 * The slider's thumb may be dragged vertically (on the y-axis).
		 *
		 * @see #direction
		 */
		public static const DIRECTION_VERTICAL:String = "vertical";

		/**
		 * The slider has only one track, that fills the full length of the
		 * slider. In this layout mode, the "minimum" track is displayed and
		 * fills the entire length of the slider. The maximum track will not
		 * exist.
		 *
		 * @see #trackLayoutMode
		 */
		public static const TRACK_LAYOUT_MODE_SINGLE:String = "single";

		/**
		 * The slider has two tracks, stretching to fill each side of the slider
		 * with the thumb in the middle. The tracks will be resized as the thumb
		 * moves. This layout mode is designed for sliders where the two sides
		 * of the track may be colored differently to show the value
		 * "filling up" as the slider is dragged.
		 *
		 * <p>Since the width and height of the tracks will change, consider
		 * using a special display object such as a <code>Scale9Image</code>,
		 * <code>Scale3Image</code> or a <code>TiledImage</code> that is
		 * designed to be resized dynamically.</p>
		 *
		 * @see #trackLayoutMode
		 * @see feathers.display.Scale9Image
		 * @see feathers.display.Scale3Image
		 * @see feathers.display.TiledImage
		 */
		public static const TRACK_LAYOUT_MODE_MIN_MAX:String = "minMax";

		/**
		 * The slider's track dimensions fill the full width and height of the
		 * slider.
		 *
		 * @see #trackScaleMode
		 */
		public static const TRACK_SCALE_MODE_EXACT_FIT:String = "exactFit";

		/**
		 * If the slider's direction is horizontal, the width of the track will
		 * fill the full width of the slider, and if the slider's direction is
		 * vertical, the height of the track will fill the full height of the
		 * slider. The other edge will not be scaled.
		 *
		 * @see #trackScaleMode
		 */
		public static const TRACK_SCALE_MODE_DIRECTIONAL:String = "directional";

		/**
		 * The default value added to the <code>nameList</code> of the minimum
		 * track.
		 *
		 * @see feathers.core.IFeathersControl#nameList
		 */
		public static const DEFAULT_CHILD_NAME_MINIMUM_TRACK:String = "feathers-slider-minimum-track";

		/**
		 * The default value added to the <code>nameList</code> of the maximum
		 * track.
		 *
		 * @see feathers.core.IFeathersControl#nameList
		 */
		public static const DEFAULT_CHILD_NAME_MAXIMUM_TRACK:String = "feathers-slider-maximum-track";

		/**
		 * The default value added to the <code>nameList</code> of the thumb.
		 *
		 * @see feathers.core.IFeathersControl#nameList
		 */
		public static const DEFAULT_CHILD_NAME_THUMB:String = "feathers-slider-thumb";

		/**
		 * @private
		 */
		protected static function defaultThumbFactory():Button
		{
			return new Button();
		}

		/**
		 * @private
		 */
		protected static function defaultMinimumTrackFactory():Button
		{
			return new Button();
		}

		/**
		 * @private
		 */
		protected static function defaultMaximumTrackFactory():Button
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
		 * The value added to the <code>nameList</code> of the minimum track. This
		 * variable is <code>protected</code> so that sub-classes can customize
		 * the minimum track name in their constructors instead of using the default
		 * name defined by <code>DEFAULT_CHILD_NAME_MINIMUM_TRACK</code>.
		 *
		 * <p>To customize the minimum track name without subclassing, see
		 * <code>customMinimumTrackName</code>.</p>
		 *
		 * @see #customMinimumTrackName
		 * @see feathers.core.IFeathersControl#nameList
		 */
		protected var minimumTrackName:String = DEFAULT_CHILD_NAME_MINIMUM_TRACK;

		/**
		 * The value added to the <code>nameList</code> of the maximum track. This
		 * variable is <code>protected</code> so that sub-classes can customize
		 * the maximum track name in their constructors instead of using the default
		 * name defined by <code>DEFAULT_CHILD_NAME_MAXIMUM_TRACK</code>.
		 *
		 * <p>To customize the maximum track name without subclassing, see
		 * <code>customMaximumTrackName</code>.</p>
		 *
		 * @see #customMaximumTrackName
		 * @see feathers.core.IFeathersControl#nameList
		 */
		protected var maximumTrackName:String = DEFAULT_CHILD_NAME_MAXIMUM_TRACK;

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
		 * The thumb sub-component.
		 */
		protected var thumb:Button;
		
		/**
		 * The minimum track sub-component.
		 */
		protected var minimumTrack:Button;

		/**
		 * The maximum track sub-component.
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
		protected var _direction:String = DIRECTION_HORIZONTAL;

		[Inspectable(type="String",enumeration="horizontal,vertical")]
		/**
		 * Determines if the slider's thumb can be dragged horizontally or
		 * vertically. When this value changes, the slider's width and height
		 * values do not change automatically.
		 *
		 * <p>In the following example, the direction is changed to vertical:</p>
		 *
		 * <listing version="3.0">
		 * slider.direction = Slider.DIRECTION_VERTICAL;</listing>
		 *
		 * @default Slider.DIRECTION_HORIZONTAL
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
		 * If the slider's track is touched, and the thumb is shown, the slider
		 * value will be incremented or decremented by the page value. If the
		 * thumb is hidden, this value is ignored, and the track may be dragged
		 * instead.
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
		protected var _trackLayoutMode:String = TRACK_LAYOUT_MODE_SINGLE;

		[Inspectable(type="String",enumeration="single,minMax")]
		/**
		 * Determines how the minimum and maximum track skins are positioned and
		 * sized.
		 *
		 * <p>In the following example, the slider is given two tracks:</p>
		 *
		 * <listing version="3.0">
		 * slider.trackLayoutMode = Slider.TRACK_LAYOUT_MODE_MIN_MAX;</listing>
		 *
		 * @default Slider.TRACK_LAYOUT_MODE_SINGLE
		 *
		 * @see #TRACK_LAYOUT_MODE_SINGLE
		 * @see #TRACK_LAYOUT_MODE_MIN_MAX
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
		protected var _trackScaleMode:String = TRACK_SCALE_MODE_DIRECTIONAL;

		[Inspectable(type="String",enumeration="exactFit,directional")]
		/**
		 * Determines how the minimum and maximum track skins are positioned and
		 * sized.
		 *
		 * <p>In the following example, the slider's track layout is customized:</p>
		 *
		 * <listing version="3.0">
		 * slider.trackScaleMode = Slider.TRACK_SCALE_MODE_EXACT_FIT;</listing>
		 *
		 * @default Slider.TRACK_SCALE_MODE_DIRECTIONAL
		 *
		 * @see #TRACK_SCALE_MODE_DIRECTIONAL
		 * @see #TRACK_SCALE_MODE_EXACT_FIT
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
		 * The minimum track must be an instance of <code>Button</code>. This
		 * factory can be used to change properties on the minimum track when it
		 * is first created. For instance, if you are skinning Feathers
		 * components without a theme, you might use this factory to set skins
		 * and other styles on the minimum track.
		 *
		 * <p>The function should have the following signature:</p>
		 * <pre>function():Button</pre>
		 *
		 * <p>In the following example, a custom minimum track factory is passed
		 * to the slider:</p>
		 *
		 * <listing version="3.0">
		 * slider.minimumTrackFactory = function():Button
		 * {
		 *     var track:Button = new Button();
		 *     track.defaultSkin = new Image( upTexture );
		 *     track.downSkin = new Image( downTexture );
		 *     return track;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.Button
		 * @see #minimumTrackProperties
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
		protected var _customMinimumTrackName:String;

		/**
		 * A name to add to the slider's minimum track sub-component. Typically
		 * used by a theme to provide different skins to different sliders.
		 *
		 * <p>In the following example, a custom minimum track name is passed
		 * to the slider:</p>
		 *
		 * <listing version="3.0">
		 * slider.customMinimumTrackName = "my-custom-minimum-track";</listing>
		 *
		 * <p>In your theme, you can target this sub-component name to provide
		 * different skins than the default style:</p>
		 *
		 * <listing version="3.0">
		 * setInitializerForClass( Button, customMinimumTrackInitializer, "my-custom-minimum-track");</listing>
		 *
		 * @default null
		 *
		 * @see #DEFAULT_CHILD_NAME_MINIMUM_TRACK
		 * @see feathers.core.FeathersControl#nameList
		 * @see feathers.core.DisplayListWatcher
		 * @see #minimumTrackFactory
		 * @see #minimumTrackProperties
		 */
		public function get customMinimumTrackName():String
		{
			return this._customMinimumTrackName;
		}

		/**
		 * @private
		 */
		public function set customMinimumTrackName(value:String):void
		{
			if(this._customMinimumTrackName == value)
			{
				return;
			}
			this._customMinimumTrackName = value;
			this.invalidate(INVALIDATION_FLAG_MINIMUM_TRACK_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _minimumTrackProperties:PropertyProxy;

		/**
		 * A set of key/value pairs to be passed down to the slider's minimum
		 * track sub-component. The minimum track is a
		 * <code>feathers.controls.Button</code> instance that is created by
		 * <code>minimumTrackFactory</code>.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
		 * which is in a <code>Scroller</code> which is in a <code>List</code>,
		 * you can use the following syntax:</p>
		 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
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
		 * @see feathers.controls.Button
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
				const newValue:PropertyProxy = new PropertyProxy();
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
		 * The maximum track must be an instance of <code>Button</code>.
		 * This factory can be used to change properties on the maximum track
		 * when it is first created. For instance, if you are skinning Feathers
		 * components without a theme, you might use this factory to set skins
		 * and other styles on the maximum track.
		 *
		 * <p>The function should have the following signature:</p>
		 * <pre>function():Button</pre>
		 *
		 * <p>In the following example, a custom maximum track factory is passed
		 * to the slider:</p>
		 *
		 * <listing version="3.0">
		 * slider.maximumTrackFactory = function():Button
		 * {
		 *     var track:Button = new Button();
		 *     track.defaultSkin = new Image( upTexture );
		 *     track.downSkin = new Image( downTexture );
		 *     return track;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.Button
		 * @see #maximumTrackProperties
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
		protected var _customMaximumTrackName:String;

		/**
		 * A name to add to the slider's maximum track sub-component. Typically
		 * used by a theme to provide different skins to different sliders.
		 *
		 * <p>In the following example, a custom maximum track name is passed
		 * to the slider:</p>
		 *
		 * <listing version="3.0">
		 * slider.customMaximumTrackName = "my-custom-maximum-track";</listing>
		 *
		 * <p>In your theme, you can target this sub-component name to provide
		 * different skins than the default style:</p>
		 *
		 * <listing version="3.0">
		 * setInitializerForClass( Button, customMaximumTrackInitializer, "my-custom-maximum-track");</listing>
		 *
		 * @default null
		 *
		 * @see #DEFAULT_CHILD_NAME_MAXIMUM_TRACK
		 * @see feathers.core.FeathersControl#nameList
		 * @see feathers.core.DisplayListWatcher
		 * @see #maximumTrackFactory
		 * @see #maximumTrackProperties
		 */
		public function get customMaximumTrackName():String
		{
			return this._customMaximumTrackName;
		}

		/**
		 * @private
		 */
		public function set customMaximumTrackName(value:String):void
		{
			if(this._customMaximumTrackName == value)
			{
				return;
			}
			this._customMaximumTrackName = value;
			this.invalidate(INVALIDATION_FLAG_MAXIMUM_TRACK_FACTORY);
		}
		
		/**
		 * @private
		 */
		protected var _maximumTrackProperties:PropertyProxy;
		
		/**
		 * A set of key/value pairs to be passed down to the slider's maximum
		 * track sub-component. The maximum track is a
		 * <code>feathers.controls.Button</code> instance that is created by
		 * <code>maximumTrackFactory</code>.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
		 * which is in a <code>Scroller</code> which is in a <code>List</code>,
		 * you can use the following syntax:</p>
		 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
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
		 * @see feathers.controls.Button
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
				const newValue:PropertyProxy = new PropertyProxy();
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
		 * to the slider:</p>
		 *
		 * <listing version="3.0">
		 * slider.thumbFactory = function():Button
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
		 * A name to add to the slider's thumb sub-component. Typically
		 * used by a theme to provide different skins to different sliders.
		 *
		 * <p>In the following example, a custom thumb name is passed
		 * to the slider:</p>
		 *
		 * <listing version="3.0">
		 * slider.customThumbName = "my-custom-thumb";</listing>
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
		 * A set of key/value pairs to be passed down to the slider's thumb
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
		 * <p>In the following example, the slider's thumb properties
		 * are updated:</p>
		 *
		 * <listing version="3.0">
		 * slider.thumbProperties.defaultSkin = new Image( upTexture );
		 * slider.thumbProperties.downSkin = new Image( downTexture );</listing>
		 *
		 * @default null
		 * 
		 * @see feathers.controls.Button
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
				const newValue:PropertyProxy = new PropertyProxy();
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
		override protected function draw():void
		{
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			const stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			const focusInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_FOCUS);
			const thumbFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_THUMB_FACTORY);
			const minimumTrackFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_MINIMUM_TRACK_FACTORY);
			const maximumTrackFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_MAXIMUM_TRACK_FACTORY);

			if(thumbFactoryInvalid)
			{
				this.createThumb();
			}

			if(minimumTrackFactoryInvalid)
			{
				this.createMinimumTrack();
			}

			this.createOrDestroyMaximumTrackIfNeeded(maximumTrackFactoryInvalid);

			if(thumbFactoryInvalid || stylesInvalid)
			{
				this.refreshThumbStyles();
			}
			if(minimumTrackFactoryInvalid || stylesInvalid)
			{
				this.refreshMinimumTrackStyles();
			}
			if((maximumTrackFactoryInvalid || stylesInvalid) && this.maximumTrack)
			{
				this.refreshMaximumTrackStyles();
			}
			
			if(thumbFactoryInvalid || stateInvalid)
			{
				this.thumb.isEnabled = this._isEnabled;
			}
			if(minimumTrackFactoryInvalid || stateInvalid)
			{
				this.minimumTrack.isEnabled = this._isEnabled;
			}
			if((maximumTrackFactoryInvalid || stateInvalid) && this.maximumTrack)
			{
				this.maximumTrack.isEnabled = this._isEnabled;
			}

			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

			if(thumbFactoryInvalid || minimumTrackFactoryInvalid || maximumTrackFactoryInvalid ||
				dataInvalid || stylesInvalid || sizeInvalid)
			{
				this.layoutChildren();
			}

			if(sizeInvalid || focusInvalid)
			{
				this.refreshFocusIndicator();
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
				newWidth = Math.max(newWidth, this.thumb.width);
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
				newHeight = Math.max(newHeight, this.thumb.height);
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
			this.thumb.keepDownStateOnRollOut = true;
			this.thumb.addEventListener(TouchEvent.TOUCH, thumb_touchHandler);
			this.addChild(this.thumb);
		}

		/**
		 * @private
		 */
		protected function createMinimumTrack():void
		{
			if(this.minimumTrack)
			{
				this.minimumTrack.removeFromParent(true);
				this.minimumTrack = null;
			}

			const factory:Function = this._minimumTrackFactory != null ? this._minimumTrackFactory : defaultMinimumTrackFactory;
			const minimumTrackName:String = this._customMinimumTrackName != null ? this._customMinimumTrackName : this.minimumTrackName;
			this.minimumTrack = Button(factory());
			this.minimumTrack.nameList.add(minimumTrackName);
			this.minimumTrack.keepDownStateOnRollOut = true;
			this.minimumTrack.addEventListener(TouchEvent.TOUCH, track_touchHandler);
			this.addChildAt(this.minimumTrack, 0);
		}

		/**
		 * @private
		 */
		protected function createOrDestroyMaximumTrackIfNeeded(maximumTrackFactoryInvalid:Boolean):void
		{
			if(this._trackLayoutMode == TRACK_LAYOUT_MODE_MIN_MAX)
			{
				if(!maximumTrackFactoryInvalid)
				{
					return;
				}
				if(this.maximumTrack)
				{
					this.maximumTrack.removeFromParent(true);
					this.maximumTrack = null;
				}
				const factory:Function = this._maximumTrackFactory != null ? this._maximumTrackFactory : defaultMaximumTrackFactory;
				const maximumTrackName:String = this._customMaximumTrackName != null ? this._customMaximumTrackName : this.maximumTrackName;
				this.maximumTrack = Button(factory());
				this.maximumTrack.nameList.add(maximumTrackName);
				this.maximumTrack.keepDownStateOnRollOut = true;
				this.maximumTrack.addEventListener(TouchEvent.TOUCH, track_touchHandler);
				this.addChildAt(this.maximumTrack, 1);
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
		protected function refreshMinimumTrackStyles():void
		{
			for(var propertyName:String in this._minimumTrackProperties)
			{
				if(this.minimumTrack.hasOwnProperty(propertyName))
				{
					var propertyValue:Object = this._minimumTrackProperties[propertyName];
					this.minimumTrack[propertyName] = propertyValue;
				}
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
				if(this.maximumTrack.hasOwnProperty(propertyName))
				{
					var propertyValue:Object = this._maximumTrackProperties[propertyName];
					this.maximumTrack[propertyName] = propertyValue;
				}
			}
		}

		/**
		 * @private
		 */
		protected function layoutChildren():void
		{
			this.layoutThumb();

			if(this._trackLayoutMode == TRACK_LAYOUT_MODE_MIN_MAX)
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
		protected function layoutTrackWithMinMax():void
		{
			if(this._direction == DIRECTION_VERTICAL)
			{
				this.maximumTrack.y = 0;
				this.maximumTrack.height = this.thumb.y + this.thumb.height / 2;
				this.minimumTrack.y = this.maximumTrack.height;
				this.minimumTrack.height = this.actualHeight - this.minimumTrack.y;

				if(this._trackScaleMode == TRACK_SCALE_MODE_DIRECTIONAL)
				{
					this.maximumTrack.width = NaN;
					this.maximumTrack.validate();
					this.maximumTrack.x = (this.actualWidth - this.maximumTrack.width) / 2;
					this.minimumTrack.width = NaN;
					this.minimumTrack.validate();
					this.minimumTrack.x = (this.actualWidth - this.minimumTrack.width) / 2;
				}
				else //exact fit
				{
					this.maximumTrack.x = 0;
					this.maximumTrack.width = this.actualWidth;
					this.minimumTrack.x = 0;
					this.minimumTrack.width = this.actualWidth;
				}
			}
			else //horizontal
			{
				this.minimumTrack.x = 0;
				this.minimumTrack.width = this.thumb.x + this.thumb.width / 2;
				this.maximumTrack.x = this.minimumTrack.width;
				this.maximumTrack.width = this.actualWidth - this.maximumTrack.x;

				if(this._trackScaleMode == TRACK_SCALE_MODE_DIRECTIONAL)
				{
					this.minimumTrack.height = NaN;
					this.minimumTrack.validate();
					this.minimumTrack.y = (this.actualHeight - this.minimumTrack.height) / 2;
					this.maximumTrack.height = NaN;
					this.maximumTrack.validate();
					this.maximumTrack.y = (this.actualHeight - this.maximumTrack.height) / 2;
				}
				else //exact fit
				{
					this.minimumTrack.y = 0;
					this.minimumTrack.height = this.actualHeight;
					this.maximumTrack.y = 0;
					this.maximumTrack.height = this.actualHeight;
				}
			}
		}

		/**
		 * @private
		 */
		protected function layoutTrackWithSingle():void
		{
			if(this._trackScaleMode == TRACK_SCALE_MODE_DIRECTIONAL)
			{
				if(this._direction == DIRECTION_VERTICAL)
				{
					this.minimumTrack.y = 0;
					this.minimumTrack.width = NaN;
					this.minimumTrack.height = this.actualHeight;
					this.minimumTrack.validate();
					this.minimumTrack.x = (this.actualWidth - this.minimumTrack.width) / 2;
				}
				else //horizontal
				{
					this.minimumTrack.x = 0;
					this.minimumTrack.width = this.actualWidth;
					this.minimumTrack.height = NaN;
					this.minimumTrack.validate();
					this.minimumTrack.y = (this.actualHeight - this.minimumTrack.height) / 2;
				}
			}
			else //exact fit
			{
				this.minimumTrack.x = 0;
				this.minimumTrack.y = 0;
				this.minimumTrack.width = this.actualWidth;
				this.minimumTrack.height = this.actualHeight;
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
				const trackScrollableHeight:Number = this.actualHeight - this.thumb.height - this._minimumPadding - this._maximumPadding;
				const yOffset:Number = location.y - this._touchStartY - this._maximumPadding;
				const yPosition:Number = Math.min(Math.max(0, this._thumbStartY + yOffset), trackScrollableHeight);
				percentage = 1 - (yPosition / trackScrollableHeight);
			}
			else //horizontal
			{
				const trackScrollableWidth:Number = this.actualWidth - this.thumb.width - this._minimumPadding - this._maximumPadding;
				const xOffset:Number = location.x - this._touchStartX - this._minimumPadding;
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
			const wasDragging:Boolean = this.isDragging;
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

			const track:DisplayObject = DisplayObject(event.currentTarget);
			if(this._touchPointID >= 0)
			{
				var touch:Touch = event.getTouch(track, null, this._touchPointID);
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
				this.dispatchEventWith(FeathersEventType.BEGIN_INTERACTION);
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
			const page:Number = isNaN(this._page) ? this._step : this._page;
			if(this._direction == Slider.DIRECTION_VERTICAL)
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
			if(this._repeatTimer.currentCount < 5)
			{
				return;
			}
			this.currentRepeatAction();
		}
	}
}