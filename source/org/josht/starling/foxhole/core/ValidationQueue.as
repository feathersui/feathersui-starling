/*
 Copyright (c) 2012 Josh Tynjala

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 */
package org.josht.starling.foxhole.core
{
	import starling.animation.IAnimatable;
	import starling.core.Starling;

	[ExcludeClass]
	public class ValidationQueue implements IAnimatable
	{
		public function ValidationQueue()
		{

		}

		private var _isValidating:Boolean = false;
		private var _delayedQueue:Vector.<FoxholeControl> = new <FoxholeControl>[];
		private var _queue:Vector.<FoxholeControl> = new <FoxholeControl>[];

		public function addControl(control:FoxholeControl, delayIfValidating:Boolean):void
		{
			const currentQueue:Vector.<FoxholeControl> = (this._isValidating && delayIfValidating) ? this._delayedQueue : this._queue;
			const queueLength:int = currentQueue.length;
			for(var i:int = 0; i < queueLength; i++)
			{
				var item:FoxholeControl = currentQueue[i];
				if(control.contains(item))
				{
					break;
				}
			}
			currentQueue.splice(i, 0, control);
			if(!this._isValidating && currentQueue == this._queue && this._queue.length == 1)
			{
				Starling.juggler.add(this);
			}
		}

		public function advanceTime(time:Number):void
		{
			this._isValidating = true;
			while(this._queue.length > 0)
			{
				var item:FoxholeControl = this._queue.shift();
				item.validate();
			}

			const temp:Vector.<FoxholeControl> = this._queue;
			this._queue = this._delayedQueue;
			this._delayedQueue = temp;

			if(this._queue.length == 0)
			{
				Starling.juggler.remove(this);
			}
			this._isValidating = false;
		}
	}
}
