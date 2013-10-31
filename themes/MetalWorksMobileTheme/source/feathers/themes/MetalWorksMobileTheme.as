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
package feathers.themes
{
	import starling.display.DisplayObjectContainer;

	public class MetalWorksMobileTheme extends MetalWorksMobileThemeWithAssetManager
	{
		[Embed(source="/../assets/images/metalworks.xml",mimeType="application/octet-stream")]
		public static const metalworks_xml:Class;

		[Embed(source="/../assets/images/metalworks.png")]
		public static const metalworks:Class;

		public function MetalWorksMobileTheme(container:DisplayObjectContainer = null, scaleToDPI:Boolean = true)
		{
			super(null, null, container, scaleToDPI);
		}

		override protected function get atlasImageClass():Class
		{
			return metalworks;
		}

		override protected function get atlasXMLClass():Class
		{
			return metalworks_xml;
		}
	}
}
