package feathers.tests
{
	import org.flexunit.Assert;
	import org.flexunit.async.Async;

	import starling.events.Event;

	public class ImageLoaderInternalStateTests
	{
		private var _loader:ImageLoaderDisposeWatcher;

		[Before]
		public function prepare():void
		{
			this._loader = new ImageLoaderDisposeWatcher();
			TestFeathers.starlingRoot.addChild(this._loader);
		}

		[After]
		public function cleanup():void
		{
			this._loader.removeFromParent(true);
			this._loader = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test(async)]
		public function testDisposeTextureAfterSetSourceToNull():void
		{
			var loader:ImageLoaderDisposeWatcher = this._loader;
			loader.addEventListener(Event.COMPLETE, function():void
			{
				loader.source = null;
			});
			loader.source = "fixtures/red100x100.png";
			loader.validate();
			Async.delayCall(this, function():void
			{
				Assert.assertTrue("Texture not disposed after setting ImageLoader source to null.", loader.hasDisposedTexture);
			}, 200);
		}

		[Test(async)]
		public function testKeepTextureAfterLoadNewImageWithSameDimensions():void
		{
			var isSecondImageLoaded:Boolean = false;
			var loader:ImageLoaderDisposeWatcher = this._loader;
			loader.addEventListener(Event.COMPLETE, function():void
			{
				loader.removeEventListener(Event.COMPLETE, arguments.callee);
				loader.source = "fixtures/blue100x100.png";
				loader.validate();
				loader.addEventListener(Event.COMPLETE, function():void
				{
					isSecondImageLoaded = true;
				});
			});
			loader.source = "fixtures/red100x100.png";
			loader.validate();
			Async.delayCall(this, function():void
			{
				Assert.assertTrue("Second image did not complete loading.", isSecondImageLoaded);
				Assert.assertFalse("Texture incorrectly disposed after setting ImageLoader source to image with same dimensions.", loader.hasDisposedTexture);
			}, 200);
		}

		[Test(async)]
		public function testDisposeTextureAfterLoadNewImageWithDifferentDimensions():void
		{
			var isSecondImageLoaded:Boolean = false;
			var loader:ImageLoaderDisposeWatcher = this._loader;
			loader.addEventListener(Event.COMPLETE, function():void
			{
				loader.removeEventListener(Event.COMPLETE, arguments.callee);
				loader.source = "fixtures/green200x200.png";
				loader.validate();
				loader.addEventListener(Event.COMPLETE, function():void
				{
					isSecondImageLoaded = true;
				});
			});
			loader.source = "fixtures/red100x100.png";
			loader.validate();
			Async.delayCall(this, function():void
			{
				Assert.assertTrue("Second image did not complete loading.", isSecondImageLoaded);
				Assert.assertTrue("Texture not disposed after setting ImageLoader source to image with different dimensions.", loader.hasDisposedTexture);
			}, 200);
		}
	}
}

import feathers.controls.ImageLoader;

class ImageLoaderDisposeWatcher extends ImageLoader
{
	override protected function cleanupTexture():void
	{
		if(this._texture && this._isTextureOwner)
		{
			this.hasDisposedTexture = true;
		}
		super.cleanupTexture();
	}
	
	public var hasDisposedTexture:Boolean = false;
}