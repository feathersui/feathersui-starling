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
	import feathers.core.IMeasureDisplayObject;
	import feathers.core.IValidating;
	import feathers.core.PopUpManager;
	import feathers.events.FeathersEventType;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.RelativePosition;
	import feathers.layout.VerticalAlign;
	import feathers.skins.IStyleProvider;
	import feathers.utils.display.getDisplayObjectDepthFromStage;
	import feathers.utils.skins.resetFluidChildDimensionsForMeasurement;

	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Stage;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.Pool;

	/**
	 * The position of the callout's arrow relative to the callout's
	 * background. If the callout's <code>origin</code> is set, this value
	 * will be managed by the callout and may change automatically if the
	 * origin moves to a new position or if the stage resizes.
	 *
	 * <p>The <code>supportedDirections</code> property is related to this
	 * one, but they have different meanings and are usually opposites. For
	 * example, a callout on the right side of its origin will generally
	 * display its left arrow.</p>
	 *
	 * <p>If you use <code>Callout.show()</code> or set the <code>origin</code>
	 * property manually, you should avoid manually modifying the
	 * <code>arrowPosition</code> and <code>arrowOffset</code> properties.</p>
	 *
	 * <p>In the following example, the callout's arrow is positioned on the
	 * left side:</p>
	 *
	 * <listing version="3.0">
	 * callout.arrowPosition = RelativePosition.LEFT;</listing>
	 *
	 * @default feathers.layout.RelativePosition.TOP
	 *
	 * @see feathers.layout.RelativePosition#TOP
	 * @see feathers.layout.RelativePosition#RIGHT
	 * @see feathers.layout.RelativePosition#BOTTOM
	 * @see feathers.layout.RelativePosition#LEFT
	 *
	 * @see #origin
	 * @see #supportedPositions
	 * @see #style:arrowOffset
	 */
	[Style(name="arrowPosition",type="String")]

	/**
	 * The primary background to display behind the callout's content.
	 *
	 * <p>In the following example, the callout's background is set to an image:</p>
	 *
	 * <listing version="3.0">
	 * callout.backgroundSkin = new Image( texture );</listing>
	 *
	 * @default null
	 */
	[Style(name="backgroundSkin",type="starling.display.DisplayObject")]

	/**
	 * The space, in pixels, between the bottom arrow skin and the
	 * background skin. To have the arrow overlap the background, you may
	 * use a negative gap value.
	 *
	 * <p>In the following example, the gap between the callout and its
	 * bottom arrow is set to -4 pixels (perhaps to hide a border on the
	 * callout's background):</p>
	 *
	 * <listing version="3.0">
	 * callout.bottomArrowGap = -4;</listing>
	 *
	 * @default 0
	 * 
	 * @see #style:bottomArrowSkin
	 */
	[Style(name="bottomArrowGap",type="Number")]

	/**
	 * The arrow skin to display on the bottom edge of the callout. This
	 * arrow is displayed when the callout is displayed above the region it
	 * points at.
	 *
	 * <p>In the following example, the callout's bottom arrow skin is set
	 * to an image:</p>
	 *
	 * <listing version="3.0">
	 * callout.bottomArrowSkin = new Image( texture );</listing>
	 *
	 * @default null
	 * 
	 * @see #style:bottomArrowGap
	 */
	[Style(name="bottomArrowSkin",type="starling.display.DisplayObject")]

	/**
	 * The horizontal alignment of the callout, relative to the origin.
	 *
	 * @default feathers.layout.HorizontalAlign.CENTER
	 *
	 * @see feathers.layout.HorizontalAlign#LEFT
	 * @see feathers.layout.HorizontalAlign#CENTER
	 * @see feathers.layout.HorizontalAlign#RIGHT
	 */
	[Style(name="horizontalAlign",type="String")]

	/**
	 * The space, in pixels, between the right arrow skin and the background
	 * skin. To have the arrow overlap the background, you may use a
	 * negative gap value.
	 *
	 * <p>In the following example, the gap between the callout and its
	 * left arrow is set to -4 pixels (perhaps to hide a border on the
	 * callout's background):</p>
	 *
	 * <listing version="3.0">
	 * callout.leftArrowGap = -4;</listing>
	 *
	 * @default 0
	 * 
	 * @see #style:leftArrowSkin
	 */
	[Style(name="leftArrowGap",type="Number")]

	/**
	 * The arrow skin to display on the left edge of the callout. This arrow
	 * is displayed when the callout is displayed to the right of the region
	 * it points at.
	 *
	 * <p>In the following example, the callout's left arrow skin is set
	 * to an image:</p>
	 *
	 * <listing version="3.0">
	 * callout.leftArrowSkin = new Image( texture );</listing>
	 *
	 * @default null
	 * 
	 * @see #style:leftArrowGap
	 */
	[Style(name="leftArrowSkin",type="starling.display.DisplayObject")]

	/**
	 * Quickly sets all padding properties to the same value. The
	 * <code>padding</code> getter always returns the value of
	 * <code>paddingTop</code>, but the other padding values may be
	 * different.
	 *
	 * <p>In the following example, the padding of all sides of the callout
	 * is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * callout.padding = 20;</listing>
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
	 * The minimum space, in pixels, between the callout's top edge and the
	 * callout's content.
	 *
	 * <p>In the following example, the padding on the top edge of the
	 * callout is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * callout.paddingTop = 20;</listing>
	 *
	 * @default 0
	 * 
	 * @see #style:padding
	 */
	[Style(name="paddingTop",type="Number")]

	/**
	 * The minimum space, in pixels, between the callout's right edge and
	 * the callout's content.
	 *
	 * <p>In the following example, the padding on the right edge of the
	 * callout is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * callout.paddingRight = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:padding
	 */
	[Style(name="paddingRight",type="Number")]

	/**
	 * The minimum space, in pixels, between the callout's bottom edge and
	 * the callout's content.
	 *
	 * <p>In the following example, the padding on the bottom edge of the
	 * callout is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * callout.paddingBottom = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:padding
	 */
	[Style(name="paddingBottom",type="Number")]

	/**
	 * The minimum space, in pixels, between the callout's left edge and the
	 * callout's content.
	 *
	 * <p>In the following example, the padding on the left edge of the
	 * callout is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * callout.paddingLeft = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:padding
	 */
	[Style(name="paddingLeft",type="Number")]

	/**
	 * The space, in pixels, between the right arrow skin and the background
	 * skin. To have the arrow overlap the background, you may use a
	 * negative gap value.
	 *
	 * <p>In the following example, the gap between the callout and its
	 * right arrow is set to -4 pixels (perhaps to hide a border on the
	 * callout's background):</p>
	 *
	 * <listing version="3.0">
	 * callout.rightArrowGap = -4;</listing>
	 *
	 * @default 0
	 * 
	 * @see #style:rightArrowSkin
	 */
	[Style(name="rightArrowGap",type="Number")]

	/**
	 * The arrow skin to display on the right edge of the callout. This
	 * arrow is displayed when the callout is displayed to the left of the
	 * region it points at.
	 *
	 * <p>In the following example, the callout's right arrow skin is set
	 * to an image:</p>
	 *
	 * <listing version="3.0">
	 * callout.rightArrowSkin = new Image( texture );</listing>
	 *
	 * @default null
	 * 
	 * @see #style:rightArrowGap
	 */
	[Style(name="rightArrowSkin",type="starling.display.DisplayObject")]

	/**
	 * The space, in pixels, between the top arrow skin and the background
	 * skin. To have the arrow overlap the background, you may use a
	 * negative gap value.
	 *
	 * <p>In the following example, the gap between the callout and its
	 * top arrow is set to -4 pixels (perhaps to hide a border on the
	 * callout's background):</p>
	 *
	 * <listing version="3.0">
	 * callout.topArrowGap = -4;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:topArrowSkin
	 */
	[Style(name="topArrowGap",type="Number")]

	/**
	 * The arrow skin to display on the top edge of the callout. This arrow
	 * is displayed when the callout is displayed below the region it points
	 * at.
	 *
	 * <p>In the following example, the callout's top arrow skin is set
	 * to an image:</p>
	 *
	 * <listing version="3.0">
	 * callout.topArrowSkin = new Image( texture );</listing>
	 *
	 * @default null
	 * 
	 * @see #style:topArrowGap
	 */
	[Style(name="topArrowSkin",type="starling.display.DisplayObject")]

	/**
	 * The vertical alignment of the callout, relative to the origin.
	 *
	 * @default feathers.layout.VerticalAlign.MIDDLE
	 *
	 * @see feathers.layout.VerticalAlign#TOP
	 * @see feathers.layout.VerticalAlign#MIDDLE
	 * @see feathers.layout.VerticalAlign#BOTTOM
	 */
	[Style(name="verticalAlign",type="String")]

	/**
	 * The offset, in pixels, of the arrow skin from the horizontal center
	 * or vertical middle of the background skin, depending on the position
	 * of the arrow (which side it is on). This value is used to point at
	 * the callout's origin when the callout is not perfectly centered
	 * relative to the origin.
	 *
	 * <p>On the top and bottom edges, the arrow will move left for negative
	 * values of <code>arrowOffset</code> and right for positive values. On
	 * the left and right edges, the arrow will move up for negative values
	 * and down for positive values.</p>
	 *
	 * <p>If you use <code>Callout.show()</code> or set the <code>origin</code>
	 * property manually, you should avoid manually modifying the
	 * <code>arrowPosition</code> and <code>arrowOffset</code> properties.</p>
	 *
	 * <p>In the following example, the arrow offset is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * callout.arrowOffset = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:arrowPosition
	 * @see #origin
	 */
	[Style(name="arrowOffset",type="Number")]

	/**
	 * Dispatched when the callout is closed.
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
	 * @eventType starling.events.Event.CLOSE
	 */
	[Event(name="close",type="starling.events.Event")]

	/**
	 * A pop-up container that points at (or calls out) a specific region of
	 * the application (typically a specific control that triggered it).
	 *
	 * <p>In general, a <code>Callout</code> isn't instantiated directly.
	 * Instead, you will typically call the static function
	 * <code>Callout.show()</code>. This is not required, but it result in less
	 * code and no need to manually manage calls to the <code>PopUpManager</code>.</p>
	 *
	 * <p>In the following example, a callout displaying a <code>Label</code> is
	 * shown when a <code>Button</code> is triggered:</p>
	 *
	 * <listing version="3.0">
	 * button.addEventListener( Event.TRIGGERED, button_triggeredHandler );
	 * 
	 * function button_triggeredHandler( event:Event ):void
	 * {
	 *     var label:Label = new Label();
	 *     label.text = "Hello World!";
	 *     var button:Button = Button( event.currentTarget );
	 *     Callout.show( label, button );
	 * }</listing>
	 *
	 * @see ../../../help/callout.html How to use the Feathers Callout component
	 *
	 * @productversion Feathers 1.0.0
	 */
	public class Callout extends FeathersControl
	{
		/**
		 * The default <code>IStyleProvider</code> for all <code>Callout</code>
		 * components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * The default positions used by a callout.
		 */
		public static const DEFAULT_POSITIONS:Vector.<String> = new <String>
		[
			RelativePosition.BOTTOM,
			RelativePosition.TOP,
			RelativePosition.RIGHT,
			RelativePosition.LEFT,
		];

		/**
		 * @private
		 * DEPRECATED: Replaced by a Vector.&lt;String&gt; containing values from
		 * <code>feathers.layout.RelativePosition</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const DIRECTION_ANY:String = "any";

		/**
		 * @private
		 * DEPRECATED: Replaced by a Vector.&lt;String&gt; containing values from
		 * <code>feathers.layout.RelativePosition</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const DIRECTION_VERTICAL:String = "vertical";

		/**
		 * @private
		 * DEPRECATED: Replaced by a Vector.&lt;String&gt; containing values from
		 * <code>feathers.layout.RelativePosition</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const DIRECTION_HORIZONTAL:String = "horizontal";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.RelativePosition.TOP</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const DIRECTION_UP:String = "up";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.RelativePosition.BOTTOM</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const DIRECTION_DOWN:String = "down";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.RelativePosition.LEFT</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const DIRECTION_LEFT:String = "left";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.RelativePosition.RIGHT</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const DIRECTION_RIGHT:String = "right";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.RelativePosition.TOP</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const ARROW_POSITION_TOP:String = "top";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.RelativePosition.RIGHT</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const ARROW_POSITION_RIGHT:String = "right";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.RelativePosition.BOTTOM</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const ARROW_POSITION_BOTTOM:String = "bottom";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.RelativePosition.LEFT</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const ARROW_POSITION_LEFT:String = "left";

		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_ORIGIN:String = "origin";

		/**
		 * @private
		 */
		protected static const FUZZY_CONTENT_DIMENSIONS_PADDING:Number = 0.000001;

		/**
		 * Quickly sets all stage padding properties to the same value. The
		 * <code>stagePadding</code> getter always returns the value of
		 * <code>stagePaddingTop</code>, but the other padding values may be
		 * different.
		 *
		 * <p>The following example gives the stage 20 pixels of padding on all
		 * sides:</p>
		 *
		 * <listing version="3.0">
		 * Callout.stagePadding = 20;</listing>
		 *
		 * @default 0
		 *
		 * @see #stagePaddingTop
		 * @see #stagePaddingRight
		 * @see #stagePaddingBottom
		 * @see #stagePaddingLeft
		 */
		public static function get stagePadding():Number
		{
			return Callout.stagePaddingTop;
		}

		/**
		 * @private
		 */
		public static function set stagePadding(value:Number):void
		{
			Callout.stagePaddingTop = value;
			Callout.stagePaddingRight = value;
			Callout.stagePaddingBottom = value;
			Callout.stagePaddingLeft = value;
		}

		/**
		 * The padding between a callout and the top edge of the stage when the
		 * callout is positioned automatically. May be ignored if the callout
		 * is too big for the stage.
		 *
		 * <p>In the following example, the top stage padding will be set to
		 * 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * Callout.stagePaddingTop = 20;</listing>
		 */
		public static var stagePaddingTop:Number = 0;

		/**
		 * The padding between a callout and the right edge of the stage when the
		 * callout is positioned automatically. May be ignored if the callout
		 * is too big for the stage.
		 *
		 * <p>In the following example, the right stage padding will be set to
		 * 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * Callout.stagePaddingRight = 20;</listing>
		 */
		public static var stagePaddingRight:Number = 0;

		/**
		 * The padding between a callout and the bottom edge of the stage when the
		 * callout is positioned automatically. May be ignored if the callout
		 * is too big for the stage.
		 *
		 * <p>In the following example, the bottom stage padding will be set to
		 * 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * Callout.stagePaddingBottom = 20;</listing>
		 */
		public static var stagePaddingBottom:Number = 0;

		/**
		 * The margin between a callout and the top edge of the stage when the
		 * callout is positioned automatically. May be ignored if the callout
		 * is too big for the stage.
		 *
		 * <p>In the following example, the left stage padding will be set to
		 * 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * Callout.stagePaddingLeft = 20;</listing>
		 */
		public static var stagePaddingLeft:Number = 0;

		/**
		 * Returns a new <code>Callout</code> instance when
		 * <code>Callout.show()</code> is called. If one wishes to skin the
		 * callout manually or change its behavior, a custom factory may be
		 * provided.
		 *
		 * <p>This function is expected to have the following signature:</p>
		 *
		 * <pre>function():Callout</pre>
		 *
		 * <p>The following example shows how to create a custom callout factory:</p>
		 *
		 * <listing version="3.0">
		 * Callout.calloutFactory = function():Callout
		 * {
		 *     var callout:Callout = new Callout();
		 *     //set properties here!
		 *     return callout;
		 * };</listing>
		 * 
		 * <p>Note: the default callout factory sets the following properties:</p>
		 *
		 * <listing version="3.0">
		 * callout.closeOnTouchBeganOutside = true;
		 * callout.closeOnTouchEndedOutside = true;
		 * callout.closeOnKeys = new &lt;uint&gt;[Keyboard.BACK, Keyboard.ESCAPE];</listing>
		 *
		 * @see #show()
		 */
		public static var calloutFactory:Function = defaultCalloutFactory;

		/**
		 * Returns an overlay to display with a callout that is modal. Uses the
		 * standard <code>overlayFactory</code> of the <code>PopUpManager</code>
		 * by default, but you can use this property to provide your own custom
		 * overlay, if you prefer.
		 *
		 * <p>This function is expected to have the following signature:</p>
		 * <pre>function():DisplayObject</pre>
		 *
		 * <p>The following example uses a semi-transparent <code>Quad</code> as
		 * a custom overlay:</p>
		 *
		 * <listing version="3.0">
		 * Callout.calloutOverlayFactory = function():Quad
		 * {
		 *     var quad:Quad = new Quad(10, 10, 0x000000);
		 *     quad.alpha = 0.75;
		 *     return quad;
		 * };</listing>
		 *
		 * @see feathers.core.PopUpManager#overlayFactory
		 *
		 * @see #show()
		 */
		public static var calloutOverlayFactory:Function = PopUpManager.defaultOverlayFactory;

		/**
		 * Creates a callout, and then positions and sizes it automatically
		 * based on an origin rectangle and the specified direction relative to
		 * the original. The provided width and height values are optional, and
		 * these values may be ignored if the callout cannot be drawn at the
		 * specified dimensions.
		 * 
		 * <p>The <code>supportedPositions</code> parameter should be a
		 * <code>Vector.&lt;String&gt;</code> of values from the
		 * <code>feathers.layout.RelativePosition</code> class. The positions
		 * should be ordered by preference. This parameter is typed as
		 * <code>Object</code> to allow some deprecated <code>String</code>
		 * values. In a future version of Feathers, the type will change to
		 * <code>Vector.&lt;String&gt;</code> instead.</p>
		 *
		 * <p>In the following example, a callout displaying a <code>Label</code> is
		 * shown when a <code>Button</code> is triggered:</p>
		 *
		 * <listing version="3.0">
		 * button.addEventListener( Event.TRIGGERED, button_triggeredHandler );
		 *
		 * function button_triggeredHandler( event:Event ):void
		 * {
		 *     var label:Label = new Label();
		 *     label.text = "Hello World!";
		 *     var button:Button = Button( event.currentTarget );
		 *     Callout.show( label, button );
		 * }</listing>
		 */
		public static function show(content:DisplayObject, origin:DisplayObject,
			supportedPositions:Object = null, isModal:Boolean = true, customCalloutFactory:Function = null,
			customOverlayFactory:Function = null):Callout
		{
			if(origin.stage === null)
			{
				throw new ArgumentError("Callout origin must be added to the stage.");
			}
			var factory:Function = customCalloutFactory;
			if(factory === null)
			{
				factory = calloutFactory;
				if(factory === null)
				{
					factory = defaultCalloutFactory;
				}
			}
			var callout:Callout = Callout(factory());
			callout.content = content;
			if(supportedPositions is String)
			{
				//fallback for deprecated options
				callout.supportedDirections = supportedPositions as String;
			}
			else
			{
				callout.supportedPositions = supportedPositions as Vector.<String>;
			}
			callout.origin = origin;
			factory = customOverlayFactory;
			if(factory === null)
			{
				factory = calloutOverlayFactory;
				if(factory === null)
				{
					factory = PopUpManager.defaultOverlayFactory;
				}
			}
			PopUpManager.addPopUp(callout, isModal, false, factory);
			return callout;
		}

		/**
		 * The default factory that creates callouts when <code>Callout.show()</code>
		 * is called. To use a different factory, you need to set
		 * <code>Callout.calloutFactory</code> to a <code>Function</code>
		 * instance.
		 */
		public static function defaultCalloutFactory():Callout
		{
			var callout:Callout = new Callout();
			callout.closeOnTouchBeganOutside = true;
			callout.closeOnTouchEndedOutside = true;
			callout.closeOnKeys = new <uint>[Keyboard.BACK, Keyboard.ESCAPE];
			return callout;
		}

		/**
		 * @private
		 */
		protected static function positionBelowOrigin(callout:Callout, globalOrigin:Rectangle):void
		{
			callout.measureWithArrowPosition(RelativePosition.TOP);
			var idealXPosition:Number = globalOrigin.x;
			if(callout._horizontalAlign === HorizontalAlign.CENTER)
			{
				idealXPosition += Math.round((globalOrigin.width - callout.width) / 2);
			}
			else if(callout._horizontalAlign === HorizontalAlign.RIGHT)
			{
				idealXPosition += (globalOrigin.width - callout.width);
			}
			var xPosition:Number = idealXPosition;
			if(stagePaddingLeft > xPosition)
			{
				xPosition = stagePaddingLeft;
			}
			else
			{
				var stage:Stage = callout.stage !== null ? callout.stage : Starling.current.stage;
				var maxXPosition:Number = stage.stageWidth - callout.width - stagePaddingRight;
				if(maxXPosition < xPosition)
				{
					xPosition = maxXPosition;
				}
			}
			var point:Point = Pool.getPoint(xPosition, globalOrigin.y + globalOrigin.height);
			//we calculate the position in global coordinates, but the callout
			//may be in a container that is offset from the global origin, so
			//adjust for that difference.
			callout.parent.globalToLocal(point, point);
			callout.x = point.x;
			callout.y = point.y;
			Pool.putPoint(point);
			if(callout._isValidating)
			{
				//no need to invalidate and need to validate again next frame
				callout._arrowOffset = idealXPosition - xPosition;
				callout._arrowPosition = RelativePosition.TOP;
			}
			else
			{
				callout.arrowOffset = idealXPosition - xPosition;
				callout.arrowPosition = RelativePosition.TOP;
			}
		}

		/**
		 * @private
		 */
		protected static function positionAboveOrigin(callout:Callout, globalOrigin:Rectangle):void
		{
			callout.measureWithArrowPosition(RelativePosition.BOTTOM);
			var idealXPosition:Number = globalOrigin.x;
			if(callout._horizontalAlign === HorizontalAlign.CENTER)
			{
				idealXPosition += Math.round((globalOrigin.width - callout.width) / 2);
			}
			else if(callout._horizontalAlign === HorizontalAlign.RIGHT)
			{
				idealXPosition += (globalOrigin.width - callout.width);
			}
			var xPosition:Number = idealXPosition;
			if(stagePaddingLeft > xPosition)
			{
				xPosition = stagePaddingLeft;
			}
			else
			{
				var stage:Stage = callout.stage !== null ? callout.stage : Starling.current.stage;
				var maxXPosition:Number = stage.stageWidth - callout.width - stagePaddingRight;
				if(maxXPosition < xPosition)
				{
					xPosition = maxXPosition;
				}
			}
			var point:Point = Pool.getPoint(xPosition, globalOrigin.y - callout.height);
			//we calculate the position in global coordinates, but the callout
			//may be in a container that is offset from the global origin, so
			//adjust for that difference.
			callout.parent.globalToLocal(point, point);
			callout.x = point.x;
			callout.y = point.y;
			Pool.putPoint(point);
			if(callout._isValidating)
			{
				//no need to invalidate and need to validate again next frame
				callout._arrowOffset = idealXPosition - xPosition;
				callout._arrowPosition = RelativePosition.BOTTOM;
			}
			else
			{
				callout.arrowOffset = idealXPosition - xPosition;
				callout.arrowPosition = RelativePosition.BOTTOM;
			}
		}

		/**
		 * @private
		 */
		protected static function positionToRightOfOrigin(callout:Callout, globalOrigin:Rectangle):void
		{
			callout.measureWithArrowPosition(RelativePosition.LEFT);
			var idealYPosition:Number = globalOrigin.y;
			if(callout._verticalAlign === VerticalAlign.MIDDLE)
			{
				idealYPosition += Math.round((globalOrigin.height - callout.height) / 2);
			}
			else if(callout._verticalAlign === VerticalAlign.BOTTOM)
			{
				idealYPosition += (globalOrigin.height - callout.height);
			}
			var yPosition:Number = idealYPosition;
			if(stagePaddingTop > yPosition)
			{
				yPosition = stagePaddingTop;
			}
			else
			{
				var stage:Stage = callout.stage !== null ? callout.stage : Starling.current.stage;
				var maxYPosition:Number = stage.stageHeight - callout.height - stagePaddingBottom;
				if(maxYPosition < yPosition)
				{
					yPosition = maxYPosition;
				}
			}
			var point:Point = Pool.getPoint(globalOrigin.x + globalOrigin.width, yPosition);
			//we calculate the position in global coordinates, but the callout
			//may be in a container that is offset from the global origin, so
			//adjust for that difference.
			callout.parent.globalToLocal(point, point);
			callout.x = point.x;
			callout.y = point.y;
			Pool.putPoint(point);
			if(callout._isValidating)
			{
				//no need to invalidate and need to validate again next frame
				callout._arrowOffset = idealYPosition - yPosition;
				callout._arrowPosition = RelativePosition.LEFT;
			}
			else
			{
				callout.arrowOffset = idealYPosition - yPosition;
				callout.arrowPosition = RelativePosition.LEFT;
			}
		}

		/**
		 * @private
		 */
		protected static function positionToLeftOfOrigin(callout:Callout, globalOrigin:Rectangle):void
		{
			callout.measureWithArrowPosition(RelativePosition.RIGHT);
			var idealYPosition:Number = globalOrigin.y;
			if(callout._verticalAlign === VerticalAlign.MIDDLE)
			{
				idealYPosition += Math.round((globalOrigin.height - callout.height) / 2);
			}
			else if(callout._verticalAlign === VerticalAlign.BOTTOM)
			{
				idealYPosition += (globalOrigin.height - callout.height);
			}
			var yPosition:Number = idealYPosition;
			if(stagePaddingTop > yPosition)
			{
				yPosition = stagePaddingTop;
			}
			else
			{
				var stage:Stage = callout.stage !== null ? callout.stage : Starling.current.stage;
				var maxYPosition:Number = stage.stageHeight - callout.height - stagePaddingBottom;
				if(maxYPosition < yPosition)
				{
					yPosition = maxYPosition;
				}
			}
			var point:Point = Pool.getPoint(globalOrigin.x - callout.width, yPosition);
			//we calculate the position in global coordinates, but the callout
			//may be in a container that is offset from the global origin, so
			//adjust for that difference.
			callout.parent.globalToLocal(point, point);
			callout.x = point.x;
			callout.y = point.y;
			Pool.putPoint(point);
			if(callout._isValidating)
			{
				//no need to invalidate and need to validate again next frame
				callout._arrowOffset = idealYPosition - yPosition;
				callout._arrowPosition = RelativePosition.RIGHT;
			}
			else
			{
				callout.arrowOffset = idealYPosition - yPosition;
				callout.arrowPosition = RelativePosition.RIGHT;
			}
		}

		/**
		 * Constructor.
		 */
		public function Callout()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, callout_addedToStageHandler);
		}

		/**
		 * Determines if the callout is automatically closed if a touch in the
		 * <code>TouchPhase.BEGAN</code> phase happens outside of the callout's
		 * or the origin's bounds.
		 *
		 * <p>In the following example, the callout will not close when a touch
		 * event with <code>TouchPhase.BEGAN</code> is detected outside the
		 * callout's (or its origin's) bounds:</p>
		 *
		 * <listing version="3.0">
		 * callout.closeOnTouchBeganOutside = false;</listing>
		 *
		 * @see #closeOnTouchEndedOutside
		 * @see #closeOnKeys
		 */
		public var closeOnTouchBeganOutside:Boolean = false;

		/**
		 * Determines if the callout is automatically closed if a touch in the
		 * <code>TouchPhase.ENDED</code> phase happens outside of the callout's
		 * or the origin's bounds.
		 *
		 * <p>In the following example, the callout will not close when a touch
		 * event with <code>TouchPhase.ENDED</code> is detected outside the
		 * callout's (or its origin's) bounds:</p>
		 *
		 * <listing version="3.0">
		 * callout.closeOnTouchEndedOutside = false;</listing>
		 *
		 * @see #closeOnTouchBeganOutside
		 * @see #closeOnKeys
		 */
		public var closeOnTouchEndedOutside:Boolean = false;

		/**
		 * The callout will be closed if any of these keys are pressed.
		 *
		 * <p>In the following example, the callout close when the Escape key
		 * is pressed:</p>
		 *
		 * <listing version="3.0">
		 * callout.closeOnKeys = new &lt;uint&gt;[Keyboard.ESCAPE];</listing>
		 *
		 * @see #closeOnTouchBeganOutside
		 * @see #closeOnTouchEndedOutside
		 */
		public var closeOnKeys:Vector.<uint>;

		/**
		 * Determines if the callout will be disposed when <code>close()</code>
		 * is called internally. Close may be called internally in a variety of
		 * cases, depending on values such as <code>closeOnTouchBeganOutside</code>,
		 * <code>closeOnTouchEndedOutside</code>, and <code>closeOnKeys</code>.
		 * If set to <code>false</code>, you may reuse the callout later by
		 * giving it a new <code>origin</code> and adding it to the
		 * <code>PopUpManager</code> again.
		 *
		 * <p>In the following example, the callout will not be disposed when it
		 * closes itself:</p>
		 *
		 * <listing version="3.0">
		 * callout.disposeOnSelfClose = false;</listing>
		 *
		 * @see #closeOnTouchBeganOutside
		 * @see #closeOnTouchEndedOutside
		 * @see #closeOnKeys
		 * @see #close()
		 */
		public var disposeOnSelfClose:Boolean = true;

		/**
		 * Determines if the callout's content will be disposed when the callout
		 * is disposed. If set to <code>false</code>, the callout's content may
		 * be added to the display list again later.
		 *
		 * <p>In the following example, the callout's content will not be
		 * disposed when the callout is disposed:</p>
		 *
		 * <listing version="3.0">
		 * callout.disposeContent = false;</listing>
		 */
		public var disposeContent:Boolean = true;

		/**
		 * @private
		 */
		protected var _isReadyToClose:Boolean = false;

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return Callout.globalStyleProvider;
		}

		/**
		 * @private
		 */
		protected var _explicitContentWidth:Number;

		/**
		 * @private
		 */
		protected var _explicitContentHeight:Number;

		/**
		 * @private
		 */
		protected var _explicitContentMinWidth:Number;

		/**
		 * @private
		 */
		protected var _explicitContentMinHeight:Number;

		/**
		 * @private
		 */
		protected var _explicitContentMaxWidth:Number;

		/**
		 * @private
		 */
		protected var _explicitContentMaxHeight:Number;

		/**
		 * @private
		 */
		protected var _explicitBackgroundSkinWidth:Number;

		/**
		 * @private
		 */
		protected var _explicitBackgroundSkinHeight:Number;

		/**
		 * @private
		 */
		protected var _explicitBackgroundSkinMinWidth:Number;

		/**
		 * @private
		 */
		protected var _explicitBackgroundSkinMinHeight:Number;

		/**
		 * @private
		 */
		protected var _explicitBackgroundSkinMaxWidth:Number;

		/**
		 * @private
		 */
		protected var _explicitBackgroundSkinMaxHeight:Number;

		/**
		 * @private
		 */
		protected var _content:DisplayObject;

		/**
		 * The display object that will be presented by the callout. This object
		 * may be resized to fit the callout's bounds. If the content needs to
		 * be scrolled if placed into a smaller region than its ideal size, it
		 * must provide its own scrolling capabilities because the callout does
		 * not offer scrolling.
		 *
		 * <p>In the following example, the callout's content is an image:</p>
		 *
		 * <listing version="3.0">
		 * callout.content = new Image( texture );</listing>
		 *
		 * @default null
		 */
		public function get content():DisplayObject
		{
			return this._content;
		}

		/**
		 * @private
		 */
		public function set content(value:DisplayObject):void
		{
			if(this._content == value)
			{
				return;
			}
			if(this._content !== null)
			{
				if(this._content is IFeathersControl)
				{
					IFeathersControl(this._content).removeEventListener(FeathersEventType.RESIZE, content_resizeHandler);
				}
				if(this._content.parent === this)
				{
					this._content.width = this._explicitContentWidth;
					this._content.height = this._explicitContentHeight;
					if(this._content is IMeasureDisplayObject)
					{
						var measureContent:IMeasureDisplayObject = IMeasureDisplayObject(this._content);
						measureContent.minWidth = this._explicitContentMinWidth;
						measureContent.minHeight = this._explicitContentMinHeight;
						measureContent.maxWidth = this._explicitContentMaxWidth;
						measureContent.maxHeight = this._explicitContentMaxHeight;
					}
					this._content.removeFromParent(false);
				}
			}
			this._content = value;
			if(this._content !== null)
			{
				if(this._content is IFeathersControl)
				{
					IFeathersControl(this._content).addEventListener(FeathersEventType.RESIZE, content_resizeHandler);
				}
				this.addChild(this._content);
				if(this._content is IFeathersControl)
				{
					IFeathersControl(this._content).initializeNow();
				}
				if(this._content is IMeasureDisplayObject)
				{
					measureContent = IMeasureDisplayObject(this._content);
					this._explicitContentWidth = measureContent.explicitWidth;
					this._explicitContentHeight = measureContent.explicitHeight;
					this._explicitContentMinWidth = measureContent.explicitMinWidth;
					this._explicitContentMinHeight = measureContent.explicitMinHeight;
					this._explicitContentMaxWidth = measureContent.explicitMaxWidth;
					this._explicitContentMaxHeight = measureContent.explicitMaxHeight;
				}
				else
				{
					this._explicitContentWidth = this._content.width;
					this._explicitContentHeight = this._content.height;
					this._explicitContentMinWidth = this._explicitContentWidth;
					this._explicitContentMinHeight = this._explicitContentHeight;
					this._explicitContentMaxWidth = this._explicitContentWidth;
					this._explicitContentMaxHeight = this._explicitContentHeight;
				}
			}
			this.invalidate(INVALIDATION_FLAG_SIZE);
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _origin:DisplayObject;

		/**
		 * A callout may be positioned relative to another display object, known
		 * as the callout's origin. Even if the position of the origin changes,
		 * the callout will reposition itself to always point at the origin.
		 *
		 * <p>When an origin is set, the <code>arrowPosition</code> and
		 * <code>arrowOffset</code> properties will be managed automatically by
		 * the callout. Setting either of these values manually will either have
		 * no effect or unexpected behavior, so it is recommended that you
		 * avoid modifying those properties.</p>
		 * 
		 * <p>Note: The <code>origin</code> is excluded when using
		 * <code>closeOnTouchBeganOutside</code> and <code>closeOnTouchEndedOutside</code>.
		 * In other words, when the origin is touched, and either of these
		 * properties is <code>true</code>, the callout will not be closed. If
		 * the callout is not displayed modally, and touching the origin opens
		 * the callout, you should check if a callout is already visible. If a
		 * callout is visible, close it. If no callouts are visible, show one.
		 * However, if the callout is modal, the touch will be stopped by the
		 * overlay before it reaches the origin, so this behavior will not apply.</p>
		 *
		 * <p>In general, if you use <code>Callout.show()</code>, you will
		 * rarely need to manually manage the <code>origin</code> property.</p>
		 *
		 * <p>In the following example, the callout's origin is set to a button:</p>
		 *
		 * <listing version="3.0">
		 * callout.origin = button;</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.Callout#show()
		 * @see #supportedPositions
		 */
		public function get origin():DisplayObject
		{
			return this._origin;
		}

		/**
		 * @private
		 */
		public function set origin(value:DisplayObject):void
		{
			if(this._origin == value)
			{
				return;
			}
			if(value && !value.stage)
			{
				throw new ArgumentError("Callout origin must have access to the stage.");
			}
			if(this._origin)
			{
				this.removeEventListener(EnterFrameEvent.ENTER_FRAME, callout_enterFrameHandler);
				this._origin.removeEventListener(Event.REMOVED_FROM_STAGE, origin_removedFromStageHandler);
			}
			this._origin = value;
			this._lastGlobalBoundsOfOrigin = null;
			if(this._origin)
			{
				this._origin.addEventListener(Event.REMOVED_FROM_STAGE, origin_removedFromStageHandler);
				this.addEventListener(EnterFrameEvent.ENTER_FRAME, callout_enterFrameHandler);
			}
			this.invalidate(INVALIDATION_FLAG_ORIGIN);
		}

		/**
		 * @private
		 */
		protected var _supportedDirections:String = null;

		/**
		 * @private
		 * DEPRECATED: Replaced by the <code>position</code> property.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public function get supportedDirections():String
		{
			return this._supportedDirections;
		}

		/**
		 * @private
		 */
		public function set supportedDirections(value:String):void
		{
			var positions:Vector.<String> = null;
			if(value === DIRECTION_ANY)
			{
				positions = new <String>[RelativePosition.BOTTOM, RelativePosition.TOP, RelativePosition.RIGHT, RelativePosition.LEFT];
			}
			else if(value === DIRECTION_HORIZONTAL)
			{
				positions = new <String>[RelativePosition.RIGHT, RelativePosition.LEFT];
			}
			else if(value === DIRECTION_VERTICAL)
			{
				positions = new <String>[RelativePosition.BOTTOM, RelativePosition.TOP];
			}
			else if(value === DIRECTION_UP)
			{
				positions = new <String>[RelativePosition.TOP];
			}
			else if(value === DIRECTION_DOWN)
			{
				positions = new <String>[RelativePosition.BOTTOM];
			}
			else if(value === DIRECTION_RIGHT)
			{
				positions = new <String>[RelativePosition.RIGHT];
			}
			else if(value === DIRECTION_LEFT)
			{
				positions = new <String>[RelativePosition.LEFT];
			}
			this._supportedDirections = value;
			this.supportedPositions = positions;
		}

		/**
		 * @private
		 */
		protected var _supportedPositions:Vector.<String> = null;

		/**
		 * The position of the callout, relative to its origin. Accepts a
		 * <code>Vector.&lt;String&gt;</code> containing one or more of the
		 * constants from <code>feathers.layout.RelativePosition</code> or
		 * <code>null</code>. If <code>null</code>, the callout will attempt to
		 * position itself using values in the following order:
		 * 
		 * <ul>
		 *     <li><code>RelativePosition.BOTTOM</code></li>
		 *     <li><code>RelativePosition.TOP</code></li>
		 *     <li><code>RelativePosition.RIGHT</code></li>
		 *     <li><code>RelativePosition.LEFT</code></li>
		 * </ul>
		 * 
		 * <p>Note: If the callout's origin is not set, the
		 * <code>supportedPositions</code> property will be ignored.</p>
		 *
		 * <p>In the following example, the callout's supported positions are
		 * restricted to the top and bottom of the origin:</p>
		 *
		 * <listing version="3.0">
		 * callout.supportedPositions = new &lt;String&gt;[RelativePosition.TOP, RelativePosition.BOTTOM];</listing>
		 *
		 * <p>In the following example, the callout's position is restricted to
		 * the right of the origin:</p>
		 *
		 * <listing version="3.0">
		 * callout.supportedPositions = new &lt;String&gt;[RelativePosition.RIGHT];</listing>
		 *
		 * <p>Note: The <code>arrowPosition</code> property is related to this
		 * one, but they have different meanings and are usually opposites. For
		 * example, a callout on the right side of its origin will generally
		 * display its left arrow.</p>
		 *
		 * @default null
		 *
		 * @see feathers.layout.RelativePosition#TOP
		 * @see feathers.layout.RelativePosition#RIGHT
		 * @see feathers.layout.RelativePosition#BOTTOM
		 * @see feathers.layout.RelativePosition#LEFT
		 */
		public function get supportedPositions():Vector.<String>
		{
			return this._supportedPositions;
		}

		/**
		 * @private
		 */
		public function set supportedPositions(value:Vector.<String>):void
		{
			this._supportedPositions = value;
		}

		/**
		 * @private
		 */
		protected var _horizontalAlign:String = HorizontalAlign.CENTER;

		/**
		 * @private
		 */
		public function get horizontalAlign():String
		{
			return this._horizontalAlign;
		}

		/**
		 * @private
		 */
		public function set horizontalAlign(value:String):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._horizontalAlign === value)
			{
				return;
			}
			this._horizontalAlign = value;
			this._lastGlobalBoundsOfOrigin = null;
			this.invalidate(INVALIDATION_FLAG_ORIGIN);
		}

		/**
		 * @private
		 */
		protected var _verticalAlign:String = VerticalAlign.MIDDLE;

		/**
		 * @private
		 */
		public function get verticalAlign():String
		{
			return this._verticalAlign;
		}

		/**
		 * @private
		 */
		public function set verticalAlign(value:String):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._verticalAlign === value)
			{
				return;
			}
			this._verticalAlign = value;
			this._lastGlobalBoundsOfOrigin = null;
			this.invalidate(INVALIDATION_FLAG_ORIGIN);
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
			if(this._paddingTop === value)
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
			if(this._paddingRight === value)
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
			if(this._paddingBottom === value)
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
			if(this._paddingLeft === value)
			{
				return;
			}
			this._paddingLeft = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _arrowPosition:String = RelativePosition.TOP;

		[Inspectable(type="String",enumeration="top,right,bottom,left")]
		/**
		 * @private
		 */
		public function get arrowPosition():String
		{
			return this._arrowPosition;
		}

		/**
		 * @private
		 */
		public function set arrowPosition(value:String):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._arrowPosition === value)
			{
				return;
			}
			this._arrowPosition = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

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
			if(this._backgroundSkin !== null && this._backgroundSkin.parent === this)
			{
				//we need to restore these values so that they won't be lost the
				//next time that this skin is used for measurement
				this._backgroundSkin.width = this._explicitBackgroundSkinWidth;
				this._backgroundSkin.height = this._explicitBackgroundSkinHeight;
				if(this._backgroundSkin is IMeasureDisplayObject)
				{
					var measureSkin:IMeasureDisplayObject = IMeasureDisplayObject(this._backgroundSkin);
					measureSkin.minWidth = this._explicitBackgroundSkinMinWidth;
					measureSkin.minHeight = this._explicitBackgroundSkinMinHeight;
					measureSkin.maxWidth = this._explicitBackgroundSkinMaxWidth;
					measureSkin.maxHeight = this._explicitBackgroundSkinMaxHeight;
				}
				this._backgroundSkin.removeFromParent(false);
			}
			this._backgroundSkin = value;
			if(this._backgroundSkin !== null)
			{
				if(this._backgroundSkin is IFeathersControl)
				{
					IFeathersControl(this._backgroundSkin).initializeNow();
				}
				if(this._backgroundSkin is IMeasureDisplayObject)
				{
					measureSkin = IMeasureDisplayObject(this._backgroundSkin);
					this._explicitBackgroundSkinWidth = measureSkin.explicitWidth;
					this._explicitBackgroundSkinHeight = measureSkin.explicitHeight;
					this._explicitBackgroundSkinMinWidth = measureSkin.explicitMinWidth;
					this._explicitBackgroundSkinMinHeight = measureSkin.explicitMinHeight;
					this._explicitBackgroundSkinMaxWidth = measureSkin.explicitMaxWidth;
					this._explicitBackgroundSkinMaxHeight = measureSkin.explicitMaxHeight;
				}
				else
				{
					this._explicitBackgroundSkinWidth = this._backgroundSkin.width;
					this._explicitBackgroundSkinHeight = this._backgroundSkin.height;
					this._explicitBackgroundSkinMinWidth = this._explicitBackgroundSkinWidth;
					this._explicitBackgroundSkinMinHeight = this._explicitBackgroundSkinHeight;
					this._explicitBackgroundSkinMaxWidth = this._explicitBackgroundSkinWidth;
					this._explicitBackgroundSkinMaxHeight = this._explicitBackgroundSkinHeight;
				}
				this.addChildAt(this._backgroundSkin, 0);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var currentArrowSkin:DisplayObject;

		/**
		 * @private
		 */
		protected var _topArrowSkin:DisplayObject;

		/**
		 * @private
		 */
		public function get topArrowSkin():DisplayObject
		{
			return this._topArrowSkin;
		}

		/**
		 * @private
		 */
		public function set topArrowSkin(value:DisplayObject):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				if(value !== null)
				{
					value.dispose();
				}
				return;
			}
			if(this._topArrowSkin === value)
			{
				return;
			}
			if(this._topArrowSkin !== null && this._topArrowSkin.parent === this)
			{
				this._topArrowSkin.removeFromParent(false);
			}
			this._topArrowSkin = value;
			if(this._topArrowSkin !== null)
			{
				this._topArrowSkin.visible = false;
				var index:int = this.getChildIndex(this._content);
				if(index < 0)
				{
					this.addChild(this._topArrowSkin);
				}
				else
				{
					this.addChildAt(this._topArrowSkin, index);
				}
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _rightArrowSkin:DisplayObject;

		/**
		 * @private
		 */
		public function get rightArrowSkin():DisplayObject
		{
			return this._rightArrowSkin;
		}

		/**
		 * @private
		 */
		public function set rightArrowSkin(value:DisplayObject):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				if(value !== null)
				{
					value.dispose();
				}
				return;
			}
			if(this._rightArrowSkin === value)
			{
				return;
			}
			if(this._rightArrowSkin !== null && this._rightArrowSkin.parent === this)
			{
				this._rightArrowSkin.removeFromParent(false);
			}
			this._rightArrowSkin = value;
			if(this._rightArrowSkin !== null)
			{
				this._rightArrowSkin.visible = false;
				var index:int = this.getChildIndex(this._content);
				if(index < 0)
				{
					this.addChild(this._rightArrowSkin);
				}
				else
				{
					this.addChildAt(this._rightArrowSkin, index);
				}
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _bottomArrowSkin:DisplayObject;

		/**
		 * @private
		 */
		public function get bottomArrowSkin():DisplayObject
		{
			return this._bottomArrowSkin;
		}

		/**
		 * @private
		 */
		public function set bottomArrowSkin(value:DisplayObject):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				if(value !== null)
				{
					value.dispose();
				}
				return;
			}
			if(this._bottomArrowSkin === value)
			{
				return;
			}
			if(this._bottomArrowSkin !== null && this._bottomArrowSkin.parent === this)
			{
				this._bottomArrowSkin.removeFromParent(false);
			}
			this._bottomArrowSkin = value;
			if(this._bottomArrowSkin !== null)
			{
				this._bottomArrowSkin.visible = false;
				var index:int = this.getChildIndex(this._content);
				if(index < 0)
				{
					this.addChild(this._bottomArrowSkin);
				}
				else
				{
					this.addChildAt(this._bottomArrowSkin, index);
				}
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _leftArrowSkin:DisplayObject;

		/**
		 * @private
		 */
		public function get leftArrowSkin():DisplayObject
		{
			return this._leftArrowSkin;
		}

		/**
		 * @private
		 */
		public function set leftArrowSkin(value:DisplayObject):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				if(value !== null)
				{
					value.dispose();
				}
				return;
			}
			if(this._leftArrowSkin === value)
			{
				return;
			}
			if(this._leftArrowSkin !== null && this._leftArrowSkin.parent === this)
			{
				this._leftArrowSkin.removeFromParent(false);
			}
			this._leftArrowSkin = value;
			if(this._leftArrowSkin !== null)
			{
				this._leftArrowSkin.visible = false;
				var index:int = this.getChildIndex(this._content);
				if(index < 0)
				{
					this.addChild(this._leftArrowSkin);
				}
				else
				{
					this.addChildAt(this._leftArrowSkin, index);
				}
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _topArrowGap:Number = 0;

		/**
		 * @private
		 */
		public function get topArrowGap():Number
		{
			return this._topArrowGap;
		}

		/**
		 * @private
		 */
		public function set topArrowGap(value:Number):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._topArrowGap === value)
			{
				return;
			}
			this._topArrowGap = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _bottomArrowGap:Number = 0;

		/**
		 * @private
		 */
		public function get bottomArrowGap():Number
		{
			return this._bottomArrowGap;
		}

		/**
		 * @private
		 */
		public function set bottomArrowGap(value:Number):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._bottomArrowGap === value)
			{
				return;
			}
			this._bottomArrowGap = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _rightArrowGap:Number = 0;

		/**
		 * @private
		 */
		public function get rightArrowGap():Number
		{
			return this._rightArrowGap;
		}

		/**
		 * @private
		 */
		public function set rightArrowGap(value:Number):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._rightArrowGap === value)
			{
				return;
			}
			this._rightArrowGap = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _leftArrowGap:Number = 0;

		/**
		 * @private
		 */
		public function get leftArrowGap():Number
		{
			return this._leftArrowGap;
		}

		/**
		 * @private
		 */
		public function set leftArrowGap(value:Number):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._leftArrowGap === value)
			{
				return;
			}
			this._leftArrowGap = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _arrowOffset:Number = 0;

		/**
		 * @private
		 */
		public function get arrowOffset():Number
		{
			return this._arrowOffset;
		}

		/**
		 * @private
		 */
		public function set arrowOffset(value:Number):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._arrowOffset === value)
			{
				return;
			}
			this._arrowOffset = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _lastGlobalBoundsOfOrigin:Rectangle;

		/**
		 * @private
		 */
		protected var _ignoreContentResize:Boolean = false;

		/**
		 * @private
		 */
		override public function dispose():void
		{
			this.origin = null;
			var savedContent:DisplayObject = this._content;
			this.content = null;
			//remove the content safely if it should not be disposed
			if(savedContent !== null && this.disposeContent)
			{
				savedContent.dispose();
			}
			super.dispose();
		}

		/**
		 * Closes the callout.
		 */
		public function close(dispose:Boolean = false):void
		{
			if(this.parent)
			{
				//don't dispose here because we need to keep the event listeners
				//when dispatching Event.CLOSE. we'll dispose after that.
				this.removeFromParent(false);
				this.dispatchEventWith(Event.CLOSE);
			}
			if(dispose)
			{
				this.dispose();
			}
		}

		/**
		 * @private
		 */
		override protected function initialize():void
		{
			this.addEventListener(Event.REMOVED_FROM_STAGE, callout_removedFromStageHandler);
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			var stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			var stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			var originInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_ORIGIN);

			if(sizeInvalid)
			{
				this._lastGlobalBoundsOfOrigin = null;
				originInvalid = true;
			}

			if(originInvalid)
			{
				this.positionRelativeToOrigin();
			}

			if(stylesInvalid || stateInvalid)
			{
				this.refreshArrowSkin();
			}

			if(stateInvalid || dataInvalid)
			{
				this.refreshEnabled();
			}

			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

			this.layoutChildren();
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
			return this.measureWithArrowPosition(this._arrowPosition);
		}

		/**
		 * @private
		 */
		protected function measureWithArrowPosition(arrowPosition:String):Boolean
		{
			var needsWidth:Boolean = this._explicitWidth !== this._explicitWidth; //isNaN
			var needsHeight:Boolean = this._explicitHeight !== this._explicitHeight; //isNaN
			var needsMinWidth:Boolean = this._explicitMinWidth !== this._explicitMinWidth; //isNaN
			var needsMinHeight:Boolean = this._explicitMinHeight !== this._explicitMinHeight; //isNaN
			if(!needsWidth && !needsHeight && !needsMinWidth && !needsMinHeight)
			{
				return false;
			}

			if(this._backgroundSkin !== null)
			{
				var oldBackgroundWidth:Number = this._backgroundSkin.width;
				var oldBackgroundHeight:Number = this._backgroundSkin.height;
			}
			var measureBackground:IMeasureDisplayObject = this._backgroundSkin as IMeasureDisplayObject;
			resetFluidChildDimensionsForMeasurement(this._backgroundSkin,
				this._explicitWidth, this._explicitHeight,
				this._explicitMinWidth, this._explicitMinHeight,
				this._explicitMaxWidth, this._explicitMaxHeight,
				this._explicitBackgroundSkinWidth, this._explicitBackgroundSkinHeight,
				this._explicitBackgroundSkinMinWidth, this._explicitBackgroundSkinMinHeight,
				this._explicitBackgroundSkinMaxWidth, this._explicitBackgroundSkinMaxHeight);
			if(this._backgroundSkin is IValidating)
			{
				IValidating(this._backgroundSkin).validate();
			}

			var leftOrRightArrowWidth:Number = 0;
			var leftOrRightArrowHeight:Number = 0;
			if(arrowPosition === RelativePosition.LEFT && this._leftArrowSkin !== null)
			{
				leftOrRightArrowWidth = this._leftArrowSkin.width + this._leftArrowGap;
				leftOrRightArrowHeight = this._leftArrowSkin.height;
			}
			else if(arrowPosition === RelativePosition.RIGHT && this._rightArrowSkin !== null)
			{
				leftOrRightArrowWidth = this._rightArrowSkin.width + this._rightArrowGap;
				leftOrRightArrowHeight = this._rightArrowSkin.height;
			}
			var topOrBottomArrowWidth:Number = 0;
			var topOrBottomArrowHeight:Number = 0;
			if(arrowPosition === RelativePosition.TOP && this._topArrowSkin !== null)
			{
				topOrBottomArrowWidth = this._topArrowSkin.width;
				topOrBottomArrowHeight = this._topArrowSkin.height + this._topArrowGap;
			}
			else if(arrowPosition === RelativePosition.BOTTOM && this._bottomArrowSkin !== null)
			{
				topOrBottomArrowWidth = this._bottomArrowSkin.width;
				topOrBottomArrowHeight = this._bottomArrowSkin.height + this._bottomArrowGap;
			}
			//the content resizes when the callout resizes, so we can treat it
			//similarly to a background skin
			var oldIgnoreContentResize:Boolean = this._ignoreContentResize;
			this._ignoreContentResize = true;
			var measureContent:IMeasureDisplayObject = this._content as IMeasureDisplayObject;
			resetFluidChildDimensionsForMeasurement(this._content,
				this._explicitWidth - leftOrRightArrowWidth - this._paddingLeft - this._paddingRight,
				this._explicitHeight - topOrBottomArrowHeight - this._paddingTop - this._paddingBottom,
				this._explicitMinWidth - leftOrRightArrowWidth - this._paddingLeft - this._paddingRight,
				this._explicitMinHeight - topOrBottomArrowHeight - this._paddingTop - this._paddingBottom,
				this._explicitMaxWidth - leftOrRightArrowHeight - this._paddingLeft - this._paddingRight,
				this._explicitMaxHeight - topOrBottomArrowHeight - this._paddingTop - this._paddingBottom,
				this._explicitContentWidth, this._explicitContentHeight,
				this._explicitContentMinWidth, this._explicitContentMinHeight,
				this._explicitContentMaxWidth, this._explicitContentMaxHeight);
			if(measureContent !== null)
			{
				var contentMaxWidth:Number = this._explicitMaxWidth - this._paddingLeft - this._paddingRight;
				if(contentMaxWidth < measureContent.maxWidth)
				{
					measureContent.maxWidth = contentMaxWidth;
				}
				var contentMaxHeight:Number = this._explicitMaxHeight - this._paddingTop - this._paddingBottom;
				if(contentMaxHeight < measureContent.maxHeight)
				{
					measureContent.maxHeight = contentMaxHeight;
				}
			}
			if(this._content is IValidating)
			{
				IValidating(this._content).validate();
			}
			this._ignoreContentResize = oldIgnoreContentResize;

			//the dimensions of the stage (plus stage padding) affect the
			//maximum width and height
			var maxWidth:Number = this._explicitMaxWidth;
			var maxHeight:Number = this._explicitMaxHeight;
			if(this.stage !== null)
			{
				var stageMaxWidth:Number = this.stage.stageWidth - stagePaddingLeft - stagePaddingRight;
				if(maxWidth > stageMaxWidth)
				{
					maxWidth = stageMaxWidth;
				}
				var stageMaxHeight:Number = this.stage.stageHeight - stagePaddingTop - stagePaddingBottom;
				if(maxHeight > stageMaxHeight)
				{
					maxHeight = stageMaxHeight;
				}
			}
			
			var newWidth:Number = this._explicitWidth;
			if(needsWidth)
			{
				var contentWidth:Number = 0;
				if(this._content !== null)
				{
					contentWidth = this._content.width;
				}
				if(topOrBottomArrowWidth > contentWidth)
				{
					contentWidth = topOrBottomArrowWidth;
				}
				newWidth = contentWidth + this._paddingLeft + this._paddingRight;
				var backgroundWidth:Number = 0;
				if(this._backgroundSkin !== null)
				{
					backgroundWidth = this._backgroundSkin.width;
				}
				if(backgroundWidth > newWidth)
				{
					newWidth = backgroundWidth;
				}
				newWidth += leftOrRightArrowWidth;
				if(newWidth > maxWidth)
				{
					newWidth = maxWidth;
				}
			}
			var newHeight:Number = this._explicitHeight;
			if(needsHeight)
			{
				var contentHeight:Number = 0;
				if(this._content !== null)
				{
					contentHeight = this._content.height;
				}
				if(leftOrRightArrowHeight > contentWidth)
				{
					contentHeight = leftOrRightArrowHeight;
				}
				newHeight = contentHeight + this._paddingTop + this._paddingBottom;
				var backgroundHeight:Number = 0;
				if(this._backgroundSkin !== null)
				{
					backgroundHeight = this._backgroundSkin.height;
				}
				if(backgroundHeight > newHeight)
				{
					newHeight = backgroundHeight;
				}
				newHeight += topOrBottomArrowHeight;
				if(newHeight > maxHeight)
				{
					newHeight = maxHeight;
				}
			}
			var newMinWidth:Number = this._explicitMinWidth;
			if(needsMinWidth)
			{
				var contentMinWidth:Number = 0;
				if(measureContent !== null)
				{
					contentMinWidth = measureContent.minWidth;
				}
				else if(this._content !== null)
				{
					contentMinWidth = this._content.width;
				}
				if(topOrBottomArrowWidth > contentMinWidth)
				{
					contentMinWidth = topOrBottomArrowWidth;
				}
				newMinWidth = contentMinWidth + this._paddingLeft + this._paddingRight;
				var backgroundMinWidth:Number = 0;
				if(measureBackground !== null)
				{
					backgroundMinWidth = measureBackground.minWidth;
				}
				else if(this._backgroundSkin !== null)
				{
					backgroundMinWidth = this._explicitBackgroundSkinMinWidth;
				}
				if(backgroundMinWidth > newMinWidth)
				{
					newMinWidth = backgroundMinWidth;
				}
				newMinWidth += leftOrRightArrowWidth;
				if(newMinWidth > maxWidth)
				{
					newMinWidth = maxWidth;
				}
			}
			var newMinHeight:Number = this._explicitHeight;
			if(needsMinHeight)
			{
				var contentMinHeight:Number = 0;
				if(measureContent !== null)
				{
					contentMinHeight = measureContent.minHeight;
				}
				else if(this._content !== null)
				{
					contentMinHeight = this._content.height;
				}
				if(leftOrRightArrowHeight > contentMinHeight)
				{
					contentMinHeight = leftOrRightArrowHeight;
				}
				newMinHeight = contentMinHeight + this._paddingTop + this._paddingBottom;
				var backgroundMinHeight:Number = 0;
				if(measureBackground !== null)
				{
					backgroundMinHeight = measureBackground.minHeight;
				}
				else if(this._backgroundSkin !== null)
				{
					backgroundMinHeight = this._explicitBackgroundSkinMinHeight;
				}
				if(backgroundMinHeight > newMinHeight)
				{
					newMinHeight = backgroundMinHeight;
				}
				newMinHeight += topOrBottomArrowHeight;
				if(newMinHeight > maxHeight)
				{
					newMinHeight = maxHeight;
				}
			}
			if(this._backgroundSkin !== null)
			{
				this._backgroundSkin.width = oldBackgroundWidth;
				this._backgroundSkin.height = oldBackgroundHeight;
			}
			return this.saveMeasurements(newWidth, newHeight, newMinWidth, newMinHeight);
		}

		/**
		 * @private
		 */
		protected function refreshArrowSkin():void
		{
			this.currentArrowSkin = null;
			if(this._arrowPosition == RelativePosition.BOTTOM)
			{
				this.currentArrowSkin = this._bottomArrowSkin;
			}
			else if(this._bottomArrowSkin)
			{
				this._bottomArrowSkin.visible = false;
			}
			if(this._arrowPosition == RelativePosition.TOP)
			{
				this.currentArrowSkin = this._topArrowSkin;
			}
			else if(this._topArrowSkin)
			{
				this._topArrowSkin.visible = false;
			}
			if(this._arrowPosition == RelativePosition.LEFT)
			{
				this.currentArrowSkin = this._leftArrowSkin;
			}
			else if(this._leftArrowSkin)
			{
				this._leftArrowSkin.visible = false;
			}
			if(this._arrowPosition == RelativePosition.RIGHT)
			{
				this.currentArrowSkin = this._rightArrowSkin;
			}
			else if(this._rightArrowSkin)
			{
				this._rightArrowSkin.visible = false;
			}
			if(this.currentArrowSkin)
			{
				this.currentArrowSkin.visible = true;
			}
		}

		/**
		 * @private
		 */
		protected function refreshEnabled():void
		{
			if(this._content is IFeathersControl)
			{
				IFeathersControl(this._content).isEnabled = this._isEnabled;
			}
		}

		/**
		 * @private
		 */
		protected function layoutChildren():void
		{
			var xPosition:Number = 0;
			if(this._leftArrowSkin !== null && this._arrowPosition === RelativePosition.LEFT)
			{
				xPosition = this._leftArrowSkin.width + this._leftArrowGap;
			}
			var yPosition:Number = 0;
			if(this._topArrowSkin !== null &&  this._arrowPosition === RelativePosition.TOP)
			{
				yPosition = this._topArrowSkin.height + this._topArrowGap;
			}
			var widthOffset:Number = 0;
			if(this._rightArrowSkin !== null && this._arrowPosition === RelativePosition.RIGHT)
			{
				widthOffset = this._rightArrowSkin.width + this._rightArrowGap;
			}
			var heightOffset:Number = 0;
			if(this._bottomArrowSkin !== null && this._arrowPosition === RelativePosition.BOTTOM)
			{
				heightOffset = this._bottomArrowSkin.height + this._bottomArrowGap;
			}
			var backgroundWidth:Number = this.actualWidth - xPosition - widthOffset;
			var backgroundHeight:Number = this.actualHeight - yPosition - heightOffset;
			if(this._backgroundSkin !== null)
			{
				this._backgroundSkin.x = xPosition;
				this._backgroundSkin.y = yPosition;
				this._backgroundSkin.width = backgroundWidth;
				this._backgroundSkin.height = backgroundHeight;
			}

			if(this.currentArrowSkin !== null)
			{
				var contentWidth:Number = backgroundWidth - this._paddingLeft - this._paddingRight;
				var contentHeight:Number = backgroundHeight - this._paddingTop - this._paddingBottom;
				if(this._arrowPosition === RelativePosition.LEFT)
				{
					this._leftArrowSkin.x = xPosition - this._leftArrowSkin.width - this._leftArrowGap;
					var leftArrowSkinY:Number = this._arrowOffset + yPosition + this._paddingTop;
					if(this._verticalAlign === VerticalAlign.MIDDLE)
					{
						leftArrowSkinY += Math.round((contentHeight - this._leftArrowSkin.height) / 2);
					}
					else if(this._verticalAlign === VerticalAlign.BOTTOM)
					{
						leftArrowSkinY += (contentHeight - this._leftArrowSkin.height);
					}
					var minLeftArrowSkinY:Number = yPosition + this._paddingTop;
					if(minLeftArrowSkinY > leftArrowSkinY)
					{
						leftArrowSkinY = minLeftArrowSkinY;
					}
					else
					{
						var maxLeftArrowSkinY:Number = yPosition + this._paddingTop + contentHeight - this._leftArrowSkin.height;
						if(maxLeftArrowSkinY < leftArrowSkinY)
						{
							leftArrowSkinY = maxLeftArrowSkinY;
						}
					}
					this._leftArrowSkin.y = leftArrowSkinY;
				}
				else if(this._arrowPosition === RelativePosition.RIGHT)
				{
					this._rightArrowSkin.x = xPosition + backgroundWidth + this._rightArrowGap;
					var rightArrowSkinY:Number = this._arrowOffset + yPosition + this._paddingTop;
					if(this._verticalAlign === VerticalAlign.MIDDLE)
					{
						rightArrowSkinY += Math.round((contentHeight - this._rightArrowSkin.height) / 2);
					}
					else if(this._verticalAlign === VerticalAlign.BOTTOM)
					{
						rightArrowSkinY += (contentHeight - this._rightArrowSkin.height);
					}
					var minRightArrowSkinY:Number = yPosition + this._paddingTop;
					if(minRightArrowSkinY > rightArrowSkinY)
					{
						rightArrowSkinY = minRightArrowSkinY;
					}
					else
					{
						var maxRightArrowSkinY:Number = yPosition + this._paddingTop + contentHeight - this._rightArrowSkin.height;
						if(maxRightArrowSkinY < rightArrowSkinY)
						{
							rightArrowSkinY = maxRightArrowSkinY;
						}
					}
					this._rightArrowSkin.y = rightArrowSkinY;
				}
				else if(this._arrowPosition === RelativePosition.BOTTOM)
				{
					var bottomArrowSkinX:Number = this._arrowOffset + xPosition + this._paddingLeft;
					if(this._horizontalAlign === HorizontalAlign.CENTER)
					{
						bottomArrowSkinX += Math.round((contentWidth - this._bottomArrowSkin.width) / 2);
					}
					else if(this._horizontalAlign === HorizontalAlign.RIGHT)
					{
						bottomArrowSkinX += (contentWidth - this._bottomArrowSkin.width);
					}
					var minBottomArrowSkinX:Number = xPosition + this._paddingLeft;
					if(minBottomArrowSkinX > bottomArrowSkinX)
					{
						bottomArrowSkinX = minBottomArrowSkinX;
					}
					else
					{
						var maxBottomArrowSkinX:Number = xPosition + this._paddingLeft + contentWidth - this._bottomArrowSkin.width;
						if(maxBottomArrowSkinX < bottomArrowSkinX)
						{
							bottomArrowSkinX = maxBottomArrowSkinX;
						}
					}
					this._bottomArrowSkin.x = bottomArrowSkinX; 
					this._bottomArrowSkin.y = yPosition + backgroundHeight + this._bottomArrowGap;
				}
				else //top
				{
					var topArrowSkinX:Number = this._arrowOffset + xPosition + this._paddingLeft;
					if(this._horizontalAlign === HorizontalAlign.CENTER)
					{
						topArrowSkinX += Math.round((contentWidth - this._topArrowSkin.width) / 2);
					}
					else if(this._horizontalAlign === HorizontalAlign.RIGHT)
					{
						topArrowSkinX += (contentWidth - this._topArrowSkin.width);
					}
					var minTopArrowSkinX:Number = xPosition + this._paddingLeft;
					if(minTopArrowSkinX > topArrowSkinX)
					{
						topArrowSkinX = minTopArrowSkinX;
					}
					else
					{
						var maxTopArrowSkinX:Number = xPosition + this._paddingLeft + contentWidth - this._topArrowSkin.width;
						if(maxTopArrowSkinX < topArrowSkinX)
						{
							topArrowSkinX = maxTopArrowSkinX;
						}
					}
					this._topArrowSkin.x = topArrowSkinX;
					this._topArrowSkin.y = yPosition - this._topArrowSkin.height - this._topArrowGap;
				}
			}

			if(this._content !== null)
			{
				this._content.x = xPosition + this._paddingLeft;
				this._content.y = yPosition + this._paddingTop;
				var oldIgnoreContentResize:Boolean = this._ignoreContentResize;
				this._ignoreContentResize = true;
				this._content.width = backgroundWidth - this._paddingLeft - this._paddingRight;
				this._content.height = backgroundHeight - this._paddingTop - this._paddingBottom;
				if(this._content is IValidating)
				{
					IValidating(this._content).validate();
				}
				this._ignoreContentResize = oldIgnoreContentResize;
			}
		}

		/**
		 * @private
		 */
		protected function positionRelativeToOrigin():void
		{
			if(this._origin === null)
			{
				return;
			}
			var stage:Stage = this.stage !== null ? this.stage : Starling.current.stage;
			var rect:Rectangle = Pool.getRectangle();
			this._origin.getBounds(stage, rect);
			var hasGlobalBounds:Boolean = this._lastGlobalBoundsOfOrigin != null;
			if(hasGlobalBounds && this._lastGlobalBoundsOfOrigin.equals(rect))
			{
				Pool.putRectangle(rect);
				return;
			}
			if(!hasGlobalBounds)
			{
				this._lastGlobalBoundsOfOrigin = new Rectangle();
			}
			this._lastGlobalBoundsOfOrigin.x = rect.x;
			this._lastGlobalBoundsOfOrigin.y = rect.y;
			this._lastGlobalBoundsOfOrigin.width = rect.width;
			this._lastGlobalBoundsOfOrigin.height = rect.height;
			Pool.putRectangle(rect);

			var supportedPositions:Vector.<String> = this._supportedPositions;
			if(supportedPositions === null)
			{
				supportedPositions = DEFAULT_POSITIONS;
			}
			var upSpace:Number = -1;
			var rightSpace:Number = -1;
			var downSpace:Number = -1;
			var leftSpace:Number = -1;
			var positionsCount:int = supportedPositions.length;
			for(var i:int = 0; i < positionsCount; i++)
			{
				var position:String = supportedPositions[i];
				switch(position)
				{
					case RelativePosition.TOP:
					{
						//arrow is opposite, on bottom side
						this.measureWithArrowPosition(RelativePosition.BOTTOM);
						upSpace = this._lastGlobalBoundsOfOrigin.y - this.actualHeight;
						if(upSpace >= stagePaddingTop)
						{
							positionAboveOrigin(this, this._lastGlobalBoundsOfOrigin);
							return;
						}
						if(upSpace < 0)
						{
							upSpace = 0;
						}
						break;
					}
					case RelativePosition.RIGHT:
					{
						//arrow is opposite, on left side
						this.measureWithArrowPosition(RelativePosition.LEFT);
						rightSpace = (stage.stageWidth - actualWidth) - (this._lastGlobalBoundsOfOrigin.x + this._lastGlobalBoundsOfOrigin.width);
						if(rightSpace >= stagePaddingRight)
						{
							positionToRightOfOrigin(this, this._lastGlobalBoundsOfOrigin);
							return;
						}
						if(rightSpace < 0)
						{
							rightSpace = 0;
						}
						break;
					}
					case RelativePosition.LEFT:
					{
						this.measureWithArrowPosition(RelativePosition.RIGHT);
						leftSpace = this._lastGlobalBoundsOfOrigin.x - this.actualWidth;
						if(leftSpace >= stagePaddingLeft)
						{
							positionToLeftOfOrigin(this, this._lastGlobalBoundsOfOrigin);
							return;
						}
						if(leftSpace < 0)
						{
							leftSpace = 0;
						}
						break;
					}
					default: //bottom
					{
						//arrow is opposite, on top side
						this.measureWithArrowPosition(RelativePosition.TOP);
						downSpace = (stage.stageHeight - this.actualHeight) - (this._lastGlobalBoundsOfOrigin.y + this._lastGlobalBoundsOfOrigin.height);
						if(downSpace >= stagePaddingBottom)
						{
							positionBelowOrigin(this, this._lastGlobalBoundsOfOrigin);
							return;
						}
						if(downSpace < 0)
						{
							downSpace = 0;
						}
					}
				}
			}
			//worst case: pick the side that has the most available space
			if(downSpace !== -1 && downSpace >= upSpace &&
				downSpace >= rightSpace && downSpace >= leftSpace)
			{
				positionBelowOrigin(this, this._lastGlobalBoundsOfOrigin);
			}
			else if(upSpace !== -1 && upSpace >= rightSpace && upSpace >= leftSpace)
			{
				positionAboveOrigin(this, this._lastGlobalBoundsOfOrigin);
			}
			else if(rightSpace !== -1 && rightSpace >= leftSpace)
			{
				positionToRightOfOrigin(this, this._lastGlobalBoundsOfOrigin);
			}
			else
			{
				positionToLeftOfOrigin(this, this._lastGlobalBoundsOfOrigin);
			}
		}

		/**
		 * @private
		 */
		protected function callout_addedToStageHandler(event:Event):void
		{
			var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
			//using priority here is a hack so that objects higher up in the
			//display list have a chance to cancel the event first.
			var priority:int = -getDisplayObjectDepthFromStage(this);
			starling.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, callout_nativeStage_keyDownHandler, false, priority, true);

			this.stage.addEventListener(TouchEvent.TOUCH, stage_touchHandler);
			//to avoid touch events bubbling up to the callout and causing it to
			//close immediately, we wait one frame before allowing it to close
			//based on touches.
			this._isReadyToClose = false;
			this.addEventListener(EnterFrameEvent.ENTER_FRAME, callout_oneEnterFrameHandler);
		}

		/**
		 * @private
		 */
		protected function callout_removedFromStageHandler(event:Event):void
		{
			this.stage.removeEventListener(TouchEvent.TOUCH, stage_touchHandler);
			var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
			starling.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN, callout_nativeStage_keyDownHandler);
		}

		/**
		 * @private
		 */
		protected function callout_oneEnterFrameHandler(event:Event):void
		{
			this.removeEventListener(EnterFrameEvent.ENTER_FRAME, callout_oneEnterFrameHandler);
			this._isReadyToClose = true;
		}

		/**
		 * @private
		 */
		protected function callout_enterFrameHandler(event:EnterFrameEvent):void
		{
			this.positionRelativeToOrigin();
		}

		/**
		 * @private
		 */
		protected function stage_touchHandler(event:TouchEvent):void
		{
			var target:DisplayObject = DisplayObject(event.target);
			if(!this._isReadyToClose ||
				(!this.closeOnTouchEndedOutside && !this.closeOnTouchBeganOutside) || this.contains(target) ||
				(PopUpManager.isPopUp(this) && !PopUpManager.isTopLevelPopUp(this)))
			{
				return;
			}

			if(this._origin == target || (this._origin is DisplayObjectContainer && DisplayObjectContainer(this._origin).contains(target)))
			{
				return;
			}

			if(this.closeOnTouchBeganOutside)
			{
				var touch:Touch = event.getTouch(this.stage, TouchPhase.BEGAN);
				if(touch)
				{
					this.close(this.disposeOnSelfClose);
					return;
				}
			}
			if(this.closeOnTouchEndedOutside)
			{
				touch = event.getTouch(this.stage, TouchPhase.ENDED);
				if(touch)
				{
					this.close(this.disposeOnSelfClose);
					return;
				}
			}
		}

		/**
		 * @private
		 */
		protected function callout_nativeStage_keyDownHandler(event:KeyboardEvent):void
		{
			if(event.isDefaultPrevented())
			{
				//someone else already handled this one
				return;
			}
			if(!this.closeOnKeys || this.closeOnKeys.indexOf(event.keyCode) < 0)
			{
				return;
			}
			//don't let the OS handle the event
			event.preventDefault();
			this.close(this.disposeOnSelfClose);
		}

		/**
		 * @private
		 */
		protected function origin_removedFromStageHandler(event:Event):void
		{
			this.close(this.disposeOnSelfClose);
		}

		/**
		 * @private
		 */
		protected function content_resizeHandler(event:Event):void
		{
			if(this._ignoreContentResize)
			{
				return;
			}
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}
	}
}
