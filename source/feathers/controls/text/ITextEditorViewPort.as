/*
Feathers
Copyright 2012-2020 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.text
{
	import feathers.controls.supportClasses.IViewPort;
	import feathers.core.ITextEditor;

	/**
	 * Handles the editing of multiline text.
	 *
	 * @see feathers.controls.TextArea
	 *
	 * @productversion Feathers 1.1.0
	 */
	public interface ITextEditorViewPort extends ITextEditor, IViewPort
	{
		/**
		 * The padding between the top edge of the viewport and the text.
		 */
		function get paddingTop():Number;

		/**
		 * @private
		 */
		function set paddingTop(value:Number):void;
		
		/**
		 * The padding between the right edge of the viewport and the text.
		 */
		function get paddingRight():Number;

		/**
		 * @private
		 */
		function set paddingRight(value:Number):void;
		
		/**
		 * The padding between the bottom edge of the viewport and the text.
		 */
		function get paddingBottom():Number;

		/**
		 * @private
		 */
		function set paddingBottom(value:Number):void;
		
		/**
		 * The padding between the left edge of the viewport and the text.
		 */
		function get paddingLeft():Number;

		/**
		 * @private
		 */
		function set paddingLeft(value:Number):void;
	}
}
