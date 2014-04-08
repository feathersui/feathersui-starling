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
	import starling.core.Starling;
	import starling.events.Event;
	import starling.utils.AssetManager;

	[Event(name="complete",type="starling.events.Event")]

	/**
	 * The "Metal Works" theme for mobile Feathers apps.
	 *
	 * <p>This version of the theme requires loading assets at runtime. To use
	 * embedded assets, see <code>MetalWorksMobileTheme</code> instead.</p>
	 *
	 * <p>To use this theme, the following files must be included when packaging
	 * your app:</p>
	 * <ul>
	 *     <li>images/metalworks.png</li>
	 *     <li>images/metalworks.xml</li>
	 * </ul>
	 *
	 * @see http://wiki.starling-framework.org/feathers/theme-assets
	 */
	public class MetalWorksMobileThemeWithAssetManager extends BaseMetalWorksMobileTheme
	{
		public function MetalWorksMobileThemeWithAssetManager(assetsBasePath:String = null, assetManager:AssetManager = null)
		{
			this.loadAssets(assetsBasePath, assetManager);
		}

		protected var assetPaths:Vector.<String> = new <String>
		[
			"images/metalworks.xml",
			"images/metalworks.png"
		];

		protected var assetManager:AssetManager;

		override public function dispose():void
		{
			super.dispose();
			if(this.assetManager)
			{
				this.assetManager.removeTextureAtlas(ATLAS_NAME);
				this.assetManager = null;
			}
		}

		override protected function initialize():void
		{
			this.atlas = this.assetManager.getTextureAtlas(ATLAS_NAME);
			super.initialize();
		}

		protected function assetManager_onProgress(progress:Number):void
		{
			if(progress < 1)
			{
				return;
			}
			this.initialize();
			this.dispatchEventWith(Event.COMPLETE);
		}

		protected function loadAssets(assetsBasePath:String, assetManager:AssetManager):void
		{
			this.assetManager = assetManager;
			if(!this.assetManager)
			{
				this.assetManager = new AssetManager(Starling.contentScaleFactor);
			}
			//add a trailing slash, if needed
			if(assetsBasePath.lastIndexOf("/") != assetsBasePath.length - 1)
			{
				assetsBasePath += "/";
			}
			var assetPaths:Vector.<String> = this.assetPaths;
			var assetCount:int = assetPaths.length;
			for(var i:int = 0; i < assetCount; i++)
			{
				var asset:String = assetPaths[i];
				this.assetManager.enqueue(assetsBasePath + asset);
			}
			this.assetManager.loadQueue(assetManager_onProgress);
		}
	}
}
