package feathers.tests
{
	import feathers.controls.AutoSizeMode;
	import feathers.controls.ScrollContainer;

	import org.flexunit.Assert;

	import starling.display.Quad;

	public class ScrollContainerMeasurementTests
	{
		//note: the background width is purposefully smaller than the item width
		private static const BACKGROUND_WIDTH:Number = 200;
		//note: the background height is purposefully larger than the item height
		private static const BACKGROUND_HEIGHT:Number = 250;

		//note: the item width is purposefully larger than the background width
		private static const ITEM_WIDTH:Number = 210;
		//note: the item height is purposefully smaller than the background height
		private static const ITEM_HEIGHT:Number = 160;

		private var _container:ScrollContainer;
		private var _container2:ScrollContainer;

		[Before]
		public function prepare():void
		{
			this._container = new ScrollContainer();
			TestFeathers.starlingRoot.addChild(this._container);
			this._container.validate();
		}

		[After]
		public function cleanup():void
		{
			this._container.removeFromParent(true);
			this._container = null;
			
			if(this._container2)
			{
				this._container2.removeFromParent(true);
				this._container2 = null;
			}

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testAutoSizeWithNoBackgroundAndNoChildren():void
		{
			this._container.validate();
			Assert.assertStrictlyEquals("The width of the scroll container was not calculated correctly.",
				0, this._container.width);
			Assert.assertStrictlyEquals("The height of the scroll container was not calculated correctly.",
				0, this._container.height);
			Assert.assertStrictlyEquals("The minWidth of the scroll container was not calculated correctly.",
				0, this._container.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the scroll container was not calculated correctly.",
				0, this._container.minHeight);
		}

		[Test]
		public function testAutoSizeWithBackgroundAndNoChildren():void
		{
			this._container.backgroundSkin = new Quad(BACKGROUND_WIDTH, BACKGROUND_HEIGHT);
			this._container.validate();
			Assert.assertStrictlyEquals("The width of the scroll container was not calculated correctly.",
				BACKGROUND_WIDTH, this._container.width);
			Assert.assertStrictlyEquals("The height of the scroll container was not calculated correctly.",
				BACKGROUND_HEIGHT, this._container.height);
			Assert.assertStrictlyEquals("The minWidth of the scroll container was not calculated correctly.",
				BACKGROUND_WIDTH, this._container.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the scroll container was not calculated correctly.",
				BACKGROUND_HEIGHT, this._container.minHeight);
		}

		[Test]
		public function testAutoSizeModeStage():void
		{
			this._container.autoSizeMode = AutoSizeMode.STAGE;
			this._container.validate();
			Assert.assertStrictlyEquals("The width of the scroll container was not calculated correctly with autoSizeMode set to AutoSizeMode.STAGE.",
				this._container.stage.stageWidth, this._container.width);
			Assert.assertStrictlyEquals("The height of the scroll container was not calculated correctly with autoSizeMode set to AutoSizeMode.STAGE.",
				this._container.stage.stageHeight, this._container.height);
			Assert.assertStrictlyEquals("The minWidth of the scroll container was not calculated correctly with autoSizeMode set to AutoSizeMode.STAGE.",
				this._container.stage.stageWidth, this._container.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the scroll container was not calculated correctly with autoSizeMode set to AutoSizeMode.STAGE.",
				this._container.stage.stageHeight, this._container.minHeight);
		}

		[Test]
		public function testAutoSizeModeStageWithoutParent():void
		{
			this._container2 = new ScrollContainer();
			this._container2.autoSizeMode = AutoSizeMode.STAGE;
			this._container2.validate();
			Assert.assertStrictlyEquals("The width of the ScrollContainer was not calculated correctly with no parent and AutoSizeMode.STAGE.",
				0, this._container2.width);
			Assert.assertStrictlyEquals("The height of the ScrollContainer was not calculated correctly with no parent and AutoSizeMode.STAGE.",
				0, this._container2.height);
			Assert.assertStrictlyEquals("The minWidth of the ScrollContainer was not calculated correctly with no parent and AutoSizeMode.STAGE.",
				0, this._container2.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the ScrollContainer was not calculated correctly with no parent and AutoSizeMode.STAGE.",
				0, this._container2.minHeight);
		}

		[Test]
		public function testAutoSizeModeStageWithValidateBeforeAdd():void
		{
			this._container2 = new ScrollContainer();
			this._container2.autoSizeMode = AutoSizeMode.STAGE;
			this._container2.validate();
			TestFeathers.starlingRoot.addChild(this._container2);
			this._container2.validate();
			Assert.assertStrictlyEquals("The width of the ScrollContainer was not calculated correctly after addChild() when validated before with AutoSizeMode.STAGE.",
				TestFeathers.starlingRoot.stage.stageWidth, this._container2.width);
			Assert.assertStrictlyEquals("The height of the ScrollContainer was not calculated correctly after addChild() when validated before with AutoSizeMode.STAGE.",
				TestFeathers.starlingRoot.stage.stageHeight, this._container2.height);
			Assert.assertStrictlyEquals("The minWidth of the ScrollContainer was not calculated correctly after addChild() when validated before with AutoSizeMode.STAGE.",
				TestFeathers.starlingRoot.stage.stageWidth, this._container2.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the ScrollContainer was not calculated correctly after addChild() when validated before with AutoSizeMode.STAGE.",
				TestFeathers.starlingRoot.stage.stageHeight, this._container2.minHeight);
		}

		[Test]
		public function testAutoSizeWithChildAtOrigin():void
		{
			this._container.addChild(new Quad(ITEM_WIDTH, ITEM_HEIGHT));
			this._container.validate();
			Assert.assertStrictlyEquals("The width of the scroll container was not calculated correctly.",
				ITEM_WIDTH, this._container.width);
			Assert.assertStrictlyEquals("The height of the scroll container was not calculated correctly.",
				ITEM_HEIGHT, this._container.height);
			Assert.assertStrictlyEquals("The minWidth of the scroll container was not calculated correctly.",
				ITEM_WIDTH, this._container.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the scroll container was not calculated correctly.",
				ITEM_HEIGHT, this._container.minHeight);
		}

		[Test]
		public function testAutoSizeWithChildAtOriginAndMeasureViewPortSetToFalse():void
		{
			this._container.addChild(new Quad(ITEM_WIDTH, ITEM_HEIGHT));
			this._container.measureViewPort = false;
			this._container.validate();
			Assert.assertStrictlyEquals("The width of the scroll container was not calculated correctly.",
				0, this._container.width);
			Assert.assertStrictlyEquals("The height of the scroll container was not calculated correctly.",
				0, this._container.height);
			Assert.assertStrictlyEquals("The minWidth of the scroll container was not calculated correctly.",
				0, this._container.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the scroll container was not calculated correctly.",
				0, this._container.minHeight);
		}

		[Test]
		public function testAutoSizeWithChildAtPositiveXAndY():void
		{
			var child:Quad = new Quad(ITEM_WIDTH, ITEM_HEIGHT);
			child.x = 120;
			child.y = 130;
			this._container.addChild(child);
			this._container.validate();
			Assert.assertStrictlyEquals("The width of the scroll container was not calculated correctly.",
				child.x + ITEM_WIDTH, this._container.width);
			Assert.assertStrictlyEquals("The height of the scroll container was not calculated correctly.",
				child.y + ITEM_HEIGHT, this._container.height);
			Assert.assertStrictlyEquals("The minWidth of the scroll container was not calculated correctly.",
				child.x + ITEM_WIDTH, this._container.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the scroll container was not calculated correctly.",
				child.y + ITEM_HEIGHT, this._container.minHeight);
		}

		[Test]
		public function testAutoSizeWithMultipleChildren():void
		{
			var child1:Quad = new Quad(ITEM_WIDTH, ITEM_HEIGHT);
			child1.x = 0;
			child1.y = 130;
			this._container.addChild(child1);
			var child2:Quad = new Quad(ITEM_WIDTH, ITEM_HEIGHT);
			child2.x = 120;
			child2.y = 0;
			this._container.addChild(child2);
			this._container.validate();
			Assert.assertStrictlyEquals("The width of the scroll container was not calculated correctly.",
				child2.x + ITEM_WIDTH, this._container.width);
			Assert.assertStrictlyEquals("The height of the scroll container was not calculated correctly.",
				child1.y + ITEM_HEIGHT, this._container.height);
			Assert.assertStrictlyEquals("The minWidth of the scroll container was not calculated correctly.",
				child2.x + ITEM_WIDTH, this._container.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the scroll container was not calculated correctly.",
				child1.y + ITEM_HEIGHT, this._container.minHeight);
		}

		[Test]
		public function testAutoSizeChildAndBackground():void
		{
			this._container.addChild(new Quad(ITEM_WIDTH, ITEM_HEIGHT));
			this._container.backgroundSkin = new Quad(BACKGROUND_WIDTH, BACKGROUND_HEIGHT);
			this._container.validate();
			Assert.assertStrictlyEquals("The width of the scroll container was not calculated correctly.",
				ITEM_WIDTH, this._container.width);
			Assert.assertStrictlyEquals("The height of the scroll container was not calculated correctly.",
				BACKGROUND_HEIGHT, this._container.height);
			Assert.assertStrictlyEquals("The minWidth of the scroll container was not calculated correctly.",
				ITEM_WIDTH, this._container.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the scroll container was not calculated correctly.",
				BACKGROUND_HEIGHT, this._container.minHeight);
		}
	}
}
