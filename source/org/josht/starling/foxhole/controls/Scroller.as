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

Below is a list of certain publicly available software that is the source of
intellectual property in this class, along with the licensing terms that pertain
to those sources of IP.

The velocity and throwing physics calculations are loosely based on code from
the TouchScrolling library by Pavel fljot.
Copyright (c) 2011 Pavel fljot
License: Same as above.
Source: https://github.com/fljot/TouchScrolling
*/
package org.josht.starling.foxhole.controls
{
	import com.gskinner.motion.easing.Quintic;

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

	import starling.display.DisplayObject;
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
		 * The scroller may scroll, if the view port is larger than the
		 * scroller's bounds.
		 */
		public static const SCROLL_POLICY_AUTO:String = "auto";
		
		/**
		 * The scroller does not scroll at all.
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
		 * The point where we stop calculating velocity changes because floating
		 * point issues can start to appear.
		 */
		private static const MINIMUM_VELOCITY:Number = 0.02;
		
		/**
		 * @private
		 * The friction applied every frame when the scroller is "thrown".
		 */
		private static const FRICTION:Number = 0.998;

		/**
		 * @private
		 * Extra friction applied when the scroller is beyond its bounds and
		 * needs to bounce back.
		 */
		private static const EXTRA_FRICTION:Number = 0.95;

		/**
		 * @private
		 * Older saved velocities are given less importance.
		 */
		private static const VELOCITY_WEIGHTS:Vector.<Number> = new <Number>[2, 1.66, 1.33, 1];

		/**
		 * @private
		 */
		private static const MAXIMUM_SAVED_VELOCITY_COUNT:int = 4;
		
		/**
		 * Constructor.
		 */
		public function Scroller()
		{
			super();

			this._viewPortWrapper = new Sprite();
			this.addChild(this._viewPortWrapper);
			this.addEventListener(TouchEvent.TOUCH, touchHandler);
		}

		private var _touchPointID:int = -1;
		private var _startTouchX:Number;
		private var _startTouchY:Number;
		private var _startHorizontalScrollPosition:Number;
		private var _startVerticalScrollPosition:Number;
		private var _currentTouchX:Number;
		private var _currentTouchY:Number;
		private var _previousTouchTime:int;
		private var _previousTouchX:Number;
		private var _previousTouchY:Number;
		private var _velocityX:Number;
		private var _velocityY:Number;
		private var _previousVelocityX:Vector.<Number> = new <Number>[];
		private var _previousVelocityY:Vector.<Number> = new <Number>[];
		
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
		private var _hasElasticEdges:Boolean = true;
		
		/**
		 * Determines if the scrolling can go beyond the edges of the viewport.
		 */
		public function get hasElasticEdges():Boolean
		{
			return this._hasElasticEdges;
		}
		
		/**
		 * @private
		 */
		public function set hasElasticEdges(value:Boolean):void
		{
			this._hasElasticEdges = value;
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
			this._velocityX = 0;
			this._velocityY = 0;
			this._previousVelocityX.length = 0;
			this._previousVelocityY.length = 0;
		}
		
		/**
		 * Throws the scroller to the specified position. If you want to throw
		 * in one direction, pass in NaN or the current scroll position for the
		 * value that you do not want to change.
		 */
		public function throwTo(targetHorizontalScrollPosition:Number = NaN, targetVerticalScrollPosition:Number = NaN, duration:Number = 0.25):void
		{
			if(!isNaN(targetHorizontalScrollPosition))
			{
				if(this._horizontalAutoScrollTween)
				{
					this._horizontalAutoScrollTween.paused = true;
					this._horizontalAutoScrollTween = null;
				}
				if(this._horizontalScrollPosition != targetHorizontalScrollPosition)
				{
					this._horizontalAutoScrollTween = new GTween(this, duration,
					{
						horizontalScrollPosition: targetHorizontalScrollPosition
					},
					{
						ease: Quintic.easeOut,
						onComplete: horizontalAutoScrollTween_onComplete
					});
				}
				else
				{
					this.finishScrollingHorizontally();
				}
			}
			
			if(!isNaN(targetVerticalScrollPosition))
			{
				if(this._verticalAutoScrollTween)
				{
					this._verticalAutoScrollTween.paused = true;
					this._verticalAutoScrollTween = null;
				}
				if(this._verticalScrollPosition != targetVerticalScrollPosition)
				{
					this._verticalAutoScrollTween = new GTween(this, duration,
					{
						verticalScrollPosition: targetVerticalScrollPosition
					},
					{
						ease: Quintic.easeOut,
						onComplete: verticalAutoScrollTween_onComplete
					});
				}
				else
				{
					this.finishScrollingVertically();
				}
			}
		}

		override public function hitTest(localPoint:Point, forTouch:Boolean = false):DisplayObject
		{
			//first check the children for touches
			var result:DisplayObject = super.hitTest(localPoint, forTouch);
			if(!result)
			{
				//we want to register touches in our hitArea as a last resort
				if(forTouch && (!this.visible || !this.touchable))
				{
					return null;
				}
				//I don't know why we need to adjust for viewPortWrapper's location
				localPoint.x += this._viewPortWrapper.x;
				localPoint.y += this._viewPortWrapper.y;
				result = this._hitArea.containsPoint(localPoint) ? this : null;
				localPoint.x -= this._viewPortWrapper.x;
				localPoint.y -= this._viewPortWrapper.y;
			}
			return result;
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
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const scrollInvalid:Boolean = dataInvalid || this.isInvalid(INVALIDATION_FLAG_SCROLL);
			const clippingInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_CLIPPING);

			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;
			
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
				this._velocityX = 0;
				this._velocityY = 0;
				this._previousVelocityX.length = 0;
				this._previousVelocityY.length = 0;
				this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
				this.stage.removeEventListener(TouchEvent.TOUCH, stage_touchHandler);
				if(this._viewPort)
				{
					this._maxHorizontalScrollPosition = Math.max(0, this._viewPort.width - this.actualWidth);
					this._maxVerticalScrollPosition = Math.max(0, this._viewPort.height - this.actualHeight);
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
		protected function autoSizeIfNeeded():Boolean
		{
			const needsWidth:Boolean = isNaN(this.explicitWidth);
			const needsHeight:Boolean = isNaN(this.explicitHeight);
			if(!needsWidth && !needsHeight)
			{
				return false;
			}

			if(this._viewPort is FoxholeControl)
			{
				FoxholeControl(this._viewPort).validate();
			}

			var newWidth:Number = this.explicitWidth;
			var newHeight:Number = this.explicitHeight;
			if(needsWidth)
			{
				newWidth = this._viewPort.width;
			}
			if(needsHeight)
			{
				newHeight = this._viewPort.height;
			}
			this.setSizeInternal(newWidth, newHeight, false);
			return true;
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
					offsetX = (this.actualWidth - this._viewPort.width) / 2;
				}
				else if(this._horizontalAlign == HORIZONTAL_ALIGN_RIGHT)
				{
					offsetX = this.actualWidth - this._viewPort.width;
				}
			}
			if(this._maxVerticalScrollPosition == 0)
			{
				if(this._verticalAlign == VERTICAL_ALIGN_MIDDLE)
				{
					offsetY = (this.actualHeight - this._viewPort.height) / 2;
				}
				else if(this._verticalAlign == VERTICAL_ALIGN_BOTTOM)
				{
					offsetY = this.actualHeight - this._viewPort.height;
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
				scrollRect.width = this.actualWidth;
				scrollRect.height = this.actualHeight;
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
			if(position < 0)
			{
				if(this._hasElasticEdges)
				{
					position /= 2;
				}
				else
				{
					position = 0;
				}
			}
			else if(position > this._maxHorizontalScrollPosition)
			{
				if(this._hasElasticEdges)
				{
					position -= (position - this._maxHorizontalScrollPosition) / 2;
				}
				else
				{
					position = this._maxHorizontalScrollPosition;
				}
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
			if(position < 0)
			{
				if(this._hasElasticEdges)
				{
					position /= 2;
				}
				else
				{
					position = 0;
				}
			}
			else if(position > this._maxVerticalScrollPosition)
			{
				if(this._hasElasticEdges)
				{
					position -= (position - this._maxVerticalScrollPosition) / 2;
				}
				else
				{
					position = this._maxVerticalScrollPosition;
				}
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
			this.throwTo(targetHorizontalScrollPosition, NaN, 0.24);
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
			this.throwTo(NaN, targetVerticalScrollPosition, 0.24);
		}
		
		/**
		 * @private
		 */
		protected function throwHorizontally(pixelsPerMS:Number):void
		{
			var absPixelsPerMS:Number = Math.abs(pixelsPerMS);
			if(absPixelsPerMS <= MINIMUM_VELOCITY)
			{
				this.finishScrollingHorizontally();
				return;
			}
			var targetHorizontalScrollPosition:Number = this._horizontalScrollPosition + (pixelsPerMS - MINIMUM_VELOCITY) / Math.log(FRICTION);
			if(targetHorizontalScrollPosition < 0 || targetHorizontalScrollPosition > this._maxHorizontalScrollPosition)
			{
				var duration:Number = 0;
				targetHorizontalScrollPosition = this._horizontalScrollPosition;
				while(Math.abs(pixelsPerMS) > MINIMUM_VELOCITY)
				{
					targetHorizontalScrollPosition -= pixelsPerMS;
					if(targetHorizontalScrollPosition < 0 || targetHorizontalScrollPosition > this._maxHorizontalScrollPosition)
					{
						if(this._hasElasticEdges)
						{
							pixelsPerMS *= FRICTION * EXTRA_FRICTION;
						}
						else
						{
							targetHorizontalScrollPosition = clamp(targetHorizontalScrollPosition, 0, this._maxHorizontalScrollPosition);
							duration++;
							break;
						}
					}
					else
					{
						pixelsPerMS *= FRICTION;
					}
					duration++;
				}
			}
			else
			{
				duration = Math.log(MINIMUM_VELOCITY / absPixelsPerMS) / Math.log(FRICTION);
			}
			this.throwTo(targetHorizontalScrollPosition, NaN, duration / 1000);
		}
		
		/**
		 * @private
		 */
		protected function throwVertically(pixelsPerMS:Number):void
		{
			var absPixelsPerMS:Number = Math.abs(pixelsPerMS);
			if(absPixelsPerMS <= MINIMUM_VELOCITY)
			{
				this.finishScrollingVertically();
				return;
			}

			var targetVerticalScrollPosition:Number = this._verticalScrollPosition + (pixelsPerMS - MINIMUM_VELOCITY) / Math.log(FRICTION);
			if(targetVerticalScrollPosition < 0 || targetVerticalScrollPosition > this._maxVerticalScrollPosition)
			{
				var duration:Number = 0;
				targetVerticalScrollPosition = this._verticalScrollPosition;
				while(Math.abs(pixelsPerMS) > MINIMUM_VELOCITY)
				{
					targetVerticalScrollPosition -= pixelsPerMS;
					if(targetVerticalScrollPosition < 0 || targetVerticalScrollPosition > this._maxVerticalScrollPosition)
					{
						if(this._hasElasticEdges)
						{
							pixelsPerMS *= FRICTION * EXTRA_FRICTION;
						}
						else
						{
							targetVerticalScrollPosition = clamp(targetVerticalScrollPosition, 0, this._maxVerticalScrollPosition);
							duration++;
							break;
						}
					}
					else
					{
						pixelsPerMS *= FRICTION;
					}
					duration++;
				}
			}
			else
			{
				duration = Math.log(MINIMUM_VELOCITY / absPixelsPerMS) / Math.log(FRICTION);
			}
			this.throwTo(NaN, targetVerticalScrollPosition, duration / 1000);
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
			this._horizontalAutoScrollTween = null;
			this.finishScrollingHorizontally();
		}
		
		/**
		 * @private
		 */
		protected function verticalAutoScrollTween_onComplete(tween:GTween):void
		{
			this._verticalAutoScrollTween = null;
			this.finishScrollingVertically();
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
			this._velocityX = 0;
			this._velocityY = 0;
			this._previousVelocityX.length = 0;
			this._previousVelocityY.length = 0;
			this._previousTouchTime = getTimer();
			this._previousTouchX = this._startTouchX = this._currentTouchX = location.x;
			this._previousTouchY = this._startTouchY = this._currentTouchY = location.y;
			this._startHorizontalScrollPosition = this._horizontalScrollPosition;
			this._startVerticalScrollPosition = this._verticalScrollPosition;
			this._isDraggingHorizontally = false;
			this._isDraggingVertically = false;
			this._isScrollingStopped = false;

			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
			//we need to listen on the stage because if we scroll the bottom or
			//right edge past the top of the scroller, it gets stuck and we stop
			//receiving touch events for "this".
			this.stage.addEventListener(TouchEvent.TOUCH, stage_touchHandler);
		}

		private function enterFrameHandler(event:Event):void
		{
			if(this._isScrollingStopped)
			{
				return;
			}
			const now:int = getTimer();
			const timeOffset:int = now - this._previousTouchTime;
			if(timeOffset > 0)
			{
				//we're keeping two velocity updates to improve accuracy
				this._previousVelocityX.unshift(this._velocityX);
				if(this._previousVelocityX.length > MAXIMUM_SAVED_VELOCITY_COUNT)
				{
					this._previousVelocityX.pop();
				}
				this._previousVelocityY.unshift(this._velocityY);
				if(this._previousVelocityY.length > MAXIMUM_SAVED_VELOCITY_COUNT)
				{
					this._previousVelocityY.pop();
				}
				this._velocityX = (this._currentTouchX - this._previousTouchX) / timeOffset;
				this._velocityY = (this._currentTouchY - this._previousTouchY) / timeOffset;
				this._previousTouchTime = now;
				this._previousTouchX = this._currentTouchX;
				this._previousTouchY = this._currentTouchY;
			}
			const horizontalInchesMoved:Number = Math.abs(this._currentTouchX - this._startTouchX) / Capabilities.screenDPI;
			const verticalInchesMoved:Number = Math.abs(this._currentTouchY - this._startTouchY) / Capabilities.screenDPI;
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
				this.updateHorizontalScrollFromTouchPosition(this._currentTouchX);
			}
			if(this._isDraggingVertically && !this._verticalAutoScrollTween)
			{
				this.updateVerticalScrollFromTouchPosition(this._currentTouchY);
			}
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
				//we're saving these to use in the enter frame handler because
				//that provides a longer time offset
				const location:Point = touch.getLocation(this);
				this._currentTouchX = location.x;
				this._currentTouchY = location.y;
			}
			else if(touch.phase == TouchPhase.ENDED)
			{
				this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
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
					var sum:Number = this._velocityX * 2.33;
					var velocityCount:int = this._previousVelocityX.length;
					var totalWeight:Number = 0;
					for(var i:int = 0; i < velocityCount; i++)
					{
						var weight:Number = VELOCITY_WEIGHTS[i];
						sum += this._previousVelocityX.shift() * weight;
						totalWeight += weight;
					}
					this.throwHorizontally(sum / totalWeight);
				}
				
				if(!isFinishingVertically && this._verticalScrollPolicy != SCROLL_POLICY_OFF)
				{
					sum = this._velocityY * 2.33;
					velocityCount = this._previousVelocityY.length;
					totalWeight = 0;
					for(i = 0; i < velocityCount; i++)
					{
						weight = VELOCITY_WEIGHTS[i];
						sum += this._previousVelocityY.shift() * weight;
						totalWeight += weight;
					}
					this.throwVertically(sum / totalWeight);
				}
			}
		}
		
		/**
		 * @private
		 */
		private function removedFromStageHandler(event:Event):void
		{
			this._touchPointID = -1;
			this._velocityX = 0;
			this._velocityY = 0;
			this._previousVelocityX.length = 0;
			this._previousVelocityY.length = 0;
			this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			this.stage.removeEventListener(TouchEvent.TOUCH, stage_touchHandler);
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