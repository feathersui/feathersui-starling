/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core
{
	import flash.geom.Point;

	import starling.text.TextFormat;

	/**
	 * Interface that handles common capabilities of rendering text.
	 *
	 * @see ../../../help/text-renderers.html Introduction to Feathers text renderers
	 */
	public interface ITextRenderer extends IStateObserver, IFeathersControl, ITextBaselineControl
	{
		/**
		 * The text to render.
		 *
		 * <p>If using the <code>Label</code> component, this property should
		 * be set on the <code>Label</code>, and it will be passed down to the
		 * text renderer.</p>
		 */
		function get text():String;

		/**
		 * @private
		 */
		function set text(value:String):void;

		/**
		 * Determines if the text wraps to the next line when it reaches the
		 * width (or max width) of the component.
		 *
		 * <p>If using the <code>Label</code> component, this property should
		 * be set on the <code>Label</code>, and it will be passed down to the
		 * text renderer automatically.</p>
		 */
		function get wordWrap():Boolean;

		/**
		 * @private
		 */
		function set wordWrap(value:Boolean):void;

		/**
		 * The number of text lines in the text renderer. The text renderer may
		 * contain multiple text lines if the text contains line breaks or if
		 * the <code>wordWrap</code> property is enabled.
		 */
		function get numLines():int;

		/**
		 * The font styles used to render the text.
		 * 
		 * @see http://doc.starling-framework.org/current/starling/text/TextFormat.html starling.text.TextFormat
		 * @see #setElementFormatForState()
		 */
		function get fontStyles():TextFormat;

		/**
		 * @private
		 */
		function set fontStyles(value:TextFormat):void;

		/**
		 * The font styles used to render the text when the text renderer is
		 * disabled.
		 *
		 * @see http://doc.starling-framework.org/current/starling/text/TextFormat.html starling.text.TextFormat
		 * @see #fontStyles
		 */
		function get disabledFontStyles():TextFormat;

		/**
		 * @private
		 */
		function set disabledFontStyles(value:TextFormat):void;

		/**
		 * The font styles used to render the text when the
		 * <code>stateContext</code> implements the <code>IToggle</code>
		 * interface, and it is selected.
		 *
		 * @see http://doc.starling-framework.org/current/starling/text/TextFormat.html starling.text.TextFormat
		 * @see #fontStyles
		 * @see #stateContext
		 * @see feathers.core.IToggle
		 */
		function get selectedFontStyles():TextFormat;

		/**
		 * @private
		 */
		function set selectedFontStyles(value:TextFormat):void;

		/**
		 * Sets the font styles to be used by the text renderer when the
		 * <code>currentState</code> property of the <code>stateContext</code>
		 * matches the specified state value.
		 *
		 * <p>If font styles are not defined for a specific state, the value of
		 * the <code>fonstStyles</code> property will be used instead.</p>
		 *
		 * <p>If the <code>disabledFontStyles</code> property is not
		 * <code>null</code> and the <code>isEnabled</code> property is
		 * <code>false</code>, all other font styles will be ignored.</p>
		 *
		 * @see #fontStyles
		 * @see #stateContext
		 */
		function setFontStylesForState(state:String, fontStyles:TextFormat):void;

		/**
		 * Measures the text's bounds (without a full validation, if
		 * possible).
		 */
		function measureText(result:Point = null):Point;
	}
}
