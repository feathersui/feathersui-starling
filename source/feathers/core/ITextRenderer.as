/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core
{
	import flash.geom.Point;

	/**
	 * Interface that handles common capabilities of rendering text.
	 *
	 * @see ../../../help/text-renderers.html Introduction to Feathers text renderers
	 */
	public interface ITextRenderer extends IFeathersControl, ITextBaselineControl
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
		 * Measures the text's bounds (without a full validation, if
		 * possible).
		 */
		function measureText(result:Point = null):Point;
	}
}
