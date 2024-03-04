/*
Feathers
Copyright 2012-2021 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.core.FeathersControl;
	import feathers.core.IAdvancedNativeFocusOwner;
	import feathers.core.IFeathersControl;
	import feathers.core.IFocusDisplayObject;
	import feathers.core.IMeasureDisplayObject;
	import feathers.core.IMultilineTextEditor;
	import feathers.core.INativeFocusOwner;
	import feathers.core.IStateContext;
	import feathers.core.IStateObserver;
	import feathers.core.ITextBaselineControl;
	import feathers.core.ITextEditor;
	import feathers.core.ITextRenderer;
	import feathers.core.IValidating;
	import feathers.core.PopUpManager;
	import feathers.core.PropertyProxy;
	import feathers.events.FeathersEventType;
	import feathers.layout.RelativePosition;
	import feathers.layout.VerticalAlign;
	import feathers.skins.IStyleProvider;
	import feathers.text.FontStylesSet;
	import feathers.utils.skins.resetFluidChildDimensionsForMeasurement;

	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;

	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextFormat;
	import starling.utils.Pool;

	/**
	 * The skin used for the input's disabled state. If <code>null</code>,
	 * then <code>backgroundSkin</code> is used instead.
	 *
	 * <p>The following example gives the input a skin for the disabled state:</p>
	 *
	 * <listing version="3.0">
	 * input.backgroundDisabledSkin = new Image( texture );</listing>
	 *
	 * <p>Alternatively, you may use <code>setSkinForState()</code> with
	 * <code>TextInputState.DISABLED</code> to set the same skin:</p>
	 *
	 * <listing version="3.0">
	 * var skin:Image = new Image( texture );
	 * input.setSkinForState( TextInputState.DISABLED, skin );</listing>
	 *
	 * @default null
	 *
	 * @see #style:backgroundSkin
	 * @see #setSkinForState()
	 * @see feathers.controls.TextInputState#DISABLED
	 */
	[Style(name="backgroundDisabledSkin",type="starling.display.DisplayObject")]

	/**
	 * The skin used for the input's enabled state. If <code>null</code>,
	 * then <code>backgroundSkin</code> is used instead.
	 *
	 * <p>The following example gives the input a skin for the enabled state:</p>
	 *
	 * <listing version="3.0">
	 * input.backgroundEnabledSkin = new Image( texture );</listing>
	 *
	 * <p>Alternatively, you may use <code>setSkinForState()</code> with
	 * <code>TextInputState.ENABLED</code> to set the same skin:</p>
	 *
	 * <listing version="3.0">
	 * var skin:Image = new Image( texture );
	 * input.setSkinForState( TextInputState.ENABLED, skin );</listing>
	 *
	 * @default null
	 *
	 * @see #style:backgroundSkin
	 * @see #setSkinForState()
	 * @see feathers.controls.TextInputState#ENABLED
	 */
	[Style(name="backgroundEnabledSkin",type="starling.display.DisplayObject")]

	/**
	 * The skin used for the input's error state. If <code>null</code>,
	 * then <code>backgroundSkin</code> is used instead.
	 *
	 * <p>The following example gives the input a skin for the error state:</p>
	 *
	 * <listing version="3.0">
	 * input.backgroundErrorSkin = new Image( texture );</listing>
	 *
	 * <p>Alternatively, you may use <code>setSkinForState()</code> with
	 * <code>TextInputState.ERROR</code> to set the same skin:</p>
	 *
	 * <listing version="3.0">
	 * var skin:Image = new Image( texture );
	 * input.setSkinForState( TextInputState.ERROR, skin );</listing>
	 *
	 * @default null
	 *
	 * @see #style:backgroundSkin
	 * @see #setSkinForState()
	 * @see feathers.controls.TextInputState#ERROR
	 */
	[Style(name="backgroundErrorSkin",type="starling.display.DisplayObject")]

	/**
	 * The skin used for the input's focused state. If <code>null</code>,
	 * then <code>backgroundSkin</code> is used instead.
	 *
	 * <p>The following example gives the input a skin for the focused state:</p>
	 *
	 * <listing version="3.0">
	 * input.backgroundFocusedSkin = new Image( texture );</listing>
	 *
	 * <p>Alternatively, you may use <code>setSkinForState()</code> with
	 * <code>TextInputState.FOCUSED</code> to set the same skin:</p>
	 *
	 * <listing version="3.0">
	 * var skin:Image = new Image( texture );
	 * input.setSkinForState( TextInputState.FOCUSED, skin );</listing>
	 *
	 * @default null
	 *
	 * @see #style:backgroundSkin
	 * @see #setSkinForState()
	 * @see feathers.controls.TextInputState#FOCUSED
	 */
	[Style(name="backgroundFocusedSkin",type="starling.display.DisplayObject")]

	/**
	 * The skin used when no other skin is defined for the current state.
	 * Intended for use when multiple states should use the same skin.
	 *
	 * <p>The following example gives the input a default skin to use for
	 * all states when no specific skin is available:</p>
	 *
	 * <listing version="3.0">
	 * input.backgroundSkin = new Image( texture );</listing>
	 *
	 * @default null
	 *
	 * @see #setSkinForState()
	 */
	[Style(name="backgroundSkin",type="starling.display.DisplayObject")]

	/**
	 * A style name to add to the text input's error callout sub-component.
	 * Typically used by a theme to provide different styles to different
	 * text inputs.
	 *
	 * <p>In the following example, a custom error callout style name
	 * is passed to the text input:</p>
	 *
	 * <listing version="3.0">
	 * input.customErrorCalloutStyleName = "my-custom-text-input-error-callout";</listing>
	 *
	 * <p>In your theme, you can target this sub-component style name to
	 * provide different styles than the default:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( Callout ).setFunctionForStyleName( "my-custom-text-input-error-callout", setCustomTextInputErrorCalloutStyles );</listing>
	 *
	 * @default null
	 *
	 * @see #DEFAULT_CHILD_STYLE_NAME_ERROR_CALLOUT
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	[Style(name="customErrorCalloutStyleName",type="String")]

	/**
	 * A style name to add to the text input's prompt text renderer
	 * sub-component. Typically used by a theme to provide different styles
	 * to different text inputs.
	 *
	 * <p>In the following example, a custom prompt text renderer style name
	 * is passed to the text input:</p>
	 *
	 * <listing version="3.0">
	 * input.customPromptStyleName = "my-custom-text-input-prompt";</listing>
	 *
	 * <p>In your theme, you can target this sub-component style name to
	 * provide different styles than the default:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( BitmapFontTextRenderer ).setFunctionForStyleName( "my-custom-text-input-prompt", setCustomTextInputPromptStyles );</listing>
	 *
	 * @default null
	 *
	 * @see #DEFAULT_CHILD_STYLE_NAME_PROMPT
	 * @see feathers.core.FeathersControl#styleNameList
	 * @see #promptFactory
	 */
	[Style(name="customPromptStyleName",type="String")]

	/**
	 * A style name to add to the text input's text editor sub-component.
	 * Typically used by a theme to provide different styles to different
	 * text inputs.
	 *
	 * <p>In the following example, a custom text editor style name is
	 * passed to the text input:</p>
	 *
	 * <listing version="3.0">
	 * input.customTextEditorStyleName = "my-custom-text-input-text-editor";</listing>
	 *
	 * <p>In your theme, you can target this sub-component style name to
	 * provide different styles than the default:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( StageTextTextEditor ).setFunctionForStyleName( "my-custom-text-input-text-editor", setCustomTextInputTextEditorStyles );</listing>
	 *
	 * @default null
	 *
	 * @see #DEFAULT_CHILD_STYLE_NAME_TEXT_EDITOR
	 * @see feathers.core.FeathersControl#styleNameList
	 * @see #textEditorFactory
	 */
	[Style(name="customTextEditorStyleName",type="String")]

	/**
	 * The icon used when no other icon is defined for the current state.
	 * Intended for use when multiple states should use the same icon.
	 *
	 * <p>The following example gives the input a default icon to use for
	 * all states when no specific icon is available:</p>
	 *
	 * <listing version="3.0">
	 * input.defaultIcon = new Image( texture );</listing>
	 *
	 * @default null
	 *
	 * @see #setIconForState()
	 */
	[Style(name="defaultIcon",type="starling.display.DisplayObject")]

	/**
	 * The font styles used to display the input's text when the input is
	 * disabled.
	 *
	 * <p>In the following example, the disabled font styles are customized:</p>
	 *
	 * <listing version="3.0">
	 * input.disabledFontStyles = new TextFormat( "Helvetica", 20, 0x999999 );</listing>
	 *
	 * <p>Alternatively, you may use <code>setFontStylesForState()</code> with
	 * <code>TextInputState.DISABLED</code> to set the same font styles:</p>
	 *
	 * <listing version="3.0">
	 * var fontStyles:TextFormat = new TextFormat( "Helvetica", 20, 0x999999 );
	 * input.setFontStylesForState( TextInputState.DISABLED, fontStyles );</listing>
	 *
	 * <p>Note: The <code>starling.text.TextFormat</code> class defines a
	 * number of common font styles, but the text editor being used may
	 * support a larger number of ways to be customized. Use the
	 * <code>textEditorFactory</code> to set more advanced styles on the
	 * text editor.</p>
	 *
	 * @default null
	 *
	 * @see http://doc.starling-framework.org/current/starling/text/TextFormat.html starling.text.TextFormat
	 * @see #style:fontStyles
	 * @see #setFontStylesForState()
	 * @see feathers.controls.TextInputState#DISABLED
	 */
	[Style(name="disabledFontStyles",type="starling.text.TextFormat")]

	/**
	 * The icon used for the input's disabled state. If <code>null</code>,
	 * then <code>defaultIcon</code> is used instead.
	 *
	 * <p>The following example gives the input an icon for the disabled state:</p>
	 *
	 * <listing version="3.0">
	 * button.disabledIcon = new Image( texture );</listing>
	 *
	 * <p>Alternatively, you may use <code>setIconForState()</code> with
	 * <code>TextInputState.DISABLED</code> to set the same icon:</p>
	 *
	 * <listing version="3.0">
	 * var icon:Image = new Image( texture );
	 * input.setIconForState( TextInputState.DISABLED, icon );</listing>
	 *
	 * @default null
	 *
	 * @see #style:defaultIcon
	 * @see #setIconForState()
	 * @see feathers.controls.TextInputState#DISABLED
	 */
	[Style(name="disabledIcon",type="starling.display.DisplayObject")]

	/**
	 * The icon used for the input's enabled state. If <code>null</code>,
	 * then <code>defaultIcon</code> is used instead.
	 *
	 * <p>The following example gives the input an icon for the enabled state:</p>
	 *
	 * <listing version="3.0">
	 * button.enabledIcon = new Image( texture );</listing>
	 *
	 * <p>Alternatively, you may use <code>setIconForState()</code> with
	 * <code>TextInputState.ENABLED</code> to set the same icon:</p>
	 *
	 * <listing version="3.0">
	 * var icon:Image = new Image( texture );
	 * input.setIconForState( TextInputState.ENABLED, icon );</listing>
	 *
	 * @default null
	 *
	 * @see #style:defaultIcon
	 * @see #setIconForState()
	 * @see feathers.controls.TextInputState#ENABLED
	 */
	[Style(name="enabledIcon",type="starling.display.DisplayObject")]

	/**
	 * The icon used for the input's error state. If <code>null</code>,
	 * then <code>defaultIcon</code> is used instead.
	 *
	 * <p>The following example gives the input an icon for the error state:</p>
	 *
	 * <listing version="3.0">
	 * button.errorIcon = new Image( texture );</listing>
	 *
	 * <p>Alternatively, you may use <code>setIconForState()</code> with
	 * <code>TextInputState.ERROR</code> to set the same icon:</p>
	 *
	 * <listing version="3.0">
	 * var icon:Image = new Image( texture );
	 * input.setIconForState( TextInputState.ERROR, icon );</listing>
	 *
	 * @default null
	 *
	 * @see #style:defaultIcon
	 * @see #setIconForState()
	 * @see feathers.controls.TextInputState#ERROR
	 */
	[Style(name="errorIcon",type="starling.display.DisplayObject")]

	/**
	 * The icon used for the input's focused state. If <code>null</code>,
	 * then <code>defaultIcon</code> is used instead.
	 *
	 * <p>The following example gives the input an icon for the focused state:</p>
	 *
	 * <listing version="3.0">
	 * button.focusedIcon = new Image( texture );</listing>
	 *
	 * <p>Alternatively, you may use <code>setIconForState()</code> with
	 * <code>TextInputState.FOCUSED</code> to set the same icon:</p>
	 *
	 * <listing version="3.0">
	 * var icon:Image = new Image( texture );
	 * input.setIconForState( TextInputState.FOCUSED, icon );</listing>
	 *
	 * @default null
	 *
	 * @see #style:defaultIcon
	 * @see #setIconForState()
	 * @see feathers.controls.TextInputState#FOCUSED
	 */
	[Style(name="focusedIcon",type="starling.display.DisplayObject")]

	/**
	 * The font styles used to display the input's text.
	 *
	 * <p>In the following example, the font styles are customized:</p>
	 *
	 * <listing version="3.0">
	 * input.fontStyles = new TextFormat( "Helvetica", 20, 0xcc0000 );</listing>
	 *
	 * <p>Note: The <code>starling.text.TextFormat</code> class defines a
	 * number of common font styles, but the text editor being used may
	 * support a larger number of ways to be customized. Use the
	 * <code>textEditorFactory</code> to set more advanced styles on the
	 * text editor.</p>
	 *
	 * @default null
	 *
	 * @see http://doc.starling-framework.org/current/starling/text/TextFormat.html starling.text.TextFormat
	 * @see #style:disabledFontStyles
	 * @see #setFontStylesForState()
	 */
	[Style(name="fontStyles",type="starling.text.TextFormat")]

	/**
	 * The space, in pixels, between the icon and the text editor, if an
	 * icon exists.
	 *
	 * <p>The following example creates a gap of 50 pixels between the icon
	 * and the text editor:</p>
	 *
	 * <listing version="3.0">
	 * button.defaultIcon = new Image( texture );
	 * button.gap = 50;</listing>
	 *
	 * @default 0
	 */
	[Style(name="gap",type="Number")]

	/**
	 * The location of the icon, relative to the text renderer.
	 *
	 * <p>The following example positions the icon to the right of the
	 * text renderer:</p>
	 *
	 * <listing version="3.0">
	 * input.defaultIcon = new Image( texture );
	 * input.iconPosition = RelativePosition.RIGHT;</listing>
	 *
	 * @default feathers.layout.RelativePosition.LEFT
	 *
	 * @see feathers.layout.RelativePosition#RIGHT
	 * @see feathers.layout.RelativePosition#LEFT
	 */
	[Style(name="iconPosition",type="String")]

	/**
	 * Quickly sets all padding properties to the same value. The
	 * <code>padding</code> getter always returns the value of
	 * <code>paddingTop</code>, but the other padding values may be
	 * different.
	 *
	 * <p>In the following example, the text input's padding is set to
	 * 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * input.padding = 20;</listing>
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
	 * The minimum space, in pixels, between the input's top edge and the
	 * input's content.
	 *
	 * <p>In the following example, the text input's top padding is set to
	 * 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * input.paddingTop = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:padding
	 */
	[Style(name="paddingTop",type="Number")]

	/**
	 * The minimum space, in pixels, between the input's right edge and the
	 * input's content.
	 *
	 * <p>In the following example, the text input's right padding is set to
	 * 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * input.paddingRight = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:padding
	 */
	[Style(name="paddingRight",type="Number")]

	/**
	 * The minimum space, in pixels, between the input's bottom edge and
	 * the input's content.
	 *
	 * <p>In the following example, the text input's bottom padding is set to
	 * 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * input.paddingBottom = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:padding
	 */
	[Style(name="paddingBottom",type="Number")]

	/**
	 * The minimum space, in pixels, between the input's left edge and the
	 * input's content.
	 *
	 * <p>In the following example, the text input's left padding is set to
	 * 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * input.paddingLeft = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:padding
	 */
	[Style(name="paddingLeft",type="Number")]

	/**
	 * The font styles used to display the input's prompt when the input is
	 * disabled.
	 *
	 * <p>In the following example, the disabled font styles are customized:</p>
	 *
	 * <listing version="3.0">
	 * input.promptDisabledFontStyles = new TextFormat( "Helvetica", 20, 0x999999 );</listing>
	 *
	 * <p>Note: The <code>starling.text.TextFormat</code> class defines a
	 * number of common font styles, but the text renderer being used may
	 * support a larger number of ways to be customized. Use the
	 * <code>promptFactory</code> to set more advanced styles on the
	 * text renderer.</p>
	 *
	 * @default null
	 *
	 * @see http://doc.starling-framework.org/current/starling/text/TextFormat.html starling.text.TextFormat
	 * @see #style:promptFontStyles
	 * @see #setPromptFontStylesForState()
	 */
	[Style(name="promptDisabledFontStyles",type="starling.text.TextFormat")]

	/**
	 * The font styles used to display the input's prompt text.
	 *
	 * <p>In the following example, the font styles are customized:</p>
	 *
	 * <listing version="3.0">
	 * input.promptFontStyles = new TextFormat( "Helvetica", 20, 0xcc0000 );</listing>
	 *
	 * <p>Note: The <code>starling.text.TextFormat</code> class defines a
	 * number of common font styles, but the text renderer being used may
	 * support a larger number of ways to be customized. Use the
	 * <code>promptFactory</code> to set more advanced styles on the
	 * text renderer.</p>
	 *
	 * @default null
	 *
	 * @see http://doc.starling-framework.org/current/starling/text/TextFormat.html starling.text.TextFormat
	 * @see #style:promptDisabledFontStyles
	 * @see #setPromptFontStylesForState()
	 */
	[Style(name="promptFontStyles",type="starling.text.TextFormat")]

	/**
	 * If not <code>null</code>, the dimensions of the
	 * <code>typicalText</code> will be used in the calculation of the text
	 * input's full dimensions. If the text input's dimensions haven't been
	 * set explicitly, it's calculated dimensions will be at least large
	 * enough to display the <code>typicalText</code>. Other children, such
	 * as the background skin and the prompt text renderer may also affect
	 * the dimensions of the text input, allowing it to, potentially, be
	 * bigger than the rendered <code>typicalText</code>.
	 *
	 * <p>In the following example, the text input's typical text is
	 * updated:</p>
	 *
	 * <listing version="3.0">
	 * input.text = "We want to allow the text input to show all of this text";</listing>
	 *
	 * @default null
	 */
	[Style(name="typicalText",type="String")]

	/**
	 * The location where the text editor is aligned vertically (on
	 * the y-axis).
	 *
	 * <p>The following example aligns the text editor to the top:</p>
	 *
	 * <listing version="3.0">
	 * input.verticalAlign = VerticalAlign.TOP;</listing>
	 *
	 * @default feathers.layout.VerticalAlign.MIDDLE
	 *
	 * @see feathers.layout.VerticalAlign#TOP
	 * @see feathers.layout.VerticalAlign#MIDDLE
	 * @see feathers.layout.VerticalAlign#BOTTOM
	 * @see feathers.layout.VerticalAlign#JUSTIFY
	 */
	[Style(name="verticalAlign",type="String")]

	/**
	 * Dispatched when the text input's <code>text</code> property changes.
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
	 * @see #text
	 *
	 * @eventType starling.events.Event.CHANGE
	 */
	[Event(name="change",type="starling.events.Event")]

	/**
	 * Dispatched when the user presses the Enter key while the text input
	 * has focus. This event may not be dispatched at all times. Certain text
	 * editors will not dispatch an event for the enter key on some platforms,
	 * depending on the values of certain properties. This may include the
	 * default values for some platforms! If you've encountered this issue,
	 * please see the specific text editor's API documentation for complete
	 * details of this event's limitations and requirements.
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
	 * @eventType feathers.events.FeathersEventType.ENTER
	 */
	[Event(name="enter",type="starling.events.Event")]

	/**
	 * Dispatched when the text input receives focus.
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
	 * Dispatched when the text input loses focus.
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
	 * Dispatched when the soft keyboard is about the be activated by the text
	 * editor. Not all text editors will activate a soft keyboard.
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
	 * @eventType feathers.events.FeathersEventType.SOFT_KEYBOARD_ACTIVATING
	 */
	[Event(name="softKeyboardActivating",type="starling.events.Event")]

	/**
	 * Dispatched when the soft keyboard is activated by the text editor. Not
	 * all text editors will activate a soft keyboard.
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
	 * @eventType feathers.events.FeathersEventType.SOFT_KEYBOARD_ACTIVATE
	 */
	[Event(name="softKeyboardActivate",type="starling.events.Event")]

	/**
	 * Dispatched when the soft keyboard is deactivated by the text editor. Not
	 * all text editors will activate a soft keyboard.
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
	 * @eventType feathers.events.FeathersEventType.SOFT_KEYBOARD_DEACTIVATE
	 */
	[Event(name="softKeyboardDeactivate",type="starling.events.Event")]

	/**
	 * Dispatched when the display object's state changes.
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
	 * @eventType feathers.events.FeathersEventType.STATE_CHANGE
	 *
	 * @see #currentState
	 */
	[Event(name="stateChange",type="starling.events.Event")]

	[DefaultProperty("text")]
	/**
	 * A text entry control that allows users to enter and edit a single line of
	 * uniformly-formatted text.
	 *
	 * <p>The following example sets the text in a text input, selects the text,
	 * and listens for when the text value changes:</p>
	 *
	 * <listing version="3.0">
	 * var input:TextInput = new TextInput();
	 * input.text = "Hello World";
	 * input.selectRange( 0, input.text.length );
	 * input.addEventListener( Event.CHANGE, input_changeHandler );
	 * this.addChild( input );</listing>
	 *
	 * @see ../../../help/text-input.html How to use the Feathers TextInput component
	 * @see ../../../help/text-editors.html Introduction to Feathers text editors
	 * @see feathers.core.ITextEditor
	 * @see feathers.controls.AutoComplete
	 * @see feathers.controls.TextArea
	 *
	 * @productversion Feathers 1.0.0
	 */
	public class TextInput extends FeathersControl implements ITextBaselineControl, IAdvancedNativeFocusOwner, IStateContext
	{
		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_PROMPT_FACTORY:String = "promptFactory";

		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_ERROR_CALLOUT_FACTORY:String = "errorCalloutFactory";

		/**
		 * The default value added to the <code>styleNameList</code> of the text
		 * editor.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_TEXT_EDITOR:String = "feathers-text-input-text-editor";

		/**
		 * The default value added to the <code>styleNameList</code> of the
		 * prompt text renderer.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_PROMPT:String = "feathers-text-input-prompt";

		/**
		 * The default value added to the <code>styleNameList</code> of the
		 * error callout.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_ERROR_CALLOUT:String = "feathers-text-input-error-callout";

		/**
		 * An alternate style name to use with <code>TextInput</code> to allow a
		 * theme to give it a search input style. If a theme does not provide a
		 * style for the search text input, the theme will automatically fal
		 * back to using the default text input style.
		 *
		 * <p>An alternate style name should always be added to a component's
		 * <code>styleNameList</code> before the component is initialized. If
		 * the style name is added later, it will be ignored.</p>
		 *
		 * <p>In the following example, the search style is applied to a text
		 * input:</p>
		 *
		 * <listing version="3.0">
		 * var input:TextInput = new TextInput();
		 * input.styleNameList.add( TextInput.ALTERNATE_STYLE_NAME_SEARCH_TEXT_INPUT );
		 * this.addChild( input );</listing>
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const ALTERNATE_STYLE_NAME_SEARCH_TEXT_INPUT:String = "feathers-search-text-input";

		/**
		 * The default <code>IStyleProvider</code> for all <code>TextInput</code>
		 * components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		private static function defaultErrorCalloutFactory():TextCallout
		{
			return new TextCallout();
		}
		
		/**
		 * Constructor.
		 */
		public function TextInput()
		{
			super();
			if(this._fontStylesSet === null)
			{
				this._fontStylesSet = new FontStylesSet();
				this._fontStylesSet.addEventListener(Event.CHANGE, fontStyles_changeHandler);
			}
			if(this._promptFontStylesSet === null)
			{
				this._promptFontStylesSet = new FontStylesSet();
				this._promptFontStylesSet.addEventListener(Event.CHANGE, fontStyles_changeHandler);
			}
			this.addEventListener(TouchEvent.TOUCH, textInput_touchHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, textInput_removedFromStageHandler);
		}

		/**
		 * The text editor sub-component.
		 *
		 * <p>For internal use in subclasses.</p>
		 */
		protected var textEditor:ITextEditor;

		/**
		 * The prompt text renderer sub-component.
		 *
		 * <p>For internal use in subclasses.</p>
		 */
		protected var promptTextRenderer:ITextRenderer;

		/**
		 * The currently selected background, based on state.
		 *
		 * <p>For internal use in subclasses.</p>
		 */
		protected var currentBackground:DisplayObject;

		/**
		 * The currently visible icon. The value will be <code>null</code> if
		 * there is no currently visible icon.
		 *
		 * <p>For internal use in subclasses.</p>
		 */
		protected var currentIcon:DisplayObject;

		/**
		 * The <code>TextCallout</code> that displays the value of the
		 * <code>errorString</code> property. The value may be
		 * <code>null</code> if there is no current error string or the text
		 * input does not have focus.
		 *
		 * <p>For internal use in subclasses.</p>
		 */
		protected var callout:TextCallout;

		/**
		 * The value added to the <code>styleNameList</code> of the text editor.
		 * This variable is <code>protected</code> so that sub-classes can
		 * customize the text editor style name in their constructors instead of
		 * using the default style name defined by
		 * <code>DEFAULT_CHILD_STYLE_NAME_TEXT_EDITOR</code>.
		 *
		 * <p>To customize the text editor style name without subclassing, see
		 * <code>customTextEditorStyleName</code>.</p>
		 *
		 * @see #style:customTextEditorStyleName
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var textEditorStyleName:String = DEFAULT_CHILD_STYLE_NAME_TEXT_EDITOR;

		/**
		 * The value added to the <code>styleNameList</code> of the prompt text
		 * renderer. This variable is <code>protected</code> so that sub-classes
		 * can customize the prompt text renderer style name in their
		 * constructors instead of using the default style name defined by
		 * <code>DEFAULT_CHILD_STYLE_NAME_PROMPT</code>.
		 *
		 * <p>To customize the prompt text renderer style name without
		 * subclassing, see <code>customPromptStyleName</code>.</p>
		 *
		 * @see #style:customPromptStyleName
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var promptStyleName:String = DEFAULT_CHILD_STYLE_NAME_PROMPT;

		/**
		 * The value added to the <code>styleNameList</code> of the error
		 * callout. This variable is <code>protected</code> so that sub-classes
		 * can customize the prompt text renderer style name in their
		 * constructors instead of using the default style name defined by
		 * <code>DEFAULT_CHILD_STYLE_NAME_ERROR_CALLOUT</code>.
		 *
		 * <p>To customize the error callout style name without subclassing, see
		 * <code>customErrorCalloutStyleName</code>.</p>
		 *
		 * @see #style:customErrorCalloutStyleName
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var errorCalloutStyleName:String = DEFAULT_CHILD_STYLE_NAME_ERROR_CALLOUT;

		/**
		 * @private
		 */
		protected var _textEditorHasFocus:Boolean = false;

		/**
		 * A text editor may be an <code>INativeFocusOwner</code>, so we need to
		 * return the value of its <code>nativeFocus</code> property. If not,
		 * then we return <code>null</code>.
		 *
		 * @see feathers.core.INativeFocusOwner
		 */
		public function get nativeFocus():Object
		{
			if(this.textEditor is INativeFocusOwner)
			{
				return INativeFocusOwner(this.textEditor).nativeFocus;
			}
			return null;
		}

		/**
		 * @private
		 */
		override public function get maintainTouchFocus():Boolean
		{
			if(this.textEditor is IFocusDisplayObject)
			{
				return IFocusDisplayObject(this.textEditor).maintainTouchFocus;
			}
			return super.maintainTouchFocus;
		}

		/**
		 * @private
		 */
		protected var _ignoreTextChanges:Boolean = false;

		/**
		 * @private
		 */
		protected var _touchPointID:int = -1;

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return TextInput.globalStyleProvider;
		}

		/**
		 * When the <code>FocusManager</code> isn't enabled, <code>hasFocus</code>
		 * can be used instead of <code>FocusManager.focus == textInput</code>
		 * to determine if the text input has focus.
		 */
		public function get hasFocus():Boolean
		{
			return this._textEditorHasFocus;
		}

		/**
		 * @private
		 */
		override public function set isEnabled(value:Boolean):void
		{
			super.isEnabled = value;
			this.refreshState();
		}

		/**
		 * @private
		 */
		protected var _currentState:String = TextInputState.ENABLED;

		/**
		 * The current state of the text input.
		 *
		 * @see feathers.controls.TextInputState
		 * @see #event:stateChange feathers.events.FeathersEventType.STATE_CHANGE
		 */
		public function get currentState():String
		{
			return this._currentState;
		}

		/**
		 * @private
		 */
		protected var _text:String = "";

		[Bindable(event="change")]
		/**
		 * The text displayed by the text input. The text input dispatches
		 * <code>Event.CHANGE</code> when the value of the <code>text</code>
		 * property changes for any reason.
		 *
		 * <p>In the following example, the text input's text is updated:</p>
		 *
		 * <listing version="3.0">
		 * input.text = "Hello World";</listing>
		 *
		 * @see #event:change
		 *
		 * @default ""
		 */
		public function get text():String
		{
			return this._text;
		}

		/**
		 * @private
		 */
		public function set text(value:String):void
		{
			if(!value)
			{
				//don't allow null or undefined
				value = "";
			}
			if(this._text == value)
			{
				return;
			}
			this._text = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * The baseline measurement of the text, in pixels.
		 */
		public function get baseline():Number
		{
			if(!this.textEditor)
			{
				return 0;
			}
			return this.textEditor.y + this.textEditor.baseline;
		}

		/**
		 * @private
		 */
		protected var _prompt:String = null;

		/**
		 * The prompt, hint, or description text displayed by the input when the
		 * value of its text is empty.
		 *
		 * <p>In the following example, the text input's prompt is updated:</p>
		 *
		 * <listing version="3.0">
		 * input.prompt = "User Name";</listing>
		 *
		 * @default null
		 */
		public function get prompt():String
		{
			return this._prompt;
		}

		/**
		 * @private
		 */
		public function set prompt(value:String):void
		{
			if(this._prompt == value)
			{
				return;
			}
			this._prompt = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _typicalText:String = null;

		/**
		 * @private
		 */
		public function get typicalText():String
		{
			return this._typicalText;
		}

		/**
		 * @private
		 */
		public function set typicalText(value:String):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._typicalText === value)
			{
				return;
			}
			this._typicalText = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _maxChars:int = 0;

		/**
		 * The maximum number of characters that may be entered. If <code>0</code>,
		 * any number of characters may be entered.
		 *
		 * <p>In the following example, the text input's maximum characters is
		 * specified:</p>
		 *
		 * <listing version="3.0">
		 * input.maxChars = 10;</listing>
		 *
		 * @default 0
		 */
		public function get maxChars():int
		{
			return this._maxChars;
		}

		/**
		 * @private
		 */
		public function set maxChars(value:int):void
		{
			if(this._maxChars == value)
			{
				return;
			}
			this._maxChars = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _restrict:String;

		/**
		 * Limits the set of characters that may be entered.
		 *
		 * <p>In the following example, the text input's allowed characters are
		 * restricted:</p>
		 *
		 * <listing version="3.0">
		 * input.restrict = "0-9";</listing>
		 *
		 * @default null
		 */
		public function get restrict():String
		{
			return this._restrict;
		}

		/**
		 * @private
		 */
		public function set restrict(value:String):void
		{
			if(this._restrict == value)
			{
				return;
			}
			this._restrict = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _displayAsPassword:Boolean = false;

		/**
		 * Determines if the entered text will be masked so that it cannot be
		 * seen, such as for a password input.
		 *
		 * <p>In the following example, the text input's text is displayed as
		 * a password:</p>
		 *
		 * <listing version="3.0">
		 * input.displayAsPassword = true;</listing>
		 *
		 * @default false
		 */
		public function get displayAsPassword():Boolean
		{
			return this._displayAsPassword;
		}

		/**
		 * @private
		 */
		public function set displayAsPassword(value:Boolean):void
		{
			if(this._displayAsPassword == value)
			{
				return;
			}
			this._displayAsPassword = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _isEditable:Boolean = true;

		/**
		 * Determines if the text input is editable. If the text input is not
		 * editable, it will still appear enabled.
		 *
		 * <p>In the following example, the text input is not editable:</p>
		 *
		 * <listing version="3.0">
		 * input.isEditable = false;</listing>
		 *
		 * @default true
		 *
		 * @see #isSelectable
		 */
		public function get isEditable():Boolean
		{
			return this._isEditable;
		}

		/**
		 * @private
		 */
		public function set isEditable(value:Boolean):void
		{
			if(this._isEditable == value)
			{
				return;
			}
			this._isEditable = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _isSelectable:Boolean = true;

		/**
		 * If the <code>isEditable</code> property is set to <code>false</code>,
		 * the <code>isSelectable</code> property determines if the text is
		 * selectable. If the <code>isEditable</code> property is set to
		 * <code>true</code>, the text will always be selectable.
		 *
		 * <p>In the following example, the text input is not selectable:</p>
		 *
		 * <listing version="3.0">
		 * input.isEditable = false;
		 * input.isSelectable = false;</listing>
		 *
		 * @default true
		 *
		 * @see #isEditable
		 */
		public function get isSelectable():Boolean
		{
			return this._isSelectable;
		}

		/**
		 * @private
		 */
		public function set isSelectable(value:Boolean):void
		{
			if(this._isSelectable == value)
			{
				return;
			}
			this._isSelectable = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _errorString:String = null;

		/**
		 * Error text to display in a <code>Callout</code> when the input has
		 * focus. When this value is not <code>null</code> the input's state is
		 * changed to <code>TextInputState.ERROR</code>.
		 *
		 * An empty string will change the background, but no
		 * <code>Callout</code> will appear on focus.
		 *
		 * To clear an error, the <code>errorString</code> property must be set
		 * to <code>null</code>
		 *
		 * <p>The following example displays an error string:</p>
		 *
		 * <listing version="3.0">
		 * input.errorString = "Something is wrong";</listing>
		 *
		 * @default null
		 *
		 * @see #currentState
		 */
		public function get errorString():String
		{
			return this._errorString;
		}

		/**
		 * @private
		 */
		public function set errorString(value:String):void
		{
			if(this._errorString === value)
			{
				return;
			}
			this._errorString = value;
			this.refreshState();
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			var savedCallee:Function = arguments.callee;
			function changeHandler(event:Event):void
			{
				processStyleRestriction(savedCallee);
			}
			var oldValue:TextFormat = this._fontStylesSet.format;
			if(oldValue !== null)
			{
				oldValue.removeEventListener(Event.CHANGE, changeHandler);
			}
			this._fontStylesSet.format = value;
			if(value !== null)
			{
				value.addEventListener(Event.CHANGE, changeHandler);
			}
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			var savedCallee:Function = arguments.callee;
			function changeHandler(event:Event):void
			{
				processStyleRestriction(savedCallee);
			}
			var oldValue:TextFormat = this._fontStylesSet.disabledFormat;
			if(oldValue !== null)
			{
				oldValue.removeEventListener(Event.CHANGE, changeHandler);
			}
			this._fontStylesSet.disabledFormat = value;
			if(value !== null)
			{
				value.addEventListener(Event.CHANGE, changeHandler);
			}
		}

		/**
		 * @private
		 */
		protected var _textEditorFactory:Function;

		/**
		 * A function used to instantiate the text editor. If null,
		 * <code>FeathersControl.defaultTextEditorFactory</code> is used
		 * instead. The text editor must be an instance of
		 * <code>ITextEditor</code>. This factory can be used to change
		 * properties on the text editor when it is first created. For instance,
		 * if you are skinning Feathers components without a theme, you might
		 * use this factory to set styles on the text editor.
		 *
		 * <p>The factory should have the following function signature:</p>
		 * <pre>function():ITextEditor</pre>
		 *
		 * <p>In the following example, a custom text editor factory is passed
		 * to the text input:</p>
		 *
		 * <listing version="3.0">
		 * input.textEditorFactory = function():ITextEditor
		 * {
		 *     return new TextFieldTextEditor();
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.core.ITextEditor
		 * @see feathers.core.FeathersControl#defaultTextEditorFactory
		 */
		public function get textEditorFactory():Function
		{
			return this._textEditorFactory;
		}

		/**
		 * @private
		 */
		public function set textEditorFactory(value:Function):void
		{
			if(this._textEditorFactory == value)
			{
				return;
			}
			this._textEditorFactory = value;
			this.invalidate(INVALIDATION_FLAG_TEXT_EDITOR);
		}

		/**
		 * @private
		 */
		protected var _customTextEditorStyleName:String;

		/**
		 * @private
		 */
		public function get customTextEditorStyleName():String
		{
			return this._customTextEditorStyleName;
		}

		/**
		 * @private
		 */
		public function set customTextEditorStyleName(value:String):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._customTextEditorStyleName === value)
			{
				return;
			}
			this._customTextEditorStyleName = value;
			this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
		}

		/**
		 * @private
		 */
		protected var _promptFontStylesSet:FontStylesSet;

		/**
		 * @private
		 */
		public function get promptFontStyles():TextFormat
		{
			return this._promptFontStylesSet.format;
		}

		/**
		 * @private
		 */
		public function set promptFontStyles(value:TextFormat):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			var savedCallee:Function = arguments.callee;
			function changeHandler(event:Event):void
			{
				processStyleRestriction(savedCallee);
			}
			var oldValue:TextFormat = this._promptFontStylesSet.format;
			if(oldValue !== null)
			{
				oldValue.removeEventListener(Event.CHANGE, changeHandler);
			}
			this._promptFontStylesSet.format = value;
			if(value !== null)
			{
				value.addEventListener(Event.CHANGE, changeHandler);
			}
		}

		/**
		 * @private
		 */
		public function get promptDisabledFontStyles():TextFormat
		{
			return this._promptFontStylesSet.disabledFormat;
		}

		/**
		 * @private
		 */
		public function set promptDisabledFontStyles(value:TextFormat):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			var savedCallee:Function = arguments.callee;
			function changeHandler(event:Event):void
			{
				processStyleRestriction(savedCallee);
			}
			var oldValue:TextFormat = this._promptFontStylesSet.disabledFormat;
			if(oldValue !== null)
			{
				oldValue.removeEventListener(Event.CHANGE, changeHandler);
			}
			this._promptFontStylesSet.disabledFormat = value;
			if(value !== null)
			{
				value.addEventListener(Event.CHANGE, changeHandler);
			}
		}

		/**
		 * @private
		 */
		protected var _promptFactory:Function;

		/**
		 * A function used to instantiate the prompt text renderer. If null,
		 * <code>FeathersControl.defaultTextRendererFactory</code> is used
		 * instead. The prompt text renderer must be an instance of
		 * <code>ITextRenderer</code>. This factory can be used to change
		 * properties on the prompt when it is first created. For instance, if
		 * you are skinning Feathers components without a theme, you might use
		 * this factory to set styles on the prompt.
		 *
		 * <p>The factory should have the following function signature:</p>
		 * <pre>function():ITextRenderer</pre>
		 *
		 * <p>If the <code>prompt</code> property is <code>null</code>, the
		 * prompt text renderer will not be created.</p>
		 *
		 * <p>In the following example, a custom prompt factory is passed to the
		 * text input:</p>
		 *
		 * <listing version="3.0">
		 * input.promptFactory = function():ITextRenderer
		 * {
		 *     return new TextFieldTextRenderer();
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see #prompt
		 * @see feathers.core.ITextRenderer
		 * @see feathers.core.FeathersControl#defaultTextRendererFactory
		 */
		public function get promptFactory():Function
		{
			return this._promptFactory;
		}

		/**
		 * @private
		 */
		public function set promptFactory(value:Function):void
		{
			if(this._promptFactory == value)
			{
				return;
			}
			this._promptFactory = value;
			this.invalidate(INVALIDATION_FLAG_PROMPT_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _customPromptStyleName:String;

		/**
		 * @private
		 */
		public function get customPromptStyleName():String
		{
			return this._customPromptStyleName;
		}

		/**
		 * @private
		 */
		public function set customPromptStyleName(value:String):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._customPromptStyleName === value)
			{
				return;
			}
			this._customPromptStyleName = value;
			this.invalidate(INVALIDATION_FLAG_PROMPT_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _promptProperties:PropertyProxy;

		/**
		 * An object that stores properties for the input's prompt text
		 * renderer sub-component, and the properties will be passed down to the
		 * text renderer when the input validates. The available properties
		 * depend on which <code>ITextRenderer</code> implementation is returned
		 * by <code>messageFactory</code>. Refer to
		 * <a href="../core/ITextRenderer.html"><code>feathers.core.ITextRenderer</code></a>
		 * for a list of available text renderer implementations.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
		 * which is in a <code>List</code>, you can use the following syntax:</p>
		 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * <p>Setting properties in a <code>promptFactory</code> function
		 * instead of using <code>promptProperties</code> will result in
		 * better performance.</p>
		 *
		 * <p>In the following example, the text input's prompt's properties are
		 * updated (this example assumes that the prompt text renderer is a
		 * <code>TextFieldTextRenderer</code>):</p>
		 *
		 * <listing version="3.0">
		 * input.promptProperties.textFormat = new TextFormat( "Source Sans Pro", 16, 0x333333 );
		 * input.promptProperties.embedFonts = true;</listing>
		 *
		 * @default null
		 *
		 * @see #prompt
		 * @see #promptFactory
		 * @see feathers.core.ITextRenderer
		 */
		public function get promptProperties():Object
		{
			if(!this._promptProperties)
			{
				this._promptProperties = new PropertyProxy(childProperties_onChange);
			}
			return this._promptProperties;
		}

		/**
		 * @private
		 */
		public function set promptProperties(value:Object):void
		{
			if(this._promptProperties == value)
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
			if(this._promptProperties)
			{
				this._promptProperties.removeOnChangeCallback(childProperties_onChange);
			}
			this._promptProperties = PropertyProxy(value);
			if(this._promptProperties)
			{
				this._promptProperties.addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		/**
		 * @private
		 */
		protected var _errorCalloutFactory:Function;
		
		/**
		 * A function used to instantiate the error text callout. If null,
		 * <code>new TextCallout()</code> is used instead.
		 * The error text callout must be an instance of
		 * <code>TextCallout</code>. This factory can be used to change
		 * properties on the callout when it is first created. For instance, if
		 * you are skinning Feathers components without a theme, you might use
		 * this factory to set styles on the callout.
		 *
		 * <p>The factory should have the following function signature:</p>
		 * <pre>function():TextCallout</pre>
		 *
		 * <p>In the following example, a custom error callout factory is passed
		 * to the text input:</p>
		 *
		 * <listing version="3.0">
		 * input.errorCalloutFactory = function():TextCallout
		 * {
		 *     return new TextCallout();
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see #errorString
		 * @see feathers.controls.TextCallout
		 */
		public function get errorCalloutFactory():Function
		{
			return this._errorCalloutFactory;
		}
		
		public function set errorCalloutFactory(value:Function):void
		{
			if(this._errorCalloutFactory == value)
			{
				return;
			}
			this._errorCalloutFactory = value;
			this.invalidate(INVALIDATION_FLAG_ERROR_CALLOUT_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _customErrorCalloutStyleName:String;

		/**
		 * @private
		 */
		public function get customErrorCalloutStyleName():String
		{
			return this._customErrorCalloutStyleName;
		}

		/**
		 * @private
		 */
		public function set customErrorCalloutStyleName(value:String):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._customErrorCalloutStyleName === value)
			{
				return;
			}
			this._customErrorCalloutStyleName = value;
			this.invalidate(INVALIDATION_FLAG_ERROR_CALLOUT_FACTORY);
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
				return;
			}
			if(this._backgroundSkin === value)
			{
				return;
			}
			if(this._backgroundSkin !== null &&
				this.currentBackground === this._backgroundSkin)
			{
				//if this skin needs to be reused somewhere else, we need to
				//properly clean it up
				this.removeCurrentBackground(this._backgroundSkin);
				this.currentBackground = null;
			}
			this._backgroundSkin = value;
			this.invalidate(INVALIDATION_FLAG_SKIN);
		}

		/**
		 * @private
		 */
		protected var _stateToSkin:Object = {};

		/**
		 * @private
		 */
		public function get backgroundEnabledSkin():DisplayObject
		{
			return this.getSkinForState(TextInputState.ENABLED);
		}

		/**
		 * @private
		 */
		public function set backgroundEnabledSkin(value:DisplayObject):void
		{
			this.setSkinForState(TextInputState.ENABLED, value);
		}

		/**
		 * @private
		 */
		public function get backgroundFocusedSkin():DisplayObject
		{
			return this.getSkinForState(TextInputState.FOCUSED);
		}

		/**
		 * @private
		 */
		public function set backgroundFocusedSkin(value:DisplayObject):void
		{
			this.setSkinForState(TextInputState.FOCUSED, value);
		}

		/**
		 * @private
		 */
		public function get backgroundErrorSkin():DisplayObject
		{
			return this.getSkinForState(TextInputState.ERROR);
		}

		/**
		 * @private
		 */
		public function set backgroundErrorSkin(value:DisplayObject):void
		{
			this.setSkinForState(TextInputState.ERROR, value);
		}

		/**
		 * @private
		 */
		public function get backgroundDisabledSkin():DisplayObject
		{
			return this.getSkinForState(TextInputState.DISABLED);
		}

		/**
		 * @private
		 */
		public function set backgroundDisabledSkin(value:DisplayObject):void
		{
			this.setSkinForState(TextInputState.DISABLED, value);
		}

		/**
		 * @private
		 * The width of the first icon that was displayed.
		 */
		protected var _originalIconWidth:Number = NaN;

		/**
		 * @private
		 * The height of the first icon that was displayed.
		 */
		protected var _originalIconHeight:Number = NaN;

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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._defaultIcon === value)
			{
				return;
			}
			this._defaultIcon = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _stateToIcon:Object = {};

		/**
		 * @private
		 */
		public function get enabledIcon():DisplayObject
		{
			return this.getIconForState(TextInputState.ENABLED);
		}

		/**
		 * @private
		 */
		public function set enabledIcon(value:DisplayObject):void
		{
			this.setIconForState(TextInputState.ENABLED, value);
		}

		/**
		 * @private
		 */
		public function get disabledIcon():DisplayObject
		{
			return this.getIconForState(TextInputState.DISABLED);
		}

		/**
		 * @private
		 */
		public function set disabledIcon(value:DisplayObject):void
		{
			this.setIconForState(TextInputState.DISABLED, value);
		}

		/**
		 * @private
		 */
		public function get focusedIcon():DisplayObject
		{
			return this.getIconForState(TextInputState.FOCUSED);
		}

		/**
		 * @private
		 */
		public function set focusedIcon(value:DisplayObject):void
		{
			this.setIconForState(TextInputState.FOCUSED, value);
		}

		/**
		 * @private
		 */
		public function get errorIcon():DisplayObject
		{
			return this.getIconForState(TextInputState.ERROR);
		}

		/**
		 * @private
		 */
		public function set errorIcon(value:DisplayObject):void
		{
			this.setIconForState(TextInputState.ERROR, value);
		}

		/**
		 * @private
		 */
		protected var _iconPosition:String = RelativePosition.LEFT;

		[Inspectable(type="String",enumeration="left,right")]
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._iconPosition === value)
			{
				return;
			}
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._gap == value)
			{
				return;
			}
			this._gap = value;
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
		protected var _verticalAlign:String = VerticalAlign.MIDDLE;

		[Inspectable(type="String",enumeration="top,middle,bottom,justify")]
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
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 * Flag indicating that the text editor should get focus after it is
		 * created.
		 */
		protected var _isWaitingToSetFocus:Boolean = false;

		/**
		 * @private
		 */
		protected var _pendingSelectionBeginIndex:int = -1;

		/**
		 * @private
		 */
		protected var _pendingSelectionEndIndex:int = -1;

		/**
		 * @private
		 */
		protected var _oldMouseCursor:String = null;

		/**
		 * @private
		 */
		protected var _textEditorProperties:PropertyProxy;

		/**
		 * An object that stores properties for the input's text editor
		 * sub-component, and the properties will be passed down to the
		 * text editor when the input validates. The available properties
		 * depend on which <code>ITextEditor</code> implementation is returned
		 * by <code>textEditorFactory</code>. Refer to
		 * <a href="../core/ITextEditor.html"><code>feathers.core.ITextEditor</code></a>
		 * for a list of available text editor implementations.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
		 * which is in a <code>List</code>, you can use the following syntax:</p>
		 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * <p>Setting properties in a <code>textEditorFactory</code> function
		 * instead of using <code>textEditorProperties</code> will result in
		 * better performance.</p>
		 *
		 * <p>In the following example, the text input's text editor properties
		 * are specified (this example assumes that the text editor is a
		 * <code>StageTextTextEditor</code>):</p>
		 *
		 * <listing version="3.0">
		 * input.textEditorProperties.fontName = "Helvetica";
		 * input.textEditorProperties.fontSize = 16;</listing>
		 *
		 * @default null
		 *
		 * @see #textEditorFactory
		 * @see feathers.core.ITextEditor
		 */
		public function get textEditorProperties():Object
		{
			if(!this._textEditorProperties)
			{
				this._textEditorProperties = new PropertyProxy(childProperties_onChange);
			}
			return this._textEditorProperties;
		}

		/**
		 * @private
		 */
		public function set textEditorProperties(value:Object):void
		{
			if(this._textEditorProperties == value)
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
			if(this._textEditorProperties)
			{
				this._textEditorProperties.removeOnChangeCallback(childProperties_onChange);
			}
			this._textEditorProperties = PropertyProxy(value);
			if(this._textEditorProperties)
			{
				this._textEditorProperties.addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @copy feathers.core.ITextEditor#selectionBeginIndex
		 */
		public function get selectionBeginIndex():int
		{
			if(this._pendingSelectionBeginIndex >= 0)
			{
				return this._pendingSelectionBeginIndex;
			}
			if(this.textEditor)
			{
				return this.textEditor.selectionBeginIndex;
			}
			return 0;
		}

		/**
		 * @copy feathers.core.ITextEditor#selectionEndIndex
		 */
		public function get selectionEndIndex():int
		{
			if(this._pendingSelectionEndIndex >= 0)
			{
				return this._pendingSelectionEndIndex;
			}
			if(this.textEditor)
			{
				return this.textEditor.selectionEndIndex;
			}
			return 0;
		}

		/**
		 * @private
		 */
		override public function set visible(value:Boolean):void
		{
			if(!value)
			{
				this._isWaitingToSetFocus = false;
			}
			super.visible = value;
			//call clearFocus() after setting super.visible because the text
			//editor may check the visible property
			if(!value && this._textEditorHasFocus)
			{
				this.textEditor.clearFocus();
			}
		}

		/**
		 * @private
		 */
		override public function hitTest(localPoint:Point):DisplayObject
		{
			if(!this.visible || !this.touchable)
			{
				return null;
			}
			if(this.mask && !this.hitTestMask(localPoint))
			{
				return null;
			}
			return this._hitArea.containsPoint(localPoint) ? DisplayObject(this.textEditor) : null;
		}

		/**
		 * Focuses the text input control so that it may be edited, and selects
		 * all of its text. Call <code>selectRange()</code> after
		 * <code>setFocus()</code> to select a different range.
		 *
		 * @see #selectRange()
		 */
		public function setFocus():void
		{
			//if the text editor has focus, no need to set focus
			//if this is invisible, it wouldn't make sense to set focus
			//if there's a touch point ID, we'll be setting focus on our own
			if(this._textEditorHasFocus || !this.visible || this._touchPointID >= 0)
			{
				return;
			}
			if(this._isEditable || this._isSelectable)
			{
				this.selectRange(0, this._text.length);
			}
			if(this.textEditor)
			{
				this._isWaitingToSetFocus = false;
				this.textEditor.setFocus();
			}
			else
			{
				this._isWaitingToSetFocus = true;
				this.invalidate(INVALIDATION_FLAG_SELECTED);
			}
		}

		/**
		 * Manually removes focus from the text input control.
		 */
		public function clearFocus():void
		{
			this._isWaitingToSetFocus = false;
			if(!this.textEditor || !this._textEditorHasFocus)
			{
				return;
			}
			this.textEditor.clearFocus();
		}

		/**
		 * Sets the range of selected characters. If both values are the same,
		 * or the end index is <code>-1</code>, the text insertion position is
		 * changed and nothing is selected.
		 */
		public function selectRange(beginIndex:int, endIndex:int = -1):void
		{
			if(endIndex < 0)
			{
				endIndex = beginIndex;
			}
			if(beginIndex < 0)
			{
				throw new RangeError("Expected begin index >= 0. Received " + beginIndex + ".");
			}
			if(endIndex > this._text.length)
			{
				throw new RangeError("Expected end index <= " + this._text.length + ". Received " + endIndex + ".");
			}

			//if it's invalid, we need to wait until validation before changing
			//the selection
			if(this.textEditor && (this._isValidating || !this.isInvalid()))
			{
				this._pendingSelectionBeginIndex = -1;
				this._pendingSelectionEndIndex = -1;
				this.textEditor.selectRange(beginIndex, endIndex);
			}
			else
			{
				this._pendingSelectionBeginIndex = beginIndex;
				this._pendingSelectionEndIndex = endIndex;
				this.invalidate(INVALIDATION_FLAG_SELECTED);
			}
		}

		/**
		 * Gets the font styles to be used to display the input's text when the
		 * input's <code>currentState</code> property matches the specified
		 * state value.
		 *
		 * <p>If font styles are not defined for a specific state, returns
		 * <code>null</code>.</p>
		 *
		 * @see http://doc.starling-framework.org/current/starling/text/TextFormat.html starling.text.TextFormat
		 * @see #setFontStylesForState()
		 * @see #style:fontStyles
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
		 * Sets the font styles to be used to display the input's text when the
		 * input's <code>currentState</code> property matches the specified
		 * state value.
		 *
		 * <p>If font styles are not defined for a specific state, the value of
		 * the <code>fontStyles</code> property will be used instead.</p>
		 *
		 * <p>Note: if the text editor has been customized with advanced font
		 * formatting, it may override the values specified with
		 * <code>setFontStylesForState()</code> and properties like
		 * <code>fontStyles</code> and <code>disabledFontStyles</code>.</p>
		 *
		 * @see http://doc.starling-framework.org/current/starling/text/TextFormat.html starling.text.TextFormat
		 * @see #style:fontStyles
		 */
		public function setFontStylesForState(state:String, format:TextFormat):void
		{
			var key:String = "setFontStylesForState--" + state;
			if(this.processStyleRestriction(key))
			{
				return;
			}
			function changeHandler(event:Event):void
			{
				processStyleRestriction(key);
			}
			var oldFormat:TextFormat = this._fontStylesSet.getFormatForState(state);
			if(oldFormat !== null)
			{
				oldFormat.removeEventListener(Event.CHANGE, changeHandler);
			}
			this._fontStylesSet.setFormatForState(state, format);
			if(format !== null)
			{
				format.addEventListener(Event.CHANGE, changeHandler);
			}
		}

		/**
		 * Gets the font styles to be used to display the input's prompt when
		 * the input's <code>currentState</code> property matches the specified
		 * state value.
		 *
		 * <p>If prompt font styles are not defined for a specific state, returns
		 * <code>null</code>.</p>
		 *
		 * @see http://doc.starling-framework.org/current/starling/text/TextFormat.html starling.text.TextFormat
		 * @see #setPromptFontStylesForState()
		 * @see #promptFontStyles
		 */
		public function getPromptFontStylesForState(state:String):TextFormat
		{
			if(this._promptFontStylesSet === null)
			{
				return null;
			}
			return this._promptFontStylesSet.getFormatForState(state);
		}

		/**
		 * Sets the font styles to be used to display the input's prompt when
		 * the input's <code>currentState</code> property matches the specified
		 * state value.
		 *
		 * <p>If prompt font styles are not defined for a specific state, the
		 * value of the <code>promptFontStyles</code> property will be used instead.</p>
		 *
		 * <p>Note: if the text renderer has been customized with advanced font
		 * formatting, it may override the values specified with
		 * <code>setPromptFontStylesForState()</code> and properties like
		 * <code>promptFontStyles</code> and <code>promptDisabledFontStyles</code>.</p>
		 *
		 * @see http://doc.starling-framework.org/current/starling/text/TextFormat.html starling.text.TextFormat
		 * @see #promptFontStyles
		 */
		public function setPromptFontStylesForState(state:String, format:TextFormat):void
		{
			var key:String = "setPromptFontStylesForState--" + state;
			if(this.processStyleRestriction(key))
			{
				return;
			}
			function changeHandler(event:Event):void
			{
				processStyleRestriction(key);
			}
			var oldFormat:TextFormat = this._promptFontStylesSet.getFormatForState(state);
			if(oldFormat !== null)
			{
				oldFormat.removeEventListener(Event.CHANGE, changeHandler);
			}
			this._promptFontStylesSet.setFormatForState(state, format);
			if(format !== null)
			{
				format.addEventListener(Event.CHANGE, changeHandler);
			}
		}

		/**
		 * Gets the skin to be used by the text input when the input's
		 * <code>currentState</code> property matches the specified state value.
		 *
		 * <p>If a skin is not defined for a specific state, returns
		 * <code>null</code>.</p>
		 *
		 * @see #setSkinForState()
		 * @see feathers.controls.TextInputState
		 */
		public function getSkinForState(state:String):DisplayObject
		{
			return this._stateToSkin[state] as DisplayObject;
		}

		/**
		 * Sets the skin to be used by the text input when the input's
		 * <code>currentState</code> property matches the specified state value.
		 *
		 * <p>If a skin is not defined for a specific state, the value of the
		 * <code>backgroundSkin</code> property will be used instead.</p>
		 *
		 * @see #backgroundSkin
		 * @see #getSkinForState()
		 * @see feathers.controls.TextInputState
		 */
		public function setSkinForState(state:String, skin:DisplayObject):void
		{
			var key:String = "setSkinForState--" + state;
			if(this.processStyleRestriction(key))
			{
				if(skin !== null)
				{
					skin.dispose();
				}
				return;
			}
			var oldSkin:DisplayObject = this._stateToSkin[state] as DisplayObject;
			if(oldSkin !== null &&
				this.currentBackground === oldSkin)
			{
				//if this skin needs to be reused somewhere else, we need to
				//properly clean it up
				this.removeCurrentBackground(oldSkin);
				this.currentBackground = null;
			}
			if(skin !== null)
			{
				this._stateToSkin[state] = skin;
			}
			else
			{
				delete this._stateToSkin[state];
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * Gets the icon to be used by the text input when the input's
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
		 * Sets the icon to be used by the text input when the input's
		 * <code>currentState</code> property matches the specified state value.
		 *
		 * <p>If an icon is not defined for a specific state, the value of the
		 * <code>defaultIcon</code> property will be used instead.</p>
		 *
		 * @see #defaultIcon
		 * @see #getIconForState()
		 */
		public function setIconForState(state:String, icon:DisplayObject):void
		{
			var key:String = "setIconForState--" + state;
			if(this.processStyleRestriction(key))
			{
				if(icon !== null)
				{
					icon.dispose();
				}
				return;
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
		override public function dispose():void
		{
			//we don't dispose it if the text input is the parent because it'll
			//already get disposed in super.dispose()
			if(this._backgroundSkin !== null && this._backgroundSkin.parent !== this)
			{
				this._backgroundSkin.dispose();
			}
			for(var state:String in this._stateToSkin)
			{
				var skin:DisplayObject = this._stateToSkin[state] as DisplayObject;
				if(skin !== null && skin.parent !== this)
				{
					skin.dispose();
				}
			}
			if(this._defaultIcon !== null && this._defaultIcon.parent !== this)
			{
				this._defaultIcon.dispose();
			}
			for(state in this._stateToIcon)
			{
				var icon:DisplayObject = this._stateToIcon[state] as DisplayObject;
				if(icon !== null && icon.parent !== this)
				{
					icon.dispose();
				}
			}
			if(this._fontStylesSet !== null)
			{
				this._fontStylesSet.dispose();
				this._fontStylesSet = null;
			}
			if(this._promptFontStylesSet !== null)
			{
				this._promptFontStylesSet.dispose();
				this._promptFontStylesSet = null;
			}
			super.dispose();
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			var stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			var stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			var skinInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SKIN);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			var textEditorInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_TEXT_EDITOR);
			var promptFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_PROMPT_FACTORY);
			var focusInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_FOCUS);

			if(textEditorInvalid)
			{
				this.createTextEditor();
			}

			if(promptFactoryInvalid || (this._prompt !== null && !this.promptTextRenderer))
			{
				this.createPrompt();
			}

			if(textEditorInvalid || stylesInvalid)
			{
				this.refreshTextEditorProperties();
			}

			if(promptFactoryInvalid || stylesInvalid)
			{
				this.refreshPromptProperties();
			}

			if(textEditorInvalid || dataInvalid)
			{
				var oldIgnoreTextChanges:Boolean = this._ignoreTextChanges;
				this._ignoreTextChanges = true;
				this.textEditor.text = this._text;
				this._ignoreTextChanges = oldIgnoreTextChanges;
			}

			if(this.promptTextRenderer)
			{
				if(promptFactoryInvalid || dataInvalid || stylesInvalid)
				{
					this.promptTextRenderer.visible = this._prompt && this._text.length == 0;
				}

				if(promptFactoryInvalid || stateInvalid)
				{
					this.promptTextRenderer.isEnabled = this._isEnabled;
				}
			}

			if(textEditorInvalid || stateInvalid)
			{
				this.textEditor.isEnabled = this._isEnabled;
				if(!this._isEnabled && Mouse.supportsNativeCursor && this._oldMouseCursor)
				{
					Mouse.cursor = this._oldMouseCursor;
					this._oldMouseCursor = null;
				}
			}

			if(stateInvalid || skinInvalid)
			{
				this.refreshBackgroundSkin();
			}
			if(stateInvalid || stylesInvalid)
			{
				this.refreshIcon();
			}

			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

			this.layoutChildren();

			//the state might not change if the text input has focus when
			//the error string changes, so check for styles too!
			if(stateInvalid || stylesInvalid)
			{
				this.refreshErrorCallout();
			}

			if(sizeInvalid || focusInvalid)
			{
				this.refreshFocusIndicator();
			}

			this.doPendingActions();
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

			var measureBackground:IMeasureDisplayObject = this.currentBackground as IMeasureDisplayObject;
			resetFluidChildDimensionsForMeasurement(this.currentBackground,
				this._explicitWidth, this._explicitHeight,
				this._explicitMinWidth, this._explicitMinHeight,
				this._explicitMaxWidth, this._explicitMaxHeight,
				this._explicitBackgroundWidth, this._explicitBackgroundHeight,
				this._explicitBackgroundMinWidth, this._explicitBackgroundMinHeight,
				this._explicitBackgroundMaxWidth, this._explicitBackgroundMaxHeight);
			if(this.currentBackground is IValidating)
			{
				IValidating(this.currentBackground).validate();
			}
			if(this.currentIcon is IValidating)
			{
				IValidating(this.currentIcon).validate();
			}

			var measuredContentWidth:Number = 0;
			var measuredContentHeight:Number = 0;

			//if the typicalText is specified, the dimensions of the text editor
			//can affect the final dimensions. otherwise, the background skin or
			//prompt should be used for measurement.
			if(this._typicalText !== null)
			{
				var point:Point = Pool.getPoint();
				var oldTextEditorWidth:Number = this.textEditor.width;
				var oldTextEditorHeight:Number = this.textEditor.height;
				var oldIgnoreTextChanges:Boolean = this._ignoreTextChanges;
				this._ignoreTextChanges = true;
				this.textEditor.setSize(NaN, NaN);
				this.textEditor.text = this._typicalText;
				this.textEditor.measureText(point);
				this.textEditor.text = this._text;
				this._ignoreTextChanges = oldIgnoreTextChanges;
				measuredContentWidth = point.x;
				measuredContentHeight = point.y;
				Pool.putPoint(point);
			}
			if(this._prompt !== null)
			{
				point = Pool.getPoint();
				this.promptTextRenderer.setSize(NaN, NaN);
				this.promptTextRenderer.measureText(point);
				if(point.x > measuredContentWidth)
				{
					measuredContentWidth = point.x;
				}
				if(point.y > measuredContentHeight)
				{
					measuredContentHeight = point.y;
				}
				Pool.putPoint(point);
			}

			var newWidth:Number = this._explicitWidth;
			if(needsWidth)
			{
				newWidth = measuredContentWidth;
				if(this._originalIconWidth === this._originalIconWidth) //!isNaN
				{
					newWidth += this._originalIconWidth + this._gap;
				}
				newWidth += this._paddingLeft + this._paddingRight;
				if(this.currentBackground !== null &&
					this.currentBackground.width > newWidth)
				{
					newWidth = this.currentBackground.width;
				}
			}
			var newHeight:Number = this._explicitHeight;
			if(needsHeight)
			{
				newHeight = measuredContentHeight;
				if(this._originalIconHeight === this._originalIconHeight && //!isNaN
					this._originalIconHeight > newHeight)
				{
					newHeight = this._originalIconHeight;
				}
				newHeight += this._paddingTop + this._paddingBottom;
				if(this.currentBackground !== null &&
					this.currentBackground.height > newHeight)
				{
					newHeight = this.currentBackground.height;
				}
			}

			var newMinWidth:Number = this._explicitMinWidth;
			if(needsMinWidth)
			{
				newMinWidth = measuredContentWidth;
				if(this.currentIcon is IFeathersControl)
				{
					newMinWidth += IFeathersControl(this.currentIcon).minWidth + this._gap;
				}
				else if(this._originalIconWidth === this._originalIconWidth)
				{
					newMinWidth += this._originalIconWidth + this._gap;
				}
				newMinWidth += this._paddingLeft + this._paddingRight;
				var backgroundMinWidth:Number = 0;
				if(measureBackground !== null)
				{
					backgroundMinWidth = measureBackground.minWidth;
				}
				else if(this.currentBackground !== null)
				{
					backgroundMinWidth = this._explicitBackgroundMinWidth;
				}
				if(backgroundMinWidth > newMinWidth)
				{
					newMinWidth = backgroundMinWidth;
				}
			}
			var newMinHeight:Number = this._explicitMinHeight;
			if(needsMinHeight)
			{
				newMinHeight = measuredContentHeight;
				if(this.currentIcon is IFeathersControl)
				{
					var iconMinHeight:Number = IFeathersControl(this.currentIcon).minHeight;
					if(iconMinHeight > newMinHeight)
					{
						newMinHeight = iconMinHeight;
					}
				}
				else if(this._originalIconHeight === this._originalIconHeight && //!isNaN
					this._originalIconHeight > newMinHeight)
				{
					newMinHeight = this._originalIconHeight;
				}
				newMinHeight += this._paddingTop + this._paddingBottom;
				var backgroundMinHeight:Number = 0;
				if(measureBackground !== null)
				{
					backgroundMinHeight = measureBackground.minHeight;
				}
				else if(this.currentBackground !== null)
				{
					backgroundMinHeight = this._explicitBackgroundMinHeight;
				}
				if(backgroundMinHeight > newMinHeight)
				{
					newMinHeight = backgroundMinHeight;
				}
			}

			var isMultiline:Boolean = this.textEditor is IMultilineTextEditor && IMultilineTextEditor(this.textEditor).multiline;
			if(this._typicalText !== null && (this._verticalAlign == VerticalAlign.JUSTIFY || isMultiline))
			{
				this.textEditor.width = oldTextEditorWidth;
				this.textEditor.height = oldTextEditorHeight;
			}

			return this.saveMeasurements(newWidth, newHeight, newMinWidth, newMinHeight);
		}

		/**
		 * Creates and adds the <code>textEditor</code> sub-component and
		 * removes the old instance, if one exists.
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 *
		 * @see #textEditor
		 * @see #textEditorFactory
		 */
		protected function createTextEditor():void
		{
			if(this.textEditor)
			{
				this.removeChild(DisplayObject(this.textEditor), true);
				this.textEditor.removeEventListener(Event.CHANGE, textEditor_changeHandler);
				this.textEditor.removeEventListener(FeathersEventType.ENTER, textEditor_enterHandler);
				this.textEditor.removeEventListener(FeathersEventType.FOCUS_IN, textEditor_focusInHandler);
				this.textEditor.removeEventListener(FeathersEventType.FOCUS_OUT, textEditor_focusOutHandler);
				this.textEditor = null;
			}

			var factory:Function = this._textEditorFactory != null ? this._textEditorFactory : FeathersControl.defaultTextEditorFactory;
			this.textEditor = ITextEditor(factory());
			var textEditorStyleName:String = this._customTextEditorStyleName != null ? this._customTextEditorStyleName : this.textEditorStyleName;
			this.textEditor.styleNameList.add(textEditorStyleName);
			if(this.textEditor is IStateObserver)
			{
				IStateObserver(this.textEditor).stateContext = this;
			}
			this.textEditor.addEventListener(Event.CHANGE, textEditor_changeHandler);
			this.textEditor.addEventListener(FeathersEventType.ENTER, textEditor_enterHandler);
			this.textEditor.addEventListener(FeathersEventType.FOCUS_IN, textEditor_focusInHandler);
			this.textEditor.addEventListener(FeathersEventType.FOCUS_OUT, textEditor_focusOutHandler);
			this.addChild(DisplayObject(this.textEditor));
		}

		/**
		 * @private
		 */
		protected function createPrompt():void
		{
			if(this.promptTextRenderer)
			{
				this.removeChild(DisplayObject(this.promptTextRenderer), true);
				this.promptTextRenderer = null;
			}

			if(this._prompt === null)
			{
				return;
			}

			var factory:Function = this._promptFactory != null ? this._promptFactory : FeathersControl.defaultTextRendererFactory;
			this.promptTextRenderer = ITextRenderer(factory());
			var promptStyleName:String = this._customPromptStyleName != null ? this._customPromptStyleName : this.promptStyleName;
			this.promptTextRenderer.styleNameList.add(promptStyleName);
			this.addChild(DisplayObject(this.promptTextRenderer));
		}

		/**
		 * @private
		 */
		protected function createErrorCallout():void
		{
			if(this.callout !== null)
			{
				this.callout.removeFromParent(true);
				this.callout = null;
			}

			if(this._errorString === null)
			{
				return;
			}
			
			var factory:Function = this._errorCalloutFactory != null ? this._errorCalloutFactory : defaultErrorCalloutFactory;
			this.callout = TextCallout(factory());
			var errorCalloutStyleName:String = this._customErrorCalloutStyleName != null ? this._customErrorCalloutStyleName : this.errorCalloutStyleName;
			this.callout.styleNameList.add(errorCalloutStyleName);
			this.callout.closeOnKeys = null;
			this.callout.closeOnTouchBeganOutside = false;
			this.callout.closeOnTouchEndedOutside = false;
			this.callout.touchable = false;
			this.callout.origin = this;
			PopUpManager.addPopUp(this.callout, false, false);
		}

		/**
		 * @private
		 */
		protected function changeState(state:String):void
		{
			if(this._currentState === state)
			{
				return;
			}
			this._currentState = state;
			this.invalidate(INVALIDATION_FLAG_STATE);
			this.dispatchEventWith(FeathersEventType.STATE_CHANGE);
		}

		/**
		 * @private
		 */
		protected function doPendingActions():void
		{
			if(this._isWaitingToSetFocus)
			{
				this._isWaitingToSetFocus = false;
				if(!this._textEditorHasFocus)
				{
					if((this._isEditable || this._isSelectable) &&
						this._pendingSelectionBeginIndex < 0)
					{
						this._pendingSelectionBeginIndex = 0;
						this._pendingSelectionEndIndex = this._text.length;
					}
					this.textEditor.setFocus();
				}
			}
			if(this._pendingSelectionBeginIndex >= 0)
			{
				var startIndex:int = this._pendingSelectionBeginIndex;
				var endIndex:int = this._pendingSelectionEndIndex;
				this._pendingSelectionBeginIndex = -1;
				this._pendingSelectionEndIndex = -1;
				if(endIndex >= 0)
				{
					var textLength:int = this._text.length;
					if(endIndex > textLength)
					{
						endIndex = textLength;
					}
				}
				this.selectRange(startIndex, endIndex);
			}
		}

		/**
		 * @private
		 */
		protected function refreshTextEditorProperties():void
		{
			this.textEditor.displayAsPassword = this._displayAsPassword;
			this.textEditor.maxChars = this._maxChars;
			this.textEditor.restrict = this._restrict;
			this.textEditor.isEditable = this._isEditable;
			this.textEditor.isSelectable = this._isSelectable;
			this.textEditor.fontStyles = this._fontStylesSet;
			for(var propertyName:String in this._textEditorProperties)
			{
				var propertyValue:Object = this._textEditorProperties[propertyName];
				this.textEditor[propertyName] = propertyValue;
			}
		}

		/**
		 * @private
		 */
		protected function refreshPromptProperties():void
		{
			if(!this.promptTextRenderer)
			{
				return;
			}
			this.promptTextRenderer.text = this._prompt;
			this.promptTextRenderer.fontStyles = this._promptFontStylesSet;
			for(var propertyName:String in this._promptProperties)
			{
				var propertyValue:Object = this._promptProperties[propertyName];
				this.promptTextRenderer[propertyName] = propertyValue;
			}
		}

		/**
		 * Sets the <code>currentBackground</code> property.
		 *
		 * <p>For internal use in subclasses.</p>
		 */
		protected function refreshBackgroundSkin():void
		{
			var oldSkin:DisplayObject = this.currentBackground;
			this.currentBackground = this.getCurrentSkin();
			if(this.currentBackground !== oldSkin)
			{
				this.removeCurrentBackground(oldSkin);
				if(this.currentBackground !== null)
				{
					if(this.currentBackground is IStateObserver)
					{
						IStateObserver(this.currentBackground).stateContext = this;
					}
					if(this.currentBackground is IFeathersControl)
					{
						IFeathersControl(this.currentBackground).initializeNow();
					}
					if(this.currentBackground is IMeasureDisplayObject)
					{
						var measureSkin:IMeasureDisplayObject = IMeasureDisplayObject(this.currentBackground);
						this._explicitBackgroundWidth = measureSkin.explicitWidth;
						this._explicitBackgroundHeight = measureSkin.explicitHeight;
						this._explicitBackgroundMinWidth = measureSkin.explicitMinWidth;
						this._explicitBackgroundMinHeight = measureSkin.explicitMinHeight;
						this._explicitBackgroundMaxWidth = measureSkin.explicitMaxWidth;
						this._explicitBackgroundMaxHeight = measureSkin.explicitMaxHeight;
					}
					else
					{
						this._explicitBackgroundWidth = this.currentBackground.width;
						this._explicitBackgroundHeight = this.currentBackground.height;
						this._explicitBackgroundMinWidth = this._explicitBackgroundWidth;
						this._explicitBackgroundMinHeight = this._explicitBackgroundHeight;
						this._explicitBackgroundMaxWidth = this._explicitBackgroundWidth;
						this._explicitBackgroundMaxHeight = this._explicitBackgroundHeight;
					}
					this.addChildAt(this.currentBackground, 0);
				}
			}
		}

		/**
		 * @private
		 */
		protected function removeCurrentBackground(skin:DisplayObject):void
		{
			if(skin === null)
			{
				return;
			}
			if(skin is IStateObserver)
			{
				IStateObserver(skin).stateContext = null;
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
				skin.removeFromParent(false);
			}
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
				if(oldIcon)
				{
					if(oldIcon is IStateObserver)
					{
						IStateObserver(oldIcon).stateContext = null;
					}
					this.removeChild(oldIcon, false);
				}
				if(this.currentIcon)
				{
					if(this.currentIcon is IStateObserver)
					{
						IStateObserver(this.currentIcon).stateContext = this;
					}
					//we want the icon to appear below the text editor
					var index:int = this.getChildIndex(DisplayObject(this.textEditor));
					this.addChildAt(this.currentIcon, index);
				}
			}
			if(this.currentIcon &&
				(this._originalIconWidth !== this._originalIconWidth || //isNaN
				this._originalIconHeight !== this._originalIconHeight)) //isNaN
			{
				if(this.currentIcon is IValidating)
				{
					IValidating(this.currentIcon).validate();
				}
				this._originalIconWidth = this.currentIcon.width;
				this._originalIconHeight = this.currentIcon.height;
			}
		}

		/**
		 * @private
		 */
		protected function getCurrentSkin():DisplayObject
		{
			var result:DisplayObject = this._stateToSkin[this._currentState] as DisplayObject;
			if(result !== null)
			{
				return result;
			}
			return this._backgroundSkin;
		}

		/**
		 * @private
		 */
		protected function getCurrentIcon():DisplayObject
		{
			var result:DisplayObject = this._stateToIcon[this._currentState] as DisplayObject;
			if(result !== null)
			{
				return result;
			}
			return this._defaultIcon;
		}

		/**
		 * Positions and sizes the text input's children.
		 *
		 * <p>For internal use in subclasses.</p>
		 */
		protected function layoutChildren():void
		{
			if(this.currentBackground !== null)
			{
				this.currentBackground.visible = true;
				this.currentBackground.touchable = true;
				this.currentBackground.width = this.actualWidth;
				this.currentBackground.height = this.actualHeight;
			}

			if(this.currentIcon is IValidating)
			{
				IValidating(this.currentIcon).validate();
			}

			if(this.currentIcon !== null)
			{
				if(this._iconPosition === RelativePosition.RIGHT)
				{
					this.currentIcon.x = this.actualWidth - this.currentIcon.width - this._paddingRight;
					this.textEditor.x = this._paddingLeft;
					if(this.promptTextRenderer !== null)
					{
						this.promptTextRenderer.x = this._paddingLeft;
					}
				}
				else //left
				{
					this.currentIcon.x = this._paddingLeft;
					this.textEditor.x = this.currentIcon.x + this.currentIcon.width + this._gap;
					if(this.promptTextRenderer !== null)
					{
						this.promptTextRenderer.x = this.currentIcon.x + this.currentIcon.width + this._gap;
					}
				}
			}
			else
			{
				this.textEditor.x = this._paddingLeft;
				if(this.promptTextRenderer !== null)
				{
					this.promptTextRenderer.x = this._paddingLeft;
				}
			}

			var textEditorWidth:Number = this.actualWidth - this._paddingRight - this.textEditor.x;
			if(this.currentIcon !== null && this._iconPosition === RelativePosition.RIGHT)
			{
				textEditorWidth -= (this.currentIcon.width + this._gap);
			}
			this.textEditor.width = textEditorWidth;
			if(this.promptTextRenderer !== null)
			{
				this.promptTextRenderer.width = textEditorWidth;
			}

			var isMultiline:Boolean = this.textEditor is IMultilineTextEditor && IMultilineTextEditor(this.textEditor).multiline;
			if(isMultiline || this._verticalAlign === VerticalAlign.JUSTIFY)
			{
				//multiline is treated the same as justify
				this.textEditor.height = this.actualHeight - this._paddingTop - this._paddingBottom;
			}
			else
			{
				//clear the height and auto-size instead
				this.textEditor.height = NaN;
			}
			this.textEditor.validate();
			if(this.promptTextRenderer !== null)
			{
				this.promptTextRenderer.validate();
			}

			var biggerHeight:Number = this.textEditor.height;
			var biggerBaseline:Number = this.textEditor.baseline;
			if(this.promptTextRenderer !== null)
			{
				var promptBaseline:Number = this.promptTextRenderer.baseline;
				var promptHeight:Number = this.promptTextRenderer.height;
				if(promptBaseline > biggerBaseline)
				{
					biggerBaseline = promptBaseline;
				}
				if(promptHeight > biggerHeight)
				{
					biggerHeight = promptHeight;
				}
			}

			if(isMultiline)
			{
				this.textEditor.y = this._paddingTop + biggerBaseline - this.textEditor.baseline;
				if(this.promptTextRenderer !== null)
				{
					this.promptTextRenderer.y = this._paddingTop + biggerBaseline - promptBaseline;
					this.promptTextRenderer.height = this.actualHeight - this.promptTextRenderer.y - this._paddingBottom;
				}
				if(this.currentIcon !== null)
				{
					this.currentIcon.y = this._paddingTop;
				}
			}
			else
			{
				switch(this._verticalAlign)
				{
					case VerticalAlign.JUSTIFY:
					{
						this.textEditor.y = this._paddingTop + biggerBaseline - this.textEditor.baseline;
						if(this.promptTextRenderer)
						{
							this.promptTextRenderer.y = this._paddingTop + biggerBaseline - promptBaseline;
							this.promptTextRenderer.height = this.actualHeight - this.promptTextRenderer.y - this._paddingBottom;
						}
						if(this.currentIcon)
						{
							this.currentIcon.y = this._paddingTop;
						}
						break;
					}
					case VerticalAlign.TOP:
					{
						this.textEditor.y = this._paddingTop + biggerBaseline - this.textEditor.baseline;
						if(this.promptTextRenderer)
						{
							this.promptTextRenderer.y = this._paddingTop + biggerBaseline - promptBaseline;
						}
						if(this.currentIcon)
						{
							this.currentIcon.y = this._paddingTop;
						}
						break;
					}
					case VerticalAlign.BOTTOM:
					{
						this.textEditor.y = this.actualHeight - this._paddingBottom - biggerHeight + biggerBaseline - this.textEditor.baseline;
						if(this.promptTextRenderer)
						{
							this.promptTextRenderer.y = this.actualHeight - this._paddingBottom - biggerHeight + biggerBaseline - promptBaseline;
						}
						if(this.currentIcon)
						{
							this.currentIcon.y = this.actualHeight - this._paddingBottom - this.currentIcon.height;
						}
						break;
					}
					default: //middle
					{
						this.textEditor.y = biggerBaseline - this.textEditor.baseline + this._paddingTop + Math.round((this.actualHeight - this._paddingTop - this._paddingBottom - biggerHeight) / 2);
						if(this.promptTextRenderer)
						{
							this.promptTextRenderer.y = biggerBaseline - promptBaseline + this._paddingTop + Math.round((this.actualHeight - this._paddingTop - this._paddingBottom - biggerHeight) / 2);
						}
						if(this.currentIcon)
						{
							this.currentIcon.y = this._paddingTop + Math.round((this.actualHeight - this._paddingTop - this._paddingBottom - this.currentIcon.height) / 2);
						}
					}
				}
			}
		}

		/**
		 * @private
		 */
		protected function setFocusOnTextEditorWithTouch(touch:Touch):void
		{
			if(!this.isFocusEnabled)
			{
				return;
			}

			var point:Point = Pool.getPoint();
			touch.getLocation(this.stage, point);
			var isInBounds:Boolean = this.contains(this.stage.hitTest(point));
			//if the focus manager is enabled, _hasFocus will determine if we
			//pass focus to the text editor.
			//if there is no focus manager, then we check if the touch is in
			//the bounds of the text input.
			if((this._hasFocus || isInBounds) && !this._textEditorHasFocus)
			{
				this.textEditor.globalToLocal(point, point);
				this._isWaitingToSetFocus = false;
				this.textEditor.setFocus(point);
			}
			Pool.putPoint(point);
		}

		/**
		 * @private
		 */
		protected function refreshState():void
		{
			if(this._isEnabled)
			{
				//this component can have focus while its text editor does not
				//have focus. StageText, in particular, can't receive focus
				//when its enabled property is false, but we still want to show
				//that the input is focused.
				if(this._textEditorHasFocus || this._hasFocus)
				{
					this.changeState(TextInputState.FOCUSED);
				}
				else if(this._errorString !== null)
				{
					this.changeState(TextInputState.ERROR);
				}
				else
				{
					this.changeState(TextInputState.ENABLED);
				}
			}
			else
			{
				this.changeState(TextInputState.DISABLED);
			}
		}

		/**
		 * @private
		 */
		protected function refreshErrorCallout():void
		{
			if(this._textEditorHasFocus && this.callout === null &&
				this._errorString !== null && this._errorString.length > 0)
			{
				this.createErrorCallout();
			}
			else if(this.callout !== null &&
				(!this._textEditorHasFocus || this._errorString === null || this._errorString.length == 0))
			{
				this.callout.removeFromParent(true);
				this.callout = null;
			}
			if(this.callout !== null)
			{
				this.callout.text = this._errorString;
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
		protected function textInput_removedFromStageHandler(event:Event):void
		{
			if(!this._focusManager && this._textEditorHasFocus)
			{
				this.clearFocus();
			}
			this._textEditorHasFocus = false;
			this._isWaitingToSetFocus = false;
			this._touchPointID = -1;
			if(Mouse.supportsNativeCursor && this._oldMouseCursor)
			{
				Mouse.cursor = this._oldMouseCursor;
				this._oldMouseCursor = null;
			}
		}

		/**
		 * @private
		 */
		protected function textInput_touchHandler(event:TouchEvent):void
		{
			if(!this._isEnabled)
			{
				this._touchPointID = -1;
				return;
			}

			if(this._touchPointID >= 0)
			{
				var touch:Touch = event.getTouch(this, TouchPhase.ENDED, this._touchPointID);
				if(!touch)
				{
					return;
				}
				var point:Point = Pool.getPoint();
				touch.getLocation(this.stage, point);
				var isInBounds:Boolean = this.contains(this.stage.hitTest(point));
				Pool.putPoint(point);
				if(!isInBounds)
				{
					//if not in bounds on TouchPhase.ENDED, there won't be a
					//hover end event, so we need to clear the mouse cursor
					if(Mouse.supportsNativeCursor && this._oldMouseCursor)
					{
						Mouse.cursor = this._oldMouseCursor;
						this._oldMouseCursor = null;
					}
				}
				this._touchPointID = -1;
				if(this.textEditor.setTouchFocusOnEndedPhase)
				{
					this.setFocusOnTextEditorWithTouch(touch);
				}
			}
			else
			{
				touch = event.getTouch(this, TouchPhase.BEGAN);
				if(touch)
				{
					this._touchPointID = touch.id;
					if(!this.textEditor.setTouchFocusOnEndedPhase)
					{
						this.setFocusOnTextEditorWithTouch(touch);
					}
					return;
				}
				touch = event.getTouch(this, TouchPhase.HOVER);
				if(touch)
				{
					if((this._isEditable || this._isSelectable) &&
						Mouse.supportsNativeCursor && !this._oldMouseCursor)
					{
						this._oldMouseCursor = Mouse.cursor;
						Mouse.cursor = MouseCursor.IBEAM;
					}
					return;
				}

				//end hover
				if(Mouse.supportsNativeCursor && this._oldMouseCursor)
				{
					Mouse.cursor = this._oldMouseCursor;
					this._oldMouseCursor = null;
				}
			}
		}

		/**
		 * @private
		 */
		override protected function focusInHandler(event:Event):void
		{
			if(!this._focusManager)
			{
				return;
			}
			super.focusInHandler(event);
			//in some cases the text editor cannot receive focus, so it won't
			//dispatch an event. we need to detect the focused state using the
			//_hasFocus variable
			this.refreshState();
			this.setFocus();
		}

		/**
		 * @private
		 */
		override protected function focusOutHandler(event:Event):void
		{
			if(!this._focusManager)
			{
				return;
			}
			super.focusOutHandler(event);
			//similar to above, we refresh the state based on the _hasFocus
			//because the text editor may not be able to receive focus
			this.refreshState();
			this.textEditor.clearFocus();
		}

		/**
		 * @private
		 */
		protected function textEditor_changeHandler(event:Event):void
		{
			if(this._ignoreTextChanges)
			{
				return;
			}
			this.text = this.textEditor.text;
		}

		/**
		 * @private
		 */
		protected function textEditor_enterHandler(event:Event):void
		{
			this.dispatchEventWith(FeathersEventType.ENTER);
		}

		/**
		 * @private
		 */
		protected function textEditor_focusInHandler(event:Event):void
		{
			if(!this.visible)
			{
				this.textEditor.clearFocus();
				return;
			}
			this._textEditorHasFocus = true;
			this.refreshState();
			this.refreshErrorCallout();
			if(this._focusManager !== null && this.isFocusEnabled)
			{
				if(this._focusManager.focus !== this)
				{
					//if setFocus() was called manually, we need to notify the focus
					//manager (unless isFocusEnabled is false).
					//if the focus manager already knows that we have focus, it will
					//simply return without doing anything.
					this._focusManager.focus = this;
				}
			}
			else
			{
				this.dispatchEventWith(FeathersEventType.FOCUS_IN);
			}
		}

		/**
		 * @private
		 */
		protected function textEditor_focusOutHandler(event:Event):void
		{
			this._textEditorHasFocus = false;
			this.refreshState();
			this.refreshErrorCallout();
			if(this._focusManager !== null && this.isFocusEnabled)
			{
				if(this._focusManager.focus === this)
				{
					//if clearFocus() was called manually, we need to notify the
					//focus manager if it still thinks we have focus.
					this._focusManager.focus = null;
				}
			}
			else
			{
				this.dispatchEventWith(FeathersEventType.FOCUS_OUT);
			}
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
