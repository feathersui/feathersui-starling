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
	import feathers.core.IStateObserver;
	import feathers.core.ITextBaselineControl;
	import feathers.core.ITextRenderer;
	import feathers.core.IValidating;
	import feathers.core.PropertyProxy;
	import feathers.events.FeathersEventType;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.RelativePosition;
	import feathers.layout.VerticalAlign;
	import feathers.skins.IStyleProvider;
	import feathers.text.FontStylesSet;
	import feathers.utils.keyboard.KeyToTrigger;
	import feathers.utils.skins.resetFluidChildDimensionsForMeasurement;
	import feathers.utils.touch.LongPress;

	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.ui.Keyboard;

	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.rendering.Painter;
	import starling.text.TextFormat;

	/**
	 * The icon used when no other icon is defined for the current state.
	 * Intended to be used when multiple states should share the same icon.
	 *
	 * <p>This property will be ignored if a function is passed to the
	 * <code>stateToIconFunction</code> property.</p>
	 *
	 * <p>The following example gives the button a default icon to use for
	 * all states when no specific icon is available:</p>
	 *
	 * <listing version="3.0">
	 * button.defaultIcon = new Image( texture );</listing>
	 *
	 * @default null
	 *
	 * @see #setIconForState()
	 */
	[Style(name="defaultIcon",type="starling.display.DisplayObject")]

	/**
	 * The font styles used to display the button's text when the button is
	 * disabled.
	 *
	 * <p>In the following example, the disabled font styles are customized:</p>
	 *
	 * <listing version="3.0">
	 * button.disabledFontStyles = new TextFormat( "Helvetica", 20, 0x999999 );</listing>
	 *
	 * <p>Note: The <code>starling.text.TextFormat</code> class defines a
	 * number of common font styles, but the text renderer being used may
	 * support a larger number of ways to be customized. Use the
	 * <code>labelFactory</code> to set more advanced styles on the
	 * text renderer.</p>
	 *
	 * @default null
	 *
	 * @see http://doc.starling-framework.org/current/starling/text/TextFormat.html starling.text.TextFormat
	 * @see #style:fontStyles
	 */
	[Style(name="disabledFontStyles",type="starling.text.TextFormat")]

	/**
	 * The font styles used to display the button's text.
	 *
	 * <p>In the following example, the font styles are customized:</p>
	 *
	 * <listing version="3.0">
	 * button.fontStyles = new TextFormat( "Helvetica", 20, 0xcc0000 );</listing>
	 *
	 * <p>Note: The <code>starling.text.TextFormat</code> class defines a
	 * number of common font styles, but the text renderer being used may
	 * support a larger number of ways to be customized. Use the
	 * <code>labelFactory</code> to set more advanced styles.</p>
	 *
	 * @default null
	 *
	 * @see http://doc.starling-framework.org/current/starling/text/TextFormat.html starling.text.TextFormat
	 * @see #style:disabledFontStyles
	 * @see #setFontStylesForState()
	 */
	[Style(name="fontStyles",type="starling.text.TextFormat")]

	/**
	 * The space, in pixels, between the icon and the label. Applies to
	 * either horizontal or vertical spacing, depending on the value of
	 * <code>iconPosition</code>.
	 *
	 * <p>If <code>gap</code> is set to <code>Number.POSITIVE_INFINITY</code>,
	 * the label and icon will be positioned as far apart as possible. In
	 * other words, they will be positioned at the edges of the button,
	 * adjusted for padding.</p>
	 *
	 * <p>The following example creates a gap of 50 pixels between the label
	 * and the icon:</p>
	 *
	 * <listing version="3.0">
	 * button.label = "Click Me";
	 * button.defaultIcon = new Image( texture );
	 * button.gap = 50;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:iconPosition
	 * @see #style:minGap
	 */
	[Style(name="gap",type="Number")]

	/**
	 * The location where the button's content is aligned horizontally (on
	 * the x-axis).
	 *
	 * <p>The following example aligns the button's content to the left:</p>
	 *
	 * <listing version="3.0">
	 * button.horizontalAlign = HorizontalAlign.LEFT;</listing>
	 *
	 * @default feathers.layout.HorizontalAlign.CENTER
	 *
	 * @see feathers.layout.HorizontalAlign#LEFT
	 * @see feathers.layout.HorizontalAlign#CENTER
	 * @see feathers.layout.HorizontalAlign#RIGHT
	 */
	[Style(name="horizontalAlign",type="String")]

	/**
	 * The location where the button's content is aligned vertically (on
	 * the y-axis).
	 *
	 * <p>The following example aligns the button's content to the top:</p>
	 *
	 * <listing version="3.0">
	 * button.verticalAlign = VerticalAlign.TOP;</listing>
	 *
	 * @default feathers.layout.VerticalAlign.MIDDLE
	 *
	 * @see feathers.layout.VerticalAlign#TOP
	 * @see feathers.layout.VerticalAlign#MIDDLE
	 * @see feathers.layout.VerticalAlign#BOTTOM
	 */
	[Style(name="verticalAlign",type="String")]

	/**
	 * Offsets the x position of the icon by a certain number of pixels.
	 * This does not affect the measurement of the button. The button will
	 * measure itself as if the icon were not offset from its original
	 * position.
	 *
	 * <p>The following example offsets the x position of the button's icon
	 * by 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * button.iconOffsetX = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:iconOffsetY
	 */
	[Style(name="iconOffsetX",type="Number")]

	/**
	 * Offsets the y position of the icon by a certain number of pixels.
	 * This does not affect the measurement of the button. The button will
	 * measure itself as if the icon were not offset from its original
	 * position.
	 *
	 * <p>The following example offsets the y position of the button's icon
	 * by 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * button.iconOffsetY = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:iconOffsetX
	 */
	[Style(name="iconOffsetY",type="Number")]

	/**
	 * The location of the icon, relative to the label.
	 *
	 * <p>The following example positions the icon to the right of the
	 * label:</p>
	 *
	 * <listing version="3.0">
	 * button.label = "Click Me";
	 * button.defaultIcon = new Image( texture );
	 * button.iconPosition = RelativePosition.RIGHT;</listing>
	 *
	 * @default feathers.layout.RelativePosition.LEFT
	 *
	 * @see feathers.layout.RelativePosition#TOP
	 * @see feathers.layout.RelativePosition#RIGHT
	 * @see feathers.layout.RelativePosition#BOTTOM
	 * @see feathers.layout.RelativePosition#LEFT
	 * @see feathers.layout.RelativePosition#RIGHT_BASELINE
	 * @see feathers.layout.RelativePosition#LEFT_BASELINE
	 * @see feathers.layout.RelativePosition#MANUAL
	 */
	[Style(name="iconPosition",type="String")]

	/**
	 * Offsets the x position of the label by a certain number of pixels.
	 * This does not affect the measurement of the button. The button will
	 * measure itself as if the label were not offset from its original
	 * position.
	 *
	 * <p>The following example offsets the x position of the button's label
	 * by 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * button.labelOffsetX = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:labelOffsetY
	 */
	[Style(name="labelOffsetX",type="Number")]

	/**
	 * Offsets the y position of the label by a certain number of pixels.
	 * This does not affect the measurement of the button. The button will
	 * measure itself as if the label were not offset from its original
	 * position.
	 *
	 * <p>The following example offsets the y position of the button's label
	 * by 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * button.labelOffsetY = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:labelOffsetX
	 */
	[Style(name="labelOffsetY",type="Number")]

	/**
	 * If the value of the <code>gap</code> property is
	 * <code>Number.POSITIVE_INFINITY</code>, meaning that the gap will
	 * fill as much space as possible, the final calculated value will not be
	 * smaller than the value of the <code>minGap</code> property.
	 *
	 * <p>The following example ensures that the gap is never smaller than
	 * 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * button.gap = Number.POSITIVE_INFINITY;
	 * button.minGap = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:gap
	 */
	[Style(name="minGap",type="Number")]

	/**
	 * Quickly sets all padding properties to the same value. The
	 * <code>padding</code> getter always returns the value of
	 * <code>paddingTop</code>, but the other padding values may be
	 * different.
	 *
	 * <p>The following example gives the button 20 pixels of padding on all
	 * sides:</p>
	 *
	 * <listing version="3.0">
	 * button.padding = 20;</listing>
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
	 * The minimum space, in pixels, between the button's top edge and the
	 * button's content.
	 *
	 * <p>The following example gives the button 20 pixels of padding on the
	 * top edge only:</p>
	 *
	 * <listing version="3.0">
	 * button.paddingTop = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:padding
	 */
	[Style(name="paddingTop",type="Number")]

	/**
	 * The minimum space, in pixels, between the button's right edge and the
	 * button's content.
	 *
	 * <p>The following example gives the button 20 pixels of padding on the
	 * right edge only:</p>
	 *
	 * <listing version="3.0">
	 * button.paddingRight = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:padding
	 */
	[Style(name="paddingRight",type="Number")]

	/**
	 * The minimum space, in pixels, between the button's bottom edge and
	 * the button's content.
	 *
	 * <p>The following example gives the button 20 pixels of padding on the
	 * bottom edge only:</p>
	 *
	 * <listing version="3.0">
	 * button.paddingBottom = 20;</listing>
	 *
	 * @default 0
	 * 
	 * @see #style:padding
	 */
	[Style(name="paddingBottom",type="Number")]

	/**
	 * The minimum space, in pixels, between the button's left edge and the
	 * button's content.
	 *
	 * <p>The following example gives the button 20 pixels of padding on the
	 * left edge only:</p>
	 *
	 * <listing version="3.0">
	 * button.paddingLeft = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:padding
	 */
	[Style(name="paddingLeft",type="Number")]

	/**
	 * The button renders at this scale in the down state.
	 *
	 * <p>The following example scales the button in the down state:</p>
	 *
	 * <listing version="3.0">
	 * button.scaleWhenDown = 0.9;</listing>
	 *
	 * @default 1
	 * 
	 * @see #style:scaleWhenHovering
	 */
	[Style(name="scaleWhenDown",type="Number")]

	/**
	 * The button renders at this scale in the hover state.
	 *
	 * <p>The following example scales the button in the hover state:</p>
	 *
	 * <listing version="3.0">
	 * button.scaleWhenHovering = 0.9;</listing>
	 *
	 * @default 1
	 *
	 * @see #style:scaleWhenDown
	 */
	[Style(name="scaleWhenHovering",type="Number")]

	/**
	 * Dispatched when the button is pressed for a long time. The property
	 * <code>isLongPressEnabled</code> must be set to <code>true</code> before
	 * this event will be dispatched.
	 *
	 * <p>The following example enables long presses:</p>
	 *
	 * <listing version="3.0">
	 * button.isLongPressEnabled = true;
	 * button.addEventListener( FeathersEventType.LONG_PRESS, function( event:Event ):void
	 * {
	 *     // long press
	 * });</listing>
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
	 * @eventType feathers.events.FeathersEventType.LONG_PRESS
	 * @see #isLongPressEnabled
	 * @see #longPressDuration
	 */
	[Event(name="longPress",type="starling.events.Event")]

	/**
	 * A push button control that may be triggered when pressed and released.
	 *
	 * <p>The following example creates a button, gives it a label and listens
	 * for when the button is triggered:</p>
	 *
	 * <listing version="3.0">
	 * var button:Button = new Button();
	 * button.label = "Click Me";
	 * button.addEventListener( Event.TRIGGERED, button_triggeredHandler );
	 * this.addChild( button );</listing>
	 *
	 * @see ../../../help/button.html How to use the Feathers Button component
	 */
	public class Button extends BasicButton implements IFocusDisplayObject, ITextBaselineControl
	{
		/**
		 * @private
		 */
		private static const HELPER_POINT:Point = new Point();

		/**
		 * The default value added to the <code>styleNameList</code> of the label.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_LABEL:String = "feathers-button-label";

		/**
		 * An alternate style name to use with <code>Button</code> to allow a
		 * theme to give it a more prominent, "call-to-action" style. If a theme
		 * does not provide a style for a call-to-action button, the theme will
		 * automatically fall back to using the default button style.
		 *
		 * <p>An alternate style name should always be added to a component's
		 * <code>styleNameList</code> before the component is initialized. If
		 * the style name is added later, it will be ignored.</p>
		 *
		 * <p>In the following example, the call-to-action style is applied to
		 * a button:</p>
		 *
		 * <listing version="3.0">
		 * var button:Button = new Button();
		 * button.styleNameList.add( Button.ALTERNATE_STYLE_NAME_CALL_TO_ACTION_BUTTON );
		 * this.addChild( button );</listing>
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const ALTERNATE_STYLE_NAME_CALL_TO_ACTION_BUTTON:String = "feathers-call-to-action-button";

		/**
		 * An alternate style name to use with <code>Button</code> to allow a
		 * theme to give it a less prominent, "quiet" style. If a theme does not
		 * provide a style for a quiet button, the theme will automatically fall
		 * back to using the default button style.
		 *
		 * <p>An alternate style name should always be added to a component's
		 * <code>styleNameList</code> before the component is initialized. If
		 * the style name is added later, it will be ignored.</p>
		 *
		 * <p>In the following example, the quiet button style is applied to
		 * a button:</p>
		 *
		 * <listing version="3.0">
		 * var button:Button = new Button();
		 * button.styleNameList.add( Button.ALTERNATE_STYLE_NAME_QUIET_BUTTON );
		 * this.addChild( button );</listing>
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const ALTERNATE_STYLE_NAME_QUIET_BUTTON:String = "feathers-quiet-button";

		/**
		 * An alternate style name to use with <code>Button</code> to allow a
		 * theme to give it a highly prominent, "danger" style. An example would
		 * be a delete button or some other button that has a destructive action
		 * that cannot be undone if the button is triggered. If a theme does not
		 * provide a style for the danger button, the theme will automatically
		 * fall back to using the default button style.
		 *
		 * <p>An alternate style name should always be added to a component's
		 * <code>styleNameList</code> before the component is initialized. If
		 * the style name is added later, it will be ignored.</p>
		 *
		 * <p>In the following example, the danger button style is applied to
		 * a button:</p>
		 *
		 * <listing version="3.0">
		 * var button:Button = new Button();
		 * button.styleNameList.add( Button.ALTERNATE_STYLE_NAME_DANGER_BUTTON );
		 * this.addChild( button );</listing>
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const ALTERNATE_STYLE_NAME_DANGER_BUTTON:String = "feathers-danger-button";

		/**
		 * An alternate style name to use with <code>Button</code> to allow a
		 * theme to give it a "back button" style, perhaps with an arrow
		 * pointing backward. If a theme does not provide a style for a back
		 * button, the theme will automatically fall back to using the default
		 * button skin.
		 *
		 * <p>An alternate style name should always be added to a component's
		 * <code>styleNameList</code> before the component is initialized. If
		 * the style name is added later, it will be ignored.</p>
		 *
		 * <p>In the following example, the back button style is applied to
		 * a button:</p>
		 *
		 * <listing version="3.0">
		 * var button:Button = new Button();
		 * button.styleNameList.add( Button.ALTERNATE_STYLE_NAME_BACK_BUTTON );
		 * this.addChild( button );</listing>
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const ALTERNATE_STYLE_NAME_BACK_BUTTON:String = "feathers-back-button";

		/**
		 * An alternate style name to use with <code>Button</code> to allow a
		 * theme to give it a "forward" button style, perhaps with an arrow
		 * pointing forward. If a theme does not provide a style for a forward
		 * button, the theme will automatically fall back to using the default
		 * button style.
		 *
		 * <p>An alternate style name should always be added to a component's
		 * <code>styleNameList</code> before the component is initialized. If
		 * the style name is added later, it will be ignored.</p>
		 *
		 * <p>In the following example, the forward button style is applied to
		 * a button:</p>
		 *
		 * <listing version="3.0">
		 * var button:Button = new Button();
		 * button.styleNameList.add( Button.ALTERNATE_STYLE_NAME_FORWARD_BUTTON );
		 * this.addChild( button );</listing>
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const ALTERNATE_STYLE_NAME_FORWARD_BUTTON:String = "feathers-forward-button";
		
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.ButtonState.UP</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const STATE_UP:String = "up";
		
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.ButtonState.DOWN</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const STATE_DOWN:String = "down";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.ButtonState.HOVER</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const STATE_HOVER:String = "hover";
		
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.ButtonState.DISABLED</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const STATE_DISABLED:String = "disabled";
		
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.RelativePosition.TOP</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const ICON_POSITION_TOP:String = "top";
		
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.RelativePosition.RIGHT</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const ICON_POSITION_RIGHT:String = "right";
		
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.RelativePosition.BOTTOM</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const ICON_POSITION_BOTTOM:String = "bottom";
		
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.RelativePosition.LEFT</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const ICON_POSITION_LEFT:String = "left";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.RelativePosition.MANUAL</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const ICON_POSITION_MANUAL:String = "manual";
		
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.RelativePosition.LEFT_BASELINE</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const ICON_POSITION_LEFT_BASELINE:String = "leftBaseline";
		
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.RelativePosition.RIGHT_BASELINE</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const ICON_POSITION_RIGHT_BASELINE:String = "rightBaseline";
		
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.HorizontalAlign.LEFT</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const HORIZONTAL_ALIGN_LEFT:String = "left";
		
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.HorizontalAlign.CENTER</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const HORIZONTAL_ALIGN_CENTER:String = "center";
		
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.HorizontalAlign.RIGHT</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const HORIZONTAL_ALIGN_RIGHT:String = "right";
		
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.VerticalAlign.TOP</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const VERTICAL_ALIGN_TOP:String = "top";
		
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.VerticalAlign.MIDDLE</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const VERTICAL_ALIGN_MIDDLE:String = "middle";
		
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.VerticalAlign.BOTTOM</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const VERTICAL_ALIGN_BOTTOM:String = "bottom";

		/**
		 * The default <code>IStyleProvider</code> for all <code>Button</code>
		 * components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;
		
		/**
		 * Constructor.
		 */
		public function Button()
		{
			super();
			if(this._fontStylesSet === null)
			{
				this._fontStylesSet = new FontStylesSet();
				this._fontStylesSet.addEventListener(Event.CHANGE, fontStyles_changeHandler);
			}
		}

		/**
		 * The value added to the <code>styleNameList</code> of the label text
		 * renderer. This variable is <code>protected</code> so that sub-classes
		 * can customize the label text renderer style name in their
		 * constructors instead of using the default style name defined by
		 * <code>DEFAULT_CHILD_STYLE_NAME_LABEL</code>.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var labelStyleName:String = DEFAULT_CHILD_STYLE_NAME_LABEL;
		
		/**
		 * The text renderer for the button's label.
		 *
		 * <p>For internal use in subclasses.</p>
		 *
		 * @see #label
		 * @see #labelFactory
		 * @see #createLabel()
		 */
		protected var labelTextRenderer:ITextRenderer;
		
		/**
		 * The currently visible icon. The value will be <code>null</code> if
		 * there is no currently visible icon.
		 *
		 * <p>For internal use in subclasses.</p>
		 */
		protected var currentIcon:DisplayObject;

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return Button.globalStyleProvider;
		}

		/**
		 * @private
		 */
		protected var keyToTrigger:KeyToTrigger;

		/**
		 * @private
		 */
		protected var longPress:LongPress;

		/**
		 * @private
		 */
		protected var _scaleMatrix:Matrix;
		
		/**
		 * @private
		 */
		protected var _label:String = null;
		
		/**
		 * The text displayed on the button.
		 *
		 * <p>The following example gives the button some label text:</p>
		 *
		 * <listing version="3.0">
		 * button.label = "Click Me";</listing>
		 *
		 * @default null
		 */
		public function get label():String
		{
			return this._label;
		}
		
		/**
		 * @private
		 */
		public function set label(value:String):void
		{
			if(this._label == value)
			{
				return;
			}
			this._label = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _hasLabelTextRenderer:Boolean = true;

		/**
		 * Determines if the button's label text renderer is created or not.
		 * Useful for button sub-components that may not display text, like
		 * slider thumbs and tracks, or similar sub-components on scroll bars.
		 *
		 * <p>The following example removed the label text renderer:</p>
		 *
		 * <listing version="3.0">
		 * button.hasLabelTextRenderer = false;</listing>
		 *
		 * @default true
		 */
		public function get hasLabelTextRenderer():Boolean
		{
			return this._hasLabelTextRenderer;
		}

		/**
		 * @private
		 */
		public function set hasLabelTextRenderer(value:Boolean):void
		{
			if(this._hasLabelTextRenderer == value)
			{
				return;
			}
			this._hasLabelTextRenderer = value;
			this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
		}

		/**
		 * @private
		 */
		protected var _iconPosition:String = RelativePosition.LEFT;

		[Inspectable(type="String",enumeration="top,right,bottom,left,rightBaseline,leftBaseline,manual")]
		/**
		 * @private
		 */
		public function get iconPosition():String
		{
			return this._iconPosition;
		}

		/**
		 * @private
		 */
		public function set iconPosition(value:String):void
		{
			if(this._iconPosition === value)
			{
				return;
			}
			if(this.isStyleRestricted(arguments.callee))
			{
				return;
			}
			this.restrictStyle(arguments.callee);
			this._iconPosition = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _gap:Number = 0;

		/**
		 * @private
		 */
		public function get gap():Number
		{
			return this._gap;
		}

		/**
		 * @private
		 */
		public function set gap(value:Number):void
		{
			if(this._gap === value)
			{
				return;
			}
			if(this.isStyleRestricted(arguments.callee))
			{
				return;
			}
			this.restrictStyle(arguments.callee);
			this._gap = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _minGap:Number = 0;

		/**
		 * @private
		 */
		public function get minGap():Number
		{
			return this._minGap;
		}

		/**
		 * @private
		 */
		public function set minGap(value:Number):void
		{
			if(this._minGap === value)
			{
				return;
			}
			if(this.isStyleRestricted(arguments.callee))
			{
				return;
			}
			this.restrictStyle(arguments.callee);
			this._minGap = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _horizontalAlign:String = HorizontalAlign.CENTER;

		[Inspectable(type="String",enumeration="left,center,right")]
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
			if(this._horizontalAlign === value)
			{
				return;
			}
			if(this.isStyleRestricted(arguments.callee))
			{
				return;
			}
			this.restrictStyle(arguments.callee);
			this._horizontalAlign = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _verticalAlign:String = VerticalAlign.MIDDLE;

		[Inspectable(type="String",enumeration="top,middle,bottom")]
		/**
		 * @private
		 */
		public function get verticalAlign():String
		{
			return _verticalAlign;
		}

		/**
		 * @private
		 */
		public function set verticalAlign(value:String):void
		{
			if(this._verticalAlign === value)
			{
				return;
			}
			if(this.isStyleRestricted(arguments.callee))
			{
				return;
			}
			this.restrictStyle(arguments.callee);
			this._verticalAlign = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
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
			if(this._paddingTop === value)
			{
				return;
			}
			if(this.isStyleRestricted(arguments.callee))
			{
				return;
			}
			this.restrictStyle(arguments.callee);
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
			if(this._paddingRight === value)
			{
				return;
			}
			if(this.isStyleRestricted(arguments.callee))
			{
				return;
			}
			this.restrictStyle(arguments.callee);
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
			if(this._paddingBottom === value)
			{
				return;
			}
			if(this.isStyleRestricted(arguments.callee))
			{
				return;
			}
			this.restrictStyle(arguments.callee);
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
			if(this._paddingLeft === value)
			{
				return;
			}
			if(this.isStyleRestricted(arguments.callee))
			{
				return;
			}
			this.restrictStyle(arguments.callee);
			this._paddingLeft = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _labelOffsetX:Number = 0;

		/**
		 * @private
		 */
		public function get labelOffsetX():Number
		{
			return this._labelOffsetX;
		}

		/**
		 * @private
		 */
		public function set labelOffsetX(value:Number):void
		{
			if(this._labelOffsetX === value)
			{
				return;
			}
			if(this.isStyleRestricted(arguments.callee))
			{
				return;
			}
			this.restrictStyle(arguments.callee);
			this._labelOffsetX = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _labelOffsetY:Number = 0;

		/**
		 * @private
		 */
		public function get labelOffsetY():Number
		{
			return this._labelOffsetY;
		}

		/**
		 * @private
		 */
		public function set labelOffsetY(value:Number):void
		{
			if(this._labelOffsetY === value)
			{
				return;
			}
			if(this.isStyleRestricted(arguments.callee))
			{
				return;
			}
			this.restrictStyle(arguments.callee);
			this._labelOffsetY = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _iconOffsetX:Number = 0;

		/**
		 * @private
		 */
		public function get iconOffsetX():Number
		{
			return this._iconOffsetX;
		}

		/**
		 * @private
		 */
		public function set iconOffsetX(value:Number):void
		{
			if(this._iconOffsetX === value)
			{
				return;
			}
			if(this.isStyleRestricted(arguments.callee))
			{
				return;
			}
			this.restrictStyle(arguments.callee);
			this._iconOffsetX = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _iconOffsetY:Number = 0;

		/**
		 * @private
		 */
		public function get iconOffsetY():Number
		{
			return this._iconOffsetY;
		}

		/**
		 * @private
		 */
		public function set iconOffsetY(value:Number):void
		{
			if(this._iconOffsetY === value)
			{
				return;
			}
			if(this.isStyleRestricted(arguments.callee))
			{
				return;
			}
			this.restrictStyle(arguments.callee);
			this._iconOffsetY = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _stateToIconFunction:Function;

		/**
		 * DEPRECATED: Create a <code>feathers.skins.ImageSkin</code> instead,
		 * and pass to the <code>defaultIcon</code> property.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public function get stateToIconFunction():Function
		{
			return this._stateToIconFunction;
		}

		/**
		 * @private
		 */
		public function set stateToIconFunction(value:Function):void
		{
			if(this._stateToIconFunction == value)
			{
				return;
			}
			this._stateToIconFunction = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _stateToLabelPropertiesFunction:Function;

		/**
		 * DEPRECATED: Call the <code>setFontStylesForState()</code> function
		 * with the appropriate <code>ButtonState</code> constant and pass in a
		 * <code>starling.text.TextFormat</code> object.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 * 
		 * @see #setFontStylesForState()
		 * @see feathers.controls.ButtonState
		 */
		public function get stateToLabelPropertiesFunction():Function
		{
			return this._stateToLabelPropertiesFunction;
		}

		/**
		 * @private
		 */
		public function set stateToLabelPropertiesFunction(value:Function):void
		{
			if(this._stateToLabelPropertiesFunction == value)
			{
				return;
			}
			this._stateToLabelPropertiesFunction = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		/**
		 * The skin used for the button's up state. If <code>null</code>, then
		 * <code>defaultSkin</code> is used instead.
		 *
		 * <p>This property will be ignored if a function is passed to the
		 * <code>stateToSkinFunction</code> property.</p>
		 *
		 * <p>The following example gives the button a skin for the up state:</p>
		 *
		 * <listing version="3.0">
		 * button.upSkin = new Image( texture );</listing>
		 *
		 * @default null
		 * 
		 * @see #defaultSkin
		 * @see #setSkinForState()
		 * @see feathers.controls.ButtonState.UP
		 */
		public function get upSkin():DisplayObject
		{
			return this.getSkinForState(ButtonState.UP);
		}
		
		/**
		 * @private
		 */
		public function set upSkin(value:DisplayObject):void
		{
			this.setSkinForState(ButtonState.UP, value);
		}
		
		/**
		 * The skin used for the button's down state. If <code>null</code>, then
		 * <code>defaultSkin</code> is used instead.
		 *
		 * <p>This property will be ignored if a function is passed to the
		 * <code>stateToSkinFunction</code> property.</p>
		 *
		 * <p>The following example gives the button a skin for the down state:</p>
		 *
		 * <listing version="3.0">
		 * button.downSkin = new Image( texture );</listing>
		 *
		 * @default null
		 * 
		 * @see #defaultSkin
		 * @see #setSkinForState()
		 * @see feathers.controls.ButtonState.DOWN
		 */
		public function get downSkin():DisplayObject
		{
			return this.getSkinForState(ButtonState.DOWN);
		}
		
		/**
		 * @private
		 */
		public function set downSkin(value:DisplayObject):void
		{
			this.setSkinForState(ButtonState.DOWN, value);
		}

		/**
		 * The skin used for the button's hover state. If <code>null</code>, then
		 * <code>defaultSkin</code> is used instead.
		 *
		 * <p>This property will be ignored if a function is passed to the
		 * <code>stateToSkinFunction</code> property.</p>
		 *
		 * <p>The following example gives the button a skin for the hover state:</p>
		 *
		 * <listing version="3.0">
		 * button.hoverSkin = new Image( texture );</listing>
		 *
		 * @default null
		 *
		 * @see #defaultSkin
		 * @see #setSkinForState()
		 * @see feathers.controls.ButtonState.HOVER
		 */
		public function get hoverSkin():DisplayObject
		{
			return this.getSkinForState(ButtonState.HOVER);
		}

		/**
		 * @private
		 */
		public function set hoverSkin(value:DisplayObject):void
		{
			this.setSkinForState(ButtonState.HOVER, value);
		}
		
		/**
		 * The skin used for the button's disabled state. If <code>null</code>,
		 * then <code>defaultSkin</code> is used instead.
		 *
		 * <p>This property will be ignored if a function is passed to the
		 * <code>stateToSkinFunction</code> property.</p>
		 *
		 * <p>The following example gives the button a skin for the disabled state:</p>
		 *
		 * <listing version="3.0">
		 * button.disabledSkin = new Image( texture );</listing>
		 *
		 * @default null
		 * 
		 * @see #defaultSkin
		 * @see #setSkinForState()
		 * @see feathers.controls.ButtonState.DISABLED
		 */
		public function get disabledSkin():DisplayObject
		{
			return this.getSkinForState(ButtonState.DISABLED);
		}
		
		/**
		 * @private
		 */
		public function set disabledSkin(value:DisplayObject):void
		{
			this.setSkinForState(ButtonState.DISABLED, value);
		}

		/**
		 * @private
		 */
		protected var _stateToSkinFunction:Function;

		/**
		 * DEPRECATED: Create a <code>feathers.skins.ImageSkin</code> instead,
		 * and pass to the <code>defaultSkin</code> property.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public function get stateToSkinFunction():Function
		{
			return this._stateToSkinFunction;
		}

		/**
		 * @private
		 */
		public function set stateToSkinFunction(value:Function):void
		{
			if(this._stateToSkinFunction == value)
			{
				return;
			}
			this._stateToSkinFunction = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _fontStylesSet:FontStylesSet;

		/**
		 * @private
		 */
		public function get fontStyles():TextFormat
		{
			return this._fontStylesSet.format;
		}

		/**
		 * @private
		 */
		public function set fontStyles(value:TextFormat):void
		{
			if(this.isStyleRestricted(arguments.callee))
			{
				return;
			}
			this.restrictStyle(arguments.callee);
			this._fontStylesSet.format = value;
		}

		/**
		 * @private
		 */
		public function get disabledFontStyles():TextFormat
		{
			return this._fontStylesSet.disabledFormat;
		}

		/**
		 * @private
		 */
		public function set disabledFontStyles(value:TextFormat):void
		{
			if(this.isStyleRestricted(arguments.callee))
			{
				return;
			}
			this.restrictStyle(arguments.callee);
			this._fontStylesSet.disabledFormat = value;
		}

		/**
		 * @private
		 */
		protected var _labelFactory:Function;

		/**
		 * A function used to instantiate the button's label text renderer
		 * sub-component. By default, the button will use the global text
		 * renderer factory, <code>FeathersControl.defaultTextRendererFactory()</code>,
		 * to create the label text renderer. The label text renderer must be an
		 * instance of <code>ITextRenderer</code>. To change properties on the
		 * label text renderer, see <code>defaultLabelProperties</code> and the
		 * other "<code>LabelProperties</code>" properties for each button
		 * state.
		 *
		 * <p>The factory should have the following function signature:</p>
		 * <pre>function():ITextRenderer</pre>
		 *
		 * <p>The following example gives the button a custom factory for the
		 * label text renderer:</p>
		 *
		 * <listing version="3.0">
		 * button.labelFactory = function():ITextRenderer
		 * {
		 *     return new TextFieldTextRenderer();
		 * }</listing>
		 *
		 * @default null
		 *
		 * @see feathers.core.ITextRenderer
		 * @see feathers.core.FeathersControl#defaultTextRendererFactory
		 */
		public function get labelFactory():Function
		{
			return this._labelFactory;
		}

		/**
		 * @private
		 */
		public function set labelFactory(value:Function):void
		{
			if(this._labelFactory == value)
			{
				return;
			}
			this._labelFactory = value;
			this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
		}

		/**
		 * @private
		 */
		protected var _customLabelStyleName:String;

		/**
		 * A style name to add to the button's label text renderer
		 * sub-component. Typically used by a theme to provide different styles
		 * to different buttons.
		 *
		 * <p>In the following example, a custom label style name is passed to
		 * the button:</p>
		 *
		 * <listing version="3.0">
		 * button.customLabelStyleName = "my-custom-button-label";</listing>
		 *
		 * <p>In your theme, you can target this sub-component style name to
		 * provide different styles than the default:</p>
		 *
		 * <listing version="3.0">
		 * getStyleProviderForClass( BitmapFontTextRenderer ).setFunctionForStyleName( "my-custom-button-label", setCustomButtonLabelStyles );</listing>
		 *
		 * @default null
		 *
		 * @see #DEFAULT_CHILD_STYLE_NAME_LABEL
		 * @see feathers.core.FeathersControl#styleNameList
		 * @see #labelFactory
		 */
		public function get customLabelStyleName():String
		{
			return this._customLabelStyleName;
		}

		/**
		 * @private
		 */
		public function set customLabelStyleName(value:String):void
		{
			if(this._customLabelStyleName == value)
			{
				return;
			}
			this._customLabelStyleName = value;
			this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
		}

		/**
		 * @private
		 */
		protected var _defaultLabelProperties:PropertyProxy;
		
		/**
		 * An object that stores properties for the button's label text renderer
		 * when no specific properties are defined for the button's current
		 * state, and the properties will be passed down to the label text
		 * renderer when the button validates. The available properties depend
		 * on which <code>ITextRenderer</code> implementation is returned by
		 * <code>labelFactory</code>. Refer to
		 * <a href="../core/ITextRenderer.html"><code>feathers.core.ITextRenderer</code></a>
		 * for a list of available text renderer implementations.
		 *
		 * <p>The following example gives the button default label properties to
		 * use for all states when no specific label properties are available
		 * (this example assumes that the label text renderer is a
		 * <code>BitmapFontTextRenderer</code>):</p>
		 *
		 * <listing version="3.0">
		 * button.defaultLabelProperties.textFormat = new BitmapFontTextFormat( bitmapFont );
		 * button.defaultLabelProperties.wordWrap = true;</listing>
		 *
		 * @default null
		 *
		 * @see feathers.core.ITextRenderer
		 */
		public function get defaultLabelProperties():Object
		{
			if(this._defaultLabelProperties === null)
			{
				this._defaultLabelProperties = new PropertyProxy(childProperties_onChange);
			}
			return this._defaultLabelProperties;
		}
		
		/**
		 * @private
		 */
		public function set defaultLabelProperties(value:Object):void
		{
			if(!(value is PropertyProxy))
			{
				value = PropertyProxy.fromObject(value);
			}
			if(this._defaultLabelProperties !== null)
			{
				this._defaultLabelProperties.removeOnChangeCallback(childProperties_onChange);
			}
			this._defaultLabelProperties = PropertyProxy(value);
			if(this._defaultLabelProperties !== null)
			{
				this._defaultLabelProperties.addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _stateToLabelProperties:Object = {};
		
		/**
		 * DEPRECATED: Use the <code>fontStyles</code> property, or call the
		 * <code>setFontStylesForState()</code> function with
		 * <code>ButtonState.UP</code> and pass in a
		 * <code>starling.text.TextFormat</code> object instead.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 * 
		 * @see #fontStyles
		 * @see #setFontStylesForState()
		 * @see feathers.controls.ButtonState.UP
		 */
		public function get upLabelProperties():Object
		{
			var value:PropertyProxy = PropertyProxy(this._stateToLabelProperties[ButtonState.UP]);
			if(!value)
			{
				value = new PropertyProxy(childProperties_onChange);
				this._stateToLabelProperties[ButtonState.UP] = value;
			}
			return value;
		}
		
		/**
		 * @private
		 */
		public function set upLabelProperties(value:Object):void
		{
			if(!(value is PropertyProxy))
			{
				value = PropertyProxy.fromObject(value);
			}
			var oldValue:PropertyProxy = PropertyProxy(this._stateToLabelProperties[ButtonState.UP]);
			if(oldValue)
			{
				oldValue.removeOnChangeCallback(childProperties_onChange);
			}
			this._stateToLabelProperties[ButtonState.UP] = value;
			if(value)
			{
				PropertyProxy(value).addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		/**
		 * DEPRECATED: Call the <code>setFontStylesForState()</code> function
		 * with <code>ButtonState.DOWN</code> and pass in a
		 * <code>starling.text.TextFormat</code> object instead.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 * 
		 * @see #setFontStylesForState()
		 * @see feathers.controls.ButtonState.DOWN
		 */
		public function get downLabelProperties():Object
		{
			var value:PropertyProxy = PropertyProxy(this._stateToLabelProperties[ButtonState.DOWN]);
			if(!value)
			{
				value = new PropertyProxy(childProperties_onChange);
				this._stateToLabelProperties[ButtonState.DOWN] = value;
			}
			return value;
		}
		
		/**
		 * @private
		 */
		public function set downLabelProperties(value:Object):void
		{
			if(!(value is PropertyProxy))
			{
				value = PropertyProxy.fromObject(value);
			}
			var oldValue:PropertyProxy = PropertyProxy(this._stateToLabelProperties[ButtonState.DOWN]);
			if(oldValue)
			{
				oldValue.removeOnChangeCallback(childProperties_onChange);
			}
			this._stateToLabelProperties[ButtonState.DOWN] = value;
			if(value)
			{
				PropertyProxy(value).addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * DEPRECATED: Call the <code>setFontStylesForState()</code> function
		 * with <code>ButtonState.HOVER</code> and pass in a
		 * <code>starling.text.TextFormat</code> object instead.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 *
		 * @see #setFontStylesForState()
		 * @see feathers.controls.ButtonState.HOVER
		 */
		public function get hoverLabelProperties():Object
		{
			var value:PropertyProxy = PropertyProxy(this._stateToLabelProperties[ButtonState.HOVER]);
			if(!value)
			{
				value = new PropertyProxy(childProperties_onChange);
				this._stateToLabelProperties[ButtonState.HOVER] = value;
			}
			return value;
		}

		/**
		 * @private
		 */
		public function set hoverLabelProperties(value:Object):void
		{
			if(!(value is PropertyProxy))
			{
				value = PropertyProxy.fromObject(value);
			}
			var oldValue:PropertyProxy = PropertyProxy(this._stateToLabelProperties[ButtonState.HOVER]);
			if(oldValue)
			{
				oldValue.removeOnChangeCallback(childProperties_onChange);
			}
			this._stateToLabelProperties[ButtonState.HOVER] = value;
			if(value)
			{
				PropertyProxy(value).addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		/**
		 * DEPRECATED: Use the <code>disabledFontStyles</code> property, or call
		 * the <code>setFontStylesForState()</code> function with
		 * <code>ButtonState.DISABLED</code> and pass in a
		 * <code>starling.text.TextFormat</code> object instead.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 *
		 * @see #setFontStylesForState()
		 * @see feathers.controls.ButtonState.DISABLED
		 */
		public function get disabledLabelProperties():Object
		{
			var value:PropertyProxy = PropertyProxy(this._stateToLabelProperties[ButtonState.DISABLED]);
			if(!value)
			{
				value = new PropertyProxy(childProperties_onChange);
				this._stateToLabelProperties[ButtonState.DISABLED] = value;
			}
			return value;
		}
		
		/**
		 * @private
		 */
		public function set disabledLabelProperties(value:Object):void
		{
			if(!(value is PropertyProxy))
			{
				value = PropertyProxy.fromObject(value);
			}
			var oldValue:PropertyProxy = PropertyProxy(this._stateToLabelProperties[ButtonState.DISABLED]);
			if(oldValue)
			{
				oldValue.removeOnChangeCallback(childProperties_onChange);
			}
			this._stateToLabelProperties[ButtonState.DISABLED] = value;
			if(value)
			{
				PropertyProxy(value).addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _defaultIcon:DisplayObject;

		/**
		 * @private
		 */
		public function get defaultIcon():DisplayObject
		{
			return this._defaultIcon;
		}

		/**
		 * @private
		 */
		public function set defaultIcon(value:DisplayObject):void
		{
			if(this._defaultIcon === value)
			{
				return;
			}
			if(this.isStyleRestricted(arguments.callee))
			{
				if(value !== null)
				{
					value.dispose();
				}
				return;
			}
			this.restrictStyle(arguments.callee);
			if(this._defaultIcon !== null &&
				this.currentIcon === this._defaultIcon)
			{
				//if this icon needs to be reused somewhere else, we need to
				//properly clean it up
				this.removeCurrentIcon(this._defaultIcon);
				this.currentIcon = null;
			}
			this._defaultIcon = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _stateToIcon:Object = {};

		/**
		 * The icon used for the button's up state. If <code>null</code>, then
		 * <code>defaultIcon</code> is used instead.
		 *
		 * <p>This property will be ignored if a function is passed to the
		 * <code>stateToIconFunction</code> property.</p>
		 *
		 * <p>The following example gives the button an icon for the up state:</p>
		 *
		 * <listing version="3.0">
		 * button.upIcon = new Image( texture );</listing>
		 *
		 * @default null
		 * 
		 * @see #defaultIcon
		 * @see #setIconForState()
		 * @see feathers.controls.ButtonState.UP
		 */
		public function get upIcon():DisplayObject
		{
			return this.getIconForState(ButtonState.UP);
		}

		/**
		 * @private
		 */
		public function set upIcon(value:DisplayObject):void
		{
			return this.setIconForState(ButtonState.UP, value);
		}

		/**
		 * The icon used for the button's down state. If <code>null</code>, then
		 * <code>defaultIcon</code> is used instead.
		 *
		 * <p>This property will be ignored if a function is passed to the
		 * <code>stateToIconFunction</code> property.</p>
		 *
		 * <p>The following example gives the button an icon for the down state:</p>
		 *
		 * <listing version="3.0">
		 * button.downIcon = new Image( texture );</listing>
		 *
		 * @default null
		 * 
		 * @see #defaultIcon
		 * @see #setIconForState()
		 * @see feathers.controls.ButtonState.DOWN
		 */
		public function get downIcon():DisplayObject
		{
			return this.getIconForState(ButtonState.DOWN);
		}

		/**
		 * @private
		 */
		public function set downIcon(value:DisplayObject):void
		{
			return this.setIconForState(ButtonState.DOWN, value);
		}

		/**
		 * The icon used for the button's hover state. If <code>null</code>, then
		 * <code>defaultIcon</code> is used instead.
		 *
		 * <p>This property will be ignored if a function is passed to the
		 * <code>stateToIconFunction</code> property.</p>
		 *
		 * <p>The following example gives the button an icon for the hover state:</p>
		 *
		 * <listing version="3.0">
		 * button.hoverIcon = new Image( texture );</listing>
		 *
		 * @default null
		 *
		 * @see #defaultIcon
		 * @see #setIconForState()
		 * @see feathers.controls.ButtonState.HOVER
		 */
		public function get hoverIcon():DisplayObject
		{
			return this.getIconForState(ButtonState.HOVER);
		}

		/**
		 * @private
		 */
		public function set hoverIcon(value:DisplayObject):void
		{
			return this.setIconForState(ButtonState.HOVER, value);
		}

		/**
		 * The icon used for the button's disabled state. If <code>null</code>, then
		 * <code>defaultIcon</code> is used instead.
		 *
		 * <p>This property will be ignored if a function is passed to the
		 * <code>stateToIconFunction</code> property.</p>
		 *
		 * <p>The following example gives the button an icon for the disabled state:</p>
		 *
		 * <listing version="3.0">
		 * button.disabledIcon = new Image( texture );</listing>
		 *
		 * @default null
		 * 
		 * @see #defaultIcon
		 * @see #setIconForState()
		 * @see feathers.controls.ButtonState.DISABLED
		 */
		public function get disabledIcon():DisplayObject
		{
			return this.getIconForState(ButtonState.DISABLED);
		}

		/**
		 * @private
		 */
		public function set disabledIcon(value:DisplayObject):void
		{
			return this.setIconForState(ButtonState.DISABLED, value);
		}

		/**
		 * @private
		 */
		protected var _longPressDuration:Number = 0.5;

		/**
		 * The duration, in seconds, of a long press.
		 *
		 * <p>The following example changes the long press duration to one full second:</p>
		 *
		 * <listing version="3.0">
		 * button.longPressDuration = 1.0;</listing>
		 *
		 * @default 0.5
		 *
		 * @see #event:longPress
		 * @see #isLongPressEnabled
		 */
		public function get longPressDuration():Number
		{
			return this._longPressDuration;
		}

		/**
		 * @private
		 */
		public function set longPressDuration(value:Number):void
		{
			if(this._longPressDuration === value)
			{
				return;
			}
			this._longPressDuration = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _isLongPressEnabled:Boolean = false;

		/**
		 * Determines if <code>FeathersEventType.LONG_PRESS</code> will be
		 * dispatched.
		 *
		 * <p>The following example enables long presses:</p>
		 *
		 * <listing version="3.0">
		 * button.isLongPressEnabled = true;
		 * button.addEventListener( FeathersEventType.LONG_PRESS, function( event:Event ):void
		 * {
		 *     // long press
		 * });</listing>
		 *
		 * @default false
		 *
		 * @see #event:longPress
		 * @see #longPressDuration
		 */
		public function get isLongPressEnabled():Boolean
		{
			return this._isLongPressEnabled;
		}

		/**
		 * @private
		 */
		public function set isLongPressEnabled(value:Boolean):void
		{
			if(this._isLongPressEnabled === value)
			{
				return;
			}
			this._isLongPressEnabled = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _scaleWhenDown:Number = 1;

		/**
		 * @private
		 */
		public function get scaleWhenDown():Number
		{
			return this._scaleWhenDown;
		}

		/**
		 * @private
		 */
		public function set scaleWhenDown(value:Number):void
		{
			if(this._scaleWhenDown === value)
			{
				return;
			}
			if(this.isStyleRestricted(arguments.callee))
			{
				return;
			}
			this.restrictStyle(arguments.callee);
			this._scaleWhenDown = value;
		}

		/**
		 * @private
		 */
		protected var _scaleWhenHovering:Number = 1;

		/**
		 * @private
		 */
		public function get scaleWhenHovering():Number
		{
			return this._scaleWhenHovering;
		}

		/**
		 * @private
		 */
		public function set scaleWhenHovering(value:Number):void
		{
			if(this._scaleWhenHovering === value)
			{
				return;
			}
			if(this.isStyleRestricted(arguments.callee))
			{
				return;
			}
			this.restrictStyle(arguments.callee);
			this._scaleWhenHovering = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get baseline():Number
		{
			if(!this.labelTextRenderer)
			{
				return this.scaledActualHeight;
			}
			return this.scaleY * (this.labelTextRenderer.y + this.labelTextRenderer.baseline);
		}

		/**
		 * @private
		 */
		protected var _ignoreIconResizes:Boolean = false;

		/**
		 * @private
		 */
		override public function render(painter:Painter):void
		{
			var scale:Number = 1;
			if(this._currentState === ButtonState.DOWN)
			{
				scale = this._scaleWhenDown;
			}
			else if(this._currentState === ButtonState.HOVER)
			{
				scale = this._scaleWhenHovering;
			}
			if(scale !== 1)
			{
				if(this._scaleMatrix === null)
				{
					this._scaleMatrix = new Matrix();
				}
				else
				{
					this._scaleMatrix.identity();
				}
				this._scaleMatrix.translate(Math.round((1 - scale) / 2 * this.actualWidth),
					Math.round((1 - scale) / 2 * this.actualHeight));
				this._scaleMatrix.scale(scale, scale);
				painter.state.transformModelviewMatrix(this._scaleMatrix);
			}
			super.render(painter);
		}

		/**
		 * @private
		 */
		override public function dispose():void
		{
			//we don't dispose it if the button is the parent because it'll
			//already get disposed in super.dispose()
			if(this._defaultIcon !== null && this._defaultIcon.parent !== this)
			{
				this._defaultIcon.dispose();
			}
			for(var state:String in this._stateToIcon)
			{
				var icon:DisplayObject = this._stateToIcon[state] as DisplayObject;
				if(icon !== null && icon.parent !== this)
				{
					icon.dispose();
				}
			}
			super.dispose();
		}

		/**
		 * Gets the font styles to be used to display the button's text when the
		 * button's <code>currentState</code> property matches the specified
		 * state value.
		 *
		 * <p>If font styles are not defined for a specific state, returns
		 * <code>null</code>.</p>
		 * 
		 * @see http://doc.starling-framework.org/current/starling/text/TextFormat.html starling.text.TextFormat
		 * @see #setFontStylesForState()
		 * @see #fontStyles
		 */
		public function getFontStylesForState(state:String):TextFormat
		{
			if(this._fontStylesSet === null)
			{
				return null;
			}
			return this._fontStylesSet.getFormatForState(state);
		}

		/**
		 * Sets the font styles to be used to display the button's text when the
		 * button's <code>currentState</code> property matches the specified
		 * state value.
		 *
		 * <p>If font styles are not defined for a specific state, the value of
		 * the <code>fontStyles</code> property will be used instead.</p>
		 * 
		 * <p>Note: if the text renderer has been customized with advanced font
		 * formatting, it may override the values specified with
		 * <code>setFontStylesForState()</code> and properties like
		 * <code>fontStyles</code> and <code>disabledFontStyles</code>.</p>
		 *
		 * @see http://doc.starling-framework.org/current/starling/text/TextFormat.html starling.text.TextFormat
		 * @see #fontStyles
		 */
		public function setFontStylesForState(state:String, format:TextFormat):void
		{
			this._fontStylesSet.setFormatForState(state, format);
		}

		/**
		 * Gets the icon to be used by the button when the button's
		 * <code>currentState</code> property matches the specified state value.
		 *
		 * <p>If a icon is not defined for a specific state, returns
		 * <code>null</code>.</p>
		 *
		 * @see #setIconForState()
		 */
		public function getIconForState(state:String):DisplayObject
		{
			return this._stateToIcon[state] as DisplayObject;
		}

		/**
		 * Sets the icon to be used by the button when the button's
		 * <code>currentState</code> property matches the specified state value.
		 *
		 * <p>If an icon is not defined for a specific state, the value of the
		 * <code>defaultIcon</code> property will be used instead.</p>
		 *
		 * @see #defaultIcon
		 * @see #getIconForState()
		 * @see feathers.controls.ButtonState
		 */
		public function setIconForState(state:String, icon:DisplayObject):void
		{
			var key:String = "setIconForState--" + state;
			if(this.isStyleRestricted(key))
			{
				if(icon !== null)
				{
					icon.dispose();
				}
				return;
			}
			this.restrictStyle(key);
			var oldIcon:DisplayObject = this._stateToIcon[state] as DisplayObject;
			if(oldIcon !== null &&
				this.currentIcon === oldIcon)
			{
				//if this icon needs to be reused somewhere else, we need to
				//properly clean it up
				this.removeCurrentIcon(oldIcon);
				this.currentIcon = null;
			}
			if(icon !== null)
			{
				this._stateToIcon[state] = icon;
			}
			else
			{
				delete this._stateToIcon[state];
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		override protected function initialize():void
		{
			super.initialize();
			if(!this.keyToTrigger)
			{
				this.keyToTrigger = new KeyToTrigger(this);
			}
			if(!this.longPress)
			{
				this.longPress = new LongPress(this);
				this.longPress.tapToTrigger = this.tapToTrigger;
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
			var textRendererInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_TEXT_RENDERER);
			var focusInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_FOCUS);

			if(textRendererInvalid)
			{
				this.createLabel();
			}
			
			if(textRendererInvalid || stateInvalid || dataInvalid)
			{
				this.refreshLabel();
			}

			if(stylesInvalid || stateInvalid)
			{
				this.refreshLongPressEvents();
				this.refreshIcon();
			}

			//most components don't need to check the state before passing
			//properties to a child component, but button is an exception
			if(textRendererInvalid || stylesInvalid || stateInvalid)
			{
				this.refreshLabelStyles();
			}

			super.draw();
			
			if(textRendererInvalid || stylesInvalid || stateInvalid || dataInvalid || sizeInvalid)
			{
				this.layoutContent();
			}

			if(sizeInvalid || focusInvalid)
			{
				this.refreshFocusIndicator();
			}
		}

		/**
		 * @private
		 */
		override protected function autoSizeIfNeeded():Boolean
		{
			var needsWidth:Boolean = this._explicitWidth !== this._explicitWidth; //isNaN
			var needsHeight:Boolean = this._explicitHeight !== this._explicitHeight; //isNaN
			var needsMinWidth:Boolean = this._explicitMinWidth !== this._explicitMinWidth; //isNaN
			var needsMinHeight:Boolean = this._explicitMinHeight !== this._explicitMinHeight; //isNaN
			if(!needsWidth && !needsHeight && !needsMinWidth && !needsMinHeight)
			{
				return false;
			}
			
			var labelRenderer:ITextRenderer = null;
			if(this._label !== null && this.labelTextRenderer)
			{
				labelRenderer = this.labelTextRenderer;
				this.refreshMaxLabelSize(true);
				this.labelTextRenderer.measureText(HELPER_POINT);
			}
			
			var adjustedGap:Number = this._gap;
			if(adjustedGap === Number.POSITIVE_INFINITY)
			{
				adjustedGap = this._minGap;
			}

			resetFluidChildDimensionsForMeasurement(this.currentSkin,
				this._explicitWidth, this._explicitHeight,
				this._explicitMinWidth, this._explicitMinHeight,
				this._explicitMaxWidth, this._explicitMaxHeight,
				this._explicitSkinWidth, this._explicitSkinHeight,
				this._explicitSkinMinWidth, this._explicitSkinMinHeight,
				this._explicitSkinMaxWidth, this._explicitSkinMaxHeight);
			var measureSkin:IMeasureDisplayObject = this.currentSkin as IMeasureDisplayObject;
			
			if(this.currentIcon is IValidating)
			{
				IValidating(this.currentIcon).validate();
			}
			if(this.currentSkin is IValidating)
			{
				IValidating(this.currentSkin).validate();
			}
			
			var newMinWidth:Number = this._explicitMinWidth;
			if(needsMinWidth)
			{
				if(labelRenderer !== null)
				{
					newMinWidth = HELPER_POINT.x;
				}
				else
				{
					newMinWidth = 0;
				}
				if(this.currentIcon !== null)
				{
					if(labelRenderer !== null) //both label and icon
					{
						if(this._iconPosition !== RelativePosition.TOP && this._iconPosition !== RelativePosition.BOTTOM &&
							this._iconPosition !== RelativePosition.MANUAL)
						{
							newMinWidth += adjustedGap;
							if(this.currentIcon is IFeathersControl)
							{
								newMinWidth += IFeathersControl(this.currentIcon).minWidth;
							}
							else
							{
								newMinWidth += this.currentIcon.width;
							}
						}
						else //top, bottom, or manual
						{
							if(this.currentIcon is IFeathersControl)
							{
								var iconMinWidth:Number = IFeathersControl(this.currentIcon).minWidth;
								if(iconMinWidth > newMinWidth)
								{
									newMinWidth = iconMinWidth;
								}
							}
							else if(this.currentIcon.width > newMinWidth)
							{
								newMinWidth = this.currentIcon.width;
							}
						}
					}
					else //no label
					{
						if(this.currentIcon is IFeathersControl)
						{
							newMinWidth = IFeathersControl(this.currentIcon).minWidth;
						}
						else
						{
							newMinWidth = this.currentIcon.width;
						}
					}
				}
				newMinWidth += this._paddingLeft + this._paddingRight;
				if(this.currentSkin !== null)
				{
					if(measureSkin !== null)
					{
						if(measureSkin.minWidth > newMinWidth)
						{
							newMinWidth = measureSkin.minWidth;
						}
					}
					else if(this._explicitSkinMinWidth > newMinWidth)
					{
						newMinWidth = this._explicitSkinMinWidth;
					}
				}
			}

			var newMinHeight:Number = this._explicitMinHeight;
			if(needsMinHeight)
			{
				if(labelRenderer !== null)
				{
					newMinHeight = HELPER_POINT.y;
				}
				else
				{
					newMinHeight = 0;
				}
				if(this.currentIcon !== null)
				{
					if(labelRenderer !== null) //both label and icon
					{
						if(this._iconPosition === RelativePosition.TOP || this._iconPosition === RelativePosition.BOTTOM)
						{
							newMinHeight += adjustedGap;
							if(this.currentIcon is IFeathersControl)
							{
								newMinHeight += IFeathersControl(this.currentIcon).minHeight;
							}
							else
							{
								newMinHeight += this.currentIcon.height;
							}
						}
						else //left, right, manual
						{
							if(this.currentIcon is IFeathersControl)
							{
								var iconMinHeight:Number = IFeathersControl(this.currentIcon).minHeight;
								if(iconMinHeight > newMinHeight)
								{
									newMinHeight = iconMinHeight;
								}
							}
							else if(this.currentIcon.height > newMinHeight)
							{
								newMinHeight = this.currentIcon.height;
							}
						}
					}
					else //no label
					{
						if(this.currentIcon is IFeathersControl)
						{
							newMinHeight = IFeathersControl(this.currentIcon).minHeight;
						}
						else
						{
							newMinHeight = this.currentIcon.height;
						}
					}
				}
				newMinHeight += this._paddingTop + this._paddingBottom;
				if(this.currentSkin !== null)
				{
					if(measureSkin !== null)
					{
						if(measureSkin.minHeight > newMinHeight)
						{
							newMinHeight = measureSkin.minHeight;
						}
					}
					else if(this._explicitSkinMinHeight > newMinHeight)
					{
						newMinHeight = this._explicitSkinMinHeight;
					}
				}
			}
			
			var newWidth:Number = this._explicitWidth;
			if(needsWidth)
			{
				if(labelRenderer !== null)
				{
					newWidth = HELPER_POINT.x;
				}
				else
				{
					newWidth = 0;
				}
				if(this.currentIcon !== null)
				{
					if(labelRenderer !== null) //both label and icon
					{
						if(this._iconPosition !== RelativePosition.TOP && this._iconPosition !== RelativePosition.BOTTOM &&
							this._iconPosition !== RelativePosition.MANUAL)
						{
							newWidth += adjustedGap + this.currentIcon.width;
						}
						else if(this.currentIcon.width > newWidth) //top, bottom, or manual
						{
							newWidth = this.currentIcon.width;
						}
					}
					else //no label
					{
						newWidth = this.currentIcon.width;
					}
				}
				newWidth += this._paddingLeft + this._paddingRight;
				if(this.currentSkin !== null &&
					this.currentSkin.width > newWidth)
				{
					newWidth = this.currentSkin.width;
				}
			}

			var newHeight:Number = this._explicitHeight;
			if(needsHeight)
			{
				if(labelRenderer !== null)
				{
					newHeight = HELPER_POINT.y;
				}
				else
				{
					newHeight = 0;
				}
				if(this.currentIcon !== null)
				{
					if(labelRenderer !== null) //both label and icon
					{
						if(this._iconPosition === RelativePosition.TOP || this._iconPosition === RelativePosition.BOTTOM)
						{
							newHeight += adjustedGap + this.currentIcon.height;
						}
						else if(this.currentIcon.height > newHeight) //left, right, manual
						{
							newHeight = this.currentIcon.height;
						}
					}
					else //no label
					{
						newHeight = this.currentIcon.height;
					}
				}
				newHeight += this._paddingTop + this._paddingBottom;
				if(this.currentSkin !== null &&
					this.currentSkin.height > newHeight)
				{
					newHeight = this.currentSkin.height;
				}
			}

			return this.saveMeasurements(newWidth, newHeight, newMinWidth, newMinHeight);
		}

		/**
		 * @private
		 */
		override protected function changeState(state:String):void
		{
			var oldState:String = this._currentState;
			if(oldState === state)
			{
				return;
			}
			super.changeState(state);
			if(this._scaleWhenHovering !== 1 &&
				(state === ButtonState.HOVER || oldState === ButtonState.HOVER))
			{
				this.setRequiresRedraw();
			}
			else if(this._scaleWhenDown !== 1 &&
				(state === ButtonState.DOWN || oldState === ButtonState.DOWN))
			{
				this.setRequiresRedraw();
			}
		}

		/**
		 * Creates the label text renderer sub-component and
		 * removes the old instance, if one exists.
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 *
		 * @see #labelTextRenderer
		 * @see #labelFactory
		 */
		protected function createLabel():void
		{
			if(this.labelTextRenderer)
			{
				this.removeChild(DisplayObject(this.labelTextRenderer), true);
				this.labelTextRenderer = null;
			}

			if(this._hasLabelTextRenderer)
			{
				var factory:Function = this._labelFactory != null ? this._labelFactory : FeathersControl.defaultTextRendererFactory;
				this.labelTextRenderer = ITextRenderer(factory());
				var labelStyleName:String = this._customLabelStyleName != null ? this._customLabelStyleName : this.labelStyleName;
				this.labelTextRenderer.styleNameList.add(labelStyleName);
				if(this.labelTextRenderer is IStateObserver)
				{
					IStateObserver(this.labelTextRenderer).stateContext = this;
				}
				this.addChild(DisplayObject(this.labelTextRenderer));
			}
		}

		/**
		 * @private
		 */
		protected function refreshLabel():void
		{
			if(!this.labelTextRenderer)
			{
				return;
			}
			this.labelTextRenderer.text = this._label;
			this.labelTextRenderer.visible = this._label !== null && this._label.length > 0;
			this.labelTextRenderer.isEnabled = this._isEnabled;
		}
		
		/**
		 * Sets the <code>currentIcon</code> property.
		 *
		 * <p>For internal use in subclasses.</p>
		 */
		protected function refreshIcon():void
		{
			var oldIcon:DisplayObject = this.currentIcon;
			this.currentIcon = this.getCurrentIcon();
			if(this.currentIcon is IFeathersControl)
			{
				IFeathersControl(this.currentIcon).isEnabled = this._isEnabled;
			}
			if(this.currentIcon !== oldIcon)
			{
				if(oldIcon !== null)
				{
					this.removeCurrentIcon(oldIcon);
				}
				if(this.currentIcon !== null)
				{
					if(this.currentIcon is IStateObserver)
					{
						IStateObserver(this.currentIcon).stateContext = this;
					}
					//we want the icon to appear below the label text renderer
					var index:int = this.numChildren;
					if(this.labelTextRenderer)
					{
						index = this.getChildIndex(DisplayObject(this.labelTextRenderer));
					}
					this.addChildAt(this.currentIcon, index);
					if(this.currentIcon is IFeathersControl)
					{
						IFeathersControl(this.currentIcon).addEventListener(FeathersEventType.RESIZE, currentIcon_resizeHandler);
					}
				}
			}
		}

		/**
		 * @private
		 */
		protected function removeCurrentIcon(icon:DisplayObject):void
		{
			if(icon === null)
			{
				return;
			}
			if(icon is IFeathersControl)
			{
				IFeathersControl(icon).removeEventListener(FeathersEventType.RESIZE, currentIcon_resizeHandler);
			}
			if(icon is IStateObserver)
			{
				IStateObserver(icon).stateContext = null;
			}
			if(icon.parent === this)
			{
				this.removeChild(icon, false);
			}
		}

		/**
		 * @private
		 */
		override protected function getCurrentSkin():DisplayObject
		{
			if(this._stateToSkinFunction !== null)
			{
				return DisplayObject(this._stateToSkinFunction(this, this._currentState, this.currentSkin));
			}
			return super.getCurrentSkin();
		}

		/**
		 * @private
		 */
		protected function getCurrentIcon():DisplayObject
		{
			if(this._stateToIconFunction !== null)
			{
				return DisplayObject(this._stateToIconFunction(this, this._currentState, this.currentIcon));
			}
			var result:DisplayObject = this._stateToIcon[this._currentState] as DisplayObject;
			if(result !== null)
			{
				return result;
			}
			return this._defaultIcon;
		}

		/**
		 * @private
		 */
		protected function refreshLabelStyles():void
		{
			if(this.labelTextRenderer === null)
			{
				return;
			}
			this.labelTextRenderer.fontStyles = this._fontStylesSet;
			var properties:Object = this.getCurrentLabelProperties();
			for(var propertyName:String in properties)
			{
				var propertyValue:Object = properties[propertyName];
				this.labelTextRenderer[propertyName] = propertyValue;
			}
		}

		/**
		 * @private
		 */
		protected function getCurrentLabelProperties():Object
		{
			if(this._stateToLabelPropertiesFunction !== null)
			{
				return this._stateToLabelPropertiesFunction(this, this._currentState);
			}
			var result:Object = this._stateToLabelProperties[this._currentState];
			if(result !== null)
			{
				return result;
			}
			return this._defaultLabelProperties;
		}

		/**
		 * @private
		 */
		override protected function refreshTriggeredEvents():void
		{
			super.refreshTriggeredEvents();
			this.keyToTrigger.isEnabled = this._isEnabled;
		}

		/**
		 * @private
		 */
		protected function refreshLongPressEvents():void
		{
			this.longPress.isEnabled = this._isEnabled && this._isLongPressEnabled;
			this.longPress.longPressDuration = this._longPressDuration;
		}
		
		/**
		 * Positions and sizes the button's content.
		 *
		 * <p>For internal use in subclasses.</p>
		 */
		protected function layoutContent():void
		{
			this.refreshMaxLabelSize(false);
			var labelRenderer:DisplayObject = null;
			if(this._label !== null && this.labelTextRenderer)
			{
				this.labelTextRenderer.validate();
				labelRenderer = DisplayObject(this.labelTextRenderer);
			}
			var iconIsInLayout:Boolean = this.currentIcon && this._iconPosition != RelativePosition.MANUAL;
			if(labelRenderer && iconIsInLayout)
			{
				this.positionSingleChild(labelRenderer);
				this.positionLabelAndIcon();
			}
			else if(labelRenderer)
			{
				this.positionSingleChild(labelRenderer);
			}
			else if(iconIsInLayout)
			{
				this.positionSingleChild(this.currentIcon);
			}

			if(this.currentIcon)
			{
				if(this._iconPosition == RelativePosition.MANUAL)
				{
					this.currentIcon.x = this._paddingLeft;
					this.currentIcon.y = this._paddingTop;
				}
				this.currentIcon.x += this._iconOffsetX;
				this.currentIcon.y += this._iconOffsetY;
			}
			if(labelRenderer)
			{
				this.labelTextRenderer.x += this._labelOffsetX;
				this.labelTextRenderer.y += this._labelOffsetY;
			}
		}

		/**
		 * @private
		 */
		protected function refreshMaxLabelSize(forMeasurement:Boolean):void
		{
			var oldIgnoreIconResizes:Boolean = this._ignoreIconResizes;
			this._ignoreIconResizes = true;
			if(this.currentIcon is IValidating)
			{
				IValidating(this.currentIcon).validate();
			}
			var calculatedWidth:Number = this.actualWidth;
			var calculatedHeight:Number = this.actualHeight;
			if(forMeasurement)
			{
				calculatedWidth = this._explicitWidth;
				if(calculatedWidth !== calculatedWidth) //isNaN
				{
					calculatedWidth = this._explicitMaxWidth;
				}
				calculatedHeight = this._explicitHeight;
				if(calculatedHeight !== calculatedHeight) //isNaN
				{
					calculatedHeight = this._explicitMaxHeight;
				}
			}
			if(this._label != null && this.labelTextRenderer)
			{
				this.labelTextRenderer.maxWidth = calculatedWidth - this._paddingLeft - this._paddingRight;
				this.labelTextRenderer.maxHeight = calculatedHeight - this._paddingTop - this._paddingBottom;
				if(this.currentIcon)
				{
					var adjustedGap:Number = this._gap;
					if(adjustedGap == Number.POSITIVE_INFINITY)
					{
						adjustedGap = this._minGap;
					}
					if(this._iconPosition == RelativePosition.LEFT || this._iconPosition == RelativePosition.LEFT_BASELINE ||
						this._iconPosition == RelativePosition.RIGHT || this._iconPosition == RelativePosition.RIGHT_BASELINE)
					{
						this.labelTextRenderer.maxWidth -= (this.currentIcon.width + adjustedGap);
					}
					if(this._iconPosition == RelativePosition.TOP || this._iconPosition == RelativePosition.BOTTOM)
					{
						this.labelTextRenderer.maxHeight -= (this.currentIcon.height + adjustedGap);
					}
				}
			}
			this._ignoreIconResizes = oldIgnoreIconResizes;
		}
		
		/**
		 * @private
		 */
		protected function positionSingleChild(displayObject:DisplayObject):void
		{
			if(this._horizontalAlign == HorizontalAlign.LEFT)
			{
				displayObject.x = this._paddingLeft;
			}
			else if(this._horizontalAlign == HorizontalAlign.RIGHT)
			{
				displayObject.x = this.actualWidth - this._paddingRight - displayObject.width;
			}
			else //center
			{
				displayObject.x = this._paddingLeft + Math.round((this.actualWidth - this._paddingLeft - this._paddingRight - displayObject.width) / 2);
			}
			if(this._verticalAlign == VerticalAlign.TOP)
			{
				displayObject.y = this._paddingTop;
			}
			else if(this._verticalAlign == VerticalAlign.BOTTOM)
			{
				displayObject.y = this.actualHeight - this._paddingBottom - displayObject.height;
			}
			else //middle
			{
				displayObject.y = this._paddingTop + Math.round((this.actualHeight - this._paddingTop - this._paddingBottom - displayObject.height) / 2);
			}
		}
		
		/**
		 * @private
		 */
		protected function positionLabelAndIcon():void
		{
			if(this._iconPosition == RelativePosition.TOP)
			{
				if(this._gap == Number.POSITIVE_INFINITY)
				{
					this.currentIcon.y = this._paddingTop;
					this.labelTextRenderer.y = this.actualHeight - this._paddingBottom - this.labelTextRenderer.height;
				}
				else
				{
					if(this._verticalAlign == VerticalAlign.TOP)
					{
						this.labelTextRenderer.y += this.currentIcon.height + this._gap;
					}
					else if(this._verticalAlign == VerticalAlign.MIDDLE)
					{
						this.labelTextRenderer.y += Math.round((this.currentIcon.height + this._gap) / 2);
					}
					this.currentIcon.y = this.labelTextRenderer.y - this.currentIcon.height - this._gap;
				}
			}
			else if(this._iconPosition == RelativePosition.RIGHT || this._iconPosition == RelativePosition.RIGHT_BASELINE)
			{
				if(this._gap == Number.POSITIVE_INFINITY)
				{
					this.labelTextRenderer.x = this._paddingLeft;
					this.currentIcon.x = this.actualWidth - this._paddingRight - this.currentIcon.width;
				}
				else
				{
					if(this._horizontalAlign == HorizontalAlign.RIGHT)
					{
						this.labelTextRenderer.x -= this.currentIcon.width + this._gap;
					}
					else if(this._horizontalAlign == HorizontalAlign.CENTER)
					{
						this.labelTextRenderer.x -= Math.round((this.currentIcon.width + this._gap) / 2);
					}
					this.currentIcon.x = this.labelTextRenderer.x + this.labelTextRenderer.width + this._gap;
				}
			}
			else if(this._iconPosition == RelativePosition.BOTTOM)
			{
				if(this._gap == Number.POSITIVE_INFINITY)
				{
					this.labelTextRenderer.y = this._paddingTop;
					this.currentIcon.y = this.actualHeight - this._paddingBottom - this.currentIcon.height;
				}
				else
				{
					if(this._verticalAlign == VerticalAlign.BOTTOM)
					{
						this.labelTextRenderer.y -= this.currentIcon.height + this._gap;
					}
					else if(this._verticalAlign == VerticalAlign.MIDDLE)
					{
						this.labelTextRenderer.y -= Math.round((this.currentIcon.height + this._gap) / 2);
					}
					this.currentIcon.y = this.labelTextRenderer.y + this.labelTextRenderer.height + this._gap;
				}
			}
			else if(this._iconPosition == RelativePosition.LEFT || this._iconPosition == RelativePosition.LEFT_BASELINE)
			{
				if(this._gap == Number.POSITIVE_INFINITY)
				{
					this.currentIcon.x = this._paddingLeft;
					this.labelTextRenderer.x = this.actualWidth - this._paddingRight - this.labelTextRenderer.width;
				}
				else
				{
					if(this._horizontalAlign == HorizontalAlign.LEFT)
					{
						this.labelTextRenderer.x += this._gap + this.currentIcon.width;
					}
					else if(this._horizontalAlign == HorizontalAlign.CENTER)
					{
						this.labelTextRenderer.x += Math.round((this._gap + this.currentIcon.width) / 2);
					}
					this.currentIcon.x = this.labelTextRenderer.x - this._gap - this.currentIcon.width;
				}
			}
			
			if(this._iconPosition == RelativePosition.LEFT || this._iconPosition == RelativePosition.RIGHT)
			{
				if(this._verticalAlign == VerticalAlign.TOP)
				{
					this.currentIcon.y = this._paddingTop;
				}
				else if(this._verticalAlign == VerticalAlign.BOTTOM)
				{
					this.currentIcon.y = this.actualHeight - this._paddingBottom - this.currentIcon.height;
				}
				else
				{
					this.currentIcon.y = this._paddingTop + Math.round((this.actualHeight - this._paddingTop - this._paddingBottom - this.currentIcon.height) / 2);
				}
			}
			else if(this._iconPosition == RelativePosition.LEFT_BASELINE || this._iconPosition == RelativePosition.RIGHT_BASELINE)
			{
				this.currentIcon.y = this.labelTextRenderer.y + (this.labelTextRenderer.baseline) - this.currentIcon.height;
			}
			else //top or bottom
			{
				if(this._horizontalAlign == HorizontalAlign.LEFT)
				{
					this.currentIcon.x = this._paddingLeft;
				}
				else if(this._horizontalAlign == HorizontalAlign.RIGHT)
				{
					this.currentIcon.x = this.actualWidth - this._paddingRight - this.currentIcon.width;
				}
				else
				{
					this.currentIcon.x = this._paddingLeft + Math.round((this.actualWidth - this._paddingLeft - this._paddingRight - this.currentIcon.width) / 2);
				}
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
		override protected function focusInHandler(event:Event):void
		{
			super.focusInHandler(event);
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
			this.stage.addEventListener(KeyboardEvent.KEY_UP, stage_keyUpHandler);
		}

		/**
		 * @private
		 */
		override protected function focusOutHandler(event:Event):void
		{
			super.focusOutHandler(event);
			this.stage.removeEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
			this.stage.removeEventListener(KeyboardEvent.KEY_UP, stage_keyUpHandler);

			if(this.touchPointID >= 0)
			{
				this.touchPointID = -1;
				if(this._isEnabled)
				{
					this.changeState(ButtonState.UP);
				}
				else
				{
					this.changeState(ButtonState.DISABLED);
				}
			}
		}

		/**
		 * @private
		 */
		protected function stage_keyDownHandler(event:KeyboardEvent):void
		{
			if(event.keyCode === Keyboard.ESCAPE)
			{
				this.touchPointID = -1;
				this.changeState(ButtonState.UP);
			}
			if(this.touchPointID >= 0 || event.keyCode !== Keyboard.SPACE)
			{
				return;
			}
			this.touchPointID = int.MAX_VALUE;
			this.changeState(ButtonState.DOWN);
		}

		/**
		 * @private
		 */
		protected function stage_keyUpHandler(event:KeyboardEvent):void
		{
			if(this.touchPointID !== int.MAX_VALUE || event.keyCode !== Keyboard.SPACE)
			{
				return;
			}
			this.resetTouchState();
		}

		/**
		 * @private
		 */
		protected function currentIcon_resizeHandler():void
		{
			if(this._ignoreIconResizes)
			{
				return;
			}
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		/**
		 * @private
		 */
		protected function fontStyles_changeHandler(event:Event):void
		{
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
	}
}