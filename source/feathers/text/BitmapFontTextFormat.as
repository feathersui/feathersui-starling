/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

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
	 *
	 * @productversion Feathers 1.0.0
	 */
	public class BitmapFontTextFormat
	{
		/**
		 * Constructor.
		 */
		public function BitmapFontTextFormat(font:Object, size:Number = NaN, color:uint = 0xffffff, align:String = TextFormatAlign.LEFT, leading : Number = 0)
		{
			if(font is String)
			{
				font = TextField.getBitmapFont(font as String);
			}
			if(!(font is BitmapFont))
			{
				throw new ArgumentError("BitmapFontTextFormat font must be a BitmapFont instance or a String representing the name of a registered bitmap font.");
			}
			this.font = BitmapFont(font);
			this.size = size;
			this.color = color;
			this.align = align;
			this.leading = leading;
		}

		/**
		 * The name of the font.
		 */
		public function get fontName():String
		{
			return this.font ? this.font.name : null;
		}
		
		/**
		 * The BitmapFont instance to use.
		 */
		public var font:BitmapFont;
		
		/**
		 * The color used to tint the bitmap font's texture when rendered.
		 * Tinting works like the "multiply" blend mode. In other words, the
		 * <code>color</code> property can only make the text render with a
		 * darker color. With that in mind, if the characters in the original
		 * texture are black, then you cannot change their color at all. To be
		 * able to render the text using any color, the characters in the
		 * original texture should be white.
		 *
		 * @default 0xffffff
		 *
		 * @see http://doc.starling-framework.org/core/starling/display/BlendMode.html#MULTIPLY starling.display.BlendMode.MULTIPLY
		 */
		public var color:uint;
		
		/**
		 * The size at which to display the bitmap font. Set to <code>NaN</code>
		 * to use the default size in the BitmapFont instance.
		 *
		 * @default NaN
		 */
		public var size:Number;
		
		/**
		 * The number of extra pixels between characters. May be positive or
		 * negative.
		 *
		 * @default 0
		 */
		public var letterSpacing:Number = 0;

		[Inspectable(type="String",enumeration="left,center,right")]
		/**
		 * Determines the alignment of the text, either left, center, or right.
		 *
		 * @default flash.text.TextFormatAlign.LEFT
		 */
		public var align:String = TextFormatAlign.LEFT;

		/**
		 * A number representing the amount of vertical space (called leading)
		 * between lines. The total vertical distance between lines is this
		 * value added to the BitmapFont instance's lineHeight property.
		 *
		 * @default 0
		 */
		public var leading:Number;

		/**
		 * Determines if the kerning values defined in the BitmapFont instance
		 * will be used for layout.
		 *
		 * @default true
		 */
		public var isKerningEnabled:Boolean = true;
	}
}