package feathers.tests
{
	import feathers.controls.ImageLoader;
	import feathers.utils.textures.TextureCache;

	import flash.geom.Rectangle;

	import org.flexunit.Assert;
	import org.flexunit.async.Async;

	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.ScaleMode;

	public class ImageLoaderTests
	{
		private var _loader:ImageLoader;
		private var _texture:Texture;

		[Before]
		public function prepare():void
		{
			this._loader = new ImageLoader();
			TestFeathers.starlingRoot.addChild(this._loader);
			this._loader.validate();
		}

		[After]
		public function cleanup():void
		{
			this._loader.removeFromParent(true);
			this._loader = null;
			
			if(this._texture !== null)
			{
				this._texture.dispose();
				this._texture = null;
			}

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test(async)]
		public function testCompleteEvent():void
		{
			var completeDispatched:Boolean = false;
			this._loader.addEventListener(Event.COMPLETE, function():void
			{
				completeDispatched = true;
			});
			this._loader.source = "fixtures/red100x100.png";
			this._loader.validate();
			Async.delayCall(this, function():void
			{
				Assert.assertTrue("Event.COMPLETE not dispatched by ImageLoader after loading valid URL.", completeDispatched);
			}, 200);
		}

		[Test(async)]
		public function testIOErrorEvent():void
		{
			var ioErrorDispatched:Boolean = false;
			this._loader.addEventListener(Event.IO_ERROR, function():void
			{
				ioErrorDispatched = true;
			});
			this._loader.source = "fixtures/fake.png";
			this._loader.validate();
			Async.delayCall(this, function():void
			{
				Assert.assertTrue("Event.IO_ERROR not dispatched by ImageLoader after loading invalid URL.", ioErrorDispatched);
			}, 200);
		}

		[Test(async)]
		public function testResize():void
		{
			var resizeDispatched:Boolean = false;
			var loader:ImageLoader = this._loader;
			loader.addEventListener(Event.RESIZE, function():void
			{
				resizeDispatched = true;
			});
			loader.source = "fixtures/red100x100.png";
			loader.validate();
			Async.delayCall(this, function():void
			{
				Assert.assertTrue("Event.RESIZE not dispatched by ImageLoader after loading URL.", resizeDispatched);
				Assert.assertStrictlyEquals("ImageLoader width property not changed after loading URL.", 100, loader.width);
				Assert.assertStrictlyEquals("ImageLoader height property not changed after loading URL.", 100, loader.height);
				Assert.assertStrictlyEquals("ImageLoader minWidth property not changed after loading URL.", 100, loader.minWidth);
				Assert.assertStrictlyEquals("ImageLoader minHeight property not changed after loading URL.", 100, loader.minHeight);
			}, 200);
		}

		[Test(async)]
		public function testResizeWithNewSource():void
		{
			var loader:ImageLoader = this._loader;
			loader.addEventListener(Event.COMPLETE, function():void
			{
				loader.removeEventListener(Event.COMPLETE, arguments.callee);
				loader.source = "fixtures/green200x200.png";
				loader.validate();
			});
			loader.source = "fixtures/red100x100.png";
			loader.validate();
			Async.delayCall(this, function():void
			{
				Assert.assertStrictlyEquals("ImageLoader width property not changed after loading second URL.", 200, loader.width);
				Assert.assertStrictlyEquals("ImageLoader height property not changed after loading second URL.", 200, loader.height);
				Assert.assertStrictlyEquals("ImageLoader minWidth property not changed after loading second URL.", 200, loader.minWidth);
				Assert.assertStrictlyEquals("ImageLoader minHeight property not changed after loading second URL.", 200, loader.minHeight);
			}, 200);
		}

		[Test(async)]
		public function testScaleFactor():void
		{
			var loader:ImageLoader = this._loader;
			loader.scaleFactor = 2;
			loader.source = "fixtures/green200x200.png";
			loader.validate();
			Async.delayCall(this, function():void
			{
				Assert.assertStrictlyEquals("ImageLoader originalSourceWidth property not changed after loading URL.", 200, loader.originalSourceWidth);
				Assert.assertStrictlyEquals("ImageLoader originalSourceHeight property not changed after loading URL.", 200, loader.originalSourceHeight);
				Assert.assertStrictlyEquals("ImageLoader width property not changed after loading URL.", 100, loader.width);
				Assert.assertStrictlyEquals("ImageLoader height property not changed after loading URL.", 100, loader.height);
				Assert.assertStrictlyEquals("ImageLoader minWidth property not changed after loading URL.", 100, loader.minWidth);
				Assert.assertStrictlyEquals("ImageLoader minHeight property not changed after loading URL.", 100, loader.minHeight);
			}, 200);
		}

		[Test(async)]
		public function testCacheRetainCountOnComplete():void
		{
			var textureCache:TextureCache = new TextureCache(2);
			var source:String = "fixtures/green200x200.png";
			var loader:ImageLoader = this._loader;
			loader.source = source;
			loader.textureCache = textureCache;
			var retainCount:int = 0;
			loader.addEventListener(Event.COMPLETE, function():void
			{
				retainCount = textureCache.getRetainCount(source);
			});
			loader.validate();
			Async.delayCall(this, function():void
			{
				textureCache.dispose();
				Assert.assertStrictlyEquals("ImageLoader textureCache retain count incorrect after load complete.", 1, retainCount);
			}, 200);
		}

		[Test(async)]
		public function testReleaseTextureFromCacheAfterSetSourceToNull():void
		{
			var textureCache:TextureCache = new TextureCache(2);
			var source:String = "fixtures/green200x200.png";
			var loader:ImageLoader = this._loader;
			loader.source = source;
			loader.textureCache = textureCache;
			loader.validate();
			Async.delayCall(this, function():void
			{
				loader.source = null;
				var retainCount:int = textureCache.getRetainCount(source);
				textureCache.dispose();
				Assert.assertStrictlyEquals("ImageLoader textureCache retain count incorrect after set source to null.", 0, retainCount);
			}, 200);
		}

		[Test]
		public function testAutoSizeWidthScaleModeNone():void
		{
			var textureSize:Number = 20;
			var loaderHeight:Number = 200;
			this._texture = Texture.fromColor(textureSize, textureSize);
			this._loader.source = this._texture;
			this._loader.height = loaderHeight;
			this._loader.scaleMode = ScaleMode.NONE;
			this._loader.validate();

			Assert.assertStrictlyEquals("ImageLoader calculates incorrect width when using ScaleMode.NONE and setting larger explicit height.",
				textureSize, this._loader.width);
			Assert.assertStrictlyEquals("ImageLoader calculates incorrect minWidth when using ScaleMode.NONE and setting larger explicit height.",
				textureSize, this._loader.minWidth);
		}

		[Test]
		public function testAutoSizeHeightScaleModeNone():void
		{
			var textureSize:Number = 20;
			var loaderWidth:Number = 200;
			this._texture = Texture.fromColor(textureSize, textureSize);
			this._loader.source = this._texture;
			this._loader.width = loaderWidth;
			this._loader.scaleMode = ScaleMode.NONE;
			this._loader.validate();

			Assert.assertStrictlyEquals("ImageLoader calculates incorrect height when using ScaleMode.NONE and setting larger explicit width.",
				textureSize, this._loader.height);
			Assert.assertStrictlyEquals("ImageLoader calculates incorrect minHeight when using ScaleMode.NONE and setting larger explicit width.",
				textureSize, this._loader.minHeight);
		}

		[Test]
		public function testAutoSizeWidthAfterSettingHeightLarger():void
		{
			var textureWidth:Number = 20;
			var textureHeight:Number = 15;
			var expectedWidth:Number = 200;
			var updatedHeight:Number = 150;
			this._texture = Texture.fromColor(textureWidth, textureHeight);
			this._loader.source = this._texture;
			this._loader.height = updatedHeight;
			this._loader.scaleMode = ScaleMode.SHOW_ALL;
			this._loader.validate();

			Assert.assertStrictlyEquals("ImageLoader calculates incorrect width when setting explicit height larger than texture height.",
				expectedWidth, this._loader.width);
			Assert.assertStrictlyEquals("ImageLoader calculates incorrect minWidth when setting explicit height larger than texture height.",
				expectedWidth, this._loader.minWidth);
		}

		[Test]
		public function testAutoSizeHeightAfterSettingWidthLarger():void
		{
			var textureWidth:Number = 20;
			var textureHeight:Number = 15;
			var updatedWidth:Number = 200;
			var expectedHeight:Number = 150;
			this._texture = Texture.fromColor(textureWidth, textureHeight);
			this._loader.source = this._texture;
			this._loader.width = updatedWidth;
			this._loader.scaleMode = ScaleMode.SHOW_ALL;
			this._loader.validate();

			Assert.assertStrictlyEquals("ImageLoader calculates incorrect height when setting explicit width larger than texture width.",
				expectedHeight, this._loader.height);
			Assert.assertStrictlyEquals("ImageLoader calculates incorrect minHeight when setting explicit width larger than texture width.",
				expectedHeight, this._loader.minHeight);
		}

		[Test]
		public function testIgnoreMaintainAspectRationWithScale9Grid():void
		{
			var textureWidth:Number = 20;
			var textureHeight:Number = 15;
			var updatedWidth:Number = 200;
			this._texture = Texture.fromColor(textureWidth, textureHeight);
			this._loader.source = this._texture;
			this._loader.scale9Grid = new Rectangle(2, 2, 18, 11);
			this._loader.width = updatedWidth;
			this._loader.scaleMode = ScaleMode.SHOW_ALL;
			this._loader.validate();

			Assert.assertStrictlyEquals("ImageLoader calculates incorrect height when setting explicit width larger than texture width and using scale9Grid.",
				textureHeight, this._loader.height);
		}
	}
}
