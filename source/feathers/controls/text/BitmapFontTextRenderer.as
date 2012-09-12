/*
Copyright (c) 2012 Josh Tynjala

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
*/
package feathers.controls.text
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import feathers.core.FeathersControl;
	import feathers.core.ITextRenderer;
	import feathers.text.BitmapFontTextFormat;

	import starling.core.RenderSupport;
	import starling.display.Image;
	import starling.display.QuadBatch;
	import starling.text.BitmapChar;
	import starling.text.BitmapFont;
	import starling.textures.TextureSmoothing;

	/**
	 * Renders text using <code>starling.text.BitmapFont</code>.
	 * 
	 * @see starling.text.BitmapFont
	 */
	public class BitmapFontTextRenderer extends FeathersControl implements ITextRenderer
	{
		/**
		 * @private
		 */
		private static var helperImage:Image;

		/**
		 * @private
		 */
		private static const helperMatrix:Matrix = new Matrix();

		/**
		 * Constructor.
		 */
		public function BitmapFontTextRenderer()
		{
			this.isQuickHitAreaEnabled = true;
		}

		/**
		 * @private
		 */
		private var _characterBatch:QuadBatch;

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
		private var _text:String = "";
		
		/**
		 * The text to display.
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
		private var _smoothing:String = TextureSmoothing.BILINEAR;
		
		/**
		 * A smoothing value passed to each character image.
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
		private var _snapToPixels:Boolean = true;

		/**
		 * Determines if characters should be snapped to the nearest whole pixel
		 * when rendered.
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
		private var _truncationText:String = "...";

		/**
		 * The text to display at the end of the label if it is truncated.
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
			this.invalidate(INVALIDATION_FLAG_DATA,  INVALIDATION_FLAG_SIZE);
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
			return font.baseline * fontSizeScale;
		}

		/**
		 * @private
		 */
		override public function render(support:RenderSupport, alpha:Number):void
		{
			if(this._snapToPixels)
			{
				this.getTransformationMatrix(this.stage, helperMatrix);
				this._characterBatch.x = Math.round(helperMatrix.tx) - helperMatrix.tx;
				this._characterBatch.y = Math.round(helperMatrix.ty) - helperMatrix.ty;
				const scrollRect:Rectangle = this.scrollRect;
				if(scrollRect)
				{
					this._characterBatch.x += Math.round(scrollRect.x) - scrollRect.x;
					this._characterBatch.y += Math.round(scrollRect.y) - scrollRect.y;
				}
			}
			else
			{
				this._characterBatch.x = this._characterBatch.y = 0;
			}
			super.render(support, alpha);
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
			if(!this.currentTextFormat)
			{
				return result;
			}
			const font:BitmapFont = this.currentTextFormat.font;
			const customSize:Number = this.currentTextFormat.size;
			const customLetterSpacing:Number = this.currentTextFormat.letterSpacing;
			const isKerningEnabled:Boolean = this.currentTextFormat.isKerningEnabled;
			const scale:Number = isNaN(customSize) ? 1 : (customSize / font.size);
			const color:uint = this.currentTextFormat.color;
			const lineHeight:Number = font.lineHeight * scale;
			
			var maxX:Number = 0;
			var currentX:Number = 0;
			var currentY:Number = 0;
			var lastCharID:Number = NaN;
			var charCount:int = this._text ? this._text.length : 0;
			for(var i:int = 0; i < charCount; i++)
			{
				var charID:int = this._text.charCodeAt(i);
				if(charID == 10 || charID == 13) //new line \n or \r
				{
					currentX = Math.max(0, currentX - customLetterSpacing);
					maxX = Math.max(maxX, currentX);
					lastCharID = NaN;
					currentX = 0;
					currentY += lineHeight;
					continue;
				}
				var charData:BitmapChar = font.getChar(charID);
				if(!charData)
				{
					trace("Missing character " + String.fromCharCode(charID) + " in font " + font.name + ".");
					continue;
				}
				
				if(isKerningEnabled && !isNaN(lastCharID))
				{
					currentX += charData.getKerning(lastCharID);
				}
				
				currentX += charData.xAdvance * scale + customLetterSpacing;
				lastCharID = charID;
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
		override protected function initialize():void
		{
			this._characterBatch = new QuadBatch();
			this._characterBatch.touchable = false;
			this.addChild(this._characterBatch);
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
				this._characterBatch.reset();
				if(!this.currentTextFormat)
				{
					this.setSizeInternal(0, 0, false);
					return;
				}
				const font:BitmapFont = this.currentTextFormat.font;
				const customSize:Number = this.currentTextFormat.size;
				const customLetterSpacing:Number = this.currentTextFormat.letterSpacing;
				const isKerningEnabled:Boolean = this.currentTextFormat.isKerningEnabled;
				const scale:Number = isNaN(customSize) ? 1 : (customSize / font.size);
				const color:uint = this.currentTextFormat.color;
				const lineHeight:Number = font.lineHeight * scale;

				var maxX:Number = 0;
				var currentX:Number = 0;
				var currentY:Number = 0;
				var lastCharID:Number = NaN;
				var textToDraw:String = this.getTruncatedText();
				if(helperImage)
				{
					helperImage.color = color;
					helperImage.smoothing = this._smoothing;
				}
				const charCount:int = textToDraw ? textToDraw.length : 0;
				for(var i:int = 0; i < charCount; i++)
				{
					var charID:int = textToDraw.charCodeAt(i);
					if(charID == 10 || charID == 13) //new line \n or \r
					{
						currentX = Math.max(0, currentX - customLetterSpacing);
						maxX = Math.max(maxX, currentX);
						lastCharID = NaN;
						currentX = 0;
						currentY += lineHeight;
						continue;
					}
					var charData:BitmapChar = font.getChar(charID);
					if(!charData)
					{
						trace("Missing character " + String.fromCharCode(charID) + " in font " + font.name + ".");
						continue;
					}

					if(isKerningEnabled && !isNaN(lastCharID))
					{
						currentX += charData.getKerning(lastCharID);
					}

					if(!helperImage)
					{
						helperImage = new Image(charData.texture);
						helperImage.color = color;
						helperImage.smoothing = this._smoothing;
					}
					else
					{
						helperImage.texture = charData.texture;
					}
					helperImage.readjustSize();
					helperImage.scaleX = helperImage.scaleY = scale;
					helperImage.x = currentX + charData.xOffset * scale;
					helperImage.y = currentY + charData.yOffset * scale;
					if(this._snapToPixels)
					{
						helperImage.x = Math.round(helperImage.x);
						helperImage.y = Math.round(helperImage.y);
					}
					helperImage.color = color;
					helperImage.smoothing = this._smoothing;

					currentX += charData.xAdvance * scale + customLetterSpacing;
					lastCharID = charID;

					this._characterBatch.addImage(helperImage);
				}
				currentX = Math.max(0, currentX - customLetterSpacing);
				maxX = Math.max(maxX, currentX);
				this.setSizeInternal(maxX, currentY + font.lineHeight * scale, false);
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
			//if the maxWidth is infinity or the string is multiline, don't
			//allow truncation
			if(this._maxWidth == Number.POSITIVE_INFINITY || this._text.indexOf(String.fromCharCode(10)) >= 0 || this._text.indexOf(String.fromCharCode(13)) >= 0)
			{
				return this._text;
			}

			const font:BitmapFont = this.currentTextFormat.font;
			const customSize:Number = this.currentTextFormat.size;
			const customLetterSpacing:Number = this.currentTextFormat.letterSpacing;
			const isKerningEnabled:Boolean = this.currentTextFormat.isKerningEnabled;
			const scale:Number = isNaN(customSize) ? 1 : (customSize / font.size);
			var currentX:Number = 0;
			var lastCharID:Number = NaN;
			var charCount:int = this._text ? this._text.length : 0;
			var isTruncated:Boolean = false;
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
				if(isKerningEnabled && !isNaN(lastCharID))
				{
					currentKerning = charData.getKerning(lastCharID);
				}
				currentX += currentKerning + charData.xAdvance * scale;
				if(currentX > this._maxWidth)
				{
					truncationIndex = i;
					break;
				}
				currentX += customLetterSpacing;
				lastCharID = charID;
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
					if(isKerningEnabled && !isNaN(lastCharID))
					{
						currentKerning = charData.getKerning(lastCharID);
					}
					currentX += currentKerning + charData.xAdvance * scale + customLetterSpacing;
					lastCharID = charID;
				}
				currentX -= customLetterSpacing;

				//then work our way backwards until we fit into the maxWidth
				for(i = truncationIndex; i >= 0; i--)
				{
					charID = this._text.charCodeAt(i);
					lastCharID = i > 0 ? this._text.charCodeAt(i - 1) : NaN;
					charData = font.getChar(charID);
					if(!charData)
					{
						continue;
					}
					currentKerning = 0;
					if(isKerningEnabled && !isNaN(lastCharID))
					{
						currentKerning = charData.getKerning(lastCharID);
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
	}
}