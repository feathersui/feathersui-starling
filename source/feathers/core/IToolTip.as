/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core
{
	/**
	 * An interface for tool tips created by the tool tip manager.
	 * 
	 * @see ../../../help/tool-tips.html Tool tips in Feathers
	 * @see feathers.core.ToolTipManager
	 *
	 * @productversion Feathers 3.0.0
	 */
	public interface IToolTip extends IFeathersControl
	{
		/**
		 * The text to display in the tool tip.
		 */
		function get text():String;

		/**
		 * @private
		 */
		function set text(value:String):void;
	}
}
