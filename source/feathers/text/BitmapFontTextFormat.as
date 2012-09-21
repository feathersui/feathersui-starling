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
package feathers.text
{
	import starling.text.BitmapFont;
	import starling.text.TextField;

	/**
	 * Customizes a bitmap font for use by a <code>BitmapFontTextRenderer</code>.
	 * 
	 * @see feathers.controls.text.BitmapFontTextRenderer
	 */
	public class BitmapFontTextFormat
	{
		/**
		 * Constructor.
		 */
		public function BitmapFontTextFormat(font:Object, size:Number = NaN, color:uint = 0xffffff)
		{
			if(font is String)
			{
				font = TextField.getBitmapFont(font as String);
			}
			if(!(font is BitmapFont))
			{
				throw new ArgumentError("BitmapFontTextFormat font must be a String or a BitmapFont instance.")
			}
			this.font = BitmapFont(font);
			this.size = size;
			this.color = color;
		}

		public function get fontName():String
		{
			return this.font ? this.font.name : null;
		}
		
		/**
		 * The BitmapFont instance to use.
		 */
		public var font:BitmapFont;
		
		/**
		 * The multiply color.
		 */
		public var color:uint;
		
		/**
		 * The size at which to display the bitmap font. Set to <code>NaN</code>
		 * to use the default size in the BitmapFont instance.
		 */
		public var size:Number;
		
		/**
		 * The number of extra pixels between characters. May be positive or
		 * negative.
		 */
		public var letterSpacing:Number = 0;
		
		/**
		 * Determines if the kerning values defined in the BitmapFont instance
		 * will be used for layout.
		 */
		public var isKerningEnabled:Boolean = true;
	}
}