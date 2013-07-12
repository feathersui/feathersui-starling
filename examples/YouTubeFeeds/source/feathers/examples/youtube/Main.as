package feathers.examples.youtube
{
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.events.FeathersEventType;
	import feathers.examples.youtube.models.VideoDetails;
	import feathers.examples.youtube.models.VideoFeed;
	import feathers.examples.youtube.models.YouTubeModel;
	import feathers.examples.youtube.screens.ListVideosScreen;
	import feathers.examples.youtube.screens.MainMenuScreen;
	import feathers.examples.youtube.screens.VideoDetailsScreen;
	import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
	import feathers.themes.MetalWorksMobileTheme;

	import starling.events.Event;

	public class Main extends ScreenNavigator
	{
		private static const MAIN_MENU:String = "mainMenu";
		private static const LIST_VIDEOS:String = "listVideos";
		private static const VIDEO_DETAILS:String = "videoDetails";

		public function Main()
		{
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}

		private var _transitionManager:ScreenSlidingStackTransitionManager;
		private var _model:YouTubeModel;

		private function initializeHandler(event:Event):void
		{
			new MetalWorksMobileTheme();

			this._model = new YouTubeModel();

			this.addScreen(MAIN_MENU, new ScreenNavigatorItem(MainMenuScreen,
			{
				listVideos: mainMenuScreen_listVideosHandler
			}));

			this.addScreen(LIST_VIDEOS, new ScreenNavigatorItem(ListVideosScreen,
			{
				complete: MAIN_MENU,
				showVideoDetails: listVideos_showVideoDetails
			},
			{
				model: this._model
			}));

			this.addScreen(VIDEO_DETAILS, new ScreenNavigatorItem(VideoDetailsScreen,
			{
				complete: LIST_VIDEOS
			},
			{
				model: this._model
			}));

			this.showScreen(MAIN_MENU);

			this._transitionManager = new ScreenSlidingStackTransitionManager(this);
			this._transitionManager.duration = 0.4;
		}

		private function mainMenuScreen_listVideosHandler(event:Event, selectedItem:VideoFeed):void
		{
			this._model.selectedList = selectedItem;
			this.showScreen(LIST_VIDEOS);
		}

		private function listVideos_showVideoDetails(event:Event, selectedItem:VideoDetails):void
		{
			this._model.selectedVideo = selectedItem;
			this.showScreen(VIDEO_DETAILS);
		}
	}
}
