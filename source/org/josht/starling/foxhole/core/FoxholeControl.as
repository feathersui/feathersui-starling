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
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import org.josht.starling.display.Sprite;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	public class FoxholeControl extends Sprite
	{
		public static const INVALIDATION_FLAG_ALL:String = "all";
		public static const INVALIDATION_FLAG_STATE:String = "state";
		public static const INVALIDATION_FLAG_SIZE:String = "size";
		public static const INVALIDATION_FLAG_STYLES:String = "styles";
		public static const INVALIDATION_FLAG_DATA:String = "data";
		public static const INVALIDATION_FLAG_SCROLL:String = "scroll";
		public static const INVALIDATION_FLAG_SELECTED:String = "selected";
		
		private static const ENTER_FRAME_DISPLAY_OBJECT:Shape = new Shape();
		
		protected static var isCallingLater:Boolean = false;
		
		private static var callLaterQueue:Vector.<CallLaterQueueItem>;
		
		protected static function callLater(method:Function, arguments:Array = null):void
		{
			if(!callLaterQueue)
			{
				callLaterQueue = new <CallLaterQueueItem>[];
			}
			callLaterQueue.push(new CallLaterQueueItem(method, arguments));
			if(!ENTER_FRAME_DISPLAY_OBJECT.hasEventListener(flash.events.Event.ENTER_FRAME))
			{
				Starling.current.nativeStage.invalidate();
				ENTER_FRAME_DISPLAY_OBJECT.addEventListener(flash.events.Event.FRAME_CONSTRUCTED, callLater_frameEventHandler);
				ENTER_FRAME_DISPLAY_OBJECT.addEventListener(flash.events.Event.RENDER, callLater_frameEventHandler);
				ENTER_FRAME_DISPLAY_OBJECT.addEventListener(flash.events.Event.ENTER_FRAME, callLater_frameEventHandler);
				ENTER_FRAME_DISPLAY_OBJECT.addEventListener(flash.events.Event.EXIT_FRAME, callLater_frameEventHandler);
			}
		}
		
		private static function callLater_frameEventHandler(event:flash.events.Event):void
		{
			isCallingLater = true;
			
			var methodCount:int;
			while(callLaterQueue.length > 0)
			{
				var item:CallLaterQueueItem = callLaterQueue.shift();
				item.method.apply(null, item.parameters);
			}
			ENTER_FRAME_DISPLAY_OBJECT.removeEventListener(flash.events.Event.FRAME_CONSTRUCTED, callLater_frameEventHandler);
			ENTER_FRAME_DISPLAY_OBJECT.removeEventListener(flash.events.Event.RENDER, callLater_frameEventHandler);
			ENTER_FRAME_DISPLAY_OBJECT.removeEventListener(flash.events.Event.ENTER_FRAME, callLater_frameEventHandler);
			ENTER_FRAME_DISPLAY_OBJECT.removeEventListener(flash.events.Event.EXIT_FRAME, callLater_frameEventHandler);
			isCallingLater = false;
		}
		
		public function FoxholeControl()
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private var _isInitialized:Boolean = false;
		private var _invalidateCount:int;
		private var _isAllInvalid:Boolean = false;
		private var _invalidationFlags:Dictionary = new Dictionary(true);
		
		protected var _isEnabled:Boolean = true;

		public function get isEnabled():Boolean
		{
			return _isEnabled;
		}

		public function set isEnabled(value:Boolean):void
		{
			if(this._isEnabled == value)
			{
				return;
			}
			this._isEnabled = value;
			this.invalidate(INVALIDATION_FLAG_STATE);
		}
		
		protected var _width:Number = NaN;

		override public function get width():Number
		{
			return this._width;
		}

		override public function set width(value:Number):void
		{
			if(this._width == value)
			{
				return;
			}
			this._width = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}
		
		protected var _height:Number = NaN;
		
		override public function get height():Number
		{
			return this._height;
		}
		
		override public function set height(value:Number):void
		{
			if(this._height == value)
			{
				return;
			}
			this._height = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}
		
		private var _isValidating:Boolean = false;

		public function invalidate(...rest:Array):void
		{
			if(!this.stage)
			{
				return;
			}
			const isInvalidAlready:Boolean = this.isInvalid();
			for each(var flag:String in rest)
			{
				if(flag == INVALIDATION_FLAG_ALL)
				{
					continue;
				}
				this._invalidationFlags[flag] = true;
			}
			if(rest.length == 0 || rest.indexOf(INVALIDATION_FLAG_ALL) >= 0)
			{
				this._isAllInvalid = true;
			}
			if(this._isValidating)
			{
				this._invalidateCount++;
				if(this._invalidateCount > 10)
				{
					trace("Stopping out of control invalidation. Control may not invalidate() more than 10 ten times during validate() step.");
					return;
				}
				callLater(this.invalidate, rest);
				return;
			}
			this._invalidateCount = 0;
			if(!isInvalidAlready)
			{
				callLater(validate);
			}
		}
		
		public function validate():void
		{
			if(!this.stage || !this.isInvalid())
			{
				return;
			}
			this._isValidating = true;
			this.draw();
			for(var flag:String in this._invalidationFlags)
			{
				delete this._invalidationFlags[flag];
			}
			this._isAllInvalid = false;
			this._isValidating = false;
		}
		
		public function isInvalid(flag:String = null):Boolean	
		{
			if(this._isAllInvalid)
			{
				return true;
			}
			if(!flag) //return true if any flag is set
			{
				for(var flag:String in this._invalidationFlags)
				{
					return true;
				}
				return false;
			}
			return this._invalidationFlags[flag];
		}
		
		protected function initialize():void
		{
			
		}
		
		protected function draw():void
		{
			
		}
		
		private function addedToStageHandler(event:starling.events.Event):void
		{
			if(event.target != this)
			{
				return;
			}
			if(!this._isInitialized)
			{
				this.initialize();
				this._isInitialized = true;
			}
			this.invalidate();
		}
	}
}

class CallLaterQueueItem
{
	public function CallLaterQueueItem(method:Function, parameters:Array)
	{
		this.method = method;
		this.parameters = parameters;
	}
	
	public var method:Function;
	public var parameters:Array;
}