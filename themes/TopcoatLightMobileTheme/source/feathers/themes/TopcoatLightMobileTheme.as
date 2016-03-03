/*
Copyright 2012-2016 Bowler Hat LLC, Marcel Piestansky

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

	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	/**
	 * The "Topcoat Light" theme for mobile Feathers apps.
	 *
	 * <p>This version of the theme embeds its assets. To load assets at
	 * runtime, see <code>TopcoatLightMobileThemeWithAssetManager</code> instead.</p>
	 *
	 * @see http://feathersui.com/help/theme-assets.html
	 */
	public class TopcoatLightMobileTheme extends BaseTopcoatLightMobileTheme
	{
		[Embed(source="/../assets/images/topcoat_light_mobile.xml", mimeType="application/octet-stream")]
		private static const ATLAS_XML:Class;
		
		[Embed(source="/../assets/images/topcoat_light_mobile.png")]
		private static const ATLAS_BITMAP:Class;

		public function TopcoatLightMobileTheme()
		{
			super();
			this.initialize();
		}

		override protected function initialize():void
		{
			this.initializeTextureAtlas();
			super.initialize();
		}

		protected function initializeTextureAtlas():void
		{
			var atlasBitmapData:BitmapData = Bitmap(new ATLAS_BITMAP()).bitmapData;
			var atlasTexture:Texture = Texture.fromBitmapData(atlasBitmapData, false, false, 2);
			atlasTexture.root.onRestore = onAtlasTextureRestore;
			atlasBitmapData.dispose();
			this.atlas = new TextureAtlas(atlasTexture, XML(new ATLAS_XML()));
		}

		private function onAtlasTextureRestore():void
		{
			var atlasBitmapData:BitmapData = Bitmap(new ATLAS_BITMAP()).bitmapData;
			this.atlas.texture.root.uploadBitmapData(atlasBitmapData);
			atlasBitmapData.dispose();
		}

	}

}
