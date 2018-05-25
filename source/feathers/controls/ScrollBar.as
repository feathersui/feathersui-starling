/*
Feathers
Copyright 2012-2018 Bowler Hat LLC. All Rights Reserved.

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
	import feathers.events.FeathersEventType;
	import feathers.layout.Direction;
	import feathers.skins.IStyleProvider;
	import feathers.utils.math.clamp;
	import feathers.utils.math.roundDownToNearest;
	import feathers.utils.math.roundToNearest;
	import feathers.utils.math.roundUpToNearest;

	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;

	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.Pool;

	/**
	 * A style name to add to the scroll bar's decrement button
	 * sub-component. Typically used by a theme to provide different styles
	 * to different scroll bars.
	 *
	 * <p>In the following example, a custom decrement button style name is
	 * passed to the scroll bar:</p>
	 *
	 * <listing version="3.0">
	 * scrollBar.customDecrementButtonStyleName = "my-custom-decrement-button";</listing>
	 *
	 * <p>In your theme, you can target this sub-component style name to
	 * provide different skins than the default style:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( Button ).setFunctionForStyleName( "my-custom-decrement-button", setCustomDecrementButtonStyles );</listing>
	 *
	 * @default null
	 *
	 * @see #DEFAULT_CHILD_STYLE_NAME_DECREMENT_BUTTON
	 * @see feathers.core.FeathersControl#styleNameList
	 * @see #decrementButtonFactory
	 */
	[Style(name="customDecrementButtonStyleName",type="String")]

	/**
	 * A style name to add to the scroll bar's increment button
	 * sub-component. Typically used by a theme to provide different styles
	 * to different scroll bars.
	 *
	 * <p>In the following example, a custom increment button style name is
	 * passed to the scroll bar:</p>
	 *
	 * <listing version="3.0">
	 * scrollBar.customIncrementButtonStyleName = "my-custom-increment-button";</listing>
	 *
	 * <p>In your theme, you can target this sub-component style name to
	 * provide different styles than the default:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( Button ).setFunctionForStyleName( "my-custom-increment-button", setCustomIncrementButtonStyles );</listing>
	 *
	 * @default null
	 *
	 * @see #DEFAULT_CHILD_STYLE_NAME_INCREMENT_BUTTON
	 * @see feathers.core.FeathersControl#styleNameList
	 * @see #incrementButtonFactory
	 */
	[Style(name="customIncrementButtonStyleName",type="String")]

	/**
	 * A style name to add to the scroll bar's minimum track sub-component.
	 * Typically used by a theme to provide different styles to different
	 * scroll bars.
	 *
	 * <p>In the following example, a custom minimum track style name is
	 * passed to the scroll bar:</p>
	 *
	 * <listing version="3.0">
	 * scrollBar.customMinimumTrackStyleName = "my-custom-minimum-track";</listing>
	 *
	 * <p>In your theme, you can target this sub-component style name to provide
	 * different styles than the default:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( Button ).setFunctionForStyleName( "my-custom-minimum-track", setCustomMinimumTrackStyles );</listing>
	 *
	 * @default null
	 *
	 * @see #DEFAULT_CHILD_STYLE_NAME_MINIMUM_TRACK
	 * @see feathers.core.FeathersControl#styleNameList
	 * @see #minimumTrackFactory
	 */
	[Style(name="customMinimumTrackStyleName",type="String")]

	/**
	 * A style name to add to the scroll bar's maximum track sub-component.
	 * Typically used by a theme to provide different styles to different
	 * scroll bars.
	 *
	 * <p>In the following example, a custom maximum track style name is
	 * passed to the scroll bar:</p>
	 *
	 * <listing version="3.0">
	 * scrollBar.customMaximumTrackStyleName = "my-custom-maximum-track";</listing>
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
	 */
	[Style(name="customMaximumTrackStyleName",type="String")]

	/**
	 * A style name to add to the scroll bar's thumb sub-component.
	 * Typically used by a theme to provide different styles to different
	 * scroll bars.
	 *
	 * <p>In the following example, a custom thumb style name is passed
	 * to the scroll bar:</p>
	 *
	 * <listing version="3.0">
	 * scrollBar.customThumbStyleName = "my-custom-thumb";</listing>
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
	 */
	[Style(name="customThumbStyleName",type="String")]

	/**
	 * Determines if the scroll bar's thumb can be dragged horizontally or
	 * vertically. When this value changes, the scroll bar's width and
	 * height values do not change automatically.
	 *
	 * <p>Note: When using a <code>SimpleScrollBar</code> with a scrolling
	 * container, the container will automatically set the correct
	 * <code>direction</code> value. Generally, you should not need to set this
	 * style manually.</p>
	 *
	 * <p>In the following example, the direction is changed to vertical:</p>
	 *
	 * <listing version="3.0">
	 * scrollBar.direction = Direction.VERTICAL;</listing>
	 * 
	 * <p><strong>Note:</strong> The <code>Direction.NONE</code>
	 * constant is not supported.</p>
	 *
	 * @default feathers.layout.Direction.HORIZONTAL
	 *
	 * @see feathers.layout.Direction#HORIZONTAL
	 * @see feathers.layout.Direction#VERTICAL
	 */
	[Style(name="direction",type="String")]

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
	 * @see #style:paddingTop
	 * @see #style:paddingRight
	 * @see #style:paddingBottom
	 * @see #style:paddingLeft
	 */
	[Style(name="padding",type="Number")]

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
	 *
	 * @see #style:padding
	 */
	[Style(name="paddingTop",type="Number")]

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
	 *
	 * @see #style:padding
	 */
	[Style(name="paddingRight",type="Number")]

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
	 *
	 * @see #style:padding
	 */
	[Style(name="paddingBottom",type="Number")]

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
	 *
	 * @see #style:padding
	 */
	[Style(name="paddingLeft",type="Number")]

	/**
	 * Determines how the minimum and maximum track skins are positioned and
	 * sized.
	 *
	 * <p>In the following example, the scroll bar is given two tracks:</p>
	 *
	 * <listing version="3.0">
	 * scrollBar.trackLayoutMode = TrackLayoutMode.SPLIT;</listing>
	 *
	 * @default feathers.controls.TrackLayoutMode.SINGLE
	 *
	 * @see feathers.controls.TrackLayoutMode#SINGLE
	 * @see feathers.controls.TrackLayoutMode#SPLIT
	 */
	[Style(name="trackLayoutMode",type="String")]

	/**
	 * Dispatched when the scroll bar's value changes.
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
	 * Dispatched when the user starts interacting with the scroll bar's thumb,
	 * track, or buttons.
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
	 * Dispatched when the user stops interacting with the scroll bar's thumb,
	 * track, or buttons.
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
	 * @see ../../../help/scroll-bar.html How to use the Feathers ScrollBar component
	 * @see feathers.controls.SimpleScrollBar
	 *
	 * @productversion Feathers 1.0.0
	 */
	public class ScrollBar extends FeathersControl implements IDirectionalScrollBar
	{
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

		[Deprecated(replacement="feathers.layout.Direction.HORIZONTAL",since="3.0.0")]
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

		[Deprecated(replacement="feathers.layout.Direction.VERTICAL",since="3.0.0")]
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

		[Deprecated(replacement="feathers.controls.TrackLayoutMode.SINGLE",since="3.0.0")]
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

		[Deprecated(replacement="feathers.controls.TrackLayoutMode.SPLIT",since="3.0.0")]
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
		 * The default value added to the <code>styleNameList</code> of the minimum
		 * track.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_MINIMUM_TRACK:String = "feathers-scroll-bar-minimum-track";

		/**
		 * The default value added to the <code>styleNameList</code> of the maximum
		 * track.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_MAXIMUM_TRACK:String = "feathers-scroll-bar-maximum-track";

		/**
		 * The default value added to the <code>styleNameList</code> of the thumb.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_THUMB:String = "feathers-scroll-bar-thumb";

		/**
		 * The default value added to the <code>styleNameList</code> of the decrement
		 * button.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_DECREMENT_BUTTON:String = "feathers-scroll-bar-decrement-button";

		/**
		 * The default value added to the <code>styleNameList</code> of the increment
		 * button.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_INCREMENT_BUTTON:String = "feathers-scroll-bar-increment-button";

		/**
		 * The default <code>IStyleProvider</code> for all <code>ScrollBar</code>
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
		 * @private
		 */
		protected static function defaultDecrementButtonFactory():BasicButton
		{
			return new Button();
		}

		/**
		 * @private
		 */
		protected static function defaultIncrementButtonFactory():BasicButton
		{
			return new Button();
		}

		/**
		 * Constructor.
		 */
		public function ScrollBar()
		{
			super();
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
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
		 * @see #style:customMinimumTrackStyleName
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
		 * @see #style:customMaximumTrackStyleName
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
		 * @see #style:customThumbStyleName
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var thumbStyleName:String = DEFAULT_CHILD_STYLE_NAME_THUMB;

		/**
		 * The value added to the <code>styleNameList</code> of the decrement
		 * button. This variable is <code>protected</code> so that sub-classes
		 * can customize the decrement button style name in their constructors
		 * instead of using the default style name defined by
		 * <code>DEFAULT_CHILD_STYLE_NAME_DECREMENT_BUTTON</code>.
		 *
		 * <p>To customize the decrement button style name without subclassing,
		 * see <code>customDecrementButtonStyleName</code>.</p>
		 *
		 * @see #style:customDecrementButtonStyleName
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var decrementButtonStyleName:String = DEFAULT_CHILD_STYLE_NAME_DECREMENT_BUTTON;

		/**
		 * The value added to the <code>styleNameList</code> of the increment
		 * button. This variable is <code>protected</code> so that sub-classes
		 * can customize the increment button style name in their constructors
		 * instead of using the default style name defined by
		 * <code>DEFAULT_CHILD_STYLE_NAME_INCREMENT_BUTTON</code>.
		 *
		 * <p>To customize the increment button style name without subclassing,
		 * see <code>customIncrementButtonName</code>.</p>
		 *
		 * @see #style:customIncrementButtonStyleName
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var incrementButtonStyleName:String = DEFAULT_CHILD_STYLE_NAME_INCREMENT_BUTTON;

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
		protected var decrementButton:BasicButton;

		/**
		 * The scroll bar's increment button sub-component.
		 *
		 * <p>For internal use in subclasses.</p>
		 *
		 * @see #incrementButtonFactory
		 * @see #createIncrementButton()
		 */
		protected var incrementButton:BasicButton;

		/**
		 * The scroll bar's thumb sub-component.
		 *
		 * <p>For internal use in subclasses.</p>
		 *
		 * @see #thumbFactory
		 * @see #createThumb()
		 */
		protected var thumb:DisplayObject;

		/**
		 * The scroll bar's minimum track sub-component.
		 *
		 * <p>For internal use in subclasses.</p>
		 *
		 * @see #minimumTrackFactory
		 * @see #createMinimumTrack()
		 */
		protected var minimumTrack:DisplayObject;

		/**
		 * The scroll bar's maximum track sub-component.
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
			return ScrollBar.globalStyleProvider;
		}

		/**
		 * @private
		 */
		protected var _direction:String = Direction.HORIZONTAL;

		[Inspectable(type="String",enumeration="horizontal,vertical")]
		/**
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._direction === value)
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
		 * @private
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
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
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
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
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
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
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
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
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
		protected var _trackLayoutMode:String = TrackLayoutMode.SINGLE;

		[Inspectable(type="String",enumeration="single,split")]
		/**
		 * @private
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
			if(value === "minMax")
			{
				value = TrackLayoutMode.SPLIT;
			}
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._trackLayoutMode === value)
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
		 * <code>BasicButton</code>. This factory can be used to change
		 * properties on the minimum track when it is first created. For
		 * instance, if you are skinning Feathers components without a theme,
		 * you might use this factory to set skins and other styles on the
		 * minimum track.
		 *
		 * <p>The function should have the following signature:</p>
		 * <pre>function():BasicButton</pre>
		 *
		 * <p>In the following example, a custom minimum track factory is passed
		 * to the scroll bar:</p>
		 *
		 * <listing version="3.0">
		 * scrollBar.minimumTrackFactory = function():BasicButton
		 * {
		 *     var track:BasicButton = new BasicButton();
		 *     track.defaultSkin = new Image( upTexture );
		 *     track.downSkin = new Image( downTexture );
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
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._customMinimumTrackStyleName === value)
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
		 * An object that stores properties for the scroll bar's "minimum"
		 * track, and the properties will be passed down to the "minimum" track when
		 * the scroll bar validates. For a list of available properties, refer to
		 * <a href="Button.html"><code>feathers.controls.BasicButton</code></a>.
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
		 * @see feathers.controls.BasicButton
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
				var newValue:PropertyProxy = new PropertyProxy();
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
		 * <code>BasicButton</code>. This factory can be used to change
		 * properties on the maximum track when it is first created. For
		 * instance, if you are skinning Feathers components without a theme,
		 * you might use this factory to set skins and other styles on the
		 * maximum track.
		 *
		 * <p>The function should have the following signature:</p>
		 * <pre>function():BasicButton</pre>
		 *
		 * <p>In the following example, a custom maximum track factory is passed
		 * to the scroll bar:</p>
		 *
		 * <listing version="3.0">
		 * scrollBar.maximumTrackFactory = function():BasicButton
		 * {
		 *     var track:BasicButton = new BasicButton();
		 *     track.defaultSkin = new Image( upTexture );
		 *     track.downSkin = new Image( downTexture );
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
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._customMaximumTrackStyleName === value)
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
		 * An object that stores properties for the scroll bar's "maximum"
		 * track, and the properties will be passed down to the "maximum" track when
		 * the scroll bar validates. For a list of available properties, refer to
		 * <a href="Button.html"><code>feathers.controls.BasicButton</code></a>.
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
		 * @see feathers.controls.BasicButton
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
				var newValue:PropertyProxy = new PropertyProxy();
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
		 * <pre>function():BasicButton</pre>
		 *
		 * <p>In the following example, a custom thumb factory is passed
		 * to the scroll bar:</p>
		 *
		 * <listing version="3.0">
		 * scrollBar.thumbFactory = function():BasicButton
		 * {
		 *     var thumb:BasicButton = new BasicButton();
		 *     thumb.defaultSkin = new Image( upTexture );
		 *     thumb.downSkin = new Image( downTexture );
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
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._customThumbStyleName === value)
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
		 * An object that stores properties for the scroll bar's thumb, and the
		 * properties will be passed down to the thumb when the scroll bar
		 * validates. For a list of available properties, refer to
		 * <a href="Button.html"><code>feathers.controls.BasicButton</code></a>.
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
		 * @see feathers.controls.BasicButton
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
				var newValue:PropertyProxy = new PropertyProxy();
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
		 * <code>BasicButton</code>. This factory can be used to change
		 * properties on the decrement button when it is first created. For
		 * instance, if you are skinning Feathers components without a theme,
		 * you might use this factory to set skins and other styles on the
		 * decrement button.
		 *
		 * <p>The function should have the following signature:</p>
		 * <pre>function():BasicButton</pre>
		 *
		 * <p>In the following example, a custom decrement button factory is passed
		 * to the scroll bar:</p>
		 *
		 * <listing version="3.0">
		 * scrollBar.decrementButtonFactory = function():BasicButton
		 * {
		 *     var button:BasicButton = new BasicButton();
		 *     button.defaultSkin = new Image( upTexture );
		 *     button.downSkin = new Image( downTexture );
		 *     return button;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.BasicButton
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
		protected var _customDecrementButtonStyleName:String;

		/**
		 * @private
		 */
		public function get customDecrementButtonStyleName():String
		{
			return this._customDecrementButtonStyleName;
		}

		/**
		 * @private
		 */
		public function set customDecrementButtonStyleName(value:String):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._customDecrementButtonStyleName === value)
			{
				return;
			}
			this._customDecrementButtonStyleName = value;
			this.invalidate(INVALIDATION_FLAG_DECREMENT_BUTTON_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _decrementButtonProperties:PropertyProxy;

		/**
		 * An object that stores properties for the scroll bar's decrement
		 * button, and the properties will be passed down to the decrement
		 * button when the scroll bar validates. For a list of available
		 * properties, refer to
		 * <a href="Button.html"><code>feathers.controls.BasicButton</code></a>.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
		 * which is in a <code>List</code>, you can use the following syntax:</p>
		 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
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
		 * @see feathers.controls.BasicButton
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
				var newValue:PropertyProxy = new PropertyProxy();
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
		 * <code>BasicButton</code>. This factory can be used to change
		 * properties on the increment button when it is first created. For
		 * instance, if you are skinning Feathers components without a theme,
		 * you might use this factory to set skins and other styles on the
		 * increment button.
		 *
		 * <p>The function should have the following signature:</p>
		 * <pre>function():BasicButton</pre>
		 *
		 * <p>In the following example, a custom increment button factory is passed
		 * to the scroll bar:</p>
		 *
		 * <listing version="3.0">
		 * scrollBar.incrementButtonFactory = function():BasicButton
		 * {
		 *     var button:BasicButton = new BasicButton();
		 *     button.defaultSkin = new Image( upTexture );
		 *     button.downSkin = new Image( downTexture );
		 *     return button;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.BasicButton
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
		protected var _customIncrementButtonStyleName:String;

		/**
		 * @private
		 */
		public function get customIncrementButtonStyleName():String
		{
			return this._customIncrementButtonStyleName;
		}

		/**
		 * @private
		 */
		public function set customIncrementButtonStyleName(value:String):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._customIncrementButtonStyleName === value)
			{
				return;
			}
			this._customIncrementButtonStyleName = value;
			this.invalidate(INVALIDATION_FLAG_INCREMENT_BUTTON_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _incrementButtonProperties:PropertyProxy;

		/**
		 * An object that stores properties for the scroll bar's increment
		 * button, and the properties will be passed down to the increment
		 * button when the scroll bar validates. For a list of available
		 * properties, refer to
		 * <a href="Button.html"><code>feathers.controls.BasicButton</code></a>.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
		 * which is in a <code>List</code>, you can use the following syntax:</p>
		 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
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
		 * @see feathers.controls.BasicButton
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
				var newValue:PropertyProxy = new PropertyProxy();
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
		protected var _pageStartValue:Number;

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
			var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			var stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			var stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			var layoutInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_LAYOUT);
			var thumbFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_THUMB_FACTORY);
			var minimumTrackFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_MINIMUM_TRACK_FACTORY);
			var maximumTrackFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_MAXIMUM_TRACK_FACTORY);
			var incrementButtonFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_INCREMENT_BUTTON_FACTORY);
			var decrementButtonFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DECREMENT_BUTTON_FACTORY);

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

			if(dataInvalid || stateInvalid || thumbFactoryInvalid ||
				minimumTrackFactoryInvalid || maximumTrackFactoryInvalid ||
				decrementButtonFactoryInvalid || incrementButtonFactoryInvalid)
			{
				this.refreshEnabled();
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
			if(this.decrementButton is IValidating)
			{
				IValidating(this.decrementButton).validate();
			}
			if(this.incrementButton is IValidating)
			{
				IValidating(this.incrementButton).validate();
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
					newWidth += this.maximumTrack.width;
				}
				newWidth += this.decrementButton.width + this.incrementButton.width;
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
				if(this.decrementButton.height > newHeight)
				{
					newHeight = this.decrementButton.height;
				}
				if(this.incrementButton.height > newHeight)
				{
					newHeight = this.incrementButton.height;
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
						newMinWidth += measureMaxTrack.minWidth;
					}
					else if(this.maximumTrack.width > newMinWidth)
					{
						newMinWidth += this.maximumTrack.width;
					}
				}
				if(this.decrementButton is IMeasureDisplayObject)
				{
					newMinWidth += IMeasureDisplayObject(this.decrementButton).minWidth;
				}
				else
				{
					newMinWidth += this.decrementButton.width;
				}
				if(this.incrementButton is IMeasureDisplayObject)
				{
					newMinWidth += IMeasureDisplayObject(this.incrementButton).minWidth;
				}
				else
				{
					newMinWidth += this.incrementButton.width;
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
				if(this.decrementButton is IMeasureDisplayObject)
				{
					var measureDecrementButton:IMeasureDisplayObject = IMeasureDisplayObject(this.decrementButton);
					if(measureDecrementButton.minHeight > newMinHeight)
					{
						newMinHeight = measureDecrementButton.minHeight;
					}
				}
				else if(this.decrementButton.height > newMinHeight)
				{
					newMinHeight = this.decrementButton.height;
				}
				if(this.incrementButton is IMeasureDisplayObject)
				{
					var measureIncrementButton:IMeasureDisplayObject = IMeasureDisplayObject(this.incrementButton);
					if(measureIncrementButton.minHeight > newMinHeight)
					{
						newMinHeight = measureIncrementButton.minHeight;
					}
				}
				else if(this.incrementButton.height > newMinHeight)
				{
					newMinHeight = this.incrementButton.height;
				}
			}
			return this.saveMeasurements(newWidth, newHeight, newMinWidth, newMinHeight);
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
			if(this.decrementButton is IValidating)
			{
				IValidating(this.decrementButton).validate();
			}
			if(this.incrementButton is IValidating)
			{
				IValidating(this.incrementButton).validate();
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
				if(this.decrementButton.width > newWidth)
				{
					newWidth = this.decrementButton.width;
				}
				if(this.incrementButton.width > newWidth)
				{
					newWidth = this.incrementButton.width;
				}
			}
			if(needsHeight)
			{
				newHeight = this.minimumTrack.height;
				if(!isSingle) //split
				{
					newHeight += this.maximumTrack.height;
				}
				newHeight += this.decrementButton.height + this.incrementButton.height;
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
				if(this.decrementButton is IMeasureDisplayObject)
				{
					var measureDecrementButton:IMeasureDisplayObject = IMeasureDisplayObject(this.decrementButton);
					if(measureDecrementButton.minWidth > newMinWidth)
					{
						newMinWidth = measureDecrementButton.minWidth;
					}
				}
				else if(this.decrementButton.width > newMinWidth)
				{
					newMinWidth = this.decrementButton.width;
				}
				if(this.incrementButton is IMeasureDisplayObject)
				{
					var measureIncrementButton:IMeasureDisplayObject = IMeasureDisplayObject(this.incrementButton);
					if(measureIncrementButton.minWidth > newMinWidth)
					{
						newMinWidth = measureIncrementButton.minWidth;
					}
				}
				else if(this.incrementButton.width > newMinWidth)
				{
					newMinWidth = this.incrementButton.width;
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
						newMinHeight += measureMaxTrack.minHeight;
					}
					else
					{
						newMinHeight += this.maximumTrack.height;
					}
				}
				if(this.decrementButton is IMeasureDisplayObject)
				{
					newMinHeight += IMeasureDisplayObject(this.decrementButton).minHeight;
				}
				else
				{
					newMinHeight += this.decrementButton.height;
				}
				if(this.incrementButton is IMeasureDisplayObject)
				{
					newMinHeight += IMeasureDisplayObject(this.incrementButton).minHeight;
				}
				else
				{
					newMinHeight += this.incrementButton.height;
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
		 * @see #style:customThumbStyleName
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
			if(thumb is IFocusDisplayObject)
			{
				thumb.isFocusEnabled = false;
			}
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
		 * @see #style:customMinimumTrackStyleName
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
			if(minimumTrack is IFocusDisplayObject)
			{
				minimumTrack.isFocusEnabled = false;
			}
			minimumTrack.addEventListener(TouchEvent.TOUCH, track_touchHandler);
			this.addChildAt(minimumTrack, 0);
			this.minimumTrack = minimumTrack;

			if(this.minimumTrack is IFeathersControl)
			{
				IFeathersControl(this.minimumTrack).initializeNow();
			}
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
				//measurements as explicit when we auto-size the scroll bar
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
		 * @see #style:customMaximumTrackStyleName
		 */
		protected function createMaximumTrack():void
		{
			if(this.maximumTrack)
			{
				this.maximumTrack.removeFromParent(true);
				this.maximumTrack = null;
			}
			if(this._trackLayoutMode !== TrackLayoutMode.SPLIT)
			{
				return;
			}
			var factory:Function = this._maximumTrackFactory != null ? this._maximumTrackFactory : defaultMaximumTrackFactory;
			var maximumTrackStyleName:String = this._customMaximumTrackStyleName != null ? this._customMaximumTrackStyleName : this.maximumTrackStyleName;
			var maximumTrack:BasicButton = BasicButton(factory());
			maximumTrack.styleNameList.add(maximumTrackStyleName);
			maximumTrack.keepDownStateOnRollOut = true;
			if(maximumTrack is IFocusDisplayObject)
			{
				maximumTrack.isFocusEnabled = false;
			}
			maximumTrack.addEventListener(TouchEvent.TOUCH, track_touchHandler);
			this.addChildAt(maximumTrack, 1);
			this.maximumTrack = maximumTrack;

			if(this.maximumTrack is IFeathersControl)
			{
				IFeathersControl(this.maximumTrack).initializeNow();
			}
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
				//measurements as explicit when we auto-size the scroll bar
				this._maximumTrackSkinExplicitWidth = this.maximumTrack.width;
				this._maximumTrackSkinExplicitHeight = this.maximumTrack.height;
				this._maximumTrackSkinExplicitMinWidth = this._maximumTrackSkinExplicitWidth;
				this._maximumTrackSkinExplicitMinHeight = this._maximumTrackSkinExplicitHeight
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
		 * @see #style:customDecremenButtonStyleName
		 */
		protected function createDecrementButton():void
		{
			if(this.decrementButton)
			{
				this.decrementButton.removeFromParent(true);
				this.decrementButton = null;
			}

			var factory:Function = this._decrementButtonFactory != null ? this._decrementButtonFactory : defaultDecrementButtonFactory;
			var decrementButtonStyleName:String = this._customDecrementButtonStyleName != null ? this._customDecrementButtonStyleName : this.decrementButtonStyleName;
			this.decrementButton = BasicButton(factory());
			this.decrementButton.styleNameList.add(decrementButtonStyleName);
			this.decrementButton.keepDownStateOnRollOut = true;
			if(this.decrementButton is IFocusDisplayObject)
			{
				this.decrementButton.isFocusEnabled = false;
			}
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
		 * @see #style:customIncrementButtonStyleName
		 */
		protected function createIncrementButton():void
		{
			if(this.incrementButton)
			{
				this.incrementButton.removeFromParent(true);
				this.incrementButton = null;
			}

			var factory:Function = this._incrementButtonFactory != null ? this._incrementButtonFactory : defaultIncrementButtonFactory;
			var incrementButtonStyleName:String = this._customIncrementButtonStyleName != null ? this._customIncrementButtonStyleName : this.incrementButtonStyleName;
			this.incrementButton = BasicButton(factory());
			this.incrementButton.styleNameList.add(incrementButtonStyleName);
			this.incrementButton.keepDownStateOnRollOut = true;
			if(this.incrementButton is IFocusDisplayObject)
			{
				this.incrementButton.isFocusEnabled = false;
			}
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
				var propertyValue:Object = this._thumbProperties[propertyName];
				this.thumb[propertyName] = propertyValue;
			}
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
		protected function refreshDecrementButtonStyles():void
		{
			for(var propertyName:String in this._decrementButtonProperties)
			{
				var propertyValue:Object = this._decrementButtonProperties[propertyName];
				this.decrementButton[propertyName] = propertyValue;
			}
		}

		/**
		 * @private
		 */
		protected function refreshIncrementButtonStyles():void
		{
			for(var propertyName:String in this._incrementButtonProperties)
			{
				var propertyValue:Object = this._incrementButtonProperties[propertyName];
				this.incrementButton[propertyName] = propertyValue;
			}
		}

		/**
		 * @private
		 */
		protected function refreshEnabled():void
		{
			var isEnabled:Boolean = this._isEnabled && this._maximum > this._minimum;
			if(this.thumb is IFeathersControl)
			{
				IFeathersControl(this.thumb).isEnabled = isEnabled;
			}
			if(this.minimumTrack is IFeathersControl)
			{
				IFeathersControl(this.minimumTrack).isEnabled = isEnabled;
			}
			if(this.maximumTrack is IFeathersControl)
			{
				IFeathersControl(this.maximumTrack).isEnabled = isEnabled;
			}
			this.decrementButton.isEnabled = isEnabled;
			this.incrementButton.isEnabled = isEnabled;
		}

		/**
		 * @private
		 */
		protected function layout():void
		{
			this.layoutStepButtons();
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
		protected function layoutStepButtons():void
		{
			if(this._direction == Direction.VERTICAL)
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
			var showButtons:Boolean = this._maximum != this._minimum;
			this.decrementButton.visible = showButtons;
			this.incrementButton.visible = showButtons;
		}

		/**
		 * @private
		 */
		protected function layoutThumb():void
		{
			var range:Number = this._maximum - this._minimum;
			this.thumb.visible = range > 0 && range < Number.POSITIVE_INFINITY && this._isEnabled;
			if(!this.thumb.visible)
			{
				return;
			}

			//this will auto-size the thumb, if needed
			if(this.thumb is IValidating)
			{
				IValidating(this.thumb).validate();
			}

			var contentWidth:Number = this.actualWidth - this._paddingLeft - this._paddingRight;
			var contentHeight:Number = this.actualHeight - this._paddingTop - this._paddingBottom;
			var adjustedPage:Number = this._page;
			if(this._page == 0)
			{
				adjustedPage = this._step;
			}
			if(adjustedPage > range)
			{
				adjustedPage = range;
			}
			if(this._direction == Direction.VERTICAL)
			{
				contentHeight -= (this.decrementButton.height + this.incrementButton.height);
				var thumbMinHeight:Number = this.thumbOriginalHeight;
				if(this.thumb is IMeasureDisplayObject)
				{
					thumbMinHeight = IMeasureDisplayObject(this.thumb).minHeight;
				}
				this.thumb.width = this.thumbOriginalWidth;
				this.thumb.height = Math.max(thumbMinHeight, contentHeight * adjustedPage / range);
				var trackScrollableHeight:Number = contentHeight - this.thumb.height;
				this.thumb.x = this._paddingLeft + (this.actualWidth - this._paddingLeft - this._paddingRight - this.thumb.width) / 2;
				this.thumb.y = this.decrementButton.height + this._paddingTop + Math.max(0, Math.min(trackScrollableHeight, trackScrollableHeight * (this._value - this._minimum) / range));
			}
			else //horizontal
			{
				contentWidth -= (this.decrementButton.width + this.decrementButton.width);
				var thumbMinWidth:Number = this.thumbOriginalWidth;
				if(this.thumb is IMeasureDisplayObject)
				{
					thumbMinWidth = IMeasureDisplayObject(this.thumb).minWidth;
				}
				this.thumb.width = Math.max(thumbMinWidth, contentWidth * adjustedPage / range);
				this.thumb.height = this.thumbOriginalHeight;
				var trackScrollableWidth:Number = contentWidth - this.thumb.width;
				this.thumb.x = this.decrementButton.width + this._paddingLeft + Math.max(0, Math.min(trackScrollableWidth, trackScrollableWidth * (this._value - this._minimum) / range));
				this.thumb.y = this._paddingTop + (this.actualHeight - this._paddingTop - this._paddingBottom - this.thumb.height) / 2;
			}
		}

		/**
		 * @private
		 */
		protected function layoutTrackWithMinMax():void
		{
			var range:Number = this._maximum - this._minimum;
			this.minimumTrack.touchable = range > 0 && range < Number.POSITIVE_INFINITY;
			if(this.maximumTrack)
			{
				this.maximumTrack.touchable = range > 0 && range < Number.POSITIVE_INFINITY;
			}

			var showButtons:Boolean = this._maximum != this._minimum;
			if(this._direction === Direction.VERTICAL)
			{
				this.minimumTrack.x = 0;
				if(showButtons)
				{
					this.minimumTrack.y = this.decrementButton.height;
				}
				else
				{
					this.minimumTrack.y = 0;
				}
				this.minimumTrack.width = this.actualWidth;
				this.minimumTrack.height = (this.thumb.y + this.thumb.height / 2) - this.minimumTrack.y;

				this.maximumTrack.x = 0;
				this.maximumTrack.y = this.minimumTrack.y + this.minimumTrack.height;
				this.maximumTrack.width = this.actualWidth;
				if(showButtons)
				{
					this.maximumTrack.height = this.actualHeight - this.incrementButton.height - this.maximumTrack.y;
				}
				else
				{
					this.maximumTrack.height = this.actualHeight - this.maximumTrack.y;
				}
			}
			else //horizontal
			{
				if(showButtons)
				{
					this.minimumTrack.x = this.decrementButton.width;
				}
				else
				{
					this.minimumTrack.x = 0;
				}
				this.minimumTrack.y = 0;
				this.minimumTrack.width = (this.thumb.x + this.thumb.width / 2) - this.minimumTrack.x;
				this.minimumTrack.height = this.actualHeight;

				this.maximumTrack.x = this.minimumTrack.x + this.minimumTrack.width;
				this.maximumTrack.y = 0;
				if(showButtons)
				{
					this.maximumTrack.width = this.actualWidth - this.incrementButton.width - this.maximumTrack.x;
				}
				else
				{
					this.maximumTrack.width = this.actualWidth - this.maximumTrack.x;
				}
				this.maximumTrack.height = this.actualHeight;
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
		}

		/**
		 * @private
		 */
		protected function layoutTrackWithSingle():void
		{
			var range:Number = this._maximum - this._minimum;
			this.minimumTrack.touchable = range > 0 && range < Number.POSITIVE_INFINITY;

			var showButtons:Boolean = this._maximum != this._minimum;
			if(this._direction === Direction.VERTICAL)
			{
				this.minimumTrack.x = 0;
				if(showButtons)
				{
					this.minimumTrack.y = this.decrementButton.height;
				}
				else
				{
					this.minimumTrack.y = 0;
				}
				this.minimumTrack.width = this.actualWidth;
				if(showButtons)
				{
					this.minimumTrack.height = this.actualHeight - this.minimumTrack.y - this.incrementButton.height;
				}
				else
				{
					this.minimumTrack.height = this.actualHeight - this.minimumTrack.y;
				}
			}
			else //horizontal
			{
				if(showButtons)
				{
					this.minimumTrack.x = this.decrementButton.width;
				}
				else
				{
					this.minimumTrack.x = 0;
				}
				this.minimumTrack.y = 0;
				if(showButtons)
				{
					this.minimumTrack.width = this.actualWidth - this.minimumTrack.x - this.incrementButton.width;
				}
				else
				{
					this.minimumTrack.width = this.actualWidth - this.minimumTrack.x;
				}
				this.minimumTrack.height = this.actualHeight;
			}

			//final validation to avoid juggler next frame issues
			if(this.minimumTrack is IValidating)
			{
				IValidating(this.minimumTrack).validate();
			}
		}

		/**
		 * @private
		 */
		protected function locationToValue(location:Point):Number
		{
			var percentage:Number = 0;
			if(this._direction == Direction.VERTICAL)
			{
				var trackScrollableHeight:Number = this.actualHeight - this.thumb.height - this.decrementButton.height - this.incrementButton.height - this._paddingTop - this._paddingBottom;
				if(trackScrollableHeight > 0)
				{
					var yOffset:Number = location.y - this._touchStartY - this._paddingTop;
					var yPosition:Number = Math.min(Math.max(0, this._thumbStartY + yOffset - this.decrementButton.height), trackScrollableHeight);
					percentage = yPosition / trackScrollableHeight;
				}
			}
			else //horizontal
			{
				var trackScrollableWidth:Number = this.actualWidth - this.thumb.width - this.decrementButton.width - this.incrementButton.width - this._paddingLeft - this._paddingRight;
				if(trackScrollableWidth > 0)
				{
					var xOffset:Number = location.x - this._touchStartX - this._paddingLeft;
					var xPosition:Number = Math.min(Math.max(0, this._thumbStartX + xOffset - this.decrementButton.width), trackScrollableWidth);
					percentage = xPosition / trackScrollableWidth;
				}
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
			var range:Number = this._maximum - this._minimum;
			var adjustedPage:Number = this._page;
			if(this._page == 0)
			{
				adjustedPage = this._step;
			}
			if(adjustedPage > range)
			{
				adjustedPage = range;
			}
			if(this._touchValue < this._pageStartValue)
			{
				var newValue:Number = Math.max(this._touchValue, this._value - adjustedPage);
				if(this._step != 0 && newValue != this._maximum && newValue != this._minimum)
				{
					newValue = roundDownToNearest(newValue, this._step);
				}
				this.value = newValue;
			}
			else if(this._touchValue > this._pageStartValue)
			{
				newValue = Math.min(this._touchValue, this._value + adjustedPage);
				if(this._step != 0 && newValue != this._maximum && newValue != this._minimum)
				{
					newValue = roundUpToNearest(newValue, this._step);
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

			var track:DisplayObject = DisplayObject(event.currentTarget);
			if(this._touchPointID >= 0)
			{
				var touch:Touch = event.getTouch(track, null, this._touchPointID);
				if(touch === null)
				{
					return;
				}
				if(touch.phase === TouchPhase.MOVED)
				{
					var location:Point = touch.getLocation(this, Pool.getPoint());
					this._touchValue = this.locationToValue(location);
					Pool.putPoint(location);
				}
				else if(touch.phase === TouchPhase.ENDED)
				{
					this._touchPointID = -1;
					this._repeatTimer.stop();
					this.dispatchEventWith(FeathersEventType.END_INTERACTION);
				}
			}
			else
			{
				touch = event.getTouch(track, TouchPhase.BEGAN);
				if(touch === null)
				{
					return;
				}
				this._touchPointID = touch.id;
				this.dispatchEventWith(FeathersEventType.BEGIN_INTERACTION);
				location = touch.getLocation(this, Pool.getPoint());
				this._touchStartX = location.x;
				this._touchStartY = location.y;
				this._thumbStartX = this._touchStartX;
				this._thumbStartY = this._touchStartY;
				this._touchValue = this.locationToValue(location);
				Pool.putPoint(location);
				this._pageStartValue = this._value;
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
				if(touch === null)
				{
					return;
				}
				if(touch.phase === TouchPhase.MOVED)
				{
					var location:Point = touch.getLocation(this, Pool.getPoint());
					var newValue:Number = this.locationToValue(location);
					Pool.putPoint(location);
					if(this._step != 0 && newValue != this._maximum && newValue != this._minimum)
					{
						newValue = roundToNearest(newValue, this._step);
					}
					this.value = newValue;
				}
				else if(touch.phase === TouchPhase.ENDED)
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
				if(touch === null)
				{
					return;
				}
				location = touch.getLocation(this, Pool.getPoint());
				this._touchPointID = touch.id;
				this._thumbStartX = this.thumb.x;
				this._thumbStartY = this.thumb.y;
				this._touchStartX = location.x;
				this._touchStartY = location.y;
				Pool.putPoint(location);
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
				if(touch === null)
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
				if(touch === null)
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
				if(touch === null)
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
				if(touch === null)
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
