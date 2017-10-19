package feathers.tests
{
	import feathers.controls.AutoSizeMode;
	import feathers.controls.LayoutGroup;

	import org.flexunit.Assert;

	import starling.display.Quad;

	public class LayoutGroupMeasurementTests
	{
		//note: the background width is purposefully smaller than the item width
		private static const BACKGROUND_WIDTH:Number = 200;
		//note: the background height is purposefully larger than the item height
		private static const BACKGROUND_HEIGHT:Number = 250;
		private static const BACKGROUND_MIN_WIDTH:Number = 180;
		private static const BACKGROUND_MIN_HEIGHT:Number = 190;

		//note: the item width is purposefully larger than the background width
		private static const ITEM_WIDTH:Number = 210;
		//note: the item height is purposefully smaller than the background height
		private static const ITEM_HEIGHT:Number = 160;

		private static const ITEM_WIDTH2:Number = 190;
		private static const ITEM_HEIGHT2:Number = 170;

		private static const ITEM_PIVOTX:Number = 105;
		private static const ITEM_PIVOTY:Number = 80;

		private var _group:LayoutGroup;
		private var _group2:LayoutGroup;

		[Before]
		public function prepare():void
		{
			this._group = new LayoutGroup();
			TestFeathers.starlingRoot.addChild(this._group);
			this._group.validate();
		}

		[After]
		public function cleanup():void
		{
			this._group.removeFromParent(true);
			this._group = null;
			
			if(this._group2)
			{
				this._group2.removeFromParent(true);
				this._group2 = null;
			}

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}
		
		private function addSimpleBackground():void
		{
			this._group.backgroundSkin = new Quad(BACKGROUND_WIDTH, BACKGROUND_HEIGHT);
		}

		private function addComplexBackground():void
		{
			var backgroundSkin:LayoutGroup = new LayoutGroup();
			backgroundSkin.setSize(BACKGROUND_WIDTH, BACKGROUND_HEIGHT);
			backgroundSkin.minWidth = BACKGROUND_MIN_WIDTH;
			backgroundSkin.minHeight = BACKGROUND_MIN_HEIGHT;
			this._group.backgroundSkin = backgroundSkin;
		}

		[Test]
		public function testAutoSizeNoChildrenNoBackgroundAndNoLayout():void
		{
			this._group.validate();
			Assert.assertStrictlyEquals("The width of the layout group was not calculated correctly when empty.",
				0, this._group.width);
			Assert.assertStrictlyEquals("The height of the layout group was not calculated correctly when empty.",
				0, this._group.height);
			Assert.assertStrictlyEquals("The minWidth of the layout group was not calculated correctly when empty.",
				0, this._group.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the layout group was not calculated correctly when empty.",
				0, this._group.minHeight);
		}

		[Test]
		public function testAutoSizeWithSimpleBackgroundAndNoChildren():void
		{
			this.addSimpleBackground();
			this._group.validate();
			Assert.assertStrictlyEquals("The width of the layout group was not calculated correctly with background skin and no children.",
				BACKGROUND_WIDTH, this._group.width);
			Assert.assertStrictlyEquals("The height of the layout group was not calculated correctly with background skin and no children.",
				BACKGROUND_HEIGHT, this._group.height);
			Assert.assertStrictlyEquals("The minWidth of the layout group was not calculated correctly with background skin and no children.",
				BACKGROUND_WIDTH, this._group.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the layout group was not calculated correctly with background skin and no children.",
				BACKGROUND_HEIGHT, this._group.minHeight);
		}

		[Test]
		public function testAutoSizeWithComplexBackgroundAndNoChildren():void
		{
			this.addComplexBackground();
			this._group.validate();
			Assert.assertStrictlyEquals("The width of the layout group was not calculated correctly with complex background skin and no children.",
				BACKGROUND_WIDTH, this._group.width);
			Assert.assertStrictlyEquals("The height of the layout group was not calculated correctly with complex background skin and no children.",
				BACKGROUND_HEIGHT, this._group.height);
			
			//this is a little different than other components. the layout needs
			//to account for the full background dimensions, so the minimum
			//dimensions cannot be passed to the layout. to use minimum
			//dimensions with a LayoutGroup, they need to be set on the
			//LayoutGroup directly!
			Assert.assertStrictlyEquals("The minWidth of the layout group was not calculated correctly with complex background skin and no children.",
				BACKGROUND_WIDTH, this._group.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the layout group was not calculated correctly with complex background skin and no children.",
				BACKGROUND_HEIGHT, this._group.minHeight);
		}

		[Test]
		public function testAutoSizeModeStage():void
		{
			this._group.autoSizeMode = AutoSizeMode.STAGE;
			this._group.validate();
			Assert.assertStrictlyEquals("The width of the layout group was not calculated correctly with autoSizeMode set to AutoSizeMode.STAGE.",
				this._group.stage.stageWidth, this._group.width);
			Assert.assertStrictlyEquals("The height of the layout group was not calculated correctly with autoSizeMode set to AutoSizeMode.STAGE.",
				this._group.stage.stageHeight, this._group.height);
			Assert.assertStrictlyEquals("The minWidth of the layout group was not calculated correctly with autoSizeMode set to AutoSizeMode.STAGE.",
				this._group.stage.stageWidth, this._group.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the layout group was not calculated correctly with autoSizeMode set to AutoSizeMode.STAGE.",
				this._group.stage.stageHeight, this._group.minHeight);
		}

		[Test]
		public function testAutoSizeModeStageWithoutParent():void
		{
			this._group2 = new LayoutGroup();
			this._group2.autoSizeMode = AutoSizeMode.STAGE;
			this._group2.validate();
			Assert.assertStrictlyEquals("The width of the LayoutGroup was not calculated correctly with no parent and AutoSizeMode.STAGE.",
				0, this._group2.width);
			Assert.assertStrictlyEquals("The height of the LayoutGroup was not calculated correctly with no parent and AutoSizeMode.STAGE.",
				0, this._group2.height);
			Assert.assertStrictlyEquals("The minWidth of the LayoutGroup was not calculated correctly with no parent and AutoSizeMode.STAGE.",
				0, this._group2.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the LayoutGroup was not calculated correctly with no parent and AutoSizeMode.STAGE.",
				0, this._group2.minHeight);
		}

		[Test]
		public function testAutoSizeModeStageWithValidateBeforeAdd():void
		{
			this._group2 = new LayoutGroup();
			this._group2.autoSizeMode = AutoSizeMode.STAGE;
			this._group2.validate();
			TestFeathers.starlingRoot.addChild(this._group2);
			this._group2.validate();
			Assert.assertStrictlyEquals("The width of the LayoutGroup was not calculated correctly after addChild() when validated before with AutoSizeMode.STAGE.",
				TestFeathers.starlingRoot.stage.stageWidth, this._group2.width);
			Assert.assertStrictlyEquals("The height of the LayoutGroup was not calculated correctly after addChild() when validated before with AutoSizeMode.STAGE.",
				TestFeathers.starlingRoot.stage.stageHeight, this._group2.height);
			Assert.assertStrictlyEquals("The minWidth of the LayoutGroup was not calculated correctly after addChild() when validated before with AutoSizeMode.STAGE.",
				TestFeathers.starlingRoot.stage.stageWidth, this._group2.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the LayoutGroup was not calculated correctly after addChild() when validated before with AutoSizeMode.STAGE.",
				TestFeathers.starlingRoot.stage.stageHeight, this._group2.minHeight);
		}

		[Test]
		public function testAutoSizeModeStageWithChildBeyondStageEdges():void
		{
			this._group.autoSizeMode = AutoSizeMode.STAGE;
			var child:Quad = new Quad(ITEM_WIDTH, ITEM_HEIGHT);
			child.x = this._group.stage.stageWidth + 100;
			child.y = this._group.stage.stageHeight + 100;
			this._group.addChild(child);
			this._group.validate();
			Assert.assertStrictlyEquals("The width of the layout group was not calculated correctly with autoSizeMode set to AutoSizeMode.STAGE.",
				this._group.stage.stageWidth, this._group.width);
			Assert.assertStrictlyEquals("The height of the layout group was not calculated correctly with autoSizeMode set to AutoSizeMode.STAGE.",
				this._group.stage.stageHeight, this._group.height);
			Assert.assertStrictlyEquals("The minWidth of the layout group was not calculated correctly with autoSizeMode set to AutoSizeMode.STAGE.",
				this._group.stage.stageWidth, this._group.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the layout group was not calculated correctly with autoSizeMode set to AutoSizeMode.STAGE.",
				this._group.stage.stageHeight, this._group.minHeight);
		}

		[Test]
		public function testAutoSizeWithChildAtOrigin():void
		{
			this._group.addChild(new Quad(ITEM_WIDTH, ITEM_HEIGHT));
			this._group.validate();
			Assert.assertStrictlyEquals("The width of the layout group was not calculated correctly.",
				ITEM_WIDTH, this._group.width);
			Assert.assertStrictlyEquals("The height of the layout group was not calculated correctly.",
				ITEM_HEIGHT, this._group.height);
			Assert.assertStrictlyEquals("The minWidth of the layout group was not calculated correctly.",
				ITEM_WIDTH, this._group.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the layout group was not calculated correctly.",
				ITEM_HEIGHT, this._group.minHeight);
		}

		[Test]
		public function testAutoSizeWithChild():void
		{
			var child:Quad = new Quad(ITEM_WIDTH, ITEM_HEIGHT);
			child.x = 120;
			child.y = 130;
			this._group.addChild(child);
			this._group.validate();
			Assert.assertStrictlyEquals("The width of the layout group was not calculated correctly.",
				child.x + ITEM_WIDTH, this._group.width);
			Assert.assertStrictlyEquals("The height of the layout group was not calculated correctly.",
				child.y + ITEM_HEIGHT, this._group.height);
			Assert.assertStrictlyEquals("The minWidth of the layout group was not calculated correctly.",
				child.x + ITEM_WIDTH, this._group.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the layout group was not calculated correctly.",
				child.y + ITEM_HEIGHT, this._group.minHeight);
		}

		[Test]
		public function testAutoSizeWithChildPositionedWithBoundsFullyInNegative():void
		{
			var child:Quad = new Quad(ITEM_WIDTH, ITEM_HEIGHT);
			child.x = -420;
			child.y = -430;
			this._group.addChild(child);
			this._group.validate();
			Assert.assertStrictlyEquals("The width of the layout group was not calculated correctly.",
				0, this._group.width);
			Assert.assertStrictlyEquals("The height of the layout group was not calculated correctly.",
				0, this._group.height);
			Assert.assertStrictlyEquals("The minWidth of the layout group was not calculated correctly.",
				0, this._group.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the layout group was not calculated correctly.",
				0, this._group.minHeight);
		}

		[Test]
		public function testAutoSizeWithChildPositionedWithBoundsInBothPositiveAndNegative():void
		{
			var child:Quad = new Quad(ITEM_WIDTH, ITEM_HEIGHT);
			child.x = -Math.round(ITEM_WIDTH / 4);
			child.y = -Math.round(ITEM_HEIGHT / 3);
			this._group.addChild(child);
			this._group.validate();
			Assert.assertStrictlyEquals("The width of the layout group was not calculated correctly.",
				child.x + ITEM_WIDTH, this._group.width);
			Assert.assertStrictlyEquals("The height of the layout group was not calculated correctly.",
				child.y + ITEM_HEIGHT, this._group.height);
			Assert.assertStrictlyEquals("The minWidth of the layout group was not calculated correctly.",
				child.x + ITEM_WIDTH, this._group.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the layout group was not calculated correctly.",
				child.y + ITEM_HEIGHT, this._group.minHeight);
		}

		[Test]
		public function testAutoSizeWithMultipleChildren():void
		{
			var child1:Quad = new Quad(ITEM_WIDTH, ITEM_HEIGHT);
			child1.x = 0;
			child1.y = 130;
			this._group.addChild(child1);
			var child2:Quad = new Quad(ITEM_WIDTH2, ITEM_HEIGHT2);
			child2.x = 120;
			child2.y = 0;
			this._group.addChild(child2);
			this._group.validate();
			Assert.assertStrictlyEquals("The width of the layout group was not calculated correctly.",
				child2.x + ITEM_WIDTH2, this._group.width);
			Assert.assertStrictlyEquals("The height of the layout group was not calculated correctly.",
				child1.y + ITEM_HEIGHT, this._group.height);
			Assert.assertStrictlyEquals("The minWidth of the layout group was not calculated correctly.",
				child2.x + ITEM_WIDTH2, this._group.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the layout group was not calculated correctly.",
				child1.y + ITEM_HEIGHT, this._group.minHeight);
		}

		[Test]
		public function testAutoSizeChildAndSimpleBackground():void
		{
			this._group.addChild(new Quad(ITEM_WIDTH, ITEM_HEIGHT));
			this.addSimpleBackground();
			this._group.validate();
			Assert.assertStrictlyEquals("The width of the layout group was not calculated correctly.",
				ITEM_WIDTH, this._group.width);
			Assert.assertStrictlyEquals("The height of the layout group was not calculated correctly.",
				BACKGROUND_HEIGHT, this._group.height);
			Assert.assertStrictlyEquals("The minWidth of the layout group was not calculated correctly.",
				ITEM_WIDTH, this._group.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the layout group was not calculated correctly.",
				BACKGROUND_HEIGHT, this._group.minHeight);
		}

		[Test]
		public function testAutoSizeChildWithPivots():void
		{
			var child:Quad = new Quad(ITEM_WIDTH, ITEM_HEIGHT);
			child.pivotX = ITEM_PIVOTX;
			child.pivotY = ITEM_PIVOTY;
			child.x = 120;
			child.y = 130;
			this._group.addChild(child);
			this._group.validate();
			var groupWidth:Number = child.x - ITEM_PIVOTX + ITEM_WIDTH;
			var groupHeight:Number = child.y - ITEM_PIVOTY + ITEM_HEIGHT;
			Assert.assertStrictlyEquals("The width of the layout group was not calculated correctly.",
				groupWidth, this._group.width);
			Assert.assertStrictlyEquals("The height of the layout group was not calculated correctly.",
				groupHeight, this._group.height);
			Assert.assertStrictlyEquals("The minWidth of the layout group was not calculated correctly.",
				groupWidth, this._group.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the layout group was not calculated correctly.",
				groupHeight, this._group.minHeight);
		}

		[Test]
		public function testRemoveChildToResizeSkin():void
		{
			var child:Quad = new Quad(ITEM_WIDTH, ITEM_HEIGHT);
			this._group.addChild(child);
			this._group.backgroundSkin = new Quad(10, 10, 0xff00ff);
			this._group.backgroundDisabledSkin = new Quad(10, 10, 0xff00ff);
			this._group.validate();
			//the child's dimensions were large enough to make group bigger
			//than the skin's dimensions
			this._group.removeChild(child);
			//switch to a different skin before validation
			this._group.isEnabled = false;
			this._group.validate();
			//now switch back to the original skin, and the dimensions could
			//be wrong if they weren't restored
			this._group.isEnabled = true;
			this._group.validate();
			Assert.assertStrictlyEquals("The width of the LayoutGroup was not calculated correctly after changing to a different skin and removing larger child.",
				10, this._group.width);
			Assert.assertStrictlyEquals("The height of the LayoutGroup was not calculated correctly after changing to a different skin and removing larger child.",
				10, this._group.height);
		}
	}
}
