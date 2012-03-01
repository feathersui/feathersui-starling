package org.josht.starling.display
{
	import flash.display.LoaderInfo;
	import flash.events.KeyboardEvent;
	import flash.system.Capabilities;
	import flash.ui.Keyboard;
	
	import org.josht.utils.display.calculateScaleRatioToFit;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.ResizeEvent;
	
	public class Screen extends Sprite
	{
		public function Screen()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private var _originalWidth:Number = NaN;
		
		public function get originalWidth():Number
		{
			return this._originalWidth;
		}
		
		public function set originalWidth(value:Number):void
		{
			this._originalWidth = value;
		}
		
		private var _originalHeight:Number = NaN;
		
		public function get originalHeight():Number
		{
			return this._originalHeight;
		}
		
		public function set originalHeight(value:Number):void
		{
			this._originalHeight = value;
		}
		
		private var _originalDPI:int = 168;
		
		public function get originalDPI():int
		{
			return this._originalDPI;
		}
		
		public function set originalDPI(value:int):void
		{
			this._originalDPI = value;
		}
		
		private var _initialized:Boolean = false;
		
		private var _pixelScaleRatio:Number = 1;
		
		protected function get pixelScaleRatio():Number
		{
			return this._pixelScaleRatio;
		}
		
		private var _dpiScaleRatio:Number = 1;
		
		protected function get dpiScaleRatio():Number
		{
			return this._dpiScaleRatio;
		}
		
		protected var backButtonHandler:Function;
		
		protected var menuButtonHandler:Function;
		
		protected var searchButtonHandler:Function;
		
		protected function initialize():void
		{
			
		}
		
		protected function layout():void
		{
			
		}
		
		protected function destroy():void
		{
			
		}
		
		private function refreshScaleRatio():void
		{
			const loaderInfo:LoaderInfo = Starling.current.nativeStage.loaderInfo;
			if(isNaN(this._originalWidth))
			{
				this._originalWidth = loaderInfo.width
			}
			if(isNaN(this._originalHeight))
			{
				this._originalHeight = loaderInfo.height;
			}
			this._pixelScaleRatio = calculateScaleRatioToFit(originalWidth, originalHeight, this.stage.stageWidth, this.stage.stageHeight);
			this._dpiScaleRatio = this._originalDPI / Capabilities.screenDPI;
		}
		
		private function addedToStageHandler(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			this.stage.addEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
			Starling.current.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler, false, 0, true);
			if(!this._initialized)
			{
				this.refreshScaleRatio();
				this.initialize();
				this.layout();
				this._initialized = true;
			}
		}
		
		private function stage_resizeHandler(event:ResizeEvent):void
		{
			this.refreshScaleRatio();
			this.layout();
		}
		
		private function stage_keyDownHandler(event:KeyboardEvent):void
		{
			//we're accessing Keyboard.BACK (and others) using a string because
			//this code may be compiled for both Flash Player and AIR.
			if(this.backButtonHandler != null &&
				Object(Keyboard).hasOwnProperty("BACK") &&
				event.keyCode == Keyboard["BACK"])
			{
				event.stopImmediatePropagation();
				event.preventDefault();
				this.backButtonHandler();
			}
			
			if(this.menuButtonHandler != null &&
				Object(Keyboard).hasOwnProperty("MENU") &&
				event.keyCode == Keyboard["MENU"])
			{
				event.preventDefault();
				this.menuButtonHandler();
			}
			
			if(this.searchButtonHandler != null &&
				Object(Keyboard).hasOwnProperty("SEARCH") &&
				event.keyCode == Keyboard["SEARCH"])
			{
				event.preventDefault();
				this.searchButtonHandler();
			}
		}
		
		private function removedFromStageHandler(event:Event):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			this.stage.removeEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
			Starling.current.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
			this.destroy();
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
	}
}