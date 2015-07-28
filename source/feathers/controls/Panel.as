/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.core.IFeathersControl;
	import feathers.core.IFocusExtras;
	import feathers.core.PropertyProxy;
	import feathers.events.FeathersEventType;
	import feathers.skins.IStyleProvider;

	import starling.display.DisplayObject;
	import starling.events.Event;

	/**
	 * A container with layout, optional scrolling, a header, and an optional
	 * footer.
	 *
	 * <p>The following example creates a panel with a horizontal layout and
	 * adds two buttons to it:</p>
	 *
	 * <listing version="3.0">
	 * var panel:Panel = new Panel();
	 * panel.title = "Is it time to party?";
	 * 
	 * var layout:HorizontalLayout = new HorizontalLayout();
	 * layout.gap = 20;
	 * layout.padding = 20;
	 * panel.layout = layout;
	 * 
	 * this.addChild( panel );
	 * 
	 * var yesButton:Button = new Button();
	 * yesButton.label = "Yes";
	 * panel.addChild( yesButton );
	 * 
	 * var noButton:Button = new Button();
	 * noButton.label = "No";
	 * panel.addChild( noButton );</listing>
	 *
	 * @see ../../../help/panel.html How to use the Feathers Panel component
	 */
	public class Panel extends ScrollContainer implements IFocusExtras
	{
		/**
		 * The default value added to the <code>styleNameList</code> of the header.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_HEADER:String = "feathers-panel-header";

		/**
		 * DEPRECATED: Replaced by <code>Panel.DEFAULT_CHILD_STYLE_NAME_HEADER</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 2.1. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 *
		 * @see Panel#DEFAULT_CHILD_STYLE_NAME_HEADER
		 */
		public static const DEFAULT_CHILD_NAME_HEADER:String = DEFAULT_CHILD_STYLE_NAME_HEADER;

		/**
		 * The default value added to the <code>styleNameList</code> of the footer.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_FOOTER:String = "feathers-panel-footer";

		/**
		 * DEPRECATED: Replaced by <code>Panel.DEFAULT_CHILD_STYLE_NAME_FOOTER</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 2.1. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 *
		 * @see Panel#DEFAULT_CHILD_STYLE_NAME_FOOTER
		 */
		public static const DEFAULT_CHILD_NAME_FOOTER:String = DEFAULT_CHILD_STYLE_NAME_FOOTER;

		/**
		 * @copy feathers.controls.Scroller#SCROLL_POLICY_AUTO
		 *
		 * @see feathers.controls.Scroller#horizontalScrollPolicy
		 * @see feathers.controls.Scroller#verticalScrollPolicy
		 */
		public static const SCROLL_POLICY_AUTO:String = "auto";

		/**
		 * @copy feathers.controls.Scroller#SCROLL_POLICY_ON
		 *
		 * @see feathers.controls.Scroller#horizontalScrollPolicy
		 * @see feathers.controls.Scroller#verticalScrollPolicy
		 */
		public static const SCROLL_POLICY_ON:String = "on";

		/**
		 * @copy feathers.controls.Scroller#SCROLL_POLICY_OFF
		 *
		 * @see feathers.controls.Scroller#horizontalScrollPolicy
		 * @see feathers.controls.Scroller#verticalScrollPolicy
		 */
		public static const SCROLL_POLICY_OFF:String = "off";

		/**
		 * @copy feathers.controls.Scroller#SCROLL_BAR_DISPLAY_MODE_FLOAT
		 *
		 * @see feathers.controls.Scroller#scrollBarDisplayMode
		 */
		public static const SCROLL_BAR_DISPLAY_MODE_FLOAT:String = "float";

		/**
		 * @copy feathers.controls.Scroller#SCROLL_BAR_DISPLAY_MODE_FIXED
		 *
		 * @see feathers.controls.Scroller#scrollBarDisplayMode
		 */
		public static const SCROLL_BAR_DISPLAY_MODE_FIXED:String = "fixed";

		/**
		 * @copy feathers.controls.Scroller#SCROLL_BAR_DISPLAY_MODE_NONE
		 *
		 * @see feathers.controls.Scroller#scrollBarDisplayMode
		 */
		public static const SCROLL_BAR_DISPLAY_MODE_NONE:String = "none";

		/**
		 * The vertical scroll bar will be positioned on the right.
		 *
		 * @see feathers.controls.Scroller#verticalScrollBarPosition
		 */
		public static const VERTICAL_SCROLL_BAR_POSITION_RIGHT:String = "right";

		/**
		 * The vertical scroll bar will be positioned on the left.
		 *
		 * @see feathers.controls.Scroller#verticalScrollBarPosition
		 */
		public static const VERTICAL_SCROLL_BAR_POSITION_LEFT:String = "left";

		/**
		 * @copy feathers.controls.Scroller#INTERACTION_MODE_TOUCH
		 *
		 * @see feathers.controls.Scroller#interactionMode
		 */
		public static const INTERACTION_MODE_TOUCH:String = "touch";

		/**
		 * @copy feathers.controls.Scroller#INTERACTION_MODE_MOUSE
		 *
		 * @see feathers.controls.Scroller#interactionMode
		 */
		public static const INTERACTION_MODE_MOUSE:String = "mouse";

		/**
		 * @copy feathers.controls.Scroller#INTERACTION_MODE_TOUCH_AND_SCROLL_BARS
		 *
		 * @see feathers.controls.Scroller#interactionMode
		 */
		public static const INTERACTION_MODE_TOUCH_AND_SCROLL_BARS:String = "touchAndScrollBars";

		/**
		 * @copy feathers.controls.Scroller#MOUSE_WHEEL_SCROLL_DIRECTION_VERTICAL
		 *
		 * @see feathers.controls.Scroller#verticalMouseWheelScrollDirection
		 */
		public static const MOUSE_WHEEL_SCROLL_DIRECTION_VERTICAL:String = "vertical";

		/**
		 * @copy feathers.controls.Scroller#MOUSE_WHEEL_SCROLL_DIRECTION_HORIZONTAL
		 *
		 * @see feathers.controls.Scroller#verticalMouseWheelScrollDirection
		 */
		public static const MOUSE_WHEEL_SCROLL_DIRECTION_HORIZONTAL:String = "horizontal";

		/**
		 * @copy feathers.controls.Scroller#DECELERATION_RATE_NORMAL
		 *
		 * @see feathers.controls.Scroller#decelerationRate
		 */
		public static const DECELERATION_RATE_NORMAL:Number = 0.998;

		/**
		 * @copy feathers.controls.Scroller#DECELERATION_RATE_FAST
		 *
		 * @see feathers.controls.Scroller#decelerationRate
		 */
		public static const DECELERATION_RATE_FAST:Number = 0.99;

		/**
		 * @copy feathers.controls.ScrollContainer#AUTO_SIZE_MODE_STAGE
		 *
		 * @see feathers.controls.ScrollContainer#autoSizeMode
		 */
		public static const AUTO_SIZE_MODE_STAGE:String = "stage";

		/**
		 * @copy feathers.controls.ScrollContainer#AUTO_SIZE_MODE_CONTENT
		 *
		 * @see feathers.controls.ScrollContainer#autoSizeMode
		 */
		public static const AUTO_SIZE_MODE_CONTENT:String = "content";

		/**
		 * The default <code>IStyleProvider</code> for all <code>Panel</code>
		 * components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_HEADER_FACTORY:String = "headerFactory";

		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_FOOTER_FACTORY:String = "footerFactory";

		/**
		 * @private
		 */
		protected static function defaultHeaderFactory():IFeathersControl
		{
			return new Header();
		}

		/**
		 * Constructor.
		 */
		public function Panel()
		{
			super();
		}

		/**
		 * The header sub-component.
		 *
		 * <p>For internal use in subclasses.</p>
		 *
		 * @see #headerFactory
		 * @see #createHeader()
		 */
		protected var header:IFeathersControl;

		/**
		 * The footer sub-component.
		 *
		 * <p>For internal use in subclasses.</p>
		 *
		 * @see #footerFactory
		 * @see #createFooter()
		 */
		protected var footer:IFeathersControl;

		/**
		 * The default value added to the <code>styleNameList</code> of the
		 * header. This variable is <code>protected</code> so that sub-classes
		 * can customize the header style name in their constructors instead of
		 * using the default style name defined by
		 * <code>DEFAULT_CHILD_STYLE_NAME_HEADER</code>.
		 *
		 * <p>To customize the header style name without subclassing, see
		 * <code>customHeaderStyleName</code>.</p>
		 *
		 * @see #customHeaderStyleName
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var headerStyleName:String = DEFAULT_CHILD_STYLE_NAME_HEADER;

		/**
		 * DEPRECATED: Replaced by <code>headerStyleName</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 2.1. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 *
		 * @see #headerStyleName
		 */
		protected function get headerName():String
		{
			return this.headerStyleName;
		}

		/**
		 * @private
		 */
		protected function set headerName(value:String):void
		{
			this.headerStyleName = value;
		}

		/**
		 * The default value added to the <code>styleNameList</code> of the
		 * footer. This variable is <code>protected</code> so that sub-classes
		 * can customize the footer style name in their constructors instead of
		 * using the default style name defined by
		 * <code>DEFAULT_CHILD_STYLE_NAME_FOOTER</code>.
		 *
		 * <p>To customize the footer style name without subclassing, see
		 * <code>customFooterStyleName</code>.</p>
		 *
		 * @see #customFooterStyleName
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var footerStyleName:String = DEFAULT_CHILD_STYLE_NAME_FOOTER;

		/**
		 * DEPRECATED: Replaced by <code>footerStyleName</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 2.1. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 *
		 * @see #footerStyleName
		 */
		protected function get footerName():String
		{
			return this.footerStyleName;
		}

		/**
		 * @private
		 */
		protected function set footerName(value:String):void
		{
			this.footerStyleName = value;
		}

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return Panel.globalStyleProvider;
		}

		/**
		 * @private
		 */
		protected var _title:String = null;

		/**
		 * The panel's title to display in the header.
		 *
		 * <p>By default, this value is passed to the <code>title</code>
		 * property of the header, if that property exists. However, if the
		 * header is not a <code>feathers.controls.Header</code> instance,
		 * changing the value of <code>titleField</code> will allow the panel to
		 * pass its title to a different property on the header instead.</p>
		 *
		 * <p>In the following example, a custom header factory is provided to
		 * the panel:</p>
		 *
		 * <listing version="3.0">
		 * panel.title = "Settings";</listing>
		 *
		 * @default null
		 *
		 * @see #headerTitleField
		 * @see #headerFactory
		 */
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
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}


		/**
		 * @private
		 */
		protected var _headerTitleField:String = "title";

		/**
		 * A property of the header that should be used to display the panel's
		 * title.
		 *
		 * <p>By default, this value is passed to the <code>title</code>
		 * property of the header, if that property exists. However, if the
		 * header is not a <code>feathers.controls.Header</code> instance,
		 * changing the value of <code>titleField</code> will allow the panel to
		 * pass the title to a different property name instead.</p>
		 *
		 * <p>In the following example, a <code>Button</code> is used as a
		 * custom header, and the title is passed to its <code>label</code>
		 * property:</p>
		 *
		 * <listing version="3.0">
		 * panel.headerFactory = function():IFeathersControl
		 * {
		 *     return new Button();
		 * };
		 * panel.titleField = "label";</listing>
		 *
		 * @default "title"
		 *
		 * @see #title
		 * @see #headerFactory
		 */
		public function get headerTitleField():String
		{
			return this._headerTitleField;
		}

		/**
		 * @private
		 */
		public function set headerTitleField(value:String):void
		{
			if(this._headerTitleField == value)
			{
				return;
			}
			this._headerTitleField = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _headerFactory:Function;

		/**
		 * A function used to generate the panel's header sub-component.
		 * The header must be an instance of <code>IFeathersControl</code>, but
		 * the default is an instance of <code>Header</code>. This factory can
		 * be used to change properties on the header when it is first
		 * created. For instance, if you are skinning Feathers components
		 * without a theme, you might use this factory to set skins and other
		 * styles on the header.
		 *
		 * <p>The function should have the following signature:</p>
		 * <pre>function():IFeathersControl</pre>
		 *
		 * <p>In the following example, a custom header factory is provided to
		 * the panel:</p>
		 *
		 * <listing version="3.0">
		 * panel.headerFactory = function():IFeathersControl
		 * {
		 *     var header:Header = new Header();
		 *     var closeButton:Button = new Button();
		 *     closeButton.label = "Close";
		 *     closeButton.addEventListener( Event.TRIGGERED, closeButton_triggeredHandler );
		 *     header.rightItems = new &lt;DisplayObject&gt;[ closeButton ];
		 *     return header;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.Header
		 * @see #headerProperties
		 */
		public function get headerFactory():Function
		{
			return this._headerFactory;
		}

		/**
		 * @private
		 */
		public function set headerFactory(value:Function):void
		{
			if(this._headerFactory == value)
			{
				return;
			}
			this._headerFactory = value;
			this.invalidate(INVALIDATION_FLAG_HEADER_FACTORY);
			//hack because the super class doesn't know anything about the
			//header factory
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		/**
		 * @private
		 */
		protected var _customHeaderStyleName:String;

		/**
		 * A style name to add to the panel's header sub-component. Typically
		 * used by a theme to provide different styles to different panels.
		 *
		 * <p>In the following example, a custom header style name is passed to
		 * the panel:</p>
		 *
		 * <listing version="3.0">
		 * panel.customHeaderStyleName = "my-custom-header";</listing>
		 *
		 * <p>In your theme, you can target this sub-component style name to
		 * provide different styles than the default (this example assumes that the
		 * header is a <code>Header</code>, but it can be any
		 * <code>IFeathersControl</code>):</p>
		 *
		 * <listing version="3.0">
		 * getStyleProviderForClass( Header ).setFunctionForStyleName( "my-custom-header", setCustomHeaderStyles );</listing>
		 *
		 * @default null
		 *
		 * @see #DEFAULT_CHILD_STYLE_NAME_HEADER
		 * @see feathers.core.FeathersControl#styleNameList
		 * @see #headerFactory
		 * @see #headerProperties
		 */
		public function get customHeaderStyleName():String
		{
			return this._customHeaderStyleName;
		}

		/**
		 * @private
		 */
		public function set customHeaderStyleName(value:String):void
		{
			if(this._customHeaderStyleName == value)
			{
				return;
			}
			this._customHeaderStyleName = value;
			this.invalidate(INVALIDATION_FLAG_HEADER_FACTORY);
			//hack because the super class doesn't know anything about the
			//header factory
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		/**
		 * DEPRECATED: Replaced by <code>customHeaderStyleName</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 2.1. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 *
		 * @see #customHeaderStyleName
		 */
		public function get customHeaderName():String
		{
			return this.customHeaderStyleName;
		}

		/**
		 * @private
		 */
		public function set customHeaderName(value:String):void
		{
			this.customHeaderStyleName = value;
		}

		/**
		 * @private
		 */
		protected var _headerProperties:PropertyProxy;

		/**
		 * An object that stores properties for the container's header
		 * sub-component, and the properties will be passed down to the header
		 * when the container validates. Any Feathers component may be used as
		 * the container's header, so the available properties depend on which
		 * type of component is returned by <code>headerFactory</code>.
		 *
		 * <p>By default, the <code>headerFactory</code> will return a
		 * <code>Header</code> instance. If you aren't using a different type of
		 * component as the container's header, you can refer to
		 * <a href="Header.html"><code>feathers.controls.Header</code></a>
		 * for a list of available properties. Otherwise, refer to the
		 * appropriate documentation for details about which properties are
		 * available on the component that you're using as the header.</p>
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
		 * which is in a <code>List</code>, you can use the following syntax:</p>
		 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * <p>Setting properties in a <code>headerFactory</code> function
		 * instead of using <code>headerProperties</code> will result in better
		 * performance.</p>
		 *
		 * <p>In the following example, the header properties are customized:</p>
		 *
		 * <listing version="3.0">
		 * var closeButton:Button = new Button();
		 * closeButton.label = "Close";
		 * closeButton.addEventListener( Event.TRIGGERED, closeButton_triggeredHandler );
		 * panel.headerProperties.rightItems = new &lt;DisplayObject&gt;[ closeButton ];</listing>
		 *
		 * @default null
		 *
		 * @see #headerFactory
		 * @see feathers.controls.Header
		 */
		public function get headerProperties():Object
		{
			if(!this._headerProperties)
			{
				this._headerProperties = new PropertyProxy(childProperties_onChange);
			}
			return this._headerProperties;
		}

		/**
		 * @private
		 */
		public function set headerProperties(value:Object):void
		{
			if(this._headerProperties == value)
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
			if(this._headerProperties)
			{
				this._headerProperties.removeOnChangeCallback(childProperties_onChange);
			}
			this._headerProperties = PropertyProxy(value);
			if(this._headerProperties)
			{
				this._headerProperties.addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _footerFactory:Function;

		/**
		 * A function used to generate the panel's footer sub-component.
		 * The footer must be an instance of <code>IFeathersControl</code>, and
		 * by default, there is no footer. This factory can be used to change
		 * properties on the footer when it is first created. For instance, if
		 * you are skinning Feathers components without a theme, you might use
		 * this factory to set skins and other styles on the footer.
		 *
		 * <p>The function should have the following signature:</p>
		 * <pre>function():IFeathersControl</pre>
		 *
		 * <p>In the following example, a custom footer factory is provided to
		 * the panel:</p>
		 *
		 * <listing version="3.0">
		 * panel.footerFactory = function():IFeathersControl
		 * {
		 *     return new ScrollContainer();
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.core.FeathersControl
		 * @see #footerProperties
		 */
		public function get footerFactory():Function
		{
			return this._footerFactory;
		}

		/**
		 * @private
		 */
		public function set footerFactory(value:Function):void
		{
			if(this._footerFactory == value)
			{
				return;
			}
			this._footerFactory = value;
			this.invalidate(INVALIDATION_FLAG_FOOTER_FACTORY);
			//hack because the super class doesn't know anything about the
			//header factory
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		/**
		 * @private
		 */
		protected var _customFooterStyleName:String;

		/**
		 * A style name to add to the panel's footer sub-component. Typically
		 * used by a theme to provide different styles to different panels.
		 *
		 * <p>In the following example, a custom footer style name is passed to
		 * the panel:</p>
		 *
		 * <listing version="3.0">
		 * panel.customFooterStyleName = "my-custom-footer";</listing>
		 *
		 * <p>In your theme, you can target this sub-component style name to
		 * provide different styles than the default (this example assumes that the
		 * footer is a <code>ScrollContainer</code>, but it can be any
		 * <code>IFeathersControl</code>):</p>
		 *
		 * <listing version="3.0">
		 * getStyleProviderForClass( ScrollContainer ).setFunctionForStyleName( "my-custom-footer", setCustomFooterStyles );</listing>
		 *
		 * @default null
		 *
		 * @see #DEFAULT_CHILD_STYLE_NAME_FOOTER
		 * @see feathers.core.FeathersControl#styleNameList
		 * @see #footerFactory
		 * @see #footerProperties
		 */
		public function get customFooterStyleName():String
		{
			return this._customFooterStyleName;
		}

		/**
		 * @private
		 */
		public function set customFooterStyleName(value:String):void
		{
			if(this._customFooterStyleName == value)
			{
				return;
			}
			this._customFooterStyleName = value;
			this.invalidate(INVALIDATION_FLAG_FOOTER_FACTORY);
			//hack because the super class doesn't know anything about the
			//header factory
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		/**
		 * DEPRECATED: Replaced by <code>customFooterStyleName</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 2.1. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 *
		 * @see #customFooterStyleName
		 */
		public function get customFooterName():String
		{
			return this.customFooterStyleName;
		}

		/**
		 * @private
		 */
		public function set customFooterName(value:String):void
		{
			this.customFooterStyleName = value;
		}

		/**
		 * @private
		 */
		protected var _footerProperties:PropertyProxy;

		/**
		 * An object that stores properties for the container's footer
		 * sub-component, and the properties will be passed down to the footer
		 * when the container validates. Any Feathers component may be used as
		 * the container's footer, so the available properties depend on which
		 * type of component is returned by <code>footerFactory</code>. Refer to
		 * the appropriate documentation for details about which properties are
		 * available on the component that you're using as the footer.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
		 * which is in a <code>List</code>, you can use the following syntax:</p>
		 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * <p>Setting properties in a <code>footerFactory</code> function
		 * instead of using <code>footerProperties</code> will result in better
		 * performance.</p>
		 *
		 * <p>In the following example, the footer properties are customized:</p>
		 *
		 * <listing version="3.0">
		 * panel.footerProperties.verticalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;</listing>
		 *
		 * @default null
		 *
		 * @see #footerFactory
		 */
		public function get footerProperties():Object
		{
			if(!this._footerProperties)
			{
				this._footerProperties = new PropertyProxy(childProperties_onChange);
			}
			return this._footerProperties;
		}

		/**
		 * @private
		 */
		public function set footerProperties(value:Object):void
		{
			if(this._footerProperties == value)
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
			if(this._footerProperties)
			{
				this._footerProperties.removeOnChangeCallback(childProperties_onChange);
			}
			this._footerProperties = PropertyProxy(value);
			if(this._footerProperties)
			{
				this._footerProperties.addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _focusExtrasBefore:Vector.<DisplayObject> = new <DisplayObject>[];

		/**
		 * @inheritDoc
		 */
		public function get focusExtrasBefore():Vector.<DisplayObject>
		{
			return this._focusExtrasBefore;
		}

		/**
		 * @private
		 */
		private var _focusExtrasAfter:Vector.<DisplayObject> = new <DisplayObject>[];

		/**
		 * @inheritDoc
		 */
		public function get focusExtrasAfter():Vector.<DisplayObject>
		{
			return this._focusExtrasAfter;
		}

		/**
		 * Quickly sets all outer padding properties to the same value. The
		 * <code>outerPadding</code> getter always returns the value of
		 * <code>outerPaddingTop</code>, but the other padding values may be
		 * different.
		 *
		 * <p>In the following example, the outer padding is set to 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * panel.outerPadding = 20;</listing>
		 *
		 * @default 0
		 *
		 * @see #outerPaddingTop
		 * @see #outerPaddingRight
		 * @see #outerPaddingBottom
		 * @see #outerPaddingLeft
		 * @see feathers.controls.Scroller#padding
		 */
		public function get outerPadding():Number
		{
			return this._outerPaddingTop;
		}

		/**
		 * @private
		 */
		public function set outerPadding(value:Number):void
		{
			this.outerPaddingTop = value;
			this.outerPaddingRight = value;
			this.outerPaddingBottom = value;
			this.outerPaddingLeft = value;
		}

		/**
		 * @private
		 */
		protected var _outerPaddingTop:Number = 0;

		/**
		 * The minimum space, in pixels, between the panel's top edge and the
		 * panel's header.
		 *
		 * <p>Note: The <code>paddingTop</code> property applies to the
		 * middle content only, and it does not affect the header. Use
		 * <code>outerPaddingTop</code> if you want to include padding above
		 * the header. <code>outerPaddingTop</code> and <code>paddingTop</code>
		 * may be used simultaneously to define padding around the outer edges
		 * of the panel and additional padding around its middle content.</p>
		 *
		 * <p>In the following example, the top padding is set to 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * panel.outerPaddingTop = 20;</listing>
		 *
		 * @default 0
		 *
		 * @see feathers.controls.Scroller#paddingTop
		 */
		public function get outerPaddingTop():Number
		{
			return this._outerPaddingTop;
		}

		/**
		 * @private
		 */
		public function set outerPaddingTop(value:Number):void
		{
			if(this._outerPaddingTop == value)
			{
				return;
			}
			this._outerPaddingTop = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _outerPaddingRight:Number = 0;

		/**
		 * The minimum space, in pixels, between the panel's right edge and the
		 * panel's header, middle content, and footer.
		 *
		 * <p>Note: The <code>paddingRight</code> property applies to the middle
		 * content only, and it does not affect the header or footer. Use
		 * <code>outerPaddingRight</code> if you want to include padding around
		 * the header and footer too. <code>outerPaddingRight</code> and
		 * <code>paddingRight</code> may be used simultaneously to define
		 * padding around the outer edges of the panel plus additional padding
		 * around its middle content.</p>
		 *
		 * <p>In the following example, the right outer padding is set to 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * panel.outerPaddingRight = 20;</listing>
		 *
		 * @default 0
		 *
		 * @see feathers.controls.Scroller#paddingRight
		 */
		public function get outerPaddingRight():Number
		{
			return this._outerPaddingRight;
		}

		/**
		 * @private
		 */
		public function set outerPaddingRight(value:Number):void
		{
			if(this._outerPaddingRight == value)
			{
				return;
			}
			this._outerPaddingRight = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _outerPaddingBottom:Number = 0;

		/**
		 * The minimum space, in pixels, between the panel's bottom edge and the
		 * panel's footer.
		 *
		 * <p>Note: The <code>paddingBottom</code> property applies to the
		 * middle content only, and it does not affect the footer. Use
		 * <code>outerPaddingBottom</code> if you want to include padding below
		 * the footer. <code>outerPaddingBottom</code> and <code>paddingBottom</code>
		 * may be used simultaneously to define padding around the outer edges
		 * of the panel and additional padding around its middle content.</p>
		 *
		 * <p>In the following example, the bottom outer padding is set to 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * panel.outerPaddingBottom = 20;</listing>
		 *
		 * @default 0
		 *
		 * @see feathers.controls.Scroller#paddingBottom
		 */
		public function get outerPaddingBottom():Number
		{
			return this._outerPaddingBottom;
		}

		/**
		 * @private
		 */
		public function set outerPaddingBottom(value:Number):void
		{
			if(this._outerPaddingBottom == value)
			{
				return;
			}
			this._outerPaddingBottom = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _outerPaddingLeft:Number = 0;

		/**
		 * The minimum space, in pixels, between the panel's left edge and the
		 * panel's header, middle content, and footer.
		 *
		 * <p>Note: The <code>paddingLeft</code> property applies to the middle
		 * content only, and it does not affect the header or footer. Use
		 * <code>outerPaddingLeft</code> if you want to include padding around
		 * the header and footer too. <code>outerPaddingLeft</code> and
		 * <code>paddingLeft</code> may be used simultaneously to define padding
		 * around the outer edges of the panel and additional padding around its
		 * middle content.</p>
		 *
		 * <p>In the following example, the left outer padding is set to 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * scroller.outerPaddingLeft = 20;</listing>
		 *
		 * @default 0
		 *
		 * @see feathers.controls.Scroller#paddingLeft
		 */
		public function get outerPaddingLeft():Number
		{
			return this._outerPaddingLeft;
		}

		/**
		 * @private
		 */
		public function set outerPaddingLeft(value:Number):void
		{
			if(this._outerPaddingLeft == value)
			{
				return;
			}
			this._outerPaddingLeft = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _ignoreHeaderResizing:Boolean = false;

		/**
		 * @private
		 */
		protected var _ignoreFooterResizing:Boolean = false;

		/**
		 * @private
		 */
		override protected function draw():void
		{
			var headerFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_HEADER_FACTORY);
			var footerFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_FOOTER_FACTORY);
			var stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);

			if(headerFactoryInvalid)
			{
				this.createHeader();
			}

			if(footerFactoryInvalid)
			{
				this.createFooter();
			}

			if(headerFactoryInvalid || stylesInvalid)
			{
				this.refreshHeaderStyles();
			}

			if(footerFactoryInvalid || stylesInvalid)
			{
				this.refreshFooterStyles();
			}

			super.draw();
		}

		/**
		 * @inheritDoc
		 */
		override protected function autoSizeIfNeeded():Boolean
		{
			var needsWidth:Boolean = this.explicitWidth !== this.explicitWidth; //isNaN
			var needsHeight:Boolean = this.explicitHeight !== this.explicitHeight; //isNaN
			if(!needsWidth && !needsHeight)
			{
				return false;
			}
			if(this._autoSizeMode == AUTO_SIZE_MODE_STAGE)
			{
				return this.setSizeInternal(this.stage.stageWidth, this.stage.stageHeight, false);
			}

			var oldIgnoreHeaderResizing:Boolean = this._ignoreHeaderResizing;
			this._ignoreHeaderResizing = true;
			var oldIgnoreFooterResizing:Boolean = this._ignoreFooterResizing;
			this._ignoreFooterResizing = true;

			var oldHeaderWidth:Number = this.header.width;
			var oldHeaderHeight:Number = this.header.height;
			this.header.width = this.explicitWidth;
			this.header.maxWidth = this._maxWidth;
			this.header.height = NaN;
			this.header.validate();

			if(this.footer)
			{
				var oldFooterWidth:Number = this.footer.width;
				var oldFooterHeight:Number = this.footer.height;
				this.footer.width = this.explicitWidth;
				this.footer.maxWidth = this._maxWidth;
				this.footer.height = NaN;
				this.footer.validate();
			}

			var newWidth:Number = this.explicitWidth;
			var newHeight:Number = this.explicitHeight;
			if(needsWidth)
			{
				newWidth = Math.max(this.header.width, this._viewPort.width + this._rightViewPortOffset + this._leftViewPortOffset);
				if(this.footer)
				{
					newWidth = Math.max(newWidth, this.footer.width);
				}
				if(this.originalBackgroundWidth === this.originalBackgroundWidth) //!isNaN
				{
					newWidth = Math.max(newWidth, this.originalBackgroundWidth);
				}
			}
			if(needsHeight)
			{
				newHeight = this._viewPort.height + this._bottomViewPortOffset + this._topViewPortOffset;
				if(this.originalBackgroundHeight === this.originalBackgroundHeight) //!isNaN
				{
					newHeight = Math.max(newHeight, this.originalBackgroundHeight);
				}
			}

			this.header.width = oldHeaderWidth;
			this.header.height = oldHeaderHeight;
			if(this.footer)
			{
				this.footer.width = oldFooterWidth;
				this.footer.height = oldFooterHeight;
			}
			this._ignoreHeaderResizing = oldIgnoreHeaderResizing;
			this._ignoreFooterResizing = oldIgnoreFooterResizing;

			return this.setSizeInternal(newWidth, newHeight, false);
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
		 * @see #customHeaderStyleName
		 */
		protected function createHeader():void
		{
			if(this.header)
			{
				this.header.removeEventListener(FeathersEventType.RESIZE, header_resizeHandler);
				var displayHeader:DisplayObject = DisplayObject(this.header);
				this._focusExtrasBefore.splice(this._focusExtrasBefore.indexOf(displayHeader), 1);
				this.removeRawChild(displayHeader, true);
				this.header = null;
			}

			var factory:Function = this._headerFactory != null ? this._headerFactory : defaultHeaderFactory;
			var headerStyleName:String = this._customHeaderStyleName != null ? this._customHeaderStyleName : this.headerStyleName;
			this.header = IFeathersControl(factory());
			this.header.styleNameList.add(headerStyleName);
			this.header.addEventListener(FeathersEventType.RESIZE, header_resizeHandler);
			displayHeader = DisplayObject(this.header);
			this.addRawChild(displayHeader);
			this._focusExtrasBefore.push(displayHeader);
		}

		/**
		 * Creates and adds the <code>footer</code> sub-component and
		 * removes the old instance, if one exists.
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 *
		 * @see #footer
		 * @see #footerFactory
		 * @see #customFooterStyleName
		 */
		protected function createFooter():void
		{
			if(this.footer)
			{
				this.footer.removeEventListener(FeathersEventType.RESIZE, footer_resizeHandler);
				var displayFooter:DisplayObject = DisplayObject(this.footer);
				this._focusExtrasAfter.splice(this._focusExtrasAfter.indexOf(displayFooter), 1);
				this.removeRawChild(displayFooter, true);
				this.footer = null;
			}

			if(this._footerFactory == null)
			{
				return;
			}
			var footerStyleName:String = this._customFooterStyleName != null ? this._customFooterStyleName : this.footerStyleName;
			this.footer = IFeathersControl(this._footerFactory());
			this.footer.styleNameList.add(footerStyleName);
			this.footer.addEventListener(FeathersEventType.RESIZE, footer_resizeHandler);
			displayFooter = DisplayObject(this.footer);
			this.addRawChild(displayFooter);
			this._focusExtrasAfter.push(displayFooter);
		}

		/**
		 * @private
		 */
		protected function refreshHeaderStyles():void
		{
			if(Object(this.header).hasOwnProperty(this._headerTitleField))
			{
				this.header[this._headerTitleField] = this._title;
			}
			for(var propertyName:String in this._headerProperties)
			{
				var propertyValue:Object = this._headerProperties[propertyName];
				this.header[propertyName] = propertyValue;
			}
		}

		/**
		 * @private
		 */
		protected function refreshFooterStyles():void
		{
			for(var propertyName:String in this._footerProperties)
			{
				var propertyValue:Object = this._footerProperties[propertyName];
				this.footer[propertyName] = propertyValue;
			}
		}

		/**
		 * @private
		 */
		override protected function calculateViewPortOffsets(forceScrollBars:Boolean = false, useActualBounds:Boolean = false):void
		{
			super.calculateViewPortOffsets(forceScrollBars);

			this._leftViewPortOffset += this._outerPaddingLeft;
			this._rightViewPortOffset += this._outerPaddingRight;

			var oldIgnoreHeaderResizing:Boolean = this._ignoreHeaderResizing;
			this._ignoreHeaderResizing = true;
			var oldHeaderWidth:Number = this.header.width;
			var oldHeaderHeight:Number = this.header.height;
			if(useActualBounds)
			{
				this.header.width = this.actualWidth - this._outerPaddingLeft - this._outerPaddingRight;
			}
			else
			{
				this.header.width = this.explicitWidth - this._outerPaddingLeft - this._outerPaddingRight;
			}
			this.header.maxWidth = this._maxWidth - this._outerPaddingLeft - this._outerPaddingRight;
			this.header.height = NaN;
			this.header.validate();
			this._topViewPortOffset += this.header.height + this._outerPaddingTop;
			this.header.width = oldHeaderWidth;
			this.header.height = oldHeaderHeight;
			this._ignoreHeaderResizing = oldIgnoreHeaderResizing;

			if(this.footer)
			{
				var oldIgnoreFooterResizing:Boolean = this._ignoreFooterResizing;
				this._ignoreFooterResizing = true;
				var oldFooterWidth:Number = this.footer.width;
				var oldFooterHeight:Number = this.footer.height;
				if(useActualBounds)
				{
					this.footer.width = this.actualWidth - this._outerPaddingLeft - this._outerPaddingRight;
				}
				else
				{
					this.header.width = this.explicitWidth - this._outerPaddingLeft - this._outerPaddingRight;
				}
				this.footer.maxWidth = this._maxWidth - this._outerPaddingLeft - this._outerPaddingRight;
				this.footer.height = NaN;
				this.footer.validate();
				this._bottomViewPortOffset += this.footer.height + this._outerPaddingBottom;
				this.footer.width = oldFooterWidth;
				this.footer.height = oldFooterHeight;
				this._ignoreFooterResizing = oldIgnoreFooterResizing;
			}
			else
			{
				this._bottomViewPortOffset += this._outerPaddingBottom;
			}
		}

		/**
		 * @private
		 */
		override protected function layoutChildren():void
		{
			super.layoutChildren();

			var oldIgnoreHeaderResizing:Boolean = this._ignoreHeaderResizing;
			this._ignoreHeaderResizing = true;
			this.header.x = this._outerPaddingLeft;
			this.header.y = this._outerPaddingTop;
			this.header.width = this.actualWidth - this._outerPaddingLeft - this._outerPaddingRight;
			this.header.height = NaN;
			this.header.validate();
			this._ignoreHeaderResizing = oldIgnoreHeaderResizing;

			if(this.footer)
			{
				var oldIgnoreFooterResizing:Boolean = this._ignoreFooterResizing;
				this._ignoreFooterResizing = true;
				this.footer.x = this._outerPaddingLeft;
				this.footer.width = this.actualWidth - this._outerPaddingLeft - this._outerPaddingRight;
				this.footer.height = NaN;
				this.footer.validate();
				this.footer.y = this.actualHeight - this.footer.height - this._outerPaddingBottom;
				this._ignoreFooterResizing = oldIgnoreFooterResizing;
			}
		}

		/**
		 * @private
		 */
		protected function header_resizeHandler(event:Event):void
		{
			if(this._ignoreHeaderResizing)
			{
				return;
			}
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		/**
		 * @private
		 */
		protected function footer_resizeHandler(event:Event):void
		{
			if(this._ignoreFooterResizing)
			{
				return;
			}
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}
	}
}
