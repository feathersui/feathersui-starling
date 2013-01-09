/*
 Feathers
 Copyright (c) 2012 Josh Tynjala. All Rights Reserved.

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
	 * @see starling.events.EventDispatcher
	 */
	public interface IFeathersEventDispatcher
	{

		/**
		 * @private
		 */
		function addEventListener(type:String, listener:Function):void;

		/**
		 * @private
		 */
		function removeEventListener(type:String, listener:Function):void;

		/**
		 * @private
		 */
		function removeEventListeners(type:String = null):void;

		/**
		 * @private
		 */
		function dispatchEvent(event:Event):void;

		/**
		 * @private
		 */
		function dispatchEventWith(type:String, bubbles:Boolean = false, data:Object = null):void;

		/**
		 * @private
		 */
		function hasEventListener(type:String):Boolean;
	}
}
