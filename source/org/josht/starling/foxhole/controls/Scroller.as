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
	import org.josht.utils.math.clamp;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * Allows horizontal and vertical scrolling of a viewport (which may be any
	 * Starling display object). Will react to the <code>onResize</code> signal
	 * dispatched by Foxhole controls.
	 */
	public class Scroller extends FoxholeControl
	{
		/**
		 * The scroller may scroll.
		 */
		public static const SCROLL_POLICY_AUTO:String = "auto";
		
		/**
		 * The scroll does not scroll at all.
		 */
		public static const SCROLL_POLICY_OFF:String = "off";
		
		/**
		 * Aligns the viewport to the left, if the viewport's width is smaller
		 * than the scroller's width.
		 */
		public static const HORIZONTAL_ALIGN_LEFT:String = "left";
		
		/**
		 * Aligns the viewport to the center, if the viewport's width is smaller
		 * than the scroller's width.
		 */
		public static const HORIZONTAL_ALIGN_CENTER:String = "center";
		
		/**
		 * Aligns the viewport to the right, if the viewport's width is smaller
		 * than the scroller's width.
		 */
		public static const HORIZONTAL_ALIGN_RIGHT:String = "right";
		
		/**
		 * Aligns the viewport to the top, if the viewport's height is smaller
		 * than the scroller's height.
		 */
		public static const VERTICAL_ALIGN_TOP:String = "top";
		
		/**
		 * Aligns the viewport to the middle, if the viewport's height is smaller
		 * than the scroller's height.
		 */
		public static const VERTICAL_ALIGN_MIDDLE:String = "middle";
		
		/**
		 * Aligns the viewport to the bottom, if the viewport's height is smaller
		 * than the scroller's height.
		 */
		public static const VERTICAL_ALIGN_BOTTOM:String = "bottom";
		
		/**
		 * Flag to indicate that the clipping has changed.
		 */
		public static const INVALIDATION_FLAG_CLIPPING:String = "clipping";
		
		/**
		 * @private
		 * The minimum physical distance (in inches) that a touch must move
		 * before the scroller starts scrolling.
		 */
		private static const MINIMUM_DRAG_DISTANCE:Number = 0.04;
		
		/**
		 * @private
		 * The friction applied every frame when the scroller is "thrown".
		 */
		private static const FRICTION:Number = 0.9925;
		
		/**
		 * Constructor.
		 */
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
		private var _startTouchX:Number;
		private var _startTouchY:Number;
		private var _startHorizontalScrollPosition:Number;
		private var _startVerticalScrollPosition:Number;
		private var _previousTouchTime:int;
		private var _previousTouchX:Number;
		private var _previousTouchY:Number;
		private var _velocityX:Number;
		private var _velocityY:Number;
		private var _previousVelocityX:Number;
		private var _previousVelocityY:Number;
		
		private var _horizontalAutoScrollTween:GTween;
		private var _verticalAutoScrollTween:GTween;
		private var _isDraggingHorizontally:Boolean = false;
		private var _isDraggingVertically:Boolean = false;
		
		private var _viewPortWrapper:Sprite;
		
		/**
		 * @private
		 */
		private var _viewPort:DisplayObject;
		
		/**
		 * The display object displayed and scrolled within the Scroller.
		 */
		public function get viewPort():DisplayObject
		{
			return this._viewPort;
		}
		
		/**
		 * @private
		 */
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
		
		/**
		 * @private
		 */
		private var _horizontalScrollPosition:Number = 0;
		
		/**
		 * The number of pixels the scroller has been scrolled horizontally (on
		 * the x-axis).
		 */
		public function get horizontalScrollPosition():Number
		{
			return this._horizontalScrollPosition;
		}
		
		/**
		 * @private
		 */
		public function set horizontalScrollPosition(value:Number):void
		{
			if(this._horizontalScrollPosition == value)
			{
				return;
			}
			this._horizontalScrollPosition = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
			this._onScroll.dispatch(this);
		}
		
		/**
		 * @private
		 */
		private var _maxHorizontalScrollPosition:Number = 0;
		
		/**
		 * The maximum number of pixels the scroller may be scrolled
		 * horizontally (on the x-axis). This value is automatically calculated
		 * based on the width of the viewport. The <code>horizontalScrollPosition</code>
		 * property may have a higher value than the maximum due to elastic
		 * edges. However, once the user stops interacting with the scroller,
		 * it will automatically animate back to the maximum (or minimum, if
		 * below 0).
		 */
		public function get maxHorizontalScrollPosition():Number
		{
			return this._maxHorizontalScrollPosition;
		}
		
		/**
		 * @private
		 */
		private var _horizontalScrollPolicy:String = SCROLL_POLICY_AUTO;
		
		/**
		 * Determines whether the scroller may scroll horizontally (on the
		 * x-axis) or not.
		 */
		public function get horizontalScrollPolicy():String
		{
			return this._horizontalScrollPolicy;
		}
		
		/**
		 * @private
		 */
		public function set horizontalScrollPolicy(value:String):void
		{
			if(this._horizontalScrollPolicy == value)
			{
				return;
			}
			this._horizontalScrollPolicy = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
		}
		
		/**
		 * @private
		 */
		protected var _horizontalAlign:String = HORIZONTAL_ALIGN_LEFT;
		
		/**
		 * If the viewport's width is less than the scroller's width, it will
		 * be aligned to the left, center, or right of the scroller.
		 * 
		 * @see HORIZONTAL_ALIGN_LEFT
		 * @see HORIZONTAL_ALIGN_CENTER
		 * @see HORIZONTAL_ALIGN_RIGHT
		 */
		public function get horizontalAlign():String
		{
			return _horizontalAlign;
		}
		
		/**
		 * @private
		 */
		public function set horizontalAlign(value:String):void
		{
			if(this._horizontalAlign == value)
			{
				return;
			}
			this._horizontalAlign = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		/**
		 * @private
		 */
		private var _verticalScrollPosition:Number = 0;
		
		/**
		 * The number of pixels the scroller has been scrolled vertically (on
		 * the y-axis).
		 */
		public function get verticalScrollPosition():Number
		{
			return this._verticalScrollPosition;
		}
		
		/**
		 * @private
		 */
		public function set verticalScrollPosition(value:Number):void
		{
			if(this._verticalScrollPosition == value)
			{
				return;
			}
			this._verticalScrollPosition = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
			this._onScroll.dispatch(this);
		}
		
		/**
		 * @private
		 */
		private var _maxVerticalScrollPosition:Number = 0;
		
		/**
		 * The maximum number of pixels the scroller may be scrolled vertically
		 * (on the y-axis). This value is automatically calculated based on the 
		 * height of the viewport. The <code>verticalScrollPosition</code>
		 * property may have a higher value than the maximum due to elastic
		 * edges. However, once the user stops interacting with the scroller,
		 * it will automatically animate back to the maximum (or minimum, if
		 * below 0).
		 */
		public function get maxVerticalScrollPosition():Number
		{
			return this._maxVerticalScrollPosition;
		}
		
		/**
		 * @private
		 */
		private var _verticalScrollPolicy:String = SCROLL_POLICY_AUTO;
		
		/**
		 * Determines whether the scroller may scroll vertically (on the
		 * y-axis) or not.
		 */
		public function get verticalScrollPolicy():String
		{
			return this._verticalScrollPolicy;
		}
		
		/**
		 * @private
		 */
		public function set verticalScrollPolicy(value:String):void
		{
			if(this._verticalScrollPolicy == value)
			{
				return;
			}
			this._verticalScrollPolicy = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
		}
		
		/**
		 * @private
		 */
		protected var _verticalAlign:String = VERTICAL_ALIGN_TOP;
		
		/**
		 * If the viewport's height is less than the scroller's height, it will
		 * be aligned to the top, middle, or bottom of the scroller.
		 * 
		 * @see VERTICAL_ALIGN_TOP
		 * @see VERTICAL_ALIGN_MIDDLE
		 * @see VERTICAL_ALIGN_BOTTOM
		 */
		public function get verticalAlign():String
		{
			return _verticalAlign;
		}
		
		/**
		 * @private
		 */
		public function set verticalAlign(value:String):void
		{
			if(this._verticalAlign == value)
			{
				return;
			}
			this._verticalAlign = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		/**
		 * @private
		 */
		private var _clipContent:Boolean = false;
		
		/**
		 * If true, the viewport will be clipped to the scroller's bounds. In
		 * other words, anything appearing outside the scroller's bounds will
		 * not be visible.
		 * 
		 * <p>To improve performance, turn off clipping and place other display
		 * objects over the edges of the scroller to hide the content that
		 * bleeds outside of the scroller's bounds.</p>
		 */
		public function get clipContent():Boolean
		{
			return this._clipContent;
		}
		
		/**
		 * @private
		 */
		public function set clipContent(value:Boolean):void
		{
			if(this._clipContent == value)
			{
				return;
			}
			this._clipContent = value;
			this.invalidate(INVALIDATION_FLAG_CLIPPING);
		}
		
		/**
		 * @private
		 */
		protected var _onScroll:Signal = new Signal(Scroller);
		
		/**
		 * Dispatched when the scroller scrolls in either direction.
		 */
		public function get onScroll():ISignal
		{
			return this._onScroll;
		}
		
		private var _isScrollingStopped:Boolean = false;
		
		/**
		 * If the user is dragging the scroll, calling stopScrolling() will
		 * cause the scroller to ignore the drag.
		 */
		public function stopScrolling():void
		{
			this._isScrollingStopped = true;
		}
		
		/**
		 * @private
		 */
		override protected function initialize():void
		{
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		/**
		 * @private
		 */
		override protected function draw():void
		{
			const sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const scrollInvalid:Boolean = dataInvalid || this.isInvalid(INVALIDATION_FLAG_SCROLL);
			const clippingInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_CLIPPING);
			
			if(sizeInvalid)
			{
				this._background.width = this._width;
				this._background.height = this._height;
			}
			
			if(sizeInvalid || dataInvalid)
			{
				//stop animating. this is a serious change.
				if(this._horizontalAutoScrollTween)
				{
					this._horizontalAutoScrollTween.paused = true;
					this._horizontalAutoScrollTween = null;
				}
				if(this._verticalAutoScrollTween)
				{
					this._verticalAutoScrollTween.paused = true;
					this._verticalAutoScrollTween = null;
				}
				this._touchPointID = -1;
				this._velocityX = this._previousVelocityX = 0;
				this._velocityY = this._previousVelocityY = 0;
				if(this._viewPort)
				{
					this._maxHorizontalScrollPosition = Math.max(0, this._viewPort.width - this._width);
					this._maxVerticalScrollPosition = Math.max(0, this._viewPort.height - this._height);
				}
				else
				{
					this._maxHorizontalScrollPosition = 0;
					this._maxVerticalScrollPosition = 0;
				}
				this._horizontalScrollPosition = clamp(this._horizontalScrollPosition, 0, this._maxHorizontalScrollPosition);
				this._verticalScrollPosition = clamp(this._verticalScrollPosition, 0, this._maxVerticalScrollPosition);
			}
			
			if(sizeInvalid || dataInvalid || scrollInvalid || clippingInvalid)
			{
				this.scrollContent();
			}
		}
		
		/**
		 * @private
		 */
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
		
		/**
		 * @private
		 */
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
		
		/**
		 * @private
		 */
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
		
		/**
		 * @private
		 */
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
		
		/**
		 * @private
		 */
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
		
		/**
		 * @private
		 */
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
		
		/**
		 * @private
		 */
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
		
		/**
		 * @private
		 */
		protected function viewPort_onResize(viewPort:FoxholeControl):void
		{
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		/**
		 * @private
		 */
		protected function horizontalAutoScrollTween_onComplete(tween:GTween):void
		{
			if(this._horizontalAutoScrollTween == tween)
			{
				this._horizontalAutoScrollTween = null;
				this.finishScrollingHorizontally();
			}
		}
		
		/**
		 * @private
		 */
		protected function verticalAutoScrollTween_onComplete(tween:GTween):void
		{
			if(this._verticalAutoScrollTween == tween)
			{
				this._verticalAutoScrollTween = null;
				this.finishScrollingVertically();
			}
		}
		
		/**
		 * @private
		 */
		protected function touchHandler(event:TouchEvent):void
		{
			if(!this._isEnabled || this._touchPointID >= 0)
			{
				return;
			}
			const touch:Touch = event.getTouch(this);
			if(!touch || touch.phase != TouchPhase.BEGAN)
			{
				return;
			}
			const location:Point = touch.getLocation(this);
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
			this._velocityX = this._previousVelocityX = 0;
			this._velocityY = this._previousVelocityY = 0;
			this._previousTouchTime = getTimer();
			this._previousTouchX = this._startTouchX = location.x;
			this._previousTouchY = this._startTouchY = location.y;
			this._startHorizontalScrollPosition = this._horizontalScrollPosition;
			this._startVerticalScrollPosition = this._verticalScrollPosition;
			this._isDraggingHorizontally = false;
			this._isDraggingVertically = false;
			this._isScrollingStopped = false;
			
			//we need to listen on the stage because if we scroll the bottom or
			//right edge past the top of the scroller, it gets stuck and we stop
			//receiving touch events for "this".
			this.stage.addEventListener(TouchEvent.TOUCH, stage_touchHandler);
		}
		
		private function stage_touchHandler(event:TouchEvent):void
		{
			const touch:Touch = event.getTouch(this.stage);
			if(!touch || (touch.phase != TouchPhase.MOVED && touch.phase != TouchPhase.ENDED) || (this._touchPointID >= 0 && touch.id != this._touchPointID))
			{
				return;
			}
			if(touch.phase == TouchPhase.MOVED)
			{
				if(this._isScrollingStopped)
				{
					return;
				}
				const now:int = getTimer();
				const timeOffset:int = now - this._previousTouchTime;
				const location:Point = touch.getLocation(this);
				if(timeOffset > 0)
				{
					//we're keeping two velocity updates to improve accuracy
					this._previousVelocityX = this._velocityX;
					this._previousVelocityY = this._velocityY;
					this._velocityX = (location.x - this._previousTouchX) / timeOffset;
					this._velocityY = (location.y - this._previousTouchY) / timeOffset;
					this._previousTouchTime = now
					this._previousTouchX = location.x;
					this._previousTouchY = location.y;
				}
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
				this.stage.removeEventListener(TouchEvent.TOUCH, stage_touchHandler);
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
				
				if(!isFinishingHorizontally && this._horizontalScrollPolicy != SCROLL_POLICY_OFF)
				{
					//take the average for more accuracy
					this.throwHorizontally((this._velocityX + this._previousVelocityX) / 2);
				}
				
				if(!isFinishingVertically && this._verticalScrollPolicy != SCROLL_POLICY_OFF)
				{
					this.throwVertically((this._velocityY + this._previousVelocityY) / 2);
				}
			}
		}
		
		/**
		 * @private
		 */
		private function removedFromStageHandler(event:Event):void
		{
			this._touchPointID = -1;
			this._velocityX = this._previousVelocityX = 0;
			this._velocityY = this._previousVelocityY = 0;
			if(this._verticalAutoScrollTween)
			{
				this._verticalAutoScrollTween.paused = true;
				this._verticalAutoScrollTween = null;
			}
			if(this._horizontalAutoScrollTween)
			{
				this._horizontalAutoScrollTween.paused = true;
				this._horizontalAutoScrollTween = null;
			}
			
			//if we stopped the animation while the list was outside the scroll
			//bounds, then let's account for that
			this._horizontalScrollPosition = clamp(this._horizontalScrollPosition, 0, this._maxHorizontalScrollPosition);
			this._verticalScrollPosition = clamp(this._verticalScrollPosition, 0, this._maxVerticalScrollPosition);
		}
	}
}