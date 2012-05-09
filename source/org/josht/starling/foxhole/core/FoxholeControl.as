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
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	import org.josht.starling.display.Sprite;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import starling.core.RenderSupport;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.utils.transformCoords;

	/**
	 * Base class for all Foxhole UI controls. Implements invalidation and sets
	 * up some basic template functions like <code>initialize()</code> and
	 * <code>draw()</code>.
	 */
	public class FoxholeControl extends Sprite
	{
		private static const helperMatrix:Matrix = new Matrix();
		private static const helperPoint:Point = new Point();
		
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
		 * Constructor.
		 */
		public function FoxholeControl()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}

		/**
		 * @private
		 */
		protected var _nameList:TokenList = new TokenList();

		/**
		 * Contains a list of all names assigned to this control. Names may be
		 * added, removed, or toggled.
		 */
		public function get nameList():TokenList
		{
			return this._nameList;
		}

		/**
		 * Non-unique identifiers for a Foxhole control that are expected to be
		 * used in a similar way to classes in HTML/CSS. Typically, these are
		 * most often used to identify sub-controls.
		 */
		override public function get name():String
		{
			return this._nameList.value;
		}

		/**
		 * @private
		 */
		override public function set name(value:String):void
		{
			this._nameList.value = value;
		}
		
		/**
		 * @private
		 */
		private var _isQuickHitAreaEnabled:Boolean = false;

		/**
		 * Similar to mouseChildren on the classic display list. If true,
		 * children cannot dispatch touch events, but hit tests will be much
		 * faster.
		 */
		public function get isQuickHitAreaEnabled():Boolean
		{
			return this._isQuickHitAreaEnabled;
		}

		/**
		 * @private
		 */
		public function set isQuickHitAreaEnabled(value:Boolean):void
		{
			this._isQuickHitAreaEnabled = value;
		}

		/**
		 * @private
		 */
		protected var _hitArea:Rectangle = new Rectangle();
		
		/**
		 * @private
		 * Flag indicating if the <code>initialize()</code> function has been called yet.
		 */
		private var _isInitialized:Boolean = false;
		
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
		private var _delayedInvalidationFlags:Dictionary = new Dictionary(true);
		
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
		 * The width value explicitly set by calling the width setter or
		 * setSize().
		 */
		protected var explicitWidth:Number = NaN;

		/**
		 * The final width value that should be used for layout. If the width
		 * has been explicitly set, then that value is used. If not, the actual
		 * width will be calculated automatically. Each component has different
		 * automatic sizing behavior, but it's usually based on the component's
		 * skin or content, including text or sub-components.
		 */
		protected var actualWidth:Number = NaN;
		
		/**
		 * The width of the component, in pixels. This could be a value that was
		 * set explicitly, or the component will automatically resize if no
		 * explicit width value is provided. Each component has a different
		 * automatic sizing behavior, but it's usually based on the component's
		 * skin or content, including text or sub-components.
		 */
		override public function get width():Number
		{
			return this.actualWidth;
		}
		
		/**
		 * @private
		 */
		override public function set width(value:Number):void
		{
			this.explicitWidth = value;
			this.setSizeInternal(value, this.actualHeight, true);
		}

		/**
		 * The height value explicitly set by calling the height setter or
		 * setSize().
		 */
		protected var explicitHeight:Number = NaN;

		/**
		 * The final height value that should be used for layout. If the height
		 * has been explicitly set, then that value is used. If not, the actual
		 * height will be calculated automatically. Each component has different
		 * automatic sizing behavior, but it's usually based on the component's
		 * skin or content, including text or sub-components.
		 */
		protected var actualHeight:Number = NaN;

		/**
		 * The height of the component, in pixels. This could be a value that
		 * was set explicitly, or the component will automatically resize if no
		 * explicit height value is provided. Each component has a different
		 * automatic sizing behavior, but it's usually based on the component's
		 * skin or content, including text or sub-components.
		 */
		override public function get height():Number
		{
			return this.actualHeight;
		}
		
		/**
		 * @private
		 */
		override public function set height(value:Number):void
		{
			this.explicitHeight = value;
			this.setSizeInternal(this.explicitWidth, value, true);
		}

		/**
		 * @private
		 */
		private var _minWidth:Number = 0;

		/**
		 * The minimum recommend width to be used for self-measurement and,
		 * optionally, by the parent who is resizing this component. A width
		 * value that is smaller than <code>minWidth</code> may be set
		 * explicitly, and it will not be affected by this value.
		 */
		public function get minWidth():Number
		{
			return this._minWidth;
		}

		/**
		 * @private
		 */
		public function set minWidth(value:Number):void
		{
			if(this._minWidth == value)
			{
				return;
			}
			this._minWidth = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		/**
		 * @private
		 */
		private var _minHeight:Number = 0;

		/**
		 * The minimum recommend height to be used for self-measurement and,
		 * optionally, by the parent who is resizing this component. A height
		 * value that is smaller than <code>minHeight</code> may be set
		 * explicitly, and it will not be affected by this value.
		 */
		public function get minHeight():Number
		{
			return this._minHeight;
		}

		/**
		 * @private
		 */
		public function set minHeight(value:Number):void
		{
			if(this._minHeight == value)
			{
				return;
			}
			this._minHeight = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
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
		 * @private
		 */
		public override function getBounds(targetSpace:DisplayObject, resultRect:Rectangle=null):Rectangle
		{
			if(this.scrollRect)
			{
				return super.getBounds(targetSpace, resultRect);
			}
			
			if(!resultRect)
			{
				resultRect = new Rectangle();
			}
			
			var minX:Number = Number.MAX_VALUE, maxX:Number = -Number.MAX_VALUE;
			var minY:Number = Number.MAX_VALUE, maxY:Number = -Number.MAX_VALUE;
			
			if (targetSpace == this) // optimization
			{
				minX = this._hitArea.x;
				minY = this._hitArea.y;
				maxX = this._hitArea.x + this._hitArea.width;
				maxY = this._hitArea.y + this._hitArea.height;
			}
			else
			{
				this.getTransformationMatrix(targetSpace, helperMatrix);
				
				transformCoords(helperMatrix, this._hitArea.x, this._hitArea.y, helperPoint);
				minX = minX < helperPoint.x ? minX : helperPoint.x;
				maxX = maxX > helperPoint.x ? maxX : helperPoint.x;
				minY = minY < helperPoint.y ? minY : helperPoint.y;
				maxY = maxY > helperPoint.y ? maxY : helperPoint.y;
				
				transformCoords(helperMatrix, this._hitArea.x, this._hitArea.y + this._hitArea.height, helperPoint);
				minX = minX < helperPoint.x ? minX : helperPoint.x;
				maxX = maxX > helperPoint.x ? maxX : helperPoint.x;
				minY = minY < helperPoint.y ? minY : helperPoint.y;
				maxY = maxY > helperPoint.y ? maxY : helperPoint.y;
				
				transformCoords(helperMatrix, this._hitArea.x + this._hitArea.width, this._hitArea.y, helperPoint);
				minX = minX < helperPoint.x ? minX : helperPoint.x;
				maxX = maxX > helperPoint.x ? maxX : helperPoint.x;
				minY = minY < helperPoint.y ? minY : helperPoint.y;
				maxY = maxY > helperPoint.y ? maxY : helperPoint.y;
				
				transformCoords(helperMatrix, this._hitArea.x + this._hitArea.width, this._hitArea.y + this._hitArea.height, helperPoint);
				minX = minX < helperPoint.x ? minX : helperPoint.x;
				maxX = maxX > helperPoint.x ? maxX : helperPoint.x;
				minY = minY < helperPoint.y ? minY : helperPoint.y;
				maxY = maxY > helperPoint.y ? maxY : helperPoint.y;
			}
			
			resultRect.x = minX;
			resultRect.y = minY;
			resultRect.width  = maxX - minX;
			resultRect.height = maxY - minY;
			
			return resultRect;
		}
		
		/**
		 * @private
		 */
		override public function hitTest(localPoint:Point, forTouch:Boolean=false):DisplayObject
		{
			if(this._isQuickHitAreaEnabled)
			{
				if(forTouch && (!this.visible || !this.touchable))
				{
					return null;
				}
				return this._hitArea.containsPoint(localPoint) ? this : null;
			}
			return super.hitTest(localPoint, forTouch);
		}

		/**
		 * @private
		 */
		override public function render(support:RenderSupport, alpha:Number):void
		{
			var validationCount:int = 0;
			while(this.isInvalid())
			{
				this.validate();
				validationCount++;
				if(validationCount > 10)
				{
					//we give up. do it next time.
					trace("Warning: Stopping out of control validation.");
					break;
				}
			}
			super.render(support, alpha);
		}
		
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
				//we'll invalidate everything once we're added to the stage, so
				//there's no point in micro-managing it before that.
				return;
			}
			for each(var flag:String in rest)
			{
				if(this._isValidating)
				{
					this._delayedInvalidationFlags[flag] = true;
				}
				else
				{
					if(flag == INVALIDATION_FLAG_ALL)
					{
						continue;
					}
					this._invalidationFlags[flag] = true;
				}
			}
			if(rest.length == 0 || rest.indexOf(INVALIDATION_FLAG_ALL) >= 0)
			{
				if(this._isValidating)
				{
					this._delayedInvalidationFlags[INVALIDATION_FLAG_ALL] = true;
				}
				else
				{
					this._isAllInvalid = true;
				}
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
			for(flag in this._delayedInvalidationFlags)
			{
				if(flag == INVALIDATION_FLAG_ALL)
				{
					this._isAllInvalid = true;
				}
				else
				{
					this._invalidationFlags[flag] = true;
				}
				delete this._delayedInvalidationFlags[flag];
			}
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
			this.explicitWidth = width;
			this.explicitHeight = height;
			this.setSizeInternal(width, height, true);
		}
		
		/**
		 * Sets the width and height of the control, with the option of
		 * invalidating or not. Intended to be used for automatic resizing.
		 */
		protected function setSizeInternal(width:Number, height:Number, canInvalidate:Boolean):void
		{
			var resized:Boolean = false;
			if(!isNaN(this.explicitWidth))
			{
				width = this.explicitWidth;
			}
			else
			{
				width = Math.max(this._minWidth, width);
			}
			if(!isNaN(this.explicitHeight))
			{
				height = this.explicitHeight;
			}
			else
			{
				height = Math.max(this._minHeight, height);
			}
			if(this.actualWidth != width)
			{
				this.actualWidth = width;
				this._hitArea.width = width;
				resized = true;
			}
			if(this.actualHeight != height)
			{
				this.actualHeight = height;
				this._hitArea.height = height;
				resized = true;
			}
			if(resized)
			{
				if(canInvalidate)
				{
					this.invalidate(INVALIDATION_FLAG_SIZE);
				}
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
		private function addedToStageHandler(event:Event):void
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