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
	import starling.display.DisplayObjectContainer;

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
			currentQueue[currentQueue.length] = control;
		}

		/**
		 * @private
		 */
		public function advanceTime(time:Number):void
		{
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
