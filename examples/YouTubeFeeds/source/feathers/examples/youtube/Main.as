package feathers.examples.youtube
{
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.StackScreenNavigator;
	import feathers.controls.StackScreenNavigatorItem;
	import feathers.examples.youtube.models.VideoDetails;
	import feathers.examples.youtube.models.VideoFeed;
	import feathers.examples.youtube.models.YouTubeModel;
	import feathers.examples.youtube.screens.ListVideosScreen;
	import feathers.examples.youtube.screens.MainMenuScreen;
	import feathers.examples.youtube.screens.VideoDetailsScreen;
	import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
	import feathers.motion.transitions.Slide;
	import feathers.themes.MetalWorksMobileTheme;

	import starling.events.Event;

	public class Main extends StackScreenNavigator
	{
		private static const MAIN_MENU:String = "mainMenu";
		private static const LIST_VIDEOS:String = "listVideos";
		private static const VIDEO_DETAILS:String = "videoDetails";

		public function Main()
		{
			super();
		}

		private var _model:YouTubeModel;

		override protected function initialize():void
		{
			//never forget to call super.initialize()
			super.initialize();

			new MetalWorksMobileTheme();

			this._model = new YouTubeModel();

			this.addScreen(MAIN_MENU, new StackScreenNavigatorItem(MainMenuScreen,
			{
				listVideos: mainMenuScreen_listVideosHandler
			}));

			this.addScreen(LIST_VIDEOS, new StackScreenNavigatorItem(ListVideosScreen,
			{
				showVideoDetails: listVideos_showVideoDetails
			}, Event.COMPLETE,
			{
				model: this._model
			}));

			this.addScreen(VIDEO_DETAILS, new StackScreenNavigatorItem(VideoDetailsScreen,
				null, Event.COMPLETE,
			{
				model: this._model
			}));

			this.pushScreen(MAIN_MENU);

			this.pushTransition = Slide.createSlideLeftTransition();
			this.popTransition = Slide.createSlideRightTransition();
		}

		private function mainMenuScreen_listVideosHandler(event:Event, data:Object):void
		{
			var screen:MainMenuScreen = MainMenuScreen(this.activeScreen);
			this._model.selectedList = screen.selectedCategory;
			this.pushScreen(LIST_VIDEOS, data);
		}

		private function listVideos_showVideoDetails(event:Event, data:Object):void
		{
			var screen:ListVideosScreen = ListVideosScreen(this.activeScreen);
			this._model.selectedVideo = screen.selectedVideo;
			this.pushScreen(VIDEO_DETAILS, data);
		}
	}
}
