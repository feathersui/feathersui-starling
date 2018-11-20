/*
Feathers
Copyright 2012-2018 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.controls.supportClasses.IViewPort;
	import feathers.core.FeathersControl;
	import feathers.core.IFeathersControl;
	import feathers.core.IFocusDisplayObject;
	import feathers.core.IMeasureDisplayObject;
	import feathers.core.IValidating;
	import feathers.core.PropertyProxy;
	import feathers.events.ExclusiveTouch;
	import feathers.events.FeathersEventType;
	import feathers.layout.Direction;
	import feathers.layout.RelativePosition;
	import feathers.system.DeviceCapabilities;
	import feathers.utils.display.getDisplayObjectDepthFromStage;
	import feathers.utils.math.roundDownToNearest;
	import feathers.utils.math.roundToNearest;
	import feathers.utils.math.roundUpToNearest;
	import feathers.utils.skins.resetFluidChildDimensionsForMeasurement;

	import flash.errors.IllegalOperationError;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;

	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.MathUtil;
	import starling.utils.Pool;

	/**
	 * If <code>true</code>, the background's <code>visible</code> property
	 * will be set to <code>false</code> when the scroll position is greater
	 * than or equal to the minimum scroll position and less than or equal
	 * to the maximum scroll position. The background will be visible when
	 * the content is extended beyond the scrolling bounds, such as when
	 * <code>hasElasticEdges</code> is <code>true</code>.
	 *
	 * <p>If the content is not fully opaque, this setting should not be
	 * enabled.</p>
	 *
	 * <p>This setting may be enabled to potentially improve performance.</p>
	 *
	 * <p>In the following example, the background is automatically hidden:</p>
	 *
	 * <listing version="3.0">
	 * scroller.autoHideBackground = true;</listing>
	 *
	 * @default false
	 * 
	 * @see #style:backgroundSkin
	 */
	[Style(name="autoHideBackground",type="Boolean")]

	/**
	 * The default background to display.
	 *
	 * <p>In the following example, the scroller is given a background skin:</p>
	 *
	 * <listing version="3.0">
	 * scroller.backgroundSkin = new Image( texture );</listing>
	 *
	 * @default null
	 * 
	 * @see #style:backgroundDisabledSkin
	 */
	[Style(name="backgroundSkin",type="starling.display.DisplayObject")]

	/**
	 * A background to display when the container is disabled.
	 *
	 * <p>In the following example, the scroller is given a disabled background skin:</p>
	 *
	 * <listing version="3.0">
	 * scroller.backgroundDisabledSkin = new Image( texture );</listing>
	 *
	 * @default null
	 *
	 * @see #style:backgroundSkin
	 */
	[Style(name="backgroundDisabledSkin",type="starling.display.DisplayObject")]

	/**
	 * If true, the viewport will be clipped to the scroller's bounds. In
	 * other words, anything appearing outside the scroller's bounds will
	 * not be visible.
	 *
	 * <p>To improve performance, turn off clipping and place other display
	 * objects over the edges of the scroller to hide the content that
	 * bleeds outside of the scroller's bounds.</p>
	 *
	 * <p>In the following example, clipping is disabled:</p>
	 *
	 * <listing version="3.0">
	 * scroller.clipContent = false;</listing>
	 *
	 * @default true
	 */
	[Style(name="clipContent",type="Boolean")]

	/**
	 * A style name to add to the container's horizontal scroll bar
	 * sub-component. Typically used by a theme to provide different styles
	 * to different containers.
	 *
	 * <p>In the following example, a custom horizontal scroll bar style
	 * name is passed to the scroller:</p>
	 *
	 * <listing version="3.0">
	 * scroller.customHorizontalScrollBarStyleName = "my-custom-horizontal-scroll-bar";</listing>
	 *
	 * <p>In your theme, you can target this sub-component style name to
	 * provide different styles than the default:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( SimpleScrollBar ).setFunctionForStyleName( "my-custom-horizontal-scroll-bar", setCustomHorizontalScrollBarStyles );</listing>
	 *
	 * @default null
	 *
	 * @see #DEFAULT_CHILD_STYLE_NAME_HORIZONTAL_SCROLL_BAR
	 * @see feathers.core.FeathersControl#styleNameList
	 * @see #horizontalScrollBarFactory
	 */
	[Style(name="customHorizontalScrollBarStyleName",type="String")]

	/**
	 * A style name to add to the container's vertical scroll bar
	 * sub-component. Typically used by a theme to provide different styles
	 * to different containers.
	 *
	 * <p>In the following example, a custom vertical scroll bar style name
	 * is passed to the scroller:</p>
	 *
	 * <listing version="3.0">
	 * scroller.customVerticalScrollBarStyleName = "my-custom-vertical-scroll-bar";</listing>
	 *
	 * <p>In your theme, you can target this sub-component style name to
	 * provide different styles than the default:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( SimpleScrollBar ).setFunctionForStyleName( "my-custom-vertical-scroll-bar", setCustomVerticalScrollBarStyles );</listing>
	 *
	 * @default null
	 *
	 * @see #DEFAULT_CHILD_STYLE_NAME_VERTICAL_SCROLL_BAR
	 * @see feathers.core.FeathersControl#styleNameList
	 * @see #verticalScrollBarFactory
	 */
	[Style(name="customVerticalScrollBarStyleName",type="String")]

	/**
	 * This value is used to decelerate the scroller when "thrown". The
	 * velocity of a throw is multiplied by this value once per millisecond
	 * to decelerate. A value greater than <code>0</code> and less than
	 * <code>1</code> is expected.
	 *
	 * <p>In the following example, deceleration rate is lowered to adjust
	 * the behavior of a throw:</p>
	 *
	 * <listing version="3.0">
	 * scroller.decelerationRate = DecelerationRate.FAST;</listing>
	 *
	 * @default feathers.controls.DecelerationRate.NORMAL
	 *
	 * @see feathers.controls.DecelerationRate#NORMAL
	 * @see feathers.controls.DecelerationRate#FAST
	 */
	[Style(name="decelerationRate",type="Number")]

	/**
	 * If the scroll position goes outside the minimum or maximum bounds
	 * when the scroller's content is being actively dragged, the scrolling
	 * will be constrained using this multiplier. A value of <code>0</code>
	 * means that the scroller will not go beyond its minimum or maximum
	 * bounds. A value of <code>1</code> means that going beyond the minimum
	 * or maximum bounds is completely unrestrained.
	 *
	 * <p>In the following example, the elasticity of dragging beyond the
	 * scroller's edges is customized:</p>
	 *
	 * <listing version="3.0">
	 * scroller.elasticity = 0.5;</listing>
	 *
	 * @default 0.33
	 *
	 * @see #style:hasElasticEdges
	 * @see #style:throwElasticity
	 */
	[Style(name="elasticity",type="Number")]

	/**
	 * The duration, in seconds, of the animation when a the scroller snaps
	 * back to the minimum or maximum position after going out of bounds.
	 *
	 * <p>In the following example, the duration of the animation that snaps
	 * the content back after pulling it beyond the edge is set to 750
	 * milliseconds:</p>
	 *
	 * <listing version="3.0">
	 * scroller.elasticSnapDuration = 0.75;</listing>
	 *
	 * @default 0.5
	 * 
	 * @see #style:hasElasticEdges
	 */
	[Style(name="elasticSnapDuration",type="Number")]

	/**
	 * Determines if the scrolling can go beyond the edges of the viewport.
	 *
	 * <p>In the following example, elastic edges are disabled:</p>
	 *
	 * <listing version="3.0">
	 * scroller.hasElasticEdges = false;</listing>
	 *
	 * @default true
	 *
	 * @see #style:elasticity
	 * @see #style:throwElasticity
	 */
	[Style(name="hasElasticEdges",type="Boolean")]

	/**
	 * The duration, in seconds, of the animation when a scroll bar fades
	 * out.
	 *
	 * <p>In the following example, the duration of the animation that hides
	 * the scroll bars is set to 500 milliseconds:</p>
	 *
	 * <listing version="3.0">
	 * scroller.hideScrollBarAnimationDuration = 0.5;</listing>
	 *
	 * @default 0.2
	 * 
	 * @see #style:scrollBarDisplayMode
	 */
	[Style(name="hideScrollBarAnimationDuration",type="Number")]

	/**
	 * The easing function used for hiding the scroll bars, if applicable.
	 *
	 * <p>In the following example, the ease of the animation that hides
	 * the scroll bars is customized:</p>
	 *
	 * <listing version="3.0">
	 * scroller.hideScrollBarAnimationEase = Transitions.EASE_IN_OUT;</listing>
	 *
	 * @default starling.animation.Transitions.EASE_OUT
	 *
	 * @see http://doc.starling-framework.org/core/starling/animation/Transitions.html starling.animation.Transitions
	 *
	 * @see #style:scrollBarDisplayMode
	 */
	[Style(name="hideScrollBarAnimationEase",type="Object")]

	/**
	 * Determines where the horizontal scroll bar will be positioned.
	 *
	 * <p>In the following example, the scroll bars is positioned on the top:</p>
	 *
	 * <listing version="3.0">
	 * scroller.horizontalScrollBarPosition = RelativePosition.TOP;</listing>
	 *
	 * @default feathers.layout.RelativePosition.BOTTOM
	 *
	 * @see feathers.layout.RelativePosition#TOP
	 * @see feathers.layout.RelativePosition#BOTTOM
	 */
	[Style(name="horizontalScrollBarPosition",type="String")]

	/**
	 * Determines how the user may interact with the scroller.
	 *
	 * <p>In the following example, the interaction mode is optimized for mouse:</p>
	 *
	 * <listing version="3.0">
	 * scroller.interactionMode = ScrollInteractionMode.MOUSE;</listing>
	 *
	 * @default feathers.controls.ScrollInteractionMode.TOUCH
	 *
	 * @see feathers.controls.ScrollInteractionMode#TOUCH
	 * @see feathers.controls.ScrollInteractionMode#MOUSE
	 * @see feathers.controls.ScrollInteractionMode#TOUCH_AND_SCROLL_BARS
	 */
	[Style(name="interactionMode",type="String")]

	/**
	 * The duration, in seconds, of the animation when the mouse wheel
	 * initiates a scroll action.
	 *
	 * <p>In the following example, the duration of the animation that runs
	 * when the mouse wheel is scrolled is set to 500 milliseconds:</p>
	 *
	 * <listing version="3.0">
	 * scroller.mouseWheelScrollDuration = 0.5;</listing>
	 *
	 * @default 0.35
	 */
	[Style(name="mouseWheelScrollDuration",type="Number")]

	/**
	 * Quickly sets all padding properties to the same value. The
	 * <code>padding</code> getter always returns the value of
	 * <code>paddingTop</code>, but the other padding values may be
	 * different.
	 *
	 * <p>In the following example, the padding is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * scroller.padding = 20;</listing>
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
	 * The minimum space, in pixels, between the container's top edge and the
	 * container's content.
	 *
	 * <p>In the following example, the top padding is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * scroller.paddingTop = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:padding
	 */
	[Style(name="paddingTop",type="Number")]

	/**
	 * The minimum space, in pixels, between the container's right edge and
	 * the container's content.
	 *
	 * <p>In the following example, the right padding is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * scroller.paddingRight = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:padding
	 */
	[Style(name="paddingRight",type="Number")]

	/**
	 * The minimum space, in pixels, between the container's bottom edge and
	 * the container's content.
	 *
	 * <p>In the following example, the bottom padding is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * scroller.paddingBottom = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:padding
	 */
	[Style(name="paddingBottom",type="Number")]

	/**
	 * The minimum space, in pixels, between the container's left edge and the
	 * container's content.
	 *
	 * <p>In the following example, the left padding is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * scroller.paddingLeft = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:padding
	 */
	[Style(name="paddingLeft",type="Number")]

	/**
	 * The duration, in seconds, of the animation when the scroller is
	 * thrown to a page.
	 *
	 * <p>In the following example, the duration of the animation that
	 * changes the page when thrown is set to 250 milliseconds:</p>
	 *
	 * <listing version="3.0">
	 * scroller.pageThrowDuration = 0.25;</listing>
	 *
	 * @default 0.5
	 */
	[Style(name="pageThrowDuration",type="Number")]

	/**
	 * The duration, in seconds, that the scroll bars will be shown when
	 * calling <code>revealScrollBars()</code>
	 *
	 * @default 1.0
	 *
	 * @see #revealScrollBars()
	 */
	[Style(name="revealScrollBarsDuration",type="Number")]

	/**
	 * Determines how the scroll bars are displayed.
	 *
	 * <p>In the following example, the scroll bars are fixed:</p>
	 *
	 * <listing version="3.0">
	 * scroller.scrollBarDisplayMode = ScrollBarDisplayMode.FIXED;</listing>
	 *
	 * @default feathers.controls.ScrollBarDisplayMode.FLOAT
	 *
	 * @see feathers.controls.ScrollBarDisplayMode#FLOAT
	 * @see feathers.controls.ScrollBarDisplayMode#FIXED
	 * @see feathers.controls.ScrollBarDisplayMode#FIXED_FLOAT
	 * @see feathers.controls.ScrollBarDisplayMode#NONE
	 */
	[Style(name="scrollBarDisplayMode",type="String")]

	/**
	 * If enabled, the scroll position will always be adjusted to the nearest
	 * pixel on the physical screen. Depending on the value of Starling's
	 * <code>contentScaleFactor</code>, this may or may not result in an integer
	 * value for the scroll position.
	 *
	 * <p>In the following example, the scroll position is not snapped to pixels:</p>
	 *
	 * <listing version="3.0">
	 * scroller.snapScrollPositionsToPixels = false;</listing>
	 *
	 * @default true
	 */
	[Style(name="snapScrollPositionsToPixels",type="Boolean")]

	/**
	 * Determines if scrolling will snap to the nearest page.
	 *
	 * <p>In the following example, the scroller snaps to the nearest page:</p>
	 *
	 * <listing version="3.0">
	 * scroller.snapToPages = true;</listing>
	 *
	 * @default false
	 */
	[Style(name="snapToPages",type="Boolean")]

	/**
	 * The easing function used for "throw" animations.
	 *
	 * <p>In the following example, the ease of throwing animations is
	 * customized:</p>
	 *
	 * <listing version="3.0">
	 * scroller.throwEase = Transitions.EASE_IN_OUT;</listing>
	 *
	 * @see http://doc.starling-framework.org/core/starling/animation/Transitions.html starling.animation.Transitions
	 */
	[Style(name="throwEase",type="Object")]

	/**
	 * If the scroll position goes outside the minimum or maximum bounds
	 * when the scroller's content is "thrown", the scrolling will be
	 * constrained using this multiplier. A value of <code>0</code> means
	 * that the scroller will not go beyond its minimum or maximum bounds.
	 * A value of <code>1</code> means that going beyond the minimum or
	 * maximum bounds is completely unrestrained.
	 *
	 * <p>In the following example, the elasticity of throwing beyond the
	 * scroller's edges is customized:</p>
	 *
	 * <listing version="3.0">
	 * scroller.throwElasticity = 0.1;</listing>
	 *
	 * @default 0.05
	 *
	 * @see #style:hasElasticEdges
	 * @see #style:elasticity
	 */
	[Style(name="throwElasticity",type="Number")]

	/**
	 * If <code>true</code>, the duration of a "throw" animation will be the
	 * same no matter the value of the throw's initial velocity. This value
	 * may be set to <code>false</code> to have the scroller calculate a
	 * variable duration based on the velocity of the throw.
	 *
	 * <p>It may seem unintuitive, but using the same fixed duration for any
	 * velocity is recommended if you are looking to closely match the
	 * behavior of native scrolling on iOS.</p>
	 *
	 * <p>In the following example, the behavior of a "throw" animation is
	 * changed:</p>
	 *
	 * <listing version="3.0">
	 * scroller.useFixedThrowDuration = false;</listing>
	 *
	 * @default true
	 *
	 * @see #style:decelerationRate
	 */
	[Style(name="useFixedThrowDuration",type="Boolean")]

	/**
	 * Determines where the vertical scroll bar will be positioned.
	 *
	 * <p>In the following example, the scroll bars is positioned on the left:</p>
	 *
	 * <listing version="3.0">
	 * scroller.verticalScrollBarPosition = RelativePosition.LEFT;</listing>
	 *
	 * @default feathers.layout.RelativePosition.RIGHT
	 *
	 * @see feathers.layout.RelativePosition#RIGHT
	 * @see feathers.layout.RelativePosition#LEFT
	 */
	[Style(name="verticalScrollBarPosition",type="String")]

	/**
	 * Dispatched when the scroller scrolls in either direction or when the view
	 * port's scrolling bounds have changed. Listen for <code>FeathersEventType.SCROLL_START</code>
	 * to know when scrolling starts as a result of user interaction or when
	 * scrolling is triggered by an animation. Similarly, listen for
	 * <code>FeathersEventType.SCROLL_COMPLETE</code> to know when the scrolling
	 * ends.
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
	 * @eventType starling.events.Event.SCROLL
	 * @see #event:scrollStart feathers.events.FeathersEventType.SCROLL_START
	 * @see #event:scrollComplete feathers.events.FeathersEventType.SCROLL_COMPLETE
	 */
	[Event(name="scroll",type="starling.events.Event")]

	/**
	 * Dispatched when the scroller starts scrolling in either direction
	 * as a result of either user interaction or animation.
	 *
	 * <p>Note: If <code>horizontalScrollPosition</code> or <code>verticalScrollPosition</code>
	 * is set manually (in other words, the scrolling is not triggered by user
	 * interaction or an animated scroll), no <code>FeathersEventType.SCROLL_START</code>
	 * or <code>FeathersEventType.SCROLL_COMPLETE</code> events will be
	 * dispatched.</p>
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
	 * @eventType feathers.events.FeathersEventType.SCROLL_START
	 * @see #event:scrollComplete feathers.events.FeathersEventType.SCROLL_COMPLETE
	 * @see #event:scroll feathers.events.FeathersEventType.SCROLL
	 */
	[Event(name="scrollStart",type="starling.events.Event")]

	/**
	 * Dispatched when the scroller finishes scrolling in either direction
	 * as a result of either user interaction or animation. Animations may not
	 * end at the same time that user interaction ends, so the event may be
	 * delayed if user interaction triggers scrolling again.
	 *
	 * <p>Note: If <code>horizontalScrollPosition</code> or <code>verticalScrollPosition</code>
	 * is set manually (in other words, the scrolling is not triggered by user
	 * interaction or an animated scroll), no <code>FeathersEventType.SCROLL_START</code>
	 * or <code>FeathersEventType.SCROLL_COMPLETE</code> events will be
	 * dispatched.</p>
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
	 * @eventType feathers.events.FeathersEventType.SCROLL_COMPLETE
	 * @see #event:scrollStart feathers.events.FeathersEventType.SCROLL_START
	 * @see #event:scroll feathers.events.FeathersEventType.SCROLL
	 */
	[Event(name="scrollComplete",type="starling.events.Event")]

	/**
	 * Dispatched when the user starts dragging the scroller when
	 * <code>ScrollInteractionMode.TOUCH</code> is enabled or when the user
	 * starts interacting with the scroll bar.
	 *
	 * <p>Note: If <code>horizontalScrollPosition</code> or <code>verticalScrollPosition</code>
	 * is set manually (in other words, the scrolling is not triggered by user
	 * interaction), no <code>FeathersEventType.BEGIN_INTERACTION</code>
	 * or <code>FeathersEventType.END_INTERACTION</code> events will be
	 * dispatched.</p>
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
	 * @see #event:endInteraction feathers.events.FeathersEventType.END_INTERACTION
	 * @see #event:scroll feathers.events.FeathersEventType.SCROLL
	 */
	[Event(name="beginInteraction",type="starling.events.Event")]

	/**
	 * Dispatched when the user stops dragging the scroller when
	 * <code>ScrollInteractionMode.TOUCH</code> is enabled or when the user
	 * stops interacting with the scroll bar. The scroller may continue
	 * scrolling after this event is dispatched if the user interaction has also
	 * triggered an animation.
	 *
	 * <p>Note: If <code>horizontalScrollPosition</code> or <code>verticalScrollPosition</code>
	 * is set manually (in other words, the scrolling is not triggered by user
	 * interaction), no <code>FeathersEventType.BEGIN_INTERACTION</code>
	 * or <code>FeathersEventType.END_INTERACTION</code> events will be
	 * dispatched.</p>
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
	 * @see #event:beginInteraction feathers.events.FeathersEventType.BEGIN_INTERACTION
	 * @see #event:scroll feathers.events.FeathersEventType.SCROLL
	 */
	[Event(name="endInteraction",type="starling.events.Event")]

	/**
	 * Dispatched when the component receives focus.
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
	 * @eventType feathers.events.FeathersEventType.FOCUS_IN
	 */
	[Event(name="focusIn",type="starling.events.Event")]

	/**
	 * Dispatched when the component loses focus.
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
	 * @eventType feathers.events.FeathersEventType.FOCUS_OUT
	 */
	[Event(name="focusOut",type="starling.events.Event")]

	/**
	 * Dispatched when a pull view is activated.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>The pull view that was activated.</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @eventType starling.events.Event.UPDATE
	 */
	[Event(name="update",type="starling.events.Event")]

	/**
	 * Allows horizontal and vertical scrolling of a <em>view port</em>. Not
	 * meant to be used as a standalone container or component. Generally meant
	 * to be the super class of another component that needs to support
	 * scrolling. To put components in a generic scrollable container (with
	 * optional layout), see <code>ScrollContainer</code>. To scroll long
	 * passages of text, see <code>ScrollText</code>.
	 *
	 * <p>This component is generally not instantiated directly. Instead it is
	 * typically used as a super class for other scrolling components like lists
	 * and containers. With that in mind, no code example is included here.</p>
	 *
	 * @see feathers.controls.ScrollContainer
	 *
	 * @productversion Feathers 1.1.0
	 */
	public class Scroller extends FeathersControl implements IFocusDisplayObject
	{
		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_SCROLL_BAR_RENDERER:String = "scrollBarRenderer";

		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_PENDING_SCROLL:String = "pendingScroll";

		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_PENDING_REVEAL_SCROLL_BARS:String = "pendingRevealScrollBars";

		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_PENDING_PULL_VIEW:String = "pendingPullView";

		/**
		 * Flag to indicate that the clipping has changed.
		 */
		protected static const INVALIDATION_FLAG_CLIPPING:String = "clipping";

		/**
		 * @private
		 * The point where we stop calculating velocity changes because floating
		 * point issues can start to appear.
		 */
		private static const MINIMUM_VELOCITY:Number = 0.02;

		/**
		 * @private
		 * The current velocity is given high importance.
		 */
		private static const CURRENT_VELOCITY_WEIGHT:Number = 2.33;

		/**
		 * @private
		 * Older saved velocities are given less importance.
		 */
		private static const VELOCITY_WEIGHTS:Vector.<Number> = new <Number>[1, 1.33, 1.66, 2];

		/**
		 * @private
		 */
		private static const MAXIMUM_SAVED_VELOCITY_COUNT:int = 4;

		/**
		 * The default value added to the <code>styleNameList</code> of the
		 * horizontal scroll bar.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_HORIZONTAL_SCROLL_BAR:String = "feathers-scroller-horizontal-scroll-bar";

		/**
		 * The default value added to the <code>styleNameList</code> of the vertical
		 * scroll bar.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_VERTICAL_SCROLL_BAR:String = "feathers-scroller-vertical-scroll-bar";

		/**
		 * @private
		 */
		protected static const PAGE_INDEX_EPSILON:Number = 0.01;

		/**
		 * @private
		 */
		protected static function defaultScrollBarFactory():IScrollBar
		{
			return new SimpleScrollBar();
		}

		/**
		 * @private
		 */
		protected static function defaultThrowEase(ratio:Number):Number
		{
			ratio -= 1;
			return 1 - ratio * ratio * ratio * ratio;
		}

		/**
		 * Constructor.
		 */
		public function Scroller()
		{
			super();

			this.addEventListener(Event.ADDED_TO_STAGE, scroller_addedToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, scroller_removedFromStageHandler);
		}

		/**
		 * The value added to the <code>styleNameList</code> of the horizontal
		 * scroll bar. This variable is <code>protected</code> so that
		 * sub-classes can customize the horizontal scroll bar style name in
		 * their constructors instead of using the default style name defined by
		 * <code>DEFAULT_CHILD_STYLE_NAME_HORIZONTAL_SCROLL_BAR</code>.
		 *
		 * <p>To customize the horizontal scroll bar style name without
		 * subclassing, see <code>customHorizontalScrollBarStyleName</code>.</p>
		 *
		 * @see #style:customHorizontalScrollBarStyleName
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var horizontalScrollBarStyleName:String = DEFAULT_CHILD_STYLE_NAME_HORIZONTAL_SCROLL_BAR;

		/**
		 * The value added to the <code>styleNameList</code> of the vertical
		 * scroll bar. This variable is <code>protected</code> so that
		 * sub-classes can customize the vertical scroll bar style name in their
		 * constructors instead of using the default style name defined by
		 * <code>DEFAULT_CHILD_STYLE_NAME_VERTICAL_SCROLL_BAR</code>.
		 *
		 * <p>To customize the vertical scroll bar style name without
		 * subclassing, see <code>customVerticalScrollBarStyleName</code>.</p>
		 *
		 * @see #style:customVerticalScrollBarStyleName
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var verticalScrollBarStyleName:String = DEFAULT_CHILD_STYLE_NAME_VERTICAL_SCROLL_BAR;

		/**
		 * The horizontal scrollbar instance. May be null.
		 *
		 * <p>For internal use in subclasses.</p>
		 *
		 * @see #horizontalScrollBarFactory
		 * @see #createScrollBars()
		 */
		protected var horizontalScrollBar:IScrollBar;

		/**
		 * The vertical scrollbar instance. May be null.
		 *
		 * <p>For internal use in subclasses.</p>
		 *
		 * @see #verticalScrollBarFactory
		 * @see #createScrollBars()
		 */
		protected var verticalScrollBar:IScrollBar;

		/**
		 * @private
		 */
		override public function get isFocusEnabled():Boolean
		{
			return (this._maxVerticalScrollPosition != this._minVerticalScrollPosition ||
				this._maxHorizontalScrollPosition != this._minHorizontalScrollPosition) &&
				super.isFocusEnabled;
		}

		/**
		 * @private
		 */
		protected var _topViewPortOffset:Number;

		/**
		 * @private
		 */
		protected var _rightViewPortOffset:Number;

		/**
		 * @private
		 */
		protected var _bottomViewPortOffset:Number;

		/**
		 * @private
		 */
		protected var _leftViewPortOffset:Number;

		/**
		 * @private
		 */
		protected var _hasHorizontalScrollBar:Boolean = false;

		/**
		 * @private
		 */
		protected var _hasVerticalScrollBar:Boolean = false;

		/**
		 * @private
		 */
		protected var _horizontalScrollBarTouchPointID:int = -1;

		/**
		 * @private
		 */
		protected var _verticalScrollBarTouchPointID:int = -1;

		/**
		 * @private
		 */
		protected var _touchPointID:int = -1;

		/**
		 * @private
		 */
		protected var _startTouchX:Number;

		/**
		 * @private
		 */
		protected var _startTouchY:Number;

		/**
		 * @private
		 */
		protected var _startHorizontalScrollPosition:Number;

		/**
		 * @private
		 */
		protected var _startVerticalScrollPosition:Number;

		/**
		 * @private
		 */
		protected var _currentTouchX:Number;

		/**
		 * @private
		 */
		protected var _currentTouchY:Number;

		/**
		 * @private
		 */
		protected var _previousTouchTime:int;

		/**
		 * @private
		 */
		protected var _previousTouchX:Number;

		/**
		 * @private
		 */
		protected var _previousTouchY:Number;

		/**
		 * @private
		 */
		protected var _velocityX:Number = 0;

		/**
		 * @private
		 */
		protected var _velocityY:Number = 0;

		/**
		 * @private
		 */
		protected var _previousVelocityX:Vector.<Number> = new <Number>[];

		/**
		 * @private
		 */
		protected var _previousVelocityY:Vector.<Number> = new <Number>[];

		/**
		 * @private
		 */
		protected var _pendingVelocityChange:Boolean = false;

		/**
		 * @private
		 */
		protected var _lastViewPortWidth:Number = 0;

		/**
		 * @private
		 */
		protected var _lastViewPortHeight:Number = 0;

		/**
		 * @private
		 */
		protected var _hasViewPortBoundsChanged:Boolean = false;

		/**
		 * @private
		 */
		protected var _horizontalAutoScrollTween:Tween;

		/**
		 * @private
		 */
		protected var _verticalAutoScrollTween:Tween;

		/**
		 * @private
		 */
		protected var _topPullTween:Tween;

		/**
		 * @private
		 */
		protected var _rightPullTween:Tween;

		/**
		 * @private
		 */
		protected var _bottomPullTween:Tween;

		/**
		 * @private
		 */
		protected var _leftPullTween:Tween;

		/**
		 * @private
		 */
		protected var _isDraggingHorizontally:Boolean = false;

		/**
		 * @private
		 */
		protected var _isDraggingVertically:Boolean = false;

		/**
		 * @private
		 */
		protected var ignoreViewPortResizing:Boolean = false;

		/**
		 * @private
		 */
		protected var _viewPort:IViewPort;

		/**
		 * The display object displayed and scrolled within the Scroller.
		 *
		 * @default null
		 */
		public function get viewPort():IViewPort
		{
			return this._viewPort;
		}

		/**
		 * @private
		 */
		public function set viewPort(value:IViewPort):void
		{
			if(this._viewPort == value)
			{
				return;
			}
			if(this._viewPort !== null)
			{
				this._viewPort.removeEventListener(FeathersEventType.RESIZE, viewPort_resizeHandler);
				this.removeRawChildInternal(DisplayObject(this._viewPort));
			}
			this._viewPort = value;
			if(this._viewPort !== null)
			{
				this._viewPort.addEventListener(FeathersEventType.RESIZE, viewPort_resizeHandler);
				this.addRawChildAtInternal(DisplayObject(this._viewPort), 0);
				if(this._viewPort is IFeathersControl)
				{
					IFeathersControl(this._viewPort).initializeNow();
				}
				this._explicitViewPortWidth = this._viewPort.explicitWidth;
				this._explicitViewPortHeight = this._viewPort.explicitHeight;
				this._explicitViewPortMinWidth = this._viewPort.explicitMinWidth;
				this._explicitViewPortMinHeight = this._viewPort.explicitMinHeight;
			}
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		/**
		 * @private
		 */
		protected var _explicitViewPortWidth:Number;

		/**
		 * @private
		 */
		protected var _explicitViewPortHeight:Number;

		/**
		 * @private
		 */
		protected var _explicitViewPortMinWidth:Number;

		/**
		 * @private
		 */
		protected var _explicitViewPortMinHeight:Number;

		/**
		 * @private
		 */
		protected var _measureViewPort:Boolean = true;

		/**
		 * Determines if the dimensions of the view port are used when measuring
		 * the scroller. If disabled, only children other than the view port
		 * (such as the background skin) are used for measurement.
		 *
		 * <p>In the following example, the view port measurement is disabled:</p>
		 *
		 * <listing version="3.0">
		 * scroller.measureViewPort = false;</listing>
		 *
		 * @default true
		 */
		public function get measureViewPort():Boolean
		{
			return this._measureViewPort;
		}

		/**
		 * @private
		 */
		public function set measureViewPort(value:Boolean):void
		{
			if(this._measureViewPort == value)
			{
				return;
			}
			this._measureViewPort = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		/**
		 * @private
		 */
		protected var _snapToPages:Boolean = false;

		/**
		 * @private
		 */
		public function get snapToPages():Boolean
		{
			return this._snapToPages;
		}

		/**
		 * @private
		 */
		public function set snapToPages(value:Boolean):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._snapToPages === value)
			{
				return;
			}
			this._snapToPages = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
		}

		/**
		 * @private
		 */
		protected var _snapOnComplete:Boolean = false;

		/**
		 * @private
		 */
		protected var _horizontalScrollBarFactory:Function = defaultScrollBarFactory;

		/**
		 * Creates the horizontal scroll bar. The horizontal scroll bar must be
		 * an instance of <code>IScrollBar</code>. This factory can be used to
		 * change properties on the horizontal scroll bar when it is first
		 * created. For instance, if you are skinning Feathers components
		 * without a theme, you might use this factory to set skins and other
		 * styles on the horizontal scroll bar.
		 *
		 * <p>This function is expected to have the following signature:</p>
		 *
		 * <pre>function():IScrollBar</pre>
		 *
		 * <p>In the following example, a custom horizontal scroll bar factory
		 * is passed to the scroller:</p>
		 *
		 * <listing version="3.0">
		 * scroller.horizontalScrollBarFactory = function():IScrollBar
		 * {
		 *     return new ScrollBar();
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.IScrollBar
		 */
		public function get horizontalScrollBarFactory():Function
		{
			return this._horizontalScrollBarFactory;
		}

		/**
		 * @private
		 */
		public function set horizontalScrollBarFactory(value:Function):void
		{
			if(this._horizontalScrollBarFactory == value)
			{
				return;
			}
			this._horizontalScrollBarFactory = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL_BAR_RENDERER);
		}

		/**
		 * @private
		 */
		protected var _customHorizontalScrollBarStyleName:String;

		/**
		 * @private
		 */
		public function get customHorizontalScrollBarStyleName():String
		{
			return this._customHorizontalScrollBarStyleName;
		}

		/**
		 * @private
		 */
		public function set customHorizontalScrollBarStyleName(value:String):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._customHorizontalScrollBarStyleName === value)
			{
				return;
			}
			this._customHorizontalScrollBarStyleName = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL_BAR_RENDERER);
		}

		/**
		 * @private
		 */
		protected var _horizontalScrollBarProperties:PropertyProxy;

		/**
		 * An object that stores properties for the container's horizontal
		 * scroll bar, and the properties will be passed down to the horizontal
		 * scroll bar when the container validates. The available properties
		 * depend on which <code>IScrollBar</code> implementation is returned
		 * by <code>horizontalScrollBarFactory</code>. Refer to
		 * <a href="IScrollBar.html"><code>feathers.controls.IScrollBar</code></a>
		 * for a list of available scroll bar implementations.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
		 * which is in a <code>List</code>, you can use the following syntax:</p>
		 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * <p>Setting properties in a <code>horizontalScrollBarFactory</code>
		 * function instead of using <code>horizontalScrollBarProperties</code>
		 * will result in better performance.</p>
		 *
		 * <p>In the following example, properties for the horizontal scroll bar
		 * are passed to the scroller:</p>
		 *
		 * <listing version="3.0">
		 * scroller.horizontalScrollBarProperties.liveDragging = false;</listing>
		 *
		 * @default null
		 *
		 * @see #horizontalScrollBarFactory
		 * @see feathers.controls.IScrollBar
		 * @see feathers.controls.SimpleScrollBar
		 * @see feathers.controls.ScrollBar
		 */
		public function get horizontalScrollBarProperties():Object
		{
			if(!this._horizontalScrollBarProperties)
			{
				this._horizontalScrollBarProperties = new PropertyProxy(childProperties_onChange);
			}
			return this._horizontalScrollBarProperties;
		}

		/**
		 * @private
		 */
		public function set horizontalScrollBarProperties(value:Object):void
		{
			if(this._horizontalScrollBarProperties == value)
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
			if(this._horizontalScrollBarProperties)
			{
				this._horizontalScrollBarProperties.removeOnChangeCallback(childProperties_onChange);
			}
			this._horizontalScrollBarProperties = PropertyProxy(value);
			if(this._horizontalScrollBarProperties)
			{
				this._horizontalScrollBarProperties.addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _verticalScrollBarPosition:String = RelativePosition.RIGHT;

		[Inspectable(type="String",enumeration="right,left")]
		/**
		 * @private
		 */
		public function get verticalScrollBarPosition():String
		{
			return this._verticalScrollBarPosition;
		}

		/**
		 * @private
		 */
		public function set verticalScrollBarPosition(value:String):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._verticalScrollBarPosition === value)
			{
				return;
			}
			this._verticalScrollBarPosition = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		/**
		 * @private
		 */
		protected var _horizontalScrollBarPosition:String = RelativePosition.BOTTOM;

		[Inspectable(type="String",enumeration="bottom,top")]
		/**
		 * @private
		 */
		public function get horizontalScrollBarPosition():String
		{
			return this._horizontalScrollBarPosition;
		}

		/**
		 * @private
		 */
		public function set horizontalScrollBarPosition(value:String):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._horizontalScrollBarPosition === value)
			{
				return;
			}
			this._horizontalScrollBarPosition = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _verticalScrollBarFactory:Function = defaultScrollBarFactory;

		/**
		 * Creates the vertical scroll bar. The vertical scroll bar must be an
		 * instance of <code>Button</code>. This factory can be used to change
		 * properties on the vertical scroll bar when it is first created. For
		 * instance, if you are skinning Feathers components without a theme,
		 * you might use this factory to set skins and other styles on the
		 * vertical scroll bar.
		 *
		 * <p>This function is expected to have the following signature:</p>
		 *
		 * <pre>function():IScrollBar</pre>
		 *
		 * <p>In the following example, a custom vertical scroll bar factory
		 * is passed to the scroller:</p>
		 *
		 * <listing version="3.0">
		 * scroller.verticalScrollBarFactory = function():IScrollBar
		 * {
		 *     return new ScrollBar();
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.IScrollBar
		 */
		public function get verticalScrollBarFactory():Function
		{
			return this._verticalScrollBarFactory;
		}

		/**
		 * @private
		 */
		public function set verticalScrollBarFactory(value:Function):void
		{
			if(this._verticalScrollBarFactory == value)
			{
				return;
			}
			this._verticalScrollBarFactory = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL_BAR_RENDERER);
		}

		/**
		 * @private
		 */
		protected var _customVerticalScrollBarStyleName:String;

		/**
		 * @private
		 */
		public function get customVerticalScrollBarStyleName():String
		{
			return this._customVerticalScrollBarStyleName;
		}

		/**
		 * @private
		 */
		public function set customVerticalScrollBarStyleName(value:String):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._customVerticalScrollBarStyleName === value)
			{
				return;
			}
			this._customVerticalScrollBarStyleName = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL_BAR_RENDERER);
		}

		/**
		 * @private
		 */
		protected var _verticalScrollBarProperties:PropertyProxy;

		/**
		 * An object that stores properties for the container's vertical scroll
		 * bar, and the properties will be passed down to the vertical scroll
		 * bar when the container validates. The available properties depend on
		 * which <code>IScrollBar</code> implementation is returned by
		 * <code>verticalScrollBarFactory</code>. Refer to
		 * <a href="IScrollBar.html"><code>feathers.controls.IScrollBar</code></a>
		 * for a list of available scroll bar implementations.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
		 * which is in a <code>List</code>, you can use the following syntax:</p>
		 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * <p>Setting properties in a <code>verticalScrollBarFactory</code>
		 * function instead of using <code>verticalScrollBarProperties</code>
		 * will result in better performance.</p>
		 *
		 * <p>In the following example, properties for the vertical scroll bar
		 * are passed to the container:</p>
		 *
		 * <listing version="3.0">
		 * scroller.verticalScrollBarProperties.liveDragging = false;</listing>
		 *
		 * @default null
		 *
		 * @see #verticalScrollBarFactory
		 * @see feathers.controls.IScrollBar
		 * @see feathers.controls.SimpleScrollBar
		 * @see feathers.controls.ScrollBar
		 */
		public function get verticalScrollBarProperties():Object
		{
			if(!this._verticalScrollBarProperties)
			{
				this._verticalScrollBarProperties = new PropertyProxy(childProperties_onChange);
			}
			return this._verticalScrollBarProperties;
		}

		/**
		 * @private
		 */
		public function set verticalScrollBarProperties(value:Object):void
		{
			if(this._horizontalScrollBarProperties == value)
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
			if(this._verticalScrollBarProperties)
			{
				this._verticalScrollBarProperties.removeOnChangeCallback(childProperties_onChange);
			}
			this._verticalScrollBarProperties = PropertyProxy(value);
			if(this._verticalScrollBarProperties)
			{
				this._verticalScrollBarProperties.addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var actualHorizontalScrollStep:Number = 1;

		/**
		 * @private
		 */
		protected var explicitHorizontalScrollStep:Number = NaN;

		/**
		 * The number of pixels the horizontal scroll position can be adjusted
		 * by a "step". Passed to the horizontal scroll bar, if one exists.
		 * Touch scrolling is not affected by the step value.
		 *
		 * <p>In the following example, the horizontal scroll step is customized:</p>
		 *
		 * <listing version="3.0">
		 * scroller.horizontalScrollStep = 0;</listing>
		 *
		 * @default NaN
		 */
		public function get horizontalScrollStep():Number
		{
			return this.actualHorizontalScrollStep;
		}

		/**
		 * @private
		 */
		public function set horizontalScrollStep(value:Number):void
		{
			if(this.explicitHorizontalScrollStep == value)
			{
				return;
			}
			this.explicitHorizontalScrollStep = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
		}

		/**
		 * @private
		 */
		protected var _targetHorizontalScrollPosition:Number;

		/**
		 * @private
		 */
		protected var _horizontalScrollPosition:Number = 0;

		/**
		 * The number of pixels the container has been scrolled horizontally (on
		 * the x-axis).
		 *
		 * <p>In the following example, the horizontal scroll position is customized:</p>
		 *
		 * <listing version="3.0">
		 * scroller.horizontalScrollPosition = scroller.maxHorizontalScrollPosition;</listing>
		 *
		 * @see #minHorizontalScrollPosition
		 * @see #maxHorizontalScrollPosition
		 */
		public function get horizontalScrollPosition():Number
		{
			return this._horizontalScrollPosition;
		}

		/**
		 * @private
		 */
		public function set horizontalScrollPosition(value:Number):void
		{
			if(this._horizontalScrollPosition == value)
			{
				return;
			}
			if(value !== value) //isNaN
			{
				//there isn't any recovery from this, so stop it early
				throw new ArgumentError("horizontalScrollPosition cannot be NaN.");
			}
			this._horizontalScrollPosition = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
		}

		/**
		 * @private
		 */
		protected var _minHorizontalScrollPosition:Number = 0;

		/**
		 * The number of pixels the scroller may be scrolled horizontally to the
		 * left. This value is automatically calculated based on the bounds of
		 * the viewport. The <code>horizontalScrollPosition</code> property may
		 * have a lower value than the minimum due to elastic edges. However,
		 * once the user stops interacting with the scroller, it will
		 * automatically animate back to the maximum or minimum position.
		 *
		 * @see #horizontalScrollPosition
		 * @see #maxHorizontalScrollPosition
		 */
		public function get minHorizontalScrollPosition():Number
		{
			return this._minHorizontalScrollPosition;
		}

		/**
		 * @private
		 */
		protected var _maxHorizontalScrollPosition:Number = 0;

		/**
		 * The number of pixels the scroller may be scrolled horizontally to the
		 * right. This value is automatically calculated based on the bounds of
		 * the viewport. The <code>horizontalScrollPosition</code> property may
		 * have a higher value than the maximum due to elastic edges. However,
		 * once the user stops interacting with the scroller, it will
		 * automatically animate back to the maximum or minimum position.
		 *
		 * @see #horizontalScrollPosition
		 * @see #minHorizontalScrollPosition
		 */
		public function get maxHorizontalScrollPosition():Number
		{
			return this._maxHorizontalScrollPosition;
		}

		/**
		 * @private
		 */
		protected var _horizontalPageIndex:int = 0;

		/**
		 * The index of the horizontal page, if snapping is enabled. If snapping
		 * is disabled, the index will always be <code>0</code>.
		 * 
		 * @see #horizontalPageCount
		 * @see #minHorizontalPageIndex
		 * @see #maxHorizontalPageIndex
		 */
		public function get horizontalPageIndex():int
		{
			if(this.hasPendingHorizontalPageIndex)
			{
				return this.pendingHorizontalPageIndex;
			}
			return this._horizontalPageIndex;
		}

		/**
		 * @private
		 */
		public function set horizontalPageIndex(value:int):void
		{
			if(!this._snapToPages)
			{
				throw new IllegalOperationError("The horizontalPageIndex may not be set if snapToPages is false.");
			}
			this.hasPendingHorizontalPageIndex = false;
			this.pendingHorizontalScrollPosition = NaN;
			if(this._horizontalPageIndex == value)
			{
				return;
			}
			if(!this.isInvalid())
			{
				if(value < this._minHorizontalPageIndex)
				{
					value = this._minHorizontalPageIndex;
				}
				else if(value > this._maxHorizontalPageIndex)
				{
					value = this._maxHorizontalPageIndex;
				}
				this._horizontalScrollPosition = this.actualPageWidth * value;
			}
			else
			{
				//minimum and maximum values haven't been calculated yet, so we
				//need to wait for validation to change the scroll position
				this.hasPendingHorizontalPageIndex = true;
				this.pendingHorizontalPageIndex = value;
				this.pendingScrollDuration = 0;
			}
			this.invalidate(INVALIDATION_FLAG_SCROLL);
		}

		/**
		 * @private
		 */
		protected var _minHorizontalPageIndex:int = 0;

		/**
		 * The minimum horizontal page index that may be displayed by this
		 * container, if page snapping is enabled.
		 *
		 * @see #snapToPages
		 * @see #horizontalPageCount
		 * @see #maxHorizontalPageIndex
		 */
		public function get minHorizontalPageIndex():int
		{
			return this._minHorizontalPageIndex;
		}

		/**
		 * @private
		 */
		protected var _maxHorizontalPageIndex:int = 0;

		/**
		 * The maximum horizontal page index that may be displayed by this
		 * container, if page snapping is enabled.
		 *
		 * @see #snapToPages
		 * @see #horizontalPageCount
		 * @see #minHorizontalPageIndex
		 */
		public function get maxHorizontalPageIndex():int
		{
			return this._maxHorizontalPageIndex;
		}

		/**
		 * The number of horizontal pages, if snapping is enabled. If snapping
		 * is disabled, the page count will always be <code>1</code>.
		 *
		 * <p>If the scroller's view port supports infinite scrolling, this
		 * property will return <code>int.MAX_VALUE</code>, since an
		 * <code>int</code> cannot hold the value <code>Number.POSITIVE_INFINITY</code>.</p>
		 *
		 * @see #snapToPages
		 * @see #horizontalPageIndex
		 * @see #minHorizontalPageIndex
		 * @see #maxHorizontalPageIndex
		 */
		public function get horizontalPageCount():int
		{
			if(this._maxHorizontalPageIndex == int.MAX_VALUE ||
				this._minHorizontalPageIndex == int.MIN_VALUE)
			{
				return int.MAX_VALUE;
			}
			return this._maxHorizontalPageIndex - this._minHorizontalPageIndex + 1;
		}

		/**
		 * @private
		 */
		protected var _horizontalScrollPolicy:String = ScrollPolicy.AUTO;

		[Inspectable(type="String",enumeration="auto,on,off")]
		/**
		 * Determines whether the scroller may scroll horizontally (on the
		 * x-axis) or not.
		 *
		 * <p>In the following example, horizontal scrolling is disabled:</p>
		 *
		 * <listing version="3.0">
		 * scroller.horizontalScrollPolicy = ScrollPolicy.OFF;</listing>
		 *
		 * @default feathers.controls.ScrollPolicy.AUTO
		 *
		 * @see feathers.controls.ScrollPolicy#AUTO
		 * @see feathers.controls.ScrollPolicy#ON
		 * @see feathers.controls.ScrollPolicy#OFF
		 */
		public function get horizontalScrollPolicy():String
		{
			return this._horizontalScrollPolicy;
		}

		/**
		 * @private
		 */
		public function set horizontalScrollPolicy(value:String):void
		{
			if(this._horizontalScrollPolicy == value)
			{
				return;
			}
			this._horizontalScrollPolicy = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
			this.invalidate(INVALIDATION_FLAG_SCROLL_BAR_RENDERER);
		}

		/**
		 * @private
		 */
		protected var actualVerticalScrollStep:Number = 1;

		/**
		 * @private
		 */
		protected var explicitVerticalScrollStep:Number = NaN;

		/**
		 * The number of pixels the vertical scroll position can be adjusted
		 * by a "step". Passed to the vertical scroll bar, if one exists.
		 * Touch scrolling is not affected by the step value.
		 *
		 * <p>In the following example, the vertical scroll step is customized:</p>
		 *
		 * <listing version="3.0">
		 * scroller.verticalScrollStep = 0;</listing>
		 *
		 * @default NaN
		 */
		public function get verticalScrollStep():Number
		{
			return this.actualVerticalScrollStep;
		}

		/**
		 * @private
		 */
		public function set verticalScrollStep(value:Number):void
		{
			if(this.explicitVerticalScrollStep == value)
			{
				return;
			}
			this.explicitVerticalScrollStep = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
		}

		/**
		 * @private
		 */
		protected var _verticalMouseWheelScrollStep:Number = NaN;

		/**
		 * The number of pixels the vertical scroll position can be adjusted by
		 * a "step" when using the mouse wheel. If this value is
		 * <code>NaN</code>, the mouse wheel will use the same scroll step as the scroll bars.
		 *
		 * <p>In the following example, the vertical mouse wheel scroll step is
		 * customized:</p>
		 *
		 * <listing version="3.0">
		 * scroller.verticalMouseWheelScrollStep = 10;</listing>
		 *
		 * @default NaN
		 */
		public function get verticalMouseWheelScrollStep():Number
		{
			return this._verticalMouseWheelScrollStep;
		}

		/**
		 * @private
		 */
		public function set verticalMouseWheelScrollStep(value:Number):void
		{
			if(this._verticalMouseWheelScrollStep == value)
			{
				return;
			}
			this._verticalMouseWheelScrollStep = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
		}

		/**
		 * @private
		 */
		protected var _targetVerticalScrollPosition:Number;

		/**
		 * @private
		 */
		protected var _verticalScrollPosition:Number = 0;

		/**
		 * The number of pixels the container has been scrolled vertically (on
		 * the y-axis).
		 *
		 * <p>In the following example, the vertical scroll position is customized:</p>
		 *
		 * <listing version="3.0">
		 * scroller.verticalScrollPosition = scroller.maxVerticalScrollPosition;</listing>
		 * 
		 * @see #minVerticalScrollPosition
		 * @see #maxVerticalScrollPosition
		 */
		public function get verticalScrollPosition():Number
		{
			return this._verticalScrollPosition;
		}

		/**
		 * @private
		 */
		public function set verticalScrollPosition(value:Number):void
		{
			if(this._verticalScrollPosition == value)
			{
				return;
			}
			if(value !== value) //isNaN
			{
				//there isn't any recovery from this, so stop it early
				throw new ArgumentError("verticalScrollPosition cannot be NaN.");
			}
			this._verticalScrollPosition = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
		}

		/**
		 * @private
		 */
		protected var _minVerticalScrollPosition:Number = 0;

		/**
		 * The number of pixels the scroller may be scrolled vertically beyond
		 * the top edge. This value is automatically calculated based on the
		 * bounds of the viewport. The <code>verticalScrollPosition</code>
		 * property may have a lower value than the minimum due to elastic
		 * edges. However, once the user stops interacting with the scroller, it
		 * will automatically animate back to the maximum or minimum position.
		 *
		 * @see #verticalScrollPosition
		 * @see #maxVerticalScrollPosition
		 */
		public function get minVerticalScrollPosition():Number
		{
			return this._minVerticalScrollPosition;
		}

		/**
		 * @private
		 */
		protected var _maxVerticalScrollPosition:Number = 0;

		/**
		 * The number of pixels the scroller may be scrolled vertically beyond
		 * the bottom edge. This value is automatically calculated based on the
		 * bounds of the viewport. The <code>verticalScrollPosition</code>
		 * property may have a lower value than the minimum due to elastic
		 * edges. However, once the user stops interacting with the scroller, it
		 * will automatically animate back to the maximum or minimum position.
		 *
		 * @see #verticalScrollPosition
		 * @see #minVerticalScrollPosition
		 */
		public function get maxVerticalScrollPosition():Number
		{
			return this._maxVerticalScrollPosition;
		}

		/**
		 * @private
		 */
		protected var _verticalPageIndex:int = 0;

		/**
		 * The index of the vertical page, if snapping is enabled. If snapping
		 * is disabled, the index will always be <code>0</code>.
		 *
		 * @see #verticalPageCount
		 * @see #minVerticalPageIndex
		 * @see #maxVerticalPageIndex
		 */
		public function get verticalPageIndex():int
		{
			if(this.hasPendingVerticalPageIndex)
			{
				return this.pendingVerticalPageIndex;
			}
			return this._verticalPageIndex;
		}

		/**
		 * @private
		 */
		public function set verticalPageIndex(value:int):void
		{
			if(!this._snapToPages)
			{
				throw new IllegalOperationError("The verticalPageIndex may not be set if snapToPages is false.");
			}
			this.hasPendingVerticalPageIndex = false;
			this.pendingVerticalScrollPosition = NaN;
			if(this._verticalPageIndex == value)
			{
				return;
			}
			if(!this.isInvalid())
			{
				if(value < this._minVerticalPageIndex)
				{
					value = this._minVerticalPageIndex;
				}
				else if(value > this._maxVerticalPageIndex)
				{
					value = this._maxVerticalPageIndex;
				}
				this._verticalScrollPosition = this.actualPageHeight * value;
			}
			else
			{
				//minimum and maximum values haven't been calculated yet, so we
				//need to wait for validation to change the scroll position
				this.hasPendingVerticalPageIndex = true;
				this.pendingVerticalPageIndex = value;
				this.pendingScrollDuration = 0;
			}
			this.invalidate(INVALIDATION_FLAG_SCROLL);
		}

		/**
		 * @private
		 */
		protected var _minVerticalPageIndex:int = 0;

		/**
		 * The minimum vertical page index that may be displayed by this
		 * container, if page snapping is enabled.
		 *
		 * @see #snapToPages
		 * @see #verticalPageCount
		 * @see #maxVerticalPageIndex
		 */
		public function get minVerticalPageIndex():int
		{
			return this._minVerticalPageIndex;
		}

		/**
		 * @private
		 */
		protected var _maxVerticalPageIndex:int = 0;

		/**
		 * The maximum vertical page index that may be displayed by this
		 * container, if page snapping is enabled.
		 *
		 * @see #snapToPages
		 * @see #verticalPageCount
		 * @see #minVerticalPageIndex
		 */
		public function get maxVerticalPageIndex():int
		{
			return this._maxVerticalPageIndex;
		}

		/**
		 * The number of vertical pages, if snapping is enabled. If snapping
		 * is disabled, the page count will always be <code>1</code>.
		 *
		 * <p>If the scroller's view port supports infinite scrolling, this
		 * property will return <code>int.MAX_VALUE</code>, since an
		 * <code>int</code> cannot hold the value <code>Number.POSITIVE_INFINITY</code>.</p>
		 *
		 * @see #snapToPages
		 * @see #verticalPageIndex
		 * @see #minVerticalPageIndex
		 * @see #maxVerticalPageIndex
		 */
		public function get verticalPageCount():int
		{
			if(this._maxVerticalPageIndex == int.MAX_VALUE ||
				this._minVerticalPageIndex == int.MIN_VALUE)
			{
				return int.MAX_VALUE;
			}
			return this._maxVerticalPageIndex - this._minVerticalPageIndex + 1;
		}

		/**
		 * @private
		 */
		protected var _verticalScrollPolicy:String = ScrollPolicy.AUTO;

		[Inspectable(type="String",enumeration="auto,on,off")]
		/**
		 * Determines whether the scroller may scroll vertically (on the
		 * y-axis) or not.
		 *
		 * <p>In the following example, vertical scrolling is disabled:</p>
		 *
		 * <listing version="3.0">
		 * scroller.verticalScrollPolicy = ScrollPolicy.OFF;</listing>
		 *
		 * @default feathers.controls.ScrollPolicy.AUTO
		 *
		 * @see feathers.controls.ScrollPolicy#AUTO
		 * @see feathers.controls.ScrollPolicy#ON
		 * @see feathers.controls.ScrollPolicy#OFF
		 */
		public function get verticalScrollPolicy():String
		{
			return this._verticalScrollPolicy;
		}

		/**
		 * @private
		 */
		public function set verticalScrollPolicy(value:String):void
		{
			if(this._verticalScrollPolicy == value)
			{
				return;
			}
			this._verticalScrollPolicy = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
			this.invalidate(INVALIDATION_FLAG_SCROLL_BAR_RENDERER);
		}

		/**
		 * @private
		 */
		protected var _clipContent:Boolean = true;

		/**
		 * @private
		 */
		public function get clipContent():Boolean
		{
			return this._clipContent;
		}

		/**
		 * @private
		 */
		public function set clipContent(value:Boolean):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._clipContent === value)
			{
				return;
			}
			this._clipContent = value;
			if(!value && this._viewPort)
			{
				this._viewPort.mask = null;
			}
			this.invalidate(INVALIDATION_FLAG_CLIPPING);
		}

		/**
		 * @private
		 */
		protected var actualPageWidth:Number = 0;

		/**
		 * @private
		 */
		protected var explicitPageWidth:Number = NaN;

		/**
		 * When set, the horizontal pages snap to this width value instead of
		 * the width of the scroller.
		 *
		 * <p>In the following example, the page width is set to 200 pixels:</p>
		 *
		 * <listing version="3.0">
		 * scroller.pageWidth = 200;</listing>
		 *
		 * @see #snapToPages
		 */
		public function get pageWidth():Number
		{
			return this.actualPageWidth;
		}

		/**
		 * @private
		 */
		public function set pageWidth(value:Number):void
		{
			if(this.explicitPageWidth == value)
			{
				return;
			}
			var valueIsNaN:Boolean = value !== value; //isNaN
			if(valueIsNaN && this.explicitPageWidth !== this.explicitPageWidth) //isNaN
			{
				return;
			}
			this.explicitPageWidth = value;
			if(valueIsNaN)
			{
				//we need to calculate this value during validation
				this.actualPageWidth = 0;
			}
			else
			{
				this.actualPageWidth = this.explicitPageWidth;
			}
		}

		/**
		 * @private
		 */
		protected var actualPageHeight:Number = 0;

		/**
		 * @private
		 */
		protected var explicitPageHeight:Number = NaN;

		/**
		 * When set, the vertical pages snap to this height value instead of
		 * the height of the scroller.
		 *
		 * <p>In the following example, the page height is set to 200 pixels:</p>
		 *
		 * <listing version="3.0">
		 * scroller.pageHeight = 200;</listing>
		 *
		 * @see #snapToPages
		 */
		public function get pageHeight():Number
		{
			return this.actualPageHeight;
		}

		/**
		 * @private
		 */
		public function set pageHeight(value:Number):void
		{
			if(this.explicitPageHeight == value)
			{
				return;
			}
			var valueIsNaN:Boolean = value !== value; //isNaN
			if(valueIsNaN && this.explicitPageHeight !== this.explicitPageHeight) //isNaN
			{
				return;
			}
			this.explicitPageHeight = value;
			if(valueIsNaN)
			{
				//we need to calculate this value during validation
				this.actualPageHeight = 0;
			}
			else
			{
				this.actualPageHeight = this.explicitPageHeight;
			}
		}

		/**
		 * @private
		 */
		protected var _hasElasticEdges:Boolean = true;

		/**
		 * @private
		 */
		public function get hasElasticEdges():Boolean
		{
			return this._hasElasticEdges;
		}

		/**
		 * @private
		 */
		public function set hasElasticEdges(value:Boolean):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			this._hasElasticEdges = value;
		}

		/**
		 * @private
		 */
		protected var _elasticity:Number = 0.33;

		/**
		 * @private
		 */
		public function get elasticity():Number
		{
			return this._elasticity;
		}

		/**
		 * @private
		 */
		public function set elasticity(value:Number):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			this._elasticity = value;
		}

		/**
		 * @private
		 */
		protected var _throwElasticity:Number = 0.05;

		/**
		 * @private
		 */
		public function get throwElasticity():Number
		{
			return this._throwElasticity;
		}

		/**
		 * @private
		 */
		public function set throwElasticity(value:Number):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			this._throwElasticity = value;
		}

		/**
		 * @private
		 */
		protected var _scrollBarDisplayMode:String = ScrollBarDisplayMode.FLOAT;

		[Inspectable(type="String",enumeration="float,fixed,fixedFloat,none")]
		/**
		 * @private
		 */
		public function get scrollBarDisplayMode():String
		{
			return this._scrollBarDisplayMode;
		}

		/**
		 * @private
		 */
		public function set scrollBarDisplayMode(value:String):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._scrollBarDisplayMode === value)
			{
				return;
			}
			this._scrollBarDisplayMode = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _interactionMode:String = ScrollInteractionMode.TOUCH;

		[Inspectable(type="String",enumeration="touch,mouse,touchAndScrollBars")]
		/**
		 * @private
		 */
		public function get interactionMode():String
		{
			return this._interactionMode;
		}

		/**
		 * @private
		 */
		public function set interactionMode(value:String):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._interactionMode === value)
			{
				return;
			}
			this._interactionMode = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _explicitBackgroundWidth:Number;

		/**
		 * @private
		 */
		protected var _explicitBackgroundHeight:Number;

		/**
		 * @private
		 */
		protected var _explicitBackgroundMinWidth:Number;

		/**
		 * @private
		 */
		protected var _explicitBackgroundMinHeight:Number;

		/**
		 * @private
		 */
		protected var _explicitBackgroundMaxWidth:Number;

		/**
		 * @private
		 */
		protected var _explicitBackgroundMaxHeight:Number;

		/**
		 * @private
		 */
		protected var currentBackgroundSkin:DisplayObject;

		/**
		 * @private
		 */
		protected var _backgroundSkin:DisplayObject;

		/**
		 * @private
		 */
		public function get backgroundSkin():DisplayObject
		{
			return this._backgroundSkin;
		}

		/**
		 * @private
		 */
		public function set backgroundSkin(value:DisplayObject):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				if(value !== null)
				{
					value.dispose();
				}
				return;
			}
			if(this._backgroundSkin === value)
			{
				return;
			}
			if(this._backgroundSkin !== null &&
				this.currentBackgroundSkin === this._backgroundSkin)
			{
				this.removeCurrentBackgroundSkin(this._backgroundSkin);
				this.currentBackgroundSkin = null;
			}
			this._backgroundSkin = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _backgroundDisabledSkin:DisplayObject;

		/**
		 * @private
		 */
		public function get backgroundDisabledSkin():DisplayObject
		{
			return this._backgroundDisabledSkin;
		}

		/**
		 * @private
		 */
		public function set backgroundDisabledSkin(value:DisplayObject):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				if(value !== null)
				{
					value.dispose();
				}
				return;
			}
			if(this._backgroundDisabledSkin === value)
			{
				return;
			}
			if(this._backgroundDisabledSkin !== null &&
				this.currentBackgroundSkin === this._backgroundDisabledSkin)
			{
				this.removeCurrentBackgroundSkin(this._backgroundDisabledSkin);
				this.currentBackgroundSkin = null;
			}
			this._backgroundDisabledSkin = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _autoHideBackground:Boolean = false;

		/**
		 * @private
		 */
		public function get autoHideBackground():Boolean
		{
			return this._autoHideBackground;
		}

		/**
		 * @private
		 */
		public function set autoHideBackground(value:Boolean):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._autoHideBackground === value)
			{
				return;
			}
			this._autoHideBackground = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _minimumDragDistance:Number = 0.04;

		/**
		 * The minimum physical distance (in inches) that a touch must move
		 * before the scroller starts scrolling.
		 *
		 * <p>In the following example, the minimum drag distance is customized:</p>
		 *
		 * <listing version="3.0">
		 * scroller.minimumDragDistance = 0.1;</listing>
		 *
		 * @default 0.04
		 */
		public function get minimumDragDistance():Number
		{
			return this._minimumDragDistance;
		}

		/**
		 * @private
		 */
		public function set minimumDragDistance(value:Number):void
		{
			this._minimumDragDistance = value;
		}

		/**
		 * @private
		 */
		protected var _minimumPageThrowVelocity:Number = 5;

		/**
		 * The minimum physical velocity (in inches per second) that a touch
		 * must move before the scroller will "throw" to the next page.
		 * Otherwise, it will settle to the nearest page.
		 *
		 * <p>In the following example, the minimum page throw velocity is customized:</p>
		 *
		 * <listing version="3.0">
		 * scroller.minimumPageThrowVelocity = 2;</listing>
		 *
		 * @default 5
		 */
		public function get minimumPageThrowVelocity():Number
		{
			return this._minimumPageThrowVelocity;
		}

		/**
		 * @private
		 */
		public function set minimumPageThrowVelocity(value:Number):void
		{
			this._minimumPageThrowVelocity = value;
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
		protected var _horizontalScrollBarHideTween:Tween;

		/**
		 * @private
		 */
		protected var _verticalScrollBarHideTween:Tween;

		/**
		 * @private
		 */
		protected var _hideScrollBarAnimationDuration:Number = 0.2;

		/**
		 * @private
		 */
		public function get hideScrollBarAnimationDuration():Number
		{
			return this._hideScrollBarAnimationDuration;
		}

		/**
		 * @private
		 */
		public function set hideScrollBarAnimationDuration(value:Number):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			this._hideScrollBarAnimationDuration = value;
		}

		/**
		 * @private
		 */
		protected var _hideScrollBarAnimationEase:Object = Transitions.EASE_OUT;

		/**
		 * @private
		 */
		public function get hideScrollBarAnimationEase():Object
		{
			return this._hideScrollBarAnimationEase;
		}

		/**
		 * @private
		 */
		public function set hideScrollBarAnimationEase(value:Object):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			this._hideScrollBarAnimationEase = value;
		}

		/**
		 * @private
		 */
		protected var _elasticSnapDuration:Number = 0.5;

		/**
		 * @private
		 */
		public function get elasticSnapDuration():Number
		{
			return this._elasticSnapDuration;
		}

		/**
		 * @private
		 */
		public function set elasticSnapDuration(value:Number):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			this._elasticSnapDuration = value;
		}

		/**
		 * @private
		 * This value is precalculated. See the <code>decelerationRate</code>
		 * setter for the dynamic calculation.
		 */
		protected var _logDecelerationRate:Number = -0.0020020026706730793;

		/**
		 * @private
		 */
		protected var _decelerationRate:Number = DecelerationRate.NORMAL;

		/**
		 * @private
		 */
		public function get decelerationRate():Number
		{
			return this._decelerationRate;
		}

		/**
		 * @private
		 */
		public function set decelerationRate(value:Number):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._decelerationRate == value)
			{
				return;
			}
			this._decelerationRate = value;
			this._logDecelerationRate = Math.log(this._decelerationRate);
			this._fixedThrowDuration = -0.1 / Math.log(Math.pow(this._decelerationRate, 1000 / 60))
		}

		/**
		 * @private
		 * This value is precalculated. See the <code>decelerationRate</code>
		 * setter for the dynamic calculation.
		 */
		protected var _fixedThrowDuration:Number = 2.996998998998728;

		/**
		 * @private
		 */
		protected var _useFixedThrowDuration:Boolean = true;

		/**
		 * @private
		 */
		public function get useFixedThrowDuration():Boolean
		{
			return this._useFixedThrowDuration;
		}

		/**
		 * @private
		 */
		public function set useFixedThrowDuration(value:Boolean):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			this._useFixedThrowDuration = value;
		}

		/**
		 * @private
		 */
		protected var _pageThrowDuration:Number = 0.5;

		/**
		 * @private
		 */
		public function get pageThrowDuration():Number
		{
			return this._pageThrowDuration;
		}

		/**
		 * @private
		 */
		public function set pageThrowDuration(value:Number):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			this._pageThrowDuration = value;
		}

		/**
		 * @private
		 */
		protected var _mouseWheelScrollDuration:Number = 0.35;

		/**
		 * @private
		 */
		public function get mouseWheelScrollDuration():Number
		{
			return this._mouseWheelScrollDuration;
		}

		/**
		 * @private
		 */
		public function set mouseWheelScrollDuration(value:Number):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			this._mouseWheelScrollDuration = value;
		}

		/**
		 * @private
		 */
		protected var _verticalMouseWheelScrollDirection:String = Direction.VERTICAL;

		/**
		 * The direction of scrolling when the user scrolls the mouse wheel
		 * vertically. In some cases, it is common for a container that only
		 * scrolls horizontally to scroll even when the mouse wheel is scrolled
		 * vertically.
		 *
		 * <p>In the following example, the direction of scrolling when using
		 * the mouse wheel is changed:</p>
		 *
		 * <listing version="3.0">
		 * scroller.verticalMouseWheelScrollDirection = Direction.HORIZONTAL;</listing>
		 *
		 * @default feathers.layout.Direction.VERTICAL
		 *
		 * @see feathers.layout.Direction#HORIZONTAL
		 * @see feathers.layout.Direction#VERTICAL
		 */
		public function get verticalMouseWheelScrollDirection():String
		{
			return this._verticalMouseWheelScrollDirection;
		}

		/**
		 * @private
		 */
		public function set verticalMouseWheelScrollDirection(value:String):void
		{
			this._verticalMouseWheelScrollDirection = value;
		}

		/**
		 * @private
		 */
		protected var _throwEase:Object = defaultThrowEase;

		/**
		 * @private
		 */
		public function get throwEase():Object
		{
			return this._throwEase;
		}

		/**
		 * @private
		 */
		public function set throwEase(value:Object):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(value == null)
			{
				value = defaultThrowEase;
			}
			this._throwEase = value;
		}

		/**
		 * @private
		 */
		protected var _snapScrollPositionsToPixels:Boolean = true;

		/**
		 * @private
		 */
		public function get snapScrollPositionsToPixels():Boolean
		{
			return this._snapScrollPositionsToPixels;
		}

		/**
		 * @private
		 */
		public function set snapScrollPositionsToPixels(value:Boolean):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._snapScrollPositionsToPixels === value)
			{
				return;
			}
			this._snapScrollPositionsToPixels = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
		}

		/**
		 * @private
		 */
		protected var _horizontalScrollBarIsScrolling:Boolean = false;

		/**
		 * @private
		 */
		protected var _verticalScrollBarIsScrolling:Boolean = false;

		/**
		 * @private
		 */
		protected var _isScrolling:Boolean = false;

		/**
		 * Determines if the scroller is currently scrolling with user
		 * interaction or with animation.
		 */
		public function get isScrolling():Boolean
		{
			return this._isScrolling;
		}

		/**
		 * @private
		 */
		protected var _isScrollingStopped:Boolean = false;

		/**
		 * The pending horizontal scroll position to scroll to after validating.
		 * A value of <code>NaN</code> means that the scroller won't scroll to a
		 * horizontal position after validating.
		 */
		protected var pendingHorizontalScrollPosition:Number = NaN;

		/**
		 * The pending vertical scroll position to scroll to after validating.
		 * A value of <code>NaN</code> means that the scroller won't scroll to a
		 * vertical position after validating.
		 */
		protected var pendingVerticalScrollPosition:Number = NaN;

		/**
		 * A flag that indicates if the scroller should scroll to a new page
		 * when it validates. If <code>true</code>, it will use the value of
		 * <code>pendingHorizontalPageIndex</code> as the target page index.
		 * 
		 * @see #pendingHorizontalPageIndex
		 */
		protected var hasPendingHorizontalPageIndex:Boolean = false;

		/**
		 * A flag that indicates if the scroller should scroll to a new page
		 * when it validates. If <code>true</code>, it will use the value of
		 * <code>pendingVerticalPageIndex</code> as the target page index.
		 *
		 * @see #pendingVerticalPageIndex
		 */
		protected var hasPendingVerticalPageIndex:Boolean = false;

		/**
		 * The pending horizontal page index to scroll to after validating. The
		 * flag <code>hasPendingHorizontalPageIndex</code> must be set to true
		 * if there is a pending page index to scroll to.
		 * 
		 * @see #hasPendingHorizontalPageIndex
		 */
		protected var pendingHorizontalPageIndex:int;

		/**
		 * The pending vertical page index to scroll to after validating. The
		 * flag <code>hasPendingVerticalPageIndex</code> must be set to true
		 * if there is a pending page index to scroll to.
		 *
		 * @see #hasPendingVerticalPageIndex
		 */
		protected var pendingVerticalPageIndex:int;

		/**
		 * The duration of the pending scroll action.
		 */
		protected var pendingScrollDuration:Number;

		/**
		 * @private
		 */
		protected var isScrollBarRevealPending:Boolean = false;

		/**
		 * @private
		 */
		protected var _revealScrollBarsDuration:Number = 1.0;

		/**
		 * @private
		 */
		public function get revealScrollBarsDuration():Number
		{
			return this._revealScrollBarsDuration;
		}

		/**
		 * @private
		 */
		public function set revealScrollBarsDuration(value:Number):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			this._revealScrollBarsDuration = value;
		}

		/**
		 * @private
		 */
		protected var _isTopPullViewPending:Boolean = false;

		/**
		 * @private
		 */
		protected var _isTopPullViewActive:Boolean = false;

		/**
		 * Indicates if the <code>topPullView</code> has been activated. Set to
		 * <code>false</code> to close the <code>topPullView</code>.
		 * 
		 * <p>Note: Manually setting <code>isTopPullViewActive</code> to
		 * <code>true</code> will not result in <code>Event.UPDATE</code> being
		 * dispatched.</p>
		 * 
		 * @see #topPullView
		 */
		public function get isTopPullViewActive():Boolean
		{
			return this._isTopPullViewActive;
		}

		/**
		 * @private
		 */
		public function set isTopPullViewActive(value:Boolean):void
		{
			if(this._isTopPullViewActive === value)
			{
				return;
			}
			if(this._topPullView === null)
			{
				return;
			}
			this._isTopPullViewActive = value;
			this._isTopPullViewPending = true;
			this.invalidate(INVALIDATION_FLAG_PENDING_PULL_VIEW);
		}

		/**
		 * @private
		 */
		protected var _topPullView:DisplayObject = null;

		/**
		 * A view that is displayed at the top of the scroller's view port when
		 * dragging down.
		 *
		 * <strong>Events</strong>
		 * 
		 * <p>The scroller will dispatch <code>FeathersEventType.PULLING</code>
		 * on the pull view as it is dragged into view. The event's
		 * <code>data</code> property will be a value between <code>0</code> and
		 * <code>1</code> to indicate how far the pull view has been dragged so
		 * far. A value of <code>1</code> does not necessarily indicate that
		 * the pull view has been activated yet. A value greater than
		 * <code>1</code> is possible if <code>hasElasticEdges</code> is
		 * <code>true</code>.</p>
		 * 
		 * <p>When the pull view is activated by the user, the scroller will
		 * dispatch <code>Event.UPDATE</code>. When the pull view should
		 * be deactivated, set the <code>isTopPullViewActive</code> property
		 * to <code>false</code>.</p>
		 * 
		 * @default null
		 *
		 * @see #isTopPullViewActive
		 * @see #topPullViewDisplayMode
		 * @see #event:update starling.events.Event.UPDATE
		 */
		public function get topPullView():DisplayObject
		{
			return this._topPullView;
		}

		/**
		 * @private
		 */
		public function set topPullView(value:DisplayObject):void
		{
			if(this._topPullView !== null)
			{
				this._topPullView.mask.dispose();
				this._topPullView.mask = null;
				if(this._topPullView.parent === this)
				{
					this.removeRawChildInternal(this._topPullView, false);
				}
			}
			this._topPullView = value;
			if(this._topPullView !== null)
			{
				this._topPullView.mask = new Quad(1, 1, 0xff00ff);
				this._topPullView.visible = false;
				this.addRawChildInternal(this._topPullView);
			}
			else
			{
				this.isTopPullViewActive = false;
			}
		}

		/**
		 * @private
		 */
		protected var _topPullViewDisplayMode:String = PullViewDisplayMode.DRAG;

		/**
		 * Indicates whether the top pull view may be dragged with the content,
		 * or if its position is fixed to the edge of the scroller.
		 *
		 * @default feathers.controls.PullViewDisplayMode.DRAG
		 *
		 * @see feathers.controls.PullViewDisplayMode#DRAG
		 * @see feathers.controls.PullViewDisplayMode#FIXED
		 * @see #topPullView
		 */
		public function get topPullViewDisplayMode():String
		{
			return this._topPullViewDisplayMode;
		}

		/**
		 * @private
		 */
		public function set topPullViewDisplayMode(value:String):void
		{
			if(this._topPullViewDisplayMode === value)
			{
				return;
			}
			this._topPullViewDisplayMode = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _topPullViewRatio:Number = 0;

		/**
		 * @private
		 */
		protected function get topPullViewRatio():Number
		{
			return this._topPullViewRatio;
		}

		/**
		 * @private
		 */
		protected function set topPullViewRatio(value:Number):void
		{
			if(this._topPullViewRatio == value)
			{
				return;
			}
			this._topPullViewRatio = value;
			if(!this._isTopPullViewActive && this._topPullView !== null)
			{
				this._topPullView.dispatchEventWith(FeathersEventType.PULLING, false, value);
			}
		}

		/**
		 * @private
		 */
		protected var _isRightPullViewPending:Boolean = false;

		/**
		 * @private
		 */
		protected var _isRightPullViewActive:Boolean = false;

		/**
		 * Indicates if the <code>rightPullView</code> has been activated. Set
		 * to <code>false</code> to close the <code>rightPullView</code>.
		 *
		 * <p>Note: Manually setting <code>isRightPullViewActive</code> to
		 * <code>true</code> will not result in <code>Event.UPDATE</code> being
		 * dispatched.</p>
		 *
		 * @see #rightPullView
		 */
		public function get isRightPullViewActive():Boolean
		{
			return this._isRightPullViewActive;
		}

		/**
		 * @private
		 */
		public function set isRightPullViewActive(value:Boolean):void
		{
			if(this._isRightPullViewActive === value)
			{
				return;
			}
			if(this._rightPullView === null)
			{
				return;
			}
			this._isRightPullViewActive = value;
			this._isRightPullViewPending = true;
			this.invalidate(INVALIDATION_FLAG_PENDING_PULL_VIEW);
		}

		/**
		 * @private
		 */
		protected var _rightPullView:DisplayObject = null;

		/**
		 * A view that is displayed to the right of the scroller's view port
		 * when dragging to the left.
		 *
		 * <strong>Events</strong>
		 *
		 * <p>The scroller will dispatch <code>FeathersEventType.PULLING</code>
		 * on the pull view as it is dragged into view. The event's
		 * <code>data</code> property will be a value between <code>0</code> and
		 * <code>1</code> to indicate how far the pull view has been dragged so
		 * far. A value of <code>1</code> does not necessarily indicate that
		 * the pull view has been activated yet. A value greater than
		 * <code>1</code> is possible if <code>hasElasticEdges</code> is
		 * <code>true</code>.</p>
		 *
		 * <p>When the pull view is activated by the user, the scroller will
		 * dispatch <code>Event.UPDATE</code>. When the pull view should
		 * be deactivated, set the <code>isRightPullViewActive</code> property
		 * to <code>false</code>.</p>
		 *
		 * @default null
		 *
		 * @see #isRightPullViewActive
		 * @see #rightPullViewDisplayMode
		 * @see #event:update starling.events.Event.UPDATE
		 */
		public function get rightPullView():DisplayObject
		{
			return this._rightPullView;
		}

		/**
		 * @private
		 */
		public function set rightPullView(value:DisplayObject):void
		{
			if(this._rightPullView !== null)
			{
				this._rightPullView.mask.dispose();
				this._rightPullView.mask = null;
				if(this._rightPullView.parent === this)
				{
					this.removeRawChildInternal(this._rightPullView, false);
				}
			}
			this._rightPullView = value;
			if(this._rightPullView !== null)
			{
				this._rightPullView.mask = new Quad(1, 1, 0xff00ff);
				this._rightPullView.visible = false;
				this.addRawChildInternal(this._rightPullView);
			}
			else
			{
				this.isRightPullViewActive = false;
			}
		}

		/**
		 * @private
		 */
		protected var _rightPullViewDisplayMode:String = PullViewDisplayMode.DRAG;

		/**
		 * Indicates whether the right pull view may be dragged with the
		 * content, or if its position is fixed to the edge of the scroller.
		 *
		 * @default feathers.controls.PullViewDisplayMode.DRAG
		 *
		 * @see feathers.controls.PullViewDisplayMode#DRAG
		 * @see feathers.controls.PullViewDisplayMode#FIXED
		 * @see #rightPullView
		 */
		public function get rightPullViewDisplayMode():String
		{
			return this._rightPullViewDisplayMode;
		}

		/**
		 * @private
		 */
		public function set rightPullViewDisplayMode(value:String):void
		{
			if(this._rightPullViewDisplayMode === value)
			{
				return;
			}
			this._rightPullViewDisplayMode = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _rightPullViewRatio:Number = 0;

		/**
		 * @private
		 */
		protected function get rightPullViewRatio():Number
		{
			return this._rightPullViewRatio;
		}

		/**
		 * @private
		 */
		protected function set rightPullViewRatio(value:Number):void
		{
			if(this._rightPullViewRatio == value)
			{
				return;
			}
			this._rightPullViewRatio = value;
			if(!this._isRightPullViewActive && this._rightPullView !== null)
			{
				this._rightPullView.dispatchEventWith(FeathersEventType.PULLING, false, value);
			}
		}

		/**
		 * @private
		 */
		protected var _isBottomPullViewPending:Boolean = false;

		/**
		 * @private
		 */
		protected var _isBottomPullViewActive:Boolean = false;

		/**
		 * Indicates if the <code>bottomPullView</code> has been activated. Set
		 * to <code>false</code> to close the <code>bottomPullView</code>.
		 *
		 * <p>Note: Manually setting <code>isBottomPullViewActive</code> to
		 * <code>true</code> will not result in <code>Event.UPDATE</code> being
		 * dispatched.</p>
		 *
		 * @see #bottomPullView
		 */
		public function get isBottomPullViewActive():Boolean
		{
			return this._isBottomPullViewActive;
		}

		/**
		 * @private
		 */
		public function set isBottomPullViewActive(value:Boolean):void
		{
			if(this._isBottomPullViewActive === value)
			{
				return;
			}
			if(this._bottomPullView === null)
			{
				return;
			}
			this._isBottomPullViewActive = value;
			this._isBottomPullViewPending = true;
			this.invalidate(INVALIDATION_FLAG_PENDING_PULL_VIEW);
		}

		/**
		 * @private
		 */
		protected var _bottomPullView:DisplayObject = null;

		/**
		 * A view that is displayed at the bottom of the scroller's view port
		 * when dragging up.
		 *
		 * <strong>Events</strong>
		 *
		 * <p>The scroller will dispatch <code>FeathersEventType.PULLING</code>
		 * on the pull view as it is dragged into view. The event's
		 * <code>data</code> property will be a value between <code>0</code> and
		 * <code>1</code> to indicate how far the pull view has been dragged so
		 * far. A value of <code>1</code> does not necessarily indicate that
		 * the pull view has been activated yet. A value greater than
		 * <code>1</code> is possible if <code>hasElasticEdges</code> is
		 * <code>true</code>.</p>
		 *
		 * <p>When the pull view is activated by the user, the scroller will
		 * dispatch <code>Event.UPDATE</code>. When the pull view should
		 * be deactivated, set the <code>isBottomPullViewActive</code> property
		 * to <code>false</code>.</p>
		 *
		 * @default null
		 *
		 * @see #isBottomPullViewActive
		 * @see #bottomPullViewDisplayMode
		 * @see #event:update starling.events.Event.UPDATE
		 */
		public function get bottomPullView():DisplayObject
		{
			return this._bottomPullView;
		}

		/**
		 * @private
		 */
		public function set bottomPullView(value:DisplayObject):void
		{
			if(this._bottomPullView !== null)
			{
				this._bottomPullView.mask.dispose();
				this._bottomPullView.mask = null;
				if(this._bottomPullView.parent === this)
				{
					this.removeRawChildInternal(this._bottomPullView, false);
				}
			}
			this._bottomPullView = value;
			if(this._bottomPullView !== null)
			{
				this._bottomPullView.mask = new Quad(1, 1, 0xff00ff);
				this._bottomPullView.visible = false;
				this.addRawChildInternal(this._bottomPullView);
			}
			else
			{
				this.isBottomPullViewActive = false;
			}
		}

		/**
		 * @private
		 */
		protected var _bottomPullViewDisplayMode:String = PullViewDisplayMode.DRAG;

		/**
		 * Indicates whether the bottom pull view may be dragged with the
		 * content, or if its position is fixed to the edge of the scroller.
		 *
		 * @default feathers.controls.PullViewDisplayMode.DRAG
		 *
		 * @see feathers.controls.PullViewDisplayMode#DRAG
		 * @see feathers.controls.PullViewDisplayMode#FIXED
		 * @see #bottomPullView
		 */
		public function get bottomPullViewDisplayMode():String
		{
			return this._bottomPullViewDisplayMode;
		}

		/**
		 * @private
		 */
		public function set bottomPullViewDisplayMode(value:String):void
		{
			if(this._bottomPullViewDisplayMode === value)
			{
				return;
			}
			this._bottomPullViewDisplayMode = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _bottomPullViewRatio:Number = 0;

		/**
		 * @private
		 */
		protected function get bottomPullViewRatio():Number
		{
			return this._bottomPullViewRatio;
		}

		/**
		 * @private
		 */
		protected function set bottomPullViewRatio(value:Number):void
		{
			if(this._bottomPullViewRatio == value)
			{
				return;
			}
			this._bottomPullViewRatio = value;
			if(!this._isBottomPullViewActive && this._bottomPullView !== null)
			{
				this._bottomPullView.dispatchEventWith(FeathersEventType.PULLING, false, value);
			}
		}

		/**
		 * @private
		 */
		protected var _isLeftPullViewPending:Boolean = false;

		/**
		 * @private
		 */
		protected var _isLeftPullViewActive:Boolean = false;

		/**
		 * Indicates if the <code>leftPullView</code> has been activated. Set to
		 * <code>false</code> to close the <code>leftPullView</code>.
		 *
		 * <p>Note: Manually setting <code>isLeftpPullViewActive</code> to
		 * <code>true</code> will not result in <code>Event.UPDATE</code> being
		 * dispatched.</p>
		 *
		 * @see #leftPullView
		 */
		public function get isLeftPullViewActive():Boolean
		{
			return this._isLeftPullViewActive;
		}

		/**
		 * @private
		 */
		public function set isLeftPullViewActive(value:Boolean):void
		{
			if(this._isLeftPullViewActive === value)
			{
				return;
			}
			if(this._leftPullView === null)
			{
				return;
			}
			this._isLeftPullViewActive = value;
			this._isLeftPullViewPending = true;
			this.invalidate(INVALIDATION_FLAG_PENDING_PULL_VIEW);
		}

		/**
		 * @private
		 */
		protected var _leftPullView:DisplayObject = null;

		/**
		 * A view that is displayed to the left of the scroller's view port
		 * when dragging to the right.
		 *
		 * <strong>Events</strong>
		 *
		 * <p>The scroller will dispatch <code>FeathersEventType.PULLING</code>
		 * on the pull view as it is dragged into view. The event's
		 * <code>data</code> property will be a value between <code>0</code> and
		 * <code>1</code> to indicate how far the pull view has been dragged so
		 * far. A value of <code>1</code> does not necessarily indicate that
		 * the pull view has been activated yet. A value greater than
		 * <code>1</code> is possible if <code>hasElasticEdges</code> is
		 * <code>true</code>.</p>
		 *
		 * <p>When the pull view is activated by the user, the scroller will
		 * dispatch <code>Event.UPDATE</code>. When the pull view should
		 * be deactivated, set the <code>isLeftPullViewActive</code> property
		 * to <code>false</code>.</p>
		 *
		 * @default null
		 *
		 * @see #isLeftPullViewActive
		 * @see #leftPullViewDisplayMode
		 * @see #event:update starling.events.Event.UPDATE
		 */
		public function get leftPullView():DisplayObject
		{
			return this._leftPullView;
		}

		/**
		 * @private
		 */
		public function set leftPullView(value:DisplayObject):void
		{
			if(this._leftPullView !== null)
			{
				this._leftPullView.mask.dispose();
				this._leftPullView.mask = null;
				if(this._leftPullView.parent === this)
				{
					this.removeRawChildInternal(this._leftPullView, false);
				}
			}
			this._leftPullView = value;
			if(this._leftPullView !== null)
			{
				this._leftPullView.mask = new Quad(1, 1, 0xff00ff);
				this._leftPullView.visible = false;
				this.addRawChildInternal(this._leftPullView);
			}
			else
			{
				this.isLeftPullViewActive = false;
			}
		}

		/**
		 * @private
		 */
		protected var _leftPullViewRatio:Number = 0;

		/**
		 * @private
		 */
		protected function get leftPullViewRatio():Number
		{
			return this._leftPullViewRatio;
		}

		/**
		 * @private
		 */
		protected function set leftPullViewRatio(value:Number):void
		{
			if(this._leftPullViewRatio == value)
			{
				return;
			}
			this._leftPullViewRatio = value;
			if(!this._isLeftPullViewActive && this._leftPullView !== null)
			{
				this._leftPullView.dispatchEventWith(FeathersEventType.PULLING, false, value);
			}
		}

		/**
		 * @private
		 */
		protected var _leftPullViewDisplayMode:String = PullViewDisplayMode.DRAG;

		/**
		 * Indicates whether the left pull view may be dragged with the content,
		 * or if its position is fixed to the edge of the scroller.
		 *
		 * @default feathers.controls.PullViewDisplayMode.DRAG
		 *
		 * @see feathers.controls.PullViewDisplayMode#DRAG
		 * @see feathers.controls.PullViewDisplayMode#FIXED
		 * @see #leftPullView
		 */
		public function get leftPullViewDisplayMode():String
		{
			return this._leftPullViewDisplayMode;
		}

		/**
		 * @private
		 */
		public function set leftPullViewDisplayMode(value:String):void
		{
			if(this._leftPullViewDisplayMode === value)
			{
				return;
			}
			this._leftPullViewDisplayMode = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _horizontalAutoScrollTweenEndRatio:Number = 1;

		/**
		 * @private
		 */
		protected var _verticalAutoScrollTweenEndRatio:Number = 1;

		/**
		 * @private
		 */
		override public function dispose():void
		{
			var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
			starling.nativeStage.removeEventListener(MouseEvent.MOUSE_WHEEL, nativeStage_mouseWheelHandler);
			starling.nativeStage.removeEventListener("orientationChange", nativeStage_orientationChangeHandler);

			//we don't dispose it if the scroller is the parent because it'll
			//already get disposed in super.dispose()
			if(this._backgroundSkin !== null &&
				this._backgroundSkin.parent !== this)
			{
				this._backgroundSkin.dispose();
			}
			if(this._backgroundDisabledSkin !== null &&
				this._backgroundDisabledSkin.parent !== this)
			{
				this._backgroundDisabledSkin.dispose();
			}
			super.dispose();
		}

		/**
		 * If the user is scrolling with touch or if the scrolling is animated,
		 * calling stopScrolling() will cause the scroller to ignore the drag
		 * and stop animations. This function may only be called during scrolling,
		 * so if you need to stop scrolling on a <code>TouchEvent</code> with
		 * <code>TouchPhase.BEGAN</code>, you may need to wait for the scroller
		 * to start scrolling before you can call this function.
		 *
		 * <p>In the following example, we listen for <code>FeathersEventType.SCROLL_START</code>
		 * to stop scrolling:</p>
		 *
		 * <listing version="3.0">
		 * scroller.addEventListener( FeathersEventType.SCROLL_START, function( event:Event ):void
		 * {
		 *     scroller.stopScrolling();
		 * });</listing>
		 */
		public function stopScrolling():void
		{
			if(this._horizontalAutoScrollTween)
			{
				Starling.juggler.remove(this._horizontalAutoScrollTween);
				this._horizontalAutoScrollTween = null;
			}
			if(this._verticalAutoScrollTween)
			{
				Starling.juggler.remove(this._verticalAutoScrollTween);
				this._verticalAutoScrollTween = null;
			}
			this._isScrollingStopped = true;
			this._velocityX = 0;
			this._velocityY = 0;
			this._previousVelocityX.length = 0;
			this._previousVelocityY.length = 0;
			this.hideHorizontalScrollBar();
			this.hideVerticalScrollBar();
		}

		/**
		 * After the next validation, animates the scroll positions to a
		 * specific location. May scroll in only one direction by passing in a
		 * value of <code>NaN</code> for either scroll position. If the
		 * <code>animationDuration</code> argument is <code>NaN</code> (the
		 * default value), the duration of a standard throw is used. The
		 * duration is in seconds.
		 *
		 * <p>Because this function is primarily designed for animation, using a
		 * duration of <code>0</code> may require a frame or two before the
		 * scroll position updates.</p>
		 *
		 * <p>In the following example, we scroll to the maximum vertical scroll
		 * position:</p>
		 *
		 * <listing version="3.0">
		 * scroller.scrollToPosition( scroller.horizontalScrollPosition, scroller.maxVerticalScrollPosition );</listing>
		 *
		 * @see #horizontalScrollPosition
		 * @see #verticalScrollPosition
		 * @see #throwEase
		 */
		public function scrollToPosition(horizontalScrollPosition:Number, verticalScrollPosition:Number, animationDuration:Number = NaN):void
		{
			if(animationDuration !== animationDuration) //isNaN
			{
				if(this._useFixedThrowDuration)
				{
					animationDuration = this._fixedThrowDuration;
				}
				else
				{
					var point:Point = Pool.getPoint(horizontalScrollPosition - this._horizontalScrollPosition, verticalScrollPosition - this._verticalScrollPosition);
					animationDuration = this.calculateDynamicThrowDuration(point.length * this._logDecelerationRate + MINIMUM_VELOCITY);
					Pool.putPoint(point);
				}
			}
			//cancel any pending scroll to a different page. we can have only
			//one type of pending scroll at a time.
			this.hasPendingHorizontalPageIndex = false;
			this.hasPendingVerticalPageIndex = false;
			if(this.pendingHorizontalScrollPosition == horizontalScrollPosition &&
				this.pendingVerticalScrollPosition == verticalScrollPosition &&
				this.pendingScrollDuration == animationDuration)
			{
				return;
			}
			this.pendingHorizontalScrollPosition = horizontalScrollPosition;
			this.pendingVerticalScrollPosition = verticalScrollPosition;
			this.pendingScrollDuration = animationDuration;
			this.invalidate(INVALIDATION_FLAG_PENDING_SCROLL);
		}

		/**
		 * After the next validation, animates the scroll position to a specific
		 * page index. To scroll in only one direction, pass in the value of the
		 * <code>horizontalPageIndex</code> or the
		 * <code>verticalPageIndex</code> property to the appropriate parameter.
		 * If the <code>animationDuration</code> argument is <code>NaN</code>
		 * (the default value) the value of the <code>pageThrowDuration</code>
		 * property is used for the duration. The duration is in seconds.
		 *
		 * <p>You can only scroll to a page if the <code>snapToPages</code>
		 * property is <code>true</code>.</p>
		 *
		 * <p>In the following example, we scroll to the last horizontal page:</p>
		 *
		 * <listing version="3.0">
		 * scroller.scrollToPageIndex( scroller.horizontalPageCount - 1, scroller.verticalPageIndex );</listing>
		 *
		 * @see #snapToPages
		 * @see #pageThrowDuration
		 * @see #throwEase
		 * @see #horizontalPageIndex
		 * @see #verticalPageIndex
		 */
		public function scrollToPageIndex(horizontalPageIndex:int, verticalPageIndex:int, animationDuration:Number = NaN):void
		{
			if(animationDuration !== animationDuration) //isNaN
			{
				animationDuration = this._pageThrowDuration;
			}
			//cancel any pending scroll to a specific scroll position. we can
			//have only one type of pending scroll at a time.
			this.pendingHorizontalScrollPosition = NaN;
			this.pendingVerticalScrollPosition = NaN;
			this.hasPendingHorizontalPageIndex = this._horizontalPageIndex !== horizontalPageIndex;
			this.hasPendingVerticalPageIndex = this._verticalPageIndex !== verticalPageIndex;
			if(!this.hasPendingHorizontalPageIndex && !this.hasPendingVerticalPageIndex)
			{
				return;
			}
			this.pendingHorizontalPageIndex = horizontalPageIndex;
			this.pendingVerticalPageIndex = verticalPageIndex;
			this.pendingScrollDuration = animationDuration;
			this.invalidate(INVALIDATION_FLAG_PENDING_SCROLL);
		}

		/**
		 * If the scroll bars are floating, briefly show them as a hint to the
		 * user. Useful when first navigating to a screen to give the user
		 * context about both the ability to scroll and the current scroll
		 * position.
		 *
		 * @see #revealScrollBarsDuration
		 */
		public function revealScrollBars():void
		{
			this.isScrollBarRevealPending = true;
			this.invalidate(INVALIDATION_FLAG_PENDING_REVEAL_SCROLL_BARS);
		}

		/**
		 * @private
		 */
		override public function hitTest(localPoint:Point):DisplayObject
		{
			//save localX and localY because localPoint could change after the
			//call to super.hitTest().
			var localX:Number = localPoint.x;
			var localY:Number = localPoint.y;
			//first check the children for touches
			var result:DisplayObject = super.hitTest(localPoint);
			if((this._isDraggingHorizontally || this._isDraggingVertically) &&
				this.viewPort is DisplayObjectContainer &&
				DisplayObjectContainer(this.viewPort).contains(result))
			{
				result = DisplayObject(this.viewPort);
			}
			if(result === null)
			{
				//we want to register touches in our hitArea as a last resort
				if(!this.visible || !this.touchable)
				{
					return null;
				}
				return this._hitArea.contains(localX, localY) ? this : null;
			}
			return result;
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			//we don't use this flag in this class, but subclasses will use it,
			//and it's better to handle it here instead of having them
			//invalidate unrelated flags
			var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			//similarly, this flag may be set in subclasses
			var layoutInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_LAYOUT);
			var scrollInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SCROLL);
			var clippingInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_CLIPPING);
			var stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			var stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			var scrollBarInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SCROLL_BAR_RENDERER);
			var pendingScrollInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_PENDING_SCROLL);
			var pendingRevealScrollBarsInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_PENDING_REVEAL_SCROLL_BARS);
			var pendingPullViewInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_PENDING_PULL_VIEW);

			if(scrollBarInvalid)
			{
				this.createScrollBars();
			}

			if(sizeInvalid || stylesInvalid || stateInvalid)
			{
				this.refreshBackgroundSkin();
			}

			if(scrollBarInvalid || stylesInvalid)
			{
				this.refreshScrollBarStyles();
				this.refreshInteractionModeEvents();
			}

			if(scrollBarInvalid || stateInvalid)
			{
				this.refreshEnabled();
			}

			if(this.horizontalScrollBar)
			{
				this.horizontalScrollBar.validate();
			}
			if(this.verticalScrollBar)
			{
				this.verticalScrollBar.validate();
			}

			var oldMaxHorizontalScrollPosition:Number = this._maxHorizontalScrollPosition;
			var oldMaxVerticalScrollPosition:Number = this._maxVerticalScrollPosition;
			var needsMeasurement:Boolean = (scrollInvalid && this._viewPort.requiresMeasurementOnScroll) ||
				dataInvalid || sizeInvalid || stylesInvalid || scrollBarInvalid || stateInvalid || layoutInvalid;
			this.refreshViewPort(needsMeasurement);
			if(oldMaxHorizontalScrollPosition != this._maxHorizontalScrollPosition)
			{
				this.refreshHorizontalAutoScrollTweenEndRatio();
				scrollInvalid = true;
			}
			if(oldMaxVerticalScrollPosition != this._maxVerticalScrollPosition)
			{
				this.refreshVerticalAutoScrollTweenEndRatio();
				scrollInvalid = true;
			}
			if(scrollInvalid)
			{
				this.dispatchEventWith(Event.SCROLL);
			}

			this.showOrHideChildren();
			this.layoutChildren();

			if(scrollInvalid || sizeInvalid || stylesInvalid || scrollBarInvalid)
			{
				this.refreshScrollBarValues();
			}

			if(needsMeasurement || scrollInvalid || clippingInvalid)
			{
				this.refreshMask();
			}
			this.refreshFocusIndicator();

			if(pendingScrollInvalid)
			{
				this.handlePendingScroll();
			}

			if(pendingRevealScrollBarsInvalid)
			{
				this.handlePendingRevealScrollBars();
			}

			if(pendingPullViewInvalid)
			{
				this.handlePendingPullView();
			}
		}

		/**
		 * @private
		 */
		protected function refreshViewPort(measure:Boolean):void
		{
			if(this._snapScrollPositionsToPixels)
			{
				var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
				var pixelSize:Number = 1 / starling.contentScaleFactor;
				this._viewPort.horizontalScrollPosition = Math.round(this._horizontalScrollPosition / pixelSize) * pixelSize;
				this._viewPort.verticalScrollPosition = Math.round(this._verticalScrollPosition / pixelSize) * pixelSize;
			}
			else
			{
				this._viewPort.horizontalScrollPosition = this._horizontalScrollPosition;
				this._viewPort.verticalScrollPosition = this._verticalScrollPosition;
			}
			if(!measure)
			{
				this._viewPort.validate();
				this.refreshScrollValues();
				return;
			}
			var loopCount:int = 0;
			do
			{
				this._hasViewPortBoundsChanged = false;
				//if we don't need to do any measurement, we can skip
				//this stuff and improve performance
				if(this._measureViewPort)
				{
					this.calculateViewPortOffsets(true, false);
					this.refreshViewPortBoundsForMeasurement();
				}
				this.calculateViewPortOffsets(false, false);

				this.autoSizeIfNeeded();

				//just in case autoSizeIfNeeded() is overridden, we need to call
				//this again and use actualWidth/Height instead of
				//explicitWidth/Height.
				this.calculateViewPortOffsets(false, true);

				this.refreshViewPortBoundsForLayout();
				this.refreshScrollValues();
				loopCount++;
				if(loopCount >= 10)
				{
					//if it still fails after ten tries, we've probably entered
					//an infinite loop. it could be things like rounding errors,
					//layout issues, or custom item renderers that don't measure
					//correctly
					throw new Error(getQualifiedClassName(this) + " stuck in an infinite loop during measurement and validation. This may be an issue with the layout or children, such as custom item renderers.");
				}
			}
			while(this._hasViewPortBoundsChanged);
			this._lastViewPortWidth = this._viewPort.width;
			this._lastViewPortHeight = this._viewPort.height;
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
			var needsWidth:Boolean = this._explicitWidth !== this._explicitWidth; //isNaN
			var needsHeight:Boolean = this._explicitHeight !== this._explicitHeight; //isNaN
			var needsMinWidth:Boolean = this._explicitMinWidth !== this._explicitMinWidth; //isNaN
			var needsMinHeight:Boolean = this._explicitMinHeight !== this._explicitMinHeight; //isNaN
			if(!needsWidth && !needsHeight && !needsMinWidth && !needsMinHeight)
			{
				return false;
			}

			resetFluidChildDimensionsForMeasurement(this.currentBackgroundSkin,
				this._explicitWidth, this._explicitHeight,
				this._explicitMinWidth, this._explicitMinHeight,
				this._explicitMaxWidth, this._explicitMaxHeight,
				this._explicitBackgroundWidth, this._explicitBackgroundHeight,
				this._explicitBackgroundMinWidth, this._explicitBackgroundMinHeight,
				this._explicitBackgroundMaxWidth, this._explicitBackgroundMaxHeight);
			var measureBackground:IMeasureDisplayObject = this.currentBackgroundSkin as IMeasureDisplayObject;
			if(this.currentBackgroundSkin is IValidating)
			{
				IValidating(this.currentBackgroundSkin).validate();
			}

			var newWidth:Number = this._explicitWidth;
			var newHeight:Number = this._explicitHeight;
			var newMinWidth:Number = this._explicitMinWidth;
			var newMinHeight:Number = this._explicitMinHeight;
			if(needsWidth)
			{
				if(this._measureViewPort)
				{
					newWidth = this._viewPort.visibleWidth;
				}
				else
				{
					newWidth = 0;
				}
				newWidth += this._rightViewPortOffset + this._leftViewPortOffset;
				if(this.currentBackgroundSkin !== null &&
					this.currentBackgroundSkin.width > newWidth)
				{
					newWidth = this.currentBackgroundSkin.width;
				}
			}
			if(needsHeight)
			{
				if(this._measureViewPort)
				{
					newHeight = this._viewPort.visibleHeight;
				}
				else
				{
					newHeight = 0;
				}
				newHeight += this._bottomViewPortOffset + this._topViewPortOffset;
				if(this.currentBackgroundSkin !== null &&
					this.currentBackgroundSkin.height > newHeight)
				{
					newHeight = this.currentBackgroundSkin.height;
				}
			}
			if(needsMinWidth)
			{
				if(this._measureViewPort)
				{
					newMinWidth = this._viewPort.minVisibleWidth;
				}
				else
				{
					newMinWidth = 0;
				}
				newMinWidth += this._rightViewPortOffset + this._leftViewPortOffset;
				if(this.currentBackgroundSkin !== null)
				{
					if(measureBackground !== null)
					{
						if(measureBackground.minWidth > newMinWidth)
						{
							newMinWidth = measureBackground.minWidth;
						}
					}
					else if(this._explicitBackgroundMinWidth > newMinWidth)
					{
						newMinWidth = this._explicitBackgroundMinWidth;
					}
				}
			}
			if(needsMinHeight)
			{
				if(this._measureViewPort)
				{
					newMinHeight = this._viewPort.minVisibleHeight;
				}
				else
				{
					newMinHeight = 0;
				}
				newMinHeight += this._bottomViewPortOffset + this._topViewPortOffset;
				if(this.currentBackgroundSkin !== null)
				{
					if(measureBackground !== null)
					{
						if(measureBackground.minHeight > newMinHeight)
						{
							newMinHeight = measureBackground.minHeight;
						}
					}
					else if(this._explicitBackgroundMinHeight > newMinHeight)
					{
						newMinHeight = this._explicitBackgroundMinHeight;
					}
				}
			}
			return this.saveMeasurements(newWidth, newHeight, newMinWidth, newMinHeight);
		}

		/**
		 * Creates and adds the <code>horizontalScrollBar</code> and
		 * <code>verticalScrollBar</code> sub-components and removes the old
		 * instances, if they exist.
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 *
		 * @see #horizontalScrollBar
		 * @see #verticalScrollBar
		 * @see #horizontalScrollBarFactory
		 * @see #verticalScrollBarFactory
		 */
		protected function createScrollBars():void
		{
			if(this.horizontalScrollBar)
			{
				this.horizontalScrollBar.removeEventListener(FeathersEventType.BEGIN_INTERACTION, horizontalScrollBar_beginInteractionHandler);
				this.horizontalScrollBar.removeEventListener(FeathersEventType.END_INTERACTION, horizontalScrollBar_endInteractionHandler);
				this.horizontalScrollBar.removeEventListener(Event.CHANGE, horizontalScrollBar_changeHandler);
				this.removeRawChildInternal(DisplayObject(this.horizontalScrollBar), true);
				this.horizontalScrollBar = null;
			}
			if(this.verticalScrollBar)
			{
				this.verticalScrollBar.removeEventListener(FeathersEventType.BEGIN_INTERACTION, verticalScrollBar_beginInteractionHandler);
				this.verticalScrollBar.removeEventListener(FeathersEventType.END_INTERACTION, verticalScrollBar_endInteractionHandler);
				this.verticalScrollBar.removeEventListener(Event.CHANGE, verticalScrollBar_changeHandler);
				this.removeRawChildInternal(DisplayObject(this.verticalScrollBar), true);
				this.verticalScrollBar = null;
			}

			if(this._scrollBarDisplayMode != ScrollBarDisplayMode.NONE &&
				this._horizontalScrollPolicy != ScrollPolicy.OFF && this._horizontalScrollBarFactory != null)
			{
				this.horizontalScrollBar = IScrollBar(this._horizontalScrollBarFactory());
				if(this.horizontalScrollBar is IDirectionalScrollBar)
				{
					IDirectionalScrollBar(this.horizontalScrollBar).direction = Direction.HORIZONTAL;
				}
				var horizontalScrollBarStyleName:String = this._customHorizontalScrollBarStyleName != null ? this._customHorizontalScrollBarStyleName : this.horizontalScrollBarStyleName;
				this.horizontalScrollBar.styleNameList.add(horizontalScrollBarStyleName);
				this.horizontalScrollBar.addEventListener(Event.CHANGE, horizontalScrollBar_changeHandler);
				this.horizontalScrollBar.addEventListener(FeathersEventType.BEGIN_INTERACTION, horizontalScrollBar_beginInteractionHandler);
				this.horizontalScrollBar.addEventListener(FeathersEventType.END_INTERACTION, horizontalScrollBar_endInteractionHandler);
				this.addRawChildInternal(DisplayObject(this.horizontalScrollBar));
			}
			if(this._scrollBarDisplayMode != ScrollBarDisplayMode.NONE &&
				this._verticalScrollPolicy != ScrollPolicy.OFF && this._verticalScrollBarFactory != null)
			{
				this.verticalScrollBar = IScrollBar(this._verticalScrollBarFactory());
				if(this.verticalScrollBar is IDirectionalScrollBar)
				{
					IDirectionalScrollBar(this.verticalScrollBar).direction = Direction.VERTICAL;
				}
				var verticalScrollBarStyleName:String = this._customVerticalScrollBarStyleName != null ? this._customVerticalScrollBarStyleName : this.verticalScrollBarStyleName;
				this.verticalScrollBar.styleNameList.add(verticalScrollBarStyleName);
				this.verticalScrollBar.addEventListener(Event.CHANGE, verticalScrollBar_changeHandler);
				this.verticalScrollBar.addEventListener(FeathersEventType.BEGIN_INTERACTION, verticalScrollBar_beginInteractionHandler);
				this.verticalScrollBar.addEventListener(FeathersEventType.END_INTERACTION, verticalScrollBar_endInteractionHandler);
				this.addRawChildInternal(DisplayObject(this.verticalScrollBar));
			}
		}

		/**
		 * Choose the appropriate background skin based on the control's current
		 * state.
		 */
		protected function refreshBackgroundSkin():void
		{
			var newCurrentBackgroundSkin:DisplayObject = this.getCurrentBackgroundSkin();
			if(this.currentBackgroundSkin !== newCurrentBackgroundSkin)
			{
				this.removeCurrentBackgroundSkin(this.currentBackgroundSkin);
				this.currentBackgroundSkin = newCurrentBackgroundSkin;
				if(this.currentBackgroundSkin !== null)
				{
					if(this.currentBackgroundSkin is IFeathersControl)
					{
						IFeathersControl(this.currentBackgroundSkin).initializeNow();
					}
					if(this.currentBackgroundSkin is IMeasureDisplayObject)
					{
						var measureSkin:IMeasureDisplayObject = IMeasureDisplayObject(this.currentBackgroundSkin);
						this._explicitBackgroundWidth = measureSkin.explicitWidth;
						this._explicitBackgroundHeight = measureSkin.explicitHeight;
						this._explicitBackgroundMinWidth = measureSkin.explicitMinWidth;
						this._explicitBackgroundMinHeight = measureSkin.explicitMinHeight;
						this._explicitBackgroundMaxWidth = measureSkin.explicitMaxWidth;
						this._explicitBackgroundMaxHeight = measureSkin.explicitMaxHeight;
					}
					else
					{
						this._explicitBackgroundWidth = this.currentBackgroundSkin.width;
						this._explicitBackgroundHeight = this.currentBackgroundSkin.height;
						this._explicitBackgroundMinWidth = this._explicitBackgroundWidth;
						this._explicitBackgroundMinHeight = this._explicitBackgroundHeight;
						this._explicitBackgroundMaxWidth = this._explicitBackgroundWidth;
						this._explicitBackgroundMaxHeight = this._explicitBackgroundHeight;
					}
					this.addRawChildAtInternal(this.currentBackgroundSkin, 0);
				}
			}
		}

		/**
		 * @private
		 */
		protected function getCurrentBackgroundSkin():DisplayObject
		{
			var newCurrentBackgroundSkin:DisplayObject = this._backgroundSkin;
			if(!this._isEnabled && this._backgroundDisabledSkin !== null)
			{
				newCurrentBackgroundSkin = this._backgroundDisabledSkin;
			}
			return newCurrentBackgroundSkin;
		}

		/**
		 * @private
		 */
		protected function removeCurrentBackgroundSkin(skin:DisplayObject):void
		{
			if(skin === null)
			{
				return;
			}
			if(skin.parent === this)
			{
				//we need to restore these values so that they won't be lost the
				//next time that this skin is used for measurement
				skin.width = this._explicitBackgroundWidth;
				skin.height = this._explicitBackgroundHeight;
				if(skin is IMeasureDisplayObject)
				{
					var measureSkin:IMeasureDisplayObject = IMeasureDisplayObject(skin);
					measureSkin.minWidth = this._explicitBackgroundMinWidth;
					measureSkin.minHeight = this._explicitBackgroundMinHeight;
					measureSkin.maxWidth = this._explicitBackgroundMaxWidth;
					measureSkin.maxHeight = this._explicitBackgroundMaxHeight;
				}
				this.removeRawChildInternal(skin);
			}
		}

		/**
		 * @private
		 */
		protected function refreshScrollBarStyles():void
		{
			if(this.horizontalScrollBar)
			{
				for(var propertyName:String in this._horizontalScrollBarProperties)
				{
					var propertyValue:Object = this._horizontalScrollBarProperties[propertyName];
					this.horizontalScrollBar[propertyName] = propertyValue;
				}
				if(this._horizontalScrollBarHideTween)
				{
					Starling.juggler.remove(this._horizontalScrollBarHideTween);
					this._horizontalScrollBarHideTween = null;
				}
				this.horizontalScrollBar.alpha = this._scrollBarDisplayMode == ScrollBarDisplayMode.FLOAT ? 0 : 1;
			}
			if(this.verticalScrollBar)
			{
				for(propertyName in this._verticalScrollBarProperties)
				{
					propertyValue = this._verticalScrollBarProperties[propertyName];
					this.verticalScrollBar[propertyName] = propertyValue;
				}
				if(this._verticalScrollBarHideTween)
				{
					Starling.juggler.remove(this._verticalScrollBarHideTween);
					this._verticalScrollBarHideTween = null;
				}
				this.verticalScrollBar.alpha = this._scrollBarDisplayMode == ScrollBarDisplayMode.FLOAT ? 0 : 1;
			}
		}

		/**
		 * @private
		 */
		protected function refreshEnabled():void
		{
			if(this._viewPort)
			{
				this._viewPort.isEnabled = this._isEnabled;
			}
			if(this.horizontalScrollBar)
			{
				this.horizontalScrollBar.isEnabled = this._isEnabled;
			}
			if(this.verticalScrollBar)
			{
				this.verticalScrollBar.isEnabled = this._isEnabled;
			}
		}

		/**
		 * @private
		 */
		override protected function refreshFocusIndicator():void
		{
			if(this._focusIndicatorSkin)
			{
				if(this._hasFocus && this._showFocus)
				{
					if(this._focusIndicatorSkin.parent != this)
					{
						this.addRawChildInternal(this._focusIndicatorSkin);
					}
					else
					{
						this.setRawChildIndexInternal(this._focusIndicatorSkin, this.numRawChildrenInternal - 1);
					}
				}
				else if(this._focusIndicatorSkin.parent == this)
				{
					this.removeRawChildInternal(this._focusIndicatorSkin, false);
				}
				this._focusIndicatorSkin.x = this._focusPaddingLeft;
				this._focusIndicatorSkin.y = this._focusPaddingTop;
				this._focusIndicatorSkin.width = this.actualWidth - this._focusPaddingLeft - this._focusPaddingRight;
				this._focusIndicatorSkin.height = this.actualHeight - this._focusPaddingTop - this._focusPaddingBottom;
			}
		}

		/**
		 * @private
		 */
		protected function refreshViewPortBoundsForMeasurement():void
		{
			var horizontalWidthOffset:Number = this._leftViewPortOffset + this._rightViewPortOffset;
			var verticalHeightOffset:Number = this._topViewPortOffset + this._bottomViewPortOffset;

			resetFluidChildDimensionsForMeasurement(this.currentBackgroundSkin,
				this._explicitWidth, this._explicitHeight,
				this._explicitMinWidth, this._explicitMinHeight,
				this._explicitMaxWidth, this._explicitMaxHeight,
				this._explicitBackgroundWidth, this._explicitBackgroundHeight,
				this._explicitBackgroundMinWidth, this._explicitBackgroundMinHeight,
				this._explicitBackgroundMaxWidth, this._explicitBackgroundMaxHeight);
			var measureBackground:IMeasureDisplayObject = this.currentBackgroundSkin as IMeasureDisplayObject;
			if(this.currentBackgroundSkin is IValidating)
			{
				IValidating(this.currentBackgroundSkin).validate();
			}
			
			//we account for the explicit minimum dimensions of the view port
			//and the minimum dimensions of the background skin because it helps
			//the final measurements stabilize faster.
			var viewPortMinWidth:Number = this._explicitMinWidth;
			if(viewPortMinWidth !== viewPortMinWidth || //isNaN
				this._explicitViewPortMinWidth > viewPortMinWidth)
			{
				viewPortMinWidth = this._explicitViewPortMinWidth;
			}
			if(viewPortMinWidth !== viewPortMinWidth || //isNaN
				this._explicitWidth > viewPortMinWidth)
			{
				viewPortMinWidth = this._explicitWidth;
			}
			if(this.currentBackgroundSkin !== null)
			{
				var backgroundMinWidth:Number = this.currentBackgroundSkin.width;
				if(measureBackground !== null)
				{
					backgroundMinWidth = measureBackground.minWidth;
				}
				if(viewPortMinWidth !== viewPortMinWidth || //isNaN
					backgroundMinWidth > viewPortMinWidth)
				{
					viewPortMinWidth = backgroundMinWidth;
				}
			}
			viewPortMinWidth -= horizontalWidthOffset;

			var viewPortMinHeight:Number = this._explicitMinHeight;
			if(viewPortMinHeight !== viewPortMinHeight || //isNaN
				this._explicitViewPortMinHeight > viewPortMinHeight)
			{
				viewPortMinHeight = this._explicitViewPortMinHeight;
			}
			if(viewPortMinHeight !== viewPortMinHeight || //isNaN
				this._explicitHeight > viewPortMinHeight)
			{
				viewPortMinHeight = this._explicitHeight;
			}
			if(this.currentBackgroundSkin !== null)
			{
				var backgroundMinHeight:Number = this.currentBackgroundSkin.height;
				if(measureBackground !== null)
				{
					backgroundMinHeight = measureBackground.minHeight;
				}
				if(viewPortMinHeight !== viewPortMinHeight || //isNaN
					backgroundMinHeight > viewPortMinHeight)
				{
					viewPortMinHeight = backgroundMinHeight;
				}
			}
			viewPortMinHeight -= verticalHeightOffset;

			var oldIgnoreViewPortResizing:Boolean = this.ignoreViewPortResizing;
			//setting some of the properties below may result in a resize
			//event, which forces another layout pass for the view port and
			//hurts performance (because it needs to break out of an
			//infinite loop)
			this.ignoreViewPortResizing = true;

			//if scroll bars are fixed, we're going to include the offsets even
			//if they may not be needed in the final pass. if not fixed, the
			//view port fills the entire bounds.
			this._viewPort.visibleWidth = this._explicitWidth - horizontalWidthOffset;
			this._viewPort.minVisibleWidth = this._explicitMinWidth - horizontalWidthOffset;
			this._viewPort.maxVisibleWidth = this._explicitMaxWidth - horizontalWidthOffset;
			this._viewPort.minWidth = viewPortMinWidth;

			this._viewPort.visibleHeight = this._explicitHeight - verticalHeightOffset;
			this._viewPort.minVisibleHeight = this._explicitMinHeight - verticalHeightOffset;
			this._viewPort.maxVisibleHeight = this._explicitMaxHeight - verticalHeightOffset;
			this._viewPort.minHeight = viewPortMinHeight;
			this._viewPort.validate();
			//we don't want to listen for a resize event from the view port
			//while it is validating this time. during the next validation is
			//where it matters if the view port resizes. 
			this.ignoreViewPortResizing = oldIgnoreViewPortResizing;
		}

		/**
		 * @private
		 */
		protected function refreshViewPortBoundsForLayout():void
		{
			var horizontalWidthOffset:Number = this._leftViewPortOffset + this._rightViewPortOffset;
			var verticalHeightOffset:Number = this._topViewPortOffset + this._bottomViewPortOffset;

			var oldIgnoreViewPortResizing:Boolean = this.ignoreViewPortResizing;
			//setting some of the properties below may result in a resize
			//event, which forces another layout pass for the view port and
			//hurts performance (because it needs to break out of an
			//infinite loop)
			this.ignoreViewPortResizing = true;

			var visibleWidth:Number = this.actualWidth - horizontalWidthOffset;
			//we'll only set the view port's visibleWidth and visibleHeight if
			//our dimensions are explicit. this allows the view port to know
			//whether it needs to re-measure on scroll.
			if(this._viewPort.visibleWidth != visibleWidth)
			{
				this._viewPort.visibleWidth = visibleWidth;
			}
			this._viewPort.minVisibleWidth = this.actualWidth - horizontalWidthOffset;
			this._viewPort.maxVisibleWidth = this._explicitMaxWidth - horizontalWidthOffset;
			this._viewPort.minWidth = visibleWidth;

			var visibleHeight:Number = this.actualHeight - verticalHeightOffset;
			if(this._viewPort.visibleHeight != visibleHeight)
			{
				this._viewPort.visibleHeight = visibleHeight;
			}
			this._viewPort.minVisibleHeight = this.actualMinHeight - verticalHeightOffset;
			this._viewPort.maxVisibleHeight = this._explicitMaxHeight - verticalHeightOffset;
			this._viewPort.minHeight = visibleHeight;

			//this time, we care whether a resize event is dispatched while the
			//view port is validating because it means we'll need to try another
			//measurement pass. we restore the flag before calling validate().
			this.ignoreViewPortResizing = oldIgnoreViewPortResizing;

			this._viewPort.validate();
		}

		/**
		 * @private
		 */
		protected function refreshScrollValues():void
		{
			this.refreshScrollSteps();

			var oldMaxHSP:Number = this._maxHorizontalScrollPosition;
			var oldMaxVSP:Number = this._maxVerticalScrollPosition;
			this.refreshMinAndMaxScrollPositions();
			var maximumPositionsChanged:Boolean = this._maxHorizontalScrollPosition != oldMaxHSP || this._maxVerticalScrollPosition != oldMaxVSP;
			if(maximumPositionsChanged && this._touchPointID < 0)
			{
				this.clampScrollPositions();
			}

			this.refreshPageCount();
			this.refreshPageIndices();
		}

		/**
		 * @private
		 */
		protected function clampScrollPositions():void
		{
			if(!this._horizontalAutoScrollTween)
			{
				if(this._snapToPages)
				{
					this._horizontalScrollPosition = roundToNearest(this._horizontalScrollPosition, this.actualPageWidth);
				}
				var targetHorizontalScrollPosition:Number = this._horizontalScrollPosition;
				if(targetHorizontalScrollPosition < this._minHorizontalScrollPosition)
				{
					targetHorizontalScrollPosition = this._minHorizontalScrollPosition;
				}
				else if(targetHorizontalScrollPosition > this._maxHorizontalScrollPosition)
				{
					targetHorizontalScrollPosition = this._maxHorizontalScrollPosition;
				}
				this.horizontalScrollPosition = targetHorizontalScrollPosition;
			}
			if(!this._verticalAutoScrollTween)
			{
				if(this._snapToPages)
				{
					this._verticalScrollPosition = roundToNearest(this._verticalScrollPosition, this.actualPageHeight);
				}
				var targetVerticalScrollPosition:Number = this._verticalScrollPosition;
				if(targetVerticalScrollPosition < this._minVerticalScrollPosition)
				{
					targetVerticalScrollPosition = this._minVerticalScrollPosition;
				}
				else if(targetVerticalScrollPosition > this._maxVerticalScrollPosition)
				{
					targetVerticalScrollPosition = this._maxVerticalScrollPosition;
				}
				this.verticalScrollPosition = targetVerticalScrollPosition;
			}
		}

		/**
		 * @private
		 */
		protected function refreshScrollSteps():void
		{
			if(this.explicitHorizontalScrollStep !== this.explicitHorizontalScrollStep) //isNaN
			{
				if(this._viewPort)
				{
					this.actualHorizontalScrollStep = this._viewPort.horizontalScrollStep;
				}
				else
				{
					this.actualHorizontalScrollStep = 1;
				}
			}
			else
			{
				this.actualHorizontalScrollStep = this.explicitHorizontalScrollStep;
			}
			if(this.explicitVerticalScrollStep !== this.explicitVerticalScrollStep) //isNaN
			{
				if(this._viewPort)
				{
					this.actualVerticalScrollStep = this._viewPort.verticalScrollStep;
				}
				else
				{
					this.actualVerticalScrollStep = 1;
				}
			}
			else
			{
				this.actualVerticalScrollStep = this.explicitVerticalScrollStep;
			}
		}

		/**
		 * @private
		 */
		protected function refreshMinAndMaxScrollPositions():void
		{
			var visibleViewPortWidth:Number = this.actualWidth - (this._leftViewPortOffset + this._rightViewPortOffset);
			var visibleViewPortHeight:Number = this.actualHeight - (this._topViewPortOffset + this._bottomViewPortOffset);
			if(this.explicitPageWidth !== this.explicitPageWidth) //isNaN
			{
				this.actualPageWidth = visibleViewPortWidth;
			}
			if(this.explicitPageHeight !== this.explicitPageHeight) //isNaN
			{
				this.actualPageHeight = visibleViewPortHeight;
			}
			if(this._viewPort)
			{
				this._minHorizontalScrollPosition = this._viewPort.contentX;
				if(this._viewPort.width == Number.POSITIVE_INFINITY)
				{
					//we don't want to risk the possibility of negative infinity
					//being added to positive infinity. the result is NaN.
					this._maxHorizontalScrollPosition = Number.POSITIVE_INFINITY;
				}
				else
				{
					this._maxHorizontalScrollPosition = this._minHorizontalScrollPosition + this._viewPort.width - visibleViewPortWidth;
				}
				if(this._maxHorizontalScrollPosition < this._minHorizontalScrollPosition)
				{
					this._maxHorizontalScrollPosition = this._minHorizontalScrollPosition;
				}
				this._minVerticalScrollPosition = this._viewPort.contentY;
				if(this._viewPort.height == Number.POSITIVE_INFINITY)
				{
					//we don't want to risk the possibility of negative infinity
					//being added to positive infinity. the result is NaN.
					this._maxVerticalScrollPosition = Number.POSITIVE_INFINITY;
				}
				else
				{
					this._maxVerticalScrollPosition = this._minVerticalScrollPosition + this._viewPort.height - visibleViewPortHeight;
				}
				if(this._maxVerticalScrollPosition < this._minVerticalScrollPosition)
				{
					this._maxVerticalScrollPosition =  this._minVerticalScrollPosition;
				}
			}
			else
			{
				this._minHorizontalScrollPosition = 0;
				this._minVerticalScrollPosition = 0;
				this._maxHorizontalScrollPosition = 0;
				this._maxVerticalScrollPosition = 0;
			}
		}

		/**
		 * @private
		 */
		protected function refreshPageCount():void
		{
			if(this._snapToPages)
			{
				var horizontalScrollRange:Number = this._maxHorizontalScrollPosition - this._minHorizontalScrollPosition;
				if(horizontalScrollRange == Number.POSITIVE_INFINITY)
				{
					//trying to put positive infinity into an int results in 0
					//so we need a special case to provide a large int value.
					if(this._minHorizontalScrollPosition == Number.NEGATIVE_INFINITY)
					{
						this._minHorizontalPageIndex = int.MIN_VALUE;
					}
					else
					{
						this._minHorizontalPageIndex = 0;
					}
					this._maxHorizontalPageIndex = int.MAX_VALUE;
				}
				else
				{
					this._minHorizontalPageIndex = 0;
					var unroundedPageIndex:Number = horizontalScrollRange / this.actualPageWidth;
					var nearestPageIndex:int = Math.round(unroundedPageIndex);
					if(MathUtil.isEquivalent(unroundedPageIndex, nearestPageIndex, PAGE_INDEX_EPSILON))
					{
						//we almost always want to round up, but a
						//floating point math error, or a page width that
						//isn't an integer (when snapping to pixels) could
						//cause the page index to be off by one
						this._maxHorizontalPageIndex = nearestPageIndex;
					}
					else
					{
						this._maxHorizontalPageIndex = Math.ceil(unroundedPageIndex);
					}
				}

				var verticalScrollRange:Number = this._maxVerticalScrollPosition - this._minVerticalScrollPosition;
				if(verticalScrollRange == Number.POSITIVE_INFINITY)
				{
					//trying to put positive infinity into an int results in 0
					//so we need a special case to provide a large int value.
					if(this._minVerticalScrollPosition == Number.NEGATIVE_INFINITY)
					{
						this._minVerticalPageIndex = int.MIN_VALUE;
					}
					else
					{
						this._minVerticalPageIndex = 0;
					}
					this._maxVerticalPageIndex = int.MAX_VALUE;
				}
				else
				{
					this._minVerticalPageIndex = 0;
					unroundedPageIndex = verticalScrollRange / this.actualPageHeight;
					nearestPageIndex = Math.round(unroundedPageIndex);
					if(MathUtil.isEquivalent(unroundedPageIndex, nearestPageIndex, PAGE_INDEX_EPSILON))
					{
						//we almost always want to round up, but a
						//floating point math error, or a page height that
						//isn't an integer (when snapping to pixels) could
						//cause the page index to be off by one
						this._maxVerticalPageIndex = nearestPageIndex;
					}
					else
					{
						this._maxVerticalPageIndex = Math.ceil(unroundedPageIndex);
					}
				}
			}
			else
			{
				this._maxHorizontalPageIndex = 0;
				this._maxHorizontalPageIndex = 0;
				this._minVerticalPageIndex = 0;
				this._maxVerticalPageIndex = 0;
			}
		}

		/**
		 * @private
		 */
		protected function refreshPageIndices():void
		{
			if(!this._horizontalAutoScrollTween && !this.hasPendingHorizontalPageIndex)
			{
				if(this._snapToPages)
				{
					if(this._horizontalScrollPosition == this._maxHorizontalScrollPosition)
					{
						this._horizontalPageIndex = this._maxHorizontalPageIndex;
					}
					else if(this._horizontalScrollPosition == this._minHorizontalScrollPosition)
					{
						this._horizontalPageIndex = this._minHorizontalPageIndex;
					}
					else
					{
						if(this._minHorizontalScrollPosition == Number.NEGATIVE_INFINITY && this._horizontalScrollPosition < 0)
						{
							var unroundedPageIndex:Number = this._horizontalScrollPosition / this.actualPageWidth;
						}
						else if(this._maxHorizontalScrollPosition == Number.POSITIVE_INFINITY && this._horizontalScrollPosition >= 0)
						{
							unroundedPageIndex = this._horizontalScrollPosition / this.actualPageWidth;
						}
						else
						{
							var adjustedHorizontalScrollPosition:Number = this._horizontalScrollPosition - this._minHorizontalScrollPosition;
							unroundedPageIndex = adjustedHorizontalScrollPosition / this.actualPageWidth;
						}
						var nearestPageIndex:int = Math.round(unroundedPageIndex);
						if(unroundedPageIndex != nearestPageIndex &&
							MathUtil.isEquivalent(unroundedPageIndex, nearestPageIndex, PAGE_INDEX_EPSILON))
						{
							//we almost always want to round down, but a
							//floating point math error, or a page width that
							//isn't an integer (when snapping to pixels) could
							//cause the page index to be off by one
							this._horizontalPageIndex = nearestPageIndex;
						}
						else
						{
							this._horizontalPageIndex = Math.floor(unroundedPageIndex);
						}
					}
				}
				else
				{
					this._horizontalPageIndex = this._minHorizontalPageIndex;
				}
				if(this._horizontalPageIndex < this._minHorizontalPageIndex)
				{
					this._horizontalPageIndex = this._minHorizontalPageIndex;
				}
				if(this._horizontalPageIndex > this._maxHorizontalPageIndex)
				{
					this._horizontalPageIndex = this._maxHorizontalPageIndex;
				}
			}
			if(!this._verticalAutoScrollTween && !this.hasPendingVerticalPageIndex)
			{
				if(this._snapToPages)
				{
					if(this._verticalScrollPosition == this._maxVerticalScrollPosition)
					{
						this._verticalPageIndex = this._maxVerticalPageIndex;
					}
					else if(this._verticalScrollPosition == this._minVerticalScrollPosition)
					{
						this._verticalPageIndex = this._minVerticalPageIndex;
					}
					else
					{
						if(this._minVerticalScrollPosition == Number.NEGATIVE_INFINITY && this._verticalScrollPosition < 0)
						{
							unroundedPageIndex = this._verticalScrollPosition / this.actualPageHeight;
						}
						else if(this._maxVerticalScrollPosition == Number.POSITIVE_INFINITY && this._verticalScrollPosition >= 0)
						{
							unroundedPageIndex = this._verticalScrollPosition / this.actualPageHeight;
						}
						else
						{
							var adjustedVerticalScrollPosition:Number = this._verticalScrollPosition - this._minVerticalScrollPosition;
							unroundedPageIndex = adjustedVerticalScrollPosition / this.actualPageHeight;
						}
						nearestPageIndex = Math.round(unroundedPageIndex);
						if(unroundedPageIndex != nearestPageIndex &&
							MathUtil.isEquivalent(unroundedPageIndex, nearestPageIndex, PAGE_INDEX_EPSILON))
						{
							//we almost always want to round down, but a
							//floating point math error, or a page height that
							//isn't an integer (when snapping to pixels) could
							//cause the page index to be off by one
							this._verticalPageIndex = nearestPageIndex;
						}
						else
						{
							this._verticalPageIndex = Math.floor(unroundedPageIndex);
						}
					}
				}
				else
				{
					this._verticalPageIndex = this._minVerticalScrollPosition;
				}
				if(this._verticalPageIndex < this._minVerticalScrollPosition)
				{
					this._verticalPageIndex = this._minVerticalScrollPosition;
				}
				if(this._verticalPageIndex > this._maxVerticalPageIndex)
				{
					this._verticalPageIndex = this._maxVerticalPageIndex;
				}
			}
		}

		/**
		 * @private
		 */
		protected function refreshScrollBarValues():void
		{
			if(this.horizontalScrollBar)
			{
				this.horizontalScrollBar.minimum = this._minHorizontalScrollPosition;
				this.horizontalScrollBar.maximum = this._maxHorizontalScrollPosition;
				this.horizontalScrollBar.value = this._horizontalScrollPosition;
				this.horizontalScrollBar.page = (this._maxHorizontalScrollPosition - this._minHorizontalScrollPosition) * this.actualPageWidth / this._viewPort.width;
				this.horizontalScrollBar.step = this.actualHorizontalScrollStep;
			}

			if(this.verticalScrollBar)
			{
				this.verticalScrollBar.minimum = this._minVerticalScrollPosition;
				this.verticalScrollBar.maximum = this._maxVerticalScrollPosition;
				this.verticalScrollBar.value = this._verticalScrollPosition;
				this.verticalScrollBar.page = (this._maxVerticalScrollPosition - this._minVerticalScrollPosition) * this.actualPageHeight / this._viewPort.height;
				this.verticalScrollBar.step = this.actualVerticalScrollStep;
			}
		}

		/**
		 * @private
		 */
		protected function showOrHideChildren():void
		{
			var childCount:int = this.numRawChildrenInternal;
			if(this.verticalScrollBar)
			{
				this.verticalScrollBar.visible = this._hasVerticalScrollBar;
				this.verticalScrollBar.touchable = this._hasVerticalScrollBar && this._interactionMode != ScrollInteractionMode.TOUCH;
				this.setRawChildIndexInternal(DisplayObject(this.verticalScrollBar), childCount - 1);
			}
			if(this.horizontalScrollBar)
			{
				this.horizontalScrollBar.visible = this._hasHorizontalScrollBar;
				this.horizontalScrollBar.touchable = this._hasHorizontalScrollBar && this._interactionMode != ScrollInteractionMode.TOUCH;
				if(this.verticalScrollBar)
				{
					this.setRawChildIndexInternal(DisplayObject(this.horizontalScrollBar), childCount - 2);
				}
				else
				{
					this.setRawChildIndexInternal(DisplayObject(this.horizontalScrollBar), childCount - 1);
				}
			}
			if(this.currentBackgroundSkin)
			{
				if(this._autoHideBackground)
				{
					this.currentBackgroundSkin.visible = this._viewPort.width <= this.actualWidth ||
						this._viewPort.height <= this.actualHeight ||
						this._horizontalScrollPosition < 0 ||
						this._horizontalScrollPosition > this._maxHorizontalScrollPosition ||
						this._verticalScrollPosition < 0 ||
						this._verticalScrollPosition > this._maxVerticalScrollPosition;
				}
				else
				{
					this.currentBackgroundSkin.visible = true;
				}
			}

		}

		/**
		 * @private
		 */
		protected function calculateViewPortOffsetsForFixedHorizontalScrollBar(forceScrollBars:Boolean = false, useActualBounds:Boolean = false):void
		{
			if(this.horizontalScrollBar && (this._measureViewPort || useActualBounds))
			{
				var scrollerWidth:Number = useActualBounds ? this.actualWidth : this._explicitWidth;
				if(!useActualBounds && !forceScrollBars &&
					scrollerWidth !== scrollerWidth) //isNaN
				{
					//even if explicitWidth is NaN, the view port might measure
					//a view port width smaller than its content width
					scrollerWidth = this._viewPort.visibleWidth + this._leftViewPortOffset + this._rightViewPortOffset;
				}
				var totalWidth:Number = this._viewPort.width + this._leftViewPortOffset + this._rightViewPortOffset;
				if(forceScrollBars || this._horizontalScrollPolicy === ScrollPolicy.ON ||
					((totalWidth > scrollerWidth || totalWidth > this._explicitMaxWidth) &&
						this._horizontalScrollPolicy !== ScrollPolicy.OFF))
				{
					this._hasHorizontalScrollBar = true;
					if(this._scrollBarDisplayMode === ScrollBarDisplayMode.FIXED)
					{
						if(this._horizontalScrollBarPosition === RelativePosition.TOP)
						{
							this._topViewPortOffset += this.horizontalScrollBar.height;
						}
						else
						{
							this._bottomViewPortOffset += this.horizontalScrollBar.height;
						}
					}
				}
				else
				{
					this._hasHorizontalScrollBar = false;
				}
			}
			else
			{
				this._hasHorizontalScrollBar = false;
			}
		}

		/**
		 * @private
		 */
		protected function calculateViewPortOffsetsForFixedVerticalScrollBar(forceScrollBars:Boolean = false, useActualBounds:Boolean = false):void
		{
			if(this.verticalScrollBar && (this._measureViewPort || useActualBounds))
			{
				var scrollerHeight:Number = useActualBounds ? this.actualHeight : this._explicitHeight;
				if(!useActualBounds && !forceScrollBars &&
					scrollerHeight !== scrollerHeight) //isNaN
				{
					//even if explicitHeight is NaN, the view port might measure
					//a view port height smaller than its content height
					scrollerHeight = this._viewPort.visibleHeight + this._topViewPortOffset + this._bottomViewPortOffset;
				}
				var totalHeight:Number = this._viewPort.height + this._topViewPortOffset + this._bottomViewPortOffset;
				if(forceScrollBars || this._verticalScrollPolicy === ScrollPolicy.ON ||
					((totalHeight > scrollerHeight || totalHeight > this._explicitMaxHeight) &&
						this._verticalScrollPolicy !== ScrollPolicy.OFF))
				{
					this._hasVerticalScrollBar = true;
					if(this._scrollBarDisplayMode === ScrollBarDisplayMode.FIXED)
					{
						if(this._verticalScrollBarPosition === RelativePosition.LEFT)
						{
							this._leftViewPortOffset += this.verticalScrollBar.width;
						}
						else
						{
							this._rightViewPortOffset += this.verticalScrollBar.width;
						}
					}
				}
				else
				{
					this._hasVerticalScrollBar = false;
				}
			}
			else
			{
				this._hasVerticalScrollBar = false;
			}
		}

		/**
		 * @private
		 */
		protected function calculateViewPortOffsets(forceScrollBars:Boolean = false, useActualBounds:Boolean = false):void
		{
			//in fixed mode, if we determine that scrolling is required, we
			//remember the offsets for later. if scrolling is not needed, then
			//we will ignore the offsets from here forward
			this._topViewPortOffset = this._paddingTop;
			this._rightViewPortOffset = this._paddingRight;
			this._bottomViewPortOffset = this._paddingBottom;
			this._leftViewPortOffset = this._paddingLeft;
			this.calculateViewPortOffsetsForFixedHorizontalScrollBar(forceScrollBars, useActualBounds);
			this.calculateViewPortOffsetsForFixedVerticalScrollBar(forceScrollBars, useActualBounds);
			//we need to double check the horizontal scroll bar if the scroll
			//bars are fixed because adding a vertical scroll bar may require a
			//horizontal one too.
			if(this._scrollBarDisplayMode == ScrollBarDisplayMode.FIXED &&
				this._hasVerticalScrollBar && !this._hasHorizontalScrollBar)
			{
				this.calculateViewPortOffsetsForFixedHorizontalScrollBar(forceScrollBars, useActualBounds);
			}
		}

		/**
		 * @private
		 */
		protected function refreshInteractionModeEvents():void
		{
			if(this._interactionMode == ScrollInteractionMode.TOUCH || this._interactionMode == ScrollInteractionMode.TOUCH_AND_SCROLL_BARS)
			{
				this.addEventListener(TouchEvent.TOUCH, scroller_touchHandler);
			}
			else
			{
				this.removeEventListener(TouchEvent.TOUCH, scroller_touchHandler);
			}

			if((this._interactionMode == ScrollInteractionMode.MOUSE || this._interactionMode == ScrollInteractionMode.TOUCH_AND_SCROLL_BARS) &&
				this._scrollBarDisplayMode == ScrollBarDisplayMode.FLOAT)
			{
				if(this.horizontalScrollBar)
				{
					this.horizontalScrollBar.addEventListener(TouchEvent.TOUCH, horizontalScrollBar_touchHandler);
				}
				if(this.verticalScrollBar)
				{
					this.verticalScrollBar.addEventListener(TouchEvent.TOUCH, verticalScrollBar_touchHandler);
				}
			}
			else
			{
				if(this.horizontalScrollBar)
				{
					this.horizontalScrollBar.removeEventListener(TouchEvent.TOUCH, horizontalScrollBar_touchHandler);
				}
				if(this.verticalScrollBar)
				{
					this.verticalScrollBar.removeEventListener(TouchEvent.TOUCH, verticalScrollBar_touchHandler);
				}
			}
		}

		/**
		 * Positions and sizes children based on the actual width and height
		 * values.
		 */
		protected function layoutChildren():void
		{
			var visibleWidth:Number = this.actualWidth - this._leftViewPortOffset - this._rightViewPortOffset;
			var visibleHeight:Number = this.actualHeight - this._topViewPortOffset - this._bottomViewPortOffset;

			if(this.currentBackgroundSkin !== null)
			{
				this.currentBackgroundSkin.width = this.actualWidth;
				this.currentBackgroundSkin.height = this.actualHeight;
			}

			if(this._snapScrollPositionsToPixels)
			{
				var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
				var pixelSize:Number = 1 / starling.contentScaleFactor;
				this._viewPort.x = Math.round((this._leftViewPortOffset - this._horizontalScrollPosition) / pixelSize) * pixelSize;
				this._viewPort.y = Math.round((this._topViewPortOffset - this._verticalScrollPosition) / pixelSize) * pixelSize;
			}
			else
			{
				this._viewPort.x = this._leftViewPortOffset - this._horizontalScrollPosition;
				this._viewPort.y = this._topViewPortOffset - this._verticalScrollPosition;
			}

			this.layoutPullViews();
			this.layoutScrollBars();
		}

		/**
		 * @private
		 */
		protected function layoutScrollBars():void
		{
			var visibleWidth:Number = this.actualWidth - this._leftViewPortOffset - this._rightViewPortOffset;
			var visibleHeight:Number = this.actualHeight - this._topViewPortOffset - this._bottomViewPortOffset;
			if(this.horizontalScrollBar !== null)
			{
				this.horizontalScrollBar.validate();
			}
			if(this.verticalScrollBar !== null)
			{
				this.verticalScrollBar.validate();
			}
			if(this.horizontalScrollBar !== null)
			{
				if(this._horizontalScrollBarPosition === RelativePosition.TOP)
				{
					this.horizontalScrollBar.y = this._paddingTop;
				}
				else
				{
					this.horizontalScrollBar.y = this._topViewPortOffset + visibleHeight;
				}
				this.horizontalScrollBar.x = this._leftViewPortOffset;
				if(this._scrollBarDisplayMode !== ScrollBarDisplayMode.FIXED)
				{
					this.horizontalScrollBar.y -= this.horizontalScrollBar.height;
					if((this._hasVerticalScrollBar || this._verticalScrollBarHideTween) && this.verticalScrollBar)
					{
						this.horizontalScrollBar.width = visibleWidth - this.verticalScrollBar.width;
					}
					else
					{
						this.horizontalScrollBar.width = visibleWidth;
					}
				}
				else
				{
					this.horizontalScrollBar.width = visibleWidth;
				}
			}

			if(this.verticalScrollBar !== null)
			{
				if(this._verticalScrollBarPosition === RelativePosition.LEFT)
				{
					this.verticalScrollBar.x = this._paddingLeft;
				}
				else
				{
					this.verticalScrollBar.x = this._leftViewPortOffset + visibleWidth;
				}
				this.verticalScrollBar.y = this._topViewPortOffset;
				if(this._scrollBarDisplayMode !== ScrollBarDisplayMode.FIXED)
				{
					this.verticalScrollBar.x -= this.verticalScrollBar.width;
					if((this._hasHorizontalScrollBar || this._horizontalScrollBarHideTween) && this.horizontalScrollBar)
					{
						this.verticalScrollBar.height = visibleHeight - this.horizontalScrollBar.height;
					}
					else
					{
						this.verticalScrollBar.height = visibleHeight;
					}
				}
				else
				{
					this.verticalScrollBar.height = visibleHeight;
				}
			}
		}

		/**
		 * @private
		 */
		protected function layoutPullViews():void
		{
			var viewPortIndex:int = this.getRawChildIndexInternal(DisplayObject(this._viewPort));
			if(this._topPullView !== null)
			{
				if(this._topPullView is IValidating)
				{
					IValidating(this._topPullView).validate();
				}
				this._topPullView.x = this._topPullView.pivotX * this._topPullView.scaleX +
					(this.actualWidth - this._topPullView.width) / 2;
				//if the animation is active, we don't want to interrupt it.
				//if the user starts dragging, the animation will be stopped.
				if(this._topPullTween === null)
				{
					var pullViewSize:Number = this._topPullView.height;
					var finalRatio:Number = this._topPullViewRatio;
					if(this._verticalScrollPosition < this._minVerticalScrollPosition)
					{
						var scrollRatio:Number = (this._minVerticalScrollPosition - this._verticalScrollPosition) / pullViewSize;
						if(scrollRatio > finalRatio)
						{
							finalRatio = scrollRatio;
						}
					}
					if(this._isTopPullViewActive && finalRatio < 1)
					{
						finalRatio = 1;
					}
					if(finalRatio > 0)
					{
						if(this._topPullViewDisplayMode === PullViewDisplayMode.FIXED)
						{
							this._topPullView.y = this._topViewPortOffset +
								this._topPullView.pivotY * this._topPullView.scaleY;
						}
						else
						{
							this._topPullView.y = this._topViewPortOffset +
								this._topPullView.pivotY * this._topPullView.scaleY +
								(finalRatio * pullViewSize) - pullViewSize;
						}
						this._topPullView.visible = true;
						this.refreshTopPullViewMask();
					}
					else
					{
						this._topPullView.visible = false;
					}
				}
				var pullViewIndex:int = this.getRawChildIndexInternal(this._topPullView);
				if(this._topPullViewDisplayMode === PullViewDisplayMode.FIXED &&
					this._hasElasticEdges)
				{
					//if fixed and elastic, the pull view should appear below
					//the view port
					if(viewPortIndex < pullViewIndex)
					{
						this.setRawChildIndexInternal(this._topPullView, viewPortIndex);
						viewPortIndex++;
					}
				}
				else
				{
					//otherwise, it should appear above
					if(viewPortIndex > pullViewIndex)
					{
						this.removeRawChildInternal(this._topPullView);
						this.addRawChildAtInternal(this._topPullView, viewPortIndex);
						viewPortIndex--;
					}
				}
			}
			if(this._rightPullView !== null)
			{
				if(this._rightPullView is IValidating)
				{
					IValidating(this._rightPullView).validate();
				}
				this._rightPullView.y = this._rightPullView.pivotY * this._rightPullView.scaleY +
					(this.actualHeight - this._rightPullView.height) / 2;
				//if the animation is active, we don't want to interrupt it.
				//if the user starts dragging, the animation will be stopped.
				if(this._rightPullTween === null)
				{
					pullViewSize = this._rightPullView.width;
					finalRatio = this._rightPullViewRatio;
					if(this._horizontalScrollPosition > this._maxHorizontalScrollPosition)
					{
						scrollRatio = (this._horizontalScrollPosition - this._maxHorizontalScrollPosition) / pullViewSize;
						if(scrollRatio > finalRatio)
						{
							finalRatio = scrollRatio;
						}
					}
					if(this._isRightPullViewActive && finalRatio < 1)
					{
						finalRatio = 1;
					}
					if(finalRatio > 0)
					{
						if(this._rightPullViewDisplayMode === PullViewDisplayMode.FIXED)
						{
							this._rightPullView.x = this._rightPullView.pivotX * this._rightPullView.scaleX +
								this.actualWidth - this._rightViewPortOffset - pullViewSize;
						}
						else
						{
							this._rightPullView.x = this._rightPullView.pivotX * this._rightPullView.scaleX +
								this.actualWidth - this._rightViewPortOffset - (finalRatio * pullViewSize);
						}
						this._rightPullView.visible = true;
						this.refreshRightPullViewMask();
					}
					else
					{
						this._rightPullView.visible = false;
					}
				}
				pullViewIndex = this.getRawChildIndexInternal(this._rightPullView);
				if(this._rightPullViewDisplayMode === PullViewDisplayMode.FIXED &&
					this._hasElasticEdges)
				{
					//if fixed and elastic, the pull view should appear below
					//the view port
					if(viewPortIndex < pullViewIndex)
					{
						this.setRawChildIndexInternal(this._rightPullView, viewPortIndex);
						viewPortIndex++;
					}
				}
				else
				{
					//otherwise, it should appear above
					if(viewPortIndex > pullViewIndex)
					{
						this.removeRawChildInternal(this._rightPullView);
						this.addRawChildAtInternal(this._rightPullView, viewPortIndex);
						viewPortIndex--;
					}
				}
			}
			if(this._bottomPullView !== null)
			{
				if(this._bottomPullView is IValidating)
				{
					IValidating(this._bottomPullView).validate();
				}
				this._bottomPullView.x = this._bottomPullView.pivotX * this._bottomPullView.scaleX +
					(this.actualWidth - this._bottomPullView.width) / 2;
				//if the animation is active, we don't want to interrupt it.
				//if the user starts dragging, the animation will be stopped.
				if(this._bottomPullTween === null)
				{
					pullViewSize = this._bottomPullView.height;
					finalRatio = this._bottomPullViewRatio;
					if(this._verticalScrollPosition > this._maxVerticalScrollPosition)
					{
						//if the scroll position is greater than the pull
						//position, then prefer the scroll position
						scrollRatio = (this._verticalScrollPosition - this._maxVerticalScrollPosition) / pullViewSize;
						if(scrollRatio > finalRatio)
						{
							finalRatio = scrollRatio;
						}
					}
					if(this._isBottomPullViewActive && finalRatio < 1)
					{
						finalRatio = 1;
					}
					if(finalRatio > 0)
					{
						if(this._bottomPullViewDisplayMode === PullViewDisplayMode.FIXED)
						{
							this._bottomPullView.y = this._bottomPullView.pivotY * this._bottomPullView.scaleY +
								this.actualHeight - this._bottomViewPortOffset - pullViewSize;
						}
						else
						{
							this._bottomPullView.y = this._bottomPullView.pivotY * this._bottomPullView.scaleY +
								this.actualHeight - this._bottomViewPortOffset - (finalRatio * pullViewSize);
						}
						this._bottomPullView.visible = true;
						this.refreshBottomPullViewMask();
					}
					else
					{
						this._bottomPullView.visible = false;
					}
				}
				pullViewIndex = this.getRawChildIndexInternal(this._bottomPullView);
				if(this._bottomPullViewDisplayMode === PullViewDisplayMode.FIXED &&
					this._hasElasticEdges)
				{
					//if fixed and elastic, the pull view should appear below
					//the view port
					if(viewPortIndex < pullViewIndex)
					{
						this.setRawChildIndexInternal(this._bottomPullView, viewPortIndex);
						viewPortIndex++;
					}
				}
				else
				{
					//otherwise, it should appear above
					if(viewPortIndex > pullViewIndex)
					{
						this.removeRawChildInternal(this._bottomPullView);
						this.addRawChildAtInternal(this._bottomPullView, viewPortIndex);
						viewPortIndex--;
					}
				}
			}
			if(this._leftPullView !== null)
			{
				if(this._leftPullView is IValidating)
				{
					IValidating(this._leftPullView).validate();
				}
				this._leftPullView.y = this._leftPullView.pivotY * this._leftPullView.scaleY +
					(this.actualHeight - this._leftPullView.height) / 2;
				//if the animation is active, we don't want to interrupt it.
				//if the user starts dragging, the animation will be stopped.
				if(this._leftPullTween === null)
				{
					pullViewSize = this._leftPullView.width;
					finalRatio = this._leftPullViewRatio;
					if(this._horizontalScrollPosition < this._minHorizontalScrollPosition)
					{
						//if the scroll position is less than the pull position,
						//then prefer the scroll position
						scrollRatio = (this._minHorizontalScrollPosition - this._horizontalScrollPosition) / pullViewSize;
						if(scrollRatio > finalRatio)
						{
							finalRatio = scrollRatio;
						}
					}
					if(this._isLeftPullViewActive && finalRatio < 1)
					{
						finalRatio = 1;
					}
					if(finalRatio > 0)
					{
						if(this._leftPullViewDisplayMode === PullViewDisplayMode.FIXED)
						{
							this._leftPullView.x = this._leftViewPortOffset +
								this._leftPullView.pivotX * this._leftPullView.scaleX;
						}
						else
						{
							this._leftPullView.x = this._leftViewPortOffset +
								this._leftPullView.pivotX * this._leftPullView.scaleX +
								 (finalRatio * pullViewSize) - pullViewSize;
						}
						this._leftPullView.visible = true;
						this.refreshLeftPullViewMask();
					}
					else
					{
						this._leftPullView.visible = false;
					}
				}
				pullViewIndex = this.getRawChildIndexInternal(this._leftPullView);
				if(this._leftPullViewDisplayMode === PullViewDisplayMode.FIXED &&
					this._hasElasticEdges)
				{
					//if fixed and elastic, the pull view should appear below
					//the view port
					if(viewPortIndex < pullViewIndex)
					{
						this.setRawChildIndexInternal(this._leftPullView, viewPortIndex);
					}
				}
				else
				{
					//otherwise, it should appear above
					if(viewPortIndex > pullViewIndex)
					{
						this.removeRawChildInternal(this._leftPullView);
						this.addRawChildAtInternal(this._leftPullView, viewPortIndex);
					}
				}
			}
		}

		/**
		 * @private
		 */
		protected function refreshTopPullViewMask():void
		{
			var pullViewHeight:Number = this._topPullView.height / this._topPullView.scaleY;
			var mask:DisplayObject = this._topPullView.mask;
			var maskHeight:Number = pullViewHeight + ((this._topPullView.y - this._topPullView.pivotY * this._topPullView.scaleY - this._paddingTop) / this._topPullView.scaleY);
			if(maskHeight < 0)
			{
				maskHeight = 0;
			}
			else if(maskHeight > pullViewHeight)
			{
				maskHeight = pullViewHeight;
			}
			mask.width = this._topPullView.width / this._topPullView.scaleX;
			mask.height = maskHeight;
			mask.x = 0;
			mask.y = pullViewHeight - maskHeight;
		}

		/**
		 * @private
		 */
		protected function refreshRightPullViewMask():void
		{
			var pullViewWidth:Number = this._rightPullView.width / this._rightPullView.scaleX;
			var mask:DisplayObject = this._rightPullView.mask;
			var maskWidth:Number = this.actualWidth - this._rightViewPortOffset - ((this._rightPullView.x - this._rightPullView.pivotX / this._rightPullView.scaleX) / this._rightPullView.scaleX);
			if(maskWidth < 0)
			{
				maskWidth = 0;
			}
			else if(maskWidth > pullViewWidth)
			{
				maskWidth = pullViewWidth;
			}
			mask.width = maskWidth;
			mask.height = this._rightPullView.height / this._rightPullView.scaleY;
			mask.x = 0;
			mask.y = 0;
		}

		/**
		 * @private
		 */
		protected function refreshBottomPullViewMask():void
		{
			var pullViewHeight:Number = this._bottomPullView.height / this._bottomPullView.scaleY;
			var mask:DisplayObject = this._bottomPullView.mask;
			var maskHeight:Number = this.actualHeight - this._bottomViewPortOffset - ((this._bottomPullView.y - this._bottomPullView.pivotY / this._bottomPullView.scaleY) / this._bottomPullView.scaleY);
			if(maskHeight < 0)
			{
				maskHeight = 0;
			}
			else if(maskHeight > pullViewHeight)
			{
				maskHeight = pullViewHeight;
			}
			mask.width = this._bottomPullView.width / this._bottomPullView.scaleX;
			mask.height = maskHeight;
			mask.x = 0;
			mask.y = 0;
		}

		/**
		 * @private
		 */
		protected function refreshLeftPullViewMask():void
		{
			var pullViewWidth:Number = this._leftPullView.width / this._leftPullView.scaleX;
			var mask:DisplayObject = this._leftPullView.mask;
			var maskWidth:Number = pullViewWidth + ((this._leftPullView.x - this._leftPullView.pivotX * this._leftPullView.scaleX - this._paddingLeft) / this._leftPullView.scaleX);
			if(maskWidth < 0)
			{
				maskWidth = 0;
			}
			else if(maskWidth > pullViewWidth)
			{
				maskWidth = pullViewWidth;
			}
			mask.width = maskWidth;
			mask.height = this._leftPullView.height / this._leftPullView.scaleY;
			mask.x = pullViewWidth - maskWidth;
			mask.y = 0;
		}

		/**
		 * @private
		 */
		protected function refreshMask():void
		{
			if(!this._clipContent)
			{
				return;
			}
			var clipWidth:Number = this.actualWidth - this._leftViewPortOffset - this._rightViewPortOffset;
			if(clipWidth < 0)
			{
				clipWidth = 0;
			}
			var clipHeight:Number = this.actualHeight - this._topViewPortOffset - this._bottomViewPortOffset;
			if(clipHeight < 0)
			{
				clipHeight = 0;
			}
			var mask:Quad = this._viewPort.mask as Quad;
			if(!mask)
			{
				mask = new Quad(1, 1, 0xff0ff);
				this._viewPort.mask = mask;
			}
			mask.x = this._horizontalScrollPosition;
			mask.y = this._verticalScrollPosition;
			mask.width = clipWidth;
			mask.height = clipHeight;
		}

		/**
		 * @private
		 */
		protected function get numRawChildrenInternal():int
		{
			if(this is IScrollContainer)
			{
				return IScrollContainer(this).numRawChildren;
			}
			return this.numChildren;
		}

		/**
		 * @private
		 */
		protected function addRawChildInternal(child:DisplayObject):DisplayObject
		{
			if(this is IScrollContainer)
			{
				return IScrollContainer(this).addRawChild(child);
			}
			return this.addChild(child);
		}

		/**
		 * @private
		 */
		protected function addRawChildAtInternal(child:DisplayObject, index:int):DisplayObject
		{
			if(this is IScrollContainer)
			{
				return IScrollContainer(this).addRawChildAt(child, index);
			}
			return this.addChildAt(child, index);
		}

		/**
		 * @private
		 */
		protected function removeRawChildInternal(child:DisplayObject, dispose:Boolean = false):DisplayObject
		{
			if(this is IScrollContainer)
			{
				return IScrollContainer(this).removeRawChild(child, dispose);
			}
			return this.removeChild(child, dispose);
		}

		/**
		 * @private
		 */
		protected function removeRawChildAtInternal(index:int, dispose:Boolean = false):DisplayObject
		{
			if(this is IScrollContainer)
			{
				return IScrollContainer(this).removeRawChildAt(index, dispose);
			}
			return this.removeChildAt(index, dispose);
		}

		/**
		 * @private
		 */
		protected function getRawChildIndexInternal(child:DisplayObject):int
		{
			if(this is IScrollContainer)
			{
				return IScrollContainer(this).getRawChildIndex(child);
			}
			return this.getChildIndex(child);
		}

		/**
		 * @private
		 */
		protected function setRawChildIndexInternal(child:DisplayObject, index:int):void
		{
			if(this is IScrollContainer)
			{
				IScrollContainer(this).setRawChildIndex(child, index);
				return;
			}
			this.setChildIndex(child, index);
		}

		/**
		 * @private
		 */
		protected function updateHorizontalScrollFromTouchPosition(touchX:Number):void
		{
			var offset:Number = this._startTouchX - touchX;
			var position:Number = this._startHorizontalScrollPosition + offset;
			var adjustedMinScrollPosition:Number = this._minHorizontalScrollPosition;
			if(this._isLeftPullViewActive && this._hasElasticEdges)
			{
				adjustedMinScrollPosition -= this._leftPullView.width;
			}
			var adjustedMaxScrollPosition:Number = this._maxHorizontalScrollPosition;
			if(this._isRightPullViewActive && this._hasElasticEdges)
			{
				adjustedMaxScrollPosition += this._rightPullView.width;
			}
			if(position < adjustedMinScrollPosition)
			{
				//first, calculate the position as if elastic edges were enabled
				position = position - (position - adjustedMinScrollPosition) * (1 - this._elasticity);
				if(this._leftPullView !== null && position < adjustedMinScrollPosition)
				{
					if(this._isLeftPullViewActive)
					{
						this.leftPullViewRatio = 1;
					}
					else
					{
						//save the difference between that position and the minimum
						//to use for the position of the pull view
						this.leftPullViewRatio = (adjustedMinScrollPosition - position) / this._leftPullView.width;
					}
				}
				if(this._rightPullView !== null && !this._isRightPullViewActive)
				{
					this.rightPullViewRatio = 0;
				}
				if(!this._hasElasticEdges ||
					(this._isRightPullViewActive && this._minHorizontalScrollPosition == this._maxHorizontalScrollPosition))
				{
					//if elastic edges aren't enabled, use the minimum
					position = adjustedMinScrollPosition;
				}
			}
			else if(position > adjustedMaxScrollPosition)
			{
				position = position - (position - adjustedMaxScrollPosition) * (1 - this._elasticity);
				if(this._rightPullView !== null && position > adjustedMaxScrollPosition)
				{
					if(this._isRightPullViewActive)
					{
						this.rightPullViewRatio = 1;
					}
					else
					{
						this.rightPullViewRatio = (position - adjustedMaxScrollPosition) / this._rightPullView.width;
					}
				}
				if(this._leftPullView !== null && !this._isLeftPullViewActive)
				{
					this.leftPullViewRatio = 0;
				}
				if(!this._hasElasticEdges ||
					(this._isLeftPullViewActive && this._minHorizontalScrollPosition == this._maxHorizontalScrollPosition))
				{
					position = adjustedMaxScrollPosition;
				}
			}
			else
			{
				if(this._leftPullView !== null && !this._isLeftPullViewActive)
				{
					this.leftPullViewRatio = 0;
				}
				if(this._rightPullView !== null && !this._isRightPullViewActive)
				{
					this.rightPullViewRatio = 0;
				}
			}
			if(this._leftPullViewRatio > 0)
			{
				if(this._leftPullTween !== null)
				{
					this._leftPullTween.dispatchEventWith(Event.REMOVE_FROM_JUGGLER);
					this._leftPullTween = null;
				}
				//ensure that the component invalidates, even if the
				//horizontalScrollPosition does not change
				this.invalidate(INVALIDATION_FLAG_SCROLL);
			}
			if(this._rightPullViewRatio > 0)
			{
				if(this._rightPullTween !== null)
				{
					this._rightPullTween.dispatchEventWith(Event.REMOVE_FROM_JUGGLER);
					this._rightPullTween = null;
				}
				//see note above with previous call to invalidate()
				this.invalidate(INVALIDATION_FLAG_SCROLL);
			}
			this.horizontalScrollPosition = position;
		}

		/**
		 * @private
		 */
		protected function updateVerticalScrollFromTouchPosition(touchY:Number):void
		{
			var offset:Number = this._startTouchY - touchY;
			var position:Number = this._startVerticalScrollPosition + offset;
			var adjustedMinScrollPosition:Number = this._minVerticalScrollPosition;
			if(this._isTopPullViewActive && this._hasElasticEdges)
			{
				adjustedMinScrollPosition -= this._topPullView.height;
			}
			var adjustedMaxScrollPosition:Number = this._maxVerticalScrollPosition;
			if(this._isBottomPullViewActive && this._hasElasticEdges)
			{
				adjustedMaxScrollPosition += this._bottomPullView.height;
			}
			if(position < adjustedMinScrollPosition)
			{
				//first, calculate the position as if elastic edges were enabled
				position = position - (position - adjustedMinScrollPosition) * (1 - this._elasticity);
				if(this._topPullView !== null && position < adjustedMinScrollPosition)
				{
					if(this._isTopPullViewActive)
					{
						this.topPullViewRatio = 1;
					}
					else
					{
						this.topPullViewRatio = (adjustedMinScrollPosition - position) / this._topPullView.height;
					}
				}
				if(this._bottomPullView !== null && !this._isBottomPullViewActive)
				{
					this.bottomPullViewRatio = 0;
				}
				if(!this._hasElasticEdges ||
					(this._isBottomPullViewActive && this._minVerticalScrollPosition == this._maxVerticalScrollPosition))
				{
					//if elastic edges aren't enabled, use the minimum
					position = adjustedMinScrollPosition;
				}
			}
			else if(position > adjustedMaxScrollPosition)
			{
				position = position - (position - adjustedMaxScrollPosition) * (1 - this._elasticity);
				if(this._bottomPullView !== null && position > adjustedMaxScrollPosition)
				{
					if(this._isBottomPullViewActive)
					{
						this.bottomPullViewRatio = 1;
					}
					else
					{
						this.bottomPullViewRatio = (position - adjustedMaxScrollPosition) / this._bottomPullView.height
					}
				}
				if(this._topPullView !== null && !this._isTopPullViewActive)
				{
					this.topPullViewRatio = 0;
				}
				if(!this._hasElasticEdges ||
					(this._isTopPullViewActive && this._minVerticalScrollPosition == this._maxVerticalScrollPosition))
				{
					position = adjustedMaxScrollPosition;
				}
			}
			else
			{
				if(this._topPullView !== null && !this._isTopPullViewActive)
				{
					this.topPullViewRatio = 0;
				}
				if(this._bottomPullView !== null && !this._isBottomPullViewActive)
				{
					this.bottomPullViewRatio = 0;
				}
			}
			if(this._topPullViewRatio > 0)
			{
				if(this._topPullTween !== null)
				{
					this._topPullTween.dispatchEventWith(Event.REMOVE_FROM_JUGGLER);
					this._topPullTween = null;
				}
				//ensure that the component invalidates, even if the
				//verticalScrollPosition does not change
				this.invalidate(INVALIDATION_FLAG_SCROLL);
			}
			if(this._bottomPullViewRatio > 0)
			{
				if(this._bottomPullTween !== null)
				{
					this._bottomPullTween.dispatchEventWith(Event.REMOVE_FROM_JUGGLER);
					this._bottomPullTween = null;
				}
				//see note above with previous call to invalidate()
				this.invalidate(INVALIDATION_FLAG_SCROLL);
			}
			this.verticalScrollPosition = position;
		}

		/**
		 * Immediately throws the scroller to the specified position, with
		 * optional animation. If you want to throw in only one direction, pass
		 * in <code>NaN</code> for the value that you do not want to change. The
		 * scroller should be validated before throwing.
		 *
		 * @see #scrollToPosition()
		 */
		protected function throwTo(targetHorizontalScrollPosition:Number = NaN, targetVerticalScrollPosition:Number = NaN, duration:Number = 0.5):void
		{
			var changedPosition:Boolean = false;
			if(targetHorizontalScrollPosition === targetHorizontalScrollPosition) //!isNaN
			{
				if(this._snapToPages && targetHorizontalScrollPosition > this._minHorizontalScrollPosition &&
					targetHorizontalScrollPosition < this._maxHorizontalScrollPosition)
				{
					targetHorizontalScrollPosition = roundToNearest(targetHorizontalScrollPosition, this.actualPageWidth);
				}
				if(this._horizontalAutoScrollTween)
				{
					Starling.juggler.remove(this._horizontalAutoScrollTween);
					this._horizontalAutoScrollTween = null;
				}
				if(this._horizontalScrollPosition != targetHorizontalScrollPosition)
				{
					changedPosition = true;
					this.revealHorizontalScrollBar();
					this.startScroll();
					if(duration == 0)
					{
						this.horizontalScrollPosition = targetHorizontalScrollPosition;
					}
					else
					{
						this._startHorizontalScrollPosition = this._horizontalScrollPosition;
						this._targetHorizontalScrollPosition = targetHorizontalScrollPosition;
						this._horizontalAutoScrollTween = new Tween(this, duration, this._throwEase);
						this._horizontalAutoScrollTween.animate("horizontalScrollPosition", targetHorizontalScrollPosition);
						if(this._snapScrollPositionsToPixels)
						{
							this._horizontalAutoScrollTween.onUpdate = this.horizontalAutoScrollTween_onUpdate;
						}
						this._horizontalAutoScrollTween.onComplete = this.horizontalAutoScrollTween_onComplete;
						Starling.juggler.add(this._horizontalAutoScrollTween);
						this.refreshHorizontalAutoScrollTweenEndRatio();
					}
				}
				else
				{
					this.finishScrollingHorizontally();
				}
			}

			if(targetVerticalScrollPosition === targetVerticalScrollPosition) //!isNaN
			{
				if(this._snapToPages && targetVerticalScrollPosition > this._minVerticalScrollPosition &&
					targetVerticalScrollPosition < this._maxVerticalScrollPosition)
				{
					targetVerticalScrollPosition = roundToNearest(targetVerticalScrollPosition, this.actualPageHeight);
				}
				if(this._verticalAutoScrollTween)
				{
					Starling.juggler.remove(this._verticalAutoScrollTween);
					this._verticalAutoScrollTween = null;
				}
				if(this._verticalScrollPosition != targetVerticalScrollPosition)
				{
					changedPosition = true;
					this.revealVerticalScrollBar();
					this.startScroll();
					if(duration == 0)
					{
						this.verticalScrollPosition = targetVerticalScrollPosition;
					}
					else
					{
						this._startVerticalScrollPosition = this._verticalScrollPosition;
						this._targetVerticalScrollPosition = targetVerticalScrollPosition;
						this._verticalAutoScrollTween = new Tween(this, duration, this._throwEase);
						this._verticalAutoScrollTween.animate("verticalScrollPosition", targetVerticalScrollPosition);
						if(this._snapScrollPositionsToPixels)
						{
							this._verticalAutoScrollTween.onUpdate = this.verticalAutoScrollTween_onUpdate;
						}
						this._verticalAutoScrollTween.onComplete = this.verticalAutoScrollTween_onComplete;
						Starling.juggler.add(this._verticalAutoScrollTween);
						this.refreshVerticalAutoScrollTweenEndRatio();
					}
				}
				else
				{
					this.finishScrollingVertically();
				}
			}

			if(changedPosition && duration == 0)
			{
				this.completeScroll();
			}
		}

		/**
		 * Immediately throws the scroller to the specified page index, with
		 * optional animation. If you want to throw in only one direction, pass
		 * in the value from the <code>horizontalPageIndex</code> or
		 * <code>verticalPageIndex</code> property to the appropriate parameter.
		 * The scroller must be validated before throwing, to ensure that the
		 * minimum and maximum scroll positions are accurate.
		 *
		 * @see #scrollToPageIndex()
		 */
		protected function throwToPage(targetHorizontalPageIndex:int, targetVerticalPageIndex:int, duration:Number = 0.5):void
		{
			var targetHorizontalScrollPosition:Number = this._horizontalScrollPosition;
			if(targetHorizontalPageIndex >= this._minHorizontalPageIndex)
			{
				targetHorizontalScrollPosition = this.actualPageWidth * targetHorizontalPageIndex;
			}
			if(targetHorizontalScrollPosition < this._minHorizontalScrollPosition)
			{
				targetHorizontalScrollPosition = this._minHorizontalScrollPosition;
			}
			if(targetHorizontalScrollPosition > this._maxHorizontalScrollPosition)
			{
				targetHorizontalScrollPosition = this._maxHorizontalScrollPosition;
			}
			var targetVerticalScrollPosition:Number = this._verticalScrollPosition;
			if(targetVerticalPageIndex >= this._minVerticalPageIndex)
			{
				targetVerticalScrollPosition = this.actualPageHeight * targetVerticalPageIndex;
			}
			if(targetVerticalScrollPosition < this._minVerticalScrollPosition)
			{
				targetVerticalScrollPosition = this._minVerticalScrollPosition;
			}
			if(targetVerticalScrollPosition > this._maxVerticalScrollPosition)
			{
				targetVerticalScrollPosition = this._maxVerticalScrollPosition;
			}
			if(targetHorizontalPageIndex >= this._minHorizontalPageIndex)
			{
				this._horizontalPageIndex = targetHorizontalPageIndex;
			}
			if(targetVerticalPageIndex >= this._minVerticalPageIndex)
			{
				this._verticalPageIndex = targetVerticalPageIndex;
			}
			this.throwTo(targetHorizontalScrollPosition, targetVerticalScrollPosition, duration);
		}

		/**
		 * @private
		 */
		protected function calculateDynamicThrowDuration(pixelsPerMS:Number):Number
		{
			return (Math.log(MINIMUM_VELOCITY / Math.abs(pixelsPerMS)) / this._logDecelerationRate) / 1000;
		}

		/**
		 * @private
		 */
		protected function calculateThrowDistance(pixelsPerMS:Number):Number
		{
			return (pixelsPerMS - MINIMUM_VELOCITY) / this._logDecelerationRate;
		}

		/**
		 * @private
		 */
		protected function finishScrollingHorizontally():void
		{
			var adjustedMinScrollPosition:Number = this._minHorizontalScrollPosition;
			if(this._isLeftPullViewActive && this._hasElasticEdges)
			{
				adjustedMinScrollPosition -= this._leftPullView.width;
			}
			var adjustedMaxScrollPosition:Number = this._maxHorizontalScrollPosition;
			if(this._isRightPullViewActive && this._hasElasticEdges)
			{
				adjustedMaxScrollPosition += this._rightPullView.width;
			}
			var targetHorizontalScrollPosition:Number = NaN;
			if(this._horizontalScrollPosition < adjustedMinScrollPosition)
			{
				targetHorizontalScrollPosition = adjustedMinScrollPosition;
			}
			else if(this._horizontalScrollPosition > adjustedMaxScrollPosition)
			{
				targetHorizontalScrollPosition = adjustedMaxScrollPosition;
			}

			this._isDraggingHorizontally = false;
			if(targetHorizontalScrollPosition !== targetHorizontalScrollPosition) //isNaN
			{
				this.completeScroll();
			}
			else if(Math.abs(targetHorizontalScrollPosition - this._horizontalScrollPosition) < 1)
			{
				//this distance is too small to animate. just finish now.
				this.horizontalScrollPosition = targetHorizontalScrollPosition;
				this.completeScroll();
			}
			else
			{
				this.throwTo(targetHorizontalScrollPosition, NaN, this._elasticSnapDuration);
			}
			this.restoreHorizontalPullViews();
		}

		/**
		 * @private
		 */
		protected function finishScrollingVertically():void
		{
			var adjustedMinScrollPosition:Number = this._minVerticalScrollPosition;
			if(this._isTopPullViewActive && this._hasElasticEdges)
			{
				adjustedMinScrollPosition -= this._topPullView.height;
			}
			var adjustedMaxScrollPosition:Number = this._maxVerticalScrollPosition;
			if(this._isBottomPullViewActive && this._hasElasticEdges)
			{
				adjustedMaxScrollPosition += this._bottomPullView.height;
			}
			var targetVerticalScrollPosition:Number = NaN;
			if(this._verticalScrollPosition < adjustedMinScrollPosition)
			{
				targetVerticalScrollPosition = adjustedMinScrollPosition;
			}
			else if(this._verticalScrollPosition > adjustedMaxScrollPosition)
			{
				targetVerticalScrollPosition = adjustedMaxScrollPosition;
			}

			this._isDraggingVertically = false;
			if(targetVerticalScrollPosition !== targetVerticalScrollPosition) //isNaN
			{
				this.completeScroll();
			}
			else if(Math.abs(targetVerticalScrollPosition - this._verticalScrollPosition) < 1)
			{
				//this distance is too small to animate. just finish now.
				this.verticalScrollPosition = targetVerticalScrollPosition;
				this.completeScroll();
			}
			else
			{
				this.throwTo(NaN, targetVerticalScrollPosition, this._elasticSnapDuration);
			}
			this.restoreVerticalPullViews();
		}

		/**
		 * @private
		 */
		protected function restoreVerticalPullViews():void
		{
			if(this._topPullView !== null &&
				this._topPullViewRatio > 0)
			{
				if(this._topPullTween !== null)
				{
					this._topPullTween.dispatchEventWith(Event.REMOVE_FROM_JUGGLER);
					this._topPullTween = null;
				}
				if(this._topPullViewDisplayMode === PullViewDisplayMode.DRAG)
				{
					var yPosition:Number = this._topViewPortOffset + 
						this._topPullView.pivotY * this._topPullView.scaleY;
					if(!this._isTopPullViewActive)
					{
						yPosition -= this._topPullView.height;
					}
					if(this._topPullView.y != yPosition)
					{
						this._topPullTween = new Tween(this._topPullView, this._elasticSnapDuration, this._throwEase);
						this._topPullTween.animate("y", yPosition);
						this._topPullTween.onUpdate = this.refreshTopPullViewMask;
						this._topPullTween.onComplete = this.topPullTween_onComplete;
						Starling.juggler.add(this._topPullTween);
					}
				}
				else
				{
					this.topPullTween_onComplete();
				}
			}
			if(this._bottomPullView !== null &&
				this._bottomPullViewRatio > 0)
			{
				if(this._bottomPullTween !== null)
				{
					this._bottomPullTween.dispatchEventWith(Event.REMOVE_FROM_JUGGLER);
					this._bottomPullTween = null;
				}
				if(this._bottomPullViewDisplayMode === PullViewDisplayMode.DRAG)
				{
					yPosition = this.actualHeight - this._bottomViewPortOffset +
						this._bottomPullView.pivotY * this._bottomPullView.scaleY;
					if(this._isBottomPullViewActive)
					{
						yPosition -= this._bottomPullView.height;
					}
					if(this._bottomPullView.y != yPosition)
					{
						this._bottomPullTween = new Tween(this._bottomPullView, this._elasticSnapDuration, this._throwEase);
						this._bottomPullTween.animate("y", yPosition);
						this._bottomPullTween.onUpdate = this.refreshBottomPullViewMask;
						this._bottomPullTween.onComplete = this.bottomPullTween_onComplete;
						Starling.juggler.add(this._bottomPullTween);
					}
				}
				else
				{
					this.bottomPullTween_onComplete();
				}
			}
		}

		/**
		 * @private
		 */
		protected function restoreHorizontalPullViews():void
		{
			if(this._leftPullView !== null &&
				this._leftPullViewRatio > 0)
			{
				if(this._leftPullTween !== null)
				{
					this._leftPullTween.dispatchEventWith(Event.REMOVE_FROM_JUGGLER);
					this._leftPullTween = null;
				}
				if(this._leftPullViewDisplayMode === PullViewDisplayMode.DRAG)
				{
					var xPosition:Number = this._leftViewPortOffset +
						this._leftPullView.pivotX * this._leftPullView.scaleX;
					if(!this._isLeftPullViewActive)
					{
						xPosition -= this._leftPullView.width;
					}
					if(this._leftPullView.x != xPosition)
					{
						this._leftPullTween = new Tween(this._leftPullView, this._elasticSnapDuration, this._throwEase);
						this._leftPullTween.animate("x", xPosition);
						this._leftPullTween.onUpdate = this.refreshLeftPullViewMask;
						this._leftPullTween.onComplete = this.leftPullTween_onComplete;
						Starling.juggler.add(this._leftPullTween);
					}
				}
				else
				{
					this.leftPullTween_onComplete();
				}
			}
			if(this._rightPullView !== null &&
				this._rightPullViewRatio > 0)
			{
				if(this._rightPullTween !== null)
				{
					this._rightPullTween.dispatchEventWith(Event.REMOVE_FROM_JUGGLER);
					this._rightPullTween = null;
				}
				if(this._rightPullViewDisplayMode === PullViewDisplayMode.DRAG)
				{
					xPosition = this.actualWidth - this._rightViewPortOffset +
						this._rightPullView.pivotX * this._rightPullView.scaleX;
					if(this._isRightPullViewActive)
					{
						xPosition -= this._rightPullView.width;
					}
					if(this._rightPullView.x != xPosition)
					{
						this._rightPullTween = new Tween(this._rightPullView, this._elasticSnapDuration, this._throwEase);
						this._rightPullTween.animate("x", xPosition);
						this._rightPullTween.onUpdate = this.refreshRightPullViewMask;
						this._rightPullTween.onComplete = this.rightPullTween_onComplete;
						Starling.juggler.add(this._rightPullTween);
					}
				}
				else
				{
					this.rightPullTween_onComplete();
				}
			}
		}

		/**
		 * @private
		 */
		protected function throwHorizontally(pixelsPerMS:Number):void
		{
			if(this._snapToPages && !this._snapOnComplete)
			{
				var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
				var inchesPerSecond:Number = 1000 * pixelsPerMS / (DeviceCapabilities.dpi / starling.contentScaleFactor);
				if(inchesPerSecond > this._minimumPageThrowVelocity)
				{
					var snappedPageHorizontalScrollPosition:Number = roundDownToNearest(this._horizontalScrollPosition, this.actualPageWidth);
				}
				else if(inchesPerSecond < -this._minimumPageThrowVelocity)
				{
					snappedPageHorizontalScrollPosition = roundUpToNearest(this._horizontalScrollPosition, this.actualPageWidth);
				}
				else
				{
					var lastPageWidth:Number = this._maxHorizontalScrollPosition % this.actualPageWidth;
					var startOfLastPage:Number = this._maxHorizontalScrollPosition - lastPageWidth;
					if(lastPageWidth < this.actualPageWidth && this._horizontalScrollPosition >= startOfLastPage)
					{
						var lastPagePosition:Number = this._horizontalScrollPosition - startOfLastPage;
						if(inchesPerSecond > this._minimumPageThrowVelocity)
						{
							snappedPageHorizontalScrollPosition = startOfLastPage + roundDownToNearest(lastPagePosition, lastPageWidth);
						}
						else if(inchesPerSecond < -this._minimumPageThrowVelocity)
						{
							snappedPageHorizontalScrollPosition = startOfLastPage + roundUpToNearest(lastPagePosition, lastPageWidth);
						}
						else
						{
							snappedPageHorizontalScrollPosition = startOfLastPage + roundToNearest(lastPagePosition, lastPageWidth);
						}
					}
					else
					{
						snappedPageHorizontalScrollPosition = roundToNearest(this._horizontalScrollPosition, this.actualPageWidth);
					}
				}
				if(snappedPageHorizontalScrollPosition < this._minHorizontalScrollPosition)
				{
					snappedPageHorizontalScrollPosition = this._minHorizontalScrollPosition;
				}
				else if(snappedPageHorizontalScrollPosition > this._maxHorizontalScrollPosition)
				{
					snappedPageHorizontalScrollPosition = this._maxHorizontalScrollPosition;
				}
				if(snappedPageHorizontalScrollPosition == this._maxHorizontalScrollPosition)
				{
					var targetHorizontalPageIndex:int = this._maxHorizontalPageIndex;
				}
				else
				{
					//we need to use Math.round() on these values to avoid
					//floating-point errors that could result in the values
					//being rounded down too far.
					if(this._minHorizontalScrollPosition == Number.NEGATIVE_INFINITY)
					{
						targetHorizontalPageIndex = Math.round(snappedPageHorizontalScrollPosition / this.actualPageWidth);
					}
					else
					{
						targetHorizontalPageIndex = Math.round((snappedPageHorizontalScrollPosition - this._minHorizontalScrollPosition) / this.actualPageWidth);
					}
				}
				this.throwToPage(targetHorizontalPageIndex, -1, this._pageThrowDuration);
				return;
			}

			var absPixelsPerMS:Number = Math.abs(pixelsPerMS);
			if(!this._snapToPages && absPixelsPerMS <= MINIMUM_VELOCITY)
			{
				this.finishScrollingHorizontally();
				return;
			}

			var duration:Number = this._fixedThrowDuration;
			if(!this._useFixedThrowDuration)
			{
				duration = this.calculateDynamicThrowDuration(pixelsPerMS);
			}
			this.throwTo(this._horizontalScrollPosition + this.calculateThrowDistance(pixelsPerMS), NaN, duration);
		}

		/**
		 * @private
		 */
		protected function throwVertically(pixelsPerMS:Number):void
		{
			if(this._snapToPages && !this._snapOnComplete)
			{
				var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
				var inchesPerSecond:Number = 1000 * pixelsPerMS / (DeviceCapabilities.dpi / starling.contentScaleFactor);
				if(inchesPerSecond > this._minimumPageThrowVelocity)
				{
					var snappedPageVerticalScrollPosition:Number = roundDownToNearest(this._verticalScrollPosition, this.actualPageHeight);
				}
				else if(inchesPerSecond < -this._minimumPageThrowVelocity)
				{
					snappedPageVerticalScrollPosition = roundUpToNearest(this._verticalScrollPosition, this.actualPageHeight);
				}
				else
				{
					var lastPageHeight:Number = this._maxVerticalScrollPosition % this.actualPageHeight;
					var startOfLastPage:Number = this._maxVerticalScrollPosition - lastPageHeight;
					if(lastPageHeight < this.actualPageHeight && this._verticalScrollPosition >= startOfLastPage)
					{
						var lastPagePosition:Number = this._verticalScrollPosition - startOfLastPage;
						if(inchesPerSecond > this._minimumPageThrowVelocity)
						{
							snappedPageVerticalScrollPosition = startOfLastPage + roundDownToNearest(lastPagePosition, lastPageHeight);
						}
						else if(inchesPerSecond < -this._minimumPageThrowVelocity)
						{
							snappedPageVerticalScrollPosition = startOfLastPage + roundUpToNearest(lastPagePosition, lastPageHeight);
						}
						else
						{
							snappedPageVerticalScrollPosition = startOfLastPage + roundToNearest(lastPagePosition, lastPageHeight);
						}
					}
					else
					{
						snappedPageVerticalScrollPosition = roundToNearest(this._verticalScrollPosition, this.actualPageHeight);
					}
				}
				if(snappedPageVerticalScrollPosition < this._minVerticalScrollPosition)
				{
					snappedPageVerticalScrollPosition = this._minVerticalScrollPosition;
				}
				else if(snappedPageVerticalScrollPosition > this._maxVerticalScrollPosition)
				{
					snappedPageVerticalScrollPosition = this._maxVerticalScrollPosition;
				}
				if(snappedPageVerticalScrollPosition == this._maxVerticalScrollPosition)
				{
					var targetVerticalPageIndex:int = this._maxVerticalPageIndex;
				}
				else
				{
					//we need to use Math.round() on these values to avoid
					//floating-point errors that could result in the values
					//being rounded down too far.
					if(this._minVerticalScrollPosition == Number.NEGATIVE_INFINITY)
					{
						targetVerticalPageIndex = Math.round(snappedPageVerticalScrollPosition / this.actualPageHeight);
					}
					else
					{
						targetVerticalPageIndex = Math.round((snappedPageVerticalScrollPosition - this._minVerticalScrollPosition) / this.actualPageHeight);
					}
				}
				this.throwToPage(-1, targetVerticalPageIndex, this._pageThrowDuration);
				return;
			}

			var absPixelsPerMS:Number = Math.abs(pixelsPerMS);
			if(!this._snapToPages && absPixelsPerMS <= MINIMUM_VELOCITY)
			{
				this.finishScrollingVertically();
				return;
			}

			var duration:Number = this._fixedThrowDuration;
			if(!this._useFixedThrowDuration)
			{
				duration = this.calculateDynamicThrowDuration(pixelsPerMS);
			}
			this.throwTo(NaN, this._verticalScrollPosition + this.calculateThrowDistance(pixelsPerMS), duration);
		}

		/**
		 * @private
		 */
		protected function horizontalAutoScrollTween_onUpdateWithEndRatio():void
		{
			var ratio:Number = this._horizontalAutoScrollTween.transitionFunc(this._horizontalAutoScrollTween.currentTime / this._horizontalAutoScrollTween.totalTime);
			if(ratio >= this._horizontalAutoScrollTweenEndRatio &&
				this._horizontalAutoScrollTween.currentTime < this._horizontalAutoScrollTween.totalTime)
			{
				//check that the currentTime is less than totalTime because if
				//the tween is complete, we don't want it set to null before
				//the onComplete callback
				if(!this._hasElasticEdges)
				{
					if(this._horizontalScrollPosition < this._minHorizontalScrollPosition)
					{
						this._horizontalScrollPosition = this._minHorizontalScrollPosition;
					}
					else if(this._horizontalScrollPosition > this._maxHorizontalScrollPosition)
					{
						this._horizontalScrollPosition = this._maxHorizontalScrollPosition;
					}
				}
				Starling.juggler.remove(this._horizontalAutoScrollTween);
				this._horizontalAutoScrollTween = null;
				this.finishScrollingHorizontally();
				return;
			}
			if(this._snapScrollPositionsToPixels)
			{
				this.horizontalAutoScrollTween_onUpdate();
			}
		}

		/**
		 * @private
		 */
		protected function verticalAutoScrollTween_onUpdateWithEndRatio():void
		{
			var ratio:Number = this._verticalAutoScrollTween.transitionFunc(this._verticalAutoScrollTween.currentTime / this._verticalAutoScrollTween.totalTime);
			if(ratio >= this._verticalAutoScrollTweenEndRatio &&
				this._verticalAutoScrollTween.currentTime < this._verticalAutoScrollTween.totalTime)
			{
				//check that the currentTime is less than totalTime because if
				//the tween is complete, we don't want it set to null before
				//the onComplete callback
				if(!this._hasElasticEdges)
				{
					if(this._verticalScrollPosition < this._minVerticalScrollPosition)
					{
						this._verticalScrollPosition = this._minVerticalScrollPosition;
					}
					else if(this._verticalScrollPosition > this._maxVerticalScrollPosition)
					{
						this._verticalScrollPosition = this._maxVerticalScrollPosition;
					}
				}
				Starling.juggler.remove(this._verticalAutoScrollTween);
				this._verticalAutoScrollTween = null;
				this.finishScrollingVertically();
				return;
			}
			if(this._snapScrollPositionsToPixels)
			{
				this.verticalAutoScrollTween_onUpdate();
			}
		}

		/**
		 * @private
		 */
		protected function refreshHorizontalAutoScrollTweenEndRatio():void
		{
			var adjustedMinVerticalScrollPosition:Number = this._minHorizontalScrollPosition;
			if(this._isLeftPullViewActive && this._hasElasticEdges)
			{
				adjustedMinVerticalScrollPosition -= this._leftPullView.width;
			}
			var adjustedMaxScrollPosition:Number = this._maxHorizontalScrollPosition;
			if(this._isRightPullViewActive && this._hasElasticEdges)
			{
				adjustedMaxScrollPosition += this._rightPullView.width;
			}
			var distance:Number = Math.abs(this._targetHorizontalScrollPosition - this._startHorizontalScrollPosition);
			var ratioOutOfBounds:Number = 0;
			if(this._targetHorizontalScrollPosition > adjustedMaxScrollPosition)
			{
				ratioOutOfBounds = (this._targetHorizontalScrollPosition - adjustedMaxScrollPosition) / distance;
			}
			else if(this._targetHorizontalScrollPosition < adjustedMinVerticalScrollPosition)
			{
				ratioOutOfBounds = (adjustedMinVerticalScrollPosition - this._targetHorizontalScrollPosition) / distance;
			}
			if(ratioOutOfBounds > 0)
			{
				if(this._hasElasticEdges)
				{
					this._horizontalAutoScrollTweenEndRatio = (1 - ratioOutOfBounds) + (ratioOutOfBounds * this._throwElasticity);
				}
				else
				{
					this._horizontalAutoScrollTweenEndRatio = 1 - ratioOutOfBounds;
				}
			}
			else
			{
				this._horizontalAutoScrollTweenEndRatio = 1;
			}
			if(this._horizontalAutoScrollTween)
			{
				if(this._horizontalAutoScrollTweenEndRatio < 1)
				{
					this._horizontalAutoScrollTween.onUpdate = this.horizontalAutoScrollTween_onUpdateWithEndRatio;
				}
				else if(this._snapScrollPositionsToPixels)
				{
					this._horizontalAutoScrollTween.onUpdate = this.horizontalAutoScrollTween_onUpdate;
				}
			}
		}

		/**
		 * @private
		 */
		protected function refreshVerticalAutoScrollTweenEndRatio():void
		{
			var adjustedMinVerticalScrollPosition:Number = this._minVerticalScrollPosition;
			if(this._isTopPullViewActive && this._hasElasticEdges)
			{
				adjustedMinVerticalScrollPosition -= this._topPullView.height;
			}
			var adjustedMaxScrollPosition:Number = this._maxVerticalScrollPosition;
			if(this._isBottomPullViewActive && this._hasElasticEdges)
			{
				adjustedMaxScrollPosition += this._bottomPullView.height;
			}
			var distance:Number = Math.abs(this._targetVerticalScrollPosition - this._startVerticalScrollPosition);
			var ratioOutOfBounds:Number = 0;
			if(this._targetVerticalScrollPosition > adjustedMaxScrollPosition)
			{
				ratioOutOfBounds = (this._targetVerticalScrollPosition - adjustedMaxScrollPosition) / distance;
			}
			else if(this._targetVerticalScrollPosition < adjustedMinVerticalScrollPosition)
			{
				ratioOutOfBounds = (adjustedMinVerticalScrollPosition - this._targetVerticalScrollPosition) / distance;
			}
			if(ratioOutOfBounds > 0)
			{
				if(this._hasElasticEdges)
				{
					this._verticalAutoScrollTweenEndRatio = (1 - ratioOutOfBounds) + (ratioOutOfBounds * this._throwElasticity);
				}
				else
				{
					this._verticalAutoScrollTweenEndRatio = 1 - ratioOutOfBounds;
				}
			}
			else
			{
				this._verticalAutoScrollTweenEndRatio = 1;
			}
			if(this._verticalAutoScrollTween)
			{
				if(this._verticalAutoScrollTweenEndRatio < 1)
				{
					this._verticalAutoScrollTween.onUpdate = this.verticalAutoScrollTween_onUpdateWithEndRatio;
				}
				else if(this._snapScrollPositionsToPixels)
				{
					this._verticalAutoScrollTween.onUpdate = this.verticalAutoScrollTween_onUpdate;
				}
			}
		}

		/**
		 * @private
		 */
		protected function hideHorizontalScrollBar(delay:Number = 0):void
		{
			if(!this.horizontalScrollBar || this._scrollBarDisplayMode != ScrollBarDisplayMode.FLOAT || this._horizontalScrollBarHideTween)
			{
				return;
			}
			if(this.horizontalScrollBar.alpha == 0)
			{
				return;
			}
			if(this._hideScrollBarAnimationDuration == 0 && delay == 0)
			{
				this.horizontalScrollBar.alpha = 0;
			}
			else
			{
				this._horizontalScrollBarHideTween = new Tween(this.horizontalScrollBar, this._hideScrollBarAnimationDuration, this._hideScrollBarAnimationEase);
				this._horizontalScrollBarHideTween.fadeTo(0);
				this._horizontalScrollBarHideTween.delay = delay;
				this._horizontalScrollBarHideTween.onComplete = horizontalScrollBarHideTween_onComplete;
				Starling.juggler.add(this._horizontalScrollBarHideTween);
			}
		}

		/**
		 * @private
		 */
		protected function hideVerticalScrollBar(delay:Number = 0):void
		{
			if(!this.verticalScrollBar || this._scrollBarDisplayMode != ScrollBarDisplayMode.FLOAT || this._verticalScrollBarHideTween)
			{
				return;
			}
			if(this.verticalScrollBar.alpha == 0)
			{
				return;
			}
			if(this._hideScrollBarAnimationDuration == 0 && delay == 0)
			{
				this.verticalScrollBar.alpha = 0;
			}
			else
			{
				this._verticalScrollBarHideTween = new Tween(this.verticalScrollBar, this._hideScrollBarAnimationDuration, this._hideScrollBarAnimationEase);
				this._verticalScrollBarHideTween.fadeTo(0);
				this._verticalScrollBarHideTween.delay = delay;
				this._verticalScrollBarHideTween.onComplete = verticalScrollBarHideTween_onComplete;
				Starling.juggler.add(this._verticalScrollBarHideTween);
			}
		}

		/**
		 * @private
		 */
		protected function revealHorizontalScrollBar():void
		{
			if(!this.horizontalScrollBar || this._scrollBarDisplayMode != ScrollBarDisplayMode.FLOAT)
			{
				return;
			}
			if(this._horizontalScrollBarHideTween)
			{
				Starling.juggler.remove(this._horizontalScrollBarHideTween);
				this._horizontalScrollBarHideTween = null;
			}
			this.horizontalScrollBar.alpha = 1;
		}

		/**
		 * @private
		 */
		protected function revealVerticalScrollBar():void
		{
			if(!this.verticalScrollBar || this._scrollBarDisplayMode != ScrollBarDisplayMode.FLOAT)
			{
				return;
			}
			if(this._verticalScrollBarHideTween)
			{
				Starling.juggler.remove(this._verticalScrollBarHideTween);
				this._verticalScrollBarHideTween = null;
			}
			this.verticalScrollBar.alpha = 1;
		}

		/**
		 * If scrolling hasn't already started, prepares the scroller to scroll
		 * and dispatches <code>FeathersEventType.SCROLL_START</code>.
		 */
		protected function startScroll():void
		{
			if(this._isScrolling)
			{
				return;
			}
			this._isScrolling = true;
			this.dispatchEventWith(FeathersEventType.SCROLL_START);
		}

		/**
		 * Prepares the scroller for normal interaction and dispatches
		 * <code>FeathersEventType.SCROLL_COMPLETE</code>.
		 */
		protected function completeScroll():void
		{
			if(!this._isScrolling || this._verticalAutoScrollTween || this._horizontalAutoScrollTween ||
				this._isDraggingHorizontally || this._isDraggingVertically ||
				this._horizontalScrollBarIsScrolling || this._verticalScrollBarIsScrolling)
			{
				return;
			}
			this._isScrolling = false;
			this.hideHorizontalScrollBar();
			this.hideVerticalScrollBar();
			//we validate to ensure that the final Event.SCROLL
			//dispatched before FeathersEventType.SCROLL_COMPLETE
			this.validate();
			this.dispatchEventWith(FeathersEventType.SCROLL_COMPLETE);
		}

		/**
		 * Scrolls to a pending scroll position, if required.
		 */
		protected function handlePendingScroll():void
		{
			if(this.pendingHorizontalScrollPosition === this.pendingHorizontalScrollPosition ||
				this.pendingVerticalScrollPosition === this.pendingVerticalScrollPosition) //!isNaN
			{
				this.throwTo(this.pendingHorizontalScrollPosition, this.pendingVerticalScrollPosition, this.pendingScrollDuration);
				this.pendingHorizontalScrollPosition = NaN;
				this.pendingVerticalScrollPosition = NaN;
			}
			if(this.hasPendingHorizontalPageIndex && this.hasPendingVerticalPageIndex)
			{
				//both
				this.throwToPage(this.pendingHorizontalPageIndex, this.pendingVerticalPageIndex, this.pendingScrollDuration);
			}
			else if(this.hasPendingHorizontalPageIndex)
			{
				//horizontal only
				this.throwToPage(this.pendingHorizontalPageIndex, this._verticalPageIndex, this.pendingScrollDuration);
			}
			else if(this.hasPendingVerticalPageIndex)
			{
				//vertical only
				this.throwToPage(this._horizontalPageIndex, this.pendingVerticalPageIndex, this.pendingScrollDuration);
			}
			this.hasPendingHorizontalPageIndex = false;
			this.hasPendingVerticalPageIndex = false;
		}

		/**
		 * @private
		 */
		protected function handlePendingRevealScrollBars():void
		{
			if(!this.isScrollBarRevealPending)
			{
				return;
			}
			this.isScrollBarRevealPending = false;
			if(this._scrollBarDisplayMode != ScrollBarDisplayMode.FLOAT)
			{
				return;
			}
			this.revealHorizontalScrollBar();
			this.revealVerticalScrollBar();
			this.hideHorizontalScrollBar(this._revealScrollBarsDuration);
			this.hideVerticalScrollBar(this._revealScrollBarsDuration);
		}

		/**
		 * @private
		 */
		protected function handlePendingPullView():void
		{
			if(this._isTopPullViewPending)
			{
				this._isTopPullViewPending = false;
				if(this._isTopPullViewActive)
				{
					if(this._topPullTween !== null)
					{
						this._topPullTween.dispatchEventWith(Event.REMOVE_FROM_JUGGLER);
						this._topPullTween = null;
					}
					if(this._topPullView is IValidating)
					{
						IValidating(this._topPullView).validate();
					}
					this._topPullView.visible = true;
					this._topPullViewRatio = 1;
					if(this._topPullViewDisplayMode === PullViewDisplayMode.DRAG)
					{
						var targetY:Number = this._topViewPortOffset +
							this._topPullView.pivotY * this._topPullView.scaleY;
						if(this.isCreated)
						{
							this._topPullView.y = targetY - this._topPullView.height;
							this._topPullTween = new Tween(this._topPullView, this._elasticSnapDuration, this._throwEase);
							this._topPullTween.animate("y", targetY);
							this._topPullTween.onUpdate = this.refreshTopPullViewMask;
							this._topPullTween.onComplete = this.topPullTween_onComplete;
							Starling.juggler.add(this._topPullTween);
						}
						else
						{
							//if this is the first time the component validates,
							//we don't need animation
							this._topPullView.y = targetY;
						}
					}
				}
				else
				{
					if(this._isScrolling)
					{
						this.restoreVerticalPullViews();
					}
					else
					{
						this.finishScrollingVertically();
					}
				}
			}
			if(this._isRightPullViewPending)
			{
				this._isRightPullViewPending = false;
				if(this._isRightPullViewActive)
				{
					if(this._rightPullTween !== null)
					{
						this._rightPullTween.dispatchEventWith(Event.REMOVE_FROM_JUGGLER);
						this._rightPullTween = null;
					}
					if(this._rightPullView is IValidating)
					{
						IValidating(this._rightPullView).validate();
					}
					this._rightPullView.visible = true;
					this._rightPullViewRatio = 1;
					if(this._rightPullViewDisplayMode === PullViewDisplayMode.DRAG)
					{
						var targetX:Number = this.actualWidth - this._rightViewPortOffset +
							this._rightPullView.pivotX * this._rightPullView.scaleX -
							this._rightPullView.width;
						if(this.isCreated)
						{
							this._rightPullView.x = targetX + this._rightPullView.width;
							this._rightPullTween = new Tween(this._rightPullView, this._elasticSnapDuration, this._throwEase);
							this._rightPullTween.animate("x", targetX);
							this._rightPullTween.onUpdate = this.refreshRightPullViewMask;
							this._rightPullTween.onComplete = this.rightPullTween_onComplete;
							Starling.juggler.add(this._rightPullTween);
						}
						else
						{
							//if this is the first time the component validates,
							//we don't need animation
							this._rightPullView.x = targetX;
						}
					}
				}
				else
				{
					if(this._isScrolling)
					{
						this.restoreHorizontalPullViews();
					}
					else
					{
						this.finishScrollingHorizontally();
					}
				}
			}
			if(this._isBottomPullViewPending)
			{
				this._isBottomPullViewPending = false;
				if(this._isBottomPullViewActive)
				{
					if(this._bottomPullTween !== null)
					{
						this._bottomPullTween.dispatchEventWith(Event.REMOVE_FROM_JUGGLER);
						this._bottomPullTween = null;
					}
					if(this._bottomPullView is IValidating)
					{
						IValidating(this._bottomPullView).validate();
					}
					this._bottomPullView.visible = true;
					this._bottomPullViewRatio = 1;
					if(this._bottomPullViewDisplayMode === PullViewDisplayMode.DRAG)
					{
						targetY = this.actualHeight - this._bottomViewPortOffset +
							this._bottomPullView.pivotY * this._bottomPullView.scaleY -
							this._bottomPullView.height;
						if(this.isCreated)
						{
							this._bottomPullView.y = targetY + this._bottomPullView.height;
							this._bottomPullTween = new Tween(this._bottomPullView, this._elasticSnapDuration, this._throwEase);
							this._bottomPullTween.animate("y", targetY);
							this._bottomPullTween.onUpdate = this.refreshBottomPullViewMask;
							this._bottomPullTween.onComplete = this.bottomPullTween_onComplete;
							Starling.juggler.add(this._bottomPullTween);
						}
						else
						{
							this._bottomPullView.y = targetY;
						}
					}
				}
				else
				{
					if(this._isScrolling)
					{
						this.restoreVerticalPullViews();
					}
					else
					{
						this.finishScrollingVertically();
					}
				}
			}
			if(this._isLeftPullViewPending)
			{
				this._isLeftPullViewPending = false;
				if(this._isLeftPullViewActive)
				{
					if(this._leftPullTween !== null)
					{
						this._leftPullTween.dispatchEventWith(Event.REMOVE_FROM_JUGGLER);
						this._leftPullTween = null;
					}
					if(this._leftPullView is IValidating)
					{
						IValidating(this._leftPullView).validate();
					}
					this._leftPullView.visible = true;
					this._leftPullViewRatio = 1;
					if(this._leftPullViewDisplayMode === PullViewDisplayMode.DRAG)
					{
						targetX = this._leftViewPortOffset +
							this._leftPullView.pivotX * this._leftPullView.scaleX;
						if(this.isCreated)
						{
							this._leftPullView.x = targetX - this._leftPullView.width;
							this._leftPullTween = new Tween(this._leftPullView, this._elasticSnapDuration, this._throwEase);
							this._leftPullTween.animate("x", targetX);
							this._leftPullTween.onUpdate = this.refreshLeftPullViewMask;
							this._leftPullTween.onComplete = this.leftPullTween_onComplete;
							Starling.juggler.add(this._leftPullTween);
						}
						else
						{
							//if this is the first time the component validates,
							//we don't need animation
							this._leftPullView.x = targetX;
						}
					}
				}
				else
				{
					if(this._isScrolling)
					{
						this.restoreHorizontalPullViews();
					}
					else
					{
						this.finishScrollingHorizontally();
					}
				}
			}
		}

		/**
		 * @private
		 */
		protected function checkForDrag():void
		{
			if(this._isScrollingStopped)
			{
				return;
			}
			var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
			var horizontalInchesMoved:Number = (this._currentTouchX - this._startTouchX) / (DeviceCapabilities.dpi / starling.contentScaleFactor);
			var verticalInchesMoved:Number = (this._currentTouchY - this._startTouchY) / (DeviceCapabilities.dpi / starling.contentScaleFactor);
			if(!this._isDraggingHorizontally &&
				(
					this._horizontalScrollPolicy === ScrollPolicy.ON ||
					(this._horizontalScrollPolicy === ScrollPolicy.AUTO && this._minHorizontalScrollPosition != this._maxHorizontalScrollPosition) ||
					(this._leftPullView !== null && (this._currentTouchX > this._startTouchX || this._horizontalScrollPosition < this._minHorizontalScrollPosition)) ||
					(this._rightPullView !== null && (this._currentTouchX < this._startTouchX || this._horizontalScrollPosition > this._minHorizontalScrollPosition))
				) &&
				(
					((horizontalInchesMoved <= -this._minimumDragDistance) && (this._hasElasticEdges || this._horizontalScrollPosition < this._maxHorizontalScrollPosition || this._rightPullView !== null)) ||
					((horizontalInchesMoved >= this._minimumDragDistance) && (this._hasElasticEdges || this._horizontalScrollPosition > this._minHorizontalScrollPosition || this._leftPullView !== null))
				))
			{
				if(this.horizontalScrollBar)
				{
					this.revealHorizontalScrollBar();
				}
				this._startTouchX = this._currentTouchX;
				this._startHorizontalScrollPosition = this._horizontalScrollPosition;
				this._isDraggingHorizontally = true;
				//if we haven't already started dragging in the other direction,
				//we need to dispatch the event that says we're starting.
				if(!this._isDraggingVertically)
				{
					this.dispatchEventWith(FeathersEventType.BEGIN_INTERACTION);
					var exclusiveTouch:ExclusiveTouch = ExclusiveTouch.forStage(this.stage);
					exclusiveTouch.removeEventListener(Event.CHANGE, exclusiveTouch_changeHandler);
					exclusiveTouch.claimTouch(this._touchPointID, this);
					this.startScroll();
				}
			}
			if(!this._isDraggingVertically &&
				(
					this._verticalScrollPolicy == ScrollPolicy.ON ||
					(this._verticalScrollPolicy == ScrollPolicy.AUTO && this._minVerticalScrollPosition != this._maxVerticalScrollPosition) ||
					(this._topPullView !== null && (this._currentTouchY > this._startTouchY || this._verticalScrollPosition < this._minVerticalScrollPosition)) ||
					(this._bottomPullView !== null && (this._currentTouchY < this._startTouchY || this._verticalScrollPosition > this._minVerticalScrollPosition))
				) &&
				(
					((verticalInchesMoved <= -this._minimumDragDistance) && (this._hasElasticEdges || this._verticalScrollPosition < this._maxVerticalScrollPosition || this._bottomPullView !== null)) ||
					((verticalInchesMoved >= this._minimumDragDistance) && (this._hasElasticEdges || this._verticalScrollPosition > this._minVerticalScrollPosition || this._topPullView !== null))
				))
			{
				if(this.verticalScrollBar)
				{
					this.revealVerticalScrollBar();
				}
				this._startTouchY = this._currentTouchY;
				this._startVerticalScrollPosition = this._verticalScrollPosition;
				this._isDraggingVertically = true;
				if(!this._isDraggingHorizontally)
				{
					exclusiveTouch = ExclusiveTouch.forStage(this.stage);
					exclusiveTouch.removeEventListener(Event.CHANGE, exclusiveTouch_changeHandler);
					exclusiveTouch.claimTouch(this._touchPointID, this);
					this.dispatchEventWith(FeathersEventType.BEGIN_INTERACTION);
					this.startScroll();
				}
			}
			if(this._isDraggingHorizontally && !this._horizontalAutoScrollTween)
			{
				this.updateHorizontalScrollFromTouchPosition(this._currentTouchX);
			}
			if(this._isDraggingVertically && !this._verticalAutoScrollTween)
			{
				this.updateVerticalScrollFromTouchPosition(this._currentTouchY);
			}
		}

		/**
		 * @private
		 */
		protected function saveVelocity():void
		{
			this._pendingVelocityChange = false;
			if(this._isScrollingStopped)
			{
				return;
			}
			var now:int = getTimer();
			var timeOffset:int = now - this._previousTouchTime;
			if(timeOffset > 0)
			{
				//we're keeping previous velocity updates to improve accuracy
				this._previousVelocityX[this._previousVelocityX.length] = this._velocityX;
				if(this._previousVelocityX.length > MAXIMUM_SAVED_VELOCITY_COUNT)
				{
					this._previousVelocityX.shift();
				}
				this._previousVelocityY[this._previousVelocityY.length] = this._velocityY;
				if(this._previousVelocityY.length > MAXIMUM_SAVED_VELOCITY_COUNT)
				{
					this._previousVelocityY.shift();
				}
				this._velocityX = (this._currentTouchX - this._previousTouchX) / timeOffset;
				this._velocityY = (this._currentTouchY - this._previousTouchY) / timeOffset;
				this._previousTouchTime = now;
				this._previousTouchX = this._currentTouchX;
				this._previousTouchY = this._currentTouchY;
			}
		}

		/**
		 * @private
		 */
		protected function viewPort_resizeHandler(event:Event):void
		{
			if(this.ignoreViewPortResizing ||
				(this._viewPort.width == this._lastViewPortWidth && this._viewPort.height == this._lastViewPortHeight))
			{
				return;
			}
			this._lastViewPortWidth = this._viewPort.width;
			this._lastViewPortHeight = this._viewPort.height;
			if(this._isValidating)
			{
				this._hasViewPortBoundsChanged = true;
			}
			else
			{
				this.invalidate(INVALIDATION_FLAG_SIZE);
			}
		}

		/**
		 * @private
		 */
		protected function childProperties_onChange(proxy:PropertyProxy, name:String):void
		{
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected function verticalScrollBar_changeHandler(event:Event):void
		{
			this.verticalScrollPosition = this.verticalScrollBar.value;
		}

		/**
		 * @private
		 */
		protected function horizontalScrollBar_changeHandler(event:Event):void
		{
			this.horizontalScrollPosition = this.horizontalScrollBar.value;
		}

		/**
		 * @private
		 */
		protected function horizontalScrollBar_beginInteractionHandler(event:Event):void
		{
			if(this._horizontalAutoScrollTween)
			{
				Starling.juggler.remove(this._horizontalAutoScrollTween);
				this._horizontalAutoScrollTween = null;
			}
			this._isDraggingHorizontally = false;
			this._horizontalScrollBarIsScrolling = true;
			this.dispatchEventWith(FeathersEventType.BEGIN_INTERACTION);
			if(!this._isScrolling)
			{
				this.startScroll();
			}
		}

		/**
		 * @private
		 */
		protected function horizontalScrollBar_endInteractionHandler(event:Event):void
		{
			this._horizontalScrollBarIsScrolling = false;
			this.dispatchEventWith(FeathersEventType.END_INTERACTION);
			this.completeScroll();
		}

		/**
		 * @private
		 */
		protected function verticalScrollBar_beginInteractionHandler(event:Event):void
		{
			if(this._verticalAutoScrollTween)
			{
				Starling.juggler.remove(this._verticalAutoScrollTween);
				this._verticalAutoScrollTween = null;
			}
			this._isDraggingVertically = false;
			this._verticalScrollBarIsScrolling = true;
			this.dispatchEventWith(FeathersEventType.BEGIN_INTERACTION);
			if(!this._isScrolling)
			{
				this.startScroll();
			}
		}

		/**
		 * @private
		 */
		protected function verticalScrollBar_endInteractionHandler(event:Event):void
		{
			this._verticalScrollBarIsScrolling = false;
			this.dispatchEventWith(FeathersEventType.END_INTERACTION);
			this.completeScroll();
		}

		/**
		 * @private
		 */
		protected function horizontalAutoScrollTween_onUpdate():void
		{
			var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
			var pixelSize:Number = 1 / starling.contentScaleFactor;
			var viewPortX:Number = Math.round((this._leftViewPortOffset - this._horizontalScrollPosition) / pixelSize) * pixelSize;
			var targetViewPortX:Number = Math.round((this._leftViewPortOffset - this._targetHorizontalScrollPosition) / pixelSize) * pixelSize;
			if(viewPortX == targetViewPortX)
			{
				//we've reached the snapped position, but the tween may not
				//have ended yet. since the user won't see any further changes,
				//force the tween to the end.
				this._horizontalAutoScrollTween.advanceTime(this._horizontalAutoScrollTween.totalTime);
			}
		}

		/**
		 * @private
		 */
		protected function horizontalAutoScrollTween_onComplete():void
		{
			//because the onUpdate callback may call advanceTime(), remove
			//the callbacks to be sure that they aren't called too many times.
			if(this._horizontalAutoScrollTween !== null)
			{
				this._horizontalAutoScrollTween.onUpdate = null;
				this._horizontalAutoScrollTween.onComplete = null;
				this._horizontalAutoScrollTween = null;
			}
			//the page index will not have updated during the animation, so we
			//need to ensure that it is updated now.
			this.invalidate(INVALIDATION_FLAG_SCROLL);
			this.finishScrollingHorizontally();
		}

		/**
		 * @private
		 */
		protected function verticalAutoScrollTween_onUpdate():void
		{
			var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
			var pixelSize:Number = 1 / starling.contentScaleFactor;
			var viewPortY:Number = Math.round((this._topViewPortOffset - this._verticalScrollPosition) / pixelSize) * pixelSize;
			var targetViewPortY:Number = Math.round((this._topViewPortOffset - this._targetVerticalScrollPosition) / pixelSize) * pixelSize;
			if(viewPortY == targetViewPortY)
			{
				//we've reached the snapped position, but the tween may not
				//have ended yet. since the user won't see any further changes,
				//force the tween to the end.
				this._verticalAutoScrollTween.advanceTime(this._verticalAutoScrollTween.totalTime);
			}
		}

		/**
		 * @private
		 */
		protected function verticalAutoScrollTween_onComplete():void
		{
			//because the onUpdate callback may call advanceTime(), remove
			//the callbacks to be sure that they aren't called too many times.
			if(this._verticalAutoScrollTween !== null)
			{
				this._verticalAutoScrollTween.onUpdate = null;
				this._verticalAutoScrollTween.onComplete = null;
				this._verticalAutoScrollTween = null;
			}
			//the page index will not have updated during the animation, so we
			//need to ensure that it is updated now.
			this.invalidate(INVALIDATION_FLAG_SCROLL);
			this.finishScrollingVertically();
		}

		/**
		 * @private
		 */
		protected function topPullTween_onComplete():void
		{
			this._topPullTween = null;
			if(this._isTopPullViewActive)
			{
				this._topPullViewRatio = 1;
			}
			else
			{
				this._topPullViewRatio = 0;
			}
			this.invalidate(INVALIDATION_FLAG_SCROLL);
		}

		/**
		 * @private
		 */
		protected function rightPullTween_onComplete():void
		{
			this._rightPullTween = null;
			if(this._isRightPullViewActive)
			{
				this._rightPullViewRatio = 1;
			}
			else
			{
				this._rightPullViewRatio = 0;
			}
			this.invalidate(INVALIDATION_FLAG_SCROLL);
		}

		/**
		 * @private
		 */
		protected function bottomPullTween_onComplete():void
		{
			this._bottomPullTween = null;
			if(this._isBottomPullViewActive)
			{
				this._bottomPullViewRatio = 1;
			}
			else
			{
				this._bottomPullViewRatio = 0;
			}
			this.invalidate(INVALIDATION_FLAG_SCROLL);
		}

		/**
		 * @private
		 */
		protected function leftPullTween_onComplete():void
		{
			this._leftPullTween = null;
			if(this._isLeftPullViewActive)
			{
				this._leftPullViewRatio = 1;
			}
			else
			{
				this._leftPullViewRatio = 0;
			}
			this.invalidate(INVALIDATION_FLAG_SCROLL);
		}

		/**
		 * @private
		 */
		protected function horizontalScrollBarHideTween_onComplete():void
		{
			this._horizontalScrollBarHideTween = null;
		}

		/**
		 * @private
		 */
		protected function verticalScrollBarHideTween_onComplete():void
		{
			this._verticalScrollBarHideTween = null;
		}

		/**
		 * @private
		 */
		protected function scroller_touchHandler(event:TouchEvent):void
		{
			//it's rare, but the stage could be null if the scroller is removed
			//in a listener for the same event.
			if(!this._isEnabled || this.stage === null)
			{
				this._touchPointID = -1;
				return;
			}
			if(this._touchPointID != -1)
			{
				return;
			}

			//any began touch is okay here. we don't need to check all touches.
			var touch:Touch = event.getTouch(this, TouchPhase.BEGAN);
			if(touch === null)
			{
				return;
			}

			if(this._interactionMode == ScrollInteractionMode.TOUCH_AND_SCROLL_BARS &&
				(event.interactsWith(DisplayObject(this.horizontalScrollBar)) || event.interactsWith(DisplayObject(this.verticalScrollBar))))
			{
				return;
			}

			var touchPosition:Point = touch.getLocation(this, Pool.getPoint());
			var touchX:Number = touchPosition.x;
			var touchY:Number = touchPosition.y;
			Pool.putPoint(touchPosition);
			if(touchX < this._leftViewPortOffset || touchY < this._topViewPortOffset ||
				touchX >= (this.actualWidth - this._rightViewPortOffset) ||
				touchY >= (this.actualHeight - this._bottomViewPortOffset))
			{
				return;
			}

			var exclusiveTouch:ExclusiveTouch = ExclusiveTouch.forStage(this.stage);
			if(exclusiveTouch.getClaim(touch.id))
			{
				//already claimed
				return;
			}

			//if the scroll policy is off, we shouldn't stop this animation
			if(this._horizontalAutoScrollTween !== null && this._horizontalScrollPolicy !== ScrollPolicy.OFF)
			{
				Starling.juggler.remove(this._horizontalAutoScrollTween);
				this._horizontalAutoScrollTween = null;
			}
			if(this._verticalAutoScrollTween !== null && this._verticalScrollPolicy !== ScrollPolicy.OFF)
			{
				Starling.juggler.remove(this._verticalAutoScrollTween);
				this._verticalAutoScrollTween = null;
			}

			this._touchPointID = touch.id;
			this._velocityX = 0;
			this._velocityY = 0;
			this._previousVelocityX.length = 0;
			this._previousVelocityY.length = 0;
			this._previousTouchTime = getTimer();
			this._previousTouchX = this._startTouchX = this._currentTouchX = touchX;
			this._previousTouchY = this._startTouchY = this._currentTouchY = touchY;
			this._startHorizontalScrollPosition = this._horizontalScrollPosition;
			this._startVerticalScrollPosition = this._verticalScrollPosition;
			this._isScrollingStopped = false;
			this._isDraggingVertically = false;
			this._isDraggingHorizontally = false;
			if(this._isScrolling)
			{
				//if it was scrolling, stop it immediately
				this.completeScroll();
			}

			this.addEventListener(Event.ENTER_FRAME, scroller_enterFrameHandler);

			//we need to listen on the stage because if we scroll the bottom or
			//right edge past the top of the scroller, it gets stuck and we stop
			//receiving touch events for "this".
			this.stage.addEventListener(TouchEvent.TOUCH, stage_touchHandler);

			exclusiveTouch.addEventListener(Event.CHANGE, exclusiveTouch_changeHandler);
		}

		/**
		 * @private
		 */
		protected function scroller_enterFrameHandler(event:Event):void
		{
			this.saveVelocity();
		}

		/**
		 * @private
		 */
		protected function stage_touchHandler(event:TouchEvent):void
		{
			if(this._touchPointID < 0)
			{
				//if the touch is claimed with ExclusiveTouch by a child, the
				//listener is removed, but the current event will keep bubbling
				return;
			}
			var touch:Touch = event.getTouch(this.stage, null, this._touchPointID);
			if(touch === null)
			{
				return;
			}

			if(touch.phase === TouchPhase.MOVED)
			{
				var touchPosition:Point = touch.getLocation(this, Pool.getPoint());
				this._currentTouchX = touchPosition.x;
				this._currentTouchY = touchPosition.y;
				Pool.putPoint(touchPosition);
				this.checkForDrag();
				//we don't call saveVelocity() on TouchPhase.MOVED because the
				//time interval may be very short, which could lead to
				//inaccurate results. instead, we wait for the next frame.
				this._pendingVelocityChange = true;
			}
			else if(touch.phase === TouchPhase.ENDED)
			{
				if(this._pendingVelocityChange)
				{
					//we may need to do this one last time because the enter
					//frame listener may not have been called since the last
					//TouchPhase.MOVED
					this.saveVelocity();
				}
				if(!this._isDraggingHorizontally && !this._isDraggingVertically)
				{
					ExclusiveTouch.forStage(this.stage).removeEventListener(Event.CHANGE, exclusiveTouch_changeHandler);
				}
				this.removeEventListener(Event.ENTER_FRAME, scroller_enterFrameHandler);
				this.stage.removeEventListener(TouchEvent.TOUCH, stage_touchHandler);
				this._touchPointID = -1;
				this.dispatchEventWith(FeathersEventType.END_INTERACTION);

				if(!this._isTopPullViewActive && this._isDraggingVertically &&
					this._topPullView !== null &&
					this._topPullViewRatio >= 1)
				{
					this._isTopPullViewActive = true;
					this._topPullView.dispatchEventWith(Event.UPDATE);
					this.dispatchEventWith(Event.UPDATE, false, this._topPullView);
				}
				if(!this._isRightPullViewActive && this._isDraggingHorizontally &&
					this._rightPullView !== null &&
					this._rightPullViewRatio >= 1)
				{
					this._isRightPullViewActive = true;
					this._rightPullView.dispatchEventWith(Event.UPDATE);
					this.dispatchEventWith(Event.UPDATE, false, this._rightPullView);
				}
				if(!this._isBottomPullViewActive && this._isDraggingVertically &&
					this._bottomPullView !== null &&
					this._bottomPullViewRatio >= 1)
				{
					this._isBottomPullViewActive = true;
					this._bottomPullView.dispatchEventWith(Event.UPDATE);
					this.dispatchEventWith(Event.UPDATE, false, this._bottomPullView);
				}
				if(!this._isLeftPullViewActive && this._isDraggingHorizontally && 
					this._leftPullView !== null &&
					this._leftPullViewRatio >= 1)
				{
					this._isLeftPullViewActive = true;
					this._leftPullView.dispatchEventWith(Event.UPDATE);
					this.dispatchEventWith(Event.UPDATE, false, this._leftPullView);
				}

				var isFinishingHorizontally:Boolean = false;
				var adjustedMinHorizontalScrollPosition:Number = this._minHorizontalScrollPosition;
				if(this._isLeftPullViewActive && this._hasElasticEdges)
				{
					adjustedMinHorizontalScrollPosition -= this._leftPullView.width;
				}
				var adjustedMaxHorizontalScrollPosition:Number = this._maxHorizontalScrollPosition;
				if(this._isRightPullViewActive && this._hasElasticEdges)
				{
					adjustedMaxHorizontalScrollPosition += this._rightPullView.width;
				}
				if(this._horizontalScrollPosition < adjustedMinHorizontalScrollPosition ||
					this._horizontalScrollPosition > adjustedMaxHorizontalScrollPosition)
				{
					isFinishingHorizontally = true;
					this.finishScrollingHorizontally();
				}
				var isFinishingVertically:Boolean = false;
				var adjustedMinVerticalScrollPosition:Number = this._minVerticalScrollPosition;
				if(this._isTopPullViewActive && this._hasElasticEdges)
				{
					adjustedMinVerticalScrollPosition -= this._topPullView.height;
				}
				var adjustedMaxVerticalScrollPosition:Number = this._maxVerticalScrollPosition;
				if(this._isBottomPullViewActive && this._hasElasticEdges)
				{
					adjustedMaxVerticalScrollPosition += this._bottomPullView.height;
				}
				if(this._verticalScrollPosition < adjustedMinVerticalScrollPosition ||
					this._verticalScrollPosition > adjustedMaxVerticalScrollPosition)
				{
					isFinishingVertically = true;
					this.finishScrollingVertically();
				}

				if(isFinishingHorizontally && isFinishingVertically)
				{
					return;
				}

				if(!isFinishingHorizontally)
				{
					if(this._isDraggingHorizontally)
					{
						//take the average for more accuracy
						var sum:Number = this._velocityX * CURRENT_VELOCITY_WEIGHT;
						var velocityCount:int = this._previousVelocityX.length;
						var totalWeight:Number = CURRENT_VELOCITY_WEIGHT;
						for(var i:int = 0; i < velocityCount; i++)
						{
							var weight:Number = VELOCITY_WEIGHTS[i];
							sum += this._previousVelocityX.shift() * weight;
							totalWeight += weight;
						}
						this.throwHorizontally(sum / totalWeight);
					}
					else
					{
						this.hideHorizontalScrollBar();
					}
				}

				if(!isFinishingVertically)
				{
					if(this._isDraggingVertically)
					{
						sum = this._velocityY * CURRENT_VELOCITY_WEIGHT;
						velocityCount = this._previousVelocityY.length;
						totalWeight = CURRENT_VELOCITY_WEIGHT;
						for(i = 0; i < velocityCount; i++)
						{
							weight = VELOCITY_WEIGHTS[i];
							sum += this._previousVelocityY.shift() * weight;
							totalWeight += weight;
						}
						this.throwVertically(sum / totalWeight);
					}
					else
					{
						this.hideVerticalScrollBar();
					}
				}
			}
		}

		/**
		 * @private
		 */
		protected function exclusiveTouch_changeHandler(event:Event, touchID:int):void
		{
			if(this._touchPointID < 0 || this._touchPointID != touchID || this._isDraggingHorizontally || this._isDraggingVertically)
			{
				return;
			}
			var exclusiveTouch:ExclusiveTouch = ExclusiveTouch.forStage(this.stage);
			if(exclusiveTouch.getClaim(touchID) == this)
			{
				return;
			}

			this._touchPointID = -1;
			this.removeEventListener(Event.ENTER_FRAME, scroller_enterFrameHandler);
			this.stage.removeEventListener(TouchEvent.TOUCH, stage_touchHandler);
			exclusiveTouch.removeEventListener(Event.CHANGE, exclusiveTouch_changeHandler);
			this.dispatchEventWith(FeathersEventType.END_INTERACTION);
		}

		/**
		 * @private
		 */
		protected function nativeStage_mouseWheelHandler(event:MouseEvent):void
		{
			if(!this._isEnabled)
			{
				this._touchPointID = -1;
				return;
			}
			if((this._verticalMouseWheelScrollDirection === Direction.VERTICAL && (this._maxVerticalScrollPosition == this._minVerticalScrollPosition || this._verticalScrollPolicy == ScrollPolicy.OFF)) ||
				(this._verticalMouseWheelScrollDirection === Direction.HORIZONTAL && (this._maxHorizontalScrollPosition == this._minHorizontalScrollPosition || this._horizontalScrollPolicy == ScrollPolicy.OFF)))
			{
				return;
			}

			var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
			var nativeScaleFactor:Number = 1;
			if(starling.supportHighResolutions)
			{
				nativeScaleFactor = starling.nativeStage.contentsScaleFactor;
			}
			var starlingViewPort:Rectangle = starling.viewPort;
			var scaleFactor:Number = nativeScaleFactor / starling.contentScaleFactor;
			var point:Point = Pool.getPoint(
				(event.stageX - starlingViewPort.x) * scaleFactor,
				(event.stageY - starlingViewPort.y) * scaleFactor);
			var isContained:Boolean = this.contains(this.stage.hitTest(point));
			if(!isContained)
			{
				Pool.putPoint(point);
			}
			else
			{
				this.globalToLocal(point, point);
				var localMouseX:Number = point.x;
				var localMouseY:Number = point.y;
				Pool.putPoint(point);
				if(localMouseX < this._leftViewPortOffset || localMouseY < this._topViewPortOffset ||
					localMouseX >= this.actualWidth - this._rightViewPortOffset ||
					localMouseY >= this.actualHeight - this._bottomViewPortOffset)
				{
					return;
				}
				var targetHorizontalScrollPosition:Number = this._horizontalScrollPosition;
				var targetVerticalScrollPosition:Number = this._verticalScrollPosition;
				var scrollStep:Number = this._verticalMouseWheelScrollStep;
				if(this._verticalMouseWheelScrollDirection == Direction.HORIZONTAL)
				{
					if(scrollStep !== scrollStep) //isNaN
					{
						scrollStep = this.actualHorizontalScrollStep;
					}
					targetHorizontalScrollPosition -= event.delta * scrollStep;
					if(targetHorizontalScrollPosition < this._minHorizontalScrollPosition)
					{
						targetHorizontalScrollPosition = this._minHorizontalScrollPosition;
					}
					else if(targetHorizontalScrollPosition > this._maxHorizontalScrollPosition)
					{
						targetHorizontalScrollPosition = this._maxHorizontalScrollPosition;
					}
				}
				else //vertical
				{
					if(scrollStep !== scrollStep) //isNaN
					{
						scrollStep = this.actualVerticalScrollStep;
					}
					targetVerticalScrollPosition -= event.delta * scrollStep;
					if(targetVerticalScrollPosition < this._minVerticalScrollPosition)
					{
						targetVerticalScrollPosition = this._minVerticalScrollPosition;
					}
					else if(targetVerticalScrollPosition > this._maxVerticalScrollPosition)
					{
						targetVerticalScrollPosition = this._maxVerticalScrollPosition;
					}
				}
				this.throwTo(targetHorizontalScrollPosition, targetVerticalScrollPosition, this._mouseWheelScrollDuration);
			}
		}

		/**
		 * @private
		 */
		protected function nativeStage_orientationChangeHandler(event:flash.events.Event):void
		{
			if(this._touchPointID < 0)
			{
				return;
			}
			this._startTouchX = this._previousTouchX = this._currentTouchX;
			this._startTouchY = this._previousTouchY = this._currentTouchY;
			this._startHorizontalScrollPosition = this._horizontalScrollPosition;
			this._startVerticalScrollPosition = this._verticalScrollPosition;
		}

		/**
		 * @private
		 */
		protected function horizontalScrollBar_touchHandler(event:TouchEvent):void
		{
			if(!this._isEnabled)
			{
				this._horizontalScrollBarTouchPointID = -1;
				return;
			}

			var displayHorizontalScrollBar:DisplayObject = DisplayObject(event.currentTarget);
			if(this._horizontalScrollBarTouchPointID >= 0)
			{
				var touch:Touch = event.getTouch(displayHorizontalScrollBar, TouchPhase.ENDED, this._horizontalScrollBarTouchPointID);
				if(!touch)
				{
					return;
				}

				this._horizontalScrollBarTouchPointID = -1;
				var touchPosition:Point = touch.getLocation(displayHorizontalScrollBar, Pool.getPoint());
				var isInBounds:Boolean = this.horizontalScrollBar.hitTest(touchPosition) !== null;
				Pool.putPoint(touchPosition);
				if(!isInBounds)
				{
					this.hideHorizontalScrollBar();
				}
			}
			else
			{
				touch = event.getTouch(displayHorizontalScrollBar, TouchPhase.BEGAN);
				if(touch)
				{
					this._horizontalScrollBarTouchPointID = touch.id;
					return;
				}
				if(this._isScrolling)
				{
					return;
				}
				touch = event.getTouch(displayHorizontalScrollBar, TouchPhase.HOVER);
				if(touch)
				{
					this.revealHorizontalScrollBar();
					return;
				}

				//end hover
				this.hideHorizontalScrollBar();
			}
		}

		/**
		 * @private
		 */
		protected function verticalScrollBar_touchHandler(event:TouchEvent):void
		{
			if(!this._isEnabled)
			{
				this._verticalScrollBarTouchPointID = -1;
				return;
			}

			var displayVerticalScrollBar:DisplayObject = DisplayObject(event.currentTarget);
			if(this._verticalScrollBarTouchPointID >= 0)
			{
				var touch:Touch = event.getTouch(displayVerticalScrollBar, TouchPhase.ENDED, this._verticalScrollBarTouchPointID);
				if(!touch)
				{
					return;
				}

				this._verticalScrollBarTouchPointID = -1;
				var touchPosition:Point = touch.getLocation(displayVerticalScrollBar, Pool.getPoint());
				var isInBounds:Boolean = this.verticalScrollBar.hitTest(touchPosition) !== null;
				Pool.putPoint(touchPosition);
				if(!isInBounds)
				{
					this.hideVerticalScrollBar();
				}
			}
			else
			{
				touch = event.getTouch(displayVerticalScrollBar, TouchPhase.BEGAN);
				if(touch)
				{
					this._verticalScrollBarTouchPointID = touch.id;
					return;
				}
				if(this._isScrolling)
				{
					return;
				}
				touch = event.getTouch(displayVerticalScrollBar, TouchPhase.HOVER);
				if(touch)
				{
					this.revealVerticalScrollBar();
					return;
				}

				//end hover
				this.hideVerticalScrollBar();
			}
		}

		/**
		 * @private
		 */
		protected function scroller_addedToStageHandler(event:Event):void
		{
			var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
			starling.nativeStage.addEventListener(MouseEvent.MOUSE_WHEEL, nativeStage_mouseWheelHandler, false, 0, true);
			starling.nativeStage.addEventListener("orientationChange", nativeStage_orientationChangeHandler, false, 0, true);
		}

		/**
		 * @private
		 */
		protected function scroller_removedFromStageHandler(event:Event):void
		{
			var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
			starling.nativeStage.removeEventListener(MouseEvent.MOUSE_WHEEL, nativeStage_mouseWheelHandler);
			starling.nativeStage.removeEventListener("orientationChange", nativeStage_orientationChangeHandler);
			if(this._touchPointID >= 0)
			{
				var exclusiveTouch:ExclusiveTouch = ExclusiveTouch.forStage(this.stage);
				exclusiveTouch.removeEventListener(Event.CHANGE, exclusiveTouch_changeHandler);
			}
			this._touchPointID = -1;
			this._horizontalScrollBarTouchPointID = -1;
			this._verticalScrollBarTouchPointID = -1;
			this._isDraggingHorizontally = false;
			this._isDraggingVertically = false;
			this._velocityX = 0;
			this._velocityY = 0;
			this._previousVelocityX.length = 0;
			this._previousVelocityY.length = 0;
			this._horizontalScrollBarIsScrolling = false;
			this._verticalScrollBarIsScrolling = false;
			this.removeEventListener(Event.ENTER_FRAME, scroller_enterFrameHandler);
			this.stage.removeEventListener(TouchEvent.TOUCH, stage_touchHandler);
			if(this._verticalAutoScrollTween)
			{
				Starling.juggler.remove(this._verticalAutoScrollTween);
				this._verticalAutoScrollTween = null;
			}
			if(this._horizontalAutoScrollTween)
			{
				Starling.juggler.remove(this._horizontalAutoScrollTween);
				this._horizontalAutoScrollTween = null;
			}
			if(this._topPullTween)
			{
				this._topPullTween.dispatchEventWith(Event.REMOVE_FROM_JUGGLER);
				this._topPullTween = null;
			}
			if(this._rightPullTween)
			{
				this._rightPullTween.dispatchEventWith(Event.REMOVE_FROM_JUGGLER);
				this._rightPullTween = null;
			}
			if(this._bottomPullTween)
			{
				this._bottomPullTween.dispatchEventWith(Event.REMOVE_FROM_JUGGLER);
				this._bottomPullTween = null;
			}
			if(this._leftPullTween)
			{
				this._leftPullTween.dispatchEventWith(Event.REMOVE_FROM_JUGGLER);
				this._leftPullTween = null;
			}

			//if we stopped the animation while the list was outside the scroll
			//bounds, then let's account for that
			var oldHorizontalScrollPosition:Number = this._horizontalScrollPosition;
			var oldVerticalScrollPosition:Number = this._verticalScrollPosition;
			if(this._horizontalScrollPosition < this._minHorizontalScrollPosition)
			{
				this._horizontalScrollPosition = this._minHorizontalScrollPosition;
			}
			else if(this._horizontalScrollPosition > this._maxHorizontalScrollPosition)
			{
				this._horizontalScrollPosition = this._maxHorizontalScrollPosition;
			}
			if(this._verticalScrollPosition < this._minVerticalScrollPosition)
			{
				this._verticalScrollPosition = this._minVerticalScrollPosition;
			}
			else if(this._verticalScrollPosition > this._maxVerticalScrollPosition)
			{
				this._verticalScrollPosition = this._maxVerticalScrollPosition;
			}
			if(oldHorizontalScrollPosition != this._horizontalScrollPosition ||
				oldVerticalScrollPosition != this._verticalScrollPosition)
			{
				this.dispatchEventWith(Event.SCROLL);
			}
			this.completeScroll();
		}

		/**
		 * @private
		 */
		override protected function focusInHandler(event:Event):void
		{
			super.focusInHandler(event);
			//using priority here is a hack so that objects deeper in the
			//display list have a chance to cancel the event first.
			var priority:int = -getDisplayObjectDepthFromStage(this);
			this.stage.starling.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, nativeStage_keyDownHandler, false, priority, true);
			this.stage.starling.nativeStage.addEventListener("gestureDirectionalTap", stage_gestureDirectionalTapHandler, false, priority, true);
		}

		/**
		 * @private
		 */
		override protected function focusOutHandler(event:Event):void
		{
			super.focusOutHandler(event);
			this.stage.starling.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN, nativeStage_keyDownHandler);
			this.stage.starling.nativeStage.removeEventListener("gestureDirectionalTap", stage_gestureDirectionalTapHandler);
		}

		/**
		 * @private
		 */
		protected function nativeStage_keyDownHandler(event:KeyboardEvent):void
		{
			if(event.isDefaultPrevented())
			{
				return;
			}
			var newHorizontalScrollPosition:Number = this._horizontalScrollPosition;
			var newVerticalScrollPosition:Number = this._verticalScrollPosition;
			if(event.keyCode == Keyboard.HOME)
			{
				newVerticalScrollPosition = this._minVerticalScrollPosition;
			}
			else if(event.keyCode == Keyboard.END)
			{
				newVerticalScrollPosition = this._maxVerticalScrollPosition;
			}
			else if(event.keyCode == Keyboard.PAGE_UP)
			{
				newVerticalScrollPosition = Math.max(this._minVerticalScrollPosition, this._verticalScrollPosition - this.viewPort.visibleHeight);
			}
			else if(event.keyCode == Keyboard.PAGE_DOWN)
			{
				newVerticalScrollPosition = Math.min(this._maxVerticalScrollPosition, this._verticalScrollPosition + this.viewPort.visibleHeight);
			}
			else if(event.keyCode == Keyboard.UP)
			{
				newVerticalScrollPosition = Math.max(this._minVerticalScrollPosition, this._verticalScrollPosition - this.verticalScrollStep);
			}
			else if(event.keyCode == Keyboard.DOWN)
			{
				newVerticalScrollPosition = Math.min(this._maxVerticalScrollPosition, this._verticalScrollPosition + this.verticalScrollStep);
			}
			else if(event.keyCode == Keyboard.LEFT)
			{
				newHorizontalScrollPosition = Math.max(this._minHorizontalScrollPosition, this._horizontalScrollPosition - this.horizontalScrollStep);
			}
			else if(event.keyCode == Keyboard.RIGHT)
			{
				newHorizontalScrollPosition = Math.min(this._maxHorizontalScrollPosition, this._horizontalScrollPosition + this.horizontalScrollStep);
			}
			if(this._horizontalScrollPosition != newHorizontalScrollPosition)
			{
				event.preventDefault();
				this.horizontalScrollPosition = newHorizontalScrollPosition;
			}
			if(this._verticalScrollPosition != newVerticalScrollPosition)
			{
				event.preventDefault();
				this.verticalScrollPosition = newVerticalScrollPosition;
			}
		}

		/**
		 * @private
		 */
		protected function stage_gestureDirectionalTapHandler(event:TransformGestureEvent):void
		{
			if(event.isDefaultPrevented())
			{
				return;
			}
			var newHorizontalScrollPosition:Number = this._horizontalScrollPosition;
			var newVerticalScrollPosition:Number = this._verticalScrollPosition;
			if(event.offsetY < 0)
			{
				newVerticalScrollPosition = Math.max(this._minVerticalScrollPosition, this._verticalScrollPosition - this.verticalScrollStep);
			}
			else if(event.offsetY > 0)
			{
				newVerticalScrollPosition = Math.min(this._maxVerticalScrollPosition, this._verticalScrollPosition + this.verticalScrollStep);
			}
			else if(event.offsetX < 0)
			{
				newHorizontalScrollPosition = Math.max(this._maxHorizontalScrollPosition, this._horizontalScrollPosition - this.horizontalScrollStep);
			}
			else if(event.offsetX > 0)
			{
				newHorizontalScrollPosition = Math.min(this._maxHorizontalScrollPosition, this._horizontalScrollPosition + this.horizontalScrollStep);
			}
			if(this._horizontalScrollPosition != newHorizontalScrollPosition)
			{
				event.stopImmediatePropagation();
				//event.preventDefault();
				this.horizontalScrollPosition = newHorizontalScrollPosition;
			}
			if(this._verticalScrollPosition != newVerticalScrollPosition)
			{
				event.stopImmediatePropagation();
				//event.preventDefault();
				this.verticalScrollPosition = newVerticalScrollPosition;
			}
		}
	}
}
