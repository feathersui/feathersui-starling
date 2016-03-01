/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.text
{
	import feathers.core.FeathersControl;
	import feathers.core.IStateContext;
	import feathers.core.IStateObserver;
	import feathers.core.ITextRenderer;
	import feathers.core.IToggle;
	import feathers.events.FeathersEventType;
	import feathers.skins.IStyleProvider;
	import feathers.text.BitmapFontTextFormat;

	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;

	import starling.display.Image;
	import starling.display.MeshBatch;
	import starling.events.Event;
	import starling.rendering.Painter;
	import starling.text.BitmapChar;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import starling.utils.MathUtil;

	/**
	 * Renders text using
	 * <a href="http://wiki.starling-framework.org/manual/displaying_text#bitmap_fonts" target="_top">bitmap fonts</a>.
	 *
	 * <p>The following example shows how to use
	 * <code>BitmapFontTextRenderer</code> with a <code>Label</code>:</p>
	 *
	 * <listing version="3.0">
	 * var label:Label = new Label();
	 * label.text = "I am the very model of a modern Major General";
	 * label.textRendererFactory = function():ITextRenderer
	 * {
	 *     return new BitmapFontTextRenderer();
	 * };
	 * this.addChild( label );</listing>
	 *
	 * @see ../../../../help/text-renderers.html Introduction to Feathers text renderers
	 * @see ../../../../help/bitmap-font-text-renderer.html How to use the Feathers BitmapFontTextRenderer component
	 * @see http://wiki.starling-framework.org/manual/displaying_text#bitmap_fonts Starling Wiki: Displaying Text with Bitmap Fonts
	 */
	public class BitmapFontTextRenderer extends FeathersControl implements ITextRenderer, IStateObserver
	{
		/**
		 * @private
		 */
		private static var HELPER_IMAGE:Image;

		/**
		 * @private
		 */
		private static const HELPER_POINT:Point = new Point();

		/**
		 * @private
		 */
		private static const CHARACTER_ID_SPACE:int = 32;

		/**
		 * @private
		 */
		private static const CHARACTER_ID_TAB:int = 9;

		/**
		 * @private
		 */
		private static const CHARACTER_ID_LINE_FEED:int = 10;

		/**
		 * @private
		 */
		private static const CHARACTER_ID_CARRIAGE_RETURN:int = 13;

		/**
		 * @private
		 */
		private static var CHARACTER_BUFFER:Vector.<CharLocation>;

		/**
		 * @private
		 */
		private static var CHAR_LOCATION_POOL:Vector.<CharLocation>;

		/**
		 * @private
		 */
		private static const FUZZY_MAX_WIDTH_PADDING:Number = 0.000001;

		/**
		 * The default <code>IStyleProvider</code> for all <code>BitmapFontTextRenderer</code>
		 * components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * Constructor.
		 */
		public function BitmapFontTextRenderer()
		{
			super();
			if(!CHAR_LOCATION_POOL)
			{
				//compiler doesn't like referencing CharLocation class in a
				//static constant
				CHAR_LOCATION_POOL = new <CharLocation>[];
			}
			if(!CHARACTER_BUFFER)
			{
				CHARACTER_BUFFER = new <CharLocation>[];
			}
			this.isQuickHitAreaEnabled = true;
		}

		/**
		 * @private
		 */
		protected var _characterBatch:MeshBatch;

		/**
		 * @private
		 * This variable may be used by subclasses to affect the x position of
		 * the text.
		 */
		protected var _batchX:Number = 0;

		/**
		 * @private
		 */
		protected var currentTextFormat:BitmapFontTextFormat;

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return BitmapFontTextRenderer.globalStyleProvider;
		}

		/**
		 * @private
		 */
		protected var _textFormatForState:Object;
		
		/**
		 * @private
		 */
		protected var _textFormat:BitmapFontTextFormat;
		
		/**
		 * The font and styles used to draw the text.
		 *
		 * <p>In the following example, the text format is changed:</p>
		 *
		 * <listing version="3.0">
		 * textRenderer.textFormat = new BitmapFontTextFormat( bitmapFont );</listing>
		 *
		 * @default null
		 *
		 * @see #setTextFormatForState()
		 * @see #disabledTextFormat
		 * @see #selectedTextFormat
		 */
		public function get textFormat():BitmapFontTextFormat
		{
			return this._textFormat;
		}
		
		/**
		 * @private
		 */
		public function set textFormat(value:BitmapFontTextFormat):void
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
		protected var _disabledTextFormat:BitmapFontTextFormat;

		/**
		 * The font and styles used to draw the text when the label is disabled.
		 *
		 * <p>In the following example, the disabled text format is changed:</p>
		 *
		 * <listing version="3.0">
		 * textRenderer.isEnabled = false;
		 * textRenderer.disabledTextFormat = new BitmapFontTextFormat( bitmapFont );</listing>
		 *
		 * @default null
		 * 
		 * @see #textFormat
		 * @see #selectedTextFormat
		 */
		public function get disabledTextFormat():BitmapFontTextFormat
		{
			return this._disabledTextFormat;
		}

		/**
		 * @private
		 */
		public function set disabledTextFormat(value:BitmapFontTextFormat):void
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
		protected var _selectedTextFormat:BitmapFontTextFormat;

		/**
		 * The font and styles used to draw the text when the
		 * <code>stateContext</code> implements the <code>IToggle</code>
		 * interface, and it is selected.
		 *
		 * <p>In the following example, the selected text format is changed:</p>
		 *
		 * <listing version="3.0">
		 * textRenderer.selectedTextFormat = new BitmapFontTextFormat( bitmapFont );</listing>
		 *
		 * @default null
		 *
		 * @see #stateContext
		 * @see feathers.core.IToggle
		 * @see #textFormat
		 * @see #disabledTextFormat
		 */
		public function get selectedTextFormat():BitmapFontTextFormat
		{
			return this._selectedTextFormat;
		}

		/**
		 * @private
		 */
		public function set selectedTextFormat(value:BitmapFontTextFormat):void
		{
			if(this._selectedTextFormat == value)
			{
				return;
			}
			this._selectedTextFormat = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		/**
		 * @private
		 */
		protected var _text:String = null;
		
		/**
		 * @inheritDoc
		 *
		 * <p>In the following example, the text is changed:</p>
		 *
		 * <listing version="3.0">
		 * textRenderer.text = "Lorem ipsum";</listing>
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
		protected var _textureSmoothing:String = TextureSmoothing.BILINEAR;

		[Inspectable(type="String",enumeration="bilinear,trilinear,none")]
		/**
		 * A texture smoothing value passed to each character image.
		 *
		 * <p>In the following example, the texture smoothing is changed:</p>
		 *
		 * <listing version="3.0">
		 * textRenderer.textureSmoothing = TextureSmoothing.NONE;</listing>
		 *
		 * @default starling.textures.TextureSmoothing.BILINEAR
		 *
		 * @see http://doc.starling-framework.org/core/starling/textures/TextureSmoothing.html starling.textures.TextureSmoothing
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
			if(this._textureSmoothing == value)
			{
				return;
			}
			this._textureSmoothing = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _wordWrap:Boolean = false;

		/**
		 * @inheritDoc
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
			return _wordWrap;
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
		protected var _truncateToFit:Boolean = true;

		/**
		 * If word wrap is disabled, and the text is longer than the width of
		 * the label, the text may be truncated using <code>truncationText</code>.
		 *
		 * <p>This feature may be disabled to improve performance.</p>
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
		protected var _useSeparateBatch:Boolean = true;

		/**
		 * Determines if the characters are batched normally by Starling or if
		 * they're batched separately. Batching separately may improve
		 * performance for text that changes often, while batching normally
		 * may be better when a lot of text is displayed on screen at once.
		 *
		 * <p>In the following example, separate batching is disabled:</p>
		 *
		 * <listing version="3.0">
		 * textRenderer.useSeparateBatch = false;</listing>
		 *
		 * @default true
		 */
		public function get useSeparateBatch():Boolean
		{
			return this._useSeparateBatch;
		}

		/**
		 * @private
		 */
		public function set useSeparateBatch(value:Boolean):void
		{
			if(this._useSeparateBatch == value)
			{
				return;
			}
			this._useSeparateBatch = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @inheritDoc
		 */
		public function get baseline():Number
		{
			if(!this._textFormat)
			{
				return 0;
			}
			var font:BitmapFont = this._textFormat.font;
			var formatSize:Number = this._textFormat.size;
			var fontSizeScale:Number = formatSize / font.size;
			if(fontSizeScale !== fontSizeScale) //isNaN
			{
				fontSizeScale = 1;
			}
			var baseline:Number = font.baseline;
			//for some reason, if we don't call a function right here,
			//compiling with the flex 4.6 SDK will throw a VerifyError
			//for a stack overflow.
			//we could change the !== check back to isNaN() instead, but
			//isNaN() can allocate an object, so we should call a different
			//function without allocation.
			this.doNothing();
			if(baseline !== baseline) //isNaN
			{
				return font.lineHeight * fontSizeScale;
			}
			return baseline * fontSizeScale;
		}

		/**
		 * @private
		 */
		protected var _stateContext:IStateContext;

		/**
		 * When the text renderer observes a state context, the text renderer
		 * may change its <code>BitmapFontTextFormat</code> based on the current
		 * state of that context. Typically, a relevant component will
		 * automatically assign itself as the state context of a text renderer,
		 * so this property is typically meant for internal use only.
		 *
		 * @default null
		 *
		 * @see #setTextFormatForState()
		 */
		public function get stateContext():IStateContext
		{
			return this._stateContext;
		}

		/**
		 * @private
		 */
		public function set stateContext(value:IStateContext):void
		{
			if(this._stateContext === value)
			{
				return;
			}
			if(this._stateContext)
			{
				this._stateContext.removeEventListener(FeathersEventType.STATE_CHANGE, stateContext_stateChangeHandler);
			}
			this._stateContext = value;
			if(this._stateContext)
			{
				this._stateContext.addEventListener(FeathersEventType.STATE_CHANGE, stateContext_stateChangeHandler);
			}
			this.invalidate(INVALIDATION_FLAG_STATE);
		}

		/**
		 * @private
		 */
		override public function dispose():void
		{
			this.stateContext = null;
			super.dispose();
		}

		/**
		 * @private
		 */
		override public function render(painter:Painter):void
		{
			this._characterBatch.x = this._batchX;
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

			if(this.isInvalid(INVALIDATION_FLAG_STYLES) || this.isInvalid(INVALIDATION_FLAG_STATE))
			{
				this.refreshTextFormat();
			}

			if(!this.currentTextFormat || this._text === null)
			{
				result.setTo(0, 0);
				return result;
			}

			var font:BitmapFont = this.currentTextFormat.font;
			var customSize:Number = this.currentTextFormat.size;
			var customLetterSpacing:Number = this.currentTextFormat.letterSpacing;
			var isKerningEnabled:Boolean = this.currentTextFormat.isKerningEnabled;
			var scale:Number = customSize / font.size;
			if(scale !== scale) //isNaN
			{
				scale = 1;
			}
			var lineHeight:Number = font.lineHeight * scale + this.currentTextFormat.leading;
			var maxLineWidth:Number = this._explicitWidth;
			if(maxLineWidth !== maxLineWidth) //isNaN
			{
				maxLineWidth = this._maxWidth;
			}

			var maxX:Number = 0;
			var currentX:Number = 0;
			var currentY:Number = 0;
			var previousCharID:Number = NaN;
			var charCount:int = this._text.length;
			var startXOfPreviousWord:Number = 0;
			var widthOfWhitespaceAfterWord:Number = 0;
			var wordCountForLine:int = 0;
			var line:String = "";
			var word:String = "";
			for(var i:int = 0; i < charCount; i++)
			{
				var charID:int = this._text.charCodeAt(i);
				if(charID == CHARACTER_ID_LINE_FEED || charID == CHARACTER_ID_CARRIAGE_RETURN) //new line \n or \r
				{
					currentX = currentX - customLetterSpacing;
					if(currentX < 0)
					{
						currentX = 0;
					}
					if(maxX < currentX)
					{
						maxX = currentX;
					}
					previousCharID = NaN;
					currentX = 0;
					currentY += lineHeight;
					startXOfPreviousWord = 0;
					wordCountForLine = 0;
					widthOfWhitespaceAfterWord = 0;
					continue;
				}

				var charData:BitmapChar = font.getChar(charID);
				if(!charData)
				{
					trace("Missing character " + String.fromCharCode(charID) + " in font " + font.name + ".");
					continue;
				}

				if(isKerningEnabled &&
					previousCharID === previousCharID) //!isNaN
				{
					currentX += charData.getKerning(previousCharID) * scale;
				}

				var xAdvance:Number = charData.xAdvance * scale;
				if(this._wordWrap)
				{
					var currentCharIsWhitespace:Boolean = charID == CHARACTER_ID_SPACE || charID == CHARACTER_ID_TAB;
					var previousCharIsWhitespace:Boolean = previousCharID == CHARACTER_ID_SPACE || previousCharID == CHARACTER_ID_TAB;
					if(currentCharIsWhitespace)
					{
						if(!previousCharIsWhitespace)
						{
							widthOfWhitespaceAfterWord = 0;
						}
						widthOfWhitespaceAfterWord += xAdvance;
					}
					else if(previousCharIsWhitespace)
					{
						startXOfPreviousWord = currentX;
						wordCountForLine++;
						line += word;
						word = "";
					}

					if(!currentCharIsWhitespace && wordCountForLine > 0 && (currentX + xAdvance) > maxLineWidth)
					{
						//we're just reusing this variable to avoid creating a
						//new one. it'll be reset to 0 in a moment.
						widthOfWhitespaceAfterWord = startXOfPreviousWord - widthOfWhitespaceAfterWord;
						if(maxX < widthOfWhitespaceAfterWord)
						{
							maxX = widthOfWhitespaceAfterWord;
						}
						previousCharID = NaN;
						currentX -= startXOfPreviousWord;
						currentY += lineHeight;
						startXOfPreviousWord = 0;
						widthOfWhitespaceAfterWord = 0;
						wordCountForLine = 0;
						line = "";
					}
				}
				currentX += xAdvance + customLetterSpacing;
				previousCharID = charID;
				word += String.fromCharCode(charID);
			}
			currentX = currentX - customLetterSpacing;
			if(currentX < 0)
			{
				currentX = 0;
			}
			//if the text ends in extra whitespace, the currentX value will be
			//larger than the max line width. we'll remove that and add extra
			//lines.
			if(this._wordWrap)
			{
				while(currentX > maxLineWidth && !MathUtil.isEquivalent(currentX, maxLineWidth))
				{
					currentX -= maxLineWidth;
					currentY += lineHeight;
				}
			}
			if(maxX < currentX)
			{
				maxX = currentX;
			}

			result.x = maxX;
			result.y = currentY + lineHeight - this.currentTextFormat.leading;
			return result;
		}

		/**
		 * Sets the <code>BitmapFontTextFormat</code> to be used by the text
		 * renderer when the <code>currentState</code> property of the
		 * <code>stateContext</code> matches the specified state value.
		 *
		 * <p>If an <code>BitmapFontTextFormat</code> is not defined for a
		 * specific state, the value of the <code>textFormat</code> property
		 * will be used instead.</p>
		 *
		 * <p>If the <code>disabledTextFormat</code> property is not
		 * <code>null</code> and the <code>isEnabled</code> property is
		 * <code>false</code>, all other text formats will be ignored.</p>
		 *
		 * @see #stateContext
		 * @see #textFormat
		 */
		public function setTextFormatForState(state:String, textFormat:BitmapFontTextFormat):void
		{
			if(textFormat)
			{
				if(!this._textFormatForState)
				{
					this._textFormatForState = {};
				}
				this._textFormatForState[state] = textFormat;
			}
			else
			{
				delete this._textFormatForState[state];
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
			if(!this._characterBatch)
			{
				this._characterBatch = new MeshBatch();
				this._characterBatch.touchable = false;
				this.addChild(this._characterBatch);
			}
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

			if(stylesInvalid || stateInvalid)
			{
				this.refreshTextFormat();
			}

			if(dataInvalid || stylesInvalid || sizeInvalid || stateInvalid)
			{
				this._characterBatch.batchable = !this._useSeparateBatch;
				this._characterBatch.clear();
				if(!this.currentTextFormat || this._text === null)
				{
					this.setSizeInternal(0, 0, false);
					return;
				}
				this.layoutCharacters(HELPER_POINT);
				this.setSizeInternal(HELPER_POINT.x, HELPER_POINT.y, false);
			}
		}

		/**
		 * @private
		 */
		protected function layoutCharacters(result:Point = null):Point
		{
			if(!result)
			{
				result = new Point();
			}

			var font:BitmapFont = this.currentTextFormat.font;
			var customSize:Number = this.currentTextFormat.size;
			var customLetterSpacing:Number = this.currentTextFormat.letterSpacing;
			var isKerningEnabled:Boolean = this.currentTextFormat.isKerningEnabled;
			var scale:Number = customSize / font.size;
			if(scale !== scale) //isNaN
			{
				scale = 1;
			}
			var lineHeight:Number = font.lineHeight * scale + this.currentTextFormat.leading;
			var offsetX:Number = font.offsetX * scale;
			var offsetY:Number = font.offsetY * scale;

			var hasExplicitWidth:Boolean = this._explicitWidth === this._explicitWidth; //!isNaN
			var isAligned:Boolean = this.currentTextFormat.align != TextFormatAlign.LEFT;
			var maxLineWidth:Number = hasExplicitWidth ? this._explicitWidth : this._maxWidth;
			if(isAligned && maxLineWidth == Number.POSITIVE_INFINITY)
			{
				//we need to measure the text to get the maximum line width
				//so that we can align the text
				this.measureText(HELPER_POINT);
				maxLineWidth = HELPER_POINT.x;
			}
			var textToDraw:String = this._text;
			if(this._truncateToFit)
			{
				textToDraw = this.getTruncatedText(maxLineWidth);
			}
			CHARACTER_BUFFER.length = 0;

			var maxX:Number = 0;
			var currentX:Number = 0;
			var currentY:Number = 0;
			var previousCharID:Number = NaN;
			var isWordComplete:Boolean = false;
			var startXOfPreviousWord:Number = 0;
			var widthOfWhitespaceAfterWord:Number = 0;
			var wordLength:int = 0;
			var wordCountForLine:int = 0;
			var charCount:int = textToDraw ? textToDraw.length : 0;
			for(var i:int = 0; i < charCount; i++)
			{
				isWordComplete = false;
				var charID:int = textToDraw.charCodeAt(i);
				if(charID == CHARACTER_ID_LINE_FEED || charID == CHARACTER_ID_CARRIAGE_RETURN) //new line \n or \r
				{
					currentX = currentX - customLetterSpacing;
					if(currentX < 0)
					{
						currentX = 0;
					}
					if(this._wordWrap || isAligned)
					{
						this.alignBuffer(maxLineWidth, currentX, 0);
						this.addBufferToBatch(0);
					}
					if(maxX < currentX)
					{
						maxX = currentX;
					}
					previousCharID = NaN;
					currentX = 0;
					currentY += lineHeight;
					startXOfPreviousWord = 0;
					widthOfWhitespaceAfterWord = 0;
					wordLength = 0;
					wordCountForLine = 0;
					continue;
				}

				var charData:BitmapChar = font.getChar(charID);
				if(!charData)
				{
					trace("Missing character " + String.fromCharCode(charID) + " in font " + font.name + ".");
					continue;
				}

				if(isKerningEnabled &&
					previousCharID === previousCharID) //!isNaN
				{
					currentX += charData.getKerning(previousCharID) * scale;
				}

				var xAdvance:Number = charData.xAdvance * scale;
				if(this._wordWrap)
				{
					var currentCharIsWhitespace:Boolean = charID == CHARACTER_ID_SPACE || charID == CHARACTER_ID_TAB;
					var previousCharIsWhitespace:Boolean = previousCharID == CHARACTER_ID_SPACE || previousCharID == CHARACTER_ID_TAB;
					if(currentCharIsWhitespace)
					{
						if(!previousCharIsWhitespace)
						{
							widthOfWhitespaceAfterWord = 0;
						}
						widthOfWhitespaceAfterWord += xAdvance;
					}
					else if(previousCharIsWhitespace)
					{
						startXOfPreviousWord = currentX;
						wordLength = 0;
						wordCountForLine++;
						isWordComplete = true;
					}

					//we may need to move to a new line at the same time
					//that our previous word in the buffer can be batched
					//so we need to add the buffer here rather than after
					//the next section
					if(isWordComplete && !isAligned)
					{
						this.addBufferToBatch(0);
					}

					//floating point errors can cause unnecessary line breaks,
					//so we're going to be a little bit fuzzy on the greater
					//than check. such tiny numbers shouldn't break anything.
					if(!currentCharIsWhitespace && wordCountForLine > 0 && ((currentX + xAdvance) - maxLineWidth) > FUZZY_MAX_WIDTH_PADDING)
					{
						if(isAligned)
						{
							this.trimBuffer(wordLength);
							this.alignBuffer(maxLineWidth, startXOfPreviousWord - widthOfWhitespaceAfterWord, wordLength);
							this.addBufferToBatch(wordLength);
						}
						this.moveBufferedCharacters(-startXOfPreviousWord, lineHeight, 0);
						//we're just reusing this variable to avoid creating a
						//new one. it'll be reset to 0 in a moment.
						widthOfWhitespaceAfterWord = startXOfPreviousWord - widthOfWhitespaceAfterWord;
						if(maxX < widthOfWhitespaceAfterWord)
						{
							maxX = widthOfWhitespaceAfterWord;
						}
						previousCharID = NaN;
						currentX -= startXOfPreviousWord;
						currentY += lineHeight;
						startXOfPreviousWord = 0;
						widthOfWhitespaceAfterWord = 0;
						wordLength = 0;
						isWordComplete = false;
						wordCountForLine = 0;
					}
				}
				if(this._wordWrap || isAligned)
				{
					var charLocation:CharLocation = CHAR_LOCATION_POOL.length > 0 ? CHAR_LOCATION_POOL.shift() : new CharLocation();
					charLocation.char = charData;
					charLocation.x = currentX + offsetX + charData.xOffset * scale;
					charLocation.y = currentY + offsetY + charData.yOffset * scale;
					charLocation.scale = scale;
					CHARACTER_BUFFER[CHARACTER_BUFFER.length] = charLocation;
					wordLength++;
				}
				else
				{
					this.addCharacterToBatch(charData,
						currentX + offsetX + charData.xOffset * scale,
						currentY + offsetY + charData.yOffset * scale,
						scale);
				}

				currentX += xAdvance + customLetterSpacing;
				previousCharID = charID;
			}
			currentX = currentX - customLetterSpacing;
			if(currentX < 0)
			{
				currentX = 0;
			}
			if(this._wordWrap || isAligned)
			{
				this.alignBuffer(maxLineWidth, currentX, 0);
				this.addBufferToBatch(0);
			}
			//if the text ends in extra whitespace, the currentX value will be
			//larger than the max line width. we'll remove that and add extra
			//lines.
			if(this._wordWrap)
			{
				while(currentX > maxLineWidth && !MathUtil.isEquivalent(currentX, maxLineWidth))
				{
					currentX -= maxLineWidth;
					currentY += lineHeight;
				}
			}
			if(maxX < currentX)
			{
				maxX = currentX;
			}

			if(isAligned && !hasExplicitWidth)
			{
				var align:String = this._textFormat.align;
				if(align == TextFormatAlign.CENTER)
				{
					this._batchX = (maxX - maxLineWidth) / 2;
				}
				else if(align == TextFormatAlign.RIGHT)
				{
					this._batchX = maxX - maxLineWidth;
				}
			}
			else
			{
				this._batchX = 0;
			}
			this._characterBatch.x = this._batchX;

			result.x = maxX;
			result.y = currentY + lineHeight - this.currentTextFormat.leading;
			return result;
		}

		/**
		 * @private
		 */
		protected function trimBuffer(skipCount:int):void
		{
			var countToRemove:int = 0;
			var charCount:int = CHARACTER_BUFFER.length - skipCount;
			for(var i:int = charCount - 1; i >= 0; i--)
			{
				var charLocation:CharLocation = CHARACTER_BUFFER[i];
				var charData:BitmapChar = charLocation.char;
				var charID:int = charData.charID;
				if(charID == CHARACTER_ID_SPACE || charID == CHARACTER_ID_TAB)
				{
					countToRemove++;
				}
				else
				{
					break;
				}
			}
			if(countToRemove > 0)
			{
				CHARACTER_BUFFER.splice(i + 1, countToRemove);
			}
		}

		/**
		 * @private
		 */
		protected function alignBuffer(maxLineWidth:Number, currentLineWidth:Number, skipCount:int):void
		{
			var align:String = this.currentTextFormat.align;
			if(align == TextFormatAlign.CENTER)
			{
				this.moveBufferedCharacters(Math.round((maxLineWidth - currentLineWidth) / 2), 0, skipCount);
			}
			else if(align == TextFormatAlign.RIGHT)
			{
				this.moveBufferedCharacters(maxLineWidth - currentLineWidth, 0, skipCount);
			}
		}

		/**
		 * @private
		 */
		protected function addBufferToBatch(skipCount:int):void
		{
			var charCount:int = CHARACTER_BUFFER.length - skipCount;
			var pushIndex:int = CHAR_LOCATION_POOL.length;
			for(var i:int = 0; i < charCount; i++)
			{
				var charLocation:CharLocation = CHARACTER_BUFFER.shift();
				this.addCharacterToBatch(charLocation.char, charLocation.x, charLocation.y, charLocation.scale);
				charLocation.char = null;
				CHAR_LOCATION_POOL[pushIndex] = charLocation;
				pushIndex++;
			}
		}

		/**
		 * @private
		 */
		protected function moveBufferedCharacters(xOffset:Number, yOffset:Number, skipCount:int):void
		{
			var charCount:int = CHARACTER_BUFFER.length - skipCount;
			for(var i:int = 0; i < charCount; i++)
			{
				var charLocation:CharLocation = CHARACTER_BUFFER[i];
				charLocation.x += xOffset;
				charLocation.y += yOffset;
			}
		}

		/**
		 * @private
		 */
		protected function addCharacterToBatch(charData:BitmapChar, x:Number, y:Number, scale:Number, painter:Painter = null):void
		{
			var texture:Texture = charData.texture;
			var frame:Rectangle = texture.frame;
			if(frame)
			{
				if(frame.width === 0 || frame.height === 0)
				{
					return;
				}
			}
			else if(texture.width === 0 || texture.height === 0)
			{
				return;
			}
			if(!HELPER_IMAGE)
			{
				HELPER_IMAGE = new Image(texture);
			}
			else
			{
				HELPER_IMAGE.texture = texture;
				HELPER_IMAGE.readjustSize();
			}
			HELPER_IMAGE.scaleX = HELPER_IMAGE.scaleY = scale;
			HELPER_IMAGE.x = x;
			HELPER_IMAGE.y = y;
			HELPER_IMAGE.color = this.currentTextFormat.color;
			HELPER_IMAGE.textureSmoothing = this._textureSmoothing;

			if(painter)
			{
				/*support.pushMatrix();
				support.transformMatrix(HELPER_IMAGE);
				support.batchQuad(HELPER_IMAGE, parentAlpha, HELPER_IMAGE.texture, this._textureSmoothing);
				support.popMatrix();*/
			}
			else
			{
				this._characterBatch.addMesh(HELPER_IMAGE);
			}
		}

		/**
		 * @private
		 */
		protected function refreshTextFormat():void
		{
			var textFormat:BitmapFontTextFormat;
			if(this._stateContext && this._textFormatForState)
			{
				var currentState:String = this._stateContext.currentState;
				if(currentState in this._textFormatForState)
				{
					textFormat = BitmapFontTextFormat(this._textFormatForState[currentState]);
				}
			}
			if(!textFormat && !this._isEnabled && this._disabledTextFormat)
			{
				textFormat = this._disabledTextFormat;
			}
			if(!textFormat && this._selectedTextFormat &&
				this._stateContext is IToggle && IToggle(this._stateContext).isSelected)
			{
				textFormat = this._selectedTextFormat;
			}
			if(!textFormat)
			{
				//let's fall back to using Starling's embedded mini font if no
				//text format has been specified
				if(!this._textFormat)
				{
					//if it's not registered, do that first
					if(!TextField.getBitmapFont(BitmapFont.MINI))
					{
						TextField.registerBitmapFont(new BitmapFont());
					}
					this._textFormat = new BitmapFontTextFormat(BitmapFont.MINI, NaN, 0x000000);
				}
				textFormat = this._textFormat;
			}
			this.currentTextFormat = textFormat;
		}

		/**
		 * @private
		 */
		protected function getTruncatedText(width:Number):String
		{
			if(!this._text)
			{
				//this shouldn't be called if _text is null, but just in case...
				return "";
			}

			//if the width is infinity or the string is multiline, don't allow truncation
			if(width == Number.POSITIVE_INFINITY || this._wordWrap || this._text.indexOf(String.fromCharCode(CHARACTER_ID_LINE_FEED)) >= 0 || this._text.indexOf(String.fromCharCode(CHARACTER_ID_CARRIAGE_RETURN)) >= 0)
			{
				return this._text;
			}

			var font:BitmapFont = this.currentTextFormat.font;
			var customSize:Number = this.currentTextFormat.size;
			var customLetterSpacing:Number = this.currentTextFormat.letterSpacing;
			var isKerningEnabled:Boolean = this.currentTextFormat.isKerningEnabled;
			var scale:Number = customSize / font.size;
			if(scale !== scale) //isNaN
			{
				scale = 1;
			}
			var currentX:Number = 0;
			var previousCharID:Number = NaN;
			var charCount:int = this._text.length;
			var truncationIndex:int = -1;
			for(var i:int = 0; i < charCount; i++)
			{
				var charID:int = this._text.charCodeAt(i);
				var charData:BitmapChar = font.getChar(charID);
				if(!charData)
				{
					continue;
				}
				var currentKerning:Number = 0;
				if(isKerningEnabled &&
					previousCharID === previousCharID) //!isNaN
				{
					currentKerning = charData.getKerning(previousCharID) * scale;
				}
				currentX += currentKerning + charData.xAdvance * scale;
				if(currentX > width)
				{
					//floating point errors can cause unnecessary truncation,
					//so we're going to be a little bit fuzzy on the greater
					//than check. such tiny numbers shouldn't break anything.
					var difference:Number = Math.abs(currentX - width);
					if(difference > FUZZY_MAX_WIDTH_PADDING)
					{
						truncationIndex = i;
						break;
					}
				}
				currentX += customLetterSpacing;
				previousCharID = charID;
			}

			if(truncationIndex >= 0)
			{
				//first measure the size of the truncation text
				charCount = this._truncationText.length;
				for(i = 0; i < charCount; i++)
				{
					charID = this._truncationText.charCodeAt(i);
					charData = font.getChar(charID);
					if(!charData)
					{
						continue;
					}
					currentKerning = 0;
					if(isKerningEnabled &&
						previousCharID === previousCharID) //!isNaN
					{
						currentKerning = charData.getKerning(previousCharID) * scale;
					}
					currentX += currentKerning + charData.xAdvance * scale + customLetterSpacing;
					previousCharID = charID;
				}
				currentX -= customLetterSpacing;

				//then work our way backwards until we fit into the width
				for(i = truncationIndex; i >= 0; i--)
				{
					charID = this._text.charCodeAt(i);
					previousCharID = i > 0 ? this._text.charCodeAt(i - 1) : NaN;
					charData = font.getChar(charID);
					if(!charData)
					{
						continue;
					}
					currentKerning = 0;
					if(isKerningEnabled &&
						previousCharID === previousCharID) //!isNaN
					{
						currentKerning = charData.getKerning(previousCharID) * scale;
					}
					currentX -= (currentKerning + charData.xAdvance * scale + customLetterSpacing);
					if(currentX <= width)
					{
						return this._text.substr(0, i) + this._truncationText;
					}
				}
				return this._truncationText;
			}
			return this._text;
		}

		/**
		 * @private
		 */
		protected function stateContext_stateChangeHandler(event:Event):void
		{
			this.invalidate(INVALIDATION_FLAG_STATE);
		}

		/**
		 * @private
		 * This function is here to work around a bug in the Flex 4.6 SDK
		 * compiler. For explanation, see the places where it gets called.
		 */
		protected function doNothing():void {}
	}
}

import starling.text.BitmapChar;

class CharLocation
{
	public function CharLocation()
	{

	}

	public var char:BitmapChar;
	public var scale:Number;
	public var x:Number;
	public var y:Number;
}
