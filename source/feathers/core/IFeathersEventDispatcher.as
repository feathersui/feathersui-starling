/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core
{
	import starling.events.Event;

	/**
	 * Public properties and functions from <code>starling.events.EventDispatcher</code>
	 * in helpful interface form.
	 *
	 * <p>Never cast an object to this type. Cast to <code>EventDispatcher</code>
	 * instead. This interface exists only to support easier code hinting.</p>
	 *
	 * @see starling.events.EventDispatcher
	 */
	public interface IFeathersEventDispatcher
	{
		/**
		 * @see starling.events.EventDispatcher#addEventListener()
		 */
		function addEventListener(type:String, listener:Function):void;

		/**
		 * @see starling.events.EventDispatcher#removeEventListener()
		 */
		function removeEventListener(type:String, listener:Function):void;

		/**
		 * @see starling.events.EventDispatcher#removeEventListeners()
		 */
		function removeEventListeners(type:String = null):void;

		/**
		 * @see starling.events.EventDispatcher#dispatchEvent()
		 */
		function dispatchEvent(event:Event):void;

		/**
		 * @see starling.events.EventDispatcher#dispatchEventWith()
		 */
		function dispatchEventWith(type:String, bubbles:Boolean = false, data:Object = null):void;

		/**
		 * @see starling.events.EventDispatcher#hasEventListener()
		 */
		function hasEventListener(type:String):Boolean;
	}
}
