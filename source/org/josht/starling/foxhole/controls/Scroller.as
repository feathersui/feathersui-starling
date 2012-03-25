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
	import com.gskinner.motion.easing.Exponential;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.utils.getTimer;
	
	import org.josht.starling.display.Sprite;
	import org.josht.starling.foxhole.core.FoxholeControl;
	import org.josht.starling.motion.GTween;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class Scroller extends FoxholeControl
	{
		public static const SCROLL_POLICY_AUTO:String = "auto";
		public static const SCROLL_POLICY_OFF:String = "off";
		
		public static const HORIZONTAL_ALIGN_LEFT:String = "left";
		public static const HORIZONTAL_ALIGN_CENTER:String = "center";
		public static const HORIZONTAL_ALIGN_RIGHT:String = "right";
		
		public static const VERTICAL_ALIGN_TOP:String = "top";
		public static const VERTICAL_ALIGN_MIDDLE:String = "middle";
		public static const VERTICAL_ALIGN_BOTTOM:String = "bottom";
		
		protected static const INVALIDATION_FLAG_CLIPPING:String = "clipping";
		
		private static const MINIMUM_DRAG_DISTANCE:Number = 0.04;
		private static const FRICTION:Number = 0.9925;
		
		public function Scroller()
		{
			super();
			
			this._background = new Quad(10, 10, 0xff00ff);
			this._background.alpha = 0;
			this.addChild(this._background);
			this._viewPortWrapper = new Sprite();
			this.addChild(this._viewPortWrapper);
			this.addEventListener(TouchEvent.TOUCH, touchHandler);
		}
		
		private var _background:Quad;
		private var _touchPointID:int = -1;
		private var _startTouchTime:int;
		private var _startTouchX:Number;
		private var _startTouchY:Number;
		private var _startHorizontalScrollPosition:Number;
		private var _startVerticalScrollPosition:Number;
		
		private var _horizontalAutoScrollTween:GTween;
		private var _verticalAutoScrollTween:GTween;
		private var _isDraggingHorizontally:Boolean = false;
		private var _isDraggingVertically:Boolean = false;
		
		private var _viewPortWrapper:Sprite;
		
		private var _viewPort:DisplayObject;
		
		public function get viewPort():DisplayObject
		{
			return this._viewPort;
		}
		
		public function set viewPort(value:DisplayObject):void
		{
			if(this._viewPort == value)
			{
				return;
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
			if(this._viewPort)
			{
				if(this._viewPort is FoxholeControl)
				{
					FoxholeControl(this._viewPort).onResize.remove(viewPort_onResize);
				}
				this._viewPortWrapper.removeChild(this._viewPort);
			}
			this._viewPort = value;
			if(this._viewPort)
			{
				if(this._viewPort is FoxholeControl)
				{
					FoxholeControl(this._viewPort).onResize.add(viewPort_onResize);
				}
				this._viewPortWrapper.addChild(this._viewPort);
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		private var _horizontalScrollPosition:Number = 0;
		
		public function get horizontalScrollPosition():Number
		{
			return this._horizontalScrollPosition;
		}
		
		public function set horizontalScrollPosition(value:Number):void
		{
			value = Math.round(value);
			if(this._horizontalScrollPosition == value)
			{
				return;
			}
			this._horizontalScrollPosition = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
			this._onScroll.dispatch(this);
		}
		
		private var _maxHorizontalScrollPosition:Number = 0;
		
		public function get maxHorizontalScrollPosition():Number
		{
			return this._maxHorizontalScrollPosition;
		}
		
		private var _horizontalScrollPolicy:String = SCROLL_POLICY_AUTO;
		
		public function get horizontalScrollPolicy():String
		{
			return this._horizontalScrollPolicy;
		}
		
		public function set horizontalScrollPolicy(value:String):void
		{
			if(this._horizontalScrollPolicy == value)
			{
				return;
			}
			this._horizontalScrollPolicy = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
		}
		
		protected var _horizontalAlign:String = HORIZONTAL_ALIGN_LEFT;
		
		public function get horizontalAlign():String
		{
			return _horizontalAlign;
		}
		
		public function set horizontalAlign(value:String):void
		{
			if(this._horizontalAlign == value)
			{
				return;
			}
			this._horizontalAlign = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		private var _verticalScrollPosition:Number = 0;
		
		public function get verticalScrollPosition():Number
		{
			return this._verticalScrollPosition;
		}
		
		public function set verticalScrollPosition(value:Number):void
		{
			value = Math.round(value);
			if(this._verticalScrollPosition == value)
			{
				return;
			}
			this._verticalScrollPosition = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
			this._onScroll.dispatch(this);
		}
		
		private var _maxVerticalScrollPosition:Number = 0;
		
		public function get maxVerticalScrollPosition():Number
		{
			return this._maxVerticalScrollPosition;
		}
		
		private var _verticalScrollPolicy:String = SCROLL_POLICY_AUTO;
		
		public function get verticalScrollPolicy():String
		{
			return this._verticalScrollPolicy;
		}
		
		public function set verticalScrollPolicy(value:String):void
		{
			if(this._verticalScrollPolicy == value)
			{
				return;
			}
			this._verticalScrollPolicy = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
		}
		
		protected var _verticalAlign:String = VERTICAL_ALIGN_TOP;
		
		public function get verticalAlign():String
		{
			return _verticalAlign;
		}
		
		public function set verticalAlign(value:String):void
		{
			if(this._verticalAlign == value)
			{
				return;
			}
			this._verticalAlign = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		private var _clipContent:Boolean = false;
		
		public function get clipContent():Boolean
		{
			return this._clipContent;
		}
		
		public function set clipContent(value:Boolean):void
		{
			if(this._clipContent == value)
			{
				return;
			}
			this._clipContent = value;
			this.invalidate(INVALIDATION_FLAG_CLIPPING);
		}
		
		protected var _onScroll:Signal = new Signal(Scroller);
		
		public function get onScroll():ISignal
		{
			return this._onScroll;
		}
		
		override protected function draw():void
		{
			const sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const scrollInvalid:Boolean = dataInvalid || this.isInvalid(INVALIDATION_FLAG_SCROLL);
			
			if(sizeInvalid)
			{
				this._background.width = this._width;
				this._background.height = this._height;
			}
			
			if(sizeInvalid || dataInvalid)
			{
				if(this._viewPort)
				{
					this._maxHorizontalScrollPosition = Math.round(Math.max(0, this._viewPort.width - this._width));
					this._maxVerticalScrollPosition = Math.round(Math.max(0, this._viewPort.height - this._height));
				}
				else
				{
					this._maxHorizontalScrollPosition = 0;
					this._maxVerticalScrollPosition = 0;
				}
				this._horizontalScrollPosition = Math.min(this._horizontalScrollPosition, this._maxHorizontalScrollPosition);
				this._verticalScrollPosition = Math.min(this._verticalScrollPosition, this._maxVerticalScrollPosition);
			}
			
			if(sizeInvalid || dataInvalid || scrollInvalid)
			{
				this.scrollContent();
			}
		}
		
		protected function scrollContent():void
		{	
			var offsetX:Number = 0;
			var offsetY:Number = 0;
			if(this._maxHorizontalScrollPosition == 0)
			{
				if(this._horizontalAlign == HORIZONTAL_ALIGN_CENTER)
				{
					offsetX = (this._width - this._viewPort.width) / 2;
				}
				else if(this._horizontalAlign == HORIZONTAL_ALIGN_RIGHT)
				{
					offsetX = this._width - this._viewPort.width;	
				}
			}
			if(this._maxVerticalScrollPosition == 0)
			{
				if(this._verticalAlign == VERTICAL_ALIGN_MIDDLE)
				{
					offsetY = (this._height - this._viewPort.height) / 2;
				}
				else if(this._verticalAlign == VERTICAL_ALIGN_BOTTOM)
				{
					offsetY = this._height - this._viewPort.height;	
				}
			}
			if(this._clipContent)
			{
				this._viewPortWrapper.x = 0;
				this._viewPortWrapper.y = 0;
				if(!this._viewPortWrapper.scrollRect)
				{
					this._viewPortWrapper.scrollRect = new Rectangle();
				}
				
				const scrollRect:Rectangle = this._viewPortWrapper.scrollRect;
				scrollRect.width = this._width;
				scrollRect.height = this._height;
				scrollRect.x = this._horizontalScrollPosition - offsetX;
				scrollRect.y = this._verticalScrollPosition - offsetY;
				this._viewPortWrapper.scrollRect = scrollRect;
			}
			else
			{
				if(this._viewPortWrapper.scrollRect)
				{
					this._viewPortWrapper.scrollRect = null;
				}
				this._viewPortWrapper.x = -this._horizontalScrollPosition + offsetX;
				this._viewPortWrapper.y = -this._verticalScrollPosition + offsetY;
			}
		}
		
		protected function updateHorizontalScrollFromTouchPosition(touchX:Number):void
		{
			const offset:Number = this._startTouchX - touchX;
			var position:Number = this._startHorizontalScrollPosition + offset;
			if(this._horizontalScrollPosition < 0)
			{
				position /= 2;
			}
			else if(position > this._maxHorizontalScrollPosition)
			{
				position -= (position - this._maxHorizontalScrollPosition) / 2;
			}
			
			this.horizontalScrollPosition = position;
		}
		
		protected function updateVerticalScrollFromTouchPosition(touchY:Number):void
		{
			const offset:Number = this._startTouchY - touchY;
			var position:Number = this._startVerticalScrollPosition + offset;
			if(this._verticalScrollPosition < 0)
			{
				position /= 2;
			}
			else if(position > this._maxVerticalScrollPosition)
			{
				position -= (position - this._maxVerticalScrollPosition) / 2;
			}
			
			this.verticalScrollPosition = position;
		}
		
		private function finishScrollingHorizontally():void
		{
			var targetHorizontalScrollPosition:Number = NaN;
			if(this._horizontalScrollPosition < 0)
			{
				targetHorizontalScrollPosition = 0;
			}
			else if(this._horizontalScrollPosition > this._maxHorizontalScrollPosition)
			{
				targetHorizontalScrollPosition = this._maxHorizontalScrollPosition;
			}
			
			this._isDraggingHorizontally = false;
			if(this._horizontalAutoScrollTween)
			{
				this._horizontalAutoScrollTween.paused = false;
				this._horizontalAutoScrollTween = null;
			}
			if(!isNaN(targetHorizontalScrollPosition))
			{
				this._horizontalAutoScrollTween = new GTween(this, 0.24,
				{
					horizontalScrollPosition: targetHorizontalScrollPosition
				},
				{
					ease: Exponential.easeOut,
					onComplete: horizontalAutoScrollTween_onComplete
				});
			}
		}
		
		private function finishScrollingVertically():void
		{
			var targetVerticalScrollPosition:Number = NaN;
			if(this._verticalScrollPosition < 0)
			{
				targetVerticalScrollPosition = 0;
			}
			else if(this._verticalScrollPosition > this._maxVerticalScrollPosition)
			{
				targetVerticalScrollPosition = this._maxVerticalScrollPosition;
			}
			
			this._isDraggingVertically = false;
			if(this._verticalAutoScrollTween)
			{
				this._verticalAutoScrollTween.paused = false;
				this._verticalAutoScrollTween = null;
			}
			if(!isNaN(targetVerticalScrollPosition))
			{
				this._verticalAutoScrollTween = new GTween(this, 0.24,
				{
					verticalScrollPosition: targetVerticalScrollPosition
				},
				{
					ease: Exponential.easeOut,
					onComplete: verticalAutoScrollTween_onComplete
				});
			}
		}
		
		protected function throwHorizontally(pixelsPerMS:Number):void
		{
			const frameRate:int = Starling.current.nativeStage.frameRate;
			var pixelsPerFrame:Number = (1000 * pixelsPerMS) / frameRate;
			var targetHorizontalScrollPosition:Number = this._horizontalScrollPosition;
			var frameCount:int = 0;
			while(Math.floor(Math.abs(pixelsPerFrame)) > 0)
			{
				targetHorizontalScrollPosition -= pixelsPerFrame;
				if(targetHorizontalScrollPosition < 0 || targetHorizontalScrollPosition > this._maxHorizontalScrollPosition)
				{
					pixelsPerFrame *= 0.5;
					targetHorizontalScrollPosition += pixelsPerFrame;
				}
				pixelsPerFrame *= FRICTION;
				frameCount++;
			}
			
			if(this._horizontalAutoScrollTween)
			{
				this._horizontalAutoScrollTween.paused = false;
				this._horizontalAutoScrollTween = null;
			}
			this._horizontalAutoScrollTween = new GTween(this, frameCount / frameRate,
			{
				horizontalScrollPosition: targetHorizontalScrollPosition
			},
			{
				ease: Exponential.easeOut,
				onComplete: horizontalAutoScrollTween_onComplete
			});
		}
		
		protected function throwVertically(pixelsPerMS:Number):void
		{
			const frameRate:int = Starling.current.nativeStage.frameRate;
			var pixelsPerFrame:Number = (1000 * pixelsPerMS) / frameRate;
			var targetVerticalScrollPosition:Number = this._verticalScrollPosition;
			var frameCount:int = 0;
			while(Math.floor(Math.abs(pixelsPerFrame)) > 0)
			{
				targetVerticalScrollPosition -= pixelsPerFrame;
				if(targetVerticalScrollPosition < 0 || targetVerticalScrollPosition > this._maxVerticalScrollPosition)
				{
					pixelsPerFrame *= 0.5;
					targetVerticalScrollPosition += pixelsPerFrame;
				}
				pixelsPerFrame *= FRICTION;
				frameCount++;
			}
			
			if(this._verticalAutoScrollTween)
			{
				this._verticalAutoScrollTween.paused = false;
				this._verticalAutoScrollTween = null;
			}
			this._verticalAutoScrollTween = new GTween(this, frameCount / frameRate,
			{
				verticalScrollPosition: targetVerticalScrollPosition
			},
			{
				ease: Exponential.easeOut,
				onComplete: verticalAutoScrollTween_onComplete
			});
		}
		
		protected function viewPort_onResize(viewPort:FoxholeControl):void
		{
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		protected function horizontalAutoScrollTween_onComplete(tween:GTween):void
		{
			if(this._horizontalAutoScrollTween == tween)
			{
				this._horizontalAutoScrollTween = null;
				this.finishScrollingHorizontally();
			}
		}
		
		protected function verticalAutoScrollTween_onComplete(tween:GTween):void
		{
			if(this._verticalAutoScrollTween == tween)
			{
				this._verticalAutoScrollTween = null;
				this.finishScrollingVertically();
			}
		}
		
		protected function touchHandler(event:TouchEvent):void
		{
			if(!this._isEnabled)
			{
				return;
			}
			const touch:Touch = event.getTouch(this);
			if(!touch || (this._touchPointID >= 0 && touch.id != this._touchPointID))
			{
				return;
			}
			const location:Point = touch.getLocation(this);
			if(touch.phase == TouchPhase.BEGAN)
			{
				if(this._horizontalAutoScrollTween)
				{
					this._horizontalAutoScrollTween.paused = true;
					this._horizontalAutoScrollTween = null
				}
				if(this._verticalAutoScrollTween)
				{
					this._verticalAutoScrollTween.paused = true;
					this._verticalAutoScrollTween = null
				}
				
				this._touchPointID = touch.id;
				this._startTouchTime = getTimer();
				this._startTouchX = location.x;
				this._startTouchY = location.y;
				this._startHorizontalScrollPosition = this._horizontalScrollPosition;
				this._startVerticalScrollPosition = this._verticalScrollPosition;
				this._isDraggingHorizontally = false;
				this._isDraggingVertically = false;
			}
			else if(touch.phase == TouchPhase.MOVED)
			{
				const horizontalInchesMoved:Number = Math.abs(location.x - this._startTouchX) / Capabilities.screenDPI;
				const verticalInchesMoved:Number = Math.abs(location.y - this._startTouchY) / Capabilities.screenDPI;
				if(this._horizontalScrollPolicy != SCROLL_POLICY_OFF && !this._isDraggingHorizontally && horizontalInchesMoved >= MINIMUM_DRAG_DISTANCE)
				{
					this._isDraggingHorizontally = true;
				}
				if(this._verticalScrollPolicy != SCROLL_POLICY_OFF && !this._isDraggingVertically && verticalInchesMoved >= MINIMUM_DRAG_DISTANCE)
				{
					this._isDraggingVertically = true;
				}
				if(this._isDraggingHorizontally && !this._horizontalAutoScrollTween)
				{
					this.updateHorizontalScrollFromTouchPosition(location.x);
				}
				if(this._isDraggingVertically && !this._verticalAutoScrollTween)
				{
					this.updateVerticalScrollFromTouchPosition(location.y);
				}
			}
			else if(touch.phase == TouchPhase.ENDED)
			{
				this._touchPointID = -1;
				var isFinishingHorizontally:Boolean = false;
				var isFinishingVertically:Boolean = false;
				if(this._horizontalScrollPosition < 0 || this._horizontalScrollPosition > this._maxHorizontalScrollPosition)
				{
					isFinishingHorizontally = true;
					this.finishScrollingHorizontally();
				}
				if(this._verticalScrollPosition < 0 || this._verticalScrollPosition > this._maxVerticalScrollPosition)
				{
					isFinishingVertically = true;
					this.finishScrollingVertically();
				}
				if(isFinishingHorizontally && isFinishingVertically)
				{
					return;
				}
				
				const dragDuration:int = getTimer() - this._startTouchTime;
				if(!isFinishingHorizontally && this._horizontalScrollPolicy != SCROLL_POLICY_OFF)
				{
					const horizontalDragDistance:Number = location.x - this._startTouchX;
					this.throwHorizontally(horizontalDragDistance / dragDuration);
				}
				
				if(!isFinishingVertically && this._verticalScrollPolicy != SCROLL_POLICY_OFF)
				{
					const verticalDragDistance:Number = location.y - this._startTouchY;
					this.throwVertically(verticalDragDistance / dragDuration);
				}
			}
		}
	}
}