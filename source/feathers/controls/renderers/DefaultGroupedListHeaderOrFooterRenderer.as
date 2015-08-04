/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.renderers
{
	import feathers.controls.GroupedList;
	import feathers.controls.ImageLoader;
	import feathers.core.FeathersControl;
	import feathers.core.IFeathersControl;
	import feathers.core.ITextRenderer;
	import feathers.core.IValidating;
	import feathers.core.PropertyProxy;
	import feathers.skins.IStyleProvider;

	import starling.display.DisplayObject;

	/**
	 * The default renderer used for headers and footers in a GroupedList
	 * control.
	 *
	 * @see feathers.controls.GroupedList
	 */
	public class DefaultGroupedListHeaderOrFooterRenderer extends FeathersControl implements IGroupedListHeaderOrFooterRenderer
	{
		/**
		 * The content will be aligned horizontally to the left edge of the renderer.
		 *
		 * @see #horizontalAlign
		 */
		public static const HORIZONTAL_ALIGN_LEFT:String = "left";

		/**
		 * The content will be aligned horizontally to the center of the renderer.
		 *
		 * @see #horizontalAlign
		 */
		public static const HORIZONTAL_ALIGN_CENTER:String = "center";

		/**
		 * The content will be aligned horizontally to the right edge of the renderer.
		 *
		 * @see #horizontalAlign
		 */
		public static const HORIZONTAL_ALIGN_RIGHT:String = "right";

		/**
		 * The content will be justified horizontally, filling the entire width
		 * of the renderer, minus padding.
		 *
		 * @see #horizontalAlign
		 */
		public static const HORIZONTAL_ALIGN_JUSTIFY:String = "justify";

		/**
		 * The content will be aligned vertically to the top edge of the renderer.
		 *
		 * @see #verticalAlign
		 */
		public static const VERTICAL_ALIGN_TOP:String = "top";

		/**
		 * The content will be aligned vertically to the middle of the renderer.
		 *
		 * @see #verticalAlign
		 */
		public static const VERTICAL_ALIGN_MIDDLE:String = "middle";

		/**
		 * The content will be aligned vertically to the bottom edge of the renderer.
		 *
		 * @see #verticalAlign
		 */
		public static const VERTICAL_ALIGN_BOTTOM:String = "bottom";

		/**
		 * The content will be justified vertically, filling the entire height
		 * of the renderer, minus padding.
		 *
		 * @see #verticalAlign
		 */
		public static const VERTICAL_ALIGN_JUSTIFY:String = "justify";

		/**
		 * The default value added to the <code>styleNameList</code> of the
		 * content label.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_CONTENT_LABEL:String = "feathers-header-footer-renderer-content-label";

		/**
		 * The default <code>IStyleProvider</code> for all <code>DefaultGroupedListHeaderOrFooterRenderer</code>
		 * components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * @private
		 */
		protected static function defaultImageLoaderFactory():ImageLoader
		{
			return new ImageLoader();
		}

		/**
		 * Constructor.
		 */
		public function DefaultGroupedListHeaderOrFooterRenderer()
		{
			super();
		}

		/**
		 * The value added to the <code>styleNameList</code> of the content
		 * label text renderer.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var contentLabelStyleName:String = DEFAULT_CHILD_STYLE_NAME_CONTENT_LABEL;

		/**
		 * @private
		 */
		protected var contentImage:ImageLoader;

		/**
		 * @private
		 */
		protected var contentLabel:ITextRenderer;

		/**
		 * @private
		 */
		protected var content:DisplayObject;

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return DefaultGroupedListHeaderOrFooterRenderer.globalStyleProvider;
		}

		/**
		 * @private
		 */
		protected var _data:Object;

		/**
		 * @inheritDoc
		 */
		public function get data():Object
		{
			return this._data;
		}

		/**
		 * @private
		 */
		public function set data(value:Object):void
		{
			if(this._data == value)
			{
				return;
			}
			this._data = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _groupIndex:int = -1;

		/**
		 * @inheritDoc
		 */
		public function get groupIndex():int
		{
			return this._groupIndex;
		}

		/**
		 * @private
		 */
		public function set groupIndex(value:int):void
		{
			this._groupIndex = value;
		}

		/**
		 * @private
		 */
		protected var _layoutIndex:int = -1;

		/**
		 * @inheritDoc
		 */
		public function get layoutIndex():int
		{
			return this._layoutIndex;
		}

		/**
		 * @private
		 */
		public function set layoutIndex(value:int):void
		{
			this._layoutIndex = value;
		}

		/**
		 * @private
		 */
		protected var _owner:GroupedList;

		/**
		 * @inheritDoc
		 */
		public function get owner():GroupedList
		{
			return this._owner;
		}

		/**
		 * @private
		 */
		public function set owner(value:GroupedList):void
		{
			if(this._owner == value)
			{
				return;
			}
			this._owner = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _horizontalAlign:String = HORIZONTAL_ALIGN_LEFT;

		[Inspectable(type="String",enumeration="left,center,right,justify")]
		/**
		 * The location where the renderer's content is aligned horizontally
		 * (on the x-axis).
		 *
		 * <p>In the following example, the horizontal alignment is changed to
		 * right:</p>
		 *
		 * <listing version="3.0">
		 * renderer.horizontalAlign = DefaultGroupedListHeaderOrFooterRenderer.HORIZONTAL_ALIGN_RIGHT;</listing>
		 *
		 * @default DefaultGroupedListHeaderOrFooterRenderer.HORIZONTAL_ALIGN_LEFT
		 *
		 * @see #HORIZONTAL_ALIGN_LEFT
		 * @see #HORIZONTAL_ALIGN_CENTER
		 * @see #HORIZONTAL_ALIGN_RIGHT
		 * @see #HORIZONTAL_ALIGN_JUSTIFY
		 */
		public function get horizontalAlign():String
		{
			return this._horizontalAlign;
		}

		/**
		 * @private
		 */
		public function set horizontalAlign(value:String):void
		{
			if(this._horizontalAlign == value)
			{
				return;
			}
			this._horizontalAlign = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _verticalAlign:String = VERTICAL_ALIGN_MIDDLE;

		[Inspectable(type="String",enumeration="top,middle,bottom,justify")]
		/**
		 * The location where the renderer's content is aligned vertically (on
		 * the y-axis).
		 *
		 * <p>In the following example, the vertical alignment is changed to
		 * bottom:</p>
		 *
		 * <listing version="3.0">
		 * renderer.verticalAlign = DefaultGroupedListHeaderOrFooterRenderer.HORIZONTAL_ALIGN_BOTTOM;</listing>
		 *
		 * @default DefaultGroupedListHeaderOrFooterRenderer.VERTICAL_ALIGN_MIDDLE
		 *
		 * @see #VERTICAL_ALIGN_TOP
		 * @see #VERTICAL_ALIGN_MIDDLE
		 * @see #VERTICAL_ALIGN_BOTTOM
		 * @see #VERTICAL_ALIGN_JUSTIFY
		 */
		public function get verticalAlign():String
		{
			return _verticalAlign;
		}

		/**
		 * @private
		 */
		public function set verticalAlign(value:String):void
		{
			if(this._verticalAlign == value)
			{
				return;
			}
			this._verticalAlign = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _contentField:String = "content";

		/**
		 * The field in the item that contains a display object to be positioned
		 * in the content position of the renderer. If you wish to display a
		 * texture in the content position, it's better for performance to use
		 * <code>contentSourceField</code> instead.
		 *
		 * <p>All of the content fields and functions, ordered by priority:</p>
		 * <ol>
		 *     <li><code>contentSourceFunction</code></li>
		 *     <li><code>contentSourceField</code></li>
		 *     <li><code>contentLabelFunction</code></li>
		 *     <li><code>contentLabelField</code></li>
		 *     <li><code>contentFunction</code></li>
		 *     <li><code>contentField</code></li>
		 * </ol>
		 *
		 * <p>In the following example, the content field is customized:</p>
		 *
		 * <listing version="3.0">
		 * renderer.contentField = "header";</listing>
		 *
		 * @default "content"
		 *
		 * @see #contentSourceField
		 * @see #contentFunction
		 * @see #contentSourceFunction
		 * @see #contentLabelField
		 * @see #contentLabelFunction
		 */
		public function get contentField():String
		{
			return this._contentField;
		}

		/**
		 * @private
		 */
		public function set contentField(value:String):void
		{
			if(this._contentField == value)
			{
				return;
			}
			this._contentField = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _contentFunction:Function;

		/**
		 * A function that returns a display object to be positioned in the
		 * content position of the renderer. If you wish to display a texture in
		 * the content position, it's better for performance to use
		 * <code>contentSourceFunction</code> instead.
		 *
		 * <p>The function is expected to have the following signature:</p>
		 * <pre>function( item:Object ):DisplayObject</pre>
		 *
		 * <p>All of the content fields and functions, ordered by priority:</p>
		 * <ol>
		 *     <li><code>contentSourceFunction</code></li>
		 *     <li><code>contentSourceField</code></li>
		 *     <li><code>contentLabelFunction</code></li>
		 *     <li><code>contentLabelField</code></li>
		 *     <li><code>contentFunction</code></li>
		 *     <li><code>contentField</code></li>
		 * </ol>
		 *
		 * <p>In the following example, the content function is customized:</p>
		 *
		 * <listing version="3.0">
		 * renderer.contentFunction = function( item:Object ):DisplayObject
		 * {
		 *    if(item in cachedContent)
		 *    {
		 *        return cachedContent[item];
		 *    }
		 *    var content:DisplayObject = createContentForHeader( item );
		 *    cachedContent[item] = content;
		 *    return content;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see #contentField
		 * @see #contentSourceField
		 * @see #contentSourceFunction
		 * @see #contentLabelField
		 * @see #contentLabelFunction
		 */
		public function get contentFunction():Function
		{
			return this._contentFunction;
		}

		/**
		 * @private
		 */
		public function set contentFunction(value:Function):void
		{
			if(this._contentFunction == value)
			{
				return;
			}
			this._contentFunction = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _contentSourceField:String = "source";

		/**
		 * The field in the data that contains a <code>starling.textures.Texture</code>
		 * or a URL that points to a bitmap to be used as the renderer's
		 * content. The renderer will automatically manage and reuse an internal
		 * <code>ImageLoader</code> sub-component and this value will be passed
		 * to the <code>source</code> property. The <code>ImageLoader</code> may
		 * be customized by changing the <code>contentLoaderFactory</code>.
		 *
		 * <p>Using an content source will result in better performance than
		 * passing in an <code>ImageLoader</code> or <code>Image</code> through
		 * <code>contentField</code> or <code>contentFunction</code> because the
		 * renderer can avoid costly display list manipulation.</p>
		 *
		 * <p>All of the content fields and functions, ordered by priority:</p>
		 * <ol>
		 *     <li><code>contentSourceFunction</code></li>
		 *     <li><code>contentSourceField</code></li>
		 *     <li><code>contentLabelFunction</code></li>
		 *     <li><code>contentLabelField</code></li>
		 *     <li><code>contentFunction</code></li>
		 *     <li><code>contentField</code></li>
		 * </ol>
		 *
		 * <p>In the following example, the content source field is customized:</p>
		 *
		 * <listing version="3.0">
		 * renderer.contentSourceField = "texture";</listing>
		 *
		 * @default "source"
		 *
		 * @see feathers.controls.ImageLoader#source
		 * @see #contentLoaderFactory
		 * @see #contentSourceFunction
		 * @see #contentField
		 * @see #contentFunction
		 * @see #contentLabelField
		 * @see #contentLabelFunction
		 */
		public function get contentSourceField():String
		{
			return this._contentSourceField;
		}

		/**
		 * @private
		 */
		public function set contentSourceField(value:String):void
		{
			if(this._contentSourceField == value)
			{
				return;
			}
			this._contentSourceField = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _contentSourceFunction:Function;

		/**
		 * A function used to generate a <code>starling.textures.Texture</code>
		 * or a URL that points to a bitmap to be used as the renderer's
		 * content. The renderer will automatically manage and reuse an internal
		 * <code>ImageLoader</code> sub-component and this value will be passed
		 * to the <code>source</code> property. The <code>ImageLoader</code> may
		 * be customized by changing the <code>contentLoaderFactory</code>.
		 *
		 * <p>Using an content source will result in better performance than
		 * passing in an <code>ImageLoader</code> or <code>Image</code> through
		 * <code>contentField</code> or <code>contentFunction</code> because the
		 * renderer can avoid costly display list manipulation.</p>
		 *
		 * <p>The function is expected to have the following signature:</p>
		 * <pre>function( item:Object ):Object</pre>
		 *
		 * <p>The return value is a valid value for the <code>source</code>
		 * property of an <code>ImageLoader</code> component.</p>
		 *
		 * <p>All of the content fields and functions, ordered by priority:</p>
		 * <ol>
		 *     <li><code>contentSourceFunction</code></li>
		 *     <li><code>contentSourceField</code></li>
		 *     <li><code>contentLabelFunction</code></li>
		 *     <li><code>contentLabelField</code></li>
		 *     <li><code>contentFunction</code></li>
		 *     <li><code>contentField</code></li>
		 * </ol>
		 *
		 * <p>In the following example, the content source function is customized:</p>
		 *
		 * <listing version="3.0">
		 * renderer.contentSourceFunction = function( item:Object ):Object
		 * {
		 *    return "http://www.example.com/thumbs/" + item.name + "-thumb.png";
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.ImageLoader#source
		 * @see #contentLoaderFactory
		 * @see #contentSourceField
		 * @see #contentField
		 * @see #contentFunction
		 * @see #contentLabelField
		 * @see #contentLabelFunction
		 */
		public function get contentSourceFunction():Function
		{
			return this._contentSourceFunction;
		}

		/**
		 * @private
		 */
		public function set contentSourceFunction(value:Function):void
		{
			if(this.contentSourceFunction == value)
			{
				return;
			}
			this._contentSourceFunction = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _contentLabelField:String = "label";

		/**
		 * The field in the item that contains a string to be displayed in a
		 * renderer-managed <code>Label</code> in the content position of the
		 * renderer. The renderer will automatically reuse an internal
		 * <code>Label</code> and swap the text when the data changes. This
		 * <code>Label</code> may be skinned by changing the
		 * <code>contentLabelFactory</code>.
		 *
		 * <p>Using an content label will result in better performance than
		 * passing in a <code>Label</code> through a <code>contentField</code>
		 * or <code>contentFunction</code> because the renderer can avoid
		 * costly display list manipulation.</p>
		 *
		 * <p>All of the content fields and functions, ordered by priority:</p>
		 * <ol>
		 *     <li><code>contentTextureFunction</code></li>
		 *     <li><code>contentTextureField</code></li>
		 *     <li><code>contentLabelFunction</code></li>
		 *     <li><code>contentLabelField</code></li>
		 *     <li><code>contentFunction</code></li>
		 *     <li><code>contentField</code></li>
		 * </ol>
		 *
		 * <p>In the following example, the content label field is customized:</p>
		 *
		 * <listing version="3.0">
		 * renderer.contentLabelField = "text";</listing>
		 *
		 * @default "label"
		 *
		 * @see #contentLabelFactory
		 * @see #contentLabelFunction
		 * @see #contentField
		 * @see #contentFunction
		 * @see #contentSourceField
		 * @see #contentSourceFunction
		 */
		public function get contentLabelField():String
		{
			return this._contentLabelField;
		}

		/**
		 * @private
		 */
		public function set contentLabelField(value:String):void
		{
			if(this._contentLabelField == value)
			{
				return;
			}
			this._contentLabelField = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _contentLabelFunction:Function;

		/**
		 * A function that returns a string to be displayed in a
		 * renderer-managed <code>Label</code> in the content position of the
		 * renderer. The renderer will automatically reuse an internal
		 * <code>Label</code> and swap the text when the data changes. This
		 * <code>Label</code> may be skinned by changing the
		 * <code>contentLabelFactory</code>.
		 *
		 * <p>Using an content label will result in better performance than
		 * passing in a <code>Label</code> through a <code>contentField</code>
		 * or <code>contentFunction</code> because the renderer can avoid
		 * costly display list manipulation.</p>
		 *
		 * <p>The function is expected to have the following signature:</p>
		 * <pre>function( item:Object ):String</pre>
		 *
		 * <p>All of the content fields and functions, ordered by priority:</p>
		 * <ol>
		 *     <li><code>contentTextureFunction</code></li>
		 *     <li><code>contentTextureField</code></li>
		 *     <li><code>contentLabelFunction</code></li>
		 *     <li><code>contentLabelField</code></li>
		 *     <li><code>contentFunction</code></li>
		 *     <li><code>contentField</code></li>
		 * </ol>
		 *
		 * <p>In the following example, the content label function is customized:</p>
		 *
		 * <listing version="3.0">
		 * renderer.contentLabelFunction = function( item:Object ):String
		 * {
		 *    return item.category + " > " + item.subCategory;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see #contentLabelFactory
		 * @see #contentLabelField
		 * @see #contentField
		 * @see #contentFunction
		 * @see #contentSourceField
		 * @see #contentSourceFunction
		 */
		public function get contentLabelFunction():Function
		{
			return this._contentLabelFunction;
		}

		/**
		 * @private
		 */
		public function set contentLabelFunction(value:Function):void
		{
			if(this._contentLabelFunction == value)
			{
				return;
			}
			this._contentLabelFunction = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _contentLoaderFactory:Function = defaultImageLoaderFactory;

		/**
		 * A function that generates an <code>ImageLoader</code> that uses the result
		 * of <code>contentSourceField</code> or <code>contentSourceFunction</code>.
		 * Useful for transforming the <code>ImageLoader</code> in some way. For
		 * example, you might want to scale it for current screen density or
		 * apply pixel snapping.
		 *
		 * <p>In the following example, a custom content loader factory is passed
		 * to the renderer:</p>
		 *
		 * <listing version="3.0">
		 * renderer.contentLoaderFactory = function():ImageLoader
		 * {
		 *     var loader:ImageLoader = new ImageLoader();
		 *     loader.snapToPixels = true;
		 *     return loader;
		 * };</listing>
		 *
		 * @default function():ImageLoader { return new ImageLoader(); }
		 *
		 * @see feathers.controls.ImageLoader
		 * @see #contentSourceField
		 * @see #contentSourceFunction
		 */
		public function get contentLoaderFactory():Function
		{
			return this._contentLoaderFactory;
		}

		/**
		 * @private
		 */
		public function set contentLoaderFactory(value:Function):void
		{
			if(this._contentLoaderFactory == value)
			{
				return;
			}
			this._contentLoaderFactory = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _contentLabelFactory:Function;

		/**
		 * A function that generates an <code>ITextRenderer</code> that uses the result
		 * of <code>contentLabelField</code> or <code>contentLabelFunction</code>.
		 * Can be used to set properties on the <code>ITextRenderer</code>.
		 *
		 * <p>In the following example, a custom content label factory is passed
		 * to the renderer:</p>
		 *
		 * <listing version="3.0">
		 * renderer.contentLabelFactory = function():ITextRenderer
		 * {
		 *     var renderer:TextFieldTextRenderer = new TextFieldTextRenderer();
		 *     renderer.textFormat = new TextFormat( "Source Sans Pro", 16, 0x333333 );
		 *     renderer.embedFonts = true;
		 *     return renderer;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.core.ITextRenderer
		 * @see feathers.core.FeathersControl#defaultTextRendererFactory
		 * @see #contentLabelField
		 * @see #contentLabelFunction
		 */
		public function get contentLabelFactory():Function
		{
			return this._contentLabelFactory;
		}

		/**
		 * @private
		 */
		public function set contentLabelFactory(value:Function):void
		{
			if(this._contentLabelFactory == value)
			{
				return;
			}
			this._contentLabelFactory = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _customContentLabelStyleName:String;

		/**
		 * A style name to add to the renderer's label text renderer
		 * sub-component. Typically used by a theme to provide different styles
		 * to different renderers.
		 *
		 * <p>In the following example, a custom label style name is passed to
		 * the renderer:</p>
		 *
		 * <listing version="3.0">
		 * renderer.customContentLabelStyleName = "my-custom-header-or-footer-renderer-label";</listing>
		 *
		 * <p>In your theme, you can target this sub-component style name to
		 * provide different styles than the default:</p>
		 *
		 * <listing version="3.0">
		 * getStyleProviderForClass( BitmapFontTextRenderer ).setFunctionForStyleName( "my-custom-header-or-footer-label", setCustomHeaderOrFooterLabelStyles );</listing>
		 *
		 * @default null
		 *
		 * @see #DEFAULT_CHILD_STYLE_NAME_CONTENT_LABEL
		 * @see feathers.core.FeathersControl#styleNameList
		 * @see #contentLabelFactory
		 */
		public function get customContentLabelStyleName():String
		{
			return this._customContentLabelStyleName;
		}

		/**
		 * @private
		 */
		public function set customContentLabelStyleName(value:String):void
		{
			if(this._customContentLabelStyleName == value)
			{
				return;
			}
			this._customContentLabelStyleName = value;
			this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
		}

		/**
		 * @private
		 */
		protected var _contentLabelProperties:PropertyProxy;

		/**
		 * An object that stores properties for the content label text renderer
		 * sub-component, and the properties will be passed down to the
		 * text renderer when this component validates. The available properties
		 * depend on which <code>ITextRenderer</code> implementation is returned
		 * by <code>contentLabelFactory</code>. Refer to
		 * <a href="../../core/ITextRenderer.html"><code>feathers.core.ITextRenderer</code></a>
		 * for a list of available text renderer implementations.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
		 * which is in a <code>List</code>, you can use the following syntax:</p>
		 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * <p>In the following example, a custom content label properties are
		 * customized:</p>
		 * 
		 * <listing version="3.0">
		 * renderer.contentLabelProperties.textFormat = new TextFormat( "Source Sans Pro", 16, 0x333333 );
		 * renderer.contentLabelProperties.embedFonts = true;</listing>
		 *
		 * @default null
		 *
		 * @see feathers.core.ITextRenderer
		 * @see #contentLabelField
		 * @see #contentLabelFunction
		 */
		public function get contentLabelProperties():Object
		{
			if(!this._contentLabelProperties)
			{
				this._contentLabelProperties = new PropertyProxy(contentLabelProperties_onChange);
			}
			return this._contentLabelProperties;
		}

		/**
		 * @private
		 */
		public function set contentLabelProperties(value:Object):void
		{
			if(this._contentLabelProperties == value)
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
			if(this._contentLabelProperties)
			{
				this._contentLabelProperties.removeOnChangeCallback(contentLabelProperties_onChange);
			}
			this._contentLabelProperties = PropertyProxy(value);
			if(this._contentLabelProperties)
			{
				this._contentLabelProperties.addOnChangeCallback(contentLabelProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var originalBackgroundWidth:Number = NaN;

		/**
		 * @private
		 */
		protected var originalBackgroundHeight:Number = NaN;

		/**
		 * @private
		 */
		protected var currentBackgroundSkin:DisplayObject;

		/**
		 * @private
		 */
		protected var _backgroundSkin:DisplayObject;

		/**
		 * A background to behind the component's content.
		 *
		 * <p>In the following example, the header renderers is given a
		 * background skin:</p>
		 *
		 * <listing version="3.0">
		 * renderer.backgroundSkin = new Image( texture );</listing>
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

			if(this._backgroundSkin && this._backgroundSkin != this._backgroundDisabledSkin)
			{
				this.removeChild(this._backgroundSkin);
			}
			this._backgroundSkin = value;
			if(this._backgroundSkin && this._backgroundSkin.parent != this)
			{
				this._backgroundSkin.visible = false;
				this.addChildAt(this._backgroundSkin, 0);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _backgroundDisabledSkin:DisplayObject;

		/**
		 * A background to display when the component is disabled.
		 *
		 * <p>In the following example, the header renderers is given a
		 * disabled background skin:</p>
		 *
		 * <listing version="3.0">
		 * renderer.backgroundDisabledSkin = new Image( texture );</listing>
		 *
		 * @default null
		 */
		public function get backgroundDisabledSkin():DisplayObject
		{
			return this._backgroundDisabledSkin;
		}

		/**
		 * @private
		 */
		public function set backgroundDisabledSkin(value:DisplayObject):void
		{
			if(this._backgroundDisabledSkin == value)
			{
				return;
			}

			if(this._backgroundDisabledSkin && this._backgroundDisabledSkin != this._backgroundSkin)
			{
				this.removeChild(this._backgroundDisabledSkin);
			}
			this._backgroundDisabledSkin = value;
			if(this._backgroundDisabledSkin && this._backgroundDisabledSkin.parent != this)
			{
				this._backgroundDisabledSkin.visible = false;
				this.addChildAt(this._backgroundDisabledSkin, 0);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * Quickly sets all padding properties to the same value. The
		 * <code>padding</code> getter always returns the value of
		 * <code>paddingTop</code>, but the other padding values may be
		 * different.
		 *
		 * <p>In the following example, the padding is set to 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * renderer.padding = 20;</listing>
		 *
		 * @default 0
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
		 * The minimum space, in pixels, between the component's top edge and
		 * the component's content.
		 *
		 * <p>In the following example, the top padding is set to 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * renderer.paddingTop = 20;</listing>
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
		 * The minimum space, in pixels, between the component's right edge
		 * and the component's content.
		 *
		 * <p>In the following example, the right padding is set to 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * renderer.paddingRight = 20;</listing>
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
		 * The minimum space, in pixels, between the component's bottom edge
		 * and the component's content.
		 *
		 * <p>In the following example, the bottom padding is set to 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * renderer.paddingBottom = 20;</listing>
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
		 * The minimum space, in pixels, between the component's left edge
		 * and the component's content.
		 * 
		 * <p>In the following example, the left padding is set to 20 pixels:</p>
		 * 
		 * <listing version="3.0">
		 * renderer.paddingLeft = 20;</listing>
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
		override public function dispose():void
		{
			//the content may have come from outside of this class. it's up
			//to that code to dispose of the content. in fact, if we disposed
			//of it here, we might screw something up!
			if(this.content)
			{
				this.content.removeFromParent();
			}

			//however, we need to dispose these, if they exist, since we made
			//them here.
			if(this.contentImage)
			{
				this.contentImage.dispose();
				this.contentImage = null;
			}
			if(this.contentLabel)
			{
				DisplayObject(this.contentLabel).dispose();
				this.contentLabel = null;
			}
			super.dispose();
		}

		/**
		 * Uses the content fields and functions to generate content for a
		 * specific group header or footer.
		 *
		 * <p>All of the content fields and functions, ordered by priority:</p>
		 * <ol>
		 *     <li><code>contentTextureFunction</code></li>
		 *     <li><code>contentTextureField</code></li>
		 *     <li><code>contentLabelFunction</code></li>
		 *     <li><code>contentLabelField</code></li>
		 *     <li><code>contentFunction</code></li>
		 *     <li><code>contentField</code></li>
		 * </ol>
		 */
		protected function itemToContent(item:Object):DisplayObject
		{
			if(this._contentSourceFunction != null)
			{
				var source:Object = this._contentSourceFunction(item);
				this.refreshContentSource(source);
				return this.contentImage;
			}
			else if(this._contentSourceField != null && item && item.hasOwnProperty(this._contentSourceField))
			{
				source = item[this._contentSourceField];
				this.refreshContentSource(source);
				return this.contentImage;
			}
			else if(this._contentLabelFunction != null)
			{
				var labelResult:Object = this._contentLabelFunction(item);
				if(labelResult is String)
				{
					this.refreshContentLabel(labelResult as String);
				}
				else
				{
					this.refreshContentLabel(labelResult.toString());
				}
				return DisplayObject(this.contentLabel);
			}
			else if(this._contentLabelField != null && item && item.hasOwnProperty(this._contentLabelField))
			{
				labelResult = item[this._contentLabelField];
				if(labelResult is String)
				{
					this.refreshContentLabel(labelResult as String);
				}
				else
				{
					this.refreshContentLabel(labelResult.toString());
				}
				return DisplayObject(this.contentLabel);
			}
			else if(this._contentFunction != null)
			{
				return this._contentFunction(item) as DisplayObject;
			}
			else if(this._contentField != null && item && item.hasOwnProperty(this._contentField))
			{
				return item[this._contentField] as DisplayObject;
			}
			else if(item is String)
			{
				this.refreshContentLabel(item as String);
				return DisplayObject(this.contentLabel);
			}
			else if(item)
			{
				this.refreshContentLabel(item.toString());
				return DisplayObject(this.contentLabel);
			}

			return null;
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			var stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			var stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);

			if(stylesInvalid || stateInvalid)
			{
				this.refreshBackgroundSkin();
			}

			if(dataInvalid)
			{
				this.commitData();
			}

			if(dataInvalid || stylesInvalid)
			{
				this.refreshContentLabelStyles();
			}

			if(dataInvalid || stateInvalid)
			{
				this.refreshEnabled();
			}

			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

			if(dataInvalid || stylesInvalid || sizeInvalid)
			{
				this.layout();
			}

			if(sizeInvalid || stylesInvalid || stateInvalid)
			{
				if(this.currentBackgroundSkin)
				{
					this.currentBackgroundSkin.width = this.actualWidth;
					this.currentBackgroundSkin.height = this.actualHeight;
				}
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
			var needsWidth:Boolean = this.explicitWidth !== this.explicitWidth; //isNaN
			var needsHeight:Boolean = this.explicitHeight !== this.explicitHeight; //isNaN
			if(!needsWidth && !needsHeight)
			{
				return false;
			}
			if(!this.content)
			{
				return this.setSizeInternal(0, 0, false);
			}
			if(this.contentLabel)
			{
				//special case for label to allow word wrap
				var labelMaxWidth:Number = this.explicitWidth;
				if(needsWidth)
				{
					labelMaxWidth = this._maxWidth;
				}
				this.contentLabel.maxWidth = labelMaxWidth - this._paddingLeft - this._paddingRight;
			}
			if(this._horizontalAlign == HORIZONTAL_ALIGN_JUSTIFY)
			{
				this.content.width = this.explicitWidth - this._paddingLeft - this._paddingRight;
			}
			if(this._verticalAlign == VERTICAL_ALIGN_JUSTIFY)
			{
				this.content.height = this.explicitHeight - this._paddingTop - this._paddingBottom;
			}
			if(this.content is IValidating)
			{
				IValidating(this.content).validate();
			}
			var newWidth:Number = this.explicitWidth;
			var newHeight:Number = this.explicitHeight;
			if(needsWidth)
			{
				newWidth = this.content.width + this._paddingLeft + this._paddingRight;
				if(this.originalBackgroundWidth === this.originalBackgroundWidth && //!isNaN
					this.originalBackgroundWidth > newWidth)
				{
					newWidth = this.originalBackgroundWidth;
				}
			}
			if(needsHeight)
			{
				newHeight = this.content.height + this._paddingTop + this._paddingBottom;
				if(this.originalBackgroundHeight === this.originalBackgroundHeight && //!isNaN
					this.originalBackgroundHeight > newHeight)
				{
					newHeight = this.originalBackgroundHeight;
				}
			}
			return this.setSizeInternal(newWidth, newHeight, false);
		}

		/**
		 * @private
		 */
		protected function refreshBackgroundSkin():void
		{
			this.currentBackgroundSkin = this._backgroundSkin;
			if(!this._isEnabled && this._backgroundDisabledSkin)
			{
				if(this._backgroundSkin)
				{
					this._backgroundSkin.visible = false;
				}
				this.currentBackgroundSkin = this._backgroundDisabledSkin;
			}
			else if(this._backgroundDisabledSkin)
			{
				this._backgroundDisabledSkin.visible = false;
			}
			if(this.currentBackgroundSkin)
			{
				if(this.originalBackgroundWidth !== this.originalBackgroundWidth) //isNaN
				{
					this.originalBackgroundWidth = this.currentBackgroundSkin.width;
				}
				if(this.originalBackgroundHeight !== this.originalBackgroundHeight) //isNaN
				{
					this.originalBackgroundHeight = this.currentBackgroundSkin.height;
				}
				this.currentBackgroundSkin.visible = true;
			}
		}

		/**
		 * @private
		 */
		protected function commitData():void
		{
			if(this._owner)
			{
				var newContent:DisplayObject = this.itemToContent(this._data);
				if(newContent != this.content)
				{
					if(this.content)
					{
						this.content.removeFromParent();
					}
					this.content = newContent;
					if(this.content)
					{
						this.addChild(this.content);
					}
				}
			}
			else
			{
				if(this.content)
				{
					this.content.removeFromParent();
					this.content = null;
				}
			}
		}

		/**
		 * @private
		 */
		protected function refreshContentSource(source:Object):void
		{
			if(!this.contentImage)
			{
				this.contentImage = this._contentLoaderFactory();
			}
			this.contentImage.source = source;
		}

		/**
		 * @private
		 */
		protected function refreshContentLabel(label:String):void
		{
			if(label !== null)
			{
				if(!this.contentLabel)
				{
					var factory:Function = this._contentLabelFactory != null ? this._contentLabelFactory : FeathersControl.defaultTextRendererFactory;
					this.contentLabel = ITextRenderer(factory());
					var contentLabelStyleName:String = this._customContentLabelStyleName != null ? this._customContentLabelStyleName : this.contentLabelStyleName;
					FeathersControl(this.contentLabel).styleNameList.add(contentLabelStyleName);
				}
				this.contentLabel.text = label;
			}
			else if(this.contentLabel)
			{
				DisplayObject(this.contentLabel).removeFromParent(true);
				this.contentLabel = null;
			}
		}

		/**
		 * @private
		 */
		protected function refreshEnabled():void
		{
			if(this.content is IFeathersControl)
			{
				IFeathersControl(this.content).isEnabled = this._isEnabled;
			}
		}

		/**
		 * @private
		 */
		protected function refreshContentLabelStyles():void
		{
			if(!this.contentLabel)
			{
				return;
			}
			for(var propertyName:String in this._contentLabelProperties)
			{
				var propertyValue:Object = this._contentLabelProperties[propertyName];
				this.contentLabel[propertyName] = propertyValue;
			}
		}

		/**
		 * @private
		 */
		protected function layout():void
		{
			if(!this.content)
			{
				return;
			}

			if(this.contentLabel)
			{
				this.contentLabel.maxWidth = this.actualWidth - this._paddingLeft - this._paddingRight;
			}
			switch(this._horizontalAlign)
			{
				case HORIZONTAL_ALIGN_CENTER:
				{
					this.content.x = this._paddingLeft + (this.actualWidth - this._paddingLeft - this._paddingRight - this.content.width) / 2;
					break;
				}
				case HORIZONTAL_ALIGN_RIGHT:
				{
					this.content.x = this.actualWidth - this._paddingRight - this.content.width;
					break;
				}
				case HORIZONTAL_ALIGN_JUSTIFY:
				{
					this.content.x = this._paddingLeft;
					this.content.width = this.actualWidth - this._paddingLeft - this._paddingRight;
					break;
				}
				default: //left
				{
					this.content.x = this._paddingLeft;
				}
			}

			switch(this._verticalAlign)
			{
				case VERTICAL_ALIGN_TOP:
				{
					this.content.y = this._paddingTop;
					break;
				}
				case VERTICAL_ALIGN_BOTTOM:
				{
					this.content.y = this.actualHeight - this._paddingBottom - this.content.height;
					break;
				}
				case VERTICAL_ALIGN_JUSTIFY:
				{
					this.content.y = this._paddingTop;
					this.content.height = this.actualHeight - this._paddingTop - this._paddingBottom;
					break;
				}
				default: //middle
				{
					this.content.y = this._paddingTop + (this.actualHeight - this._paddingTop - this._paddingBottom - this.content.height) / 2;
				}
			}

		}

		/**
		 * @private
		 */
		protected function contentLabelProperties_onChange(proxy:PropertyProxy, name:String):void
		{
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
	}
}
