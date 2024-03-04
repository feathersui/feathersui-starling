/*
Feathers
Copyright 2012-2021 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.controls.supportClasses.TextFieldViewPort;
	import feathers.core.INativeFocusOwner;
	import feathers.skins.IStyleProvider;
	import feathers.text.FontStylesSet;

	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.StyleSheet;
	import flash.text.TextFormat;

	import starling.events.Event;
	import starling.text.TextFormat;

	/**
	 * The type of anti-aliasing used for this text field, defined as
	 * constants in the <code>flash.text.AntiAliasType</code> class.
	 *
	 * <p>In the following example, the anti-alias type is changed:</p>
	 *
	 * <listing version="3.0">
	 * textRenderer.antiAliasType = AntiAliasType.NORMAL;</listing>
	 *
	 * @default flash.text.AntiAliasType.ADVANCED
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#antiAliasType Full description of flash.text.TextField.antiAliasType in Adobe's Flash Platform API Reference
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/AntiAliasType.html flash.text.AntiAliasType
	 */
	[Style(name="antiAliasType",type="String")]

	/**
	 * Specifies whether the text field has a background fill. Use the
	 * <code>backgroundColor</code> property to set the background color of
	 * a text field.
	 *
	 * <p>In the following example, the background is enabled:</p>
	 *
	 * <listing version="3.0">
	 * scrollText.background = true;
	 * scrollText.backgroundColor = 0xff0000;</listing>
	 *
	 * @default false
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#background Full description of flash.text.TextField.background in Adobe's Flash Platform API Reference
	 * @see #style:backgroundColor
	 */
	[Style(name="background",type="Boolean")]

	/**
	 * The color of the text field background that is displayed if the
	 * <code>background</code> property is set to <code>true</code>.
	 *
	 * <p>In the following example, the background color is changed:</p>
	 *
	 * <listing version="3.0">
	 * scrollText.background = true;
	 * scrollText.backgroundColor = 0xff000ff;</listing>
	 *
	 * @default 0xffffff
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#backgroundColor Full description of flash.text.TextField.backgroundColor in Adobe's Flash Platform API Reference
	 * @see #style:background
	 */
	[Style(name="backgroundColor",type="uint")]

	/**
	 * Specifies whether the text field has a border. Use the
	 * <code>borderColor</code> property to set the border color.
	 *
	 * <p>In the following example, the border is enabled:</p>
	 *
	 * <listing version="3.0">
	 * scrollText.border = true;
	 * scrollText.borderColor = 0xff0000;</listing>
	 *
	 * @default false
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#border Full description of flash.text.TextField.border in Adobe's Flash Platform API Reference
	 * @see #style:borderColor
	 */
	[Style(name="border",type="Boolean")]

	/**
	 * The color of the text field border that is displayed if the
	 * <code>border</code> property is set to <code>true</code>.
	 *
	 * <p>In the following example, the border color is changed:</p>
	 *
	 * <listing version="3.0">
	 * scrollText.border = true;
	 * scrollText.borderColor = 0xff00ff;</listing>
	 *
	 * @default 0x000000
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#borderColor Full description of flash.text.TextField.borderColor in Adobe's Flash Platform API Reference
	 * @see #style:border
	 */
	[Style(name="borderColor",type="uint")]

	/**
	 * If set to <code>true</code>, an internal bitmap representation of the
	 * <code>TextField</code> on the classic display list is cached by the
	 * runtime. This caching may affect performance.
	 *
	 * <p>In the following example, bitmap caching is disabled:</p>
	 *
	 * <listing version="3.0">
	 * scrollText.cacheAsBitmap = false;</listing>
	 *
	 * @default true
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/DisplayObject.html#cacheAsBitmap Full description of flash.display.DisplayObject.cacheAsBitmap in Adobe's Flash Platform API Reference
	 */
	[Style(name="cacheAsBitmap",type="Boolean")]

	/**
	 * A boolean value that specifies whether extra white space (spaces,
	 * line breaks, and so on) in a text field with HTML text is removed.
	 *
	 * <p>In the following example, whitespace is condensed:</p>
	 *
	 * <listing version="3.0">
	 * scrollText.condenseWhite = true;</listing>
	 *
	 * @default false
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#condenseWhite Full description of flash.text.TextField.condenseWhite in Adobe's Flash Platform API Reference
	 * @see #isHTML
	 */
	[Style(name="condenseWhite",type="Boolean")]

	/**
	 * The font styles used to display the label's text when the label is
	 * disabled.
	 *
	 * <p>If the <code>textFormat</code> property or the
	 * <code>disabledTextFormat</code> property is not <code>null</code>,
	 * the <code>disabledFontStyles</code> property will be ignored.</p>
	 *
	 * <p>In the following example, the disabled font styles are customized:</p>
	 *
	 * <listing version="3.0">
	 * label.disabledFontStyles = new TextFormat( "Helvetica", 20, 0x999999 );</listing>
	 *
	 * <p>Note: The <code>starling.text.TextFormat</code> class defines a
	 * number of common font styles, but <code>ScrollText</code> supports
	 * a larger number of ways to be customized. Use the
	 * <code>disabledTextFormat</code> property to set more advanced styles
	 * on the text renderer. If the <code>disabledTextFormat</code> property
	 * is not <code>null</code>, the <code>disabledFontStyles</code>
	 * property will be ignored.</p>
	 *
	 * @default null
	 *
	 * @see http://doc.starling-framework.org/current/starling/text/TextFormat.html starling.text.TextFormat
	 * @see #style:fontStyles
	 */
	[Style(name="disabledFontStyles",type="starling.text.TextFormat")]

	/**
	 * Advanced font formatting used to draw the text when the component is
	 * disabled if <code>disabledFontStyles</code> cannot be used.
	 *
	 * <p>If this property is not <code>null</code>, the
	 * <code>disabledFontStyles</code> property will be ignored.</p>
	 *
	 * <p>Note: It is considered best practice to use the
	 * <code>fontStyles</code> and <code>disabledFontStyles</code>
	 * properties with <code>starling.text.TextFormat</code> for font
	 * formatting. The <code>textFormat</code> property is available for
	 * advanced uses where features of <code>flash.text.TextField</code>
	 * that are not exposed by Starling's <code>TextFormat</code> need to be
	 * customized. In most cases, these advanced features are not required.</p>
	 *
	 * <p>In the following example, the disabled text format is changed:</p>
	 *
	 * <listing version="3.0">
	 * textRenderer.isEnabled = false;
	 * textRenderer.disabledTextFormat = new TextFormat( "_sans", 16, 0xcccccc );</listing>
	 *
	 * @default null
	 *
	 * @see #style:disabledFontStyles
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextFormat.html flash.text.TextFormat
	 */
	[Style(name="disabledTextFormat",type="flash.text.TextFormat")]

	/**
	 * Specifies whether the text field is a password text field that hides
	 * the input characters using asterisks instead of the actual
	 * characters.
	 *
	 * <p>In the following example, the text is displayed as a password:</p>
	 *
	 * <listing version="3.0">
	 * scrollText.displayAsPassword = true;</listing>
	 *
	 * @default false
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#displayAsPassword Full description of flash.text.TextField.displayAsPassword in Adobe's Flash Platform API Reference
	 */
	[Style(name="displayAsPassword",type="Boolean")]

	/**
	 * If advanced <code>flash.text.TextFormat</code> styles are specified,
	 * determines if the component should use an embedded font or not. If
	 * the specified font is not actually embedded, the text may not be
	 * displayed at all.
	 *
	 * <p>If the font styles are passed in using
	 * <code>starling.text.TextFormat</code>, the component  will automatically
	 * detect if a font is embedded or not, and the <code>embedFonts</code>
	 * property will be ignored if it is set to <code>false</code>. Setting it
	 * to <code>true</code> will force the component to always try to use
	 * embedded fonts.</p>
	 *
	 * <p>In the following example, some text is formatted with an embedded
	 * font:</p>
	 *
	 * <listing version="3.0">
	 * scrollText.textFormat = new TextFormat( "Source Sans Pro", 16, 0x333333;
	 * scrollText.embedFonts = true;</listing>
	 *
	 * @default false
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#embedFonts Full description of flash.text.TextField.embedFonts in Adobe's Flash Platform API Reference
	 * @see #textFormat
	 */
	[Style(name="embedFonts",type="Boolean")]

	/**
	 * The font styles used to display the label's text.
	 *
	 * <p>In the following example, the font styles are customized:</p>
	 *
	 * <listing version="3.0">
	 * label.fontStyles = new TextFormat( "Helvetica", 20, 0xcc0000 );</listing>
	 *
	 * <p>Note: The <code>starling.text.TextFormat</code> class defines a
	 * number of common font styles, but <code>ScrollText</code> supports
	 * a larger number of ways to be customized. Use the
	 * <code>textFormat</code> property to set more advanced styles
	 * on the text renderer. If the <code>textFormat</code> property is not
	 * <code>null</code>, the <code>fontStyles</code> property will be
	 * ignored.</p>
	 *
	 * @default null
	 *
	 * @see http://doc.starling-framework.org/current/starling/text/TextFormat.html starling.text.TextFormat
	 * @see #style:disabledFontStyles
	 */
	[Style(name="fontStyles",type="starling.text.TextFormat")]

	/**
	 * Determines whether Flash Player forces strong horizontal and vertical
	 * lines to fit to a pixel or subpixel grid, or not at all using the
	 * constants defined in the <code>flash.text.GridFitType</code> class.
	 * This property applies only if the <code>antiAliasType</code> property
	 * of the text field is set to <code>flash.text.AntiAliasType.ADVANCED</code>.
	 *
	 * <p>In the following example, the grid fit type is changed:</p>
	 *
	 * <listing version="3.0">
	 * scrollText.gridFitType = GridFitType.SUBPIXEL;</listing>
	 *
	 * @default flash.text.GridFitType.PIXEL
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#gridFitType Full description of flash.text.TextField.gridFitType in Adobe's Flash Platform API Reference
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/GridFitType.html flash.text.GridFitType
	 * @see #style:antiAliasType
	 */
	[Style(name="gridFitType",type="String")]

	/**
	 * Quickly sets all outer padding properties to the same value. The
	 * <code>outerPadding</code> getter always returns the value of
	 * <code>outerPaddingTop</code>, but the other padding values may be
	 * different.
	 *
	 * <p>In the following example, the outer padding is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * panel.outerPadding = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:outerPaddingTop
	 * @see #style:outerPaddingRight
	 * @see #style:outerPaddingBottom
	 * @see #style:outerPaddingLeft
	 * @see feathers.controls.Scroller#style:padding
	 */
	[Style(name="outerPadding",type="Number")]

	/**
	 * The minimum space, in pixels, between the view port's top edge and the
	 * top edge of the component.
	 *
	 * <p>Note: The <code>paddingTop</code> property applies to padding inside
	 * the view port, and may not be visible on all sides if the text may be
	 * scroll. Use <code>outerPaddingTop</code> if you want to always display
	 * padding on the top side of the component. <code>outerPaddingTop</code>
	 * and <code>paddingTop</code> may be used simultaneously to define
	 * padding around the outer edges of the container and additional padding
	 * around the text.</p>
	 *
	 * <p>In the following example, the top padding is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * panel.outerPaddingTop = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:outerPadding
	 * @see feathers.controls.Scroller#style:paddingTop
	 */
	[Style(name="outerPaddingTop",type="Number")]

	/**
	 * The minimum space, in pixels, between the view port's right edge and the
	 * right edge of the component.
	 *
	 * <p>Note: The <code>paddingRight</code> property applies to padding inside
	 * the view port, and may not be visible on all sides if the text may be
	 * scroll. Use <code>outerPaddingRight</code> if you want to always display
	 * padding on the right side of the component. <code>outerPaddingRight</code>
	 * and <code>paddingRight</code> may be used simultaneously to define
	 * padding around the outer edges of the container and additional padding
	 * around the text.</p>
	 *
	 * <p>In the following example, the right outer padding is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * panel.outerPaddingRight = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:outerPadding
	 * @see feathers.controls.Scroller#style:paddingRight
	 */
	[Style(name="outerPaddingRight",type="Number")]

	/**
	 * The minimum space, in pixels, between the view port's bottom edge and the
	 * bottom edge of the component.
	 *
	 * <p>Note: The <code>paddingBottom</code> property applies to padding inside
	 * the view port, and may not be visible on all sides if the text may be
	 * scroll. Use <code>outerPaddingBottom</code> if you want to always display
	 * padding on the bottom edge of the component. <code>outerPaddingBottom</code>
	 * and <code>paddingBottom</code> may be used simultaneously to define
	 * padding around the outer edges of the container and additional padding
	 * around the text.</p>
	 *
	 * <p>In the following example, the bottom outer padding is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * panel.outerPaddingBottom = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:outerPadding
	 * @see feathers.controls.Scroller#style:paddingBottom
	 */
	[Style(name="outerPaddingBottom",type="Number")]

	/**
	 * The minimum space, in pixels, between the view port's left edge and the
	 * left edge of the component.
	 *
	 * <p>Note: The <code>paddingLeft</code> property applies to padding inside
	 * the view port, and may not be visible on all sides if the text may be
	 * scroll. Use <code>outerPaddingLeft</code> if you want to always display
	 * padding on the left side of the component. <code>outerPaddingLeft</code>
	 * and <code>paddingLeft</code> may be used simultaneously to define
	 * padding around the outer edges of the container and additional padding
	 * around the text.</p>
	 *
	 * <p>In the following example, the left outer padding is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * scrollText.outerPaddingLeft = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:outerPadding
	 * @see feathers.controls.Scroller#style:paddingLeft
	 */
	[Style(name="outerPaddingLeft",type="Number")]

	/**
	 * The sharpness of the glyph edges in this text field. This property
	 * applies only if the <code>antiAliasType</code> property of the text
	 * field is set to <code>flash.text.AntiAliasType.ADVANCED</code>. The
	 * range for <code>sharpness</code> is a number from <code>-400</code>
	 * to <code>400</code>.
	 *
	 * <p>In the following example, the sharpness is changed:</p>
	 *
	 * <listing version="3.0">
	 * scrollText.sharpness = 200;</listing>
	 *
	 * @default 0
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#sharpness Full description of flash.text.TextField.sharpness in Adobe's Flash Platform API Reference
	 * @see #style:antiAliasType
	 */
	[Style(name="sharpness",type="Number")]

	/**
	 * The <code>StyleSheet</code> object to pass to the TextField.
	 *
	 * <p>In the following example, a style sheet is applied:</p>
	 *
	 * <listing version="3.0">
	 * var style:StyleSheet = new StyleSheet();
	 * var heading:Object = new Object();
	 * heading.fontWeight = "bold";
	 * heading.color = "#FF0000";
	 * 
	 * var body:Object = new Object();
	 * body.fontStyle = "italic";
	 * 
	 * style.setStyle(".heading", heading);
	 * style.setStyle("body", body);
	 * 
	 * scrollText.styleSheet = style;
	 * scrollText.isHTML = true;
	 * scrollText.text = "&lt;body&gt;&lt;span class='heading'&gt;Hello&lt;/span&gt; World...&lt;/body&gt;";</listing>
	 *
	 * @default null
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#styleSheet Full description of flash.text.TextField.styleSheet in Adobe's Flash Platform API Reference
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/StyleSheet.html flash.text.StyleSheet
	 * @see #isHTML
	 */
	[Style(name="styleSheet",type="flash.text.StyleSheet")]

	/**
	 * Advanced font formatting used to draw the text if
	 * <code>fontStyles</code> cannot be used.
	 *
	 * <p>If this property is not <code>null</code>, the
	 * <code>fontStyles</code> property will be ignored.</p>
	 *
	 * <p>Note: It is considered best practice to use the
	 * <code>fontStyles</code> property and
	 * <code>starling.text.TextFormat</code> for font formatting. The
	 * <code>textFormat</code> property is available for advanced uses where
	 * features of <code>flash.text.TextField</code> that are not exposed by
	 * Starling's <code>TextFormat</code> need to be customized. In most
	 * cases, these advanced features are not required.</p>
	 *
	 * <p>In the following example, the text is formatted:</p>
	 *
	 * <listing version="3.0">
	 * scrollText.textFormat = new TextFormat( "_sans", 16, 0x333333 );</listing>
	 *
	 * @default null
	 *
	 * @see #style:fontStyles
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextFormat.html flash.text.TextFormat
	 */
	[Style(name="textFormat",type="flash.text.TextFormat")]

	/**
	 * The thickness of the glyph edges in this text field. This property
	 * applies only if the <code>antiAliasType</code> property is set to
	 * <code>flash.text.AntiAliasType.ADVANCED</code>. The range for
	 * <code>thickness</code> is a number from <code>-200</code> to
	 * <code>200</code>.
	 *
	 * <p>In the following example, the thickness is changed:</p>
	 *
	 * <listing version="3.0">
	 * scrollText.thickness = 100;</listing>
	 *
	 * @default 0
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#thickness Full description of flash.text.TextField.thickness in Adobe's Flash Platform API Reference
	 * @see #style:antiAliasType
	 */
	[Style(name="thickness",type="Number")]

	/**
	 * Dispatched when an anchor (<code>&lt;a&gt;</code>) element in the HTML
	 * text is triggered when the <code>href</code> attribute begins with
	 * <code>"event:"</code>. This event is dispatched when the internal
	 * <code>flash.text.TextField</code> dispatches its own
	 * <code>TextEvent.LINK</code>.
	 *
	 * <p>The <code>data</code> property of the <code>Event</code> object that
	 * is dispatched by the <code>ScrollText</code> contains the value of the
	 * <code>text</code> property of the <code>TextEvent</code> that is
	 * dispatched by the <code>flash.text.TextField</code>.</p>
	 *
	 * <p>The following example listens for <code>Event.TRIGGERED</code> on a
	 * <code>ScrollText</code> component:</p>
	 *
	 * <listing version="3.0">
	 * var scrollText:ScrollText = new ScrollText();
	 * scrollText.text = "&lt;a href=\"event:hello\"&gt;Hello&lt;/a&gt; World";
	 * scrollText.addEventListener( Event.TRIGGERED, scrollText_triggeredHandler );
	 * this.addChild( scrollText );</listing>
	 *
	 * <p>The following example shows a listener for <code>Event.TRIGGERED</code>:</p>
	 *
	 * <listing version="3.0">
	 * function scrollText_triggeredHandler(event:Event):void
	 * {
	 *     trace( event.data ); //hello
	 * }</listing>
	 *
	 * @eventType starling.events.Event.TRIGGERED
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/events/TextEvent.html#LINK flash.events.TextEvent.LINK
	 */
	[Event(name="triggered",type="starling.events.Event")]

	[DefaultProperty("text")]
	/**
	 * Displays long passages of text in a scrollable container using the
	 * runtime's software-based <code>flash.text.TextField</code> as an overlay
	 * above Starling content on the classic display list. This component will
	 * <strong>always</strong> appear above Starling content. The only way to
	 * put something above ScrollText is to put something above it on the
	 * classic display list.
	 *
	 * <p>Meant as a workaround component for when TextFieldTextRenderer runs
	 * into the runtime texture limits.</p>
	 *
	 * <p>Since this component is rendered with the runtime's software renderer,
	 * rather than on the GPU, it may not perform very well on mobile devices
	 * with high resolution screens.</p>
	 *
	 * <p>The following example displays some text:</p>
	 *
	 * <listing version="3.0">
	 * var scrollText:ScrollText = new ScrollText();
	 * scrollText.text = "Hello World";
	 * this.addChild( scrollText );</listing>
	 *
	 * @see ../../../help/scroll-text.html How to use the Feathers ScrollText component
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html flash.text.TextField
	 *
	 * @productversion Feathers 1.0.0
	 */
	public class ScrollText extends Scroller implements INativeFocusOwner
	{
		/**
		 * The default <code>IStyleProvider</code> for all <code>ScrollText</code>
		 * components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * Constructor.
		 */
		public function ScrollText()
		{
			super();
			if(this._fontStylesSet === null)
			{
				this._fontStylesSet = new FontStylesSet();
				this._fontStylesSet.addEventListener(Event.CHANGE, fontStyles_changeHandler);
			}
			this.textViewPort = new TextFieldViewPort();
			this.textViewPort.addEventListener(Event.TRIGGERED, textViewPort_triggeredHandler);
			this.viewPort = this.textViewPort;
		}

		/**
		 * @private
		 */
		protected var textViewPort:TextFieldViewPort;

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return ScrollText.globalStyleProvider;
		}

		/**
		 * @private
		 */
		public function get nativeFocus():Object
		{
			if(this.viewPort === null)
			{
				return null;
			}
			return this.textViewPort.nativeFocus;
		}

		/**
		 * @private
		 */
		protected var _text:String = "";

		/**
		 * The text to display. If <code>isHTML</code> is <code>true</code>, the
		 * text will be rendered as HTML with the same capabilities as the
		 * <code>htmlText</code> property of <code>flash.text.TextField</code>.
		 *
		 * <p>In the following example, some text is displayed:</p>
		 *
		 * <listing version="3.0">
		 * scrollText.text = "Hello World";</listing>
		 *
		 * @default ""
		 *
		 * @see #isHTML
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
				value = "";
			}
			if(this._text == value)
			{
				return;
			}
			this._text = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _isHTML:Boolean = false;

		/**
		 * Determines if the TextField should display the text as HTML or not.
		 *
		 * <p>In the following example, some HTML-formatted text is displayed:</p>
		 *
		 * <listing version="3.0">
		 * scrollText.isHTML = true;
		 * scrollText.text = "&lt;b&gt;Hello&lt;/b&gt; &lt;i&gt;World&lt;/i&gt;";</listing>
		 *
		 * @default false
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#htmlText flash.text.TextField.htmlText
		 * @see #text
		 */
		public function get isHTML():Boolean
		{
			return this._isHTML;
		}

		/**
		 * @private
		 */
		public function set isHTML(value:Boolean):void
		{
			if(this._isHTML == value)
			{
				return;
			}
			this._isHTML = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _fontStylesSet:FontStylesSet;

		/**
		 * @private
		 */
		public function get fontStyles():starling.text.TextFormat
		{
			return this._fontStylesSet.format;
		}

		/**
		 * @private
		 */
		public function set fontStyles(value:starling.text.TextFormat):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			this._fontStylesSet.format = value;
		}

		/**
		 * @private
		 */
		public function get disabledFontStyles():starling.text.TextFormat
		{
			return this._fontStylesSet.disabledFormat;
		}

		/**
		 * @private
		 */
		public function set disabledFontStyles(value:starling.text.TextFormat):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			this._fontStylesSet.disabledFormat = value;
		}

		/**
		 * @private
		 */
		protected var _textFormat:flash.text.TextFormat;

		/**
		 * @private
		 */
		public function get textFormat():flash.text.TextFormat
		{
			return this._textFormat;
		}

		/**
		 * @private
		 */
		public function set textFormat(value:flash.text.TextFormat):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._textFormat === value)
			{
				return;
			}
			this._textFormat = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _disabledTextFormat:flash.text.TextFormat;

		/**
		 * @private
		 */
		public function get disabledTextFormat():flash.text.TextFormat
		{
			return this._disabledTextFormat;
		}

		/**
		 * @private
		 */
		public function set disabledTextFormat(value:flash.text.TextFormat):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._disabledTextFormat === value)
			{
				return;
			}
			this._disabledTextFormat = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _styleSheet:StyleSheet;

		/**
		 * @private
		 */
		public function get styleSheet():StyleSheet
		{
			return this._styleSheet;
		}

		/**
		 * @private
		 */
		public function set styleSheet(value:StyleSheet):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._styleSheet === value)
			{
				return;
			}
			this._styleSheet = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _embedFonts:Boolean = false;

		/**
		 * @private
		 */
		public function get embedFonts():Boolean
		{
			return this._embedFonts;
		}

		/**
		 * @private
		 */
		public function set embedFonts(value:Boolean):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._embedFonts === value)
			{
				return;
			}
			this._embedFonts = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _antiAliasType:String = AntiAliasType.ADVANCED;

		/**
		 * @private
		 */
		public function get antiAliasType():String
		{
			return this._antiAliasType;
		}

		/**
		 * @private
		 */
		public function set antiAliasType(value:String):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._antiAliasType === value)
			{
				return;
			}
			this._antiAliasType = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _background:Boolean = false;

		/**
		 * @private
		 */
		public function get background():Boolean
		{
			return this._background;
		}

		/**
		 * @private
		 */
		public function set background(value:Boolean):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._background === value)
			{
				return;
			}
			this._background = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _backgroundColor:uint = 0xffffff;

		/**
		 * @private
		 */
		public function get backgroundColor():uint
		{
			return this._backgroundColor;
		}

		/**
		 * @private
		 */
		public function set backgroundColor(value:uint):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._backgroundColor == value)
			{
				return;
			}
			this._backgroundColor = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _border:Boolean = false;

		/**
		 * @private
		 */
		public function get border():Boolean
		{
			return this._border;
		}

		/**
		 * @private
		 */
		public function set border(value:Boolean):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._border === value)
			{
				return;
			}
			this._border = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _borderColor:uint = 0x000000;

		/**
		 * @private
		 */
		public function get borderColor():uint
		{
			return this._borderColor;
		}

		/**
		 * @private
		 */
		public function set borderColor(value:uint):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._borderColor == value)
			{
				return;
			}
			this._borderColor = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _cacheAsBitmap:Boolean = true;

		/**
		 * @private
		 */
		public function get cacheAsBitmap():Boolean
		{
			return this._cacheAsBitmap;
		}

		/**
		 * @private
		 */
		public function set cacheAsBitmap(value:Boolean):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._cacheAsBitmap === value)
			{
				return;
			}
			this._cacheAsBitmap = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _condenseWhite:Boolean = false;

		/**
		 * @private
		 */
		public function get condenseWhite():Boolean
		{
			return this._condenseWhite;
		}

		/**
		 * @private
		 */
		public function set condenseWhite(value:Boolean):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._condenseWhite === value)
			{
				return;
			}
			this._condenseWhite = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _displayAsPassword:Boolean = false;

		/**
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._displayAsPassword === value)
			{
				return;
			}
			this._displayAsPassword = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _gridFitType:String = GridFitType.PIXEL;

		/**
		 * @private
		 */
		public function get gridFitType():String
		{
			return this._gridFitType;
		}

		/**
		 * @private
		 */
		public function set gridFitType(value:String):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._gridFitType === value)
			{
				return;
			}
			this._gridFitType = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _sharpness:Number = 0;

		/**
		 * @private
		 */
		public function get sharpness():Number
		{
			return this._sharpness;
		}

		/**
		 * @private
		 */
		public function set sharpness(value:Number):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._sharpness == value)
			{
				return;
			}
			this._sharpness = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		private var _thickness:Number = 0;

		/**
		 * @private
		 */
		public function get thickness():Number
		{
			return this._thickness;
		}

		/**
		 * @private
		 */
		public function set thickness(value:Number):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._thickness == value)
			{
				return;
			}
			this._thickness = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		override public function get padding():Number
		{
			return this._textPaddingTop;
		}

		//no setter for padding because the one in Scroller is acceptable

		/**
		 * @private
		 */
		protected var _textPaddingTop:Number = 0;

		/**
		 * @private
		 */
		override public function get paddingTop():Number
		{
			return this._textPaddingTop;
		}

		/**
		 * @private
		 */
		override public function set paddingTop(value:Number):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._textPaddingTop == value)
			{
				return;
			}
			this._textPaddingTop = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _textPaddingRight:Number = 0;

		/**
		 * @private
		 */
		override public function get paddingRight():Number
		{
			return this._textPaddingRight;
		}

		/**
		 * @private
		 */
		override public function set paddingRight(value:Number):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._textPaddingRight == value)
			{
				return;
			}
			this._textPaddingRight = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _textPaddingBottom:Number = 0;

		/**
		 * @private
		 */
		override public function get paddingBottom():Number
		{
			return this._textPaddingBottom;
		}

		/**
		 * @private
		 */
		override public function set paddingBottom(value:Number):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._textPaddingBottom == value)
			{
				return;
			}
			this._textPaddingBottom = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _textPaddingLeft:Number = 0;

		/**
		 * @private
		 */
		override public function get paddingLeft():Number
		{
			return this._textPaddingLeft;
		}

		/**
		 * @private
		 */
		override public function set paddingLeft(value:Number):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._textPaddingLeft == value)
			{
				return;
			}
			this._textPaddingLeft = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		public function get outerPadding():Number
		{
			return this._outerPaddingTop;
		}

		/**
		 * @private
		 */
		public function set outerPadding(value:Number):void
		{
			this.outerPaddingTop = value;
			this.outerPaddingRight = value;
			this.outerPaddingBottom = value;
			this.outerPaddingLeft = value;
		}

		/**
		 * @private
		 */
		protected var _outerPaddingTop:Number = 0;

		/**
		 * @private
		 */
		public function get outerPaddingTop():Number
		{
			return this._outerPaddingTop;
		}

		/**
		 * @private
		 */
		public function set outerPaddingTop(value:Number):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._outerPaddingTop == value)
			{
				return;
			}
			this._outerPaddingTop = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _outerPaddingRight:Number = 0;

		/**
		 * @private
		 */
		public function get outerPaddingRight():Number
		{
			return this._outerPaddingRight;
		}

		/**
		 * @private
		 */
		public function set outerPaddingRight(value:Number):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._outerPaddingRight == value)
			{
				return;
			}
			this._outerPaddingRight = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _outerPaddingBottom:Number = 0;

		/**
		 * @private
		 */
		public function get outerPaddingBottom():Number
		{
			return this._outerPaddingBottom;
		}

		/**
		 * @private
		 */
		public function set outerPaddingBottom(value:Number):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._outerPaddingBottom == value)
			{
				return;
			}
			this._outerPaddingBottom = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _outerPaddingLeft:Number = 0;

		/**
		 * @private
		 */
		public function get outerPaddingLeft():Number
		{
			return this._outerPaddingLeft;
		}

		/**
		 * @private
		 */
		public function set outerPaddingLeft(value:Number):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._outerPaddingLeft == value)
			{
				return;
			}
			this._outerPaddingLeft = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _visible:Boolean = true;

		/**
		 * @private
		 */
		override public function get visible():Boolean
		{
			return this._visible;
		}

		/**
		 * @private
		 */
		override public function set visible(value:Boolean):void
		{
			if(this._visible == value)
			{
				return;
			}
			this._visible = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _alpha:Number = 1;

		/**
		 * @private
		 */
		override public function get alpha():Number
		{
			return this._alpha;
		}

		/**
		 * @private
		 */
		override public function set alpha(value:Number):void
		{
			if(this._alpha == value)
			{
				return;
			}
			this._alpha = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		override public function dispose():void
		{
			if(this._fontStylesSet !== null)
			{
				this._fontStylesSet.dispose();
				this._fontStylesSet = null;
			}
			super.dispose();
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			var scrollInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SCROLL);
			var stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);

			if(dataInvalid)
			{
				this.textViewPort.text = this._text;
				this.textViewPort.isHTML = this._isHTML;
			}

			if(stylesInvalid)
			{
				this.textViewPort.antiAliasType = this._antiAliasType;
				this.textViewPort.background = this._background;
				this.textViewPort.backgroundColor = this._backgroundColor;
				this.textViewPort.border = this._border;
				this.textViewPort.borderColor = this._borderColor;
				this.textViewPort.cacheAsBitmap = this._cacheAsBitmap;
				this.textViewPort.condenseWhite = this._condenseWhite;
				this.textViewPort.displayAsPassword = this._displayAsPassword;
				this.textViewPort.gridFitType = this._gridFitType;
				this.textViewPort.sharpness = this._sharpness;
				this.textViewPort.thickness = this._thickness;
				this.textViewPort.textFormat = this._textFormat;
				this.textViewPort.disabledTextFormat = this._disabledTextFormat;
				this.textViewPort.fontStyles = this._fontStylesSet;
				this.textViewPort.styleSheet = this._styleSheet;
				this.textViewPort.embedFonts = this._embedFonts;
				this.textViewPort.paddingTop = this._textPaddingTop;
				this.textViewPort.paddingRight = this._textPaddingRight;
				this.textViewPort.paddingBottom = this._textPaddingBottom;
				this.textViewPort.paddingLeft = this._textPaddingLeft;
				this.textViewPort.visible = this._visible;
				this.textViewPort.alpha = this._alpha;
			}

			super.draw();
		}

		/**
		 * @private
		 */
		override protected function calculateViewPortOffsets(forceScrollBars:Boolean = false, useActualBounds:Boolean = false):void
		{
			super.calculateViewPortOffsets(forceScrollBars);

			this._topViewPortOffset += this._outerPaddingTop;
			this._rightViewPortOffset += this._outerPaddingRight;
			this._bottomViewPortOffset += this._outerPaddingBottom;
			this._leftViewPortOffset += this._outerPaddingLeft;
		}

		/**
		 * @private
		 */
		protected function textViewPort_triggeredHandler(event:Event, link:String):void
		{
			this.dispatchEventWith(Event.TRIGGERED, false, link);
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
