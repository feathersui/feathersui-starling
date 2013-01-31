/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.text
{
	import flash.text.TextFormatAlign;

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
		public function BitmapFontTextFormat(font:Object, size:Number = NaN, color:uint = 0xffffff, align:String = TextFormatAlign.LEFT)
		{
			if(font is String)
			{
				font = TextField.getBitmapFont(font as String);
			}
			if(!(font is BitmapFont))
			{
				throw new ArgumentError("BitmapFontTextFormat font must be a String or a BitmapFont instance.");
			}
			this.font = BitmapFont(font);
			this.size = size;
			this.color = color;
			this.align = align;
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

		[Inspectable(type="String",enumeration="left,center,right")]
		/**
		 * Determines the alignment of the text, either left, center, or right.
		 */
		public var align:String = TextFormatAlign.LEFT;
		
		/**
		 * Determines if the kerning values defined in the BitmapFont instance
		 * will be used for layout.
		 */
		public var isKerningEnabled:Boolean = true;
	}
}