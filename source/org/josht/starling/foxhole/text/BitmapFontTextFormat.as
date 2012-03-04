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
	import flash.system.System;
	
	import org.josht.starling.foxhole.core.FoxholeControl;
	import org.josht.starling.foxhole.text.BitmapFontTextFormat;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.text.BitmapChar;
	import starling.text.BitmapFont;
	import starling.textures.TextureSmoothing;

	/**
	 * Displays a single-line of text. Cannot be clipped.
	 */
	public class Label extends FoxholeControl
	{
		public function Label()
		{
			this.touchable = false;
		}
		
		private var _isLayoutInvalid:Boolean = false;
		private var _isTextOrFontInvalid:Boolean = false;
		
		private var _lastFont:BitmapFont;
		private var _lastColor:uint = uint.MAX_VALUE;
		
		private var _textFormat:BitmapFontTextFormat;

		public function get textFormat():BitmapFontTextFormat
		{
			return this._textFormat;
		}

		public function set textFormat(value:BitmapFontTextFormat):void
		{
			this._textFormat = value;
			if(this._textFormat)
			{
				if(this._textFormat.font != this._lastFont || (this._textFormat.color == uint.MAX_VALUE && this._lastColor != uint.MAX_VALUE))
				{
					this._isTextOrFontInvalid = true;
				}
				this._lastFont = this._textFormat.font;
				this._lastColor = this._textFormat.color;
			}
			this._isLayoutInvalid = true;
			super.invalidate();
		}
		
		private var _text:String = "";

		public function get text():String
		{
			return this._text;
		}

		public function set text(value:String):void
		{
			if(this._text == value)
			{
				return;
			}
			this._text = value;
			this._isTextOrFontInvalid = true;
			this._isLayoutInvalid = true;
			super.invalidate();
		}

		private var _characters:Vector.<Image> = new <Image>[];
		
		override public function invalidate(...rest:Array):void
		{
			this._isTextOrFontInvalid = true;
			this._isLayoutInvalid = true;
			super.invalidate.apply(this, rest);
		}
		
		override public function dispose():void
		{
			this._lastFont = null;
			super.dispose();
		}
		
		override protected function draw():void
		{
			this.rebuildCharacters();
			if(this._textFormat)
			{
				var color:uint = this._textFormat.color;
				if(color != uint.MAX_VALUE)
				{
					for each(var charDisplay:Image in this._characters)
					{
						charDisplay.color = color;
					}
				}
			}
			this.layout();
			
			this._isLayoutInvalid = false;
			this._isTextOrFontInvalid = false;
		}
		
		private function rebuildCharacters():void
		{
			if(!this._isTextOrFontInvalid)
			{
				return;
			}
			while(this._characters.length > 0)
			{
				var charDisplay:Image = this._characters.shift();
				this.removeChild(charDisplay);
			}
			
			if(!this._textFormat)
			{
				return;
			}
			
			const font:BitmapFont = this._textFormat.font;
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
				charDisplay = charData.createImage();
				charDisplay.touchable = false;
				this.addChild(charDisplay);
				this._characters.push(charDisplay);
			}
		}
	
		private function layout():void
		{
			if(!this._isLayoutInvalid || !this._textFormat)
			{
				return;
			}
			const font:BitmapFont = this._textFormat.font;
			const customSize:Number = this._textFormat.size;
			const customLetterSpacing:Number = this._textFormat.letterSpacing;
			const isKerningEnabled:Boolean = this._textFormat.isKerningEnabled;
			const scale:Number = isNaN(customSize) ? 1 : (customSize / font.size);
			
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
					continue;
				}
				if(isKerningEnabled && !isNaN(lastCharID))
				{
					currentX += charData.getKerning(lastCharID);
				}
				var charDisplay:Image = this._characters[characterIndex];
				charDisplay.scaleX = charDisplay.scaleY = scale;
				charDisplay.x = currentX + charData.xOffset * scale;
				charDisplay.y = charData.yOffset * scale;
				
				currentX += charData.xAdvance * scale + customLetterSpacing;
				maxY = Math.max(maxY, charDisplay.y + charDisplay.height);
				lastCharID = charID;
				characterIndex++;
			}
		
			this._width = currentX;
			this._height = Math.max(maxY, font.lineHeight * scale);
	
		}
	}
}