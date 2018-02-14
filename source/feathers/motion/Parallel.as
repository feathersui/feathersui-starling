/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.motion
{
	import starling.display.DisplayObject;
	import feathers.motion.effectClasses.IEffectContext;
	import feathers.motion.effectClasses.ParallelEffectContext;

	/**
	 * Combines multiple effects that play at the same time, in parallel. 
	 *
	 * @productversion Feathers 3.5.0
	 */
	public class Parallel
	{
		/**
		 * Creates an effect function that combines multiple effect functions
		 * that will play at the same time, in parallel.
		 *
		 * @productversion Feathers 3.5.0
		 */
		public static function createParallelEffect(effect1:Function, effect2:Function, ...rest:Array):Function
		{
			//the order doesn't matter, so just add them at the end
			rest[rest.length] = effect1;
			rest[rest.length] = effect2;
			return function(target:DisplayObject):IEffectContext
			{
				return new ParallelEffectContext(target, rest);
			}
		}
	}
}