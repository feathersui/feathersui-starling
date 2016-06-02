/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core
{
	import flash.utils.Dictionary;

	import starling.animation.IAnimatable;
	import starling.core.Starling;

	[ExcludeClass]
	public final class ValidationQueue implements IAnimatable
	{
		/**
		 * @private
		 */
		private static const STARLING_TO_VALIDATION_QUEUE:Dictionary = new Dictionary(true);

		/**
		 * Gets the validation queue for the specified Starling instance. If
		 * a validation queue does not exist for the specified Starling
		 * instance, a new one will be created.
		 */
		public static function forStarling(starling:Starling):ValidationQueue
		{
			if(!starling)
			{
				return null;
			}
			var queue:ValidationQueue = STARLING_TO_VALIDATION_QUEUE[starling];
			if(!queue)
			{
				STARLING_TO_VALIDATION_QUEUE[starling] = queue = new ValidationQueue(starling);
			}
			return queue;
		}

		/**
		 * Constructor.
		 */
		public function ValidationQueue(starling:Starling)
		{
			this._starling = starling;
		}

		private var _starling:Starling;

		private var _isValidating:Boolean = false;

		/**
		 * If true, the queue is currently validating.
		 *
		 * <p>In the following example, we check if the queue is currently validating:</p>
		 *
		 * <listing version="3.0">
		 * if( queue.isValidating )
		 * {
		 *     // do something
		 * }</listing>
		 */
		public function get isValidating():Boolean
		{
			return this._isValidating;
		}

		private var _delayedQueue:Vector.<IValidating> = new <IValidating>[];
		private var _queue:Vector.<IValidating> = new <IValidating>[];

		/**
		 * Disposes the validation queue.
		 */
		public function dispose():void
		{
			if(this._starling)
			{
				this._starling.juggler.remove(this);
				this._starling = null;
			}
		}

		/**
		 * Adds a validating component to the queue.
		 */
		public function addControl(control:IValidating, delayIfValidating:Boolean):void
		{
			//if the juggler was purged, we need to add the queue back in.
			if(!this._starling.juggler.contains(this))
			{
				this._starling.juggler.add(this);
			}
			var currentQueue:Vector.<IValidating> = (this._isValidating && delayIfValidating) ? this._delayedQueue : this._queue;
			if(currentQueue.indexOf(control) >= 0)
			{
				//already queued
				return;
			}
			var queueLength:int = currentQueue.length;
			if(this._isValidating && currentQueue == this._queue)
			{
				//special case: we need to keep it sorted
				var depth:int = control.depth;

				//we're traversing the queue backwards because it's
				//significantly more likely that we're going to push than that
				//we're going to splice, so there's no point to iterating over
				//the whole queue
				for(var i:int = queueLength - 1; i >= 0; i--)
				{
					var otherControl:IValidating = IValidating(currentQueue[i]);
					var otherDepth:int = otherControl.depth;
					//we can skip the overhead of calling queueSortFunction and
					//of looking up the value we've already stored in the depth
					//local variable.
					if(depth >= otherDepth)
					{
						break;
					}
				}
				//add one because we're going after the last item we checked
				//if we made it through all of them, i will be -1, and we want 0
				i++;
				currentQueue.insertAt(i, control);
			}
			else
			{
				//faster than push() because push() creates a temporary rest
				//Array that needs to be garbage collected
				currentQueue[queueLength] = control;
			}
		}

		/**
		 * @private
		 */
		public function advanceTime(time:Number):void
		{
			if(this._isValidating || !this._starling.contextValid)
			{
				return;
			}
			var queueLength:int = this._queue.length;
			if(queueLength === 0)
			{
				return;
			}
			this._isValidating = true;
			if(queueLength > 1)
			{
				//only sort if there's more than one item in the queue because
				//it will avoid allocating objects
				this._queue = this._queue.sort(queueSortFunction);
			}
			while(queueLength > 0) //rechecking length after the shift
			{
				var item:IValidating = this._queue.shift();
				queueLength--;
				if(item.depth < 0)
				{
					//skip items that are no longer on the display list
					continue;
				}
				item.validate();
			}
			var temp:Vector.<IValidating> = this._queue;
			this._queue = this._delayedQueue;
			this._delayedQueue = temp;
			this._isValidating = false;
		}

		/**
		 * @private
		 */
		protected function queueSortFunction(first:IValidating, second:IValidating):int
		{
			var difference:int = second.depth - first.depth;
			if(difference > 0)
			{
				return -1;
			}
			else if(difference < 0)
			{
				return 1;
			}
			return 0;
		}
	}
}
