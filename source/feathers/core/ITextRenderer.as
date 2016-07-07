/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core
{
	import feathers.text.FontStylesSet;

	import flash.geom.Point;

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
		 * The font styles used to render the text. May be ignored if more
		 * advanced styles defined by the text renderer implementation have
		 * been set.
		 */
		function get fontStyles():FontStylesSet;

		/**
		 * @private
		 */
		function set fontStyles(value:FontStylesSet):void;

		/**
		 * Measures the text's bounds (without a full validation, if
		 * possible).
		 */
		function measureText(result:Point = null):Point;
	}
}
