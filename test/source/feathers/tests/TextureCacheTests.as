package feathers.tests
{
	import feathers.utils.textures.TextureCache;

	import org.flexunit.Assert;

	import starling.textures.Texture;

	public class TextureCacheTests
	{
		private static const KEY_ONE:String = "one";
		private static const KEY_TWO:String = "two";
		
		private var _cache:TextureCache;
		private var _texture1:Texture;
		private var _texture2:Texture;
		
		[Before]
		public function prepare():void
		{
			this._cache = new TextureCache();
			
			this._texture1 = Texture.fromColor(10, 10, 0xffff00ff);
			this._texture2 = Texture.fromColor(10, 10, 0xffffff00);
		}

		[After]
		public function cleanup():void
		{
			this._cache.dispose();
			this._cache = null;
			this._texture1.dispose();
			this._texture1 = null;
			this._texture2.dispose();
			this._texture2 = null;
		}

		[Test]
		public function testRetainCountAfterAddWithRetain():void
		{
			this._cache.addTexture(KEY_ONE, this._texture1, true);
			Assert.assertStrictlyEquals("The result of getRetainCount() on a TextureCache is incorrect after addTexture() with retain.",
				1, this._cache.getRetainCount(KEY_ONE));
		}

		[Test]
		public function testRetainCountAfterAddWithoutRetain():void
		{
			this._cache.addTexture(KEY_ONE, this._texture1, false);
			Assert.assertStrictlyEquals("The result of getRetainCount() on a TextureCache is incorrect after addTexture() without retain.",
				0, this._cache.getRetainCount(KEY_ONE));
		}

		[Test]
		public function testRetainCountAfterTwoRetains():void
		{
			this._cache.addTexture(KEY_ONE, this._texture1, true);
			this._cache.retainTexture(KEY_ONE);
			Assert.assertStrictlyEquals("The result of getRetainCount() on a TextureCache is incorrect after retaining twice.",
				2, this._cache.getRetainCount(KEY_ONE));
		}

		[Test]
		public function testRetainCountAfterRelease():void
		{
			this._cache.addTexture(KEY_ONE, this._texture1, true);
			this._cache.releaseTexture(KEY_ONE);
			Assert.assertStrictlyEquals("The result of getRetainCount() on a TextureCache is incorrect after releasing.",
				0, this._cache.getRetainCount(KEY_ONE));
		}

		[Test]
		public function testRetainCountAfterRemove():void
		{
			this._cache.addTexture(KEY_ONE, this._texture1, true);
			this._cache.removeTexture(KEY_ONE);
			Assert.assertStrictlyEquals("The result of getRetainCount() on a TextureCache is incorrect after removing a texture.",
				0, this._cache.getRetainCount(KEY_ONE));
		}

		[Test]
		public function testRetainCountAfterDispose():void
		{
			this._cache.addTexture(KEY_ONE, this._texture1, true);
			this._cache.dispose();
			Assert.assertStrictlyEquals("The result of getRetainCount() on a TextureCache is incorrect after disposing the cache.",
				0, this._cache.getRetainCount(KEY_ONE));
		}

		[Test]
		public function testRetainCountAfterAddTwoTextures():void
		{
			this._cache.addTexture(KEY_ONE, this._texture1, true);
			this._cache.addTexture(KEY_TWO, this._texture2, true);
			this._cache.retainTexture(KEY_ONE);
			this._cache.retainTexture(KEY_ONE);
			this._cache.retainTexture(KEY_TWO);
			Assert.assertStrictlyEquals("The result of getRetainCount() on a TextureCache is incorrect after adding two textures.",
				3, this._cache.getRetainCount(KEY_ONE));
			Assert.assertStrictlyEquals("The result of getRetainCount() on a TextureCache is incorrect after adding two textures.",
				2, this._cache.getRetainCount(KEY_TWO));
		}

		[Test]
		public function testHasTextureAfterRetain():void
		{
			this._cache.addTexture(KEY_ONE, this._texture1, true);
			Assert.assertTrue("The result of hasTexture() on a TextureCache is incorrect after retain.",
				this._cache.hasTexture(KEY_ONE));
		}

		[Test]
		public function testHasTextureAfterRelease():void
		{
			this._cache.addTexture(KEY_ONE, this._texture1, true);
			this._cache.releaseTexture(KEY_ONE);
			Assert.assertTrue("The result of hasTexture() on a TextureCache is incorrect after releasing.",
				this._cache.hasTexture(KEY_ONE));
		}

		[Test]
		public function testHasTextureAfterRemove():void
		{
			this._cache.addTexture(KEY_ONE, this._texture1, true);
			this._cache.removeTexture(KEY_ONE);
			Assert.assertFalse("The result of hasTexture() on a TextureCache is incorrect after removing a texture.",
				this._cache.hasTexture(KEY_ONE));
		}

		[Test]
		public function testHasTextureAfterDispose():void
		{
			this._cache.addTexture(KEY_ONE, this._texture1, true);
			this._cache.dispose();
			Assert.assertFalse("The result of hasTexture() on a TextureCache is incorrect after disposing the cache.",
				this._cache.hasTexture(KEY_ONE));
		}

		[Test]
		public function testHasTextureWithMaxUnretainedTexturesAfterAddWithoutRetain():void
		{
			this._cache.maxUnretainedTextures = 1;
			this._cache.addTexture(KEY_ONE, this._texture1, false);
			this._cache.addTexture(KEY_TWO, this._texture2, false);
			//both are added unretained, but the maximum is 1, one will be
			//removed automatically. since KEY_ONE was put into an unretained
			//state first, it's the one that will be removed.
			Assert.assertFalse("The result of hasTexture() on a TextureCache is maxUnretainedTextures is incorrect after releasing",
				this._cache.hasTexture(KEY_ONE));
			Assert.assertTrue("The result of hasTexture() on a TextureCache with maxUnretainedTextures is incorrect after releasing.",
				this._cache.hasTexture(KEY_TWO));
		}

		[Test]
		public function testHasTextureWithMaxUnretainedTexturesAfterRelease():void
		{
			this._cache.maxUnretainedTextures = 1;
			this._cache.addTexture(KEY_ONE, this._texture1, true);
			this._cache.addTexture(KEY_TWO, this._texture2, true);
			this._cache.releaseTexture(KEY_ONE);
			this._cache.releaseTexture(KEY_TWO);
			//KEY_ONE was released first, so it will be the one that is removed
			//automatically, while KEY_TWO will remain cached.
			Assert.assertFalse("The result of hasTexture() on a TextureCache is maxUnretainedTextures is incorrect after releasing",
				this._cache.hasTexture(KEY_ONE));
			Assert.assertTrue("The result of hasTexture() on a TextureCache with maxUnretainedTextures is incorrect after releasing.",
				this._cache.hasTexture(KEY_TWO));
		}

		[Test]
		public function testRemoveTextureThatWasNotAdded():void
		{
			//no errors should be thrown
			this._cache.removeTexture(KEY_ONE);
		}

		[Test(expects="flash.errors.IllegalOperationError")]
		public function testAddTextureAfterDispose():void
		{
			this._cache.dispose();
			this._cache.addTexture(KEY_ONE, this._texture1, true);
		}

		[Test(expects="flash.errors.IllegalOperationError")]
		public function testRetainTextureAfterDispose():void
		{
			//in the case where the cache is disposed before a display object
			//is disposed, it's better not to throw a strange runtime error.
			this._cache.addTexture(KEY_ONE, this._texture1, true);
			this._cache.dispose();
			this._cache.retainTexture(KEY_ONE);
		}

		[Test]
		public function testReleaseTextureAfterDispose():void
		{
			//in the case where the cache is disposed before a display object
			//is disposed, it's better not to throw a strange runtime error.
			this._cache.addTexture(KEY_ONE, this._texture1, true);
			this._cache.dispose();
			this._cache.releaseTexture(KEY_ONE);
		}

		[Test]
		public function testRemoveTextureAfterDispose():void
		{
			this._cache.addTexture(KEY_ONE, this._texture1, true);
			this._cache.dispose();
			//removal shouldn't throw any errors if the texture doesn't exist
			this._cache.removeTexture(KEY_ONE);
		}
	}
}
