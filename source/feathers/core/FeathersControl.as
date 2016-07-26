/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core
{
	import feathers.controls.text.BitmapFontTextRenderer;
	import feathers.controls.text.StageTextTextEditor;
	import feathers.events.FeathersEventType;
	import feathers.layout.ILayoutData;
	import feathers.layout.ILayoutDisplayObject;
	import feathers.skins.IStyleProvider;
	import feathers.utils.display.getDisplayObjectDepthFromStage;
	import feathers.utils.display.stageToStarling;

	import flash.errors.IllegalOperationError;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.MatrixUtil;
	import starling.utils.Pool;

	/**
	 * Dispatched after <code>initialize()</code> has been called, but before
	 * the first time that <code>draw()</code> has been called.
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
	 * @eventType feathers.events.FeathersEventType.INITIALIZE
	 */
	[Event(name="initialize",type="starling.events.Event")]

	/**
	 * Dispatched after the component has validated for the first time. Both
	 * <code>initialize()</code> and <code>draw()</code> will have been called,
	 * and all children will have been created.
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
	 * @eventType feathers.events.FeathersEventType.CREATION_COMPLETE
	 */
	[Event(name="creationComplete",type="starling.events.Event")]

	/**
	 * Dispatched when the width or height of the control changes.
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
	 * @eventType starling.events.Event.RESIZE
	 */
	[Event(name="resize",type="starling.events.Event")]

	/**
	 * Base class for all UI controls. Implements invalidation and sets up some
	 * basic template functions like <code>initialize()</code> and
	 * <code>draw()</code>.
	 *
	 * <p>This is a base class for Feathers components that isn't meant to be
	 * instantiated directly. It should only be subclassed. For a simple
	 * component that will automatically size itself based on its children,
	 * and with optional support for layouts, see <code>LayoutGroup</code>.</p>
	 *
	 * @see feathers.controls.LayoutGroup
	 */
	public class FeathersControl extends Sprite implements IFeathersControl, ILayoutDisplayObject
	{
		/**
		 * @private
		 */
		private static const HELPER_MATRIX:Matrix = new Matrix();

		/**
		 * @private
		 */
		private static const HELPER_POINT:Point = new Point();

		/**
		 * Flag to indicate that everything is invalid and should be redrawn.
		 */
		public static const INVALIDATION_FLAG_ALL:String = "all";

		/**
		 * Invalidation flag to indicate that the state has changed. Used by
		 * <code>isEnabled</code>, but may be used for other control states too.
		 *
		 * @see #isEnabled
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
		 * Invalidation flag to indicate that the skin of the UI control has changed.
		 */
		public static const INVALIDATION_FLAG_SKIN:String = "skin";

		/**
		 * Invalidation flag to indicate that the layout of the UI control has
		 * changed.
		 */
		public static const INVALIDATION_FLAG_LAYOUT:String = "layout";

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
		 * Invalidation flag to indicate that the focus of the UI control has
		 * changed.
		 */
		public static const INVALIDATION_FLAG_FOCUS:String = "focus";

		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_TEXT_RENDERER:String = "textRenderer";

		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_TEXT_EDITOR:String = "textEditor";

		/**
		 * @private
		 */
		protected static const ILLEGAL_WIDTH_ERROR:String = "A component's width cannot be NaN.";

		/**
		 * @private
		 */
		protected static const ILLEGAL_HEIGHT_ERROR:String = "A component's height cannot be NaN.";

		/**
		 * @private
		 */
		protected static const ABSTRACT_CLASS_ERROR:String = "FeathersControl is an abstract class. For a lightweight Feathers wrapper, use feathers.controls.LayoutGroup.";

		/**
		 * A function used by all UI controls that support text renderers to
		 * create an ITextRenderer instance. You may replace the default
		 * function with your own, if you prefer not to use the
		 * BitmapFontTextRenderer.
		 *
		 * <p>The function is expected to have the following signature:</p>
		 * <pre>function():ITextRenderer</pre>
		 *
		 * @see ../../../help/text-renderers.html Introduction to Feathers text renderers
		 * @see feathers.core.ITextRenderer
		 */
		public static var defaultTextRendererFactory:Function = function():ITextRenderer
		{
			return new BitmapFontTextRenderer();
		}

		/**
		 * A function used by all UI controls that support text editor to
		 * create an <code>ITextEditor</code> instance. You may replace the
		 * default function with your own, if you prefer not to use the
		 * <code>StageTextTextEditor</code>.
		 *
		 * <p>The function is expected to have the following signature:</p>
		 * <pre>function():ITextEditor</pre>
		 *
		 * @see ../../../help/text-editors.html Introduction to Feathers text editors
		 * @see feathers.core.ITextEditor
		 */
		public static var defaultTextEditorFactory:Function = function():ITextEditor
		{
			return new StageTextTextEditor();
		}

		/**
		 * Constructor.
		 */
		public function FeathersControl()
		{
			super();
			if(Object(this).constructor == FeathersControl)
			{
				throw new Error(ABSTRACT_CLASS_ERROR);
			}
			this._styleProvider = this.defaultStyleProvider;
			this.addEventListener(Event.ADDED_TO_STAGE, feathersControl_addedToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, feathersControl_removedFromStageHandler);
		}

		/**
		 * @private
		 */
		protected var _validationQueue:ValidationQueue;

		/**
		 * The concatenated <code>styleNameList</code>, with values separated
		 * by spaces. Style names are somewhat similar to classes in CSS
		 * selectors. In Feathers, they are a non-unique identifier that can
		 * differentiate multiple styles of the same type of UI control. A
		 * single control may have many style names, and many controls can share
		 * a single style name. A <a target="_top" href="../../../help/themes.html">theme</a>
		 * or another skinning mechanism may use style names to provide a
		 * variety of visual appearances for a single component class.
		 *
		 * <p>In general, the <code>styleName</code> property should not be set
		 * directly on a Feathers component. You should add and remove style
		 * names from the <code>styleNameList</code> property instead.</p>
		 *
		 * @default ""
		 *
		 * @see #styleNameList
		 * @see ../../../help/themes.html Introduction the Feathers themes
		 * @see ../../../help/custom-themes.html Creating custom Feathers themes
		 */
		public function get styleName():String
		{
			return this._styleNameList.value;
		}

		/**
		 * @private
		 */
		public function set styleName(value:String):void
		{
			this._styleNameList.value = value;
		}

		/**
		 * @private
		 */
		protected var _styleNameList:TokenList = new TokenList();

		/**
		 * Contains a list of all "styles" assigned to this control. Names are
		 * like classes in CSS selectors. They are a non-unique identifier that
		 * can differentiate multiple styles of the same type of UI control. A
		 * single control may have many names, and many controls can share a
		 * single name. A <a target="_top" href="../../../help/themes.html">theme</a>
		 * or another skinning mechanism may use style names to provide a
		 * variety of visual appearances for a single component class.
		 *
		 * <p>Names may be added, removed, or toggled on the
		 * <code>styleNameList</code>. Names cannot contain spaces.</p>
		 *
		 * <p>In the following example, a name is added to the name list:</p>
		 *
		 * <listing version="3.0">
		 * control.styleNameList.add( "custom-component-name" );</listing>
		 *
		 * @see #styleName
		 * @see ../../../help/themes.html Introduction to Feathers themes
		 * @see ../../../help/custom-themes.html Creating custom Feathers themes
		 */
		public function get styleNameList():TokenList
		{
			return this._styleNameList;
		}

		/**
		 * @private
		 */
		protected var _styleProvider:IStyleProvider;

		/**
		 * When a component initializes, a style provider may be used to set
		 * properties that affect the component's visual appearance.
		 *
		 * <p>You can set or replace an existing style provider at any time
		 * before a component initializes without immediately affecting the
		 * component's visual appearance. After the component initializes, the
		 * style provider may still be changed, but any properties that
		 * were set by the previous style provider will not be reset to their
		 * default values.</p>
		 *
		 * @see #styleName
		 * @see #styleNameList
		 * @see ../../../help/themes.html Introduction to Feathers themes
		 */
		public function get styleProvider():IStyleProvider
		{
			return this._styleProvider;
		}

		/**
		 * @private
		 */
		public function set styleProvider(value:IStyleProvider):void
		{
			this._styleProvider = value;
			if(this._styleProvider && this.isInitialized)
			{
				this._styleProvider.applyStyles(this);
			}
		}

		/**
		 * When the <code>FeathersControl</code> constructor is called, the
		 * <code>globalStyleProvider</code> property is set to this value. May be
		 * <code>null</code>.
		 *
		 * <p>Typically, a subclass of <code>FeathersControl</code> will
		 * override this function to return its static <code>globalStyleProvider</code>
		 * value. For instance, <code>feathers.controls.Button</code> overrides
		 * this function, and its implementation looks like this:</p>
		 *
		 * <listing version="3.0">
		 * override protected function get defaultStyleProvider():IStyleProvider
		 * {
		 *     return Button.globalStyleProvider;
		 * }</listing>
		 *
		 * @see #styleProvider
		 */
		protected function get defaultStyleProvider():IStyleProvider
		{
			return null;
		}

		/**
		 * @private
		 */
		protected var _isQuickHitAreaEnabled:Boolean = false;

		/**
		 * Similar to <code>mouseChildren</code> on the classic display list. If
		 * <code>true</code>, children cannot dispatch touch events, but hit
		 * tests will be much faster. Easier than overriding
		 * <code>hitTest()</code>.
		 *
		 * <p>In the following example, the quick hit area is enabled:</p>
		 *
		 * <listing version="3.0">
		 * control.isQuickHitAreaEnabled = true;</listing>
		 *
		 * @default false
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
		 */
		protected var _isInitializing:Boolean = false;

		/**
		 * @private
		 */
		protected var _isInitialized:Boolean = false;

		/**
		 * Determines if the component has been initialized yet. The
		 * <code>initialize()</code> function is called one time only, when the
		 * Feathers UI control is added to the display list for the first time.
		 *
		 * <p>In the following example, we check if the component is initialized
		 * or not, and we listen for an event if it isn't:</p>
		 *
		 * <listing version="3.0">
		 * if( !control.isInitialized )
		 * {
		 *     control.addEventListener( FeathersEventType.INITIALIZE, initializeHandler );
		 * }</listing>
		 *
		 * @see #event:initialize
		 * @see #isCreated
		 */
		public function get isInitialized():Boolean
		{
			return this._isInitialized;
		}

		/**
		 * @private
		 * A flag that indicates that everything is invalid. If true, no other
		 * flags will need to be tracked.
		 */
		protected var _isAllInvalid:Boolean = false;

		/**
		 * @private
		 */
		protected var _invalidationFlags:Object = {};

		/**
		 * @private
		 */
		protected var _delayedInvalidationFlags:Object = {};

		/**
		 * @private
		 */
		protected var _isEnabled:Boolean = true;

		/**
		 * Indicates whether the control is interactive or not.
		 *
		 * <p>In the following example, the control is disabled:</p>
		 *
		 * <listing version="3.0">
		 * control.isEnabled = false;</listing>
		 *
		 * @default true
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
		protected var _explicitWidth:Number = NaN;

		/**
		 * The width value explicitly set by passing a value to the
		 * <code>width</code> setter or to the <code>setSize()</code> method.
		 */
		public function get explicitWidth():Number
		{
			return this._explicitWidth;
		}

		/**
		 * The final width value that should be used for layout. If the width
		 * has been explicitly set, then that value is used. If not, the actual
		 * width will be calculated automatically. Each component has different
		 * automatic sizing behavior, but it's usually based on the component's
		 * skin or content, including text or subcomponents.
		 */
		protected var actualWidth:Number = 0;

		/**
		 * @private
		 * The <code>actualWidth</code> value that accounts for
		 * <code>scaleX</code>. Not intended to be used for layout since layout
		 * uses unscaled values. This is the value exposed externally through
		 * the <code>width</code> getter.
		 */
		protected var scaledActualWidth:Number = 0;

		/**
		 * The width of the component, in pixels. This could be a value that was
		 * set explicitly, or the component will automatically resize if no
		 * explicit width value is provided. Each component has a different
		 * automatic sizing behavior, but it's usually based on the component's
		 * skin or content, including text or subcomponents.
		 *
		 * <p><strong>Note:</strong> Values of the <code>width</code> and
		 * <code>height</code> properties may not be accurate until after
		 * validation. If you are seeing <code>width</code> or <code>height</code>
		 * values of <code>0</code>, but you can see something on the screen and
		 * know that the value should be larger, it may be because you asked for
		 * the dimensions before the component had validated. Call
		 * <code>validate()</code> to tell the component to immediately redraw
		 * and calculate an accurate values for the dimensions.</p>
		 *
		 * <p>In the following example, the width is set to 120 pixels:</p>
		 *
		 * <listing version="3.0">
		 * control.width = 120;</listing>
		 *
		 * <p>In the following example, the width is cleared so that the
		 * component can automatically measure its own width:</p>
		 *
		 * <listing version="3.0">
		 * control.width = NaN;</listing>
		 *
		 * @see feathers.core.FeathersControl#setSize()
		 * @see feathers.core.FeathersControl#validate()
		 */
		override public function get width():Number
		{
			return this.scaledActualWidth;
		}

		/**
		 * @private
		 */
		override public function set width(value:Number):void
		{
			var valueIsNaN:Boolean = value !== value; //isNaN
			if(valueIsNaN && this._explicitWidth !== this._explicitWidth)
			{
				return;
			}
			if(this.scaleX !== 1)
			{
				value /= this.scaleX;
			}
			if(this._explicitWidth == value)
			{
				return;
			}
			this._explicitWidth = value;
			if(valueIsNaN)
			{
				this.actualWidth = this.scaledActualWidth = 0;
				this.invalidate(INVALIDATION_FLAG_SIZE);
			}
			else
			{
				var result:Boolean = this.saveMeasurements(value, this.actualHeight, this.actualMinWidth, this.actualMinHeight);
				if(result)
				{
					this.invalidate(INVALIDATION_FLAG_SIZE);
				}
			}
		}

		/**
		 * @private
		 */
		protected var _explicitHeight:Number = NaN;

		/**
		 * The height value explicitly set by passing a value to the
		 * <code>height</code> setter or by calling the <code>setSize()</code>
		 * function.
		 */
		public function get explicitHeight():Number
		{
			return this._explicitHeight;
		}

		/**
		 * The final height value that should be used for layout. If the height
		 * has been explicitly set, then that value is used. If not, the actual
		 * height will be calculated automatically. Each component has different
		 * automatic sizing behavior, but it's usually based on the component's
		 * skin or content, including text or subcomponents.
		 */
		protected var actualHeight:Number = 0;

		/**
		 * @private
		 * The <code>actualHeight</code> value that accounts for
		 * <code>scaleY</code>. Not intended to be used for layout since layout
		 * uses unscaled values. This is the value exposed externally through
		 * the <code>height</code> getter.
		 */
		protected var scaledActualHeight:Number = 0;

		/**
		 * The height of the component, in pixels. This could be a value that
		 * was set explicitly, or the component will automatically resize if no
		 * explicit height value is provided. Each component has a different
		 * automatic sizing behavior, but it's usually based on the component's
		 * skin or content, including text or subcomponents.
		 *
		 * <p><strong>Note:</strong> Values of the <code>width</code> and
		 * <code>height</code> properties may not be accurate until after
		 * validation. If you are seeing <code>width</code> or <code>height</code>
		 * values of <code>0</code>, but you can see something on the screen and
		 * know that the value should be larger, it may be because you asked for
		 * the dimensions before the component had validated. Call
		 * <code>validate()</code> to tell the component to immediately redraw
		 * and calculate an accurate values for the dimensions.</p>
		 *
		 * <p>In the following example, the height is set to 120 pixels:</p>
		 *
		 * <listing version="3.0">
		 * control.height = 120;</listing>
		 *
		 * <p>In the following example, the height is cleared so that the
		 * component can automatically measure its own height:</p>
		 *
		 * <listing version="3.0">
		 * control.height = NaN;</listing>
		 *
		 * @see feathers.core.FeathersControl#setSize()
		 * @see feathers.core.FeathersControl#validate()
		 */
		override public function get height():Number
		{
			return this.scaledActualHeight;
		}

		/**
		 * @private
		 */
		override public function set height(value:Number):void
		{
			var valueIsNaN:Boolean = value !== value; //isNaN
			if(valueIsNaN && this._explicitHeight !== this._explicitHeight)
			{
				return;
			}
			if(this.scaleY !== 1)
			{
				value /= this.scaleY;
			}
			if(this._explicitHeight == value)
			{
				return;
			}
			this._explicitHeight = value;
			if(valueIsNaN)
			{
				this.actualHeight = this.scaledActualHeight = 0;
				this.invalidate(INVALIDATION_FLAG_SIZE);
			}
			else
			{
				var result:Boolean = this.saveMeasurements(this.actualWidth, value, this.actualMinWidth, this.actualMinHeight);
				if(result)
				{
					this.invalidate(INVALIDATION_FLAG_SIZE);
				}
			}
		}

		/**
		 * @private
		 */
		protected var _minTouchWidth:Number = 0;

		/**
		 * If using <code>isQuickHitAreaEnabled</code>, and the hit area's
		 * width is smaller than this value, it will be expanded.
		 *
		 * <p>In the following example, the minimum width of the hit area is
		 * set to 120 pixels:</p>
		 *
		 * <listing version="3.0">
		 * control.minTouchWidth = 120;</listing>
		 *
		 * @default 0
		 */
		public function get minTouchWidth():Number
		{
			return this._minTouchWidth;
		}

		/**
		 * @private
		 */
		public function set minTouchWidth(value:Number):void
		{
			if(this._minTouchWidth == value)
			{
				return;
			}
			this._minTouchWidth = value;
			this.refreshHitAreaX();
		}

		/**
		 * @private
		 */
		protected var _minTouchHeight:Number = 0;

		/**
		 * If using <code>isQuickHitAreaEnabled</code>, and the hit area's
		 * height is smaller than this value, it will be expanded.
		 *
		 * <p>In the following example, the minimum height of the hit area is
		 * set to 120 pixels:</p>
		 *
		 * <listing version="3.0">
		 * control.minTouchHeight = 120;</listing>
		 *
		 * @default 0
		 */
		public function get minTouchHeight():Number
		{
			return this._minTouchHeight;
		}

		/**
		 * @private
		 */
		public function set minTouchHeight(value:Number):void
		{
			if(this._minTouchHeight == value)
			{
				return;
			}
			this._minTouchHeight = value;
			this.refreshHitAreaY();
		}

		/**
		 * @private
		 */
		protected var _explicitMinWidth:Number = NaN;

		/**
		 * The minimum width value explicitly set by passing a value to the
		 * <code>minWidth</code> setter.
		 * 
		 * <p>If no value has been passed to the <code>minWidth</code> setter,
		 * this property returns <code>NaN</code>.</p>
		 */
		public function get explicitMinWidth():Number
		{
			return this._explicitMinWidth;
		}

		/**
		 * The final minimum width value that should be used for layout. If the
		 * minimum width has been explicitly set, then that value is used. If
		 * not, the actual minimum width will be calculated automatically. Each
		 * component has different automatic sizing behavior, but it's usually
		 * based on the component's skin or content, including text or
		 * subcomponents.
		 */
		protected var actualMinWidth:Number = 0;

		/**
		 * @private
		 * The <code>actualMinWidth</code> value that accounts for
		 * <code>scaleX</code>. Not intended to be used for layout since layout
		 * uses unscaled values. This is the value exposed externally through
		 * the <code>minWidth</code> getter.
		 */
		protected var scaledActualMinWidth:Number = 0;

		/**
		 * The minimum recommended width to be used for self-measurement and,
		 * optionally, by any code that is resizing this component. This value
		 * is not strictly enforced in all cases. An explicit width value that
		 * is smaller than <code>minWidth</code> may be set and will not be
		 * affected by the minimum.
		 *
		 * <p>In the following example, the minimum width of the control is
		 * set to 120 pixels:</p>
		 *
		 * <listing version="3.0">
		 * control.minWidth = 120;</listing>
		 *
		 * @default 0
		 */
		public function get minWidth():Number
		{
			return this.scaledActualMinWidth;
		}

		/**
		 * @private
		 */
		public function set minWidth(value:Number):void
		{
			var valueIsNaN:Boolean = value !== value; //isNaN
			if(valueIsNaN && this._explicitMinWidth !== this._explicitMinWidth)
			{
				return;
			}
			if(this.scaleX !== 1)
			{
				value /= this.scaleX;
			}
			if(this._explicitMinWidth == value)
			{
				return;
			}
			var oldValue:Number = this._explicitMinWidth;
			this._explicitMinWidth = value;
			if(valueIsNaN)
			{
				this.actualMinWidth = this.scaledActualMinWidth = 0;
				this.invalidate(INVALIDATION_FLAG_SIZE);
			}
			else
			{
				this.saveMeasurements(this.actualWidth, this.actualHeight, value, this.actualMinHeight);
				if(this._explicitWidth !== this._explicitWidth &&
					(this.actualWidth < value || this.actualWidth === oldValue))
				{
					//only invalidate if this change might affect the width
					//because everything else was handled in saveMeasurements()
					this.invalidate(INVALIDATION_FLAG_SIZE);
				}
			}
		}

		/**
		 * @private
		 */
		protected var _explicitMinHeight:Number = NaN;

		/**
		 * The minimum height value explicitly set by passing a value to the
		 * <code>minHeight</code> setter.
		 *
		 * <p>If no value has been passed to the <code>minHeight</code> setter,
		 * this property returns <code>NaN</code>.</p>
		 */
		public function get explicitMinHeight():Number
		{
			return this._explicitMinHeight;
		}

		/**
		 * The final minimum height value that should be used for layout. If the
		 * minimum height has been explicitly set, then that value is used. If
		 * not, the actual minimum height will be calculated automatically. Each
		 * component has different automatic sizing behavior, but it's usually
		 * based on the component's skin or content, including text or
		 * subcomponents.
		 */
		protected var actualMinHeight:Number = 0;

		/**
		 * @private
		 * The <code>actuaMinHeight</code> value that accounts for
		 * <code>scaleY</code>. Not intended to be used for layout since layout
		 * uses unscaled values. This is the value exposed externally through
		 * the <code>minHeight</code> getter.
		 */
		protected var scaledActualMinHeight:Number = 0;

		/**
		 * The minimum recommended height to be used for self-measurement and,
		 * optionally, by any code that is resizing this component. This value
		 * is not strictly enforced in all cases. An explicit height value that
		 * is smaller than <code>minHeight</code> may be set and will not be
		 * affected by the minimum.
		 *
		 * <p>In the following example, the minimum height of the control is
		 * set to 120 pixels:</p>
		 *
		 * <listing version="3.0">
		 * control.minHeight = 120;</listing>
		 *
		 * @default 0
		 */
		public function get minHeight():Number
		{
			return this.scaledActualMinHeight;
		}

		/**
		 * @private
		 */
		public function set minHeight(value:Number):void
		{
			var valueIsNaN:Boolean = value !== value; //isNaN
			if(valueIsNaN && this._explicitMinHeight !== this._explicitMinHeight)
			{
				return;
			}
			if(this.scaleY !== 1)
			{
				value /= this.scaleY;
			}
			if(this._explicitMinHeight == value)
			{
				return;
			}
			var oldValue:Number = this._explicitMinHeight;
			this._explicitMinHeight = value;
			if(valueIsNaN)
			{
				this.actualMinHeight = this.scaledActualMinHeight = 0;
				this.invalidate(INVALIDATION_FLAG_SIZE);
			}
			else
			{
				this.saveMeasurements(this.actualWidth, this.actualHeight, this.actualMinWidth, value);
				if(this._explicitHeight !== this._explicitHeight && //isNaN
					(this.actualHeight < value || this.actualHeight === oldValue))
				{
					//only invalidate if this change might affect the height
					//because everything else was handled in saveMeasurements()
					this.invalidate(INVALIDATION_FLAG_SIZE);
				}
			}
		}

		/**
		 * @private
		 */
		protected var _explicitMaxWidth:Number = Number.POSITIVE_INFINITY;

		/**
		 * The maximum width value explicitly set by passing a value to the
		 * <code>maxWidth</code> setter.
		 *
		 * <p>If no value has been passed to the <code>maxWidth</code> setter,
		 * this property returns <code>NaN</code>.</p>
		 */
		public function get explicitMaxWidth():Number
		{
			return this._explicitMaxWidth;
		}

		/**
		 * The maximum recommended width to be used for self-measurement and,
		 * optionally, by any code that is resizing this component. This value
		 * is not strictly enforced in all cases. An explicit width value that
		 * is larger than <code>maxWidth</code> may be set and will not be
		 * affected by the maximum.
		 *
		 * <p>In the following example, the maximum width of the control is
		 * set to 120 pixels:</p>
		 *
		 * <listing version="3.0">
		 * control.maxWidth = 120;</listing>
		 *
		 * @default Number.POSITIVE_INFINITY
		 */
		public function get maxWidth():Number
		{
			return this._explicitMaxWidth;
		}

		/**
		 * @private
		 */
		public function set maxWidth(value:Number):void
		{
			if(value < 0)
			{
				value = 0;
			}
			if(this._explicitMaxWidth == value)
			{
				return;
			}
			if(value !== value) //isNaN
			{
				throw new ArgumentError("maxWidth cannot be NaN");
			}
			var oldValue:Number = this._explicitMaxWidth;
			this._explicitMaxWidth = value;
			if(this._explicitWidth !== this._explicitWidth && //isNaN
				(this.actualWidth > value || this.actualWidth === oldValue))
			{
				//only invalidate if this change might affect the width
				this.invalidate(INVALIDATION_FLAG_SIZE);
			}
		}

		/**
		 * @private
		 */
		protected var _explicitMaxHeight:Number = Number.POSITIVE_INFINITY;

		/**
		 * The maximum height value explicitly set by passing a value to the
		 * <code>maxHeight</code> setter.
		 *
		 * <p>If no value has been passed to the <code>maxHeight</code> setter,
		 * this property returns <code>NaN</code>.</p>
		 */
		public function get explicitMaxHeight():Number
		{
			return this._explicitMaxHeight;
		}

		/**
		 * The maximum recommended height to be used for self-measurement and,
		 * optionally, by any code that is resizing this component. This value
		 * is not strictly enforced in all cases. An explicit height value that
		 * is larger than <code>maxHeight</code> may be set and will not be
		 * affected by the maximum.
		 *
		 * <p>In the following example, the maximum width of the control is
		 * set to 120 pixels:</p>
		 *
		 * <listing version="3.0">
		 * control.maxWidth = 120;</listing>
		 *
		 * @default Number.POSITIVE_INFINITY
		 */
		public function get maxHeight():Number
		{
			return this._explicitMaxHeight;
		}

		/**
		 * @private
		 */
		public function set maxHeight(value:Number):void
		{
			if(value < 0)
			{
				value = 0;
			}
			if(this._explicitMaxHeight == value)
			{
				return;
			}
			if(value !== value) //isNaN
			{
				throw new ArgumentError("maxHeight cannot be NaN");
			}
			var oldValue:Number = this._explicitMaxHeight;
			this._explicitMaxHeight = value;
			if(this._explicitHeight !== this._explicitHeight && //isNaN
				(this.actualHeight > value || this.actualHeight === oldValue))
			{
				//only invalidate if this change might affect the width
				this.invalidate(INVALIDATION_FLAG_SIZE);
			}
		}

		/**
		 * @private
		 */
		override public function set scaleX(value:Number):void
		{
			super.scaleX = value;
			this.saveMeasurements(this.actualWidth, this.actualHeight, this.actualMinWidth, this.actualMinHeight);
		}

		/**
		 * @private
		 */
		override public function set scaleY(value:Number):void
		{
			super.scaleY = value;
			this.saveMeasurements(this.actualWidth, this.actualHeight, this.actualMinWidth, this.actualMinHeight);
		}

		/**
		 * @private
		 */
		protected var _includeInLayout:Boolean = true;

		/**
		 * @inheritDoc
		 *
		 * @default true
		 */
		public function get includeInLayout():Boolean
		{
			return this._includeInLayout;
		}

		/**
		 * @private
		 */
		public function set includeInLayout(value:Boolean):void
		{
			if(this._includeInLayout == value)
			{
				return;
			}
			this._includeInLayout = value;
			this.dispatchEventWith(FeathersEventType.LAYOUT_DATA_CHANGE);
		}

		/**
		 * @private
		 */
		protected var _layoutData:ILayoutData;

		/**
		 * @inheritDoc
		 *
		 * @default null
		 */
		public function get layoutData():ILayoutData
		{
			return this._layoutData;
		}

		/**
		 * @private
		 */
		public function set layoutData(value:ILayoutData):void
		{
			if(this._layoutData == value)
			{
				return;
			}
			if(this._layoutData)
			{
				this._layoutData.removeEventListener(Event.CHANGE, layoutData_changeHandler);
			}
			this._layoutData = value;
			if(this._layoutData)
			{
				this._layoutData.addEventListener(Event.CHANGE, layoutData_changeHandler);
			}
			this.dispatchEventWith(FeathersEventType.LAYOUT_DATA_CHANGE);
		}

		/**
		 * @private
		 */
		protected var _toolTip:String;

		/**
		 * Text to display in a tool tip to when hovering over this component,
		 * if the <code>ToolTipManager</code> is enabled.
		 * 
		 * @default null
		 *
		 * @see ../../../help/tool-tips.html Tool tips in Feathers
		 * @see feathers.core.ToolTipManager
		 */
		public function get toolTip():String
		{
			return this._toolTip;
		}

		/**
		 * @private
		 */
		public function set toolTip(value:String):void
		{
			this._toolTip = value;
		}

		/**
		 * @private
		 */
		protected var _focusManager:IFocusManager;

		/**
		 * <p>The implementation of this property is provided for convenience,
		 * but it cannot be used unless a subclass implements the
		 * <code>IFocusDisplayObject</code> interface.</p>
		 * 
		 * @copy feathers.core.IFocusDisplayObject#focusManager
		 *
		 * @default null
		 *
		 * @see feathers.core.IFocusDisplayObject
		 */
		public function get focusManager():IFocusManager
		{
			return this._focusManager;
		}

		/**
		 * @private
		 */
		public function set focusManager(value:IFocusManager):void
		{
			if(!(this is IFocusDisplayObject))
			{
				throw new IllegalOperationError("Cannot pass a focus manager to a component that does not implement feathers.core.IFocusDisplayObject");
			}
			if(this._focusManager == value)
			{
				return;
			}
			this._focusManager = value;
			if(this._focusManager)
			{
				this.addEventListener(FeathersEventType.FOCUS_IN, focusInHandler);
				this.addEventListener(FeathersEventType.FOCUS_OUT, focusOutHandler);
			}
			else
			{
				this.removeEventListener(FeathersEventType.FOCUS_IN, focusInHandler);
				this.removeEventListener(FeathersEventType.FOCUS_OUT, focusOutHandler);
			}
		}

		/**
		 * @private
		 */
		protected var _focusOwner:IFocusDisplayObject;

		/**
		 * <p>The implementation of this property is provided for convenience,
		 * but it cannot be used unless a subclass implements the
		 * <code>IFocusDisplayObject</code> interface.</p>
		 * 
		 * @copy feathers.core.IFocusDisplayObject#focusOwner
		 *
		 * @default null
		 * 
		 * @see feathers.core.IFocusDisplayObject
		 */
		public function get focusOwner():IFocusDisplayObject
		{
			return this._focusOwner;
		}

		/**
		 * @private
		 */
		public function set focusOwner(value:IFocusDisplayObject):void
		{
			this._focusOwner = value;
		}

		/**
		 * @private
		 */
		protected var _isFocusEnabled:Boolean = true;

		/**
		 * <p>The implementation of this property is provided for convenience,
		 * but it cannot be used unless a subclass implements the
		 * <code>IFocusDisplayObject</code> interface.</p>
		 *
		 * @copy feathers.core.IFocusDisplayObject#isFocusEnabled
		 *
		 * @default true
		 *
		 * @see feathers.core.IFocusDisplayObject
		 */
		public function get isFocusEnabled():Boolean
		{
			return this._isEnabled && this._isFocusEnabled;
		}

		/**
		 * @private
		 */
		public function set isFocusEnabled(value:Boolean):void
		{
			if(!(this is IFocusDisplayObject))
			{
				throw new IllegalOperationError("Cannot enable focus on a component that does not implement feathers.core.IFocusDisplayObject");
			}
			if(this._isFocusEnabled == value)
			{
				return;
			}
			this._isFocusEnabled = value;
		}

		/**
		 * @private
		 */
		protected var _nextTabFocus:IFocusDisplayObject;

		/**
		 * <p>The implementation of this property is provided for convenience,
		 * but it cannot be used unless a subclass implements the
		 * <code>IFocusDisplayObject</code> interface.</p>
		 *
		 * @copy feathers.core.IFocusDisplayObject#nextTabFocus
		 *
		 * @default null
		 *
		 * @see feathers.core.IFocusDisplayObject
		 */
		public function get nextTabFocus():IFocusDisplayObject
		{
			return this._nextTabFocus;
		}

		/**
		 * @private
		 */
		public function set nextTabFocus(value:IFocusDisplayObject):void
		{
			if(!(this is IFocusDisplayObject))
			{
				throw new IllegalOperationError("Cannot set next tab focus on a component that does not implement feathers.core.IFocusDisplayObject");
			}
			this._nextTabFocus = value;
		}

		/**
		 * @private
		 */
		protected var _previousTabFocus:IFocusDisplayObject;

		/**
		 * <p>The implementation of this property is provided for convenience,
		 * but it cannot be used unless a subclass implements the
		 * <code>IFocusDisplayObject</code> interface.</p>
		 *
		 * @copy feathers.core.IFocusDisplayObject#previousTabFocus
		 *
		 * @default null
		 *
		 * @see feathers.core.IFocusDisplayObject
		 */
		public function get previousTabFocus():IFocusDisplayObject
		{
			return this._previousTabFocus;
		}

		/**
		 * @private
		 */
		public function set previousTabFocus(value:IFocusDisplayObject):void
		{
			if(!(this is IFocusDisplayObject))
			{
				throw new IllegalOperationError("Cannot set previous tab focus on a component that does not implement feathers.core.IFocusDisplayObject");
			}
			this._previousTabFocus = value;
		}

		/**
		 * @private
		 */
		protected var _focusIndicatorSkin:DisplayObject;

		/**
		 * If this component supports focus, this optional skin will be
		 * displayed above the component when <code>showFocus()</code> is
		 * called. The focus indicator skin is not always displayed when the
		 * component has focus. Typically, if the component receives focus from
		 * a touch, the focus indicator is not displayed.
		 *
		 * <p>The <code>touchable</code> of this skin will always be set to
		 * <code>false</code> so that it does not "steal" touches from the
		 * component or its sub-components. This skin will not affect the
		 * dimensions of the component or its hit area. It is simply a visual
		 * indicator of focus.</p>
		 *
		 * <p>The implementation of this property is provided for convenience,
		 * but it cannot be used unless a subclass implements the
		 * <code>IFocusDisplayObject</code> interface.</p>
		 *
		 * <p>In the following example, the focus indicator skin is set:</p>
		 *
		 * <listing version="3.0">
		 * control.focusIndicatorSkin = new Image( texture );</listing>
		 *
		 * @default null
		 */
		public function get focusIndicatorSkin():DisplayObject
		{
			return this._focusIndicatorSkin;
		}

		/**
		 * @private
		 */
		public function set focusIndicatorSkin(value:DisplayObject):void
		{
			if(!(this is IFocusDisplayObject))
			{
				throw new IllegalOperationError("Cannot set focus indicator skin on a component that does not implement feathers.core.IFocusDisplayObject");
			}
			if(this._focusIndicatorSkin == value)
			{
				return;
			}
			if(this._focusIndicatorSkin)
			{
				if(this._focusIndicatorSkin.parent == this)
				{
					this._focusIndicatorSkin.removeFromParent(false);
				}
				if(this._focusIndicatorSkin is IStateObserver &&
					this is IStateContext)
				{
					IStateObserver(this._focusIndicatorSkin).stateContext = null;
				}
			}
			this._focusIndicatorSkin = value;
			if(this._focusIndicatorSkin)
			{
				this._focusIndicatorSkin.touchable = false;
			}
			if(this._focusIndicatorSkin is IStateObserver &&
				this is IStateContext)
			{
				IStateObserver(this._focusIndicatorSkin).stateContext = IStateContext(this);
			}
			if(this._focusManager && this._focusManager.focus == this)
			{
				this.invalidate(INVALIDATION_FLAG_STYLES);
			}
		}

		/**
		 * Quickly sets all focus padding properties to the same value. The
		 * <code>focusPadding</code> getter always returns the value of
		 * <code>focusPaddingTop</code>, but the other focus padding values may
		 * be different.
		 *
		 * <p>The implementation of this property is provided for convenience,
		 * but it cannot be used unless a subclass implements the
		 * <code>IFocusDisplayObject</code> interface.</p>
		 *
		 * <p>The following example gives the button 2 pixels of focus padding
		 * on all sides:</p>
		 *
		 * <listing version="3.0">
		 * control.focusPadding = 2;</listing>
		 *
		 * @default 0
		 *
		 * @see #focusPaddingTop
		 * @see #focusPaddingRight
		 * @see #focusPaddingBottom
		 * @see #focusPaddingLeft
		 */
		public function get focusPadding():Number
		{
			return this._focusPaddingTop;
		}

		/**
		 * @private
		 */
		public function set focusPadding(value:Number):void
		{
			this.focusPaddingTop = value;
			this.focusPaddingRight = value;
			this.focusPaddingBottom = value;
			this.focusPaddingLeft = value;
		}

		/**
		 * @private
		 */
		protected var _focusPaddingTop:Number = 0;

		/**
		 * The minimum space, in pixels, between the object's top edge and the
		 * top edge of the focus indicator skin. A negative value may be used
		 * to expand the focus indicator skin outside the bounds of the object.
		 *
		 * <p>The implementation of this property is provided for convenience,
		 * but it cannot be used unless a subclass implements the
		 * <code>IFocusDisplayObject</code> interface.</p>
		 *
		 * <p>The following example gives the focus indicator skin -2 pixels of
		 * padding on the top edge only:</p>
		 *
		 * <listing version="3.0">
		 * control.focusPaddingTop = -2;</listing>
		 *
		 * @default 0
		 */
		public function get focusPaddingTop():Number
		{
			return this._focusPaddingTop;
		}

		/**
		 * @private
		 */
		public function set focusPaddingTop(value:Number):void
		{
			if(this._focusPaddingTop == value)
			{
				return;
			}
			this._focusPaddingTop = value;
			this.invalidate(INVALIDATION_FLAG_FOCUS);
		}

		/**
		 * @private
		 */
		protected var _focusPaddingRight:Number = 0;

		/**
		 * The minimum space, in pixels, between the object's right edge and the
		 * right edge of the focus indicator skin. A negative value may be used
		 * to expand the focus indicator skin outside the bounds of the object.
		 *
		 * <p>The implementation of this property is provided for convenience,
		 * but it cannot be used unless a subclass implements the
		 * <code>IFocusDisplayObject</code> interface.</p>
		 *
		 * <p>The following example gives the focus indicator skin -2 pixels of
		 * padding on the right edge only:</p>
		 *
		 * <listing version="3.0">
		 * control.focusPaddingRight = -2;</listing>
		 *
		 * @default 0
		 */
		public function get focusPaddingRight():Number
		{
			return this._focusPaddingRight;
		}

		/**
		 * @private
		 */
		public function set focusPaddingRight(value:Number):void
		{
			if(this._focusPaddingRight == value)
			{
				return;
			}
			this._focusPaddingRight = value;
			this.invalidate(INVALIDATION_FLAG_FOCUS);
		}

		/**
		 * @private
		 */
		protected var _focusPaddingBottom:Number = 0;

		/**
		 * The minimum space, in pixels, between the object's bottom edge and the
		 * bottom edge of the focus indicator skin. A negative value may be used
		 * to expand the focus indicator skin outside the bounds of the object.
		 *
		 * <p>The implementation of this property is provided for convenience,
		 * but it cannot be used unless a subclass implements the
		 * <code>IFocusDisplayObject</code> interface.</p>
		 *
		 * <p>The following example gives the focus indicator skin -2 pixels of
		 * padding on the bottom edge only:</p>
		 *
		 * <listing version="3.0">
		 * control.focusPaddingBottom = -2;</listing>
		 *
		 * @default 0
		 */
		public function get focusPaddingBottom():Number
		{
			return this._focusPaddingBottom;
		}

		/**
		 * @private
		 */
		public function set focusPaddingBottom(value:Number):void
		{
			if(this._focusPaddingBottom == value)
			{
				return;
			}
			this._focusPaddingBottom = value;
			this.invalidate(INVALIDATION_FLAG_FOCUS);
		}

		/**
		 * @private
		 */
		protected var _focusPaddingLeft:Number = 0;

		/**
		 * The minimum space, in pixels, between the object's left edge and the
		 * left edge of the focus indicator skin. A negative value may be used
		 * to expand the focus indicator skin outside the bounds of the object.
		 *
		 * <p>The implementation of this property is provided for convenience,
		 * but it cannot be used unless a subclass implements the
		 * <code>IFocusDisplayObject</code> interface.</p>
		 *
		 * <p>The following example gives the focus indicator skin -2 pixels of
		 * padding on the right edge only:</p>
		 *
		 * <listing version="3.0">
		 * control.focusPaddingLeft = -2;</listing>
		 *
		 * @default 0
		 */
		public function get focusPaddingLeft():Number
		{
			return this._focusPaddingLeft;
		}

		/**
		 * @private
		 */
		public function set focusPaddingLeft(value:Number):void
		{
			if(this._focusPaddingLeft == value)
			{
				return;
			}
			this._focusPaddingLeft = value;
			this.invalidate(INVALIDATION_FLAG_FOCUS);
		}

		/**
		 * @private
		 */
		protected var _hasFocus:Boolean = false;

		/**
		 * @private
		 */
		protected var _showFocus:Boolean = false;

		/**
		 * @private
		 * Flag to indicate that the control is currently validating.
		 */
		protected var _isValidating:Boolean = false;

		/**
		 * @private
		 * Flag to indicate that the control has validated at least once.
		 */
		protected var _hasValidated:Boolean = false;

		/**
		 * Determines if the component has been initialized and validated for
		 * the first time.
		 *
		 * <p>In the following example, we check if the component is created or
		 * not, and we listen for an event if it isn't:</p>
		 *
		 * <listing version="3.0">
		 * if( !control.isCreated )
		 * {
		 *     control.addEventListener( FeathersEventType.CREATION_COMPLETE, creationCompleteHandler );
		 * }</listing>
		 *
		 * @see #event:creationComplete
		 * @see #isInitialized
		 */
		public function get isCreated():Boolean
		{
			return this._hasValidated;
		}

		/**
		 * @private
		 */
		protected var _depth:int = -1;

		/**
		 * @copy feathers.core.IValidating#depth
		 */
		public function get depth():int
		{
			return this._depth;
		}

		/**
		 * @private
		 */
		protected var _invalidateCount:int = 0;

		/**
		 * Feathers components use an optimized <code>getBounds()</code>
		 * implementation that may sometimes behave differently than regular
		 * Starling display objects. For instance, filters may need some special
		 * customization. If a component's children appear outside of its
		 * bounds (such as at negative dimensions), padding should be added to
		 * the filter to account for these regions.
		 */
		override public function getBounds(targetSpace:DisplayObject, resultRect:Rectangle=null):Rectangle
		{
			if(!resultRect)
			{
				resultRect = new Rectangle();
			}

			var minX:Number = Number.MAX_VALUE, maxX:Number = -Number.MAX_VALUE;
			var minY:Number = Number.MAX_VALUE, maxY:Number = -Number.MAX_VALUE;

			if (targetSpace == this) // optimization
			{
				minX = 0;
				minY = 0;
				maxX = this.actualWidth;
				maxY = this.actualHeight;
			}
			else
			{
				var matrix:Matrix = Pool.getMatrix();
				this.getTransformationMatrix(targetSpace, matrix);

				MatrixUtil.transformCoords(matrix, 0, 0, HELPER_POINT);
				minX = minX < HELPER_POINT.x ? minX : HELPER_POINT.x;
				maxX = maxX > HELPER_POINT.x ? maxX : HELPER_POINT.x;
				minY = minY < HELPER_POINT.y ? minY : HELPER_POINT.y;
				maxY = maxY > HELPER_POINT.y ? maxY : HELPER_POINT.y;

				MatrixUtil.transformCoords(matrix, 0, this.actualHeight, HELPER_POINT);
				minX = minX < HELPER_POINT.x ? minX : HELPER_POINT.x;
				maxX = maxX > HELPER_POINT.x ? maxX : HELPER_POINT.x;
				minY = minY < HELPER_POINT.y ? minY : HELPER_POINT.y;
				maxY = maxY > HELPER_POINT.y ? maxY : HELPER_POINT.y;

				MatrixUtil.transformCoords(matrix, this.actualWidth, 0, HELPER_POINT);
				minX = minX < HELPER_POINT.x ? minX : HELPER_POINT.x;
				maxX = maxX > HELPER_POINT.x ? maxX : HELPER_POINT.x;
				minY = minY < HELPER_POINT.y ? minY : HELPER_POINT.y;
				maxY = maxY > HELPER_POINT.y ? maxY : HELPER_POINT.y;

				MatrixUtil.transformCoords(matrix, this.actualWidth, this.actualHeight, HELPER_POINT);
				minX = minX < HELPER_POINT.x ? minX : HELPER_POINT.x;
				maxX = maxX > HELPER_POINT.x ? maxX : HELPER_POINT.x;
				minY = minY < HELPER_POINT.y ? minY : HELPER_POINT.y;
				maxY = maxY > HELPER_POINT.y ? maxY : HELPER_POINT.y;

				Pool.putMatrix(matrix);
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
		override public function hitTest(localPoint:Point):DisplayObject
		{
			if(this._isQuickHitAreaEnabled)
			{
				if(!this.visible || !this.touchable)
				{
					return null;
				}
				if(this.mask && !this.hitTestMask(localPoint))
				{
					return null;
				}
				return this._hitArea.containsPoint(localPoint) ? this : null;
			}
			return super.hitTest(localPoint);
		}

		/**
		 * @private
		 */
		protected var _isDisposed:Boolean = false;

		/**
		 * @private
		 */
		override public function dispose():void
		{
			this._isDisposed = true;
			this._validationQueue = null;
			super.dispose();
		}

		/**
		 * Call this function to tell the UI control that a redraw is pending.
		 * The redraw will happen immediately before Starling renders the UI
		 * control to the screen. The validation system exists to ensure that
		 * multiple properties can be set together without redrawing multiple
		 * times in between each property change.
		 *
		 * <p>If you cannot wait until later for the validation to happen, you
		 * can call <code>validate()</code> to redraw immediately. As an example,
		 * you might want to validate immediately if you need to access the
		 * correct <code>width</code> or <code>height</code> values of the UI
		 * control, since these values are calculated during validation.</p>
		 *
		 * @see feathers.core.FeathersControl#validate()
		 */
		public function invalidate(flag:String = INVALIDATION_FLAG_ALL):void
		{
			var isAlreadyInvalid:Boolean = this.isInvalid();
			var isAlreadyDelayedInvalid:Boolean = false;
			if(this._isValidating)
			{
				for(var otherFlag:String in this._delayedInvalidationFlags)
				{
					isAlreadyDelayedInvalid = true;
					break;
				}
			}
			if(!flag || flag == INVALIDATION_FLAG_ALL)
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
			else
			{
				if(this._isValidating)
				{
					this._delayedInvalidationFlags[flag] = true;
				}
				else if(flag != INVALIDATION_FLAG_ALL && !this._invalidationFlags.hasOwnProperty(flag))
				{
					this._invalidationFlags[flag] = true;
				}
			}
			if(this._validationQueue === null || !this._isInitialized)
			{
				//we'll add this component to the queue later, after it has been
				//added to the stage.
				return;
			}
			if(this._isValidating)
			{
				//if we've already incremented this counter this time, we can
				//return. we're already in queue.
				if(isAlreadyDelayedInvalid)
				{
					return;
				}
				this._invalidateCount++;
				//if invalidate() is called during validation, we'll be added
				//back to the end of the queue. we'll keep trying this a certain
				//number of times, but at some point, it needs to be considered
				//an infinite loop or a serious bug because it affects
				//performance.
				if(this._invalidateCount >= 10)
				{
					throw new Error(getQualifiedClassName(this) + " returned to validation queue too many times during validation. This may be an infinite loop. Try to avoid doing anything that calls invalidate() during validation.");
				}
				this._validationQueue.addControl(this, false);
				return;
			}
			if(isAlreadyInvalid)
			{
				return;
			}
			this._invalidateCount = 0;
			this._validationQueue.addControl(this, false);
		}

		/**
		 * @copy feathers.core.IValidating#validate()
		 *
		 * @see #invalidate()
		 */
		public function validate():void
		{
			if(this._isDisposed)
			{
				//disposed components have no reason to validate, but they may
				//have been left in the queue.
				return;
			}
			if(!this._isInitialized)
			{
				if(this._isInitializing)
				{
					//initializing components cannot validate until they've
					//finished initializing. we'll have to wait.
					return;
				}
				this.initializeNow();
			}
			//if we're not actually invalid, there's nothing to do here, so
			//simply return.
			if(!this.isInvalid())
			{
				return;
			}
			if(this._isValidating)
			{
				//we were already validating, so there's nothing to do here.
				//the existing validation will continue.
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
			if(!this._hasValidated)
			{
				this._hasValidated = true;
				this.dispatchEventWith(FeathersEventType.CREATION_COMPLETE);
			}
		}

		/**
		 * Indicates whether the control is pending validation or not. By
		 * default, returns <code>true</code> if any invalidation flag has been
		 * set. If you pass in a specific flag, returns <code>true</code> only
		 * if that flag has been set (others may be set too, but it checks the
		 * specific flag only. If all flags have been marked as invalid, always
		 * returns <code>true</code>.
		 */
		public function isInvalid(flag:String = null):Boolean
		{
			if(this._isAllInvalid)
			{
				return true;
			}
			if(!flag) //return true if any flag is set
			{
				for(flag in this._invalidationFlags)
				{
					return true;
				}
				return false;
			}
			return this._invalidationFlags[flag];
		}

		/**
		 * Sets both the width and the height of the control in a single
		 * function call.
		 *
		 * @see #width
		 * @see #height
		 */
		public function setSize(width:Number, height:Number):void
		{
			this._explicitWidth = width;
			var widthIsNaN:Boolean = width !== width;
			if(widthIsNaN)
			{
				this.actualWidth = this.scaledActualWidth = 0;
			}
			this._explicitHeight = height;
			var heightIsNaN:Boolean = height !== height;
			if(heightIsNaN)
			{
				this.actualHeight = this.scaledActualHeight = 0;
			}

			if(widthIsNaN || heightIsNaN)
			{
				this.invalidate(INVALIDATION_FLAG_SIZE);
			}
			else
			{
				var result:Boolean = this.saveMeasurements(width, height, this.actualMinWidth, this.actualMinHeight);
				if(result)
				{
					this.invalidate(INVALIDATION_FLAG_SIZE);
				}
			}
		}

		/**
		 * Sets both the x and the y positions of the control in a single
		 * function call.
		 *
		 * @see #x
		 * @see #y
		 */
		public function move(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}

		/**
		 * Resets the <code>styleProvider</code> property to its default value,
		 * which is usually the global style provider for the component.
		 * 
		 * @see #styleProvider
		 * @see #defaultStyleProvider
		 */
		public function resetStyleProvider():void
		{
			this.styleProvider = this.defaultStyleProvider;
		}

		/**
		 * <p>The implementation of this method is provided for convenience, but
		 * it cannot be used unless a subclass implements the
		 * <code>IFocusDisplayObject</code> interface.</p>
		 *
		 * @copy feathers.core.IFocusDisplayObject#showFocus()
		 *
		 * @see feathers.core.IFocusDisplayObject
		 */
		public function showFocus():void
		{
			if(!this._hasFocus || !this._focusIndicatorSkin)
			{
				return;
			}

			this._showFocus = true;
			this.invalidate(INVALIDATION_FLAG_FOCUS);
		}

		/**
		 * <p>The implementation of this method is provided for convenience, but
		 * it cannot be used unless a subclass implements the
		 * <code>IFocusDisplayObject</code> interface.</p>
		 *
		 * @copy feathers.core.IFocusDisplayObject#hideFocus()
		 *
		 * @see feathers.core.IFocusDisplayObject
		 */
		public function hideFocus():void
		{
			if(!this._hasFocus || !this._focusIndicatorSkin)
			{
				return;
			}

			this._showFocus = false;
			this.invalidate(INVALIDATION_FLAG_FOCUS);
		}

		/**
		 * If the component has not yet initialized, initializes immediately.
		 * The <code>initialize()</code> function will be called, and the
		 * <code>FeathersEventType.INITIALIZE</code> event will be dispatched.
		 * Then, if the component has a style provider, it will be applied. The
		 * component will not validate, though. To initialize and validate
		 * immediately, call <code>validate()</code> instead.
		 * 
		 * @see #isInitialized
		 * @see #initialize()
		 * @see #event:initialize FeathersEventType.INITIALIZE
		 * @see #styleProvider
		 * @see #validate()
		 */
		public function initializeNow():void
		{
			if(this._isInitialized || this._isInitializing)
			{
				return;
			}
			this._isInitializing = true;
			this.initialize();
			this.invalidate(); //invalidate everything
			this._isInitializing = false;
			this._isInitialized = true;
			this.dispatchEventWith(FeathersEventType.INITIALIZE);

			if(this._styleProvider)
			{
				this._styleProvider.applyStyles(this);
			}
			this._styleNameList.addEventListener(Event.CHANGE, styleNameList_changeHandler);
		}

		/**
		 * Sets the width and height of the control, with the option of
		 * invalidating or not. Intended to be used when the <code>width</code>
		 * and <code>height</code> values have not been set explicitly, and the
		 * UI control needs to measure itself and choose an "ideal" size.
		 */
		protected function setSizeInternal(width:Number, height:Number, canInvalidate:Boolean):Boolean
		{
			var changed:Boolean = this.saveMeasurements(width, height, this.actualMinWidth, this.actualMinHeight);
			if(canInvalidate && changed)
			{
				this.invalidate(INVALIDATION_FLAG_SIZE);
			}
			return changed;
		}

		/**
		 * Saves the dimensions and minimum dimensions calculated for the
		 * component. Returns true if the reported values have changed and
		 * <code>Event.RESIZE</code> was dispatched.
		 */
		protected function saveMeasurements(width:Number, height:Number, minWidth:Number = 0, minHeight:Number = 0):Boolean
		{
			if(this._explicitMinWidth === this._explicitMinWidth) //!isNaN
			{
				//the min width has been set explicitly. it has precedence over
				//the measured min width
				minWidth = this._explicitMinWidth;
			}
			if(this._explicitMinHeight === this._explicitMinHeight) //!isNaN
			{
				//the min height has been set explicitly. it has precedence over
				//the measured min height
				minHeight = this._explicitMinHeight;
			}
			if(this._explicitWidth === this._explicitWidth) //!isNaN
			{
				width = this._explicitWidth;
			}
			else
			{
				if(width < minWidth)
				{
					width = minWidth;
				}
				else if(width > this._explicitMaxWidth)
				{
					width = this._explicitMaxWidth;
				}
			}
			if(this._explicitHeight === this._explicitHeight) //!isNaN
			{
				height = this._explicitHeight;
			}
			else
			{
				if(height < minHeight)
				{
					height = minHeight;
				}
				else if(height > this._explicitMaxHeight)
				{
					height = this._explicitMaxHeight;
				}
			}
			if(width !== width) //isNaN
			{
				throw new ArgumentError(ILLEGAL_WIDTH_ERROR);
			}
			if(height !== height) //isNaN
			{
				throw new ArgumentError(ILLEGAL_HEIGHT_ERROR);
			}
			var scaleX:Number = this.scaleX;
			if(scaleX < 0)
			{
				scaleX = -scaleX;
			}
			var scaleY:Number = this.scaleY;
			if(scaleY < 0)
			{
				scaleY = -scaleY;
			}
			var resized:Boolean = false;
			if(this.actualWidth !== width)
			{
				this.actualWidth = width;
				this.refreshHitAreaX();
				resized = true;
			}
			if(this.actualHeight !== height)
			{
				this.actualHeight = height;
				this.refreshHitAreaY();
				resized = true;
			}
			if(this.actualMinWidth !== minWidth)
			{
				this.actualMinWidth = minWidth;
				resized = true;
			}
			if(this.actualMinHeight !== minHeight)
			{
				this.actualMinHeight = minHeight;
				resized = true;
			}
			width = this.scaledActualWidth;
			height = this.scaledActualHeight;
			this.scaledActualWidth = this.actualWidth * scaleX;
			this.scaledActualHeight = this.actualHeight * scaleY;
			this.scaledActualMinWidth = this.actualMinWidth * scaleX;
			this.scaledActualMinHeight = this.actualMinHeight * scaleY;
			if(width !== this.scaledActualWidth || height !== this.scaledActualHeight)
			{
				resized = true;
				this.dispatchEventWith(Event.RESIZE);
			}
			return resized;
		}

		/**
		 * Called the first time that the UI control is added to the stage, and
		 * you should override this function to customize the initialization
		 * process. Do things like create children and set up event listeners.
		 * After this function is called, <code>FeathersEventType.INITIALIZE</code>
		 * is dispatched.
		 *
		 * @see #event:initialize feathers.events.FeathersEventType.INITIALIZE
		 */
		protected function initialize():void
		{

		}

		/**
		 * Override to customize layout and to adjust properties of children.
		 * Called when the component validates, if any flags have been marked
		 * to indicate that validation is pending.
		 */
		protected function draw():void
		{

		}

		/**
		 * Sets an invalidation flag. This will not add the component to the
		 * validation queue. It only sets the flag. A subclass might use
		 * this function during <code>draw()</code> to manipulate the flags that
		 * its superclass sees.
		 */
		protected function setInvalidationFlag(flag:String):void
		{
			if(this._invalidationFlags.hasOwnProperty(flag))
			{
				return;
			}
			this._invalidationFlags[flag] = true;
		}

		/**
		 * Clears an invalidation flag. This will not remove the component from
		 * the validation queue. It only clears the flag. A subclass might use
		 * this function during <code>draw()</code> to manipulate the flags that
		 * its superclass sees.
		 */
		protected function clearInvalidationFlag(flag:String):void
		{
			delete this._invalidationFlags[flag];
		}

		/**
		 * Updates the focus indicator skin by showing or hiding it and
		 * adjusting its position and dimensions. This function is not called
		 * automatically. Components that support focus should call this
		 * function at an appropriate point within the <code>draw()</code>
		 * function. This function may be overridden if the default behavior is
		 * not desired.
		 */
		protected function refreshFocusIndicator():void
		{
			if(this._focusIndicatorSkin)
			{
				if(this._hasFocus && this._showFocus)
				{
					if(this._focusIndicatorSkin.parent != this)
					{
						this.addChild(this._focusIndicatorSkin);
					}
					else
					{
						this.setChildIndex(this._focusIndicatorSkin, this.numChildren - 1);
					}
				}
				else if(this._focusIndicatorSkin.parent)
				{
					this._focusIndicatorSkin.removeFromParent(false);
				}
				this._focusIndicatorSkin.x = this._focusPaddingLeft;
				this._focusIndicatorSkin.y = this._focusPaddingTop;
				this._focusIndicatorSkin.width = this.actualWidth - this._focusPaddingLeft - this._focusPaddingRight;
				this._focusIndicatorSkin.height = this.actualHeight - this._focusPaddingTop - this._focusPaddingBottom;
			}
		}

		/**
		 * @private
		 */
		protected function refreshHitAreaX():void
		{
			if(this.actualWidth < this._minTouchWidth)
			{
				this._hitArea.width = this._minTouchWidth;
			}
			else
			{
				this._hitArea.width = this.actualWidth;
			}
			var hitAreaX:Number = (this.actualWidth - this._hitArea.width) / 2;
			if(hitAreaX !== hitAreaX) //isNaN
			{
				this._hitArea.x = 0;
			}
			else
			{
				this._hitArea.x = hitAreaX;
			}
		}

		/**
		 * @private
		 */
		protected function refreshHitAreaY():void
		{
			if(this.actualHeight < this._minTouchHeight)
			{
				this._hitArea.height = this._minTouchHeight;
			}
			else
			{
				this._hitArea.height = this.actualHeight;
			}
			var hitAreaY:Number = (this.actualHeight - this._hitArea.height) / 2;
			if(hitAreaY !== hitAreaY) //isNaN
			{
				this._hitArea.y = 0;
			}
			else
			{
				this._hitArea.y = hitAreaY;
			}
		}

		/**
		 * Default event handler for <code>FeathersEventType.FOCUS_IN</code>
		 * that may be overridden in subclasses to perform additional actions
		 * when the component receives focus.
		 */
		protected function focusInHandler(event:Event):void
		{
			this._hasFocus = true;
			this.invalidate(INVALIDATION_FLAG_FOCUS);
		}

		/**
		 * Default event handler for <code>FeathersEventType.FOCUS_OUT</code>
		 * that may be overridden in subclasses to perform additional actions
		 * when the component loses focus.
		 */
		protected function focusOutHandler(event:Event):void
		{
			this._hasFocus = false;
			this._showFocus = false;
			this.invalidate(INVALIDATION_FLAG_FOCUS);
		}

		/**
		 * @private
		 * Initialize the control, if it hasn't been initialized yet. Then,
		 * invalidate. If already initialized, check if invalid and put back
		 * into queue.
		 */
		protected function feathersControl_addedToStageHandler(event:Event):void
		{
			this._depth = getDisplayObjectDepthFromStage(this);
			var starling:Starling = stageToStarling(this.stage);
			this._validationQueue = ValidationQueue.forStarling(starling);
			if(!this._isInitialized)
			{
				this.initializeNow();
			}
			if(this.isInvalid())
			{
				this._invalidateCount = 0;
				//add to validation queue, if required
				this._validationQueue.addControl(this, false);
			}
		}

		/**
		 * @private
		 */
		protected function feathersControl_removedFromStageHandler(event:Event):void
		{
			this._depth = -1;
			this._validationQueue = null;
		}

		/**
		 * @private
		 */
		protected function layoutData_changeHandler(event:Event):void
		{
			this.dispatchEventWith(FeathersEventType.LAYOUT_DATA_CHANGE);
		}

		/**
		 * @private
		 */
		protected function styleNameList_changeHandler(event:Event):void
		{
			if(!this._styleProvider)
			{
				return;
			}
			this._styleProvider.applyStyles(this);
		}
	}
}