/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.controls.supportClasses.TextFieldViewPort;

	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.StyleSheet;
	import flash.text.TextFormat;

	/**
	 * Displays long passages of text in a scrollable container using the
	 * runtime's software-based <code>flash.text.TextField</code> as an overlay
	 * above Starling content on the classic display list. This component will
	 * <strong>always</strong> appear above Starling content. The only way to
	 * put something above ScrollText is to put something above it on the
	 * classic display list.
	 *
	 * <p>Meant as a workaround component for when TextFieldTextRenderer runs
	 * into the runtime texture limits.</p>
	 *
	 * @see http://wiki.starling-framework.org/feathers/scroll-text
	 * @see feathers.controls.text.TextFieldTextRenderer
	 */
	public class ScrollText extends Scroller
	{
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
		 * Constructor.
		 */
		public function ScrollText()
		{
			this.textViewPort = new TextFieldViewPort();
			this.viewPort = this.textViewPort;
		}

		/**
		 * @private
		 */
		protected var textViewPort:TextFieldViewPort;

		/**
		 * @private
		 */
		protected var _text:String = "";

		/**
		 * The text to display. If <code>isHTML</code> is <code>true</code>, the
		 * text will be rendered as HTML with the same capabilities as the
		 * <code>htmlText</code> property of <code>flash.text.TextField</code>.
		 *
		 * @see #isHTML
		 * @see flash.text.TextField#htmlText
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
			if(!value)
			{
				value = "";
			}
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
		protected var _isHTML:Boolean = false;

		/**
		 * Determines if the TextField should display the text as HTML or not.
		 *
		 * @see #text
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
		protected var _styleSheet:StyleSheet;

		/**
		 * The <code>StyleSheet</code> object to pass to the TextField.
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
		 * @private
		 */
		private var _antiAliasType:String = AntiAliasType.ADVANCED;

		/**
		 * Same as the TextField property with the same name.
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
		 * @see flash.text.TextField#background
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
		 * @see flash.text.TextField#backgroundColor
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
		 * @see flash.text.TextField#border
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
		 * @see flash.text.TextField#borderColor
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
		protected var _textPaddingTop:Number = 0;

		/**
		 * The minimum space, in pixels, between the component's top edge and
		 * the top edge of the text.
		 */
		override public function get paddingTop():Number
		{
			return this._textPaddingTop;
		}

		/**
		 * @private
		 */
		override public function set paddingTop(value:Number):void
		{
			if(this._textPaddingTop == value)
			{
				return;
			}
			this._textPaddingTop = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _textPaddingRight:Number = 0;

		/**
		 * The minimum space, in pixels, between the component's right edge and
		 * the right edge of the text.
		 */
		override public function get paddingRight():Number
		{
			return this._textPaddingRight;
		}

		/**
		 * @private
		 */
		override public function set paddingRight(value:Number):void
		{
			if(this._textPaddingRight == value)
			{
				return;
			}
			this._textPaddingRight = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _textPaddingBottom:Number = 0;

		/**
		 * The minimum space, in pixels, between the component's bottom edge and
		 * the bottom edge of the text.
		 */
		override public function get paddingBottom():Number
		{
			return this._textPaddingBottom;
		}

		/**
		 * @private
		 */
		override public function set paddingBottom(value:Number):void
		{
			if(this._textPaddingBottom == value)
			{
				return;
			}
			this._textPaddingBottom = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _textPaddingLeft:Number = 0;

		/**
		 * The minimum space, in pixels, between the component's left edge and
		 * the left edge of the text.
		 */
		override public function get paddingLeft():Number
		{
			return this._textPaddingLeft;
		}

		/**
		 * @private
		 */
		override public function set paddingLeft(value:Number):void
		{
			if(this._textPaddingLeft == value)
			{
				return;
			}
			this._textPaddingLeft = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _visible:Boolean = true;

		/**
		 * @private
		 */
		override public function get visible():Boolean
		{
			return this._visible;
		}

		/**
		 * @private
		 */
		override public function set visible(value:Boolean):void
		{
			if(this._visible == value)
			{
				return;
			}
			this._visible = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _alpha:Number = 1;

		/**
		 * @private
		 */
		override public function get alpha():Number
		{
			return this._alpha;
		}

		/**
		 * @private
		 */
		override public function set alpha(value:Number):void
		{
			if(this._alpha == value)
			{
				return;
			}
			this._alpha = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		override public function get hasVisibleArea():Boolean
		{
			return true;
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const scrollInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SCROLL);
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);

			if(dataInvalid)
			{
				this.textViewPort.text = this._text;
				this.textViewPort.isHTML = this._isHTML;
			}

			if(stylesInvalid)
			{
				this.textViewPort.antiAliasType = this._antiAliasType;
				this.textViewPort.background = this._background;
				this.textViewPort.backgroundColor = this._backgroundColor;
				this.textViewPort.border = this._border;
				this.textViewPort.borderColor = this._borderColor;
				this.textViewPort.condenseWhite = this._condenseWhite;
				this.textViewPort.displayAsPassword = this._displayAsPassword;
				this.textViewPort.gridFitType = this._gridFitType;
				this.textViewPort.sharpness = this._sharpness;
				this.textViewPort.thickness = this._thickness;
				this.textViewPort.textFormat = this._textFormat;
				this.textViewPort.styleSheet = this._styleSheet;
				this.textViewPort.embedFonts = this._embedFonts;
				this.textViewPort.paddingTop = this._textPaddingTop;
				this.textViewPort.paddingRight = this._textPaddingRight;
				this.textViewPort.paddingBottom = this._textPaddingBottom;
				this.textViewPort.paddingLeft = this._textPaddingLeft;
				this.textViewPort.visible = this._visible;
				this.textViewPort.alpha = this._alpha;
			}

			super.draw();
		}
	}
}
