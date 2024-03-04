/*
Feathers
Copyright 2012-2021 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.core.FeathersControl;
	import feathers.core.IFeathersControl;
	import feathers.core.IMeasureDisplayObject;
	import feathers.core.ITextRenderer;
	import feathers.core.IValidating;
	import feathers.core.PopUpManager;
	import feathers.core.PropertyProxy;
	import feathers.data.IListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.VerticalLayout;
	import feathers.skins.IStyleProvider;
	import feathers.text.FontStylesSet;
	import feathers.utils.display.getDisplayObjectDepthFromStage;
	import feathers.utils.skins.resetFluidChildDimensionsForMeasurement;

	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.text.TextFormat;

	[Exclude(name="layout",kind="property")]
	[Exclude(name="footer",kind="property")]
	[Exclude(name="footerFactory",kind="property")]
	[Exclude(name="footerProperties",kind="property")]
	[Exclude(name="customFooterStyleName",kind="style")]
	[Exclude(name="createFooter",kind="method")]

	/**
	 * A style name to add to the alert's button group sub-component.
	 * Typically used by a theme to provide different styles to different alerts.
	 *
	 * <p>In the following example, a custom button group style name is
	 * passed to the alert:</p>
	 *
	 * <listing version="3.0">
	 * alert.customButtonGroupStyleName = "my-custom-button-group";</listing>
	 *
	 * <p>In your theme, you can target this sub-component style name to
	 * provide different styles than the default:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( ButtonGroup ).setFunctionForStyleName( "my-custom-button-group", setCustomButtonGroupStyles );</listing>
	 *
	 * @default null
	 *
	 * @see #DEFAULT_CHILD_STYLE_NAME_BUTTON_GROUP
	 * @see feathers.core.FeathersControl#styleNameList
	 * @see #buttonGroupFactory
	 */
	[Style(name="customButtonGroupStyleName",type="String")]

	/**
	 * A style name to add to the alert's message text renderer
	 * sub-component. Typically used by a theme to provide different styles
	 * to different alerts.
	 *
	 * <p>In the following example, a custom message style name is passed
	 * to the alert:</p>
	 *
	 * <listing version="3.0">
	 * alert.customMessageStyleName = "my-custom-button-group";</listing>
	 *
	 * <p>In your theme, you can target this sub-component style name to
	 * provide different styles than the default:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( BitmapFontTextRenderer ).setFunctionForStyleName( "my-custom-message", setCustomMessageStyles );</listing>
	 *
	 * @default null
	 *
	 * @see #DEFAULT_CHILD_STYLE_NAME_MESSAGE
	 * @see feathers.core.FeathersControl#styleNameList
	 * @see #messageFactory
	 */
	[Style(name="customMessageStyleName",type="String")]

	/**
	 * The font styles used to display the alert's message text when the
	 * alert is disabled.
	 *
	 * <p>These styles will only apply to the alert's message. The header's
	 * title font styles should be set directly on the header. The button
	 * font styles should be set directly on the buttons.</p>
	 *
	 * <p>In the following example, the disabled font styles are customized:</p>
	 *
	 * <listing version="3.0">
	 * alert.disabledFontStyles = new TextFormat( "Helvetica", 20, 0x999999 );</listing>
	 *
	 * <p>Note: The <code>starling.text.TextFormat</code> class defines a
	 * number of common font styles, but the text renderer being used may
	 * support a larger number of ways to be customized. Use the
	 * <code>messageFactory</code> to set more advanced styles on the
	 * text renderer.</p>
	 *
	 * @default null
	 *
	 * @see http://doc.starling-framework.org/current/starling/text/TextFormat.html starling.text.TextFormat
	 * @see #style:fontStyles
	 */
	[Style(name="disabledFontStyles",type="starling.text.TextFormat")]

	/**
	 * The font styles used to display the alert's message text.
	 *
	 * <p>These styles will only apply to the alert's message. The header's
	 * title font styles should be set directly on the header. The button
	 * font styles should be set directly on the buttons.</p>
	 *
	 * <p>In the following example, the font styles are customized:</p>
	 *
	 * <listing version="3.0">
	 * alert.fontStyles = new TextFormat( "Helvetica", 20, 0xcc0000 );</listing>
	 *
	 * <p>Note: The <code>starling.text.TextFormat</code> class defines a
	 * number of common font styles, but the text renderer being used may
	 * support a larger number of ways to be customized. Use the
	 * <code>messageFactory</code> to set more advanced styles.</p>
	 *
	 * @default null
	 *
	 * @see http://doc.starling-framework.org/current/starling/text/TextFormat.html starling.text.TextFormat
	 * @see #style:disabledFontStyles
	 */
	[Style(name="fontStyles",type="starling.text.TextFormat")]

	/**
	 * The space, in pixels, between the alert's icon and its message text
	 * renderer.
	 *
	 * <p>In the following example, the gap is set to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * alert.gap = 20;</listing>
	 *
	 * @default 0
	 */
	[Style(name="gap",type="Number")]

	/**
	 * The alert's optional icon content to display next to the text.
	 *
	 * <p>In the following example, the icon is privated:</p>
	 *
	 * <listing version="3.0">
	 * alert.icon = new Image( texture );</listing>
	 *
	 * @default null
	 */
	[Style(name="icon",type="starling.display.DisplayObject")]

	/**
	 * Dispatched when the alert is closed. The <code>data</code> property of
	 * the event object will contain the item from the <code>ButtonGroup</code>
	 * data provider for the button that is triggered. If no button is
	 * triggered, then the <code>data</code> property will be <code>null</code>.
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
	 * Displays a message in a modal pop-up with a title and a set of buttons.
	 *
	 * <p>In general, an <code>Alert</code> isn't instantiated directly.
	 * Instead, you will typically call the static function
	 * <code>Alert.show()</code>. This is not required, but it result in less
	 * code and no need to manually manage calls to the <code>PopUpManager</code>.</p>
	 *
	 * <p>In the following example, an alert is shown when a <code>Button</code>
	 * is triggered:</p>
	 *
	 * <listing version="3.0">
	 * button.addEventListener( Event.TRIGGERED, button_triggeredHandler );
	 * 
	 * function button_triggeredHandler( event:Event ):void
	 * {
	 *     var alert:Alert = Alert.show( "This is an alert!", "Hello World", new ArrayCollection(
	 *     [
	 *         { label: "OK" }
	 *     ]));
	 * }</listing>
	 *
	 * @see ../../../help/alert.html How to use the Feathers Alert component
	 *
	 * @productversion Feathers 1.2.0
	 */
	public class Alert extends Panel
	{
		/**
		 * The default value added to the <code>styleNameList</code> of the header.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_HEADER:String = "feathers-alert-header";

		/**
		 * The default value added to the <code>styleNameList</code> of the button group.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_BUTTON_GROUP:String = "feathers-alert-button-group";

		/**
		 * The default value added to the <code>styleNameList</code> of the
		 * message text renderer.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 * @see ../../../help/text-renderers.html Introduction to Feathers text renderers
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_MESSAGE:String = "feathers-alert-message";

		/**
		 * Returns a new <code>Alert</code> instance when <code>Alert.show()</code>
		 * is called. If one wishes to skin the alert manually, a custom factory
		 * may be provided.
		 *
		 * <p>This function is expected to have the following signature:</p>
		 *
		 * <pre>function():Alert</pre>
		 *
		 * <p>The following example shows how to create a custom alert factory:</p>
		 *
		 * <listing version="3.0">
		 * Alert.alertFactory = function():Alert
		 * {
		 *     var alert:Alert = new Alert();
		 *     //set properties here!
		 *     return alert;
		 * };</listing>
		 *
		 * @see #show()
		 */
		public static var alertFactory:Function = defaultAlertFactory;

		/**
		 * Creates overlays for modal alerts. When this property is
		 * <code>null</code>, uses the <code>overlayFactory</code> defined by
		 * <code>PopUpManager</code> instead.
		 *
		 * <p>Note: Specific, individual alerts may have custom overlays that
		 * are different than the default by passing a different overlay factory
		 * to <code>Alert.show()</code>.</p>
		 *
		 * <p>This function is expected to have the following signature:</p>
		 * <pre>function():DisplayObject</pre>
		 *
		 * <p>The following example uses a semi-transparent <code>Quad</code> as
		 * a custom overlay:</p>
		 *
		 * <listing version="3.0">
		 * Alert.overlayFactory = function():Quad
		 * {
		 *     var quad:Quad = new Quad(10, 10, 0x000000);
		 *     quad.alpha = 0.75;
		 *     return quad;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.core.PopUpManager#overlayFactory
		 * @see #show()
		 */
		public static var overlayFactory:Function;

		/**
		 * The default <code>IStyleProvider</code> for all <code>Alert</code>
		 * components.
		 *
		 * @default null
		 *
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * The default factory that creates alerts when <code>Alert.show()</code>
		 * is called. To use a different factory, you need to set
		 * <code>Alert.alertFactory</code> to a <code>Function</code>
		 * instance.
		 *
		 * @see #show()
		 * @see #alertFactory
		 */
		public static function defaultAlertFactory():Alert
		{
			return new Alert();
		}

		/**
		 * Creates an alert, sets common properties, and adds it to the
		 * <code>PopUpManager</code> with the specified modal and centering
		 * options.
		 *
		 * <p>In the following example, an alert is shown when a
		 * <code>Button</code> is triggered:</p>
		 *
		 * <listing version="3.0">
		 * button.addEventListener( Event.TRIGGERED, button_triggeredHandler );
		 * 
		 * function button_triggeredHandler( event:Event ):void
		 * {
		 *     var alert:Alert = Alert.show( "This is an alert!", "Hello World", new ArrayCollection(
		 *     [
		 *         { label: "OK" }
		 *     ]);
		 * }</listing>
		 */
		public static function show(message:String, title:String = null, buttons:IListCollection = null,
			icon:DisplayObject = null, isModal:Boolean = true, isCentered:Boolean = true,
			customAlertFactory:Function = null, customOverlayFactory:Function = null):Alert
		{
			var factory:Function = customAlertFactory;
			if(factory == null)
			{
				factory = alertFactory != null ? alertFactory : defaultAlertFactory;
			}
			var alert:Alert = Alert(factory());
			alert.title = title;
			alert.message = message;
			alert.buttonsDataProvider = buttons;
			alert.icon = icon;
			factory = customOverlayFactory;
			if(factory == null)
			{
				factory = overlayFactory;
			}
			PopUpManager.addPopUp(alert, isModal, isCentered, factory);
			return alert;
		}

		/**
		 * @private
		 */
		protected static function defaultButtonGroupFactory():ButtonGroup
		{
			return new ButtonGroup();
		}

		/**
		 * Constructor.
		 */
		public function Alert()
		{
			super();
			this.headerStyleName = DEFAULT_CHILD_STYLE_NAME_HEADER;
			this.footerStyleName = DEFAULT_CHILD_STYLE_NAME_BUTTON_GROUP;
			if(this._fontStylesSet === null)
			{
				this._fontStylesSet = new FontStylesSet();
				this._fontStylesSet.addEventListener(Event.CHANGE, fontStyles_changeHandler);
			}
			this.buttonGroupFactory = defaultButtonGroupFactory;
			this.addEventListener(Event.ADDED_TO_STAGE, alert_addedToStageHandler);
		}

		/**
		 * The value added to the <code>styleNameList</code> of the alert's
		 * message text renderer. This variable is <code>protected</code> so
		 * that sub-classes can customize the message style name in their
		 * constructors instead of using the default style name defined by
		 * <code>DEFAULT_CHILD_STYLE_NAME_MESSAGE</code>.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var messageStyleName:String = DEFAULT_CHILD_STYLE_NAME_MESSAGE;

		/**
		 * The header sub-component.
		 *
		 * <p>For internal use in subclasses.</p>
		 */
		protected var headerHeader:Header;

		/**
		 * The button group sub-component.
		 *
		 * <p>For internal use in subclasses.</p>
		 */
		protected var buttonGroupFooter:ButtonGroup;

		/**
		 * The message text renderer sub-component.
		 *
		 * <p>For internal use in subclasses.</p>
		 */
		protected var messageTextRenderer:ITextRenderer;

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return Alert.globalStyleProvider;
		}

		/**
		 * @private
		 */
		protected var _message:String = null;

		/**
		 * The alert's main text content.
		 */
		public function get message():String
		{
			return this._message;
		}

		/**
		 * @private
		 */
		public function set message(value:String):void
		{
			if(this._message == value)
			{
				return;
			}
			this._message = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _icon:DisplayObject;

		/**
		 * @private
		 */
		public function get icon():DisplayObject
		{
			return this._icon;
		}

		/**
		 * @private
		 */
		public function set icon(value:DisplayObject):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				if(value !== null)
				{
					value.dispose();
				}
				return;
			}
			if(this._icon === value)
			{
				return;
			}
			var oldDisplayListBypassEnabled:Boolean = this.displayListBypassEnabled;
			this.displayListBypassEnabled = false;
			if(this._icon)
			{
				this._icon.removeEventListener(FeathersEventType.RESIZE, icon_resizeHandler);
				this.removeChild(this._icon);
			}
			this._icon = value;
			if(this._icon)
			{
				this._icon.addEventListener(FeathersEventType.RESIZE, icon_resizeHandler);
				this.addChild(this._icon);
			}
			this.displayListBypassEnabled = oldDisplayListBypassEnabled;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _gap:Number = 0;

		/**
		 * @private
		 */
		public function get gap():Number
		{
			return this._gap;
		}

		/**
		 * @private
		 */
		public function set gap(value:Number):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._gap == value)
			{
				return;
			}
			this._gap = value;
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
		}

		/**
		 * @private
		 */
		protected var _buttonsDataProvider:IListCollection = null;

		/**
		 * The data provider of the alert's <code>ButtonGroup</code>.
		 */
		public function get buttonsDataProvider():IListCollection
		{
			return this._buttonsDataProvider;
		}

		/**
		 * @private
		 */
		public function set buttonsDataProvider(value:IListCollection):void
		{
			if(this._buttonsDataProvider == value)
			{
				return;
			}
			this._buttonsDataProvider = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _acceptButtonIndex:int;

		/**
		 * The index of the button in the <code>buttonsDataProvider</code> to
		 * trigger when <code>Keyboard.ENTER</code> is pressed.
		 *
		 * <p>In the following example, the <code>acceptButtonIndex</code> is
		 * set to the first button in the data provider.</p>
		 *
		 * <listing version="3.0">
		 * var alert:Alert = Alert.show( "This is an alert!", "Hello World", new ArrayCollection(
		 * [
		 *     { label: "OK" }
		 * ]));
		 * alert.acceptButtonIndex = 0;</listing>
		 *
		 * @default -1
		 */
		public function get acceptButtonIndex():int
		{
			return this._acceptButtonIndex;
		}

		/**
		 * @private
		 */
		public function set acceptButtonIndex(value:int):void
		{
			this._acceptButtonIndex = value;
		}

		/**
		 * @private
		 */
		protected var _cancelButtonIndex:int;

		/**
		 * The index of the button in the <code>buttonsDataProvider</code> to
		 * trigger when <code>Keyboard.ESCAPE</code> or
		 * <code>Keyboard.BACK</code> is pressed.
		 *
		 * <p>In the following example, the <code>cancelButtonIndex</code> is
		 * set to the second button in the data provider.</p>
		 *
		 * <listing version="3.0">
		 * var alert:Alert = Alert.show( "This is an alert!", "Hello World", new ArrayCollection(
		 * [
		 *     { label: "OK" },
		 *     { label: "Cancel" },
		 * ]));
		 * alert.cancelButtonIndex = 1;</listing>
		 *
		 * @default -1
		 */
		public function get cancelButtonIndex():int
		{
			return this._cancelButtonIndex;
		}

		/**
		 * @private
		 */
		public function set cancelButtonIndex(value:int):void
		{
			this._cancelButtonIndex = value;
		}

		/**
		 * @private
		 */
		protected var _fontStylesSet:FontStylesSet;

		/**
		 * @private
		 */
		public function get fontStyles():TextFormat
		{
			return this._fontStylesSet.format;
		}

		/**
		 * @private
		 */
		public function set fontStyles(value:TextFormat):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			var savedCallee:Function = arguments.callee;
			function changeHandler(event:Event):void
			{
				processStyleRestriction(savedCallee);
			}
			var oldValue:TextFormat = this._fontStylesSet.format;
			if(oldValue !== null)
			{
				oldValue.removeEventListener(Event.CHANGE, changeHandler);
			}
			this._fontStylesSet.format = value;
			if(value !== null)
			{
				value.addEventListener(Event.CHANGE, changeHandler);
			}
		}

		/**
		 * @private
		 */
		public function get disabledFontStyles():TextFormat
		{
			return this._fontStylesSet.disabledFormat;
		}

		/**
		 * @private
		 */
		public function set disabledFontStyles(value:TextFormat):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			var savedCallee:Function = arguments.callee;
			function changeHandler(event:Event):void
			{
				processStyleRestriction(savedCallee);
			}
			var oldValue:TextFormat = this._fontStylesSet.disabledFormat;
			if(oldValue !== null)
			{
				oldValue.removeEventListener(Event.CHANGE, changeHandler);
			}
			this._fontStylesSet.disabledFormat = value;
			if(value !== null)
			{
				value.addEventListener(Event.CHANGE, changeHandler);
			}
		}

		/**
		 * @private
		 */
		protected var _messageFactory:Function;

		/**
		 * A function used to instantiate the alert's message text renderer
		 * sub-component. By default, the alert will use the global text
		 * renderer factory, <code>FeathersControl.defaultTextRendererFactory()</code>,
		 * to create the message text renderer. The message text renderer must
		 * be an instance of <code>ITextRenderer</code>. This factory can be
		 * used to change properties on the message text renderer when it is
		 * first created. For instance, if you are skinning Feathers components
		 * without a theme, you might use this factory to style the message text
		 * renderer.
		 *
		 * <p>If you are not using a theme, the message factory can be used to
		 * provide skin the message text renderer with appropriate text styles.</p>
		 *
		 * <p>The factory should have the following function signature:</p>
		 * <pre>function():ITextRenderer</pre>
		 *
		 * <p>In the following example, a custom message factory is passed to
		 * the alert:</p>
		 *
		 * <listing version="3.0">
		 * alert.messageFactory = function():ITextRenderer
		 * {
		 *     var messageRenderer:TextFieldTextRenderer = new TextFieldTextRenderer();
		 *     messageRenderer.textFormat = new TextFormat( "_sans", 12, 0xff0000 );
		 *     return messageRenderer;
		 * }</listing>
		 *
		 * @default null
		 *
		 * @see #message
		 * @see feathers.core.ITextRenderer
		 * @see feathers.core.FeathersControl#defaultTextRendererFactory
		 */
		public function get messageFactory():Function
		{
			return this._messageFactory;
		}

		/**
		 * @private
		 */
		public function set messageFactory(value:Function):void
		{
			if(this._messageFactory == value)
			{
				return;
			}
			this._messageFactory = value;
			this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
		}

		/**
		 * @private
		 */
		protected var _messageProperties:PropertyProxy;

		/**
		 * An object that stores properties for the alert's message text
		 * renderer sub-component, and the properties will be passed down to the
		 * text renderer when the alert validates. The available properties
		 * depend on which <code>ITextRenderer</code> implementation is returned
		 * by <code>messageFactory</code>. Refer to
		 * <a href="../core/ITextRenderer.html"><code>feathers.core.ITextRenderer</code></a>
		 * for a list of available text renderer implementations.
		 *
		 * <p>In the following example, some properties are set for the alert's
		 * message text renderer (this example assumes that the message text
		 * renderer is a <code>BitmapFontTextRenderer</code>):</p>
		 *
		 * <listing version="3.0">
		 * alert.messageProperties.textFormat = new BitmapFontTextFormat( bitmapFont );
		 * alert.messageProperties.wordWrap = true;</listing>
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
		 * which is in a <code>List</code>, you can use the following syntax:</p>
		 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * <p>Setting properties in a <code>messageFactory</code> function instead
		 * of using <code>messageProperties</code> will result in better
		 * performance.</p>
		 *
		 * @default null
		 *
		 * @see #messageFactory
		 * @see feathers.core.ITextRenderer
		 */
		public function get messageProperties():Object
		{
			if(!this._messageProperties)
			{
				this._messageProperties = new PropertyProxy(childProperties_onChange);
			}
			return this._messageProperties;
		}

		/**
		 * @private
		 */
		public function set messageProperties(value:Object):void
		{
			if(this._messageProperties == value)
			{
				return;
			}
			if(value && !(value is PropertyProxy))
			{
				value = PropertyProxy.fromObject(value);
			}
			if(this._messageProperties)
			{
				this._messageProperties.removeOnChangeCallback(childProperties_onChange);
			}
			this._messageProperties = PropertyProxy(value);
			if(this._messageProperties)
			{
				this._messageProperties.addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _customMessageStyleName:String;

		/**
		 * @private
		 */
		public function get customMessageStyleName():String
		{
			return this._customMessageStyleName;
		}

		/**
		 * @private
		 */
		public function set customMessageStyleName(value:String):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._customMessageStyleName === value)
			{
				return;
			}
			this._customMessageStyleName = value;
			this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
		}

		/**
		 * A function used to generate the alerts's button group sub-component.
		 * The button group must be an instance of <code>ButtonGroup</code>.
		 * This factory can be used to change properties on the button group
		 * when it is first created. For instance, if you are skinning Feathers
		 * components without a theme, you might use this factory to set skins
		 * and other styles on the button group.
		 *
		 * <p>The function should have the following signature:</p>
		 * <pre>function():ButtonGroup</pre>
		 *
		 * <p>In the following example, a custom button group factory is
		 * provided to the alert:</p>
		 *
		 * <listing version="3.0">
		 * alert.buttonGroupFactory = function():ButtonGroup
		 * {
		 *     return new ButtonGroup();
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.ButtonGroup
		 */
		public function get buttonGroupFactory():Function
		{
			return super.footerFactory;
		}

		/**
		 * @private
		 */
		public function set buttonGroupFactory(value:Function):void
		{
			super.footerFactory = value;
		}

		/**
		 * @private
		 */
		public function get customButtonGroupStyleName():String
		{
			return super.customFooterStyleName;
		}

		/**
		 * @private
		 */
		public function set customButtonGroupStyleName(value:String):void
		{
			super.customFooterStyleName = value;
		}

		/**
		 * An object that stores properties for the alert's button group
		 * sub-component, and the properties will be passed down to the button
		 * group when the alert validates. For a list of available properties,
		 * refer to <a href="ButtonGroup.html"><code>feathers.controls.ButtonGroup</code></a>.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
		 * which is in a <code>List</code>, you can use the following syntax:</p>
		 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * <p>Setting properties in a <code>buttonGroupFactory</code> function
		 * instead of using <code>buttonGroupProperties</code> will result in better
		 * performance.</p>
		 *
		 * <p>In the following example, the button group properties are customized:</p>
		 *
		 * <listing version="3.0">
		 * alert.buttonGroupProperties.gap = 20;</listing>
		 *
		 * @default null
		 *
		 * @see #buttonGroupFactory
		 * @see feathers.controls.ButtonGroup
		 */
		public function get buttonGroupProperties():Object
		{
			return super.footerProperties;
		}

		/**
		 * @private
		 */
		public function set buttonGroupProperties(value:Object):void
		{
			super.footerProperties = value;
		}

		/**
		 * @private
		 */
		override public function dispose():void
		{
			if(this._fontStylesSet !== null)
			{
				this._fontStylesSet.dispose();
				this._fontStylesSet = null;
			}
			super.dispose();
		}

		/**
		 * @private
		 */
		override protected function initialize():void
		{
			if(this._layout === null)
			{
				var layout:VerticalLayout = new VerticalLayout();
				layout.horizontalAlign = HorizontalAlign.JUSTIFY;
				this.ignoreNextStyleRestriction();
				this.layout = layout;
			}
			super.initialize();
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			var stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			var stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			var textRendererInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_TEXT_RENDERER);

			if(textRendererInvalid)
			{
				this.createMessage();
			}

			if(textRendererInvalid || dataInvalid)
			{
				this.messageTextRenderer.text = this._message;
			}

			if(textRendererInvalid || stylesInvalid)
			{
				this.refreshMessageStyles();
			}

			super.draw();

			if(this._icon !== null)
			{
				if(this._icon is IValidating)
				{
					IValidating(this._icon).validate();
				}
				this._icon.x = this._paddingLeft;
				this._icon.y = this._topViewPortOffset + (this._viewPort.visibleHeight - this._icon.height) / 2;
			}
		}

		/**
		 * @private
		 */
		override protected function autoSizeIfNeeded():Boolean
		{
			if(this._autoSizeMode === AutoSizeMode.STAGE)
			{
				//the implementation in a super class can handle this
				return super.autoSizeIfNeeded();
			}

			var needsWidth:Boolean = this._explicitWidth !== this._explicitWidth; //isNaN
			var needsHeight:Boolean = this._explicitHeight !== this._explicitHeight; //isNaN
			var needsMinWidth:Boolean = this._explicitMinWidth !== this._explicitMinWidth; //isNaN
			var needsMinHeight:Boolean = this._explicitMinHeight !== this._explicitMinHeight; //isNaN
			if(!needsWidth && !needsHeight && !needsMinWidth && !needsMinHeight)
			{
				return false;
			}

			resetFluidChildDimensionsForMeasurement(this.currentBackgroundSkin,
				this._explicitWidth, this._explicitHeight,
				this._explicitMinWidth, this._explicitMinHeight,
				this._explicitMaxWidth, this._explicitMaxHeight,
				this._explicitBackgroundWidth, this._explicitBackgroundHeight,
				this._explicitBackgroundMinWidth, this._explicitBackgroundMinHeight,
				this._explicitBackgroundMaxWidth, this._explicitBackgroundMaxHeight);
			var measureBackground:IMeasureDisplayObject = this.currentBackgroundSkin as IMeasureDisplayObject;
			if(this.currentBackgroundSkin is IValidating)
			{
				IValidating(this.currentBackgroundSkin).validate();
			}

			if(this._icon is IValidating)
			{
				IValidating(this._icon).validate();
			}

			//we don't measure the header and footer here because they are
			//handled in calculateViewPortOffsets(), which is automatically
			//called by Scroller before autoSizeIfNeeded().

			var newWidth:Number = this._explicitWidth;
			var newHeight:Number = this._explicitHeight;
			var newMinWidth:Number = this._explicitMinWidth;
			var newMinHeight:Number = this._explicitMinHeight;
			if(needsWidth)
			{
				if(this._measureViewPort)
				{
					newWidth = this._viewPort.visibleWidth;
				}
				else
				{
					newWidth = 0;
				}
				//we don't need to account for the icon and gap because it is
				//already included in the left offset
				newWidth += this._rightViewPortOffset + this._leftViewPortOffset;
				var headerWidth:Number = this.header.width + this._outerPaddingLeft + this._outerPaddingRight;
				if(headerWidth > newWidth)
				{
					newWidth = headerWidth;
				}
				if(this.footer !== null)
				{
					var footerWidth:Number = this.footer.width + this._outerPaddingLeft + this._outerPaddingRight;
					if(footerWidth > newWidth)
					{
						newWidth = footerWidth;
					}
				}
				if(this.currentBackgroundSkin !== null &&
					this.currentBackgroundSkin.width > newWidth)
				{
					newWidth = this.currentBackgroundSkin.width;
				}
			}
			if(needsHeight)
			{
				if(this._measureViewPort)
				{
					newHeight = this._viewPort.visibleHeight;
				}
				else
				{
					newHeight = 0;
				}
				if(this._icon !== null)
				{
					var iconHeight:Number = this._icon.height;
					if(iconHeight === iconHeight && //!isNaN
						iconHeight > newHeight)
					{
						newHeight = iconHeight;
					}
				}
				newHeight += this._bottomViewPortOffset + this._topViewPortOffset;
				//we don't need to account for the header and footer because
				//they're already included in the top and bottom offsets
				if(this.currentBackgroundSkin !== null &&
					this.currentBackgroundSkin.height > newHeight)
				{
					newHeight = this.currentBackgroundSkin.height;
				}
			}
			if(needsMinWidth)
			{
				if(this._measureViewPort)
				{
					newMinWidth = this._viewPort.minVisibleWidth;
				}
				else
				{
					newMinWidth = 0;
				}
				//we don't need to account for the icon and gap because it is
				//already included in the left offset
				newMinWidth += this._rightViewPortOffset + this._leftViewPortOffset;
				var headerMinWidth:Number = this.header.minWidth + this._outerPaddingLeft + this._outerPaddingRight;
				if(headerMinWidth > newMinWidth)
				{
					newMinWidth = headerMinWidth;
				}
				if(this.footer !== null)
				{
					var footerMinWidth:Number = this.footer.minWidth + this._outerPaddingLeft + this._outerPaddingRight;
					if(footerMinWidth > newMinWidth)
					{
						newMinWidth = footerMinWidth;
					}
				}
				if(this.currentBackgroundSkin !== null)
				{
					if(measureBackground !== null)
					{
						if(measureBackground.minWidth > newMinWidth)
						{
							newMinWidth = measureBackground.minWidth;
						}
					}
					else if(this._explicitBackgroundMinWidth > newMinWidth)
					{
						newMinWidth = this._explicitBackgroundMinWidth;
					}
				}
			}
			if(needsMinHeight)
			{
				if(this._measureViewPort)
				{
					newMinHeight = this._viewPort.minVisibleHeight;
				}
				else
				{
					newMinHeight = 0;
				}
				if(this._icon !== null)
				{
					iconHeight = this._icon.height;
					if(iconHeight === iconHeight && //!isNaN
						iconHeight > newMinHeight)
					{
						newMinHeight = iconHeight;
					}
				}
				newMinHeight += this._bottomViewPortOffset + this._topViewPortOffset;
				//we don't need to account for the header and footer because
				//they're already included in the top and bottom offsets
				if(this.currentBackgroundSkin !== null)
				{
					if(measureBackground !== null)
					{
						if(measureBackground.minHeight > newMinHeight)
						{
							newMinHeight = measureBackground.minHeight;
						}
					}
					else if(this._explicitBackgroundMinHeight > newMinHeight)
					{
						newMinHeight = this._explicitBackgroundMinHeight;
					}
				}
			}

			return this.saveMeasurements(newWidth, newHeight, newMinWidth, newMinHeight);
		}

		/**
		 * Creates and adds the <code>header</code> sub-component and
		 * removes the old instance, if one exists.
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 *
		 * @see #header
		 * @see #headerFactory
		 * @see #style:customHeaderStyleName
		 */
		override protected function createHeader():void
		{
			super.createHeader();
			this.headerHeader = Header(this.header);
		}

		/**
		 * Creates and adds the <code>buttonGroupFooter</code> sub-component and
		 * removes the old instance, if one exists.
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 *
		 * @see #buttonGroupFooter
		 * @see #buttonGroupFactory
		 * @see #style:customButtonGroupStyleName
		 */
		protected function createButtonGroup():void
		{
			if(this.buttonGroupFooter)
			{
				this.buttonGroupFooter.removeEventListener(Event.TRIGGERED, buttonsFooter_triggeredHandler);
			}
			super.createFooter();
			this.buttonGroupFooter = ButtonGroup(this.footer);
			this.buttonGroupFooter.addEventListener(Event.TRIGGERED, buttonsFooter_triggeredHandler);
		}

		/**
		 * @private
		 */
		override protected function createFooter():void
		{
			this.createButtonGroup();
		}

		/**
		 * Creates and adds the <code>messageTextRenderer</code> sub-component and
		 * removes the old instance, if one exists.
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 *
		 * @see #message
		 * @see #messageTextRenderer
		 * @see #messageFactory
		 */
		protected function createMessage():void
		{
			if(this.messageTextRenderer)
			{
				this.removeChild(DisplayObject(this.messageTextRenderer), true);
				this.messageTextRenderer = null;
			}

			var factory:Function = this._messageFactory != null ? this._messageFactory : FeathersControl.defaultTextRendererFactory;
			this.messageTextRenderer = ITextRenderer(factory());
			this.messageTextRenderer.wordWrap = true;
			var messageStyleName:String = this._customMessageStyleName != null ? this._customMessageStyleName : this.messageStyleName;
			var uiTextRenderer:IFeathersControl = IFeathersControl(this.messageTextRenderer);
			uiTextRenderer.styleNameList.add(messageStyleName);
			uiTextRenderer.touchable = false;
			this.addChild(DisplayObject(this.messageTextRenderer));
		}

		/**
		 * @private
		 */
		override protected function refreshFooterStyles():void
		{
			super.refreshFooterStyles();
			this.buttonGroupFooter.dataProvider = this._buttonsDataProvider;
		}

		/**
		 * @private
		 */
		protected function refreshMessageStyles():void
		{
			this.messageTextRenderer.fontStyles = this._fontStylesSet;
			for(var propertyName:String in this._messageProperties)
			{
				var propertyValue:Object = this._messageProperties[propertyName];
				this.messageTextRenderer[propertyName] = propertyValue;
			}
		}

		/**
		 * @private
		 */
		override protected function calculateViewPortOffsets(forceScrollBars:Boolean = false, useActualBounds:Boolean = false):void
		{
			super.calculateViewPortOffsets(forceScrollBars, useActualBounds);
			if(this._icon !== null)
			{
				if(this._icon is IValidating)
				{
					IValidating(this._icon).validate();
				}
				var iconWidth:Number = this._icon.width;
				if(iconWidth === iconWidth) //!isNaN
				{
					this._leftViewPortOffset += iconWidth + this._gap;
				}
			}
		}

		/**
		 * @private
		 */
		protected function closeAlert(item:Object):void
		{
			this.removeFromParent();
			this.dispatchEventWith(Event.CLOSE, false, item);
			this.dispose();
		}

		/**
		 * @private
		 */
		protected function buttonsFooter_triggeredHandler(event:Event, data:Object):void
		{
			this.closeAlert(data);
		}

		/**
		 * @private
		 */
		protected function icon_resizeHandler(event:Event):void
		{
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
		}

		/**
		 * @private
		 */
		protected function fontStyles_changeHandler(event:Event):void
		{
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected function alert_addedToStageHandler(event:Event):void
		{
			var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
			//using priority here is a hack so that objects higher up in the
			//display list have a chance to cancel the event first.
			var priority:int = -getDisplayObjectDepthFromStage(this);
			starling.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, alert_nativeStage_keyDownHandler, false, priority, true);
			this.addEventListener(Event.REMOVED_FROM_STAGE, alert_removedFromStageHandler);
		}

		/**
		 * @private
		 */
		protected function alert_removedFromStageHandler(event:Event):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, alert_removedFromStageHandler);
			var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
			starling.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN, alert_nativeStage_keyDownHandler);
		}

		/**
		 * @private
		 */
		protected function alert_nativeStage_keyDownHandler(event:KeyboardEvent):void
		{
			if(event.isDefaultPrevented())
			{
				//someone else already handled this one
				return;
			}
			if(this._buttonsDataProvider === null)
			{
				//no buttons to trigger
				return;
			}
			var keyCode:uint = event.keyCode;
			if(this._acceptButtonIndex != -1 && keyCode == Keyboard.ENTER)
			{
				//don't let the OS handle the event
				event.preventDefault();
				var item:Object = this._buttonsDataProvider.getItemAt(this._acceptButtonIndex);
				this.closeAlert(item);
				return;
			}
			if(this._cancelButtonIndex != -1 &&
				(keyCode == Keyboard.BACK || keyCode == Keyboard.ESCAPE))
			{
				//don't let the OS handle the event
				event.preventDefault();
				item = this._buttonsDataProvider.getItemAt(this._cancelButtonIndex);
				this.closeAlert(item);
				return;
			}
		}

	}
}
