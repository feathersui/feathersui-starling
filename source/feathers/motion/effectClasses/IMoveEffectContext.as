/*
Feathers
Copyright 2012-2019 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.motion.effectClasses
{
	/**
	 * Gives a component the ability to control a move effect.
	 * 
	 * @see ../../../help/effects.html Effects and animation for Feathers components
	 */
	public interface IMoveEffectContext extends IEffectContext
	{
		/**
		 * The old x position of the target.
		 */
		function get oldX():Number;

		/**
		 * @private
		 */
		function set oldX(value:Number):void;

		/**
		 * The old y position of the target.
		 */
		function get oldY():Number;

		/**
		 * @private
		 */
		function set oldY(value:Number):void;

		/**
		 * The new x position of the target.
		 */
		function get newX():Number;

		/**
		 * @private
		 */
		function set newX(value:Number):void;

		/**
		 * The new y position of the target.
		 */
		function get newY():Number;

		/**
		 * @private
		 */
		function set newY(value:Number):void;
	}	
}