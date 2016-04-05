/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.core.FeathersControl;
	import feathers.core.IFeathersControl;
	import feathers.core.IValidating;
	import feathers.core.PopUpManager;
	import feathers.events.FeathersEventType;
	import feathers.layout.RelativePosition;
	import feathers.skins.IStyleProvider;
	import feathers.utils.display.getDisplayObjectDepthFromStage;

	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * Dispatched when the callout is closed.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>null</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @eventType starling.events.Event.CLOSE
	 */
	[Event(name="close",type="starling.events.Event")]

	/**
	 * A pop-up container that points at (or calls out) a specific region of
	 * the application (typically a specific control that triggered it).
	 *
	 * <p>In general, a <code>Callout</code> isn't instantiated directly.
	 * Instead, you will typically call the static function
	 * <code>Callout.show()</code>. This is not required, but it result in less
	 * code and no need to manually manage calls to the <code>PopUpManager</code>.</p>
	 *
	 * <p>In the following example, a callout displaying a <code>Label</code> is
	 * shown when a <code>Button</code> is triggered:</p>
	 *
	 * <listing version="3.0">
	 * button.addEventListener( Event.TRIGGERED, button_triggeredHandler );
	 * 
	 * function button_triggeredHandler( event:Event ):void
	 * {
	 *     var label:Label = new Label();
	 *     label.text = "Hello World!";
	 *     var button:Button = Button( event.currentTarget );
	 *     Callout.show( label, button );
	 * }</listing>
	 *
	 * @see ../../../help/callout.html How to use the Feathers Callout component
	 */
	public class Callout extends FeathersControl
	{
		/**
		 * The default <code>IStyleProvider</code> for all <code>Callout</code>
		 * components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * The default positions used by a callout.
		 */
		public static const DEFAULT_POSITIONS:Vector.<String> = new <String>
		[
			RelativePosition.BOTTOM,
			RelativePosition.TOP,
			RelativePosition.RIGHT,
			RelativePosition.LEFT,
		];

		/**
		 * @private
		 * DEPRECATED: Replaced by a Vector.&lt;String&gt; containing values from
		 * <code>feathers.layout.RelativePosition</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const DIRECTION_ANY:String = "any";

		/**
		 * @private
		 * DEPRECATED: Replaced by a Vector.&lt;String&gt; containing values from
		 * <code>feathers.layout.RelativePosition</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const DIRECTION_VERTICAL:String = "vertical";

		/**
		 * @private
		 * DEPRECATED: Replaced by a Vector.&lt;String&gt; containing values from
		 * <code>feathers.layout.RelativePosition</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const DIRECTION_HORIZONTAL:String = "horizontal";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.RelativePosition.TOP</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const DIRECTION_UP:String = "up";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.RelativePosition.BOTTOM</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const DIRECTION_DOWN:String = "down";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.RelativePosition.LEFT</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const DIRECTION_LEFT:String = "left";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.RelativePosition.RIGHT</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const DIRECTION_RIGHT:String = "right";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.RelativePosition.TOP</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const ARROW_POSITION_TOP:String = "top";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.RelativePosition.RIGHT</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const ARROW_POSITION_RIGHT:String = "right";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.RelativePosition.BOTTOM</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const ARROW_POSITION_BOTTOM:String = "bottom";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.RelativePosition.LEFT</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const ARROW_POSITION_LEFT:String = "left";

		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_ORIGIN:String = "origin";

		/**
		 * @private
		 */
		private static const HELPER_RECT:Rectangle = new Rectangle();

		/**
		 * @private
		 */
		private static const HELPER_POINT:Point = new Point();

		/**
		 * @private
		 */
		protected static const FUZZY_CONTENT_DIMENSIONS_PADDING:Number = 0.000001;

		/**
		 * Quickly sets all stage padding properties to the same value. The
		 * <code>stagePadding</code> getter always returns the value of
		 * <code>stagePaddingTop</code>, but the other padding values may be
		 * different.
		 *
		 * <p>The following example gives the stage 20 pixels of padding on all
		 * sides:</p>
		 *
		 * <listing version="3.0">
		 * Callout.stagePadding = 20;</listing>
		 *
		 * @default 0
		 *
		 * @see #stagePaddingTop
		 * @see #stagePaddingRight
		 * @see #stagePaddingBottom
		 * @see #stagePaddingLeft
		 */
		public static function get stagePadding():Number
		{
			return Callout.stagePaddingTop;
		}

		/**
		 * @private
		 */
		public static function set stagePadding(value:Number):void
		{
			Callout.stagePaddingTop = value;
			Callout.stagePaddingRight = value;
			Callout.stagePaddingBottom = value;
			Callout.stagePaddingLeft = value;
		}

		/**
		 * The padding between a callout and the top edge of the stage when the
		 * callout is positioned automatically. May be ignored if the callout
		 * is too big for the stage.
		 *
		 * <p>In the following example, the top stage padding will be set to
		 * 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * Callout.stagePaddingTop = 20;</listing>
		 */
		public static var stagePaddingTop:Number = 0;

		/**
		 * The padding between a callout and the right edge of the stage when the
		 * callout is positioned automatically. May be ignored if the callout
		 * is too big for the stage.
		 *
		 * <p>In the following example, the right stage padding will be set to
		 * 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * Callout.stagePaddingRight = 20;</listing>
		 */
		public static var stagePaddingRight:Number = 0;

		/**
		 * The padding between a callout and the bottom edge of the stage when the
		 * callout is positioned automatically. May be ignored if the callout
		 * is too big for the stage.
		 *
		 * <p>In the following example, the bottom stage padding will be set to
		 * 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * Callout.stagePaddingBottom = 20;</listing>
		 */
		public static var stagePaddingBottom:Number = 0;

		/**
		 * The margin between a callout and the top edge of the stage when the
		 * callout is positioned automatically. May be ignored if the callout
		 * is too big for the stage.
		 *
		 * <p>In the following example, the left stage padding will be set to
		 * 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * Callout.stagePaddingLeft = 20;</listing>
		 */
		public static var stagePaddingLeft:Number = 0;

		/**
		 * Returns a new <code>Callout</code> instance when
		 * <code>Callout.show()</code> is called. If one wishes to skin the
		 * callout manually or change its behavior, a custom factory may be
		 * provided.
		 *
		 * <p>This function is expected to have the following signature:</p>
		 *
		 * <pre>function():Callout</pre>
		 *
		 * <p>The following example shows how to create a custom callout factory:</p>
		 *
		 * <listing version="3.0">
		 * Callout.calloutFactory = function():Callout
		 * {
		 *     var callout:Callout = new Callout();
		 *     //set properties here!
		 *     return callout;
		 * };</listing>
		 * 
		 * <p>Note: the default callout factory sets the following properties:</p>
		 *
		 * <listing version="3.0">
		 * callout.closeOnTouchBeganOutside = true;
		 * callout.closeOnTouchEndedOutside = true;
		 * callout.closeOnKeys = new &lt;uint&gt;[Keyboard.BACK, Keyboard.ESCAPE];</listing>
		 *
		 * @see #show()
		 */
		public static var calloutFactory:Function = defaultCalloutFactory;

		/**
		 * Returns an overlay to display with a callout that is modal. Uses the
		 * standard <code>overlayFactory</code> of the <code>PopUpManager</code>
		 * by default, but you can use this property to provide your own custom
		 * overlay, if you prefer.
		 *
		 * <p>This function is expected to have the following signature:</p>
		 * <pre>function():DisplayObject</pre>
		 *
		 * <p>The following example uses a semi-transparent <code>Quad</code> as
		 * a custom overlay:</p>
		 *
		 * <listing version="3.0">
		 * Callout.calloutOverlayFactory = function():Quad
		 * {
		 *     var quad:Quad = new Quad(10, 10, 0x000000);
		 *     quad.alpha = 0.75;
		 *     return quad;
		 * };</listing>
		 *
		 * @see feathers.core.PopUpManager#overlayFactory
		 *
		 * @see #show()
		 */
		public static var calloutOverlayFactory:Function = PopUpManager.defaultOverlayFactory;

		/**
		 * Creates a callout, and then positions and sizes it automatically
		 * based on an origin rectangle and the specified direction relative to
		 * the original. The provided width and height values are optional, and
		 * these values may be ignored if the callout cannot be drawn at the
		 * specified dimensions.
		 * 
		 * <p>The <code>supportedPositions</code> parameter should be a
		 * <code>Vector.&lt;String&gt;</code> of values from the
		 * <code>feathers.layout.RelativePosition</code> class. The positions
		 * should be ordered by preference. This parameter is typed as
		 * <code>Object</code> to allow some deprecated <code>String</code>
		 * values. In a future version of Feathers, the type will change to
		 * <code>Vector.&lt;String&gt;</code> instead.</p>
		 *
		 * <p>In the following example, a callout displaying a <code>Label</code> is
		 * shown when a <code>Button</code> is triggered:</p>
		 *
		 * <listing version="3.0">
		 * button.addEventListener( Event.TRIGGERED, button_triggeredHandler );
		 *
		 * function button_triggeredHandler( event:Event ):void
		 * {
		 *     var label:Label = new Label();
		 *     label.text = "Hello World!";
		 *     var button:Button = Button( event.currentTarget );
		 *     Callout.show( label, button );
		 * }</listing>
		 */
		public static function show(content:DisplayObject, origin:DisplayObject,
			supportedPositions:Object = null, isModal:Boolean = true, customCalloutFactory:Function = null,
			customOverlayFactory:Function = null):Callout
		{
			if(origin.stage === null)
			{
				throw new ArgumentError("Callout origin must be added to the stage.");
			}
			var factory:Function = customCalloutFactory;
			if(factory === null)
			{
				factory = calloutFactory;
				if(factory === null)
				{
					factory = defaultCalloutFactory;
				}
			}
			var callout:Callout = Callout(factory());
			callout.content = content;
			if(supportedPositions is String)
			{
				//fallback for deprecated options
				callout.supportedDirections = supportedPositions as String;
			}
			else
			{
				callout.supportedPositions = supportedPositions as Vector.<String>;
			}
			callout.origin = origin;
			factory = customOverlayFactory;
			if(factory === null)
			{
				factory = calloutOverlayFactory;
				if(factory === null)
				{
					factory = PopUpManager.defaultOverlayFactory;
				}
			}
			PopUpManager.addPopUp(callout, isModal, false, factory);
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
			var callout:Callout = new Callout();
			callout.closeOnTouchBeganOutside = true;
			callout.closeOnTouchEndedOutside = true;
			callout.closeOnKeys = new <uint>[Keyboard.BACK, Keyboard.ESCAPE];
			return callout;
		}

		/**
		 * @private
		 */
		protected static function positionBelowOrigin(callout:Callout, globalOrigin:Rectangle):void
		{
			callout.measureWithArrowPosition(RelativePosition.TOP, HELPER_POINT);
			var idealXPosition:Number = globalOrigin.x + Math.round((globalOrigin.width - HELPER_POINT.x) / 2);
			var xPosition:Number = Math.max(stagePaddingLeft, Math.min(Starling.current.stage.stageWidth - HELPER_POINT.x - stagePaddingRight, idealXPosition));
			callout.x = xPosition;
			callout.y = globalOrigin.y + globalOrigin.height;
			if(callout._isValidating)
			{
				//no need to invalidate and need to validate again next frame
				callout._arrowOffset = idealXPosition - xPosition;
				callout._arrowPosition = RelativePosition.TOP;
			}
			else
			{
				callout.arrowOffset = idealXPosition - xPosition;
				callout.arrowPosition = RelativePosition.TOP;
			}
		}

		/**
		 * @private
		 */
		protected static function positionAboveOrigin(callout:Callout, globalOrigin:Rectangle):void
		{
			callout.measureWithArrowPosition(RelativePosition.BOTTOM, HELPER_POINT);
			var idealXPosition:Number = globalOrigin.x + Math.round((globalOrigin.width - HELPER_POINT.x) / 2);
			var xPosition:Number = Math.max(stagePaddingLeft, Math.min(Starling.current.stage.stageWidth - HELPER_POINT.x - stagePaddingRight, idealXPosition));
			callout.x = xPosition;
			callout.y = globalOrigin.y - HELPER_POINT.y;
			if(callout._isValidating)
			{
				//no need to invalidate and need to validate again next frame
				callout._arrowOffset = idealXPosition - xPosition;
				callout._arrowPosition = RelativePosition.BOTTOM;
			}
			else
			{
				callout.arrowOffset = idealXPosition - xPosition;
				callout.arrowPosition = RelativePosition.BOTTOM;
			}
		}

		/**
		 * @private
		 */
		protected static function positionToRightOfOrigin(callout:Callout, globalOrigin:Rectangle):void
		{
			callout.measureWithArrowPosition(RelativePosition.LEFT, HELPER_POINT);
			callout.x = globalOrigin.x + globalOrigin.width;
			var idealYPosition:Number = globalOrigin.y + Math.round((globalOrigin.height - HELPER_POINT.y) / 2);
			var yPosition:Number = Math.max(stagePaddingTop, Math.min(Starling.current.stage.stageHeight - HELPER_POINT.y - stagePaddingBottom, idealYPosition));
			callout.y = yPosition;
			if(callout._isValidating)
			{
				//no need to invalidate and need to validate again next frame
				callout._arrowOffset = idealYPosition - yPosition;
				callout._arrowPosition = RelativePosition.LEFT;
			}
			else
			{
				callout.arrowOffset = idealYPosition - yPosition;
				callout.arrowPosition = RelativePosition.LEFT;
			}
		}

		/**
		 * @private
		 */
		protected static function positionToLeftOfOrigin(callout:Callout, globalOrigin:Rectangle):void
		{
			callout.measureWithArrowPosition(RelativePosition.RIGHT, HELPER_POINT);
			callout.x = globalOrigin.x - HELPER_POINT.x;
			var idealYPosition:Number = globalOrigin.y + Math.round((globalOrigin.height - HELPER_POINT.y) / 2);
			var yPosition:Number = Math.max(stagePaddingLeft, Math.min(Starling.current.stage.stageHeight - HELPER_POINT.y - stagePaddingBottom, idealYPosition));
			callout.y = yPosition;
			if(callout._isValidating)
			{
				//no need to invalidate and need to validate again next frame
				callout._arrowOffset = idealYPosition - yPosition;
				callout._arrowPosition = RelativePosition.RIGHT;
			}
			else
			{
				callout.arrowOffset = idealYPosition - yPosition;
				callout.arrowPosition = RelativePosition.RIGHT;
			}
		}

		/**
		 * Constructor.
		 */
		public function Callout()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, callout_addedToStageHandler);
		}

		/**
		 * Determines if the callout is automatically closed if a touch in the
		 * <code>TouchPhase.BEGAN</code> phase happens outside of the callout's
		 * bounds.
		 *
		 * <p>In the following example, the callout will not close when a touch
		 * event with <code>TouchPhase.BEGAN</code> is detected outside the
		 * callout's (or its origin's) bounds:</p>
		 *
		 * <listing version="3.0">
		 * callout.closeOnTouchBeganOutside = false;</listing>
		 *
		 * @see #closeOnTouchEndedOutside
		 * @see #closeOnKeys
		 */
		public var closeOnTouchBeganOutside:Boolean = false;

		/**
		 * Determines if the callout is automatically closed if a touch in the
		 * <code>TouchPhase.ENDED</code> phase happens outside of the callout's
		 * bounds.
		 *
		 * <p>In the following example, the callout will not close when a touch
		 * event with <code>TouchPhase.ENDED</code> is detected outside the
		 * callout's (or its origin's) bounds:</p>
		 *
		 * <listing version="3.0">
		 * callout.closeOnTouchEndedOutside = false;</listing>
		 *
		 * @see #closeOnTouchBeganOutside
		 * @see #closeOnKeys
		 */
		public var closeOnTouchEndedOutside:Boolean = false;

		/**
		 * The callout will be closed if any of these keys are pressed.
		 *
		 * <p>In the following example, the callout close when the Escape key
		 * is pressed:</p>
		 *
		 * <listing version="3.0">
		 * callout.closeOnKeys = new &lt;uint&gt;[Keyboard.ESCAPE];</listing>
		 *
		 * @see #closeOnTouchBeganOutside
		 * @see #closeOnTouchEndedOutside
		 */
		public var closeOnKeys:Vector.<uint>;

		/**
		 * Determines if the callout will be disposed when <code>close()</code>
		 * is called internally. Close may be called internally in a variety of
		 * cases, depending on values such as <code>closeOnTouchBeganOutside</code>,
		 * <code>closeOnTouchEndedOutside</code>, and <code>closeOnKeys</code>.
		 * If set to <code>false</code>, you may reuse the callout later by
		 * giving it a new <code>origin</code> and adding it to the
		 * <code>PopUpManager</code> again.
		 *
		 * <p>In the following example, the callout will not be disposed when it
		 * closes itself:</p>
		 *
		 * <listing version="3.0">
		 * callout.disposeOnSelfClose = false;</listing>
		 *
		 * @see #closeOnTouchBeganOutside
		 * @see #closeOnTouchEndedOutside
		 * @see #closeOnKeys
		 * @see #close()
		 */
		public var disposeOnSelfClose:Boolean = true;

		/**
		 * Determines if the callout's content will be disposed when the callout
		 * is disposed. If set to <code>false</code>, the callout's content may
		 * be added to the display list again later.
		 *
		 * <p>In the following example, the callout's content will not be
		 * disposed when the callout is disposed:</p>
		 *
		 * <listing version="3.0">
		 * callout.disposeContent = false;</listing>
		 */
		public var disposeContent:Boolean = true;

		/**
		 * @private
		 */
		protected var _isReadyToClose:Boolean = false;

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return Callout.globalStyleProvider;
		}

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
		 *
		 * <p>In the following example, the callout's content is an image:</p>
		 *
		 * <listing version="3.0">
		 * callout.content = new Image( texture );</listing>
		 *
		 * @default null
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
				if(this._content is IFeathersControl)
				{
					IFeathersControl(this._content).removeEventListener(FeathersEventType.RESIZE, content_resizeHandler);
				}
				if(this._content.parent == this)
				{
					this._content.removeFromParent(false);
				}
			}
			this._content = value;
			if(this._content)
			{
				if(this._content is IFeathersControl)
				{
					IFeathersControl(this._content).addEventListener(FeathersEventType.RESIZE, content_resizeHandler);
				}
				this.addChild(this._content);
			}
			this.invalidate(INVALIDATION_FLAG_SIZE);
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _origin:DisplayObject;

		/**
		 * A callout may be positioned relative to another display object, known
		 * as the callout's origin. Even if the position of the origin changes,
		 * the callout will reposition itself to always point at the origin.
		 *
		 * <p>When an origin is set, the <code>arrowPosition</code> and
		 * <code>arrowOffset</code> properties will be managed automatically by
		 * the callout. Setting either of these values manually with either have
		 * no effect or unexpected behavior, so it is recommended that you
		 * avoid modifying those properties.</p>
		 *
		 * <p>In general, if you use <code>Callout.show()</code>, you will
		 * rarely need to manually manage the origin.</p>
		 *
		 * <p>In the following example, the callout's origin is set to a button:</p>
		 *
		 * <listing version="3.0">
		 * callout.origin = button;</listing>
		 *
		 * @default null
		 *
		 * @see #supportedDirections
		 * @see #arrowPosition
		 * @see #arrowOffset
		 */
		public function get origin():DisplayObject
		{
			return this._origin;
		}

		public function set origin(value:DisplayObject):void
		{
			if(this._origin == value)
			{
				return;
			}
			if(value && !value.stage)
			{
				throw new ArgumentError("Callout origin must have access to the stage.");
			}
			if(this._origin)
			{
				this.removeEventListener(EnterFrameEvent.ENTER_FRAME, callout_enterFrameHandler);
				this._origin.removeEventListener(Event.REMOVED_FROM_STAGE, origin_removedFromStageHandler);
			}
			this._origin = value;
			this._lastGlobalBoundsOfOrigin = null;
			if(this._origin)
			{
				this._origin.addEventListener(Event.REMOVED_FROM_STAGE, origin_removedFromStageHandler);
				this.addEventListener(EnterFrameEvent.ENTER_FRAME, callout_enterFrameHandler);
			}
			this.invalidate(INVALIDATION_FLAG_ORIGIN);
		}

		/**
		 * @private
		 */
		protected var _supportedDirections:String = null;

		/**
		 * @private
		 * DEPRECATED: Replaced by the <code>position</code> property.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public function get supportedDirections():String
		{
			return this._supportedDirections;
		}

		/**
		 * @private
		 */
		public function set supportedDirections(value:String):void
		{
			var positions:Vector.<String> = null;
			if(value === DIRECTION_ANY)
			{
				positions = new <String>[RelativePosition.BOTTOM, RelativePosition.TOP, RelativePosition.RIGHT, RelativePosition.LEFT];
			}
			else if(value === DIRECTION_HORIZONTAL)
			{
				positions = new <String>[RelativePosition.RIGHT, RelativePosition.LEFT];
			}
			else if(value === DIRECTION_VERTICAL)
			{
				positions = new <String>[RelativePosition.BOTTOM, RelativePosition.TOP];
			}
			else if(value === DIRECTION_UP)
			{
				positions = new <String>[RelativePosition.TOP];
			}
			else if(value === DIRECTION_DOWN)
			{
				positions = new <String>[RelativePosition.BOTTOM];
			}
			else if(value === DIRECTION_RIGHT)
			{
				positions = new <String>[RelativePosition.RIGHT];
			}
			else if(value === DIRECTION_LEFT)
			{
				positions = new <String>[RelativePosition.LEFT];
			}
			this._supportedDirections = value;
			this.supportedPositions = positions;
		}

		/**
		 * @private
		 */
		protected var _supportedPositions:Vector.<String> = null;

		/**
		 * The position of the callout, relative to its origin. Accepts a
		 * <code>Vector.&lt;String&gt;</code> containing one or more of the
		 * constants from <code>feathers.layout.RelativePosition</code> or
		 * <code>null</code>. If <code>null</code>, the callout will attempt to
		 * position itself using values in the following order:
		 * 
		 * <ul>
		 *     <li><code>RelativePosition.BOTTOM</code></li>
		 *     <li><code>RelativePosition.TOP</code></li>
		 *     <li><code>RelativePosition.RIGHT</code></li>
		 *     <li><code>RelativePosition.LEFT</code></li>
		 * </ul>
		 * 
		 * <p>Note: If the callout's origin is not set, the
		 * <code>supportedPositions</code> property will be ignored.</p>
		 *
		 * <p>In the following example, the callout's supported positions are
		 * restricted to the top and bottom of the origin:</p>
		 *
		 * <listing version="3.0">
		 * callout.supportedPositions = new &lt;String&gt;[RelativePosition.TOP, RelativePosition.BOTTOM];</listing>
		 *
		 * <p>In the following example, the callout's position is restricted to
		 * the right of the origin:</p>
		 *
		 * <listing version="3.0">
		 * callout.supportedPositions = new &lt;String&gt;[RelativePosition.RIGHT];</listing>
		 *
		 * <p>Note: The <code>arrowPosition</code> property is related to this
		 * one, but they have different meanings and are usually opposites. For
		 * example, a callout on the right side of its origin will generally
		 * display its left arrow.</p>
		 *
		 * @default null
		 *
		 * @see feathers.layout.RelativePosition#TOP
		 * @see feathers.layout.RelativePosition#RIGHT
		 * @see feathers.layout.RelativePosition#BOTTOM
		 * @see feathers.layout.RelativePosition#LEFT
		 */
		public function get supportedPositions():Vector.<String>
		{
			return this._supportedPositions;
		}

		/**
		 * @private
		 */
		public function set supportedPositions(value:Vector.<String>):void
		{
			this._supportedPositions = value;
		}

		/**
		 * Quickly sets all padding properties to the same value. The
		 * <code>padding</code> getter always returns the value of
		 * <code>paddingTop</code>, but the other padding values may be
		 * different.
		 *
		 * <p>In the following example, the padding of all sides of the callout
		 * is set to 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * callout.padding = 20;</listing>
		 *
		 * @default 0
		 *
		 * @see #paddingTop
		 * @see #paddingRight
		 * @see #paddingBottom
		 * @see #paddingLeft
		 */
		public function get padding():Number
		{
			return this._paddingTop;
		}

		/**
		 * @private
		 */
		public function set padding(value:Number):void
		{
			this.paddingTop = value;
			this.paddingRight = value;
			this.paddingBottom = value;
			this.paddingLeft = value;
		}

		/**
		 * @private
		 */
		protected var _paddingTop:Number = 0;

		/**
		 * The minimum space, in pixels, between the callout's top edge and the
		 * callout's content.
		 *
		 * <p>In the following example, the padding on the top edge of the
		 * callout is set to 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * callout.paddingTop = 20;</listing>
		 *
		 * @default 0
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
		 *
		 * <p>In the following example, the padding on the right edge of the
		 * callout is set to 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * callout.paddingRight = 20;</listing>
		 *
		 * @default 0
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
		 *
		 * <p>In the following example, the padding on the bottom edge of the
		 * callout is set to 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * callout.paddingBottom = 20;</listing>
		 *
		 * @default 0
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
		 *
		 * <p>In the following example, the padding on the left edge of the
		 * callout is set to 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * callout.paddingLeft = 20;</listing>
		 *
		 * @default 0
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
		protected var _arrowPosition:String = RelativePosition.TOP;

		[Inspectable(type="String",enumeration="top,right,bottom,left")]
		/**
		 * The position of the callout's arrow relative to the callout's
		 * background. If the callout's <code>origin</code> is set, this value
		 * will be managed by the callout and may change automatically if the
		 * origin moves to a new position or if the stage resizes.
		 *
		 * <p>The <code>supportedDirections</code> property is related to this
		 * one, but they have different meanings and are usually opposites. For
		 * example, a callout on the right side of its origin will generally
		 * display its left arrow.</p>
		 *
		 * <p>If you use <code>Callout.show()</code> or set the <code>origin</code>
		 * property manually, you should avoid manually modifying the
		 * <code>arrowPosition</code> and <code>arrowOffset</code> properties.</p>
		 *
		 * <p>In the following example, the callout's arrow is positioned on the
		 * left side:</p>
		 *
		 * <listing version="3.0">
		 * callout.arrowPosition = RelativePosition.LEFT;</listing>
		 *
		 * @default feathers.layout.RelativePosition.TOP
		 *
		 * @see feathers.layout.RelativePosition#TOP
		 * @see feathers.layout.RelativePosition#RIGHT
		 * @see feathers.layout.RelativePosition#BOTTOM
		 * @see feathers.layout.RelativePosition#LEFT
		 *
		 * @see #origin
		 * @see #supportedDirections
		 * @see #arrowOffset
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
		 *
		 * <p>In the following example, the callout's background is set to an image:</p>
		 *
		 * <listing version="3.0">
		 * callout.backgroundSkin = new Image( texture );</listing>
		 *
		 * @default null
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
		 *
		 * <p>In the following example, the callout's bottom arrow skin is set
		 * to an image:</p>
		 *
		 * <listing version="3.0">
		 * callout.bottomArrowSkin = new Image( texture );</listing>
		 *
		 * @default null
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
				var index:int = this.getChildIndex(this._content);
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
		 *
		 * <p>In the following example, the callout's top arrow skin is set
		 * to an image:</p>
		 *
		 * <listing version="3.0">
		 * callout.topArrowSkin = new Image( texture );</listing>
		 *
		 * @default null
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
				var index:int = this.getChildIndex(this._content);
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
		 *
		 * <p>In the following example, the callout's left arrow skin is set
		 * to an image:</p>
		 *
		 * <listing version="3.0">
		 * callout.leftArrowSkin = new Image( texture );</listing>
		 *
		 * @default null
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
				var index:int = this.getChildIndex(this._content);
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
		 *
		 * <p>In the following example, the callout's right arrow skin is set
		 * to an image:</p>
		 *
		 * <listing version="3.0">
		 * callout.rightArrowSkin = new Image( texture );</listing>
		 *
		 * @default null
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
				var index:int = this.getChildIndex(this._content);
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
		 *
		 * <p>In the following example, the gap between the callout and its
		 * top arrow is set to -4 pixels (perhaps to hide a border on the
		 * callout's background):</p>
		 *
		 * <listing version="3.0">
		 * callout.topArrowGap = -4;</listing>
		 *
		 * @default 0
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
		 *
		 * <p>In the following example, the gap between the callout and its
		 * bottom arrow is set to -4 pixels (perhaps to hide a border on the
		 * callout's background):</p>
		 *
		 * <listing version="3.0">
		 * callout.bottomArrowGap = -4;</listing>
		 *
		 * @default 0
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
		 *
		 * <p>In the following example, the gap between the callout and its
		 * right arrow is set to -4 pixels (perhaps to hide a border on the
		 * callout's background):</p>
		 *
		 * <listing version="3.0">
		 * callout.rightArrowGap = -4;</listing>
		 *
		 * @default 0
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
		 *
		 * <p>In the following example, the gap between the callout and its
		 * left arrow is set to -4 pixels (perhaps to hide a border on the
		 * callout's background):</p>
		 *
		 * <listing version="3.0">
		 * callout.leftArrowGap = -4;</listing>
		 *
		 * @default 0
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
		 * The offset, in pixels, of the arrow skin from the horizontal center
		 * or vertical middle of the background skin, depending on the position
		 * of the arrow (which side it is on). This value is used to point at
		 * the callout's origin when the callout is not perfectly centered
		 * relative to the origin.
		 *
		 * <p>On the top and bottom edges, the arrow will move left for negative
		 * values of <code>arrowOffset</code> and right for positive values. On
		 * the left and right edges, the arrow will move up for negative values
		 * and down for positive values.</p>
		 *
		 * <p>If you use <code>Callout.show()</code> or set the <code>origin</code>
		 * property manually, you should avoid manually modifying the
		 * <code>arrowPosition</code> and <code>arrowOffset</code> properties.</p>
		 *
		 * <p>In the following example, the arrow offset is set to 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * callout.arrowOffset = 20;</listing>
		 *
		 * @default 0
		 *
		 * @see #arrowPosition
		 * @see #origin
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
		 * @private
		 */
		protected var _lastGlobalBoundsOfOrigin:Rectangle;

		/**
		 * @private
		 */
		protected var _ignoreContentResize:Boolean = false;

		/**
		 * @private
		 */
		override public function dispose():void
		{
			this.origin = null;
			var savedContent:DisplayObject = this._content;
			this.content = null;
			//remove the content safely if it should not be disposed
			if(savedContent && this.disposeContent)
			{
				savedContent.dispose();
			}
			super.dispose();
		}

		/**
		 * Closes the callout.
		 */
		public function close(dispose:Boolean = false):void
		{
			if(this.parent)
			{
				//don't dispose here because we need to keep the event listeners
				//when dispatching Event.CLOSE. we'll dispose after that.
				this.removeFromParent(false);
				this.dispatchEventWith(Event.CLOSE);
			}
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
			this.addEventListener(Event.REMOVED_FROM_STAGE, callout_removedFromStageHandler);
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			var stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			var stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			var originInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_ORIGIN);

			if(sizeInvalid)
			{
				this._lastGlobalBoundsOfOrigin = null;
				originInvalid = true;
			}

			if(originInvalid)
			{
				this.positionRelativeToOrigin();
			}

			if(stylesInvalid || stateInvalid)
			{
				this.refreshArrowSkin();
			}

			if(stateInvalid)
			{
				if(this._content is IFeathersControl)
				{
					IFeathersControl(this._content).isEnabled = this._isEnabled;
				}
			}

			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

			if(sizeInvalid || stylesInvalid || dataInvalid || stateInvalid)
			{
				this.layoutChildren();
			}
		}

		/**
		 * If the component's dimensions have not been set explicitly, it will
		 * measure its content and determine an ideal size for itself. If the
		 * <code>explicitWidth</code> or <code>explicitHeight</code> member
		 * variables are set, those value will be used without additional
		 * measurement. If one is set, but not the other, the dimension with the
		 * explicit value will not be measured, but the other non-explicit
		 * dimension will still need measurement.
		 *
		 * <p>Calls <code>setSizeInternal()</code> to set up the
		 * <code>actualWidth</code> and <code>actualHeight</code> member
		 * variables used for layout.</p>
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 */
		protected function autoSizeIfNeeded():Boolean
		{
			this.measureWithArrowPosition(this._arrowPosition, HELPER_POINT);
			return this.setSizeInternal(HELPER_POINT.x, HELPER_POINT.y, false);
		}

		/**
		 * @private
		 */
		protected function measureWithArrowPosition(arrowPosition:String, result:Point = null):Point
		{
			if(!result)
			{
				result = new Point();
			}
			var needsWidth:Boolean = this._explicitWidth !== this._explicitWidth; //isNaN
			var needsHeight:Boolean = this._explicitHeight !== this._explicitHeight; //isNaN
			if(!needsWidth && !needsHeight)
			{
				result.x = this._explicitWidth;
				result.y = this._explicitHeight;
				return result;
			}

			var minWidth:Number = this._explicitMinWidth;
			var maxWidth:Number = this._maxWidth;
			var minHeight:Number = this._explicitMinHeight;
			var maxHeight:Number = this._maxHeight;
			//the background skin dimensions affect the minimum width
			if(this._originalBackgroundWidth === this._originalBackgroundWidth && //!isNaN
				minWidth < this._originalBackgroundWidth)
			{
				minWidth = this._originalBackgroundWidth;
			}
			if(this._originalBackgroundHeight === this._originalBackgroundHeight && //!isNaN
				minHeight < this._originalBackgroundHeight)
			{
				minHeight = this._originalBackgroundHeight;
			}
			//the width of top or bottom arrow (plus padding) affect the minimum
			//width too
			if(arrowPosition === RelativePosition.TOP && this._topArrowSkin)
			{
				var minWidthWithTopArrow:Number = this._topArrowSkin.width + this._paddingLeft + this._paddingRight;
				if(minWidth < minWidthWithTopArrow)
				{
					minWidth = minWidthWithTopArrow;
				}
			}
			if(arrowPosition === RelativePosition.BOTTOM && this._bottomArrowSkin)
			{
				var minWidthWithBottomArrow:Number = this._bottomArrowSkin.width + this._paddingLeft + this._paddingRight;
				if(minWidth < minWidthWithBottomArrow)
				{
					minWidth = minWidthWithBottomArrow;
				}
			}
			//the height of left or right arrow (plus padding) affect the
			//minimum height too
			if(arrowPosition === RelativePosition.LEFT && this._leftArrowSkin)
			{
				var minHeightWithLeftArrow:Number = this._leftArrowSkin.height + this._paddingTop + this._paddingBottom;
				if(minHeight < minHeightWithLeftArrow)
				{
					minHeight = minHeightWithLeftArrow;
				}
			}
			if(arrowPosition === RelativePosition.RIGHT && this._rightArrowSkin)
			{
				var minHeightWithRightArrow:Number = this._rightArrowSkin.height + this._paddingTop + this._paddingBottom;
				if(minHeight < minHeightWithRightArrow)
				{
					minHeight = minHeightWithRightArrow;
				}
			}
			//the dimensions of the stage (plus stage padding) affect the
			//maximum width and height
			if(this.stage)
			{
				var stageMaxWidth:Number = this.stage.stageWidth - stagePaddingLeft - stagePaddingRight;
				var stageMaxHeight:Number = this.stage.stageHeight - stagePaddingTop - stagePaddingBottom;
				if(maxWidth > stageMaxWidth)
				{
					maxWidth = stageMaxWidth;
				}
				if(maxHeight > stageMaxHeight)
				{
					maxHeight = stageMaxHeight;
				}
			}
			//the width of the left or right arrow skin affects the minimum and
			//maximum width of the content
			var leftOrRightArrowWidth:Number = 0;
			if(arrowPosition === RelativePosition.LEFT && this._leftArrowSkin)
			{
				leftOrRightArrowWidth += this._leftArrowSkin.width + this._leftArrowGap;
			}
			else if(arrowPosition === RelativePosition.RIGHT && this._rightArrowSkin)
			{
				leftOrRightArrowWidth += this._rightArrowSkin.width + this._rightArrowGap;
			}
			//the height of the top or bottom arrow skin affects the minimum and
			//maximum height of the content
			var topOrBottomArrowHeight:Number = 0;
			if(arrowPosition === RelativePosition.TOP && this._topArrowSkin)
			{
				topOrBottomArrowHeight += this._topArrowSkin.height + this._topArrowGap;
			}
			else if(arrowPosition === RelativePosition.BOTTOM && this._bottomArrowSkin)
			{
				topOrBottomArrowHeight += this._bottomArrowSkin.height + this._bottomArrowGap;
			}
			if(this._content is IFeathersControl)
			{
				var minContentWidth:Number = minWidth - leftOrRightArrowWidth - this._paddingLeft - this._paddingRight;
				var maxContentWidth:Number = maxWidth - leftOrRightArrowWidth - this._paddingLeft - this._paddingRight;
				var minContentHeight:Number = minHeight - topOrBottomArrowHeight - this._paddingTop - this._paddingBottom;
				var maxContentHeight:Number = maxHeight - topOrBottomArrowHeight - this._paddingTop - this._paddingBottom;
				//we only adjust the minimum and maximum dimensions of the
				//content when it won't fit into the callout's minimum or
				//maximum dimensions
				var feathersContent:IFeathersControl = IFeathersControl(this._content);
				if(feathersContent.minWidth < minContentWidth)
				{
					feathersContent.minWidth = minContentWidth;
				}
				if(feathersContent.maxWidth > maxContentWidth)
				{
					feathersContent.maxWidth = maxContentWidth;
				}
				if(feathersContent.minHeight < minContentHeight)
				{
					feathersContent.minHeight = minContentHeight;
				}
				if(feathersContent.maxHeight > maxContentHeight)
				{
					feathersContent.maxHeight = maxContentHeight;
				}
			}
			if(this._content is IValidating)
			{
				IValidating(this._content).validate();
			}

			var newWidth:Number = this._explicitWidth;
			var newHeight:Number = this._explicitHeight;
			if(needsWidth)
			{
				newWidth = this._content.width + leftOrRightArrowWidth + this._paddingLeft + this._paddingRight;
				if(newWidth < minWidth)
				{
					newWidth = minWidth;
				}
				else if(newWidth > maxWidth)
				{
					newWidth = maxWidth;
				}
			}
			if(needsHeight)
			{
				newHeight = this._content.height + topOrBottomArrowHeight + this._paddingTop + this._paddingBottom;
				if(newHeight < minHeight)
				{
					newHeight = minHeight;
				}
				else if(newHeight > maxHeight)
				{
					newHeight = maxHeight;
				}
			}
			result.x = newWidth;
			result.y = newHeight;
			return result;
		}

		/**
		 * @private
		 */
		protected function refreshArrowSkin():void
		{
			this.currentArrowSkin = null;
			if(this._arrowPosition == RelativePosition.BOTTOM)
			{
				this.currentArrowSkin = this._bottomArrowSkin;
			}
			else if(this._bottomArrowSkin)
			{
				this._bottomArrowSkin.visible = false;
			}
			if(this._arrowPosition == RelativePosition.TOP)
			{
				this.currentArrowSkin = this._topArrowSkin;
			}
			else if(this._topArrowSkin)
			{
				this._topArrowSkin.visible = false;
			}
			if(this._arrowPosition == RelativePosition.LEFT)
			{
				this.currentArrowSkin = this._leftArrowSkin;
			}
			else if(this._leftArrowSkin)
			{
				this._leftArrowSkin.visible = false;
			}
			if(this._arrowPosition == RelativePosition.RIGHT)
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
		protected function layoutChildren():void
		{
			var xPosition:Number = (this._leftArrowSkin && this._arrowPosition == RelativePosition.LEFT) ? this._leftArrowSkin.width + this._leftArrowGap : 0;
			var yPosition:Number = (this._topArrowSkin &&  this._arrowPosition == RelativePosition.TOP) ? this._topArrowSkin.height + this._topArrowGap : 0;
			var widthOffset:Number = (this._rightArrowSkin && this._arrowPosition == RelativePosition.RIGHT) ? this._rightArrowSkin.width + this._rightArrowGap : 0;
			var heightOffset:Number = (this._bottomArrowSkin && this._arrowPosition == RelativePosition.BOTTOM) ? this._bottomArrowSkin.height + this._bottomArrowGap : 0;
			var backgroundWidth:Number = this.actualWidth - xPosition - widthOffset;
			var backgroundHeight:Number = this.actualHeight - yPosition - heightOffset;
			if(this._backgroundSkin)
			{
				this._backgroundSkin.x = xPosition;
				this._backgroundSkin.y = yPosition;
				this._backgroundSkin.width = backgroundWidth;
				this._backgroundSkin.height = backgroundHeight;
			}

			if(this.currentArrowSkin)
			{
				if(this._arrowPosition == RelativePosition.LEFT)
				{
					this._leftArrowSkin.x = xPosition - this._leftArrowSkin.width - this._leftArrowGap;
					this._leftArrowSkin.y = this._arrowOffset + yPosition + Math.round((backgroundHeight - this._leftArrowSkin.height) / 2);
					this._leftArrowSkin.y = Math.min(yPosition + backgroundHeight - this._paddingBottom - this._leftArrowSkin.height, Math.max(yPosition + this._paddingTop, this._leftArrowSkin.y));
				}
				else if(this._arrowPosition == RelativePosition.RIGHT)
				{
					this._rightArrowSkin.x = xPosition + backgroundWidth + this._rightArrowGap;
					this._rightArrowSkin.y = this._arrowOffset + yPosition + Math.round((backgroundHeight - this._rightArrowSkin.height) / 2);
					this._rightArrowSkin.y = Math.min(yPosition + backgroundHeight - this._paddingBottom - this._rightArrowSkin.height, Math.max(yPosition + this._paddingTop, this._rightArrowSkin.y));
				}
				else if(this._arrowPosition == RelativePosition.BOTTOM)
				{
					this._bottomArrowSkin.x = this._arrowOffset + xPosition + Math.round((backgroundWidth - this._bottomArrowSkin.width) / 2);
					this._bottomArrowSkin.x = Math.min(xPosition + backgroundWidth - this._paddingRight - this._bottomArrowSkin.width, Math.max(xPosition + this._paddingLeft, this._bottomArrowSkin.x));
					this._bottomArrowSkin.y = yPosition + backgroundHeight + this._bottomArrowGap;
				}
				else //top
				{
					this._topArrowSkin.x = this._arrowOffset + xPosition + Math.round((backgroundWidth - this._topArrowSkin.width) / 2);
					this._topArrowSkin.x = Math.min(xPosition + backgroundWidth - this._paddingRight - this._topArrowSkin.width, Math.max(xPosition + this._paddingLeft, this._topArrowSkin.x));
					this._topArrowSkin.y = yPosition - this._topArrowSkin.height - this._topArrowGap;
				}
			}

			if(this._content)
			{
				this._content.x = xPosition + this._paddingLeft;
				this._content.y = yPosition + this._paddingTop;
				var oldIgnoreContentResize:Boolean = this._ignoreContentResize;
				this._ignoreContentResize = true;
				var contentWidth:Number = backgroundWidth - this._paddingLeft - this._paddingRight;
				var difference:Number = Math.abs(this._content.width - contentWidth);
				//instead of !=, we do some fuzzy math to account for possible
				//floating point errors.
				if(difference > FUZZY_CONTENT_DIMENSIONS_PADDING)
				{
					//we prefer not to set the width property of the content
					//because that stops it from being able to resize, but
					//sometimes, it's required.
					this._content.width = contentWidth;
				}
				var contentHeight:Number = backgroundHeight - this._paddingTop - this._paddingBottom;
				difference = Math.abs(this._content.height - contentHeight);
				//instead of !=, we do some fuzzy math to account for possible
				//floating point errors.
				if(difference > FUZZY_CONTENT_DIMENSIONS_PADDING)
				{
					this._content.height = contentHeight;
				}
				this._ignoreContentResize = oldIgnoreContentResize;
			}
		}

		/**
		 * @private
		 */
		protected function positionRelativeToOrigin():void
		{
			if(this._origin === null)
			{
				return;
			}
			this._origin.getBounds(Starling.current.stage, HELPER_RECT);
			var hasGlobalBounds:Boolean = this._lastGlobalBoundsOfOrigin != null;
			if(hasGlobalBounds && this._lastGlobalBoundsOfOrigin.equals(HELPER_RECT))
			{
				return;
			}
			if(!hasGlobalBounds)
			{
				this._lastGlobalBoundsOfOrigin = new Rectangle();
			}
			this._lastGlobalBoundsOfOrigin.x = HELPER_RECT.x;
			this._lastGlobalBoundsOfOrigin.y = HELPER_RECT.y;
			this._lastGlobalBoundsOfOrigin.width = HELPER_RECT.width;
			this._lastGlobalBoundsOfOrigin.height = HELPER_RECT.height;

			var supportedPositions:Vector.<String> = this._supportedPositions;
			if(supportedPositions === null)
			{
				supportedPositions = DEFAULT_POSITIONS;
			}
			var positionsCount:int = supportedPositions.length;
			for(var i:int = 0; i < positionsCount; i++)
			{
				var position:String = supportedPositions[i];
				switch(position)
				{
					case RelativePosition.TOP:
					{
						//arrow is opposite, on bottom side
						this.measureWithArrowPosition(RelativePosition.BOTTOM, HELPER_POINT);
						var upSpace:Number = this._lastGlobalBoundsOfOrigin.y - HELPER_POINT.y;
						if(upSpace >= stagePaddingTop)
						{
							positionAboveOrigin(this, this._lastGlobalBoundsOfOrigin);
							return;
						}
						break;
					}
					case RelativePosition.RIGHT:
					{
						//arrow is opposite, on left side
						this.measureWithArrowPosition(RelativePosition.LEFT, HELPER_POINT);
						var rightSpace:Number = (Starling.current.stage.stageWidth - HELPER_POINT.x) - (this._lastGlobalBoundsOfOrigin.x + this._lastGlobalBoundsOfOrigin.width);
						if(rightSpace >= stagePaddingRight)
						{
							positionToRightOfOrigin(this, this._lastGlobalBoundsOfOrigin);
							return;
						}
						break;
					}
					case RelativePosition.LEFT:
					{
						this.measureWithArrowPosition(RelativePosition.RIGHT, HELPER_POINT);
						var leftSpace:Number = this._lastGlobalBoundsOfOrigin.x - HELPER_POINT.x;
						if(leftSpace >= stagePaddingLeft)
						{
							positionToLeftOfOrigin(this, this._lastGlobalBoundsOfOrigin);
							return;
						}
						break;
					}
					default: //bottom
					{
						//arrow is opposite, on top side
						this.measureWithArrowPosition(RelativePosition.TOP, HELPER_POINT);
						var downSpace:Number = (Starling.current.stage.stageHeight - HELPER_POINT.y) - (this._lastGlobalBoundsOfOrigin.y + this._lastGlobalBoundsOfOrigin.height);
						if(downSpace >= stagePaddingBottom)
						{
							positionBelowOrigin(this, this._lastGlobalBoundsOfOrigin);
							return;
						}
					}
				}
			}
			//worst case: pick the side that has the most available space
			if(downSpace >= upSpace && downSpace >= rightSpace && downSpace >= leftSpace)
			{
				positionBelowOrigin(this, this._lastGlobalBoundsOfOrigin);
			}
			else if(upSpace >= rightSpace && upSpace >= leftSpace)
			{
				positionAboveOrigin(this, this._lastGlobalBoundsOfOrigin);
			}
			else if(rightSpace >= leftSpace)
			{
				positionToRightOfOrigin(this, this._lastGlobalBoundsOfOrigin);
			}
			else
			{
				positionToLeftOfOrigin(this, this._lastGlobalBoundsOfOrigin);
			}
		}

		/**
		 * @private
		 */
		protected function callout_addedToStageHandler(event:Event):void
		{
			//using priority here is a hack so that objects higher up in the
			//display list have a chance to cancel the event first.
			var priority:int = -getDisplayObjectDepthFromStage(this);
			Starling.current.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, callout_nativeStage_keyDownHandler, false, priority, true);

			this.stage.addEventListener(TouchEvent.TOUCH, stage_touchHandler);
			//to avoid touch events bubbling up to the callout and causing it to
			//close immediately, we wait one frame before allowing it to close
			//based on touches.
			this._isReadyToClose = false;
			this.addEventListener(EnterFrameEvent.ENTER_FRAME, callout_oneEnterFrameHandler);
		}

		/**
		 * @private
		 */
		protected function callout_removedFromStageHandler(event:Event):void
		{
			this.stage.removeEventListener(TouchEvent.TOUCH, stage_touchHandler);
			Starling.current.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN, callout_nativeStage_keyDownHandler);
		}

		/**
		 * @private
		 */
		protected function callout_oneEnterFrameHandler(event:Event):void
		{
			this.removeEventListener(EnterFrameEvent.ENTER_FRAME, callout_oneEnterFrameHandler);
			this._isReadyToClose = true;
		}

		/**
		 * @private
		 */
		protected function callout_enterFrameHandler(event:EnterFrameEvent):void
		{
			this.positionRelativeToOrigin();
		}

		/**
		 * @private
		 */
		protected function stage_touchHandler(event:TouchEvent):void
		{
			var target:DisplayObject = DisplayObject(event.target);
			if(!this._isReadyToClose ||
				(!this.closeOnTouchEndedOutside && !this.closeOnTouchBeganOutside) || this.contains(target) ||
				(PopUpManager.isPopUp(this) && !PopUpManager.isTopLevelPopUp(this)))
			{
				return;
			}

			if(this._origin == target || (this._origin is DisplayObjectContainer && DisplayObjectContainer(this._origin).contains(target)))
			{
				return;
			}

			if(this.closeOnTouchBeganOutside)
			{
				var touch:Touch = event.getTouch(this.stage, TouchPhase.BEGAN);
				if(touch)
				{
					this.close(this.disposeOnSelfClose);
					return;
				}
			}
			if(this.closeOnTouchEndedOutside)
			{
				touch = event.getTouch(this.stage, TouchPhase.ENDED);
				if(touch)
				{
					this.close(this.disposeOnSelfClose);
					return;
				}
			}
		}

		/**
		 * @private
		 */
		protected function callout_nativeStage_keyDownHandler(event:KeyboardEvent):void
		{
			if(event.isDefaultPrevented())
			{
				//someone else already handled this one
				return;
			}
			if(!this.closeOnKeys || this.closeOnKeys.indexOf(event.keyCode) < 0)
			{
				return;
			}
			//don't let the OS handle the event
			event.preventDefault();
			this.close(this.disposeOnSelfClose);
		}

		/**
		 * @private
		 */
		protected function origin_removedFromStageHandler(event:Event):void
		{
			this.close(this.disposeOnSelfClose);
		}

		/**
		 * @private
		 */
		protected function content_resizeHandler(event:Event):void
		{
			if(this._ignoreContentResize)
			{
				return;
			}
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}
	}
}
