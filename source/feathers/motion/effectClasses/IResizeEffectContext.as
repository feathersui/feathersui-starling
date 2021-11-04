/*
Feathers
Copyright 2012-2021 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.motion.effectClasses
{
	/**
	 * Gives a component the ability to control a resize effect.
	 *
	 * @see ../../../help/effects.html Effects and animation for Feathers components
	 */
	public interface IResizeEffectContext extends IEffectContext
	{
		/**
		 * The old width of the target.
		 */
		function get oldWidth():Number;

		/**
		 * @private
		 */
		function set oldWidth(value:Number):void;

		/**
		 * The old height of the target.
		 */
		function get oldHeight():Number;

		/**
		 * @private
		 */
		function set oldHeight(value:Number):void;

		/**
		 * The new width of the target.
		 */
		function get newWidth():Number;

		/**
		 * @private
		 */
		function set newWidth(value:Number):void;

		/**
		 * The new height of the target.
		 */
		function get newHeight():Number;

		/**
		 * @private
		 */
		function set newHeight(value:Number):void;
	}
}