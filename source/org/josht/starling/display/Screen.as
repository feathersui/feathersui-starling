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
package org.josht.starling.display
{
	import flash.display.DisplayObjectContainer;
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
		
		override public function set x(value:Number):void
		{
			super.x = Math.round(value);
		}
		
		override public function set y(value:Number):void
		{
			super.y = Math.round(value);
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
		
		private var _pixelScale:Number = 1;
		
		protected function get pixelScale():Number
		{
			return this._pixelScale;
		}
		
		private var _dpiScale:Number = 1;
		
		protected function get dpiScale():Number
		{
			return this._dpiScale;
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
			const loaderInfo:LoaderInfo = DisplayObjectContainer(Starling.current.nativeStage.root).getChildAt(0).loaderInfo;
			if(isNaN(this._originalWidth))
			{
				try
				{
					this._originalWidth = loaderInfo.width
				} 
				catch(error:Error) 
				{
					this._originalWidth = this.stage.stageWidth;
				}
			}
			if(isNaN(this._originalHeight))
			{
				try
				{
					this._originalHeight = loaderInfo.height;
				} 
				catch(error:Error) 
				{
					this._originalHeight = this.stage.stageHeight;
				}
			}
			this._pixelScale = calculateScaleRatioToFit(originalWidth, originalHeight, this.stage.stageWidth, this.stage.stageHeight);
			this._dpiScale = Capabilities.screenDPI / this._originalDPI;
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