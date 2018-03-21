/*
Feathers
Copyright 2012-2018 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core
{
	/**
	 * @private
	 * A text editor that is compatible with <code>TextEditorIMEClient</code>.
	 * 
	 * @see feathers.utils.text.TextEditorIMEClient
	 *
	 * @productversion Feathers 3.0.0
	 */
	public interface IIMETextEditor extends ITextEditor
	{
		/**
		 * The index where the selection is anchored. Will be equal to either
		 * <code>selectionBeginIndex</code> or <code>selectionEndIndex</code>.
		 *
		 * @see #selectionActiveIndex
		 */
		function get selectionAnchorIndex():int;

		/**
		 * The index where the selection is active.
		 *
		 * @see #selectionAnchorIndex
		 */
		function get selectionActiveIndex():int;
	}
}
