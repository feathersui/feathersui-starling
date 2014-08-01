/*
 Copyright (c) 2014 Josh Tynjala

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
package feathers.themes
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	/**
	 * The "Minimal" theme for mobile Feathers apps.
	 *
	 * <p>This version of the theme embeds its assets. To load assets at
	 * runtime, see <code>MinimalMobileThemeWithAssetManager</code> instead.</p>
	 *
	 * @see http://wiki.starling-framework.org/feathers/theme-assets
	 */
	public class MinimalMobileTheme extends BaseMinimalMobileTheme
	{
		/**
		 * @private
		 */
		[Embed(source="/../assets/images/minimal_mobile.xml",mimeType="application/octet-stream")]
		protected static const ATLAS_XML:Class;

		/**
		 * @private
		 */
		[Embed(source="/../assets/images/minimal_mobile.png")]
		protected static const ATLAS_BITMAP:Class;

		/**
		 * @private
		 */
		[Embed(source="/../assets/fonts/pf_ronda_seven.fnt",mimeType="application/octet-stream")]
		protected static const FONT_XML:Class;

		/**
		 * Constructor.
		 */
		public function MinimalMobileTheme(scaleToDPI:Boolean = true)
		{
			super(scaleToDPI);
			this.initialize();
		}

		/**
		 * @private
		 */
		override protected function initialize():void
		{
			var atlasBitmapData:BitmapData = Bitmap(new ATLAS_BITMAP()).bitmapData;
			var atlasTexture:Texture = Texture.fromBitmapData(atlasBitmapData, false);
			atlasTexture.root.onRestore = this.atlasTexture_onRestore;
			atlasBitmapData.dispose();
			this.atlas = new TextureAtlas(atlasTexture, XML(new ATLAS_XML()));

			var bitmapFont:BitmapFont = new BitmapFont(this.atlas.getTexture(FONT_TEXTURE_NAME), XML(new FONT_XML()));
			TextField.registerBitmapFont(bitmapFont, FONT_NAME);

			super.initialize();
		}

		/**
		 * @private
		 */
		protected function atlasTexture_onRestore():void
		{
			var atlasBitmapData:BitmapData = Bitmap(new ATLAS_BITMAP()).bitmapData;
			this.atlas.texture.root.uploadBitmapData(atlasBitmapData);
			atlasBitmapData.dispose();
		}
	}
}