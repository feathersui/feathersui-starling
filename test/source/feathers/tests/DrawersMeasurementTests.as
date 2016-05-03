package feathers.tests
{
	import feathers.controls.AutoSizeMode;
	import feathers.controls.Drawers;
	import feathers.controls.LayoutGroup;
	import feathers.layout.Orientation;

	import org.flexunit.Assert;

	public class DrawersMeasurementTests
	{
		private static const CONTENT_WIDTH:Number = 300;
		private static const CONTENT_HEIGHT:Number = 250;
		private static const CONTENT_MIN_WIDTH:Number = 125;
		private static const CONTENT_MIN_HEIGHT:Number = 75;
		
		private static const LEFT_DRAWER_WIDTH:Number = 30;
		private static const LEFT_DRAWER_HEIGHT:Number = 325;
		private static const LEFT_DRAWER_MIN_WIDTH:Number = 12;
		private static const LEFT_DRAWER_MIN_HEIGHT:Number = 100;

		private static const RIGHT_DRAWER_WIDTH:Number = 11;
		private static const RIGHT_DRAWER_HEIGHT:Number = 316;
		private static const RIGHT_DRAWER_MIN_WIDTH:Number = 15;
		private static const RIGHT_DRAWER_MIN_HEIGHT:Number = 110;

		private static const TOP_DRAWER_WIDTH:Number = 350;
		private static const TOP_DRAWER_HEIGHT:Number = 23;
		private static const TOP_DRAWER_MIN_WIDTH:Number = 315;
		private static const TOP_DRAWER_MIN_HEIGHT:Number = 21;

		private static const BOTTOM_DRAWER_WIDTH:Number = 330;
		private static const BOTTOM_DRAWER_HEIGHT:Number = 37;
		private static const BOTTOM_DRAWER_MIN_WIDTH:Number = 325;
		private static const BOTTOM_DRAWER_MIN_HEIGHT:Number = 31;

		private var _drawers:Drawers;

		[Before]
		public function prepare():void
		{
			this._drawers = new Drawers();
			TestFeathers.starlingRoot.addChild(this._drawers);
		}

		[After]
		public function cleanup():void
		{
			this._drawers.removeFromParent(true);
			this._drawers = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		private function addContent():void
		{
			var content:LayoutGroup = new LayoutGroup();
			content.width = CONTENT_WIDTH;
			content.height = CONTENT_HEIGHT;
			content.minWidth = CONTENT_MIN_WIDTH;
			content.minHeight = CONTENT_MIN_HEIGHT;
			this._drawers.content = content;
		}

		private function addLeftDrawer():void
		{
			var leftDrawer:LayoutGroup = new LayoutGroup();
			leftDrawer.width = LEFT_DRAWER_WIDTH;
			leftDrawer.height = LEFT_DRAWER_HEIGHT;
			leftDrawer.minWidth = LEFT_DRAWER_MIN_WIDTH;
			leftDrawer.minHeight = LEFT_DRAWER_MIN_HEIGHT;
			this._drawers.leftDrawer = leftDrawer;
		}

		private function addRightDrawer():void
		{
			var rightDrawer:LayoutGroup = new LayoutGroup();
			rightDrawer.width = RIGHT_DRAWER_WIDTH;
			rightDrawer.height = RIGHT_DRAWER_HEIGHT;
			rightDrawer.minWidth = RIGHT_DRAWER_MIN_WIDTH;
			rightDrawer.minHeight = RIGHT_DRAWER_MIN_HEIGHT;
			this._drawers.rightDrawer = rightDrawer;
		}

		private function addTopDrawer():void
		{
			var topDrawer:LayoutGroup = new LayoutGroup();
			topDrawer.width = TOP_DRAWER_WIDTH;
			topDrawer.height = TOP_DRAWER_HEIGHT;
			topDrawer.minWidth = TOP_DRAWER_MIN_WIDTH;
			topDrawer.minHeight = TOP_DRAWER_MIN_HEIGHT;
			this._drawers.topDrawer = topDrawer;
		}

		private function addBottomDrawer():void
		{
			var bottomDrawer:LayoutGroup = new LayoutGroup();
			bottomDrawer.width = BOTTOM_DRAWER_WIDTH;
			bottomDrawer.height = BOTTOM_DRAWER_HEIGHT;
			bottomDrawer.minWidth = BOTTOM_DRAWER_MIN_WIDTH;
			bottomDrawer.minHeight = BOTTOM_DRAWER_MIN_HEIGHT;
			this._drawers.bottomDrawer = bottomDrawer;
		}

		[Test]
		public function testAutoSizeStage():void
		{
			this.addContent();
			this._drawers.autoSizeMode = AutoSizeMode.STAGE;
			this._drawers.validate();

			Assert.assertStrictlyEquals("The width of the Drawers was not calculated correctly based on the stage width.",
				this._drawers.stage.stageWidth, this._drawers.width);
			Assert.assertStrictlyEquals("The height of the Drawers was not calculated correctly based on the stage height.",
				this._drawers.stage.stageHeight, this._drawers.height);
			Assert.assertStrictlyEquals("The minWidth of the Drawers was not calculated correctly based on the stage width.",
				this._drawers.stage.stageWidth, this._drawers.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Drawers was not calculated correctly based on the stage height.",
				this._drawers.stage.stageHeight, this._drawers.minHeight);
		}

		[Test]
		public function testAutoSizeContent():void
		{
			this.addContent();
			this._drawers.autoSizeMode = AutoSizeMode.CONTENT;
			this._drawers.validate();

			Assert.assertStrictlyEquals("The width of the Drawers was not calculated correctly based on the content width.",
				CONTENT_WIDTH, this._drawers.width);
			Assert.assertStrictlyEquals("The height of the Drawers was not calculated correctly based on the content height.",
				CONTENT_HEIGHT, this._drawers.height);
			Assert.assertStrictlyEquals("The minWidth of the Drawers was not calculated correctly based on the content minWidth.",
				CONTENT_MIN_WIDTH, this._drawers.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Drawers was not calculated correctly based on the content minHeight.",
				CONTENT_MIN_HEIGHT, this._drawers.minHeight);
		}

		[Test]
		public function testAutoSizeContentWithDrawersThatAreNotDocked():void
		{
			this.addContent();
			this.addTopDrawer();
			this.addRightDrawer();
			this.addBottomDrawer();
			this.addLeftDrawer();
			this._drawers.topDrawerDockMode = Orientation.NONE;
			this._drawers.rightDrawerDockMode = Orientation.NONE;
			this._drawers.bottomDrawerDockMode = Orientation.NONE;
			this._drawers.leftDrawerDockMode = Orientation.NONE;
			this._drawers.autoSizeMode = AutoSizeMode.CONTENT;
			this._drawers.validate();

			Assert.assertStrictlyEquals("The width of the Drawers was not calculated correctly based on the content width.",
				CONTENT_WIDTH, this._drawers.width);
			Assert.assertStrictlyEquals("The height of the Drawers was not calculated correctly based on the content height.",
				CONTENT_HEIGHT, this._drawers.height);
			Assert.assertStrictlyEquals("The minWidth of the Drawers was not calculated correctly based on the content width.",
				CONTENT_MIN_WIDTH, this._drawers.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Drawers was not calculated correctly based on the content height.",
				CONTENT_MIN_HEIGHT, this._drawers.minHeight);
		}

		[Test]
		public function testAutoSizeContentWithDockedLeftDrawer():void
		{
			this.addContent();
			this.addLeftDrawer();
			this._drawers.leftDrawerDockMode = Orientation.BOTH;
			this._drawers.autoSizeMode = AutoSizeMode.CONTENT;
			this._drawers.validate();

			Assert.assertStrictlyEquals("The width of the Drawers was not calculated correctly based on the content width plus docked left drawer width.",
				CONTENT_WIDTH + LEFT_DRAWER_WIDTH, this._drawers.width);
			Assert.assertStrictlyEquals("The height of the Drawers was not calculated correctly based on the maximum of content height and docked left drawer height.",
				LEFT_DRAWER_HEIGHT, this._drawers.height);
			Assert.assertStrictlyEquals("The minWidth of the Drawers was not calculated correctly based on the content minWidth plus docked left drawer minWidth.",
				CONTENT_MIN_WIDTH + LEFT_DRAWER_MIN_WIDTH, this._drawers.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Drawers was not calculated correctly based on the maximum of content minHeight and docked left drawer minHeight.",
				LEFT_DRAWER_MIN_HEIGHT, this._drawers.minHeight);
		}

		[Test]
		public function testAutoSizeContentWithDockedRightDrawer():void
		{
			this.addContent();
			this.addRightDrawer();
			this._drawers.rightDrawerDockMode = Orientation.BOTH;
			this._drawers.autoSizeMode = AutoSizeMode.CONTENT;
			this._drawers.validate();

			Assert.assertStrictlyEquals("The width of the Drawers was not calculated correctly based on the content width plus docked right drawer width.",
				CONTENT_WIDTH + RIGHT_DRAWER_WIDTH, this._drawers.width);
			Assert.assertStrictlyEquals("The height of the Drawers was not calculated correctly based on the maximum of content height and docked right drawer height.",
				RIGHT_DRAWER_HEIGHT, this._drawers.height);
			Assert.assertStrictlyEquals("The minWidth of the Drawers was not calculated correctly based on the content minWidth plus docked right drawer minWidth.",
				CONTENT_MIN_WIDTH + RIGHT_DRAWER_MIN_WIDTH, this._drawers.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Drawers was not calculated correctly based on the maximum of content minHeight and docked right drawer minHeight.",
				RIGHT_DRAWER_MIN_HEIGHT, this._drawers.minHeight);
		}

		[Test]
		public function testAutoSizeContentWithDockedTopDrawer():void
		{
			this.addContent();
			this.addTopDrawer();
			this._drawers.topDrawerDockMode = Orientation.BOTH;
			this._drawers.autoSizeMode = AutoSizeMode.CONTENT;
			this._drawers.validate();

			Assert.assertStrictlyEquals("The width of the Drawers was not calculated correctly based on the maximum of content width and docked top drawer width.",
				TOP_DRAWER_WIDTH, this._drawers.width);
			Assert.assertStrictlyEquals("The height of the Drawers was not calculated correctly based on the content height plus docked top drawer height.",
				CONTENT_HEIGHT + TOP_DRAWER_HEIGHT, this._drawers.height);
			Assert.assertStrictlyEquals("The minWidth of the Drawers was not calculated correctly based on the maximum of content minWidth and docked top drawer minWidth.",
				TOP_DRAWER_MIN_WIDTH, this._drawers.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Drawers was not calculated correctly based on the content minHeight plus docked top drawer minHeight.",
				CONTENT_MIN_HEIGHT + TOP_DRAWER_MIN_HEIGHT, this._drawers.minHeight);
		}

		[Test]
		public function testAutoSizeContentWithDockedBottomDrawer():void
		{
			this.addContent();
			this.addBottomDrawer();
			this._drawers.bottomDrawerDockMode = Orientation.BOTH;
			this._drawers.autoSizeMode = AutoSizeMode.CONTENT;
			this._drawers.validate();

			Assert.assertStrictlyEquals("The width of the Drawers was not calculated correctly based on the maximum of content width and docked bottom drawer width.",
				BOTTOM_DRAWER_WIDTH, this._drawers.width);
			Assert.assertStrictlyEquals("The height of the Drawers was not calculated correctly based on the content height plus docked bottom drawer height.",
				CONTENT_HEIGHT + BOTTOM_DRAWER_HEIGHT, this._drawers.height);
			Assert.assertStrictlyEquals("The minWidth of the Drawers was not calculated correctly based on the maximum of content minWidth and docked bottom drawer minWidth.",
				BOTTOM_DRAWER_MIN_WIDTH, this._drawers.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Drawers was not calculated correctly based on the content minHeight plus docked bottom drawer minHeight.",
				CONTENT_MIN_HEIGHT + BOTTOM_DRAWER_MIN_HEIGHT, this._drawers.minHeight);
		}

		[Test]
		public function testAutoSizeContentWithDockedTopAndBottomDrawer():void
		{
			this.addContent();
			this.addTopDrawer();
			this.addBottomDrawer();
			this._drawers.topDrawerDockMode = Orientation.BOTH;
			this._drawers.bottomDrawerDockMode = Orientation.BOTH;
			this._drawers.autoSizeMode = AutoSizeMode.CONTENT;
			this._drawers.validate();

			Assert.assertStrictlyEquals("The width of the Drawers was not calculated correctly based on the maximum of content width, docked top drawer width, and docked bottom drawer width.",
				TOP_DRAWER_WIDTH, this._drawers.width);
			Assert.assertStrictlyEquals("The height of the Drawers was not calculated correctly based on the content height plus docked top drawer height plus docked bottom drawer height.",
				CONTENT_HEIGHT + TOP_DRAWER_HEIGHT + BOTTOM_DRAWER_HEIGHT, this._drawers.height);
			Assert.assertStrictlyEquals("The minWidth of the Drawers was not calculated correctly based on the maximum of content minWidth, docked top drawer minWidth, and docked bottom drawer minWidth.",
				BOTTOM_DRAWER_MIN_WIDTH, this._drawers.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Drawers was not calculated correctly based on the content minHeight plus docked top drawer height plus docked bottom drawer minHeight.",
				CONTENT_MIN_HEIGHT + TOP_DRAWER_MIN_HEIGHT +BOTTOM_DRAWER_MIN_HEIGHT, this._drawers.minHeight);
		}

		[Test]
		public function testAutoSizeContentWithDockedLeftAndRightDrawer():void
		{
			this.addContent();
			this.addRightDrawer();
			this.addLeftDrawer();
			this._drawers.rightDrawerDockMode = Orientation.BOTH;
			this._drawers.leftDrawerDockMode = Orientation.BOTH;
			this._drawers.autoSizeMode = AutoSizeMode.CONTENT;
			this._drawers.validate();

			Assert.assertStrictlyEquals("The width of the Drawers was not calculated correctly based on the content width, plus docked left drawer width, plus docked right drawer width.",
				CONTENT_WIDTH + LEFT_DRAWER_WIDTH + RIGHT_DRAWER_WIDTH, this._drawers.width);
			Assert.assertStrictlyEquals("The height of the Drawers was not calculated correctly based on the maximum of content height, docked left drawer height, and docked right drawer height.",
				LEFT_DRAWER_HEIGHT, this._drawers.height);
			Assert.assertStrictlyEquals("The minWidth of the Drawers was not calculated correctly based on the content minWidth, plus docked left drawer minWidth, plus docked right drawer minWidth.",
				CONTENT_MIN_WIDTH + LEFT_DRAWER_MIN_WIDTH + RIGHT_DRAWER_MIN_WIDTH, this._drawers.minWidth);
			Assert.assertStrictlyEquals("The minHeight of the Drawers was not calculated correctly based on the maximum of content minHeight, docked left drawer height, and docked right drawer minHeight.",
				RIGHT_DRAWER_MIN_HEIGHT, this._drawers.minHeight);
		}
	}
}
