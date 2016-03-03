/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.core.FeathersControl;
	import feathers.core.ITextRenderer;
	import feathers.core.IToolTip;
	import feathers.core.PopUpManager;
	import feathers.skins.IStyleProvider;

	import flash.ui.Keyboard;

	import starling.display.DisplayObject;
	import starling.events.EnterFrameEvent;

	[Exclude(name="content",kind="property")]
	
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
	 * A special <code>Callout</code> designed to display text.
	 *
	 * <p>In the following example, a text callout is shown when a
	 * <code>Button</code> is triggered:</p>
	 *
	 * <listing version="3.0">
	 * button.addEventListener( Event.TRIGGERED, button_triggeredHandler );
	 *
	 * function button_triggeredHandler( event:Event ):void
	 * {
	 *     var button:Button = Button( event.currentTarget );
	 *     Callout.show( "Hello World", button );
	 * }</listing>
	 *
	 * <p><strong>Beta Component:</strong> This is a new component, and its APIs
	 * may need some changes between now and the next version of Feathers to
	 * account for overlooked requirements or other issues. Upgrading to future
	 * versions of Feathers may involve manual changes to your code that uses
	 * this component. The
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>
	 * will not go into effect until this component's status is upgraded from
	 * beta to stable.</p>
	 *
	 * @see ../../../help/text-callout.html How to use the Feathers Callout component
	 */
	public class TextCallout extends Callout implements IToolTip
	{
		/**
		 * The default value added to the <code>styleNameList</code> of the text
		 * renderer sub-component.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_TEXT_RENDERER:String = "feathers-text-callout-text-renderer";
		
		/**
		 * The default <code>IStyleProvider</code> for all <code>Label</code>
		 * components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * Returns a new <code>TextCallout</code> instance when
		 * <code>TextCallout.show()</code> is called. If one wishes to skin the
		 * callout manually or change its behavior, a custom factory may be
		 * provided.
		 *
		 * <p>This function is expected to have the following signature:</p>
		 *
		 * <pre>function():TextCallout</pre>
		 *
		 * <p>The following example shows how to create a custom text callout factory:</p>
		 *
		 * <listing version="3.0">
		 * TextCallout.calloutFactory = function():TextCallout
		 * {
		 *     var callout:TextCallout = new TextCallout();
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
		 * The default factory that creates callouts when
		 * <code>TextCallout.show()</code> is called. To use a different
		 * factory, you need to set <code>TextCallout.calloutFactory</code> to a
		 * <code>Function</code> instance.
		 */
		public static function defaultCalloutFactory():TextCallout
		{
			var callout:TextCallout = new TextCallout();
			callout.closeOnTouchBeganOutside = true;
			callout.closeOnTouchEndedOutside = true;
			callout.closeOnKeys = new <uint>[Keyboard.BACK, Keyboard.ESCAPE];
			return callout;
		}
		
		/**
		 * Creates a callout that displays some text, and then positions and
		 * sizes it automatically based on an origin rectangle and the specified
		 * direction relative to the origin.
		 *
		 * <p>In the following example, a text callout is shown when a
		 * <code>Button</code> is triggered:</p>
		 *
		 * <listing version="3.0">
		 * button.addEventListener( Event.TRIGGERED, button_triggeredHandler );
		 *
		 * function button_triggeredHandler( event:Event ):void
		 * {
		 *     var button:Button = Button( event.currentTarget );
		 *     TextCallout.show( "Hello World", button );
		 * }</listing>
		 */
		public static function show(text:String, origin:DisplayObject, supportedDirections:String = DIRECTION_ANY,
			isModal:Boolean = true, customCalloutFactory:Function = null, customOverlayFactory:Function = null):TextCallout
		{
			if(!origin.stage)
			{
				throw new ArgumentError("TextCallout origin must be added to the stage.");
			}
			var factory:Function = customCalloutFactory;
			if(factory == null)
			{
				factory = calloutFactory != null ? calloutFactory : defaultCalloutFactory;
			}
			var callout:TextCallout = TextCallout(factory());
			callout.text = text;
			callout.supportedDirections = supportedDirections;
			callout.origin = origin;
			factory = customOverlayFactory;
			if(factory == null)
			{
				factory = calloutOverlayFactory != null ? calloutOverlayFactory : PopUpManager.defaultOverlayFactory;
			}
			PopUpManager.addPopUp(callout, isModal, false, factory);
			callout.validate();
			return callout;
		}
		
		/**
		 * Constructor.
		 */
		public function TextCallout()
		{
			super();
			this.isQuickHitAreaEnabled = true;
		}

		/**
		 * The text renderer.
		 *
		 * @see #createTextRenderer()
		 * @see #textRendererFactory
		 */
		protected var textRenderer:ITextRenderer;

		/**
		 * The value added to the <code>styleNameList</code> of the text
		 * renderer sub-component. This variable is <code>protected</code> so
		 * that sub-classes can customize the label text renderer style name in
		 * their constructors instead of using the default style name defined by
		 * <code>DEFAULT_CHILD_STYLE_NAME_TEXT_RENDERER</code>.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var textRendererStyleName:String = DEFAULT_CHILD_STYLE_NAME_TEXT_RENDERER;

		/**
		 * @private
		 */
		protected var _text:String;

		/**
		 * The text to display in the callout.
		 */
		public function get text():String
		{
			return this._text;
		}

		/**
		 * @private
		 */
		public function set text(value:String):void
		{
			if(this._text === value)
			{
				return;
			}
			this._text = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _textRendererFactory:Function;

		/**
		 * A function used to instantiate the callout's text renderer
		 * sub-component. By default, the callout will use the global text
		 * renderer factory, <code>FeathersControl.defaultTextRendererFactory()</code>,
		 * to create the text renderer. The text renderer must be an instance of
		 * <code>ITextRenderer</code>. This factory can be used to change
		 * properties on the text renderer when it is first created. For
		 * instance, if you are skinning Feathers components without a theme,
		 * you might use this factory to style the text renderer.
		 *
		 * <p>The factory should have the following function signature:</p>
		 * <pre>function():ITextRenderer</pre>
		 *
		 * <p>In the following example, a custom text renderer factory is passed
		 * to the callout:</p>
		 *
		 * <listing version="3.0">
		 * callout.textRendererFactory = function():ITextRenderer
		 * {
		 *     return new TextFieldTextRenderer();
		 * }</listing>
		 *
		 * @default null
		 *
		 * @see feathers.core.ITextRenderer
		 * @see feathers.core.FeathersControl#defaultTextRendererFactory
		 */
		public function get textRendererFactory():Function
		{
			return this._textRendererFactory;
		}

		/**
		 * @private
		 */
		public function set textRendererFactory(value:Function):void
		{
			if(this._textRendererFactory == value)
			{
				return;
			}
			this._textRendererFactory = value;
			this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
		}

		/**
		 * @private
		 */
		protected var _customTextRendererStyleName:String;

		/**
		 * A style name to add to the callout's text renderer sub-component.
		 * Typically used by a theme to provide different styles to different
		 * callouts.
		 *
		 * <p>In the following example, a custom text renderer style name is
		 * passed to the callout:</p>
		 *
		 * <listing version="3.0">
		 * button.customTextRendererStyleName = "my-custom-text-callout-text-renderer";</listing>
		 *
		 * <p>In your theme, you can target this sub-component style name to
		 * provide different styles than the default:</p>
		 *
		 * <listing version="3.0">
		 * getStyleProviderForClass( BitmapFontTextRenderer ).setFunctionForStyleName( "my-custom-text-callout-text-renderer", setCustomTextCalloutTextRendererStyles );</listing>
		 *
		 * @default null
		 *
		 * @see #DEFAULT_CHILD_STYLE_NAME_TEXT_RENDERER
		 * @see feathers.core.FeathersControl#styleNameList
		 * @see #textRendererFactory
		 */
		public function get customTextRendererStyleName():String
		{
			return this._customTextRendererStyleName;
		}

		/**
		 * @private
		 */
		public function set customTextRendererStyleName(value:String):void
		{
			if(this._customTextRendererStyleName == value)
			{
				return;
			}
			this._customTextRendererStyleName = value;
			this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
		}

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			if(TextCallout.globalStyleProvider !== null)
			{
				return TextCallout.globalStyleProvider;
			}
			return Callout.globalStyleProvider;
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			var stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			var textRendererInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_TEXT_RENDERER);

			if(textRendererInvalid)
			{
				this.createTextRenderer();
			}

			if(textRendererInvalid || dataInvalid || stateInvalid)
			{
				this.refreshTextRendererData();
			}
			super.draw();
		}

		/**
		 * Creates and adds the <code>textRenderer</code> sub-component and
		 * removes the old instance, if one exists.
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 *
		 * @see #textRenderer
		 * @see #textRendererFactory
		 */
		protected function createTextRenderer():void
		{
			if(this.textRenderer)
			{
				this.removeChild(DisplayObject(this.textRenderer), true);
				this.textRenderer = null;
			}

			var factory:Function = this._textRendererFactory != null ? this._textRendererFactory : FeathersControl.defaultTextRendererFactory;
			this.textRenderer = ITextRenderer(factory());
			var textRendererStyleName:String = this._customTextRendererStyleName !== null ? this._customTextRendererStyleName : this.textRendererStyleName;
			this.textRenderer.styleNameList.add(textRendererStyleName);
			this._content = DisplayObject(this.textRenderer);
			this.addChild(this._content);
		}

		/**
		 * @private
		 */
		protected function refreshTextRendererData():void
		{
			this.textRenderer.text = this._text;
			this.textRenderer.visible = this._text && this._text.length > 0;
		}

		/**
		 * @private
		 */
		override protected function callout_enterFrameHandler(event:EnterFrameEvent):void
		{
			//wait for validation
			if(this.isCreated)
			{
				this.positionToOrigin();
			}
		}
	}
}
