/*
Feathers
Copyright 2012-2020 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core
{
	/**
	 * Interface for tool tip management.
	 *
	 * @see ../../../help/tool-tips.html Tool tips in Feathers
	 * @see feathers.core.ToolTipManager
	 *
	 * @productversion Feathers 3.0.0
	 */
	public interface IToolTipManager
	{
		/**
		 * Cleans up event listeners and display objects used by the tool tip
		 * manager.
		 */
		function dispose():void;
	}
}
