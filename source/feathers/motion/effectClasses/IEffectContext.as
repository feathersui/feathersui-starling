/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.motion.effectClasses
{
	import feathers.core.IFeathersEventDispatcher;

	/**
	 * Dispatched when the effect is complete.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>null</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @eventType starling.events.Event.COMPLETE
	 */
	[Event(name="complete",type="starling.events.Event")]

	/**
	 * Gives a component the ability to control an effect.
	 * 
	 * @productversion Feathers 3.5.0
	 */
	public interface IEffectContext extends IFeathersEventDispatcher
	{
		/**
		 * The position of the effect, from <code>0</code> to <code>1</code>.
		 */
		function get position():Number;

		/**
		 * @private
		 */
		function set position(value:Number):void;

		/**
		 * Starts playing the effect from its current position to the end.
		 */
		function play():void;

		/**
		 * Starts playing the effect from its current position back to the
		 * beginning (completing at a position of <code>0</code>).
		 */
		function playReverse():void;

		/**
		 * Pauses an effect that is currently playing.
		 */
		function pause():void;

		/**
		 * Stops the effect at its current position and orces Event.COMPLETE to
		 * dispatch.
		 */
		function stop():void;

		/**
		 * Advances the effect to the end and forces Event.COMPLETE to dispatch.
		 */
		function toEnd():void;
	}	
}