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

	import starling.display.DisplayObject;
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
	 * Dispatched when the user starts interacting with the scroll bar's thumb,
	 * track, or buttons.
	 *
	 * @eventType feathers.events.FeathersEventType.BEGIN_INTERACTION
	 */
	[Event(name="beginInteraction",type="starling.events.Event")]

	/**
	 * Dispatched when the user stops interacting with the scroll bar's thumb,
	 * track, or buttons.
	 *
	 * @eventType feathers.events.FeathersEventType.END_INTERACTION
	 */
	[Event(name="endInteraction",type="starling.events.Event")]

	/**
	 * Select a value between a minimum and a maximum by dragging a thumb over
	 * a physical range or by using step buttons. This is a desktop-centric
	 * scroll bar with many skinnable parts. For mobile, the
	 * <code>SimpleScrollBar</code> is probably a better choice as it provides
	 * only the thumb to indicate position without all the extra chrome.
	 *
	 * <p>The following example updates a list to use scroll bars:</p>
	 *
	 * <listing version="3.0">
	 * list.horizontalScrollBarFactory = function():IScrollBar
	 * {
	 *     return new ScrollBar();
	 * };
	 * list.verticalScrollBarFactory = function():IScrollBar
	 * {
	 *     return new ScrollBar();
	 * };</listing>
	 *
	 * @see http://wiki.starling-framework.org/feathers/scroll-bar
	 * @see SimpleScrollBar
	 */
	public class ScrollBar extends FeathersControl implements IScrollBar
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
		 */
		protected static const INVALIDATION_FLAG_DECREMENT_BUTTON_FACTORY:String = "decrementButtonFactory";

		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_INCREMENT_BUTTON_FACTORY:String = "incrementButtonFactory";

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
		 * The scroll bar has only one track, that fills the full length of the
		 * scroll bar. In this layout mode, the "minimum" track is displayed and
		 * fills the entire length of the scroll bar. The maximum track will not
		 * exist.
		 *
		 * @see #trackLayoutMode
		 */
		public static const TRACK_LAYOUT_MODE_SINGLE:String = "single";

		/**
		 * The scroll bar has two tracks, stretching to fill each side of the
		 * scroll bar with the thumb in the middle. The tracks will be resized
		 * as the thumb moves. This layout mode is designed for scroll bars
		 * where the two sides of the track may be colored differently to show
		 * the value "filling up" as the thumb is dragged or to highlight the
		 * track when it is triggered to scroll by a page instead of a step.
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
		 * The default value added to the <code>nameList</code> of the minimum
		 * track.
		 *
		 * @see feathers.core.IFeathersControl#nameList
		 */
		public static const DEFAULT_CHILD_NAME_MINIMUM_TRACK:String = "feathers-scroll-bar-minimum-track";

		/**
		 * The default value added to the <code>nameList</code> of the maximum
		 * track.
		 *
		 * @see feathers.core.IFeathersControl#nameList
		 */
		public static const DEFAULT_CHILD_NAME_MAXIMUM_TRACK:String = "feathers-scroll-bar-maximum-track";

		/**
		 * The default value added to the <code>nameList</code> of the thumb.
		 *
		 * @see feathers.core.IFeathersControl#nameList
		 */
		public static const DEFAULT_CHILD_NAME_THUMB:String = "feathers-scroll-bar-thumb";

		/**
		 * The default value added to the <code>nameList</code> of the decrement
		 * button.
		 *
		 * @see feathers.core.IFeathersControl#nameList
		 */
		public static const DEFAULT_CHILD_NAME_DECREMENT_BUTTON:String = "feathers-scroll-bar-decrement-button";

		/**
		 * The default value added to the <code>nameList</code> of the increment
		 * button.
		 *
		 * @see feathers.core.IFeathersControl#nameList
		 */
		public static const DEFAULT_CHILD_NAME_INCREMENT_BUTTON:String = "feathers-scroll-bar-increment-button";

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
		 * @private
		 */
		protected static function defaultDecrementButtonFactory():Button
		{
			return new Button();
		}

		/**
		 * @private
		 */
		protected static function defaultIncrementButtonFactory():Button
		{
			return new Button();
		}

		/**
		 * Constructor.
		 */
		public function ScrollBar()
		{
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
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
		 * The value added to the <code>nameList</code> of the decrement button. This
		 * variable is <code>protected</code> so that sub-classes can customize
		 * the decrement button name in their constructors instead of using the default
		 * name defined by <code>DEFAULT_CHILD_NAME_DECREMENT_BUTTON</code>.
		 *
		 * <p>To customize the decrement button name without subclassing, see
		 * <code>customDecrementButtonName</code>.</p>
		 *
		 * @see #customDecrementButtonName
		 * @see feathers.core.IFeathersControl#nameList
		 */
		protected var decrementButtonName:String = DEFAULT_CHILD_NAME_DECREMENT_BUTTON;

		/**
		 * The value added to the <code>nameList</code> of the increment button. This
		 * variable is <code>protected</code> so that sub-classes can customize
		 * the increment button name in their constructors instead of using the default
		 * name defined by <code>DEFAULT_CHILD_NAME_INCREMENT_BUTTON</code>.
		 *
		 * <p>To customize the increment button name without subclassing, see
		 * <code>customIncrementButtonName</code>.</p>
		 *
		 * @see #customIncrementButtonName
		 * @see feathers.core.IFeathersControl#nameList
		 */
		protected var incrementButtonName:String = DEFAULT_CHILD_NAME_INCREMENT_BUTTON;

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
		 * The scroll bar's decrement button sub-component.
		 *
		 * <p>For internal use in subclasses.</p>
		 *
		 * @see #decrementButtonFactory
		 * @see #createDecrementButton()
		 */
		protected var decrementButton:Button;

		/**
		 * The scroll bar's increment button sub-component.
		 *
		 * <p>For internal use in subclasses.</p>
		 *
		 * @see #incrementButtonFactory
		 * @see #createIncrementButton()
		 */
		protected var incrementButton:Button;

		/**
		 * The scroll bar's thumb sub-component.
		 *
		 * <p>For internal use in subclasses.</p>
		 *
		 * @see #thumbFactory
		 * @see #createThumb()
		 */
		protected var thumb:Button;

		/**
		 * The scroll bar's minimum track sub-component.
		 *
		 * <p>For internal use in subclasses.</p>
		 *
		 * @see #minimumTrackFactory
		 * @see #createMinimumTrack()
		 */
		protected var minimumTrack:Button;

		/**
		 * The scroll bar's maximum track sub-component.
		 *
		 * <p>For internal use in subclasses.</p>
		 *
		 * @see #maximumTrackFactory
		 * @see #createMaximumTrack()
		 */
		protected var maximumTrack:Button;

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
		 * scrollBar.direction = ScrollBar.DIRECTION_VERTICAL;</listing>
		 *
		 * @default ScrollBar.DIRECTION_HORIZONTAL
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
			this.invalidate(INVALIDATION_FLAG_DECREMENT_BUTTON_FACTORY);
			this.invalidate(INVALIDATION_FLAG_INCREMENT_BUTTON_FACTORY);
			this.invalidate(INVALIDATION_FLAG_MINIMUM_TRACK_FACTORY);
			this.invalidate(INVALIDATION_FLAG_MAXIMUM_TRACK_FACTORY);
			this.invalidate(INVALIDATION_FLAG_THUMB_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _value:Number = 0;

		/**
		 * @inheritDoc
		 *
		 * @default 0
		 *
		 * @see #minimum
		 * @see #maximum
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
		 * The minimum space, in pixels, above the content, not
		 * including the track(s).
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
		 * The minimum space, in pixels, to the right of the content, not
		 * including the track(s).
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
		 * The minimum space, in pixels, below the content, not
		 * including the track(s).
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
		 * The minimum space, in pixels, to the left of the content, not
		 * including the track(s).
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
		protected var _trackLayoutMode:String = TRACK_LAYOUT_MODE_SINGLE;

		[Inspectable(type="String",enumeration="single,minMax")]
		/**
		 * Determines how the minimum and maximum track skins are positioned and
		 * sized.
		 *
		 * <p>In the following example, the scroll bar is given two tracks:</p>
		 *
		 * <listing version="3.0">
		 * scrollBar.trackLayoutMode = ScrollBar.TRACK_LAYOUT_MODE_MIN_MAX;</listing>
		 *
		 * @default ScrollBar.TRACK_LAYOUT_MODE_SINGLE
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
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
		}

		/**
		 * @private
		 */
		protected var _minimumTrackFactory:Function;

		/**
		 * A function used to generate the scroll bar's minimum track
		 * sub-component. The minimum track must be an instance of
		 * <code>Button</code>. This factory can be used to change properties on
		 * the minimum track when it is first created. For instance, if you
		 * are skinning Feathers components without a theme, you might use this
		 * factory to set skins and other styles on the minimum track.
		 *
		 * <p>The function should have the following signature:</p>
		 * <pre>function():Button</pre>
		 *
		 * <p>In the following example, a custom minimum track factory is passed
		 * to the scroll bar:</p>
		 *
		 * <listing version="3.0">
		 * scrollBar.minimumTrackFactory = function():Button
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
		 * A name to add to the scroll bar's minimum track sub-component. Typically
		 * used by a theme to provide different skins to different scroll bars.
		 *
		 * <p>In the following example, a custom minimum track name is passed
		 * to the scroll bar:</p>
		 *
		 * <listing version="3.0">
		 * scrollBar.customMinimumTrackName = "my-custom-minimum-track";</listing>
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
		 * A set of key/value pairs to be passed down to the scroll bar's
		 * minimum track sub-component. The minimum track is a
		 * <code>feathers.controls.Button</code> instance. that is created by
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
		 * <p>In the following example, the scroll bar's minimum track properties
		 * are updated:</p>
		 *
		 * <listing version="3.0">
		 * scrollBar.minimumTrackProperties.defaultSkin = new Image( upTexture );
		 * scrollBar.minimumTrackProperties.downSkin = new Image( downTexture );</listing>
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
				this._minimumTrackProperties.removeOnChangeCallback(minimumTrackProperties_onChange);
			}
			this._minimumTrackProperties = PropertyProxy(value);
			if(this._minimumTrackProperties)
			{
				this._minimumTrackProperties.addOnChangeCallback(minimumTrackProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _maximumTrackFactory:Function;

		/**
		 * A function used to generate the scroll bar's maximum track
		 * sub-component. The maximum track must be an instance of
		 * <code>Button</code>. This factory can be used to change properties on
		 * the maximum track when it is first created. For instance, if you
		 * are skinning Feathers components without a theme, you might use this
		 * factory to set skins and other styles on the maximum track.
		 *
		 * <p>The function should have the following signature:</p>
		 * <pre>function():Button</pre>
		 *
		 * <p>In the following example, a custom maximum track factory is passed
		 * to the scroll bar:</p>
		 *
		 * <listing version="3.0">
		 * scrollBar.maximumTrackFactory = function():Button
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
		 * A name to add to the scroll bar's maximum track sub-component. Typically
		 * used by a theme to provide different skins to different scroll bars.
		 *
		 * <p>In the following example, a custom maximum track name is passed
		 * to the scroll bar:</p>
		 *
		 * <listing version="3.0">
		 * scrollBar.customMaximumTrackName = "my-custom-maximum-track";</listing>
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
		 * A set of key/value pairs to be passed down to the scroll bar's
		 * maximum track sub-component. The maximum track is a
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
		 * <p>In the following example, the scroll bar's maximum track properties
		 * are updated:</p>
		 *
		 * <listing version="3.0">
		 * scrollBar.maximumTrackProperties.defaultSkin = new Image( upTexture );
		 * scrollBar.maximumTrackProperties.downSkin = new Image( downTexture );</listing>
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
				this._maximumTrackProperties.removeOnChangeCallback(maximumTrackProperties_onChange);
			}
			this._maximumTrackProperties = PropertyProxy(value);
			if(this._maximumTrackProperties)
			{
				this._maximumTrackProperties.addOnChangeCallback(maximumTrackProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

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
		protected var _decrementButtonFactory:Function;

		/**
		 * A function used to generate the scroll bar's decrement button
		 * sub-component. The decrement button must be an instance of
		 * <code>Button</code>. This factory can be used to change properties on
		 * the decrement button when it is first created. For instance, if you
		 * are skinning Feathers components without a theme, you might use this
		 * factory to set skins and other styles on the decrement button.
		 *
		 * <p>The function should have the following signature:</p>
		 * <pre>function():Button</pre>
		 *
		 * <p>In the following example, a custom decrement button factory is passed
		 * to the scroll bar:</p>
		 *
		 * <listing version="3.0">
		 * scrollBar.decrementButtonFactory = function():Button
		 * {
		 *     var button:Button = new Button();
		 *     button.defaultSkin = new Image( upTexture );
		 *     button.downSkin = new Image( downTexture );
		 *     return button;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.Button
		 * @see #decrementButtonProperties
		 */
		public function get decrementButtonFactory():Function
		{
			return this._decrementButtonFactory;
		}

		/**
		 * @private
		 */
		public function set decrementButtonFactory(value:Function):void
		{
			if(this._decrementButtonFactory == value)
			{
				return;
			}
			this._decrementButtonFactory = value;
			this.invalidate(INVALIDATION_FLAG_DECREMENT_BUTTON_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _customDecrementButtonName:String;

		/**
		 * A name to add to the scroll bar's decrement button sub-component. Typically
		 * used by a theme to provide different skins to different scroll bars.
		 *
		 * <p>In the following example, a custom decrement button name is passed
		 * to the scroll bar:</p>
		 *
		 * <listing version="3.0">
		 * scrollBar.customDecrementButtonName = "my-custom-decrement-button";</listing>
		 *
		 * <p>In your theme, you can target this sub-component name to provide
		 * different skins than the default style:</p>
		 *
		 * <listing version="3.0">
		 * setInitializerForClass( Button, customDecrementButtonInitializer, "my-custom-decrement-button");</listing>
		 *
		 * @default null
		 *
		 * @see #DEFAULT_CHILD_NAME_DECREMENT_BUTTON
		 * @see feathers.core.FeathersControl#nameList
		 * @see feathers.core.DisplayListWatcher
		 * @see #decrementButtonFactory
		 * @see #decrementButtonProperties
		 */
		public function get customDecrementButtonName():String
		{
			return this._customDecrementButtonName;
		}

		/**
		 * @private
		 */
		public function set customDecrementButtonName(value:String):void
		{
			if(this._customDecrementButtonName == value)
			{
				return;
			}
			this._customDecrementButtonName = value;
			this.invalidate(INVALIDATION_FLAG_DECREMENT_BUTTON_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _decrementButtonProperties:PropertyProxy;

		/**
		 * A set of key/value pairs to be passed down to the scroll bar's
		 * decrement button sub-component. The decrement button is a
		 * <code>feathers.controls.Button</code> instance that is created by
		 * <code>decrementButtonFactory</code>.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
		 * which is in a <code>Scroller</code> which is in a <code>List</code>,
		 * you can use the following syntax:</p>
		 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * <p>Setting properties in a <code>decrementButtonFactory</code>
		 * function instead of using <code>decrementButtonProperties</code> will
		 * result in better performance.</p>
		 *
		 * <p>In the following example, the scroll bar's decrement button properties
		 * are updated:</p>
		 *
		 * <listing version="3.0">
		 * scrollBar.decrementButtonProperties.defaultSkin = new Image( upTexture );
		 * scrollBar.decrementButtonProperties.downSkin = new Image( downTexture );</listing>
		 *
		 * @default null
		 *
		 * @see #decrementButtonFactory
		 * @see feathers.controls.Button
		 */
		public function get decrementButtonProperties():Object
		{
			if(!this._decrementButtonProperties)
			{
				this._decrementButtonProperties = new PropertyProxy(decrementButtonProperties_onChange);
			}
			return this._decrementButtonProperties;
		}

		/**
		 * @private
		 */
		public function set decrementButtonProperties(value:Object):void
		{
			if(this._decrementButtonProperties == value)
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
			if(this._decrementButtonProperties)
			{
				this._decrementButtonProperties.removeOnChangeCallback(decrementButtonProperties_onChange);
			}
			this._decrementButtonProperties = PropertyProxy(value);
			if(this._decrementButtonProperties)
			{
				this._decrementButtonProperties.addOnChangeCallback(decrementButtonProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _incrementButtonFactory:Function;

		/**
		 * A function used to generate the scroll bar's increment button
		 * sub-component. The increment button must be an instance of
		 * <code>Button</code>. This factory can be used to change properties on
		 * the increment button when it is first created. For instance, if you
		 * are skinning Feathers components without a theme, you might use this
		 * factory to set skins and other styles on the increment button.
		 *
		 * <p>The function should have the following signature:</p>
		 * <pre>function():Button</pre>
		 *
		 * <p>In the following example, a custom increment button factory is passed
		 * to the scroll bar:</p>
		 *
		 * <listing version="3.0">
		 * scrollBar.incrementButtonFactory = function():Button
		 * {
		 *     var button:Button = new Button();
		 *     button.defaultSkin = new Image( upTexture );
		 *     button.downSkin = new Image( downTexture );
		 *     return button;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.Button
		 * @see #incrementButtonProperties
		 */
		public function get incrementButtonFactory():Function
		{
			return this._incrementButtonFactory;
		}

		/**
		 * @private
		 */
		public function set incrementButtonFactory(value:Function):void
		{
			if(this._incrementButtonFactory == value)
			{
				return;
			}
			this._incrementButtonFactory = value;
			this.invalidate(INVALIDATION_FLAG_INCREMENT_BUTTON_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _customIncrementButtonName:String;

		/**
		 * A name to add to the scroll bar's increment button sub-component. Typically
		 * used by a theme to provide different skins to different scroll bars.
		 *
		 * <p>In the following example, a custom increment button name is passed
		 * to the scroll bar:</p>
		 *
		 * <listing version="3.0">
		 * scrollBar.customIncrementButtonName = "my-custom-increment-button";</listing>
		 *
		 * <p>In your theme, you can target this sub-component name to provide
		 * different skins than the default style:</p>
		 *
		 * <listing version="3.0">
		 * setInitializerForClass( Button, customIncrementInitializer, "my-custom-increment-button");</listing>
		 *
		 * @default null
		 *
		 * @see #DEFAULT_CHILD_NAME_INCREMENT_BUTTON
		 * @see feathers.core.FeathersControl#nameList
		 * @see feathers.core.DisplayListWatcher
		 * @see #incrementButtonFactory
		 * @see #incrementButtonProperties
		 */
		public function get customIncrementButtonName():String
		{
			return this._customIncrementButtonName;
		}

		/**
		 * @private
		 */
		public function set customIncrementButtonName(value:String):void
		{
			if(this._customIncrementButtonName == value)
			{
				return;
			}
			this._customIncrementButtonName = value;
			this.invalidate(INVALIDATION_FLAG_INCREMENT_BUTTON_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _incrementButtonProperties:PropertyProxy;

		/**
		 * A set of key/value pairs to be passed down to the scroll bar's
		 * increment button sub-component. The increment button is a
		 * <code>feathers.controls.Button</code> instance that is created by
		 * <code>incrementButtonFactory</code>.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
		 * which is in a <code>Scroller</code> which is in a <code>List</code>,
		 * you can use the following syntax:</p>
		 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * <p>Setting properties in a <code>incrementButtonFactory</code>
		 * function instead of using <code>incrementButtonProperties</code> will
		 * result in better performance.</p>
		 *
		 * <p>In the following example, the scroll bar's increment button properties
		 * are updated:</p>
		 *
		 * <listing version="3.0">
		 * scrollBar.incrementButtonProperties.defaultSkin = new Image( upTexture );
		 * scrollBar.incrementButtonProperties.downSkin = new Image( downTexture );</listing>
		 *
		 * @default null
		 *
		 * @see #incrementButtonFactory
		 * @see feathers.controls.Button
		 */
		public function get incrementButtonProperties():Object
		{
			if(!this._incrementButtonProperties)
			{
				this._incrementButtonProperties = new PropertyProxy(incrementButtonProperties_onChange);
			}
			return this._incrementButtonProperties;
		}

		/**
		 * @private
		 */
		public function set incrementButtonProperties(value:Object):void
		{
			if(this._incrementButtonProperties == value)
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
			if(this._incrementButtonProperties)
			{
				this._incrementButtonProperties.removeOnChangeCallback(incrementButtonProperties_onChange);
			}
			this._incrementButtonProperties = PropertyProxy(value);
			if(this._incrementButtonProperties)
			{
				this._incrementButtonProperties.addOnChangeCallback(incrementButtonProperties_onChange);
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
			const layoutInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_LAYOUT);
			const thumbFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_THUMB_FACTORY);
			const minimumTrackFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_MINIMUM_TRACK_FACTORY);
			const maximumTrackFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_MAXIMUM_TRACK_FACTORY);
			const incrementButtonFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_INCREMENT_BUTTON_FACTORY);
			const decrementButtonFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DECREMENT_BUTTON_FACTORY);

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
			if(decrementButtonFactoryInvalid)
			{
				this.createDecrementButton();
			}
			if(incrementButtonFactoryInvalid)
			{
				this.createIncrementButton();
			}

			if(thumbFactoryInvalid || stylesInvalid)
			{
				this.refreshThumbStyles();
			}
			if(minimumTrackFactoryInvalid || stylesInvalid)
			{
				this.refreshMinimumTrackStyles();
			}
			if((maximumTrackFactoryInvalid || stylesInvalid || layoutInvalid) && this.maximumTrack)
			{
				this.refreshMaximumTrackStyles();
			}
			if(decrementButtonFactoryInvalid || stylesInvalid)
			{
				this.refreshDecrementButtonStyles();
			}
			if(incrementButtonFactoryInvalid || stylesInvalid)
			{
				this.refreshIncrementButtonStyles();
			}

			const isEnabled:Boolean = this._isEnabled && this._maximum > this._minimum;
			if(dataInvalid || stateInvalid || thumbFactoryInvalid)
			{
				this.thumb.isEnabled = isEnabled;
			}
			if(dataInvalid || stateInvalid || minimumTrackFactoryInvalid)
			{
				this.minimumTrack.isEnabled = isEnabled;
			}
			if((dataInvalid || stateInvalid || maximumTrackFactoryInvalid || layoutInvalid) && this.maximumTrack)
			{
				this.maximumTrack.isEnabled = isEnabled;
			}
			if(dataInvalid || stateInvalid || decrementButtonFactoryInvalid)
			{
				this.decrementButton.isEnabled = isEnabled;
			}
			if(dataInvalid || stateInvalid || incrementButtonFactoryInvalid)
			{
				this.incrementButton.isEnabled = isEnabled;
			}

			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

			this.layout();
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
		 * <p>Calls <code>setSizeInternal()</code> to set up the
		 * <code>actualWidth</code> and <code>actualHeight</code> member
		 * variables used for layout.</p>
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
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
			if(isNaN(this.thumbOriginalWidth) || isNaN(this.thumbOriginalHeight))
			{
				this.thumb.validate();
				this.thumbOriginalWidth = this.thumb.width;
				this.thumbOriginalHeight = this.thumb.height;
			}
			this.decrementButton.validate();
			this.incrementButton.validate();

			const needsWidth:Boolean = isNaN(this.explicitWidth);
			const needsHeight:Boolean = isNaN(this.explicitHeight);
			if(!needsWidth && !needsHeight)
			{
				return false;
			}

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
		 * Creates and adds the <code>thumb</code> sub-component and
		 * removes the old instance, if one exists.
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 *
		 * @see #thumb
		 * @see #thumbFactory
		 * @see #customThumbName
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
			this.thumb.isFocusEnabled = false;
			this.thumb.addEventListener(TouchEvent.TOUCH, thumb_touchHandler);
			this.addChild(this.thumb);
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
		 * @see #customMinimumTrackName
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
			this.minimumTrack.isFocusEnabled = false;
			this.minimumTrack.addEventListener(TouchEvent.TOUCH, track_touchHandler);
			this.addChildAt(this.minimumTrack, 0);
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
		 * @see #customMaximumTrackName
		 */
		protected function createMaximumTrack():void
		{
			if(this._trackLayoutMode == TRACK_LAYOUT_MODE_MIN_MAX)
			{
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
				this.maximumTrack.isFocusEnabled = false;
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
		 * Creates and adds the <code>decrementButton</code> sub-component and
		 * removes the old instance, if one exists.
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 *
		 * @see #decrementButton
		 * @see #decrementButtonFactory
		 * @see #customDecremenButtonName
		 */
		protected function createDecrementButton():void
		{
			if(this.decrementButton)
			{
				this.decrementButton.removeFromParent(true);
				this.decrementButton = null;
			}

			const factory:Function = this._decrementButtonFactory != null ? this._decrementButtonFactory : defaultDecrementButtonFactory;
			const decrementButtonName:String = this._customDecrementButtonName != null ? this._customDecrementButtonName : this.decrementButtonName;
			this.decrementButton = Button(factory());
			this.decrementButton.nameList.add(decrementButtonName);
			this.decrementButton.keepDownStateOnRollOut = true;
			this.decrementButton.isFocusEnabled = false;
			this.decrementButton.addEventListener(TouchEvent.TOUCH, decrementButton_touchHandler);
			this.addChild(this.decrementButton);
		}

		/**
		 * Creates and adds the <code>incrementButton</code> sub-component and
		 * removes the old instance, if one exists.
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 *
		 * @see #incrementButton
		 * @see #incrementButtonFactory
		 * @see #customIncrementButtonName
		 */
		protected function createIncrementButton():void
		{
			if(this.incrementButton)
			{
				this.incrementButton.removeFromParent(true);
				this.incrementButton = null;
			}

			const factory:Function = this._incrementButtonFactory != null ? this._incrementButtonFactory : defaultIncrementButtonFactory;
			const incrementButtonName:String = this._customIncrementButtonName != null ? this._customIncrementButtonName : this.incrementButtonName;
			this.incrementButton = Button(factory());
			this.incrementButton.nameList.add(incrementButtonName);
			this.incrementButton.keepDownStateOnRollOut = true;
			this.incrementButton.isFocusEnabled = false;
			this.incrementButton.addEventListener(TouchEvent.TOUCH, incrementButton_touchHandler);
			this.addChild(this.incrementButton);
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
		protected function refreshDecrementButtonStyles():void
		{
			for(var propertyName:String in this._decrementButtonProperties)
			{
				if(this.decrementButton.hasOwnProperty(propertyName))
				{
					var propertyValue:Object = this._decrementButtonProperties[propertyName];
					this.decrementButton[propertyName] = propertyValue;
				}
			}
		}

		/**
		 * @private
		 */
		protected function refreshIncrementButtonStyles():void
		{
			for(var propertyName:String in this._incrementButtonProperties)
			{
				if(this.incrementButton.hasOwnProperty(propertyName))
				{
					var propertyValue:Object = this._incrementButtonProperties[propertyName];
					this.incrementButton[propertyName] = propertyValue;
				}
			}
		}

		/**
		 * @private
		 */
		protected function layout():void
		{
			this.layoutStepButtons();
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
		protected function layoutStepButtons():void
		{
			if(this._direction == DIRECTION_VERTICAL)
			{
				this.decrementButton.x = (this.actualWidth - this.decrementButton.width) / 2;
				this.decrementButton.y = 0;
				this.incrementButton.x = (this.actualWidth - this.incrementButton.width) / 2;
				this.incrementButton.y = this.actualHeight - this.incrementButton.height;
			}
			else
			{
				this.decrementButton.x = 0;
				this.decrementButton.y = (this.actualHeight - this.decrementButton.height) / 2;
				this.incrementButton.x = this.actualWidth - this.incrementButton.width;
				this.incrementButton.y = (this.actualHeight - this.incrementButton.height) / 2;
			}
		}

		/**
		 * @private
		 */
		protected function layoutThumb():void
		{
			const range:Number = this._maximum - this._minimum;
			this.thumb.visible = range > 0;
			if(!this.thumb.visible)
			{
				return;
			}

			//this will auto-size the thumb, if needed
			this.thumb.validate();

			var contentWidth:Number = this.actualWidth - this._paddingLeft - this._paddingRight;
			var contentHeight:Number = this.actualHeight - this._paddingTop - this._paddingBottom;
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
				contentHeight -= (this.decrementButton.height + this.incrementButton.height);
				const thumbMinHeight:Number = this.thumb.minHeight > 0 ? this.thumb.minHeight : this.thumbOriginalHeight;
				this.thumb.width = this.thumbOriginalWidth;
				this.thumb.height = Math.max(thumbMinHeight, contentHeight * adjustedPageStep / range);
				const trackScrollableHeight:Number = contentHeight - this.thumb.height;
				this.thumb.x = this._paddingLeft + (this.actualWidth - this._paddingLeft - this._paddingRight - this.thumb.width) / 2;
				this.thumb.y = this.decrementButton.height + this._paddingTop + Math.max(0, Math.min(trackScrollableHeight, trackScrollableHeight * (this._value - this._minimum) / range));
			}
			else //horizontal
			{
				contentWidth -= (this.decrementButton.width + this.decrementButton.width);
				const thumbMinWidth:Number = this.thumb.minWidth > 0 ? this.thumb.minWidth : this.thumbOriginalWidth;
				this.thumb.width = Math.max(thumbMinWidth, contentWidth * adjustedPageStep / range);
				this.thumb.height = this.thumbOriginalHeight;
				const trackScrollableWidth:Number = contentWidth - this.thumb.width;
				this.thumb.x = this.decrementButton.width + this._paddingLeft + Math.max(0, Math.min(trackScrollableWidth, trackScrollableWidth * (this._value - this._minimum) / range));
				this.thumb.y = this._paddingTop + (this.actualHeight - this._paddingTop - this._paddingBottom - this.thumb.height) / 2;
			}
		}

		/**
		 * @private
		 */
		protected function layoutTrackWithMinMax():void
		{
			if(this._direction == DIRECTION_VERTICAL)
			{
				this.minimumTrack.x = 0;
				this.minimumTrack.y = 0;
				this.minimumTrack.width = this.actualWidth;
				this.minimumTrack.height = (this.thumb.y + this.thumb.height / 2) - this.minimumTrack.y;

				this.maximumTrack.x = 0;
				this.maximumTrack.y = this.minimumTrack.y + this.minimumTrack.height;
				this.maximumTrack.width = this.actualWidth;
				this.maximumTrack.height = this.actualHeight - this.maximumTrack.y;
			}
			else //horizontal
			{
				this.minimumTrack.x = 0;
				this.minimumTrack.y = 0;
				this.minimumTrack.width = (this.thumb.x + this.thumb.width / 2) - this.minimumTrack.x;
				this.minimumTrack.height = this.actualHeight;

				this.maximumTrack.x = this.minimumTrack.x + this.minimumTrack.width;
				this.maximumTrack.y = 0;
				this.maximumTrack.width = this.actualWidth - this.maximumTrack.x;
				this.maximumTrack.height = this.actualHeight;
			}

			//final validation to avoid juggler next frame issues
			this.minimumTrack.validate();
			this.maximumTrack.validate();
		}

		/**
		 * @private
		 */
		protected function layoutTrackWithSingle():void
		{
			if(this._direction == DIRECTION_VERTICAL)
			{
				this.minimumTrack.x = 0;
				this.minimumTrack.y = 0;
				this.minimumTrack.width = this.actualWidth;
				this.minimumTrack.height = this.actualHeight - this.minimumTrack.y;
			}
			else //horizontal
			{
				this.minimumTrack.x = 0;
				this.minimumTrack.y = 0;
				this.minimumTrack.width = this.actualWidth - this.minimumTrack.x;
				this.minimumTrack.height = this.actualHeight;
			}

			//final validation to avoid juggler next frame issues
			this.minimumTrack.validate();
		}

		/**
		 * @private
		 */
		protected function locationToValue(location:Point):Number
		{
			var percentage:Number;
			if(this._direction == DIRECTION_VERTICAL)
			{
				const trackScrollableHeight:Number = this.actualHeight - this.thumb.height - this.decrementButton.height - this.incrementButton.height - this._paddingTop - this._paddingBottom;
				const yOffset:Number = location.y - this._touchStartY - this._paddingTop;
				const yPosition:Number = Math.min(Math.max(0, this._thumbStartY + yOffset - this.decrementButton.height), trackScrollableHeight);
				percentage = yPosition / trackScrollableHeight;
			}
			else //horizontal
			{
				const trackScrollableWidth:Number = this.actualWidth - this.thumb.width - this.decrementButton.width - this.incrementButton.width - this._paddingLeft - this._paddingRight;
				const xOffset:Number = location.x - this._touchStartX - this._paddingLeft;
				const xPosition:Number = Math.min(Math.max(0, this._thumbStartX + xOffset - this.decrementButton.width), trackScrollableWidth);
				percentage = xPosition / trackScrollableWidth;
			}

			return this._minimum + percentage * (this._maximum - this._minimum);
		}

		/**
		 * @private
		 */
		protected function decrement():void
		{
			this.value -= this._step;
		}

		/**
		 * @private
		 */
		protected function increment():void
		{
			this.value += this._step;
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
		protected function decrementButtonProperties_onChange(proxy:PropertyProxy, name:Object):void
		{
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected function incrementButtonProperties_onChange(proxy:PropertyProxy, name:Object):void
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

			const track:DisplayObject = DisplayObject(event.currentTarget);
			if(this._touchPointID >= 0)
			{
				var touch:Touch = event.getTouch(track, TouchPhase.ENDED, this._touchPointID);
				if(!touch)
				{
					return;
				}
				this._touchPointID = -1;
				this._repeatTimer.stop();
				this.dispatchEventWith(FeathersEventType.END_INTERACTION);
			}
			else
			{
				touch = event.getTouch(track, TouchPhase.BEGAN);
				if(!touch)
				{
					return;
				}
				this._touchPointID = touch.id;
				this.dispatchEventWith(FeathersEventType.BEGIN_INTERACTION);
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
		protected function decrementButton_touchHandler(event:TouchEvent):void
		{
			if(!this._isEnabled)
			{
				this._touchPointID = -1;
				return;
			}

			if(this._touchPointID >= 0)
			{
				var touch:Touch = event.getTouch(this.decrementButton, TouchPhase.ENDED, this._touchPointID);
				if(!touch)
				{
					return;
				}
				this._touchPointID = -1;
				this._repeatTimer.stop();
				this.dispatchEventWith(FeathersEventType.END_INTERACTION);
			}
			else //if we get here, we don't have a saved touch ID yet
			{
				touch = event.getTouch(this.decrementButton, TouchPhase.BEGAN);
				if(!touch)
				{
					return;
				}
				this._touchPointID = touch.id;
				this.dispatchEventWith(FeathersEventType.BEGIN_INTERACTION);
				this.decrement();
				this.startRepeatTimer(this.decrement);
			}
		}

		/**
		 * @private
		 */
		protected function incrementButton_touchHandler(event:TouchEvent):void
		{
			if(!this._isEnabled)
			{
				this._touchPointID = -1;
				return;
			}

			if(this._touchPointID >= 0)
			{
				var touch:Touch = event.getTouch(this.incrementButton, TouchPhase.ENDED, this._touchPointID);
				if(!touch)
				{
					return;
				}
				this._touchPointID = -1;
				this._repeatTimer.stop();
				this.dispatchEventWith(FeathersEventType.END_INTERACTION);
			}
			else //if we get here, we don't have a saved touch ID yet
			{
				touch = event.getTouch(this.incrementButton, TouchPhase.BEGAN);
				if(!touch)
				{
					return;
				}
				this._touchPointID = touch.id;
				this.dispatchEventWith(FeathersEventType.BEGIN_INTERACTION);
				this.increment();
				this.startRepeatTimer(this.increment);
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
