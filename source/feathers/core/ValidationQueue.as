/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core
{
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
			const currentQueue:Vector.<IFeathersControl> = (this._isValidating && delayIfValidating) ? this._delayedQueue : this._queue;
			const queueLength:int = currentQueue.length;
			const containerControl:DisplayObjectContainer = control as DisplayObjectContainer;
			for(var i:int = 0; i < queueLength; i++)
			{
				var item:DisplayObject = DisplayObject(currentQueue[i]);
				if(control == item && currentQueue == this._queue)
				{
					//already queued
					return;
				}
				if(containerControl && containerControl.contains(item))
				{
					break;
				}
			}
			if(i == queueLength)
			{
				currentQueue[queueLength] = control;
			}
			else
			{
				currentQueue.splice(i, 0, control);
			}
		}

		/**
		 * @private
		 */
		public function advanceTime(time:Number):void
		{
			this._isValidating = true;
			while(this._queue.length > 0)
			{
				var item:IFeathersControl = this._queue.shift();
				item.validate();
			}
			const temp:Vector.<IFeathersControl> = this._queue;
			this._queue = this._delayedQueue;
			this._delayedQueue = temp;
			this._isValidating = false;
		}
	}
}
