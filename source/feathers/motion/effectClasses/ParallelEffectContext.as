/*
Feathers
Copyright 2012-2021 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.motion.effectClasses
{
	import starling.display.DisplayObject;

	/**
	 * An effect context for running multiple effects in parallel.
	 *
	 * @productversion Feathers 3.5.0
	 *
	 * @see feathers.motion.Parallel
	 */
	public class ParallelEffectContext extends BaseEffectContext implements IEffectContext
	{
		/**
		 * Constructor.
		 */
		public function ParallelEffectContext(target:DisplayObject, functions:Array, transition:Object = null)
		{
			var duration:Number = 0;
			var count:int = functions.length;
			for(var i:int = 0; i < count; i++)
			{
				var func:Function = functions[i] as Function;
				var context:IEffectContext = IEffectContext(func(target));
				this._contexts[i] = context;
				var contextDuration:Number = context.duration;
				if(contextDuration > duration)
				{
					duration = contextDuration;
				}
			}
			super(target, duration, transition);
		}

		/**
		 * @private
		 */
		protected var _contexts:Vector.<IEffectContext> = new <IEffectContext>[];

		/**
		 * @private
		 */
		override protected function updateEffect():void
		{
			var ratio:Number = this._position * this._duration;
			var contextCount:int = this._contexts.length;
			for(var i:int = 0; i < contextCount; i++)
			{
				var context:IEffectContext = this._contexts[i] as IEffectContext;
				context.position = ratio / context.duration;
			}
		}
	}
}