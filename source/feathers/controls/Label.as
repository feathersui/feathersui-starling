/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.core.FeathersControl;
	import feathers.core.ITextBaselineControl;
	import feathers.core.ITextRenderer;
	import feathers.core.IValidating;
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
		 * DEPRECATED: Replaced by <code>Label.ALTERNATE_STYLE_NAME_HEADING</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 2.1. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 *
		 * @see Label#ALTERNATE_STYLE_NAME_HEADING
		 */
		public static const ALTERNATE_NAME_HEADING:String = ALTERNATE_STYLE_NAME_HEADING;

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
		 * DEPRECATED: Replaced by <code>Label.ALTERNATE_STYLE_NAME_DETAIL</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 2.1. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 *
		 * @see Label#ALTERNATE_STYLE_NAME_DETAIL
		 */
		public static const ALTERNATE_NAME_DETAIL:String = ALTERNATE_STYLE_NAME_DETAIL;

		/**
		 * The icon will be positioned above the text.
		 *
		 * @see #iconPosition
		 */
		public static const ICON_POSITION_TOP:String = "top";
		
		/**
		 * The icon will be positioned to the right of the text.
		 *
		 * @see #iconPosition
		 */
		public static const ICON_POSITION_RIGHT:String = "right";
		
		/**
		 * The icon will be positioned below the text.
		 *
		 * @see #iconPosition
		 */
		public static const ICON_POSITION_BOTTOM:String = "bottom";
		
		/**
		 * The icon will be positioned to the left of the text.
		 *
		 * @see #iconPosition
		 */
		public static const ICON_POSITION_LEFT:String = "left";

		/**
		 * The icon will be positioned manually with no relation to the position
		 * of the text. Use <code>iconOffsetX</code> and <code>iconOffsetY</code>
		 * to set the icon's position.
		 *
		 * @see #iconPosition
		 * @see #iconOffsetX
		 * @see #iconOffsetY
		 */
		public static const ICON_POSITION_MANUAL:String = "manual";
		
		/**
		 * The icon will be positioned to the left the text, and the bottom of
		 * the icon will be aligned to the baseline of the text.
		 *
		 * @see #iconPosition
		 */
		public static const ICON_POSITION_LEFT_BASELINE:String = "leftBaseline";
		
		/**
		 * The icon will be positioned to the right the label, and the bottom of
		 * the icon will be aligned to the baseline of the text.
		 *
		 * @see #iconPosition
		 */
		public static const ICON_POSITION_RIGHT_BASELINE:String = "rightBaseline";
		
		/**
		 * The icon and text will be aligned horizontally to the left edge of the label.
		 *
		 * @see #horizontalAlign
		 */
		public static const HORIZONTAL_ALIGN_LEFT:String = "left";
		
		/**
		 * The icon and text will be aligned horizontally to the center of the label.
		 *
		 * @see #horizontalAlign
		 */
		public static const HORIZONTAL_ALIGN_CENTER:String = "center";
		
		/**
		 * The icon and text will be aligned horizontally to the right edge of the label.
		 *
		 * @see #horizontalAlign
		 */
		public static const HORIZONTAL_ALIGN_RIGHT:String = "right";
		
		/**
		 * The icon and text will be aligned vertically to the top edge of the label.
		 *
		 * @see #verticalAlign
		 */
		public static const VERTICAL_ALIGN_TOP:String = "top";
		
		/**
		 * The icon and text will be aligned vertically to the middle of the label.
		 *
		 * @see #verticalAlign
		 */
		public static const VERTICAL_ALIGN_MIDDLE:String = "middle";
		
		/**
		 * The icon and text will be aligned vertically to the bottom edge of the label.
		 *
		 * @see #verticalAlign
		 */
		public static const VERTICAL_ALIGN_BOTTOM:String = "bottom";

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
		 * width of the component.
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
		 * A set of key/value pairs to be passed down to the text renderer. The
		 * text renderer is an <code>ITextRenderer</code> instance. The
		 * available properties depend on which <code>ITextRenderer</code>
		 * implementation is returned by <code>textRendererFactory</code>. The
		 * most common implementations are <code>BitmapFontTextRenderer</code>
		 * and <code>TextFieldTextRenderer</code>.
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
		 * @see feathers.controls.text.BitmapFontTextRenderer
		 * @see feathers.controls.text.TextFieldTextRenderer
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
		 * @private
		 */
		protected var currentIconSkin:DisplayObject;
		
		/**
		 * @private
		 */
		protected var _iconSkin:DisplayObject;
		
		/**
		 * An optional icon displayed with the label.
		 *
		 * <p>The following example gives the label an icon</p>
		 *
		 * <listing version="3.0">
		 * label.iconSkin = new Image( texture );</listing>
		 *
		 * @default null
		 */
		public function get iconSkin():DisplayObject
		{
			return _iconSkin;
		}
		
		/**
		 * @private
		 */
		public function set iconSkin(value:DisplayObject):void
		{
			if(this._iconSkin == value)
			{
				return;
			}
			if(this._iconSkin && this.currentIconSkin == this._iconSkin)
			{
				this.removeChild(this._iconSkin);
				this.currentIconSkin = null;
			}
			this._iconSkin = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		/**
		 * @private
		 */
		protected var _iconDisabledSkin:DisplayObject;
		
		/**
		 * An optional disabled icon displayed with the label.
		 * 
		 * <p>The following example gives the label a disabled icon</p>
		 *
		 * <listing version="3.0">
		 * label.iconDisabledSkin = new Image( texture );</listing>
		 *
		 * @default null
		 */
		public function get iconDisabledSkin():DisplayObject
		{
			return _iconDisabledSkin;
		}
		
		/**
		 * @private
		 */
		public function set iconDisabledSkin(value:DisplayObject):void
		{
			if(this._iconDisabledSkin == value)
			{
				return;
			}
			if(this._iconDisabledSkin && this.currentIconSkin == this._iconDisabledSkin)
			{
				this.removeChild(this._iconDisabledSkin);
				this.currentIconSkin = null;
			}
			this._iconDisabledSkin = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		/**
		 * @private
		 */
		protected var _iconPosition:String = ICON_POSITION_LEFT;

		[Inspectable(type="String",enumeration="top,right,bottom,left,rightBaseline,leftBaseline,manual")]
		/**
		 * The location of the icon, relative to the label.
		 *
		 * <p>The following example positions the icon to the right of the
		 * label:</p>
		 *
		 * <listing version="3.0">
		 * label.text = "Hello World";
		 * label.defaultIcon = new Image( texture );
		 * label.iconPosition = Label.ICON_POSITION_RIGHT;</listing>
		 *
		 * @default Label.ICON_POSITION_LEFT
		 *
		 * @see #ICON_POSITION_TOP
		 * @see #ICON_POSITION_RIGHT
		 * @see #ICON_POSITION_BOTTOM
		 * @see #ICON_POSITION_LEFT
		 * @see #ICON_POSITION_RIGHT_BASELINE
		 * @see #ICON_POSITION_LEFT_BASELINE
		 * @see #ICON_POSITION_MANUAL
		 */
		public function get iconPosition():String
		{
			return this._iconPosition;
		}
		
		/**
		 * @private
		 */
		public function set iconPosition(value:String):void
		{
			if(this._iconPosition == value)
			{
				return;
			}
			this._iconPosition = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		/**
		 * @private
		 */
		protected var _gap:Number = 0;
		
		/**
		 * The space, in pixels, between the icon and the label. Applies to
		 * either horizontal or vertical spacing, depending on the value of
		 * <code>iconPosition</code>.
		 * 
		 * <p>If <code>gap</code> is set to <code>Number.POSITIVE_INFINITY</code>,
		 * the label and icon will be positioned as far apart as possible. In
		 * other words, they will be positioned at the edges of the label,
		 * adjusted for padding.</p>
		 *
		 * <p>The following example creates a gap of 50 pixels between the label
		 * and the icon:</p>
		 *
		 * <listing version="3.0">
		 * label.text = "Hello World";
		 * label.iconSkin = new Image( texture );
		 * label.gap = 50;</listing>
		 *
		 * @default 0
		 * 
		 * @see #iconPosition
		 * @see #minGap
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
			if(this._gap == value)
			{
				return;
			}
			this._gap = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _minGap:Number = 0;

		/**
		 * If the value of the <code>gap</code> property is
		 * <code>Number.POSITIVE_INFINITY</code>, meaning that the gap will
		 * fill as much space as possible, the final calculated value will not be
		 * smaller than the value of the <code>minGap</code> property.
		 *
		 * <p>The following example ensures that the gap is never smaller than
		 * 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * label.gap = Number.POSITIVE_INFINITY;
		 * label.minGap = 20;</listing>
		 *
		 * @default 0
		 *
		 * @see #gap
		 */
		public function get minGap():Number
		{
			return this._minGap;
		}

		/**
		 * @private
		 */
		public function set minGap(value:Number):void
		{
			if(this._minGap == value)
			{
				return;
			}
			this._minGap = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		/**
		 * @private
		 */
		protected var _horizontalAlign:String = HORIZONTAL_ALIGN_LEFT;

		[Inspectable(type="String",enumeration="left,center,right")]
		/**
		 * The location where the label's content is aligned horizontally (on
		 * the x-axis).
		 *
		 * <p>The following example aligns the label's content to the center:</p>
		 *
		 * <listing version="3.0">
		 * label.horizontalAlign = Label.HORIZONTAL_ALIGN_CENTER;</listing>
		 *
		 * @default Label.HORIZONTAL_ALIGN_LEFT
		 *
		 * @see #HORIZONTAL_ALIGN_LEFT
		 * @see #HORIZONTAL_ALIGN_CENTER
		 * @see #HORIZONTAL_ALIGN_RIGHT
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

		[Inspectable(type="String",enumeration="top,middle,bottom")]
		/**
		 * The location where the label's content is aligned vertically (on
		 * the y-axis).
		 *
		 * <p>The following example aligns the label's content to the top:</p>
		 *
		 * <listing version="3.0">
		 * label.verticalAlign = Label.VERTICAL_ALIGN_TOP;</listing>
		 *
		 * @default Label.VERTICAL_ALIGN_MIDDLE
		 *
		 * @see #VERTICAL_ALIGN_TOP
		 * @see #VERTICAL_ALIGN_MIDDLE
		 * @see #VERTICAL_ALIGN_BOTTOM
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
		protected var _textOffsetX:Number = 0;

		/**
		 * Offsets the x position of the text by a certain number of pixels.
		 * This does not affect the measurement of the label. The label will
		 * measure itself as if the text were not offset from its original
		 * position.
		 *
		 * <p>The following example offsets the x position of the label's text
		 * by 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * label.textOffsetX = 20;</listing>
		 *
		 * @default 0
		 *
		 * @see #labelOffsetY
		 */
		public function get textOffsetX():Number
		{
			return this._textOffsetX;
		}

		/**
		 * @private
		 */
		public function set textOffsetX(value:Number):void
		{
			if(this._textOffsetX == value)
			{
				return;
			}
			this._textOffsetX = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _textOffsetY:Number = 0;

		/**
		 * Offsets the y position of the text by a certain number of pixels.
		 * This does not affect the measurement of the label. The label will
		 * measure itself as if the text were not offset from its original
		 * position.
		 *
		 * <p>The following example offsets the y position of the label's text
		 * by 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * label.textOffsetY = 20;</listing>
		 *
		 * @default 0
		 *
		 * @see #labelOffsetX
		 */
		public function get textOffsetY():Number
		{
			return this._textOffsetY;
		}

		/**
		 * @private
		 */
		public function set textOffsetY(value:Number):void
		{
			if(this._textOffsetY == value)
			{
				return;
			}
			this._textOffsetY = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _iconOffsetX:Number = 0;

		/**
		 * Offsets the x position of the icon by a certain number of pixels.
		 * This does not affect the measurement of the label. The label will
		 * measure itself as if the icon were not offset from its original
		 * position.
		 *
		 * <p>The following example offsets the x position of the label's icon
		 * by 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * label.iconOffsetX = 20;</listing>
		 *
		 * @default 0
		 *
		 * @see #iconOffsetY
		 */
		public function get iconOffsetX():Number
		{
			return this._iconOffsetX;
		}

		/**
		 * @private
		 */
		public function set iconOffsetX(value:Number):void
		{
			if(this._iconOffsetX == value)
			{
				return;
			}
			this._iconOffsetX = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _iconOffsetY:Number = 0;

		/**
		 * Offsets the y position of the icon by a certain number of pixels.
		 * This does not affect the measurement of the label. The label will
		 * measure itself as if the icon were not offset from its original
		 * position.
		 *
		 * <p>The following example offsets the y position of the label's icon
		 * by 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * label.iconOffsetY = 20;</listing>
		 *
		 * @default 0
		 *
		 * @see #iconOffsetX
		 */
		public function get iconOffsetY():Number
		{
			return this._iconOffsetY;
		}

		/**
		 * @private
		 */
		public function set iconOffsetY(value:Number):void
		{
			if(this._iconOffsetY == value)
			{
				return;
			}
			this._iconOffsetY = value;
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
			
			if(stylesInvalid || stateInvalid)
			{
				this.refreshIconSkin();
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
			this.refreshMaxLabelWidth(true);
			this.textRenderer.measureText(HELPER_POINT);
			var newWidth:Number = this.explicitWidth;
			if(needsWidth)
			{
				if(this.currentIconSkin && this.text)
				{
					if(this._iconPosition != ICON_POSITION_TOP && this._iconPosition != ICON_POSITION_BOTTOM &&
						this._iconPosition != ICON_POSITION_MANUAL)
					{
						var adjustedGap:Number = this._gap;
						if(adjustedGap == Number.POSITIVE_INFINITY)
						{
							adjustedGap = this._minGap;
						}
						newWidth = this.currentIconSkin.width + adjustedGap + HELPER_POINT.x;
					}
					else
					{
						newWidth = Math.max(this.currentIconSkin.width, HELPER_POINT.x);
					}
				}
				else if(this.currentIconSkin)
				{
					newWidth = this.currentIconSkin.width;
				}
				else if(this.text)
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
				if(this.currentIconSkin && this.text)
				{
					if(this._iconPosition == ICON_POSITION_TOP || this._iconPosition == ICON_POSITION_BOTTOM)
					{
						adjustedGap = this._gap;
						if(adjustedGap == Number.POSITIVE_INFINITY)
						{
							adjustedGap = this._minGap;
						}
						newHeight = this.currentIconSkin.height + adjustedGap + HELPER_POINT.y;
					}
					else
					{
						newHeight = Math.max(this.currentIconSkin.height, HELPER_POINT.y);
					}
				}
				else if(this.currentIconSkin)
				{
					newHeight = this.currentIconSkin.height;
				}
				else if(this.text)
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
		 * Sets the <code>currentIconSkin</code> property.
		 *
		 * <p>For internal use in subclasses.</p>
		 */
		protected function refreshIconSkin():void
		{
			var newCurrentIconSkin:DisplayObject = this._iconSkin;
			if(!this._isEnabled && this._iconDisabledSkin)
			{
				newCurrentIconSkin = this._iconDisabledSkin;
			}
			if(this.currentIconSkin != newCurrentIconSkin)
			{
				if(this.currentIconSkin)
				{
					this.removeChild(this.currentIconSkin);
				}
				this.currentIconSkin = newCurrentIconSkin;
				if(this.currentIconSkin)
				{
					this.addChild(this.currentIconSkin);
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
			this.refreshMaxLabelWidth(false);
			if(this._text && this.textRenderer && this.currentIconSkin)
			{
				this.textRenderer.validate();
				this.positionSingleChild(DisplayObject(this.textRenderer));
				if(this._iconPosition != ICON_POSITION_MANUAL)
				{
					this.positionLabelAndIcon();
				}

			}
			else if(this._text && this.textRenderer && !this.currentIconSkin)
			{
				this.textRenderer.validate();
				this.positionSingleChild(DisplayObject(this.textRenderer));
			}
			else if((!this._text || !this.textRenderer) && this.currentIconSkin && this._iconPosition != ICON_POSITION_MANUAL)
			{
				this.positionSingleChild(this.currentIconSkin);
			}

			if(this.currentIconSkin)
			{
				if(this._iconPosition == ICON_POSITION_MANUAL)
				{
					this.currentIconSkin.x = this._paddingLeft;
					this.currentIconSkin.y = this._paddingTop;
				}
				this.currentIconSkin.x += this._iconOffsetX;
				this.currentIconSkin.y += this._iconOffsetY;
			}
			if(this._text && this.textRenderer)
			{
				this.textRenderer.x += this._textOffsetX;
				this.textRenderer.y += this._textOffsetY;
			}
		}
		
		/**
		 * @private
		 */
		protected function positionSingleChild(displayObject:DisplayObject):void
		{
			if(this._horizontalAlign == HORIZONTAL_ALIGN_LEFT)
			{
				displayObject.x = this._paddingLeft;
			}
			else if(this._horizontalAlign == HORIZONTAL_ALIGN_RIGHT)
			{
				displayObject.x = this.actualWidth - this._paddingRight - displayObject.width;
			}
			else //center
			{
				displayObject.x = this._paddingLeft + Math.round((this.actualWidth - this._paddingLeft - this._paddingRight - displayObject.width) / 2);
			}
			if(this._verticalAlign == VERTICAL_ALIGN_TOP)
			{
				displayObject.y = this._paddingTop;
			}
			else if(this._verticalAlign == VERTICAL_ALIGN_BOTTOM)
			{
				displayObject.y = this.actualHeight - this._paddingBottom - displayObject.height;
			}
			else //middle
			{
				displayObject.y = this._paddingTop + Math.round((this.actualHeight - this._paddingTop - this._paddingBottom - displayObject.height) / 2);
			}
		}
		
		/**
		 * @private
		 */
		protected function positionLabelAndIcon():void
		{
			if(this._iconPosition == ICON_POSITION_TOP)
			{
				if(this._gap == Number.POSITIVE_INFINITY)
				{
					this.currentIconSkin.y = this._paddingTop;
					this.textRenderer.y = this.actualHeight - this._paddingBottom - this.textRenderer.height;
				}
				else
				{
					if(this._verticalAlign == VERTICAL_ALIGN_TOP)
					{
						this.textRenderer.y += this.currentIconSkin.height + this._gap;
					}
					else if(this._verticalAlign == VERTICAL_ALIGN_MIDDLE)
					{
						this.textRenderer.y += Math.round((this.currentIconSkin.height + this._gap) / 2);
					}
					this.currentIconSkin.y = this.textRenderer.y - this.currentIconSkin.height - this._gap;
				}
			}
			else if(this._iconPosition == ICON_POSITION_RIGHT || this._iconPosition == ICON_POSITION_RIGHT_BASELINE)
			{
				if(this._gap == Number.POSITIVE_INFINITY)
				{
					this.textRenderer.x = this._paddingLeft;
					this.currentIconSkin.x = this.actualWidth - this._paddingRight - this.currentIconSkin.width;
				}
				else
				{
					if(this._horizontalAlign == HORIZONTAL_ALIGN_RIGHT)
					{
						this.textRenderer.x -= this.currentIconSkin.width + this._gap;
					}
					else if(this._horizontalAlign == HORIZONTAL_ALIGN_CENTER)
					{
						this.textRenderer.x -= Math.round((this.currentIconSkin.width + this._gap) / 2);
					}
					this.currentIconSkin.x = this.textRenderer.x + this.textRenderer.width + this._gap;
				}
			}
			else if(this._iconPosition == ICON_POSITION_BOTTOM)
			{
				if(this._gap == Number.POSITIVE_INFINITY)
				{
					this.textRenderer.y = this._paddingTop;
					this.currentIconSkin.y = this.actualHeight - this._paddingBottom - this.currentIconSkin.height;
				}
				else
				{
					if(this._verticalAlign == VERTICAL_ALIGN_BOTTOM)
					{
						this.textRenderer.y -= this.currentIconSkin.height + this._gap;
					}
					else if(this._verticalAlign == VERTICAL_ALIGN_MIDDLE)
					{
						this.textRenderer.y -= Math.round((this.currentIconSkin.height + this._gap) / 2);
					}
					this.currentIconSkin.y = this.textRenderer.y + this.textRenderer.height + this._gap;
				}
			}
			else if(this._iconPosition == ICON_POSITION_LEFT || this._iconPosition == ICON_POSITION_LEFT_BASELINE)
			{
				if(this._gap == Number.POSITIVE_INFINITY)
				{
					this.currentIconSkin.x = this._paddingLeft;
					this.textRenderer.x = this.actualWidth - this._paddingRight - this.textRenderer.width;
				}
				else
				{
					if(this._horizontalAlign == HORIZONTAL_ALIGN_LEFT)
					{
						this.textRenderer.x += this._gap + this.currentIconSkin.width;
					}
					else if(this._horizontalAlign == HORIZONTAL_ALIGN_CENTER)
					{
						this.textRenderer.x += Math.round((this._gap + this.currentIconSkin.width) / 2);
					}
					this.currentIconSkin.x = this.textRenderer.x - this._gap - this.currentIconSkin.width;
				}
			}
			
			if(this._iconPosition == ICON_POSITION_LEFT || this._iconPosition == ICON_POSITION_RIGHT)
			{
				if(this._verticalAlign == VERTICAL_ALIGN_TOP)
				{
					this.currentIconSkin.y = this._paddingTop;
				}
				else if(this._verticalAlign == VERTICAL_ALIGN_BOTTOM)
				{
					this.currentIconSkin.y = this.actualHeight - this._paddingBottom - this.currentIconSkin.height;
				}
				else
				{
					this.currentIconSkin.y = this._paddingTop + Math.round((this.actualHeight - this._paddingTop - this._paddingBottom - this.currentIconSkin.height) / 2);
				}
			}
			else if(this._iconPosition == ICON_POSITION_LEFT_BASELINE || this._iconPosition == ICON_POSITION_RIGHT_BASELINE)
			{
				this.currentIconSkin.y = this.textRenderer.y + (this.textRenderer.baseline) - this.currentIconSkin.height;
			}
			else //top or bottom
			{
				if(this._horizontalAlign == HORIZONTAL_ALIGN_LEFT)
				{
					this.currentIconSkin.x = this._paddingLeft;
				}
				else if(this._horizontalAlign == HORIZONTAL_ALIGN_RIGHT)
				{
					this.currentIconSkin.x = this.actualWidth - this._paddingRight - this.currentIconSkin.width;
				}
				else
				{
					this.currentIconSkin.x = this._paddingLeft + Math.round((this.actualWidth - this._paddingLeft - this._paddingRight - this.currentIconSkin.width) / 2);
				}
			}
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
		protected function refreshMaxLabelWidth(forMeasurement:Boolean):void
		{
			if(this.currentIconSkin is IValidating)
			{
				IValidating(this.currentIconSkin).validate();
			}
			var calculatedWidth:Number = this.actualWidth;
			if(forMeasurement)
			{
				calculatedWidth = this.explicitWidth;
				if(calculatedWidth !== calculatedWidth) //isNaN
				{
					calculatedWidth = this._maxWidth;
				}
			}
			if(this._text && this.textRenderer && this.currentIconSkin)
			{
				if(this._iconPosition == ICON_POSITION_LEFT || this._iconPosition == ICON_POSITION_LEFT_BASELINE ||
					this._iconPosition == ICON_POSITION_RIGHT || this._iconPosition == ICON_POSITION_RIGHT_BASELINE)
				{
					var adjustedGap:Number = this._gap;
					if(adjustedGap == Number.POSITIVE_INFINITY)
					{
						adjustedGap = this._minGap;
					}
					this.textRenderer.maxWidth = calculatedWidth - this._paddingLeft - this._paddingRight - this.currentIconSkin.width - adjustedGap;
				}
				else
				{
					this.textRenderer.maxWidth = calculatedWidth - this._paddingLeft - this._paddingRight;
				}

			}
			else if(this._text && this.textRenderer && !this.currentIconSkin)
			{
				this.textRenderer.maxWidth = calculatedWidth - this._paddingLeft - this._paddingRight;
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
