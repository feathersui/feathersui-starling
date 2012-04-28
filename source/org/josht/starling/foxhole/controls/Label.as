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
package org.josht.starling.foxhole.controls
{
	import flash.geom.Matrix;

	import org.josht.starling.foxhole.core.FoxholeControl;
	import org.josht.starling.foxhole.text.BitmapFontTextFormat;

	import starling.core.RenderSupport;
	import starling.display.Image;
	import starling.display.QuadBatch;
	import starling.text.BitmapChar;
	import starling.text.BitmapFont;
	import starling.textures.TextureSmoothing;

	/**
	 * Displays a single-line of text. Cannot be clipped.
	 */
	public class Label extends FoxholeControl
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
		public function Label()
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
		private var _textFormat:BitmapFontTextFormat;
		
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
		 * A smoothing value passed to each character.
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

		private var _snapToPixels:Boolean = true;

		public function get snapToPixels():Boolean
		{
			return _snapToPixels;
		}

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
		override public function render(support:RenderSupport, alpha:Number):void
		{
			if(this._snapToPixels)
			{
				this.getTransformationMatrix(this.stage, helperMatrix);
				this._characterBatch.x = Math.round(helperMatrix.tx) - helperMatrix.tx;
				this._characterBatch.y = Math.round(helperMatrix.ty) - helperMatrix.ty;
			}
			else
			{
				this._characterBatch.x = this._characterBatch.y = 0;
			}
			super.render(support, alpha);
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
			
			if(dataInvalid || stylesInvalid)
			{
				this._characterBatch.reset();
				if(!this._textFormat)
				{
					this.setSizeInternal(0, 0, false);
					return;
				}
				const font:BitmapFont = this._textFormat.font;
				const customSize:Number = this._textFormat.size;
				const customLetterSpacing:Number = this._textFormat.letterSpacing;
				const isKerningEnabled:Boolean = this._textFormat.isKerningEnabled;
				const scale:Number = isNaN(customSize) ? 1 : (customSize / font.size);
				const color:uint = this._textFormat.color;

				var currentX:Number = 0;
				var maxY:Number = 0;
				var lastCharID:Number = NaN;
				var characterIndex:int = 0;
				const charCount:int = this._text.length;
				for(var i:int = 0; i < charCount; i++)
				{
					var charID:Number = this._text.charCodeAt(i);
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
					}
					else
					{
						helperImage.texture = charData.texture;
					}
					helperImage.readjustSize();
					helperImage.scaleX = helperImage.scaleY = scale;
					helperImage.x = currentX + charData.xOffset * scale;
					if(this._snapToPixels)
					{
						helperImage.x = Math.round(helperImage.x);
						helperImage.y = Math.round(helperImage.y);
					}
					helperImage.y = charData.yOffset * scale;
					helperImage.color = color;
					helperImage.smoothing = this._smoothing;

					currentX += charData.xAdvance * scale + customLetterSpacing;
					maxY = Math.max(maxY, helperImage.y + helperImage.height);
					lastCharID = charID;
					characterIndex++;

					this._characterBatch.addImage(helperImage);
				}
				this.setSizeInternal(currentX, Math.max(maxY, font.lineHeight * scale), false);
			}
		}
	}
}