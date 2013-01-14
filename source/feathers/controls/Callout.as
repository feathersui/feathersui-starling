/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.core.FeathersControl;
	import feathers.core.PopUpManager;

	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * Dispatched when the callout is closed.
	 *
	 * @eventType starling.events.Event.CLOSE
	 */
	[Event(name="close",type="starling.events.Event")]

	/**
	 * A pop-up container that points at (or calls out) a specific region of
	 * the application (typically a specific control that triggered it).
	 *
	 * @see http://wiki.starling-framework.org/feathers/callout
	 */
	public class Callout extends FeathersControl
	{
		/**
		 * The callout may be positioned on any side of the origin region.
		 */
		public static const DIRECTION_ANY:String = "any";

		/**
		 * The callout must be positioned above the origin region.
		 */
		public static const DIRECTION_UP:String = "up";

		/**
		 * The callout must be positioned below the origin region.
		 */
		public static const DIRECTION_DOWN:String = "down";

		/**
		 * The callout must be positioned to the left side of the origin region.
		 */
		public static const DIRECTION_LEFT:String = "left";

		/**
		 * The callout must be positioned to the right side of the origin region.
		 */
		public static const DIRECTION_RIGHT:String = "right";

		/**
		 * The arrow will appear on the top side of the callout.
		 */
		public static const ARROW_POSITION_TOP:String = "top";

		/**
		 * The arrow will appear on the right side of the callout.
		 */
		public static const ARROW_POSITION_RIGHT:String = "right";

		/**
		 * The arrow will appear on the bottom side of the callout.
		 */
		public static const ARROW_POSITION_BOTTOM:String = "bottom";

		/**
		 * The arrow will appear on the left side of the callout.
		 */
		public static const ARROW_POSITION_LEFT:String = "left";

		/**
		 * @private
		 */
		private static var helperRect:Rectangle = new Rectangle();

		/**
		 * @private
		 */
		private static const HELPER_TOUCHES_VECTOR:Vector.<Touch> = new <Touch>[];

		/**
		 * @private
		 */
		protected static const DIRECTION_TO_FUNCTION:Object = {};
		DIRECTION_TO_FUNCTION[DIRECTION_ANY] = positionCalloutAny;
		DIRECTION_TO_FUNCTION[DIRECTION_UP] = positionCalloutAbove;
		DIRECTION_TO_FUNCTION[DIRECTION_DOWN] = positionCalloutBelow;
		DIRECTION_TO_FUNCTION[DIRECTION_LEFT] = positionCalloutLeftSide;
		DIRECTION_TO_FUNCTION[DIRECTION_RIGHT] = positionCalloutRightSide;

		/**
		 * @private
		 */
		protected static const callouts:Vector.<Callout> = new <Callout>[];

		/**
		 * The padding between a callout and the top edge of the stage when the
		 * callout is positioned automatically. May be ignored if the callout
		 * is too big for the stage.
		 */
		public static var stagePaddingTop:Number = 0;

		/**
		 * The padding between a callout and the right edge of the stage when the
		 * callout is positioned automatically. May be ignored if the callout
		 * is too big for the stage.
		 */
		public static var stagePaddingRight:Number = 0;

		/**
		 * The padding between a callout and the bottom edge of the stage when the
		 * callout is positioned automatically. May be ignored if the callout
		 * is too big for the stage.
		 */
		public static var stagePaddingBottom:Number = 0;

		/**
		 * The margin between a callout and the top edge of the stage when the
		 * callout is positioned automatically. May be ignored if the callout
		 * is too big for the stage.
		 */
		public static var stagePaddingLeft:Number = 0;

		/**
		 * Returns a new <code>Callout</code> instance when <code>Callout.show()</code>
		 * is called with isModal set to true. If one wishes to skin the callout
		 * manually, a custom factory may be provided.
		 *
		 * <p>This function is expected to have the following signature:</p>
		 *
		 * <pre>function():Callout</pre>
		 */
		public static var calloutFactory:Function = defaultCalloutFactory;

		/**
		 * Returns an overlay to display with a callout that is modal.
		 *
		 * <p>This function is expected to have the following signature:</p>
		 * <pre>function():DisplayObject</pre>
		 *
		 * @see feathers.core.PopUpManager#overlayFactory
		 */
		public static var calloutOverlayFactory:Function = PopUpManager.defaultOverlayFactory;

		/**
		 * Creates a callout, and then positions and sizes it automatically
		 * based on an origin rectangle and the specified direction relative to
		 * the original. The provided width and height values are optional, and
		 * these values may be ignored if the callout cannot be drawn at the
		 * specified dimensions.
		 */
		public static function show(content:DisplayObject, origin:DisplayObject, direction:String = DIRECTION_ANY,
			isModal:Boolean = true, customCalloutFactory:Function = null):Callout
		{
			if(!origin.stage)
			{
				throw new ArgumentError("Callout origin must be added to the stage.");
			}
			var factory:Function = customCalloutFactory;
			if(factory == null)
			{
				factory = calloutFactory != null ? calloutFactory : defaultCalloutFactory;
			}
			const callout:Callout = Callout(factory());
			callout.content = content;
			callout._isPopUp = true;
			const overlayFactory:Function = calloutOverlayFactory != null ? calloutOverlayFactory : PopUpManager.defaultOverlayFactory;
			PopUpManager.addPopUp(callout, isModal, false, overlayFactory);

			var globalBounds:Rectangle = origin.getBounds(Starling.current.stage);
			positionCalloutByDirection(callout, globalBounds, direction);
			callouts.push(callout);

			function enterFrameHandler(event:EnterFrameEvent):void
			{
				origin.getBounds(Starling.current.stage, helperRect);
				if(globalBounds.equals(helperRect))
				{
					return;
				}
				const temp:Rectangle = globalBounds;
				globalBounds = helperRect;
				helperRect = temp;
				positionCalloutByDirection(callout, globalBounds, direction);
			}
			function origin_removedFromStageHandler(event:Event):void
			{
				callout.close(true);
			}
			function callout_closeHandler(event:Event):void
			{
				origin.removeEventListener(Event.REMOVED_FROM_STAGE, origin_removedFromStageHandler);
				Starling.current.stage.removeEventListener(EnterFrameEvent.ENTER_FRAME, enterFrameHandler);
				callout.removeEventListener(Event.CLOSE, callout_closeHandler);
				const index:int = callouts.indexOf(callout);
				if(index >= 0)
				{
					callouts.splice(index, 1);
				}
			}
			callout.addEventListener(EnterFrameEvent.ENTER_FRAME, enterFrameHandler);
			callout.addEventListener(Event.CLOSE, callout_closeHandler);
			origin.addEventListener(Event.REMOVED_FROM_STAGE, origin_removedFromStageHandler);

			return callout;
		}

		/**
		 * The default factory that creates callouts when <code>Callout.show()</code>
		 * is called. To use a different factory, you need to set
		 * <code>Callout.calloutFactory</code> to a <code>Function</code>
		 * instance.
		 */
		public static function defaultCalloutFactory():Callout
		{
			const callout:Callout = new Callout();
			callout.closeOnTouchBeganOutside = true;
			callout.closeOnTouchEndedOutside = true;
			callout.closeOnKeys = new <uint>[Keyboard.BACK, Keyboard.ESCAPE];
			return callout;
		}

		/**
		 * @private
		 */
		protected static function positionCalloutByDirection(callout:Callout, globalOrigin:Rectangle, direction:String):void
		{
			if(DIRECTION_TO_FUNCTION.hasOwnProperty(direction))
			{
				const calloutPositionFunction:Function = DIRECTION_TO_FUNCTION[direction];
				calloutPositionFunction(callout, globalOrigin);
			}
			else
			{
				positionCalloutAny(callout, globalOrigin);
			}
		}

		/**
		 * @private
		 */
		protected static function positionCalloutAny(callout:Callout, globalOrigin:Rectangle):void
		{
			callout.arrowPosition = ARROW_POSITION_TOP;
			callout.validate();
			const downSpace:Number = (Starling.current.stage.stageHeight - callout.height) - (globalOrigin.y + globalOrigin.height);
			if(downSpace >= stagePaddingBottom)
			{
				positionCalloutBelow(callout, globalOrigin);
				return;
			}

			callout.arrowPosition = ARROW_POSITION_BOTTOM;
			callout.validate();
			const upSpace:Number = globalOrigin.y - callout.height;
			if(upSpace >= stagePaddingTop)
			{
				positionCalloutAbove(callout, globalOrigin);
				return;
			}

			callout.arrowPosition = ARROW_POSITION_LEFT;
			callout.validate();
			const rightSpace:Number = (Starling.current.stage.stageWidth - callout.width) - (globalOrigin.x + globalOrigin.width);
			if(rightSpace >= stagePaddingRight)
			{
				positionCalloutRightSide(callout, globalOrigin);
				return;
			}

			callout.arrowPosition = ARROW_POSITION_RIGHT;
			callout.validate();
			const leftSpace:Number = globalOrigin.x - callout.width;
			if(leftSpace >= stagePaddingLeft)
			{
				positionCalloutLeftSide(callout, globalOrigin);
				return;
			}

			//worst case: pick the side that has the most available space
			if(downSpace >= upSpace && downSpace >= rightSpace && downSpace >= leftSpace)
			{
				positionCalloutBelow(callout, globalOrigin);
			}
			else if(upSpace >= rightSpace && upSpace >= leftSpace)
			{
				positionCalloutAbove(callout, globalOrigin);
			}
			else if(rightSpace >= leftSpace)
			{
				positionCalloutRightSide(callout, globalOrigin);
			}
			else
			{
				positionCalloutLeftSide(callout, globalOrigin);
			}

		}

		/**
		 * @private
		 */
		protected static function positionCalloutBelow(callout:Callout, globalOrigin:Rectangle):void
		{
			callout.arrowPosition = ARROW_POSITION_TOP;
			callout.validate();
			const idealXPosition:Number = globalOrigin.x + (globalOrigin.width - callout.width) / 2;
			const xPosition:Number = Math.max(stagePaddingLeft, Math.min(Starling.current.stage.stageWidth - callout.width - stagePaddingRight, idealXPosition));
			callout.x = xPosition;
			callout.y = globalOrigin.y + globalOrigin.height;
			callout.arrowOffset = idealXPosition - xPosition;
		}

		/**
		 * @private
		 */
		protected static function positionCalloutAbove(callout:Callout, globalOrigin:Rectangle):void
		{
			callout.arrowPosition = ARROW_POSITION_BOTTOM;
			callout.validate();
			const idealXPosition:Number = globalOrigin.x + (globalOrigin.width - callout.width) / 2;
			const xPosition:Number = Math.max(stagePaddingLeft, Math.min(Starling.current.stage.stageWidth - callout.width - stagePaddingRight, idealXPosition));
			callout.x = xPosition;
			callout.y = globalOrigin.y - callout.height;
			callout.arrowOffset = idealXPosition - xPosition;
		}

		/**
		 * @private
		 */
		protected static function positionCalloutRightSide(callout:Callout, globalOrigin:Rectangle):void
		{
			callout.arrowPosition = ARROW_POSITION_LEFT;
			callout.validate();
			callout.x = globalOrigin.x + globalOrigin.width;
			const idealYPosition:Number = globalOrigin.y + (globalOrigin.height - callout.height) / 2;
			const yPosition:Number = Math.max(stagePaddingTop, Math.min(Starling.current.stage.stageHeight - callout.height - stagePaddingBottom, idealYPosition));
			callout.y = yPosition;
			callout.arrowOffset = idealYPosition - yPosition;
		}

		/**
		 * @private
		 */
		protected static function positionCalloutLeftSide(callout:Callout, globalOrigin:Rectangle):void
		{
			callout.arrowPosition = ARROW_POSITION_RIGHT;
			callout.validate();
			callout.x = globalOrigin.x - callout.width;
			const idealYPosition:Number = globalOrigin.y + (globalOrigin.height - callout.height) / 2;
			const yPosition:Number = Math.max(stagePaddingLeft, Math.min(Starling.current.stage.stageHeight - callout.height - stagePaddingBottom, idealYPosition));
			callout.y = yPosition;
			callout.arrowOffset = idealYPosition - yPosition;
		}

		/**
		 * Constructor.
		 */
		public function Callout()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}

		/**
		 * Determines if the callout is automatically closed if a touch in the
		 * <code>TouchPhase.BEGAN</code> phase happens outside of the callout's
		 * bounds.
		 */
		public var closeOnTouchBeganOutside:Boolean = false;

		/**
		 * Determines if the callout is automatically closed if a touch in the
		 * <code>TouchPhase.ENDED</code> phase happens outside of the callout's
		 * bounds.
		 */
		public var closeOnTouchEndedOutside:Boolean = false;

		/**
		 * The callout will be closed if any of these keys are pressed.
		 */
		public var closeOnKeys:Vector.<uint>;

		/**
		 * @private
		 */
		protected var _isPopUp:Boolean = false;

		/**
		 * @private
		 */
		protected var _isReadyToClose:Boolean = false;

		/**
		 * @private
		 */
		protected var _originalContentWidth:Number = NaN;

		/**
		 * @private
		 */
		protected var _originalContentHeight:Number = NaN;

		/**
		 * @private
		 */
		protected var _content:DisplayObject;

		/**
		 * The display object that will be presented by the callout. This object
		 * may be resized to fit the callout's bounds. If the content needs to
		 * be scrolled if placed into a smaller region than its ideal size, it
		 * must provide its own scrolling capabilities because the callout does
		 * not offer scrolling.
		 */
		public function get content():DisplayObject
		{
			return this._content;
		}

		/**
		 * @private
		 */
		public function set content(value:DisplayObject):void
		{
			if(this._content == value)
			{
				return;
			}
			if(this._content)
			{
				this._content.removeFromParent(false);
			}
			this._content = value;
			if(this._content)
			{
				this.addChild(this._content);
			}
			this._originalContentWidth = NaN;
			this._originalContentHeight = NaN;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _paddingTop:Number = 0;

		/**
		 * The minimum space, in pixels, between the callout's top edge and the
		 * callout's content.
		 */
		public function get paddingTop():Number
		{
			return this._paddingTop;
		}

		/**
		 * @private
		 */
		public function set paddingTop(value:Number):void
		{
			if(this._paddingTop == value)
			{
				return;
			}
			this._paddingTop = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _paddingRight:Number = 0;

		/**
		 * The minimum space, in pixels, between the callout's right edge and
		 * the callout's content.
		 */
		public function get paddingRight():Number
		{
			return this._paddingRight;
		}

		/**
		 * @private
		 */
		public function set paddingRight(value:Number):void
		{
			if(this._paddingRight == value)
			{
				return;
			}
			this._paddingRight = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _paddingBottom:Number = 0;

		/**
		 * The minimum space, in pixels, between the callout's bottom edge and
		 * the callout's content.
		 */
		public function get paddingBottom():Number
		{
			return this._paddingBottom;
		}

		/**
		 * @private
		 */
		public function set paddingBottom(value:Number):void
		{
			if(this._paddingBottom == value)
			{
				return;
			}
			this._paddingBottom = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _paddingLeft:Number = 0;

		/**
		 * The minimum space, in pixels, between the callout's left edge and the
		 * callout's content.
		 */
		public function get paddingLeft():Number
		{
			return this._paddingLeft;
		}

		/**
		 * @private
		 */
		public function set paddingLeft(value:Number):void
		{
			if(this._paddingLeft == value)
			{
				return;
			}
			this._paddingLeft = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _arrowPosition:String = ARROW_POSITION_TOP;

		[Inspectable(type="String",enumeration="top,right,bottom,left")]
		/**
		 * The position of the callout's arrow relative to the background. Do
		 * not confuse this with the direction that the callout opens when using
		 * <code>Callout.create()</code>.
		 */
		public function get arrowPosition():String
		{
			return this._arrowPosition;
		}

		/**
		 * @private
		 */
		public function set arrowPosition(value:String):void
		{
			if(this._arrowPosition == value)
			{
				return;
			}
			this._arrowPosition = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _originalBackgroundWidth:Number = NaN;

		/**
		 * @private
		 */
		protected var _originalBackgroundHeight:Number = NaN;

		/**
		 * @private
		 */
		protected var _backgroundSkin:DisplayObject;

		/**
		 * The primary background to display.
		 */
		public function get backgroundSkin():DisplayObject
		{
			return this._backgroundSkin;
		}

		/**
		 * @private
		 */
		public function set backgroundSkin(value:DisplayObject):void
		{
			if(this._backgroundSkin == value)
			{
				return;
			}

			if(this._backgroundSkin)
			{
				this.removeChild(this._backgroundSkin);
			}
			this._backgroundSkin = value;
			if(this._backgroundSkin)
			{
				this._originalBackgroundWidth = this._backgroundSkin.width;
				this._originalBackgroundHeight = this._backgroundSkin.height;
				this.addChildAt(this._backgroundSkin, 0);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var currentArrowSkin:DisplayObject;

		/**
		 * @private
		 */
		protected var _bottomArrowSkin:DisplayObject;

		/**
		 * The arrow skin to display on the bottom edge of the callout. This
		 * arrow is displayed when the callout is displayed above the region it
		 * points at.
		 */
		public function get bottomArrowSkin():DisplayObject
		{
			return this._bottomArrowSkin;
		}

		/**
		 * @private
		 */
		public function set bottomArrowSkin(value:DisplayObject):void
		{
			if(this._bottomArrowSkin == value)
			{
				return;
			}

			if(this._bottomArrowSkin)
			{
				this.removeChild(this._bottomArrowSkin);
			}
			this._bottomArrowSkin = value;
			if(this._bottomArrowSkin)
			{
				this._bottomArrowSkin.visible = false;
				const index:int = this.getChildIndex(this._content);
				if(index < 0)
				{
					this.addChild(this._bottomArrowSkin);
				}
				else
				{
					this.addChildAt(this._bottomArrowSkin, index);
				}
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _topArrowSkin:DisplayObject;

		/**
		 * The arrow skin to display on the top edge of the callout. This arrow
		 * is displayed when the callout is displayed below the region it points
		 * at.
		 */
		public function get topArrowSkin():DisplayObject
		{
			return this._topArrowSkin;
		}

		/**
		 * @private
		 */
		public function set topArrowSkin(value:DisplayObject):void
		{
			if(this._topArrowSkin == value)
			{
				return;
			}

			if(this._topArrowSkin)
			{
				this.removeChild(this._topArrowSkin);
			}
			this._topArrowSkin = value;
			if(this._topArrowSkin)
			{
				this._topArrowSkin.visible = false;
				const index:int = this.getChildIndex(this._content);
				if(index < 0)
				{
					this.addChild(this._topArrowSkin);
				}
				else
				{
					this.addChildAt(this._topArrowSkin, index);
				}
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _leftArrowSkin:DisplayObject;

		/**
		 * The arrow skin to display on the left edge of the callout. This arrow
		 * is displayed when the callout is displayed to the right of the region
		 * it points at.
		 */
		public function get leftArrowSkin():DisplayObject
		{
			return this._leftArrowSkin;
		}

		/**
		 * @private
		 */
		public function set leftArrowSkin(value:DisplayObject):void
		{
			if(this._leftArrowSkin == value)
			{
				return;
			}

			if(this._leftArrowSkin)
			{
				this.removeChild(this._leftArrowSkin);
			}
			this._leftArrowSkin = value;
			if(this._leftArrowSkin)
			{
				this._leftArrowSkin.visible = false;
				const index:int = this.getChildIndex(this._content);
				if(index < 0)
				{
					this.addChild(this._leftArrowSkin);
				}
				else
				{
					this.addChildAt(this._leftArrowSkin, index);
				}
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _rightArrowSkin:DisplayObject;

		/**
		 * The arrow skin to display on the right edge of the callout. This
		 * arrow is displayed when the callout is displayed to the left of the
		 * region it points at.
		 */
		public function get rightArrowSkin():DisplayObject
		{
			return this._rightArrowSkin;
		}

		/**
		 * @private
		 */
		public function set rightArrowSkin(value:DisplayObject):void
		{
			if(this._rightArrowSkin == value)
			{
				return;
			}

			if(this._rightArrowSkin)
			{
				this.removeChild(this._rightArrowSkin);
			}
			this._rightArrowSkin = value;
			if(this._rightArrowSkin)
			{
				this._rightArrowSkin.visible = false;
				const index:int = this.getChildIndex(this._content);
				if(index < 0)
				{
					this.addChild(this._rightArrowSkin);
				}
				else
				{
					this.addChildAt(this._rightArrowSkin, index);
				}
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _topArrowGap:Number = 0;

		/**
		 * The space, in pixels, between the top arrow skin and the background
		 * skin. To have the arrow overlap the background, you may use a
		 * negative gap value.
		 */
		public function get topArrowGap():Number
		{
			return this._topArrowGap;
		}

		/**
		 * @private
		 */
		public function set topArrowGap(value:Number):void
		{
			if(this._topArrowGap == value)
			{
				return;
			}
			this._topArrowGap = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _bottomArrowGap:Number = 0;

		/**
		 * The space, in pixels, between the bottom arrow skin and the
		 * background skin. To have the arrow overlap the background, you may
		 * use a negative gap value.
		 */
		public function get bottomArrowGap():Number
		{
			return this._bottomArrowGap;
		}

		/**
		 * @private
		 */
		public function set bottomArrowGap(value:Number):void
		{
			if(this._bottomArrowGap == value)
			{
				return;
			}
			this._bottomArrowGap = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _rightArrowGap:Number = 0;

		/**
		 * The space, in pixels, between the right arrow skin and the background
		 * skin. To have the arrow overlap the background, you may use a
		 * negative gap value.
		 */
		public function get rightArrowGap():Number
		{
			return this._rightArrowGap;
		}

		/**
		 * @private
		 */
		public function set rightArrowGap(value:Number):void
		{
			if(this._rightArrowGap == value)
			{
				return;
			}
			this._rightArrowGap = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _leftArrowGap:Number = 0;

		/**
		 * The space, in pixels, between the right arrow skin and the background
		 * skin. To have the arrow overlap the background, you may use a
		 * negative gap value.
		 */
		public function get leftArrowGap():Number
		{
			return this._leftArrowGap;
		}

		/**
		 * @private
		 */
		public function set leftArrowGap(value:Number):void
		{
			if(this._leftArrowGap == value)
			{
				return;
			}
			this._leftArrowGap = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _arrowOffset:Number = 0;

		/**
		 * The offset, in pixels, of the arrow skin from the center or middle of
		 * the background skin. On the top and bottom edges, the arrow will
		 * move left for negative values and right for positive values. On the
		 * left and right edges, the arrow will move up for negative values
		 * and down for positive values.
		 */
		public function get arrowOffset():Number
		{
			return this._arrowOffset;
		}

		/**
		 * @private
		 */
		public function set arrowOffset(value:Number):void
		{
			if(this._arrowOffset == value)
			{
				return;
			}
			this._arrowOffset = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * Closes the callout.
		 */
		public function close(dispose:Boolean = false):void
		{
			if(!this.parent)
			{
				return;
			}
			this.removeFromParent();
			this.dispatchEventWith(Event.CLOSE);
			if(dispose)
			{
				this.dispose();
			}
		}

		/**
		 * @private
		 */
		override protected function initialize():void
		{
			this.stage.addEventListener(TouchEvent.TOUCH, stage_touchHandler);
			Starling.current.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler, false, int.MAX_VALUE, true);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			const stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);

			if(stylesInvalid || stateInvalid)
			{
				this.refreshArrowSkin();
			}

			if(stateInvalid)
			{
				if(this._content is FeathersControl)
				{
					FeathersControl(this._content).isEnabled = this._isEnabled;
				}
			}

			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

			if(sizeInvalid || stylesInvalid || dataInvalid || stateInvalid)
			{
				this.layout();
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

			const needsContentWidth:Boolean = isNaN(this._originalContentWidth);
			const needsContentHeight:Boolean = isNaN(this._originalContentHeight);
			if(this._content && (needsContentWidth || needsContentHeight))
			{
				if(this._content is FeathersControl)
				{
					FeathersControl(this._content).validate();
				}
				if(needsContentWidth)
				{
					this._originalContentWidth = this._content.width;
				}
				if(needsContentHeight)
				{
					this._originalContentHeight = this._content.height;
				}
			}

			var newWidth:Number = this.explicitWidth;
			var newHeight:Number = this.explicitHeight;
			if(needsWidth)
			{
				newWidth = this._originalContentWidth + this._paddingLeft + this._paddingRight;
				if(!isNaN(this._originalBackgroundWidth))
				{
					newWidth = Math.max(this._originalBackgroundWidth, newWidth);
				}
				if(this._arrowPosition == ARROW_POSITION_LEFT && this._leftArrowSkin)
				{
					newWidth += this._leftArrowSkin.width + this._leftArrowGap;
				}
				if(this._arrowPosition == ARROW_POSITION_RIGHT && this._rightArrowSkin)
				{
					newWidth += this._rightArrowSkin.width + this._rightArrowGap;
				}
				if(this._arrowPosition == ARROW_POSITION_TOP && this._topArrowSkin)
				{
					newWidth = Math.max(newWidth, this._topArrowSkin.width + this._paddingLeft + this._paddingRight);
				}
				if(this._arrowPosition == ARROW_POSITION_BOTTOM && this._bottomArrowSkin)
				{
					newWidth = Math.max(newWidth, this._bottomArrowSkin.width + this._paddingLeft + this._paddingRight);
				}
				newWidth = Math.min(newWidth, this.stage.stageWidth - stagePaddingLeft - stagePaddingRight);
			}
			if(needsHeight)
			{
				newHeight = this._originalContentHeight + this._paddingTop + this._paddingBottom;
				if(!isNaN(this._originalBackgroundHeight))
				{
					newHeight = Math.max(this._originalBackgroundHeight, newHeight);
				}
				if(this._arrowPosition == ARROW_POSITION_TOP && this._topArrowSkin)
				{
					newHeight += this._topArrowSkin.height + this._topArrowGap;
				}
				if(this._arrowPosition == ARROW_POSITION_BOTTOM && this._bottomArrowSkin)
				{
					newHeight += this._bottomArrowSkin.height + this._bottomArrowGap;
				}
				if(this._arrowPosition == ARROW_POSITION_LEFT && this._leftArrowSkin)
				{
					newHeight = Math.max(newHeight, this._leftArrowSkin.height + this._paddingTop + this._paddingBottom);
				}
				if(this._arrowPosition == ARROW_POSITION_RIGHT && this._rightArrowSkin)
				{
					newHeight = Math.max(newHeight, this._rightArrowSkin.height + this._paddingTop + this._paddingBottom);
				}
				newHeight = Math.min(newHeight, this.stage.stageHeight - stagePaddingTop - stagePaddingBottom);
			}
			return this.setSizeInternal(newWidth, newHeight, false);
		}

		/**
		 * @private
		 */
		protected function refreshArrowSkin():void
		{
			this.currentArrowSkin = null;
			if(this._arrowPosition == ARROW_POSITION_BOTTOM)
			{
				this.currentArrowSkin = this._bottomArrowSkin;
			}
			else if(this._bottomArrowSkin)
			{
				this._bottomArrowSkin.visible = false;
			}
			if(this._arrowPosition == ARROW_POSITION_TOP)
			{
				this.currentArrowSkin = this._topArrowSkin;
			}
			else if(this._topArrowSkin)
			{
				this._topArrowSkin.visible = false;
			}
			if(this._arrowPosition == ARROW_POSITION_LEFT)
			{
				this.currentArrowSkin = this._leftArrowSkin;
			}
			else if(this._leftArrowSkin)
			{
				this._leftArrowSkin.visible = false;
			}
			if(this._arrowPosition == ARROW_POSITION_RIGHT)
			{
				this.currentArrowSkin = this._rightArrowSkin;
			}
			else if(this._rightArrowSkin)
			{
				this._rightArrowSkin.visible = false;
			}
			if(this.currentArrowSkin)
			{
				this.currentArrowSkin.visible = true;
			}
		}

		/**
		 * @private
		 */
		protected function layout():void
		{
			const xPosition:Number = (this._leftArrowSkin && this._arrowPosition == ARROW_POSITION_LEFT) ? this._leftArrowSkin.width + this._leftArrowGap : 0;
			const yPosition:Number = (this._topArrowSkin &&  this._arrowPosition == ARROW_POSITION_TOP) ? this._topArrowSkin.height + this._topArrowGap : 0;
			const widthOffset:Number = (this._rightArrowSkin && this._arrowPosition == ARROW_POSITION_RIGHT) ? this._rightArrowSkin.width + this._rightArrowGap : 0;
			const heightOffset:Number = (this._bottomArrowSkin && this._arrowPosition == ARROW_POSITION_BOTTOM) ? this._bottomArrowSkin.height + this._bottomArrowGap : 0;
			this._backgroundSkin.x = xPosition;
			this._backgroundSkin.y = yPosition;
			this._backgroundSkin.width = this.actualWidth - xPosition - widthOffset;
			this._backgroundSkin.height = this.actualHeight - yPosition - heightOffset;

			if(this.currentArrowSkin)
			{
				if(this._arrowPosition == ARROW_POSITION_LEFT)
				{
					this._leftArrowSkin.x = this._backgroundSkin.x - this._leftArrowSkin.width - this._leftArrowGap;
					this._leftArrowSkin.y = this._arrowOffset + this._backgroundSkin.y + (this._backgroundSkin.height - this._leftArrowSkin.height) / 2;
					this._leftArrowSkin.y = Math.min(this._backgroundSkin.y + this._backgroundSkin.height - this._paddingBottom - this._leftArrowSkin.height, Math.max(this._backgroundSkin.y + this._paddingTop, this._leftArrowSkin.y));
				}
				else if(this._arrowPosition == ARROW_POSITION_RIGHT)
				{
					this._rightArrowSkin.x = this._backgroundSkin.x + this._backgroundSkin.width + this._rightArrowGap;
					this._rightArrowSkin.y = this._arrowOffset + this._backgroundSkin.y + (this._backgroundSkin.height - this._rightArrowSkin.height) / 2;
					this._rightArrowSkin.y = Math.min(this._backgroundSkin.y + this._backgroundSkin.height - this._paddingBottom - this._rightArrowSkin.height, Math.max(this._backgroundSkin.y + this._paddingTop, this._rightArrowSkin.y));
				}
				else if(this._arrowPosition == ARROW_POSITION_BOTTOM)
				{
					this._bottomArrowSkin.x = this._arrowOffset + this._backgroundSkin.x + (this._backgroundSkin.width - this._bottomArrowSkin.width) / 2;
					this._bottomArrowSkin.x = Math.min(this._backgroundSkin.x + this._backgroundSkin.width - this._paddingRight - this._bottomArrowSkin.width, Math.max(this._backgroundSkin.x + this._paddingLeft, this._bottomArrowSkin.x));
					this._bottomArrowSkin.y = this._backgroundSkin.y + this._backgroundSkin.height + this._bottomArrowGap;
				}
				else //top
				{
					this._topArrowSkin.x = this._arrowOffset + this._backgroundSkin.x + (this._backgroundSkin.width - this._topArrowSkin.width) / 2;
					this._topArrowSkin.x = Math.min(this._backgroundSkin.x + this._backgroundSkin.width - this._paddingRight - this._topArrowSkin.width, Math.max(this._backgroundSkin.x + this._paddingLeft, this._topArrowSkin.x));
					this._topArrowSkin.y = this._backgroundSkin.y - this._topArrowSkin.height - this._topArrowGap;
				}
			}

			if(this._content)
			{
				this._content.x = this._backgroundSkin.x + this._paddingLeft;
				this._content.y = this._backgroundSkin.y + this._paddingTop;
				this._content.width = this._backgroundSkin.width - this._paddingLeft - this._paddingRight;
				this._content.height = this._backgroundSkin.height - this._paddingTop - this._paddingBottom;
			}
		}

		/**
		 * @private
		 */
		protected function addedToStageHandler(event:Event):void
		{
			//to avoid touch events bubbling up to the callout and causing it to
			//close immediately, we wait one frame before allowing it to close
			//based on touches.
			this._isReadyToClose = false;
			this.addEventListener(EnterFrameEvent.ENTER_FRAME, enterFrameHandler);
		}

		/**
		 * @private
		 */
		protected function removedFromStageHandler(event:Event):void
		{
			this.stage.removeEventListener(TouchEvent.TOUCH, stage_touchHandler);
			Starling.current.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
		}

		/**
		 * @private
		 */
		protected function enterFrameHandler(event:Event):void
		{
			this.removeEventListener(EnterFrameEvent.ENTER_FRAME, enterFrameHandler);
			this._isReadyToClose = true;
		}

		/**
		 * @private
		 */
		protected function stage_touchHandler(event:TouchEvent):void
		{
			if(!this._isReadyToClose || (!this.closeOnTouchEndedOutside && !this.closeOnTouchBeganOutside) ||
				this.contains(DisplayObject(event.target)))
			{
				return;
			}

			const touches:Vector.<Touch> = event.getTouches(this.stage, null, HELPER_TOUCHES_VECTOR);
			const touchCount:int = touches.length;
			for(var i:int = 0; i < touchCount; i++)
			{
				var touch:Touch = touches[i];
				var phase:String = touch.phase;
				if((this.closeOnTouchBeganOutside && phase == TouchPhase.BEGAN) ||
					(this.closeOnTouchEndedOutside && phase == TouchPhase.ENDED))
				{
					this.close(this._isPopUp);
					break;
				}
			}
			HELPER_TOUCHES_VECTOR.length = 0;
		}

		/**
		 * @private
		 */
		protected function stage_keyDownHandler(event:KeyboardEvent):void
		{
			if(!this.closeOnKeys || this.closeOnKeys.indexOf(event.keyCode) < 0)
			{
				return;
			}
			//don't let the OS handle the event
			event.preventDefault();
			//don't let other event handlers handle the event
			event.stopImmediatePropagation();
			this.close(this._isPopUp);
		}
	}
}
