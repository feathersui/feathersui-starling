/*
Feathers
Copyright 2012-2021 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core
{
	/**
	 * Watches an <code>IStateContext</code> for state changes.
	 *
	 * @see feathers.core.IStateContext
	 *
	 * @productversion Feathers 2.3.0
	 */
	public interface IStateObserver
	{
		/**
		 * The current state context that is being observed.
		 */
		function get stateContext():IStateContext;

		/**
		 * @private
		 */
		function set stateContext(value:IStateContext):void;
	}
}
