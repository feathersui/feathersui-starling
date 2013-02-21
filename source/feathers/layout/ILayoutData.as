/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.layout
{
	import feathers.core.IFeathersEventDispatcher;

	/**
	 * Dispatched when a property of the layout data changes.
	 */
	[Event(name="change",type="starling.events.Event")]

	/**
	 * Extra data used by layout algorithms.
	 */
	public interface ILayoutData extends IFeathersEventDispatcher
	{
	}
}
