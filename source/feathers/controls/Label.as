/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.core.FeathersControl;
	import feathers.core.ITextBaselineControl;
	import feathers.core.ITextRenderer;
	import feathers.core.PropertyProxy;
	import feathers.skins.IStyleProvider;

	import flash.geom.Point;

	import starling.display.DisplayObject;

	/**
	 * Displays text using a text renderer.
	 *
	 * @see ../../../help/label.html How to use the Feathers Label component
	 * @see ../../../help/text-renderers.html Introduction to Feathers text renderers
	 */
	public class Label extends FeathersControl implements ITextBaselineControl
	{
		/**
		 * @private
		 */
		private static const HELPER_POINT:Point = new Point();

		/**
		 * An alternate style name to use with <code>Label</code> to allow a
		 * theme to give it a larger style meant for headings. If a theme does
		 * not provide a style for a heading label, the theme will automatically
		 * fall back to using the default style for a label.
		 *
		 * <p>An alternate style name should always be added to a component's
		 * <code>styleNameList</code> before the component is initialized. If
		 * the style name is added later, it will be ignored.</p>
		 *
		 * <p>In the following example, the heading style is applied to a label:</p>
		 *
		 * <listing version="3.0">
		 * var label:Label = new Label();
		 * label.text = "Very Important Heading";
		 * label.styleNameList.add( Label.ALTERNATE_STYLE_NAME_HEADING );
		 * this.addChild( label );</listing>
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const ALTERNATE_STYLE_NAME_HEADING:String = "feathers-heading-label";

		/**
		 * An alternate style name to use with <code>Label</code> to allow a
		 * theme to give it a smaller style meant for less-important details. If
		 * a theme does not provide a style for a detail label, the theme will
		 * automatically fall back to using the default style for a label.
		 *
		 * <p>An alternate style name should always be added to a component's
		 * <code>styleNameList</code> before the component is initialized. If
		 * the style name is added later, it will be ignored.</p>
		 *
		 * <p>In the following example, the detail style is applied to a label:</p>
		 *
		 * <listing version="3.0">
		 * var label:Label = new Label();
		 * label.text = "Less important, detailed text";
		 * label.styleNameList.add( Label.ALTERNATE_STYLE_NAME_DETAIL );
		 * this.addChild( label );</listing>
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const ALTERNATE_STYLE_NAME_DETAIL:String = "feathers-detail-label";

		/**
		 * The default <code>IStyleProvider</code> for all <code>Label</code>
		 * components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * Constructor.
		 */
		public function Label()
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
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return Label.globalStyleProvider;
		}

		/**
		 * @private
		 */
		protected var _text:String = null;

		/**
		 * The text displayed by the label.
		 *
		 * <p>In the following example, the label's text is updated:</p>
		 *
		 * <listing version="3.0">
		 * label.text = "Hello World";</listing>
		 *
		 * @default null
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
			if(this._text == value)
			{
				return;
			}
			this._text = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _wordWrap:Boolean = false;

		/**
		 * Determines if the text wraps to the next line when it reaches the
		 * width (or max width) of the component.
		 *
		 * <p>In the following example, the label's text is wrapped:</p>
		 *
		 * <listing version="3.0">
		 * label.wordWrap = true;</listing>
		 *
		 * @default false
		 */
		public function get wordWrap():Boolean
		{
			return this._wordWrap;
		}

		/**
		 * @private
		 */
		public function set wordWrap(value:Boolean):void
		{
			if(this._wordWrap == value)
			{
				return;
			}
			this._wordWrap = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * The baseline measurement of the text, in pixels.
		 */
		public function get baseline():Number
		{
			if(!this.textRenderer)
			{
				return 0;
			}
			return this.textRenderer.y + this.textRenderer.baseline;
		}

		/**
		 * @private
		 */
		protected var _textRendererFactory:Function;

		/**
		 * A function used to instantiate the label's text renderer
		 * sub-component. By default, the label will use the global text
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
		 * to the label:</p>
		 *
		 * <listing version="3.0">
		 * label.textRendererFactory = function():ITextRenderer
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
		protected var _textRendererProperties:PropertyProxy;

		/**
		 * An object that stores properties for the label's text renderer
		 * sub-component, and the properties will be passed down to the text
		 * renderer when the label validates. The available properties
		 * depend on which <code>ITextRenderer</code> implementation is returned
		 * by <code>textRendererFactory</code>. Refer to
		 * <a href="../core/ITextRenderer.html"><code>feathers.core.ITextRenderer</code></a>
		 * for a list of available text renderer implementations.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
		 * which is in a <code>List</code>, you can use the following syntax:</p>
		 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * <p>Setting properties in a <code>textRendererFactory</code> function
		 * instead of using <code>textRendererProperties</code> will result in
		 * better performance.</p>
		 *
		 * <p>In the following example, the label's text renderer's properties
		 * are updated (this example assumes that the label text renderer is a
		 * <code>TextFieldTextRenderer</code>):</p>
		 *
		 * <listing version="3.0">
		 * label.textRendererProperties.textFormat = new TextFormat( "Source Sans Pro", 16, 0x333333 );
		 * label.textRendererProperties.embedFonts = true;</listing>
		 *
		 * @default null
		 *
		 * @see #textRendererFactory
		 * @see feathers.core.ITextRenderer
		 */
		public function get textRendererProperties():Object
		{
			if(!this._textRendererProperties)
			{
				this._textRendererProperties = new PropertyProxy(textRendererProperties_onChange);
			}
			return this._textRendererProperties;
		}

		/**
		 * @private
		 */
		public function set textRendererProperties(value:Object):void
		{
			if(this._textRendererProperties == value)
			{
				return;
			}
			if(value && !(value is PropertyProxy))
			{
				value = PropertyProxy.fromObject(value);
			}
			if(this._textRendererProperties)
			{
				this._textRendererProperties.removeOnChangeCallback(textRendererProperties_onChange);
			}
			this._textRendererProperties = PropertyProxy(value);
			if(this._textRendererProperties)
			{
				this._textRendererProperties.addOnChangeCallback(textRendererProperties_onChange);
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
		 * The default background to display behind the label's text.
		 *
		 * <p>In the following example, the label is given a background skin:</p>
		 *
		 * <listing version="3.0">
		 * label.backgroundSkin = new Image( texture );</listing>
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

			if(this._backgroundSkin && this.currentBackgroundSkin == this._backgroundSkin)
			{
				this.removeChild(this._backgroundSkin);
				this.currentBackgroundSkin = null;
			}
			this._backgroundSkin = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _backgroundDisabledSkin:DisplayObject;

		/**
		 * A background to display when the label is disabled.
		 *
		 * <p>In the following example, the label is given a disabled background skin:</p>
		 *
		 * <listing version="3.0">
		 * label.backgroundDisabledSkin = new Image( texture );</listing>
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

			if(this._backgroundDisabledSkin && this.currentBackgroundSkin == this._backgroundDisabledSkin)
			{
				this.removeChild(this._backgroundDisabledSkin);
				this.currentBackgroundSkin = null;
			}
			this._backgroundDisabledSkin = value;
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
		 * label.padding = 20;</listing>
		 *
		 * @default 0
		 *
		 * @see #paddingTop
		 * @see #paddingRight
		 * @see #paddingBottom
		 * @see #paddingLeft
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
		 * The minimum space, in pixels, between the label's top edge and the
		 * label's text.
		 *
		 * <p>In the following example, the top padding is set to 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * label.paddingTop = 20;</listing>
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
		 * The minimum space, in pixels, between the label's right edge and
		 * the label's text.
		 *
		 * <p>In the following example, the right padding is set to 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * label.paddingRight = 20;</listing>
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
		 * The minimum space, in pixels, between the label's bottom edge and
		 * the label's text.
		 *
		 * <p>In the following example, the bottom padding is set to 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * label.paddingBottom = 20;</listing>
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
		 * The minimum space, in pixels, between the label's left edge and the
		 * label's text.
		 *
		 * <p>In the following example, the left padding is set to 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * label.paddingLeft = 20;</listing>
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
		override protected function draw():void
		{
			var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			var stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			var stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			var textRendererInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_TEXT_RENDERER);

			if(sizeInvalid || stylesInvalid || stateInvalid)
			{
				this.refreshBackgroundSkin();
			}

			if(textRendererInvalid)
			{
				this.createTextRenderer();
			}

			if(textRendererInvalid || dataInvalid || stateInvalid)
			{
				this.refreshTextRendererData();
			}

			if(textRendererInvalid || stateInvalid)
			{
				this.refreshEnabled();
			}

			if(textRendererInvalid || stylesInvalid || stateInvalid)
			{
				this.refreshTextRendererStyles();
			}

			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

			this.layoutChildren();
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
			this.textRenderer.minWidth = this._minWidth - this._paddingLeft - this._paddingRight;
			this.textRenderer.maxWidth = this._maxWidth - this._paddingLeft - this._paddingRight;
			this.textRenderer.width = this.explicitWidth - this._paddingLeft - this._paddingRight;
			this.textRenderer.minHeight = this._minHeight - this._paddingTop - this._paddingBottom;
			this.textRenderer.maxHeight = this._maxHeight - this._paddingTop - this._paddingBottom;
			this.textRenderer.height = this.explicitHeight - this._paddingTop - this._paddingBottom;
			this.textRenderer.measureText(HELPER_POINT);
			var newWidth:Number = this.explicitWidth;
			if(needsWidth)
			{
				if(this._text)
				{
					newWidth = HELPER_POINT.x;
				}
				else
				{
					newWidth = 0;
				}
				if(this.originalBackgroundWidth === this.originalBackgroundWidth &&
					this.originalBackgroundWidth > newWidth) //!isNaN
				{
					newWidth = this.originalBackgroundWidth;
				}
				newWidth += this._paddingLeft + this._paddingRight;
			}

			var newHeight:Number = this.explicitHeight;
			if(needsHeight)
			{
				if(this._text)
				{
					newHeight = HELPER_POINT.y;
				}
				else
				{
					newHeight = 0;
				}
				if(this.originalBackgroundHeight === this.originalBackgroundHeight &&
					this.originalBackgroundHeight > newHeight) //!isNaN
				{
					newHeight = this.originalBackgroundHeight;
				}
				newHeight += this._paddingTop + this._paddingBottom;
			}

			return this.setSizeInternal(newWidth, newHeight, false);
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
			this.addChild(DisplayObject(this.textRenderer));
		}

		/**
		 * Choose the appropriate background skin based on the control's current
		 * state.
		 */
		protected function refreshBackgroundSkin():void
		{
			var newCurrentBackgroundSkin:DisplayObject = this._backgroundSkin;
			if(!this._isEnabled && this._backgroundDisabledSkin)
			{
				newCurrentBackgroundSkin = this._backgroundDisabledSkin;
			}
			if(this.currentBackgroundSkin != newCurrentBackgroundSkin)
			{
				if(this.currentBackgroundSkin)
				{
					this.removeChild(this.currentBackgroundSkin);
				}
				this.currentBackgroundSkin = newCurrentBackgroundSkin;
				if(this.currentBackgroundSkin)
				{
					this.addChildAt(this.currentBackgroundSkin, 0);
				}
			}
			if(this.currentBackgroundSkin)
			{
				//force it to the bottom
				this.setChildIndex(this.currentBackgroundSkin, 0);

				if(this.originalBackgroundWidth !== this.originalBackgroundWidth) //isNaN
				{
					this.originalBackgroundWidth = this.currentBackgroundSkin.width;
				}
				if(this.originalBackgroundHeight !== this.originalBackgroundHeight) //isNaN
				{
					this.originalBackgroundHeight = this.currentBackgroundSkin.height;
				}
			}
		}

		/**
		 * Positions and sizes children based on the actual width and height
		 * values.
		 */
		protected function layoutChildren():void
		{
			if(this.currentBackgroundSkin)
			{
				this.currentBackgroundSkin.x = 0;
				this.currentBackgroundSkin.y = 0;
				this.currentBackgroundSkin.width = this.actualWidth;
				this.currentBackgroundSkin.height = this.actualHeight;
			}
			this.textRenderer.x = this._paddingLeft;
			this.textRenderer.y = this._paddingTop;
			this.textRenderer.width = this.actualWidth - this._paddingLeft - this._paddingRight;
			this.textRenderer.height = this.actualHeight - this._paddingTop - this._paddingBottom;
			this.textRenderer.validate();
		}

		/**
		 * @private
		 */
		protected function refreshEnabled():void
		{
			this.textRenderer.isEnabled = this._isEnabled;
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
		protected function refreshTextRendererStyles():void
		{
			this.textRenderer.wordWrap = this._wordWrap;
			for(var propertyName:String in this._textRendererProperties)
			{
				var propertyValue:Object = this._textRendererProperties[propertyName];
				this.textRenderer[propertyName] = propertyValue;
			}
		}

		/**
		 * @private
		 */
		protected function textRendererProperties_onChange(proxy:PropertyProxy, propertyName:String):void
		{
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
	}
}
