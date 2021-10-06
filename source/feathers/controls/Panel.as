/*
Feathers
Copyright 2012-2021 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.core.IFeathersControl;
	import feathers.core.IFocusExtras;
	import feathers.core.IMeasureDisplayObject;
	import feathers.core.IValidating;
	import feathers.core.PropertyProxy;
	import feathers.events.FeathersEventType;
	import feathers.skins.IStyleProvider;
	import feathers.utils.skins.resetFluidChildDimensionsForMeasurement;

	import starling.display.DisplayObject;
	import starling.events.Event;

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
	 */
	[Style(name="customHeaderStyleName",type="String")]

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
	 */
	[Style(name="customFooterStyleName",type="String")]

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
	 * @see #style:outerPaddingTop
	 * @see #style:outerPaddingRight
	 * @see #style:outerPaddingBottom
	 * @see #style:outerPaddingLeft
	 * @see feathers.controls.Scroller#style:padding
	 */
	[Style(name="outerPadding",type="Number")]

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
	 * @see #style:outerPadding
	 * @see feathers.controls.Scroller#style:paddingTop
	 */
	[Style(name="outerPaddingTop",type="Number")]

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
	 * @see #style:outerPadding
	 * @see feathers.controls.Scroller#style:paddingRight
	 */
	[Style(name="outerPaddingRight",type="Number")]

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
	 * @see #style:outerPadding
	 * @see feathers.controls.Scroller#style:paddingBottom
	 */
	[Style(name="outerPaddingBottom",type="Number")]

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
	 * @see #style:outerPadding
	 * @see feathers.controls.Scroller#style:paddingLeft
	 */
	[Style(name="outerPaddingLeft",type="Number")]

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
	 *
	 * @productversion Feathers 1.1.0
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
		 * The default value added to the <code>styleNameList</code> of the footer.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_FOOTER:String = "feathers-panel-footer";

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
		 * @see #style:customHeaderStyleName
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var headerStyleName:String = DEFAULT_CHILD_STYLE_NAME_HEADER;

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
		 * @see #style:customFooterStyleName
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var footerStyleName:String = DEFAULT_CHILD_STYLE_NAME_FOOTER;

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
		protected var _explicitHeaderWidth:Number;

		/**
		 * @private
		 */
		protected var _explicitHeaderHeight:Number;

		/**
		 * @private
		 */
		protected var _explicitHeaderMinWidth:Number;

		/**
		 * @private
		 */
		protected var _explicitHeaderMinHeight:Number;

		/**
		 * @private
		 */
		protected var _explicitFooterWidth:Number;

		/**
		 * @private
		 */
		protected var _explicitFooterHeight:Number;

		/**
		 * @private
		 */
		protected var _explicitFooterMinWidth:Number;

		/**
		 * @private
		 */
		protected var _explicitFooterMinHeight:Number;

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
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._customHeaderStyleName === value)
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
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._customFooterStyleName === value)
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
		 * panel.footerProperties.verticalScrollPolicy = ScrollPolicy.OFF;</listing>
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
		 * @private
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
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
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
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
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
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
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
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
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
			if(this._autoSizeMode === AutoSizeMode.STAGE)
			{
				//the implementation in ScrollContainer can handle this
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
		protected function createHeader():void
		{
			if(this.header !== null)
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
			displayHeader = DisplayObject(this.header);
			this.addRawChild(displayHeader);
			this._focusExtrasBefore.push(displayHeader);
			this.header.addEventListener(FeathersEventType.RESIZE, header_resizeHandler);

			this.header.initializeNow();
			this._explicitHeaderWidth = this.header.explicitWidth;
			this._explicitHeaderHeight = this.header.explicitHeight;
			this._explicitHeaderMinWidth = this.header.explicitMinWidth;
			this._explicitHeaderMinHeight = this.header.explicitMinHeight;
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
		 * @see #style:customFooterStyleName
		 */
		protected function createFooter():void
		{
			if(this.footer !== null)
			{
				this.footer.removeEventListener(FeathersEventType.RESIZE, footer_resizeHandler);
				var displayFooter:DisplayObject = DisplayObject(this.footer);
				this._focusExtrasAfter.splice(this._focusExtrasAfter.indexOf(displayFooter), 1);
				this.removeRawChild(displayFooter, true);
				this.footer = null;
			}

			if(this._footerFactory === null)
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

			this.footer.initializeNow();
			this._explicitFooterWidth = this.footer.explicitWidth;
			this._explicitFooterHeight = this.footer.explicitHeight;
			this._explicitFooterMinWidth = this.footer.explicitMinWidth;
			this._explicitFooterMinHeight = this.footer.explicitMinHeight;
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
			if(useActualBounds)
			{
				this.header.width = this.actualWidth - this._outerPaddingLeft - this._outerPaddingRight;
				this.header.minWidth = this.actualMinWidth - this._outerPaddingLeft - this._outerPaddingRight;
			}
			else
			{
				this.header.width = this._explicitWidth - this._outerPaddingLeft - this._outerPaddingRight;
				this.header.minWidth = this._explicitMinWidth - this._outerPaddingLeft - this._outerPaddingRight;
			}
			this.header.maxWidth = this._explicitMaxWidth - this._outerPaddingLeft - this._outerPaddingRight;
			this.header.height = this._explicitHeaderHeight;
			this.header.minHeight = this._explicitHeaderMinHeight;
			this.header.validate();
			this._topViewPortOffset += this.header.height + this._outerPaddingTop;
			this._ignoreHeaderResizing = oldIgnoreHeaderResizing;

			if(this.footer !== null)
			{
				var oldIgnoreFooterResizing:Boolean = this._ignoreFooterResizing;
				this._ignoreFooterResizing = true;
				if(useActualBounds)
				{
					this.footer.width = this.actualWidth - this._outerPaddingLeft - this._outerPaddingRight;
					this.footer.minWidth = this.actualMinWidth - this._outerPaddingLeft - this._outerPaddingRight;
				}
				else
				{
					this.footer.width = this._explicitWidth - this._outerPaddingLeft - this._outerPaddingRight;
					this.footer.minWidth = this._explicitMinWidth - this._outerPaddingLeft - this._outerPaddingRight;
				}
				this.footer.maxWidth = this._explicitMaxWidth - this._outerPaddingLeft - this._outerPaddingRight;
				this.footer.height = this._explicitFooterHeight;
				this.footer.minHeight = this._explicitFooterMinHeight;
				this.footer.validate();
				this._bottomViewPortOffset += this.footer.height + this._outerPaddingBottom;
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
			this.header.height = this._explicitHeaderHeight;
			this.header.validate();
			this._ignoreHeaderResizing = oldIgnoreHeaderResizing;

			if(this.footer !== null)
			{
				var oldIgnoreFooterResizing:Boolean = this._ignoreFooterResizing;
				this._ignoreFooterResizing = true;
				this.footer.x = this._outerPaddingLeft;
				this.footer.width = this.actualWidth - this._outerPaddingLeft - this._outerPaddingRight;
				this.footer.height = this._explicitFooterHeight;
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
