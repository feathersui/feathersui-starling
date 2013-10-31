/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.text
{
	import feathers.core.FeathersControl;
	import feathers.core.ITextRenderer;

	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.ConcreteTexture;
	import starling.textures.Texture;
	import starling.utils.getNextPowerOfTwo;

	/**
	 * Renders text with a native <code>flash.text.TextField</code> and draws
	 * it to <code>BitmapData</code> to convert to Starling textures. Textures
	 * are completely managed by this component, and they will be automatically
	 * disposed when the component is removed from the stage.
	 *
	 * <p>For longer passages of text, this component will stitch together
	 * multiple individual textures both horizontally and vertically, as a grid,
	 * if required. This may require quite a lot of texture memory, possibly
	 * exceeding the limits of some mobile devices, so use this component with
	 * caution when displaying a lot of text.</p>
	 *
	 * @see http://wiki.starling-framework.org/feathers/text-renderers
	 * @see flash.text.TextField
	 */
	public class TextFieldTextRenderer extends FeathersControl implements ITextRenderer
	{
		/**
		 * @private
		 */
		private static const HELPER_POINT:Point = new Point();

		/**
		 * @private
		 */
		private static const HELPER_MATRIX:Matrix = new Matrix();

		/**
		 * Constructor.
		 */
		public function TextFieldTextRenderer()
		{
			this.isQuickHitAreaEnabled = true;
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}

		/**
		 * The TextField instance used to render the text before taking a
		 * texture snapshot.
		 */
		protected var textField:TextField;

		/**
		 * An image that displays a snapshot of the native <code>TextField</code>
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
		protected var _previousTextFieldWidth:Number = NaN;

		/**
		 * @private
		 */
		protected var _previousTextFieldHeight:Number = NaN;

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
		protected var _needsNewTexture:Boolean = false;

		/**
		 * @private
		 */
		protected var _text:String = "";

		/**
		 * @inheritDoc
		 *
		 * <p>In the following example, the text is changed:</p>
		 *
		 * <listing version="3.0">
		 * textRenderer.text = "Lorem ipsum";</listing>
		 *
		 * @default ""
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
			if(value === null)
			{
				//flash.text.TextField won't accept a null value
				value = "";
			}
			this._text = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _isHTML:Boolean = false;

		/**
		 * Determines if the TextField should display the text as HTML or not.
		 *
		 * <p>In the following example, the text is displayed as HTML:</p>
		 *
		 * <listing version="3.0">
		 * textRenderer.isHTML = true;</listing>
		 *
		 * @default false
		 *
		 * @see flash.text.TextField#htmlText
		 */
		public function get isHTML():Boolean
		{
			return this._isHTML;
		}

		/**
		 * @private
		 */
		public function set isHTML(value:Boolean):void
		{
			if(this._isHTML == value)
			{
				return;
			}
			this._isHTML = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _textFormat:TextFormat;

		/**
		 * The font and styles used to draw the text.
		 *
		 * <p>In the following example, the text format is changed:</p>
		 *
		 * <listing version="3.0">
		 * textRenderer.textFormat = new TextFormat( "Source Sans Pro" );</listing>
		 *
		 * @default null
		 *
		 * @see #disabledTextFormat
		 * @see flash.text.TextFormat
		 */
		public function get textFormat():TextFormat
		{
			return this._textFormat;
		}

		/**
		 * @private
		 */
		public function set textFormat(value:TextFormat):void
		{
			if(this._textFormat == value)
			{
				return;
			}
			this._textFormat = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _disabledTextFormat:TextFormat;

		/**
		 * The font and styles used to draw the text when the component is disabled.
		 *
		 * <p>In the following example, the disabled text format is changed:</p>
		 *
		 * <listing version="3.0">
		 * textRenderer.isEnabled = false;
		 * textRenderer.disabledTextFormat = new TextFormat( "Source Sans Pro" );</listing>
		 *
		 * @default null
		 *
		 * @see #textFormat
		 * @see flash.text.TextFormat
		 */
		public function get disabledTextFormat():TextFormat
		{
			return this._disabledTextFormat;
		}

		/**
		 * @private
		 */
		public function set disabledTextFormat(value:TextFormat):void
		{
			if(this._disabledTextFormat == value)
			{
				return;
			}
			this._disabledTextFormat = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _styleSheet:StyleSheet;

		/**
		 * The <code>StyleSheet</code> object to pass to the TextField.
		 *
		 * <p>In the following example, the text is changed:</p>
		 *
		 * <listing version="3.0">
		 * var style:StyleSheet = new StyleSheet();
		 * var heading:Object = new Object();
		 * heading.fontWeight = "bold";
		 * heading.color = "#FF0000";
		 *
		 * var body:Object = new Object();
		 * body.fontStyle = "italic";
		 *
		 * style.setStyle(".heading", heading);
		 * style.setStyle("body", body);
		 *
		 * textRenderer.styleSheet = style;
		 * textRenderer.htmlText = "<body><span class='heading'>Hello </span>World...</body>";</listing>
		 *
		 * @default null
		 *
		 * @see flash.text.StyleSheet
		 */
		public function get styleSheet():StyleSheet
		{
			return this._styleSheet;
		}

		/**
		 * @private
		 */
		public function set styleSheet(value:StyleSheet):void
		{
			if(this._styleSheet == value)
			{
				return;
			}
			this._styleSheet = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _embedFonts:Boolean = false;

		/**
		 * Determines if the TextField should use an embedded font or not.
		 *
		 * <p>In the following example, the font is embedded:</p>
		 *
		 * <listing version="3.0">
		 * textRenderer.embedFonts = true;</listing>
		 *
		 * @default false
		 */
		public function get embedFonts():Boolean
		{
			return this._embedFonts;
		}

		/**
		 * @private
		 */
		public function set embedFonts(value:Boolean):void
		{
			if(this._embedFonts == value)
			{
				return;
			}
			this._embedFonts = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @inheritDoc
		 */
		public function get baseline():Number
		{
			//2 is the gutter Flash Player adds
			return 2 + this.textField.getLineMetrics(0).ascent;
		}

		/**
		 * @private
		 */
		protected var _wordWrap:Boolean = false;

		/**
		 * Determines if the TextField wraps text to the next line.
		 *
		 * <p>In the following example, word wrap is enabled:</p>
		 *
		 * <listing version="3.0">
		 * textRenderer.wordWrap = true;</listing>
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
		 * @private
		 */
		protected var _snapToPixels:Boolean = true;

		/**
		 * Determines if the text should be snapped to the nearest whole pixel
		 * when rendered. When this is <code>false</code>, text may be displayed
		 * on sub-pixels, which often results in blurred rendering due to
		 * texture smoothing.
		 *
		 * <p>In the following example, the text is not snapped to pixels:</p>
		 *
		 * <listing version="3.0">
		 * textRenderer.snapToPixels = false;</listing>
		 *
		 * @default true
		 */
		public function get snapToPixels():Boolean
		{
			return this._snapToPixels;
		}

		/**
		 * @private
		 */
		public function set snapToPixels(value:Boolean):void
		{
			this._snapToPixels = value;
		}

		/**
		 * @private
		 */
		private var _antiAliasType:String = AntiAliasType.ADVANCED;

		/**
		 * Same as the TextField property with the same name.
		 *
		 * <p>In the following example, the anti-alias type is changed:</p>
		 *
		 * <listing version="3.0">
		 * textRenderer.antiAliasType = AntiAliasType.NORMAL;</listing>
		 *
		 * @default flash.text.AntiAliasType.ADVANCED
		 *
		 * @see flash.text.TextField#antiAliasType
		 */
		public function get antiAliasType():String
		{
			return this._antiAliasType;
		}

		/**
		 * @private
		 */
		public function set antiAliasType(value:String):void
		{
			if(this._antiAliasType == value)
			{
				return;
			}
			this._antiAliasType = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _background:Boolean = false;

		/**
		 * Same as the TextField property with the same name.
		 *
		 * <p>In the following example, the background is enabled:</p>
		 *
		 * <listing version="3.0">
		 * textRenderer.background = true;</listing>
		 *
		 * @default false
		 *
		 * @see flash.text.TextField#background
		 * @see #backgroundColor
		 */
		public function get background():Boolean
		{
			return this._background;
		}

		/**
		 * @private
		 */
		public function set background(value:Boolean):void
		{
			if(this._background == value)
			{
				return;
			}
			this._background = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _backgroundColor:uint = 0xffffff;

		/**
		 * Same as the TextField property with the same name.
		 *
		 * <p>In the following example, the background color is changed:</p>
		 *
		 * <listing version="3.0">
		 * textRenderer.backgroundColor = 0xff000ff;</listing>
		 *
		 * @default 0xffffff
		 *
		 * @see flash.text.TextField#backgroundColor
		 * @see #background
		 */
		public function get backgroundColor():uint
		{
			return this._backgroundColor;
		}

		/**
		 * @private
		 */
		public function set backgroundColor(value:uint):void
		{
			if(this._backgroundColor == value)
			{
				return;
			}
			this._backgroundColor = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _border:Boolean = false;

		/**
		 * Same as the TextField property with the same name.
		 *
		 * <p>In the following example, the border is enabled:</p>
		 *
		 * <listing version="3.0">
		 * textRenderer.border = true;</listing>
		 *
		 * @default false
		 *
		 * @see flash.text.TextField#border
		 * @see #borderColor
		 */
		public function get border():Boolean
		{
			return this._border;
		}

		/**
		 * @private
		 */
		public function set border(value:Boolean):void
		{
			if(this._border == value)
			{
				return;
			}
			this._border = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _borderColor:uint = 0x000000;

		/**
		 * Same as the TextField property with the same name.
		 *
		 * <p>In the following example, the border color is changed:</p>
		 *
		 * <listing version="3.0">
		 * textRenderer.borderColor = 0xff00ff;</listing>
		 *
		 * @default 0x000000
		 *
		 * @see flash.text.TextField#borderColor
		 * @see #border
		 */
		public function get borderColor():uint
		{
			return this._borderColor;
		}

		/**
		 * @private
		 */
		public function set borderColor(value:uint):void
		{
			if(this._borderColor == value)
			{
				return;
			}
			this._borderColor = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _condenseWhite:Boolean = false;

		/**
		 * Same as the TextField property with the same name.
		 *
		 * <p>In the following example, whitespace is condensed:</p>
		 *
		 * <listing version="3.0">
		 * textRenderer.condenseWhite = true;</listing>
		 *
		 * @default false
		 *
		 * @see flash.text.TextField#condenseWhite
		 */
		public function get condenseWhite():Boolean
		{
			return this._condenseWhite;
		}

		/**
		 * @private
		 */
		public function set condenseWhite(value:Boolean):void
		{
			if(this._condenseWhite == value)
			{
				return;
			}
			this._condenseWhite = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _displayAsPassword:Boolean = false;

		/**
		 * Same as the TextField property with the same name.
		 *
		 * <p>In the following example, the text is displayed as a password:</p>
		 *
		 * <listing version="3.0">
		 * textRenderer.displayAsPassword = true;</listing>
		 *
		 * @default false
		 *
		 * @see flash.text.TextField#displayAsPassword
		 */
		public function get displayAsPassword():Boolean
		{
			return this._displayAsPassword;
		}

		/**
		 * @private
		 */
		public function set displayAsPassword(value:Boolean):void
		{
			if(this._displayAsPassword == value)
			{
				return;
			}
			this._displayAsPassword = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _gridFitType:String = GridFitType.PIXEL;

		/**
		 * Same as the TextField property with the same name.
		 *
		 * <p>In the following example, the grid fit type is changed:</p>
		 *
		 * <listing version="3.0">
		 * textRenderer.gridFitType = GridFitType.SUBPIXEL;</listing>
		 *
		 * @default flash.text.GridFitType.PIXEL
		 *
		 * @see flash.text.TextField#gridFitType
		 */
		public function get gridFitType():String
		{
			return this._gridFitType;
		}

		/**
		 * @private
		 */
		public function set gridFitType(value:String):void
		{
			if(this._gridFitType == value)
			{
				return;
			}
			this._gridFitType = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _sharpness:Number = 0;

		/**
		 * Same as the TextField property with the same name.
		 *
		 * <p>In the following example, the sharpness is changed:</p>
		 *
		 * <listing version="3.0">
		 * textRenderer.sharpness = 200;</listing>
		 *
		 * @default 0
		 *
		 * @see flash.text.TextField#sharpness
		 */
		public function get sharpness():Number
		{
			return this._sharpness;
		}

		/**
		 * @private
		 */
		public function set sharpness(value:Number):void
		{
			if(this._sharpness == value)
			{
				return;
			}
			this._sharpness = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		private var _thickness:Number = 0;

		/**
		 * Same as the TextField property with the same name.
		 *
		 * <p>In the following example, the thickness is changed:</p>
		 *
		 * <listing version="3.0">
		 * textRenderer.thickness = 100;</listing>
		 *
		 * @default 0
		 *
		 * @see flash.text.TextField#thickness
		 */
		public function get thickness():Number
		{
			return this._thickness;
		}

		/**
		 * @private
		 */
		public function set thickness(value:Number):void
		{
			if(this._thickness == value)
			{
				return;
			}
			this._thickness = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
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
			value = getNextPowerOfTwo(value);
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
		override public function dispose():void
		{
			this.disposeContent();
			super.dispose();
		}

		/**
		 * @private
		 */
		override public function render(support:RenderSupport, parentAlpha:Number):void
		{
			if(this.textSnapshot)
			{
				if(this._snapToPixels)
				{
					this.getTransformationMatrix(this.stage, HELPER_MATRIX);
					this.textSnapshot.x = Math.round(HELPER_MATRIX.tx) - HELPER_MATRIX.tx;
					this.textSnapshot.y = Math.round(HELPER_MATRIX.ty) - HELPER_MATRIX.ty;
				}
				else
				{
					this.textSnapshot.x = this.textSnapshot.y = 0;
				}
			}
			super.render(support, parentAlpha);
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

			if(!this.textField)
			{
				result.x = result.y = 0;
				return result;
			}

			const needsWidth:Boolean = isNaN(this.explicitWidth);
			const needsHeight:Boolean = isNaN(this.explicitHeight);
			if(!needsWidth && !needsHeight)
			{
				result.x = this.explicitWidth;
				result.y = this.explicitHeight;
				return result;
			}

			this.commit();

			result = this.measure(result);

			return result;
		}

		/**
		 * @private
		 */
		override protected function initialize():void
		{
			if(!this.textField)
			{
				this.textField = new TextField();
				this.textField.mouseEnabled = this.textField.mouseWheelEnabled = false;
				this.textField.selectable = false;
				this.textField.multiline = true;
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
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);

			if(stylesInvalid)
			{
				this.textField.antiAliasType = this._antiAliasType;
				this.textField.background = this._background;
				this.textField.backgroundColor = this._backgroundColor;
				this.textField.border = this._border;
				this.textField.borderColor = this._borderColor;
				this.textField.condenseWhite = this._condenseWhite;
				this.textField.displayAsPassword = this._displayAsPassword;
				this.textField.gridFitType = this._gridFitType;
				this.textField.sharpness = this._sharpness;
				this.textField.thickness = this._thickness;
			}

			if(dataInvalid || stylesInvalid || stateInvalid)
			{
				this.textField.wordWrap = this._wordWrap;
				this.textField.embedFonts = this._embedFonts;
				if(!this._isEnabled && this._disabledTextFormat)
				{
					this.textField.defaultTextFormat = this._disabledTextFormat;
				}
				else if(this._textFormat)
				{
					this.textField.defaultTextFormat = this._textFormat;
				}
				this.textField.styleSheet = this._styleSheet;
				if(this._isHTML)
				{
					this.textField.htmlText = this._text;
				}
				else
				{
					this.textField.text = this._text;
				}
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

			const needsWidth:Boolean = isNaN(this.explicitWidth);
			const needsHeight:Boolean = isNaN(this.explicitHeight);

			this.textField.autoSize = TextFieldAutoSize.LEFT;
			this.textField.wordWrap = false;

			var newWidth:Number = this.explicitWidth;
			if(needsWidth)
			{
				//yes, this value is never used. this is a workaround for a bug
				//in AIR for iOS where getting the value for textField.width the
				//first time results in an incorrect value, but if you query it
				//again, for some reason, it reports the correct width value.
				var hackWorkaround:Number = this.textField.width;

				//we use Math.ceil() as another workaround. even though we're
				//setting width to exact same value reported here when we turn
				//on word wrap in a moment, sometimes the last character moves
				//to the next line. Bumping up to a whole pixel seems to help.
				newWidth = Math.ceil(this.textField.width);
				if(newWidth < this._minWidth)
				{
					newWidth = this._minWidth;
				}
				else if(newWidth > this._maxWidth)
				{
					newWidth = this._maxWidth;
				}
			}

			this.textField.width = newWidth;
			this.textField.wordWrap = this._wordWrap;
			var newHeight:Number = this.explicitHeight;
			if(needsHeight)
			{
				newHeight = Math.ceil(this.textField.height);
				if(newHeight < this._minHeight)
				{
					newHeight = this._minHeight;
				}
				else if(newHeight > this._maxHeight)
				{
					newHeight = this._maxHeight;
				}
			}

			this.textField.autoSize = TextFieldAutoSize.NONE;

			//put the width and height back just in case we measured without
			//a full validation
			this.textField.width = this.actualWidth;
			this.textField.height = this.actualHeight;

			result.x = newWidth;
			result.y = newHeight;

			return result;
		}

		/**
		 * @private
		 */
		protected function layout(sizeInvalid:Boolean):void
		{
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);

			if(sizeInvalid)
			{
				this.textField.width = this.actualWidth;
				this.textField.height = this.actualHeight;
				var rectangleSnapshotWidth:Number = this.actualWidth * Starling.contentScaleFactor;
				if(rectangleSnapshotWidth > this._maxTextureDimensions)
				{
					this._snapshotWidth = int(rectangleSnapshotWidth / this._maxTextureDimensions) * this._maxTextureDimensions + getNextPowerOfTwo(rectangleSnapshotWidth % this._maxTextureDimensions);
				}
				else
				{
					this._snapshotWidth = getNextPowerOfTwo(rectangleSnapshotWidth);
				}
				var rectangleSnapshotHeight:Number = this.actualHeight * Starling.contentScaleFactor;
				if(rectangleSnapshotHeight > this._maxTextureDimensions)
				{
					this._snapshotHeight = int(rectangleSnapshotHeight / this._maxTextureDimensions) * this._maxTextureDimensions + getNextPowerOfTwo(rectangleSnapshotHeight % this._maxTextureDimensions);
				}
				else
				{
					this._snapshotHeight = getNextPowerOfTwo(rectangleSnapshotHeight);
				}
				const textureRoot:ConcreteTexture = this.textSnapshot ? this.textSnapshot.texture.root : null;
				this._needsNewTexture = this._needsNewTexture || !this.textSnapshot || this._snapshotWidth != textureRoot.width || this._snapshotHeight != textureRoot.height;
			}

			//instead of checking sizeInvalid, which will often be triggered by
			//changing maxWidth or something for measurement, we check against
			//the previous actualWidth/Height used for the snapshot.
			if(stylesInvalid || dataInvalid || this._needsNewTexture ||
				this.actualWidth != this._previousTextFieldWidth ||
				this.actualHeight != this._previousTextFieldHeight)
			{
				this._previousTextFieldWidth = this.actualWidth;
				this._previousTextFieldHeight = this.actualHeight;
				const hasText:Boolean = this._text.length > 0;
				if(hasText)
				{
					//we need to wait a frame for the TextField to render
					//properly. sometimes two, and this is a known issue.
					this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
				}
				if(this.textSnapshot)
				{
					this.textSnapshot.visible = hasText;
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
			const needsWidth:Boolean = isNaN(this.explicitWidth);
			const needsHeight:Boolean = isNaN(this.explicitHeight);
			if(!needsWidth && !needsHeight)
			{
				return false;
			}

			this.measure(HELPER_POINT);
			return this.setSizeInternal(HELPER_POINT.x, HELPER_POINT.y, false);
		}

		/**
		 * @private
		 */
		protected function texture_onRestore():void
		{
			this.refreshSnapshot();
		}

		/**
		 * @private
		 */
		protected function refreshSnapshot():void
		{
			if(this._snapshotWidth == 0 || this._snapshotHeight == 0)
			{
				return;
			}
			HELPER_MATRIX.identity();
			HELPER_MATRIX.scale(Starling.contentScaleFactor, Starling.contentScaleFactor);
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
					if(!bitmapData || bitmapData.width != currentBitmapWidth || bitmapData.height != currentBitmapHeight)
					{
						if(bitmapData)
						{
							bitmapData.dispose();
						}
						bitmapData = new BitmapData(currentBitmapWidth, currentBitmapHeight, true, 0x00ff00ff);
					}
					else
					{
						//clear the bitmap data and reuse it
						bitmapData.fillRect(bitmapData.rect, 0x00ff00ff);
					}
					HELPER_MATRIX.tx = -xPosition;
					HELPER_MATRIX.ty = -yPosition;
					bitmapData.draw(this.textField, HELPER_MATRIX);
					var newTexture:Texture;
					if(!this.textSnapshot || this._needsNewTexture)
					{
						newTexture = Texture.fromBitmapData(bitmapData, false, false, Starling.contentScaleFactor);
						newTexture.root.onRestore = texture_onRestore;
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
							const existingTexture:Texture = snapshot.texture;
							existingTexture.root.uploadBitmapData(bitmapData);
						}
					}
					if(snapshotIndex >= 0)
					{
						this.textSnapshots[snapshotIndex] = snapshot;
					}
					else
					{
						this.textSnapshot = snapshot;
					}
					snapshot.x = xPosition;
					snapshot.y = yPosition;
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
			this._needsNewTexture = false;
		}

		/**
		 * @private
		 */
		protected function disposeContent():void
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

			this._previousTextFieldWidth = NaN;
			this._previousTextFieldHeight = NaN;

			this._needsNewTexture = false;
			this._snapshotWidth = 0;
			this._snapshotHeight = 0;
		}

		/**
		 * @private
		 */
		protected function addedToStageHandler(event:Event):void
		{
			//we need to invalidate in order to get a fresh snapshot
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		/**
		 * @private
		 */
		protected function removedFromStageHandler(event:Event):void
		{
			this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);

			//avoid the need to call dispose(). we'll create a new snapshot
			//when the renderer is added to stage again.
			this.disposeContent();
		}

		/**
		 * @private
		 */
		protected function enterFrameHandler(event:Event):void
		{
			this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			this.refreshSnapshot();
		}
	}
}
