/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.core.FeathersControl;
	import feathers.core.IFeathersControl;
	import feathers.core.IFocusDisplayObject;
	import feathers.core.IMeasureDisplayObject;
	import feathers.core.IValidating;
	import feathers.core.PropertyProxy;
	import feathers.events.FeathersEventType;
	import feathers.layout.Direction;
	import feathers.skins.IStyleProvider;
	import feathers.utils.math.clamp;
	import feathers.utils.math.roundToNearest;

	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;

	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * A style name to add to the scroll bar's thumb sub-component.
	 * Typically used by a theme to provide different styles to different
	 * scroll bars.
	 *
	 * <p>In the following example, a custom thumb style name is passed
	 * to the scroll bar:</p>
	 *
	 * <listing version="3.0">
	 * scrollBar.customThumbStyleName = "my-custom-thumb";</listing>
	 *
	 * <p>In your theme, you can target this sub-component style name to
	 * provide different styles than the default:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( Button ).setFunctionForStyleName( "my-custom-thumb", setCustomThumbStyles );</listing>
	 *
	 * @default null
	 *
	 * @see #DEFAULT_CHILD_STYLE_NAME_THUMB
	 * @see feathers.core.FeathersControl#styleNameList
	 * @see #thumbFactory
	 */
	[Style(name="customThumbStyleName",type="String")]

	/**
	 * Determines if the scroll bar's thumb can be dragged horizontally or
	 * vertically. When this value changes, the scroll bar's width and
	 * height values do not change automatically.
	 * 
	 * <p>Note: When using a <code>SimpleScrollBar</code> with a scrolling
	 * container, the container will automatically set the correct
	 * <code>direction</code> value. Generally, you should not need to set this
	 * style manually.</p>
	 *
	 * <p>In the following example, the direction is changed to vertical:</p>
	 *
	 * <listing version="3.0">
	 * scrollBar.direction = Direction.VERTICAL;</listing>
	 *
	 * @default feathers.layout.Direction.HORIZONTAL
	 *
	 * @see feathers.layout.Direction#HORIZONTAL
	 * @see feathers.layout.Direction#VERTICAL
	 */
	[Style(name="direction",type="String")]

	/**
	 * Quickly sets all padding properties to the same value. The
	 * <code>padding</code> getter always returns the value of
	 * <code>paddingTop</code>, but the other padding values may be
	 * different.
	 *
	 * <p>In the following example, the padding is changed to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * scrollBar.padding = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:paddingTop
	 * @see #style:paddingRight
	 * @see #style:paddingBottom
	 * @see #style:paddingLeft
	 */
	[Style(name="padding",type="Number")]

	/**
	 * The minimum space, in pixels, above the thumb.
	 *
	 * <p>In the following example, the top padding is changed to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * scrollBar.paddingTop = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:padding
	 */
	[Style(name="paddingTop",type="Number")]

	/**
	 * The minimum space, in pixels, to the right of the thumb.
	 *
	 * <p>In the following example, the right padding is changed to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * scrollBar.paddingRight = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:padding
	 */
	[Style(name="paddingRight",type="Number")]

	/**
	 * The minimum space, in pixels, below the thumb.
	 *
	 * <p>In the following example, the bottom padding is changed to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * scrollBar.paddingBottom = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:padding
	 */
	[Style(name="paddingBottom",type="Number")]

	/**
	 * The minimum space, in pixels, to the left of the thumb.
	 *
	 * <p>In the following example, the left padding is changed to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * scrollBar.paddingLeft = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:padding
	 */
	[Style(name="paddingLeft",type="Number")]

	/**
	 * Dispatched when the scroll bar's value changes.
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
	 * @eventType starling.events.Event.CHANGE
	 */
	[Event(name="change",type="starling.events.Event")]

	/**
	 * Dispatched when the user starts dragging the scroll bar's thumb.
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
	 * @eventType feathers.events.FeathersEventType.BEGIN_INTERACTION
	 */
	[Event(name="beginInteraction",type="starling.events.Event")]

	/**
	 * Dispatched when the user stops dragging the scroll bar's thumb.
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
	 * @eventType feathers.events.FeathersEventType.END_INTERACTION
	 */
	[Event(name="endInteraction",type="starling.events.Event")]

	/**
	 * Select a value between a minimum and a maximum by dragging a thumb over
	 * a physical range. This type of scroll bar does not have a visible track,
	 * and it does not have increment and decrement buttons. It is ideal for
	 * mobile applications where the scroll bar is often simply a visual element
	 * to indicate the scroll position. For a more feature-rich scroll bar,
	 * see the <code>ScrollBar</code> component.
	 *
	 * <p>The following example updates a list to use simple scroll bars:</p>
	 *
	 * <listing version="3.0">
	 * list.horizontalScrollBarFactory = function():IScrollBar
	 * {
	 *     return new SimpleScrollBar();
	 * };
	 * list.verticalScrollBarFactory = function():IScrollBar
	 * {
	 *     return new SimpleScrollBar();
	 * };</listing>
	 *
	 * @see ../../../help/simple-scroll-bar.html How to use the Feathers SimpleScrollBar component
	 * @see feathers.controls.ScrollBar
	 *
	 * @productversion Feathers 1.0.0
	 */
	public class SimpleScrollBar extends FeathersControl implements IDirectionalScrollBar
	{
		/**
		 * @private
		 */
		private static const HELPER_POINT:Point = new Point();

		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_THUMB_FACTORY:String = "thumbFactory";

		[Deprecated(replacement="feathers.layout.Direction.HORIZONTAL",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.Direction.HORIZONTAL</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const DIRECTION_HORIZONTAL:String = "horizontal";

		[Deprecated(replacement="feathers.layout.Direction.VERTICAL",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.Direction.VERTICAL</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const DIRECTION_VERTICAL:String = "vertical";

		/**
		 * The default value added to the <code>styleNameList</code> of the thumb.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_THUMB:String = "feathers-simple-scroll-bar-thumb";

		/**
		 * The default <code>IStyleProvider</code> for all <code>SimpleScrollBar</code>
		 * components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * @private
		 */
		protected static function defaultThumbFactory():BasicButton
		{
			return new Button();
		}

		/**
		 * Constructor.
		 */
		public function SimpleScrollBar()
		{
			super();
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}

		/**
		 * The value added to the <code>styleNameList</code> of the thumb. This
		 * variable is <code>protected</code> so that sub-classes can customize
		 * the thumb style name in their constructors instead of using the
		 * default style name defined by <code>DEFAULT_CHILD_STYLE_NAME_THUMB</code>.
		 *
		 * <p>To customize the thumb style name without subclassing, see
		 * <code>customThumbStyleName</code>.</p>
		 *
		 * @see #style:customThumbStyleName
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var thumbStyleName:String = DEFAULT_CHILD_STYLE_NAME_THUMB;

		/**
		 * @private
		 */
		protected var _thumbExplicitWidth:Number;

		/**
		 * @private
		 */
		protected var _thumbExplicitHeight:Number;

		/**
		 * @private
		 */
		protected var _thumbExplicitMinWidth:Number;

		/**
		 * @private
		 */
		protected var _thumbExplicitMinHeight:Number;

		/**
		 * The thumb sub-component.
		 *
		 * <p>For internal use in subclasses.</p>
		 *
		 * @see #thumbFactory
		 * @see #createThumb()
		 */
		protected var thumb:DisplayObject;

		/**
		 * @private
		 */
		protected var track:Quad;

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return SimpleScrollBar.globalStyleProvider;
		}

		/**
		 * @private
		 */
		protected var _direction:String = Direction.HORIZONTAL;

		[Inspectable(type="String",enumeration="horizontal,vertical")]
		/**
		 * @private
		 */
		public function get direction():String
		{
			return this._direction;
		}

		/**
		 * @private
		 */
		public function set direction(value:String):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._direction === value)
			{
				return;
			}
			this._direction = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
			this.invalidate(INVALIDATION_FLAG_THUMB_FACTORY);
		}

		/**
		 * Determines if the value should be clamped to the range between the
		 * minimum and maximum. If <code>false</code> and the value is outside of the range,
		 * the thumb will shrink as if the range were increasing.
		 *
		 * <p>In the following example, the clamping behavior is updated:</p>
		 *
		 * <listing version="3.0">
		 * scrollBar.clampToRange = true;</listing>
		 *
		 * @default false
		 */
		public var clampToRange:Boolean = false;

		/**
		 * @private
		 */
		protected var _value:Number = 0;

		[Bindable(event="change")]
		/**
		 * @inheritDoc
		 *
		 * @default 0
		 *
		 * @see #maximum
		 * @see #minimum
		 * @see #step
		 * @see #page
		 * @see #event:change
		 */
		public function get value():Number
		{
			return this._value;
		}

		/**
		 * @private
		 */
		public function set value(newValue:Number):void
		{
			if(this.clampToRange)
			{
				newValue = clamp(newValue, this._minimum, this._maximum);
			}
			if(this._value == newValue)
			{
				return;
			}
			this._value = newValue;
			this.invalidate(INVALIDATION_FLAG_DATA);
			if(this.liveDragging || !this.isDragging)
			{
				this.dispatchEventWith(Event.CHANGE);
			}
		}

		/**
		 * @private
		 */
		protected var _minimum:Number = 0;

		/**
		 * @inheritDoc
		 *
		 * @default 0
		 *
		 * @see #value
		 * @see #maximum
		 */
		public function get minimum():Number
		{
			return this._minimum;
		}

		/**
		 * @private
		 */
		public function set minimum(value:Number):void
		{
			if(this._minimum == value)
			{
				return;
			}
			this._minimum = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _maximum:Number = 0;

		/**
		 * @inheritDoc
		 *
		 * @default 0
		 *
		 * @see #value
		 * @see #minimum
		 */
		public function get maximum():Number
		{
			return this._maximum;
		}

		/**
		 * @private
		 */
		public function set maximum(value:Number):void
		{
			if(this._maximum == value)
			{
				return;
			}
			this._maximum = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _step:Number = 0;

		/**
		 * @inheritDoc
		 *
		 * @default 0
		 *
		 * @see #value
		 * @see #page
		 */
		public function get step():Number
		{
			return this._step;
		}

		/**
		 * @private
		 */
		public function set step(value:Number):void
		{
			this._step = value;
		}

		/**
		 * @private
		 */
		protected var _page:Number = 0;

		/**
		 * @inheritDoc
		 *
		 * @default 0
		 *
		 * @see #value
		 * @see #step
		 */
		public function get page():Number
		{
			return this._page;
		}

		/**
		 * @private
		 */
		public function set page(value:Number):void
		{
			if(this._page == value)
			{
				return;
			}
			this._page = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
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
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._paddingTop === value)
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
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._paddingRight === value)
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
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._paddingBottom === value)
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
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._paddingLeft === value)
			{
				return;
			}
			this._paddingLeft = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var currentRepeatAction:Function;

		/**
		 * @private
		 */
		protected var _repeatTimer:Timer;

		/**
		 * @private
		 */
		protected var _repeatDelay:Number = 0.05;

		/**
		 * The time, in seconds, before actions are repeated. The first repeat
		 * happens after a delay that is five times longer than the following
		 * repeats.
		 *
		 * <p>In the following example, the repeat delay is changed to 500 milliseconds:</p>
		 *
		 * <listing version="3.0">
		 * scrollBar.repeatDelay = 0.5;</listing>
		 *
		 * @default 0.05
		 */
		public function get repeatDelay():Number
		{
			return this._repeatDelay;
		}

		/**
		 * @private
		 */
		public function set repeatDelay(value:Number):void
		{
			if(this._repeatDelay == value)
			{
				return;
			}
			this._repeatDelay = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var isDragging:Boolean = false;

		/**
		 * Determines if the scroll bar dispatches the <code>Event.CHANGE</code>
		 * event every time the thumb moves, or only once it stops moving.
		 *
		 * <p>In the following example, live dragging is disabled:</p>
		 *
		 * <listing version="3.0">
		 * scrollBar.liveDragging = false;</listing>
		 *
		 * @default true
		 */
		public var liveDragging:Boolean = true;

		/**
		 * @private
		 */
		protected var _thumbFactory:Function;

		/**
		 * A function used to generate the scroll bar's thumb sub-component.
		 * The thumb must be an instance of <code>BasicButton</code>. This
		 * factory can be used to change properties on the thumb when it is
		 * first created. For instance, if you are skinning Feathers components
		 * without a theme, you might use this factory to set skins and other
		 * styles on the thumb.
		 *
		 * <p>The function should have the following signature:</p>
		 * <pre>function():BasicButton</pre>
		 *
		 * <p>In the following example, a custom thumb factory is passed
		 * to the scroll bar:</p>
		 *
		 * <listing version="3.0">
		 * scrollBar.thumbFactory = function():BasicButton
		 * {
		 *     var thumb:BasicButton = new BasicButton();
		 *     var skin:ImageSkin = new ImageSkin( upTexture );
		 *     skin.setTextureForState( ButtonState.DOWN, downTexture );
		 *     thumb.defaultSkin = skin;
		 *     return thumb;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.BasicButton
		 */
		public function get thumbFactory():Function
		{
			return this._thumbFactory;
		}

		/**
		 * @private
		 */
		public function set thumbFactory(value:Function):void
		{
			if(this._thumbFactory == value)
			{
				return;
			}
			this._thumbFactory = value;
			this.invalidate(INVALIDATION_FLAG_THUMB_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _customThumbStyleName:String;

		/**
		 * @private
		 */
		public function get customThumbStyleName():String
		{
			return this._customThumbStyleName;
		}

		/**
		 * @private
		 */
		public function set customThumbStyleName(value:String):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._customThumbStyleName === value)
			{
				return;
			}
			this._customThumbStyleName = value;
			this.invalidate(INVALIDATION_FLAG_THUMB_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _thumbProperties:PropertyProxy;

		/**
		 * An object that stores properties for the scroll bar's thumb, and the
		 * properties will be passed down to the thumb when the scroll bar
		 * validates. For a list of available properties, refer to
		 * <a href="Button.html"><code>feathers.controls.BasicButton</code></a>.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
		 * which is in a <code>List</code>, you can use the following syntax:</p>
		 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * <p>Setting properties in a <code>thumbFactory</code> function instead
		 * of using <code>thumbProperties</code> will result in better
		 * performance.</p>
		 *
		 * <p>In the following example, the scroll bar's thumb properties
		 * are updated:</p>
		 *
		 * <listing version="3.0">
		 * scrollBar.thumbProperties.defaultSkin = new Image( upTexture );
		 * scrollBar.thumbProperties.downSkin = new Image( downTexture );</listing>
		 *
		 * @default null
		 *
		 * @see #thumbFactory
		 * @see feathers.controls.BasicButton
		 */
		public function get thumbProperties():Object
		{
			if(!this._thumbProperties)
			{
				this._thumbProperties = new PropertyProxy(thumbProperties_onChange);
			}
			return this._thumbProperties;
		}

		/**
		 * @private
		 */
		public function set thumbProperties(value:Object):void
		{
			if(this._thumbProperties == value)
			{
				return;
			}
			if(!value)
			{
				value = new PropertyProxy();
			}
			if(!(value is PropertyProxy))
			{
				var newValue:PropertyProxy = new PropertyProxy();
				for(var propertyName:String in value)
				{
					newValue[propertyName] = value[propertyName];
				}
				value = newValue;
			}
			if(this._thumbProperties)
			{
				this._thumbProperties.removeOnChangeCallback(thumbProperties_onChange);
			}
			this._thumbProperties = PropertyProxy(value);
			if(this._thumbProperties)
			{
				this._thumbProperties.addOnChangeCallback(thumbProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _touchPointID:int = -1;

		/**
		 * @private
		 */
		protected var _touchStartX:Number = NaN;

		/**
		 * @private
		 */
		protected var _touchStartY:Number = NaN;

		/**
		 * @private
		 */
		protected var _thumbStartX:Number = NaN;

		/**
		 * @private
		 */
		protected var _thumbStartY:Number = NaN;

		/**
		 * @private
		 */
		protected var _touchValue:Number;

		/**
		 * @private
		 */
		override protected function initialize():void
		{
			if(!this.track)
			{
				this.track = new Quad(10, 10, 0xff00ff);
				this.track.alpha = 0;
				this.track.addEventListener(TouchEvent.TOUCH, track_touchHandler);
				this.addChild(this.track);
			}
			if(this._value < this._minimum)
			{
				this.value = this._minimum;
			}
			else if(this._value > this._maximum)
			{
				this.value = this._maximum;
			}
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA)
			var stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			var stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			var thumbFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_THUMB_FACTORY);

			if(thumbFactoryInvalid)
			{
				this.createThumb();
			}

			if(thumbFactoryInvalid || stylesInvalid)
			{
				this.refreshThumbStyles();
			}

			if(dataInvalid || thumbFactoryInvalid || stateInvalid)
			{
				this.refreshEnabled();
			}

			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

			this.layout();
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
		 * <p>Calls <code>saveMeasurements()</code> to set up the
		 * <code>actualWidth</code> and <code>actualHeight</code> member
		 * variables used for layout.</p>
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 */
		protected function autoSizeIfNeeded():Boolean
		{
			var needsWidth:Boolean = this._explicitWidth !== this._explicitWidth; //isNaN
			var needsHeight:Boolean = this._explicitHeight !== this._explicitHeight; //isNaN
			var needsMinWidth:Boolean = this._explicitMinWidth !== this._explicitMinWidth; //isNaN
			var needsMinHeight:Boolean = this._explicitMinHeight !== this._explicitMinHeight; //isNaN
			if(!needsWidth && !needsHeight && !needsMinWidth && !needsMinHeight)
			{
				return false;
			}
			
			this.thumb.width = this._thumbExplicitWidth;
			this.thumb.height = this._thumbExplicitHeight;
			var measureThumb:IMeasureDisplayObject;
			if(this.thumb is IMeasureDisplayObject)
			{
				measureThumb = IMeasureDisplayObject(this.thumb);
				measureThumb.minWidth = this._thumbExplicitMinWidth;
				measureThumb.minHeight = this._thumbExplicitMinHeight;
			}
			if(this.thumb is IValidating)
			{
				IValidating(this.thumb).validate();
			}

			var range:Number = this._maximum - this._minimum;
			var adjustedPage:Number = this._page;
			if(adjustedPage === 0)
			{
				//fall back to using step!
				adjustedPage = this._step;
			}
			if(adjustedPage > range)
			{
				adjustedPage = range;
			}
			var newWidth:Number = this._explicitWidth;
			var newHeight:Number = this._explicitHeight;
			var newMinWidth:Number = this._explicitMinWidth;
			var newMinHeight:Number = this._explicitMinHeight;
			if(needsWidth)
			{
				newWidth = this.thumb.width;
				if(this._direction !== Direction.VERTICAL && adjustedPage !== 0)
				{
					newWidth *= range / adjustedPage;
				}
				newWidth += this._paddingLeft + this._paddingRight;
			}
			if(needsHeight)
			{
				newHeight = this.thumb.height;
				if(this._direction === Direction.VERTICAL && adjustedPage !== 0)
				{
					newHeight *= range / adjustedPage;
				}
				newHeight += this._paddingTop + this._paddingBottom;
			}
			if(needsMinWidth)
			{
				if(measureThumb !== null)
				{
					newMinWidth = measureThumb.minWidth;
				}
				else
				{
					newMinWidth = this.thumb.width;
				}
				if(this._direction !== Direction.VERTICAL && adjustedPage !== 0)
				{
					newMinWidth *= range / adjustedPage;
				}
				newMinWidth += this._paddingLeft + this._paddingRight;
			}
			if(needsMinHeight)
			{
				if(measureThumb !== null)
				{
					newMinHeight = measureThumb.minHeight;
				}
				else
				{
					newMinHeight = this.thumb.height;
				}
				if(this._direction === Direction.VERTICAL && adjustedPage !== 0)
				{
					newMinHeight *= range / adjustedPage;
				}
				newMinHeight += this._paddingTop + this._paddingBottom;
			}
			return this.saveMeasurements(newWidth, newHeight, newMinWidth, newMinHeight);
		}

		/**
		 * Creates and adds the <code>thumb</code> sub-component and
		 * removes the old instance, if one exists.
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 *
		 * @see #thumb
		 * @see #thumbFactory
		 * @see #style:customThumbStyleName
		 */
		protected function createThumb():void
		{
			if(this.thumb)
			{
				this.thumb.removeFromParent(true);
				this.thumb = null;
			}

			var factory:Function = this._thumbFactory != null ? this._thumbFactory : defaultThumbFactory;
			var thumbStyleName:String = this._customThumbStyleName != null ? this._customThumbStyleName : this.thumbStyleName;
			var thumb:BasicButton = BasicButton(factory());
			thumb.styleNameList.add(thumbStyleName);
			if(thumb is IFocusDisplayObject)
			{
				thumb.isFocusEnabled = false;
			}
			thumb.keepDownStateOnRollOut = true;
			thumb.addEventListener(TouchEvent.TOUCH, thumb_touchHandler);
			this.addChild(thumb);
			this.thumb = thumb;

			if(this.thumb is IFeathersControl)
			{
				IFeathersControl(this.thumb).initializeNow();
			}
			if(this.thumb is IMeasureDisplayObject)
			{
				var measureThumb:IMeasureDisplayObject = IMeasureDisplayObject(this.thumb);
				this._thumbExplicitWidth = measureThumb.explicitWidth;
				this._thumbExplicitHeight = measureThumb.explicitHeight;
				this._thumbExplicitMinWidth = measureThumb.explicitMinWidth;
				this._thumbExplicitMinHeight = measureThumb.explicitMinHeight;
			}
			else
			{
				//this is a regular display object, and we'll treat its
				//measurements as explicit when we auto-size the scroll bar
				this._thumbExplicitWidth = this.thumb.width;
				this._thumbExplicitHeight = this.thumb.height;
				this._thumbExplicitMinWidth = this._thumbExplicitWidth;
				this._thumbExplicitMinHeight = this._thumbExplicitHeight;
			}
		}

		/**
		 * @private
		 */
		protected function refreshThumbStyles():void
		{
			for(var propertyName:String in this._thumbProperties)
			{
				var propertyValue:Object = this._thumbProperties[propertyName];
				this.thumb[propertyName] = propertyValue;
			}
		}

		/**
		 * @private
		 */
		protected function refreshEnabled():void
		{
			if(this.thumb is IFeathersControl)
			{
				IFeathersControl(this.thumb).isEnabled = this._isEnabled && this._maximum > this._minimum;
			}
		}

		/**
		 * @private
		 */
		protected function layout():void
		{
			this.track.width = this.actualWidth;
			this.track.height = this.actualHeight;

			var range:Number = this._maximum - this._minimum;
			this.thumb.visible = range > 0;
			if(!this.thumb.visible)
			{
				return;
			}

			//this will auto-size the thumb, if needed
			if(this.thumb is IValidating)
			{
				IValidating(this.thumb).validate();
			}

			var contentWidth:Number = this.actualWidth - this._paddingLeft - this._paddingRight;
			var contentHeight:Number = this.actualHeight - this._paddingTop - this._paddingBottom;
			var adjustedPage:Number = this._page;
			if(this._page == 0)
			{
				adjustedPage = this._step;
			}
			else if(adjustedPage > range)
			{
				adjustedPage = range;
			}
			var valueOffset:Number = 0;
			if(this._value < this._minimum)
			{
				valueOffset = (this._minimum - this._value);
			}
			if(this._value > this._maximum)
			{
				valueOffset = (this._value - this._maximum);
			}
			if(this._direction == Direction.VERTICAL)
			{
				this.thumb.width = contentWidth;
				var thumbMinHeight:Number = this._thumbExplicitMinHeight;
				if(this.thumb is IMeasureDisplayObject)
				{
					thumbMinHeight = IMeasureDisplayObject(this.thumb).minHeight;
				}
				var thumbHeight:Number = contentHeight * adjustedPage / range;
				var heightOffset:Number = contentHeight - thumbHeight;
				if(heightOffset > thumbHeight)
				{
					heightOffset = thumbHeight;
				}
				heightOffset *=  valueOffset / (range * thumbHeight / contentHeight);
				thumbHeight -= heightOffset;
				if(thumbHeight < thumbMinHeight)
				{
					thumbHeight = thumbMinHeight;
				}
				this.thumb.height = thumbHeight;
				this.thumb.x = this._paddingLeft + (this.actualWidth - this._paddingLeft - this._paddingRight - this.thumb.width) / 2;
				var trackScrollableHeight:Number = contentHeight - this.thumb.height;
				var thumbY:Number = trackScrollableHeight * (this._value - this._minimum) / range;
				if(thumbY > trackScrollableHeight)
				{
					thumbY = trackScrollableHeight;
				}
				else if(thumbY < 0)
				{
					thumbY = 0;
				}
				this.thumb.y = this._paddingTop + thumbY;
			}
			else //horizontal
			{
				var thumbMinWidth:Number = this._thumbExplicitMinWidth;
				if(this.thumb is IMeasureDisplayObject)
				{
					thumbMinWidth = IMeasureDisplayObject(this.thumb).minWidth;
				}
				var thumbWidth:Number = contentWidth * adjustedPage / range;
				var widthOffset:Number = contentWidth - thumbWidth;
				if(widthOffset > thumbWidth)
				{
					widthOffset = thumbWidth;
				}
				widthOffset *= valueOffset / (range * thumbWidth / contentWidth);
				thumbWidth -= widthOffset;
				if(thumbWidth < thumbMinWidth)
				{
					thumbWidth = thumbMinWidth;
				}
				this.thumb.width = thumbWidth;
				this.thumb.height = contentHeight;
				var trackScrollableWidth:Number = contentWidth - this.thumb.width;
				var thumbX:Number = trackScrollableWidth * (this._value - this._minimum) / range;
				if(thumbX > trackScrollableWidth)
				{
					thumbX = trackScrollableWidth;
				}
				else if(thumbX < 0)
				{
					thumbX = 0;
				}
				this.thumb.x = this._paddingLeft + thumbX;
				this.thumb.y = this._paddingTop + (this.actualHeight - this._paddingTop - this._paddingBottom - this.thumb.height) / 2;
			}

			//final validation to avoid juggler next frame issues
			if(this.thumb is IValidating)
			{
				IValidating(this.thumb).validate();
			}
		}

		/**
		 * @private
		 */
		protected function locationToValue(location:Point):Number
		{
			var percentage:Number = 0;
			if(this._direction == Direction.VERTICAL)
			{
				var trackScrollableHeight:Number = this.actualHeight - this.thumb.height - this._paddingTop - this._paddingBottom;
				if(trackScrollableHeight > 0)
				{
					var yOffset:Number = location.y - this._touchStartY - this._paddingTop;
					var yPosition:Number = Math.min(Math.max(0, this._thumbStartY + yOffset), trackScrollableHeight);
					percentage = yPosition / trackScrollableHeight;
				}
			}
			else //horizontal
			{
				var trackScrollableWidth:Number = this.actualWidth - this.thumb.width - this._paddingLeft - this._paddingRight;
				if(trackScrollableWidth > 0)
				{
					var xOffset:Number = location.x - this._touchStartX - this._paddingLeft;
					var xPosition:Number = Math.min(Math.max(0, this._thumbStartX + xOffset), trackScrollableWidth);
					percentage = xPosition / trackScrollableWidth;
				}
			}

			return this._minimum + percentage * (this._maximum - this._minimum);
		}

		/**
		 * @private
		 */
		protected function adjustPage():void
		{
			var range:Number = this._maximum - this._minimum;
			var adjustedPage:Number = this._page;
			if(adjustedPage === 0)
			{
				adjustedPage = this._step;
			}
			if(adjustedPage > range)
			{
				adjustedPage = range;
			}
			if(this._touchValue < this._value)
			{
				var newValue:Number = Math.max(this._touchValue, this._value - adjustedPage);
				if(this._step != 0 && newValue != this._maximum && newValue != this._minimum)
				{
					newValue = roundToNearest(newValue, this._step);
				}
				this.value = newValue;
			}
			else if(this._touchValue > this._value)
			{
				newValue = Math.min(this._touchValue, this._value + adjustedPage);
				if(this._step != 0 && newValue != this._maximum && newValue != this._minimum)
				{
					newValue = roundToNearest(newValue, this._step);
				}
				this.value = newValue;
			}
		}

		/**
		 * @private
		 */
		protected function startRepeatTimer(action:Function):void
		{
			this.currentRepeatAction = action;
			if(this._repeatDelay > 0)
			{
				if(!this._repeatTimer)
				{
					this._repeatTimer = new Timer(this._repeatDelay * 1000);
					this._repeatTimer.addEventListener(TimerEvent.TIMER, repeatTimer_timerHandler);
				}
				else
				{
					this._repeatTimer.reset();
					this._repeatTimer.delay = this._repeatDelay * 1000;
				}
				this._repeatTimer.start();
			}
		}

		/**
		 * @private
		 */
		protected function thumbProperties_onChange(proxy:PropertyProxy, name:Object):void
		{
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected function removedFromStageHandler(event:Event):void
		{
			this._touchPointID = -1;
			if(this._repeatTimer)
			{
				this._repeatTimer.stop();
			}
		}

		/**
		 * @private
		 */
		protected function track_touchHandler(event:TouchEvent):void
		{
			if(!this._isEnabled)
			{
				this._touchPointID = -1;
				return;
			}

			if(this._touchPointID >= 0)
			{
				var touch:Touch = event.getTouch(this.track, TouchPhase.ENDED, this._touchPointID);
				if(!touch)
				{
					return;
				}
				this._touchPointID = -1;
				this._repeatTimer.stop();
			}
			else
			{
				touch = event.getTouch(this.track, TouchPhase.BEGAN);
				if(!touch)
				{
					return;
				}
				this._touchPointID = touch.id;
				touch.getLocation(this, HELPER_POINT);
				this._touchStartX = HELPER_POINT.x;
				this._touchStartY = HELPER_POINT.y;
				this._thumbStartX = HELPER_POINT.x;
				this._thumbStartY = HELPER_POINT.y;
				this._touchValue = this.locationToValue(HELPER_POINT);
				this.adjustPage();
				this.startRepeatTimer(this.adjustPage);
			}
		}

		/**
		 * @private
		 */
		protected function thumb_touchHandler(event:TouchEvent):void
		{
			if(!this._isEnabled)
			{
				return;
			}

			if(this._touchPointID >= 0)
			{
				var touch:Touch = event.getTouch(this.thumb, null, this._touchPointID);
				if(!touch)
				{
					return;
				}

				if(touch.phase == TouchPhase.MOVED)
				{
					touch.getLocation(this, HELPER_POINT);
					var newValue:Number = this.locationToValue(HELPER_POINT);
					if(this._step != 0 && newValue != this._maximum && newValue != this._minimum)
					{
						newValue = roundToNearest(newValue, this._step);
					}
					this.value = newValue;
				}
				else if(touch.phase == TouchPhase.ENDED)
				{
					this._touchPointID = -1;
					this.isDragging = false;
					if(!this.liveDragging)
					{
						this.dispatchEventWith(Event.CHANGE);
					}
					this.dispatchEventWith(FeathersEventType.END_INTERACTION);
				}
			}
			else
			{
				touch = event.getTouch(this.thumb, TouchPhase.BEGAN);
				if(!touch)
				{
					return;
				}
				touch.getLocation(this, HELPER_POINT);
				this._touchPointID = touch.id;
				this._thumbStartX = this.thumb.x;
				this._thumbStartY = this.thumb.y;
				this._touchStartX = HELPER_POINT.x;
				this._touchStartY = HELPER_POINT.y;
				this.isDragging = true;
				this.dispatchEventWith(FeathersEventType.BEGIN_INTERACTION);
			}
		}

		/**
		 * @private
		 */
		protected function repeatTimer_timerHandler(event:TimerEvent):void
		{
			if(this._repeatTimer.currentCount < 5)
			{
				return;
			}
			this.currentRepeatAction();
		}
	}
}
