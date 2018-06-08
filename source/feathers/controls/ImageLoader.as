/*
Feathers
Copyright 2012-2018 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.core.FeathersControl;
	import feathers.events.FeathersEventType;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.VerticalAlign;
	import feathers.skins.IStyleProvider;
	import feathers.utils.textures.TextureCache;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display3D.Context3DTextureFormat;
	import flash.errors.IllegalOperationError;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ImageDecodingPolicy;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;

	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	import starling.utils.SystemUtil;

	/**
	 * The tint value to use on the internal
	 * <code>starling.display.Image</code>.
	 *
	 * <p>In the following example, the image loader's texture color is
	 * customized:</p>
	 *
	 * <listing version="3.0">
	 * loader.color = 0xff00ff;</listing>
	 *
	 * @default 0xffffff
	 *
	 * @see http://doc.starling-framework.org/core/starling/display/Image.html#color starling.display.Image.color
	 */
	[Style(name="color",type="uint")]

	/**
	 * A texture to display while a URL source is loading.
	 *
	 * <p>In the following example, the image loader's loading texture is
	 * customized:</p>
	 *
	 * <listing version="3.0">
	 * loader.source = "http://example.com/example.png";
	 * loader.loadingTexture = texture;</listing>
	 *
	 * @default null
	 *
	 * @see #style:errorTexture
	 */
	[Style(name="loadingTexture",type="starling.textures.Texture")]

	/**
	 * A texture to display when a URL source cannot be loaded for any
	 * reason.
	 *
	 * <p>In the following example, the image loader's error texture is
	 * customized:</p>
	 *
	 * <listing version="3.0">
	 * loader.source = "http://example.com/example.png";
	 * loader.errorTexture = texture;</listing>
	 *
	 * @default null
	 *
	 * @see #style:loadingTexture
	 */
	[Style(name="errorTexture",type="starling.textures.Texture")]

	/**
	 * The location where the content is aligned horizontally (on
	 * the x-axis) when its width is larger or smaller than the width of
	 * the <code>ImageLoader</code>.
	 *
	 * <p>If the <code>scaleContent</code> property is set to
	 * <code>true</code>, the <code>horizontalAlign</code> property is
	 * ignored.</p>
	 *
	 * <p>The following example aligns the content to the right:</p>
	 *
	 * <listing version="3.0">
	 * loader.horizontalAlign = HorizontalAlign.RIGHT;</listing>
	 * 
	 * <p><strong>Note:</strong> The <code>HorizontalAlign.JUSTIFY</code>
	 * constant is not supported.</p>
	 *
	 * @default feathers.layout.HorizontalAlign.LEFT
	 *
	 * @see #style:scaleContent
	 * @see #style:scaleMode
	 * @see feathers.layout.HorizontalAlign#LEFT
	 * @see feathers.layout.HorizontalAlign#CENTER
	 * @see feathers.layout.HorizontalAlign#RIGHT
	 */
	[Style(name="horizontalAlign",type="String")]

	/**
	 * Determines if the aspect ratio of the texture is maintained when the
	 * dimensions of the <code>ImageLoader</code> are changed manually and
	 * the new dimensions have a different aspect ratio than the texture.
	 *
	 * <p>If the <code>scaleContent</code> property is set to
	 * <code>false</code> or if the <code>scale9Grid</code> property is not
	 * <code>null</code>, the <code>maintainAspectRatio</code> property is
	 * ignored.</p>
	 *
	 * <p>In the following example, the image loader's aspect ratio is not
	 * maintained:</p>
	 *
	 * <listing version="3.0">
	 * loader.maintainAspectRatio = false;</listing>
	 *
	 * @default true
	 *
	 * @see #style:scaleContent
	 * @see #style:scaleMode
	 */
	[Style(name="maintainAspectRatio",type="Boolean")]

	/**
	 * Quickly sets all padding properties to the same value. The
	 * <code>padding</code> getter always returns the value of
	 * <code>paddingTop</code>, but the other padding values may be
	 * different.
	 *
	 * <p>In the following example, the image loader's padding is set to
	 * 20 pixels on all sides:</p>
	 *
	 * <listing version="3.0">
	 * loader.padding = 20;</listing>
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
	 * The minimum space, in pixels, between the control's top edge and the
	 * control's content. Value may be negative to extend the content
	 * outside the edges of the control. Useful for skinning.
	 *
	 * <p>In the following example, the image loader's top padding is set
	 * to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * loader.paddingTop = 20;</listing>
	 *
	 * @default 0
	 * 
	 * @see #style:padding
	 */
	[Style(name="paddingTop",type="Number")]

	/**
	 * The minimum space, in pixels, between the control's right edge and the
	 * control's content. Value may be negative to extend the content
	 * outside the edges of the control. Useful for skinning.
	 *
	 * <p>In the following example, the image loader's right padding is set
	 * to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * loader.paddingRight = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:padding
	 */
	[Style(name="paddingRight",type="Number")]

	/**
	 * The minimum space, in pixels, between the control's bottom edge and the
	 * control's content. Value may be negative to extend the content
	 * outside the edges of the control. Useful for skinning.
	 *
	 * <p>In the following example, the image loader's bottom padding is set
	 * to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * loader.paddingBottom = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:padding
	 */
	[Style(name="paddingBottom",type="Number")]

	/**
	 * The minimum space, in pixels, between the control's left edge and the
	 * control's content. Value may be negative to extend the content
	 * outside the edges of the control. Useful for skinning.
	 *
	 * <p>In the following example, the image loader's left padding is set
	 * to 20 pixels:</p>
	 *
	 * <listing version="3.0">
	 * loader.paddingLeft = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:padding
	 */
	[Style(name="paddingLeft",type="Number")]

	/**
	 * The <code>pixelSnapping</code> value to use on the internal
	 * <code>starling.display.Image</code>.
	 *
	 * <p>In the following example, the image loader's pixelSnapping is
	 * disabled:</p>
	 *
	 * <listing version="3.0">
	 * loader.pixelSnapping = false;</listing>
	 *
	 * @default true
	 *
	 * @see http://doc.starling-framework.org/core/starling/display/Mesh.html#pixelSnapping starling.display.Mesh.pixelSnapping
	 */
	[Style(name="pixelSnapping",type="Boolean")]

	/**
	 * The <code>scale9Grid</code> value to use on the internal
	 * <code>starling.display.Image</code>.
	 *
	 * <p>If this property is not <code>null</code>, the
	 * <code>maintainAspectRatio</code> property will be ignored.</p>
	 *
	 * <p>In the following example, the image loader's scale9Grid is set to a
	 * custom value:</p>
	 *
	 * <listing version="3.0">
	 * loader.scale9Grid = Rectangle(2, 3, 7, 12);</listing>
	 *
	 * @default null
	 *
	 * @see http://doc.starling-framework.org/core/starling/display/Image.html#scale9Grid starling.display.Image.scale9Grid
	 */
	[Style(name="scale9Grid",type="flash.geom.Rectangle")]

	/**
	 * Determines if the content will be scaled if the dimensions of the
	 * <code>ImageLoader</code> are changed.
	 *
	 * <p>In the following example, the image loader's content is not
	 * scaled:</p>
	 *
	 * <listing version="3.0">
	 * loader.scaleContent = false;</listing>
	 *
	 * @default true
	 *
	 * @see #style:horizontalAlign
	 * @see #style:verticalAlign
	 * @see #style:maintainAspectRatio
	 * @see #style:scaleMode
	 */
	[Style(name="scaleContent",type="Boolean")]

	/**
	 * Determines how the texture is scaled if <code>scaleContent</code> and
	 * <code>maintainAspectRatio</code> are both set to <code>true</code>.
	 * See the <code>starling.utils.ScaleMode</code> class for details about
	 * each scaling mode.
	 *
	 * <p>If the <code>scaleContent</code> property is set to
	 * <code>false</code>, or the <code>maintainAspectRatio</code> property
	 * is set to false, the <code>scaleMode</code> property is ignored.</p>
	 *
	 * <p>In the following example, the image loader's scale mode is changed:</p>
	 *
	 * <listing version="3.0">
	 * loader.scaleMode = ScaleMode.NO_BORDER;</listing>
	 *
	 * @default starling.utils.ScaleMode.SHOW_ALL
	 *
	 * @see #style:scaleContent
	 * @see #style:maintainAspectRatio
	 * @see http://doc.starling-framework.org/core/starling/utils/ScaleMode.html starling.utils.ScaleMode
	 */
	[Style(name="scaleMode",type="String")]

	/**
	 * The texture smoothing value to use on the internal
	 * <code>starling.display.Image</code>.
	 *
	 * <p>In the following example, the image loader's smoothing is set to a
	 * custom value:</p>
	 *
	 * <listing version="3.0">
	 * loader.textureSmoothing = TextureSmoothing.NONE;</listing>
	 *
	 * @default starling.textures.TextureSmoothing.BILINEAR
	 *
	 * @see http://doc.starling-framework.org/core/starling/textures/TextureSmoothing.html starling.textures.TextureSmoothing
	 * @see http://doc.starling-framework.org/core/starling/display/Mesh.html#textureSmoothing starling.display.Mesh.textureSmoothing
	 */
	[Style(name="textureSmoothing",type="String")]

	/**
	 * The <code>tileGrid</code> value to use on the internal
	 * <code>starling.display.Image</code>.
	 *
	 * <p>In the following example, the image loader's tileGrid is set to a
	 * custom value:</p>
	 *
	 * <listing version="3.0">
	 * loader.tileGrid = Rectangle();</listing>
	 *
	 * @default null
	 *
	 * @see http://doc.starling-framework.org/core/starling/display/Image.html#tileGrid starling.display.Image.tileGrid
	 */
	[Style(name="tileGrid",type="flash.geom.Rectangle")]

	/**
	 * The location where the content is aligned vertically (on
	 * the y-axis) when its height is larger or smaller than the height of
	 * the <code>ImageLoader</code>.
	 *
	 * <p>If the <code>scaleContent</code> property is set to
	 * <code>true</code>, the <code>verticalAlign</code> property is
	 * ignored.</p>
	 *
	 * <p>The following example aligns the content to the bottom:</p>
	 *
	 * <listing version="3.0">
	 * loader.verticalAlign = VerticalAlign.BOTTOM;</listing>
	 * 
	 * <p><strong>Note:</strong> The <code>VerticalAlign.JUSTIFY</code>
	 * constant is not supported.</p>
	 *
	 * @default feathers.layout.VerticalAlign.TOP
	 *
	 * @see #style:scaleContent
	 * @see #style:scaleMode
	 * @see feathers.layout.VerticalAlign#TOP
	 * @see feathers.layout.VerticalAlign#MIDDLE
	 * @see feathers.layout.VerticalAlign#BOTTOM
	 */
	[Style(name="verticalAlign",type="String")]

	/**
	 * Dispatched when the source finishes loading, if the source is a URL. This
	 * event is not dispatched when the source is a texture.
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
	 * @eventType starling.events.Event.COMPLETE
	 */
	[Event(name="complete",type="starling.events.Event")]

	/**
	 * Dispatched periodically as the source loads, if the source is a URL. This
	 * event is not dispatched when the source is a texture.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>A value between 0.0 and 1.0 to indicate
	 *   how much image data has loaded.</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @eventType feathers.events.FeathersEventType.PROGRESS
	 */
	[Event(name="progress",type="starling.events.Event")]

	/**
	 * @private
	 * DEPRECATED: Replaced by <code>Event.IO_ERROR</code> and
	 * <code>Event.SECURITY_ERROR</code>.
	 *
	 * <p><strong>DEPRECATION WARNING:</strong> This event is deprecated
	 * starting with Feathers 2.2. It will be removed in a future version of
	 * Feathers according to the standard
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
	 *
	 * @eventType feathers.events.FeathersEventType.ERROR
	 * 
	 * @see #event:ioError
	 * @see #event:securityError
	 */
	[Event(name="error",type="starling.events.Event")]

	/**
	 * Dispatched if an IO error occurs while loading the source content.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>The <code>flash.events.IOErrorEvent</code>
	 *   dispatched by the loader.</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @eventType starling.events.Event.IO_ERROR
	 */
	[Event(name="ioError",type="starling.events.Event")]

	/**
	 * Dispatched if a security error occurs while loading the source content.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>The <code>flash.events.SecurityErrorEvent</code>
	 *   dispatched by the loader.</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @eventType starling.events.Event.SECURITY_ERROR
	 */
	[Event(name="securityError",type="starling.events.Event")]

	/**
	 * Displays an image, either from an existing <code>Texture</code> object or
	 * from an image file loaded with its URL. Supported image files include ATF
	 * format and any bitmap formats that may be loaded by
	 * <code>flash.display.Loader</code>, including JPG, GIF, and PNG.
	 *
	 * <p>The following example passes a URL to an image loader and listens for
	 * its complete event:</p>
	 *
	 * <listing version="3.0">
	 * var loader:ImageLoader = new ImageLoader();
	 * loader.source = "http://example.com/example.png";
	 * loader.addEventListener( Event.COMPLETE, loader_completeHandler );
	 * this.addChild( loader );</listing>
	 *
	 * <p>The following example passes an existing texture to an image loader:</p>
	 *
	 * <listing version="3.0">
	 * var loader:ImageLoader = new ImageLoader();
	 * loader.source = Texture.fromBitmap( bitmap );
	 * this.addChild( loader );</listing>
	 *
	 * @productversion Feathers 1.0.0
	 */
	public class ImageLoader extends FeathersControl
	{
		/**
		 * @private
		 */
		private static const HELPER_RECTANGLE:Rectangle = new Rectangle();

		/**
		 * @private
		 */
		private static const HELPER_RECTANGLE2:Rectangle = new Rectangle();

		/**
		 * @private
		 */
		private static const CONTEXT_LOST_WARNING:String = "ImageLoader: Context lost while processing loaded image, retrying...";

		/**
		 * @private
		 */
		protected static const ATF_FILE_EXTENSION:String = "atf";

		/**
		 * @private
		 */
		protected static var textureQueueHead:ImageLoader;

		/**
		 * @private
		 */
		protected static var textureQueueTail:ImageLoader;

		/**
		 * The default <code>IStyleProvider</code> for all <code>ImageLoader</code>
		 * components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * Constructor.
		 */
		public function ImageLoader()
		{
			this.isQuickHitAreaEnabled = true;
		}

		/**
		 * The internal <code>starling.display.Image</code> child.
		 */
		protected var image:Image;

		/**
		 * The internal <code>flash.display.Loader</code> used to load textures
		 * from URLs.
		 */
		protected var loader:Loader;

		/**
		 * The internal <code>flash.net.URLLoader</code> used to load raw data
		 * from URLs.
		 */
		protected var urlLoader:URLLoader;

		/**
		 * @private
		 */
		protected var _lastURL:String;

		/**
		 * @private
		 */
		protected var _originalTextureWidth:Number = NaN;

		/**
		 * @private
		 */
		protected var _originalTextureHeight:Number = NaN;

		/**
		 * @private
		 */
		protected var _currentTextureWidth:Number = NaN;

		/**
		 * @private
		 */
		protected var _currentTextureHeight:Number = NaN;

		/**
		 * @private
		 */
		protected var _currentTexture:Texture;

		/**
		 * @private
		 */
		protected var _isRestoringTexture:Boolean = false;

		/**
		 * @private
		 */
		protected var _texture:Texture;

		/**
		 * @private
		 */
		protected var _isTextureOwner:Boolean = false;

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return ImageLoader.globalStyleProvider;
		}

		/**
		 * @private
		 */
		protected var _source:Object;

		/**
		 * The <code>Texture</code> to display, or a URL pointing to an image
		 * file. Supported image files include ATF format and any bitmap formats
		 * that may be loaded by <code>flash.display.Loader</code>, including
		 * JPG, GIF, and PNG.
		 *
		 * <p>In the following example, the image loader's source is set to a
		 * texture:</p>
		 *
		 * <listing version="3.0">
		 * loader.source = Texture.fromBitmap( bitmap );</listing>
		 *
		 * <p>In the following example, the image loader's source is set to the
		 * URL of a PNG image:</p>
		 *
		 * <listing version="3.0">
		 * loader.source = "http://example.com/example.png";</listing>
		 *
		 * @default null
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/Loader.html
		 * @see http://wiki.starling-framework.org/manual/atf_textures
		 */
		public function get source():Object
		{
			return this._source;
		}

		/**
		 * @private
		 */
		public function set source(value:Object):void
		{
			if(this._source == value)
			{
				return;
			}
			this._isRestoringTexture = false;
			if(this._isInTextureQueue)
			{
				this.removeFromTextureQueue();
			}

			var oldTexture:Texture;
			//we should try to reuse the existing texture, if possible.
			if(this._isTextureOwner && value && !(value is Texture))
			{
				oldTexture = this._texture;
				this._isTextureOwner = false;
			}
			this.cleanupTexture();

			//the source variable needs to be set after cleanupTexture() is
			//called because cleanupTexture() needs to know the old source if
			//a TextureCache is in use.
			this._source = value;

			if(oldTexture)
			{
				this._texture = oldTexture;
				this._isTextureOwner = true;
			}
			if(this.image)
			{
				this.image.visible = false;
			}
			this.cleanupLoaders(true);
			this._lastURL = null;
			if(this._source is Texture)
			{
				this._isLoaded = true;
			}
			else
			{

				this._isLoaded = false;
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _textureCache:TextureCache;

		/**
		 * An optional cache for textures.
		 *
		 * <p>In the following example, a cache is provided for textures:</p>
		 *
		 * <listing version="3.0">
		 * var cache:TextureCache = new TextureCache(30);
		 * loader1.textureCache = cache;
		 * loader2.textureCache = cache;</listing>
		 * 
		 * <p><strong>Warning:</strong> the textures in the cache will not be
		 * disposed automatically. When the cache is no longer needed (such as
		 * when the <code>ImageLoader</code> components have all been disposed),
		 * you must call the <code>dispose()</code> method on the
		 * <code>TextureCache</code>. Failing to do so will result in a serious
		 * memory leak.</p>
		 *
		 * @default null
		 */
		public function get textureCache():TextureCache
		{
			return this._textureCache;
		}

		/**
		 * @private
		 */
		public function set textureCache(value:TextureCache):void
		{
			this._textureCache = value;
		}

		/**
		 * @private
		 */
		protected var _loadingTexture:Texture;

		/**
		 * @private
		 */
		public function get loadingTexture():Texture
		{
			return this._loadingTexture;
		}

		/**
		 * @private
		 */
		public function set loadingTexture(value:Texture):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._loadingTexture === value)
			{
				return;
			}
			this._loadingTexture = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _errorTexture:Texture;

		/**
		 * @private
		 */
		public function get errorTexture():Texture
		{
			return this._errorTexture;
		}

		/**
		 * @private
		 */
		public function set errorTexture(value:Texture):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._errorTexture === value)
			{
				return;
			}
			this._errorTexture = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _isLoaded:Boolean = false;

		/**
		 * Indicates if the source has completed loading, if the source is a
		 * URL. Always returns <code>true</code> when the source is a texture.
		 *
		 * <p>In the following example, we check if the image loader's source
		 * has finished loading:</p>
		 *
		 * <listing version="3.0">
		 * if( loader.isLoaded )
		 * {
		 *     //do something
		 * }</listing>
		 */
		public function get isLoaded():Boolean
		{
			return this._isLoaded;
		}

		/**
		 * @private
		 */
		private var _textureScale:Number = 1;

		/**
		 * Scales the texture dimensions during measurement, but does not set
		 * the texture's scale factor. Useful for UI that should scale based on
		 * screen density or resolution without accounting for
		 * <code>contentScaleFactor</code>.
		 *
		 * <p>In the following example, the image loader's texture scale is
		 * customized:</p>
		 *
		 * <listing version="3.0">
		 * loader.textureScale = 0.5;</listing>
		 *
		 * @default 1
		 */
		public function get textureScale():Number
		{
			return this._textureScale;
		}

		/**
		 * @private
		 */
		public function set textureScale(value:Number):void
		{
			if(this._textureScale == value)
			{
				return;
			}
			this._textureScale = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		/**
		 * @private
		 */
		private var _scaleFactor:Number = 1;

		/**
		 * The scale factor value to pass to <code>Texture.fromBitmapData()</code>
		 * when creating a texture loaded from a URL.
		 *
		 * <p>In the following example, the image loader's scale factor is
		 * customized:</p>
		 *
		 * <listing version="3.0">
		 * loader.scaleFactor = 2;</listing>
		 *
		 * @default 1
		 */
		public function get scaleFactor():Number
		{
			return this._scaleFactor;
		}

		/**
		 * @private
		 */
		public function set scaleFactor(value:Number):void
		{
			if(this._scaleFactor == value)
			{
				return;
			}
			this._scaleFactor = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		/**
		 * @private
		 */
		private var _textureSmoothing:String = TextureSmoothing.BILINEAR;

		/**
		 * @private
		 */
		public function get textureSmoothing():String
		{
			return this._textureSmoothing;
		}

		/**
		 * @private
		 */
		public function set textureSmoothing(value:String):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._textureSmoothing === value)
			{
				return;
			}
			this._textureSmoothing = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _scale9Grid:Rectangle;

		/**
		 * @private
		 */
		public function get scale9Grid():Rectangle
		{
			return this._scale9Grid;
		}

		/**
		 * @private
		 */
		public function set scale9Grid(value:Rectangle):void
		{
			if(this._scale9Grid == value)
			{
				return;
			}
			this._scale9Grid = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _tileGrid:Rectangle;

		/**
		 * @private
		 */
		public function get tileGrid():Rectangle
		{
			return this._tileGrid;
		}

		/**
		 * @private
		 */
		public function set tileGrid(value:Rectangle):void
		{
			if(this._tileGrid == value)
			{
				return;
			}
			this._tileGrid = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _pixelSnapping:Boolean = true;

		/**
		 * @private
		 */
		public function get pixelSnapping():Boolean
		{
			return this._pixelSnapping;
		}

		/**
		 * @private
		 */
		public function set pixelSnapping(value:Boolean):void
		{
			if(this._pixelSnapping == value)
			{
				return;
			}
			this._pixelSnapping = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _color:uint = 0xffffff;

		/**
		 * @private
		 */
		public function get color():uint
		{
			return this._color;
		}

		/**
		 * @private
		 */
		public function set color(value:uint):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._color == value)
			{
				return;
			}
			this._color = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _textureFormat:String = Context3DTextureFormat.BGRA;

		/**
		 * The texture format to use when creating a texture loaded from a URL.
		 *
		 * <p>In the following example, the image loader's texture format is set
		 * to a custom value:</p>
		 *
		 * <listing version="3.0">
		 * loader.textureFormat = Context3DTextureFormat.BGRA_PACKED;</listing>
		 *
		 * @default flash.display3d.Context3DTextureFormat.BGRA
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display3D/Context3DTextureFormat.html flash.display3d.Context3DTextureFormat
		 */
		public function get textureFormat():String
		{
			return this._textureFormat;
		}

		/**
		 * @private
		 */
		public function set textureFormat(value:String):void
		{
			if(this._textureFormat == value)
			{
				return;
			}
			this._textureFormat = value;
			this._lastURL = null;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		private var _scaleContent:Boolean = true;

		/**
		 * @private
		 */
		public function get scaleContent():Boolean
		{
			return this._scaleContent;
		}

		/**
		 * @private
		 */
		public function set scaleContent(value:Boolean):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._scaleContent === value)
			{
				return;
			}
			this._scaleContent = value;
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
		}

		/**
		 * @private
		 */
		private var _maintainAspectRatio:Boolean = true;

		/**
		 * @private
		 */
		public function get maintainAspectRatio():Boolean
		{
			return this._maintainAspectRatio;
		}

		/**
		 * @private
		 */
		public function set maintainAspectRatio(value:Boolean):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._maintainAspectRatio === value)
			{
				return;
			}
			this._maintainAspectRatio = value;
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
		}

		/**
		 * @private
		 */
		private var _scaleMode:String = ScaleMode.SHOW_ALL;

		[Inspectable(type="String",enumeration="showAll,noBorder,none")]
		/**
		 * @private
		 */
		public function get scaleMode():String
		{
			return this._scaleMode;
		}

		/**
		 * @private
		 */
		public function set scaleMode(value:String):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._scaleMode === value)
			{
				return;
			}
			this._scaleMode = value;
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
		}

		/**
		 * @private
		 */
		protected var _horizontalAlign:String = HorizontalAlign.LEFT;

		[Inspectable(type="String",enumeration="left,center,right")]
		/**
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._horizontalAlign === value)
			{
				return;
			}
			this._horizontalAlign = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _verticalAlign:String = VerticalAlign.TOP;

		[Inspectable(type="String",enumeration="top,middle,bottom")]
		/**
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._verticalAlign === value)
			{
				return;
			}
			this._verticalAlign = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * The original width of the source content, in pixels. This value will
		 * be <code>0</code> until the source content finishes loading. If the
		 * source is a texture, this value will be <code>0</code> until the
		 * <code>ImageLoader</code> validates.
		 */
		public function get originalSourceWidth():Number
		{
			if(this._originalTextureWidth === this._originalTextureWidth) //!isNaN
			{
				return this._originalTextureWidth;
			}
			return 0;
		}

		/**
		 * The original height of the source content, in pixels. This value will
		 * be <code>0</code> until the source content finishes loading. If the
		 * source is a texture, this value will be <code>0</code> until the
		 * <code>ImageLoader</code> validates.
		 */
		public function get originalSourceHeight():Number
		{
			if(this._originalTextureHeight === this._originalTextureHeight) //!isNaN
			{
				return this._originalTextureHeight;
			}
			return 0;
		}

		/**
		 * @private
		 */
		protected var _pendingBitmapDataTexture:BitmapData;

		/**
		 * @private
		 */
		protected var _pendingRawTextureData:ByteArray;

		/**
		 * @private
		 */
		protected var _delayTextureCreation:Boolean = false;

		/**
		 * Determines if a loaded bitmap may be converted to a texture
		 * immediately after loading. If <code>true</code>, the loaded bitmap
		 * will be saved until this property is set to <code>false</code>, and
		 * only then it will be used to create the texture.
		 *
		 * <p>This property is intended to be used while a parent container,
		 * such as a <code>List</code>, is scrolling in order to keep scrolling
		 * as smooth as possible. Creating textures is expensive and performance
		 * can be affected by it. Set this property to <code>true</code> when
		 * the <code>List</code> dispatches <code>FeathersEventType.SCROLL_START</code>
		 * and set back to false when the <code>List</code> dispatches
		 * <code>FeathersEventType.SCROLL_COMPLETE</code>. You may also need
		 * to set to false if the <code>isScrolling</code> property of the
		 * <code>List</code> is <code>true</code> before you listen to those
		 * events.</p>
		 *
		 * <p>In the following example, the image loader's texture creation is
		 * delayed:</p>
		 *
		 * <listing version="3.0">
		 * loader.delayTextureCreation = true;</listing>
		 *
		 * @default false
		 *
		 * @see #textureQueueDuration
		 * @see feathers.controls.Scroller#event:scrollStart
		 * @see feathers.controls.Scroller#event:scrollComplete
		 * @see feathers.controls.Scroller#isScrolling
		 */
		public function get delayTextureCreation():Boolean
		{
			return this._delayTextureCreation;
		}

		/**
		 * @private
		 */
		public function set delayTextureCreation(value:Boolean):void
		{
			if(this._delayTextureCreation == value)
			{
				return;
			}
			this._delayTextureCreation = value;
			if(!this._delayTextureCreation)
			{
				this.processPendingTexture();
			}
		}

		/**
		 * @private
		 */
		protected var _isInTextureQueue:Boolean = false;

		/**
		 * @private
		 */
		protected var _textureQueuePrevious:ImageLoader;

		/**
		 * @private
		 */
		protected var _textureQueueNext:ImageLoader;

		/**
		 * @private
		 */
		protected var _accumulatedPrepareTextureTime:Number;

		/**
		 * @private
		 */
		protected var _textureQueueDuration:Number = Number.POSITIVE_INFINITY;

		/**
		 * If <code>delayTextureCreation</code> is <code>true</code> and the
		 * duration is not <code>Number.POSITIVE_INFINITY</code>, the loader
		 * will be added to a queue where the textures are uploaded to the GPU
		 * in sequence to avoid significantly affecting performance. Useful for
		 * lists where many textures may need to be uploaded during scrolling.
		 *
		 * <p>If the duration is <code>Number.POSITIVE_INFINITY</code>, the
		 * default value, the texture will not be uploaded until
		 * <code>delayTextureCreation</code> is set to <code>false</code>. In
		 * this situation, the loader will not be added to the queue, and other
		 * loaders with a duration won't be affected.</p>
		 *
		 * <p>In the following example, the image loader's texture creation is
		 * delayed by half a second:</p>
		 *
		 * <listing version="3.0">
		 * loader.delayTextureCreation = true;
		 * loader.textureQueueDuration = 0.5;</listing>
		 *
		 * @default Number.POSITIVE_INFINITY
		 *
		 * @see #delayTextureCreation
		 */
		public function get textureQueueDuration():Number
		{
			return this._textureQueueDuration;
		}

		/**
		 * @private
		 */
		public function set textureQueueDuration(value:Number):void
		{
			if(this._textureQueueDuration == value)
			{
				return;
			}
			var oldDuration:Number = this._textureQueueDuration;
			this._textureQueueDuration = value;
			if(this._delayTextureCreation)
			{
				 if((this._pendingBitmapDataTexture || this._pendingRawTextureData) &&
					oldDuration == Number.POSITIVE_INFINITY && this._textureQueueDuration < Number.POSITIVE_INFINITY)
				{
					this.addToTextureQueue();
				}
				else if(this._isInTextureQueue && this._textureQueueDuration == Number.POSITIVE_INFINITY)
				{
					this.removeFromTextureQueue();
				}
			}
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
		protected var _asyncTextureUpload:Boolean = true;

		/**
		 * Determines if textures loaded from URLs are uploaded asynchronously
		 * or not.
		 * 
		 * <p>Note: depending on the version of AIR and the platform it is
		 * running on, textures may be uploaded synchronously, even when this
		 * property is <code>true</code>.</p>
		 *
		 * <p>In the following example, the texture will be uploaded
		 * synchronously:</p>
		 *
		 * <listing version="3.0">
		 * loader.asyncTextureUpload = false;</listing>
		 * 
		 * @default true
		 */
		public function get asyncTextureUpload():Boolean
		{
			return this._asyncTextureUpload;
		}

		/**
		 * @private
		 */
		public function set asyncTextureUpload(value:Boolean):void
		{
			this._asyncTextureUpload = value;
		}

		/**
		 * @private
		 */
		protected var _imageDecodingOnLoad:Boolean = false;

		/**
		 * @private
		 */
		protected var _loaderContext:LoaderContext = null;

		/**
		 * If the texture is loaded using <code>flash.display.Loader</code>,
		 * a custom <code>flash.system.LoaderContext</code> may optionally
		 * be provided.
		 *
		 * <p>In the following example, a custom loader context is provided:</p>
		 *
		 * <listing version="3.0">
		 * var context:LoaderContext = new LoaderContext();
		 * context.loadPolicyFile = true;
		 * loader.loaderContext = context;
		 * </listing>
		 * 
		 * @see https://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/system/LoaderContext.html flash.system.LoaderContext
		 */
		public function get loaderContext():LoaderContext
		{
			return this._loaderContext;
		}

		/**
		 * @private
		 */
		public function set loaderContext(value:LoaderContext):void
		{
			this._loaderContext = value;
		}

		/**
		 * @private
		 */
		override public function dispose():void
		{
			this._isRestoringTexture = false;
			this.cleanupLoaders(true);
			this.cleanupTexture();
			super.dispose();
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			var layoutInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_LAYOUT);
			var stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);

			if(dataInvalid)
			{
				this.commitData();
			}

			if(dataInvalid || stylesInvalid)
			{
				this.commitStyles();
			}

			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

			if(dataInvalid || layoutInvalid || sizeInvalid || stylesInvalid)
			{
				this.layout();
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

			var heightScale:Number = 1;
			var widthScale:Number = 1;
			if(this._scaleContent && this._maintainAspectRatio &&
				this._scaleMode !== ScaleMode.NONE &&
				this._scale9Grid === null)
			{
				if(!needsHeight)
				{
					heightScale = this._explicitHeight / (this._currentTextureHeight * this._textureScale);
				}
				else if(this._explicitMaxHeight < this._currentTextureHeight)
				{
					heightScale = this._explicitMaxHeight / (this._currentTextureHeight * this._textureScale);
				}
				else if(this._explicitMinHeight > this._currentTextureHeight)
				{
					heightScale = this._explicitMinHeight / (this._currentTextureHeight * this._textureScale);
				}
				if(!needsWidth)
				{
					widthScale = this._explicitWidth / (this._currentTextureWidth * this._textureScale);
				}
				else if(this._explicitMaxWidth < this._currentTextureWidth)
				{
					widthScale = this._explicitMaxWidth / (this._currentTextureWidth * this._textureScale);
				}
				else if(this._explicitMinWidth > this._currentTextureWidth)
				{
					widthScale = this._explicitMinWidth / (this._currentTextureWidth * this._textureScale);
				}
			}

			var newWidth:Number = this._explicitWidth;
			if(needsWidth)
			{
				if(this._currentTextureWidth === this._currentTextureWidth) //!isNaN
				{
					newWidth = this._currentTextureWidth * this._textureScale * heightScale;
				}
				else
				{
					newWidth = 0;
				}
				newWidth += this._paddingLeft + this._paddingRight;
			}

			var newHeight:Number = this._explicitHeight;
			if(needsHeight)
			{
				if(this._currentTextureHeight === this._currentTextureHeight) //!isNaN
				{
					newHeight = this._currentTextureHeight * this._textureScale * widthScale;
				}
				else
				{
					newHeight = 0;
				}
				newHeight += this._paddingTop + this._paddingBottom;
			}

			//this ensures that an ImageLoader can recover from width or height
			//being set to 0 by percentWidth or percentHeight
			if(needsHeight && needsMinHeight)
			{
				//if no height values are set, use the original texture width
				//for the minWidth
				heightScale = 1;
			}
			if(needsWidth && needsMinWidth)
			{
				//if no width values are set, use the original texture height
				//for the minHeight
				widthScale = 1;
			}

			var newMinWidth:Number = this._explicitMinWidth;
			if(needsMinWidth)
			{
				if(this._currentTextureWidth === this._currentTextureWidth) //!isNaN
				{
					newMinWidth = this._currentTextureWidth * this._textureScale * heightScale;
				}
				else
				{
					newMinWidth = 0;
				}
				newMinWidth += this._paddingLeft + this._paddingRight;
			}

			var newMinHeight:Number = this._explicitMinHeight;
			if(needsMinHeight)
			{
				if(this._currentTextureHeight === this._currentTextureHeight) //!isNaN
				{
					newMinHeight = this._currentTextureHeight * this._textureScale * widthScale;
				}
				else
				{
					newMinHeight = 0;
				}
				newMinHeight += this._paddingTop + this._paddingBottom;
			}

			return this.saveMeasurements(newWidth, newHeight, newMinWidth, newMinHeight);
		}

		/**
		 * @private
		 */
		protected function commitData():void
		{
			if(this._source is Texture)
			{
				this._lastURL = null;
				this._texture = Texture(this._source);
				this.refreshCurrentTexture();
			}
			else
			{
				var sourceURL:String = this._source as String;
				if(!sourceURL)
				{
					this._lastURL = null;
				}
				else if(sourceURL != this._lastURL)
				{
					this._lastURL = sourceURL;

					if(this.findSourceInCache())
					{
						return;
					}

					if(isATFURL(sourceURL))
					{
						if(this.loader)
						{
							this.loader = null;
						}
						if(!this.urlLoader)
						{
							this.urlLoader = new URLLoader();
							this.urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
						}
						this.urlLoader.addEventListener(flash.events.Event.COMPLETE, rawDataLoader_completeHandler);
						this.urlLoader.addEventListener(ProgressEvent.PROGRESS, rawDataLoader_progressHandler);
						this.urlLoader.addEventListener(IOErrorEvent.IO_ERROR, rawDataLoader_ioErrorHandler);
						this.urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, rawDataLoader_securityErrorHandler);
						this.urlLoader.load(new URLRequest(sourceURL));
						return;
					}
					else //not ATF
					{
						if(this.urlLoader)
						{
							this.urlLoader = null;
						}
						if(!this.loader)
						{
							this.loader = new Loader();
						}
						this.loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, loader_completeHandler);
						this.loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loader_progressHandler);
						this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loader_ioErrorHandler);
						this.loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_securityErrorHandler);
						if(this._loaderContext === null)
						{
							//create a default loader context that checks
							//policy files, and also decodes images on load for
							//better performance
							this._loaderContext = new LoaderContext(true);
							this._loaderContext.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
						}
						//save this value because the _loaderContext might
						//change before we need to access it.
						//we will need it if we need to clean up the Loader.
						this._imageDecodingOnLoad = this._loaderContext.imageDecodingPolicy === ImageDecodingPolicy.ON_LOAD;
						this.loader.load(new URLRequest(sourceURL), this._loaderContext);
					}
				}
				this.refreshCurrentTexture();
			}
		}

		/**
		 * @private
		 */
		protected function commitStyles():void
		{
			if(!this.image)
			{
				return;
			}
			this.image.textureSmoothing = this._textureSmoothing;
			this.image.color = this._color;
			this.image.scale9Grid = this._scale9Grid;
			this.image.tileGrid = this._tileGrid;
			this.image.pixelSnapping = this._pixelSnapping;
		}

		/**
		 * @private
		 */
		protected function layout():void
		{
			if(!this.image || !this._currentTexture)
			{
				return;
			}
			if(this._scaleContent)
			{
				if(this._maintainAspectRatio && this._scale9Grid === null)
				{
					HELPER_RECTANGLE.x = 0;
					HELPER_RECTANGLE.y = 0;
					HELPER_RECTANGLE.width = this._currentTextureWidth * this._textureScale;
					HELPER_RECTANGLE.height = this._currentTextureHeight * this._textureScale;
					HELPER_RECTANGLE2.x = 0;
					HELPER_RECTANGLE2.y = 0;
					HELPER_RECTANGLE2.width = this.actualWidth - this._paddingLeft - this._paddingRight;
					HELPER_RECTANGLE2.height = this.actualHeight - this._paddingTop - this._paddingBottom;
					RectangleUtil.fit(HELPER_RECTANGLE, HELPER_RECTANGLE2, this._scaleMode, false, HELPER_RECTANGLE);
					this.image.x = HELPER_RECTANGLE.x + this._paddingLeft;
					this.image.y = HELPER_RECTANGLE.y + this._paddingTop;
					this.image.width = HELPER_RECTANGLE.width;
					this.image.height = HELPER_RECTANGLE.height;
				}
				else
				{
					this.image.x = this._paddingLeft;
					this.image.y = this._paddingTop;
					this.image.width = this.actualWidth - this._paddingLeft - this._paddingRight;
					this.image.height = this.actualHeight - this._paddingTop - this._paddingBottom;
				}
			}
			else
			{
				var imageWidth:Number = this._currentTextureWidth * this._textureScale;
				var imageHeight:Number = this._currentTextureHeight * this._textureScale;
				if(this._horizontalAlign === HorizontalAlign.RIGHT)
				{
					this.image.x = this.actualWidth - this._paddingRight - imageWidth;
				}
				else if(this._horizontalAlign === HorizontalAlign.CENTER)
				{
					this.image.x = this._paddingLeft + ((this.actualWidth - this._paddingLeft - this._paddingRight) - imageWidth) / 2;
				}
				else //left
				{
					this.image.x = this._paddingLeft;
				}
				if(this._verticalAlign === VerticalAlign.BOTTOM)
				{
					this.image.y = this.actualHeight - this._paddingBottom - imageHeight;
				}
				else if(this._verticalAlign === VerticalAlign.MIDDLE)
				{
					this.image.y = this._paddingTop + ((this.actualHeight - this._paddingTop - this._paddingBottom) - imageHeight) / 2;
				}
				else //top
				{
					this.image.y = this._paddingTop;
				}
				this.image.width = imageWidth;
				this.image.height = imageHeight;
			}
			if((!this._scaleContent || (this._maintainAspectRatio && this._scaleMode !== ScaleMode.SHOW_ALL)) &&
				(this.actualWidth != imageWidth || this.actualHeight != imageHeight))
			{
				var mask:Quad = this.image.mask as Quad;
				if(mask !== null)
				{
					mask.x = 0;
					mask.y = 0;
					mask.width = this.actualWidth;
					mask.height = this.actualHeight;
				}
				else
				{
					mask = new Quad(1, 1, 0xff00ff);
					//the initial dimensions cannot be 0 or there's a runtime error,
					//and these values might be 0
					mask.width = this.actualWidth;
					mask.height = this.actualHeight;
					this.image.mask = mask;
					this.addChild(mask);
				}
			}
			else
			{
				mask = this.image.mask as Quad;
				if(mask !== null)
				{
					mask.removeFromParent(true);
					this.image.mask = null;
				}
			}
		}

		/**
		 * @private
		 */
		protected function isATFURL(sourceURL:String):Boolean
		{
			var index:int = sourceURL.indexOf("?");
			if(index >= 0)
			{
				sourceURL = sourceURL.substr(0, index);
			}
			return sourceURL.toLowerCase().lastIndexOf(ATF_FILE_EXTENSION) == sourceURL.length - 3;
		}

		/**
		 * @private
		 */
		protected function refreshCurrentTexture():void
		{
			var newTexture:Texture = this._isLoaded ? this._texture : null;
			if(!newTexture)
			{
				if(this.loader || this.urlLoader)
				{
					newTexture = this._loadingTexture;
				}
				else
				{
					newTexture = this._errorTexture;
				}
			}

			if(this._currentTexture == newTexture)
			{
				return;
			}
			this._currentTexture = newTexture;

			if(!this._currentTexture)
			{
				if(this.image)
				{
					this.removeChild(this.image, true);
					this.image = null;
				}
				return;
			}

			//save the texture's frame so that we don't need to create a new
			//rectangle every time that we want to access it.
			var frame:Rectangle = this._currentTexture.frame;
			if(frame)
			{
				this._currentTextureWidth = frame.width;
				this._currentTextureHeight = frame.height;
			}
			else
			{
				this._currentTextureWidth = this._currentTexture.width;
				this._currentTextureHeight = this._currentTexture.height;
				this._originalTextureWidth = this._currentTexture.nativeWidth;
				this._originalTextureHeight = this._currentTexture.nativeHeight;
			}
			if(!this.image)
			{
				this.image = new Image(this._currentTexture);
				this.addChild(this.image);
			}
			else
			{
				this.image.texture = this._currentTexture;
				this.image.readjustSize();
			}
			this.image.visible = true;
		}

		/**
		 * @private
		 */
		protected function cleanupTexture():void
		{
			if(this._texture)
			{
				if(this._isTextureOwner)
				{
					if(!SystemUtil.isDesktop && !SystemUtil.isApplicationActive)
					{
						//avoiding stage3d calls when a mobile application isn't active
						SystemUtil.executeWhenApplicationIsActive(this._texture.dispose);
					}
					else
					{
						this._texture.dispose();
					}
				}
				else if(this._textureCache !== null)
				{
					var cacheKey:String = this.sourceToTextureCacheKey(this._source);
					if(cacheKey !== null)
					{
						this._textureCache.releaseTexture(cacheKey);
					}
				}
			}
			if(this._pendingBitmapDataTexture)
			{
				this._pendingBitmapDataTexture.dispose();
			}
			if(this._pendingRawTextureData)
			{
				this._pendingRawTextureData.clear();
			}
			this._currentTexture = null;
			this._currentTextureWidth = NaN;
			this._currentTextureHeight = NaN;
			this._originalTextureWidth = NaN;
			this._originalTextureHeight = NaN;
			this._pendingBitmapDataTexture = null;
			this._pendingRawTextureData = null;
			this._texture = null;
			this._isTextureOwner = false;
		}

		/**
		 * @private
		 */
		protected function cleanupLoaders(close:Boolean):void
		{
			if(this.urlLoader)
			{
				this.urlLoader.removeEventListener(flash.events.Event.COMPLETE, rawDataLoader_completeHandler);
				this.urlLoader.removeEventListener(ProgressEvent.PROGRESS, rawDataLoader_progressHandler);
				this.urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, rawDataLoader_ioErrorHandler);
				this.urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, rawDataLoader_securityErrorHandler);
				if(close)
				{
					try
					{
						this.urlLoader.close();
					}
					catch(error:Error)
					{
						//no need to do anything in response
					}
				}
				this.urlLoader = null;
			}

			if(this.loader)
			{
				this.loader.contentLoaderInfo.removeEventListener(flash.events.Event.COMPLETE, loader_completeHandler);
				this.loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, loader_progressHandler);
				this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loader_ioErrorHandler);
				this.loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_securityErrorHandler);
				if(close)
				{
					var closed:Boolean = false;
					if(!this._imageDecodingOnLoad)
					{
						//when using ImageDecodingPolicy.ON_LOAD, calling close()
						//seems to cause the image data to get stuck in memory,
						//unable to be garbage collected!
						//to clean up the memory, we need to wait for Event.COMPLETE
						//to dispose the BitmapData and call unload(). we can't do
						//either of those things here.
						try
						{
							this.loader.close();
							closed = true;
						}
						catch(error:Error)
						{
						}
					}
					if(!closed)
					{
						//if we couldn't close() the loader, for some reason,
						//our best option is to let it complete and clean
						//things up then.
						this.loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, orphanedLoader_completeHandler);
						//be sure to add listeners for these events, or errors
						//could be thrown! issue #1627
						this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, orphanedLoader_errorHandler);
						this.loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, orphanedLoader_errorHandler);
					}
				}
				this.loader = null;
			}
		}

		/**
		 * @private
		 */
		protected function findSourceInCache():Boolean
		{
			var cacheKey:String = this.sourceToTextureCacheKey(this._source);
			if(this._textureCache !== null && !this._isRestoringTexture &&
				cacheKey !== null && this._textureCache.hasTexture(cacheKey))
			{
				this._texture = this._textureCache.retainTexture(cacheKey);
				this._isTextureOwner = false;
				this._isRestoringTexture = false;
				this._isLoaded = true;
				this.refreshCurrentTexture();
				this.dispatchEventWith(starling.events.Event.COMPLETE);
				return true;
			}
			return false;
		}

		/**
		 * @private
		 * Subclasses may override this method to support sources other than
		 * URLs in the texture cache.
		 */
		protected function sourceToTextureCacheKey(source:Object):String
		{
			if(source is String)
			{
				return source as String;
			}
			return null;
		}

		/**
		 * @private
		 */
		protected function verifyCurrentStarling():void
		{
			if(this.stage === null || Starling.current.stage === this.stage)
			{
				return;
			}
			this.stage.starling.makeCurrent();
		}

		/**
		 * @private
		 */
		protected function replaceBitmapDataTexture(bitmapData:BitmapData):void
		{
			var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
			if(!starling.contextValid)
			{
				//this trace duplicates the behavior of AssetManager
				trace(CONTEXT_LOST_WARNING);
				setTimeout(replaceBitmapDataTexture, 1, bitmapData);
				return;
			}
			if(!SystemUtil.isDesktop && !SystemUtil.isApplicationActive)
			{
				//avoiding stage3d calls when a mobile application isn't active
				SystemUtil.executeWhenApplicationIsActive(replaceBitmapDataTexture, bitmapData);
				return;
			}
			this.verifyCurrentStarling();

			if(this.findSourceInCache())
			{
				//someone else added this URL to the cache while we were in the
				//middle of loading it. we can reuse the texture from the cache!
				
				//don't forget to dispose the BitmapData, though...
				bitmapData.dispose();
				
				//then invalidate so that everything is resized correctly
				this.invalidate(INVALIDATION_FLAG_DATA);
				return;
			}
			
			if(!this._texture)
			{
				//skip Texture.fromBitmapData() because we don't want
				//it to create an onRestore function that will be
				//immediately discarded for garbage collection.
				try
				{
					this._texture = Texture.empty(bitmapData.width / this._scaleFactor,
						bitmapData.height / this._scaleFactor, true, false, false,
						this._scaleFactor, this._textureFormat);
				}
				catch(error:Error)
				{
					this.cleanupTexture();
					this.invalidate(INVALIDATION_FLAG_DATA);
					this.dispatchEventWith(starling.events.Event.IO_ERROR, false, new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, error.toString()));
					return;
				}
				this._texture.root.onRestore = this.createTextureOnRestore(this._texture,
					this._source, this._textureFormat, this._scaleFactor);
				if(this._textureCache)
				{
					var cacheKey:String = this.sourceToTextureCacheKey(this._source);
					if(cacheKey !== null)
					{
						this._textureCache.addTexture(cacheKey, this._texture, true);
					}
				}
			}
			if(this._asyncTextureUpload)
			{
				this._texture.root.uploadBitmapData(bitmapData, function():void
				{
					if(image !== null)
					{
						//this isn't technically required because other properties of
						//the Image will be changed, but to avoid potential future
						//refactoring headaches, it won't hurt to be extra careful.
						image.setRequiresRedraw();
					}
					bitmapData.dispose();
					_isTextureOwner = _textureCache === null;
					_isRestoringTexture = false;
					_isLoaded = true;
					refreshCurrentTexture();
					invalidate(INVALIDATION_FLAG_DATA);
					dispatchEventWith(starling.events.Event.COMPLETE);
				});
			}
			else //synchronous
			{
				this._texture.root.uploadBitmapData(bitmapData);
				if(this.image !== null)
				{
					//this isn't technically required because other properties of
					//the Image will be changed, but to avoid potential future
					//refactoring headaches, it won't hurt to be extra careful.
					this.image.setRequiresRedraw();
				}
				bitmapData.dispose();
				this._isTextureOwner = this._textureCache === null;
				this._isRestoringTexture = false;
				this._isLoaded = true;
				//let's refresh the texture right away so that properties like
				//originalSourceWidth and originalSourceHeight return the
				//correct values in the Event.COMPLETE listeners.
				this.refreshCurrentTexture();
				//we can still do other things later, like layout
				this.invalidate(INVALIDATION_FLAG_DATA);
				this.dispatchEventWith(starling.events.Event.COMPLETE);
			}
		}

		/**
		 * @private
		 */
		protected function replaceRawTextureData(rawData:ByteArray):void
		{
			var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
			if(!starling.contextValid)
			{
				//this trace duplicates the behavior of AssetManager
				trace(CONTEXT_LOST_WARNING);
				setTimeout(replaceRawTextureData, 1, rawData);
				return;
			}
			if(!SystemUtil.isDesktop && !SystemUtil.isApplicationActive)
			{
				//avoiding stage3d calls when a mobile application isn't active
				SystemUtil.executeWhenApplicationIsActive(replaceRawTextureData, rawData);
				return;
			}
			this.verifyCurrentStarling();

			if(this.findSourceInCache())
			{
				//someone else added this URL to the cache while we were in the
				//middle of loading it. we can reuse the texture from the cache!

				//don't forget to clear the ByteArray, though...
				rawData.clear();

				//then invalidate so that everything is resized correctly
				this.invalidate(INVALIDATION_FLAG_DATA);
				return;
			}
			
			if(this._texture)
			{
				this._texture.root.uploadAtfData(rawData);
			}
			else
			{
				try
				{
					this._texture = Texture.fromAtfData(rawData, this._scaleFactor);
				}
				catch(error:Error)
				{
					this.cleanupTexture();
					this.invalidate(INVALIDATION_FLAG_DATA);
					this.dispatchEventWith(starling.events.Event.IO_ERROR, false, new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, error.toString()));
					return;
				}
				this._texture.root.onRestore = this.createTextureOnRestore(this._texture,
					this._source, this._textureFormat, this._scaleFactor);
				if(this._textureCache)
				{
					var cacheKey:String = this.sourceToTextureCacheKey(this._source);
					if(cacheKey !== null)
					{
						this._textureCache.addTexture(cacheKey, this._texture, true);
					}
				}
			}
			rawData.clear();
			//if we have a cache for the textures, then the cache is the owner
			//because other ImageLoaders may use the same texture.
			this._isTextureOwner = this._textureCache === null;
			this._isRestoringTexture = false;
			this._isLoaded = true;
			this.invalidate(INVALIDATION_FLAG_DATA);
			this.dispatchEventWith(starling.events.Event.COMPLETE);
		}

		/**
		 * @private
		 */
		protected function addToTextureQueue():void
		{
			if(!this._delayTextureCreation)
			{
				throw new IllegalOperationError("Cannot add loader to delayed texture queue if delayTextureCreation is false.");
			}
			if(this._textureQueueDuration == Number.POSITIVE_INFINITY)
			{
				throw new IllegalOperationError("Cannot add loader to delayed texture queue if textureQueueDuration is Number.POSITIVE_INFINITY.");
			}
			if(this._isInTextureQueue)
			{
				throw new IllegalOperationError("Cannot add loader to delayed texture queue more than once.");
			}
			this.addEventListener(starling.events.Event.REMOVED_FROM_STAGE, imageLoader_removedFromStageHandler);
			this._isInTextureQueue = true;
			if(textureQueueTail)
			{
				textureQueueTail._textureQueueNext = this;
				this._textureQueuePrevious = textureQueueTail;
				textureQueueTail = this;
			}
			else
			{
				textureQueueHead = this;
				textureQueueTail = this;
				this.preparePendingTexture();
			}
		}

		/**
		 * @private
		 */
		protected function removeFromTextureQueue():void
		{
			if(!this._isInTextureQueue)
			{
				return;
			}
			var previous:ImageLoader = this._textureQueuePrevious;
			var next:ImageLoader = this._textureQueueNext;
			this._textureQueuePrevious = null;
			this._textureQueueNext = null;
			this._isInTextureQueue = false;
			this.removeEventListener(starling.events.Event.REMOVED_FROM_STAGE, imageLoader_removedFromStageHandler);
			this.removeEventListener(EnterFrameEvent.ENTER_FRAME, processTextureQueue_enterFrameHandler);
			if(previous)
			{
				previous._textureQueueNext = next;
			}
			if(next)
			{
				next._textureQueuePrevious = previous;
			}
			var wasHead:Boolean = textureQueueHead == this;
			var wasTail:Boolean = textureQueueTail == this;
			if(wasTail)
			{
				textureQueueTail = previous;
				if(wasHead)
				{
					textureQueueHead = previous;
				}
			}
			if(wasHead)
			{
				textureQueueHead = next;
				if(wasTail)
				{
					textureQueueTail = next;
				}
			}
			if(wasHead && textureQueueHead)
			{
				textureQueueHead.preparePendingTexture();
			}
		}

		/**
		 * @private
		 */
		protected function preparePendingTexture():void
		{
			if(this._textureQueueDuration > 0)
			{
				this._accumulatedPrepareTextureTime = 0;
				this.addEventListener(EnterFrameEvent.ENTER_FRAME, processTextureQueue_enterFrameHandler);
			}
			else
			{
				this.processPendingTexture();
			}
		}

		/**
		 * @private
		 */
		protected function processPendingTexture():void
		{
			if(this._pendingBitmapDataTexture)
			{
				var bitmapData:BitmapData = this._pendingBitmapDataTexture;
				this._pendingBitmapDataTexture = null;
				this.replaceBitmapDataTexture(bitmapData);
			}
			if(this._pendingRawTextureData)
			{
				var rawData:ByteArray = this._pendingRawTextureData;
				this._pendingRawTextureData = null;
				this.replaceRawTextureData(rawData);
			}
			if(this._isInTextureQueue)
			{
				this.removeFromTextureQueue();
			}
		}

		/**
		 * @private
		 */
		protected function createTextureOnRestore(texture:Texture, source:Object,
			format:String, scaleFactor:Number):Function
		{
			return function():void
			{
				if(_texture === texture)
				{
					texture_onRestore();
					return;
				}
				//this is a hacky way to handle restoring the texture when the
				//current ImageLoader is no longer displaying the texture being
				//restored.
				var otherLoader:ImageLoader = new ImageLoader();
				otherLoader.source = source;
				otherLoader._texture = texture;
				otherLoader._textureFormat = format;
				otherLoader._scaleFactor = scaleFactor;
				otherLoader.validate();
				otherLoader.addEventListener(starling.events.Event.COMPLETE, onRestore_onComplete);
			};
		}

		/**
		 * @private
		 */
		protected function onRestore_onComplete(event:starling.events.Event):void
		{
			var otherLoader:ImageLoader = ImageLoader(event.currentTarget);
			otherLoader._isTextureOwner = false;
			otherLoader._texture = null;
			otherLoader.dispose();
		}

		/**
		 * @private
		 */
		protected function texture_onRestore():void
		{
			//reload the texture from the URL
			this._isRestoringTexture = true;
			this._lastURL = null;
			this._isLoaded = false;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected function processTextureQueue_enterFrameHandler(event:EnterFrameEvent):void
		{
			this._accumulatedPrepareTextureTime += event.passedTime;
			if(this._accumulatedPrepareTextureTime >= this._textureQueueDuration)
			{
				this.removeEventListener(EnterFrameEvent.ENTER_FRAME, processTextureQueue_enterFrameHandler);
				this.processPendingTexture();
			}
		}

		/**
		 * @private
		 */
		protected function imageLoader_removedFromStageHandler(event:starling.events.Event):void
		{
			if(this._isInTextureQueue)
			{
				this.removeFromTextureQueue();
			}
		}

		/**
		 * @private
		 */
		protected function loader_completeHandler(event:flash.events.Event):void
		{
			var bitmap:Bitmap = Bitmap(this.loader.content);
			this.cleanupLoaders(false);

			var bitmapData:BitmapData = bitmap.bitmapData;

			//if the upload is synchronous, attempt to reuse the existing
			//texture so that we don't need to create a new one.
			//when AIR-4198247 is fixed in a stable build, this can be removed
			//(perhaps with some kind of AIR version detection, though)
			var canReuseTexture:Boolean =
				this._texture !== null &&
				(!Texture.asyncBitmapUploadEnabled || !this._asyncTextureUpload) &&
				this._texture.nativeWidth == bitmapData.width &&
				this._texture.nativeHeight == bitmapData.height &&
				this._texture.scale == this._scaleFactor &&
				this._texture.format == this._textureFormat;
			if(!canReuseTexture)
			{
				this.cleanupTexture();
				if(this._textureCache)
				{
					//we need to replace the current texture in the cache,
					//so we need to remove the old one so that the cache
					//doesn't throw an error because there's already a
					//texture with this key.
					var key:String = this.sourceToTextureCacheKey(this._source);
					this._textureCache.removeTexture(key);
				}
			}
			if(this._delayTextureCreation && !this._isRestoringTexture)
			{
				this._pendingBitmapDataTexture = bitmapData;
				if(this._textureQueueDuration < Number.POSITIVE_INFINITY)
				{
					this.addToTextureQueue();
				}
			}
			else
			{
				this.replaceBitmapDataTexture(bitmapData);
			}
		}

		/**
		 * @private
		 */
		protected function loader_progressHandler(event:ProgressEvent):void
		{
			this.dispatchEventWith(FeathersEventType.PROGRESS, false, event.bytesLoaded / event.bytesTotal);
		}

		/**
		 * @private
		 */
		protected function loader_ioErrorHandler(event:IOErrorEvent):void
		{
			this.cleanupLoaders(false);
			this.cleanupTexture();
			this.invalidate(INVALIDATION_FLAG_DATA);
			this.dispatchEventWith(FeathersEventType.ERROR, false, event);
			this.dispatchEventWith(starling.events.Event.IO_ERROR, false, event);
		}

		/**
		 * @private
		 */
		protected function loader_securityErrorHandler(event:SecurityErrorEvent):void
		{
			this.cleanupLoaders(false);
			this.cleanupTexture();
			this.invalidate(INVALIDATION_FLAG_DATA);
			this.dispatchEventWith(FeathersEventType.ERROR, false, event);
			this.dispatchEventWith(starling.events.Event.SECURITY_ERROR, false, event);
		}

		/**
		 * @private
		 */
		protected function orphanedLoader_completeHandler(event:flash.events.Event):void
		{
			var loaderInfo:LoaderInfo = LoaderInfo(event.currentTarget);
			loaderInfo.removeEventListener(flash.events.Event.COMPLETE, orphanedLoader_completeHandler);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, orphanedLoader_errorHandler);
			loaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, orphanedLoader_errorHandler);
			var loader:Loader = loaderInfo.loader;
			var bitmap:Bitmap = Bitmap(loader.content);
			bitmap.bitmapData.dispose();
			//we could call unloadAndStop() and force the garbage collector to
			//run, but that could hurt performance, so let it happen naturally.
			loader.unload();
		}

		/**
		 * @private
		 */
		protected function orphanedLoader_errorHandler(event:flash.events.Event):void
		{
			var loaderInfo:LoaderInfo = LoaderInfo(event.currentTarget);
			loaderInfo.removeEventListener(flash.events.Event.COMPLETE, orphanedLoader_completeHandler);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, orphanedLoader_errorHandler);
			loaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, orphanedLoader_errorHandler);
			//no need to do anything else. this listener only exists to avoid
			//a runtime error on an resource that is no longer required
		}

		/**
		 * @private
		 */
		protected function rawDataLoader_completeHandler(event:flash.events.Event):void
		{
			var rawData:ByteArray = ByteArray(this.urlLoader.data);
			this.cleanupLoaders(false);

			//only clear the texture if we're not restoring
			if(!this._isRestoringTexture)
			{
				this.cleanupTexture();
			}
			if(this._delayTextureCreation && !this._isRestoringTexture)
			{
				this._pendingRawTextureData = rawData;
				if(this._textureQueueDuration < Number.POSITIVE_INFINITY)
				{
					this.addToTextureQueue();
				}
			}
			else
			{
				this.replaceRawTextureData(rawData);
			}
		}

		/**
		 * @private
		 */
		protected function rawDataLoader_progressHandler(event:ProgressEvent):void
		{
			this.dispatchEventWith(FeathersEventType.PROGRESS, false, event.bytesLoaded / event.bytesTotal);
		}

		/**
		 * @private
		 */
		protected function rawDataLoader_ioErrorHandler(event:ErrorEvent):void
		{
			this.cleanupLoaders(false);
			this.cleanupTexture();
			this.invalidate(INVALIDATION_FLAG_DATA);
			this.dispatchEventWith(FeathersEventType.ERROR, false, event);
			this.dispatchEventWith(starling.events.Event.IO_ERROR, false, event);
		}

		/**
		 * @private
		 */
		protected function rawDataLoader_securityErrorHandler(event:ErrorEvent):void
		{
			this.cleanupLoaders(false);
			this.cleanupTexture();
			this.invalidate(INVALIDATION_FLAG_DATA);
			this.dispatchEventWith(FeathersEventType.ERROR, false, event);
			this.dispatchEventWith(starling.events.Event.SECURITY_ERROR, false, event);
		}
	}
}