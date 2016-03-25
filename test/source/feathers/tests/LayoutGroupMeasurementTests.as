package feathers.tests
{
	import feathers.controls.AutoSizeMode;
	import feathers.controls.Button;
	import feathers.controls.LayoutGroup;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.VerticalAlign;
	import feathers.layout.VerticalLayout;
	import feathers.tests.supportClasses.DisposeFlagQuad;

	import org.flexunit.Assert;

	import starling.display.Quad;
	import starling.events.Event;

	public class LayoutGroupMeasurementTests
	{
		//note: the background width is purposefully smaller than the item width
		private static const BACKGROUND_WIDTH:Number = 200;
		//note: the background height is purposefully larger than the item height
		private static const BACKGROUND_HEIGHT:Number = 250;

		//note: the item width is purposefully larger than the background width
		private static const ITEM_WIDTH:Number = 210;
		//note: the item height is purposefully smaller than the background height
		private static const ITEM_HEIGHT:Number = 160;

		private static const ITEM_WIDTH2:Number = 190;
		private static const ITEM_HEIGHT2:Number = 170;

		private var _group:LayoutGroup;

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

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}
		
		private function addSimpleBackground():void
		{
			this._group.backgroundSkin = new Quad(BACKGROUND_WIDTH, BACKGROUND_HEIGHT);
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
		public function testAutoSizeWithBackgroundAndNoChildren():void
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
	}
}
