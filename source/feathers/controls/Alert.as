package feathers.controls
{
	import feathers.core.FeathersControl;
	import feathers.core.IFeathersControl;
	import feathers.core.ITextRenderer;
	import feathers.core.PopUpManager;
	import feathers.core.PropertyProxy;
	import feathers.data.ListCollection;
	import feathers.layout.VerticalLayout;

	import starling.display.DisplayObject;
	import starling.events.Event;

	[Exclude(name="layout",kind="property")]

	public class Alert extends Panel
	{
		public static const DEFAULT_CHILD_NAME_HEADER:String = "feathers-alert-header";
		public static const DEFAULT_CHILD_NAME_BUTTON_GROUP:String = "feathers-alert-button-group";
		public static const DEFAULT_CHILD_NAME_MESSAGE:String = "feathers-alert-message";

		public static function show(message:String, title:String = null, buttons:ListCollection = null):Alert
		{
			var alert:Alert = new Alert();
			alert.title = title;
			alert.message = message;
			alert.buttonsDataProvider = buttons;
			PopUpManager.addPopUp(alert, true, true);
			return alert;
		}

		/**
		 * @private
		 */
		protected static function defaultFooterFactory():ButtonGroup
		{
			return new ButtonGroup();
		}

		/**
		 * Constructor.
		 */
		public function Alert()
		{
			super();
			this.headerName = DEFAULT_CHILD_NAME_HEADER;
			this.footerName = DEFAULT_CHILD_NAME_BUTTON_GROUP;
			this.footerFactory = defaultFooterFactory;
		}

		/**
		 * The value added to the <code>nameList</code> of the alert's message
		 * text renderer. This variable is <code>protected</code> so that
		 * sub-classes can customize the message name in their constructors
		 * instead of using the default name defined by
		 * <code>DEFAULT_CHILD_NAME_MESSAGE</code>.
		 *
		 * @see feathers.core.IFeathersControl#nameList
		 */
		protected var messageName:String = DEFAULT_CHILD_NAME_MESSAGE;

		protected var headerHeader:Header;

		protected var buttonsFooter:ButtonGroup;

		protected var messageTextRenderer:ITextRenderer;

		/**
		 * @private
		 */
		protected var _title:String = null;

		public function get title():String
		{
			return this._title;
		}

		/**
		 * @private
		 */
		public function set title(value:String):void
		{
			if(this._title == value)
			{
				return;
			}
			this._title = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _message:String = null;

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
		protected var _buttonsDataProvider:ListCollection;

		public function get buttonsDataProvider():ListCollection
		{
			return this._buttonsDataProvider;
		}

		/**
		 * @private
		 */
		public function set buttonsDataProvider(value:ListCollection):void
		{
			if(this._buttonsDataProvider == value)
			{
				return;
			}
			this._buttonsDataProvider = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
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
		 * header.messageFactory = function():ITextRenderer
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
		 * @see feathers.controls.text.BitmapFontTextRenderer
		 * @see feathers.controls.text.TextFieldTextRenderer
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
		 * A set of key/value pairs to be passed down to the alert's message
		 * text renderer. The message text renderer is an <code>ITextRenderer</code>
		 * instance. The available properties depend on which
		 * <code>ITextRenderer</code> implementation is returned by
		 * <code>messageFactory</code>. The most common implementations are
		 * <code>BitmapFontTextRenderer</code> and <code>TextFieldTextRenderer</code>.
		 *
		 * <p>In the following example, some properties are set for the alert's
		 * message text renderer (this example assumes that the message text
		 * renderer is a <code>BitmapFontTextRenderer</code>):</p>
		 *
		 * <listing version="3.0">
		 * header.messageProperties.textFormat = new BitmapFontTextFormat( bitmapFont );
		 * header.messageProperties.wordWrap = true;</listing>
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
		 * which is in a <code>Scroller</code> which is in a <code>List</code>,
		 * you can use the following syntax:</p>
		 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * <p>Setting properties in a <code>messageFactory</code> function instead
		 * of using <code>messageProperties</code> will result in better
		 * performance.</p>
		 *
		 * @default null
		 *
		 * @see #titleFactory
		 * @see feathers.core.ITextRenderer
		 * @see feathers.controls.text.BitmapFontTextRenderer
		 * @see feathers.controls.text.TextFieldTextRenderer
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

		override protected function initialize():void
		{
			if(!this.layout)
			{
				var layout:VerticalLayout = new VerticalLayout();
				layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
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
			var stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES)
			var textRendererInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_TEXT_RENDERER);

			if(textRendererInvalid)
			{
				const oldDisplayListBypassEnabled:Boolean = this.displayListBypassEnabled;
				this.displayListBypassEnabled = true;
				this.createMessage();
				this.displayListBypassEnabled = oldDisplayListBypassEnabled;
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
		}

		/**
		 * @private
		 */
		override protected function createHeader():void
		{
			super.createHeader();
			this.headerHeader = Header(this.header);
		}

		/**
		 * @private
		 */
		override protected function createFooter():void
		{
			if(this.buttonsFooter)
			{
				this.buttonsFooter.removeEventListener(Event.TRIGGERED, buttonsFooter_triggeredHandler);
			}
			super.createFooter();
			this.buttonsFooter = ButtonGroup(this.footer);
			this.buttonsFooter.addEventListener(Event.TRIGGERED, buttonsFooter_triggeredHandler);
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

			const factory:Function = this._messageFactory != null ? this._messageFactory : FeathersControl.defaultTextRendererFactory;
			this.messageTextRenderer = ITextRenderer(factory());
			const uiTextRenderer:IFeathersControl = IFeathersControl(this.messageTextRenderer);
			uiTextRenderer.nameList.add(this.messageName);
			uiTextRenderer.touchable = false;
			this.addChild(DisplayObject(this.messageTextRenderer));
		}

		/**
		 * @private
		 */
		override protected function refreshHeaderStyles():void
		{
			super.refreshHeaderStyles();
			this.headerHeader.title = this._title;
		}

		/**
		 * @private
		 */
		override protected function refreshFooterStyles():void
		{
			super.refreshFooterStyles();
			this.buttonsFooter.dataProvider = this._buttonsDataProvider;
		}

		/**
		 * @private
		 */
		protected function refreshMessageStyles():void
		{
			const displayMessageRenderer:DisplayObject = DisplayObject(this.messageTextRenderer);
			for(var propertyName:String in this._messageProperties)
			{
				if(displayMessageRenderer.hasOwnProperty(propertyName))
				{
					var propertyValue:Object = this._messageProperties[propertyName];
					displayMessageRenderer[propertyName] = propertyValue;
				}
			}
		}

		/**
		 * @private
		 */
		protected function buttonsFooter_triggeredHandler(event:Event, data:Object):void
		{
			this.removeFromParent();
			this.dispatchEventWith(Event.CLOSE, false, data);
			this.dispose();
		}

	}
}
