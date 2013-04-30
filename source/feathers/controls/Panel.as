/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.core.IFeathersControl;
	import feathers.core.PropertyProxy;

	import starling.display.DisplayObject;

	/**
	 * A container with layout, optional scrolling, a header, and an optional
	 * footer.
	 *
	 * <p><strong>Beta Component:</strong> This is a new component, and its APIs
	 * may need some changes between now and the next version of Feathers to
	 * account for overlooked requirements or other issues. Upgrading to future
	 * versions of Feathers may involve manual changes to your code that uses
	 * this component. The
	 * <a href="http://wiki.starling-framework.org/feathers/deprecation-policy">Feathers deprecation policy</a>
	 * will not go into effect until this component's status is upgraded from
	 * beta to stable.</p>
	 *
	 * @see http://wiki.starling-framework.org/feathers/panel
	 */
	public class Panel extends ScrollContainer
	{
		/**
		 * The default value added to the <code>nameList</code> of the header.
		 *
		 * @see feathers.core.IFeathersControl#nameList
		 */
		public static const DEFAULT_CHILD_NAME_HEADER:String = "feathers-panel-header";

		/**
		 * The default value added to the <code>nameList</code> of the footer.
		 *
		 * @see feathers.core.IFeathersControl#nameList
		 */
		public static const DEFAULT_CHILD_NAME_FOOTER:String = "feathers-panel-footer";

		/**
		 * @copy feathers.controls.Scroller#SCROLL_POLICY_AUTO
		 */
		public static const SCROLL_POLICY_AUTO:String = "auto";

		/**
		 * @copy feathers.controls.Scroller#SCROLL_POLICY_ON
		 */
		public static const SCROLL_POLICY_ON:String = "on";

		/**
		 * @copy feathers.controls.Scroller#SCROLL_POLICY_OFF
		 */
		public static const SCROLL_POLICY_OFF:String = "off";

		/**
		 * @copy feathers.controls.Scroller#SCROLL_BAR_DISPLAY_MODE_FLOAT
		 */
		public static const SCROLL_BAR_DISPLAY_MODE_FLOAT:String = "float";

		/**
		 * @copy feathers.controls.Scroller#SCROLL_BAR_DISPLAY_MODE_FIXED
		 */
		public static const SCROLL_BAR_DISPLAY_MODE_FIXED:String = "fixed";

		/**
		 * @copy feathers.controls.Scroller#SCROLL_BAR_DISPLAY_MODE_NONE
		 */
		public static const SCROLL_BAR_DISPLAY_MODE_NONE:String = "none";

		/**
		 * @copy feathers.controls.Scroller#INTERACTION_MODE_TOUCH
		 */
		public static const INTERACTION_MODE_TOUCH:String = "touch";

		/**
		 * @copy feathers.controls.Scroller#INTERACTION_MODE_MOUSE
		 */
		public static const INTERACTION_MODE_MOUSE:String = "mouse";

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
		 */
		protected var header:IFeathersControl;

		/**
		 * The footer sub-component.
		 */
		protected var footer:IFeathersControl;

		/**
		 * The default value added to the <code>nameList</code> of the header.
		 *
		 * <p>To customize the header name without subclassing, see
		 * <code>customHeaderName</code>.</p> This
		 * variable is <code>protected</code> so that sub-classes can customize
		 * the header name in their constructors instead of using the default
		 * name defined by <code>DEFAULT_CHILD_NAME_HEADER</code>.
		 *
		 * @see #customHeaderName
		 * @see feathers.core.IFeathersControl#nameList
		 */
		protected var headerName:String = DEFAULT_CHILD_NAME_HEADER;

		/**
		 * The default value added to the <code>nameList</code> of the footer. This
		 * variable is <code>protected</code> so that sub-classes can customize
		 * the footer name in their constructors instead of using the default
		 * name defined by <code>DEFAULT_CHILD_NAME_FOOTER</code>.
		 *
		 * <p>To customize the footer name without subclassing, see
		 * <code>customFooterName</code>.</p>
		 *
		 * @see #customFooterName
		 * @see feathers.core.IFeathersControl#nameList
		 */
		protected var footerName:String = DEFAULT_CHILD_NAME_FOOTER;

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
		 * @see feathers.core.IFeathersControl
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
		protected var _customHeaderName:String;

		/**
		 * A name to add to the panel's header sub-component. Typically
		 * used by a theme to provide different skins to different panels.
		 *
		 * @see #DEFAULT_CHILD_NAME_HEADER
		 * @see feathers.core.FeathersControl#nameList
		 * @see #headerFactory
		 * @see #headerProperties
		 */
		public function get customHeaderName():String
		{
			return this._customHeaderName;
		}

		/**
		 * @private
		 */
		public function set customHeaderName(value:String):void
		{
			if(this._customHeaderName == value)
			{
				return;
			}
			this._customHeaderName = value;
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
		 * A set of key/value pairs to be passed down to the container's
		 * header sub-component. The header may be any
		 * <code>feathers.core.IFeathersControl</code> instance, but the default
		 * is a <code>feathers.controls.Header</code> instance. The available
		 * properties depend on what type of component is returned by
		 * <code>footerFactory</code>.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
		 * which is in a <code>Scroller</code> which is in a <code>List</code>,
		 * you can use the following syntax:</p>
		 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * <p>Setting properties in a <code>headerFactory</code> function
		 * instead of using <code>headerProperties</code> will result in better
		 * performance.</p>
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
				const newValue:PropertyProxy = new PropertyProxy();
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
		 * @see feathers.core.IFeathersControl
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
		protected var _customFooterName:String;

		/**
		 * A name to add to the panel's footer sub-component. Typically
		 * used by a theme to provide different skins to different panels.
		 *
		 * @see #DEFAULT_CHILD_NAME_FOOTER
		 * @see feathers.core.FeathersControl#nameList
		 * @see #footerFactory
		 * @see #footerProperties
		 */
		public function get customFooterName():String
		{
			return this._customFooterName;
		}

		/**
		 * @private
		 */
		public function set customFooterName(value:String):void
		{
			if(this._customFooterName == value)
			{
				return;
			}
			this._customFooterName = value;
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
		 * A set of key/value pairs to be passed down to the container's
		 * footer sub-component. The footer may be any
		 * <code>feathers.core.IFeathersControl</code> instance, but there is no
		 * default. The available properties depend on what type of component is
		 * returned by <code>footerFactory</code>.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
		 * which is in a <code>Scroller</code> which is in a <code>List</code>,
		 * you can use the following syntax:</p>
		 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * <p>Setting properties in a <code>footerFactory</code> function
		 * instead of using <code>footerProperties</code> will result in better
		 * performance.</p>
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
				const newValue:PropertyProxy = new PropertyProxy();
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
		override protected function draw():void
		{
			const headerFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_HEADER_FACTORY);
			const footerFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_FOOTER_FACTORY);
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);

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
		 * @private
		 */
		override protected function autoSizeIfNeeded():Boolean
		{
			const needsWidth:Boolean = isNaN(this.explicitWidth);
			const needsHeight:Boolean = isNaN(this.explicitHeight);
			if(!needsWidth && !needsHeight)
			{
				return false;
			}

			const oldHeaderWidth:Number = this.header.width;
			const oldHeaderHeight:Number = this.header.height;
			this.header.width = this.explicitWidth;
			this.header.maxWidth = this._maxWidth;
			this.header.height = NaN;
			this.header.validate();

			if(this.footer)
			{
				const oldFooterWidth:Number = this.footer.width;
				const oldFooterHeight:Number = this.footer.height;
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
				if(!isNaN(this.originalBackgroundWidth))
				{
					newWidth = Math.max(newWidth, this.originalBackgroundWidth);
				}
			}
			if(needsHeight)
			{
				newHeight = this._viewPort.height + this._bottomViewPortOffset + this._topViewPortOffset;
				if(!isNaN(this.originalBackgroundHeight))
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

			return this.setSizeInternal(newWidth, newHeight, false);
		}

		/**
		 * @private
		 */
		protected function createHeader():void
		{
			const oldDisplayListBypassEnabled:Boolean = this.displayListBypassEnabled;
			this.displayListBypassEnabled = false;
			if(this.header)
			{
				this.removeChild(DisplayObject(this.header), true);
				this.header = null;
			}

			const factory:Function = this._headerFactory != null ? this._headerFactory : defaultHeaderFactory;
			const headerName:String = this._customHeaderName != null ? this._customHeaderName : this.headerName;
			this.header = IFeathersControl(factory());
			this.header.nameList.add(headerName);
			this.addChild(DisplayObject(this.header));
			this.displayListBypassEnabled = oldDisplayListBypassEnabled;
		}

		/**
		 * @private
		 */
		protected function createFooter():void
		{
			const oldDisplayListBypassEnabled:Boolean = this.displayListBypassEnabled;
			this.displayListBypassEnabled = false;
			if(this.footer)
			{
				this.removeChild(DisplayObject(this.footer), true);
				this.footer = null;
			}

			if(this._footerFactory == null)
			{
				return;
			}
			const footerName:String = this._customFooterName != null ? this._customFooterName : this.footerName;
			this.footer = IFeathersControl(this._footerFactory());
			this.footer.nameList.add(footerName);
			this.addChild(DisplayObject(this.footer));
			this.displayListBypassEnabled = oldDisplayListBypassEnabled;
		}

		/**
		 * @private
		 */
		protected function refreshHeaderStyles():void
		{
			const headerAsObject:Object = this.header;
			for(var propertyName:String in this._headerProperties)
			{
				if(headerAsObject.hasOwnProperty(propertyName))
				{
					var propertyValue:Object = this._headerProperties[propertyName];
					this.header[propertyName] = propertyValue;
				}
			}
		}

		/**
		 * @private
		 */
		protected function refreshFooterStyles():void
		{
			const footerAsObject:Object = this.footer;
			for(var propertyName:String in this._footerProperties)
			{
				if(footerAsObject.hasOwnProperty(propertyName))
				{
					var propertyValue:Object = this._footerProperties[propertyName];
					this.footer[propertyName] = propertyValue;
				}
			}
		}

		/**
		 * @private
		 */
		override protected function calculateViewPortOffsets(forceScrollBars:Boolean = false):void
		{
			super.calculateViewPortOffsets(forceScrollBars);

			const oldHeaderWidth:Number = this.header.width;
			const oldHeaderHeight:Number = this.header.height;
			this.header.width = this.explicitWidth;
			this.header.maxWidth = this._maxWidth;
			this.header.height = NaN;
			this.header.validate();
			this._topViewPortOffset += this.header.height;
			this.header.width = oldHeaderWidth;
			this.header.height = oldHeaderHeight;

			if(this.footer)
			{
				const oldFooterWidth:Number = this.footer.width;
				const oldFooterHeight:Number = this.footer.height;
				this.footer.width = this.explicitWidth;
				this.footer.maxWidth = this._maxWidth;
				this.footer.height = NaN;
				this.footer.validate();
				this._bottomViewPortOffset += this.footer.height;
				this.footer.width = oldFooterWidth;
				this.footer.height = oldFooterHeight;
			}
		}

		/**
		 * @private
		 */
		override protected function layoutChildren():void
		{
			super.layoutChildren();

			this.header.width = this.actualWidth;
			this.header.height = NaN;
			this.header.validate();

			if(this.footer)
			{
				this.footer.width = this.actualWidth;
				this.footer.height = NaN;
				this.footer.validate();
				this.footer.y = this.actualHeight - this.footer.height;
			}
		}
	}
}
