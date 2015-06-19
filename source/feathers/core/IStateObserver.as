/*
Feathers
Copyright 2012-2015 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core
{
	/**
	 * Watches an <code>IStateContext</code> for state changes.
	 * 
	 * @see feathers.core.IStateContext
	 */
	public interface IStateObserver
	{
		function get stateContext():IStateContext;
		function set stateContext(value:IStateContext):void;
	}
}
