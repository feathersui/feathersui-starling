package org.josht.starling.foxhole.controls
{
	import flash.display.Stage;
	
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;

	public class FPSDisplay extends Label implements IAnimatable
	{
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
		
		public var showTargetFPS:Boolean = false
		
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
		
		private function addedToStageHandler(event:Event):void
		{
			this._nativeStage = Starling.current.nativeStage;
			Starling.juggler.add(this);
			this.addEventListener(starling.events.Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		private function removedFromStageHandler(event:Event):void
		{
			Starling.juggler.remove(this);
			this.addEventListener(starling.events.Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
	}
}