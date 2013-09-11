/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core
{
	import feathers.utils.display.getDisplayObjectDepthFromStage;

	import flash.utils.Dictionary;

	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.display.DisplayObject;

	[ExcludeClass]
	public final class ValidationQueue implements IAnimatable
	{
		/**
		 * Constructor.
		 */
		public function ValidationQueue()
		{
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

		private var _delayedQueue:Vector.<IFeathersControl> = new <IFeathersControl>[];
		private var _queue:Vector.<IFeathersControl> = new <IFeathersControl>[];
		private var _depthDictionary:Dictionary = new Dictionary(true);

		/**
		 * @private
		 * Adds a control to the queue.
		 */
		public function addControl(control:IFeathersControl, delayIfValidating:Boolean):void
		{
			const currentStarling:Starling = Starling.current;
			if(currentStarling && this._starling != currentStarling)
			{
				if(this._starling)
				{
					this._starling.juggler.remove(this);
				}
				this._starling = currentStarling;
			}
			if(!this._starling.juggler.contains(this))
			{
				this._starling.juggler.add(this);
			}
			var currentQueue:Vector.<IFeathersControl> = (this._isValidating && delayIfValidating) ? this._delayedQueue : this._queue;
			if(currentQueue.indexOf(control) >= 0)
			{
				//already queued
				return;
			}
			var queueLength:int = currentQueue.length;
			if(this._isValidating && currentQueue == this._queue)
			{
				//special case: we need to keep it sorted
				var depth:int = getDisplayObjectDepthFromStage(DisplayObject(control));
				this._depthDictionary[control] = depth;

				//we're traversing the queue backwards because it's
				//significantly more likely that we're going to push than that
				//we're going to splice, so there's no point to iterating over
				//the whole queue
				for(var i:int = queueLength - 1; i >= 0; i--)
				{
					var otherControl:IFeathersControl = IFeathersControl(currentQueue[i]);
					var otherDepth:int = this._depthDictionary[otherControl] as int;
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
				if(i == queueLength)
				{
					currentQueue[queueLength] = control;
				}
				else
				{
					currentQueue.splice(i, 0, control);
				}
			}
			else
			{
				currentQueue[queueLength] = control;
			}
		}

		/**
		 * @private
		 */
		public function advanceTime(time:Number):void
		{
			if(this._isValidating)
			{
				return;
			}
			var queueLength:int = this._queue.length;
			if(queueLength == 0)
			{
				return;
			}
			this._isValidating = true;
			for(var i:int = 0; i < queueLength; i++)
			{
				var displayQueueItem:DisplayObject = DisplayObject(this._queue[i]);
				this._depthDictionary[displayQueueItem] = getDisplayObjectDepthFromStage(displayQueueItem);
			}
			this._queue = this._queue.sort(queueSortFunction);
			while(this._queue.length > 0) //rechecking length after the shift
			{
				var item:IFeathersControl = this._queue.shift();
				item.validate();
				delete this._depthDictionary[item];
			}
			const temp:Vector.<IFeathersControl> = this._queue;
			this._queue = this._delayedQueue;
			this._delayedQueue = temp;
			this._isValidating = false;
		}

		/**
		 * @private
		 */
		protected function queueSortFunction(first:IFeathersControl, second:IFeathersControl):int
		{
			var firstDepth:int = this._depthDictionary[first] as int;
			var secondDepth:int = this._depthDictionary[second] as int;
			if(firstDepth < secondDepth)
			{
				return -1;
			}
			else if(firstDepth > secondDepth)
			{
				return 1;
			}
			return 0;
		}
	}
}
