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
	import feathers.text.BitmapFontTextFormat;

	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextFormatAlign;

	import starling.core.RenderSupport;
	import starling.display.Image;
	import starling.display.QuadBatch;
	import starling.text.BitmapChar;
	import starling.text.BitmapFont;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;

	/**
	 * Renders text using <code>starling.text.BitmapFont</code>.
	 *
	 * @see http://wiki.starling-framework.org/feathers/text-renderers
	 * @see starling.text.BitmapFont
	 */
	public class BitmapFontTextRenderer extends FeathersControl implements ITextRenderer
	{
		/**
		 * @private
		 */
		private static var HELPER_IMAGE:Image;

		/**
		 * @private
		 */
		private static const HELPER_MATRIX:Matrix = new Matrix();

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
		 * Constructor.
		 */
		public function BitmapFontTextRenderer()
		{
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
		protected var _characterBatch:QuadBatch;

		/**
		 * @private
		 */
		protected var _locations:Vector.<CharLocation>;

		/**
		 * @private
		 */
		protected var _images:Vector.<Image>;

		/**
		 * @private
		 */
		protected var _imagesCache:Vector.<Image>;

		/**
		 * @private
		 */
		protected var currentTextFormat:BitmapFontTextFormat;
		
		/**
		 * @private
		 */
		protected var _textFormat:BitmapFontTextFormat;
		
		/**
		 * The font and styles used to draw the text.
		 *
		 * @default null
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
		 * @default null
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
		protected var _text:String = null;
		
		/**
		 * The text to display.
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
		protected var _smoothing:String = TextureSmoothing.BILINEAR;

		[Inspectable(type="String",enumeration="bilinear,trilinear,none")]
		/**
		 * A smoothing value passed to each character image.
		 *
		 * @default starling.textures.TextureSmoothing.BILINEAR
		 *
		 * @see starling.textures.TextureSmoothing
		 */
		public function get smoothing():String
		{
			return this._smoothing;
		}
		
		/**
		 * @private
		 */
		public function set smoothing(value:String):void
		{
			if(this._smoothing == value)
			{
				return;
			}
			this._smoothing = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _wordWrap:Boolean = false;

		/**
		 * If the width or maxWidth values are set, then the text will continue
		 * on the next line, if it is too long.
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
		protected var _snapToPixels:Boolean = true;

		/**
		 * Determines if the position of the text should be snapped to the
		 * nearest whole pixel when rendered. When snapped to a whole pixel, the
		 * text is often more readable. When not snapped, the text may become
		 * blurry due to texture smoothing.
		 *
		 * @default true
		 */
		public function get snapToPixels():Boolean
		{
			return _snapToPixels;
		}

		/**
		 * @private
		 */
		public function set snapToPixels(value:Boolean):void
		{
			if(this._snapToPixels == value)
			{
				return;
			}
			this._snapToPixels = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _truncationText:String = "...";

		/**
		 * The text to display at the end of the label if it is truncated.
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
			const font:BitmapFont = this._textFormat.font;
			const formatSize:Number = this._textFormat.size;
			const fontSizeScale:Number = isNaN(formatSize) ? 1 : (formatSize / font.size);
			if(isNaN(font.baseline))
			{
				return font.lineHeight * fontSizeScale;
			}
			return font.baseline * fontSizeScale;
		}

		/**
		 * @private
		 */
		override public function dispose():void
		{
			this.moveLocationsToPool();
			super.dispose();
		}

		/**
		 * @private
		 */
		override public function render(support:RenderSupport, parentAlpha:Number):void
		{
			var offsetX:Number = 0;
			var offsetY:Number = 0;
			if(this._snapToPixels)
			{
				this.getTransformationMatrix(this.stage, HELPER_MATRIX);
				offsetX = Math.round(HELPER_MATRIX.tx) - HELPER_MATRIX.tx;
				offsetY = Math.round(HELPER_MATRIX.ty) - HELPER_MATRIX.ty;
			}
			if(this._locations)
			{
				const locationCount:int = this._locations.length;
				for(var i:int = 0; i < locationCount; i++)
				{
					var location:CharLocation = this._locations[i];
					var image:Image = this._images[i];
					image.x = offsetX + location.x;
					image.y = offsetY + location.y;
				}
			}
			else if(this._characterBatch)
			{
				this._characterBatch.x = offsetX;
				this._characterBatch.y = offsetY;
			}
			super.render(support, parentAlpha);
		}
		
		/**
		 * @inheritDoc
		 */
		public function measureText(result:Point = null):Point
		{
			if(this.isInvalid(INVALIDATION_FLAG_STYLES) || this.isInvalid(INVALIDATION_FLAG_STATE))
			{
				this.refreshTextFormat();
			}

			if(!result)
			{
				result = new Point();
			}
			else
			{
				result.x = result.y = 0;
			}
			if(!this.currentTextFormat || !this._text)
			{
				return result;
			}
			const font:BitmapFont = this.currentTextFormat.font;
			const customSize:Number = this.currentTextFormat.size;
			const customLetterSpacing:Number = this.currentTextFormat.letterSpacing;
			const isKerningEnabled:Boolean = this.currentTextFormat.isKerningEnabled;
			const scale:Number = isNaN(customSize) ? 1 : (customSize / font.size);
			const lineHeight:Number = font.lineHeight * scale;
			const maxLineWidth:Number = !isNaN(this.explicitWidth) ? this.explicitWidth : this._maxWidth;
			const isAligned:Boolean = this.currentTextFormat.align != TextFormatAlign.LEFT;

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
					currentX = Math.max(0, currentX - customLetterSpacing);
					maxX = Math.max(maxX, currentX);
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

				if(isKerningEnabled && !isNaN(previousCharID))
				{
					currentX += charData.getKerning(previousCharID);
				}

				var offsetX:Number = charData.xAdvance * scale;
				if(this._wordWrap)
				{
					var previousCharIsWhitespace:Boolean = previousCharID == CHARACTER_ID_SPACE || previousCharID == CHARACTER_ID_TAB;
					if(charID == CHARACTER_ID_SPACE || charID == CHARACTER_ID_TAB)
					{
						if(!previousCharIsWhitespace)
						{
							widthOfWhitespaceAfterWord = 0;
						}
						widthOfWhitespaceAfterWord += offsetX;
					}
					else if(previousCharIsWhitespace)
					{
						startXOfPreviousWord = currentX;
						wordCountForLine++;
						line += word;
						word = "";
					}

					if(wordCountForLine > 0 && (currentX + offsetX) > maxLineWidth)
					{
						maxX = Math.max(maxX, startXOfPreviousWord - widthOfWhitespaceAfterWord);
						previousCharID = NaN;
						currentX -= startXOfPreviousWord;
						currentY += lineHeight;
						startXOfPreviousWord = 0;
						widthOfWhitespaceAfterWord = 0;
						wordCountForLine = 0;
						line = "";
					}
				}
				currentX += offsetX + customLetterSpacing;
				previousCharID = charID;
				word += String.fromCharCode(charID);
			}
			currentX = Math.max(0, currentX - customLetterSpacing);
			maxX = Math.max(maxX, currentX);

			result.x = maxX;
			result.y = currentY + font.lineHeight * scale;
			return result;
		}
		
		/**
		 * @private
		 */
		override protected function draw():void
		{
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			const sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			const stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);

			if(stylesInvalid || stateInvalid)
			{
				this.refreshTextFormat();
			}

			if(dataInvalid || stylesInvalid || sizeInvalid)
			{
				this.refreshBatching();
				if(!this.currentTextFormat || !this._text)
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
		protected function refreshBatching():void
		{
			this.moveLocationsToPool();
			if(this._useSeparateBatch)
			{
				if(!this._characterBatch)
				{
					this._characterBatch = new QuadBatch();
					this._characterBatch.touchable = false;
					this.addChild(this._characterBatch);
				}
				this._characterBatch.reset();
				this._locations = null;
				if(this._images)
				{
					const imageCount:int = this._images.length;
					for(var i:int = 0; i < imageCount; i++)
					{
						var image:Image = this._images[i];
						image.removeFromParent(true);
					}
				}
				this._images = null;
				this._imagesCache = null;
			}
			else
			{
				if(this._characterBatch)
				{
					this._characterBatch.removeFromParent(true);
					this._characterBatch = null;
				}
				if(!this._locations)
				{
					this._locations = new <CharLocation>[];
				}
				if(!this._images)
				{
					this._images = new <Image>[];
				}
				if(!this._imagesCache)
				{
					this._imagesCache = new <Image>[];
				}
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

			const font:BitmapFont = this.currentTextFormat.font;
			const customSize:Number = this.currentTextFormat.size;
			const customLetterSpacing:Number = this.currentTextFormat.letterSpacing;
			const isKerningEnabled:Boolean = this.currentTextFormat.isKerningEnabled;
			const scale:Number = isNaN(customSize) ? 1 : (customSize / font.size);
			const lineHeight:Number = font.lineHeight * scale;
			const maxLineWidth:Number = !isNaN(this.explicitWidth) ? this.explicitWidth : this._maxWidth;
			const textToDraw:String = this.getTruncatedText();
			const isAligned:Boolean = this.currentTextFormat.align != TextFormatAlign.LEFT;
			CHARACTER_BUFFER.length = 0;

			if(!this._useSeparateBatch)
			{
				//cache the old images for reuse
				const temp:Vector.<Image> = this._imagesCache;
				this._imagesCache = this._images;
				this._images = temp;
			}

			var maxX:Number = 0;
			var currentX:Number = 0;
			var currentY:Number = 0;
			var previousCharID:Number = NaN;
			var isWordComplete:Boolean = false;
			var startXOfPreviousWord:Number = 0;
			var widthOfWhitespaceAfterWord:Number = 0;
			var wordLength:int = 0;
			var wordCountForLine:int = 0;
			const charCount:int = textToDraw ? textToDraw.length : 0;
			for(var i:int = 0; i < charCount; i++)
			{
				isWordComplete = false;
				var charID:int = textToDraw.charCodeAt(i);
				if(charID == CHARACTER_ID_LINE_FEED || charID == CHARACTER_ID_CARRIAGE_RETURN) //new line \n or \r
				{
					currentX = Math.max(0, currentX - customLetterSpacing);
					if(this._wordWrap || isAligned)
					{
						this.alignBuffer(maxLineWidth, currentX, 0);
						this.addBufferToBatch(0);
					}
					maxX = Math.max(maxX, currentX);
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

				if(isKerningEnabled && !isNaN(previousCharID))
				{
					currentX += charData.getKerning(previousCharID);
				}

				var offsetX:Number = charData.xAdvance * scale;
				if(this._wordWrap)
				{
					var previousCharIsWhitespace:Boolean = previousCharID == CHARACTER_ID_SPACE || previousCharID == CHARACTER_ID_TAB;
					if(charID == CHARACTER_ID_SPACE || charID == CHARACTER_ID_TAB)
					{
						if(!previousCharIsWhitespace)
						{
							widthOfWhitespaceAfterWord = 0;
						}
						widthOfWhitespaceAfterWord += offsetX;
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

					if(wordCountForLine > 0 && (currentX + offsetX) > maxLineWidth)
					{
						if(isAligned)
						{
							this.trimBuffer(wordLength);
							this.alignBuffer(maxLineWidth, startXOfPreviousWord - widthOfWhitespaceAfterWord, wordLength);
							this.addBufferToBatch(wordLength);
						}
						this.moveBufferedCharacters(-startXOfPreviousWord, lineHeight, 0);
						maxX = Math.max(maxX, startXOfPreviousWord - widthOfWhitespaceAfterWord);
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
				if(this._wordWrap || isAligned || !this._useSeparateBatch)
				{
					var charLocation:CharLocation = CHAR_LOCATION_POOL.length > 0 ? CHAR_LOCATION_POOL.shift() : new CharLocation();
					charLocation.char = charData;
					charLocation.x = currentX + charData.xOffset * scale;
					charLocation.y = currentY + charData.yOffset * scale;
					charLocation.scale = scale;
					if(this._wordWrap || isAligned)
					{
						CHARACTER_BUFFER.push(charLocation);
						wordLength++;
					}
					else
					{
						this.addLocation(charLocation);
					}
				}
				else
				{
					this.addCharacterToBatch(charData, currentX + charData.xOffset * scale, currentY + charData.yOffset * scale, scale);
				}

				currentX += offsetX + customLetterSpacing;
				previousCharID = charID;
			}
			currentX = Math.max(0, currentX - customLetterSpacing);
			if(this._wordWrap || isAligned)
			{
				this.alignBuffer(maxLineWidth, currentX, 0);
				this.addBufferToBatch(0);
			}
			maxX = Math.max(maxX, currentX);

			if(!this._useSeparateBatch)
			{
				//clear the cache of old images that are no longer needed
				const cacheLength:int = this._imagesCache.length;
				for(i = 0; i < cacheLength; i++)
				{
					var image:Image = this._imagesCache.shift();
					image.removeFromParent(true);
				}
			}

			result.x = maxX;
			result.y = currentY + font.lineHeight * scale;
			return result;
		}

		/**
		 * @private
		 */
		protected function trimBuffer(skipCount:int):void
		{
			var countToRemove:int = 0;
			const charCount:int = CHARACTER_BUFFER.length - skipCount;
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
			const align:String = this.currentTextFormat.align;
			if(align == TextFormatAlign.CENTER)
			{
				this.moveBufferedCharacters((maxLineWidth - currentLineWidth) / 2, 0, skipCount);
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
			const charCount:int = CHARACTER_BUFFER.length - skipCount;
			for(var i:int = 0; i < charCount; i++)
			{
				var charLocation:CharLocation = CHARACTER_BUFFER.shift();
				if(this._useSeparateBatch)
				{
					this.addCharacterToBatch(charLocation.char, charLocation.x, charLocation.y, charLocation.scale);
					charLocation.char = null;
					CHAR_LOCATION_POOL.push(charLocation);
				}
				else
				{
					this.addLocation(charLocation);
				}
			}
		}

		/**
		 * @private
		 */
		protected function addLocation(location:CharLocation):void
		{
			var image:Image;
			const charData:BitmapChar = location.char;
			const texture:Texture = charData.texture;
			if(this._imagesCache.length > 0)
			{
				image = this._imagesCache.shift();
				image.texture = texture;
				image.readjustSize();
			}
			else
			{
				image = new Image(texture);
				this.addChild(image);
			}
			image.scaleX = image.scaleY = location.scale;
			image.smoothing = this._smoothing;
			image.color = this.currentTextFormat.color;
			this._images.push(image);
			this._locations.push(location);
		}

		/**
		 * @private
		 */
		protected function moveBufferedCharacters(xOffset:Number, yOffset:Number, skipCount:int):void
		{
			const charCount:int = CHARACTER_BUFFER.length - skipCount;
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
		protected function addCharacterToBatch(charData:BitmapChar, x:Number, y:Number, scale:Number, support:RenderSupport = null, parentAlpha:Number = 1):void
		{
			if(!HELPER_IMAGE)
			{
				HELPER_IMAGE = new Image(charData.texture);
			}
			else
			{
				HELPER_IMAGE.texture = charData.texture;
				HELPER_IMAGE.readjustSize();
			}
			HELPER_IMAGE.scaleX = HELPER_IMAGE.scaleY = scale;
			HELPER_IMAGE.x = x;
			HELPER_IMAGE.y = y;
			HELPER_IMAGE.color = this.currentTextFormat.color;
			HELPER_IMAGE.smoothing = this._smoothing;

			if(support)
			{
				support.pushMatrix();
				support.transformMatrix(HELPER_IMAGE);
				support.batchQuad(HELPER_IMAGE, parentAlpha, HELPER_IMAGE.texture, this._smoothing);
				support.popMatrix();
			}
			else
			{
				this._characterBatch.addImage(HELPER_IMAGE);
			}
		}

		/**
		 * @private
		 */
		protected function refreshTextFormat():void
		{
			if(!this._isEnabled && this._disabledTextFormat)
			{
				this.currentTextFormat = this._disabledTextFormat;
			}
			else
			{
				this.currentTextFormat = this._textFormat;
			}
		}

		/**
		 * @private
		 */
		protected function getTruncatedText():String
		{
			if(!this._text)
			{
				//this shouldn't be called if _text is null, but just in case...
				return "";
			}
			//if the maxWidth is infinity or the string is multiline, don't
			//allow truncation
			if(this._maxWidth == Number.POSITIVE_INFINITY || this._wordWrap || this._text.indexOf(String.fromCharCode(CHARACTER_ID_LINE_FEED)) >= 0 || this._text.indexOf(String.fromCharCode(CHARACTER_ID_CARRIAGE_RETURN)) >= 0)
			{
				return this._text;
			}

			const font:BitmapFont = this.currentTextFormat.font;
			const customSize:Number = this.currentTextFormat.size;
			const customLetterSpacing:Number = this.currentTextFormat.letterSpacing;
			const isKerningEnabled:Boolean = this.currentTextFormat.isKerningEnabled;
			const scale:Number = isNaN(customSize) ? 1 : (customSize / font.size);
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
				if(isKerningEnabled && !isNaN(previousCharID))
				{
					currentKerning = charData.getKerning(previousCharID);
				}
				currentX += currentKerning + charData.xAdvance * scale;
				if(currentX > this._maxWidth)
				{
					truncationIndex = i;
					break;
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
					if(isKerningEnabled && !isNaN(previousCharID))
					{
						currentKerning = charData.getKerning(previousCharID);
					}
					currentX += currentKerning + charData.xAdvance * scale + customLetterSpacing;
					previousCharID = charID;
				}
				currentX -= customLetterSpacing;

				//then work our way backwards until we fit into the maxWidth
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
					if(isKerningEnabled && !isNaN(previousCharID))
					{
						currentKerning = charData.getKerning(previousCharID);
					}
					currentX -= (currentKerning + charData.xAdvance * scale + customLetterSpacing);
					if(currentX <= this._maxWidth)
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
		protected function moveLocationsToPool():void
		{
			if(!this._locations)
			{
				return;
			}
			const locationCount:int = this._locations.length;
			for(var i:int = 0; i < locationCount; i++)
			{
				var location:CharLocation = this._locations.shift();
				location.char = null;
				CHAR_LOCATION_POOL.push(location);
			}
		}
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