/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.motion
{
	import feathers.core.IFeathersEventDispatcher;

	/**
	 * 
	 */
	[Event(name="complete",type="starling.events.Event")]

	/**
	 * Gives a component the ability to control an effect.
	 */
	public interface IEffectContext extends IFeathersEventDispatcher
	{
		/**
		 * 
		 */
		function get position():Number;

		/**
		 * @private
		 */
		function set position(value:Number):void;

		/**
		 * 
		 */
		function get easeEnabled():Boolean;

		/**
		 * @private
		 */
		function set easeEnabled(value:Boolean):void;

		/**
		 * 
		 */
		function play():void;

		/**
		 * 
		 */
		function playReverse():void;

		/**
		 * 
		 */
		function pause():void;
	}	
}