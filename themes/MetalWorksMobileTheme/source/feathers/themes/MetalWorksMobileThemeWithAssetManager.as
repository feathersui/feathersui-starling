/*
Copyright 2012-2015 Bowler Hat LLC

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

	/**
	 * @copy feathers.themes.IAsyncTheme#event:complete
	 *
	 * @eventType starling.events.Event.COMPLETE
	 */
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
	 *     <li>images/metalworks_mobile.png</li>
	 *     <li>images/metalworks_mobile.xml</li>
	 * </ul>
	 *
	 * @see http://feathersui.com/help/theme-assets.html
	 */
	public class MetalWorksMobileThemeWithAssetManager extends BaseMetalWorksMobileTheme implements IAsyncTheme
	{
		/**
		 * @private
		 * The name of the texture atlas in the asset manager.
		 */
		protected static const ATLAS_NAME:String = "metalworks_mobile";

		/**
		 * Constructor.
		 * @param assetsBasePath The root folder of the assets.
		 * @param assetManager An optional pre-created AssetManager. The scaleFactor property must be equal to Starling.contentScaleFactor. To load assets with a different scale factor, use multiple AssetManager instances.
		 */
		public function MetalWorksMobileThemeWithAssetManager(assetsBasePath:String = "./", assetManager:AssetManager = null)
		{
			this.loadAssets(assetsBasePath, assetManager);
		}

		/**
		 * @private
		 * The paths to each of the assets, relative to the base path.
		 */
		protected var assetPaths:Vector.<String> = new <String>
		[
			"images/" + ATLAS_NAME + ".xml",
			"images/" + ATLAS_NAME + ".png"
		];

		/**
		 * @private
		 */
		protected var assetManager:AssetManager;

		/**
		 * @private
		 */
		protected var isComplete:Boolean = false;

		/**
		 * @private
		 */
		override public function dispose():void
		{
			super.dispose();
			if(this.assetManager)
			{
				this.assetManager.removeTextureAtlas(ATLAS_NAME);
				this.assetManager = null;
			}
		}

		/**
		 * @copy feathers.themes.IAsyncTheme#isCompleteForStarling()
		 */
		public function isCompleteForStarling(starling:Starling):Boolean
		{
			return this.isComplete;
		}

		/**
		 * @private
		 */
		override protected function initialize():void
		{
			this.initializeTextureAtlas();
			super.initialize();
		}

		/**
		 * @private
		 */
		protected function initializeTextureAtlas():void
		{
			this.atlas = this.assetManager.getTextureAtlas(ATLAS_NAME);
		}

		/**
		 * @private
		 */
		protected function assetManager_onProgress(progress:Number):void
		{
			if(progress < 1)
			{
				return;
			}
			this.initialize();
			this.isComplete = true;
			this.dispatchEventWith(Event.COMPLETE, false, Starling.current);
		}

		/**
		 * @private
		 */
		protected function loadAssets(assetsBasePath:String, assetManager:AssetManager):void
		{
			var oldScaleFactor:Number = -1;
			if(assetManager)
			{
				oldScaleFactor = assetManager.scaleFactor;
				assetManager.scaleFactor = 1;
			}
			else
			{
				assetManager = new AssetManager();
			}
			this.assetManager = assetManager;
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
			if(oldScaleFactor != -1)
			{
				//restore the old scale factor, just in case
				this.assetManager.scaleFactor = oldScaleFactor;
			}
			this.assetManager.loadQueue(assetManager_onProgress);
		}
	}
}
