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
package org.josht.starling.foxhole.controls
{
	import flash.display.Stage;
	
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;

	/**
	 * Displays the frames per second.
	 */
	public class FPSDisplay extends Label implements IAnimatable
	{
		/**
		 * Constructor.
		 */
		public function FPSDisplay()
		{
			super();
			this.text = "0";
			this.touchable = false;
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private var _frameCount:int = 0;
		private var _elapsedTime:Number = 0;
		private var _nativeStage:Stage;

		/**
		 * If true, will display both the actual frame rate, and the target
		 * frame rate of the stage.
		 */
		public var showTargetFPS:Boolean = false

		/**
		 * @private
		 */
		public function advanceTime(time:Number):void
		{
			this._frameCount++;
			this._elapsedTime += time;
			
			if(this._elapsedTime >= 1)
			{
				this.text = int(this._frameCount / this._elapsedTime) + (this.showTargetFPS ? " / " + this._nativeStage.frameRate : "");
				this._elapsedTime = this._frameCount = 0;
			}
		}

		/**
		 * @private
		 */
		private function addedToStageHandler(event:Event):void
		{
			this._nativeStage = Starling.current.nativeStage;
			Starling.juggler.add(this);
			this.addEventListener(starling.events.Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}

		/**
		 * @private
		 */
		private function removedFromStageHandler(event:Event):void
		{
			Starling.juggler.remove(this);
			this.removeEventListener(starling.events.Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
	}
}