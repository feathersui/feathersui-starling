/*
Feathers
Copyright 2012-2018 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.text
{
	import feathers.core.IFeathersControl;
	import feathers.core.ITextRenderer;
	import feathers.core.IToggle;
	import feathers.layout.HorizontalAlign;
	import feathers.skins.IStyleProvider;
	import feathers.utils.geom.matrixToScaleX;
	import feathers.utils.geom.matrixToScaleY;
	import feathers.utils.textures.calculateSnapshotTextureDimensions;

	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display3D.Context3DProfile;
	import flash.filters.BitmapFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.FontType;
	import flash.text.engine.ContentElement;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontLookup;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	import flash.text.engine.Kerning;
	import flash.text.engine.SpaceJustifier;
	import flash.text.engine.TabStop;
	import flash.text.engine.TextBaseline;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextElement;
	import flash.text.engine.TextJustifier;
	import flash.text.engine.TextLine;
	import flash.text.engine.TextRotation;

	import starling.core.Starling;
	import starling.display.Image;
	import starling.rendering.Painter;
	import starling.text.TextFormat;
	import starling.textures.ConcreteTexture;
	import starling.textures.Texture;
	import starling.utils.Align;
	import starling.utils.MathUtil;
	import starling.utils.Pool;
	import starling.utils.SystemUtil;

	/**
	 * Renders text with a native <code>flash.text.engine.TextBlock</code> from
	 * <a href="http://help.adobe.com/en_US/as3/dev/WS9dd7ed846a005b294b857bfa122bd808ea6-8000.html" target="_top">Flash Text Engine</a>
	 * (sometimes abbreviated as FTE), and draws it to <code>BitmapData</code>
	 * before uploading it to a texture on the GPU. Textures are managed
	 * internally by this component, and they will be automatically disposed
	 * when the component is disposed.
	 *
	 * <p>For longer passages of text, this component will stitch together
	 * multiple individual textures both horizontally and vertically, as a grid,
	 * if required. This may require quite a lot of texture memory, possibly
	 * exceeding the limits of some mobile devices, so use this component with
	 * caution when displaying a lot of text.</p>
	 *
	 * <p>The following example shows how to use
	 * <code>TextBlockTextRenderer</code> with a <code>Label</code>:</p>
	 *
	 * <listing version="3.0">
	 * var label:Label = new Label();
	 * label.text = "I am the very model of a modern Major General";
	 * label.textRendererFactory = function():ITextRenderer
	 * {
	 *     return new TextBlockTextRenderer();
	 * };
	 * this.addChild( label );</listing>
	 * 
	 * <strong>Embedding Fonts</strong>
	 * 
	 * <p>This text renderer supports embedded TrueType or OpenType fonts.</p>
	 * 
	 * <p>In the following example, a TrueType font is included with
	 * <code>[Embed]</code> metadata:</p>
	 * 
	 * <listing version="3.0">
	 * [Embed(source="path/to/font.ttf",fontFamily="MyCustomFont",fontWeight="normal",fontStyle="normal",mimeType="application/x-font",embedAsCFF="true")]
	 * private static const MY_CUSTOM_FONT:Class;</listing>
	 * 
	 * <p>The <code>source</code> field should point to the font file, relative
	 * to the current <code>.as</code> file that contains the metadata.</p>
	 * 
	 * <p>Set the <code>fontFamily</code> field to the string value that you
	 * want to use when referencing this font in code. For example, you would
	 * use this name when you create a <code>starling.text.TextFormat</code>
	 * object. Replace "MyCustomFont" with an appropriate name for your font.</p>
	 * 
	 * <p><strong>Tip:</strong> For best results, try not to set the exact same
	 * name in the <code>fontFamily</code> field as the name of device font
	 * installed on your system. Debugging embedded font issues can be
	 * frustrating when you see the correct font on your development computer,
	 * but it's a different font on other devices. If you use a font name that
	 * doesn't exist on your development computer, you'll see when something is
	 * wrong immediately, instead of discovering it later when you're testing
	 * on other devices.</p>
	 * 
	 * <p>If the font is bold, set the <code>fontWeight</code> field to "bold".
	 * Otherwise, set it to "normal".</p>
	 * 
	 * <p>If the font is italic, set the <code>fontStyle</code> field to
	 * "italic". Otherwise, set it to "normal".</p>
	 * 
	 * <p>Since the text renderer is based on Flash Text Engine, you
	 * <strong>must</strong> set the <code>embedAsCFF</code> field to
	 * "true".</p>
	 *
	 * @see ../../../../help/text-renderers.html Introduction to Feathers text renderers
	 * @see ../../../../help/text-block-text-renderer.html How to use the Feathers TextBlockTextRenderer component
	 * @see http://help.adobe.com/en_US/as3/dev/WS9dd7ed846a005b294b857bfa122bd808ea6-8000.html Using the Flash Text Engine in ActionScript 3.0 Developer's Guide
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/TextBlock.html flash.text.engine.TextBlock
	 *
	 * @productversion Feathers 1.3.0
	 */
	public class TextBlockTextRenderer extends BaseTextRenderer implements ITextRenderer
	{
		/**
		 * @private
		 */
		private static const HELPER_POINT:Point = new Point();

		/**
		 * @private
		 */
		private static const HELPER_RESULT:MeasureTextResult = new MeasureTextResult();

		/**
		 * @private
		 */
		private static const HELPER_MATRIX:Matrix = new Matrix();

		/**
		 * @private
		 */
		private static var HELPER_TEXT_LINES:Vector.<TextLine> = new <TextLine>[];

		/**
		 * @private
		 * This is enforced by the runtime.
		 */
		protected static const MAX_TEXT_LINE_WIDTH:Number = 1000000;

		/**
		 * @private
		 */
		protected static const LINE_FEED:String = "\n";

		/**
		 * @private
		 */
		protected static const CARRIAGE_RETURN:String = "\r";

		/**
		 * @private
		 */
		protected static const FUZZY_TRUNCATION_DIFFERENCE:Number = 0.000001;

		[Deprecated(replacement="feathers.layout.HorizontalAlign.LEFT",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.HorizontalAlign.LEFT</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.1. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const TEXT_ALIGN_LEFT:String = "left";

		[Deprecated(replacement="feathers.layout.HorizontalAlign.CENTER",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.HorizontalAlign.CENTER</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.1. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const TEXT_ALIGN_CENTER:String = "center";

		[Deprecated(replacement="feathers.layout.HorizontalAlign.RIGHT",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.HorizontalAlign.RIGHT</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.1. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const TEXT_ALIGN_RIGHT:String = "right";

		/**
		 * The default <code>IStyleProvider</code> for all <code>TextBlockTextRenderer</code>
		 * components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * Constructor.
		 */
		public function TextBlockTextRenderer()
		{
			super();
			this.isQuickHitAreaEnabled = true;
		}

		/**
		 * The TextBlock instance used to render the text before taking a
		 * texture snapshot.
		 */
		protected var textBlock:TextBlock;

		/**
		 * An image that displays a snapshot of the native <code>TextBlock</code>
		 * in the Starling display list when the editor doesn't have focus.
		 */
		protected var textSnapshot:Image;

		/**
		 * If multiple snapshots are needed due to texture size limits, the
		 * snapshots appearing after the first are stored here.
		 */
		protected var textSnapshots:Vector.<Image>;

		/**
		 * @private
		 */
		protected var _textSnapshotScrollX:Number = 0;

		/**
		 * @private
		 */
		protected var _textSnapshotScrollY:Number = 0;

		/**
		 * @private
		 */
		protected var _textSnapshotOffsetX:Number = 0;

		/**
		 * @private
		 */
		protected var _textSnapshotOffsetY:Number = 0;

		/**
		 * @private
		 */
		protected var _textSnapshotNativeFiltersWidth:Number = 0;

		/**
		 * @private
		 */
		protected var _textSnapshotNativeFiltersHeight:Number = 0;

		/**
		 * @private
		 */
		protected var _lastGlobalScaleX:Number = 0;

		/**
		 * @private
		 */
		protected var _lastGlobalScaleY:Number = 0;

		/**
		 * @private
		 */
		protected var _lastGlobalContentScaleFactor:Number = 0;

		/**
		 * @private
		 */
		protected var _textLineContainer:Sprite;

		/**
		 * @private
		 */
		protected var _textLines:Vector.<TextLine> = new <TextLine>[];

		/**
		 * @private
		 */
		protected var _measurementTextLineContainer:Sprite;

		/**
		 * @private
		 */
		protected var _measurementTextLines:Vector.<TextLine> = new <TextLine>[];

		/**
		 * @private
		 */
		protected var _previousLayoutActualWidth:Number = NaN;

		/**
		 * @private
		 */
		protected var _previousLayoutActualHeight:Number = NaN;

		/**
		 * @private
		 */
		protected var _savedTextLinesWidth:Number = NaN;

		/**
		 * @private
		 */
		protected var _savedTextLinesHeight:Number = NaN;

		/**
		 * @private
		 */
		protected var _snapshotWidth:int = 0;

		/**
		 * @private
		 */
		protected var _snapshotHeight:int = 0;

		/**
		 * @private
		 */
		protected var _snapshotVisibleWidth:int = 0;

		/**
		 * @private
		 */
		protected var _snapshotVisibleHeight:int = 0;

		/**
		 * @private
		 */
		protected var _needsNewTexture:Boolean = false;

		/**
		 * @private
		 */
		protected var _needsTextureUpdate:Boolean = false;

		/**
		 * @private
		 */
		protected var _truncationOffset:int = 0;

		/**
		 * @private
		 */
		protected var _textElement:TextElement;

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return TextBlockTextRenderer.globalStyleProvider;
		}

		/**
		 * @private
		 */
		override public function set maxWidth(value:Number):void
		{
			//this is a special case because truncation may bypass normal rules
			//for determining if changing maxWidth should invalidate
			var needsInvalidate:Boolean = value > this._explicitMaxWidth && this._lastMeasurementWasTruncated;
			super.maxWidth = value;
			if(needsInvalidate)
			{
				this.invalidate(INVALIDATION_FLAG_SIZE);
			}
		}

		/**
		 * @copy feathers.core.ITextRenderer#numLines
		 */
		public function get numLines():int
		{
			return this._textLines.length;
		}

		/**
		 * @private
		 */
		override public function set text(value:String):void
		{
			if(this._text == value)
			{
				return;
			}
			if(this._textElement === null)
			{
				this._textElement = new TextElement(value);
			}
			this.content = this._textElement;
			super.text = value;
		}

		/**
		 * @private
		 */
		protected var _content:ContentElement;

		/**
		 * Sets the contents of the <code>TextBlock</code> to a complex value
		 * that may contain graphics and text with multiple formats.
		 *
		 * <p>In the following example, the content is set to a
		 * <code>GroupElement</code> that contains text with multiple
		 * formats:</p>
		 *
		 * <listing version="3.0">
		 * var format1:ElementFormat = new ElementFormat(new FontDescription("_sans"), 20, 0x000000);
		 * var format2:ElementFormat = new ElementFormat(new FontDescription("_sans"), 20, 0xff0000);
		 * var format3:ElementFormat = new ElementFormat(new FontDescription("_sans", FontWeight.NORMAL, FontPosture.ITALIC), 20, 0x000000);
		 * var text1:TextElement = new TextElement("Different ", format1);
		 * var text2:TextElement = new TextElement("colors", format2);
		 * var text3:TextElement = new TextElement(" and ", format1);
		 * var text4:TextElement = new TextElement("styles", format3);
		 * var elements:Vector.&lt;ContentElement&gt; = new &lt;ContentElement&gt;[text1, text2, text3, text4];
		 * var group:GroupElement = new GroupElement(elements);
		 *
		 * var textRenderer:TextBlockTextRenderer = new TextBlockTextRenderer();
		 * textRenderer.content = group;</listing>
		 *
		 * <p>In the following example, the content is set to a
		 * <code>GroupElement</code> that contains both text and a bitmap
		 * graphic:</p>
		 *
		 * <listing version="3.0">
		 * var format:ElementFormat = new ElementFormat(new FontDescription("_sans"), 20);
		 * var text:TextElement = new TextElement("Hi there! ", format);
		 * var bitmap:Bitmap = new EmbeddedBitmap(); //a bitmap included with [Embed]
		 * var graphic:GraphicElement = new GraphicElement(bitmap, bitmap.width, bitmap.height, format);
		 * var elements:Vector.&lt;ContentElement&gt; = new &lt;ContentElement&gt;[text, graphic];
		 * var group:GroupElement = new GroupElement(elements);
		 *
		 * var textRenderer:TextBlockTextRenderer = new TextBlockTextRenderer();
		 * textRenderer.content = group;</listing>
		 *
		 * <p>Note: The <code>content</code> property cannot be used when the
		 * <code>TextBlockTextRenderer</code> receives its text from a parent
		 * component, such as a <code>Label</code> or a <code>Button</code>.</p>
		 *
		 * @default null
		 *
		 * @see #text
		 */
		public function get content():ContentElement
		{
			return this._content;
		}

		/**
		 * @private
		 */
		public function set content(value:ContentElement):void
		{
			if(this._content === value)
			{
				return;
			}
			if(value is TextElement)
			{
				this._textElement = TextElement(value);
			}
			else
			{
				this._textElement = null;
			}
			this._content = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * For debugging purposes, the current
		 * <code>flash.text.engine.ElementFormat</code> used to render the text.
		 * Updated during validation, and may be <code>null</code> before the
		 * first validation.
		 *
		 * <p>Do not modify this value. It is meant for testing and debugging
		 * only. Use the parent's <code>starling.text.TextFormat</code> font
		 * styles APIs instead.</p>
		 */
		public function get currentElementFormat():ElementFormat
		{
			if(this._textElement === null)
			{
				return null;
			}
			return this._textElement.elementFormat;
		}

		/**
		 * @private
		 */
		protected var _fontStylesElementFormat:ElementFormat;

		/**
		 * @private
		 */
		protected var _currentVerticalAlign:String;

		/**
		 * @private
		 */
		protected var _currentHorizontalAlign:String;

		/**
		 * @private
		 */
		protected var _verticalAlignOffsetY:Number = 0;

		/**
		 * @private
		 */
		protected var _elementFormatForState:Object;

		/**
		 * @private
		 */
		protected var _elementFormat:ElementFormat;

		/**
		 * Advanced font formatting used to draw the text, if
		 * <code>fontStyles</code> and <code>starling.text.TextFormat</code>
		 * cannot be used on the parent component because the full capabilities
		 * of Flash Text Engine are required.
		 *
		 * <p>In the following example, the element format is changed:</p>
		 *
		 * <listing version="3.0">
		 * textRenderer.elementFormat = new ElementFormat( new FontDescription( "Source Sans Pro" ) );</listing>
		 *
		 * <p><strong>Warning:</strong> If this property is not
		 * <code>null</code>, any <code>starling.text.TextFormat</code> font
		 * styles that are passed in from the parent component may be ignored.
		 * In other words, advanced font styling with <code>ElementFormat</code>
		 * will always take precedence.</p>
		 *
		 * <p><strong>Warning:</strong> This property will be ignored if the
		 * <code>content</code> property is customized with Flash Text Engine
		 * rich text objects such as <code>GroupElement</code> and
		 * <code>GraphicElement</code>.</p>
		 * 
		 * @default null
		 *
		 * @see #setElementFormatForState()
		 * @see #disabledElementFormat
		 * @see #selectedElementFormat
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/ElementFormat.html flash.text.engine.ElementFormat
		 */
		public function get elementFormat():ElementFormat
		{
			return this._elementFormat;
		}

		/**
		 * @private
		 */
		public function set elementFormat(value:ElementFormat):void
		{
			if(this._elementFormat == value)
			{
				return;
			}
			this._elementFormat = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _disabledElementFormat:ElementFormat;

		/**
		 * Advanced font formatting used to draw the text when the component
		 * is disabled, if <code>disabledFontStyles</code> and
		 * <code>starling.text.TextFormat</code> cannot be used on the parent
		 * component because the full capabilities of Flash Text Engine are
		 * required.
		 *
		 * <p>In the following example, the disabled element format is changed:</p>
		 *
		 * <listing version="3.0">
		 * textRenderer.isEnabled = false;
		 * textRenderer.disabledElementFormat = new ElementFormat( new FontDescription( "Source Sans Pro" ) );</listing>
		 *
		 * <p><strong>Warning:</strong> If this property is not
		 * <code>null</code>, any <code>starling.text.TextFormat</code> font
		 * styles that are passed in from the parent component may be ignored.
		 * In other words, advanced font styling with <code>ElementFormat</code>
		 * will always take precedence.</p>
		 *
		 * <p><strong>Warning:</strong> This property will be ignored if the
		 * <code>content</code> property is customized with Flash Text Engine
		 * rich text objects such as <code>GroupElement</code> and
		 * <code>GraphicElement</code>.</p>
		 * 
		 * @default null
		 *
		 * @see #elementFormat
		 * @see #selectedElementFormat
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/ElementFormat.html flash.text.engine.ElementFormat
		 */
		public function get disabledElementFormat():ElementFormat
		{
			return this._disabledElementFormat;
		}

		/**
		 * @private
		 */
		public function set disabledElementFormat(value:ElementFormat):void
		{
			if(this._disabledElementFormat == value)
			{
				return;
			}
			this._disabledElementFormat = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _selectedElementFormat:ElementFormat;

		/**
		 * Advanced font formatting used to draw the text when the
		 * <code>stateContext</code> is selected, if
		 * <code>selectedFontStyles</code> and
		 * <code>starling.text.TextFormat</code> cannot be used on the parent
		 * component because the full capabilities of Flash Text Engine are
		 * required.
		 *
		 * <p>In the following example, the selected element format is changed:</p>
		 *
		 * <listing version="3.0">
		 * textRenderer.selectedElementFormat = new ElementFormat( new FontDescription( "Source Sans Pro" ) );</listing>
		 *
		 * <p><strong>Warning:</strong> If this property is not
		 * <code>null</code>, any <code>starling.text.TextFormat</code> font
		 * styles that are passed in from the parent component may be ignored.
		 * In other words, advanced font styling with <code>ElementFormat</code>
		 * will always take precedence.</p>
		 *
		 * <p><strong>Warning:</strong> This property will be ignored if the
		 * <code>content</code> property is customized with Flash Text Engine
		 * rich text objects such as <code>GroupElement</code> and
		 * <code>GraphicElement</code>.</p>
		 * 
		 * @default null
		 *
		 * @see #stateContext
		 * @see feathers.core.IToggle
		 * @see #elementFormat
		 * @see #disabledElementFormat
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/ElementFormat.html flash.text.engine.ElementFormat
		 */
		public function get selectedElementFormat():ElementFormat
		{
			return this._selectedElementFormat;
		}

		/**
		 * @private
		 */
		public function set selectedElementFormat(value:ElementFormat):void
		{
			if(this._selectedElementFormat == value)
			{
				return;
			}
			this._selectedElementFormat = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _currentLeading:Number = 0;

		/**
		 * @private
		 */
		protected var _leading:Number = NaN;

		/**
		 * The amount of vertical space, in pixels, between lines.
		 *
		 * <p>If <code>leading</code> is <code>NaN</code> the leading from the
		 * <code>starling.text.TextFormat</code> font styles may be used. If no
		 * <code>starling.text.TextFormat</code> font styles have been provided
		 * by the parent component, the leading will default to <code>0</code>.</p>
		 *
		 * <p>In the following example, the leading is changed to 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * textRenderer.leading = 20;</listing>
		 *
		 * @default NaN
		 */
		public function get leading():Number
		{
			return this._leading;
		}

		/**
		 * @private
		 */
		public function set leading(value:Number):void
		{
			if(this._leading == value)
			{
				return;
			}
			this._leading = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _textAlign:String = null;

		/**
		 * The alignment of the text. For justified text, see the
		 * <code>textJustifier</code> property.
		 * 
		 * <p>If <code>textAlign</code> is <code>null</code> the horizontal
		 * alignment from the <code>starling.text.TextFormat</code> font styles
		 * may be used. If no <code>starling.text.TextFormat</code> font styles
		 * have been provided by the parent component, the alignment will
		 * default to <code>HorizontalAlign.LEFT</code>.</p>
		 *
		 * <p>In the following example, the text alignment is changed:</p>
		 *
		 * <listing version="3.0">
		 * textRenderer.textAlign = HorizontalAlign.CENTER;</listing>
		 *
		 * @default null
		 *
		 * @see feathers.layout.HorizontalAlign#LEFT
		 * @see feathers.layout.HorizontalAlign#CENTER
		 * @see feathers.layout.HorizontalAlign#RIGHT
		 * @see #textJustifier
		 */
		public function get textAlign():String
		{
			return this._textAlign;
		}

		/**
		 * @private
		 */
		public function set textAlign(value:String):void
		{
			if(this._textAlign == value)
			{
				return;
			}
			this._textAlign = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @inheritDoc
		 */
		public function get baseline():Number
		{
			if(this._textLines.length == 0)
			{
				return 0;
			}
			return this.calculateLineAscent(this._textLines[0]);
		}

		/**
		 * @private
		 */
		protected var _applyNonLinearFontScaling:Boolean = true;

		/**
		 * Specifies that you want to enhance screen appearance at the expense
		 * of what-you-see-is-what-you-get (WYSIWYG) print fidelity.
		 *
		 * <p>In the following example, this property is changed to false:</p>
		 *
		 * <listing version="3.0">
		 * textRenderer.applyNonLinearFontScaling = false;</listing>
		 *
		 * @default true
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/TextBlock.html#applyNonLinearFontScaling Full description of flash.text.engine.TextBlock.applyNonLinearFontScaling in Adobe's Flash Platform API Reference
		 */
		public function get applyNonLinearFontScaling():Boolean
		{
			return this._applyNonLinearFontScaling;
		}

		/**
		 * @private
		 */
		public function set applyNonLinearFontScaling(value:Boolean):void
		{
			if(this._applyNonLinearFontScaling == value)
			{
				return;
			}
			this._applyNonLinearFontScaling = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _baselineFontDescription:FontDescription;

		/**
		 * The font used to determine the baselines for all the lines created from the block, independent of their content.
		 *
		 * <p>In the following example, the baseline font description is changed:</p>
		 *
		 * <listing version="3.0">
		 * textRenderer.baselineFontDescription = new FontDescription( "Source Sans Pro", FontWeight.BOLD );</listing>
		 *
		 * @default null
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/TextBlock.html#baselineFontDescription Full description of flash.text.engine.TextBlock.baselineFontDescription in Adobe's Flash Platform API Reference
		 * @see #baselineFontSize
		 */
		public function get baselineFontDescription():FontDescription
		{
			return this._baselineFontDescription;
		}

		/**
		 * @private
		 */
		public function set baselineFontDescription(value:FontDescription):void
		{
			if(this._baselineFontDescription == value)
			{
				return;
			}
			this._baselineFontDescription = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _baselineFontSize:Number = 12;

		/**
		 * The font size used to calculate the baselines for the lines created
		 * from the block.
		 *
		 * <p>In the following example, the baseline font size is changed:</p>
		 *
		 * <listing version="3.0">
		 * textRenderer.baselineFontSize = 20;</listing>
		 *
		 * @default 12
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/TextBlock.html#baselineFontSize Full description of flash.text.engine.TextBlock.baselineFontSize in Adobe's Flash Platform API Reference
		 * @see #baselineFontDescription
		 */
		public function get baselineFontSize():Number
		{
			return this._baselineFontSize;
		}

		/**
		 * @private
		 */
		public function set baselineFontSize(value:Number):void
		{
			if(this._baselineFontSize == value)
			{
				return;
			}
			this._baselineFontSize = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _baselineZero:String = TextBaseline.ROMAN;

		/**
		 * Specifies which baseline is at y=0 for lines created from this block.
		 *
		 * <p>In the following example, the baseline zero is changed:</p>
		 *
		 * <listing version="3.0">
		 * textRenderer.baselineZero = TextBaseline.ASCENT;</listing>
		 *
		 * @default TextBaseline.ROMAN
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/TextBlock.html#baselineZero Full description of flash.text.engine.TextBlock.baselineZero in Adobe's Flash Platform API Reference
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/TextBaseline.html flash.text.engine.TextBaseline
		 */
		public function get baselineZero():String
		{
			return this._baselineZero;
		}

		/**
		 * @private
		 */
		public function set baselineZero(value:String):void
		{
			if(this._baselineZero == value)
			{
				return;
			}
			this._baselineZero = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _bidiLevel:int = 0;

		/**
		 * Specifies the bidirectional paragraph embedding level of the text
		 * block.
		 *
		 * <p>In the following example, the bidi level is changed:</p>
		 *
		 * <listing version="3.0">
		 * textRenderer.bidiLevel = 1;</listing>
		 *
		 * @default 0
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/TextBlock.html#bidiLevel Full description of flash.text.engine.TextBlock.bidiLevel in Adobe's Flash Platform API Reference
		 */
		public function get bidiLevel():int
		{
			return this._bidiLevel;
		}

		/**
		 * @private
		 */
		public function set bidiLevel(value:int):void
		{
			if(this._bidiLevel == value)
			{
				return;
			}
			this._bidiLevel = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _lineRotation:String = TextRotation.ROTATE_0;

		/**
		 * Rotates the text lines in the text block as a unit.
		 *
		 * <p>In the following example, the line rotation is changed:</p>
		 *
		 * <listing version="3.0">
		 * textRenderer.lineRotation = TextRotation.ROTATE_90;</listing>
		 *
		 * @default TextRotation.ROTATE_0
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/TextBlock.html#lineRotation Full description of flash.text.engine.TextBlock.lineRotation in Adobe's Flash Platform API Reference
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/TextRotation.html flash.text.engine.TextRotation
		 */
		public function get lineRotation():String
		{
			return this._lineRotation;
		}

		/**
		 * @private
		 */
		public function set lineRotation(value:String):void
		{
			if(this._lineRotation == value)
			{
				return;
			}
			this._lineRotation = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _tabStops:Vector.<TabStop>;

		/**
		 * Specifies the tab stops for the text in the text block, in the form
		 * of a <code>Vector</code> of <code>TabStop</code> objects.
		 *
		 * <p>In the following example, the tab stops changed:</p>
		 *
		 * <listing version="3.0">
		 * textRenderer.tabStops = new &lt;TabStop&gt;[ new TabStop( TabAlignment.CENTER ) ];</listing>
		 *
		 * @default null
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/TextBlock.html#tabStops Full description of flash.text.engine.TextBlock.tabStops in Adobe's Flash Platform API Reference
		 */
		public function get tabStops():Vector.<TabStop>
		{
			return this._tabStops;
		}

		/**
		 * @private
		 */
		public function set tabStops(value:Vector.<TabStop>):void
		{
			if(this._tabStops == value)
			{
				return;
			}
			this._tabStops = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _textJustifier:TextJustifier = new SpaceJustifier();

		/**
		 * Specifies the <code>TextJustifier</code> to use during line creation.
		 *
		 * <p>In the following example, the text justifier is changed:</p>
		 *
		 * <listing version="3.0">
		 * textRenderer.textJustifier = new SpaceJustifier( "en", LineJustification.ALL_BUT_LAST );</listing>
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/TextBlock.html#textJustifier Full description of flash.text.engine.TextBlock.textJustifier in Adobe's Flash Platform API Reference
		 */
		public function get textJustifier():TextJustifier
		{
			return this._textJustifier;
		}

		/**
		 * @private
		 */
		public function set textJustifier(value:TextJustifier):void
		{
			if(this._textJustifier == value)
			{
				return;
			}
			this._textJustifier = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _userData:*;

		/**
		 * Provides a way for the application to associate arbitrary data with
		 * the text block.
		 *
		 * <p>In the following example, the user data is changed:</p>
		 *
		 * <listing version="3.0">
		 * textRenderer.userData = { author: "William Shakespeare", title: "Much Ado About Nothing" };</listing>
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/TextBlock.html#userData Full description of flash.text.engine.TextBlock.userData in Adobe's Flash Platform API Reference
		 */
		public function get userData():*
		{
			return this._userData;
		}

		/**
		 * @private
		 */
		public function set userData(value:*):void
		{
			if(this._userData === value)
			{
				return;
			}
			this._userData = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _pixelSnapping:Boolean = true;

		/**
		 * Determines if the text should be snapped to the nearest whole pixel
		 * when rendered. When this is <code>false</code>, text may be displayed
		 * on sub-pixels, which often results in blurred rendering due to
		 * texture smoothing.
		 *
		 * <p>In the following example, the text is not snapped to pixels:</p>
		 *
		 * <listing version="3.0">
		 * textRenderer.pixelSnapping = false;</listing>
		 *
		 * @default true
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
			if(this._pixelSnapping === value)
			{
				return;
			}
			this._pixelSnapping = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _maxTextureDimensions:int = 2048;

		/**
		 * The maximum size of individual textures that are managed by this text
		 * renderer. Must be a power of 2. A larger value will create fewer
		 * individual textures, but a smaller value may use less overall texture
		 * memory by incrementing over smaller powers of two.
		 *
		 * <p>In the following example, the maximum size of the textures is
		 * changed:</p>
		 *
		 * <listing version="3.0">
		 * renderer.maxTextureDimensions = 4096;</listing>
		 *
		 * @default 2048
		 */
		public function get maxTextureDimensions():int
		{
			return this._maxTextureDimensions;
		}

		/**
		 * @private
		 */
		public function set maxTextureDimensions(value:int):void
		{
			var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
			//check if we can use rectangle textures or not
			if(starling.profile === Context3DProfile.BASELINE_CONSTRAINED)
			{
				value = MathUtil.getNextPowerOfTwo(value);
			}
			if(this._maxTextureDimensions == value)
			{
				return;
			}
			this._maxTextureDimensions = value;
			this._needsNewTexture = true;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		/**
		 * @private
		 */
		protected var _nativeFilters:Array;

		/**
		 * Native filters to pass to the <code>flash.text.engine.TextLine</code>
		 * instances before creating the texture snapshot.
		 *
		 * <p>In the following example, the native filters are changed:</p>
		 *
		 * <listing version="3.0">
		 * renderer.nativeFilters = [ new GlowFilter() ];</listing>
		 *
		 * @default null
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/DisplayObject.html#filters Full description of flash.display.DisplayObject.filters in Adobe's Flash Platform API Reference
		 */
		public function get nativeFilters():Array
		{
			return this._nativeFilters;
		}

		/**
		 * @private
		 */
		public function set nativeFilters(value:Array):void
		{
			if(this._nativeFilters == value)
			{
				return;
			}
			this._nativeFilters = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _truncationText:String = "...";

		/**
		 * The text to display at the end of the label if it is truncated.
		 *
		 * <p>In the following example, the truncation text is changed:</p>
		 *
		 * <listing version="3.0">
		 * textRenderer.truncationText = " [more]";</listing>
		 *
		 * @default "..."
		 *
		 * @see #truncateToFit
		 */
		public function get truncationText():String
		{
			return _truncationText;
		}

		/**
		 * @private
		 */
		public function set truncationText(value:String):void
		{
			if(this._truncationText == value)
			{
				return;
			}
			this._truncationText = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _truncateToFit:Boolean = true;

		/**
		 * If word wrap is disabled, and the text is longer than the width of
		 * the label, the text may be truncated using <code>truncationText</code>.
		 *
		 * <p>This feature may be disabled to improve performance.</p>
		 *
		 * <p>This feature only works when the <code>text</code> property is
		 * set to a string value. If the <code>content</code> property is set
		 * instead, then the content will not be truncated.</p>
		 *
		 * <p>This feature does not currently support the truncation of text
		 * displayed on multiple lines.</p>
		 *
		 * <p>In the following example, truncation is disabled:</p>
		 *
		 * <listing version="3.0">
		 * textRenderer.truncateToFit = false;</listing>
		 *
		 * @default true
		 *
		 * @see #truncationText
		 */
		public function get truncateToFit():Boolean
		{
			return _truncateToFit;
		}

		/**
		 * @private
		 */
		public function set truncateToFit(value:Boolean):void
		{
			if(this._truncateToFit == value)
			{
				return;
			}
			this._truncateToFit = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _updateSnapshotOnScaleChange:Boolean = false;

		/**
		 * Refreshes the texture snapshot every time that the text renderer is
		 * scaled. Based on the scale in global coordinates, so scaling the
		 * parent will require a new snapshot.
		 *
		 * <p>Warning: setting this property to true may result in reduced
		 * performance because every change of the scale requires uploading a
		 * new texture to the GPU. Use with caution. Consider setting this
		 * property to false temporarily during animations that modify the
		 * scale.</p>
		 *
		 * <p>In the following example, the snapshot will be updated when the
		 * text renderer is scaled:</p>
		 *
		 * <listing version="3.0">
		 * textRenderer.updateSnapshotOnScaleChange = true;</listing>
		 *
		 * @default false
		 */
		public function get updateSnapshotOnScaleChange():Boolean
		{
			return this._updateSnapshotOnScaleChange;
		}

		/**
		 * @private
		 */
		public function set updateSnapshotOnScaleChange(value:Boolean):void
		{
			if(this._updateSnapshotOnScaleChange == value)
			{
				return;
			}
			this._updateSnapshotOnScaleChange = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _lastMeasurementWidth:Number = 0;

		/**
		 * @private
		 */
		protected var _lastMeasurementHeight:Number = 0;

		/**
		 * @private
		 */
		protected var _lastMeasurementWasTruncated:Boolean = false;

		/**
		 * @private
		 */
		protected var _textBlockChanged:Boolean = true;

		/**
		 * @private
		 */
		override public function dispose():void
		{
			if(this.textSnapshot)
			{
				this.textSnapshot.texture.dispose();
				this.removeChild(this.textSnapshot, true);
				this.textSnapshot = null;
			}
			if(this.textSnapshots)
			{
				var snapshotCount:int = this.textSnapshots.length;
				for(var i:int = 0; i < snapshotCount; i++)
				{
					var snapshot:Image = this.textSnapshots[i];
					snapshot.texture.dispose();
					this.removeChild(snapshot, true);
				}
				this.textSnapshots = null;
			}
			//this isn't necessary, but if a memory leak keeps the text renderer
			//from being garbage collected, freeing up these things may help
			//ease memory pressure from native filters and other expensive stuff
			this.textBlock = null;
			this._textLineContainer = null;
			this._textLines = null;
			this._measurementTextLineContainer = null;
			this._measurementTextLines = null;
			this._textElement = null;
			this._content = null;

			this._previousLayoutActualWidth = NaN;
			this._previousLayoutActualHeight = NaN;

			this._needsNewTexture = false;
			this._snapshotWidth = 0;
			this._snapshotHeight = 0;

			super.dispose();
		}

		/**
		 * @private
		 */
		override public function render(painter:Painter):void
		{
			var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
			if(this._updateSnapshotOnScaleChange)
			{
				this.getTransformationMatrix(this.stage, HELPER_MATRIX);
				var globalScaleX:Number = matrixToScaleX(HELPER_MATRIX);
				var globalScaleY:Number = matrixToScaleY(HELPER_MATRIX);
				if(globalScaleX != this._lastGlobalScaleX ||
					globalScaleY != this._lastGlobalScaleY ||
					starling.contentScaleFactor != this._lastGlobalContentScaleFactor)
				{
					//the snapshot needs to be updated because the scale has
					//changed since the last snapshot was taken.
					this.invalidate(INVALIDATION_FLAG_SIZE);
					this.validate();
				}
			}
			if(this._needsTextureUpdate)
			{
				this._needsTextureUpdate = false;
				if(this._content !== null)
				{
					this.refreshSnapshot();
				}
			}
			if(this.textSnapshot !== null)
			{
				var scaleFactor:Number = starling.contentScaleFactor;
				if(!this._nativeFilters || this._nativeFilters.length === 0)
				{
					var offsetX:Number = 0;
					var offsetY:Number = 0;
				}
				else
				{
					offsetX = this._textSnapshotOffsetX / scaleFactor;
					offsetY = this._textSnapshotOffsetY / scaleFactor;
				}
				offsetY += this._verticalAlignOffsetY * scaleFactor;

				var snapshotIndex:int = -1;
				var totalBitmapWidth:Number = this._snapshotWidth;
				var totalBitmapHeight:Number = this._snapshotHeight;
				var xPosition:Number = offsetX;
				var yPosition:Number = offsetY;
				do
				{
					var currentBitmapWidth:Number = totalBitmapWidth;
					if(currentBitmapWidth > this._maxTextureDimensions)
					{
						currentBitmapWidth = this._maxTextureDimensions;
					}
					do
					{
						var currentBitmapHeight:Number = totalBitmapHeight;
						if(currentBitmapHeight > this._maxTextureDimensions)
						{
							currentBitmapHeight = this._maxTextureDimensions;
						}
						if(snapshotIndex < 0)
						{
							var snapshot:Image = this.textSnapshot;
							snapshot.visible = this._snapshotWidth > 0 && this._snapshotHeight > 0 && this._content !== null;
						}
						else
						{
							snapshot = this.textSnapshots[snapshotIndex];
						}
						snapshot.pixelSnapping = this._pixelSnapping;
						snapshot.x = xPosition / scaleFactor;
						snapshot.y = yPosition / scaleFactor;
						snapshotIndex++;
						yPosition += currentBitmapHeight;
						totalBitmapHeight -= currentBitmapHeight;
					}
					while(totalBitmapHeight > 0)
					xPosition += currentBitmapWidth;
					totalBitmapWidth -= currentBitmapWidth;
					yPosition = offsetY;
					totalBitmapHeight = this._snapshotHeight;
				}
				while(totalBitmapWidth > 0)
			}
			super.render(painter);
		}

		/**
		 * @inheritDoc
		 */
		public function measureText(result:Point = null):Point
		{
			if(!result)
			{
				result = new Point();
			}

			var needsWidth:Boolean = this._explicitWidth !== this._explicitWidth; //isNaN
			var needsHeight:Boolean = this._explicitHeight !== this._explicitHeight; //isNaN
			if(!needsWidth && !needsHeight)
			{
				result.x = this._explicitWidth;
				result.y = this._explicitHeight;
				return result;
			}

			//if a parent component validates before we're added to the stage,
			//measureText() may be called before initialization, so we need to
			//force it.
			if(!this._isInitialized)
			{
				this.initializeNow();
			}

			this.commit();

			result = this.measure(result);

			return result;
		}

		/**
		 * Gets the advanced <code>ElementFormat</code> font formatting passed
		 * in using <code>setElementFormatForState()</code> for the specified
		 * state.
		 *
		 * <p>If an <code>ElementFormat</code> is not defined for a specific
		 * state, returns <code>null</code>.</p>
		 * 
		 * @see #setElementFormatForState()
		 */
		public function getElementFormatForState(state:String):ElementFormat
		{
			if(this._elementFormatForState === null)
			{
				return null;
			}
			return ElementFormat(this._elementFormatForState[state]);
		}

		/**
		 * Sets the advanced <code>ElementFormat</code> font formatting to be
		 * used by the text renderer when the <code>currentState</code> property
		 * of the <code>stateContext</code> matches the specified state value.
		 * For advanced use cases where <code>starling.text.TextFormat</code>
		 * cannot be used on the parent component because the full capabilities
		 * of Flash Text Engine are required.
		 * 
		 * <p>If an <code>ElementFormat</code> is not defined for a specific
		 * state, the value of the <code>elementFormat</code> property will be
		 * used instead.</p>
		 * 
		 * <p>If the <code>disabledElementFormat</code> property is not
		 * <code>null</code> and the <code>isEnabled</code> property is
		 * <code>false</code>, all other element formats will be ignored.</p>
		 * 
		 * @see #stateContext
		 * @see #elementFormat
		 */
		public function setElementFormatForState(state:String, elementFormat:ElementFormat):void
		{
			if(elementFormat)
			{
				if(!this._elementFormatForState)
				{
					this._elementFormatForState = {};
				}
				this._elementFormatForState[state] = elementFormat;
			}
			else
			{
				delete this._elementFormatForState[state];
			}
			//if the context's current state is the state that we're modifying,
			//we need to use the new value immediately.
			if(this._stateContext && this._stateContext.currentState === state)
			{
				this.invalidate(INVALIDATION_FLAG_STATE);
			}
		}

		/**
		 * @private
		 */
		override protected function initialize():void
		{
			if(!this.textBlock)
			{
				this.textBlock = new TextBlock();
			}
			if(!this._textLineContainer)
			{
				this._textLineContainer = new Sprite();
			}
			if(!this._measurementTextLineContainer)
			{
				this._measurementTextLineContainer = new Sprite();
			}
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);

			this.commit();

			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

			this.layout(sizeInvalid);
		}

		/**
		 * @private
		 */
		protected function commit():void
		{
			var stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			var stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);

			if(dataInvalid || stylesInvalid || stateInvalid)
			{
				this.refreshElementFormat();
			}

			if(stylesInvalid)
			{
				this._textBlockChanged = true;
				this.textBlock.applyNonLinearFontScaling = this._applyNonLinearFontScaling;
				this.textBlock.baselineFontDescription = this._baselineFontDescription;
				this.textBlock.baselineFontSize = this._baselineFontSize;
				this.textBlock.baselineZero = this._baselineZero;
				this.textBlock.bidiLevel = this._bidiLevel;
				this.textBlock.lineRotation = this._lineRotation;
				this.textBlock.tabStops = this._tabStops;
				this.textBlock.textJustifier = this._textJustifier;
				this.textBlock.userData = this._userData;

				this._textLineContainer.filters = this._nativeFilters;
			}

			if(dataInvalid)
			{
				this._textBlockChanged = true;
				this.textBlock.content = this._content;
			}
		}

		/**
		 * @private
		 */
		protected function measure(result:Point = null):Point
		{
			if(!result)
			{
				result = new Point();
			}

			var needsWidth:Boolean = this._explicitWidth !== this._explicitWidth; //isNaN
			var needsHeight:Boolean = this._explicitHeight !== this._explicitHeight; //isNaN
			var newWidth:Number = this._explicitWidth;
			var newHeight:Number = this._explicitHeight;
			if(needsWidth)
			{
				newWidth = this._explicitMaxWidth;
				if(newWidth > MAX_TEXT_LINE_WIDTH)
				{
					newWidth = MAX_TEXT_LINE_WIDTH;
				}
			}
			if(needsHeight)
			{
				newHeight = this._explicitMaxHeight;
			}

			//sometimes, we can determine that the dimensions will be exactly
			//the same without needing to refresh the text lines. this will
			//result in much better performance.
			if(this._wordWrap)
			{
				//when word wrapped, we need to measure again any time that the
				//width changes.
				var needsMeasurement:Boolean = newWidth !== this._lastMeasurementWidth;
			}
			else
			{
				//we can skip measuring again more frequently when the text is
				//a single line.

				//if the width is smaller than the last layout width, we need to
				//measure again. when it's larger, the result won't change...
				needsMeasurement = newWidth < this._lastMeasurementWidth;

				//...unless the text was previously truncated!
				needsMeasurement ||= (this._lastMeasurementWasTruncated && newWidth !== this._lastMeasurementWidth);
			}
			if(this._textBlockChanged || needsMeasurement)
			{
				this.refreshTextLines(this._measurementTextLines, this._measurementTextLineContainer, newWidth, newHeight, HELPER_RESULT);
				this._lastMeasurementWidth = HELPER_RESULT.width;
				this._lastMeasurementHeight = HELPER_RESULT.height;
				this._lastMeasurementWasTruncated = HELPER_RESULT.isTruncated;
				this._textBlockChanged = false;
			}
			if(needsWidth)
			{
				newWidth = Math.ceil(this._measurementTextLineContainer.width);
				if(newWidth > this._explicitMaxWidth)
				{
					newWidth = this._explicitMaxWidth;
				}
			}
			if(needsHeight)
			{
				newHeight = Math.ceil(this._lastMeasurementHeight);
				if(newHeight <= 0 && this._elementFormat)
				{
					newHeight = this._elementFormat.fontSize;
				}
			}

			result.x = newWidth;
			result.y = newHeight;

			return result;
		}

		/**
		 * @private
		 */
		protected function layout(sizeInvalid:Boolean):void
		{
			var stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			var stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);

			//first, we check if something will have changed the appearance of
			//the text lines. they will always need to be refreshed for that.
			//if not, we check if the actualWidth and actualHeight have changed
			//since the last time we did layout. sizeInvalid will often be
			//triggered by changing maxWidth or something for measurement, so we
			//need to be more specific.
			var contentStateChanged:Boolean = stylesInvalid || dataInvalid || stateInvalid ||
				this.actualWidth !== this._previousLayoutActualWidth ||
				this.actualHeight !== this._previousLayoutActualHeight;
			if(contentStateChanged)
			{
				this._previousLayoutActualWidth = this.actualWidth;
				this._previousLayoutActualHeight = this.actualHeight;
				if(this._content !== null)
				{
					this.refreshTextLines(this._textLines, this._textLineContainer, this.actualWidth, this.actualHeight, HELPER_RESULT);
					//since refreshTextLines() isn't called every time that
					//calculateSnapshotDimensions() is called, we need to save
					//these values
					this._savedTextLinesWidth = HELPER_RESULT.width;
					this._savedTextLinesHeight = HELPER_RESULT.height;
					this._verticalAlignOffsetY = this.getVerticalAlignOffsetY();
				}
			}
			//on the other hand, sizeInvalid will always indicate that the
			//snapshot dimensions need to be revisited
			if(contentStateChanged || sizeInvalid)
			{
				this.calculateSnapshotDimensions();
			}

			if(contentStateChanged || this._needsNewTexture)
			{
				//we're going to update the texture in render() because 
				//there's a chance that it will be updated more than once per
				//frame if we do it here.
				this._needsTextureUpdate = true;
				this.setRequiresRedraw();
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

			if(needsWidth || needsHeight)
			{
				//since the minimum dimensions are based on the regular
				//dimensions, we don't need to measure if only minimum
				//dimensions are required
				this.measure(HELPER_POINT);
			}
			var newWidth:Number = this._explicitWidth;
			if(needsWidth)
			{
				newWidth = HELPER_POINT.x;
			}
			var newHeight:Number = this._explicitHeight;
			if(needsHeight)
			{
				newHeight = HELPER_POINT.y;
			}
			var newMinWidth:Number = this._explicitMinWidth;
			if(needsMinWidth)
			{
				if(needsWidth)
				{
					//this allows wrapping or truncation
					newMinWidth = 0;
				}
				else
				{
					newMinWidth = newWidth;
				}
			}
			var newMinHeight:Number = this._explicitMinHeight;
			if(needsMinHeight)
			{
				newMinHeight = newHeight;
			}
			return this.saveMeasurements(newWidth, newHeight, newMinWidth, newMinHeight);
		}

		/**
		 * @private
		 */
		protected function measureNativeFilters(bitmapData:BitmapData, result:Rectangle = null):Rectangle
		{
			if(!result)
			{
				result = new Rectangle();
			}
			var resultX:Number = 0;
			var resultY:Number = 0;
			var resultWidth:Number = 0;
			var resultHeight:Number = 0;
			var filterCount:int = this._nativeFilters.length;
			for(var i:int = 0; i < filterCount; i++)
			{
				var filter:BitmapFilter = this._nativeFilters[i];
				var filterRect:Rectangle = bitmapData.generateFilterRect(bitmapData.rect, filter);
				var filterX:Number = filterRect.x;
				var filterY:Number = filterRect.y;
				var filterWidth:Number = filterRect.width;
				var filterHeight:Number = filterRect.height;
				if(resultX > filterX)
				{
					resultX = filterX;
				}
				if(resultY > filterY)
				{
					resultY = filterY;
				}
				if(resultWidth < filterWidth)
				{
					resultWidth = filterWidth;
				}
				if(resultHeight < filterHeight)
				{
					resultHeight = filterHeight;
				}
			}
			result.setTo(resultX, resultY, resultWidth, resultHeight);
			return result;
		}

		/**
		 * @private
		 */
		protected function refreshElementFormat():void
		{
			var elementFormat:ElementFormat;
			if(this._stateContext !== null)
			{
				if(this._elementFormatForState !== null)
				{
					var currentState:String = this._stateContext.currentState;
					if(currentState in this._elementFormatForState)
					{
						elementFormat = ElementFormat(this._elementFormatForState[currentState]);
					}
				}
				if(elementFormat === null && this._disabledElementFormat !== null &&
					this._stateContext is IFeathersControl && !IFeathersControl(this._stateContext).isEnabled)
				{
					elementFormat = this._disabledElementFormat;
				}
				if(elementFormat === null && this._selectedElementFormat !== null &&
					this._stateContext is IToggle && IToggle(this._stateContext).isSelected)
				{
					elementFormat = this._selectedElementFormat;
				}
			}
			else //no state context
			{
				//we can still check if the text renderer is disabled to see if
				//we should use disabledElementFormat
				if(!this._isEnabled && this._disabledElementFormat !== null)
				{
					elementFormat = this._disabledElementFormat;
				}
			}
			if(elementFormat === null)
			{
				elementFormat = this._elementFormat;
			}
			//ElementFormat is considered more advanced, so it gets precedence
			//over starling.text.TextFormat font styles
			if(elementFormat === null)
			{
				elementFormat = this.getElementFormatFromFontStyles();
			}
			else
			{
				//if using ElementFormat, vertical align is always top
				this._currentVerticalAlign = Align.TOP;
				//these are defaults in case textAlign and leading are not set
				this._currentHorizontalAlign = Align.CENTER;
				this._currentLeading = 0;
			}
			if(this._textAlign !== null)
			{
				this._currentHorizontalAlign = this._textAlign;
			}
			if(this._leading === this._leading) //!isNaN
			{
				this._currentLeading = this._leading;
			}
			if(this._textElement === null)
			{
				return;
			}
			if(this._textElement.elementFormat !== elementFormat)
			{
				this._textBlockChanged = true;
				this._textElement.elementFormat = elementFormat;
			}
		}

		/**
		 * @private
		 */
		protected function getElementFormatFromFontStyles():ElementFormat
		{
			if(this.isInvalid(INVALIDATION_FLAG_STYLES) ||
				this.isInvalid(INVALIDATION_FLAG_STATE))
			{
				var textFormat:TextFormat;
				if(this._fontStyles !== null)
				{
					textFormat = this._fontStyles.getTextFormatForTarget(this);
				}
				if(textFormat !== null)
				{
					var fontWeight:String = FontWeight.NORMAL;
					if(textFormat.bold)
					{
						fontWeight = FontWeight.BOLD;
					}
					var fontPosture:String = FontPosture.NORMAL;
					if(textFormat.italic)
					{
						fontPosture = FontPosture.ITALIC;
					}
					var fontLookup:String = FontLookup.DEVICE;
					if(SystemUtil.isEmbeddedFont(textFormat.font, textFormat.bold, textFormat.italic, FontType.EMBEDDED_CFF))
					{
						fontLookup = FontLookup.EMBEDDED_CFF;
					}
					var fontDescription:FontDescription =
						new FontDescription(textFormat.font, fontWeight, fontPosture, fontLookup);
					this._fontStylesElementFormat = new ElementFormat(fontDescription, textFormat.size, textFormat.color);
					if(textFormat.kerning)
					{
						this._fontStylesElementFormat.kerning = Kerning.ON;
					}
					else
					{
						this._fontStylesElementFormat.kerning = Kerning.OFF;
					}
					var letterSpacing:Number = textFormat.letterSpacing / 2;
					//adobe documentation recommends splitting it between
					//left and right
					//http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/ElementFormat.html#trackingRight
					this._fontStylesElementFormat.trackingRight = letterSpacing;
					this._fontStylesElementFormat.trackingLeft = letterSpacing;
					this._currentLeading = textFormat.leading;
					this._currentVerticalAlign = textFormat.verticalAlign;
					this._currentHorizontalAlign = textFormat.horizontalAlign;
				}
				else if(this._fontStylesElementFormat === null)
				{
					//fallback to a default so that something is displayed
					this._fontStylesElementFormat = new ElementFormat();
					this._currentLeading = 0;
					this._currentVerticalAlign = Align.TOP;
					this._currentHorizontalAlign = Align.LEFT;
				}
			}
			return this._fontStylesElementFormat;
		}

		/**
		 * @private
		 */
		protected function createTextureOnRestoreCallback(snapshot:Image):void
		{
			var self:TextBlockTextRenderer = this;
			var texture:Texture = snapshot.texture;
			texture.root.onRestore = function():void
			{
				var starling:Starling = self.stage !== null ? self.stage.starling : Starling.current;
				var scaleFactor:Number = starling.contentScaleFactor;
				if(texture.scale != scaleFactor)
				{
					//if we've changed between scale factors, we need to
					//recreate the texture to match the new scale factor.
					invalidate(INVALIDATION_FLAG_SIZE);
				}
				else
				{
					HELPER_MATRIX.identity();
					HELPER_MATRIX.scale(scaleFactor, scaleFactor);
					var bitmapData:BitmapData = self.drawTextLinesRegionToBitmapData(
						snapshot.x, snapshot.y, texture.nativeWidth, texture.nativeHeight);
					texture.root.uploadBitmapData(bitmapData);
					bitmapData.dispose();
				}
			};
		}

		/**
		 * @private
		 */
		protected function drawTextLinesRegionToBitmapData(textLinesX:Number, textLinesY:Number,
			bitmapWidth:Number, bitmapHeight:Number, bitmapData:BitmapData = null):BitmapData
		{
			var clipWidth:Number = this._snapshotVisibleWidth - textLinesX;
			var clipHeight:Number = this._snapshotVisibleHeight - textLinesY;
			if(!bitmapData || bitmapData.width != bitmapWidth || bitmapData.height != bitmapHeight)
			{
				if(bitmapData)
				{
					bitmapData.dispose();
				}
				bitmapData = new BitmapData(bitmapWidth, bitmapHeight, true, 0x00ff00ff);
			}
			else
			{
				//clear the bitmap data and reuse it
				bitmapData.fillRect(bitmapData.rect, 0x00ff00ff);
			}
			var nativeScaleFactor:Number = 1;
			var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
			if(starling && starling.supportHighResolutions)
			{
				nativeScaleFactor = starling.nativeStage.contentsScaleFactor;
			}
			HELPER_MATRIX.tx = -textLinesX - this._textSnapshotScrollX * nativeScaleFactor - this._textSnapshotOffsetX;
			HELPER_MATRIX.ty = -textLinesY - this._textSnapshotScrollY * nativeScaleFactor - this._textSnapshotOffsetY;
			var rect:Rectangle = Pool.getRectangle(0, 0, clipWidth, clipHeight);
			bitmapData.draw(this._textLineContainer, HELPER_MATRIX, null, null, rect);
			Pool.putRectangle(rect);
			return bitmapData;
		}

		/**
		 * @private
		 */
		protected function calculateSnapshotDimensions():void
		{
			var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
			var scaleFactor:Number = starling.contentScaleFactor;
			this._lastGlobalContentScaleFactor = scaleFactor;
			//these are getting put into an int later, so we don't want it
			//to possibly round down and cut off part of the text. 
			if(this._savedTextLinesWidth < this.actualWidth)
			{
				var rectangleSnapshotWidth:Number = Math.ceil(this._savedTextLinesWidth * scaleFactor);
			}
			else
			{
				rectangleSnapshotWidth = Math.ceil(this.actualWidth * scaleFactor);
			}
			if(this._savedTextLinesHeight < this.actualHeight)
			{
				var rectangleSnapshotHeight:Number = Math.ceil(this._savedTextLinesHeight * scaleFactor);
			}
			else
			{
				rectangleSnapshotHeight = Math.ceil(this.actualHeight * scaleFactor);
			}
			if(this._updateSnapshotOnScaleChange)
			{
				this.getTransformationMatrix(this.stage, HELPER_MATRIX);
				this._lastGlobalScaleX = matrixToScaleX(HELPER_MATRIX);
				this._lastGlobalScaleY = matrixToScaleY(HELPER_MATRIX);
				rectangleSnapshotWidth *= this._lastGlobalScaleX;
				rectangleSnapshotHeight *= this._lastGlobalScaleY;
			}
			if(rectangleSnapshotWidth >= 1 && rectangleSnapshotHeight >= 1 &&
				this._nativeFilters !== null && this._nativeFilters.length > 0)
			{
				rectangleSnapshotWidth = this._textSnapshotNativeFiltersWidth;
				rectangleSnapshotHeight = this._textSnapshotNativeFiltersHeight;
			}
			var point:Point = Pool.getPoint();
			calculateSnapshotTextureDimensions(rectangleSnapshotWidth,
				rectangleSnapshotHeight, this._maxTextureDimensions,
				starling.profile !== Context3DProfile.BASELINE_CONSTRAINED, point);
			//the full dimensions of the texture
			this._snapshotWidth = point.x;
			this._snapshotHeight = point.y;
			//the clipping dimensions of the texture, if it is next power-of-two
			this._snapshotVisibleWidth = rectangleSnapshotWidth;
			this._snapshotVisibleHeight = rectangleSnapshotHeight;
			Pool.putPoint(point);

			var textureRoot:ConcreteTexture = this.textSnapshot ? this.textSnapshot.texture.root : null;
			this._needsNewTexture = this._needsNewTexture || this.textSnapshot === null ||
				(textureRoot !== null && (textureRoot.scale !== scaleFactor ||
				this._snapshotWidth !== textureRoot.nativeWidth || this._snapshotHeight !== textureRoot.nativeHeight));
		}

		/**
		 * @private
		 */
		protected function refreshSnapshot():void
		{
			if(this._snapshotWidth <= 0 || this._snapshotHeight <= 0)
			{
				return;
			}
			var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
			var scaleFactor:Number = starling.contentScaleFactor;
			if(this._updateSnapshotOnScaleChange)
			{
				this.getTransformationMatrix(this.stage, HELPER_MATRIX);
				var globalScaleX:Number = matrixToScaleX(HELPER_MATRIX);
				var globalScaleY:Number = matrixToScaleY(HELPER_MATRIX);
			}
			HELPER_MATRIX.identity();
			HELPER_MATRIX.scale(scaleFactor, scaleFactor);
			if(this._updateSnapshotOnScaleChange)
			{
				HELPER_MATRIX.scale(globalScaleX, globalScaleY);
			}
			var totalBitmapWidth:Number = this._snapshotWidth;
			var totalBitmapHeight:Number = this._snapshotHeight;
			var xPosition:Number = 0;
			var yPosition:Number = 0;
			var bitmapData:BitmapData;
			var snapshotIndex:int = -1;
			do
			{
				var currentBitmapWidth:Number = totalBitmapWidth;
				if(currentBitmapWidth > this._maxTextureDimensions)
				{
					currentBitmapWidth = this._maxTextureDimensions;
				}
				do
				{
					var currentBitmapHeight:Number = totalBitmapHeight;
					if(currentBitmapHeight > this._maxTextureDimensions)
					{
						currentBitmapHeight = this._maxTextureDimensions;
					}
					bitmapData = this.drawTextLinesRegionToBitmapData(xPosition, yPosition,
						currentBitmapWidth, currentBitmapHeight, bitmapData);
					var newTexture:Texture;
					if(!this.textSnapshot || this._needsNewTexture)
					{
						//skip Texture.fromBitmapData() because we don't want
						//it to create an onRestore function that will be
						//immediately discarded for garbage collection. 
						newTexture = Texture.empty(bitmapData.width / scaleFactor, bitmapData.height / scaleFactor,
							true, false, false, scaleFactor);
						newTexture.root.uploadBitmapData(bitmapData);
					}
					var snapshot:Image = null;
					if(snapshotIndex >= 0)
					{
						if(!this.textSnapshots)
						{
							this.textSnapshots = new <Image>[];
						}
						else if(this.textSnapshots.length > snapshotIndex)
						{
							snapshot = this.textSnapshots[snapshotIndex]
						}
					}
					else
					{
						snapshot = this.textSnapshot;
					}

					if(!snapshot)
					{
						snapshot = new Image(newTexture);
						this.addChild(snapshot);
					}
					else
					{
						if(this._needsNewTexture)
						{
							snapshot.texture.dispose();
							snapshot.texture = newTexture;
							snapshot.readjustSize();
						}
						else
						{
							//this is faster, if we haven't resized the bitmapdata
							var existingTexture:Texture = snapshot.texture;
							existingTexture.root.uploadBitmapData(bitmapData);
							//however, the image won't be notified that its
							//texture has changed, so we need to do it manually
							this.textSnapshot.setRequiresRedraw();
						}
					}
					if(newTexture)
					{
						this.createTextureOnRestoreCallback(snapshot);
					}
					if(snapshotIndex >= 0)
					{
						this.textSnapshots[snapshotIndex] = snapshot;
					}
					else
					{
						this.textSnapshot = snapshot;
					}
					snapshot.x = xPosition / scaleFactor;
					snapshot.y = yPosition / scaleFactor;
					if(this._updateSnapshotOnScaleChange)
					{
						snapshot.scaleX = 1 / globalScaleX;
						snapshot.scaleY = 1 / globalScaleY;
					}
					else
					{
						snapshot.scale = 1;
					}
					snapshotIndex++;
					yPosition += currentBitmapHeight;
					totalBitmapHeight -= currentBitmapHeight;
				}
				while(totalBitmapHeight > 0)
				xPosition += currentBitmapWidth;
				totalBitmapWidth -= currentBitmapWidth;
				yPosition = 0;
				totalBitmapHeight = this._snapshotHeight;
			}
			while(totalBitmapWidth > 0)
			bitmapData.dispose();
			if(this.textSnapshots)
			{
				var snapshotCount:int = this.textSnapshots.length;
				for(var i:int = snapshotIndex; i < snapshotCount; i++)
				{
					snapshot = this.textSnapshots[i];
					snapshot.texture.dispose();
					snapshot.removeFromParent(true);
				}
				if(snapshotIndex == 0)
				{
					this.textSnapshots = null;
				}
				else
				{
					this.textSnapshots.length = snapshotIndex;
				}
			}
			if(this._updateSnapshotOnScaleChange)
			{
				this._lastGlobalScaleX = globalScaleX;
				this._lastGlobalScaleY = globalScaleY;
				this._lastGlobalContentScaleFactor = scaleFactor;
			}
			this._needsNewTexture = false;
		}

		/**
		 * @private
		 * the ascent alone doesn't account for diacritical marks,
		 * like accents and things. however, increasing the ascent by
		 * the value of the descent seems to be a good approximation.
		 */
		protected function calculateLineAscent(line:TextLine):Number
		{
			var calculatedAscent:Number = line.ascent + line.descent;
			if(line.totalAscent > calculatedAscent)
			{
				calculatedAscent = line.totalAscent;
			}
			return calculatedAscent;
		}

		/**
		 * @private
		 */
		protected function refreshTextElementText():void
		{
			if(this._textElement === null)
			{
				return;
			}
			var newText:String = this._text;
			if(newText !== null && newText.length > 0)
			{
				if(newText.charAt(newText.length - 1) === " ")
				{
					//add an invisible control character because FTE apparently
					//doesn't think that it's important to include trailing
					//spaces in its width measurement.
					newText += String.fromCharCode(3);
				}
			}
			else
			{
				//similar to above. this hack ensures that the baseline is
				//measured properly when the text is an empty string.
				newText = String.fromCharCode(3);
			}
			this._textElement.text = newText;
		}

		/**
		 * @private
		 */
		protected function refreshTextLines(textLines:Vector.<TextLine>,
			textLineParent:DisplayObjectContainer, width:Number, height:Number,
			result:MeasureTextResult = null):MeasureTextResult
		{
			var lineCount:int = textLines.length;
			//copy the invalid text lines over to the helper vector so that we
			//can reuse them
			HELPER_TEXT_LINES.length = 0;
			for(var i:int = 0; i < lineCount; i++)
			{
				HELPER_TEXT_LINES[i] = textLines[i];
			}
			textLines.length = 0;

			this.refreshTextElementText();

			var wasTruncated:Boolean = false;
			var maxLineWidth:Number = 0;
			var yPosition:Number = 0;
			if(width >= 0)
			{
				var line:TextLine = null;
				var lineStartIndex:int = 0;
				var canTruncate:Boolean = this._truncateToFit && this._textElement && !this._wordWrap;
				var pushIndex:int = textLines.length;
				var inactiveTextLineCount:int = HELPER_TEXT_LINES.length;
				while(true)
				{
					this._truncationOffset = 0;
					var previousLine:TextLine = line;
					var lineWidth:Number = width;
					if(!this._wordWrap)
					{
						lineWidth = MAX_TEXT_LINE_WIDTH;
					}
					if(inactiveTextLineCount > 0)
					{
						var inactiveLine:TextLine = HELPER_TEXT_LINES[0];
						line = this.textBlock.recreateTextLine(inactiveLine, previousLine, lineWidth, 0, true);
						if(line)
						{
							HELPER_TEXT_LINES.shift();
							inactiveTextLineCount--;
						}
					}
					else
					{
						line = this.textBlock.createTextLine(previousLine, lineWidth, 0, true);
						if(line)
						{
							textLineParent.addChild(line);
						}
					}
					if(!line)
					{
						//end of text
						break;
					}
					var lineLength:int = line.rawTextLength;
					var isTruncated:Boolean = false;
					var difference:Number = 0;
					while(canTruncate && (difference = line.width - width) > FUZZY_TRUNCATION_DIFFERENCE)
					{
						isTruncated = true;
						if(this._truncationOffset == 0)
						{
							//this will quickly skip all of the characters after
							//the maximum width of the line, instead of going
							//one by one.
							var endIndex:int = line.getAtomIndexAtPoint(width, 0);
							if(endIndex >= 0)
							{
								this._truncationOffset = line.rawTextLength - endIndex;
							}
						}
						this._truncationOffset++;
						var truncatedTextLength:int = lineLength - this._truncationOffset;
						//we want to start at this line so that the previous
						//lines don't become invalid.
						var truncatedText:String =  this._text.substr(lineStartIndex, truncatedTextLength) + this._truncationText;
						var lineBreakIndex:int = this._text.indexOf(LINE_FEED, lineStartIndex);
						if(lineBreakIndex < 0)
						{
							lineBreakIndex = this._text.indexOf(CARRIAGE_RETURN, lineStartIndex);
						}
						if(lineBreakIndex >= 0)
						{
							truncatedText += this._text.substr(lineBreakIndex);
						}
						this._textElement.text = truncatedText;
						line = this.textBlock.recreateTextLine(line, null, lineWidth, 0, true);
						if(truncatedTextLength <= 0)
						{
							break;
						}
					}
					if(pushIndex > 0)
					{
						yPosition += this._currentLeading;
					}

					if(line.width > maxLineWidth)
					{
						maxLineWidth = line.width;
					}
					yPosition += this.calculateLineAscent(line);
					line.y = yPosition;
					yPosition += line.totalDescent;
					textLines[pushIndex] = line;
					pushIndex++;
					lineStartIndex += lineLength;
					wasTruncated ||= isTruncated;
				}
			}
			if(textLines !== this._measurementTextLines)
			{
				//no need to align the measurement text lines because they won't
				//be rendered
				this.alignTextLines(textLines, width, this._currentHorizontalAlign);
			}
			if(this._currentHorizontalAlign === Align.RIGHT)
			{
				maxLineWidth = width;
			}
			else if(this._currentHorizontalAlign === Align.CENTER)
			{
				maxLineWidth = (width + maxLineWidth) / 2;
			}

			inactiveTextLineCount = HELPER_TEXT_LINES.length;
			for(i = 0; i < inactiveTextLineCount; i++)
			{
				line = HELPER_TEXT_LINES[i];
				textLineParent.removeChild(line);
			}
			HELPER_TEXT_LINES.length = 0;
			if(result === null)
			{
				result = new MeasureTextResult(maxLineWidth, yPosition, wasTruncated);
			}
			else
			{
				result.width = maxLineWidth;
				result.height = yPosition;
				result.isTruncated = wasTruncated;
			}

			if(textLines !== this._measurementTextLines)
			{
				if(result.width >= 1 && result.height >= 1 &&
					this._nativeFilters !== null && this._nativeFilters.length > 0)
				{
					var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
					var scaleFactor:Number = starling.contentScaleFactor;
					HELPER_MATRIX.identity();
					HELPER_MATRIX.scale(scaleFactor, scaleFactor);
					var bitmapData:BitmapData = new BitmapData(result.width, result.height, true, 0x00ff00ff);
					var rect:Rectangle = Pool.getRectangle();
					bitmapData.draw(this._textLineContainer, HELPER_MATRIX, null, null, rect);
					this.measureNativeFilters(bitmapData, rect);
					bitmapData.dispose();
					bitmapData = null;
					this._textSnapshotOffsetX = rect.x;
					this._textSnapshotOffsetY = rect.y;
					this._textSnapshotNativeFiltersWidth = rect.width;
					this._textSnapshotNativeFiltersHeight = rect.height;
					Pool.putRectangle(rect);
				}
				else
				{
					this._textSnapshotOffsetX = 0;
					this._textSnapshotOffsetY = 0;
					this._textSnapshotNativeFiltersWidth = 0;
					this._textSnapshotNativeFiltersHeight = 0;
				}
			}
			return result;
		}

		/**
		 * @private
		 */
		protected function getVerticalAlignOffsetY():Number
		{
			if(this._savedTextLinesHeight > this.actualHeight)
			{
				return 0;
			}
			if(this._currentVerticalAlign === Align.BOTTOM)
			{
				return (this.actualHeight - this._savedTextLinesHeight);
			}
			else if(this._currentVerticalAlign === Align.CENTER)
			{
				return (this.actualHeight - this._savedTextLinesHeight) / 2;
			}
			return 0;
		}

		/**
		 * @private
		 */
		protected function alignTextLines(textLines:Vector.<TextLine>, width:Number, textAlign:String):void
		{
			var lineCount:int = textLines.length;
			for(var i:int = 0; i < lineCount; i++)
			{
				var line:TextLine = textLines[i];
				if(textAlign == HorizontalAlign.CENTER)
				{
					line.x = (width - line.width) / 2;
				}
				else if(textAlign == HorizontalAlign.RIGHT)
				{
					line.x = width - line.width;
				}
				else
				{
					line.x = 0;
				}
			}
		}
	}
}
