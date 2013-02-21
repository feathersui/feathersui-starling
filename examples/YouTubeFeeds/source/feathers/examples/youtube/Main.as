package feathers.examples.youtube
{
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.examples.youtube.models.VideoDetails;
	import feathers.examples.youtube.models.VideoFeed;
	import feathers.examples.youtube.models.YouTubeModel;
	import feathers.examples.youtube.screens.ListVideosScreen;
	import feathers.examples.youtube.screens.MainMenuScreen;
	import feathers.examples.youtube.screens.VideoDetailsScreen;
	import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
	import feathers.themes.MetalWorksMobileTheme;

	import starling.display.Sprite;
	import starling.events.Event;

	public class Main extends Sprite
	{
		private static const MAIN_MENU:String = "mainMenu";
		private static const LIST_VIDEOS:String = "listVideos";
		private static const VIDEO_DETAILS:String = "videoDetails";

		public function Main()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}

		private var _theme:MetalWorksMobileTheme;
		private var _navigator:ScreenNavigator;
		private var _transitionManager:ScreenSlidingStackTransitionManager;
		private var _model:YouTubeModel;

		private function addedToStageHandler(event:Event):void
		{
			this._theme = new MetalWorksMobileTheme();

			this._model = new YouTubeModel();

			this._navigator = new ScreenNavigator();
			this.addChild(this._navigator);

			this._navigator.addScreen(MAIN_MENU, new ScreenNavigatorItem(MainMenuScreen,
			{
				listVideos: mainMenuScreen_listVideosHandler
			}));

			this._navigator.addScreen(LIST_VIDEOS, new ScreenNavigatorItem(ListVideosScreen,
			{
				complete: MAIN_MENU,
				showVideoDetails: listVideos_showVideoDetails
			},
			{
				model: this._model
			}));

			this._navigator.addScreen(VIDEO_DETAILS, new ScreenNavigatorItem(VideoDetailsScreen,
			{
				complete: LIST_VIDEOS
			},
			{
				model: this._model
			}));

			this._navigator.showScreen(MAIN_MENU);

			this._transitionManager = new ScreenSlidingStackTransitionManager(this._navigator);
			this._transitionManager.duration = 0.4;
		}

		private function mainMenuScreen_listVideosHandler(event:Event, selectedItem:VideoFeed):void
		{
			this._model.selectedList = selectedItem;
			this._navigator.showScreen(LIST_VIDEOS);
		}

		private function listVideos_showVideoDetails(event:Event, selectedItem:VideoDetails):void
		{
			this._model.selectedVideo = selectedItem;
			this._navigator.showScreen(VIDEO_DETAILS);
		}
	}
}
