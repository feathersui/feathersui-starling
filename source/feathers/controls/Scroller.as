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
package feathers.controls
{
	import com.gskinner.motion.easing.Cubic;
	import com.gskinner.motion.easing.Sine;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.utils.getTimer;
	
	import feathers.controls.supportClasses.IViewPort;
	import feathers.core.FeathersControl;
	import feathers.core.PropertyProxy;
	import feathers.display.ScrollRectManager;
	import feathers.display.Sprite;
	import feathers.motion.GTween;
	import feathers.system.DeviceCapabilities;
	import feathers.utils.math.clamp;
	import feathers.utils.math.roundDownToNearest;
	import feathers.utils.math.roundToNearest;
	import feathers.utils.math.roundUpToNearest;
	
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * Allows horizontal and vertical scrolling of a viewport (which may be any
	 * Starling display object).
	 *
	 * <p>Will react to the <code>onResize</code> signal dispatched by UI
	 * controls to adjust the maximum scroll positions. For regular Starling
	 * display objects, the <code>invalidate()</code> function needs to be
	 * called on the <code>Scroller</code> when they resize because the
	 * <code>Scroller</code> cannot detect the change.</p>
	 */
	public class Scroller extends FeathersControl
	{
		/**
		 * @private
		 */
		private static var helperPoint:Point = new Point();

		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_SCROLL_BAR_RENDERER:String = "scrollBarRenderer";

		/**
		 * The scroller may scroll if the view port is larger than the
		 * scroller's bounds. If the interaction mode is touch, the elastic
		 * edges will only be active if the maximum scroll position is greater
		 * than zero. If the scroll bar display mode is fixed, the scroll bar
		 * will only be visible when the maximum scroll position is greater than
		 * zero.
		 */
		public static const SCROLL_POLICY_AUTO:String = "auto";

		/**
		 * The scroller will always scroll. If the interaction mode is touch,
		 * elastic edges will always be active, even when the maximum scroll
		 * position is zero. If the scroll bar display mode is fixed, the scroll
		 * bar will always be visible.
		 */
		public static const SCROLL_POLICY_ON:String = "on";
		
		/**
		 * The scroller does not scroll at all. If the scroll bar display mode
		 * is fixed or float, the scroll bar will never be visible.
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
		 * The scroll bars appear above the scroller's view port, and fade out
		 * when not in use.
		 */
		public static const SCROLL_BAR_DISPLAY_MODE_FLOAT:String = "float";

		/**
		 * The scroll bars are always visible and appear next to the scroller's
		 * view port, making the view port smaller than the scroller.
		 */
		public static const SCROLL_BAR_DISPLAY_MODE_FIXED:String = "fixed";

		/**
		 * The scroll bars are never visible.
		 */
		public static const SCROLL_BAR_DISPLAY_MODE_NONE:String = "none";

		/**
		 * The user may touch anywhere on the scroller and drag to scroll.
		 */
		public static const INTERACTION_MODE_TOUCH:String = "touch";

		/**
		 * The user may interact with the scroll bars to scroll.
		 */
		public static const INTERACTION_MODE_MOUSE:String = "mouse";
		
		/**
		 * Flag to indicate that the clipping has changed.
		 */
		protected static const INVALIDATION_FLAG_CLIPPING:String = "clipping";
		
		/**
		 * @private
		 * The minimum physical distance (in inches) that a touch must move
		 * before the scroller starts scrolling.
		 */
		private static const MINIMUM_DRAG_DISTANCE:Number = 0.04;

		/**
		 * @private
		 * The minimum physical velocity (in inches per second) that a touch
		 * must move before the scroller will "throw" to the next page.
		 * Otherwise, it will settle to the nearest page.
		 */
		private static const MINIMUM_PAGE_VELOCITY:Number = 5;

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
		 * The default value added to the <code>nameList</code> of the
		 * horizontal scroll bar.
		 */
		public static const DEFAULT_CHILD_NAME_HORIZONTAL_SCROLL_BAR:String = "feathers-scroller-horizontal-scroll-bar";

		/**
		 * The default value added to the <code>nameList</code> of the vertical
		 * scroll bar.
		 */
		public static const DEFAULT_CHILD_NAME_VERTICAL_SCROLL_BAR:String = "feathers-scroller-vertical-scroll-bar";

		/**
		 * @private
		 */
		protected static function defaultHorizontalScrollBarFactory():IScrollBar
		{
			const scrollBar:SimpleScrollBar = new SimpleScrollBar();
			scrollBar.direction = SimpleScrollBar.DIRECTION_HORIZONTAL;
			return scrollBar;
		}

		/**
		 * @private
		 */
		protected static function defaultVerticalScrollBarFactory():IScrollBar
		{
			const scrollBar:SimpleScrollBar = new SimpleScrollBar();
			scrollBar.direction = SimpleScrollBar.DIRECTION_VERTICAL;
			return scrollBar;
		}
		
		/**
		 * Constructor.
		 */
		public function Scroller()
		{
			super();

			this._viewPortWrapper = new Sprite();
			this.addChild(this._viewPortWrapper);

			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}

		/**
		 * The value added to the <code>nameList</code> of the horizontal scroll
		 * bar.
		 */
		protected var horizontalScrollBarName:String = DEFAULT_CHILD_NAME_HORIZONTAL_SCROLL_BAR;

		/**
		 * The value added to the <code>nameList</code> of the vertical scroll
		 * bar.
		 */
		protected var verticalScrollBarName:String = DEFAULT_CHILD_NAME_VERTICAL_SCROLL_BAR;

		/**
		 * The horizontal scrollbar instance. May be null.
		 */
		protected var horizontalScrollBar:IScrollBar;

		/**
		 * The vertical scrollbar instance. May be null.
		 */
		protected var verticalScrollBar:IScrollBar;

		/**
		 * @private
		 */
		protected var _horizontalScrollBarHeightOffset:Number;

		/**
		 * @private
		 */
		protected var _verticalScrollBarWidthOffset:Number;

		private var _horizontalScrollBarTouchPointID:int = -1;
		private var _verticalScrollBarTouchPointID:int = -1;
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
		private var _velocityX:Number = 0;
		private var _velocityY:Number = 0;
		private var _previousVelocityX:Vector.<Number> = new <Number>[];
		private var _previousVelocityY:Vector.<Number> = new <Number>[];
		private var _lastViewPortWidth:Number = 0;
		private var _lastViewPortHeight:Number = 0;
		
		private var _horizontalAutoScrollTween:GTween;
		private var _verticalAutoScrollTween:GTween;
		private var _isDraggingHorizontally:Boolean = false;
		private var _isDraggingVertically:Boolean = false;

		private var _viewPortWrapper:Sprite;

		/**
		 * @private
		 */
		protected var ignoreViewPortResizing:Boolean = false;
		
		/**
		 * @private
		 */
		private var _viewPort:IViewPort;
		
		/**
		 * The display object displayed and scrolled within the Scroller.
		 */
		public function get viewPort():IViewPort
		{
			return this._viewPort;
		}
		
		/**
		 * @private
		 */
		public function set viewPort(value:IViewPort):void
		{
			if(this._viewPort == value)
			{
				return;
			}
			if(this._viewPort)
			{
				this._viewPort.onResize.remove(viewPort_onResize);
				this._viewPortWrapper.removeChild(FeathersControl(this._viewPort));
			}
			this._viewPort = value;
			if(this._viewPort)
			{
				this._viewPort.onResize.add(viewPort_onResize);
				this._viewPortWrapper.addChild(FeathersControl(this._viewPort));
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _snapToPages:Boolean = false;

		/**
		 * Determines if scrolling will snap to the nearest page.
		 */
		public function get snapToPages():Boolean
		{
			return this._snapToPages;
		}

		/**
		 * @private
		 */
		public function set snapToPages(value:Boolean):void
		{
			if(this._snapToPages == value)
			{
				return;
			}
			this._snapToPages = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
		}

		/**
		 * @private
		 */
		private var _horizontalScrollBarFactory:Function = defaultHorizontalScrollBarFactory;

		/**
		 * Creates the horizontal scroll bar.
		 *
		 * <p>This function is expected to have the following signature:</p>
		 *
		 * <pre>function():IScrollBar</pre>
		 */
		public function get horizontalScrollBarFactory():Function
		{
			return this._horizontalScrollBarFactory;
		}

		/**
		 * @private
		 */
		public function set horizontalScrollBarFactory(value:Function):void
		{
			if(this._horizontalScrollBarFactory == value)
			{
				return;
			}
			this._horizontalScrollBarFactory = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL_BAR_RENDERER);
		}

		/**
		 * @private
		 */
		private var _horizontalScrollBarProperties:PropertyProxy;

		/**
		 * A set of key/value pairs to be passed down to the scroller's
		 * horizontal scroll bar instance (if it exists). The scroll bar is an
		 * <code>IScrollBar</code> implementation.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
		 * which is in a <code>Scroller</code> which is in a <code>List</code>,
		 * you can use the following syntax:</p>
		 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * @see #horizontalScrollBarFactory
		 */
		public function get horizontalScrollBarProperties():Object
		{
			if(!this._horizontalScrollBarProperties)
			{
				this._horizontalScrollBarProperties = new PropertyProxy(horizontalScrollBarProperties_onChange);
			}
			return this._horizontalScrollBarProperties;
		}

		/**
		 * @private
		 */
		public function set horizontalScrollBarProperties(value:Object):void
		{
			if(this._horizontalScrollBarProperties == value)
			{
				return;
			}
			if(!value)
			{
				value = new PropertyProxy();
			}
			if(!(value is PropertyProxy))
			{
				const newValue:PropertyProxy = new PropertyProxy();
				for(var propertyName:String in value)
				{
					newValue[propertyName] = value[propertyName];
				}
				value = newValue;
			}
			if(this._horizontalScrollBarProperties)
			{
				this._horizontalScrollBarProperties.onChange.remove(horizontalScrollBarProperties_onChange);
			}
			this._horizontalScrollBarProperties = PropertyProxy(value);
			if(this._horizontalScrollBarProperties)
			{
				this._horizontalScrollBarProperties.onChange.add(horizontalScrollBarProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _verticalScrollBarFactory:Function = defaultVerticalScrollBarFactory;

		/**
		 * Creates the vertical scroll bar.
		 *
		 * <p>This function is expected to have the following signature:</p>
		 *
		 * <pre>function():IScrollBar</pre>
		 */
		public function get verticalScrollBarFactory():Function
		{
			return this._verticalScrollBarFactory;
		}

		/**
		 * @private
		 */
		public function set verticalScrollBarFactory(value:Function):void
		{
			if(this._verticalScrollBarFactory == value)
			{
				return;
			}
			this._verticalScrollBarFactory = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL_BAR_RENDERER);
		}

		/**
		 * @private
		 */
		private var _verticalScrollBarProperties:PropertyProxy;

		/**
		 * A set of key/value pairs to be passed down to the scroller's
		 * vertical scroll bar instance (if it exists). The scroll bar is an
		 * <code>IScrollBar</code> implementation.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
		 * which is in a <code>Scroller</code> which is in a <code>List</code>,
		 * you can use the following syntax:</p>
		 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * @see #verticalScrollBarFactory
		 */
		public function get verticalScrollBarProperties():Object
		{
			if(!this._verticalScrollBarProperties)
			{
				this._verticalScrollBarProperties = new PropertyProxy(verticalScrollBarProperties_onChange);
			}
			return this._verticalScrollBarProperties;
		}

		/**
		 * @private
		 */
		public function set verticalScrollBarProperties(value:Object):void
		{
			if(this._horizontalScrollBarProperties == value)
			{
				return;
			}
			if(!value)
			{
				value = new PropertyProxy();
			}
			if(!(value is PropertyProxy))
			{
				const newValue:PropertyProxy = new PropertyProxy();
				for(var propertyName:String in value)
				{
					newValue[propertyName] = value[propertyName];
				}
				value = newValue;
			}
			if(this._verticalScrollBarProperties)
			{
				this._verticalScrollBarProperties.onChange.remove(verticalScrollBarProperties_onChange);
			}
			this._verticalScrollBarProperties = PropertyProxy(value);
			if(this._verticalScrollBarProperties)
			{
				this._verticalScrollBarProperties.onChange.add(verticalScrollBarProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _horizontalScrollStep:Number = 1;

		/**
		 * The number of pixels the scroller can be stepped horizontally. Passed
		 * to the horizontal scroll bar, if one exists. Touch scrolling is not
		 * affected by the step value.
		 */
		public function get horizontalScrollStep():Number
		{
			return this._horizontalScrollStep;
		}

		/**
		 * @private
		 */
		public function set horizontalScrollStep(value:Number):void
		{
			if(this._horizontalScrollStep == value)
			{
				return;
			}
			if(isNaN(value))
			{
				//nope
				throw new ArgumentError("horizontalScrollStep cannot be NaN.");
			}
			this._horizontalScrollStep = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
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
			if(this._snapScrollPositionsToPixels)
			{
				value = Math.round(value);
			}
			if(this._horizontalScrollPosition == value)
			{
				return;
			}
			if(isNaN(value))
			{
				//there isn't any recovery from this, so stop it early
				throw new ArgumentError("horizontalScrollPosition cannot be NaN.");
			}
			this._horizontalScrollPosition = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
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
		protected var _horizontalPageIndex:int = 0;

		/**
		 * The index of the horizontal page, if snapping is enabled. If snapping
		 * is disabled, the index will always be <code>0</code>.
		 */
		public function get horizontalPageIndex():int
		{
			return this._horizontalPageIndex;
		}
		
		/**
		 * @private
		 */
		private var _horizontalScrollPolicy:String = SCROLL_POLICY_AUTO;
		
		/**
		 * Determines whether the scroller may scroll horizontally (on the
		 * x-axis) or not.
		 *
		 * @see #SCROLL_POLICY_AUTO
		 * @see #SCROLL_POLICY_ON
		 * @see #SCROLL_POLICY_OFF
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
			this.invalidate(INVALIDATION_FLAG_SCROLL, INVALIDATION_FLAG_SCROLL_BAR_RENDERER);
		}
		
		/**
		 * @private
		 */
		protected var _horizontalAlign:String = HORIZONTAL_ALIGN_LEFT;
		
		/**
		 * If the viewport's width is less than the scroller's width, it will
		 * be aligned to the left, center, or right of the scroller.
		 * 
		 * @see #HORIZONTAL_ALIGN_LEFT
		 * @see #HORIZONTAL_ALIGN_CENTER
		 * @see #HORIZONTAL_ALIGN_RIGHT
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
		private var _verticalScrollStep:Number = 1;

		/**
		 * The number of pixels the scroller can be stepped vertically. Passed
		 * to the vertical scroll bar, if it exists, and used for scrolling with
		 * the mouse wheel. Touch scrolling is not affected by the step value.
		 */
		public function get verticalScrollStep():Number
		{
			return this._verticalScrollStep;
		}

		/**
		 * @private
		 */
		public function set verticalScrollStep(value:Number):void
		{
			if(this._verticalScrollStep == value)
			{
				return;
			}
			if(isNaN(value))
			{
				//nope
				throw new ArgumentError("verticalScrollStep cannot be NaN.");
			}
			this._verticalScrollStep = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
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
			if(this._snapScrollPositionsToPixels)
			{
				value = Math.round(value);
			}
			if(this._verticalScrollPosition == value)
			{
				return;
			}
			if(isNaN(value))
			{
				//there isn't any recovery from this, so stop it early
				throw new ArgumentError("verticalScrollPosition cannot be NaN.");
			}
			this._verticalScrollPosition = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
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
		protected var _verticalPageIndex:int = 0;

		/**
		 * The index of the vertical page, if snapping is enabled. If snapping
		 * is disabled, the index will always be <code>0</code>.
		 */
		public function get verticalPageIndex():int
		{
			return this._verticalPageIndex;
		}
		
		/**
		 * @private
		 */
		private var _verticalScrollPolicy:String = SCROLL_POLICY_AUTO;
		
		/**
		 * Determines whether the scroller may scroll vertically (on the
		 * y-axis) or not.
		 *
		 * @see #SCROLL_POLICY_AUTO
		 * @see #SCROLL_POLICY_ON
		 * @see #SCROLL_POLICY_OFF
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
			this.invalidate(INVALIDATION_FLAG_SCROLL, INVALIDATION_FLAG_SCROLL_BAR_RENDERER);
		}
		
		/**
		 * @private
		 */
		protected var _verticalAlign:String = VERTICAL_ALIGN_TOP;
		
		/**
		 * If the viewport's height is less than the scroller's height, it will
		 * be aligned to the top, middle, or bottom of the scroller.
		 * 
		 * @see #VERTICAL_ALIGN_TOP
		 * @see #VERTICAL_ALIGN_MIDDLE
		 * @see #VERTICAL_ALIGN_BOTTOM
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
		private var _clipContent:Boolean = true;
		
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
		private var _elasticity:Number = 0.33;

		/**
		 * If the scroll position goes outside the minimum or maximum bounds,
		 * the scrolling will be constrained using this multiplier.
		 */
		public function get elasticity():Number
		{
			return this._elasticity;
		}

		/**
		 * @private
		 */
		public function set elasticity(value:Number):void
		{
			this._elasticity = value;
		}

		/**
		 * @private
		 */
		protected var _scrollBarDisplayMode:String = SCROLL_BAR_DISPLAY_MODE_FLOAT;

		/**
		 * Determines how the scroll bars are displayed.
		 *
		 * @see #SCROLL_BAR_DISPLAY_MODE_FLOAT
		 * @see #SCROLL_BAR_DISPLAY_MODE_FIXED
		 * @see #SCROLL_BAR_DISPLAY_MODE_NONE
		 */
		public function get scrollBarDisplayMode():String
		{
			return this._scrollBarDisplayMode;
		}

		/**
		 * @private
		 */
		public function set scrollBarDisplayMode(value:String):void
		{
			if(this._scrollBarDisplayMode == value)
			{
				return;
			}
			this._scrollBarDisplayMode = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _interactionMode:String = INTERACTION_MODE_TOUCH;

		/**
		 * Determines how the user may interact with the scroller.
		 *
		 * @see #INTERACTION_MODE_TOUCH
		 * @see #INTERACTION_MODE_MOUSE
		 */
		public function get interactionMode():String
		{
			return this._interactionMode;
		}

		/**
		 * @private
		 */
		public function set interactionMode(value:String):void
		{
			if(this._interactionMode == value)
			{
				return;
			}
			this._interactionMode = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _horizontalScrollBarHideTween:GTween;

		/**
		 * @private
		 */
		protected var _verticalScrollBarHideTween:GTween;

		/**
		 * @private
		 */
		protected var _hideScrollBarAnimationDuration:Number = 0.2;

		/**
		 * The duration, in seconds, of the animation when a scroll bar fades
		 * out.
		 */
		public function get hideScrollBarAnimationDuration():Number
		{
			return this._hideScrollBarAnimationDuration;
		}

		/**
		 * @private
		 */
		public function set hideScrollBarAnimationDuration(value:Number):void
		{
			this._hideScrollBarAnimationDuration = value;
		}

		/**
		 * @private
		 */
		protected var _elasticSnapDuration:Number = 0.24;

		/**
		 * The duration, in seconds, of the animation when a the scroller snaps
		 * back to the minimum or maximum position after going out of bounds.
		 */
		public function get elasticSnapDuration():Number
		{
			return this._elasticSnapDuration;
		}

		/**
		 * @private
		 */
		public function set elasticSnapDuration(value:Number):void
		{
			this._elasticSnapDuration = value;
		}

		/**
		 * @private
		 */
		protected var _pageThrowDuration:Number = 0.5;

		/**
		 * The duration, in seconds, of the animation when a the scroller is
		 * thrown to a page.
		 */
		public function get pageThrowDuration():Number
		{
			return this._pageThrowDuration;
		}

		/**
		 * @private
		 */
		public function set pageThrowDuration(value:Number):void
		{
			this._pageThrowDuration = value;
		}

		/**
		 * @private
		 */
		protected var _throwEase:Function = Cubic.easeOut;

		/**
		 * The easing function used for "throw" animations.
		 */
		public function get throwEase():Function
		{
			return this._throwEase;
		}

		/**
		 * @private
		 */
		public function set throwEase(value:Function):void
		{
			this._throwEase = value;
		}

		/**
		 * @private
		 */
		protected var _snapScrollPositionsToPixels:Boolean = false;

		/**
		 * If enabled, the scroll position will always be adjusted to whole
		 * pixels.
		 */
		public function get snapScrollPositionsToPixels():Boolean
		{
			return this._snapScrollPositionsToPixels;
		}

		/**
		 * @private
		 */
		public function set snapScrollPositionsToPixels(value:Boolean):void
		{
			if(this._snapScrollPositionsToPixels == value)
			{
				return;
			}
			this._snapScrollPositionsToPixels = value;
			if(this._snapScrollPositionsToPixels)
			{
				this.horizontalScrollPosition = Math.round(this._horizontalScrollPosition);
				this.verticalScrollPosition = Math.round(this._verticalScrollPosition);
			}
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

		/**
		 * @private
		 */
		protected var _onDragStart:Signal = new Signal(Scroller);

		/**
		 * Dispatched when a drag has begun that will make the scroller begin
		 * scrolling in either direction.
		 */
		public function get onDragStart():ISignal
		{
			return this._onDragStart;
		}

		/**
		 * @private
		 */
		protected var _onDragEnd:Signal = new Signal(Scroller);

		/**
		 * Dispatched when a drag has ended that will make the scroller end
		 * scrolling in either direction.
		 */
		public function get onDragEnd():ISignal
		{
			return this._onDragEnd;
		}
		
		private var _isScrollingStopped:Boolean = false;
		
		/**
		 * If the user is scrolling with touch or if the scrolling is animated,
		 * calling stopScrolling() will cause the scroller to ignore the drag
		 * and stop animations.
		 */
		public function stopScrolling():void
		{
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
		public function throwTo(targetHorizontalScrollPosition:Number = NaN, targetVerticalScrollPosition:Number = NaN, duration:Number = 0.5):void
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
						ease: this._throwEase,
						onComplete: horizontalAutoScrollTween_onComplete
					});
					this._horizontalAutoScrollTween.init();
				}
				else
				{
					this.finishScrollingHorizontally();
				}
			}
			else
			{
				this.hideHorizontalScrollBar();
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
						ease: this._throwEase,
						onComplete: verticalAutoScrollTween_onComplete
					});
					this._verticalAutoScrollTween.init();
				}
				else
				{
					this.finishScrollingVertically();
				}
			}
			else
			{
				this.hideVerticalScrollBar();
			}
		}

		/**
		 * @private
		 */
		override public function hitTest(localPoint:Point, forTouch:Boolean = false):DisplayObject
		{
			//save localX and localY because localPoint could change after the
			//call to super.hitTest().
			const localX:Number = localPoint.x;
			const localY:Number = localPoint.y;
			//first check the children for touches
			var result:DisplayObject = super.hitTest(localPoint, forTouch);
			if(!result)
			{
				//we want to register touches in our hitArea as a last resort
				if(forTouch && (!this.visible || !this.touchable))
				{
					return null;
				}
				return this._hitArea.contains(localX, localY) ? this : null;
			}
			return result;
		}

		/**
		 * @private
		 */
		override public function dispose():void
		{
			this._onScroll.removeAll();
			this._onDragStart.removeAll();
			this._onDragEnd.removeAll();
			super.dispose();
		}
		
		/**
		 * @private
		 */
		override protected function draw():void
		{
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const scrollInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SCROLL);
			const clippingInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_CLIPPING);
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			const scrollBarInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SCROLL_BAR_RENDERER);

			if(scrollBarInvalid)
			{
				this.createScrollBars();
			}

			if(scrollBarInvalid || stylesInvalid)
			{
				this.refreshScrollBarStyles();
				this.refreshInteractionModeEvents();
			}

			if(this.horizontalScrollBar is FeathersControl)
			{
				FeathersControl(this.horizontalScrollBar).validate();
			}
			if(this.verticalScrollBar is FeathersControl)
			{
				FeathersControl(this.verticalScrollBar).validate();
			}

			//even if fixed, we need to measure without them first
			if(scrollInvalid || sizeInvalid || stylesInvalid || scrollBarInvalid || dataInvalid)
			{
				this.refreshViewPortBoundsWithoutFixedScrollBars();
			}

			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

			if(scrollInvalid || sizeInvalid || stylesInvalid || scrollBarInvalid || dataInvalid)
			{
				this.refreshViewPortBoundsWithFixedScrollBars();
			}
			this._lastViewPortWidth = viewPort.width;
			this._lastViewPortHeight = viewPort.height;

			if(scrollInvalid || sizeInvalid || stylesInvalid || scrollBarInvalid || dataInvalid)
			{
				this.refreshScrollValues(scrollInvalid);
				this.refreshScrollBarValues();
			}

			if(scrollInvalid || sizeInvalid || stylesInvalid || scrollBarInvalid || dataInvalid)
			{
				this.layout();
			}
			
			if(scrollInvalid || sizeInvalid || stylesInvalid || scrollBarInvalid || dataInvalid || clippingInvalid)
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

			var newWidth:Number = this.explicitWidth;
			var newHeight:Number = this.explicitHeight;
			if(needsWidth)
			{
				newWidth = this._viewPort.width + this._verticalScrollBarWidthOffset;
			}
			if(needsHeight)
			{
				newHeight = this._viewPort.height + this._horizontalScrollBarHeightOffset;
			}
			return this.setSizeInternal(newWidth, newHeight, false);
		}

		/**
		 * @private
		 */
		protected function createScrollBars():void
		{
			if(this.horizontalScrollBar)
			{
				this.horizontalScrollBar.onChange.remove(horizontalScrollBar_onChange);
				DisplayObject(this.horizontalScrollBar).removeFromParent(true);
				this.horizontalScrollBar = null;
			}
			if(this.verticalScrollBar)
			{
				this.verticalScrollBar.onChange.remove(verticalScrollBar_onChange);
				DisplayObject(this.verticalScrollBar).removeFromParent(true);
				this.verticalScrollBar = null;
			}

			if(this._scrollBarDisplayMode != SCROLL_BAR_DISPLAY_MODE_NONE &&
				this._horizontalScrollPolicy != SCROLL_POLICY_OFF && this._horizontalScrollBarFactory != null)
			{
				this.horizontalScrollBar = this._horizontalScrollBarFactory();
				if(this.horizontalScrollBar is FeathersControl)
				{
					FeathersControl(this.horizontalScrollBar).nameList.add(this.horizontalScrollBarName);
				}
				this.horizontalScrollBar.onChange.add(horizontalScrollBar_onChange);
				const displayHorizontalScrollBar:DisplayObject = DisplayObject(this.horizontalScrollBar);
				this.addChild(displayHorizontalScrollBar);
			}
			if(this._scrollBarDisplayMode != SCROLL_BAR_DISPLAY_MODE_NONE &&
				this._verticalScrollPolicy != SCROLL_POLICY_OFF && this._verticalScrollBarFactory != null)
			{
				this.verticalScrollBar = this._verticalScrollBarFactory();
				if(this.verticalScrollBar is FeathersControl)
				{
					FeathersControl(this.verticalScrollBar).nameList.add(this.verticalScrollBarName);
				}
				this.verticalScrollBar.onChange.add(verticalScrollBar_onChange);
				const displayVerticalScrollBar:DisplayObject = DisplayObject(this.verticalScrollBar);
				this.addChild(displayVerticalScrollBar);
			}
		}

		/**
		 * @private
		 */
		protected function refreshScrollBarStyles():void
		{
			if(this.horizontalScrollBar)
			{
				var objectScrollBar:Object = this.horizontalScrollBar;
				for(var propertyName:String in this._horizontalScrollBarProperties)
				{
					if(objectScrollBar.hasOwnProperty(propertyName))
					{
						var propertyValue:Object = this._horizontalScrollBarProperties[propertyName];
						this.horizontalScrollBar[propertyName] = propertyValue;
					}
				}
				if(this._horizontalScrollBarHideTween)
				{
					this._horizontalScrollBarHideTween.paused = true;
					this._horizontalScrollBarHideTween = null;
				}
				const displayHorizontalScrollBar:DisplayObject = DisplayObject(this.horizontalScrollBar);
				displayHorizontalScrollBar.alpha = this._scrollBarDisplayMode == SCROLL_BAR_DISPLAY_MODE_FLOAT ? 0 : 1;
				displayHorizontalScrollBar.touchable = this._interactionMode == INTERACTION_MODE_MOUSE;
			}
			if(this.verticalScrollBar)
			{
				objectScrollBar = this.verticalScrollBar;
				for(propertyName in this._verticalScrollBarProperties)
				{
					if(objectScrollBar.hasOwnProperty(propertyName))
					{
						propertyValue = this._verticalScrollBarProperties[propertyName];
						this.verticalScrollBar[propertyName] = propertyValue;
					}
				}
				if(this._verticalScrollBarHideTween)
				{
					this._verticalScrollBarHideTween.paused = true;
					this._verticalScrollBarHideTween = null;
				}
				const displayVerticalScrollBar:DisplayObject = DisplayObject(this.verticalScrollBar);
				displayVerticalScrollBar.alpha = this._scrollBarDisplayMode == SCROLL_BAR_DISPLAY_MODE_FLOAT ? 0 : 1;
				displayVerticalScrollBar.touchable = this._interactionMode == INTERACTION_MODE_MOUSE;
			}
		}

		/**
		 * @private
		 */
		protected function refreshViewPortBoundsWithoutFixedScrollBars():void
		{
			var horizontalScrollBarHeightOffset:Number = 0;
			var verticalScrollBarWidthOffset:Number = 0;
			if(this._scrollBarDisplayMode == SCROLL_BAR_DISPLAY_MODE_FIXED)
			{
				horizontalScrollBarHeightOffset = this.horizontalScrollBar ? DisplayObject(this.horizontalScrollBar).height : 0;
				verticalScrollBarWidthOffset = this.verticalScrollBar ? DisplayObject(this.verticalScrollBar).width : 0;
			}

			//if scroll bars are fixed, we're going to include the offsets even
			//if they may not be needed in the final pass. if not fixed, the
			//view port fills the entire bounds.
			if(isNaN(this.explicitWidth))
			{
				this._viewPort.visibleWidth = NaN;
			}
			else
			{
				this._viewPort.visibleWidth = this.explicitWidth - verticalScrollBarWidthOffset;
			}
			if(isNaN(this.explicitHeight))
			{
				this._viewPort.visibleHeight = NaN;
			}
			else
			{
				this._viewPort.visibleHeight = this.explicitHeight - horizontalScrollBarHeightOffset;
			}
			this._viewPort.minVisibleWidth = Math.max(0, this._minWidth - verticalScrollBarWidthOffset);
			this._viewPort.maxVisibleWidth = this._maxWidth - verticalScrollBarWidthOffset;
			this._viewPort.minVisibleHeight = Math.max(0, this._minHeight - horizontalScrollBarHeightOffset);
			this._viewPort.maxVisibleHeight = this._maxHeight - horizontalScrollBarHeightOffset;

			this._viewPort.horizontalScrollPosition = this._horizontalScrollPosition;
			this._viewPort.verticalScrollPosition = this._verticalScrollPosition;

			if(this._scrollBarDisplayMode == SCROLL_BAR_DISPLAY_MODE_FIXED)
			{
				this.ignoreViewPortResizing = true;
			}
			FeathersControl(this._viewPort).validate();
			this.ignoreViewPortResizing = false;

			//in fixed mode, if we determine that scrolling is required, we
			//remember the offsets for later. if scrolling is not needed, then
			//we will ignore the offsets from here forward
			this._horizontalScrollBarHeightOffset = 0;
			this._verticalScrollBarWidthOffset = 0;
			if(this._scrollBarDisplayMode == SCROLL_BAR_DISPLAY_MODE_FIXED)
			{
				if(this.horizontalScrollBar)
				{
					if(this._horizontalScrollPolicy == SCROLL_POLICY_ON ||
						((this._viewPort.width > this.explicitWidth || this._viewPort.width > this._maxWidth) &&
							this._horizontalScrollPolicy != SCROLL_POLICY_OFF))
					{
						this._horizontalScrollBarHeightOffset = horizontalScrollBarHeightOffset;
					}
				}
				if(this.verticalScrollBar)
				{
					if(this._verticalScrollPolicy == SCROLL_POLICY_ON ||
						((this._viewPort.height > this.explicitHeight || this._viewPort.height > this._maxHeight) &&
							this._verticalScrollPolicy != SCROLL_POLICY_OFF))
					{
						this._verticalScrollBarWidthOffset = verticalScrollBarWidthOffset;
					}
				}
			}
		}

		/**
		 * @private
		 */
		protected function refreshViewPortBoundsWithFixedScrollBars():void
		{
			const isFixed:Boolean = this._scrollBarDisplayMode == SCROLL_BAR_DISPLAY_MODE_FIXED;
			const displayHorizontalScrollBar:DisplayObject = this.horizontalScrollBar as DisplayObject;
			const displayVerticalScrollBar:DisplayObject = this.verticalScrollBar as DisplayObject;
			if(displayHorizontalScrollBar)
			{
				displayHorizontalScrollBar.visible = !isFixed || this._horizontalScrollBarHeightOffset > 0;
			}
			if(displayVerticalScrollBar)
			{
				displayVerticalScrollBar.visible = !isFixed || this._verticalScrollBarWidthOffset > 0;
			}
			if(!isFixed)
			{
				return;
			}

			//we need to make a second pass on the view port to use the offsets
			//and the final actual bounds
			this._viewPort.visibleWidth = this.actualWidth - this._verticalScrollBarWidthOffset;
			this._viewPort.visibleHeight = this.actualHeight - this._horizontalScrollBarHeightOffset;
			FeathersControl(viewPort).validate();
		}

		/**
		 * @private
		 */
		protected function refreshScrollValues(isScrollInvalid:Boolean):void
		{
			const oldMaxHSP:Number = this._maxHorizontalScrollPosition;
			const oldMaxVSP:Number = this._maxVerticalScrollPosition;
			if(this._viewPort)
			{
				this._maxHorizontalScrollPosition = Math.max(0, this._viewPort.width + this._verticalScrollBarWidthOffset - this.actualWidth);
				this._maxVerticalScrollPosition = Math.max(0, this._viewPort.height + this._horizontalScrollBarHeightOffset - this.actualHeight);
			}
			else
			{
				this._maxHorizontalScrollPosition = 0;
				this._maxVerticalScrollPosition = 0;
			}

			const maximumPositionsChanged:Boolean = this._maxHorizontalScrollPosition != oldMaxHSP || this._maxVerticalScrollPosition != oldMaxVSP;
			if(maximumPositionsChanged)
			{
				if(this._touchPointID < 0 && !this._horizontalAutoScrollTween)
				{
					if(this._snapToPages)
					{
						this._horizontalScrollPosition = Math.max(0, roundToNearest(this._horizontalScrollPosition, this.actualWidth));
					}
					this._horizontalScrollPosition = clamp(this._horizontalScrollPosition, 0, this._maxHorizontalScrollPosition);
				}
				if(this._touchPointID < 0 && !this._verticalAutoScrollTween)
				{
					if(this._snapToPages)
					{
						this._verticalScrollPosition = Math.max(0, roundToNearest(this._verticalScrollPosition, this.actualHeight));
					}
					this._verticalScrollPosition = clamp(this._verticalScrollPosition, 0, this._maxVerticalScrollPosition);
				}
			}

			if(this._snapToPages)
			{
				if(isScrollInvalid && !this._isDraggingHorizontally && !this._horizontalAutoScrollTween)
				{
					this._horizontalPageIndex = Math.max(0, Math.floor(this._horizontalScrollPosition / this.actualWidth));
				}
				if(isScrollInvalid && !this._isDraggingVertically && !this._verticalAutoScrollTween)
				{
					this._verticalPageIndex = Math.max(0, Math.floor(this._verticalScrollPosition / this.actualHeight));
				}
			}
			else
			{
				this._horizontalPageIndex = this._verticalPageIndex = 0;
			}

			if(maximumPositionsChanged || isScrollInvalid)
			{
				this._onScroll.dispatch(this);
			}
		}

		/**
		 * @private
		 */
		protected function refreshScrollBarValues():void
		{
			if(this.horizontalScrollBar)
			{
				this.horizontalScrollBar.minimum = 0;
				this.horizontalScrollBar.maximum = this._maxHorizontalScrollPosition;
				this.horizontalScrollBar.value = this._horizontalScrollPosition;
				this.horizontalScrollBar.page = this._maxHorizontalScrollPosition * this.actualWidth / this._viewPort.width;
				this.horizontalScrollBar.step = this._horizontalScrollStep;
			}

			if(this.verticalScrollBar)
			{
				this.verticalScrollBar.minimum = 0;
				this.verticalScrollBar.maximum = this._maxVerticalScrollPosition;
				this.verticalScrollBar.value = this._verticalScrollPosition;
				this.verticalScrollBar.page = this._maxVerticalScrollPosition * this.actualHeight / this._viewPort.height;
				this.verticalScrollBar.step = this._verticalScrollStep;
			}
		}

		/**
		 * @private
		 */
		protected function refreshInteractionModeEvents():void
		{
			const displayHorizontalScrollBar:DisplayObject = this.horizontalScrollBar as DisplayObject;
			const displayVerticalScrollBar:DisplayObject = this.verticalScrollBar as DisplayObject;
			if(this._interactionMode == INTERACTION_MODE_TOUCH)
			{
				this.addEventListener(TouchEvent.TOUCH, touchHandler);
			}
			else
			{
				this.removeEventListener(TouchEvent.TOUCH, touchHandler);
			}

			if(this._interactionMode == INTERACTION_MODE_MOUSE && this._scrollBarDisplayMode == SCROLL_BAR_DISPLAY_MODE_FLOAT)
			{
				if(displayHorizontalScrollBar)
				{
					displayHorizontalScrollBar.addEventListener(TouchEvent.TOUCH, horizontalScrollBar_touchHandler);
				}
				if(displayVerticalScrollBar)
				{
					displayVerticalScrollBar.addEventListener(TouchEvent.TOUCH, verticalScrollBar_touchHandler);
				}
			}
			else
			{
				if(displayHorizontalScrollBar)
				{
					displayHorizontalScrollBar.removeEventListener(TouchEvent.TOUCH, horizontalScrollBar_touchHandler);
				}
				if(displayVerticalScrollBar)
				{
					displayVerticalScrollBar.removeEventListener(TouchEvent.TOUCH, verticalScrollBar_touchHandler);
				}
			}
		}

		/**
		 * @private
		 */
		protected function layout():void
		{
			if(this.horizontalScrollBar is FeathersControl)
			{
				FeathersControl(this.horizontalScrollBar).validate();
			}
			if(this.verticalScrollBar is FeathersControl)
			{
				FeathersControl(this.verticalScrollBar).validate();
			}

			const displayHorizontalScrollBar:DisplayObject = this.horizontalScrollBar as DisplayObject;
			if(displayHorizontalScrollBar)
			{
				displayHorizontalScrollBar.x = 0;
				displayHorizontalScrollBar.y = this.actualHeight - displayHorizontalScrollBar.height;
				displayHorizontalScrollBar.width = this.actualWidth;
				if(this._verticalScrollBarWidthOffset > 0)
				{
					displayHorizontalScrollBar.width -= this._verticalScrollBarWidthOffset;
				}
			}

			const displayVerticalScrollBar:DisplayObject = this.verticalScrollBar as DisplayObject;
			if(displayVerticalScrollBar)
			{
				displayVerticalScrollBar.x = this.actualWidth - displayVerticalScrollBar.width;
				displayVerticalScrollBar.y = 0;
				displayVerticalScrollBar.height = this.actualHeight;
				if(this._horizontalScrollBarHeightOffset >= 0)
				{
					displayVerticalScrollBar.height -= this._horizontalScrollBarHeightOffset;
				}
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
				if(!this.scrollRect)
				{
					this.scrollRect = new Rectangle();
				}
				
				const scrollRect:Rectangle = this.scrollRect;
				scrollRect.width = this.actualWidth;
				scrollRect.height = this.actualHeight;
				this.scrollRect = scrollRect;
			}

			this._viewPortWrapper.x = -this._horizontalScrollPosition + offsetX;
			this._viewPortWrapper.y = -this._verticalScrollPosition + offsetY;
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
					position *= this._elasticity;
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
					position -= (position - this._maxHorizontalScrollPosition) * (1 - this._elasticity);
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
					position *= this._elasticity;
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
					position -= (position - this._maxVerticalScrollPosition) * (1 - this._elasticity);
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
			this.throwTo(targetHorizontalScrollPosition, NaN, this._elasticSnapDuration);
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
			this.throwTo(NaN, targetVerticalScrollPosition, this._elasticSnapDuration);
		}
		
		/**
		 * @private
		 */
		protected function throwHorizontally(pixelsPerMS:Number):void
		{
			if(this._snapToPages)
			{
				const inchesPerSecond:Number = 1000 * pixelsPerMS / DeviceCapabilities.dpi;
				if(inchesPerSecond > MINIMUM_PAGE_VELOCITY)
				{
					var snappedPageHorizontalScrollPosition:Number = roundDownToNearest(this._horizontalScrollPosition, this.actualWidth);
				}
				else if(inchesPerSecond < -MINIMUM_PAGE_VELOCITY)
				{
					snappedPageHorizontalScrollPosition = roundUpToNearest(this._horizontalScrollPosition, this.actualWidth);
				}
				else
				{
					snappedPageHorizontalScrollPosition = roundToNearest(this._horizontalScrollPosition, this.actualWidth);
				}
				snappedPageHorizontalScrollPosition = Math.max(0, Math.min(this._maxHorizontalScrollPosition, snappedPageHorizontalScrollPosition));
				this.throwTo(snappedPageHorizontalScrollPosition, NaN, this._pageThrowDuration);
				this._horizontalPageIndex = Math.round(snappedPageHorizontalScrollPosition / this.actualWidth);
				return;
			}

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
			if(this._snapToPages)
			{
				const inchesPerSecond:Number = 1000 * pixelsPerMS / DeviceCapabilities.dpi;
				if(inchesPerSecond > MINIMUM_PAGE_VELOCITY)
				{
					var snappedPageVerticalScrollPosition:Number = roundDownToNearest(this._verticalScrollPosition, this.actualHeight);
				}
				else if(inchesPerSecond < -MINIMUM_PAGE_VELOCITY)
				{
					snappedPageVerticalScrollPosition = roundUpToNearest(this._verticalScrollPosition, this.actualHeight);
				}
				else
				{
					snappedPageVerticalScrollPosition = roundToNearest(this._verticalScrollPosition, this.actualHeight);
				}
				snappedPageVerticalScrollPosition = Math.max(0, Math.min(this._maxVerticalScrollPosition, snappedPageVerticalScrollPosition));
				this.throwTo(NaN, snappedPageVerticalScrollPosition, this._pageThrowDuration);
				this._verticalPageIndex = Math.round(snappedPageVerticalScrollPosition / this.actualHeight);
				return;
			}

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
		protected function hideHorizontalScrollBar(delay:Number = 0):void
		{
			if(!this.horizontalScrollBar || this._scrollBarDisplayMode != SCROLL_BAR_DISPLAY_MODE_FLOAT || this._horizontalScrollBarHideTween)
			{
				return;
			}
			const displayHorizontalScrollBar:DisplayObject = DisplayObject(this.horizontalScrollBar);
			if(displayHorizontalScrollBar.alpha == 0)
			{
				return;
			}
			this._horizontalScrollBarHideTween = new GTween(this.horizontalScrollBar, this._hideScrollBarAnimationDuration,
			{
				alpha: 0
			},
			{
				delay: delay,
				ease: Sine.easeOut,
				onComplete: horizontalScrollBarHideTween_onComplete
			});
		}

		/**
		 * @private
		 */
		protected function hideVerticalScrollBar(delay:Number = 0):void
		{
			if(!this.verticalScrollBar || this._scrollBarDisplayMode != SCROLL_BAR_DISPLAY_MODE_FLOAT || this._verticalScrollBarHideTween)
			{
				return;
			}
			const displayVerticalScrollBar:DisplayObject = DisplayObject(this.verticalScrollBar);
			if(displayVerticalScrollBar.alpha == 0)
			{
				return;
			}
			this._verticalScrollBarHideTween = new GTween(this.verticalScrollBar, this._hideScrollBarAnimationDuration,
			{
				alpha: 0
			},
			{
				delay: delay,
				ease: Sine.easeOut,
				onComplete: verticalScrollBarHideTween_onComplete
			});
		}

		/**
		 * @private
		 */
		protected function viewPort_onResize(viewPort:FeathersControl, oldWidth:Number, oldHeight:Number):void
		{
			if(this.ignoreViewPortResizing ||
				(this._viewPort.width == this._lastViewPortWidth && this._viewPort.height == this._lastViewPortHeight))
			{
				return;
			}
			this._lastViewPortWidth = this._viewPort.width;
			this._lastViewPortHeight = this._viewPort.height;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected function horizontalScrollBarProperties_onChange(proxy:PropertyProxy, name:Object):void
		{
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected function verticalScrollBarProperties_onChange(proxy:PropertyProxy, name:Object):void
		{
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected function verticalScrollBar_onChange(scrollBar:IScrollBar):void
		{
			this.verticalScrollPosition = scrollBar.value;
		}

		/**
		 * @private
		 */
		protected function horizontalScrollBar_onChange(scrollBar:IScrollBar):void
		{
			this.horizontalScrollPosition = scrollBar.value;
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
		protected function horizontalScrollBarHideTween_onComplete(tween:GTween):void
		{
			this._horizontalScrollBarHideTween = null;
		}

		/**
		 * @private
		 */
		protected function verticalScrollBarHideTween_onComplete(tween:GTween):void
		{
			this._verticalScrollBarHideTween = null;
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

			//any began touch is okay here. we don't need to check all touches.
			const touch:Touch = event.getTouch(this, TouchPhase.BEGAN);
			if(!touch)
			{
				return;
			}
			touch.getLocation(this, helperPoint);
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
			this._previousTouchX = this._startTouchX = this._currentTouchX = helperPoint.x;
			this._previousTouchY = this._startTouchY = this._currentTouchY = helperPoint.y;
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

		/**
		 * @private
		 */
		protected function enterFrameHandler(event:Event):void
		{
			if(this._isScrollingStopped)
			{
				return;
			}
			const now:int = getTimer();
			const timeOffset:int = now - this._previousTouchTime;
			if(timeOffset > 0)
			{
				//we're keeping previous velocity updates to improve accuracy
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
			const horizontalInchesMoved:Number = Math.abs(this._currentTouchX - this._startTouchX) / DeviceCapabilities.dpi;
			const verticalInchesMoved:Number = Math.abs(this._currentTouchY - this._startTouchY) / DeviceCapabilities.dpi;
			if((this._horizontalScrollPolicy == SCROLL_POLICY_ON ||
				(this._horizontalScrollPolicy == SCROLL_POLICY_AUTO && this._maxHorizontalScrollPosition > 0)) &&
				!this._isDraggingHorizontally && horizontalInchesMoved >= MINIMUM_DRAG_DISTANCE)
			{
				if(this.horizontalScrollBar)
				{
					if(this._horizontalScrollBarHideTween)
					{
						this._horizontalScrollBarHideTween.paused = true;
						this._horizontalScrollBarHideTween = null;
					}
					if(this._scrollBarDisplayMode == SCROLL_BAR_DISPLAY_MODE_FLOAT)
					{
						DisplayObject(this.horizontalScrollBar).alpha = 1;
					}
				}
				//if we haven't already started dragging in the other direction,
				//we need to dispatch the signal that says we're starting.
				if(!this._isDraggingVertically)
				{
					this._onDragStart.dispatch(this);
				}
				this._startTouchX = this._currentTouchX;
				this._startHorizontalScrollPosition = this._horizontalScrollPosition;
				this._isDraggingHorizontally = true;
			}
			if((this._verticalScrollPolicy == SCROLL_POLICY_ON ||
				(this._verticalScrollPolicy == SCROLL_POLICY_AUTO && this._maxVerticalScrollPosition > 0)) &&
				!this._isDraggingVertically && verticalInchesMoved >= MINIMUM_DRAG_DISTANCE)
			{
				if(!this._isDraggingHorizontally)
				{
					if(this.verticalScrollBar)
					{
						if(this._verticalScrollBarHideTween)
						{
							this._verticalScrollBarHideTween.paused = true;
							this._verticalScrollBarHideTween = null;
						}
						if(this._scrollBarDisplayMode == SCROLL_BAR_DISPLAY_MODE_FLOAT)
						{
							DisplayObject(this.verticalScrollBar).alpha = 1;
						}
					}
					this._onDragStart.dispatch(this);
				}
				this._startTouchY = this._currentTouchY;
				this._startVerticalScrollPosition = this._verticalScrollPosition;
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

		/**
		 * @private
		 */
		protected function stage_touchHandler(event:TouchEvent):void
		{
			const touches:Vector.<Touch> = event.getTouches(this.stage);
			if(touches.length == 0 || this._touchPointID < 0)
			{
				return;
			}
			var touch:Touch;
			for each(var currentTouch:Touch in touches)
			{
				if(currentTouch.id == this._touchPointID)
				{
					touch = currentTouch;
					break;
				}
			}
			if(!touch)
			{
				return;
			}

			if(touch.phase == TouchPhase.MOVED)
			{
				//we're saving these to use in the enter frame handler because
				//that provides a longer time offset
				touch.getLocation(this, helperPoint);
				this._currentTouchX = helperPoint.x;
				this._currentTouchY = helperPoint.y;
			}
			else if(touch.phase == TouchPhase.ENDED)
			{
				this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
				this.stage.removeEventListener(TouchEvent.TOUCH, stage_touchHandler);
				this._touchPointID = -1;
				this._onDragEnd.dispatch(this);
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
				
				if(!isFinishingHorizontally && this._isDraggingHorizontally)
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
				else
				{
					this.hideHorizontalScrollBar();
				}
				
				if(!isFinishingVertically && this._isDraggingVertically)
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
				else
				{
					this.hideVerticalScrollBar();
				}
			}
		}

		/**
		 * @private
		 */
		protected function nativeStage_mouseWheelHandler(event:MouseEvent):void
		{
			if(this._verticalScrollBarHideTween)
			{
				this._verticalScrollBarHideTween.paused = true;
				this._verticalScrollBarHideTween = null;
			}

			if(this.verticalScrollBar && this._scrollBarDisplayMode == SCROLL_BAR_DISPLAY_MODE_FLOAT)
			{
				DisplayObject(this.verticalScrollBar).alpha = 1;
			}

			helperPoint.x = event.stageX;
			helperPoint.y = event.stageY;
			this.globalToLocal(helperPoint, helperPoint);
			if(this.hitTest(helperPoint, true))
			{
				this.verticalScrollPosition = Math.min(this._maxVerticalScrollPosition, Math.max(0, this._verticalScrollPosition - event.delta * this._verticalScrollStep));
			}

			this.hideVerticalScrollBar(0.25);
		}

		/**
		 * @private
		 */
		protected function nativeStage_orientationChangeHandler(event:flash.events.Event):void
		{
			if(this._touchPointID < 0)
			{
				return;
			}
			this._startTouchX = this._previousTouchX = this._currentTouchX;
			this._startTouchY = this._previousTouchY = this._currentTouchY;
			this._startHorizontalScrollPosition = this._horizontalScrollPosition;
			this._startVerticalScrollPosition = this._verticalScrollPosition;
		}

		/**
		 * @private
		 */
		protected function horizontalScrollBar_touchHandler(event:TouchEvent):void
		{
			const displayHorizontalScrollBar:DisplayObject = DisplayObject(event.currentTarget);
			const touches:Vector.<Touch> = event.getTouches(displayHorizontalScrollBar);
			if(touches.length == 0)
			{
				//end hover
				this.hideHorizontalScrollBar();
				return;
			}
			if(this._horizontalScrollBarTouchPointID >= 0)
			{
				var touch:Touch;
				for each(var currentTouch:Touch in touches)
				{
					if(currentTouch.id == this._horizontalScrollBarTouchPointID)
					{
						touch = currentTouch;
						break;
					}
				}
				if(!touch)
				{
					//end hover
					this.hideHorizontalScrollBar();
					return;
				}
				if(touch.phase == TouchPhase.ENDED)
				{
					this._horizontalScrollBarTouchPointID = -1;
					touch.getLocation(displayHorizontalScrollBar, helperPoint);
					ScrollRectManager.adjustTouchLocation(helperPoint, displayHorizontalScrollBar);
					const isInBounds:Boolean = displayHorizontalScrollBar.hitTest(helperPoint, true) != null;
					if(!isInBounds)
					{
						this.hideHorizontalScrollBar();
					}
					return;
				}
			}
			else
			{
				for each(touch in touches)
				{
					if(touch.phase == TouchPhase.HOVER)
					{
						if(this._horizontalScrollBarHideTween)
						{
							this._horizontalScrollBarHideTween.paused = true;
							this._horizontalScrollBarHideTween = null;
						}
						displayHorizontalScrollBar.alpha = 1;
						return;
					}
					else if(touch.phase == TouchPhase.BEGAN)
					{
						this._horizontalScrollBarTouchPointID = touch.id;
						return;
					}
				}
			}
		}

		/**
		 * @private
		 */
		protected function verticalScrollBar_touchHandler(event:TouchEvent):void
		{
			const displayVerticalScrollBar:DisplayObject = DisplayObject(event.currentTarget);
			const touches:Vector.<Touch> = event.getTouches(displayVerticalScrollBar);
			if(touches.length == 0)
			{
				//end hover
				this.hideVerticalScrollBar();
				return;
			}
			if(this._verticalScrollBarTouchPointID >= 0)
			{
				var touch:Touch;
				for each(var currentTouch:Touch in touches)
				{
					if(currentTouch.id == this._verticalScrollBarTouchPointID)
					{
						touch = currentTouch;
						break;
					}
				}
				if(!touch)
				{
					//end hover
					this.hideVerticalScrollBar();
					return;
				}
				if(touch.phase == TouchPhase.ENDED)
				{
					this._verticalScrollBarTouchPointID = -1;
					touch.getLocation(displayVerticalScrollBar, helperPoint);
					ScrollRectManager.adjustTouchLocation(helperPoint, displayVerticalScrollBar);
					const isInBounds:Boolean = displayVerticalScrollBar.hitTest(helperPoint, true) != null;
					if(!isInBounds)
					{
						this.hideVerticalScrollBar();
					}
					return;
				}
			}
			else
			{
				for each(touch in touches)
				{
					if(touch.phase == TouchPhase.HOVER)
					{
						if(this._verticalScrollBarHideTween)
						{
							this._verticalScrollBarHideTween.paused = true;
							this._verticalScrollBarHideTween = null;
						}
						displayVerticalScrollBar.alpha = 1;
						return;
					}
					else if(touch.phase == TouchPhase.BEGAN)
					{
						this._verticalScrollBarTouchPointID = touch.id;
						return;
					}
				}
			}
		}

		/**
		 * @private
		 */
		protected function addedToStageHandler(event:Event):void
		{
			Starling.current.nativeStage.addEventListener(MouseEvent.MOUSE_WHEEL, nativeStage_mouseWheelHandler, false, 0, true);
			Starling.current.nativeStage.addEventListener("orientationChange", nativeStage_orientationChangeHandler, false, 0, true);
		}
		
		/**
		 * @private
		 */
		protected function removedFromStageHandler(event:Event):void
		{
			Starling.current.nativeStage.removeEventListener(MouseEvent.MOUSE_WHEEL, nativeStage_mouseWheelHandler);
			Starling.current.nativeStage.removeEventListener("orientationChange", nativeStage_orientationChangeHandler);
			this._touchPointID = -1;
			this._horizontalScrollBarTouchPointID = -1;
			this._verticalScrollBarTouchPointID = -1;
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
			const oldHorizontalScrollPosition:Number = this._horizontalScrollPosition;
			const oldVerticalScrollPosition:Number = this._verticalScrollPosition;
			this._horizontalScrollPosition = clamp(this._horizontalScrollPosition, 0, this._maxHorizontalScrollPosition);
			this._verticalScrollPosition = clamp(this._verticalScrollPosition, 0, this._maxVerticalScrollPosition);
			if(oldHorizontalScrollPosition != this._horizontalScrollPosition ||
				oldVerticalScrollPosition != this._verticalScrollPosition)
			{
				this._onScroll.dispatch(this);
			}
		}
	}
}