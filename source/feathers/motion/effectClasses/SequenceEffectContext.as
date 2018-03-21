/*
Feathers
Copyright 2012-2018 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.motion.effectClasses
{
	import starling.display.DisplayObject;

	/**
	 * An effect context for running multiple effects one after another in sequence.
	 * 
	 * @productversion Feathers 3.5.0
	 * 
	 * @see feathers.motion.Sequence
	 */
	public class SequenceEffectContext extends BaseEffectContext implements IEffectContext
	{
		/**
		 * Constructor.
		 */
		public function SequenceEffectContext(target:DisplayObject, functions:Array)
		{
			var duration:Number = 0;
			var count:int = functions.length;
			for(var i:int = 0; i < count; i++)
			{
				var func:Function = functions[i] as Function;
				var context:IEffectContext = IEffectContext(func(target));
				this._contexts[i] = context;
				duration += context.duration;
			}
			super(duration);
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
			var totalTime:Number = 0;
			var currentTime:Number = this._position * this._duration;
			var contextCount:int = this._contexts.length;
			for(var i:int = 0; i < contextCount; i++)
			{
				var context:IEffectContext = this._contexts[i] as IEffectContext;
				var contextDuration:Number = context.duration;
				if(totalTime > currentTime)
				{
					context.position = 0;
				}
				else
				{
					context.position = (currentTime - totalTime) / contextDuration;
				}
				totalTime += contextDuration;
			}
		}
	}
}