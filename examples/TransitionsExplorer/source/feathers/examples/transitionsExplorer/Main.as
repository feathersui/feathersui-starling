package feathers.examples.transitionsExplorer
{
	import feathers.controls.ImageLoader;
	import feathers.controls.LayoutGroup;
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.examples.transitionsExplorer.screens.AllTransitionsScreen;
	import feathers.examples.transitionsExplorer.screens.FourWayTransitionScreen;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.motion.transitions.ColorFade;
	import feathers.motion.transitions.Cover;
	import feathers.motion.transitions.Crossfade;
	import feathers.motion.transitions.Cube;
	import feathers.motion.transitions.Flip;
	import feathers.motion.transitions.Reveal;
	import feathers.motion.transitions.Slide;
	import feathers.themes.MetalWorksMobileTheme;

	import starling.events.Event;
	import starling.textures.Texture;

	public class Main extends LayoutGroup
	{
		[Embed(source="/../assets/images/test-pattern1.png")]
		private static const TEST_PATTERN1:Class;

		[Embed(source="/../assets/images/test-pattern2.png")]
		private static const TEST_PATTERN2:Class;

		private static const MENU_SCREEN_ID_ALL_TRANSITIONS:String = "allTransitions";
		private static const MENU_SCREEN_ID_COVER:String = "cover";
		private static const MENU_SCREEN_ID_CUBE:String = "cube";
		private static const MENU_SCREEN_ID_FLIP:String = "flip";
		private static const MENU_SCREEN_ID_REVEAL:String = "reveal";
		private static const MENU_SCREEN_ID_SLIDE:String = "slide";

		private static const CONTENT_SCREEN_ID_ONE:String = "one";
		private static const CONTENT_SCREEN_ID_TWO:String = "two";

		public function Main()
		{
			this.autoSizeMode = LayoutGroup.AUTO_SIZE_MODE_STAGE;
		}

		private var _menu:ScreenNavigator;
		private var _content:ScreenNavigator;

		override protected function initialize():void
		{
			new MetalWorksMobileTheme();

			this.layout = new AnchorLayout();

			this._menu = new ScreenNavigator();
			this._menu.autoSizeMode = ScreenNavigator.AUTO_SIZE_MODE_CONTENT;
			var menuLayoutData:AnchorLayoutData = new AnchorLayoutData();
			menuLayoutData.top = 0;
			menuLayoutData.bottom = 0;
			menuLayoutData.left = 0;
			this._menu.width = this.stage.stageWidth / 3;
			this._menu.layoutData = new AnchorLayoutData(0, NaN, 0, 0);
			this.addChild(this._menu);

			var allTransitionsItem:ScreenNavigatorItem = new ScreenNavigatorItem(AllTransitionsScreen);
			allTransitionsItem.setFunctionForEvent(AllTransitionsScreen.COLOR_FADE, colorFadeHandler);
			allTransitionsItem.setFunctionForEvent(AllTransitionsScreen.CROSSFADE, crossfadeHandler);
			allTransitionsItem.setScreenIDForEvent(AllTransitionsScreen.COVER, MENU_SCREEN_ID_COVER);
			allTransitionsItem.setScreenIDForEvent(AllTransitionsScreen.CUBE, MENU_SCREEN_ID_CUBE);
			allTransitionsItem.setScreenIDForEvent(AllTransitionsScreen.FLIP, MENU_SCREEN_ID_FLIP);
			allTransitionsItem.setScreenIDForEvent(AllTransitionsScreen.REVEAL, MENU_SCREEN_ID_REVEAL);
			allTransitionsItem.setScreenIDForEvent(AllTransitionsScreen.SLIDE, MENU_SCREEN_ID_SLIDE);
			this._menu.addScreen(MENU_SCREEN_ID_ALL_TRANSITIONS, allTransitionsItem);

			var coverItem:ScreenNavigatorItem = new ScreenNavigatorItem(FourWayTransitionScreen);
			coverItem.properties.transitionName = "Cover";
			coverItem.properties.leftTransition = Cover.createCoverLeftTransition();
			coverItem.properties.rightTransition = Cover.createCoverRightTransition();
			coverItem.properties.upTransition = Cover.createCoverUpTransition();
			coverItem.properties.downTransition = Cover.createCoverDownTransition();
			coverItem.setFunctionForEvent(FourWayTransitionScreen.TRANSITION, transitionHandler);
			coverItem.setScreenIDForEvent(Event.COMPLETE, MENU_SCREEN_ID_ALL_TRANSITIONS);
			this._menu.addScreen(MENU_SCREEN_ID_COVER, coverItem);

			var cubeItem:ScreenNavigatorItem = new ScreenNavigatorItem(FourWayTransitionScreen);
			cubeItem.properties.transitionName = "Cube";
			cubeItem.properties.leftTransition = Cube.createCubeLeftTransition();
			cubeItem.properties.rightTransition = Cube.createCubeRightTransition();
			cubeItem.properties.upTransition = Cube.createCubeUpTransition();
			cubeItem.properties.downTransition = Cube.createCubeDownTransition();
			cubeItem.setFunctionForEvent(FourWayTransitionScreen.TRANSITION, transitionHandler);
			cubeItem.setScreenIDForEvent(Event.COMPLETE, MENU_SCREEN_ID_ALL_TRANSITIONS);
			this._menu.addScreen(MENU_SCREEN_ID_CUBE, cubeItem);

			var flipItem:ScreenNavigatorItem = new ScreenNavigatorItem(FourWayTransitionScreen);
			flipItem.properties.transitionName = "Flip";
			flipItem.properties.leftTransition = Flip.createFlipLeftTransition();
			flipItem.properties.rightTransition = Flip.createFlipRightTransition();
			flipItem.properties.upTransition = Flip.createFlipUpTransition();
			flipItem.properties.downTransition = Flip.createFlipDownTransition();
			flipItem.setFunctionForEvent(FourWayTransitionScreen.TRANSITION, transitionHandler);
			flipItem.setScreenIDForEvent(Event.COMPLETE, MENU_SCREEN_ID_ALL_TRANSITIONS);
			this._menu.addScreen(MENU_SCREEN_ID_FLIP, flipItem);

			var revealItem:ScreenNavigatorItem = new ScreenNavigatorItem(FourWayTransitionScreen);
			revealItem.properties.transitionName = "Reveal";
			revealItem.properties.leftTransition = Reveal.createRevealLeftTransition();
			revealItem.properties.rightTransition = Reveal.createRevealRightTransition();
			revealItem.properties.upTransition = Reveal.createRevealUpTransition();
			revealItem.properties.downTransition = Reveal.createRevealDownTransition();
			revealItem.setFunctionForEvent(FourWayTransitionScreen.TRANSITION, transitionHandler);
			revealItem.setScreenIDForEvent(Event.COMPLETE, MENU_SCREEN_ID_ALL_TRANSITIONS);
			this._menu.addScreen(MENU_SCREEN_ID_REVEAL, revealItem);

			var slideItem:ScreenNavigatorItem = new ScreenNavigatorItem(FourWayTransitionScreen);
			slideItem.properties.transitionName = "Slide";
			slideItem.properties.leftTransition = Slide.createSlideLeftTransition();
			slideItem.properties.rightTransition = Slide.createSlideRightTransition();
			slideItem.properties.upTransition = Slide.createSlideUpTransition();
			slideItem.properties.downTransition = Slide.createSlideDownTransition();
			slideItem.setFunctionForEvent(FourWayTransitionScreen.TRANSITION, transitionHandler);
			slideItem.setScreenIDForEvent(Event.COMPLETE, MENU_SCREEN_ID_ALL_TRANSITIONS);
			this._menu.addScreen(MENU_SCREEN_ID_SLIDE, slideItem);

			this._menu.showScreen(MENU_SCREEN_ID_ALL_TRANSITIONS);

			this._content = new ScreenNavigator();
			var contentLayoutData:AnchorLayoutData = new AnchorLayoutData(0, 0, 0, 0);
			contentLayoutData.leftAnchorDisplayObject = this._menu;
			this._content.layoutData = contentLayoutData;
			this.addChildAt(this._content, 0);

			var content1:ImageLoader = new ImageLoader();
			content1.source = Texture.fromEmbeddedAsset(TEST_PATTERN1, false);
			this._content.addScreen(CONTENT_SCREEN_ID_ONE, new ScreenNavigatorItem(content1));
			var content2:ImageLoader = new ImageLoader();
			content2.source = Texture.fromEmbeddedAsset(TEST_PATTERN2, false);
			this._content.addScreen(CONTENT_SCREEN_ID_TWO, new ScreenNavigatorItem(content2));

			this._content.showScreen(CONTENT_SCREEN_ID_ONE);
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

		private function colorFadeHandler(event:Event):void
		{
			this._content.showScreen(this.getNextScreenID(), ColorFade.createColorFadeTransition());
		}

		private function crossfadeHandler(event:Event):void
		{
			this._content.showScreen(this.getNextScreenID(), Crossfade.createCrossfadeTransition());
		}


	}
}
