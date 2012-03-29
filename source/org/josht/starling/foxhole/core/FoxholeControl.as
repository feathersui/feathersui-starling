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
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	/**
	 * Base class for all Foxhole UI controls. Implements invalidation and sets
	 * up some basic template functions like <code>initialize()</code> and
	 * <code>draw()</code>.
	 */
	public class FoxholeControl extends Sprite
	{
		/**
		 * Flag to indicate that everything is invalid and should be redrawn.
		 */
		public static const INVALIDATION_FLAG_ALL:String = "all";
		
		/**
		 * Invalidation flag to indicate that the state has changed. Used by
		 * <code>isEnabled</code>, but may be used for other control states too.
		 * 
		 * @see isEnabled
		 */
		public static const INVALIDATION_FLAG_STATE:String = "state";
		
		/**
		 * Invalidation flag to indicate that the dimensions of the UI control
		 * have changed.
		 */
		public static const INVALIDATION_FLAG_SIZE:String = "size";
		
		/**
		 * Invalidation flag to indicate that the styles or visual appearance of
		 * the UI control has changed.
		 */
		public static const INVALIDATION_FLAG_STYLES:String = "styles";
		
		/**
		 * Invalidation flag to indicate that the primary data displayed by the
		 * UI control has changed.
		 */
		public static const INVALIDATION_FLAG_DATA:String = "data";
		
		/**
		 * Invalidation flag to indicate that the scroll position of the UI
		 * control has changed.
		 */
		public static const INVALIDATION_FLAG_SCROLL:String = "scroll";
		
		/**
		 * Invalidation flag to indicate that the selection of the UI control
		 * has changed.
		 */
		public static const INVALIDATION_FLAG_SELECTED:String = "selected";
		
		/**
		 * @private
		 * A display object that fires frame events that trigger validation.
		 */
		private static const ENTER_FRAME_DISPLAY_OBJECT:Shape = new Shape();
		
		/**
		 * Flag to indicate that the call later queue is being processed.
		 */
		protected static var isCallingLater:Boolean = false;
		
		/**
		 * @private
		 * The queue of functions to be called later.
		 */
		private static var callLaterQueue:Vector.<CallLaterQueueItem>;
		
		/**
		 * Calls a function later, within one frame. Used for invalidation of
		 * UI controls when properties change.
		 */
		protected static function callLater(target:FoxholeControl, method:Function, arguments:Array = null):void
		{
			if(!callLaterQueue)
			{
				callLaterQueue = new <CallLaterQueueItem>[];
			}
			const queueLength:int = callLaterQueue.length;
			for(var i:int = 0; i < queueLength; i++)
			{
				var item:CallLaterQueueItem = callLaterQueue[i];
				if(target.contains(item.target))
				{
					break;
				}
			}
			callLaterQueue.splice(i, 0, new CallLaterQueueItem(target, method, arguments));
			if(!ENTER_FRAME_DISPLAY_OBJECT.hasEventListener(flash.events.Event.ENTER_FRAME))
			{
				Starling.current.nativeStage.invalidate();
				ENTER_FRAME_DISPLAY_OBJECT.addEventListener(flash.events.Event.FRAME_CONSTRUCTED, callLater_frameEventHandler);
				ENTER_FRAME_DISPLAY_OBJECT.addEventListener(flash.events.Event.RENDER, callLater_frameEventHandler);
				ENTER_FRAME_DISPLAY_OBJECT.addEventListener(flash.events.Event.ENTER_FRAME, callLater_frameEventHandler);
				ENTER_FRAME_DISPLAY_OBJECT.addEventListener(flash.events.Event.EXIT_FRAME, callLater_frameEventHandler);
			}
		}
		
		/**
		 * @private
		 * Processes functions in the queue that are to be called later.
		 */
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
		
		/**
		 * Constructor.
		 */
		public function FoxholeControl()
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		/**
		 * @private
		 * Flag indicating if the <code>initialize()</code> function has been called yet.
		 */
		private var _isInitialized:Boolean = false;
		
		/**
		 * @private
		 * A counter for the number of times <code>invalidate()</code> has been
		 * called during validation. If it gets called too many times, the UI
		 * control will automatically stop to avoid hanging.
		 */
		private var _invalidateCount:int;
		
		/**
		 * @private
		 * A flag that indicates that everything is invalid. If true, no other
		 * flags will need to be tracked.
		 */
		private var _isAllInvalid:Boolean = false;
		
		/**
		 * @private
		 * The current invalidation flags.
		 */
		private var _invalidationFlags:Dictionary = new Dictionary(true);
		
		/**
		 * @private
		 */
		protected var _isEnabled:Boolean = true;
		
		/**
		 * Indicates whether the control is interactive or not.
		 */
		public function get isEnabled():Boolean
		{
			return _isEnabled;
		}
		
		/**
		 * @private
		 */
		public function set isEnabled(value:Boolean):void
		{
			if(this._isEnabled == value)
			{
				return;
			}
			this._isEnabled = value;
			this.invalidate(INVALIDATION_FLAG_STATE);
		}
		
		/**
		 * @private
		 */
		protected var _width:Number = NaN;
		
		/**
		 * @inheritDoc
		 */
		override public function get width():Number
		{
			return this._width;
		}
		
		/**
		 * @private
		 */
		override public function set width(value:Number):void
		{
			this.setSize(value, this._height);
		}
		
		/**
		 * @private
		 */
		protected var _height:Number = NaN;
		
		/**
		 * @inheritDoc
		 */
		override public function get height():Number
		{
			return this._height;
		}
		
		/**
		 * @private
		 */
		override public function set height(value:Number):void
		{
			this.setSize(this._width, value);
		}
		
		/**
		 * @private
		 */
		protected var _onResize:Signal = new Signal(FoxholeControl);
		
		/**
		 * Dispatched when the width or height of the control changes.
		 */
		public function get onResize():ISignal
		{
			return this._onResize;
		}
		
		/**
		 * @private
		 * Flag to indicate that the control is currently validating.
		 */
		private var _isValidating:Boolean = false;
		
		/**
		 * When called, the UI control will redraw within one frame.
		 * Invalidation limits processing so that multiple property changes only
		 * trigger a single redraw.
		 * 
		 * <p>If the UI control isn't on the display list, it will never redraw.
		 * The control will automatically invalidate once it has been added.</p>
		 */
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
				callLater(this, this.invalidate, rest);
				return;
			}
			this._invalidateCount = 0;
			if(!isInvalidAlready)
			{
				callLater(this, validate);
			}
		}
		
		/**
		 * Immediately validates the control, which triggers a redraw, if one
		 * is pending.
		 */
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
		
		/**
		 * Indicates whether the control is invalid or not. You may optionally
		 * pass in a specific flag to check if that particular flag is set. If
		 * the "all" flag is set, the result will always be true.
		 */
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
		
		/**
		 * Sets both the width and the height of the control.
		 */
		public function setSize(width:Number, height:Number):void
		{
			var resized:Boolean = false;
			if(this._width != width)
			{
				this._width = width;
				resized = true;
			}
			if(this._height != height)
			{
				this._height = height;
				resized = true;
			}
			if(resized)
			{
				this.invalidate(INVALIDATION_FLAG_SIZE);
				this._onResize.dispatch(this);
			}
		}
		
		/**
		 * Override to initialize the UI control. Should be used to create
		 * children and set up event listeners.
		 */
		protected function initialize():void
		{
			
		}
		
		/**
		 * Override to customize layout and to adjust properties of children.
		 */
		protected function draw():void
		{
			
		}
		
		/**
		 * @private
		 * Initialize the control, if it hasn't been initialized yet. Then,
		 * invalidate.
		 */
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
import org.josht.starling.foxhole.core.FoxholeControl;

class CallLaterQueueItem
{
	public function CallLaterQueueItem(target:FoxholeControl, method:Function, parameters:Array)
	{
		this.target = target;
		this.method = method;
		this.parameters = parameters;
	}
	
	public var target:FoxholeControl;
	public var method:Function;
	public var parameters:Array;
}