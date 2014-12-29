package feathers.examples.transitionsExplorer
{
	import feathers.controls.ImageLoader;
	import feathers.controls.LayoutGroup;
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.StackScreenNavigator;
	import feathers.controls.StackScreenNavigatorItem;
	import feathers.examples.transitionsExplorer.screens.AllTransitionsScreen;
	import feathers.examples.transitionsExplorer.screens.ColorFadeTransitionScreen;
	import feathers.examples.transitionsExplorer.screens.FadeTransitionScreen;
	import feathers.examples.transitionsExplorer.screens.FourWayTransitionScreen;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.motion.Cover;
	import feathers.motion.Cube;
	import feathers.motion.Flip;
	import feathers.motion.Reveal;
	import feathers.motion.Slide;
	import feathers.themes.MetalWorksMobileTheme;

	import starling.display.Quad;

	import starling.events.Event;
	import starling.textures.Texture;

	public class Main extends LayoutGroup
	{
		[Embed(source="/../assets/images/test-pattern1.png")]
		private static const TEST_PATTERN1:Class;

		[Embed(source="/../assets/images/test-pattern2.png")]
		private static const TEST_PATTERN2:Class;

		private static const MENU_SCREEN_ID_ALL_TRANSITIONS:String = "allTransitions";
		private static const MENU_SCREEN_ID_COLOR_FADE:String = "colorFade";
		private static const MENU_SCREEN_ID_COVER:String = "cover";
		private static const MENU_SCREEN_ID_CUBE:String = "cube";
		private static const MENU_SCREEN_ID_FADE:String = "fade";
		private static const MENU_SCREEN_ID_FLIP:String = "flip";
		private static const MENU_SCREEN_ID_REVEAL:String = "reveal";
		private static const MENU_SCREEN_ID_SLIDE:String = "slide";

		private static const CONTENT_SCREEN_ID_ONE:String = "one";
		private static const CONTENT_SCREEN_ID_TWO:String = "two";

		public function Main()
		{
			this.autoSizeMode = LayoutGroup.AUTO_SIZE_MODE_STAGE;
		}

		private var _menu:StackScreenNavigator;
		private var _content:ScreenNavigator;

		override protected function initialize():void
		{
			new MetalWorksMobileTheme();

			this.layout = new AnchorLayout();

			this._menu = new StackScreenNavigator();
			this._menu.autoSizeMode = StackScreenNavigator.AUTO_SIZE_MODE_CONTENT;
			var menuLayoutData:AnchorLayoutData = new AnchorLayoutData();
			menuLayoutData.top = 0;
			menuLayoutData.bottom = 0;
			menuLayoutData.left = 0;
			this._menu.width = this.stage.stageWidth / 3;
			this._menu.layoutData = new AnchorLayoutData(0, NaN, 0, 0);
			this._menu.clipContent = true;
			this.addChild(this._menu);

			var allTransitionsItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(AllTransitionsScreen);
			allTransitionsItem.setScreenIDForPushEvent(AllTransitionsScreen.COVER, MENU_SCREEN_ID_COVER);
			allTransitionsItem.setScreenIDForPushEvent(AllTransitionsScreen.CUBE, MENU_SCREEN_ID_CUBE);
			allTransitionsItem.setScreenIDForPushEvent(AllTransitionsScreen.FADE, MENU_SCREEN_ID_FADE);
			allTransitionsItem.setScreenIDForPushEvent(AllTransitionsScreen.COLOR_FADE, MENU_SCREEN_ID_COLOR_FADE);
			allTransitionsItem.setScreenIDForPushEvent(AllTransitionsScreen.FLIP, MENU_SCREEN_ID_FLIP);
			allTransitionsItem.setScreenIDForPushEvent(AllTransitionsScreen.REVEAL, MENU_SCREEN_ID_REVEAL);
			allTransitionsItem.setScreenIDForPushEvent(AllTransitionsScreen.SLIDE, MENU_SCREEN_ID_SLIDE);
			this._menu.addScreen(MENU_SCREEN_ID_ALL_TRANSITIONS, allTransitionsItem);

			var colorFadeItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(ColorFadeTransitionScreen);
			colorFadeItem.setFunctionForPushEvent(FourWayTransitionScreen.TRANSITION, transitionHandler);
			colorFadeItem.addPopEvent(Event.COMPLETE);
			this._menu.addScreen(MENU_SCREEN_ID_COLOR_FADE, colorFadeItem);

			var coverItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(FourWayTransitionScreen);
			coverItem.properties.transitionName = "Cover";
			coverItem.properties.leftTransition = Cover.createCoverLeftTransition();
			coverItem.properties.rightTransition = Cover.createCoverRightTransition();
			coverItem.properties.upTransition = Cover.createCoverUpTransition();
			coverItem.properties.downTransition = Cover.createCoverDownTransition();
			coverItem.setFunctionForPushEvent(FourWayTransitionScreen.TRANSITION, transitionHandler);
			coverItem.addPopEvent(Event.COMPLETE);
			this._menu.addScreen(MENU_SCREEN_ID_COVER, coverItem);

			var cubeItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(FourWayTransitionScreen);
			cubeItem.properties.transitionName = "Cube";
			cubeItem.properties.leftTransition = Cube.createCubeLeftTransition();
			cubeItem.properties.rightTransition = Cube.createCubeRightTransition();
			cubeItem.properties.upTransition = Cube.createCubeUpTransition();
			cubeItem.properties.downTransition = Cube.createCubeDownTransition();
			cubeItem.setFunctionForPushEvent(FourWayTransitionScreen.TRANSITION, transitionHandler);
			cubeItem.addPopEvent(Event.COMPLETE);
			this._menu.addScreen(MENU_SCREEN_ID_CUBE, cubeItem);

			var fadeItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(FadeTransitionScreen);
			fadeItem.setFunctionForPushEvent(FourWayTransitionScreen.TRANSITION, transitionHandler);
			fadeItem.addPopEvent(Event.COMPLETE);
			this._menu.addScreen(MENU_SCREEN_ID_FADE, fadeItem);

			var flipItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(FourWayTransitionScreen);
			flipItem.properties.transitionName = "Flip";
			flipItem.properties.leftTransition = Flip.createFlipLeftTransition();
			flipItem.properties.rightTransition = Flip.createFlipRightTransition();
			flipItem.properties.upTransition = Flip.createFlipUpTransition();
			flipItem.properties.downTransition = Flip.createFlipDownTransition();
			flipItem.setFunctionForPushEvent(FourWayTransitionScreen.TRANSITION, transitionHandler);
			flipItem.addPopEvent(Event.COMPLETE);
			this._menu.addScreen(MENU_SCREEN_ID_FLIP, flipItem);

			var revealItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(FourWayTransitionScreen);
			revealItem.properties.transitionName = "Reveal";
			revealItem.properties.leftTransition = Reveal.createRevealLeftTransition();
			revealItem.properties.rightTransition = Reveal.createRevealRightTransition();
			revealItem.properties.upTransition = Reveal.createRevealUpTransition();
			revealItem.properties.downTransition = Reveal.createRevealDownTransition();
			revealItem.setFunctionForPushEvent(FourWayTransitionScreen.TRANSITION, transitionHandler);
			revealItem.addPopEvent(Event.COMPLETE);
			this._menu.addScreen(MENU_SCREEN_ID_REVEAL, revealItem);

			var slideItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(FourWayTransitionScreen);
			slideItem.properties.transitionName = "Slide";
			slideItem.properties.leftTransition = Slide.createSlideLeftTransition();
			slideItem.properties.rightTransition = Slide.createSlideRightTransition();
			slideItem.properties.upTransition = Slide.createSlideUpTransition();
			slideItem.properties.downTransition = Slide.createSlideDownTransition();
			slideItem.setFunctionForPushEvent(FourWayTransitionScreen.TRANSITION, transitionHandler);
			slideItem.addPopEvent(Event.COMPLETE);
			this._menu.addScreen(MENU_SCREEN_ID_SLIDE, slideItem);

			this._menu.pushScreen(MENU_SCREEN_ID_ALL_TRANSITIONS);

			this._menu.pushTransition = Slide.createSlideLeftTransition();
			this._menu.popTransition = Slide.createSlideRightTransition();

			this._content = new ScreenNavigator();
			var contentLayoutData:AnchorLayoutData = new AnchorLayoutData(0, 0, 0, 0);
			contentLayoutData.leftAnchorDisplayObject = this._menu;
			this._content.layoutData = contentLayoutData;
			this.addChildAt(this._content, 0);

			var content1:LayoutGroup = new LayoutGroup();
			content1.layout = new AnchorLayout();
			var image:ImageLoader = new ImageLoader();
			image.source = Texture.fromEmbeddedAsset(TEST_PATTERN1, false);
			image.layoutData = new AnchorLayoutData(0, 0, 0, 0);
			content1.addChild(image);
			content1.backgroundSkin = new Quad(1, 1, 0x000000);
			this._content.addScreen(CONTENT_SCREEN_ID_ONE, new ScreenNavigatorItem(content1));
			var content2:LayoutGroup = new LayoutGroup();
			content2.layout = new AnchorLayout();
			image = new ImageLoader();
			image.source = Texture.fromEmbeddedAsset(TEST_PATTERN2, false);
			image.layoutData = new AnchorLayoutData(0, 0, 0, 0);
			content2.addChild(image);
			content2.backgroundSkin = new Quad(1, 1, 0xffffff);
			this._content.addScreen(CONTENT_SCREEN_ID_TWO, new ScreenNavigatorItem(content2));

			this._content.showScreen(CONTENT_SCREEN_ID_ONE);

			//we're not setting the transition on the content screen navigator
			//because the screens will select their own transitions.
		}

		private function getNextScreenID():String
		{
			if(this._content.activeScreenID == CONTENT_SCREEN_ID_ONE)
			{
				return CONTENT_SCREEN_ID_TWO;
			}
			return CONTENT_SCREEN_ID_ONE;
		}

		private function transitionHandler(event:Event, transition:Function):void
		{
			this._content.showScreen(this.getNextScreenID(), transition);
		}
	}
}
