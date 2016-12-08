/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

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
	 * instead. This interface exists only to support easier code hinting for
	 * interfaces.</p>
	 *
	 * @see http://doc.starling-framework.org/core/starling/events/EventDispatcher.html starling.events.EventDispatcher
	 *
	 * @productversion Feathers 1.1.0
	 */
	public interface IFeathersEventDispatcher
	{
		/**
		 * Adds a listener for an event type.
		 *
		 * @see http://doc.starling-framework.org/core/starling/events/EventDispatcher.html#addEventListener() Full description of starling.events.EventDispatcher.addEventListener() in Gamua's Starling Framework API Reference
		 */
		function addEventListener(type:String, listener:Function):void;

		/**
		 * Removes a listener for an event type.
		 *
		 * @see http://doc.starling-framework.org/core/starling/events/EventDispatcher.html#removeEventListener() Full description of starling.events.EventDispatcher.addEventListener() in Gamua's Starling Framework API Reference
		 */
		function removeEventListener(type:String, listener:Function):void;

		/**
		 * Removes all listeners for an event type.
		 *
		 * @see http://doc.starling-framework.org/core/starling/events/EventDispatcher.html#removeEventListeners() Full description of starling.events.EventDispatcher.removeEventListeners() in Gamua's Starling Framework API Reference
		 */
		function removeEventListeners(type:String = null):void;

		/**
		 * Dispatches an event to all listeners added for the specified event type.
		 *
		 * @see http://doc.starling-framework.org/core/starling/events/EventDispatcher.html#dispatchEvent() Full description of starling.events.EventDispatcher.dispatchEvent() in Gamua's Starling Framework API Reference
		 */
		function dispatchEvent(event:Event):void;

		/**
		 * Dispatches an event from the pool with the specified to all listeners
		 * for the specified event type.
		 *
		 * @see http://doc.starling-framework.org/core/starling/events/EventDispatcher.html#dispatchEventWith() Full description of starling.events.EventDispatcher.dispatchEventWith() in Gamua's Starling Framework API Reference
		 */
		function dispatchEventWith(type:String, bubbles:Boolean = false, data:Object = null):void;

		/**
		 * Checks if a listener has been added for the specified event type.
		 *
		 * @see http://doc.starling-framework.org/core/starling/events/EventDispatcher.html#hasEventListener() Full description of starling.events.EventDispatcher.hasEventListener() in Gamua's Starling Framework API Reference
		 */
		function hasEventListener(type:String, listener:Function = null):Boolean;
	}
}
